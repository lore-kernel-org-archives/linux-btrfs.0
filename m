From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y impact
Date: Fri, 9 Jan 2009 18:46:22 +0100
Message-ID: <20090109174622.GF26290@one.firstfloor.org>
References: <20090108183306.GA22916@elte.hu> <496648C7.5050700@zytor.com> <alpine.LFD.2.00.0901081943150.6528@localhost.localdomain> <20090109130057.GA31845@elte.hu> <49675920.4050205@hp.com> <20090109153508.GA4671@elte.hu> <49677CB1.3030701@zytor.com> <20090109084620.3c711aad@infradead.org> <20090109172011.GD26290@one.firstfloor.org> <alpine.LFD.2.00.0901090909080.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	Dirk Hohndel <hohndel@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
	jim owens <jowens@hp.com>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>, jh@suse.cz
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901090909080.6528@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 09, 2009 at 09:11:47AM -0800, Linus Torvalds wrote:
> IIRC, the numbers mean different things for different versions of gcc, and 
> I think using the parameters was very strongly discouraged by gcc 
> developers. IOW, they were meant for gcc developers internal tuning 
> efforts, not really for external people. Which means that using them would 

When I asked last time that was not what I heard. Apparently at least
some --params are considered ready for user consumption these days.

> put us _more_ at the mercy of random compiler versions rather than less.

Yes it would basically be a list in the Makefile keyed on compiler
version giving different options and someone would need to do 
the work to do that for each new compiler version.

That would be some work, but it might be less work than going
all over 9.7MLOCs and changing inlines around manually.
Also the advantage is that that you wouldn't need to teach
the rules to hundreds of new driver programmers.

Anyways I'm not very strongly wedded to this idea, but I think
it's an alternative that should be at least considered before
doing anything else drastic.

-Andi

-- 
ak@linux.intel.com
