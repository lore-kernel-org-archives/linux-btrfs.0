From: Bernd Schmidt <bernds_cb1@t-online.de>
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex: implement
 adaptive spinning
Date: Mon, 12 Jan 2009 23:03:19 +0100
Message-ID: <496BBE27.2020206@t-online.de>
References: <20090111201427.GP26290@one.firstfloor.org> <1231704939.25018.548.camel@macbook.infradead.org> <20090111203441.GQ26290@one.firstfloor.org> <alpine.LFD.2.00.0901111248060.6528@localhost.localdomain> <alpine.LFD.2.00.0901111458290.6528@localhost.localdomain> <20090112001255.GR26290@one.firstfloor.org> <alpine.LFD.2.00.0901111619400.6528@localhost.localdomain> <20090112005228.GS26290@one.firstfloor.org> <496B86B5.3090707@t-online.de> <alpine.LFD.2.00.0901121034170.6528@localhost.localdomain> <20090112193201.GA23848@one.firstfloor.org> <alpine.LFD.2.00.0901121128080.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andi Kleen <andi@firstfloor.org>,
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901121128080.6528@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

Linus Torvalds wrote:
> But you'll need some background to it:

You paint a somewhat one-sided picture bordering on FUD.

> Type-based aliasing is _stupid_.

Type-based aliasing is simply an application of the language definition,
and depending on the compiled application and/or target architecture, it
can be essential for performance.

It's _hard_ to tell whether two memory accesses can possibly conflict,
and the ability to decide based on type makes a vast difference.  This
is not, as you suggest in another post, simply a mild inconvenience for
the compiler that restricts scheduling a bit and forces the hardware
sort it out at run-time.  Too lazy to construct one myself, I googled
for examples, and here's a trivial one that shows how it affects the
ability of the compiler to eliminate memory references:

  typedef struct
  {
    short a, b, c;
  } Sample;

  void test(int* values, Sample *uniform, int count)
  {
   int i;

   for (i=0;i<count;i++)
   {
     values[i] += uniform->b;
   }
  }

Type-based aliasing is what allows you to eliminate a load from the
loop.  Most users probably expect this kind of optimization from their
compiler, and it'll make a difference not just on Itanium.

I'll grant you that if you're writing a kernel or maybe a malloc
library, you have reason to be unhappy about it.  But that's what
compiler switches are for: -fno-strict-aliasing allows you to write code
in a superset of C.

> So gcc did. I know for a _fact_ that gcc would re-order write accesses 
> that were clearly to (statically) the same address. Gcc would suddenly 
> think that
> 
> 	unsigned long a;
> 
> 	a = 5;
> 	*(unsigned short *)&a = 4;
> 
> could be re-ordered to set it to 4 first (because clearly they don't alias 
> - by reading the standard),

To be precise, what the standard says is that your example is not C, and
therefore has no meaning.  While this kind of thing does occur in the
wild, it is infrequent, and the programs that used this kind of code
have been fixed over the years.

gcc even warns about code such as the above with -Wall, which makes this
even more of a non-issue.

linus2.c: In function 'foo':
linus2.c:6: warning: dereferencing type-punned pointer will break
strict-aliasing rules

> and then because now the assignment of 'a=5' 
> was later, the assignment of 4 could be elided entirely! And if somebody 
> complains that the compiler is insane, the compiler people would say 
> "nyaah, nyaah, the standards people said we can do this", with absolutely 
> no introspection to ask whether it made any SENSE.

The thing is, yours is a trivial example, but try to think further: in
the general case the compiler can't tell whether two accesses can go to
the same address at runtime.  If it could, we wouldn't be having this
discussion; I'm pretty sure this question reduces to the halting
problem.  That's why the compiler must have a set of conservative rules
that allow it to decide that two accesses definitely _can't_ conflict.
For all standards conforming programs, type based aliasing is such a
rule.  You could add code to weaken it by also checking against the
address, but since that cannot be a reliable test that catches all
problematic cases, what would be the point?

So, in effect, if you're arguing that the compiler should detect the
above case and override the type-based aliasing based on the known
address, you're arguing that only subtle bugs in the application should
be exposed, not the obvious ones.  If you're arguing we should do away
with type-based aliasing altogether, you're ignoring the fact that there
are (a majority of) other users of gcc than the Linux kernel, they write
standards-conforming C, and they tend to worry about performance of
compiled code.

> The fact is, Linux uses -fno-strict-aliasing for a damn good reason: 
> because the gcc notion of "strict aliasing" is one huge stinking pile of 
> sh*t. Linux doesn't use that flag because Linux is playing fast and loose, 
> it uses that flag because _not_ using that flag is insane.

Not using this flag works for pretty much all user space applications
these days.

> Type-based aliasing is unacceptably stupid to begin with, and gcc took 
> that stupidity to totally new heights by making it actually more important 
> than even statically visible aliasing.

gcc makes use of statically visible aliasing if it can use it to prove
that two accesses can't conflict even if they have the same type, but
it's vastly less powerful than type based analysis.  Since it's
impossible in general to decide that two accesses must conflict, trying
to avoid transformations based on such an attempt is completely
senseless.  Trying to do so would have no effect for conforming C
programs, and avoid only a subset of the problematic cases for other
programs, so it's a waste of time.

So, to summarize: strict aliasing works for nearly every application
these days, there's a compiler switch for the rest to turn it off, it
can be a serious performance improvement, and the compiler warns about
dangerous constructs.  That makes the issue a little less black and
white than "type based aliasing is stupid".


Bernd
-- 
This footer brought to you by insane German lawmakers.
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 40368
Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif
