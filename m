From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -v5][RFC]: mutex: implement adaptive spinning
Date: Wed, 7 Jan 2009 22:57:59 +0100
Message-ID: <20090107215759.GA17917@elte.hu>
References: <1231329783.11687.287.camel@twins> <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain> <1231347442.11687.344.camel@twins> <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain> <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com> <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain> <20090107210923.GV2002@parisc-linux.org> <alpine.LFD.2.00.0901071314490.3057@localhost.localdomain> <20090107213222.GE4597@elte.hu> <20090107134715.9c5e139e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: torvalds@linux-foundation.org, matthew@wil.cx, rostedt@goodmis.org,
	peterz@infradead.org, paulmck@linux.vnet.ibm.com,
	ghaskins@novell.com, andi@firstfloor.org, chris.mason@oracle.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, tglx@linutronix.de, npiggin@suse.de,
	pmorreale@novell.com, SDietrich@novell.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090107134715.9c5e139e.akpm@linux-foundation.org>
List-ID: <linux-btrfs.vger.kernel.org>


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 7 Jan 2009 22:32:22 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > We could do the whole "oldfs = get_fs(); set_fs(KERNEL_DS); .. 
> > > set_fs(oldfs);" crud, but it would probably be better to just add an 
> > > architected accessor. Especially since it's going to generally just be a
> > > 
> > > 	#define get_kernel_careful(val,p) __get_user(val,p)
> > > 
> > > for most architectures.
> > > 
> > > We've needed that before (and yes, we've simply mis-used __get_user() on 
> > > x86 before rather than add it).
> > 
> > for the oldfs stuff we already have probe_kernel_read(). OTOH, that 
> > involves pagefault_disable() which is an atomic op
> 
> tisn't.  pagefault_disable() is just preempt_count()+=1;barrier() ?

okay. Not an atomic (which is plenty fast on Nehalem with 20 cycles 
anyway), but probe_kernel_read() is expensive nevertheless:

ffffffff8027c092 <probe_kernel_read>:
ffffffff8027c092:	65 48 8b 04 25 10 00 	mov    %gs:0x10,%rax
ffffffff8027c099:	00 00 
ffffffff8027c09b:	53                   	push   %rbx
ffffffff8027c09c:	48 8b 98 48 e0 ff ff 	mov    -0x1fb8(%rax),%rbx
ffffffff8027c0a3:	48 c7 80 48 e0 ff ff 	movq   $0xffffffffffffffff,-0x1fb8(%rax)
ffffffff8027c0aa:	ff ff ff ff 
ffffffff8027c0ae:	65 48 8b 04 25 10 00 	mov    %gs:0x10,%rax
ffffffff8027c0b5:	00 00 
ffffffff8027c0b7:	ff 80 44 e0 ff ff    	incl   -0x1fbc(%rax)
ffffffff8027c0bd:	e8 0e dd 0d 00       	callq  ffffffff80359dd0 <__copy_from_user_inatomic>
ffffffff8027c0c2:	65 48 8b 14 25 10 00 	mov    %gs:0x10,%rdx
ffffffff8027c0c9:	00 00 
ffffffff8027c0cb:	ff 8a 44 e0 ff ff    	decl   -0x1fbc(%rdx)
ffffffff8027c0d1:	65 48 8b 14 25 10 00 	mov    %gs:0x10,%rdx
ffffffff8027c0d8:	00 00 
ffffffff8027c0da:	48 83 f8 01          	cmp    $0x1,%rax
ffffffff8027c0de:	48 89 9a 48 e0 ff ff 	mov    %rbx,-0x1fb8(%rdx)
ffffffff8027c0e5:	48 19 c0             	sbb    %rax,%rax
ffffffff8027c0e8:	48 f7 d0             	not    %rax
ffffffff8027c0eb:	48 83 e0 f2          	and    $0xfffffffffffffff2,%rax
ffffffff8027c0ef:	5b                   	pop    %rbx
ffffffff8027c0f0:	c3                   	retq   
ffffffff8027c0f1:	90                   	nop    

where __copy_user_inatomic() goes into the full __copy_generic_unrolled(). 
Not pretty.

> Am suspecting that you guys might be over-optimising this 
> contended-path-were-going-to-spin-anyway code?

not sure. Especially for 'good' locking usage - where there are shortly 
held locks and the spin times are short, the average time to get _out_ of 
the spinning section is a kind of secondary fastpath as well.

	Ingo
