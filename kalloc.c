// Physical memory allocator, intended to allocate
// memory for user processes, kernel stacks, page table pages,
// and pipe buffers. Allocates 4096-byte pages.

#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "spinlock.h"


struct{
  int use_lock;
  struct spinlock lock;
  int ref_count[PHYSTOP/PGSIZE];
  long long process_idxs[PHYSTOP/PGSIZE];
}rmap;

void initrmap(){
  if(rmap.use_lock)
    acquire(&rmap.lock);
  for(int ind = 0; ind< (PHYSTOP/PGSIZE);++ind){
    rmap.ref_count[ind] = 0;
    rmap.process_idxs[ind] = 0;
  }
  if(rmap.use_lock)
    release(&rmap.lock);
}

int 
get_rmap(uint pa)
{ 
  int rmap_index;
  if(rmap.use_lock)
    acquire(&rmap.lock);
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
  int value=rmap.ref_count[rmap_index];
  if(rmap.use_lock)
    release(&rmap.lock);
  return value;
}
void 
set_rmap(uint pa,int value)
{
  int rmap_index;
  if(rmap.use_lock)
    acquire(&rmap.lock);
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
  rmap.ref_count[rmap_index]=value;
  if(rmap.use_lock)
    release(&rmap.lock);
}
void 
inc_rmap(uint pa)
{
  int rmap_index;
  if(rmap.use_lock)
    acquire(&rmap.lock);
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
  rmap.ref_count[rmap_index]++;
  if(rmap.use_lock)
    release(&rmap.lock);
}
void 
dec_rmap(uint pa)
{
  int rmap_index;
  if(rmap.use_lock)
    acquire(&rmap.lock);
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
  rmap.ref_count[rmap_index]--;
  if(rmap.ref_count[rmap_index] < 0)
    rmap.ref_count[rmap_index] = 0;
  if(rmap.use_lock)
    release(&rmap.lock);
}

int get_pindex_status(uint pa, uint p_index)
{
  int rmap_index, pindex_status=0;
  long long val=1;
  if(p_index>=64 || p_index<0)
    panic("wrong pindex in get_pindex_status");
  if(rmap.use_lock)
    acquire(&rmap.lock);
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
  if((rmap.process_idxs[rmap_index])&(val<<p_index))
    pindex_status=1;
  if(rmap.use_lock)
    release(&rmap.lock);
  return pindex_status;
}

long long get_pindex_value(uint pa){
  uint rmap_index;
  long long process_idxs;
  if(rmap.use_lock)
    acquire(&rmap.lock);
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
  process_idxs=rmap.process_idxs[rmap_index];
  if(rmap.use_lock)
    release(&rmap.lock);
  return process_idxs;
}

void set_pindex_value(uint pa, long long process_idxs){
  uint rmap_index;
  if(rmap.use_lock)
    acquire(&rmap.lock);
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
  rmap.process_idxs[rmap_index] = process_idxs;
  if(rmap.use_lock)
    release(&rmap.lock);
}

void set_pindex_status(uint pa, uint p_index,uint pindex_status)
{
  int rmap_index;
  long long  val=1;
  if(p_index>=64 || p_index<0)
    panic("wrong pindex in set_pindex_status");

  if(rmap.use_lock)
    acquire(&rmap.lock);
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
  if(pindex_status)
  {
    rmap.process_idxs[rmap_index] |=(val<<p_index);
  }
  else{
    rmap.process_idxs[rmap_index] &=(~(val<<p_index));
  }
  if(rmap.use_lock)
    release(&rmap.lock);
}

void freerange(void *vstart, void *vend);
extern char end[]; // first address after kernel loaded from ELF file
                   // defined by the kernel linker script in kernel.ld

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  int use_lock;
  uint num_free_pages;  //store number of free pages
  struct run *freelist;
} kmem;

// Initialization happens in two phases.
// 1. main() calls kinit1() while still using entrypgdir to place just
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  rmap.use_lock=0;
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
  rmap.use_lock=1;
}

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
  {
    kfree(p);
    // kmem.num_free_pages+=1;
  }
    
}
//PAGEBREAK: 21
// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
  struct run *r;
  // cprintf(" page address %p \n",v);
  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");

  dec_rmap(V2P(v));
  if(get_rmap(V2P(v))>0)
    return;

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.num_free_pages+=1;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = kmem.freelist;
  if(r)
  {
    kmem.freelist = r->next;
    kmem.num_free_pages-=1;
    set_rmap(V2P(r),1); 
  }
  if(kmem.use_lock)
    release(&kmem.lock);
  
  if(!r)
  {
    swap_out();
    // cprintf("page allocated when r==0\n");
    return kalloc();
  }
  // cprintf("page address that allocated:%p\n",(char*)r);
  return (char*)r;
}
uint 
num_of_FreePages(void)
{
  acquire(&kmem.lock);

  uint num_free_pages = kmem.num_free_pages;
  
  release(&kmem.lock);
  
  return num_free_pages;
}
