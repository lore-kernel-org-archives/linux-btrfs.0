From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y
 impact
Date: Fri, 9 Jan 2009 08:28:14 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901090817470.6528@localhost.localdomain>
References: <20090108141808.GC11629@elte.hu> <1231426014.11687.456.camel@twins> <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain> <1231434515.14304.27.camel@think.oraclecorp.com> <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain>
 <20090108183306.GA22916@elte.hu> <496648C7.5050700@zytor.com> <alpine.LFD.2.00.0901081943150.6528@localhost.localdomain> <20090109130057.GA31845@elte.hu> <49675920.4050205@hp.com> <20090109153508.GA4671@elte.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: jim owens <jowens@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
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
In-Reply-To: <20090109153508.GA4671@elte.hu>
List-ID: <linux-btrfs.vger.kernel.org>



On Fri, 9 Jan 2009, Ingo Molnar wrote:
> 
> Core kernel developers tend to be quite inline-conscious and generally do 
> not believe that making something inline will make it go faster.

Some of us core kernel developers tend to believe that:

 - inlining is supposed to work like macros, and should make the compiler 
   do decisions BASED ON CALL-SITE.

   This is one of the most _common_ reasons for inlining. Making the 
   compiler select static code rather than dynamic code, and using 
   inlining as a nice macro. We can pass in a flag with a constant value, 
   and only the case that matters will be compiled.

It's not about size - or necessarily even performance - at all. It's about 
abstraction, and a way of writing code. 

And the thing is, as long as gcc does what we ask, we can notice when _we_ 
did something wrong. We can say "ok, we should just remove the inline" 
etc. But when gcc then essentially flips a coin, and inlines things we 
don't want to, it dilutes the whole value of inlining - because now gcc 
does things that actually does hurt us.

We get oopses that have a nice symbolic back-trace, and it reports an 
error IN TOTALLY THE WRONG FUNCTION, because gcc "helpfully" inlined 
things to the point that only an expert can realize "oh, the bug was 
actually five hundred lines up, in that other function that was just 
called once, so gcc inlined it even though it is huge".

See? THIS is the problem with gcc heuristics. It's not about quality of 
code, it's about RELIABILITY of code. 

The reason people use C for system programming is because the language is 
a reasonably portable way to get the expected end results WITHOUT the 
compiler making a lot of semantic changes behind your back. 

Inlining is also the wrong thing to do _even_ if it makes code smaller and 
faster if you inline the unlikely case, or inlining causes more live 
variables that cause stack pressure. And we KNOW this happens. Again, I'd 
be much happier if we had a compiler option to just does "do what I _say_, 
dammit", and then we can fix up the mistakes. Because then they are _our_ 
mistakes, not some random compiler version that throws a dice!

			Linus
