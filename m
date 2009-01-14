From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PULL] adaptive spinning mutexes
Date: Thu, 15 Jan 2009 00:23:27 +0100
Message-ID: <20090114232327.GA29821@elte.hu>
References: <20090114183319.GA18630@elte.hu> <20090114105300.66bd014d.akpm@linux-foundation.org> <20090114190008.GA13203@elte.hu> <20090114113638.c818fcf8.akpm@linux-foundation.org> <20090114201435.GA6519@elte.hu> <20090114123017.9acf42d7.akpm@linux-foundation.org> <20090114205122.GC6519@elte.hu> <20090114130642.cf2b18b2.akpm@linux-foundation.org> <20090114211458.GD6519@elte.hu> <20090114133529.317a346c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
	paulmck@linux.vnet.ibm.com, ghaskins@novell.com, matthew@wil.cx,
	andi@firstfloor.org, chris.mason@oracle.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, tglx@linutronix.de, npiggin@suse.de,
	pmorreale@novell.com, SDietrich@novell.com,
	dmitry.adamushko@gmail.com, hannes@cmpxchg.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090114133529.317a346c.akpm@linux-foundation.org>
List-ID: <linux-btrfs.vger.kernel.org>


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > I also checked Fedora and it has SCHED_DEBUG=y 
> > in its kernel rpms.
> 
> If all distros set SCHED_DEBUG=y then fine.

95% of the distros and significant majority of the lkml traffic.

And no, we dont generally dont provide knobs for essential performance 
features of core Linux kernel primitives - so the existence of SPIN_OWNER 
in /sys/debug/sched_features is an exception already.

We dont have any knob to switch ticket spinlocks to old-style spinlocks. 
We dont have any knob to switch the page allocator from LIFO to FIFO. We 
dont have any knob to turn off the coalescing of vmas in the MM. We dont 
have any knob to turn the mmap_sem from an rwsem to a mutex to a spinlock.

Why? Beacause such design and implementation details are what make Linux 
Linux, and we stand by those decisions for better or worse. And we do try 
to eliminate as many 'worse' situations as possible, but we dont provide 
knobs galore. We offer flexibility in our willingness to fix any genuine 
performance issues in our source code.

The thing is that apps tend to gravitate towards solutions with the least 
short-term cost. If a super important enterprise app can solve their 
performance problem by either redesigning their broken code, or by turning 
off a feature we have in the kernel in their install scripts (which we 
made so easy to tune via a stable sysctl), guess which variant they will 
chose? Even if they hurt all other apps in the process.

> > note that there's also a performance issue here: we generally _dont 
> > want_ a debug sysctl overhead in the mutex code or in any fastpath for 
> > that matter. So making it depend on SCHED_DEBUG is useful.
> > 
> > sched_feat() features get optimized out at build time when SCHED_DEBUG 
> > is disabled. So it gives us the best of two worlds: the utility of 
> > sysctls in the SCHED_DEBUG=y, and they get compiled out in the 
> > !SCHED_DEBUG case.
> 
> I'm not detecting here a sufficient appreciation of the number of 
> sched-related regressions we've seen in recent years, nor of the 
> difficulty encountered in diagnosing and fixing them.  Let alone the 
> difficulty getting those fixes propagated out a *long* time after the 
> regression was added.

The bugzilla you just dug out in another thread does not seem to apply, so 
i'm not sure what you are referring to.

Regarding historic tendencies, we have numbers like:

                      [v2.6.14]     [v2.6.29]

                      Semaphores  | Mutexes
            ----------------------------------------------
                                  | no-spin           spin
                                  |
  [tmpfs]   ops/sec:       50713  |  291038         392865       (+34.9%)
  [ext3]    ops/sec:       45214  |  283291         435674       (+53.7%)

10x performance improvement on ext3, compared to 2.6.14.

I'm sure there will be other numbers that go down - but the thing is, 
we've _never_ been good at finding the worst-possible workload cases 
during development.

> You're taking a whizzy new feature which drastically changes a critical 
> core kernel feature and jamming it into mainline with a vestigial amount 
> of testing coverage without giving sufficient care and thought to the 
> practical lessons which we have learned from doing this in the past.

If you look at the whole existence of /sys/debug/sched_feature you'll see 
how careful we've been about performance regressions. We made it a 
sched_feat() exactly because if a change goes wrong and becomes a step 
backwards then it's a oneliner to turn it default-off.

We made use of that facility in the past and we have a number of debug 
knobs there right now:

 # cat /debug/sched_features 
 NEW_FAIR_SLEEPERS NORMALIZED_SLEEPER WAKEUP_PREEMPT START_DEBIT 
 AFFINE_WAKEUPS CACHE_HOT_BUDDY SYNC_WAKEUPS NO_HRTICK NO_DOUBLE_TICK 
 ASYM_GRAN LB_BIAS LB_WAKEUP_UPDATE ASYM_EFF_LOAD NO_WAKEUP_OVERLAP 
 LAST_BUDDY OWNER_SPIN

All of those ~16 scheduler knobs were done out of caution, to make sure 
that if we change some scheduling aspect there's a convenient way to debug 
performance or interactivity regressions, without forcing people into 
bisection and/or reboots, etc.

> This is a highly risky change.  It's not that the probability of failure 
> is high - the problem is that the *cost* of the improbable failure is 
> high.  We should seek to minimize that cost.

It never mattered much to the efficiency of finding performance 
regressions whether a feature sat tight for 4 kernel releases in -mm or 
went upstream in a week. It _does_ matter to stability - but not 
significantly to performance.

What matteres most to getting performance right is testing exposure and 
variance, not length of the integration period. Easy revertability helps 
too - and that is a given here - it's literally a oneliner to disable it. 
See that oneliner below.

	Ingo

Index: linux/kernel/sched_features.h
===================================================================
--- linux.orig/kernel/sched_features.h
+++ linux/kernel/sched_features.h
@@ -13,4 +13,4 @@ SCHED_FEAT(LB_WAKEUP_UPDATE, 1)
 SCHED_FEAT(ASYM_EFF_LOAD, 1)
 SCHED_FEAT(WAKEUP_OVERLAP, 0)
 SCHED_FEAT(LAST_BUDDY, 1)
-SCHED_FEAT(OWNER_SPIN, 1)
+SCHED_FEAT(OWNER_SPIN, 0)
