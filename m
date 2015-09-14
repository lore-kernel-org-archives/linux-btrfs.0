Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47448 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbbINXyw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Sep 2015 19:54:52 -0400
Date: Tue, 15 Sep 2015 07:54:41 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: Horrible dbench performance
Message-ID: <20150914235441.GA6243@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20150914152820.GA25610@localhost.localdomain>
 <20150914193126.GC11307@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150914193126.GC11307@ret.masoncoding.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 14, 2015 at 03:31:27PM -0400, Chris Mason wrote:
> On Mon, Sep 14, 2015 at 11:28:21PM +0800, Liu Bo wrote:
> > Hi,
> > 
> > Both [1] and [2] had run dbench on btrfs with fast storage, and 
> > showed bad numbers, I got an impression that after refractoring btree lock to
> > smart rwlock, we have mitigated this issue..
> > 
> > Not got a fast-enough ssd handy, does anyone confirm the result showed
> > in those link?
> > 
> > [1]:https://lkml.org/lkml/2015/4/29/793
> > [2]:https://lkml.org/lkml/2015/8/21/22
> > 
> 
> Taking a quick look, its not clear to me which operation the latency
> number corresponds to.  I think the sources are picking the worst
> latency that any of the children see, and since there are a number of
> fsyncs as part of each run, my guess is that our fsync is ending up
> slower than the others.

Yeah, that's right, it picks the worst latency among all children's
running.

The above link [1] showed that btrfs + dbench produces cpu-bound workload
with large number of children.

> 
> If you just run dbench with one writer on my machine, its ~2x faster
> than XFS in tput with half the latency.
> 
> If you go up to 200 writers, xfs cruises along at 1,100MB/s and btrfs is
> pegged at 281MB/s.  All the CPUs are at 100% system time, all hitting
> lock contention on the root of the btree.
> 
> If you create a subvolume for each of the clients, btrfs goes up to
> 3600MB/s and latencies about 3x of XFS.  It runs flat out that way until
> it fills the drive.

Last time we talked about dbench, we also replaced directory with
subvolume and got really nice results.

This result proves that lock contention contributes to most of latency,
doesn't it?

> 
> If someone wants to dive into the latencies, that would be great.  It's
> probably fsync, and it's probably CPU bound because Josef changed things
> around to do inline crcs (which is the right answer imho).

Looks like we still behave the same with the old times on the lock
contention.


Here is my results with a 40G ssd partition (or should I use the whole disk
directly?) , 8G ram and i5-2520M CPU, the scheduler is deadline and
queue_depth is 32.

[boliu@localhost dbench-4.0]$ for i in 8 16 32 64 128; do sudo sh test_dbench.sh ext4 $i | tail -1 ; done                                                                                       
mke2fs 1.42.12 (29-Aug-2014)
Throughput 268.655 MB/sec  8 clients  8 procs  max_latency=29.443 ms
mke2fs 1.42.12 (29-Aug-2014)
Throughput 500.605 MB/sec  16 clients  16 procs  max_latency=32.379 ms
mke2fs 1.42.12 (29-Aug-2014)
Throughput 669.413 MB/sec  32 clients  32 procs  max_latency=2078.969 ms
mke2fs 1.42.12 (29-Aug-2014)
Throughput 685.038 MB/sec  64 clients  64 procs  max_latency=1778.066 ms
mke2fs 1.42.12 (29-Aug-2014)
Throughput 349.329 MB/sec  128 clients  128 procs  max_latency=2595.917 ms

[boliu@localhost dbench-4.0]$ sudo sysctl vm.drop_caches=3 && for i in 8 16 32 64 128; do sudo s h test_dbench.sh xfs $i | tail -1 ; done                                                        
vm.drop_caches = 3
Throughput 390.187 MB/sec  8 clients  8 procs  max_latency=46.202 ms
Throughput 677.981 MB/sec  16 clients  16 procs  max_latency=51.046 ms
Throughput 773.213 MB/sec  32 clients  32 procs  max_latency=2150.677 ms
Throughput 756.338 MB/sec  64 clients  64 procs  max_latency=2664.716 ms
Throughput 227.198 MB/sec  128 clients  128 procs  max_latency=7520.982 ms

[boliu@localhost dbench-4.0]$ sudo sysctl vm.drop_caches=3 && for i in 8 16 32 64 128; do sudo sh test_dbench.sh btrfs $i | tail -1 ; done                                                      
vm.drop_caches = 3
Throughput 292.318 MB/sec  8 clients  8 procs  max_latency=229.759 ms
Throughput 505.097 MB/sec  16 clients  16 procs  max_latency=28.868 ms
Throughput 656.121 MB/sec  32 clients  32 procs  max_latency=2674.770 ms
Throughput 622.782 MB/sec  64 clients  64 procs  max_latency=4312.870 ms
Throughput 289.462 MB/sec  128 clients  128 procs  max_latency=7484.317 ms


Ext4 and xfs also run to the similar long latency, 'perf top' shows
__d_lookup_rcu() is very hot, while for btrfs, _raw_spin_lock(),
btrfs_get_token_XX() and queue_read_lock_slowpath() are the hottest
places.  So on my machine, lock contention is a reason, not just for btrfs.

Thanks,

-liubo
