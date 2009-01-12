From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex: implement
 adaptive spinning
Date: Mon, 12 Jan 2009 11:02:17 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901121034170.6528@localhost.localdomain>
References: <1231676801.25018.150.camel@macbook.infradead.org> <20090111181307.GM26290@one.firstfloor.org> <alpine.LFD.2.00.0901111114230.6528@localhost.localdomain> <20090111201427.GP26290@one.firstfloor.org> <1231704939.25018.548.camel@macbook.infradead.org>
 <20090111203441.GQ26290@one.firstfloor.org> <alpine.LFD.2.00.0901111248060.6528@localhost.localdomain> <alpine.LFD.2.00.0901111458290.6528@localhost.localdomain> <20090112001255.GR26290@one.firstfloor.org> <alpine.LFD.2.00.0901111619400.6528@localhost.localdomain>
 <20090112005228.GS26290@one.firstfloor.org> <496B86B5.3090707@t-online.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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
To: Bernd Schmidt <bernds_cb1@t-online.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <496B86B5.3090707@t-online.de>
List-ID: <linux-btrfs.vger.kernel.org>



On Mon, 12 Jan 2009, Bernd Schmidt wrote:
> 
> Something at the back of my mind said "aliasing".
> 
> $ gcc linus.c -O2 -S ; grep subl linus.s
>         subl    $1624, %esp
> $ gcc linus.c -O2 -S -fno-strict-aliasing; grep subl linus.s
>         subl    $824, %esp
> 
> That's with 4.3.2.

Interesting. 

Nonsensical, but interesting.

Since they have no overlap in lifetime, confusing this with aliasing is 
really really broken (if the functions _hadn't_ been inlined, you'd have 
gotten the same address for the two variables anyway! So anybody who 
thinks that they need different addresses because they are different types 
is really really fundmantally confused!).

But your numbers are unambiguous, and I can see the effect of that 
compiler flag myself.

The good news is that the kernel obviously already uses 
-fno-strict-aliasing for other reasonds, so we should see this effect 
already, _despite_ it making no sense. And the stack usage still causes 
problems.

Oh, and I see why. This test-case shows it clearly.

Note how the max stack usage _should_ be "struct b" + "struct c". Note how 
it isn't (it's "struct a" + "struct b/c").

So what seems to be going on is that gcc is able to do some per-slot 
sharing, but if you have one function with a single large entity, and 
another with a couple of different ones, gcc can't do any smart 
allocation.

Put another way: gcc doesn't create a "union of the set of different stack 
usages" (which would be optimal given a single frame, and generate the 
stack layout of just the maximum possible size), it creates a "set of 
unions of different stack usages" (which can be optimal in the trivial 
cases, but not nearly optimal in practical cases).

That explains the ioctl behavior - the structure use is usually pretty 
complicated (ie it's almost never about just _one_ large stack slot, but 
the ioctl cases tend to do random stuff with multiple slots).

So it doesn't add up to some horrible maximum of all sizes, but it also 
doesn't end up coalescing stack usage very well.

		Linus
---
struct a {
	int a;
	unsigned long array[200];
};

struct b {
	int b;
	unsigned long array[100];
};

struct c {
	int c;
	unsigned long array[100];
};

extern int fn3(int, void *);
extern int fn4(int, void *);

static inline __attribute__ ((always_inline))
int fn1(int flag)
{
	struct a a;
	return fn3(flag, &a);
}

static inline __attribute__ ((always_inline))
int fn2(int flag)
{
	struct b b;
	struct c c;	
	return fn4(flag, &b) + fn4(flag, &c);
}

int fn(int flag)
{
	fn1(flag);
	if (flag & 1)
		return 0;
	return fn2(flag);
}
