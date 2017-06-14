Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20935 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750770AbdFNKGW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Jun 2017 06:06:22 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 3/3 v2.2] btrfs: wait part of the write_dev_flush() can be separated out
Date: Wed, 14 Jun 2017 18:12:30 +0800
Message-Id: <1497435150-961-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1497346349-1194-1-git-send-email-anand.jain@oracle.com>
References: <1497346349-1194-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Submit and wait parts of write_dev_flush() can be split into two
separate functions for better readability.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2.2: Make it conflict free patch on top of
       [PATCH] btrfs: test for device flush-able should be after wait code
      There is no other changes. Sorry for another version. Thxs.
v2.1: Part of commit log got missed out during send. fix it.
v2: . Add the removal of submit_flush_error in check_barrier_error()
    from 2/2 before to 1/3 here, as its appropriate to be here.
    . Did not split the write and wait part here in this patch.

 fs/btrfs/disk-io.c | 60 ++++++++++++++++++++++++++++--------------------------
 1 file changed, 31 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 42bb674028f6..9b9375469134 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3488,39 +3488,17 @@ static void btrfs_end_empty_barrier(struct bio *bio)
 }
 
 /*
- * trigger flushes for one the devices.  If you pass wait == 0, the flushes are
- * sent down.  With wait == 1, it waits for the previous flush.
- *
- * any device where the flush fails with eopnotsupp are flagged as not-barrier
- * capable
+ * Submit a flush request to the device if it supports it. Error handling is
+ * done in the waiting counterpart.
  */
-static int write_dev_flush(struct btrfs_device *device, int wait)
+static void write_dev_flush(struct btrfs_device *device)
 {
 	struct request_queue *devq;
 	struct bio *bio;
-	int ret = 0;
-
-	if (wait) {
-		bio = device->flush_bio;
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
 
 	devq = bdev_get_queue(device->bdev);
 	if (!test_bit(QUEUE_FLAG_WC, &devq->queue_flags))
-		return 0;
+		return;
 
 	/*
 	 * one reference for us, and we leave it for the
@@ -3537,8 +3515,32 @@ static int write_dev_flush(struct btrfs_device *device, int wait)
 
 	bio_get(bio);
 	btrfsic_submit_bio(bio);
+}
 
-	return 0;
+/*
+ * If the flush bio has been submitted by write_dev_flush, wait for it.
+ */
+static int wait_dev_flush(struct btrfs_device *device)
+{
+	int ret = 0;
+	struct bio *bio = device->flush_bio;
+
+	if (!bio)
+		return 0;
+
+	wait_for_completion(&device->flush_wait);
+
+	if (bio->bi_error) {
+		ret = bio->bi_error;
+		btrfs_dev_stat_inc_and_print(device,
+				BTRFS_DEV_STAT_FLUSH_ERRS);
+	}
+
+	/* drop the reference from the wait == 0 run */
+	bio_put(bio);
+	device->flush_bio = NULL;
+
+	return ret;
 }
 
 static int check_barrier_error(struct btrfs_fs_devices *fsdevs)
@@ -3579,7 +3581,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 		if (!dev->in_fs_metadata || !dev->writeable)
 			continue;
 
-		write_dev_flush(dev, 0);
+		write_dev_flush(dev);
 		dev->last_flush_error = 0;
 	}
 
@@ -3594,7 +3596,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 		if (!dev->in_fs_metadata || !dev->writeable)
 			continue;
 
-		ret = write_dev_flush(dev, 1);
+		ret = wait_dev_flush(dev);
 		if (ret) {
 			dev->last_flush_error = ret;
 			errors_wait++;
-- 
2.7.0

