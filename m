From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Fri, 9 Jan 2009 17:34:09 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901091731130.6528@localhost.localdomain>
References: <alpine.LFD.2.00.0901090759420.6528@localhost.localdomain> <20090109204103.GA17212@elte.hu> <alpine.LFD.2.00.0901091251380.6528@localhost.localdomain> <20090109213442.GA20051@elte.hu> <1231537320.5726.2.camel@brick>
 <alpine.LFD.2.00.0901091347170.6528@localhost.localdomain> <20090109231227.GA25070@elte.hu> <alpine.LFD.2.00.0901091522250.6528@localhost.localdomain> <20090110010125.GA31031@elte.hu> <alpine.LFD.2.00.0901091705410.6528@localhost.localdomain>
 <20090110012050.GA1083@elte.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090110012050.GA1083@elte.hu>
List-ID: <linux-btrfs.vger.kernel.org>



On Sat, 10 Jan 2009, Ingo Molnar wrote:

> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Sat, 10 Jan 2009, Ingo Molnar wrote:
> > > 
> > > Well, it's not totally meaningless. To begin with, defining 'inline' to 
> > > mean 'always inline' is a Linux kernel definition. So we already changed 
> > > the behavior - in the hope of getting it right most of the time and in the 
> > > hope of thus improving the kernel.
> > 
> > Umm. No we didn't. We've never changed it. It was "always inline" back in 
> 
> s/changed the behavior/overrode the behavior

The point is, as far as the kenrel has been concerned, "inline" has always 
meant the same thing. Not just for the last few weeks, but for the last 18 
_years_. It's always meant "always inline".

> But i'd definitely argue that the Linux kernel definition of 'inline' was 
> always more consistent than GCC's. That was rather easy as well: it doesnt 
> get any more clear-cut than 'always inline'.

Exactly. And I argue that we shouldn't change it.

If we have too many "inline"s, and if gcc inlines for us _anyway_, then 
the answer is not to change the meaning of "inline", but simply say "ok, 
we have too many inlines. Let's remove the ones we don't care about".

> I think it is axiomatic that improving the kernel means changing it - 
> sometimes that means changing deep details. (And if you see us ignoring 
> complaints, let us know, it must not happen.)

And I'm agreeing with you.

What I'm _not_ agreeing with is how you want to change the semantics of 
something we've had for 18 years.

YOU are the one who want to make "inline" mean "maybe". I'm against it. 
I'm against it because it makes no sense. It's not what we've ever done.

		Linus
