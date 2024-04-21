
_testcow3:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
	exit();
}

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 0c             	sub    $0xc,%esp
	printf(1, "Test starting...\n");
  11:	68 84 0a 00 00       	push   $0xa84
  16:	6a 01                	push   $0x1
  18:	e8 b3 06 00 00       	call   6d0 <printf>
	test();
  1d:	e8 3e 00 00 00       	call   60 <test>
  22:	66 90                	xchg   %ax,%ax
  24:	66 90                	xchg   %ax,%ax
  26:	66 90                	xchg   %ax,%ax
  28:	66 90                	xchg   %ax,%ax
  2a:	66 90                	xchg   %ax,%ax
  2c:	66 90                	xchg   %ax,%ax
  2e:	66 90                	xchg   %ax,%ax

00000030 <processing>:
processing(int *x) {
  30:	55                   	push   %ebp
  31:	89 e5                	mov    %esp,%ebp
  33:	83 ec 0c             	sub    $0xc,%esp
  36:	8b 45 08             	mov    0x8(%ebp),%eax
  39:	c7 00 ae ad 01 00    	movl   $0x1adae,(%eax)
    printf(1, "done processing %d\n", x);
  3f:	50                   	push   %eax
  40:	68 f8 09 00 00       	push   $0x9f8
  45:	6a 01                	push   $0x1
  47:	e8 84 06 00 00       	call   6d0 <printf>
}
  4c:	83 c4 10             	add    $0x10,%esp
  4f:	c9                   	leave  
  50:	c3                   	ret    
  51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  5f:	90                   	nop

