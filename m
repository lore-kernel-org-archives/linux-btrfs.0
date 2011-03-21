From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH RFC] btrfs: Simplify locking
Date: Sun, 20 Mar 2011 20:10:51 -0400
Message-ID: <1300665355-sup-1698@think>
References: <20110320174433.GA12003@htj.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20110320174433.GA12003@htj.dyndns.org>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Tejun Heo's message of 2011-03-20 13:44:33 -0400:
> Hello, guys.
> 
> I've been looking through btrfs code and found out that the locking
> was quite interesting.  The distinction between blocking and
> non-blocking locking is valid but is essentially attacing the same
> problem that CONFIG_MUTEX_SPIN_ON_OWNER addresses in generic manner.
> 
> It seemed that CONFIG_MUTEX_SPIN_ON_OWNER should be able to do it
> better as it actually knows whether the lock owner is running or not,
> so I did a few "dbench 50" runs with the complex locking removed.
> 
> The test machine is a dual core machine with 1 gig of memory.  The
> filesystem is on OCZ vertex 64 gig SSD.  I'm attaching the kernel
> config.  Please note that CONFIG_MUTEX_SPIN_ON_OWNER is enabled only
> when lock debugging is disabled, but it will be enabled on virtually
> any production configuration.
> 
> The machine was idle during the dbench runs and CPU usages and context
> switches are calculated from /proc/stat over the dbench runs.  The
> throughput is as reported by dbench.
> 
>          user  system  sirq    cxtsw throughput
> before  14426  129332   345  1674004    171.7
> after   14274  129036   308  1183346    172.119
> 
> So, the extra code isn't really helping anything.  It's worse in every
> way.  Are there some obscure reasons the custom locking should be kept
> around?

Hi Tejun,

I went through a number of benchmarks with the explicit
blocking/spinning code and back then it was still significantly faster
than the adaptive spin.  But, it is definitely worth doing these again,
how many dbench procs did you use?

The biggest benefit to explicit spinning is that mutex_lock starts with
might_sleep(), so we skip the cond_resched().  Do you have voluntary
preempt on?

The long term goal was always to get rid of the blocking locks, I had a
lot of code to track the top blockers and we had gotten rid of about 90%
of them.

Thanks for looking at this

-chris
