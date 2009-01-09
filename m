From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y impact
Date: Fri, 9 Jan 2009 18:32:33 +0100
Message-ID: <20090109173233.GE26290@one.firstfloor.org>
References: <20090108183306.GA22916@elte.hu> <496648C7.5050700@zytor.com> <alpine.LFD.2.00.0901081943150.6528@localhost.localdomain> <20090109130057.GA31845@elte.hu> <49675920.4050205@hp.com> <20090109153508.GA4671@elte.hu> <49677CB1.3030701@zytor.com> <20090109084620.3c711aad@infradead.org> <49678095.2030803@zytor.com> <alpine.DEB.1.10.0901091206460.17378@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	Dirk Hohndel <hohndel@infradead.org>,
	Ingo Molnar <mingo@elte.hu>, jim owens <jowens@hp.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
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
To: Steven Rostedt <rostedt@goodmis.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0901091206460.17378@gandalf.stny.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>

> I vote for the, get rid of the current inline, rename __always_inline to 

There is some code that absolutely requires inline for correctness,
like the x86-64 vsyscall code. I would advocate to keep the
explicit __always_inline at least there to make it very clear.

> inline, and then remove all non needed inlines from the kernel.

Most inlines in .c should be probably dropped.

> 
> We'll, probably start adding a lot more noinlines.

That would cost you, see the numbers I posted (~4.1% text increase)

-Andi
-- 
ak@linux.intel.com
