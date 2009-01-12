From: Bernd Schmidt <bernds_cb1@t-online.de>
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex: implement
 adaptive spinning
Date: Mon, 12 Jan 2009 20:55:34 +0100
Message-ID: <496BA036.3010101@t-online.de>
References: <1231676801.25018.150.camel@macbook.infradead.org> <20090111181307.GM26290@one.firstfloor.org> <alpine.LFD.2.00.0901111114230.6528@localhost.localdomain> <20090111201427.GP26290@one.firstfloor.org> <1231704939.25018.548.camel@macbook.infradead.org> <20090111203441.GQ26290@one.firstfloor.org> <alpine.LFD.2.00.0901111248060.6528@localhost.localdomain> <alpine.LFD.2.00.0901111458290.6528@localhost.localdomain> <20090112001255.GR26290@one.firstfloor.org> <alpine.LFD.2.00.0901111619400.6528@localhost.localdomain> <20090112005228.GS26290@one.firstfloor.org> <496B86B5.3090707@t-online.de> <alpine.LFD.2.00.0901121034170.6528@localhost.localdomain>
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
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901121034170.6528@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

Linus Torvalds wrote:
> 
> On Mon, 12 Jan 2009, Bernd Schmidt wrote:
>> Something at the back of my mind said "aliasing".
>>
>> $ gcc linus.c -O2 -S ; grep subl linus.s
>>         subl    $1624, %esp
>> $ gcc linus.c -O2 -S -fno-strict-aliasing; grep subl linus.s
>>         subl    $824, %esp
>>
>> That's with 4.3.2.
> 
> Interesting. 
> 
> Nonsensical, but interesting.
> 
> Since they have no overlap in lifetime, confusing this with aliasing is 
> really really broken (if the functions _hadn't_ been inlined, you'd have 
> gotten the same address for the two variables anyway! So anybody who 
> thinks that they need different addresses because they are different types 
> is really really fundmantally confused!).

I've never really looked at the stack slot sharing code.  But I think
it's not hard to see what's going on: "no overlap in lifetime" may be a
temporary state.  Let's say you have

 {
   variable_of_some_type a;
   writes to a;
   other stuff;
   reads from a;
 }
 {
   variable_of_some_other_type b;
   writes to b;
   other stuff;
   reads from b;
 }

At the point where the compiler generates RTL, stack space has to be
allocated for variables A and B.  At this point the lifetimes are
non-overlapping.  However, if the compiler chooses to put them into the
same stack location, the RTL-based alias analysis will happily conclude
(based on the differing types) that the reads from A and the writes to B
can't possibly conflict, and some passes may end up reordering them.
End result: overlapping lifetimes and overlapping stack slots.  Oops.


Bernd
-- 
This footer brought to you by insane German lawmakers.
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 40368
Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif
