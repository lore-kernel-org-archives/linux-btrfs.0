From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex: implement
 adaptive spinning
Date: Mon, 12 Jan 2009 11:45:03 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901121143070.6528@localhost.localdomain>
References: <20090111201427.GP26290@one.firstfloor.org> <1231704939.25018.548.camel@macbook.infradead.org> <20090111203441.GQ26290@one.firstfloor.org> <alpine.LFD.2.00.0901111248060.6528@localhost.localdomain> <alpine.LFD.2.00.0901111458290.6528@localhost.localdomain>
 <20090112001255.GR26290@one.firstfloor.org> <alpine.LFD.2.00.0901111619400.6528@localhost.localdomain> <20090112005228.GS26290@one.firstfloor.org> <496B86B5.3090707@t-online.de> <alpine.LFD.2.00.0901121034170.6528@localhost.localdomain>
 <20090112193201.GA23848@one.firstfloor.org> <496B9890.1090002@zytor.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Andi Kleen <andi@firstfloor.org>,
	Bernd Schmidt <bernds_cb1@t-online.de>,
	David Woodhouse <dwmw2@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
	Harvey Harrison <harvey.harrison@gmail.com>,
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
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <496B9890.1090002@zytor.com>
List-ID: <linux-btrfs.vger.kernel.org>



On Mon, 12 Jan 2009, H. Peter Anvin wrote:
> 
> This is about storage allocation, not aliases.  Storage allocation only
> depends on lifetime.

Well, the thing is, code motion does extend life-times, and if you think 
you can move stores across each other (even when you can see that they 
alias statically) due to type-based alias decisions, that does essentially 
end up making what _used_ to be disjoint lifetimes now be potentially 
overlapping.

			Linus
