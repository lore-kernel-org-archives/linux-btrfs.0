From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [RFC] [PATCH] Btrfs: improve fsync/osync write performance
Date: Thu, 02 Apr 2009 15:25:26 +0900
Message-ID: <6.0.0.20.2.20090402112809.06d828e0@172.19.0.2>
References: <6.0.0.20.2.20090331115027.05879e88@172.19.0.2>
 <1238599038.18549.39.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1238599038.18549.39.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>


At 00:17 09/04/02, Chris Mason wrote:
>On Tue, 2009-03-31 at 14:18 +0900, Hisashi Hifumi wrote:
>> Hi Chris.
>> 
>> I noticed performance of fsync() and write() with O_SYNC flag on Btrfs is
>> very slow as compared to ext3/4. I used blktrace to try to investigate the 
>> cause of this. One of cause is that unplug is done by kblockd even if the 
>I/O is 
>> issued through fsync() or write() with O_SYNC flag. kblockd's unplug timeout
>> is 3msec, so unplug via blockd can decrease I/O response. To increase 
>> fsync/osync write performance, speeding up unplug should be done here.
>> 
>
>I realized today that all of the async thread handling btrfs does for
>writes gives us plenty of time to queue up IO for the block device.  If
>that's true, we can just unplug the block device in async helper thread
>and get pretty good coverage for the problem you're describing.
>
>Could you please try the patch below and see if it performs well?  I did
>some O_DIRECT testing on a 5 drive array, and tput jumped from 386MB/s
>to 450MB/s for large writes.
>
>Thanks again for digging through this problem.
>
>-chris
>
>diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>index dd06e18..bf377ab 100644
>--- a/fs/btrfs/volumes.c
>+++ b/fs/btrfs/volumes.c
>@@ -146,7 +146,7 @@ static noinline int run_scheduled_bios(struct 
>btrfs_device *device)
> 	unsigned long num_run = 0;
> 	unsigned long limit;
> 
>-	bdi = device->bdev->bd_inode->i_mapping->backing_dev_info;
>+	bdi = blk_get_backing_dev_info(device->bdev);
> 	fs_info = device->dev_root->fs_info;
> 	limit = btrfs_async_submit_limit(fs_info);
> 	limit = limit * 2 / 3;
>@@ -231,6 +231,19 @@ loop_lock:
> 	if (device->pending_bios)
> 		goto loop_lock;
> 	spin_unlock(&device->io_lock);
>+
>+	/*
>+	* IO has already been through a long path to get here.  Checksumming,
>+	* async helper threads, perhaps compression.  We've done a pretty
>+	* good job of collecting a batch of IO and should just unplug
>+	* the device right away.
>+	*
>+	* This will help anyone who is waiting on the IO, they might have
>+	* already unplugged, but managed to do so before the bio they
>+	* cared about found its way down here.
>+	*/
>+	if (bdi->unplug_io_fn)
>+		bdi->unplug_io_fn(bdi, NULL);
> done:
> 	return 0;
> }

I tested your unplug patch.

# sysbench --num-threads=4 --max-requests=10000  --test=fileio --file-num=1 
 --file-block-size=4K --file-total-size=128M --file-test-mode=rndwr 
 --file-fsync-freq=5  run

-2.6.29
Test execution summary:
    total time:                          626.9416s
    total number of events:              10004
    total time taken by event execution: 442.5869
    per-request statistics:
         min:                            0.0000s
         avg:                            0.0442s
         max:                            1.4229s
         approx.  95 percentile:         0.3959s

Threads fairness:
    events (avg/stddev):           2501.0000/73.43
    execution time (avg/stddev):   110.6467/7.15



-2.6.29-patched
Operations performed:  0 Read, 10003 Write, 1996 Other = 11999 Total
Read 0b  Written 39.074Mb  Total transferred 39.074Mb  (68.269Kb/sec)
   17.07 Requests/sec executed

Test execution summary:
    total time:                          586.0944s
    total number of events:              10003
    total time taken by event execution: 347.5348
    per-request statistics:
         min:                            0.0000s
         avg:                            0.0347s
         max:                            2.2546s
         approx.  95 percentile:         0.3090s

Threads fairness:
    events (avg/stddev):           2500.7500/54.98
    execution time (avg/stddev):   86.8837/3.06


We can get some performance improvement by this patch.
What if the case write() without O_SYNC ?
I am concerned about decreasing optimization effect on block layer (merge, sort)
when the I/O is not fsync or write with O_SYNC.


