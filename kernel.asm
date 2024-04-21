
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
80100028:	bc 00 b9 11 80       	mov    $0x8011b900,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 a0 35 10 80       	mov    $0x801035a0,%eax
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
8010004c:	68 60 7e 10 80       	push   $0x80107e60
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 e5 4b 00 00       	call   80104c40 <initlock>
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
80100092:	68 67 7e 10 80       	push   $0x80107e67
80100097:	50                   	push   %eax
80100098:	e8 73 4a 00 00       	call   80104b10 <initsleeplock>
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
801000e4:	e8 27 4d 00 00       	call   80104e10 <acquire>
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
80100162:	e8 49 4c 00 00       	call   80104db0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 de 49 00 00       	call   80104b50 <acquiresleep>
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
8010018c:	e8 6f 21 00 00       	call   80102300 <iderw>
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
801001a1:	68 6e 7e 10 80       	push   $0x80107e6e
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
801001be:	e8 2d 4a 00 00       	call   80104bf0 <holdingsleep>
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
801001d4:	e9 27 21 00 00       	jmp    80102300 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 7f 7e 10 80       	push   $0x80107e7f
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
801001ff:	e8 ec 49 00 00       	call   80104bf0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 9c 49 00 00       	call   80104bb0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 f0 4b 00 00       	call   80104e10 <acquire>
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
8010026c:	e9 3f 4b 00 00       	jmp    80104db0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 86 7e 10 80       	push   $0x80107e86
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
80100294:	e8 e7 15 00 00       	call   80101880 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 6b 4b 00 00       	call   80104e10 <acquire>
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
801002cd:	e8 ce 40 00 00       	call   801043a0 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 c9 3b 00 00       	call   80103eb0 <myproc>
801002e7:	8b 48 28             	mov    0x28(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 b5 4a 00 00       	call   80104db0 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 9c 14 00 00       	call   801017a0 <ilock>
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
8010034c:	e8 5f 4a 00 00       	call   80104db0 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 46 14 00 00       	call   801017a0 <ilock>
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
80100399:	e8 92 2a 00 00       	call   80102e30 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 8d 7e 10 80       	push   $0x80107e8d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 07 89 10 80 	movl   $0x80108907,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 93 48 00 00       	call   80104c60 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 a1 7e 10 80       	push   $0x80107ea1
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
8010041a:	e8 41 61 00 00       	call   80106560 <uartputc>
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
80100505:	e8 56 60 00 00       	call   80106560 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 4a 60 00 00       	call   80106560 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 3e 60 00 00       	call   80106560 <uartputc>
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
80100551:	e8 1a 4a 00 00       	call   80104f70 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 65 49 00 00       	call   80104ed0 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 a5 7e 10 80       	push   $0x80107ea5
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
8010059f:	e8 dc 12 00 00       	call   80101880 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005ab:	e8 60 48 00 00       	call   80104e10 <acquire>
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
801005e4:	e8 c7 47 00 00       	call   80104db0 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 ae 11 00 00       	call   801017a0 <ilock>

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
80100636:	0f b6 92 d0 7e 10 80 	movzbl -0x7fef8130(%edx),%edx
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
801007e8:	e8 23 46 00 00       	call   80104e10 <acquire>
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
80100838:	bf b8 7e 10 80       	mov    $0x80107eb8,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ff 10 80       	push   $0x8010ff20
8010085b:	e8 50 45 00 00       	call   80104db0 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 bf 7e 10 80       	push   $0x80107ebf
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
80100893:	e8 78 45 00 00       	call   80104e10 <acquire>
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
801009d0:	e8 db 43 00 00       	call   80104db0 <release>
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
80100a0e:	e9 2d 3b 00 00       	jmp    80104540 <procdump>
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
80100a44:	e8 17 3a 00 00       	call   80104460 <wakeup>
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
80100a66:	68 c8 7e 10 80       	push   $0x80107ec8
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 cb 41 00 00       	call   80104c40 <initlock>

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
80100a99:	e8 02 1a 00 00       	call   801024a0 <ioapicenable>
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
80100abc:	e8 ef 33 00 00       	call   80103eb0 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 d4 27 00 00       	call   801032a0 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 e9 15 00 00       	call   801020c0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 05 03 00 00    	je     80100de7 <exec+0x337>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 b3 0c 00 00       	call   801017a0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 b2 0f 00 00       	call   80101ab0 <readi>
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
80100b0a:	e8 21 0f 00 00       	call   80101a30 <iunlockput>
    end_op();
80100b0f:	e8 fc 27 00 00       	call   80103310 <end_op>
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
80100b34:	e8 57 6c 00 00       	call   80107790 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 af 02 00 00    	je     80100e06 <exec+0x356>
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
80100ba3:	e8 28 6a 00 00       	call   801075d0 <allocuvm>
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
80100bd9:	e8 22 68 00 00       	call   80107400 <loaduvm>
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
80100c01:	e8 aa 0e 00 00       	call   80101ab0 <readi>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	0f 84 5e ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1b:	e8 f0 6a 00 00       	call   80107710 <freevm>
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
80100c4c:	e8 df 0d 00 00       	call   80101a30 <iunlockput>
  end_op();
80100c51:	e8 ba 26 00 00       	call   80103310 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 69 69 00 00       	call   801075d0 <allocuvm>
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
80100c83:	e8 a8 6b 00 00       	call   80107830 <clearpteu>
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
80100cd3:	e8 f8 43 00 00       	call   801050d0 <strlen>
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
80100ce7:	e8 e4 43 00 00       	call   801050d0 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 03 6d 00 00       	call   80107a00 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 fa 69 00 00       	call   80107710 <freevm>
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
80100d63:	e8 98 6c 00 00       	call   80107a00 <copyout>
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
80100da1:	e8 ea 42 00 00       	call   80105090 <safestrcpy>
  curproc->pgdir = pgdir;
80100da6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dac:	89 f8                	mov    %edi,%eax
80100dae:	8b 7f 08             	mov    0x8(%edi),%edi
  curproc->sz = sz;
80100db1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100db3:	89 48 08             	mov    %ecx,0x8(%eax)
  curproc->rss = sz;
80100db6:	89 c1                	mov    %eax,%ecx
80100db8:	89 70 04             	mov    %esi,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100dbb:	8b 40 1c             	mov    0x1c(%eax),%eax
80100dbe:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dc4:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc7:	8b 41 1c             	mov    0x1c(%ecx),%eax
80100dca:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dcd:	89 0c 24             	mov    %ecx,(%esp)
80100dd0:	e8 9b 64 00 00       	call   80107270 <switchuvm>
  freevm(oldpgdir);
80100dd5:	89 3c 24             	mov    %edi,(%esp)
80100dd8:	e8 33 69 00 00       	call   80107710 <freevm>
  return 0;
80100ddd:	83 c4 10             	add    $0x10,%esp
80100de0:	31 c0                	xor    %eax,%eax
80100de2:	e9 35 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de7:	e8 24 25 00 00       	call   80103310 <end_op>
    cprintf("exec: fail\n");
80100dec:	83 ec 0c             	sub    $0xc,%esp
80100def:	68 e1 7e 10 80       	push   $0x80107ee1
80100df4:	e8 a7 f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100df9:	83 c4 10             	add    $0x10,%esp
80100dfc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e01:	e9 16 fd ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e06:	be 00 20 00 00       	mov    $0x2000,%esi
80100e0b:	31 ff                	xor    %edi,%edi
80100e0d:	e9 36 fe ff ff       	jmp    80100c48 <exec+0x198>
80100e12:	66 90                	xchg   %ax,%ax
80100e14:	66 90                	xchg   %ax,%ax
80100e16:	66 90                	xchg   %ax,%ax
80100e18:	66 90                	xchg   %ax,%ax
80100e1a:	66 90                	xchg   %ax,%ax
80100e1c:	66 90                	xchg   %ax,%ax
80100e1e:	66 90                	xchg   %ax,%ax

80100e20 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e20:	55                   	push   %ebp
80100e21:	89 e5                	mov    %esp,%ebp
80100e23:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e26:	68 ed 7e 10 80       	push   $0x80107eed
80100e2b:	68 60 ff 10 80       	push   $0x8010ff60
80100e30:	e8 0b 3e 00 00       	call   80104c40 <initlock>
}
80100e35:	83 c4 10             	add    $0x10,%esp
80100e38:	c9                   	leave  
80100e39:	c3                   	ret    
80100e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e40 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e44:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100e49:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e4c:	68 60 ff 10 80       	push   $0x8010ff60
80100e51:	e8 ba 3f 00 00       	call   80104e10 <acquire>
80100e56:	83 c4 10             	add    $0x10,%esp
80100e59:	eb 10                	jmp    80100e6b <filealloc+0x2b>
80100e5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e5f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e60:	83 c3 18             	add    $0x18,%ebx
80100e63:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100e69:	74 25                	je     80100e90 <filealloc+0x50>
    if(f->ref == 0){
80100e6b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e6e:	85 c0                	test   %eax,%eax
80100e70:	75 ee                	jne    80100e60 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e72:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e75:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e7c:	68 60 ff 10 80       	push   $0x8010ff60
80100e81:	e8 2a 3f 00 00       	call   80104db0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e86:	89 d8                	mov    %ebx,%eax
      return f;
80100e88:	83 c4 10             	add    $0x10,%esp
}
80100e8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e8e:	c9                   	leave  
80100e8f:	c3                   	ret    
  release(&ftable.lock);
80100e90:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e93:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e95:	68 60 ff 10 80       	push   $0x8010ff60
80100e9a:	e8 11 3f 00 00       	call   80104db0 <release>
}
80100e9f:	89 d8                	mov    %ebx,%eax
  return 0;
80100ea1:	83 c4 10             	add    $0x10,%esp
}
80100ea4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ea7:	c9                   	leave  
80100ea8:	c3                   	ret    
80100ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100eb0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100eb0:	55                   	push   %ebp
80100eb1:	89 e5                	mov    %esp,%ebp
80100eb3:	53                   	push   %ebx
80100eb4:	83 ec 10             	sub    $0x10,%esp
80100eb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eba:	68 60 ff 10 80       	push   $0x8010ff60
80100ebf:	e8 4c 3f 00 00       	call   80104e10 <acquire>
  if(f->ref < 1)
80100ec4:	8b 43 04             	mov    0x4(%ebx),%eax
80100ec7:	83 c4 10             	add    $0x10,%esp
80100eca:	85 c0                	test   %eax,%eax
80100ecc:	7e 1a                	jle    80100ee8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ece:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ed1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ed4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ed7:	68 60 ff 10 80       	push   $0x8010ff60
80100edc:	e8 cf 3e 00 00       	call   80104db0 <release>
  return f;
}
80100ee1:	89 d8                	mov    %ebx,%eax
80100ee3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ee6:	c9                   	leave  
80100ee7:	c3                   	ret    
    panic("filedup");
80100ee8:	83 ec 0c             	sub    $0xc,%esp
80100eeb:	68 f4 7e 10 80       	push   $0x80107ef4
80100ef0:	e8 8b f4 ff ff       	call   80100380 <panic>
80100ef5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f00 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	57                   	push   %edi
80100f04:	56                   	push   %esi
80100f05:	53                   	push   %ebx
80100f06:	83 ec 28             	sub    $0x28,%esp
80100f09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f0c:	68 60 ff 10 80       	push   $0x8010ff60
80100f11:	e8 fa 3e 00 00       	call   80104e10 <acquire>
  if(f->ref < 1)
80100f16:	8b 53 04             	mov    0x4(%ebx),%edx
80100f19:	83 c4 10             	add    $0x10,%esp
80100f1c:	85 d2                	test   %edx,%edx
80100f1e:	0f 8e a5 00 00 00    	jle    80100fc9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f24:	83 ea 01             	sub    $0x1,%edx
80100f27:	89 53 04             	mov    %edx,0x4(%ebx)
80100f2a:	75 44                	jne    80100f70 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f2c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f30:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f33:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f35:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f3b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f3e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f41:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f44:	68 60 ff 10 80       	push   $0x8010ff60
  ff = *f;
80100f49:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f4c:	e8 5f 3e 00 00       	call   80104db0 <release>

  if(ff.type == FD_PIPE)
80100f51:	83 c4 10             	add    $0x10,%esp
80100f54:	83 ff 01             	cmp    $0x1,%edi
80100f57:	74 57                	je     80100fb0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f59:	83 ff 02             	cmp    $0x2,%edi
80100f5c:	74 2a                	je     80100f88 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f61:	5b                   	pop    %ebx
80100f62:	5e                   	pop    %esi
80100f63:	5f                   	pop    %edi
80100f64:	5d                   	pop    %ebp
80100f65:	c3                   	ret    
80100f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f6d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f70:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80100f77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f7a:	5b                   	pop    %ebx
80100f7b:	5e                   	pop    %esi
80100f7c:	5f                   	pop    %edi
80100f7d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f7e:	e9 2d 3e 00 00       	jmp    80104db0 <release>
80100f83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f87:	90                   	nop
    begin_op();
80100f88:	e8 13 23 00 00       	call   801032a0 <begin_op>
    iput(ff.ip);
80100f8d:	83 ec 0c             	sub    $0xc,%esp
80100f90:	ff 75 e0             	push   -0x20(%ebp)
80100f93:	e8 38 09 00 00       	call   801018d0 <iput>
    end_op();
80100f98:	83 c4 10             	add    $0x10,%esp
}
80100f9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f9e:	5b                   	pop    %ebx
80100f9f:	5e                   	pop    %esi
80100fa0:	5f                   	pop    %edi
80100fa1:	5d                   	pop    %ebp
    end_op();
80100fa2:	e9 69 23 00 00       	jmp    80103310 <end_op>
80100fa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fae:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fb0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fb4:	83 ec 08             	sub    $0x8,%esp
80100fb7:	53                   	push   %ebx
80100fb8:	56                   	push   %esi
80100fb9:	e8 b2 2a 00 00       	call   80103a70 <pipeclose>
80100fbe:	83 c4 10             	add    $0x10,%esp
}
80100fc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc4:	5b                   	pop    %ebx
80100fc5:	5e                   	pop    %esi
80100fc6:	5f                   	pop    %edi
80100fc7:	5d                   	pop    %ebp
80100fc8:	c3                   	ret    
    panic("fileclose");
80100fc9:	83 ec 0c             	sub    $0xc,%esp
80100fcc:	68 fc 7e 10 80       	push   $0x80107efc
80100fd1:	e8 aa f3 ff ff       	call   80100380 <panic>
80100fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fdd:	8d 76 00             	lea    0x0(%esi),%esi

80100fe0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	53                   	push   %ebx
80100fe4:	83 ec 04             	sub    $0x4,%esp
80100fe7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fea:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fed:	75 31                	jne    80101020 <filestat+0x40>
    ilock(f->ip);
80100fef:	83 ec 0c             	sub    $0xc,%esp
80100ff2:	ff 73 10             	push   0x10(%ebx)
80100ff5:	e8 a6 07 00 00       	call   801017a0 <ilock>
    stati(f->ip, st);
80100ffa:	58                   	pop    %eax
80100ffb:	5a                   	pop    %edx
80100ffc:	ff 75 0c             	push   0xc(%ebp)
80100fff:	ff 73 10             	push   0x10(%ebx)
80101002:	e8 79 0a 00 00       	call   80101a80 <stati>
    iunlock(f->ip);
80101007:	59                   	pop    %ecx
80101008:	ff 73 10             	push   0x10(%ebx)
8010100b:	e8 70 08 00 00       	call   80101880 <iunlock>
    return 0;
  }
  return -1;
}
80101010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101013:	83 c4 10             	add    $0x10,%esp
80101016:	31 c0                	xor    %eax,%eax
}
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101020:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101023:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101028:	c9                   	leave  
80101029:	c3                   	ret    
8010102a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101030 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101030:	55                   	push   %ebp
80101031:	89 e5                	mov    %esp,%ebp
80101033:	57                   	push   %edi
80101034:	56                   	push   %esi
80101035:	53                   	push   %ebx
80101036:	83 ec 0c             	sub    $0xc,%esp
80101039:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010103c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010103f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101042:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101046:	74 60                	je     801010a8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101048:	8b 03                	mov    (%ebx),%eax
8010104a:	83 f8 01             	cmp    $0x1,%eax
8010104d:	74 41                	je     80101090 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010104f:	83 f8 02             	cmp    $0x2,%eax
80101052:	75 5b                	jne    801010af <fileread+0x7f>
    ilock(f->ip);
80101054:	83 ec 0c             	sub    $0xc,%esp
80101057:	ff 73 10             	push   0x10(%ebx)
8010105a:	e8 41 07 00 00       	call   801017a0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010105f:	57                   	push   %edi
80101060:	ff 73 14             	push   0x14(%ebx)
80101063:	56                   	push   %esi
80101064:	ff 73 10             	push   0x10(%ebx)
80101067:	e8 44 0a 00 00       	call   80101ab0 <readi>
8010106c:	83 c4 20             	add    $0x20,%esp
8010106f:	89 c6                	mov    %eax,%esi
80101071:	85 c0                	test   %eax,%eax
80101073:	7e 03                	jle    80101078 <fileread+0x48>
      f->off += r;
80101075:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101078:	83 ec 0c             	sub    $0xc,%esp
8010107b:	ff 73 10             	push   0x10(%ebx)
8010107e:	e8 fd 07 00 00       	call   80101880 <iunlock>
    return r;
80101083:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101089:	89 f0                	mov    %esi,%eax
8010108b:	5b                   	pop    %ebx
8010108c:	5e                   	pop    %esi
8010108d:	5f                   	pop    %edi
8010108e:	5d                   	pop    %ebp
8010108f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101090:	8b 43 0c             	mov    0xc(%ebx),%eax
80101093:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101096:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101099:	5b                   	pop    %ebx
8010109a:	5e                   	pop    %esi
8010109b:	5f                   	pop    %edi
8010109c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010109d:	e9 6e 2b 00 00       	jmp    80103c10 <piperead>
801010a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010a8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010ad:	eb d7                	jmp    80101086 <fileread+0x56>
  panic("fileread");
801010af:	83 ec 0c             	sub    $0xc,%esp
801010b2:	68 06 7f 10 80       	push   $0x80107f06
801010b7:	e8 c4 f2 ff ff       	call   80100380 <panic>
801010bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010c0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010c0:	55                   	push   %ebp
801010c1:	89 e5                	mov    %esp,%ebp
801010c3:	57                   	push   %edi
801010c4:	56                   	push   %esi
801010c5:	53                   	push   %ebx
801010c6:	83 ec 1c             	sub    $0x1c,%esp
801010c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010cf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010d2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010d5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010dc:	0f 84 bd 00 00 00    	je     8010119f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801010e2:	8b 03                	mov    (%ebx),%eax
801010e4:	83 f8 01             	cmp    $0x1,%eax
801010e7:	0f 84 bf 00 00 00    	je     801011ac <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010ed:	83 f8 02             	cmp    $0x2,%eax
801010f0:	0f 85 c8 00 00 00    	jne    801011be <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010f9:	31 f6                	xor    %esi,%esi
    while(i < n){
801010fb:	85 c0                	test   %eax,%eax
801010fd:	7f 30                	jg     8010112f <filewrite+0x6f>
801010ff:	e9 94 00 00 00       	jmp    80101198 <filewrite+0xd8>
80101104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101108:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010110b:	83 ec 0c             	sub    $0xc,%esp
8010110e:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101111:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101114:	e8 67 07 00 00       	call   80101880 <iunlock>
      end_op();
80101119:	e8 f2 21 00 00       	call   80103310 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010111e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101121:	83 c4 10             	add    $0x10,%esp
80101124:	39 c7                	cmp    %eax,%edi
80101126:	75 5c                	jne    80101184 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101128:	01 fe                	add    %edi,%esi
    while(i < n){
8010112a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010112d:	7e 69                	jle    80101198 <filewrite+0xd8>
      int n1 = n - i;
8010112f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101132:	b8 00 06 00 00       	mov    $0x600,%eax
80101137:	29 f7                	sub    %esi,%edi
80101139:	39 c7                	cmp    %eax,%edi
8010113b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010113e:	e8 5d 21 00 00       	call   801032a0 <begin_op>
      ilock(f->ip);
80101143:	83 ec 0c             	sub    $0xc,%esp
80101146:	ff 73 10             	push   0x10(%ebx)
80101149:	e8 52 06 00 00       	call   801017a0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010114e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101151:	57                   	push   %edi
80101152:	ff 73 14             	push   0x14(%ebx)
80101155:	01 f0                	add    %esi,%eax
80101157:	50                   	push   %eax
80101158:	ff 73 10             	push   0x10(%ebx)
8010115b:	e8 50 0a 00 00       	call   80101bb0 <writei>
80101160:	83 c4 20             	add    $0x20,%esp
80101163:	85 c0                	test   %eax,%eax
80101165:	7f a1                	jg     80101108 <filewrite+0x48>
      iunlock(f->ip);
80101167:	83 ec 0c             	sub    $0xc,%esp
8010116a:	ff 73 10             	push   0x10(%ebx)
8010116d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101170:	e8 0b 07 00 00       	call   80101880 <iunlock>
      end_op();
80101175:	e8 96 21 00 00       	call   80103310 <end_op>
      if(r < 0)
8010117a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010117d:	83 c4 10             	add    $0x10,%esp
80101180:	85 c0                	test   %eax,%eax
80101182:	75 1b                	jne    8010119f <filewrite+0xdf>
        panic("short filewrite");
80101184:	83 ec 0c             	sub    $0xc,%esp
80101187:	68 0f 7f 10 80       	push   $0x80107f0f
8010118c:	e8 ef f1 ff ff       	call   80100380 <panic>
80101191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101198:	89 f0                	mov    %esi,%eax
8010119a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010119d:	74 05                	je     801011a4 <filewrite+0xe4>
8010119f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801011a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a7:	5b                   	pop    %ebx
801011a8:	5e                   	pop    %esi
801011a9:	5f                   	pop    %edi
801011aa:	5d                   	pop    %ebp
801011ab:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801011ac:	8b 43 0c             	mov    0xc(%ebx),%eax
801011af:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011b5:	5b                   	pop    %ebx
801011b6:	5e                   	pop    %esi
801011b7:	5f                   	pop    %edi
801011b8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011b9:	e9 52 29 00 00       	jmp    80103b10 <pipewrite>
  panic("filewrite");
801011be:	83 ec 0c             	sub    $0xc,%esp
801011c1:	68 15 7f 10 80       	push   $0x80107f15
801011c6:	e8 b5 f1 ff ff       	call   80100380 <panic>
801011cb:	66 90                	xchg   %ax,%ax
801011cd:	66 90                	xchg   %ax,%ax
801011cf:	90                   	nop

801011d0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011d0:	55                   	push   %ebp
801011d1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011d3:	89 d0                	mov    %edx,%eax
801011d5:	c1 e8 0c             	shr    $0xc,%eax
801011d8:	03 05 dc 25 11 80    	add    0x801125dc,%eax
{
801011de:	89 e5                	mov    %esp,%ebp
801011e0:	56                   	push   %esi
801011e1:	53                   	push   %ebx
801011e2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011e4:	83 ec 08             	sub    $0x8,%esp
801011e7:	50                   	push   %eax
801011e8:	51                   	push   %ecx
801011e9:	e8 e2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011ee:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011f0:	c1 fb 03             	sar    $0x3,%ebx
801011f3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801011f6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801011f8:	83 e1 07             	and    $0x7,%ecx
801011fb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101200:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101206:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101208:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010120d:	85 c1                	test   %eax,%ecx
8010120f:	74 23                	je     80101234 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101211:	f7 d0                	not    %eax
  log_write(bp);
80101213:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101216:	21 c8                	and    %ecx,%eax
80101218:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010121c:	56                   	push   %esi
8010121d:	e8 5e 22 00 00       	call   80103480 <log_write>
  brelse(bp);
80101222:	89 34 24             	mov    %esi,(%esp)
80101225:	e8 c6 ef ff ff       	call   801001f0 <brelse>
}
8010122a:	83 c4 10             	add    $0x10,%esp
8010122d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101230:	5b                   	pop    %ebx
80101231:	5e                   	pop    %esi
80101232:	5d                   	pop    %ebp
80101233:	c3                   	ret    
    panic("freeing free block");
80101234:	83 ec 0c             	sub    $0xc,%esp
80101237:	68 1f 7f 10 80       	push   $0x80107f1f
8010123c:	e8 3f f1 ff ff       	call   80100380 <panic>
80101241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101248:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010124f:	90                   	nop

80101250 <balloc>:
{
80101250:	55                   	push   %ebp
80101251:	89 e5                	mov    %esp,%ebp
80101253:	57                   	push   %edi
80101254:	56                   	push   %esi
80101255:	53                   	push   %ebx
80101256:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101259:	8b 0d c0 25 11 80    	mov    0x801125c0,%ecx
{
8010125f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101262:	85 c9                	test   %ecx,%ecx
80101264:	0f 84 87 00 00 00    	je     801012f1 <balloc+0xa1>
8010126a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101271:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101274:	83 ec 08             	sub    $0x8,%esp
80101277:	89 f0                	mov    %esi,%eax
80101279:	c1 f8 0c             	sar    $0xc,%eax
8010127c:	03 05 dc 25 11 80    	add    0x801125dc,%eax
80101282:	50                   	push   %eax
80101283:	ff 75 d8             	push   -0x28(%ebp)
80101286:	e8 45 ee ff ff       	call   801000d0 <bread>
8010128b:	83 c4 10             	add    $0x10,%esp
8010128e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101291:	a1 c0 25 11 80       	mov    0x801125c0,%eax
80101296:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101299:	31 c0                	xor    %eax,%eax
8010129b:	eb 2f                	jmp    801012cc <balloc+0x7c>
8010129d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801012a0:	89 c1                	mov    %eax,%ecx
801012a2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801012aa:	83 e1 07             	and    $0x7,%ecx
801012ad:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012af:	89 c1                	mov    %eax,%ecx
801012b1:	c1 f9 03             	sar    $0x3,%ecx
801012b4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012b9:	89 fa                	mov    %edi,%edx
801012bb:	85 df                	test   %ebx,%edi
801012bd:	74 41                	je     80101300 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012bf:	83 c0 01             	add    $0x1,%eax
801012c2:	83 c6 01             	add    $0x1,%esi
801012c5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ca:	74 05                	je     801012d1 <balloc+0x81>
801012cc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012cf:	77 cf                	ja     801012a0 <balloc+0x50>
    brelse(bp);
801012d1:	83 ec 0c             	sub    $0xc,%esp
801012d4:	ff 75 e4             	push   -0x1c(%ebp)
801012d7:	e8 14 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012dc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012e3:	83 c4 10             	add    $0x10,%esp
801012e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012e9:	39 05 c0 25 11 80    	cmp    %eax,0x801125c0
801012ef:	77 80                	ja     80101271 <balloc+0x21>
  panic("balloc: out of blocks");
801012f1:	83 ec 0c             	sub    $0xc,%esp
801012f4:	68 32 7f 10 80       	push   $0x80107f32
801012f9:	e8 82 f0 ff ff       	call   80100380 <panic>
801012fe:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101300:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101303:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101306:	09 da                	or     %ebx,%edx
80101308:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010130c:	57                   	push   %edi
8010130d:	e8 6e 21 00 00       	call   80103480 <log_write>
        brelse(bp);
80101312:	89 3c 24             	mov    %edi,(%esp)
80101315:	e8 d6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010131a:	58                   	pop    %eax
8010131b:	5a                   	pop    %edx
8010131c:	56                   	push   %esi
8010131d:	ff 75 d8             	push   -0x28(%ebp)
80101320:	e8 ab ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101325:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101328:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010132a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010132d:	68 00 02 00 00       	push   $0x200
80101332:	6a 00                	push   $0x0
80101334:	50                   	push   %eax
80101335:	e8 96 3b 00 00       	call   80104ed0 <memset>
  log_write(bp);
8010133a:	89 1c 24             	mov    %ebx,(%esp)
8010133d:	e8 3e 21 00 00       	call   80103480 <log_write>
  brelse(bp);
80101342:	89 1c 24             	mov    %ebx,(%esp)
80101345:	e8 a6 ee ff ff       	call   801001f0 <brelse>
}
8010134a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010134d:	89 f0                	mov    %esi,%eax
8010134f:	5b                   	pop    %ebx
80101350:	5e                   	pop    %esi
80101351:	5f                   	pop    %edi
80101352:	5d                   	pop    %ebp
80101353:	c3                   	ret    
80101354:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010135b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010135f:	90                   	nop

80101360 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	89 c7                	mov    %eax,%edi
80101366:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101367:	31 f6                	xor    %esi,%esi
{
80101369:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136a:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
8010136f:	83 ec 28             	sub    $0x28,%esp
80101372:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101375:	68 60 09 11 80       	push   $0x80110960
8010137a:	e8 91 3a 00 00       	call   80104e10 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010137f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101382:	83 c4 10             	add    $0x10,%esp
80101385:	eb 1b                	jmp    801013a2 <iget+0x42>
80101387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010138e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101390:	39 3b                	cmp    %edi,(%ebx)
80101392:	74 6c                	je     80101400 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101394:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010139a:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013a0:	73 26                	jae    801013c8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013a2:	8b 43 08             	mov    0x8(%ebx),%eax
801013a5:	85 c0                	test   %eax,%eax
801013a7:	7f e7                	jg     80101390 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801013a9:	85 f6                	test   %esi,%esi
801013ab:	75 e7                	jne    80101394 <iget+0x34>
801013ad:	85 c0                	test   %eax,%eax
801013af:	75 76                	jne    80101427 <iget+0xc7>
801013b1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013b3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013b9:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013bf:	72 e1                	jb     801013a2 <iget+0x42>
801013c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013c8:	85 f6                	test   %esi,%esi
801013ca:	74 79                	je     80101445 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013cc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013cf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013d1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013d4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013db:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013e2:	68 60 09 11 80       	push   $0x80110960
801013e7:	e8 c4 39 00 00       	call   80104db0 <release>

  return ip;
801013ec:	83 c4 10             	add    $0x10,%esp
}
801013ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013f2:	89 f0                	mov    %esi,%eax
801013f4:	5b                   	pop    %ebx
801013f5:	5e                   	pop    %esi
801013f6:	5f                   	pop    %edi
801013f7:	5d                   	pop    %ebp
801013f8:	c3                   	ret    
801013f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101400:	39 53 04             	cmp    %edx,0x4(%ebx)
80101403:	75 8f                	jne    80101394 <iget+0x34>
      release(&icache.lock);
80101405:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101408:	83 c0 01             	add    $0x1,%eax
      return ip;
8010140b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010140d:	68 60 09 11 80       	push   $0x80110960
      ip->ref++;
80101412:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101415:	e8 96 39 00 00       	call   80104db0 <release>
      return ip;
8010141a:	83 c4 10             	add    $0x10,%esp
}
8010141d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101420:	89 f0                	mov    %esi,%eax
80101422:	5b                   	pop    %ebx
80101423:	5e                   	pop    %esi
80101424:	5f                   	pop    %edi
80101425:	5d                   	pop    %ebp
80101426:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101427:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010142d:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101433:	73 10                	jae    80101445 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101435:	8b 43 08             	mov    0x8(%ebx),%eax
80101438:	85 c0                	test   %eax,%eax
8010143a:	0f 8f 50 ff ff ff    	jg     80101390 <iget+0x30>
80101440:	e9 68 ff ff ff       	jmp    801013ad <iget+0x4d>
    panic("iget: no inodes");
80101445:	83 ec 0c             	sub    $0xc,%esp
80101448:	68 48 7f 10 80       	push   $0x80107f48
8010144d:	e8 2e ef ff ff       	call   80100380 <panic>
80101452:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101460 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101460:	55                   	push   %ebp
80101461:	89 e5                	mov    %esp,%ebp
80101463:	57                   	push   %edi
80101464:	56                   	push   %esi
80101465:	89 c6                	mov    %eax,%esi
80101467:	53                   	push   %ebx
80101468:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010146b:	83 fa 0b             	cmp    $0xb,%edx
8010146e:	0f 86 8c 00 00 00    	jbe    80101500 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101474:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101477:	83 fb 7f             	cmp    $0x7f,%ebx
8010147a:	0f 87 a2 00 00 00    	ja     80101522 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101480:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101486:	85 c0                	test   %eax,%eax
80101488:	74 5e                	je     801014e8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010148a:	83 ec 08             	sub    $0x8,%esp
8010148d:	50                   	push   %eax
8010148e:	ff 36                	push   (%esi)
80101490:	e8 3b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101495:	83 c4 10             	add    $0x10,%esp
80101498:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010149c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010149e:	8b 3b                	mov    (%ebx),%edi
801014a0:	85 ff                	test   %edi,%edi
801014a2:	74 1c                	je     801014c0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801014a4:	83 ec 0c             	sub    $0xc,%esp
801014a7:	52                   	push   %edx
801014a8:	e8 43 ed ff ff       	call   801001f0 <brelse>
801014ad:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014b3:	89 f8                	mov    %edi,%eax
801014b5:	5b                   	pop    %ebx
801014b6:	5e                   	pop    %esi
801014b7:	5f                   	pop    %edi
801014b8:	5d                   	pop    %ebp
801014b9:	c3                   	ret    
801014ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014c3:	8b 06                	mov    (%esi),%eax
801014c5:	e8 86 fd ff ff       	call   80101250 <balloc>
      log_write(bp);
801014ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014cd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014d0:	89 03                	mov    %eax,(%ebx)
801014d2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014d4:	52                   	push   %edx
801014d5:	e8 a6 1f 00 00       	call   80103480 <log_write>
801014da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014dd:	83 c4 10             	add    $0x10,%esp
801014e0:	eb c2                	jmp    801014a4 <bmap+0x44>
801014e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014e8:	8b 06                	mov    (%esi),%eax
801014ea:	e8 61 fd ff ff       	call   80101250 <balloc>
801014ef:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014f5:	eb 93                	jmp    8010148a <bmap+0x2a>
801014f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014fe:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
80101500:	8d 5a 14             	lea    0x14(%edx),%ebx
80101503:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101507:	85 ff                	test   %edi,%edi
80101509:	75 a5                	jne    801014b0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010150b:	8b 00                	mov    (%eax),%eax
8010150d:	e8 3e fd ff ff       	call   80101250 <balloc>
80101512:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101516:	89 c7                	mov    %eax,%edi
}
80101518:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010151b:	5b                   	pop    %ebx
8010151c:	89 f8                	mov    %edi,%eax
8010151e:	5e                   	pop    %esi
8010151f:	5f                   	pop    %edi
80101520:	5d                   	pop    %ebp
80101521:	c3                   	ret    
  panic("bmap: out of range");
80101522:	83 ec 0c             	sub    $0xc,%esp
80101525:	68 58 7f 10 80       	push   $0x80107f58
8010152a:	e8 51 ee ff ff       	call   80100380 <panic>
8010152f:	90                   	nop

80101530 <readsb>:
{
80101530:	55                   	push   %ebp
80101531:	89 e5                	mov    %esp,%ebp
80101533:	56                   	push   %esi
80101534:	53                   	push   %ebx
80101535:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101538:	83 ec 08             	sub    $0x8,%esp
8010153b:	6a 01                	push   $0x1
8010153d:	ff 75 08             	push   0x8(%ebp)
80101540:	e8 8b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101545:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101548:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010154a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010154d:	6a 24                	push   $0x24
8010154f:	50                   	push   %eax
80101550:	56                   	push   %esi
80101551:	e8 1a 3a 00 00       	call   80104f70 <memmove>
  brelse(bp);
80101556:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101559:	83 c4 10             	add    $0x10,%esp
}
8010155c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010155f:	5b                   	pop    %ebx
80101560:	5e                   	pop    %esi
80101561:	5d                   	pop    %ebp
  brelse(bp);
80101562:	e9 89 ec ff ff       	jmp    801001f0 <brelse>
80101567:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010156e:	66 90                	xchg   %ax,%ax

80101570 <iinit>:
{
80101570:	55                   	push   %ebp
80101571:	89 e5                	mov    %esp,%ebp
80101573:	53                   	push   %ebx
80101574:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101579:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010157c:	68 6b 7f 10 80       	push   $0x80107f6b
80101581:	68 60 09 11 80       	push   $0x80110960
80101586:	e8 b5 36 00 00       	call   80104c40 <initlock>
  for(i = 0; i < NINODE; i++) {
8010158b:	83 c4 10             	add    $0x10,%esp
8010158e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101590:	83 ec 08             	sub    $0x8,%esp
80101593:	68 72 7f 10 80       	push   $0x80107f72
80101598:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101599:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010159f:	e8 6c 35 00 00       	call   80104b10 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015a4:	83 c4 10             	add    $0x10,%esp
801015a7:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
801015ad:	75 e1                	jne    80101590 <iinit+0x20>
  bp = bread(dev, 1);
801015af:	83 ec 08             	sub    $0x8,%esp
801015b2:	6a 01                	push   $0x1
801015b4:	ff 75 08             	push   0x8(%ebp)
801015b7:	e8 14 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015bc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015bf:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015c1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015c4:	6a 24                	push   $0x24
801015c6:	50                   	push   %eax
801015c7:	68 c0 25 11 80       	push   $0x801125c0
801015cc:	e8 9f 39 00 00       	call   80104f70 <memmove>
  brelse(bp);
801015d1:	89 1c 24             	mov    %ebx,(%esp)
801015d4:	e8 17 ec ff ff       	call   801001f0 <brelse>
  initpageswap(sb.swapstart);
801015d9:	58                   	pop    %eax
801015da:	ff 35 e0 25 11 80    	push   0x801125e0
801015e0:	e8 fb 64 00 00       	call   80107ae0 <initpageswap>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d nswap %d logstart %d\
801015e5:	5a                   	pop    %edx
801015e6:	59                   	pop    %ecx
801015e7:	ff 35 e0 25 11 80    	push   0x801125e0
801015ed:	ff 35 dc 25 11 80    	push   0x801125dc
801015f3:	ff 35 d8 25 11 80    	push   0x801125d8
801015f9:	ff 35 d4 25 11 80    	push   0x801125d4
801015ff:	ff 35 d0 25 11 80    	push   0x801125d0
80101605:	ff 35 cc 25 11 80    	push   0x801125cc
8010160b:	ff 35 c8 25 11 80    	push   0x801125c8
80101611:	ff 35 c4 25 11 80    	push   0x801125c4
80101617:	ff 35 c0 25 11 80    	push   0x801125c0
8010161d:	68 d8 7f 10 80       	push   $0x80107fd8
80101622:	e8 79 f0 ff ff       	call   801006a0 <cprintf>
}
80101627:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010162a:	83 c4 30             	add    $0x30,%esp
8010162d:	c9                   	leave  
8010162e:	c3                   	ret    
8010162f:	90                   	nop

80101630 <ialloc>:
{
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	57                   	push   %edi
80101634:	56                   	push   %esi
80101635:	53                   	push   %ebx
80101636:	83 ec 1c             	sub    $0x1c,%esp
80101639:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010163c:	83 3d c8 25 11 80 01 	cmpl   $0x1,0x801125c8
{
80101643:	8b 75 08             	mov    0x8(%ebp),%esi
80101646:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101649:	0f 86 91 00 00 00    	jbe    801016e0 <ialloc+0xb0>
8010164f:	bf 01 00 00 00       	mov    $0x1,%edi
80101654:	eb 21                	jmp    80101677 <ialloc+0x47>
80101656:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010165d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101660:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101663:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101666:	53                   	push   %ebx
80101667:	e8 84 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010166c:	83 c4 10             	add    $0x10,%esp
8010166f:	3b 3d c8 25 11 80    	cmp    0x801125c8,%edi
80101675:	73 69                	jae    801016e0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101677:	89 f8                	mov    %edi,%eax
80101679:	83 ec 08             	sub    $0x8,%esp
8010167c:	c1 e8 03             	shr    $0x3,%eax
8010167f:	03 05 d8 25 11 80    	add    0x801125d8,%eax
80101685:	50                   	push   %eax
80101686:	56                   	push   %esi
80101687:	e8 44 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010168c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010168f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101691:	89 f8                	mov    %edi,%eax
80101693:	83 e0 07             	and    $0x7,%eax
80101696:	c1 e0 06             	shl    $0x6,%eax
80101699:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010169d:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016a1:	75 bd                	jne    80101660 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016a3:	83 ec 04             	sub    $0x4,%esp
801016a6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016a9:	6a 40                	push   $0x40
801016ab:	6a 00                	push   $0x0
801016ad:	51                   	push   %ecx
801016ae:	e8 1d 38 00 00       	call   80104ed0 <memset>
      dip->type = type;
801016b3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016b7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016ba:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016bd:	89 1c 24             	mov    %ebx,(%esp)
801016c0:	e8 bb 1d 00 00       	call   80103480 <log_write>
      brelse(bp);
801016c5:	89 1c 24             	mov    %ebx,(%esp)
801016c8:	e8 23 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016cd:	83 c4 10             	add    $0x10,%esp
}
801016d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016d3:	89 fa                	mov    %edi,%edx
}
801016d5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016d6:	89 f0                	mov    %esi,%eax
}
801016d8:	5e                   	pop    %esi
801016d9:	5f                   	pop    %edi
801016da:	5d                   	pop    %ebp
      return iget(dev, inum);
801016db:	e9 80 fc ff ff       	jmp    80101360 <iget>
  panic("ialloc: no inodes");
801016e0:	83 ec 0c             	sub    $0xc,%esp
801016e3:	68 78 7f 10 80       	push   $0x80107f78
801016e8:	e8 93 ec ff ff       	call   80100380 <panic>
801016ed:	8d 76 00             	lea    0x0(%esi),%esi

801016f0 <iupdate>:
{
801016f0:	55                   	push   %ebp
801016f1:	89 e5                	mov    %esp,%ebp
801016f3:	56                   	push   %esi
801016f4:	53                   	push   %ebx
801016f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016f8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016fb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fe:	83 ec 08             	sub    $0x8,%esp
80101701:	c1 e8 03             	shr    $0x3,%eax
80101704:	03 05 d8 25 11 80    	add    0x801125d8,%eax
8010170a:	50                   	push   %eax
8010170b:	ff 73 a4             	push   -0x5c(%ebx)
8010170e:	e8 bd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101713:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101717:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010171a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010171c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010171f:	83 e0 07             	and    $0x7,%eax
80101722:	c1 e0 06             	shl    $0x6,%eax
80101725:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101729:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010172c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101730:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101733:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101737:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010173b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010173f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101743:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101747:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010174a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010174d:	6a 34                	push   $0x34
8010174f:	53                   	push   %ebx
80101750:	50                   	push   %eax
80101751:	e8 1a 38 00 00       	call   80104f70 <memmove>
  log_write(bp);
80101756:	89 34 24             	mov    %esi,(%esp)
80101759:	e8 22 1d 00 00       	call   80103480 <log_write>
  brelse(bp);
8010175e:	89 75 08             	mov    %esi,0x8(%ebp)
80101761:	83 c4 10             	add    $0x10,%esp
}
80101764:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101767:	5b                   	pop    %ebx
80101768:	5e                   	pop    %esi
80101769:	5d                   	pop    %ebp
  brelse(bp);
8010176a:	e9 81 ea ff ff       	jmp    801001f0 <brelse>
8010176f:	90                   	nop

80101770 <idup>:
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	53                   	push   %ebx
80101774:	83 ec 10             	sub    $0x10,%esp
80101777:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010177a:	68 60 09 11 80       	push   $0x80110960
8010177f:	e8 8c 36 00 00       	call   80104e10 <acquire>
  ip->ref++;
80101784:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101788:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010178f:	e8 1c 36 00 00       	call   80104db0 <release>
}
80101794:	89 d8                	mov    %ebx,%eax
80101796:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101799:	c9                   	leave  
8010179a:	c3                   	ret    
8010179b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010179f:	90                   	nop

801017a0 <ilock>:
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	56                   	push   %esi
801017a4:	53                   	push   %ebx
801017a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017a8:	85 db                	test   %ebx,%ebx
801017aa:	0f 84 b7 00 00 00    	je     80101867 <ilock+0xc7>
801017b0:	8b 53 08             	mov    0x8(%ebx),%edx
801017b3:	85 d2                	test   %edx,%edx
801017b5:	0f 8e ac 00 00 00    	jle    80101867 <ilock+0xc7>
  acquiresleep(&ip->lock);
801017bb:	83 ec 0c             	sub    $0xc,%esp
801017be:	8d 43 0c             	lea    0xc(%ebx),%eax
801017c1:	50                   	push   %eax
801017c2:	e8 89 33 00 00       	call   80104b50 <acquiresleep>
  if(ip->valid == 0){
801017c7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017ca:	83 c4 10             	add    $0x10,%esp
801017cd:	85 c0                	test   %eax,%eax
801017cf:	74 0f                	je     801017e0 <ilock+0x40>
}
801017d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017d4:	5b                   	pop    %ebx
801017d5:	5e                   	pop    %esi
801017d6:	5d                   	pop    %ebp
801017d7:	c3                   	ret    
801017d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017df:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017e0:	8b 43 04             	mov    0x4(%ebx),%eax
801017e3:	83 ec 08             	sub    $0x8,%esp
801017e6:	c1 e8 03             	shr    $0x3,%eax
801017e9:	03 05 d8 25 11 80    	add    0x801125d8,%eax
801017ef:	50                   	push   %eax
801017f0:	ff 33                	push   (%ebx)
801017f2:	e8 d9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017f7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017fa:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017fc:	8b 43 04             	mov    0x4(%ebx),%eax
801017ff:	83 e0 07             	and    $0x7,%eax
80101802:	c1 e0 06             	shl    $0x6,%eax
80101805:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101809:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010180c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010180f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101813:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101817:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010181b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010181f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101823:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101827:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010182b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010182e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101831:	6a 34                	push   $0x34
80101833:	50                   	push   %eax
80101834:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101837:	50                   	push   %eax
80101838:	e8 33 37 00 00       	call   80104f70 <memmove>
    brelse(bp);
8010183d:	89 34 24             	mov    %esi,(%esp)
80101840:	e8 ab e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101845:	83 c4 10             	add    $0x10,%esp
80101848:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010184d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101854:	0f 85 77 ff ff ff    	jne    801017d1 <ilock+0x31>
      panic("ilock: no type");
8010185a:	83 ec 0c             	sub    $0xc,%esp
8010185d:	68 90 7f 10 80       	push   $0x80107f90
80101862:	e8 19 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101867:	83 ec 0c             	sub    $0xc,%esp
8010186a:	68 8a 7f 10 80       	push   $0x80107f8a
8010186f:	e8 0c eb ff ff       	call   80100380 <panic>
80101874:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010187b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010187f:	90                   	nop

80101880 <iunlock>:
{
80101880:	55                   	push   %ebp
80101881:	89 e5                	mov    %esp,%ebp
80101883:	56                   	push   %esi
80101884:	53                   	push   %ebx
80101885:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101888:	85 db                	test   %ebx,%ebx
8010188a:	74 28                	je     801018b4 <iunlock+0x34>
8010188c:	83 ec 0c             	sub    $0xc,%esp
8010188f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101892:	56                   	push   %esi
80101893:	e8 58 33 00 00       	call   80104bf0 <holdingsleep>
80101898:	83 c4 10             	add    $0x10,%esp
8010189b:	85 c0                	test   %eax,%eax
8010189d:	74 15                	je     801018b4 <iunlock+0x34>
8010189f:	8b 43 08             	mov    0x8(%ebx),%eax
801018a2:	85 c0                	test   %eax,%eax
801018a4:	7e 0e                	jle    801018b4 <iunlock+0x34>
  releasesleep(&ip->lock);
801018a6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018ac:	5b                   	pop    %ebx
801018ad:	5e                   	pop    %esi
801018ae:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018af:	e9 fc 32 00 00       	jmp    80104bb0 <releasesleep>
    panic("iunlock");
801018b4:	83 ec 0c             	sub    $0xc,%esp
801018b7:	68 9f 7f 10 80       	push   $0x80107f9f
801018bc:	e8 bf ea ff ff       	call   80100380 <panic>
801018c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018cf:	90                   	nop

801018d0 <iput>:
{
801018d0:	55                   	push   %ebp
801018d1:	89 e5                	mov    %esp,%ebp
801018d3:	57                   	push   %edi
801018d4:	56                   	push   %esi
801018d5:	53                   	push   %ebx
801018d6:	83 ec 28             	sub    $0x28,%esp
801018d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018dc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018df:	57                   	push   %edi
801018e0:	e8 6b 32 00 00       	call   80104b50 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018e5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018e8:	83 c4 10             	add    $0x10,%esp
801018eb:	85 d2                	test   %edx,%edx
801018ed:	74 07                	je     801018f6 <iput+0x26>
801018ef:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018f4:	74 32                	je     80101928 <iput+0x58>
  releasesleep(&ip->lock);
801018f6:	83 ec 0c             	sub    $0xc,%esp
801018f9:	57                   	push   %edi
801018fa:	e8 b1 32 00 00       	call   80104bb0 <releasesleep>
  acquire(&icache.lock);
801018ff:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101906:	e8 05 35 00 00       	call   80104e10 <acquire>
  ip->ref--;
8010190b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010190f:	83 c4 10             	add    $0x10,%esp
80101912:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
80101919:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010191c:	5b                   	pop    %ebx
8010191d:	5e                   	pop    %esi
8010191e:	5f                   	pop    %edi
8010191f:	5d                   	pop    %ebp
  release(&icache.lock);
80101920:	e9 8b 34 00 00       	jmp    80104db0 <release>
80101925:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101928:	83 ec 0c             	sub    $0xc,%esp
8010192b:	68 60 09 11 80       	push   $0x80110960
80101930:	e8 db 34 00 00       	call   80104e10 <acquire>
    int r = ip->ref;
80101935:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101938:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010193f:	e8 6c 34 00 00       	call   80104db0 <release>
    if(r == 1){
80101944:	83 c4 10             	add    $0x10,%esp
80101947:	83 fe 01             	cmp    $0x1,%esi
8010194a:	75 aa                	jne    801018f6 <iput+0x26>
8010194c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101952:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101955:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101958:	89 cf                	mov    %ecx,%edi
8010195a:	eb 0b                	jmp    80101967 <iput+0x97>
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101960:	83 c6 04             	add    $0x4,%esi
80101963:	39 fe                	cmp    %edi,%esi
80101965:	74 19                	je     80101980 <iput+0xb0>
    if(ip->addrs[i]){
80101967:	8b 16                	mov    (%esi),%edx
80101969:	85 d2                	test   %edx,%edx
8010196b:	74 f3                	je     80101960 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010196d:	8b 03                	mov    (%ebx),%eax
8010196f:	e8 5c f8 ff ff       	call   801011d0 <bfree>
      ip->addrs[i] = 0;
80101974:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010197a:	eb e4                	jmp    80101960 <iput+0x90>
8010197c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101980:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101986:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101989:	85 c0                	test   %eax,%eax
8010198b:	75 2d                	jne    801019ba <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010198d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101990:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101997:	53                   	push   %ebx
80101998:	e8 53 fd ff ff       	call   801016f0 <iupdate>
      ip->type = 0;
8010199d:	31 c0                	xor    %eax,%eax
8010199f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801019a3:	89 1c 24             	mov    %ebx,(%esp)
801019a6:	e8 45 fd ff ff       	call   801016f0 <iupdate>
      ip->valid = 0;
801019ab:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801019b2:	83 c4 10             	add    $0x10,%esp
801019b5:	e9 3c ff ff ff       	jmp    801018f6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019ba:	83 ec 08             	sub    $0x8,%esp
801019bd:	50                   	push   %eax
801019be:	ff 33                	push   (%ebx)
801019c0:	e8 0b e7 ff ff       	call   801000d0 <bread>
801019c5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019c8:	83 c4 10             	add    $0x10,%esp
801019cb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019d4:	8d 70 5c             	lea    0x5c(%eax),%esi
801019d7:	89 cf                	mov    %ecx,%edi
801019d9:	eb 0c                	jmp    801019e7 <iput+0x117>
801019db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019df:	90                   	nop
801019e0:	83 c6 04             	add    $0x4,%esi
801019e3:	39 f7                	cmp    %esi,%edi
801019e5:	74 0f                	je     801019f6 <iput+0x126>
      if(a[j])
801019e7:	8b 16                	mov    (%esi),%edx
801019e9:	85 d2                	test   %edx,%edx
801019eb:	74 f3                	je     801019e0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019ed:	8b 03                	mov    (%ebx),%eax
801019ef:	e8 dc f7 ff ff       	call   801011d0 <bfree>
801019f4:	eb ea                	jmp    801019e0 <iput+0x110>
    brelse(bp);
801019f6:	83 ec 0c             	sub    $0xc,%esp
801019f9:	ff 75 e4             	push   -0x1c(%ebp)
801019fc:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019ff:	e8 ec e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a04:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a0a:	8b 03                	mov    (%ebx),%eax
80101a0c:	e8 bf f7 ff ff       	call   801011d0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a11:	83 c4 10             	add    $0x10,%esp
80101a14:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a1b:	00 00 00 
80101a1e:	e9 6a ff ff ff       	jmp    8010198d <iput+0xbd>
80101a23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a30 <iunlockput>:
{
80101a30:	55                   	push   %ebp
80101a31:	89 e5                	mov    %esp,%ebp
80101a33:	56                   	push   %esi
80101a34:	53                   	push   %ebx
80101a35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a38:	85 db                	test   %ebx,%ebx
80101a3a:	74 34                	je     80101a70 <iunlockput+0x40>
80101a3c:	83 ec 0c             	sub    $0xc,%esp
80101a3f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a42:	56                   	push   %esi
80101a43:	e8 a8 31 00 00       	call   80104bf0 <holdingsleep>
80101a48:	83 c4 10             	add    $0x10,%esp
80101a4b:	85 c0                	test   %eax,%eax
80101a4d:	74 21                	je     80101a70 <iunlockput+0x40>
80101a4f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a52:	85 c0                	test   %eax,%eax
80101a54:	7e 1a                	jle    80101a70 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a56:	83 ec 0c             	sub    $0xc,%esp
80101a59:	56                   	push   %esi
80101a5a:	e8 51 31 00 00       	call   80104bb0 <releasesleep>
  iput(ip);
80101a5f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a62:	83 c4 10             	add    $0x10,%esp
}
80101a65:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a68:	5b                   	pop    %ebx
80101a69:	5e                   	pop    %esi
80101a6a:	5d                   	pop    %ebp
  iput(ip);
80101a6b:	e9 60 fe ff ff       	jmp    801018d0 <iput>
    panic("iunlock");
80101a70:	83 ec 0c             	sub    $0xc,%esp
80101a73:	68 9f 7f 10 80       	push   $0x80107f9f
80101a78:	e8 03 e9 ff ff       	call   80100380 <panic>
80101a7d:	8d 76 00             	lea    0x0(%esi),%esi

80101a80 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a80:	55                   	push   %ebp
80101a81:	89 e5                	mov    %esp,%ebp
80101a83:	8b 55 08             	mov    0x8(%ebp),%edx
80101a86:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a89:	8b 0a                	mov    (%edx),%ecx
80101a8b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a8e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a91:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a94:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a98:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a9b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a9f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101aa3:	8b 52 58             	mov    0x58(%edx),%edx
80101aa6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101aa9:	5d                   	pop    %ebp
80101aaa:	c3                   	ret    
80101aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aaf:	90                   	nop

80101ab0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ab0:	55                   	push   %ebp
80101ab1:	89 e5                	mov    %esp,%ebp
80101ab3:	57                   	push   %edi
80101ab4:	56                   	push   %esi
80101ab5:	53                   	push   %ebx
80101ab6:	83 ec 1c             	sub    $0x1c,%esp
80101ab9:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101abc:	8b 45 08             	mov    0x8(%ebp),%eax
80101abf:	8b 75 10             	mov    0x10(%ebp),%esi
80101ac2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101ac5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ac8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101acd:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ad0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ad3:	0f 84 a7 00 00 00    	je     80101b80 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ad9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101adc:	8b 40 58             	mov    0x58(%eax),%eax
80101adf:	39 c6                	cmp    %eax,%esi
80101ae1:	0f 87 ba 00 00 00    	ja     80101ba1 <readi+0xf1>
80101ae7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aea:	31 c9                	xor    %ecx,%ecx
80101aec:	89 da                	mov    %ebx,%edx
80101aee:	01 f2                	add    %esi,%edx
80101af0:	0f 92 c1             	setb   %cl
80101af3:	89 cf                	mov    %ecx,%edi
80101af5:	0f 82 a6 00 00 00    	jb     80101ba1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101afb:	89 c1                	mov    %eax,%ecx
80101afd:	29 f1                	sub    %esi,%ecx
80101aff:	39 d0                	cmp    %edx,%eax
80101b01:	0f 43 cb             	cmovae %ebx,%ecx
80101b04:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b07:	85 c9                	test   %ecx,%ecx
80101b09:	74 67                	je     80101b72 <readi+0xc2>
80101b0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b0f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b10:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b13:	89 f2                	mov    %esi,%edx
80101b15:	c1 ea 09             	shr    $0x9,%edx
80101b18:	89 d8                	mov    %ebx,%eax
80101b1a:	e8 41 f9 ff ff       	call   80101460 <bmap>
80101b1f:	83 ec 08             	sub    $0x8,%esp
80101b22:	50                   	push   %eax
80101b23:	ff 33                	push   (%ebx)
80101b25:	e8 a6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b2a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b2d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b32:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b34:	89 f0                	mov    %esi,%eax
80101b36:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b3b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b3d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b40:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b42:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b46:	39 d9                	cmp    %ebx,%ecx
80101b48:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b4b:	83 c4 0c             	add    $0xc,%esp
80101b4e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b4f:	01 df                	add    %ebx,%edi
80101b51:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b53:	50                   	push   %eax
80101b54:	ff 75 e0             	push   -0x20(%ebp)
80101b57:	e8 14 34 00 00       	call   80104f70 <memmove>
    brelse(bp);
80101b5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b5f:	89 14 24             	mov    %edx,(%esp)
80101b62:	e8 89 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b67:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b6a:	83 c4 10             	add    $0x10,%esp
80101b6d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b70:	77 9e                	ja     80101b10 <readi+0x60>
  }
  return n;
80101b72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b78:	5b                   	pop    %ebx
80101b79:	5e                   	pop    %esi
80101b7a:	5f                   	pop    %edi
80101b7b:	5d                   	pop    %ebp
80101b7c:	c3                   	ret    
80101b7d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b80:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b84:	66 83 f8 09          	cmp    $0x9,%ax
80101b88:	77 17                	ja     80101ba1 <readi+0xf1>
80101b8a:	8b 04 c5 00 09 11 80 	mov    -0x7feef700(,%eax,8),%eax
80101b91:	85 c0                	test   %eax,%eax
80101b93:	74 0c                	je     80101ba1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b95:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b9b:	5b                   	pop    %ebx
80101b9c:	5e                   	pop    %esi
80101b9d:	5f                   	pop    %edi
80101b9e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b9f:	ff e0                	jmp    *%eax
      return -1;
80101ba1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ba6:	eb cd                	jmp    80101b75 <readi+0xc5>
80101ba8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101baf:	90                   	nop

80101bb0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	57                   	push   %edi
80101bb4:	56                   	push   %esi
80101bb5:	53                   	push   %ebx
80101bb6:	83 ec 1c             	sub    $0x1c,%esp
80101bb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bbc:	8b 75 0c             	mov    0xc(%ebp),%esi
80101bbf:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bc2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bc7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101bca:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bcd:	8b 75 10             	mov    0x10(%ebp),%esi
80101bd0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bd3:	0f 84 b7 00 00 00    	je     80101c90 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bd9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bdc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bdf:	0f 87 e7 00 00 00    	ja     80101ccc <writei+0x11c>
80101be5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101be8:	31 d2                	xor    %edx,%edx
80101bea:	89 f8                	mov    %edi,%eax
80101bec:	01 f0                	add    %esi,%eax
80101bee:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bf1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bf6:	0f 87 d0 00 00 00    	ja     80101ccc <writei+0x11c>
80101bfc:	85 d2                	test   %edx,%edx
80101bfe:	0f 85 c8 00 00 00    	jne    80101ccc <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c04:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101c0b:	85 ff                	test   %edi,%edi
80101c0d:	74 72                	je     80101c81 <writei+0xd1>
80101c0f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c10:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101c13:	89 f2                	mov    %esi,%edx
80101c15:	c1 ea 09             	shr    $0x9,%edx
80101c18:	89 f8                	mov    %edi,%eax
80101c1a:	e8 41 f8 ff ff       	call   80101460 <bmap>
80101c1f:	83 ec 08             	sub    $0x8,%esp
80101c22:	50                   	push   %eax
80101c23:	ff 37                	push   (%edi)
80101c25:	e8 a6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c2a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c2f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c32:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c35:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c37:	89 f0                	mov    %esi,%eax
80101c39:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c3e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c40:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c44:	39 d9                	cmp    %ebx,%ecx
80101c46:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c49:	83 c4 0c             	add    $0xc,%esp
80101c4c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c4d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c4f:	ff 75 dc             	push   -0x24(%ebp)
80101c52:	50                   	push   %eax
80101c53:	e8 18 33 00 00       	call   80104f70 <memmove>
    log_write(bp);
80101c58:	89 3c 24             	mov    %edi,(%esp)
80101c5b:	e8 20 18 00 00       	call   80103480 <log_write>
    brelse(bp);
80101c60:	89 3c 24             	mov    %edi,(%esp)
80101c63:	e8 88 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c68:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c6b:	83 c4 10             	add    $0x10,%esp
80101c6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c71:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c74:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c77:	77 97                	ja     80101c10 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c79:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c7c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c7f:	77 37                	ja     80101cb8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c81:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c84:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c87:	5b                   	pop    %ebx
80101c88:	5e                   	pop    %esi
80101c89:	5f                   	pop    %edi
80101c8a:	5d                   	pop    %ebp
80101c8b:	c3                   	ret    
80101c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c90:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c94:	66 83 f8 09          	cmp    $0x9,%ax
80101c98:	77 32                	ja     80101ccc <writei+0x11c>
80101c9a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101ca1:	85 c0                	test   %eax,%eax
80101ca3:	74 27                	je     80101ccc <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101ca5:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101ca8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cab:	5b                   	pop    %ebx
80101cac:	5e                   	pop    %esi
80101cad:	5f                   	pop    %edi
80101cae:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101caf:	ff e0                	jmp    *%eax
80101cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101cb8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101cbb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101cbe:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101cc1:	50                   	push   %eax
80101cc2:	e8 29 fa ff ff       	call   801016f0 <iupdate>
80101cc7:	83 c4 10             	add    $0x10,%esp
80101cca:	eb b5                	jmp    80101c81 <writei+0xd1>
      return -1;
80101ccc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cd1:	eb b1                	jmp    80101c84 <writei+0xd4>
80101cd3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ce0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101ce6:	6a 0e                	push   $0xe
80101ce8:	ff 75 0c             	push   0xc(%ebp)
80101ceb:	ff 75 08             	push   0x8(%ebp)
80101cee:	e8 ed 32 00 00       	call   80104fe0 <strncmp>
}
80101cf3:	c9                   	leave  
80101cf4:	c3                   	ret    
80101cf5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101d00 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d00:	55                   	push   %ebp
80101d01:	89 e5                	mov    %esp,%ebp
80101d03:	57                   	push   %edi
80101d04:	56                   	push   %esi
80101d05:	53                   	push   %ebx
80101d06:	83 ec 1c             	sub    $0x1c,%esp
80101d09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d0c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d11:	0f 85 85 00 00 00    	jne    80101d9c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d17:	8b 53 58             	mov    0x58(%ebx),%edx
80101d1a:	31 ff                	xor    %edi,%edi
80101d1c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d1f:	85 d2                	test   %edx,%edx
80101d21:	74 3e                	je     80101d61 <dirlookup+0x61>
80101d23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d27:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d28:	6a 10                	push   $0x10
80101d2a:	57                   	push   %edi
80101d2b:	56                   	push   %esi
80101d2c:	53                   	push   %ebx
80101d2d:	e8 7e fd ff ff       	call   80101ab0 <readi>
80101d32:	83 c4 10             	add    $0x10,%esp
80101d35:	83 f8 10             	cmp    $0x10,%eax
80101d38:	75 55                	jne    80101d8f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d3a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d3f:	74 18                	je     80101d59 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d41:	83 ec 04             	sub    $0x4,%esp
80101d44:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d47:	6a 0e                	push   $0xe
80101d49:	50                   	push   %eax
80101d4a:	ff 75 0c             	push   0xc(%ebp)
80101d4d:	e8 8e 32 00 00       	call   80104fe0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d52:	83 c4 10             	add    $0x10,%esp
80101d55:	85 c0                	test   %eax,%eax
80101d57:	74 17                	je     80101d70 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d59:	83 c7 10             	add    $0x10,%edi
80101d5c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d5f:	72 c7                	jb     80101d28 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d64:	31 c0                	xor    %eax,%eax
}
80101d66:	5b                   	pop    %ebx
80101d67:	5e                   	pop    %esi
80101d68:	5f                   	pop    %edi
80101d69:	5d                   	pop    %ebp
80101d6a:	c3                   	ret    
80101d6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d6f:	90                   	nop
      if(poff)
80101d70:	8b 45 10             	mov    0x10(%ebp),%eax
80101d73:	85 c0                	test   %eax,%eax
80101d75:	74 05                	je     80101d7c <dirlookup+0x7c>
        *poff = off;
80101d77:	8b 45 10             	mov    0x10(%ebp),%eax
80101d7a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d7c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d80:	8b 03                	mov    (%ebx),%eax
80101d82:	e8 d9 f5 ff ff       	call   80101360 <iget>
}
80101d87:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d8a:	5b                   	pop    %ebx
80101d8b:	5e                   	pop    %esi
80101d8c:	5f                   	pop    %edi
80101d8d:	5d                   	pop    %ebp
80101d8e:	c3                   	ret    
      panic("dirlookup read");
80101d8f:	83 ec 0c             	sub    $0xc,%esp
80101d92:	68 b9 7f 10 80       	push   $0x80107fb9
80101d97:	e8 e4 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d9c:	83 ec 0c             	sub    $0xc,%esp
80101d9f:	68 a7 7f 10 80       	push   $0x80107fa7
80101da4:	e8 d7 e5 ff ff       	call   80100380 <panic>
80101da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101db0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101db0:	55                   	push   %ebp
80101db1:	89 e5                	mov    %esp,%ebp
80101db3:	57                   	push   %edi
80101db4:	56                   	push   %esi
80101db5:	53                   	push   %ebx
80101db6:	89 c3                	mov    %eax,%ebx
80101db8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101dbb:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101dbe:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101dc1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101dc4:	0f 84 64 01 00 00    	je     80101f2e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101dca:	e8 e1 20 00 00       	call   80103eb0 <myproc>
  acquire(&icache.lock);
80101dcf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101dd2:	8b 70 6c             	mov    0x6c(%eax),%esi
  acquire(&icache.lock);
80101dd5:	68 60 09 11 80       	push   $0x80110960
80101dda:	e8 31 30 00 00       	call   80104e10 <acquire>
  ip->ref++;
80101ddf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101de3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101dea:	e8 c1 2f 00 00       	call   80104db0 <release>
80101def:	83 c4 10             	add    $0x10,%esp
80101df2:	eb 07                	jmp    80101dfb <namex+0x4b>
80101df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101df8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101dfb:	0f b6 03             	movzbl (%ebx),%eax
80101dfe:	3c 2f                	cmp    $0x2f,%al
80101e00:	74 f6                	je     80101df8 <namex+0x48>
  if(*path == 0)
80101e02:	84 c0                	test   %al,%al
80101e04:	0f 84 06 01 00 00    	je     80101f10 <namex+0x160>
  while(*path != '/' && *path != 0)
80101e0a:	0f b6 03             	movzbl (%ebx),%eax
80101e0d:	84 c0                	test   %al,%al
80101e0f:	0f 84 10 01 00 00    	je     80101f25 <namex+0x175>
80101e15:	89 df                	mov    %ebx,%edi
80101e17:	3c 2f                	cmp    $0x2f,%al
80101e19:	0f 84 06 01 00 00    	je     80101f25 <namex+0x175>
80101e1f:	90                   	nop
80101e20:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e24:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e27:	3c 2f                	cmp    $0x2f,%al
80101e29:	74 04                	je     80101e2f <namex+0x7f>
80101e2b:	84 c0                	test   %al,%al
80101e2d:	75 f1                	jne    80101e20 <namex+0x70>
  len = path - s;
80101e2f:	89 f8                	mov    %edi,%eax
80101e31:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e33:	83 f8 0d             	cmp    $0xd,%eax
80101e36:	0f 8e ac 00 00 00    	jle    80101ee8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e3c:	83 ec 04             	sub    $0x4,%esp
80101e3f:	6a 0e                	push   $0xe
80101e41:	53                   	push   %ebx
    path++;
80101e42:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e44:	ff 75 e4             	push   -0x1c(%ebp)
80101e47:	e8 24 31 00 00       	call   80104f70 <memmove>
80101e4c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e4f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e52:	75 0c                	jne    80101e60 <namex+0xb0>
80101e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e58:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e5b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e5e:	74 f8                	je     80101e58 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e60:	83 ec 0c             	sub    $0xc,%esp
80101e63:	56                   	push   %esi
80101e64:	e8 37 f9 ff ff       	call   801017a0 <ilock>
    if(ip->type != T_DIR){
80101e69:	83 c4 10             	add    $0x10,%esp
80101e6c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e71:	0f 85 cd 00 00 00    	jne    80101f44 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e77:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e7a:	85 c0                	test   %eax,%eax
80101e7c:	74 09                	je     80101e87 <namex+0xd7>
80101e7e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e81:	0f 84 22 01 00 00    	je     80101fa9 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e87:	83 ec 04             	sub    $0x4,%esp
80101e8a:	6a 00                	push   $0x0
80101e8c:	ff 75 e4             	push   -0x1c(%ebp)
80101e8f:	56                   	push   %esi
80101e90:	e8 6b fe ff ff       	call   80101d00 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e95:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101e98:	83 c4 10             	add    $0x10,%esp
80101e9b:	89 c7                	mov    %eax,%edi
80101e9d:	85 c0                	test   %eax,%eax
80101e9f:	0f 84 e1 00 00 00    	je     80101f86 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ea5:	83 ec 0c             	sub    $0xc,%esp
80101ea8:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101eab:	52                   	push   %edx
80101eac:	e8 3f 2d 00 00       	call   80104bf0 <holdingsleep>
80101eb1:	83 c4 10             	add    $0x10,%esp
80101eb4:	85 c0                	test   %eax,%eax
80101eb6:	0f 84 30 01 00 00    	je     80101fec <namex+0x23c>
80101ebc:	8b 56 08             	mov    0x8(%esi),%edx
80101ebf:	85 d2                	test   %edx,%edx
80101ec1:	0f 8e 25 01 00 00    	jle    80101fec <namex+0x23c>
  releasesleep(&ip->lock);
80101ec7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eca:	83 ec 0c             	sub    $0xc,%esp
80101ecd:	52                   	push   %edx
80101ece:	e8 dd 2c 00 00       	call   80104bb0 <releasesleep>
  iput(ip);
80101ed3:	89 34 24             	mov    %esi,(%esp)
80101ed6:	89 fe                	mov    %edi,%esi
80101ed8:	e8 f3 f9 ff ff       	call   801018d0 <iput>
80101edd:	83 c4 10             	add    $0x10,%esp
80101ee0:	e9 16 ff ff ff       	jmp    80101dfb <namex+0x4b>
80101ee5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ee8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101eeb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101eee:	83 ec 04             	sub    $0x4,%esp
80101ef1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ef4:	50                   	push   %eax
80101ef5:	53                   	push   %ebx
    name[len] = 0;
80101ef6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ef8:	ff 75 e4             	push   -0x1c(%ebp)
80101efb:	e8 70 30 00 00       	call   80104f70 <memmove>
    name[len] = 0;
80101f00:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101f03:	83 c4 10             	add    $0x10,%esp
80101f06:	c6 02 00             	movb   $0x0,(%edx)
80101f09:	e9 41 ff ff ff       	jmp    80101e4f <namex+0x9f>
80101f0e:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101f10:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f13:	85 c0                	test   %eax,%eax
80101f15:	0f 85 be 00 00 00    	jne    80101fd9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f1e:	89 f0                	mov    %esi,%eax
80101f20:	5b                   	pop    %ebx
80101f21:	5e                   	pop    %esi
80101f22:	5f                   	pop    %edi
80101f23:	5d                   	pop    %ebp
80101f24:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f25:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f28:	89 df                	mov    %ebx,%edi
80101f2a:	31 c0                	xor    %eax,%eax
80101f2c:	eb c0                	jmp    80101eee <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f2e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f33:	b8 01 00 00 00       	mov    $0x1,%eax
80101f38:	e8 23 f4 ff ff       	call   80101360 <iget>
80101f3d:	89 c6                	mov    %eax,%esi
80101f3f:	e9 b7 fe ff ff       	jmp    80101dfb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f44:	83 ec 0c             	sub    $0xc,%esp
80101f47:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f4a:	53                   	push   %ebx
80101f4b:	e8 a0 2c 00 00       	call   80104bf0 <holdingsleep>
80101f50:	83 c4 10             	add    $0x10,%esp
80101f53:	85 c0                	test   %eax,%eax
80101f55:	0f 84 91 00 00 00    	je     80101fec <namex+0x23c>
80101f5b:	8b 46 08             	mov    0x8(%esi),%eax
80101f5e:	85 c0                	test   %eax,%eax
80101f60:	0f 8e 86 00 00 00    	jle    80101fec <namex+0x23c>
  releasesleep(&ip->lock);
80101f66:	83 ec 0c             	sub    $0xc,%esp
80101f69:	53                   	push   %ebx
80101f6a:	e8 41 2c 00 00       	call   80104bb0 <releasesleep>
  iput(ip);
80101f6f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f72:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f74:	e8 57 f9 ff ff       	call   801018d0 <iput>
      return 0;
80101f79:	83 c4 10             	add    $0x10,%esp
}
80101f7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f7f:	89 f0                	mov    %esi,%eax
80101f81:	5b                   	pop    %ebx
80101f82:	5e                   	pop    %esi
80101f83:	5f                   	pop    %edi
80101f84:	5d                   	pop    %ebp
80101f85:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f86:	83 ec 0c             	sub    $0xc,%esp
80101f89:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f8c:	52                   	push   %edx
80101f8d:	e8 5e 2c 00 00       	call   80104bf0 <holdingsleep>
80101f92:	83 c4 10             	add    $0x10,%esp
80101f95:	85 c0                	test   %eax,%eax
80101f97:	74 53                	je     80101fec <namex+0x23c>
80101f99:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f9c:	85 c9                	test   %ecx,%ecx
80101f9e:	7e 4c                	jle    80101fec <namex+0x23c>
  releasesleep(&ip->lock);
80101fa0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	52                   	push   %edx
80101fa7:	eb c1                	jmp    80101f6a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fa9:	83 ec 0c             	sub    $0xc,%esp
80101fac:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101faf:	53                   	push   %ebx
80101fb0:	e8 3b 2c 00 00       	call   80104bf0 <holdingsleep>
80101fb5:	83 c4 10             	add    $0x10,%esp
80101fb8:	85 c0                	test   %eax,%eax
80101fba:	74 30                	je     80101fec <namex+0x23c>
80101fbc:	8b 7e 08             	mov    0x8(%esi),%edi
80101fbf:	85 ff                	test   %edi,%edi
80101fc1:	7e 29                	jle    80101fec <namex+0x23c>
  releasesleep(&ip->lock);
80101fc3:	83 ec 0c             	sub    $0xc,%esp
80101fc6:	53                   	push   %ebx
80101fc7:	e8 e4 2b 00 00       	call   80104bb0 <releasesleep>
}
80101fcc:	83 c4 10             	add    $0x10,%esp
}
80101fcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fd2:	89 f0                	mov    %esi,%eax
80101fd4:	5b                   	pop    %ebx
80101fd5:	5e                   	pop    %esi
80101fd6:	5f                   	pop    %edi
80101fd7:	5d                   	pop    %ebp
80101fd8:	c3                   	ret    
    iput(ip);
80101fd9:	83 ec 0c             	sub    $0xc,%esp
80101fdc:	56                   	push   %esi
    return 0;
80101fdd:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fdf:	e8 ec f8 ff ff       	call   801018d0 <iput>
    return 0;
80101fe4:	83 c4 10             	add    $0x10,%esp
80101fe7:	e9 2f ff ff ff       	jmp    80101f1b <namex+0x16b>
    panic("iunlock");
80101fec:	83 ec 0c             	sub    $0xc,%esp
80101fef:	68 9f 7f 10 80       	push   $0x80107f9f
80101ff4:	e8 87 e3 ff ff       	call   80100380 <panic>
80101ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102000 <dirlink>:
{
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	57                   	push   %edi
80102004:	56                   	push   %esi
80102005:	53                   	push   %ebx
80102006:	83 ec 20             	sub    $0x20,%esp
80102009:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010200c:	6a 00                	push   $0x0
8010200e:	ff 75 0c             	push   0xc(%ebp)
80102011:	53                   	push   %ebx
80102012:	e8 e9 fc ff ff       	call   80101d00 <dirlookup>
80102017:	83 c4 10             	add    $0x10,%esp
8010201a:	85 c0                	test   %eax,%eax
8010201c:	75 67                	jne    80102085 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010201e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102021:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102024:	85 ff                	test   %edi,%edi
80102026:	74 29                	je     80102051 <dirlink+0x51>
80102028:	31 ff                	xor    %edi,%edi
8010202a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010202d:	eb 09                	jmp    80102038 <dirlink+0x38>
8010202f:	90                   	nop
80102030:	83 c7 10             	add    $0x10,%edi
80102033:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102036:	73 19                	jae    80102051 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102038:	6a 10                	push   $0x10
8010203a:	57                   	push   %edi
8010203b:	56                   	push   %esi
8010203c:	53                   	push   %ebx
8010203d:	e8 6e fa ff ff       	call   80101ab0 <readi>
80102042:	83 c4 10             	add    $0x10,%esp
80102045:	83 f8 10             	cmp    $0x10,%eax
80102048:	75 4e                	jne    80102098 <dirlink+0x98>
    if(de.inum == 0)
8010204a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010204f:	75 df                	jne    80102030 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102051:	83 ec 04             	sub    $0x4,%esp
80102054:	8d 45 da             	lea    -0x26(%ebp),%eax
80102057:	6a 0e                	push   $0xe
80102059:	ff 75 0c             	push   0xc(%ebp)
8010205c:	50                   	push   %eax
8010205d:	e8 ce 2f 00 00       	call   80105030 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102062:	6a 10                	push   $0x10
  de.inum = inum;
80102064:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102067:	57                   	push   %edi
80102068:	56                   	push   %esi
80102069:	53                   	push   %ebx
  de.inum = inum;
8010206a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010206e:	e8 3d fb ff ff       	call   80101bb0 <writei>
80102073:	83 c4 20             	add    $0x20,%esp
80102076:	83 f8 10             	cmp    $0x10,%eax
80102079:	75 2a                	jne    801020a5 <dirlink+0xa5>
  return 0;
8010207b:	31 c0                	xor    %eax,%eax
}
8010207d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102080:	5b                   	pop    %ebx
80102081:	5e                   	pop    %esi
80102082:	5f                   	pop    %edi
80102083:	5d                   	pop    %ebp
80102084:	c3                   	ret    
    iput(ip);
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	50                   	push   %eax
80102089:	e8 42 f8 ff ff       	call   801018d0 <iput>
    return -1;
8010208e:	83 c4 10             	add    $0x10,%esp
80102091:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102096:	eb e5                	jmp    8010207d <dirlink+0x7d>
      panic("dirlink read");
80102098:	83 ec 0c             	sub    $0xc,%esp
8010209b:	68 c8 7f 10 80       	push   $0x80107fc8
801020a0:	e8 db e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
801020a5:	83 ec 0c             	sub    $0xc,%esp
801020a8:	68 a6 86 10 80       	push   $0x801086a6
801020ad:	e8 ce e2 ff ff       	call   80100380 <panic>
801020b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020c0 <namei>:

struct inode*
namei(char *path)
{
801020c0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020c1:	31 d2                	xor    %edx,%edx
{
801020c3:	89 e5                	mov    %esp,%ebp
801020c5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020c8:	8b 45 08             	mov    0x8(%ebp),%eax
801020cb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020ce:	e8 dd fc ff ff       	call   80101db0 <namex>
}
801020d3:	c9                   	leave  
801020d4:	c3                   	ret    
801020d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020e0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020e0:	55                   	push   %ebp
  return namex(path, 1, name);
801020e1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020e6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020eb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ee:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020ef:	e9 bc fc ff ff       	jmp    80101db0 <namex>
801020f4:	66 90                	xchg   %ax,%ax
801020f6:	66 90                	xchg   %ax,%ax
801020f8:	66 90                	xchg   %ax,%ax
801020fa:	66 90                	xchg   %ax,%ax
801020fc:	66 90                	xchg   %ax,%ax
801020fe:	66 90                	xchg   %ax,%ax

80102100 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102100:	55                   	push   %ebp
80102101:	89 e5                	mov    %esp,%ebp
80102103:	57                   	push   %edi
80102104:	56                   	push   %esi
80102105:	53                   	push   %ebx
80102106:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102109:	85 c0                	test   %eax,%eax
8010210b:	0f 84 b4 00 00 00    	je     801021c5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102111:	8b 70 08             	mov    0x8(%eax),%esi
80102114:	89 c3                	mov    %eax,%ebx
80102116:	81 fe 0f 27 00 00    	cmp    $0x270f,%esi
8010211c:	0f 87 96 00 00 00    	ja     801021b8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102122:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102127:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010212e:	66 90                	xchg   %ax,%ax
80102130:	89 ca                	mov    %ecx,%edx
80102132:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102133:	83 e0 c0             	and    $0xffffffc0,%eax
80102136:	3c 40                	cmp    $0x40,%al
80102138:	75 f6                	jne    80102130 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010213a:	31 ff                	xor    %edi,%edi
8010213c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102141:	89 f8                	mov    %edi,%eax
80102143:	ee                   	out    %al,(%dx)
80102144:	b8 01 00 00 00       	mov    $0x1,%eax
80102149:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010214e:	ee                   	out    %al,(%dx)
8010214f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102154:	89 f0                	mov    %esi,%eax
80102156:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102157:	89 f0                	mov    %esi,%eax
80102159:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010215e:	c1 f8 08             	sar    $0x8,%eax
80102161:	ee                   	out    %al,(%dx)
80102162:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102167:	89 f8                	mov    %edi,%eax
80102169:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010216a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010216e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102173:	c1 e0 04             	shl    $0x4,%eax
80102176:	83 e0 10             	and    $0x10,%eax
80102179:	83 c8 e0             	or     $0xffffffe0,%eax
8010217c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010217d:	f6 03 04             	testb  $0x4,(%ebx)
80102180:	75 16                	jne    80102198 <idestart+0x98>
80102182:	b8 20 00 00 00       	mov    $0x20,%eax
80102187:	89 ca                	mov    %ecx,%edx
80102189:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010218a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010218d:	5b                   	pop    %ebx
8010218e:	5e                   	pop    %esi
8010218f:	5f                   	pop    %edi
80102190:	5d                   	pop    %ebp
80102191:	c3                   	ret    
80102192:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102198:	b8 30 00 00 00       	mov    $0x30,%eax
8010219d:	89 ca                	mov    %ecx,%edx
8010219f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801021a0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801021a5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801021a8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021ad:	fc                   	cld    
801021ae:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801021b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021b3:	5b                   	pop    %ebx
801021b4:	5e                   	pop    %esi
801021b5:	5f                   	pop    %edi
801021b6:	5d                   	pop    %ebp
801021b7:	c3                   	ret    
    panic("incorrect blockno");
801021b8:	83 ec 0c             	sub    $0xc,%esp
801021bb:	68 53 80 10 80       	push   $0x80108053
801021c0:	e8 bb e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021c5:	83 ec 0c             	sub    $0xc,%esp
801021c8:	68 4a 80 10 80       	push   $0x8010804a
801021cd:	e8 ae e1 ff ff       	call   80100380 <panic>
801021d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021e0 <ideinit>:
{
801021e0:	55                   	push   %ebp
801021e1:	89 e5                	mov    %esp,%ebp
801021e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021e6:	68 65 80 10 80       	push   $0x80108065
801021eb:	68 20 26 11 80       	push   $0x80112620
801021f0:	e8 4b 2a 00 00       	call   80104c40 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021f5:	58                   	pop    %eax
801021f6:	a1 c4 67 11 80       	mov    0x801167c4,%eax
801021fb:	5a                   	pop    %edx
801021fc:	83 e8 01             	sub    $0x1,%eax
801021ff:	50                   	push   %eax
80102200:	6a 0e                	push   $0xe
80102202:	e8 99 02 00 00       	call   801024a0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102207:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010220a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010220f:	90                   	nop
80102210:	ec                   	in     (%dx),%al
80102211:	83 e0 c0             	and    $0xffffffc0,%eax
80102214:	3c 40                	cmp    $0x40,%al
80102216:	75 f8                	jne    80102210 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102218:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010221d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102222:	ee                   	out    %al,(%dx)
80102223:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102228:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010222d:	eb 06                	jmp    80102235 <ideinit+0x55>
8010222f:	90                   	nop
  for(i=0; i<1000; i++){
80102230:	83 e9 01             	sub    $0x1,%ecx
80102233:	74 0f                	je     80102244 <ideinit+0x64>
80102235:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102236:	84 c0                	test   %al,%al
80102238:	74 f6                	je     80102230 <ideinit+0x50>
      havedisk1 = 1;
8010223a:	c7 05 00 26 11 80 01 	movl   $0x1,0x80112600
80102241:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102244:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102249:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010224e:	ee                   	out    %al,(%dx)
}
8010224f:	c9                   	leave  
80102250:	c3                   	ret    
80102251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102258:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010225f:	90                   	nop

80102260 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102260:	55                   	push   %ebp
80102261:	89 e5                	mov    %esp,%ebp
80102263:	57                   	push   %edi
80102264:	56                   	push   %esi
80102265:	53                   	push   %ebx
80102266:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102269:	68 20 26 11 80       	push   $0x80112620
8010226e:	e8 9d 2b 00 00       	call   80104e10 <acquire>

  if((b = idequeue) == 0){
80102273:	8b 1d 04 26 11 80    	mov    0x80112604,%ebx
80102279:	83 c4 10             	add    $0x10,%esp
8010227c:	85 db                	test   %ebx,%ebx
8010227e:	74 63                	je     801022e3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102280:	8b 43 58             	mov    0x58(%ebx),%eax
80102283:	a3 04 26 11 80       	mov    %eax,0x80112604

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102288:	8b 33                	mov    (%ebx),%esi
8010228a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102290:	75 2f                	jne    801022c1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102292:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102297:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010229e:	66 90                	xchg   %ax,%ax
801022a0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022a1:	89 c1                	mov    %eax,%ecx
801022a3:	83 e1 c0             	and    $0xffffffc0,%ecx
801022a6:	80 f9 40             	cmp    $0x40,%cl
801022a9:	75 f5                	jne    801022a0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801022ab:	a8 21                	test   $0x21,%al
801022ad:	75 12                	jne    801022c1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801022af:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801022b2:	b9 80 00 00 00       	mov    $0x80,%ecx
801022b7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022bc:	fc                   	cld    
801022bd:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801022bf:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022c1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022c4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022c7:	83 ce 02             	or     $0x2,%esi
801022ca:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022cc:	53                   	push   %ebx
801022cd:	e8 8e 21 00 00       	call   80104460 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022d2:	a1 04 26 11 80       	mov    0x80112604,%eax
801022d7:	83 c4 10             	add    $0x10,%esp
801022da:	85 c0                	test   %eax,%eax
801022dc:	74 05                	je     801022e3 <ideintr+0x83>
    idestart(idequeue);
801022de:	e8 1d fe ff ff       	call   80102100 <idestart>
    release(&idelock);
801022e3:	83 ec 0c             	sub    $0xc,%esp
801022e6:	68 20 26 11 80       	push   $0x80112620
801022eb:	e8 c0 2a 00 00       	call   80104db0 <release>

  release(&idelock);
}
801022f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022f3:	5b                   	pop    %ebx
801022f4:	5e                   	pop    %esi
801022f5:	5f                   	pop    %edi
801022f6:	5d                   	pop    %ebp
801022f7:	c3                   	ret    
801022f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ff:	90                   	nop

80102300 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102300:	55                   	push   %ebp
80102301:	89 e5                	mov    %esp,%ebp
80102303:	53                   	push   %ebx
80102304:	83 ec 10             	sub    $0x10,%esp
80102307:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010230a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010230d:	50                   	push   %eax
8010230e:	e8 dd 28 00 00       	call   80104bf0 <holdingsleep>
80102313:	83 c4 10             	add    $0x10,%esp
80102316:	85 c0                	test   %eax,%eax
80102318:	0f 84 c3 00 00 00    	je     801023e1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010231e:	8b 03                	mov    (%ebx),%eax
80102320:	83 e0 06             	and    $0x6,%eax
80102323:	83 f8 02             	cmp    $0x2,%eax
80102326:	0f 84 a8 00 00 00    	je     801023d4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010232c:	8b 53 04             	mov    0x4(%ebx),%edx
8010232f:	85 d2                	test   %edx,%edx
80102331:	74 0d                	je     80102340 <iderw+0x40>
80102333:	a1 00 26 11 80       	mov    0x80112600,%eax
80102338:	85 c0                	test   %eax,%eax
8010233a:	0f 84 87 00 00 00    	je     801023c7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102340:	83 ec 0c             	sub    $0xc,%esp
80102343:	68 20 26 11 80       	push   $0x80112620
80102348:	e8 c3 2a 00 00       	call   80104e10 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010234d:	a1 04 26 11 80       	mov    0x80112604,%eax
  b->qnext = 0;
80102352:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102359:	83 c4 10             	add    $0x10,%esp
8010235c:	85 c0                	test   %eax,%eax
8010235e:	74 60                	je     801023c0 <iderw+0xc0>
80102360:	89 c2                	mov    %eax,%edx
80102362:	8b 40 58             	mov    0x58(%eax),%eax
80102365:	85 c0                	test   %eax,%eax
80102367:	75 f7                	jne    80102360 <iderw+0x60>
80102369:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010236c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010236e:	39 1d 04 26 11 80    	cmp    %ebx,0x80112604
80102374:	74 3a                	je     801023b0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102376:	8b 03                	mov    (%ebx),%eax
80102378:	83 e0 06             	and    $0x6,%eax
8010237b:	83 f8 02             	cmp    $0x2,%eax
8010237e:	74 1b                	je     8010239b <iderw+0x9b>
    sleep(b, &idelock);
80102380:	83 ec 08             	sub    $0x8,%esp
80102383:	68 20 26 11 80       	push   $0x80112620
80102388:	53                   	push   %ebx
80102389:	e8 12 20 00 00       	call   801043a0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010238e:	8b 03                	mov    (%ebx),%eax
80102390:	83 c4 10             	add    $0x10,%esp
80102393:	83 e0 06             	and    $0x6,%eax
80102396:	83 f8 02             	cmp    $0x2,%eax
80102399:	75 e5                	jne    80102380 <iderw+0x80>
  }


  release(&idelock);
8010239b:	c7 45 08 20 26 11 80 	movl   $0x80112620,0x8(%ebp)
}
801023a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023a5:	c9                   	leave  
  release(&idelock);
801023a6:	e9 05 2a 00 00       	jmp    80104db0 <release>
801023ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023af:	90                   	nop
    idestart(b);
801023b0:	89 d8                	mov    %ebx,%eax
801023b2:	e8 49 fd ff ff       	call   80102100 <idestart>
801023b7:	eb bd                	jmp    80102376 <iderw+0x76>
801023b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023c0:	ba 04 26 11 80       	mov    $0x80112604,%edx
801023c5:	eb a5                	jmp    8010236c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023c7:	83 ec 0c             	sub    $0xc,%esp
801023ca:	68 94 80 10 80       	push   $0x80108094
801023cf:	e8 ac df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023d4:	83 ec 0c             	sub    $0xc,%esp
801023d7:	68 7f 80 10 80       	push   $0x8010807f
801023dc:	e8 9f df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023e1:	83 ec 0c             	sub    $0xc,%esp
801023e4:	68 69 80 10 80       	push   $0x80108069
801023e9:	e8 92 df ff ff       	call   80100380 <panic>
801023ee:	66 90                	xchg   %ax,%ax

801023f0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023f0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023f1:	c7 05 54 26 11 80 00 	movl   $0xfec00000,0x80112654
801023f8:	00 c0 fe 
{
801023fb:	89 e5                	mov    %esp,%ebp
801023fd:	56                   	push   %esi
801023fe:	53                   	push   %ebx
  ioapic->reg = reg;
801023ff:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102406:	00 00 00 
  return ioapic->data;
80102409:	8b 15 54 26 11 80    	mov    0x80112654,%edx
8010240f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102412:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102418:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010241e:	0f b6 15 c0 67 11 80 	movzbl 0x801167c0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102425:	c1 ee 10             	shr    $0x10,%esi
80102428:	89 f0                	mov    %esi,%eax
8010242a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010242d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102430:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102433:	39 c2                	cmp    %eax,%edx
80102435:	74 16                	je     8010244d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102437:	83 ec 0c             	sub    $0xc,%esp
8010243a:	68 b4 80 10 80       	push   $0x801080b4
8010243f:	e8 5c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102444:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
8010244a:	83 c4 10             	add    $0x10,%esp
8010244d:	83 c6 21             	add    $0x21,%esi
{
80102450:	ba 10 00 00 00       	mov    $0x10,%edx
80102455:	b8 20 00 00 00       	mov    $0x20,%eax
8010245a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102460:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102462:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102464:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  for(i = 0; i <= maxintr; i++){
8010246a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010246d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102473:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102476:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102479:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010247c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010247e:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
80102484:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010248b:	39 f0                	cmp    %esi,%eax
8010248d:	75 d1                	jne    80102460 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010248f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102492:	5b                   	pop    %ebx
80102493:	5e                   	pop    %esi
80102494:	5d                   	pop    %ebp
80102495:	c3                   	ret    
80102496:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010249d:	8d 76 00             	lea    0x0(%esi),%esi

801024a0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801024a0:	55                   	push   %ebp
  ioapic->reg = reg;
801024a1:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
{
801024a7:	89 e5                	mov    %esp,%ebp
801024a9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801024ac:	8d 50 20             	lea    0x20(%eax),%edx
801024af:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801024b3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024b5:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024bb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801024be:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024c4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024c6:	a1 54 26 11 80       	mov    0x80112654,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024cb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024ce:	89 50 10             	mov    %edx,0x10(%eax)
}
801024d1:	5d                   	pop    %ebp
801024d2:	c3                   	ret    
801024d3:	66 90                	xchg   %ax,%ax
801024d5:	66 90                	xchg   %ax,%ax
801024d7:	66 90                	xchg   %ax,%ax
801024d9:	66 90                	xchg   %ax,%ax
801024db:	66 90                	xchg   %ax,%ax
801024dd:	66 90                	xchg   %ax,%ax
801024df:	90                   	nop

801024e0 <get_rmap>:
}rmap;


int 
get_rmap(uint pa)
{ 
801024e0:	55                   	push   %ebp
801024e1:	89 e5                	mov    %esp,%ebp
801024e3:	53                   	push   %ebx
801024e4:	83 ec 14             	sub    $0x14,%esp
  int rmap_index;
  if(rmap.use_lock)
    acquire(&rmap.lock);
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
801024e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(rmap.use_lock)
801024ea:	8b 0d a0 26 11 80    	mov    0x801126a0,%ecx
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
801024f0:	c1 eb 0c             	shr    $0xc,%ebx
  if(rmap.use_lock)
801024f3:	85 c9                	test   %ecx,%ecx
801024f5:	75 11                	jne    80102508 <get_rmap+0x28>
  int value=rmap.ref_count[rmap_index];
801024f7:	8b 04 9d d8 26 11 80 	mov    -0x7feed928(,%ebx,4),%eax
  if(rmap.use_lock)
    release(&rmap.lock);
  return value;
}
801024fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102501:	c9                   	leave  
80102502:	c3                   	ret    
80102503:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102507:	90                   	nop
    acquire(&rmap.lock);
80102508:	83 ec 0c             	sub    $0xc,%esp
8010250b:	68 a4 26 11 80       	push   $0x801126a4
80102510:	e8 fb 28 00 00       	call   80104e10 <acquire>
  if(rmap.use_lock)
80102515:	8b 15 a0 26 11 80    	mov    0x801126a0,%edx
  int value=rmap.ref_count[rmap_index];
8010251b:	8b 04 9d d8 26 11 80 	mov    -0x7feed928(,%ebx,4),%eax
  if(rmap.use_lock)
80102522:	83 c4 10             	add    $0x10,%esp
80102525:	85 d2                	test   %edx,%edx
80102527:	74 d5                	je     801024fe <get_rmap+0x1e>
    release(&rmap.lock);
80102529:	83 ec 0c             	sub    $0xc,%esp
8010252c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010252f:	68 a4 26 11 80       	push   $0x801126a4
80102534:	e8 77 28 00 00       	call   80104db0 <release>
  return value;
80102539:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010253c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    release(&rmap.lock);
8010253f:	83 c4 10             	add    $0x10,%esp
}
80102542:	c9                   	leave  
80102543:	c3                   	ret    
80102544:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010254b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010254f:	90                   	nop

80102550 <set_rmap>:
void 
set_rmap(uint pa,int value)
{
80102550:	55                   	push   %ebp
  int rmap_index;
  if(rmap.use_lock)
80102551:	8b 15 a0 26 11 80    	mov    0x801126a0,%edx
{
80102557:	89 e5                	mov    %esp,%ebp
80102559:	56                   	push   %esi
8010255a:	8b 75 0c             	mov    0xc(%ebp),%esi
8010255d:	53                   	push   %ebx
8010255e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(rmap.use_lock)
80102561:	85 d2                	test   %edx,%edx
80102563:	75 1b                	jne    80102580 <set_rmap+0x30>
    acquire(&rmap.lock);
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
80102565:	c1 eb 0c             	shr    $0xc,%ebx
  rmap.ref_count[rmap_index]=value;
80102568:	89 34 9d d8 26 11 80 	mov    %esi,-0x7feed928(,%ebx,4)
  if(rmap.use_lock)
    release(&rmap.lock);
}
8010256f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102572:	5b                   	pop    %ebx
80102573:	5e                   	pop    %esi
80102574:	5d                   	pop    %ebp
80102575:	c3                   	ret    
80102576:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010257d:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&rmap.lock);
80102580:	83 ec 0c             	sub    $0xc,%esp
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
80102583:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&rmap.lock);
80102586:	68 a4 26 11 80       	push   $0x801126a4
8010258b:	e8 80 28 00 00       	call   80104e10 <acquire>
  if(rmap.use_lock)
80102590:	a1 a0 26 11 80       	mov    0x801126a0,%eax
  rmap.ref_count[rmap_index]=value;
80102595:	89 34 9d d8 26 11 80 	mov    %esi,-0x7feed928(,%ebx,4)
  if(rmap.use_lock)
8010259c:	83 c4 10             	add    $0x10,%esp
8010259f:	85 c0                	test   %eax,%eax
801025a1:	74 cc                	je     8010256f <set_rmap+0x1f>
    release(&rmap.lock);
801025a3:	c7 45 08 a4 26 11 80 	movl   $0x801126a4,0x8(%ebp)
}
801025aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025ad:	5b                   	pop    %ebx
801025ae:	5e                   	pop    %esi
801025af:	5d                   	pop    %ebp
    release(&rmap.lock);
801025b0:	e9 fb 27 00 00       	jmp    80104db0 <release>
801025b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801025c0 <inc_rmap>:
void 
inc_rmap(uint pa)
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	53                   	push   %ebx
801025c4:	83 ec 04             	sub    $0x4,%esp
  int rmap_index;
  if(rmap.use_lock)
801025c7:	8b 15 a0 26 11 80    	mov    0x801126a0,%edx
{
801025cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(rmap.use_lock)
801025d0:	85 d2                	test   %edx,%edx
801025d2:	75 1c                	jne    801025f0 <inc_rmap+0x30>
    acquire(&rmap.lock);
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
801025d4:	89 d8                	mov    %ebx,%eax
801025d6:	c1 e8 0c             	shr    $0xc,%eax
  rmap.ref_count[rmap_index]++;
801025d9:	83 04 85 d8 26 11 80 	addl   $0x1,-0x7feed928(,%eax,4)
801025e0:	01 
  if(rmap.use_lock)
    release(&rmap.lock);
}
801025e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025e4:	c9                   	leave  
801025e5:	c3                   	ret    
801025e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025ed:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&rmap.lock);
801025f0:	83 ec 0c             	sub    $0xc,%esp
801025f3:	68 a4 26 11 80       	push   $0x801126a4
801025f8:	e8 13 28 00 00       	call   80104e10 <acquire>
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
801025fd:	89 d8                	mov    %ebx,%eax
  if(rmap.use_lock)
801025ff:	83 c4 10             	add    $0x10,%esp
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
80102602:	c1 e8 0c             	shr    $0xc,%eax
  rmap.ref_count[rmap_index]++;
80102605:	83 04 85 d8 26 11 80 	addl   $0x1,-0x7feed928(,%eax,4)
8010260c:	01 
  if(rmap.use_lock)
8010260d:	a1 a0 26 11 80       	mov    0x801126a0,%eax
80102612:	85 c0                	test   %eax,%eax
80102614:	74 cb                	je     801025e1 <inc_rmap+0x21>
    release(&rmap.lock);
80102616:	c7 45 08 a4 26 11 80 	movl   $0x801126a4,0x8(%ebp)
}
8010261d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102620:	c9                   	leave  
    release(&rmap.lock);
80102621:	e9 8a 27 00 00       	jmp    80104db0 <release>
80102626:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010262d:	8d 76 00             	lea    0x0(%esi),%esi

80102630 <dec_rmap>:
void 
dec_rmap(uint pa)
{
80102630:	55                   	push   %ebp
80102631:	89 e5                	mov    %esp,%ebp
80102633:	53                   	push   %ebx
80102634:	83 ec 04             	sub    $0x4,%esp
  int rmap_index;
  if(rmap.use_lock)
80102637:	8b 15 a0 26 11 80    	mov    0x801126a0,%edx
{
8010263d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(rmap.use_lock)
80102640:	85 d2                	test   %edx,%edx
80102642:	75 1c                	jne    80102660 <dec_rmap+0x30>
    acquire(&rmap.lock);
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
80102644:	89 d8                	mov    %ebx,%eax
80102646:	c1 e8 0c             	shr    $0xc,%eax
  rmap.ref_count[rmap_index]--;
80102649:	83 2c 85 d8 26 11 80 	subl   $0x1,-0x7feed928(,%eax,4)
80102650:	01 
  if(rmap.use_lock)
    release(&rmap.lock);
}
80102651:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102654:	c9                   	leave  
80102655:	c3                   	ret    
80102656:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010265d:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&rmap.lock);
80102660:	83 ec 0c             	sub    $0xc,%esp
80102663:	68 a4 26 11 80       	push   $0x801126a4
80102668:	e8 a3 27 00 00       	call   80104e10 <acquire>
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
8010266d:	89 d8                	mov    %ebx,%eax
  if(rmap.use_lock)
8010266f:	83 c4 10             	add    $0x10,%esp
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
80102672:	c1 e8 0c             	shr    $0xc,%eax
  rmap.ref_count[rmap_index]--;
80102675:	83 2c 85 d8 26 11 80 	subl   $0x1,-0x7feed928(,%eax,4)
8010267c:	01 
  if(rmap.use_lock)
8010267d:	a1 a0 26 11 80       	mov    0x801126a0,%eax
80102682:	85 c0                	test   %eax,%eax
80102684:	74 cb                	je     80102651 <dec_rmap+0x21>
    release(&rmap.lock);
80102686:	c7 45 08 a4 26 11 80 	movl   $0x801126a4,0x8(%ebp)
}
8010268d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102690:	c9                   	leave  
    release(&rmap.lock);
80102691:	e9 1a 27 00 00       	jmp    80104db0 <release>
80102696:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010269d:	8d 76 00             	lea    0x0(%esi),%esi

801026a0 <get_pindex_status>:

int get_pindex_status(uint pa, uint p_index)
{
801026a0:	55                   	push   %ebp
801026a1:	89 e5                	mov    %esp,%ebp
801026a3:	57                   	push   %edi
801026a4:	56                   	push   %esi
801026a5:	53                   	push   %ebx
801026a6:	83 ec 1c             	sub    $0x1c,%esp
801026a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  int rmap_index, pindex_status=0;
  long long val=1;
  if(p_index>=64 || p_index<0)
801026ac:	83 f9 3f             	cmp    $0x3f,%ecx
801026af:	0f 87 9d 00 00 00    	ja     80102752 <get_pindex_status+0xb2>
    panic("wrong pindex in get_pindex_status");
  if(rmap.use_lock)
    acquire(&rmap.lock);
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
  if((rmap.process_idxs[rmap_index])&(val<<p_index))
801026b5:	89 cf                	mov    %ecx,%edi
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
801026b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(rmap.use_lock)
801026ba:	a1 a0 26 11 80       	mov    0x801126a0,%eax
  if((rmap.process_idxs[rmap_index])&(val<<p_index))
801026bf:	c1 ef 05             	shr    $0x5,%edi
801026c2:	83 e7 01             	and    $0x1,%edi
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
801026c5:	c1 eb 0c             	shr    $0xc,%ebx
  if((rmap.process_idxs[rmap_index])&(val<<p_index))
801026c8:	89 fe                	mov    %edi,%esi
801026ca:	d3 e7                	shl    %cl,%edi
801026cc:	83 f6 01             	xor    $0x1,%esi
801026cf:	d3 e6                	shl    %cl,%esi
  if(rmap.use_lock)
801026d1:	85 c0                	test   %eax,%eax
801026d3:	75 2b                	jne    80102700 <get_pindex_status+0x60>
  if((rmap.process_idxs[rmap_index])&(val<<p_index))
801026d5:	8b 04 dd d8 46 11 80 	mov    -0x7feeb928(,%ebx,8),%eax
801026dc:	8b 14 dd dc 46 11 80 	mov    -0x7feeb924(,%ebx,8),%edx
801026e3:	21 f0                	and    %esi,%eax
801026e5:	21 fa                	and    %edi,%edx
801026e7:	09 d0                	or     %edx,%eax
801026e9:	0f 95 c0             	setne  %al
801026ec:	0f b6 c0             	movzbl %al,%eax
    pindex_status=1;
  if(rmap.use_lock)
    release(&rmap.lock);
  return pindex_status;
}
801026ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801026f2:	5b                   	pop    %ebx
801026f3:	5e                   	pop    %esi
801026f4:	5f                   	pop    %edi
801026f5:	5d                   	pop    %ebp
801026f6:	c3                   	ret    
801026f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026fe:	66 90                	xchg   %ax,%ax
    acquire(&rmap.lock);
80102700:	83 ec 0c             	sub    $0xc,%esp
80102703:	68 a4 26 11 80       	push   $0x801126a4
80102708:	e8 03 27 00 00       	call   80104e10 <acquire>
  if((rmap.process_idxs[rmap_index])&(val<<p_index))
8010270d:	8b 04 dd d8 46 11 80 	mov    -0x7feeb928(,%ebx,8),%eax
80102714:	8b 14 dd dc 46 11 80 	mov    -0x7feeb924(,%ebx,8),%edx
8010271b:	83 c4 10             	add    $0x10,%esp
8010271e:	21 f0                	and    %esi,%eax
80102720:	21 fa                	and    %edi,%edx
80102722:	09 d0                	or     %edx,%eax
  if(rmap.use_lock)
80102724:	8b 15 a0 26 11 80    	mov    0x801126a0,%edx
  if((rmap.process_idxs[rmap_index])&(val<<p_index))
8010272a:	0f 95 c0             	setne  %al
8010272d:	0f b6 c0             	movzbl %al,%eax
  if(rmap.use_lock)
80102730:	85 d2                	test   %edx,%edx
80102732:	74 bb                	je     801026ef <get_pindex_status+0x4f>
    release(&rmap.lock);
80102734:	83 ec 0c             	sub    $0xc,%esp
80102737:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010273a:	68 a4 26 11 80       	push   $0x801126a4
8010273f:	e8 6c 26 00 00       	call   80104db0 <release>
  return pindex_status;
80102744:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    release(&rmap.lock);
80102747:	83 c4 10             	add    $0x10,%esp
}
8010274a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010274d:	5b                   	pop    %ebx
8010274e:	5e                   	pop    %esi
8010274f:	5f                   	pop    %edi
80102750:	5d                   	pop    %ebp
80102751:	c3                   	ret    
    panic("wrong pindex in get_pindex_status");
80102752:	83 ec 0c             	sub    $0xc,%esp
80102755:	68 e8 80 10 80       	push   $0x801080e8
8010275a:	e8 21 dc ff ff       	call   80100380 <panic>
8010275f:	90                   	nop

80102760 <set_pindex_status>:
void set_pindex_status(uint pa, uint p_index,uint pindex_status)
{
80102760:	55                   	push   %ebp
80102761:	89 e5                	mov    %esp,%ebp
80102763:	57                   	push   %edi
80102764:	56                   	push   %esi
80102765:	53                   	push   %ebx
80102766:	83 ec 1c             	sub    $0x1c,%esp
80102769:	8b 45 10             	mov    0x10(%ebp),%eax
8010276c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010276f:	8b 7d 08             	mov    0x8(%ebp),%edi
80102772:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int rmap_index;
  long long  val=1;
  if(p_index>=64 || p_index<0)
80102775:	83 f9 3f             	cmp    $0x3f,%ecx
80102778:	0f 87 bb 00 00 00    	ja     80102839 <set_pindex_status+0xd9>
    panic("wrong pindex in set_pindex_status");

  if(rmap.use_lock)
8010277e:	8b 1d a0 26 11 80    	mov    0x801126a0,%ebx
80102784:	85 db                	test   %ebx,%ebx
80102786:	0f 85 8c 00 00 00    	jne    80102818 <set_pindex_status+0xb8>
    acquire(&rmap.lock);
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
8010278c:	c1 ef 0c             	shr    $0xc,%edi
  if(pindex_status)
  {
    rmap.process_idxs[rmap_index] |=(val<<p_index);
8010278f:	be 01 00 00 00       	mov    $0x1,%esi
80102794:	8d 87 06 04 00 00    	lea    0x406(%edi),%eax
8010279a:	31 ff                	xor    %edi,%edi
8010279c:	8b 14 c5 a8 26 11 80 	mov    -0x7feed958(,%eax,8),%edx
801027a3:	0f a5 f7             	shld   %cl,%esi,%edi
801027a6:	d3 e6                	shl    %cl,%esi
801027a8:	89 55 e0             	mov    %edx,-0x20(%ebp)
801027ab:	8b 14 c5 ac 26 11 80 	mov    -0x7feed954(,%eax,8),%edx
801027b2:	f6 c1 20             	test   $0x20,%cl
801027b5:	74 04                	je     801027bb <set_pindex_status+0x5b>
801027b7:	89 f7                	mov    %esi,%edi
801027b9:	31 f6                	xor    %esi,%esi
  if(pindex_status)
801027bb:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801027be:	85 c9                	test   %ecx,%ecx
801027c0:	75 2e                	jne    801027f0 <set_pindex_status+0x90>
  }
  else{
    rmap.process_idxs[rmap_index] &=(~(val<<p_index));
801027c2:	89 f1                	mov    %esi,%ecx
801027c4:	89 fe                	mov    %edi,%esi
801027c6:	f7 d6                	not    %esi
801027c8:	f7 d1                	not    %ecx
801027ca:	23 4d e0             	and    -0x20(%ebp),%ecx
801027cd:	21 f2                	and    %esi,%edx
801027cf:	89 0c c5 a8 26 11 80 	mov    %ecx,-0x7feed958(,%eax,8)
801027d6:	89 14 c5 ac 26 11 80 	mov    %edx,-0x7feed954(,%eax,8)
  }
  if(rmap.use_lock)
801027dd:	85 db                	test   %ebx,%ebx
801027df:	75 1f                	jne    80102800 <set_pindex_status+0xa0>
    release(&rmap.lock);
}
801027e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801027e4:	5b                   	pop    %ebx
801027e5:	5e                   	pop    %esi
801027e6:	5f                   	pop    %edi
801027e7:	5d                   	pop    %ebp
801027e8:	c3                   	ret    
801027e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    rmap.process_idxs[rmap_index] |=(val<<p_index);
801027f0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801027f3:	09 fa                	or     %edi,%edx
801027f5:	09 f1                	or     %esi,%ecx
801027f7:	eb d6                	jmp    801027cf <set_pindex_status+0x6f>
801027f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&rmap.lock);
80102800:	c7 45 08 a4 26 11 80 	movl   $0x801126a4,0x8(%ebp)
}
80102807:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010280a:	5b                   	pop    %ebx
8010280b:	5e                   	pop    %esi
8010280c:	5f                   	pop    %edi
8010280d:	5d                   	pop    %ebp
    release(&rmap.lock);
8010280e:	e9 9d 25 00 00       	jmp    80104db0 <release>
80102813:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102817:	90                   	nop
    acquire(&rmap.lock);
80102818:	83 ec 0c             	sub    $0xc,%esp
8010281b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010281e:	68 a4 26 11 80       	push   $0x801126a4
80102823:	e8 e8 25 00 00       	call   80104e10 <acquire>
  if(rmap.use_lock)
80102828:	8b 1d a0 26 11 80    	mov    0x801126a0,%ebx
8010282e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80102831:	83 c4 10             	add    $0x10,%esp
80102834:	e9 53 ff ff ff       	jmp    8010278c <set_pindex_status+0x2c>
    panic("wrong pindex in set_pindex_status");
80102839:	83 ec 0c             	sub    $0xc,%esp
8010283c:	68 0c 81 10 80       	push   $0x8010810c
80102841:	e8 3a db ff ff       	call   80100380 <panic>
80102846:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010284d:	8d 76 00             	lea    0x0(%esi),%esi

80102850 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102850:	55                   	push   %ebp
80102851:	89 e5                	mov    %esp,%ebp
80102853:	57                   	push   %edi
80102854:	56                   	push   %esi
80102855:	53                   	push   %ebx
80102856:	83 ec 0c             	sub    $0xc,%esp
80102859:	8b 75 08             	mov    0x8(%ebp),%esi
  struct run *r;
  // cprintf(" page address %p \n",v);
  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010285c:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
80102862:	0f 85 4d 01 00 00    	jne    801029b5 <kfree+0x165>
80102868:	81 fe 00 b9 11 80    	cmp    $0x8011b900,%esi
8010286e:	0f 82 41 01 00 00    	jb     801029b5 <kfree+0x165>
80102874:	8d 9e 00 00 00 80    	lea    -0x80000000(%esi),%ebx
8010287a:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
80102880:	0f 87 2f 01 00 00    	ja     801029b5 <kfree+0x165>
  if(rmap.use_lock)
80102886:	a1 a0 26 11 80       	mov    0x801126a0,%eax
8010288b:	85 c0                	test   %eax,%eax
8010288d:	0f 85 85 00 00 00    	jne    80102918 <kfree+0xc8>
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
80102893:	c1 eb 0c             	shr    $0xc,%ebx
  rmap.ref_count[rmap_index]--;
80102896:	83 c3 0c             	add    $0xc,%ebx
80102899:	8b 04 9d a8 26 11 80 	mov    -0x7feed958(,%ebx,4),%eax
801028a0:	8d 78 ff             	lea    -0x1(%eax),%edi
801028a3:	89 3c 9d a8 26 11 80 	mov    %edi,-0x7feed958(,%ebx,4)
    panic("kfree");

  dec_rmap(V2P(v));
  if(get_rmap(V2P(v))>0)
801028aa:	85 ff                	test   %edi,%edi
801028ac:	7e 12                	jle    801028c0 <kfree+0x70>
  r->next = kmem.freelist;
  kmem.num_free_pages+=1;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
}
801028ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801028b1:	5b                   	pop    %ebx
801028b2:	5e                   	pop    %esi
801028b3:	5f                   	pop    %edi
801028b4:	5d                   	pop    %ebp
801028b5:	c3                   	ret    
801028b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028bd:	8d 76 00             	lea    0x0(%esi),%esi
  memset(v, 1, PGSIZE);
801028c0:	83 ec 04             	sub    $0x4,%esp
801028c3:	68 00 10 00 00       	push   $0x1000
801028c8:	6a 01                	push   $0x1
801028ca:	56                   	push   %esi
801028cb:	e8 00 26 00 00       	call   80104ed0 <memset>
  if(kmem.use_lock)
801028d0:	8b 15 94 26 11 80    	mov    0x80112694,%edx
801028d6:	83 c4 10             	add    $0x10,%esp
801028d9:	85 d2                	test   %edx,%edx
801028db:	0f 85 bf 00 00 00    	jne    801029a0 <kfree+0x150>
  r->next = kmem.freelist;
801028e1:	a1 9c 26 11 80       	mov    0x8011269c,%eax
801028e6:	89 06                	mov    %eax,(%esi)
  if(kmem.use_lock)
801028e8:	a1 94 26 11 80       	mov    0x80112694,%eax
  kmem.num_free_pages+=1;
801028ed:	83 05 98 26 11 80 01 	addl   $0x1,0x80112698
  kmem.freelist = r;
801028f4:	89 35 9c 26 11 80    	mov    %esi,0x8011269c
  if(kmem.use_lock)
801028fa:	85 c0                	test   %eax,%eax
801028fc:	74 b0                	je     801028ae <kfree+0x5e>
    release(&kmem.lock);
801028fe:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
80102905:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102908:	5b                   	pop    %ebx
80102909:	5e                   	pop    %esi
8010290a:	5f                   	pop    %edi
8010290b:	5d                   	pop    %ebp
    release(&kmem.lock);
8010290c:	e9 9f 24 00 00       	jmp    80104db0 <release>
80102911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&rmap.lock);
80102918:	83 ec 0c             	sub    $0xc,%esp
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
8010291b:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&rmap.lock);
8010291e:	68 a4 26 11 80       	push   $0x801126a4
  rmap.ref_count[rmap_index]--;
80102923:	83 c3 0c             	add    $0xc,%ebx
    acquire(&rmap.lock);
80102926:	e8 e5 24 00 00       	call   80104e10 <acquire>
  rmap.ref_count[rmap_index]--;
8010292b:	8b 04 9d a8 26 11 80 	mov    -0x7feed958(,%ebx,4),%eax
  if(rmap.use_lock)
80102932:	83 c4 10             	add    $0x10,%esp
  rmap.ref_count[rmap_index]--;
80102935:	8d 78 ff             	lea    -0x1(%eax),%edi
  if(rmap.use_lock)
80102938:	a1 a0 26 11 80       	mov    0x801126a0,%eax
  rmap.ref_count[rmap_index]--;
8010293d:	89 3c 9d a8 26 11 80 	mov    %edi,-0x7feed958(,%ebx,4)
  if(rmap.use_lock)
80102944:	85 c0                	test   %eax,%eax
80102946:	0f 84 5e ff ff ff    	je     801028aa <kfree+0x5a>
    release(&rmap.lock);
8010294c:	83 ec 0c             	sub    $0xc,%esp
8010294f:	68 a4 26 11 80       	push   $0x801126a4
80102954:	e8 57 24 00 00       	call   80104db0 <release>
  if(rmap.use_lock)
80102959:	8b 3d a0 26 11 80    	mov    0x801126a0,%edi
8010295f:	83 c4 10             	add    $0x10,%esp
80102962:	85 ff                	test   %edi,%edi
80102964:	74 5c                	je     801029c2 <kfree+0x172>
    acquire(&rmap.lock);
80102966:	83 ec 0c             	sub    $0xc,%esp
80102969:	68 a4 26 11 80       	push   $0x801126a4
8010296e:	e8 9d 24 00 00       	call   80104e10 <acquire>
  if(rmap.use_lock)
80102973:	8b 0d a0 26 11 80    	mov    0x801126a0,%ecx
  int value=rmap.ref_count[rmap_index];
80102979:	8b 3c 9d a8 26 11 80 	mov    -0x7feed958(,%ebx,4),%edi
  if(rmap.use_lock)
80102980:	83 c4 10             	add    $0x10,%esp
80102983:	85 c9                	test   %ecx,%ecx
80102985:	0f 84 1f ff ff ff    	je     801028aa <kfree+0x5a>
    release(&rmap.lock);
8010298b:	83 ec 0c             	sub    $0xc,%esp
8010298e:	68 a4 26 11 80       	push   $0x801126a4
80102993:	e8 18 24 00 00       	call   80104db0 <release>
80102998:	83 c4 10             	add    $0x10,%esp
8010299b:	e9 0a ff ff ff       	jmp    801028aa <kfree+0x5a>
    acquire(&kmem.lock);
801029a0:	83 ec 0c             	sub    $0xc,%esp
801029a3:	68 60 26 11 80       	push   $0x80112660
801029a8:	e8 63 24 00 00       	call   80104e10 <acquire>
801029ad:	83 c4 10             	add    $0x10,%esp
801029b0:	e9 2c ff ff ff       	jmp    801028e1 <kfree+0x91>
    panic("kfree");
801029b5:	83 ec 0c             	sub    $0xc,%esp
801029b8:	68 2e 81 10 80       	push   $0x8010812e
801029bd:	e8 be d9 ff ff       	call   80100380 <panic>
  int value=rmap.ref_count[rmap_index];
801029c2:	8b 3c 9d a8 26 11 80 	mov    -0x7feed958(,%ebx,4),%edi
801029c9:	e9 dc fe ff ff       	jmp    801028aa <kfree+0x5a>
801029ce:	66 90                	xchg   %ax,%ax

801029d0 <freerange>:
{
801029d0:	55                   	push   %ebp
801029d1:	89 e5                	mov    %esp,%ebp
801029d3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801029d4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801029d7:	8b 75 0c             	mov    0xc(%ebp),%esi
801029da:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801029db:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801029e1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801029e7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801029ed:	39 de                	cmp    %ebx,%esi
801029ef:	72 23                	jb     80102a14 <freerange+0x44>
801029f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801029f8:	83 ec 0c             	sub    $0xc,%esp
801029fb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a01:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102a07:	50                   	push   %eax
80102a08:	e8 43 fe ff ff       	call   80102850 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a0d:	83 c4 10             	add    $0x10,%esp
80102a10:	39 f3                	cmp    %esi,%ebx
80102a12:	76 e4                	jbe    801029f8 <freerange+0x28>
}
80102a14:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a17:	5b                   	pop    %ebx
80102a18:	5e                   	pop    %esi
80102a19:	5d                   	pop    %ebp
80102a1a:	c3                   	ret    
80102a1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a1f:	90                   	nop

80102a20 <kinit2>:
{
80102a20:	55                   	push   %ebp
80102a21:	89 e5                	mov    %esp,%ebp
80102a23:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102a24:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102a27:	8b 75 0c             	mov    0xc(%ebp),%esi
80102a2a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102a2b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102a31:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a37:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102a3d:	39 de                	cmp    %ebx,%esi
80102a3f:	72 23                	jb     80102a64 <kinit2+0x44>
80102a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102a48:	83 ec 0c             	sub    $0xc,%esp
80102a4b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a51:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102a57:	50                   	push   %eax
80102a58:	e8 f3 fd ff ff       	call   80102850 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a5d:	83 c4 10             	add    $0x10,%esp
80102a60:	39 de                	cmp    %ebx,%esi
80102a62:	73 e4                	jae    80102a48 <kinit2+0x28>
  kmem.use_lock = 1;
80102a64:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
80102a6b:	00 00 00 
  rmap.use_lock=1;
80102a6e:	c7 05 a0 26 11 80 01 	movl   $0x1,0x801126a0
80102a75:	00 00 00 
}
80102a78:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a7b:	5b                   	pop    %ebx
80102a7c:	5e                   	pop    %esi
80102a7d:	5d                   	pop    %ebp
80102a7e:	c3                   	ret    
80102a7f:	90                   	nop

80102a80 <kinit1>:
{
80102a80:	55                   	push   %ebp
80102a81:	89 e5                	mov    %esp,%ebp
80102a83:	56                   	push   %esi
80102a84:	53                   	push   %ebx
80102a85:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102a88:	83 ec 08             	sub    $0x8,%esp
80102a8b:	68 34 81 10 80       	push   $0x80108134
80102a90:	68 60 26 11 80       	push   $0x80112660
80102a95:	e8 a6 21 00 00       	call   80104c40 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a9d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102aa0:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
80102aa7:	00 00 00 
  rmap.use_lock=0;
80102aaa:	c7 05 a0 26 11 80 00 	movl   $0x0,0x801126a0
80102ab1:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102ab4:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102aba:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ac0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102ac6:	39 de                	cmp    %ebx,%esi
80102ac8:	72 22                	jb     80102aec <kinit1+0x6c>
80102aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    kfree(p);
80102ad0:	83 ec 0c             	sub    $0xc,%esp
80102ad3:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ad9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102adf:	50                   	push   %eax
80102ae0:	e8 6b fd ff ff       	call   80102850 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ae5:	83 c4 10             	add    $0x10,%esp
80102ae8:	39 de                	cmp    %ebx,%esi
80102aea:	73 e4                	jae    80102ad0 <kinit1+0x50>
}
80102aec:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102aef:	5b                   	pop    %ebx
80102af0:	5e                   	pop    %esi
80102af1:	5d                   	pop    %ebp
80102af2:	c3                   	ret    
80102af3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102b00 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102b00:	55                   	push   %ebp
80102b01:	89 e5                	mov    %esp,%ebp
80102b03:	56                   	push   %esi
80102b04:	53                   	push   %ebx
80102b05:	8d 76 00             	lea    0x0(%esi),%esi
  struct run *r;

  if(kmem.use_lock)
80102b08:	a1 94 26 11 80       	mov    0x80112694,%eax
80102b0d:	85 c0                	test   %eax,%eax
80102b0f:	75 5f                	jne    80102b70 <kalloc+0x70>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102b11:	8b 1d 9c 26 11 80    	mov    0x8011269c,%ebx
  if(r)
80102b17:	85 db                	test   %ebx,%ebx
80102b19:	74 79                	je     80102b94 <kalloc+0x94>
  {
    kmem.freelist = r->next;
80102b1b:	8b 03                	mov    (%ebx),%eax
    kmem.num_free_pages-=1;
    set_rmap(V2P(r),1); 
80102b1d:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
    kmem.num_free_pages-=1;
80102b23:	83 2d 98 26 11 80 01 	subl   $0x1,0x80112698
    kmem.freelist = r->next;
80102b2a:	a3 9c 26 11 80       	mov    %eax,0x8011269c
  if(rmap.use_lock)
80102b2f:	a1 a0 26 11 80       	mov    0x801126a0,%eax
80102b34:	85 c0                	test   %eax,%eax
80102b36:	75 68                	jne    80102ba0 <kalloc+0xa0>
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
80102b38:	c1 ee 0c             	shr    $0xc,%esi
  rmap.ref_count[rmap_index]=value;
80102b3b:	c7 04 b5 d8 26 11 80 	movl   $0x1,-0x7feed928(,%esi,4)
80102b42:	01 00 00 00 
  }
  if(kmem.use_lock)
80102b46:	a1 94 26 11 80       	mov    0x80112694,%eax
80102b4b:	85 c0                	test   %eax,%eax
80102b4d:	74 10                	je     80102b5f <kalloc+0x5f>
    release(&kmem.lock);
80102b4f:	83 ec 0c             	sub    $0xc,%esp
80102b52:	68 60 26 11 80       	push   $0x80112660
80102b57:	e8 54 22 00 00       	call   80104db0 <release>
80102b5c:	83 c4 10             	add    $0x10,%esp
    // cprintf("page allocated when r==0\n");
    return kalloc();
  }
  // cprintf("page address that allocated:%p\n",(char*)r);
  return (char*)r;
}
80102b5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b62:	89 d8                	mov    %ebx,%eax
80102b64:	5b                   	pop    %ebx
80102b65:	5e                   	pop    %esi
80102b66:	5d                   	pop    %ebp
80102b67:	c3                   	ret    
80102b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b6f:	90                   	nop
    acquire(&kmem.lock);
80102b70:	83 ec 0c             	sub    $0xc,%esp
80102b73:	68 60 26 11 80       	push   $0x80112660
80102b78:	e8 93 22 00 00       	call   80104e10 <acquire>
  r = kmem.freelist;
80102b7d:	8b 1d 9c 26 11 80    	mov    0x8011269c,%ebx
  if(r)
80102b83:	83 c4 10             	add    $0x10,%esp
80102b86:	85 db                	test   %ebx,%ebx
80102b88:	75 91                	jne    80102b1b <kalloc+0x1b>
  if(kmem.use_lock)
80102b8a:	8b 15 94 26 11 80    	mov    0x80112694,%edx
80102b90:	85 d2                	test   %edx,%edx
80102b92:	75 4d                	jne    80102be1 <kalloc+0xe1>
    swap_out();
80102b94:	e8 27 52 00 00       	call   80107dc0 <swap_out>
    return kalloc();
80102b99:	e9 6a ff ff ff       	jmp    80102b08 <kalloc+0x8>
80102b9e:	66 90                	xchg   %ax,%ax
    acquire(&rmap.lock);
80102ba0:	83 ec 0c             	sub    $0xc,%esp
  rmap_index = ((pa>>PTXSHIFT)&(0xFFFFF));
80102ba3:	c1 ee 0c             	shr    $0xc,%esi
    acquire(&rmap.lock);
80102ba6:	68 a4 26 11 80       	push   $0x801126a4
80102bab:	e8 60 22 00 00       	call   80104e10 <acquire>
  if(rmap.use_lock)
80102bb0:	8b 0d a0 26 11 80    	mov    0x801126a0,%ecx
80102bb6:	83 c4 10             	add    $0x10,%esp
  rmap.ref_count[rmap_index]=value;
80102bb9:	c7 04 b5 d8 26 11 80 	movl   $0x1,-0x7feed928(,%esi,4)
80102bc0:	01 00 00 00 
  if(rmap.use_lock)
80102bc4:	85 c9                	test   %ecx,%ecx
80102bc6:	0f 84 7a ff ff ff    	je     80102b46 <kalloc+0x46>
    release(&rmap.lock);
80102bcc:	83 ec 0c             	sub    $0xc,%esp
80102bcf:	68 a4 26 11 80       	push   $0x801126a4
80102bd4:	e8 d7 21 00 00       	call   80104db0 <release>
80102bd9:	83 c4 10             	add    $0x10,%esp
80102bdc:	e9 65 ff ff ff       	jmp    80102b46 <kalloc+0x46>
    release(&kmem.lock);
80102be1:	83 ec 0c             	sub    $0xc,%esp
80102be4:	68 60 26 11 80       	push   $0x80112660
80102be9:	e8 c2 21 00 00       	call   80104db0 <release>
80102bee:	83 c4 10             	add    $0x10,%esp
80102bf1:	eb a1                	jmp    80102b94 <kalloc+0x94>
80102bf3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102c00 <num_of_FreePages>:
uint 
num_of_FreePages(void)
{
80102c00:	55                   	push   %ebp
80102c01:	89 e5                	mov    %esp,%ebp
80102c03:	53                   	push   %ebx
80102c04:	83 ec 10             	sub    $0x10,%esp
  acquire(&kmem.lock);
80102c07:	68 60 26 11 80       	push   $0x80112660
80102c0c:	e8 ff 21 00 00       	call   80104e10 <acquire>

  uint num_free_pages = kmem.num_free_pages;
80102c11:	8b 1d 98 26 11 80    	mov    0x80112698,%ebx
  
  release(&kmem.lock);
80102c17:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
80102c1e:	e8 8d 21 00 00       	call   80104db0 <release>
  
  return num_free_pages;
}
80102c23:	89 d8                	mov    %ebx,%eax
80102c25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c28:	c9                   	leave  
80102c29:	c3                   	ret    
80102c2a:	66 90                	xchg   %ax,%ax
80102c2c:	66 90                	xchg   %ax,%ax
80102c2e:	66 90                	xchg   %ax,%ax

80102c30 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c30:	ba 64 00 00 00       	mov    $0x64,%edx
80102c35:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102c36:	a8 01                	test   $0x1,%al
80102c38:	0f 84 c2 00 00 00    	je     80102d00 <kbdgetc+0xd0>
{
80102c3e:	55                   	push   %ebp
80102c3f:	ba 60 00 00 00       	mov    $0x60,%edx
80102c44:	89 e5                	mov    %esp,%ebp
80102c46:	53                   	push   %ebx
80102c47:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102c48:	8b 1d d8 66 11 80    	mov    0x801166d8,%ebx
  data = inb(KBDATAP);
80102c4e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102c51:	3c e0                	cmp    $0xe0,%al
80102c53:	74 5b                	je     80102cb0 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102c55:	89 da                	mov    %ebx,%edx
80102c57:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
80102c5a:	84 c0                	test   %al,%al
80102c5c:	78 62                	js     80102cc0 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102c5e:	85 d2                	test   %edx,%edx
80102c60:	74 09                	je     80102c6b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102c62:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102c65:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102c68:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80102c6b:	0f b6 91 60 82 10 80 	movzbl -0x7fef7da0(%ecx),%edx
  shift ^= togglecode[data];
80102c72:	0f b6 81 60 81 10 80 	movzbl -0x7fef7ea0(%ecx),%eax
  shift |= shiftcode[data];
80102c79:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102c7b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102c7d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
80102c7f:	89 15 d8 66 11 80    	mov    %edx,0x801166d8
  c = charcode[shift & (CTL | SHIFT)][data];
80102c85:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102c88:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102c8b:	8b 04 85 40 81 10 80 	mov    -0x7fef7ec0(,%eax,4),%eax
80102c92:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102c96:	74 0b                	je     80102ca3 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102c98:	8d 50 9f             	lea    -0x61(%eax),%edx
80102c9b:	83 fa 19             	cmp    $0x19,%edx
80102c9e:	77 48                	ja     80102ce8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102ca0:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102ca3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ca6:	c9                   	leave  
80102ca7:	c3                   	ret    
80102ca8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102caf:	90                   	nop
    shift |= E0ESC;
80102cb0:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102cb3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102cb5:	89 1d d8 66 11 80    	mov    %ebx,0x801166d8
}
80102cbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cbe:	c9                   	leave  
80102cbf:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102cc0:	83 e0 7f             	and    $0x7f,%eax
80102cc3:	85 d2                	test   %edx,%edx
80102cc5:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102cc8:	0f b6 81 60 82 10 80 	movzbl -0x7fef7da0(%ecx),%eax
80102ccf:	83 c8 40             	or     $0x40,%eax
80102cd2:	0f b6 c0             	movzbl %al,%eax
80102cd5:	f7 d0                	not    %eax
80102cd7:	21 d8                	and    %ebx,%eax
}
80102cd9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
80102cdc:	a3 d8 66 11 80       	mov    %eax,0x801166d8
    return 0;
80102ce1:	31 c0                	xor    %eax,%eax
}
80102ce3:	c9                   	leave  
80102ce4:	c3                   	ret    
80102ce5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102ce8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102ceb:	8d 50 20             	lea    0x20(%eax),%edx
}
80102cee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cf1:	c9                   	leave  
      c += 'a' - 'A';
80102cf2:	83 f9 1a             	cmp    $0x1a,%ecx
80102cf5:	0f 42 c2             	cmovb  %edx,%eax
}
80102cf8:	c3                   	ret    
80102cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102d00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102d05:	c3                   	ret    
80102d06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d0d:	8d 76 00             	lea    0x0(%esi),%esi

80102d10 <kbdintr>:

void
kbdintr(void)
{
80102d10:	55                   	push   %ebp
80102d11:	89 e5                	mov    %esp,%ebp
80102d13:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102d16:	68 30 2c 10 80       	push   $0x80102c30
80102d1b:	e8 60 db ff ff       	call   80100880 <consoleintr>
}
80102d20:	83 c4 10             	add    $0x10,%esp
80102d23:	c9                   	leave  
80102d24:	c3                   	ret    
80102d25:	66 90                	xchg   %ax,%ax
80102d27:	66 90                	xchg   %ax,%ax
80102d29:	66 90                	xchg   %ax,%ax
80102d2b:	66 90                	xchg   %ax,%ax
80102d2d:	66 90                	xchg   %ax,%ax
80102d2f:	90                   	nop

80102d30 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102d30:	a1 dc 66 11 80       	mov    0x801166dc,%eax
80102d35:	85 c0                	test   %eax,%eax
80102d37:	0f 84 cb 00 00 00    	je     80102e08 <lapicinit+0xd8>
  lapic[index] = value;
80102d3d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102d44:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d47:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d4a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102d51:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d54:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d57:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102d5e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102d61:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d64:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102d6b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102d6e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d71:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102d78:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102d7b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d7e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102d85:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102d88:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102d8b:	8b 50 30             	mov    0x30(%eax),%edx
80102d8e:	c1 ea 10             	shr    $0x10,%edx
80102d91:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102d97:	75 77                	jne    80102e10 <lapicinit+0xe0>
  lapic[index] = value;
80102d99:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102da0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102da3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102da6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102dad:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102db0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102db3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102dba:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102dbd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102dc0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102dc7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102dca:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102dcd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102dd4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102dd7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102dda:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102de1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102de4:	8b 50 20             	mov    0x20(%eax),%edx
80102de7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dee:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102df0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102df6:	80 e6 10             	and    $0x10,%dh
80102df9:	75 f5                	jne    80102df0 <lapicinit+0xc0>
  lapic[index] = value;
80102dfb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102e02:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e05:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102e08:	c3                   	ret    
80102e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102e10:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102e17:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102e1a:	8b 50 20             	mov    0x20(%eax),%edx
}
80102e1d:	e9 77 ff ff ff       	jmp    80102d99 <lapicinit+0x69>
80102e22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102e30 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102e30:	a1 dc 66 11 80       	mov    0x801166dc,%eax
80102e35:	85 c0                	test   %eax,%eax
80102e37:	74 07                	je     80102e40 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102e39:	8b 40 20             	mov    0x20(%eax),%eax
80102e3c:	c1 e8 18             	shr    $0x18,%eax
80102e3f:	c3                   	ret    
    return 0;
80102e40:	31 c0                	xor    %eax,%eax
}
80102e42:	c3                   	ret    
80102e43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102e50 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102e50:	a1 dc 66 11 80       	mov    0x801166dc,%eax
80102e55:	85 c0                	test   %eax,%eax
80102e57:	74 0d                	je     80102e66 <lapiceoi+0x16>
  lapic[index] = value;
80102e59:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102e60:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e63:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102e66:	c3                   	ret    
80102e67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e6e:	66 90                	xchg   %ax,%ax

80102e70 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102e70:	c3                   	ret    
80102e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e7f:	90                   	nop

80102e80 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102e80:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e81:	b8 0f 00 00 00       	mov    $0xf,%eax
80102e86:	ba 70 00 00 00       	mov    $0x70,%edx
80102e8b:	89 e5                	mov    %esp,%ebp
80102e8d:	53                   	push   %ebx
80102e8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102e91:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102e94:	ee                   	out    %al,(%dx)
80102e95:	b8 0a 00 00 00       	mov    $0xa,%eax
80102e9a:	ba 71 00 00 00       	mov    $0x71,%edx
80102e9f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102ea0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102ea2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102ea5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102eab:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102ead:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102eb0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102eb2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102eb5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102eb8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102ebe:	a1 dc 66 11 80       	mov    0x801166dc,%eax
80102ec3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ec9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ecc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102ed3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ed6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ed9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102ee0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ee3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ee6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102eec:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102eef:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ef5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ef8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102efe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f01:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102f07:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102f0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f0d:	c9                   	leave  
80102f0e:	c3                   	ret    
80102f0f:	90                   	nop

80102f10 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102f10:	55                   	push   %ebp
80102f11:	b8 0b 00 00 00       	mov    $0xb,%eax
80102f16:	ba 70 00 00 00       	mov    $0x70,%edx
80102f1b:	89 e5                	mov    %esp,%ebp
80102f1d:	57                   	push   %edi
80102f1e:	56                   	push   %esi
80102f1f:	53                   	push   %ebx
80102f20:	83 ec 4c             	sub    $0x4c,%esp
80102f23:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f24:	ba 71 00 00 00       	mov    $0x71,%edx
80102f29:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102f2a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f2d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102f32:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102f35:	8d 76 00             	lea    0x0(%esi),%esi
80102f38:	31 c0                	xor    %eax,%eax
80102f3a:	89 da                	mov    %ebx,%edx
80102f3c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f3d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102f42:	89 ca                	mov    %ecx,%edx
80102f44:	ec                   	in     (%dx),%al
80102f45:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f48:	89 da                	mov    %ebx,%edx
80102f4a:	b8 02 00 00 00       	mov    $0x2,%eax
80102f4f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f50:	89 ca                	mov    %ecx,%edx
80102f52:	ec                   	in     (%dx),%al
80102f53:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f56:	89 da                	mov    %ebx,%edx
80102f58:	b8 04 00 00 00       	mov    $0x4,%eax
80102f5d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f5e:	89 ca                	mov    %ecx,%edx
80102f60:	ec                   	in     (%dx),%al
80102f61:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f64:	89 da                	mov    %ebx,%edx
80102f66:	b8 07 00 00 00       	mov    $0x7,%eax
80102f6b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f6c:	89 ca                	mov    %ecx,%edx
80102f6e:	ec                   	in     (%dx),%al
80102f6f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f72:	89 da                	mov    %ebx,%edx
80102f74:	b8 08 00 00 00       	mov    $0x8,%eax
80102f79:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f7a:	89 ca                	mov    %ecx,%edx
80102f7c:	ec                   	in     (%dx),%al
80102f7d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f7f:	89 da                	mov    %ebx,%edx
80102f81:	b8 09 00 00 00       	mov    $0x9,%eax
80102f86:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f87:	89 ca                	mov    %ecx,%edx
80102f89:	ec                   	in     (%dx),%al
80102f8a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f8c:	89 da                	mov    %ebx,%edx
80102f8e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102f93:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f94:	89 ca                	mov    %ecx,%edx
80102f96:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102f97:	84 c0                	test   %al,%al
80102f99:	78 9d                	js     80102f38 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102f9b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102f9f:	89 fa                	mov    %edi,%edx
80102fa1:	0f b6 fa             	movzbl %dl,%edi
80102fa4:	89 f2                	mov    %esi,%edx
80102fa6:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102fa9:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102fad:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102fb0:	89 da                	mov    %ebx,%edx
80102fb2:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102fb5:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102fb8:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102fbc:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102fbf:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102fc2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102fc6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102fc9:	31 c0                	xor    %eax,%eax
80102fcb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102fcc:	89 ca                	mov    %ecx,%edx
80102fce:	ec                   	in     (%dx),%al
80102fcf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102fd2:	89 da                	mov    %ebx,%edx
80102fd4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102fd7:	b8 02 00 00 00       	mov    $0x2,%eax
80102fdc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102fdd:	89 ca                	mov    %ecx,%edx
80102fdf:	ec                   	in     (%dx),%al
80102fe0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102fe3:	89 da                	mov    %ebx,%edx
80102fe5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102fe8:	b8 04 00 00 00       	mov    $0x4,%eax
80102fed:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102fee:	89 ca                	mov    %ecx,%edx
80102ff0:	ec                   	in     (%dx),%al
80102ff1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ff4:	89 da                	mov    %ebx,%edx
80102ff6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ff9:	b8 07 00 00 00       	mov    $0x7,%eax
80102ffe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102fff:	89 ca                	mov    %ecx,%edx
80103001:	ec                   	in     (%dx),%al
80103002:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103005:	89 da                	mov    %ebx,%edx
80103007:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010300a:	b8 08 00 00 00       	mov    $0x8,%eax
8010300f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103010:	89 ca                	mov    %ecx,%edx
80103012:	ec                   	in     (%dx),%al
80103013:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103016:	89 da                	mov    %ebx,%edx
80103018:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010301b:	b8 09 00 00 00       	mov    $0x9,%eax
80103020:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103021:	89 ca                	mov    %ecx,%edx
80103023:	ec                   	in     (%dx),%al
80103024:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103027:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010302a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010302d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80103030:	6a 18                	push   $0x18
80103032:	50                   	push   %eax
80103033:	8d 45 b8             	lea    -0x48(%ebp),%eax
80103036:	50                   	push   %eax
80103037:	e8 e4 1e 00 00       	call   80104f20 <memcmp>
8010303c:	83 c4 10             	add    $0x10,%esp
8010303f:	85 c0                	test   %eax,%eax
80103041:	0f 85 f1 fe ff ff    	jne    80102f38 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80103047:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010304b:	75 78                	jne    801030c5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010304d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103050:	89 c2                	mov    %eax,%edx
80103052:	83 e0 0f             	and    $0xf,%eax
80103055:	c1 ea 04             	shr    $0x4,%edx
80103058:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010305b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010305e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80103061:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103064:	89 c2                	mov    %eax,%edx
80103066:	83 e0 0f             	and    $0xf,%eax
80103069:	c1 ea 04             	shr    $0x4,%edx
8010306c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010306f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103072:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80103075:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103078:	89 c2                	mov    %eax,%edx
8010307a:	83 e0 0f             	and    $0xf,%eax
8010307d:	c1 ea 04             	shr    $0x4,%edx
80103080:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103083:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103086:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80103089:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010308c:	89 c2                	mov    %eax,%edx
8010308e:	83 e0 0f             	and    $0xf,%eax
80103091:	c1 ea 04             	shr    $0x4,%edx
80103094:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103097:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010309a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010309d:	8b 45 c8             	mov    -0x38(%ebp),%eax
801030a0:	89 c2                	mov    %eax,%edx
801030a2:	83 e0 0f             	and    $0xf,%eax
801030a5:	c1 ea 04             	shr    $0x4,%edx
801030a8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801030ab:	8d 04 50             	lea    (%eax,%edx,2),%eax
801030ae:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801030b1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801030b4:	89 c2                	mov    %eax,%edx
801030b6:	83 e0 0f             	and    $0xf,%eax
801030b9:	c1 ea 04             	shr    $0x4,%edx
801030bc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801030bf:	8d 04 50             	lea    (%eax,%edx,2),%eax
801030c2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801030c5:	8b 75 08             	mov    0x8(%ebp),%esi
801030c8:	8b 45 b8             	mov    -0x48(%ebp),%eax
801030cb:	89 06                	mov    %eax,(%esi)
801030cd:	8b 45 bc             	mov    -0x44(%ebp),%eax
801030d0:	89 46 04             	mov    %eax,0x4(%esi)
801030d3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801030d6:	89 46 08             	mov    %eax,0x8(%esi)
801030d9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801030dc:	89 46 0c             	mov    %eax,0xc(%esi)
801030df:	8b 45 c8             	mov    -0x38(%ebp),%eax
801030e2:	89 46 10             	mov    %eax,0x10(%esi)
801030e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
801030e8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801030eb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801030f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030f5:	5b                   	pop    %ebx
801030f6:	5e                   	pop    %esi
801030f7:	5f                   	pop    %edi
801030f8:	5d                   	pop    %ebp
801030f9:	c3                   	ret    
801030fa:	66 90                	xchg   %ax,%ax
801030fc:	66 90                	xchg   %ax,%ax
801030fe:	66 90                	xchg   %ax,%ax

80103100 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103100:	8b 0d 28 67 11 80    	mov    0x80116728,%ecx
80103106:	85 c9                	test   %ecx,%ecx
80103108:	0f 8e 8a 00 00 00    	jle    80103198 <install_trans+0x98>
{
8010310e:	55                   	push   %ebp
8010310f:	89 e5                	mov    %esp,%ebp
80103111:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103112:	31 ff                	xor    %edi,%edi
{
80103114:	56                   	push   %esi
80103115:	53                   	push   %ebx
80103116:	83 ec 0c             	sub    $0xc,%esp
80103119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103120:	a1 14 67 11 80       	mov    0x80116714,%eax
80103125:	83 ec 08             	sub    $0x8,%esp
80103128:	01 f8                	add    %edi,%eax
8010312a:	83 c0 01             	add    $0x1,%eax
8010312d:	50                   	push   %eax
8010312e:	ff 35 24 67 11 80    	push   0x80116724
80103134:	e8 97 cf ff ff       	call   801000d0 <bread>
80103139:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010313b:	58                   	pop    %eax
8010313c:	5a                   	pop    %edx
8010313d:	ff 34 bd 2c 67 11 80 	push   -0x7fee98d4(,%edi,4)
80103144:	ff 35 24 67 11 80    	push   0x80116724
  for (tail = 0; tail < log.lh.n; tail++) {
8010314a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010314d:	e8 7e cf ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103152:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103155:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103157:	8d 46 5c             	lea    0x5c(%esi),%eax
8010315a:	68 00 02 00 00       	push   $0x200
8010315f:	50                   	push   %eax
80103160:	8d 43 5c             	lea    0x5c(%ebx),%eax
80103163:	50                   	push   %eax
80103164:	e8 07 1e 00 00       	call   80104f70 <memmove>
    bwrite(dbuf);  // write dst to disk
80103169:	89 1c 24             	mov    %ebx,(%esp)
8010316c:	e8 3f d0 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80103171:	89 34 24             	mov    %esi,(%esp)
80103174:	e8 77 d0 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80103179:	89 1c 24             	mov    %ebx,(%esp)
8010317c:	e8 6f d0 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103181:	83 c4 10             	add    $0x10,%esp
80103184:	39 3d 28 67 11 80    	cmp    %edi,0x80116728
8010318a:	7f 94                	jg     80103120 <install_trans+0x20>
  }
}
8010318c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010318f:	5b                   	pop    %ebx
80103190:	5e                   	pop    %esi
80103191:	5f                   	pop    %edi
80103192:	5d                   	pop    %ebp
80103193:	c3                   	ret    
80103194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103198:	c3                   	ret    
80103199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801031a0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801031a0:	55                   	push   %ebp
801031a1:	89 e5                	mov    %esp,%ebp
801031a3:	53                   	push   %ebx
801031a4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
801031a7:	ff 35 14 67 11 80    	push   0x80116714
801031ad:	ff 35 24 67 11 80    	push   0x80116724
801031b3:	e8 18 cf ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801031b8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
801031bb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
801031bd:	a1 28 67 11 80       	mov    0x80116728,%eax
801031c2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
801031c5:	85 c0                	test   %eax,%eax
801031c7:	7e 19                	jle    801031e2 <write_head+0x42>
801031c9:	31 d2                	xor    %edx,%edx
801031cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031cf:	90                   	nop
    hb->block[i] = log.lh.block[i];
801031d0:	8b 0c 95 2c 67 11 80 	mov    -0x7fee98d4(,%edx,4),%ecx
801031d7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801031db:	83 c2 01             	add    $0x1,%edx
801031de:	39 d0                	cmp    %edx,%eax
801031e0:	75 ee                	jne    801031d0 <write_head+0x30>
  }
  bwrite(buf);
801031e2:	83 ec 0c             	sub    $0xc,%esp
801031e5:	53                   	push   %ebx
801031e6:	e8 c5 cf ff ff       	call   801001b0 <bwrite>
  brelse(buf);
801031eb:	89 1c 24             	mov    %ebx,(%esp)
801031ee:	e8 fd cf ff ff       	call   801001f0 <brelse>
}
801031f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801031f6:	83 c4 10             	add    $0x10,%esp
801031f9:	c9                   	leave  
801031fa:	c3                   	ret    
801031fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031ff:	90                   	nop

80103200 <initlog>:
{
80103200:	55                   	push   %ebp
80103201:	89 e5                	mov    %esp,%ebp
80103203:	53                   	push   %ebx
80103204:	83 ec 3c             	sub    $0x3c,%esp
80103207:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010320a:	68 60 83 10 80       	push   $0x80108360
8010320f:	68 e0 66 11 80       	push   $0x801166e0
80103214:	e8 27 1a 00 00       	call   80104c40 <initlock>
  readsb(dev, &sb);
80103219:	58                   	pop    %eax
8010321a:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010321d:	5a                   	pop    %edx
8010321e:	50                   	push   %eax
8010321f:	53                   	push   %ebx
80103220:	e8 0b e3 ff ff       	call   80101530 <readsb>
  log.start = sb.logstart;
80103225:	8b 45 e8             	mov    -0x18(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80103228:	59                   	pop    %ecx
  log.dev = dev;
80103229:	89 1d 24 67 11 80    	mov    %ebx,0x80116724
  log.size = sb.nlog;
8010322f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  log.start = sb.logstart;
80103232:	a3 14 67 11 80       	mov    %eax,0x80116714
  log.size = sb.nlog;
80103237:	89 15 18 67 11 80    	mov    %edx,0x80116718
  struct buf *buf = bread(log.dev, log.start);
8010323d:	5a                   	pop    %edx
8010323e:	50                   	push   %eax
8010323f:	53                   	push   %ebx
80103240:	e8 8b ce ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103245:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80103248:	8b 58 5c             	mov    0x5c(%eax),%ebx
8010324b:	89 1d 28 67 11 80    	mov    %ebx,0x80116728
  for (i = 0; i < log.lh.n; i++) {
80103251:	85 db                	test   %ebx,%ebx
80103253:	7e 1d                	jle    80103272 <initlog+0x72>
80103255:	31 d2                	xor    %edx,%edx
80103257:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010325e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80103260:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80103264:	89 0c 95 2c 67 11 80 	mov    %ecx,-0x7fee98d4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010326b:	83 c2 01             	add    $0x1,%edx
8010326e:	39 d3                	cmp    %edx,%ebx
80103270:	75 ee                	jne    80103260 <initlog+0x60>
  brelse(buf);
80103272:	83 ec 0c             	sub    $0xc,%esp
80103275:	50                   	push   %eax
80103276:	e8 75 cf ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010327b:	e8 80 fe ff ff       	call   80103100 <install_trans>
  log.lh.n = 0;
80103280:	c7 05 28 67 11 80 00 	movl   $0x0,0x80116728
80103287:	00 00 00 
  write_head(); // clear the log
8010328a:	e8 11 ff ff ff       	call   801031a0 <write_head>
}
8010328f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103292:	83 c4 10             	add    $0x10,%esp
80103295:	c9                   	leave  
80103296:	c3                   	ret    
80103297:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010329e:	66 90                	xchg   %ax,%ax

801032a0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801032a0:	55                   	push   %ebp
801032a1:	89 e5                	mov    %esp,%ebp
801032a3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801032a6:	68 e0 66 11 80       	push   $0x801166e0
801032ab:	e8 60 1b 00 00       	call   80104e10 <acquire>
801032b0:	83 c4 10             	add    $0x10,%esp
801032b3:	eb 18                	jmp    801032cd <begin_op+0x2d>
801032b5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801032b8:	83 ec 08             	sub    $0x8,%esp
801032bb:	68 e0 66 11 80       	push   $0x801166e0
801032c0:	68 e0 66 11 80       	push   $0x801166e0
801032c5:	e8 d6 10 00 00       	call   801043a0 <sleep>
801032ca:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801032cd:	a1 20 67 11 80       	mov    0x80116720,%eax
801032d2:	85 c0                	test   %eax,%eax
801032d4:	75 e2                	jne    801032b8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801032d6:	a1 1c 67 11 80       	mov    0x8011671c,%eax
801032db:	8b 15 28 67 11 80    	mov    0x80116728,%edx
801032e1:	83 c0 01             	add    $0x1,%eax
801032e4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801032e7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801032ea:	83 fa 1e             	cmp    $0x1e,%edx
801032ed:	7f c9                	jg     801032b8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
801032ef:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
801032f2:	a3 1c 67 11 80       	mov    %eax,0x8011671c
      release(&log.lock);
801032f7:	68 e0 66 11 80       	push   $0x801166e0
801032fc:	e8 af 1a 00 00       	call   80104db0 <release>
      break;
    }
  }
}
80103301:	83 c4 10             	add    $0x10,%esp
80103304:	c9                   	leave  
80103305:	c3                   	ret    
80103306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010330d:	8d 76 00             	lea    0x0(%esi),%esi

80103310 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103310:	55                   	push   %ebp
80103311:	89 e5                	mov    %esp,%ebp
80103313:	57                   	push   %edi
80103314:	56                   	push   %esi
80103315:	53                   	push   %ebx
80103316:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103319:	68 e0 66 11 80       	push   $0x801166e0
8010331e:	e8 ed 1a 00 00       	call   80104e10 <acquire>
  log.outstanding -= 1;
80103323:	a1 1c 67 11 80       	mov    0x8011671c,%eax
  if(log.committing)
80103328:	8b 35 20 67 11 80    	mov    0x80116720,%esi
8010332e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103331:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103334:	89 1d 1c 67 11 80    	mov    %ebx,0x8011671c
  if(log.committing)
8010333a:	85 f6                	test   %esi,%esi
8010333c:	0f 85 22 01 00 00    	jne    80103464 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103342:	85 db                	test   %ebx,%ebx
80103344:	0f 85 f6 00 00 00    	jne    80103440 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010334a:	c7 05 20 67 11 80 01 	movl   $0x1,0x80116720
80103351:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103354:	83 ec 0c             	sub    $0xc,%esp
80103357:	68 e0 66 11 80       	push   $0x801166e0
8010335c:	e8 4f 1a 00 00       	call   80104db0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103361:	8b 0d 28 67 11 80    	mov    0x80116728,%ecx
80103367:	83 c4 10             	add    $0x10,%esp
8010336a:	85 c9                	test   %ecx,%ecx
8010336c:	7f 42                	jg     801033b0 <end_op+0xa0>
    acquire(&log.lock);
8010336e:	83 ec 0c             	sub    $0xc,%esp
80103371:	68 e0 66 11 80       	push   $0x801166e0
80103376:	e8 95 1a 00 00       	call   80104e10 <acquire>
    wakeup(&log);
8010337b:	c7 04 24 e0 66 11 80 	movl   $0x801166e0,(%esp)
    log.committing = 0;
80103382:	c7 05 20 67 11 80 00 	movl   $0x0,0x80116720
80103389:	00 00 00 
    wakeup(&log);
8010338c:	e8 cf 10 00 00       	call   80104460 <wakeup>
    release(&log.lock);
80103391:	c7 04 24 e0 66 11 80 	movl   $0x801166e0,(%esp)
80103398:	e8 13 1a 00 00       	call   80104db0 <release>
8010339d:	83 c4 10             	add    $0x10,%esp
}
801033a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033a3:	5b                   	pop    %ebx
801033a4:	5e                   	pop    %esi
801033a5:	5f                   	pop    %edi
801033a6:	5d                   	pop    %ebp
801033a7:	c3                   	ret    
801033a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033af:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801033b0:	a1 14 67 11 80       	mov    0x80116714,%eax
801033b5:	83 ec 08             	sub    $0x8,%esp
801033b8:	01 d8                	add    %ebx,%eax
801033ba:	83 c0 01             	add    $0x1,%eax
801033bd:	50                   	push   %eax
801033be:	ff 35 24 67 11 80    	push   0x80116724
801033c4:	e8 07 cd ff ff       	call   801000d0 <bread>
801033c9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801033cb:	58                   	pop    %eax
801033cc:	5a                   	pop    %edx
801033cd:	ff 34 9d 2c 67 11 80 	push   -0x7fee98d4(,%ebx,4)
801033d4:	ff 35 24 67 11 80    	push   0x80116724
  for (tail = 0; tail < log.lh.n; tail++) {
801033da:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801033dd:	e8 ee cc ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
801033e2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801033e5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801033e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801033ea:	68 00 02 00 00       	push   $0x200
801033ef:	50                   	push   %eax
801033f0:	8d 46 5c             	lea    0x5c(%esi),%eax
801033f3:	50                   	push   %eax
801033f4:	e8 77 1b 00 00       	call   80104f70 <memmove>
    bwrite(to);  // write the log
801033f9:	89 34 24             	mov    %esi,(%esp)
801033fc:	e8 af cd ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103401:	89 3c 24             	mov    %edi,(%esp)
80103404:	e8 e7 cd ff ff       	call   801001f0 <brelse>
    brelse(to);
80103409:	89 34 24             	mov    %esi,(%esp)
8010340c:	e8 df cd ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103411:	83 c4 10             	add    $0x10,%esp
80103414:	3b 1d 28 67 11 80    	cmp    0x80116728,%ebx
8010341a:	7c 94                	jl     801033b0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010341c:	e8 7f fd ff ff       	call   801031a0 <write_head>
    install_trans(); // Now install writes to home locations
80103421:	e8 da fc ff ff       	call   80103100 <install_trans>
    log.lh.n = 0;
80103426:	c7 05 28 67 11 80 00 	movl   $0x0,0x80116728
8010342d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103430:	e8 6b fd ff ff       	call   801031a0 <write_head>
80103435:	e9 34 ff ff ff       	jmp    8010336e <end_op+0x5e>
8010343a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103440:	83 ec 0c             	sub    $0xc,%esp
80103443:	68 e0 66 11 80       	push   $0x801166e0
80103448:	e8 13 10 00 00       	call   80104460 <wakeup>
  release(&log.lock);
8010344d:	c7 04 24 e0 66 11 80 	movl   $0x801166e0,(%esp)
80103454:	e8 57 19 00 00       	call   80104db0 <release>
80103459:	83 c4 10             	add    $0x10,%esp
}
8010345c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010345f:	5b                   	pop    %ebx
80103460:	5e                   	pop    %esi
80103461:	5f                   	pop    %edi
80103462:	5d                   	pop    %ebp
80103463:	c3                   	ret    
    panic("log.committing");
80103464:	83 ec 0c             	sub    $0xc,%esp
80103467:	68 64 83 10 80       	push   $0x80108364
8010346c:	e8 0f cf ff ff       	call   80100380 <panic>
80103471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103478:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010347f:	90                   	nop

80103480 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103480:	55                   	push   %ebp
80103481:	89 e5                	mov    %esp,%ebp
80103483:	53                   	push   %ebx
80103484:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103487:	8b 15 28 67 11 80    	mov    0x80116728,%edx
{
8010348d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103490:	83 fa 1d             	cmp    $0x1d,%edx
80103493:	0f 8f 85 00 00 00    	jg     8010351e <log_write+0x9e>
80103499:	a1 18 67 11 80       	mov    0x80116718,%eax
8010349e:	83 e8 01             	sub    $0x1,%eax
801034a1:	39 c2                	cmp    %eax,%edx
801034a3:	7d 79                	jge    8010351e <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
801034a5:	a1 1c 67 11 80       	mov    0x8011671c,%eax
801034aa:	85 c0                	test   %eax,%eax
801034ac:	7e 7d                	jle    8010352b <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
801034ae:	83 ec 0c             	sub    $0xc,%esp
801034b1:	68 e0 66 11 80       	push   $0x801166e0
801034b6:	e8 55 19 00 00       	call   80104e10 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801034bb:	8b 15 28 67 11 80    	mov    0x80116728,%edx
801034c1:	83 c4 10             	add    $0x10,%esp
801034c4:	85 d2                	test   %edx,%edx
801034c6:	7e 4a                	jle    80103512 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801034c8:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
801034cb:	31 c0                	xor    %eax,%eax
801034cd:	eb 08                	jmp    801034d7 <log_write+0x57>
801034cf:	90                   	nop
801034d0:	83 c0 01             	add    $0x1,%eax
801034d3:	39 c2                	cmp    %eax,%edx
801034d5:	74 29                	je     80103500 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801034d7:	39 0c 85 2c 67 11 80 	cmp    %ecx,-0x7fee98d4(,%eax,4)
801034de:	75 f0                	jne    801034d0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
801034e0:	89 0c 85 2c 67 11 80 	mov    %ecx,-0x7fee98d4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801034e7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801034ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801034ed:	c7 45 08 e0 66 11 80 	movl   $0x801166e0,0x8(%ebp)
}
801034f4:	c9                   	leave  
  release(&log.lock);
801034f5:	e9 b6 18 00 00       	jmp    80104db0 <release>
801034fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103500:	89 0c 95 2c 67 11 80 	mov    %ecx,-0x7fee98d4(,%edx,4)
    log.lh.n++;
80103507:	83 c2 01             	add    $0x1,%edx
8010350a:	89 15 28 67 11 80    	mov    %edx,0x80116728
80103510:	eb d5                	jmp    801034e7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80103512:	8b 43 08             	mov    0x8(%ebx),%eax
80103515:	a3 2c 67 11 80       	mov    %eax,0x8011672c
  if (i == log.lh.n)
8010351a:	75 cb                	jne    801034e7 <log_write+0x67>
8010351c:	eb e9                	jmp    80103507 <log_write+0x87>
    panic("too big a transaction");
8010351e:	83 ec 0c             	sub    $0xc,%esp
80103521:	68 73 83 10 80       	push   $0x80108373
80103526:	e8 55 ce ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010352b:	83 ec 0c             	sub    $0xc,%esp
8010352e:	68 89 83 10 80       	push   $0x80108389
80103533:	e8 48 ce ff ff       	call   80100380 <panic>
80103538:	66 90                	xchg   %ax,%ax
8010353a:	66 90                	xchg   %ax,%ax
8010353c:	66 90                	xchg   %ax,%ax
8010353e:	66 90                	xchg   %ax,%ax

80103540 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103540:	55                   	push   %ebp
80103541:	89 e5                	mov    %esp,%ebp
80103543:	53                   	push   %ebx
80103544:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103547:	e8 44 09 00 00       	call   80103e90 <cpuid>
8010354c:	89 c3                	mov    %eax,%ebx
8010354e:	e8 3d 09 00 00       	call   80103e90 <cpuid>
80103553:	83 ec 04             	sub    $0x4,%esp
80103556:	53                   	push   %ebx
80103557:	50                   	push   %eax
80103558:	68 a4 83 10 80       	push   $0x801083a4
8010355d:	e8 3e d1 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103562:	e8 09 2c 00 00       	call   80106170 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103567:	e8 c4 08 00 00       	call   80103e30 <mycpu>
8010356c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010356e:	b8 01 00 00 00       	mov    $0x1,%eax
80103573:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010357a:	e8 41 0b 00 00       	call   801040c0 <scheduler>
8010357f:	90                   	nop

80103580 <mpenter>:
{
80103580:	55                   	push   %ebp
80103581:	89 e5                	mov    %esp,%ebp
80103583:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103586:	e8 d5 3c 00 00       	call   80107260 <switchkvm>
  seginit();
8010358b:	e8 b0 3b 00 00       	call   80107140 <seginit>
  lapicinit();
80103590:	e8 9b f7 ff ff       	call   80102d30 <lapicinit>
  mpmain();
80103595:	e8 a6 ff ff ff       	call   80103540 <mpmain>
8010359a:	66 90                	xchg   %ax,%ax
8010359c:	66 90                	xchg   %ax,%ax
8010359e:	66 90                	xchg   %ax,%ax

801035a0 <main>:
{
801035a0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801035a4:	83 e4 f0             	and    $0xfffffff0,%esp
801035a7:	ff 71 fc             	push   -0x4(%ecx)
801035aa:	55                   	push   %ebp
801035ab:	89 e5                	mov    %esp,%ebp
801035ad:	53                   	push   %ebx
801035ae:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801035af:	83 ec 08             	sub    $0x8,%esp
801035b2:	68 00 00 40 80       	push   $0x80400000
801035b7:	68 00 b9 11 80       	push   $0x8011b900
801035bc:	e8 bf f4 ff ff       	call   80102a80 <kinit1>
  kvmalloc();      // kernel page table
801035c1:	e8 4a 42 00 00       	call   80107810 <kvmalloc>
  mpinit();        // detect other processors
801035c6:	e8 85 01 00 00       	call   80103750 <mpinit>
  lapicinit();     // interrupt controller
801035cb:	e8 60 f7 ff ff       	call   80102d30 <lapicinit>
  seginit();       // segment descriptors
801035d0:	e8 6b 3b 00 00       	call   80107140 <seginit>
  picinit();       // disable pic
801035d5:	e8 76 03 00 00       	call   80103950 <picinit>
  ioapicinit();    // another interrupt controller
801035da:	e8 11 ee ff ff       	call   801023f0 <ioapicinit>
  consoleinit();   // console hardware
801035df:	e8 7c d4 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801035e4:	e8 97 2e 00 00       	call   80106480 <uartinit>
  pinit();         // process table
801035e9:	e8 22 08 00 00       	call   80103e10 <pinit>
  tvinit();        // trap vectors
801035ee:	e8 fd 2a 00 00       	call   801060f0 <tvinit>
  binit();         // buffer cache
801035f3:	e8 48 ca ff ff       	call   80100040 <binit>
  fileinit();      // file table
801035f8:	e8 23 d8 ff ff       	call   80100e20 <fileinit>
  ideinit();       // disk 
801035fd:	e8 de eb ff ff       	call   801021e0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103602:	83 c4 0c             	add    $0xc,%esp
80103605:	68 8a 00 00 00       	push   $0x8a
8010360a:	68 8c b4 10 80       	push   $0x8010b48c
8010360f:	68 00 70 00 80       	push   $0x80007000
80103614:	e8 57 19 00 00       	call   80104f70 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103619:	83 c4 10             	add    $0x10,%esp
8010361c:	69 05 c4 67 11 80 b0 	imul   $0xb0,0x801167c4,%eax
80103623:	00 00 00 
80103626:	05 e0 67 11 80       	add    $0x801167e0,%eax
8010362b:	3d e0 67 11 80       	cmp    $0x801167e0,%eax
80103630:	76 7e                	jbe    801036b0 <main+0x110>
80103632:	bb e0 67 11 80       	mov    $0x801167e0,%ebx
80103637:	eb 20                	jmp    80103659 <main+0xb9>
80103639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103640:	69 05 c4 67 11 80 b0 	imul   $0xb0,0x801167c4,%eax
80103647:	00 00 00 
8010364a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103650:	05 e0 67 11 80       	add    $0x801167e0,%eax
80103655:	39 c3                	cmp    %eax,%ebx
80103657:	73 57                	jae    801036b0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103659:	e8 d2 07 00 00       	call   80103e30 <mycpu>
8010365e:	39 c3                	cmp    %eax,%ebx
80103660:	74 de                	je     80103640 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103662:	e8 99 f4 ff ff       	call   80102b00 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103667:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010366a:	c7 05 f8 6f 00 80 80 	movl   $0x80103580,0x80006ff8
80103671:	35 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103674:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010367b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010367e:	05 00 10 00 00       	add    $0x1000,%eax
80103683:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103688:	0f b6 03             	movzbl (%ebx),%eax
8010368b:	68 00 70 00 00       	push   $0x7000
80103690:	50                   	push   %eax
80103691:	e8 ea f7 ff ff       	call   80102e80 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103696:	83 c4 10             	add    $0x10,%esp
80103699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036a0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801036a6:	85 c0                	test   %eax,%eax
801036a8:	74 f6                	je     801036a0 <main+0x100>
801036aa:	eb 94                	jmp    80103640 <main+0xa0>
801036ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801036b0:	83 ec 08             	sub    $0x8,%esp
801036b3:	68 00 00 40 80       	push   $0x80400000
801036b8:	68 00 00 40 80       	push   $0x80400000
801036bd:	e8 5e f3 ff ff       	call   80102a20 <kinit2>
  userinit();      // first user process
801036c2:	e8 19 08 00 00       	call   80103ee0 <userinit>
  mpmain();        // finish this processor's setup
801036c7:	e8 74 fe ff ff       	call   80103540 <mpmain>
801036cc:	66 90                	xchg   %ax,%ax
801036ce:	66 90                	xchg   %ax,%ax

801036d0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	57                   	push   %edi
801036d4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801036d5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801036db:	53                   	push   %ebx
  e = addr+len;
801036dc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801036df:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801036e2:	39 de                	cmp    %ebx,%esi
801036e4:	72 10                	jb     801036f6 <mpsearch1+0x26>
801036e6:	eb 50                	jmp    80103738 <mpsearch1+0x68>
801036e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036ef:	90                   	nop
801036f0:	89 fe                	mov    %edi,%esi
801036f2:	39 fb                	cmp    %edi,%ebx
801036f4:	76 42                	jbe    80103738 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801036f6:	83 ec 04             	sub    $0x4,%esp
801036f9:	8d 7e 10             	lea    0x10(%esi),%edi
801036fc:	6a 04                	push   $0x4
801036fe:	68 b8 83 10 80       	push   $0x801083b8
80103703:	56                   	push   %esi
80103704:	e8 17 18 00 00       	call   80104f20 <memcmp>
80103709:	83 c4 10             	add    $0x10,%esp
8010370c:	85 c0                	test   %eax,%eax
8010370e:	75 e0                	jne    801036f0 <mpsearch1+0x20>
80103710:	89 f2                	mov    %esi,%edx
80103712:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103718:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010371b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010371e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103720:	39 fa                	cmp    %edi,%edx
80103722:	75 f4                	jne    80103718 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103724:	84 c0                	test   %al,%al
80103726:	75 c8                	jne    801036f0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103728:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010372b:	89 f0                	mov    %esi,%eax
8010372d:	5b                   	pop    %ebx
8010372e:	5e                   	pop    %esi
8010372f:	5f                   	pop    %edi
80103730:	5d                   	pop    %ebp
80103731:	c3                   	ret    
80103732:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103738:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010373b:	31 f6                	xor    %esi,%esi
}
8010373d:	5b                   	pop    %ebx
8010373e:	89 f0                	mov    %esi,%eax
80103740:	5e                   	pop    %esi
80103741:	5f                   	pop    %edi
80103742:	5d                   	pop    %ebp
80103743:	c3                   	ret    
80103744:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010374b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010374f:	90                   	nop

80103750 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	57                   	push   %edi
80103754:	56                   	push   %esi
80103755:	53                   	push   %ebx
80103756:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103759:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103760:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103767:	c1 e0 08             	shl    $0x8,%eax
8010376a:	09 d0                	or     %edx,%eax
8010376c:	c1 e0 04             	shl    $0x4,%eax
8010376f:	75 1b                	jne    8010378c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103771:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103778:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010377f:	c1 e0 08             	shl    $0x8,%eax
80103782:	09 d0                	or     %edx,%eax
80103784:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103787:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010378c:	ba 00 04 00 00       	mov    $0x400,%edx
80103791:	e8 3a ff ff ff       	call   801036d0 <mpsearch1>
80103796:	89 c3                	mov    %eax,%ebx
80103798:	85 c0                	test   %eax,%eax
8010379a:	0f 84 40 01 00 00    	je     801038e0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801037a0:	8b 73 04             	mov    0x4(%ebx),%esi
801037a3:	85 f6                	test   %esi,%esi
801037a5:	0f 84 25 01 00 00    	je     801038d0 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
801037ab:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801037ae:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801037b4:	6a 04                	push   $0x4
801037b6:	68 bd 83 10 80       	push   $0x801083bd
801037bb:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801037bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801037bf:	e8 5c 17 00 00       	call   80104f20 <memcmp>
801037c4:	83 c4 10             	add    $0x10,%esp
801037c7:	85 c0                	test   %eax,%eax
801037c9:	0f 85 01 01 00 00    	jne    801038d0 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
801037cf:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801037d6:	3c 01                	cmp    $0x1,%al
801037d8:	74 08                	je     801037e2 <mpinit+0x92>
801037da:	3c 04                	cmp    $0x4,%al
801037dc:	0f 85 ee 00 00 00    	jne    801038d0 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801037e2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801037e9:	66 85 d2             	test   %dx,%dx
801037ec:	74 22                	je     80103810 <mpinit+0xc0>
801037ee:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801037f1:	89 f0                	mov    %esi,%eax
  sum = 0;
801037f3:	31 d2                	xor    %edx,%edx
801037f5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801037f8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801037ff:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103802:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103804:	39 c7                	cmp    %eax,%edi
80103806:	75 f0                	jne    801037f8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103808:	84 d2                	test   %dl,%dl
8010380a:	0f 85 c0 00 00 00    	jne    801038d0 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103810:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103816:	a3 dc 66 11 80       	mov    %eax,0x801166dc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010381b:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103822:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
80103828:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010382d:	03 55 e4             	add    -0x1c(%ebp),%edx
80103830:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103837:	90                   	nop
80103838:	39 d0                	cmp    %edx,%eax
8010383a:	73 15                	jae    80103851 <mpinit+0x101>
    switch(*p){
8010383c:	0f b6 08             	movzbl (%eax),%ecx
8010383f:	80 f9 02             	cmp    $0x2,%cl
80103842:	74 4c                	je     80103890 <mpinit+0x140>
80103844:	77 3a                	ja     80103880 <mpinit+0x130>
80103846:	84 c9                	test   %cl,%cl
80103848:	74 56                	je     801038a0 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010384a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010384d:	39 d0                	cmp    %edx,%eax
8010384f:	72 eb                	jb     8010383c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103851:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103854:	85 f6                	test   %esi,%esi
80103856:	0f 84 d9 00 00 00    	je     80103935 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010385c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103860:	74 15                	je     80103877 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103862:	b8 70 00 00 00       	mov    $0x70,%eax
80103867:	ba 22 00 00 00       	mov    $0x22,%edx
8010386c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010386d:	ba 23 00 00 00       	mov    $0x23,%edx
80103872:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103873:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103876:	ee                   	out    %al,(%dx)
  }
}
80103877:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010387a:	5b                   	pop    %ebx
8010387b:	5e                   	pop    %esi
8010387c:	5f                   	pop    %edi
8010387d:	5d                   	pop    %ebp
8010387e:	c3                   	ret    
8010387f:	90                   	nop
    switch(*p){
80103880:	83 e9 03             	sub    $0x3,%ecx
80103883:	80 f9 01             	cmp    $0x1,%cl
80103886:	76 c2                	jbe    8010384a <mpinit+0xfa>
80103888:	31 f6                	xor    %esi,%esi
8010388a:	eb ac                	jmp    80103838 <mpinit+0xe8>
8010388c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103890:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103894:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103897:	88 0d c0 67 11 80    	mov    %cl,0x801167c0
      continue;
8010389d:	eb 99                	jmp    80103838 <mpinit+0xe8>
8010389f:	90                   	nop
      if(ncpu < NCPU) {
801038a0:	8b 0d c4 67 11 80    	mov    0x801167c4,%ecx
801038a6:	83 f9 07             	cmp    $0x7,%ecx
801038a9:	7f 19                	jg     801038c4 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801038ab:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801038b1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801038b5:	83 c1 01             	add    $0x1,%ecx
801038b8:	89 0d c4 67 11 80    	mov    %ecx,0x801167c4
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801038be:	88 9f e0 67 11 80    	mov    %bl,-0x7fee9820(%edi)
      p += sizeof(struct mpproc);
801038c4:	83 c0 14             	add    $0x14,%eax
      continue;
801038c7:	e9 6c ff ff ff       	jmp    80103838 <mpinit+0xe8>
801038cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801038d0:	83 ec 0c             	sub    $0xc,%esp
801038d3:	68 c2 83 10 80       	push   $0x801083c2
801038d8:	e8 a3 ca ff ff       	call   80100380 <panic>
801038dd:	8d 76 00             	lea    0x0(%esi),%esi
{
801038e0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801038e5:	eb 13                	jmp    801038fa <mpinit+0x1aa>
801038e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038ee:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801038f0:	89 f3                	mov    %esi,%ebx
801038f2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801038f8:	74 d6                	je     801038d0 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801038fa:	83 ec 04             	sub    $0x4,%esp
801038fd:	8d 73 10             	lea    0x10(%ebx),%esi
80103900:	6a 04                	push   $0x4
80103902:	68 b8 83 10 80       	push   $0x801083b8
80103907:	53                   	push   %ebx
80103908:	e8 13 16 00 00       	call   80104f20 <memcmp>
8010390d:	83 c4 10             	add    $0x10,%esp
80103910:	85 c0                	test   %eax,%eax
80103912:	75 dc                	jne    801038f0 <mpinit+0x1a0>
80103914:	89 da                	mov    %ebx,%edx
80103916:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010391d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103920:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103923:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103926:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103928:	39 d6                	cmp    %edx,%esi
8010392a:	75 f4                	jne    80103920 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010392c:	84 c0                	test   %al,%al
8010392e:	75 c0                	jne    801038f0 <mpinit+0x1a0>
80103930:	e9 6b fe ff ff       	jmp    801037a0 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103935:	83 ec 0c             	sub    $0xc,%esp
80103938:	68 dc 83 10 80       	push   $0x801083dc
8010393d:	e8 3e ca ff ff       	call   80100380 <panic>
80103942:	66 90                	xchg   %ax,%ax
80103944:	66 90                	xchg   %ax,%ax
80103946:	66 90                	xchg   %ax,%ax
80103948:	66 90                	xchg   %ax,%ax
8010394a:	66 90                	xchg   %ax,%ax
8010394c:	66 90                	xchg   %ax,%ax
8010394e:	66 90                	xchg   %ax,%ax

80103950 <picinit>:
80103950:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103955:	ba 21 00 00 00       	mov    $0x21,%edx
8010395a:	ee                   	out    %al,(%dx)
8010395b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103960:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103961:	c3                   	ret    
80103962:	66 90                	xchg   %ax,%ax
80103964:	66 90                	xchg   %ax,%ax
80103966:	66 90                	xchg   %ax,%ax
80103968:	66 90                	xchg   %ax,%ax
8010396a:	66 90                	xchg   %ax,%ax
8010396c:	66 90                	xchg   %ax,%ax
8010396e:	66 90                	xchg   %ax,%ax

80103970 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103970:	55                   	push   %ebp
80103971:	89 e5                	mov    %esp,%ebp
80103973:	57                   	push   %edi
80103974:	56                   	push   %esi
80103975:	53                   	push   %ebx
80103976:	83 ec 0c             	sub    $0xc,%esp
80103979:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010397c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010397f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103985:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010398b:	e8 b0 d4 ff ff       	call   80100e40 <filealloc>
80103990:	89 03                	mov    %eax,(%ebx)
80103992:	85 c0                	test   %eax,%eax
80103994:	0f 84 a8 00 00 00    	je     80103a42 <pipealloc+0xd2>
8010399a:	e8 a1 d4 ff ff       	call   80100e40 <filealloc>
8010399f:	89 06                	mov    %eax,(%esi)
801039a1:	85 c0                	test   %eax,%eax
801039a3:	0f 84 87 00 00 00    	je     80103a30 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801039a9:	e8 52 f1 ff ff       	call   80102b00 <kalloc>
801039ae:	89 c7                	mov    %eax,%edi
801039b0:	85 c0                	test   %eax,%eax
801039b2:	0f 84 b0 00 00 00    	je     80103a68 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
801039b8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801039bf:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801039c2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801039c5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801039cc:	00 00 00 
  p->nwrite = 0;
801039cf:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801039d6:	00 00 00 
  p->nread = 0;
801039d9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801039e0:	00 00 00 
  initlock(&p->lock, "pipe");
801039e3:	68 fb 83 10 80       	push   $0x801083fb
801039e8:	50                   	push   %eax
801039e9:	e8 52 12 00 00       	call   80104c40 <initlock>
  (*f0)->type = FD_PIPE;
801039ee:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801039f0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801039f3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801039f9:	8b 03                	mov    (%ebx),%eax
801039fb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801039ff:	8b 03                	mov    (%ebx),%eax
80103a01:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103a05:	8b 03                	mov    (%ebx),%eax
80103a07:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103a0a:	8b 06                	mov    (%esi),%eax
80103a0c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103a12:	8b 06                	mov    (%esi),%eax
80103a14:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103a18:	8b 06                	mov    (%esi),%eax
80103a1a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103a1e:	8b 06                	mov    (%esi),%eax
80103a20:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103a23:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103a26:	31 c0                	xor    %eax,%eax
}
80103a28:	5b                   	pop    %ebx
80103a29:	5e                   	pop    %esi
80103a2a:	5f                   	pop    %edi
80103a2b:	5d                   	pop    %ebp
80103a2c:	c3                   	ret    
80103a2d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103a30:	8b 03                	mov    (%ebx),%eax
80103a32:	85 c0                	test   %eax,%eax
80103a34:	74 1e                	je     80103a54 <pipealloc+0xe4>
    fileclose(*f0);
80103a36:	83 ec 0c             	sub    $0xc,%esp
80103a39:	50                   	push   %eax
80103a3a:	e8 c1 d4 ff ff       	call   80100f00 <fileclose>
80103a3f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103a42:	8b 06                	mov    (%esi),%eax
80103a44:	85 c0                	test   %eax,%eax
80103a46:	74 0c                	je     80103a54 <pipealloc+0xe4>
    fileclose(*f1);
80103a48:	83 ec 0c             	sub    $0xc,%esp
80103a4b:	50                   	push   %eax
80103a4c:	e8 af d4 ff ff       	call   80100f00 <fileclose>
80103a51:	83 c4 10             	add    $0x10,%esp
}
80103a54:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103a57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103a5c:	5b                   	pop    %ebx
80103a5d:	5e                   	pop    %esi
80103a5e:	5f                   	pop    %edi
80103a5f:	5d                   	pop    %ebp
80103a60:	c3                   	ret    
80103a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103a68:	8b 03                	mov    (%ebx),%eax
80103a6a:	85 c0                	test   %eax,%eax
80103a6c:	75 c8                	jne    80103a36 <pipealloc+0xc6>
80103a6e:	eb d2                	jmp    80103a42 <pipealloc+0xd2>

80103a70 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103a70:	55                   	push   %ebp
80103a71:	89 e5                	mov    %esp,%ebp
80103a73:	56                   	push   %esi
80103a74:	53                   	push   %ebx
80103a75:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103a78:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103a7b:	83 ec 0c             	sub    $0xc,%esp
80103a7e:	53                   	push   %ebx
80103a7f:	e8 8c 13 00 00       	call   80104e10 <acquire>
  if(writable){
80103a84:	83 c4 10             	add    $0x10,%esp
80103a87:	85 f6                	test   %esi,%esi
80103a89:	74 65                	je     80103af0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
80103a8b:	83 ec 0c             	sub    $0xc,%esp
80103a8e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103a94:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103a9b:	00 00 00 
    wakeup(&p->nread);
80103a9e:	50                   	push   %eax
80103a9f:	e8 bc 09 00 00       	call   80104460 <wakeup>
80103aa4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103aa7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103aad:	85 d2                	test   %edx,%edx
80103aaf:	75 0a                	jne    80103abb <pipeclose+0x4b>
80103ab1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103ab7:	85 c0                	test   %eax,%eax
80103ab9:	74 15                	je     80103ad0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103abb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103abe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ac1:	5b                   	pop    %ebx
80103ac2:	5e                   	pop    %esi
80103ac3:	5d                   	pop    %ebp
    release(&p->lock);
80103ac4:	e9 e7 12 00 00       	jmp    80104db0 <release>
80103ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103ad0:	83 ec 0c             	sub    $0xc,%esp
80103ad3:	53                   	push   %ebx
80103ad4:	e8 d7 12 00 00       	call   80104db0 <release>
    kfree((char*)p);
80103ad9:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103adc:	83 c4 10             	add    $0x10,%esp
}
80103adf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ae2:	5b                   	pop    %ebx
80103ae3:	5e                   	pop    %esi
80103ae4:	5d                   	pop    %ebp
    kfree((char*)p);
80103ae5:	e9 66 ed ff ff       	jmp    80102850 <kfree>
80103aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103af0:	83 ec 0c             	sub    $0xc,%esp
80103af3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103af9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103b00:	00 00 00 
    wakeup(&p->nwrite);
80103b03:	50                   	push   %eax
80103b04:	e8 57 09 00 00       	call   80104460 <wakeup>
80103b09:	83 c4 10             	add    $0x10,%esp
80103b0c:	eb 99                	jmp    80103aa7 <pipeclose+0x37>
80103b0e:	66 90                	xchg   %ax,%ax

80103b10 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	57                   	push   %edi
80103b14:	56                   	push   %esi
80103b15:	53                   	push   %ebx
80103b16:	83 ec 28             	sub    $0x28,%esp
80103b19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103b1c:	53                   	push   %ebx
80103b1d:	e8 ee 12 00 00       	call   80104e10 <acquire>
  for(i = 0; i < n; i++){
80103b22:	8b 45 10             	mov    0x10(%ebp),%eax
80103b25:	83 c4 10             	add    $0x10,%esp
80103b28:	85 c0                	test   %eax,%eax
80103b2a:	0f 8e c0 00 00 00    	jle    80103bf0 <pipewrite+0xe0>
80103b30:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103b33:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103b39:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103b3f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b42:	03 45 10             	add    0x10(%ebp),%eax
80103b45:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103b48:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103b4e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103b54:	89 ca                	mov    %ecx,%edx
80103b56:	05 00 02 00 00       	add    $0x200,%eax
80103b5b:	39 c1                	cmp    %eax,%ecx
80103b5d:	74 3f                	je     80103b9e <pipewrite+0x8e>
80103b5f:	eb 67                	jmp    80103bc8 <pipewrite+0xb8>
80103b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103b68:	e8 43 03 00 00       	call   80103eb0 <myproc>
80103b6d:	8b 48 28             	mov    0x28(%eax),%ecx
80103b70:	85 c9                	test   %ecx,%ecx
80103b72:	75 34                	jne    80103ba8 <pipewrite+0x98>
      wakeup(&p->nread);
80103b74:	83 ec 0c             	sub    $0xc,%esp
80103b77:	57                   	push   %edi
80103b78:	e8 e3 08 00 00       	call   80104460 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103b7d:	58                   	pop    %eax
80103b7e:	5a                   	pop    %edx
80103b7f:	53                   	push   %ebx
80103b80:	56                   	push   %esi
80103b81:	e8 1a 08 00 00       	call   801043a0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103b86:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103b8c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103b92:	83 c4 10             	add    $0x10,%esp
80103b95:	05 00 02 00 00       	add    $0x200,%eax
80103b9a:	39 c2                	cmp    %eax,%edx
80103b9c:	75 2a                	jne    80103bc8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80103b9e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103ba4:	85 c0                	test   %eax,%eax
80103ba6:	75 c0                	jne    80103b68 <pipewrite+0x58>
        release(&p->lock);
80103ba8:	83 ec 0c             	sub    $0xc,%esp
80103bab:	53                   	push   %ebx
80103bac:	e8 ff 11 00 00       	call   80104db0 <release>
        return -1;
80103bb1:	83 c4 10             	add    $0x10,%esp
80103bb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103bb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103bbc:	5b                   	pop    %ebx
80103bbd:	5e                   	pop    %esi
80103bbe:	5f                   	pop    %edi
80103bbf:	5d                   	pop    %ebp
80103bc0:	c3                   	ret    
80103bc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103bc8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103bcb:	8d 4a 01             	lea    0x1(%edx),%ecx
80103bce:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103bd4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80103bda:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
80103bdd:	83 c6 01             	add    $0x1,%esi
80103be0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103be3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103be7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103bea:	0f 85 58 ff ff ff    	jne    80103b48 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103bf0:	83 ec 0c             	sub    $0xc,%esp
80103bf3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103bf9:	50                   	push   %eax
80103bfa:	e8 61 08 00 00       	call   80104460 <wakeup>
  release(&p->lock);
80103bff:	89 1c 24             	mov    %ebx,(%esp)
80103c02:	e8 a9 11 00 00       	call   80104db0 <release>
  return n;
80103c07:	8b 45 10             	mov    0x10(%ebp),%eax
80103c0a:	83 c4 10             	add    $0x10,%esp
80103c0d:	eb aa                	jmp    80103bb9 <pipewrite+0xa9>
80103c0f:	90                   	nop

80103c10 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103c10:	55                   	push   %ebp
80103c11:	89 e5                	mov    %esp,%ebp
80103c13:	57                   	push   %edi
80103c14:	56                   	push   %esi
80103c15:	53                   	push   %ebx
80103c16:	83 ec 18             	sub    $0x18,%esp
80103c19:	8b 75 08             	mov    0x8(%ebp),%esi
80103c1c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103c1f:	56                   	push   %esi
80103c20:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103c26:	e8 e5 11 00 00       	call   80104e10 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103c2b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103c31:	83 c4 10             	add    $0x10,%esp
80103c34:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103c3a:	74 2f                	je     80103c6b <piperead+0x5b>
80103c3c:	eb 37                	jmp    80103c75 <piperead+0x65>
80103c3e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103c40:	e8 6b 02 00 00       	call   80103eb0 <myproc>
80103c45:	8b 48 28             	mov    0x28(%eax),%ecx
80103c48:	85 c9                	test   %ecx,%ecx
80103c4a:	0f 85 80 00 00 00    	jne    80103cd0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103c50:	83 ec 08             	sub    $0x8,%esp
80103c53:	56                   	push   %esi
80103c54:	53                   	push   %ebx
80103c55:	e8 46 07 00 00       	call   801043a0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103c5a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103c60:	83 c4 10             	add    $0x10,%esp
80103c63:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103c69:	75 0a                	jne    80103c75 <piperead+0x65>
80103c6b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103c71:	85 c0                	test   %eax,%eax
80103c73:	75 cb                	jne    80103c40 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103c75:	8b 55 10             	mov    0x10(%ebp),%edx
80103c78:	31 db                	xor    %ebx,%ebx
80103c7a:	85 d2                	test   %edx,%edx
80103c7c:	7f 20                	jg     80103c9e <piperead+0x8e>
80103c7e:	eb 2c                	jmp    80103cac <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103c80:	8d 48 01             	lea    0x1(%eax),%ecx
80103c83:	25 ff 01 00 00       	and    $0x1ff,%eax
80103c88:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103c8e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103c93:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103c96:	83 c3 01             	add    $0x1,%ebx
80103c99:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103c9c:	74 0e                	je     80103cac <piperead+0x9c>
    if(p->nread == p->nwrite)
80103c9e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103ca4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103caa:	75 d4                	jne    80103c80 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103cac:	83 ec 0c             	sub    $0xc,%esp
80103caf:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103cb5:	50                   	push   %eax
80103cb6:	e8 a5 07 00 00       	call   80104460 <wakeup>
  release(&p->lock);
80103cbb:	89 34 24             	mov    %esi,(%esp)
80103cbe:	e8 ed 10 00 00       	call   80104db0 <release>
  return i;
80103cc3:	83 c4 10             	add    $0x10,%esp
}
80103cc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cc9:	89 d8                	mov    %ebx,%eax
80103ccb:	5b                   	pop    %ebx
80103ccc:	5e                   	pop    %esi
80103ccd:	5f                   	pop    %edi
80103cce:	5d                   	pop    %ebp
80103ccf:	c3                   	ret    
      release(&p->lock);
80103cd0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103cd3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103cd8:	56                   	push   %esi
80103cd9:	e8 d2 10 00 00       	call   80104db0 <release>
      return -1;
80103cde:	83 c4 10             	add    $0x10,%esp
}
80103ce1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ce4:	89 d8                	mov    %ebx,%eax
80103ce6:	5b                   	pop    %ebx
80103ce7:	5e                   	pop    %esi
80103ce8:	5f                   	pop    %edi
80103ce9:	5d                   	pop    %ebp
80103cea:	c3                   	ret    
80103ceb:	66 90                	xchg   %ax,%ax
80103ced:	66 90                	xchg   %ax,%ax
80103cef:	90                   	nop

80103cf0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103cf0:	55                   	push   %ebp
80103cf1:	89 e5                	mov    %esp,%ebp
80103cf3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cf4:	bb 94 6d 11 80       	mov    $0x80116d94,%ebx
{
80103cf9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103cfc:	68 60 6d 11 80       	push   $0x80116d60
80103d01:	e8 0a 11 00 00       	call   80104e10 <acquire>
80103d06:	83 c4 10             	add    $0x10,%esp
80103d09:	eb 10                	jmp    80103d1b <allocproc+0x2b>
80103d0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d0f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d10:	83 eb 80             	sub    $0xffffff80,%ebx
80103d13:	81 fb 94 8d 11 80    	cmp    $0x80118d94,%ebx
80103d19:	74 75                	je     80103d90 <allocproc+0xa0>
    if(p->state == UNUSED)
80103d1b:	8b 43 10             	mov    0x10(%ebx),%eax
80103d1e:	85 c0                	test   %eax,%eax
80103d20:	75 ee                	jne    80103d10 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103d22:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103d27:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103d2a:	c7 43 10 01 00 00 00 	movl   $0x1,0x10(%ebx)
  p->pid = nextpid++;
80103d31:	89 43 14             	mov    %eax,0x14(%ebx)
80103d34:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103d37:	68 60 6d 11 80       	push   $0x80116d60
  p->pid = nextpid++;
80103d3c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103d42:	e8 69 10 00 00       	call   80104db0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103d47:	e8 b4 ed ff ff       	call   80102b00 <kalloc>
80103d4c:	83 c4 10             	add    $0x10,%esp
80103d4f:	89 43 0c             	mov    %eax,0xc(%ebx)
80103d52:	85 c0                	test   %eax,%eax
80103d54:	74 53                	je     80103da9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103d56:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103d5c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103d5f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103d64:	89 53 1c             	mov    %edx,0x1c(%ebx)
  *(uint*)sp = (uint)trapret;
80103d67:	c7 40 14 e2 60 10 80 	movl   $0x801060e2,0x14(%eax)
  p->context = (struct context*)sp;
80103d6e:	89 43 20             	mov    %eax,0x20(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103d71:	6a 14                	push   $0x14
80103d73:	6a 00                	push   $0x0
80103d75:	50                   	push   %eax
80103d76:	e8 55 11 00 00       	call   80104ed0 <memset>
  p->context->eip = (uint)forkret;
80103d7b:	8b 43 20             	mov    0x20(%ebx),%eax

  return p;
80103d7e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103d81:	c7 40 10 c0 3d 10 80 	movl   $0x80103dc0,0x10(%eax)
}
80103d88:	89 d8                	mov    %ebx,%eax
80103d8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d8d:	c9                   	leave  
80103d8e:	c3                   	ret    
80103d8f:	90                   	nop
  release(&ptable.lock);
80103d90:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103d93:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103d95:	68 60 6d 11 80       	push   $0x80116d60
80103d9a:	e8 11 10 00 00       	call   80104db0 <release>
}
80103d9f:	89 d8                	mov    %ebx,%eax
  return 0;
80103da1:	83 c4 10             	add    $0x10,%esp
}
80103da4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103da7:	c9                   	leave  
80103da8:	c3                   	ret    
    p->state = UNUSED;
80103da9:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return 0;
80103db0:	31 db                	xor    %ebx,%ebx
}
80103db2:	89 d8                	mov    %ebx,%eax
80103db4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103db7:	c9                   	leave  
80103db8:	c3                   	ret    
80103db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103dc0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103dc0:	55                   	push   %ebp
80103dc1:	89 e5                	mov    %esp,%ebp
80103dc3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103dc6:	68 60 6d 11 80       	push   $0x80116d60
80103dcb:	e8 e0 0f 00 00       	call   80104db0 <release>

  if (first) {
80103dd0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103dd5:	83 c4 10             	add    $0x10,%esp
80103dd8:	85 c0                	test   %eax,%eax
80103dda:	75 04                	jne    80103de0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103ddc:	c9                   	leave  
80103ddd:	c3                   	ret    
80103dde:	66 90                	xchg   %ax,%ax
    first = 0;
80103de0:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103de7:	00 00 00 
    iinit(ROOTDEV);
80103dea:	83 ec 0c             	sub    $0xc,%esp
80103ded:	6a 01                	push   $0x1
80103def:	e8 7c d7 ff ff       	call   80101570 <iinit>
    initlog(ROOTDEV);
80103df4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103dfb:	e8 00 f4 ff ff       	call   80103200 <initlog>
}
80103e00:	83 c4 10             	add    $0x10,%esp
80103e03:	c9                   	leave  
80103e04:	c3                   	ret    
80103e05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103e10 <pinit>:
{
80103e10:	55                   	push   %ebp
80103e11:	89 e5                	mov    %esp,%ebp
80103e13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103e16:	68 00 84 10 80       	push   $0x80108400
80103e1b:	68 60 6d 11 80       	push   $0x80116d60
80103e20:	e8 1b 0e 00 00       	call   80104c40 <initlock>
}
80103e25:	83 c4 10             	add    $0x10,%esp
80103e28:	c9                   	leave  
80103e29:	c3                   	ret    
80103e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e30 <mycpu>:
{
80103e30:	55                   	push   %ebp
80103e31:	89 e5                	mov    %esp,%ebp
80103e33:	56                   	push   %esi
80103e34:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e35:	9c                   	pushf  
80103e36:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103e37:	f6 c4 02             	test   $0x2,%ah
80103e3a:	75 46                	jne    80103e82 <mycpu+0x52>
  apicid = lapicid();
80103e3c:	e8 ef ef ff ff       	call   80102e30 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103e41:	8b 35 c4 67 11 80    	mov    0x801167c4,%esi
80103e47:	85 f6                	test   %esi,%esi
80103e49:	7e 2a                	jle    80103e75 <mycpu+0x45>
80103e4b:	31 d2                	xor    %edx,%edx
80103e4d:	eb 08                	jmp    80103e57 <mycpu+0x27>
80103e4f:	90                   	nop
80103e50:	83 c2 01             	add    $0x1,%edx
80103e53:	39 f2                	cmp    %esi,%edx
80103e55:	74 1e                	je     80103e75 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103e57:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103e5d:	0f b6 99 e0 67 11 80 	movzbl -0x7fee9820(%ecx),%ebx
80103e64:	39 c3                	cmp    %eax,%ebx
80103e66:	75 e8                	jne    80103e50 <mycpu+0x20>
}
80103e68:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103e6b:	8d 81 e0 67 11 80    	lea    -0x7fee9820(%ecx),%eax
}
80103e71:	5b                   	pop    %ebx
80103e72:	5e                   	pop    %esi
80103e73:	5d                   	pop    %ebp
80103e74:	c3                   	ret    
  panic("unknown apicid\n");
80103e75:	83 ec 0c             	sub    $0xc,%esp
80103e78:	68 07 84 10 80       	push   $0x80108407
80103e7d:	e8 fe c4 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103e82:	83 ec 0c             	sub    $0xc,%esp
80103e85:	68 3c 85 10 80       	push   $0x8010853c
80103e8a:	e8 f1 c4 ff ff       	call   80100380 <panic>
80103e8f:	90                   	nop

80103e90 <cpuid>:
cpuid() {
80103e90:	55                   	push   %ebp
80103e91:	89 e5                	mov    %esp,%ebp
80103e93:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103e96:	e8 95 ff ff ff       	call   80103e30 <mycpu>
}
80103e9b:	c9                   	leave  
  return mycpu()-cpus;
80103e9c:	2d e0 67 11 80       	sub    $0x801167e0,%eax
80103ea1:	c1 f8 04             	sar    $0x4,%eax
80103ea4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103eaa:	c3                   	ret    
80103eab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103eaf:	90                   	nop

80103eb0 <myproc>:
myproc(void) {
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	53                   	push   %ebx
80103eb4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103eb7:	e8 04 0e 00 00       	call   80104cc0 <pushcli>
  c = mycpu();
80103ebc:	e8 6f ff ff ff       	call   80103e30 <mycpu>
  p = c->proc;
80103ec1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ec7:	e8 44 0e 00 00       	call   80104d10 <popcli>
}
80103ecc:	89 d8                	mov    %ebx,%eax
80103ece:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ed1:	c9                   	leave  
80103ed2:	c3                   	ret    
80103ed3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ee0 <userinit>:
{
80103ee0:	55                   	push   %ebp
80103ee1:	89 e5                	mov    %esp,%ebp
80103ee3:	53                   	push   %ebx
80103ee4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103ee7:	e8 04 fe ff ff       	call   80103cf0 <allocproc>
80103eec:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103eee:	a3 94 8d 11 80       	mov    %eax,0x80118d94
  if((p->pgdir = setupkvm()) == 0)
80103ef3:	e8 98 38 00 00       	call   80107790 <setupkvm>
80103ef8:	89 43 08             	mov    %eax,0x8(%ebx)
80103efb:	85 c0                	test   %eax,%eax
80103efd:	0f 84 bd 00 00 00    	je     80103fc0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103f03:	83 ec 04             	sub    $0x4,%esp
80103f06:	68 2c 00 00 00       	push   $0x2c
80103f0b:	68 60 b4 10 80       	push   $0x8010b460
80103f10:	50                   	push   %eax
80103f11:	e8 6a 34 00 00       	call   80107380 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103f16:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103f19:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103f1f:	6a 4c                	push   $0x4c
80103f21:	6a 00                	push   $0x0
80103f23:	ff 73 1c             	push   0x1c(%ebx)
80103f26:	e8 a5 0f 00 00       	call   80104ed0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103f2b:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103f2e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103f33:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103f36:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103f3b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103f3f:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103f42:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103f46:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103f49:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103f4d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103f51:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103f54:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103f58:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103f5c:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103f5f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103f66:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103f69:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103f70:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103f73:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103f7a:	8d 43 70             	lea    0x70(%ebx),%eax
80103f7d:	6a 10                	push   $0x10
80103f7f:	68 30 84 10 80       	push   $0x80108430
80103f84:	50                   	push   %eax
80103f85:	e8 06 11 00 00       	call   80105090 <safestrcpy>
  p->cwd = namei("/");
80103f8a:	c7 04 24 39 84 10 80 	movl   $0x80108439,(%esp)
80103f91:	e8 2a e1 ff ff       	call   801020c0 <namei>
80103f96:	89 43 6c             	mov    %eax,0x6c(%ebx)
  acquire(&ptable.lock);
80103f99:	c7 04 24 60 6d 11 80 	movl   $0x80116d60,(%esp)
80103fa0:	e8 6b 0e 00 00       	call   80104e10 <acquire>
  p->state = RUNNABLE;
80103fa5:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  release(&ptable.lock);
80103fac:	c7 04 24 60 6d 11 80 	movl   $0x80116d60,(%esp)
80103fb3:	e8 f8 0d 00 00       	call   80104db0 <release>
}
80103fb8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fbb:	83 c4 10             	add    $0x10,%esp
80103fbe:	c9                   	leave  
80103fbf:	c3                   	ret    
    panic("userinit: out of memory?");
80103fc0:	83 ec 0c             	sub    $0xc,%esp
80103fc3:	68 17 84 10 80       	push   $0x80108417
80103fc8:	e8 b3 c3 ff ff       	call   80100380 <panic>
80103fcd:	8d 76 00             	lea    0x0(%esi),%esi

80103fd0 <growproc>:
{
80103fd0:	55                   	push   %ebp
80103fd1:	89 e5                	mov    %esp,%ebp
80103fd3:	56                   	push   %esi
80103fd4:	53                   	push   %ebx
80103fd5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103fd8:	e8 e3 0c 00 00       	call   80104cc0 <pushcli>
  c = mycpu();
80103fdd:	e8 4e fe ff ff       	call   80103e30 <mycpu>
  p = c->proc;
80103fe2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fe8:	e8 23 0d 00 00       	call   80104d10 <popcli>
  sz = curproc->sz;
80103fed:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103fef:	85 f6                	test   %esi,%esi
80103ff1:	7f 1d                	jg     80104010 <growproc+0x40>
  } else if(n < 0){
80103ff3:	75 3b                	jne    80104030 <growproc+0x60>
  switchuvm(curproc);
80103ff5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103ff8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103ffa:	53                   	push   %ebx
80103ffb:	e8 70 32 00 00       	call   80107270 <switchuvm>
  return 0;
80104000:	83 c4 10             	add    $0x10,%esp
80104003:	31 c0                	xor    %eax,%eax
}
80104005:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104008:	5b                   	pop    %ebx
80104009:	5e                   	pop    %esi
8010400a:	5d                   	pop    %ebp
8010400b:	c3                   	ret    
8010400c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104010:	83 ec 04             	sub    $0x4,%esp
80104013:	01 c6                	add    %eax,%esi
80104015:	56                   	push   %esi
80104016:	50                   	push   %eax
80104017:	ff 73 08             	push   0x8(%ebx)
8010401a:	e8 b1 35 00 00       	call   801075d0 <allocuvm>
8010401f:	83 c4 10             	add    $0x10,%esp
80104022:	85 c0                	test   %eax,%eax
80104024:	75 cf                	jne    80103ff5 <growproc+0x25>
      return -1;
80104026:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010402b:	eb d8                	jmp    80104005 <growproc+0x35>
8010402d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104030:	83 ec 04             	sub    $0x4,%esp
80104033:	01 c6                	add    %eax,%esi
80104035:	56                   	push   %esi
80104036:	50                   	push   %eax
80104037:	ff 73 08             	push   0x8(%ebx)
8010403a:	e8 b1 34 00 00       	call   801074f0 <deallocuvm>
8010403f:	83 c4 10             	add    $0x10,%esp
80104042:	85 c0                	test   %eax,%eax
80104044:	75 af                	jne    80103ff5 <growproc+0x25>
80104046:	eb de                	jmp    80104026 <growproc+0x56>
80104048:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010404f:	90                   	nop

80104050 <print_rss>:
{
80104050:	55                   	push   %ebp
80104051:	89 e5                	mov    %esp,%ebp
80104053:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104054:	bb 94 6d 11 80       	mov    $0x80116d94,%ebx
{
80104059:	83 ec 10             	sub    $0x10,%esp
  cprintf("PrintingRSS\n");
8010405c:	68 3b 84 10 80       	push   $0x8010843b
80104061:	e8 3a c6 ff ff       	call   801006a0 <cprintf>
  acquire(&ptable.lock);
80104066:	c7 04 24 60 6d 11 80 	movl   $0x80116d60,(%esp)
8010406d:	e8 9e 0d 00 00       	call   80104e10 <acquire>
80104072:	83 c4 10             	add    $0x10,%esp
80104075:	8d 76 00             	lea    0x0(%esi),%esi
    if((p->state == UNUSED))
80104078:	8b 43 10             	mov    0x10(%ebx),%eax
8010407b:	85 c0                	test   %eax,%eax
8010407d:	74 14                	je     80104093 <print_rss+0x43>
    cprintf("((P)) id: %d, state: %d, rss: %d\n",p->pid,p->state,p->rss);
8010407f:	ff 73 04             	push   0x4(%ebx)
80104082:	50                   	push   %eax
80104083:	ff 73 14             	push   0x14(%ebx)
80104086:	68 64 85 10 80       	push   $0x80108564
8010408b:	e8 10 c6 ff ff       	call   801006a0 <cprintf>
80104090:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104093:	83 eb 80             	sub    $0xffffff80,%ebx
80104096:	81 fb 94 8d 11 80    	cmp    $0x80118d94,%ebx
8010409c:	75 da                	jne    80104078 <print_rss+0x28>
  release(&ptable.lock);
8010409e:	83 ec 0c             	sub    $0xc,%esp
801040a1:	68 60 6d 11 80       	push   $0x80116d60
801040a6:	e8 05 0d 00 00       	call   80104db0 <release>
}
801040ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040ae:	83 c4 10             	add    $0x10,%esp
801040b1:	c9                   	leave  
801040b2:	c3                   	ret    
801040b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801040c0 <scheduler>:
{
801040c0:	55                   	push   %ebp
801040c1:	89 e5                	mov    %esp,%ebp
801040c3:	57                   	push   %edi
801040c4:	56                   	push   %esi
801040c5:	53                   	push   %ebx
801040c6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
801040c9:	e8 62 fd ff ff       	call   80103e30 <mycpu>
  c->proc = 0;
801040ce:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801040d5:	00 00 00 
  struct cpu *c = mycpu();
801040d8:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801040da:	8d 78 04             	lea    0x4(%eax),%edi
801040dd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
801040e0:	fb                   	sti    
    acquire(&ptable.lock);
801040e1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040e4:	bb 94 6d 11 80       	mov    $0x80116d94,%ebx
    acquire(&ptable.lock);
801040e9:	68 60 6d 11 80       	push   $0x80116d60
801040ee:	e8 1d 0d 00 00       	call   80104e10 <acquire>
801040f3:	83 c4 10             	add    $0x10,%esp
801040f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040fd:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80104100:	83 7b 10 03          	cmpl   $0x3,0x10(%ebx)
80104104:	75 33                	jne    80104139 <scheduler+0x79>
      switchuvm(p);
80104106:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104109:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010410f:	53                   	push   %ebx
80104110:	e8 5b 31 00 00       	call   80107270 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104115:	58                   	pop    %eax
80104116:	5a                   	pop    %edx
80104117:	ff 73 20             	push   0x20(%ebx)
8010411a:	57                   	push   %edi
      p->state = RUNNING;
8010411b:	c7 43 10 04 00 00 00 	movl   $0x4,0x10(%ebx)
      swtch(&(c->scheduler), p->context);
80104122:	e8 c4 0f 00 00       	call   801050eb <swtch>
      switchkvm();
80104127:	e8 34 31 00 00       	call   80107260 <switchkvm>
      c->proc = 0;
8010412c:	83 c4 10             	add    $0x10,%esp
8010412f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104136:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104139:	83 eb 80             	sub    $0xffffff80,%ebx
8010413c:	81 fb 94 8d 11 80    	cmp    $0x80118d94,%ebx
80104142:	75 bc                	jne    80104100 <scheduler+0x40>
    release(&ptable.lock);
80104144:	83 ec 0c             	sub    $0xc,%esp
80104147:	68 60 6d 11 80       	push   $0x80116d60
8010414c:	e8 5f 0c 00 00       	call   80104db0 <release>
    sti();
80104151:	83 c4 10             	add    $0x10,%esp
80104154:	eb 8a                	jmp    801040e0 <scheduler+0x20>
80104156:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010415d:	8d 76 00             	lea    0x0(%esi),%esi

80104160 <sched>:
{
80104160:	55                   	push   %ebp
80104161:	89 e5                	mov    %esp,%ebp
80104163:	56                   	push   %esi
80104164:	53                   	push   %ebx
  pushcli();
80104165:	e8 56 0b 00 00       	call   80104cc0 <pushcli>
  c = mycpu();
8010416a:	e8 c1 fc ff ff       	call   80103e30 <mycpu>
  p = c->proc;
8010416f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104175:	e8 96 0b 00 00       	call   80104d10 <popcli>
  if(!holding(&ptable.lock))
8010417a:	83 ec 0c             	sub    $0xc,%esp
8010417d:	68 60 6d 11 80       	push   $0x80116d60
80104182:	e8 e9 0b 00 00       	call   80104d70 <holding>
80104187:	83 c4 10             	add    $0x10,%esp
8010418a:	85 c0                	test   %eax,%eax
8010418c:	74 4f                	je     801041dd <sched+0x7d>
  if(mycpu()->ncli != 1)
8010418e:	e8 9d fc ff ff       	call   80103e30 <mycpu>
80104193:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010419a:	75 68                	jne    80104204 <sched+0xa4>
  if(p->state == RUNNING)
8010419c:	83 7b 10 04          	cmpl   $0x4,0x10(%ebx)
801041a0:	74 55                	je     801041f7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801041a2:	9c                   	pushf  
801041a3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801041a4:	f6 c4 02             	test   $0x2,%ah
801041a7:	75 41                	jne    801041ea <sched+0x8a>
  intena = mycpu()->intena;
801041a9:	e8 82 fc ff ff       	call   80103e30 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801041ae:	83 c3 20             	add    $0x20,%ebx
  intena = mycpu()->intena;
801041b1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801041b7:	e8 74 fc ff ff       	call   80103e30 <mycpu>
801041bc:	83 ec 08             	sub    $0x8,%esp
801041bf:	ff 70 04             	push   0x4(%eax)
801041c2:	53                   	push   %ebx
801041c3:	e8 23 0f 00 00       	call   801050eb <swtch>
  mycpu()->intena = intena;
801041c8:	e8 63 fc ff ff       	call   80103e30 <mycpu>
}
801041cd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801041d0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801041d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041d9:	5b                   	pop    %ebx
801041da:	5e                   	pop    %esi
801041db:	5d                   	pop    %ebp
801041dc:	c3                   	ret    
    panic("sched ptable.lock");
801041dd:	83 ec 0c             	sub    $0xc,%esp
801041e0:	68 48 84 10 80       	push   $0x80108448
801041e5:	e8 96 c1 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
801041ea:	83 ec 0c             	sub    $0xc,%esp
801041ed:	68 74 84 10 80       	push   $0x80108474
801041f2:	e8 89 c1 ff ff       	call   80100380 <panic>
    panic("sched running");
801041f7:	83 ec 0c             	sub    $0xc,%esp
801041fa:	68 66 84 10 80       	push   $0x80108466
801041ff:	e8 7c c1 ff ff       	call   80100380 <panic>
    panic("sched locks");
80104204:	83 ec 0c             	sub    $0xc,%esp
80104207:	68 5a 84 10 80       	push   $0x8010845a
8010420c:	e8 6f c1 ff ff       	call   80100380 <panic>
80104211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104218:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010421f:	90                   	nop

80104220 <wait>:
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	56                   	push   %esi
80104224:	53                   	push   %ebx
  pushcli();
80104225:	e8 96 0a 00 00       	call   80104cc0 <pushcli>
  c = mycpu();
8010422a:	e8 01 fc ff ff       	call   80103e30 <mycpu>
  p = c->proc;
8010422f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104235:	e8 d6 0a 00 00       	call   80104d10 <popcli>
  acquire(&ptable.lock);
8010423a:	83 ec 0c             	sub    $0xc,%esp
8010423d:	68 60 6d 11 80       	push   $0x80116d60
80104242:	e8 c9 0b 00 00       	call   80104e10 <acquire>
80104247:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010424a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010424c:	bb 94 6d 11 80       	mov    $0x80116d94,%ebx
80104251:	eb 10                	jmp    80104263 <wait+0x43>
80104253:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104257:	90                   	nop
80104258:	83 eb 80             	sub    $0xffffff80,%ebx
8010425b:	81 fb 94 8d 11 80    	cmp    $0x80118d94,%ebx
80104261:	74 1b                	je     8010427e <wait+0x5e>
      if(p->parent != curproc)
80104263:	39 73 18             	cmp    %esi,0x18(%ebx)
80104266:	75 f0                	jne    80104258 <wait+0x38>
      if(p->state == ZOMBIE){
80104268:	83 7b 10 05          	cmpl   $0x5,0x10(%ebx)
8010426c:	74 62                	je     801042d0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010426e:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80104271:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104276:	81 fb 94 8d 11 80    	cmp    $0x80118d94,%ebx
8010427c:	75 e5                	jne    80104263 <wait+0x43>
    if(!havekids || curproc->killed){
8010427e:	85 c0                	test   %eax,%eax
80104280:	0f 84 a0 00 00 00    	je     80104326 <wait+0x106>
80104286:	8b 46 28             	mov    0x28(%esi),%eax
80104289:	85 c0                	test   %eax,%eax
8010428b:	0f 85 95 00 00 00    	jne    80104326 <wait+0x106>
  pushcli();
80104291:	e8 2a 0a 00 00       	call   80104cc0 <pushcli>
  c = mycpu();
80104296:	e8 95 fb ff ff       	call   80103e30 <mycpu>
  p = c->proc;
8010429b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042a1:	e8 6a 0a 00 00       	call   80104d10 <popcli>
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
801042a6:	85 db                	test   %ebx,%ebx
801042a8:	0f 84 8f 00 00 00    	je     8010433d <wait+0x11d>
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
801042ae:	89 73 24             	mov    %esi,0x24(%ebx)
  p->state = SLEEPING;
801042b1:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)

  sched();
801042b8:	e8 a3 fe ff ff       	call   80104160 <sched>

  // Tidy up.
  p->chan = 0;
801042bd:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
801042c4:	eb 84                	jmp    8010424a <wait+0x2a>
801042c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042cd:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
801042d0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
801042d3:	8b 73 14             	mov    0x14(%ebx),%esi
        kfree(p->kstack);
801042d6:	ff 73 0c             	push   0xc(%ebx)
801042d9:	e8 72 e5 ff ff       	call   80102850 <kfree>
        p->kstack = 0;
801042de:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        freevm(p->pgdir);
801042e5:	5a                   	pop    %edx
801042e6:	ff 73 08             	push   0x8(%ebx)
801042e9:	e8 22 34 00 00       	call   80107710 <freevm>
        p->pid = 0;
801042ee:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->parent = 0;
801042f5:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
        p->name[0] = 0;
801042fc:	c6 43 70 00          	movb   $0x0,0x70(%ebx)
        p->killed = 0;
80104300:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
        p->state = UNUSED;
80104307:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        release(&ptable.lock);
8010430e:	c7 04 24 60 6d 11 80 	movl   $0x80116d60,(%esp)
80104315:	e8 96 0a 00 00       	call   80104db0 <release>
        return pid;
8010431a:	83 c4 10             	add    $0x10,%esp
}
8010431d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104320:	89 f0                	mov    %esi,%eax
80104322:	5b                   	pop    %ebx
80104323:	5e                   	pop    %esi
80104324:	5d                   	pop    %ebp
80104325:	c3                   	ret    
      release(&ptable.lock);
80104326:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104329:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010432e:	68 60 6d 11 80       	push   $0x80116d60
80104333:	e8 78 0a 00 00       	call   80104db0 <release>
      return -1;
80104338:	83 c4 10             	add    $0x10,%esp
8010433b:	eb e0                	jmp    8010431d <wait+0xfd>
    panic("sleep");
8010433d:	83 ec 0c             	sub    $0xc,%esp
80104340:	68 88 84 10 80       	push   $0x80108488
80104345:	e8 36 c0 ff ff       	call   80100380 <panic>
8010434a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104350 <yield>:
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	53                   	push   %ebx
80104354:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104357:	68 60 6d 11 80       	push   $0x80116d60
8010435c:	e8 af 0a 00 00       	call   80104e10 <acquire>
  pushcli();
80104361:	e8 5a 09 00 00       	call   80104cc0 <pushcli>
  c = mycpu();
80104366:	e8 c5 fa ff ff       	call   80103e30 <mycpu>
  p = c->proc;
8010436b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104371:	e8 9a 09 00 00       	call   80104d10 <popcli>
  myproc()->state = RUNNABLE;
80104376:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  sched();
8010437d:	e8 de fd ff ff       	call   80104160 <sched>
  release(&ptable.lock);
80104382:	c7 04 24 60 6d 11 80 	movl   $0x80116d60,(%esp)
80104389:	e8 22 0a 00 00       	call   80104db0 <release>
}
8010438e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104391:	83 c4 10             	add    $0x10,%esp
80104394:	c9                   	leave  
80104395:	c3                   	ret    
80104396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010439d:	8d 76 00             	lea    0x0(%esi),%esi

801043a0 <sleep>:
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	57                   	push   %edi
801043a4:	56                   	push   %esi
801043a5:	53                   	push   %ebx
801043a6:	83 ec 0c             	sub    $0xc,%esp
801043a9:	8b 7d 08             	mov    0x8(%ebp),%edi
801043ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801043af:	e8 0c 09 00 00       	call   80104cc0 <pushcli>
  c = mycpu();
801043b4:	e8 77 fa ff ff       	call   80103e30 <mycpu>
  p = c->proc;
801043b9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043bf:	e8 4c 09 00 00       	call   80104d10 <popcli>
  if(p == 0)
801043c4:	85 db                	test   %ebx,%ebx
801043c6:	0f 84 87 00 00 00    	je     80104453 <sleep+0xb3>
  if(lk == 0)
801043cc:	85 f6                	test   %esi,%esi
801043ce:	74 76                	je     80104446 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801043d0:	81 fe 60 6d 11 80    	cmp    $0x80116d60,%esi
801043d6:	74 50                	je     80104428 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801043d8:	83 ec 0c             	sub    $0xc,%esp
801043db:	68 60 6d 11 80       	push   $0x80116d60
801043e0:	e8 2b 0a 00 00       	call   80104e10 <acquire>
    release(lk);
801043e5:	89 34 24             	mov    %esi,(%esp)
801043e8:	e8 c3 09 00 00       	call   80104db0 <release>
  p->chan = chan;
801043ed:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
801043f0:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
801043f7:	e8 64 fd ff ff       	call   80104160 <sched>
  p->chan = 0;
801043fc:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
    release(&ptable.lock);
80104403:	c7 04 24 60 6d 11 80 	movl   $0x80116d60,(%esp)
8010440a:	e8 a1 09 00 00       	call   80104db0 <release>
    acquire(lk);
8010440f:	89 75 08             	mov    %esi,0x8(%ebp)
80104412:	83 c4 10             	add    $0x10,%esp
}
80104415:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104418:	5b                   	pop    %ebx
80104419:	5e                   	pop    %esi
8010441a:	5f                   	pop    %edi
8010441b:	5d                   	pop    %ebp
    acquire(lk);
8010441c:	e9 ef 09 00 00       	jmp    80104e10 <acquire>
80104421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104428:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
8010442b:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
80104432:	e8 29 fd ff ff       	call   80104160 <sched>
  p->chan = 0;
80104437:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
}
8010443e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104441:	5b                   	pop    %ebx
80104442:	5e                   	pop    %esi
80104443:	5f                   	pop    %edi
80104444:	5d                   	pop    %ebp
80104445:	c3                   	ret    
    panic("sleep without lk");
80104446:	83 ec 0c             	sub    $0xc,%esp
80104449:	68 8e 84 10 80       	push   $0x8010848e
8010444e:	e8 2d bf ff ff       	call   80100380 <panic>
    panic("sleep");
80104453:	83 ec 0c             	sub    $0xc,%esp
80104456:	68 88 84 10 80       	push   $0x80108488
8010445b:	e8 20 bf ff ff       	call   80100380 <panic>

80104460 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	53                   	push   %ebx
80104464:	83 ec 10             	sub    $0x10,%esp
80104467:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010446a:	68 60 6d 11 80       	push   $0x80116d60
8010446f:	e8 9c 09 00 00       	call   80104e10 <acquire>
80104474:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104477:	b8 94 6d 11 80       	mov    $0x80116d94,%eax
8010447c:	eb 0c                	jmp    8010448a <wakeup+0x2a>
8010447e:	66 90                	xchg   %ax,%ax
80104480:	83 e8 80             	sub    $0xffffff80,%eax
80104483:	3d 94 8d 11 80       	cmp    $0x80118d94,%eax
80104488:	74 1c                	je     801044a6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010448a:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
8010448e:	75 f0                	jne    80104480 <wakeup+0x20>
80104490:	3b 58 24             	cmp    0x24(%eax),%ebx
80104493:	75 eb                	jne    80104480 <wakeup+0x20>
      p->state = RUNNABLE;
80104495:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010449c:	83 e8 80             	sub    $0xffffff80,%eax
8010449f:	3d 94 8d 11 80       	cmp    $0x80118d94,%eax
801044a4:	75 e4                	jne    8010448a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
801044a6:	c7 45 08 60 6d 11 80 	movl   $0x80116d60,0x8(%ebp)
}
801044ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044b0:	c9                   	leave  
  release(&ptable.lock);
801044b1:	e9 fa 08 00 00       	jmp    80104db0 <release>
801044b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044bd:	8d 76 00             	lea    0x0(%esi),%esi

801044c0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	53                   	push   %ebx
801044c4:	83 ec 10             	sub    $0x10,%esp
801044c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801044ca:	68 60 6d 11 80       	push   $0x80116d60
801044cf:	e8 3c 09 00 00       	call   80104e10 <acquire>
801044d4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044d7:	b8 94 6d 11 80       	mov    $0x80116d94,%eax
801044dc:	eb 0c                	jmp    801044ea <kill+0x2a>
801044de:	66 90                	xchg   %ax,%ax
801044e0:	83 e8 80             	sub    $0xffffff80,%eax
801044e3:	3d 94 8d 11 80       	cmp    $0x80118d94,%eax
801044e8:	74 36                	je     80104520 <kill+0x60>
    if(p->pid == pid){
801044ea:	39 58 14             	cmp    %ebx,0x14(%eax)
801044ed:	75 f1                	jne    801044e0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801044ef:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
      p->killed = 1;
801044f3:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
      if(p->state == SLEEPING)
801044fa:	75 07                	jne    80104503 <kill+0x43>
        p->state = RUNNABLE;
801044fc:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
      release(&ptable.lock);
80104503:	83 ec 0c             	sub    $0xc,%esp
80104506:	68 60 6d 11 80       	push   $0x80116d60
8010450b:	e8 a0 08 00 00       	call   80104db0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104510:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104513:	83 c4 10             	add    $0x10,%esp
80104516:	31 c0                	xor    %eax,%eax
}
80104518:	c9                   	leave  
80104519:	c3                   	ret    
8010451a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104520:	83 ec 0c             	sub    $0xc,%esp
80104523:	68 60 6d 11 80       	push   $0x80116d60
80104528:	e8 83 08 00 00       	call   80104db0 <release>
}
8010452d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104530:	83 c4 10             	add    $0x10,%esp
80104533:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104538:	c9                   	leave  
80104539:	c3                   	ret    
8010453a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104540 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	57                   	push   %edi
80104544:	56                   	push   %esi
80104545:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104548:	53                   	push   %ebx
80104549:	bb 04 6e 11 80       	mov    $0x80116e04,%ebx
8010454e:	83 ec 3c             	sub    $0x3c,%esp
80104551:	eb 24                	jmp    80104577 <procdump+0x37>
80104553:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104557:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104558:	83 ec 0c             	sub    $0xc,%esp
8010455b:	68 07 89 10 80       	push   $0x80108907
80104560:	e8 3b c1 ff ff       	call   801006a0 <cprintf>
80104565:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104568:	83 eb 80             	sub    $0xffffff80,%ebx
8010456b:	81 fb 04 8e 11 80    	cmp    $0x80118e04,%ebx
80104571:	0f 84 81 00 00 00    	je     801045f8 <procdump+0xb8>
    if(p->state == UNUSED)
80104577:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010457a:	85 c0                	test   %eax,%eax
8010457c:	74 ea                	je     80104568 <procdump+0x28>
      state = "???";
8010457e:	ba 9f 84 10 80       	mov    $0x8010849f,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104583:	83 f8 05             	cmp    $0x5,%eax
80104586:	77 11                	ja     80104599 <procdump+0x59>
80104588:	8b 14 85 b0 85 10 80 	mov    -0x7fef7a50(,%eax,4),%edx
      state = "???";
8010458f:	b8 9f 84 10 80       	mov    $0x8010849f,%eax
80104594:	85 d2                	test   %edx,%edx
80104596:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104599:	53                   	push   %ebx
8010459a:	52                   	push   %edx
8010459b:	ff 73 a4             	push   -0x5c(%ebx)
8010459e:	68 a3 84 10 80       	push   $0x801084a3
801045a3:	e8 f8 c0 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
801045a8:	83 c4 10             	add    $0x10,%esp
801045ab:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801045af:	75 a7                	jne    80104558 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801045b1:	83 ec 08             	sub    $0x8,%esp
801045b4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801045b7:	8d 7d c0             	lea    -0x40(%ebp),%edi
801045ba:	50                   	push   %eax
801045bb:	8b 43 b0             	mov    -0x50(%ebx),%eax
801045be:	8b 40 0c             	mov    0xc(%eax),%eax
801045c1:	83 c0 08             	add    $0x8,%eax
801045c4:	50                   	push   %eax
801045c5:	e8 96 06 00 00       	call   80104c60 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801045ca:	83 c4 10             	add    $0x10,%esp
801045cd:	8d 76 00             	lea    0x0(%esi),%esi
801045d0:	8b 17                	mov    (%edi),%edx
801045d2:	85 d2                	test   %edx,%edx
801045d4:	74 82                	je     80104558 <procdump+0x18>
        cprintf(" %p", pc[i]);
801045d6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801045d9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801045dc:	52                   	push   %edx
801045dd:	68 a1 7e 10 80       	push   $0x80107ea1
801045e2:	e8 b9 c0 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801045e7:	83 c4 10             	add    $0x10,%esp
801045ea:	39 fe                	cmp    %edi,%esi
801045ec:	75 e2                	jne    801045d0 <procdump+0x90>
801045ee:	e9 65 ff ff ff       	jmp    80104558 <procdump+0x18>
801045f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045f7:	90                   	nop
  }
}
801045f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045fb:	5b                   	pop    %ebx
801045fc:	5e                   	pop    %esi
801045fd:	5f                   	pop    %edi
801045fe:	5d                   	pop    %ebp
801045ff:	c3                   	ret    

80104600 <find_victim_process>:

struct proc* find_victim_process()
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	53                   	push   %ebx
80104604:	83 ec 10             	sub    $0x10,%esp
    struct proc* sp=ptable.proc;
    acquire(&ptable.lock);
80104607:	68 60 6d 11 80       	push   $0x80116d60
8010460c:	e8 ff 07 00 00       	call   80104e10 <acquire>

    for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104611:	b8 94 6d 11 80       	mov    $0x80116d94,%eax
    acquire(&ptable.lock);
80104616:	83 c4 10             	add    $0x10,%esp
    struct proc* sp=ptable.proc;
80104619:	89 c3                	mov    %eax,%ebx
8010461b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010461f:	90                   	nop
      if(p->rss> sp->rss)
80104620:	8b 53 04             	mov    0x4(%ebx),%edx
80104623:	39 50 04             	cmp    %edx,0x4(%eax)
80104626:	0f 47 d8             	cmova  %eax,%ebx
    for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104629:	83 e8 80             	sub    $0xffffff80,%eax
8010462c:	3d 94 8d 11 80       	cmp    $0x80118d94,%eax
80104631:	75 ed                	jne    80104620 <find_victim_process+0x20>
      {
        sp=p;
      }
    }
    release(&ptable.lock);
80104633:	83 ec 0c             	sub    $0xc,%esp
80104636:	68 60 6d 11 80       	push   $0x80116d60
8010463b:	e8 70 07 00 00       	call   80104db0 <release>
    return sp;
}
80104640:	89 d8                	mov    %ebx,%eax
80104642:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104645:	c9                   	leave  
80104646:	c3                   	ret    
80104647:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010464e:	66 90                	xchg   %ax,%ax

80104650 <find_victim_page>:


pte_t*
find_victim_page(struct proc* p)
{
80104650:	55                   	push   %ebp
80104651:	89 e5                	mov    %esp,%ebp
80104653:	56                   	push   %esi
80104654:	53                   	push   %ebx
80104655:	8b 5d 08             	mov    0x8(%ebp),%ebx
  for(int b=0;b<p->sz;b+=4096)
80104658:	8b 03                	mov    (%ebx),%eax
8010465a:	85 c0                	test   %eax,%eax
8010465c:	74 2b                	je     80104689 <find_victim_page+0x39>
8010465e:	31 f6                	xor    %esi,%esi
  {
    pte_t* pg=walkpgdir(p->pgdir,(void *)b,0);
80104660:	83 ec 04             	sub    $0x4,%esp
80104663:	6a 00                	push   $0x0
80104665:	56                   	push   %esi
80104666:	ff 73 08             	push   0x8(%ebx)
80104669:	e8 62 2b 00 00       	call   801071d0 <walkpgdir>
    // cprintf("page table entry:%p ",*pg);
    if(pg && (*pg& PTE_P)==PTE_P && (*pg &PTE_A)==0)
8010466e:	83 c4 10             	add    $0x10,%esp
80104671:	85 c0                	test   %eax,%eax
80104673:	74 0a                	je     8010467f <find_victim_page+0x2f>
80104675:	8b 10                	mov    (%eax),%edx
80104677:	83 e2 21             	and    $0x21,%edx
8010467a:	83 fa 01             	cmp    $0x1,%edx
8010467d:	74 0c                	je     8010468b <find_victim_page+0x3b>
  for(int b=0;b<p->sz;b+=4096)
8010467f:	81 c6 00 10 00 00    	add    $0x1000,%esi
80104685:	39 33                	cmp    %esi,(%ebx)
80104687:	77 d7                	ja     80104660 <find_victim_page+0x10>
    {
      // cprintf("  a................................%p  ",b);
      return pg;
    }
  }
  return 0;
80104689:	31 c0                	xor    %eax,%eax
}
8010468b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010468e:	5b                   	pop    %ebx
8010468f:	5e                   	pop    %esi
80104690:	5d                   	pop    %ebp
80104691:	c3                   	ret    
80104692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046a0 <make_unaccessed_page>:

void make_unaccessed_page(struct proc* p)
{
801046a0:	55                   	push   %ebp
  uint cnt=p->rss;
  cnt=cnt/10+1;
801046a1:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
{
801046a6:	89 e5                	mov    %esp,%ebp
801046a8:	57                   	push   %edi
801046a9:	56                   	push   %esi
801046aa:	53                   	push   %ebx
  for(int b=0;cnt && b<p->sz;b+=4096)
801046ab:	31 db                	xor    %ebx,%ebx
{
801046ad:	83 ec 0c             	sub    $0xc,%esp
801046b0:	8b 7d 08             	mov    0x8(%ebp),%edi
  cnt=cnt/10+1;
801046b3:	f7 67 04             	mull   0x4(%edi)
801046b6:	c1 ea 03             	shr    $0x3,%edx
801046b9:	8d 72 01             	lea    0x1(%edx),%esi
  for(int b=0;cnt && b<p->sz;b+=4096)
801046bc:	39 1f                	cmp    %ebx,(%edi)
801046be:	76 2b                	jbe    801046eb <make_unaccessed_page+0x4b>
  {
    pte_t* pg=walkpgdir(p->pgdir,(void *)b,0);
801046c0:	83 ec 04             	sub    $0x4,%esp
801046c3:	6a 00                	push   $0x0
801046c5:	53                   	push   %ebx
801046c6:	ff 77 08             	push   0x8(%edi)
801046c9:	e8 02 2b 00 00       	call   801071d0 <walkpgdir>
    if(pg && ((*pg& PTE_P)==PTE_P) && ((*pg &PTE_A)==PTE_A))
801046ce:	83 c4 10             	add    $0x10,%esp
801046d1:	85 c0                	test   %eax,%eax
801046d3:	74 0c                	je     801046e1 <make_unaccessed_page+0x41>
801046d5:	8b 10                	mov    (%eax),%edx
801046d7:	89 d1                	mov    %edx,%ecx
801046d9:	83 e1 21             	and    $0x21,%ecx
801046dc:	83 f9 21             	cmp    $0x21,%ecx
801046df:	74 17                	je     801046f8 <make_unaccessed_page+0x58>
  for(int b=0;cnt && b<p->sz;b+=4096)
801046e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801046e7:	39 1f                	cmp    %ebx,(%edi)
801046e9:	77 d5                	ja     801046c0 <make_unaccessed_page+0x20>
      *pg=(*pg)& (~PTE_A);
      cnt-=4096;
      // cprintf("count: %d",cnt);
    }
  }
}
801046eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046ee:	5b                   	pop    %ebx
801046ef:	5e                   	pop    %esi
801046f0:	5f                   	pop    %edi
801046f1:	5d                   	pop    %ebp
801046f2:	c3                   	ret    
801046f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046f7:	90                   	nop
      *pg=(*pg)& (~PTE_A);
801046f8:	83 e2 df             	and    $0xffffffdf,%edx
  for(int b=0;cnt && b<p->sz;b+=4096)
801046fb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      *pg=(*pg)& (~PTE_A);
80104701:	89 10                	mov    %edx,(%eax)
  for(int b=0;cnt && b<p->sz;b+=4096)
80104703:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80104709:	75 b1                	jne    801046bc <make_unaccessed_page+0x1c>
}
8010470b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010470e:	5b                   	pop    %ebx
8010470f:	5e                   	pop    %esi
80104710:	5f                   	pop    %edi
80104711:	5d                   	pop    %ebp
80104712:	c3                   	ret    
80104713:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010471a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104720 <find_proc_index>:
//   if(p>=&ptable.proc[NPROC])
//       panic("adding page of process that not exist.");
  
// }

int find_proc_index(struct proc* curproc){
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	53                   	push   %ebx
  struct proc* p;
  int i=0;
80104724:	31 db                	xor    %ebx,%ebx
int find_proc_index(struct proc* curproc){
80104726:	83 ec 10             	sub    $0x10,%esp

  acquire(&ptable.lock);
80104729:	68 60 6d 11 80       	push   $0x80116d60
8010472e:	e8 dd 06 00 00       	call   80104e10 <acquire>
  for(p=ptable.proc;p<&ptable.proc[NPROC];p++,i++)
  {
    if(p->pid==curproc->pid){
80104733:	8b 45 08             	mov    0x8(%ebp),%eax
80104736:	83 c4 10             	add    $0x10,%esp
80104739:	8b 50 14             	mov    0x14(%eax),%edx
8010473c:	eb 0a                	jmp    80104748 <find_proc_index+0x28>
8010473e:	66 90                	xchg   %ax,%ax
  for(p=ptable.proc;p<&ptable.proc[NPROC];p++,i++)
80104740:	83 c3 01             	add    $0x1,%ebx
80104743:	83 fb 40             	cmp    $0x40,%ebx
80104746:	74 28                	je     80104770 <find_proc_index+0x50>
    if(p->pid==curproc->pid){
80104748:	89 d8                	mov    %ebx,%eax
8010474a:	c1 e0 07             	shl    $0x7,%eax
8010474d:	39 90 a8 6d 11 80    	cmp    %edx,-0x7fee9258(%eax)
80104753:	75 eb                	jne    80104740 <find_proc_index+0x20>
      release(&ptable.lock);
80104755:	83 ec 0c             	sub    $0xc,%esp
80104758:	68 60 6d 11 80       	push   $0x80116d60
8010475d:	e8 4e 06 00 00       	call   80104db0 <release>
  if(p>=&ptable.proc[NPROC])
      panic("adding page of process that not exist.");
  release(&ptable.lock);

  return i;
}
80104762:	89 d8                	mov    %ebx,%eax
80104764:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104767:	c9                   	leave  
80104768:	c3                   	ret    
80104769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("adding page of process that not exist.");
80104770:	83 ec 0c             	sub    $0xc,%esp
80104773:	68 88 85 10 80       	push   $0x80108588
80104778:	e8 03 bc ff ff       	call   80100380 <panic>
8010477d:	8d 76 00             	lea    0x0(%esi),%esi

80104780 <find_proc_from_index>:

struct proc* find_proc_from_index(int cur_proc_index)
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	53                   	push   %ebx
80104784:	83 ec 04             	sub    $0x4,%esp
80104787:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc * curproc;
  if(cur_proc_index>=64)
8010478a:	83 fb 3f             	cmp    $0x3f,%ebx
8010478d:	7f 27                	jg     801047b6 <find_proc_from_index+0x36>
    panic("Invalid process index");

  acquire(&ptable.lock);
8010478f:	83 ec 0c             	sub    $0xc,%esp
  curproc=ptable.proc+cur_proc_index;
80104792:	c1 e3 07             	shl    $0x7,%ebx
  acquire(&ptable.lock);
80104795:	68 60 6d 11 80       	push   $0x80116d60
8010479a:	e8 71 06 00 00       	call   80104e10 <acquire>
  release(&ptable.lock);
8010479f:	c7 04 24 60 6d 11 80 	movl   $0x80116d60,(%esp)
801047a6:	e8 05 06 00 00       	call   80104db0 <release>
  curproc=ptable.proc+cur_proc_index;
801047ab:	8d 83 94 6d 11 80    	lea    -0x7fee926c(%ebx),%eax

  return curproc;
}
801047b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047b4:	c9                   	leave  
801047b5:	c3                   	ret    
    panic("Invalid process index");
801047b6:	83 ec 0c             	sub    $0xc,%esp
801047b9:	68 ac 84 10 80       	push   $0x801084ac
801047be:	e8 bd bb ff ff       	call   80100380 <panic>
801047c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047d0 <update_process_index_to_rmap>:

void update_process_index_to_rmap(struct proc* curproc, uint value)
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	57                   	push   %edi
801047d4:	56                   	push   %esi
  int i=0;
801047d5:	31 f6                	xor    %esi,%esi
{
801047d7:	53                   	push   %ebx
801047d8:	83 ec 18             	sub    $0x18,%esp
801047db:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&ptable.lock);
801047de:	68 60 6d 11 80       	push   $0x80116d60
801047e3:	e8 28 06 00 00       	call   80104e10 <acquire>
    if(p->pid==curproc->pid){
801047e8:	8b 57 14             	mov    0x14(%edi),%edx
801047eb:	83 c4 10             	add    $0x10,%esp
801047ee:	eb 08                	jmp    801047f8 <update_process_index_to_rmap+0x28>
  for(p=ptable.proc;p<&ptable.proc[NPROC];p++,i++)
801047f0:	83 c6 01             	add    $0x1,%esi
801047f3:	83 fe 40             	cmp    $0x40,%esi
801047f6:	74 70                	je     80104868 <update_process_index_to_rmap+0x98>
    if(p->pid==curproc->pid){
801047f8:	89 f0                	mov    %esi,%eax
801047fa:	c1 e0 07             	shl    $0x7,%eax
801047fd:	39 90 a8 6d 11 80    	cmp    %edx,-0x7fee9258(%eax)
80104803:	75 eb                	jne    801047f0 <update_process_index_to_rmap+0x20>
      release(&ptable.lock);
80104805:	83 ec 0c             	sub    $0xc,%esp
  uint pa, i;
  uint process_index;

  process_index=find_proc_index(curproc);

  for(i = 0; i < curproc->sz; i += PGSIZE){
80104808:	31 db                	xor    %ebx,%ebx
      release(&ptable.lock);
8010480a:	68 60 6d 11 80       	push   $0x80116d60
8010480f:	e8 9c 05 00 00       	call   80104db0 <release>
  for(i = 0; i < curproc->sz; i += PGSIZE){
80104814:	8b 07                	mov    (%edi),%eax
80104816:	83 c4 10             	add    $0x10,%esp
80104819:	85 c0                	test   %eax,%eax
8010481b:	74 3d                	je     8010485a <update_process_index_to_rmap+0x8a>
8010481d:	8d 76 00             	lea    0x0(%esi),%esi
    if((pte = walkpgdir(curproc->pgdir, (void *) i, 0)) == 0)
80104820:	83 ec 04             	sub    $0x4,%esp
80104823:	6a 00                	push   $0x0
80104825:	53                   	push   %ebx
80104826:	ff 77 08             	push   0x8(%edi)
80104829:	e8 a2 29 00 00       	call   801071d0 <walkpgdir>
8010482e:	83 c4 10             	add    $0x10,%esp
80104831:	85 c0                	test   %eax,%eax
80104833:	74 4d                	je     80104882 <update_process_index_to_rmap+0xb2>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80104835:	8b 00                	mov    (%eax),%eax
80104837:	a8 01                	test   $0x1,%al
80104839:	74 3a                	je     80104875 <update_process_index_to_rmap+0xa5>
      panic("copyuvm: page not present");
    pa=PTE_ADDR(*pte);
    set_pindex_status(pa,process_index,value);
8010483b:	83 ec 04             	sub    $0x4,%esp
    pa=PTE_ADDR(*pte);
8010483e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    set_pindex_status(pa,process_index,value);
80104843:	ff 75 0c             	push   0xc(%ebp)
  for(i = 0; i < curproc->sz; i += PGSIZE){
80104846:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    set_pindex_status(pa,process_index,value);
8010484c:	56                   	push   %esi
8010484d:	50                   	push   %eax
8010484e:	e8 0d df ff ff       	call   80102760 <set_pindex_status>
  for(i = 0; i < curproc->sz; i += PGSIZE){
80104853:	83 c4 10             	add    $0x10,%esp
80104856:	39 1f                	cmp    %ebx,(%edi)
80104858:	77 c6                	ja     80104820 <update_process_index_to_rmap+0x50>
  }
}
8010485a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010485d:	5b                   	pop    %ebx
8010485e:	5e                   	pop    %esi
8010485f:	5f                   	pop    %edi
80104860:	5d                   	pop    %ebp
80104861:	c3                   	ret    
80104862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      panic("adding page of process that not exist.");
80104868:	83 ec 0c             	sub    $0xc,%esp
8010486b:	68 88 85 10 80       	push   $0x80108588
80104870:	e8 0b bb ff ff       	call   80100380 <panic>
      panic("copyuvm: page not present");
80104875:	83 ec 0c             	sub    $0xc,%esp
80104878:	68 dc 84 10 80       	push   $0x801084dc
8010487d:	e8 fe ba ff ff       	call   80100380 <panic>
      panic("copyuvm: pte should exist");
80104882:	83 ec 0c             	sub    $0xc,%esp
80104885:	68 c2 84 10 80       	push   $0x801084c2
8010488a:	e8 f1 ba ff ff       	call   80100380 <panic>
8010488f:	90                   	nop

80104890 <fork>:
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	57                   	push   %edi
80104894:	56                   	push   %esi
80104895:	53                   	push   %ebx
80104896:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104899:	e8 22 04 00 00       	call   80104cc0 <pushcli>
  c = mycpu();
8010489e:	e8 8d f5 ff ff       	call   80103e30 <mycpu>
  p = c->proc;
801048a3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801048a9:	e8 62 04 00 00       	call   80104d10 <popcli>
  if((np = allocproc()) == 0){
801048ae:	e8 3d f4 ff ff       	call   80103cf0 <allocproc>
801048b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801048b6:	85 c0                	test   %eax,%eax
801048b8:	0f 84 d7 00 00 00    	je     80104995 <fork+0x105>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801048be:	83 ec 08             	sub    $0x8,%esp
801048c1:	ff 33                	push   (%ebx)
801048c3:	89 c7                	mov    %eax,%edi
801048c5:	ff 73 08             	push   0x8(%ebx)
801048c8:	e8 b3 2f 00 00       	call   80107880 <copyuvm>
801048cd:	83 c4 10             	add    $0x10,%esp
801048d0:	89 47 08             	mov    %eax,0x8(%edi)
801048d3:	85 c0                	test   %eax,%eax
801048d5:	0f 84 c1 00 00 00    	je     8010499c <fork+0x10c>
  update_process_index_to_rmap(curproc,(uint)1);
801048db:	83 ec 08             	sub    $0x8,%esp
801048de:	6a 01                	push   $0x1
801048e0:	53                   	push   %ebx
801048e1:	e8 ea fe ff ff       	call   801047d0 <update_process_index_to_rmap>
  update_process_index_to_rmap(np,(uint)1);
801048e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801048e9:	58                   	pop    %eax
801048ea:	5a                   	pop    %edx
801048eb:	6a 01                	push   $0x1
801048ed:	57                   	push   %edi
801048ee:	e8 dd fe ff ff       	call   801047d0 <update_process_index_to_rmap>
  np->sz = curproc->sz;
801048f3:	8b 03                	mov    (%ebx),%eax
  *np->tf = *curproc->tf;
801048f5:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->parent = curproc;
801048fa:	89 5f 18             	mov    %ebx,0x18(%edi)
  np->tf->eax = 0;
801048fd:	83 c4 10             	add    $0x10,%esp
  np->sz = curproc->sz;
80104900:	89 07                	mov    %eax,(%edi)
  np->rss = np->sz;
80104902:	89 47 04             	mov    %eax,0x4(%edi)
  np->parent = curproc;
80104905:	89 f8                	mov    %edi,%eax
  *np->tf = *curproc->tf;
80104907:	8b 73 1c             	mov    0x1c(%ebx),%esi
8010490a:	8b 7f 1c             	mov    0x1c(%edi),%edi
8010490d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
8010490f:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80104911:	8b 40 1c             	mov    0x1c(%eax),%eax
80104914:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
8010491b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010491f:	90                   	nop
    if(curproc->ofile[i])
80104920:	8b 44 b3 2c          	mov    0x2c(%ebx,%esi,4),%eax
80104924:	85 c0                	test   %eax,%eax
80104926:	74 13                	je     8010493b <fork+0xab>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104928:	83 ec 0c             	sub    $0xc,%esp
8010492b:	50                   	push   %eax
8010492c:	e8 7f c5 ff ff       	call   80100eb0 <filedup>
80104931:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104934:	83 c4 10             	add    $0x10,%esp
80104937:	89 44 b2 2c          	mov    %eax,0x2c(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010493b:	83 c6 01             	add    $0x1,%esi
8010493e:	83 fe 10             	cmp    $0x10,%esi
80104941:	75 dd                	jne    80104920 <fork+0x90>
  np->cwd = idup(curproc->cwd);
80104943:	83 ec 0c             	sub    $0xc,%esp
80104946:	ff 73 6c             	push   0x6c(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104949:	83 c3 70             	add    $0x70,%ebx
  np->cwd = idup(curproc->cwd);
8010494c:	e8 1f ce ff ff       	call   80101770 <idup>
80104951:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104954:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104957:	89 47 6c             	mov    %eax,0x6c(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010495a:	8d 47 70             	lea    0x70(%edi),%eax
8010495d:	6a 10                	push   $0x10
8010495f:	53                   	push   %ebx
80104960:	50                   	push   %eax
80104961:	e8 2a 07 00 00       	call   80105090 <safestrcpy>
  pid = np->pid;
80104966:	8b 5f 14             	mov    0x14(%edi),%ebx
  acquire(&ptable.lock);
80104969:	c7 04 24 60 6d 11 80 	movl   $0x80116d60,(%esp)
80104970:	e8 9b 04 00 00       	call   80104e10 <acquire>
  np->state = RUNNABLE;
80104975:	c7 47 10 03 00 00 00 	movl   $0x3,0x10(%edi)
  release(&ptable.lock);
8010497c:	c7 04 24 60 6d 11 80 	movl   $0x80116d60,(%esp)
80104983:	e8 28 04 00 00       	call   80104db0 <release>
  return pid;
80104988:	83 c4 10             	add    $0x10,%esp
}
8010498b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010498e:	89 d8                	mov    %ebx,%eax
80104990:	5b                   	pop    %ebx
80104991:	5e                   	pop    %esi
80104992:	5f                   	pop    %edi
80104993:	5d                   	pop    %ebp
80104994:	c3                   	ret    
    return -1;
80104995:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010499a:	eb ef                	jmp    8010498b <fork+0xfb>
    kfree(np->kstack);
8010499c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010499f:	83 ec 0c             	sub    $0xc,%esp
801049a2:	ff 73 0c             	push   0xc(%ebx)
801049a5:	e8 a6 de ff ff       	call   80102850 <kfree>
    np->kstack = 0;
801049aa:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801049b1:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
801049b4:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return -1;
801049bb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801049c0:	eb c9                	jmp    8010498b <fork+0xfb>
801049c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801049d0 <exit>:
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	57                   	push   %edi
801049d4:	56                   	push   %esi
801049d5:	53                   	push   %ebx
801049d6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
801049d9:	e8 d2 f4 ff ff       	call   80103eb0 <myproc>
  if(curproc == initproc)
801049de:	39 05 94 8d 11 80    	cmp    %eax,0x80118d94
801049e4:	0f 84 0f 01 00 00    	je     80104af9 <exit+0x129>
801049ea:	89 c3                	mov    %eax,%ebx
801049ec:	8d 70 2c             	lea    0x2c(%eax),%esi
801049ef:	8d 78 6c             	lea    0x6c(%eax),%edi
801049f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
801049f8:	8b 06                	mov    (%esi),%eax
801049fa:	85 c0                	test   %eax,%eax
801049fc:	74 12                	je     80104a10 <exit+0x40>
      fileclose(curproc->ofile[fd]);
801049fe:	83 ec 0c             	sub    $0xc,%esp
80104a01:	50                   	push   %eax
80104a02:	e8 f9 c4 ff ff       	call   80100f00 <fileclose>
      curproc->ofile[fd] = 0;
80104a07:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80104a0d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104a10:	83 c6 04             	add    $0x4,%esi
80104a13:	39 f7                	cmp    %esi,%edi
80104a15:	75 e1                	jne    801049f8 <exit+0x28>
  begin_op();
80104a17:	e8 84 e8 ff ff       	call   801032a0 <begin_op>
  iput(curproc->cwd);
80104a1c:	83 ec 0c             	sub    $0xc,%esp
80104a1f:	ff 73 6c             	push   0x6c(%ebx)
80104a22:	e8 a9 ce ff ff       	call   801018d0 <iput>
  end_op();
80104a27:	e8 e4 e8 ff ff       	call   80103310 <end_op>
  curproc->cwd = 0;
80104a2c:	c7 43 6c 00 00 00 00 	movl   $0x0,0x6c(%ebx)
  acquire(&ptable.lock);
80104a33:	c7 04 24 60 6d 11 80 	movl   $0x80116d60,(%esp)
80104a3a:	e8 d1 03 00 00       	call   80104e10 <acquire>
  wakeup1(curproc->parent);
80104a3f:	8b 53 18             	mov    0x18(%ebx),%edx
80104a42:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a45:	b8 94 6d 11 80       	mov    $0x80116d94,%eax
80104a4a:	eb 0e                	jmp    80104a5a <exit+0x8a>
80104a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a50:	83 e8 80             	sub    $0xffffff80,%eax
80104a53:	3d 94 8d 11 80       	cmp    $0x80118d94,%eax
80104a58:	74 1c                	je     80104a76 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80104a5a:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80104a5e:	75 f0                	jne    80104a50 <exit+0x80>
80104a60:	3b 50 24             	cmp    0x24(%eax),%edx
80104a63:	75 eb                	jne    80104a50 <exit+0x80>
      p->state = RUNNABLE;
80104a65:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a6c:	83 e8 80             	sub    $0xffffff80,%eax
80104a6f:	3d 94 8d 11 80       	cmp    $0x80118d94,%eax
80104a74:	75 e4                	jne    80104a5a <exit+0x8a>
      p->parent = initproc;
80104a76:	8b 0d 94 8d 11 80    	mov    0x80118d94,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a7c:	ba 94 6d 11 80       	mov    $0x80116d94,%edx
80104a81:	eb 10                	jmp    80104a93 <exit+0xc3>
80104a83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a87:	90                   	nop
80104a88:	83 ea 80             	sub    $0xffffff80,%edx
80104a8b:	81 fa 94 8d 11 80    	cmp    $0x80118d94,%edx
80104a91:	74 3b                	je     80104ace <exit+0xfe>
    if(p->parent == curproc){
80104a93:	39 5a 18             	cmp    %ebx,0x18(%edx)
80104a96:	75 f0                	jne    80104a88 <exit+0xb8>
      if(p->state == ZOMBIE)
80104a98:	83 7a 10 05          	cmpl   $0x5,0x10(%edx)
      p->parent = initproc;
80104a9c:	89 4a 18             	mov    %ecx,0x18(%edx)
      if(p->state == ZOMBIE)
80104a9f:	75 e7                	jne    80104a88 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104aa1:	b8 94 6d 11 80       	mov    $0x80116d94,%eax
80104aa6:	eb 12                	jmp    80104aba <exit+0xea>
80104aa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aaf:	90                   	nop
80104ab0:	83 e8 80             	sub    $0xffffff80,%eax
80104ab3:	3d 94 8d 11 80       	cmp    $0x80118d94,%eax
80104ab8:	74 ce                	je     80104a88 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80104aba:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80104abe:	75 f0                	jne    80104ab0 <exit+0xe0>
80104ac0:	3b 48 24             	cmp    0x24(%eax),%ecx
80104ac3:	75 eb                	jne    80104ab0 <exit+0xe0>
      p->state = RUNNABLE;
80104ac5:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
80104acc:	eb e2                	jmp    80104ab0 <exit+0xe0>
  free_swap(curproc);
80104ace:	83 ec 0c             	sub    $0xc,%esp
  curproc->state = ZOMBIE;
80104ad1:	c7 43 10 05 00 00 00 	movl   $0x5,0x10(%ebx)
  free_swap(curproc);
80104ad8:	53                   	push   %ebx
80104ad9:	e8 e2 30 00 00       	call   80107bc0 <free_swap>
  update_process_index_to_rmap(curproc,(uint)0);
80104ade:	58                   	pop    %eax
80104adf:	5a                   	pop    %edx
80104ae0:	6a 00                	push   $0x0
80104ae2:	53                   	push   %ebx
80104ae3:	e8 e8 fc ff ff       	call   801047d0 <update_process_index_to_rmap>
  sched();
80104ae8:	e8 73 f6 ff ff       	call   80104160 <sched>
  panic("zombie exit");
80104aed:	c7 04 24 03 85 10 80 	movl   $0x80108503,(%esp)
80104af4:	e8 87 b8 ff ff       	call   80100380 <panic>
    panic("init exiting");
80104af9:	83 ec 0c             	sub    $0xc,%esp
80104afc:	68 f6 84 10 80       	push   $0x801084f6
80104b01:	e8 7a b8 ff ff       	call   80100380 <panic>
80104b06:	66 90                	xchg   %ax,%ax
80104b08:	66 90                	xchg   %ax,%ax
80104b0a:	66 90                	xchg   %ax,%ax
80104b0c:	66 90                	xchg   %ax,%ax
80104b0e:	66 90                	xchg   %ax,%ax

80104b10 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	53                   	push   %ebx
80104b14:	83 ec 0c             	sub    $0xc,%esp
80104b17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104b1a:	68 c8 85 10 80       	push   $0x801085c8
80104b1f:	8d 43 04             	lea    0x4(%ebx),%eax
80104b22:	50                   	push   %eax
80104b23:	e8 18 01 00 00       	call   80104c40 <initlock>
  lk->name = name;
80104b28:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104b2b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104b31:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104b34:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104b3b:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104b3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b41:	c9                   	leave  
80104b42:	c3                   	ret    
80104b43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b50 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	56                   	push   %esi
80104b54:	53                   	push   %ebx
80104b55:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104b58:	8d 73 04             	lea    0x4(%ebx),%esi
80104b5b:	83 ec 0c             	sub    $0xc,%esp
80104b5e:	56                   	push   %esi
80104b5f:	e8 ac 02 00 00       	call   80104e10 <acquire>
  while (lk->locked) {
80104b64:	8b 13                	mov    (%ebx),%edx
80104b66:	83 c4 10             	add    $0x10,%esp
80104b69:	85 d2                	test   %edx,%edx
80104b6b:	74 16                	je     80104b83 <acquiresleep+0x33>
80104b6d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104b70:	83 ec 08             	sub    $0x8,%esp
80104b73:	56                   	push   %esi
80104b74:	53                   	push   %ebx
80104b75:	e8 26 f8 ff ff       	call   801043a0 <sleep>
  while (lk->locked) {
80104b7a:	8b 03                	mov    (%ebx),%eax
80104b7c:	83 c4 10             	add    $0x10,%esp
80104b7f:	85 c0                	test   %eax,%eax
80104b81:	75 ed                	jne    80104b70 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104b83:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104b89:	e8 22 f3 ff ff       	call   80103eb0 <myproc>
80104b8e:	8b 40 14             	mov    0x14(%eax),%eax
80104b91:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104b94:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104b97:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b9a:	5b                   	pop    %ebx
80104b9b:	5e                   	pop    %esi
80104b9c:	5d                   	pop    %ebp
  release(&lk->lk);
80104b9d:	e9 0e 02 00 00       	jmp    80104db0 <release>
80104ba2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104bb0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	56                   	push   %esi
80104bb4:	53                   	push   %ebx
80104bb5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104bb8:	8d 73 04             	lea    0x4(%ebx),%esi
80104bbb:	83 ec 0c             	sub    $0xc,%esp
80104bbe:	56                   	push   %esi
80104bbf:	e8 4c 02 00 00       	call   80104e10 <acquire>
  lk->locked = 0;
80104bc4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104bca:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104bd1:	89 1c 24             	mov    %ebx,(%esp)
80104bd4:	e8 87 f8 ff ff       	call   80104460 <wakeup>
  release(&lk->lk);
80104bd9:	89 75 08             	mov    %esi,0x8(%ebp)
80104bdc:	83 c4 10             	add    $0x10,%esp
}
80104bdf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104be2:	5b                   	pop    %ebx
80104be3:	5e                   	pop    %esi
80104be4:	5d                   	pop    %ebp
  release(&lk->lk);
80104be5:	e9 c6 01 00 00       	jmp    80104db0 <release>
80104bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104bf0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	57                   	push   %edi
80104bf4:	31 ff                	xor    %edi,%edi
80104bf6:	56                   	push   %esi
80104bf7:	53                   	push   %ebx
80104bf8:	83 ec 18             	sub    $0x18,%esp
80104bfb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104bfe:	8d 73 04             	lea    0x4(%ebx),%esi
80104c01:	56                   	push   %esi
80104c02:	e8 09 02 00 00       	call   80104e10 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104c07:	8b 03                	mov    (%ebx),%eax
80104c09:	83 c4 10             	add    $0x10,%esp
80104c0c:	85 c0                	test   %eax,%eax
80104c0e:	75 18                	jne    80104c28 <holdingsleep+0x38>
  release(&lk->lk);
80104c10:	83 ec 0c             	sub    $0xc,%esp
80104c13:	56                   	push   %esi
80104c14:	e8 97 01 00 00       	call   80104db0 <release>
  return r;
}
80104c19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c1c:	89 f8                	mov    %edi,%eax
80104c1e:	5b                   	pop    %ebx
80104c1f:	5e                   	pop    %esi
80104c20:	5f                   	pop    %edi
80104c21:	5d                   	pop    %ebp
80104c22:	c3                   	ret    
80104c23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c27:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104c28:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104c2b:	e8 80 f2 ff ff       	call   80103eb0 <myproc>
80104c30:	39 58 14             	cmp    %ebx,0x14(%eax)
80104c33:	0f 94 c0             	sete   %al
80104c36:	0f b6 c0             	movzbl %al,%eax
80104c39:	89 c7                	mov    %eax,%edi
80104c3b:	eb d3                	jmp    80104c10 <holdingsleep+0x20>
80104c3d:	66 90                	xchg   %ax,%ax
80104c3f:	90                   	nop

80104c40 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104c40:	55                   	push   %ebp
80104c41:	89 e5                	mov    %esp,%ebp
80104c43:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104c46:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104c49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104c4f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104c52:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104c59:	5d                   	pop    %ebp
80104c5a:	c3                   	ret    
80104c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c5f:	90                   	nop

80104c60 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104c60:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104c61:	31 d2                	xor    %edx,%edx
{
80104c63:	89 e5                	mov    %esp,%ebp
80104c65:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104c66:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104c69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104c6c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104c6f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104c70:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104c76:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104c7c:	77 1a                	ja     80104c98 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104c7e:	8b 58 04             	mov    0x4(%eax),%ebx
80104c81:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104c84:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104c87:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104c89:	83 fa 0a             	cmp    $0xa,%edx
80104c8c:	75 e2                	jne    80104c70 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104c8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c91:	c9                   	leave  
80104c92:	c3                   	ret    
80104c93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c97:	90                   	nop
  for(; i < 10; i++)
80104c98:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104c9b:	8d 51 28             	lea    0x28(%ecx),%edx
80104c9e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104ca0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104ca6:	83 c0 04             	add    $0x4,%eax
80104ca9:	39 d0                	cmp    %edx,%eax
80104cab:	75 f3                	jne    80104ca0 <getcallerpcs+0x40>
}
80104cad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cb0:	c9                   	leave  
80104cb1:	c3                   	ret    
80104cb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104cc0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	53                   	push   %ebx
80104cc4:	83 ec 04             	sub    $0x4,%esp
80104cc7:	9c                   	pushf  
80104cc8:	5b                   	pop    %ebx
  asm volatile("cli");
80104cc9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104cca:	e8 61 f1 ff ff       	call   80103e30 <mycpu>
80104ccf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104cd5:	85 c0                	test   %eax,%eax
80104cd7:	74 17                	je     80104cf0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104cd9:	e8 52 f1 ff ff       	call   80103e30 <mycpu>
80104cde:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104ce5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ce8:	c9                   	leave  
80104ce9:	c3                   	ret    
80104cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104cf0:	e8 3b f1 ff ff       	call   80103e30 <mycpu>
80104cf5:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104cfb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104d01:	eb d6                	jmp    80104cd9 <pushcli+0x19>
80104d03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d10 <popcli>:

void
popcli(void)
{
80104d10:	55                   	push   %ebp
80104d11:	89 e5                	mov    %esp,%ebp
80104d13:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104d16:	9c                   	pushf  
80104d17:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104d18:	f6 c4 02             	test   $0x2,%ah
80104d1b:	75 35                	jne    80104d52 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104d1d:	e8 0e f1 ff ff       	call   80103e30 <mycpu>
80104d22:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104d29:	78 34                	js     80104d5f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104d2b:	e8 00 f1 ff ff       	call   80103e30 <mycpu>
80104d30:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104d36:	85 d2                	test   %edx,%edx
80104d38:	74 06                	je     80104d40 <popcli+0x30>
    sti();
}
80104d3a:	c9                   	leave  
80104d3b:	c3                   	ret    
80104d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104d40:	e8 eb f0 ff ff       	call   80103e30 <mycpu>
80104d45:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104d4b:	85 c0                	test   %eax,%eax
80104d4d:	74 eb                	je     80104d3a <popcli+0x2a>
  asm volatile("sti");
80104d4f:	fb                   	sti    
}
80104d50:	c9                   	leave  
80104d51:	c3                   	ret    
    panic("popcli - interruptible");
80104d52:	83 ec 0c             	sub    $0xc,%esp
80104d55:	68 d3 85 10 80       	push   $0x801085d3
80104d5a:	e8 21 b6 ff ff       	call   80100380 <panic>
    panic("popcli");
80104d5f:	83 ec 0c             	sub    $0xc,%esp
80104d62:	68 ea 85 10 80       	push   $0x801085ea
80104d67:	e8 14 b6 ff ff       	call   80100380 <panic>
80104d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d70 <holding>:
{
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	56                   	push   %esi
80104d74:	53                   	push   %ebx
80104d75:	8b 75 08             	mov    0x8(%ebp),%esi
80104d78:	31 db                	xor    %ebx,%ebx
  pushcli();
80104d7a:	e8 41 ff ff ff       	call   80104cc0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104d7f:	8b 06                	mov    (%esi),%eax
80104d81:	85 c0                	test   %eax,%eax
80104d83:	75 0b                	jne    80104d90 <holding+0x20>
  popcli();
80104d85:	e8 86 ff ff ff       	call   80104d10 <popcli>
}
80104d8a:	89 d8                	mov    %ebx,%eax
80104d8c:	5b                   	pop    %ebx
80104d8d:	5e                   	pop    %esi
80104d8e:	5d                   	pop    %ebp
80104d8f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104d90:	8b 5e 08             	mov    0x8(%esi),%ebx
80104d93:	e8 98 f0 ff ff       	call   80103e30 <mycpu>
80104d98:	39 c3                	cmp    %eax,%ebx
80104d9a:	0f 94 c3             	sete   %bl
  popcli();
80104d9d:	e8 6e ff ff ff       	call   80104d10 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104da2:	0f b6 db             	movzbl %bl,%ebx
}
80104da5:	89 d8                	mov    %ebx,%eax
80104da7:	5b                   	pop    %ebx
80104da8:	5e                   	pop    %esi
80104da9:	5d                   	pop    %ebp
80104daa:	c3                   	ret    
80104dab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104daf:	90                   	nop

80104db0 <release>:
{
80104db0:	55                   	push   %ebp
80104db1:	89 e5                	mov    %esp,%ebp
80104db3:	56                   	push   %esi
80104db4:	53                   	push   %ebx
80104db5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104db8:	e8 03 ff ff ff       	call   80104cc0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104dbd:	8b 03                	mov    (%ebx),%eax
80104dbf:	85 c0                	test   %eax,%eax
80104dc1:	75 15                	jne    80104dd8 <release+0x28>
  popcli();
80104dc3:	e8 48 ff ff ff       	call   80104d10 <popcli>
    panic("release");
80104dc8:	83 ec 0c             	sub    $0xc,%esp
80104dcb:	68 f1 85 10 80       	push   $0x801085f1
80104dd0:	e8 ab b5 ff ff       	call   80100380 <panic>
80104dd5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104dd8:	8b 73 08             	mov    0x8(%ebx),%esi
80104ddb:	e8 50 f0 ff ff       	call   80103e30 <mycpu>
80104de0:	39 c6                	cmp    %eax,%esi
80104de2:	75 df                	jne    80104dc3 <release+0x13>
  popcli();
80104de4:	e8 27 ff ff ff       	call   80104d10 <popcli>
  lk->pcs[0] = 0;
80104de9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104df0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104df7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104dfc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104e02:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e05:	5b                   	pop    %ebx
80104e06:	5e                   	pop    %esi
80104e07:	5d                   	pop    %ebp
  popcli();
80104e08:	e9 03 ff ff ff       	jmp    80104d10 <popcli>
80104e0d:	8d 76 00             	lea    0x0(%esi),%esi

80104e10 <acquire>:
{
80104e10:	55                   	push   %ebp
80104e11:	89 e5                	mov    %esp,%ebp
80104e13:	53                   	push   %ebx
80104e14:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104e17:	e8 a4 fe ff ff       	call   80104cc0 <pushcli>
  if(holding(lk))
80104e1c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104e1f:	e8 9c fe ff ff       	call   80104cc0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104e24:	8b 03                	mov    (%ebx),%eax
80104e26:	85 c0                	test   %eax,%eax
80104e28:	75 7e                	jne    80104ea8 <acquire+0x98>
  popcli();
80104e2a:	e8 e1 fe ff ff       	call   80104d10 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104e2f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104e38:	8b 55 08             	mov    0x8(%ebp),%edx
80104e3b:	89 c8                	mov    %ecx,%eax
80104e3d:	f0 87 02             	lock xchg %eax,(%edx)
80104e40:	85 c0                	test   %eax,%eax
80104e42:	75 f4                	jne    80104e38 <acquire+0x28>
  __sync_synchronize();
80104e44:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e4c:	e8 df ef ff ff       	call   80103e30 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104e51:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104e54:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104e56:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104e59:	31 c0                	xor    %eax,%eax
80104e5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e5f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104e60:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104e66:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104e6c:	77 1a                	ja     80104e88 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
80104e6e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104e71:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104e75:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104e78:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104e7a:	83 f8 0a             	cmp    $0xa,%eax
80104e7d:	75 e1                	jne    80104e60 <acquire+0x50>
}
80104e7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e82:	c9                   	leave  
80104e83:	c3                   	ret    
80104e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104e88:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
80104e8c:	8d 51 34             	lea    0x34(%ecx),%edx
80104e8f:	90                   	nop
    pcs[i] = 0;
80104e90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104e96:	83 c0 04             	add    $0x4,%eax
80104e99:	39 c2                	cmp    %eax,%edx
80104e9b:	75 f3                	jne    80104e90 <acquire+0x80>
}
80104e9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ea0:	c9                   	leave  
80104ea1:	c3                   	ret    
80104ea2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104ea8:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104eab:	e8 80 ef ff ff       	call   80103e30 <mycpu>
80104eb0:	39 c3                	cmp    %eax,%ebx
80104eb2:	0f 85 72 ff ff ff    	jne    80104e2a <acquire+0x1a>
  popcli();
80104eb8:	e8 53 fe ff ff       	call   80104d10 <popcli>
    panic("acquire");
80104ebd:	83 ec 0c             	sub    $0xc,%esp
80104ec0:	68 f9 85 10 80       	push   $0x801085f9
80104ec5:	e8 b6 b4 ff ff       	call   80100380 <panic>
80104eca:	66 90                	xchg   %ax,%ax
80104ecc:	66 90                	xchg   %ax,%ax
80104ece:	66 90                	xchg   %ax,%ax

80104ed0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104ed0:	55                   	push   %ebp
80104ed1:	89 e5                	mov    %esp,%ebp
80104ed3:	57                   	push   %edi
80104ed4:	8b 55 08             	mov    0x8(%ebp),%edx
80104ed7:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104eda:	53                   	push   %ebx
80104edb:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104ede:	89 d7                	mov    %edx,%edi
80104ee0:	09 cf                	or     %ecx,%edi
80104ee2:	83 e7 03             	and    $0x3,%edi
80104ee5:	75 29                	jne    80104f10 <memset+0x40>
    c &= 0xFF;
80104ee7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104eea:	c1 e0 18             	shl    $0x18,%eax
80104eed:	89 fb                	mov    %edi,%ebx
80104eef:	c1 e9 02             	shr    $0x2,%ecx
80104ef2:	c1 e3 10             	shl    $0x10,%ebx
80104ef5:	09 d8                	or     %ebx,%eax
80104ef7:	09 f8                	or     %edi,%eax
80104ef9:	c1 e7 08             	shl    $0x8,%edi
80104efc:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104efe:	89 d7                	mov    %edx,%edi
80104f00:	fc                   	cld    
80104f01:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104f03:	5b                   	pop    %ebx
80104f04:	89 d0                	mov    %edx,%eax
80104f06:	5f                   	pop    %edi
80104f07:	5d                   	pop    %ebp
80104f08:	c3                   	ret    
80104f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104f10:	89 d7                	mov    %edx,%edi
80104f12:	fc                   	cld    
80104f13:	f3 aa                	rep stos %al,%es:(%edi)
80104f15:	5b                   	pop    %ebx
80104f16:	89 d0                	mov    %edx,%eax
80104f18:	5f                   	pop    %edi
80104f19:	5d                   	pop    %ebp
80104f1a:	c3                   	ret    
80104f1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f1f:	90                   	nop

80104f20 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	56                   	push   %esi
80104f24:	8b 75 10             	mov    0x10(%ebp),%esi
80104f27:	8b 55 08             	mov    0x8(%ebp),%edx
80104f2a:	53                   	push   %ebx
80104f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104f2e:	85 f6                	test   %esi,%esi
80104f30:	74 2e                	je     80104f60 <memcmp+0x40>
80104f32:	01 c6                	add    %eax,%esi
80104f34:	eb 14                	jmp    80104f4a <memcmp+0x2a>
80104f36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104f40:	83 c0 01             	add    $0x1,%eax
80104f43:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104f46:	39 f0                	cmp    %esi,%eax
80104f48:	74 16                	je     80104f60 <memcmp+0x40>
    if(*s1 != *s2)
80104f4a:	0f b6 0a             	movzbl (%edx),%ecx
80104f4d:	0f b6 18             	movzbl (%eax),%ebx
80104f50:	38 d9                	cmp    %bl,%cl
80104f52:	74 ec                	je     80104f40 <memcmp+0x20>
      return *s1 - *s2;
80104f54:	0f b6 c1             	movzbl %cl,%eax
80104f57:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104f59:	5b                   	pop    %ebx
80104f5a:	5e                   	pop    %esi
80104f5b:	5d                   	pop    %ebp
80104f5c:	c3                   	ret    
80104f5d:	8d 76 00             	lea    0x0(%esi),%esi
80104f60:	5b                   	pop    %ebx
  return 0;
80104f61:	31 c0                	xor    %eax,%eax
}
80104f63:	5e                   	pop    %esi
80104f64:	5d                   	pop    %ebp
80104f65:	c3                   	ret    
80104f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f6d:	8d 76 00             	lea    0x0(%esi),%esi

80104f70 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104f70:	55                   	push   %ebp
80104f71:	89 e5                	mov    %esp,%ebp
80104f73:	57                   	push   %edi
80104f74:	8b 55 08             	mov    0x8(%ebp),%edx
80104f77:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104f7a:	56                   	push   %esi
80104f7b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104f7e:	39 d6                	cmp    %edx,%esi
80104f80:	73 26                	jae    80104fa8 <memmove+0x38>
80104f82:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104f85:	39 fa                	cmp    %edi,%edx
80104f87:	73 1f                	jae    80104fa8 <memmove+0x38>
80104f89:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104f8c:	85 c9                	test   %ecx,%ecx
80104f8e:	74 0c                	je     80104f9c <memmove+0x2c>
      *--d = *--s;
80104f90:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104f94:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104f97:	83 e8 01             	sub    $0x1,%eax
80104f9a:	73 f4                	jae    80104f90 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104f9c:	5e                   	pop    %esi
80104f9d:	89 d0                	mov    %edx,%eax
80104f9f:	5f                   	pop    %edi
80104fa0:	5d                   	pop    %ebp
80104fa1:	c3                   	ret    
80104fa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104fa8:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104fab:	89 d7                	mov    %edx,%edi
80104fad:	85 c9                	test   %ecx,%ecx
80104faf:	74 eb                	je     80104f9c <memmove+0x2c>
80104fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104fb8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104fb9:	39 c6                	cmp    %eax,%esi
80104fbb:	75 fb                	jne    80104fb8 <memmove+0x48>
}
80104fbd:	5e                   	pop    %esi
80104fbe:	89 d0                	mov    %edx,%eax
80104fc0:	5f                   	pop    %edi
80104fc1:	5d                   	pop    %ebp
80104fc2:	c3                   	ret    
80104fc3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104fd0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104fd0:	eb 9e                	jmp    80104f70 <memmove>
80104fd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104fe0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104fe0:	55                   	push   %ebp
80104fe1:	89 e5                	mov    %esp,%ebp
80104fe3:	56                   	push   %esi
80104fe4:	8b 75 10             	mov    0x10(%ebp),%esi
80104fe7:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104fea:	53                   	push   %ebx
80104feb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
80104fee:	85 f6                	test   %esi,%esi
80104ff0:	74 2e                	je     80105020 <strncmp+0x40>
80104ff2:	01 d6                	add    %edx,%esi
80104ff4:	eb 18                	jmp    8010500e <strncmp+0x2e>
80104ff6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ffd:	8d 76 00             	lea    0x0(%esi),%esi
80105000:	38 d8                	cmp    %bl,%al
80105002:	75 14                	jne    80105018 <strncmp+0x38>
    n--, p++, q++;
80105004:	83 c2 01             	add    $0x1,%edx
80105007:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010500a:	39 f2                	cmp    %esi,%edx
8010500c:	74 12                	je     80105020 <strncmp+0x40>
8010500e:	0f b6 01             	movzbl (%ecx),%eax
80105011:	0f b6 1a             	movzbl (%edx),%ebx
80105014:	84 c0                	test   %al,%al
80105016:	75 e8                	jne    80105000 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105018:	29 d8                	sub    %ebx,%eax
}
8010501a:	5b                   	pop    %ebx
8010501b:	5e                   	pop    %esi
8010501c:	5d                   	pop    %ebp
8010501d:	c3                   	ret    
8010501e:	66 90                	xchg   %ax,%ax
80105020:	5b                   	pop    %ebx
    return 0;
80105021:	31 c0                	xor    %eax,%eax
}
80105023:	5e                   	pop    %esi
80105024:	5d                   	pop    %ebp
80105025:	c3                   	ret    
80105026:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010502d:	8d 76 00             	lea    0x0(%esi),%esi

80105030 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	57                   	push   %edi
80105034:	56                   	push   %esi
80105035:	8b 75 08             	mov    0x8(%ebp),%esi
80105038:	53                   	push   %ebx
80105039:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010503c:	89 f0                	mov    %esi,%eax
8010503e:	eb 15                	jmp    80105055 <strncpy+0x25>
80105040:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105044:	8b 7d 0c             	mov    0xc(%ebp),%edi
80105047:	83 c0 01             	add    $0x1,%eax
8010504a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
8010504e:	88 50 ff             	mov    %dl,-0x1(%eax)
80105051:	84 d2                	test   %dl,%dl
80105053:	74 09                	je     8010505e <strncpy+0x2e>
80105055:	89 cb                	mov    %ecx,%ebx
80105057:	83 e9 01             	sub    $0x1,%ecx
8010505a:	85 db                	test   %ebx,%ebx
8010505c:	7f e2                	jg     80105040 <strncpy+0x10>
    ;
  while(n-- > 0)
8010505e:	89 c2                	mov    %eax,%edx
80105060:	85 c9                	test   %ecx,%ecx
80105062:	7e 17                	jle    8010507b <strncpy+0x4b>
80105064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105068:	83 c2 01             	add    $0x1,%edx
8010506b:	89 c1                	mov    %eax,%ecx
8010506d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80105071:	29 d1                	sub    %edx,%ecx
80105073:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80105077:	85 c9                	test   %ecx,%ecx
80105079:	7f ed                	jg     80105068 <strncpy+0x38>
  return os;
}
8010507b:	5b                   	pop    %ebx
8010507c:	89 f0                	mov    %esi,%eax
8010507e:	5e                   	pop    %esi
8010507f:	5f                   	pop    %edi
80105080:	5d                   	pop    %ebp
80105081:	c3                   	ret    
80105082:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105090 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105090:	55                   	push   %ebp
80105091:	89 e5                	mov    %esp,%ebp
80105093:	56                   	push   %esi
80105094:	8b 55 10             	mov    0x10(%ebp),%edx
80105097:	8b 75 08             	mov    0x8(%ebp),%esi
8010509a:	53                   	push   %ebx
8010509b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010509e:	85 d2                	test   %edx,%edx
801050a0:	7e 25                	jle    801050c7 <safestrcpy+0x37>
801050a2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801050a6:	89 f2                	mov    %esi,%edx
801050a8:	eb 16                	jmp    801050c0 <safestrcpy+0x30>
801050aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801050b0:	0f b6 08             	movzbl (%eax),%ecx
801050b3:	83 c0 01             	add    $0x1,%eax
801050b6:	83 c2 01             	add    $0x1,%edx
801050b9:	88 4a ff             	mov    %cl,-0x1(%edx)
801050bc:	84 c9                	test   %cl,%cl
801050be:	74 04                	je     801050c4 <safestrcpy+0x34>
801050c0:	39 d8                	cmp    %ebx,%eax
801050c2:	75 ec                	jne    801050b0 <safestrcpy+0x20>
    ;
  *s = 0;
801050c4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801050c7:	89 f0                	mov    %esi,%eax
801050c9:	5b                   	pop    %ebx
801050ca:	5e                   	pop    %esi
801050cb:	5d                   	pop    %ebp
801050cc:	c3                   	ret    
801050cd:	8d 76 00             	lea    0x0(%esi),%esi

801050d0 <strlen>:

int
strlen(const char *s)
{
801050d0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801050d1:	31 c0                	xor    %eax,%eax
{
801050d3:	89 e5                	mov    %esp,%ebp
801050d5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801050d8:	80 3a 00             	cmpb   $0x0,(%edx)
801050db:	74 0c                	je     801050e9 <strlen+0x19>
801050dd:	8d 76 00             	lea    0x0(%esi),%esi
801050e0:	83 c0 01             	add    $0x1,%eax
801050e3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801050e7:	75 f7                	jne    801050e0 <strlen+0x10>
    ;
  return n;
}
801050e9:	5d                   	pop    %ebp
801050ea:	c3                   	ret    

801050eb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801050eb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801050ef:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801050f3:	55                   	push   %ebp
  pushl %ebx
801050f4:	53                   	push   %ebx
  pushl %esi
801050f5:	56                   	push   %esi
  pushl %edi
801050f6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801050f7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801050f9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801050fb:	5f                   	pop    %edi
  popl %esi
801050fc:	5e                   	pop    %esi
  popl %ebx
801050fd:	5b                   	pop    %ebx
  popl %ebp
801050fe:	5d                   	pop    %ebp
  ret
801050ff:	c3                   	ret    

80105100 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	53                   	push   %ebx
80105104:	83 ec 04             	sub    $0x4,%esp
80105107:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010510a:	e8 a1 ed ff ff       	call   80103eb0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010510f:	8b 00                	mov    (%eax),%eax
80105111:	39 d8                	cmp    %ebx,%eax
80105113:	76 1b                	jbe    80105130 <fetchint+0x30>
80105115:	8d 53 04             	lea    0x4(%ebx),%edx
80105118:	39 d0                	cmp    %edx,%eax
8010511a:	72 14                	jb     80105130 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010511c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010511f:	8b 13                	mov    (%ebx),%edx
80105121:	89 10                	mov    %edx,(%eax)
  return 0;
80105123:	31 c0                	xor    %eax,%eax
}
80105125:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105128:	c9                   	leave  
80105129:	c3                   	ret    
8010512a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105130:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105135:	eb ee                	jmp    80105125 <fetchint+0x25>
80105137:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010513e:	66 90                	xchg   %ax,%ax

80105140 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105140:	55                   	push   %ebp
80105141:	89 e5                	mov    %esp,%ebp
80105143:	53                   	push   %ebx
80105144:	83 ec 04             	sub    $0x4,%esp
80105147:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010514a:	e8 61 ed ff ff       	call   80103eb0 <myproc>

  if(addr >= curproc->sz)
8010514f:	39 18                	cmp    %ebx,(%eax)
80105151:	76 2d                	jbe    80105180 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80105153:	8b 55 0c             	mov    0xc(%ebp),%edx
80105156:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105158:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010515a:	39 d3                	cmp    %edx,%ebx
8010515c:	73 22                	jae    80105180 <fetchstr+0x40>
8010515e:	89 d8                	mov    %ebx,%eax
80105160:	eb 0d                	jmp    8010516f <fetchstr+0x2f>
80105162:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105168:	83 c0 01             	add    $0x1,%eax
8010516b:	39 c2                	cmp    %eax,%edx
8010516d:	76 11                	jbe    80105180 <fetchstr+0x40>
    if(*s == 0)
8010516f:	80 38 00             	cmpb   $0x0,(%eax)
80105172:	75 f4                	jne    80105168 <fetchstr+0x28>
      return s - *pp;
80105174:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80105176:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105179:	c9                   	leave  
8010517a:	c3                   	ret    
8010517b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010517f:	90                   	nop
80105180:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105183:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105188:	c9                   	leave  
80105189:	c3                   	ret    
8010518a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105190 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	56                   	push   %esi
80105194:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105195:	e8 16 ed ff ff       	call   80103eb0 <myproc>
8010519a:	8b 55 08             	mov    0x8(%ebp),%edx
8010519d:	8b 40 1c             	mov    0x1c(%eax),%eax
801051a0:	8b 40 44             	mov    0x44(%eax),%eax
801051a3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801051a6:	e8 05 ed ff ff       	call   80103eb0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801051ab:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801051ae:	8b 00                	mov    (%eax),%eax
801051b0:	39 c6                	cmp    %eax,%esi
801051b2:	73 1c                	jae    801051d0 <argint+0x40>
801051b4:	8d 53 08             	lea    0x8(%ebx),%edx
801051b7:	39 d0                	cmp    %edx,%eax
801051b9:	72 15                	jb     801051d0 <argint+0x40>
  *ip = *(int*)(addr);
801051bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801051be:	8b 53 04             	mov    0x4(%ebx),%edx
801051c1:	89 10                	mov    %edx,(%eax)
  return 0;
801051c3:	31 c0                	xor    %eax,%eax
}
801051c5:	5b                   	pop    %ebx
801051c6:	5e                   	pop    %esi
801051c7:	5d                   	pop    %ebp
801051c8:	c3                   	ret    
801051c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801051d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801051d5:	eb ee                	jmp    801051c5 <argint+0x35>
801051d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051de:	66 90                	xchg   %ax,%ax

801051e0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801051e0:	55                   	push   %ebp
801051e1:	89 e5                	mov    %esp,%ebp
801051e3:	57                   	push   %edi
801051e4:	56                   	push   %esi
801051e5:	53                   	push   %ebx
801051e6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
801051e9:	e8 c2 ec ff ff       	call   80103eb0 <myproc>
801051ee:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801051f0:	e8 bb ec ff ff       	call   80103eb0 <myproc>
801051f5:	8b 55 08             	mov    0x8(%ebp),%edx
801051f8:	8b 40 1c             	mov    0x1c(%eax),%eax
801051fb:	8b 40 44             	mov    0x44(%eax),%eax
801051fe:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105201:	e8 aa ec ff ff       	call   80103eb0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105206:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105209:	8b 00                	mov    (%eax),%eax
8010520b:	39 c7                	cmp    %eax,%edi
8010520d:	73 31                	jae    80105240 <argptr+0x60>
8010520f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80105212:	39 c8                	cmp    %ecx,%eax
80105214:	72 2a                	jb     80105240 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105216:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80105219:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
8010521c:	85 d2                	test   %edx,%edx
8010521e:	78 20                	js     80105240 <argptr+0x60>
80105220:	8b 16                	mov    (%esi),%edx
80105222:	39 c2                	cmp    %eax,%edx
80105224:	76 1a                	jbe    80105240 <argptr+0x60>
80105226:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105229:	01 c3                	add    %eax,%ebx
8010522b:	39 da                	cmp    %ebx,%edx
8010522d:	72 11                	jb     80105240 <argptr+0x60>
    return -1;
  *pp = (char*)i;
8010522f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105232:	89 02                	mov    %eax,(%edx)
  return 0;
80105234:	31 c0                	xor    %eax,%eax
}
80105236:	83 c4 0c             	add    $0xc,%esp
80105239:	5b                   	pop    %ebx
8010523a:	5e                   	pop    %esi
8010523b:	5f                   	pop    %edi
8010523c:	5d                   	pop    %ebp
8010523d:	c3                   	ret    
8010523e:	66 90                	xchg   %ax,%ax
    return -1;
80105240:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105245:	eb ef                	jmp    80105236 <argptr+0x56>
80105247:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010524e:	66 90                	xchg   %ax,%ax

80105250 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105250:	55                   	push   %ebp
80105251:	89 e5                	mov    %esp,%ebp
80105253:	56                   	push   %esi
80105254:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105255:	e8 56 ec ff ff       	call   80103eb0 <myproc>
8010525a:	8b 55 08             	mov    0x8(%ebp),%edx
8010525d:	8b 40 1c             	mov    0x1c(%eax),%eax
80105260:	8b 40 44             	mov    0x44(%eax),%eax
80105263:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105266:	e8 45 ec ff ff       	call   80103eb0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010526b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010526e:	8b 00                	mov    (%eax),%eax
80105270:	39 c6                	cmp    %eax,%esi
80105272:	73 44                	jae    801052b8 <argstr+0x68>
80105274:	8d 53 08             	lea    0x8(%ebx),%edx
80105277:	39 d0                	cmp    %edx,%eax
80105279:	72 3d                	jb     801052b8 <argstr+0x68>
  *ip = *(int*)(addr);
8010527b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
8010527e:	e8 2d ec ff ff       	call   80103eb0 <myproc>
  if(addr >= curproc->sz)
80105283:	3b 18                	cmp    (%eax),%ebx
80105285:	73 31                	jae    801052b8 <argstr+0x68>
  *pp = (char*)addr;
80105287:	8b 55 0c             	mov    0xc(%ebp),%edx
8010528a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010528c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010528e:	39 d3                	cmp    %edx,%ebx
80105290:	73 26                	jae    801052b8 <argstr+0x68>
80105292:	89 d8                	mov    %ebx,%eax
80105294:	eb 11                	jmp    801052a7 <argstr+0x57>
80105296:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010529d:	8d 76 00             	lea    0x0(%esi),%esi
801052a0:	83 c0 01             	add    $0x1,%eax
801052a3:	39 c2                	cmp    %eax,%edx
801052a5:	76 11                	jbe    801052b8 <argstr+0x68>
    if(*s == 0)
801052a7:	80 38 00             	cmpb   $0x0,(%eax)
801052aa:	75 f4                	jne    801052a0 <argstr+0x50>
      return s - *pp;
801052ac:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
801052ae:	5b                   	pop    %ebx
801052af:	5e                   	pop    %esi
801052b0:	5d                   	pop    %ebp
801052b1:	c3                   	ret    
801052b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801052b8:	5b                   	pop    %ebx
    return -1;
801052b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052be:	5e                   	pop    %esi
801052bf:	5d                   	pop    %ebp
801052c0:	c3                   	ret    
801052c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052cf:	90                   	nop

801052d0 <syscall>:
[SYS_getNumFreePages]   sys_getNumFreePages,
};

void
syscall(void)
{
801052d0:	55                   	push   %ebp
801052d1:	89 e5                	mov    %esp,%ebp
801052d3:	53                   	push   %ebx
801052d4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801052d7:	e8 d4 eb ff ff       	call   80103eb0 <myproc>
801052dc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801052de:	8b 40 1c             	mov    0x1c(%eax),%eax
801052e1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801052e4:	8d 50 ff             	lea    -0x1(%eax),%edx
801052e7:	83 fa 16             	cmp    $0x16,%edx
801052ea:	77 24                	ja     80105310 <syscall+0x40>
801052ec:	8b 14 85 20 86 10 80 	mov    -0x7fef79e0(,%eax,4),%edx
801052f3:	85 d2                	test   %edx,%edx
801052f5:	74 19                	je     80105310 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
801052f7:	ff d2                	call   *%edx
801052f9:	89 c2                	mov    %eax,%edx
801052fb:	8b 43 1c             	mov    0x1c(%ebx),%eax
801052fe:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105301:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105304:	c9                   	leave  
80105305:	c3                   	ret    
80105306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010530d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105310:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105311:	8d 43 70             	lea    0x70(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105314:	50                   	push   %eax
80105315:	ff 73 14             	push   0x14(%ebx)
80105318:	68 01 86 10 80       	push   $0x80108601
8010531d:	e8 7e b3 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80105322:	8b 43 1c             	mov    0x1c(%ebx),%eax
80105325:	83 c4 10             	add    $0x10,%esp
80105328:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010532f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105332:	c9                   	leave  
80105333:	c3                   	ret    
80105334:	66 90                	xchg   %ax,%ax
80105336:	66 90                	xchg   %ax,%ax
80105338:	66 90                	xchg   %ax,%ax
8010533a:	66 90                	xchg   %ax,%ax
8010533c:	66 90                	xchg   %ax,%ax
8010533e:	66 90                	xchg   %ax,%ax

80105340 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105340:	55                   	push   %ebp
80105341:	89 e5                	mov    %esp,%ebp
80105343:	57                   	push   %edi
80105344:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105345:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105348:	53                   	push   %ebx
80105349:	83 ec 34             	sub    $0x34,%esp
8010534c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010534f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105352:	57                   	push   %edi
80105353:	50                   	push   %eax
{
80105354:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105357:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010535a:	e8 81 cd ff ff       	call   801020e0 <nameiparent>
8010535f:	83 c4 10             	add    $0x10,%esp
80105362:	85 c0                	test   %eax,%eax
80105364:	0f 84 46 01 00 00    	je     801054b0 <create+0x170>
    return 0;
  ilock(dp);
8010536a:	83 ec 0c             	sub    $0xc,%esp
8010536d:	89 c3                	mov    %eax,%ebx
8010536f:	50                   	push   %eax
80105370:	e8 2b c4 ff ff       	call   801017a0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105375:	83 c4 0c             	add    $0xc,%esp
80105378:	6a 00                	push   $0x0
8010537a:	57                   	push   %edi
8010537b:	53                   	push   %ebx
8010537c:	e8 7f c9 ff ff       	call   80101d00 <dirlookup>
80105381:	83 c4 10             	add    $0x10,%esp
80105384:	89 c6                	mov    %eax,%esi
80105386:	85 c0                	test   %eax,%eax
80105388:	74 56                	je     801053e0 <create+0xa0>
    iunlockput(dp);
8010538a:	83 ec 0c             	sub    $0xc,%esp
8010538d:	53                   	push   %ebx
8010538e:	e8 9d c6 ff ff       	call   80101a30 <iunlockput>
    ilock(ip);
80105393:	89 34 24             	mov    %esi,(%esp)
80105396:	e8 05 c4 ff ff       	call   801017a0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010539b:	83 c4 10             	add    $0x10,%esp
8010539e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801053a3:	75 1b                	jne    801053c0 <create+0x80>
801053a5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801053aa:	75 14                	jne    801053c0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801053ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053af:	89 f0                	mov    %esi,%eax
801053b1:	5b                   	pop    %ebx
801053b2:	5e                   	pop    %esi
801053b3:	5f                   	pop    %edi
801053b4:	5d                   	pop    %ebp
801053b5:	c3                   	ret    
801053b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053bd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801053c0:	83 ec 0c             	sub    $0xc,%esp
801053c3:	56                   	push   %esi
    return 0;
801053c4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
801053c6:	e8 65 c6 ff ff       	call   80101a30 <iunlockput>
    return 0;
801053cb:	83 c4 10             	add    $0x10,%esp
}
801053ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053d1:	89 f0                	mov    %esi,%eax
801053d3:	5b                   	pop    %ebx
801053d4:	5e                   	pop    %esi
801053d5:	5f                   	pop    %edi
801053d6:	5d                   	pop    %ebp
801053d7:	c3                   	ret    
801053d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053df:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
801053e0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801053e4:	83 ec 08             	sub    $0x8,%esp
801053e7:	50                   	push   %eax
801053e8:	ff 33                	push   (%ebx)
801053ea:	e8 41 c2 ff ff       	call   80101630 <ialloc>
801053ef:	83 c4 10             	add    $0x10,%esp
801053f2:	89 c6                	mov    %eax,%esi
801053f4:	85 c0                	test   %eax,%eax
801053f6:	0f 84 cd 00 00 00    	je     801054c9 <create+0x189>
  ilock(ip);
801053fc:	83 ec 0c             	sub    $0xc,%esp
801053ff:	50                   	push   %eax
80105400:	e8 9b c3 ff ff       	call   801017a0 <ilock>
  ip->major = major;
80105405:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105409:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010540d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105411:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105415:	b8 01 00 00 00       	mov    $0x1,%eax
8010541a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010541e:	89 34 24             	mov    %esi,(%esp)
80105421:	e8 ca c2 ff ff       	call   801016f0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105426:	83 c4 10             	add    $0x10,%esp
80105429:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010542e:	74 30                	je     80105460 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105430:	83 ec 04             	sub    $0x4,%esp
80105433:	ff 76 04             	push   0x4(%esi)
80105436:	57                   	push   %edi
80105437:	53                   	push   %ebx
80105438:	e8 c3 cb ff ff       	call   80102000 <dirlink>
8010543d:	83 c4 10             	add    $0x10,%esp
80105440:	85 c0                	test   %eax,%eax
80105442:	78 78                	js     801054bc <create+0x17c>
  iunlockput(dp);
80105444:	83 ec 0c             	sub    $0xc,%esp
80105447:	53                   	push   %ebx
80105448:	e8 e3 c5 ff ff       	call   80101a30 <iunlockput>
  return ip;
8010544d:	83 c4 10             	add    $0x10,%esp
}
80105450:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105453:	89 f0                	mov    %esi,%eax
80105455:	5b                   	pop    %ebx
80105456:	5e                   	pop    %esi
80105457:	5f                   	pop    %edi
80105458:	5d                   	pop    %ebp
80105459:	c3                   	ret    
8010545a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105460:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105463:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105468:	53                   	push   %ebx
80105469:	e8 82 c2 ff ff       	call   801016f0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010546e:	83 c4 0c             	add    $0xc,%esp
80105471:	ff 76 04             	push   0x4(%esi)
80105474:	68 9c 86 10 80       	push   $0x8010869c
80105479:	56                   	push   %esi
8010547a:	e8 81 cb ff ff       	call   80102000 <dirlink>
8010547f:	83 c4 10             	add    $0x10,%esp
80105482:	85 c0                	test   %eax,%eax
80105484:	78 18                	js     8010549e <create+0x15e>
80105486:	83 ec 04             	sub    $0x4,%esp
80105489:	ff 73 04             	push   0x4(%ebx)
8010548c:	68 9b 86 10 80       	push   $0x8010869b
80105491:	56                   	push   %esi
80105492:	e8 69 cb ff ff       	call   80102000 <dirlink>
80105497:	83 c4 10             	add    $0x10,%esp
8010549a:	85 c0                	test   %eax,%eax
8010549c:	79 92                	jns    80105430 <create+0xf0>
      panic("create dots");
8010549e:	83 ec 0c             	sub    $0xc,%esp
801054a1:	68 8f 86 10 80       	push   $0x8010868f
801054a6:	e8 d5 ae ff ff       	call   80100380 <panic>
801054ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054af:	90                   	nop
}
801054b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801054b3:	31 f6                	xor    %esi,%esi
}
801054b5:	5b                   	pop    %ebx
801054b6:	89 f0                	mov    %esi,%eax
801054b8:	5e                   	pop    %esi
801054b9:	5f                   	pop    %edi
801054ba:	5d                   	pop    %ebp
801054bb:	c3                   	ret    
    panic("create: dirlink");
801054bc:	83 ec 0c             	sub    $0xc,%esp
801054bf:	68 9e 86 10 80       	push   $0x8010869e
801054c4:	e8 b7 ae ff ff       	call   80100380 <panic>
    panic("create: ialloc");
801054c9:	83 ec 0c             	sub    $0xc,%esp
801054cc:	68 80 86 10 80       	push   $0x80108680
801054d1:	e8 aa ae ff ff       	call   80100380 <panic>
801054d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054dd:	8d 76 00             	lea    0x0(%esi),%esi

801054e0 <sys_dup>:
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	56                   	push   %esi
801054e4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801054e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801054e8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801054eb:	50                   	push   %eax
801054ec:	6a 00                	push   $0x0
801054ee:	e8 9d fc ff ff       	call   80105190 <argint>
801054f3:	83 c4 10             	add    $0x10,%esp
801054f6:	85 c0                	test   %eax,%eax
801054f8:	78 36                	js     80105530 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801054fa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801054fe:	77 30                	ja     80105530 <sys_dup+0x50>
80105500:	e8 ab e9 ff ff       	call   80103eb0 <myproc>
80105505:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105508:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
8010550c:	85 f6                	test   %esi,%esi
8010550e:	74 20                	je     80105530 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105510:	e8 9b e9 ff ff       	call   80103eb0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105515:	31 db                	xor    %ebx,%ebx
80105517:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010551e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105520:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
80105524:	85 d2                	test   %edx,%edx
80105526:	74 18                	je     80105540 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105528:	83 c3 01             	add    $0x1,%ebx
8010552b:	83 fb 10             	cmp    $0x10,%ebx
8010552e:	75 f0                	jne    80105520 <sys_dup+0x40>
}
80105530:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105533:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105538:	89 d8                	mov    %ebx,%eax
8010553a:	5b                   	pop    %ebx
8010553b:	5e                   	pop    %esi
8010553c:	5d                   	pop    %ebp
8010553d:	c3                   	ret    
8010553e:	66 90                	xchg   %ax,%ax
  filedup(f);
80105540:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105543:	89 74 98 2c          	mov    %esi,0x2c(%eax,%ebx,4)
  filedup(f);
80105547:	56                   	push   %esi
80105548:	e8 63 b9 ff ff       	call   80100eb0 <filedup>
  return fd;
8010554d:	83 c4 10             	add    $0x10,%esp
}
80105550:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105553:	89 d8                	mov    %ebx,%eax
80105555:	5b                   	pop    %ebx
80105556:	5e                   	pop    %esi
80105557:	5d                   	pop    %ebp
80105558:	c3                   	ret    
80105559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105560 <sys_read>:
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	56                   	push   %esi
80105564:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105565:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105568:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010556b:	53                   	push   %ebx
8010556c:	6a 00                	push   $0x0
8010556e:	e8 1d fc ff ff       	call   80105190 <argint>
80105573:	83 c4 10             	add    $0x10,%esp
80105576:	85 c0                	test   %eax,%eax
80105578:	78 5e                	js     801055d8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010557a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010557e:	77 58                	ja     801055d8 <sys_read+0x78>
80105580:	e8 2b e9 ff ff       	call   80103eb0 <myproc>
80105585:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105588:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
8010558c:	85 f6                	test   %esi,%esi
8010558e:	74 48                	je     801055d8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105590:	83 ec 08             	sub    $0x8,%esp
80105593:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105596:	50                   	push   %eax
80105597:	6a 02                	push   $0x2
80105599:	e8 f2 fb ff ff       	call   80105190 <argint>
8010559e:	83 c4 10             	add    $0x10,%esp
801055a1:	85 c0                	test   %eax,%eax
801055a3:	78 33                	js     801055d8 <sys_read+0x78>
801055a5:	83 ec 04             	sub    $0x4,%esp
801055a8:	ff 75 f0             	push   -0x10(%ebp)
801055ab:	53                   	push   %ebx
801055ac:	6a 01                	push   $0x1
801055ae:	e8 2d fc ff ff       	call   801051e0 <argptr>
801055b3:	83 c4 10             	add    $0x10,%esp
801055b6:	85 c0                	test   %eax,%eax
801055b8:	78 1e                	js     801055d8 <sys_read+0x78>
  return fileread(f, p, n);
801055ba:	83 ec 04             	sub    $0x4,%esp
801055bd:	ff 75 f0             	push   -0x10(%ebp)
801055c0:	ff 75 f4             	push   -0xc(%ebp)
801055c3:	56                   	push   %esi
801055c4:	e8 67 ba ff ff       	call   80101030 <fileread>
801055c9:	83 c4 10             	add    $0x10,%esp
}
801055cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055cf:	5b                   	pop    %ebx
801055d0:	5e                   	pop    %esi
801055d1:	5d                   	pop    %ebp
801055d2:	c3                   	ret    
801055d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055d7:	90                   	nop
    return -1;
801055d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055dd:	eb ed                	jmp    801055cc <sys_read+0x6c>
801055df:	90                   	nop

801055e0 <sys_write>:
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	56                   	push   %esi
801055e4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801055e5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801055e8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801055eb:	53                   	push   %ebx
801055ec:	6a 00                	push   $0x0
801055ee:	e8 9d fb ff ff       	call   80105190 <argint>
801055f3:	83 c4 10             	add    $0x10,%esp
801055f6:	85 c0                	test   %eax,%eax
801055f8:	78 5e                	js     80105658 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801055fa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801055fe:	77 58                	ja     80105658 <sys_write+0x78>
80105600:	e8 ab e8 ff ff       	call   80103eb0 <myproc>
80105605:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105608:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
8010560c:	85 f6                	test   %esi,%esi
8010560e:	74 48                	je     80105658 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105610:	83 ec 08             	sub    $0x8,%esp
80105613:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105616:	50                   	push   %eax
80105617:	6a 02                	push   $0x2
80105619:	e8 72 fb ff ff       	call   80105190 <argint>
8010561e:	83 c4 10             	add    $0x10,%esp
80105621:	85 c0                	test   %eax,%eax
80105623:	78 33                	js     80105658 <sys_write+0x78>
80105625:	83 ec 04             	sub    $0x4,%esp
80105628:	ff 75 f0             	push   -0x10(%ebp)
8010562b:	53                   	push   %ebx
8010562c:	6a 01                	push   $0x1
8010562e:	e8 ad fb ff ff       	call   801051e0 <argptr>
80105633:	83 c4 10             	add    $0x10,%esp
80105636:	85 c0                	test   %eax,%eax
80105638:	78 1e                	js     80105658 <sys_write+0x78>
  return filewrite(f, p, n);
8010563a:	83 ec 04             	sub    $0x4,%esp
8010563d:	ff 75 f0             	push   -0x10(%ebp)
80105640:	ff 75 f4             	push   -0xc(%ebp)
80105643:	56                   	push   %esi
80105644:	e8 77 ba ff ff       	call   801010c0 <filewrite>
80105649:	83 c4 10             	add    $0x10,%esp
}
8010564c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010564f:	5b                   	pop    %ebx
80105650:	5e                   	pop    %esi
80105651:	5d                   	pop    %ebp
80105652:	c3                   	ret    
80105653:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105657:	90                   	nop
    return -1;
80105658:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010565d:	eb ed                	jmp    8010564c <sys_write+0x6c>
8010565f:	90                   	nop

80105660 <sys_close>:
{
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
80105663:	56                   	push   %esi
80105664:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105665:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105668:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010566b:	50                   	push   %eax
8010566c:	6a 00                	push   $0x0
8010566e:	e8 1d fb ff ff       	call   80105190 <argint>
80105673:	83 c4 10             	add    $0x10,%esp
80105676:	85 c0                	test   %eax,%eax
80105678:	78 3e                	js     801056b8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010567a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010567e:	77 38                	ja     801056b8 <sys_close+0x58>
80105680:	e8 2b e8 ff ff       	call   80103eb0 <myproc>
80105685:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105688:	8d 5a 08             	lea    0x8(%edx),%ebx
8010568b:	8b 74 98 0c          	mov    0xc(%eax,%ebx,4),%esi
8010568f:	85 f6                	test   %esi,%esi
80105691:	74 25                	je     801056b8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105693:	e8 18 e8 ff ff       	call   80103eb0 <myproc>
  fileclose(f);
80105698:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010569b:	c7 44 98 0c 00 00 00 	movl   $0x0,0xc(%eax,%ebx,4)
801056a2:	00 
  fileclose(f);
801056a3:	56                   	push   %esi
801056a4:	e8 57 b8 ff ff       	call   80100f00 <fileclose>
  return 0;
801056a9:	83 c4 10             	add    $0x10,%esp
801056ac:	31 c0                	xor    %eax,%eax
}
801056ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801056b1:	5b                   	pop    %ebx
801056b2:	5e                   	pop    %esi
801056b3:	5d                   	pop    %ebp
801056b4:	c3                   	ret    
801056b5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801056b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056bd:	eb ef                	jmp    801056ae <sys_close+0x4e>
801056bf:	90                   	nop

801056c0 <sys_fstat>:
{
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
801056c3:	56                   	push   %esi
801056c4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801056c5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801056c8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801056cb:	53                   	push   %ebx
801056cc:	6a 00                	push   $0x0
801056ce:	e8 bd fa ff ff       	call   80105190 <argint>
801056d3:	83 c4 10             	add    $0x10,%esp
801056d6:	85 c0                	test   %eax,%eax
801056d8:	78 46                	js     80105720 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801056da:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801056de:	77 40                	ja     80105720 <sys_fstat+0x60>
801056e0:	e8 cb e7 ff ff       	call   80103eb0 <myproc>
801056e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801056e8:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
801056ec:	85 f6                	test   %esi,%esi
801056ee:	74 30                	je     80105720 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801056f0:	83 ec 04             	sub    $0x4,%esp
801056f3:	6a 14                	push   $0x14
801056f5:	53                   	push   %ebx
801056f6:	6a 01                	push   $0x1
801056f8:	e8 e3 fa ff ff       	call   801051e0 <argptr>
801056fd:	83 c4 10             	add    $0x10,%esp
80105700:	85 c0                	test   %eax,%eax
80105702:	78 1c                	js     80105720 <sys_fstat+0x60>
  return filestat(f, st);
80105704:	83 ec 08             	sub    $0x8,%esp
80105707:	ff 75 f4             	push   -0xc(%ebp)
8010570a:	56                   	push   %esi
8010570b:	e8 d0 b8 ff ff       	call   80100fe0 <filestat>
80105710:	83 c4 10             	add    $0x10,%esp
}
80105713:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105716:	5b                   	pop    %ebx
80105717:	5e                   	pop    %esi
80105718:	5d                   	pop    %ebp
80105719:	c3                   	ret    
8010571a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105720:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105725:	eb ec                	jmp    80105713 <sys_fstat+0x53>
80105727:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010572e:	66 90                	xchg   %ax,%ax

80105730 <sys_link>:
{
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	57                   	push   %edi
80105734:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105735:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105738:	53                   	push   %ebx
80105739:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010573c:	50                   	push   %eax
8010573d:	6a 00                	push   $0x0
8010573f:	e8 0c fb ff ff       	call   80105250 <argstr>
80105744:	83 c4 10             	add    $0x10,%esp
80105747:	85 c0                	test   %eax,%eax
80105749:	0f 88 fb 00 00 00    	js     8010584a <sys_link+0x11a>
8010574f:	83 ec 08             	sub    $0x8,%esp
80105752:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105755:	50                   	push   %eax
80105756:	6a 01                	push   $0x1
80105758:	e8 f3 fa ff ff       	call   80105250 <argstr>
8010575d:	83 c4 10             	add    $0x10,%esp
80105760:	85 c0                	test   %eax,%eax
80105762:	0f 88 e2 00 00 00    	js     8010584a <sys_link+0x11a>
  begin_op();
80105768:	e8 33 db ff ff       	call   801032a0 <begin_op>
  if((ip = namei(old)) == 0){
8010576d:	83 ec 0c             	sub    $0xc,%esp
80105770:	ff 75 d4             	push   -0x2c(%ebp)
80105773:	e8 48 c9 ff ff       	call   801020c0 <namei>
80105778:	83 c4 10             	add    $0x10,%esp
8010577b:	89 c3                	mov    %eax,%ebx
8010577d:	85 c0                	test   %eax,%eax
8010577f:	0f 84 e4 00 00 00    	je     80105869 <sys_link+0x139>
  ilock(ip);
80105785:	83 ec 0c             	sub    $0xc,%esp
80105788:	50                   	push   %eax
80105789:	e8 12 c0 ff ff       	call   801017a0 <ilock>
  if(ip->type == T_DIR){
8010578e:	83 c4 10             	add    $0x10,%esp
80105791:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105796:	0f 84 b5 00 00 00    	je     80105851 <sys_link+0x121>
  iupdate(ip);
8010579c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010579f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801057a4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801057a7:	53                   	push   %ebx
801057a8:	e8 43 bf ff ff       	call   801016f0 <iupdate>
  iunlock(ip);
801057ad:	89 1c 24             	mov    %ebx,(%esp)
801057b0:	e8 cb c0 ff ff       	call   80101880 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801057b5:	58                   	pop    %eax
801057b6:	5a                   	pop    %edx
801057b7:	57                   	push   %edi
801057b8:	ff 75 d0             	push   -0x30(%ebp)
801057bb:	e8 20 c9 ff ff       	call   801020e0 <nameiparent>
801057c0:	83 c4 10             	add    $0x10,%esp
801057c3:	89 c6                	mov    %eax,%esi
801057c5:	85 c0                	test   %eax,%eax
801057c7:	74 5b                	je     80105824 <sys_link+0xf4>
  ilock(dp);
801057c9:	83 ec 0c             	sub    $0xc,%esp
801057cc:	50                   	push   %eax
801057cd:	e8 ce bf ff ff       	call   801017a0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801057d2:	8b 03                	mov    (%ebx),%eax
801057d4:	83 c4 10             	add    $0x10,%esp
801057d7:	39 06                	cmp    %eax,(%esi)
801057d9:	75 3d                	jne    80105818 <sys_link+0xe8>
801057db:	83 ec 04             	sub    $0x4,%esp
801057de:	ff 73 04             	push   0x4(%ebx)
801057e1:	57                   	push   %edi
801057e2:	56                   	push   %esi
801057e3:	e8 18 c8 ff ff       	call   80102000 <dirlink>
801057e8:	83 c4 10             	add    $0x10,%esp
801057eb:	85 c0                	test   %eax,%eax
801057ed:	78 29                	js     80105818 <sys_link+0xe8>
  iunlockput(dp);
801057ef:	83 ec 0c             	sub    $0xc,%esp
801057f2:	56                   	push   %esi
801057f3:	e8 38 c2 ff ff       	call   80101a30 <iunlockput>
  iput(ip);
801057f8:	89 1c 24             	mov    %ebx,(%esp)
801057fb:	e8 d0 c0 ff ff       	call   801018d0 <iput>
  end_op();
80105800:	e8 0b db ff ff       	call   80103310 <end_op>
  return 0;
80105805:	83 c4 10             	add    $0x10,%esp
80105808:	31 c0                	xor    %eax,%eax
}
8010580a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010580d:	5b                   	pop    %ebx
8010580e:	5e                   	pop    %esi
8010580f:	5f                   	pop    %edi
80105810:	5d                   	pop    %ebp
80105811:	c3                   	ret    
80105812:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105818:	83 ec 0c             	sub    $0xc,%esp
8010581b:	56                   	push   %esi
8010581c:	e8 0f c2 ff ff       	call   80101a30 <iunlockput>
    goto bad;
80105821:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105824:	83 ec 0c             	sub    $0xc,%esp
80105827:	53                   	push   %ebx
80105828:	e8 73 bf ff ff       	call   801017a0 <ilock>
  ip->nlink--;
8010582d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105832:	89 1c 24             	mov    %ebx,(%esp)
80105835:	e8 b6 be ff ff       	call   801016f0 <iupdate>
  iunlockput(ip);
8010583a:	89 1c 24             	mov    %ebx,(%esp)
8010583d:	e8 ee c1 ff ff       	call   80101a30 <iunlockput>
  end_op();
80105842:	e8 c9 da ff ff       	call   80103310 <end_op>
  return -1;
80105847:	83 c4 10             	add    $0x10,%esp
8010584a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010584f:	eb b9                	jmp    8010580a <sys_link+0xda>
    iunlockput(ip);
80105851:	83 ec 0c             	sub    $0xc,%esp
80105854:	53                   	push   %ebx
80105855:	e8 d6 c1 ff ff       	call   80101a30 <iunlockput>
    end_op();
8010585a:	e8 b1 da ff ff       	call   80103310 <end_op>
    return -1;
8010585f:	83 c4 10             	add    $0x10,%esp
80105862:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105867:	eb a1                	jmp    8010580a <sys_link+0xda>
    end_op();
80105869:	e8 a2 da ff ff       	call   80103310 <end_op>
    return -1;
8010586e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105873:	eb 95                	jmp    8010580a <sys_link+0xda>
80105875:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010587c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105880 <sys_unlink>:
{
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	57                   	push   %edi
80105884:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105885:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105888:	53                   	push   %ebx
80105889:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010588c:	50                   	push   %eax
8010588d:	6a 00                	push   $0x0
8010588f:	e8 bc f9 ff ff       	call   80105250 <argstr>
80105894:	83 c4 10             	add    $0x10,%esp
80105897:	85 c0                	test   %eax,%eax
80105899:	0f 88 7a 01 00 00    	js     80105a19 <sys_unlink+0x199>
  begin_op();
8010589f:	e8 fc d9 ff ff       	call   801032a0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801058a4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801058a7:	83 ec 08             	sub    $0x8,%esp
801058aa:	53                   	push   %ebx
801058ab:	ff 75 c0             	push   -0x40(%ebp)
801058ae:	e8 2d c8 ff ff       	call   801020e0 <nameiparent>
801058b3:	83 c4 10             	add    $0x10,%esp
801058b6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801058b9:	85 c0                	test   %eax,%eax
801058bb:	0f 84 62 01 00 00    	je     80105a23 <sys_unlink+0x1a3>
  ilock(dp);
801058c1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801058c4:	83 ec 0c             	sub    $0xc,%esp
801058c7:	57                   	push   %edi
801058c8:	e8 d3 be ff ff       	call   801017a0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801058cd:	58                   	pop    %eax
801058ce:	5a                   	pop    %edx
801058cf:	68 9c 86 10 80       	push   $0x8010869c
801058d4:	53                   	push   %ebx
801058d5:	e8 06 c4 ff ff       	call   80101ce0 <namecmp>
801058da:	83 c4 10             	add    $0x10,%esp
801058dd:	85 c0                	test   %eax,%eax
801058df:	0f 84 fb 00 00 00    	je     801059e0 <sys_unlink+0x160>
801058e5:	83 ec 08             	sub    $0x8,%esp
801058e8:	68 9b 86 10 80       	push   $0x8010869b
801058ed:	53                   	push   %ebx
801058ee:	e8 ed c3 ff ff       	call   80101ce0 <namecmp>
801058f3:	83 c4 10             	add    $0x10,%esp
801058f6:	85 c0                	test   %eax,%eax
801058f8:	0f 84 e2 00 00 00    	je     801059e0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801058fe:	83 ec 04             	sub    $0x4,%esp
80105901:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105904:	50                   	push   %eax
80105905:	53                   	push   %ebx
80105906:	57                   	push   %edi
80105907:	e8 f4 c3 ff ff       	call   80101d00 <dirlookup>
8010590c:	83 c4 10             	add    $0x10,%esp
8010590f:	89 c3                	mov    %eax,%ebx
80105911:	85 c0                	test   %eax,%eax
80105913:	0f 84 c7 00 00 00    	je     801059e0 <sys_unlink+0x160>
  ilock(ip);
80105919:	83 ec 0c             	sub    $0xc,%esp
8010591c:	50                   	push   %eax
8010591d:	e8 7e be ff ff       	call   801017a0 <ilock>
  if(ip->nlink < 1)
80105922:	83 c4 10             	add    $0x10,%esp
80105925:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010592a:	0f 8e 1c 01 00 00    	jle    80105a4c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105930:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105935:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105938:	74 66                	je     801059a0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010593a:	83 ec 04             	sub    $0x4,%esp
8010593d:	6a 10                	push   $0x10
8010593f:	6a 00                	push   $0x0
80105941:	57                   	push   %edi
80105942:	e8 89 f5 ff ff       	call   80104ed0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105947:	6a 10                	push   $0x10
80105949:	ff 75 c4             	push   -0x3c(%ebp)
8010594c:	57                   	push   %edi
8010594d:	ff 75 b4             	push   -0x4c(%ebp)
80105950:	e8 5b c2 ff ff       	call   80101bb0 <writei>
80105955:	83 c4 20             	add    $0x20,%esp
80105958:	83 f8 10             	cmp    $0x10,%eax
8010595b:	0f 85 de 00 00 00    	jne    80105a3f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105961:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105966:	0f 84 94 00 00 00    	je     80105a00 <sys_unlink+0x180>
  iunlockput(dp);
8010596c:	83 ec 0c             	sub    $0xc,%esp
8010596f:	ff 75 b4             	push   -0x4c(%ebp)
80105972:	e8 b9 c0 ff ff       	call   80101a30 <iunlockput>
  ip->nlink--;
80105977:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010597c:	89 1c 24             	mov    %ebx,(%esp)
8010597f:	e8 6c bd ff ff       	call   801016f0 <iupdate>
  iunlockput(ip);
80105984:	89 1c 24             	mov    %ebx,(%esp)
80105987:	e8 a4 c0 ff ff       	call   80101a30 <iunlockput>
  end_op();
8010598c:	e8 7f d9 ff ff       	call   80103310 <end_op>
  return 0;
80105991:	83 c4 10             	add    $0x10,%esp
80105994:	31 c0                	xor    %eax,%eax
}
80105996:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105999:	5b                   	pop    %ebx
8010599a:	5e                   	pop    %esi
8010599b:	5f                   	pop    %edi
8010599c:	5d                   	pop    %ebp
8010599d:	c3                   	ret    
8010599e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801059a0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801059a4:	76 94                	jbe    8010593a <sys_unlink+0xba>
801059a6:	be 20 00 00 00       	mov    $0x20,%esi
801059ab:	eb 0b                	jmp    801059b8 <sys_unlink+0x138>
801059ad:	8d 76 00             	lea    0x0(%esi),%esi
801059b0:	83 c6 10             	add    $0x10,%esi
801059b3:	3b 73 58             	cmp    0x58(%ebx),%esi
801059b6:	73 82                	jae    8010593a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801059b8:	6a 10                	push   $0x10
801059ba:	56                   	push   %esi
801059bb:	57                   	push   %edi
801059bc:	53                   	push   %ebx
801059bd:	e8 ee c0 ff ff       	call   80101ab0 <readi>
801059c2:	83 c4 10             	add    $0x10,%esp
801059c5:	83 f8 10             	cmp    $0x10,%eax
801059c8:	75 68                	jne    80105a32 <sys_unlink+0x1b2>
    if(de.inum != 0)
801059ca:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801059cf:	74 df                	je     801059b0 <sys_unlink+0x130>
    iunlockput(ip);
801059d1:	83 ec 0c             	sub    $0xc,%esp
801059d4:	53                   	push   %ebx
801059d5:	e8 56 c0 ff ff       	call   80101a30 <iunlockput>
    goto bad;
801059da:	83 c4 10             	add    $0x10,%esp
801059dd:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801059e0:	83 ec 0c             	sub    $0xc,%esp
801059e3:	ff 75 b4             	push   -0x4c(%ebp)
801059e6:	e8 45 c0 ff ff       	call   80101a30 <iunlockput>
  end_op();
801059eb:	e8 20 d9 ff ff       	call   80103310 <end_op>
  return -1;
801059f0:	83 c4 10             	add    $0x10,%esp
801059f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059f8:	eb 9c                	jmp    80105996 <sys_unlink+0x116>
801059fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105a00:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105a03:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105a06:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105a0b:	50                   	push   %eax
80105a0c:	e8 df bc ff ff       	call   801016f0 <iupdate>
80105a11:	83 c4 10             	add    $0x10,%esp
80105a14:	e9 53 ff ff ff       	jmp    8010596c <sys_unlink+0xec>
    return -1;
80105a19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a1e:	e9 73 ff ff ff       	jmp    80105996 <sys_unlink+0x116>
    end_op();
80105a23:	e8 e8 d8 ff ff       	call   80103310 <end_op>
    return -1;
80105a28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a2d:	e9 64 ff ff ff       	jmp    80105996 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105a32:	83 ec 0c             	sub    $0xc,%esp
80105a35:	68 c0 86 10 80       	push   $0x801086c0
80105a3a:	e8 41 a9 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
80105a3f:	83 ec 0c             	sub    $0xc,%esp
80105a42:	68 d2 86 10 80       	push   $0x801086d2
80105a47:	e8 34 a9 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
80105a4c:	83 ec 0c             	sub    $0xc,%esp
80105a4f:	68 ae 86 10 80       	push   $0x801086ae
80105a54:	e8 27 a9 ff ff       	call   80100380 <panic>
80105a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a60 <sys_open>:

int
sys_open(void)
{
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	57                   	push   %edi
80105a64:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105a65:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105a68:	53                   	push   %ebx
80105a69:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105a6c:	50                   	push   %eax
80105a6d:	6a 00                	push   $0x0
80105a6f:	e8 dc f7 ff ff       	call   80105250 <argstr>
80105a74:	83 c4 10             	add    $0x10,%esp
80105a77:	85 c0                	test   %eax,%eax
80105a79:	0f 88 8e 00 00 00    	js     80105b0d <sys_open+0xad>
80105a7f:	83 ec 08             	sub    $0x8,%esp
80105a82:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a85:	50                   	push   %eax
80105a86:	6a 01                	push   $0x1
80105a88:	e8 03 f7 ff ff       	call   80105190 <argint>
80105a8d:	83 c4 10             	add    $0x10,%esp
80105a90:	85 c0                	test   %eax,%eax
80105a92:	78 79                	js     80105b0d <sys_open+0xad>
    return -1;

  begin_op();
80105a94:	e8 07 d8 ff ff       	call   801032a0 <begin_op>

  if(omode & O_CREATE){
80105a99:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105a9d:	75 79                	jne    80105b18 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105a9f:	83 ec 0c             	sub    $0xc,%esp
80105aa2:	ff 75 e0             	push   -0x20(%ebp)
80105aa5:	e8 16 c6 ff ff       	call   801020c0 <namei>
80105aaa:	83 c4 10             	add    $0x10,%esp
80105aad:	89 c6                	mov    %eax,%esi
80105aaf:	85 c0                	test   %eax,%eax
80105ab1:	0f 84 7e 00 00 00    	je     80105b35 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105ab7:	83 ec 0c             	sub    $0xc,%esp
80105aba:	50                   	push   %eax
80105abb:	e8 e0 bc ff ff       	call   801017a0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105ac0:	83 c4 10             	add    $0x10,%esp
80105ac3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105ac8:	0f 84 c2 00 00 00    	je     80105b90 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105ace:	e8 6d b3 ff ff       	call   80100e40 <filealloc>
80105ad3:	89 c7                	mov    %eax,%edi
80105ad5:	85 c0                	test   %eax,%eax
80105ad7:	74 23                	je     80105afc <sys_open+0x9c>
  struct proc *curproc = myproc();
80105ad9:	e8 d2 e3 ff ff       	call   80103eb0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105ade:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105ae0:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
80105ae4:	85 d2                	test   %edx,%edx
80105ae6:	74 60                	je     80105b48 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105ae8:	83 c3 01             	add    $0x1,%ebx
80105aeb:	83 fb 10             	cmp    $0x10,%ebx
80105aee:	75 f0                	jne    80105ae0 <sys_open+0x80>
    if(f)
      fileclose(f);
80105af0:	83 ec 0c             	sub    $0xc,%esp
80105af3:	57                   	push   %edi
80105af4:	e8 07 b4 ff ff       	call   80100f00 <fileclose>
80105af9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105afc:	83 ec 0c             	sub    $0xc,%esp
80105aff:	56                   	push   %esi
80105b00:	e8 2b bf ff ff       	call   80101a30 <iunlockput>
    end_op();
80105b05:	e8 06 d8 ff ff       	call   80103310 <end_op>
    return -1;
80105b0a:	83 c4 10             	add    $0x10,%esp
80105b0d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b12:	eb 6d                	jmp    80105b81 <sys_open+0x121>
80105b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105b18:	83 ec 0c             	sub    $0xc,%esp
80105b1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105b1e:	31 c9                	xor    %ecx,%ecx
80105b20:	ba 02 00 00 00       	mov    $0x2,%edx
80105b25:	6a 00                	push   $0x0
80105b27:	e8 14 f8 ff ff       	call   80105340 <create>
    if(ip == 0){
80105b2c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105b2f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105b31:	85 c0                	test   %eax,%eax
80105b33:	75 99                	jne    80105ace <sys_open+0x6e>
      end_op();
80105b35:	e8 d6 d7 ff ff       	call   80103310 <end_op>
      return -1;
80105b3a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b3f:	eb 40                	jmp    80105b81 <sys_open+0x121>
80105b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105b48:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105b4b:	89 7c 98 2c          	mov    %edi,0x2c(%eax,%ebx,4)
  iunlock(ip);
80105b4f:	56                   	push   %esi
80105b50:	e8 2b bd ff ff       	call   80101880 <iunlock>
  end_op();
80105b55:	e8 b6 d7 ff ff       	call   80103310 <end_op>

  f->type = FD_INODE;
80105b5a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105b60:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b63:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105b66:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105b69:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105b6b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105b72:	f7 d0                	not    %eax
80105b74:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b77:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105b7a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b7d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105b81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b84:	89 d8                	mov    %ebx,%eax
80105b86:	5b                   	pop    %ebx
80105b87:	5e                   	pop    %esi
80105b88:	5f                   	pop    %edi
80105b89:	5d                   	pop    %ebp
80105b8a:	c3                   	ret    
80105b8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b8f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105b90:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105b93:	85 c9                	test   %ecx,%ecx
80105b95:	0f 84 33 ff ff ff    	je     80105ace <sys_open+0x6e>
80105b9b:	e9 5c ff ff ff       	jmp    80105afc <sys_open+0x9c>

80105ba0 <sys_mkdir>:

int
sys_mkdir(void)
{
80105ba0:	55                   	push   %ebp
80105ba1:	89 e5                	mov    %esp,%ebp
80105ba3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105ba6:	e8 f5 d6 ff ff       	call   801032a0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105bab:	83 ec 08             	sub    $0x8,%esp
80105bae:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bb1:	50                   	push   %eax
80105bb2:	6a 00                	push   $0x0
80105bb4:	e8 97 f6 ff ff       	call   80105250 <argstr>
80105bb9:	83 c4 10             	add    $0x10,%esp
80105bbc:	85 c0                	test   %eax,%eax
80105bbe:	78 30                	js     80105bf0 <sys_mkdir+0x50>
80105bc0:	83 ec 0c             	sub    $0xc,%esp
80105bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bc6:	31 c9                	xor    %ecx,%ecx
80105bc8:	ba 01 00 00 00       	mov    $0x1,%edx
80105bcd:	6a 00                	push   $0x0
80105bcf:	e8 6c f7 ff ff       	call   80105340 <create>
80105bd4:	83 c4 10             	add    $0x10,%esp
80105bd7:	85 c0                	test   %eax,%eax
80105bd9:	74 15                	je     80105bf0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105bdb:	83 ec 0c             	sub    $0xc,%esp
80105bde:	50                   	push   %eax
80105bdf:	e8 4c be ff ff       	call   80101a30 <iunlockput>
  end_op();
80105be4:	e8 27 d7 ff ff       	call   80103310 <end_op>
  return 0;
80105be9:	83 c4 10             	add    $0x10,%esp
80105bec:	31 c0                	xor    %eax,%eax
}
80105bee:	c9                   	leave  
80105bef:	c3                   	ret    
    end_op();
80105bf0:	e8 1b d7 ff ff       	call   80103310 <end_op>
    return -1;
80105bf5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bfa:	c9                   	leave  
80105bfb:	c3                   	ret    
80105bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c00 <sys_mknod>:

int
sys_mknod(void)
{
80105c00:	55                   	push   %ebp
80105c01:	89 e5                	mov    %esp,%ebp
80105c03:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105c06:	e8 95 d6 ff ff       	call   801032a0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105c0b:	83 ec 08             	sub    $0x8,%esp
80105c0e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c11:	50                   	push   %eax
80105c12:	6a 00                	push   $0x0
80105c14:	e8 37 f6 ff ff       	call   80105250 <argstr>
80105c19:	83 c4 10             	add    $0x10,%esp
80105c1c:	85 c0                	test   %eax,%eax
80105c1e:	78 60                	js     80105c80 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105c20:	83 ec 08             	sub    $0x8,%esp
80105c23:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c26:	50                   	push   %eax
80105c27:	6a 01                	push   $0x1
80105c29:	e8 62 f5 ff ff       	call   80105190 <argint>
  if((argstr(0, &path)) < 0 ||
80105c2e:	83 c4 10             	add    $0x10,%esp
80105c31:	85 c0                	test   %eax,%eax
80105c33:	78 4b                	js     80105c80 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105c35:	83 ec 08             	sub    $0x8,%esp
80105c38:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c3b:	50                   	push   %eax
80105c3c:	6a 02                	push   $0x2
80105c3e:	e8 4d f5 ff ff       	call   80105190 <argint>
     argint(1, &major) < 0 ||
80105c43:	83 c4 10             	add    $0x10,%esp
80105c46:	85 c0                	test   %eax,%eax
80105c48:	78 36                	js     80105c80 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105c4a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105c4e:	83 ec 0c             	sub    $0xc,%esp
80105c51:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105c55:	ba 03 00 00 00       	mov    $0x3,%edx
80105c5a:	50                   	push   %eax
80105c5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105c5e:	e8 dd f6 ff ff       	call   80105340 <create>
     argint(2, &minor) < 0 ||
80105c63:	83 c4 10             	add    $0x10,%esp
80105c66:	85 c0                	test   %eax,%eax
80105c68:	74 16                	je     80105c80 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105c6a:	83 ec 0c             	sub    $0xc,%esp
80105c6d:	50                   	push   %eax
80105c6e:	e8 bd bd ff ff       	call   80101a30 <iunlockput>
  end_op();
80105c73:	e8 98 d6 ff ff       	call   80103310 <end_op>
  return 0;
80105c78:	83 c4 10             	add    $0x10,%esp
80105c7b:	31 c0                	xor    %eax,%eax
}
80105c7d:	c9                   	leave  
80105c7e:	c3                   	ret    
80105c7f:	90                   	nop
    end_op();
80105c80:	e8 8b d6 ff ff       	call   80103310 <end_op>
    return -1;
80105c85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c8a:	c9                   	leave  
80105c8b:	c3                   	ret    
80105c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c90 <sys_chdir>:

int
sys_chdir(void)
{
80105c90:	55                   	push   %ebp
80105c91:	89 e5                	mov    %esp,%ebp
80105c93:	56                   	push   %esi
80105c94:	53                   	push   %ebx
80105c95:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105c98:	e8 13 e2 ff ff       	call   80103eb0 <myproc>
80105c9d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105c9f:	e8 fc d5 ff ff       	call   801032a0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105ca4:	83 ec 08             	sub    $0x8,%esp
80105ca7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105caa:	50                   	push   %eax
80105cab:	6a 00                	push   $0x0
80105cad:	e8 9e f5 ff ff       	call   80105250 <argstr>
80105cb2:	83 c4 10             	add    $0x10,%esp
80105cb5:	85 c0                	test   %eax,%eax
80105cb7:	78 77                	js     80105d30 <sys_chdir+0xa0>
80105cb9:	83 ec 0c             	sub    $0xc,%esp
80105cbc:	ff 75 f4             	push   -0xc(%ebp)
80105cbf:	e8 fc c3 ff ff       	call   801020c0 <namei>
80105cc4:	83 c4 10             	add    $0x10,%esp
80105cc7:	89 c3                	mov    %eax,%ebx
80105cc9:	85 c0                	test   %eax,%eax
80105ccb:	74 63                	je     80105d30 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105ccd:	83 ec 0c             	sub    $0xc,%esp
80105cd0:	50                   	push   %eax
80105cd1:	e8 ca ba ff ff       	call   801017a0 <ilock>
  if(ip->type != T_DIR){
80105cd6:	83 c4 10             	add    $0x10,%esp
80105cd9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105cde:	75 30                	jne    80105d10 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105ce0:	83 ec 0c             	sub    $0xc,%esp
80105ce3:	53                   	push   %ebx
80105ce4:	e8 97 bb ff ff       	call   80101880 <iunlock>
  iput(curproc->cwd);
80105ce9:	58                   	pop    %eax
80105cea:	ff 76 6c             	push   0x6c(%esi)
80105ced:	e8 de bb ff ff       	call   801018d0 <iput>
  end_op();
80105cf2:	e8 19 d6 ff ff       	call   80103310 <end_op>
  curproc->cwd = ip;
80105cf7:	89 5e 6c             	mov    %ebx,0x6c(%esi)
  return 0;
80105cfa:	83 c4 10             	add    $0x10,%esp
80105cfd:	31 c0                	xor    %eax,%eax
}
80105cff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d02:	5b                   	pop    %ebx
80105d03:	5e                   	pop    %esi
80105d04:	5d                   	pop    %ebp
80105d05:	c3                   	ret    
80105d06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d0d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105d10:	83 ec 0c             	sub    $0xc,%esp
80105d13:	53                   	push   %ebx
80105d14:	e8 17 bd ff ff       	call   80101a30 <iunlockput>
    end_op();
80105d19:	e8 f2 d5 ff ff       	call   80103310 <end_op>
    return -1;
80105d1e:	83 c4 10             	add    $0x10,%esp
80105d21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d26:	eb d7                	jmp    80105cff <sys_chdir+0x6f>
80105d28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d2f:	90                   	nop
    end_op();
80105d30:	e8 db d5 ff ff       	call   80103310 <end_op>
    return -1;
80105d35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d3a:	eb c3                	jmp    80105cff <sys_chdir+0x6f>
80105d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d40 <sys_exec>:

int
sys_exec(void)
{
80105d40:	55                   	push   %ebp
80105d41:	89 e5                	mov    %esp,%ebp
80105d43:	57                   	push   %edi
80105d44:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105d45:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105d4b:	53                   	push   %ebx
80105d4c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105d52:	50                   	push   %eax
80105d53:	6a 00                	push   $0x0
80105d55:	e8 f6 f4 ff ff       	call   80105250 <argstr>
80105d5a:	83 c4 10             	add    $0x10,%esp
80105d5d:	85 c0                	test   %eax,%eax
80105d5f:	0f 88 87 00 00 00    	js     80105dec <sys_exec+0xac>
80105d65:	83 ec 08             	sub    $0x8,%esp
80105d68:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105d6e:	50                   	push   %eax
80105d6f:	6a 01                	push   $0x1
80105d71:	e8 1a f4 ff ff       	call   80105190 <argint>
80105d76:	83 c4 10             	add    $0x10,%esp
80105d79:	85 c0                	test   %eax,%eax
80105d7b:	78 6f                	js     80105dec <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105d7d:	83 ec 04             	sub    $0x4,%esp
80105d80:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105d86:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105d88:	68 80 00 00 00       	push   $0x80
80105d8d:	6a 00                	push   $0x0
80105d8f:	56                   	push   %esi
80105d90:	e8 3b f1 ff ff       	call   80104ed0 <memset>
80105d95:	83 c4 10             	add    $0x10,%esp
80105d98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d9f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105da0:	83 ec 08             	sub    $0x8,%esp
80105da3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105da9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105db0:	50                   	push   %eax
80105db1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105db7:	01 f8                	add    %edi,%eax
80105db9:	50                   	push   %eax
80105dba:	e8 41 f3 ff ff       	call   80105100 <fetchint>
80105dbf:	83 c4 10             	add    $0x10,%esp
80105dc2:	85 c0                	test   %eax,%eax
80105dc4:	78 26                	js     80105dec <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105dc6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105dcc:	85 c0                	test   %eax,%eax
80105dce:	74 30                	je     80105e00 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105dd0:	83 ec 08             	sub    $0x8,%esp
80105dd3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105dd6:	52                   	push   %edx
80105dd7:	50                   	push   %eax
80105dd8:	e8 63 f3 ff ff       	call   80105140 <fetchstr>
80105ddd:	83 c4 10             	add    $0x10,%esp
80105de0:	85 c0                	test   %eax,%eax
80105de2:	78 08                	js     80105dec <sys_exec+0xac>
  for(i=0;; i++){
80105de4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105de7:	83 fb 20             	cmp    $0x20,%ebx
80105dea:	75 b4                	jne    80105da0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105dec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105def:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105df4:	5b                   	pop    %ebx
80105df5:	5e                   	pop    %esi
80105df6:	5f                   	pop    %edi
80105df7:	5d                   	pop    %ebp
80105df8:	c3                   	ret    
80105df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105e00:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105e07:	00 00 00 00 
  return exec(path, argv);
80105e0b:	83 ec 08             	sub    $0x8,%esp
80105e0e:	56                   	push   %esi
80105e0f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105e15:	e8 96 ac ff ff       	call   80100ab0 <exec>
80105e1a:	83 c4 10             	add    $0x10,%esp
}
80105e1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e20:	5b                   	pop    %ebx
80105e21:	5e                   	pop    %esi
80105e22:	5f                   	pop    %edi
80105e23:	5d                   	pop    %ebp
80105e24:	c3                   	ret    
80105e25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e30 <sys_pipe>:

int
sys_pipe(void)
{
80105e30:	55                   	push   %ebp
80105e31:	89 e5                	mov    %esp,%ebp
80105e33:	57                   	push   %edi
80105e34:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e35:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105e38:	53                   	push   %ebx
80105e39:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e3c:	6a 08                	push   $0x8
80105e3e:	50                   	push   %eax
80105e3f:	6a 00                	push   $0x0
80105e41:	e8 9a f3 ff ff       	call   801051e0 <argptr>
80105e46:	83 c4 10             	add    $0x10,%esp
80105e49:	85 c0                	test   %eax,%eax
80105e4b:	78 4a                	js     80105e97 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105e4d:	83 ec 08             	sub    $0x8,%esp
80105e50:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e53:	50                   	push   %eax
80105e54:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105e57:	50                   	push   %eax
80105e58:	e8 13 db ff ff       	call   80103970 <pipealloc>
80105e5d:	83 c4 10             	add    $0x10,%esp
80105e60:	85 c0                	test   %eax,%eax
80105e62:	78 33                	js     80105e97 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105e64:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105e67:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105e69:	e8 42 e0 ff ff       	call   80103eb0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105e6e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105e70:	8b 74 98 2c          	mov    0x2c(%eax,%ebx,4),%esi
80105e74:	85 f6                	test   %esi,%esi
80105e76:	74 28                	je     80105ea0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105e78:	83 c3 01             	add    $0x1,%ebx
80105e7b:	83 fb 10             	cmp    $0x10,%ebx
80105e7e:	75 f0                	jne    80105e70 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105e80:	83 ec 0c             	sub    $0xc,%esp
80105e83:	ff 75 e0             	push   -0x20(%ebp)
80105e86:	e8 75 b0 ff ff       	call   80100f00 <fileclose>
    fileclose(wf);
80105e8b:	58                   	pop    %eax
80105e8c:	ff 75 e4             	push   -0x1c(%ebp)
80105e8f:	e8 6c b0 ff ff       	call   80100f00 <fileclose>
    return -1;
80105e94:	83 c4 10             	add    $0x10,%esp
80105e97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e9c:	eb 53                	jmp    80105ef1 <sys_pipe+0xc1>
80105e9e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105ea0:	8d 73 08             	lea    0x8(%ebx),%esi
80105ea3:	89 7c b0 0c          	mov    %edi,0xc(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ea7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105eaa:	e8 01 e0 ff ff       	call   80103eb0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105eaf:	31 d2                	xor    %edx,%edx
80105eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105eb8:	8b 4c 90 2c          	mov    0x2c(%eax,%edx,4),%ecx
80105ebc:	85 c9                	test   %ecx,%ecx
80105ebe:	74 20                	je     80105ee0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105ec0:	83 c2 01             	add    $0x1,%edx
80105ec3:	83 fa 10             	cmp    $0x10,%edx
80105ec6:	75 f0                	jne    80105eb8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105ec8:	e8 e3 df ff ff       	call   80103eb0 <myproc>
80105ecd:	c7 44 b0 0c 00 00 00 	movl   $0x0,0xc(%eax,%esi,4)
80105ed4:	00 
80105ed5:	eb a9                	jmp    80105e80 <sys_pipe+0x50>
80105ed7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ede:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105ee0:	89 7c 90 2c          	mov    %edi,0x2c(%eax,%edx,4)
  }
  fd[0] = fd0;
80105ee4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105ee7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105ee9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105eec:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105eef:	31 c0                	xor    %eax,%eax
}
80105ef1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ef4:	5b                   	pop    %ebx
80105ef5:	5e                   	pop    %esi
80105ef6:	5f                   	pop    %edi
80105ef7:	5d                   	pop    %ebp
80105ef8:	c3                   	ret    
80105ef9:	66 90                	xchg   %ax,%ax
80105efb:	66 90                	xchg   %ax,%ax
80105efd:	66 90                	xchg   %ax,%ax
80105eff:	90                   	nop

80105f00 <sys_getNumFreePages>:


int
sys_getNumFreePages(void)
{
  return num_of_FreePages();  
80105f00:	e9 fb cc ff ff       	jmp    80102c00 <num_of_FreePages>
80105f05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f10 <sys_getrss>:
}

int 
sys_getrss()
{
80105f10:	55                   	push   %ebp
80105f11:	89 e5                	mov    %esp,%ebp
80105f13:	83 ec 08             	sub    $0x8,%esp
  print_rss();
80105f16:	e8 35 e1 ff ff       	call   80104050 <print_rss>
  return 0;
}
80105f1b:	31 c0                	xor    %eax,%eax
80105f1d:	c9                   	leave  
80105f1e:	c3                   	ret    
80105f1f:	90                   	nop

80105f20 <sys_fork>:

int
sys_fork(void)
{
  return fork();
80105f20:	e9 6b e9 ff ff       	jmp    80104890 <fork>
80105f25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f30 <sys_exit>:
}

int
sys_exit(void)
{
80105f30:	55                   	push   %ebp
80105f31:	89 e5                	mov    %esp,%ebp
80105f33:	83 ec 08             	sub    $0x8,%esp
  exit();
80105f36:	e8 95 ea ff ff       	call   801049d0 <exit>
  return 0;  // not reached
}
80105f3b:	31 c0                	xor    %eax,%eax
80105f3d:	c9                   	leave  
80105f3e:	c3                   	ret    
80105f3f:	90                   	nop

80105f40 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105f40:	e9 db e2 ff ff       	jmp    80104220 <wait>
80105f45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f50 <sys_kill>:
}

int
sys_kill(void)
{
80105f50:	55                   	push   %ebp
80105f51:	89 e5                	mov    %esp,%ebp
80105f53:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105f56:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f59:	50                   	push   %eax
80105f5a:	6a 00                	push   $0x0
80105f5c:	e8 2f f2 ff ff       	call   80105190 <argint>
80105f61:	83 c4 10             	add    $0x10,%esp
80105f64:	85 c0                	test   %eax,%eax
80105f66:	78 18                	js     80105f80 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105f68:	83 ec 0c             	sub    $0xc,%esp
80105f6b:	ff 75 f4             	push   -0xc(%ebp)
80105f6e:	e8 4d e5 ff ff       	call   801044c0 <kill>
80105f73:	83 c4 10             	add    $0x10,%esp
}
80105f76:	c9                   	leave  
80105f77:	c3                   	ret    
80105f78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f7f:	90                   	nop
80105f80:	c9                   	leave  
    return -1;
80105f81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f86:	c3                   	ret    
80105f87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f8e:	66 90                	xchg   %ax,%ax

80105f90 <sys_getpid>:

int
sys_getpid(void)
{
80105f90:	55                   	push   %ebp
80105f91:	89 e5                	mov    %esp,%ebp
80105f93:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105f96:	e8 15 df ff ff       	call   80103eb0 <myproc>
80105f9b:	8b 40 14             	mov    0x14(%eax),%eax
}
80105f9e:	c9                   	leave  
80105f9f:	c3                   	ret    

80105fa0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105fa0:	55                   	push   %ebp
80105fa1:	89 e5                	mov    %esp,%ebp
80105fa3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105fa4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105fa7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105faa:	50                   	push   %eax
80105fab:	6a 00                	push   $0x0
80105fad:	e8 de f1 ff ff       	call   80105190 <argint>
80105fb2:	83 c4 10             	add    $0x10,%esp
80105fb5:	85 c0                	test   %eax,%eax
80105fb7:	78 27                	js     80105fe0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105fb9:	e8 f2 de ff ff       	call   80103eb0 <myproc>
  if(growproc(n) < 0)
80105fbe:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105fc1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105fc3:	ff 75 f4             	push   -0xc(%ebp)
80105fc6:	e8 05 e0 ff ff       	call   80103fd0 <growproc>
80105fcb:	83 c4 10             	add    $0x10,%esp
80105fce:	85 c0                	test   %eax,%eax
80105fd0:	78 0e                	js     80105fe0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105fd2:	89 d8                	mov    %ebx,%eax
80105fd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105fd7:	c9                   	leave  
80105fd8:	c3                   	ret    
80105fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105fe0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105fe5:	eb eb                	jmp    80105fd2 <sys_sbrk+0x32>
80105fe7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fee:	66 90                	xchg   %ax,%ax

80105ff0 <sys_sleep>:

int
sys_sleep(void)
{
80105ff0:	55                   	push   %ebp
80105ff1:	89 e5                	mov    %esp,%ebp
80105ff3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105ff4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ff7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105ffa:	50                   	push   %eax
80105ffb:	6a 00                	push   $0x0
80105ffd:	e8 8e f1 ff ff       	call   80105190 <argint>
80106002:	83 c4 10             	add    $0x10,%esp
80106005:	85 c0                	test   %eax,%eax
80106007:	0f 88 8a 00 00 00    	js     80106097 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010600d:	83 ec 0c             	sub    $0xc,%esp
80106010:	68 c0 8d 11 80       	push   $0x80118dc0
80106015:	e8 f6 ed ff ff       	call   80104e10 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010601a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
8010601d:	8b 1d a0 8d 11 80    	mov    0x80118da0,%ebx
  while(ticks - ticks0 < n){
80106023:	83 c4 10             	add    $0x10,%esp
80106026:	85 d2                	test   %edx,%edx
80106028:	75 27                	jne    80106051 <sys_sleep+0x61>
8010602a:	eb 54                	jmp    80106080 <sys_sleep+0x90>
8010602c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106030:	83 ec 08             	sub    $0x8,%esp
80106033:	68 c0 8d 11 80       	push   $0x80118dc0
80106038:	68 a0 8d 11 80       	push   $0x80118da0
8010603d:	e8 5e e3 ff ff       	call   801043a0 <sleep>
  while(ticks - ticks0 < n){
80106042:	a1 a0 8d 11 80       	mov    0x80118da0,%eax
80106047:	83 c4 10             	add    $0x10,%esp
8010604a:	29 d8                	sub    %ebx,%eax
8010604c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010604f:	73 2f                	jae    80106080 <sys_sleep+0x90>
    if(myproc()->killed){
80106051:	e8 5a de ff ff       	call   80103eb0 <myproc>
80106056:	8b 40 28             	mov    0x28(%eax),%eax
80106059:	85 c0                	test   %eax,%eax
8010605b:	74 d3                	je     80106030 <sys_sleep+0x40>
      release(&tickslock);
8010605d:	83 ec 0c             	sub    $0xc,%esp
80106060:	68 c0 8d 11 80       	push   $0x80118dc0
80106065:	e8 46 ed ff ff       	call   80104db0 <release>
  }
  release(&tickslock);
  return 0;
}
8010606a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010606d:	83 c4 10             	add    $0x10,%esp
80106070:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106075:	c9                   	leave  
80106076:	c3                   	ret    
80106077:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010607e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106080:	83 ec 0c             	sub    $0xc,%esp
80106083:	68 c0 8d 11 80       	push   $0x80118dc0
80106088:	e8 23 ed ff ff       	call   80104db0 <release>
  return 0;
8010608d:	83 c4 10             	add    $0x10,%esp
80106090:	31 c0                	xor    %eax,%eax
}
80106092:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106095:	c9                   	leave  
80106096:	c3                   	ret    
    return -1;
80106097:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010609c:	eb f4                	jmp    80106092 <sys_sleep+0xa2>
8010609e:	66 90                	xchg   %ax,%ax

801060a0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801060a0:	55                   	push   %ebp
801060a1:	89 e5                	mov    %esp,%ebp
801060a3:	53                   	push   %ebx
801060a4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801060a7:	68 c0 8d 11 80       	push   $0x80118dc0
801060ac:	e8 5f ed ff ff       	call   80104e10 <acquire>
  xticks = ticks;
801060b1:	8b 1d a0 8d 11 80    	mov    0x80118da0,%ebx
  release(&tickslock);
801060b7:	c7 04 24 c0 8d 11 80 	movl   $0x80118dc0,(%esp)
801060be:	e8 ed ec ff ff       	call   80104db0 <release>
  return xticks;
}
801060c3:	89 d8                	mov    %ebx,%eax
801060c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801060c8:	c9                   	leave  
801060c9:	c3                   	ret    

801060ca <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801060ca:	1e                   	push   %ds
  pushl %es
801060cb:	06                   	push   %es
  pushl %fs
801060cc:	0f a0                	push   %fs
  pushl %gs
801060ce:	0f a8                	push   %gs
  pushal
801060d0:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801060d1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801060d5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801060d7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801060d9:	54                   	push   %esp
  call trap
801060da:	e8 c1 00 00 00       	call   801061a0 <trap>
  addl $4, %esp
801060df:	83 c4 04             	add    $0x4,%esp

801060e2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801060e2:	61                   	popa   
  popl %gs
801060e3:	0f a9                	pop    %gs
  popl %fs
801060e5:	0f a1                	pop    %fs
  popl %es
801060e7:	07                   	pop    %es
  popl %ds
801060e8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801060e9:	83 c4 08             	add    $0x8,%esp
  iret
801060ec:	cf                   	iret   
801060ed:	66 90                	xchg   %ax,%ax
801060ef:	90                   	nop

801060f0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801060f0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801060f1:	31 c0                	xor    %eax,%eax
{
801060f3:	89 e5                	mov    %esp,%ebp
801060f5:	83 ec 08             	sub    $0x8,%esp
801060f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060ff:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106100:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106107:	c7 04 c5 02 8e 11 80 	movl   $0x8e000008,-0x7fee71fe(,%eax,8)
8010610e:	08 00 00 8e 
80106112:	66 89 14 c5 00 8e 11 	mov    %dx,-0x7fee7200(,%eax,8)
80106119:	80 
8010611a:	c1 ea 10             	shr    $0x10,%edx
8010611d:	66 89 14 c5 06 8e 11 	mov    %dx,-0x7fee71fa(,%eax,8)
80106124:	80 
  for(i = 0; i < 256; i++)
80106125:	83 c0 01             	add    $0x1,%eax
80106128:	3d 00 01 00 00       	cmp    $0x100,%eax
8010612d:	75 d1                	jne    80106100 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010612f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106132:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80106137:	c7 05 02 90 11 80 08 	movl   $0xef000008,0x80119002
8010613e:	00 00 ef 
  initlock(&tickslock, "time");
80106141:	68 e1 86 10 80       	push   $0x801086e1
80106146:	68 c0 8d 11 80       	push   $0x80118dc0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010614b:	66 a3 00 90 11 80    	mov    %ax,0x80119000
80106151:	c1 e8 10             	shr    $0x10,%eax
80106154:	66 a3 06 90 11 80    	mov    %ax,0x80119006
  initlock(&tickslock, "time");
8010615a:	e8 e1 ea ff ff       	call   80104c40 <initlock>
}
8010615f:	83 c4 10             	add    $0x10,%esp
80106162:	c9                   	leave  
80106163:	c3                   	ret    
80106164:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010616b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010616f:	90                   	nop

80106170 <idtinit>:

void
idtinit(void)
{
80106170:	55                   	push   %ebp
  pd[0] = size-1;
80106171:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106176:	89 e5                	mov    %esp,%ebp
80106178:	83 ec 10             	sub    $0x10,%esp
8010617b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010617f:	b8 00 8e 11 80       	mov    $0x80118e00,%eax
80106184:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106188:	c1 e8 10             	shr    $0x10,%eax
8010618b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010618f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106192:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106195:	c9                   	leave  
80106196:	c3                   	ret    
80106197:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010619e:	66 90                	xchg   %ax,%ax

801061a0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801061a0:	55                   	push   %ebp
801061a1:	89 e5                	mov    %esp,%ebp
801061a3:	57                   	push   %edi
801061a4:	56                   	push   %esi
801061a5:	53                   	push   %ebx
801061a6:	83 ec 1c             	sub    $0x1c,%esp
801061a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801061ac:	8b 43 30             	mov    0x30(%ebx),%eax
801061af:	83 f8 40             	cmp    $0x40,%eax
801061b2:	0f 84 30 01 00 00    	je     801062e8 <trap+0x148>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801061b8:	83 e8 0e             	sub    $0xe,%eax
801061bb:	83 f8 31             	cmp    $0x31,%eax
801061be:	0f 87 8c 00 00 00    	ja     80106250 <trap+0xb0>
801061c4:	ff 24 85 88 87 10 80 	jmp    *-0x7fef7878(,%eax,4)
801061cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061cf:	90                   	nop
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
801061d0:	e8 bb dc ff ff       	call   80103e90 <cpuid>
801061d5:	85 c0                	test   %eax,%eax
801061d7:	0f 84 13 02 00 00    	je     801063f0 <trap+0x250>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
801061dd:	e8 6e cc ff ff       	call   80102e50 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061e2:	e8 c9 dc ff ff       	call   80103eb0 <myproc>
801061e7:	85 c0                	test   %eax,%eax
801061e9:	74 1d                	je     80106208 <trap+0x68>
801061eb:	e8 c0 dc ff ff       	call   80103eb0 <myproc>
801061f0:	8b 50 28             	mov    0x28(%eax),%edx
801061f3:	85 d2                	test   %edx,%edx
801061f5:	74 11                	je     80106208 <trap+0x68>
801061f7:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801061fb:	83 e0 03             	and    $0x3,%eax
801061fe:	66 83 f8 03          	cmp    $0x3,%ax
80106202:	0f 84 c8 01 00 00    	je     801063d0 <trap+0x230>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106208:	e8 a3 dc ff ff       	call   80103eb0 <myproc>
8010620d:	85 c0                	test   %eax,%eax
8010620f:	74 0f                	je     80106220 <trap+0x80>
80106211:	e8 9a dc ff ff       	call   80103eb0 <myproc>
80106216:	83 78 10 04          	cmpl   $0x4,0x10(%eax)
8010621a:	0f 84 b0 00 00 00    	je     801062d0 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106220:	e8 8b dc ff ff       	call   80103eb0 <myproc>
80106225:	85 c0                	test   %eax,%eax
80106227:	74 1d                	je     80106246 <trap+0xa6>
80106229:	e8 82 dc ff ff       	call   80103eb0 <myproc>
8010622e:	8b 40 28             	mov    0x28(%eax),%eax
80106231:	85 c0                	test   %eax,%eax
80106233:	74 11                	je     80106246 <trap+0xa6>
80106235:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106239:	83 e0 03             	and    $0x3,%eax
8010623c:	66 83 f8 03          	cmp    $0x3,%ax
80106240:	0f 84 cf 00 00 00    	je     80106315 <trap+0x175>
    exit();
}
80106246:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106249:	5b                   	pop    %ebx
8010624a:	5e                   	pop    %esi
8010624b:	5f                   	pop    %edi
8010624c:	5d                   	pop    %ebp
8010624d:	c3                   	ret    
8010624e:	66 90                	xchg   %ax,%ax
    if(myproc() == 0 || (tf->cs&3) == 0){
80106250:	e8 5b dc ff ff       	call   80103eb0 <myproc>
80106255:	8b 7b 38             	mov    0x38(%ebx),%edi
80106258:	85 c0                	test   %eax,%eax
8010625a:	0f 84 c4 01 00 00    	je     80106424 <trap+0x284>
80106260:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106264:	0f 84 ba 01 00 00    	je     80106424 <trap+0x284>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010626a:	0f 20 d1             	mov    %cr2,%ecx
8010626d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106270:	e8 1b dc ff ff       	call   80103e90 <cpuid>
80106275:	8b 73 30             	mov    0x30(%ebx),%esi
80106278:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010627b:	8b 43 34             	mov    0x34(%ebx),%eax
8010627e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80106281:	e8 2a dc ff ff       	call   80103eb0 <myproc>
80106286:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106289:	e8 22 dc ff ff       	call   80103eb0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010628e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106291:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106294:	51                   	push   %ecx
80106295:	57                   	push   %edi
80106296:	52                   	push   %edx
80106297:	ff 75 e4             	push   -0x1c(%ebp)
8010629a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010629b:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010629e:	83 c6 70             	add    $0x70,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801062a1:	56                   	push   %esi
801062a2:	ff 70 14             	push   0x14(%eax)
801062a5:	68 44 87 10 80       	push   $0x80108744
801062aa:	e8 f1 a3 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
801062af:	83 c4 20             	add    $0x20,%esp
801062b2:	e8 f9 db ff ff       	call   80103eb0 <myproc>
801062b7:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062be:	e8 ed db ff ff       	call   80103eb0 <myproc>
801062c3:	85 c0                	test   %eax,%eax
801062c5:	0f 85 20 ff ff ff    	jne    801061eb <trap+0x4b>
801062cb:	e9 38 ff ff ff       	jmp    80106208 <trap+0x68>
  if(myproc() && myproc()->state == RUNNING &&
801062d0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801062d4:	0f 85 46 ff ff ff    	jne    80106220 <trap+0x80>
    yield();
801062da:	e8 71 e0 ff ff       	call   80104350 <yield>
801062df:	e9 3c ff ff ff       	jmp    80106220 <trap+0x80>
801062e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
801062e8:	e8 c3 db ff ff       	call   80103eb0 <myproc>
801062ed:	8b 70 28             	mov    0x28(%eax),%esi
801062f0:	85 f6                	test   %esi,%esi
801062f2:	0f 85 e8 00 00 00    	jne    801063e0 <trap+0x240>
    myproc()->tf = tf;
801062f8:	e8 b3 db ff ff       	call   80103eb0 <myproc>
801062fd:	89 58 1c             	mov    %ebx,0x1c(%eax)
    syscall();
80106300:	e8 cb ef ff ff       	call   801052d0 <syscall>
    if(myproc()->killed)
80106305:	e8 a6 db ff ff       	call   80103eb0 <myproc>
8010630a:	8b 48 28             	mov    0x28(%eax),%ecx
8010630d:	85 c9                	test   %ecx,%ecx
8010630f:	0f 84 31 ff ff ff    	je     80106246 <trap+0xa6>
}
80106315:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106318:	5b                   	pop    %ebx
80106319:	5e                   	pop    %esi
8010631a:	5f                   	pop    %edi
8010631b:	5d                   	pop    %ebp
      exit();
8010631c:	e9 af e6 ff ff       	jmp    801049d0 <exit>
80106321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106328:	8b 7b 38             	mov    0x38(%ebx),%edi
8010632b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
8010632f:	e8 5c db ff ff       	call   80103e90 <cpuid>
80106334:	57                   	push   %edi
80106335:	56                   	push   %esi
80106336:	50                   	push   %eax
80106337:	68 ec 86 10 80       	push   $0x801086ec
8010633c:	e8 5f a3 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80106341:	e8 0a cb ff ff       	call   80102e50 <lapiceoi>
    break;
80106346:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106349:	e8 62 db ff ff       	call   80103eb0 <myproc>
8010634e:	85 c0                	test   %eax,%eax
80106350:	0f 85 95 fe ff ff    	jne    801061eb <trap+0x4b>
80106356:	e9 ad fe ff ff       	jmp    80106208 <trap+0x68>
8010635b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010635f:	90                   	nop
    kbdintr();
80106360:	e8 ab c9 ff ff       	call   80102d10 <kbdintr>
    lapiceoi();
80106365:	e8 e6 ca ff ff       	call   80102e50 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010636a:	e8 41 db ff ff       	call   80103eb0 <myproc>
8010636f:	85 c0                	test   %eax,%eax
80106371:	0f 85 74 fe ff ff    	jne    801061eb <trap+0x4b>
80106377:	e9 8c fe ff ff       	jmp    80106208 <trap+0x68>
8010637c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106380:	e8 3b 02 00 00       	call   801065c0 <uartintr>
    lapiceoi();
80106385:	e8 c6 ca ff ff       	call   80102e50 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010638a:	e8 21 db ff ff       	call   80103eb0 <myproc>
8010638f:	85 c0                	test   %eax,%eax
80106391:	0f 85 54 fe ff ff    	jne    801061eb <trap+0x4b>
80106397:	e9 6c fe ff ff       	jmp    80106208 <trap+0x68>
8010639c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
801063a0:	e8 bb be ff ff       	call   80102260 <ideintr>
801063a5:	e9 33 fe ff ff       	jmp    801061dd <trap+0x3d>
801063aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pagingintr();
801063b0:	e8 5b 17 00 00       	call   80107b10 <pagingintr>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063b5:	e8 f6 da ff ff       	call   80103eb0 <myproc>
801063ba:	85 c0                	test   %eax,%eax
801063bc:	0f 85 29 fe ff ff    	jne    801061eb <trap+0x4b>
801063c2:	e9 41 fe ff ff       	jmp    80106208 <trap+0x68>
801063c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063ce:	66 90                	xchg   %ax,%ax
    exit();
801063d0:	e8 fb e5 ff ff       	call   801049d0 <exit>
801063d5:	e9 2e fe ff ff       	jmp    80106208 <trap+0x68>
801063da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801063e0:	e8 eb e5 ff ff       	call   801049d0 <exit>
801063e5:	e9 0e ff ff ff       	jmp    801062f8 <trap+0x158>
801063ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
801063f0:	83 ec 0c             	sub    $0xc,%esp
801063f3:	68 c0 8d 11 80       	push   $0x80118dc0
801063f8:	e8 13 ea ff ff       	call   80104e10 <acquire>
      wakeup(&ticks);
801063fd:	c7 04 24 a0 8d 11 80 	movl   $0x80118da0,(%esp)
      ticks++;
80106404:	83 05 a0 8d 11 80 01 	addl   $0x1,0x80118da0
      wakeup(&ticks);
8010640b:	e8 50 e0 ff ff       	call   80104460 <wakeup>
      release(&tickslock);
80106410:	c7 04 24 c0 8d 11 80 	movl   $0x80118dc0,(%esp)
80106417:	e8 94 e9 ff ff       	call   80104db0 <release>
8010641c:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010641f:	e9 b9 fd ff ff       	jmp    801061dd <trap+0x3d>
80106424:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106427:	e8 64 da ff ff       	call   80103e90 <cpuid>
8010642c:	83 ec 0c             	sub    $0xc,%esp
8010642f:	56                   	push   %esi
80106430:	57                   	push   %edi
80106431:	50                   	push   %eax
80106432:	ff 73 30             	push   0x30(%ebx)
80106435:	68 10 87 10 80       	push   $0x80108710
8010643a:	e8 61 a2 ff ff       	call   801006a0 <cprintf>
      panic("trap");
8010643f:	83 c4 14             	add    $0x14,%esp
80106442:	68 e6 86 10 80       	push   $0x801086e6
80106447:	e8 34 9f ff ff       	call   80100380 <panic>
8010644c:	66 90                	xchg   %ax,%ax
8010644e:	66 90                	xchg   %ax,%ax

80106450 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106450:	a1 00 96 11 80       	mov    0x80119600,%eax
80106455:	85 c0                	test   %eax,%eax
80106457:	74 17                	je     80106470 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106459:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010645e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010645f:	a8 01                	test   $0x1,%al
80106461:	74 0d                	je     80106470 <uartgetc+0x20>
80106463:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106468:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106469:	0f b6 c0             	movzbl %al,%eax
8010646c:	c3                   	ret    
8010646d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106470:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106475:	c3                   	ret    
80106476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010647d:	8d 76 00             	lea    0x0(%esi),%esi

80106480 <uartinit>:
{
80106480:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106481:	31 c9                	xor    %ecx,%ecx
80106483:	89 c8                	mov    %ecx,%eax
80106485:	89 e5                	mov    %esp,%ebp
80106487:	57                   	push   %edi
80106488:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010648d:	56                   	push   %esi
8010648e:	89 fa                	mov    %edi,%edx
80106490:	53                   	push   %ebx
80106491:	83 ec 1c             	sub    $0x1c,%esp
80106494:	ee                   	out    %al,(%dx)
80106495:	be fb 03 00 00       	mov    $0x3fb,%esi
8010649a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010649f:	89 f2                	mov    %esi,%edx
801064a1:	ee                   	out    %al,(%dx)
801064a2:	b8 0c 00 00 00       	mov    $0xc,%eax
801064a7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064ac:	ee                   	out    %al,(%dx)
801064ad:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801064b2:	89 c8                	mov    %ecx,%eax
801064b4:	89 da                	mov    %ebx,%edx
801064b6:	ee                   	out    %al,(%dx)
801064b7:	b8 03 00 00 00       	mov    $0x3,%eax
801064bc:	89 f2                	mov    %esi,%edx
801064be:	ee                   	out    %al,(%dx)
801064bf:	ba fc 03 00 00       	mov    $0x3fc,%edx
801064c4:	89 c8                	mov    %ecx,%eax
801064c6:	ee                   	out    %al,(%dx)
801064c7:	b8 01 00 00 00       	mov    $0x1,%eax
801064cc:	89 da                	mov    %ebx,%edx
801064ce:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801064cf:	ba fd 03 00 00       	mov    $0x3fd,%edx
801064d4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801064d5:	3c ff                	cmp    $0xff,%al
801064d7:	74 78                	je     80106551 <uartinit+0xd1>
  uart = 1;
801064d9:	c7 05 00 96 11 80 01 	movl   $0x1,0x80119600
801064e0:	00 00 00 
801064e3:	89 fa                	mov    %edi,%edx
801064e5:	ec                   	in     (%dx),%al
801064e6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064eb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801064ec:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801064ef:	bf 50 88 10 80       	mov    $0x80108850,%edi
801064f4:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
801064f9:	6a 00                	push   $0x0
801064fb:	6a 04                	push   $0x4
801064fd:	e8 9e bf ff ff       	call   801024a0 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106502:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106506:	83 c4 10             	add    $0x10,%esp
80106509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106510:	a1 00 96 11 80       	mov    0x80119600,%eax
80106515:	bb 80 00 00 00       	mov    $0x80,%ebx
8010651a:	85 c0                	test   %eax,%eax
8010651c:	75 14                	jne    80106532 <uartinit+0xb2>
8010651e:	eb 23                	jmp    80106543 <uartinit+0xc3>
    microdelay(10);
80106520:	83 ec 0c             	sub    $0xc,%esp
80106523:	6a 0a                	push   $0xa
80106525:	e8 46 c9 ff ff       	call   80102e70 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010652a:	83 c4 10             	add    $0x10,%esp
8010652d:	83 eb 01             	sub    $0x1,%ebx
80106530:	74 07                	je     80106539 <uartinit+0xb9>
80106532:	89 f2                	mov    %esi,%edx
80106534:	ec                   	in     (%dx),%al
80106535:	a8 20                	test   $0x20,%al
80106537:	74 e7                	je     80106520 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106539:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010653d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106542:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106543:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106547:	83 c7 01             	add    $0x1,%edi
8010654a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010654d:	84 c0                	test   %al,%al
8010654f:	75 bf                	jne    80106510 <uartinit+0x90>
}
80106551:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106554:	5b                   	pop    %ebx
80106555:	5e                   	pop    %esi
80106556:	5f                   	pop    %edi
80106557:	5d                   	pop    %ebp
80106558:	c3                   	ret    
80106559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106560 <uartputc>:
  if(!uart)
80106560:	a1 00 96 11 80       	mov    0x80119600,%eax
80106565:	85 c0                	test   %eax,%eax
80106567:	74 47                	je     801065b0 <uartputc+0x50>
{
80106569:	55                   	push   %ebp
8010656a:	89 e5                	mov    %esp,%ebp
8010656c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010656d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106572:	53                   	push   %ebx
80106573:	bb 80 00 00 00       	mov    $0x80,%ebx
80106578:	eb 18                	jmp    80106592 <uartputc+0x32>
8010657a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106580:	83 ec 0c             	sub    $0xc,%esp
80106583:	6a 0a                	push   $0xa
80106585:	e8 e6 c8 ff ff       	call   80102e70 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010658a:	83 c4 10             	add    $0x10,%esp
8010658d:	83 eb 01             	sub    $0x1,%ebx
80106590:	74 07                	je     80106599 <uartputc+0x39>
80106592:	89 f2                	mov    %esi,%edx
80106594:	ec                   	in     (%dx),%al
80106595:	a8 20                	test   $0x20,%al
80106597:	74 e7                	je     80106580 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106599:	8b 45 08             	mov    0x8(%ebp),%eax
8010659c:	ba f8 03 00 00       	mov    $0x3f8,%edx
801065a1:	ee                   	out    %al,(%dx)
}
801065a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801065a5:	5b                   	pop    %ebx
801065a6:	5e                   	pop    %esi
801065a7:	5d                   	pop    %ebp
801065a8:	c3                   	ret    
801065a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065b0:	c3                   	ret    
801065b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065bf:	90                   	nop

801065c0 <uartintr>:

void
uartintr(void)
{
801065c0:	55                   	push   %ebp
801065c1:	89 e5                	mov    %esp,%ebp
801065c3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801065c6:	68 50 64 10 80       	push   $0x80106450
801065cb:	e8 b0 a2 ff ff       	call   80100880 <consoleintr>
}
801065d0:	83 c4 10             	add    $0x10,%esp
801065d3:	c9                   	leave  
801065d4:	c3                   	ret    

801065d5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801065d5:	6a 00                	push   $0x0
  pushl $0
801065d7:	6a 00                	push   $0x0
  jmp alltraps
801065d9:	e9 ec fa ff ff       	jmp    801060ca <alltraps>

801065de <vector1>:
.globl vector1
vector1:
  pushl $0
801065de:	6a 00                	push   $0x0
  pushl $1
801065e0:	6a 01                	push   $0x1
  jmp alltraps
801065e2:	e9 e3 fa ff ff       	jmp    801060ca <alltraps>

801065e7 <vector2>:
.globl vector2
vector2:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $2
801065e9:	6a 02                	push   $0x2
  jmp alltraps
801065eb:	e9 da fa ff ff       	jmp    801060ca <alltraps>

801065f0 <vector3>:
.globl vector3
vector3:
  pushl $0
801065f0:	6a 00                	push   $0x0
  pushl $3
801065f2:	6a 03                	push   $0x3
  jmp alltraps
801065f4:	e9 d1 fa ff ff       	jmp    801060ca <alltraps>

801065f9 <vector4>:
.globl vector4
vector4:
  pushl $0
801065f9:	6a 00                	push   $0x0
  pushl $4
801065fb:	6a 04                	push   $0x4
  jmp alltraps
801065fd:	e9 c8 fa ff ff       	jmp    801060ca <alltraps>

80106602 <vector5>:
.globl vector5
vector5:
  pushl $0
80106602:	6a 00                	push   $0x0
  pushl $5
80106604:	6a 05                	push   $0x5
  jmp alltraps
80106606:	e9 bf fa ff ff       	jmp    801060ca <alltraps>

8010660b <vector6>:
.globl vector6
vector6:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $6
8010660d:	6a 06                	push   $0x6
  jmp alltraps
8010660f:	e9 b6 fa ff ff       	jmp    801060ca <alltraps>

80106614 <vector7>:
.globl vector7
vector7:
  pushl $0
80106614:	6a 00                	push   $0x0
  pushl $7
80106616:	6a 07                	push   $0x7
  jmp alltraps
80106618:	e9 ad fa ff ff       	jmp    801060ca <alltraps>

8010661d <vector8>:
.globl vector8
vector8:
  pushl $8
8010661d:	6a 08                	push   $0x8
  jmp alltraps
8010661f:	e9 a6 fa ff ff       	jmp    801060ca <alltraps>

80106624 <vector9>:
.globl vector9
vector9:
  pushl $0
80106624:	6a 00                	push   $0x0
  pushl $9
80106626:	6a 09                	push   $0x9
  jmp alltraps
80106628:	e9 9d fa ff ff       	jmp    801060ca <alltraps>

8010662d <vector10>:
.globl vector10
vector10:
  pushl $10
8010662d:	6a 0a                	push   $0xa
  jmp alltraps
8010662f:	e9 96 fa ff ff       	jmp    801060ca <alltraps>

80106634 <vector11>:
.globl vector11
vector11:
  pushl $11
80106634:	6a 0b                	push   $0xb
  jmp alltraps
80106636:	e9 8f fa ff ff       	jmp    801060ca <alltraps>

8010663b <vector12>:
.globl vector12
vector12:
  pushl $12
8010663b:	6a 0c                	push   $0xc
  jmp alltraps
8010663d:	e9 88 fa ff ff       	jmp    801060ca <alltraps>

80106642 <vector13>:
.globl vector13
vector13:
  pushl $13
80106642:	6a 0d                	push   $0xd
  jmp alltraps
80106644:	e9 81 fa ff ff       	jmp    801060ca <alltraps>

80106649 <vector14>:
.globl vector14
vector14:
  pushl $14
80106649:	6a 0e                	push   $0xe
  jmp alltraps
8010664b:	e9 7a fa ff ff       	jmp    801060ca <alltraps>

80106650 <vector15>:
.globl vector15
vector15:
  pushl $0
80106650:	6a 00                	push   $0x0
  pushl $15
80106652:	6a 0f                	push   $0xf
  jmp alltraps
80106654:	e9 71 fa ff ff       	jmp    801060ca <alltraps>

80106659 <vector16>:
.globl vector16
vector16:
  pushl $0
80106659:	6a 00                	push   $0x0
  pushl $16
8010665b:	6a 10                	push   $0x10
  jmp alltraps
8010665d:	e9 68 fa ff ff       	jmp    801060ca <alltraps>

80106662 <vector17>:
.globl vector17
vector17:
  pushl $17
80106662:	6a 11                	push   $0x11
  jmp alltraps
80106664:	e9 61 fa ff ff       	jmp    801060ca <alltraps>

80106669 <vector18>:
.globl vector18
vector18:
  pushl $0
80106669:	6a 00                	push   $0x0
  pushl $18
8010666b:	6a 12                	push   $0x12
  jmp alltraps
8010666d:	e9 58 fa ff ff       	jmp    801060ca <alltraps>

80106672 <vector19>:
.globl vector19
vector19:
  pushl $0
80106672:	6a 00                	push   $0x0
  pushl $19
80106674:	6a 13                	push   $0x13
  jmp alltraps
80106676:	e9 4f fa ff ff       	jmp    801060ca <alltraps>

8010667b <vector20>:
.globl vector20
vector20:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $20
8010667d:	6a 14                	push   $0x14
  jmp alltraps
8010667f:	e9 46 fa ff ff       	jmp    801060ca <alltraps>

80106684 <vector21>:
.globl vector21
vector21:
  pushl $0
80106684:	6a 00                	push   $0x0
  pushl $21
80106686:	6a 15                	push   $0x15
  jmp alltraps
80106688:	e9 3d fa ff ff       	jmp    801060ca <alltraps>

8010668d <vector22>:
.globl vector22
vector22:
  pushl $0
8010668d:	6a 00                	push   $0x0
  pushl $22
8010668f:	6a 16                	push   $0x16
  jmp alltraps
80106691:	e9 34 fa ff ff       	jmp    801060ca <alltraps>

80106696 <vector23>:
.globl vector23
vector23:
  pushl $0
80106696:	6a 00                	push   $0x0
  pushl $23
80106698:	6a 17                	push   $0x17
  jmp alltraps
8010669a:	e9 2b fa ff ff       	jmp    801060ca <alltraps>

8010669f <vector24>:
.globl vector24
vector24:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $24
801066a1:	6a 18                	push   $0x18
  jmp alltraps
801066a3:	e9 22 fa ff ff       	jmp    801060ca <alltraps>

801066a8 <vector25>:
.globl vector25
vector25:
  pushl $0
801066a8:	6a 00                	push   $0x0
  pushl $25
801066aa:	6a 19                	push   $0x19
  jmp alltraps
801066ac:	e9 19 fa ff ff       	jmp    801060ca <alltraps>

801066b1 <vector26>:
.globl vector26
vector26:
  pushl $0
801066b1:	6a 00                	push   $0x0
  pushl $26
801066b3:	6a 1a                	push   $0x1a
  jmp alltraps
801066b5:	e9 10 fa ff ff       	jmp    801060ca <alltraps>

801066ba <vector27>:
.globl vector27
vector27:
  pushl $0
801066ba:	6a 00                	push   $0x0
  pushl $27
801066bc:	6a 1b                	push   $0x1b
  jmp alltraps
801066be:	e9 07 fa ff ff       	jmp    801060ca <alltraps>

801066c3 <vector28>:
.globl vector28
vector28:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $28
801066c5:	6a 1c                	push   $0x1c
  jmp alltraps
801066c7:	e9 fe f9 ff ff       	jmp    801060ca <alltraps>

801066cc <vector29>:
.globl vector29
vector29:
  pushl $0
801066cc:	6a 00                	push   $0x0
  pushl $29
801066ce:	6a 1d                	push   $0x1d
  jmp alltraps
801066d0:	e9 f5 f9 ff ff       	jmp    801060ca <alltraps>

801066d5 <vector30>:
.globl vector30
vector30:
  pushl $0
801066d5:	6a 00                	push   $0x0
  pushl $30
801066d7:	6a 1e                	push   $0x1e
  jmp alltraps
801066d9:	e9 ec f9 ff ff       	jmp    801060ca <alltraps>

801066de <vector31>:
.globl vector31
vector31:
  pushl $0
801066de:	6a 00                	push   $0x0
  pushl $31
801066e0:	6a 1f                	push   $0x1f
  jmp alltraps
801066e2:	e9 e3 f9 ff ff       	jmp    801060ca <alltraps>

801066e7 <vector32>:
.globl vector32
vector32:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $32
801066e9:	6a 20                	push   $0x20
  jmp alltraps
801066eb:	e9 da f9 ff ff       	jmp    801060ca <alltraps>

801066f0 <vector33>:
.globl vector33
vector33:
  pushl $0
801066f0:	6a 00                	push   $0x0
  pushl $33
801066f2:	6a 21                	push   $0x21
  jmp alltraps
801066f4:	e9 d1 f9 ff ff       	jmp    801060ca <alltraps>

801066f9 <vector34>:
.globl vector34
vector34:
  pushl $0
801066f9:	6a 00                	push   $0x0
  pushl $34
801066fb:	6a 22                	push   $0x22
  jmp alltraps
801066fd:	e9 c8 f9 ff ff       	jmp    801060ca <alltraps>

80106702 <vector35>:
.globl vector35
vector35:
  pushl $0
80106702:	6a 00                	push   $0x0
  pushl $35
80106704:	6a 23                	push   $0x23
  jmp alltraps
80106706:	e9 bf f9 ff ff       	jmp    801060ca <alltraps>

8010670b <vector36>:
.globl vector36
vector36:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $36
8010670d:	6a 24                	push   $0x24
  jmp alltraps
8010670f:	e9 b6 f9 ff ff       	jmp    801060ca <alltraps>

80106714 <vector37>:
.globl vector37
vector37:
  pushl $0
80106714:	6a 00                	push   $0x0
  pushl $37
80106716:	6a 25                	push   $0x25
  jmp alltraps
80106718:	e9 ad f9 ff ff       	jmp    801060ca <alltraps>

8010671d <vector38>:
.globl vector38
vector38:
  pushl $0
8010671d:	6a 00                	push   $0x0
  pushl $38
8010671f:	6a 26                	push   $0x26
  jmp alltraps
80106721:	e9 a4 f9 ff ff       	jmp    801060ca <alltraps>

80106726 <vector39>:
.globl vector39
vector39:
  pushl $0
80106726:	6a 00                	push   $0x0
  pushl $39
80106728:	6a 27                	push   $0x27
  jmp alltraps
8010672a:	e9 9b f9 ff ff       	jmp    801060ca <alltraps>

8010672f <vector40>:
.globl vector40
vector40:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $40
80106731:	6a 28                	push   $0x28
  jmp alltraps
80106733:	e9 92 f9 ff ff       	jmp    801060ca <alltraps>

80106738 <vector41>:
.globl vector41
vector41:
  pushl $0
80106738:	6a 00                	push   $0x0
  pushl $41
8010673a:	6a 29                	push   $0x29
  jmp alltraps
8010673c:	e9 89 f9 ff ff       	jmp    801060ca <alltraps>

80106741 <vector42>:
.globl vector42
vector42:
  pushl $0
80106741:	6a 00                	push   $0x0
  pushl $42
80106743:	6a 2a                	push   $0x2a
  jmp alltraps
80106745:	e9 80 f9 ff ff       	jmp    801060ca <alltraps>

8010674a <vector43>:
.globl vector43
vector43:
  pushl $0
8010674a:	6a 00                	push   $0x0
  pushl $43
8010674c:	6a 2b                	push   $0x2b
  jmp alltraps
8010674e:	e9 77 f9 ff ff       	jmp    801060ca <alltraps>

80106753 <vector44>:
.globl vector44
vector44:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $44
80106755:	6a 2c                	push   $0x2c
  jmp alltraps
80106757:	e9 6e f9 ff ff       	jmp    801060ca <alltraps>

8010675c <vector45>:
.globl vector45
vector45:
  pushl $0
8010675c:	6a 00                	push   $0x0
  pushl $45
8010675e:	6a 2d                	push   $0x2d
  jmp alltraps
80106760:	e9 65 f9 ff ff       	jmp    801060ca <alltraps>

80106765 <vector46>:
.globl vector46
vector46:
  pushl $0
80106765:	6a 00                	push   $0x0
  pushl $46
80106767:	6a 2e                	push   $0x2e
  jmp alltraps
80106769:	e9 5c f9 ff ff       	jmp    801060ca <alltraps>

8010676e <vector47>:
.globl vector47
vector47:
  pushl $0
8010676e:	6a 00                	push   $0x0
  pushl $47
80106770:	6a 2f                	push   $0x2f
  jmp alltraps
80106772:	e9 53 f9 ff ff       	jmp    801060ca <alltraps>

80106777 <vector48>:
.globl vector48
vector48:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $48
80106779:	6a 30                	push   $0x30
  jmp alltraps
8010677b:	e9 4a f9 ff ff       	jmp    801060ca <alltraps>

80106780 <vector49>:
.globl vector49
vector49:
  pushl $0
80106780:	6a 00                	push   $0x0
  pushl $49
80106782:	6a 31                	push   $0x31
  jmp alltraps
80106784:	e9 41 f9 ff ff       	jmp    801060ca <alltraps>

80106789 <vector50>:
.globl vector50
vector50:
  pushl $0
80106789:	6a 00                	push   $0x0
  pushl $50
8010678b:	6a 32                	push   $0x32
  jmp alltraps
8010678d:	e9 38 f9 ff ff       	jmp    801060ca <alltraps>

80106792 <vector51>:
.globl vector51
vector51:
  pushl $0
80106792:	6a 00                	push   $0x0
  pushl $51
80106794:	6a 33                	push   $0x33
  jmp alltraps
80106796:	e9 2f f9 ff ff       	jmp    801060ca <alltraps>

8010679b <vector52>:
.globl vector52
vector52:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $52
8010679d:	6a 34                	push   $0x34
  jmp alltraps
8010679f:	e9 26 f9 ff ff       	jmp    801060ca <alltraps>

801067a4 <vector53>:
.globl vector53
vector53:
  pushl $0
801067a4:	6a 00                	push   $0x0
  pushl $53
801067a6:	6a 35                	push   $0x35
  jmp alltraps
801067a8:	e9 1d f9 ff ff       	jmp    801060ca <alltraps>

801067ad <vector54>:
.globl vector54
vector54:
  pushl $0
801067ad:	6a 00                	push   $0x0
  pushl $54
801067af:	6a 36                	push   $0x36
  jmp alltraps
801067b1:	e9 14 f9 ff ff       	jmp    801060ca <alltraps>

801067b6 <vector55>:
.globl vector55
vector55:
  pushl $0
801067b6:	6a 00                	push   $0x0
  pushl $55
801067b8:	6a 37                	push   $0x37
  jmp alltraps
801067ba:	e9 0b f9 ff ff       	jmp    801060ca <alltraps>

801067bf <vector56>:
.globl vector56
vector56:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $56
801067c1:	6a 38                	push   $0x38
  jmp alltraps
801067c3:	e9 02 f9 ff ff       	jmp    801060ca <alltraps>

801067c8 <vector57>:
.globl vector57
vector57:
  pushl $0
801067c8:	6a 00                	push   $0x0
  pushl $57
801067ca:	6a 39                	push   $0x39
  jmp alltraps
801067cc:	e9 f9 f8 ff ff       	jmp    801060ca <alltraps>

801067d1 <vector58>:
.globl vector58
vector58:
  pushl $0
801067d1:	6a 00                	push   $0x0
  pushl $58
801067d3:	6a 3a                	push   $0x3a
  jmp alltraps
801067d5:	e9 f0 f8 ff ff       	jmp    801060ca <alltraps>

801067da <vector59>:
.globl vector59
vector59:
  pushl $0
801067da:	6a 00                	push   $0x0
  pushl $59
801067dc:	6a 3b                	push   $0x3b
  jmp alltraps
801067de:	e9 e7 f8 ff ff       	jmp    801060ca <alltraps>

801067e3 <vector60>:
.globl vector60
vector60:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $60
801067e5:	6a 3c                	push   $0x3c
  jmp alltraps
801067e7:	e9 de f8 ff ff       	jmp    801060ca <alltraps>

801067ec <vector61>:
.globl vector61
vector61:
  pushl $0
801067ec:	6a 00                	push   $0x0
  pushl $61
801067ee:	6a 3d                	push   $0x3d
  jmp alltraps
801067f0:	e9 d5 f8 ff ff       	jmp    801060ca <alltraps>

801067f5 <vector62>:
.globl vector62
vector62:
  pushl $0
801067f5:	6a 00                	push   $0x0
  pushl $62
801067f7:	6a 3e                	push   $0x3e
  jmp alltraps
801067f9:	e9 cc f8 ff ff       	jmp    801060ca <alltraps>

801067fe <vector63>:
.globl vector63
vector63:
  pushl $0
801067fe:	6a 00                	push   $0x0
  pushl $63
80106800:	6a 3f                	push   $0x3f
  jmp alltraps
80106802:	e9 c3 f8 ff ff       	jmp    801060ca <alltraps>

80106807 <vector64>:
.globl vector64
vector64:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $64
80106809:	6a 40                	push   $0x40
  jmp alltraps
8010680b:	e9 ba f8 ff ff       	jmp    801060ca <alltraps>

80106810 <vector65>:
.globl vector65
vector65:
  pushl $0
80106810:	6a 00                	push   $0x0
  pushl $65
80106812:	6a 41                	push   $0x41
  jmp alltraps
80106814:	e9 b1 f8 ff ff       	jmp    801060ca <alltraps>

80106819 <vector66>:
.globl vector66
vector66:
  pushl $0
80106819:	6a 00                	push   $0x0
  pushl $66
8010681b:	6a 42                	push   $0x42
  jmp alltraps
8010681d:	e9 a8 f8 ff ff       	jmp    801060ca <alltraps>

80106822 <vector67>:
.globl vector67
vector67:
  pushl $0
80106822:	6a 00                	push   $0x0
  pushl $67
80106824:	6a 43                	push   $0x43
  jmp alltraps
80106826:	e9 9f f8 ff ff       	jmp    801060ca <alltraps>

8010682b <vector68>:
.globl vector68
vector68:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $68
8010682d:	6a 44                	push   $0x44
  jmp alltraps
8010682f:	e9 96 f8 ff ff       	jmp    801060ca <alltraps>

80106834 <vector69>:
.globl vector69
vector69:
  pushl $0
80106834:	6a 00                	push   $0x0
  pushl $69
80106836:	6a 45                	push   $0x45
  jmp alltraps
80106838:	e9 8d f8 ff ff       	jmp    801060ca <alltraps>

8010683d <vector70>:
.globl vector70
vector70:
  pushl $0
8010683d:	6a 00                	push   $0x0
  pushl $70
8010683f:	6a 46                	push   $0x46
  jmp alltraps
80106841:	e9 84 f8 ff ff       	jmp    801060ca <alltraps>

80106846 <vector71>:
.globl vector71
vector71:
  pushl $0
80106846:	6a 00                	push   $0x0
  pushl $71
80106848:	6a 47                	push   $0x47
  jmp alltraps
8010684a:	e9 7b f8 ff ff       	jmp    801060ca <alltraps>

8010684f <vector72>:
.globl vector72
vector72:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $72
80106851:	6a 48                	push   $0x48
  jmp alltraps
80106853:	e9 72 f8 ff ff       	jmp    801060ca <alltraps>

80106858 <vector73>:
.globl vector73
vector73:
  pushl $0
80106858:	6a 00                	push   $0x0
  pushl $73
8010685a:	6a 49                	push   $0x49
  jmp alltraps
8010685c:	e9 69 f8 ff ff       	jmp    801060ca <alltraps>

80106861 <vector74>:
.globl vector74
vector74:
  pushl $0
80106861:	6a 00                	push   $0x0
  pushl $74
80106863:	6a 4a                	push   $0x4a
  jmp alltraps
80106865:	e9 60 f8 ff ff       	jmp    801060ca <alltraps>

8010686a <vector75>:
.globl vector75
vector75:
  pushl $0
8010686a:	6a 00                	push   $0x0
  pushl $75
8010686c:	6a 4b                	push   $0x4b
  jmp alltraps
8010686e:	e9 57 f8 ff ff       	jmp    801060ca <alltraps>

80106873 <vector76>:
.globl vector76
vector76:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $76
80106875:	6a 4c                	push   $0x4c
  jmp alltraps
80106877:	e9 4e f8 ff ff       	jmp    801060ca <alltraps>

8010687c <vector77>:
.globl vector77
vector77:
  pushl $0
8010687c:	6a 00                	push   $0x0
  pushl $77
8010687e:	6a 4d                	push   $0x4d
  jmp alltraps
80106880:	e9 45 f8 ff ff       	jmp    801060ca <alltraps>

80106885 <vector78>:
.globl vector78
vector78:
  pushl $0
80106885:	6a 00                	push   $0x0
  pushl $78
80106887:	6a 4e                	push   $0x4e
  jmp alltraps
80106889:	e9 3c f8 ff ff       	jmp    801060ca <alltraps>

8010688e <vector79>:
.globl vector79
vector79:
  pushl $0
8010688e:	6a 00                	push   $0x0
  pushl $79
80106890:	6a 4f                	push   $0x4f
  jmp alltraps
80106892:	e9 33 f8 ff ff       	jmp    801060ca <alltraps>

80106897 <vector80>:
.globl vector80
vector80:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $80
80106899:	6a 50                	push   $0x50
  jmp alltraps
8010689b:	e9 2a f8 ff ff       	jmp    801060ca <alltraps>

801068a0 <vector81>:
.globl vector81
vector81:
  pushl $0
801068a0:	6a 00                	push   $0x0
  pushl $81
801068a2:	6a 51                	push   $0x51
  jmp alltraps
801068a4:	e9 21 f8 ff ff       	jmp    801060ca <alltraps>

801068a9 <vector82>:
.globl vector82
vector82:
  pushl $0
801068a9:	6a 00                	push   $0x0
  pushl $82
801068ab:	6a 52                	push   $0x52
  jmp alltraps
801068ad:	e9 18 f8 ff ff       	jmp    801060ca <alltraps>

801068b2 <vector83>:
.globl vector83
vector83:
  pushl $0
801068b2:	6a 00                	push   $0x0
  pushl $83
801068b4:	6a 53                	push   $0x53
  jmp alltraps
801068b6:	e9 0f f8 ff ff       	jmp    801060ca <alltraps>

801068bb <vector84>:
.globl vector84
vector84:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $84
801068bd:	6a 54                	push   $0x54
  jmp alltraps
801068bf:	e9 06 f8 ff ff       	jmp    801060ca <alltraps>

801068c4 <vector85>:
.globl vector85
vector85:
  pushl $0
801068c4:	6a 00                	push   $0x0
  pushl $85
801068c6:	6a 55                	push   $0x55
  jmp alltraps
801068c8:	e9 fd f7 ff ff       	jmp    801060ca <alltraps>

801068cd <vector86>:
.globl vector86
vector86:
  pushl $0
801068cd:	6a 00                	push   $0x0
  pushl $86
801068cf:	6a 56                	push   $0x56
  jmp alltraps
801068d1:	e9 f4 f7 ff ff       	jmp    801060ca <alltraps>

801068d6 <vector87>:
.globl vector87
vector87:
  pushl $0
801068d6:	6a 00                	push   $0x0
  pushl $87
801068d8:	6a 57                	push   $0x57
  jmp alltraps
801068da:	e9 eb f7 ff ff       	jmp    801060ca <alltraps>

801068df <vector88>:
.globl vector88
vector88:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $88
801068e1:	6a 58                	push   $0x58
  jmp alltraps
801068e3:	e9 e2 f7 ff ff       	jmp    801060ca <alltraps>

801068e8 <vector89>:
.globl vector89
vector89:
  pushl $0
801068e8:	6a 00                	push   $0x0
  pushl $89
801068ea:	6a 59                	push   $0x59
  jmp alltraps
801068ec:	e9 d9 f7 ff ff       	jmp    801060ca <alltraps>

801068f1 <vector90>:
.globl vector90
vector90:
  pushl $0
801068f1:	6a 00                	push   $0x0
  pushl $90
801068f3:	6a 5a                	push   $0x5a
  jmp alltraps
801068f5:	e9 d0 f7 ff ff       	jmp    801060ca <alltraps>

801068fa <vector91>:
.globl vector91
vector91:
  pushl $0
801068fa:	6a 00                	push   $0x0
  pushl $91
801068fc:	6a 5b                	push   $0x5b
  jmp alltraps
801068fe:	e9 c7 f7 ff ff       	jmp    801060ca <alltraps>

80106903 <vector92>:
.globl vector92
vector92:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $92
80106905:	6a 5c                	push   $0x5c
  jmp alltraps
80106907:	e9 be f7 ff ff       	jmp    801060ca <alltraps>

8010690c <vector93>:
.globl vector93
vector93:
  pushl $0
8010690c:	6a 00                	push   $0x0
  pushl $93
8010690e:	6a 5d                	push   $0x5d
  jmp alltraps
80106910:	e9 b5 f7 ff ff       	jmp    801060ca <alltraps>

80106915 <vector94>:
.globl vector94
vector94:
  pushl $0
80106915:	6a 00                	push   $0x0
  pushl $94
80106917:	6a 5e                	push   $0x5e
  jmp alltraps
80106919:	e9 ac f7 ff ff       	jmp    801060ca <alltraps>

8010691e <vector95>:
.globl vector95
vector95:
  pushl $0
8010691e:	6a 00                	push   $0x0
  pushl $95
80106920:	6a 5f                	push   $0x5f
  jmp alltraps
80106922:	e9 a3 f7 ff ff       	jmp    801060ca <alltraps>

80106927 <vector96>:
.globl vector96
vector96:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $96
80106929:	6a 60                	push   $0x60
  jmp alltraps
8010692b:	e9 9a f7 ff ff       	jmp    801060ca <alltraps>

80106930 <vector97>:
.globl vector97
vector97:
  pushl $0
80106930:	6a 00                	push   $0x0
  pushl $97
80106932:	6a 61                	push   $0x61
  jmp alltraps
80106934:	e9 91 f7 ff ff       	jmp    801060ca <alltraps>

80106939 <vector98>:
.globl vector98
vector98:
  pushl $0
80106939:	6a 00                	push   $0x0
  pushl $98
8010693b:	6a 62                	push   $0x62
  jmp alltraps
8010693d:	e9 88 f7 ff ff       	jmp    801060ca <alltraps>

80106942 <vector99>:
.globl vector99
vector99:
  pushl $0
80106942:	6a 00                	push   $0x0
  pushl $99
80106944:	6a 63                	push   $0x63
  jmp alltraps
80106946:	e9 7f f7 ff ff       	jmp    801060ca <alltraps>

8010694b <vector100>:
.globl vector100
vector100:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $100
8010694d:	6a 64                	push   $0x64
  jmp alltraps
8010694f:	e9 76 f7 ff ff       	jmp    801060ca <alltraps>

80106954 <vector101>:
.globl vector101
vector101:
  pushl $0
80106954:	6a 00                	push   $0x0
  pushl $101
80106956:	6a 65                	push   $0x65
  jmp alltraps
80106958:	e9 6d f7 ff ff       	jmp    801060ca <alltraps>

8010695d <vector102>:
.globl vector102
vector102:
  pushl $0
8010695d:	6a 00                	push   $0x0
  pushl $102
8010695f:	6a 66                	push   $0x66
  jmp alltraps
80106961:	e9 64 f7 ff ff       	jmp    801060ca <alltraps>

80106966 <vector103>:
.globl vector103
vector103:
  pushl $0
80106966:	6a 00                	push   $0x0
  pushl $103
80106968:	6a 67                	push   $0x67
  jmp alltraps
8010696a:	e9 5b f7 ff ff       	jmp    801060ca <alltraps>

8010696f <vector104>:
.globl vector104
vector104:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $104
80106971:	6a 68                	push   $0x68
  jmp alltraps
80106973:	e9 52 f7 ff ff       	jmp    801060ca <alltraps>

80106978 <vector105>:
.globl vector105
vector105:
  pushl $0
80106978:	6a 00                	push   $0x0
  pushl $105
8010697a:	6a 69                	push   $0x69
  jmp alltraps
8010697c:	e9 49 f7 ff ff       	jmp    801060ca <alltraps>

80106981 <vector106>:
.globl vector106
vector106:
  pushl $0
80106981:	6a 00                	push   $0x0
  pushl $106
80106983:	6a 6a                	push   $0x6a
  jmp alltraps
80106985:	e9 40 f7 ff ff       	jmp    801060ca <alltraps>

8010698a <vector107>:
.globl vector107
vector107:
  pushl $0
8010698a:	6a 00                	push   $0x0
  pushl $107
8010698c:	6a 6b                	push   $0x6b
  jmp alltraps
8010698e:	e9 37 f7 ff ff       	jmp    801060ca <alltraps>

80106993 <vector108>:
.globl vector108
vector108:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $108
80106995:	6a 6c                	push   $0x6c
  jmp alltraps
80106997:	e9 2e f7 ff ff       	jmp    801060ca <alltraps>

8010699c <vector109>:
.globl vector109
vector109:
  pushl $0
8010699c:	6a 00                	push   $0x0
  pushl $109
8010699e:	6a 6d                	push   $0x6d
  jmp alltraps
801069a0:	e9 25 f7 ff ff       	jmp    801060ca <alltraps>

801069a5 <vector110>:
.globl vector110
vector110:
  pushl $0
801069a5:	6a 00                	push   $0x0
  pushl $110
801069a7:	6a 6e                	push   $0x6e
  jmp alltraps
801069a9:	e9 1c f7 ff ff       	jmp    801060ca <alltraps>

801069ae <vector111>:
.globl vector111
vector111:
  pushl $0
801069ae:	6a 00                	push   $0x0
  pushl $111
801069b0:	6a 6f                	push   $0x6f
  jmp alltraps
801069b2:	e9 13 f7 ff ff       	jmp    801060ca <alltraps>

801069b7 <vector112>:
.globl vector112
vector112:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $112
801069b9:	6a 70                	push   $0x70
  jmp alltraps
801069bb:	e9 0a f7 ff ff       	jmp    801060ca <alltraps>

801069c0 <vector113>:
.globl vector113
vector113:
  pushl $0
801069c0:	6a 00                	push   $0x0
  pushl $113
801069c2:	6a 71                	push   $0x71
  jmp alltraps
801069c4:	e9 01 f7 ff ff       	jmp    801060ca <alltraps>

801069c9 <vector114>:
.globl vector114
vector114:
  pushl $0
801069c9:	6a 00                	push   $0x0
  pushl $114
801069cb:	6a 72                	push   $0x72
  jmp alltraps
801069cd:	e9 f8 f6 ff ff       	jmp    801060ca <alltraps>

801069d2 <vector115>:
.globl vector115
vector115:
  pushl $0
801069d2:	6a 00                	push   $0x0
  pushl $115
801069d4:	6a 73                	push   $0x73
  jmp alltraps
801069d6:	e9 ef f6 ff ff       	jmp    801060ca <alltraps>

801069db <vector116>:
.globl vector116
vector116:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $116
801069dd:	6a 74                	push   $0x74
  jmp alltraps
801069df:	e9 e6 f6 ff ff       	jmp    801060ca <alltraps>

801069e4 <vector117>:
.globl vector117
vector117:
  pushl $0
801069e4:	6a 00                	push   $0x0
  pushl $117
801069e6:	6a 75                	push   $0x75
  jmp alltraps
801069e8:	e9 dd f6 ff ff       	jmp    801060ca <alltraps>

801069ed <vector118>:
.globl vector118
vector118:
  pushl $0
801069ed:	6a 00                	push   $0x0
  pushl $118
801069ef:	6a 76                	push   $0x76
  jmp alltraps
801069f1:	e9 d4 f6 ff ff       	jmp    801060ca <alltraps>

801069f6 <vector119>:
.globl vector119
vector119:
  pushl $0
801069f6:	6a 00                	push   $0x0
  pushl $119
801069f8:	6a 77                	push   $0x77
  jmp alltraps
801069fa:	e9 cb f6 ff ff       	jmp    801060ca <alltraps>

801069ff <vector120>:
.globl vector120
vector120:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $120
80106a01:	6a 78                	push   $0x78
  jmp alltraps
80106a03:	e9 c2 f6 ff ff       	jmp    801060ca <alltraps>

80106a08 <vector121>:
.globl vector121
vector121:
  pushl $0
80106a08:	6a 00                	push   $0x0
  pushl $121
80106a0a:	6a 79                	push   $0x79
  jmp alltraps
80106a0c:	e9 b9 f6 ff ff       	jmp    801060ca <alltraps>

80106a11 <vector122>:
.globl vector122
vector122:
  pushl $0
80106a11:	6a 00                	push   $0x0
  pushl $122
80106a13:	6a 7a                	push   $0x7a
  jmp alltraps
80106a15:	e9 b0 f6 ff ff       	jmp    801060ca <alltraps>

80106a1a <vector123>:
.globl vector123
vector123:
  pushl $0
80106a1a:	6a 00                	push   $0x0
  pushl $123
80106a1c:	6a 7b                	push   $0x7b
  jmp alltraps
80106a1e:	e9 a7 f6 ff ff       	jmp    801060ca <alltraps>

80106a23 <vector124>:
.globl vector124
vector124:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $124
80106a25:	6a 7c                	push   $0x7c
  jmp alltraps
80106a27:	e9 9e f6 ff ff       	jmp    801060ca <alltraps>

80106a2c <vector125>:
.globl vector125
vector125:
  pushl $0
80106a2c:	6a 00                	push   $0x0
  pushl $125
80106a2e:	6a 7d                	push   $0x7d
  jmp alltraps
80106a30:	e9 95 f6 ff ff       	jmp    801060ca <alltraps>

80106a35 <vector126>:
.globl vector126
vector126:
  pushl $0
80106a35:	6a 00                	push   $0x0
  pushl $126
80106a37:	6a 7e                	push   $0x7e
  jmp alltraps
80106a39:	e9 8c f6 ff ff       	jmp    801060ca <alltraps>

80106a3e <vector127>:
.globl vector127
vector127:
  pushl $0
80106a3e:	6a 00                	push   $0x0
  pushl $127
80106a40:	6a 7f                	push   $0x7f
  jmp alltraps
80106a42:	e9 83 f6 ff ff       	jmp    801060ca <alltraps>

80106a47 <vector128>:
.globl vector128
vector128:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $128
80106a49:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106a4e:	e9 77 f6 ff ff       	jmp    801060ca <alltraps>

80106a53 <vector129>:
.globl vector129
vector129:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $129
80106a55:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106a5a:	e9 6b f6 ff ff       	jmp    801060ca <alltraps>

80106a5f <vector130>:
.globl vector130
vector130:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $130
80106a61:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106a66:	e9 5f f6 ff ff       	jmp    801060ca <alltraps>

80106a6b <vector131>:
.globl vector131
vector131:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $131
80106a6d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106a72:	e9 53 f6 ff ff       	jmp    801060ca <alltraps>

80106a77 <vector132>:
.globl vector132
vector132:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $132
80106a79:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106a7e:	e9 47 f6 ff ff       	jmp    801060ca <alltraps>

80106a83 <vector133>:
.globl vector133
vector133:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $133
80106a85:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106a8a:	e9 3b f6 ff ff       	jmp    801060ca <alltraps>

80106a8f <vector134>:
.globl vector134
vector134:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $134
80106a91:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106a96:	e9 2f f6 ff ff       	jmp    801060ca <alltraps>

80106a9b <vector135>:
.globl vector135
vector135:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $135
80106a9d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106aa2:	e9 23 f6 ff ff       	jmp    801060ca <alltraps>

80106aa7 <vector136>:
.globl vector136
vector136:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $136
80106aa9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106aae:	e9 17 f6 ff ff       	jmp    801060ca <alltraps>

80106ab3 <vector137>:
.globl vector137
vector137:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $137
80106ab5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106aba:	e9 0b f6 ff ff       	jmp    801060ca <alltraps>

80106abf <vector138>:
.globl vector138
vector138:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $138
80106ac1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106ac6:	e9 ff f5 ff ff       	jmp    801060ca <alltraps>

80106acb <vector139>:
.globl vector139
vector139:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $139
80106acd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106ad2:	e9 f3 f5 ff ff       	jmp    801060ca <alltraps>

80106ad7 <vector140>:
.globl vector140
vector140:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $140
80106ad9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106ade:	e9 e7 f5 ff ff       	jmp    801060ca <alltraps>

80106ae3 <vector141>:
.globl vector141
vector141:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $141
80106ae5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106aea:	e9 db f5 ff ff       	jmp    801060ca <alltraps>

80106aef <vector142>:
.globl vector142
vector142:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $142
80106af1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106af6:	e9 cf f5 ff ff       	jmp    801060ca <alltraps>

80106afb <vector143>:
.globl vector143
vector143:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $143
80106afd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106b02:	e9 c3 f5 ff ff       	jmp    801060ca <alltraps>

80106b07 <vector144>:
.globl vector144
vector144:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $144
80106b09:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106b0e:	e9 b7 f5 ff ff       	jmp    801060ca <alltraps>

80106b13 <vector145>:
.globl vector145
vector145:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $145
80106b15:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106b1a:	e9 ab f5 ff ff       	jmp    801060ca <alltraps>

80106b1f <vector146>:
.globl vector146
vector146:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $146
80106b21:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106b26:	e9 9f f5 ff ff       	jmp    801060ca <alltraps>

80106b2b <vector147>:
.globl vector147
vector147:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $147
80106b2d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106b32:	e9 93 f5 ff ff       	jmp    801060ca <alltraps>

80106b37 <vector148>:
.globl vector148
vector148:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $148
80106b39:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106b3e:	e9 87 f5 ff ff       	jmp    801060ca <alltraps>

80106b43 <vector149>:
.globl vector149
vector149:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $149
80106b45:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106b4a:	e9 7b f5 ff ff       	jmp    801060ca <alltraps>

80106b4f <vector150>:
.globl vector150
vector150:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $150
80106b51:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106b56:	e9 6f f5 ff ff       	jmp    801060ca <alltraps>

80106b5b <vector151>:
.globl vector151
vector151:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $151
80106b5d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106b62:	e9 63 f5 ff ff       	jmp    801060ca <alltraps>

80106b67 <vector152>:
.globl vector152
vector152:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $152
80106b69:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106b6e:	e9 57 f5 ff ff       	jmp    801060ca <alltraps>

80106b73 <vector153>:
.globl vector153
vector153:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $153
80106b75:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106b7a:	e9 4b f5 ff ff       	jmp    801060ca <alltraps>

80106b7f <vector154>:
.globl vector154
vector154:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $154
80106b81:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106b86:	e9 3f f5 ff ff       	jmp    801060ca <alltraps>

80106b8b <vector155>:
.globl vector155
vector155:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $155
80106b8d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106b92:	e9 33 f5 ff ff       	jmp    801060ca <alltraps>

80106b97 <vector156>:
.globl vector156
vector156:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $156
80106b99:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106b9e:	e9 27 f5 ff ff       	jmp    801060ca <alltraps>

80106ba3 <vector157>:
.globl vector157
vector157:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $157
80106ba5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106baa:	e9 1b f5 ff ff       	jmp    801060ca <alltraps>

80106baf <vector158>:
.globl vector158
vector158:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $158
80106bb1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106bb6:	e9 0f f5 ff ff       	jmp    801060ca <alltraps>

80106bbb <vector159>:
.globl vector159
vector159:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $159
80106bbd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106bc2:	e9 03 f5 ff ff       	jmp    801060ca <alltraps>

80106bc7 <vector160>:
.globl vector160
vector160:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $160
80106bc9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106bce:	e9 f7 f4 ff ff       	jmp    801060ca <alltraps>

80106bd3 <vector161>:
.globl vector161
vector161:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $161
80106bd5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106bda:	e9 eb f4 ff ff       	jmp    801060ca <alltraps>

80106bdf <vector162>:
.globl vector162
vector162:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $162
80106be1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106be6:	e9 df f4 ff ff       	jmp    801060ca <alltraps>

80106beb <vector163>:
.globl vector163
vector163:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $163
80106bed:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106bf2:	e9 d3 f4 ff ff       	jmp    801060ca <alltraps>

80106bf7 <vector164>:
.globl vector164
vector164:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $164
80106bf9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106bfe:	e9 c7 f4 ff ff       	jmp    801060ca <alltraps>

80106c03 <vector165>:
.globl vector165
vector165:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $165
80106c05:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106c0a:	e9 bb f4 ff ff       	jmp    801060ca <alltraps>

80106c0f <vector166>:
.globl vector166
vector166:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $166
80106c11:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106c16:	e9 af f4 ff ff       	jmp    801060ca <alltraps>

80106c1b <vector167>:
.globl vector167
vector167:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $167
80106c1d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106c22:	e9 a3 f4 ff ff       	jmp    801060ca <alltraps>

80106c27 <vector168>:
.globl vector168
vector168:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $168
80106c29:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106c2e:	e9 97 f4 ff ff       	jmp    801060ca <alltraps>

80106c33 <vector169>:
.globl vector169
vector169:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $169
80106c35:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106c3a:	e9 8b f4 ff ff       	jmp    801060ca <alltraps>

80106c3f <vector170>:
.globl vector170
vector170:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $170
80106c41:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106c46:	e9 7f f4 ff ff       	jmp    801060ca <alltraps>

80106c4b <vector171>:
.globl vector171
vector171:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $171
80106c4d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106c52:	e9 73 f4 ff ff       	jmp    801060ca <alltraps>

80106c57 <vector172>:
.globl vector172
vector172:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $172
80106c59:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106c5e:	e9 67 f4 ff ff       	jmp    801060ca <alltraps>

80106c63 <vector173>:
.globl vector173
vector173:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $173
80106c65:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106c6a:	e9 5b f4 ff ff       	jmp    801060ca <alltraps>

80106c6f <vector174>:
.globl vector174
vector174:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $174
80106c71:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106c76:	e9 4f f4 ff ff       	jmp    801060ca <alltraps>

80106c7b <vector175>:
.globl vector175
vector175:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $175
80106c7d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106c82:	e9 43 f4 ff ff       	jmp    801060ca <alltraps>

80106c87 <vector176>:
.globl vector176
vector176:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $176
80106c89:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106c8e:	e9 37 f4 ff ff       	jmp    801060ca <alltraps>

80106c93 <vector177>:
.globl vector177
vector177:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $177
80106c95:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106c9a:	e9 2b f4 ff ff       	jmp    801060ca <alltraps>

80106c9f <vector178>:
.globl vector178
vector178:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $178
80106ca1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106ca6:	e9 1f f4 ff ff       	jmp    801060ca <alltraps>

80106cab <vector179>:
.globl vector179
vector179:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $179
80106cad:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106cb2:	e9 13 f4 ff ff       	jmp    801060ca <alltraps>

80106cb7 <vector180>:
.globl vector180
vector180:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $180
80106cb9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106cbe:	e9 07 f4 ff ff       	jmp    801060ca <alltraps>

80106cc3 <vector181>:
.globl vector181
vector181:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $181
80106cc5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106cca:	e9 fb f3 ff ff       	jmp    801060ca <alltraps>

80106ccf <vector182>:
.globl vector182
vector182:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $182
80106cd1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106cd6:	e9 ef f3 ff ff       	jmp    801060ca <alltraps>

80106cdb <vector183>:
.globl vector183
vector183:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $183
80106cdd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106ce2:	e9 e3 f3 ff ff       	jmp    801060ca <alltraps>

80106ce7 <vector184>:
.globl vector184
vector184:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $184
80106ce9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106cee:	e9 d7 f3 ff ff       	jmp    801060ca <alltraps>

80106cf3 <vector185>:
.globl vector185
vector185:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $185
80106cf5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106cfa:	e9 cb f3 ff ff       	jmp    801060ca <alltraps>

80106cff <vector186>:
.globl vector186
vector186:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $186
80106d01:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106d06:	e9 bf f3 ff ff       	jmp    801060ca <alltraps>

80106d0b <vector187>:
.globl vector187
vector187:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $187
80106d0d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106d12:	e9 b3 f3 ff ff       	jmp    801060ca <alltraps>

80106d17 <vector188>:
.globl vector188
vector188:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $188
80106d19:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106d1e:	e9 a7 f3 ff ff       	jmp    801060ca <alltraps>

80106d23 <vector189>:
.globl vector189
vector189:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $189
80106d25:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106d2a:	e9 9b f3 ff ff       	jmp    801060ca <alltraps>

80106d2f <vector190>:
.globl vector190
vector190:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $190
80106d31:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106d36:	e9 8f f3 ff ff       	jmp    801060ca <alltraps>

80106d3b <vector191>:
.globl vector191
vector191:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $191
80106d3d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106d42:	e9 83 f3 ff ff       	jmp    801060ca <alltraps>

80106d47 <vector192>:
.globl vector192
vector192:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $192
80106d49:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106d4e:	e9 77 f3 ff ff       	jmp    801060ca <alltraps>

80106d53 <vector193>:
.globl vector193
vector193:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $193
80106d55:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106d5a:	e9 6b f3 ff ff       	jmp    801060ca <alltraps>

80106d5f <vector194>:
.globl vector194
vector194:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $194
80106d61:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106d66:	e9 5f f3 ff ff       	jmp    801060ca <alltraps>

80106d6b <vector195>:
.globl vector195
vector195:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $195
80106d6d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106d72:	e9 53 f3 ff ff       	jmp    801060ca <alltraps>

80106d77 <vector196>:
.globl vector196
vector196:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $196
80106d79:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106d7e:	e9 47 f3 ff ff       	jmp    801060ca <alltraps>

80106d83 <vector197>:
.globl vector197
vector197:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $197
80106d85:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106d8a:	e9 3b f3 ff ff       	jmp    801060ca <alltraps>

80106d8f <vector198>:
.globl vector198
vector198:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $198
80106d91:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106d96:	e9 2f f3 ff ff       	jmp    801060ca <alltraps>

80106d9b <vector199>:
.globl vector199
vector199:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $199
80106d9d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106da2:	e9 23 f3 ff ff       	jmp    801060ca <alltraps>

80106da7 <vector200>:
.globl vector200
vector200:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $200
80106da9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106dae:	e9 17 f3 ff ff       	jmp    801060ca <alltraps>

80106db3 <vector201>:
.globl vector201
vector201:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $201
80106db5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106dba:	e9 0b f3 ff ff       	jmp    801060ca <alltraps>

80106dbf <vector202>:
.globl vector202
vector202:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $202
80106dc1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106dc6:	e9 ff f2 ff ff       	jmp    801060ca <alltraps>

80106dcb <vector203>:
.globl vector203
vector203:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $203
80106dcd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106dd2:	e9 f3 f2 ff ff       	jmp    801060ca <alltraps>

80106dd7 <vector204>:
.globl vector204
vector204:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $204
80106dd9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106dde:	e9 e7 f2 ff ff       	jmp    801060ca <alltraps>

80106de3 <vector205>:
.globl vector205
vector205:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $205
80106de5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106dea:	e9 db f2 ff ff       	jmp    801060ca <alltraps>

80106def <vector206>:
.globl vector206
vector206:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $206
80106df1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106df6:	e9 cf f2 ff ff       	jmp    801060ca <alltraps>

80106dfb <vector207>:
.globl vector207
vector207:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $207
80106dfd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106e02:	e9 c3 f2 ff ff       	jmp    801060ca <alltraps>

80106e07 <vector208>:
.globl vector208
vector208:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $208
80106e09:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106e0e:	e9 b7 f2 ff ff       	jmp    801060ca <alltraps>

80106e13 <vector209>:
.globl vector209
vector209:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $209
80106e15:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106e1a:	e9 ab f2 ff ff       	jmp    801060ca <alltraps>

80106e1f <vector210>:
.globl vector210
vector210:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $210
80106e21:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106e26:	e9 9f f2 ff ff       	jmp    801060ca <alltraps>

80106e2b <vector211>:
.globl vector211
vector211:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $211
80106e2d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106e32:	e9 93 f2 ff ff       	jmp    801060ca <alltraps>

80106e37 <vector212>:
.globl vector212
vector212:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $212
80106e39:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106e3e:	e9 87 f2 ff ff       	jmp    801060ca <alltraps>

80106e43 <vector213>:
.globl vector213
vector213:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $213
80106e45:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106e4a:	e9 7b f2 ff ff       	jmp    801060ca <alltraps>

80106e4f <vector214>:
.globl vector214
vector214:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $214
80106e51:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106e56:	e9 6f f2 ff ff       	jmp    801060ca <alltraps>

80106e5b <vector215>:
.globl vector215
vector215:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $215
80106e5d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106e62:	e9 63 f2 ff ff       	jmp    801060ca <alltraps>

80106e67 <vector216>:
.globl vector216
vector216:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $216
80106e69:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106e6e:	e9 57 f2 ff ff       	jmp    801060ca <alltraps>

80106e73 <vector217>:
.globl vector217
vector217:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $217
80106e75:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106e7a:	e9 4b f2 ff ff       	jmp    801060ca <alltraps>

80106e7f <vector218>:
.globl vector218
vector218:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $218
80106e81:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106e86:	e9 3f f2 ff ff       	jmp    801060ca <alltraps>

80106e8b <vector219>:
.globl vector219
vector219:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $219
80106e8d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106e92:	e9 33 f2 ff ff       	jmp    801060ca <alltraps>

80106e97 <vector220>:
.globl vector220
vector220:
  pushl $0
80106e97:	6a 00                	push   $0x0
  pushl $220
80106e99:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106e9e:	e9 27 f2 ff ff       	jmp    801060ca <alltraps>

80106ea3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106ea3:	6a 00                	push   $0x0
  pushl $221
80106ea5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106eaa:	e9 1b f2 ff ff       	jmp    801060ca <alltraps>

80106eaf <vector222>:
.globl vector222
vector222:
  pushl $0
80106eaf:	6a 00                	push   $0x0
  pushl $222
80106eb1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106eb6:	e9 0f f2 ff ff       	jmp    801060ca <alltraps>

80106ebb <vector223>:
.globl vector223
vector223:
  pushl $0
80106ebb:	6a 00                	push   $0x0
  pushl $223
80106ebd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106ec2:	e9 03 f2 ff ff       	jmp    801060ca <alltraps>

80106ec7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106ec7:	6a 00                	push   $0x0
  pushl $224
80106ec9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106ece:	e9 f7 f1 ff ff       	jmp    801060ca <alltraps>

80106ed3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106ed3:	6a 00                	push   $0x0
  pushl $225
80106ed5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106eda:	e9 eb f1 ff ff       	jmp    801060ca <alltraps>

80106edf <vector226>:
.globl vector226
vector226:
  pushl $0
80106edf:	6a 00                	push   $0x0
  pushl $226
80106ee1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106ee6:	e9 df f1 ff ff       	jmp    801060ca <alltraps>

80106eeb <vector227>:
.globl vector227
vector227:
  pushl $0
80106eeb:	6a 00                	push   $0x0
  pushl $227
80106eed:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106ef2:	e9 d3 f1 ff ff       	jmp    801060ca <alltraps>

80106ef7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106ef7:	6a 00                	push   $0x0
  pushl $228
80106ef9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106efe:	e9 c7 f1 ff ff       	jmp    801060ca <alltraps>

80106f03 <vector229>:
.globl vector229
vector229:
  pushl $0
80106f03:	6a 00                	push   $0x0
  pushl $229
80106f05:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106f0a:	e9 bb f1 ff ff       	jmp    801060ca <alltraps>

80106f0f <vector230>:
.globl vector230
vector230:
  pushl $0
80106f0f:	6a 00                	push   $0x0
  pushl $230
80106f11:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106f16:	e9 af f1 ff ff       	jmp    801060ca <alltraps>

80106f1b <vector231>:
.globl vector231
vector231:
  pushl $0
80106f1b:	6a 00                	push   $0x0
  pushl $231
80106f1d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106f22:	e9 a3 f1 ff ff       	jmp    801060ca <alltraps>

80106f27 <vector232>:
.globl vector232
vector232:
  pushl $0
80106f27:	6a 00                	push   $0x0
  pushl $232
80106f29:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106f2e:	e9 97 f1 ff ff       	jmp    801060ca <alltraps>

80106f33 <vector233>:
.globl vector233
vector233:
  pushl $0
80106f33:	6a 00                	push   $0x0
  pushl $233
80106f35:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106f3a:	e9 8b f1 ff ff       	jmp    801060ca <alltraps>

80106f3f <vector234>:
.globl vector234
vector234:
  pushl $0
80106f3f:	6a 00                	push   $0x0
  pushl $234
80106f41:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106f46:	e9 7f f1 ff ff       	jmp    801060ca <alltraps>

80106f4b <vector235>:
.globl vector235
vector235:
  pushl $0
80106f4b:	6a 00                	push   $0x0
  pushl $235
80106f4d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106f52:	e9 73 f1 ff ff       	jmp    801060ca <alltraps>

80106f57 <vector236>:
.globl vector236
vector236:
  pushl $0
80106f57:	6a 00                	push   $0x0
  pushl $236
80106f59:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106f5e:	e9 67 f1 ff ff       	jmp    801060ca <alltraps>

80106f63 <vector237>:
.globl vector237
vector237:
  pushl $0
80106f63:	6a 00                	push   $0x0
  pushl $237
80106f65:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106f6a:	e9 5b f1 ff ff       	jmp    801060ca <alltraps>

80106f6f <vector238>:
.globl vector238
vector238:
  pushl $0
80106f6f:	6a 00                	push   $0x0
  pushl $238
80106f71:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106f76:	e9 4f f1 ff ff       	jmp    801060ca <alltraps>

80106f7b <vector239>:
.globl vector239
vector239:
  pushl $0
80106f7b:	6a 00                	push   $0x0
  pushl $239
80106f7d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106f82:	e9 43 f1 ff ff       	jmp    801060ca <alltraps>

80106f87 <vector240>:
.globl vector240
vector240:
  pushl $0
80106f87:	6a 00                	push   $0x0
  pushl $240
80106f89:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106f8e:	e9 37 f1 ff ff       	jmp    801060ca <alltraps>

80106f93 <vector241>:
.globl vector241
vector241:
  pushl $0
80106f93:	6a 00                	push   $0x0
  pushl $241
80106f95:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106f9a:	e9 2b f1 ff ff       	jmp    801060ca <alltraps>

80106f9f <vector242>:
.globl vector242
vector242:
  pushl $0
80106f9f:	6a 00                	push   $0x0
  pushl $242
80106fa1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106fa6:	e9 1f f1 ff ff       	jmp    801060ca <alltraps>

80106fab <vector243>:
.globl vector243
vector243:
  pushl $0
80106fab:	6a 00                	push   $0x0
  pushl $243
80106fad:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106fb2:	e9 13 f1 ff ff       	jmp    801060ca <alltraps>

80106fb7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106fb7:	6a 00                	push   $0x0
  pushl $244
80106fb9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106fbe:	e9 07 f1 ff ff       	jmp    801060ca <alltraps>

80106fc3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106fc3:	6a 00                	push   $0x0
  pushl $245
80106fc5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106fca:	e9 fb f0 ff ff       	jmp    801060ca <alltraps>

80106fcf <vector246>:
.globl vector246
vector246:
  pushl $0
80106fcf:	6a 00                	push   $0x0
  pushl $246
80106fd1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106fd6:	e9 ef f0 ff ff       	jmp    801060ca <alltraps>

80106fdb <vector247>:
.globl vector247
vector247:
  pushl $0
80106fdb:	6a 00                	push   $0x0
  pushl $247
80106fdd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106fe2:	e9 e3 f0 ff ff       	jmp    801060ca <alltraps>

80106fe7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106fe7:	6a 00                	push   $0x0
  pushl $248
80106fe9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106fee:	e9 d7 f0 ff ff       	jmp    801060ca <alltraps>

80106ff3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106ff3:	6a 00                	push   $0x0
  pushl $249
80106ff5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106ffa:	e9 cb f0 ff ff       	jmp    801060ca <alltraps>

80106fff <vector250>:
.globl vector250
vector250:
  pushl $0
80106fff:	6a 00                	push   $0x0
  pushl $250
80107001:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107006:	e9 bf f0 ff ff       	jmp    801060ca <alltraps>

8010700b <vector251>:
.globl vector251
vector251:
  pushl $0
8010700b:	6a 00                	push   $0x0
  pushl $251
8010700d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107012:	e9 b3 f0 ff ff       	jmp    801060ca <alltraps>

80107017 <vector252>:
.globl vector252
vector252:
  pushl $0
80107017:	6a 00                	push   $0x0
  pushl $252
80107019:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010701e:	e9 a7 f0 ff ff       	jmp    801060ca <alltraps>

80107023 <vector253>:
.globl vector253
vector253:
  pushl $0
80107023:	6a 00                	push   $0x0
  pushl $253
80107025:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010702a:	e9 9b f0 ff ff       	jmp    801060ca <alltraps>

8010702f <vector254>:
.globl vector254
vector254:
  pushl $0
8010702f:	6a 00                	push   $0x0
  pushl $254
80107031:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107036:	e9 8f f0 ff ff       	jmp    801060ca <alltraps>

8010703b <vector255>:
.globl vector255
vector255:
  pushl $0
8010703b:	6a 00                	push   $0x0
  pushl $255
8010703d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107042:	e9 83 f0 ff ff       	jmp    801060ca <alltraps>
80107047:	66 90                	xchg   %ax,%ax
80107049:	66 90                	xchg   %ax,%ax
8010704b:	66 90                	xchg   %ax,%ax
8010704d:	66 90                	xchg   %ax,%ax
8010704f:	90                   	nop

80107050 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107050:	55                   	push   %ebp
80107051:	89 e5                	mov    %esp,%ebp
80107053:	57                   	push   %edi
80107054:	56                   	push   %esi
80107055:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107056:	89 d3                	mov    %edx,%ebx
80107058:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010705e:	83 ec 1c             	sub    $0x1c,%esp
80107061:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107064:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107068:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010706d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107070:	8b 45 08             	mov    0x8(%ebp),%eax
80107073:	29 d8                	sub    %ebx,%eax
80107075:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107078:	eb 3d                	jmp    801070b7 <mappages+0x67>
8010707a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107080:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107082:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107087:	c1 ea 0a             	shr    $0xa,%edx
8010708a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107090:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107097:	85 c0                	test   %eax,%eax
80107099:	74 75                	je     80107110 <mappages+0xc0>
      return -1;
    if(*pte & PTE_P)
8010709b:	f6 00 01             	testb  $0x1,(%eax)
8010709e:	0f 85 86 00 00 00    	jne    8010712a <mappages+0xda>
      panic("remap");
    *pte = pa | perm | PTE_P;
801070a4:	0b 75 0c             	or     0xc(%ebp),%esi
801070a7:	83 ce 01             	or     $0x1,%esi
801070aa:	89 30                	mov    %esi,(%eax)
    if(a == last)
801070ac:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
801070af:	74 6f                	je     80107120 <mappages+0xd0>
      break;
    a += PGSIZE;
801070b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
801070b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
801070ba:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801070bd:	8d 34 18             	lea    (%eax,%ebx,1),%esi
801070c0:	89 d8                	mov    %ebx,%eax
801070c2:	c1 e8 16             	shr    $0x16,%eax
801070c5:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
801070c8:	8b 07                	mov    (%edi),%eax
801070ca:	a8 01                	test   $0x1,%al
801070cc:	75 b2                	jne    80107080 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801070ce:	e8 2d ba ff ff       	call   80102b00 <kalloc>
801070d3:	85 c0                	test   %eax,%eax
801070d5:	74 39                	je     80107110 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
801070d7:	83 ec 04             	sub    $0x4,%esp
801070da:	89 45 d8             	mov    %eax,-0x28(%ebp)
801070dd:	68 00 10 00 00       	push   $0x1000
801070e2:	6a 00                	push   $0x0
801070e4:	50                   	push   %eax
801070e5:	e8 e6 dd ff ff       	call   80104ed0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801070ea:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
801070ed:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801070f0:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
801070f6:	83 c8 07             	or     $0x7,%eax
801070f9:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
801070fb:	89 d8                	mov    %ebx,%eax
801070fd:	c1 e8 0a             	shr    $0xa,%eax
80107100:	25 fc 0f 00 00       	and    $0xffc,%eax
80107105:	01 d0                	add    %edx,%eax
80107107:	eb 92                	jmp    8010709b <mappages+0x4b>
80107109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pa += PGSIZE;
  }
  return 0;
}
80107110:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107113:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107118:	5b                   	pop    %ebx
80107119:	5e                   	pop    %esi
8010711a:	5f                   	pop    %edi
8010711b:	5d                   	pop    %ebp
8010711c:	c3                   	ret    
8010711d:	8d 76 00             	lea    0x0(%esi),%esi
80107120:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107123:	31 c0                	xor    %eax,%eax
}
80107125:	5b                   	pop    %ebx
80107126:	5e                   	pop    %esi
80107127:	5f                   	pop    %edi
80107128:	5d                   	pop    %ebp
80107129:	c3                   	ret    
      panic("remap");
8010712a:	83 ec 0c             	sub    $0xc,%esp
8010712d:	68 58 88 10 80       	push   $0x80108858
80107132:	e8 49 92 ff ff       	call   80100380 <panic>
80107137:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010713e:	66 90                	xchg   %ax,%ax

80107140 <seginit>:
{
80107140:	55                   	push   %ebp
80107141:	89 e5                	mov    %esp,%ebp
80107143:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107146:	e8 45 cd ff ff       	call   80103e90 <cpuid>
  pd[0] = size-1;
8010714b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107150:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107156:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010715a:	c7 80 58 68 11 80 ff 	movl   $0xffff,-0x7fee97a8(%eax)
80107161:	ff 00 00 
80107164:	c7 80 5c 68 11 80 00 	movl   $0xcf9a00,-0x7fee97a4(%eax)
8010716b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010716e:	c7 80 60 68 11 80 ff 	movl   $0xffff,-0x7fee97a0(%eax)
80107175:	ff 00 00 
80107178:	c7 80 64 68 11 80 00 	movl   $0xcf9200,-0x7fee979c(%eax)
8010717f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107182:	c7 80 68 68 11 80 ff 	movl   $0xffff,-0x7fee9798(%eax)
80107189:	ff 00 00 
8010718c:	c7 80 6c 68 11 80 00 	movl   $0xcffa00,-0x7fee9794(%eax)
80107193:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107196:	c7 80 70 68 11 80 ff 	movl   $0xffff,-0x7fee9790(%eax)
8010719d:	ff 00 00 
801071a0:	c7 80 74 68 11 80 00 	movl   $0xcff200,-0x7fee978c(%eax)
801071a7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801071aa:	05 50 68 11 80       	add    $0x80116850,%eax
  pd[1] = (uint)p;
801071af:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801071b3:	c1 e8 10             	shr    $0x10,%eax
801071b6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801071ba:	8d 45 f2             	lea    -0xe(%ebp),%eax
801071bd:	0f 01 10             	lgdtl  (%eax)
}
801071c0:	c9                   	leave  
801071c1:	c3                   	ret    
801071c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801071d0 <walkpgdir>:
{
801071d0:	55                   	push   %ebp
801071d1:	89 e5                	mov    %esp,%ebp
801071d3:	57                   	push   %edi
801071d4:	56                   	push   %esi
801071d5:	53                   	push   %ebx
801071d6:	83 ec 0c             	sub    $0xc,%esp
801071d9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pde = &pgdir[PDX(va)];
801071dc:	8b 55 08             	mov    0x8(%ebp),%edx
801071df:	89 fe                	mov    %edi,%esi
801071e1:	c1 ee 16             	shr    $0x16,%esi
801071e4:	8d 34 b2             	lea    (%edx,%esi,4),%esi
  if(*pde & PTE_P){
801071e7:	8b 1e                	mov    (%esi),%ebx
801071e9:	f6 c3 01             	test   $0x1,%bl
801071ec:	74 22                	je     80107210 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801071ee:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801071f4:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
  return &pgtab[PTX(va)];
801071fa:	89 f8                	mov    %edi,%eax
}
801071fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801071ff:	c1 e8 0a             	shr    $0xa,%eax
80107202:	25 fc 0f 00 00       	and    $0xffc,%eax
80107207:	01 d8                	add    %ebx,%eax
}
80107209:	5b                   	pop    %ebx
8010720a:	5e                   	pop    %esi
8010720b:	5f                   	pop    %edi
8010720c:	5d                   	pop    %ebp
8010720d:	c3                   	ret    
8010720e:	66 90                	xchg   %ax,%ax
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107210:	8b 45 10             	mov    0x10(%ebp),%eax
80107213:	85 c0                	test   %eax,%eax
80107215:	74 31                	je     80107248 <walkpgdir+0x78>
80107217:	e8 e4 b8 ff ff       	call   80102b00 <kalloc>
8010721c:	89 c3                	mov    %eax,%ebx
8010721e:	85 c0                	test   %eax,%eax
80107220:	74 26                	je     80107248 <walkpgdir+0x78>
    memset(pgtab, 0, PGSIZE);
80107222:	83 ec 04             	sub    $0x4,%esp
80107225:	68 00 10 00 00       	push   $0x1000
8010722a:	6a 00                	push   $0x0
8010722c:	50                   	push   %eax
8010722d:	e8 9e dc ff ff       	call   80104ed0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107232:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107238:	83 c4 10             	add    $0x10,%esp
8010723b:	83 c8 07             	or     $0x7,%eax
8010723e:	89 06                	mov    %eax,(%esi)
80107240:	eb b8                	jmp    801071fa <walkpgdir+0x2a>
80107242:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80107248:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
8010724b:	31 c0                	xor    %eax,%eax
}
8010724d:	5b                   	pop    %ebx
8010724e:	5e                   	pop    %esi
8010724f:	5f                   	pop    %edi
80107250:	5d                   	pop    %ebp
80107251:	c3                   	ret    
80107252:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107260 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107260:	a1 04 96 11 80       	mov    0x80119604,%eax
80107265:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010726a:	0f 22 d8             	mov    %eax,%cr3
}
8010726d:	c3                   	ret    
8010726e:	66 90                	xchg   %ax,%ax

80107270 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107270:	55                   	push   %ebp
80107271:	89 e5                	mov    %esp,%ebp
80107273:	57                   	push   %edi
80107274:	56                   	push   %esi
80107275:	53                   	push   %ebx
80107276:	83 ec 1c             	sub    $0x1c,%esp
80107279:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010727c:	85 f6                	test   %esi,%esi
8010727e:	0f 84 cb 00 00 00    	je     8010734f <switchuvm+0xdf>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80107284:	8b 46 0c             	mov    0xc(%esi),%eax
80107287:	85 c0                	test   %eax,%eax
80107289:	0f 84 da 00 00 00    	je     80107369 <switchuvm+0xf9>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
8010728f:	8b 46 08             	mov    0x8(%esi),%eax
80107292:	85 c0                	test   %eax,%eax
80107294:	0f 84 c2 00 00 00    	je     8010735c <switchuvm+0xec>
    panic("switchuvm: no pgdir");

  pushcli();
8010729a:	e8 21 da ff ff       	call   80104cc0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010729f:	e8 8c cb ff ff       	call   80103e30 <mycpu>
801072a4:	89 c3                	mov    %eax,%ebx
801072a6:	e8 85 cb ff ff       	call   80103e30 <mycpu>
801072ab:	89 c7                	mov    %eax,%edi
801072ad:	e8 7e cb ff ff       	call   80103e30 <mycpu>
801072b2:	83 c7 08             	add    $0x8,%edi
801072b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801072b8:	e8 73 cb ff ff       	call   80103e30 <mycpu>
801072bd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801072c0:	ba 67 00 00 00       	mov    $0x67,%edx
801072c5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801072cc:	83 c0 08             	add    $0x8,%eax
801072cf:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801072d6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801072db:	83 c1 08             	add    $0x8,%ecx
801072de:	c1 e8 18             	shr    $0x18,%eax
801072e1:	c1 e9 10             	shr    $0x10,%ecx
801072e4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801072ea:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801072f0:	b9 99 40 00 00       	mov    $0x4099,%ecx
801072f5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801072fc:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107301:	e8 2a cb ff ff       	call   80103e30 <mycpu>
80107306:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010730d:	e8 1e cb ff ff       	call   80103e30 <mycpu>
80107312:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107316:	8b 5e 0c             	mov    0xc(%esi),%ebx
80107319:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010731f:	e8 0c cb ff ff       	call   80103e30 <mycpu>
80107324:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107327:	e8 04 cb ff ff       	call   80103e30 <mycpu>
8010732c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107330:	b8 28 00 00 00       	mov    $0x28,%eax
80107335:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107338:	8b 46 08             	mov    0x8(%esi),%eax
8010733b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107340:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80107343:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107346:	5b                   	pop    %ebx
80107347:	5e                   	pop    %esi
80107348:	5f                   	pop    %edi
80107349:	5d                   	pop    %ebp
  popcli();
8010734a:	e9 c1 d9 ff ff       	jmp    80104d10 <popcli>
    panic("switchuvm: no process");
8010734f:	83 ec 0c             	sub    $0xc,%esp
80107352:	68 5e 88 10 80       	push   $0x8010885e
80107357:	e8 24 90 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
8010735c:	83 ec 0c             	sub    $0xc,%esp
8010735f:	68 89 88 10 80       	push   $0x80108889
80107364:	e8 17 90 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80107369:	83 ec 0c             	sub    $0xc,%esp
8010736c:	68 74 88 10 80       	push   $0x80108874
80107371:	e8 0a 90 ff ff       	call   80100380 <panic>
80107376:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010737d:	8d 76 00             	lea    0x0(%esi),%esi

80107380 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107380:	55                   	push   %ebp
80107381:	89 e5                	mov    %esp,%ebp
80107383:	57                   	push   %edi
80107384:	56                   	push   %esi
80107385:	53                   	push   %ebx
80107386:	83 ec 1c             	sub    $0x1c,%esp
80107389:	8b 45 0c             	mov    0xc(%ebp),%eax
8010738c:	8b 75 10             	mov    0x10(%ebp),%esi
8010738f:	8b 7d 08             	mov    0x8(%ebp),%edi
80107392:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
80107395:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010739b:	77 4b                	ja     801073e8 <inituvm+0x68>
    panic("inituvm: more than a page");
  mem = kalloc();
8010739d:	e8 5e b7 ff ff       	call   80102b00 <kalloc>
  memset(mem, 0, PGSIZE);
801073a2:	83 ec 04             	sub    $0x4,%esp
801073a5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801073aa:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801073ac:	6a 00                	push   $0x0
801073ae:	50                   	push   %eax
801073af:	e8 1c db ff ff       	call   80104ed0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801073b4:	58                   	pop    %eax
801073b5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801073bb:	5a                   	pop    %edx
801073bc:	6a 06                	push   $0x6
801073be:	b9 00 10 00 00       	mov    $0x1000,%ecx
801073c3:	31 d2                	xor    %edx,%edx
801073c5:	50                   	push   %eax
801073c6:	89 f8                	mov    %edi,%eax
801073c8:	e8 83 fc ff ff       	call   80107050 <mappages>
  memmove(mem, init, sz);
801073cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801073d0:	89 75 10             	mov    %esi,0x10(%ebp)
801073d3:	83 c4 10             	add    $0x10,%esp
801073d6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801073d9:	89 45 0c             	mov    %eax,0xc(%ebp)
}
801073dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073df:	5b                   	pop    %ebx
801073e0:	5e                   	pop    %esi
801073e1:	5f                   	pop    %edi
801073e2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801073e3:	e9 88 db ff ff       	jmp    80104f70 <memmove>
    panic("inituvm: more than a page");
801073e8:	83 ec 0c             	sub    $0xc,%esp
801073eb:	68 9d 88 10 80       	push   $0x8010889d
801073f0:	e8 8b 8f ff ff       	call   80100380 <panic>
801073f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107400 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107400:	55                   	push   %ebp
80107401:	89 e5                	mov    %esp,%ebp
80107403:	57                   	push   %edi
80107404:	56                   	push   %esi
80107405:	53                   	push   %ebx
80107406:	83 ec 1c             	sub    $0x1c,%esp
80107409:	8b 45 0c             	mov    0xc(%ebp),%eax
8010740c:	8b 75 18             	mov    0x18(%ebp),%esi
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
8010740f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107414:	0f 85 bb 00 00 00    	jne    801074d5 <loaduvm+0xd5>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
8010741a:	01 f0                	add    %esi,%eax
8010741c:	89 f3                	mov    %esi,%ebx
8010741e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107421:	8b 45 14             	mov    0x14(%ebp),%eax
80107424:	01 f0                	add    %esi,%eax
80107426:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107429:	85 f6                	test   %esi,%esi
8010742b:	0f 84 87 00 00 00    	je     801074b8 <loaduvm+0xb8>
80107431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107438:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
8010743b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010743e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107440:	89 c2                	mov    %eax,%edx
80107442:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107445:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107448:	f6 c2 01             	test   $0x1,%dl
8010744b:	75 13                	jne    80107460 <loaduvm+0x60>
      panic("loaduvm: address should exist");
8010744d:	83 ec 0c             	sub    $0xc,%esp
80107450:	68 b7 88 10 80       	push   $0x801088b7
80107455:	e8 26 8f ff ff       	call   80100380 <panic>
8010745a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107460:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107463:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107469:	25 fc 0f 00 00       	and    $0xffc,%eax
8010746e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107475:	85 c0                	test   %eax,%eax
80107477:	74 d4                	je     8010744d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107479:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010747b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010747e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107483:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107488:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010748e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107491:	29 d9                	sub    %ebx,%ecx
80107493:	05 00 00 00 80       	add    $0x80000000,%eax
80107498:	57                   	push   %edi
80107499:	51                   	push   %ecx
8010749a:	50                   	push   %eax
8010749b:	ff 75 10             	push   0x10(%ebp)
8010749e:	e8 0d a6 ff ff       	call   80101ab0 <readi>
801074a3:	83 c4 10             	add    $0x10,%esp
801074a6:	39 f8                	cmp    %edi,%eax
801074a8:	75 1e                	jne    801074c8 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801074aa:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801074b0:	89 f0                	mov    %esi,%eax
801074b2:	29 d8                	sub    %ebx,%eax
801074b4:	39 c6                	cmp    %eax,%esi
801074b6:	77 80                	ja     80107438 <loaduvm+0x38>
      return -1;
  }
  return 0;
}
801074b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801074bb:	31 c0                	xor    %eax,%eax
}
801074bd:	5b                   	pop    %ebx
801074be:	5e                   	pop    %esi
801074bf:	5f                   	pop    %edi
801074c0:	5d                   	pop    %ebp
801074c1:	c3                   	ret    
801074c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801074c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801074cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801074d0:	5b                   	pop    %ebx
801074d1:	5e                   	pop    %esi
801074d2:	5f                   	pop    %edi
801074d3:	5d                   	pop    %ebp
801074d4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
801074d5:	83 ec 0c             	sub    $0xc,%esp
801074d8:	68 60 89 10 80       	push   $0x80108960
801074dd:	e8 9e 8e ff ff       	call   80100380 <panic>
801074e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801074f0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801074f0:	55                   	push   %ebp
801074f1:	89 e5                	mov    %esp,%ebp
801074f3:	57                   	push   %edi
801074f4:	56                   	push   %esi
801074f5:	53                   	push   %ebx
801074f6:	83 ec 1c             	sub    $0x1c,%esp
801074f9:	8b 75 0c             	mov    0xc(%ebp),%esi
801074fc:	8b 7d 08             	mov    0x8(%ebp),%edi
  pte_t *pte;
  uint a, pa;
  struct proc* p=myproc();
801074ff:	e8 ac c9 ff ff       	call   80103eb0 <myproc>
80107504:	89 45 e0             	mov    %eax,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;
80107507:	89 f0                	mov    %esi,%eax
  if(newsz >= oldsz)
80107509:	39 75 10             	cmp    %esi,0x10(%ebp)
8010750c:	73 31                	jae    8010753f <deallocuvm+0x4f>

  a = PGROUNDUP(newsz);
8010750e:	8b 45 10             	mov    0x10(%ebp),%eax
80107511:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107517:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010751d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; a  < oldsz; a += PGSIZE){
80107520:	39 de                	cmp    %ebx,%esi
80107522:	76 18                	jbe    8010753c <deallocuvm+0x4c>
  pde = &pgdir[PDX(va)];
80107524:	89 da                	mov    %ebx,%edx
80107526:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107529:	8b 04 97             	mov    (%edi,%edx,4),%eax
8010752c:	a8 01                	test   $0x1,%al
8010752e:	75 20                	jne    80107550 <deallocuvm+0x60>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107530:	83 c2 01             	add    $0x1,%edx
80107533:	89 d3                	mov    %edx,%ebx
80107535:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107538:	39 de                	cmp    %ebx,%esi
8010753a:	77 e8                	ja     80107524 <deallocuvm+0x34>
      kfree(v);
      p->rss-=4096;
      *pte = 0;
    }
  }
  return newsz;
8010753c:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010753f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107542:	5b                   	pop    %ebx
80107543:	5e                   	pop    %esi
80107544:	5f                   	pop    %edi
80107545:	5d                   	pop    %ebp
80107546:	c3                   	ret    
80107547:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010754e:	66 90                	xchg   %ax,%ax
  return &pgtab[PTX(va)];
80107550:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107552:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107557:	c1 e9 0a             	shr    $0xa,%ecx
8010755a:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80107560:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80107567:	85 c0                	test   %eax,%eax
80107569:	74 c5                	je     80107530 <deallocuvm+0x40>
    else if((*pte & PTE_P) != 0){
8010756b:	8b 10                	mov    (%eax),%edx
8010756d:	f6 c2 01             	test   $0x1,%dl
80107570:	75 0e                	jne    80107580 <deallocuvm+0x90>
  for(; a  < oldsz; a += PGSIZE){
80107572:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107578:	eb a6                	jmp    80107520 <deallocuvm+0x30>
8010757a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(pa == 0)
80107580:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107586:	74 33                	je     801075bb <deallocuvm+0xcb>
      kfree(v);
80107588:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010758b:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107591:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107594:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
8010759a:	52                   	push   %edx
8010759b:	e8 b0 b2 ff ff       	call   80102850 <kfree>
      p->rss-=4096;
801075a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
801075a3:	83 c4 10             	add    $0x10,%esp
      p->rss-=4096;
801075a6:	81 68 04 00 10 00 00 	subl   $0x1000,0x4(%eax)
      *pte = 0;
801075ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801075b6:	e9 65 ff ff ff       	jmp    80107520 <deallocuvm+0x30>
        panic("kfree");
801075bb:	83 ec 0c             	sub    $0xc,%esp
801075be:	68 2e 81 10 80       	push   $0x8010812e
801075c3:	e8 b8 8d ff ff       	call   80100380 <panic>
801075c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075cf:	90                   	nop

801075d0 <allocuvm>:
{
801075d0:	55                   	push   %ebp
801075d1:	89 e5                	mov    %esp,%ebp
801075d3:	57                   	push   %edi
801075d4:	56                   	push   %esi
801075d5:	53                   	push   %ebx
801075d6:	83 ec 1c             	sub    $0x1c,%esp
  struct proc*p=myproc();
801075d9:	e8 d2 c8 ff ff       	call   80103eb0 <myproc>
801075de:	89 c7                	mov    %eax,%edi
  if(newsz >= KERNBASE)
801075e0:	8b 45 10             	mov    0x10(%ebp),%eax
801075e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801075e6:	85 c0                	test   %eax,%eax
801075e8:	0f 88 c2 00 00 00    	js     801076b0 <allocuvm+0xe0>
  if(newsz < oldsz)
801075ee:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801075f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801075f4:	0f 82 9e 00 00 00    	jb     80107698 <allocuvm+0xc8>
  a = PGROUNDUP(oldsz);
801075fa:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107600:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107606:	39 75 10             	cmp    %esi,0x10(%ebp)
80107609:	77 4c                	ja     80107657 <allocuvm+0x87>
8010760b:	e9 8b 00 00 00       	jmp    8010769b <allocuvm+0xcb>
    memset(mem, 0, PGSIZE);
80107610:	83 ec 04             	sub    $0x4,%esp
80107613:	68 00 10 00 00       	push   $0x1000
80107618:	6a 00                	push   $0x0
8010761a:	50                   	push   %eax
8010761b:	e8 b0 d8 ff ff       	call   80104ed0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107620:	58                   	pop    %eax
80107621:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107627:	5a                   	pop    %edx
80107628:	6a 06                	push   $0x6
8010762a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010762f:	89 f2                	mov    %esi,%edx
80107631:	50                   	push   %eax
80107632:	8b 45 08             	mov    0x8(%ebp),%eax
80107635:	e8 16 fa ff ff       	call   80107050 <mappages>
8010763a:	83 c4 10             	add    $0x10,%esp
8010763d:	85 c0                	test   %eax,%eax
8010763f:	0f 88 83 00 00 00    	js     801076c8 <allocuvm+0xf8>
    p->rss+=4096;
80107645:	81 47 04 00 10 00 00 	addl   $0x1000,0x4(%edi)
  for(; a < newsz; a += PGSIZE){
8010764c:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107652:	39 75 10             	cmp    %esi,0x10(%ebp)
80107655:	76 44                	jbe    8010769b <allocuvm+0xcb>
    mem = kalloc();
80107657:	e8 a4 b4 ff ff       	call   80102b00 <kalloc>
8010765c:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
8010765e:	85 c0                	test   %eax,%eax
80107660:	75 ae                	jne    80107610 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107662:	83 ec 0c             	sub    $0xc,%esp
80107665:	68 d5 88 10 80       	push   $0x801088d5
8010766a:	e8 31 90 ff ff       	call   801006a0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010766f:	83 c4 0c             	add    $0xc,%esp
80107672:	ff 75 0c             	push   0xc(%ebp)
80107675:	ff 75 10             	push   0x10(%ebp)
80107678:	ff 75 08             	push   0x8(%ebp)
8010767b:	e8 70 fe ff ff       	call   801074f0 <deallocuvm>
      return 0;
80107680:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107687:	83 c4 10             	add    $0x10,%esp
}
8010768a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010768d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107690:	5b                   	pop    %ebx
80107691:	5e                   	pop    %esi
80107692:	5f                   	pop    %edi
80107693:	5d                   	pop    %ebp
80107694:	c3                   	ret    
80107695:	8d 76 00             	lea    0x0(%esi),%esi
    return oldsz;
80107698:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
8010769b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010769e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076a1:	5b                   	pop    %ebx
801076a2:	5e                   	pop    %esi
801076a3:	5f                   	pop    %edi
801076a4:	5d                   	pop    %ebp
801076a5:	c3                   	ret    
801076a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076ad:	8d 76 00             	lea    0x0(%esi),%esi
    return 0;
801076b0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801076b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076bd:	5b                   	pop    %ebx
801076be:	5e                   	pop    %esi
801076bf:	5f                   	pop    %edi
801076c0:	5d                   	pop    %ebp
801076c1:	c3                   	ret    
801076c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801076c8:	83 ec 0c             	sub    $0xc,%esp
801076cb:	68 ed 88 10 80       	push   $0x801088ed
801076d0:	e8 cb 8f ff ff       	call   801006a0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801076d5:	83 c4 0c             	add    $0xc,%esp
801076d8:	ff 75 0c             	push   0xc(%ebp)
801076db:	ff 75 10             	push   0x10(%ebp)
801076de:	ff 75 08             	push   0x8(%ebp)
801076e1:	e8 0a fe ff ff       	call   801074f0 <deallocuvm>
      kfree(mem);
801076e6:	89 1c 24             	mov    %ebx,(%esp)
801076e9:	e8 62 b1 ff ff       	call   80102850 <kfree>
      return 0;
801076ee:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801076f5:	83 c4 10             	add    $0x10,%esp
}
801076f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076fe:	5b                   	pop    %ebx
801076ff:	5e                   	pop    %esi
80107700:	5f                   	pop    %edi
80107701:	5d                   	pop    %ebp
80107702:	c3                   	ret    
80107703:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010770a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107710 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107710:	55                   	push   %ebp
80107711:	89 e5                	mov    %esp,%ebp
80107713:	57                   	push   %edi
80107714:	56                   	push   %esi
80107715:	53                   	push   %ebx
80107716:	83 ec 0c             	sub    $0xc,%esp
80107719:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010771c:	85 f6                	test   %esi,%esi
8010771e:	74 59                	je     80107779 <freevm+0x69>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
80107720:	83 ec 04             	sub    $0x4,%esp
80107723:	89 f3                	mov    %esi,%ebx
80107725:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010772b:	6a 00                	push   $0x0
8010772d:	68 00 00 00 80       	push   $0x80000000
80107732:	56                   	push   %esi
80107733:	e8 b8 fd ff ff       	call   801074f0 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80107738:	83 c4 10             	add    $0x10,%esp
8010773b:	eb 0a                	jmp    80107747 <freevm+0x37>
8010773d:	8d 76 00             	lea    0x0(%esi),%esi
80107740:	83 c3 04             	add    $0x4,%ebx
80107743:	39 df                	cmp    %ebx,%edi
80107745:	74 23                	je     8010776a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107747:	8b 03                	mov    (%ebx),%eax
80107749:	a8 01                	test   $0x1,%al
8010774b:	74 f3                	je     80107740 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010774d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107752:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107755:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107758:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010775d:	50                   	push   %eax
8010775e:	e8 ed b0 ff ff       	call   80102850 <kfree>
80107763:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107766:	39 df                	cmp    %ebx,%edi
80107768:	75 dd                	jne    80107747 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010776a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010776d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107770:	5b                   	pop    %ebx
80107771:	5e                   	pop    %esi
80107772:	5f                   	pop    %edi
80107773:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107774:	e9 d7 b0 ff ff       	jmp    80102850 <kfree>
    panic("freevm: no pgdir");
80107779:	83 ec 0c             	sub    $0xc,%esp
8010777c:	68 09 89 10 80       	push   $0x80108909
80107781:	e8 fa 8b ff ff       	call   80100380 <panic>
80107786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010778d:	8d 76 00             	lea    0x0(%esi),%esi

80107790 <setupkvm>:
{
80107790:	55                   	push   %ebp
80107791:	89 e5                	mov    %esp,%ebp
80107793:	56                   	push   %esi
80107794:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107795:	e8 66 b3 ff ff       	call   80102b00 <kalloc>
8010779a:	89 c6                	mov    %eax,%esi
8010779c:	85 c0                	test   %eax,%eax
8010779e:	74 42                	je     801077e2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801077a0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801077a3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801077a8:	68 00 10 00 00       	push   $0x1000
801077ad:	6a 00                	push   $0x0
801077af:	50                   	push   %eax
801077b0:	e8 1b d7 ff ff       	call   80104ed0 <memset>
801077b5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801077b8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801077bb:	83 ec 08             	sub    $0x8,%esp
801077be:	8b 4b 08             	mov    0x8(%ebx),%ecx
801077c1:	ff 73 0c             	push   0xc(%ebx)
801077c4:	8b 13                	mov    (%ebx),%edx
801077c6:	50                   	push   %eax
801077c7:	29 c1                	sub    %eax,%ecx
801077c9:	89 f0                	mov    %esi,%eax
801077cb:	e8 80 f8 ff ff       	call   80107050 <mappages>
801077d0:	83 c4 10             	add    $0x10,%esp
801077d3:	85 c0                	test   %eax,%eax
801077d5:	78 19                	js     801077f0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801077d7:	83 c3 10             	add    $0x10,%ebx
801077da:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801077e0:	75 d6                	jne    801077b8 <setupkvm+0x28>
}
801077e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801077e5:	89 f0                	mov    %esi,%eax
801077e7:	5b                   	pop    %ebx
801077e8:	5e                   	pop    %esi
801077e9:	5d                   	pop    %ebp
801077ea:	c3                   	ret    
801077eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801077ef:	90                   	nop
      freevm(pgdir);
801077f0:	83 ec 0c             	sub    $0xc,%esp
801077f3:	56                   	push   %esi
      return 0;
801077f4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801077f6:	e8 15 ff ff ff       	call   80107710 <freevm>
      return 0;
801077fb:	83 c4 10             	add    $0x10,%esp
}
801077fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107801:	89 f0                	mov    %esi,%eax
80107803:	5b                   	pop    %ebx
80107804:	5e                   	pop    %esi
80107805:	5d                   	pop    %ebp
80107806:	c3                   	ret    
80107807:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010780e:	66 90                	xchg   %ax,%ax

80107810 <kvmalloc>:
{
80107810:	55                   	push   %ebp
80107811:	89 e5                	mov    %esp,%ebp
80107813:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107816:	e8 75 ff ff ff       	call   80107790 <setupkvm>
8010781b:	a3 04 96 11 80       	mov    %eax,0x80119604
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107820:	05 00 00 00 80       	add    $0x80000000,%eax
80107825:	0f 22 d8             	mov    %eax,%cr3
}
80107828:	c9                   	leave  
80107829:	c3                   	ret    
8010782a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107830 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107830:	55                   	push   %ebp
80107831:	89 e5                	mov    %esp,%ebp
80107833:	83 ec 08             	sub    $0x8,%esp
80107836:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107839:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010783c:	89 c1                	mov    %eax,%ecx
8010783e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107841:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107844:	f6 c2 01             	test   $0x1,%dl
80107847:	75 17                	jne    80107860 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107849:	83 ec 0c             	sub    $0xc,%esp
8010784c:	68 1a 89 10 80       	push   $0x8010891a
80107851:	e8 2a 8b ff ff       	call   80100380 <panic>
80107856:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010785d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107860:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107863:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107869:	25 fc 0f 00 00       	and    $0xffc,%eax
8010786e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107875:	85 c0                	test   %eax,%eax
80107877:	74 d0                	je     80107849 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107879:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010787c:	c9                   	leave  
8010787d:	c3                   	ret    
8010787e:	66 90                	xchg   %ax,%ax

80107880 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107880:	55                   	push   %ebp
80107881:	89 e5                	mov    %esp,%ebp
80107883:	57                   	push   %edi
80107884:	56                   	push   %esi
80107885:	53                   	push   %ebx
80107886:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  // char *mem;

  if((d = setupkvm()) == 0)
80107889:	e8 02 ff ff ff       	call   80107790 <setupkvm>
8010788e:	89 c3                	mov    %eax,%ebx
80107890:	85 c0                	test   %eax,%eax
80107892:	0f 84 c9 00 00 00    	je     80107961 <copyuvm+0xe1>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107898:	8b 45 0c             	mov    0xc(%ebp),%eax
8010789b:	85 c0                	test   %eax,%eax
8010789d:	0f 84 b2 00 00 00    	je     80107955 <copyuvm+0xd5>
801078a3:	31 ff                	xor    %edi,%edi
801078a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
801078a8:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801078ab:	89 f8                	mov    %edi,%eax
801078ad:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801078b0:	8b 04 82             	mov    (%edx,%eax,4),%eax
801078b3:	a8 01                	test   $0x1,%al
801078b5:	75 11                	jne    801078c8 <copyuvm+0x48>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801078b7:	83 ec 0c             	sub    $0xc,%esp
801078ba:	68 c2 84 10 80       	push   $0x801084c2
801078bf:	e8 bc 8a ff ff       	call   80100380 <panic>
801078c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801078c8:	89 f9                	mov    %edi,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801078ca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801078cf:	c1 e9 0a             	shr    $0xa,%ecx
801078d2:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
801078d8:	8d b4 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%esi
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801078df:	85 f6                	test   %esi,%esi
801078e1:	74 d4                	je     801078b7 <copyuvm+0x37>
    if(!(*pte & PTE_P))
801078e3:	8b 0e                	mov    (%esi),%ecx
801078e5:	f6 c1 01             	test   $0x1,%cl
801078e8:	0f 84 a6 00 00 00    	je     80107994 <copyuvm+0x114>
      panic("copyuvm: page not present");
    cprintf("Debug: before write unset %p\n",*pte);
801078ee:	83 ec 08             	sub    $0x8,%esp
801078f1:	51                   	push   %ecx
801078f2:	68 24 89 10 80       	push   $0x80108924
801078f7:	e8 a4 8d ff ff       	call   801006a0 <cprintf>
    *pte=((*pte)&(~PTE_W));
801078fc:	8b 0e                	mov    (%esi),%ecx
801078fe:	83 e1 fd             	and    $0xfffffffd,%ecx
80107901:	89 0e                	mov    %ecx,(%esi)
    cprintf("Debug: after write unset%p\n",*pte);
80107903:	58                   	pop    %eax
80107904:	5a                   	pop    %edx
80107905:	51                   	push   %ecx
80107906:	68 42 89 10 80       	push   $0x80108942
8010790b:	e8 90 8d ff ff       	call   801006a0 <cprintf>
    pa = PTE_ADDR(*pte);
80107910:	8b 06                	mov    (%esi),%eax
80107912:	89 c6                	mov    %eax,%esi
80107914:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107917:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    flags = PTE_FLAGS(*pte);
    inc_rmap(pa);
8010791d:	89 34 24             	mov    %esi,(%esp)
80107920:	e8 9b ac ff ff       	call   801025c0 <inc_rmap>
    // if((mem = kalloc()) == 0)
    //   goto bad;
    // memmove(mem, (char*)P2V(pa), PGSIZE);
    // if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
    if(mappages(d, (void*)i, PGSIZE,pa, flags) < 0) {
80107925:	59                   	pop    %ecx
80107926:	58                   	pop    %eax
80107927:	b9 00 10 00 00       	mov    $0x1000,%ecx
    flags = PTE_FLAGS(*pte);
8010792c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if(mappages(d, (void*)i, PGSIZE,pa, flags) < 0) {
8010792f:	89 fa                	mov    %edi,%edx
    flags = PTE_FLAGS(*pte);
80107931:	25 ff 0f 00 00       	and    $0xfff,%eax
    if(mappages(d, (void*)i, PGSIZE,pa, flags) < 0) {
80107936:	50                   	push   %eax
80107937:	89 d8                	mov    %ebx,%eax
80107939:	56                   	push   %esi
8010793a:	e8 11 f7 ff ff       	call   80107050 <mappages>
8010793f:	83 c4 10             	add    $0x10,%esp
80107942:	85 c0                	test   %eax,%eax
80107944:	78 2a                	js     80107970 <copyuvm+0xf0>
  for(i = 0; i < sz; i += PGSIZE){
80107946:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010794c:	39 7d 0c             	cmp    %edi,0xc(%ebp)
8010794f:	0f 87 53 ff ff ff    	ja     801078a8 <copyuvm+0x28>
      // kfree(mem);
      goto bad;
    }
  }
  lcr3(V2P(pgdir));
80107955:	8b 45 08             	mov    0x8(%ebp),%eax
80107958:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
8010795e:	0f 22 de             	mov    %esi,%cr3

bad:
  freevm(d);
  lcr3(V2P(pgdir));
  return 0;
}
80107961:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107964:	89 d8                	mov    %ebx,%eax
80107966:	5b                   	pop    %ebx
80107967:	5e                   	pop    %esi
80107968:	5f                   	pop    %edi
80107969:	5d                   	pop    %ebp
8010796a:	c3                   	ret    
8010796b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010796f:	90                   	nop
  freevm(d);
80107970:	83 ec 0c             	sub    $0xc,%esp
80107973:	53                   	push   %ebx
80107974:	e8 97 fd ff ff       	call   80107710 <freevm>
  lcr3(V2P(pgdir));
80107979:	8b 45 08             	mov    0x8(%ebp),%eax
8010797c:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
80107982:	0f 22 de             	mov    %esi,%cr3
  return 0;
80107985:	31 db                	xor    %ebx,%ebx
80107987:	83 c4 10             	add    $0x10,%esp
}
8010798a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010798d:	89 d8                	mov    %ebx,%eax
8010798f:	5b                   	pop    %ebx
80107990:	5e                   	pop    %esi
80107991:	5f                   	pop    %edi
80107992:	5d                   	pop    %ebp
80107993:	c3                   	ret    
      panic("copyuvm: page not present");
80107994:	83 ec 0c             	sub    $0xc,%esp
80107997:	68 dc 84 10 80       	push   $0x801084dc
8010799c:	e8 df 89 ff ff       	call   80100380 <panic>
801079a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079af:	90                   	nop

801079b0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801079b0:	55                   	push   %ebp
801079b1:	89 e5                	mov    %esp,%ebp
801079b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801079b6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801079b9:	89 c1                	mov    %eax,%ecx
801079bb:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801079be:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801079c1:	f6 c2 01             	test   $0x1,%dl
801079c4:	0f 84 00 01 00 00    	je     80107aca <uva2ka.cold>
  return &pgtab[PTX(va)];
801079ca:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801079cd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801079d3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801079d4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801079d9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
801079e0:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801079e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801079e7:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801079ea:	05 00 00 00 80       	add    $0x80000000,%eax
801079ef:	83 fa 05             	cmp    $0x5,%edx
801079f2:	ba 00 00 00 00       	mov    $0x0,%edx
801079f7:	0f 45 c2             	cmovne %edx,%eax
}
801079fa:	c3                   	ret    
801079fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801079ff:	90                   	nop

80107a00 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107a00:	55                   	push   %ebp
80107a01:	89 e5                	mov    %esp,%ebp
80107a03:	57                   	push   %edi
80107a04:	56                   	push   %esi
80107a05:	53                   	push   %ebx
80107a06:	83 ec 0c             	sub    $0xc,%esp
80107a09:	8b 75 14             	mov    0x14(%ebp),%esi
80107a0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a0f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107a12:	85 f6                	test   %esi,%esi
80107a14:	75 51                	jne    80107a67 <copyout+0x67>
80107a16:	e9 a5 00 00 00       	jmp    80107ac0 <copyout+0xc0>
80107a1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107a1f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107a20:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107a26:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
80107a2c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107a32:	74 75                	je     80107aa9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107a34:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107a36:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107a39:	29 c3                	sub    %eax,%ebx
80107a3b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107a41:	39 f3                	cmp    %esi,%ebx
80107a43:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107a46:	29 f8                	sub    %edi,%eax
80107a48:	83 ec 04             	sub    $0x4,%esp
80107a4b:	01 c1                	add    %eax,%ecx
80107a4d:	53                   	push   %ebx
80107a4e:	52                   	push   %edx
80107a4f:	51                   	push   %ecx
80107a50:	e8 1b d5 ff ff       	call   80104f70 <memmove>
    len -= n;
    buf += n;
80107a55:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107a58:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
80107a5e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107a61:	01 da                	add    %ebx,%edx
  while(len > 0){
80107a63:	29 de                	sub    %ebx,%esi
80107a65:	74 59                	je     80107ac0 <copyout+0xc0>
  if(*pde & PTE_P){
80107a67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
80107a6a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107a6c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
80107a6e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107a71:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107a77:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
80107a7a:	f6 c1 01             	test   $0x1,%cl
80107a7d:	0f 84 4e 00 00 00    	je     80107ad1 <copyout.cold>
  return &pgtab[PTX(va)];
80107a83:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107a85:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107a8b:	c1 eb 0c             	shr    $0xc,%ebx
80107a8e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107a94:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
80107a9b:	89 d9                	mov    %ebx,%ecx
80107a9d:	83 e1 05             	and    $0x5,%ecx
80107aa0:	83 f9 05             	cmp    $0x5,%ecx
80107aa3:	0f 84 77 ff ff ff    	je     80107a20 <copyout+0x20>
  }
  return 0;
}
80107aa9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107aac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107ab1:	5b                   	pop    %ebx
80107ab2:	5e                   	pop    %esi
80107ab3:	5f                   	pop    %edi
80107ab4:	5d                   	pop    %ebp
80107ab5:	c3                   	ret    
80107ab6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107abd:	8d 76 00             	lea    0x0(%esi),%esi
80107ac0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107ac3:	31 c0                	xor    %eax,%eax
}
80107ac5:	5b                   	pop    %ebx
80107ac6:	5e                   	pop    %esi
80107ac7:	5f                   	pop    %edi
80107ac8:	5d                   	pop    %ebp
80107ac9:	c3                   	ret    

80107aca <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80107aca:	a1 00 00 00 00       	mov    0x0,%eax
80107acf:	0f 0b                	ud2    

80107ad1 <copyout.cold>:
80107ad1:	a1 00 00 00 00       	mov    0x0,%eax
80107ad6:	0f 0b                	ud2    
80107ad8:	66 90                	xchg   %ax,%ax
80107ada:	66 90                	xchg   %ax,%ax
80107adc:	66 90                	xchg   %ax,%ax
80107ade:	66 90                	xchg   %ax,%ax

80107ae0 <initpageswap>:
#include "memlayout.h"

struct slotinfo slot_array[SSIZE];
uint swap_start;

void initpageswap(uint sbstart){
80107ae0:	55                   	push   %ebp
80107ae1:	89 e5                	mov    %esp,%ebp
    swap_start=sbstart;
80107ae3:	8b 45 08             	mov    0x8(%ebp),%eax
80107ae6:	a3 20 96 11 80       	mov    %eax,0x80119620
    for(uint i=0;i<SSIZE;i++)
80107aeb:	b8 40 96 11 80       	mov    $0x80119640,%eax
    {
        slot_array[i].is_free=1;
80107af0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    for(uint i=0;i<SSIZE;i++)
80107af6:	83 c0 0c             	add    $0xc,%eax
80107af9:	3d 00 a9 11 80       	cmp    $0x8011a900,%eax
80107afe:	75 f0                	jne    80107af0 <initpageswap+0x10>
    }
}
80107b00:	5d                   	pop    %ebp
80107b01:	c3                   	ret    
80107b02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107b10 <pagingintr>:
//         rmap[i].virtual_addr=-1;
//         rmap[i].process_indexes=0;
//     }
// }

void pagingintr(){
80107b10:	55                   	push   %ebp
80107b11:	89 e5                	mov    %esp,%ebp
80107b13:	57                   	push   %edi
80107b14:	56                   	push   %esi
80107b15:	53                   	push   %ebx
80107b16:	83 ec 28             	sub    $0x28,%esp
    cprintf("Debug: Pageing Intrupt Handler \n");
80107b19:	68 84 89 10 80       	push   $0x80108984
80107b1e:	e8 7d 8b ff ff       	call   801006a0 <cprintf>
    struct proc *curproc;
    uint pfa, pa, flags;
    pte_t *pte;
    char *mem;
    // Accesing the process that caused pagefault
    curproc=myproc();
80107b23:	e8 88 c3 ff ff       	call   80103eb0 <myproc>
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107b28:	0f 20 d2             	mov    %cr2,%edx
    // Accessing the page addr that caused the pagefault 
    pfa=rcr2();
    // Accessing the page table entry of the fault page.
    pte=walkpgdir(curproc->pgdir, (void *)pfa,0);
80107b2b:	83 c4 0c             	add    $0xc,%esp
80107b2e:	6a 00                	push   $0x0
80107b30:	52                   	push   %edx
80107b31:	ff 70 08             	push   0x8(%eax)
80107b34:	e8 97 f6 ff ff       	call   801071d0 <walkpgdir>
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);

    // Checking is pagefault due to COW
    if((flags & PTE_P))
80107b39:	83 c4 10             	add    $0x10,%esp
    pa = PTE_ADDR(*pte);
80107b3c:	8b 10                	mov    (%eax),%edx
    if((flags & PTE_P))
80107b3e:	f6 c2 01             	test   $0x1,%dl
80107b41:	75 0d                	jne    80107b50 <pagingintr+0x40>
      flags|=PTE_W;
      *pte= PTE_ADDR((uint)V2P(mem)) | flags;
      kfree(P2V(pa));
    }
    return;
}
80107b43:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b46:	5b                   	pop    %ebx
80107b47:	5e                   	pop    %esi
80107b48:	5f                   	pop    %edi
80107b49:	5d                   	pop    %ebp
80107b4a:	c3                   	ret    
80107b4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107b4f:	90                   	nop
80107b50:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      if((mem = kalloc()) == 0)
80107b53:	89 c6                	mov    %eax,%esi
80107b55:	e8 a6 af ff ff       	call   80102b00 <kalloc>
80107b5a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107b5d:	85 c0                	test   %eax,%eax
80107b5f:	89 c3                	mov    %eax,%ebx
80107b61:	74 4f                	je     80107bb2 <pagingintr+0xa2>
    pa = PTE_ADDR(*pte);
80107b63:	89 d7                	mov    %edx,%edi
      memmove(mem, (char*)P2V(pa), PGSIZE);
80107b65:	83 ec 04             	sub    $0x4,%esp
    pa = PTE_ADDR(*pte);
80107b68:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      *pte= PTE_ADDR((uint)V2P(mem)) | flags;
80107b6b:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    pa = PTE_ADDR(*pte);
80107b71:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
      memmove(mem, (char*)P2V(pa), PGSIZE);
80107b77:	68 00 10 00 00       	push   $0x1000
      *pte= PTE_ADDR((uint)V2P(mem)) | flags;
80107b7c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
      memmove(mem, (char*)P2V(pa), PGSIZE);
80107b82:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107b88:	57                   	push   %edi
80107b89:	50                   	push   %eax
80107b8a:	e8 e1 d3 ff ff       	call   80104f70 <memmove>
    flags = PTE_FLAGS(*pte);
80107b8f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107b92:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
      *pte= PTE_ADDR((uint)V2P(mem)) | flags;
80107b98:	09 d3                	or     %edx,%ebx
80107b9a:	83 cb 02             	or     $0x2,%ebx
80107b9d:	89 1e                	mov    %ebx,(%esi)
      kfree(P2V(pa));
80107b9f:	89 3c 24             	mov    %edi,(%esp)
80107ba2:	e8 a9 ac ff ff       	call   80102850 <kfree>
80107ba7:	83 c4 10             	add    $0x10,%esp
}
80107baa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107bad:	5b                   	pop    %ebx
80107bae:	5e                   	pop    %esi
80107baf:	5f                   	pop    %edi
80107bb0:	5d                   	pop    %ebp
80107bb1:	c3                   	ret    
        panic("memory is not available for page copy");
80107bb2:	83 ec 0c             	sub    $0xc,%esp
80107bb5:	68 a8 89 10 80       	push   $0x801089a8
80107bba:	e8 c1 87 ff ff       	call   80100380 <panic>
80107bbf:	90                   	nop

80107bc0 <free_swap>:

void free_swap(struct proc* p)
{
80107bc0:	55                   	push   %ebp
80107bc1:	b8 40 96 11 80       	mov    $0x80119640,%eax
80107bc6:	89 e5                	mov    %esp,%ebp
80107bc8:	8b 55 08             	mov    0x8(%ebp),%edx
80107bcb:	eb 0d                	jmp    80107bda <free_swap+0x1a>
80107bcd:	8d 76 00             	lea    0x0(%esi),%esi
  for(int i=0;i<SSIZE;i++)
80107bd0:	83 c0 0c             	add    $0xc,%eax
80107bd3:	3d 00 a9 11 80       	cmp    $0x8011a900,%eax
80107bd8:	74 1e                	je     80107bf8 <free_swap+0x38>
  {
    if(slot_array[i].pid==p->pid && slot_array[i].is_free==0)
80107bda:	8b 4a 14             	mov    0x14(%edx),%ecx
80107bdd:	39 48 08             	cmp    %ecx,0x8(%eax)
80107be0:	75 ee                	jne    80107bd0 <free_swap+0x10>
80107be2:	8b 08                	mov    (%eax),%ecx
80107be4:	85 c9                	test   %ecx,%ecx
80107be6:	75 e8                	jne    80107bd0 <free_swap+0x10>
    {
      slot_array[i].is_free=1;
80107be8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  for(int i=0;i<SSIZE;i++)
80107bee:	83 c0 0c             	add    $0xc,%eax
80107bf1:	3d 00 a9 11 80       	cmp    $0x8011a900,%eax
80107bf6:	75 e2                	jne    80107bda <free_swap+0x1a>
    }
  }
}
80107bf8:	5d                   	pop    %ebp
80107bf9:	c3                   	ret    
80107bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107c00 <write_to_swap>:
uint write_to_swap(char* vpa)
{
80107c00:	55                   	push   %ebp
80107c01:	ba 40 96 11 80       	mov    $0x80119640,%edx
   uint slot_ind=0;
   for(slot_ind=0;slot_ind<SSIZE;slot_ind++)
80107c06:	31 c0                	xor    %eax,%eax
{
80107c08:	89 e5                	mov    %esp,%ebp
80107c0a:	57                   	push   %edi
80107c0b:	56                   	push   %esi
80107c0c:	53                   	push   %ebx
80107c0d:	83 ec 1c             	sub    $0x1c,%esp
80107c10:	8b 5d 08             	mov    0x8(%ebp),%ebx
80107c13:	eb 14                	jmp    80107c29 <write_to_swap+0x29>
80107c15:	8d 76 00             	lea    0x0(%esi),%esi
   for(slot_ind=0;slot_ind<SSIZE;slot_ind++)
80107c18:	83 c0 01             	add    $0x1,%eax
80107c1b:	83 c2 0c             	add    $0xc,%edx
80107c1e:	3d 90 01 00 00       	cmp    $0x190,%eax
80107c23:	0f 84 97 00 00 00    	je     80107cc0 <write_to_swap+0xc0>
   {
      if(slot_array[slot_ind].is_free)
80107c29:	8b 0a                	mov    (%edx),%ecx
80107c2b:	85 c9                	test   %ecx,%ecx
80107c2d:	74 e9                	je     80107c18 <write_to_swap+0x18>
      {
        slot_array[slot_ind].is_free=0;
80107c2f:	8d 14 40             	lea    (%eax,%eax,2),%edx
        break;
      }
   }
   if(slot_ind==SSIZE) slot_ind--;
   uint block_num=swap_start+slot_ind*8;
80107c32:	c1 e0 03             	shl    $0x3,%eax
        slot_array[slot_ind].is_free=0;
80107c35:	c7 04 95 40 96 11 80 	movl   $0x0,-0x7fee69c0(,%edx,4)
80107c3c:	00 00 00 00 
   uint block_num=swap_start+slot_ind*8;
80107c40:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107c43:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
80107c49:	8b 75 e0             	mov    -0x20(%ebp),%esi
80107c4c:	03 35 20 96 11 80    	add    0x80119620,%esi
   for(int i=0;i<8;i++)
80107c52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107c55:	8d 76 00             	lea    0x0(%esi),%esi
   {
        struct buf* b=bread(ROOTDEV,block_num+i);
80107c58:	83 ec 08             	sub    $0x8,%esp
80107c5b:	56                   	push   %esi
80107c5c:	6a 01                	push   $0x1
80107c5e:	e8 6d 84 ff ff       	call   801000d0 <bread>
        memmove(b->data,vpa,512);
80107c63:	83 c4 0c             	add    $0xc,%esp
        struct buf* b=bread(ROOTDEV,block_num+i);
80107c66:	89 c7                	mov    %eax,%edi
        memmove(b->data,vpa,512);
80107c68:	8d 40 5c             	lea    0x5c(%eax),%eax
80107c6b:	68 00 02 00 00       	push   $0x200
80107c70:	53                   	push   %ebx
        b->blockno=block_num+i;
        b->flags|=B_DIRTY;
        b->dev=ROOTDEV;
        bwrite(b);
        brelse(b);
        vpa=vpa+512;
80107c71:	81 c3 00 02 00 00    	add    $0x200,%ebx
        memmove(b->data,vpa,512);
80107c77:	50                   	push   %eax
80107c78:	e8 f3 d2 ff ff       	call   80104f70 <memmove>
        b->flags|=B_DIRTY;
80107c7d:	83 0f 04             	orl    $0x4,(%edi)
        b->blockno=block_num+i;
80107c80:	89 77 08             	mov    %esi,0x8(%edi)
   for(int i=0;i<8;i++)
80107c83:	83 c6 01             	add    $0x1,%esi
        b->dev=ROOTDEV;
80107c86:	c7 47 04 01 00 00 00 	movl   $0x1,0x4(%edi)
        bwrite(b);
80107c8d:	89 3c 24             	mov    %edi,(%esp)
80107c90:	e8 1b 85 ff ff       	call   801001b0 <bwrite>
        brelse(b);
80107c95:	89 3c 24             	mov    %edi,(%esp)
80107c98:	e8 53 85 ff ff       	call   801001f0 <brelse>
   for(int i=0;i<8;i++)
80107c9d:	83 c4 10             	add    $0x10,%esp
80107ca0:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80107ca3:	75 b3                	jne    80107c58 <write_to_swap+0x58>
   } 
   return swap_start+slot_ind*8;
80107ca5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107ca8:	03 05 20 96 11 80    	add    0x80119620,%eax
}
80107cae:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107cb1:	5b                   	pop    %ebx
80107cb2:	5e                   	pop    %esi
80107cb3:	5f                   	pop    %edi
80107cb4:	5d                   	pop    %ebp
80107cb5:	c3                   	ret    
80107cb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107cbd:	8d 76 00             	lea    0x0(%esi),%esi
80107cc0:	c7 45 e0 78 0c 00 00 	movl   $0xc78,-0x20(%ebp)
80107cc7:	e9 77 ff ff ff       	jmp    80107c43 <write_to_swap+0x43>
80107ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107cd0 <read_from_swap>:

void read_from_swap(uint sbn, char* pa)
{
80107cd0:	55                   	push   %ebp
80107cd1:	89 e5                	mov    %esp,%ebp
80107cd3:	57                   	push   %edi
80107cd4:	56                   	push   %esi
80107cd5:	53                   	push   %ebx
80107cd6:	83 ec 1c             	sub    $0x1c,%esp
80107cd9:	8b 7d 08             	mov    0x8(%ebp),%edi
80107cdc:	8b 75 0c             	mov    0xc(%ebp),%esi
    slot_array[sbn/8].is_free=1;
80107cdf:	89 f8                	mov    %edi,%eax
80107ce1:	c1 e8 03             	shr    $0x3,%eax
80107ce4:	8d 04 40             	lea    (%eax,%eax,2),%eax
80107ce7:	c7 04 85 40 96 11 80 	movl   $0x1,-0x7fee69c0(,%eax,4)
80107cee:	01 00 00 00 
    for(int i=0;i<8;i++)
80107cf2:	8d 86 00 10 00 00    	lea    0x1000(%esi),%eax
80107cf8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107cfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107cff:	90                   	nop
    {
        struct buf* b=bread(ROOTDEV,sbn+i);
80107d00:	83 ec 08             	sub    $0x8,%esp
80107d03:	57                   	push   %edi
    for(int i=0;i<8;i++)
80107d04:	83 c7 01             	add    $0x1,%edi
        struct buf* b=bread(ROOTDEV,sbn+i);
80107d07:	6a 01                	push   $0x1
80107d09:	e8 c2 83 ff ff       	call   801000d0 <bread>
        memmove(pa,b->data,512);
80107d0e:	83 c4 0c             	add    $0xc,%esp
        struct buf* b=bread(ROOTDEV,sbn+i);
80107d11:	89 c3                	mov    %eax,%ebx
        memmove(pa,b->data,512);
80107d13:	8d 40 5c             	lea    0x5c(%eax),%eax
80107d16:	68 00 02 00 00       	push   $0x200
80107d1b:	50                   	push   %eax
80107d1c:	56                   	push   %esi
        brelse(b);
        pa+=512;
80107d1d:	81 c6 00 02 00 00    	add    $0x200,%esi
        memmove(pa,b->data,512);
80107d23:	e8 48 d2 ff ff       	call   80104f70 <memmove>
        brelse(b);
80107d28:	89 1c 24             	mov    %ebx,(%esp)
80107d2b:	e8 c0 84 ff ff       	call   801001f0 <brelse>
    for(int i=0;i<8;i++)
80107d30:	83 c4 10             	add    $0x10,%esp
80107d33:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
80107d36:	75 c8                	jne    80107d00 <read_from_swap+0x30>
    }
}
80107d38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d3b:	5b                   	pop    %ebx
80107d3c:	5e                   	pop    %esi
80107d3d:	5f                   	pop    %edi
80107d3e:	5d                   	pop    %ebp
80107d3f:	c3                   	ret    

80107d40 <swap_in>:

void
swap_in(){
80107d40:	55                   	push   %ebp
80107d41:	89 e5                	mov    %esp,%ebp
80107d43:	57                   	push   %edi
80107d44:	56                   	push   %esi
80107d45:	53                   	push   %ebx
80107d46:	83 ec 1c             	sub    $0x1c,%esp
    struct proc* curproc=myproc();
80107d49:	e8 62 c1 ff ff       	call   80103eb0 <myproc>
80107d4e:	89 c3                	mov    %eax,%ebx
80107d50:	0f 20 d0             	mov    %cr2,%eax
    uint pfa=rcr2();
    pte_t* pte=walkpgdir(curproc->pgdir, (void *)pfa,0 );
80107d53:	83 ec 04             	sub    $0x4,%esp
80107d56:	6a 00                	push   $0x0
80107d58:	50                   	push   %eax
80107d59:	ff 73 08             	push   0x8(%ebx)
80107d5c:	e8 6f f4 ff ff       	call   801071d0 <walkpgdir>
    uint sbn=(*pte)>>PTXSHIFT;
80107d61:	8b 30                	mov    (%eax),%esi
    pte_t* pte=walkpgdir(curproc->pgdir, (void *)pfa,0 );
80107d63:	89 c7                	mov    %eax,%edi
    // cprintf("page fault virtual address: %p and physical address %p\n",pfa,(*pte));
    char* pa=kalloc();
80107d65:	e8 96 ad ff ff       	call   80102b00 <kalloc>
    // cprintf("Helloooooooooooooooooooooooooo..............\n");
    uint pg=(V2P((uint)pa))&(~0xfff);
    (*pte)=((uint)(pg)|slot_array[sbn/8].page_perm);
80107d6a:	89 f2                	mov    %esi,%edx
    char* pa=kalloc();
80107d6c:	89 c1                	mov    %eax,%ecx
    uint pg=(V2P((uint)pa))&(~0xfff);
80107d6e:	8d 80 00 00 00 80    	lea    -0x80000000(%eax),%eax
    (*pte)=((uint)(pg)|slot_array[sbn/8].page_perm);
80107d74:	c1 ea 0f             	shr    $0xf,%edx
    uint pg=(V2P((uint)pa))&(~0xfff);
80107d77:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    (*pte)=((uint)(pg)|slot_array[sbn/8].page_perm);
80107d7c:	8d 14 52             	lea    (%edx,%edx,2),%edx
80107d7f:	8d 14 95 40 96 11 80 	lea    -0x7fee69c0(,%edx,4),%edx
80107d86:	0b 42 04             	or     0x4(%edx),%eax
80107d89:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107d8c:	89 07                	mov    %eax,(%edi)
    read_from_swap(sbn, pa);
80107d8e:	58                   	pop    %eax
    uint sbn=(*pte)>>PTXSHIFT;
80107d8f:	89 f0                	mov    %esi,%eax
80107d91:	c1 e8 0c             	shr    $0xc,%eax
    read_from_swap(sbn, pa);
80107d94:	5a                   	pop    %edx
80107d95:	51                   	push   %ecx
80107d96:	50                   	push   %eax
80107d97:	e8 34 ff ff ff       	call   80107cd0 <read_from_swap>
    slot_array[sbn/8].pid=curproc->pid;
80107d9c:	8b 43 14             	mov    0x14(%ebx),%eax
80107d9f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    curproc->rss+=4096;
    // cprintf("process id thats page swapped in: %d and  page table entry %p \n",curproc->pid,(*pte));
}
80107da2:	83 c4 10             	add    $0x10,%esp
    slot_array[sbn/8].pid=curproc->pid;
80107da5:	89 42 08             	mov    %eax,0x8(%edx)
    curproc->rss+=4096;
80107da8:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
}
80107daf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107db2:	5b                   	pop    %ebx
80107db3:	5e                   	pop    %esi
80107db4:	5f                   	pop    %edi
80107db5:	5d                   	pop    %ebp
80107db6:	c3                   	ret    
80107db7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107dbe:	66 90                	xchg   %ax,%ax

80107dc0 <swap_out>:

void
swap_out(){
80107dc0:	55                   	push   %ebp
80107dc1:	89 e5                	mov    %esp,%ebp
80107dc3:	57                   	push   %edi
80107dc4:	56                   	push   %esi
80107dc5:	53                   	push   %ebx
80107dc6:	83 ec 0c             	sub    $0xc,%esp
    struct proc* p=find_victim_process();
80107dc9:	e8 32 c8 ff ff       	call   80104600 <find_victim_process>
    pte_t *pg;
    pg=find_victim_page(p);
80107dce:	83 ec 0c             	sub    $0xc,%esp
80107dd1:	50                   	push   %eax
    struct proc* p=find_victim_process();
80107dd2:	89 c6                	mov    %eax,%esi
    pg=find_victim_page(p);
80107dd4:	e8 77 c8 ff ff       	call   80104650 <find_victim_page>

    // cprintf("\nDebug Victim IPD [%d], Page [%p]\n", p->pid, *pg);
    // cprintf("\n  Debug Victim IPD [%d], Page [%p]\n", p->pid, pg);
    while((uint)pg==0)
80107dd9:	83 c4 10             	add    $0x10,%esp
80107ddc:	85 c0                	test   %eax,%eax
80107dde:	75 70                	jne    80107e50 <swap_out+0x90>
    {
        // cprintf("Hello i am going to unaccessed some pages.\n");
        make_unaccessed_page(p);
80107de0:	83 ec 0c             	sub    $0xc,%esp
80107de3:	56                   	push   %esi
80107de4:	e8 b7 c8 ff ff       	call   801046a0 <make_unaccessed_page>
        pg=find_victim_page(p);
80107de9:	89 34 24             	mov    %esi,(%esp)
80107dec:	e8 5f c8 ff ff       	call   80104650 <find_victim_page>
    while((uint)pg==0)
80107df1:	83 c4 10             	add    $0x10,%esp
        pg=find_victim_page(p);
80107df4:	89 c3                	mov    %eax,%ebx
    while((uint)pg==0)
80107df6:	85 c0                	test   %eax,%eax
80107df8:	74 e6                	je     80107de0 <swap_out+0x20>
    }
    char* pa=(char*)(P2V((*pg)&(~0xFFF)));    
80107dfa:	8b 3b                	mov    (%ebx),%edi
    // cprintf("   victim page %p:\n",pa);
    uint sbn= write_to_swap(pa);
80107dfc:	83 ec 0c             	sub    $0xc,%esp
    char* pa=(char*)(P2V((*pg)&(~0xFFF)));    
80107dff:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80107e05:	81 c7 00 00 00 80    	add    $0x80000000,%edi
    uint sbn= write_to_swap(pa);
80107e0b:	57                   	push   %edi
80107e0c:	e8 ef fd ff ff       	call   80107c00 <write_to_swap>
    slot_array[sbn/8].page_perm=((*pg)&(0xFFF));
80107e11:	89 c2                	mov    %eax,%edx
    (*pg)=((sbn<<PTXSHIFT)&(~0xfff));
80107e13:	c1 e0 0c             	shl    $0xc,%eax
    slot_array[sbn/8].page_perm=((*pg)&(0xFFF));
80107e16:	c1 ea 03             	shr    $0x3,%edx
80107e19:	8d 0c 52             	lea    (%edx,%edx,2),%ecx
80107e1c:	8b 13                	mov    (%ebx),%edx
80107e1e:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
80107e24:	89 14 8d 44 96 11 80 	mov    %edx,-0x7fee69bc(,%ecx,4)
    (*pg)=((sbn<<PTXSHIFT)&(~0xfff));
80107e2b:	89 03                	mov    %eax,(%ebx)
    kfree(pa);
80107e2d:	89 3c 24             	mov    %edi,(%esp)
80107e30:	e8 1b aa ff ff       	call   80102850 <kfree>
    // cprintf("\n  Debug Victim IPD [%d], Page [%p]\n", p->pid, *pg);
    p->rss-=4096;
80107e35:	81 6e 04 00 10 00 00 	subl   $0x1000,0x4(%esi)
    // cprintf("  process id thats page swapped out: %d \n",p->pid);
80107e3c:	83 c4 10             	add    $0x10,%esp
80107e3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e42:	5b                   	pop    %ebx
80107e43:	5e                   	pop    %esi
80107e44:	5f                   	pop    %edi
80107e45:	5d                   	pop    %ebp
80107e46:	c3                   	ret    
80107e47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e4e:	66 90                	xchg   %ax,%ax
80107e50:	89 c3                	mov    %eax,%ebx
80107e52:	eb a6                	jmp    80107dfa <swap_out+0x3a>
