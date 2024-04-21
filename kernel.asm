
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc f0 75 11 80       	mov    $0x801175f0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 a0 33 10 80       	mov    $0x801033a0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 00 77 10 80       	push   $0x80107700
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 65 47 00 00       	call   801047c0 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 07 77 10 80       	push   $0x80107707
80100097:	50                   	push   %eax
80100098:	e8 f3 45 00 00       	call   80104690 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 a7 48 00 00       	call   80104990 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 c9 47 00 00       	call   80104930 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 5e 45 00 00       	call   801046d0 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 4f 21 00 00       	call   801022e0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 0e 77 10 80       	push   $0x8010770e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 ad 45 00 00       	call   80104770 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 07 21 00 00       	jmp    801022e0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 1f 77 10 80       	push   $0x8010771f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 6c 45 00 00       	call   80104770 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 1c 45 00 00       	call   80104730 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 70 47 00 00       	call   80104990 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 bf 46 00 00       	jmp    80104930 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 26 77 10 80       	push   $0x80107726
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 c7 15 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 eb 46 00 00       	call   80104990 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 1e 41 00 00       	call   801043f0 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 c9 39 00 00       	call   80103cb0 <myproc>
801002e7:	8b 48 28             	mov    0x28(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 35 46 00 00       	call   80104930 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 7c 14 00 00       	call   80101780 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ff 10 80       	push   $0x8010ff20
8010034c:	e8 df 45 00 00       	call   80104930 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 26 14 00 00       	call   80101780 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 92 28 00 00       	call   80102c30 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 2d 77 10 80       	push   $0x8010772d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 07 81 10 80 	movl   $0x80108107,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 13 44 00 00       	call   801047e0 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 41 77 10 80       	push   $0x80107741
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 c1 5c 00 00       	call   801060e0 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if(pos < 0 || pos > 25*80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100493:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 d6 5b 00 00       	call   801060e0 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 ca 5b 00 00       	call   801060e0 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 be 5b 00 00       	call   801060e0 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 9a 45 00 00       	call   80104af0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 e5 44 00 00       	call   80104a50 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 45 77 10 80       	push   $0x80107745
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 bc 12 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005ab:	e8 e0 43 00 00       	call   80104990 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli    
    for(;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 20 ff 10 80       	push   $0x8010ff20
801005e4:	e8 47 43 00 00       	call   80104930 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 8e 11 00 00       	call   80101780 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 70 77 10 80 	movzbl -0x7fef8890(%edx),%edx
  }while((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if(sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100662:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
    for(;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 54 ff 10 80       	mov    0x8010ff54,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
    switch(c){
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
  if(locking)
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
}
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret    
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
      for(; *s; s++)
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
  if(panicked){
80100760:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli    
    for(;;)
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100787:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007a8:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 20 ff 10 80       	push   $0x8010ff20
801007e8:	e8 a3 41 00 00       	call   80104990 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100812:	85 d2                	test   %edx,%edx
80100814:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100817:	74 2e                	je     80100847 <cprintf+0x1a7>
80100819:	fa                   	cli    
    for(;;)
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli    
    for(;;)
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli    
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
        s = "(null)";
80100838:	bf 58 77 10 80       	mov    $0x80107758,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ff 10 80       	push   $0x8010ff20
8010085b:	e8 d0 40 00 00       	call   80104930 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 5f 77 10 80       	push   $0x8010775f
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <consoleintr>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
  int c, doprocdump = 0;
80100885:	31 f6                	xor    %esi,%esi
{
80100887:	53                   	push   %ebx
80100888:	83 ec 18             	sub    $0x18,%esp
8010088b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010088e:	68 20 ff 10 80       	push   $0x8010ff20
80100893:	e8 f8 40 00 00       	call   80104990 <acquire>
  while((c = getc()) >= 0){
80100898:	83 c4 10             	add    $0x10,%esp
8010089b:	eb 1a                	jmp    801008b7 <consoleintr+0x37>
8010089d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008a0:	83 fb 08             	cmp    $0x8,%ebx
801008a3:	0f 84 d7 00 00 00    	je     80100980 <consoleintr+0x100>
801008a9:	83 fb 10             	cmp    $0x10,%ebx
801008ac:	0f 85 32 01 00 00    	jne    801009e4 <consoleintr+0x164>
801008b2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008b7:	ff d7                	call   *%edi
801008b9:	89 c3                	mov    %eax,%ebx
801008bb:	85 c0                	test   %eax,%eax
801008bd:	0f 88 05 01 00 00    	js     801009c8 <consoleintr+0x148>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 78                	je     80100940 <consoleintr+0xc0>
801008c8:	7e d6                	jle    801008a0 <consoleintr+0x20>
801008ca:	83 fb 7f             	cmp    $0x7f,%ebx
801008cd:	0f 84 ad 00 00 00    	je     80100980 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d3:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 08 ff 10 80    	mov    %ecx,0x8010ff08
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  if(panicked){
80100906:	85 d2                	test   %edx,%edx
80100908:	0f 85 10 01 00 00    	jne    80100a1e <consoleintr+0x19e>
8010090e:	89 d8                	mov    %ebx,%eax
80100910:	e8 eb fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100915:	83 fb 0a             	cmp    $0xa,%ebx
80100918:	0f 84 14 01 00 00    	je     80100a32 <consoleintr+0x1b2>
8010091e:	83 fb 04             	cmp    $0x4,%ebx
80100921:	0f 84 0b 01 00 00    	je     80100a32 <consoleintr+0x1b2>
80100927:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100940:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100945:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.e--;
8010096c:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli    
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(input.e != input.w){
80100980:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100985:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100999:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009b7:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 20 ff 10 80       	push   $0x8010ff20
801009d0:	e8 5b 3f 00 00       	call   80104930 <release>
  if(doprocdump) {
801009d5:	83 c4 10             	add    $0x10,%esp
801009d8:	85 f6                	test   %esi,%esi
801009da:	75 2b                	jne    80100a07 <consoleintr+0x187>
}
801009dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009df:	5b                   	pop    %ebx
801009e0:	5e                   	pop    %esi
801009e1:	5f                   	pop    %edi
801009e2:	5d                   	pop    %ebp
801009e3:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009e4:	85 db                	test   %ebx,%ebx
801009e6:	0f 84 cb fe ff ff    	je     801008b7 <consoleintr+0x37>
801009ec:	e9 e2 fe ff ff       	jmp    801008d3 <consoleintr+0x53>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f8:	b8 00 01 00 00       	mov    $0x100,%eax
801009fd:	e8 fe f9 ff ff       	call   80100400 <consputc.part.0>
80100a02:	e9 b0 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
}
80100a07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a0a:	5b                   	pop    %ebx
80100a0b:	5e                   	pop    %esi
80100a0c:	5f                   	pop    %edi
80100a0d:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a0e:	e9 7d 3b 00 00       	jmp    80104590 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a13:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
  if(panicked){
80100a1a:	85 d2                	test   %edx,%edx
80100a1c:	74 0a                	je     80100a28 <consoleintr+0x1a8>
80100a1e:	fa                   	cli    
    for(;;)
80100a1f:	eb fe                	jmp    80100a1f <consoleintr+0x19f>
80100a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a28:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a2d:	e8 ce f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a32:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
80100a3f:	68 00 ff 10 80       	push   $0x8010ff00
80100a44:	e8 67 3a 00 00       	call   801044b0 <wakeup>
80100a49:	83 c4 10             	add    $0x10,%esp
80100a4c:	e9 66 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
80100a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 68 77 10 80       	push   $0x80107768
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 4b 3d 00 00       	call   801047c0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c 09 11 80 90 	movl   $0x80100590,0x8011090c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 e2 19 00 00       	call   80102480 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave  
80100aa2:	c3                   	ret    
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 ef 31 00 00       	call   80103cb0 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 d4 25 00 00       	call   801030a0 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 c9 15 00 00       	call   801020a0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 02 03 00 00    	je     80100de4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 93 0c 00 00       	call   80101780 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 92 0f 00 00       	call   80101a90 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	74 22                	je     80100b28 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	53                   	push   %ebx
80100b0a:	e8 01 0f 00 00       	call   80101a10 <iunlockput>
    end_op();
80100b0f:	e8 fc 25 00 00       	call   80103110 <end_op>
80100b14:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b1f:	5b                   	pop    %ebx
80100b20:	5e                   	pop    %esi
80100b21:	5f                   	pop    %edi
80100b22:	5d                   	pop    %ebp
80100b23:	c3                   	ret    
80100b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b28:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b2f:	45 4c 46 
80100b32:	75 d2                	jne    80100b06 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b34:	e8 c7 67 00 00       	call   80107300 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 ac 02 00 00    	je     80100e03 <exec+0x353>
  sz = 0;
80100b57:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b5e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b61:	31 ff                	xor    %edi,%edi
80100b63:	e9 8e 00 00 00       	jmp    80100bf6 <exec+0x146>
80100b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b6f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b70:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b77:	75 6c                	jne    80100be5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b79:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b7f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b85:	0f 82 87 00 00 00    	jb     80100c12 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b8b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b91:	72 7f                	jb     80100c12 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b93:	83 ec 04             	sub    $0x4,%esp
80100b96:	50                   	push   %eax
80100b97:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b9d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ba3:	e8 78 65 00 00       	call   80107120 <allocuvm>
80100ba8:	83 c4 10             	add    $0x10,%esp
80100bab:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	74 5d                	je     80100c12 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100bb5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bbb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bc0:	75 50                	jne    80100c12 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bc2:	83 ec 0c             	sub    $0xc,%esp
80100bc5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bcb:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bd1:	53                   	push   %ebx
80100bd2:	50                   	push   %eax
80100bd3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bd9:	e8 52 64 00 00       	call   80107030 <loaduvm>
80100bde:	83 c4 20             	add    $0x20,%esp
80100be1:	85 c0                	test   %eax,%eax
80100be3:	78 2d                	js     80100c12 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100be5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bec:	83 c7 01             	add    $0x1,%edi
80100bef:	83 c6 20             	add    $0x20,%esi
80100bf2:	39 f8                	cmp    %edi,%eax
80100bf4:	7e 3a                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bf6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bfc:	6a 20                	push   $0x20
80100bfe:	56                   	push   %esi
80100bff:	50                   	push   %eax
80100c00:	53                   	push   %ebx
80100c01:	e8 8a 0e 00 00       	call   80101a90 <readi>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	0f 84 5e ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1b:	e8 60 66 00 00       	call   80107280 <freevm>
  if(ip){
80100c20:	83 c4 10             	add    $0x10,%esp
80100c23:	e9 de fe ff ff       	jmp    80100b06 <exec+0x56>
80100c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c2f:	90                   	nop
  sz = PGROUNDUP(sz);
80100c30:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c36:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c3c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	53                   	push   %ebx
80100c4c:	e8 bf 0d 00 00       	call   80101a10 <iunlockput>
  end_op();
80100c51:	e8 ba 24 00 00       	call   80103110 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 b9 64 00 00       	call   80107120 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c6                	mov    %eax,%esi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 94 00 00 00    	je     80100d08 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c7d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 18 67 00 00       	call   801073a0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c94:	8b 00                	mov    (%eax),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	0f 84 8b 00 00 00    	je     80100d29 <exec+0x279>
80100c9e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100ca4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100caa:	eb 23                	jmp    80100ccf <exec+0x21f>
80100cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100cb3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100cba:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cbd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100cc3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cc6:	85 c0                	test   %eax,%eax
80100cc8:	74 59                	je     80100d23 <exec+0x273>
    if(argc >= MAXARG)
80100cca:	83 ff 20             	cmp    $0x20,%edi
80100ccd:	74 39                	je     80100d08 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ccf:	83 ec 0c             	sub    $0xc,%esp
80100cd2:	50                   	push   %eax
80100cd3:	e8 78 3f 00 00       	call   80104c50 <strlen>
80100cd8:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cda:	58                   	pop    %eax
80100cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cde:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce1:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ce4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce7:	e8 64 3f 00 00       	call   80104c50 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 63 68 00 00       	call   80107560 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 6a 65 00 00       	call   80107280 <freevm>
80100d16:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d1e:	e9 f9 fd ff ff       	jmp    80100b1c <exec+0x6c>
80100d23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d29:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d30:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d32:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d39:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d3d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d3f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d42:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d48:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d4a:	50                   	push   %eax
80100d4b:	52                   	push   %edx
80100d4c:	53                   	push   %ebx
80100d4d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d53:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d5a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d5d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d63:	e8 f8 67 00 00       	call   80107560 <copyout>
80100d68:	83 c4 10             	add    $0x10,%esp
80100d6b:	85 c0                	test   %eax,%eax
80100d6d:	78 99                	js     80100d08 <exec+0x258>
  for(last=s=path; *s; s++)
80100d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d72:	8b 55 08             	mov    0x8(%ebp),%edx
80100d75:	0f b6 00             	movzbl (%eax),%eax
80100d78:	84 c0                	test   %al,%al
80100d7a:	74 13                	je     80100d8f <exec+0x2df>
80100d7c:	89 d1                	mov    %edx,%ecx
80100d7e:	66 90                	xchg   %ax,%ax
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d95:	83 ec 04             	sub    $0x4,%esp
80100d98:	6a 10                	push   $0x10
80100d9a:	89 f8                	mov    %edi,%eax
80100d9c:	52                   	push   %edx
80100d9d:	83 c0 70             	add    $0x70,%eax
80100da0:	50                   	push   %eax
80100da1:	e8 6a 3e 00 00       	call   80104c10 <safestrcpy>
  curproc->pgdir = pgdir;
80100da6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dac:	89 f8                	mov    %edi,%eax
80100dae:	8b 7f 08             	mov    0x8(%edi),%edi
  curproc->sz = sz;
80100db1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100db3:	89 48 08             	mov    %ecx,0x8(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db6:	89 c1                	mov    %eax,%ecx
80100db8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbe:	8b 40 1c             	mov    0x1c(%eax),%eax
80100dc1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc4:	8b 41 1c             	mov    0x1c(%ecx),%eax
80100dc7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dca:	89 0c 24             	mov    %ecx,(%esp)
80100dcd:	e8 ce 60 00 00       	call   80106ea0 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 a6 64 00 00       	call   80107280 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 27 23 00 00       	call   80103110 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 81 77 10 80       	push   $0x80107781
80100df1:	e8 aa f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100df6:	83 c4 10             	add    $0x10,%esp
80100df9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dfe:	e9 19 fd ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e03:	be 00 20 00 00       	mov    $0x2000,%esi
80100e08:	31 ff                	xor    %edi,%edi
80100e0a:	e9 39 fe ff ff       	jmp    80100c48 <exec+0x198>
80100e0f:	90                   	nop

80100e10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e16:	68 8d 77 10 80       	push   $0x8010778d
80100e1b:	68 60 ff 10 80       	push   $0x8010ff60
80100e20:	e8 9b 39 00 00       	call   801047c0 <initlock>
}
80100e25:	83 c4 10             	add    $0x10,%esp
80100e28:	c9                   	leave  
80100e29:	c3                   	ret    
80100e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e30 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e34:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100e39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e3c:	68 60 ff 10 80       	push   $0x8010ff60
80100e41:	e8 4a 3b 00 00       	call   80104990 <acquire>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	eb 10                	jmp    80100e5b <filealloc+0x2b>
80100e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e4f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e50:	83 c3 18             	add    $0x18,%ebx
80100e53:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100e59:	74 25                	je     80100e80 <filealloc+0x50>
    if(f->ref == 0){
80100e5b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e5e:	85 c0                	test   %eax,%eax
80100e60:	75 ee                	jne    80100e50 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e62:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e65:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e6c:	68 60 ff 10 80       	push   $0x8010ff60
80100e71:	e8 ba 3a 00 00       	call   80104930 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e76:	89 d8                	mov    %ebx,%eax
      return f;
80100e78:	83 c4 10             	add    $0x10,%esp
}
80100e7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e7e:	c9                   	leave  
80100e7f:	c3                   	ret    
  release(&ftable.lock);
80100e80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e83:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e85:	68 60 ff 10 80       	push   $0x8010ff60
80100e8a:	e8 a1 3a 00 00       	call   80104930 <release>
}
80100e8f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e91:	83 c4 10             	add    $0x10,%esp
}
80100e94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e97:	c9                   	leave  
80100e98:	c3                   	ret    
80100e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ea0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	53                   	push   %ebx
80100ea4:	83 ec 10             	sub    $0x10,%esp
80100ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eaa:	68 60 ff 10 80       	push   $0x8010ff60
80100eaf:	e8 dc 3a 00 00       	call   80104990 <acquire>
  if(f->ref < 1)
80100eb4:	8b 43 04             	mov    0x4(%ebx),%eax
80100eb7:	83 c4 10             	add    $0x10,%esp
80100eba:	85 c0                	test   %eax,%eax
80100ebc:	7e 1a                	jle    80100ed8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ebe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ec1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ec4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ec7:	68 60 ff 10 80       	push   $0x8010ff60
80100ecc:	e8 5f 3a 00 00       	call   80104930 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 94 77 10 80       	push   $0x80107794
80100ee0:	e8 9b f4 ff ff       	call   80100380 <panic>
80100ee5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	57                   	push   %edi
80100ef4:	56                   	push   %esi
80100ef5:	53                   	push   %ebx
80100ef6:	83 ec 28             	sub    $0x28,%esp
80100ef9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100efc:	68 60 ff 10 80       	push   $0x8010ff60
80100f01:	e8 8a 3a 00 00       	call   80104990 <acquire>
  if(f->ref < 1)
80100f06:	8b 53 04             	mov    0x4(%ebx),%edx
80100f09:	83 c4 10             	add    $0x10,%esp
80100f0c:	85 d2                	test   %edx,%edx
80100f0e:	0f 8e a5 00 00 00    	jle    80100fb9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f14:	83 ea 01             	sub    $0x1,%edx
80100f17:	89 53 04             	mov    %edx,0x4(%ebx)
80100f1a:	75 44                	jne    80100f60 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f1c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f20:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f23:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f25:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f2b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f2e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f31:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f34:	68 60 ff 10 80       	push   $0x8010ff60
  ff = *f;
80100f39:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f3c:	e8 ef 39 00 00       	call   80104930 <release>

  if(ff.type == FD_PIPE)
80100f41:	83 c4 10             	add    $0x10,%esp
80100f44:	83 ff 01             	cmp    $0x1,%edi
80100f47:	74 57                	je     80100fa0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f49:	83 ff 02             	cmp    $0x2,%edi
80100f4c:	74 2a                	je     80100f78 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f51:	5b                   	pop    %ebx
80100f52:	5e                   	pop    %esi
80100f53:	5f                   	pop    %edi
80100f54:	5d                   	pop    %ebp
80100f55:	c3                   	ret    
80100f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f5d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f60:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80100f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6a:	5b                   	pop    %ebx
80100f6b:	5e                   	pop    %esi
80100f6c:	5f                   	pop    %edi
80100f6d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f6e:	e9 bd 39 00 00       	jmp    80104930 <release>
80100f73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f77:	90                   	nop
    begin_op();
80100f78:	e8 23 21 00 00       	call   801030a0 <begin_op>
    iput(ff.ip);
80100f7d:	83 ec 0c             	sub    $0xc,%esp
80100f80:	ff 75 e0             	push   -0x20(%ebp)
80100f83:	e8 28 09 00 00       	call   801018b0 <iput>
    end_op();
80100f88:	83 c4 10             	add    $0x10,%esp
}
80100f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8e:	5b                   	pop    %ebx
80100f8f:	5e                   	pop    %esi
80100f90:	5f                   	pop    %edi
80100f91:	5d                   	pop    %ebp
    end_op();
80100f92:	e9 79 21 00 00       	jmp    80103110 <end_op>
80100f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fa0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fa4:	83 ec 08             	sub    $0x8,%esp
80100fa7:	53                   	push   %ebx
80100fa8:	56                   	push   %esi
80100fa9:	e8 c2 28 00 00       	call   80103870 <pipeclose>
80100fae:	83 c4 10             	add    $0x10,%esp
}
80100fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb4:	5b                   	pop    %ebx
80100fb5:	5e                   	pop    %esi
80100fb6:	5f                   	pop    %edi
80100fb7:	5d                   	pop    %ebp
80100fb8:	c3                   	ret    
    panic("fileclose");
80100fb9:	83 ec 0c             	sub    $0xc,%esp
80100fbc:	68 9c 77 10 80       	push   $0x8010779c
80100fc1:	e8 ba f3 ff ff       	call   80100380 <panic>
80100fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fcd:	8d 76 00             	lea    0x0(%esi),%esi

80100fd0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	53                   	push   %ebx
80100fd4:	83 ec 04             	sub    $0x4,%esp
80100fd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fda:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fdd:	75 31                	jne    80101010 <filestat+0x40>
    ilock(f->ip);
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	ff 73 10             	push   0x10(%ebx)
80100fe5:	e8 96 07 00 00       	call   80101780 <ilock>
    stati(f->ip, st);
80100fea:	58                   	pop    %eax
80100feb:	5a                   	pop    %edx
80100fec:	ff 75 0c             	push   0xc(%ebp)
80100fef:	ff 73 10             	push   0x10(%ebx)
80100ff2:	e8 69 0a 00 00       	call   80101a60 <stati>
    iunlock(f->ip);
80100ff7:	59                   	pop    %ecx
80100ff8:	ff 73 10             	push   0x10(%ebx)
80100ffb:	e8 60 08 00 00       	call   80101860 <iunlock>
    return 0;
  }
  return -1;
}
80101000:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101003:	83 c4 10             	add    $0x10,%esp
80101006:	31 c0                	xor    %eax,%eax
}
80101008:	c9                   	leave  
80101009:	c3                   	ret    
8010100a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101020 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 0c             	sub    $0xc,%esp
80101029:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010102c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010102f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101032:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101036:	74 60                	je     80101098 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101038:	8b 03                	mov    (%ebx),%eax
8010103a:	83 f8 01             	cmp    $0x1,%eax
8010103d:	74 41                	je     80101080 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010103f:	83 f8 02             	cmp    $0x2,%eax
80101042:	75 5b                	jne    8010109f <fileread+0x7f>
    ilock(f->ip);
80101044:	83 ec 0c             	sub    $0xc,%esp
80101047:	ff 73 10             	push   0x10(%ebx)
8010104a:	e8 31 07 00 00       	call   80101780 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010104f:	57                   	push   %edi
80101050:	ff 73 14             	push   0x14(%ebx)
80101053:	56                   	push   %esi
80101054:	ff 73 10             	push   0x10(%ebx)
80101057:	e8 34 0a 00 00       	call   80101a90 <readi>
8010105c:	83 c4 20             	add    $0x20,%esp
8010105f:	89 c6                	mov    %eax,%esi
80101061:	85 c0                	test   %eax,%eax
80101063:	7e 03                	jle    80101068 <fileread+0x48>
      f->off += r;
80101065:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101068:	83 ec 0c             	sub    $0xc,%esp
8010106b:	ff 73 10             	push   0x10(%ebx)
8010106e:	e8 ed 07 00 00       	call   80101860 <iunlock>
    return r;
80101073:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101079:	89 f0                	mov    %esi,%eax
8010107b:	5b                   	pop    %ebx
8010107c:	5e                   	pop    %esi
8010107d:	5f                   	pop    %edi
8010107e:	5d                   	pop    %ebp
8010107f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101080:	8b 43 0c             	mov    0xc(%ebx),%eax
80101083:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101089:	5b                   	pop    %ebx
8010108a:	5e                   	pop    %esi
8010108b:	5f                   	pop    %edi
8010108c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010108d:	e9 7e 29 00 00       	jmp    80103a10 <piperead>
80101092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101098:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010109d:	eb d7                	jmp    80101076 <fileread+0x56>
  panic("fileread");
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	68 a6 77 10 80       	push   $0x801077a6
801010a7:	e8 d4 f2 ff ff       	call   80100380 <panic>
801010ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010b0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	57                   	push   %edi
801010b4:	56                   	push   %esi
801010b5:	53                   	push   %ebx
801010b6:	83 ec 1c             	sub    $0x1c,%esp
801010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010c2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010c5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010cc:	0f 84 bd 00 00 00    	je     8010118f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801010d2:	8b 03                	mov    (%ebx),%eax
801010d4:	83 f8 01             	cmp    $0x1,%eax
801010d7:	0f 84 bf 00 00 00    	je     8010119c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010dd:	83 f8 02             	cmp    $0x2,%eax
801010e0:	0f 85 c8 00 00 00    	jne    801011ae <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010e9:	31 f6                	xor    %esi,%esi
    while(i < n){
801010eb:	85 c0                	test   %eax,%eax
801010ed:	7f 30                	jg     8010111f <filewrite+0x6f>
801010ef:	e9 94 00 00 00       	jmp    80101188 <filewrite+0xd8>
801010f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010f8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801010fb:	83 ec 0c             	sub    $0xc,%esp
801010fe:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101101:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101104:	e8 57 07 00 00       	call   80101860 <iunlock>
      end_op();
80101109:	e8 02 20 00 00       	call   80103110 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010110e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101111:	83 c4 10             	add    $0x10,%esp
80101114:	39 c7                	cmp    %eax,%edi
80101116:	75 5c                	jne    80101174 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101118:	01 fe                	add    %edi,%esi
    while(i < n){
8010111a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010111d:	7e 69                	jle    80101188 <filewrite+0xd8>
      int n1 = n - i;
8010111f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101122:	b8 00 06 00 00       	mov    $0x600,%eax
80101127:	29 f7                	sub    %esi,%edi
80101129:	39 c7                	cmp    %eax,%edi
8010112b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010112e:	e8 6d 1f 00 00       	call   801030a0 <begin_op>
      ilock(f->ip);
80101133:	83 ec 0c             	sub    $0xc,%esp
80101136:	ff 73 10             	push   0x10(%ebx)
80101139:	e8 42 06 00 00       	call   80101780 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010113e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101141:	57                   	push   %edi
80101142:	ff 73 14             	push   0x14(%ebx)
80101145:	01 f0                	add    %esi,%eax
80101147:	50                   	push   %eax
80101148:	ff 73 10             	push   0x10(%ebx)
8010114b:	e8 40 0a 00 00       	call   80101b90 <writei>
80101150:	83 c4 20             	add    $0x20,%esp
80101153:	85 c0                	test   %eax,%eax
80101155:	7f a1                	jg     801010f8 <filewrite+0x48>
      iunlock(f->ip);
80101157:	83 ec 0c             	sub    $0xc,%esp
8010115a:	ff 73 10             	push   0x10(%ebx)
8010115d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101160:	e8 fb 06 00 00       	call   80101860 <iunlock>
      end_op();
80101165:	e8 a6 1f 00 00       	call   80103110 <end_op>
      if(r < 0)
8010116a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010116d:	83 c4 10             	add    $0x10,%esp
80101170:	85 c0                	test   %eax,%eax
80101172:	75 1b                	jne    8010118f <filewrite+0xdf>
        panic("short filewrite");
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	68 af 77 10 80       	push   $0x801077af
8010117c:	e8 ff f1 ff ff       	call   80100380 <panic>
80101181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101188:	89 f0                	mov    %esi,%eax
8010118a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010118d:	74 05                	je     80101194 <filewrite+0xe4>
8010118f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101197:	5b                   	pop    %ebx
80101198:	5e                   	pop    %esi
80101199:	5f                   	pop    %edi
8010119a:	5d                   	pop    %ebp
8010119b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010119c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010119f:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a5:	5b                   	pop    %ebx
801011a6:	5e                   	pop    %esi
801011a7:	5f                   	pop    %edi
801011a8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011a9:	e9 62 27 00 00       	jmp    80103910 <pipewrite>
  panic("filewrite");
801011ae:	83 ec 0c             	sub    $0xc,%esp
801011b1:	68 b5 77 10 80       	push   $0x801077b5
801011b6:	e8 c5 f1 ff ff       	call   80100380 <panic>
801011bb:	66 90                	xchg   %ax,%ax
801011bd:	66 90                	xchg   %ax,%ax
801011bf:	90                   	nop

801011c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011c0:	55                   	push   %ebp
801011c1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011c3:	89 d0                	mov    %edx,%eax
801011c5:	c1 e8 0c             	shr    $0xc,%eax
801011c8:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
801011ce:	89 e5                	mov    %esp,%ebp
801011d0:	56                   	push   %esi
801011d1:	53                   	push   %ebx
801011d2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	50                   	push   %eax
801011d8:	51                   	push   %ecx
801011d9:	e8 f2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011de:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011e0:	c1 fb 03             	sar    $0x3,%ebx
801011e3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801011e6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801011e8:	83 e1 07             	and    $0x7,%ecx
801011eb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801011f0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801011f6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801011f8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801011fd:	85 c1                	test   %eax,%ecx
801011ff:	74 23                	je     80101224 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101201:	f7 d0                	not    %eax
  log_write(bp);
80101203:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101206:	21 c8                	and    %ecx,%eax
80101208:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010120c:	56                   	push   %esi
8010120d:	e8 6e 20 00 00       	call   80103280 <log_write>
  brelse(bp);
80101212:	89 34 24             	mov    %esi,(%esp)
80101215:	e8 d6 ef ff ff       	call   801001f0 <brelse>
}
8010121a:	83 c4 10             	add    $0x10,%esp
8010121d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101220:	5b                   	pop    %ebx
80101221:	5e                   	pop    %esi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret    
    panic("freeing free block");
80101224:	83 ec 0c             	sub    $0xc,%esp
80101227:	68 bf 77 10 80       	push   $0x801077bf
8010122c:	e8 4f f1 ff ff       	call   80100380 <panic>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010123f:	90                   	nop

80101240 <balloc>:
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101249:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
8010124f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101252:	85 c9                	test   %ecx,%ecx
80101254:	0f 84 87 00 00 00    	je     801012e1 <balloc+0xa1>
8010125a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101261:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101264:	83 ec 08             	sub    $0x8,%esp
80101267:	89 f0                	mov    %esi,%eax
80101269:	c1 f8 0c             	sar    $0xc,%eax
8010126c:	03 05 cc 25 11 80    	add    0x801125cc,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	push   -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101281:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80101286:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101289:	31 c0                	xor    %eax,%eax
8010128b:	eb 2f                	jmp    801012bc <balloc+0x7c>
8010128d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101290:	89 c1                	mov    %eax,%ecx
80101292:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010129a:	83 e1 07             	and    $0x7,%ecx
8010129d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010129f:	89 c1                	mov    %eax,%ecx
801012a1:	c1 f9 03             	sar    $0x3,%ecx
801012a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012a9:	89 fa                	mov    %edi,%edx
801012ab:	85 df                	test   %ebx,%edi
801012ad:	74 41                	je     801012f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012af:	83 c0 01             	add    $0x1,%eax
801012b2:	83 c6 01             	add    $0x1,%esi
801012b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ba:	74 05                	je     801012c1 <balloc+0x81>
801012bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012bf:	77 cf                	ja     80101290 <balloc+0x50>
    brelse(bp);
801012c1:	83 ec 0c             	sub    $0xc,%esp
801012c4:	ff 75 e4             	push   -0x1c(%ebp)
801012c7:	e8 24 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012d3:	83 c4 10             	add    $0x10,%esp
801012d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012d9:	39 05 b4 25 11 80    	cmp    %eax,0x801125b4
801012df:	77 80                	ja     80101261 <balloc+0x21>
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 d2 77 10 80       	push   $0x801077d2
801012e9:	e8 92 f0 ff ff       	call   80100380 <panic>
801012ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012f6:	09 da                	or     %ebx,%edx
801012f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012fc:	57                   	push   %edi
801012fd:	e8 7e 1f 00 00       	call   80103280 <log_write>
        brelse(bp);
80101302:	89 3c 24             	mov    %edi,(%esp)
80101305:	e8 e6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010130a:	58                   	pop    %eax
8010130b:	5a                   	pop    %edx
8010130c:	56                   	push   %esi
8010130d:	ff 75 d8             	push   -0x28(%ebp)
80101310:	e8 bb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101315:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101318:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010131a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010131d:	68 00 02 00 00       	push   $0x200
80101322:	6a 00                	push   $0x0
80101324:	50                   	push   %eax
80101325:	e8 26 37 00 00       	call   80104a50 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 4e 1f 00 00       	call   80103280 <log_write>
  brelse(bp);
80101332:	89 1c 24             	mov    %ebx,(%esp)
80101335:	e8 b6 ee ff ff       	call   801001f0 <brelse>
}
8010133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133d:	89 f0                	mov    %esi,%eax
8010133f:	5b                   	pop    %ebx
80101340:	5e                   	pop    %esi
80101341:	5f                   	pop    %edi
80101342:	5d                   	pop    %ebp
80101343:	c3                   	ret    
80101344:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010134f:	90                   	nop

80101350 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	89 c7                	mov    %eax,%edi
80101356:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101357:	31 f6                	xor    %esi,%esi
{
80101359:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135a:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 60 09 11 80       	push   $0x80110960
8010136a:	e8 21 36 00 00       	call   80104990 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101372:	83 c4 10             	add    $0x10,%esp
80101375:	eb 1b                	jmp    80101392 <iget+0x42>
80101377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010137e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101380:	39 3b                	cmp    %edi,(%ebx)
80101382:	74 6c                	je     801013f0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101384:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010138a:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101390:	73 26                	jae    801013b8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101392:	8b 43 08             	mov    0x8(%ebx),%eax
80101395:	85 c0                	test   %eax,%eax
80101397:	7f e7                	jg     80101380 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101399:	85 f6                	test   %esi,%esi
8010139b:	75 e7                	jne    80101384 <iget+0x34>
8010139d:	85 c0                	test   %eax,%eax
8010139f:	75 76                	jne    80101417 <iget+0xc7>
801013a1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013a3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013a9:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013af:	72 e1                	jb     80101392 <iget+0x42>
801013b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013b8:	85 f6                	test   %esi,%esi
801013ba:	74 79                	je     80101435 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013bc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013bf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013c1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013c4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013cb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013d2:	68 60 09 11 80       	push   $0x80110960
801013d7:	e8 54 35 00 00       	call   80104930 <release>

  return ip;
801013dc:	83 c4 10             	add    $0x10,%esp
}
801013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e2:	89 f0                	mov    %esi,%eax
801013e4:	5b                   	pop    %ebx
801013e5:	5e                   	pop    %esi
801013e6:	5f                   	pop    %edi
801013e7:	5d                   	pop    %ebp
801013e8:	c3                   	ret    
801013e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013f3:	75 8f                	jne    80101384 <iget+0x34>
      release(&icache.lock);
801013f5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013f8:	83 c0 01             	add    $0x1,%eax
      return ip;
801013fb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013fd:	68 60 09 11 80       	push   $0x80110960
      ip->ref++;
80101402:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101405:	e8 26 35 00 00       	call   80104930 <release>
      return ip;
8010140a:	83 c4 10             	add    $0x10,%esp
}
8010140d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101410:	89 f0                	mov    %esi,%eax
80101412:	5b                   	pop    %ebx
80101413:	5e                   	pop    %esi
80101414:	5f                   	pop    %edi
80101415:	5d                   	pop    %ebp
80101416:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101417:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010141d:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101423:	73 10                	jae    80101435 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101425:	8b 43 08             	mov    0x8(%ebx),%eax
80101428:	85 c0                	test   %eax,%eax
8010142a:	0f 8f 50 ff ff ff    	jg     80101380 <iget+0x30>
80101430:	e9 68 ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
80101435:	83 ec 0c             	sub    $0xc,%esp
80101438:	68 e8 77 10 80       	push   $0x801077e8
8010143d:	e8 3e ef ff ff       	call   80100380 <panic>
80101442:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101450 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	57                   	push   %edi
80101454:	56                   	push   %esi
80101455:	89 c6                	mov    %eax,%esi
80101457:	53                   	push   %ebx
80101458:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010145b:	83 fa 0b             	cmp    $0xb,%edx
8010145e:	0f 86 8c 00 00 00    	jbe    801014f0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101464:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101467:	83 fb 7f             	cmp    $0x7f,%ebx
8010146a:	0f 87 a2 00 00 00    	ja     80101512 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101470:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101476:	85 c0                	test   %eax,%eax
80101478:	74 5e                	je     801014d8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010147a:	83 ec 08             	sub    $0x8,%esp
8010147d:	50                   	push   %eax
8010147e:	ff 36                	push   (%esi)
80101480:	e8 4b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101485:	83 c4 10             	add    $0x10,%esp
80101488:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010148c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010148e:	8b 3b                	mov    (%ebx),%edi
80101490:	85 ff                	test   %edi,%edi
80101492:	74 1c                	je     801014b0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101494:	83 ec 0c             	sub    $0xc,%esp
80101497:	52                   	push   %edx
80101498:	e8 53 ed ff ff       	call   801001f0 <brelse>
8010149d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014a3:	89 f8                	mov    %edi,%eax
801014a5:	5b                   	pop    %ebx
801014a6:	5e                   	pop    %esi
801014a7:	5f                   	pop    %edi
801014a8:	5d                   	pop    %ebp
801014a9:	c3                   	ret    
801014aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014b3:	8b 06                	mov    (%esi),%eax
801014b5:	e8 86 fd ff ff       	call   80101240 <balloc>
      log_write(bp);
801014ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014bd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014c0:	89 03                	mov    %eax,(%ebx)
801014c2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014c4:	52                   	push   %edx
801014c5:	e8 b6 1d 00 00       	call   80103280 <log_write>
801014ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014cd:	83 c4 10             	add    $0x10,%esp
801014d0:	eb c2                	jmp    80101494 <bmap+0x44>
801014d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014d8:	8b 06                	mov    (%esi),%eax
801014da:	e8 61 fd ff ff       	call   80101240 <balloc>
801014df:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014e5:	eb 93                	jmp    8010147a <bmap+0x2a>
801014e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014ee:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
801014f0:	8d 5a 14             	lea    0x14(%edx),%ebx
801014f3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801014f7:	85 ff                	test   %edi,%edi
801014f9:	75 a5                	jne    801014a0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014fb:	8b 00                	mov    (%eax),%eax
801014fd:	e8 3e fd ff ff       	call   80101240 <balloc>
80101502:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101506:	89 c7                	mov    %eax,%edi
}
80101508:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010150b:	5b                   	pop    %ebx
8010150c:	89 f8                	mov    %edi,%eax
8010150e:	5e                   	pop    %esi
8010150f:	5f                   	pop    %edi
80101510:	5d                   	pop    %ebp
80101511:	c3                   	ret    
  panic("bmap: out of range");
80101512:	83 ec 0c             	sub    $0xc,%esp
80101515:	68 f8 77 10 80       	push   $0x801077f8
8010151a:	e8 61 ee ff ff       	call   80100380 <panic>
8010151f:	90                   	nop

80101520 <readsb>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	56                   	push   %esi
80101524:	53                   	push   %ebx
80101525:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101528:	83 ec 08             	sub    $0x8,%esp
8010152b:	6a 01                	push   $0x1
8010152d:	ff 75 08             	push   0x8(%ebp)
80101530:	e8 9b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101535:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101538:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010153a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010153d:	6a 1c                	push   $0x1c
8010153f:	50                   	push   %eax
80101540:	56                   	push   %esi
80101541:	e8 aa 35 00 00       	call   80104af0 <memmove>
  brelse(bp);
80101546:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101549:	83 c4 10             	add    $0x10,%esp
}
8010154c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010154f:	5b                   	pop    %ebx
80101550:	5e                   	pop    %esi
80101551:	5d                   	pop    %ebp
  brelse(bp);
80101552:	e9 99 ec ff ff       	jmp    801001f0 <brelse>
80101557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010155e:	66 90                	xchg   %ax,%ax

80101560 <iinit>:
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	53                   	push   %ebx
80101564:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101569:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010156c:	68 0b 78 10 80       	push   $0x8010780b
80101571:	68 60 09 11 80       	push   $0x80110960
80101576:	e8 45 32 00 00       	call   801047c0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 12 78 10 80       	push   $0x80107812
80101588:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101589:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010158f:	e8 fc 30 00 00       	call   80104690 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101594:	83 c4 10             	add    $0x10,%esp
80101597:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
8010159d:	75 e1                	jne    80101580 <iinit+0x20>
  bp = bread(dev, 1);
8010159f:	83 ec 08             	sub    $0x8,%esp
801015a2:	6a 01                	push   $0x1
801015a4:	ff 75 08             	push   0x8(%ebp)
801015a7:	e8 24 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015ac:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015af:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015b1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015b4:	6a 1c                	push   $0x1c
801015b6:	50                   	push   %eax
801015b7:	68 b4 25 11 80       	push   $0x801125b4
801015bc:	e8 2f 35 00 00       	call   80104af0 <memmove>
  brelse(bp);
801015c1:	89 1c 24             	mov    %ebx,(%esp)
801015c4:	e8 27 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015c9:	ff 35 cc 25 11 80    	push   0x801125cc
801015cf:	ff 35 c8 25 11 80    	push   0x801125c8
801015d5:	ff 35 c4 25 11 80    	push   0x801125c4
801015db:	ff 35 c0 25 11 80    	push   0x801125c0
801015e1:	ff 35 bc 25 11 80    	push   0x801125bc
801015e7:	ff 35 b8 25 11 80    	push   0x801125b8
801015ed:	ff 35 b4 25 11 80    	push   0x801125b4
801015f3:	68 78 78 10 80       	push   $0x80107878
801015f8:	e8 a3 f0 ff ff       	call   801006a0 <cprintf>
}
801015fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101600:	83 c4 30             	add    $0x30,%esp
80101603:	c9                   	leave  
80101604:	c3                   	ret    
80101605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010160c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101610 <ialloc>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	57                   	push   %edi
80101614:	56                   	push   %esi
80101615:	53                   	push   %ebx
80101616:	83 ec 1c             	sub    $0x1c,%esp
80101619:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101623:	8b 75 08             	mov    0x8(%ebp),%esi
80101626:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101629:	0f 86 91 00 00 00    	jbe    801016c0 <ialloc+0xb0>
8010162f:	bf 01 00 00 00       	mov    $0x1,%edi
80101634:	eb 21                	jmp    80101657 <ialloc+0x47>
80101636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010163d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101640:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101643:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101646:	53                   	push   %ebx
80101647:	e8 a4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010164c:	83 c4 10             	add    $0x10,%esp
8010164f:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
80101655:	73 69                	jae    801016c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101657:	89 f8                	mov    %edi,%eax
80101659:	83 ec 08             	sub    $0x8,%esp
8010165c:	c1 e8 03             	shr    $0x3,%eax
8010165f:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101665:	50                   	push   %eax
80101666:	56                   	push   %esi
80101667:	e8 64 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010166c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010166f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101671:	89 f8                	mov    %edi,%eax
80101673:	83 e0 07             	and    $0x7,%eax
80101676:	c1 e0 06             	shl    $0x6,%eax
80101679:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010167d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101681:	75 bd                	jne    80101640 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101683:	83 ec 04             	sub    $0x4,%esp
80101686:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101689:	6a 40                	push   $0x40
8010168b:	6a 00                	push   $0x0
8010168d:	51                   	push   %ecx
8010168e:	e8 bd 33 00 00       	call   80104a50 <memset>
      dip->type = type;
80101693:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101697:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010169a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010169d:	89 1c 24             	mov    %ebx,(%esp)
801016a0:	e8 db 1b 00 00       	call   80103280 <log_write>
      brelse(bp);
801016a5:	89 1c 24             	mov    %ebx,(%esp)
801016a8:	e8 43 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016ad:	83 c4 10             	add    $0x10,%esp
}
801016b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016b3:	89 fa                	mov    %edi,%edx
}
801016b5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016b6:	89 f0                	mov    %esi,%eax
}
801016b8:	5e                   	pop    %esi
801016b9:	5f                   	pop    %edi
801016ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801016bb:	e9 90 fc ff ff       	jmp    80101350 <iget>
  panic("ialloc: no inodes");
801016c0:	83 ec 0c             	sub    $0xc,%esp
801016c3:	68 18 78 10 80       	push   $0x80107818
801016c8:	e8 b3 ec ff ff       	call   80100380 <panic>
801016cd:	8d 76 00             	lea    0x0(%esi),%esi

801016d0 <iupdate>:
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	56                   	push   %esi
801016d4:	53                   	push   %ebx
801016d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016db:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016de:	83 ec 08             	sub    $0x8,%esp
801016e1:	c1 e8 03             	shr    $0x3,%eax
801016e4:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801016ea:	50                   	push   %eax
801016eb:	ff 73 a4             	push   -0x5c(%ebx)
801016ee:	e8 dd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016f3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016f7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fa:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016fc:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016ff:	83 e0 07             	and    $0x7,%eax
80101702:	c1 e0 06             	shl    $0x6,%eax
80101705:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101709:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010170c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101710:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101713:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101717:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010171b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010171f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101723:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101727:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010172a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172d:	6a 34                	push   $0x34
8010172f:	53                   	push   %ebx
80101730:	50                   	push   %eax
80101731:	e8 ba 33 00 00       	call   80104af0 <memmove>
  log_write(bp);
80101736:	89 34 24             	mov    %esi,(%esp)
80101739:	e8 42 1b 00 00       	call   80103280 <log_write>
  brelse(bp);
8010173e:	89 75 08             	mov    %esi,0x8(%ebp)
80101741:	83 c4 10             	add    $0x10,%esp
}
80101744:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101747:	5b                   	pop    %ebx
80101748:	5e                   	pop    %esi
80101749:	5d                   	pop    %ebp
  brelse(bp);
8010174a:	e9 a1 ea ff ff       	jmp    801001f0 <brelse>
8010174f:	90                   	nop

80101750 <idup>:
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	53                   	push   %ebx
80101754:	83 ec 10             	sub    $0x10,%esp
80101757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010175a:	68 60 09 11 80       	push   $0x80110960
8010175f:	e8 2c 32 00 00       	call   80104990 <acquire>
  ip->ref++;
80101764:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101768:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010176f:	e8 bc 31 00 00       	call   80104930 <release>
}
80101774:	89 d8                	mov    %ebx,%eax
80101776:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101779:	c9                   	leave  
8010177a:	c3                   	ret    
8010177b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010177f:	90                   	nop

80101780 <ilock>:
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101788:	85 db                	test   %ebx,%ebx
8010178a:	0f 84 b7 00 00 00    	je     80101847 <ilock+0xc7>
80101790:	8b 53 08             	mov    0x8(%ebx),%edx
80101793:	85 d2                	test   %edx,%edx
80101795:	0f 8e ac 00 00 00    	jle    80101847 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010179b:	83 ec 0c             	sub    $0xc,%esp
8010179e:	8d 43 0c             	lea    0xc(%ebx),%eax
801017a1:	50                   	push   %eax
801017a2:	e8 29 2f 00 00       	call   801046d0 <acquiresleep>
  if(ip->valid == 0){
801017a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017aa:	83 c4 10             	add    $0x10,%esp
801017ad:	85 c0                	test   %eax,%eax
801017af:	74 0f                	je     801017c0 <ilock+0x40>
}
801017b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017b4:	5b                   	pop    %ebx
801017b5:	5e                   	pop    %esi
801017b6:	5d                   	pop    %ebp
801017b7:	c3                   	ret    
801017b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017bf:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017c0:	8b 43 04             	mov    0x4(%ebx),%eax
801017c3:	83 ec 08             	sub    $0x8,%esp
801017c6:	c1 e8 03             	shr    $0x3,%eax
801017c9:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801017cf:	50                   	push   %eax
801017d0:	ff 33                	push   (%ebx)
801017d2:	e8 f9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017d7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017da:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017dc:	8b 43 04             	mov    0x4(%ebx),%eax
801017df:	83 e0 07             	and    $0x7,%eax
801017e2:	c1 e0 06             	shl    $0x6,%eax
801017e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101803:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101807:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010180b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010180e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101811:	6a 34                	push   $0x34
80101813:	50                   	push   %eax
80101814:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101817:	50                   	push   %eax
80101818:	e8 d3 32 00 00       	call   80104af0 <memmove>
    brelse(bp);
8010181d:	89 34 24             	mov    %esi,(%esp)
80101820:	e8 cb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101825:	83 c4 10             	add    $0x10,%esp
80101828:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010182d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101834:	0f 85 77 ff ff ff    	jne    801017b1 <ilock+0x31>
      panic("ilock: no type");
8010183a:	83 ec 0c             	sub    $0xc,%esp
8010183d:	68 30 78 10 80       	push   $0x80107830
80101842:	e8 39 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 2a 78 10 80       	push   $0x8010782a
8010184f:	e8 2c eb ff ff       	call   80100380 <panic>
80101854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010185b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010185f:	90                   	nop

80101860 <iunlock>:
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	56                   	push   %esi
80101864:	53                   	push   %ebx
80101865:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101868:	85 db                	test   %ebx,%ebx
8010186a:	74 28                	je     80101894 <iunlock+0x34>
8010186c:	83 ec 0c             	sub    $0xc,%esp
8010186f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101872:	56                   	push   %esi
80101873:	e8 f8 2e 00 00       	call   80104770 <holdingsleep>
80101878:	83 c4 10             	add    $0x10,%esp
8010187b:	85 c0                	test   %eax,%eax
8010187d:	74 15                	je     80101894 <iunlock+0x34>
8010187f:	8b 43 08             	mov    0x8(%ebx),%eax
80101882:	85 c0                	test   %eax,%eax
80101884:	7e 0e                	jle    80101894 <iunlock+0x34>
  releasesleep(&ip->lock);
80101886:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101889:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010188c:	5b                   	pop    %ebx
8010188d:	5e                   	pop    %esi
8010188e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010188f:	e9 9c 2e 00 00       	jmp    80104730 <releasesleep>
    panic("iunlock");
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	68 3f 78 10 80       	push   $0x8010783f
8010189c:	e8 df ea ff ff       	call   80100380 <panic>
801018a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018af:	90                   	nop

801018b0 <iput>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	57                   	push   %edi
801018b4:	56                   	push   %esi
801018b5:	53                   	push   %ebx
801018b6:	83 ec 28             	sub    $0x28,%esp
801018b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018bf:	57                   	push   %edi
801018c0:	e8 0b 2e 00 00       	call   801046d0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018c8:	83 c4 10             	add    $0x10,%esp
801018cb:	85 d2                	test   %edx,%edx
801018cd:	74 07                	je     801018d6 <iput+0x26>
801018cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018d4:	74 32                	je     80101908 <iput+0x58>
  releasesleep(&ip->lock);
801018d6:	83 ec 0c             	sub    $0xc,%esp
801018d9:	57                   	push   %edi
801018da:	e8 51 2e 00 00       	call   80104730 <releasesleep>
  acquire(&icache.lock);
801018df:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801018e6:	e8 a5 30 00 00       	call   80104990 <acquire>
  ip->ref--;
801018eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018ef:	83 c4 10             	add    $0x10,%esp
801018f2:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
801018f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018fc:	5b                   	pop    %ebx
801018fd:	5e                   	pop    %esi
801018fe:	5f                   	pop    %edi
801018ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101900:	e9 2b 30 00 00       	jmp    80104930 <release>
80101905:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 60 09 11 80       	push   $0x80110960
80101910:	e8 7b 30 00 00       	call   80104990 <acquire>
    int r = ip->ref;
80101915:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101918:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010191f:	e8 0c 30 00 00       	call   80104930 <release>
    if(r == 1){
80101924:	83 c4 10             	add    $0x10,%esp
80101927:	83 fe 01             	cmp    $0x1,%esi
8010192a:	75 aa                	jne    801018d6 <iput+0x26>
8010192c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101932:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101935:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101938:	89 cf                	mov    %ecx,%edi
8010193a:	eb 0b                	jmp    80101947 <iput+0x97>
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101940:	83 c6 04             	add    $0x4,%esi
80101943:	39 fe                	cmp    %edi,%esi
80101945:	74 19                	je     80101960 <iput+0xb0>
    if(ip->addrs[i]){
80101947:	8b 16                	mov    (%esi),%edx
80101949:	85 d2                	test   %edx,%edx
8010194b:	74 f3                	je     80101940 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010194d:	8b 03                	mov    (%ebx),%eax
8010194f:	e8 6c f8 ff ff       	call   801011c0 <bfree>
      ip->addrs[i] = 0;
80101954:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010195a:	eb e4                	jmp    80101940 <iput+0x90>
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101960:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101966:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101969:	85 c0                	test   %eax,%eax
8010196b:	75 2d                	jne    8010199a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010196d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101970:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101977:	53                   	push   %ebx
80101978:	e8 53 fd ff ff       	call   801016d0 <iupdate>
      ip->type = 0;
8010197d:	31 c0                	xor    %eax,%eax
8010197f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101983:	89 1c 24             	mov    %ebx,(%esp)
80101986:	e8 45 fd ff ff       	call   801016d0 <iupdate>
      ip->valid = 0;
8010198b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101992:	83 c4 10             	add    $0x10,%esp
80101995:	e9 3c ff ff ff       	jmp    801018d6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010199a:	83 ec 08             	sub    $0x8,%esp
8010199d:	50                   	push   %eax
8010199e:	ff 33                	push   (%ebx)
801019a0:	e8 2b e7 ff ff       	call   801000d0 <bread>
801019a5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019a8:	83 c4 10             	add    $0x10,%esp
801019ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019b4:	8d 70 5c             	lea    0x5c(%eax),%esi
801019b7:	89 cf                	mov    %ecx,%edi
801019b9:	eb 0c                	jmp    801019c7 <iput+0x117>
801019bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019bf:	90                   	nop
801019c0:	83 c6 04             	add    $0x4,%esi
801019c3:	39 f7                	cmp    %esi,%edi
801019c5:	74 0f                	je     801019d6 <iput+0x126>
      if(a[j])
801019c7:	8b 16                	mov    (%esi),%edx
801019c9:	85 d2                	test   %edx,%edx
801019cb:	74 f3                	je     801019c0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019cd:	8b 03                	mov    (%ebx),%eax
801019cf:	e8 ec f7 ff ff       	call   801011c0 <bfree>
801019d4:	eb ea                	jmp    801019c0 <iput+0x110>
    brelse(bp);
801019d6:	83 ec 0c             	sub    $0xc,%esp
801019d9:	ff 75 e4             	push   -0x1c(%ebp)
801019dc:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019df:	e8 0c e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019e4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019ea:	8b 03                	mov    (%ebx),%eax
801019ec:	e8 cf f7 ff ff       	call   801011c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019f1:	83 c4 10             	add    $0x10,%esp
801019f4:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019fb:	00 00 00 
801019fe:	e9 6a ff ff ff       	jmp    8010196d <iput+0xbd>
80101a03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a10 <iunlockput>:
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	56                   	push   %esi
80101a14:	53                   	push   %ebx
80101a15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a18:	85 db                	test   %ebx,%ebx
80101a1a:	74 34                	je     80101a50 <iunlockput+0x40>
80101a1c:	83 ec 0c             	sub    $0xc,%esp
80101a1f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a22:	56                   	push   %esi
80101a23:	e8 48 2d 00 00       	call   80104770 <holdingsleep>
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	85 c0                	test   %eax,%eax
80101a2d:	74 21                	je     80101a50 <iunlockput+0x40>
80101a2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a32:	85 c0                	test   %eax,%eax
80101a34:	7e 1a                	jle    80101a50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	56                   	push   %esi
80101a3a:	e8 f1 2c 00 00       	call   80104730 <releasesleep>
  iput(ip);
80101a3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a42:	83 c4 10             	add    $0x10,%esp
}
80101a45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a48:	5b                   	pop    %ebx
80101a49:	5e                   	pop    %esi
80101a4a:	5d                   	pop    %ebp
  iput(ip);
80101a4b:	e9 60 fe ff ff       	jmp    801018b0 <iput>
    panic("iunlock");
80101a50:	83 ec 0c             	sub    $0xc,%esp
80101a53:	68 3f 78 10 80       	push   $0x8010783f
80101a58:	e8 23 e9 ff ff       	call   80100380 <panic>
80101a5d:	8d 76 00             	lea    0x0(%esi),%esi

80101a60 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	8b 55 08             	mov    0x8(%ebp),%edx
80101a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a69:	8b 0a                	mov    (%edx),%ecx
80101a6b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a6e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a71:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a74:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a78:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a7b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a7f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a83:	8b 52 58             	mov    0x58(%edx),%edx
80101a86:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a89:	5d                   	pop    %ebp
80101a8a:	c3                   	ret    
80101a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a8f:	90                   	nop

80101a90 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 1c             	sub    $0x1c,%esp
80101a99:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9f:	8b 75 10             	mov    0x10(%ebp),%esi
80101aa2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101aa5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101aa8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101aad:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ab0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ab3:	0f 84 a7 00 00 00    	je     80101b60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ab9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101abc:	8b 40 58             	mov    0x58(%eax),%eax
80101abf:	39 c6                	cmp    %eax,%esi
80101ac1:	0f 87 ba 00 00 00    	ja     80101b81 <readi+0xf1>
80101ac7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aca:	31 c9                	xor    %ecx,%ecx
80101acc:	89 da                	mov    %ebx,%edx
80101ace:	01 f2                	add    %esi,%edx
80101ad0:	0f 92 c1             	setb   %cl
80101ad3:	89 cf                	mov    %ecx,%edi
80101ad5:	0f 82 a6 00 00 00    	jb     80101b81 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101adb:	89 c1                	mov    %eax,%ecx
80101add:	29 f1                	sub    %esi,%ecx
80101adf:	39 d0                	cmp    %edx,%eax
80101ae1:	0f 43 cb             	cmovae %ebx,%ecx
80101ae4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ae7:	85 c9                	test   %ecx,%ecx
80101ae9:	74 67                	je     80101b52 <readi+0xc2>
80101aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101af3:	89 f2                	mov    %esi,%edx
80101af5:	c1 ea 09             	shr    $0x9,%edx
80101af8:	89 d8                	mov    %ebx,%eax
80101afa:	e8 51 f9 ff ff       	call   80101450 <bmap>
80101aff:	83 ec 08             	sub    $0x8,%esp
80101b02:	50                   	push   %eax
80101b03:	ff 33                	push   (%ebx)
80101b05:	e8 c6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b0a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b0d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b12:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b14:	89 f0                	mov    %esi,%eax
80101b16:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b1b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b1d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b20:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b22:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b26:	39 d9                	cmp    %ebx,%ecx
80101b28:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b2b:	83 c4 0c             	add    $0xc,%esp
80101b2e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b2f:	01 df                	add    %ebx,%edi
80101b31:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b33:	50                   	push   %eax
80101b34:	ff 75 e0             	push   -0x20(%ebp)
80101b37:	e8 b4 2f 00 00       	call   80104af0 <memmove>
    brelse(bp);
80101b3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b3f:	89 14 24             	mov    %edx,(%esp)
80101b42:	e8 a9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b47:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b4a:	83 c4 10             	add    $0x10,%esp
80101b4d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b50:	77 9e                	ja     80101af0 <readi+0x60>
  }
  return n;
80101b52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b58:	5b                   	pop    %ebx
80101b59:	5e                   	pop    %esi
80101b5a:	5f                   	pop    %edi
80101b5b:	5d                   	pop    %ebp
80101b5c:	c3                   	ret    
80101b5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b64:	66 83 f8 09          	cmp    $0x9,%ax
80101b68:	77 17                	ja     80101b81 <readi+0xf1>
80101b6a:	8b 04 c5 00 09 11 80 	mov    -0x7feef700(,%eax,8),%eax
80101b71:	85 c0                	test   %eax,%eax
80101b73:	74 0c                	je     80101b81 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b7b:	5b                   	pop    %ebx
80101b7c:	5e                   	pop    %esi
80101b7d:	5f                   	pop    %edi
80101b7e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b7f:	ff e0                	jmp    *%eax
      return -1;
80101b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b86:	eb cd                	jmp    80101b55 <readi+0xc5>
80101b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b8f:	90                   	nop

80101b90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	57                   	push   %edi
80101b94:	56                   	push   %esi
80101b95:	53                   	push   %ebx
80101b96:	83 ec 1c             	sub    $0x1c,%esp
80101b99:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b9f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ba2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ba7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101baa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bad:	8b 75 10             	mov    0x10(%ebp),%esi
80101bb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bb3:	0f 84 b7 00 00 00    	je     80101c70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bbc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bbf:	0f 87 e7 00 00 00    	ja     80101cac <writei+0x11c>
80101bc5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bc8:	31 d2                	xor    %edx,%edx
80101bca:	89 f8                	mov    %edi,%eax
80101bcc:	01 f0                	add    %esi,%eax
80101bce:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bd1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bd6:	0f 87 d0 00 00 00    	ja     80101cac <writei+0x11c>
80101bdc:	85 d2                	test   %edx,%edx
80101bde:	0f 85 c8 00 00 00    	jne    80101cac <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101be4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101beb:	85 ff                	test   %edi,%edi
80101bed:	74 72                	je     80101c61 <writei+0xd1>
80101bef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bf0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bf3:	89 f2                	mov    %esi,%edx
80101bf5:	c1 ea 09             	shr    $0x9,%edx
80101bf8:	89 f8                	mov    %edi,%eax
80101bfa:	e8 51 f8 ff ff       	call   80101450 <bmap>
80101bff:	83 ec 08             	sub    $0x8,%esp
80101c02:	50                   	push   %eax
80101c03:	ff 37                	push   (%edi)
80101c05:	e8 c6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c0a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c0f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c12:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c15:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c17:	89 f0                	mov    %esi,%eax
80101c19:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c1e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c20:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c24:	39 d9                	cmp    %ebx,%ecx
80101c26:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c29:	83 c4 0c             	add    $0xc,%esp
80101c2c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c2d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c2f:	ff 75 dc             	push   -0x24(%ebp)
80101c32:	50                   	push   %eax
80101c33:	e8 b8 2e 00 00       	call   80104af0 <memmove>
    log_write(bp);
80101c38:	89 3c 24             	mov    %edi,(%esp)
80101c3b:	e8 40 16 00 00       	call   80103280 <log_write>
    brelse(bp);
80101c40:	89 3c 24             	mov    %edi,(%esp)
80101c43:	e8 a8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c48:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c4b:	83 c4 10             	add    $0x10,%esp
80101c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c51:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c54:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c57:	77 97                	ja     80101bf0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c5c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c5f:	77 37                	ja     80101c98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c61:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c67:	5b                   	pop    %ebx
80101c68:	5e                   	pop    %esi
80101c69:	5f                   	pop    %edi
80101c6a:	5d                   	pop    %ebp
80101c6b:	c3                   	ret    
80101c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c74:	66 83 f8 09          	cmp    $0x9,%ax
80101c78:	77 32                	ja     80101cac <writei+0x11c>
80101c7a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101c81:	85 c0                	test   %eax,%eax
80101c83:	74 27                	je     80101cac <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c85:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c8f:	ff e0                	jmp    *%eax
80101c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c98:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c9b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c9e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101ca1:	50                   	push   %eax
80101ca2:	e8 29 fa ff ff       	call   801016d0 <iupdate>
80101ca7:	83 c4 10             	add    $0x10,%esp
80101caa:	eb b5                	jmp    80101c61 <writei+0xd1>
      return -1;
80101cac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cb1:	eb b1                	jmp    80101c64 <writei+0xd4>
80101cb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cc0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cc0:	55                   	push   %ebp
80101cc1:	89 e5                	mov    %esp,%ebp
80101cc3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cc6:	6a 0e                	push   $0xe
80101cc8:	ff 75 0c             	push   0xc(%ebp)
80101ccb:	ff 75 08             	push   0x8(%ebp)
80101cce:	e8 8d 2e 00 00       	call   80104b60 <strncmp>
}
80101cd3:	c9                   	leave  
80101cd4:	c3                   	ret    
80101cd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ce0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	57                   	push   %edi
80101ce4:	56                   	push   %esi
80101ce5:	53                   	push   %ebx
80101ce6:	83 ec 1c             	sub    $0x1c,%esp
80101ce9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cf1:	0f 85 85 00 00 00    	jne    80101d7c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cf7:	8b 53 58             	mov    0x58(%ebx),%edx
80101cfa:	31 ff                	xor    %edi,%edi
80101cfc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cff:	85 d2                	test   %edx,%edx
80101d01:	74 3e                	je     80101d41 <dirlookup+0x61>
80101d03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d07:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d08:	6a 10                	push   $0x10
80101d0a:	57                   	push   %edi
80101d0b:	56                   	push   %esi
80101d0c:	53                   	push   %ebx
80101d0d:	e8 7e fd ff ff       	call   80101a90 <readi>
80101d12:	83 c4 10             	add    $0x10,%esp
80101d15:	83 f8 10             	cmp    $0x10,%eax
80101d18:	75 55                	jne    80101d6f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d1f:	74 18                	je     80101d39 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d21:	83 ec 04             	sub    $0x4,%esp
80101d24:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d27:	6a 0e                	push   $0xe
80101d29:	50                   	push   %eax
80101d2a:	ff 75 0c             	push   0xc(%ebp)
80101d2d:	e8 2e 2e 00 00       	call   80104b60 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d32:	83 c4 10             	add    $0x10,%esp
80101d35:	85 c0                	test   %eax,%eax
80101d37:	74 17                	je     80101d50 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d39:	83 c7 10             	add    $0x10,%edi
80101d3c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d3f:	72 c7                	jb     80101d08 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d44:	31 c0                	xor    %eax,%eax
}
80101d46:	5b                   	pop    %ebx
80101d47:	5e                   	pop    %esi
80101d48:	5f                   	pop    %edi
80101d49:	5d                   	pop    %ebp
80101d4a:	c3                   	ret    
80101d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d4f:	90                   	nop
      if(poff)
80101d50:	8b 45 10             	mov    0x10(%ebp),%eax
80101d53:	85 c0                	test   %eax,%eax
80101d55:	74 05                	je     80101d5c <dirlookup+0x7c>
        *poff = off;
80101d57:	8b 45 10             	mov    0x10(%ebp),%eax
80101d5a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d5c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d60:	8b 03                	mov    (%ebx),%eax
80101d62:	e8 e9 f5 ff ff       	call   80101350 <iget>
}
80101d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d6a:	5b                   	pop    %ebx
80101d6b:	5e                   	pop    %esi
80101d6c:	5f                   	pop    %edi
80101d6d:	5d                   	pop    %ebp
80101d6e:	c3                   	ret    
      panic("dirlookup read");
80101d6f:	83 ec 0c             	sub    $0xc,%esp
80101d72:	68 59 78 10 80       	push   $0x80107859
80101d77:	e8 04 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d7c:	83 ec 0c             	sub    $0xc,%esp
80101d7f:	68 47 78 10 80       	push   $0x80107847
80101d84:	e8 f7 e5 ff ff       	call   80100380 <panic>
80101d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d90:	55                   	push   %ebp
80101d91:	89 e5                	mov    %esp,%ebp
80101d93:	57                   	push   %edi
80101d94:	56                   	push   %esi
80101d95:	53                   	push   %ebx
80101d96:	89 c3                	mov    %eax,%ebx
80101d98:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d9b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d9e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101da1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101da4:	0f 84 64 01 00 00    	je     80101f0e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101daa:	e8 01 1f 00 00       	call   80103cb0 <myproc>
  acquire(&icache.lock);
80101daf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101db2:	8b 70 6c             	mov    0x6c(%eax),%esi
  acquire(&icache.lock);
80101db5:	68 60 09 11 80       	push   $0x80110960
80101dba:	e8 d1 2b 00 00       	call   80104990 <acquire>
  ip->ref++;
80101dbf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dc3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101dca:	e8 61 2b 00 00       	call   80104930 <release>
80101dcf:	83 c4 10             	add    $0x10,%esp
80101dd2:	eb 07                	jmp    80101ddb <namex+0x4b>
80101dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101dd8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ddb:	0f b6 03             	movzbl (%ebx),%eax
80101dde:	3c 2f                	cmp    $0x2f,%al
80101de0:	74 f6                	je     80101dd8 <namex+0x48>
  if(*path == 0)
80101de2:	84 c0                	test   %al,%al
80101de4:	0f 84 06 01 00 00    	je     80101ef0 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dea:	0f b6 03             	movzbl (%ebx),%eax
80101ded:	84 c0                	test   %al,%al
80101def:	0f 84 10 01 00 00    	je     80101f05 <namex+0x175>
80101df5:	89 df                	mov    %ebx,%edi
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	0f 84 06 01 00 00    	je     80101f05 <namex+0x175>
80101dff:	90                   	nop
80101e00:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e04:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	74 04                	je     80101e0f <namex+0x7f>
80101e0b:	84 c0                	test   %al,%al
80101e0d:	75 f1                	jne    80101e00 <namex+0x70>
  len = path - s;
80101e0f:	89 f8                	mov    %edi,%eax
80101e11:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e13:	83 f8 0d             	cmp    $0xd,%eax
80101e16:	0f 8e ac 00 00 00    	jle    80101ec8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e1c:	83 ec 04             	sub    $0x4,%esp
80101e1f:	6a 0e                	push   $0xe
80101e21:	53                   	push   %ebx
    path++;
80101e22:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e24:	ff 75 e4             	push   -0x1c(%ebp)
80101e27:	e8 c4 2c 00 00       	call   80104af0 <memmove>
80101e2c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e2f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e32:	75 0c                	jne    80101e40 <namex+0xb0>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e38:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e3b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e3e:	74 f8                	je     80101e38 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	56                   	push   %esi
80101e44:	e8 37 f9 ff ff       	call   80101780 <ilock>
    if(ip->type != T_DIR){
80101e49:	83 c4 10             	add    $0x10,%esp
80101e4c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e51:	0f 85 cd 00 00 00    	jne    80101f24 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e57:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e5a:	85 c0                	test   %eax,%eax
80101e5c:	74 09                	je     80101e67 <namex+0xd7>
80101e5e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e61:	0f 84 22 01 00 00    	je     80101f89 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e67:	83 ec 04             	sub    $0x4,%esp
80101e6a:	6a 00                	push   $0x0
80101e6c:	ff 75 e4             	push   -0x1c(%ebp)
80101e6f:	56                   	push   %esi
80101e70:	e8 6b fe ff ff       	call   80101ce0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e75:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101e78:	83 c4 10             	add    $0x10,%esp
80101e7b:	89 c7                	mov    %eax,%edi
80101e7d:	85 c0                	test   %eax,%eax
80101e7f:	0f 84 e1 00 00 00    	je     80101f66 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e85:	83 ec 0c             	sub    $0xc,%esp
80101e88:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101e8b:	52                   	push   %edx
80101e8c:	e8 df 28 00 00       	call   80104770 <holdingsleep>
80101e91:	83 c4 10             	add    $0x10,%esp
80101e94:	85 c0                	test   %eax,%eax
80101e96:	0f 84 30 01 00 00    	je     80101fcc <namex+0x23c>
80101e9c:	8b 56 08             	mov    0x8(%esi),%edx
80101e9f:	85 d2                	test   %edx,%edx
80101ea1:	0f 8e 25 01 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101ea7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eaa:	83 ec 0c             	sub    $0xc,%esp
80101ead:	52                   	push   %edx
80101eae:	e8 7d 28 00 00       	call   80104730 <releasesleep>
  iput(ip);
80101eb3:	89 34 24             	mov    %esi,(%esp)
80101eb6:	89 fe                	mov    %edi,%esi
80101eb8:	e8 f3 f9 ff ff       	call   801018b0 <iput>
80101ebd:	83 c4 10             	add    $0x10,%esp
80101ec0:	e9 16 ff ff ff       	jmp    80101ddb <namex+0x4b>
80101ec5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ec8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101ecb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101ece:	83 ec 04             	sub    $0x4,%esp
80101ed1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ed4:	50                   	push   %eax
80101ed5:	53                   	push   %ebx
    name[len] = 0;
80101ed6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ed8:	ff 75 e4             	push   -0x1c(%ebp)
80101edb:	e8 10 2c 00 00       	call   80104af0 <memmove>
    name[len] = 0;
80101ee0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ee3:	83 c4 10             	add    $0x10,%esp
80101ee6:	c6 02 00             	movb   $0x0,(%edx)
80101ee9:	e9 41 ff ff ff       	jmp    80101e2f <namex+0x9f>
80101eee:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ef0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ef3:	85 c0                	test   %eax,%eax
80101ef5:	0f 85 be 00 00 00    	jne    80101fb9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101efb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101efe:	89 f0                	mov    %esi,%eax
80101f00:	5b                   	pop    %ebx
80101f01:	5e                   	pop    %esi
80101f02:	5f                   	pop    %edi
80101f03:	5d                   	pop    %ebp
80101f04:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f08:	89 df                	mov    %ebx,%edi
80101f0a:	31 c0                	xor    %eax,%eax
80101f0c:	eb c0                	jmp    80101ece <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f0e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f13:	b8 01 00 00 00       	mov    $0x1,%eax
80101f18:	e8 33 f4 ff ff       	call   80101350 <iget>
80101f1d:	89 c6                	mov    %eax,%esi
80101f1f:	e9 b7 fe ff ff       	jmp    80101ddb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f24:	83 ec 0c             	sub    $0xc,%esp
80101f27:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f2a:	53                   	push   %ebx
80101f2b:	e8 40 28 00 00       	call   80104770 <holdingsleep>
80101f30:	83 c4 10             	add    $0x10,%esp
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 84 91 00 00 00    	je     80101fcc <namex+0x23c>
80101f3b:	8b 46 08             	mov    0x8(%esi),%eax
80101f3e:	85 c0                	test   %eax,%eax
80101f40:	0f 8e 86 00 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f46:	83 ec 0c             	sub    $0xc,%esp
80101f49:	53                   	push   %ebx
80101f4a:	e8 e1 27 00 00       	call   80104730 <releasesleep>
  iput(ip);
80101f4f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f52:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f54:	e8 57 f9 ff ff       	call   801018b0 <iput>
      return 0;
80101f59:	83 c4 10             	add    $0x10,%esp
}
80101f5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f5f:	89 f0                	mov    %esi,%eax
80101f61:	5b                   	pop    %ebx
80101f62:	5e                   	pop    %esi
80101f63:	5f                   	pop    %edi
80101f64:	5d                   	pop    %ebp
80101f65:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f66:	83 ec 0c             	sub    $0xc,%esp
80101f69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f6c:	52                   	push   %edx
80101f6d:	e8 fe 27 00 00       	call   80104770 <holdingsleep>
80101f72:	83 c4 10             	add    $0x10,%esp
80101f75:	85 c0                	test   %eax,%eax
80101f77:	74 53                	je     80101fcc <namex+0x23c>
80101f79:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f7c:	85 c9                	test   %ecx,%ecx
80101f7e:	7e 4c                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f83:	83 ec 0c             	sub    $0xc,%esp
80101f86:	52                   	push   %edx
80101f87:	eb c1                	jmp    80101f4a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f89:	83 ec 0c             	sub    $0xc,%esp
80101f8c:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f8f:	53                   	push   %ebx
80101f90:	e8 db 27 00 00       	call   80104770 <holdingsleep>
80101f95:	83 c4 10             	add    $0x10,%esp
80101f98:	85 c0                	test   %eax,%eax
80101f9a:	74 30                	je     80101fcc <namex+0x23c>
80101f9c:	8b 7e 08             	mov    0x8(%esi),%edi
80101f9f:	85 ff                	test   %edi,%edi
80101fa1:	7e 29                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	53                   	push   %ebx
80101fa7:	e8 84 27 00 00       	call   80104730 <releasesleep>
}
80101fac:	83 c4 10             	add    $0x10,%esp
}
80101faf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fb2:	89 f0                	mov    %esi,%eax
80101fb4:	5b                   	pop    %ebx
80101fb5:	5e                   	pop    %esi
80101fb6:	5f                   	pop    %edi
80101fb7:	5d                   	pop    %ebp
80101fb8:	c3                   	ret    
    iput(ip);
80101fb9:	83 ec 0c             	sub    $0xc,%esp
80101fbc:	56                   	push   %esi
    return 0;
80101fbd:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fbf:	e8 ec f8 ff ff       	call   801018b0 <iput>
    return 0;
80101fc4:	83 c4 10             	add    $0x10,%esp
80101fc7:	e9 2f ff ff ff       	jmp    80101efb <namex+0x16b>
    panic("iunlock");
80101fcc:	83 ec 0c             	sub    $0xc,%esp
80101fcf:	68 3f 78 10 80       	push   $0x8010783f
80101fd4:	e8 a7 e3 ff ff       	call   80100380 <panic>
80101fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fe0 <dirlink>:
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	57                   	push   %edi
80101fe4:	56                   	push   %esi
80101fe5:	53                   	push   %ebx
80101fe6:	83 ec 20             	sub    $0x20,%esp
80101fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fec:	6a 00                	push   $0x0
80101fee:	ff 75 0c             	push   0xc(%ebp)
80101ff1:	53                   	push   %ebx
80101ff2:	e8 e9 fc ff ff       	call   80101ce0 <dirlookup>
80101ff7:	83 c4 10             	add    $0x10,%esp
80101ffa:	85 c0                	test   %eax,%eax
80101ffc:	75 67                	jne    80102065 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ffe:	8b 7b 58             	mov    0x58(%ebx),%edi
80102001:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102004:	85 ff                	test   %edi,%edi
80102006:	74 29                	je     80102031 <dirlink+0x51>
80102008:	31 ff                	xor    %edi,%edi
8010200a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010200d:	eb 09                	jmp    80102018 <dirlink+0x38>
8010200f:	90                   	nop
80102010:	83 c7 10             	add    $0x10,%edi
80102013:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102016:	73 19                	jae    80102031 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102018:	6a 10                	push   $0x10
8010201a:	57                   	push   %edi
8010201b:	56                   	push   %esi
8010201c:	53                   	push   %ebx
8010201d:	e8 6e fa ff ff       	call   80101a90 <readi>
80102022:	83 c4 10             	add    $0x10,%esp
80102025:	83 f8 10             	cmp    $0x10,%eax
80102028:	75 4e                	jne    80102078 <dirlink+0x98>
    if(de.inum == 0)
8010202a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010202f:	75 df                	jne    80102010 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102031:	83 ec 04             	sub    $0x4,%esp
80102034:	8d 45 da             	lea    -0x26(%ebp),%eax
80102037:	6a 0e                	push   $0xe
80102039:	ff 75 0c             	push   0xc(%ebp)
8010203c:	50                   	push   %eax
8010203d:	e8 6e 2b 00 00       	call   80104bb0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102042:	6a 10                	push   $0x10
  de.inum = inum;
80102044:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102047:	57                   	push   %edi
80102048:	56                   	push   %esi
80102049:	53                   	push   %ebx
  de.inum = inum;
8010204a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010204e:	e8 3d fb ff ff       	call   80101b90 <writei>
80102053:	83 c4 20             	add    $0x20,%esp
80102056:	83 f8 10             	cmp    $0x10,%eax
80102059:	75 2a                	jne    80102085 <dirlink+0xa5>
  return 0;
8010205b:	31 c0                	xor    %eax,%eax
}
8010205d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102060:	5b                   	pop    %ebx
80102061:	5e                   	pop    %esi
80102062:	5f                   	pop    %edi
80102063:	5d                   	pop    %ebp
80102064:	c3                   	ret    
    iput(ip);
80102065:	83 ec 0c             	sub    $0xc,%esp
80102068:	50                   	push   %eax
80102069:	e8 42 f8 ff ff       	call   801018b0 <iput>
    return -1;
8010206e:	83 c4 10             	add    $0x10,%esp
80102071:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102076:	eb e5                	jmp    8010205d <dirlink+0x7d>
      panic("dirlink read");
80102078:	83 ec 0c             	sub    $0xc,%esp
8010207b:	68 68 78 10 80       	push   $0x80107868
80102080:	e8 fb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 a6 7e 10 80       	push   $0x80107ea6
8010208d:	e8 ee e2 ff ff       	call   80100380 <panic>
80102092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020a0 <namei>:

struct inode*
namei(char *path)
{
801020a0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020a1:	31 d2                	xor    %edx,%edx
{
801020a3:	89 e5                	mov    %esp,%ebp
801020a5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020a8:	8b 45 08             	mov    0x8(%ebp),%eax
801020ab:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020ae:	e8 dd fc ff ff       	call   80101d90 <namex>
}
801020b3:	c9                   	leave  
801020b4:	c3                   	ret    
801020b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020c0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020c0:	55                   	push   %ebp
  return namex(path, 1, name);
801020c1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020c6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ce:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020cf:	e9 bc fc ff ff       	jmp    80101d90 <namex>
801020d4:	66 90                	xchg   %ax,%ax
801020d6:	66 90                	xchg   %ax,%ax
801020d8:	66 90                	xchg   %ax,%ax
801020da:	66 90                	xchg   %ax,%ax
801020dc:	66 90                	xchg   %ax,%ax
801020de:	66 90                	xchg   %ax,%ax

801020e0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	57                   	push   %edi
801020e4:	56                   	push   %esi
801020e5:	53                   	push   %ebx
801020e6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020e9:	85 c0                	test   %eax,%eax
801020eb:	0f 84 b4 00 00 00    	je     801021a5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020f1:	8b 70 08             	mov    0x8(%eax),%esi
801020f4:	89 c3                	mov    %eax,%ebx
801020f6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020fc:	0f 87 96 00 00 00    	ja     80102198 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102102:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010210e:	66 90                	xchg   %ax,%ax
80102110:	89 ca                	mov    %ecx,%edx
80102112:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102113:	83 e0 c0             	and    $0xffffffc0,%eax
80102116:	3c 40                	cmp    $0x40,%al
80102118:	75 f6                	jne    80102110 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010211a:	31 ff                	xor    %edi,%edi
8010211c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102121:	89 f8                	mov    %edi,%eax
80102123:	ee                   	out    %al,(%dx)
80102124:	b8 01 00 00 00       	mov    $0x1,%eax
80102129:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010212e:	ee                   	out    %al,(%dx)
8010212f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102134:	89 f0                	mov    %esi,%eax
80102136:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102137:	89 f0                	mov    %esi,%eax
80102139:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010213e:	c1 f8 08             	sar    $0x8,%eax
80102141:	ee                   	out    %al,(%dx)
80102142:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102147:	89 f8                	mov    %edi,%eax
80102149:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010214a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010214e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102153:	c1 e0 04             	shl    $0x4,%eax
80102156:	83 e0 10             	and    $0x10,%eax
80102159:	83 c8 e0             	or     $0xffffffe0,%eax
8010215c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010215d:	f6 03 04             	testb  $0x4,(%ebx)
80102160:	75 16                	jne    80102178 <idestart+0x98>
80102162:	b8 20 00 00 00       	mov    $0x20,%eax
80102167:	89 ca                	mov    %ecx,%edx
80102169:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010216a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010216d:	5b                   	pop    %ebx
8010216e:	5e                   	pop    %esi
8010216f:	5f                   	pop    %edi
80102170:	5d                   	pop    %ebp
80102171:	c3                   	ret    
80102172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102178:	b8 30 00 00 00       	mov    $0x30,%eax
8010217d:	89 ca                	mov    %ecx,%edx
8010217f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102180:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102185:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102188:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010218d:	fc                   	cld    
8010218e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102190:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102193:	5b                   	pop    %ebx
80102194:	5e                   	pop    %esi
80102195:	5f                   	pop    %edi
80102196:	5d                   	pop    %ebp
80102197:	c3                   	ret    
    panic("incorrect blockno");
80102198:	83 ec 0c             	sub    $0xc,%esp
8010219b:	68 d4 78 10 80       	push   $0x801078d4
801021a0:	e8 db e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 cb 78 10 80       	push   $0x801078cb
801021ad:	e8 ce e1 ff ff       	call   80100380 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021c0 <ideinit>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021c6:	68 e6 78 10 80       	push   $0x801078e6
801021cb:	68 00 26 11 80       	push   $0x80112600
801021d0:	e8 eb 25 00 00       	call   801047c0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021d5:	58                   	pop    %eax
801021d6:	a1 a4 37 11 80       	mov    0x801137a4,%eax
801021db:	5a                   	pop    %edx
801021dc:	83 e8 01             	sub    $0x1,%eax
801021df:	50                   	push   %eax
801021e0:	6a 0e                	push   $0xe
801021e2:	e8 99 02 00 00       	call   80102480 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021e7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ea:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ef:	90                   	nop
801021f0:	ec                   	in     (%dx),%al
801021f1:	83 e0 c0             	and    $0xffffffc0,%eax
801021f4:	3c 40                	cmp    $0x40,%al
801021f6:	75 f8                	jne    801021f0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021f8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021fd:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102202:	ee                   	out    %al,(%dx)
80102203:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102208:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010220d:	eb 06                	jmp    80102215 <ideinit+0x55>
8010220f:	90                   	nop
  for(i=0; i<1000; i++){
80102210:	83 e9 01             	sub    $0x1,%ecx
80102213:	74 0f                	je     80102224 <ideinit+0x64>
80102215:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102216:	84 c0                	test   %al,%al
80102218:	74 f6                	je     80102210 <ideinit+0x50>
      havedisk1 = 1;
8010221a:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
80102221:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102224:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102229:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010222e:	ee                   	out    %al,(%dx)
}
8010222f:	c9                   	leave  
80102230:	c3                   	ret    
80102231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010223f:	90                   	nop

80102240 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	57                   	push   %edi
80102244:	56                   	push   %esi
80102245:	53                   	push   %ebx
80102246:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102249:	68 00 26 11 80       	push   $0x80112600
8010224e:	e8 3d 27 00 00       	call   80104990 <acquire>

  if((b = idequeue) == 0){
80102253:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
80102259:	83 c4 10             	add    $0x10,%esp
8010225c:	85 db                	test   %ebx,%ebx
8010225e:	74 63                	je     801022c3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102260:	8b 43 58             	mov    0x58(%ebx),%eax
80102263:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102268:	8b 33                	mov    (%ebx),%esi
8010226a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102270:	75 2f                	jne    801022a1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102272:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227e:	66 90                	xchg   %ax,%ax
80102280:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102281:	89 c1                	mov    %eax,%ecx
80102283:	83 e1 c0             	and    $0xffffffc0,%ecx
80102286:	80 f9 40             	cmp    $0x40,%cl
80102289:	75 f5                	jne    80102280 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010228b:	a8 21                	test   $0x21,%al
8010228d:	75 12                	jne    801022a1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010228f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102292:	b9 80 00 00 00       	mov    $0x80,%ecx
80102297:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010229c:	fc                   	cld    
8010229d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010229f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022a1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022a4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022a7:	83 ce 02             	or     $0x2,%esi
801022aa:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022ac:	53                   	push   %ebx
801022ad:	e8 fe 21 00 00       	call   801044b0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022b2:	a1 e4 25 11 80       	mov    0x801125e4,%eax
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	85 c0                	test   %eax,%eax
801022bc:	74 05                	je     801022c3 <ideintr+0x83>
    idestart(idequeue);
801022be:	e8 1d fe ff ff       	call   801020e0 <idestart>
    release(&idelock);
801022c3:	83 ec 0c             	sub    $0xc,%esp
801022c6:	68 00 26 11 80       	push   $0x80112600
801022cb:	e8 60 26 00 00       	call   80104930 <release>

  release(&idelock);
}
801022d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022d3:	5b                   	pop    %ebx
801022d4:	5e                   	pop    %esi
801022d5:	5f                   	pop    %edi
801022d6:	5d                   	pop    %ebp
801022d7:	c3                   	ret    
801022d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022df:	90                   	nop

801022e0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 10             	sub    $0x10,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801022ed:	50                   	push   %eax
801022ee:	e8 7d 24 00 00       	call   80104770 <holdingsleep>
801022f3:	83 c4 10             	add    $0x10,%esp
801022f6:	85 c0                	test   %eax,%eax
801022f8:	0f 84 c3 00 00 00    	je     801023c1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 e0 06             	and    $0x6,%eax
80102303:	83 f8 02             	cmp    $0x2,%eax
80102306:	0f 84 a8 00 00 00    	je     801023b4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010230c:	8b 53 04             	mov    0x4(%ebx),%edx
8010230f:	85 d2                	test   %edx,%edx
80102311:	74 0d                	je     80102320 <iderw+0x40>
80102313:	a1 e0 25 11 80       	mov    0x801125e0,%eax
80102318:	85 c0                	test   %eax,%eax
8010231a:	0f 84 87 00 00 00    	je     801023a7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102320:	83 ec 0c             	sub    $0xc,%esp
80102323:	68 00 26 11 80       	push   $0x80112600
80102328:	e8 63 26 00 00       	call   80104990 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010232d:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
80102332:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102339:	83 c4 10             	add    $0x10,%esp
8010233c:	85 c0                	test   %eax,%eax
8010233e:	74 60                	je     801023a0 <iderw+0xc0>
80102340:	89 c2                	mov    %eax,%edx
80102342:	8b 40 58             	mov    0x58(%eax),%eax
80102345:	85 c0                	test   %eax,%eax
80102347:	75 f7                	jne    80102340 <iderw+0x60>
80102349:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010234c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010234e:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
80102354:	74 3a                	je     80102390 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102356:	8b 03                	mov    (%ebx),%eax
80102358:	83 e0 06             	and    $0x6,%eax
8010235b:	83 f8 02             	cmp    $0x2,%eax
8010235e:	74 1b                	je     8010237b <iderw+0x9b>
    sleep(b, &idelock);
80102360:	83 ec 08             	sub    $0x8,%esp
80102363:	68 00 26 11 80       	push   $0x80112600
80102368:	53                   	push   %ebx
80102369:	e8 82 20 00 00       	call   801043f0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010236e:	8b 03                	mov    (%ebx),%eax
80102370:	83 c4 10             	add    $0x10,%esp
80102373:	83 e0 06             	and    $0x6,%eax
80102376:	83 f8 02             	cmp    $0x2,%eax
80102379:	75 e5                	jne    80102360 <iderw+0x80>
  }


  release(&idelock);
8010237b:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
80102382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102385:	c9                   	leave  
  release(&idelock);
80102386:	e9 a5 25 00 00       	jmp    80104930 <release>
8010238b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010238f:	90                   	nop
    idestart(b);
80102390:	89 d8                	mov    %ebx,%eax
80102392:	e8 49 fd ff ff       	call   801020e0 <idestart>
80102397:	eb bd                	jmp    80102356 <iderw+0x76>
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023a0:	ba e4 25 11 80       	mov    $0x801125e4,%edx
801023a5:	eb a5                	jmp    8010234c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023a7:	83 ec 0c             	sub    $0xc,%esp
801023aa:	68 15 79 10 80       	push   $0x80107915
801023af:	e8 cc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 00 79 10 80       	push   $0x80107900
801023bc:	e8 bf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	68 ea 78 10 80       	push   $0x801078ea
801023c9:	e8 b2 df ff ff       	call   80100380 <panic>
801023ce:	66 90                	xchg   %ax,%ax

801023d0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023d0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023d1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801023d8:	00 c0 fe 
{
801023db:	89 e5                	mov    %esp,%ebp
801023dd:	56                   	push   %esi
801023de:	53                   	push   %ebx
  ioapic->reg = reg;
801023df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023e6:	00 00 00 
  return ioapic->data;
801023e9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801023ef:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023f2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023f8:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023fe:	0f b6 15 a0 37 11 80 	movzbl 0x801137a0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102405:	c1 ee 10             	shr    $0x10,%esi
80102408:	89 f0                	mov    %esi,%eax
8010240a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010240d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102410:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102413:	39 c2                	cmp    %eax,%edx
80102415:	74 16                	je     8010242d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102417:	83 ec 0c             	sub    $0xc,%esp
8010241a:	68 34 79 10 80       	push   $0x80107934
8010241f:	e8 7c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102424:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010242a:	83 c4 10             	add    $0x10,%esp
8010242d:	83 c6 21             	add    $0x21,%esi
{
80102430:	ba 10 00 00 00       	mov    $0x10,%edx
80102435:	b8 20 00 00 00       	mov    $0x20,%eax
8010243a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102440:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102442:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102444:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
8010244a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010244d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102453:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102456:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102459:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010245c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010245e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102464:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010246b:	39 f0                	cmp    %esi,%eax
8010246d:	75 d1                	jne    80102440 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010246f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102472:	5b                   	pop    %ebx
80102473:	5e                   	pop    %esi
80102474:	5d                   	pop    %ebp
80102475:	c3                   	ret    
80102476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010247d:	8d 76 00             	lea    0x0(%esi),%esi

80102480 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102480:	55                   	push   %ebp
  ioapic->reg = reg;
80102481:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102487:	89 e5                	mov    %esp,%ebp
80102489:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010248c:	8d 50 20             	lea    0x20(%eax),%edx
8010248f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102493:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102495:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010249b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010249e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a6:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024ab:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024ae:	89 50 10             	mov    %edx,0x10(%eax)
}
801024b1:	5d                   	pop    %ebp
801024b2:	c3                   	ret    
801024b3:	66 90                	xchg   %ax,%ax
801024b5:	66 90                	xchg   %ax,%ax
801024b7:	66 90                	xchg   %ax,%ax
801024b9:	66 90                	xchg   %ax,%ax
801024bb:	66 90                	xchg   %ax,%ax
801024bd:	66 90                	xchg   %ax,%ax
801024bf:	90                   	nop

801024c0 <get_rmap>:
}rmap;


int 
get_rmap(uint pa)
{ 
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	53                   	push   %ebx
801024c4:	83 ec 14             	sub    $0x14,%esp
  int rmap_index;
  if(rmap.use_lock)
    acquire(&rmap.lock);
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
801024c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(rmap.use_lock)
801024ca:	8b 0d 80 26 11 80    	mov    0x80112680,%ecx
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
801024d0:	c1 eb 0c             	shr    $0xc,%ebx
  if(rmap.use_lock)
801024d3:	85 c9                	test   %ecx,%ecx
801024d5:	75 11                	jne    801024e8 <get_rmap+0x28>
  int value=rmap.ref_count[rmap_index];
801024d7:	8b 04 9d b8 26 11 80 	mov    -0x7feed948(,%ebx,4),%eax
  if(rmap.use_lock)
    release(&rmap.lock);
  return value;
}
801024de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024e1:	c9                   	leave  
801024e2:	c3                   	ret    
801024e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024e7:	90                   	nop
    acquire(&rmap.lock);
801024e8:	83 ec 0c             	sub    $0xc,%esp
801024eb:	68 84 26 11 80       	push   $0x80112684
801024f0:	e8 9b 24 00 00       	call   80104990 <acquire>
  if(rmap.use_lock)
801024f5:	8b 15 80 26 11 80    	mov    0x80112680,%edx
  int value=rmap.ref_count[rmap_index];
801024fb:	8b 04 9d b8 26 11 80 	mov    -0x7feed948(,%ebx,4),%eax
  if(rmap.use_lock)
80102502:	83 c4 10             	add    $0x10,%esp
80102505:	85 d2                	test   %edx,%edx
80102507:	74 d5                	je     801024de <get_rmap+0x1e>
    release(&rmap.lock);
80102509:	83 ec 0c             	sub    $0xc,%esp
8010250c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010250f:	68 84 26 11 80       	push   $0x80112684
80102514:	e8 17 24 00 00       	call   80104930 <release>
  return value;
80102519:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010251c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    release(&rmap.lock);
8010251f:	83 c4 10             	add    $0x10,%esp
}
80102522:	c9                   	leave  
80102523:	c3                   	ret    
80102524:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010252b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010252f:	90                   	nop

80102530 <set_rmap>:
void 
set_rmap(uint pa,int value)
{
80102530:	55                   	push   %ebp
  int rmap_index;
  if(rmap.use_lock)
80102531:	8b 15 80 26 11 80    	mov    0x80112680,%edx
{
80102537:	89 e5                	mov    %esp,%ebp
80102539:	56                   	push   %esi
8010253a:	8b 75 0c             	mov    0xc(%ebp),%esi
8010253d:	53                   	push   %ebx
8010253e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(rmap.use_lock)
80102541:	85 d2                	test   %edx,%edx
80102543:	75 1b                	jne    80102560 <set_rmap+0x30>
    acquire(&rmap.lock);
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
80102545:	c1 eb 0c             	shr    $0xc,%ebx
  rmap.ref_count[rmap_index]=value;
80102548:	89 34 9d b8 26 11 80 	mov    %esi,-0x7feed948(,%ebx,4)
  if(rmap.use_lock)
    release(&rmap.lock);
}
8010254f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102552:	5b                   	pop    %ebx
80102553:	5e                   	pop    %esi
80102554:	5d                   	pop    %ebp
80102555:	c3                   	ret    
80102556:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010255d:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&rmap.lock);
80102560:	83 ec 0c             	sub    $0xc,%esp
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
80102563:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&rmap.lock);
80102566:	68 84 26 11 80       	push   $0x80112684
8010256b:	e8 20 24 00 00       	call   80104990 <acquire>
  if(rmap.use_lock)
80102570:	a1 80 26 11 80       	mov    0x80112680,%eax
  rmap.ref_count[rmap_index]=value;
80102575:	89 34 9d b8 26 11 80 	mov    %esi,-0x7feed948(,%ebx,4)
  if(rmap.use_lock)
8010257c:	83 c4 10             	add    $0x10,%esp
8010257f:	85 c0                	test   %eax,%eax
80102581:	74 cc                	je     8010254f <set_rmap+0x1f>
    release(&rmap.lock);
80102583:	c7 45 08 84 26 11 80 	movl   $0x80112684,0x8(%ebp)
}
8010258a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010258d:	5b                   	pop    %ebx
8010258e:	5e                   	pop    %esi
8010258f:	5d                   	pop    %ebp
    release(&rmap.lock);
80102590:	e9 9b 23 00 00       	jmp    80104930 <release>
80102595:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010259c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801025a0 <inc_rmap>:
void 
inc_rmap(uint pa)
{
801025a0:	55                   	push   %ebp
801025a1:	89 e5                	mov    %esp,%ebp
801025a3:	53                   	push   %ebx
801025a4:	83 ec 04             	sub    $0x4,%esp
  int rmap_index;
  if(rmap.use_lock)
801025a7:	8b 15 80 26 11 80    	mov    0x80112680,%edx
{
801025ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(rmap.use_lock)
801025b0:	85 d2                	test   %edx,%edx
801025b2:	75 1c                	jne    801025d0 <inc_rmap+0x30>
    acquire(&rmap.lock);
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
801025b4:	89 d8                	mov    %ebx,%eax
801025b6:	c1 e8 0c             	shr    $0xc,%eax
  rmap.ref_count[rmap_index]++;
801025b9:	83 04 85 b8 26 11 80 	addl   $0x1,-0x7feed948(,%eax,4)
801025c0:	01 
  if(rmap.use_lock)
    release(&rmap.lock);
}
801025c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025c4:	c9                   	leave  
801025c5:	c3                   	ret    
801025c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025cd:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&rmap.lock);
801025d0:	83 ec 0c             	sub    $0xc,%esp
801025d3:	68 84 26 11 80       	push   $0x80112684
801025d8:	e8 b3 23 00 00       	call   80104990 <acquire>
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
801025dd:	89 d8                	mov    %ebx,%eax
  if(rmap.use_lock)
801025df:	83 c4 10             	add    $0x10,%esp
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
801025e2:	c1 e8 0c             	shr    $0xc,%eax
  rmap.ref_count[rmap_index]++;
801025e5:	83 04 85 b8 26 11 80 	addl   $0x1,-0x7feed948(,%eax,4)
801025ec:	01 
  if(rmap.use_lock)
801025ed:	a1 80 26 11 80       	mov    0x80112680,%eax
801025f2:	85 c0                	test   %eax,%eax
801025f4:	74 cb                	je     801025c1 <inc_rmap+0x21>
    release(&rmap.lock);
801025f6:	c7 45 08 84 26 11 80 	movl   $0x80112684,0x8(%ebp)
}
801025fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102600:	c9                   	leave  
    release(&rmap.lock);
80102601:	e9 2a 23 00 00       	jmp    80104930 <release>
80102606:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010260d:	8d 76 00             	lea    0x0(%esi),%esi

80102610 <dec_rmap>:
void 
dec_rmap(uint pa)
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	53                   	push   %ebx
80102614:	83 ec 04             	sub    $0x4,%esp
  int rmap_index;
  if(rmap.use_lock)
80102617:	8b 15 80 26 11 80    	mov    0x80112680,%edx
{
8010261d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(rmap.use_lock)
80102620:	85 d2                	test   %edx,%edx
80102622:	75 1c                	jne    80102640 <dec_rmap+0x30>
    acquire(&rmap.lock);
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
80102624:	89 d8                	mov    %ebx,%eax
80102626:	c1 e8 0c             	shr    $0xc,%eax
  rmap.ref_count[rmap_index]--;
80102629:	83 2c 85 b8 26 11 80 	subl   $0x1,-0x7feed948(,%eax,4)
80102630:	01 
  if(rmap.use_lock)
    release(&rmap.lock);
}
80102631:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102634:	c9                   	leave  
80102635:	c3                   	ret    
80102636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010263d:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&rmap.lock);
80102640:	83 ec 0c             	sub    $0xc,%esp
80102643:	68 84 26 11 80       	push   $0x80112684
80102648:	e8 43 23 00 00       	call   80104990 <acquire>
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
8010264d:	89 d8                	mov    %ebx,%eax
  if(rmap.use_lock)
8010264f:	83 c4 10             	add    $0x10,%esp
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
80102652:	c1 e8 0c             	shr    $0xc,%eax
  rmap.ref_count[rmap_index]--;
80102655:	83 2c 85 b8 26 11 80 	subl   $0x1,-0x7feed948(,%eax,4)
8010265c:	01 
  if(rmap.use_lock)
8010265d:	a1 80 26 11 80       	mov    0x80112680,%eax
80102662:	85 c0                	test   %eax,%eax
80102664:	74 cb                	je     80102631 <dec_rmap+0x21>
    release(&rmap.lock);
80102666:	c7 45 08 84 26 11 80 	movl   $0x80112684,0x8(%ebp)
}
8010266d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102670:	c9                   	leave  
    release(&rmap.lock);
80102671:	e9 ba 22 00 00       	jmp    80104930 <release>
80102676:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010267d:	8d 76 00             	lea    0x0(%esi),%esi

80102680 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102680:	55                   	push   %ebp
80102681:	89 e5                	mov    %esp,%ebp
80102683:	57                   	push   %edi
80102684:	56                   	push   %esi
80102685:	53                   	push   %ebx
80102686:	83 ec 0c             	sub    $0xc,%esp
80102689:	8b 75 08             	mov    0x8(%ebp),%esi
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010268c:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
80102692:	0f 85 4d 01 00 00    	jne    801027e5 <kfree+0x165>
80102698:	81 fe f0 75 11 80    	cmp    $0x801175f0,%esi
8010269e:	0f 82 41 01 00 00    	jb     801027e5 <kfree+0x165>
801026a4:	8d 9e 00 00 00 80    	lea    -0x80000000(%esi),%ebx
801026aa:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
801026b0:	0f 87 2f 01 00 00    	ja     801027e5 <kfree+0x165>
  if(rmap.use_lock)
801026b6:	a1 80 26 11 80       	mov    0x80112680,%eax
801026bb:	85 c0                	test   %eax,%eax
801026bd:	0f 85 85 00 00 00    	jne    80102748 <kfree+0xc8>
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
801026c3:	c1 eb 0c             	shr    $0xc,%ebx
  rmap.ref_count[rmap_index]--;
801026c6:	83 c3 0c             	add    $0xc,%ebx
801026c9:	8b 04 9d 88 26 11 80 	mov    -0x7feed978(,%ebx,4),%eax
801026d0:	8d 78 ff             	lea    -0x1(%eax),%edi
801026d3:	89 3c 9d 88 26 11 80 	mov    %edi,-0x7feed978(,%ebx,4)
    panic("kfree");

  dec_rmap(V2P(v));
  if(get_rmap(V2P(v))>0)
801026da:	85 ff                	test   %edi,%edi
801026dc:	7e 12                	jle    801026f0 <kfree+0x70>
  r->next = kmem.freelist;
  kmem.num_free_pages+=1;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
}
801026de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801026e1:	5b                   	pop    %ebx
801026e2:	5e                   	pop    %esi
801026e3:	5f                   	pop    %edi
801026e4:	5d                   	pop    %ebp
801026e5:	c3                   	ret    
801026e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026ed:	8d 76 00             	lea    0x0(%esi),%esi
  memset(v, 1, PGSIZE);
801026f0:	83 ec 04             	sub    $0x4,%esp
801026f3:	68 00 10 00 00       	push   $0x1000
801026f8:	6a 01                	push   $0x1
801026fa:	56                   	push   %esi
801026fb:	e8 50 23 00 00       	call   80104a50 <memset>
  if(kmem.use_lock)
80102700:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102706:	83 c4 10             	add    $0x10,%esp
80102709:	85 d2                	test   %edx,%edx
8010270b:	0f 85 bf 00 00 00    	jne    801027d0 <kfree+0x150>
  r->next = kmem.freelist;
80102711:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102716:	89 06                	mov    %eax,(%esi)
  if(kmem.use_lock)
80102718:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.num_free_pages+=1;
8010271d:	83 05 78 26 11 80 01 	addl   $0x1,0x80112678
  kmem.freelist = r;
80102724:	89 35 7c 26 11 80    	mov    %esi,0x8011267c
  if(kmem.use_lock)
8010272a:	85 c0                	test   %eax,%eax
8010272c:	74 b0                	je     801026de <kfree+0x5e>
    release(&kmem.lock);
8010272e:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102735:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102738:	5b                   	pop    %ebx
80102739:	5e                   	pop    %esi
8010273a:	5f                   	pop    %edi
8010273b:	5d                   	pop    %ebp
    release(&kmem.lock);
8010273c:	e9 ef 21 00 00       	jmp    80104930 <release>
80102741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&rmap.lock);
80102748:	83 ec 0c             	sub    $0xc,%esp
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
8010274b:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&rmap.lock);
8010274e:	68 84 26 11 80       	push   $0x80112684
  rmap.ref_count[rmap_index]--;
80102753:	83 c3 0c             	add    $0xc,%ebx
    acquire(&rmap.lock);
80102756:	e8 35 22 00 00       	call   80104990 <acquire>
  rmap.ref_count[rmap_index]--;
8010275b:	8b 04 9d 88 26 11 80 	mov    -0x7feed978(,%ebx,4),%eax
  if(rmap.use_lock)
80102762:	83 c4 10             	add    $0x10,%esp
  rmap.ref_count[rmap_index]--;
80102765:	8d 78 ff             	lea    -0x1(%eax),%edi
  if(rmap.use_lock)
80102768:	a1 80 26 11 80       	mov    0x80112680,%eax
  rmap.ref_count[rmap_index]--;
8010276d:	89 3c 9d 88 26 11 80 	mov    %edi,-0x7feed978(,%ebx,4)
  if(rmap.use_lock)
80102774:	85 c0                	test   %eax,%eax
80102776:	0f 84 5e ff ff ff    	je     801026da <kfree+0x5a>
    release(&rmap.lock);
8010277c:	83 ec 0c             	sub    $0xc,%esp
8010277f:	68 84 26 11 80       	push   $0x80112684
80102784:	e8 a7 21 00 00       	call   80104930 <release>
  if(rmap.use_lock)
80102789:	8b 3d 80 26 11 80    	mov    0x80112680,%edi
8010278f:	83 c4 10             	add    $0x10,%esp
80102792:	85 ff                	test   %edi,%edi
80102794:	74 5c                	je     801027f2 <kfree+0x172>
    acquire(&rmap.lock);
80102796:	83 ec 0c             	sub    $0xc,%esp
80102799:	68 84 26 11 80       	push   $0x80112684
8010279e:	e8 ed 21 00 00       	call   80104990 <acquire>
  if(rmap.use_lock)
801027a3:	8b 0d 80 26 11 80    	mov    0x80112680,%ecx
  int value=rmap.ref_count[rmap_index];
801027a9:	8b 3c 9d 88 26 11 80 	mov    -0x7feed978(,%ebx,4),%edi
  if(rmap.use_lock)
801027b0:	83 c4 10             	add    $0x10,%esp
801027b3:	85 c9                	test   %ecx,%ecx
801027b5:	0f 84 1f ff ff ff    	je     801026da <kfree+0x5a>
    release(&rmap.lock);
801027bb:	83 ec 0c             	sub    $0xc,%esp
801027be:	68 84 26 11 80       	push   $0x80112684
801027c3:	e8 68 21 00 00       	call   80104930 <release>
801027c8:	83 c4 10             	add    $0x10,%esp
801027cb:	e9 0a ff ff ff       	jmp    801026da <kfree+0x5a>
    acquire(&kmem.lock);
801027d0:	83 ec 0c             	sub    $0xc,%esp
801027d3:	68 40 26 11 80       	push   $0x80112640
801027d8:	e8 b3 21 00 00       	call   80104990 <acquire>
801027dd:	83 c4 10             	add    $0x10,%esp
801027e0:	e9 2c ff ff ff       	jmp    80102711 <kfree+0x91>
    panic("kfree");
801027e5:	83 ec 0c             	sub    $0xc,%esp
801027e8:	68 66 79 10 80       	push   $0x80107966
801027ed:	e8 8e db ff ff       	call   80100380 <panic>
  int value=rmap.ref_count[rmap_index];
801027f2:	8b 3c 9d 88 26 11 80 	mov    -0x7feed978(,%ebx,4),%edi
801027f9:	e9 dc fe ff ff       	jmp    801026da <kfree+0x5a>
801027fe:	66 90                	xchg   %ax,%ax

80102800 <freerange>:
{
80102800:	55                   	push   %ebp
80102801:	89 e5                	mov    %esp,%ebp
80102803:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102804:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102807:	8b 75 0c             	mov    0xc(%ebp),%esi
8010280a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010280b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102811:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102817:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010281d:	39 de                	cmp    %ebx,%esi
8010281f:	72 23                	jb     80102844 <freerange+0x44>
80102821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102828:	83 ec 0c             	sub    $0xc,%esp
8010282b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102831:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102837:	50                   	push   %eax
80102838:	e8 43 fe ff ff       	call   80102680 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010283d:	83 c4 10             	add    $0x10,%esp
80102840:	39 f3                	cmp    %esi,%ebx
80102842:	76 e4                	jbe    80102828 <freerange+0x28>
}
80102844:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102847:	5b                   	pop    %ebx
80102848:	5e                   	pop    %esi
80102849:	5d                   	pop    %ebp
8010284a:	c3                   	ret    
8010284b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010284f:	90                   	nop

80102850 <kinit2>:
{
80102850:	55                   	push   %ebp
80102851:	89 e5                	mov    %esp,%ebp
80102853:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102854:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102857:	8b 75 0c             	mov    0xc(%ebp),%esi
8010285a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010285b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102861:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102867:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010286d:	39 de                	cmp    %ebx,%esi
8010286f:	72 23                	jb     80102894 <kinit2+0x44>
80102871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102878:	83 ec 0c             	sub    $0xc,%esp
8010287b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102881:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102887:	50                   	push   %eax
80102888:	e8 f3 fd ff ff       	call   80102680 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010288d:	83 c4 10             	add    $0x10,%esp
80102890:	39 de                	cmp    %ebx,%esi
80102892:	73 e4                	jae    80102878 <kinit2+0x28>
  kmem.use_lock = 1;
80102894:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010289b:	00 00 00 
  rmap.use_lock=1;
8010289e:	c7 05 80 26 11 80 01 	movl   $0x1,0x80112680
801028a5:	00 00 00 
}
801028a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801028ab:	5b                   	pop    %ebx
801028ac:	5e                   	pop    %esi
801028ad:	5d                   	pop    %ebp
801028ae:	c3                   	ret    
801028af:	90                   	nop

801028b0 <kinit1>:
{
801028b0:	55                   	push   %ebp
801028b1:	89 e5                	mov    %esp,%ebp
801028b3:	56                   	push   %esi
801028b4:	53                   	push   %ebx
801028b5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801028b8:	83 ec 08             	sub    $0x8,%esp
801028bb:	68 6c 79 10 80       	push   $0x8010796c
801028c0:	68 40 26 11 80       	push   $0x80112640
801028c5:	e8 f6 1e 00 00       	call   801047c0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801028ca:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028cd:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801028d0:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801028d7:	00 00 00 
  rmap.use_lock=0;
801028da:	c7 05 80 26 11 80 00 	movl   $0x0,0x80112680
801028e1:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801028e4:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801028ea:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028f0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801028f6:	39 de                	cmp    %ebx,%esi
801028f8:	72 22                	jb     8010291c <kinit1+0x6c>
801028fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    kfree(p);
80102900:	83 ec 0c             	sub    $0xc,%esp
80102903:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102909:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010290f:	50                   	push   %eax
80102910:	e8 6b fd ff ff       	call   80102680 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102915:	83 c4 10             	add    $0x10,%esp
80102918:	39 de                	cmp    %ebx,%esi
8010291a:	73 e4                	jae    80102900 <kinit1+0x50>
}
8010291c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010291f:	5b                   	pop    %ebx
80102920:	5e                   	pop    %esi
80102921:	5d                   	pop    %ebp
80102922:	c3                   	ret    
80102923:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010292a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102930 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102930:	55                   	push   %ebp
80102931:	89 e5                	mov    %esp,%ebp
80102933:	56                   	push   %esi
80102934:	53                   	push   %ebx
  struct run *r;

  if(kmem.use_lock)
80102935:	8b 1d 74 26 11 80    	mov    0x80112674,%ebx
8010293b:	85 db                	test   %ebx,%ebx
8010293d:	75 61                	jne    801029a0 <kalloc+0x70>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010293f:	8b 1d 7c 26 11 80    	mov    0x8011267c,%ebx
  if(r)
80102945:	85 db                	test   %ebx,%ebx
80102947:	74 45                	je     8010298e <kalloc+0x5e>
  {
    kmem.freelist = r->next;
80102949:	8b 03                	mov    (%ebx),%eax
  if(rmap.use_lock)
8010294b:	8b 0d 80 26 11 80    	mov    0x80112680,%ecx
    kmem.num_free_pages-=1;
    set_rmap(V2P(r),1); 
80102951:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
    kmem.num_free_pages-=1;
80102957:	83 2d 78 26 11 80 01 	subl   $0x1,0x80112678
    kmem.freelist = r->next;
8010295e:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  if(rmap.use_lock)
80102963:	85 c9                	test   %ecx,%ecx
80102965:	75 59                	jne    801029c0 <kalloc+0x90>
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
80102967:	c1 ee 0c             	shr    $0xc,%esi
  rmap.ref_count[rmap_index]=value;
8010296a:	c7 04 b5 b8 26 11 80 	movl   $0x1,-0x7feed948(,%esi,4)
80102971:	01 00 00 00 
  }
  if(kmem.use_lock)
80102975:	a1 74 26 11 80       	mov    0x80112674,%eax
8010297a:	85 c0                	test   %eax,%eax
8010297c:	74 10                	je     8010298e <kalloc+0x5e>
    release(&kmem.lock);
8010297e:	83 ec 0c             	sub    $0xc,%esp
80102981:	68 40 26 11 80       	push   $0x80112640
80102986:	e8 a5 1f 00 00       	call   80104930 <release>
8010298b:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
8010298e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102991:	89 d8                	mov    %ebx,%eax
80102993:	5b                   	pop    %ebx
80102994:	5e                   	pop    %esi
80102995:	5d                   	pop    %ebp
80102996:	c3                   	ret    
80102997:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010299e:	66 90                	xchg   %ax,%ax
    acquire(&kmem.lock);
801029a0:	83 ec 0c             	sub    $0xc,%esp
801029a3:	68 40 26 11 80       	push   $0x80112640
801029a8:	e8 e3 1f 00 00       	call   80104990 <acquire>
  r = kmem.freelist;
801029ad:	8b 1d 7c 26 11 80    	mov    0x8011267c,%ebx
  if(r)
801029b3:	83 c4 10             	add    $0x10,%esp
801029b6:	85 db                	test   %ebx,%ebx
801029b8:	75 8f                	jne    80102949 <kalloc+0x19>
801029ba:	eb b9                	jmp    80102975 <kalloc+0x45>
801029bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&rmap.lock);
801029c0:	83 ec 0c             	sub    $0xc,%esp
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
801029c3:	c1 ee 0c             	shr    $0xc,%esi
    acquire(&rmap.lock);
801029c6:	68 84 26 11 80       	push   $0x80112684
801029cb:	e8 c0 1f 00 00       	call   80104990 <acquire>
  if(rmap.use_lock)
801029d0:	8b 15 80 26 11 80    	mov    0x80112680,%edx
801029d6:	83 c4 10             	add    $0x10,%esp
  rmap.ref_count[rmap_index]=value;
801029d9:	c7 04 b5 b8 26 11 80 	movl   $0x1,-0x7feed948(,%esi,4)
801029e0:	01 00 00 00 
  if(rmap.use_lock)
801029e4:	85 d2                	test   %edx,%edx
801029e6:	74 8d                	je     80102975 <kalloc+0x45>
    release(&rmap.lock);
801029e8:	83 ec 0c             	sub    $0xc,%esp
801029eb:	68 84 26 11 80       	push   $0x80112684
801029f0:	e8 3b 1f 00 00       	call   80104930 <release>
801029f5:	83 c4 10             	add    $0x10,%esp
801029f8:	e9 78 ff ff ff       	jmp    80102975 <kalloc+0x45>
801029fd:	8d 76 00             	lea    0x0(%esi),%esi

80102a00 <num_of_FreePages>:
uint 
num_of_FreePages(void)
{
80102a00:	55                   	push   %ebp
80102a01:	89 e5                	mov    %esp,%ebp
80102a03:	53                   	push   %ebx
80102a04:	83 ec 10             	sub    $0x10,%esp
  acquire(&kmem.lock);
80102a07:	68 40 26 11 80       	push   $0x80112640
80102a0c:	e8 7f 1f 00 00       	call   80104990 <acquire>

  uint num_free_pages = kmem.num_free_pages;
80102a11:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  
  release(&kmem.lock);
80102a17:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102a1e:	e8 0d 1f 00 00       	call   80104930 <release>
  
  return num_free_pages;
}
80102a23:	89 d8                	mov    %ebx,%eax
80102a25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a28:	c9                   	leave  
80102a29:	c3                   	ret    
80102a2a:	66 90                	xchg   %ax,%ax
80102a2c:	66 90                	xchg   %ax,%ax
80102a2e:	66 90                	xchg   %ax,%ax

80102a30 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a30:	ba 64 00 00 00       	mov    $0x64,%edx
80102a35:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102a36:	a8 01                	test   $0x1,%al
80102a38:	0f 84 c2 00 00 00    	je     80102b00 <kbdgetc+0xd0>
{
80102a3e:	55                   	push   %ebp
80102a3f:	ba 60 00 00 00       	mov    $0x60,%edx
80102a44:	89 e5                	mov    %esp,%ebp
80102a46:	53                   	push   %ebx
80102a47:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102a48:	8b 1d b8 36 11 80    	mov    0x801136b8,%ebx
  data = inb(KBDATAP);
80102a4e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102a51:	3c e0                	cmp    $0xe0,%al
80102a53:	74 5b                	je     80102ab0 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102a55:	89 da                	mov    %ebx,%edx
80102a57:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
80102a5a:	84 c0                	test   %al,%al
80102a5c:	78 62                	js     80102ac0 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102a5e:	85 d2                	test   %edx,%edx
80102a60:	74 09                	je     80102a6b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102a62:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102a65:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102a68:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80102a6b:	0f b6 91 a0 7a 10 80 	movzbl -0x7fef8560(%ecx),%edx
  shift ^= togglecode[data];
80102a72:	0f b6 81 a0 79 10 80 	movzbl -0x7fef8660(%ecx),%eax
  shift |= shiftcode[data];
80102a79:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102a7b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102a7d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
80102a7f:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
  c = charcode[shift & (CTL | SHIFT)][data];
80102a85:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102a88:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102a8b:	8b 04 85 80 79 10 80 	mov    -0x7fef8680(,%eax,4),%eax
80102a92:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102a96:	74 0b                	je     80102aa3 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102a98:	8d 50 9f             	lea    -0x61(%eax),%edx
80102a9b:	83 fa 19             	cmp    $0x19,%edx
80102a9e:	77 48                	ja     80102ae8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102aa0:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102aa3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102aa6:	c9                   	leave  
80102aa7:	c3                   	ret    
80102aa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102aaf:	90                   	nop
    shift |= E0ESC;
80102ab0:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102ab3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102ab5:	89 1d b8 36 11 80    	mov    %ebx,0x801136b8
}
80102abb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102abe:	c9                   	leave  
80102abf:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102ac0:	83 e0 7f             	and    $0x7f,%eax
80102ac3:	85 d2                	test   %edx,%edx
80102ac5:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102ac8:	0f b6 81 a0 7a 10 80 	movzbl -0x7fef8560(%ecx),%eax
80102acf:	83 c8 40             	or     $0x40,%eax
80102ad2:	0f b6 c0             	movzbl %al,%eax
80102ad5:	f7 d0                	not    %eax
80102ad7:	21 d8                	and    %ebx,%eax
}
80102ad9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
80102adc:	a3 b8 36 11 80       	mov    %eax,0x801136b8
    return 0;
80102ae1:	31 c0                	xor    %eax,%eax
}
80102ae3:	c9                   	leave  
80102ae4:	c3                   	ret    
80102ae5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102ae8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102aeb:	8d 50 20             	lea    0x20(%eax),%edx
}
80102aee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102af1:	c9                   	leave  
      c += 'a' - 'A';
80102af2:	83 f9 1a             	cmp    $0x1a,%ecx
80102af5:	0f 42 c2             	cmovb  %edx,%eax
}
80102af8:	c3                   	ret    
80102af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102b00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102b05:	c3                   	ret    
80102b06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b0d:	8d 76 00             	lea    0x0(%esi),%esi

80102b10 <kbdintr>:

void
kbdintr(void)
{
80102b10:	55                   	push   %ebp
80102b11:	89 e5                	mov    %esp,%ebp
80102b13:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102b16:	68 30 2a 10 80       	push   $0x80102a30
80102b1b:	e8 60 dd ff ff       	call   80100880 <consoleintr>
}
80102b20:	83 c4 10             	add    $0x10,%esp
80102b23:	c9                   	leave  
80102b24:	c3                   	ret    
80102b25:	66 90                	xchg   %ax,%ax
80102b27:	66 90                	xchg   %ax,%ax
80102b29:	66 90                	xchg   %ax,%ax
80102b2b:	66 90                	xchg   %ax,%ax
80102b2d:	66 90                	xchg   %ax,%ax
80102b2f:	90                   	nop

80102b30 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102b30:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102b35:	85 c0                	test   %eax,%eax
80102b37:	0f 84 cb 00 00 00    	je     80102c08 <lapicinit+0xd8>
  lapic[index] = value;
80102b3d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102b44:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b47:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b4a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102b51:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b54:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b57:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102b5e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102b61:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b64:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102b6b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102b6e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b71:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102b78:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b7b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b7e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102b85:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b88:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102b8b:	8b 50 30             	mov    0x30(%eax),%edx
80102b8e:	c1 ea 10             	shr    $0x10,%edx
80102b91:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102b97:	75 77                	jne    80102c10 <lapicinit+0xe0>
  lapic[index] = value;
80102b99:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102ba0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ba3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ba6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102bad:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bb0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bb3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102bba:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bbd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bc0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102bc7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bca:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bcd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102bd4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bd7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bda:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102be1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102be4:	8b 50 20             	mov    0x20(%eax),%edx
80102be7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102bee:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102bf0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102bf6:	80 e6 10             	and    $0x10,%dh
80102bf9:	75 f5                	jne    80102bf0 <lapicinit+0xc0>
  lapic[index] = value;
80102bfb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102c02:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c05:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102c08:	c3                   	ret    
80102c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102c10:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102c17:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102c1a:	8b 50 20             	mov    0x20(%eax),%edx
}
80102c1d:	e9 77 ff ff ff       	jmp    80102b99 <lapicinit+0x69>
80102c22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c30 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102c30:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102c35:	85 c0                	test   %eax,%eax
80102c37:	74 07                	je     80102c40 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102c39:	8b 40 20             	mov    0x20(%eax),%eax
80102c3c:	c1 e8 18             	shr    $0x18,%eax
80102c3f:	c3                   	ret    
    return 0;
80102c40:	31 c0                	xor    %eax,%eax
}
80102c42:	c3                   	ret    
80102c43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102c50 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102c50:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102c55:	85 c0                	test   %eax,%eax
80102c57:	74 0d                	je     80102c66 <lapiceoi+0x16>
  lapic[index] = value;
80102c59:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102c60:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c63:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102c66:	c3                   	ret    
80102c67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c6e:	66 90                	xchg   %ax,%ax

80102c70 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102c70:	c3                   	ret    
80102c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c7f:	90                   	nop

80102c80 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102c80:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c81:	b8 0f 00 00 00       	mov    $0xf,%eax
80102c86:	ba 70 00 00 00       	mov    $0x70,%edx
80102c8b:	89 e5                	mov    %esp,%ebp
80102c8d:	53                   	push   %ebx
80102c8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102c91:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102c94:	ee                   	out    %al,(%dx)
80102c95:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c9a:	ba 71 00 00 00       	mov    $0x71,%edx
80102c9f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102ca0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102ca2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102ca5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102cab:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102cad:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102cb0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102cb2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102cb5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102cb8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102cbe:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102cc3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cc9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ccc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102cd3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cd6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102cd9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102ce0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ce3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ce6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cec:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102cef:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cf5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102cf8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cfe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d01:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102d07:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102d0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d0d:	c9                   	leave  
80102d0e:	c3                   	ret    
80102d0f:	90                   	nop

80102d10 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102d10:	55                   	push   %ebp
80102d11:	b8 0b 00 00 00       	mov    $0xb,%eax
80102d16:	ba 70 00 00 00       	mov    $0x70,%edx
80102d1b:	89 e5                	mov    %esp,%ebp
80102d1d:	57                   	push   %edi
80102d1e:	56                   	push   %esi
80102d1f:	53                   	push   %ebx
80102d20:	83 ec 4c             	sub    $0x4c,%esp
80102d23:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d24:	ba 71 00 00 00       	mov    $0x71,%edx
80102d29:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102d2a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d2d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102d32:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102d35:	8d 76 00             	lea    0x0(%esi),%esi
80102d38:	31 c0                	xor    %eax,%eax
80102d3a:	89 da                	mov    %ebx,%edx
80102d3c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d3d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102d42:	89 ca                	mov    %ecx,%edx
80102d44:	ec                   	in     (%dx),%al
80102d45:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d48:	89 da                	mov    %ebx,%edx
80102d4a:	b8 02 00 00 00       	mov    $0x2,%eax
80102d4f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d50:	89 ca                	mov    %ecx,%edx
80102d52:	ec                   	in     (%dx),%al
80102d53:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d56:	89 da                	mov    %ebx,%edx
80102d58:	b8 04 00 00 00       	mov    $0x4,%eax
80102d5d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d5e:	89 ca                	mov    %ecx,%edx
80102d60:	ec                   	in     (%dx),%al
80102d61:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d64:	89 da                	mov    %ebx,%edx
80102d66:	b8 07 00 00 00       	mov    $0x7,%eax
80102d6b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d6c:	89 ca                	mov    %ecx,%edx
80102d6e:	ec                   	in     (%dx),%al
80102d6f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d72:	89 da                	mov    %ebx,%edx
80102d74:	b8 08 00 00 00       	mov    $0x8,%eax
80102d79:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d7a:	89 ca                	mov    %ecx,%edx
80102d7c:	ec                   	in     (%dx),%al
80102d7d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d7f:	89 da                	mov    %ebx,%edx
80102d81:	b8 09 00 00 00       	mov    $0x9,%eax
80102d86:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d87:	89 ca                	mov    %ecx,%edx
80102d89:	ec                   	in     (%dx),%al
80102d8a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d8c:	89 da                	mov    %ebx,%edx
80102d8e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102d93:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d94:	89 ca                	mov    %ecx,%edx
80102d96:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102d97:	84 c0                	test   %al,%al
80102d99:	78 9d                	js     80102d38 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102d9b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102d9f:	89 fa                	mov    %edi,%edx
80102da1:	0f b6 fa             	movzbl %dl,%edi
80102da4:	89 f2                	mov    %esi,%edx
80102da6:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102da9:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102dad:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102db0:	89 da                	mov    %ebx,%edx
80102db2:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102db5:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102db8:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102dbc:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102dbf:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102dc2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102dc6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102dc9:	31 c0                	xor    %eax,%eax
80102dcb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dcc:	89 ca                	mov    %ecx,%edx
80102dce:	ec                   	in     (%dx),%al
80102dcf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dd2:	89 da                	mov    %ebx,%edx
80102dd4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102dd7:	b8 02 00 00 00       	mov    $0x2,%eax
80102ddc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ddd:	89 ca                	mov    %ecx,%edx
80102ddf:	ec                   	in     (%dx),%al
80102de0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102de3:	89 da                	mov    %ebx,%edx
80102de5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102de8:	b8 04 00 00 00       	mov    $0x4,%eax
80102ded:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dee:	89 ca                	mov    %ecx,%edx
80102df0:	ec                   	in     (%dx),%al
80102df1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102df4:	89 da                	mov    %ebx,%edx
80102df6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102df9:	b8 07 00 00 00       	mov    $0x7,%eax
80102dfe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dff:	89 ca                	mov    %ecx,%edx
80102e01:	ec                   	in     (%dx),%al
80102e02:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e05:	89 da                	mov    %ebx,%edx
80102e07:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102e0a:	b8 08 00 00 00       	mov    $0x8,%eax
80102e0f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e10:	89 ca                	mov    %ecx,%edx
80102e12:	ec                   	in     (%dx),%al
80102e13:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e16:	89 da                	mov    %ebx,%edx
80102e18:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102e1b:	b8 09 00 00 00       	mov    $0x9,%eax
80102e20:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e21:	89 ca                	mov    %ecx,%edx
80102e23:	ec                   	in     (%dx),%al
80102e24:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102e27:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102e2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102e2d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102e30:	6a 18                	push   $0x18
80102e32:	50                   	push   %eax
80102e33:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102e36:	50                   	push   %eax
80102e37:	e8 64 1c 00 00       	call   80104aa0 <memcmp>
80102e3c:	83 c4 10             	add    $0x10,%esp
80102e3f:	85 c0                	test   %eax,%eax
80102e41:	0f 85 f1 fe ff ff    	jne    80102d38 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102e47:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102e4b:	75 78                	jne    80102ec5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102e4d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102e50:	89 c2                	mov    %eax,%edx
80102e52:	83 e0 0f             	and    $0xf,%eax
80102e55:	c1 ea 04             	shr    $0x4,%edx
80102e58:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e5b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e5e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102e61:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102e64:	89 c2                	mov    %eax,%edx
80102e66:	83 e0 0f             	and    $0xf,%eax
80102e69:	c1 ea 04             	shr    $0x4,%edx
80102e6c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e6f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e72:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102e75:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102e78:	89 c2                	mov    %eax,%edx
80102e7a:	83 e0 0f             	and    $0xf,%eax
80102e7d:	c1 ea 04             	shr    $0x4,%edx
80102e80:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e83:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e86:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102e89:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102e8c:	89 c2                	mov    %eax,%edx
80102e8e:	83 e0 0f             	and    $0xf,%eax
80102e91:	c1 ea 04             	shr    $0x4,%edx
80102e94:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e97:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e9a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102e9d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ea0:	89 c2                	mov    %eax,%edx
80102ea2:	83 e0 0f             	and    $0xf,%eax
80102ea5:	c1 ea 04             	shr    $0x4,%edx
80102ea8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102eab:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102eae:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102eb1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102eb4:	89 c2                	mov    %eax,%edx
80102eb6:	83 e0 0f             	and    $0xf,%eax
80102eb9:	c1 ea 04             	shr    $0x4,%edx
80102ebc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ebf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ec2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102ec5:	8b 75 08             	mov    0x8(%ebp),%esi
80102ec8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ecb:	89 06                	mov    %eax,(%esi)
80102ecd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ed0:	89 46 04             	mov    %eax,0x4(%esi)
80102ed3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ed6:	89 46 08             	mov    %eax,0x8(%esi)
80102ed9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102edc:	89 46 0c             	mov    %eax,0xc(%esi)
80102edf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ee2:	89 46 10             	mov    %eax,0x10(%esi)
80102ee5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ee8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102eeb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102ef2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ef5:	5b                   	pop    %ebx
80102ef6:	5e                   	pop    %esi
80102ef7:	5f                   	pop    %edi
80102ef8:	5d                   	pop    %ebp
80102ef9:	c3                   	ret    
80102efa:	66 90                	xchg   %ax,%ax
80102efc:	66 90                	xchg   %ax,%ax
80102efe:	66 90                	xchg   %ax,%ax

80102f00 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102f00:	8b 0d 08 37 11 80    	mov    0x80113708,%ecx
80102f06:	85 c9                	test   %ecx,%ecx
80102f08:	0f 8e 8a 00 00 00    	jle    80102f98 <install_trans+0x98>
{
80102f0e:	55                   	push   %ebp
80102f0f:	89 e5                	mov    %esp,%ebp
80102f11:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102f12:	31 ff                	xor    %edi,%edi
{
80102f14:	56                   	push   %esi
80102f15:	53                   	push   %ebx
80102f16:	83 ec 0c             	sub    $0xc,%esp
80102f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102f20:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80102f25:	83 ec 08             	sub    $0x8,%esp
80102f28:	01 f8                	add    %edi,%eax
80102f2a:	83 c0 01             	add    $0x1,%eax
80102f2d:	50                   	push   %eax
80102f2e:	ff 35 04 37 11 80    	push   0x80113704
80102f34:	e8 97 d1 ff ff       	call   801000d0 <bread>
80102f39:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102f3b:	58                   	pop    %eax
80102f3c:	5a                   	pop    %edx
80102f3d:	ff 34 bd 0c 37 11 80 	push   -0x7feec8f4(,%edi,4)
80102f44:	ff 35 04 37 11 80    	push   0x80113704
  for (tail = 0; tail < log.lh.n; tail++) {
80102f4a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102f4d:	e8 7e d1 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102f52:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102f55:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102f57:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f5a:	68 00 02 00 00       	push   $0x200
80102f5f:	50                   	push   %eax
80102f60:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102f63:	50                   	push   %eax
80102f64:	e8 87 1b 00 00       	call   80104af0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102f69:	89 1c 24             	mov    %ebx,(%esp)
80102f6c:	e8 3f d2 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102f71:	89 34 24             	mov    %esi,(%esp)
80102f74:	e8 77 d2 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102f79:	89 1c 24             	mov    %ebx,(%esp)
80102f7c:	e8 6f d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f81:	83 c4 10             	add    $0x10,%esp
80102f84:	39 3d 08 37 11 80    	cmp    %edi,0x80113708
80102f8a:	7f 94                	jg     80102f20 <install_trans+0x20>
  }
}
80102f8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f8f:	5b                   	pop    %ebx
80102f90:	5e                   	pop    %esi
80102f91:	5f                   	pop    %edi
80102f92:	5d                   	pop    %ebp
80102f93:	c3                   	ret    
80102f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f98:	c3                   	ret    
80102f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102fa0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102fa0:	55                   	push   %ebp
80102fa1:	89 e5                	mov    %esp,%ebp
80102fa3:	53                   	push   %ebx
80102fa4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102fa7:	ff 35 f4 36 11 80    	push   0x801136f4
80102fad:	ff 35 04 37 11 80    	push   0x80113704
80102fb3:	e8 18 d1 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102fb8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102fbb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102fbd:	a1 08 37 11 80       	mov    0x80113708,%eax
80102fc2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102fc5:	85 c0                	test   %eax,%eax
80102fc7:	7e 19                	jle    80102fe2 <write_head+0x42>
80102fc9:	31 d2                	xor    %edx,%edx
80102fcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fcf:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102fd0:	8b 0c 95 0c 37 11 80 	mov    -0x7feec8f4(,%edx,4),%ecx
80102fd7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102fdb:	83 c2 01             	add    $0x1,%edx
80102fde:	39 d0                	cmp    %edx,%eax
80102fe0:	75 ee                	jne    80102fd0 <write_head+0x30>
  }
  bwrite(buf);
80102fe2:	83 ec 0c             	sub    $0xc,%esp
80102fe5:	53                   	push   %ebx
80102fe6:	e8 c5 d1 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102feb:	89 1c 24             	mov    %ebx,(%esp)
80102fee:	e8 fd d1 ff ff       	call   801001f0 <brelse>
}
80102ff3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ff6:	83 c4 10             	add    $0x10,%esp
80102ff9:	c9                   	leave  
80102ffa:	c3                   	ret    
80102ffb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fff:	90                   	nop

80103000 <initlog>:
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	53                   	push   %ebx
80103004:	83 ec 2c             	sub    $0x2c,%esp
80103007:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010300a:	68 a0 7b 10 80       	push   $0x80107ba0
8010300f:	68 c0 36 11 80       	push   $0x801136c0
80103014:	e8 a7 17 00 00       	call   801047c0 <initlock>
  readsb(dev, &sb);
80103019:	58                   	pop    %eax
8010301a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010301d:	5a                   	pop    %edx
8010301e:	50                   	push   %eax
8010301f:	53                   	push   %ebx
80103020:	e8 fb e4 ff ff       	call   80101520 <readsb>
  log.start = sb.logstart;
80103025:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80103028:	59                   	pop    %ecx
  log.dev = dev;
80103029:	89 1d 04 37 11 80    	mov    %ebx,0x80113704
  log.size = sb.nlog;
8010302f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103032:	a3 f4 36 11 80       	mov    %eax,0x801136f4
  log.size = sb.nlog;
80103037:	89 15 f8 36 11 80    	mov    %edx,0x801136f8
  struct buf *buf = bread(log.dev, log.start);
8010303d:	5a                   	pop    %edx
8010303e:	50                   	push   %eax
8010303f:	53                   	push   %ebx
80103040:	e8 8b d0 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103045:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80103048:	8b 58 5c             	mov    0x5c(%eax),%ebx
8010304b:	89 1d 08 37 11 80    	mov    %ebx,0x80113708
  for (i = 0; i < log.lh.n; i++) {
80103051:	85 db                	test   %ebx,%ebx
80103053:	7e 1d                	jle    80103072 <initlog+0x72>
80103055:	31 d2                	xor    %edx,%edx
80103057:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010305e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80103060:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80103064:	89 0c 95 0c 37 11 80 	mov    %ecx,-0x7feec8f4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010306b:	83 c2 01             	add    $0x1,%edx
8010306e:	39 d3                	cmp    %edx,%ebx
80103070:	75 ee                	jne    80103060 <initlog+0x60>
  brelse(buf);
80103072:	83 ec 0c             	sub    $0xc,%esp
80103075:	50                   	push   %eax
80103076:	e8 75 d1 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010307b:	e8 80 fe ff ff       	call   80102f00 <install_trans>
  log.lh.n = 0;
80103080:	c7 05 08 37 11 80 00 	movl   $0x0,0x80113708
80103087:	00 00 00 
  write_head(); // clear the log
8010308a:	e8 11 ff ff ff       	call   80102fa0 <write_head>
}
8010308f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103092:	83 c4 10             	add    $0x10,%esp
80103095:	c9                   	leave  
80103096:	c3                   	ret    
80103097:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010309e:	66 90                	xchg   %ax,%ax

801030a0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801030a0:	55                   	push   %ebp
801030a1:	89 e5                	mov    %esp,%ebp
801030a3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801030a6:	68 c0 36 11 80       	push   $0x801136c0
801030ab:	e8 e0 18 00 00       	call   80104990 <acquire>
801030b0:	83 c4 10             	add    $0x10,%esp
801030b3:	eb 18                	jmp    801030cd <begin_op+0x2d>
801030b5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801030b8:	83 ec 08             	sub    $0x8,%esp
801030bb:	68 c0 36 11 80       	push   $0x801136c0
801030c0:	68 c0 36 11 80       	push   $0x801136c0
801030c5:	e8 26 13 00 00       	call   801043f0 <sleep>
801030ca:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801030cd:	a1 00 37 11 80       	mov    0x80113700,%eax
801030d2:	85 c0                	test   %eax,%eax
801030d4:	75 e2                	jne    801030b8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801030d6:	a1 fc 36 11 80       	mov    0x801136fc,%eax
801030db:	8b 15 08 37 11 80    	mov    0x80113708,%edx
801030e1:	83 c0 01             	add    $0x1,%eax
801030e4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801030e7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801030ea:	83 fa 1e             	cmp    $0x1e,%edx
801030ed:	7f c9                	jg     801030b8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
801030ef:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
801030f2:	a3 fc 36 11 80       	mov    %eax,0x801136fc
      release(&log.lock);
801030f7:	68 c0 36 11 80       	push   $0x801136c0
801030fc:	e8 2f 18 00 00       	call   80104930 <release>
      break;
    }
  }
}
80103101:	83 c4 10             	add    $0x10,%esp
80103104:	c9                   	leave  
80103105:	c3                   	ret    
80103106:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010310d:	8d 76 00             	lea    0x0(%esi),%esi

80103110 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103110:	55                   	push   %ebp
80103111:	89 e5                	mov    %esp,%ebp
80103113:	57                   	push   %edi
80103114:	56                   	push   %esi
80103115:	53                   	push   %ebx
80103116:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103119:	68 c0 36 11 80       	push   $0x801136c0
8010311e:	e8 6d 18 00 00       	call   80104990 <acquire>
  log.outstanding -= 1;
80103123:	a1 fc 36 11 80       	mov    0x801136fc,%eax
  if(log.committing)
80103128:	8b 35 00 37 11 80    	mov    0x80113700,%esi
8010312e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103131:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103134:	89 1d fc 36 11 80    	mov    %ebx,0x801136fc
  if(log.committing)
8010313a:	85 f6                	test   %esi,%esi
8010313c:	0f 85 22 01 00 00    	jne    80103264 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103142:	85 db                	test   %ebx,%ebx
80103144:	0f 85 f6 00 00 00    	jne    80103240 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010314a:	c7 05 00 37 11 80 01 	movl   $0x1,0x80113700
80103151:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103154:	83 ec 0c             	sub    $0xc,%esp
80103157:	68 c0 36 11 80       	push   $0x801136c0
8010315c:	e8 cf 17 00 00       	call   80104930 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103161:	8b 0d 08 37 11 80    	mov    0x80113708,%ecx
80103167:	83 c4 10             	add    $0x10,%esp
8010316a:	85 c9                	test   %ecx,%ecx
8010316c:	7f 42                	jg     801031b0 <end_op+0xa0>
    acquire(&log.lock);
8010316e:	83 ec 0c             	sub    $0xc,%esp
80103171:	68 c0 36 11 80       	push   $0x801136c0
80103176:	e8 15 18 00 00       	call   80104990 <acquire>
    wakeup(&log);
8010317b:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
    log.committing = 0;
80103182:	c7 05 00 37 11 80 00 	movl   $0x0,0x80113700
80103189:	00 00 00 
    wakeup(&log);
8010318c:	e8 1f 13 00 00       	call   801044b0 <wakeup>
    release(&log.lock);
80103191:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
80103198:	e8 93 17 00 00       	call   80104930 <release>
8010319d:	83 c4 10             	add    $0x10,%esp
}
801031a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031a3:	5b                   	pop    %ebx
801031a4:	5e                   	pop    %esi
801031a5:	5f                   	pop    %edi
801031a6:	5d                   	pop    %ebp
801031a7:	c3                   	ret    
801031a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031af:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801031b0:	a1 f4 36 11 80       	mov    0x801136f4,%eax
801031b5:	83 ec 08             	sub    $0x8,%esp
801031b8:	01 d8                	add    %ebx,%eax
801031ba:	83 c0 01             	add    $0x1,%eax
801031bd:	50                   	push   %eax
801031be:	ff 35 04 37 11 80    	push   0x80113704
801031c4:	e8 07 cf ff ff       	call   801000d0 <bread>
801031c9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801031cb:	58                   	pop    %eax
801031cc:	5a                   	pop    %edx
801031cd:	ff 34 9d 0c 37 11 80 	push   -0x7feec8f4(,%ebx,4)
801031d4:	ff 35 04 37 11 80    	push   0x80113704
  for (tail = 0; tail < log.lh.n; tail++) {
801031da:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801031dd:	e8 ee ce ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
801031e2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801031e5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801031e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801031ea:	68 00 02 00 00       	push   $0x200
801031ef:	50                   	push   %eax
801031f0:	8d 46 5c             	lea    0x5c(%esi),%eax
801031f3:	50                   	push   %eax
801031f4:	e8 f7 18 00 00       	call   80104af0 <memmove>
    bwrite(to);  // write the log
801031f9:	89 34 24             	mov    %esi,(%esp)
801031fc:	e8 af cf ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103201:	89 3c 24             	mov    %edi,(%esp)
80103204:	e8 e7 cf ff ff       	call   801001f0 <brelse>
    brelse(to);
80103209:	89 34 24             	mov    %esi,(%esp)
8010320c:	e8 df cf ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103211:	83 c4 10             	add    $0x10,%esp
80103214:	3b 1d 08 37 11 80    	cmp    0x80113708,%ebx
8010321a:	7c 94                	jl     801031b0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010321c:	e8 7f fd ff ff       	call   80102fa0 <write_head>
    install_trans(); // Now install writes to home locations
80103221:	e8 da fc ff ff       	call   80102f00 <install_trans>
    log.lh.n = 0;
80103226:	c7 05 08 37 11 80 00 	movl   $0x0,0x80113708
8010322d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103230:	e8 6b fd ff ff       	call   80102fa0 <write_head>
80103235:	e9 34 ff ff ff       	jmp    8010316e <end_op+0x5e>
8010323a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103240:	83 ec 0c             	sub    $0xc,%esp
80103243:	68 c0 36 11 80       	push   $0x801136c0
80103248:	e8 63 12 00 00       	call   801044b0 <wakeup>
  release(&log.lock);
8010324d:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
80103254:	e8 d7 16 00 00       	call   80104930 <release>
80103259:	83 c4 10             	add    $0x10,%esp
}
8010325c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010325f:	5b                   	pop    %ebx
80103260:	5e                   	pop    %esi
80103261:	5f                   	pop    %edi
80103262:	5d                   	pop    %ebp
80103263:	c3                   	ret    
    panic("log.committing");
80103264:	83 ec 0c             	sub    $0xc,%esp
80103267:	68 a4 7b 10 80       	push   $0x80107ba4
8010326c:	e8 0f d1 ff ff       	call   80100380 <panic>
80103271:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103278:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010327f:	90                   	nop

80103280 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103280:	55                   	push   %ebp
80103281:	89 e5                	mov    %esp,%ebp
80103283:	53                   	push   %ebx
80103284:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103287:	8b 15 08 37 11 80    	mov    0x80113708,%edx
{
8010328d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103290:	83 fa 1d             	cmp    $0x1d,%edx
80103293:	0f 8f 85 00 00 00    	jg     8010331e <log_write+0x9e>
80103299:	a1 f8 36 11 80       	mov    0x801136f8,%eax
8010329e:	83 e8 01             	sub    $0x1,%eax
801032a1:	39 c2                	cmp    %eax,%edx
801032a3:	7d 79                	jge    8010331e <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
801032a5:	a1 fc 36 11 80       	mov    0x801136fc,%eax
801032aa:	85 c0                	test   %eax,%eax
801032ac:	7e 7d                	jle    8010332b <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
801032ae:	83 ec 0c             	sub    $0xc,%esp
801032b1:	68 c0 36 11 80       	push   $0x801136c0
801032b6:	e8 d5 16 00 00       	call   80104990 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801032bb:	8b 15 08 37 11 80    	mov    0x80113708,%edx
801032c1:	83 c4 10             	add    $0x10,%esp
801032c4:	85 d2                	test   %edx,%edx
801032c6:	7e 4a                	jle    80103312 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801032c8:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
801032cb:	31 c0                	xor    %eax,%eax
801032cd:	eb 08                	jmp    801032d7 <log_write+0x57>
801032cf:	90                   	nop
801032d0:	83 c0 01             	add    $0x1,%eax
801032d3:	39 c2                	cmp    %eax,%edx
801032d5:	74 29                	je     80103300 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801032d7:	39 0c 85 0c 37 11 80 	cmp    %ecx,-0x7feec8f4(,%eax,4)
801032de:	75 f0                	jne    801032d0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
801032e0:	89 0c 85 0c 37 11 80 	mov    %ecx,-0x7feec8f4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801032e7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801032ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801032ed:	c7 45 08 c0 36 11 80 	movl   $0x801136c0,0x8(%ebp)
}
801032f4:	c9                   	leave  
  release(&log.lock);
801032f5:	e9 36 16 00 00       	jmp    80104930 <release>
801032fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103300:	89 0c 95 0c 37 11 80 	mov    %ecx,-0x7feec8f4(,%edx,4)
    log.lh.n++;
80103307:	83 c2 01             	add    $0x1,%edx
8010330a:	89 15 08 37 11 80    	mov    %edx,0x80113708
80103310:	eb d5                	jmp    801032e7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80103312:	8b 43 08             	mov    0x8(%ebx),%eax
80103315:	a3 0c 37 11 80       	mov    %eax,0x8011370c
  if (i == log.lh.n)
8010331a:	75 cb                	jne    801032e7 <log_write+0x67>
8010331c:	eb e9                	jmp    80103307 <log_write+0x87>
    panic("too big a transaction");
8010331e:	83 ec 0c             	sub    $0xc,%esp
80103321:	68 b3 7b 10 80       	push   $0x80107bb3
80103326:	e8 55 d0 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010332b:	83 ec 0c             	sub    $0xc,%esp
8010332e:	68 c9 7b 10 80       	push   $0x80107bc9
80103333:	e8 48 d0 ff ff       	call   80100380 <panic>
80103338:	66 90                	xchg   %ax,%ax
8010333a:	66 90                	xchg   %ax,%ax
8010333c:	66 90                	xchg   %ax,%ax
8010333e:	66 90                	xchg   %ax,%ax

80103340 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103340:	55                   	push   %ebp
80103341:	89 e5                	mov    %esp,%ebp
80103343:	53                   	push   %ebx
80103344:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103347:	e8 44 09 00 00       	call   80103c90 <cpuid>
8010334c:	89 c3                	mov    %eax,%ebx
8010334e:	e8 3d 09 00 00       	call   80103c90 <cpuid>
80103353:	83 ec 04             	sub    $0x4,%esp
80103356:	53                   	push   %ebx
80103357:	50                   	push   %eax
80103358:	68 e4 7b 10 80       	push   $0x80107be4
8010335d:	e8 3e d3 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103362:	e8 89 29 00 00       	call   80105cf0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103367:	e8 c4 08 00 00       	call   80103c30 <mycpu>
8010336c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010336e:	b8 01 00 00 00       	mov    $0x1,%eax
80103373:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010337a:	e8 61 0c 00 00       	call   80103fe0 <scheduler>
8010337f:	90                   	nop

80103380 <mpenter>:
{
80103380:	55                   	push   %ebp
80103381:	89 e5                	mov    %esp,%ebp
80103383:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103386:	e8 05 3b 00 00       	call   80106e90 <switchkvm>
  seginit();
8010338b:	e8 e0 39 00 00       	call   80106d70 <seginit>
  lapicinit();
80103390:	e8 9b f7 ff ff       	call   80102b30 <lapicinit>
  mpmain();
80103395:	e8 a6 ff ff ff       	call   80103340 <mpmain>
8010339a:	66 90                	xchg   %ax,%ax
8010339c:	66 90                	xchg   %ax,%ax
8010339e:	66 90                	xchg   %ax,%ax

801033a0 <main>:
{
801033a0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801033a4:	83 e4 f0             	and    $0xfffffff0,%esp
801033a7:	ff 71 fc             	push   -0x4(%ecx)
801033aa:	55                   	push   %ebp
801033ab:	89 e5                	mov    %esp,%ebp
801033ad:	53                   	push   %ebx
801033ae:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801033af:	83 ec 08             	sub    $0x8,%esp
801033b2:	68 00 00 40 80       	push   $0x80400000
801033b7:	68 f0 75 11 80       	push   $0x801175f0
801033bc:	e8 ef f4 ff ff       	call   801028b0 <kinit1>
  kvmalloc();      // kernel page table
801033c1:	e8 ba 3f 00 00       	call   80107380 <kvmalloc>
  mpinit();        // detect other processors
801033c6:	e8 85 01 00 00       	call   80103550 <mpinit>
  lapicinit();     // interrupt controller
801033cb:	e8 60 f7 ff ff       	call   80102b30 <lapicinit>
  seginit();       // segment descriptors
801033d0:	e8 9b 39 00 00       	call   80106d70 <seginit>
  picinit();       // disable pic
801033d5:	e8 76 03 00 00       	call   80103750 <picinit>
  ioapicinit();    // another interrupt controller
801033da:	e8 f1 ef ff ff       	call   801023d0 <ioapicinit>
  consoleinit();   // console hardware
801033df:	e8 7c d6 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801033e4:	e8 17 2c 00 00       	call   80106000 <uartinit>
  pinit();         // process table
801033e9:	e8 22 08 00 00       	call   80103c10 <pinit>
  tvinit();        // trap vectors
801033ee:	e8 7d 28 00 00       	call   80105c70 <tvinit>
  binit();         // buffer cache
801033f3:	e8 48 cc ff ff       	call   80100040 <binit>
  fileinit();      // file table
801033f8:	e8 13 da ff ff       	call   80100e10 <fileinit>
  ideinit();       // disk 
801033fd:	e8 be ed ff ff       	call   801021c0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103402:	83 c4 0c             	add    $0xc,%esp
80103405:	68 8a 00 00 00       	push   $0x8a
8010340a:	68 8c b4 10 80       	push   $0x8010b48c
8010340f:	68 00 70 00 80       	push   $0x80007000
80103414:	e8 d7 16 00 00       	call   80104af0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103419:	83 c4 10             	add    $0x10,%esp
8010341c:	69 05 a4 37 11 80 b0 	imul   $0xb0,0x801137a4,%eax
80103423:	00 00 00 
80103426:	05 c0 37 11 80       	add    $0x801137c0,%eax
8010342b:	3d c0 37 11 80       	cmp    $0x801137c0,%eax
80103430:	76 7e                	jbe    801034b0 <main+0x110>
80103432:	bb c0 37 11 80       	mov    $0x801137c0,%ebx
80103437:	eb 20                	jmp    80103459 <main+0xb9>
80103439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103440:	69 05 a4 37 11 80 b0 	imul   $0xb0,0x801137a4,%eax
80103447:	00 00 00 
8010344a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103450:	05 c0 37 11 80       	add    $0x801137c0,%eax
80103455:	39 c3                	cmp    %eax,%ebx
80103457:	73 57                	jae    801034b0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103459:	e8 d2 07 00 00       	call   80103c30 <mycpu>
8010345e:	39 c3                	cmp    %eax,%ebx
80103460:	74 de                	je     80103440 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103462:	e8 c9 f4 ff ff       	call   80102930 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103467:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010346a:	c7 05 f8 6f 00 80 80 	movl   $0x80103380,0x80006ff8
80103471:	33 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103474:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010347b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010347e:	05 00 10 00 00       	add    $0x1000,%eax
80103483:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103488:	0f b6 03             	movzbl (%ebx),%eax
8010348b:	68 00 70 00 00       	push   $0x7000
80103490:	50                   	push   %eax
80103491:	e8 ea f7 ff ff       	call   80102c80 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103496:	83 c4 10             	add    $0x10,%esp
80103499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034a0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801034a6:	85 c0                	test   %eax,%eax
801034a8:	74 f6                	je     801034a0 <main+0x100>
801034aa:	eb 94                	jmp    80103440 <main+0xa0>
801034ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801034b0:	83 ec 08             	sub    $0x8,%esp
801034b3:	68 00 00 40 80       	push   $0x80400000
801034b8:	68 00 00 40 80       	push   $0x80400000
801034bd:	e8 8e f3 ff ff       	call   80102850 <kinit2>
  userinit();      // first user process
801034c2:	e8 19 08 00 00       	call   80103ce0 <userinit>
  mpmain();        // finish this processor's setup
801034c7:	e8 74 fe ff ff       	call   80103340 <mpmain>
801034cc:	66 90                	xchg   %ax,%ax
801034ce:	66 90                	xchg   %ax,%ax

801034d0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801034d0:	55                   	push   %ebp
801034d1:	89 e5                	mov    %esp,%ebp
801034d3:	57                   	push   %edi
801034d4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801034d5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801034db:	53                   	push   %ebx
  e = addr+len;
801034dc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801034df:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801034e2:	39 de                	cmp    %ebx,%esi
801034e4:	72 10                	jb     801034f6 <mpsearch1+0x26>
801034e6:	eb 50                	jmp    80103538 <mpsearch1+0x68>
801034e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034ef:	90                   	nop
801034f0:	89 fe                	mov    %edi,%esi
801034f2:	39 fb                	cmp    %edi,%ebx
801034f4:	76 42                	jbe    80103538 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801034f6:	83 ec 04             	sub    $0x4,%esp
801034f9:	8d 7e 10             	lea    0x10(%esi),%edi
801034fc:	6a 04                	push   $0x4
801034fe:	68 f8 7b 10 80       	push   $0x80107bf8
80103503:	56                   	push   %esi
80103504:	e8 97 15 00 00       	call   80104aa0 <memcmp>
80103509:	83 c4 10             	add    $0x10,%esp
8010350c:	85 c0                	test   %eax,%eax
8010350e:	75 e0                	jne    801034f0 <mpsearch1+0x20>
80103510:	89 f2                	mov    %esi,%edx
80103512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103518:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010351b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010351e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103520:	39 fa                	cmp    %edi,%edx
80103522:	75 f4                	jne    80103518 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103524:	84 c0                	test   %al,%al
80103526:	75 c8                	jne    801034f0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103528:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010352b:	89 f0                	mov    %esi,%eax
8010352d:	5b                   	pop    %ebx
8010352e:	5e                   	pop    %esi
8010352f:	5f                   	pop    %edi
80103530:	5d                   	pop    %ebp
80103531:	c3                   	ret    
80103532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103538:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010353b:	31 f6                	xor    %esi,%esi
}
8010353d:	5b                   	pop    %ebx
8010353e:	89 f0                	mov    %esi,%eax
80103540:	5e                   	pop    %esi
80103541:	5f                   	pop    %edi
80103542:	5d                   	pop    %ebp
80103543:	c3                   	ret    
80103544:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010354b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010354f:	90                   	nop

80103550 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103550:	55                   	push   %ebp
80103551:	89 e5                	mov    %esp,%ebp
80103553:	57                   	push   %edi
80103554:	56                   	push   %esi
80103555:	53                   	push   %ebx
80103556:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103559:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103560:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103567:	c1 e0 08             	shl    $0x8,%eax
8010356a:	09 d0                	or     %edx,%eax
8010356c:	c1 e0 04             	shl    $0x4,%eax
8010356f:	75 1b                	jne    8010358c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103571:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103578:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010357f:	c1 e0 08             	shl    $0x8,%eax
80103582:	09 d0                	or     %edx,%eax
80103584:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103587:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010358c:	ba 00 04 00 00       	mov    $0x400,%edx
80103591:	e8 3a ff ff ff       	call   801034d0 <mpsearch1>
80103596:	89 c3                	mov    %eax,%ebx
80103598:	85 c0                	test   %eax,%eax
8010359a:	0f 84 40 01 00 00    	je     801036e0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801035a0:	8b 73 04             	mov    0x4(%ebx),%esi
801035a3:	85 f6                	test   %esi,%esi
801035a5:	0f 84 25 01 00 00    	je     801036d0 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
801035ab:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801035ae:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801035b4:	6a 04                	push   $0x4
801035b6:	68 fd 7b 10 80       	push   $0x80107bfd
801035bb:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801035bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801035bf:	e8 dc 14 00 00       	call   80104aa0 <memcmp>
801035c4:	83 c4 10             	add    $0x10,%esp
801035c7:	85 c0                	test   %eax,%eax
801035c9:	0f 85 01 01 00 00    	jne    801036d0 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
801035cf:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801035d6:	3c 01                	cmp    $0x1,%al
801035d8:	74 08                	je     801035e2 <mpinit+0x92>
801035da:	3c 04                	cmp    $0x4,%al
801035dc:	0f 85 ee 00 00 00    	jne    801036d0 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801035e2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801035e9:	66 85 d2             	test   %dx,%dx
801035ec:	74 22                	je     80103610 <mpinit+0xc0>
801035ee:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801035f1:	89 f0                	mov    %esi,%eax
  sum = 0;
801035f3:	31 d2                	xor    %edx,%edx
801035f5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801035f8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801035ff:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103602:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103604:	39 c7                	cmp    %eax,%edi
80103606:	75 f0                	jne    801035f8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103608:	84 d2                	test   %dl,%dl
8010360a:	0f 85 c0 00 00 00    	jne    801036d0 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103610:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103616:	a3 bc 36 11 80       	mov    %eax,0x801136bc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010361b:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103622:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
80103628:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010362d:	03 55 e4             	add    -0x1c(%ebp),%edx
80103630:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103633:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103637:	90                   	nop
80103638:	39 d0                	cmp    %edx,%eax
8010363a:	73 15                	jae    80103651 <mpinit+0x101>
    switch(*p){
8010363c:	0f b6 08             	movzbl (%eax),%ecx
8010363f:	80 f9 02             	cmp    $0x2,%cl
80103642:	74 4c                	je     80103690 <mpinit+0x140>
80103644:	77 3a                	ja     80103680 <mpinit+0x130>
80103646:	84 c9                	test   %cl,%cl
80103648:	74 56                	je     801036a0 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010364a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010364d:	39 d0                	cmp    %edx,%eax
8010364f:	72 eb                	jb     8010363c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103651:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103654:	85 f6                	test   %esi,%esi
80103656:	0f 84 d9 00 00 00    	je     80103735 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010365c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103660:	74 15                	je     80103677 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103662:	b8 70 00 00 00       	mov    $0x70,%eax
80103667:	ba 22 00 00 00       	mov    $0x22,%edx
8010366c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010366d:	ba 23 00 00 00       	mov    $0x23,%edx
80103672:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103673:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103676:	ee                   	out    %al,(%dx)
  }
}
80103677:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010367a:	5b                   	pop    %ebx
8010367b:	5e                   	pop    %esi
8010367c:	5f                   	pop    %edi
8010367d:	5d                   	pop    %ebp
8010367e:	c3                   	ret    
8010367f:	90                   	nop
    switch(*p){
80103680:	83 e9 03             	sub    $0x3,%ecx
80103683:	80 f9 01             	cmp    $0x1,%cl
80103686:	76 c2                	jbe    8010364a <mpinit+0xfa>
80103688:	31 f6                	xor    %esi,%esi
8010368a:	eb ac                	jmp    80103638 <mpinit+0xe8>
8010368c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103690:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103694:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103697:	88 0d a0 37 11 80    	mov    %cl,0x801137a0
      continue;
8010369d:	eb 99                	jmp    80103638 <mpinit+0xe8>
8010369f:	90                   	nop
      if(ncpu < NCPU) {
801036a0:	8b 0d a4 37 11 80    	mov    0x801137a4,%ecx
801036a6:	83 f9 07             	cmp    $0x7,%ecx
801036a9:	7f 19                	jg     801036c4 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801036ab:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801036b1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801036b5:	83 c1 01             	add    $0x1,%ecx
801036b8:	89 0d a4 37 11 80    	mov    %ecx,0x801137a4
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801036be:	88 9f c0 37 11 80    	mov    %bl,-0x7feec840(%edi)
      p += sizeof(struct mpproc);
801036c4:	83 c0 14             	add    $0x14,%eax
      continue;
801036c7:	e9 6c ff ff ff       	jmp    80103638 <mpinit+0xe8>
801036cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801036d0:	83 ec 0c             	sub    $0xc,%esp
801036d3:	68 02 7c 10 80       	push   $0x80107c02
801036d8:	e8 a3 cc ff ff       	call   80100380 <panic>
801036dd:	8d 76 00             	lea    0x0(%esi),%esi
{
801036e0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801036e5:	eb 13                	jmp    801036fa <mpinit+0x1aa>
801036e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036ee:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801036f0:	89 f3                	mov    %esi,%ebx
801036f2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801036f8:	74 d6                	je     801036d0 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801036fa:	83 ec 04             	sub    $0x4,%esp
801036fd:	8d 73 10             	lea    0x10(%ebx),%esi
80103700:	6a 04                	push   $0x4
80103702:	68 f8 7b 10 80       	push   $0x80107bf8
80103707:	53                   	push   %ebx
80103708:	e8 93 13 00 00       	call   80104aa0 <memcmp>
8010370d:	83 c4 10             	add    $0x10,%esp
80103710:	85 c0                	test   %eax,%eax
80103712:	75 dc                	jne    801036f0 <mpinit+0x1a0>
80103714:	89 da                	mov    %ebx,%edx
80103716:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010371d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103720:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103723:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103726:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103728:	39 d6                	cmp    %edx,%esi
8010372a:	75 f4                	jne    80103720 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010372c:	84 c0                	test   %al,%al
8010372e:	75 c0                	jne    801036f0 <mpinit+0x1a0>
80103730:	e9 6b fe ff ff       	jmp    801035a0 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103735:	83 ec 0c             	sub    $0xc,%esp
80103738:	68 1c 7c 10 80       	push   $0x80107c1c
8010373d:	e8 3e cc ff ff       	call   80100380 <panic>
80103742:	66 90                	xchg   %ax,%ax
80103744:	66 90                	xchg   %ax,%ax
80103746:	66 90                	xchg   %ax,%ax
80103748:	66 90                	xchg   %ax,%ax
8010374a:	66 90                	xchg   %ax,%ax
8010374c:	66 90                	xchg   %ax,%ax
8010374e:	66 90                	xchg   %ax,%ax

80103750 <picinit>:
80103750:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103755:	ba 21 00 00 00       	mov    $0x21,%edx
8010375a:	ee                   	out    %al,(%dx)
8010375b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103760:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103761:	c3                   	ret    
80103762:	66 90                	xchg   %ax,%ax
80103764:	66 90                	xchg   %ax,%ax
80103766:	66 90                	xchg   %ax,%ax
80103768:	66 90                	xchg   %ax,%ax
8010376a:	66 90                	xchg   %ax,%ax
8010376c:	66 90                	xchg   %ax,%ax
8010376e:	66 90                	xchg   %ax,%ax

80103770 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103770:	55                   	push   %ebp
80103771:	89 e5                	mov    %esp,%ebp
80103773:	57                   	push   %edi
80103774:	56                   	push   %esi
80103775:	53                   	push   %ebx
80103776:	83 ec 0c             	sub    $0xc,%esp
80103779:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010377c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010377f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103785:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010378b:	e8 a0 d6 ff ff       	call   80100e30 <filealloc>
80103790:	89 03                	mov    %eax,(%ebx)
80103792:	85 c0                	test   %eax,%eax
80103794:	0f 84 a8 00 00 00    	je     80103842 <pipealloc+0xd2>
8010379a:	e8 91 d6 ff ff       	call   80100e30 <filealloc>
8010379f:	89 06                	mov    %eax,(%esi)
801037a1:	85 c0                	test   %eax,%eax
801037a3:	0f 84 87 00 00 00    	je     80103830 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801037a9:	e8 82 f1 ff ff       	call   80102930 <kalloc>
801037ae:	89 c7                	mov    %eax,%edi
801037b0:	85 c0                	test   %eax,%eax
801037b2:	0f 84 b0 00 00 00    	je     80103868 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
801037b8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801037bf:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801037c2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801037c5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801037cc:	00 00 00 
  p->nwrite = 0;
801037cf:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801037d6:	00 00 00 
  p->nread = 0;
801037d9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801037e0:	00 00 00 
  initlock(&p->lock, "pipe");
801037e3:	68 3b 7c 10 80       	push   $0x80107c3b
801037e8:	50                   	push   %eax
801037e9:	e8 d2 0f 00 00       	call   801047c0 <initlock>
  (*f0)->type = FD_PIPE;
801037ee:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801037f0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801037f3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801037f9:	8b 03                	mov    (%ebx),%eax
801037fb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801037ff:	8b 03                	mov    (%ebx),%eax
80103801:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103805:	8b 03                	mov    (%ebx),%eax
80103807:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010380a:	8b 06                	mov    (%esi),%eax
8010380c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103812:	8b 06                	mov    (%esi),%eax
80103814:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103818:	8b 06                	mov    (%esi),%eax
8010381a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010381e:	8b 06                	mov    (%esi),%eax
80103820:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103823:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103826:	31 c0                	xor    %eax,%eax
}
80103828:	5b                   	pop    %ebx
80103829:	5e                   	pop    %esi
8010382a:	5f                   	pop    %edi
8010382b:	5d                   	pop    %ebp
8010382c:	c3                   	ret    
8010382d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103830:	8b 03                	mov    (%ebx),%eax
80103832:	85 c0                	test   %eax,%eax
80103834:	74 1e                	je     80103854 <pipealloc+0xe4>
    fileclose(*f0);
80103836:	83 ec 0c             	sub    $0xc,%esp
80103839:	50                   	push   %eax
8010383a:	e8 b1 d6 ff ff       	call   80100ef0 <fileclose>
8010383f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103842:	8b 06                	mov    (%esi),%eax
80103844:	85 c0                	test   %eax,%eax
80103846:	74 0c                	je     80103854 <pipealloc+0xe4>
    fileclose(*f1);
80103848:	83 ec 0c             	sub    $0xc,%esp
8010384b:	50                   	push   %eax
8010384c:	e8 9f d6 ff ff       	call   80100ef0 <fileclose>
80103851:	83 c4 10             	add    $0x10,%esp
}
80103854:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103857:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010385c:	5b                   	pop    %ebx
8010385d:	5e                   	pop    %esi
8010385e:	5f                   	pop    %edi
8010385f:	5d                   	pop    %ebp
80103860:	c3                   	ret    
80103861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103868:	8b 03                	mov    (%ebx),%eax
8010386a:	85 c0                	test   %eax,%eax
8010386c:	75 c8                	jne    80103836 <pipealloc+0xc6>
8010386e:	eb d2                	jmp    80103842 <pipealloc+0xd2>

80103870 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103870:	55                   	push   %ebp
80103871:	89 e5                	mov    %esp,%ebp
80103873:	56                   	push   %esi
80103874:	53                   	push   %ebx
80103875:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103878:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010387b:	83 ec 0c             	sub    $0xc,%esp
8010387e:	53                   	push   %ebx
8010387f:	e8 0c 11 00 00       	call   80104990 <acquire>
  if(writable){
80103884:	83 c4 10             	add    $0x10,%esp
80103887:	85 f6                	test   %esi,%esi
80103889:	74 65                	je     801038f0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010388b:	83 ec 0c             	sub    $0xc,%esp
8010388e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103894:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010389b:	00 00 00 
    wakeup(&p->nread);
8010389e:	50                   	push   %eax
8010389f:	e8 0c 0c 00 00       	call   801044b0 <wakeup>
801038a4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801038a7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801038ad:	85 d2                	test   %edx,%edx
801038af:	75 0a                	jne    801038bb <pipeclose+0x4b>
801038b1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801038b7:	85 c0                	test   %eax,%eax
801038b9:	74 15                	je     801038d0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801038bb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801038be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038c1:	5b                   	pop    %ebx
801038c2:	5e                   	pop    %esi
801038c3:	5d                   	pop    %ebp
    release(&p->lock);
801038c4:	e9 67 10 00 00       	jmp    80104930 <release>
801038c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801038d0:	83 ec 0c             	sub    $0xc,%esp
801038d3:	53                   	push   %ebx
801038d4:	e8 57 10 00 00       	call   80104930 <release>
    kfree((char*)p);
801038d9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801038dc:	83 c4 10             	add    $0x10,%esp
}
801038df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038e2:	5b                   	pop    %ebx
801038e3:	5e                   	pop    %esi
801038e4:	5d                   	pop    %ebp
    kfree((char*)p);
801038e5:	e9 96 ed ff ff       	jmp    80102680 <kfree>
801038ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801038f0:	83 ec 0c             	sub    $0xc,%esp
801038f3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801038f9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103900:	00 00 00 
    wakeup(&p->nwrite);
80103903:	50                   	push   %eax
80103904:	e8 a7 0b 00 00       	call   801044b0 <wakeup>
80103909:	83 c4 10             	add    $0x10,%esp
8010390c:	eb 99                	jmp    801038a7 <pipeclose+0x37>
8010390e:	66 90                	xchg   %ax,%ax

80103910 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103910:	55                   	push   %ebp
80103911:	89 e5                	mov    %esp,%ebp
80103913:	57                   	push   %edi
80103914:	56                   	push   %esi
80103915:	53                   	push   %ebx
80103916:	83 ec 28             	sub    $0x28,%esp
80103919:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010391c:	53                   	push   %ebx
8010391d:	e8 6e 10 00 00       	call   80104990 <acquire>
  for(i = 0; i < n; i++){
80103922:	8b 45 10             	mov    0x10(%ebp),%eax
80103925:	83 c4 10             	add    $0x10,%esp
80103928:	85 c0                	test   %eax,%eax
8010392a:	0f 8e c0 00 00 00    	jle    801039f0 <pipewrite+0xe0>
80103930:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103933:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103939:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010393f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103942:	03 45 10             	add    0x10(%ebp),%eax
80103945:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103948:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010394e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103954:	89 ca                	mov    %ecx,%edx
80103956:	05 00 02 00 00       	add    $0x200,%eax
8010395b:	39 c1                	cmp    %eax,%ecx
8010395d:	74 3f                	je     8010399e <pipewrite+0x8e>
8010395f:	eb 67                	jmp    801039c8 <pipewrite+0xb8>
80103961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103968:	e8 43 03 00 00       	call   80103cb0 <myproc>
8010396d:	8b 48 28             	mov    0x28(%eax),%ecx
80103970:	85 c9                	test   %ecx,%ecx
80103972:	75 34                	jne    801039a8 <pipewrite+0x98>
      wakeup(&p->nread);
80103974:	83 ec 0c             	sub    $0xc,%esp
80103977:	57                   	push   %edi
80103978:	e8 33 0b 00 00       	call   801044b0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010397d:	58                   	pop    %eax
8010397e:	5a                   	pop    %edx
8010397f:	53                   	push   %ebx
80103980:	56                   	push   %esi
80103981:	e8 6a 0a 00 00       	call   801043f0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103986:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010398c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103992:	83 c4 10             	add    $0x10,%esp
80103995:	05 00 02 00 00       	add    $0x200,%eax
8010399a:	39 c2                	cmp    %eax,%edx
8010399c:	75 2a                	jne    801039c8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010399e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801039a4:	85 c0                	test   %eax,%eax
801039a6:	75 c0                	jne    80103968 <pipewrite+0x58>
        release(&p->lock);
801039a8:	83 ec 0c             	sub    $0xc,%esp
801039ab:	53                   	push   %ebx
801039ac:	e8 7f 0f 00 00       	call   80104930 <release>
        return -1;
801039b1:	83 c4 10             	add    $0x10,%esp
801039b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801039b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039bc:	5b                   	pop    %ebx
801039bd:	5e                   	pop    %esi
801039be:	5f                   	pop    %edi
801039bf:	5d                   	pop    %ebp
801039c0:	c3                   	ret    
801039c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801039c8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801039cb:	8d 4a 01             	lea    0x1(%edx),%ecx
801039ce:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801039d4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801039da:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
801039dd:	83 c6 01             	add    $0x1,%esi
801039e0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801039e3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801039e7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801039ea:	0f 85 58 ff ff ff    	jne    80103948 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801039f0:	83 ec 0c             	sub    $0xc,%esp
801039f3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801039f9:	50                   	push   %eax
801039fa:	e8 b1 0a 00 00       	call   801044b0 <wakeup>
  release(&p->lock);
801039ff:	89 1c 24             	mov    %ebx,(%esp)
80103a02:	e8 29 0f 00 00       	call   80104930 <release>
  return n;
80103a07:	8b 45 10             	mov    0x10(%ebp),%eax
80103a0a:	83 c4 10             	add    $0x10,%esp
80103a0d:	eb aa                	jmp    801039b9 <pipewrite+0xa9>
80103a0f:	90                   	nop

80103a10 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103a10:	55                   	push   %ebp
80103a11:	89 e5                	mov    %esp,%ebp
80103a13:	57                   	push   %edi
80103a14:	56                   	push   %esi
80103a15:	53                   	push   %ebx
80103a16:	83 ec 18             	sub    $0x18,%esp
80103a19:	8b 75 08             	mov    0x8(%ebp),%esi
80103a1c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103a1f:	56                   	push   %esi
80103a20:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103a26:	e8 65 0f 00 00       	call   80104990 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103a2b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103a31:	83 c4 10             	add    $0x10,%esp
80103a34:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103a3a:	74 2f                	je     80103a6b <piperead+0x5b>
80103a3c:	eb 37                	jmp    80103a75 <piperead+0x65>
80103a3e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103a40:	e8 6b 02 00 00       	call   80103cb0 <myproc>
80103a45:	8b 48 28             	mov    0x28(%eax),%ecx
80103a48:	85 c9                	test   %ecx,%ecx
80103a4a:	0f 85 80 00 00 00    	jne    80103ad0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103a50:	83 ec 08             	sub    $0x8,%esp
80103a53:	56                   	push   %esi
80103a54:	53                   	push   %ebx
80103a55:	e8 96 09 00 00       	call   801043f0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103a5a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103a60:	83 c4 10             	add    $0x10,%esp
80103a63:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103a69:	75 0a                	jne    80103a75 <piperead+0x65>
80103a6b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103a71:	85 c0                	test   %eax,%eax
80103a73:	75 cb                	jne    80103a40 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103a75:	8b 55 10             	mov    0x10(%ebp),%edx
80103a78:	31 db                	xor    %ebx,%ebx
80103a7a:	85 d2                	test   %edx,%edx
80103a7c:	7f 20                	jg     80103a9e <piperead+0x8e>
80103a7e:	eb 2c                	jmp    80103aac <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103a80:	8d 48 01             	lea    0x1(%eax),%ecx
80103a83:	25 ff 01 00 00       	and    $0x1ff,%eax
80103a88:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103a8e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103a93:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103a96:	83 c3 01             	add    $0x1,%ebx
80103a99:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103a9c:	74 0e                	je     80103aac <piperead+0x9c>
    if(p->nread == p->nwrite)
80103a9e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103aa4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103aaa:	75 d4                	jne    80103a80 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103aac:	83 ec 0c             	sub    $0xc,%esp
80103aaf:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103ab5:	50                   	push   %eax
80103ab6:	e8 f5 09 00 00       	call   801044b0 <wakeup>
  release(&p->lock);
80103abb:	89 34 24             	mov    %esi,(%esp)
80103abe:	e8 6d 0e 00 00       	call   80104930 <release>
  return i;
80103ac3:	83 c4 10             	add    $0x10,%esp
}
80103ac6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ac9:	89 d8                	mov    %ebx,%eax
80103acb:	5b                   	pop    %ebx
80103acc:	5e                   	pop    %esi
80103acd:	5f                   	pop    %edi
80103ace:	5d                   	pop    %ebp
80103acf:	c3                   	ret    
      release(&p->lock);
80103ad0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103ad3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103ad8:	56                   	push   %esi
80103ad9:	e8 52 0e 00 00       	call   80104930 <release>
      return -1;
80103ade:	83 c4 10             	add    $0x10,%esp
}
80103ae1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ae4:	89 d8                	mov    %ebx,%eax
80103ae6:	5b                   	pop    %ebx
80103ae7:	5e                   	pop    %esi
80103ae8:	5f                   	pop    %edi
80103ae9:	5d                   	pop    %ebp
80103aea:	c3                   	ret    
80103aeb:	66 90                	xchg   %ax,%ax
80103aed:	66 90                	xchg   %ax,%ax
80103aef:	90                   	nop

80103af0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103af4:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
{
80103af9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103afc:	68 40 3d 11 80       	push   $0x80113d40
80103b01:	e8 8a 0e 00 00       	call   80104990 <acquire>
80103b06:	83 c4 10             	add    $0x10,%esp
80103b09:	eb 10                	jmp    80103b1b <allocproc+0x2b>
80103b0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b0f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b10:	83 eb 80             	sub    $0xffffff80,%ebx
80103b13:	81 fb 74 5d 11 80    	cmp    $0x80115d74,%ebx
80103b19:	74 75                	je     80103b90 <allocproc+0xa0>
    if(p->state == UNUSED)
80103b1b:	8b 43 10             	mov    0x10(%ebx),%eax
80103b1e:	85 c0                	test   %eax,%eax
80103b20:	75 ee                	jne    80103b10 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103b22:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103b27:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103b2a:	c7 43 10 01 00 00 00 	movl   $0x1,0x10(%ebx)
  p->pid = nextpid++;
80103b31:	89 43 14             	mov    %eax,0x14(%ebx)
80103b34:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103b37:	68 40 3d 11 80       	push   $0x80113d40
  p->pid = nextpid++;
80103b3c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103b42:	e8 e9 0d 00 00       	call   80104930 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103b47:	e8 e4 ed ff ff       	call   80102930 <kalloc>
80103b4c:	83 c4 10             	add    $0x10,%esp
80103b4f:	89 43 0c             	mov    %eax,0xc(%ebx)
80103b52:	85 c0                	test   %eax,%eax
80103b54:	74 53                	je     80103ba9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103b56:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103b5c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103b5f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103b64:	89 53 1c             	mov    %edx,0x1c(%ebx)
  *(uint*)sp = (uint)trapret;
80103b67:	c7 40 14 62 5c 10 80 	movl   $0x80105c62,0x14(%eax)
  p->context = (struct context*)sp;
80103b6e:	89 43 20             	mov    %eax,0x20(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103b71:	6a 14                	push   $0x14
80103b73:	6a 00                	push   $0x0
80103b75:	50                   	push   %eax
80103b76:	e8 d5 0e 00 00       	call   80104a50 <memset>
  p->context->eip = (uint)forkret;
80103b7b:	8b 43 20             	mov    0x20(%ebx),%eax

  return p;
80103b7e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103b81:	c7 40 10 c0 3b 10 80 	movl   $0x80103bc0,0x10(%eax)
}
80103b88:	89 d8                	mov    %ebx,%eax
80103b8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b8d:	c9                   	leave  
80103b8e:	c3                   	ret    
80103b8f:	90                   	nop
  release(&ptable.lock);
80103b90:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103b93:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103b95:	68 40 3d 11 80       	push   $0x80113d40
80103b9a:	e8 91 0d 00 00       	call   80104930 <release>
}
80103b9f:	89 d8                	mov    %ebx,%eax
  return 0;
80103ba1:	83 c4 10             	add    $0x10,%esp
}
80103ba4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ba7:	c9                   	leave  
80103ba8:	c3                   	ret    
    p->state = UNUSED;
80103ba9:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return 0;
80103bb0:	31 db                	xor    %ebx,%ebx
}
80103bb2:	89 d8                	mov    %ebx,%eax
80103bb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bb7:	c9                   	leave  
80103bb8:	c3                   	ret    
80103bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103bc0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103bc0:	55                   	push   %ebp
80103bc1:	89 e5                	mov    %esp,%ebp
80103bc3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103bc6:	68 40 3d 11 80       	push   $0x80113d40
80103bcb:	e8 60 0d 00 00       	call   80104930 <release>

  if (first) {
80103bd0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103bd5:	83 c4 10             	add    $0x10,%esp
80103bd8:	85 c0                	test   %eax,%eax
80103bda:	75 04                	jne    80103be0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103bdc:	c9                   	leave  
80103bdd:	c3                   	ret    
80103bde:	66 90                	xchg   %ax,%ax
    first = 0;
80103be0:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103be7:	00 00 00 
    iinit(ROOTDEV);
80103bea:	83 ec 0c             	sub    $0xc,%esp
80103bed:	6a 01                	push   $0x1
80103bef:	e8 6c d9 ff ff       	call   80101560 <iinit>
    initlog(ROOTDEV);
80103bf4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103bfb:	e8 00 f4 ff ff       	call   80103000 <initlog>
}
80103c00:	83 c4 10             	add    $0x10,%esp
80103c03:	c9                   	leave  
80103c04:	c3                   	ret    
80103c05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103c10 <pinit>:
{
80103c10:	55                   	push   %ebp
80103c11:	89 e5                	mov    %esp,%ebp
80103c13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103c16:	68 40 7c 10 80       	push   $0x80107c40
80103c1b:	68 40 3d 11 80       	push   $0x80113d40
80103c20:	e8 9b 0b 00 00       	call   801047c0 <initlock>
}
80103c25:	83 c4 10             	add    $0x10,%esp
80103c28:	c9                   	leave  
80103c29:	c3                   	ret    
80103c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c30 <mycpu>:
{
80103c30:	55                   	push   %ebp
80103c31:	89 e5                	mov    %esp,%ebp
80103c33:	56                   	push   %esi
80103c34:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c35:	9c                   	pushf  
80103c36:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103c37:	f6 c4 02             	test   $0x2,%ah
80103c3a:	75 46                	jne    80103c82 <mycpu+0x52>
  apicid = lapicid();
80103c3c:	e8 ef ef ff ff       	call   80102c30 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103c41:	8b 35 a4 37 11 80    	mov    0x801137a4,%esi
80103c47:	85 f6                	test   %esi,%esi
80103c49:	7e 2a                	jle    80103c75 <mycpu+0x45>
80103c4b:	31 d2                	xor    %edx,%edx
80103c4d:	eb 08                	jmp    80103c57 <mycpu+0x27>
80103c4f:	90                   	nop
80103c50:	83 c2 01             	add    $0x1,%edx
80103c53:	39 f2                	cmp    %esi,%edx
80103c55:	74 1e                	je     80103c75 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103c57:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103c5d:	0f b6 99 c0 37 11 80 	movzbl -0x7feec840(%ecx),%ebx
80103c64:	39 c3                	cmp    %eax,%ebx
80103c66:	75 e8                	jne    80103c50 <mycpu+0x20>
}
80103c68:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103c6b:	8d 81 c0 37 11 80    	lea    -0x7feec840(%ecx),%eax
}
80103c71:	5b                   	pop    %ebx
80103c72:	5e                   	pop    %esi
80103c73:	5d                   	pop    %ebp
80103c74:	c3                   	ret    
  panic("unknown apicid\n");
80103c75:	83 ec 0c             	sub    $0xc,%esp
80103c78:	68 47 7c 10 80       	push   $0x80107c47
80103c7d:	e8 fe c6 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103c82:	83 ec 0c             	sub    $0xc,%esp
80103c85:	68 30 7d 10 80       	push   $0x80107d30
80103c8a:	e8 f1 c6 ff ff       	call   80100380 <panic>
80103c8f:	90                   	nop

80103c90 <cpuid>:
cpuid() {
80103c90:	55                   	push   %ebp
80103c91:	89 e5                	mov    %esp,%ebp
80103c93:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103c96:	e8 95 ff ff ff       	call   80103c30 <mycpu>
}
80103c9b:	c9                   	leave  
  return mycpu()-cpus;
80103c9c:	2d c0 37 11 80       	sub    $0x801137c0,%eax
80103ca1:	c1 f8 04             	sar    $0x4,%eax
80103ca4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103caa:	c3                   	ret    
80103cab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103caf:	90                   	nop

80103cb0 <myproc>:
myproc(void) {
80103cb0:	55                   	push   %ebp
80103cb1:	89 e5                	mov    %esp,%ebp
80103cb3:	53                   	push   %ebx
80103cb4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103cb7:	e8 84 0b 00 00       	call   80104840 <pushcli>
  c = mycpu();
80103cbc:	e8 6f ff ff ff       	call   80103c30 <mycpu>
  p = c->proc;
80103cc1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cc7:	e8 c4 0b 00 00       	call   80104890 <popcli>
}
80103ccc:	89 d8                	mov    %ebx,%eax
80103cce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cd1:	c9                   	leave  
80103cd2:	c3                   	ret    
80103cd3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ce0 <userinit>:
{
80103ce0:	55                   	push   %ebp
80103ce1:	89 e5                	mov    %esp,%ebp
80103ce3:	53                   	push   %ebx
80103ce4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103ce7:	e8 04 fe ff ff       	call   80103af0 <allocproc>
80103cec:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103cee:	a3 74 5d 11 80       	mov    %eax,0x80115d74
  if((p->pgdir = setupkvm()) == 0)
80103cf3:	e8 08 36 00 00       	call   80107300 <setupkvm>
80103cf8:	89 43 08             	mov    %eax,0x8(%ebx)
80103cfb:	85 c0                	test   %eax,%eax
80103cfd:	0f 84 bd 00 00 00    	je     80103dc0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103d03:	83 ec 04             	sub    $0x4,%esp
80103d06:	68 2c 00 00 00       	push   $0x2c
80103d0b:	68 60 b4 10 80       	push   $0x8010b460
80103d10:	50                   	push   %eax
80103d11:	e8 9a 32 00 00       	call   80106fb0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103d16:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103d19:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103d1f:	6a 4c                	push   $0x4c
80103d21:	6a 00                	push   $0x0
80103d23:	ff 73 1c             	push   0x1c(%ebx)
80103d26:	e8 25 0d 00 00       	call   80104a50 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103d2b:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103d2e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103d33:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103d36:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103d3b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103d3f:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103d42:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103d46:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103d49:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103d4d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103d51:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103d54:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103d58:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103d5c:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103d5f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103d66:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103d69:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103d70:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103d73:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103d7a:	8d 43 70             	lea    0x70(%ebx),%eax
80103d7d:	6a 10                	push   $0x10
80103d7f:	68 70 7c 10 80       	push   $0x80107c70
80103d84:	50                   	push   %eax
80103d85:	e8 86 0e 00 00       	call   80104c10 <safestrcpy>
  p->cwd = namei("/");
80103d8a:	c7 04 24 79 7c 10 80 	movl   $0x80107c79,(%esp)
80103d91:	e8 0a e3 ff ff       	call   801020a0 <namei>
80103d96:	89 43 6c             	mov    %eax,0x6c(%ebx)
  acquire(&ptable.lock);
80103d99:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103da0:	e8 eb 0b 00 00       	call   80104990 <acquire>
  p->state = RUNNABLE;
80103da5:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  release(&ptable.lock);
80103dac:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103db3:	e8 78 0b 00 00       	call   80104930 <release>
}
80103db8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103dbb:	83 c4 10             	add    $0x10,%esp
80103dbe:	c9                   	leave  
80103dbf:	c3                   	ret    
    panic("userinit: out of memory?");
80103dc0:	83 ec 0c             	sub    $0xc,%esp
80103dc3:	68 57 7c 10 80       	push   $0x80107c57
80103dc8:	e8 b3 c5 ff ff       	call   80100380 <panic>
80103dcd:	8d 76 00             	lea    0x0(%esi),%esi

80103dd0 <growproc>:
{
80103dd0:	55                   	push   %ebp
80103dd1:	89 e5                	mov    %esp,%ebp
80103dd3:	56                   	push   %esi
80103dd4:	53                   	push   %ebx
80103dd5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103dd8:	e8 63 0a 00 00       	call   80104840 <pushcli>
  c = mycpu();
80103ddd:	e8 4e fe ff ff       	call   80103c30 <mycpu>
  p = c->proc;
80103de2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103de8:	e8 a3 0a 00 00       	call   80104890 <popcli>
  sz = curproc->sz;
80103ded:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103def:	85 f6                	test   %esi,%esi
80103df1:	7f 1d                	jg     80103e10 <growproc+0x40>
  } else if(n < 0){
80103df3:	75 3b                	jne    80103e30 <growproc+0x60>
  switchuvm(curproc);
80103df5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103df8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103dfa:	53                   	push   %ebx
80103dfb:	e8 a0 30 00 00       	call   80106ea0 <switchuvm>
  return 0;
80103e00:	83 c4 10             	add    $0x10,%esp
80103e03:	31 c0                	xor    %eax,%eax
}
80103e05:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e08:	5b                   	pop    %ebx
80103e09:	5e                   	pop    %esi
80103e0a:	5d                   	pop    %ebp
80103e0b:	c3                   	ret    
80103e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103e10:	83 ec 04             	sub    $0x4,%esp
80103e13:	01 c6                	add    %eax,%esi
80103e15:	56                   	push   %esi
80103e16:	50                   	push   %eax
80103e17:	ff 73 08             	push   0x8(%ebx)
80103e1a:	e8 01 33 00 00       	call   80107120 <allocuvm>
80103e1f:	83 c4 10             	add    $0x10,%esp
80103e22:	85 c0                	test   %eax,%eax
80103e24:	75 cf                	jne    80103df5 <growproc+0x25>
      return -1;
80103e26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e2b:	eb d8                	jmp    80103e05 <growproc+0x35>
80103e2d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103e30:	83 ec 04             	sub    $0x4,%esp
80103e33:	01 c6                	add    %eax,%esi
80103e35:	56                   	push   %esi
80103e36:	50                   	push   %eax
80103e37:	ff 73 08             	push   0x8(%ebx)
80103e3a:	e8 11 34 00 00       	call   80107250 <deallocuvm>
80103e3f:	83 c4 10             	add    $0x10,%esp
80103e42:	85 c0                	test   %eax,%eax
80103e44:	75 af                	jne    80103df5 <growproc+0x25>
80103e46:	eb de                	jmp    80103e26 <growproc+0x56>
80103e48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e4f:	90                   	nop

80103e50 <fork>:
{
80103e50:	55                   	push   %ebp
80103e51:	89 e5                	mov    %esp,%ebp
80103e53:	57                   	push   %edi
80103e54:	56                   	push   %esi
80103e55:	53                   	push   %ebx
80103e56:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103e59:	e8 e2 09 00 00       	call   80104840 <pushcli>
  c = mycpu();
80103e5e:	e8 cd fd ff ff       	call   80103c30 <mycpu>
  p = c->proc;
80103e63:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e69:	e8 22 0a 00 00       	call   80104890 <popcli>
  if((np = allocproc()) == 0){
80103e6e:	e8 7d fc ff ff       	call   80103af0 <allocproc>
80103e73:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103e76:	85 c0                	test   %eax,%eax
80103e78:	0f 84 b7 00 00 00    	je     80103f35 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103e7e:	83 ec 08             	sub    $0x8,%esp
80103e81:	ff 33                	push   (%ebx)
80103e83:	89 c7                	mov    %eax,%edi
80103e85:	ff 73 08             	push   0x8(%ebx)
80103e88:	e8 63 35 00 00       	call   801073f0 <copyuvm>
80103e8d:	83 c4 10             	add    $0x10,%esp
80103e90:	89 47 08             	mov    %eax,0x8(%edi)
80103e93:	85 c0                	test   %eax,%eax
80103e95:	0f 84 a1 00 00 00    	je     80103f3c <fork+0xec>
  np->sz = curproc->sz;
80103e9b:	8b 03                	mov    (%ebx),%eax
80103e9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103ea0:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103ea2:	8b 79 1c             	mov    0x1c(%ecx),%edi
  np->parent = curproc;
80103ea5:	89 c8                	mov    %ecx,%eax
80103ea7:	89 59 18             	mov    %ebx,0x18(%ecx)
  *np->tf = *curproc->tf;
80103eaa:	b9 13 00 00 00       	mov    $0x13,%ecx
80103eaf:	8b 73 1c             	mov    0x1c(%ebx),%esi
80103eb2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103eb4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103eb6:	8b 40 1c             	mov    0x1c(%eax),%eax
80103eb9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103ec0:	8b 44 b3 2c          	mov    0x2c(%ebx,%esi,4),%eax
80103ec4:	85 c0                	test   %eax,%eax
80103ec6:	74 13                	je     80103edb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103ec8:	83 ec 0c             	sub    $0xc,%esp
80103ecb:	50                   	push   %eax
80103ecc:	e8 cf cf ff ff       	call   80100ea0 <filedup>
80103ed1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103ed4:	83 c4 10             	add    $0x10,%esp
80103ed7:	89 44 b2 2c          	mov    %eax,0x2c(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103edb:	83 c6 01             	add    $0x1,%esi
80103ede:	83 fe 10             	cmp    $0x10,%esi
80103ee1:	75 dd                	jne    80103ec0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103ee3:	83 ec 0c             	sub    $0xc,%esp
80103ee6:	ff 73 6c             	push   0x6c(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ee9:	83 c3 70             	add    $0x70,%ebx
  np->cwd = idup(curproc->cwd);
80103eec:	e8 5f d8 ff ff       	call   80101750 <idup>
80103ef1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ef4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103ef7:	89 47 6c             	mov    %eax,0x6c(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103efa:	8d 47 70             	lea    0x70(%edi),%eax
80103efd:	6a 10                	push   $0x10
80103eff:	53                   	push   %ebx
80103f00:	50                   	push   %eax
80103f01:	e8 0a 0d 00 00       	call   80104c10 <safestrcpy>
  pid = np->pid;
80103f06:	8b 5f 14             	mov    0x14(%edi),%ebx
  acquire(&ptable.lock);
80103f09:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103f10:	e8 7b 0a 00 00       	call   80104990 <acquire>
  np->state = RUNNABLE;
80103f15:	c7 47 10 03 00 00 00 	movl   $0x3,0x10(%edi)
  release(&ptable.lock);
80103f1c:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103f23:	e8 08 0a 00 00       	call   80104930 <release>
  return pid;
80103f28:	83 c4 10             	add    $0x10,%esp
}
80103f2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f2e:	89 d8                	mov    %ebx,%eax
80103f30:	5b                   	pop    %ebx
80103f31:	5e                   	pop    %esi
80103f32:	5f                   	pop    %edi
80103f33:	5d                   	pop    %ebp
80103f34:	c3                   	ret    
    return -1;
80103f35:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103f3a:	eb ef                	jmp    80103f2b <fork+0xdb>
    kfree(np->kstack);
80103f3c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103f3f:	83 ec 0c             	sub    $0xc,%esp
80103f42:	ff 73 0c             	push   0xc(%ebx)
80103f45:	e8 36 e7 ff ff       	call   80102680 <kfree>
    np->kstack = 0;
80103f4a:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103f51:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103f54:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return -1;
80103f5b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103f60:	eb c9                	jmp    80103f2b <fork+0xdb>
80103f62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f70 <print_rss>:
{
80103f70:	55                   	push   %ebp
80103f71:	89 e5                	mov    %esp,%ebp
80103f73:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f74:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
{
80103f79:	83 ec 10             	sub    $0x10,%esp
  cprintf("PrintingRSS\n");
80103f7c:	68 7b 7c 10 80       	push   $0x80107c7b
80103f81:	e8 1a c7 ff ff       	call   801006a0 <cprintf>
  acquire(&ptable.lock);
80103f86:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103f8d:	e8 fe 09 00 00       	call   80104990 <acquire>
80103f92:	83 c4 10             	add    $0x10,%esp
80103f95:	8d 76 00             	lea    0x0(%esi),%esi
    if((p->state == UNUSED))
80103f98:	8b 43 10             	mov    0x10(%ebx),%eax
80103f9b:	85 c0                	test   %eax,%eax
80103f9d:	74 14                	je     80103fb3 <print_rss+0x43>
    cprintf("((P)) id: %d, state: %d, rss: %d\n",p->pid,p->state,p->rss);
80103f9f:	ff 73 04             	push   0x4(%ebx)
80103fa2:	50                   	push   %eax
80103fa3:	ff 73 14             	push   0x14(%ebx)
80103fa6:	68 58 7d 10 80       	push   $0x80107d58
80103fab:	e8 f0 c6 ff ff       	call   801006a0 <cprintf>
80103fb0:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fb3:	83 eb 80             	sub    $0xffffff80,%ebx
80103fb6:	81 fb 74 5d 11 80    	cmp    $0x80115d74,%ebx
80103fbc:	75 da                	jne    80103f98 <print_rss+0x28>
  release(&ptable.lock);
80103fbe:	83 ec 0c             	sub    $0xc,%esp
80103fc1:	68 40 3d 11 80       	push   $0x80113d40
80103fc6:	e8 65 09 00 00       	call   80104930 <release>
}
80103fcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fce:	83 c4 10             	add    $0x10,%esp
80103fd1:	c9                   	leave  
80103fd2:	c3                   	ret    
80103fd3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103fe0 <scheduler>:
{
80103fe0:	55                   	push   %ebp
80103fe1:	89 e5                	mov    %esp,%ebp
80103fe3:	57                   	push   %edi
80103fe4:	56                   	push   %esi
80103fe5:	53                   	push   %ebx
80103fe6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103fe9:	e8 42 fc ff ff       	call   80103c30 <mycpu>
  c->proc = 0;
80103fee:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103ff5:	00 00 00 
  struct cpu *c = mycpu();
80103ff8:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103ffa:	8d 78 04             	lea    0x4(%eax),%edi
80103ffd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80104000:	fb                   	sti    
    acquire(&ptable.lock);
80104001:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104004:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
    acquire(&ptable.lock);
80104009:	68 40 3d 11 80       	push   $0x80113d40
8010400e:	e8 7d 09 00 00       	call   80104990 <acquire>
80104013:	83 c4 10             	add    $0x10,%esp
80104016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010401d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80104020:	83 7b 10 03          	cmpl   $0x3,0x10(%ebx)
80104024:	75 33                	jne    80104059 <scheduler+0x79>
      switchuvm(p);
80104026:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104029:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010402f:	53                   	push   %ebx
80104030:	e8 6b 2e 00 00       	call   80106ea0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104035:	58                   	pop    %eax
80104036:	5a                   	pop    %edx
80104037:	ff 73 20             	push   0x20(%ebx)
8010403a:	57                   	push   %edi
      p->state = RUNNING;
8010403b:	c7 43 10 04 00 00 00 	movl   $0x4,0x10(%ebx)
      swtch(&(c->scheduler), p->context);
80104042:	e8 24 0c 00 00       	call   80104c6b <swtch>
      switchkvm();
80104047:	e8 44 2e 00 00       	call   80106e90 <switchkvm>
      c->proc = 0;
8010404c:	83 c4 10             	add    $0x10,%esp
8010404f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104056:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104059:	83 eb 80             	sub    $0xffffff80,%ebx
8010405c:	81 fb 74 5d 11 80    	cmp    $0x80115d74,%ebx
80104062:	75 bc                	jne    80104020 <scheduler+0x40>
    release(&ptable.lock);
80104064:	83 ec 0c             	sub    $0xc,%esp
80104067:	68 40 3d 11 80       	push   $0x80113d40
8010406c:	e8 bf 08 00 00       	call   80104930 <release>
    sti();
80104071:	83 c4 10             	add    $0x10,%esp
80104074:	eb 8a                	jmp    80104000 <scheduler+0x20>
80104076:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010407d:	8d 76 00             	lea    0x0(%esi),%esi

80104080 <sched>:
{
80104080:	55                   	push   %ebp
80104081:	89 e5                	mov    %esp,%ebp
80104083:	56                   	push   %esi
80104084:	53                   	push   %ebx
  pushcli();
80104085:	e8 b6 07 00 00       	call   80104840 <pushcli>
  c = mycpu();
8010408a:	e8 a1 fb ff ff       	call   80103c30 <mycpu>
  p = c->proc;
8010408f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104095:	e8 f6 07 00 00       	call   80104890 <popcli>
  if(!holding(&ptable.lock))
8010409a:	83 ec 0c             	sub    $0xc,%esp
8010409d:	68 40 3d 11 80       	push   $0x80113d40
801040a2:	e8 49 08 00 00       	call   801048f0 <holding>
801040a7:	83 c4 10             	add    $0x10,%esp
801040aa:	85 c0                	test   %eax,%eax
801040ac:	74 4f                	je     801040fd <sched+0x7d>
  if(mycpu()->ncli != 1)
801040ae:	e8 7d fb ff ff       	call   80103c30 <mycpu>
801040b3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801040ba:	75 68                	jne    80104124 <sched+0xa4>
  if(p->state == RUNNING)
801040bc:	83 7b 10 04          	cmpl   $0x4,0x10(%ebx)
801040c0:	74 55                	je     80104117 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801040c2:	9c                   	pushf  
801040c3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801040c4:	f6 c4 02             	test   $0x2,%ah
801040c7:	75 41                	jne    8010410a <sched+0x8a>
  intena = mycpu()->intena;
801040c9:	e8 62 fb ff ff       	call   80103c30 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801040ce:	83 c3 20             	add    $0x20,%ebx
  intena = mycpu()->intena;
801040d1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801040d7:	e8 54 fb ff ff       	call   80103c30 <mycpu>
801040dc:	83 ec 08             	sub    $0x8,%esp
801040df:	ff 70 04             	push   0x4(%eax)
801040e2:	53                   	push   %ebx
801040e3:	e8 83 0b 00 00       	call   80104c6b <swtch>
  mycpu()->intena = intena;
801040e8:	e8 43 fb ff ff       	call   80103c30 <mycpu>
}
801040ed:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801040f0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801040f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040f9:	5b                   	pop    %ebx
801040fa:	5e                   	pop    %esi
801040fb:	5d                   	pop    %ebp
801040fc:	c3                   	ret    
    panic("sched ptable.lock");
801040fd:	83 ec 0c             	sub    $0xc,%esp
80104100:	68 88 7c 10 80       	push   $0x80107c88
80104105:	e8 76 c2 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
8010410a:	83 ec 0c             	sub    $0xc,%esp
8010410d:	68 b4 7c 10 80       	push   $0x80107cb4
80104112:	e8 69 c2 ff ff       	call   80100380 <panic>
    panic("sched running");
80104117:	83 ec 0c             	sub    $0xc,%esp
8010411a:	68 a6 7c 10 80       	push   $0x80107ca6
8010411f:	e8 5c c2 ff ff       	call   80100380 <panic>
    panic("sched locks");
80104124:	83 ec 0c             	sub    $0xc,%esp
80104127:	68 9a 7c 10 80       	push   $0x80107c9a
8010412c:	e8 4f c2 ff ff       	call   80100380 <panic>
80104131:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104138:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010413f:	90                   	nop

80104140 <exit>:
{
80104140:	55                   	push   %ebp
80104141:	89 e5                	mov    %esp,%ebp
80104143:	57                   	push   %edi
80104144:	56                   	push   %esi
80104145:	53                   	push   %ebx
80104146:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80104149:	e8 62 fb ff ff       	call   80103cb0 <myproc>
  if(curproc == initproc)
8010414e:	39 05 74 5d 11 80    	cmp    %eax,0x80115d74
80104154:	0f 84 fd 00 00 00    	je     80104257 <exit+0x117>
8010415a:	89 c3                	mov    %eax,%ebx
8010415c:	8d 70 2c             	lea    0x2c(%eax),%esi
8010415f:	8d 78 6c             	lea    0x6c(%eax),%edi
80104162:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80104168:	8b 06                	mov    (%esi),%eax
8010416a:	85 c0                	test   %eax,%eax
8010416c:	74 12                	je     80104180 <exit+0x40>
      fileclose(curproc->ofile[fd]);
8010416e:	83 ec 0c             	sub    $0xc,%esp
80104171:	50                   	push   %eax
80104172:	e8 79 cd ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
80104177:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010417d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104180:	83 c6 04             	add    $0x4,%esi
80104183:	39 f7                	cmp    %esi,%edi
80104185:	75 e1                	jne    80104168 <exit+0x28>
  begin_op();
80104187:	e8 14 ef ff ff       	call   801030a0 <begin_op>
  iput(curproc->cwd);
8010418c:	83 ec 0c             	sub    $0xc,%esp
8010418f:	ff 73 6c             	push   0x6c(%ebx)
80104192:	e8 19 d7 ff ff       	call   801018b0 <iput>
  end_op();
80104197:	e8 74 ef ff ff       	call   80103110 <end_op>
  curproc->cwd = 0;
8010419c:	c7 43 6c 00 00 00 00 	movl   $0x0,0x6c(%ebx)
  acquire(&ptable.lock);
801041a3:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
801041aa:	e8 e1 07 00 00       	call   80104990 <acquire>
  wakeup1(curproc->parent);
801041af:	8b 53 18             	mov    0x18(%ebx),%edx
801041b2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041b5:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
801041ba:	eb 0e                	jmp    801041ca <exit+0x8a>
801041bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041c0:	83 e8 80             	sub    $0xffffff80,%eax
801041c3:	3d 74 5d 11 80       	cmp    $0x80115d74,%eax
801041c8:	74 1c                	je     801041e6 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
801041ca:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
801041ce:	75 f0                	jne    801041c0 <exit+0x80>
801041d0:	3b 50 24             	cmp    0x24(%eax),%edx
801041d3:	75 eb                	jne    801041c0 <exit+0x80>
      p->state = RUNNABLE;
801041d5:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041dc:	83 e8 80             	sub    $0xffffff80,%eax
801041df:	3d 74 5d 11 80       	cmp    $0x80115d74,%eax
801041e4:	75 e4                	jne    801041ca <exit+0x8a>
      p->parent = initproc;
801041e6:	8b 0d 74 5d 11 80    	mov    0x80115d74,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041ec:	ba 74 3d 11 80       	mov    $0x80113d74,%edx
801041f1:	eb 10                	jmp    80104203 <exit+0xc3>
801041f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041f7:	90                   	nop
801041f8:	83 ea 80             	sub    $0xffffff80,%edx
801041fb:	81 fa 74 5d 11 80    	cmp    $0x80115d74,%edx
80104201:	74 3b                	je     8010423e <exit+0xfe>
    if(p->parent == curproc){
80104203:	39 5a 18             	cmp    %ebx,0x18(%edx)
80104206:	75 f0                	jne    801041f8 <exit+0xb8>
      if(p->state == ZOMBIE)
80104208:	83 7a 10 05          	cmpl   $0x5,0x10(%edx)
      p->parent = initproc;
8010420c:	89 4a 18             	mov    %ecx,0x18(%edx)
      if(p->state == ZOMBIE)
8010420f:	75 e7                	jne    801041f8 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104211:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
80104216:	eb 12                	jmp    8010422a <exit+0xea>
80104218:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010421f:	90                   	nop
80104220:	83 e8 80             	sub    $0xffffff80,%eax
80104223:	3d 74 5d 11 80       	cmp    $0x80115d74,%eax
80104228:	74 ce                	je     801041f8 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
8010422a:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
8010422e:	75 f0                	jne    80104220 <exit+0xe0>
80104230:	3b 48 24             	cmp    0x24(%eax),%ecx
80104233:	75 eb                	jne    80104220 <exit+0xe0>
      p->state = RUNNABLE;
80104235:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
8010423c:	eb e2                	jmp    80104220 <exit+0xe0>
  curproc->state = ZOMBIE;
8010423e:	c7 43 10 05 00 00 00 	movl   $0x5,0x10(%ebx)
  sched();
80104245:	e8 36 fe ff ff       	call   80104080 <sched>
  panic("zombie exit");
8010424a:	83 ec 0c             	sub    $0xc,%esp
8010424d:	68 d5 7c 10 80       	push   $0x80107cd5
80104252:	e8 29 c1 ff ff       	call   80100380 <panic>
    panic("init exiting");
80104257:	83 ec 0c             	sub    $0xc,%esp
8010425a:	68 c8 7c 10 80       	push   $0x80107cc8
8010425f:	e8 1c c1 ff ff       	call   80100380 <panic>
80104264:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010426b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010426f:	90                   	nop

80104270 <wait>:
{
80104270:	55                   	push   %ebp
80104271:	89 e5                	mov    %esp,%ebp
80104273:	56                   	push   %esi
80104274:	53                   	push   %ebx
  pushcli();
80104275:	e8 c6 05 00 00       	call   80104840 <pushcli>
  c = mycpu();
8010427a:	e8 b1 f9 ff ff       	call   80103c30 <mycpu>
  p = c->proc;
8010427f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104285:	e8 06 06 00 00       	call   80104890 <popcli>
  acquire(&ptable.lock);
8010428a:	83 ec 0c             	sub    $0xc,%esp
8010428d:	68 40 3d 11 80       	push   $0x80113d40
80104292:	e8 f9 06 00 00       	call   80104990 <acquire>
80104297:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010429a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010429c:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
801042a1:	eb 10                	jmp    801042b3 <wait+0x43>
801042a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042a7:	90                   	nop
801042a8:	83 eb 80             	sub    $0xffffff80,%ebx
801042ab:	81 fb 74 5d 11 80    	cmp    $0x80115d74,%ebx
801042b1:	74 1b                	je     801042ce <wait+0x5e>
      if(p->parent != curproc)
801042b3:	39 73 18             	cmp    %esi,0x18(%ebx)
801042b6:	75 f0                	jne    801042a8 <wait+0x38>
      if(p->state == ZOMBIE){
801042b8:	83 7b 10 05          	cmpl   $0x5,0x10(%ebx)
801042bc:	74 62                	je     80104320 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042be:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
801042c1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042c6:	81 fb 74 5d 11 80    	cmp    $0x80115d74,%ebx
801042cc:	75 e5                	jne    801042b3 <wait+0x43>
    if(!havekids || curproc->killed){
801042ce:	85 c0                	test   %eax,%eax
801042d0:	0f 84 a0 00 00 00    	je     80104376 <wait+0x106>
801042d6:	8b 46 28             	mov    0x28(%esi),%eax
801042d9:	85 c0                	test   %eax,%eax
801042db:	0f 85 95 00 00 00    	jne    80104376 <wait+0x106>
  pushcli();
801042e1:	e8 5a 05 00 00       	call   80104840 <pushcli>
  c = mycpu();
801042e6:	e8 45 f9 ff ff       	call   80103c30 <mycpu>
  p = c->proc;
801042eb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042f1:	e8 9a 05 00 00       	call   80104890 <popcli>
  if(p == 0)
801042f6:	85 db                	test   %ebx,%ebx
801042f8:	0f 84 8f 00 00 00    	je     8010438d <wait+0x11d>
  p->chan = chan;
801042fe:	89 73 24             	mov    %esi,0x24(%ebx)
  p->state = SLEEPING;
80104301:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
80104308:	e8 73 fd ff ff       	call   80104080 <sched>
  p->chan = 0;
8010430d:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
}
80104314:	eb 84                	jmp    8010429a <wait+0x2a>
80104316:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010431d:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104320:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104323:	8b 73 14             	mov    0x14(%ebx),%esi
        kfree(p->kstack);
80104326:	ff 73 0c             	push   0xc(%ebx)
80104329:	e8 52 e3 ff ff       	call   80102680 <kfree>
        p->kstack = 0;
8010432e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        freevm(p->pgdir);
80104335:	5a                   	pop    %edx
80104336:	ff 73 08             	push   0x8(%ebx)
80104339:	e8 42 2f 00 00       	call   80107280 <freevm>
        p->pid = 0;
8010433e:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->parent = 0;
80104345:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
        p->name[0] = 0;
8010434c:	c6 43 70 00          	movb   $0x0,0x70(%ebx)
        p->killed = 0;
80104350:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
        p->state = UNUSED;
80104357:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        release(&ptable.lock);
8010435e:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80104365:	e8 c6 05 00 00       	call   80104930 <release>
        return pid;
8010436a:	83 c4 10             	add    $0x10,%esp
}
8010436d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104370:	89 f0                	mov    %esi,%eax
80104372:	5b                   	pop    %ebx
80104373:	5e                   	pop    %esi
80104374:	5d                   	pop    %ebp
80104375:	c3                   	ret    
      release(&ptable.lock);
80104376:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104379:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010437e:	68 40 3d 11 80       	push   $0x80113d40
80104383:	e8 a8 05 00 00       	call   80104930 <release>
      return -1;
80104388:	83 c4 10             	add    $0x10,%esp
8010438b:	eb e0                	jmp    8010436d <wait+0xfd>
    panic("sleep");
8010438d:	83 ec 0c             	sub    $0xc,%esp
80104390:	68 e1 7c 10 80       	push   $0x80107ce1
80104395:	e8 e6 bf ff ff       	call   80100380 <panic>
8010439a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043a0 <yield>:
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	53                   	push   %ebx
801043a4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801043a7:	68 40 3d 11 80       	push   $0x80113d40
801043ac:	e8 df 05 00 00       	call   80104990 <acquire>
  pushcli();
801043b1:	e8 8a 04 00 00       	call   80104840 <pushcli>
  c = mycpu();
801043b6:	e8 75 f8 ff ff       	call   80103c30 <mycpu>
  p = c->proc;
801043bb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043c1:	e8 ca 04 00 00       	call   80104890 <popcli>
  myproc()->state = RUNNABLE;
801043c6:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  sched();
801043cd:	e8 ae fc ff ff       	call   80104080 <sched>
  release(&ptable.lock);
801043d2:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
801043d9:	e8 52 05 00 00       	call   80104930 <release>
}
801043de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043e1:	83 c4 10             	add    $0x10,%esp
801043e4:	c9                   	leave  
801043e5:	c3                   	ret    
801043e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043ed:	8d 76 00             	lea    0x0(%esi),%esi

801043f0 <sleep>:
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	57                   	push   %edi
801043f4:	56                   	push   %esi
801043f5:	53                   	push   %ebx
801043f6:	83 ec 0c             	sub    $0xc,%esp
801043f9:	8b 7d 08             	mov    0x8(%ebp),%edi
801043fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801043ff:	e8 3c 04 00 00       	call   80104840 <pushcli>
  c = mycpu();
80104404:	e8 27 f8 ff ff       	call   80103c30 <mycpu>
  p = c->proc;
80104409:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010440f:	e8 7c 04 00 00       	call   80104890 <popcli>
  if(p == 0)
80104414:	85 db                	test   %ebx,%ebx
80104416:	0f 84 87 00 00 00    	je     801044a3 <sleep+0xb3>
  if(lk == 0)
8010441c:	85 f6                	test   %esi,%esi
8010441e:	74 76                	je     80104496 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104420:	81 fe 40 3d 11 80    	cmp    $0x80113d40,%esi
80104426:	74 50                	je     80104478 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104428:	83 ec 0c             	sub    $0xc,%esp
8010442b:	68 40 3d 11 80       	push   $0x80113d40
80104430:	e8 5b 05 00 00       	call   80104990 <acquire>
    release(lk);
80104435:	89 34 24             	mov    %esi,(%esp)
80104438:	e8 f3 04 00 00       	call   80104930 <release>
  p->chan = chan;
8010443d:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
80104440:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
80104447:	e8 34 fc ff ff       	call   80104080 <sched>
  p->chan = 0;
8010444c:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
    release(&ptable.lock);
80104453:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
8010445a:	e8 d1 04 00 00       	call   80104930 <release>
    acquire(lk);
8010445f:	89 75 08             	mov    %esi,0x8(%ebp)
80104462:	83 c4 10             	add    $0x10,%esp
}
80104465:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104468:	5b                   	pop    %ebx
80104469:	5e                   	pop    %esi
8010446a:	5f                   	pop    %edi
8010446b:	5d                   	pop    %ebp
    acquire(lk);
8010446c:	e9 1f 05 00 00       	jmp    80104990 <acquire>
80104471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104478:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
8010447b:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
80104482:	e8 f9 fb ff ff       	call   80104080 <sched>
  p->chan = 0;
80104487:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
}
8010448e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104491:	5b                   	pop    %ebx
80104492:	5e                   	pop    %esi
80104493:	5f                   	pop    %edi
80104494:	5d                   	pop    %ebp
80104495:	c3                   	ret    
    panic("sleep without lk");
80104496:	83 ec 0c             	sub    $0xc,%esp
80104499:	68 e7 7c 10 80       	push   $0x80107ce7
8010449e:	e8 dd be ff ff       	call   80100380 <panic>
    panic("sleep");
801044a3:	83 ec 0c             	sub    $0xc,%esp
801044a6:	68 e1 7c 10 80       	push   $0x80107ce1
801044ab:	e8 d0 be ff ff       	call   80100380 <panic>

801044b0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	53                   	push   %ebx
801044b4:	83 ec 10             	sub    $0x10,%esp
801044b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801044ba:	68 40 3d 11 80       	push   $0x80113d40
801044bf:	e8 cc 04 00 00       	call   80104990 <acquire>
801044c4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044c7:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
801044cc:	eb 0c                	jmp    801044da <wakeup+0x2a>
801044ce:	66 90                	xchg   %ax,%ax
801044d0:	83 e8 80             	sub    $0xffffff80,%eax
801044d3:	3d 74 5d 11 80       	cmp    $0x80115d74,%eax
801044d8:	74 1c                	je     801044f6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
801044da:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
801044de:	75 f0                	jne    801044d0 <wakeup+0x20>
801044e0:	3b 58 24             	cmp    0x24(%eax),%ebx
801044e3:	75 eb                	jne    801044d0 <wakeup+0x20>
      p->state = RUNNABLE;
801044e5:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044ec:	83 e8 80             	sub    $0xffffff80,%eax
801044ef:	3d 74 5d 11 80       	cmp    $0x80115d74,%eax
801044f4:	75 e4                	jne    801044da <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
801044f6:	c7 45 08 40 3d 11 80 	movl   $0x80113d40,0x8(%ebp)
}
801044fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104500:	c9                   	leave  
  release(&ptable.lock);
80104501:	e9 2a 04 00 00       	jmp    80104930 <release>
80104506:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010450d:	8d 76 00             	lea    0x0(%esi),%esi

80104510 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	53                   	push   %ebx
80104514:	83 ec 10             	sub    $0x10,%esp
80104517:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010451a:	68 40 3d 11 80       	push   $0x80113d40
8010451f:	e8 6c 04 00 00       	call   80104990 <acquire>
80104524:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104527:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
8010452c:	eb 0c                	jmp    8010453a <kill+0x2a>
8010452e:	66 90                	xchg   %ax,%ax
80104530:	83 e8 80             	sub    $0xffffff80,%eax
80104533:	3d 74 5d 11 80       	cmp    $0x80115d74,%eax
80104538:	74 36                	je     80104570 <kill+0x60>
    if(p->pid == pid){
8010453a:	39 58 14             	cmp    %ebx,0x14(%eax)
8010453d:	75 f1                	jne    80104530 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010453f:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
      p->killed = 1;
80104543:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
      if(p->state == SLEEPING)
8010454a:	75 07                	jne    80104553 <kill+0x43>
        p->state = RUNNABLE;
8010454c:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
      release(&ptable.lock);
80104553:	83 ec 0c             	sub    $0xc,%esp
80104556:	68 40 3d 11 80       	push   $0x80113d40
8010455b:	e8 d0 03 00 00       	call   80104930 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104560:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104563:	83 c4 10             	add    $0x10,%esp
80104566:	31 c0                	xor    %eax,%eax
}
80104568:	c9                   	leave  
80104569:	c3                   	ret    
8010456a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104570:	83 ec 0c             	sub    $0xc,%esp
80104573:	68 40 3d 11 80       	push   $0x80113d40
80104578:	e8 b3 03 00 00       	call   80104930 <release>
}
8010457d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104580:	83 c4 10             	add    $0x10,%esp
80104583:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104588:	c9                   	leave  
80104589:	c3                   	ret    
8010458a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104590 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	57                   	push   %edi
80104594:	56                   	push   %esi
80104595:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104598:	53                   	push   %ebx
80104599:	bb e4 3d 11 80       	mov    $0x80113de4,%ebx
8010459e:	83 ec 3c             	sub    $0x3c,%esp
801045a1:	eb 24                	jmp    801045c7 <procdump+0x37>
801045a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045a7:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801045a8:	83 ec 0c             	sub    $0xc,%esp
801045ab:	68 07 81 10 80       	push   $0x80108107
801045b0:	e8 eb c0 ff ff       	call   801006a0 <cprintf>
801045b5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045b8:	83 eb 80             	sub    $0xffffff80,%ebx
801045bb:	81 fb e4 5d 11 80    	cmp    $0x80115de4,%ebx
801045c1:	0f 84 81 00 00 00    	je     80104648 <procdump+0xb8>
    if(p->state == UNUSED)
801045c7:	8b 43 a0             	mov    -0x60(%ebx),%eax
801045ca:	85 c0                	test   %eax,%eax
801045cc:	74 ea                	je     801045b8 <procdump+0x28>
      state = "???";
801045ce:	ba f8 7c 10 80       	mov    $0x80107cf8,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801045d3:	83 f8 05             	cmp    $0x5,%eax
801045d6:	77 11                	ja     801045e9 <procdump+0x59>
801045d8:	8b 14 85 a4 7d 10 80 	mov    -0x7fef825c(,%eax,4),%edx
      state = "???";
801045df:	b8 f8 7c 10 80       	mov    $0x80107cf8,%eax
801045e4:	85 d2                	test   %edx,%edx
801045e6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801045e9:	53                   	push   %ebx
801045ea:	52                   	push   %edx
801045eb:	ff 73 a4             	push   -0x5c(%ebx)
801045ee:	68 fc 7c 10 80       	push   $0x80107cfc
801045f3:	e8 a8 c0 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
801045f8:	83 c4 10             	add    $0x10,%esp
801045fb:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801045ff:	75 a7                	jne    801045a8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104601:	83 ec 08             	sub    $0x8,%esp
80104604:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104607:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010460a:	50                   	push   %eax
8010460b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010460e:	8b 40 0c             	mov    0xc(%eax),%eax
80104611:	83 c0 08             	add    $0x8,%eax
80104614:	50                   	push   %eax
80104615:	e8 c6 01 00 00       	call   801047e0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010461a:	83 c4 10             	add    $0x10,%esp
8010461d:	8d 76 00             	lea    0x0(%esi),%esi
80104620:	8b 17                	mov    (%edi),%edx
80104622:	85 d2                	test   %edx,%edx
80104624:	74 82                	je     801045a8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104626:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104629:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010462c:	52                   	push   %edx
8010462d:	68 41 77 10 80       	push   $0x80107741
80104632:	e8 69 c0 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104637:	83 c4 10             	add    $0x10,%esp
8010463a:	39 fe                	cmp    %edi,%esi
8010463c:	75 e2                	jne    80104620 <procdump+0x90>
8010463e:	e9 65 ff ff ff       	jmp    801045a8 <procdump+0x18>
80104643:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104647:	90                   	nop
  }
}
80104648:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010464b:	5b                   	pop    %ebx
8010464c:	5e                   	pop    %esi
8010464d:	5f                   	pop    %edi
8010464e:	5d                   	pop    %ebp
8010464f:	c3                   	ret    

80104650 <add_to_rmap>:


//updating rmap array for corresponding process with virtual 
void add_to_rmap(int pid, uint vpa)
{
80104650:	55                   	push   %ebp
  struct proc* p;
  for(p=ptable.proc;p<&ptable.proc[NPROC];p++)
80104651:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
{
80104656:	89 e5                	mov    %esp,%ebp
80104658:	83 ec 08             	sub    $0x8,%esp
8010465b:	8b 55 08             	mov    0x8(%ebp),%edx
8010465e:	eb 0a                	jmp    8010466a <add_to_rmap+0x1a>
  for(p=ptable.proc;p<&ptable.proc[NPROC];p++)
80104660:	83 e8 80             	sub    $0xffffff80,%eax
80104663:	3d 74 5d 11 80       	cmp    $0x80115d74,%eax
80104668:	74 0e                	je     80104678 <add_to_rmap+0x28>
  {
    if(p->pid==pid) break;
8010466a:	39 50 14             	cmp    %edx,0x14(%eax)
8010466d:	75 f1                	jne    80104660 <add_to_rmap+0x10>
  }
  if(p>=&ptable.proc[NPROC])
8010466f:	3d 74 5d 11 80       	cmp    $0x80115d74,%eax
80104674:	73 02                	jae    80104678 <add_to_rmap+0x28>
      panic("adding page of process that not exist.");
  
}
80104676:	c9                   	leave  
80104677:	c3                   	ret    
      panic("adding page of process that not exist.");
80104678:	83 ec 0c             	sub    $0xc,%esp
8010467b:	68 7c 7d 10 80       	push   $0x80107d7c
80104680:	e8 fb bc ff ff       	call   80100380 <panic>
80104685:	66 90                	xchg   %ax,%ax
80104687:	66 90                	xchg   %ax,%ax
80104689:	66 90                	xchg   %ax,%ax
8010468b:	66 90                	xchg   %ax,%ax
8010468d:	66 90                	xchg   %ax,%ax
8010468f:	90                   	nop

80104690 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	53                   	push   %ebx
80104694:	83 ec 0c             	sub    $0xc,%esp
80104697:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010469a:	68 bc 7d 10 80       	push   $0x80107dbc
8010469f:	8d 43 04             	lea    0x4(%ebx),%eax
801046a2:	50                   	push   %eax
801046a3:	e8 18 01 00 00       	call   801047c0 <initlock>
  lk->name = name;
801046a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801046ab:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801046b1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801046b4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801046bb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801046be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046c1:	c9                   	leave  
801046c2:	c3                   	ret    
801046c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046d0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	56                   	push   %esi
801046d4:	53                   	push   %ebx
801046d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801046d8:	8d 73 04             	lea    0x4(%ebx),%esi
801046db:	83 ec 0c             	sub    $0xc,%esp
801046de:	56                   	push   %esi
801046df:	e8 ac 02 00 00       	call   80104990 <acquire>
  while (lk->locked) {
801046e4:	8b 13                	mov    (%ebx),%edx
801046e6:	83 c4 10             	add    $0x10,%esp
801046e9:	85 d2                	test   %edx,%edx
801046eb:	74 16                	je     80104703 <acquiresleep+0x33>
801046ed:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801046f0:	83 ec 08             	sub    $0x8,%esp
801046f3:	56                   	push   %esi
801046f4:	53                   	push   %ebx
801046f5:	e8 f6 fc ff ff       	call   801043f0 <sleep>
  while (lk->locked) {
801046fa:	8b 03                	mov    (%ebx),%eax
801046fc:	83 c4 10             	add    $0x10,%esp
801046ff:	85 c0                	test   %eax,%eax
80104701:	75 ed                	jne    801046f0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104703:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104709:	e8 a2 f5 ff ff       	call   80103cb0 <myproc>
8010470e:	8b 40 14             	mov    0x14(%eax),%eax
80104711:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104714:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104717:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010471a:	5b                   	pop    %ebx
8010471b:	5e                   	pop    %esi
8010471c:	5d                   	pop    %ebp
  release(&lk->lk);
8010471d:	e9 0e 02 00 00       	jmp    80104930 <release>
80104722:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104730 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	56                   	push   %esi
80104734:	53                   	push   %ebx
80104735:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104738:	8d 73 04             	lea    0x4(%ebx),%esi
8010473b:	83 ec 0c             	sub    $0xc,%esp
8010473e:	56                   	push   %esi
8010473f:	e8 4c 02 00 00       	call   80104990 <acquire>
  lk->locked = 0;
80104744:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010474a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104751:	89 1c 24             	mov    %ebx,(%esp)
80104754:	e8 57 fd ff ff       	call   801044b0 <wakeup>
  release(&lk->lk);
80104759:	89 75 08             	mov    %esi,0x8(%ebp)
8010475c:	83 c4 10             	add    $0x10,%esp
}
8010475f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104762:	5b                   	pop    %ebx
80104763:	5e                   	pop    %esi
80104764:	5d                   	pop    %ebp
  release(&lk->lk);
80104765:	e9 c6 01 00 00       	jmp    80104930 <release>
8010476a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104770 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	57                   	push   %edi
80104774:	31 ff                	xor    %edi,%edi
80104776:	56                   	push   %esi
80104777:	53                   	push   %ebx
80104778:	83 ec 18             	sub    $0x18,%esp
8010477b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010477e:	8d 73 04             	lea    0x4(%ebx),%esi
80104781:	56                   	push   %esi
80104782:	e8 09 02 00 00       	call   80104990 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104787:	8b 03                	mov    (%ebx),%eax
80104789:	83 c4 10             	add    $0x10,%esp
8010478c:	85 c0                	test   %eax,%eax
8010478e:	75 18                	jne    801047a8 <holdingsleep+0x38>
  release(&lk->lk);
80104790:	83 ec 0c             	sub    $0xc,%esp
80104793:	56                   	push   %esi
80104794:	e8 97 01 00 00       	call   80104930 <release>
  return r;
}
80104799:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010479c:	89 f8                	mov    %edi,%eax
8010479e:	5b                   	pop    %ebx
8010479f:	5e                   	pop    %esi
801047a0:	5f                   	pop    %edi
801047a1:	5d                   	pop    %ebp
801047a2:	c3                   	ret    
801047a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047a7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
801047a8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801047ab:	e8 00 f5 ff ff       	call   80103cb0 <myproc>
801047b0:	39 58 14             	cmp    %ebx,0x14(%eax)
801047b3:	0f 94 c0             	sete   %al
801047b6:	0f b6 c0             	movzbl %al,%eax
801047b9:	89 c7                	mov    %eax,%edi
801047bb:	eb d3                	jmp    80104790 <holdingsleep+0x20>
801047bd:	66 90                	xchg   %ax,%ax
801047bf:	90                   	nop

801047c0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801047c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801047c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801047cf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801047d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801047d9:	5d                   	pop    %ebp
801047da:	c3                   	ret    
801047db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047df:	90                   	nop

801047e0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801047e0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801047e1:	31 d2                	xor    %edx,%edx
{
801047e3:	89 e5                	mov    %esp,%ebp
801047e5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801047e6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801047e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801047ec:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801047ef:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801047f0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801047f6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801047fc:	77 1a                	ja     80104818 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801047fe:	8b 58 04             	mov    0x4(%eax),%ebx
80104801:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104804:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104807:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104809:	83 fa 0a             	cmp    $0xa,%edx
8010480c:	75 e2                	jne    801047f0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010480e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104811:	c9                   	leave  
80104812:	c3                   	ret    
80104813:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104817:	90                   	nop
  for(; i < 10; i++)
80104818:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010481b:	8d 51 28             	lea    0x28(%ecx),%edx
8010481e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104820:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104826:	83 c0 04             	add    $0x4,%eax
80104829:	39 d0                	cmp    %edx,%eax
8010482b:	75 f3                	jne    80104820 <getcallerpcs+0x40>
}
8010482d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104830:	c9                   	leave  
80104831:	c3                   	ret    
80104832:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104840 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	53                   	push   %ebx
80104844:	83 ec 04             	sub    $0x4,%esp
80104847:	9c                   	pushf  
80104848:	5b                   	pop    %ebx
  asm volatile("cli");
80104849:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010484a:	e8 e1 f3 ff ff       	call   80103c30 <mycpu>
8010484f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104855:	85 c0                	test   %eax,%eax
80104857:	74 17                	je     80104870 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104859:	e8 d2 f3 ff ff       	call   80103c30 <mycpu>
8010485e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104865:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104868:	c9                   	leave  
80104869:	c3                   	ret    
8010486a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104870:	e8 bb f3 ff ff       	call   80103c30 <mycpu>
80104875:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010487b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104881:	eb d6                	jmp    80104859 <pushcli+0x19>
80104883:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010488a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104890 <popcli>:

void
popcli(void)
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104896:	9c                   	pushf  
80104897:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104898:	f6 c4 02             	test   $0x2,%ah
8010489b:	75 35                	jne    801048d2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010489d:	e8 8e f3 ff ff       	call   80103c30 <mycpu>
801048a2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801048a9:	78 34                	js     801048df <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801048ab:	e8 80 f3 ff ff       	call   80103c30 <mycpu>
801048b0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801048b6:	85 d2                	test   %edx,%edx
801048b8:	74 06                	je     801048c0 <popcli+0x30>
    sti();
}
801048ba:	c9                   	leave  
801048bb:	c3                   	ret    
801048bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801048c0:	e8 6b f3 ff ff       	call   80103c30 <mycpu>
801048c5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801048cb:	85 c0                	test   %eax,%eax
801048cd:	74 eb                	je     801048ba <popcli+0x2a>
  asm volatile("sti");
801048cf:	fb                   	sti    
}
801048d0:	c9                   	leave  
801048d1:	c3                   	ret    
    panic("popcli - interruptible");
801048d2:	83 ec 0c             	sub    $0xc,%esp
801048d5:	68 c7 7d 10 80       	push   $0x80107dc7
801048da:	e8 a1 ba ff ff       	call   80100380 <panic>
    panic("popcli");
801048df:	83 ec 0c             	sub    $0xc,%esp
801048e2:	68 de 7d 10 80       	push   $0x80107dde
801048e7:	e8 94 ba ff ff       	call   80100380 <panic>
801048ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048f0 <holding>:
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	56                   	push   %esi
801048f4:	53                   	push   %ebx
801048f5:	8b 75 08             	mov    0x8(%ebp),%esi
801048f8:	31 db                	xor    %ebx,%ebx
  pushcli();
801048fa:	e8 41 ff ff ff       	call   80104840 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801048ff:	8b 06                	mov    (%esi),%eax
80104901:	85 c0                	test   %eax,%eax
80104903:	75 0b                	jne    80104910 <holding+0x20>
  popcli();
80104905:	e8 86 ff ff ff       	call   80104890 <popcli>
}
8010490a:	89 d8                	mov    %ebx,%eax
8010490c:	5b                   	pop    %ebx
8010490d:	5e                   	pop    %esi
8010490e:	5d                   	pop    %ebp
8010490f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104910:	8b 5e 08             	mov    0x8(%esi),%ebx
80104913:	e8 18 f3 ff ff       	call   80103c30 <mycpu>
80104918:	39 c3                	cmp    %eax,%ebx
8010491a:	0f 94 c3             	sete   %bl
  popcli();
8010491d:	e8 6e ff ff ff       	call   80104890 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104922:	0f b6 db             	movzbl %bl,%ebx
}
80104925:	89 d8                	mov    %ebx,%eax
80104927:	5b                   	pop    %ebx
80104928:	5e                   	pop    %esi
80104929:	5d                   	pop    %ebp
8010492a:	c3                   	ret    
8010492b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010492f:	90                   	nop

80104930 <release>:
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	56                   	push   %esi
80104934:	53                   	push   %ebx
80104935:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104938:	e8 03 ff ff ff       	call   80104840 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010493d:	8b 03                	mov    (%ebx),%eax
8010493f:	85 c0                	test   %eax,%eax
80104941:	75 15                	jne    80104958 <release+0x28>
  popcli();
80104943:	e8 48 ff ff ff       	call   80104890 <popcli>
    panic("release");
80104948:	83 ec 0c             	sub    $0xc,%esp
8010494b:	68 e5 7d 10 80       	push   $0x80107de5
80104950:	e8 2b ba ff ff       	call   80100380 <panic>
80104955:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104958:	8b 73 08             	mov    0x8(%ebx),%esi
8010495b:	e8 d0 f2 ff ff       	call   80103c30 <mycpu>
80104960:	39 c6                	cmp    %eax,%esi
80104962:	75 df                	jne    80104943 <release+0x13>
  popcli();
80104964:	e8 27 ff ff ff       	call   80104890 <popcli>
  lk->pcs[0] = 0;
80104969:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104970:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104977:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010497c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104982:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104985:	5b                   	pop    %ebx
80104986:	5e                   	pop    %esi
80104987:	5d                   	pop    %ebp
  popcli();
80104988:	e9 03 ff ff ff       	jmp    80104890 <popcli>
8010498d:	8d 76 00             	lea    0x0(%esi),%esi

80104990 <acquire>:
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	53                   	push   %ebx
80104994:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104997:	e8 a4 fe ff ff       	call   80104840 <pushcli>
  if(holding(lk))
8010499c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010499f:	e8 9c fe ff ff       	call   80104840 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801049a4:	8b 03                	mov    (%ebx),%eax
801049a6:	85 c0                	test   %eax,%eax
801049a8:	75 7e                	jne    80104a28 <acquire+0x98>
  popcli();
801049aa:	e8 e1 fe ff ff       	call   80104890 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801049af:	b9 01 00 00 00       	mov    $0x1,%ecx
801049b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
801049b8:	8b 55 08             	mov    0x8(%ebp),%edx
801049bb:	89 c8                	mov    %ecx,%eax
801049bd:	f0 87 02             	lock xchg %eax,(%edx)
801049c0:	85 c0                	test   %eax,%eax
801049c2:	75 f4                	jne    801049b8 <acquire+0x28>
  __sync_synchronize();
801049c4:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801049c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801049cc:	e8 5f f2 ff ff       	call   80103c30 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801049d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
801049d4:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
801049d6:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
801049d9:	31 c0                	xor    %eax,%eax
801049db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049df:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801049e0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801049e6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801049ec:	77 1a                	ja     80104a08 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
801049ee:	8b 5a 04             	mov    0x4(%edx),%ebx
801049f1:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801049f5:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801049f8:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801049fa:	83 f8 0a             	cmp    $0xa,%eax
801049fd:	75 e1                	jne    801049e0 <acquire+0x50>
}
801049ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a02:	c9                   	leave  
80104a03:	c3                   	ret    
80104a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104a08:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
80104a0c:	8d 51 34             	lea    0x34(%ecx),%edx
80104a0f:	90                   	nop
    pcs[i] = 0;
80104a10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104a16:	83 c0 04             	add    $0x4,%eax
80104a19:	39 c2                	cmp    %eax,%edx
80104a1b:	75 f3                	jne    80104a10 <acquire+0x80>
}
80104a1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a20:	c9                   	leave  
80104a21:	c3                   	ret    
80104a22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104a28:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104a2b:	e8 00 f2 ff ff       	call   80103c30 <mycpu>
80104a30:	39 c3                	cmp    %eax,%ebx
80104a32:	0f 85 72 ff ff ff    	jne    801049aa <acquire+0x1a>
  popcli();
80104a38:	e8 53 fe ff ff       	call   80104890 <popcli>
    panic("acquire");
80104a3d:	83 ec 0c             	sub    $0xc,%esp
80104a40:	68 ed 7d 10 80       	push   $0x80107ded
80104a45:	e8 36 b9 ff ff       	call   80100380 <panic>
80104a4a:	66 90                	xchg   %ax,%ax
80104a4c:	66 90                	xchg   %ax,%ax
80104a4e:	66 90                	xchg   %ax,%ax

80104a50 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	57                   	push   %edi
80104a54:	8b 55 08             	mov    0x8(%ebp),%edx
80104a57:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104a5a:	53                   	push   %ebx
80104a5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104a5e:	89 d7                	mov    %edx,%edi
80104a60:	09 cf                	or     %ecx,%edi
80104a62:	83 e7 03             	and    $0x3,%edi
80104a65:	75 29                	jne    80104a90 <memset+0x40>
    c &= 0xFF;
80104a67:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104a6a:	c1 e0 18             	shl    $0x18,%eax
80104a6d:	89 fb                	mov    %edi,%ebx
80104a6f:	c1 e9 02             	shr    $0x2,%ecx
80104a72:	c1 e3 10             	shl    $0x10,%ebx
80104a75:	09 d8                	or     %ebx,%eax
80104a77:	09 f8                	or     %edi,%eax
80104a79:	c1 e7 08             	shl    $0x8,%edi
80104a7c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104a7e:	89 d7                	mov    %edx,%edi
80104a80:	fc                   	cld    
80104a81:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104a83:	5b                   	pop    %ebx
80104a84:	89 d0                	mov    %edx,%eax
80104a86:	5f                   	pop    %edi
80104a87:	5d                   	pop    %ebp
80104a88:	c3                   	ret    
80104a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104a90:	89 d7                	mov    %edx,%edi
80104a92:	fc                   	cld    
80104a93:	f3 aa                	rep stos %al,%es:(%edi)
80104a95:	5b                   	pop    %ebx
80104a96:	89 d0                	mov    %edx,%eax
80104a98:	5f                   	pop    %edi
80104a99:	5d                   	pop    %ebp
80104a9a:	c3                   	ret    
80104a9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a9f:	90                   	nop

80104aa0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	56                   	push   %esi
80104aa4:	8b 75 10             	mov    0x10(%ebp),%esi
80104aa7:	8b 55 08             	mov    0x8(%ebp),%edx
80104aaa:	53                   	push   %ebx
80104aab:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104aae:	85 f6                	test   %esi,%esi
80104ab0:	74 2e                	je     80104ae0 <memcmp+0x40>
80104ab2:	01 c6                	add    %eax,%esi
80104ab4:	eb 14                	jmp    80104aca <memcmp+0x2a>
80104ab6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104abd:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104ac0:	83 c0 01             	add    $0x1,%eax
80104ac3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104ac6:	39 f0                	cmp    %esi,%eax
80104ac8:	74 16                	je     80104ae0 <memcmp+0x40>
    if(*s1 != *s2)
80104aca:	0f b6 0a             	movzbl (%edx),%ecx
80104acd:	0f b6 18             	movzbl (%eax),%ebx
80104ad0:	38 d9                	cmp    %bl,%cl
80104ad2:	74 ec                	je     80104ac0 <memcmp+0x20>
      return *s1 - *s2;
80104ad4:	0f b6 c1             	movzbl %cl,%eax
80104ad7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104ad9:	5b                   	pop    %ebx
80104ada:	5e                   	pop    %esi
80104adb:	5d                   	pop    %ebp
80104adc:	c3                   	ret    
80104add:	8d 76 00             	lea    0x0(%esi),%esi
80104ae0:	5b                   	pop    %ebx
  return 0;
80104ae1:	31 c0                	xor    %eax,%eax
}
80104ae3:	5e                   	pop    %esi
80104ae4:	5d                   	pop    %ebp
80104ae5:	c3                   	ret    
80104ae6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aed:	8d 76 00             	lea    0x0(%esi),%esi

80104af0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	57                   	push   %edi
80104af4:	8b 55 08             	mov    0x8(%ebp),%edx
80104af7:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104afa:	56                   	push   %esi
80104afb:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104afe:	39 d6                	cmp    %edx,%esi
80104b00:	73 26                	jae    80104b28 <memmove+0x38>
80104b02:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104b05:	39 fa                	cmp    %edi,%edx
80104b07:	73 1f                	jae    80104b28 <memmove+0x38>
80104b09:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104b0c:	85 c9                	test   %ecx,%ecx
80104b0e:	74 0c                	je     80104b1c <memmove+0x2c>
      *--d = *--s;
80104b10:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104b14:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104b17:	83 e8 01             	sub    $0x1,%eax
80104b1a:	73 f4                	jae    80104b10 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104b1c:	5e                   	pop    %esi
80104b1d:	89 d0                	mov    %edx,%eax
80104b1f:	5f                   	pop    %edi
80104b20:	5d                   	pop    %ebp
80104b21:	c3                   	ret    
80104b22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104b28:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104b2b:	89 d7                	mov    %edx,%edi
80104b2d:	85 c9                	test   %ecx,%ecx
80104b2f:	74 eb                	je     80104b1c <memmove+0x2c>
80104b31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104b38:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104b39:	39 c6                	cmp    %eax,%esi
80104b3b:	75 fb                	jne    80104b38 <memmove+0x48>
}
80104b3d:	5e                   	pop    %esi
80104b3e:	89 d0                	mov    %edx,%eax
80104b40:	5f                   	pop    %edi
80104b41:	5d                   	pop    %ebp
80104b42:	c3                   	ret    
80104b43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b50 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104b50:	eb 9e                	jmp    80104af0 <memmove>
80104b52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b60 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	56                   	push   %esi
80104b64:	8b 75 10             	mov    0x10(%ebp),%esi
80104b67:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104b6a:	53                   	push   %ebx
80104b6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
80104b6e:	85 f6                	test   %esi,%esi
80104b70:	74 2e                	je     80104ba0 <strncmp+0x40>
80104b72:	01 d6                	add    %edx,%esi
80104b74:	eb 18                	jmp    80104b8e <strncmp+0x2e>
80104b76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b7d:	8d 76 00             	lea    0x0(%esi),%esi
80104b80:	38 d8                	cmp    %bl,%al
80104b82:	75 14                	jne    80104b98 <strncmp+0x38>
    n--, p++, q++;
80104b84:	83 c2 01             	add    $0x1,%edx
80104b87:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104b8a:	39 f2                	cmp    %esi,%edx
80104b8c:	74 12                	je     80104ba0 <strncmp+0x40>
80104b8e:	0f b6 01             	movzbl (%ecx),%eax
80104b91:	0f b6 1a             	movzbl (%edx),%ebx
80104b94:	84 c0                	test   %al,%al
80104b96:	75 e8                	jne    80104b80 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104b98:	29 d8                	sub    %ebx,%eax
}
80104b9a:	5b                   	pop    %ebx
80104b9b:	5e                   	pop    %esi
80104b9c:	5d                   	pop    %ebp
80104b9d:	c3                   	ret    
80104b9e:	66 90                	xchg   %ax,%ax
80104ba0:	5b                   	pop    %ebx
    return 0;
80104ba1:	31 c0                	xor    %eax,%eax
}
80104ba3:	5e                   	pop    %esi
80104ba4:	5d                   	pop    %ebp
80104ba5:	c3                   	ret    
80104ba6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bad:	8d 76 00             	lea    0x0(%esi),%esi

80104bb0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	57                   	push   %edi
80104bb4:	56                   	push   %esi
80104bb5:	8b 75 08             	mov    0x8(%ebp),%esi
80104bb8:	53                   	push   %ebx
80104bb9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104bbc:	89 f0                	mov    %esi,%eax
80104bbe:	eb 15                	jmp    80104bd5 <strncpy+0x25>
80104bc0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104bc4:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104bc7:	83 c0 01             	add    $0x1,%eax
80104bca:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104bce:	88 50 ff             	mov    %dl,-0x1(%eax)
80104bd1:	84 d2                	test   %dl,%dl
80104bd3:	74 09                	je     80104bde <strncpy+0x2e>
80104bd5:	89 cb                	mov    %ecx,%ebx
80104bd7:	83 e9 01             	sub    $0x1,%ecx
80104bda:	85 db                	test   %ebx,%ebx
80104bdc:	7f e2                	jg     80104bc0 <strncpy+0x10>
    ;
  while(n-- > 0)
80104bde:	89 c2                	mov    %eax,%edx
80104be0:	85 c9                	test   %ecx,%ecx
80104be2:	7e 17                	jle    80104bfb <strncpy+0x4b>
80104be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104be8:	83 c2 01             	add    $0x1,%edx
80104beb:	89 c1                	mov    %eax,%ecx
80104bed:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104bf1:	29 d1                	sub    %edx,%ecx
80104bf3:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104bf7:	85 c9                	test   %ecx,%ecx
80104bf9:	7f ed                	jg     80104be8 <strncpy+0x38>
  return os;
}
80104bfb:	5b                   	pop    %ebx
80104bfc:	89 f0                	mov    %esi,%eax
80104bfe:	5e                   	pop    %esi
80104bff:	5f                   	pop    %edi
80104c00:	5d                   	pop    %ebp
80104c01:	c3                   	ret    
80104c02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104c10 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	56                   	push   %esi
80104c14:	8b 55 10             	mov    0x10(%ebp),%edx
80104c17:	8b 75 08             	mov    0x8(%ebp),%esi
80104c1a:	53                   	push   %ebx
80104c1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104c1e:	85 d2                	test   %edx,%edx
80104c20:	7e 25                	jle    80104c47 <safestrcpy+0x37>
80104c22:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104c26:	89 f2                	mov    %esi,%edx
80104c28:	eb 16                	jmp    80104c40 <safestrcpy+0x30>
80104c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104c30:	0f b6 08             	movzbl (%eax),%ecx
80104c33:	83 c0 01             	add    $0x1,%eax
80104c36:	83 c2 01             	add    $0x1,%edx
80104c39:	88 4a ff             	mov    %cl,-0x1(%edx)
80104c3c:	84 c9                	test   %cl,%cl
80104c3e:	74 04                	je     80104c44 <safestrcpy+0x34>
80104c40:	39 d8                	cmp    %ebx,%eax
80104c42:	75 ec                	jne    80104c30 <safestrcpy+0x20>
    ;
  *s = 0;
80104c44:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104c47:	89 f0                	mov    %esi,%eax
80104c49:	5b                   	pop    %ebx
80104c4a:	5e                   	pop    %esi
80104c4b:	5d                   	pop    %ebp
80104c4c:	c3                   	ret    
80104c4d:	8d 76 00             	lea    0x0(%esi),%esi

80104c50 <strlen>:

int
strlen(const char *s)
{
80104c50:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104c51:	31 c0                	xor    %eax,%eax
{
80104c53:	89 e5                	mov    %esp,%ebp
80104c55:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104c58:	80 3a 00             	cmpb   $0x0,(%edx)
80104c5b:	74 0c                	je     80104c69 <strlen+0x19>
80104c5d:	8d 76 00             	lea    0x0(%esi),%esi
80104c60:	83 c0 01             	add    $0x1,%eax
80104c63:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104c67:	75 f7                	jne    80104c60 <strlen+0x10>
    ;
  return n;
}
80104c69:	5d                   	pop    %ebp
80104c6a:	c3                   	ret    

80104c6b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104c6b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104c6f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104c73:	55                   	push   %ebp
  pushl %ebx
80104c74:	53                   	push   %ebx
  pushl %esi
80104c75:	56                   	push   %esi
  pushl %edi
80104c76:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104c77:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104c79:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104c7b:	5f                   	pop    %edi
  popl %esi
80104c7c:	5e                   	pop    %esi
  popl %ebx
80104c7d:	5b                   	pop    %ebx
  popl %ebp
80104c7e:	5d                   	pop    %ebp
  ret
80104c7f:	c3                   	ret    

80104c80 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	53                   	push   %ebx
80104c84:	83 ec 04             	sub    $0x4,%esp
80104c87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104c8a:	e8 21 f0 ff ff       	call   80103cb0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c8f:	8b 00                	mov    (%eax),%eax
80104c91:	39 d8                	cmp    %ebx,%eax
80104c93:	76 1b                	jbe    80104cb0 <fetchint+0x30>
80104c95:	8d 53 04             	lea    0x4(%ebx),%edx
80104c98:	39 d0                	cmp    %edx,%eax
80104c9a:	72 14                	jb     80104cb0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104c9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c9f:	8b 13                	mov    (%ebx),%edx
80104ca1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ca3:	31 c0                	xor    %eax,%eax
}
80104ca5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ca8:	c9                   	leave  
80104ca9:	c3                   	ret    
80104caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104cb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cb5:	eb ee                	jmp    80104ca5 <fetchint+0x25>
80104cb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cbe:	66 90                	xchg   %ax,%ax

80104cc0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	53                   	push   %ebx
80104cc4:	83 ec 04             	sub    $0x4,%esp
80104cc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104cca:	e8 e1 ef ff ff       	call   80103cb0 <myproc>

  if(addr >= curproc->sz)
80104ccf:	39 18                	cmp    %ebx,(%eax)
80104cd1:	76 2d                	jbe    80104d00 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104cd3:	8b 55 0c             	mov    0xc(%ebp),%edx
80104cd6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104cd8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104cda:	39 d3                	cmp    %edx,%ebx
80104cdc:	73 22                	jae    80104d00 <fetchstr+0x40>
80104cde:	89 d8                	mov    %ebx,%eax
80104ce0:	eb 0d                	jmp    80104cef <fetchstr+0x2f>
80104ce2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ce8:	83 c0 01             	add    $0x1,%eax
80104ceb:	39 c2                	cmp    %eax,%edx
80104ced:	76 11                	jbe    80104d00 <fetchstr+0x40>
    if(*s == 0)
80104cef:	80 38 00             	cmpb   $0x0,(%eax)
80104cf2:	75 f4                	jne    80104ce8 <fetchstr+0x28>
      return s - *pp;
80104cf4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104cf6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cf9:	c9                   	leave  
80104cfa:	c3                   	ret    
80104cfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104cff:	90                   	nop
80104d00:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104d03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d08:	c9                   	leave  
80104d09:	c3                   	ret    
80104d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d10 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104d10:	55                   	push   %ebp
80104d11:	89 e5                	mov    %esp,%ebp
80104d13:	56                   	push   %esi
80104d14:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d15:	e8 96 ef ff ff       	call   80103cb0 <myproc>
80104d1a:	8b 55 08             	mov    0x8(%ebp),%edx
80104d1d:	8b 40 1c             	mov    0x1c(%eax),%eax
80104d20:	8b 40 44             	mov    0x44(%eax),%eax
80104d23:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104d26:	e8 85 ef ff ff       	call   80103cb0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d2b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d2e:	8b 00                	mov    (%eax),%eax
80104d30:	39 c6                	cmp    %eax,%esi
80104d32:	73 1c                	jae    80104d50 <argint+0x40>
80104d34:	8d 53 08             	lea    0x8(%ebx),%edx
80104d37:	39 d0                	cmp    %edx,%eax
80104d39:	72 15                	jb     80104d50 <argint+0x40>
  *ip = *(int*)(addr);
80104d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d3e:	8b 53 04             	mov    0x4(%ebx),%edx
80104d41:	89 10                	mov    %edx,(%eax)
  return 0;
80104d43:	31 c0                	xor    %eax,%eax
}
80104d45:	5b                   	pop    %ebx
80104d46:	5e                   	pop    %esi
80104d47:	5d                   	pop    %ebp
80104d48:	c3                   	ret    
80104d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104d50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d55:	eb ee                	jmp    80104d45 <argint+0x35>
80104d57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d5e:	66 90                	xchg   %ax,%ax

80104d60 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	57                   	push   %edi
80104d64:	56                   	push   %esi
80104d65:	53                   	push   %ebx
80104d66:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104d69:	e8 42 ef ff ff       	call   80103cb0 <myproc>
80104d6e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d70:	e8 3b ef ff ff       	call   80103cb0 <myproc>
80104d75:	8b 55 08             	mov    0x8(%ebp),%edx
80104d78:	8b 40 1c             	mov    0x1c(%eax),%eax
80104d7b:	8b 40 44             	mov    0x44(%eax),%eax
80104d7e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104d81:	e8 2a ef ff ff       	call   80103cb0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d86:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d89:	8b 00                	mov    (%eax),%eax
80104d8b:	39 c7                	cmp    %eax,%edi
80104d8d:	73 31                	jae    80104dc0 <argptr+0x60>
80104d8f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104d92:	39 c8                	cmp    %ecx,%eax
80104d94:	72 2a                	jb     80104dc0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104d96:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104d99:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104d9c:	85 d2                	test   %edx,%edx
80104d9e:	78 20                	js     80104dc0 <argptr+0x60>
80104da0:	8b 16                	mov    (%esi),%edx
80104da2:	39 c2                	cmp    %eax,%edx
80104da4:	76 1a                	jbe    80104dc0 <argptr+0x60>
80104da6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104da9:	01 c3                	add    %eax,%ebx
80104dab:	39 da                	cmp    %ebx,%edx
80104dad:	72 11                	jb     80104dc0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104daf:	8b 55 0c             	mov    0xc(%ebp),%edx
80104db2:	89 02                	mov    %eax,(%edx)
  return 0;
80104db4:	31 c0                	xor    %eax,%eax
}
80104db6:	83 c4 0c             	add    $0xc,%esp
80104db9:	5b                   	pop    %ebx
80104dba:	5e                   	pop    %esi
80104dbb:	5f                   	pop    %edi
80104dbc:	5d                   	pop    %ebp
80104dbd:	c3                   	ret    
80104dbe:	66 90                	xchg   %ax,%ax
    return -1;
80104dc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dc5:	eb ef                	jmp    80104db6 <argptr+0x56>
80104dc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dce:	66 90                	xchg   %ax,%ax

80104dd0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	56                   	push   %esi
80104dd4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104dd5:	e8 d6 ee ff ff       	call   80103cb0 <myproc>
80104dda:	8b 55 08             	mov    0x8(%ebp),%edx
80104ddd:	8b 40 1c             	mov    0x1c(%eax),%eax
80104de0:	8b 40 44             	mov    0x44(%eax),%eax
80104de3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104de6:	e8 c5 ee ff ff       	call   80103cb0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104deb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104dee:	8b 00                	mov    (%eax),%eax
80104df0:	39 c6                	cmp    %eax,%esi
80104df2:	73 44                	jae    80104e38 <argstr+0x68>
80104df4:	8d 53 08             	lea    0x8(%ebx),%edx
80104df7:	39 d0                	cmp    %edx,%eax
80104df9:	72 3d                	jb     80104e38 <argstr+0x68>
  *ip = *(int*)(addr);
80104dfb:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104dfe:	e8 ad ee ff ff       	call   80103cb0 <myproc>
  if(addr >= curproc->sz)
80104e03:	3b 18                	cmp    (%eax),%ebx
80104e05:	73 31                	jae    80104e38 <argstr+0x68>
  *pp = (char*)addr;
80104e07:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e0a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104e0c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104e0e:	39 d3                	cmp    %edx,%ebx
80104e10:	73 26                	jae    80104e38 <argstr+0x68>
80104e12:	89 d8                	mov    %ebx,%eax
80104e14:	eb 11                	jmp    80104e27 <argstr+0x57>
80104e16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e1d:	8d 76 00             	lea    0x0(%esi),%esi
80104e20:	83 c0 01             	add    $0x1,%eax
80104e23:	39 c2                	cmp    %eax,%edx
80104e25:	76 11                	jbe    80104e38 <argstr+0x68>
    if(*s == 0)
80104e27:	80 38 00             	cmpb   $0x0,(%eax)
80104e2a:	75 f4                	jne    80104e20 <argstr+0x50>
      return s - *pp;
80104e2c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104e2e:	5b                   	pop    %ebx
80104e2f:	5e                   	pop    %esi
80104e30:	5d                   	pop    %ebp
80104e31:	c3                   	ret    
80104e32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e38:	5b                   	pop    %ebx
    return -1;
80104e39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e3e:	5e                   	pop    %esi
80104e3f:	5d                   	pop    %ebp
80104e40:	c3                   	ret    
80104e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e4f:	90                   	nop

80104e50 <syscall>:
[SYS_getNumFreePages]   sys_getNumFreePages,
};

void
syscall(void)
{
80104e50:	55                   	push   %ebp
80104e51:	89 e5                	mov    %esp,%ebp
80104e53:	53                   	push   %ebx
80104e54:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104e57:	e8 54 ee ff ff       	call   80103cb0 <myproc>
80104e5c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104e5e:	8b 40 1c             	mov    0x1c(%eax),%eax
80104e61:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104e64:	8d 50 ff             	lea    -0x1(%eax),%edx
80104e67:	83 fa 16             	cmp    $0x16,%edx
80104e6a:	77 24                	ja     80104e90 <syscall+0x40>
80104e6c:	8b 14 85 20 7e 10 80 	mov    -0x7fef81e0(,%eax,4),%edx
80104e73:	85 d2                	test   %edx,%edx
80104e75:	74 19                	je     80104e90 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104e77:	ff d2                	call   *%edx
80104e79:	89 c2                	mov    %eax,%edx
80104e7b:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104e7e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104e81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e84:	c9                   	leave  
80104e85:	c3                   	ret    
80104e86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e8d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104e90:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104e91:	8d 43 70             	lea    0x70(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104e94:	50                   	push   %eax
80104e95:	ff 73 14             	push   0x14(%ebx)
80104e98:	68 f5 7d 10 80       	push   $0x80107df5
80104e9d:	e8 fe b7 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104ea2:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104ea5:	83 c4 10             	add    $0x10,%esp
80104ea8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104eaf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104eb2:	c9                   	leave  
80104eb3:	c3                   	ret    
80104eb4:	66 90                	xchg   %ax,%ax
80104eb6:	66 90                	xchg   %ax,%ax
80104eb8:	66 90                	xchg   %ax,%ax
80104eba:	66 90                	xchg   %ax,%ax
80104ebc:	66 90                	xchg   %ax,%ax
80104ebe:	66 90                	xchg   %ax,%ax

80104ec0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	57                   	push   %edi
80104ec4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104ec5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104ec8:	53                   	push   %ebx
80104ec9:	83 ec 34             	sub    $0x34,%esp
80104ecc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104ecf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104ed2:	57                   	push   %edi
80104ed3:	50                   	push   %eax
{
80104ed4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104ed7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104eda:	e8 e1 d1 ff ff       	call   801020c0 <nameiparent>
80104edf:	83 c4 10             	add    $0x10,%esp
80104ee2:	85 c0                	test   %eax,%eax
80104ee4:	0f 84 46 01 00 00    	je     80105030 <create+0x170>
    return 0;
  ilock(dp);
80104eea:	83 ec 0c             	sub    $0xc,%esp
80104eed:	89 c3                	mov    %eax,%ebx
80104eef:	50                   	push   %eax
80104ef0:	e8 8b c8 ff ff       	call   80101780 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104ef5:	83 c4 0c             	add    $0xc,%esp
80104ef8:	6a 00                	push   $0x0
80104efa:	57                   	push   %edi
80104efb:	53                   	push   %ebx
80104efc:	e8 df cd ff ff       	call   80101ce0 <dirlookup>
80104f01:	83 c4 10             	add    $0x10,%esp
80104f04:	89 c6                	mov    %eax,%esi
80104f06:	85 c0                	test   %eax,%eax
80104f08:	74 56                	je     80104f60 <create+0xa0>
    iunlockput(dp);
80104f0a:	83 ec 0c             	sub    $0xc,%esp
80104f0d:	53                   	push   %ebx
80104f0e:	e8 fd ca ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
80104f13:	89 34 24             	mov    %esi,(%esp)
80104f16:	e8 65 c8 ff ff       	call   80101780 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104f1b:	83 c4 10             	add    $0x10,%esp
80104f1e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104f23:	75 1b                	jne    80104f40 <create+0x80>
80104f25:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104f2a:	75 14                	jne    80104f40 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104f2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f2f:	89 f0                	mov    %esi,%eax
80104f31:	5b                   	pop    %ebx
80104f32:	5e                   	pop    %esi
80104f33:	5f                   	pop    %edi
80104f34:	5d                   	pop    %ebp
80104f35:	c3                   	ret    
80104f36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f3d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104f40:	83 ec 0c             	sub    $0xc,%esp
80104f43:	56                   	push   %esi
    return 0;
80104f44:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104f46:	e8 c5 ca ff ff       	call   80101a10 <iunlockput>
    return 0;
80104f4b:	83 c4 10             	add    $0x10,%esp
}
80104f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f51:	89 f0                	mov    %esi,%eax
80104f53:	5b                   	pop    %ebx
80104f54:	5e                   	pop    %esi
80104f55:	5f                   	pop    %edi
80104f56:	5d                   	pop    %ebp
80104f57:	c3                   	ret    
80104f58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f5f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104f60:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104f64:	83 ec 08             	sub    $0x8,%esp
80104f67:	50                   	push   %eax
80104f68:	ff 33                	push   (%ebx)
80104f6a:	e8 a1 c6 ff ff       	call   80101610 <ialloc>
80104f6f:	83 c4 10             	add    $0x10,%esp
80104f72:	89 c6                	mov    %eax,%esi
80104f74:	85 c0                	test   %eax,%eax
80104f76:	0f 84 cd 00 00 00    	je     80105049 <create+0x189>
  ilock(ip);
80104f7c:	83 ec 0c             	sub    $0xc,%esp
80104f7f:	50                   	push   %eax
80104f80:	e8 fb c7 ff ff       	call   80101780 <ilock>
  ip->major = major;
80104f85:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104f89:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104f8d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104f91:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104f95:	b8 01 00 00 00       	mov    $0x1,%eax
80104f9a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104f9e:	89 34 24             	mov    %esi,(%esp)
80104fa1:	e8 2a c7 ff ff       	call   801016d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104fa6:	83 c4 10             	add    $0x10,%esp
80104fa9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104fae:	74 30                	je     80104fe0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104fb0:	83 ec 04             	sub    $0x4,%esp
80104fb3:	ff 76 04             	push   0x4(%esi)
80104fb6:	57                   	push   %edi
80104fb7:	53                   	push   %ebx
80104fb8:	e8 23 d0 ff ff       	call   80101fe0 <dirlink>
80104fbd:	83 c4 10             	add    $0x10,%esp
80104fc0:	85 c0                	test   %eax,%eax
80104fc2:	78 78                	js     8010503c <create+0x17c>
  iunlockput(dp);
80104fc4:	83 ec 0c             	sub    $0xc,%esp
80104fc7:	53                   	push   %ebx
80104fc8:	e8 43 ca ff ff       	call   80101a10 <iunlockput>
  return ip;
80104fcd:	83 c4 10             	add    $0x10,%esp
}
80104fd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fd3:	89 f0                	mov    %esi,%eax
80104fd5:	5b                   	pop    %ebx
80104fd6:	5e                   	pop    %esi
80104fd7:	5f                   	pop    %edi
80104fd8:	5d                   	pop    %ebp
80104fd9:	c3                   	ret    
80104fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104fe0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104fe3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104fe8:	53                   	push   %ebx
80104fe9:	e8 e2 c6 ff ff       	call   801016d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104fee:	83 c4 0c             	add    $0xc,%esp
80104ff1:	ff 76 04             	push   0x4(%esi)
80104ff4:	68 9c 7e 10 80       	push   $0x80107e9c
80104ff9:	56                   	push   %esi
80104ffa:	e8 e1 cf ff ff       	call   80101fe0 <dirlink>
80104fff:	83 c4 10             	add    $0x10,%esp
80105002:	85 c0                	test   %eax,%eax
80105004:	78 18                	js     8010501e <create+0x15e>
80105006:	83 ec 04             	sub    $0x4,%esp
80105009:	ff 73 04             	push   0x4(%ebx)
8010500c:	68 9b 7e 10 80       	push   $0x80107e9b
80105011:	56                   	push   %esi
80105012:	e8 c9 cf ff ff       	call   80101fe0 <dirlink>
80105017:	83 c4 10             	add    $0x10,%esp
8010501a:	85 c0                	test   %eax,%eax
8010501c:	79 92                	jns    80104fb0 <create+0xf0>
      panic("create dots");
8010501e:	83 ec 0c             	sub    $0xc,%esp
80105021:	68 8f 7e 10 80       	push   $0x80107e8f
80105026:	e8 55 b3 ff ff       	call   80100380 <panic>
8010502b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010502f:	90                   	nop
}
80105030:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105033:	31 f6                	xor    %esi,%esi
}
80105035:	5b                   	pop    %ebx
80105036:	89 f0                	mov    %esi,%eax
80105038:	5e                   	pop    %esi
80105039:	5f                   	pop    %edi
8010503a:	5d                   	pop    %ebp
8010503b:	c3                   	ret    
    panic("create: dirlink");
8010503c:	83 ec 0c             	sub    $0xc,%esp
8010503f:	68 9e 7e 10 80       	push   $0x80107e9e
80105044:	e8 37 b3 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80105049:	83 ec 0c             	sub    $0xc,%esp
8010504c:	68 80 7e 10 80       	push   $0x80107e80
80105051:	e8 2a b3 ff ff       	call   80100380 <panic>
80105056:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010505d:	8d 76 00             	lea    0x0(%esi),%esi

80105060 <sys_dup>:
{
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	56                   	push   %esi
80105064:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105065:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105068:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010506b:	50                   	push   %eax
8010506c:	6a 00                	push   $0x0
8010506e:	e8 9d fc ff ff       	call   80104d10 <argint>
80105073:	83 c4 10             	add    $0x10,%esp
80105076:	85 c0                	test   %eax,%eax
80105078:	78 36                	js     801050b0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010507a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010507e:	77 30                	ja     801050b0 <sys_dup+0x50>
80105080:	e8 2b ec ff ff       	call   80103cb0 <myproc>
80105085:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105088:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
8010508c:	85 f6                	test   %esi,%esi
8010508e:	74 20                	je     801050b0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105090:	e8 1b ec ff ff       	call   80103cb0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105095:	31 db                	xor    %ebx,%ebx
80105097:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010509e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
801050a0:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
801050a4:	85 d2                	test   %edx,%edx
801050a6:	74 18                	je     801050c0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
801050a8:	83 c3 01             	add    $0x1,%ebx
801050ab:	83 fb 10             	cmp    $0x10,%ebx
801050ae:	75 f0                	jne    801050a0 <sys_dup+0x40>
}
801050b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801050b3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801050b8:	89 d8                	mov    %ebx,%eax
801050ba:	5b                   	pop    %ebx
801050bb:	5e                   	pop    %esi
801050bc:	5d                   	pop    %ebp
801050bd:	c3                   	ret    
801050be:	66 90                	xchg   %ax,%ax
  filedup(f);
801050c0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801050c3:	89 74 98 2c          	mov    %esi,0x2c(%eax,%ebx,4)
  filedup(f);
801050c7:	56                   	push   %esi
801050c8:	e8 d3 bd ff ff       	call   80100ea0 <filedup>
  return fd;
801050cd:	83 c4 10             	add    $0x10,%esp
}
801050d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050d3:	89 d8                	mov    %ebx,%eax
801050d5:	5b                   	pop    %ebx
801050d6:	5e                   	pop    %esi
801050d7:	5d                   	pop    %ebp
801050d8:	c3                   	ret    
801050d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801050e0 <sys_read>:
{
801050e0:	55                   	push   %ebp
801050e1:	89 e5                	mov    %esp,%ebp
801050e3:	56                   	push   %esi
801050e4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801050e5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801050e8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801050eb:	53                   	push   %ebx
801050ec:	6a 00                	push   $0x0
801050ee:	e8 1d fc ff ff       	call   80104d10 <argint>
801050f3:	83 c4 10             	add    $0x10,%esp
801050f6:	85 c0                	test   %eax,%eax
801050f8:	78 5e                	js     80105158 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050fa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050fe:	77 58                	ja     80105158 <sys_read+0x78>
80105100:	e8 ab eb ff ff       	call   80103cb0 <myproc>
80105105:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105108:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
8010510c:	85 f6                	test   %esi,%esi
8010510e:	74 48                	je     80105158 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105110:	83 ec 08             	sub    $0x8,%esp
80105113:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105116:	50                   	push   %eax
80105117:	6a 02                	push   $0x2
80105119:	e8 f2 fb ff ff       	call   80104d10 <argint>
8010511e:	83 c4 10             	add    $0x10,%esp
80105121:	85 c0                	test   %eax,%eax
80105123:	78 33                	js     80105158 <sys_read+0x78>
80105125:	83 ec 04             	sub    $0x4,%esp
80105128:	ff 75 f0             	push   -0x10(%ebp)
8010512b:	53                   	push   %ebx
8010512c:	6a 01                	push   $0x1
8010512e:	e8 2d fc ff ff       	call   80104d60 <argptr>
80105133:	83 c4 10             	add    $0x10,%esp
80105136:	85 c0                	test   %eax,%eax
80105138:	78 1e                	js     80105158 <sys_read+0x78>
  return fileread(f, p, n);
8010513a:	83 ec 04             	sub    $0x4,%esp
8010513d:	ff 75 f0             	push   -0x10(%ebp)
80105140:	ff 75 f4             	push   -0xc(%ebp)
80105143:	56                   	push   %esi
80105144:	e8 d7 be ff ff       	call   80101020 <fileread>
80105149:	83 c4 10             	add    $0x10,%esp
}
8010514c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010514f:	5b                   	pop    %ebx
80105150:	5e                   	pop    %esi
80105151:	5d                   	pop    %ebp
80105152:	c3                   	ret    
80105153:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105157:	90                   	nop
    return -1;
80105158:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010515d:	eb ed                	jmp    8010514c <sys_read+0x6c>
8010515f:	90                   	nop

80105160 <sys_write>:
{
80105160:	55                   	push   %ebp
80105161:	89 e5                	mov    %esp,%ebp
80105163:	56                   	push   %esi
80105164:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105165:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105168:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010516b:	53                   	push   %ebx
8010516c:	6a 00                	push   $0x0
8010516e:	e8 9d fb ff ff       	call   80104d10 <argint>
80105173:	83 c4 10             	add    $0x10,%esp
80105176:	85 c0                	test   %eax,%eax
80105178:	78 5e                	js     801051d8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010517a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010517e:	77 58                	ja     801051d8 <sys_write+0x78>
80105180:	e8 2b eb ff ff       	call   80103cb0 <myproc>
80105185:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105188:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
8010518c:	85 f6                	test   %esi,%esi
8010518e:	74 48                	je     801051d8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105190:	83 ec 08             	sub    $0x8,%esp
80105193:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105196:	50                   	push   %eax
80105197:	6a 02                	push   $0x2
80105199:	e8 72 fb ff ff       	call   80104d10 <argint>
8010519e:	83 c4 10             	add    $0x10,%esp
801051a1:	85 c0                	test   %eax,%eax
801051a3:	78 33                	js     801051d8 <sys_write+0x78>
801051a5:	83 ec 04             	sub    $0x4,%esp
801051a8:	ff 75 f0             	push   -0x10(%ebp)
801051ab:	53                   	push   %ebx
801051ac:	6a 01                	push   $0x1
801051ae:	e8 ad fb ff ff       	call   80104d60 <argptr>
801051b3:	83 c4 10             	add    $0x10,%esp
801051b6:	85 c0                	test   %eax,%eax
801051b8:	78 1e                	js     801051d8 <sys_write+0x78>
  return filewrite(f, p, n);
801051ba:	83 ec 04             	sub    $0x4,%esp
801051bd:	ff 75 f0             	push   -0x10(%ebp)
801051c0:	ff 75 f4             	push   -0xc(%ebp)
801051c3:	56                   	push   %esi
801051c4:	e8 e7 be ff ff       	call   801010b0 <filewrite>
801051c9:	83 c4 10             	add    $0x10,%esp
}
801051cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051cf:	5b                   	pop    %ebx
801051d0:	5e                   	pop    %esi
801051d1:	5d                   	pop    %ebp
801051d2:	c3                   	ret    
801051d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051d7:	90                   	nop
    return -1;
801051d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051dd:	eb ed                	jmp    801051cc <sys_write+0x6c>
801051df:	90                   	nop

801051e0 <sys_close>:
{
801051e0:	55                   	push   %ebp
801051e1:	89 e5                	mov    %esp,%ebp
801051e3:	56                   	push   %esi
801051e4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801051e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801051e8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801051eb:	50                   	push   %eax
801051ec:	6a 00                	push   $0x0
801051ee:	e8 1d fb ff ff       	call   80104d10 <argint>
801051f3:	83 c4 10             	add    $0x10,%esp
801051f6:	85 c0                	test   %eax,%eax
801051f8:	78 3e                	js     80105238 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801051fa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801051fe:	77 38                	ja     80105238 <sys_close+0x58>
80105200:	e8 ab ea ff ff       	call   80103cb0 <myproc>
80105205:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105208:	8d 5a 08             	lea    0x8(%edx),%ebx
8010520b:	8b 74 98 0c          	mov    0xc(%eax,%ebx,4),%esi
8010520f:	85 f6                	test   %esi,%esi
80105211:	74 25                	je     80105238 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105213:	e8 98 ea ff ff       	call   80103cb0 <myproc>
  fileclose(f);
80105218:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010521b:	c7 44 98 0c 00 00 00 	movl   $0x0,0xc(%eax,%ebx,4)
80105222:	00 
  fileclose(f);
80105223:	56                   	push   %esi
80105224:	e8 c7 bc ff ff       	call   80100ef0 <fileclose>
  return 0;
80105229:	83 c4 10             	add    $0x10,%esp
8010522c:	31 c0                	xor    %eax,%eax
}
8010522e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105231:	5b                   	pop    %ebx
80105232:	5e                   	pop    %esi
80105233:	5d                   	pop    %ebp
80105234:	c3                   	ret    
80105235:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105238:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010523d:	eb ef                	jmp    8010522e <sys_close+0x4e>
8010523f:	90                   	nop

80105240 <sys_fstat>:
{
80105240:	55                   	push   %ebp
80105241:	89 e5                	mov    %esp,%ebp
80105243:	56                   	push   %esi
80105244:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105245:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105248:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010524b:	53                   	push   %ebx
8010524c:	6a 00                	push   $0x0
8010524e:	e8 bd fa ff ff       	call   80104d10 <argint>
80105253:	83 c4 10             	add    $0x10,%esp
80105256:	85 c0                	test   %eax,%eax
80105258:	78 46                	js     801052a0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010525a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010525e:	77 40                	ja     801052a0 <sys_fstat+0x60>
80105260:	e8 4b ea ff ff       	call   80103cb0 <myproc>
80105265:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105268:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
8010526c:	85 f6                	test   %esi,%esi
8010526e:	74 30                	je     801052a0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105270:	83 ec 04             	sub    $0x4,%esp
80105273:	6a 14                	push   $0x14
80105275:	53                   	push   %ebx
80105276:	6a 01                	push   $0x1
80105278:	e8 e3 fa ff ff       	call   80104d60 <argptr>
8010527d:	83 c4 10             	add    $0x10,%esp
80105280:	85 c0                	test   %eax,%eax
80105282:	78 1c                	js     801052a0 <sys_fstat+0x60>
  return filestat(f, st);
80105284:	83 ec 08             	sub    $0x8,%esp
80105287:	ff 75 f4             	push   -0xc(%ebp)
8010528a:	56                   	push   %esi
8010528b:	e8 40 bd ff ff       	call   80100fd0 <filestat>
80105290:	83 c4 10             	add    $0x10,%esp
}
80105293:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105296:	5b                   	pop    %ebx
80105297:	5e                   	pop    %esi
80105298:	5d                   	pop    %ebp
80105299:	c3                   	ret    
8010529a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801052a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052a5:	eb ec                	jmp    80105293 <sys_fstat+0x53>
801052a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052ae:	66 90                	xchg   %ax,%ax

801052b0 <sys_link>:
{
801052b0:	55                   	push   %ebp
801052b1:	89 e5                	mov    %esp,%ebp
801052b3:	57                   	push   %edi
801052b4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801052b5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801052b8:	53                   	push   %ebx
801052b9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801052bc:	50                   	push   %eax
801052bd:	6a 00                	push   $0x0
801052bf:	e8 0c fb ff ff       	call   80104dd0 <argstr>
801052c4:	83 c4 10             	add    $0x10,%esp
801052c7:	85 c0                	test   %eax,%eax
801052c9:	0f 88 fb 00 00 00    	js     801053ca <sys_link+0x11a>
801052cf:	83 ec 08             	sub    $0x8,%esp
801052d2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801052d5:	50                   	push   %eax
801052d6:	6a 01                	push   $0x1
801052d8:	e8 f3 fa ff ff       	call   80104dd0 <argstr>
801052dd:	83 c4 10             	add    $0x10,%esp
801052e0:	85 c0                	test   %eax,%eax
801052e2:	0f 88 e2 00 00 00    	js     801053ca <sys_link+0x11a>
  begin_op();
801052e8:	e8 b3 dd ff ff       	call   801030a0 <begin_op>
  if((ip = namei(old)) == 0){
801052ed:	83 ec 0c             	sub    $0xc,%esp
801052f0:	ff 75 d4             	push   -0x2c(%ebp)
801052f3:	e8 a8 cd ff ff       	call   801020a0 <namei>
801052f8:	83 c4 10             	add    $0x10,%esp
801052fb:	89 c3                	mov    %eax,%ebx
801052fd:	85 c0                	test   %eax,%eax
801052ff:	0f 84 e4 00 00 00    	je     801053e9 <sys_link+0x139>
  ilock(ip);
80105305:	83 ec 0c             	sub    $0xc,%esp
80105308:	50                   	push   %eax
80105309:	e8 72 c4 ff ff       	call   80101780 <ilock>
  if(ip->type == T_DIR){
8010530e:	83 c4 10             	add    $0x10,%esp
80105311:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105316:	0f 84 b5 00 00 00    	je     801053d1 <sys_link+0x121>
  iupdate(ip);
8010531c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010531f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105324:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105327:	53                   	push   %ebx
80105328:	e8 a3 c3 ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
8010532d:	89 1c 24             	mov    %ebx,(%esp)
80105330:	e8 2b c5 ff ff       	call   80101860 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105335:	58                   	pop    %eax
80105336:	5a                   	pop    %edx
80105337:	57                   	push   %edi
80105338:	ff 75 d0             	push   -0x30(%ebp)
8010533b:	e8 80 cd ff ff       	call   801020c0 <nameiparent>
80105340:	83 c4 10             	add    $0x10,%esp
80105343:	89 c6                	mov    %eax,%esi
80105345:	85 c0                	test   %eax,%eax
80105347:	74 5b                	je     801053a4 <sys_link+0xf4>
  ilock(dp);
80105349:	83 ec 0c             	sub    $0xc,%esp
8010534c:	50                   	push   %eax
8010534d:	e8 2e c4 ff ff       	call   80101780 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105352:	8b 03                	mov    (%ebx),%eax
80105354:	83 c4 10             	add    $0x10,%esp
80105357:	39 06                	cmp    %eax,(%esi)
80105359:	75 3d                	jne    80105398 <sys_link+0xe8>
8010535b:	83 ec 04             	sub    $0x4,%esp
8010535e:	ff 73 04             	push   0x4(%ebx)
80105361:	57                   	push   %edi
80105362:	56                   	push   %esi
80105363:	e8 78 cc ff ff       	call   80101fe0 <dirlink>
80105368:	83 c4 10             	add    $0x10,%esp
8010536b:	85 c0                	test   %eax,%eax
8010536d:	78 29                	js     80105398 <sys_link+0xe8>
  iunlockput(dp);
8010536f:	83 ec 0c             	sub    $0xc,%esp
80105372:	56                   	push   %esi
80105373:	e8 98 c6 ff ff       	call   80101a10 <iunlockput>
  iput(ip);
80105378:	89 1c 24             	mov    %ebx,(%esp)
8010537b:	e8 30 c5 ff ff       	call   801018b0 <iput>
  end_op();
80105380:	e8 8b dd ff ff       	call   80103110 <end_op>
  return 0;
80105385:	83 c4 10             	add    $0x10,%esp
80105388:	31 c0                	xor    %eax,%eax
}
8010538a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010538d:	5b                   	pop    %ebx
8010538e:	5e                   	pop    %esi
8010538f:	5f                   	pop    %edi
80105390:	5d                   	pop    %ebp
80105391:	c3                   	ret    
80105392:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105398:	83 ec 0c             	sub    $0xc,%esp
8010539b:	56                   	push   %esi
8010539c:	e8 6f c6 ff ff       	call   80101a10 <iunlockput>
    goto bad;
801053a1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801053a4:	83 ec 0c             	sub    $0xc,%esp
801053a7:	53                   	push   %ebx
801053a8:	e8 d3 c3 ff ff       	call   80101780 <ilock>
  ip->nlink--;
801053ad:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801053b2:	89 1c 24             	mov    %ebx,(%esp)
801053b5:	e8 16 c3 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
801053ba:	89 1c 24             	mov    %ebx,(%esp)
801053bd:	e8 4e c6 ff ff       	call   80101a10 <iunlockput>
  end_op();
801053c2:	e8 49 dd ff ff       	call   80103110 <end_op>
  return -1;
801053c7:	83 c4 10             	add    $0x10,%esp
801053ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053cf:	eb b9                	jmp    8010538a <sys_link+0xda>
    iunlockput(ip);
801053d1:	83 ec 0c             	sub    $0xc,%esp
801053d4:	53                   	push   %ebx
801053d5:	e8 36 c6 ff ff       	call   80101a10 <iunlockput>
    end_op();
801053da:	e8 31 dd ff ff       	call   80103110 <end_op>
    return -1;
801053df:	83 c4 10             	add    $0x10,%esp
801053e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053e7:	eb a1                	jmp    8010538a <sys_link+0xda>
    end_op();
801053e9:	e8 22 dd ff ff       	call   80103110 <end_op>
    return -1;
801053ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053f3:	eb 95                	jmp    8010538a <sys_link+0xda>
801053f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105400 <sys_unlink>:
{
80105400:	55                   	push   %ebp
80105401:	89 e5                	mov    %esp,%ebp
80105403:	57                   	push   %edi
80105404:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105405:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105408:	53                   	push   %ebx
80105409:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010540c:	50                   	push   %eax
8010540d:	6a 00                	push   $0x0
8010540f:	e8 bc f9 ff ff       	call   80104dd0 <argstr>
80105414:	83 c4 10             	add    $0x10,%esp
80105417:	85 c0                	test   %eax,%eax
80105419:	0f 88 7a 01 00 00    	js     80105599 <sys_unlink+0x199>
  begin_op();
8010541f:	e8 7c dc ff ff       	call   801030a0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105424:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105427:	83 ec 08             	sub    $0x8,%esp
8010542a:	53                   	push   %ebx
8010542b:	ff 75 c0             	push   -0x40(%ebp)
8010542e:	e8 8d cc ff ff       	call   801020c0 <nameiparent>
80105433:	83 c4 10             	add    $0x10,%esp
80105436:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105439:	85 c0                	test   %eax,%eax
8010543b:	0f 84 62 01 00 00    	je     801055a3 <sys_unlink+0x1a3>
  ilock(dp);
80105441:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105444:	83 ec 0c             	sub    $0xc,%esp
80105447:	57                   	push   %edi
80105448:	e8 33 c3 ff ff       	call   80101780 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010544d:	58                   	pop    %eax
8010544e:	5a                   	pop    %edx
8010544f:	68 9c 7e 10 80       	push   $0x80107e9c
80105454:	53                   	push   %ebx
80105455:	e8 66 c8 ff ff       	call   80101cc0 <namecmp>
8010545a:	83 c4 10             	add    $0x10,%esp
8010545d:	85 c0                	test   %eax,%eax
8010545f:	0f 84 fb 00 00 00    	je     80105560 <sys_unlink+0x160>
80105465:	83 ec 08             	sub    $0x8,%esp
80105468:	68 9b 7e 10 80       	push   $0x80107e9b
8010546d:	53                   	push   %ebx
8010546e:	e8 4d c8 ff ff       	call   80101cc0 <namecmp>
80105473:	83 c4 10             	add    $0x10,%esp
80105476:	85 c0                	test   %eax,%eax
80105478:	0f 84 e2 00 00 00    	je     80105560 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010547e:	83 ec 04             	sub    $0x4,%esp
80105481:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105484:	50                   	push   %eax
80105485:	53                   	push   %ebx
80105486:	57                   	push   %edi
80105487:	e8 54 c8 ff ff       	call   80101ce0 <dirlookup>
8010548c:	83 c4 10             	add    $0x10,%esp
8010548f:	89 c3                	mov    %eax,%ebx
80105491:	85 c0                	test   %eax,%eax
80105493:	0f 84 c7 00 00 00    	je     80105560 <sys_unlink+0x160>
  ilock(ip);
80105499:	83 ec 0c             	sub    $0xc,%esp
8010549c:	50                   	push   %eax
8010549d:	e8 de c2 ff ff       	call   80101780 <ilock>
  if(ip->nlink < 1)
801054a2:	83 c4 10             	add    $0x10,%esp
801054a5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801054aa:	0f 8e 1c 01 00 00    	jle    801055cc <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801054b0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054b5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801054b8:	74 66                	je     80105520 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801054ba:	83 ec 04             	sub    $0x4,%esp
801054bd:	6a 10                	push   $0x10
801054bf:	6a 00                	push   $0x0
801054c1:	57                   	push   %edi
801054c2:	e8 89 f5 ff ff       	call   80104a50 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801054c7:	6a 10                	push   $0x10
801054c9:	ff 75 c4             	push   -0x3c(%ebp)
801054cc:	57                   	push   %edi
801054cd:	ff 75 b4             	push   -0x4c(%ebp)
801054d0:	e8 bb c6 ff ff       	call   80101b90 <writei>
801054d5:	83 c4 20             	add    $0x20,%esp
801054d8:	83 f8 10             	cmp    $0x10,%eax
801054db:	0f 85 de 00 00 00    	jne    801055bf <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
801054e1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054e6:	0f 84 94 00 00 00    	je     80105580 <sys_unlink+0x180>
  iunlockput(dp);
801054ec:	83 ec 0c             	sub    $0xc,%esp
801054ef:	ff 75 b4             	push   -0x4c(%ebp)
801054f2:	e8 19 c5 ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
801054f7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801054fc:	89 1c 24             	mov    %ebx,(%esp)
801054ff:	e8 cc c1 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
80105504:	89 1c 24             	mov    %ebx,(%esp)
80105507:	e8 04 c5 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010550c:	e8 ff db ff ff       	call   80103110 <end_op>
  return 0;
80105511:	83 c4 10             	add    $0x10,%esp
80105514:	31 c0                	xor    %eax,%eax
}
80105516:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105519:	5b                   	pop    %ebx
8010551a:	5e                   	pop    %esi
8010551b:	5f                   	pop    %edi
8010551c:	5d                   	pop    %ebp
8010551d:	c3                   	ret    
8010551e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105520:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105524:	76 94                	jbe    801054ba <sys_unlink+0xba>
80105526:	be 20 00 00 00       	mov    $0x20,%esi
8010552b:	eb 0b                	jmp    80105538 <sys_unlink+0x138>
8010552d:	8d 76 00             	lea    0x0(%esi),%esi
80105530:	83 c6 10             	add    $0x10,%esi
80105533:	3b 73 58             	cmp    0x58(%ebx),%esi
80105536:	73 82                	jae    801054ba <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105538:	6a 10                	push   $0x10
8010553a:	56                   	push   %esi
8010553b:	57                   	push   %edi
8010553c:	53                   	push   %ebx
8010553d:	e8 4e c5 ff ff       	call   80101a90 <readi>
80105542:	83 c4 10             	add    $0x10,%esp
80105545:	83 f8 10             	cmp    $0x10,%eax
80105548:	75 68                	jne    801055b2 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010554a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010554f:	74 df                	je     80105530 <sys_unlink+0x130>
    iunlockput(ip);
80105551:	83 ec 0c             	sub    $0xc,%esp
80105554:	53                   	push   %ebx
80105555:	e8 b6 c4 ff ff       	call   80101a10 <iunlockput>
    goto bad;
8010555a:	83 c4 10             	add    $0x10,%esp
8010555d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105560:	83 ec 0c             	sub    $0xc,%esp
80105563:	ff 75 b4             	push   -0x4c(%ebp)
80105566:	e8 a5 c4 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010556b:	e8 a0 db ff ff       	call   80103110 <end_op>
  return -1;
80105570:	83 c4 10             	add    $0x10,%esp
80105573:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105578:	eb 9c                	jmp    80105516 <sys_unlink+0x116>
8010557a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105580:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105583:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105586:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010558b:	50                   	push   %eax
8010558c:	e8 3f c1 ff ff       	call   801016d0 <iupdate>
80105591:	83 c4 10             	add    $0x10,%esp
80105594:	e9 53 ff ff ff       	jmp    801054ec <sys_unlink+0xec>
    return -1;
80105599:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010559e:	e9 73 ff ff ff       	jmp    80105516 <sys_unlink+0x116>
    end_op();
801055a3:	e8 68 db ff ff       	call   80103110 <end_op>
    return -1;
801055a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055ad:	e9 64 ff ff ff       	jmp    80105516 <sys_unlink+0x116>
      panic("isdirempty: readi");
801055b2:	83 ec 0c             	sub    $0xc,%esp
801055b5:	68 c0 7e 10 80       	push   $0x80107ec0
801055ba:	e8 c1 ad ff ff       	call   80100380 <panic>
    panic("unlink: writei");
801055bf:	83 ec 0c             	sub    $0xc,%esp
801055c2:	68 d2 7e 10 80       	push   $0x80107ed2
801055c7:	e8 b4 ad ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
801055cc:	83 ec 0c             	sub    $0xc,%esp
801055cf:	68 ae 7e 10 80       	push   $0x80107eae
801055d4:	e8 a7 ad ff ff       	call   80100380 <panic>
801055d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801055e0 <sys_open>:

int
sys_open(void)
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	57                   	push   %edi
801055e4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801055e5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801055e8:	53                   	push   %ebx
801055e9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801055ec:	50                   	push   %eax
801055ed:	6a 00                	push   $0x0
801055ef:	e8 dc f7 ff ff       	call   80104dd0 <argstr>
801055f4:	83 c4 10             	add    $0x10,%esp
801055f7:	85 c0                	test   %eax,%eax
801055f9:	0f 88 8e 00 00 00    	js     8010568d <sys_open+0xad>
801055ff:	83 ec 08             	sub    $0x8,%esp
80105602:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105605:	50                   	push   %eax
80105606:	6a 01                	push   $0x1
80105608:	e8 03 f7 ff ff       	call   80104d10 <argint>
8010560d:	83 c4 10             	add    $0x10,%esp
80105610:	85 c0                	test   %eax,%eax
80105612:	78 79                	js     8010568d <sys_open+0xad>
    return -1;

  begin_op();
80105614:	e8 87 da ff ff       	call   801030a0 <begin_op>

  if(omode & O_CREATE){
80105619:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010561d:	75 79                	jne    80105698 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010561f:	83 ec 0c             	sub    $0xc,%esp
80105622:	ff 75 e0             	push   -0x20(%ebp)
80105625:	e8 76 ca ff ff       	call   801020a0 <namei>
8010562a:	83 c4 10             	add    $0x10,%esp
8010562d:	89 c6                	mov    %eax,%esi
8010562f:	85 c0                	test   %eax,%eax
80105631:	0f 84 7e 00 00 00    	je     801056b5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105637:	83 ec 0c             	sub    $0xc,%esp
8010563a:	50                   	push   %eax
8010563b:	e8 40 c1 ff ff       	call   80101780 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105640:	83 c4 10             	add    $0x10,%esp
80105643:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105648:	0f 84 c2 00 00 00    	je     80105710 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010564e:	e8 dd b7 ff ff       	call   80100e30 <filealloc>
80105653:	89 c7                	mov    %eax,%edi
80105655:	85 c0                	test   %eax,%eax
80105657:	74 23                	je     8010567c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105659:	e8 52 e6 ff ff       	call   80103cb0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010565e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105660:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
80105664:	85 d2                	test   %edx,%edx
80105666:	74 60                	je     801056c8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105668:	83 c3 01             	add    $0x1,%ebx
8010566b:	83 fb 10             	cmp    $0x10,%ebx
8010566e:	75 f0                	jne    80105660 <sys_open+0x80>
    if(f)
      fileclose(f);
80105670:	83 ec 0c             	sub    $0xc,%esp
80105673:	57                   	push   %edi
80105674:	e8 77 b8 ff ff       	call   80100ef0 <fileclose>
80105679:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010567c:	83 ec 0c             	sub    $0xc,%esp
8010567f:	56                   	push   %esi
80105680:	e8 8b c3 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105685:	e8 86 da ff ff       	call   80103110 <end_op>
    return -1;
8010568a:	83 c4 10             	add    $0x10,%esp
8010568d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105692:	eb 6d                	jmp    80105701 <sys_open+0x121>
80105694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105698:	83 ec 0c             	sub    $0xc,%esp
8010569b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010569e:	31 c9                	xor    %ecx,%ecx
801056a0:	ba 02 00 00 00       	mov    $0x2,%edx
801056a5:	6a 00                	push   $0x0
801056a7:	e8 14 f8 ff ff       	call   80104ec0 <create>
    if(ip == 0){
801056ac:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801056af:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801056b1:	85 c0                	test   %eax,%eax
801056b3:	75 99                	jne    8010564e <sys_open+0x6e>
      end_op();
801056b5:	e8 56 da ff ff       	call   80103110 <end_op>
      return -1;
801056ba:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801056bf:	eb 40                	jmp    80105701 <sys_open+0x121>
801056c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801056c8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801056cb:	89 7c 98 2c          	mov    %edi,0x2c(%eax,%ebx,4)
  iunlock(ip);
801056cf:	56                   	push   %esi
801056d0:	e8 8b c1 ff ff       	call   80101860 <iunlock>
  end_op();
801056d5:	e8 36 da ff ff       	call   80103110 <end_op>

  f->type = FD_INODE;
801056da:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801056e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801056e3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801056e6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801056e9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801056eb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801056f2:	f7 d0                	not    %eax
801056f4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801056f7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801056fa:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801056fd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105701:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105704:	89 d8                	mov    %ebx,%eax
80105706:	5b                   	pop    %ebx
80105707:	5e                   	pop    %esi
80105708:	5f                   	pop    %edi
80105709:	5d                   	pop    %ebp
8010570a:	c3                   	ret    
8010570b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010570f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105710:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105713:	85 c9                	test   %ecx,%ecx
80105715:	0f 84 33 ff ff ff    	je     8010564e <sys_open+0x6e>
8010571b:	e9 5c ff ff ff       	jmp    8010567c <sys_open+0x9c>

80105720 <sys_mkdir>:

int
sys_mkdir(void)
{
80105720:	55                   	push   %ebp
80105721:	89 e5                	mov    %esp,%ebp
80105723:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105726:	e8 75 d9 ff ff       	call   801030a0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010572b:	83 ec 08             	sub    $0x8,%esp
8010572e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105731:	50                   	push   %eax
80105732:	6a 00                	push   $0x0
80105734:	e8 97 f6 ff ff       	call   80104dd0 <argstr>
80105739:	83 c4 10             	add    $0x10,%esp
8010573c:	85 c0                	test   %eax,%eax
8010573e:	78 30                	js     80105770 <sys_mkdir+0x50>
80105740:	83 ec 0c             	sub    $0xc,%esp
80105743:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105746:	31 c9                	xor    %ecx,%ecx
80105748:	ba 01 00 00 00       	mov    $0x1,%edx
8010574d:	6a 00                	push   $0x0
8010574f:	e8 6c f7 ff ff       	call   80104ec0 <create>
80105754:	83 c4 10             	add    $0x10,%esp
80105757:	85 c0                	test   %eax,%eax
80105759:	74 15                	je     80105770 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010575b:	83 ec 0c             	sub    $0xc,%esp
8010575e:	50                   	push   %eax
8010575f:	e8 ac c2 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105764:	e8 a7 d9 ff ff       	call   80103110 <end_op>
  return 0;
80105769:	83 c4 10             	add    $0x10,%esp
8010576c:	31 c0                	xor    %eax,%eax
}
8010576e:	c9                   	leave  
8010576f:	c3                   	ret    
    end_op();
80105770:	e8 9b d9 ff ff       	call   80103110 <end_op>
    return -1;
80105775:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010577a:	c9                   	leave  
8010577b:	c3                   	ret    
8010577c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105780 <sys_mknod>:

int
sys_mknod(void)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105786:	e8 15 d9 ff ff       	call   801030a0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010578b:	83 ec 08             	sub    $0x8,%esp
8010578e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105791:	50                   	push   %eax
80105792:	6a 00                	push   $0x0
80105794:	e8 37 f6 ff ff       	call   80104dd0 <argstr>
80105799:	83 c4 10             	add    $0x10,%esp
8010579c:	85 c0                	test   %eax,%eax
8010579e:	78 60                	js     80105800 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801057a0:	83 ec 08             	sub    $0x8,%esp
801057a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057a6:	50                   	push   %eax
801057a7:	6a 01                	push   $0x1
801057a9:	e8 62 f5 ff ff       	call   80104d10 <argint>
  if((argstr(0, &path)) < 0 ||
801057ae:	83 c4 10             	add    $0x10,%esp
801057b1:	85 c0                	test   %eax,%eax
801057b3:	78 4b                	js     80105800 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801057b5:	83 ec 08             	sub    $0x8,%esp
801057b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057bb:	50                   	push   %eax
801057bc:	6a 02                	push   $0x2
801057be:	e8 4d f5 ff ff       	call   80104d10 <argint>
     argint(1, &major) < 0 ||
801057c3:	83 c4 10             	add    $0x10,%esp
801057c6:	85 c0                	test   %eax,%eax
801057c8:	78 36                	js     80105800 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801057ca:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801057ce:	83 ec 0c             	sub    $0xc,%esp
801057d1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801057d5:	ba 03 00 00 00       	mov    $0x3,%edx
801057da:	50                   	push   %eax
801057db:	8b 45 ec             	mov    -0x14(%ebp),%eax
801057de:	e8 dd f6 ff ff       	call   80104ec0 <create>
     argint(2, &minor) < 0 ||
801057e3:	83 c4 10             	add    $0x10,%esp
801057e6:	85 c0                	test   %eax,%eax
801057e8:	74 16                	je     80105800 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801057ea:	83 ec 0c             	sub    $0xc,%esp
801057ed:	50                   	push   %eax
801057ee:	e8 1d c2 ff ff       	call   80101a10 <iunlockput>
  end_op();
801057f3:	e8 18 d9 ff ff       	call   80103110 <end_op>
  return 0;
801057f8:	83 c4 10             	add    $0x10,%esp
801057fb:	31 c0                	xor    %eax,%eax
}
801057fd:	c9                   	leave  
801057fe:	c3                   	ret    
801057ff:	90                   	nop
    end_op();
80105800:	e8 0b d9 ff ff       	call   80103110 <end_op>
    return -1;
80105805:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010580a:	c9                   	leave  
8010580b:	c3                   	ret    
8010580c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105810 <sys_chdir>:

int
sys_chdir(void)
{
80105810:	55                   	push   %ebp
80105811:	89 e5                	mov    %esp,%ebp
80105813:	56                   	push   %esi
80105814:	53                   	push   %ebx
80105815:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105818:	e8 93 e4 ff ff       	call   80103cb0 <myproc>
8010581d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010581f:	e8 7c d8 ff ff       	call   801030a0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105824:	83 ec 08             	sub    $0x8,%esp
80105827:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010582a:	50                   	push   %eax
8010582b:	6a 00                	push   $0x0
8010582d:	e8 9e f5 ff ff       	call   80104dd0 <argstr>
80105832:	83 c4 10             	add    $0x10,%esp
80105835:	85 c0                	test   %eax,%eax
80105837:	78 77                	js     801058b0 <sys_chdir+0xa0>
80105839:	83 ec 0c             	sub    $0xc,%esp
8010583c:	ff 75 f4             	push   -0xc(%ebp)
8010583f:	e8 5c c8 ff ff       	call   801020a0 <namei>
80105844:	83 c4 10             	add    $0x10,%esp
80105847:	89 c3                	mov    %eax,%ebx
80105849:	85 c0                	test   %eax,%eax
8010584b:	74 63                	je     801058b0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010584d:	83 ec 0c             	sub    $0xc,%esp
80105850:	50                   	push   %eax
80105851:	e8 2a bf ff ff       	call   80101780 <ilock>
  if(ip->type != T_DIR){
80105856:	83 c4 10             	add    $0x10,%esp
80105859:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010585e:	75 30                	jne    80105890 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105860:	83 ec 0c             	sub    $0xc,%esp
80105863:	53                   	push   %ebx
80105864:	e8 f7 bf ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
80105869:	58                   	pop    %eax
8010586a:	ff 76 6c             	push   0x6c(%esi)
8010586d:	e8 3e c0 ff ff       	call   801018b0 <iput>
  end_op();
80105872:	e8 99 d8 ff ff       	call   80103110 <end_op>
  curproc->cwd = ip;
80105877:	89 5e 6c             	mov    %ebx,0x6c(%esi)
  return 0;
8010587a:	83 c4 10             	add    $0x10,%esp
8010587d:	31 c0                	xor    %eax,%eax
}
8010587f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105882:	5b                   	pop    %ebx
80105883:	5e                   	pop    %esi
80105884:	5d                   	pop    %ebp
80105885:	c3                   	ret    
80105886:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010588d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105890:	83 ec 0c             	sub    $0xc,%esp
80105893:	53                   	push   %ebx
80105894:	e8 77 c1 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105899:	e8 72 d8 ff ff       	call   80103110 <end_op>
    return -1;
8010589e:	83 c4 10             	add    $0x10,%esp
801058a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058a6:	eb d7                	jmp    8010587f <sys_chdir+0x6f>
801058a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058af:	90                   	nop
    end_op();
801058b0:	e8 5b d8 ff ff       	call   80103110 <end_op>
    return -1;
801058b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058ba:	eb c3                	jmp    8010587f <sys_chdir+0x6f>
801058bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058c0 <sys_exec>:

int
sys_exec(void)
{
801058c0:	55                   	push   %ebp
801058c1:	89 e5                	mov    %esp,%ebp
801058c3:	57                   	push   %edi
801058c4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801058c5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801058cb:	53                   	push   %ebx
801058cc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801058d2:	50                   	push   %eax
801058d3:	6a 00                	push   $0x0
801058d5:	e8 f6 f4 ff ff       	call   80104dd0 <argstr>
801058da:	83 c4 10             	add    $0x10,%esp
801058dd:	85 c0                	test   %eax,%eax
801058df:	0f 88 87 00 00 00    	js     8010596c <sys_exec+0xac>
801058e5:	83 ec 08             	sub    $0x8,%esp
801058e8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801058ee:	50                   	push   %eax
801058ef:	6a 01                	push   $0x1
801058f1:	e8 1a f4 ff ff       	call   80104d10 <argint>
801058f6:	83 c4 10             	add    $0x10,%esp
801058f9:	85 c0                	test   %eax,%eax
801058fb:	78 6f                	js     8010596c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801058fd:	83 ec 04             	sub    $0x4,%esp
80105900:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105906:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105908:	68 80 00 00 00       	push   $0x80
8010590d:	6a 00                	push   $0x0
8010590f:	56                   	push   %esi
80105910:	e8 3b f1 ff ff       	call   80104a50 <memset>
80105915:	83 c4 10             	add    $0x10,%esp
80105918:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010591f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105920:	83 ec 08             	sub    $0x8,%esp
80105923:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105929:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105930:	50                   	push   %eax
80105931:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105937:	01 f8                	add    %edi,%eax
80105939:	50                   	push   %eax
8010593a:	e8 41 f3 ff ff       	call   80104c80 <fetchint>
8010593f:	83 c4 10             	add    $0x10,%esp
80105942:	85 c0                	test   %eax,%eax
80105944:	78 26                	js     8010596c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105946:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010594c:	85 c0                	test   %eax,%eax
8010594e:	74 30                	je     80105980 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105950:	83 ec 08             	sub    $0x8,%esp
80105953:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105956:	52                   	push   %edx
80105957:	50                   	push   %eax
80105958:	e8 63 f3 ff ff       	call   80104cc0 <fetchstr>
8010595d:	83 c4 10             	add    $0x10,%esp
80105960:	85 c0                	test   %eax,%eax
80105962:	78 08                	js     8010596c <sys_exec+0xac>
  for(i=0;; i++){
80105964:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105967:	83 fb 20             	cmp    $0x20,%ebx
8010596a:	75 b4                	jne    80105920 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010596c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010596f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105974:	5b                   	pop    %ebx
80105975:	5e                   	pop    %esi
80105976:	5f                   	pop    %edi
80105977:	5d                   	pop    %ebp
80105978:	c3                   	ret    
80105979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105980:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105987:	00 00 00 00 
  return exec(path, argv);
8010598b:	83 ec 08             	sub    $0x8,%esp
8010598e:	56                   	push   %esi
8010598f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105995:	e8 16 b1 ff ff       	call   80100ab0 <exec>
8010599a:	83 c4 10             	add    $0x10,%esp
}
8010599d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059a0:	5b                   	pop    %ebx
801059a1:	5e                   	pop    %esi
801059a2:	5f                   	pop    %edi
801059a3:	5d                   	pop    %ebp
801059a4:	c3                   	ret    
801059a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059b0 <sys_pipe>:

int
sys_pipe(void)
{
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	57                   	push   %edi
801059b4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801059b5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801059b8:	53                   	push   %ebx
801059b9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801059bc:	6a 08                	push   $0x8
801059be:	50                   	push   %eax
801059bf:	6a 00                	push   $0x0
801059c1:	e8 9a f3 ff ff       	call   80104d60 <argptr>
801059c6:	83 c4 10             	add    $0x10,%esp
801059c9:	85 c0                	test   %eax,%eax
801059cb:	78 4a                	js     80105a17 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801059cd:	83 ec 08             	sub    $0x8,%esp
801059d0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801059d3:	50                   	push   %eax
801059d4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801059d7:	50                   	push   %eax
801059d8:	e8 93 dd ff ff       	call   80103770 <pipealloc>
801059dd:	83 c4 10             	add    $0x10,%esp
801059e0:	85 c0                	test   %eax,%eax
801059e2:	78 33                	js     80105a17 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801059e4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801059e7:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801059e9:	e8 c2 e2 ff ff       	call   80103cb0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801059ee:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
801059f0:	8b 74 98 2c          	mov    0x2c(%eax,%ebx,4),%esi
801059f4:	85 f6                	test   %esi,%esi
801059f6:	74 28                	je     80105a20 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
801059f8:	83 c3 01             	add    $0x1,%ebx
801059fb:	83 fb 10             	cmp    $0x10,%ebx
801059fe:	75 f0                	jne    801059f0 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105a00:	83 ec 0c             	sub    $0xc,%esp
80105a03:	ff 75 e0             	push   -0x20(%ebp)
80105a06:	e8 e5 b4 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
80105a0b:	58                   	pop    %eax
80105a0c:	ff 75 e4             	push   -0x1c(%ebp)
80105a0f:	e8 dc b4 ff ff       	call   80100ef0 <fileclose>
    return -1;
80105a14:	83 c4 10             	add    $0x10,%esp
80105a17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a1c:	eb 53                	jmp    80105a71 <sys_pipe+0xc1>
80105a1e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105a20:	8d 73 08             	lea    0x8(%ebx),%esi
80105a23:	89 7c b0 0c          	mov    %edi,0xc(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105a27:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105a2a:	e8 81 e2 ff ff       	call   80103cb0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105a2f:	31 d2                	xor    %edx,%edx
80105a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105a38:	8b 4c 90 2c          	mov    0x2c(%eax,%edx,4),%ecx
80105a3c:	85 c9                	test   %ecx,%ecx
80105a3e:	74 20                	je     80105a60 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105a40:	83 c2 01             	add    $0x1,%edx
80105a43:	83 fa 10             	cmp    $0x10,%edx
80105a46:	75 f0                	jne    80105a38 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105a48:	e8 63 e2 ff ff       	call   80103cb0 <myproc>
80105a4d:	c7 44 b0 0c 00 00 00 	movl   $0x0,0xc(%eax,%esi,4)
80105a54:	00 
80105a55:	eb a9                	jmp    80105a00 <sys_pipe+0x50>
80105a57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a5e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105a60:	89 7c 90 2c          	mov    %edi,0x2c(%eax,%edx,4)
  }
  fd[0] = fd0;
80105a64:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a67:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105a69:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a6c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105a6f:	31 c0                	xor    %eax,%eax
}
80105a71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a74:	5b                   	pop    %ebx
80105a75:	5e                   	pop    %esi
80105a76:	5f                   	pop    %edi
80105a77:	5d                   	pop    %ebp
80105a78:	c3                   	ret    
80105a79:	66 90                	xchg   %ax,%ax
80105a7b:	66 90                	xchg   %ax,%ax
80105a7d:	66 90                	xchg   %ax,%ax
80105a7f:	90                   	nop

80105a80 <sys_getNumFreePages>:


int
sys_getNumFreePages(void)
{
  return num_of_FreePages();  
80105a80:	e9 7b cf ff ff       	jmp    80102a00 <num_of_FreePages>
80105a85:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a90 <sys_getrss>:
}

int 
sys_getrss()
{
80105a90:	55                   	push   %ebp
80105a91:	89 e5                	mov    %esp,%ebp
80105a93:	83 ec 08             	sub    $0x8,%esp
  print_rss();
80105a96:	e8 d5 e4 ff ff       	call   80103f70 <print_rss>
  return 0;
}
80105a9b:	31 c0                	xor    %eax,%eax
80105a9d:	c9                   	leave  
80105a9e:	c3                   	ret    
80105a9f:	90                   	nop

80105aa0 <sys_fork>:

int
sys_fork(void)
{
  return fork();
80105aa0:	e9 ab e3 ff ff       	jmp    80103e50 <fork>
80105aa5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ab0 <sys_exit>:
}

int
sys_exit(void)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	83 ec 08             	sub    $0x8,%esp
  exit();
80105ab6:	e8 85 e6 ff ff       	call   80104140 <exit>
  return 0;  // not reached
}
80105abb:	31 c0                	xor    %eax,%eax
80105abd:	c9                   	leave  
80105abe:	c3                   	ret    
80105abf:	90                   	nop

80105ac0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105ac0:	e9 ab e7 ff ff       	jmp    80104270 <wait>
80105ac5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ad0 <sys_kill>:
}

int
sys_kill(void)
{
80105ad0:	55                   	push   %ebp
80105ad1:	89 e5                	mov    %esp,%ebp
80105ad3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105ad6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ad9:	50                   	push   %eax
80105ada:	6a 00                	push   $0x0
80105adc:	e8 2f f2 ff ff       	call   80104d10 <argint>
80105ae1:	83 c4 10             	add    $0x10,%esp
80105ae4:	85 c0                	test   %eax,%eax
80105ae6:	78 18                	js     80105b00 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105ae8:	83 ec 0c             	sub    $0xc,%esp
80105aeb:	ff 75 f4             	push   -0xc(%ebp)
80105aee:	e8 1d ea ff ff       	call   80104510 <kill>
80105af3:	83 c4 10             	add    $0x10,%esp
}
80105af6:	c9                   	leave  
80105af7:	c3                   	ret    
80105af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105aff:	90                   	nop
80105b00:	c9                   	leave  
    return -1;
80105b01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b06:	c3                   	ret    
80105b07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b0e:	66 90                	xchg   %ax,%ax

80105b10 <sys_getpid>:

int
sys_getpid(void)
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105b16:	e8 95 e1 ff ff       	call   80103cb0 <myproc>
80105b1b:	8b 40 14             	mov    0x14(%eax),%eax
}
80105b1e:	c9                   	leave  
80105b1f:	c3                   	ret    

80105b20 <sys_sbrk>:

int
sys_sbrk(void)
{
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
80105b23:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105b24:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105b27:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105b2a:	50                   	push   %eax
80105b2b:	6a 00                	push   $0x0
80105b2d:	e8 de f1 ff ff       	call   80104d10 <argint>
80105b32:	83 c4 10             	add    $0x10,%esp
80105b35:	85 c0                	test   %eax,%eax
80105b37:	78 27                	js     80105b60 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105b39:	e8 72 e1 ff ff       	call   80103cb0 <myproc>
  if(growproc(n) < 0)
80105b3e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105b41:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105b43:	ff 75 f4             	push   -0xc(%ebp)
80105b46:	e8 85 e2 ff ff       	call   80103dd0 <growproc>
80105b4b:	83 c4 10             	add    $0x10,%esp
80105b4e:	85 c0                	test   %eax,%eax
80105b50:	78 0e                	js     80105b60 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105b52:	89 d8                	mov    %ebx,%eax
80105b54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b57:	c9                   	leave  
80105b58:	c3                   	ret    
80105b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105b60:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b65:	eb eb                	jmp    80105b52 <sys_sbrk+0x32>
80105b67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b6e:	66 90                	xchg   %ax,%ax

80105b70 <sys_sleep>:

int
sys_sleep(void)
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105b74:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105b77:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105b7a:	50                   	push   %eax
80105b7b:	6a 00                	push   $0x0
80105b7d:	e8 8e f1 ff ff       	call   80104d10 <argint>
80105b82:	83 c4 10             	add    $0x10,%esp
80105b85:	85 c0                	test   %eax,%eax
80105b87:	0f 88 8a 00 00 00    	js     80105c17 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105b8d:	83 ec 0c             	sub    $0xc,%esp
80105b90:	68 a0 5d 11 80       	push   $0x80115da0
80105b95:	e8 f6 ed ff ff       	call   80104990 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105b9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105b9d:	8b 1d 80 5d 11 80    	mov    0x80115d80,%ebx
  while(ticks - ticks0 < n){
80105ba3:	83 c4 10             	add    $0x10,%esp
80105ba6:	85 d2                	test   %edx,%edx
80105ba8:	75 27                	jne    80105bd1 <sys_sleep+0x61>
80105baa:	eb 54                	jmp    80105c00 <sys_sleep+0x90>
80105bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105bb0:	83 ec 08             	sub    $0x8,%esp
80105bb3:	68 a0 5d 11 80       	push   $0x80115da0
80105bb8:	68 80 5d 11 80       	push   $0x80115d80
80105bbd:	e8 2e e8 ff ff       	call   801043f0 <sleep>
  while(ticks - ticks0 < n){
80105bc2:	a1 80 5d 11 80       	mov    0x80115d80,%eax
80105bc7:	83 c4 10             	add    $0x10,%esp
80105bca:	29 d8                	sub    %ebx,%eax
80105bcc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105bcf:	73 2f                	jae    80105c00 <sys_sleep+0x90>
    if(myproc()->killed){
80105bd1:	e8 da e0 ff ff       	call   80103cb0 <myproc>
80105bd6:	8b 40 28             	mov    0x28(%eax),%eax
80105bd9:	85 c0                	test   %eax,%eax
80105bdb:	74 d3                	je     80105bb0 <sys_sleep+0x40>
      release(&tickslock);
80105bdd:	83 ec 0c             	sub    $0xc,%esp
80105be0:	68 a0 5d 11 80       	push   $0x80115da0
80105be5:	e8 46 ed ff ff       	call   80104930 <release>
  }
  release(&tickslock);
  return 0;
}
80105bea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105bed:	83 c4 10             	add    $0x10,%esp
80105bf0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bf5:	c9                   	leave  
80105bf6:	c3                   	ret    
80105bf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bfe:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105c00:	83 ec 0c             	sub    $0xc,%esp
80105c03:	68 a0 5d 11 80       	push   $0x80115da0
80105c08:	e8 23 ed ff ff       	call   80104930 <release>
  return 0;
80105c0d:	83 c4 10             	add    $0x10,%esp
80105c10:	31 c0                	xor    %eax,%eax
}
80105c12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c15:	c9                   	leave  
80105c16:	c3                   	ret    
    return -1;
80105c17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c1c:	eb f4                	jmp    80105c12 <sys_sleep+0xa2>
80105c1e:	66 90                	xchg   %ax,%ax

80105c20 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105c20:	55                   	push   %ebp
80105c21:	89 e5                	mov    %esp,%ebp
80105c23:	53                   	push   %ebx
80105c24:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105c27:	68 a0 5d 11 80       	push   $0x80115da0
80105c2c:	e8 5f ed ff ff       	call   80104990 <acquire>
  xticks = ticks;
80105c31:	8b 1d 80 5d 11 80    	mov    0x80115d80,%ebx
  release(&tickslock);
80105c37:	c7 04 24 a0 5d 11 80 	movl   $0x80115da0,(%esp)
80105c3e:	e8 ed ec ff ff       	call   80104930 <release>
  return xticks;
}
80105c43:	89 d8                	mov    %ebx,%eax
80105c45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c48:	c9                   	leave  
80105c49:	c3                   	ret    

80105c4a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105c4a:	1e                   	push   %ds
  pushl %es
80105c4b:	06                   	push   %es
  pushl %fs
80105c4c:	0f a0                	push   %fs
  pushl %gs
80105c4e:	0f a8                	push   %gs
  pushal
80105c50:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105c51:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105c55:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105c57:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105c59:	54                   	push   %esp
  call trap
80105c5a:	e8 c1 00 00 00       	call   80105d20 <trap>
  addl $4, %esp
80105c5f:	83 c4 04             	add    $0x4,%esp

80105c62 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105c62:	61                   	popa   
  popl %gs
80105c63:	0f a9                	pop    %gs
  popl %fs
80105c65:	0f a1                	pop    %fs
  popl %es
80105c67:	07                   	pop    %es
  popl %ds
80105c68:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105c69:	83 c4 08             	add    $0x8,%esp
  iret
80105c6c:	cf                   	iret   
80105c6d:	66 90                	xchg   %ax,%ax
80105c6f:	90                   	nop

80105c70 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105c70:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105c71:	31 c0                	xor    %eax,%eax
{
80105c73:	89 e5                	mov    %esp,%ebp
80105c75:	83 ec 08             	sub    $0x8,%esp
80105c78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c7f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105c80:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105c87:	c7 04 c5 e2 5d 11 80 	movl   $0x8e000008,-0x7feea21e(,%eax,8)
80105c8e:	08 00 00 8e 
80105c92:	66 89 14 c5 e0 5d 11 	mov    %dx,-0x7feea220(,%eax,8)
80105c99:	80 
80105c9a:	c1 ea 10             	shr    $0x10,%edx
80105c9d:	66 89 14 c5 e6 5d 11 	mov    %dx,-0x7feea21a(,%eax,8)
80105ca4:	80 
  for(i = 0; i < 256; i++)
80105ca5:	83 c0 01             	add    $0x1,%eax
80105ca8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105cad:	75 d1                	jne    80105c80 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105caf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105cb2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105cb7:	c7 05 e2 5f 11 80 08 	movl   $0xef000008,0x80115fe2
80105cbe:	00 00 ef 
  initlock(&tickslock, "time");
80105cc1:	68 e1 7e 10 80       	push   $0x80107ee1
80105cc6:	68 a0 5d 11 80       	push   $0x80115da0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105ccb:	66 a3 e0 5f 11 80    	mov    %ax,0x80115fe0
80105cd1:	c1 e8 10             	shr    $0x10,%eax
80105cd4:	66 a3 e6 5f 11 80    	mov    %ax,0x80115fe6
  initlock(&tickslock, "time");
80105cda:	e8 e1 ea ff ff       	call   801047c0 <initlock>
}
80105cdf:	83 c4 10             	add    $0x10,%esp
80105ce2:	c9                   	leave  
80105ce3:	c3                   	ret    
80105ce4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cef:	90                   	nop

80105cf0 <idtinit>:

void
idtinit(void)
{
80105cf0:	55                   	push   %ebp
  pd[0] = size-1;
80105cf1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105cf6:	89 e5                	mov    %esp,%ebp
80105cf8:	83 ec 10             	sub    $0x10,%esp
80105cfb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105cff:	b8 e0 5d 11 80       	mov    $0x80115de0,%eax
80105d04:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105d08:	c1 e8 10             	shr    $0x10,%eax
80105d0b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105d0f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105d12:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105d15:	c9                   	leave  
80105d16:	c3                   	ret    
80105d17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d1e:	66 90                	xchg   %ax,%ax

80105d20 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105d20:	55                   	push   %ebp
80105d21:	89 e5                	mov    %esp,%ebp
80105d23:	57                   	push   %edi
80105d24:	56                   	push   %esi
80105d25:	53                   	push   %ebx
80105d26:	83 ec 1c             	sub    $0x1c,%esp
80105d29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105d2c:	8b 43 30             	mov    0x30(%ebx),%eax
80105d2f:	83 f8 40             	cmp    $0x40,%eax
80105d32:	0f 84 30 01 00 00    	je     80105e68 <trap+0x148>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105d38:	83 e8 0e             	sub    $0xe,%eax
80105d3b:	83 f8 31             	cmp    $0x31,%eax
80105d3e:	0f 87 8c 00 00 00    	ja     80105dd0 <trap+0xb0>
80105d44:	ff 24 85 88 7f 10 80 	jmp    *-0x7fef8078(,%eax,4)
80105d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d4f:	90                   	nop
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105d50:	e8 3b df ff ff       	call   80103c90 <cpuid>
80105d55:	85 c0                	test   %eax,%eax
80105d57:	0f 84 13 02 00 00    	je     80105f70 <trap+0x250>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105d5d:	e8 ee ce ff ff       	call   80102c50 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d62:	e8 49 df ff ff       	call   80103cb0 <myproc>
80105d67:	85 c0                	test   %eax,%eax
80105d69:	74 1d                	je     80105d88 <trap+0x68>
80105d6b:	e8 40 df ff ff       	call   80103cb0 <myproc>
80105d70:	8b 50 28             	mov    0x28(%eax),%edx
80105d73:	85 d2                	test   %edx,%edx
80105d75:	74 11                	je     80105d88 <trap+0x68>
80105d77:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105d7b:	83 e0 03             	and    $0x3,%eax
80105d7e:	66 83 f8 03          	cmp    $0x3,%ax
80105d82:	0f 84 c8 01 00 00    	je     80105f50 <trap+0x230>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105d88:	e8 23 df ff ff       	call   80103cb0 <myproc>
80105d8d:	85 c0                	test   %eax,%eax
80105d8f:	74 0f                	je     80105da0 <trap+0x80>
80105d91:	e8 1a df ff ff       	call   80103cb0 <myproc>
80105d96:	83 78 10 04          	cmpl   $0x4,0x10(%eax)
80105d9a:	0f 84 b0 00 00 00    	je     80105e50 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105da0:	e8 0b df ff ff       	call   80103cb0 <myproc>
80105da5:	85 c0                	test   %eax,%eax
80105da7:	74 1d                	je     80105dc6 <trap+0xa6>
80105da9:	e8 02 df ff ff       	call   80103cb0 <myproc>
80105dae:	8b 40 28             	mov    0x28(%eax),%eax
80105db1:	85 c0                	test   %eax,%eax
80105db3:	74 11                	je     80105dc6 <trap+0xa6>
80105db5:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105db9:	83 e0 03             	and    $0x3,%eax
80105dbc:	66 83 f8 03          	cmp    $0x3,%ax
80105dc0:	0f 84 cf 00 00 00    	je     80105e95 <trap+0x175>
    exit();
}
80105dc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105dc9:	5b                   	pop    %ebx
80105dca:	5e                   	pop    %esi
80105dcb:	5f                   	pop    %edi
80105dcc:	5d                   	pop    %ebp
80105dcd:	c3                   	ret    
80105dce:	66 90                	xchg   %ax,%ax
    if(myproc() == 0 || (tf->cs&3) == 0){
80105dd0:	e8 db de ff ff       	call   80103cb0 <myproc>
80105dd5:	8b 7b 38             	mov    0x38(%ebx),%edi
80105dd8:	85 c0                	test   %eax,%eax
80105dda:	0f 84 c4 01 00 00    	je     80105fa4 <trap+0x284>
80105de0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105de4:	0f 84 ba 01 00 00    	je     80105fa4 <trap+0x284>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105dea:	0f 20 d1             	mov    %cr2,%ecx
80105ded:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105df0:	e8 9b de ff ff       	call   80103c90 <cpuid>
80105df5:	8b 73 30             	mov    0x30(%ebx),%esi
80105df8:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105dfb:	8b 43 34             	mov    0x34(%ebx),%eax
80105dfe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105e01:	e8 aa de ff ff       	call   80103cb0 <myproc>
80105e06:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105e09:	e8 a2 de ff ff       	call   80103cb0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e0e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105e11:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105e14:	51                   	push   %ecx
80105e15:	57                   	push   %edi
80105e16:	52                   	push   %edx
80105e17:	ff 75 e4             	push   -0x1c(%ebp)
80105e1a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105e1b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105e1e:	83 c6 70             	add    $0x70,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e21:	56                   	push   %esi
80105e22:	ff 70 14             	push   0x14(%eax)
80105e25:	68 44 7f 10 80       	push   $0x80107f44
80105e2a:	e8 71 a8 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80105e2f:	83 c4 20             	add    $0x20,%esp
80105e32:	e8 79 de ff ff       	call   80103cb0 <myproc>
80105e37:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e3e:	e8 6d de ff ff       	call   80103cb0 <myproc>
80105e43:	85 c0                	test   %eax,%eax
80105e45:	0f 85 20 ff ff ff    	jne    80105d6b <trap+0x4b>
80105e4b:	e9 38 ff ff ff       	jmp    80105d88 <trap+0x68>
  if(myproc() && myproc()->state == RUNNING &&
80105e50:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105e54:	0f 85 46 ff ff ff    	jne    80105da0 <trap+0x80>
    yield();
80105e5a:	e8 41 e5 ff ff       	call   801043a0 <yield>
80105e5f:	e9 3c ff ff ff       	jmp    80105da0 <trap+0x80>
80105e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105e68:	e8 43 de ff ff       	call   80103cb0 <myproc>
80105e6d:	8b 70 28             	mov    0x28(%eax),%esi
80105e70:	85 f6                	test   %esi,%esi
80105e72:	0f 85 e8 00 00 00    	jne    80105f60 <trap+0x240>
    myproc()->tf = tf;
80105e78:	e8 33 de ff ff       	call   80103cb0 <myproc>
80105e7d:	89 58 1c             	mov    %ebx,0x1c(%eax)
    syscall();
80105e80:	e8 cb ef ff ff       	call   80104e50 <syscall>
    if(myproc()->killed)
80105e85:	e8 26 de ff ff       	call   80103cb0 <myproc>
80105e8a:	8b 48 28             	mov    0x28(%eax),%ecx
80105e8d:	85 c9                	test   %ecx,%ecx
80105e8f:	0f 84 31 ff ff ff    	je     80105dc6 <trap+0xa6>
}
80105e95:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e98:	5b                   	pop    %ebx
80105e99:	5e                   	pop    %esi
80105e9a:	5f                   	pop    %edi
80105e9b:	5d                   	pop    %ebp
      exit();
80105e9c:	e9 9f e2 ff ff       	jmp    80104140 <exit>
80105ea1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105ea8:	8b 7b 38             	mov    0x38(%ebx),%edi
80105eab:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105eaf:	e8 dc dd ff ff       	call   80103c90 <cpuid>
80105eb4:	57                   	push   %edi
80105eb5:	56                   	push   %esi
80105eb6:	50                   	push   %eax
80105eb7:	68 ec 7e 10 80       	push   $0x80107eec
80105ebc:	e8 df a7 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105ec1:	e8 8a cd ff ff       	call   80102c50 <lapiceoi>
    break;
80105ec6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ec9:	e8 e2 dd ff ff       	call   80103cb0 <myproc>
80105ece:	85 c0                	test   %eax,%eax
80105ed0:	0f 85 95 fe ff ff    	jne    80105d6b <trap+0x4b>
80105ed6:	e9 ad fe ff ff       	jmp    80105d88 <trap+0x68>
80105edb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105edf:	90                   	nop
    kbdintr();
80105ee0:	e8 2b cc ff ff       	call   80102b10 <kbdintr>
    lapiceoi();
80105ee5:	e8 66 cd ff ff       	call   80102c50 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105eea:	e8 c1 dd ff ff       	call   80103cb0 <myproc>
80105eef:	85 c0                	test   %eax,%eax
80105ef1:	0f 85 74 fe ff ff    	jne    80105d6b <trap+0x4b>
80105ef7:	e9 8c fe ff ff       	jmp    80105d88 <trap+0x68>
80105efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105f00:	e8 3b 02 00 00       	call   80106140 <uartintr>
    lapiceoi();
80105f05:	e8 46 cd ff ff       	call   80102c50 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f0a:	e8 a1 dd ff ff       	call   80103cb0 <myproc>
80105f0f:	85 c0                	test   %eax,%eax
80105f11:	0f 85 54 fe ff ff    	jne    80105d6b <trap+0x4b>
80105f17:	e9 6c fe ff ff       	jmp    80105d88 <trap+0x68>
80105f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105f20:	e8 1b c3 ff ff       	call   80102240 <ideintr>
80105f25:	e9 33 fe ff ff       	jmp    80105d5d <trap+0x3d>
80105f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pagingintr();
80105f30:	e8 0b 17 00 00       	call   80107640 <pagingintr>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f35:	e8 76 dd ff ff       	call   80103cb0 <myproc>
80105f3a:	85 c0                	test   %eax,%eax
80105f3c:	0f 85 29 fe ff ff    	jne    80105d6b <trap+0x4b>
80105f42:	e9 41 fe ff ff       	jmp    80105d88 <trap+0x68>
80105f47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f4e:	66 90                	xchg   %ax,%ax
    exit();
80105f50:	e8 eb e1 ff ff       	call   80104140 <exit>
80105f55:	e9 2e fe ff ff       	jmp    80105d88 <trap+0x68>
80105f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105f60:	e8 db e1 ff ff       	call   80104140 <exit>
80105f65:	e9 0e ff ff ff       	jmp    80105e78 <trap+0x158>
80105f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105f70:	83 ec 0c             	sub    $0xc,%esp
80105f73:	68 a0 5d 11 80       	push   $0x80115da0
80105f78:	e8 13 ea ff ff       	call   80104990 <acquire>
      wakeup(&ticks);
80105f7d:	c7 04 24 80 5d 11 80 	movl   $0x80115d80,(%esp)
      ticks++;
80105f84:	83 05 80 5d 11 80 01 	addl   $0x1,0x80115d80
      wakeup(&ticks);
80105f8b:	e8 20 e5 ff ff       	call   801044b0 <wakeup>
      release(&tickslock);
80105f90:	c7 04 24 a0 5d 11 80 	movl   $0x80115da0,(%esp)
80105f97:	e8 94 e9 ff ff       	call   80104930 <release>
80105f9c:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105f9f:	e9 b9 fd ff ff       	jmp    80105d5d <trap+0x3d>
80105fa4:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105fa7:	e8 e4 dc ff ff       	call   80103c90 <cpuid>
80105fac:	83 ec 0c             	sub    $0xc,%esp
80105faf:	56                   	push   %esi
80105fb0:	57                   	push   %edi
80105fb1:	50                   	push   %eax
80105fb2:	ff 73 30             	push   0x30(%ebx)
80105fb5:	68 10 7f 10 80       	push   $0x80107f10
80105fba:	e8 e1 a6 ff ff       	call   801006a0 <cprintf>
      panic("trap");
80105fbf:	83 c4 14             	add    $0x14,%esp
80105fc2:	68 e6 7e 10 80       	push   $0x80107ee6
80105fc7:	e8 b4 a3 ff ff       	call   80100380 <panic>
80105fcc:	66 90                	xchg   %ax,%ax
80105fce:	66 90                	xchg   %ax,%ax

80105fd0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105fd0:	a1 e0 65 11 80       	mov    0x801165e0,%eax
80105fd5:	85 c0                	test   %eax,%eax
80105fd7:	74 17                	je     80105ff0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105fd9:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105fde:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105fdf:	a8 01                	test   $0x1,%al
80105fe1:	74 0d                	je     80105ff0 <uartgetc+0x20>
80105fe3:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fe8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105fe9:	0f b6 c0             	movzbl %al,%eax
80105fec:	c3                   	ret    
80105fed:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105ff0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ff5:	c3                   	ret    
80105ff6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ffd:	8d 76 00             	lea    0x0(%esi),%esi

80106000 <uartinit>:
{
80106000:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106001:	31 c9                	xor    %ecx,%ecx
80106003:	89 c8                	mov    %ecx,%eax
80106005:	89 e5                	mov    %esp,%ebp
80106007:	57                   	push   %edi
80106008:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010600d:	56                   	push   %esi
8010600e:	89 fa                	mov    %edi,%edx
80106010:	53                   	push   %ebx
80106011:	83 ec 1c             	sub    $0x1c,%esp
80106014:	ee                   	out    %al,(%dx)
80106015:	be fb 03 00 00       	mov    $0x3fb,%esi
8010601a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010601f:	89 f2                	mov    %esi,%edx
80106021:	ee                   	out    %al,(%dx)
80106022:	b8 0c 00 00 00       	mov    $0xc,%eax
80106027:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010602c:	ee                   	out    %al,(%dx)
8010602d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106032:	89 c8                	mov    %ecx,%eax
80106034:	89 da                	mov    %ebx,%edx
80106036:	ee                   	out    %al,(%dx)
80106037:	b8 03 00 00 00       	mov    $0x3,%eax
8010603c:	89 f2                	mov    %esi,%edx
8010603e:	ee                   	out    %al,(%dx)
8010603f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106044:	89 c8                	mov    %ecx,%eax
80106046:	ee                   	out    %al,(%dx)
80106047:	b8 01 00 00 00       	mov    $0x1,%eax
8010604c:	89 da                	mov    %ebx,%edx
8010604e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010604f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106054:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106055:	3c ff                	cmp    $0xff,%al
80106057:	74 78                	je     801060d1 <uartinit+0xd1>
  uart = 1;
80106059:	c7 05 e0 65 11 80 01 	movl   $0x1,0x801165e0
80106060:	00 00 00 
80106063:	89 fa                	mov    %edi,%edx
80106065:	ec                   	in     (%dx),%al
80106066:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010606b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010606c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010606f:	bf 50 80 10 80       	mov    $0x80108050,%edi
80106074:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106079:	6a 00                	push   $0x0
8010607b:	6a 04                	push   $0x4
8010607d:	e8 fe c3 ff ff       	call   80102480 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106082:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106086:	83 c4 10             	add    $0x10,%esp
80106089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106090:	a1 e0 65 11 80       	mov    0x801165e0,%eax
80106095:	bb 80 00 00 00       	mov    $0x80,%ebx
8010609a:	85 c0                	test   %eax,%eax
8010609c:	75 14                	jne    801060b2 <uartinit+0xb2>
8010609e:	eb 23                	jmp    801060c3 <uartinit+0xc3>
    microdelay(10);
801060a0:	83 ec 0c             	sub    $0xc,%esp
801060a3:	6a 0a                	push   $0xa
801060a5:	e8 c6 cb ff ff       	call   80102c70 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801060aa:	83 c4 10             	add    $0x10,%esp
801060ad:	83 eb 01             	sub    $0x1,%ebx
801060b0:	74 07                	je     801060b9 <uartinit+0xb9>
801060b2:	89 f2                	mov    %esi,%edx
801060b4:	ec                   	in     (%dx),%al
801060b5:	a8 20                	test   $0x20,%al
801060b7:	74 e7                	je     801060a0 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801060b9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801060bd:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060c2:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
801060c3:	0f b6 47 01          	movzbl 0x1(%edi),%eax
801060c7:	83 c7 01             	add    $0x1,%edi
801060ca:	88 45 e7             	mov    %al,-0x19(%ebp)
801060cd:	84 c0                	test   %al,%al
801060cf:	75 bf                	jne    80106090 <uartinit+0x90>
}
801060d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060d4:	5b                   	pop    %ebx
801060d5:	5e                   	pop    %esi
801060d6:	5f                   	pop    %edi
801060d7:	5d                   	pop    %ebp
801060d8:	c3                   	ret    
801060d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801060e0 <uartputc>:
  if(!uart)
801060e0:	a1 e0 65 11 80       	mov    0x801165e0,%eax
801060e5:	85 c0                	test   %eax,%eax
801060e7:	74 47                	je     80106130 <uartputc+0x50>
{
801060e9:	55                   	push   %ebp
801060ea:	89 e5                	mov    %esp,%ebp
801060ec:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801060ed:	be fd 03 00 00       	mov    $0x3fd,%esi
801060f2:	53                   	push   %ebx
801060f3:	bb 80 00 00 00       	mov    $0x80,%ebx
801060f8:	eb 18                	jmp    80106112 <uartputc+0x32>
801060fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106100:	83 ec 0c             	sub    $0xc,%esp
80106103:	6a 0a                	push   $0xa
80106105:	e8 66 cb ff ff       	call   80102c70 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010610a:	83 c4 10             	add    $0x10,%esp
8010610d:	83 eb 01             	sub    $0x1,%ebx
80106110:	74 07                	je     80106119 <uartputc+0x39>
80106112:	89 f2                	mov    %esi,%edx
80106114:	ec                   	in     (%dx),%al
80106115:	a8 20                	test   $0x20,%al
80106117:	74 e7                	je     80106100 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106119:	8b 45 08             	mov    0x8(%ebp),%eax
8010611c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106121:	ee                   	out    %al,(%dx)
}
80106122:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106125:	5b                   	pop    %ebx
80106126:	5e                   	pop    %esi
80106127:	5d                   	pop    %ebp
80106128:	c3                   	ret    
80106129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106130:	c3                   	ret    
80106131:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106138:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010613f:	90                   	nop

80106140 <uartintr>:

void
uartintr(void)
{
80106140:	55                   	push   %ebp
80106141:	89 e5                	mov    %esp,%ebp
80106143:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106146:	68 d0 5f 10 80       	push   $0x80105fd0
8010614b:	e8 30 a7 ff ff       	call   80100880 <consoleintr>
}
80106150:	83 c4 10             	add    $0x10,%esp
80106153:	c9                   	leave  
80106154:	c3                   	ret    

80106155 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106155:	6a 00                	push   $0x0
  pushl $0
80106157:	6a 00                	push   $0x0
  jmp alltraps
80106159:	e9 ec fa ff ff       	jmp    80105c4a <alltraps>

8010615e <vector1>:
.globl vector1
vector1:
  pushl $0
8010615e:	6a 00                	push   $0x0
  pushl $1
80106160:	6a 01                	push   $0x1
  jmp alltraps
80106162:	e9 e3 fa ff ff       	jmp    80105c4a <alltraps>

80106167 <vector2>:
.globl vector2
vector2:
  pushl $0
80106167:	6a 00                	push   $0x0
  pushl $2
80106169:	6a 02                	push   $0x2
  jmp alltraps
8010616b:	e9 da fa ff ff       	jmp    80105c4a <alltraps>

80106170 <vector3>:
.globl vector3
vector3:
  pushl $0
80106170:	6a 00                	push   $0x0
  pushl $3
80106172:	6a 03                	push   $0x3
  jmp alltraps
80106174:	e9 d1 fa ff ff       	jmp    80105c4a <alltraps>

80106179 <vector4>:
.globl vector4
vector4:
  pushl $0
80106179:	6a 00                	push   $0x0
  pushl $4
8010617b:	6a 04                	push   $0x4
  jmp alltraps
8010617d:	e9 c8 fa ff ff       	jmp    80105c4a <alltraps>

80106182 <vector5>:
.globl vector5
vector5:
  pushl $0
80106182:	6a 00                	push   $0x0
  pushl $5
80106184:	6a 05                	push   $0x5
  jmp alltraps
80106186:	e9 bf fa ff ff       	jmp    80105c4a <alltraps>

8010618b <vector6>:
.globl vector6
vector6:
  pushl $0
8010618b:	6a 00                	push   $0x0
  pushl $6
8010618d:	6a 06                	push   $0x6
  jmp alltraps
8010618f:	e9 b6 fa ff ff       	jmp    80105c4a <alltraps>

80106194 <vector7>:
.globl vector7
vector7:
  pushl $0
80106194:	6a 00                	push   $0x0
  pushl $7
80106196:	6a 07                	push   $0x7
  jmp alltraps
80106198:	e9 ad fa ff ff       	jmp    80105c4a <alltraps>

8010619d <vector8>:
.globl vector8
vector8:
  pushl $8
8010619d:	6a 08                	push   $0x8
  jmp alltraps
8010619f:	e9 a6 fa ff ff       	jmp    80105c4a <alltraps>

801061a4 <vector9>:
.globl vector9
vector9:
  pushl $0
801061a4:	6a 00                	push   $0x0
  pushl $9
801061a6:	6a 09                	push   $0x9
  jmp alltraps
801061a8:	e9 9d fa ff ff       	jmp    80105c4a <alltraps>

801061ad <vector10>:
.globl vector10
vector10:
  pushl $10
801061ad:	6a 0a                	push   $0xa
  jmp alltraps
801061af:	e9 96 fa ff ff       	jmp    80105c4a <alltraps>

801061b4 <vector11>:
.globl vector11
vector11:
  pushl $11
801061b4:	6a 0b                	push   $0xb
  jmp alltraps
801061b6:	e9 8f fa ff ff       	jmp    80105c4a <alltraps>

801061bb <vector12>:
.globl vector12
vector12:
  pushl $12
801061bb:	6a 0c                	push   $0xc
  jmp alltraps
801061bd:	e9 88 fa ff ff       	jmp    80105c4a <alltraps>

801061c2 <vector13>:
.globl vector13
vector13:
  pushl $13
801061c2:	6a 0d                	push   $0xd
  jmp alltraps
801061c4:	e9 81 fa ff ff       	jmp    80105c4a <alltraps>

801061c9 <vector14>:
.globl vector14
vector14:
  pushl $14
801061c9:	6a 0e                	push   $0xe
  jmp alltraps
801061cb:	e9 7a fa ff ff       	jmp    80105c4a <alltraps>

801061d0 <vector15>:
.globl vector15
vector15:
  pushl $0
801061d0:	6a 00                	push   $0x0
  pushl $15
801061d2:	6a 0f                	push   $0xf
  jmp alltraps
801061d4:	e9 71 fa ff ff       	jmp    80105c4a <alltraps>

801061d9 <vector16>:
.globl vector16
vector16:
  pushl $0
801061d9:	6a 00                	push   $0x0
  pushl $16
801061db:	6a 10                	push   $0x10
  jmp alltraps
801061dd:	e9 68 fa ff ff       	jmp    80105c4a <alltraps>

801061e2 <vector17>:
.globl vector17
vector17:
  pushl $17
801061e2:	6a 11                	push   $0x11
  jmp alltraps
801061e4:	e9 61 fa ff ff       	jmp    80105c4a <alltraps>

801061e9 <vector18>:
.globl vector18
vector18:
  pushl $0
801061e9:	6a 00                	push   $0x0
  pushl $18
801061eb:	6a 12                	push   $0x12
  jmp alltraps
801061ed:	e9 58 fa ff ff       	jmp    80105c4a <alltraps>

801061f2 <vector19>:
.globl vector19
vector19:
  pushl $0
801061f2:	6a 00                	push   $0x0
  pushl $19
801061f4:	6a 13                	push   $0x13
  jmp alltraps
801061f6:	e9 4f fa ff ff       	jmp    80105c4a <alltraps>

801061fb <vector20>:
.globl vector20
vector20:
  pushl $0
801061fb:	6a 00                	push   $0x0
  pushl $20
801061fd:	6a 14                	push   $0x14
  jmp alltraps
801061ff:	e9 46 fa ff ff       	jmp    80105c4a <alltraps>

80106204 <vector21>:
.globl vector21
vector21:
  pushl $0
80106204:	6a 00                	push   $0x0
  pushl $21
80106206:	6a 15                	push   $0x15
  jmp alltraps
80106208:	e9 3d fa ff ff       	jmp    80105c4a <alltraps>

8010620d <vector22>:
.globl vector22
vector22:
  pushl $0
8010620d:	6a 00                	push   $0x0
  pushl $22
8010620f:	6a 16                	push   $0x16
  jmp alltraps
80106211:	e9 34 fa ff ff       	jmp    80105c4a <alltraps>

80106216 <vector23>:
.globl vector23
vector23:
  pushl $0
80106216:	6a 00                	push   $0x0
  pushl $23
80106218:	6a 17                	push   $0x17
  jmp alltraps
8010621a:	e9 2b fa ff ff       	jmp    80105c4a <alltraps>

8010621f <vector24>:
.globl vector24
vector24:
  pushl $0
8010621f:	6a 00                	push   $0x0
  pushl $24
80106221:	6a 18                	push   $0x18
  jmp alltraps
80106223:	e9 22 fa ff ff       	jmp    80105c4a <alltraps>

80106228 <vector25>:
.globl vector25
vector25:
  pushl $0
80106228:	6a 00                	push   $0x0
  pushl $25
8010622a:	6a 19                	push   $0x19
  jmp alltraps
8010622c:	e9 19 fa ff ff       	jmp    80105c4a <alltraps>

80106231 <vector26>:
.globl vector26
vector26:
  pushl $0
80106231:	6a 00                	push   $0x0
  pushl $26
80106233:	6a 1a                	push   $0x1a
  jmp alltraps
80106235:	e9 10 fa ff ff       	jmp    80105c4a <alltraps>

8010623a <vector27>:
.globl vector27
vector27:
  pushl $0
8010623a:	6a 00                	push   $0x0
  pushl $27
8010623c:	6a 1b                	push   $0x1b
  jmp alltraps
8010623e:	e9 07 fa ff ff       	jmp    80105c4a <alltraps>

80106243 <vector28>:
.globl vector28
vector28:
  pushl $0
80106243:	6a 00                	push   $0x0
  pushl $28
80106245:	6a 1c                	push   $0x1c
  jmp alltraps
80106247:	e9 fe f9 ff ff       	jmp    80105c4a <alltraps>

8010624c <vector29>:
.globl vector29
vector29:
  pushl $0
8010624c:	6a 00                	push   $0x0
  pushl $29
8010624e:	6a 1d                	push   $0x1d
  jmp alltraps
80106250:	e9 f5 f9 ff ff       	jmp    80105c4a <alltraps>

80106255 <vector30>:
.globl vector30
vector30:
  pushl $0
80106255:	6a 00                	push   $0x0
  pushl $30
80106257:	6a 1e                	push   $0x1e
  jmp alltraps
80106259:	e9 ec f9 ff ff       	jmp    80105c4a <alltraps>

8010625e <vector31>:
.globl vector31
vector31:
  pushl $0
8010625e:	6a 00                	push   $0x0
  pushl $31
80106260:	6a 1f                	push   $0x1f
  jmp alltraps
80106262:	e9 e3 f9 ff ff       	jmp    80105c4a <alltraps>

80106267 <vector32>:
.globl vector32
vector32:
  pushl $0
80106267:	6a 00                	push   $0x0
  pushl $32
80106269:	6a 20                	push   $0x20
  jmp alltraps
8010626b:	e9 da f9 ff ff       	jmp    80105c4a <alltraps>

80106270 <vector33>:
.globl vector33
vector33:
  pushl $0
80106270:	6a 00                	push   $0x0
  pushl $33
80106272:	6a 21                	push   $0x21
  jmp alltraps
80106274:	e9 d1 f9 ff ff       	jmp    80105c4a <alltraps>

80106279 <vector34>:
.globl vector34
vector34:
  pushl $0
80106279:	6a 00                	push   $0x0
  pushl $34
8010627b:	6a 22                	push   $0x22
  jmp alltraps
8010627d:	e9 c8 f9 ff ff       	jmp    80105c4a <alltraps>

80106282 <vector35>:
.globl vector35
vector35:
  pushl $0
80106282:	6a 00                	push   $0x0
  pushl $35
80106284:	6a 23                	push   $0x23
  jmp alltraps
80106286:	e9 bf f9 ff ff       	jmp    80105c4a <alltraps>

8010628b <vector36>:
.globl vector36
vector36:
  pushl $0
8010628b:	6a 00                	push   $0x0
  pushl $36
8010628d:	6a 24                	push   $0x24
  jmp alltraps
8010628f:	e9 b6 f9 ff ff       	jmp    80105c4a <alltraps>

80106294 <vector37>:
.globl vector37
vector37:
  pushl $0
80106294:	6a 00                	push   $0x0
  pushl $37
80106296:	6a 25                	push   $0x25
  jmp alltraps
80106298:	e9 ad f9 ff ff       	jmp    80105c4a <alltraps>

8010629d <vector38>:
.globl vector38
vector38:
  pushl $0
8010629d:	6a 00                	push   $0x0
  pushl $38
8010629f:	6a 26                	push   $0x26
  jmp alltraps
801062a1:	e9 a4 f9 ff ff       	jmp    80105c4a <alltraps>

801062a6 <vector39>:
.globl vector39
vector39:
  pushl $0
801062a6:	6a 00                	push   $0x0
  pushl $39
801062a8:	6a 27                	push   $0x27
  jmp alltraps
801062aa:	e9 9b f9 ff ff       	jmp    80105c4a <alltraps>

801062af <vector40>:
.globl vector40
vector40:
  pushl $0
801062af:	6a 00                	push   $0x0
  pushl $40
801062b1:	6a 28                	push   $0x28
  jmp alltraps
801062b3:	e9 92 f9 ff ff       	jmp    80105c4a <alltraps>

801062b8 <vector41>:
.globl vector41
vector41:
  pushl $0
801062b8:	6a 00                	push   $0x0
  pushl $41
801062ba:	6a 29                	push   $0x29
  jmp alltraps
801062bc:	e9 89 f9 ff ff       	jmp    80105c4a <alltraps>

801062c1 <vector42>:
.globl vector42
vector42:
  pushl $0
801062c1:	6a 00                	push   $0x0
  pushl $42
801062c3:	6a 2a                	push   $0x2a
  jmp alltraps
801062c5:	e9 80 f9 ff ff       	jmp    80105c4a <alltraps>

801062ca <vector43>:
.globl vector43
vector43:
  pushl $0
801062ca:	6a 00                	push   $0x0
  pushl $43
801062cc:	6a 2b                	push   $0x2b
  jmp alltraps
801062ce:	e9 77 f9 ff ff       	jmp    80105c4a <alltraps>

801062d3 <vector44>:
.globl vector44
vector44:
  pushl $0
801062d3:	6a 00                	push   $0x0
  pushl $44
801062d5:	6a 2c                	push   $0x2c
  jmp alltraps
801062d7:	e9 6e f9 ff ff       	jmp    80105c4a <alltraps>

801062dc <vector45>:
.globl vector45
vector45:
  pushl $0
801062dc:	6a 00                	push   $0x0
  pushl $45
801062de:	6a 2d                	push   $0x2d
  jmp alltraps
801062e0:	e9 65 f9 ff ff       	jmp    80105c4a <alltraps>

801062e5 <vector46>:
.globl vector46
vector46:
  pushl $0
801062e5:	6a 00                	push   $0x0
  pushl $46
801062e7:	6a 2e                	push   $0x2e
  jmp alltraps
801062e9:	e9 5c f9 ff ff       	jmp    80105c4a <alltraps>

801062ee <vector47>:
.globl vector47
vector47:
  pushl $0
801062ee:	6a 00                	push   $0x0
  pushl $47
801062f0:	6a 2f                	push   $0x2f
  jmp alltraps
801062f2:	e9 53 f9 ff ff       	jmp    80105c4a <alltraps>

801062f7 <vector48>:
.globl vector48
vector48:
  pushl $0
801062f7:	6a 00                	push   $0x0
  pushl $48
801062f9:	6a 30                	push   $0x30
  jmp alltraps
801062fb:	e9 4a f9 ff ff       	jmp    80105c4a <alltraps>

80106300 <vector49>:
.globl vector49
vector49:
  pushl $0
80106300:	6a 00                	push   $0x0
  pushl $49
80106302:	6a 31                	push   $0x31
  jmp alltraps
80106304:	e9 41 f9 ff ff       	jmp    80105c4a <alltraps>

80106309 <vector50>:
.globl vector50
vector50:
  pushl $0
80106309:	6a 00                	push   $0x0
  pushl $50
8010630b:	6a 32                	push   $0x32
  jmp alltraps
8010630d:	e9 38 f9 ff ff       	jmp    80105c4a <alltraps>

80106312 <vector51>:
.globl vector51
vector51:
  pushl $0
80106312:	6a 00                	push   $0x0
  pushl $51
80106314:	6a 33                	push   $0x33
  jmp alltraps
80106316:	e9 2f f9 ff ff       	jmp    80105c4a <alltraps>

8010631b <vector52>:
.globl vector52
vector52:
  pushl $0
8010631b:	6a 00                	push   $0x0
  pushl $52
8010631d:	6a 34                	push   $0x34
  jmp alltraps
8010631f:	e9 26 f9 ff ff       	jmp    80105c4a <alltraps>

80106324 <vector53>:
.globl vector53
vector53:
  pushl $0
80106324:	6a 00                	push   $0x0
  pushl $53
80106326:	6a 35                	push   $0x35
  jmp alltraps
80106328:	e9 1d f9 ff ff       	jmp    80105c4a <alltraps>

8010632d <vector54>:
.globl vector54
vector54:
  pushl $0
8010632d:	6a 00                	push   $0x0
  pushl $54
8010632f:	6a 36                	push   $0x36
  jmp alltraps
80106331:	e9 14 f9 ff ff       	jmp    80105c4a <alltraps>

80106336 <vector55>:
.globl vector55
vector55:
  pushl $0
80106336:	6a 00                	push   $0x0
  pushl $55
80106338:	6a 37                	push   $0x37
  jmp alltraps
8010633a:	e9 0b f9 ff ff       	jmp    80105c4a <alltraps>

8010633f <vector56>:
.globl vector56
vector56:
  pushl $0
8010633f:	6a 00                	push   $0x0
  pushl $56
80106341:	6a 38                	push   $0x38
  jmp alltraps
80106343:	e9 02 f9 ff ff       	jmp    80105c4a <alltraps>

80106348 <vector57>:
.globl vector57
vector57:
  pushl $0
80106348:	6a 00                	push   $0x0
  pushl $57
8010634a:	6a 39                	push   $0x39
  jmp alltraps
8010634c:	e9 f9 f8 ff ff       	jmp    80105c4a <alltraps>

80106351 <vector58>:
.globl vector58
vector58:
  pushl $0
80106351:	6a 00                	push   $0x0
  pushl $58
80106353:	6a 3a                	push   $0x3a
  jmp alltraps
80106355:	e9 f0 f8 ff ff       	jmp    80105c4a <alltraps>

8010635a <vector59>:
.globl vector59
vector59:
  pushl $0
8010635a:	6a 00                	push   $0x0
  pushl $59
8010635c:	6a 3b                	push   $0x3b
  jmp alltraps
8010635e:	e9 e7 f8 ff ff       	jmp    80105c4a <alltraps>

80106363 <vector60>:
.globl vector60
vector60:
  pushl $0
80106363:	6a 00                	push   $0x0
  pushl $60
80106365:	6a 3c                	push   $0x3c
  jmp alltraps
80106367:	e9 de f8 ff ff       	jmp    80105c4a <alltraps>

8010636c <vector61>:
.globl vector61
vector61:
  pushl $0
8010636c:	6a 00                	push   $0x0
  pushl $61
8010636e:	6a 3d                	push   $0x3d
  jmp alltraps
80106370:	e9 d5 f8 ff ff       	jmp    80105c4a <alltraps>

80106375 <vector62>:
.globl vector62
vector62:
  pushl $0
80106375:	6a 00                	push   $0x0
  pushl $62
80106377:	6a 3e                	push   $0x3e
  jmp alltraps
80106379:	e9 cc f8 ff ff       	jmp    80105c4a <alltraps>

8010637e <vector63>:
.globl vector63
vector63:
  pushl $0
8010637e:	6a 00                	push   $0x0
  pushl $63
80106380:	6a 3f                	push   $0x3f
  jmp alltraps
80106382:	e9 c3 f8 ff ff       	jmp    80105c4a <alltraps>

80106387 <vector64>:
.globl vector64
vector64:
  pushl $0
80106387:	6a 00                	push   $0x0
  pushl $64
80106389:	6a 40                	push   $0x40
  jmp alltraps
8010638b:	e9 ba f8 ff ff       	jmp    80105c4a <alltraps>

80106390 <vector65>:
.globl vector65
vector65:
  pushl $0
80106390:	6a 00                	push   $0x0
  pushl $65
80106392:	6a 41                	push   $0x41
  jmp alltraps
80106394:	e9 b1 f8 ff ff       	jmp    80105c4a <alltraps>

80106399 <vector66>:
.globl vector66
vector66:
  pushl $0
80106399:	6a 00                	push   $0x0
  pushl $66
8010639b:	6a 42                	push   $0x42
  jmp alltraps
8010639d:	e9 a8 f8 ff ff       	jmp    80105c4a <alltraps>

801063a2 <vector67>:
.globl vector67
vector67:
  pushl $0
801063a2:	6a 00                	push   $0x0
  pushl $67
801063a4:	6a 43                	push   $0x43
  jmp alltraps
801063a6:	e9 9f f8 ff ff       	jmp    80105c4a <alltraps>

801063ab <vector68>:
.globl vector68
vector68:
  pushl $0
801063ab:	6a 00                	push   $0x0
  pushl $68
801063ad:	6a 44                	push   $0x44
  jmp alltraps
801063af:	e9 96 f8 ff ff       	jmp    80105c4a <alltraps>

801063b4 <vector69>:
.globl vector69
vector69:
  pushl $0
801063b4:	6a 00                	push   $0x0
  pushl $69
801063b6:	6a 45                	push   $0x45
  jmp alltraps
801063b8:	e9 8d f8 ff ff       	jmp    80105c4a <alltraps>

801063bd <vector70>:
.globl vector70
vector70:
  pushl $0
801063bd:	6a 00                	push   $0x0
  pushl $70
801063bf:	6a 46                	push   $0x46
  jmp alltraps
801063c1:	e9 84 f8 ff ff       	jmp    80105c4a <alltraps>

801063c6 <vector71>:
.globl vector71
vector71:
  pushl $0
801063c6:	6a 00                	push   $0x0
  pushl $71
801063c8:	6a 47                	push   $0x47
  jmp alltraps
801063ca:	e9 7b f8 ff ff       	jmp    80105c4a <alltraps>

801063cf <vector72>:
.globl vector72
vector72:
  pushl $0
801063cf:	6a 00                	push   $0x0
  pushl $72
801063d1:	6a 48                	push   $0x48
  jmp alltraps
801063d3:	e9 72 f8 ff ff       	jmp    80105c4a <alltraps>

801063d8 <vector73>:
.globl vector73
vector73:
  pushl $0
801063d8:	6a 00                	push   $0x0
  pushl $73
801063da:	6a 49                	push   $0x49
  jmp alltraps
801063dc:	e9 69 f8 ff ff       	jmp    80105c4a <alltraps>

801063e1 <vector74>:
.globl vector74
vector74:
  pushl $0
801063e1:	6a 00                	push   $0x0
  pushl $74
801063e3:	6a 4a                	push   $0x4a
  jmp alltraps
801063e5:	e9 60 f8 ff ff       	jmp    80105c4a <alltraps>

801063ea <vector75>:
.globl vector75
vector75:
  pushl $0
801063ea:	6a 00                	push   $0x0
  pushl $75
801063ec:	6a 4b                	push   $0x4b
  jmp alltraps
801063ee:	e9 57 f8 ff ff       	jmp    80105c4a <alltraps>

801063f3 <vector76>:
.globl vector76
vector76:
  pushl $0
801063f3:	6a 00                	push   $0x0
  pushl $76
801063f5:	6a 4c                	push   $0x4c
  jmp alltraps
801063f7:	e9 4e f8 ff ff       	jmp    80105c4a <alltraps>

801063fc <vector77>:
.globl vector77
vector77:
  pushl $0
801063fc:	6a 00                	push   $0x0
  pushl $77
801063fe:	6a 4d                	push   $0x4d
  jmp alltraps
80106400:	e9 45 f8 ff ff       	jmp    80105c4a <alltraps>

80106405 <vector78>:
.globl vector78
vector78:
  pushl $0
80106405:	6a 00                	push   $0x0
  pushl $78
80106407:	6a 4e                	push   $0x4e
  jmp alltraps
80106409:	e9 3c f8 ff ff       	jmp    80105c4a <alltraps>

8010640e <vector79>:
.globl vector79
vector79:
  pushl $0
8010640e:	6a 00                	push   $0x0
  pushl $79
80106410:	6a 4f                	push   $0x4f
  jmp alltraps
80106412:	e9 33 f8 ff ff       	jmp    80105c4a <alltraps>

80106417 <vector80>:
.globl vector80
vector80:
  pushl $0
80106417:	6a 00                	push   $0x0
  pushl $80
80106419:	6a 50                	push   $0x50
  jmp alltraps
8010641b:	e9 2a f8 ff ff       	jmp    80105c4a <alltraps>

80106420 <vector81>:
.globl vector81
vector81:
  pushl $0
80106420:	6a 00                	push   $0x0
  pushl $81
80106422:	6a 51                	push   $0x51
  jmp alltraps
80106424:	e9 21 f8 ff ff       	jmp    80105c4a <alltraps>

80106429 <vector82>:
.globl vector82
vector82:
  pushl $0
80106429:	6a 00                	push   $0x0
  pushl $82
8010642b:	6a 52                	push   $0x52
  jmp alltraps
8010642d:	e9 18 f8 ff ff       	jmp    80105c4a <alltraps>

80106432 <vector83>:
.globl vector83
vector83:
  pushl $0
80106432:	6a 00                	push   $0x0
  pushl $83
80106434:	6a 53                	push   $0x53
  jmp alltraps
80106436:	e9 0f f8 ff ff       	jmp    80105c4a <alltraps>

8010643b <vector84>:
.globl vector84
vector84:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $84
8010643d:	6a 54                	push   $0x54
  jmp alltraps
8010643f:	e9 06 f8 ff ff       	jmp    80105c4a <alltraps>

80106444 <vector85>:
.globl vector85
vector85:
  pushl $0
80106444:	6a 00                	push   $0x0
  pushl $85
80106446:	6a 55                	push   $0x55
  jmp alltraps
80106448:	e9 fd f7 ff ff       	jmp    80105c4a <alltraps>

8010644d <vector86>:
.globl vector86
vector86:
  pushl $0
8010644d:	6a 00                	push   $0x0
  pushl $86
8010644f:	6a 56                	push   $0x56
  jmp alltraps
80106451:	e9 f4 f7 ff ff       	jmp    80105c4a <alltraps>

80106456 <vector87>:
.globl vector87
vector87:
  pushl $0
80106456:	6a 00                	push   $0x0
  pushl $87
80106458:	6a 57                	push   $0x57
  jmp alltraps
8010645a:	e9 eb f7 ff ff       	jmp    80105c4a <alltraps>

8010645f <vector88>:
.globl vector88
vector88:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $88
80106461:	6a 58                	push   $0x58
  jmp alltraps
80106463:	e9 e2 f7 ff ff       	jmp    80105c4a <alltraps>

80106468 <vector89>:
.globl vector89
vector89:
  pushl $0
80106468:	6a 00                	push   $0x0
  pushl $89
8010646a:	6a 59                	push   $0x59
  jmp alltraps
8010646c:	e9 d9 f7 ff ff       	jmp    80105c4a <alltraps>

80106471 <vector90>:
.globl vector90
vector90:
  pushl $0
80106471:	6a 00                	push   $0x0
  pushl $90
80106473:	6a 5a                	push   $0x5a
  jmp alltraps
80106475:	e9 d0 f7 ff ff       	jmp    80105c4a <alltraps>

8010647a <vector91>:
.globl vector91
vector91:
  pushl $0
8010647a:	6a 00                	push   $0x0
  pushl $91
8010647c:	6a 5b                	push   $0x5b
  jmp alltraps
8010647e:	e9 c7 f7 ff ff       	jmp    80105c4a <alltraps>

80106483 <vector92>:
.globl vector92
vector92:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $92
80106485:	6a 5c                	push   $0x5c
  jmp alltraps
80106487:	e9 be f7 ff ff       	jmp    80105c4a <alltraps>

8010648c <vector93>:
.globl vector93
vector93:
  pushl $0
8010648c:	6a 00                	push   $0x0
  pushl $93
8010648e:	6a 5d                	push   $0x5d
  jmp alltraps
80106490:	e9 b5 f7 ff ff       	jmp    80105c4a <alltraps>

80106495 <vector94>:
.globl vector94
vector94:
  pushl $0
80106495:	6a 00                	push   $0x0
  pushl $94
80106497:	6a 5e                	push   $0x5e
  jmp alltraps
80106499:	e9 ac f7 ff ff       	jmp    80105c4a <alltraps>

8010649e <vector95>:
.globl vector95
vector95:
  pushl $0
8010649e:	6a 00                	push   $0x0
  pushl $95
801064a0:	6a 5f                	push   $0x5f
  jmp alltraps
801064a2:	e9 a3 f7 ff ff       	jmp    80105c4a <alltraps>

801064a7 <vector96>:
.globl vector96
vector96:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $96
801064a9:	6a 60                	push   $0x60
  jmp alltraps
801064ab:	e9 9a f7 ff ff       	jmp    80105c4a <alltraps>

801064b0 <vector97>:
.globl vector97
vector97:
  pushl $0
801064b0:	6a 00                	push   $0x0
  pushl $97
801064b2:	6a 61                	push   $0x61
  jmp alltraps
801064b4:	e9 91 f7 ff ff       	jmp    80105c4a <alltraps>

801064b9 <vector98>:
.globl vector98
vector98:
  pushl $0
801064b9:	6a 00                	push   $0x0
  pushl $98
801064bb:	6a 62                	push   $0x62
  jmp alltraps
801064bd:	e9 88 f7 ff ff       	jmp    80105c4a <alltraps>

801064c2 <vector99>:
.globl vector99
vector99:
  pushl $0
801064c2:	6a 00                	push   $0x0
  pushl $99
801064c4:	6a 63                	push   $0x63
  jmp alltraps
801064c6:	e9 7f f7 ff ff       	jmp    80105c4a <alltraps>

801064cb <vector100>:
.globl vector100
vector100:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $100
801064cd:	6a 64                	push   $0x64
  jmp alltraps
801064cf:	e9 76 f7 ff ff       	jmp    80105c4a <alltraps>

801064d4 <vector101>:
.globl vector101
vector101:
  pushl $0
801064d4:	6a 00                	push   $0x0
  pushl $101
801064d6:	6a 65                	push   $0x65
  jmp alltraps
801064d8:	e9 6d f7 ff ff       	jmp    80105c4a <alltraps>

801064dd <vector102>:
.globl vector102
vector102:
  pushl $0
801064dd:	6a 00                	push   $0x0
  pushl $102
801064df:	6a 66                	push   $0x66
  jmp alltraps
801064e1:	e9 64 f7 ff ff       	jmp    80105c4a <alltraps>

801064e6 <vector103>:
.globl vector103
vector103:
  pushl $0
801064e6:	6a 00                	push   $0x0
  pushl $103
801064e8:	6a 67                	push   $0x67
  jmp alltraps
801064ea:	e9 5b f7 ff ff       	jmp    80105c4a <alltraps>

801064ef <vector104>:
.globl vector104
vector104:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $104
801064f1:	6a 68                	push   $0x68
  jmp alltraps
801064f3:	e9 52 f7 ff ff       	jmp    80105c4a <alltraps>

801064f8 <vector105>:
.globl vector105
vector105:
  pushl $0
801064f8:	6a 00                	push   $0x0
  pushl $105
801064fa:	6a 69                	push   $0x69
  jmp alltraps
801064fc:	e9 49 f7 ff ff       	jmp    80105c4a <alltraps>

80106501 <vector106>:
.globl vector106
vector106:
  pushl $0
80106501:	6a 00                	push   $0x0
  pushl $106
80106503:	6a 6a                	push   $0x6a
  jmp alltraps
80106505:	e9 40 f7 ff ff       	jmp    80105c4a <alltraps>

8010650a <vector107>:
.globl vector107
vector107:
  pushl $0
8010650a:	6a 00                	push   $0x0
  pushl $107
8010650c:	6a 6b                	push   $0x6b
  jmp alltraps
8010650e:	e9 37 f7 ff ff       	jmp    80105c4a <alltraps>

80106513 <vector108>:
.globl vector108
vector108:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $108
80106515:	6a 6c                	push   $0x6c
  jmp alltraps
80106517:	e9 2e f7 ff ff       	jmp    80105c4a <alltraps>

8010651c <vector109>:
.globl vector109
vector109:
  pushl $0
8010651c:	6a 00                	push   $0x0
  pushl $109
8010651e:	6a 6d                	push   $0x6d
  jmp alltraps
80106520:	e9 25 f7 ff ff       	jmp    80105c4a <alltraps>

80106525 <vector110>:
.globl vector110
vector110:
  pushl $0
80106525:	6a 00                	push   $0x0
  pushl $110
80106527:	6a 6e                	push   $0x6e
  jmp alltraps
80106529:	e9 1c f7 ff ff       	jmp    80105c4a <alltraps>

8010652e <vector111>:
.globl vector111
vector111:
  pushl $0
8010652e:	6a 00                	push   $0x0
  pushl $111
80106530:	6a 6f                	push   $0x6f
  jmp alltraps
80106532:	e9 13 f7 ff ff       	jmp    80105c4a <alltraps>

80106537 <vector112>:
.globl vector112
vector112:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $112
80106539:	6a 70                	push   $0x70
  jmp alltraps
8010653b:	e9 0a f7 ff ff       	jmp    80105c4a <alltraps>

80106540 <vector113>:
.globl vector113
vector113:
  pushl $0
80106540:	6a 00                	push   $0x0
  pushl $113
80106542:	6a 71                	push   $0x71
  jmp alltraps
80106544:	e9 01 f7 ff ff       	jmp    80105c4a <alltraps>

80106549 <vector114>:
.globl vector114
vector114:
  pushl $0
80106549:	6a 00                	push   $0x0
  pushl $114
8010654b:	6a 72                	push   $0x72
  jmp alltraps
8010654d:	e9 f8 f6 ff ff       	jmp    80105c4a <alltraps>

80106552 <vector115>:
.globl vector115
vector115:
  pushl $0
80106552:	6a 00                	push   $0x0
  pushl $115
80106554:	6a 73                	push   $0x73
  jmp alltraps
80106556:	e9 ef f6 ff ff       	jmp    80105c4a <alltraps>

8010655b <vector116>:
.globl vector116
vector116:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $116
8010655d:	6a 74                	push   $0x74
  jmp alltraps
8010655f:	e9 e6 f6 ff ff       	jmp    80105c4a <alltraps>

80106564 <vector117>:
.globl vector117
vector117:
  pushl $0
80106564:	6a 00                	push   $0x0
  pushl $117
80106566:	6a 75                	push   $0x75
  jmp alltraps
80106568:	e9 dd f6 ff ff       	jmp    80105c4a <alltraps>

8010656d <vector118>:
.globl vector118
vector118:
  pushl $0
8010656d:	6a 00                	push   $0x0
  pushl $118
8010656f:	6a 76                	push   $0x76
  jmp alltraps
80106571:	e9 d4 f6 ff ff       	jmp    80105c4a <alltraps>

80106576 <vector119>:
.globl vector119
vector119:
  pushl $0
80106576:	6a 00                	push   $0x0
  pushl $119
80106578:	6a 77                	push   $0x77
  jmp alltraps
8010657a:	e9 cb f6 ff ff       	jmp    80105c4a <alltraps>

8010657f <vector120>:
.globl vector120
vector120:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $120
80106581:	6a 78                	push   $0x78
  jmp alltraps
80106583:	e9 c2 f6 ff ff       	jmp    80105c4a <alltraps>

80106588 <vector121>:
.globl vector121
vector121:
  pushl $0
80106588:	6a 00                	push   $0x0
  pushl $121
8010658a:	6a 79                	push   $0x79
  jmp alltraps
8010658c:	e9 b9 f6 ff ff       	jmp    80105c4a <alltraps>

80106591 <vector122>:
.globl vector122
vector122:
  pushl $0
80106591:	6a 00                	push   $0x0
  pushl $122
80106593:	6a 7a                	push   $0x7a
  jmp alltraps
80106595:	e9 b0 f6 ff ff       	jmp    80105c4a <alltraps>

8010659a <vector123>:
.globl vector123
vector123:
  pushl $0
8010659a:	6a 00                	push   $0x0
  pushl $123
8010659c:	6a 7b                	push   $0x7b
  jmp alltraps
8010659e:	e9 a7 f6 ff ff       	jmp    80105c4a <alltraps>

801065a3 <vector124>:
.globl vector124
vector124:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $124
801065a5:	6a 7c                	push   $0x7c
  jmp alltraps
801065a7:	e9 9e f6 ff ff       	jmp    80105c4a <alltraps>

801065ac <vector125>:
.globl vector125
vector125:
  pushl $0
801065ac:	6a 00                	push   $0x0
  pushl $125
801065ae:	6a 7d                	push   $0x7d
  jmp alltraps
801065b0:	e9 95 f6 ff ff       	jmp    80105c4a <alltraps>

801065b5 <vector126>:
.globl vector126
vector126:
  pushl $0
801065b5:	6a 00                	push   $0x0
  pushl $126
801065b7:	6a 7e                	push   $0x7e
  jmp alltraps
801065b9:	e9 8c f6 ff ff       	jmp    80105c4a <alltraps>

801065be <vector127>:
.globl vector127
vector127:
  pushl $0
801065be:	6a 00                	push   $0x0
  pushl $127
801065c0:	6a 7f                	push   $0x7f
  jmp alltraps
801065c2:	e9 83 f6 ff ff       	jmp    80105c4a <alltraps>

801065c7 <vector128>:
.globl vector128
vector128:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $128
801065c9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801065ce:	e9 77 f6 ff ff       	jmp    80105c4a <alltraps>

801065d3 <vector129>:
.globl vector129
vector129:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $129
801065d5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801065da:	e9 6b f6 ff ff       	jmp    80105c4a <alltraps>

801065df <vector130>:
.globl vector130
vector130:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $130
801065e1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801065e6:	e9 5f f6 ff ff       	jmp    80105c4a <alltraps>

801065eb <vector131>:
.globl vector131
vector131:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $131
801065ed:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801065f2:	e9 53 f6 ff ff       	jmp    80105c4a <alltraps>

801065f7 <vector132>:
.globl vector132
vector132:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $132
801065f9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801065fe:	e9 47 f6 ff ff       	jmp    80105c4a <alltraps>

80106603 <vector133>:
.globl vector133
vector133:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $133
80106605:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010660a:	e9 3b f6 ff ff       	jmp    80105c4a <alltraps>

8010660f <vector134>:
.globl vector134
vector134:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $134
80106611:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106616:	e9 2f f6 ff ff       	jmp    80105c4a <alltraps>

8010661b <vector135>:
.globl vector135
vector135:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $135
8010661d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106622:	e9 23 f6 ff ff       	jmp    80105c4a <alltraps>

80106627 <vector136>:
.globl vector136
vector136:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $136
80106629:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010662e:	e9 17 f6 ff ff       	jmp    80105c4a <alltraps>

80106633 <vector137>:
.globl vector137
vector137:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $137
80106635:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010663a:	e9 0b f6 ff ff       	jmp    80105c4a <alltraps>

8010663f <vector138>:
.globl vector138
vector138:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $138
80106641:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106646:	e9 ff f5 ff ff       	jmp    80105c4a <alltraps>

8010664b <vector139>:
.globl vector139
vector139:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $139
8010664d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106652:	e9 f3 f5 ff ff       	jmp    80105c4a <alltraps>

80106657 <vector140>:
.globl vector140
vector140:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $140
80106659:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010665e:	e9 e7 f5 ff ff       	jmp    80105c4a <alltraps>

80106663 <vector141>:
.globl vector141
vector141:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $141
80106665:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010666a:	e9 db f5 ff ff       	jmp    80105c4a <alltraps>

8010666f <vector142>:
.globl vector142
vector142:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $142
80106671:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106676:	e9 cf f5 ff ff       	jmp    80105c4a <alltraps>

8010667b <vector143>:
.globl vector143
vector143:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $143
8010667d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106682:	e9 c3 f5 ff ff       	jmp    80105c4a <alltraps>

80106687 <vector144>:
.globl vector144
vector144:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $144
80106689:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010668e:	e9 b7 f5 ff ff       	jmp    80105c4a <alltraps>

80106693 <vector145>:
.globl vector145
vector145:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $145
80106695:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010669a:	e9 ab f5 ff ff       	jmp    80105c4a <alltraps>

8010669f <vector146>:
.globl vector146
vector146:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $146
801066a1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801066a6:	e9 9f f5 ff ff       	jmp    80105c4a <alltraps>

801066ab <vector147>:
.globl vector147
vector147:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $147
801066ad:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801066b2:	e9 93 f5 ff ff       	jmp    80105c4a <alltraps>

801066b7 <vector148>:
.globl vector148
vector148:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $148
801066b9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801066be:	e9 87 f5 ff ff       	jmp    80105c4a <alltraps>

801066c3 <vector149>:
.globl vector149
vector149:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $149
801066c5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801066ca:	e9 7b f5 ff ff       	jmp    80105c4a <alltraps>

801066cf <vector150>:
.globl vector150
vector150:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $150
801066d1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801066d6:	e9 6f f5 ff ff       	jmp    80105c4a <alltraps>

801066db <vector151>:
.globl vector151
vector151:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $151
801066dd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801066e2:	e9 63 f5 ff ff       	jmp    80105c4a <alltraps>

801066e7 <vector152>:
.globl vector152
vector152:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $152
801066e9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801066ee:	e9 57 f5 ff ff       	jmp    80105c4a <alltraps>

801066f3 <vector153>:
.globl vector153
vector153:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $153
801066f5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801066fa:	e9 4b f5 ff ff       	jmp    80105c4a <alltraps>

801066ff <vector154>:
.globl vector154
vector154:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $154
80106701:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106706:	e9 3f f5 ff ff       	jmp    80105c4a <alltraps>

8010670b <vector155>:
.globl vector155
vector155:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $155
8010670d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106712:	e9 33 f5 ff ff       	jmp    80105c4a <alltraps>

80106717 <vector156>:
.globl vector156
vector156:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $156
80106719:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010671e:	e9 27 f5 ff ff       	jmp    80105c4a <alltraps>

80106723 <vector157>:
.globl vector157
vector157:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $157
80106725:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010672a:	e9 1b f5 ff ff       	jmp    80105c4a <alltraps>

8010672f <vector158>:
.globl vector158
vector158:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $158
80106731:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106736:	e9 0f f5 ff ff       	jmp    80105c4a <alltraps>

8010673b <vector159>:
.globl vector159
vector159:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $159
8010673d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106742:	e9 03 f5 ff ff       	jmp    80105c4a <alltraps>

80106747 <vector160>:
.globl vector160
vector160:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $160
80106749:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010674e:	e9 f7 f4 ff ff       	jmp    80105c4a <alltraps>

80106753 <vector161>:
.globl vector161
vector161:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $161
80106755:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010675a:	e9 eb f4 ff ff       	jmp    80105c4a <alltraps>

8010675f <vector162>:
.globl vector162
vector162:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $162
80106761:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106766:	e9 df f4 ff ff       	jmp    80105c4a <alltraps>

8010676b <vector163>:
.globl vector163
vector163:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $163
8010676d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106772:	e9 d3 f4 ff ff       	jmp    80105c4a <alltraps>

80106777 <vector164>:
.globl vector164
vector164:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $164
80106779:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010677e:	e9 c7 f4 ff ff       	jmp    80105c4a <alltraps>

80106783 <vector165>:
.globl vector165
vector165:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $165
80106785:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010678a:	e9 bb f4 ff ff       	jmp    80105c4a <alltraps>

8010678f <vector166>:
.globl vector166
vector166:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $166
80106791:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106796:	e9 af f4 ff ff       	jmp    80105c4a <alltraps>

8010679b <vector167>:
.globl vector167
vector167:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $167
8010679d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801067a2:	e9 a3 f4 ff ff       	jmp    80105c4a <alltraps>

801067a7 <vector168>:
.globl vector168
vector168:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $168
801067a9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801067ae:	e9 97 f4 ff ff       	jmp    80105c4a <alltraps>

801067b3 <vector169>:
.globl vector169
vector169:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $169
801067b5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801067ba:	e9 8b f4 ff ff       	jmp    80105c4a <alltraps>

801067bf <vector170>:
.globl vector170
vector170:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $170
801067c1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801067c6:	e9 7f f4 ff ff       	jmp    80105c4a <alltraps>

801067cb <vector171>:
.globl vector171
vector171:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $171
801067cd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801067d2:	e9 73 f4 ff ff       	jmp    80105c4a <alltraps>

801067d7 <vector172>:
.globl vector172
vector172:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $172
801067d9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801067de:	e9 67 f4 ff ff       	jmp    80105c4a <alltraps>

801067e3 <vector173>:
.globl vector173
vector173:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $173
801067e5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801067ea:	e9 5b f4 ff ff       	jmp    80105c4a <alltraps>

801067ef <vector174>:
.globl vector174
vector174:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $174
801067f1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801067f6:	e9 4f f4 ff ff       	jmp    80105c4a <alltraps>

801067fb <vector175>:
.globl vector175
vector175:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $175
801067fd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106802:	e9 43 f4 ff ff       	jmp    80105c4a <alltraps>

80106807 <vector176>:
.globl vector176
vector176:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $176
80106809:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010680e:	e9 37 f4 ff ff       	jmp    80105c4a <alltraps>

80106813 <vector177>:
.globl vector177
vector177:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $177
80106815:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010681a:	e9 2b f4 ff ff       	jmp    80105c4a <alltraps>

8010681f <vector178>:
.globl vector178
vector178:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $178
80106821:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106826:	e9 1f f4 ff ff       	jmp    80105c4a <alltraps>

8010682b <vector179>:
.globl vector179
vector179:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $179
8010682d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106832:	e9 13 f4 ff ff       	jmp    80105c4a <alltraps>

80106837 <vector180>:
.globl vector180
vector180:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $180
80106839:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010683e:	e9 07 f4 ff ff       	jmp    80105c4a <alltraps>

80106843 <vector181>:
.globl vector181
vector181:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $181
80106845:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010684a:	e9 fb f3 ff ff       	jmp    80105c4a <alltraps>

8010684f <vector182>:
.globl vector182
vector182:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $182
80106851:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106856:	e9 ef f3 ff ff       	jmp    80105c4a <alltraps>

8010685b <vector183>:
.globl vector183
vector183:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $183
8010685d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106862:	e9 e3 f3 ff ff       	jmp    80105c4a <alltraps>

80106867 <vector184>:
.globl vector184
vector184:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $184
80106869:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010686e:	e9 d7 f3 ff ff       	jmp    80105c4a <alltraps>

80106873 <vector185>:
.globl vector185
vector185:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $185
80106875:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010687a:	e9 cb f3 ff ff       	jmp    80105c4a <alltraps>

8010687f <vector186>:
.globl vector186
vector186:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $186
80106881:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106886:	e9 bf f3 ff ff       	jmp    80105c4a <alltraps>

8010688b <vector187>:
.globl vector187
vector187:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $187
8010688d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106892:	e9 b3 f3 ff ff       	jmp    80105c4a <alltraps>

80106897 <vector188>:
.globl vector188
vector188:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $188
80106899:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010689e:	e9 a7 f3 ff ff       	jmp    80105c4a <alltraps>

801068a3 <vector189>:
.globl vector189
vector189:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $189
801068a5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801068aa:	e9 9b f3 ff ff       	jmp    80105c4a <alltraps>

801068af <vector190>:
.globl vector190
vector190:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $190
801068b1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801068b6:	e9 8f f3 ff ff       	jmp    80105c4a <alltraps>

801068bb <vector191>:
.globl vector191
vector191:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $191
801068bd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801068c2:	e9 83 f3 ff ff       	jmp    80105c4a <alltraps>

801068c7 <vector192>:
.globl vector192
vector192:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $192
801068c9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801068ce:	e9 77 f3 ff ff       	jmp    80105c4a <alltraps>

801068d3 <vector193>:
.globl vector193
vector193:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $193
801068d5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801068da:	e9 6b f3 ff ff       	jmp    80105c4a <alltraps>

801068df <vector194>:
.globl vector194
vector194:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $194
801068e1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801068e6:	e9 5f f3 ff ff       	jmp    80105c4a <alltraps>

801068eb <vector195>:
.globl vector195
vector195:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $195
801068ed:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801068f2:	e9 53 f3 ff ff       	jmp    80105c4a <alltraps>

801068f7 <vector196>:
.globl vector196
vector196:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $196
801068f9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801068fe:	e9 47 f3 ff ff       	jmp    80105c4a <alltraps>

80106903 <vector197>:
.globl vector197
vector197:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $197
80106905:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010690a:	e9 3b f3 ff ff       	jmp    80105c4a <alltraps>

8010690f <vector198>:
.globl vector198
vector198:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $198
80106911:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106916:	e9 2f f3 ff ff       	jmp    80105c4a <alltraps>

8010691b <vector199>:
.globl vector199
vector199:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $199
8010691d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106922:	e9 23 f3 ff ff       	jmp    80105c4a <alltraps>

80106927 <vector200>:
.globl vector200
vector200:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $200
80106929:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010692e:	e9 17 f3 ff ff       	jmp    80105c4a <alltraps>

80106933 <vector201>:
.globl vector201
vector201:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $201
80106935:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010693a:	e9 0b f3 ff ff       	jmp    80105c4a <alltraps>

8010693f <vector202>:
.globl vector202
vector202:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $202
80106941:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106946:	e9 ff f2 ff ff       	jmp    80105c4a <alltraps>

8010694b <vector203>:
.globl vector203
vector203:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $203
8010694d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106952:	e9 f3 f2 ff ff       	jmp    80105c4a <alltraps>

80106957 <vector204>:
.globl vector204
vector204:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $204
80106959:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010695e:	e9 e7 f2 ff ff       	jmp    80105c4a <alltraps>

80106963 <vector205>:
.globl vector205
vector205:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $205
80106965:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010696a:	e9 db f2 ff ff       	jmp    80105c4a <alltraps>

8010696f <vector206>:
.globl vector206
vector206:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $206
80106971:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106976:	e9 cf f2 ff ff       	jmp    80105c4a <alltraps>

8010697b <vector207>:
.globl vector207
vector207:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $207
8010697d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106982:	e9 c3 f2 ff ff       	jmp    80105c4a <alltraps>

80106987 <vector208>:
.globl vector208
vector208:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $208
80106989:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010698e:	e9 b7 f2 ff ff       	jmp    80105c4a <alltraps>

80106993 <vector209>:
.globl vector209
vector209:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $209
80106995:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010699a:	e9 ab f2 ff ff       	jmp    80105c4a <alltraps>

8010699f <vector210>:
.globl vector210
vector210:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $210
801069a1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801069a6:	e9 9f f2 ff ff       	jmp    80105c4a <alltraps>

801069ab <vector211>:
.globl vector211
vector211:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $211
801069ad:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801069b2:	e9 93 f2 ff ff       	jmp    80105c4a <alltraps>

801069b7 <vector212>:
.globl vector212
vector212:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $212
801069b9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801069be:	e9 87 f2 ff ff       	jmp    80105c4a <alltraps>

801069c3 <vector213>:
.globl vector213
vector213:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $213
801069c5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801069ca:	e9 7b f2 ff ff       	jmp    80105c4a <alltraps>

801069cf <vector214>:
.globl vector214
vector214:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $214
801069d1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801069d6:	e9 6f f2 ff ff       	jmp    80105c4a <alltraps>

801069db <vector215>:
.globl vector215
vector215:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $215
801069dd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801069e2:	e9 63 f2 ff ff       	jmp    80105c4a <alltraps>

801069e7 <vector216>:
.globl vector216
vector216:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $216
801069e9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801069ee:	e9 57 f2 ff ff       	jmp    80105c4a <alltraps>

801069f3 <vector217>:
.globl vector217
vector217:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $217
801069f5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801069fa:	e9 4b f2 ff ff       	jmp    80105c4a <alltraps>

801069ff <vector218>:
.globl vector218
vector218:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $218
80106a01:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106a06:	e9 3f f2 ff ff       	jmp    80105c4a <alltraps>

80106a0b <vector219>:
.globl vector219
vector219:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $219
80106a0d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106a12:	e9 33 f2 ff ff       	jmp    80105c4a <alltraps>

80106a17 <vector220>:
.globl vector220
vector220:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $220
80106a19:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106a1e:	e9 27 f2 ff ff       	jmp    80105c4a <alltraps>

80106a23 <vector221>:
.globl vector221
vector221:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $221
80106a25:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106a2a:	e9 1b f2 ff ff       	jmp    80105c4a <alltraps>

80106a2f <vector222>:
.globl vector222
vector222:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $222
80106a31:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106a36:	e9 0f f2 ff ff       	jmp    80105c4a <alltraps>

80106a3b <vector223>:
.globl vector223
vector223:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $223
80106a3d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106a42:	e9 03 f2 ff ff       	jmp    80105c4a <alltraps>

80106a47 <vector224>:
.globl vector224
vector224:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $224
80106a49:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106a4e:	e9 f7 f1 ff ff       	jmp    80105c4a <alltraps>

80106a53 <vector225>:
.globl vector225
vector225:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $225
80106a55:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106a5a:	e9 eb f1 ff ff       	jmp    80105c4a <alltraps>

80106a5f <vector226>:
.globl vector226
vector226:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $226
80106a61:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106a66:	e9 df f1 ff ff       	jmp    80105c4a <alltraps>

80106a6b <vector227>:
.globl vector227
vector227:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $227
80106a6d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106a72:	e9 d3 f1 ff ff       	jmp    80105c4a <alltraps>

80106a77 <vector228>:
.globl vector228
vector228:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $228
80106a79:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106a7e:	e9 c7 f1 ff ff       	jmp    80105c4a <alltraps>

80106a83 <vector229>:
.globl vector229
vector229:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $229
80106a85:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106a8a:	e9 bb f1 ff ff       	jmp    80105c4a <alltraps>

80106a8f <vector230>:
.globl vector230
vector230:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $230
80106a91:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106a96:	e9 af f1 ff ff       	jmp    80105c4a <alltraps>

80106a9b <vector231>:
.globl vector231
vector231:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $231
80106a9d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106aa2:	e9 a3 f1 ff ff       	jmp    80105c4a <alltraps>

80106aa7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $232
80106aa9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106aae:	e9 97 f1 ff ff       	jmp    80105c4a <alltraps>

80106ab3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $233
80106ab5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106aba:	e9 8b f1 ff ff       	jmp    80105c4a <alltraps>

80106abf <vector234>:
.globl vector234
vector234:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $234
80106ac1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106ac6:	e9 7f f1 ff ff       	jmp    80105c4a <alltraps>

80106acb <vector235>:
.globl vector235
vector235:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $235
80106acd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106ad2:	e9 73 f1 ff ff       	jmp    80105c4a <alltraps>

80106ad7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $236
80106ad9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106ade:	e9 67 f1 ff ff       	jmp    80105c4a <alltraps>

80106ae3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $237
80106ae5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106aea:	e9 5b f1 ff ff       	jmp    80105c4a <alltraps>

80106aef <vector238>:
.globl vector238
vector238:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $238
80106af1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106af6:	e9 4f f1 ff ff       	jmp    80105c4a <alltraps>

80106afb <vector239>:
.globl vector239
vector239:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $239
80106afd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106b02:	e9 43 f1 ff ff       	jmp    80105c4a <alltraps>

80106b07 <vector240>:
.globl vector240
vector240:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $240
80106b09:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106b0e:	e9 37 f1 ff ff       	jmp    80105c4a <alltraps>

80106b13 <vector241>:
.globl vector241
vector241:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $241
80106b15:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106b1a:	e9 2b f1 ff ff       	jmp    80105c4a <alltraps>

80106b1f <vector242>:
.globl vector242
vector242:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $242
80106b21:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106b26:	e9 1f f1 ff ff       	jmp    80105c4a <alltraps>

80106b2b <vector243>:
.globl vector243
vector243:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $243
80106b2d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106b32:	e9 13 f1 ff ff       	jmp    80105c4a <alltraps>

80106b37 <vector244>:
.globl vector244
vector244:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $244
80106b39:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106b3e:	e9 07 f1 ff ff       	jmp    80105c4a <alltraps>

80106b43 <vector245>:
.globl vector245
vector245:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $245
80106b45:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106b4a:	e9 fb f0 ff ff       	jmp    80105c4a <alltraps>

80106b4f <vector246>:
.globl vector246
vector246:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $246
80106b51:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106b56:	e9 ef f0 ff ff       	jmp    80105c4a <alltraps>

80106b5b <vector247>:
.globl vector247
vector247:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $247
80106b5d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106b62:	e9 e3 f0 ff ff       	jmp    80105c4a <alltraps>

80106b67 <vector248>:
.globl vector248
vector248:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $248
80106b69:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106b6e:	e9 d7 f0 ff ff       	jmp    80105c4a <alltraps>

80106b73 <vector249>:
.globl vector249
vector249:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $249
80106b75:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106b7a:	e9 cb f0 ff ff       	jmp    80105c4a <alltraps>

80106b7f <vector250>:
.globl vector250
vector250:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $250
80106b81:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106b86:	e9 bf f0 ff ff       	jmp    80105c4a <alltraps>

80106b8b <vector251>:
.globl vector251
vector251:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $251
80106b8d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106b92:	e9 b3 f0 ff ff       	jmp    80105c4a <alltraps>

80106b97 <vector252>:
.globl vector252
vector252:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $252
80106b99:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106b9e:	e9 a7 f0 ff ff       	jmp    80105c4a <alltraps>

80106ba3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $253
80106ba5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106baa:	e9 9b f0 ff ff       	jmp    80105c4a <alltraps>

80106baf <vector254>:
.globl vector254
vector254:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $254
80106bb1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106bb6:	e9 8f f0 ff ff       	jmp    80105c4a <alltraps>

80106bbb <vector255>:
.globl vector255
vector255:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $255
80106bbd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106bc2:	e9 83 f0 ff ff       	jmp    80105c4a <alltraps>
80106bc7:	66 90                	xchg   %ax,%ax
80106bc9:	66 90                	xchg   %ax,%ax
80106bcb:	66 90                	xchg   %ax,%ax
80106bcd:	66 90                	xchg   %ax,%ax
80106bcf:	90                   	nop

80106bd0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106bd0:	55                   	push   %ebp
80106bd1:	89 e5                	mov    %esp,%ebp
80106bd3:	57                   	push   %edi
80106bd4:	56                   	push   %esi
80106bd5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106bd6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106bdc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106be2:	83 ec 1c             	sub    $0x1c,%esp
80106be5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106be8:	39 d3                	cmp    %edx,%ebx
80106bea:	73 49                	jae    80106c35 <deallocuvm.part.0+0x65>
80106bec:	89 c7                	mov    %eax,%edi
80106bee:	eb 0c                	jmp    80106bfc <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106bf0:	83 c0 01             	add    $0x1,%eax
80106bf3:	c1 e0 16             	shl    $0x16,%eax
80106bf6:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106bf8:	39 da                	cmp    %ebx,%edx
80106bfa:	76 39                	jbe    80106c35 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
80106bfc:	89 d8                	mov    %ebx,%eax
80106bfe:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106c01:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106c04:	f6 c1 01             	test   $0x1,%cl
80106c07:	74 e7                	je     80106bf0 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106c09:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106c0b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106c11:	c1 ee 0a             	shr    $0xa,%esi
80106c14:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106c1a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80106c21:	85 f6                	test   %esi,%esi
80106c23:	74 cb                	je     80106bf0 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106c25:	8b 06                	mov    (%esi),%eax
80106c27:	a8 01                	test   $0x1,%al
80106c29:	75 15                	jne    80106c40 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106c2b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c31:	39 da                	cmp    %ebx,%edx
80106c33:	77 c7                	ja     80106bfc <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106c35:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c3b:	5b                   	pop    %ebx
80106c3c:	5e                   	pop    %esi
80106c3d:	5f                   	pop    %edi
80106c3e:	5d                   	pop    %ebp
80106c3f:	c3                   	ret    
      if(pa == 0)
80106c40:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c45:	74 25                	je     80106c6c <deallocuvm.part.0+0x9c>
      kfree(v);
80106c47:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106c4a:	05 00 00 00 80       	add    $0x80000000,%eax
80106c4f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106c52:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106c58:	50                   	push   %eax
80106c59:	e8 22 ba ff ff       	call   80102680 <kfree>
      *pte = 0;
80106c5e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106c64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106c67:	83 c4 10             	add    $0x10,%esp
80106c6a:	eb 8c                	jmp    80106bf8 <deallocuvm.part.0+0x28>
        panic("kfree");
80106c6c:	83 ec 0c             	sub    $0xc,%esp
80106c6f:	68 66 79 10 80       	push   $0x80107966
80106c74:	e8 07 97 ff ff       	call   80100380 <panic>
80106c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c80 <mappages>:
{
80106c80:	55                   	push   %ebp
80106c81:	89 e5                	mov    %esp,%ebp
80106c83:	57                   	push   %edi
80106c84:	56                   	push   %esi
80106c85:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106c86:	89 d3                	mov    %edx,%ebx
80106c88:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106c8e:	83 ec 1c             	sub    $0x1c,%esp
80106c91:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106c94:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106c98:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c9d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106ca0:	8b 45 08             	mov    0x8(%ebp),%eax
80106ca3:	29 d8                	sub    %ebx,%eax
80106ca5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106ca8:	eb 3d                	jmp    80106ce7 <mappages+0x67>
80106caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106cb0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106cb2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106cb7:	c1 ea 0a             	shr    $0xa,%edx
80106cba:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106cc0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106cc7:	85 c0                	test   %eax,%eax
80106cc9:	74 75                	je     80106d40 <mappages+0xc0>
    if(*pte & PTE_P)
80106ccb:	f6 00 01             	testb  $0x1,(%eax)
80106cce:	0f 85 86 00 00 00    	jne    80106d5a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106cd4:	0b 75 0c             	or     0xc(%ebp),%esi
80106cd7:	83 ce 01             	or     $0x1,%esi
80106cda:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106cdc:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106cdf:	74 6f                	je     80106d50 <mappages+0xd0>
    a += PGSIZE;
80106ce1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106ce7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106cea:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106ced:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106cf0:	89 d8                	mov    %ebx,%eax
80106cf2:	c1 e8 16             	shr    $0x16,%eax
80106cf5:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106cf8:	8b 07                	mov    (%edi),%eax
80106cfa:	a8 01                	test   $0x1,%al
80106cfc:	75 b2                	jne    80106cb0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106cfe:	e8 2d bc ff ff       	call   80102930 <kalloc>
80106d03:	85 c0                	test   %eax,%eax
80106d05:	74 39                	je     80106d40 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106d07:	83 ec 04             	sub    $0x4,%esp
80106d0a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106d0d:	68 00 10 00 00       	push   $0x1000
80106d12:	6a 00                	push   $0x0
80106d14:	50                   	push   %eax
80106d15:	e8 36 dd ff ff       	call   80104a50 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106d1a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106d1d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106d20:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106d26:	83 c8 07             	or     $0x7,%eax
80106d29:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106d2b:	89 d8                	mov    %ebx,%eax
80106d2d:	c1 e8 0a             	shr    $0xa,%eax
80106d30:	25 fc 0f 00 00       	and    $0xffc,%eax
80106d35:	01 d0                	add    %edx,%eax
80106d37:	eb 92                	jmp    80106ccb <mappages+0x4b>
80106d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106d40:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106d43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d48:	5b                   	pop    %ebx
80106d49:	5e                   	pop    %esi
80106d4a:	5f                   	pop    %edi
80106d4b:	5d                   	pop    %ebp
80106d4c:	c3                   	ret    
80106d4d:	8d 76 00             	lea    0x0(%esi),%esi
80106d50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106d53:	31 c0                	xor    %eax,%eax
}
80106d55:	5b                   	pop    %ebx
80106d56:	5e                   	pop    %esi
80106d57:	5f                   	pop    %edi
80106d58:	5d                   	pop    %ebp
80106d59:	c3                   	ret    
      panic("remap");
80106d5a:	83 ec 0c             	sub    $0xc,%esp
80106d5d:	68 58 80 10 80       	push   $0x80108058
80106d62:	e8 19 96 ff ff       	call   80100380 <panic>
80106d67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d6e:	66 90                	xchg   %ax,%ax

80106d70 <seginit>:
{
80106d70:	55                   	push   %ebp
80106d71:	89 e5                	mov    %esp,%ebp
80106d73:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106d76:	e8 15 cf ff ff       	call   80103c90 <cpuid>
  pd[0] = size-1;
80106d7b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106d80:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106d86:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106d8a:	c7 80 38 38 11 80 ff 	movl   $0xffff,-0x7feec7c8(%eax)
80106d91:	ff 00 00 
80106d94:	c7 80 3c 38 11 80 00 	movl   $0xcf9a00,-0x7feec7c4(%eax)
80106d9b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106d9e:	c7 80 40 38 11 80 ff 	movl   $0xffff,-0x7feec7c0(%eax)
80106da5:	ff 00 00 
80106da8:	c7 80 44 38 11 80 00 	movl   $0xcf9200,-0x7feec7bc(%eax)
80106daf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106db2:	c7 80 48 38 11 80 ff 	movl   $0xffff,-0x7feec7b8(%eax)
80106db9:	ff 00 00 
80106dbc:	c7 80 4c 38 11 80 00 	movl   $0xcffa00,-0x7feec7b4(%eax)
80106dc3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106dc6:	c7 80 50 38 11 80 ff 	movl   $0xffff,-0x7feec7b0(%eax)
80106dcd:	ff 00 00 
80106dd0:	c7 80 54 38 11 80 00 	movl   $0xcff200,-0x7feec7ac(%eax)
80106dd7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106dda:	05 30 38 11 80       	add    $0x80113830,%eax
  pd[1] = (uint)p;
80106ddf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106de3:	c1 e8 10             	shr    $0x10,%eax
80106de6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106dea:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106ded:	0f 01 10             	lgdtl  (%eax)
}
80106df0:	c9                   	leave  
80106df1:	c3                   	ret    
80106df2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e00 <walkpgdir>:
{
80106e00:	55                   	push   %ebp
80106e01:	89 e5                	mov    %esp,%ebp
80106e03:	57                   	push   %edi
80106e04:	56                   	push   %esi
80106e05:	53                   	push   %ebx
80106e06:	83 ec 0c             	sub    $0xc,%esp
80106e09:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pde = &pgdir[PDX(va)];
80106e0c:	8b 55 08             	mov    0x8(%ebp),%edx
80106e0f:	89 fe                	mov    %edi,%esi
80106e11:	c1 ee 16             	shr    $0x16,%esi
80106e14:	8d 34 b2             	lea    (%edx,%esi,4),%esi
  if(*pde & PTE_P){
80106e17:	8b 1e                	mov    (%esi),%ebx
80106e19:	f6 c3 01             	test   $0x1,%bl
80106e1c:	74 22                	je     80106e40 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106e1e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106e24:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
  return &pgtab[PTX(va)];
80106e2a:	89 f8                	mov    %edi,%eax
}
80106e2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106e2f:	c1 e8 0a             	shr    $0xa,%eax
80106e32:	25 fc 0f 00 00       	and    $0xffc,%eax
80106e37:	01 d8                	add    %ebx,%eax
}
80106e39:	5b                   	pop    %ebx
80106e3a:	5e                   	pop    %esi
80106e3b:	5f                   	pop    %edi
80106e3c:	5d                   	pop    %ebp
80106e3d:	c3                   	ret    
80106e3e:	66 90                	xchg   %ax,%ax
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106e40:	8b 45 10             	mov    0x10(%ebp),%eax
80106e43:	85 c0                	test   %eax,%eax
80106e45:	74 31                	je     80106e78 <walkpgdir+0x78>
80106e47:	e8 e4 ba ff ff       	call   80102930 <kalloc>
80106e4c:	89 c3                	mov    %eax,%ebx
80106e4e:	85 c0                	test   %eax,%eax
80106e50:	74 26                	je     80106e78 <walkpgdir+0x78>
    memset(pgtab, 0, PGSIZE);
80106e52:	83 ec 04             	sub    $0x4,%esp
80106e55:	68 00 10 00 00       	push   $0x1000
80106e5a:	6a 00                	push   $0x0
80106e5c:	50                   	push   %eax
80106e5d:	e8 ee db ff ff       	call   80104a50 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106e62:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e68:	83 c4 10             	add    $0x10,%esp
80106e6b:	83 c8 07             	or     $0x7,%eax
80106e6e:	89 06                	mov    %eax,(%esi)
80106e70:	eb b8                	jmp    80106e2a <walkpgdir+0x2a>
80106e72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80106e78:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106e7b:	31 c0                	xor    %eax,%eax
}
80106e7d:	5b                   	pop    %ebx
80106e7e:	5e                   	pop    %esi
80106e7f:	5f                   	pop    %edi
80106e80:	5d                   	pop    %ebp
80106e81:	c3                   	ret    
80106e82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e90 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106e90:	a1 e4 65 11 80       	mov    0x801165e4,%eax
80106e95:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106e9a:	0f 22 d8             	mov    %eax,%cr3
}
80106e9d:	c3                   	ret    
80106e9e:	66 90                	xchg   %ax,%ax

80106ea0 <switchuvm>:
{
80106ea0:	55                   	push   %ebp
80106ea1:	89 e5                	mov    %esp,%ebp
80106ea3:	57                   	push   %edi
80106ea4:	56                   	push   %esi
80106ea5:	53                   	push   %ebx
80106ea6:	83 ec 1c             	sub    $0x1c,%esp
80106ea9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106eac:	85 f6                	test   %esi,%esi
80106eae:	0f 84 cb 00 00 00    	je     80106f7f <switchuvm+0xdf>
  if(p->kstack == 0)
80106eb4:	8b 46 0c             	mov    0xc(%esi),%eax
80106eb7:	85 c0                	test   %eax,%eax
80106eb9:	0f 84 da 00 00 00    	je     80106f99 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106ebf:	8b 46 08             	mov    0x8(%esi),%eax
80106ec2:	85 c0                	test   %eax,%eax
80106ec4:	0f 84 c2 00 00 00    	je     80106f8c <switchuvm+0xec>
  pushcli();
80106eca:	e8 71 d9 ff ff       	call   80104840 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106ecf:	e8 5c cd ff ff       	call   80103c30 <mycpu>
80106ed4:	89 c3                	mov    %eax,%ebx
80106ed6:	e8 55 cd ff ff       	call   80103c30 <mycpu>
80106edb:	89 c7                	mov    %eax,%edi
80106edd:	e8 4e cd ff ff       	call   80103c30 <mycpu>
80106ee2:	83 c7 08             	add    $0x8,%edi
80106ee5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ee8:	e8 43 cd ff ff       	call   80103c30 <mycpu>
80106eed:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106ef0:	ba 67 00 00 00       	mov    $0x67,%edx
80106ef5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106efc:	83 c0 08             	add    $0x8,%eax
80106eff:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f06:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f0b:	83 c1 08             	add    $0x8,%ecx
80106f0e:	c1 e8 18             	shr    $0x18,%eax
80106f11:	c1 e9 10             	shr    $0x10,%ecx
80106f14:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106f1a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106f20:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106f25:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f2c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106f31:	e8 fa cc ff ff       	call   80103c30 <mycpu>
80106f36:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f3d:	e8 ee cc ff ff       	call   80103c30 <mycpu>
80106f42:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106f46:	8b 5e 0c             	mov    0xc(%esi),%ebx
80106f49:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f4f:	e8 dc cc ff ff       	call   80103c30 <mycpu>
80106f54:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f57:	e8 d4 cc ff ff       	call   80103c30 <mycpu>
80106f5c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106f60:	b8 28 00 00 00       	mov    $0x28,%eax
80106f65:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106f68:	8b 46 08             	mov    0x8(%esi),%eax
80106f6b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106f70:	0f 22 d8             	mov    %eax,%cr3
}
80106f73:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f76:	5b                   	pop    %ebx
80106f77:	5e                   	pop    %esi
80106f78:	5f                   	pop    %edi
80106f79:	5d                   	pop    %ebp
  popcli();
80106f7a:	e9 11 d9 ff ff       	jmp    80104890 <popcli>
    panic("switchuvm: no process");
80106f7f:	83 ec 0c             	sub    $0xc,%esp
80106f82:	68 5e 80 10 80       	push   $0x8010805e
80106f87:	e8 f4 93 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106f8c:	83 ec 0c             	sub    $0xc,%esp
80106f8f:	68 89 80 10 80       	push   $0x80108089
80106f94:	e8 e7 93 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106f99:	83 ec 0c             	sub    $0xc,%esp
80106f9c:	68 74 80 10 80       	push   $0x80108074
80106fa1:	e8 da 93 ff ff       	call   80100380 <panic>
80106fa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fad:	8d 76 00             	lea    0x0(%esi),%esi

80106fb0 <inituvm>:
{
80106fb0:	55                   	push   %ebp
80106fb1:	89 e5                	mov    %esp,%ebp
80106fb3:	57                   	push   %edi
80106fb4:	56                   	push   %esi
80106fb5:	53                   	push   %ebx
80106fb6:	83 ec 1c             	sub    $0x1c,%esp
80106fb9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fbc:	8b 75 10             	mov    0x10(%ebp),%esi
80106fbf:	8b 7d 08             	mov    0x8(%ebp),%edi
80106fc2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106fc5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106fcb:	77 4b                	ja     80107018 <inituvm+0x68>
  mem = kalloc();
80106fcd:	e8 5e b9 ff ff       	call   80102930 <kalloc>
  memset(mem, 0, PGSIZE);
80106fd2:	83 ec 04             	sub    $0x4,%esp
80106fd5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106fda:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106fdc:	6a 00                	push   $0x0
80106fde:	50                   	push   %eax
80106fdf:	e8 6c da ff ff       	call   80104a50 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106fe4:	58                   	pop    %eax
80106fe5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106feb:	5a                   	pop    %edx
80106fec:	6a 06                	push   $0x6
80106fee:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ff3:	31 d2                	xor    %edx,%edx
80106ff5:	50                   	push   %eax
80106ff6:	89 f8                	mov    %edi,%eax
80106ff8:	e8 83 fc ff ff       	call   80106c80 <mappages>
  memmove(mem, init, sz);
80106ffd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107000:	89 75 10             	mov    %esi,0x10(%ebp)
80107003:	83 c4 10             	add    $0x10,%esp
80107006:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107009:	89 45 0c             	mov    %eax,0xc(%ebp)
}
8010700c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010700f:	5b                   	pop    %ebx
80107010:	5e                   	pop    %esi
80107011:	5f                   	pop    %edi
80107012:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107013:	e9 d8 da ff ff       	jmp    80104af0 <memmove>
    panic("inituvm: more than a page");
80107018:	83 ec 0c             	sub    $0xc,%esp
8010701b:	68 9d 80 10 80       	push   $0x8010809d
80107020:	e8 5b 93 ff ff       	call   80100380 <panic>
80107025:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010702c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107030 <loaduvm>:
{
80107030:	55                   	push   %ebp
80107031:	89 e5                	mov    %esp,%ebp
80107033:	57                   	push   %edi
80107034:	56                   	push   %esi
80107035:	53                   	push   %ebx
80107036:	83 ec 1c             	sub    $0x1c,%esp
80107039:	8b 45 0c             	mov    0xc(%ebp),%eax
8010703c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
8010703f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107044:	0f 85 bb 00 00 00    	jne    80107105 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
8010704a:	01 f0                	add    %esi,%eax
8010704c:	89 f3                	mov    %esi,%ebx
8010704e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107051:	8b 45 14             	mov    0x14(%ebp),%eax
80107054:	01 f0                	add    %esi,%eax
80107056:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107059:	85 f6                	test   %esi,%esi
8010705b:	0f 84 87 00 00 00    	je     801070e8 <loaduvm+0xb8>
80107061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107068:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
8010706b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010706e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107070:	89 c2                	mov    %eax,%edx
80107072:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107075:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107078:	f6 c2 01             	test   $0x1,%dl
8010707b:	75 13                	jne    80107090 <loaduvm+0x60>
      panic("loaduvm: address should exist");
8010707d:	83 ec 0c             	sub    $0xc,%esp
80107080:	68 b7 80 10 80       	push   $0x801080b7
80107085:	e8 f6 92 ff ff       	call   80100380 <panic>
8010708a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107090:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107093:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107099:	25 fc 0f 00 00       	and    $0xffc,%eax
8010709e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801070a5:	85 c0                	test   %eax,%eax
801070a7:	74 d4                	je     8010707d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
801070a9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801070ab:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
801070ae:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801070b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801070b8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801070be:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801070c1:	29 d9                	sub    %ebx,%ecx
801070c3:	05 00 00 00 80       	add    $0x80000000,%eax
801070c8:	57                   	push   %edi
801070c9:	51                   	push   %ecx
801070ca:	50                   	push   %eax
801070cb:	ff 75 10             	push   0x10(%ebp)
801070ce:	e8 bd a9 ff ff       	call   80101a90 <readi>
801070d3:	83 c4 10             	add    $0x10,%esp
801070d6:	39 f8                	cmp    %edi,%eax
801070d8:	75 1e                	jne    801070f8 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801070da:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801070e0:	89 f0                	mov    %esi,%eax
801070e2:	29 d8                	sub    %ebx,%eax
801070e4:	39 c6                	cmp    %eax,%esi
801070e6:	77 80                	ja     80107068 <loaduvm+0x38>
}
801070e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801070eb:	31 c0                	xor    %eax,%eax
}
801070ed:	5b                   	pop    %ebx
801070ee:	5e                   	pop    %esi
801070ef:	5f                   	pop    %edi
801070f0:	5d                   	pop    %ebp
801070f1:	c3                   	ret    
801070f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801070f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801070fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107100:	5b                   	pop    %ebx
80107101:	5e                   	pop    %esi
80107102:	5f                   	pop    %edi
80107103:	5d                   	pop    %ebp
80107104:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80107105:	83 ec 0c             	sub    $0xc,%esp
80107108:	68 58 81 10 80       	push   $0x80108158
8010710d:	e8 6e 92 ff ff       	call   80100380 <panic>
80107112:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107120 <allocuvm>:
{
80107120:	55                   	push   %ebp
80107121:	89 e5                	mov    %esp,%ebp
80107123:	57                   	push   %edi
80107124:	56                   	push   %esi
80107125:	53                   	push   %ebx
80107126:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107129:	8b 45 10             	mov    0x10(%ebp),%eax
{
8010712c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
8010712f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107132:	85 c0                	test   %eax,%eax
80107134:	0f 88 b6 00 00 00    	js     801071f0 <allocuvm+0xd0>
  if(newsz < oldsz)
8010713a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
8010713d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107140:	0f 82 9a 00 00 00    	jb     801071e0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107146:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
8010714c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107152:	39 75 10             	cmp    %esi,0x10(%ebp)
80107155:	77 44                	ja     8010719b <allocuvm+0x7b>
80107157:	e9 87 00 00 00       	jmp    801071e3 <allocuvm+0xc3>
8010715c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107160:	83 ec 04             	sub    $0x4,%esp
80107163:	68 00 10 00 00       	push   $0x1000
80107168:	6a 00                	push   $0x0
8010716a:	50                   	push   %eax
8010716b:	e8 e0 d8 ff ff       	call   80104a50 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107170:	58                   	pop    %eax
80107171:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107177:	5a                   	pop    %edx
80107178:	6a 06                	push   $0x6
8010717a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010717f:	89 f2                	mov    %esi,%edx
80107181:	50                   	push   %eax
80107182:	89 f8                	mov    %edi,%eax
80107184:	e8 f7 fa ff ff       	call   80106c80 <mappages>
80107189:	83 c4 10             	add    $0x10,%esp
8010718c:	85 c0                	test   %eax,%eax
8010718e:	78 78                	js     80107208 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107190:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107196:	39 75 10             	cmp    %esi,0x10(%ebp)
80107199:	76 48                	jbe    801071e3 <allocuvm+0xc3>
    mem = kalloc();
8010719b:	e8 90 b7 ff ff       	call   80102930 <kalloc>
801071a0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801071a2:	85 c0                	test   %eax,%eax
801071a4:	75 ba                	jne    80107160 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801071a6:	83 ec 0c             	sub    $0xc,%esp
801071a9:	68 d5 80 10 80       	push   $0x801080d5
801071ae:	e8 ed 94 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801071b3:	8b 45 0c             	mov    0xc(%ebp),%eax
801071b6:	83 c4 10             	add    $0x10,%esp
801071b9:	39 45 10             	cmp    %eax,0x10(%ebp)
801071bc:	74 32                	je     801071f0 <allocuvm+0xd0>
801071be:	8b 55 10             	mov    0x10(%ebp),%edx
801071c1:	89 c1                	mov    %eax,%ecx
801071c3:	89 f8                	mov    %edi,%eax
801071c5:	e8 06 fa ff ff       	call   80106bd0 <deallocuvm.part.0>
      return 0;
801071ca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801071d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801071d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071d7:	5b                   	pop    %ebx
801071d8:	5e                   	pop    %esi
801071d9:	5f                   	pop    %edi
801071da:	5d                   	pop    %ebp
801071db:	c3                   	ret    
801071dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801071e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801071e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801071e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071e9:	5b                   	pop    %ebx
801071ea:	5e                   	pop    %esi
801071eb:	5f                   	pop    %edi
801071ec:	5d                   	pop    %ebp
801071ed:	c3                   	ret    
801071ee:	66 90                	xchg   %ax,%ax
    return 0;
801071f0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801071f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801071fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071fd:	5b                   	pop    %ebx
801071fe:	5e                   	pop    %esi
801071ff:	5f                   	pop    %edi
80107200:	5d                   	pop    %ebp
80107201:	c3                   	ret    
80107202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107208:	83 ec 0c             	sub    $0xc,%esp
8010720b:	68 ed 80 10 80       	push   $0x801080ed
80107210:	e8 8b 94 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107215:	8b 45 0c             	mov    0xc(%ebp),%eax
80107218:	83 c4 10             	add    $0x10,%esp
8010721b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010721e:	74 0c                	je     8010722c <allocuvm+0x10c>
80107220:	8b 55 10             	mov    0x10(%ebp),%edx
80107223:	89 c1                	mov    %eax,%ecx
80107225:	89 f8                	mov    %edi,%eax
80107227:	e8 a4 f9 ff ff       	call   80106bd0 <deallocuvm.part.0>
      kfree(mem);
8010722c:	83 ec 0c             	sub    $0xc,%esp
8010722f:	53                   	push   %ebx
80107230:	e8 4b b4 ff ff       	call   80102680 <kfree>
      return 0;
80107235:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010723c:	83 c4 10             	add    $0x10,%esp
}
8010723f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107242:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107245:	5b                   	pop    %ebx
80107246:	5e                   	pop    %esi
80107247:	5f                   	pop    %edi
80107248:	5d                   	pop    %ebp
80107249:	c3                   	ret    
8010724a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107250 <deallocuvm>:
{
80107250:	55                   	push   %ebp
80107251:	89 e5                	mov    %esp,%ebp
80107253:	8b 55 0c             	mov    0xc(%ebp),%edx
80107256:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107259:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010725c:	39 d1                	cmp    %edx,%ecx
8010725e:	73 10                	jae    80107270 <deallocuvm+0x20>
}
80107260:	5d                   	pop    %ebp
80107261:	e9 6a f9 ff ff       	jmp    80106bd0 <deallocuvm.part.0>
80107266:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010726d:	8d 76 00             	lea    0x0(%esi),%esi
80107270:	89 d0                	mov    %edx,%eax
80107272:	5d                   	pop    %ebp
80107273:	c3                   	ret    
80107274:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010727b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010727f:	90                   	nop

80107280 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107280:	55                   	push   %ebp
80107281:	89 e5                	mov    %esp,%ebp
80107283:	57                   	push   %edi
80107284:	56                   	push   %esi
80107285:	53                   	push   %ebx
80107286:	83 ec 0c             	sub    $0xc,%esp
80107289:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010728c:	85 f6                	test   %esi,%esi
8010728e:	74 59                	je     801072e9 <freevm+0x69>
  if(newsz >= oldsz)
80107290:	31 c9                	xor    %ecx,%ecx
80107292:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107297:	89 f0                	mov    %esi,%eax
80107299:	89 f3                	mov    %esi,%ebx
8010729b:	e8 30 f9 ff ff       	call   80106bd0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801072a0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801072a6:	eb 0f                	jmp    801072b7 <freevm+0x37>
801072a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072af:	90                   	nop
801072b0:	83 c3 04             	add    $0x4,%ebx
801072b3:	39 df                	cmp    %ebx,%edi
801072b5:	74 23                	je     801072da <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801072b7:	8b 03                	mov    (%ebx),%eax
801072b9:	a8 01                	test   $0x1,%al
801072bb:	74 f3                	je     801072b0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801072bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801072c2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801072c5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801072c8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801072cd:	50                   	push   %eax
801072ce:	e8 ad b3 ff ff       	call   80102680 <kfree>
801072d3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801072d6:	39 df                	cmp    %ebx,%edi
801072d8:	75 dd                	jne    801072b7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801072da:	89 75 08             	mov    %esi,0x8(%ebp)
}
801072dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072e0:	5b                   	pop    %ebx
801072e1:	5e                   	pop    %esi
801072e2:	5f                   	pop    %edi
801072e3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801072e4:	e9 97 b3 ff ff       	jmp    80102680 <kfree>
    panic("freevm: no pgdir");
801072e9:	83 ec 0c             	sub    $0xc,%esp
801072ec:	68 09 81 10 80       	push   $0x80108109
801072f1:	e8 8a 90 ff ff       	call   80100380 <panic>
801072f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072fd:	8d 76 00             	lea    0x0(%esi),%esi

80107300 <setupkvm>:
{
80107300:	55                   	push   %ebp
80107301:	89 e5                	mov    %esp,%ebp
80107303:	56                   	push   %esi
80107304:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107305:	e8 26 b6 ff ff       	call   80102930 <kalloc>
8010730a:	89 c6                	mov    %eax,%esi
8010730c:	85 c0                	test   %eax,%eax
8010730e:	74 42                	je     80107352 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107310:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107313:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107318:	68 00 10 00 00       	push   $0x1000
8010731d:	6a 00                	push   $0x0
8010731f:	50                   	push   %eax
80107320:	e8 2b d7 ff ff       	call   80104a50 <memset>
80107325:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107328:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010732b:	83 ec 08             	sub    $0x8,%esp
8010732e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107331:	ff 73 0c             	push   0xc(%ebx)
80107334:	8b 13                	mov    (%ebx),%edx
80107336:	50                   	push   %eax
80107337:	29 c1                	sub    %eax,%ecx
80107339:	89 f0                	mov    %esi,%eax
8010733b:	e8 40 f9 ff ff       	call   80106c80 <mappages>
80107340:	83 c4 10             	add    $0x10,%esp
80107343:	85 c0                	test   %eax,%eax
80107345:	78 19                	js     80107360 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107347:	83 c3 10             	add    $0x10,%ebx
8010734a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107350:	75 d6                	jne    80107328 <setupkvm+0x28>
}
80107352:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107355:	89 f0                	mov    %esi,%eax
80107357:	5b                   	pop    %ebx
80107358:	5e                   	pop    %esi
80107359:	5d                   	pop    %ebp
8010735a:	c3                   	ret    
8010735b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010735f:	90                   	nop
      freevm(pgdir);
80107360:	83 ec 0c             	sub    $0xc,%esp
80107363:	56                   	push   %esi
      return 0;
80107364:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107366:	e8 15 ff ff ff       	call   80107280 <freevm>
      return 0;
8010736b:	83 c4 10             	add    $0x10,%esp
}
8010736e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107371:	89 f0                	mov    %esi,%eax
80107373:	5b                   	pop    %ebx
80107374:	5e                   	pop    %esi
80107375:	5d                   	pop    %ebp
80107376:	c3                   	ret    
80107377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010737e:	66 90                	xchg   %ax,%ax

80107380 <kvmalloc>:
{
80107380:	55                   	push   %ebp
80107381:	89 e5                	mov    %esp,%ebp
80107383:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107386:	e8 75 ff ff ff       	call   80107300 <setupkvm>
8010738b:	a3 e4 65 11 80       	mov    %eax,0x801165e4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107390:	05 00 00 00 80       	add    $0x80000000,%eax
80107395:	0f 22 d8             	mov    %eax,%cr3
}
80107398:	c9                   	leave  
80107399:	c3                   	ret    
8010739a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801073a0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801073a0:	55                   	push   %ebp
801073a1:	89 e5                	mov    %esp,%ebp
801073a3:	83 ec 08             	sub    $0x8,%esp
801073a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801073a9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801073ac:	89 c1                	mov    %eax,%ecx
801073ae:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801073b1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801073b4:	f6 c2 01             	test   $0x1,%dl
801073b7:	75 17                	jne    801073d0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801073b9:	83 ec 0c             	sub    $0xc,%esp
801073bc:	68 1a 81 10 80       	push   $0x8010811a
801073c1:	e8 ba 8f ff ff       	call   80100380 <panic>
801073c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073cd:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801073d0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801073d3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801073d9:	25 fc 0f 00 00       	and    $0xffc,%eax
801073de:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801073e5:	85 c0                	test   %eax,%eax
801073e7:	74 d0                	je     801073b9 <clearpteu+0x19>
  *pte &= ~PTE_U;
801073e9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801073ec:	c9                   	leave  
801073ed:	c3                   	ret    
801073ee:	66 90                	xchg   %ax,%ax

801073f0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801073f0:	55                   	push   %ebp
801073f1:	89 e5                	mov    %esp,%ebp
801073f3:	57                   	push   %edi
801073f4:	56                   	push   %esi
801073f5:	53                   	push   %ebx
801073f6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  // char *mem;

  if((d = setupkvm()) == 0)
801073f9:	e8 02 ff ff ff       	call   80107300 <setupkvm>
801073fe:	89 c6                	mov    %eax,%esi
80107400:	85 c0                	test   %eax,%eax
80107402:	0f 84 b4 00 00 00    	je     801074bc <copyuvm+0xcc>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107408:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010740b:	85 c9                	test   %ecx,%ecx
8010740d:	0f 84 9d 00 00 00    	je     801074b0 <copyuvm+0xc0>
80107413:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107416:	31 ff                	xor    %edi,%edi
80107418:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010741f:	90                   	nop
  if(*pde & PTE_P){
80107420:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107423:	89 f8                	mov    %edi,%eax
80107425:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107428:	8b 04 82             	mov    (%edx,%eax,4),%eax
8010742b:	a8 01                	test   $0x1,%al
8010742d:	75 11                	jne    80107440 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010742f:	83 ec 0c             	sub    $0xc,%esp
80107432:	68 24 81 10 80       	push   $0x80108124
80107437:	e8 44 8f ff ff       	call   80100380 <panic>
8010743c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107440:	89 f9                	mov    %edi,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107442:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107447:	c1 e9 0a             	shr    $0xa,%ecx
8010744a:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80107450:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107457:	85 c0                	test   %eax,%eax
80107459:	74 d4                	je     8010742f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010745b:	8b 18                	mov    (%eax),%ebx
8010745d:	f6 c3 01             	test   $0x1,%bl
80107460:	0f 84 91 00 00 00    	je     801074f7 <copyuvm+0x107>
      panic("copyuvm: page not present");
    // cprintf("Debug: before write unset %p\n",*pte);
    *pte=((*pte)&(~PTE_W));
80107466:	89 d9                	mov    %ebx,%ecx
    // cprintf("Debug: after write unset%p\n",*pte);
    pa = PTE_ADDR(*pte);
80107468:	89 de                	mov    %ebx,%esi
    flags = PTE_FLAGS(*pte);
    inc_rmap(pa);
8010746a:	83 ec 0c             	sub    $0xc,%esp
    flags = PTE_FLAGS(*pte);
8010746d:	81 e3 fd 0f 00 00    	and    $0xffd,%ebx
    *pte=((*pte)&(~PTE_W));
80107473:	83 e1 fd             	and    $0xfffffffd,%ecx
    pa = PTE_ADDR(*pte);
80107476:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    *pte=((*pte)&(~PTE_W));
8010747c:	89 08                	mov    %ecx,(%eax)
    inc_rmap(pa);
8010747e:	56                   	push   %esi
8010747f:	e8 1c b1 ff ff       	call   801025a0 <inc_rmap>
    // if((mem = kalloc()) == 0)
    //   goto bad;
    // memmove(mem, (char*)P2V(pa), PGSIZE);
    // if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
    if(mappages(d, (void*)i, PGSIZE,pa, flags) < 0) {
80107484:	58                   	pop    %eax
80107485:	5a                   	pop    %edx
80107486:	53                   	push   %ebx
80107487:	56                   	push   %esi
80107488:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010748b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107490:	89 fa                	mov    %edi,%edx
80107492:	e8 e9 f7 ff ff       	call   80106c80 <mappages>
80107497:	83 c4 10             	add    $0x10,%esp
8010749a:	85 c0                	test   %eax,%eax
8010749c:	78 32                	js     801074d0 <copyuvm+0xe0>
  for(i = 0; i < sz; i += PGSIZE){
8010749e:	81 c7 00 10 00 00    	add    $0x1000,%edi
801074a4:	39 7d 0c             	cmp    %edi,0xc(%ebp)
801074a7:	0f 87 73 ff ff ff    	ja     80107420 <copyuvm+0x30>
801074ad:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      // kfree(mem);
      goto bad;
    }
  }
  lcr3(V2P(pgdir));
801074b0:	8b 45 08             	mov    0x8(%ebp),%eax
801074b3:	8d b8 00 00 00 80    	lea    -0x80000000(%eax),%edi
801074b9:	0f 22 df             	mov    %edi,%cr3

bad:
  freevm(d);
  lcr3(V2P(pgdir));
  return 0;
}
801074bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074bf:	89 f0                	mov    %esi,%eax
801074c1:	5b                   	pop    %ebx
801074c2:	5e                   	pop    %esi
801074c3:	5f                   	pop    %edi
801074c4:	5d                   	pop    %ebp
801074c5:	c3                   	ret    
801074c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074cd:	8d 76 00             	lea    0x0(%esi),%esi
  freevm(d);
801074d0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801074d3:	83 ec 0c             	sub    $0xc,%esp
801074d6:	56                   	push   %esi
801074d7:	e8 a4 fd ff ff       	call   80107280 <freevm>
  lcr3(V2P(pgdir));
801074dc:	8b 45 08             	mov    0x8(%ebp),%eax
801074df:	8d b8 00 00 00 80    	lea    -0x80000000(%eax),%edi
801074e5:	0f 22 df             	mov    %edi,%cr3
  return 0;
801074e8:	31 f6                	xor    %esi,%esi
801074ea:	83 c4 10             	add    $0x10,%esp
}
801074ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074f0:	5b                   	pop    %ebx
801074f1:	89 f0                	mov    %esi,%eax
801074f3:	5e                   	pop    %esi
801074f4:	5f                   	pop    %edi
801074f5:	5d                   	pop    %ebp
801074f6:	c3                   	ret    
      panic("copyuvm: page not present");
801074f7:	83 ec 0c             	sub    $0xc,%esp
801074fa:	68 3e 81 10 80       	push   $0x8010813e
801074ff:	e8 7c 8e ff ff       	call   80100380 <panic>
80107504:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010750b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010750f:	90                   	nop

80107510 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107510:	55                   	push   %ebp
80107511:	89 e5                	mov    %esp,%ebp
80107513:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107516:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107519:	89 c1                	mov    %eax,%ecx
8010751b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010751e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107521:	f6 c2 01             	test   $0x1,%dl
80107524:	0f 84 00 01 00 00    	je     8010762a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010752a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010752d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107533:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107534:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107539:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107540:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107542:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107547:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010754a:	05 00 00 00 80       	add    $0x80000000,%eax
8010754f:	83 fa 05             	cmp    $0x5,%edx
80107552:	ba 00 00 00 00       	mov    $0x0,%edx
80107557:	0f 45 c2             	cmovne %edx,%eax
}
8010755a:	c3                   	ret    
8010755b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010755f:	90                   	nop

80107560 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107560:	55                   	push   %ebp
80107561:	89 e5                	mov    %esp,%ebp
80107563:	57                   	push   %edi
80107564:	56                   	push   %esi
80107565:	53                   	push   %ebx
80107566:	83 ec 0c             	sub    $0xc,%esp
80107569:	8b 75 14             	mov    0x14(%ebp),%esi
8010756c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010756f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107572:	85 f6                	test   %esi,%esi
80107574:	75 51                	jne    801075c7 <copyout+0x67>
80107576:	e9 a5 00 00 00       	jmp    80107620 <copyout+0xc0>
8010757b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010757f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107580:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107586:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010758c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107592:	74 75                	je     80107609 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107594:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107596:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107599:	29 c3                	sub    %eax,%ebx
8010759b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801075a1:	39 f3                	cmp    %esi,%ebx
801075a3:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
801075a6:	29 f8                	sub    %edi,%eax
801075a8:	83 ec 04             	sub    $0x4,%esp
801075ab:	01 c1                	add    %eax,%ecx
801075ad:	53                   	push   %ebx
801075ae:	52                   	push   %edx
801075af:	51                   	push   %ecx
801075b0:	e8 3b d5 ff ff       	call   80104af0 <memmove>
    len -= n;
    buf += n;
801075b5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801075b8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801075be:	83 c4 10             	add    $0x10,%esp
    buf += n;
801075c1:	01 da                	add    %ebx,%edx
  while(len > 0){
801075c3:	29 de                	sub    %ebx,%esi
801075c5:	74 59                	je     80107620 <copyout+0xc0>
  if(*pde & PTE_P){
801075c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801075ca:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801075cc:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801075ce:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801075d1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801075d7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801075da:	f6 c1 01             	test   $0x1,%cl
801075dd:	0f 84 4e 00 00 00    	je     80107631 <copyout.cold>
  return &pgtab[PTX(va)];
801075e3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801075e5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801075eb:	c1 eb 0c             	shr    $0xc,%ebx
801075ee:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801075f4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801075fb:	89 d9                	mov    %ebx,%ecx
801075fd:	83 e1 05             	and    $0x5,%ecx
80107600:	83 f9 05             	cmp    $0x5,%ecx
80107603:	0f 84 77 ff ff ff    	je     80107580 <copyout+0x20>
  }
  return 0;
}
80107609:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010760c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107611:	5b                   	pop    %ebx
80107612:	5e                   	pop    %esi
80107613:	5f                   	pop    %edi
80107614:	5d                   	pop    %ebp
80107615:	c3                   	ret    
80107616:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010761d:	8d 76 00             	lea    0x0(%esi),%esi
80107620:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107623:	31 c0                	xor    %eax,%eax
}
80107625:	5b                   	pop    %ebx
80107626:	5e                   	pop    %esi
80107627:	5f                   	pop    %edi
80107628:	5d                   	pop    %ebp
80107629:	c3                   	ret    

8010762a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010762a:	a1 00 00 00 00       	mov    0x0,%eax
8010762f:	0f 0b                	ud2    

80107631 <copyout.cold>:
80107631:	a1 00 00 00 00       	mov    0x0,%eax
80107636:	0f 0b                	ud2    
80107638:	66 90                	xchg   %ax,%ax
8010763a:	66 90                	xchg   %ax,%ax
8010763c:	66 90                	xchg   %ax,%ax
8010763e:	66 90                	xchg   %ax,%ax

80107640 <pagingintr>:
//         rmap[i].virtual_addr=-1;
//         rmap[i].process_indexes=0;
//     }
// }

void pagingintr(){
80107640:	55                   	push   %ebp
80107641:	89 e5                	mov    %esp,%ebp
80107643:	57                   	push   %edi
80107644:	56                   	push   %esi
80107645:	53                   	push   %ebx
80107646:	83 ec 1c             	sub    $0x1c,%esp
    struct proc *curproc;
    uint pfa, pa, flags;
    pte_t *pte;
    char *mem;
    // Accesing the process that caused pagefault
    curproc=myproc();
80107649:	e8 62 c6 ff ff       	call   80103cb0 <myproc>
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010764e:	0f 20 d2             	mov    %cr2,%edx
    // Accessing the page addr that caused the pagefault 
    pfa=rcr2();
    // Accessing the page table entry of the fault page.
    pte=walkpgdir(curproc->pgdir, (void *)pfa,0);
80107651:	83 ec 04             	sub    $0x4,%esp
80107654:	6a 00                	push   $0x0
80107656:	52                   	push   %edx
80107657:	ff 70 08             	push   0x8(%eax)
8010765a:	e8 a1 f7 ff ff       	call   80106e00 <walkpgdir>
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);

    // Checking is pagefault due to COW
    if((flags & PTE_P))
8010765f:	83 c4 10             	add    $0x10,%esp
    pa = PTE_ADDR(*pte);
80107662:	8b 10                	mov    (%eax),%edx
    if((flags & PTE_P))
80107664:	f6 c2 01             	test   $0x1,%dl
80107667:	75 0f                	jne    80107678 <pagingintr+0x38>
      flags|=PTE_W;
      *pte= PTE_ADDR((uint)V2P(mem)) | flags;
      kfree(P2V(pa));
    }
    return;
}
80107669:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010766c:	5b                   	pop    %ebx
8010766d:	5e                   	pop    %esi
8010766e:	5f                   	pop    %edi
8010766f:	5d                   	pop    %ebp
80107670:	c3                   	ret    
80107671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107678:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      if((mem = kalloc()) == 0)
8010767b:	89 c6                	mov    %eax,%esi
8010767d:	e8 ae b2 ff ff       	call   80102930 <kalloc>
80107682:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107685:	85 c0                	test   %eax,%eax
80107687:	89 c3                	mov    %eax,%ebx
80107689:	74 4f                	je     801076da <pagingintr+0x9a>
    pa = PTE_ADDR(*pte);
8010768b:	89 d7                	mov    %edx,%edi
      memmove(mem, (char*)P2V(pa), PGSIZE);
8010768d:	83 ec 04             	sub    $0x4,%esp
    pa = PTE_ADDR(*pte);
80107690:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      *pte= PTE_ADDR((uint)V2P(mem)) | flags;
80107693:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    pa = PTE_ADDR(*pte);
80107699:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
      memmove(mem, (char*)P2V(pa), PGSIZE);
8010769f:	68 00 10 00 00       	push   $0x1000
      *pte= PTE_ADDR((uint)V2P(mem)) | flags;
801076a4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
      memmove(mem, (char*)P2V(pa), PGSIZE);
801076aa:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801076b0:	57                   	push   %edi
801076b1:	50                   	push   %eax
801076b2:	e8 39 d4 ff ff       	call   80104af0 <memmove>
    flags = PTE_FLAGS(*pte);
801076b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801076ba:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
      *pte= PTE_ADDR((uint)V2P(mem)) | flags;
801076c0:	09 d3                	or     %edx,%ebx
801076c2:	83 cb 02             	or     $0x2,%ebx
801076c5:	89 1e                	mov    %ebx,(%esi)
      kfree(P2V(pa));
801076c7:	89 3c 24             	mov    %edi,(%esp)
801076ca:	e8 b1 af ff ff       	call   80102680 <kfree>
801076cf:	83 c4 10             	add    $0x10,%esp
}
801076d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076d5:	5b                   	pop    %ebx
801076d6:	5e                   	pop    %esi
801076d7:	5f                   	pop    %edi
801076d8:	5d                   	pop    %ebp
801076d9:	c3                   	ret    
        panic("memory is not available for page copy");
801076da:	83 ec 0c             	sub    $0xc,%esp
801076dd:	68 7c 81 10 80       	push   $0x8010817c
801076e2:	e8 99 8c ff ff       	call   80100380 <panic>
