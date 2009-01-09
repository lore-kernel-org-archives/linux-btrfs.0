From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y
	impact
Date: Fri, 9 Jan 2009 16:25:37 +0100
Message-ID: <20090109152537.GA4317@elte.hu>
References: <1231408718.11687.400.camel@twins> <20090108141808.GC11629@elte.hu> <1231426014.11687.456.camel@twins> <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain> <1231434515.14304.27.camel@think.oraclecorp.com> <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain> <20090108183306.GA22916@elte.hu> <496648C7.5050700@zytor.com> <alpine.LFD.2.00.0901081943150.6528@localhost.localdomain> <20090109130057.GA31845@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090109130057.GA31845@elte.hu>
List-ID: <linux-btrfs.vger.kernel.org>


* Ingo Molnar <mingo@elte.hu> wrote:

> > I suspect gcc has some pre-inlining heuristics that don't take 
> > constant folding and simplifiation into account - if you look at just 
> > the raw tree of the function without taking the optimization into 
> > account, it will look big.
> 
> Yeah. In my tests GCC 4.3.2 does properly inline that particular asm.

here is how that function ended up looking like here (with Peter's v7, 
which should be close to what Chris tried, looking at his crash dump):

ffffffff81491347 <__mutex_lock_common>:
ffffffff81491347:	55                   	push   %rbp
ffffffff81491348:	48 89 e5             	mov    %rsp,%rbp
ffffffff8149134b:	41 57                	push   %r15
ffffffff8149134d:	4c 8d 7f 08          	lea    0x8(%rdi),%r15
ffffffff81491351:	41 56                	push   %r14
ffffffff81491353:	49 89 f6             	mov    %rsi,%r14
ffffffff81491356:	41 55                	push   %r13
ffffffff81491358:	41 54                	push   %r12
ffffffff8149135a:	4c 8d 67 18          	lea    0x18(%rdi),%r12
ffffffff8149135e:	53                   	push   %rbx
ffffffff8149135f:	48 89 fb             	mov    %rdi,%rbx
ffffffff81491362:	48 83 ec 38          	sub    $0x38,%rsp
ffffffff81491366:	65 4c 8b 2c 25 00 00 	mov    %gs:0x0,%r13
ffffffff8149136d:	00 00 
ffffffff8149136f:	b8 01 00 00 00       	mov    $0x1,%eax
ffffffff81491374:	31 d2                	xor    %edx,%edx
ffffffff81491376:	f0 0f b1 13          	lock cmpxchg %edx,(%rbx)
ffffffff8149137a:	83 f8 01             	cmp    $0x1,%eax
ffffffff8149137d:	75 18                	jne    ffffffff81491397 <__mutex_lock_common+0x50>
ffffffff8149137f:	65 48 8b 04 25 10 00 	mov    %gs:0x10,%rax
ffffffff81491386:	00 00 
ffffffff81491388:	48 2d d8 1f 00 00    	sub    $0x1fd8,%rax
ffffffff8149138e:	48 89 43 18          	mov    %rax,0x18(%rbx)
ffffffff81491392:	e9 dd 00 00 00       	jmpq   ffffffff81491474 <__mutex_lock_common+0x12d>
ffffffff81491397:	85 c0                	test   %eax,%eax
ffffffff81491399:	79 06                	jns    ffffffff814913a1 <__mutex_lock_common+0x5a>
ffffffff8149139b:	4c 39 7b 08          	cmp    %r15,0x8(%rbx)
ffffffff8149139f:	75 19                	jne    ffffffff814913ba <__mutex_lock_common+0x73>
ffffffff814913a1:	49 8b 34 24          	mov    (%r12),%rsi
ffffffff814913a5:	48 85 f6             	test   %rsi,%rsi
ffffffff814913a8:	74 0c                	je     ffffffff814913b6 <__mutex_lock_common+0x6f>
ffffffff814913aa:	48 89 df             	mov    %rbx,%rdi
ffffffff814913ad:	e8 6c dd b9 ff       	callq  ffffffff8102f11e <spin_on_owner>
ffffffff814913b2:	85 c0                	test   %eax,%eax
ffffffff814913b4:	74 04                	je     ffffffff814913ba <__mutex_lock_common+0x73>
ffffffff814913b6:	f3 90                	pause  
ffffffff814913b8:	eb b5                	jmp    ffffffff8149136f <__mutex_lock_common+0x28>
ffffffff814913ba:	4c 8d 63 04          	lea    0x4(%rbx),%r12
ffffffff814913be:	4c 89 e7             	mov    %r12,%rdi
ffffffff814913c1:	e8 d2 0f 00 00       	callq  ffffffff81492398 <_spin_lock>
ffffffff814913c6:	48 8b 53 10          	mov    0x10(%rbx),%rdx
ffffffff814913ca:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
ffffffff814913ce:	4c 89 7d b0          	mov    %r15,-0x50(%rbp)
ffffffff814913d2:	48 89 43 10          	mov    %rax,0x10(%rbx)
ffffffff814913d6:	48 89 02             	mov    %rax,(%rdx)
ffffffff814913d9:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
ffffffff814913dd:	48 83 ca ff          	or     $0xffffffffffffffff,%rdx
ffffffff814913e1:	4c 89 6d c0          	mov    %r13,-0x40(%rbp)
ffffffff814913e5:	48 89 d0             	mov    %rdx,%rax
ffffffff814913e8:	87 03                	xchg   %eax,(%rbx)
ffffffff814913ea:	ff c8                	dec    %eax
ffffffff814913ec:	74 55                	je     ffffffff81491443 <__mutex_lock_common+0xfc>
ffffffff814913ee:	44 88 f0             	mov    %r14b,%al
ffffffff814913f1:	44 89 f2             	mov    %r14d,%edx
ffffffff814913f4:	83 e0 81             	and    $0xffffffffffffff81,%eax
ffffffff814913f7:	83 e2 01             	and    $0x1,%edx
ffffffff814913fa:	88 45 af             	mov    %al,-0x51(%rbp)
ffffffff814913fd:	89 55 a8             	mov    %edx,-0x58(%rbp)
ffffffff81491400:	48 83 c8 ff          	or     $0xffffffffffffffff,%rax
ffffffff81491404:	87 03                	xchg   %eax,(%rbx)
ffffffff81491406:	ff c8                	dec    %eax
ffffffff81491408:	74 39                	je     ffffffff81491443 <__mutex_lock_common+0xfc>
ffffffff8149140a:	80 7d af 00          	cmpb   $0x0,-0x51(%rbp)
ffffffff8149140e:	74 1c                	je     ffffffff8149142c <__mutex_lock_common+0xe5>
ffffffff81491410:	49 8b 45 08          	mov    0x8(%r13),%rax
ffffffff81491414:	f6 40 10 04          	testb  $0x4,0x10(%rax)
ffffffff81491418:	74 12                	je     ffffffff8149142c <__mutex_lock_common+0xe5>
ffffffff8149141a:	83 7d a8 00          	cmpl   $0x0,-0x58(%rbp)
ffffffff8149141e:	75 65                	jne    ffffffff81491485 <__mutex_lock_common+0x13e>
ffffffff81491420:	4c 89 ef             	mov    %r13,%rdi
ffffffff81491423:	e8 e1 2e bb ff       	callq  ffffffff81044309 <__fatal_signal_pending>
ffffffff81491428:	85 c0                	test   %eax,%eax
ffffffff8149142a:	75 59                	jne    ffffffff81491485 <__mutex_lock_common+0x13e>
ffffffff8149142c:	4d 89 75 00          	mov    %r14,0x0(%r13)
ffffffff81491430:	41 fe 04 24          	incb   (%r12)
ffffffff81491434:	e8 e9 ef ff ff       	callq  ffffffff81490422 <schedule>
ffffffff81491439:	4c 89 e7             	mov    %r12,%rdi
ffffffff8149143c:	e8 57 0f 00 00       	callq  ffffffff81492398 <_spin_lock>
ffffffff81491441:	eb bd                	jmp    ffffffff81491400 <__mutex_lock_common+0xb9>
ffffffff81491443:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffffffff81491447:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
ffffffff8149144b:	48 89 10             	mov    %rdx,(%rax)
ffffffff8149144e:	48 89 42 08          	mov    %rax,0x8(%rdx)
ffffffff81491452:	65 48 8b 04 25 10 00 	mov    %gs:0x10,%rax
ffffffff81491459:	00 00 
ffffffff8149145b:	48 2d d8 1f 00 00    	sub    $0x1fd8,%rax
ffffffff81491461:	4c 39 7b 08          	cmp    %r15,0x8(%rbx)
ffffffff81491465:	48 89 43 18          	mov    %rax,0x18(%rbx)
ffffffff81491469:	75 06                	jne    ffffffff81491471 <__mutex_lock_common+0x12a>
ffffffff8149146b:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
ffffffff81491471:	fe 43 04             	incb   0x4(%rbx)
ffffffff81491474:	31 c0                	xor    %eax,%eax
ffffffff81491476:	48 83 c4 38          	add    $0x38,%rsp
ffffffff8149147a:	5b                   	pop    %rbx
ffffffff8149147b:	41 5c                	pop    %r12
ffffffff8149147d:	41 5d                	pop    %r13
ffffffff8149147f:	41 5e                	pop    %r14
ffffffff81491481:	41 5f                	pop    %r15
ffffffff81491483:	c9                   	leaveq 
ffffffff81491484:	c3                   	retq   
ffffffff81491485:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
ffffffff81491489:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffffffff8149148d:	48 89 42 08          	mov    %rax,0x8(%rdx)
ffffffff81491491:	48 89 10             	mov    %rdx,(%rax)
ffffffff81491494:	fe 43 04             	incb   0x4(%rbx)
ffffffff81491497:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
ffffffff8149149c:	eb d8                	jmp    ffffffff81491476 <__mutex_lock_common+0x12f>

the "lock cmpxchg" ended up being inlined properly at ffffffff81491376, 
and the whole assembly sequence looks pretty compact to me.

That does not let GCC off the hook though, and i'd be the last one to 
defend it when it messes up.

	Ingo
