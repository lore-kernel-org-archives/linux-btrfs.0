From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Sat, 10 Jan 2009 02:20:50 +0100
Message-ID: <20090110012050.GA1083@elte.hu>
References: <alpine.LFD.2.00.0901090759420.6528@localhost.localdomain> <20090109204103.GA17212@elte.hu> <alpine.LFD.2.00.0901091251380.6528@localhost.localdomain> <20090109213442.GA20051@elte.hu> <1231537320.5726.2.camel@brick> <alpine.LFD.2.00.0901091347170.6528@localhost.localdomain> <20090109231227.GA25070@elte.hu> <alpine.LFD.2.00.0901091522250.6528@localhost.localdomain> <20090110010125.GA31031@elte.hu> <alpine.LFD.2.00.0901091705410.6528@localhost.localdomain>
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
In-Reply-To: <alpine.LFD.2.00.0901091705410.6528@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, 10 Jan 2009, Ingo Molnar wrote:
> > 
> > Well, it's not totally meaningless. To begin with, defining 'inline' to 
> > mean 'always inline' is a Linux kernel definition. So we already changed 
> > the behavior - in the hope of getting it right most of the time and in the 
> > hope of thus improving the kernel.
> 
> Umm. No we didn't. We've never changed it. It was "always inline" back in 

s/changed the behavior/overrode the behavior

> the old days, and then we had to keep it "always inline", which is why 
> we override the default gcc meaning with the preprocessor.
> 
> Now, OPTIMIZE_INLINING _tries_ to change the semantics, and people are 
> complaining..

But i'd definitely argue that the Linux kernel definition of 'inline' was 
always more consistent than GCC's. That was rather easy as well: it doesnt 
get any more clear-cut than 'always inline'.

Nevertheless the question remains: is 3% on allyesconfig and 1% on 
defconfig (7.5% in kernel/built-in.o) worth changing the kernel definition 
for?

I think it is axiomatic that improving the kernel means changing it - 
sometimes that means changing deep details. (And if you see us ignoring 
complaints, let us know, it must not happen.)

So the question isnt whether to change, the question is: does the kernel 
get 'better' after that change - and could the same be achieved 
realistically via other means?

If you accept us turning all 30,000 inlines in the kernel upside down, we 
might be able to get the same end result differently. You can definitely 
be sure if people complained about this ~5 lines feature they will 
complain about a tens of thousand of lines patch (and the followup changed 
regime) ten or hundred times more fiercely.

And just in case it was not clear, i'm not a GCC apologist - to the 
contrary. I dont really care which tool makes the kernel better, and i 
wont stop looking at a quantified possibility to improve the kernel just 
because it happens to be GCC that offers a solution.

	Ingo
