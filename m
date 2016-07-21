Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44654 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbcGVHSg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jul 2016 03:18:36 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] btrfs: do not background blkdev_put()
Date: Fri, 22 Jul 2016 06:04:53 +0800
Message-Id: <1469138693-810-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

At the end of unmount/dev-delete, if the device exclusive open is not
actually closed, then there might be a race with another program in
the userland who is trying to open the device in exclusive mode and
it may fail for eg:
      unmount /btrfs; fsck /dev/x
      btrfs dev del /dev/x /btrfs; fsck /dev/x
so here background blkdev_put() is not a choice

---
This patch depends on the patch 2/2 as below,
  [PATCH 1/2] btrfs: reorg btrfs_close_one_device()
  [PATCH v3 2/2] btrfs: make sure device is synced before return

RFC->PATCH:
 Collage sync and put to a function and use it

 fs/btrfs/volumes.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f741ade130a4..1ce584893d1b 100644
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
@@ -852,6 +848,17 @@ static void free_device(struct rcu_head *head)
 	schedule_work(&device->rcu_work);
 }
 
+static void btrfs_close_bdev(struct btrfs_device *device)
+{
+	if (device->bdev && device->writeable) {
+		sync_blockdev(device->bdev);
+		invalidate_bdev(device->bdev);
+	}
+
+	if (device->bdev)
+		blkdev_put(device->bdev, device->mode);
+}
+
 static void btrfs_close_one_device(struct btrfs_device *device)
 {
 	struct btrfs_fs_devices *fs_devices = device->fs_devices;
@@ -870,10 +877,7 @@ static void btrfs_close_one_device(struct btrfs_device *device)
 	if (device->missing)
 		fs_devices->missing_devices--;
 
-	if (device->bdev && device->writeable) {
-		sync_blockdev(device->bdev);
-		invalidate_bdev(device->bdev);
-	}
+	btrfs_close_bdev(device);
 
 	new_device = btrfs_alloc_device(NULL, &device->devid,
 					device->uuid);
@@ -1932,6 +1936,8 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path, u64 devid)
 		btrfs_sysfs_rm_device_link(root->fs_info->fs_devices, device);
 	}
 
+	btrfs_close_bdev(device);
+
 	call_rcu(&device->rcu, free_device);
 
 	num_devices = btrfs_super_num_devices(root->fs_info->super_copy) - 1;
@@ -2025,6 +2031,9 @@ void btrfs_rm_dev_replace_free_srcdev(struct btrfs_fs_info *fs_info,
 		/* zero out the old super if it is writable */
 		btrfs_scratch_superblocks(srcdev->bdev, srcdev->name->str);
 	}
+
+	btrfs_close_bdev(srcdev);
+
 	call_rcu(&srcdev->rcu, free_device);
 
 	/*
@@ -2080,6 +2089,8 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	 * the device_list_mutex lock.
 	 */
 	btrfs_scratch_superblocks(tgtdev->bdev, tgtdev->name->str);
+
+	btrfs_close_bdev(tgtdev);
 	call_rcu(&tgtdev->rcu, free_device);
 }
 
-- 
2.7.0

