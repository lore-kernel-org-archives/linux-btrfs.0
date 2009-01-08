From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -v6][RFC]: mutex: implement adaptive spinning
Date: Thu, 8 Jan 2009 15:18:08 +0100
Message-ID: <20090108141808.GC11629@elte.hu>
References: <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain> <1231347442.11687.344.camel@twins> <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain> <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com> <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain> <1231365115.11687.361.camel@twins> <alpine.LFD.2.00.0901071355350.3057@localhost.localdomain> <1231366716.11687.377.camel@twins> <alpine.LFD.2.00.0901071509160.3057@localhost.localdomain> <1231408718.11687.400.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
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
	Sven Dietrich <SDietrich@novell.com>
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1231408718.11687.400.camel@twins>
List-ID: <linux-btrfs.vger.kernel.org>


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2009-01-07 at 15:10 -0800, Linus Torvalds wrote:
> 
> > Please take all my patches to be pseudo-code. They've neither been 
> > compiled nor tested, and I'm just posting them in the hope that somebody 
> > else will then do things in the direction I think is the proper one ;)
> 
> Linux opteron 2.6.28-tip #585 SMP PREEMPT Thu Jan 8 10:38:09 CET 2009 x86_64 x86_64 x86_64 GNU/Linux
> 
> [root@opteron bench]# echo NO_OWNER_SPIN > /debug/sched_features; ./timec -e -5,-4,-3,-2 ./test-mutex V 16 10
> 2 CPUs, running 16 parallel test-tasks.
> checking VFS performance.
> avg ops/sec:               74996
> 
>  Performance counter stats for './test-mutex':
> 
>    12098.324578  task clock ticks     (msecs)
> 
>            1081  CPU migrations       (events)
>            7102  context switches     (events)
>            2763  pagefaults           (events)
> 
>  Wall-clock time elapsed: 12026.804839 msecs
> 
> [root@opteron bench]# echo OWNER_SPIN > /debug/sched_features; ./timec -e -5,-4,-3,-2 ./test-mutex V 16 10
> 2 CPUs, running 16 parallel test-tasks.
> checking VFS performance.
> avg ops/sec:               228126
> 
>  Performance counter stats for './test-mutex':
> 
>    22280.283224  task clock ticks     (msecs)
> 
>             117  CPU migrations       (events)
>            5711  context switches     (events)
>            2781  pagefaults           (events)
> 
>  Wall-clock time elapsed: 12307.053737 msecs
> 
> * WOW *

WOW indeed - and i can see a similar _brutal_ speedup on two separate 
16-way boxes as well:

  16 CPUs, running 128 parallel test-tasks.

  NO_OWNER_SPIN:
  avg ops/sec:               281595

  OWNER_SPIN:
  avg ops/sec:               524791

Da Killer!

Look at the performance counter stats:

>    12098.324578  task clock ticks     (msecs)
> 
>            1081  CPU migrations       (events)
>            7102  context switches     (events)
>            2763  pagefaults           (events)

>    22280.283224  task clock ticks     (msecs)
> 
>             117  CPU migrations       (events)
>            5711  context switches     (events)
>            2781  pagefaults           (events)

We were able to spend twice as much CPU time and efficiently so - and we 
did about 10% of the cross-CPU migrations as before (!).

My (wild) guess is that the biggest speedup factor was perhaps this little 
trick:

+               if (need_resched())
+                       break;

this allows the spin-mutex to only waste CPU time if there's no work 
around on that CPU. (i.e. if there's no other task that wants to run) The 
moment there's some other task, we context-switch to it.

Very elegant concept i think.

[ A detail, -tip testing found that the patch breaks mutex debugging:

  =====================================
  [ BUG: bad unlock balance detected! ]
  -------------------------------------
  swapper/0 is trying to release lock (cpu_add_remove_lock) at:
  [<ffffffff8089f540>] mutex_unlock+0xe/0x10
  but there are no more locks to release!

 but that's a detail for -v7 ;-) ]

	Ingo
