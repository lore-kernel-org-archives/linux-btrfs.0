Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:20401 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753024AbaGVXj7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jul 2014 19:39:59 -0400
Date: Wed, 23 Jul 2014 09:39:55 +1000
From: Dave Chinner <david@fromorbit.com>
To: Chris Mason <clm@fb.com>
Cc: Morten Stevens <mstevens@fedoraproject.org>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs kernel workqueues performance regression
Message-ID: <20140722233955.GU4453@dastard>
References: <CAKSJeFKteZNUnJmN3dnYaHLnayQhZNNTKX5co_smMqwy1JgQNA@mail.gmail.com>
 <53C5673F.6010702@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53C5673F.6010702@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 15, 2014 at 01:39:11PM -0400, Chris Mason wrote:
> On 07/15/2014 11:26 AM, Morten Stevens wrote:
> > Hi,
> > 
> > I see that btrfs is using kernel workqueues since linux 3.15. After
> > some tests I noticed performance regressions with fs_mark.
> > 
> > mount options: rw,relatime,compress=lzo,space_cache
> > 
> > fs_mark on Kernel 3.14.9:
> > 
> > # fs_mark  -d  /mnt/btrfs/fsmark  -D  512  -t  16  -n  4096  -s  51200  -L5  -S0
> > FSUse%        Count         Size    Files/sec     App Overhead
> >      1        65536        51200      17731.4           723894
> >      1       131072        51200      16832.6           685444
> >      1       196608        51200      19604.5           652294
> >      1       262144        51200      18663.6           630067
> >      1       327680        51200      20112.2           692769
> > 
> > The results are really nice! compress=lzo performs very good.
> > 
> > fs_mark after upgrading to Kernel 3.15.4:
> > 
> > # fs_mark  -d  /mnt/btrfs/fsmark  -D  512  -t  16  -n  4096  -s  51200  -L5  -S0
> > FSUse%        Count         Size    Files/sec     App Overhead
> >      0        65536        51200      10718.1           749540
> >      0       131072        51200       8601.2           853050
> >      0       196608        51200      11623.2           558546
> >      0       262144        51200      11534.2           536342
> >      0       327680        51200      11167.4           578562
> > 
> > That's really a big performance regression :(
> > 
> > What do you think? It's easy to reproduce with fs_mark.
> 
> I wasn't able to trigger regressions here when we first merged it, but I
> was sure that something would pop up.  fs_mark is sensitive to a few
> different factors outside just the worker threads, so it could easily be
> another change as well.
> 
> With 16 threads, the btree locking also has a huge impact, and we've
> made change there too.

FWIW, I ran my usual 16-way fsmark test last week on my sparse 500TB
perf test rig on btrfs. It sucked, big time, much worse than it's
sucked in the past. It didn't scale past a single thread - 1 thread
got 24,000 files/s, 2 threads got 25,000 files/s 16 threads got
22,000 files/s.

$ ./fs_mark  -D  10000  -S0  -n  100000  -s  0  -L  32  -d /mnt/scratch/0
....
FSUse%        Count         Size    Files/sec     App Overhead
     0       100000            0      24808.8           686583
....
$ ./fs_mark  -D  10000  -S0  -n  100000  -s  0  -L  32  -d /mnt/scratch/0  -d  /mnt/scratch/1  -d  /mnt/scratch/2  -d /mnt/scratch/3  -d  /mnt/scratch/4  -d  /mnt/scratch/5  -d /mnt/scratch/6  -d  /mnt/scratch/7  -d  /mnt/scratch/8  -d /mnt/scratch/9  -d  /mnt/scratch/10  -d  /mnt/scratch/11  -d /mnt/scratch/12  -d  /mnt/scratch/13  -d  /mnt/scratch/14  -d /mnt/scratch/15
....
FSUse%        Count         Size    Files/sec     App Overhead
     0      1600000            0      23599.7         38047237

Last time I ran this (probably about 3.12 - btrfs was simply too
broken when I last tried on 3.14) I got about 80,000 files/s so this
is a pretty significant regression.

The 16-way run consumed most of the 16 CPUs in the system, and the
perf top output showed this:

+  44.48%  [kernel]  [k] _raw_spin_unlock_irqrestore
+  28.60%  [kernel]  [k] queue_read_lock_slowpath
+  14.34%  [kernel]  [k] queue_write_lock_slowpath
+   1.91%  [kernel]  [k] _raw_spin_unlock_irq
+   0.85%  [kernel]  [k] __do_softirq
+   0.45%  [kernel]  [k] do_raw_read_lock
+   0.43%  [kernel]  [k] do_raw_read_unlock
+   0.42%  [kernel]  [k] btrfs_search_slot
+   0.40%  [kernel]  [k] do_raw_spin_lock
+   0.35%  [kernel]  [k] btrfs_tree_read_unlock
+   0.33%  [kernel]  [k] do_raw_write_lock
+   0.30%  [kernel]  [k] btrfs_clear_lock_blocking_rw
+   0.29%  [kernel]  [k] btrfs_tree_read_lock

All the CPU time is basically spend in locking functions.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
