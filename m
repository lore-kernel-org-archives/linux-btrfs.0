From: Andi Kleen <andi@firstfloor.org>
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Mon, 12 Jan 2009 01:52:28 +0100
Message-ID: <20090112005228.GS26290@one.firstfloor.org>
References: <1231676801.25018.150.camel@macbook.infradead.org> <20090111181307.GM26290@one.firstfloor.org> <alpine.LFD.2.00.0901111114230.6528@localhost.localdomain> <20090111201427.GP26290@one.firstfloor.org> <1231704939.25018.548.camel@macbook.infradead.org> <20090111203441.GQ26290@one.firstfloor.org> <alpine.LFD.2.00.0901111248060.6528@localhost.localdomain> <alpine.LFD.2.00.0901111458290.6528@localhost.localdomain> <20090112001255.GR26290@one.firstfloor.org> <alpine.LFD.2.00.0901111619400.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
In-Reply-To: <alpine.LFD.2.00.0901111619400.6528@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 11, 2009 at 04:21:03PM -0800, Linus Torvalds wrote:
> 
> 
> On Mon, 12 Jan 2009, Andi Kleen wrote:
> > 
> > so at least least for this case it works. Your case also doesn't work 
> > for me. So it looks like gcc didn't like something you did in your test 
> > program.
> 
> I very intentionally used _different_ types.
> 
> If you use the same type, gcc will apparenrly happily say "hey, I can 
> combine two variables of the same type with different liveness into the 
> same variable".

Confirmed.

> But that's not the interesting case.

Weird. I wonder where this strange restriction comes from. It indeed
makes this much less useful than it could be :/

-Andi
-- 
ak@linux.intel.com
