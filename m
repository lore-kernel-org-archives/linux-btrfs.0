From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Fri, 9 Jan 2009 17:41:58 -0800
Message-ID: <20090109174158.096dee70.akpm@linux-foundation.org>
References: <4966AB74.2090104@zytor.com>
	<20090109133710.GB31845@elte.hu>
	<alpine.LFD.2.00.0901090759420.6528@localhost.localdomain>
	<20090109204103.GA17212@elte.hu>
	<alpine.LFD.2.00.0901091251380.6528@localhost.localdomain>
	<20090109213442.GA20051@elte.hu>
	<1231537320.5726.2.camel@brick>
	<alpine.LFD.2.00.0901091347170.6528@localhost.localdomain>
	<20090109231227.GA25070@elte.hu>
	<alpine.LFD.2.00.0901091522250.6528@localhost.localdomain>
	<20090110010125.GA31031@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Harvey Harrison <harvey.harrison@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
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
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090110010125.GA31031@elte.hu>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 10 Jan 2009 02:01:25 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Sat, 10 Jan 2009, Ingo Molnar wrote:
> > > 
> > > may_inline/inline_hint is a longer, less known and uglier keyword.
> > 
> > Hey, your choice, should you decide to accept it, is to just get rid of 
> > them entirely.
> > 
> > You claim that we're back to square one, but that's simply the way 
> > things are. Either "inline" means something, or it doesn't. You argue 
> > for it meaning nothing. I argue for it meaning something.
> > 
> > If you want to argue for it meaning nothing, then REMOVE it, instead of 
> > breaking it.
> > 
> > It really is that simple. Remove the inlines you think are wrong. 
> > Instead of trying to change the meaning of them.
> 
> Well, it's not totally meaningless. To begin with, defining 'inline' to 
> mean 'always inline' is a Linux kernel definition. So we already changed 
> the behavior - in the hope of getting it right most of the time and in the 
> hope of thus improving the kernel.
> 
> And now it appears that in our quest of improving the kernel we can 
> further tweak that (already non-standard) meaning to a weak "inline if the 
> compiler agrees too" hint. That gives us an even more compact kernel. It 
> also moves the meaning of 'inline' closer to what the typical programmer 
> expects it to be - for better or worse.
> 
> We could remove them completely, but there are a couple of practical 
> problems with that:
> 
>  - In this cycle alone, in the past ~2 weeks we added another 1300 inlines
>    to the kernel.

Who "reviewed" all that?

> Do we really want periodic postings of:
> 
>       [PATCH 0/135] inline removal cleanups
> 
>    ... in the next 10 years? We have about 20% of all functions in the 
>    kernel marked with 'inline'. It is a _very_ strong habit. Is it worth 
>    fighting against it?

A side-effect of the inline fetish is that a lot of it goes into header
files, thus requiring that those header files #include lots of other
headers, thus leading to, well, the current mess.
