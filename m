From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex: implement
 adaptive spinning
Date: Sun, 11 Jan 2009 12:51:31 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901111248060.6528@localhost.localdomain>
References: <20090109231227.GA25070@elte.hu> <alpine.LFD.2.00.0901091522250.6528@localhost.localdomain> <20090110010125.GA31031@elte.hu> <20090109174158.096dee70.akpm@linux-foundation.org> <20090110030216.GW26290@one.firstfloor.org>
 <1231676801.25018.150.camel@macbook.infradead.org> <20090111181307.GM26290@one.firstfloor.org> <alpine.LFD.2.00.0901111114230.6528@localhost.localdomain> <20090111201427.GP26290@one.firstfloor.org> <1231704939.25018.548.camel@macbook.infradead.org>
 <20090111203441.GQ26290@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: David Woodhouse <dwmw2@infradead.org>,
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
In-Reply-To: <20090111203441.GQ26290@one.firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>



On Sun, 11 Jan 2009, Andi Kleen wrote:
> 
> Was -- i think that got fixed in gcc. But again only in newer versions.

I doubt it. People have said that about a million times, it has never 
gotten fixed, and I've never seen any actual proof.

I think that what got fixed was that gcc now at least re-uses stack slots 
for temporary spills. But only for things that fit in registers - not if 
you actually had variables that are big enough to be of type MEM. And the 
latter is what tends to eat stack-space (ie structures etc on stack).

But hey, maybe it really did get fixed. But the last big stack user wasn't 
that long ago, and I saw it and I have a pretty recent gcc (gcc-4.3.2 
right now, it could obviously have been slightly older back a few months 
ago).

		Linus
