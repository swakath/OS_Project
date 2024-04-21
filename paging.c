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

