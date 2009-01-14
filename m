From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PULL] adaptive spinning mutexes
Date: Wed, 14 Jan 2009 20:00:08 +0100
Message-ID: <20090114190008.GA13203@elte.hu>
References: <1231774622.4371.96.camel@laptop> <1231859742.442.128.camel@twins> <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain> <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins> <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain> <1231867314.7141.16.camel@twins> <1231952436.14825.28.camel@laptop> <20090114183319.GA18630@elte.hu> <20090114105300.66bd014d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>,
	Dmitry Adamushko <dmitry.adamushko@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090114105300.66bd014d.akpm@linux-foundation.org>
List-ID: <linux-btrfs.vger.kernel.org>


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 14 Jan 2009 19:33:19 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Please pull the adaptive-mutexes-for-linus git tree
> 
> <fear>
> 
> - It seems a major shortcoming that the feature is disabled if
>   CONFIG_DEBUG_MUTEXES=y.  It means that lots of people won't test it.
> 
> - When people hit performance/latency oddities, it would be nice if
>   they had a /proc knob with which they could disable this feature at
>   runtime.
> 
>   This would also be useful for comparative performance testing.

Yeah. From my other mail:

> > We still have the /sys/debug/sched_features tunable under 
> > CONFIG_SCHED_DEBUG=y, so should this cause any performance regressions 
> > somewhere, it can be pinned down and blamed back on this change 
> > easily, without bisection and without rebooting the box.

This kind of easy knob was included early on - this is how all those spin 
versus no-spin numbers were done.

	Ingo
