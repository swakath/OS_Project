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

struct rmap_ds rmap[2^32];  //index corresponds to vrtual address;

void initrmap()
{
    for(uint i=0;i<2^20;i++)
    {
        rmap[i].virtual_addr=-1;
        rmap[i].process_indexes=0;
    }
}

void pagingintr(){
    // cprintf("Page Swap INTERRUPT HANDLER");
    // Accesing the process that caused pagefault
    struct proc* curproc=myproc();
    // 
    uint pfa=rcr2();
    pte_t* pte=walkpgdir(curproc->pgdir, (void *)pfa,0 );
    if(((uint)(*pte)&PTE_P))
    {
        uint pa=PTE_ADDR(*pte);

    }
    // else{
    // swap_in();
    // }
    return;
}

