Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56908 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751818AbdFOQuk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Jun 2017 12:50:40 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 54DC0AC29
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Jun 2017 16:50:34 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 4/5] btrfs: add fs flag to force device flushing
Date: Thu, 15 Jun 2017 18:49:29 +0200
Message-Id: <8c201990ae0acb3b80437f9de2e432b60ecf8e4a.1497544265.git.dsterba@suse.com>
In-Reply-To: <cover.1497544265.git.dsterba@suse.com>
References: <cover.1497544265.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We need a device capable of device barriers so we can test the flush
code. To aid testing, add a per-filesystem status flag that affects the
barriers regerdless of the device capabilities and obviously does not
give the same guarantees.

It's off by default, sysfs tunable will follow.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h   | 1 +
 fs/btrfs/disk-io.c | 8 +++++---
 fs/btrfs/volumes.h | 1 +
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f0f5f28784b6..dcf4404f7d61 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -716,6 +716,7 @@ struct btrfs_delayed_root;
 #define BTRFS_FS_LOG1_ERR			12
 #define BTRFS_FS_LOG2_ERR			13
 #define BTRFS_FS_QUOTA_OVERRIDE			14
+#define BTRFS_FS_FORCE_DEV_FLUSH		15
 
 /*
  * Indicate that a whole-filesystem exclusive operation is running
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 59a732a13370..659a3b4645d2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3494,7 +3494,8 @@ static void write_dev_flush(struct btrfs_device *device)
 	struct request_queue *q = bdev_get_queue(device->bdev);
 	struct bio *bio = device->flush_bio;
 
-	if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags))
+	if (!test_bit(BTRFS_FS_FORCE_DEV_FLUSH, &device->fs_info->flags)
+	    && !test_bit(QUEUE_FLAG_WC, &q->queue_flags))
 		return;
 
 	bio_reset(bio);
@@ -3505,6 +3506,7 @@ static void write_dev_flush(struct btrfs_device *device)
 	bio->bi_private = &device->flush_wait;
 
 	submit_bio(bio);
+	device->flush_bio_sent = 1;
 }
 
 /*
@@ -3512,12 +3514,12 @@ static void write_dev_flush(struct btrfs_device *device)
  */
 static int wait_dev_flush(struct btrfs_device *device)
 {
-	struct request_queue *q = bdev_get_queue(device->bdev);
 	struct bio *bio = device->flush_bio;
 
-	if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags))
+	if (!device->flush_bio_sent)
 		return 0;
 
+	device->flush_bio_sent = 0;
 	wait_for_completion_io(&device->flush_wait);
 
 	return bio->bi_error;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 35327efecdbb..6f45fd60d15a 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -75,6 +75,7 @@ struct btrfs_device {
 	int can_discard;
 	int is_tgtdev_for_dev_replace;
 	int last_flush_error;
+	int flush_bio_sent;
 
 #ifdef __BTRFS_NEED_DEVICE_DATA_ORDERED
 	seqcount_t data_seqcount;
-- 
2.13.0

