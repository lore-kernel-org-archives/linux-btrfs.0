From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Sat, 10 Jan 2009 02:01:25 +0100
Message-ID: <20090110010125.GA31031@elte.hu>
References: <4966AB74.2090104@zytor.com> <20090109133710.GB31845@elte.hu> <alpine.LFD.2.00.0901090759420.6528@localhost.localdomain> <20090109204103.GA17212@elte.hu> <alpine.LFD.2.00.0901091251380.6528@localhost.localdomain> <20090109213442.GA20051@elte.hu> <1231537320.5726.2.camel@brick> <alpine.LFD.2.00.0901091347170.6528@localhost.localdomain> <20090109231227.GA25070@elte.hu> <alpine.LFD.2.00.0901091522250.6528@localhost.localdomain>
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
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901091522250.6528@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, 10 Jan 2009, Ingo Molnar wrote:
> > 
> > may_inline/inline_hint is a longer, less known and uglier keyword.
> 
> Hey, your choice, should you decide to accept it, is to just get rid of 
> them entirely.
> 
> You claim that we're back to square one, but that's simply the way 
> things are. Either "inline" means something, or it doesn't. You argue 
> for it meaning nothing. I argue for it meaning something.
> 
> If you want to argue for it meaning nothing, then REMOVE it, instead of 
> breaking it.
> 
> It really is that simple. Remove the inlines you think are wrong. 
> Instead of trying to change the meaning of them.

Well, it's not totally meaningless. To begin with, defining 'inline' to 
mean 'always inline' is a Linux kernel definition. So we already changed 
the behavior - in the hope of getting it right most of the time and in the 
hope of thus improving the kernel.

And now it appears that in our quest of improving the kernel we can 
further tweak that (already non-standard) meaning to a weak "inline if the 
compiler agrees too" hint. That gives us an even more compact kernel. It 
also moves the meaning of 'inline' closer to what the typical programmer 
expects it to be - for better or worse.

We could remove them completely, but there are a couple of practical 
problems with that:

 - In this cycle alone, in the past ~2 weeks we added another 1300 inlines
   to the kernel. Do we really want periodic postings of:

      [PATCH 0/135] inline removal cleanups

   ... in the next 10 years? We have about 20% of all functions in the 
   kernel marked with 'inline'. It is a _very_ strong habit. Is it worth 
   fighting against it?

 - Headers could probably go back to 'extern inline' again. At not small 
   expense - we just finished moving to 'static inline'. We'd need to 
   guarantee a library instantiation for every header include file - this 
   is an additional mechanism with additional introduction complexities 
   and an ongoing maintenance cost.

 - 'static inline' functions in .c files that are not used cause no build 
   warnings - while if we change them to 'static', we get a 'defined but
   not used' warning. Hundreds of new warnings in the allyesconfig builds.

I know that because i just have removed all variants of 'inline' from all 
.c files of the kernel, it's a 3.5MB patch:

   3263 files changed, 12409 insertions(+), 12409 deletions(-)

x86 defconfig comparisons:

      text    filename
   6875817    vmlinux.always-inline                       (  0.000% )
   6838290    vmlinux.always-inline+remove-c-inlines      ( -0.548% )
   6794474    vmlinux.optimize-inlining                   ( -1.197% )

So the kernel's size improved by half a percent. Should i submit it?

	Ingo
