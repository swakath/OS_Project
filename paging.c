#include "types.h"
#include "defs.h"
#include "param.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "buf.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "memlayout.h"

struct slotinfo slot_array[SSIZE];
uint swap_start;

void initpageswap(uint sbstart){
    swap_start=sbstart;
    for(uint i=0;i<SSIZE;i++)
    {
        slot_array[i].is_free=1;
    }
}

void pagingintr(){
    cprintf("Debug: Pageing Intrupt Handler \n");
    struct proc *curproc;
    uint pfa, pa, flags;
    pte_t *pte;
    char *mem;
    // Accesing the process that caused pagefault
    curproc=myproc();
    // Accessing the page addr that caused the pagefault 
    pfa=rcr2();
    // Accessing the page table entry of the fault page.
    pte=walkpgdir(curproc->pgdir, (void *)pfa,0);
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);

    // Checking is pagefault due to COW
    if((flags & PTE_P))
    {
      if((mem = kalloc()) == 0)
        panic("memory is not available for page copy");
      memmove(mem, (char*)P2V(pa), PGSIZE);
      flags|=PTE_W;
      *pte= PTE_ADDR((uint)V2P(mem)) | flags;
      kfree(P2V(pa));
    }
    else{
      swap_in();
    }
    return;
}

void free_swap(struct proc* p)
{
//   cprintf("Inside free swap %d:\n",p->pid);
  uint pindx = find_proc_index(p);
  long long mask = 1<<pindx;
//   cprintf("freed pid %d:\n",p->pid);
  for(int i=0;i<SSIZE;i++)
  {
    if(((slot_array[i].pindex & mask) == mask) && (slot_array[i].is_free==0))
    {
      slot_array[i].pindex = (slot_array[i].pindex & (~mask));
      slot_array[i].ref_count--;
      if(slot_array[i].ref_count <= 0){
        slot_array[i].ref_count = 0;
        slot_array[i].is_free = 1;
      }
    }
  }
}
uint write_to_swap(char* vpa)
{
   uint slot_ind=0;
   for(slot_ind=0;slot_ind<SSIZE;slot_ind++)
   {
      if(slot_array[slot_ind].is_free)
      {
        slot_array[slot_ind].is_free=0;
        break;
      }
   }
   if(slot_ind==SSIZE) slot_ind--;
   uint block_num=swap_start+slot_ind*8;
   for(int i=0;i<8;i++)
   {
        struct buf* b=bread(ROOTDEV,block_num+i);
        memmove(b->data,vpa,512);
        b->blockno=block_num+i;
        b->flags|=B_DIRTY;
        b->dev=ROOTDEV;
        bwrite(b);
        brelse(b);
        vpa=vpa+512;
   } 
   return swap_start+slot_ind*8;
}

void read_from_swap(uint sbn, char* pa)
{
    for(int i=0;i<8;i++)
    {
        struct buf* b=bread(ROOTDEV,sbn+i);
        memmove(pa,b->data,512);
        brelse(b);
        pa+=512;
    }
    slot_array[sbn/8].is_free=1;
}

void
swap_in(){
    long long pindxs;
    uint pfa, flags, ref_cnt, sbn, pgaddr;
    char* pa;
    pte_t* pte;
    struct proc* curproc;

    curproc=myproc();
    
    pfa=rcr2();
    pte=walkpgdir(curproc->pgdir, (void *)pfa,0);
    sbn=(*pte)>>PTXSHIFT;
    pa = kalloc();
    pgaddr = (V2P(pa)&(~0xFFF));
    
    flags = slot_array[sbn/8].page_perm;
    ref_cnt = slot_array[sbn/8].ref_count;
    pindxs = slot_array[sbn/8].pindex;
    read_from_swap(sbn, pa);

    swap_in_update_pte_for_pindex(pindxs, pfa, pgaddr, flags);
    set_pindex_value(pgaddr, pindxs);
    set_rmap(pgaddr,ref_cnt);

    // Updating 
    // cprintf("process id thats page swapped in: %d and  page table entry %p \n",curproc->pid,(*pte));
}

void
swap_out(){
    struct proc* p;
    struct pageinfo pg;
    pte_t* pte;
    uint vaddr;
    uint pa, flags;
    char* vpa; 
    long long pindxs;
    
    p = find_victim_process();
    pg = find_victim_page(p);

    // cprintf("\nDebug Victim IPD [%d], Page [%p]\n", p->pid, *pg);
    // cprintf("\n  Debug Victim IPD [%d], Page [%p]\n", p->pid, pg);
    while(pg.pte == 0)
    {
        // cprintf("Hello i am going to unaccessed some pages.\n");
        make_unaccessed_page(p);
        pg=find_victim_page(p);
    }

    pte = pg.pte;
    vaddr = pg.vaddr;
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    vpa=(char*)(P2V(pa));    
    
    // cprintf("   victim page %p:\n",pa);
    uint sbn = write_to_swap(vpa);
    pindxs = get_pindex_value(*pte);
    slot_array[sbn/8].page_perm = flags;
    slot_array[sbn/8].pindex = pindxs;
    slot_array[sbn/8].ref_count = get_rmap(pa);

    swap_out_update_pte_for_pindex(pindxs, vaddr, sbn);
    (*pte)=((sbn<<PTXSHIFT)&(~0xfff));
    set_pindex_value(pa, 0);
    set_rmap(pa,1);
    kfree(vpa);
    // cprintf("\n  Debug Victim IPD [%d], Page [%p]\n", p->pid, *pg);
    //p->rss-=4096;
    // cprintf("  process id thats page swapped out: %d \n",p->pid);
} 


void swap_out_update_pte_for_pindex(long long pindx, uint vaddr, uint sbn){
  long long mask=1;
  struct proc* curProc;
  pte_t* curPte;
  for(int indx = 0; indx < 64; ++indx){
    if((pindx & (mask<<indx))){
      curProc = find_proc_from_index(indx);
      curPte = walkpgdir(curProc->pgdir, (void *)vaddr,0);
      (*curPte) = ((sbn<<PTXSHIFT)&(~0xFFF));
      curProc->rss-=4096;
    }
  } 
}

void swap_in_update_pte_for_pindex(long long pindx, uint vaddr, uint pg, uint flags){
  long long mask=1;
  struct proc* curProc;
  pte_t* curPte;
  for(int indx = 0; indx < 64; ++indx){
    if((pindx & (mask<<indx))){
      curProc = find_proc_from_index(indx);
      curPte = walkpgdir(curProc->pgdir, (void *)vaddr,0);
      (*curPte) = pg | flags | PTE_P;
      curProc->rss+=4096;
    }
  }
}