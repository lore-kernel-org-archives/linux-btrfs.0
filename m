From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y
 impact
Date: Fri, 9 Jan 2009 12:26:16 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901091217530.6528@localhost.localdomain>
References: <496648C7.5050700@zytor.com> <49677CB1.3030701@zytor.com>  <20090109084620.3c711aad@infradead.org>  <20090109172011.GD26290@one.firstfloor.org>  <20090109172801.GC6936@parisc-linux.org>  <20090109174719.GG26290@one.firstfloor.org>
 <20090109173914.GD6936@parisc-linux.org>  <alpine.LFD.2.00.0901090947080.6528@localhost.localdomain>  <84fc9c000901091109t2c2aef2fu596f8807b0962688@mail.gmail.com>  <alpine.LFD.2.00.0901091128170.6528@localhost.localdomain>
 <84fc9c000901091214i16fc74b7q349433a5586d5619@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
	Dirk Hohndel <hohndel@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
	jim owens <jowens@hp.com>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>, jh@suse.cz
To: Richard Guenther <richard.guenther@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <84fc9c000901091214i16fc74b7q349433a5586d5619@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>



On Fri, 9 Jan 2009, Richard Guenther wrote:
> 
> This is a case where the improved IPA-CP (interprocedural constant 
> propagation) of GCC 4.4 may help.  In general GCC cannot say how a call 
> argument may affect optimization if the function was inlined, so the 
> size estimates are done with just looking at the function body, not the 
> arguments (well, for GCC 4.4 this is not completely true, there is now 
> some "heuristics").  With IPA-CP GCC will clone the function for the 
> constant arguments, optimize it and eventually inline it if it is small 
> enough.  At the moment this happens only if all callers call the 
> function with the same constant though (at least I think so).

Ok, that's useless. The whole point is that everybody gives different - 
but still constant - arguments.

> The above is definitely one case where using a macro or forced inlining is
> a better idea than to trust a compiler to figure out that it can optimize the
> function to a size suitable for inlining if called with a constant parameter.

.. and forced inlining is what we default to. But that's when "let's try 
letting gcc optimize this" fails. And macros get really unreadable, really 
quickly.

> > Maybe there was something else going on, and maybe Ingo's tests were off,
> > but this is an example of gcc not inlining WHEN WE TOLD IT TO, and when
> > the function was a single instruction.
> >
> > How can anybody possibly not consider that to be "stupid"?
> 
> Because it's a hard problem, it's not stupid to fail here - you didn't tell the
> compiler the function optimizes!

Well, actually we did. It's that "inline" there. That's how things used to 
work. It's like "no". It means "no". It doesn't mean "yes, I really want 
to s*ck your d*ck, but I'm just screaming no at the top of my lungs 
because I think I should do so".

See?

And you do have to realize that Linux has been using gcc for a _loong_ 
while. You can talk all you want about how "inline" is just a hint, but 
the fact is, it didn't use to be. gcc people _made_ it so, and are having 
a damn hard time admitting that it's causing problems.

> Experience tells us that people do not know better.  Maybe the kernel is
> an exception here

Oh, I can well believe it. 

And I don't even think that kernel people get it right nearly enough, but 
since for the kernel it can even be a _correctness_ issue, at least if we 
get it wrong, everybody sees it.

When _some_ compiler versions get it wrong, it's a disaster.

> But would you still want small functions be inlined even if they are not
> marked inline?

If you can really tell that they are that small, yes. 

> They do - just constant arguments are obviously not used for optimizing
> before inlining.  Otherwise you'd scream bloody murder at us for all the
> increase in compile-time ;)

A large portion of that has gone away now that everybody uses ccache. And 
if you only did it for functions that we _mark_ inline, it wouldn't even 
be true. Because those are the ones that presumably really should be 
inlined.

So no, I don't believe you. You much too easily dismiss the fact that 
we've explicitly marked these functions for inlining, and then you say 
"but we were too stupid".

If you cannot afford to do the real job, then trust the user. Don't guess.

		Linus
