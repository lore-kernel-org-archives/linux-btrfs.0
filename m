Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34158 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932121AbbHNKdo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 06:33:44 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 14/23] Btrfs: fix btrfs_scratch_superblock() with fixes from device delete
Date: Fri, 14 Aug 2015 18:32:59 +0800
Message-Id: <1439548388-29686-15-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
References: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch updates the btrfs_scratch_superblock(), (which is used
by the replace device thread), with those fixes from the
scratch superblock code section of btrfs_rm_device(). The fixes are:
  Scratch all copies of superblock
  Notify kobject that superblock has been changed
  Update time on the device

so that btrfs_rm_device() can use the function btrfs_scratch_superblock()
instead of its own scratch code. And further replace deivce code which
similarly releases device back to the system, will have the fixes from
the btrfs device delete.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 40 ++++++++++++++++++++++++++++------------
 fs/btrfs/volumes.h |  2 +-
 2 files changed, 29 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1d35332..b2a19ea 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1915,7 +1915,8 @@ void btrfs_rm_dev_replace_remove_srcdev(struct btrfs_fs_info *fs_info,
 	if (srcdev->writeable) {
 		fs_devices->rw_devices--;
 		/* zero out the old super if it is writable */
-		btrfs_scratch_superblock(srcdev);
+		btrfs_scratch_superblock(srcdev->bdev,
+					rcu_str_deref(srcdev->name));
 	}
 
 	if (srcdev->bdev)
@@ -1965,7 +1966,8 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	btrfs_sysfs_rm_device_link(fs_info->fs_devices, tgtdev);
 
 	if (tgtdev->bdev) {
-		btrfs_scratch_superblock(tgtdev);
+		btrfs_scratch_superblock(tgtdev->bdev,
+					rcu_str_deref(tgtdev->name));
 		fs_info->fs_devices->open_devices--;
 	}
 	fs_info->fs_devices->num_devices--;
@@ -6844,22 +6846,36 @@ int btrfs_get_dev_stats(struct btrfs_root *root,
 	return 0;
 }
 
-int btrfs_scratch_superblock(struct btrfs_device *device)
+void btrfs_scratch_superblock(struct block_device *bdev, char *device_path)
 {
 	struct buffer_head *bh;
 	struct btrfs_super_block *disk_super;
+	int copy_num;
 
-	bh = btrfs_read_dev_super(device->bdev);
-	if (IS_ERR(bh))
-		return PTR_ERR(bh);
-	disk_super = (struct btrfs_super_block *)bh->b_data;
+	if (!bdev)
+		return;
 
-	memset(&disk_super->magic, 0, sizeof(disk_super->magic));
-	set_buffer_dirty(bh);
-	sync_dirty_buffer(bh);
-	brelse(bh);
+	for (copy_num = 0; copy_num < BTRFS_SUPER_MIRROR_MAX;
+		copy_num++) {
 
-	return 0;
+		if (btrfs_read_dev_one_super(bdev, copy_num, &bh))
+			continue;
+
+		disk_super = (struct btrfs_super_block *)bh->b_data;
+
+		memset(&disk_super->magic, 0, sizeof(disk_super->magic));
+		set_buffer_dirty(bh);
+		sync_dirty_buffer(bh);
+		brelse(bh);
+	}
+
+	/* Notify udev that device has changed */
+	btrfs_kobject_uevent(bdev, KOBJ_CHANGE);
+
+	/* Update ctime/mtime for device path for libblkid */
+	update_dev_time(device_path);
+
+	return;
 }
 
 /*
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index a093b36..32a66c7 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -477,7 +477,7 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 				      struct btrfs_device *tgtdev);
 void btrfs_init_dev_replace_tgtdev_for_resume(struct btrfs_fs_info *fs_info,
 					      struct btrfs_device *tgtdev);
-int btrfs_scratch_superblock(struct btrfs_device *device);
+void btrfs_scratch_superblock(struct block_device *bdev, char *device_path);
 int btrfs_is_parity_mirror(struct btrfs_mapping_tree *map_tree,
 			   u64 logical, u64 len, int mirror_num);
 unsigned long btrfs_full_stripe_len(struct btrfs_root *root,
-- 
2.4.1

