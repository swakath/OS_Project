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


// struct rmap_ds rmap[2^20];  //index corresponds to physical  address;

// void initrmap()
// {
//     for(uint i=0;i<2^20;i++)
//     {
//         rmap[i].virtual_addr=-1;
//         rmap[i].process_indexes=0;
//     }
// }

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
    return;
}

void free_swap(struct proc* p)
{
  for(int i=0;i<SSIZE;i++)
  {
    if(slot_array[i].pid==p->pid && slot_array[i].is_free==0)
    {
      slot_array[i].is_free=1;
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
    slot_array[sbn/8].is_free=1;
    for(int i=0;i<8;i++)
    {
        struct buf* b=bread(ROOTDEV,sbn+i);
        memmove(pa,b->data,512);
        brelse(b);
        pa+=512;
    }
}

void
swap_in(){
    struct proc* curproc=myproc();
    uint pfa=rcr2();
    pte_t* pte=walkpgdir(curproc->pgdir, (void *)pfa,0 );
    uint sbn=(*pte)>>PTXSHIFT;
    // cprintf("page fault virtual address: %p and physical address %p\n",pfa,(*pte));
    char* pa=kalloc();
    // cprintf("Helloooooooooooooooooooooooooo..............\n");
    uint pg=(V2P((uint)pa))&(~0xfff);
    (*pte)=((uint)(pg)|slot_array[sbn/8].page_perm);
    read_from_swap(sbn, pa);
    slot_array[sbn/8].pid=curproc->pid;
    curproc->rss+=4096;
    // cprintf("process id thats page swapped in: %d and  page table entry %p \n",curproc->pid,(*pte));
}

void
swap_out(){
    struct proc* p=find_victim_process();
    pte_t *pg;
    pg=find_victim_page(p);

    // cprintf("\nDebug Victim IPD [%d], Page [%p]\n", p->pid, *pg);
    // cprintf("\n  Debug Victim IPD [%d], Page [%p]\n", p->pid, pg);
    while((uint)pg==0)
    {
        // cprintf("Hello i am going to unaccessed some pages.\n");
        make_unaccessed_page(p);
        pg=find_victim_page(p);
    }
    char* pa=(char*)(P2V((*pg)&(~0xFFF)));    
    // cprintf("   victim page %p:\n",pa);
    uint sbn= write_to_swap(pa);
    slot_array[sbn/8].page_perm=((*pg)&(0xFFF));
    (*pg)=((sbn<<PTXSHIFT)&(~0xfff));
    kfree(pa);
    // cprintf("\n  Debug Victim IPD [%d], Page [%p]\n", p->pid, *pg);
    p->rss-=4096;
    // cprintf("  process id thats page swapped out: %d \n",p->pid);
} 