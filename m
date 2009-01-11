From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex: implement
 adaptive spinning
Date: Sun, 11 Jan 2009 15:05:53 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901111458290.6528@localhost.localdomain>
References: <20090109231227.GA25070@elte.hu> <alpine.LFD.2.00.0901091522250.6528@localhost.localdomain> <20090110010125.GA31031@elte.hu> <20090109174158.096dee70.akpm@linux-foundation.org> <20090110030216.GW26290@one.firstfloor.org>
 <1231676801.25018.150.camel@macbook.infradead.org> <20090111181307.GM26290@one.firstfloor.org> <alpine.LFD.2.00.0901111114230.6528@localhost.localdomain> <20090111201427.GP26290@one.firstfloor.org> <1231704939.25018.548.camel@macbook.infradead.org>
 <20090111203441.GQ26290@one.firstfloor.org> <alpine.LFD.2.00.0901111248060.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: David Woodhouse <dwmw2@infradead.org>,
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
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901111248060.6528@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>



On Sun, 11 Jan 2009, Linus Torvalds wrote:
> On Sun, 11 Jan 2009, Andi Kleen wrote:
> > 
> > Was -- i think that got fixed in gcc. But again only in newer versions.
> 
> I doubt it. People have said that about a million times, it has never 
> gotten fixed, and I've never seen any actual proof.

In fact, I just double-checked.

Try this:

	struct a {
		unsigned long array[200];
		int a;
	};

	struct b {
		int b;
		unsigned long array[200];
	};

	extern int fn3(int, void *);
	extern int fn4(int, void *);

	static inline __attribute__((always_inline)) int fn1(int flag)
	{
		struct a a;
		return fn3(flag, &a);
	}

	static inline __attribute__((always_inline)) int fn2(int flag)
	{
		struct b b;
		return fn4(flag, &b);
	}

	int fn(int flag)
	{
		if (flag & 1)
			return fn1(flag);
		return fn2(flag);
	}

(yeah, I made sure it would inline with "always_inline" just so that the 
issue wouldn't be hidden by any "avoid stack frames" flags).

Gcc creates a big stack frame that contains _both_ 'a' and 'b', and does 
not merge the allocations together even though they clearly have no 
overlap in usage. Both 'a' and 'b' get 201 long-words (1608 bytes) of 
stack, causing the inlined version to have 3kB+ of stack, even though the 
non-inlined one would never use more than half of it.

So please stop claiming this is fixed. It's not fixed, never has been, and 
quite frankly, probably never will be because the lifetime analysis is 
hard enough (ie once you inline and there is any complex usage, CSE etc 
will quite possibly mix up the lifetimes - the above is clearly not any 
_realistic_ example).

So even if the above trivial case could be fixed, I suspect a more complex 
real-life case would still keep the allocations separate. Because merging 
the allocations and re-using the same stack for both really is pretty 
non-trivial, and the best solution is to simply not inline.

(And yeah, the above is such an extreme case that gcc seems to realize 
that it makes no sense to inline because the stack frame is _so_ big. I 
don't know what the default stack frame limit is, but it's apparently 
smaller than 1.5kB ;)

			Linus
