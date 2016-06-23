Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40265 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbcFWNBL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 09:01:11 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH RFC] don't background blkdev_put()
Date: Thu, 23 Jun 2016 21:01:53 +0800
Message-Id: <1466686913-7832-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As of now we are calling blkdev_put() under call_rcu,
actually which isn't necessary. Unless I am missing
something. This is a try out patch to know the same.

Ran successfully the fstests.

This should be applied on top of recent other patches,
  [PATCH 1/2] btrfs: reorg btrfs_close_one_device()
  [PATCH v3 2/2] btrfs: make sure device is synced before return

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e0ad29d6fe9a..63036702ea18 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -834,10 +834,6 @@ static void __free_device(struct work_struct *work)
 	struct btrfs_device *device;
 
 	device = container_of(work, struct btrfs_device, rcu_work);
-
-	if (device->bdev)
-		blkdev_put(device->bdev, device->mode);
-
 	rcu_string_free(device->name);
 	kfree(device);
 }
@@ -874,6 +870,8 @@ static void btrfs_close_one_device(struct btrfs_device *device)
 		sync_blockdev(device->bdev);
 		invalidate_bdev(device->bdev);
 	}
+	if (device->bdev)
+		blkdev_put(device->bdev, device->mode);
 
 	new_device = btrfs_alloc_device(NULL, &device->devid,
 					device->uuid);
@@ -1931,6 +1929,13 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path, u64 devid)
 		btrfs_sysfs_rm_device_link(root->fs_info->fs_devices, device);
 	}
 
+	if (device->bdev && device->writeable) {
+		sync_blockdev(device->bdev);
+		invalidate_bdev(device->bdev);
+	}
+	if (device->bdev)
+		blkdev_put(device->bdev, device->mode);
+
 	call_rcu(&device->rcu, free_device);
 
 	num_devices = btrfs_super_num_devices(root->fs_info->super_copy) - 1;
@@ -2024,6 +2029,13 @@ void btrfs_rm_dev_replace_free_srcdev(struct btrfs_fs_info *fs_info,
 		/* zero out the old super if it is writable */
 		btrfs_scratch_superblocks(srcdev->bdev, srcdev->name->str);
 	}
+
+	if (srcdev->bdev && srcdev->writeable) {
+		sync_blockdev(srcdev->bdev);
+		invalidate_bdev(srcdev->bdev);
+	}
+	if (srcdev->bdev)
+		blkdev_put(srcdev->bdev, srcdev->mode);
 	call_rcu(&srcdev->rcu, free_device);
 
 	/*
@@ -2079,6 +2091,12 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	 * the device_list_mutex lock.
 	 */
 	btrfs_scratch_superblocks(tgtdev->bdev, tgtdev->name->str);
+	if (tgtdev->bdev && tgtdev->writeable) {
+		sync_blockdev(tgtdev->bdev);
+		invalidate_bdev(tgtdev->bdev);
+	}
+	if (tgtdev->bdev)
+		blkdev_put(tgtdev->bdev, tgtdev->mode);
 	call_rcu(&tgtdev->rcu, free_device);
 }
 
-- 
2.7.0

