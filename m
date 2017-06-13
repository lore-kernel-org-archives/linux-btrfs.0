Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38052 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752566AbdFMI7e (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Jun 2017 04:59:34 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 3/3 v2] btrfs: wait part of the write_dev_flush() can be separated out
Date: Tue, 13 Jun 2017 17:05:41 +0800
Message-Id: <1497344741-1135-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1497344741-1135-1-git-send-email-anand.jain@oracle.com>
References: <1497344741-1135-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Submit and wait parts of write_dev_flush() can be split into two
separate functions for better readability.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 v2: new in v2

 fs/btrfs/disk-io.c | 60 ++++++++++++++++++++++++++++--------------------------
 1 file changed, 31 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a9f1c48519dd..0d92a7c2f550 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3488,38 +3488,16 @@ static void btrfs_end_empty_barrier(struct bio *bio)
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
 	struct request_queue *q = bdev_get_queue(device->bdev);
 	struct bio *bio;
-	int ret = 0;
 
 	if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags))
-		return 0;
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
+		return;
 
 	/*
 	 * one reference for us, and we leave it for the
@@ -3536,8 +3514,32 @@ static int write_dev_flush(struct btrfs_device *device, int wait)
 
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
@@ -3578,7 +3580,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 		if (!dev->in_fs_metadata || !dev->writeable)
 			continue;
 
-		write_dev_flush(dev, 0);
+		write_dev_flush(dev);
 		dev->last_flush_error = 0;
 	}
 
@@ -3593,7 +3595,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 		if (!dev->in_fs_metadata || !dev->writeable)
 			continue;
 
-		ret = write_dev_flush(dev, 1);
+		ret = wait_dev_flush(dev);
 		if (ret) {
 			dev->last_flush_error = ret;
 			errors_wait++;
-- 
2.7.0