00000060 <test>:
{
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	57                   	push   %edi
  64:	56                   	push   %esi
  65:	53                   	push   %ebx
  66:	83 ec 2c             	sub    $0x2c,%esp
    uint prev_free_pages = getNumFreePages();
  69:	e8 9d 05 00 00       	call   60b <getNumFreePages>
    char *m1 = (char*)malloc(size);
  6e:	83 ec 0c             	sub    $0xc,%esp
    long long size = ((prev_free_pages - 20) * 4 * 1024) / 2; // 20 pages will be used by kernel to create kstack, and process related datastructures.
  71:	8d 70 ec             	lea    -0x14(%eax),%esi
  74:	c1 e6 0c             	shl    $0xc,%esi
  77:	d1 ee                	shr    %esi
    char *m1 = (char*)malloc(size);
  79:	56                   	push   %esi
  7a:	e8 81 08 00 00       	call   900 <malloc>
    if (m1 == 0) goto out_of_memory;
  7f:	83 c4 10             	add    $0x10,%esp
  82:	85 c0                	test   %eax,%eax
  84:	0f 84 ac 01 00 00    	je     236 <test+0x1d6>
    printf(1, "\n*** Forking ***\n");
  8a:	83 ec 08             	sub    $0x8,%esp
  8d:	89 c7                	mov    %eax,%edi
  8f:	68 36 0a 00 00       	push   $0xa36
  94:	6a 01                	push   $0x1
  96:	e8 35 06 00 00       	call   6d0 <printf>
    pid = fork();
  9b:	e8 bb 04 00 00       	call   55b <fork>
    if (pid < 0) goto fork_failed; // Fork failed
  a0:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  a3:	89 c3                	mov    %eax,%ebx
    if (pid < 0) goto fork_failed; // Fork failed
  a5:	85 c0                	test   %eax,%eax
  a7:	0f 88 95 01 00 00    	js     242 <test+0x1e2>
    if (pid == 0) { // Child process
  ad:	0f 85 cf 00 00 00    	jne    182 <test+0x122>
        printf(1, "\n*** Child ***\n");
  b3:	50                   	push   %eax
  b4:	50                   	push   %eax
  b5:	68 63 0a 00 00       	push   $0xa63
  ba:	6a 01                	push   $0x1
  bc:	e8 0f 06 00 00       	call   6d0 <printf>
        prev_free_pages = getNumFreePages();
  c1:	e8 45 05 00 00       	call   60b <getNumFreePages>
        for (int i=0; i<size; i++) {
  c6:	83 c4 10             	add    $0x10,%esp
        prev_free_pages = getNumFreePages();
  c9:	89 45 d0             	mov    %eax,-0x30(%ebp)
        for (int i=0; i<size; i++) {
  cc:	85 f6                	test   %esi,%esi
  ce:	0f 84 a6 01 00 00    	je     27a <test+0x21a>
            m1[i] = (char)(65+(i%26));
  d4:	b9 4f ec c4 4e       	mov    $0x4ec4ec4f,%ecx
  d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  e0:	89 d8                	mov    %ebx,%eax
  e2:	f7 e1                	mul    %ecx
  e4:	89 d8                	mov    %ebx,%eax
  e6:	c1 ea 03             	shr    $0x3,%edx
  e9:	6b d2 1a             	imul   $0x1a,%edx,%edx
  ec:	29 d0                	sub    %edx,%eax
  ee:	83 c0 41             	add    $0x41,%eax
  f1:	88 04 1f             	mov    %al,(%edi,%ebx,1)
        for (int i=0; i<size; i++) {
  f4:	83 c3 01             	add    $0x1,%ebx
  f7:	39 f3                	cmp    %esi,%ebx
  f9:	75 e5                	jne    e0 <test+0x80>
        curr_free_pages = getNumFreePages();
  fb:	e8 0b 05 00 00       	call   60b <getNumFreePages>
        if (curr_free_pages >= prev_free_pages) {
 100:	39 45 d0             	cmp    %eax,-0x30(%ebp)
 103:	0f 86 5b 01 00 00    	jbe    264 <test+0x204>
        processing(&x);
 109:	83 ec 0c             	sub    $0xc,%esp
 10c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
        int x = 0;
 10f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
        processing(&x);
 116:	50                   	push   %eax
 117:	e8 14 ff ff ff       	call   30 <processing>
        for(int k=0;k<size;++k){
 11c:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 11f:	83 c4 10             	add    $0x10,%esp
        processing(&x);
 122:	31 c9                	xor    %ecx,%ecx
 124:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 12b:	31 db                	xor    %ebx,%ebx
 12d:	eb 19                	jmp    148 <test+0xe8>
 12f:	90                   	nop
        for(int k=0;k<size;++k){
 130:	83 c1 01             	add    $0x1,%ecx
 133:	8b 55 d0             	mov    -0x30(%ebp),%edx
 136:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 139:	83 d3 00             	adc    $0x0,%ebx
 13c:	31 d8                	xor    %ebx,%eax
 13e:	31 ca                	xor    %ecx,%edx
 140:	09 d0                	or     %edx,%eax
 142:	0f 84 52 01 00 00    	je     29a <test+0x23a>
			if(m1[k] != (char)(65+(k%26))) goto failed;
 148:	b8 4f ec c4 4e       	mov    $0x4ec4ec4f,%eax
 14d:	f7 e1                	mul    %ecx
 14f:	89 c8                	mov    %ecx,%eax
 151:	c1 ea 03             	shr    $0x3,%edx
 154:	6b d2 1a             	imul   $0x1a,%edx,%edx
 157:	29 d0                	sub    %edx,%eax
 159:	83 c0 41             	add    $0x41,%eax
 15c:	38 04 0f             	cmp    %al,(%edi,%ecx,1)
 15f:	74 cf                	je     130 <test+0xd0>
    printf(1, "Copy failed: The memory contents of the processes is inconsistent!\n");
 161:	50                   	push   %eax
 162:	50                   	push   %eax
 163:	68 44 0b 00 00       	push   $0xb44
	printf(1, "Failed to fork a process!\n");
 168:	6a 01                	push   $0x1
 16a:	e8 61 05 00 00       	call   6d0 <printf>
    printf(1, "Lab5 test failed!\n");
 16f:	58                   	pop    %eax
 170:	5a                   	pop    %edx
 171:	68 23 0a 00 00       	push   $0xa23
 176:	6a 01                	push   $0x1
 178:	e8 53 05 00 00       	call   6d0 <printf>
	exit();
 17d:	e8 e1 03 00 00       	call   563 <exit>
        printf(1, "\n*** Parent ***\n");
 182:	50                   	push   %eax
 183:	50                   	push   %eax
 184:	68 73 0a 00 00       	push   $0xa73
 189:	6a 01                	push   $0x1
 18b:	e8 40 05 00 00       	call   6d0 <printf>
        prev_free_pages = getNumFreePages();
 190:	e8 76 04 00 00       	call   60b <getNumFreePages>
        for (int i=0; i<size; i++) {
 195:	83 c4 10             	add    $0x10,%esp
        prev_free_pages = getNumFreePages();
 198:	89 45 d0             	mov    %eax,-0x30(%ebp)
        for (int i=0; i<size; i++) {
 19b:	85 f6                	test   %esi,%esi
 19d:	0f 84 0d 01 00 00    	je     2b0 <test+0x250>
 1a3:	31 db                	xor    %ebx,%ebx
            m1[i] = (char)(97+(i%26));
 1a5:	b9 4f ec c4 4e       	mov    $0x4ec4ec4f,%ecx
 1aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1b0:	89 d8                	mov    %ebx,%eax
 1b2:	f7 e1                	mul    %ecx
 1b4:	89 d8                	mov    %ebx,%eax
 1b6:	c1 ea 03             	shr    $0x3,%edx
 1b9:	6b d2 1a             	imul   $0x1a,%edx,%edx
 1bc:	29 d0                	sub    %edx,%eax
 1be:	83 c0 61             	add    $0x61,%eax
 1c1:	88 04 1f             	mov    %al,(%edi,%ebx,1)
        for (int i=0; i<size; i++) {
 1c4:	83 c3 01             	add    $0x1,%ebx
 1c7:	39 f3                	cmp    %esi,%ebx
 1c9:	75 e5                	jne    1b0 <test+0x150>
        curr_free_pages = getNumFreePages();
 1cb:	e8 3b 04 00 00       	call   60b <getNumFreePages>
        if (curr_free_pages >= prev_free_pages) {
 1d0:	39 45 d0             	cmp    %eax,-0x30(%ebp)
 1d3:	76 79                	jbe    24e <test+0x1ee>
        processing(&x);
 1d5:	83 ec 0c             	sub    $0xc,%esp
 1d8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
        int x = 0;
 1db:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
        processing(&x);
 1e2:	50                   	push   %eax
 1e3:	89 45 cc             	mov    %eax,-0x34(%ebp)
 1e6:	e8 45 fe ff ff       	call   30 <processing>
        for(int k=0;k<size;++k){
 1eb:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 1ee:	83 c4 10             	add    $0x10,%esp
        processing(&x);
 1f1:	31 c9                	xor    %ecx,%ecx
 1f3:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 1fa:	31 db                	xor    %ebx,%ebx
 1fc:	eb 1a                	jmp    218 <test+0x1b8>
 1fe:	66 90                	xchg   %ax,%ax
        for(int k=0;k<size;++k){
 200:	83 c1 01             	add    $0x1,%ecx
 203:	8b 55 d0             	mov    -0x30(%ebp),%edx
 206:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 209:	83 d3 00             	adc    $0x0,%ebx
 20c:	31 d8                	xor    %ebx,%eax
 20e:	31 ca                	xor    %ecx,%edx
 210:	09 d0                	or     %edx,%eax
 212:	0f 84 bb 00 00 00    	je     2d3 <test+0x273>
			if(m1[k] != (char)(97+(k%26))) goto failed;
 218:	b8 4f ec c4 4e       	mov    $0x4ec4ec4f,%eax
 21d:	f7 e1                	mul    %ecx
 21f:	89 c8                	mov    %ecx,%eax
 221:	c1 ea 03             	shr    $0x3,%edx
 224:	6b d2 1a             	imul   $0x1a,%edx,%edx
 227:	29 d0                	sub    %edx,%eax
 229:	83 c0 61             	add    $0x61,%eax
 22c:	38 04 0f             	cmp    %al,(%edi,%ecx,1)
 22f:	74 cf                	je     200 <test+0x1a0>
 231:	e9 2b ff ff ff       	jmp    161 <test+0x101>
	printf(1, "Exceeded the PHYSTOP!\n");
 236:	53                   	push   %ebx
 237:	53                   	push   %ebx
 238:	68 0c 0a 00 00       	push   $0xa0c
 23d:	e9 26 ff ff ff       	jmp    168 <test+0x108>
	printf(1, "Failed to fork a process!\n");
 242:	51                   	push   %ecx
 243:	51                   	push   %ecx
 244:	68 48 0a 00 00       	push   $0xa48
 249:	e9 1a ff ff ff       	jmp    168 <test+0x108>
            printf(1, "Lab5 Parent: Free pages should decrease after write\n");
 24e:	53                   	push   %ebx
 24f:	53                   	push   %ebx
 250:	68 ec 0a 00 00       	push   $0xaec
 255:	6a 01                	push   $0x1
 257:	e8 74 04 00 00       	call   6d0 <printf>
            goto failed;
 25c:	83 c4 10             	add    $0x10,%esp
 25f:	e9 fd fe ff ff       	jmp    161 <test+0x101>
            printf(1, "Lab5 Child: Free pages should decrease after write\n");
 264:	50                   	push   %eax
 265:	50                   	push   %eax
 266:	68 98 0a 00 00       	push   $0xa98
 26b:	6a 01                	push   $0x1
 26d:	e8 5e 04 00 00       	call   6d0 <printf>
            goto failed;
 272:	83 c4 10             	add    $0x10,%esp
 275:	e9 e7 fe ff ff       	jmp    161 <test+0x101>
        curr_free_pages = getNumFreePages();
 27a:	e8 8c 03 00 00       	call   60b <getNumFreePages>
        if (curr_free_pages >= prev_free_pages) {
 27f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
 282:	73 e0                	jae    264 <test+0x204>
        processing(&x);
 284:	83 ec 0c             	sub    $0xc,%esp
 287:	8d 45 e4             	lea    -0x1c(%ebp),%eax
        int x = 0;
 28a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
        processing(&x);
 291:	50                   	push   %eax
 292:	e8 99 fd ff ff       	call   30 <processing>
 297:	83 c4 10             	add    $0x10,%esp
        printf(1, "[COW] Lab5 Child test passed!\n");
 29a:	50                   	push   %eax
 29b:	50                   	push   %eax
 29c:	68 cc 0a 00 00       	push   $0xacc
 2a1:	6a 01                	push   $0x1
 2a3:	e8 28 04 00 00       	call   6d0 <printf>
 2a8:	83 c4 10             	add    $0x10,%esp
    exit();
 2ab:	e8 b3 02 00 00       	call   563 <exit>
        curr_free_pages = getNumFreePages();
 2b0:	e8 56 03 00 00       	call   60b <getNumFreePages>
        if (curr_free_pages >= prev_free_pages) {
 2b5:	39 45 d0             	cmp    %eax,-0x30(%ebp)
 2b8:	76 94                	jbe    24e <test+0x1ee>
        processing(&x);
 2ba:	83 ec 0c             	sub    $0xc,%esp
 2bd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
        int x = 0;
 2c0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
        processing(&x);
 2c7:	50                   	push   %eax
 2c8:	89 45 cc             	mov    %eax,-0x34(%ebp)
 2cb:	e8 60 fd ff ff       	call   30 <processing>
 2d0:	83 c4 10             	add    $0x10,%esp
        wait();
 2d3:	e8 93 02 00 00       	call   56b <wait>
        processing(&x);
 2d8:	83 ec 0c             	sub    $0xc,%esp
 2db:	ff 75 cc             	push   -0x34(%ebp)
 2de:	e8 4d fd ff ff       	call   30 <processing>
        printf(1, "done processing %d\n", x);
 2e3:	83 c4 0c             	add    $0xc,%esp
 2e6:	ff 75 e4             	push   -0x1c(%ebp)
 2e9:	68 f8 09 00 00       	push   $0x9f8
 2ee:	6a 01                	push   $0x1
 2f0:	e8 db 03 00 00       	call   6d0 <printf>
        printf(1, "[COW] Lab5 Parent test passed!\n");
 2f5:	5a                   	pop    %edx
 2f6:	59                   	pop    %ecx
 2f7:	68 24 0b 00 00       	push   $0xb24
 2fc:	6a 01                	push   $0x1
 2fe:	e8 cd 03 00 00       	call   6d0 <printf>
 303:	83 c4 10             	add    $0x10,%esp
 306:	eb a3                	jmp    2ab <test+0x24b>
 308:	66 90                	xchg   %ax,%ax
 30a:	66 90                	xchg   %ax,%ax
 30c:	66 90                	xchg   %ax,%ax
 30e:	66 90                	xchg   %ax,%ax

00000310 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 310:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 311:	31 c0                	xor    %eax,%eax
{
 313:	89 e5                	mov    %esp,%ebp
 315:	53                   	push   %ebx
 316:	8b 4d 08             	mov    0x8(%ebp),%ecx
 319:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 31c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 320:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 324:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 327:	83 c0 01             	add    $0x1,%eax
 32a:	84 d2                	test   %dl,%dl
 32c:	75 f2                	jne    320 <strcpy+0x10>
    ;
  return os;
}
 32e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 331:	89 c8                	mov    %ecx,%eax
 333:	c9                   	leave  
 334:	c3                   	ret    
 335:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 33c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000340 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	53                   	push   %ebx
 344:	8b 55 08             	mov    0x8(%ebp),%edx
 347:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 34a:	0f b6 02             	movzbl (%edx),%eax
 34d:	84 c0                	test   %al,%al
 34f:	75 17                	jne    368 <strcmp+0x28>
 351:	eb 3a                	jmp    38d <strcmp+0x4d>
 353:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 357:	90                   	nop
 358:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 35c:	83 c2 01             	add    $0x1,%edx
 35f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 362:	84 c0                	test   %al,%al
 364:	74 1a                	je     380 <strcmp+0x40>
    p++, q++;
 366:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 368:	0f b6 19             	movzbl (%ecx),%ebx
 36b:	38 c3                	cmp    %al,%bl
 36d:	74 e9                	je     358 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 36f:	29 d8                	sub    %ebx,%eax
}
 371:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 374:	c9                   	leave  
 375:	c3                   	ret    
 376:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 37d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 380:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 384:	31 c0                	xor    %eax,%eax
 386:	29 d8                	sub    %ebx,%eax
}
 388:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 38b:	c9                   	leave  
 38c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 38d:	0f b6 19             	movzbl (%ecx),%ebx
 390:	31 c0                	xor    %eax,%eax
 392:	eb db                	jmp    36f <strcmp+0x2f>
 394:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 39b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 39f:	90                   	nop

000003a0 <strlen>:

uint
strlen(const char *s)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 3a6:	80 3a 00             	cmpb   $0x0,(%edx)
 3a9:	74 15                	je     3c0 <strlen+0x20>
 3ab:	31 c0                	xor    %eax,%eax
 3ad:	8d 76 00             	lea    0x0(%esi),%esi
 3b0:	83 c0 01             	add    $0x1,%eax
 3b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 3b7:	89 c1                	mov    %eax,%ecx
 3b9:	75 f5                	jne    3b0 <strlen+0x10>
    ;
  return n;
}
 3bb:	89 c8                	mov    %ecx,%eax
 3bd:	5d                   	pop    %ebp
 3be:	c3                   	ret    
 3bf:	90                   	nop
  for(n = 0; s[n]; n++)
 3c0:	31 c9                	xor    %ecx,%ecx
}
 3c2:	5d                   	pop    %ebp
 3c3:	89 c8                	mov    %ecx,%eax
 3c5:	c3                   	ret    
 3c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3cd:	8d 76 00             	lea    0x0(%esi),%esi

000003d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	57                   	push   %edi
 3d4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 3d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3da:	8b 45 0c             	mov    0xc(%ebp),%eax
 3dd:	89 d7                	mov    %edx,%edi
 3df:	fc                   	cld    
 3e0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 3e2:	8b 7d fc             	mov    -0x4(%ebp),%edi
 3e5:	89 d0                	mov    %edx,%eax
 3e7:	c9                   	leave  
 3e8:	c3                   	ret    
 3e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000003f0 <strchr>:

char*
strchr(const char *s, char c)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	8b 45 08             	mov    0x8(%ebp),%eax
 3f6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 3fa:	0f b6 10             	movzbl (%eax),%edx
 3fd:	84 d2                	test   %dl,%dl
 3ff:	75 12                	jne    413 <strchr+0x23>
 401:	eb 1d                	jmp    420 <strchr+0x30>
 403:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 407:	90                   	nop
 408:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 40c:	83 c0 01             	add    $0x1,%eax
 40f:	84 d2                	test   %dl,%dl
 411:	74 0d                	je     420 <strchr+0x30>
    if(*s == c)
 413:	38 d1                	cmp    %dl,%cl
 415:	75 f1                	jne    408 <strchr+0x18>
      return (char*)s;
  return 0;
}
 417:	5d                   	pop    %ebp
 418:	c3                   	ret    
 419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 420:	31 c0                	xor    %eax,%eax
}
 422:	5d                   	pop    %ebp
 423:	c3                   	ret    
 424:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 42b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 42f:	90                   	nop

00000430 <gets>:

char*
gets(char *buf, int max)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	57                   	push   %edi
 434:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 435:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 438:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 439:	31 db                	xor    %ebx,%ebx
{
 43b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 43e:	eb 27                	jmp    467 <gets+0x37>
    cc = read(0, &c, 1);
 440:	83 ec 04             	sub    $0x4,%esp
 443:	6a 01                	push   $0x1
 445:	57                   	push   %edi
 446:	6a 00                	push   $0x0
 448:	e8 2e 01 00 00       	call   57b <read>
    if(cc < 1)
 44d:	83 c4 10             	add    $0x10,%esp
 450:	85 c0                	test   %eax,%eax
 452:	7e 1d                	jle    471 <gets+0x41>
      break;
    buf[i++] = c;
 454:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 458:	8b 55 08             	mov    0x8(%ebp),%edx
 45b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 45f:	3c 0a                	cmp    $0xa,%al
 461:	74 1d                	je     480 <gets+0x50>
 463:	3c 0d                	cmp    $0xd,%al
 465:	74 19                	je     480 <gets+0x50>
  for(i=0; i+1 < max; ){
 467:	89 de                	mov    %ebx,%esi
 469:	83 c3 01             	add    $0x1,%ebx
 46c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 46f:	7c cf                	jl     440 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 471:	8b 45 08             	mov    0x8(%ebp),%eax
 474:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 478:	8d 65 f4             	lea    -0xc(%ebp),%esp
 47b:	5b                   	pop    %ebx
 47c:	5e                   	pop    %esi
 47d:	5f                   	pop    %edi
 47e:	5d                   	pop    %ebp
 47f:	c3                   	ret    
  buf[i] = '\0';
 480:	8b 45 08             	mov    0x8(%ebp),%eax
 483:	89 de                	mov    %ebx,%esi
 485:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 489:	8d 65 f4             	lea    -0xc(%ebp),%esp
 48c:	5b                   	pop    %ebx
 48d:	5e                   	pop    %esi
 48e:	5f                   	pop    %edi
 48f:	5d                   	pop    %ebp
 490:	c3                   	ret    
 491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 498:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 49f:	90                   	nop

000004a0 <stat>:

int
stat(const char *n, struct stat *st)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	56                   	push   %esi
 4a4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4a5:	83 ec 08             	sub    $0x8,%esp
 4a8:	6a 00                	push   $0x0
 4aa:	ff 75 08             	push   0x8(%ebp)
 4ad:	e8 f1 00 00 00       	call   5a3 <open>
  if(fd < 0)
 4b2:	83 c4 10             	add    $0x10,%esp
 4b5:	85 c0                	test   %eax,%eax
 4b7:	78 27                	js     4e0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 4b9:	83 ec 08             	sub    $0x8,%esp
 4bc:	ff 75 0c             	push   0xc(%ebp)
 4bf:	89 c3                	mov    %eax,%ebx
 4c1:	50                   	push   %eax
 4c2:	e8 f4 00 00 00       	call   5bb <fstat>
  close(fd);
 4c7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 4ca:	89 c6                	mov    %eax,%esi
  close(fd);
 4cc:	e8 ba 00 00 00       	call   58b <close>
  return r;
 4d1:	83 c4 10             	add    $0x10,%esp
}
 4d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 4d7:	89 f0                	mov    %esi,%eax
 4d9:	5b                   	pop    %ebx
 4da:	5e                   	pop    %esi
 4db:	5d                   	pop    %ebp
 4dc:	c3                   	ret    
 4dd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 4e0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 4e5:	eb ed                	jmp    4d4 <stat+0x34>
 4e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4ee:	66 90                	xchg   %ax,%ax

000004f0 <atoi>:

int
atoi(const char *s)
{
 4f0:	55                   	push   %ebp
 4f1:	89 e5                	mov    %esp,%ebp
 4f3:	53                   	push   %ebx
 4f4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4f7:	0f be 02             	movsbl (%edx),%eax
 4fa:	8d 48 d0             	lea    -0x30(%eax),%ecx
 4fd:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 500:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 505:	77 1e                	ja     525 <atoi+0x35>
 507:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 50e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 510:	83 c2 01             	add    $0x1,%edx
 513:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 516:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 51a:	0f be 02             	movsbl (%edx),%eax
 51d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 520:	80 fb 09             	cmp    $0x9,%bl
 523:	76 eb                	jbe    510 <atoi+0x20>
  return n;
}
 525:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 528:	89 c8                	mov    %ecx,%eax
 52a:	c9                   	leave  
 52b:	c3                   	ret    
 52c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000530 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	57                   	push   %edi
 534:	8b 45 10             	mov    0x10(%ebp),%eax
 537:	8b 55 08             	mov    0x8(%ebp),%edx
 53a:	56                   	push   %esi
 53b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 53e:	85 c0                	test   %eax,%eax
 540:	7e 13                	jle    555 <memmove+0x25>
 542:	01 d0                	add    %edx,%eax
  dst = vdst;
 544:	89 d7                	mov    %edx,%edi
 546:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 54d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 550:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 551:	39 f8                	cmp    %edi,%eax
 553:	75 fb                	jne    550 <memmove+0x20>
  return vdst;
}
 555:	5e                   	pop    %esi
 556:	89 d0                	mov    %edx,%eax
 558:	5f                   	pop    %edi
 559:	5d                   	pop    %ebp
 55a:	c3                   	ret    

0000055b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 55b:	b8 01 00 00 00       	mov    $0x1,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret    

00000563 <exit>:
SYSCALL(exit)
 563:	b8 02 00 00 00       	mov    $0x2,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret    

0000056b <wait>:
SYSCALL(wait)
 56b:	b8 03 00 00 00       	mov    $0x3,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret    

00000573 <pipe>:
SYSCALL(pipe)
 573:	b8 04 00 00 00       	mov    $0x4,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret    

0000057b <read>:
SYSCALL(read)
 57b:	b8 05 00 00 00       	mov    $0x5,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret    

00000583 <write>:
SYSCALL(write)
 583:	b8 10 00 00 00       	mov    $0x10,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret    

0000058b <close>:
SYSCALL(close)
 58b:	b8 15 00 00 00       	mov    $0x15,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret    

00000593 <kill>:
SYSCALL(kill)
 593:	b8 06 00 00 00       	mov    $0x6,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret    

0000059b <exec>:
SYSCALL(exec)
 59b:	b8 07 00 00 00       	mov    $0x7,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret    

000005a3 <open>:
SYSCALL(open)
 5a3:	b8 0f 00 00 00       	mov    $0xf,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret    

000005ab <mknod>:
SYSCALL(mknod)
 5ab:	b8 11 00 00 00       	mov    $0x11,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret    

000005b3 <unlink>:
SYSCALL(unlink)
 5b3:	b8 12 00 00 00       	mov    $0x12,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret    

000005bb <fstat>:
SYSCALL(fstat)
 5bb:	b8 08 00 00 00       	mov    $0x8,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret    

000005c3 <link>:
SYSCALL(link)
 5c3:	b8 13 00 00 00       	mov    $0x13,%eax
 5c8:	cd 40                	int    $0x40
 5ca:	c3                   	ret    

000005cb <mkdir>:
SYSCALL(mkdir)
 5cb:	b8 14 00 00 00       	mov    $0x14,%eax
 5d0:	cd 40                	int    $0x40
 5d2:	c3                   	ret    

000005d3 <chdir>:
SYSCALL(chdir)
 5d3:	b8 09 00 00 00       	mov    $0x9,%eax
 5d8:	cd 40                	int    $0x40
 5da:	c3                   	ret    

000005db <dup>:
SYSCALL(dup)
 5db:	b8 0a 00 00 00       	mov    $0xa,%eax
 5e0:	cd 40                	int    $0x40
 5e2:	c3                   	ret    

000005e3 <getpid>:
SYSCALL(getpid)
 5e3:	b8 0b 00 00 00       	mov    $0xb,%eax
 5e8:	cd 40                	int    $0x40
 5ea:	c3                   	ret    

000005eb <sbrk>:
SYSCALL(sbrk)
 5eb:	b8 0c 00 00 00       	mov    $0xc,%eax
 5f0:	cd 40                	int    $0x40
 5f2:	c3                   	ret    

000005f3 <sleep>:
SYSCALL(sleep)
 5f3:	b8 0d 00 00 00       	mov    $0xd,%eax
 5f8:	cd 40                	int    $0x40
 5fa:	c3                   	ret    

000005fb <uptime>:
SYSCALL(uptime)
 5fb:	b8 0e 00 00 00       	mov    $0xe,%eax
 600:	cd 40                	int    $0x40
 602:	c3                   	ret    

00000603 <getrss>:
SYSCALL(getrss)
 603:	b8 16 00 00 00       	mov    $0x16,%eax
 608:	cd 40                	int    $0x40
 60a:	c3                   	ret    

0000060b <getNumFreePages>:
 60b:	b8 17 00 00 00       	mov    $0x17,%eax
 610:	cd 40                	int    $0x40
 612:	c3                   	ret    
 613:	66 90                	xchg   %ax,%ax
 615:	66 90                	xchg   %ax,%ax
 617:	66 90                	xchg   %ax,%ax
 619:	66 90                	xchg   %ax,%ax
 61b:	66 90                	xchg   %ax,%ax
 61d:	66 90                	xchg   %ax,%ax
 61f:	90                   	nop

00000620 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 620:	55                   	push   %ebp
 621:	89 e5                	mov    %esp,%ebp
 623:	57                   	push   %edi
 624:	56                   	push   %esi
 625:	53                   	push   %ebx
 626:	83 ec 3c             	sub    $0x3c,%esp
 629:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 62c:	89 d1                	mov    %edx,%ecx
{
 62e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 631:	85 d2                	test   %edx,%edx
 633:	0f 89 7f 00 00 00    	jns    6b8 <printint+0x98>
 639:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 63d:	74 79                	je     6b8 <printint+0x98>
    neg = 1;
 63f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 646:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 648:	31 db                	xor    %ebx,%ebx
 64a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 64d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 650:	89 c8                	mov    %ecx,%eax
 652:	31 d2                	xor    %edx,%edx
 654:	89 cf                	mov    %ecx,%edi
 656:	f7 75 c4             	divl   -0x3c(%ebp)
 659:	0f b6 92 e8 0b 00 00 	movzbl 0xbe8(%edx),%edx
 660:	89 45 c0             	mov    %eax,-0x40(%ebp)
 663:	89 d8                	mov    %ebx,%eax
 665:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 668:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 66b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 66e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 671:	76 dd                	jbe    650 <printint+0x30>
  if(neg)
 673:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 676:	85 c9                	test   %ecx,%ecx
 678:	74 0c                	je     686 <printint+0x66>
    buf[i++] = '-';
 67a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 67f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 681:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 686:	8b 7d b8             	mov    -0x48(%ebp),%edi
 689:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 68d:	eb 07                	jmp    696 <printint+0x76>
 68f:	90                   	nop
    putc(fd, buf[i]);
 690:	0f b6 13             	movzbl (%ebx),%edx
 693:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 696:	83 ec 04             	sub    $0x4,%esp
 699:	88 55 d7             	mov    %dl,-0x29(%ebp)
 69c:	6a 01                	push   $0x1
 69e:	56                   	push   %esi
 69f:	57                   	push   %edi
 6a0:	e8 de fe ff ff       	call   583 <write>
  while(--i >= 0)
 6a5:	83 c4 10             	add    $0x10,%esp
 6a8:	39 de                	cmp    %ebx,%esi
 6aa:	75 e4                	jne    690 <printint+0x70>
}
 6ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6af:	5b                   	pop    %ebx
 6b0:	5e                   	pop    %esi
 6b1:	5f                   	pop    %edi
 6b2:	5d                   	pop    %ebp
 6b3:	c3                   	ret    
 6b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 6b8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 6bf:	eb 87                	jmp    648 <printint+0x28>
 6c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6cf:	90                   	nop

000006d0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 6d0:	55                   	push   %ebp
 6d1:	89 e5                	mov    %esp,%ebp
 6d3:	57                   	push   %edi
 6d4:	56                   	push   %esi
 6d5:	53                   	push   %ebx
 6d6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 6dc:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 6df:	0f b6 13             	movzbl (%ebx),%edx
 6e2:	84 d2                	test   %dl,%dl
 6e4:	74 6a                	je     750 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 6e6:	8d 45 10             	lea    0x10(%ebp),%eax
 6e9:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 6ec:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 6ef:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 6f1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 6f4:	eb 36                	jmp    72c <printf+0x5c>
 6f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6fd:	8d 76 00             	lea    0x0(%esi),%esi
 700:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 703:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 708:	83 f8 25             	cmp    $0x25,%eax
 70b:	74 15                	je     722 <printf+0x52>
  write(fd, &c, 1);
 70d:	83 ec 04             	sub    $0x4,%esp
 710:	88 55 e7             	mov    %dl,-0x19(%ebp)
 713:	6a 01                	push   $0x1
 715:	57                   	push   %edi
 716:	56                   	push   %esi
 717:	e8 67 fe ff ff       	call   583 <write>
 71c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 71f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 722:	0f b6 13             	movzbl (%ebx),%edx
 725:	83 c3 01             	add    $0x1,%ebx
 728:	84 d2                	test   %dl,%dl
 72a:	74 24                	je     750 <printf+0x80>
    c = fmt[i] & 0xff;
 72c:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 72f:	85 c9                	test   %ecx,%ecx
 731:	74 cd                	je     700 <printf+0x30>
      }
    } else if(state == '%'){
 733:	83 f9 25             	cmp    $0x25,%ecx
 736:	75 ea                	jne    722 <printf+0x52>
      if(c == 'd'){
 738:	83 f8 25             	cmp    $0x25,%eax
 73b:	0f 84 07 01 00 00    	je     848 <printf+0x178>
 741:	83 e8 63             	sub    $0x63,%eax
 744:	83 f8 15             	cmp    $0x15,%eax
 747:	77 17                	ja     760 <printf+0x90>
 749:	ff 24 85 90 0b 00 00 	jmp    *0xb90(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 750:	8d 65 f4             	lea    -0xc(%ebp),%esp
 753:	5b                   	pop    %ebx
 754:	5e                   	pop    %esi
 755:	5f                   	pop    %edi
 756:	5d                   	pop    %ebp
 757:	c3                   	ret    
 758:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 75f:	90                   	nop
  write(fd, &c, 1);
 760:	83 ec 04             	sub    $0x4,%esp
 763:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 766:	6a 01                	push   $0x1
 768:	57                   	push   %edi
 769:	56                   	push   %esi
 76a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 76e:	e8 10 fe ff ff       	call   583 <write>
        putc(fd, c);
 773:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 777:	83 c4 0c             	add    $0xc,%esp
 77a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 77d:	6a 01                	push   $0x1
 77f:	57                   	push   %edi
 780:	56                   	push   %esi
 781:	e8 fd fd ff ff       	call   583 <write>
        putc(fd, c);
 786:	83 c4 10             	add    $0x10,%esp
      state = 0;
 789:	31 c9                	xor    %ecx,%ecx
 78b:	eb 95                	jmp    722 <printf+0x52>
 78d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 790:	83 ec 0c             	sub    $0xc,%esp
 793:	b9 10 00 00 00       	mov    $0x10,%ecx
 798:	6a 00                	push   $0x0
 79a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 79d:	8b 10                	mov    (%eax),%edx
 79f:	89 f0                	mov    %esi,%eax
 7a1:	e8 7a fe ff ff       	call   620 <printint>
        ap++;
 7a6:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 7aa:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7ad:	31 c9                	xor    %ecx,%ecx
 7af:	e9 6e ff ff ff       	jmp    722 <printf+0x52>
 7b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 7b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
 7bb:	8b 10                	mov    (%eax),%edx
        ap++;
 7bd:	83 c0 04             	add    $0x4,%eax
 7c0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 7c3:	85 d2                	test   %edx,%edx
 7c5:	0f 84 8d 00 00 00    	je     858 <printf+0x188>
        while(*s != 0){
 7cb:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 7ce:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 7d0:	84 c0                	test   %al,%al
 7d2:	0f 84 4a ff ff ff    	je     722 <printf+0x52>
 7d8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 7db:	89 d3                	mov    %edx,%ebx
 7dd:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 7e0:	83 ec 04             	sub    $0x4,%esp
          s++;
 7e3:	83 c3 01             	add    $0x1,%ebx
 7e6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 7e9:	6a 01                	push   $0x1
 7eb:	57                   	push   %edi
 7ec:	56                   	push   %esi
 7ed:	e8 91 fd ff ff       	call   583 <write>
        while(*s != 0){
 7f2:	0f b6 03             	movzbl (%ebx),%eax
 7f5:	83 c4 10             	add    $0x10,%esp
 7f8:	84 c0                	test   %al,%al
 7fa:	75 e4                	jne    7e0 <printf+0x110>
      state = 0;
 7fc:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 7ff:	31 c9                	xor    %ecx,%ecx
 801:	e9 1c ff ff ff       	jmp    722 <printf+0x52>
 806:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 80d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 810:	83 ec 0c             	sub    $0xc,%esp
 813:	b9 0a 00 00 00       	mov    $0xa,%ecx
 818:	6a 01                	push   $0x1
 81a:	e9 7b ff ff ff       	jmp    79a <printf+0xca>
 81f:	90                   	nop
        putc(fd, *ap);
 820:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 823:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 826:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 828:	6a 01                	push   $0x1
 82a:	57                   	push   %edi
 82b:	56                   	push   %esi
        putc(fd, *ap);
 82c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 82f:	e8 4f fd ff ff       	call   583 <write>
        ap++;
 834:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 838:	83 c4 10             	add    $0x10,%esp
      state = 0;
 83b:	31 c9                	xor    %ecx,%ecx
 83d:	e9 e0 fe ff ff       	jmp    722 <printf+0x52>
 842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 848:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 84b:	83 ec 04             	sub    $0x4,%esp
 84e:	e9 2a ff ff ff       	jmp    77d <printf+0xad>
 853:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 857:	90                   	nop
          s = "(null)";
 858:	ba 88 0b 00 00       	mov    $0xb88,%edx
        while(*s != 0){
 85d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 860:	b8 28 00 00 00       	mov    $0x28,%eax
 865:	89 d3                	mov    %edx,%ebx
 867:	e9 74 ff ff ff       	jmp    7e0 <printf+0x110>
 86c:	66 90                	xchg   %ax,%ax
 86e:	66 90                	xchg   %ax,%ax

00000870 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 870:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 871:	a1 d0 0e 00 00       	mov    0xed0,%eax
{
 876:	89 e5                	mov    %esp,%ebp
 878:	57                   	push   %edi
 879:	56                   	push   %esi
 87a:	53                   	push   %ebx
 87b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 87e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 888:	89 c2                	mov    %eax,%edx
 88a:	8b 00                	mov    (%eax),%eax
 88c:	39 ca                	cmp    %ecx,%edx
 88e:	73 30                	jae    8c0 <free+0x50>
 890:	39 c1                	cmp    %eax,%ecx
 892:	72 04                	jb     898 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 894:	39 c2                	cmp    %eax,%edx
 896:	72 f0                	jb     888 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 898:	8b 73 fc             	mov    -0x4(%ebx),%esi
 89b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 89e:	39 f8                	cmp    %edi,%eax
 8a0:	74 30                	je     8d2 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 8a2:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 8a5:	8b 42 04             	mov    0x4(%edx),%eax
 8a8:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 8ab:	39 f1                	cmp    %esi,%ecx
 8ad:	74 3a                	je     8e9 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 8af:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 8b1:	5b                   	pop    %ebx
  freep = p;
 8b2:	89 15 d0 0e 00 00    	mov    %edx,0xed0
}
 8b8:	5e                   	pop    %esi
 8b9:	5f                   	pop    %edi
 8ba:	5d                   	pop    %ebp
 8bb:	c3                   	ret    
 8bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c0:	39 c2                	cmp    %eax,%edx
 8c2:	72 c4                	jb     888 <free+0x18>
 8c4:	39 c1                	cmp    %eax,%ecx
 8c6:	73 c0                	jae    888 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 8c8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 8cb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 8ce:	39 f8                	cmp    %edi,%eax
 8d0:	75 d0                	jne    8a2 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 8d2:	03 70 04             	add    0x4(%eax),%esi
 8d5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 8d8:	8b 02                	mov    (%edx),%eax
 8da:	8b 00                	mov    (%eax),%eax
 8dc:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 8df:	8b 42 04             	mov    0x4(%edx),%eax
 8e2:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 8e5:	39 f1                	cmp    %esi,%ecx
 8e7:	75 c6                	jne    8af <free+0x3f>
    p->s.size += bp->s.size;
 8e9:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 8ec:	89 15 d0 0e 00 00    	mov    %edx,0xed0
    p->s.size += bp->s.size;
 8f2:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 8f5:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 8f8:	89 0a                	mov    %ecx,(%edx)
}
 8fa:	5b                   	pop    %ebx
 8fb:	5e                   	pop    %esi
 8fc:	5f                   	pop    %edi
 8fd:	5d                   	pop    %ebp
 8fe:	c3                   	ret    
 8ff:	90                   	nop

00000900 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 900:	55                   	push   %ebp
 901:	89 e5                	mov    %esp,%ebp
 903:	57                   	push   %edi
 904:	56                   	push   %esi
 905:	53                   	push   %ebx
 906:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 909:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 90c:	8b 3d d0 0e 00 00    	mov    0xed0,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 912:	8d 70 07             	lea    0x7(%eax),%esi
 915:	c1 ee 03             	shr    $0x3,%esi
 918:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 91b:	85 ff                	test   %edi,%edi
 91d:	0f 84 9d 00 00 00    	je     9c0 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 923:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 925:	8b 4a 04             	mov    0x4(%edx),%ecx
 928:	39 f1                	cmp    %esi,%ecx
 92a:	73 6a                	jae    996 <malloc+0x96>
 92c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 931:	39 de                	cmp    %ebx,%esi
 933:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 936:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 93d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 940:	eb 17                	jmp    959 <malloc+0x59>
 942:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 948:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 94a:	8b 48 04             	mov    0x4(%eax),%ecx
 94d:	39 f1                	cmp    %esi,%ecx
 94f:	73 4f                	jae    9a0 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 951:	8b 3d d0 0e 00 00    	mov    0xed0,%edi
 957:	89 c2                	mov    %eax,%edx
 959:	39 d7                	cmp    %edx,%edi
 95b:	75 eb                	jne    948 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 95d:	83 ec 0c             	sub    $0xc,%esp
 960:	ff 75 e4             	push   -0x1c(%ebp)
 963:	e8 83 fc ff ff       	call   5eb <sbrk>
  if(p == (char*)-1)
 968:	83 c4 10             	add    $0x10,%esp
 96b:	83 f8 ff             	cmp    $0xffffffff,%eax
 96e:	74 1c                	je     98c <malloc+0x8c>
  hp->s.size = nu;
 970:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 973:	83 ec 0c             	sub    $0xc,%esp
 976:	83 c0 08             	add    $0x8,%eax
 979:	50                   	push   %eax
 97a:	e8 f1 fe ff ff       	call   870 <free>
  return freep;
 97f:	8b 15 d0 0e 00 00    	mov    0xed0,%edx
      if((p = morecore(nunits)) == 0)
 985:	83 c4 10             	add    $0x10,%esp
 988:	85 d2                	test   %edx,%edx
 98a:	75 bc                	jne    948 <malloc+0x48>
        return 0;
  }
}
 98c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 98f:	31 c0                	xor    %eax,%eax
}
 991:	5b                   	pop    %ebx
 992:	5e                   	pop    %esi
 993:	5f                   	pop    %edi
 994:	5d                   	pop    %ebp
 995:	c3                   	ret    
    if(p->s.size >= nunits){
 996:	89 d0                	mov    %edx,%eax
 998:	89 fa                	mov    %edi,%edx
 99a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 9a0:	39 ce                	cmp    %ecx,%esi
 9a2:	74 4c                	je     9f0 <malloc+0xf0>
        p->s.size -= nunits;
 9a4:	29 f1                	sub    %esi,%ecx
 9a6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 9a9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 9ac:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 9af:	89 15 d0 0e 00 00    	mov    %edx,0xed0
}
 9b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 9b8:	83 c0 08             	add    $0x8,%eax
}
 9bb:	5b                   	pop    %ebx
 9bc:	5e                   	pop    %esi
 9bd:	5f                   	pop    %edi
 9be:	5d                   	pop    %ebp
 9bf:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 9c0:	c7 05 d0 0e 00 00 d4 	movl   $0xed4,0xed0
 9c7:	0e 00 00 
    base.s.size = 0;
 9ca:	bf d4 0e 00 00       	mov    $0xed4,%edi
    base.s.ptr = freep = prevp = &base;
 9cf:	c7 05 d4 0e 00 00 d4 	movl   $0xed4,0xed4
 9d6:	0e 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9d9:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 9db:	c7 05 d8 0e 00 00 00 	movl   $0x0,0xed8
 9e2:	00 00 00 
    if(p->s.size >= nunits){
 9e5:	e9 42 ff ff ff       	jmp    92c <malloc+0x2c>
 9ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 9f0:	8b 08                	mov    (%eax),%ecx
 9f2:	89 0a                	mov    %ecx,(%edx)
 9f4:	eb b9                	jmp    9af <malloc+0xaf>
