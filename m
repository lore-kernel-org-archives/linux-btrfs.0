From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [RFC] [PATCH] Btrfs: improve fsync/osync write performance
Date: Thu, 02 Apr 2009 11:02:28 +0900
Message-ID: <6.0.0.20.2.20090401105730.06cf23c0@172.19.0.2>
References: <6.0.0.20.2.20090331115027.05879e88@172.19.0.2>
 <1238498851.6431.6.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1238498851.6431.6.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>


At 20:27 09/03/31, Chris Mason wrote:
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
>> Btrfs's write I/O is issued via kernel thread, not via user application context
>> that calls fsync(). While waiting for page writeback, wait_on_page_writeback() 
>> can not unplug I/O sometimes on Btrfs because submit_bio is not called from 
>> user application context so when submit_bio is called from kernel thread, 
>> wait_on_page_writeback() sleeps on io_schedule(). 
>> 
>
>This is exactly right, and one of the uglier side effects of the async
>helper kernel threads.  I've been thinking for a while about a clean way
>to fix it.
>
>> I introduced btrfs_wait_on_page_writeback() on following patch, this is 
>replacement 
>> of wait_on_page_writeback() for Btrfs. This does unplug every 1 tick while
>> waiting for page writeback.
>> 
>> I did a performance test using the sysbench.
>> 
>> # sysbench --num-threads=4 --max-requests=10000  --test=fileio --file-num=1 
>> --file-block-size=4K --file-total-size=128M --file-test-mode=rndwr 
>> --file-fsync-freq=5  run
>> 
>> The result was:
>> -2.6.29
>> 
>> Test execution summary:
>>     total time:                          628.1047s
>>     total number of events:              10000
>>     total time taken by event execution: 413.0834
>>     per-request statistics:
>>          min:                            0.0000s
>>          avg:                            0.0413s
>>          max:                            1.9075s
>>          approx.  95 percentile:         0.3712s
>> 
>> Threads fairness:
>>     events (avg/stddev):           2500.0000/29.21
>>     execution time (avg/stddev):   103.2708/4.04
>> 
>> 
>> -2.6.29-patched
>> 
>> Test execution summary:
>>     total time:                          579.8049s
>>     total number of events:              10004
>>     total time taken by event execution: 355.3098
>>     per-request statistics:
>>          min:                            0.0000s
>>          avg:                            0.0355s
>>          max:                            1.7670s
>>          approx.  95 percentile:         0.3154s
>> 
>> Threads fairness:
>>     events (avg/stddev):           2501.0000/8.03
>>     execution time (avg/stddev):   88.8274/1.94
>> 
>> 
>> This patch has some effect for performance improvement. 
>> 
>> I think there are other reasons that should be fixed why fsync() or 
>> write() with O_SYNC flag is slow on Btrfs.
>> 
>
>Very nice.  Could I trouble you to try one more experiment?  The other
>way to fix this is to your WRITE_SYNC instead of WRITE.  Could you
>please hardcode WRITE_SYNC in the btrfs submit_bio paths and benchmark
>that?
>
>It doesn't cover as many cases as your patch, but it might have a lower
>overall impact.


Hi.
I wrote hardcode WRITE_SYNC patch for btrfs submit_bio paths as shown below,
and I did sysbench test.
Later, I will try your unplug patch.

