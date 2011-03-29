From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] mutex: Apply adaptive spinning on mutex_trylock()
Date: Tue, 29 Mar 2011 18:37:02 +0200
Message-ID: <20110329163702.GE29865@htj.dyndns.org>
References: <20110323153727.GB12003@htj.dyndns.org>
 <20110324094119.GD12038@htj.dyndns.org>
 <20110324094151.GE12038@htj.dyndns.org>
 <20110325101238.GC1409@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Mason <chris.m
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110325101238.GC1409@htj.dyndns.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello, guys.

I've been running dbench 50 for a few days now and the result is,
well, I don't know how to call it.

The problem was that the original patch didn't do anything because x86
fastpath code didn't call into the generic slowpath at all.

  static inline int __mutex_fastpath_trylock(atomic_t *count,
					     int (*fail_fn)(atomic_t *))
  {
	  if (likely(atomic_cmpxchg(count, 1, 0) == 1))
		  return 1;
	  else
		  return 0;
  }												

So, I thought that I probably was doing unconscious data selection
while I was running the test before sending out the patches.  Maybe I
was seeing what I wanted to see, so I ran tests in larger scale more
methodologically.

I first started with ten consecutive runs and then doubled it with
intervening reboot and then basically ended up doing that twice for
four configuration (I didn't do two runs of simple and refactor but
just averaged the two).

The hardware is mostly the same except that I switched to a hard drive
instead of SSD as hard drives tend to be slower but more consistent in
performance numbers.  On each run, the filesystem is recreated and the
system was rebooted after every ten runs.  The numbers are the
reported throughput in MiB/s at the end of each run.

  https://spreadsheets.google.com/ccc?key=0AsbaQh2SFt66dDdxOGZWVVlIbEdIOWRQLURVVUNYSXc&hl=en

Here are the descriptions of the eight columns.

  simple	only with patch to make btrfs use mutex
  refactor	mutex_spin() factored out
  spin		mutex_spin() applied to the unused trylock slowpath
  spin-1	ditto
  spin-fixed	x86 trylock fastpath updated to use generic slowpath
  spin-fixed-1	ditto
  code-layout	refactor + dummy function added to mutex.c
  code-layout-1	ditto

After running the simple, refactor and spin ones, I was convinced that
there definitely was something which was causing the difference.  The
averages were apart by more than 1.5 sigma, but I couldn't explain
what could have caused such difference.

The code-layout runs were my desparate attempts to find explanation on
what's going on.  Addition of mutex_spin to the unused trylock generic
path makes gcc arrange functions differently.  Without it, trylock
functions end up inbetween lock and unlock funcitons; with it, they
are located at the end.  I commented out the unused trylock slowpath
function and added a dummy function at the end to make gcc generate
similar assembly layout.

At this point, the only conclusions I can draw are,

* Using adaptive spinning on mutex_trylock() doesn't seem to buy
  anything according to btrfs dbench 50 runs.

and much more importantly,

* btrfs dbench 50 runs are probably not good for measuring subtle
  mutex performance differences.  Maybe it's too macro and there are
  larger scale tendencies which skew the result unless the number of
  runs are vastly increased (but 40 runs are already over eight
  hours).

If anyone can provide an explanation on what's going on, I'll be super
happy.  Otherwise, for now, I'll just leave it alone.  :-(

Thanks.

-- 
tejun
