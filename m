Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56891 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751818AbdFOQu2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Jun 2017 12:50:28 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6AC3DAB9D
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Jun 2017 16:50:27 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/5] btrfs: preallocate device flush bio
Date: Thu, 15 Jun 2017 18:49:23 +0200
Message-Id: <3d57b2def025d49df83e6e62fd153f40e91a87e4.1497544265.git.dsterba@suse.com>
In-Reply-To: <cover.1497544265.git.dsterba@suse.com>
References: <cover.1497544265.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For devices that support flushing, we allocate a bio, submit, wait for
it and then free it. The bio allocation does not fail so ENOMEM is not a
problem but we still may unnecessarily stress the allocation subsystem.

Instead, we can allocate the device at the same time we allocate the
device and reuse it each time we need to flush the barriers. The bio is
reset before each use. Reference counting is simplified to just device
allocation (get) and freeing (put).

Note for write_dev_flush: we check the queue flush status again as we
can't use the existence of bio as before.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c | 24 ++++++------------------
 fs/btrfs/volumes.c | 12 ++++++++++++
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2b00ebff13f8..27d44d6ab775 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3482,9 +3482,7 @@ static int write_dev_supers(struct btrfs_device *device,
  */
 static void btrfs_end_empty_barrier(struct bio *bio)
 {
-	if (bio->bi_private)
-		complete(bio->bi_private);
-	bio_put(bio);
+	complete(bio->bi_private);
 }
 
 /*
@@ -3494,26 +3492,19 @@ static void btrfs_end_empty_barrier(struct bio *bio)
 static void write_dev_flush(struct btrfs_device *device)
 {
 	struct request_queue *q = bdev_get_queue(device->bdev);
-	struct bio *bio;
+	struct bio *bio = device->flush_bio;
 
 	if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags))
 		return;
 
-	/*
-	 * one reference for us, and we leave it for the
-	 * caller
-	 */
-	device->flush_bio = NULL;
-	bio = btrfs_io_bio_alloc(0);
+	bio_reset(bio);
 	bio->bi_end_io = btrfs_end_empty_barrier;
 	bio->bi_bdev = device->bdev;
 	bio->bi_opf = REQ_OP_WRITE | REQ_SYNC | REQ_PREFLUSH;
 	init_completion(&device->flush_wait);
 	bio->bi_private = &device->flush_wait;
-	device->flush_bio = bio;
 
-	bio_get(bio);
-	btrfsic_submit_bio(bio);
+	submit_bio(bio);
 }
 
 /*
@@ -3522,9 +3513,10 @@ static void write_dev_flush(struct btrfs_device *device)
 static int wait_dev_flush(struct btrfs_device *device)
 {
 	int ret = 0;
+	struct request_queue *q = bdev_get_queue(device->bdev);
 	struct bio *bio = device->flush_bio;
 
-	if (!bio)
+	if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags))
 		return 0;
 
 	wait_for_completion(&device->flush_wait);
@@ -3535,10 +3527,6 @@ static int wait_dev_flush(struct btrfs_device *device)
 				BTRFS_DEV_STAT_FLUSH_ERRS);
 	}
 
-	/* drop the reference from the wait == 0 run */
-	bio_put(bio);
-	device->flush_bio = NULL;
-
 	return ret;
 }
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8bb1f4e5905a..251ae81e4363 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -242,6 +242,17 @@ static struct btrfs_device *__alloc_device(void)
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
 
+	/*
+	 * Preallocate a bio that's always going to be used for flushing device
+	 * barriers and matches the device lifespan
+	 */
+	dev->flush_bio = bio_alloc_bioset(GFP_KERNEL, 0, NULL);
+	if (!dev->flush_bio) {
+		kfree(dev);
+		return ERR_PTR(-ENOMEM);
+	}
+	bio_get(dev->flush_bio);
+
 	INIT_LIST_HEAD(&dev->dev_list);
 	INIT_LIST_HEAD(&dev->dev_alloc_list);
 	INIT_LIST_HEAD(&dev->resized_list);
@@ -838,6 +849,7 @@ static void __free_device(struct work_struct *work)
 
 	device = container_of(work, struct btrfs_device, rcu_work);
 	rcu_string_free(device->name);
+	bio_put(device->flush_bio);
 	kfree(device);
 }
 
-- 
2.13.0

