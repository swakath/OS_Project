
_testcow1:     file format elf32-i386


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
  11:	68 f0 09 00 00       	push   $0x9f0
  16:	6a 01                	push   $0x1
  18:	e8 73 05 00 00       	call   590 <printf>
	test();
  1d:	e8 0e 00 00 00       	call   30 <test>
  22:	66 90                	xchg   %ax,%ax
  24:	66 90                	xchg   %ax,%ax
  26:	66 90                	xchg   %ax,%ax
  28:	66 90                	xchg   %ax,%ax
  2a:	66 90                	xchg   %ax,%ax
  2c:	66 90                	xchg   %ax,%ax
  2e:	66 90                	xchg   %ax,%ax

00000030 <test>:
{
  30:	55                   	push   %ebp
  31:	89 e5                	mov    %esp,%ebp
  33:	57                   	push   %edi
  34:	56                   	push   %esi
  35:	53                   	push   %ebx
  36:	83 ec 1c             	sub    $0x1c,%esp
    uint prev_free_pages = getNumFreePages();
  39:	e8 8d 04 00 00       	call   4cb <getNumFreePages>
    long long size = ((prev_free_pages - 20) * 4096); // 20 pages will be used by kernel to create kstack, and process related datastructures.
  3e:	31 d2                	xor    %edx,%edx
  40:	8d 58 ec             	lea    -0x14(%eax),%ebx
    printf(1, "Allocating %d bytes for each process\n", size);
  43:	52                   	push   %edx
    long long size = ((prev_free_pages - 20) * 4096); // 20 pages will be used by kernel to create kstack, and process related datastructures.
  44:	c1 e3 0c             	shl    $0xc,%ebx
  47:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    printf(1, "Allocating %d bytes for each process\n", size);
  4a:	53                   	push   %ebx
  4b:	68 b8 08 00 00       	push   $0x8b8
  50:	6a 01                	push   $0x1
    long long size = ((prev_free_pages - 20) * 4096); // 20 pages will be used by kernel to create kstack, and process related datastructures.
  52:	89 5d e0             	mov    %ebx,-0x20(%ebp)
    printf(1, "Allocating %d bytes for each process\n", size);
  55:	e8 36 05 00 00       	call   590 <printf>
    char *m1 = (char*)malloc(size);
  5a:	89 1c 24             	mov    %ebx,(%esp)
  5d:	e8 5e 07 00 00       	call   7c0 <malloc>
    if (m1 == 0) goto out_of_memory;
  62:	83 c4 10             	add    $0x10,%esp
  65:	85 c0                	test   %eax,%eax
  67:	0f 84 37 01 00 00    	je     1a4 <test+0x174>
  6d:	89 c7                	mov    %eax,%edi
    for(int k=0;k<size;++k){
  6f:	31 c9                	xor    %ecx,%ecx
        m1[k] = (char)(65+(k%26));
  71:	be 4f ec c4 4e       	mov    $0x4ec4ec4f,%esi
    for(int k=0;k<size;++k){
  76:	85 db                	test   %ebx,%ebx
  78:	74 1b                	je     95 <test+0x65>
        m1[k] = (char)(65+(k%26));
  7a:	89 c8                	mov    %ecx,%eax
  7c:	f7 e6                	mul    %esi
  7e:	c1 ea 03             	shr    $0x3,%edx
  81:	6b c2 1a             	imul   $0x1a,%edx,%eax
  84:	89 ca                	mov    %ecx,%edx
  86:	29 c2                	sub    %eax,%edx
  88:	83 c2 41             	add    $0x41,%edx
  8b:	88 14 0f             	mov    %dl,(%edi,%ecx,1)
    for(int k=0;k<size;++k){
  8e:	83 c1 01             	add    $0x1,%ecx
  91:	39 d9                	cmp    %ebx,%ecx
  93:	75 e5                	jne    7a <test+0x4a>
    printf(1, "\n*** Forking ***\n");
  95:	83 ec 08             	sub    $0x8,%esp
  98:	68 8e 09 00 00       	push   $0x98e
  9d:	6a 01                	push   $0x1
  9f:	e8 ec 04 00 00       	call   590 <printf>
    pid = fork();
  a4:	e8 72 03 00 00       	call   41b <fork>
    if (pid < 0) goto fork_failed; // Fork failed
  a9:	83 c4 10             	add    $0x10,%esp
  ac:	85 c0                	test   %eax,%eax
  ae:	0f 88 fc 00 00 00    	js     1b0 <test+0x180>
    if (pid == 0) { // Child process
  b4:	75 74                	jne    12a <test+0xfa>
        printf(1, "\n*** Child ***\n");
  b6:	50                   	push   %eax
  b7:	50                   	push   %eax
  b8:	68 bb 09 00 00       	push   $0x9bb
  bd:	6a 01                	push   $0x1
  bf:	e8 cc 04 00 00       	call   590 <printf>
        for(int k=0;k<size;++k){
  c4:	83 c4 10             	add    $0x10,%esp
  c7:	0b 5d e4             	or     -0x1c(%ebp),%ebx
  ca:	0f 84 ec 00 00 00    	je     1bc <test+0x18c>
  d0:	31 db                	xor    %ebx,%ebx
  d2:	31 f6                	xor    %esi,%esi
  d4:	eb 18                	jmp    ee <test+0xbe>
  d6:	83 c3 01             	add    $0x1,%ebx
  d9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  df:	83 d6 00             	adc    $0x0,%esi
  e2:	31 f0                	xor    %esi,%eax
  e4:	31 da                	xor    %ebx,%edx
  e6:	09 d0                	or     %edx,%eax
  e8:	0f 84 ce 00 00 00    	je     1bc <test+0x18c>
			if(m1[k] != (char)(65+(k%26))) goto failed;
  ee:	b8 4f ec c4 4e       	mov    $0x4ec4ec4f,%eax
  f3:	f7 e3                	mul    %ebx
  f5:	89 d0                	mov    %edx,%eax
  f7:	89 da                	mov    %ebx,%edx
  f9:	c1 e8 03             	shr    $0x3,%eax
  fc:	6b c0 1a             	imul   $0x1a,%eax,%eax
  ff:	29 c2                	sub    %eax,%edx
 101:	83 c2 41             	add    $0x41,%edx
 104:	38 14 1f             	cmp    %dl,(%edi,%ebx,1)
 107:	74 cd                	je     d6 <test+0xa6>
    printf(1, "Copy failed: The memory contents of the processes is inconsistent!\n");
 109:	50                   	push   %eax
 10a:	50                   	push   %eax
 10b:	68 20 09 00 00       	push   $0x920
	printf(1, "Failed to fork a process!\n");
 110:	6a 01                	push   $0x1
 112:	e8 79 04 00 00       	call   590 <printf>
    printf(1, "Lab5 test failed!\n");
 117:	58                   	pop    %eax
 118:	5a                   	pop    %edx
 119:	68 7b 09 00 00       	push   $0x97b
 11e:	6a 01                	push   $0x1
 120:	e8 6b 04 00 00       	call   590 <printf>
	exit();
 125:	e8 f9 02 00 00       	call   423 <exit>
        printf(1, "\n*** Parent ***\n");
 12a:	56                   	push   %esi
 12b:	56                   	push   %esi
 12c:	68 cb 09 00 00       	push   $0x9cb
 131:	6a 01                	push   $0x1
 133:	e8 58 04 00 00       	call   590 <printf>
        for(int k=0;k<size;++k){
 138:	83 c4 10             	add    $0x10,%esp
 13b:	0b 5d e4             	or     -0x1c(%ebp),%ebx
 13e:	74 37                	je     177 <test+0x147>
 140:	31 db                	xor    %ebx,%ebx
 142:	31 f6                	xor    %esi,%esi
 144:	eb 14                	jmp    15a <test+0x12a>
 146:	83 c3 01             	add    $0x1,%ebx
 149:	8b 55 e0             	mov    -0x20(%ebp),%edx
 14c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 14f:	83 d6 00             	adc    $0x0,%esi
 152:	31 f0                	xor    %esi,%eax
 154:	31 da                	xor    %ebx,%edx
 156:	09 d0                	or     %edx,%eax
 158:	74 1d                	je     177 <test+0x147>
            if(m1[k] != (char)(65+(k%26))) goto failed;
 15a:	b8 4f ec c4 4e       	mov    $0x4ec4ec4f,%eax
 15f:	f7 e3                	mul    %ebx
 161:	89 d0                	mov    %edx,%eax
 163:	89 da                	mov    %ebx,%edx
 165:	c1 e8 03             	shr    $0x3,%eax
 168:	6b c0 1a             	imul   $0x1a,%eax,%eax
 16b:	29 c2                	sub    %eax,%edx
 16d:	83 c2 41             	add    $0x41,%edx
 170:	38 14 1f             	cmp    %dl,(%edi,%ebx,1)
 173:	74 d1                	je     146 <test+0x116>
 175:	eb 92                	jmp    109 <test+0xd9>
        wait();
 177:	e8 af 02 00 00       	call   42b <wait>
        printf(1, "done processing %d\n", x);
 17c:	52                   	push   %edx
 17d:	68 ae ad 01 00       	push   $0x1adae
 182:	68 dc 09 00 00       	push   $0x9dc
 187:	6a 01                	push   $0x1
 189:	e8 02 04 00 00       	call   590 <printf>
        printf(1, "[COW] Lab5 Parent test passed!\n");
 18e:	59                   	pop    %ecx
 18f:	5b                   	pop    %ebx
 190:	68 00 09 00 00       	push   $0x900
 195:	6a 01                	push   $0x1
 197:	e8 f4 03 00 00       	call   590 <printf>
 19c:	83 c4 10             	add    $0x10,%esp
    exit();
 19f:	e8 7f 02 00 00       	call   423 <exit>
	printf(1, "Exceeded the PHYSTOP!\n");
 1a4:	53                   	push   %ebx
 1a5:	53                   	push   %ebx
 1a6:	68 64 09 00 00       	push   $0x964
 1ab:	e9 60 ff ff ff       	jmp    110 <test+0xe0>
	printf(1, "Failed to fork a process!\n");
 1b0:	51                   	push   %ecx
 1b1:	51                   	push   %ecx
 1b2:	68 a0 09 00 00       	push   $0x9a0
 1b7:	e9 54 ff ff ff       	jmp    110 <test+0xe0>
        printf(1, "[COW] Lab5 Child test passed!\n");
 1bc:	57                   	push   %edi
 1bd:	57                   	push   %edi
 1be:	68 e0 08 00 00       	push   $0x8e0
 1c3:	6a 01                	push   $0x1
 1c5:	e8 c6 03 00 00       	call   590 <printf>
 1ca:	83 c4 10             	add    $0x10,%esp
 1cd:	eb d0                	jmp    19f <test+0x16f>
 1cf:	90                   	nop

000001d0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 1d0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1d1:	31 c0                	xor    %eax,%eax
{
 1d3:	89 e5                	mov    %esp,%ebp
 1d5:	53                   	push   %ebx
 1d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 1dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 1e0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 1e4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 1e7:	83 c0 01             	add    $0x1,%eax
 1ea:	84 d2                	test   %dl,%dl
 1ec:	75 f2                	jne    1e0 <strcpy+0x10>
    ;
  return os;
}
 1ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1f1:	89 c8                	mov    %ecx,%eax
 1f3:	c9                   	leave  
 1f4:	c3                   	ret    
 1f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000200 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	53                   	push   %ebx
 204:	8b 55 08             	mov    0x8(%ebp),%edx
 207:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 20a:	0f b6 02             	movzbl (%edx),%eax
 20d:	84 c0                	test   %al,%al
 20f:	75 17                	jne    228 <strcmp+0x28>
 211:	eb 3a                	jmp    24d <strcmp+0x4d>
 213:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 217:	90                   	nop
 218:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 21c:	83 c2 01             	add    $0x1,%edx
 21f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 222:	84 c0                	test   %al,%al
 224:	74 1a                	je     240 <strcmp+0x40>
    p++, q++;
 226:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 228:	0f b6 19             	movzbl (%ecx),%ebx
 22b:	38 c3                	cmp    %al,%bl
 22d:	74 e9                	je     218 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 22f:	29 d8                	sub    %ebx,%eax
}
 231:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 234:	c9                   	leave  
 235:	c3                   	ret    
 236:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 23d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 240:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 244:	31 c0                	xor    %eax,%eax
 246:	29 d8                	sub    %ebx,%eax
}
 248:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 24b:	c9                   	leave  
 24c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 24d:	0f b6 19             	movzbl (%ecx),%ebx
 250:	31 c0                	xor    %eax,%eax
 252:	eb db                	jmp    22f <strcmp+0x2f>
 254:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 25b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 25f:	90                   	nop

00000260 <strlen>:

uint
strlen(const char *s)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 266:	80 3a 00             	cmpb   $0x0,(%edx)
 269:	74 15                	je     280 <strlen+0x20>
 26b:	31 c0                	xor    %eax,%eax
 26d:	8d 76 00             	lea    0x0(%esi),%esi
 270:	83 c0 01             	add    $0x1,%eax
 273:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 277:	89 c1                	mov    %eax,%ecx
 279:	75 f5                	jne    270 <strlen+0x10>
    ;
  return n;
}
 27b:	89 c8                	mov    %ecx,%eax
 27d:	5d                   	pop    %ebp
 27e:	c3                   	ret    
 27f:	90                   	nop
  for(n = 0; s[n]; n++)
 280:	31 c9                	xor    %ecx,%ecx
}
 282:	5d                   	pop    %ebp
 283:	89 c8                	mov    %ecx,%eax
 285:	c3                   	ret    
 286:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 28d:	8d 76 00             	lea    0x0(%esi),%esi

00000290 <memset>:

void*
memset(void *dst, int c, uint n)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	57                   	push   %edi
 294:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 297:	8b 4d 10             	mov    0x10(%ebp),%ecx
 29a:	8b 45 0c             	mov    0xc(%ebp),%eax
 29d:	89 d7                	mov    %edx,%edi
 29f:	fc                   	cld    
 2a0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 2a2:	8b 7d fc             	mov    -0x4(%ebp),%edi
 2a5:	89 d0                	mov    %edx,%eax
 2a7:	c9                   	leave  
 2a8:	c3                   	ret    
 2a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002b0 <strchr>:

char*
strchr(const char *s, char c)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	8b 45 08             	mov    0x8(%ebp),%eax
 2b6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 2ba:	0f b6 10             	movzbl (%eax),%edx
 2bd:	84 d2                	test   %dl,%dl
 2bf:	75 12                	jne    2d3 <strchr+0x23>
 2c1:	eb 1d                	jmp    2e0 <strchr+0x30>
 2c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2c7:	90                   	nop
 2c8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 2cc:	83 c0 01             	add    $0x1,%eax
 2cf:	84 d2                	test   %dl,%dl
 2d1:	74 0d                	je     2e0 <strchr+0x30>
    if(*s == c)
 2d3:	38 d1                	cmp    %dl,%cl
 2d5:	75 f1                	jne    2c8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 2d7:	5d                   	pop    %ebp
 2d8:	c3                   	ret    
 2d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 2e0:	31 c0                	xor    %eax,%eax
}
 2e2:	5d                   	pop    %ebp
 2e3:	c3                   	ret    
 2e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2ef:	90                   	nop

000002f0 <gets>:

char*
gets(char *buf, int max)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	57                   	push   %edi
 2f4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 2f5:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 2f8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 2f9:	31 db                	xor    %ebx,%ebx
{
 2fb:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 2fe:	eb 27                	jmp    327 <gets+0x37>
    cc = read(0, &c, 1);
 300:	83 ec 04             	sub    $0x4,%esp
 303:	6a 01                	push   $0x1
 305:	57                   	push   %edi
 306:	6a 00                	push   $0x0
 308:	e8 2e 01 00 00       	call   43b <read>
    if(cc < 1)
 30d:	83 c4 10             	add    $0x10,%esp
 310:	85 c0                	test   %eax,%eax
 312:	7e 1d                	jle    331 <gets+0x41>
      break;
    buf[i++] = c;
 314:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 318:	8b 55 08             	mov    0x8(%ebp),%edx
 31b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 31f:	3c 0a                	cmp    $0xa,%al
 321:	74 1d                	je     340 <gets+0x50>
 323:	3c 0d                	cmp    $0xd,%al
 325:	74 19                	je     340 <gets+0x50>
  for(i=0; i+1 < max; ){
 327:	89 de                	mov    %ebx,%esi
 329:	83 c3 01             	add    $0x1,%ebx
 32c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 32f:	7c cf                	jl     300 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 331:	8b 45 08             	mov    0x8(%ebp),%eax
 334:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 338:	8d 65 f4             	lea    -0xc(%ebp),%esp
 33b:	5b                   	pop    %ebx
 33c:	5e                   	pop    %esi
 33d:	5f                   	pop    %edi
 33e:	5d                   	pop    %ebp
 33f:	c3                   	ret    
  buf[i] = '\0';
 340:	8b 45 08             	mov    0x8(%ebp),%eax
 343:	89 de                	mov    %ebx,%esi
 345:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 349:	8d 65 f4             	lea    -0xc(%ebp),%esp
 34c:	5b                   	pop    %ebx
 34d:	5e                   	pop    %esi
 34e:	5f                   	pop    %edi
 34f:	5d                   	pop    %ebp
 350:	c3                   	ret    
 351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 358:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 35f:	90                   	nop

00000360 <stat>:

int
stat(const char *n, struct stat *st)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	56                   	push   %esi
 364:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 365:	83 ec 08             	sub    $0x8,%esp
 368:	6a 00                	push   $0x0
 36a:	ff 75 08             	push   0x8(%ebp)
 36d:	e8 f1 00 00 00       	call   463 <open>
  if(fd < 0)
 372:	83 c4 10             	add    $0x10,%esp
 375:	85 c0                	test   %eax,%eax
 377:	78 27                	js     3a0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 379:	83 ec 08             	sub    $0x8,%esp
 37c:	ff 75 0c             	push   0xc(%ebp)
 37f:	89 c3                	mov    %eax,%ebx
 381:	50                   	push   %eax
 382:	e8 f4 00 00 00       	call   47b <fstat>
  close(fd);
 387:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 38a:	89 c6                	mov    %eax,%esi
  close(fd);
 38c:	e8 ba 00 00 00       	call   44b <close>
  return r;
 391:	83 c4 10             	add    $0x10,%esp
}
 394:	8d 65 f8             	lea    -0x8(%ebp),%esp
 397:	89 f0                	mov    %esi,%eax
 399:	5b                   	pop    %ebx
 39a:	5e                   	pop    %esi
 39b:	5d                   	pop    %ebp
 39c:	c3                   	ret    
 39d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 3a0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 3a5:	eb ed                	jmp    394 <stat+0x34>
 3a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3ae:	66 90                	xchg   %ax,%ax

000003b0 <atoi>:

int
atoi(const char *s)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	53                   	push   %ebx
 3b4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3b7:	0f be 02             	movsbl (%edx),%eax
 3ba:	8d 48 d0             	lea    -0x30(%eax),%ecx
 3bd:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 3c0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 3c5:	77 1e                	ja     3e5 <atoi+0x35>
 3c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3ce:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 3d0:	83 c2 01             	add    $0x1,%edx
 3d3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 3d6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 3da:	0f be 02             	movsbl (%edx),%eax
 3dd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 3e0:	80 fb 09             	cmp    $0x9,%bl
 3e3:	76 eb                	jbe    3d0 <atoi+0x20>
  return n;
}
 3e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3e8:	89 c8                	mov    %ecx,%eax
 3ea:	c9                   	leave  
 3eb:	c3                   	ret    
 3ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003f0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	57                   	push   %edi
 3f4:	8b 45 10             	mov    0x10(%ebp),%eax
 3f7:	8b 55 08             	mov    0x8(%ebp),%edx
 3fa:	56                   	push   %esi
 3fb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3fe:	85 c0                	test   %eax,%eax
 400:	7e 13                	jle    415 <memmove+0x25>
 402:	01 d0                	add    %edx,%eax
  dst = vdst;
 404:	89 d7                	mov    %edx,%edi
 406:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 40d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 410:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 411:	39 f8                	cmp    %edi,%eax
 413:	75 fb                	jne    410 <memmove+0x20>
  return vdst;
}
 415:	5e                   	pop    %esi
 416:	89 d0                	mov    %edx,%eax
 418:	5f                   	pop    %edi
 419:	5d                   	pop    %ebp
 41a:	c3                   	ret    

0000041b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 41b:	b8 01 00 00 00       	mov    $0x1,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <exit>:
SYSCALL(exit)
 423:	b8 02 00 00 00       	mov    $0x2,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <wait>:
SYSCALL(wait)
 42b:	b8 03 00 00 00       	mov    $0x3,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <pipe>:
SYSCALL(pipe)
 433:	b8 04 00 00 00       	mov    $0x4,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <read>:
SYSCALL(read)
 43b:	b8 05 00 00 00       	mov    $0x5,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <write>:
SYSCALL(write)
 443:	b8 10 00 00 00       	mov    $0x10,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <close>:
SYSCALL(close)
 44b:	b8 15 00 00 00       	mov    $0x15,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <kill>:
SYSCALL(kill)
 453:	b8 06 00 00 00       	mov    $0x6,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <exec>:
SYSCALL(exec)
 45b:	b8 07 00 00 00       	mov    $0x7,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <open>:
SYSCALL(open)
 463:	b8 0f 00 00 00       	mov    $0xf,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <mknod>:
SYSCALL(mknod)
 46b:	b8 11 00 00 00       	mov    $0x11,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <unlink>:
SYSCALL(unlink)
 473:	b8 12 00 00 00       	mov    $0x12,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <fstat>:
SYSCALL(fstat)
 47b:	b8 08 00 00 00       	mov    $0x8,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <link>:
SYSCALL(link)
 483:	b8 13 00 00 00       	mov    $0x13,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <mkdir>:
SYSCALL(mkdir)
 48b:	b8 14 00 00 00       	mov    $0x14,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <chdir>:
SYSCALL(chdir)
 493:	b8 09 00 00 00       	mov    $0x9,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <dup>:
SYSCALL(dup)
 49b:	b8 0a 00 00 00       	mov    $0xa,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <getpid>:
SYSCALL(getpid)
 4a3:	b8 0b 00 00 00       	mov    $0xb,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret    

000004ab <sbrk>:
SYSCALL(sbrk)
 4ab:	b8 0c 00 00 00       	mov    $0xc,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret    

000004b3 <sleep>:
SYSCALL(sleep)
 4b3:	b8 0d 00 00 00       	mov    $0xd,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret    

000004bb <uptime>:
SYSCALL(uptime)
 4bb:	b8 0e 00 00 00       	mov    $0xe,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    

000004c3 <getrss>:
SYSCALL(getrss)
 4c3:	b8 16 00 00 00       	mov    $0x16,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret    

000004cb <getNumFreePages>:
 4cb:	b8 17 00 00 00       	mov    $0x17,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret    
 4d3:	66 90                	xchg   %ax,%ax
 4d5:	66 90                	xchg   %ax,%ax
 4d7:	66 90                	xchg   %ax,%ax
 4d9:	66 90                	xchg   %ax,%ax
 4db:	66 90                	xchg   %ax,%ax
 4dd:	66 90                	xchg   %ax,%ax
 4df:	90                   	nop

000004e0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 4e0:	55                   	push   %ebp
 4e1:	89 e5                	mov    %esp,%ebp
 4e3:	57                   	push   %edi
 4e4:	56                   	push   %esi
 4e5:	53                   	push   %ebx
 4e6:	83 ec 3c             	sub    $0x3c,%esp
 4e9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 4ec:	89 d1                	mov    %edx,%ecx
{
 4ee:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 4f1:	85 d2                	test   %edx,%edx
 4f3:	0f 89 7f 00 00 00    	jns    578 <printint+0x98>
 4f9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 4fd:	74 79                	je     578 <printint+0x98>
    neg = 1;
 4ff:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 506:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 508:	31 db                	xor    %ebx,%ebx
 50a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 50d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 510:	89 c8                	mov    %ecx,%eax
 512:	31 d2                	xor    %edx,%edx
 514:	89 cf                	mov    %ecx,%edi
 516:	f7 75 c4             	divl   -0x3c(%ebp)
 519:	0f b6 92 64 0a 00 00 	movzbl 0xa64(%edx),%edx
 520:	89 45 c0             	mov    %eax,-0x40(%ebp)
 523:	89 d8                	mov    %ebx,%eax
 525:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 528:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 52b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 52e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 531:	76 dd                	jbe    510 <printint+0x30>
  if(neg)
 533:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 536:	85 c9                	test   %ecx,%ecx
 538:	74 0c                	je     546 <printint+0x66>
    buf[i++] = '-';
 53a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 53f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 541:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 546:	8b 7d b8             	mov    -0x48(%ebp),%edi
 549:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 54d:	eb 07                	jmp    556 <printint+0x76>
 54f:	90                   	nop
    putc(fd, buf[i]);
 550:	0f b6 13             	movzbl (%ebx),%edx
 553:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 556:	83 ec 04             	sub    $0x4,%esp
 559:	88 55 d7             	mov    %dl,-0x29(%ebp)
 55c:	6a 01                	push   $0x1
 55e:	56                   	push   %esi
 55f:	57                   	push   %edi
 560:	e8 de fe ff ff       	call   443 <write>
  while(--i >= 0)
 565:	83 c4 10             	add    $0x10,%esp
 568:	39 de                	cmp    %ebx,%esi
 56a:	75 e4                	jne    550 <printint+0x70>
}
 56c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 56f:	5b                   	pop    %ebx
 570:	5e                   	pop    %esi
 571:	5f                   	pop    %edi
 572:	5d                   	pop    %ebp
 573:	c3                   	ret    
 574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 578:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 57f:	eb 87                	jmp    508 <printint+0x28>
 581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 588:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 58f:	90                   	nop

00000590 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 590:	55                   	push   %ebp
 591:	89 e5                	mov    %esp,%ebp
 593:	57                   	push   %edi
 594:	56                   	push   %esi
 595:	53                   	push   %ebx
 596:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 599:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 59c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 59f:	0f b6 13             	movzbl (%ebx),%edx
 5a2:	84 d2                	test   %dl,%dl
 5a4:	74 6a                	je     610 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 5a6:	8d 45 10             	lea    0x10(%ebp),%eax
 5a9:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 5ac:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 5af:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 5b1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 5b4:	eb 36                	jmp    5ec <printf+0x5c>
 5b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5bd:	8d 76 00             	lea    0x0(%esi),%esi
 5c0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 5c3:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 5c8:	83 f8 25             	cmp    $0x25,%eax
 5cb:	74 15                	je     5e2 <printf+0x52>
  write(fd, &c, 1);
 5cd:	83 ec 04             	sub    $0x4,%esp
 5d0:	88 55 e7             	mov    %dl,-0x19(%ebp)
 5d3:	6a 01                	push   $0x1
 5d5:	57                   	push   %edi
 5d6:	56                   	push   %esi
 5d7:	e8 67 fe ff ff       	call   443 <write>
 5dc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 5df:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 5e2:	0f b6 13             	movzbl (%ebx),%edx
 5e5:	83 c3 01             	add    $0x1,%ebx
 5e8:	84 d2                	test   %dl,%dl
 5ea:	74 24                	je     610 <printf+0x80>
    c = fmt[i] & 0xff;
 5ec:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 5ef:	85 c9                	test   %ecx,%ecx
 5f1:	74 cd                	je     5c0 <printf+0x30>
      }
    } else if(state == '%'){
 5f3:	83 f9 25             	cmp    $0x25,%ecx
 5f6:	75 ea                	jne    5e2 <printf+0x52>
      if(c == 'd'){
 5f8:	83 f8 25             	cmp    $0x25,%eax
 5fb:	0f 84 07 01 00 00    	je     708 <printf+0x178>
 601:	83 e8 63             	sub    $0x63,%eax
 604:	83 f8 15             	cmp    $0x15,%eax
 607:	77 17                	ja     620 <printf+0x90>
 609:	ff 24 85 0c 0a 00 00 	jmp    *0xa0c(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 610:	8d 65 f4             	lea    -0xc(%ebp),%esp
 613:	5b                   	pop    %ebx
 614:	5e                   	pop    %esi
 615:	5f                   	pop    %edi
 616:	5d                   	pop    %ebp
 617:	c3                   	ret    
 618:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 61f:	90                   	nop
  write(fd, &c, 1);
 620:	83 ec 04             	sub    $0x4,%esp
 623:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 626:	6a 01                	push   $0x1
 628:	57                   	push   %edi
 629:	56                   	push   %esi
 62a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 62e:	e8 10 fe ff ff       	call   443 <write>
        putc(fd, c);
 633:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 637:	83 c4 0c             	add    $0xc,%esp
 63a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 63d:	6a 01                	push   $0x1
 63f:	57                   	push   %edi
 640:	56                   	push   %esi
 641:	e8 fd fd ff ff       	call   443 <write>
        putc(fd, c);
 646:	83 c4 10             	add    $0x10,%esp
      state = 0;
 649:	31 c9                	xor    %ecx,%ecx
 64b:	eb 95                	jmp    5e2 <printf+0x52>
 64d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 650:	83 ec 0c             	sub    $0xc,%esp
 653:	b9 10 00 00 00       	mov    $0x10,%ecx
 658:	6a 00                	push   $0x0
 65a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 65d:	8b 10                	mov    (%eax),%edx
 65f:	89 f0                	mov    %esi,%eax
 661:	e8 7a fe ff ff       	call   4e0 <printint>
        ap++;
 666:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 66a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 66d:	31 c9                	xor    %ecx,%ecx
 66f:	e9 6e ff ff ff       	jmp    5e2 <printf+0x52>
 674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 678:	8b 45 d0             	mov    -0x30(%ebp),%eax
 67b:	8b 10                	mov    (%eax),%edx
        ap++;
 67d:	83 c0 04             	add    $0x4,%eax
 680:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 683:	85 d2                	test   %edx,%edx
 685:	0f 84 8d 00 00 00    	je     718 <printf+0x188>
        while(*s != 0){
 68b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 68e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 690:	84 c0                	test   %al,%al
 692:	0f 84 4a ff ff ff    	je     5e2 <printf+0x52>
 698:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 69b:	89 d3                	mov    %edx,%ebx
 69d:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 6a0:	83 ec 04             	sub    $0x4,%esp
          s++;
 6a3:	83 c3 01             	add    $0x1,%ebx
 6a6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6a9:	6a 01                	push   $0x1
 6ab:	57                   	push   %edi
 6ac:	56                   	push   %esi
 6ad:	e8 91 fd ff ff       	call   443 <write>
        while(*s != 0){
 6b2:	0f b6 03             	movzbl (%ebx),%eax
 6b5:	83 c4 10             	add    $0x10,%esp
 6b8:	84 c0                	test   %al,%al
 6ba:	75 e4                	jne    6a0 <printf+0x110>
      state = 0;
 6bc:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 6bf:	31 c9                	xor    %ecx,%ecx
 6c1:	e9 1c ff ff ff       	jmp    5e2 <printf+0x52>
 6c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6cd:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 6d0:	83 ec 0c             	sub    $0xc,%esp
 6d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 6d8:	6a 01                	push   $0x1
 6da:	e9 7b ff ff ff       	jmp    65a <printf+0xca>
 6df:	90                   	nop
        putc(fd, *ap);
 6e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 6e3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 6e6:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 6e8:	6a 01                	push   $0x1
 6ea:	57                   	push   %edi
 6eb:	56                   	push   %esi
        putc(fd, *ap);
 6ec:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6ef:	e8 4f fd ff ff       	call   443 <write>
        ap++;
 6f4:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 6f8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6fb:	31 c9                	xor    %ecx,%ecx
 6fd:	e9 e0 fe ff ff       	jmp    5e2 <printf+0x52>
 702:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 708:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 70b:	83 ec 04             	sub    $0x4,%esp
 70e:	e9 2a ff ff ff       	jmp    63d <printf+0xad>
 713:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 717:	90                   	nop
          s = "(null)";
 718:	ba 02 0a 00 00       	mov    $0xa02,%edx
        while(*s != 0){
 71d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 720:	b8 28 00 00 00       	mov    $0x28,%eax
 725:	89 d3                	mov    %edx,%ebx
 727:	e9 74 ff ff ff       	jmp    6a0 <printf+0x110>
 72c:	66 90                	xchg   %ax,%ax
 72e:	66 90                	xchg   %ax,%ax

00000730 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 730:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 731:	a1 2c 0d 00 00       	mov    0xd2c,%eax
{
 736:	89 e5                	mov    %esp,%ebp
 738:	57                   	push   %edi
 739:	56                   	push   %esi
 73a:	53                   	push   %ebx
 73b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 73e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 748:	89 c2                	mov    %eax,%edx
 74a:	8b 00                	mov    (%eax),%eax
 74c:	39 ca                	cmp    %ecx,%edx
 74e:	73 30                	jae    780 <free+0x50>
 750:	39 c1                	cmp    %eax,%ecx
 752:	72 04                	jb     758 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 754:	39 c2                	cmp    %eax,%edx
 756:	72 f0                	jb     748 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 758:	8b 73 fc             	mov    -0x4(%ebx),%esi
 75b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 75e:	39 f8                	cmp    %edi,%eax
 760:	74 30                	je     792 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 762:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 765:	8b 42 04             	mov    0x4(%edx),%eax
 768:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 76b:	39 f1                	cmp    %esi,%ecx
 76d:	74 3a                	je     7a9 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 76f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 771:	5b                   	pop    %ebx
  freep = p;
 772:	89 15 2c 0d 00 00    	mov    %edx,0xd2c
}
 778:	5e                   	pop    %esi
 779:	5f                   	pop    %edi
 77a:	5d                   	pop    %ebp
 77b:	c3                   	ret    
 77c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 780:	39 c2                	cmp    %eax,%edx
 782:	72 c4                	jb     748 <free+0x18>
 784:	39 c1                	cmp    %eax,%ecx
 786:	73 c0                	jae    748 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 788:	8b 73 fc             	mov    -0x4(%ebx),%esi
 78b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 78e:	39 f8                	cmp    %edi,%eax
 790:	75 d0                	jne    762 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 792:	03 70 04             	add    0x4(%eax),%esi
 795:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 798:	8b 02                	mov    (%edx),%eax
 79a:	8b 00                	mov    (%eax),%eax
 79c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 79f:	8b 42 04             	mov    0x4(%edx),%eax
 7a2:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 7a5:	39 f1                	cmp    %esi,%ecx
 7a7:	75 c6                	jne    76f <free+0x3f>
    p->s.size += bp->s.size;
 7a9:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 7ac:	89 15 2c 0d 00 00    	mov    %edx,0xd2c
    p->s.size += bp->s.size;
 7b2:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 7b5:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 7b8:	89 0a                	mov    %ecx,(%edx)
}
 7ba:	5b                   	pop    %ebx
 7bb:	5e                   	pop    %esi
 7bc:	5f                   	pop    %edi
 7bd:	5d                   	pop    %ebp
 7be:	c3                   	ret    
 7bf:	90                   	nop

000007c0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7c0:	55                   	push   %ebp
 7c1:	89 e5                	mov    %esp,%ebp
 7c3:	57                   	push   %edi
 7c4:	56                   	push   %esi
 7c5:	53                   	push   %ebx
 7c6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 7cc:	8b 3d 2c 0d 00 00    	mov    0xd2c,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7d2:	8d 70 07             	lea    0x7(%eax),%esi
 7d5:	c1 ee 03             	shr    $0x3,%esi
 7d8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 7db:	85 ff                	test   %edi,%edi
 7dd:	0f 84 9d 00 00 00    	je     880 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e3:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 7e5:	8b 4a 04             	mov    0x4(%edx),%ecx
 7e8:	39 f1                	cmp    %esi,%ecx
 7ea:	73 6a                	jae    856 <malloc+0x96>
 7ec:	bb 00 10 00 00       	mov    $0x1000,%ebx
 7f1:	39 de                	cmp    %ebx,%esi
 7f3:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 7f6:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 7fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 800:	eb 17                	jmp    819 <malloc+0x59>
 802:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 808:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 80a:	8b 48 04             	mov    0x4(%eax),%ecx
 80d:	39 f1                	cmp    %esi,%ecx
 80f:	73 4f                	jae    860 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 811:	8b 3d 2c 0d 00 00    	mov    0xd2c,%edi
 817:	89 c2                	mov    %eax,%edx
 819:	39 d7                	cmp    %edx,%edi
 81b:	75 eb                	jne    808 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 81d:	83 ec 0c             	sub    $0xc,%esp
 820:	ff 75 e4             	push   -0x1c(%ebp)
 823:	e8 83 fc ff ff       	call   4ab <sbrk>
  if(p == (char*)-1)
 828:	83 c4 10             	add    $0x10,%esp
 82b:	83 f8 ff             	cmp    $0xffffffff,%eax
 82e:	74 1c                	je     84c <malloc+0x8c>
  hp->s.size = nu;
 830:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 833:	83 ec 0c             	sub    $0xc,%esp
 836:	83 c0 08             	add    $0x8,%eax
 839:	50                   	push   %eax
 83a:	e8 f1 fe ff ff       	call   730 <free>
  return freep;
 83f:	8b 15 2c 0d 00 00    	mov    0xd2c,%edx
      if((p = morecore(nunits)) == 0)
 845:	83 c4 10             	add    $0x10,%esp
 848:	85 d2                	test   %edx,%edx
 84a:	75 bc                	jne    808 <malloc+0x48>
        return 0;
  }
}
 84c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 84f:	31 c0                	xor    %eax,%eax
}
 851:	5b                   	pop    %ebx
 852:	5e                   	pop    %esi
 853:	5f                   	pop    %edi
 854:	5d                   	pop    %ebp
 855:	c3                   	ret    
    if(p->s.size >= nunits){
 856:	89 d0                	mov    %edx,%eax
 858:	89 fa                	mov    %edi,%edx
 85a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 860:	39 ce                	cmp    %ecx,%esi
 862:	74 4c                	je     8b0 <malloc+0xf0>
        p->s.size -= nunits;
 864:	29 f1                	sub    %esi,%ecx
 866:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 869:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 86c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 86f:	89 15 2c 0d 00 00    	mov    %edx,0xd2c
}
 875:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 878:	83 c0 08             	add    $0x8,%eax
}
 87b:	5b                   	pop    %ebx
 87c:	5e                   	pop    %esi
 87d:	5f                   	pop    %edi
 87e:	5d                   	pop    %ebp
 87f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 880:	c7 05 2c 0d 00 00 30 	movl   $0xd30,0xd2c
 887:	0d 00 00 
    base.s.size = 0;
 88a:	bf 30 0d 00 00       	mov    $0xd30,%edi
    base.s.ptr = freep = prevp = &base;
 88f:	c7 05 30 0d 00 00 30 	movl   $0xd30,0xd30
 896:	0d 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 899:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 89b:	c7 05 34 0d 00 00 00 	movl   $0x0,0xd34
 8a2:	00 00 00 
    if(p->s.size >= nunits){
 8a5:	e9 42 ff ff ff       	jmp    7ec <malloc+0x2c>
 8aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 8b0:	8b 08                	mov    (%eax),%ecx
 8b2:	89 0a                	mov    %ecx,(%edx)
 8b4:	eb b9                	jmp    86f <malloc+0xaf>
