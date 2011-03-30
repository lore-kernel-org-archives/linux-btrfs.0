From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 2/2] mutex: Apply adaptive spinning on mutex_trylock()
Date: Wed, 30 Mar 2011 07:46:27 -0400
Message-ID: <1301485262-sup-5247@think>
References: <20110323153727.GB12003@htj.dyndns.org> <20110324094119.GD12038@htj.dyndns.org> <20110324094151.GE12038@htj.dyndns.org> <20110325101238.GC1409@htj.dyndns.org> <20110329163702.GE29865@htj.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Cc: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20110329163702.GE29865@htj.dyndns.org>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Tejun Heo's message of 2011-03-29 12:37:02 -0400:
> Hello, guys.
> 
> I've been running dbench 50 for a few days now and the result is,
> well, I don't know how to call it.
> 
> The problem was that the original patch didn't do anything because x86
> fastpath code didn't call into the generic slowpath at all.
> 
>   static inline int __mutex_fastpath_trylock(atomic_t *count,
>                          int (*fail_fn)(atomic_t *))
>   {
>       if (likely(atomic_cmpxchg(count, 1, 0) == 1))
>           return 1;
>       else
>           return 0;
>   }                                                
> 
> So, I thought that I probably was doing unconscious data selection
> while I was running the test before sending out the patches.  Maybe I
> was seeing what I wanted to see, so I ran tests in larger scale more
> methodologically.
> 
> I first started with ten consecutive runs and then doubled it with
> intervening reboot and then basically ended up doing that twice for
> four configuration (I didn't do two runs of simple and refactor but
> just averaged the two).
> 
> The hardware is mostly the same except that I switched to a hard drive
> instead of SSD as hard drives tend to be slower but more consistent in
> performance numbers.  On each run, the filesystem is recreated and the
> system was rebooted after every ten runs.  The numbers are the
> reported throughput in MiB/s at the end of each run.
> 
>   https://spreadsheets.google.com/ccc?key=0AsbaQh2SFt66dDdxOGZWVVlIbEdIOWRQLURVVUNYSXc&hl=en
> 
> Here are the descriptions of the eight columns.
> 
>   simple    only with patch to make btrfs use mutex
>   refactor    mutex_spin() factored out
>   spin        mutex_spin() applied to the unused trylock slowpath
>   spin-1    ditto
>   spin-fixed    x86 trylock fastpath updated to use generic slowpath
>   spin-fixed-1    ditto
>   code-layout    refactor + dummy function added to mutex.c
>   code-layout-1    ditto
> 
> After running the simple, refactor and spin ones, I was convinced that
> there definitely was something which was causing the difference.  The
> averages were apart by more than 1.5 sigma, but I couldn't explain
> what could have caused such difference.

I have another workload that is interesting for this, basically N (100
or so) procs all doing stats on a bunch of files in the same directory.
This hammers very hard on the btree lookups.

During the first set of mutex spinning patches, doing any kind of
breakout on the owner spin (when the owner hasn't changed) made it much
slower.

You might want to try again with the 2.6.39-rc1 btrfs (or pull my
for-linus-unmerged tree into .38) because this gets rid of an unneeded
spinlock for the root node.

All your work convinced me to dig out my seqlock patches for read only
tree block operations.  I think we can take your current btrfs patches
and combine the seqlock stuff for a huge benefit.

In this case, the only thing we're really missing is a way to mutex_lock
without the cond_resched()

The biggest trylock user in btrfs is only there so we can keep the
spinning lock instead of the blocking lock.  Since you're getting rid of
the whole spin vs block setup, we can switch directly to a lock.

-chris
