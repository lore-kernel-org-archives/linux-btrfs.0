From: "Richard Guenther" <richard.guenther@gmail.com>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y impact
Date: Fri, 9 Jan 2009 21:14:58 +0100
Message-ID: <84fc9c000901091214i16fc74b7q349433a5586d5619@mail.gmail.com>
References: <496648C7.5050700@zytor.com> <49677CB1.3030701@zytor.com>
	 <20090109084620.3c711aad@infradead.org>
	 <20090109172011.GD26290@one.firstfloor.org>
	 <20090109172801.GC6936@parisc-linux.org>
	 <20090109174719.GG26290@one.firstfloor.org>
	 <20090109173914.GD6936@parisc-linux.org>
	 <alpine.LFD.2.00.0901090947080.6528@localhost.localdomain>
	 <84fc9c000901091109t2c2aef2fu596f8807b0962688@mail.gmail.com>
	 <alpine.LFD.2.00.0901091128170.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Matthew Wilcox" <matthew@wil.cx>,
	"Andi Kleen" <andi@firstfloor.org>,
	"Dirk Hohndel" <hohndel@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
	"jim owens" <jowens@hp.com>,
	"Chris Mason" <chris.mason@oracle.com>,
	"Peter Zijlstra" <peterz@infradead.org>,
	"Steven Rostedt" <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
	"Gregory Haskins" <ghaskins@novell.com>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	"Thomas Gleixner" <tglx@linutronix.de>,
	"Nick Piggin" <npiggin@suse.de>,
	"Peter Morreale" <pmorreale@novell.com>,
	"Sven Dietrich" <SDietrich@novell.com>, jh@suse.cz
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901091128170.6528@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 9, 2009 at 8:44 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Fri, 9 Jan 2009, Richard Guenther wrote:
>>
>> -fno-inline-functions-called-once disables the heuristic that always
>> inlines (static!) functions that are called once.  Other heuristics
>> still apply, like inlining the static function if it is small.
>> Everything else would be totally stupid - which seems to be the "default
>> mode" you think GCC developers are in.
>
> Well, I don't know about you, but the "don't inline a single instruction"
> sounds a bit stupid to me. And yes, that's exactly what triggered this
> whole thing.
>
> We have two examples of gcc doing that, one of which was even a modern
> version of gcc, where we had sone absolutely _everything_ on a source
> level to make sure that gcc could not possibly screw up. Yet it did:
>
>        static inline int constant_test_bit(int nr, const volatile unsigned long *addr)
>        {
>                return ((1UL << (nr % BITS_PER_LONG)) &
>                        (((unsigned long *)addr)[nr / BITS_PER_LONG])) != 0;
>        }
>
>        #define test_bit(nr, addr)                      \
>                (__builtin_constant_p((nr))             \
>                 ? constant_test_bit((nr), (addr))      \
>                 : variable_test_bit((nr), (addr)))
>
> in this case, Ingo said that changing that _single_ inline to forcing
> inlining made a difference.
>
> That's CRAZY. The thing isn't even called unless "nr" is constant, so
> absolutely _everything_ optimizes away, and that whole function was
> designed to give us a single instruction:
>
>        testl $constant,constant_offset(addr)
>
> and nothing else.

This is a case where the improved IPA-CP (interprocedural constant propagation)
of GCC 4.4 may help.  In general GCC cannot say how a call argument may
affect optimization if the function was inlined, so the size estimates are done
with just looking at the function body, not the arguments (well, for
GCC 4.4 this
is not completely true, there is now some "heuristics").  With IPA-CP GCC will
clone the function for the constant arguments, optimize it and eventually inline
it if it is small enough.  At the moment this happens only if all
callers call the
function with the same constant though (at least I think so).

The above is definitely one case where using a macro or forced inlining is
a better idea than to trust a compiler to figure out that it can optimize the
function to a size suitable for inlining if called with a constant parameter.

> Maybe there was something else going on, and maybe Ingo's tests were off,
> but this is an example of gcc not inlining WHEN WE TOLD IT TO, and when
> the function was a single instruction.
>
> How can anybody possibly not consider that to be "stupid"?

Because it's a hard problem, it's not stupid to fail here - you didn't tell the
compiler the function optimizes!

> The other case (with a single "cmpxchg" inline asm instruction) was at
> least _slightly_ more understandable, in that (a) Ingo claims modern gcc's
> did inline it and (b) the original function actually has a "switch()"
> statement that depends on the argument that is constant, so a stupid
> inliner might believe that it's a big function. But again, we _told_ the
> compiler to inline the damn thing, because we knew better. But gcc didn't.

Experience tells us that people do not know better.  Maybe the kernel is
an exception here, but generally trusting "inline" up to an absolute is
a bad idea (we stretch heuristics if you specify "inline" though).  We can,
for the kernels purpose and maybe other clever developers, invent a
-fobey-inline mode, only inline functions marked inline and inline
all of them (if possible - which would be the key difference to always_inline).

But would you still want small functions be inlined even if they are not
marked inline?

> The other part that is crazy is when gcc inlines large functions that
> aren't even called most of the time (the "ioctl()" switch statements tend
> to be a great example of this - gcc inlines ten or twenty functions, and
> we can guarantee that only one of them is ever called). Yes, maybe it
> makes the code smaller, but it makes the code also undebuggable and often
> BUGGY, because we now have the stack frame of all ten-to-twenty functions
> to contend with.

Use -fno-inline-functions-called-once then.  But if you ask for -Os you get -Os.
Also recent GCC estimate and limit stack growth - which you can tune
reliably with --param large-stack-frame-growth and --param large-stack-frame.

> And notice how "static" has absolutely _zero_ meaning for the above
> example. Yes, the thing is called just from one place - that's how
> something like that very much works. It's a special case. It's not _worth_
> inlining, especially if it causes bugs. So "called once" or "static" is
> actually totally irrelevant.

Static makes inlining a single call cheap, because the out-of-line body
can be reclaimed.  If you do not like that, turn it off.

> And no, they are not marked "inline" (although they are clearly also not
> marked "uninline", until we figure out that gcc is causing system crashes,
> and we add the thing).
>
> If these two small problems were fixed, gcc inlining would work much
> better. But the first one, in particular, means that the "do I inline or
> not" decision would have to happen after expanding and simplifying
> constants. And then, if the end result is big, the inlining gets aborted.

They do - just constant arguments are obviously not used for optimizing
before inlining.  Otherwise you'd scream bloody murder at us for all the
increase in compile-time ;)

Richard.

>                                Linus
>