diff -Nrup linux-2.6.29.org/fs/btrfs/disk-io.c linux-2.6.29.btrfs_sync/fs/btrfs/disk-io.c
--- linux-2.6.29.org/fs/btrfs/disk-io.c	2009-03-24 08:12:14.000000000 +0900
+++ linux-2.6.29.btrfs_sync/fs/btrfs/disk-io.c	2009-04-01 16:26:56.000000000 +0900
@@ -2068,7 +2068,7 @@ static int write_dev_supers(struct btrfs
 		}
 
 		if (i == last_barrier && do_barriers && device->barriers) {
-			ret = submit_bh(WRITE_BARRIER, bh);
+			ret = submit_bh(WRITE_BARRIER|WRITE_SYNC, bh);
 			if (ret == -EOPNOTSUPP) {
 				printk("btrfs: disabling barriers on dev %s\n",
 				       device->name);
@@ -2076,10 +2076,10 @@ static int write_dev_supers(struct btrfs
 				device->barriers = 0;
 				get_bh(bh);
 				lock_buffer(bh);
-				ret = submit_bh(WRITE, bh);
+				ret = submit_bh(WRITE_SYNC, bh);
 			}
 		} else {
-			ret = submit_bh(WRITE, bh);
+			ret = submit_bh(WRITE_SYNC, bh);
 		}
 
 		if (!ret && wait) {
diff -Nrup linux-2.6.29.org/fs/btrfs/extent_io.c linux-2.6.29.btrfs_sync/fs/btrfs/extent_io.c
--- linux-2.6.29.org/fs/btrfs/extent_io.c	2009-03-24 08:12:14.000000000 +0900
+++ linux-2.6.29.btrfs_sync/fs/btrfs/extent_io.c	2009-04-01 14:48:08.000000000 +0900
@@ -1851,8 +1851,11 @@ static int submit_one_bio(int rw, struct
 	if (tree->ops && tree->ops->submit_bio_hook)
 		tree->ops->submit_bio_hook(page->mapping->host, rw, bio,
 					   mirror_num, bio_flags);
-	else
+	else {
+		if (rw & WRITE)
+			rw = WRITE_SYNC;
 		submit_bio(rw, bio);
+	}
 	if (bio_flagged(bio, BIO_EOPNOTSUPP))
 		ret = -EOPNOTSUPP;
 	bio_put(bio);
diff -Nrup linux-2.6.29.org/fs/btrfs/volumes.c linux-2.6.29.btrfs_sync/fs/btrfs/volumes.c
--- linux-2.6.29.org/fs/btrfs/volumes.c	2009-03-24 08:12:14.000000000 +0900
+++ linux-2.6.29.btrfs_sync/fs/btrfs/volumes.c	2009-04-01 16:25:51.000000000 +0900
@@ -195,6 +195,8 @@ loop_lock:
 
 		BUG_ON(atomic_read(&cur->bi_cnt) == 0);
 		bio_get(cur);
+		if (cur->bi_rw & WRITE)
+			cur->bi_rw = WRITE_SYNC;
 		submit_bio(cur->bi_rw, cur);
 		bio_put(cur);
 		num_run++;
@@ -2815,8 +2817,11 @@ int btrfs_map_bio(struct btrfs_root *roo
 			bio->bi_bdev = dev->bdev;
 			if (async_submit)
 				schedule_bio(root, dev, rw, bio);
-			else
+			else {
+				if (rw & WRITE)
+					rw = WRITE_SYNC;
 				submit_bio(rw, bio);
+			}
 		} else {
 			bio->bi_bdev = root->fs_info->fs_devices->latest_bdev;
 			bio->bi_sector = logical >> 9;


 # sysbench --num-threads=4 --max-requests=10000  --test=fileio --file-num=1 
 --file-block-size=4K --file-total-size=128M --file-test-mode=rndwr 
 --file-fsync-freq=5  run

The result was:

-2.6.29
Test execution summary:
    total time:                          619.6822s
    total number of events:              10003
    total time taken by event execution: 403.1020
    per-request statistics:
         min:                            0.0000s
         avg:                            0.0403s
         max:                            1.4584s
         approx.  95 percentile:         0.3761s

Threads fairness:
    events (avg/stddev):           2500.7500/48.48
    execution time (avg/stddev):   100.7755/7.92


-2.6.29-WRITE_SYNC-patched

Test execution summary:
    total time:                          596.8114s
    total number of events:              10004
    total time taken by event execution: 396.2378
    per-request statistics:
         min:                            0.0000s
         avg:                            0.0396s
         max:                            1.6926s
         approx.  95 percentile:         0.3434s

Threads fairness:
    events (avg/stddev):           2501.0000/58.28
    execution time (avg/stddev):   99.0595/2.84


