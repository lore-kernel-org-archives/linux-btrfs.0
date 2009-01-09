From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Sat, 10 Jan 2009 00:12:27 +0100
Message-ID: <20090109231227.GA25070@elte.hu>
References: <20090108183306.GA22916@elte.hu> <20090108190038.GH496@one.firstfloor.org> <4966AB74.2090104@zytor.com> <20090109133710.GB31845@elte.hu> <alpine.LFD.2.00.0901090759420.6528@localhost.localdomain> <20090109204103.GA17212@elte.hu> <alpine.LFD.2.00.0901091251380.6528@localhost.localdomain> <20090109213442.GA20051@elte.hu> <1231537320.5726.2.camel@brick> <alpine.LFD.2.00.0901091347170.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759766AbZAIXNc@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901091347170.6528@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 9 Jan 2009, Harvey Harrison wrote:
> > 
> > __needs_inline?  That would imply that it's for correctness reasons.
> 
> .. but the point is, we have _thousands_ of inlines, and do you know 
> which is which? We've historically forced them to be inlined, and every 
> time somebody does that "OPTIMIZE_INLINE=y", something simply _breaks_.

Having watched all the inline and anti-inline activites and patches of the 
past decade (and having participated in many of them) my strong impression 
is that any non-automated way is a fundamentally inhuman Don Quijote 
fight.

The inlining numbers me and others posted seem to support that impression.

Today we have in excess of thirty thousand 'inline' keyword uses in the 
kernel, and in excess of one hundred thousand kernel functions. We had a 
decade of hundreds of inline-tuning patches that flipped inline attributes 
on and off, with the goal of doing that job better than the compiler.

Still a sucky compiler who was never faced with this level of inlining 
complexity before (up to a few short months ago when we released the first 
kernel with non-CONFIG_BROKEN-marked CONFIG_OPTIMIZE_INLINING feature in 
it) manages to do a better job at judging inlining than a decade of human 
optimizations managed to do. (If you accept that 1% - 3% - 7.5% code size 
reduction in important areas of the kernel is an improvement.)

That improvement is systematic: it happens regardless whether it's core 
kernel developers who wrote the code, with years of kernel experience - or 
driver developers who came from Windows and might be inexperienced about 
it all and might slap 'inline' on every second random function.

And it's not like the compiler was not allowed to inline important 
functions before: all static functions in .c it can (and do) inline if it 
sees fit. Tens of thousands of them.

If we change 'inline' back to mean 'must inline' again, we have not 
changed the human dynamics of inlines at all and are back on square one. 
'should_inline' or 'may_inline' will be an opt-in hint that will be 
subject to the same kind of misjudgements that resulted in the inlining 
situation to begin with. In .c files it's already possible to do that: by 
not placing an 'inline' keyword at all, just leaving the function 
'static'.

may_inline/inline_hint is a longer, less known and uglier keyword. So all 
the cards are stacked up against this new 'may inline' mechanism, and by 
all likelyhood it will fizzle and never reach any sort of critical mass to 
truly matter. Nor should it - why should humans do this if a silly tool 
can achieve something rather acceptable?

So such a change will in essence amount to the effective removal of 
CONFIG_OPTIMIZE_INLINING. If we want to do that then we should do that 
honestly - and remove it altogether and not pretend to care.

Fedora has CONFIG_OPTIMIZE_INLINING=y enabled today - distros are always 
on the lookout for kernel image reductor features. As of today i'm not 
aware of a single Fedora bugzilla that was caused by that.

The upstream kernel did have bugs due to it - we had the UML breakage for 
example, and an older 3.x gcc threw an internal error on one of the 
(stale) isdn telephony drivers. Was Chris's crash actually caused by gcc's 
inlining decisions? I dont think it was.

Historically we had far more compiler problems with 
CONFIG_CC_OPTIMIZE_SIZE=y - optimizing for size is a subtly complex and 
non-trivial compiler pass.

	Ingo
