From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex: implement
 adaptive spinning
Date: Mon, 12 Jan 2009 11:42:55 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901121128080.6528__33422.5328093909$1232291247$gmane$org@localhost.localdomain>
References: <20090111201427.GP26290@one.firstfloor.org> <1231704939.25018.548.camel@macbook.infradead.org> <20090111203441.GQ26290@one.firstfloor.org> <alpine.LFD.2.00.0901111248060.6528@localhost.localdomain> <alpine.LFD.2.00.0901111458290.6528@localhost.localdomain>
 <20090112001255.GR26290@one.firstfloor.org> <alpine.LFD.2.00.0901111619400.6528@localhost.localdomain> <20090112005228.GS26290@one.firstfloor.org> <496B86B5.3090707@t-online.de> <alpine.LFD.2.00.0901121034170.6528@localhost.localdomain>
 <20090112193201.GA23848@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Bernd Schmidt <bernds_cb1@t-online.de>,
	David Woodhouse <dwmw2@infradead.org>,
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
In-Reply-To: <20090112193201.GA23848@one.firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>



On Mon, 12 Jan 2009, Andi Kleen wrote:
>
> What I find nonsensical is that -fno-strict-aliasing generates
> better code here. Normally one would expect the compiler seeing
> more aliases with that option and then be more conservative
> regarding any sharing. But it seems to be the other way round
> here.

No, that's not the surprising part. And in fact, now that you mention it, 
I can even tell you why gcc does what it does.

But you'll need some background to it:

Type-based aliasing is _stupid_. It's so incredibly stupid that it's not 
even funny. It's broken. And gcc took the broken notion, and made it more 
so by making it a "by-the-letter-of-the-law" thing that makes no sense.

What happens (well, maybe it's fixed, but this was _literally_ what gcc 
used to do) is that the type-based aliasing overrode everything else, so 
if two accesses were to different types (and not in a union, and none of 
the types were "char"), then gcc "knew" that they clearly could not alias, 
and could thus wildly re-order accesses.

That's INSANE. It's so incredibly insane that people who do that should 
just be put out of their misery before they can reproduce. But real gcc 
developers really thought that it makes sense, because the standard allows 
it, and it gives the compiler the maximal freedom - because it can now do 
things that are CLEARLY NONSENSICAL.

And to compiler people, being able to do things that are clearly 
nonsensical seems to often be seen as a really good thing, because it 
means that they no longer have to worry about whether the end result works 
or not - they just got permission to do stupid things in the name of 
optimization.

So gcc did. I know for a _fact_ that gcc would re-order write accesses 
that were clearly to (statically) the same address. Gcc would suddenly 
think that

	unsigned long a;

	a = 5;
	*(unsigned short *)&a = 4;

could be re-ordered to set it to 4 first (because clearly they don't alias 
- by reading the standard), and then because now the assignment of 'a=5' 
was later, the assignment of 4 could be elided entirely! And if somebody 
complains that the compiler is insane, the compiler people would say 
"nyaah, nyaah, the standards people said we can do this", with absolutely 
no introspection to ask whether it made any SENSE.

Anyway, once you start doing stupid things like that, and once you start 
thinking that the standard makes more sense than a human being using his 
brain for 5 seconds, suddenly you end up in a situation where you can move 
stores around wildly, and it's all 'correct'.

Now, take my stupid example, and make "fn1()" do "a.a = 1" and make 
"fn2()" do "b.b = 2", and think about what a compiler that thinks it can 
re-order the two writes willy-nilly will do?

Right. It will say "ok, a.a and b.b can not alias EVEN IF THEY HAVE 
STATICALLY THE SAME ADDFRESS ON THE STACK", because they are in two 
different structres. So we can then re-order the accesses, and move the 
stores around.

Guess what happens if you have that kind of insane mentality, and you then 
try to make sure that they really don't alias, so you allocate extra stack 
space.

The fact is, Linux uses -fno-strict-aliasing for a damn good reason: 
because the gcc notion of "strict aliasing" is one huge stinking pile of 
sh*t. Linux doesn't use that flag because Linux is playing fast and loose, 
it uses that flag because _not_ using that flag is insane.

Type-based aliasing is unacceptably stupid to begin with, and gcc took 
that stupidity to totally new heights by making it actually more important 
than even statically visible aliasing.

		Linus
