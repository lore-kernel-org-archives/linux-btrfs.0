From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex: implement
 adaptive spinning
Date: Mon, 12 Jan 2009 12:11:07 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901121209220.6528@localhost.localdomain>
References: <1231676801.25018.150.camel@macbook.infradead.org> <20090111181307.GM26290@one.firstfloor.org> <alpine.LFD.2.00.0901111114230.6528@localhost.localdomain> <20090111201427.GP26290@one.firstfloor.org> <1231704939.25018.548.camel@macbook.infradead.org>
 <20090111203441.GQ26290@one.firstfloor.org> <alpine.LFD.2.00.0901111248060.6528@localhost.localdomain> <alpine.LFD.2.00.0901111458290.6528@localhost.localdomain> <20090112001255.GR26290@one.firstfloor.org> <alpine.LFD.2.00.0901111619400.6528@localhost.localdomain>
 <20090112005228.GS26290@one.firstfloor.org> <496B86B5.3090707@t-online.de> <alpine.LFD.2.00.0901121034170.6528@localhost.localdomain> <496BA036.3010101@t-online.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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
To: Bernd Schmidt <bernds_cb1@t-online.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <496BA036.3010101@t-online.de>
List-ID: <linux-btrfs.vger.kernel.org>



On Mon, 12 Jan 2009, Bernd Schmidt wrote:
> 
> However, if the compiler chooses to put them into the same stack 
> location, the RTL-based alias analysis will happily conclude (based on 
> the differing types) that the reads from A and the writes to B can't 
> possibly conflict, and some passes may end up reordering them. End 
> result: overlapping lifetimes and overlapping stack slots.  Oops.

Yes, I came to the same conclusion.

Of course, I knew a-priori that the real bug was using type-based alais 
analysis to make (statically visible) aliasing decisions, but I realize 
that there are people who never understood things like that. Sadly, some 
of them worked on gcc.

			Linus
