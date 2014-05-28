Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39763 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116AbaE1Inb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 May 2014 04:43:31 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s4S8hU50003327
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 28 May 2014 08:43:30 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id s4S8hTZG018199
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 28 May 2014 08:43:29 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id s4S8hMFu017839
	for <linux-btrfs@vger.kernel.org>; Wed, 28 May 2014 08:43:28 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/1] btrfs: use btrfs_scratch_super function to zero super
Date: Wed, 28 May 2014 16:46:19 +0800
Message-Id: <1401266779-5858-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
 fs/btrfs/volumes.c |   51 +++++++--------------------------------------------
 fs/btrfs/volumes.h |    2 +-
 2 files changed, 8 insertions(+), 45 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index db211fd..7b4f273 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1680,45 +1680,8 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	 * at this point, the device is zero sized.  We want to
 	 * remove it from the devices list and zero out the old super
 	 */
-	if (clear_super && disk_super) {
-		u64 bytenr;
-		int i;
-
-		/* make sure this device isn't detected as part of
-		 * the FS anymore
-		 */
-		memset(&disk_super->magic, 0, sizeof(disk_super->magic));
-		set_buffer_dirty(bh);
-		sync_dirty_buffer(bh);
-
-		/* clear the mirror copies of super block on the disk
-		 * being removed, 0th copy is been taken care above and
-		 * the below would take of the rest
-		 */
-		for (i = 1; i < BTRFS_SUPER_MIRROR_MAX; i++) {
-			bytenr = btrfs_sb_offset(i);
-			if (bytenr + BTRFS_SUPER_INFO_SIZE >=
-					i_size_read(bdev->bd_inode))
-				break;
-
-			brelse(bh);
-			bh = __bread(bdev, bytenr / 4096,
-					BTRFS_SUPER_INFO_SIZE);
-			if (!bh)
-				continue;
-
-			disk_super = (struct btrfs_super_block *)bh->b_data;
-
-			if (btrfs_super_bytenr(disk_super) != bytenr ||
-				btrfs_super_magic(disk_super) != BTRFS_MAGIC) {
-				continue;
-			}
-			memset(&disk_super->magic, 0,
-						sizeof(disk_super->magic));
-			set_buffer_dirty(bh);
-			sync_dirty_buffer(bh);
-		}
-	}
+	if (clear_super && disk_super)
+		btrfs_scratch_superblock(bdev);
 
 	ret = 0;
 
@@ -1762,7 +1725,7 @@ void btrfs_rm_dev_replace_srcdev(struct btrfs_fs_info *fs_info,
 		fs_info->fs_devices->open_devices--;
 
 		/* zero out the old super */
-		btrfs_scratch_superblock(srcdev);
+		btrfs_scratch_superblock(srcdev->bdev);
 	}
 
 	call_rcu(&srcdev->rcu, free_device);
@@ -1776,7 +1739,7 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	WARN_ON(!tgtdev);
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
 	if (tgtdev->bdev) {
-		btrfs_scratch_superblock(tgtdev);
+		btrfs_scratch_superblock(tgtdev->bdev);
 		fs_info->fs_devices->open_devices--;
 	}
 	fs_info->fs_devices->num_devices--;
@@ -6311,7 +6274,7 @@ int btrfs_get_dev_stats(struct btrfs_root *root,
 	return 0;
 }
 
-int btrfs_scratch_superblock(struct btrfs_device *device)
+int btrfs_scratch_superblock(struct block_device *bdev)
 {
 	struct buffer_head *bh;
 	struct btrfs_super_block *disk_super;
@@ -6321,10 +6284,10 @@ int btrfs_scratch_superblock(struct btrfs_device *device)
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		bytenr = btrfs_sb_offset(i);
 		if (bytenr + BTRFS_SUPER_INFO_SIZE >=
-				i_size_read(device->bdev->bd_inode))
+				i_size_read(bdev->bd_inode))
 			break;
 
-		bh = __bread(device->bdev, bytenr / 4096,
+		bh = __bread(bdev, bytenr / 4096,
 					BTRFS_SUPER_INFO_SIZE);
 		if (!bh)
 			continue;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 4ca67b3..25f0505 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -357,7 +357,7 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 				      struct btrfs_device *tgtdev);
 void btrfs_init_dev_replace_tgtdev_for_resume(struct btrfs_fs_info *fs_info,
 					      struct btrfs_device *tgtdev);
-int btrfs_scratch_superblock(struct btrfs_device *device);
+int btrfs_scratch_superblock(struct block_device *bdev);
 int btrfs_is_parity_mirror(struct btrfs_mapping_tree *map_tree,
 			   u64 logical, u64 len, int mirror_num);
 unsigned long btrfs_full_stripe_len(struct btrfs_root *root,
-- 
1.7.1

