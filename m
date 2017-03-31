Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35671 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933050AbdCaLYZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Mar 2017 07:24:25 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 2/4 V2] btrfs: use blkdev_issue_flush to flush the device cache
Date: Fri, 31 Mar 2017 19:29:12 +0800
Message-Id: <20170331112912.32674-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As of now we do alloc an empty bio and then use the flag REQ_PREFLUSH
to flush the device cache, instead we can use blkdev_issue_flush()
for this puspose.

Also now no need to check the return when write_dev_flush() is called
with wait = 0

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
V2
  Title of this patch is changed from
   btrfs: communicate back ENOMEM when it occurs
  And its entirely a new patch, which now use blkdev_issue_flush()

 fs/btrfs/disk-io.c | 64 +++++++++++++++---------------------------------------
 fs/btrfs/volumes.h |  3 ++-
 2 files changed, 19 insertions(+), 48 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 9de35bca1f67..42bcf98794ec 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3498,67 +3498,39 @@ static int write_dev_supers(struct btrfs_device *device,
 	return errors < i ? 0 : -1;
 }
 
-/*
- * endio for the write_dev_flush, this will wake anyone waiting
- * for the barrier when it is done
- */
-static void btrfs_end_empty_barrier(struct bio *bio)
+static void btrfs_dev_issue_flush(struct work_struct *work)
 {
-	if (bio->bi_private)
-		complete(bio->bi_private);
-	bio_put(bio);
+	int ret;
+	struct btrfs_device *device;
+
+	device = container_of(work, struct btrfs_device, flush_work);
+
+	/* we are in the commit thread */
+	ret = blkdev_issue_flush(device->bdev, GFP_NOFS, NULL);
+	device->last_flush_error = ret;
+	complete(&device->flush_wait);
 }
 
 /*
  * trigger flushes for one the devices.  If you pass wait == 0, the flushes are
  * sent down.  With wait == 1, it waits for the previous flush.
- *
- * any device where the flush fails with eopnotsupp are flagged as not-barrier
- * capable
  */
 static int write_dev_flush(struct btrfs_device *device, int wait)
 {
-	struct bio *bio;
-	int ret = 0;
-
 	if (wait) {
-		bio = device->flush_bio;
-		if (!bio)
-			return 0;
+		int ret;
 
 		wait_for_completion(&device->flush_wait);
-
-		if (bio->bi_error) {
-			ret = bio->bi_error;
+		ret = device->last_flush_error;
+		if (ret)
 			btrfs_dev_stat_inc_and_print(device,
-				BTRFS_DEV_STAT_FLUSH_ERRS);
-		}
-
-		/* drop the reference from the wait == 0 run */
-		bio_put(bio);
-		device->flush_bio = NULL;
-
+					BTRFS_DEV_STAT_FLUSH_ERRS);
 		return ret;
 	}
 
-	/*
-	 * one reference for us, and we leave it for the
-	 * caller
-	 */
-	device->flush_bio = NULL;
-	bio = btrfs_io_bio_alloc(GFP_NOFS, 0);
-	if (!bio)
-		return -ENOMEM;
-
-	bio->bi_end_io = btrfs_end_empty_barrier;
-	bio->bi_bdev = device->bdev;
-	bio->bi_opf = REQ_OP_WRITE | REQ_PREFLUSH;
 	init_completion(&device->flush_wait);
-	bio->bi_private = &device->flush_wait;
-	device->flush_bio = bio;
-
-	bio_get(bio);
-	btrfsic_submit_bio(bio);
+	INIT_WORK(&device->flush_work, btrfs_dev_issue_flush);
+	schedule_work(&device->flush_work);
 
 	return 0;
 }
@@ -3587,9 +3559,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 		if (!dev->in_fs_metadata || !dev->writeable)
 			continue;
 
-		ret = write_dev_flush(dev, 0);
-		if (ret)
-			errors_send++;
+		write_dev_flush(dev, 0);
 	}
 
 	/* wait for all the barriers */
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index fa0b79422695..1168b78c5f1d 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -123,8 +123,9 @@ struct btrfs_device {
 	struct list_head resized_list;
 
 	/* for sending down flush barriers */
-	struct bio *flush_bio;
 	struct completion flush_wait;
+	struct work_struct flush_work;
+	int last_flush_error;
 
 	/* per-device scrub information */
 	struct scrub_ctx *scrub_device;
-- 
2.10.0

