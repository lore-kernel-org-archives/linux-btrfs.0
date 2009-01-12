From: Andi Kleen <andi@firstfloor.org>
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Mon, 12 Jan 2009 01:12:55 +0100
Message-ID: <20090112001255.GR26290@one.firstfloor.org>
References: <20090109174158.096dee70.akpm@linux-foundation.org> <20090110030216.GW26290@one.firstfloor.org> <1231676801.25018.150.camel@macbook.infradead.org> <20090111181307.GM26290@one.firstfloor.org> <alpine.LFD.2.00.0901111114230.6528@localhost.localdomain> <20090111201427.GP26290@one.firstfloor.org> <1231704939.25018.548.camel@macbook.infradead.org> <20090111203441.GQ26290@one.firstfloor.org> <alpine.LFD.2.00.0901111248060.6528@localhost.localdomain> <alpine.LFD.2.00.0901111458290.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
	Harvey Harrison <harvey.harrison@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>, jh@suse.cz
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901111458290.6528@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 11, 2009 at 03:05:53PM -0800, Linus Torvalds wrote:
> 
> 
> On Sun, 11 Jan 2009, Linus Torvalds wrote:
> > On Sun, 11 Jan 2009, Andi Kleen wrote:
> > > 
> > > Was -- i think that got fixed in gcc. But again only in newer versions.
> > 
> > I doubt it. People have said that about a million times, it has never 
> > gotten fixed, and I've never seen any actual proof.
> 
> In fact, I just double-checked.
> Try this:

Hmm, I actually had tested it some time ago with my own program
(supposed to emulate an ioctl)

extern void f5(char *);

static void f3(void)
{
	char y[100];
	f5(y);
}

static void f2(void)
{
	char x[100];
	f5(x);
}

int f(int cmd)
{
	switch (cmd) { 
	case 1: f3(); break;
	case 2: f2(); break;
	}
	return 1;
}

and with gcc 4.3.1 I get:

.globl f
	.type	f, @function
f:
.LFB4:
	subq	$120, %rsp			<---- not 200 bytes, stack gets reused; dunno where the 20 comes from
.LCFI0:
	cmpl	$1, %edi
	je	.L4
	cmpl	$2, %edi
	je	.L4
	movl	$1, %eax
	addq	$120, %rsp
	ret
	.p2align 4,,10
	.p2align 3
.L4:
	movq	%rsp, %rdi
	call	f5
	movl	$1, %eax
	addq	$120, %rsp
	ret
.LFE4:

so at least least for this case it works. Your case also doesn't work for me.
So it looks like gcc didn't like something you did in your test program.
Could be a pointer aliasing problem of some sort.

But yes it doesn't work as well as we hoped.

-Andi
