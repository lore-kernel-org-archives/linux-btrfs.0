From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Updated performance results
Date: Mon, 14 Sep 2009 19:13:03 -0400
Message-ID: <20090914231303.GS8839@think>
References: <20090728202355.GC13940@think>
 <4A6F6951.9020304@austin.ibm.com>
 <20090805203526.GE12524@think>
 <4A7C32A4.9070106@austin.ibm.com>
 <20090807231240.GD3710@think>
 <4A9C0D19.5010108@austin.ibm.com>
 <20090911192955.GB2894@think>
 <4AAAC2B6.8040105@austin.ibm.com>
 <20090914135130.GE8839@think>
 <4AAEB89C.3040100@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Steven Pratt <slpratt@austin.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AAEB89C.3040100@austin.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 14, 2009 at 04:41:48PM -0500, Steven Pratt wrote:
> Chris Mason wrote:
> >On Fri, Sep 11, 2009 at 04:35:50PM -0500, Steven Pratt wrote:
> >>Chris Mason wrote:
> >>>On Mon, Aug 31, 2009 at 12:49:13PM -0500, Steven Pratt wrote:
> >>>>Better late than never. Finally got this finished up.  Mixed bag on
> >>>>this one.  BTRFS lags significantly on single threaded.  Seems
> >>>>unable to keep IO outstanding to the device.  Less that 60% busy on
> >>>>the DM device, compared to 97%+ for all other filesystems.
> >>>>nodatacow helps out, increasing utilization to about 70%, but still
> >>>>trails by a large margin.
> >>>Hi Steve,
> >>>
> >>>Jens Axboe did some profiling on his big test rig and I think we found
> >>>the biggest CPU problems.  The end result is now setting in the master
> >>>branch of the btrfs-unstable repo.
> >>>
> >>>On his boxes, btrfs went from around 400MB/s streaming writes to 1GB/s
> >>>limit, and we're now tied with XFS while using less CPU time.
> >>>
> >>>Hopefully you will see similar results ;)
> >>Hmmm, well no I didn't.  Throughputs at 1 and 128 threads are pretty
> >>much unchanged, although I do see a good CPU savings on the 128
> >>thread case (with cow).  For 16 threads we actually regressed with
> >>cow enabled.
> >>
> >>Results  are here:
> >>
> >>http://btrfs.boxacle.net/repository/raid/large_create_test/write-test/1M_odirect_create.html
> >>
> >>I'll try to look more into this next week.
> >>
> >
> >Hmmm, Jens was benchmarking buffered writes, but he was also testing on
> >his new per-bdi write back code.  If your next run could be buffered
> >instead of O_DIRECT, I'd be curious to see the results.
> >
> Buffered does look a lot better. I don't have a btrfs baseline
> before these latest changes for this exact workload, but these
> results are not bad at all.  With cow, beats just about everything
> except XFS, and with nocow simply screams.  CPU consumption looks
> good as well.  I'll probably give the full set of tests a run
> tonight.

Wow, good news at last ;)  For the oops, try the patch below (I need to
push it out, but I think it'll help).

I'll try to figure out the O_DIRECT problems.


-chris

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 6ea5cd0..ba28742 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -177,7 +177,7 @@ static int try_worker_shutdown(struct btrfs_worker_thread *worker)
 	int freeit = 0;
 
 	spin_lock_irq(&worker->lock);
-	spin_lock_irq(&worker->workers->lock);
+	spin_lock(&worker->workers->lock);
 	if (worker->workers->num_workers > 1 &&
 	    worker->idle &&
 	    !worker->working &&
@@ -188,7 +188,7 @@ static int try_worker_shutdown(struct btrfs_worker_thread *worker)
 		list_del_init(&worker->worker_list);
 		worker->workers->num_workers--;
 	}
-	spin_unlock_irq(&worker->workers->lock);
+	spin_unlock(&worker->workers->lock);
 	spin_unlock_irq(&worker->lock);
 
 	if (freeit)
