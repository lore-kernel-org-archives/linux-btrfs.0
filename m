From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH -v4][RFC]: mutex: implement adaptive spinning
Date: Wed, 07 Jan 2009 12:20:01 -0500
Message-ID: <1231348801.27813.31.camel@think.oraclecorp.com>
References: <87r63ljzox.fsf@basil.nowhere.org>
	 <20090103191706.GA2002@parisc-linux.org> <1231093310.27690.5.camel@twins>
	 <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins>
	 <20090106121052.GA27232@elte.hu> <4963584A.4090805@novell.com>
	 <20090106131643.GA15228@elte.hu> <1231248041.11687.107.camel@twins>
	 <49636799.1010109@novell.com> <20090106214229.GD6741@linux.vnet.ibm.com>
	 <1231278275.11687.111.camel@twins>
	 <alpine.LFD.2.00.0901061349520.3057@localhost.localdomain>
	 <1231279660.11687.121.camel@twins>
	 <alpine.LFD.2.00.0901061413310.3057@localhost.localdomain>
	 <1231281801.11687.125.camel@twins> <1231283778.11687.136.camel@twins>
	 <1231329783.11687.287.camel@twins>
	 <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
	Gregory Haskins <ghaskins@novell.com>,
	Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2009-01-07 at 08:25 -0800, Linus Torvalds wrote:
> 
> On Wed, 7 Jan 2009, Peter Zijlstra wrote:
> >
> > Change mutex contention behaviour such that it will sometimes busy wait on
> > acquisition - moving its behaviour closer to that of spinlocks.
> 
> Ok, this one looks _almost_ ok.
> 
> The only problem is that I think you've lost the UP case. 
> 
> In UP, you shouldn't have the code to spin, and the "spin_or_schedule()" 
> should fall back to just the schedule case.
> 
> It migth also be worthwhile to try to not set the owner, and re-organize 
> that a bit (by making it a inline function that sets the owner only for 
> CONFIG_SMP or lockdep/debug). 

So far I haven't found any btrfs benchmarks where this is slower than
mutexes without any spinning.  But, it isn't quite as fast as the btrfs
spin.

I'm using three different benchmarks, and they hammer on different
things.  All against btrfs and a single sata drive.

* dbench -t 30 50, which means run dbench 50 for 30 seconds.   It is a
broad workload that hammers on lots of code, but it also tends to go
faster when things are less fair.  These numbers are stable across runs.
Some IO is done at the very start of the run, but the bulk of the run is
CPU bound in various btrfs btrees.

Plain mutex: dbench reports 240MB/s
Simple spin: dbench reports 560MB/s
Peter's v4: dbench reports 388MB/s

* 50 procs creating 10,000 files (4k each), one dir per proc.  The
result is 50 dirs and each dir has 10,000 files.  This is mostly CPU
bound for the procs, but pdflush and friends are doing lots of IO.

Plain mutex: avg: 115 files/s avg system time for each proc: 1.6s
Simple spin: avg: 152 files/s avg system time for each proc: 2s
Peter's v4:  avg: 130 files/s avg system time for each proc: 2.9s

I would have expected Peter's patch to use less system time than my
spin.  If I change his patch to limit the spin to 512 iterations (same
as my code), the system time goes back down to 1.7s, but the files/s
doesn't improve.

* Parallel stat:  the last benchmark is the most interesting, since it
really hammers on the btree locking speed.  I take the directory tree
the file creation run (50 dirs, 10,000 files each) and have 50 procs
running stat on all the files in parallel.

Before the run I clear the inode cache but leave the page cache.  So,
everything is hot in the btree but there are no inodes in cache.

Plain mutex: 9.488s real, 8.6 sys
Simple spin: 3.8s real 13.8s sys
Peter's v4: 7.9s real 8.5s sys

-chris



