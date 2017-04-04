Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40459 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753720AbdDDKgp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Apr 2017 06:36:45 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] btrfs: check if the device is flush capable
Date: Tue,  4 Apr 2017 18:41:44 +0800
Message-Id: <20170404104144.9414-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

blkdev_issue_flush() or the empty buffer with the flag REQ_PREFLUSH
will never return BIO_EOPNOTSUPP as of now, however it should rather
or it may in future. So for now the BTRFS to have least affected by
this change at the blk layer, we can check if the device is flush
capable.

In this process, I rename the unused nobarrier member as flushable,
which the below patch made it redundant.

Per commit b25de9d6da49b1a8760a89672283128aa8c78345
   block: remove BIO_EOPNOTSUPP

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v1:
  This patch will replace
  [PATCH] btrfs: delete unused member nobarriers


 fs/btrfs/disk-io.c | 2 +-
 fs/btrfs/volumes.c | 6 ++++++
 fs/btrfs/volumes.h | 2 +-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3c476b118440..6c15f5685d25 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3517,7 +3517,7 @@ static void btrfs_dev_issue_flush(struct work_struct *work)
  */
 static int write_dev_flush(struct btrfs_device *device, int wait)
 {
-	if (device->nobarriers)
+	if (!device->flushable)
 		return 0;
 
 	if (wait) {
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4de5b2d549bd..3c5142d66260 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1010,6 +1010,8 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 			device->can_discard = 1;
 		if (!blk_queue_nonrot(q))
 			fs_devices->rotating = 1;
+		if (test_bit(QUEUE_FLAG_WC, &q->queue_flags))
+			device->flushable = true;
 
 		device->bdev = bdev;
 		device->in_fs_metadata = 0;
@@ -2377,6 +2379,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	q = bdev_get_queue(bdev);
 	if (blk_queue_discard(q))
 		device->can_discard = 1;
+	if (test_bit(QUEUE_FLAG_WC, &q->queue_flags))
+		device->flushable = true;
 	device->writeable = 1;
 	device->generation = trans->transid;
 	device->io_width = fs_info->sectorsize;
@@ -2580,6 +2584,8 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	q = bdev_get_queue(bdev);
 	if (blk_queue_discard(q))
 		device->can_discard = 1;
+	if (test_bit(QUEUE_FLAG_WC, &q->queue_flags))
+		device->flushable = true;
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
 	device->writeable = 1;
 	device->generation = 0;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 0df50bc65578..bbaf5238b6ca 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -123,7 +123,7 @@ struct btrfs_device {
 	struct list_head resized_list;
 
 	/* for sending down flush barriers */
-	int nobarriers;
+	bool flushable;
 	struct completion flush_wait;
 	struct work_struct flush_work;
 	int last_flush_error;
-- 
2.10.0

