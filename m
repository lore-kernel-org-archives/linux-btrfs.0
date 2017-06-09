Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44375 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751515AbdFIGqX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Jun 2017 02:46:23 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 1/2] btrfs: write_dev_flush does not return ENOMEM anymore
Date: Fri,  9 Jun 2017 14:52:28 +0800
Message-Id: <20170609065229.8188-2-anand.jain@oracle.com>
In-Reply-To: <20170609065229.8188-1-anand.jain@oracle.com>
References: <20170609065229.8188-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit
 9035b5dbc576 btrfs: btrfs_io_bio_alloc never fails, skip error handling

removed the -ENOMEM return from write_dev_flush() so no need to
check for the -ENOMEM during send.

This patch also peals write_dev_flush's wait part of the code,
and creates a new function wait_dev_flush().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 84 ++++++++++++++++++------------------------------------
 1 file changed, 28 insertions(+), 56 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 9f2ffe2c6afb..d8151839bb3d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3488,62 +3488,48 @@ static void btrfs_end_empty_barrier(struct bio *bio)
 }
 
 /*
- * trigger flushes for one the devices.  If you pass wait == 0, the flushes are
- * sent down.  With wait == 1, it waits for the previous flush.
- *
- * any device where the flush fails with eopnotsupp are flagged as not-barrier
- * capable
+ * trigger flushes for one the devices.
  */
-static int write_dev_flush(struct btrfs_device *device, int wait)
+static void write_dev_flush(struct btrfs_device *device)
 {
 	struct request_queue *q = bdev_get_queue(device->bdev);
 	struct bio *bio;
-	int ret = 0;
 
 	if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags))
-		return 0;
-
-	if (wait) {
-		bio = device->flush_bio;
-		if (!bio)
-			/*
-			 * This means the alloc has failed with ENOMEM, however
-			 * here we return 0, as its not a device error.
-			 */
-			return 0;
-
-		wait_for_completion(&device->flush_wait);
-
-		if (bio->bi_error) {
-			ret = bio->bi_error;
-			btrfs_dev_stat_inc_and_print(device,
-				BTRFS_DEV_STAT_FLUSH_ERRS);
-		}
-
-		/* drop the reference from the wait == 0 run */
-		bio_put(bio);
-		device->flush_bio = NULL;
-
-		return ret;
-	}
+		return;
 
-	/*
-	 * one reference for us, and we leave it for the
-	 * caller
-	 */
-	device->flush_bio = NULL;
 	bio = btrfs_io_bio_alloc(GFP_NOFS, 0);
 	bio->bi_end_io = btrfs_end_empty_barrier;
 	bio->bi_bdev = device->bdev;
 	bio->bi_opf = REQ_OP_WRITE | REQ_SYNC | REQ_PREFLUSH;
 	init_completion(&device->flush_wait);
 	bio->bi_private = &device->flush_wait;
+
 	device->flush_bio = bio;
 
 	bio_get(bio);
 	btrfsic_submit_bio(bio);
+}
 
-	return 0;
+static int wait_dev_flush(struct btrfs_device *device)
+{
+	int ret;
+	struct bio *bio = device->flush_bio;
+
+	if (!bio)
+		return 0;
+
+	wait_for_completion(&device->flush_wait);
+
+	ret = bio->bi_error;
+	if (ret)
+		btrfs_dev_stat_inc_and_print(device,
+				BTRFS_DEV_STAT_FLUSH_ERRS);
+
+	bio_put(bio);
+	device->flush_bio = NULL;
+
+	return ret;
 }
 
 static int check_barrier_error(struct btrfs_fs_devices *fsdevs)
@@ -3559,9 +3545,7 @@ static int check_barrier_error(struct btrfs_fs_devices *fsdevs)
 			dev_flush_error++;
 			continue;
 		}
-		if (dev->last_flush_error == -ENOMEM)
-			submit_flush_error++;
-		if (dev->last_flush_error && dev->last_flush_error != -ENOMEM)
+		if (dev->last_flush_error)
 			dev_flush_error++;
 	}
 
@@ -3596,10 +3580,8 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 		if (!dev->in_fs_metadata || !dev->writeable)
 			continue;
 
-		ret = write_dev_flush(dev, 0);
-		if (ret)
-			errors_send++;
-		dev->last_flush_error = ret;
+		write_dev_flush(dev);
+		dev->last_flush_error = 0;
 	}
 
 	/* wait for all the barriers */
@@ -3613,23 +3595,13 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 		if (!dev->in_fs_metadata || !dev->writeable)
 			continue;
 
-		ret = write_dev_flush(dev, 1);
+		ret = wait_dev_flush(dev);
 		if (ret) {
 			dev->last_flush_error = ret;
 			errors_wait++;
 		}
 	}
 
-	/*
-	 * Try hard in case of flush. Lets say, in RAID1 we have
-	 * the following situation
-	 *  dev1: EIO dev2: ENOMEM
-	 * this is not a fatal error as we hope to recover from
-	 * ENOMEM in the next attempt to flush.
-	 * But the following is considered as fatal
-	 *  dev1: ENOMEM dev2: ENOMEM
-	 *  dev1: bdev == NULL dev2: ENOMEM
-	 */
 	if (errors_send || errors_wait) {
 		/*
 		 * At some point we need the status of all disks
-- 
2.8.3

