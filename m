From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PULL] adaptive spinning mutexes
Date: Wed, 14 Jan 2009 19:47:46 +0100
Message-ID: <20090114184746.GA21334@elte.hu>
References: <1231774622.4371.96.camel@laptop> <1231859742.442.128.camel@twins> <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain> <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins> <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain> <1231867314.7141.16.camel@twins> <1231952436.14825.28.camel@laptop> <20090114183319.GA18630@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>,
	Dmitry Adamushko <dmitry.adamushko@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090114183319.GA18630@elte.hu>
List-ID: <linux-btrfs.vger.kernel.org>


* Ingo Molnar <mingo@elte.hu> wrote:

> Linus,
> 
> Please pull the adaptive-mutexes-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git adaptive-mutexes-for-linus
> 
> We dropped two fresh patches from v11 for the time being: the two debug 
> patches, they had test failures [they triggered mutex debugging false 
> positives].
> 
> So this tree is v10 (which got a lot of testing already) plus Chris's 
> performance patch. It passes all x86 runtime tests here.

Latest performance figures, on a 2-socket 16-way Nehalem test-system, 
running the code above, measured via "test-mutex V 128 10" VFS 
creat+unlink scalability test on tmpfs and ext3:

                              no-spin           spin

 [tmpfs]    avg ops/sec:       291038         392865       (+34.9%)
 [ext3]     avg ops/sec:       283291         435674       (+53.7%)

Those numbers impress the heck out of me, rarely do we have such kind of 
speedups these days, for any established functionality.

We still have the /sys/debug/sched_features tunable under 
CONFIG_SCHED_DEBUG=y, so should this cause any performance regressions 
somewhere, it can be pinned down and blamed back on this change easily, 
without bisection and without rebooting the box.

	Ingo
