From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Sun, 11 Jan 2009 11:25:32 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901111114230.6528@localhost.localdomain>
References: <alpine.LFD.2.00.0901091251380.6528@localhost.localdomain> <20090109213442.GA20051@elte.hu> <1231537320.5726.2.camel@brick> <alpine.LFD.2.00.0901091347170.6528@localhost.localdomain> <20090109231227.GA25070@elte.hu>
 <alpine.LFD.2.00.0901091522250.6528@localhost.localdomain> <20090110010125.GA31031@elte.hu> <20090109174158.096dee70.akpm@linux-foundation.org> <20090110030216.GW26290@one.firstfloor.org> <1231676801.25018.150.camel@macbook.infradead.org>
 <20090111181307.GM26290@one.firstfloor.org>
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
	Sven Dietrich <SDietrich@novell.com>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090111181307.GM26290@one.firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>



On Sun, 11 Jan 2009, Andi Kleen wrote:
> 
> The proposal was to use -fno-inline-functions-called-once (but 
> the resulting numbers were not promising)

Well, the _optimal_ situation would be to not need it, because gcc does a 
good job without it. That implies trying to find a better balance between 
"worth it" and "causes problems". 

Rigth now, it does sound like gcc simply doesn't try to balance AT ALL, or 
balances only when we add some very version-specific random options (ie 
the stack-usage one). And even those options don't actually make much 
sense - yes, they "balance" things, but they don't do it in a sensible 
manner.

For example: stack usage is undeniably a problem (we've hit it over and 
over again), but it's not about "stack must not be larger than X bytes". 

If the call is done unconditionally, then inlining _one_ function will 
grow the static stack usage of the function we inline into, but it will 
_not_ grow the dynamic stack usage one whit - so deciding to not inline 
because of stack usage is pointless.

See? So "stop inlining when you hit a stack limit" IS THE WRONG THING TO 
DO TOO! Because it just means that the compiler continues to do bad 
inlining decisions until it hits some magical limit - but since the 
problem isn't the static stack size of any _single_ function, but the 
combined stack size of a dynamic chain of them, that's totally idiotic. 
You still grew the dynamic stack, and you have no way of knowing by how 
much - the limit on the static one simply has zero bearing what-so-ever on 
the dynamic one.

So no, "limit static stack usage" is not a good option, because it stops 
inlining when it doesn't matter (single unconditional call), and doesn't 
stop inlining when it might (lots of sequential calls, in a deep chain).

The other alternative is to let gcc do what it does, but 

 (a) remove lots of unnecessary 'inline's. And we should likely do this 
     regardless of any "-fno-inline-functions-called-once" issues.

 (b) add lots of 'noinline's to avoid all the cases where gcc screws up so 
     badly that it's either a debugging disaster or an actual correctness 
     issue.

The problem with (b) is that it's a lot of hard thinking, and debugging 
disasters always happen in code that you didn't realize would be a problem 
(because if you had, it simply wouldn't be the debugging issue it is).

			Linus
