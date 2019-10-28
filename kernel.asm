
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
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
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
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 50 2e 10 80       	mov    $0x80102e50,%eax
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
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	68 60 70 10 80       	push   $0x80107060
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 e5 42 00 00       	call   80104340 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 67 70 10 80       	push   $0x80107067
80100097:	50                   	push   %eax
80100098:	e8 73 41 00 00       	call   80104210 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

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
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000df:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e4:	e8 b7 43 00 00       	call   801044a0 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
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
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 e9 43 00 00       	call   80104550 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 de 40 00 00       	call   80104250 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 5d 1f 00 00       	call   801020e0 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 6e 70 10 80       	push   $0x8010706e
80100198:	e8 d3 01 00 00       	call   80100370 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 3d 41 00 00       	call   801042f0 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 17 1f 00 00       	jmp    801020e0 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 7f 70 10 80       	push   $0x8010707f
801001d1:	e8 9a 01 00 00       	call   80100370 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 fc 40 00 00       	call   801042f0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 ac 40 00 00       	call   801042b0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020b:	e8 90 42 00 00       	call   801044a0 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100241:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
8010025c:	e9 ef 42 00 00       	jmp    80104550 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 86 70 10 80       	push   $0x80107086
80100269:	e8 02 01 00 00       	call   80100370 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 bb 14 00 00       	call   80101740 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 0f 42 00 00       	call   801044a0 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e 9a 00 00 00    	jle    8010033b <consoleread+0xcb>
    while(input.r == input.w){
801002a1:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002a6:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002ac:	74 24                	je     801002d2 <consoleread+0x62>
801002ae:	eb 58                	jmp    80100308 <consoleread+0x98>
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b0:	83 ec 08             	sub    $0x8,%esp
801002b3:	68 20 a5 10 80       	push   $0x8010a520
801002b8:	68 a0 ff 10 80       	push   $0x8010ffa0
801002bd:	e8 7e 3a 00 00       	call   80103d40 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c2:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002c7:	83 c4 10             	add    $0x10,%esp
801002ca:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d0:	75 36                	jne    80100308 <consoleread+0x98>
      if(myproc()->killed){
801002d2:	e8 b9 34 00 00       	call   80103790 <myproc>
801002d7:	8b 40 24             	mov    0x24(%eax),%eax
801002da:	85 c0                	test   %eax,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002de:	83 ec 0c             	sub    $0xc,%esp
801002e1:	68 20 a5 10 80       	push   $0x8010a520
801002e6:	e8 65 42 00 00       	call   80104550 <release>
        ilock(ip);
801002eb:	89 3c 24             	mov    %edi,(%esp)
801002ee:	e8 6d 13 00 00       	call   80101660 <ilock>
        return -1;
801002f3:	83 c4 10             	add    $0x10,%esp
801002f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002fe:	5b                   	pop    %ebx
801002ff:	5e                   	pop    %esi
80100300:	5f                   	pop    %edi
80100301:	5d                   	pop    %ebp
80100302:	c3                   	ret    
80100303:	90                   	nop
80100304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100308:	8d 50 01             	lea    0x1(%eax),%edx
8010030b:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100311:	89 c2                	mov    %eax,%edx
80100313:	83 e2 7f             	and    $0x7f,%edx
80100316:	0f be 92 20 ff 10 80 	movsbl -0x7fef00e0(%edx),%edx
    if(c == C('D')){  // EOF
8010031d:	83 fa 04             	cmp    $0x4,%edx
80100320:	74 39                	je     8010035b <consoleread+0xeb>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100322:	83 c6 01             	add    $0x1,%esi
    --n;
80100325:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100328:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
8010032b:	88 56 ff             	mov    %dl,-0x1(%esi)
    --n;
    if(c == '\n')
8010032e:	74 35                	je     80100365 <consoleread+0xf5>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100330:	85 db                	test   %ebx,%ebx
80100332:	0f 85 69 ff ff ff    	jne    801002a1 <consoleread+0x31>
80100338:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
8010033b:	83 ec 0c             	sub    $0xc,%esp
8010033e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100341:	68 20 a5 10 80       	push   $0x8010a520
80100346:	e8 05 42 00 00       	call   80104550 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 0d 13 00 00       	call   80101660 <ilock>

  return target - n;
80100353:	83 c4 10             	add    $0x10,%esp
80100356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100359:	eb a0                	jmp    801002fb <consoleread+0x8b>
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
8010035b:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010035e:	76 05                	jbe    80100365 <consoleread+0xf5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100360:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100365:	8b 45 10             	mov    0x10(%ebp),%eax
80100368:	29 d8                	sub    %ebx,%eax
8010036a:	eb cf                	jmp    8010033b <consoleread+0xcb>
8010036c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100370 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100370:	55                   	push   %ebp
80100371:	89 e5                	mov    %esp,%ebp
80100373:	56                   	push   %esi
80100374:	53                   	push   %ebx
80100375:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100378:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100379:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100380:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100383:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100386:	8d 75 f8             	lea    -0x8(%ebp),%esi
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100389:	e8 52 23 00 00       	call   801026e0 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 8d 70 10 80       	push   $0x8010708d
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 db 79 10 80 	movl   $0x801079db,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 a3 3f 00 00       	call   80104360 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 a1 70 10 80       	push   $0x801070a1
801003cd:	e8 8e 02 00 00       	call   80100660 <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003d2:	83 c4 10             	add    $0x10,%esp
801003d5:	39 f3                	cmp    %esi,%ebx
801003d7:	75 e7                	jne    801003c0 <panic+0x50>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003d9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003e0:	00 00 00 
801003e3:	eb fe                	jmp    801003e3 <panic+0x73>
801003e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801003e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801003f0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003f0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003f6:	85 d2                	test   %edx,%edx
801003f8:	74 06                	je     80100400 <consputc+0x10>
801003fa:	fa                   	cli    
801003fb:	eb fe                	jmp    801003fb <consputc+0xb>
801003fd:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 0c             	sub    $0xc,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 b8 00 00 00    	je     801004ce <consputc+0xde>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 f1 57 00 00       	call   80105c10 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	c1 e0 08             	shl    $0x8,%eax
8010043f:	89 c1                	mov    %eax,%ecx
80100441:	b8 0f 00 00 00       	mov    $0xf,%eax
80100446:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100447:	89 f2                	mov    %esi,%edx
80100449:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
8010044a:	0f b6 c0             	movzbl %al,%eax
8010044d:	09 c8                	or     %ecx,%eax

  if(c == '\n')
8010044f:	83 fb 0a             	cmp    $0xa,%ebx
80100452:	0f 84 0b 01 00 00    	je     80100563 <consputc+0x173>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100458:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045e:	0f 84 e6 00 00 00    	je     8010054a <consputc+0x15a>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100464:	0f b6 d3             	movzbl %bl,%edx
80100467:	8d 78 01             	lea    0x1(%eax),%edi
8010046a:	80 ce 07             	or     $0x7,%dh
8010046d:	66 89 94 00 00 80 0b 	mov    %dx,-0x7ff48000(%eax,%eax,1)
80100474:	80 

  if(pos < 0 || pos > 25*80)
80100475:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
8010047b:	0f 8f bc 00 00 00    	jg     8010053d <consputc+0x14d>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
80100481:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100487:	7f 6f                	jg     801004f8 <consputc+0x108>
80100489:	89 f8                	mov    %edi,%eax
8010048b:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
80100492:	89 fb                	mov    %edi,%ebx
80100494:	c1 e8 08             	shr    $0x8,%eax
80100497:	89 c6                	mov    %eax,%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100499:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010049e:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a3:	89 fa                	mov    %edi,%edx
801004a5:	ee                   	out    %al,(%dx)
801004a6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004ab:	89 f0                	mov    %esi,%eax
801004ad:	ee                   	out    %al,(%dx)
801004ae:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b3:	89 fa                	mov    %edi,%edx
801004b5:	ee                   	out    %al,(%dx)
801004b6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004bb:	89 d8                	mov    %ebx,%eax
801004bd:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004be:	b8 20 07 00 00       	mov    $0x720,%eax
801004c3:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c9:	5b                   	pop    %ebx
801004ca:	5e                   	pop    %esi
801004cb:	5f                   	pop    %edi
801004cc:	5d                   	pop    %ebp
801004cd:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004ce:	83 ec 0c             	sub    $0xc,%esp
801004d1:	6a 08                	push   $0x8
801004d3:	e8 38 57 00 00       	call   80105c10 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 2c 57 00 00       	call   80105c10 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 20 57 00 00       	call   80105c10 <uartputc>
801004f0:	83 c4 10             	add    $0x10,%esp
801004f3:	e9 2a ff ff ff       	jmp    80100422 <consputc+0x32>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f8:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801004fb:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004fe:	68 60 0e 00 00       	push   $0xe60
80100503:	68 a0 80 0b 80       	push   $0x800b80a0
80100508:	68 00 80 0b 80       	push   $0x800b8000
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010050d:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100514:	e8 37 41 00 00       	call   80104650 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 72 40 00 00       	call   801045a0 <memset>
8010052e:	89 f1                	mov    %esi,%ecx
80100530:	83 c4 10             	add    $0x10,%esp
80100533:	be 07 00 00 00       	mov    $0x7,%esi
80100538:	e9 5c ff ff ff       	jmp    80100499 <consputc+0xa9>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010053d:	83 ec 0c             	sub    $0xc,%esp
80100540:	68 a5 70 10 80       	push   $0x801070a5
80100545:	e8 26 fe ff ff       	call   80100370 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
8010054a:	85 c0                	test   %eax,%eax
8010054c:	8d 78 ff             	lea    -0x1(%eax),%edi
8010054f:	0f 85 20 ff ff ff    	jne    80100475 <consputc+0x85>
80100555:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
8010055a:	31 db                	xor    %ebx,%ebx
8010055c:	31 f6                	xor    %esi,%esi
8010055e:	e9 36 ff ff ff       	jmp    80100499 <consputc+0xa9>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
80100563:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100568:	f7 ea                	imul   %edx
8010056a:	89 d0                	mov    %edx,%eax
8010056c:	c1 e8 05             	shr    $0x5,%eax
8010056f:	8d 04 80             	lea    (%eax,%eax,4),%eax
80100572:	c1 e0 04             	shl    $0x4,%eax
80100575:	8d 78 50             	lea    0x50(%eax),%edi
80100578:	e9 f8 fe ff ff       	jmp    80100475 <consputc+0x85>
8010057d:	8d 76 00             	lea    0x0(%esi),%esi

80100580 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d6                	mov    %edx,%esi
80100588:	83 ec 2c             	sub    $0x2c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100590:	74 0c                	je     8010059e <printint+0x1e>
80100592:	89 c7                	mov    %eax,%edi
80100594:	c1 ef 1f             	shr    $0x1f,%edi
80100597:	85 c0                	test   %eax,%eax
80100599:	89 7d d4             	mov    %edi,-0x2c(%ebp)
8010059c:	78 51                	js     801005ef <printint+0x6f>
    x = -xx;
  else
    x = xx;

  i = 0;
8010059e:	31 ff                	xor    %edi,%edi
801005a0:	8d 5d d7             	lea    -0x29(%ebp),%ebx
801005a3:	eb 05                	jmp    801005aa <printint+0x2a>
801005a5:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
801005a8:	89 cf                	mov    %ecx,%edi
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 4f 01             	lea    0x1(%edi),%ecx
801005af:	f7 f6                	div    %esi
801005b1:	0f b6 92 d0 70 10 80 	movzbl -0x7fef8f30(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005ba:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>

  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
801005cb:	8d 4f 02             	lea    0x2(%edi),%ecx
801005ce:	8d 74 0d d7          	lea    -0x29(%ebp,%ecx,1),%esi
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  while(--i >= 0)
    consputc(buf[i]);
801005d8:	0f be 06             	movsbl (%esi),%eax
801005db:	83 ee 01             	sub    $0x1,%esi
801005de:	e8 0d fe ff ff       	call   801003f0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005e3:	39 de                	cmp    %ebx,%esi
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
    consputc(buf[i]);
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
801005ef:	f7 d8                	neg    %eax
801005f1:	eb ab                	jmp    8010059e <printint+0x1e>
801005f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100600 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100609:	ff 75 08             	pushl  0x8(%ebp)
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
8010060c:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060f:	e8 2c 11 00 00       	call   80101740 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 80 3e 00 00       	call   801044a0 <acquire>
80100620:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100623:	83 c4 10             	add    $0x10,%esp
80100626:	85 f6                	test   %esi,%esi
80100628:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062b:	7e 12                	jle    8010063f <consolewrite+0x3f>
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 b5 fd ff ff       	call   801003f0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010063b:	39 df                	cmp    %ebx,%edi
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 04 3f 00 00       	call   80104550 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 0b 10 00 00       	call   80101660 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100670:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100673:	0f 85 47 01 00 00    	jne    801007c0 <cprintf+0x160>
    acquire(&cons.lock);

  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c1                	mov    %eax,%ecx
80100680:	0f 84 4f 01 00 00    	je     801007d5 <cprintf+0x175>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
80100689:	31 db                	xor    %ebx,%ebx
8010068b:	8d 75 0c             	lea    0xc(%ebp),%esi
8010068e:	89 cf                	mov    %ecx,%edi
80100690:	85 c0                	test   %eax,%eax
80100692:	75 55                	jne    801006e9 <cprintf+0x89>
80100694:	eb 68                	jmp    801006fe <cprintf+0x9e>
80100696:	8d 76 00             	lea    0x0(%esi),%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
801006a0:	83 c3 01             	add    $0x1,%ebx
801006a3:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
801006a7:	85 d2                	test   %edx,%edx
801006a9:	74 53                	je     801006fe <cprintf+0x9e>
      break;
    switch(c){
801006ab:	83 fa 70             	cmp    $0x70,%edx
801006ae:	74 7a                	je     8010072a <cprintf+0xca>
801006b0:	7f 6e                	jg     80100720 <cprintf+0xc0>
801006b2:	83 fa 25             	cmp    $0x25,%edx
801006b5:	0f 84 ad 00 00 00    	je     80100768 <cprintf+0x108>
801006bb:	83 fa 64             	cmp    $0x64,%edx
801006be:	0f 85 84 00 00 00    	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
801006c4:	8d 46 04             	lea    0x4(%esi),%eax
801006c7:	b9 01 00 00 00       	mov    $0x1,%ecx
801006cc:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d4:	8b 06                	mov    (%esi),%eax
801006d6:	e8 a5 fe ff ff       	call   80100580 <printint>
801006db:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006de:	83 c3 01             	add    $0x1,%ebx
801006e1:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e5:	85 c0                	test   %eax,%eax
801006e7:	74 15                	je     801006fe <cprintf+0x9e>
    if(c != '%'){
801006e9:	83 f8 25             	cmp    $0x25,%eax
801006ec:	74 b2                	je     801006a0 <cprintf+0x40>
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
801006ee:	e8 fd fc ff ff       	call   801003f0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006f3:	83 c3 01             	add    $0x1,%ebx
801006f6:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006fa:	85 c0                	test   %eax,%eax
801006fc:	75 eb                	jne    801006e9 <cprintf+0x89>
      consputc(c);
      break;
    }
  }

  if(locking)
801006fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100701:	85 c0                	test   %eax,%eax
80100703:	74 10                	je     80100715 <cprintf+0xb5>
    release(&cons.lock);
80100705:	83 ec 0c             	sub    $0xc,%esp
80100708:	68 20 a5 10 80       	push   $0x8010a520
8010070d:	e8 3e 3e 00 00       	call   80104550 <release>
80100712:	83 c4 10             	add    $0x10,%esp
}
80100715:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100718:	5b                   	pop    %ebx
80100719:	5e                   	pop    %esi
8010071a:	5f                   	pop    %edi
8010071b:	5d                   	pop    %ebp
8010071c:	c3                   	ret    
8010071d:	8d 76 00             	lea    0x0(%esi),%esi
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100720:	83 fa 73             	cmp    $0x73,%edx
80100723:	74 5b                	je     80100780 <cprintf+0x120>
80100725:	83 fa 78             	cmp    $0x78,%edx
80100728:	75 1e                	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010072a:	8d 46 04             	lea    0x4(%esi),%eax
8010072d:	31 c9                	xor    %ecx,%ecx
8010072f:	ba 10 00 00 00       	mov    $0x10,%edx
80100734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100737:	8b 06                	mov    (%esi),%eax
80100739:	e8 42 fe ff ff       	call   80100580 <printint>
8010073e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100741:	eb 9b                	jmp    801006de <cprintf+0x7e>
80100743:	90                   	nop
80100744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100750:	e8 9b fc ff ff       	call   801003f0 <consputc>
      consputc(c);
80100755:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100758:	89 d0                	mov    %edx,%eax
8010075a:	e8 91 fc ff ff       	call   801003f0 <consputc>
      break;
8010075f:	e9 7a ff ff ff       	jmp    801006de <cprintf+0x7e>
80100764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100768:	b8 25 00 00 00       	mov    $0x25,%eax
8010076d:	e8 7e fc ff ff       	call   801003f0 <consputc>
80100772:	e9 7c ff ff ff       	jmp    801006f3 <cprintf+0x93>
80100777:	89 f6                	mov    %esi,%esi
80100779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100780:	8d 46 04             	lea    0x4(%esi),%eax
80100783:	8b 36                	mov    (%esi),%esi
80100785:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100788:	b8 b8 70 10 80       	mov    $0x801070b8,%eax
8010078d:	85 f6                	test   %esi,%esi
8010078f:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
80100792:	0f be 06             	movsbl (%esi),%eax
80100795:	84 c0                	test   %al,%al
80100797:	74 16                	je     801007af <cprintf+0x14f>
80100799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007a0:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
801007a3:	e8 48 fc ff ff       	call   801003f0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801007a8:	0f be 06             	movsbl (%esi),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
801007af:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801007b2:	e9 27 ff ff ff       	jmp    801006de <cprintf+0x7e>
801007b7:	89 f6                	mov    %esi,%esi
801007b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
801007c0:	83 ec 0c             	sub    $0xc,%esp
801007c3:	68 20 a5 10 80       	push   $0x8010a520
801007c8:	e8 d3 3c 00 00       	call   801044a0 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 bf 70 10 80       	push   $0x801070bf
801007dd:	e8 8e fb ff ff       	call   80100370 <panic>
801007e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801007f0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f0:	55                   	push   %ebp
801007f1:	89 e5                	mov    %esp,%ebp
801007f3:	57                   	push   %edi
801007f4:	56                   	push   %esi
801007f5:	53                   	push   %ebx
  int c, doprocdump = 0;
801007f6:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f8:	83 ec 18             	sub    $0x18,%esp
801007fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007fe:	68 20 a5 10 80       	push   $0x8010a520
80100803:	e8 98 3c 00 00       	call   801044a0 <acquire>
  while((c = getc()) >= 0){
80100808:	83 c4 10             	add    $0x10,%esp
8010080b:	90                   	nop
8010080c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100810:	ff d3                	call   *%ebx
80100812:	85 c0                	test   %eax,%eax
80100814:	89 c7                	mov    %eax,%edi
80100816:	78 48                	js     80100860 <consoleintr+0x70>
    switch(c){
80100818:	83 ff 10             	cmp    $0x10,%edi
8010081b:	0f 84 3f 01 00 00    	je     80100960 <consoleintr+0x170>
80100821:	7e 5d                	jle    80100880 <consoleintr+0x90>
80100823:	83 ff 15             	cmp    $0x15,%edi
80100826:	0f 84 dc 00 00 00    	je     80100908 <consoleintr+0x118>
8010082c:	83 ff 7f             	cmp    $0x7f,%edi
8010082f:	75 54                	jne    80100885 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100831:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100836:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010083c:	74 d2                	je     80100810 <consoleintr+0x20>
        input.e--;
8010083e:	83 e8 01             	sub    $0x1,%eax
80100841:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100846:	b8 00 01 00 00       	mov    $0x100,%eax
8010084b:	e8 a0 fb ff ff       	call   801003f0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100850:	ff d3                	call   *%ebx
80100852:	85 c0                	test   %eax,%eax
80100854:	89 c7                	mov    %eax,%edi
80100856:	79 c0                	jns    80100818 <consoleintr+0x28>
80100858:	90                   	nop
80100859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100860:	83 ec 0c             	sub    $0xc,%esp
80100863:	68 20 a5 10 80       	push   $0x8010a520
80100868:	e8 e3 3c 00 00       	call   80104550 <release>
  if(doprocdump) {
8010086d:	83 c4 10             	add    $0x10,%esp
80100870:	85 f6                	test   %esi,%esi
80100872:	0f 85 f8 00 00 00    	jne    80100970 <consoleintr+0x180>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100878:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010087b:	5b                   	pop    %ebx
8010087c:	5e                   	pop    %esi
8010087d:	5f                   	pop    %edi
8010087e:	5d                   	pop    %ebp
8010087f:	c3                   	ret    
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100880:	83 ff 08             	cmp    $0x8,%edi
80100883:	74 ac                	je     80100831 <consoleintr+0x41>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100885:	85 ff                	test   %edi,%edi
80100887:	74 87                	je     80100810 <consoleintr+0x20>
80100889:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010088e:	89 c2                	mov    %eax,%edx
80100890:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100896:	83 fa 7f             	cmp    $0x7f,%edx
80100899:	0f 87 71 ff ff ff    	ja     80100810 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010089f:	8d 50 01             	lea    0x1(%eax),%edx
801008a2:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008a5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008a8:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008ae:	0f 84 c8 00 00 00    	je     8010097c <consoleintr+0x18c>
        input.buf[input.e++ % INPUT_BUF] = c;
801008b4:	89 f9                	mov    %edi,%ecx
801008b6:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
801008bc:	89 f8                	mov    %edi,%eax
801008be:	e8 2d fb ff ff       	call   801003f0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c3:	83 ff 0a             	cmp    $0xa,%edi
801008c6:	0f 84 c1 00 00 00    	je     8010098d <consoleintr+0x19d>
801008cc:	83 ff 04             	cmp    $0x4,%edi
801008cf:	0f 84 b8 00 00 00    	je     8010098d <consoleintr+0x19d>
801008d5:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801008da:	83 e8 80             	sub    $0xffffff80,%eax
801008dd:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
801008e3:	0f 85 27 ff ff ff    	jne    80100810 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008e9:	83 ec 0c             	sub    $0xc,%esp
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ec:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
801008f1:	68 a0 ff 10 80       	push   $0x8010ffa0
801008f6:	e8 05 36 00 00       	call   80103f00 <wakeup>
801008fb:	83 c4 10             	add    $0x10,%esp
801008fe:	e9 0d ff ff ff       	jmp    80100810 <consoleintr+0x20>
80100903:	90                   	nop
80100904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100908:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010090d:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
80100913:	75 2b                	jne    80100940 <consoleintr+0x150>
80100915:	e9 f6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100920:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100925:	b8 00 01 00 00       	mov    $0x100,%eax
8010092a:	e8 c1 fa ff ff       	call   801003f0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010092f:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100934:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010093a:	0f 84 d0 fe ff ff    	je     80100810 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100940:	83 e8 01             	sub    $0x1,%eax
80100943:	89 c2                	mov    %eax,%edx
80100945:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100948:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
8010094f:	75 cf                	jne    80100920 <consoleintr+0x130>
80100951:	e9 ba fe ff ff       	jmp    80100810 <consoleintr+0x20>
80100956:	8d 76 00             	lea    0x0(%esi),%esi
80100959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100960:	be 01 00 00 00       	mov    $0x1,%esi
80100965:	e9 a6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010096a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100970:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100973:	5b                   	pop    %ebx
80100974:	5e                   	pop    %esi
80100975:	5f                   	pop    %edi
80100976:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100977:	e9 74 36 00 00       	jmp    80103ff0 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010097c:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
80100983:	b8 0a 00 00 00       	mov    $0xa,%eax
80100988:	e8 63 fa ff ff       	call   801003f0 <consputc>
8010098d:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100992:	e9 52 ff ff ff       	jmp    801008e9 <consoleintr+0xf9>
80100997:	89 f6                	mov    %esi,%esi
80100999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801009a0 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009a6:	68 c8 70 10 80       	push   $0x801070c8
801009ab:	68 20 a5 10 80       	push   $0x8010a520
801009b0:	e8 8b 39 00 00       	call   80104340 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009b5:	58                   	pop    %eax
801009b6:	5a                   	pop    %edx
801009b7:	6a 00                	push   $0x0
801009b9:	6a 01                	push   $0x1
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
801009bb:	c7 05 6c 09 11 80 00 	movl   $0x80100600,0x8011096c
801009c2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009c5:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
801009cc:	02 10 80 
  cons.locking = 1;
801009cf:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009d6:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801009d9:	e8 b2 18 00 00       	call   80102290 <ioapicenable>
}
801009de:	83 c4 10             	add    $0x10,%esp
801009e1:	c9                   	leave  
801009e2:	c3                   	ret    
801009e3:	66 90                	xchg   %ax,%ax
801009e5:	66 90                	xchg   %ax,%ax
801009e7:	66 90                	xchg   %ax,%ax
801009e9:	66 90                	xchg   %ax,%ax
801009eb:	66 90                	xchg   %ax,%ax
801009ed:	66 90                	xchg   %ax,%ax
801009ef:	90                   	nop

801009f0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009f0:	55                   	push   %ebp
801009f1:	89 e5                	mov    %esp,%ebp
801009f3:	57                   	push   %edi
801009f4:	56                   	push   %esi
801009f5:	53                   	push   %ebx
801009f6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009fc:	e8 8f 2d 00 00       	call   80103790 <myproc>
80100a01:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a07:	e8 34 21 00 00       	call   80102b40 <begin_op>

  if((ip = namei(path)) == 0){
80100a0c:	83 ec 0c             	sub    $0xc,%esp
80100a0f:	ff 75 08             	pushl  0x8(%ebp)
80100a12:	e8 99 14 00 00       	call   80101eb0 <namei>
80100a17:	83 c4 10             	add    $0x10,%esp
80100a1a:	85 c0                	test   %eax,%eax
80100a1c:	0f 84 9c 01 00 00    	je     80100bbe <exec+0x1ce>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a22:	83 ec 0c             	sub    $0xc,%esp
80100a25:	89 c3                	mov    %eax,%ebx
80100a27:	50                   	push   %eax
80100a28:	e8 33 0c 00 00       	call   80101660 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a2d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a33:	6a 34                	push   $0x34
80100a35:	6a 00                	push   $0x0
80100a37:	50                   	push   %eax
80100a38:	53                   	push   %ebx
80100a39:	e8 02 0f 00 00       	call   80101940 <readi>
80100a3e:	83 c4 20             	add    $0x20,%esp
80100a41:	83 f8 34             	cmp    $0x34,%eax
80100a44:	74 22                	je     80100a68 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a46:	83 ec 0c             	sub    $0xc,%esp
80100a49:	53                   	push   %ebx
80100a4a:	e8 a1 0e 00 00       	call   801018f0 <iunlockput>
    end_op();
80100a4f:	e8 5c 21 00 00       	call   80102bb0 <end_op>
80100a54:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a5f:	5b                   	pop    %ebx
80100a60:	5e                   	pop    %esi
80100a61:	5f                   	pop    %edi
80100a62:	5d                   	pop    %ebp
80100a63:	c3                   	ret    
80100a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a68:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a6f:	45 4c 46 
80100a72:	75 d2                	jne    80100a46 <exec+0x56>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a74:	e8 27 63 00 00       	call   80106da0 <setupkvm>
80100a79:	85 c0                	test   %eax,%eax
80100a7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a81:	74 c3                	je     80100a46 <exec+0x56>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a83:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a8a:	00 
80100a8b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100a91:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a98:	00 00 00 
80100a9b:	0f 84 c5 00 00 00    	je     80100b66 <exec+0x176>
80100aa1:	31 ff                	xor    %edi,%edi
80100aa3:	eb 18                	jmp    80100abd <exec+0xcd>
80100aa5:	8d 76 00             	lea    0x0(%esi),%esi
80100aa8:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100aaf:	83 c7 01             	add    $0x1,%edi
80100ab2:	83 c6 20             	add    $0x20,%esi
80100ab5:	39 f8                	cmp    %edi,%eax
80100ab7:	0f 8e a9 00 00 00    	jle    80100b66 <exec+0x176>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100abd:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100ac3:	6a 20                	push   $0x20
80100ac5:	56                   	push   %esi
80100ac6:	50                   	push   %eax
80100ac7:	53                   	push   %ebx
80100ac8:	e8 73 0e 00 00       	call   80101940 <readi>
80100acd:	83 c4 10             	add    $0x10,%esp
80100ad0:	83 f8 20             	cmp    $0x20,%eax
80100ad3:	75 7b                	jne    80100b50 <exec+0x160>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100ad5:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100adc:	75 ca                	jne    80100aa8 <exec+0xb8>
      continue;
    if(ph.memsz < ph.filesz)
80100ade:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ae4:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100aea:	72 64                	jb     80100b50 <exec+0x160>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100aec:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100af2:	72 5c                	jb     80100b50 <exec+0x160>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100af4:	83 ec 04             	sub    $0x4,%esp
80100af7:	50                   	push   %eax
80100af8:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100afe:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b04:	e8 e7 60 00 00       	call   80106bf0 <allocuvm>
80100b09:	83 c4 10             	add    $0x10,%esp
80100b0c:	85 c0                	test   %eax,%eax
80100b0e:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100b14:	74 3a                	je     80100b50 <exec+0x160>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b16:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b1c:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b21:	75 2d                	jne    80100b50 <exec+0x160>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b23:	83 ec 0c             	sub    $0xc,%esp
80100b26:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b2c:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b32:	53                   	push   %ebx
80100b33:	50                   	push   %eax
80100b34:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b3a:	e8 f1 5f 00 00       	call   80106b30 <loaduvm>
80100b3f:	83 c4 20             	add    $0x20,%esp
80100b42:	85 c0                	test   %eax,%eax
80100b44:	0f 89 5e ff ff ff    	jns    80100aa8 <exec+0xb8>
80100b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b50:	83 ec 0c             	sub    $0xc,%esp
80100b53:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b59:	e8 c2 61 00 00       	call   80106d20 <freevm>
80100b5e:	83 c4 10             	add    $0x10,%esp
80100b61:	e9 e0 fe ff ff       	jmp    80100a46 <exec+0x56>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b66:	83 ec 0c             	sub    $0xc,%esp
80100b69:	53                   	push   %ebx
80100b6a:	e8 81 0d 00 00       	call   801018f0 <iunlockput>
  end_op();
80100b6f:	e8 3c 20 00 00       	call   80102bb0 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b74:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b7a:	83 c4 0c             	add    $0xc,%esp
  end_op();
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b7d:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b87:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b8d:	52                   	push   %edx
80100b8e:	50                   	push   %eax
80100b8f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b95:	e8 56 60 00 00       	call   80106bf0 <allocuvm>
80100b9a:	83 c4 10             	add    $0x10,%esp
80100b9d:	85 c0                	test   %eax,%eax
80100b9f:	89 c6                	mov    %eax,%esi
80100ba1:	75 3a                	jne    80100bdd <exec+0x1ed>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100ba3:	83 ec 0c             	sub    $0xc,%esp
80100ba6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bac:	e8 6f 61 00 00       	call   80106d20 <freevm>
80100bb1:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100bb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bb9:	e9 9e fe ff ff       	jmp    80100a5c <exec+0x6c>
  struct proc *curproc = myproc();

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100bbe:	e8 ed 1f 00 00       	call   80102bb0 <end_op>
    cprintf("exec: fail\n");
80100bc3:	83 ec 0c             	sub    $0xc,%esp
80100bc6:	68 e1 70 10 80       	push   $0x801070e1
80100bcb:	e8 90 fa ff ff       	call   80100660 <cprintf>
    return -1;
80100bd0:	83 c4 10             	add    $0x10,%esp
80100bd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bd8:	e9 7f fe ff ff       	jmp    80100a5c <exec+0x6c>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bdd:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100be3:	83 ec 08             	sub    $0x8,%esp
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100be6:	31 ff                	xor    %edi,%edi
80100be8:	89 f3                	mov    %esi,%ebx
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bea:	50                   	push   %eax
80100beb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bf1:	e8 4a 62 00 00       	call   80106e40 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bf9:	83 c4 10             	add    $0x10,%esp
80100bfc:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c02:	8b 00                	mov    (%eax),%eax
80100c04:	85 c0                	test   %eax,%eax
80100c06:	74 79                	je     80100c81 <exec+0x291>
80100c08:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c0e:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c14:	eb 13                	jmp    80100c29 <exec+0x239>
80100c16:	8d 76 00             	lea    0x0(%esi),%esi
80100c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(argc >= MAXARG)
80100c20:	83 ff 20             	cmp    $0x20,%edi
80100c23:	0f 84 7a ff ff ff    	je     80100ba3 <exec+0x1b3>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c29:	83 ec 0c             	sub    $0xc,%esp
80100c2c:	50                   	push   %eax
80100c2d:	e8 ae 3b 00 00       	call   801047e0 <strlen>
80100c32:	f7 d0                	not    %eax
80100c34:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c36:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c39:	5a                   	pop    %edx

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c3a:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c3d:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c40:	e8 9b 3b 00 00       	call   801047e0 <strlen>
80100c45:	83 c0 01             	add    $0x1,%eax
80100c48:	50                   	push   %eax
80100c49:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c4c:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4f:	53                   	push   %ebx
80100c50:	56                   	push   %esi
80100c51:	e8 5a 63 00 00       	call   80106fb0 <copyout>
80100c56:	83 c4 20             	add    $0x20,%esp
80100c59:	85 c0                	test   %eax,%eax
80100c5b:	0f 88 42 ff ff ff    	js     80100ba3 <exec+0x1b3>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c61:	8b 45 0c             	mov    0xc(%ebp),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c64:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c6b:	83 c7 01             	add    $0x1,%edi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c6e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c74:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c77:	85 c0                	test   %eax,%eax
80100c79:	75 a5                	jne    80100c20 <exec+0x230>
80100c7b:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c81:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c88:	89 d9                	mov    %ebx,%ecx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c8a:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c91:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100c95:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c9c:	ff ff ff 
  ustack[1] = argc;
80100c9f:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ca5:	29 c1                	sub    %eax,%ecx

  sp -= (3+argc+1) * 4;
80100ca7:	83 c0 0c             	add    $0xc,%eax
80100caa:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cac:	50                   	push   %eax
80100cad:	52                   	push   %edx
80100cae:	53                   	push   %ebx
80100caf:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb5:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cbb:	e8 f0 62 00 00       	call   80106fb0 <copyout>
80100cc0:	83 c4 10             	add    $0x10,%esp
80100cc3:	85 c0                	test   %eax,%eax
80100cc5:	0f 88 d8 fe ff ff    	js     80100ba3 <exec+0x1b3>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ccb:	8b 45 08             	mov    0x8(%ebp),%eax
80100cce:	0f b6 10             	movzbl (%eax),%edx
80100cd1:	84 d2                	test   %dl,%dl
80100cd3:	74 19                	je     80100cee <exec+0x2fe>
80100cd5:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cd8:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100cdb:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cde:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100ce1:	0f 44 c8             	cmove  %eax,%ecx
80100ce4:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ce7:	84 d2                	test   %dl,%dl
80100ce9:	75 f0                	jne    80100cdb <exec+0x2eb>
80100ceb:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cee:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cf4:	50                   	push   %eax
80100cf5:	6a 10                	push   $0x10
80100cf7:	ff 75 08             	pushl  0x8(%ebp)
80100cfa:	89 f8                	mov    %edi,%eax
80100cfc:	83 c0 6c             	add    $0x6c,%eax
80100cff:	50                   	push   %eax
80100d00:	e8 9b 3a 00 00       	call   801047a0 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d05:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100d0b:	89 f8                	mov    %edi,%eax
80100d0d:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->pgdir = pgdir;
  curproc->sz = sz;
80100d10:	89 30                	mov    %esi,(%eax)
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d12:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
80100d15:	89 c1                	mov    %eax,%ecx
80100d17:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d1d:	8b 40 18             	mov    0x18(%eax),%eax
80100d20:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d23:	8b 41 18             	mov    0x18(%ecx),%eax
80100d26:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d29:	89 0c 24             	mov    %ecx,(%esp)
80100d2c:	e8 6f 5c 00 00       	call   801069a0 <switchuvm>
  freevm(oldpgdir);
80100d31:	89 3c 24             	mov    %edi,(%esp)
80100d34:	e8 e7 5f 00 00       	call   80106d20 <freevm>
  return 0;
80100d39:	83 c4 10             	add    $0x10,%esp
80100d3c:	31 c0                	xor    %eax,%eax
80100d3e:	e9 19 fd ff ff       	jmp    80100a5c <exec+0x6c>
80100d43:	66 90                	xchg   %ax,%ax
80100d45:	66 90                	xchg   %ax,%ax
80100d47:	66 90                	xchg   %ax,%ax
80100d49:	66 90                	xchg   %ax,%ax
80100d4b:	66 90                	xchg   %ax,%ax
80100d4d:	66 90                	xchg   %ax,%ax
80100d4f:	90                   	nop

80100d50 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d56:	68 ed 70 10 80       	push   $0x801070ed
80100d5b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d60:	e8 db 35 00 00       	call   80104340 <initlock>
}
80100d65:	83 c4 10             	add    $0x10,%esp
80100d68:	c9                   	leave  
80100d69:	c3                   	ret    
80100d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d70 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d70:	55                   	push   %ebp
80100d71:	89 e5                	mov    %esp,%ebp
80100d73:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d74:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d79:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d7c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d81:	e8 1a 37 00 00       	call   801044a0 <acquire>
80100d86:	83 c4 10             	add    $0x10,%esp
80100d89:	eb 10                	jmp    80100d9b <filealloc+0x2b>
80100d8b:	90                   	nop
80100d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d90:	83 c3 18             	add    $0x18,%ebx
80100d93:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100d99:	74 25                	je     80100dc0 <filealloc+0x50>
    if(f->ref == 0){
80100d9b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d9e:	85 c0                	test   %eax,%eax
80100da0:	75 ee                	jne    80100d90 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100da2:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100da5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dac:	68 c0 ff 10 80       	push   $0x8010ffc0
80100db1:	e8 9a 37 00 00       	call   80104550 <release>
      return f;
80100db6:	89 d8                	mov    %ebx,%eax
80100db8:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dbe:	c9                   	leave  
80100dbf:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100dc0:	83 ec 0c             	sub    $0xc,%esp
80100dc3:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dc8:	e8 83 37 00 00       	call   80104550 <release>
  return 0;
80100dcd:	83 c4 10             	add    $0x10,%esp
80100dd0:	31 c0                	xor    %eax,%eax
}
80100dd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dd5:	c9                   	leave  
80100dd6:	c3                   	ret    
80100dd7:	89 f6                	mov    %esi,%esi
80100dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100de0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	53                   	push   %ebx
80100de4:	83 ec 10             	sub    $0x10,%esp
80100de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dea:	68 c0 ff 10 80       	push   $0x8010ffc0
80100def:	e8 ac 36 00 00       	call   801044a0 <acquire>
  if(f->ref < 1)
80100df4:	8b 43 04             	mov    0x4(%ebx),%eax
80100df7:	83 c4 10             	add    $0x10,%esp
80100dfa:	85 c0                	test   %eax,%eax
80100dfc:	7e 1a                	jle    80100e18 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100dfe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e01:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
80100e04:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e07:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e0c:	e8 3f 37 00 00       	call   80104550 <release>
  return f;
}
80100e11:	89 d8                	mov    %ebx,%eax
80100e13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e16:	c9                   	leave  
80100e17:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e18:	83 ec 0c             	sub    $0xc,%esp
80100e1b:	68 f4 70 10 80       	push   $0x801070f4
80100e20:	e8 4b f5 ff ff       	call   80100370 <panic>
80100e25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e30 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	57                   	push   %edi
80100e34:	56                   	push   %esi
80100e35:	53                   	push   %ebx
80100e36:	83 ec 28             	sub    $0x28,%esp
80100e39:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e3c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e41:	e8 5a 36 00 00       	call   801044a0 <acquire>
  if(f->ref < 1)
80100e46:	8b 47 04             	mov    0x4(%edi),%eax
80100e49:	83 c4 10             	add    $0x10,%esp
80100e4c:	85 c0                	test   %eax,%eax
80100e4e:	0f 8e 9b 00 00 00    	jle    80100eef <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e54:	83 e8 01             	sub    $0x1,%eax
80100e57:	85 c0                	test   %eax,%eax
80100e59:	89 47 04             	mov    %eax,0x4(%edi)
80100e5c:	74 1a                	je     80100e78 <fileclose+0x48>
    release(&ftable.lock);
80100e5e:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e68:	5b                   	pop    %ebx
80100e69:	5e                   	pop    %esi
80100e6a:	5f                   	pop    %edi
80100e6b:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e6c:	e9 df 36 00 00       	jmp    80104550 <release>
80100e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80100e78:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e7c:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e7e:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e81:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
80100e84:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e8a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e8d:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e90:	68 c0 ff 10 80       	push   $0x8010ffc0
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e95:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e98:	e8 b3 36 00 00       	call   80104550 <release>

  if(ff.type == FD_PIPE)
80100e9d:	83 c4 10             	add    $0x10,%esp
80100ea0:	83 fb 01             	cmp    $0x1,%ebx
80100ea3:	74 13                	je     80100eb8 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100ea5:	83 fb 02             	cmp    $0x2,%ebx
80100ea8:	74 26                	je     80100ed0 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100eaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ead:	5b                   	pop    %ebx
80100eae:	5e                   	pop    %esi
80100eaf:	5f                   	pop    %edi
80100eb0:	5d                   	pop    %ebp
80100eb1:	c3                   	ret    
80100eb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100eb8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ebc:	83 ec 08             	sub    $0x8,%esp
80100ebf:	53                   	push   %ebx
80100ec0:	56                   	push   %esi
80100ec1:	e8 1a 24 00 00       	call   801032e0 <pipeclose>
80100ec6:	83 c4 10             	add    $0x10,%esp
80100ec9:	eb df                	jmp    80100eaa <fileclose+0x7a>
80100ecb:	90                   	nop
80100ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100ed0:	e8 6b 1c 00 00       	call   80102b40 <begin_op>
    iput(ff.ip);
80100ed5:	83 ec 0c             	sub    $0xc,%esp
80100ed8:	ff 75 e0             	pushl  -0x20(%ebp)
80100edb:	e8 b0 08 00 00       	call   80101790 <iput>
    end_op();
80100ee0:	83 c4 10             	add    $0x10,%esp
  }
}
80100ee3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ee6:	5b                   	pop    %ebx
80100ee7:	5e                   	pop    %esi
80100ee8:	5f                   	pop    %edi
80100ee9:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100eea:	e9 c1 1c 00 00       	jmp    80102bb0 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100eef:	83 ec 0c             	sub    $0xc,%esp
80100ef2:	68 fc 70 10 80       	push   $0x801070fc
80100ef7:	e8 74 f4 ff ff       	call   80100370 <panic>
80100efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f00 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	53                   	push   %ebx
80100f04:	83 ec 04             	sub    $0x4,%esp
80100f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f0a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f0d:	75 31                	jne    80100f40 <filestat+0x40>
    ilock(f->ip);
80100f0f:	83 ec 0c             	sub    $0xc,%esp
80100f12:	ff 73 10             	pushl  0x10(%ebx)
80100f15:	e8 46 07 00 00       	call   80101660 <ilock>
    stati(f->ip, st);
80100f1a:	58                   	pop    %eax
80100f1b:	5a                   	pop    %edx
80100f1c:	ff 75 0c             	pushl  0xc(%ebp)
80100f1f:	ff 73 10             	pushl  0x10(%ebx)
80100f22:	e8 e9 09 00 00       	call   80101910 <stati>
    iunlock(f->ip);
80100f27:	59                   	pop    %ecx
80100f28:	ff 73 10             	pushl  0x10(%ebx)
80100f2b:	e8 10 08 00 00       	call   80101740 <iunlock>
    return 0;
80100f30:	83 c4 10             	add    $0x10,%esp
80100f33:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f38:	c9                   	leave  
80100f39:	c3                   	ret    
80100f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f50 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	57                   	push   %edi
80100f54:	56                   	push   %esi
80100f55:	53                   	push   %ebx
80100f56:	83 ec 0c             	sub    $0xc,%esp
80100f59:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f5f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f62:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f66:	74 60                	je     80100fc8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f68:	8b 03                	mov    (%ebx),%eax
80100f6a:	83 f8 01             	cmp    $0x1,%eax
80100f6d:	74 41                	je     80100fb0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f6f:	83 f8 02             	cmp    $0x2,%eax
80100f72:	75 5b                	jne    80100fcf <fileread+0x7f>
    ilock(f->ip);
80100f74:	83 ec 0c             	sub    $0xc,%esp
80100f77:	ff 73 10             	pushl  0x10(%ebx)
80100f7a:	e8 e1 06 00 00       	call   80101660 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f7f:	57                   	push   %edi
80100f80:	ff 73 14             	pushl  0x14(%ebx)
80100f83:	56                   	push   %esi
80100f84:	ff 73 10             	pushl  0x10(%ebx)
80100f87:	e8 b4 09 00 00       	call   80101940 <readi>
80100f8c:	83 c4 20             	add    $0x20,%esp
80100f8f:	85 c0                	test   %eax,%eax
80100f91:	89 c6                	mov    %eax,%esi
80100f93:	7e 03                	jle    80100f98 <fileread+0x48>
      f->off += r;
80100f95:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f98:	83 ec 0c             	sub    $0xc,%esp
80100f9b:	ff 73 10             	pushl  0x10(%ebx)
80100f9e:	e8 9d 07 00 00       	call   80101740 <iunlock>
    return r;
80100fa3:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fa6:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fab:	5b                   	pop    %ebx
80100fac:	5e                   	pop    %esi
80100fad:	5f                   	pop    %edi
80100fae:	5d                   	pop    %ebp
80100faf:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fb0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fb3:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	5b                   	pop    %ebx
80100fba:	5e                   	pop    %esi
80100fbb:	5f                   	pop    %edi
80100fbc:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fbd:	e9 be 24 00 00       	jmp    80103480 <piperead>
80100fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fcd:	eb d9                	jmp    80100fa8 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100fcf:	83 ec 0c             	sub    $0xc,%esp
80100fd2:	68 06 71 10 80       	push   $0x80107106
80100fd7:	e8 94 f3 ff ff       	call   80100370 <panic>
80100fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fe0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	57                   	push   %edi
80100fe4:	56                   	push   %esi
80100fe5:	53                   	push   %ebx
80100fe6:	83 ec 1c             	sub    $0x1c,%esp
80100fe9:	8b 75 08             	mov    0x8(%ebp),%esi
80100fec:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fef:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100ff6:	8b 45 10             	mov    0x10(%ebp),%eax
80100ff9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100ffc:	0f 84 aa 00 00 00    	je     801010ac <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101002:	8b 06                	mov    (%esi),%eax
80101004:	83 f8 01             	cmp    $0x1,%eax
80101007:	0f 84 c2 00 00 00    	je     801010cf <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010100d:	83 f8 02             	cmp    $0x2,%eax
80101010:	0f 85 d8 00 00 00    	jne    801010ee <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101016:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101019:	31 ff                	xor    %edi,%edi
8010101b:	85 c0                	test   %eax,%eax
8010101d:	7f 34                	jg     80101053 <filewrite+0x73>
8010101f:	e9 9c 00 00 00       	jmp    801010c0 <filewrite+0xe0>
80101024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101028:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010102b:	83 ec 0c             	sub    $0xc,%esp
8010102e:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101031:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101034:	e8 07 07 00 00       	call   80101740 <iunlock>
      end_op();
80101039:	e8 72 1b 00 00       	call   80102bb0 <end_op>
8010103e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101041:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101044:	39 d8                	cmp    %ebx,%eax
80101046:	0f 85 95 00 00 00    	jne    801010e1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
8010104c:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010104e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101051:	7e 6d                	jle    801010c0 <filewrite+0xe0>
      int n1 = n - i;
80101053:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101056:	b8 00 06 00 00       	mov    $0x600,%eax
8010105b:	29 fb                	sub    %edi,%ebx
8010105d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101063:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
80101066:	e8 d5 1a 00 00       	call   80102b40 <begin_op>
      ilock(f->ip);
8010106b:	83 ec 0c             	sub    $0xc,%esp
8010106e:	ff 76 10             	pushl  0x10(%esi)
80101071:	e8 ea 05 00 00       	call   80101660 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101076:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101079:	53                   	push   %ebx
8010107a:	ff 76 14             	pushl  0x14(%esi)
8010107d:	01 f8                	add    %edi,%eax
8010107f:	50                   	push   %eax
80101080:	ff 76 10             	pushl  0x10(%esi)
80101083:	e8 b8 09 00 00       	call   80101a40 <writei>
80101088:	83 c4 20             	add    $0x20,%esp
8010108b:	85 c0                	test   %eax,%eax
8010108d:	7f 99                	jg     80101028 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
8010108f:	83 ec 0c             	sub    $0xc,%esp
80101092:	ff 76 10             	pushl  0x10(%esi)
80101095:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101098:	e8 a3 06 00 00       	call   80101740 <iunlock>
      end_op();
8010109d:	e8 0e 1b 00 00       	call   80102bb0 <end_op>

      if(r < 0)
801010a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010a5:	83 c4 10             	add    $0x10,%esp
801010a8:	85 c0                	test   %eax,%eax
801010aa:	74 98                	je     80101044 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801010b4:	5b                   	pop    %ebx
801010b5:	5e                   	pop    %esi
801010b6:	5f                   	pop    %edi
801010b7:	5d                   	pop    %ebp
801010b8:	c3                   	ret    
801010b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010c0:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801010c3:	75 e7                	jne    801010ac <filewrite+0xcc>
  }
  panic("filewrite");
}
801010c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c8:	89 f8                	mov    %edi,%eax
801010ca:	5b                   	pop    %ebx
801010cb:	5e                   	pop    %esi
801010cc:	5f                   	pop    %edi
801010cd:	5d                   	pop    %ebp
801010ce:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010cf:	8b 46 0c             	mov    0xc(%esi),%eax
801010d2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	5b                   	pop    %ebx
801010d9:	5e                   	pop    %esi
801010da:	5f                   	pop    %edi
801010db:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010dc:	e9 9f 22 00 00       	jmp    80103380 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010e1:	83 ec 0c             	sub    $0xc,%esp
801010e4:	68 0f 71 10 80       	push   $0x8010710f
801010e9:	e8 82 f2 ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010ee:	83 ec 0c             	sub    $0xc,%esp
801010f1:	68 15 71 10 80       	push   $0x80107115
801010f6:	e8 75 f2 ff ff       	call   80100370 <panic>
801010fb:	66 90                	xchg   %ax,%ax
801010fd:	66 90                	xchg   %ax,%ax
801010ff:	90                   	nop

80101100 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	56                   	push   %esi
80101104:	53                   	push   %ebx
80101105:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101107:	c1 ea 0c             	shr    $0xc,%edx
8010110a:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101110:	83 ec 08             	sub    $0x8,%esp
80101113:	52                   	push   %edx
80101114:	50                   	push   %eax
80101115:	e8 b6 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010111a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010111c:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101122:	ba 01 00 00 00       	mov    $0x1,%edx
80101127:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010112a:	c1 fb 03             	sar    $0x3,%ebx
8010112d:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101130:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101132:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101137:	85 d1                	test   %edx,%ecx
80101139:	74 27                	je     80101162 <bfree+0x62>
8010113b:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010113d:	f7 d2                	not    %edx
8010113f:	89 c8                	mov    %ecx,%eax
  log_write(bp);
80101141:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101144:	21 d0                	and    %edx,%eax
80101146:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010114a:	56                   	push   %esi
8010114b:	e8 d0 1b 00 00       	call   80102d20 <log_write>
  brelse(bp);
80101150:	89 34 24             	mov    %esi,(%esp)
80101153:	e8 88 f0 ff ff       	call   801001e0 <brelse>
}
80101158:	83 c4 10             	add    $0x10,%esp
8010115b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010115e:	5b                   	pop    %ebx
8010115f:	5e                   	pop    %esi
80101160:	5d                   	pop    %ebp
80101161:	c3                   	ret    

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101162:	83 ec 0c             	sub    $0xc,%esp
80101165:	68 1f 71 10 80       	push   $0x8010711f
8010116a:	e8 01 f2 ff ff       	call   80100370 <panic>
8010116f:	90                   	nop

80101170 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101170:	55                   	push   %ebp
80101171:	89 e5                	mov    %esp,%ebp
80101173:	57                   	push   %edi
80101174:	56                   	push   %esi
80101175:	53                   	push   %ebx
80101176:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101179:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010117f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101182:	85 c9                	test   %ecx,%ecx
80101184:	0f 84 85 00 00 00    	je     8010120f <balloc+0x9f>
8010118a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101191:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101194:	83 ec 08             	sub    $0x8,%esp
80101197:	89 f0                	mov    %esi,%eax
80101199:	c1 f8 0c             	sar    $0xc,%eax
8010119c:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801011a2:	50                   	push   %eax
801011a3:	ff 75 d8             	pushl  -0x28(%ebp)
801011a6:	e8 25 ef ff ff       	call   801000d0 <bread>
801011ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011ae:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801011b3:	83 c4 10             	add    $0x10,%esp
801011b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011b9:	31 c0                	xor    %eax,%eax
801011bb:	eb 2d                	jmp    801011ea <balloc+0x7a>
801011bd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801011c0:	89 c1                	mov    %eax,%ecx
801011c2:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011c7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
801011ca:	83 e1 07             	and    $0x7,%ecx
801011cd:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011cf:	89 c1                	mov    %eax,%ecx
801011d1:	c1 f9 03             	sar    $0x3,%ecx
801011d4:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
801011d9:	85 d7                	test   %edx,%edi
801011db:	74 43                	je     80101220 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011dd:	83 c0 01             	add    $0x1,%eax
801011e0:	83 c6 01             	add    $0x1,%esi
801011e3:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011e8:	74 05                	je     801011ef <balloc+0x7f>
801011ea:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801011ed:	72 d1                	jb     801011c0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801011ef:	83 ec 0c             	sub    $0xc,%esp
801011f2:	ff 75 e4             	pushl  -0x1c(%ebp)
801011f5:	e8 e6 ef ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011fa:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101201:	83 c4 10             	add    $0x10,%esp
80101204:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101207:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
8010120d:	77 82                	ja     80101191 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010120f:	83 ec 0c             	sub    $0xc,%esp
80101212:	68 32 71 10 80       	push   $0x80107132
80101217:	e8 54 f1 ff ff       	call   80100370 <panic>
8010121c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101220:	09 fa                	or     %edi,%edx
80101222:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101225:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101228:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010122c:	57                   	push   %edi
8010122d:	e8 ee 1a 00 00       	call   80102d20 <log_write>
        brelse(bp);
80101232:	89 3c 24             	mov    %edi,(%esp)
80101235:	e8 a6 ef ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
8010123a:	58                   	pop    %eax
8010123b:	5a                   	pop    %edx
8010123c:	56                   	push   %esi
8010123d:	ff 75 d8             	pushl  -0x28(%ebp)
80101240:	e8 8b ee ff ff       	call   801000d0 <bread>
80101245:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101247:	8d 40 5c             	lea    0x5c(%eax),%eax
8010124a:	83 c4 0c             	add    $0xc,%esp
8010124d:	68 00 02 00 00       	push   $0x200
80101252:	6a 00                	push   $0x0
80101254:	50                   	push   %eax
80101255:	e8 46 33 00 00       	call   801045a0 <memset>
  log_write(bp);
8010125a:	89 1c 24             	mov    %ebx,(%esp)
8010125d:	e8 be 1a 00 00       	call   80102d20 <log_write>
  brelse(bp);
80101262:	89 1c 24             	mov    %ebx,(%esp)
80101265:	e8 76 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
8010126a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010126d:	89 f0                	mov    %esi,%eax
8010126f:	5b                   	pop    %ebx
80101270:	5e                   	pop    %esi
80101271:	5f                   	pop    %edi
80101272:	5d                   	pop    %ebp
80101273:	c3                   	ret    
80101274:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010127a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101280 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101280:	55                   	push   %ebp
80101281:	89 e5                	mov    %esp,%ebp
80101283:	57                   	push   %edi
80101284:	56                   	push   %esi
80101285:	53                   	push   %ebx
80101286:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101288:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010128a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010128f:	83 ec 28             	sub    $0x28,%esp
80101292:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101295:	68 e0 09 11 80       	push   $0x801109e0
8010129a:	e8 01 32 00 00       	call   801044a0 <acquire>
8010129f:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012a5:	eb 1b                	jmp    801012c2 <iget+0x42>
801012a7:	89 f6                	mov    %esi,%esi
801012a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012b0:	85 f6                	test   %esi,%esi
801012b2:	74 44                	je     801012f8 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012b4:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012ba:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012c0:	74 4e                	je     80101310 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012c2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012c5:	85 c9                	test   %ecx,%ecx
801012c7:	7e e7                	jle    801012b0 <iget+0x30>
801012c9:	39 3b                	cmp    %edi,(%ebx)
801012cb:	75 e3                	jne    801012b0 <iget+0x30>
801012cd:	39 53 04             	cmp    %edx,0x4(%ebx)
801012d0:	75 de                	jne    801012b0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
801012d2:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
801012d5:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
801012d8:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
801012da:	68 e0 09 11 80       	push   $0x801109e0

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
801012df:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012e2:	e8 69 32 00 00       	call   80104550 <release>
      return ip;
801012e7:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
801012ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ed:	89 f0                	mov    %esi,%eax
801012ef:	5b                   	pop    %ebx
801012f0:	5e                   	pop    %esi
801012f1:	5f                   	pop    %edi
801012f2:	5d                   	pop    %ebp
801012f3:	c3                   	ret    
801012f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012f8:	85 c9                	test   %ecx,%ecx
801012fa:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012fd:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101303:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101309:	75 b7                	jne    801012c2 <iget+0x42>
8010130b:	90                   	nop
8010130c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101310:	85 f6                	test   %esi,%esi
80101312:	74 2d                	je     80101341 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101314:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101317:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101319:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010131c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101323:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010132a:	68 e0 09 11 80       	push   $0x801109e0
8010132f:	e8 1c 32 00 00       	call   80104550 <release>

  return ip;
80101334:	83 c4 10             	add    $0x10,%esp
}
80101337:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133a:	89 f0                	mov    %esi,%eax
8010133c:	5b                   	pop    %ebx
8010133d:	5e                   	pop    %esi
8010133e:	5f                   	pop    %edi
8010133f:	5d                   	pop    %ebp
80101340:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
80101341:	83 ec 0c             	sub    $0xc,%esp
80101344:	68 48 71 10 80       	push   $0x80107148
80101349:	e8 22 f0 ff ff       	call   80100370 <panic>
8010134e:	66 90                	xchg   %ax,%ax

80101350 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	56                   	push   %esi
80101355:	53                   	push   %ebx
80101356:	89 c6                	mov    %eax,%esi
80101358:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010135b:	83 fa 0b             	cmp    $0xb,%edx
8010135e:	77 18                	ja     80101378 <bmap+0x28>
80101360:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
80101363:	8b 43 5c             	mov    0x5c(%ebx),%eax
80101366:	85 c0                	test   %eax,%eax
80101368:	74 76                	je     801013e0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010136a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010136d:	5b                   	pop    %ebx
8010136e:	5e                   	pop    %esi
8010136f:	5f                   	pop    %edi
80101370:	5d                   	pop    %ebp
80101371:	c3                   	ret    
80101372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101378:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
8010137b:	83 fb 7f             	cmp    $0x7f,%ebx
8010137e:	0f 87 83 00 00 00    	ja     80101407 <bmap+0xb7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101384:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010138a:	85 c0                	test   %eax,%eax
8010138c:	74 6a                	je     801013f8 <bmap+0xa8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010138e:	83 ec 08             	sub    $0x8,%esp
80101391:	50                   	push   %eax
80101392:	ff 36                	pushl  (%esi)
80101394:	e8 37 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101399:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010139d:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801013a0:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801013a2:	8b 1a                	mov    (%edx),%ebx
801013a4:	85 db                	test   %ebx,%ebx
801013a6:	75 1d                	jne    801013c5 <bmap+0x75>
      a[bn] = addr = balloc(ip->dev);
801013a8:	8b 06                	mov    (%esi),%eax
801013aa:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013ad:	e8 be fd ff ff       	call   80101170 <balloc>
801013b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801013b5:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
801013b8:	89 c3                	mov    %eax,%ebx
801013ba:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801013bc:	57                   	push   %edi
801013bd:	e8 5e 19 00 00       	call   80102d20 <log_write>
801013c2:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
801013c5:	83 ec 0c             	sub    $0xc,%esp
801013c8:	57                   	push   %edi
801013c9:	e8 12 ee ff ff       	call   801001e0 <brelse>
801013ce:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801013d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801013d4:	89 d8                	mov    %ebx,%eax
    return addr;
  }

  panic("bmap: out of range");
}
801013d6:	5b                   	pop    %ebx
801013d7:	5e                   	pop    %esi
801013d8:	5f                   	pop    %edi
801013d9:	5d                   	pop    %ebp
801013da:	c3                   	ret    
801013db:	90                   	nop
801013dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
801013e0:	8b 06                	mov    (%esi),%eax
801013e2:	e8 89 fd ff ff       	call   80101170 <balloc>
801013e7:	89 43 5c             	mov    %eax,0x5c(%ebx)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801013ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013ed:	5b                   	pop    %ebx
801013ee:	5e                   	pop    %esi
801013ef:	5f                   	pop    %edi
801013f0:	5d                   	pop    %ebp
801013f1:	c3                   	ret    
801013f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013f8:	8b 06                	mov    (%esi),%eax
801013fa:	e8 71 fd ff ff       	call   80101170 <balloc>
801013ff:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101405:	eb 87                	jmp    8010138e <bmap+0x3e>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101407:	83 ec 0c             	sub    $0xc,%esp
8010140a:	68 58 71 10 80       	push   $0x80107158
8010140f:	e8 5c ef ff ff       	call   80100370 <panic>
80101414:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010141a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101420 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101420:	55                   	push   %ebp
80101421:	89 e5                	mov    %esp,%ebp
80101423:	56                   	push   %esi
80101424:	53                   	push   %ebx
80101425:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
80101428:	83 ec 08             	sub    $0x8,%esp
8010142b:	6a 01                	push   $0x1
8010142d:	ff 75 08             	pushl  0x8(%ebp)
80101430:	e8 9b ec ff ff       	call   801000d0 <bread>
80101435:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101437:	8d 40 5c             	lea    0x5c(%eax),%eax
8010143a:	83 c4 0c             	add    $0xc,%esp
8010143d:	6a 1c                	push   $0x1c
8010143f:	50                   	push   %eax
80101440:	56                   	push   %esi
80101441:	e8 0a 32 00 00       	call   80104650 <memmove>
  brelse(bp);
80101446:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101449:	83 c4 10             	add    $0x10,%esp
}
8010144c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010144f:	5b                   	pop    %ebx
80101450:	5e                   	pop    %esi
80101451:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
80101452:	e9 89 ed ff ff       	jmp    801001e0 <brelse>
80101457:	89 f6                	mov    %esi,%esi
80101459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101460 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101460:	55                   	push   %ebp
80101461:	89 e5                	mov    %esp,%ebp
80101463:	53                   	push   %ebx
80101464:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101469:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010146c:	68 6b 71 10 80       	push   $0x8010716b
80101471:	68 e0 09 11 80       	push   $0x801109e0
80101476:	e8 c5 2e 00 00       	call   80104340 <initlock>
8010147b:	83 c4 10             	add    $0x10,%esp
8010147e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101480:	83 ec 08             	sub    $0x8,%esp
80101483:	68 72 71 10 80       	push   $0x80107172
80101488:	53                   	push   %ebx
80101489:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010148f:	e8 7c 2d 00 00       	call   80104210 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
80101494:	83 c4 10             	add    $0x10,%esp
80101497:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
8010149d:	75 e1                	jne    80101480 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
8010149f:	83 ec 08             	sub    $0x8,%esp
801014a2:	68 c0 09 11 80       	push   $0x801109c0
801014a7:	ff 75 08             	pushl  0x8(%ebp)
801014aa:	e8 71 ff ff ff       	call   80101420 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014af:	ff 35 d8 09 11 80    	pushl  0x801109d8
801014b5:	ff 35 d4 09 11 80    	pushl  0x801109d4
801014bb:	ff 35 d0 09 11 80    	pushl  0x801109d0
801014c1:	ff 35 cc 09 11 80    	pushl  0x801109cc
801014c7:	ff 35 c8 09 11 80    	pushl  0x801109c8
801014cd:	ff 35 c4 09 11 80    	pushl  0x801109c4
801014d3:	ff 35 c0 09 11 80    	pushl  0x801109c0
801014d9:	68 d8 71 10 80       	push   $0x801071d8
801014de:	e8 7d f1 ff ff       	call   80100660 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
801014e3:	83 c4 30             	add    $0x30,%esp
801014e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014e9:	c9                   	leave  
801014ea:	c3                   	ret    
801014eb:	90                   	nop
801014ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801014f0 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
801014f0:	55                   	push   %ebp
801014f1:	89 e5                	mov    %esp,%ebp
801014f3:	57                   	push   %edi
801014f4:	56                   	push   %esi
801014f5:	53                   	push   %ebx
801014f6:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801014f9:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101500:	8b 45 0c             	mov    0xc(%ebp),%eax
80101503:	8b 75 08             	mov    0x8(%ebp),%esi
80101506:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101509:	0f 86 91 00 00 00    	jbe    801015a0 <ialloc+0xb0>
8010150f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101514:	eb 21                	jmp    80101537 <ialloc+0x47>
80101516:	8d 76 00             	lea    0x0(%esi),%esi
80101519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101520:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101523:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101526:	57                   	push   %edi
80101527:	e8 b4 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010152c:	83 c4 10             	add    $0x10,%esp
8010152f:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
80101535:	76 69                	jbe    801015a0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101537:	89 d8                	mov    %ebx,%eax
80101539:	83 ec 08             	sub    $0x8,%esp
8010153c:	c1 e8 03             	shr    $0x3,%eax
8010153f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101545:	50                   	push   %eax
80101546:	56                   	push   %esi
80101547:	e8 84 eb ff ff       	call   801000d0 <bread>
8010154c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010154e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101550:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
80101553:	83 e0 07             	and    $0x7,%eax
80101556:	c1 e0 06             	shl    $0x6,%eax
80101559:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010155d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101561:	75 bd                	jne    80101520 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101563:	83 ec 04             	sub    $0x4,%esp
80101566:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101569:	6a 40                	push   $0x40
8010156b:	6a 00                	push   $0x0
8010156d:	51                   	push   %ecx
8010156e:	e8 2d 30 00 00       	call   801045a0 <memset>
      dip->type = type;
80101573:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101577:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010157a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010157d:	89 3c 24             	mov    %edi,(%esp)
80101580:	e8 9b 17 00 00       	call   80102d20 <log_write>
      brelse(bp);
80101585:	89 3c 24             	mov    %edi,(%esp)
80101588:	e8 53 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010158d:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101590:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
80101593:	89 da                	mov    %ebx,%edx
80101595:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101597:	5b                   	pop    %ebx
80101598:	5e                   	pop    %esi
80101599:	5f                   	pop    %edi
8010159a:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
8010159b:	e9 e0 fc ff ff       	jmp    80101280 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801015a0:	83 ec 0c             	sub    $0xc,%esp
801015a3:	68 78 71 10 80       	push   $0x80107178
801015a8:	e8 c3 ed ff ff       	call   80100370 <panic>
801015ad:	8d 76 00             	lea    0x0(%esi),%esi

801015b0 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
801015b0:	55                   	push   %ebp
801015b1:	89 e5                	mov    %esp,%ebp
801015b3:	56                   	push   %esi
801015b4:	53                   	push   %ebx
801015b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015b8:	83 ec 08             	sub    $0x8,%esp
801015bb:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015be:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015c1:	c1 e8 03             	shr    $0x3,%eax
801015c4:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015ca:	50                   	push   %eax
801015cb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015ce:	e8 fd ea ff ff       	call   801000d0 <bread>
801015d3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015d5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801015d8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015dc:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015df:	83 e0 07             	and    $0x7,%eax
801015e2:	c1 e0 06             	shl    $0x6,%eax
801015e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801015e9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801015ec:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015f0:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
801015f3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801015f7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801015fb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801015ff:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101603:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101607:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010160a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010160d:	6a 34                	push   $0x34
8010160f:	53                   	push   %ebx
80101610:	50                   	push   %eax
80101611:	e8 3a 30 00 00       	call   80104650 <memmove>
  log_write(bp);
80101616:	89 34 24             	mov    %esi,(%esp)
80101619:	e8 02 17 00 00       	call   80102d20 <log_write>
  brelse(bp);
8010161e:	89 75 08             	mov    %esi,0x8(%ebp)
80101621:	83 c4 10             	add    $0x10,%esp
}
80101624:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101627:	5b                   	pop    %ebx
80101628:	5e                   	pop    %esi
80101629:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
8010162a:	e9 b1 eb ff ff       	jmp    801001e0 <brelse>
8010162f:	90                   	nop

80101630 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	53                   	push   %ebx
80101634:	83 ec 10             	sub    $0x10,%esp
80101637:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010163a:	68 e0 09 11 80       	push   $0x801109e0
8010163f:	e8 5c 2e 00 00       	call   801044a0 <acquire>
  ip->ref++;
80101644:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101648:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010164f:	e8 fc 2e 00 00       	call   80104550 <release>
  return ip;
}
80101654:	89 d8                	mov    %ebx,%eax
80101656:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101659:	c9                   	leave  
8010165a:	c3                   	ret    
8010165b:	90                   	nop
8010165c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101660 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	56                   	push   %esi
80101664:	53                   	push   %ebx
80101665:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101668:	85 db                	test   %ebx,%ebx
8010166a:	0f 84 b7 00 00 00    	je     80101727 <ilock+0xc7>
80101670:	8b 53 08             	mov    0x8(%ebx),%edx
80101673:	85 d2                	test   %edx,%edx
80101675:	0f 8e ac 00 00 00    	jle    80101727 <ilock+0xc7>
    panic("ilock");

  acquiresleep(&ip->lock);
8010167b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010167e:	83 ec 0c             	sub    $0xc,%esp
80101681:	50                   	push   %eax
80101682:	e8 c9 2b 00 00       	call   80104250 <acquiresleep>

  if(ip->valid == 0){
80101687:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010168a:	83 c4 10             	add    $0x10,%esp
8010168d:	85 c0                	test   %eax,%eax
8010168f:	74 0f                	je     801016a0 <ilock+0x40>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
80101691:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101694:	5b                   	pop    %ebx
80101695:	5e                   	pop    %esi
80101696:	5d                   	pop    %ebp
80101697:	c3                   	ret    
80101698:	90                   	nop
80101699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016a0:	8b 43 04             	mov    0x4(%ebx),%eax
801016a3:	83 ec 08             	sub    $0x8,%esp
801016a6:	c1 e8 03             	shr    $0x3,%eax
801016a9:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016af:	50                   	push   %eax
801016b0:	ff 33                	pushl  (%ebx)
801016b2:	e8 19 ea ff ff       	call   801000d0 <bread>
801016b7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016b9:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016bc:	83 c4 0c             	add    $0xc,%esp

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016bf:	83 e0 07             	and    $0x7,%eax
801016c2:	c1 e0 06             	shl    $0x6,%eax
801016c5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016c9:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016cc:	83 c0 0c             	add    $0xc,%eax
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
801016cf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801016d3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016d7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801016db:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016df:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801016e3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801016e7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801016eb:	8b 50 fc             	mov    -0x4(%eax),%edx
801016ee:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016f1:	6a 34                	push   $0x34
801016f3:	50                   	push   %eax
801016f4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801016f7:	50                   	push   %eax
801016f8:	e8 53 2f 00 00       	call   80104650 <memmove>
    brelse(bp);
801016fd:	89 34 24             	mov    %esi,(%esp)
80101700:	e8 db ea ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101705:	83 c4 10             	add    $0x10,%esp
80101708:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
8010170d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101714:	0f 85 77 ff ff ff    	jne    80101691 <ilock+0x31>
      panic("ilock: no type");
8010171a:	83 ec 0c             	sub    $0xc,%esp
8010171d:	68 90 71 10 80       	push   $0x80107190
80101722:	e8 49 ec ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101727:	83 ec 0c             	sub    $0xc,%esp
8010172a:	68 8a 71 10 80       	push   $0x8010718a
8010172f:	e8 3c ec ff ff       	call   80100370 <panic>
80101734:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010173a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101740 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101740:	55                   	push   %ebp
80101741:	89 e5                	mov    %esp,%ebp
80101743:	56                   	push   %esi
80101744:	53                   	push   %ebx
80101745:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101748:	85 db                	test   %ebx,%ebx
8010174a:	74 28                	je     80101774 <iunlock+0x34>
8010174c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010174f:	83 ec 0c             	sub    $0xc,%esp
80101752:	56                   	push   %esi
80101753:	e8 98 2b 00 00       	call   801042f0 <holdingsleep>
80101758:	83 c4 10             	add    $0x10,%esp
8010175b:	85 c0                	test   %eax,%eax
8010175d:	74 15                	je     80101774 <iunlock+0x34>
8010175f:	8b 43 08             	mov    0x8(%ebx),%eax
80101762:	85 c0                	test   %eax,%eax
80101764:	7e 0e                	jle    80101774 <iunlock+0x34>
    panic("iunlock");

  releasesleep(&ip->lock);
80101766:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101769:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010176c:	5b                   	pop    %ebx
8010176d:	5e                   	pop    %esi
8010176e:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
8010176f:	e9 3c 2b 00 00       	jmp    801042b0 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101774:	83 ec 0c             	sub    $0xc,%esp
80101777:	68 9f 71 10 80       	push   $0x8010719f
8010177c:	e8 ef eb ff ff       	call   80100370 <panic>
80101781:	eb 0d                	jmp    80101790 <iput>
80101783:	90                   	nop
80101784:	90                   	nop
80101785:	90                   	nop
80101786:	90                   	nop
80101787:	90                   	nop
80101788:	90                   	nop
80101789:	90                   	nop
8010178a:	90                   	nop
8010178b:	90                   	nop
8010178c:	90                   	nop
8010178d:	90                   	nop
8010178e:	90                   	nop
8010178f:	90                   	nop

80101790 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101790:	55                   	push   %ebp
80101791:	89 e5                	mov    %esp,%ebp
80101793:	57                   	push   %edi
80101794:	56                   	push   %esi
80101795:	53                   	push   %ebx
80101796:	83 ec 28             	sub    $0x28,%esp
80101799:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
8010179c:	8d 7e 0c             	lea    0xc(%esi),%edi
8010179f:	57                   	push   %edi
801017a0:	e8 ab 2a 00 00       	call   80104250 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017a5:	8b 56 4c             	mov    0x4c(%esi),%edx
801017a8:	83 c4 10             	add    $0x10,%esp
801017ab:	85 d2                	test   %edx,%edx
801017ad:	74 07                	je     801017b6 <iput+0x26>
801017af:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801017b4:	74 32                	je     801017e8 <iput+0x58>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
801017b6:	83 ec 0c             	sub    $0xc,%esp
801017b9:	57                   	push   %edi
801017ba:	e8 f1 2a 00 00       	call   801042b0 <releasesleep>

  acquire(&icache.lock);
801017bf:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017c6:	e8 d5 2c 00 00       	call   801044a0 <acquire>
  ip->ref--;
801017cb:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
801017cf:	83 c4 10             	add    $0x10,%esp
801017d2:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
801017d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017dc:	5b                   	pop    %ebx
801017dd:	5e                   	pop    %esi
801017de:	5f                   	pop    %edi
801017df:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
801017e0:	e9 6b 2d 00 00       	jmp    80104550 <release>
801017e5:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
801017e8:	83 ec 0c             	sub    $0xc,%esp
801017eb:	68 e0 09 11 80       	push   $0x801109e0
801017f0:	e8 ab 2c 00 00       	call   801044a0 <acquire>
    int r = ip->ref;
801017f5:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
801017f8:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017ff:	e8 4c 2d 00 00       	call   80104550 <release>
    if(r == 1){
80101804:	83 c4 10             	add    $0x10,%esp
80101807:	83 fb 01             	cmp    $0x1,%ebx
8010180a:	75 aa                	jne    801017b6 <iput+0x26>
8010180c:	8d 8e 8c 00 00 00    	lea    0x8c(%esi),%ecx
80101812:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101815:	8d 5e 5c             	lea    0x5c(%esi),%ebx
80101818:	89 cf                	mov    %ecx,%edi
8010181a:	eb 0b                	jmp    80101827 <iput+0x97>
8010181c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101820:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101823:	39 fb                	cmp    %edi,%ebx
80101825:	74 19                	je     80101840 <iput+0xb0>
    if(ip->addrs[i]){
80101827:	8b 13                	mov    (%ebx),%edx
80101829:	85 d2                	test   %edx,%edx
8010182b:	74 f3                	je     80101820 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010182d:	8b 06                	mov    (%esi),%eax
8010182f:	e8 cc f8 ff ff       	call   80101100 <bfree>
      ip->addrs[i] = 0;
80101834:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010183a:	eb e4                	jmp    80101820 <iput+0x90>
8010183c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101840:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101846:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101849:	85 c0                	test   %eax,%eax
8010184b:	75 33                	jne    80101880 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010184d:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
80101850:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101857:	56                   	push   %esi
80101858:	e8 53 fd ff ff       	call   801015b0 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
8010185d:	31 c0                	xor    %eax,%eax
8010185f:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101863:	89 34 24             	mov    %esi,(%esp)
80101866:	e8 45 fd ff ff       	call   801015b0 <iupdate>
      ip->valid = 0;
8010186b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101872:	83 c4 10             	add    $0x10,%esp
80101875:	e9 3c ff ff ff       	jmp    801017b6 <iput+0x26>
8010187a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101880:	83 ec 08             	sub    $0x8,%esp
80101883:	50                   	push   %eax
80101884:	ff 36                	pushl  (%esi)
80101886:	e8 45 e8 ff ff       	call   801000d0 <bread>
8010188b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101891:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101894:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101897:	8d 58 5c             	lea    0x5c(%eax),%ebx
8010189a:	83 c4 10             	add    $0x10,%esp
8010189d:	89 cf                	mov    %ecx,%edi
8010189f:	eb 0e                	jmp    801018af <iput+0x11f>
801018a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018a8:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
801018ab:	39 fb                	cmp    %edi,%ebx
801018ad:	74 0f                	je     801018be <iput+0x12e>
      if(a[j])
801018af:	8b 13                	mov    (%ebx),%edx
801018b1:	85 d2                	test   %edx,%edx
801018b3:	74 f3                	je     801018a8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018b5:	8b 06                	mov    (%esi),%eax
801018b7:	e8 44 f8 ff ff       	call   80101100 <bfree>
801018bc:	eb ea                	jmp    801018a8 <iput+0x118>
    }
    brelse(bp);
801018be:	83 ec 0c             	sub    $0xc,%esp
801018c1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018c4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018c7:	e8 14 e9 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018cc:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801018d2:	8b 06                	mov    (%esi),%eax
801018d4:	e8 27 f8 ff ff       	call   80101100 <bfree>
    ip->addrs[NDIRECT] = 0;
801018d9:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
801018e0:	00 00 00 
801018e3:	83 c4 10             	add    $0x10,%esp
801018e6:	e9 62 ff ff ff       	jmp    8010184d <iput+0xbd>
801018eb:	90                   	nop
801018ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018f0 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
801018f0:	55                   	push   %ebp
801018f1:	89 e5                	mov    %esp,%ebp
801018f3:	53                   	push   %ebx
801018f4:	83 ec 10             	sub    $0x10,%esp
801018f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801018fa:	53                   	push   %ebx
801018fb:	e8 40 fe ff ff       	call   80101740 <iunlock>
  iput(ip);
80101900:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101903:	83 c4 10             	add    $0x10,%esp
}
80101906:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101909:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
8010190a:	e9 81 fe ff ff       	jmp    80101790 <iput>
8010190f:	90                   	nop

80101910 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	8b 55 08             	mov    0x8(%ebp),%edx
80101916:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101919:	8b 0a                	mov    (%edx),%ecx
8010191b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010191e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101921:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101924:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101928:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010192b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010192f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101933:	8b 52 58             	mov    0x58(%edx),%edx
80101936:	89 50 10             	mov    %edx,0x10(%eax)
}
80101939:	5d                   	pop    %ebp
8010193a:	c3                   	ret    
8010193b:	90                   	nop
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101940 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	57                   	push   %edi
80101944:	56                   	push   %esi
80101945:	53                   	push   %ebx
80101946:	83 ec 1c             	sub    $0x1c,%esp
80101949:	8b 45 08             	mov    0x8(%ebp),%eax
8010194c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010194f:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101952:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101957:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010195a:	8b 7d 14             	mov    0x14(%ebp),%edi
8010195d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101960:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101963:	0f 84 a7 00 00 00    	je     80101a10 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101969:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010196c:	8b 40 58             	mov    0x58(%eax),%eax
8010196f:	39 f0                	cmp    %esi,%eax
80101971:	0f 82 c1 00 00 00    	jb     80101a38 <readi+0xf8>
80101977:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010197a:	89 fa                	mov    %edi,%edx
8010197c:	01 f2                	add    %esi,%edx
8010197e:	0f 82 b4 00 00 00    	jb     80101a38 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101984:	89 c1                	mov    %eax,%ecx
80101986:	29 f1                	sub    %esi,%ecx
80101988:	39 d0                	cmp    %edx,%eax
8010198a:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010198d:	31 ff                	xor    %edi,%edi
8010198f:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101991:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101994:	74 6d                	je     80101a03 <readi+0xc3>
80101996:	8d 76 00             	lea    0x0(%esi),%esi
80101999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019a0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019a3:	89 f2                	mov    %esi,%edx
801019a5:	c1 ea 09             	shr    $0x9,%edx
801019a8:	89 d8                	mov    %ebx,%eax
801019aa:	e8 a1 f9 ff ff       	call   80101350 <bmap>
801019af:	83 ec 08             	sub    $0x8,%esp
801019b2:	50                   	push   %eax
801019b3:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
801019b5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019ba:	e8 11 e7 ff ff       	call   801000d0 <bread>
801019bf:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801019c4:	89 f1                	mov    %esi,%ecx
801019c6:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801019cc:	83 c4 0c             	add    $0xc,%esp
    memmove(dst, bp->data + off%BSIZE, m);
801019cf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019d2:	29 cb                	sub    %ecx,%ebx
801019d4:	29 f8                	sub    %edi,%eax
801019d6:	39 c3                	cmp    %eax,%ebx
801019d8:	0f 47 d8             	cmova  %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019db:	8d 44 0a 5c          	lea    0x5c(%edx,%ecx,1),%eax
801019df:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019e0:	01 df                	add    %ebx,%edi
801019e2:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
801019e4:	50                   	push   %eax
801019e5:	ff 75 e0             	pushl  -0x20(%ebp)
801019e8:	e8 63 2c 00 00       	call   80104650 <memmove>
    brelse(bp);
801019ed:	8b 55 dc             	mov    -0x24(%ebp),%edx
801019f0:	89 14 24             	mov    %edx,(%esp)
801019f3:	e8 e8 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019f8:	01 5d e0             	add    %ebx,-0x20(%ebp)
801019fb:	83 c4 10             	add    $0x10,%esp
801019fe:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a01:	77 9d                	ja     801019a0 <readi+0x60>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101a03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a06:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a09:	5b                   	pop    %ebx
80101a0a:	5e                   	pop    %esi
80101a0b:	5f                   	pop    %edi
80101a0c:	5d                   	pop    %ebp
80101a0d:	c3                   	ret    
80101a0e:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a10:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a14:	66 83 f8 09          	cmp    $0x9,%ax
80101a18:	77 1e                	ja     80101a38 <readi+0xf8>
80101a1a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a21:	85 c0                	test   %eax,%eax
80101a23:	74 13                	je     80101a38 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a25:	89 7d 10             	mov    %edi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101a28:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a2b:	5b                   	pop    %ebx
80101a2c:	5e                   	pop    %esi
80101a2d:	5f                   	pop    %edi
80101a2e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a2f:	ff e0                	jmp    *%eax
80101a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101a38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a3d:	eb c7                	jmp    80101a06 <readi+0xc6>
80101a3f:	90                   	nop

80101a40 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a40:	55                   	push   %ebp
80101a41:	89 e5                	mov    %esp,%ebp
80101a43:	57                   	push   %edi
80101a44:	56                   	push   %esi
80101a45:	53                   	push   %ebx
80101a46:	83 ec 1c             	sub    $0x1c,%esp
80101a49:	8b 45 08             	mov    0x8(%ebp),%eax
80101a4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a4f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a52:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a57:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a5a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a5d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a60:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a63:	0f 84 b7 00 00 00    	je     80101b20 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a6c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a6f:	0f 82 eb 00 00 00    	jb     80101b60 <writei+0x120>
80101a75:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a78:	89 f8                	mov    %edi,%eax
80101a7a:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101a7c:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101a81:	0f 87 d9 00 00 00    	ja     80101b60 <writei+0x120>
80101a87:	39 c6                	cmp    %eax,%esi
80101a89:	0f 87 d1 00 00 00    	ja     80101b60 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a8f:	85 ff                	test   %edi,%edi
80101a91:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101a98:	74 78                	je     80101b12 <writei+0xd2>
80101a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101aa0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101aa3:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101aa5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101aaa:	c1 ea 09             	shr    $0x9,%edx
80101aad:	89 f8                	mov    %edi,%eax
80101aaf:	e8 9c f8 ff ff       	call   80101350 <bmap>
80101ab4:	83 ec 08             	sub    $0x8,%esp
80101ab7:	50                   	push   %eax
80101ab8:	ff 37                	pushl  (%edi)
80101aba:	e8 11 e6 ff ff       	call   801000d0 <bread>
80101abf:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ac1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ac4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101ac7:	89 f1                	mov    %esi,%ecx
80101ac9:	83 c4 0c             	add    $0xc,%esp
80101acc:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101ad2:	29 cb                	sub    %ecx,%ebx
80101ad4:	39 c3                	cmp    %eax,%ebx
80101ad6:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ad9:	8d 44 0f 5c          	lea    0x5c(%edi,%ecx,1),%eax
80101add:	53                   	push   %ebx
80101ade:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ae1:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101ae3:	50                   	push   %eax
80101ae4:	e8 67 2b 00 00       	call   80104650 <memmove>
    log_write(bp);
80101ae9:	89 3c 24             	mov    %edi,(%esp)
80101aec:	e8 2f 12 00 00       	call   80102d20 <log_write>
    brelse(bp);
80101af1:	89 3c 24             	mov    %edi,(%esp)
80101af4:	e8 e7 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101af9:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101afc:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101aff:	83 c4 10             	add    $0x10,%esp
80101b02:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101b05:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101b08:	77 96                	ja     80101aa0 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101b0a:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b0d:	3b 70 58             	cmp    0x58(%eax),%esi
80101b10:	77 36                	ja     80101b48 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b12:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b15:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b18:	5b                   	pop    %ebx
80101b19:	5e                   	pop    %esi
80101b1a:	5f                   	pop    %edi
80101b1b:	5d                   	pop    %ebp
80101b1c:	c3                   	ret    
80101b1d:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b20:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b24:	66 83 f8 09          	cmp    $0x9,%ax
80101b28:	77 36                	ja     80101b60 <writei+0x120>
80101b2a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b31:	85 c0                	test   %eax,%eax
80101b33:	74 2b                	je     80101b60 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b35:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b3b:	5b                   	pop    %ebx
80101b3c:	5e                   	pop    %esi
80101b3d:	5f                   	pop    %edi
80101b3e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b3f:	ff e0                	jmp    *%eax
80101b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b48:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b4b:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b4e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b51:	50                   	push   %eax
80101b52:	e8 59 fa ff ff       	call   801015b0 <iupdate>
80101b57:	83 c4 10             	add    $0x10,%esp
80101b5a:	eb b6                	jmp    80101b12 <writei+0xd2>
80101b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101b60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b65:	eb ae                	jmp    80101b15 <writei+0xd5>
80101b67:	89 f6                	mov    %esi,%esi
80101b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b70 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b70:	55                   	push   %ebp
80101b71:	89 e5                	mov    %esp,%ebp
80101b73:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b76:	6a 0e                	push   $0xe
80101b78:	ff 75 0c             	pushl  0xc(%ebp)
80101b7b:	ff 75 08             	pushl  0x8(%ebp)
80101b7e:	e8 4d 2b 00 00       	call   801046d0 <strncmp>
}
80101b83:	c9                   	leave  
80101b84:	c3                   	ret    
80101b85:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b90 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	57                   	push   %edi
80101b94:	56                   	push   %esi
80101b95:	53                   	push   %ebx
80101b96:	83 ec 1c             	sub    $0x1c,%esp
80101b99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101b9c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101ba1:	0f 85 80 00 00 00    	jne    80101c27 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101ba7:	8b 53 58             	mov    0x58(%ebx),%edx
80101baa:	31 ff                	xor    %edi,%edi
80101bac:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101baf:	85 d2                	test   %edx,%edx
80101bb1:	75 0d                	jne    80101bc0 <dirlookup+0x30>
80101bb3:	eb 5b                	jmp    80101c10 <dirlookup+0x80>
80101bb5:	8d 76 00             	lea    0x0(%esi),%esi
80101bb8:	83 c7 10             	add    $0x10,%edi
80101bbb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bbe:	76 50                	jbe    80101c10 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bc0:	6a 10                	push   $0x10
80101bc2:	57                   	push   %edi
80101bc3:	56                   	push   %esi
80101bc4:	53                   	push   %ebx
80101bc5:	e8 76 fd ff ff       	call   80101940 <readi>
80101bca:	83 c4 10             	add    $0x10,%esp
80101bcd:	83 f8 10             	cmp    $0x10,%eax
80101bd0:	75 48                	jne    80101c1a <dirlookup+0x8a>
      panic("dirlookup read");
    if(de.inum == 0)
80101bd2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bd7:	74 df                	je     80101bb8 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101bd9:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bdc:	83 ec 04             	sub    $0x4,%esp
80101bdf:	6a 0e                	push   $0xe
80101be1:	50                   	push   %eax
80101be2:	ff 75 0c             	pushl  0xc(%ebp)
80101be5:	e8 e6 2a 00 00       	call   801046d0 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101bea:	83 c4 10             	add    $0x10,%esp
80101bed:	85 c0                	test   %eax,%eax
80101bef:	75 c7                	jne    80101bb8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101bf1:	8b 45 10             	mov    0x10(%ebp),%eax
80101bf4:	85 c0                	test   %eax,%eax
80101bf6:	74 05                	je     80101bfd <dirlookup+0x6d>
        *poff = off;
80101bf8:	8b 45 10             	mov    0x10(%ebp),%eax
80101bfb:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101bfd:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101c01:	8b 03                	mov    (%ebx),%eax
80101c03:	e8 78 f6 ff ff       	call   80101280 <iget>
    }
  }

  return 0;
}
80101c08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c0b:	5b                   	pop    %ebx
80101c0c:	5e                   	pop    %esi
80101c0d:	5f                   	pop    %edi
80101c0e:	5d                   	pop    %ebp
80101c0f:	c3                   	ret    
80101c10:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101c13:	31 c0                	xor    %eax,%eax
}
80101c15:	5b                   	pop    %ebx
80101c16:	5e                   	pop    %esi
80101c17:	5f                   	pop    %edi
80101c18:	5d                   	pop    %ebp
80101c19:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101c1a:	83 ec 0c             	sub    $0xc,%esp
80101c1d:	68 b9 71 10 80       	push   $0x801071b9
80101c22:	e8 49 e7 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c27:	83 ec 0c             	sub    $0xc,%esp
80101c2a:	68 a7 71 10 80       	push   $0x801071a7
80101c2f:	e8 3c e7 ff ff       	call   80100370 <panic>
80101c34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101c3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101c40 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c40:	55                   	push   %ebp
80101c41:	89 e5                	mov    %esp,%ebp
80101c43:	57                   	push   %edi
80101c44:	56                   	push   %esi
80101c45:	53                   	push   %ebx
80101c46:	89 cf                	mov    %ecx,%edi
80101c48:	89 c3                	mov    %eax,%ebx
80101c4a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c4d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c50:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101c53:	0f 84 53 01 00 00    	je     80101dac <namex+0x16c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c59:	e8 32 1b 00 00       	call   80103790 <myproc>
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c5e:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c61:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c64:	68 e0 09 11 80       	push   $0x801109e0
80101c69:	e8 32 28 00 00       	call   801044a0 <acquire>
  ip->ref++;
80101c6e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c72:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101c79:	e8 d2 28 00 00       	call   80104550 <release>
80101c7e:	83 c4 10             	add    $0x10,%esp
80101c81:	eb 08                	jmp    80101c8b <namex+0x4b>
80101c83:	90                   	nop
80101c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101c88:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101c8b:	0f b6 03             	movzbl (%ebx),%eax
80101c8e:	3c 2f                	cmp    $0x2f,%al
80101c90:	74 f6                	je     80101c88 <namex+0x48>
    path++;
  if(*path == 0)
80101c92:	84 c0                	test   %al,%al
80101c94:	0f 84 e3 00 00 00    	je     80101d7d <namex+0x13d>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101c9a:	0f b6 03             	movzbl (%ebx),%eax
80101c9d:	89 da                	mov    %ebx,%edx
80101c9f:	84 c0                	test   %al,%al
80101ca1:	0f 84 ac 00 00 00    	je     80101d53 <namex+0x113>
80101ca7:	3c 2f                	cmp    $0x2f,%al
80101ca9:	75 09                	jne    80101cb4 <namex+0x74>
80101cab:	e9 a3 00 00 00       	jmp    80101d53 <namex+0x113>
80101cb0:	84 c0                	test   %al,%al
80101cb2:	74 0a                	je     80101cbe <namex+0x7e>
    path++;
80101cb4:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101cb7:	0f b6 02             	movzbl (%edx),%eax
80101cba:	3c 2f                	cmp    $0x2f,%al
80101cbc:	75 f2                	jne    80101cb0 <namex+0x70>
80101cbe:	89 d1                	mov    %edx,%ecx
80101cc0:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101cc2:	83 f9 0d             	cmp    $0xd,%ecx
80101cc5:	0f 8e 8d 00 00 00    	jle    80101d58 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101ccb:	83 ec 04             	sub    $0x4,%esp
80101cce:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101cd1:	6a 0e                	push   $0xe
80101cd3:	53                   	push   %ebx
80101cd4:	57                   	push   %edi
80101cd5:	e8 76 29 00 00       	call   80104650 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101cda:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
80101cdd:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101ce0:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101ce2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101ce5:	75 11                	jne    80101cf8 <namex+0xb8>
80101ce7:	89 f6                	mov    %esi,%esi
80101ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101cf0:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101cf3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101cf6:	74 f8                	je     80101cf0 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101cf8:	83 ec 0c             	sub    $0xc,%esp
80101cfb:	56                   	push   %esi
80101cfc:	e8 5f f9 ff ff       	call   80101660 <ilock>
    if(ip->type != T_DIR){
80101d01:	83 c4 10             	add    $0x10,%esp
80101d04:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d09:	0f 85 7f 00 00 00    	jne    80101d8e <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d0f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d12:	85 d2                	test   %edx,%edx
80101d14:	74 09                	je     80101d1f <namex+0xdf>
80101d16:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d19:	0f 84 a3 00 00 00    	je     80101dc2 <namex+0x182>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d1f:	83 ec 04             	sub    $0x4,%esp
80101d22:	6a 00                	push   $0x0
80101d24:	57                   	push   %edi
80101d25:	56                   	push   %esi
80101d26:	e8 65 fe ff ff       	call   80101b90 <dirlookup>
80101d2b:	83 c4 10             	add    $0x10,%esp
80101d2e:	85 c0                	test   %eax,%eax
80101d30:	74 5c                	je     80101d8e <namex+0x14e>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d32:	83 ec 0c             	sub    $0xc,%esp
80101d35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d38:	56                   	push   %esi
80101d39:	e8 02 fa ff ff       	call   80101740 <iunlock>
  iput(ip);
80101d3e:	89 34 24             	mov    %esi,(%esp)
80101d41:	e8 4a fa ff ff       	call   80101790 <iput>
80101d46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d49:	83 c4 10             	add    $0x10,%esp
80101d4c:	89 c6                	mov    %eax,%esi
80101d4e:	e9 38 ff ff ff       	jmp    80101c8b <namex+0x4b>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d53:	31 c9                	xor    %ecx,%ecx
80101d55:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101d58:	83 ec 04             	sub    $0x4,%esp
80101d5b:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d5e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d61:	51                   	push   %ecx
80101d62:	53                   	push   %ebx
80101d63:	57                   	push   %edi
80101d64:	e8 e7 28 00 00       	call   80104650 <memmove>
    name[len] = 0;
80101d69:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d6c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d6f:	83 c4 10             	add    $0x10,%esp
80101d72:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d76:	89 d3                	mov    %edx,%ebx
80101d78:	e9 65 ff ff ff       	jmp    80101ce2 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101d7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101d80:	85 c0                	test   %eax,%eax
80101d82:	75 54                	jne    80101dd8 <namex+0x198>
80101d84:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101d86:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d89:	5b                   	pop    %ebx
80101d8a:	5e                   	pop    %esi
80101d8b:	5f                   	pop    %edi
80101d8c:	5d                   	pop    %ebp
80101d8d:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d8e:	83 ec 0c             	sub    $0xc,%esp
80101d91:	56                   	push   %esi
80101d92:	e8 a9 f9 ff ff       	call   80101740 <iunlock>
  iput(ip);
80101d97:	89 34 24             	mov    %esi,(%esp)
80101d9a:	e8 f1 f9 ff ff       	call   80101790 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101d9f:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101da2:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101da5:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101da7:	5b                   	pop    %ebx
80101da8:	5e                   	pop    %esi
80101da9:	5f                   	pop    %edi
80101daa:	5d                   	pop    %ebp
80101dab:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101dac:	ba 01 00 00 00       	mov    $0x1,%edx
80101db1:	b8 01 00 00 00       	mov    $0x1,%eax
80101db6:	e8 c5 f4 ff ff       	call   80101280 <iget>
80101dbb:	89 c6                	mov    %eax,%esi
80101dbd:	e9 c9 fe ff ff       	jmp    80101c8b <namex+0x4b>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101dc2:	83 ec 0c             	sub    $0xc,%esp
80101dc5:	56                   	push   %esi
80101dc6:	e8 75 f9 ff ff       	call   80101740 <iunlock>
      return ip;
80101dcb:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dce:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101dd1:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dd3:	5b                   	pop    %ebx
80101dd4:	5e                   	pop    %esi
80101dd5:	5f                   	pop    %edi
80101dd6:	5d                   	pop    %ebp
80101dd7:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101dd8:	83 ec 0c             	sub    $0xc,%esp
80101ddb:	56                   	push   %esi
80101ddc:	e8 af f9 ff ff       	call   80101790 <iput>
    return 0;
80101de1:	83 c4 10             	add    $0x10,%esp
80101de4:	31 c0                	xor    %eax,%eax
80101de6:	eb 9e                	jmp    80101d86 <namex+0x146>
80101de8:	90                   	nop
80101de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101df0 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101df0:	55                   	push   %ebp
80101df1:	89 e5                	mov    %esp,%ebp
80101df3:	57                   	push   %edi
80101df4:	56                   	push   %esi
80101df5:	53                   	push   %ebx
80101df6:	83 ec 20             	sub    $0x20,%esp
80101df9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101dfc:	6a 00                	push   $0x0
80101dfe:	ff 75 0c             	pushl  0xc(%ebp)
80101e01:	53                   	push   %ebx
80101e02:	e8 89 fd ff ff       	call   80101b90 <dirlookup>
80101e07:	83 c4 10             	add    $0x10,%esp
80101e0a:	85 c0                	test   %eax,%eax
80101e0c:	75 67                	jne    80101e75 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e0e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e11:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e14:	85 ff                	test   %edi,%edi
80101e16:	74 29                	je     80101e41 <dirlink+0x51>
80101e18:	31 ff                	xor    %edi,%edi
80101e1a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e1d:	eb 09                	jmp    80101e28 <dirlink+0x38>
80101e1f:	90                   	nop
80101e20:	83 c7 10             	add    $0x10,%edi
80101e23:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101e26:	76 19                	jbe    80101e41 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e28:	6a 10                	push   $0x10
80101e2a:	57                   	push   %edi
80101e2b:	56                   	push   %esi
80101e2c:	53                   	push   %ebx
80101e2d:	e8 0e fb ff ff       	call   80101940 <readi>
80101e32:	83 c4 10             	add    $0x10,%esp
80101e35:	83 f8 10             	cmp    $0x10,%eax
80101e38:	75 4e                	jne    80101e88 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
80101e3a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e3f:	75 df                	jne    80101e20 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101e41:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e44:	83 ec 04             	sub    $0x4,%esp
80101e47:	6a 0e                	push   $0xe
80101e49:	ff 75 0c             	pushl  0xc(%ebp)
80101e4c:	50                   	push   %eax
80101e4d:	e8 ee 28 00 00       	call   80104740 <strncpy>
  de.inum = inum;
80101e52:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e55:	6a 10                	push   $0x10
80101e57:	57                   	push   %edi
80101e58:	56                   	push   %esi
80101e59:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101e5a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e5e:	e8 dd fb ff ff       	call   80101a40 <writei>
80101e63:	83 c4 20             	add    $0x20,%esp
80101e66:	83 f8 10             	cmp    $0x10,%eax
80101e69:	75 2a                	jne    80101e95 <dirlink+0xa5>
    panic("dirlink");

  return 0;
80101e6b:	31 c0                	xor    %eax,%eax
}
80101e6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e70:	5b                   	pop    %ebx
80101e71:	5e                   	pop    %esi
80101e72:	5f                   	pop    %edi
80101e73:	5d                   	pop    %ebp
80101e74:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101e75:	83 ec 0c             	sub    $0xc,%esp
80101e78:	50                   	push   %eax
80101e79:	e8 12 f9 ff ff       	call   80101790 <iput>
    return -1;
80101e7e:	83 c4 10             	add    $0x10,%esp
80101e81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e86:	eb e5                	jmp    80101e6d <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101e88:	83 ec 0c             	sub    $0xc,%esp
80101e8b:	68 c8 71 10 80       	push   $0x801071c8
80101e90:	e8 db e4 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101e95:	83 ec 0c             	sub    $0xc,%esp
80101e98:	68 c2 77 10 80       	push   $0x801077c2
80101e9d:	e8 ce e4 ff ff       	call   80100370 <panic>
80101ea2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101eb0 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101eb0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101eb1:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101eb3:	89 e5                	mov    %esp,%ebp
80101eb5:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101eb8:	8b 45 08             	mov    0x8(%ebp),%eax
80101ebb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101ebe:	e8 7d fd ff ff       	call   80101c40 <namex>
}
80101ec3:	c9                   	leave  
80101ec4:	c3                   	ret    
80101ec5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ed0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101ed0:	55                   	push   %ebp
  return namex(path, 1, name);
80101ed1:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101ed6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101ed8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101edb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101ede:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101edf:	e9 5c fd ff ff       	jmp    80101c40 <namex>
80101ee4:	66 90                	xchg   %ax,%ax
80101ee6:	66 90                	xchg   %ax,%ax
80101ee8:	66 90                	xchg   %ax,%ax
80101eea:	66 90                	xchg   %ax,%ax
80101eec:	66 90                	xchg   %ax,%ax
80101eee:	66 90                	xchg   %ax,%ax

80101ef0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101ef0:	55                   	push   %ebp
  if(b == 0)
80101ef1:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101ef3:	89 e5                	mov    %esp,%ebp
80101ef5:	56                   	push   %esi
80101ef6:	53                   	push   %ebx
  if(b == 0)
80101ef7:	0f 84 ad 00 00 00    	je     80101faa <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101efd:	8b 58 08             	mov    0x8(%eax),%ebx
80101f00:	89 c1                	mov    %eax,%ecx
80101f02:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f08:	0f 87 8f 00 00 00    	ja     80101f9d <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f0e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f13:	90                   	nop
80101f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f18:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f19:	83 e0 c0             	and    $0xffffffc0,%eax
80101f1c:	3c 40                	cmp    $0x40,%al
80101f1e:	75 f8                	jne    80101f18 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f20:	31 f6                	xor    %esi,%esi
80101f22:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f27:	89 f0                	mov    %esi,%eax
80101f29:	ee                   	out    %al,(%dx)
80101f2a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f2f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f34:	ee                   	out    %al,(%dx)
80101f35:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f3a:	89 d8                	mov    %ebx,%eax
80101f3c:	ee                   	out    %al,(%dx)
80101f3d:	89 d8                	mov    %ebx,%eax
80101f3f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f44:	c1 f8 08             	sar    $0x8,%eax
80101f47:	ee                   	out    %al,(%dx)
80101f48:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f4d:	89 f0                	mov    %esi,%eax
80101f4f:	ee                   	out    %al,(%dx)
80101f50:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80101f54:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f59:	83 e0 01             	and    $0x1,%eax
80101f5c:	c1 e0 04             	shl    $0x4,%eax
80101f5f:	83 c8 e0             	or     $0xffffffe0,%eax
80101f62:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80101f63:	f6 01 04             	testb  $0x4,(%ecx)
80101f66:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f6b:	75 13                	jne    80101f80 <idestart+0x90>
80101f6d:	b8 20 00 00 00       	mov    $0x20,%eax
80101f72:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f73:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f76:	5b                   	pop    %ebx
80101f77:	5e                   	pop    %esi
80101f78:	5d                   	pop    %ebp
80101f79:	c3                   	ret    
80101f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f80:	b8 30 00 00 00       	mov    $0x30,%eax
80101f85:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101f86:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101f8b:	8d 71 5c             	lea    0x5c(%ecx),%esi
80101f8e:	b9 80 00 00 00       	mov    $0x80,%ecx
80101f93:	fc                   	cld    
80101f94:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f96:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f99:	5b                   	pop    %ebx
80101f9a:	5e                   	pop    %esi
80101f9b:	5d                   	pop    %ebp
80101f9c:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
80101f9d:	83 ec 0c             	sub    $0xc,%esp
80101fa0:	68 34 72 10 80       	push   $0x80107234
80101fa5:	e8 c6 e3 ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
80101faa:	83 ec 0c             	sub    $0xc,%esp
80101fad:	68 2b 72 10 80       	push   $0x8010722b
80101fb2:	e8 b9 e3 ff ff       	call   80100370 <panic>
80101fb7:	89 f6                	mov    %esi,%esi
80101fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fc0 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80101fc0:	55                   	push   %ebp
80101fc1:	89 e5                	mov    %esp,%ebp
80101fc3:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
80101fc6:	68 46 72 10 80       	push   $0x80107246
80101fcb:	68 80 a5 10 80       	push   $0x8010a580
80101fd0:	e8 6b 23 00 00       	call   80104340 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101fd5:	58                   	pop    %eax
80101fd6:	a1 00 2d 11 80       	mov    0x80112d00,%eax
80101fdb:	5a                   	pop    %edx
80101fdc:	83 e8 01             	sub    $0x1,%eax
80101fdf:	50                   	push   %eax
80101fe0:	6a 0e                	push   $0xe
80101fe2:	e8 a9 02 00 00       	call   80102290 <ioapicenable>
80101fe7:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101fea:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fef:	90                   	nop
80101ff0:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101ff1:	83 e0 c0             	and    $0xffffffc0,%eax
80101ff4:	3c 40                	cmp    $0x40,%al
80101ff6:	75 f8                	jne    80101ff0 <ideinit+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101ff8:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101ffd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102002:	ee                   	out    %al,(%dx)
80102003:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102008:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010200d:	eb 06                	jmp    80102015 <ideinit+0x55>
8010200f:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102010:	83 e9 01             	sub    $0x1,%ecx
80102013:	74 0f                	je     80102024 <ideinit+0x64>
80102015:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102016:	84 c0                	test   %al,%al
80102018:	74 f6                	je     80102010 <ideinit+0x50>
      havedisk1 = 1;
8010201a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102021:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102024:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102029:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
8010202e:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
8010202f:	c9                   	leave  
80102030:	c3                   	ret    
80102031:	eb 0d                	jmp    80102040 <ideintr>
80102033:	90                   	nop
80102034:	90                   	nop
80102035:	90                   	nop
80102036:	90                   	nop
80102037:	90                   	nop
80102038:	90                   	nop
80102039:	90                   	nop
8010203a:	90                   	nop
8010203b:	90                   	nop
8010203c:	90                   	nop
8010203d:	90                   	nop
8010203e:	90                   	nop
8010203f:	90                   	nop

80102040 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102040:	55                   	push   %ebp
80102041:	89 e5                	mov    %esp,%ebp
80102043:	57                   	push   %edi
80102044:	56                   	push   %esi
80102045:	53                   	push   %ebx
80102046:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102049:	68 80 a5 10 80       	push   $0x8010a580
8010204e:	e8 4d 24 00 00       	call   801044a0 <acquire>

  if((b = idequeue) == 0){
80102053:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102059:	83 c4 10             	add    $0x10,%esp
8010205c:	85 db                	test   %ebx,%ebx
8010205e:	74 34                	je     80102094 <ideintr+0x54>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102060:	8b 43 58             	mov    0x58(%ebx),%eax
80102063:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102068:	8b 33                	mov    (%ebx),%esi
8010206a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102070:	74 3e                	je     801020b0 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102072:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102075:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102078:	83 ce 02             	or     $0x2,%esi
8010207b:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010207d:	53                   	push   %ebx
8010207e:	e8 7d 1e 00 00       	call   80103f00 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102083:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102088:	83 c4 10             	add    $0x10,%esp
8010208b:	85 c0                	test   %eax,%eax
8010208d:	74 05                	je     80102094 <ideintr+0x54>
    idestart(idequeue);
8010208f:	e8 5c fe ff ff       	call   80101ef0 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
80102094:	83 ec 0c             	sub    $0xc,%esp
80102097:	68 80 a5 10 80       	push   $0x8010a580
8010209c:	e8 af 24 00 00       	call   80104550 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
801020a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020a4:	5b                   	pop    %ebx
801020a5:	5e                   	pop    %esi
801020a6:	5f                   	pop    %edi
801020a7:	5d                   	pop    %ebp
801020a8:	c3                   	ret    
801020a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020b0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020b5:	8d 76 00             	lea    0x0(%esi),%esi
801020b8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020b9:	89 c1                	mov    %eax,%ecx
801020bb:	83 e1 c0             	and    $0xffffffc0,%ecx
801020be:	80 f9 40             	cmp    $0x40,%cl
801020c1:	75 f5                	jne    801020b8 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020c3:	a8 21                	test   $0x21,%al
801020c5:	75 ab                	jne    80102072 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
801020c7:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
801020ca:	b9 80 00 00 00       	mov    $0x80,%ecx
801020cf:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020d4:	fc                   	cld    
801020d5:	f3 6d                	rep insl (%dx),%es:(%edi)
801020d7:	8b 33                	mov    (%ebx),%esi
801020d9:	eb 97                	jmp    80102072 <ideintr+0x32>
801020db:	90                   	nop
801020dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020e0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	53                   	push   %ebx
801020e4:	83 ec 10             	sub    $0x10,%esp
801020e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801020ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801020ed:	50                   	push   %eax
801020ee:	e8 fd 21 00 00       	call   801042f0 <holdingsleep>
801020f3:	83 c4 10             	add    $0x10,%esp
801020f6:	85 c0                	test   %eax,%eax
801020f8:	0f 84 ad 00 00 00    	je     801021ab <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801020fe:	8b 03                	mov    (%ebx),%eax
80102100:	83 e0 06             	and    $0x6,%eax
80102103:	83 f8 02             	cmp    $0x2,%eax
80102106:	0f 84 b9 00 00 00    	je     801021c5 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010210c:	8b 53 04             	mov    0x4(%ebx),%edx
8010210f:	85 d2                	test   %edx,%edx
80102111:	74 0d                	je     80102120 <iderw+0x40>
80102113:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102118:	85 c0                	test   %eax,%eax
8010211a:	0f 84 98 00 00 00    	je     801021b8 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102120:	83 ec 0c             	sub    $0xc,%esp
80102123:	68 80 a5 10 80       	push   $0x8010a580
80102128:	e8 73 23 00 00       	call   801044a0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010212d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102133:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102136:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010213d:	85 d2                	test   %edx,%edx
8010213f:	75 09                	jne    8010214a <iderw+0x6a>
80102141:	eb 58                	jmp    8010219b <iderw+0xbb>
80102143:	90                   	nop
80102144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102148:	89 c2                	mov    %eax,%edx
8010214a:	8b 42 58             	mov    0x58(%edx),%eax
8010214d:	85 c0                	test   %eax,%eax
8010214f:	75 f7                	jne    80102148 <iderw+0x68>
80102151:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102154:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102156:	3b 1d 64 a5 10 80    	cmp    0x8010a564,%ebx
8010215c:	74 44                	je     801021a2 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010215e:	8b 03                	mov    (%ebx),%eax
80102160:	83 e0 06             	and    $0x6,%eax
80102163:	83 f8 02             	cmp    $0x2,%eax
80102166:	74 23                	je     8010218b <iderw+0xab>
80102168:	90                   	nop
80102169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102170:	83 ec 08             	sub    $0x8,%esp
80102173:	68 80 a5 10 80       	push   $0x8010a580
80102178:	53                   	push   %ebx
80102179:	e8 c2 1b 00 00       	call   80103d40 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010217e:	8b 03                	mov    (%ebx),%eax
80102180:	83 c4 10             	add    $0x10,%esp
80102183:	83 e0 06             	and    $0x6,%eax
80102186:	83 f8 02             	cmp    $0x2,%eax
80102189:	75 e5                	jne    80102170 <iderw+0x90>
    sleep(b, &idelock);
  }


  release(&idelock);
8010218b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102192:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102195:	c9                   	leave  
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
80102196:	e9 b5 23 00 00       	jmp    80104550 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010219b:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
801021a0:	eb b2                	jmp    80102154 <iderw+0x74>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
801021a2:	89 d8                	mov    %ebx,%eax
801021a4:	e8 47 fd ff ff       	call   80101ef0 <idestart>
801021a9:	eb b3                	jmp    8010215e <iderw+0x7e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
801021ab:	83 ec 0c             	sub    $0xc,%esp
801021ae:	68 4a 72 10 80       	push   $0x8010724a
801021b3:	e8 b8 e1 ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
801021b8:	83 ec 0c             	sub    $0xc,%esp
801021bb:	68 75 72 10 80       	push   $0x80107275
801021c0:	e8 ab e1 ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801021c5:	83 ec 0c             	sub    $0xc,%esp
801021c8:	68 60 72 10 80       	push   $0x80107260
801021cd:	e8 9e e1 ff ff       	call   80100370 <panic>
801021d2:	66 90                	xchg   %ax,%ax
801021d4:	66 90                	xchg   %ax,%ax
801021d6:	66 90                	xchg   %ax,%ax
801021d8:	66 90                	xchg   %ax,%ax
801021da:	66 90                	xchg   %ax,%ax
801021dc:	66 90                	xchg   %ax,%ax
801021de:	66 90                	xchg   %ax,%ax

801021e0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021e0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801021e1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801021e8:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021eb:	89 e5                	mov    %esp,%ebp
801021ed:	56                   	push   %esi
801021ee:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801021ef:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801021f6:	00 00 00 
  return ioapic->data;
801021f9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801021ff:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102202:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102208:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010220e:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102215:	89 f0                	mov    %esi,%eax
80102217:	c1 e8 10             	shr    $0x10,%eax
8010221a:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010221d:	8b 41 10             	mov    0x10(%ecx),%eax
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102220:	c1 e8 18             	shr    $0x18,%eax
80102223:	39 d0                	cmp    %edx,%eax
80102225:	74 16                	je     8010223d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102227:	83 ec 0c             	sub    $0xc,%esp
8010222a:	68 94 72 10 80       	push   $0x80107294
8010222f:	e8 2c e4 ff ff       	call   80100660 <cprintf>
80102234:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010223a:	83 c4 10             	add    $0x10,%esp
8010223d:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102240:	ba 10 00 00 00       	mov    $0x10,%edx
80102245:	b8 20 00 00 00       	mov    $0x20,%eax
8010224a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102250:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102252:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102258:	89 c3                	mov    %eax,%ebx
8010225a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
80102260:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102263:	89 59 10             	mov    %ebx,0x10(%ecx)
80102266:	8d 5a 01             	lea    0x1(%edx),%ebx
80102269:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010226c:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010226e:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102270:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102276:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010227d:	75 d1                	jne    80102250 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010227f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102282:	5b                   	pop    %ebx
80102283:	5e                   	pop    %esi
80102284:	5d                   	pop    %ebp
80102285:	c3                   	ret    
80102286:	8d 76 00             	lea    0x0(%esi),%esi
80102289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102290 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102290:	55                   	push   %ebp
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102291:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  }
}

void
ioapicenable(int irq, int cpunum)
{
80102297:	89 e5                	mov    %esp,%ebp
80102299:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010229c:	8d 50 20             	lea    0x20(%eax),%edx
8010229f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022a3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022a5:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022ab:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022ae:	89 51 10             	mov    %edx,0x10(%ecx)
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022b1:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022b4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022b6:	a1 34 26 11 80       	mov    0x80112634,%eax
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022bb:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022be:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801022c1:	5d                   	pop    %ebp
801022c2:	c3                   	ret    
801022c3:	66 90                	xchg   %ax,%ax
801022c5:	66 90                	xchg   %ax,%ax
801022c7:	66 90                	xchg   %ax,%ax
801022c9:	66 90                	xchg   %ax,%ax
801022cb:	66 90                	xchg   %ax,%ax
801022cd:	66 90                	xchg   %ax,%ax
801022cf:	90                   	nop

801022d0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801022d0:	55                   	push   %ebp
801022d1:	89 e5                	mov    %esp,%ebp
801022d3:	53                   	push   %ebx
801022d4:	83 ec 04             	sub    $0x4,%esp
801022d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801022da:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801022e0:	75 70                	jne    80102352 <kfree+0x82>
801022e2:	81 fb a8 57 11 80    	cmp    $0x801157a8,%ebx
801022e8:	72 68                	jb     80102352 <kfree+0x82>
801022ea:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801022f0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801022f5:	77 5b                	ja     80102352 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801022f7:	83 ec 04             	sub    $0x4,%esp
801022fa:	68 00 10 00 00       	push   $0x1000
801022ff:	6a 01                	push   $0x1
80102301:	53                   	push   %ebx
80102302:	e8 99 22 00 00       	call   801045a0 <memset>

  if(kmem.use_lock)
80102307:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010230d:	83 c4 10             	add    $0x10,%esp
80102310:	85 d2                	test   %edx,%edx
80102312:	75 2c                	jne    80102340 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102314:	a1 78 26 11 80       	mov    0x80112678,%eax
80102319:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010231b:	a1 74 26 11 80       	mov    0x80112674,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102320:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102326:	85 c0                	test   %eax,%eax
80102328:	75 06                	jne    80102330 <kfree+0x60>
    release(&kmem.lock);
}
8010232a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010232d:	c9                   	leave  
8010232e:	c3                   	ret    
8010232f:	90                   	nop
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102330:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102337:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010233a:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
8010233b:	e9 10 22 00 00       	jmp    80104550 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102340:	83 ec 0c             	sub    $0xc,%esp
80102343:	68 40 26 11 80       	push   $0x80112640
80102348:	e8 53 21 00 00       	call   801044a0 <acquire>
8010234d:	83 c4 10             	add    $0x10,%esp
80102350:	eb c2                	jmp    80102314 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
80102352:	83 ec 0c             	sub    $0xc,%esp
80102355:	68 c6 72 10 80       	push   $0x801072c6
8010235a:	e8 11 e0 ff ff       	call   80100370 <panic>
8010235f:	90                   	nop

80102360 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102360:	55                   	push   %ebp
80102361:	89 e5                	mov    %esp,%ebp
80102363:	56                   	push   %esi
80102364:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102365:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102368:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010236b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102371:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102377:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010237d:	39 de                	cmp    %ebx,%esi
8010237f:	72 23                	jb     801023a4 <freerange+0x44>
80102381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102388:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010238e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102391:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102397:	50                   	push   %eax
80102398:	e8 33 ff ff ff       	call   801022d0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010239d:	83 c4 10             	add    $0x10,%esp
801023a0:	39 f3                	cmp    %esi,%ebx
801023a2:	76 e4                	jbe    80102388 <freerange+0x28>
    kfree(p);
}
801023a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023a7:	5b                   	pop    %ebx
801023a8:	5e                   	pop    %esi
801023a9:	5d                   	pop    %ebp
801023aa:	c3                   	ret    
801023ab:	90                   	nop
801023ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023b0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801023b0:	55                   	push   %ebp
801023b1:	89 e5                	mov    %esp,%ebp
801023b3:	56                   	push   %esi
801023b4:	53                   	push   %ebx
801023b5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023b8:	83 ec 08             	sub    $0x8,%esp
801023bb:	68 cc 72 10 80       	push   $0x801072cc
801023c0:	68 40 26 11 80       	push   $0x80112640
801023c5:	e8 76 1f 00 00       	call   80104340 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023ca:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023cd:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
801023d0:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801023d7:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023da:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023e0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023e6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023ec:	39 de                	cmp    %ebx,%esi
801023ee:	72 1c                	jb     8010240c <kinit1+0x5c>
    kfree(p);
801023f0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023f6:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023f9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023ff:	50                   	push   %eax
80102400:	e8 cb fe ff ff       	call   801022d0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102405:	83 c4 10             	add    $0x10,%esp
80102408:	39 de                	cmp    %ebx,%esi
8010240a:	73 e4                	jae    801023f0 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010240c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010240f:	5b                   	pop    %ebx
80102410:	5e                   	pop    %esi
80102411:	5d                   	pop    %ebp
80102412:	c3                   	ret    
80102413:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102420 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102420:	55                   	push   %ebp
80102421:	89 e5                	mov    %esp,%ebp
80102423:	56                   	push   %esi
80102424:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102425:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
80102428:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010242b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102431:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102437:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010243d:	39 de                	cmp    %ebx,%esi
8010243f:	72 23                	jb     80102464 <kinit2+0x44>
80102441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102448:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010244e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102451:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102457:	50                   	push   %eax
80102458:	e8 73 fe ff ff       	call   801022d0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010245d:	83 c4 10             	add    $0x10,%esp
80102460:	39 de                	cmp    %ebx,%esi
80102462:	73 e4                	jae    80102448 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
80102464:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010246b:	00 00 00 
}
8010246e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102471:	5b                   	pop    %ebx
80102472:	5e                   	pop    %esi
80102473:	5d                   	pop    %ebp
80102474:	c3                   	ret    
80102475:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102480 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102480:	55                   	push   %ebp
80102481:	89 e5                	mov    %esp,%ebp
80102483:	53                   	push   %ebx
80102484:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102487:	a1 74 26 11 80       	mov    0x80112674,%eax
8010248c:	85 c0                	test   %eax,%eax
8010248e:	75 30                	jne    801024c0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102490:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
80102496:	85 db                	test   %ebx,%ebx
80102498:	74 1c                	je     801024b6 <kalloc+0x36>
    kmem.freelist = r->next;
8010249a:	8b 13                	mov    (%ebx),%edx
8010249c:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801024a2:	85 c0                	test   %eax,%eax
801024a4:	74 10                	je     801024b6 <kalloc+0x36>
    release(&kmem.lock);
801024a6:	83 ec 0c             	sub    $0xc,%esp
801024a9:	68 40 26 11 80       	push   $0x80112640
801024ae:	e8 9d 20 00 00       	call   80104550 <release>
801024b3:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
801024b6:	89 d8                	mov    %ebx,%eax
801024b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024bb:	c9                   	leave  
801024bc:	c3                   	ret    
801024bd:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
801024c0:	83 ec 0c             	sub    $0xc,%esp
801024c3:	68 40 26 11 80       	push   $0x80112640
801024c8:	e8 d3 1f 00 00       	call   801044a0 <acquire>
  r = kmem.freelist;
801024cd:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801024d3:	83 c4 10             	add    $0x10,%esp
801024d6:	a1 74 26 11 80       	mov    0x80112674,%eax
801024db:	85 db                	test   %ebx,%ebx
801024dd:	75 bb                	jne    8010249a <kalloc+0x1a>
801024df:	eb c1                	jmp    801024a2 <kalloc+0x22>
801024e1:	66 90                	xchg   %ax,%ax
801024e3:	66 90                	xchg   %ax,%ax
801024e5:	66 90                	xchg   %ax,%ax
801024e7:	66 90                	xchg   %ax,%ax
801024e9:	66 90                	xchg   %ax,%ax
801024eb:	66 90                	xchg   %ax,%ax
801024ed:	66 90                	xchg   %ax,%ax
801024ef:	90                   	nop

801024f0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801024f0:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024f1:	ba 64 00 00 00       	mov    $0x64,%edx
801024f6:	89 e5                	mov    %esp,%ebp
801024f8:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801024f9:	a8 01                	test   $0x1,%al
801024fb:	0f 84 af 00 00 00    	je     801025b0 <kbdgetc+0xc0>
80102501:	ba 60 00 00 00       	mov    $0x60,%edx
80102506:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102507:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
8010250a:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102510:	74 7e                	je     80102590 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102512:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102514:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
8010251a:	79 24                	jns    80102540 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
8010251c:	f6 c1 40             	test   $0x40,%cl
8010251f:	75 05                	jne    80102526 <kbdgetc+0x36>
80102521:	89 c2                	mov    %eax,%edx
80102523:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102526:	0f b6 82 00 74 10 80 	movzbl -0x7fef8c00(%edx),%eax
8010252d:	83 c8 40             	or     $0x40,%eax
80102530:	0f b6 c0             	movzbl %al,%eax
80102533:	f7 d0                	not    %eax
80102535:	21 c8                	and    %ecx,%eax
80102537:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010253c:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010253e:	5d                   	pop    %ebp
8010253f:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102540:	f6 c1 40             	test   $0x40,%cl
80102543:	74 09                	je     8010254e <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102545:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102548:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010254b:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
8010254e:	0f b6 82 00 74 10 80 	movzbl -0x7fef8c00(%edx),%eax
80102555:	09 c1                	or     %eax,%ecx
80102557:	0f b6 82 00 73 10 80 	movzbl -0x7fef8d00(%edx),%eax
8010255e:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102560:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102562:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102568:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010256b:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010256e:	8b 04 85 e0 72 10 80 	mov    -0x7fef8d20(,%eax,4),%eax
80102575:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102579:	74 c3                	je     8010253e <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
8010257b:	8d 50 9f             	lea    -0x61(%eax),%edx
8010257e:	83 fa 19             	cmp    $0x19,%edx
80102581:	77 1d                	ja     801025a0 <kbdgetc+0xb0>
      c += 'A' - 'a';
80102583:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102586:	5d                   	pop    %ebp
80102587:	c3                   	ret    
80102588:	90                   	nop
80102589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
80102590:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102592:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102599:	5d                   	pop    %ebp
8010259a:	c3                   	ret    
8010259b:	90                   	nop
8010259c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
801025a0:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025a3:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
801025a6:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
801025a7:	83 f9 19             	cmp    $0x19,%ecx
801025aa:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
801025ad:	c3                   	ret    
801025ae:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
801025b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025b5:	5d                   	pop    %ebp
801025b6:	c3                   	ret    
801025b7:	89 f6                	mov    %esi,%esi
801025b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025c0 <kbdintr>:

void
kbdintr(void)
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801025c6:	68 f0 24 10 80       	push   $0x801024f0
801025cb:	e8 20 e2 ff ff       	call   801007f0 <consoleintr>
}
801025d0:	83 c4 10             	add    $0x10,%esp
801025d3:	c9                   	leave  
801025d4:	c3                   	ret    
801025d5:	66 90                	xchg   %ax,%ax
801025d7:	66 90                	xchg   %ax,%ax
801025d9:	66 90                	xchg   %ax,%ax
801025db:	66 90                	xchg   %ax,%ax
801025dd:	66 90                	xchg   %ax,%ax
801025df:	90                   	nop

801025e0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801025e0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801025e5:	55                   	push   %ebp
801025e6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801025e8:	85 c0                	test   %eax,%eax
801025ea:	0f 84 c8 00 00 00    	je     801026b8 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025f0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801025f7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801025fa:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025fd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102604:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102607:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010260a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102611:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102614:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102617:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010261e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102621:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102624:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010262b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010262e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102631:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102638:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010263b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010263e:	8b 50 30             	mov    0x30(%eax),%edx
80102641:	c1 ea 10             	shr    $0x10,%edx
80102644:	80 fa 03             	cmp    $0x3,%dl
80102647:	77 77                	ja     801026c0 <lapicinit+0xe0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102649:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102650:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102653:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102656:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010265d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102660:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102663:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010266a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010266d:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102670:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102677:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010267a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010267d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102684:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102687:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010268a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102691:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102694:	8b 50 20             	mov    0x20(%eax),%edx
80102697:	89 f6                	mov    %esi,%esi
80102699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801026a0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801026a6:	80 e6 10             	and    $0x10,%dh
801026a9:	75 f5                	jne    801026a0 <lapicinit+0xc0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026ab:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801026b2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026b5:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801026b8:	5d                   	pop    %ebp
801026b9:	c3                   	ret    
801026ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026c0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801026c7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ca:	8b 50 20             	mov    0x20(%eax),%edx
801026cd:	e9 77 ff ff ff       	jmp    80102649 <lapicinit+0x69>
801026d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026e0 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
801026e0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
801026e5:	55                   	push   %ebp
801026e6:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801026e8:	85 c0                	test   %eax,%eax
801026ea:	74 0c                	je     801026f8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801026ec:	8b 40 20             	mov    0x20(%eax),%eax
}
801026ef:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
801026f0:	c1 e8 18             	shr    $0x18,%eax
}
801026f3:	c3                   	ret    
801026f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
801026f8:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
801026fa:	5d                   	pop    %ebp
801026fb:	c3                   	ret    
801026fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102700 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102700:	a1 7c 26 11 80       	mov    0x8011267c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102705:	55                   	push   %ebp
80102706:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102708:	85 c0                	test   %eax,%eax
8010270a:	74 0d                	je     80102719 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010270c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102713:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102716:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102719:	5d                   	pop    %ebp
8010271a:	c3                   	ret    
8010271b:	90                   	nop
8010271c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102720 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102720:	55                   	push   %ebp
80102721:	89 e5                	mov    %esp,%ebp
}
80102723:	5d                   	pop    %ebp
80102724:	c3                   	ret    
80102725:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102730 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102730:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102731:	ba 70 00 00 00       	mov    $0x70,%edx
80102736:	b8 0f 00 00 00       	mov    $0xf,%eax
8010273b:	89 e5                	mov    %esp,%ebp
8010273d:	53                   	push   %ebx
8010273e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102741:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102744:	ee                   	out    %al,(%dx)
80102745:	ba 71 00 00 00       	mov    $0x71,%edx
8010274a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010274f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102750:	31 c0                	xor    %eax,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102752:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102755:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010275b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010275d:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102760:	c1 e8 04             	shr    $0x4,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102763:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102765:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102768:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010276e:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102773:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102779:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010277c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102783:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102786:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102789:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102790:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102793:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102796:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010279c:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010279f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027a5:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027a8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027ae:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027b1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027b7:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801027ba:	5b                   	pop    %ebx
801027bb:	5d                   	pop    %ebp
801027bc:	c3                   	ret    
801027bd:	8d 76 00             	lea    0x0(%esi),%esi

801027c0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801027c0:	55                   	push   %ebp
801027c1:	ba 70 00 00 00       	mov    $0x70,%edx
801027c6:	b8 0b 00 00 00       	mov    $0xb,%eax
801027cb:	89 e5                	mov    %esp,%ebp
801027cd:	57                   	push   %edi
801027ce:	56                   	push   %esi
801027cf:	53                   	push   %ebx
801027d0:	83 ec 4c             	sub    $0x4c,%esp
801027d3:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027d4:	ba 71 00 00 00       	mov    $0x71,%edx
801027d9:	ec                   	in     (%dx),%al
801027da:	83 e0 04             	and    $0x4,%eax
801027dd:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027e0:	31 db                	xor    %ebx,%ebx
801027e2:	88 45 b7             	mov    %al,-0x49(%ebp)
801027e5:	bf 70 00 00 00       	mov    $0x70,%edi
801027ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801027f0:	89 d8                	mov    %ebx,%eax
801027f2:	89 fa                	mov    %edi,%edx
801027f4:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027f5:	b9 71 00 00 00       	mov    $0x71,%ecx
801027fa:	89 ca                	mov    %ecx,%edx
801027fc:	ec                   	in     (%dx),%al
}

static void
fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
801027fd:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102800:	89 fa                	mov    %edi,%edx
80102802:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102805:	b8 02 00 00 00       	mov    $0x2,%eax
8010280a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010280b:	89 ca                	mov    %ecx,%edx
8010280d:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
8010280e:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102811:	89 fa                	mov    %edi,%edx
80102813:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102816:	b8 04 00 00 00       	mov    $0x4,%eax
8010281b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010281c:	89 ca                	mov    %ecx,%edx
8010281e:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
8010281f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102822:	89 fa                	mov    %edi,%edx
80102824:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102827:	b8 07 00 00 00       	mov    $0x7,%eax
8010282c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010282d:	89 ca                	mov    %ecx,%edx
8010282f:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102830:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102833:	89 fa                	mov    %edi,%edx
80102835:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102838:	b8 08 00 00 00       	mov    $0x8,%eax
8010283d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010283e:	89 ca                	mov    %ecx,%edx
80102840:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102841:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102844:	89 fa                	mov    %edi,%edx
80102846:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102849:	b8 09 00 00 00       	mov    $0x9,%eax
8010284e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010284f:	89 ca                	mov    %ecx,%edx
80102851:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102852:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102855:	89 fa                	mov    %edi,%edx
80102857:	89 45 cc             	mov    %eax,-0x34(%ebp)
8010285a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010285f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102860:	89 ca                	mov    %ecx,%edx
80102862:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102863:	84 c0                	test   %al,%al
80102865:	78 89                	js     801027f0 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102867:	89 d8                	mov    %ebx,%eax
80102869:	89 fa                	mov    %edi,%edx
8010286b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010286c:	89 ca                	mov    %ecx,%edx
8010286e:	ec                   	in     (%dx),%al
}

static void
fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
8010286f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102872:	89 fa                	mov    %edi,%edx
80102874:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102877:	b8 02 00 00 00       	mov    $0x2,%eax
8010287c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287d:	89 ca                	mov    %ecx,%edx
8010287f:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102880:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102883:	89 fa                	mov    %edi,%edx
80102885:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102888:	b8 04 00 00 00       	mov    $0x4,%eax
8010288d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010288e:	89 ca                	mov    %ecx,%edx
80102890:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102891:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102894:	89 fa                	mov    %edi,%edx
80102896:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102899:	b8 07 00 00 00       	mov    $0x7,%eax
8010289e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010289f:	89 ca                	mov    %ecx,%edx
801028a1:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
801028a2:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028a5:	89 fa                	mov    %edi,%edx
801028a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801028aa:	b8 08 00 00 00       	mov    $0x8,%eax
801028af:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028b0:	89 ca                	mov    %ecx,%edx
801028b2:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
801028b3:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028b6:	89 fa                	mov    %edi,%edx
801028b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801028bb:	b8 09 00 00 00       	mov    $0x9,%eax
801028c0:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028c1:	89 ca                	mov    %ecx,%edx
801028c3:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
801028c4:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028c7:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
801028ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028cd:	8d 45 b8             	lea    -0x48(%ebp),%eax
801028d0:	6a 18                	push   $0x18
801028d2:	56                   	push   %esi
801028d3:	50                   	push   %eax
801028d4:	e8 17 1d 00 00       	call   801045f0 <memcmp>
801028d9:	83 c4 10             	add    $0x10,%esp
801028dc:	85 c0                	test   %eax,%eax
801028de:	0f 85 0c ff ff ff    	jne    801027f0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
801028e4:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
801028e8:	75 78                	jne    80102962 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801028ea:	8b 45 b8             	mov    -0x48(%ebp),%eax
801028ed:	89 c2                	mov    %eax,%edx
801028ef:	83 e0 0f             	and    $0xf,%eax
801028f2:	c1 ea 04             	shr    $0x4,%edx
801028f5:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028f8:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028fb:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801028fe:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102901:	89 c2                	mov    %eax,%edx
80102903:	83 e0 0f             	and    $0xf,%eax
80102906:	c1 ea 04             	shr    $0x4,%edx
80102909:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010290c:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010290f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102912:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102915:	89 c2                	mov    %eax,%edx
80102917:	83 e0 0f             	and    $0xf,%eax
8010291a:	c1 ea 04             	shr    $0x4,%edx
8010291d:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102920:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102923:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102926:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102929:	89 c2                	mov    %eax,%edx
8010292b:	83 e0 0f             	and    $0xf,%eax
8010292e:	c1 ea 04             	shr    $0x4,%edx
80102931:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102934:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102937:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010293a:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010293d:	89 c2                	mov    %eax,%edx
8010293f:	83 e0 0f             	and    $0xf,%eax
80102942:	c1 ea 04             	shr    $0x4,%edx
80102945:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102948:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010294b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010294e:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102951:	89 c2                	mov    %eax,%edx
80102953:	83 e0 0f             	and    $0xf,%eax
80102956:	c1 ea 04             	shr    $0x4,%edx
80102959:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010295c:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010295f:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102962:	8b 75 08             	mov    0x8(%ebp),%esi
80102965:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102968:	89 06                	mov    %eax,(%esi)
8010296a:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010296d:	89 46 04             	mov    %eax,0x4(%esi)
80102970:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102973:	89 46 08             	mov    %eax,0x8(%esi)
80102976:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102979:	89 46 0c             	mov    %eax,0xc(%esi)
8010297c:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010297f:	89 46 10             	mov    %eax,0x10(%esi)
80102982:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102985:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102988:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010298f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102992:	5b                   	pop    %ebx
80102993:	5e                   	pop    %esi
80102994:	5f                   	pop    %edi
80102995:	5d                   	pop    %ebp
80102996:	c3                   	ret    
80102997:	66 90                	xchg   %ax,%ax
80102999:	66 90                	xchg   %ax,%ax
8010299b:	66 90                	xchg   %ax,%ax
8010299d:	66 90                	xchg   %ax,%ax
8010299f:	90                   	nop

801029a0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029a0:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
801029a6:	85 c9                	test   %ecx,%ecx
801029a8:	0f 8e 85 00 00 00    	jle    80102a33 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801029ae:	55                   	push   %ebp
801029af:	89 e5                	mov    %esp,%ebp
801029b1:	57                   	push   %edi
801029b2:	56                   	push   %esi
801029b3:	53                   	push   %ebx
801029b4:	31 db                	xor    %ebx,%ebx
801029b6:	83 ec 0c             	sub    $0xc,%esp
801029b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801029c0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
801029c5:	83 ec 08             	sub    $0x8,%esp
801029c8:	01 d8                	add    %ebx,%eax
801029ca:	83 c0 01             	add    $0x1,%eax
801029cd:	50                   	push   %eax
801029ce:	ff 35 c4 26 11 80    	pushl  0x801126c4
801029d4:	e8 f7 d6 ff ff       	call   801000d0 <bread>
801029d9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029db:	58                   	pop    %eax
801029dc:	5a                   	pop    %edx
801029dd:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
801029e4:	ff 35 c4 26 11 80    	pushl  0x801126c4
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029ea:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029ed:	e8 de d6 ff ff       	call   801000d0 <bread>
801029f2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029f4:	8d 47 5c             	lea    0x5c(%edi),%eax
801029f7:	83 c4 0c             	add    $0xc,%esp
801029fa:	68 00 02 00 00       	push   $0x200
801029ff:	50                   	push   %eax
80102a00:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a03:	50                   	push   %eax
80102a04:	e8 47 1c 00 00       	call   80104650 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a09:	89 34 24             	mov    %esi,(%esp)
80102a0c:	e8 8f d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a11:	89 3c 24             	mov    %edi,(%esp)
80102a14:	e8 c7 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a19:	89 34 24             	mov    %esi,(%esp)
80102a1c:	e8 bf d7 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a21:	83 c4 10             	add    $0x10,%esp
80102a24:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102a2a:	7f 94                	jg     801029c0 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102a2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a2f:	5b                   	pop    %ebx
80102a30:	5e                   	pop    %esi
80102a31:	5f                   	pop    %edi
80102a32:	5d                   	pop    %ebp
80102a33:	f3 c3                	repz ret 
80102a35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a40 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a40:	55                   	push   %ebp
80102a41:	89 e5                	mov    %esp,%ebp
80102a43:	53                   	push   %ebx
80102a44:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a47:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102a4d:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102a53:	e8 78 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a58:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102a5e:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102a61:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102a63:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a65:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102a68:	7e 1f                	jle    80102a89 <write_head+0x49>
80102a6a:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102a71:	31 d2                	xor    %edx,%edx
80102a73:	90                   	nop
80102a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102a78:	8b 8a cc 26 11 80    	mov    -0x7feed934(%edx),%ecx
80102a7e:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102a82:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102a85:	39 c2                	cmp    %eax,%edx
80102a87:	75 ef                	jne    80102a78 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102a89:	83 ec 0c             	sub    $0xc,%esp
80102a8c:	53                   	push   %ebx
80102a8d:	e8 0e d7 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102a92:	89 1c 24             	mov    %ebx,(%esp)
80102a95:	e8 46 d7 ff ff       	call   801001e0 <brelse>
}
80102a9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a9d:	c9                   	leave  
80102a9e:	c3                   	ret    
80102a9f:	90                   	nop

80102aa0 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102aa0:	55                   	push   %ebp
80102aa1:	89 e5                	mov    %esp,%ebp
80102aa3:	53                   	push   %ebx
80102aa4:	83 ec 2c             	sub    $0x2c,%esp
80102aa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102aaa:	68 00 75 10 80       	push   $0x80107500
80102aaf:	68 80 26 11 80       	push   $0x80112680
80102ab4:	e8 87 18 00 00       	call   80104340 <initlock>
  readsb(dev, &sb);
80102ab9:	58                   	pop    %eax
80102aba:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102abd:	5a                   	pop    %edx
80102abe:	50                   	push   %eax
80102abf:	53                   	push   %ebx
80102ac0:	e8 5b e9 ff ff       	call   80101420 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102ac5:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102ac8:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102acb:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102acc:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102ad2:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102ad8:	a3 b4 26 11 80       	mov    %eax,0x801126b4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102add:	5a                   	pop    %edx
80102ade:	50                   	push   %eax
80102adf:	53                   	push   %ebx
80102ae0:	e8 eb d5 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102ae5:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102ae8:	83 c4 10             	add    $0x10,%esp
80102aeb:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102aed:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102af3:	7e 1c                	jle    80102b11 <initlog+0x71>
80102af5:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102afc:	31 d2                	xor    %edx,%edx
80102afe:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102b00:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b04:	83 c2 04             	add    $0x4,%edx
80102b07:	89 8a c8 26 11 80    	mov    %ecx,-0x7feed938(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102b0d:	39 da                	cmp    %ebx,%edx
80102b0f:	75 ef                	jne    80102b00 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102b11:	83 ec 0c             	sub    $0xc,%esp
80102b14:	50                   	push   %eax
80102b15:	e8 c6 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b1a:	e8 81 fe ff ff       	call   801029a0 <install_trans>
  log.lh.n = 0;
80102b1f:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102b26:	00 00 00 
  write_head(); // clear the log
80102b29:	e8 12 ff ff ff       	call   80102a40 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102b2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b31:	c9                   	leave  
80102b32:	c3                   	ret    
80102b33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b40:	55                   	push   %ebp
80102b41:	89 e5                	mov    %esp,%ebp
80102b43:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102b46:	68 80 26 11 80       	push   $0x80112680
80102b4b:	e8 50 19 00 00       	call   801044a0 <acquire>
80102b50:	83 c4 10             	add    $0x10,%esp
80102b53:	eb 18                	jmp    80102b6d <begin_op+0x2d>
80102b55:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b58:	83 ec 08             	sub    $0x8,%esp
80102b5b:	68 80 26 11 80       	push   $0x80112680
80102b60:	68 80 26 11 80       	push   $0x80112680
80102b65:	e8 d6 11 00 00       	call   80103d40 <sleep>
80102b6a:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102b6d:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102b72:	85 c0                	test   %eax,%eax
80102b74:	75 e2                	jne    80102b58 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102b76:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102b7b:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102b81:	83 c0 01             	add    $0x1,%eax
80102b84:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102b87:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102b8a:	83 fa 1e             	cmp    $0x1e,%edx
80102b8d:	7f c9                	jg     80102b58 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102b8f:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102b92:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102b97:	68 80 26 11 80       	push   $0x80112680
80102b9c:	e8 af 19 00 00       	call   80104550 <release>
      break;
    }
  }
}
80102ba1:	83 c4 10             	add    $0x10,%esp
80102ba4:	c9                   	leave  
80102ba5:	c3                   	ret    
80102ba6:	8d 76 00             	lea    0x0(%esi),%esi
80102ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bb0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102bb0:	55                   	push   %ebp
80102bb1:	89 e5                	mov    %esp,%ebp
80102bb3:	57                   	push   %edi
80102bb4:	56                   	push   %esi
80102bb5:	53                   	push   %ebx
80102bb6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102bb9:	68 80 26 11 80       	push   $0x80112680
80102bbe:	e8 dd 18 00 00       	call   801044a0 <acquire>
  log.outstanding -= 1;
80102bc3:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102bc8:	8b 1d c0 26 11 80    	mov    0x801126c0,%ebx
80102bce:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102bd1:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102bd4:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102bd6:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102bdb:	0f 85 23 01 00 00    	jne    80102d04 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102be1:	85 c0                	test   %eax,%eax
80102be3:	0f 85 f7 00 00 00    	jne    80102ce0 <end_op+0x130>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102be9:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102bec:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102bf3:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80102bf6:	31 db                	xor    %ebx,%ebx
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102bf8:	68 80 26 11 80       	push   $0x80112680
80102bfd:	e8 4e 19 00 00       	call   80104550 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c02:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102c08:	83 c4 10             	add    $0x10,%esp
80102c0b:	85 c9                	test   %ecx,%ecx
80102c0d:	0f 8e 8a 00 00 00    	jle    80102c9d <end_op+0xed>
80102c13:	90                   	nop
80102c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c18:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102c1d:	83 ec 08             	sub    $0x8,%esp
80102c20:	01 d8                	add    %ebx,%eax
80102c22:	83 c0 01             	add    $0x1,%eax
80102c25:	50                   	push   %eax
80102c26:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102c2c:	e8 9f d4 ff ff       	call   801000d0 <bread>
80102c31:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c33:	58                   	pop    %eax
80102c34:	5a                   	pop    %edx
80102c35:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102c3c:	ff 35 c4 26 11 80    	pushl  0x801126c4
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c42:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c45:	e8 86 d4 ff ff       	call   801000d0 <bread>
80102c4a:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c4c:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c4f:	83 c4 0c             	add    $0xc,%esp
80102c52:	68 00 02 00 00       	push   $0x200
80102c57:	50                   	push   %eax
80102c58:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c5b:	50                   	push   %eax
80102c5c:	e8 ef 19 00 00       	call   80104650 <memmove>
    bwrite(to);  // write the log
80102c61:	89 34 24             	mov    %esi,(%esp)
80102c64:	e8 37 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c69:	89 3c 24             	mov    %edi,(%esp)
80102c6c:	e8 6f d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102c71:	89 34 24             	mov    %esi,(%esp)
80102c74:	e8 67 d5 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c79:	83 c4 10             	add    $0x10,%esp
80102c7c:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102c82:	7c 94                	jl     80102c18 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102c84:	e8 b7 fd ff ff       	call   80102a40 <write_head>
    install_trans(); // Now install writes to home locations
80102c89:	e8 12 fd ff ff       	call   801029a0 <install_trans>
    log.lh.n = 0;
80102c8e:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102c95:	00 00 00 
    write_head();    // Erase the transaction from the log
80102c98:	e8 a3 fd ff ff       	call   80102a40 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102c9d:	83 ec 0c             	sub    $0xc,%esp
80102ca0:	68 80 26 11 80       	push   $0x80112680
80102ca5:	e8 f6 17 00 00       	call   801044a0 <acquire>
    log.committing = 0;
    wakeup(&log);
80102caa:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80102cb1:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102cb8:	00 00 00 
    wakeup(&log);
80102cbb:	e8 40 12 00 00       	call   80103f00 <wakeup>
    release(&log.lock);
80102cc0:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102cc7:	e8 84 18 00 00       	call   80104550 <release>
80102ccc:	83 c4 10             	add    $0x10,%esp
  }
}
80102ccf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cd2:	5b                   	pop    %ebx
80102cd3:	5e                   	pop    %esi
80102cd4:	5f                   	pop    %edi
80102cd5:	5d                   	pop    %ebp
80102cd6:	c3                   	ret    
80102cd7:	89 f6                	mov    %esi,%esi
80102cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80102ce0:	83 ec 0c             	sub    $0xc,%esp
80102ce3:	68 80 26 11 80       	push   $0x80112680
80102ce8:	e8 13 12 00 00       	call   80103f00 <wakeup>
  }
  release(&log.lock);
80102ced:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102cf4:	e8 57 18 00 00       	call   80104550 <release>
80102cf9:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
80102cfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cff:	5b                   	pop    %ebx
80102d00:	5e                   	pop    %esi
80102d01:	5f                   	pop    %edi
80102d02:	5d                   	pop    %ebp
80102d03:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102d04:	83 ec 0c             	sub    $0xc,%esp
80102d07:	68 04 75 10 80       	push   $0x80107504
80102d0c:	e8 5f d6 ff ff       	call   80100370 <panic>
80102d11:	eb 0d                	jmp    80102d20 <log_write>
80102d13:	90                   	nop
80102d14:	90                   	nop
80102d15:	90                   	nop
80102d16:	90                   	nop
80102d17:	90                   	nop
80102d18:	90                   	nop
80102d19:	90                   	nop
80102d1a:	90                   	nop
80102d1b:	90                   	nop
80102d1c:	90                   	nop
80102d1d:	90                   	nop
80102d1e:	90                   	nop
80102d1f:	90                   	nop

80102d20 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d20:	55                   	push   %ebp
80102d21:	89 e5                	mov    %esp,%ebp
80102d23:	53                   	push   %ebx
80102d24:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d27:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d2d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d30:	83 fa 1d             	cmp    $0x1d,%edx
80102d33:	0f 8f 97 00 00 00    	jg     80102dd0 <log_write+0xb0>
80102d39:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102d3e:	83 e8 01             	sub    $0x1,%eax
80102d41:	39 c2                	cmp    %eax,%edx
80102d43:	0f 8d 87 00 00 00    	jge    80102dd0 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d49:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102d4e:	85 c0                	test   %eax,%eax
80102d50:	0f 8e 87 00 00 00    	jle    80102ddd <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102d56:	83 ec 0c             	sub    $0xc,%esp
80102d59:	68 80 26 11 80       	push   $0x80112680
80102d5e:	e8 3d 17 00 00       	call   801044a0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d63:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102d69:	83 c4 10             	add    $0x10,%esp
80102d6c:	83 fa 00             	cmp    $0x0,%edx
80102d6f:	7e 50                	jle    80102dc1 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d71:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d74:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d76:	3b 0d cc 26 11 80    	cmp    0x801126cc,%ecx
80102d7c:	75 0b                	jne    80102d89 <log_write+0x69>
80102d7e:	eb 38                	jmp    80102db8 <log_write+0x98>
80102d80:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102d87:	74 2f                	je     80102db8 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d89:	83 c0 01             	add    $0x1,%eax
80102d8c:	39 d0                	cmp    %edx,%eax
80102d8e:	75 f0                	jne    80102d80 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102d90:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102d97:	83 c2 01             	add    $0x1,%edx
80102d9a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102da0:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102da3:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102daa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dad:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102dae:	e9 9d 17 00 00       	jmp    80104550 <release>
80102db3:	90                   	nop
80102db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102db8:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
80102dbf:	eb df                	jmp    80102da0 <log_write+0x80>
80102dc1:	8b 43 08             	mov    0x8(%ebx),%eax
80102dc4:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102dc9:	75 d5                	jne    80102da0 <log_write+0x80>
80102dcb:	eb ca                	jmp    80102d97 <log_write+0x77>
80102dcd:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102dd0:	83 ec 0c             	sub    $0xc,%esp
80102dd3:	68 13 75 10 80       	push   $0x80107513
80102dd8:	e8 93 d5 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102ddd:	83 ec 0c             	sub    $0xc,%esp
80102de0:	68 29 75 10 80       	push   $0x80107529
80102de5:	e8 86 d5 ff ff       	call   80100370 <panic>
80102dea:	66 90                	xchg   %ax,%ax
80102dec:	66 90                	xchg   %ax,%ax
80102dee:	66 90                	xchg   %ax,%ax

80102df0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102df0:	55                   	push   %ebp
80102df1:	89 e5                	mov    %esp,%ebp
80102df3:	53                   	push   %ebx
80102df4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102df7:	e8 74 09 00 00       	call   80103770 <cpuid>
80102dfc:	89 c3                	mov    %eax,%ebx
80102dfe:	e8 6d 09 00 00       	call   80103770 <cpuid>
80102e03:	83 ec 04             	sub    $0x4,%esp
80102e06:	53                   	push   %ebx
80102e07:	50                   	push   %eax
80102e08:	68 44 75 10 80       	push   $0x80107544
80102e0d:	e8 4e d8 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e12:	e8 49 2a 00 00       	call   80105860 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e17:	e8 d4 08 00 00       	call   801036f0 <mycpu>
80102e1c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e1e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e23:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e2a:	e8 21 0c 00 00       	call   80103a50 <scheduler>
80102e2f:	90                   	nop

80102e30 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102e30:	55                   	push   %ebp
80102e31:	89 e5                	mov    %esp,%ebp
80102e33:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e36:	e8 45 3b 00 00       	call   80106980 <switchkvm>
  seginit();
80102e3b:	e8 40 3a 00 00       	call   80106880 <seginit>
  lapicinit();
80102e40:	e8 9b f7 ff ff       	call   801025e0 <lapicinit>
  mpmain();
80102e45:	e8 a6 ff ff ff       	call   80102df0 <mpmain>
80102e4a:	66 90                	xchg   %ax,%ax
80102e4c:	66 90                	xchg   %ax,%ax
80102e4e:	66 90                	xchg   %ax,%ax

80102e50 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102e50:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102e54:	83 e4 f0             	and    $0xfffffff0,%esp
80102e57:	ff 71 fc             	pushl  -0x4(%ecx)
80102e5a:	55                   	push   %ebp
80102e5b:	89 e5                	mov    %esp,%ebp
80102e5d:	53                   	push   %ebx
80102e5e:	51                   	push   %ecx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102e5f:	bb 80 27 11 80       	mov    $0x80112780,%ebx
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e64:	83 ec 08             	sub    $0x8,%esp
80102e67:	68 00 00 40 80       	push   $0x80400000
80102e6c:	68 a8 57 11 80       	push   $0x801157a8
80102e71:	e8 3a f5 ff ff       	call   801023b0 <kinit1>
  kvmalloc();      // kernel page table
80102e76:	e8 a5 3f 00 00       	call   80106e20 <kvmalloc>
  mpinit();        // detect other processors
80102e7b:	e8 70 01 00 00       	call   80102ff0 <mpinit>
  lapicinit();     // interrupt controller
80102e80:	e8 5b f7 ff ff       	call   801025e0 <lapicinit>
  seginit();       // segment descriptors
80102e85:	e8 f6 39 00 00       	call   80106880 <seginit>
  picinit();       // disable pic
80102e8a:	e8 31 03 00 00       	call   801031c0 <picinit>
  ioapicinit();    // another interrupt controller
80102e8f:	e8 4c f3 ff ff       	call   801021e0 <ioapicinit>
  consoleinit();   // console hardware
80102e94:	e8 07 db ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80102e99:	e8 b2 2c 00 00       	call   80105b50 <uartinit>
  pinit();         // process table
80102e9e:	e8 2d 08 00 00       	call   801036d0 <pinit>
  tvinit();        // trap vectors
80102ea3:	e8 18 29 00 00       	call   801057c0 <tvinit>
  binit();         // buffer cache
80102ea8:	e8 93 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102ead:	e8 9e de ff ff       	call   80100d50 <fileinit>
  ideinit();       // disk 
80102eb2:	e8 09 f1 ff ff       	call   80101fc0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102eb7:	83 c4 0c             	add    $0xc,%esp
80102eba:	68 8a 00 00 00       	push   $0x8a
80102ebf:	68 8c a4 10 80       	push   $0x8010a48c
80102ec4:	68 00 70 00 80       	push   $0x80007000
80102ec9:	e8 82 17 00 00       	call   80104650 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102ece:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102ed5:	00 00 00 
80102ed8:	83 c4 10             	add    $0x10,%esp
80102edb:	05 80 27 11 80       	add    $0x80112780,%eax
80102ee0:	39 d8                	cmp    %ebx,%eax
80102ee2:	76 6f                	jbe    80102f53 <main+0x103>
80102ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102ee8:	e8 03 08 00 00       	call   801036f0 <mycpu>
80102eed:	39 d8                	cmp    %ebx,%eax
80102eef:	74 49                	je     80102f3a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102ef1:	e8 8a f5 ff ff       	call   80102480 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102ef6:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102efb:	c7 05 f8 6f 00 80 30 	movl   $0x80102e30,0x80006ff8
80102f02:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f05:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102f0c:	90 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f0f:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102f14:	0f b6 03             	movzbl (%ebx),%eax
80102f17:	83 ec 08             	sub    $0x8,%esp
80102f1a:	68 00 70 00 00       	push   $0x7000
80102f1f:	50                   	push   %eax
80102f20:	e8 0b f8 ff ff       	call   80102730 <lapicstartap>
80102f25:	83 c4 10             	add    $0x10,%esp
80102f28:	90                   	nop
80102f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f30:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f36:	85 c0                	test   %eax,%eax
80102f38:	74 f6                	je     80102f30 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102f3a:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102f41:	00 00 00 
80102f44:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f4a:	05 80 27 11 80       	add    $0x80112780,%eax
80102f4f:	39 c3                	cmp    %eax,%ebx
80102f51:	72 95                	jb     80102ee8 <main+0x98>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f53:	83 ec 08             	sub    $0x8,%esp
80102f56:	68 00 00 00 8e       	push   $0x8e000000
80102f5b:	68 00 00 40 80       	push   $0x80400000
80102f60:	e8 bb f4 ff ff       	call   80102420 <kinit2>
  userinit();      // first user process
80102f65:	e8 56 08 00 00       	call   801037c0 <userinit>
  mpmain();        // finish this processor's setup
80102f6a:	e8 81 fe ff ff       	call   80102df0 <mpmain>
80102f6f:	90                   	nop

80102f70 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f70:	55                   	push   %ebp
80102f71:	89 e5                	mov    %esp,%ebp
80102f73:	57                   	push   %edi
80102f74:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102f75:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f7b:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
80102f7c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f7f:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102f82:	39 de                	cmp    %ebx,%esi
80102f84:	73 48                	jae    80102fce <mpsearch1+0x5e>
80102f86:	8d 76 00             	lea    0x0(%esi),%esi
80102f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f90:	83 ec 04             	sub    $0x4,%esp
80102f93:	8d 7e 10             	lea    0x10(%esi),%edi
80102f96:	6a 04                	push   $0x4
80102f98:	68 58 75 10 80       	push   $0x80107558
80102f9d:	56                   	push   %esi
80102f9e:	e8 4d 16 00 00       	call   801045f0 <memcmp>
80102fa3:	83 c4 10             	add    $0x10,%esp
80102fa6:	85 c0                	test   %eax,%eax
80102fa8:	75 1e                	jne    80102fc8 <mpsearch1+0x58>
80102faa:	8d 7e 10             	lea    0x10(%esi),%edi
80102fad:	89 f2                	mov    %esi,%edx
80102faf:	31 c9                	xor    %ecx,%ecx
80102fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80102fb8:	0f b6 02             	movzbl (%edx),%eax
80102fbb:	83 c2 01             	add    $0x1,%edx
80102fbe:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102fc0:	39 fa                	cmp    %edi,%edx
80102fc2:	75 f4                	jne    80102fb8 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fc4:	84 c9                	test   %cl,%cl
80102fc6:	74 10                	je     80102fd8 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102fc8:	39 fb                	cmp    %edi,%ebx
80102fca:	89 fe                	mov    %edi,%esi
80102fcc:	77 c2                	ja     80102f90 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
80102fce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80102fd1:	31 c0                	xor    %eax,%eax
}
80102fd3:	5b                   	pop    %ebx
80102fd4:	5e                   	pop    %esi
80102fd5:	5f                   	pop    %edi
80102fd6:	5d                   	pop    %ebp
80102fd7:	c3                   	ret    
80102fd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fdb:	89 f0                	mov    %esi,%eax
80102fdd:	5b                   	pop    %ebx
80102fde:	5e                   	pop    %esi
80102fdf:	5f                   	pop    %edi
80102fe0:	5d                   	pop    %ebp
80102fe1:	c3                   	ret    
80102fe2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ff0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102ff0:	55                   	push   %ebp
80102ff1:	89 e5                	mov    %esp,%ebp
80102ff3:	57                   	push   %edi
80102ff4:	56                   	push   %esi
80102ff5:	53                   	push   %ebx
80102ff6:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102ff9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103000:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103007:	c1 e0 08             	shl    $0x8,%eax
8010300a:	09 d0                	or     %edx,%eax
8010300c:	c1 e0 04             	shl    $0x4,%eax
8010300f:	85 c0                	test   %eax,%eax
80103011:	75 1b                	jne    8010302e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
80103013:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010301a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103021:	c1 e0 08             	shl    $0x8,%eax
80103024:	09 d0                	or     %edx,%eax
80103026:	c1 e0 0a             	shl    $0xa,%eax
80103029:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
8010302e:	ba 00 04 00 00       	mov    $0x400,%edx
80103033:	e8 38 ff ff ff       	call   80102f70 <mpsearch1>
80103038:	85 c0                	test   %eax,%eax
8010303a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010303d:	0f 84 37 01 00 00    	je     8010317a <mpinit+0x18a>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103043:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103046:	8b 58 04             	mov    0x4(%eax),%ebx
80103049:	85 db                	test   %ebx,%ebx
8010304b:	0f 84 43 01 00 00    	je     80103194 <mpinit+0x1a4>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103051:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103057:	83 ec 04             	sub    $0x4,%esp
8010305a:	6a 04                	push   $0x4
8010305c:	68 5d 75 10 80       	push   $0x8010755d
80103061:	56                   	push   %esi
80103062:	e8 89 15 00 00       	call   801045f0 <memcmp>
80103067:	83 c4 10             	add    $0x10,%esp
8010306a:	85 c0                	test   %eax,%eax
8010306c:	0f 85 22 01 00 00    	jne    80103194 <mpinit+0x1a4>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103072:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103079:	3c 01                	cmp    $0x1,%al
8010307b:	74 08                	je     80103085 <mpinit+0x95>
8010307d:	3c 04                	cmp    $0x4,%al
8010307f:	0f 85 0f 01 00 00    	jne    80103194 <mpinit+0x1a4>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103085:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010308c:	85 ff                	test   %edi,%edi
8010308e:	74 21                	je     801030b1 <mpinit+0xc1>
80103090:	31 d2                	xor    %edx,%edx
80103092:	31 c0                	xor    %eax,%eax
80103094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103098:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
8010309f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030a0:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801030a3:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030a5:	39 c7                	cmp    %eax,%edi
801030a7:	75 ef                	jne    80103098 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801030a9:	84 d2                	test   %dl,%dl
801030ab:	0f 85 e3 00 00 00    	jne    80103194 <mpinit+0x1a4>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801030b1:	85 f6                	test   %esi,%esi
801030b3:	0f 84 db 00 00 00    	je     80103194 <mpinit+0x1a4>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801030b9:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801030bf:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030c4:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801030cb:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
801030d1:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030d6:	01 d6                	add    %edx,%esi
801030d8:	90                   	nop
801030d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030e0:	39 c6                	cmp    %eax,%esi
801030e2:	76 23                	jbe    80103107 <mpinit+0x117>
801030e4:	0f b6 10             	movzbl (%eax),%edx
    switch(*p){
801030e7:	80 fa 04             	cmp    $0x4,%dl
801030ea:	0f 87 c0 00 00 00    	ja     801031b0 <mpinit+0x1c0>
801030f0:	ff 24 95 9c 75 10 80 	jmp    *-0x7fef8a64(,%edx,4)
801030f7:	89 f6                	mov    %esi,%esi
801030f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103100:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103103:	39 c6                	cmp    %eax,%esi
80103105:	77 dd                	ja     801030e4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103107:	85 db                	test   %ebx,%ebx
80103109:	0f 84 92 00 00 00    	je     801031a1 <mpinit+0x1b1>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010310f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103112:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103116:	74 15                	je     8010312d <mpinit+0x13d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103118:	ba 22 00 00 00       	mov    $0x22,%edx
8010311d:	b8 70 00 00 00       	mov    $0x70,%eax
80103122:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103123:	ba 23 00 00 00       	mov    $0x23,%edx
80103128:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103129:	83 c8 01             	or     $0x1,%eax
8010312c:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010312d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103130:	5b                   	pop    %ebx
80103131:	5e                   	pop    %esi
80103132:	5f                   	pop    %edi
80103133:	5d                   	pop    %ebp
80103134:	c3                   	ret    
80103135:	8d 76 00             	lea    0x0(%esi),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103138:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
8010313e:	83 f9 07             	cmp    $0x7,%ecx
80103141:	7f 19                	jg     8010315c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103143:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103147:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010314d:	83 c1 01             	add    $0x1,%ecx
80103150:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103156:	88 97 80 27 11 80    	mov    %dl,-0x7feed880(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
8010315c:	83 c0 14             	add    $0x14,%eax
      continue;
8010315f:	e9 7c ff ff ff       	jmp    801030e0 <mpinit+0xf0>
80103164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103168:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010316c:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
8010316f:	88 15 60 27 11 80    	mov    %dl,0x80112760
      p += sizeof(struct mpioapic);
      continue;
80103175:	e9 66 ff ff ff       	jmp    801030e0 <mpinit+0xf0>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010317a:	ba 00 00 01 00       	mov    $0x10000,%edx
8010317f:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103184:	e8 e7 fd ff ff       	call   80102f70 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103189:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010318b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010318e:	0f 85 af fe ff ff    	jne    80103043 <mpinit+0x53>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
80103194:	83 ec 0c             	sub    $0xc,%esp
80103197:	68 62 75 10 80       	push   $0x80107562
8010319c:	e8 cf d1 ff ff       	call   80100370 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
801031a1:	83 ec 0c             	sub    $0xc,%esp
801031a4:	68 7c 75 10 80       	push   $0x8010757c
801031a9:	e8 c2 d1 ff ff       	call   80100370 <panic>
801031ae:	66 90                	xchg   %ax,%ax
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
801031b0:	31 db                	xor    %ebx,%ebx
801031b2:	e9 30 ff ff ff       	jmp    801030e7 <mpinit+0xf7>
801031b7:	66 90                	xchg   %ax,%ax
801031b9:	66 90                	xchg   %ax,%ax
801031bb:	66 90                	xchg   %ax,%ax
801031bd:	66 90                	xchg   %ax,%ax
801031bf:	90                   	nop

801031c0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801031c0:	55                   	push   %ebp
801031c1:	ba 21 00 00 00       	mov    $0x21,%edx
801031c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801031cb:	89 e5                	mov    %esp,%ebp
801031cd:	ee                   	out    %al,(%dx)
801031ce:	ba a1 00 00 00       	mov    $0xa1,%edx
801031d3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801031d4:	5d                   	pop    %ebp
801031d5:	c3                   	ret    
801031d6:	66 90                	xchg   %ax,%ax
801031d8:	66 90                	xchg   %ax,%ax
801031da:	66 90                	xchg   %ax,%ax
801031dc:	66 90                	xchg   %ax,%ax
801031de:	66 90                	xchg   %ax,%ax

801031e0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801031e0:	55                   	push   %ebp
801031e1:	89 e5                	mov    %esp,%ebp
801031e3:	57                   	push   %edi
801031e4:	56                   	push   %esi
801031e5:	53                   	push   %ebx
801031e6:	83 ec 0c             	sub    $0xc,%esp
801031e9:	8b 75 08             	mov    0x8(%ebp),%esi
801031ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801031ef:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801031f5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801031fb:	e8 70 db ff ff       	call   80100d70 <filealloc>
80103200:	85 c0                	test   %eax,%eax
80103202:	89 06                	mov    %eax,(%esi)
80103204:	0f 84 a8 00 00 00    	je     801032b2 <pipealloc+0xd2>
8010320a:	e8 61 db ff ff       	call   80100d70 <filealloc>
8010320f:	85 c0                	test   %eax,%eax
80103211:	89 03                	mov    %eax,(%ebx)
80103213:	0f 84 87 00 00 00    	je     801032a0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103219:	e8 62 f2 ff ff       	call   80102480 <kalloc>
8010321e:	85 c0                	test   %eax,%eax
80103220:	89 c7                	mov    %eax,%edi
80103222:	0f 84 b0 00 00 00    	je     801032d8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103228:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
8010322b:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103232:	00 00 00 
  p->writeopen = 1;
80103235:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010323c:	00 00 00 
  p->nwrite = 0;
8010323f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103246:	00 00 00 
  p->nread = 0;
80103249:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103250:	00 00 00 
  initlock(&p->lock, "pipe");
80103253:	68 b0 75 10 80       	push   $0x801075b0
80103258:	50                   	push   %eax
80103259:	e8 e2 10 00 00       	call   80104340 <initlock>
  (*f0)->type = FD_PIPE;
8010325e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103260:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
80103263:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103269:	8b 06                	mov    (%esi),%eax
8010326b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010326f:	8b 06                	mov    (%esi),%eax
80103271:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103275:	8b 06                	mov    (%esi),%eax
80103277:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010327a:	8b 03                	mov    (%ebx),%eax
8010327c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103282:	8b 03                	mov    (%ebx),%eax
80103284:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103288:	8b 03                	mov    (%ebx),%eax
8010328a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010328e:	8b 03                	mov    (%ebx),%eax
80103290:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103293:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103296:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103298:	5b                   	pop    %ebx
80103299:	5e                   	pop    %esi
8010329a:	5f                   	pop    %edi
8010329b:	5d                   	pop    %ebp
8010329c:	c3                   	ret    
8010329d:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032a0:	8b 06                	mov    (%esi),%eax
801032a2:	85 c0                	test   %eax,%eax
801032a4:	74 1e                	je     801032c4 <pipealloc+0xe4>
    fileclose(*f0);
801032a6:	83 ec 0c             	sub    $0xc,%esp
801032a9:	50                   	push   %eax
801032aa:	e8 81 db ff ff       	call   80100e30 <fileclose>
801032af:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801032b2:	8b 03                	mov    (%ebx),%eax
801032b4:	85 c0                	test   %eax,%eax
801032b6:	74 0c                	je     801032c4 <pipealloc+0xe4>
    fileclose(*f1);
801032b8:	83 ec 0c             	sub    $0xc,%esp
801032bb:	50                   	push   %eax
801032bc:	e8 6f db ff ff       	call   80100e30 <fileclose>
801032c1:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801032c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
801032c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032cc:	5b                   	pop    %ebx
801032cd:	5e                   	pop    %esi
801032ce:	5f                   	pop    %edi
801032cf:	5d                   	pop    %ebp
801032d0:	c3                   	ret    
801032d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032d8:	8b 06                	mov    (%esi),%eax
801032da:	85 c0                	test   %eax,%eax
801032dc:	75 c8                	jne    801032a6 <pipealloc+0xc6>
801032de:	eb d2                	jmp    801032b2 <pipealloc+0xd2>

801032e0 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
801032e0:	55                   	push   %ebp
801032e1:	89 e5                	mov    %esp,%ebp
801032e3:	56                   	push   %esi
801032e4:	53                   	push   %ebx
801032e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801032e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801032eb:	83 ec 0c             	sub    $0xc,%esp
801032ee:	53                   	push   %ebx
801032ef:	e8 ac 11 00 00       	call   801044a0 <acquire>
  if(writable){
801032f4:	83 c4 10             	add    $0x10,%esp
801032f7:	85 f6                	test   %esi,%esi
801032f9:	74 45                	je     80103340 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801032fb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103301:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103304:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010330b:	00 00 00 
    wakeup(&p->nread);
8010330e:	50                   	push   %eax
8010330f:	e8 ec 0b 00 00       	call   80103f00 <wakeup>
80103314:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103317:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010331d:	85 d2                	test   %edx,%edx
8010331f:	75 0a                	jne    8010332b <pipeclose+0x4b>
80103321:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103327:	85 c0                	test   %eax,%eax
80103329:	74 35                	je     80103360 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010332b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010332e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103331:	5b                   	pop    %ebx
80103332:	5e                   	pop    %esi
80103333:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103334:	e9 17 12 00 00       	jmp    80104550 <release>
80103339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
80103340:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103346:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
80103349:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103350:	00 00 00 
    wakeup(&p->nwrite);
80103353:	50                   	push   %eax
80103354:	e8 a7 0b 00 00       	call   80103f00 <wakeup>
80103359:	83 c4 10             	add    $0x10,%esp
8010335c:	eb b9                	jmp    80103317 <pipeclose+0x37>
8010335e:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103360:	83 ec 0c             	sub    $0xc,%esp
80103363:	53                   	push   %ebx
80103364:	e8 e7 11 00 00       	call   80104550 <release>
    kfree((char*)p);
80103369:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010336c:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
8010336f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103372:	5b                   	pop    %ebx
80103373:	5e                   	pop    %esi
80103374:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103375:	e9 56 ef ff ff       	jmp    801022d0 <kfree>
8010337a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103380 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103380:	55                   	push   %ebp
80103381:	89 e5                	mov    %esp,%ebp
80103383:	57                   	push   %edi
80103384:	56                   	push   %esi
80103385:	53                   	push   %ebx
80103386:	83 ec 28             	sub    $0x28,%esp
80103389:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010338c:	53                   	push   %ebx
8010338d:	e8 0e 11 00 00       	call   801044a0 <acquire>
  for(i = 0; i < n; i++){
80103392:	8b 45 10             	mov    0x10(%ebp),%eax
80103395:	83 c4 10             	add    $0x10,%esp
80103398:	85 c0                	test   %eax,%eax
8010339a:	0f 8e b9 00 00 00    	jle    80103459 <pipewrite+0xd9>
801033a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801033a3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801033a9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801033af:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801033b5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801033b8:	03 4d 10             	add    0x10(%ebp),%ecx
801033bb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033be:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801033c4:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801033ca:	39 d0                	cmp    %edx,%eax
801033cc:	74 38                	je     80103406 <pipewrite+0x86>
801033ce:	eb 59                	jmp    80103429 <pipewrite+0xa9>
      if(p->readopen == 0 || myproc()->killed){
801033d0:	e8 bb 03 00 00       	call   80103790 <myproc>
801033d5:	8b 48 24             	mov    0x24(%eax),%ecx
801033d8:	85 c9                	test   %ecx,%ecx
801033da:	75 34                	jne    80103410 <pipewrite+0x90>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801033dc:	83 ec 0c             	sub    $0xc,%esp
801033df:	57                   	push   %edi
801033e0:	e8 1b 0b 00 00       	call   80103f00 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801033e5:	58                   	pop    %eax
801033e6:	5a                   	pop    %edx
801033e7:	53                   	push   %ebx
801033e8:	56                   	push   %esi
801033e9:	e8 52 09 00 00       	call   80103d40 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033ee:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801033f4:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801033fa:	83 c4 10             	add    $0x10,%esp
801033fd:	05 00 02 00 00       	add    $0x200,%eax
80103402:	39 c2                	cmp    %eax,%edx
80103404:	75 2a                	jne    80103430 <pipewrite+0xb0>
      if(p->readopen == 0 || myproc()->killed){
80103406:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010340c:	85 c0                	test   %eax,%eax
8010340e:	75 c0                	jne    801033d0 <pipewrite+0x50>
        release(&p->lock);
80103410:	83 ec 0c             	sub    $0xc,%esp
80103413:	53                   	push   %ebx
80103414:	e8 37 11 00 00       	call   80104550 <release>
        return -1;
80103419:	83 c4 10             	add    $0x10,%esp
8010341c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103421:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103424:	5b                   	pop    %ebx
80103425:	5e                   	pop    %esi
80103426:	5f                   	pop    %edi
80103427:	5d                   	pop    %ebp
80103428:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103429:	89 c2                	mov    %eax,%edx
8010342b:	90                   	nop
8010342c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103430:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103433:	8d 42 01             	lea    0x1(%edx),%eax
80103436:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010343a:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103440:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103446:	0f b6 09             	movzbl (%ecx),%ecx
80103449:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
8010344d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103450:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
80103453:	0f 85 65 ff ff ff    	jne    801033be <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103459:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010345f:	83 ec 0c             	sub    $0xc,%esp
80103462:	50                   	push   %eax
80103463:	e8 98 0a 00 00       	call   80103f00 <wakeup>
  release(&p->lock);
80103468:	89 1c 24             	mov    %ebx,(%esp)
8010346b:	e8 e0 10 00 00       	call   80104550 <release>
  return n;
80103470:	83 c4 10             	add    $0x10,%esp
80103473:	8b 45 10             	mov    0x10(%ebp),%eax
80103476:	eb a9                	jmp    80103421 <pipewrite+0xa1>
80103478:	90                   	nop
80103479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103480 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103480:	55                   	push   %ebp
80103481:	89 e5                	mov    %esp,%ebp
80103483:	57                   	push   %edi
80103484:	56                   	push   %esi
80103485:	53                   	push   %ebx
80103486:	83 ec 18             	sub    $0x18,%esp
80103489:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010348c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010348f:	53                   	push   %ebx
80103490:	e8 0b 10 00 00       	call   801044a0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103495:	83 c4 10             	add    $0x10,%esp
80103498:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010349e:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
801034a4:	75 6a                	jne    80103510 <piperead+0x90>
801034a6:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
801034ac:	85 f6                	test   %esi,%esi
801034ae:	0f 84 cc 00 00 00    	je     80103580 <piperead+0x100>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801034b4:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
801034ba:	eb 2d                	jmp    801034e9 <piperead+0x69>
801034bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034c0:	83 ec 08             	sub    $0x8,%esp
801034c3:	53                   	push   %ebx
801034c4:	56                   	push   %esi
801034c5:	e8 76 08 00 00       	call   80103d40 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801034ca:	83 c4 10             	add    $0x10,%esp
801034cd:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801034d3:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
801034d9:	75 35                	jne    80103510 <piperead+0x90>
801034db:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
801034e1:	85 d2                	test   %edx,%edx
801034e3:	0f 84 97 00 00 00    	je     80103580 <piperead+0x100>
    if(myproc()->killed){
801034e9:	e8 a2 02 00 00       	call   80103790 <myproc>
801034ee:	8b 48 24             	mov    0x24(%eax),%ecx
801034f1:	85 c9                	test   %ecx,%ecx
801034f3:	74 cb                	je     801034c0 <piperead+0x40>
      release(&p->lock);
801034f5:	83 ec 0c             	sub    $0xc,%esp
801034f8:	53                   	push   %ebx
801034f9:	e8 52 10 00 00       	call   80104550 <release>
      return -1;
801034fe:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103501:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
80103504:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103509:	5b                   	pop    %ebx
8010350a:	5e                   	pop    %esi
8010350b:	5f                   	pop    %edi
8010350c:	5d                   	pop    %ebp
8010350d:	c3                   	ret    
8010350e:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103510:	8b 45 10             	mov    0x10(%ebp),%eax
80103513:	85 c0                	test   %eax,%eax
80103515:	7e 69                	jle    80103580 <piperead+0x100>
    if(p->nread == p->nwrite)
80103517:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010351d:	31 c9                	xor    %ecx,%ecx
8010351f:	eb 15                	jmp    80103536 <piperead+0xb6>
80103521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103528:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010352e:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
80103534:	74 5a                	je     80103590 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103536:	8d 70 01             	lea    0x1(%eax),%esi
80103539:	25 ff 01 00 00       	and    $0x1ff,%eax
8010353e:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
80103544:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
80103549:	88 04 0f             	mov    %al,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010354c:	83 c1 01             	add    $0x1,%ecx
8010354f:	39 4d 10             	cmp    %ecx,0x10(%ebp)
80103552:	75 d4                	jne    80103528 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103554:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010355a:	83 ec 0c             	sub    $0xc,%esp
8010355d:	50                   	push   %eax
8010355e:	e8 9d 09 00 00       	call   80103f00 <wakeup>
  release(&p->lock);
80103563:	89 1c 24             	mov    %ebx,(%esp)
80103566:	e8 e5 0f 00 00       	call   80104550 <release>
  return i;
8010356b:	8b 45 10             	mov    0x10(%ebp),%eax
8010356e:	83 c4 10             	add    $0x10,%esp
}
80103571:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103574:	5b                   	pop    %ebx
80103575:	5e                   	pop    %esi
80103576:	5f                   	pop    %edi
80103577:	5d                   	pop    %ebp
80103578:	c3                   	ret    
80103579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103580:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
80103587:	eb cb                	jmp    80103554 <piperead+0xd4>
80103589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103590:	89 4d 10             	mov    %ecx,0x10(%ebp)
80103593:	eb bf                	jmp    80103554 <piperead+0xd4>
80103595:	66 90                	xchg   %ax,%ax
80103597:	66 90                	xchg   %ax,%ax
80103599:	66 90                	xchg   %ax,%ax
8010359b:	66 90                	xchg   %ax,%ax
8010359d:	66 90                	xchg   %ax,%ax
8010359f:	90                   	nop

801035a0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801035a0:	55                   	push   %ebp
801035a1:	89 e5                	mov    %esp,%ebp
801035a3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801035a4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801035a9:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801035ac:	68 20 2d 11 80       	push   $0x80112d20
801035b1:	e8 ea 0e 00 00       	call   801044a0 <acquire>
801035b6:	83 c4 10             	add    $0x10,%esp
801035b9:	eb 17                	jmp    801035d2 <allocproc+0x32>
801035bb:	90                   	nop
801035bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801035c0:	81 c3 88 00 00 00    	add    $0x88,%ebx
801035c6:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
801035cc:	0f 84 8e 00 00 00    	je     80103660 <allocproc+0xc0>
    if(p->state == UNUSED)
801035d2:	8b 43 0c             	mov    0xc(%ebx),%eax
801035d5:	85 c0                	test   %eax,%eax
801035d7:	75 e7                	jne    801035c0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801035d9:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  p->ctime = ticks;
  p->rtime = 0;

  release(&ptable.lock);
801035de:	83 ec 0c             	sub    $0xc,%esp

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801035e1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;

  p->ctime = ticks;
  p->rtime = 0;

  release(&ptable.lock);
801035e8:	68 20 2d 11 80       	push   $0x80112d20
found:
  p->state = EMBRYO;
  p->pid = nextpid++;

  p->ctime = ticks;
  p->rtime = 0;
801035ed:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
801035f4:	00 00 00 
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801035f7:	8d 50 01             	lea    0x1(%eax),%edx
801035fa:	89 43 10             	mov    %eax,0x10(%ebx)

  p->ctime = ticks;
801035fd:	a1 a0 57 11 80       	mov    0x801157a0,%eax
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103602:	89 15 04 a0 10 80    	mov    %edx,0x8010a004

  p->ctime = ticks;
80103608:	89 43 7c             	mov    %eax,0x7c(%ebx)
  p->rtime = 0;

  release(&ptable.lock);
8010360b:	e8 40 0f 00 00       	call   80104550 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103610:	e8 6b ee ff ff       	call   80102480 <kalloc>
80103615:	83 c4 10             	add    $0x10,%esp
80103618:	85 c0                	test   %eax,%eax
8010361a:	89 43 08             	mov    %eax,0x8(%ebx)
8010361d:	74 58                	je     80103677 <allocproc+0xd7>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010361f:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103625:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
80103628:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010362d:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
80103630:	c7 40 14 b2 57 10 80 	movl   $0x801057b2,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103637:	6a 14                	push   $0x14
80103639:	6a 00                	push   $0x0
8010363b:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
8010363c:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010363f:	e8 5c 0f 00 00       	call   801045a0 <memset>
  p->context->eip = (uint)forkret;
80103644:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103647:	83 c4 10             	add    $0x10,%esp
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
8010364a:	c7 40 10 80 36 10 80 	movl   $0x80103680,0x10(%eax)

  return p;
80103651:	89 d8                	mov    %ebx,%eax
}
80103653:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103656:	c9                   	leave  
80103657:	c3                   	ret    
80103658:	90                   	nop
80103659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103660:	83 ec 0c             	sub    $0xc,%esp
80103663:	68 20 2d 11 80       	push   $0x80112d20
80103668:	e8 e3 0e 00 00       	call   80104550 <release>
  return 0;
8010366d:	83 c4 10             	add    $0x10,%esp
80103670:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103672:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103675:	c9                   	leave  
80103676:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80103677:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
8010367e:	eb d3                	jmp    80103653 <allocproc+0xb3>

80103680 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103680:	55                   	push   %ebp
80103681:	89 e5                	mov    %esp,%ebp
80103683:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103686:	68 20 2d 11 80       	push   $0x80112d20
8010368b:	e8 c0 0e 00 00       	call   80104550 <release>

  if (first) {
80103690:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103695:	83 c4 10             	add    $0x10,%esp
80103698:	85 c0                	test   %eax,%eax
8010369a:	75 04                	jne    801036a0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010369c:	c9                   	leave  
8010369d:	c3                   	ret    
8010369e:	66 90                	xchg   %ax,%ax
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
801036a0:	83 ec 0c             	sub    $0xc,%esp

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
801036a3:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801036aa:	00 00 00 
    iinit(ROOTDEV);
801036ad:	6a 01                	push   $0x1
801036af:	e8 ac dd ff ff       	call   80101460 <iinit>
    initlog(ROOTDEV);
801036b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801036bb:	e8 e0 f3 ff ff       	call   80102aa0 <initlog>
801036c0:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
801036c3:	c9                   	leave  
801036c4:	c3                   	ret    
801036c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801036d0 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801036d6:	68 b5 75 10 80       	push   $0x801075b5
801036db:	68 20 2d 11 80       	push   $0x80112d20
801036e0:	e8 5b 0c 00 00       	call   80104340 <initlock>
}
801036e5:	83 c4 10             	add    $0x10,%esp
801036e8:	c9                   	leave  
801036e9:	c3                   	ret    
801036ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801036f0 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	56                   	push   %esi
801036f4:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801036f5:	9c                   	pushf  
801036f6:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
801036f7:	f6 c4 02             	test   $0x2,%ah
801036fa:	75 5b                	jne    80103757 <mycpu+0x67>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
801036fc:	e8 df ef ff ff       	call   801026e0 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103701:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
80103707:	85 f6                	test   %esi,%esi
80103709:	7e 3f                	jle    8010374a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010370b:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103712:	39 d0                	cmp    %edx,%eax
80103714:	74 30                	je     80103746 <mycpu+0x56>
80103716:	b9 30 28 11 80       	mov    $0x80112830,%ecx
8010371b:	31 d2                	xor    %edx,%edx
8010371d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103720:	83 c2 01             	add    $0x1,%edx
80103723:	39 f2                	cmp    %esi,%edx
80103725:	74 23                	je     8010374a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103727:	0f b6 19             	movzbl (%ecx),%ebx
8010372a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103730:	39 d8                	cmp    %ebx,%eax
80103732:	75 ec                	jne    80103720 <mycpu+0x30>
      return &cpus[i];
80103734:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
8010373a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010373d:	5b                   	pop    %ebx
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
8010373e:	05 80 27 11 80       	add    $0x80112780,%eax
  }
  panic("unknown apicid\n");
}
80103743:	5e                   	pop    %esi
80103744:	5d                   	pop    %ebp
80103745:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103746:	31 d2                	xor    %edx,%edx
80103748:	eb ea                	jmp    80103734 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
8010374a:	83 ec 0c             	sub    $0xc,%esp
8010374d:	68 bc 75 10 80       	push   $0x801075bc
80103752:	e8 19 cc ff ff       	call   80100370 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
80103757:	83 ec 0c             	sub    $0xc,%esp
8010375a:	68 98 76 10 80       	push   $0x80107698
8010375f:	e8 0c cc ff ff       	call   80100370 <panic>
80103764:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010376a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103770 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
80103770:	55                   	push   %ebp
80103771:	89 e5                	mov    %esp,%ebp
80103773:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103776:	e8 75 ff ff ff       	call   801036f0 <mycpu>
8010377b:	2d 80 27 11 80       	sub    $0x80112780,%eax
}
80103780:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
80103781:	c1 f8 04             	sar    $0x4,%eax
80103784:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010378a:	c3                   	ret    
8010378b:	90                   	nop
8010378c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103790 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	53                   	push   %ebx
80103794:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80103797:	e8 24 0c 00 00       	call   801043c0 <pushcli>
  c = mycpu();
8010379c:	e8 4f ff ff ff       	call   801036f0 <mycpu>
  p = c->proc;
801037a1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801037a7:	e8 54 0c 00 00       	call   80104400 <popcli>
  return p;
}
801037ac:	83 c4 04             	add    $0x4,%esp
801037af:	89 d8                	mov    %ebx,%eax
801037b1:	5b                   	pop    %ebx
801037b2:	5d                   	pop    %ebp
801037b3:	c3                   	ret    
801037b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801037ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801037c0 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801037c0:	55                   	push   %ebp
801037c1:	89 e5                	mov    %esp,%ebp
801037c3:	53                   	push   %ebx
801037c4:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
801037c7:	e8 d4 fd ff ff       	call   801035a0 <allocproc>
801037cc:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
801037ce:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
801037d3:	e8 c8 35 00 00       	call   80106da0 <setupkvm>
801037d8:	85 c0                	test   %eax,%eax
801037da:	89 43 04             	mov    %eax,0x4(%ebx)
801037dd:	0f 84 bd 00 00 00    	je     801038a0 <userinit+0xe0>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801037e3:	83 ec 04             	sub    $0x4,%esp
801037e6:	68 2c 00 00 00       	push   $0x2c
801037eb:	68 60 a4 10 80       	push   $0x8010a460
801037f0:	50                   	push   %eax
801037f1:	e8 ba 32 00 00       	call   80106ab0 <inituvm>
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
801037f6:	83 c4 0c             	add    $0xc,%esp
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
801037f9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801037ff:	6a 4c                	push   $0x4c
80103801:	6a 00                	push   $0x0
80103803:	ff 73 18             	pushl  0x18(%ebx)
80103806:	e8 95 0d 00 00       	call   801045a0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010380b:	8b 43 18             	mov    0x18(%ebx),%eax
8010380e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103813:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103818:	83 c4 0c             	add    $0xc,%esp
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010381b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010381f:	8b 43 18             	mov    0x18(%ebx),%eax
80103822:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103826:	8b 43 18             	mov    0x18(%ebx),%eax
80103829:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010382d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103831:	8b 43 18             	mov    0x18(%ebx),%eax
80103834:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103838:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010383c:	8b 43 18             	mov    0x18(%ebx),%eax
8010383f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103846:	8b 43 18             	mov    0x18(%ebx),%eax
80103849:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103850:	8b 43 18             	mov    0x18(%ebx),%eax
80103853:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
8010385a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010385d:	6a 10                	push   $0x10
8010385f:	68 e5 75 10 80       	push   $0x801075e5
80103864:	50                   	push   %eax
80103865:	e8 36 0f 00 00       	call   801047a0 <safestrcpy>
  p->cwd = namei("/");
8010386a:	c7 04 24 ee 75 10 80 	movl   $0x801075ee,(%esp)
80103871:	e8 3a e6 ff ff       	call   80101eb0 <namei>
80103876:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103879:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103880:	e8 1b 0c 00 00       	call   801044a0 <acquire>

  p->state = RUNNABLE;
80103885:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
8010388c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103893:	e8 b8 0c 00 00       	call   80104550 <release>
}
80103898:	83 c4 10             	add    $0x10,%esp
8010389b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010389e:	c9                   	leave  
8010389f:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
801038a0:	83 ec 0c             	sub    $0xc,%esp
801038a3:	68 cc 75 10 80       	push   $0x801075cc
801038a8:	e8 c3 ca ff ff       	call   80100370 <panic>
801038ad:	8d 76 00             	lea    0x0(%esi),%esi

801038b0 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801038b0:	55                   	push   %ebp
801038b1:	89 e5                	mov    %esp,%ebp
801038b3:	56                   	push   %esi
801038b4:	53                   	push   %ebx
801038b5:	8b 75 08             	mov    0x8(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801038b8:	e8 03 0b 00 00       	call   801043c0 <pushcli>
  c = mycpu();
801038bd:	e8 2e fe ff ff       	call   801036f0 <mycpu>
  p = c->proc;
801038c2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801038c8:	e8 33 0b 00 00       	call   80104400 <popcli>
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
801038cd:	83 fe 00             	cmp    $0x0,%esi
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
801038d0:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
801038d2:	7e 34                	jle    80103908 <growproc+0x58>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801038d4:	83 ec 04             	sub    $0x4,%esp
801038d7:	01 c6                	add    %eax,%esi
801038d9:	56                   	push   %esi
801038da:	50                   	push   %eax
801038db:	ff 73 04             	pushl  0x4(%ebx)
801038de:	e8 0d 33 00 00       	call   80106bf0 <allocuvm>
801038e3:	83 c4 10             	add    $0x10,%esp
801038e6:	85 c0                	test   %eax,%eax
801038e8:	74 36                	je     80103920 <growproc+0x70>
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
801038ea:	83 ec 0c             	sub    $0xc,%esp
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
801038ed:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801038ef:	53                   	push   %ebx
801038f0:	e8 ab 30 00 00       	call   801069a0 <switchuvm>
  return 0;
801038f5:	83 c4 10             	add    $0x10,%esp
801038f8:	31 c0                	xor    %eax,%eax
}
801038fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038fd:	5b                   	pop    %ebx
801038fe:	5e                   	pop    %esi
801038ff:	5d                   	pop    %ebp
80103900:	c3                   	ret    
80103901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103908:	74 e0                	je     801038ea <growproc+0x3a>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010390a:	83 ec 04             	sub    $0x4,%esp
8010390d:	01 c6                	add    %eax,%esi
8010390f:	56                   	push   %esi
80103910:	50                   	push   %eax
80103911:	ff 73 04             	pushl  0x4(%ebx)
80103914:	e8 d7 33 00 00       	call   80106cf0 <deallocuvm>
80103919:	83 c4 10             	add    $0x10,%esp
8010391c:	85 c0                	test   %eax,%eax
8010391e:	75 ca                	jne    801038ea <growproc+0x3a>
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
80103920:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103925:	eb d3                	jmp    801038fa <growproc+0x4a>
80103927:	89 f6                	mov    %esi,%esi
80103929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103930 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103930:	55                   	push   %ebp
80103931:	89 e5                	mov    %esp,%ebp
80103933:	57                   	push   %edi
80103934:	56                   	push   %esi
80103935:	53                   	push   %ebx
80103936:	83 ec 1c             	sub    $0x1c,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103939:	e8 82 0a 00 00       	call   801043c0 <pushcli>
  c = mycpu();
8010393e:	e8 ad fd ff ff       	call   801036f0 <mycpu>
  p = c->proc;
80103943:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103949:	e8 b2 0a 00 00       	call   80104400 <popcli>
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
8010394e:	e8 4d fc ff ff       	call   801035a0 <allocproc>
80103953:	85 c0                	test   %eax,%eax
80103955:	89 c7                	mov    %eax,%edi
80103957:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010395a:	0f 84 b5 00 00 00    	je     80103a15 <fork+0xe5>
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103960:	83 ec 08             	sub    $0x8,%esp
80103963:	ff 33                	pushl  (%ebx)
80103965:	ff 73 04             	pushl  0x4(%ebx)
80103968:	e8 03 35 00 00       	call   80106e70 <copyuvm>
8010396d:	83 c4 10             	add    $0x10,%esp
80103970:	85 c0                	test   %eax,%eax
80103972:	89 47 04             	mov    %eax,0x4(%edi)
80103975:	0f 84 a1 00 00 00    	je     80103a1c <fork+0xec>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
8010397b:	8b 03                	mov    (%ebx),%eax
8010397d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103980:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103982:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103985:	89 c8                	mov    %ecx,%eax
80103987:	8b 79 18             	mov    0x18(%ecx),%edi
8010398a:	8b 73 18             	mov    0x18(%ebx),%esi
8010398d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103992:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103994:	31 f6                	xor    %esi,%esi
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103996:	8b 40 18             	mov    0x18(%eax),%eax
80103999:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
801039a0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801039a4:	85 c0                	test   %eax,%eax
801039a6:	74 13                	je     801039bb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
801039a8:	83 ec 0c             	sub    $0xc,%esp
801039ab:	50                   	push   %eax
801039ac:	e8 2f d4 ff ff       	call   80100de0 <filedup>
801039b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801039b4:	83 c4 10             	add    $0x10,%esp
801039b7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801039bb:	83 c6 01             	add    $0x1,%esi
801039be:	83 fe 10             	cmp    $0x10,%esi
801039c1:	75 dd                	jne    801039a0 <fork+0x70>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
801039c3:	83 ec 0c             	sub    $0xc,%esp
801039c6:	ff 73 68             	pushl  0x68(%ebx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801039c9:	83 c3 6c             	add    $0x6c,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
801039cc:	e8 5f dc ff ff       	call   80101630 <idup>
801039d1:	8b 7d e4             	mov    -0x1c(%ebp),%edi

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801039d4:	83 c4 0c             	add    $0xc,%esp
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
801039d7:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801039da:	8d 47 6c             	lea    0x6c(%edi),%eax
801039dd:	6a 10                	push   $0x10
801039df:	53                   	push   %ebx
801039e0:	50                   	push   %eax
801039e1:	e8 ba 0d 00 00       	call   801047a0 <safestrcpy>

  pid = np->pid;
801039e6:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
801039e9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039f0:	e8 ab 0a 00 00       	call   801044a0 <acquire>

  np->state = RUNNABLE;
801039f5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
801039fc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a03:	e8 48 0b 00 00       	call   80104550 <release>

  return pid;
80103a08:	83 c4 10             	add    $0x10,%esp
80103a0b:	89 d8                	mov    %ebx,%eax
}
80103a0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a10:	5b                   	pop    %ebx
80103a11:	5e                   	pop    %esi
80103a12:	5f                   	pop    %edi
80103a13:	5d                   	pop    %ebp
80103a14:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103a15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a1a:	eb f1                	jmp    80103a0d <fork+0xdd>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
80103a1c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103a1f:	83 ec 0c             	sub    $0xc,%esp
80103a22:	ff 77 08             	pushl  0x8(%edi)
80103a25:	e8 a6 e8 ff ff       	call   801022d0 <kfree>
    np->kstack = 0;
80103a2a:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80103a31:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103a38:	83 c4 10             	add    $0x10,%esp
80103a3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a40:	eb cb                	jmp    80103a0d <fork+0xdd>
80103a42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a50 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103a50:	55                   	push   %ebp
80103a51:	89 e5                	mov    %esp,%ebp
80103a53:	57                   	push   %edi
80103a54:	56                   	push   %esi
80103a55:	53                   	push   %ebx
80103a56:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80103a59:	e8 92 fc ff ff       	call   801036f0 <mycpu>
80103a5e:	8d 78 04             	lea    0x4(%eax),%edi
80103a61:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103a63:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103a6a:	00 00 00 
80103a6d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103a70:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103a71:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a74:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103a79:	68 20 2d 11 80       	push   $0x80112d20
80103a7e:	e8 1d 0a 00 00       	call   801044a0 <acquire>
80103a83:	83 c4 10             	add    $0x10,%esp
80103a86:	eb 16                	jmp    80103a9e <scheduler+0x4e>
80103a88:	90                   	nop
80103a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a90:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103a96:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80103a9c:	74 4a                	je     80103ae8 <scheduler+0x98>
      if(p->state != RUNNABLE)
80103a9e:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103aa2:	75 ec                	jne    80103a90 <scheduler+0x40>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103aa4:	83 ec 0c             	sub    $0xc,%esp
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80103aa7:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103aad:	53                   	push   %ebx
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103aae:	81 c3 88 00 00 00    	add    $0x88,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103ab4:	e8 e7 2e 00 00       	call   801069a0 <switchuvm>
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
80103ab9:	58                   	pop    %eax
80103aba:	5a                   	pop    %edx
80103abb:	ff 73 94             	pushl  -0x6c(%ebx)
80103abe:	57                   	push   %edi
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103abf:	c7 43 84 04 00 00 00 	movl   $0x4,-0x7c(%ebx)

      swtch(&(c->scheduler), p->context);
80103ac6:	e8 30 0d 00 00       	call   801047fb <swtch>
      switchkvm();
80103acb:	e8 b0 2e 00 00       	call   80106980 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103ad0:	83 c4 10             	add    $0x10,%esp
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ad3:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103ad9:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103ae0:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ae3:	75 b9                	jne    80103a9e <scheduler+0x4e>
80103ae5:	8d 76 00             	lea    0x0(%esi),%esi

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80103ae8:	83 ec 0c             	sub    $0xc,%esp
80103aeb:	68 20 2d 11 80       	push   $0x80112d20
80103af0:	e8 5b 0a 00 00       	call   80104550 <release>

  }
80103af5:	83 c4 10             	add    $0x10,%esp
80103af8:	e9 73 ff ff ff       	jmp    80103a70 <scheduler+0x20>
80103afd:	8d 76 00             	lea    0x0(%esi),%esi

80103b00 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	56                   	push   %esi
80103b04:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103b05:	e8 b6 08 00 00       	call   801043c0 <pushcli>
  c = mycpu();
80103b0a:	e8 e1 fb ff ff       	call   801036f0 <mycpu>
  p = c->proc;
80103b0f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b15:	e8 e6 08 00 00       	call   80104400 <popcli>
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
80103b1a:	83 ec 0c             	sub    $0xc,%esp
80103b1d:	68 20 2d 11 80       	push   $0x80112d20
80103b22:	e8 49 09 00 00       	call   80104470 <holding>
80103b27:	83 c4 10             	add    $0x10,%esp
80103b2a:	85 c0                	test   %eax,%eax
80103b2c:	74 4f                	je     80103b7d <sched+0x7d>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80103b2e:	e8 bd fb ff ff       	call   801036f0 <mycpu>
80103b33:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103b3a:	75 68                	jne    80103ba4 <sched+0xa4>
    panic("sched locks");
  if(p->state == RUNNING)
80103b3c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103b40:	74 55                	je     80103b97 <sched+0x97>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b42:	9c                   	pushf  
80103b43:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80103b44:	f6 c4 02             	test   $0x2,%ah
80103b47:	75 41                	jne    80103b8a <sched+0x8a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80103b49:	e8 a2 fb ff ff       	call   801036f0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103b4e:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80103b51:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103b57:	e8 94 fb ff ff       	call   801036f0 <mycpu>
80103b5c:	83 ec 08             	sub    $0x8,%esp
80103b5f:	ff 70 04             	pushl  0x4(%eax)
80103b62:	53                   	push   %ebx
80103b63:	e8 93 0c 00 00       	call   801047fb <swtch>
  mycpu()->intena = intena;
80103b68:	e8 83 fb ff ff       	call   801036f0 <mycpu>
}
80103b6d:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
80103b70:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103b76:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b79:	5b                   	pop    %ebx
80103b7a:	5e                   	pop    %esi
80103b7b:	5d                   	pop    %ebp
80103b7c:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103b7d:	83 ec 0c             	sub    $0xc,%esp
80103b80:	68 f0 75 10 80       	push   $0x801075f0
80103b85:	e8 e6 c7 ff ff       	call   80100370 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103b8a:	83 ec 0c             	sub    $0xc,%esp
80103b8d:	68 1c 76 10 80       	push   $0x8010761c
80103b92:	e8 d9 c7 ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103b97:	83 ec 0c             	sub    $0xc,%esp
80103b9a:	68 0e 76 10 80       	push   $0x8010760e
80103b9f:	e8 cc c7 ff ff       	call   80100370 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103ba4:	83 ec 0c             	sub    $0xc,%esp
80103ba7:	68 02 76 10 80       	push   $0x80107602
80103bac:	e8 bf c7 ff ff       	call   80100370 <panic>
80103bb1:	eb 0d                	jmp    80103bc0 <exit>
80103bb3:	90                   	nop
80103bb4:	90                   	nop
80103bb5:	90                   	nop
80103bb6:	90                   	nop
80103bb7:	90                   	nop
80103bb8:	90                   	nop
80103bb9:	90                   	nop
80103bba:	90                   	nop
80103bbb:	90                   	nop
80103bbc:	90                   	nop
80103bbd:	90                   	nop
80103bbe:	90                   	nop
80103bbf:	90                   	nop

80103bc0 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103bc0:	55                   	push   %ebp
80103bc1:	89 e5                	mov    %esp,%ebp
80103bc3:	57                   	push   %edi
80103bc4:	56                   	push   %esi
80103bc5:	53                   	push   %ebx
80103bc6:	83 ec 0c             	sub    $0xc,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103bc9:	e8 f2 07 00 00       	call   801043c0 <pushcli>
  c = mycpu();
80103bce:	e8 1d fb ff ff       	call   801036f0 <mycpu>
  p = c->proc;
80103bd3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103bd9:	e8 22 08 00 00       	call   80104400 <popcli>
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103bde:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103be4:	8d 5e 28             	lea    0x28(%esi),%ebx
80103be7:	8d 7e 68             	lea    0x68(%esi),%edi
80103bea:	0f 84 f1 00 00 00    	je     80103ce1 <exit+0x121>
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80103bf0:	8b 03                	mov    (%ebx),%eax
80103bf2:	85 c0                	test   %eax,%eax
80103bf4:	74 12                	je     80103c08 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103bf6:	83 ec 0c             	sub    $0xc,%esp
80103bf9:	50                   	push   %eax
80103bfa:	e8 31 d2 ff ff       	call   80100e30 <fileclose>
      curproc->ofile[fd] = 0;
80103bff:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103c05:	83 c4 10             	add    $0x10,%esp
80103c08:	83 c3 04             	add    $0x4,%ebx

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103c0b:	39 df                	cmp    %ebx,%edi
80103c0d:	75 e1                	jne    80103bf0 <exit+0x30>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
80103c0f:	e8 2c ef ff ff       	call   80102b40 <begin_op>
  iput(curproc->cwd);
80103c14:	83 ec 0c             	sub    $0xc,%esp
80103c17:	ff 76 68             	pushl  0x68(%esi)
80103c1a:	e8 71 db ff ff       	call   80101790 <iput>
  end_op();
80103c1f:	e8 8c ef ff ff       	call   80102bb0 <end_op>
  curproc->cwd = 0;
80103c24:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)

  acquire(&ptable.lock);
80103c2b:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c32:	e8 69 08 00 00       	call   801044a0 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103c37:	8b 56 14             	mov    0x14(%esi),%edx
80103c3a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c3d:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103c42:	eb 10                	jmp    80103c54 <exit+0x94>
80103c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c48:	05 88 00 00 00       	add    $0x88,%eax
80103c4d:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80103c52:	74 1e                	je     80103c72 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
80103c54:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103c58:	75 ee                	jne    80103c48 <exit+0x88>
80103c5a:	3b 50 20             	cmp    0x20(%eax),%edx
80103c5d:	75 e9                	jne    80103c48 <exit+0x88>
      p->state = RUNNABLE;
80103c5f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c66:	05 88 00 00 00       	add    $0x88,%eax
80103c6b:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80103c70:	75 e2                	jne    80103c54 <exit+0x94>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103c72:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
80103c78:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103c7d:	eb 0f                	jmp    80103c8e <exit+0xce>
80103c7f:	90                   	nop

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c80:	81 c2 88 00 00 00    	add    $0x88,%edx
80103c86:	81 fa 54 4f 11 80    	cmp    $0x80114f54,%edx
80103c8c:	74 3a                	je     80103cc8 <exit+0x108>
    if(p->parent == curproc){
80103c8e:	39 72 14             	cmp    %esi,0x14(%edx)
80103c91:	75 ed                	jne    80103c80 <exit+0xc0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103c93:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103c97:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103c9a:	75 e4                	jne    80103c80 <exit+0xc0>
80103c9c:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103ca1:	eb 11                	jmp    80103cb4 <exit+0xf4>
80103ca3:	90                   	nop
80103ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ca8:	05 88 00 00 00       	add    $0x88,%eax
80103cad:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80103cb2:	74 cc                	je     80103c80 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103cb4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103cb8:	75 ee                	jne    80103ca8 <exit+0xe8>
80103cba:	3b 48 20             	cmp    0x20(%eax),%ecx
80103cbd:	75 e9                	jne    80103ca8 <exit+0xe8>
      p->state = RUNNABLE;
80103cbf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103cc6:	eb e0                	jmp    80103ca8 <exit+0xe8>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80103cc8:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103ccf:	e8 2c fe ff ff       	call   80103b00 <sched>
  panic("zombie exit");
80103cd4:	83 ec 0c             	sub    $0xc,%esp
80103cd7:	68 3d 76 10 80       	push   $0x8010763d
80103cdc:	e8 8f c6 ff ff       	call   80100370 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
80103ce1:	83 ec 0c             	sub    $0xc,%esp
80103ce4:	68 30 76 10 80       	push   $0x80107630
80103ce9:	e8 82 c6 ff ff       	call   80100370 <panic>
80103cee:	66 90                	xchg   %ax,%ax

80103cf0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103cf0:	55                   	push   %ebp
80103cf1:	89 e5                	mov    %esp,%ebp
80103cf3:	53                   	push   %ebx
80103cf4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103cf7:	68 20 2d 11 80       	push   $0x80112d20
80103cfc:	e8 9f 07 00 00       	call   801044a0 <acquire>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103d01:	e8 ba 06 00 00       	call   801043c0 <pushcli>
  c = mycpu();
80103d06:	e8 e5 f9 ff ff       	call   801036f0 <mycpu>
  p = c->proc;
80103d0b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d11:	e8 ea 06 00 00       	call   80104400 <popcli>
// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
80103d16:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103d1d:	e8 de fd ff ff       	call   80103b00 <sched>
  release(&ptable.lock);
80103d22:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d29:	e8 22 08 00 00       	call   80104550 <release>
}
80103d2e:	83 c4 10             	add    $0x10,%esp
80103d31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d34:	c9                   	leave  
80103d35:	c3                   	ret    
80103d36:	8d 76 00             	lea    0x0(%esi),%esi
80103d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d40 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103d40:	55                   	push   %ebp
80103d41:	89 e5                	mov    %esp,%ebp
80103d43:	57                   	push   %edi
80103d44:	56                   	push   %esi
80103d45:	53                   	push   %ebx
80103d46:	83 ec 0c             	sub    $0xc,%esp
80103d49:	8b 7d 08             	mov    0x8(%ebp),%edi
80103d4c:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103d4f:	e8 6c 06 00 00       	call   801043c0 <pushcli>
  c = mycpu();
80103d54:	e8 97 f9 ff ff       	call   801036f0 <mycpu>
  p = c->proc;
80103d59:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d5f:	e8 9c 06 00 00       	call   80104400 <popcli>
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
80103d64:	85 db                	test   %ebx,%ebx
80103d66:	0f 84 87 00 00 00    	je     80103df3 <sleep+0xb3>
    panic("sleep");

  if(lk == 0)
80103d6c:	85 f6                	test   %esi,%esi
80103d6e:	74 76                	je     80103de6 <sleep+0xa6>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103d70:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103d76:	74 50                	je     80103dc8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103d78:	83 ec 0c             	sub    $0xc,%esp
80103d7b:	68 20 2d 11 80       	push   $0x80112d20
80103d80:	e8 1b 07 00 00       	call   801044a0 <acquire>
    release(lk);
80103d85:	89 34 24             	mov    %esi,(%esp)
80103d88:	e8 c3 07 00 00       	call   80104550 <release>
  }
  // Go to sleep.
  p->chan = chan;
80103d8d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103d90:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103d97:	e8 64 fd ff ff       	call   80103b00 <sched>

  // Tidy up.
  p->chan = 0;
80103d9c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103da3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103daa:	e8 a1 07 00 00       	call   80104550 <release>
    acquire(lk);
80103daf:	89 75 08             	mov    %esi,0x8(%ebp)
80103db2:	83 c4 10             	add    $0x10,%esp
  }
}
80103db5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103db8:	5b                   	pop    %ebx
80103db9:	5e                   	pop    %esi
80103dba:	5f                   	pop    %edi
80103dbb:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103dbc:	e9 df 06 00 00       	jmp    801044a0 <acquire>
80103dc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80103dc8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103dcb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103dd2:	e8 29 fd ff ff       	call   80103b00 <sched>

  // Tidy up.
  p->chan = 0;
80103dd7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103dde:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103de1:	5b                   	pop    %ebx
80103de2:	5e                   	pop    %esi
80103de3:	5f                   	pop    %edi
80103de4:	5d                   	pop    %ebp
80103de5:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103de6:	83 ec 0c             	sub    $0xc,%esp
80103de9:	68 4f 76 10 80       	push   $0x8010764f
80103dee:	e8 7d c5 ff ff       	call   80100370 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80103df3:	83 ec 0c             	sub    $0xc,%esp
80103df6:	68 49 76 10 80       	push   $0x80107649
80103dfb:	e8 70 c5 ff ff       	call   80100370 <panic>

80103e00 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103e00:	55                   	push   %ebp
80103e01:	89 e5                	mov    %esp,%ebp
80103e03:	56                   	push   %esi
80103e04:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103e05:	e8 b6 05 00 00       	call   801043c0 <pushcli>
  c = mycpu();
80103e0a:	e8 e1 f8 ff ff       	call   801036f0 <mycpu>
  p = c->proc;
80103e0f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103e15:	e8 e6 05 00 00       	call   80104400 <popcli>
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
80103e1a:	83 ec 0c             	sub    $0xc,%esp
80103e1d:	68 20 2d 11 80       	push   $0x80112d20
80103e22:	e8 79 06 00 00       	call   801044a0 <acquire>
80103e27:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103e2a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e2c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103e31:	eb 13                	jmp    80103e46 <wait+0x46>
80103e33:	90                   	nop
80103e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e38:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103e3e:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80103e44:	74 22                	je     80103e68 <wait+0x68>
      if(p->parent != curproc)
80103e46:	39 73 14             	cmp    %esi,0x14(%ebx)
80103e49:	75 ed                	jne    80103e38 <wait+0x38>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103e4b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103e4f:	74 35                	je     80103e86 <wait+0x86>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e51:	81 c3 88 00 00 00    	add    $0x88,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80103e57:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e5c:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80103e62:	75 e2                	jne    80103e46 <wait+0x46>
80103e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80103e68:	85 c0                	test   %eax,%eax
80103e6a:	74 70                	je     80103edc <wait+0xdc>
80103e6c:	8b 46 24             	mov    0x24(%esi),%eax
80103e6f:	85 c0                	test   %eax,%eax
80103e71:	75 69                	jne    80103edc <wait+0xdc>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103e73:	83 ec 08             	sub    $0x8,%esp
80103e76:	68 20 2d 11 80       	push   $0x80112d20
80103e7b:	56                   	push   %esi
80103e7c:	e8 bf fe ff ff       	call   80103d40 <sleep>
  }
80103e81:	83 c4 10             	add    $0x10,%esp
80103e84:	eb a4                	jmp    80103e2a <wait+0x2a>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103e86:	83 ec 0c             	sub    $0xc,%esp
80103e89:	ff 73 08             	pushl  0x8(%ebx)
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103e8c:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103e8f:	e8 3c e4 ff ff       	call   801022d0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103e94:	5a                   	pop    %edx
80103e95:	ff 73 04             	pushl  0x4(%ebx)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103e98:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103e9f:	e8 7c 2e 00 00       	call   80106d20 <freevm>
        p->pid = 0;
80103ea4:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103eab:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103eb2:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103eb6:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103ebd:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103ec4:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ecb:	e8 80 06 00 00       	call   80104550 <release>
        return pid;
80103ed0:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103ed3:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80103ed6:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103ed8:	5b                   	pop    %ebx
80103ed9:	5e                   	pop    %esi
80103eda:	5d                   	pop    %ebp
80103edb:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
80103edc:	83 ec 0c             	sub    $0xc,%esp
80103edf:	68 20 2d 11 80       	push   $0x80112d20
80103ee4:	e8 67 06 00 00       	call   80104550 <release>
      return -1;
80103ee9:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103eec:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
80103eef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103ef4:	5b                   	pop    %ebx
80103ef5:	5e                   	pop    %esi
80103ef6:	5d                   	pop    %ebp
80103ef7:	c3                   	ret    
80103ef8:	90                   	nop
80103ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f00 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103f00:	55                   	push   %ebp
80103f01:	89 e5                	mov    %esp,%ebp
80103f03:	53                   	push   %ebx
80103f04:	83 ec 10             	sub    $0x10,%esp
80103f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103f0a:	68 20 2d 11 80       	push   $0x80112d20
80103f0f:	e8 8c 05 00 00       	call   801044a0 <acquire>
80103f14:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f17:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103f1c:	eb 0e                	jmp    80103f2c <wakeup+0x2c>
80103f1e:	66 90                	xchg   %ax,%ax
80103f20:	05 88 00 00 00       	add    $0x88,%eax
80103f25:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80103f2a:	74 1e                	je     80103f4a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
80103f2c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f30:	75 ee                	jne    80103f20 <wakeup+0x20>
80103f32:	3b 58 20             	cmp    0x20(%eax),%ebx
80103f35:	75 e9                	jne    80103f20 <wakeup+0x20>
      p->state = RUNNABLE;
80103f37:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f3e:	05 88 00 00 00       	add    $0x88,%eax
80103f43:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80103f48:	75 e2                	jne    80103f2c <wakeup+0x2c>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103f4a:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103f51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f54:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103f55:	e9 f6 05 00 00       	jmp    80104550 <release>
80103f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103f60 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103f60:	55                   	push   %ebp
80103f61:	89 e5                	mov    %esp,%ebp
80103f63:	53                   	push   %ebx
80103f64:	83 ec 10             	sub    $0x10,%esp
80103f67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103f6a:	68 20 2d 11 80       	push   $0x80112d20
80103f6f:	e8 2c 05 00 00       	call   801044a0 <acquire>
80103f74:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f77:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103f7c:	eb 0e                	jmp    80103f8c <kill+0x2c>
80103f7e:	66 90                	xchg   %ax,%ax
80103f80:	05 88 00 00 00       	add    $0x88,%eax
80103f85:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80103f8a:	74 3c                	je     80103fc8 <kill+0x68>
    if(p->pid == pid){
80103f8c:	39 58 10             	cmp    %ebx,0x10(%eax)
80103f8f:	75 ef                	jne    80103f80 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103f91:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80103f95:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103f9c:	74 1a                	je     80103fb8 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103f9e:	83 ec 0c             	sub    $0xc,%esp
80103fa1:	68 20 2d 11 80       	push   $0x80112d20
80103fa6:	e8 a5 05 00 00       	call   80104550 <release>
      return 0;
80103fab:	83 c4 10             	add    $0x10,%esp
80103fae:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103fb0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fb3:	c9                   	leave  
80103fb4:	c3                   	ret    
80103fb5:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80103fb8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103fbf:	eb dd                	jmp    80103f9e <kill+0x3e>
80103fc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80103fc8:	83 ec 0c             	sub    $0xc,%esp
80103fcb:	68 20 2d 11 80       	push   $0x80112d20
80103fd0:	e8 7b 05 00 00       	call   80104550 <release>
  return -1;
80103fd5:	83 c4 10             	add    $0x10,%esp
80103fd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103fdd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fe0:	c9                   	leave  
80103fe1:	c3                   	ret    
80103fe2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ff0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	57                   	push   %edi
80103ff4:	56                   	push   %esi
80103ff5:	53                   	push   %ebx
80103ff6:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103ff9:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
80103ffe:	83 ec 3c             	sub    $0x3c,%esp
80104001:	eb 27                	jmp    8010402a <procdump+0x3a>
80104003:	90                   	nop
80104004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104008:	83 ec 0c             	sub    $0xc,%esp
8010400b:	68 db 79 10 80       	push   $0x801079db
80104010:	e8 4b c6 ff ff       	call   80100660 <cprintf>
80104015:	83 c4 10             	add    $0x10,%esp
80104018:	81 c3 88 00 00 00    	add    $0x88,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010401e:	81 fb c0 4f 11 80    	cmp    $0x80114fc0,%ebx
80104024:	0f 84 7e 00 00 00    	je     801040a8 <procdump+0xb8>
    if(p->state == UNUSED)
8010402a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010402d:	85 c0                	test   %eax,%eax
8010402f:	74 e7                	je     80104018 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104031:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80104034:	ba 60 76 10 80       	mov    $0x80107660,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104039:	77 11                	ja     8010404c <procdump+0x5c>
8010403b:	8b 14 85 c0 76 10 80 	mov    -0x7fef8940(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
80104042:	b8 60 76 10 80       	mov    $0x80107660,%eax
80104047:	85 d2                	test   %edx,%edx
80104049:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010404c:	53                   	push   %ebx
8010404d:	52                   	push   %edx
8010404e:	ff 73 a4             	pushl  -0x5c(%ebx)
80104051:	68 64 76 10 80       	push   $0x80107664
80104056:	e8 05 c6 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010405b:	83 c4 10             	add    $0x10,%esp
8010405e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104062:	75 a4                	jne    80104008 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104064:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104067:	83 ec 08             	sub    $0x8,%esp
8010406a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010406d:	50                   	push   %eax
8010406e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104071:	8b 40 0c             	mov    0xc(%eax),%eax
80104074:	83 c0 08             	add    $0x8,%eax
80104077:	50                   	push   %eax
80104078:	e8 e3 02 00 00       	call   80104360 <getcallerpcs>
8010407d:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104080:	8b 17                	mov    (%edi),%edx
80104082:	85 d2                	test   %edx,%edx
80104084:	74 82                	je     80104008 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104086:	83 ec 08             	sub    $0x8,%esp
80104089:	83 c7 04             	add    $0x4,%edi
8010408c:	52                   	push   %edx
8010408d:	68 a1 70 10 80       	push   $0x801070a1
80104092:	e8 c9 c5 ff ff       	call   80100660 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104097:	83 c4 10             	add    $0x10,%esp
8010409a:	39 f7                	cmp    %esi,%edi
8010409c:	75 e2                	jne    80104080 <procdump+0x90>
8010409e:	e9 65 ff ff ff       	jmp    80104008 <procdump+0x18>
801040a3:	90                   	nop
801040a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
801040a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040ab:	5b                   	pop    %ebx
801040ac:	5e                   	pop    %esi
801040ad:	5f                   	pop    %edi
801040ae:	5d                   	pop    %ebp
801040af:	c3                   	ret    

801040b0 <sys_waitx>:

int
sys_waitx(void)
{
801040b0:	55                   	push   %ebp
801040b1:	89 e5                	mov    %esp,%ebp
801040b3:	56                   	push   %esi
801040b4:	53                   	push   %ebx
  int *wtime,*rtime;
  argptr(0,(void*)&wtime,sizeof(*wtime));
801040b5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  }
}

int
sys_waitx(void)
{
801040b8:	83 ec 14             	sub    $0x14,%esp
  int *wtime,*rtime;
  argptr(0,(void*)&wtime,sizeof(*wtime));
801040bb:	6a 04                	push   $0x4
801040bd:	50                   	push   %eax
801040be:	6a 00                	push   $0x0
801040c0:	e8 3b 08 00 00       	call   80104900 <argptr>
  argptr(1,(void*)&rtime,sizeof(*rtime));
801040c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801040c8:	83 c4 0c             	add    $0xc,%esp
801040cb:	6a 04                	push   $0x4
801040cd:	50                   	push   %eax
801040ce:	6a 01                	push   $0x1
801040d0:	e8 2b 08 00 00       	call   80104900 <argptr>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801040d5:	e8 e6 02 00 00       	call   801043c0 <pushcli>
  c = mycpu();
801040da:	e8 11 f6 ff ff       	call   801036f0 <mycpu>
  p = c->proc;
801040df:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801040e5:	e8 16 03 00 00       	call   80104400 <popcli>

  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();

  acquire(&ptable.lock);
801040ea:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801040f1:	e8 aa 03 00 00       	call   801044a0 <acquire>
801040f6:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
801040f9:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040fb:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80104100:	eb 14                	jmp    80104116 <sys_waitx+0x66>
80104102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104108:	81 c3 88 00 00 00    	add    $0x88,%ebx
8010410e:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80104114:	74 22                	je     80104138 <sys_waitx+0x88>
      if(p->parent != curproc)
80104116:	39 73 14             	cmp    %esi,0x14(%ebx)
80104119:	75 ed                	jne    80104108 <sys_waitx+0x58>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
8010411b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010411f:	74 3d                	je     8010415e <sys_waitx+0xae>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104121:	81 c3 88 00 00 00    	add    $0x88,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80104127:	b8 01 00 00 00       	mov    $0x1,%eax

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010412c:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80104132:	75 e2                	jne    80104116 <sys_waitx+0x66>
80104134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104138:	85 c0                	test   %eax,%eax
8010413a:	0f 84 ae 00 00 00    	je     801041ee <sys_waitx+0x13e>
80104140:	8b 46 24             	mov    0x24(%esi),%eax
80104143:	85 c0                	test   %eax,%eax
80104145:	0f 85 a3 00 00 00    	jne    801041ee <sys_waitx+0x13e>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010414b:	83 ec 08             	sub    $0x8,%esp
8010414e:	68 20 2d 11 80       	push   $0x80112d20
80104153:	56                   	push   %esi
80104154:	e8 e7 fb ff ff       	call   80103d40 <sleep>
  }
80104159:	83 c4 10             	add    $0x10,%esp
8010415c:	eb 9b                	jmp    801040f9 <sys_waitx+0x49>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
8010415e:	83 ec 0c             	sub    $0xc,%esp
80104161:	ff 73 08             	pushl  0x8(%ebx)
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80104164:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104167:	e8 64 e1 ff ff       	call   801022d0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
8010416c:	5a                   	pop    %edx
8010416d:	ff 73 04             	pushl  0x4(%ebx)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80104170:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104177:	e8 a4 2b 00 00       	call   80106d20 <freevm>
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;

        *wtime = p->etime - p->ctime - p->rtime; // Waiting Time = End Time - Creation Time - Run Time
8010417c:	8b 93 80 00 00 00    	mov    0x80(%ebx),%edx
80104182:	2b 53 7c             	sub    0x7c(%ebx),%edx
80104185:	2b 93 84 00 00 00    	sub    0x84(%ebx),%edx
8010418b:	8b 45 f0             	mov    -0x10(%ebp),%eax
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
8010418e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104195:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010419c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801041a0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801041a7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

        *wtime = p->etime - p->ctime - p->rtime; // Waiting Time = End Time - Creation Time - Run Time
801041ae:	89 10                	mov    %edx,(%eax)
        *rtime = p->rtime;                       // Run time
801041b0:	8b 93 84 00 00 00    	mov    0x84(%ebx),%edx
801041b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041b9:	89 10                	mov    %edx,(%eax)

        p->ctime = p->etime = p->rtime = 0; // Reinitialise
801041bb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
801041c2:	00 00 00 
801041c5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
801041cc:	00 00 00 
801041cf:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)

        release(&ptable.lock);
801041d6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801041dd:	e8 6e 03 00 00       	call   80104550 <release>
        return pid;
801041e2:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
801041e5:	8d 65 f8             	lea    -0x8(%ebp),%esp
        *rtime = p->rtime;                       // Run time

        p->ctime = p->etime = p->rtime = 0; // Reinitialise

        release(&ptable.lock);
        return pid;
801041e8:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
801041ea:	5b                   	pop    %ebx
801041eb:	5e                   	pop    %esi
801041ec:	5d                   	pop    %ebp
801041ed:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
801041ee:	83 ec 0c             	sub    $0xc,%esp
801041f1:	68 20 2d 11 80       	push   $0x80112d20
801041f6:	e8 55 03 00 00       	call   80104550 <release>
      return -1;
801041fb:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
801041fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
80104201:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
80104206:	5b                   	pop    %ebx
80104207:	5e                   	pop    %esi
80104208:	5d                   	pop    %ebp
80104209:	c3                   	ret    
8010420a:	66 90                	xchg   %ax,%ax
8010420c:	66 90                	xchg   %ax,%ax
8010420e:	66 90                	xchg   %ax,%ax

80104210 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	53                   	push   %ebx
80104214:	83 ec 0c             	sub    $0xc,%esp
80104217:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010421a:	68 d8 76 10 80       	push   $0x801076d8
8010421f:	8d 43 04             	lea    0x4(%ebx),%eax
80104222:	50                   	push   %eax
80104223:	e8 18 01 00 00       	call   80104340 <initlock>
  lk->name = name;
80104228:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010422b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104231:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
80104234:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010423b:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
8010423e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104241:	c9                   	leave  
80104242:	c3                   	ret    
80104243:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104250 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	56                   	push   %esi
80104254:	53                   	push   %ebx
80104255:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104258:	83 ec 0c             	sub    $0xc,%esp
8010425b:	8d 73 04             	lea    0x4(%ebx),%esi
8010425e:	56                   	push   %esi
8010425f:	e8 3c 02 00 00       	call   801044a0 <acquire>
  while (lk->locked) {
80104264:	8b 13                	mov    (%ebx),%edx
80104266:	83 c4 10             	add    $0x10,%esp
80104269:	85 d2                	test   %edx,%edx
8010426b:	74 16                	je     80104283 <acquiresleep+0x33>
8010426d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104270:	83 ec 08             	sub    $0x8,%esp
80104273:	56                   	push   %esi
80104274:	53                   	push   %ebx
80104275:	e8 c6 fa ff ff       	call   80103d40 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
8010427a:	8b 03                	mov    (%ebx),%eax
8010427c:	83 c4 10             	add    $0x10,%esp
8010427f:	85 c0                	test   %eax,%eax
80104281:	75 ed                	jne    80104270 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104283:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104289:	e8 02 f5 ff ff       	call   80103790 <myproc>
8010428e:	8b 40 10             	mov    0x10(%eax),%eax
80104291:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104294:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104297:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010429a:	5b                   	pop    %ebx
8010429b:	5e                   	pop    %esi
8010429c:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
8010429d:	e9 ae 02 00 00       	jmp    80104550 <release>
801042a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042b0 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
801042b0:	55                   	push   %ebp
801042b1:	89 e5                	mov    %esp,%ebp
801042b3:	56                   	push   %esi
801042b4:	53                   	push   %ebx
801042b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801042b8:	83 ec 0c             	sub    $0xc,%esp
801042bb:	8d 73 04             	lea    0x4(%ebx),%esi
801042be:	56                   	push   %esi
801042bf:	e8 dc 01 00 00       	call   801044a0 <acquire>
  lk->locked = 0;
801042c4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801042ca:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801042d1:	89 1c 24             	mov    %ebx,(%esp)
801042d4:	e8 27 fc ff ff       	call   80103f00 <wakeup>
  release(&lk->lk);
801042d9:	89 75 08             	mov    %esi,0x8(%ebp)
801042dc:	83 c4 10             	add    $0x10,%esp
}
801042df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042e2:	5b                   	pop    %ebx
801042e3:	5e                   	pop    %esi
801042e4:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
801042e5:	e9 66 02 00 00       	jmp    80104550 <release>
801042ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042f0 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	57                   	push   %edi
801042f4:	56                   	push   %esi
801042f5:	53                   	push   %ebx
801042f6:	31 ff                	xor    %edi,%edi
801042f8:	83 ec 18             	sub    $0x18,%esp
801042fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801042fe:	8d 73 04             	lea    0x4(%ebx),%esi
80104301:	56                   	push   %esi
80104302:	e8 99 01 00 00       	call   801044a0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104307:	8b 03                	mov    (%ebx),%eax
80104309:	83 c4 10             	add    $0x10,%esp
8010430c:	85 c0                	test   %eax,%eax
8010430e:	74 13                	je     80104323 <holdingsleep+0x33>
80104310:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104313:	e8 78 f4 ff ff       	call   80103790 <myproc>
80104318:	39 58 10             	cmp    %ebx,0x10(%eax)
8010431b:	0f 94 c0             	sete   %al
8010431e:	0f b6 c0             	movzbl %al,%eax
80104321:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104323:	83 ec 0c             	sub    $0xc,%esp
80104326:	56                   	push   %esi
80104327:	e8 24 02 00 00       	call   80104550 <release>
  return r;
}
8010432c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010432f:	89 f8                	mov    %edi,%eax
80104331:	5b                   	pop    %ebx
80104332:	5e                   	pop    %esi
80104333:	5f                   	pop    %edi
80104334:	5d                   	pop    %ebp
80104335:	c3                   	ret    
80104336:	66 90                	xchg   %ax,%ax
80104338:	66 90                	xchg   %ax,%ax
8010433a:	66 90                	xchg   %ax,%ax
8010433c:	66 90                	xchg   %ax,%ax
8010433e:	66 90                	xchg   %ax,%ax

80104340 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104346:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104349:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010434f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104352:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104359:	5d                   	pop    %ebp
8010435a:	c3                   	ret    
8010435b:	90                   	nop
8010435c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104360 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104364:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104367:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010436a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010436d:	31 c0                	xor    %eax,%eax
8010436f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104370:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104376:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010437c:	77 1a                	ja     80104398 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010437e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104381:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104384:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104387:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104389:	83 f8 0a             	cmp    $0xa,%eax
8010438c:	75 e2                	jne    80104370 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010438e:	5b                   	pop    %ebx
8010438f:	5d                   	pop    %ebp
80104390:	c3                   	ret    
80104391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104398:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010439f:	83 c0 01             	add    $0x1,%eax
801043a2:	83 f8 0a             	cmp    $0xa,%eax
801043a5:	74 e7                	je     8010438e <getcallerpcs+0x2e>
    pcs[i] = 0;
801043a7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801043ae:	83 c0 01             	add    $0x1,%eax
801043b1:	83 f8 0a             	cmp    $0xa,%eax
801043b4:	75 e2                	jne    80104398 <getcallerpcs+0x38>
801043b6:	eb d6                	jmp    8010438e <getcallerpcs+0x2e>
801043b8:	90                   	nop
801043b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801043c0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	53                   	push   %ebx
801043c4:	83 ec 04             	sub    $0x4,%esp
801043c7:	9c                   	pushf  
801043c8:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
801043c9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801043ca:	e8 21 f3 ff ff       	call   801036f0 <mycpu>
801043cf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801043d5:	85 c0                	test   %eax,%eax
801043d7:	75 11                	jne    801043ea <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801043d9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801043df:	e8 0c f3 ff ff       	call   801036f0 <mycpu>
801043e4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801043ea:	e8 01 f3 ff ff       	call   801036f0 <mycpu>
801043ef:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801043f6:	83 c4 04             	add    $0x4,%esp
801043f9:	5b                   	pop    %ebx
801043fa:	5d                   	pop    %ebp
801043fb:	c3                   	ret    
801043fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104400 <popcli>:

void
popcli(void)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104406:	9c                   	pushf  
80104407:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104408:	f6 c4 02             	test   $0x2,%ah
8010440b:	75 52                	jne    8010445f <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010440d:	e8 de f2 ff ff       	call   801036f0 <mycpu>
80104412:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104418:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010441b:	85 d2                	test   %edx,%edx
8010441d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104423:	78 2d                	js     80104452 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104425:	e8 c6 f2 ff ff       	call   801036f0 <mycpu>
8010442a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104430:	85 d2                	test   %edx,%edx
80104432:	74 0c                	je     80104440 <popcli+0x40>
    sti();
}
80104434:	c9                   	leave  
80104435:	c3                   	ret    
80104436:	8d 76 00             	lea    0x0(%esi),%esi
80104439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104440:	e8 ab f2 ff ff       	call   801036f0 <mycpu>
80104445:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010444b:	85 c0                	test   %eax,%eax
8010444d:	74 e5                	je     80104434 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
8010444f:	fb                   	sti    
    sti();
}
80104450:	c9                   	leave  
80104451:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
80104452:	83 ec 0c             	sub    $0xc,%esp
80104455:	68 fa 76 10 80       	push   $0x801076fa
8010445a:	e8 11 bf ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
8010445f:	83 ec 0c             	sub    $0xc,%esp
80104462:	68 e3 76 10 80       	push   $0x801076e3
80104467:	e8 04 bf ff ff       	call   80100370 <panic>
8010446c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104470 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	56                   	push   %esi
80104474:	53                   	push   %ebx
80104475:	8b 75 08             	mov    0x8(%ebp),%esi
80104478:	31 db                	xor    %ebx,%ebx
  int r;
  pushcli();
8010447a:	e8 41 ff ff ff       	call   801043c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010447f:	8b 06                	mov    (%esi),%eax
80104481:	85 c0                	test   %eax,%eax
80104483:	74 10                	je     80104495 <holding+0x25>
80104485:	8b 5e 08             	mov    0x8(%esi),%ebx
80104488:	e8 63 f2 ff ff       	call   801036f0 <mycpu>
8010448d:	39 c3                	cmp    %eax,%ebx
8010448f:	0f 94 c3             	sete   %bl
80104492:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104495:	e8 66 ff ff ff       	call   80104400 <popcli>
  return r;
}
8010449a:	89 d8                	mov    %ebx,%eax
8010449c:	5b                   	pop    %ebx
8010449d:	5e                   	pop    %esi
8010449e:	5d                   	pop    %ebp
8010449f:	c3                   	ret    

801044a0 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	53                   	push   %ebx
801044a4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801044a7:	e8 14 ff ff ff       	call   801043c0 <pushcli>
  if(holding(lk))
801044ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
801044af:	83 ec 0c             	sub    $0xc,%esp
801044b2:	53                   	push   %ebx
801044b3:	e8 b8 ff ff ff       	call   80104470 <holding>
801044b8:	83 c4 10             	add    $0x10,%esp
801044bb:	85 c0                	test   %eax,%eax
801044bd:	0f 85 7d 00 00 00    	jne    80104540 <acquire+0xa0>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801044c3:	ba 01 00 00 00       	mov    $0x1,%edx
801044c8:	eb 09                	jmp    801044d3 <acquire+0x33>
801044ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801044d0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801044d3:	89 d0                	mov    %edx,%eax
801044d5:	f0 87 03             	lock xchg %eax,(%ebx)
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
801044d8:	85 c0                	test   %eax,%eax
801044da:	75 f4                	jne    801044d0 <acquire+0x30>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
801044dc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801044e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801044e4:	e8 07 f2 ff ff       	call   801036f0 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801044e9:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
801044eb:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801044ee:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801044f1:	31 c0                	xor    %eax,%eax
801044f3:	90                   	nop
801044f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801044f8:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801044fe:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104504:	77 1a                	ja     80104520 <acquire+0x80>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104506:	8b 5a 04             	mov    0x4(%edx),%ebx
80104509:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
8010450c:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
8010450f:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104511:	83 f8 0a             	cmp    $0xa,%eax
80104514:	75 e2                	jne    801044f8 <acquire+0x58>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
80104516:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104519:	c9                   	leave  
8010451a:	c3                   	ret    
8010451b:	90                   	nop
8010451c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104520:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104527:	83 c0 01             	add    $0x1,%eax
8010452a:	83 f8 0a             	cmp    $0xa,%eax
8010452d:	74 e7                	je     80104516 <acquire+0x76>
    pcs[i] = 0;
8010452f:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104536:	83 c0 01             	add    $0x1,%eax
80104539:	83 f8 0a             	cmp    $0xa,%eax
8010453c:	75 e2                	jne    80104520 <acquire+0x80>
8010453e:	eb d6                	jmp    80104516 <acquire+0x76>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104540:	83 ec 0c             	sub    $0xc,%esp
80104543:	68 01 77 10 80       	push   $0x80107701
80104548:	e8 23 be ff ff       	call   80100370 <panic>
8010454d:	8d 76 00             	lea    0x0(%esi),%esi

80104550 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	53                   	push   %ebx
80104554:	83 ec 10             	sub    $0x10,%esp
80104557:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010455a:	53                   	push   %ebx
8010455b:	e8 10 ff ff ff       	call   80104470 <holding>
80104560:	83 c4 10             	add    $0x10,%esp
80104563:	85 c0                	test   %eax,%eax
80104565:	74 22                	je     80104589 <release+0x39>
    panic("release");

  lk->pcs[0] = 0;
80104567:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010456e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104575:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010457a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
80104580:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104583:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80104584:	e9 77 fe ff ff       	jmp    80104400 <popcli>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
80104589:	83 ec 0c             	sub    $0xc,%esp
8010458c:	68 09 77 10 80       	push   $0x80107709
80104591:	e8 da bd ff ff       	call   80100370 <panic>
80104596:	66 90                	xchg   %ax,%ax
80104598:	66 90                	xchg   %ax,%ax
8010459a:	66 90                	xchg   %ax,%ax
8010459c:	66 90                	xchg   %ax,%ax
8010459e:	66 90                	xchg   %ax,%ax

801045a0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	57                   	push   %edi
801045a4:	53                   	push   %ebx
801045a5:	8b 55 08             	mov    0x8(%ebp),%edx
801045a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801045ab:	f6 c2 03             	test   $0x3,%dl
801045ae:	75 05                	jne    801045b5 <memset+0x15>
801045b0:	f6 c1 03             	test   $0x3,%cl
801045b3:	74 13                	je     801045c8 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
801045b5:	89 d7                	mov    %edx,%edi
801045b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801045ba:	fc                   	cld    
801045bb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801045bd:	5b                   	pop    %ebx
801045be:	89 d0                	mov    %edx,%eax
801045c0:	5f                   	pop    %edi
801045c1:	5d                   	pop    %ebp
801045c2:	c3                   	ret    
801045c3:	90                   	nop
801045c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
801045c8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
801045cc:	c1 e9 02             	shr    $0x2,%ecx
801045cf:	89 fb                	mov    %edi,%ebx
801045d1:	89 f8                	mov    %edi,%eax
801045d3:	c1 e3 18             	shl    $0x18,%ebx
801045d6:	c1 e0 10             	shl    $0x10,%eax
801045d9:	09 d8                	or     %ebx,%eax
801045db:	09 f8                	or     %edi,%eax
801045dd:	c1 e7 08             	shl    $0x8,%edi
801045e0:	09 f8                	or     %edi,%eax
801045e2:	89 d7                	mov    %edx,%edi
801045e4:	fc                   	cld    
801045e5:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801045e7:	5b                   	pop    %ebx
801045e8:	89 d0                	mov    %edx,%eax
801045ea:	5f                   	pop    %edi
801045eb:	5d                   	pop    %ebp
801045ec:	c3                   	ret    
801045ed:	8d 76 00             	lea    0x0(%esi),%esi

801045f0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	57                   	push   %edi
801045f4:	56                   	push   %esi
801045f5:	8b 45 10             	mov    0x10(%ebp),%eax
801045f8:	53                   	push   %ebx
801045f9:	8b 75 0c             	mov    0xc(%ebp),%esi
801045fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801045ff:	85 c0                	test   %eax,%eax
80104601:	74 29                	je     8010462c <memcmp+0x3c>
    if(*s1 != *s2)
80104603:	0f b6 13             	movzbl (%ebx),%edx
80104606:	0f b6 0e             	movzbl (%esi),%ecx
80104609:	38 d1                	cmp    %dl,%cl
8010460b:	75 2b                	jne    80104638 <memcmp+0x48>
8010460d:	8d 78 ff             	lea    -0x1(%eax),%edi
80104610:	31 c0                	xor    %eax,%eax
80104612:	eb 14                	jmp    80104628 <memcmp+0x38>
80104614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104618:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
8010461d:	83 c0 01             	add    $0x1,%eax
80104620:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104624:	38 ca                	cmp    %cl,%dl
80104626:	75 10                	jne    80104638 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104628:	39 f8                	cmp    %edi,%eax
8010462a:	75 ec                	jne    80104618 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010462c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010462d:	31 c0                	xor    %eax,%eax
}
8010462f:	5e                   	pop    %esi
80104630:	5f                   	pop    %edi
80104631:	5d                   	pop    %ebp
80104632:	c3                   	ret    
80104633:	90                   	nop
80104634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104638:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
8010463b:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
8010463c:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
8010463e:	5e                   	pop    %esi
8010463f:	5f                   	pop    %edi
80104640:	5d                   	pop    %ebp
80104641:	c3                   	ret    
80104642:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104650 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104650:	55                   	push   %ebp
80104651:	89 e5                	mov    %esp,%ebp
80104653:	56                   	push   %esi
80104654:	53                   	push   %ebx
80104655:	8b 45 08             	mov    0x8(%ebp),%eax
80104658:	8b 75 0c             	mov    0xc(%ebp),%esi
8010465b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010465e:	39 c6                	cmp    %eax,%esi
80104660:	73 2e                	jae    80104690 <memmove+0x40>
80104662:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104665:	39 c8                	cmp    %ecx,%eax
80104667:	73 27                	jae    80104690 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
80104669:	85 db                	test   %ebx,%ebx
8010466b:	8d 53 ff             	lea    -0x1(%ebx),%edx
8010466e:	74 17                	je     80104687 <memmove+0x37>
      *--d = *--s;
80104670:	29 d9                	sub    %ebx,%ecx
80104672:	89 cb                	mov    %ecx,%ebx
80104674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104678:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
8010467c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
8010467f:	83 ea 01             	sub    $0x1,%edx
80104682:	83 fa ff             	cmp    $0xffffffff,%edx
80104685:	75 f1                	jne    80104678 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104687:	5b                   	pop    %ebx
80104688:	5e                   	pop    %esi
80104689:	5d                   	pop    %ebp
8010468a:	c3                   	ret    
8010468b:	90                   	nop
8010468c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104690:	31 d2                	xor    %edx,%edx
80104692:	85 db                	test   %ebx,%ebx
80104694:	74 f1                	je     80104687 <memmove+0x37>
80104696:	8d 76 00             	lea    0x0(%esi),%esi
80104699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
801046a0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801046a4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801046a7:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801046aa:	39 d3                	cmp    %edx,%ebx
801046ac:	75 f2                	jne    801046a0 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
801046ae:	5b                   	pop    %ebx
801046af:	5e                   	pop    %esi
801046b0:	5d                   	pop    %ebp
801046b1:	c3                   	ret    
801046b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046c0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801046c3:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801046c4:	eb 8a                	jmp    80104650 <memmove>
801046c6:	8d 76 00             	lea    0x0(%esi),%esi
801046c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046d0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	57                   	push   %edi
801046d4:	56                   	push   %esi
801046d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801046d8:	53                   	push   %ebx
801046d9:	8b 7d 08             	mov    0x8(%ebp),%edi
801046dc:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
801046df:	85 c9                	test   %ecx,%ecx
801046e1:	74 37                	je     8010471a <strncmp+0x4a>
801046e3:	0f b6 17             	movzbl (%edi),%edx
801046e6:	0f b6 1e             	movzbl (%esi),%ebx
801046e9:	84 d2                	test   %dl,%dl
801046eb:	74 3f                	je     8010472c <strncmp+0x5c>
801046ed:	38 d3                	cmp    %dl,%bl
801046ef:	75 3b                	jne    8010472c <strncmp+0x5c>
801046f1:	8d 47 01             	lea    0x1(%edi),%eax
801046f4:	01 cf                	add    %ecx,%edi
801046f6:	eb 1b                	jmp    80104713 <strncmp+0x43>
801046f8:	90                   	nop
801046f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104700:	0f b6 10             	movzbl (%eax),%edx
80104703:	84 d2                	test   %dl,%dl
80104705:	74 21                	je     80104728 <strncmp+0x58>
80104707:	0f b6 19             	movzbl (%ecx),%ebx
8010470a:	83 c0 01             	add    $0x1,%eax
8010470d:	89 ce                	mov    %ecx,%esi
8010470f:	38 da                	cmp    %bl,%dl
80104711:	75 19                	jne    8010472c <strncmp+0x5c>
80104713:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
80104715:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104718:	75 e6                	jne    80104700 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
8010471a:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
8010471b:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
8010471d:	5e                   	pop    %esi
8010471e:	5f                   	pop    %edi
8010471f:	5d                   	pop    %ebp
80104720:	c3                   	ret    
80104721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104728:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010472c:	0f b6 c2             	movzbl %dl,%eax
8010472f:	29 d8                	sub    %ebx,%eax
}
80104731:	5b                   	pop    %ebx
80104732:	5e                   	pop    %esi
80104733:	5f                   	pop    %edi
80104734:	5d                   	pop    %ebp
80104735:	c3                   	ret    
80104736:	8d 76 00             	lea    0x0(%esi),%esi
80104739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104740 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	56                   	push   %esi
80104744:	53                   	push   %ebx
80104745:	8b 45 08             	mov    0x8(%ebp),%eax
80104748:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010474b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010474e:	89 c2                	mov    %eax,%edx
80104750:	eb 19                	jmp    8010476b <strncpy+0x2b>
80104752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104758:	83 c3 01             	add    $0x1,%ebx
8010475b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010475f:	83 c2 01             	add    $0x1,%edx
80104762:	84 c9                	test   %cl,%cl
80104764:	88 4a ff             	mov    %cl,-0x1(%edx)
80104767:	74 09                	je     80104772 <strncpy+0x32>
80104769:	89 f1                	mov    %esi,%ecx
8010476b:	85 c9                	test   %ecx,%ecx
8010476d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104770:	7f e6                	jg     80104758 <strncpy+0x18>
    ;
  while(n-- > 0)
80104772:	31 c9                	xor    %ecx,%ecx
80104774:	85 f6                	test   %esi,%esi
80104776:	7e 17                	jle    8010478f <strncpy+0x4f>
80104778:	90                   	nop
80104779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104780:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104784:	89 f3                	mov    %esi,%ebx
80104786:	83 c1 01             	add    $0x1,%ecx
80104789:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
8010478b:	85 db                	test   %ebx,%ebx
8010478d:	7f f1                	jg     80104780 <strncpy+0x40>
    *s++ = 0;
  return os;
}
8010478f:	5b                   	pop    %ebx
80104790:	5e                   	pop    %esi
80104791:	5d                   	pop    %ebp
80104792:	c3                   	ret    
80104793:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047a0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	56                   	push   %esi
801047a4:	53                   	push   %ebx
801047a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801047a8:	8b 45 08             	mov    0x8(%ebp),%eax
801047ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801047ae:	85 c9                	test   %ecx,%ecx
801047b0:	7e 26                	jle    801047d8 <safestrcpy+0x38>
801047b2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801047b6:	89 c1                	mov    %eax,%ecx
801047b8:	eb 17                	jmp    801047d1 <safestrcpy+0x31>
801047ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801047c0:	83 c2 01             	add    $0x1,%edx
801047c3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801047c7:	83 c1 01             	add    $0x1,%ecx
801047ca:	84 db                	test   %bl,%bl
801047cc:	88 59 ff             	mov    %bl,-0x1(%ecx)
801047cf:	74 04                	je     801047d5 <safestrcpy+0x35>
801047d1:	39 f2                	cmp    %esi,%edx
801047d3:	75 eb                	jne    801047c0 <safestrcpy+0x20>
    ;
  *s = 0;
801047d5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801047d8:	5b                   	pop    %ebx
801047d9:	5e                   	pop    %esi
801047da:	5d                   	pop    %ebp
801047db:	c3                   	ret    
801047dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047e0 <strlen>:

int
strlen(const char *s)
{
801047e0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801047e1:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
801047e3:	89 e5                	mov    %esp,%ebp
801047e5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
801047e8:	80 3a 00             	cmpb   $0x0,(%edx)
801047eb:	74 0c                	je     801047f9 <strlen+0x19>
801047ed:	8d 76 00             	lea    0x0(%esi),%esi
801047f0:	83 c0 01             	add    $0x1,%eax
801047f3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801047f7:	75 f7                	jne    801047f0 <strlen+0x10>
    ;
  return n;
}
801047f9:	5d                   	pop    %ebp
801047fa:	c3                   	ret    

801047fb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801047fb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801047ff:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104803:	55                   	push   %ebp
  pushl %ebx
80104804:	53                   	push   %ebx
  pushl %esi
80104805:	56                   	push   %esi
  pushl %edi
80104806:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104807:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104809:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010480b:	5f                   	pop    %edi
  popl %esi
8010480c:	5e                   	pop    %esi
  popl %ebx
8010480d:	5b                   	pop    %ebx
  popl %ebp
8010480e:	5d                   	pop    %ebp
  ret
8010480f:	c3                   	ret    

80104810 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	53                   	push   %ebx
80104814:	83 ec 04             	sub    $0x4,%esp
80104817:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010481a:	e8 71 ef ff ff       	call   80103790 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010481f:	8b 00                	mov    (%eax),%eax
80104821:	39 d8                	cmp    %ebx,%eax
80104823:	76 1b                	jbe    80104840 <fetchint+0x30>
80104825:	8d 53 04             	lea    0x4(%ebx),%edx
80104828:	39 d0                	cmp    %edx,%eax
8010482a:	72 14                	jb     80104840 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010482c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010482f:	8b 13                	mov    (%ebx),%edx
80104831:	89 10                	mov    %edx,(%eax)
  return 0;
80104833:	31 c0                	xor    %eax,%eax
}
80104835:	83 c4 04             	add    $0x4,%esp
80104838:	5b                   	pop    %ebx
80104839:	5d                   	pop    %ebp
8010483a:	c3                   	ret    
8010483b:	90                   	nop
8010483c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104840:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104845:	eb ee                	jmp    80104835 <fetchint+0x25>
80104847:	89 f6                	mov    %esi,%esi
80104849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104850 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	53                   	push   %ebx
80104854:	83 ec 04             	sub    $0x4,%esp
80104857:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010485a:	e8 31 ef ff ff       	call   80103790 <myproc>

  if(addr >= curproc->sz)
8010485f:	39 18                	cmp    %ebx,(%eax)
80104861:	76 29                	jbe    8010488c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104863:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104866:	89 da                	mov    %ebx,%edx
80104868:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010486a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010486c:	39 c3                	cmp    %eax,%ebx
8010486e:	73 1c                	jae    8010488c <fetchstr+0x3c>
    if(*s == 0)
80104870:	80 3b 00             	cmpb   $0x0,(%ebx)
80104873:	75 10                	jne    80104885 <fetchstr+0x35>
80104875:	eb 29                	jmp    801048a0 <fetchstr+0x50>
80104877:	89 f6                	mov    %esi,%esi
80104879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104880:	80 3a 00             	cmpb   $0x0,(%edx)
80104883:	74 1b                	je     801048a0 <fetchstr+0x50>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80104885:	83 c2 01             	add    $0x1,%edx
80104888:	39 d0                	cmp    %edx,%eax
8010488a:	77 f4                	ja     80104880 <fetchstr+0x30>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
8010488c:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
8010488f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104894:	5b                   	pop    %ebx
80104895:	5d                   	pop    %ebp
80104896:	c3                   	ret    
80104897:	89 f6                	mov    %esi,%esi
80104899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801048a0:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
801048a3:	89 d0                	mov    %edx,%eax
801048a5:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
801048a7:	5b                   	pop    %ebx
801048a8:	5d                   	pop    %ebp
801048a9:	c3                   	ret    
801048aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048b0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	56                   	push   %esi
801048b4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801048b5:	e8 d6 ee ff ff       	call   80103790 <myproc>
801048ba:	8b 40 18             	mov    0x18(%eax),%eax
801048bd:	8b 55 08             	mov    0x8(%ebp),%edx
801048c0:	8b 40 44             	mov    0x44(%eax),%eax
801048c3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();
801048c6:	e8 c5 ee ff ff       	call   80103790 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801048cb:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801048cd:	8d 73 04             	lea    0x4(%ebx),%esi
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801048d0:	39 c6                	cmp    %eax,%esi
801048d2:	73 1c                	jae    801048f0 <argint+0x40>
801048d4:	8d 53 08             	lea    0x8(%ebx),%edx
801048d7:	39 d0                	cmp    %edx,%eax
801048d9:	72 15                	jb     801048f0 <argint+0x40>
    return -1;
  *ip = *(int*)(addr);
801048db:	8b 45 0c             	mov    0xc(%ebp),%eax
801048de:	8b 53 04             	mov    0x4(%ebx),%edx
801048e1:	89 10                	mov    %edx,(%eax)
  return 0;
801048e3:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
801048e5:	5b                   	pop    %ebx
801048e6:	5e                   	pop    %esi
801048e7:	5d                   	pop    %ebp
801048e8:	c3                   	ret    
801048e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
801048f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048f5:	eb ee                	jmp    801048e5 <argint+0x35>
801048f7:	89 f6                	mov    %esi,%esi
801048f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104900 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	56                   	push   %esi
80104904:	53                   	push   %ebx
80104905:	83 ec 10             	sub    $0x10,%esp
80104908:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010490b:	e8 80 ee ff ff       	call   80103790 <myproc>
80104910:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104912:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104915:	83 ec 08             	sub    $0x8,%esp
80104918:	50                   	push   %eax
80104919:	ff 75 08             	pushl  0x8(%ebp)
8010491c:	e8 8f ff ff ff       	call   801048b0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104921:	c1 e8 1f             	shr    $0x1f,%eax
80104924:	83 c4 10             	add    $0x10,%esp
80104927:	84 c0                	test   %al,%al
80104929:	75 2d                	jne    80104958 <argptr+0x58>
8010492b:	89 d8                	mov    %ebx,%eax
8010492d:	c1 e8 1f             	shr    $0x1f,%eax
80104930:	84 c0                	test   %al,%al
80104932:	75 24                	jne    80104958 <argptr+0x58>
80104934:	8b 16                	mov    (%esi),%edx
80104936:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104939:	39 c2                	cmp    %eax,%edx
8010493b:	76 1b                	jbe    80104958 <argptr+0x58>
8010493d:	01 c3                	add    %eax,%ebx
8010493f:	39 da                	cmp    %ebx,%edx
80104941:	72 15                	jb     80104958 <argptr+0x58>
    return -1;
  *pp = (char*)i;
80104943:	8b 55 0c             	mov    0xc(%ebp),%edx
80104946:	89 02                	mov    %eax,(%edx)
  return 0;
80104948:	31 c0                	xor    %eax,%eax
}
8010494a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010494d:	5b                   	pop    %ebx
8010494e:	5e                   	pop    %esi
8010494f:	5d                   	pop    %ebp
80104950:	c3                   	ret    
80104951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
80104958:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010495d:	eb eb                	jmp    8010494a <argptr+0x4a>
8010495f:	90                   	nop

80104960 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104966:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104969:	50                   	push   %eax
8010496a:	ff 75 08             	pushl  0x8(%ebp)
8010496d:	e8 3e ff ff ff       	call   801048b0 <argint>
80104972:	83 c4 10             	add    $0x10,%esp
80104975:	85 c0                	test   %eax,%eax
80104977:	78 17                	js     80104990 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104979:	83 ec 08             	sub    $0x8,%esp
8010497c:	ff 75 0c             	pushl  0xc(%ebp)
8010497f:	ff 75 f4             	pushl  -0xc(%ebp)
80104982:	e8 c9 fe ff ff       	call   80104850 <fetchstr>
80104987:	83 c4 10             	add    $0x10,%esp
}
8010498a:	c9                   	leave  
8010498b:	c3                   	ret    
8010498c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104990:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80104995:	c9                   	leave  
80104996:	c3                   	ret    
80104997:	89 f6                	mov    %esi,%esi
80104999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049a0 <syscall>:
[SYS_waitx]   sys_waitx,
};

void
syscall(void)
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	56                   	push   %esi
801049a4:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
801049a5:	e8 e6 ed ff ff       	call   80103790 <myproc>

  num = curproc->tf->eax;
801049aa:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
801049ad:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801049af:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801049b2:	8d 50 ff             	lea    -0x1(%eax),%edx
801049b5:	83 fa 15             	cmp    $0x15,%edx
801049b8:	77 1e                	ja     801049d8 <syscall+0x38>
801049ba:	8b 14 85 40 77 10 80 	mov    -0x7fef88c0(,%eax,4),%edx
801049c1:	85 d2                	test   %edx,%edx
801049c3:	74 13                	je     801049d8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801049c5:	ff d2                	call   *%edx
801049c7:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801049ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049cd:	5b                   	pop    %ebx
801049ce:	5e                   	pop    %esi
801049cf:	5d                   	pop    %ebp
801049d0:	c3                   	ret    
801049d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801049d8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801049d9:	8d 43 6c             	lea    0x6c(%ebx),%eax

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801049dc:	50                   	push   %eax
801049dd:	ff 73 10             	pushl  0x10(%ebx)
801049e0:	68 11 77 10 80       	push   $0x80107711
801049e5:	e8 76 bc ff ff       	call   80100660 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
801049ea:	8b 43 18             	mov    0x18(%ebx),%eax
801049ed:	83 c4 10             	add    $0x10,%esp
801049f0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801049f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049fa:	5b                   	pop    %ebx
801049fb:	5e                   	pop    %esi
801049fc:	5d                   	pop    %ebp
801049fd:	c3                   	ret    
801049fe:	66 90                	xchg   %ax,%ax

80104a00 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104a00:	55                   	push   %ebp
80104a01:	89 e5                	mov    %esp,%ebp
80104a03:	57                   	push   %edi
80104a04:	56                   	push   %esi
80104a05:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104a06:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104a09:	83 ec 34             	sub    $0x34,%esp
80104a0c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104a0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104a12:	56                   	push   %esi
80104a13:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104a14:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104a17:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104a1a:	e8 b1 d4 ff ff       	call   80101ed0 <nameiparent>
80104a1f:	83 c4 10             	add    $0x10,%esp
80104a22:	85 c0                	test   %eax,%eax
80104a24:	0f 84 f6 00 00 00    	je     80104b20 <create+0x120>
    return 0;
  ilock(dp);
80104a2a:	83 ec 0c             	sub    $0xc,%esp
80104a2d:	89 c7                	mov    %eax,%edi
80104a2f:	50                   	push   %eax
80104a30:	e8 2b cc ff ff       	call   80101660 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104a35:	83 c4 0c             	add    $0xc,%esp
80104a38:	6a 00                	push   $0x0
80104a3a:	56                   	push   %esi
80104a3b:	57                   	push   %edi
80104a3c:	e8 4f d1 ff ff       	call   80101b90 <dirlookup>
80104a41:	83 c4 10             	add    $0x10,%esp
80104a44:	85 c0                	test   %eax,%eax
80104a46:	89 c3                	mov    %eax,%ebx
80104a48:	74 56                	je     80104aa0 <create+0xa0>
    iunlockput(dp);
80104a4a:	83 ec 0c             	sub    $0xc,%esp
80104a4d:	57                   	push   %edi
80104a4e:	e8 9d ce ff ff       	call   801018f0 <iunlockput>
    ilock(ip);
80104a53:	89 1c 24             	mov    %ebx,(%esp)
80104a56:	e8 05 cc ff ff       	call   80101660 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104a5b:	83 c4 10             	add    $0x10,%esp
80104a5e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104a63:	75 1b                	jne    80104a80 <create+0x80>
80104a65:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
80104a6a:	89 d8                	mov    %ebx,%eax
80104a6c:	75 12                	jne    80104a80 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104a6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a71:	5b                   	pop    %ebx
80104a72:	5e                   	pop    %esi
80104a73:	5f                   	pop    %edi
80104a74:	5d                   	pop    %ebp
80104a75:	c3                   	ret    
80104a76:	8d 76 00             	lea    0x0(%esi),%esi
80104a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if((ip = dirlookup(dp, name, 0)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80104a80:	83 ec 0c             	sub    $0xc,%esp
80104a83:	53                   	push   %ebx
80104a84:	e8 67 ce ff ff       	call   801018f0 <iunlockput>
    return 0;
80104a89:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104a8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
80104a8f:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104a91:	5b                   	pop    %ebx
80104a92:	5e                   	pop    %esi
80104a93:	5f                   	pop    %edi
80104a94:	5d                   	pop    %ebp
80104a95:	c3                   	ret    
80104a96:	8d 76 00             	lea    0x0(%esi),%esi
80104a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80104aa0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104aa4:	83 ec 08             	sub    $0x8,%esp
80104aa7:	50                   	push   %eax
80104aa8:	ff 37                	pushl  (%edi)
80104aaa:	e8 41 ca ff ff       	call   801014f0 <ialloc>
80104aaf:	83 c4 10             	add    $0x10,%esp
80104ab2:	85 c0                	test   %eax,%eax
80104ab4:	89 c3                	mov    %eax,%ebx
80104ab6:	0f 84 cc 00 00 00    	je     80104b88 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
80104abc:	83 ec 0c             	sub    $0xc,%esp
80104abf:	50                   	push   %eax
80104ac0:	e8 9b cb ff ff       	call   80101660 <ilock>
  ip->major = major;
80104ac5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104ac9:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
80104acd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104ad1:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80104ad5:	b8 01 00 00 00       	mov    $0x1,%eax
80104ada:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80104ade:	89 1c 24             	mov    %ebx,(%esp)
80104ae1:	e8 ca ca ff ff       	call   801015b0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80104ae6:	83 c4 10             	add    $0x10,%esp
80104ae9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104aee:	74 40                	je     80104b30 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80104af0:	83 ec 04             	sub    $0x4,%esp
80104af3:	ff 73 04             	pushl  0x4(%ebx)
80104af6:	56                   	push   %esi
80104af7:	57                   	push   %edi
80104af8:	e8 f3 d2 ff ff       	call   80101df0 <dirlink>
80104afd:	83 c4 10             	add    $0x10,%esp
80104b00:	85 c0                	test   %eax,%eax
80104b02:	78 77                	js     80104b7b <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
80104b04:	83 ec 0c             	sub    $0xc,%esp
80104b07:	57                   	push   %edi
80104b08:	e8 e3 cd ff ff       	call   801018f0 <iunlockput>

  return ip;
80104b0d:	83 c4 10             	add    $0x10,%esp
}
80104b10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
80104b13:	89 d8                	mov    %ebx,%eax
}
80104b15:	5b                   	pop    %ebx
80104b16:	5e                   	pop    %esi
80104b17:	5f                   	pop    %edi
80104b18:	5d                   	pop    %ebp
80104b19:	c3                   	ret    
80104b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104b20:	31 c0                	xor    %eax,%eax
80104b22:	e9 47 ff ff ff       	jmp    80104a6e <create+0x6e>
80104b27:	89 f6                	mov    %esi,%esi
80104b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104b30:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104b35:	83 ec 0c             	sub    $0xc,%esp
80104b38:	57                   	push   %edi
80104b39:	e8 72 ca ff ff       	call   801015b0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104b3e:	83 c4 0c             	add    $0xc,%esp
80104b41:	ff 73 04             	pushl  0x4(%ebx)
80104b44:	68 b8 77 10 80       	push   $0x801077b8
80104b49:	53                   	push   %ebx
80104b4a:	e8 a1 d2 ff ff       	call   80101df0 <dirlink>
80104b4f:	83 c4 10             	add    $0x10,%esp
80104b52:	85 c0                	test   %eax,%eax
80104b54:	78 18                	js     80104b6e <create+0x16e>
80104b56:	83 ec 04             	sub    $0x4,%esp
80104b59:	ff 77 04             	pushl  0x4(%edi)
80104b5c:	68 b7 77 10 80       	push   $0x801077b7
80104b61:	53                   	push   %ebx
80104b62:	e8 89 d2 ff ff       	call   80101df0 <dirlink>
80104b67:	83 c4 10             	add    $0x10,%esp
80104b6a:	85 c0                	test   %eax,%eax
80104b6c:	79 82                	jns    80104af0 <create+0xf0>
      panic("create dots");
80104b6e:	83 ec 0c             	sub    $0xc,%esp
80104b71:	68 ab 77 10 80       	push   $0x801077ab
80104b76:	e8 f5 b7 ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
80104b7b:	83 ec 0c             	sub    $0xc,%esp
80104b7e:	68 ba 77 10 80       	push   $0x801077ba
80104b83:	e8 e8 b7 ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80104b88:	83 ec 0c             	sub    $0xc,%esp
80104b8b:	68 9c 77 10 80       	push   $0x8010779c
80104b90:	e8 db b7 ff ff       	call   80100370 <panic>
80104b95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ba0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104ba0:	55                   	push   %ebp
80104ba1:	89 e5                	mov    %esp,%ebp
80104ba3:	56                   	push   %esi
80104ba4:	53                   	push   %ebx
80104ba5:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104ba7:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104baa:	89 d3                	mov    %edx,%ebx
80104bac:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104baf:	50                   	push   %eax
80104bb0:	6a 00                	push   $0x0
80104bb2:	e8 f9 fc ff ff       	call   801048b0 <argint>
80104bb7:	83 c4 10             	add    $0x10,%esp
80104bba:	85 c0                	test   %eax,%eax
80104bbc:	78 32                	js     80104bf0 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104bbe:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104bc2:	77 2c                	ja     80104bf0 <argfd.constprop.0+0x50>
80104bc4:	e8 c7 eb ff ff       	call   80103790 <myproc>
80104bc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104bcc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104bd0:	85 c0                	test   %eax,%eax
80104bd2:	74 1c                	je     80104bf0 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
80104bd4:	85 f6                	test   %esi,%esi
80104bd6:	74 02                	je     80104bda <argfd.constprop.0+0x3a>
    *pfd = fd;
80104bd8:	89 16                	mov    %edx,(%esi)
  if(pf)
80104bda:	85 db                	test   %ebx,%ebx
80104bdc:	74 22                	je     80104c00 <argfd.constprop.0+0x60>
    *pf = f;
80104bde:	89 03                	mov    %eax,(%ebx)
  return 0;
80104be0:	31 c0                	xor    %eax,%eax
}
80104be2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104be5:	5b                   	pop    %ebx
80104be6:	5e                   	pop    %esi
80104be7:	5d                   	pop    %ebp
80104be8:	c3                   	ret    
80104be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bf0:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104bf3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
80104bf8:	5b                   	pop    %ebx
80104bf9:	5e                   	pop    %esi
80104bfa:	5d                   	pop    %ebp
80104bfb:	c3                   	ret    
80104bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80104c00:	31 c0                	xor    %eax,%eax
80104c02:	eb de                	jmp    80104be2 <argfd.constprop.0+0x42>
80104c04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104c10 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104c10:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104c11:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104c13:	89 e5                	mov    %esp,%ebp
80104c15:	56                   	push   %esi
80104c16:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104c17:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
80104c1a:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104c1d:	e8 7e ff ff ff       	call   80104ba0 <argfd.constprop.0>
80104c22:	85 c0                	test   %eax,%eax
80104c24:	78 1a                	js     80104c40 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104c26:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
80104c28:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80104c2b:	e8 60 eb ff ff       	call   80103790 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80104c30:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104c34:	85 d2                	test   %edx,%edx
80104c36:	74 18                	je     80104c50 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104c38:	83 c3 01             	add    $0x1,%ebx
80104c3b:	83 fb 10             	cmp    $0x10,%ebx
80104c3e:	75 f0                	jne    80104c30 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104c40:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104c43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104c48:	5b                   	pop    %ebx
80104c49:	5e                   	pop    %esi
80104c4a:	5d                   	pop    %ebp
80104c4b:	c3                   	ret    
80104c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80104c50:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104c54:	83 ec 0c             	sub    $0xc,%esp
80104c57:	ff 75 f4             	pushl  -0xc(%ebp)
80104c5a:	e8 81 c1 ff ff       	call   80100de0 <filedup>
  return fd;
80104c5f:	83 c4 10             	add    $0x10,%esp
}
80104c62:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80104c65:	89 d8                	mov    %ebx,%eax
}
80104c67:	5b                   	pop    %ebx
80104c68:	5e                   	pop    %esi
80104c69:	5d                   	pop    %ebp
80104c6a:	c3                   	ret    
80104c6b:	90                   	nop
80104c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c70 <sys_read>:

int
sys_read(void)
{
80104c70:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c71:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104c73:	89 e5                	mov    %esp,%ebp
80104c75:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c78:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104c7b:	e8 20 ff ff ff       	call   80104ba0 <argfd.constprop.0>
80104c80:	85 c0                	test   %eax,%eax
80104c82:	78 4c                	js     80104cd0 <sys_read+0x60>
80104c84:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c87:	83 ec 08             	sub    $0x8,%esp
80104c8a:	50                   	push   %eax
80104c8b:	6a 02                	push   $0x2
80104c8d:	e8 1e fc ff ff       	call   801048b0 <argint>
80104c92:	83 c4 10             	add    $0x10,%esp
80104c95:	85 c0                	test   %eax,%eax
80104c97:	78 37                	js     80104cd0 <sys_read+0x60>
80104c99:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c9c:	83 ec 04             	sub    $0x4,%esp
80104c9f:	ff 75 f0             	pushl  -0x10(%ebp)
80104ca2:	50                   	push   %eax
80104ca3:	6a 01                	push   $0x1
80104ca5:	e8 56 fc ff ff       	call   80104900 <argptr>
80104caa:	83 c4 10             	add    $0x10,%esp
80104cad:	85 c0                	test   %eax,%eax
80104caf:	78 1f                	js     80104cd0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80104cb1:	83 ec 04             	sub    $0x4,%esp
80104cb4:	ff 75 f0             	pushl  -0x10(%ebp)
80104cb7:	ff 75 f4             	pushl  -0xc(%ebp)
80104cba:	ff 75 ec             	pushl  -0x14(%ebp)
80104cbd:	e8 8e c2 ff ff       	call   80100f50 <fileread>
80104cc2:	83 c4 10             	add    $0x10,%esp
}
80104cc5:	c9                   	leave  
80104cc6:	c3                   	ret    
80104cc7:	89 f6                	mov    %esi,%esi
80104cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104cd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104cd5:	c9                   	leave  
80104cd6:	c3                   	ret    
80104cd7:	89 f6                	mov    %esi,%esi
80104cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ce0 <sys_write>:

int
sys_write(void)
{
80104ce0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ce1:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104ce3:	89 e5                	mov    %esp,%ebp
80104ce5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ce8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104ceb:	e8 b0 fe ff ff       	call   80104ba0 <argfd.constprop.0>
80104cf0:	85 c0                	test   %eax,%eax
80104cf2:	78 4c                	js     80104d40 <sys_write+0x60>
80104cf4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104cf7:	83 ec 08             	sub    $0x8,%esp
80104cfa:	50                   	push   %eax
80104cfb:	6a 02                	push   $0x2
80104cfd:	e8 ae fb ff ff       	call   801048b0 <argint>
80104d02:	83 c4 10             	add    $0x10,%esp
80104d05:	85 c0                	test   %eax,%eax
80104d07:	78 37                	js     80104d40 <sys_write+0x60>
80104d09:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d0c:	83 ec 04             	sub    $0x4,%esp
80104d0f:	ff 75 f0             	pushl  -0x10(%ebp)
80104d12:	50                   	push   %eax
80104d13:	6a 01                	push   $0x1
80104d15:	e8 e6 fb ff ff       	call   80104900 <argptr>
80104d1a:	83 c4 10             	add    $0x10,%esp
80104d1d:	85 c0                	test   %eax,%eax
80104d1f:	78 1f                	js     80104d40 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80104d21:	83 ec 04             	sub    $0x4,%esp
80104d24:	ff 75 f0             	pushl  -0x10(%ebp)
80104d27:	ff 75 f4             	pushl  -0xc(%ebp)
80104d2a:	ff 75 ec             	pushl  -0x14(%ebp)
80104d2d:	e8 ae c2 ff ff       	call   80100fe0 <filewrite>
80104d32:	83 c4 10             	add    $0x10,%esp
}
80104d35:	c9                   	leave  
80104d36:	c3                   	ret    
80104d37:	89 f6                	mov    %esi,%esi
80104d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104d40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104d45:	c9                   	leave  
80104d46:	c3                   	ret    
80104d47:	89 f6                	mov    %esi,%esi
80104d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d50 <sys_close>:

int
sys_close(void)
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104d56:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104d59:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d5c:	e8 3f fe ff ff       	call   80104ba0 <argfd.constprop.0>
80104d61:	85 c0                	test   %eax,%eax
80104d63:	78 2b                	js     80104d90 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80104d65:	e8 26 ea ff ff       	call   80103790 <myproc>
80104d6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104d6d:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
80104d70:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104d77:	00 
  fileclose(f);
80104d78:	ff 75 f4             	pushl  -0xc(%ebp)
80104d7b:	e8 b0 c0 ff ff       	call   80100e30 <fileclose>
  return 0;
80104d80:	83 c4 10             	add    $0x10,%esp
80104d83:	31 c0                	xor    %eax,%eax
}
80104d85:	c9                   	leave  
80104d86:	c3                   	ret    
80104d87:	89 f6                	mov    %esi,%esi
80104d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104d90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104d95:	c9                   	leave  
80104d96:	c3                   	ret    
80104d97:	89 f6                	mov    %esi,%esi
80104d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104da0 <sys_fstat>:

int
sys_fstat(void)
{
80104da0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104da1:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104da3:	89 e5                	mov    %esp,%ebp
80104da5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104da8:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104dab:	e8 f0 fd ff ff       	call   80104ba0 <argfd.constprop.0>
80104db0:	85 c0                	test   %eax,%eax
80104db2:	78 2c                	js     80104de0 <sys_fstat+0x40>
80104db4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104db7:	83 ec 04             	sub    $0x4,%esp
80104dba:	6a 14                	push   $0x14
80104dbc:	50                   	push   %eax
80104dbd:	6a 01                	push   $0x1
80104dbf:	e8 3c fb ff ff       	call   80104900 <argptr>
80104dc4:	83 c4 10             	add    $0x10,%esp
80104dc7:	85 c0                	test   %eax,%eax
80104dc9:	78 15                	js     80104de0 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
80104dcb:	83 ec 08             	sub    $0x8,%esp
80104dce:	ff 75 f4             	pushl  -0xc(%ebp)
80104dd1:	ff 75 f0             	pushl  -0x10(%ebp)
80104dd4:	e8 27 c1 ff ff       	call   80100f00 <filestat>
80104dd9:	83 c4 10             	add    $0x10,%esp
}
80104ddc:	c9                   	leave  
80104ddd:	c3                   	ret    
80104dde:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104de0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104de5:	c9                   	leave  
80104de6:	c3                   	ret    
80104de7:	89 f6                	mov    %esi,%esi
80104de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104df0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104df0:	55                   	push   %ebp
80104df1:	89 e5                	mov    %esp,%ebp
80104df3:	57                   	push   %edi
80104df4:	56                   	push   %esi
80104df5:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104df6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104df9:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104dfc:	50                   	push   %eax
80104dfd:	6a 00                	push   $0x0
80104dff:	e8 5c fb ff ff       	call   80104960 <argstr>
80104e04:	83 c4 10             	add    $0x10,%esp
80104e07:	85 c0                	test   %eax,%eax
80104e09:	0f 88 fb 00 00 00    	js     80104f0a <sys_link+0x11a>
80104e0f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104e12:	83 ec 08             	sub    $0x8,%esp
80104e15:	50                   	push   %eax
80104e16:	6a 01                	push   $0x1
80104e18:	e8 43 fb ff ff       	call   80104960 <argstr>
80104e1d:	83 c4 10             	add    $0x10,%esp
80104e20:	85 c0                	test   %eax,%eax
80104e22:	0f 88 e2 00 00 00    	js     80104f0a <sys_link+0x11a>
    return -1;

  begin_op();
80104e28:	e8 13 dd ff ff       	call   80102b40 <begin_op>
  if((ip = namei(old)) == 0){
80104e2d:	83 ec 0c             	sub    $0xc,%esp
80104e30:	ff 75 d4             	pushl  -0x2c(%ebp)
80104e33:	e8 78 d0 ff ff       	call   80101eb0 <namei>
80104e38:	83 c4 10             	add    $0x10,%esp
80104e3b:	85 c0                	test   %eax,%eax
80104e3d:	89 c3                	mov    %eax,%ebx
80104e3f:	0f 84 f3 00 00 00    	je     80104f38 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80104e45:	83 ec 0c             	sub    $0xc,%esp
80104e48:	50                   	push   %eax
80104e49:	e8 12 c8 ff ff       	call   80101660 <ilock>
  if(ip->type == T_DIR){
80104e4e:	83 c4 10             	add    $0x10,%esp
80104e51:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104e56:	0f 84 c4 00 00 00    	je     80104f20 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104e5c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104e61:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104e64:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104e67:	53                   	push   %ebx
80104e68:	e8 43 c7 ff ff       	call   801015b0 <iupdate>
  iunlock(ip);
80104e6d:	89 1c 24             	mov    %ebx,(%esp)
80104e70:	e8 cb c8 ff ff       	call   80101740 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104e75:	58                   	pop    %eax
80104e76:	5a                   	pop    %edx
80104e77:	57                   	push   %edi
80104e78:	ff 75 d0             	pushl  -0x30(%ebp)
80104e7b:	e8 50 d0 ff ff       	call   80101ed0 <nameiparent>
80104e80:	83 c4 10             	add    $0x10,%esp
80104e83:	85 c0                	test   %eax,%eax
80104e85:	89 c6                	mov    %eax,%esi
80104e87:	74 5b                	je     80104ee4 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80104e89:	83 ec 0c             	sub    $0xc,%esp
80104e8c:	50                   	push   %eax
80104e8d:	e8 ce c7 ff ff       	call   80101660 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104e92:	83 c4 10             	add    $0x10,%esp
80104e95:	8b 03                	mov    (%ebx),%eax
80104e97:	39 06                	cmp    %eax,(%esi)
80104e99:	75 3d                	jne    80104ed8 <sys_link+0xe8>
80104e9b:	83 ec 04             	sub    $0x4,%esp
80104e9e:	ff 73 04             	pushl  0x4(%ebx)
80104ea1:	57                   	push   %edi
80104ea2:	56                   	push   %esi
80104ea3:	e8 48 cf ff ff       	call   80101df0 <dirlink>
80104ea8:	83 c4 10             	add    $0x10,%esp
80104eab:	85 c0                	test   %eax,%eax
80104ead:	78 29                	js     80104ed8 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104eaf:	83 ec 0c             	sub    $0xc,%esp
80104eb2:	56                   	push   %esi
80104eb3:	e8 38 ca ff ff       	call   801018f0 <iunlockput>
  iput(ip);
80104eb8:	89 1c 24             	mov    %ebx,(%esp)
80104ebb:	e8 d0 c8 ff ff       	call   80101790 <iput>

  end_op();
80104ec0:	e8 eb dc ff ff       	call   80102bb0 <end_op>

  return 0;
80104ec5:	83 c4 10             	add    $0x10,%esp
80104ec8:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104eca:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ecd:	5b                   	pop    %ebx
80104ece:	5e                   	pop    %esi
80104ecf:	5f                   	pop    %edi
80104ed0:	5d                   	pop    %ebp
80104ed1:	c3                   	ret    
80104ed2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104ed8:	83 ec 0c             	sub    $0xc,%esp
80104edb:	56                   	push   %esi
80104edc:	e8 0f ca ff ff       	call   801018f0 <iunlockput>
    goto bad;
80104ee1:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80104ee4:	83 ec 0c             	sub    $0xc,%esp
80104ee7:	53                   	push   %ebx
80104ee8:	e8 73 c7 ff ff       	call   80101660 <ilock>
  ip->nlink--;
80104eed:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104ef2:	89 1c 24             	mov    %ebx,(%esp)
80104ef5:	e8 b6 c6 ff ff       	call   801015b0 <iupdate>
  iunlockput(ip);
80104efa:	89 1c 24             	mov    %ebx,(%esp)
80104efd:	e8 ee c9 ff ff       	call   801018f0 <iunlockput>
  end_op();
80104f02:	e8 a9 dc ff ff       	call   80102bb0 <end_op>
  return -1;
80104f07:	83 c4 10             	add    $0x10,%esp
}
80104f0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104f0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f12:	5b                   	pop    %ebx
80104f13:	5e                   	pop    %esi
80104f14:	5f                   	pop    %edi
80104f15:	5d                   	pop    %ebp
80104f16:	c3                   	ret    
80104f17:	89 f6                	mov    %esi,%esi
80104f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80104f20:	83 ec 0c             	sub    $0xc,%esp
80104f23:	53                   	push   %ebx
80104f24:	e8 c7 c9 ff ff       	call   801018f0 <iunlockput>
    end_op();
80104f29:	e8 82 dc ff ff       	call   80102bb0 <end_op>
    return -1;
80104f2e:	83 c4 10             	add    $0x10,%esp
80104f31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f36:	eb 92                	jmp    80104eca <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80104f38:	e8 73 dc ff ff       	call   80102bb0 <end_op>
    return -1;
80104f3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f42:	eb 86                	jmp    80104eca <sys_link+0xda>
80104f44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104f50 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	57                   	push   %edi
80104f54:	56                   	push   %esi
80104f55:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104f56:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104f59:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104f5c:	50                   	push   %eax
80104f5d:	6a 00                	push   $0x0
80104f5f:	e8 fc f9 ff ff       	call   80104960 <argstr>
80104f64:	83 c4 10             	add    $0x10,%esp
80104f67:	85 c0                	test   %eax,%eax
80104f69:	0f 88 82 01 00 00    	js     801050f1 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
80104f6f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80104f72:	e8 c9 db ff ff       	call   80102b40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104f77:	83 ec 08             	sub    $0x8,%esp
80104f7a:	53                   	push   %ebx
80104f7b:	ff 75 c0             	pushl  -0x40(%ebp)
80104f7e:	e8 4d cf ff ff       	call   80101ed0 <nameiparent>
80104f83:	83 c4 10             	add    $0x10,%esp
80104f86:	85 c0                	test   %eax,%eax
80104f88:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104f8b:	0f 84 6a 01 00 00    	je     801050fb <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
80104f91:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104f94:	83 ec 0c             	sub    $0xc,%esp
80104f97:	56                   	push   %esi
80104f98:	e8 c3 c6 ff ff       	call   80101660 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104f9d:	58                   	pop    %eax
80104f9e:	5a                   	pop    %edx
80104f9f:	68 b8 77 10 80       	push   $0x801077b8
80104fa4:	53                   	push   %ebx
80104fa5:	e8 c6 cb ff ff       	call   80101b70 <namecmp>
80104faa:	83 c4 10             	add    $0x10,%esp
80104fad:	85 c0                	test   %eax,%eax
80104faf:	0f 84 fc 00 00 00    	je     801050b1 <sys_unlink+0x161>
80104fb5:	83 ec 08             	sub    $0x8,%esp
80104fb8:	68 b7 77 10 80       	push   $0x801077b7
80104fbd:	53                   	push   %ebx
80104fbe:	e8 ad cb ff ff       	call   80101b70 <namecmp>
80104fc3:	83 c4 10             	add    $0x10,%esp
80104fc6:	85 c0                	test   %eax,%eax
80104fc8:	0f 84 e3 00 00 00    	je     801050b1 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80104fce:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104fd1:	83 ec 04             	sub    $0x4,%esp
80104fd4:	50                   	push   %eax
80104fd5:	53                   	push   %ebx
80104fd6:	56                   	push   %esi
80104fd7:	e8 b4 cb ff ff       	call   80101b90 <dirlookup>
80104fdc:	83 c4 10             	add    $0x10,%esp
80104fdf:	85 c0                	test   %eax,%eax
80104fe1:	89 c3                	mov    %eax,%ebx
80104fe3:	0f 84 c8 00 00 00    	je     801050b1 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
80104fe9:	83 ec 0c             	sub    $0xc,%esp
80104fec:	50                   	push   %eax
80104fed:	e8 6e c6 ff ff       	call   80101660 <ilock>

  if(ip->nlink < 1)
80104ff2:	83 c4 10             	add    $0x10,%esp
80104ff5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104ffa:	0f 8e 24 01 00 00    	jle    80105124 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80105000:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105005:	8d 75 d8             	lea    -0x28(%ebp),%esi
80105008:	74 66                	je     80105070 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
8010500a:	83 ec 04             	sub    $0x4,%esp
8010500d:	6a 10                	push   $0x10
8010500f:	6a 00                	push   $0x0
80105011:	56                   	push   %esi
80105012:	e8 89 f5 ff ff       	call   801045a0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105017:	6a 10                	push   $0x10
80105019:	ff 75 c4             	pushl  -0x3c(%ebp)
8010501c:	56                   	push   %esi
8010501d:	ff 75 b4             	pushl  -0x4c(%ebp)
80105020:	e8 1b ca ff ff       	call   80101a40 <writei>
80105025:	83 c4 20             	add    $0x20,%esp
80105028:	83 f8 10             	cmp    $0x10,%eax
8010502b:	0f 85 e6 00 00 00    	jne    80105117 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80105031:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105036:	0f 84 9c 00 00 00    	je     801050d8 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
8010503c:	83 ec 0c             	sub    $0xc,%esp
8010503f:	ff 75 b4             	pushl  -0x4c(%ebp)
80105042:	e8 a9 c8 ff ff       	call   801018f0 <iunlockput>

  ip->nlink--;
80105047:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010504c:	89 1c 24             	mov    %ebx,(%esp)
8010504f:	e8 5c c5 ff ff       	call   801015b0 <iupdate>
  iunlockput(ip);
80105054:	89 1c 24             	mov    %ebx,(%esp)
80105057:	e8 94 c8 ff ff       	call   801018f0 <iunlockput>

  end_op();
8010505c:	e8 4f db ff ff       	call   80102bb0 <end_op>

  return 0;
80105061:	83 c4 10             	add    $0x10,%esp
80105064:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80105066:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105069:	5b                   	pop    %ebx
8010506a:	5e                   	pop    %esi
8010506b:	5f                   	pop    %edi
8010506c:	5d                   	pop    %ebp
8010506d:	c3                   	ret    
8010506e:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105070:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105074:	76 94                	jbe    8010500a <sys_unlink+0xba>
80105076:	bf 20 00 00 00       	mov    $0x20,%edi
8010507b:	eb 0f                	jmp    8010508c <sys_unlink+0x13c>
8010507d:	8d 76 00             	lea    0x0(%esi),%esi
80105080:	83 c7 10             	add    $0x10,%edi
80105083:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105086:	0f 83 7e ff ff ff    	jae    8010500a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010508c:	6a 10                	push   $0x10
8010508e:	57                   	push   %edi
8010508f:	56                   	push   %esi
80105090:	53                   	push   %ebx
80105091:	e8 aa c8 ff ff       	call   80101940 <readi>
80105096:	83 c4 10             	add    $0x10,%esp
80105099:	83 f8 10             	cmp    $0x10,%eax
8010509c:	75 6c                	jne    8010510a <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010509e:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801050a3:	74 db                	je     80105080 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
801050a5:	83 ec 0c             	sub    $0xc,%esp
801050a8:	53                   	push   %ebx
801050a9:	e8 42 c8 ff ff       	call   801018f0 <iunlockput>
    goto bad;
801050ae:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
801050b1:	83 ec 0c             	sub    $0xc,%esp
801050b4:	ff 75 b4             	pushl  -0x4c(%ebp)
801050b7:	e8 34 c8 ff ff       	call   801018f0 <iunlockput>
  end_op();
801050bc:	e8 ef da ff ff       	call   80102bb0 <end_op>
  return -1;
801050c1:	83 c4 10             	add    $0x10,%esp
}
801050c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
801050c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050cc:	5b                   	pop    %ebx
801050cd:	5e                   	pop    %esi
801050ce:	5f                   	pop    %edi
801050cf:	5d                   	pop    %ebp
801050d0:	c3                   	ret    
801050d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
801050d8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801050db:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
801050de:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801050e3:	50                   	push   %eax
801050e4:	e8 c7 c4 ff ff       	call   801015b0 <iupdate>
801050e9:	83 c4 10             	add    $0x10,%esp
801050ec:	e9 4b ff ff ff       	jmp    8010503c <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
801050f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050f6:	e9 6b ff ff ff       	jmp    80105066 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
801050fb:	e8 b0 da ff ff       	call   80102bb0 <end_op>
    return -1;
80105100:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105105:	e9 5c ff ff ff       	jmp    80105066 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
8010510a:	83 ec 0c             	sub    $0xc,%esp
8010510d:	68 dc 77 10 80       	push   $0x801077dc
80105112:	e8 59 b2 ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80105117:	83 ec 0c             	sub    $0xc,%esp
8010511a:	68 ee 77 10 80       	push   $0x801077ee
8010511f:	e8 4c b2 ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80105124:	83 ec 0c             	sub    $0xc,%esp
80105127:	68 ca 77 10 80       	push   $0x801077ca
8010512c:	e8 3f b2 ff ff       	call   80100370 <panic>
80105131:	eb 0d                	jmp    80105140 <sys_open>
80105133:	90                   	nop
80105134:	90                   	nop
80105135:	90                   	nop
80105136:	90                   	nop
80105137:	90                   	nop
80105138:	90                   	nop
80105139:	90                   	nop
8010513a:	90                   	nop
8010513b:	90                   	nop
8010513c:	90                   	nop
8010513d:	90                   	nop
8010513e:	90                   	nop
8010513f:	90                   	nop

80105140 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80105140:	55                   	push   %ebp
80105141:	89 e5                	mov    %esp,%ebp
80105143:	57                   	push   %edi
80105144:	56                   	push   %esi
80105145:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105146:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
80105149:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010514c:	50                   	push   %eax
8010514d:	6a 00                	push   $0x0
8010514f:	e8 0c f8 ff ff       	call   80104960 <argstr>
80105154:	83 c4 10             	add    $0x10,%esp
80105157:	85 c0                	test   %eax,%eax
80105159:	0f 88 9e 00 00 00    	js     801051fd <sys_open+0xbd>
8010515f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105162:	83 ec 08             	sub    $0x8,%esp
80105165:	50                   	push   %eax
80105166:	6a 01                	push   $0x1
80105168:	e8 43 f7 ff ff       	call   801048b0 <argint>
8010516d:	83 c4 10             	add    $0x10,%esp
80105170:	85 c0                	test   %eax,%eax
80105172:	0f 88 85 00 00 00    	js     801051fd <sys_open+0xbd>
    return -1;

  begin_op();
80105178:	e8 c3 d9 ff ff       	call   80102b40 <begin_op>

  if(omode & O_CREATE){
8010517d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105181:	0f 85 89 00 00 00    	jne    80105210 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105187:	83 ec 0c             	sub    $0xc,%esp
8010518a:	ff 75 e0             	pushl  -0x20(%ebp)
8010518d:	e8 1e cd ff ff       	call   80101eb0 <namei>
80105192:	83 c4 10             	add    $0x10,%esp
80105195:	85 c0                	test   %eax,%eax
80105197:	89 c6                	mov    %eax,%esi
80105199:	0f 84 8e 00 00 00    	je     8010522d <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
8010519f:	83 ec 0c             	sub    $0xc,%esp
801051a2:	50                   	push   %eax
801051a3:	e8 b8 c4 ff ff       	call   80101660 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801051a8:	83 c4 10             	add    $0x10,%esp
801051ab:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801051b0:	0f 84 d2 00 00 00    	je     80105288 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801051b6:	e8 b5 bb ff ff       	call   80100d70 <filealloc>
801051bb:	85 c0                	test   %eax,%eax
801051bd:	89 c7                	mov    %eax,%edi
801051bf:	74 2b                	je     801051ec <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801051c1:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
801051c3:	e8 c8 e5 ff ff       	call   80103790 <myproc>
801051c8:	90                   	nop
801051c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
801051d0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801051d4:	85 d2                	test   %edx,%edx
801051d6:	74 68                	je     80105240 <sys_open+0x100>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801051d8:	83 c3 01             	add    $0x1,%ebx
801051db:	83 fb 10             	cmp    $0x10,%ebx
801051de:	75 f0                	jne    801051d0 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
801051e0:	83 ec 0c             	sub    $0xc,%esp
801051e3:	57                   	push   %edi
801051e4:	e8 47 bc ff ff       	call   80100e30 <fileclose>
801051e9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801051ec:	83 ec 0c             	sub    $0xc,%esp
801051ef:	56                   	push   %esi
801051f0:	e8 fb c6 ff ff       	call   801018f0 <iunlockput>
    end_op();
801051f5:	e8 b6 d9 ff ff       	call   80102bb0 <end_op>
    return -1;
801051fa:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801051fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80105200:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80105205:	5b                   	pop    %ebx
80105206:	5e                   	pop    %esi
80105207:	5f                   	pop    %edi
80105208:	5d                   	pop    %ebp
80105209:	c3                   	ret    
8010520a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105210:	83 ec 0c             	sub    $0xc,%esp
80105213:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105216:	31 c9                	xor    %ecx,%ecx
80105218:	6a 00                	push   $0x0
8010521a:	ba 02 00 00 00       	mov    $0x2,%edx
8010521f:	e8 dc f7 ff ff       	call   80104a00 <create>
    if(ip == 0){
80105224:	83 c4 10             	add    $0x10,%esp
80105227:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105229:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010522b:	75 89                	jne    801051b6 <sys_open+0x76>
      end_op();
8010522d:	e8 7e d9 ff ff       	call   80102bb0 <end_op>
      return -1;
80105232:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105237:	eb 43                	jmp    8010527c <sys_open+0x13c>
80105239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105240:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105243:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105247:	56                   	push   %esi
80105248:	e8 f3 c4 ff ff       	call   80101740 <iunlock>
  end_op();
8010524d:	e8 5e d9 ff ff       	call   80102bb0 <end_op>

  f->type = FD_INODE;
80105252:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105258:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010525b:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
8010525e:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105261:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105268:	89 d0                	mov    %edx,%eax
8010526a:	83 e0 01             	and    $0x1,%eax
8010526d:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105270:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105273:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105276:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
8010527a:	89 d8                	mov    %ebx,%eax
}
8010527c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010527f:	5b                   	pop    %ebx
80105280:	5e                   	pop    %esi
80105281:	5f                   	pop    %edi
80105282:	5d                   	pop    %ebp
80105283:	c3                   	ret    
80105284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80105288:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010528b:	85 c9                	test   %ecx,%ecx
8010528d:	0f 84 23 ff ff ff    	je     801051b6 <sys_open+0x76>
80105293:	e9 54 ff ff ff       	jmp    801051ec <sys_open+0xac>
80105298:	90                   	nop
80105299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801052a0 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
801052a0:	55                   	push   %ebp
801052a1:	89 e5                	mov    %esp,%ebp
801052a3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801052a6:	e8 95 d8 ff ff       	call   80102b40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801052ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052ae:	83 ec 08             	sub    $0x8,%esp
801052b1:	50                   	push   %eax
801052b2:	6a 00                	push   $0x0
801052b4:	e8 a7 f6 ff ff       	call   80104960 <argstr>
801052b9:	83 c4 10             	add    $0x10,%esp
801052bc:	85 c0                	test   %eax,%eax
801052be:	78 30                	js     801052f0 <sys_mkdir+0x50>
801052c0:	83 ec 0c             	sub    $0xc,%esp
801052c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052c6:	31 c9                	xor    %ecx,%ecx
801052c8:	6a 00                	push   $0x0
801052ca:	ba 01 00 00 00       	mov    $0x1,%edx
801052cf:	e8 2c f7 ff ff       	call   80104a00 <create>
801052d4:	83 c4 10             	add    $0x10,%esp
801052d7:	85 c0                	test   %eax,%eax
801052d9:	74 15                	je     801052f0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801052db:	83 ec 0c             	sub    $0xc,%esp
801052de:	50                   	push   %eax
801052df:	e8 0c c6 ff ff       	call   801018f0 <iunlockput>
  end_op();
801052e4:	e8 c7 d8 ff ff       	call   80102bb0 <end_op>
  return 0;
801052e9:	83 c4 10             	add    $0x10,%esp
801052ec:	31 c0                	xor    %eax,%eax
}
801052ee:	c9                   	leave  
801052ef:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
801052f0:	e8 bb d8 ff ff       	call   80102bb0 <end_op>
    return -1;
801052f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801052fa:	c9                   	leave  
801052fb:	c3                   	ret    
801052fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105300 <sys_mknod>:

int
sys_mknod(void)
{
80105300:	55                   	push   %ebp
80105301:	89 e5                	mov    %esp,%ebp
80105303:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105306:	e8 35 d8 ff ff       	call   80102b40 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010530b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010530e:	83 ec 08             	sub    $0x8,%esp
80105311:	50                   	push   %eax
80105312:	6a 00                	push   $0x0
80105314:	e8 47 f6 ff ff       	call   80104960 <argstr>
80105319:	83 c4 10             	add    $0x10,%esp
8010531c:	85 c0                	test   %eax,%eax
8010531e:	78 60                	js     80105380 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105320:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105323:	83 ec 08             	sub    $0x8,%esp
80105326:	50                   	push   %eax
80105327:	6a 01                	push   $0x1
80105329:	e8 82 f5 ff ff       	call   801048b0 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
8010532e:	83 c4 10             	add    $0x10,%esp
80105331:	85 c0                	test   %eax,%eax
80105333:	78 4b                	js     80105380 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105335:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105338:	83 ec 08             	sub    $0x8,%esp
8010533b:	50                   	push   %eax
8010533c:	6a 02                	push   $0x2
8010533e:	e8 6d f5 ff ff       	call   801048b0 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105343:	83 c4 10             	add    $0x10,%esp
80105346:	85 c0                	test   %eax,%eax
80105348:	78 36                	js     80105380 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
8010534a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010534e:	83 ec 0c             	sub    $0xc,%esp
80105351:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105355:	ba 03 00 00 00       	mov    $0x3,%edx
8010535a:	50                   	push   %eax
8010535b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010535e:	e8 9d f6 ff ff       	call   80104a00 <create>
80105363:	83 c4 10             	add    $0x10,%esp
80105366:	85 c0                	test   %eax,%eax
80105368:	74 16                	je     80105380 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
8010536a:	83 ec 0c             	sub    $0xc,%esp
8010536d:	50                   	push   %eax
8010536e:	e8 7d c5 ff ff       	call   801018f0 <iunlockput>
  end_op();
80105373:	e8 38 d8 ff ff       	call   80102bb0 <end_op>
  return 0;
80105378:	83 c4 10             	add    $0x10,%esp
8010537b:	31 c0                	xor    %eax,%eax
}
8010537d:	c9                   	leave  
8010537e:	c3                   	ret    
8010537f:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105380:	e8 2b d8 ff ff       	call   80102bb0 <end_op>
    return -1;
80105385:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010538a:	c9                   	leave  
8010538b:	c3                   	ret    
8010538c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105390 <sys_chdir>:

int
sys_chdir(void)
{
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	56                   	push   %esi
80105394:	53                   	push   %ebx
80105395:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105398:	e8 f3 e3 ff ff       	call   80103790 <myproc>
8010539d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010539f:	e8 9c d7 ff ff       	call   80102b40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801053a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053a7:	83 ec 08             	sub    $0x8,%esp
801053aa:	50                   	push   %eax
801053ab:	6a 00                	push   $0x0
801053ad:	e8 ae f5 ff ff       	call   80104960 <argstr>
801053b2:	83 c4 10             	add    $0x10,%esp
801053b5:	85 c0                	test   %eax,%eax
801053b7:	78 77                	js     80105430 <sys_chdir+0xa0>
801053b9:	83 ec 0c             	sub    $0xc,%esp
801053bc:	ff 75 f4             	pushl  -0xc(%ebp)
801053bf:	e8 ec ca ff ff       	call   80101eb0 <namei>
801053c4:	83 c4 10             	add    $0x10,%esp
801053c7:	85 c0                	test   %eax,%eax
801053c9:	89 c3                	mov    %eax,%ebx
801053cb:	74 63                	je     80105430 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801053cd:	83 ec 0c             	sub    $0xc,%esp
801053d0:	50                   	push   %eax
801053d1:	e8 8a c2 ff ff       	call   80101660 <ilock>
  if(ip->type != T_DIR){
801053d6:	83 c4 10             	add    $0x10,%esp
801053d9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053de:	75 30                	jne    80105410 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801053e0:	83 ec 0c             	sub    $0xc,%esp
801053e3:	53                   	push   %ebx
801053e4:	e8 57 c3 ff ff       	call   80101740 <iunlock>
  iput(curproc->cwd);
801053e9:	58                   	pop    %eax
801053ea:	ff 76 68             	pushl  0x68(%esi)
801053ed:	e8 9e c3 ff ff       	call   80101790 <iput>
  end_op();
801053f2:	e8 b9 d7 ff ff       	call   80102bb0 <end_op>
  curproc->cwd = ip;
801053f7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801053fa:	83 c4 10             	add    $0x10,%esp
801053fd:	31 c0                	xor    %eax,%eax
}
801053ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105402:	5b                   	pop    %ebx
80105403:	5e                   	pop    %esi
80105404:	5d                   	pop    %ebp
80105405:	c3                   	ret    
80105406:	8d 76 00             	lea    0x0(%esi),%esi
80105409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105410:	83 ec 0c             	sub    $0xc,%esp
80105413:	53                   	push   %ebx
80105414:	e8 d7 c4 ff ff       	call   801018f0 <iunlockput>
    end_op();
80105419:	e8 92 d7 ff ff       	call   80102bb0 <end_op>
    return -1;
8010541e:	83 c4 10             	add    $0x10,%esp
80105421:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105426:	eb d7                	jmp    801053ff <sys_chdir+0x6f>
80105428:	90                   	nop
80105429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
80105430:	e8 7b d7 ff ff       	call   80102bb0 <end_op>
    return -1;
80105435:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010543a:	eb c3                	jmp    801053ff <sys_chdir+0x6f>
8010543c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105440 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	57                   	push   %edi
80105444:	56                   	push   %esi
80105445:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105446:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
8010544c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105452:	50                   	push   %eax
80105453:	6a 00                	push   $0x0
80105455:	e8 06 f5 ff ff       	call   80104960 <argstr>
8010545a:	83 c4 10             	add    $0x10,%esp
8010545d:	85 c0                	test   %eax,%eax
8010545f:	78 7f                	js     801054e0 <sys_exec+0xa0>
80105461:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105467:	83 ec 08             	sub    $0x8,%esp
8010546a:	50                   	push   %eax
8010546b:	6a 01                	push   $0x1
8010546d:	e8 3e f4 ff ff       	call   801048b0 <argint>
80105472:	83 c4 10             	add    $0x10,%esp
80105475:	85 c0                	test   %eax,%eax
80105477:	78 67                	js     801054e0 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105479:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010547f:	83 ec 04             	sub    $0x4,%esp
80105482:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105488:	68 80 00 00 00       	push   $0x80
8010548d:	6a 00                	push   $0x0
8010548f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105495:	50                   	push   %eax
80105496:	31 db                	xor    %ebx,%ebx
80105498:	e8 03 f1 ff ff       	call   801045a0 <memset>
8010549d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801054a0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801054a6:	83 ec 08             	sub    $0x8,%esp
801054a9:	57                   	push   %edi
801054aa:	8d 04 98             	lea    (%eax,%ebx,4),%eax
801054ad:	50                   	push   %eax
801054ae:	e8 5d f3 ff ff       	call   80104810 <fetchint>
801054b3:	83 c4 10             	add    $0x10,%esp
801054b6:	85 c0                	test   %eax,%eax
801054b8:	78 26                	js     801054e0 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
801054ba:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801054c0:	85 c0                	test   %eax,%eax
801054c2:	74 2c                	je     801054f0 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801054c4:	83 ec 08             	sub    $0x8,%esp
801054c7:	56                   	push   %esi
801054c8:	50                   	push   %eax
801054c9:	e8 82 f3 ff ff       	call   80104850 <fetchstr>
801054ce:	83 c4 10             	add    $0x10,%esp
801054d1:	85 c0                	test   %eax,%eax
801054d3:	78 0b                	js     801054e0 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801054d5:	83 c3 01             	add    $0x1,%ebx
801054d8:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
801054db:	83 fb 20             	cmp    $0x20,%ebx
801054de:	75 c0                	jne    801054a0 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801054e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
801054e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801054e8:	5b                   	pop    %ebx
801054e9:	5e                   	pop    %esi
801054ea:	5f                   	pop    %edi
801054eb:	5d                   	pop    %ebp
801054ec:	c3                   	ret    
801054ed:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801054f0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801054f6:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
801054f9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105500:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105504:	50                   	push   %eax
80105505:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010550b:	e8 e0 b4 ff ff       	call   801009f0 <exec>
80105510:	83 c4 10             	add    $0x10,%esp
}
80105513:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105516:	5b                   	pop    %ebx
80105517:	5e                   	pop    %esi
80105518:	5f                   	pop    %edi
80105519:	5d                   	pop    %ebp
8010551a:	c3                   	ret    
8010551b:	90                   	nop
8010551c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105520 <sys_pipe>:

int
sys_pipe(void)
{
80105520:	55                   	push   %ebp
80105521:	89 e5                	mov    %esp,%ebp
80105523:	57                   	push   %edi
80105524:	56                   	push   %esi
80105525:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105526:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
80105529:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010552c:	6a 08                	push   $0x8
8010552e:	50                   	push   %eax
8010552f:	6a 00                	push   $0x0
80105531:	e8 ca f3 ff ff       	call   80104900 <argptr>
80105536:	83 c4 10             	add    $0x10,%esp
80105539:	85 c0                	test   %eax,%eax
8010553b:	78 4a                	js     80105587 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010553d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105540:	83 ec 08             	sub    $0x8,%esp
80105543:	50                   	push   %eax
80105544:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105547:	50                   	push   %eax
80105548:	e8 93 dc ff ff       	call   801031e0 <pipealloc>
8010554d:	83 c4 10             	add    $0x10,%esp
80105550:	85 c0                	test   %eax,%eax
80105552:	78 33                	js     80105587 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105554:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105556:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105559:	e8 32 e2 ff ff       	call   80103790 <myproc>
8010555e:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105560:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105564:	85 f6                	test   %esi,%esi
80105566:	74 30                	je     80105598 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105568:	83 c3 01             	add    $0x1,%ebx
8010556b:	83 fb 10             	cmp    $0x10,%ebx
8010556e:	75 f0                	jne    80105560 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105570:	83 ec 0c             	sub    $0xc,%esp
80105573:	ff 75 e0             	pushl  -0x20(%ebp)
80105576:	e8 b5 b8 ff ff       	call   80100e30 <fileclose>
    fileclose(wf);
8010557b:	58                   	pop    %eax
8010557c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010557f:	e8 ac b8 ff ff       	call   80100e30 <fileclose>
    return -1;
80105584:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105587:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
8010558a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
8010558f:	5b                   	pop    %ebx
80105590:	5e                   	pop    %esi
80105591:	5f                   	pop    %edi
80105592:	5d                   	pop    %ebp
80105593:	c3                   	ret    
80105594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105598:	8d 73 08             	lea    0x8(%ebx),%esi
8010559b:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010559f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
801055a2:	e8 e9 e1 ff ff       	call   80103790 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
801055a7:	31 d2                	xor    %edx,%edx
801055a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801055b0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801055b4:	85 c9                	test   %ecx,%ecx
801055b6:	74 18                	je     801055d0 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801055b8:	83 c2 01             	add    $0x1,%edx
801055bb:	83 fa 10             	cmp    $0x10,%edx
801055be:	75 f0                	jne    801055b0 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
801055c0:	e8 cb e1 ff ff       	call   80103790 <myproc>
801055c5:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801055cc:	00 
801055cd:	eb a1                	jmp    80105570 <sys_pipe+0x50>
801055cf:	90                   	nop
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801055d0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801055d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801055d7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801055d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801055dc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
801055df:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
801055e2:	31 c0                	xor    %eax,%eax
}
801055e4:	5b                   	pop    %ebx
801055e5:	5e                   	pop    %esi
801055e6:	5f                   	pop    %edi
801055e7:	5d                   	pop    %ebp
801055e8:	c3                   	ret    
801055e9:	66 90                	xchg   %ax,%ax
801055eb:	66 90                	xchg   %ax,%ax
801055ed:	66 90                	xchg   %ax,%ax
801055ef:	90                   	nop

801055f0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801055f3:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801055f4:	e9 37 e3 ff ff       	jmp    80103930 <fork>
801055f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105600 <sys_exit>:
}

int
sys_exit(void)
{
80105600:	55                   	push   %ebp
80105601:	89 e5                	mov    %esp,%ebp
80105603:	83 ec 08             	sub    $0x8,%esp
  exit();
80105606:	e8 b5 e5 ff ff       	call   80103bc0 <exit>
  return 0;  // not reached
}
8010560b:	31 c0                	xor    %eax,%eax
8010560d:	c9                   	leave  
8010560e:	c3                   	ret    
8010560f:	90                   	nop

80105610 <sys_wait>:

int
sys_wait(void)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105613:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105614:	e9 e7 e7 ff ff       	jmp    80103e00 <wait>
80105619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105620 <sys_kill>:
}

int
sys_kill(void)
{
80105620:	55                   	push   %ebp
80105621:	89 e5                	mov    %esp,%ebp
80105623:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105626:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105629:	50                   	push   %eax
8010562a:	6a 00                	push   $0x0
8010562c:	e8 7f f2 ff ff       	call   801048b0 <argint>
80105631:	83 c4 10             	add    $0x10,%esp
80105634:	85 c0                	test   %eax,%eax
80105636:	78 18                	js     80105650 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105638:	83 ec 0c             	sub    $0xc,%esp
8010563b:	ff 75 f4             	pushl  -0xc(%ebp)
8010563e:	e8 1d e9 ff ff       	call   80103f60 <kill>
80105643:	83 c4 10             	add    $0x10,%esp
}
80105646:	c9                   	leave  
80105647:	c3                   	ret    
80105648:	90                   	nop
80105649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105650:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105655:	c9                   	leave  
80105656:	c3                   	ret    
80105657:	89 f6                	mov    %esi,%esi
80105659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105660 <sys_getpid>:

int
sys_getpid(void)
{
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
80105663:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105666:	e8 25 e1 ff ff       	call   80103790 <myproc>
8010566b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010566e:	c9                   	leave  
8010566f:	c3                   	ret    

80105670 <sys_sbrk>:

int
sys_sbrk(void)
{
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
80105673:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105674:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return myproc()->pid;
}

int
sys_sbrk(void)
{
80105677:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010567a:	50                   	push   %eax
8010567b:	6a 00                	push   $0x0
8010567d:	e8 2e f2 ff ff       	call   801048b0 <argint>
80105682:	83 c4 10             	add    $0x10,%esp
80105685:	85 c0                	test   %eax,%eax
80105687:	78 27                	js     801056b0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105689:	e8 02 e1 ff ff       	call   80103790 <myproc>
  if(growproc(n) < 0)
8010568e:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
80105691:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105693:	ff 75 f4             	pushl  -0xc(%ebp)
80105696:	e8 15 e2 ff ff       	call   801038b0 <growproc>
8010569b:	83 c4 10             	add    $0x10,%esp
8010569e:	85 c0                	test   %eax,%eax
801056a0:	78 0e                	js     801056b0 <sys_sbrk+0x40>
    return -1;
  return addr;
801056a2:	89 d8                	mov    %ebx,%eax
}
801056a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056a7:	c9                   	leave  
801056a8:	c3                   	ret    
801056a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
801056b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056b5:	eb ed                	jmp    801056a4 <sys_sbrk+0x34>
801056b7:	89 f6                	mov    %esi,%esi
801056b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056c0 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
801056c3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801056c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return addr;
}

int
sys_sleep(void)
{
801056c7:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801056ca:	50                   	push   %eax
801056cb:	6a 00                	push   $0x0
801056cd:	e8 de f1 ff ff       	call   801048b0 <argint>
801056d2:	83 c4 10             	add    $0x10,%esp
801056d5:	85 c0                	test   %eax,%eax
801056d7:	0f 88 8a 00 00 00    	js     80105767 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801056dd:	83 ec 0c             	sub    $0xc,%esp
801056e0:	68 60 4f 11 80       	push   $0x80114f60
801056e5:	e8 b6 ed ff ff       	call   801044a0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801056ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
801056ed:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
801056f0:	8b 1d a0 57 11 80    	mov    0x801157a0,%ebx
  while(ticks - ticks0 < n){
801056f6:	85 d2                	test   %edx,%edx
801056f8:	75 27                	jne    80105721 <sys_sleep+0x61>
801056fa:	eb 54                	jmp    80105750 <sys_sleep+0x90>
801056fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105700:	83 ec 08             	sub    $0x8,%esp
80105703:	68 60 4f 11 80       	push   $0x80114f60
80105708:	68 a0 57 11 80       	push   $0x801157a0
8010570d:	e8 2e e6 ff ff       	call   80103d40 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105712:	a1 a0 57 11 80       	mov    0x801157a0,%eax
80105717:	83 c4 10             	add    $0x10,%esp
8010571a:	29 d8                	sub    %ebx,%eax
8010571c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010571f:	73 2f                	jae    80105750 <sys_sleep+0x90>
    if(myproc()->killed){
80105721:	e8 6a e0 ff ff       	call   80103790 <myproc>
80105726:	8b 40 24             	mov    0x24(%eax),%eax
80105729:	85 c0                	test   %eax,%eax
8010572b:	74 d3                	je     80105700 <sys_sleep+0x40>
      release(&tickslock);
8010572d:	83 ec 0c             	sub    $0xc,%esp
80105730:	68 60 4f 11 80       	push   $0x80114f60
80105735:	e8 16 ee ff ff       	call   80104550 <release>
      return -1;
8010573a:	83 c4 10             	add    $0x10,%esp
8010573d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
80105742:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105745:	c9                   	leave  
80105746:	c3                   	ret    
80105747:	89 f6                	mov    %esi,%esi
80105749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105750:	83 ec 0c             	sub    $0xc,%esp
80105753:	68 60 4f 11 80       	push   $0x80114f60
80105758:	e8 f3 ed ff ff       	call   80104550 <release>
  return 0;
8010575d:	83 c4 10             	add    $0x10,%esp
80105760:	31 c0                	xor    %eax,%eax
}
80105762:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105765:	c9                   	leave  
80105766:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
80105767:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010576c:	eb d4                	jmp    80105742 <sys_sleep+0x82>
8010576e:	66 90                	xchg   %ax,%ax

80105770 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105770:	55                   	push   %ebp
80105771:	89 e5                	mov    %esp,%ebp
80105773:	53                   	push   %ebx
80105774:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105777:	68 60 4f 11 80       	push   $0x80114f60
8010577c:	e8 1f ed ff ff       	call   801044a0 <acquire>
  xticks = ticks;
80105781:	8b 1d a0 57 11 80    	mov    0x801157a0,%ebx
  release(&tickslock);
80105787:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
8010578e:	e8 bd ed ff ff       	call   80104550 <release>
  return xticks;
}
80105793:	89 d8                	mov    %ebx,%eax
80105795:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105798:	c9                   	leave  
80105799:	c3                   	ret    

8010579a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010579a:	1e                   	push   %ds
  pushl %es
8010579b:	06                   	push   %es
  pushl %fs
8010579c:	0f a0                	push   %fs
  pushl %gs
8010579e:	0f a8                	push   %gs
  pushal
801057a0:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801057a1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801057a5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801057a7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801057a9:	54                   	push   %esp
  call trap
801057aa:	e8 e1 00 00 00       	call   80105890 <trap>
  addl $4, %esp
801057af:	83 c4 04             	add    $0x4,%esp

801057b2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801057b2:	61                   	popa   
  popl %gs
801057b3:	0f a9                	pop    %gs
  popl %fs
801057b5:	0f a1                	pop    %fs
  popl %es
801057b7:	07                   	pop    %es
  popl %ds
801057b8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801057b9:	83 c4 08             	add    $0x8,%esp
  iret
801057bc:	cf                   	iret   
801057bd:	66 90                	xchg   %ax,%ax
801057bf:	90                   	nop

801057c0 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801057c0:	31 c0                	xor    %eax,%eax
801057c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801057c8:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
801057cf:	b9 08 00 00 00       	mov    $0x8,%ecx
801057d4:	c6 04 c5 a4 4f 11 80 	movb   $0x0,-0x7feeb05c(,%eax,8)
801057db:	00 
801057dc:	66 89 0c c5 a2 4f 11 	mov    %cx,-0x7feeb05e(,%eax,8)
801057e3:	80 
801057e4:	c6 04 c5 a5 4f 11 80 	movb   $0x8e,-0x7feeb05b(,%eax,8)
801057eb:	8e 
801057ec:	66 89 14 c5 a0 4f 11 	mov    %dx,-0x7feeb060(,%eax,8)
801057f3:	80 
801057f4:	c1 ea 10             	shr    $0x10,%edx
801057f7:	66 89 14 c5 a6 4f 11 	mov    %dx,-0x7feeb05a(,%eax,8)
801057fe:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801057ff:	83 c0 01             	add    $0x1,%eax
80105802:	3d 00 01 00 00       	cmp    $0x100,%eax
80105807:	75 bf                	jne    801057c8 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105809:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010580a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010580f:	89 e5                	mov    %esp,%ebp
80105811:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105814:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105819:	68 fd 77 10 80       	push   $0x801077fd
8010581e:	68 60 4f 11 80       	push   $0x80114f60
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105823:	66 89 15 a2 51 11 80 	mov    %dx,0x801151a2
8010582a:	c6 05 a4 51 11 80 00 	movb   $0x0,0x801151a4
80105831:	66 a3 a0 51 11 80    	mov    %ax,0x801151a0
80105837:	c1 e8 10             	shr    $0x10,%eax
8010583a:	c6 05 a5 51 11 80 ef 	movb   $0xef,0x801151a5
80105841:	66 a3 a6 51 11 80    	mov    %ax,0x801151a6

  initlock(&tickslock, "time");
80105847:	e8 f4 ea ff ff       	call   80104340 <initlock>
}
8010584c:	83 c4 10             	add    $0x10,%esp
8010584f:	c9                   	leave  
80105850:	c3                   	ret    
80105851:	eb 0d                	jmp    80105860 <idtinit>
80105853:	90                   	nop
80105854:	90                   	nop
80105855:	90                   	nop
80105856:	90                   	nop
80105857:	90                   	nop
80105858:	90                   	nop
80105859:	90                   	nop
8010585a:	90                   	nop
8010585b:	90                   	nop
8010585c:	90                   	nop
8010585d:	90                   	nop
8010585e:	90                   	nop
8010585f:	90                   	nop

80105860 <idtinit>:

void
idtinit(void)
{
80105860:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105861:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105866:	89 e5                	mov    %esp,%ebp
80105868:	83 ec 10             	sub    $0x10,%esp
8010586b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010586f:	b8 a0 4f 11 80       	mov    $0x80114fa0,%eax
80105874:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105878:	c1 e8 10             	shr    $0x10,%eax
8010587b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010587f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105882:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105885:	c9                   	leave  
80105886:	c3                   	ret    
80105887:	89 f6                	mov    %esi,%esi
80105889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105890 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105890:	55                   	push   %ebp
80105891:	89 e5                	mov    %esp,%ebp
80105893:	57                   	push   %edi
80105894:	56                   	push   %esi
80105895:	53                   	push   %ebx
80105896:	83 ec 1c             	sub    $0x1c,%esp
80105899:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010589c:	8b 47 30             	mov    0x30(%edi),%eax
8010589f:	83 f8 40             	cmp    $0x40,%eax
801058a2:	0f 84 88 01 00 00    	je     80105a30 <trap+0x1a0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801058a8:	83 e8 20             	sub    $0x20,%eax
801058ab:	83 f8 1f             	cmp    $0x1f,%eax
801058ae:	77 10                	ja     801058c0 <trap+0x30>
801058b0:	ff 24 85 a4 78 10 80 	jmp    *-0x7fef875c(,%eax,4)
801058b7:	89 f6                	mov    %esi,%esi
801058b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801058c0:	e8 cb de ff ff       	call   80103790 <myproc>
801058c5:	85 c0                	test   %eax,%eax
801058c7:	0f 84 d7 01 00 00    	je     80105aa4 <trap+0x214>
801058cd:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801058d1:	0f 84 cd 01 00 00    	je     80105aa4 <trap+0x214>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801058d7:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801058da:	8b 57 38             	mov    0x38(%edi),%edx
801058dd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801058e0:	89 55 dc             	mov    %edx,-0x24(%ebp)
801058e3:	e8 88 de ff ff       	call   80103770 <cpuid>
801058e8:	8b 77 34             	mov    0x34(%edi),%esi
801058eb:	8b 5f 30             	mov    0x30(%edi),%ebx
801058ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801058f1:	e8 9a de ff ff       	call   80103790 <myproc>
801058f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801058f9:	e8 92 de ff ff       	call   80103790 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801058fe:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105901:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105904:	51                   	push   %ecx
80105905:	52                   	push   %edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105906:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105909:	ff 75 e4             	pushl  -0x1c(%ebp)
8010590c:	56                   	push   %esi
8010590d:	53                   	push   %ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010590e:	83 c2 6c             	add    $0x6c,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105911:	52                   	push   %edx
80105912:	ff 70 10             	pushl  0x10(%eax)
80105915:	68 60 78 10 80       	push   $0x80107860
8010591a:	e8 41 ad ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010591f:	83 c4 20             	add    $0x20,%esp
80105922:	e8 69 de ff ff       	call   80103790 <myproc>
80105927:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010592e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105930:	e8 5b de ff ff       	call   80103790 <myproc>
80105935:	85 c0                	test   %eax,%eax
80105937:	74 0c                	je     80105945 <trap+0xb5>
80105939:	e8 52 de ff ff       	call   80103790 <myproc>
8010593e:	8b 50 24             	mov    0x24(%eax),%edx
80105941:	85 d2                	test   %edx,%edx
80105943:	75 4b                	jne    80105990 <trap+0x100>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105945:	e8 46 de ff ff       	call   80103790 <myproc>
8010594a:	85 c0                	test   %eax,%eax
8010594c:	74 0b                	je     80105959 <trap+0xc9>
8010594e:	e8 3d de ff ff       	call   80103790 <myproc>
80105953:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105957:	74 4f                	je     801059a8 <trap+0x118>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105959:	e8 32 de ff ff       	call   80103790 <myproc>
8010595e:	85 c0                	test   %eax,%eax
80105960:	74 1d                	je     8010597f <trap+0xef>
80105962:	e8 29 de ff ff       	call   80103790 <myproc>
80105967:	8b 40 24             	mov    0x24(%eax),%eax
8010596a:	85 c0                	test   %eax,%eax
8010596c:	74 11                	je     8010597f <trap+0xef>
8010596e:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105972:	83 e0 03             	and    $0x3,%eax
80105975:	66 83 f8 03          	cmp    $0x3,%ax
80105979:	0f 84 da 00 00 00    	je     80105a59 <trap+0x1c9>
    exit();
}
8010597f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105982:	5b                   	pop    %ebx
80105983:	5e                   	pop    %esi
80105984:	5f                   	pop    %edi
80105985:	5d                   	pop    %ebp
80105986:	c3                   	ret    
80105987:	89 f6                	mov    %esi,%esi
80105989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105990:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105994:	83 e0 03             	and    $0x3,%eax
80105997:	66 83 f8 03          	cmp    $0x3,%ax
8010599b:	75 a8                	jne    80105945 <trap+0xb5>
    exit();
8010599d:	e8 1e e2 ff ff       	call   80103bc0 <exit>
801059a2:	eb a1                	jmp    80105945 <trap+0xb5>
801059a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801059a8:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
801059ac:	75 ab                	jne    80105959 <trap+0xc9>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
801059ae:	e8 3d e3 ff ff       	call   80103cf0 <yield>
801059b3:	eb a4                	jmp    80105959 <trap+0xc9>
801059b5:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
801059b8:	e8 b3 dd ff ff       	call   80103770 <cpuid>
801059bd:	85 c0                	test   %eax,%eax
801059bf:	0f 84 ab 00 00 00    	je     80105a70 <trap+0x1e0>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
801059c5:	e8 36 cd ff ff       	call   80102700 <lapiceoi>
    break;
801059ca:	e9 61 ff ff ff       	jmp    80105930 <trap+0xa0>
801059cf:	90                   	nop
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801059d0:	e8 eb cb ff ff       	call   801025c0 <kbdintr>
    lapiceoi();
801059d5:	e8 26 cd ff ff       	call   80102700 <lapiceoi>
    break;
801059da:	e9 51 ff ff ff       	jmp    80105930 <trap+0xa0>
801059df:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801059e0:	e8 5b 02 00 00       	call   80105c40 <uartintr>
    lapiceoi();
801059e5:	e8 16 cd ff ff       	call   80102700 <lapiceoi>
    break;
801059ea:	e9 41 ff ff ff       	jmp    80105930 <trap+0xa0>
801059ef:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801059f0:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801059f4:	8b 77 38             	mov    0x38(%edi),%esi
801059f7:	e8 74 dd ff ff       	call   80103770 <cpuid>
801059fc:	56                   	push   %esi
801059fd:	53                   	push   %ebx
801059fe:	50                   	push   %eax
801059ff:	68 08 78 10 80       	push   $0x80107808
80105a04:	e8 57 ac ff ff       	call   80100660 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80105a09:	e8 f2 cc ff ff       	call   80102700 <lapiceoi>
    break;
80105a0e:	83 c4 10             	add    $0x10,%esp
80105a11:	e9 1a ff ff ff       	jmp    80105930 <trap+0xa0>
80105a16:	8d 76 00             	lea    0x0(%esi),%esi
80105a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105a20:	e8 1b c6 ff ff       	call   80102040 <ideintr>
80105a25:	eb 9e                	jmp    801059c5 <trap+0x135>
80105a27:	89 f6                	mov    %esi,%esi
80105a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80105a30:	e8 5b dd ff ff       	call   80103790 <myproc>
80105a35:	8b 58 24             	mov    0x24(%eax),%ebx
80105a38:	85 db                	test   %ebx,%ebx
80105a3a:	75 2c                	jne    80105a68 <trap+0x1d8>
      exit();
    myproc()->tf = tf;
80105a3c:	e8 4f dd ff ff       	call   80103790 <myproc>
80105a41:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105a44:	e8 57 ef ff ff       	call   801049a0 <syscall>
    if(myproc()->killed)
80105a49:	e8 42 dd ff ff       	call   80103790 <myproc>
80105a4e:	8b 48 24             	mov    0x24(%eax),%ecx
80105a51:	85 c9                	test   %ecx,%ecx
80105a53:	0f 84 26 ff ff ff    	je     8010597f <trap+0xef>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80105a59:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a5c:	5b                   	pop    %ebx
80105a5d:	5e                   	pop    %esi
80105a5e:	5f                   	pop    %edi
80105a5f:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
80105a60:	e9 5b e1 ff ff       	jmp    80103bc0 <exit>
80105a65:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
80105a68:	e8 53 e1 ff ff       	call   80103bc0 <exit>
80105a6d:	eb cd                	jmp    80105a3c <trap+0x1ac>
80105a6f:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
80105a70:	83 ec 0c             	sub    $0xc,%esp
80105a73:	68 60 4f 11 80       	push   $0x80114f60
80105a78:	e8 23 ea ff ff       	call   801044a0 <acquire>
      ticks++;
      wakeup(&ticks);
80105a7d:	c7 04 24 a0 57 11 80 	movl   $0x801157a0,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
80105a84:	83 05 a0 57 11 80 01 	addl   $0x1,0x801157a0
      wakeup(&ticks);
80105a8b:	e8 70 e4 ff ff       	call   80103f00 <wakeup>
      release(&tickslock);
80105a90:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
80105a97:	e8 b4 ea ff ff       	call   80104550 <release>
80105a9c:	83 c4 10             	add    $0x10,%esp
80105a9f:	e9 21 ff ff ff       	jmp    801059c5 <trap+0x135>
80105aa4:	0f 20 d6             	mov    %cr2,%esi

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105aa7:	8b 5f 38             	mov    0x38(%edi),%ebx
80105aaa:	e8 c1 dc ff ff       	call   80103770 <cpuid>
80105aaf:	83 ec 0c             	sub    $0xc,%esp
80105ab2:	56                   	push   %esi
80105ab3:	53                   	push   %ebx
80105ab4:	50                   	push   %eax
80105ab5:	ff 77 30             	pushl  0x30(%edi)
80105ab8:	68 2c 78 10 80       	push   $0x8010782c
80105abd:	e8 9e ab ff ff       	call   80100660 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80105ac2:	83 c4 14             	add    $0x14,%esp
80105ac5:	68 02 78 10 80       	push   $0x80107802
80105aca:	e8 a1 a8 ff ff       	call   80100370 <panic>
80105acf:	90                   	nop

80105ad0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105ad0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105ad5:	55                   	push   %ebp
80105ad6:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105ad8:	85 c0                	test   %eax,%eax
80105ada:	74 1c                	je     80105af8 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105adc:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ae1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105ae2:	a8 01                	test   $0x1,%al
80105ae4:	74 12                	je     80105af8 <uartgetc+0x28>
80105ae6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105aeb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105aec:	0f b6 c0             	movzbl %al,%eax
}
80105aef:	5d                   	pop    %ebp
80105af0:	c3                   	ret    
80105af1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80105af8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80105afd:	5d                   	pop    %ebp
80105afe:	c3                   	ret    
80105aff:	90                   	nop

80105b00 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	57                   	push   %edi
80105b04:	56                   	push   %esi
80105b05:	53                   	push   %ebx
80105b06:	89 c7                	mov    %eax,%edi
80105b08:	bb 80 00 00 00       	mov    $0x80,%ebx
80105b0d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105b12:	83 ec 0c             	sub    $0xc,%esp
80105b15:	eb 1b                	jmp    80105b32 <uartputc.part.0+0x32>
80105b17:	89 f6                	mov    %esi,%esi
80105b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105b20:	83 ec 0c             	sub    $0xc,%esp
80105b23:	6a 0a                	push   $0xa
80105b25:	e8 f6 cb ff ff       	call   80102720 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105b2a:	83 c4 10             	add    $0x10,%esp
80105b2d:	83 eb 01             	sub    $0x1,%ebx
80105b30:	74 07                	je     80105b39 <uartputc.part.0+0x39>
80105b32:	89 f2                	mov    %esi,%edx
80105b34:	ec                   	in     (%dx),%al
80105b35:	a8 20                	test   $0x20,%al
80105b37:	74 e7                	je     80105b20 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105b39:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b3e:	89 f8                	mov    %edi,%eax
80105b40:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80105b41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b44:	5b                   	pop    %ebx
80105b45:	5e                   	pop    %esi
80105b46:	5f                   	pop    %edi
80105b47:	5d                   	pop    %ebp
80105b48:	c3                   	ret    
80105b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b50 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105b50:	55                   	push   %ebp
80105b51:	31 c9                	xor    %ecx,%ecx
80105b53:	89 c8                	mov    %ecx,%eax
80105b55:	89 e5                	mov    %esp,%ebp
80105b57:	57                   	push   %edi
80105b58:	56                   	push   %esi
80105b59:	53                   	push   %ebx
80105b5a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105b5f:	89 da                	mov    %ebx,%edx
80105b61:	83 ec 0c             	sub    $0xc,%esp
80105b64:	ee                   	out    %al,(%dx)
80105b65:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105b6a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105b6f:	89 fa                	mov    %edi,%edx
80105b71:	ee                   	out    %al,(%dx)
80105b72:	b8 0c 00 00 00       	mov    $0xc,%eax
80105b77:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b7c:	ee                   	out    %al,(%dx)
80105b7d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105b82:	89 c8                	mov    %ecx,%eax
80105b84:	89 f2                	mov    %esi,%edx
80105b86:	ee                   	out    %al,(%dx)
80105b87:	b8 03 00 00 00       	mov    $0x3,%eax
80105b8c:	89 fa                	mov    %edi,%edx
80105b8e:	ee                   	out    %al,(%dx)
80105b8f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105b94:	89 c8                	mov    %ecx,%eax
80105b96:	ee                   	out    %al,(%dx)
80105b97:	b8 01 00 00 00       	mov    $0x1,%eax
80105b9c:	89 f2                	mov    %esi,%edx
80105b9e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105b9f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ba4:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80105ba5:	3c ff                	cmp    $0xff,%al
80105ba7:	74 5a                	je     80105c03 <uartinit+0xb3>
    return;
  uart = 1;
80105ba9:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105bb0:	00 00 00 
80105bb3:	89 da                	mov    %ebx,%edx
80105bb5:	ec                   	in     (%dx),%al
80105bb6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105bbb:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
80105bbc:	83 ec 08             	sub    $0x8,%esp
80105bbf:	bb 24 79 10 80       	mov    $0x80107924,%ebx
80105bc4:	6a 00                	push   $0x0
80105bc6:	6a 04                	push   $0x4
80105bc8:	e8 c3 c6 ff ff       	call   80102290 <ioapicenable>
80105bcd:	83 c4 10             	add    $0x10,%esp
80105bd0:	b8 78 00 00 00       	mov    $0x78,%eax
80105bd5:	eb 13                	jmp    80105bea <uartinit+0x9a>
80105bd7:	89 f6                	mov    %esi,%esi
80105bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105be0:	83 c3 01             	add    $0x1,%ebx
80105be3:	0f be 03             	movsbl (%ebx),%eax
80105be6:	84 c0                	test   %al,%al
80105be8:	74 19                	je     80105c03 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
80105bea:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105bf0:	85 d2                	test   %edx,%edx
80105bf2:	74 ec                	je     80105be0 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105bf4:	83 c3 01             	add    $0x1,%ebx
80105bf7:	e8 04 ff ff ff       	call   80105b00 <uartputc.part.0>
80105bfc:	0f be 03             	movsbl (%ebx),%eax
80105bff:	84 c0                	test   %al,%al
80105c01:	75 e7                	jne    80105bea <uartinit+0x9a>
    uartputc(*p);
}
80105c03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c06:	5b                   	pop    %ebx
80105c07:	5e                   	pop    %esi
80105c08:	5f                   	pop    %edi
80105c09:	5d                   	pop    %ebp
80105c0a:	c3                   	ret    
80105c0b:	90                   	nop
80105c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c10 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80105c10:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105c16:	55                   	push   %ebp
80105c17:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80105c19:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
80105c1e:	74 10                	je     80105c30 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80105c20:	5d                   	pop    %ebp
80105c21:	e9 da fe ff ff       	jmp    80105b00 <uartputc.part.0>
80105c26:	8d 76 00             	lea    0x0(%esi),%esi
80105c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105c30:	5d                   	pop    %ebp
80105c31:	c3                   	ret    
80105c32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c40 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105c40:	55                   	push   %ebp
80105c41:	89 e5                	mov    %esp,%ebp
80105c43:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105c46:	68 d0 5a 10 80       	push   $0x80105ad0
80105c4b:	e8 a0 ab ff ff       	call   801007f0 <consoleintr>
}
80105c50:	83 c4 10             	add    $0x10,%esp
80105c53:	c9                   	leave  
80105c54:	c3                   	ret    

80105c55 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105c55:	6a 00                	push   $0x0
  pushl $0
80105c57:	6a 00                	push   $0x0
  jmp alltraps
80105c59:	e9 3c fb ff ff       	jmp    8010579a <alltraps>

80105c5e <vector1>:
.globl vector1
vector1:
  pushl $0
80105c5e:	6a 00                	push   $0x0
  pushl $1
80105c60:	6a 01                	push   $0x1
  jmp alltraps
80105c62:	e9 33 fb ff ff       	jmp    8010579a <alltraps>

80105c67 <vector2>:
.globl vector2
vector2:
  pushl $0
80105c67:	6a 00                	push   $0x0
  pushl $2
80105c69:	6a 02                	push   $0x2
  jmp alltraps
80105c6b:	e9 2a fb ff ff       	jmp    8010579a <alltraps>

80105c70 <vector3>:
.globl vector3
vector3:
  pushl $0
80105c70:	6a 00                	push   $0x0
  pushl $3
80105c72:	6a 03                	push   $0x3
  jmp alltraps
80105c74:	e9 21 fb ff ff       	jmp    8010579a <alltraps>

80105c79 <vector4>:
.globl vector4
vector4:
  pushl $0
80105c79:	6a 00                	push   $0x0
  pushl $4
80105c7b:	6a 04                	push   $0x4
  jmp alltraps
80105c7d:	e9 18 fb ff ff       	jmp    8010579a <alltraps>

80105c82 <vector5>:
.globl vector5
vector5:
  pushl $0
80105c82:	6a 00                	push   $0x0
  pushl $5
80105c84:	6a 05                	push   $0x5
  jmp alltraps
80105c86:	e9 0f fb ff ff       	jmp    8010579a <alltraps>

80105c8b <vector6>:
.globl vector6
vector6:
  pushl $0
80105c8b:	6a 00                	push   $0x0
  pushl $6
80105c8d:	6a 06                	push   $0x6
  jmp alltraps
80105c8f:	e9 06 fb ff ff       	jmp    8010579a <alltraps>

80105c94 <vector7>:
.globl vector7
vector7:
  pushl $0
80105c94:	6a 00                	push   $0x0
  pushl $7
80105c96:	6a 07                	push   $0x7
  jmp alltraps
80105c98:	e9 fd fa ff ff       	jmp    8010579a <alltraps>

80105c9d <vector8>:
.globl vector8
vector8:
  pushl $8
80105c9d:	6a 08                	push   $0x8
  jmp alltraps
80105c9f:	e9 f6 fa ff ff       	jmp    8010579a <alltraps>

80105ca4 <vector9>:
.globl vector9
vector9:
  pushl $0
80105ca4:	6a 00                	push   $0x0
  pushl $9
80105ca6:	6a 09                	push   $0x9
  jmp alltraps
80105ca8:	e9 ed fa ff ff       	jmp    8010579a <alltraps>

80105cad <vector10>:
.globl vector10
vector10:
  pushl $10
80105cad:	6a 0a                	push   $0xa
  jmp alltraps
80105caf:	e9 e6 fa ff ff       	jmp    8010579a <alltraps>

80105cb4 <vector11>:
.globl vector11
vector11:
  pushl $11
80105cb4:	6a 0b                	push   $0xb
  jmp alltraps
80105cb6:	e9 df fa ff ff       	jmp    8010579a <alltraps>

80105cbb <vector12>:
.globl vector12
vector12:
  pushl $12
80105cbb:	6a 0c                	push   $0xc
  jmp alltraps
80105cbd:	e9 d8 fa ff ff       	jmp    8010579a <alltraps>

80105cc2 <vector13>:
.globl vector13
vector13:
  pushl $13
80105cc2:	6a 0d                	push   $0xd
  jmp alltraps
80105cc4:	e9 d1 fa ff ff       	jmp    8010579a <alltraps>

80105cc9 <vector14>:
.globl vector14
vector14:
  pushl $14
80105cc9:	6a 0e                	push   $0xe
  jmp alltraps
80105ccb:	e9 ca fa ff ff       	jmp    8010579a <alltraps>

80105cd0 <vector15>:
.globl vector15
vector15:
  pushl $0
80105cd0:	6a 00                	push   $0x0
  pushl $15
80105cd2:	6a 0f                	push   $0xf
  jmp alltraps
80105cd4:	e9 c1 fa ff ff       	jmp    8010579a <alltraps>

80105cd9 <vector16>:
.globl vector16
vector16:
  pushl $0
80105cd9:	6a 00                	push   $0x0
  pushl $16
80105cdb:	6a 10                	push   $0x10
  jmp alltraps
80105cdd:	e9 b8 fa ff ff       	jmp    8010579a <alltraps>

80105ce2 <vector17>:
.globl vector17
vector17:
  pushl $17
80105ce2:	6a 11                	push   $0x11
  jmp alltraps
80105ce4:	e9 b1 fa ff ff       	jmp    8010579a <alltraps>

80105ce9 <vector18>:
.globl vector18
vector18:
  pushl $0
80105ce9:	6a 00                	push   $0x0
  pushl $18
80105ceb:	6a 12                	push   $0x12
  jmp alltraps
80105ced:	e9 a8 fa ff ff       	jmp    8010579a <alltraps>

80105cf2 <vector19>:
.globl vector19
vector19:
  pushl $0
80105cf2:	6a 00                	push   $0x0
  pushl $19
80105cf4:	6a 13                	push   $0x13
  jmp alltraps
80105cf6:	e9 9f fa ff ff       	jmp    8010579a <alltraps>

80105cfb <vector20>:
.globl vector20
vector20:
  pushl $0
80105cfb:	6a 00                	push   $0x0
  pushl $20
80105cfd:	6a 14                	push   $0x14
  jmp alltraps
80105cff:	e9 96 fa ff ff       	jmp    8010579a <alltraps>

80105d04 <vector21>:
.globl vector21
vector21:
  pushl $0
80105d04:	6a 00                	push   $0x0
  pushl $21
80105d06:	6a 15                	push   $0x15
  jmp alltraps
80105d08:	e9 8d fa ff ff       	jmp    8010579a <alltraps>

80105d0d <vector22>:
.globl vector22
vector22:
  pushl $0
80105d0d:	6a 00                	push   $0x0
  pushl $22
80105d0f:	6a 16                	push   $0x16
  jmp alltraps
80105d11:	e9 84 fa ff ff       	jmp    8010579a <alltraps>

80105d16 <vector23>:
.globl vector23
vector23:
  pushl $0
80105d16:	6a 00                	push   $0x0
  pushl $23
80105d18:	6a 17                	push   $0x17
  jmp alltraps
80105d1a:	e9 7b fa ff ff       	jmp    8010579a <alltraps>

80105d1f <vector24>:
.globl vector24
vector24:
  pushl $0
80105d1f:	6a 00                	push   $0x0
  pushl $24
80105d21:	6a 18                	push   $0x18
  jmp alltraps
80105d23:	e9 72 fa ff ff       	jmp    8010579a <alltraps>

80105d28 <vector25>:
.globl vector25
vector25:
  pushl $0
80105d28:	6a 00                	push   $0x0
  pushl $25
80105d2a:	6a 19                	push   $0x19
  jmp alltraps
80105d2c:	e9 69 fa ff ff       	jmp    8010579a <alltraps>

80105d31 <vector26>:
.globl vector26
vector26:
  pushl $0
80105d31:	6a 00                	push   $0x0
  pushl $26
80105d33:	6a 1a                	push   $0x1a
  jmp alltraps
80105d35:	e9 60 fa ff ff       	jmp    8010579a <alltraps>

80105d3a <vector27>:
.globl vector27
vector27:
  pushl $0
80105d3a:	6a 00                	push   $0x0
  pushl $27
80105d3c:	6a 1b                	push   $0x1b
  jmp alltraps
80105d3e:	e9 57 fa ff ff       	jmp    8010579a <alltraps>

80105d43 <vector28>:
.globl vector28
vector28:
  pushl $0
80105d43:	6a 00                	push   $0x0
  pushl $28
80105d45:	6a 1c                	push   $0x1c
  jmp alltraps
80105d47:	e9 4e fa ff ff       	jmp    8010579a <alltraps>

80105d4c <vector29>:
.globl vector29
vector29:
  pushl $0
80105d4c:	6a 00                	push   $0x0
  pushl $29
80105d4e:	6a 1d                	push   $0x1d
  jmp alltraps
80105d50:	e9 45 fa ff ff       	jmp    8010579a <alltraps>

80105d55 <vector30>:
.globl vector30
vector30:
  pushl $0
80105d55:	6a 00                	push   $0x0
  pushl $30
80105d57:	6a 1e                	push   $0x1e
  jmp alltraps
80105d59:	e9 3c fa ff ff       	jmp    8010579a <alltraps>

80105d5e <vector31>:
.globl vector31
vector31:
  pushl $0
80105d5e:	6a 00                	push   $0x0
  pushl $31
80105d60:	6a 1f                	push   $0x1f
  jmp alltraps
80105d62:	e9 33 fa ff ff       	jmp    8010579a <alltraps>

80105d67 <vector32>:
.globl vector32
vector32:
  pushl $0
80105d67:	6a 00                	push   $0x0
  pushl $32
80105d69:	6a 20                	push   $0x20
  jmp alltraps
80105d6b:	e9 2a fa ff ff       	jmp    8010579a <alltraps>

80105d70 <vector33>:
.globl vector33
vector33:
  pushl $0
80105d70:	6a 00                	push   $0x0
  pushl $33
80105d72:	6a 21                	push   $0x21
  jmp alltraps
80105d74:	e9 21 fa ff ff       	jmp    8010579a <alltraps>

80105d79 <vector34>:
.globl vector34
vector34:
  pushl $0
80105d79:	6a 00                	push   $0x0
  pushl $34
80105d7b:	6a 22                	push   $0x22
  jmp alltraps
80105d7d:	e9 18 fa ff ff       	jmp    8010579a <alltraps>

80105d82 <vector35>:
.globl vector35
vector35:
  pushl $0
80105d82:	6a 00                	push   $0x0
  pushl $35
80105d84:	6a 23                	push   $0x23
  jmp alltraps
80105d86:	e9 0f fa ff ff       	jmp    8010579a <alltraps>

80105d8b <vector36>:
.globl vector36
vector36:
  pushl $0
80105d8b:	6a 00                	push   $0x0
  pushl $36
80105d8d:	6a 24                	push   $0x24
  jmp alltraps
80105d8f:	e9 06 fa ff ff       	jmp    8010579a <alltraps>

80105d94 <vector37>:
.globl vector37
vector37:
  pushl $0
80105d94:	6a 00                	push   $0x0
  pushl $37
80105d96:	6a 25                	push   $0x25
  jmp alltraps
80105d98:	e9 fd f9 ff ff       	jmp    8010579a <alltraps>

80105d9d <vector38>:
.globl vector38
vector38:
  pushl $0
80105d9d:	6a 00                	push   $0x0
  pushl $38
80105d9f:	6a 26                	push   $0x26
  jmp alltraps
80105da1:	e9 f4 f9 ff ff       	jmp    8010579a <alltraps>

80105da6 <vector39>:
.globl vector39
vector39:
  pushl $0
80105da6:	6a 00                	push   $0x0
  pushl $39
80105da8:	6a 27                	push   $0x27
  jmp alltraps
80105daa:	e9 eb f9 ff ff       	jmp    8010579a <alltraps>

80105daf <vector40>:
.globl vector40
vector40:
  pushl $0
80105daf:	6a 00                	push   $0x0
  pushl $40
80105db1:	6a 28                	push   $0x28
  jmp alltraps
80105db3:	e9 e2 f9 ff ff       	jmp    8010579a <alltraps>

80105db8 <vector41>:
.globl vector41
vector41:
  pushl $0
80105db8:	6a 00                	push   $0x0
  pushl $41
80105dba:	6a 29                	push   $0x29
  jmp alltraps
80105dbc:	e9 d9 f9 ff ff       	jmp    8010579a <alltraps>

80105dc1 <vector42>:
.globl vector42
vector42:
  pushl $0
80105dc1:	6a 00                	push   $0x0
  pushl $42
80105dc3:	6a 2a                	push   $0x2a
  jmp alltraps
80105dc5:	e9 d0 f9 ff ff       	jmp    8010579a <alltraps>

80105dca <vector43>:
.globl vector43
vector43:
  pushl $0
80105dca:	6a 00                	push   $0x0
  pushl $43
80105dcc:	6a 2b                	push   $0x2b
  jmp alltraps
80105dce:	e9 c7 f9 ff ff       	jmp    8010579a <alltraps>

80105dd3 <vector44>:
.globl vector44
vector44:
  pushl $0
80105dd3:	6a 00                	push   $0x0
  pushl $44
80105dd5:	6a 2c                	push   $0x2c
  jmp alltraps
80105dd7:	e9 be f9 ff ff       	jmp    8010579a <alltraps>

80105ddc <vector45>:
.globl vector45
vector45:
  pushl $0
80105ddc:	6a 00                	push   $0x0
  pushl $45
80105dde:	6a 2d                	push   $0x2d
  jmp alltraps
80105de0:	e9 b5 f9 ff ff       	jmp    8010579a <alltraps>

80105de5 <vector46>:
.globl vector46
vector46:
  pushl $0
80105de5:	6a 00                	push   $0x0
  pushl $46
80105de7:	6a 2e                	push   $0x2e
  jmp alltraps
80105de9:	e9 ac f9 ff ff       	jmp    8010579a <alltraps>

80105dee <vector47>:
.globl vector47
vector47:
  pushl $0
80105dee:	6a 00                	push   $0x0
  pushl $47
80105df0:	6a 2f                	push   $0x2f
  jmp alltraps
80105df2:	e9 a3 f9 ff ff       	jmp    8010579a <alltraps>

80105df7 <vector48>:
.globl vector48
vector48:
  pushl $0
80105df7:	6a 00                	push   $0x0
  pushl $48
80105df9:	6a 30                	push   $0x30
  jmp alltraps
80105dfb:	e9 9a f9 ff ff       	jmp    8010579a <alltraps>

80105e00 <vector49>:
.globl vector49
vector49:
  pushl $0
80105e00:	6a 00                	push   $0x0
  pushl $49
80105e02:	6a 31                	push   $0x31
  jmp alltraps
80105e04:	e9 91 f9 ff ff       	jmp    8010579a <alltraps>

80105e09 <vector50>:
.globl vector50
vector50:
  pushl $0
80105e09:	6a 00                	push   $0x0
  pushl $50
80105e0b:	6a 32                	push   $0x32
  jmp alltraps
80105e0d:	e9 88 f9 ff ff       	jmp    8010579a <alltraps>

80105e12 <vector51>:
.globl vector51
vector51:
  pushl $0
80105e12:	6a 00                	push   $0x0
  pushl $51
80105e14:	6a 33                	push   $0x33
  jmp alltraps
80105e16:	e9 7f f9 ff ff       	jmp    8010579a <alltraps>

80105e1b <vector52>:
.globl vector52
vector52:
  pushl $0
80105e1b:	6a 00                	push   $0x0
  pushl $52
80105e1d:	6a 34                	push   $0x34
  jmp alltraps
80105e1f:	e9 76 f9 ff ff       	jmp    8010579a <alltraps>

80105e24 <vector53>:
.globl vector53
vector53:
  pushl $0
80105e24:	6a 00                	push   $0x0
  pushl $53
80105e26:	6a 35                	push   $0x35
  jmp alltraps
80105e28:	e9 6d f9 ff ff       	jmp    8010579a <alltraps>

80105e2d <vector54>:
.globl vector54
vector54:
  pushl $0
80105e2d:	6a 00                	push   $0x0
  pushl $54
80105e2f:	6a 36                	push   $0x36
  jmp alltraps
80105e31:	e9 64 f9 ff ff       	jmp    8010579a <alltraps>

80105e36 <vector55>:
.globl vector55
vector55:
  pushl $0
80105e36:	6a 00                	push   $0x0
  pushl $55
80105e38:	6a 37                	push   $0x37
  jmp alltraps
80105e3a:	e9 5b f9 ff ff       	jmp    8010579a <alltraps>

80105e3f <vector56>:
.globl vector56
vector56:
  pushl $0
80105e3f:	6a 00                	push   $0x0
  pushl $56
80105e41:	6a 38                	push   $0x38
  jmp alltraps
80105e43:	e9 52 f9 ff ff       	jmp    8010579a <alltraps>

80105e48 <vector57>:
.globl vector57
vector57:
  pushl $0
80105e48:	6a 00                	push   $0x0
  pushl $57
80105e4a:	6a 39                	push   $0x39
  jmp alltraps
80105e4c:	e9 49 f9 ff ff       	jmp    8010579a <alltraps>

80105e51 <vector58>:
.globl vector58
vector58:
  pushl $0
80105e51:	6a 00                	push   $0x0
  pushl $58
80105e53:	6a 3a                	push   $0x3a
  jmp alltraps
80105e55:	e9 40 f9 ff ff       	jmp    8010579a <alltraps>

80105e5a <vector59>:
.globl vector59
vector59:
  pushl $0
80105e5a:	6a 00                	push   $0x0
  pushl $59
80105e5c:	6a 3b                	push   $0x3b
  jmp alltraps
80105e5e:	e9 37 f9 ff ff       	jmp    8010579a <alltraps>

80105e63 <vector60>:
.globl vector60
vector60:
  pushl $0
80105e63:	6a 00                	push   $0x0
  pushl $60
80105e65:	6a 3c                	push   $0x3c
  jmp alltraps
80105e67:	e9 2e f9 ff ff       	jmp    8010579a <alltraps>

80105e6c <vector61>:
.globl vector61
vector61:
  pushl $0
80105e6c:	6a 00                	push   $0x0
  pushl $61
80105e6e:	6a 3d                	push   $0x3d
  jmp alltraps
80105e70:	e9 25 f9 ff ff       	jmp    8010579a <alltraps>

80105e75 <vector62>:
.globl vector62
vector62:
  pushl $0
80105e75:	6a 00                	push   $0x0
  pushl $62
80105e77:	6a 3e                	push   $0x3e
  jmp alltraps
80105e79:	e9 1c f9 ff ff       	jmp    8010579a <alltraps>

80105e7e <vector63>:
.globl vector63
vector63:
  pushl $0
80105e7e:	6a 00                	push   $0x0
  pushl $63
80105e80:	6a 3f                	push   $0x3f
  jmp alltraps
80105e82:	e9 13 f9 ff ff       	jmp    8010579a <alltraps>

80105e87 <vector64>:
.globl vector64
vector64:
  pushl $0
80105e87:	6a 00                	push   $0x0
  pushl $64
80105e89:	6a 40                	push   $0x40
  jmp alltraps
80105e8b:	e9 0a f9 ff ff       	jmp    8010579a <alltraps>

80105e90 <vector65>:
.globl vector65
vector65:
  pushl $0
80105e90:	6a 00                	push   $0x0
  pushl $65
80105e92:	6a 41                	push   $0x41
  jmp alltraps
80105e94:	e9 01 f9 ff ff       	jmp    8010579a <alltraps>

80105e99 <vector66>:
.globl vector66
vector66:
  pushl $0
80105e99:	6a 00                	push   $0x0
  pushl $66
80105e9b:	6a 42                	push   $0x42
  jmp alltraps
80105e9d:	e9 f8 f8 ff ff       	jmp    8010579a <alltraps>

80105ea2 <vector67>:
.globl vector67
vector67:
  pushl $0
80105ea2:	6a 00                	push   $0x0
  pushl $67
80105ea4:	6a 43                	push   $0x43
  jmp alltraps
80105ea6:	e9 ef f8 ff ff       	jmp    8010579a <alltraps>

80105eab <vector68>:
.globl vector68
vector68:
  pushl $0
80105eab:	6a 00                	push   $0x0
  pushl $68
80105ead:	6a 44                	push   $0x44
  jmp alltraps
80105eaf:	e9 e6 f8 ff ff       	jmp    8010579a <alltraps>

80105eb4 <vector69>:
.globl vector69
vector69:
  pushl $0
80105eb4:	6a 00                	push   $0x0
  pushl $69
80105eb6:	6a 45                	push   $0x45
  jmp alltraps
80105eb8:	e9 dd f8 ff ff       	jmp    8010579a <alltraps>

80105ebd <vector70>:
.globl vector70
vector70:
  pushl $0
80105ebd:	6a 00                	push   $0x0
  pushl $70
80105ebf:	6a 46                	push   $0x46
  jmp alltraps
80105ec1:	e9 d4 f8 ff ff       	jmp    8010579a <alltraps>

80105ec6 <vector71>:
.globl vector71
vector71:
  pushl $0
80105ec6:	6a 00                	push   $0x0
  pushl $71
80105ec8:	6a 47                	push   $0x47
  jmp alltraps
80105eca:	e9 cb f8 ff ff       	jmp    8010579a <alltraps>

80105ecf <vector72>:
.globl vector72
vector72:
  pushl $0
80105ecf:	6a 00                	push   $0x0
  pushl $72
80105ed1:	6a 48                	push   $0x48
  jmp alltraps
80105ed3:	e9 c2 f8 ff ff       	jmp    8010579a <alltraps>

80105ed8 <vector73>:
.globl vector73
vector73:
  pushl $0
80105ed8:	6a 00                	push   $0x0
  pushl $73
80105eda:	6a 49                	push   $0x49
  jmp alltraps
80105edc:	e9 b9 f8 ff ff       	jmp    8010579a <alltraps>

80105ee1 <vector74>:
.globl vector74
vector74:
  pushl $0
80105ee1:	6a 00                	push   $0x0
  pushl $74
80105ee3:	6a 4a                	push   $0x4a
  jmp alltraps
80105ee5:	e9 b0 f8 ff ff       	jmp    8010579a <alltraps>

80105eea <vector75>:
.globl vector75
vector75:
  pushl $0
80105eea:	6a 00                	push   $0x0
  pushl $75
80105eec:	6a 4b                	push   $0x4b
  jmp alltraps
80105eee:	e9 a7 f8 ff ff       	jmp    8010579a <alltraps>

80105ef3 <vector76>:
.globl vector76
vector76:
  pushl $0
80105ef3:	6a 00                	push   $0x0
  pushl $76
80105ef5:	6a 4c                	push   $0x4c
  jmp alltraps
80105ef7:	e9 9e f8 ff ff       	jmp    8010579a <alltraps>

80105efc <vector77>:
.globl vector77
vector77:
  pushl $0
80105efc:	6a 00                	push   $0x0
  pushl $77
80105efe:	6a 4d                	push   $0x4d
  jmp alltraps
80105f00:	e9 95 f8 ff ff       	jmp    8010579a <alltraps>

80105f05 <vector78>:
.globl vector78
vector78:
  pushl $0
80105f05:	6a 00                	push   $0x0
  pushl $78
80105f07:	6a 4e                	push   $0x4e
  jmp alltraps
80105f09:	e9 8c f8 ff ff       	jmp    8010579a <alltraps>

80105f0e <vector79>:
.globl vector79
vector79:
  pushl $0
80105f0e:	6a 00                	push   $0x0
  pushl $79
80105f10:	6a 4f                	push   $0x4f
  jmp alltraps
80105f12:	e9 83 f8 ff ff       	jmp    8010579a <alltraps>

80105f17 <vector80>:
.globl vector80
vector80:
  pushl $0
80105f17:	6a 00                	push   $0x0
  pushl $80
80105f19:	6a 50                	push   $0x50
  jmp alltraps
80105f1b:	e9 7a f8 ff ff       	jmp    8010579a <alltraps>

80105f20 <vector81>:
.globl vector81
vector81:
  pushl $0
80105f20:	6a 00                	push   $0x0
  pushl $81
80105f22:	6a 51                	push   $0x51
  jmp alltraps
80105f24:	e9 71 f8 ff ff       	jmp    8010579a <alltraps>

80105f29 <vector82>:
.globl vector82
vector82:
  pushl $0
80105f29:	6a 00                	push   $0x0
  pushl $82
80105f2b:	6a 52                	push   $0x52
  jmp alltraps
80105f2d:	e9 68 f8 ff ff       	jmp    8010579a <alltraps>

80105f32 <vector83>:
.globl vector83
vector83:
  pushl $0
80105f32:	6a 00                	push   $0x0
  pushl $83
80105f34:	6a 53                	push   $0x53
  jmp alltraps
80105f36:	e9 5f f8 ff ff       	jmp    8010579a <alltraps>

80105f3b <vector84>:
.globl vector84
vector84:
  pushl $0
80105f3b:	6a 00                	push   $0x0
  pushl $84
80105f3d:	6a 54                	push   $0x54
  jmp alltraps
80105f3f:	e9 56 f8 ff ff       	jmp    8010579a <alltraps>

80105f44 <vector85>:
.globl vector85
vector85:
  pushl $0
80105f44:	6a 00                	push   $0x0
  pushl $85
80105f46:	6a 55                	push   $0x55
  jmp alltraps
80105f48:	e9 4d f8 ff ff       	jmp    8010579a <alltraps>

80105f4d <vector86>:
.globl vector86
vector86:
  pushl $0
80105f4d:	6a 00                	push   $0x0
  pushl $86
80105f4f:	6a 56                	push   $0x56
  jmp alltraps
80105f51:	e9 44 f8 ff ff       	jmp    8010579a <alltraps>

80105f56 <vector87>:
.globl vector87
vector87:
  pushl $0
80105f56:	6a 00                	push   $0x0
  pushl $87
80105f58:	6a 57                	push   $0x57
  jmp alltraps
80105f5a:	e9 3b f8 ff ff       	jmp    8010579a <alltraps>

80105f5f <vector88>:
.globl vector88
vector88:
  pushl $0
80105f5f:	6a 00                	push   $0x0
  pushl $88
80105f61:	6a 58                	push   $0x58
  jmp alltraps
80105f63:	e9 32 f8 ff ff       	jmp    8010579a <alltraps>

80105f68 <vector89>:
.globl vector89
vector89:
  pushl $0
80105f68:	6a 00                	push   $0x0
  pushl $89
80105f6a:	6a 59                	push   $0x59
  jmp alltraps
80105f6c:	e9 29 f8 ff ff       	jmp    8010579a <alltraps>

80105f71 <vector90>:
.globl vector90
vector90:
  pushl $0
80105f71:	6a 00                	push   $0x0
  pushl $90
80105f73:	6a 5a                	push   $0x5a
  jmp alltraps
80105f75:	e9 20 f8 ff ff       	jmp    8010579a <alltraps>

80105f7a <vector91>:
.globl vector91
vector91:
  pushl $0
80105f7a:	6a 00                	push   $0x0
  pushl $91
80105f7c:	6a 5b                	push   $0x5b
  jmp alltraps
80105f7e:	e9 17 f8 ff ff       	jmp    8010579a <alltraps>

80105f83 <vector92>:
.globl vector92
vector92:
  pushl $0
80105f83:	6a 00                	push   $0x0
  pushl $92
80105f85:	6a 5c                	push   $0x5c
  jmp alltraps
80105f87:	e9 0e f8 ff ff       	jmp    8010579a <alltraps>

80105f8c <vector93>:
.globl vector93
vector93:
  pushl $0
80105f8c:	6a 00                	push   $0x0
  pushl $93
80105f8e:	6a 5d                	push   $0x5d
  jmp alltraps
80105f90:	e9 05 f8 ff ff       	jmp    8010579a <alltraps>

80105f95 <vector94>:
.globl vector94
vector94:
  pushl $0
80105f95:	6a 00                	push   $0x0
  pushl $94
80105f97:	6a 5e                	push   $0x5e
  jmp alltraps
80105f99:	e9 fc f7 ff ff       	jmp    8010579a <alltraps>

80105f9e <vector95>:
.globl vector95
vector95:
  pushl $0
80105f9e:	6a 00                	push   $0x0
  pushl $95
80105fa0:	6a 5f                	push   $0x5f
  jmp alltraps
80105fa2:	e9 f3 f7 ff ff       	jmp    8010579a <alltraps>

80105fa7 <vector96>:
.globl vector96
vector96:
  pushl $0
80105fa7:	6a 00                	push   $0x0
  pushl $96
80105fa9:	6a 60                	push   $0x60
  jmp alltraps
80105fab:	e9 ea f7 ff ff       	jmp    8010579a <alltraps>

80105fb0 <vector97>:
.globl vector97
vector97:
  pushl $0
80105fb0:	6a 00                	push   $0x0
  pushl $97
80105fb2:	6a 61                	push   $0x61
  jmp alltraps
80105fb4:	e9 e1 f7 ff ff       	jmp    8010579a <alltraps>

80105fb9 <vector98>:
.globl vector98
vector98:
  pushl $0
80105fb9:	6a 00                	push   $0x0
  pushl $98
80105fbb:	6a 62                	push   $0x62
  jmp alltraps
80105fbd:	e9 d8 f7 ff ff       	jmp    8010579a <alltraps>

80105fc2 <vector99>:
.globl vector99
vector99:
  pushl $0
80105fc2:	6a 00                	push   $0x0
  pushl $99
80105fc4:	6a 63                	push   $0x63
  jmp alltraps
80105fc6:	e9 cf f7 ff ff       	jmp    8010579a <alltraps>

80105fcb <vector100>:
.globl vector100
vector100:
  pushl $0
80105fcb:	6a 00                	push   $0x0
  pushl $100
80105fcd:	6a 64                	push   $0x64
  jmp alltraps
80105fcf:	e9 c6 f7 ff ff       	jmp    8010579a <alltraps>

80105fd4 <vector101>:
.globl vector101
vector101:
  pushl $0
80105fd4:	6a 00                	push   $0x0
  pushl $101
80105fd6:	6a 65                	push   $0x65
  jmp alltraps
80105fd8:	e9 bd f7 ff ff       	jmp    8010579a <alltraps>

80105fdd <vector102>:
.globl vector102
vector102:
  pushl $0
80105fdd:	6a 00                	push   $0x0
  pushl $102
80105fdf:	6a 66                	push   $0x66
  jmp alltraps
80105fe1:	e9 b4 f7 ff ff       	jmp    8010579a <alltraps>

80105fe6 <vector103>:
.globl vector103
vector103:
  pushl $0
80105fe6:	6a 00                	push   $0x0
  pushl $103
80105fe8:	6a 67                	push   $0x67
  jmp alltraps
80105fea:	e9 ab f7 ff ff       	jmp    8010579a <alltraps>

80105fef <vector104>:
.globl vector104
vector104:
  pushl $0
80105fef:	6a 00                	push   $0x0
  pushl $104
80105ff1:	6a 68                	push   $0x68
  jmp alltraps
80105ff3:	e9 a2 f7 ff ff       	jmp    8010579a <alltraps>

80105ff8 <vector105>:
.globl vector105
vector105:
  pushl $0
80105ff8:	6a 00                	push   $0x0
  pushl $105
80105ffa:	6a 69                	push   $0x69
  jmp alltraps
80105ffc:	e9 99 f7 ff ff       	jmp    8010579a <alltraps>

80106001 <vector106>:
.globl vector106
vector106:
  pushl $0
80106001:	6a 00                	push   $0x0
  pushl $106
80106003:	6a 6a                	push   $0x6a
  jmp alltraps
80106005:	e9 90 f7 ff ff       	jmp    8010579a <alltraps>

8010600a <vector107>:
.globl vector107
vector107:
  pushl $0
8010600a:	6a 00                	push   $0x0
  pushl $107
8010600c:	6a 6b                	push   $0x6b
  jmp alltraps
8010600e:	e9 87 f7 ff ff       	jmp    8010579a <alltraps>

80106013 <vector108>:
.globl vector108
vector108:
  pushl $0
80106013:	6a 00                	push   $0x0
  pushl $108
80106015:	6a 6c                	push   $0x6c
  jmp alltraps
80106017:	e9 7e f7 ff ff       	jmp    8010579a <alltraps>

8010601c <vector109>:
.globl vector109
vector109:
  pushl $0
8010601c:	6a 00                	push   $0x0
  pushl $109
8010601e:	6a 6d                	push   $0x6d
  jmp alltraps
80106020:	e9 75 f7 ff ff       	jmp    8010579a <alltraps>

80106025 <vector110>:
.globl vector110
vector110:
  pushl $0
80106025:	6a 00                	push   $0x0
  pushl $110
80106027:	6a 6e                	push   $0x6e
  jmp alltraps
80106029:	e9 6c f7 ff ff       	jmp    8010579a <alltraps>

8010602e <vector111>:
.globl vector111
vector111:
  pushl $0
8010602e:	6a 00                	push   $0x0
  pushl $111
80106030:	6a 6f                	push   $0x6f
  jmp alltraps
80106032:	e9 63 f7 ff ff       	jmp    8010579a <alltraps>

80106037 <vector112>:
.globl vector112
vector112:
  pushl $0
80106037:	6a 00                	push   $0x0
  pushl $112
80106039:	6a 70                	push   $0x70
  jmp alltraps
8010603b:	e9 5a f7 ff ff       	jmp    8010579a <alltraps>

80106040 <vector113>:
.globl vector113
vector113:
  pushl $0
80106040:	6a 00                	push   $0x0
  pushl $113
80106042:	6a 71                	push   $0x71
  jmp alltraps
80106044:	e9 51 f7 ff ff       	jmp    8010579a <alltraps>

80106049 <vector114>:
.globl vector114
vector114:
  pushl $0
80106049:	6a 00                	push   $0x0
  pushl $114
8010604b:	6a 72                	push   $0x72
  jmp alltraps
8010604d:	e9 48 f7 ff ff       	jmp    8010579a <alltraps>

80106052 <vector115>:
.globl vector115
vector115:
  pushl $0
80106052:	6a 00                	push   $0x0
  pushl $115
80106054:	6a 73                	push   $0x73
  jmp alltraps
80106056:	e9 3f f7 ff ff       	jmp    8010579a <alltraps>

8010605b <vector116>:
.globl vector116
vector116:
  pushl $0
8010605b:	6a 00                	push   $0x0
  pushl $116
8010605d:	6a 74                	push   $0x74
  jmp alltraps
8010605f:	e9 36 f7 ff ff       	jmp    8010579a <alltraps>

80106064 <vector117>:
.globl vector117
vector117:
  pushl $0
80106064:	6a 00                	push   $0x0
  pushl $117
80106066:	6a 75                	push   $0x75
  jmp alltraps
80106068:	e9 2d f7 ff ff       	jmp    8010579a <alltraps>

8010606d <vector118>:
.globl vector118
vector118:
  pushl $0
8010606d:	6a 00                	push   $0x0
  pushl $118
8010606f:	6a 76                	push   $0x76
  jmp alltraps
80106071:	e9 24 f7 ff ff       	jmp    8010579a <alltraps>

80106076 <vector119>:
.globl vector119
vector119:
  pushl $0
80106076:	6a 00                	push   $0x0
  pushl $119
80106078:	6a 77                	push   $0x77
  jmp alltraps
8010607a:	e9 1b f7 ff ff       	jmp    8010579a <alltraps>

8010607f <vector120>:
.globl vector120
vector120:
  pushl $0
8010607f:	6a 00                	push   $0x0
  pushl $120
80106081:	6a 78                	push   $0x78
  jmp alltraps
80106083:	e9 12 f7 ff ff       	jmp    8010579a <alltraps>

80106088 <vector121>:
.globl vector121
vector121:
  pushl $0
80106088:	6a 00                	push   $0x0
  pushl $121
8010608a:	6a 79                	push   $0x79
  jmp alltraps
8010608c:	e9 09 f7 ff ff       	jmp    8010579a <alltraps>

80106091 <vector122>:
.globl vector122
vector122:
  pushl $0
80106091:	6a 00                	push   $0x0
  pushl $122
80106093:	6a 7a                	push   $0x7a
  jmp alltraps
80106095:	e9 00 f7 ff ff       	jmp    8010579a <alltraps>

8010609a <vector123>:
.globl vector123
vector123:
  pushl $0
8010609a:	6a 00                	push   $0x0
  pushl $123
8010609c:	6a 7b                	push   $0x7b
  jmp alltraps
8010609e:	e9 f7 f6 ff ff       	jmp    8010579a <alltraps>

801060a3 <vector124>:
.globl vector124
vector124:
  pushl $0
801060a3:	6a 00                	push   $0x0
  pushl $124
801060a5:	6a 7c                	push   $0x7c
  jmp alltraps
801060a7:	e9 ee f6 ff ff       	jmp    8010579a <alltraps>

801060ac <vector125>:
.globl vector125
vector125:
  pushl $0
801060ac:	6a 00                	push   $0x0
  pushl $125
801060ae:	6a 7d                	push   $0x7d
  jmp alltraps
801060b0:	e9 e5 f6 ff ff       	jmp    8010579a <alltraps>

801060b5 <vector126>:
.globl vector126
vector126:
  pushl $0
801060b5:	6a 00                	push   $0x0
  pushl $126
801060b7:	6a 7e                	push   $0x7e
  jmp alltraps
801060b9:	e9 dc f6 ff ff       	jmp    8010579a <alltraps>

801060be <vector127>:
.globl vector127
vector127:
  pushl $0
801060be:	6a 00                	push   $0x0
  pushl $127
801060c0:	6a 7f                	push   $0x7f
  jmp alltraps
801060c2:	e9 d3 f6 ff ff       	jmp    8010579a <alltraps>

801060c7 <vector128>:
.globl vector128
vector128:
  pushl $0
801060c7:	6a 00                	push   $0x0
  pushl $128
801060c9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801060ce:	e9 c7 f6 ff ff       	jmp    8010579a <alltraps>

801060d3 <vector129>:
.globl vector129
vector129:
  pushl $0
801060d3:	6a 00                	push   $0x0
  pushl $129
801060d5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801060da:	e9 bb f6 ff ff       	jmp    8010579a <alltraps>

801060df <vector130>:
.globl vector130
vector130:
  pushl $0
801060df:	6a 00                	push   $0x0
  pushl $130
801060e1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801060e6:	e9 af f6 ff ff       	jmp    8010579a <alltraps>

801060eb <vector131>:
.globl vector131
vector131:
  pushl $0
801060eb:	6a 00                	push   $0x0
  pushl $131
801060ed:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801060f2:	e9 a3 f6 ff ff       	jmp    8010579a <alltraps>

801060f7 <vector132>:
.globl vector132
vector132:
  pushl $0
801060f7:	6a 00                	push   $0x0
  pushl $132
801060f9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801060fe:	e9 97 f6 ff ff       	jmp    8010579a <alltraps>

80106103 <vector133>:
.globl vector133
vector133:
  pushl $0
80106103:	6a 00                	push   $0x0
  pushl $133
80106105:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010610a:	e9 8b f6 ff ff       	jmp    8010579a <alltraps>

8010610f <vector134>:
.globl vector134
vector134:
  pushl $0
8010610f:	6a 00                	push   $0x0
  pushl $134
80106111:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106116:	e9 7f f6 ff ff       	jmp    8010579a <alltraps>

8010611b <vector135>:
.globl vector135
vector135:
  pushl $0
8010611b:	6a 00                	push   $0x0
  pushl $135
8010611d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106122:	e9 73 f6 ff ff       	jmp    8010579a <alltraps>

80106127 <vector136>:
.globl vector136
vector136:
  pushl $0
80106127:	6a 00                	push   $0x0
  pushl $136
80106129:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010612e:	e9 67 f6 ff ff       	jmp    8010579a <alltraps>

80106133 <vector137>:
.globl vector137
vector137:
  pushl $0
80106133:	6a 00                	push   $0x0
  pushl $137
80106135:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010613a:	e9 5b f6 ff ff       	jmp    8010579a <alltraps>

8010613f <vector138>:
.globl vector138
vector138:
  pushl $0
8010613f:	6a 00                	push   $0x0
  pushl $138
80106141:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106146:	e9 4f f6 ff ff       	jmp    8010579a <alltraps>

8010614b <vector139>:
.globl vector139
vector139:
  pushl $0
8010614b:	6a 00                	push   $0x0
  pushl $139
8010614d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106152:	e9 43 f6 ff ff       	jmp    8010579a <alltraps>

80106157 <vector140>:
.globl vector140
vector140:
  pushl $0
80106157:	6a 00                	push   $0x0
  pushl $140
80106159:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010615e:	e9 37 f6 ff ff       	jmp    8010579a <alltraps>

80106163 <vector141>:
.globl vector141
vector141:
  pushl $0
80106163:	6a 00                	push   $0x0
  pushl $141
80106165:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010616a:	e9 2b f6 ff ff       	jmp    8010579a <alltraps>

8010616f <vector142>:
.globl vector142
vector142:
  pushl $0
8010616f:	6a 00                	push   $0x0
  pushl $142
80106171:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106176:	e9 1f f6 ff ff       	jmp    8010579a <alltraps>

8010617b <vector143>:
.globl vector143
vector143:
  pushl $0
8010617b:	6a 00                	push   $0x0
  pushl $143
8010617d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106182:	e9 13 f6 ff ff       	jmp    8010579a <alltraps>

80106187 <vector144>:
.globl vector144
vector144:
  pushl $0
80106187:	6a 00                	push   $0x0
  pushl $144
80106189:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010618e:	e9 07 f6 ff ff       	jmp    8010579a <alltraps>

80106193 <vector145>:
.globl vector145
vector145:
  pushl $0
80106193:	6a 00                	push   $0x0
  pushl $145
80106195:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010619a:	e9 fb f5 ff ff       	jmp    8010579a <alltraps>

8010619f <vector146>:
.globl vector146
vector146:
  pushl $0
8010619f:	6a 00                	push   $0x0
  pushl $146
801061a1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801061a6:	e9 ef f5 ff ff       	jmp    8010579a <alltraps>

801061ab <vector147>:
.globl vector147
vector147:
  pushl $0
801061ab:	6a 00                	push   $0x0
  pushl $147
801061ad:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801061b2:	e9 e3 f5 ff ff       	jmp    8010579a <alltraps>

801061b7 <vector148>:
.globl vector148
vector148:
  pushl $0
801061b7:	6a 00                	push   $0x0
  pushl $148
801061b9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801061be:	e9 d7 f5 ff ff       	jmp    8010579a <alltraps>

801061c3 <vector149>:
.globl vector149
vector149:
  pushl $0
801061c3:	6a 00                	push   $0x0
  pushl $149
801061c5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801061ca:	e9 cb f5 ff ff       	jmp    8010579a <alltraps>

801061cf <vector150>:
.globl vector150
vector150:
  pushl $0
801061cf:	6a 00                	push   $0x0
  pushl $150
801061d1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801061d6:	e9 bf f5 ff ff       	jmp    8010579a <alltraps>

801061db <vector151>:
.globl vector151
vector151:
  pushl $0
801061db:	6a 00                	push   $0x0
  pushl $151
801061dd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801061e2:	e9 b3 f5 ff ff       	jmp    8010579a <alltraps>

801061e7 <vector152>:
.globl vector152
vector152:
  pushl $0
801061e7:	6a 00                	push   $0x0
  pushl $152
801061e9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801061ee:	e9 a7 f5 ff ff       	jmp    8010579a <alltraps>

801061f3 <vector153>:
.globl vector153
vector153:
  pushl $0
801061f3:	6a 00                	push   $0x0
  pushl $153
801061f5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801061fa:	e9 9b f5 ff ff       	jmp    8010579a <alltraps>

801061ff <vector154>:
.globl vector154
vector154:
  pushl $0
801061ff:	6a 00                	push   $0x0
  pushl $154
80106201:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106206:	e9 8f f5 ff ff       	jmp    8010579a <alltraps>

8010620b <vector155>:
.globl vector155
vector155:
  pushl $0
8010620b:	6a 00                	push   $0x0
  pushl $155
8010620d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106212:	e9 83 f5 ff ff       	jmp    8010579a <alltraps>

80106217 <vector156>:
.globl vector156
vector156:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $156
80106219:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010621e:	e9 77 f5 ff ff       	jmp    8010579a <alltraps>

80106223 <vector157>:
.globl vector157
vector157:
  pushl $0
80106223:	6a 00                	push   $0x0
  pushl $157
80106225:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010622a:	e9 6b f5 ff ff       	jmp    8010579a <alltraps>

8010622f <vector158>:
.globl vector158
vector158:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $158
80106231:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106236:	e9 5f f5 ff ff       	jmp    8010579a <alltraps>

8010623b <vector159>:
.globl vector159
vector159:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $159
8010623d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106242:	e9 53 f5 ff ff       	jmp    8010579a <alltraps>

80106247 <vector160>:
.globl vector160
vector160:
  pushl $0
80106247:	6a 00                	push   $0x0
  pushl $160
80106249:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010624e:	e9 47 f5 ff ff       	jmp    8010579a <alltraps>

80106253 <vector161>:
.globl vector161
vector161:
  pushl $0
80106253:	6a 00                	push   $0x0
  pushl $161
80106255:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010625a:	e9 3b f5 ff ff       	jmp    8010579a <alltraps>

8010625f <vector162>:
.globl vector162
vector162:
  pushl $0
8010625f:	6a 00                	push   $0x0
  pushl $162
80106261:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106266:	e9 2f f5 ff ff       	jmp    8010579a <alltraps>

8010626b <vector163>:
.globl vector163
vector163:
  pushl $0
8010626b:	6a 00                	push   $0x0
  pushl $163
8010626d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106272:	e9 23 f5 ff ff       	jmp    8010579a <alltraps>

80106277 <vector164>:
.globl vector164
vector164:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $164
80106279:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010627e:	e9 17 f5 ff ff       	jmp    8010579a <alltraps>

80106283 <vector165>:
.globl vector165
vector165:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $165
80106285:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010628a:	e9 0b f5 ff ff       	jmp    8010579a <alltraps>

8010628f <vector166>:
.globl vector166
vector166:
  pushl $0
8010628f:	6a 00                	push   $0x0
  pushl $166
80106291:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106296:	e9 ff f4 ff ff       	jmp    8010579a <alltraps>

8010629b <vector167>:
.globl vector167
vector167:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $167
8010629d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801062a2:	e9 f3 f4 ff ff       	jmp    8010579a <alltraps>

801062a7 <vector168>:
.globl vector168
vector168:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $168
801062a9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801062ae:	e9 e7 f4 ff ff       	jmp    8010579a <alltraps>

801062b3 <vector169>:
.globl vector169
vector169:
  pushl $0
801062b3:	6a 00                	push   $0x0
  pushl $169
801062b5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801062ba:	e9 db f4 ff ff       	jmp    8010579a <alltraps>

801062bf <vector170>:
.globl vector170
vector170:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $170
801062c1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801062c6:	e9 cf f4 ff ff       	jmp    8010579a <alltraps>

801062cb <vector171>:
.globl vector171
vector171:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $171
801062cd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801062d2:	e9 c3 f4 ff ff       	jmp    8010579a <alltraps>

801062d7 <vector172>:
.globl vector172
vector172:
  pushl $0
801062d7:	6a 00                	push   $0x0
  pushl $172
801062d9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801062de:	e9 b7 f4 ff ff       	jmp    8010579a <alltraps>

801062e3 <vector173>:
.globl vector173
vector173:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $173
801062e5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801062ea:	e9 ab f4 ff ff       	jmp    8010579a <alltraps>

801062ef <vector174>:
.globl vector174
vector174:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $174
801062f1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801062f6:	e9 9f f4 ff ff       	jmp    8010579a <alltraps>

801062fb <vector175>:
.globl vector175
vector175:
  pushl $0
801062fb:	6a 00                	push   $0x0
  pushl $175
801062fd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106302:	e9 93 f4 ff ff       	jmp    8010579a <alltraps>

80106307 <vector176>:
.globl vector176
vector176:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $176
80106309:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010630e:	e9 87 f4 ff ff       	jmp    8010579a <alltraps>

80106313 <vector177>:
.globl vector177
vector177:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $177
80106315:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010631a:	e9 7b f4 ff ff       	jmp    8010579a <alltraps>

8010631f <vector178>:
.globl vector178
vector178:
  pushl $0
8010631f:	6a 00                	push   $0x0
  pushl $178
80106321:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106326:	e9 6f f4 ff ff       	jmp    8010579a <alltraps>

8010632b <vector179>:
.globl vector179
vector179:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $179
8010632d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106332:	e9 63 f4 ff ff       	jmp    8010579a <alltraps>

80106337 <vector180>:
.globl vector180
vector180:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $180
80106339:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010633e:	e9 57 f4 ff ff       	jmp    8010579a <alltraps>

80106343 <vector181>:
.globl vector181
vector181:
  pushl $0
80106343:	6a 00                	push   $0x0
  pushl $181
80106345:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010634a:	e9 4b f4 ff ff       	jmp    8010579a <alltraps>

8010634f <vector182>:
.globl vector182
vector182:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $182
80106351:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106356:	e9 3f f4 ff ff       	jmp    8010579a <alltraps>

8010635b <vector183>:
.globl vector183
vector183:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $183
8010635d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106362:	e9 33 f4 ff ff       	jmp    8010579a <alltraps>

80106367 <vector184>:
.globl vector184
vector184:
  pushl $0
80106367:	6a 00                	push   $0x0
  pushl $184
80106369:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010636e:	e9 27 f4 ff ff       	jmp    8010579a <alltraps>

80106373 <vector185>:
.globl vector185
vector185:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $185
80106375:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010637a:	e9 1b f4 ff ff       	jmp    8010579a <alltraps>

8010637f <vector186>:
.globl vector186
vector186:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $186
80106381:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106386:	e9 0f f4 ff ff       	jmp    8010579a <alltraps>

8010638b <vector187>:
.globl vector187
vector187:
  pushl $0
8010638b:	6a 00                	push   $0x0
  pushl $187
8010638d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106392:	e9 03 f4 ff ff       	jmp    8010579a <alltraps>

80106397 <vector188>:
.globl vector188
vector188:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $188
80106399:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010639e:	e9 f7 f3 ff ff       	jmp    8010579a <alltraps>

801063a3 <vector189>:
.globl vector189
vector189:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $189
801063a5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801063aa:	e9 eb f3 ff ff       	jmp    8010579a <alltraps>

801063af <vector190>:
.globl vector190
vector190:
  pushl $0
801063af:	6a 00                	push   $0x0
  pushl $190
801063b1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801063b6:	e9 df f3 ff ff       	jmp    8010579a <alltraps>

801063bb <vector191>:
.globl vector191
vector191:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $191
801063bd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801063c2:	e9 d3 f3 ff ff       	jmp    8010579a <alltraps>

801063c7 <vector192>:
.globl vector192
vector192:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $192
801063c9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801063ce:	e9 c7 f3 ff ff       	jmp    8010579a <alltraps>

801063d3 <vector193>:
.globl vector193
vector193:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $193
801063d5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801063da:	e9 bb f3 ff ff       	jmp    8010579a <alltraps>

801063df <vector194>:
.globl vector194
vector194:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $194
801063e1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801063e6:	e9 af f3 ff ff       	jmp    8010579a <alltraps>

801063eb <vector195>:
.globl vector195
vector195:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $195
801063ed:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801063f2:	e9 a3 f3 ff ff       	jmp    8010579a <alltraps>

801063f7 <vector196>:
.globl vector196
vector196:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $196
801063f9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801063fe:	e9 97 f3 ff ff       	jmp    8010579a <alltraps>

80106403 <vector197>:
.globl vector197
vector197:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $197
80106405:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010640a:	e9 8b f3 ff ff       	jmp    8010579a <alltraps>

8010640f <vector198>:
.globl vector198
vector198:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $198
80106411:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106416:	e9 7f f3 ff ff       	jmp    8010579a <alltraps>

8010641b <vector199>:
.globl vector199
vector199:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $199
8010641d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106422:	e9 73 f3 ff ff       	jmp    8010579a <alltraps>

80106427 <vector200>:
.globl vector200
vector200:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $200
80106429:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010642e:	e9 67 f3 ff ff       	jmp    8010579a <alltraps>

80106433 <vector201>:
.globl vector201
vector201:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $201
80106435:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010643a:	e9 5b f3 ff ff       	jmp    8010579a <alltraps>

8010643f <vector202>:
.globl vector202
vector202:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $202
80106441:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106446:	e9 4f f3 ff ff       	jmp    8010579a <alltraps>

8010644b <vector203>:
.globl vector203
vector203:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $203
8010644d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106452:	e9 43 f3 ff ff       	jmp    8010579a <alltraps>

80106457 <vector204>:
.globl vector204
vector204:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $204
80106459:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010645e:	e9 37 f3 ff ff       	jmp    8010579a <alltraps>

80106463 <vector205>:
.globl vector205
vector205:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $205
80106465:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010646a:	e9 2b f3 ff ff       	jmp    8010579a <alltraps>

8010646f <vector206>:
.globl vector206
vector206:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $206
80106471:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106476:	e9 1f f3 ff ff       	jmp    8010579a <alltraps>

8010647b <vector207>:
.globl vector207
vector207:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $207
8010647d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106482:	e9 13 f3 ff ff       	jmp    8010579a <alltraps>

80106487 <vector208>:
.globl vector208
vector208:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $208
80106489:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010648e:	e9 07 f3 ff ff       	jmp    8010579a <alltraps>

80106493 <vector209>:
.globl vector209
vector209:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $209
80106495:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010649a:	e9 fb f2 ff ff       	jmp    8010579a <alltraps>

8010649f <vector210>:
.globl vector210
vector210:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $210
801064a1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801064a6:	e9 ef f2 ff ff       	jmp    8010579a <alltraps>

801064ab <vector211>:
.globl vector211
vector211:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $211
801064ad:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801064b2:	e9 e3 f2 ff ff       	jmp    8010579a <alltraps>

801064b7 <vector212>:
.globl vector212
vector212:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $212
801064b9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801064be:	e9 d7 f2 ff ff       	jmp    8010579a <alltraps>

801064c3 <vector213>:
.globl vector213
vector213:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $213
801064c5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801064ca:	e9 cb f2 ff ff       	jmp    8010579a <alltraps>

801064cf <vector214>:
.globl vector214
vector214:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $214
801064d1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801064d6:	e9 bf f2 ff ff       	jmp    8010579a <alltraps>

801064db <vector215>:
.globl vector215
vector215:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $215
801064dd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801064e2:	e9 b3 f2 ff ff       	jmp    8010579a <alltraps>

801064e7 <vector216>:
.globl vector216
vector216:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $216
801064e9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801064ee:	e9 a7 f2 ff ff       	jmp    8010579a <alltraps>

801064f3 <vector217>:
.globl vector217
vector217:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $217
801064f5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801064fa:	e9 9b f2 ff ff       	jmp    8010579a <alltraps>

801064ff <vector218>:
.globl vector218
vector218:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $218
80106501:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106506:	e9 8f f2 ff ff       	jmp    8010579a <alltraps>

8010650b <vector219>:
.globl vector219
vector219:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $219
8010650d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106512:	e9 83 f2 ff ff       	jmp    8010579a <alltraps>

80106517 <vector220>:
.globl vector220
vector220:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $220
80106519:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010651e:	e9 77 f2 ff ff       	jmp    8010579a <alltraps>

80106523 <vector221>:
.globl vector221
vector221:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $221
80106525:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010652a:	e9 6b f2 ff ff       	jmp    8010579a <alltraps>

8010652f <vector222>:
.globl vector222
vector222:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $222
80106531:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106536:	e9 5f f2 ff ff       	jmp    8010579a <alltraps>

8010653b <vector223>:
.globl vector223
vector223:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $223
8010653d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106542:	e9 53 f2 ff ff       	jmp    8010579a <alltraps>

80106547 <vector224>:
.globl vector224
vector224:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $224
80106549:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010654e:	e9 47 f2 ff ff       	jmp    8010579a <alltraps>

80106553 <vector225>:
.globl vector225
vector225:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $225
80106555:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010655a:	e9 3b f2 ff ff       	jmp    8010579a <alltraps>

8010655f <vector226>:
.globl vector226
vector226:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $226
80106561:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106566:	e9 2f f2 ff ff       	jmp    8010579a <alltraps>

8010656b <vector227>:
.globl vector227
vector227:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $227
8010656d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106572:	e9 23 f2 ff ff       	jmp    8010579a <alltraps>

80106577 <vector228>:
.globl vector228
vector228:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $228
80106579:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010657e:	e9 17 f2 ff ff       	jmp    8010579a <alltraps>

80106583 <vector229>:
.globl vector229
vector229:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $229
80106585:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010658a:	e9 0b f2 ff ff       	jmp    8010579a <alltraps>

8010658f <vector230>:
.globl vector230
vector230:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $230
80106591:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106596:	e9 ff f1 ff ff       	jmp    8010579a <alltraps>

8010659b <vector231>:
.globl vector231
vector231:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $231
8010659d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801065a2:	e9 f3 f1 ff ff       	jmp    8010579a <alltraps>

801065a7 <vector232>:
.globl vector232
vector232:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $232
801065a9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801065ae:	e9 e7 f1 ff ff       	jmp    8010579a <alltraps>

801065b3 <vector233>:
.globl vector233
vector233:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $233
801065b5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801065ba:	e9 db f1 ff ff       	jmp    8010579a <alltraps>

801065bf <vector234>:
.globl vector234
vector234:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $234
801065c1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801065c6:	e9 cf f1 ff ff       	jmp    8010579a <alltraps>

801065cb <vector235>:
.globl vector235
vector235:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $235
801065cd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801065d2:	e9 c3 f1 ff ff       	jmp    8010579a <alltraps>

801065d7 <vector236>:
.globl vector236
vector236:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $236
801065d9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801065de:	e9 b7 f1 ff ff       	jmp    8010579a <alltraps>

801065e3 <vector237>:
.globl vector237
vector237:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $237
801065e5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801065ea:	e9 ab f1 ff ff       	jmp    8010579a <alltraps>

801065ef <vector238>:
.globl vector238
vector238:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $238
801065f1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801065f6:	e9 9f f1 ff ff       	jmp    8010579a <alltraps>

801065fb <vector239>:
.globl vector239
vector239:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $239
801065fd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106602:	e9 93 f1 ff ff       	jmp    8010579a <alltraps>

80106607 <vector240>:
.globl vector240
vector240:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $240
80106609:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010660e:	e9 87 f1 ff ff       	jmp    8010579a <alltraps>

80106613 <vector241>:
.globl vector241
vector241:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $241
80106615:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010661a:	e9 7b f1 ff ff       	jmp    8010579a <alltraps>

8010661f <vector242>:
.globl vector242
vector242:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $242
80106621:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106626:	e9 6f f1 ff ff       	jmp    8010579a <alltraps>

8010662b <vector243>:
.globl vector243
vector243:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $243
8010662d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106632:	e9 63 f1 ff ff       	jmp    8010579a <alltraps>

80106637 <vector244>:
.globl vector244
vector244:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $244
80106639:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010663e:	e9 57 f1 ff ff       	jmp    8010579a <alltraps>

80106643 <vector245>:
.globl vector245
vector245:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $245
80106645:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010664a:	e9 4b f1 ff ff       	jmp    8010579a <alltraps>

8010664f <vector246>:
.globl vector246
vector246:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $246
80106651:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106656:	e9 3f f1 ff ff       	jmp    8010579a <alltraps>

8010665b <vector247>:
.globl vector247
vector247:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $247
8010665d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106662:	e9 33 f1 ff ff       	jmp    8010579a <alltraps>

80106667 <vector248>:
.globl vector248
vector248:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $248
80106669:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010666e:	e9 27 f1 ff ff       	jmp    8010579a <alltraps>

80106673 <vector249>:
.globl vector249
vector249:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $249
80106675:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010667a:	e9 1b f1 ff ff       	jmp    8010579a <alltraps>

8010667f <vector250>:
.globl vector250
vector250:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $250
80106681:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106686:	e9 0f f1 ff ff       	jmp    8010579a <alltraps>

8010668b <vector251>:
.globl vector251
vector251:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $251
8010668d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106692:	e9 03 f1 ff ff       	jmp    8010579a <alltraps>

80106697 <vector252>:
.globl vector252
vector252:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $252
80106699:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010669e:	e9 f7 f0 ff ff       	jmp    8010579a <alltraps>

801066a3 <vector253>:
.globl vector253
vector253:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $253
801066a5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801066aa:	e9 eb f0 ff ff       	jmp    8010579a <alltraps>

801066af <vector254>:
.globl vector254
vector254:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $254
801066b1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801066b6:	e9 df f0 ff ff       	jmp    8010579a <alltraps>

801066bb <vector255>:
.globl vector255
vector255:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $255
801066bd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801066c2:	e9 d3 f0 ff ff       	jmp    8010579a <alltraps>
801066c7:	66 90                	xchg   %ax,%ax
801066c9:	66 90                	xchg   %ax,%ax
801066cb:	66 90                	xchg   %ax,%ax
801066cd:	66 90                	xchg   %ax,%ax
801066cf:	90                   	nop

801066d0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801066d0:	55                   	push   %ebp
801066d1:	89 e5                	mov    %esp,%ebp
801066d3:	57                   	push   %edi
801066d4:	56                   	push   %esi
801066d5:	53                   	push   %ebx
801066d6:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801066d8:	c1 ea 16             	shr    $0x16,%edx
801066db:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801066de:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
801066e1:	8b 07                	mov    (%edi),%eax
801066e3:	a8 01                	test   $0x1,%al
801066e5:	74 29                	je     80106710 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801066e7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801066ec:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
801066f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801066f5:	c1 eb 0a             	shr    $0xa,%ebx
801066f8:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
801066fe:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80106701:	5b                   	pop    %ebx
80106702:	5e                   	pop    %esi
80106703:	5f                   	pop    %edi
80106704:	5d                   	pop    %ebp
80106705:	c3                   	ret    
80106706:	8d 76 00             	lea    0x0(%esi),%esi
80106709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106710:	85 c9                	test   %ecx,%ecx
80106712:	74 2c                	je     80106740 <walkpgdir+0x70>
80106714:	e8 67 bd ff ff       	call   80102480 <kalloc>
80106719:	85 c0                	test   %eax,%eax
8010671b:	89 c6                	mov    %eax,%esi
8010671d:	74 21                	je     80106740 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010671f:	83 ec 04             	sub    $0x4,%esp
80106722:	68 00 10 00 00       	push   $0x1000
80106727:	6a 00                	push   $0x0
80106729:	50                   	push   %eax
8010672a:	e8 71 de ff ff       	call   801045a0 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010672f:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106735:	83 c4 10             	add    $0x10,%esp
80106738:	83 c8 07             	or     $0x7,%eax
8010673b:	89 07                	mov    %eax,(%edi)
8010673d:	eb b3                	jmp    801066f2 <walkpgdir+0x22>
8010673f:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
80106740:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
80106743:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106745:	5b                   	pop    %ebx
80106746:	5e                   	pop    %esi
80106747:	5f                   	pop    %edi
80106748:	5d                   	pop    %ebp
80106749:	c3                   	ret    
8010674a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106750 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106750:	55                   	push   %ebp
80106751:	89 e5                	mov    %esp,%ebp
80106753:	57                   	push   %edi
80106754:	56                   	push   %esi
80106755:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106756:	89 d3                	mov    %edx,%ebx
80106758:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010675e:	83 ec 1c             	sub    $0x1c,%esp
80106761:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106764:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106768:	8b 7d 08             	mov    0x8(%ebp),%edi
8010676b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106770:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106773:	8b 45 0c             	mov    0xc(%ebp),%eax
80106776:	29 df                	sub    %ebx,%edi
80106778:	83 c8 01             	or     $0x1,%eax
8010677b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010677e:	eb 15                	jmp    80106795 <mappages+0x45>
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106780:	f6 00 01             	testb  $0x1,(%eax)
80106783:	75 45                	jne    801067ca <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106785:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106788:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
8010678b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010678d:	74 31                	je     801067c0 <mappages+0x70>
      break;
    a += PGSIZE;
8010678f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106795:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106798:	b9 01 00 00 00       	mov    $0x1,%ecx
8010679d:	89 da                	mov    %ebx,%edx
8010679f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801067a2:	e8 29 ff ff ff       	call   801066d0 <walkpgdir>
801067a7:	85 c0                	test   %eax,%eax
801067a9:	75 d5                	jne    80106780 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
801067ab:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
801067ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
801067b3:	5b                   	pop    %ebx
801067b4:	5e                   	pop    %esi
801067b5:	5f                   	pop    %edi
801067b6:	5d                   	pop    %ebp
801067b7:	c3                   	ret    
801067b8:	90                   	nop
801067b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801067c3:	31 c0                	xor    %eax,%eax
}
801067c5:	5b                   	pop    %ebx
801067c6:	5e                   	pop    %esi
801067c7:	5f                   	pop    %edi
801067c8:	5d                   	pop    %ebp
801067c9:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
801067ca:	83 ec 0c             	sub    $0xc,%esp
801067cd:	68 2c 79 10 80       	push   $0x8010792c
801067d2:	e8 99 9b ff ff       	call   80100370 <panic>
801067d7:	89 f6                	mov    %esi,%esi
801067d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801067e0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801067e0:	55                   	push   %ebp
801067e1:	89 e5                	mov    %esp,%ebp
801067e3:	57                   	push   %edi
801067e4:	56                   	push   %esi
801067e5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801067e6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801067ec:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801067ee:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801067f4:	83 ec 1c             	sub    $0x1c,%esp
801067f7:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801067fa:	39 d3                	cmp    %edx,%ebx
801067fc:	73 66                	jae    80106864 <deallocuvm.part.0+0x84>
801067fe:	89 d6                	mov    %edx,%esi
80106800:	eb 3d                	jmp    8010683f <deallocuvm.part.0+0x5f>
80106802:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106808:	8b 10                	mov    (%eax),%edx
8010680a:	f6 c2 01             	test   $0x1,%dl
8010680d:	74 26                	je     80106835 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010680f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106815:	74 58                	je     8010686f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106817:	83 ec 0c             	sub    $0xc,%esp
8010681a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106820:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106823:	52                   	push   %edx
80106824:	e8 a7 ba ff ff       	call   801022d0 <kfree>
      *pte = 0;
80106829:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010682c:	83 c4 10             	add    $0x10,%esp
8010682f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106835:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010683b:	39 f3                	cmp    %esi,%ebx
8010683d:	73 25                	jae    80106864 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010683f:	31 c9                	xor    %ecx,%ecx
80106841:	89 da                	mov    %ebx,%edx
80106843:	89 f8                	mov    %edi,%eax
80106845:	e8 86 fe ff ff       	call   801066d0 <walkpgdir>
    if(!pte)
8010684a:	85 c0                	test   %eax,%eax
8010684c:	75 ba                	jne    80106808 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010684e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106854:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010685a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106860:	39 f3                	cmp    %esi,%ebx
80106862:	72 db                	jb     8010683f <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106864:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106867:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010686a:	5b                   	pop    %ebx
8010686b:	5e                   	pop    %esi
8010686c:	5f                   	pop    %edi
8010686d:	5d                   	pop    %ebp
8010686e:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
8010686f:	83 ec 0c             	sub    $0xc,%esp
80106872:	68 c6 72 10 80       	push   $0x801072c6
80106877:	e8 f4 9a ff ff       	call   80100370 <panic>
8010687c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106880 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106880:	55                   	push   %ebp
80106881:	89 e5                	mov    %esp,%ebp
80106883:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106886:	e8 e5 ce ff ff       	call   80103770 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010688b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106891:	31 c9                	xor    %ecx,%ecx
80106893:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106898:	66 89 90 f8 27 11 80 	mov    %dx,-0x7feed808(%eax)
8010689f:	66 89 88 fa 27 11 80 	mov    %cx,-0x7feed806(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801068a6:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801068ab:	31 c9                	xor    %ecx,%ecx
801068ad:	66 89 90 00 28 11 80 	mov    %dx,-0x7feed800(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801068b4:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801068b9:	66 89 88 02 28 11 80 	mov    %cx,-0x7feed7fe(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801068c0:	31 c9                	xor    %ecx,%ecx
801068c2:	66 89 90 08 28 11 80 	mov    %dx,-0x7feed7f8(%eax)
801068c9:	66 89 88 0a 28 11 80 	mov    %cx,-0x7feed7f6(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801068d0:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801068d5:	31 c9                	xor    %ecx,%ecx
801068d7:	66 89 90 10 28 11 80 	mov    %dx,-0x7feed7f0(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801068de:	c6 80 fc 27 11 80 00 	movb   $0x0,-0x7feed804(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801068e5:	ba 2f 00 00 00       	mov    $0x2f,%edx
801068ea:	c6 80 fd 27 11 80 9a 	movb   $0x9a,-0x7feed803(%eax)
801068f1:	c6 80 fe 27 11 80 cf 	movb   $0xcf,-0x7feed802(%eax)
801068f8:	c6 80 ff 27 11 80 00 	movb   $0x0,-0x7feed801(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801068ff:	c6 80 04 28 11 80 00 	movb   $0x0,-0x7feed7fc(%eax)
80106906:	c6 80 05 28 11 80 92 	movb   $0x92,-0x7feed7fb(%eax)
8010690d:	c6 80 06 28 11 80 cf 	movb   $0xcf,-0x7feed7fa(%eax)
80106914:	c6 80 07 28 11 80 00 	movb   $0x0,-0x7feed7f9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010691b:	c6 80 0c 28 11 80 00 	movb   $0x0,-0x7feed7f4(%eax)
80106922:	c6 80 0d 28 11 80 fa 	movb   $0xfa,-0x7feed7f3(%eax)
80106929:	c6 80 0e 28 11 80 cf 	movb   $0xcf,-0x7feed7f2(%eax)
80106930:	c6 80 0f 28 11 80 00 	movb   $0x0,-0x7feed7f1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106937:	66 89 88 12 28 11 80 	mov    %cx,-0x7feed7ee(%eax)
8010693e:	c6 80 14 28 11 80 00 	movb   $0x0,-0x7feed7ec(%eax)
80106945:	c6 80 15 28 11 80 f2 	movb   $0xf2,-0x7feed7eb(%eax)
8010694c:	c6 80 16 28 11 80 cf 	movb   $0xcf,-0x7feed7ea(%eax)
80106953:	c6 80 17 28 11 80 00 	movb   $0x0,-0x7feed7e9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
8010695a:	05 f0 27 11 80       	add    $0x801127f0,%eax
8010695f:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80106963:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106967:	c1 e8 10             	shr    $0x10,%eax
8010696a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
8010696e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106971:	0f 01 10             	lgdtl  (%eax)
}
80106974:	c9                   	leave  
80106975:	c3                   	ret    
80106976:	8d 76 00             	lea    0x0(%esi),%esi
80106979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106980 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106980:	a1 a4 57 11 80       	mov    0x801157a4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106985:	55                   	push   %ebp
80106986:	89 e5                	mov    %esp,%ebp
80106988:	05 00 00 00 80       	add    $0x80000000,%eax
8010698d:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
80106990:	5d                   	pop    %ebp
80106991:	c3                   	ret    
80106992:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801069a0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801069a0:	55                   	push   %ebp
801069a1:	89 e5                	mov    %esp,%ebp
801069a3:	57                   	push   %edi
801069a4:	56                   	push   %esi
801069a5:	53                   	push   %ebx
801069a6:	83 ec 1c             	sub    $0x1c,%esp
801069a9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801069ac:	85 f6                	test   %esi,%esi
801069ae:	0f 84 cd 00 00 00    	je     80106a81 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801069b4:	8b 46 08             	mov    0x8(%esi),%eax
801069b7:	85 c0                	test   %eax,%eax
801069b9:	0f 84 dc 00 00 00    	je     80106a9b <switchuvm+0xfb>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801069bf:	8b 7e 04             	mov    0x4(%esi),%edi
801069c2:	85 ff                	test   %edi,%edi
801069c4:	0f 84 c4 00 00 00    	je     80106a8e <switchuvm+0xee>
    panic("switchuvm: no pgdir");

  pushcli();
801069ca:	e8 f1 d9 ff ff       	call   801043c0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801069cf:	e8 1c cd ff ff       	call   801036f0 <mycpu>
801069d4:	89 c3                	mov    %eax,%ebx
801069d6:	e8 15 cd ff ff       	call   801036f0 <mycpu>
801069db:	89 c7                	mov    %eax,%edi
801069dd:	e8 0e cd ff ff       	call   801036f0 <mycpu>
801069e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801069e5:	83 c7 08             	add    $0x8,%edi
801069e8:	e8 03 cd ff ff       	call   801036f0 <mycpu>
801069ed:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801069f0:	83 c0 08             	add    $0x8,%eax
801069f3:	ba 67 00 00 00       	mov    $0x67,%edx
801069f8:	c1 e8 18             	shr    $0x18,%eax
801069fb:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80106a02:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106a09:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80106a10:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106a17:	83 c1 08             	add    $0x8,%ecx
80106a1a:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106a20:	c1 e9 10             	shr    $0x10,%ecx
80106a23:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106a29:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80106a2e:	e8 bd cc ff ff       	call   801036f0 <mycpu>
80106a33:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106a3a:	e8 b1 cc ff ff       	call   801036f0 <mycpu>
80106a3f:	b9 10 00 00 00       	mov    $0x10,%ecx
80106a44:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106a48:	e8 a3 cc ff ff       	call   801036f0 <mycpu>
80106a4d:	8b 56 08             	mov    0x8(%esi),%edx
80106a50:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106a56:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106a59:	e8 92 cc ff ff       	call   801036f0 <mycpu>
80106a5e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106a62:	b8 28 00 00 00       	mov    $0x28,%eax
80106a67:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106a6a:	8b 46 04             	mov    0x4(%esi),%eax
80106a6d:	05 00 00 00 80       	add    $0x80000000,%eax
80106a72:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80106a75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a78:	5b                   	pop    %ebx
80106a79:	5e                   	pop    %esi
80106a7a:	5f                   	pop    %edi
80106a7b:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
80106a7c:	e9 7f d9 ff ff       	jmp    80104400 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80106a81:	83 ec 0c             	sub    $0xc,%esp
80106a84:	68 32 79 10 80       	push   $0x80107932
80106a89:	e8 e2 98 ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
80106a8e:	83 ec 0c             	sub    $0xc,%esp
80106a91:	68 5d 79 10 80       	push   $0x8010795d
80106a96:	e8 d5 98 ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
80106a9b:	83 ec 0c             	sub    $0xc,%esp
80106a9e:	68 48 79 10 80       	push   $0x80107948
80106aa3:	e8 c8 98 ff ff       	call   80100370 <panic>
80106aa8:	90                   	nop
80106aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ab0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106ab0:	55                   	push   %ebp
80106ab1:	89 e5                	mov    %esp,%ebp
80106ab3:	57                   	push   %edi
80106ab4:	56                   	push   %esi
80106ab5:	53                   	push   %ebx
80106ab6:	83 ec 1c             	sub    $0x1c,%esp
80106ab9:	8b 75 10             	mov    0x10(%ebp),%esi
80106abc:	8b 45 08             	mov    0x8(%ebp),%eax
80106abf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80106ac2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106ac8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
80106acb:	77 49                	ja     80106b16 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
80106acd:	e8 ae b9 ff ff       	call   80102480 <kalloc>
  memset(mem, 0, PGSIZE);
80106ad2:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80106ad5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106ad7:	68 00 10 00 00       	push   $0x1000
80106adc:	6a 00                	push   $0x0
80106ade:	50                   	push   %eax
80106adf:	e8 bc da ff ff       	call   801045a0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106ae4:	58                   	pop    %eax
80106ae5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106aeb:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106af0:	5a                   	pop    %edx
80106af1:	6a 06                	push   $0x6
80106af3:	50                   	push   %eax
80106af4:	31 d2                	xor    %edx,%edx
80106af6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106af9:	e8 52 fc ff ff       	call   80106750 <mappages>
  memmove(mem, init, sz);
80106afe:	89 75 10             	mov    %esi,0x10(%ebp)
80106b01:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106b04:	83 c4 10             	add    $0x10,%esp
80106b07:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106b0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b0d:	5b                   	pop    %ebx
80106b0e:	5e                   	pop    %esi
80106b0f:	5f                   	pop    %edi
80106b10:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106b11:	e9 3a db ff ff       	jmp    80104650 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80106b16:	83 ec 0c             	sub    $0xc,%esp
80106b19:	68 71 79 10 80       	push   $0x80107971
80106b1e:	e8 4d 98 ff ff       	call   80100370 <panic>
80106b23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b30 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106b30:	55                   	push   %ebp
80106b31:	89 e5                	mov    %esp,%ebp
80106b33:	57                   	push   %edi
80106b34:	56                   	push   %esi
80106b35:	53                   	push   %ebx
80106b36:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106b39:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106b40:	0f 85 91 00 00 00    	jne    80106bd7 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106b46:	8b 75 18             	mov    0x18(%ebp),%esi
80106b49:	31 db                	xor    %ebx,%ebx
80106b4b:	85 f6                	test   %esi,%esi
80106b4d:	75 1a                	jne    80106b69 <loaduvm+0x39>
80106b4f:	eb 6f                	jmp    80106bc0 <loaduvm+0x90>
80106b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b58:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b5e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106b64:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106b67:	76 57                	jbe    80106bc0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106b69:	8b 55 0c             	mov    0xc(%ebp),%edx
80106b6c:	8b 45 08             	mov    0x8(%ebp),%eax
80106b6f:	31 c9                	xor    %ecx,%ecx
80106b71:	01 da                	add    %ebx,%edx
80106b73:	e8 58 fb ff ff       	call   801066d0 <walkpgdir>
80106b78:	85 c0                	test   %eax,%eax
80106b7a:	74 4e                	je     80106bca <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106b7c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106b7e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
80106b81:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106b86:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106b8b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106b91:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106b94:	01 d9                	add    %ebx,%ecx
80106b96:	05 00 00 00 80       	add    $0x80000000,%eax
80106b9b:	57                   	push   %edi
80106b9c:	51                   	push   %ecx
80106b9d:	50                   	push   %eax
80106b9e:	ff 75 10             	pushl  0x10(%ebp)
80106ba1:	e8 9a ad ff ff       	call   80101940 <readi>
80106ba6:	83 c4 10             	add    $0x10,%esp
80106ba9:	39 c7                	cmp    %eax,%edi
80106bab:	74 ab                	je     80106b58 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106bad:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106bb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106bb5:	5b                   	pop    %ebx
80106bb6:	5e                   	pop    %esi
80106bb7:	5f                   	pop    %edi
80106bb8:	5d                   	pop    %ebp
80106bb9:	c3                   	ret    
80106bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106bc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106bc3:	31 c0                	xor    %eax,%eax
}
80106bc5:	5b                   	pop    %ebx
80106bc6:	5e                   	pop    %esi
80106bc7:	5f                   	pop    %edi
80106bc8:	5d                   	pop    %ebp
80106bc9:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106bca:	83 ec 0c             	sub    $0xc,%esp
80106bcd:	68 8b 79 10 80       	push   $0x8010798b
80106bd2:	e8 99 97 ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80106bd7:	83 ec 0c             	sub    $0xc,%esp
80106bda:	68 2c 7a 10 80       	push   $0x80107a2c
80106bdf:	e8 8c 97 ff ff       	call   80100370 <panic>
80106be4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106bea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106bf0 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106bf0:	55                   	push   %ebp
80106bf1:	89 e5                	mov    %esp,%ebp
80106bf3:	57                   	push   %edi
80106bf4:	56                   	push   %esi
80106bf5:	53                   	push   %ebx
80106bf6:	83 ec 0c             	sub    $0xc,%esp
80106bf9:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80106bfc:	85 ff                	test   %edi,%edi
80106bfe:	0f 88 ca 00 00 00    	js     80106cce <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
80106c04:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106c07:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
80106c0a:	0f 82 82 00 00 00    	jb     80106c92 <allocuvm+0xa2>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106c10:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106c16:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106c1c:	39 df                	cmp    %ebx,%edi
80106c1e:	77 43                	ja     80106c63 <allocuvm+0x73>
80106c20:	e9 bb 00 00 00       	jmp    80106ce0 <allocuvm+0xf0>
80106c25:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106c28:	83 ec 04             	sub    $0x4,%esp
80106c2b:	68 00 10 00 00       	push   $0x1000
80106c30:	6a 00                	push   $0x0
80106c32:	50                   	push   %eax
80106c33:	e8 68 d9 ff ff       	call   801045a0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106c38:	58                   	pop    %eax
80106c39:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106c3f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106c44:	5a                   	pop    %edx
80106c45:	6a 06                	push   $0x6
80106c47:	50                   	push   %eax
80106c48:	89 da                	mov    %ebx,%edx
80106c4a:	8b 45 08             	mov    0x8(%ebp),%eax
80106c4d:	e8 fe fa ff ff       	call   80106750 <mappages>
80106c52:	83 c4 10             	add    $0x10,%esp
80106c55:	85 c0                	test   %eax,%eax
80106c57:	78 47                	js     80106ca0 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106c59:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c5f:	39 df                	cmp    %ebx,%edi
80106c61:	76 7d                	jbe    80106ce0 <allocuvm+0xf0>
    mem = kalloc();
80106c63:	e8 18 b8 ff ff       	call   80102480 <kalloc>
    if(mem == 0){
80106c68:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80106c6a:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106c6c:	75 ba                	jne    80106c28 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
80106c6e:	83 ec 0c             	sub    $0xc,%esp
80106c71:	68 a9 79 10 80       	push   $0x801079a9
80106c76:	e8 e5 99 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106c7b:	83 c4 10             	add    $0x10,%esp
80106c7e:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106c81:	76 4b                	jbe    80106cce <allocuvm+0xde>
80106c83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106c86:	8b 45 08             	mov    0x8(%ebp),%eax
80106c89:	89 fa                	mov    %edi,%edx
80106c8b:	e8 50 fb ff ff       	call   801067e0 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106c90:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106c92:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c95:	5b                   	pop    %ebx
80106c96:	5e                   	pop    %esi
80106c97:	5f                   	pop    %edi
80106c98:	5d                   	pop    %ebp
80106c99:	c3                   	ret    
80106c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106ca0:	83 ec 0c             	sub    $0xc,%esp
80106ca3:	68 c1 79 10 80       	push   $0x801079c1
80106ca8:	e8 b3 99 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106cad:	83 c4 10             	add    $0x10,%esp
80106cb0:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106cb3:	76 0d                	jbe    80106cc2 <allocuvm+0xd2>
80106cb5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106cb8:	8b 45 08             	mov    0x8(%ebp),%eax
80106cbb:	89 fa                	mov    %edi,%edx
80106cbd:	e8 1e fb ff ff       	call   801067e0 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80106cc2:	83 ec 0c             	sub    $0xc,%esp
80106cc5:	56                   	push   %esi
80106cc6:	e8 05 b6 ff ff       	call   801022d0 <kfree>
      return 0;
80106ccb:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
80106cce:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106cd1:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106cd3:	5b                   	pop    %ebx
80106cd4:	5e                   	pop    %esi
80106cd5:	5f                   	pop    %edi
80106cd6:	5d                   	pop    %ebp
80106cd7:	c3                   	ret    
80106cd8:	90                   	nop
80106cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ce0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106ce3:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106ce5:	5b                   	pop    %ebx
80106ce6:	5e                   	pop    %esi
80106ce7:	5f                   	pop    %edi
80106ce8:	5d                   	pop    %ebp
80106ce9:	c3                   	ret    
80106cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106cf0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106cf0:	55                   	push   %ebp
80106cf1:	89 e5                	mov    %esp,%ebp
80106cf3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106cf6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106cfc:	39 d1                	cmp    %edx,%ecx
80106cfe:	73 10                	jae    80106d10 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106d00:	5d                   	pop    %ebp
80106d01:	e9 da fa ff ff       	jmp    801067e0 <deallocuvm.part.0>
80106d06:	8d 76 00             	lea    0x0(%esi),%esi
80106d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106d10:	89 d0                	mov    %edx,%eax
80106d12:	5d                   	pop    %ebp
80106d13:	c3                   	ret    
80106d14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106d20 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106d20:	55                   	push   %ebp
80106d21:	89 e5                	mov    %esp,%ebp
80106d23:	57                   	push   %edi
80106d24:	56                   	push   %esi
80106d25:	53                   	push   %ebx
80106d26:	83 ec 0c             	sub    $0xc,%esp
80106d29:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106d2c:	85 f6                	test   %esi,%esi
80106d2e:	74 59                	je     80106d89 <freevm+0x69>
80106d30:	31 c9                	xor    %ecx,%ecx
80106d32:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106d37:	89 f0                	mov    %esi,%eax
80106d39:	e8 a2 fa ff ff       	call   801067e0 <deallocuvm.part.0>
80106d3e:	89 f3                	mov    %esi,%ebx
80106d40:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106d46:	eb 0f                	jmp    80106d57 <freevm+0x37>
80106d48:	90                   	nop
80106d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d50:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106d53:	39 fb                	cmp    %edi,%ebx
80106d55:	74 23                	je     80106d7a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106d57:	8b 03                	mov    (%ebx),%eax
80106d59:	a8 01                	test   $0x1,%al
80106d5b:	74 f3                	je     80106d50 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
80106d5d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d62:	83 ec 0c             	sub    $0xc,%esp
80106d65:	83 c3 04             	add    $0x4,%ebx
80106d68:	05 00 00 00 80       	add    $0x80000000,%eax
80106d6d:	50                   	push   %eax
80106d6e:	e8 5d b5 ff ff       	call   801022d0 <kfree>
80106d73:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106d76:	39 fb                	cmp    %edi,%ebx
80106d78:	75 dd                	jne    80106d57 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106d7a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106d7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d80:	5b                   	pop    %ebx
80106d81:	5e                   	pop    %esi
80106d82:	5f                   	pop    %edi
80106d83:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106d84:	e9 47 b5 ff ff       	jmp    801022d0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106d89:	83 ec 0c             	sub    $0xc,%esp
80106d8c:	68 dd 79 10 80       	push   $0x801079dd
80106d91:	e8 da 95 ff ff       	call   80100370 <panic>
80106d96:	8d 76 00             	lea    0x0(%esi),%esi
80106d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106da0 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106da0:	55                   	push   %ebp
80106da1:	89 e5                	mov    %esp,%ebp
80106da3:	56                   	push   %esi
80106da4:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106da5:	e8 d6 b6 ff ff       	call   80102480 <kalloc>
80106daa:	85 c0                	test   %eax,%eax
80106dac:	74 6a                	je     80106e18 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106dae:	83 ec 04             	sub    $0x4,%esp
80106db1:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106db3:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106db8:	68 00 10 00 00       	push   $0x1000
80106dbd:	6a 00                	push   $0x0
80106dbf:	50                   	push   %eax
80106dc0:	e8 db d7 ff ff       	call   801045a0 <memset>
80106dc5:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106dc8:	8b 43 04             	mov    0x4(%ebx),%eax
80106dcb:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106dce:	83 ec 08             	sub    $0x8,%esp
80106dd1:	8b 13                	mov    (%ebx),%edx
80106dd3:	ff 73 0c             	pushl  0xc(%ebx)
80106dd6:	50                   	push   %eax
80106dd7:	29 c1                	sub    %eax,%ecx
80106dd9:	89 f0                	mov    %esi,%eax
80106ddb:	e8 70 f9 ff ff       	call   80106750 <mappages>
80106de0:	83 c4 10             	add    $0x10,%esp
80106de3:	85 c0                	test   %eax,%eax
80106de5:	78 19                	js     80106e00 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106de7:	83 c3 10             	add    $0x10,%ebx
80106dea:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106df0:	75 d6                	jne    80106dc8 <setupkvm+0x28>
80106df2:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80106df4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106df7:	5b                   	pop    %ebx
80106df8:	5e                   	pop    %esi
80106df9:	5d                   	pop    %ebp
80106dfa:	c3                   	ret    
80106dfb:	90                   	nop
80106dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80106e00:	83 ec 0c             	sub    $0xc,%esp
80106e03:	56                   	push   %esi
80106e04:	e8 17 ff ff ff       	call   80106d20 <freevm>
      return 0;
80106e09:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
80106e0c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
80106e0f:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80106e11:	5b                   	pop    %ebx
80106e12:	5e                   	pop    %esi
80106e13:	5d                   	pop    %ebp
80106e14:	c3                   	ret    
80106e15:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80106e18:	31 c0                	xor    %eax,%eax
80106e1a:	eb d8                	jmp    80106df4 <setupkvm+0x54>
80106e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106e20 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106e20:	55                   	push   %ebp
80106e21:	89 e5                	mov    %esp,%ebp
80106e23:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106e26:	e8 75 ff ff ff       	call   80106da0 <setupkvm>
80106e2b:	a3 a4 57 11 80       	mov    %eax,0x801157a4
80106e30:	05 00 00 00 80       	add    $0x80000000,%eax
80106e35:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
80106e38:	c9                   	leave  
80106e39:	c3                   	ret    
80106e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e40 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106e40:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106e41:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106e43:	89 e5                	mov    %esp,%ebp
80106e45:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106e48:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e4b:	8b 45 08             	mov    0x8(%ebp),%eax
80106e4e:	e8 7d f8 ff ff       	call   801066d0 <walkpgdir>
  if(pte == 0)
80106e53:	85 c0                	test   %eax,%eax
80106e55:	74 05                	je     80106e5c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106e57:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106e5a:	c9                   	leave  
80106e5b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106e5c:	83 ec 0c             	sub    $0xc,%esp
80106e5f:	68 ee 79 10 80       	push   $0x801079ee
80106e64:	e8 07 95 ff ff       	call   80100370 <panic>
80106e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e70 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106e70:	55                   	push   %ebp
80106e71:	89 e5                	mov    %esp,%ebp
80106e73:	57                   	push   %edi
80106e74:	56                   	push   %esi
80106e75:	53                   	push   %ebx
80106e76:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106e79:	e8 22 ff ff ff       	call   80106da0 <setupkvm>
80106e7e:	85 c0                	test   %eax,%eax
80106e80:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106e83:	0f 84 c5 00 00 00    	je     80106f4e <copyuvm+0xde>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106e89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106e8c:	85 c9                	test   %ecx,%ecx
80106e8e:	0f 84 9c 00 00 00    	je     80106f30 <copyuvm+0xc0>
80106e94:	31 ff                	xor    %edi,%edi
80106e96:	eb 4a                	jmp    80106ee2 <copyuvm+0x72>
80106e98:	90                   	nop
80106e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106ea0:	83 ec 04             	sub    $0x4,%esp
80106ea3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80106ea9:	68 00 10 00 00       	push   $0x1000
80106eae:	53                   	push   %ebx
80106eaf:	50                   	push   %eax
80106eb0:	e8 9b d7 ff ff       	call   80104650 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106eb5:	58                   	pop    %eax
80106eb6:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106ebc:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ec1:	5a                   	pop    %edx
80106ec2:	ff 75 e4             	pushl  -0x1c(%ebp)
80106ec5:	50                   	push   %eax
80106ec6:	89 fa                	mov    %edi,%edx
80106ec8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106ecb:	e8 80 f8 ff ff       	call   80106750 <mappages>
80106ed0:	83 c4 10             	add    $0x10,%esp
80106ed3:	85 c0                	test   %eax,%eax
80106ed5:	78 69                	js     80106f40 <copyuvm+0xd0>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106ed7:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106edd:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80106ee0:	76 4e                	jbe    80106f30 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106ee2:	8b 45 08             	mov    0x8(%ebp),%eax
80106ee5:	31 c9                	xor    %ecx,%ecx
80106ee7:	89 fa                	mov    %edi,%edx
80106ee9:	e8 e2 f7 ff ff       	call   801066d0 <walkpgdir>
80106eee:	85 c0                	test   %eax,%eax
80106ef0:	74 6d                	je     80106f5f <copyuvm+0xef>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106ef2:	8b 00                	mov    (%eax),%eax
80106ef4:	a8 01                	test   $0x1,%al
80106ef6:	74 5a                	je     80106f52 <copyuvm+0xe2>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106ef8:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
80106efa:	25 ff 0f 00 00       	and    $0xfff,%eax
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106eff:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80106f05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80106f08:	e8 73 b5 ff ff       	call   80102480 <kalloc>
80106f0d:	85 c0                	test   %eax,%eax
80106f0f:	89 c6                	mov    %eax,%esi
80106f11:	75 8d                	jne    80106ea0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80106f13:	83 ec 0c             	sub    $0xc,%esp
80106f16:	ff 75 e0             	pushl  -0x20(%ebp)
80106f19:	e8 02 fe ff ff       	call   80106d20 <freevm>
  return 0;
80106f1e:	83 c4 10             	add    $0x10,%esp
80106f21:	31 c0                	xor    %eax,%eax
}
80106f23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f26:	5b                   	pop    %ebx
80106f27:	5e                   	pop    %esi
80106f28:	5f                   	pop    %edi
80106f29:	5d                   	pop    %ebp
80106f2a:	c3                   	ret    
80106f2b:	90                   	nop
80106f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106f30:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
80106f33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f36:	5b                   	pop    %ebx
80106f37:	5e                   	pop    %esi
80106f38:	5f                   	pop    %edi
80106f39:	5d                   	pop    %ebp
80106f3a:	c3                   	ret    
80106f3b:	90                   	nop
80106f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
      kfree(mem);
80106f40:	83 ec 0c             	sub    $0xc,%esp
80106f43:	56                   	push   %esi
80106f44:	e8 87 b3 ff ff       	call   801022d0 <kfree>
      goto bad;
80106f49:	83 c4 10             	add    $0x10,%esp
80106f4c:	eb c5                	jmp    80106f13 <copyuvm+0xa3>
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
80106f4e:	31 c0                	xor    %eax,%eax
80106f50:	eb d1                	jmp    80106f23 <copyuvm+0xb3>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80106f52:	83 ec 0c             	sub    $0xc,%esp
80106f55:	68 12 7a 10 80       	push   $0x80107a12
80106f5a:	e8 11 94 ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106f5f:	83 ec 0c             	sub    $0xc,%esp
80106f62:	68 f8 79 10 80       	push   $0x801079f8
80106f67:	e8 04 94 ff ff       	call   80100370 <panic>
80106f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106f70 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106f70:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106f71:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106f73:	89 e5                	mov    %esp,%ebp
80106f75:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106f78:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f7b:	8b 45 08             	mov    0x8(%ebp),%eax
80106f7e:	e8 4d f7 ff ff       	call   801066d0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106f83:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80106f85:	89 c2                	mov    %eax,%edx
80106f87:	83 e2 05             	and    $0x5,%edx
80106f8a:	83 fa 05             	cmp    $0x5,%edx
80106f8d:	75 11                	jne    80106fa0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106f8f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
80106f94:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106f95:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106f9a:	c3                   	ret    
80106f9b:	90                   	nop
80106f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80106fa0:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80106fa2:	c9                   	leave  
80106fa3:	c3                   	ret    
80106fa4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106faa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106fb0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106fb0:	55                   	push   %ebp
80106fb1:	89 e5                	mov    %esp,%ebp
80106fb3:	57                   	push   %edi
80106fb4:	56                   	push   %esi
80106fb5:	53                   	push   %ebx
80106fb6:	83 ec 1c             	sub    $0x1c,%esp
80106fb9:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106fbc:	8b 55 0c             	mov    0xc(%ebp),%edx
80106fbf:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106fc2:	85 db                	test   %ebx,%ebx
80106fc4:	75 40                	jne    80107006 <copyout+0x56>
80106fc6:	eb 70                	jmp    80107038 <copyout+0x88>
80106fc8:	90                   	nop
80106fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106fd0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106fd3:	89 f1                	mov    %esi,%ecx
80106fd5:	29 d1                	sub    %edx,%ecx
80106fd7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80106fdd:	39 d9                	cmp    %ebx,%ecx
80106fdf:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106fe2:	29 f2                	sub    %esi,%edx
80106fe4:	83 ec 04             	sub    $0x4,%esp
80106fe7:	01 d0                	add    %edx,%eax
80106fe9:	51                   	push   %ecx
80106fea:	57                   	push   %edi
80106feb:	50                   	push   %eax
80106fec:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80106fef:	e8 5c d6 ff ff       	call   80104650 <memmove>
    len -= n;
    buf += n;
80106ff4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106ff7:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
80106ffa:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80107000:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107002:	29 cb                	sub    %ecx,%ebx
80107004:	74 32                	je     80107038 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107006:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107008:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
8010700b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010700e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107014:	56                   	push   %esi
80107015:	ff 75 08             	pushl  0x8(%ebp)
80107018:	e8 53 ff ff ff       	call   80106f70 <uva2ka>
    if(pa0 == 0)
8010701d:	83 c4 10             	add    $0x10,%esp
80107020:	85 c0                	test   %eax,%eax
80107022:	75 ac                	jne    80106fd0 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107024:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80107027:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
8010702c:	5b                   	pop    %ebx
8010702d:	5e                   	pop    %esi
8010702e:	5f                   	pop    %edi
8010702f:	5d                   	pop    %ebp
80107030:	c3                   	ret    
80107031:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107038:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010703b:	31 c0                	xor    %eax,%eax
}
8010703d:	5b                   	pop    %ebx
8010703e:	5e                   	pop    %esi
8010703f:	5f                   	pop    %edi
80107040:	5d                   	pop    %ebp
80107041:	c3                   	ret    
