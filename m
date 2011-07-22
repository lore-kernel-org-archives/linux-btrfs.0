From: Chris Mason <chris.mason@oracle.com>
Subject: Re: rw_semaphore performance, was: new metadata reader/writer locks in integration-test
Date: Fri, 22 Jul 2011 11:14:09 -0400
Message-ID: <1311347135-sup-4912@shiny>
References: <1311096438-sup-1263@shiny> <20110722150151.GA23686@infradead.org>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	david <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20110722150151.GA23686@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Christoph Hellwig's message of 2011-07-22 11:01:51 -0400:
> On Tue, Jul 19, 2011 at 01:30:22PM -0400, Chris Mason wrote:
> > We've seen a number of benchmarks dominated by contention on the root
> > node lock.  This changes our locks into a simple reader/writer lock.
> > They are based on mutexes so that we still take advantage of the mutex
> > adaptive spins for write locks (rwsemaphores were much slower).
> 
> Interesting.  Do you have set up some artifical benchmarks for this?
> 
> I wonder if the lack of adaptive spinning has something to do with the
> slightly slower XFS performance on Joern's flash testing, given that
> we extensively use the rw_semaphore as the primary I/O mutex, while
> all others rely on plain mutexes as the primary synchronization
> primitive.

For the rw locks I had three main tests.

1) dbench 10.  This is interesting only because it is mostly bound by how
quickly we can do metadata operations in ram.  There's not much IO and
there's a good mixture of read and write btree operations (about 50/50).
rwsemaphores ran at 200MB/s while my current code runs at 2400MB/s.

The old btrfs implementation runs at 3000MB/s.  We all love and hate
dbench, so I don't put a huge amount of stock in 2400 vs 3000.  But, 200
vs 2400...people notice that in real world stuff.

2) fs_mark doing parallel zero byte file creates.  No fsyncs here, all
metadata operations.  The old btrfs locking was completely bound by
getting write locks on the root node.  The new code is much better here,
overall about 30-50% faster.  I didn't do the rw semaphores on this one,
I'll give it a shot.

3) A stat-hammer program.  This creates a bunch of files in parallel,
and then times how long it takes us to stat all the inodes.  I went from
3s of CPU time down to .9s.  rwsems were about the same here (very
fast), but that's because it's 100% reader locks.

My money for Joern's benchmarks is end-io latencies.  xfs and btrfs are
doing more at endio time.  But I need to sit down and run them myself
and take a look.

-chris
