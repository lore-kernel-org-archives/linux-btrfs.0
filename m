Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30270 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbbJFPTk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Oct 2015 11:19:40 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 2/7] Btrfs: clean up and optimize __check_raid_min_device()
Date: Tue,  6 Oct 2015 23:19:19 +0800
Message-Id: <1444144764-2384-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1444144764-2384-1-git-send-email-anand.jain@oracle.com>
References: <1444144764-2384-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

__check_raid_min_device() which was pealed from btrfs_rm_device()
maintianed its original code to show the block move. This patch
cleans up __check_raid_min_device().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 43 +++++++++++++++++++------------------------
 1 file changed, 19 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 6be21ff..35ee3ca 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1629,52 +1629,47 @@ out:
 	return ret;
 }
 
-static int __check_raid_min_devices(struct btrfs_root *root)
+static int __check_raid_min_devices(struct btrfs_fs_info *fs_info)
 {
 	u64 all_avail;
 	u64 num_devices;
 	unsigned seq;
-	int ret = 0;
 
-	num_devices = root->fs_info->fs_devices->num_devices;
-	btrfs_dev_replace_lock(&root->fs_info->dev_replace);
-	if (btrfs_dev_replace_is_ongoing(&root->fs_info->dev_replace)) {
+	num_devices = fs_info->fs_devices->num_devices;
+	btrfs_dev_replace_lock(&fs_info->dev_replace);
+	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
 		WARN_ON(num_devices < 1);
 		num_devices--;
 	}
-	btrfs_dev_replace_unlock(&root->fs_info->dev_replace);
+	btrfs_dev_replace_unlock(&fs_info->dev_replace);
 
 	do {
-		seq = read_seqbegin(&root->fs_info->profiles_lock);
+		seq = read_seqbegin(&fs_info->profiles_lock);
 
-		all_avail = root->fs_info->avail_data_alloc_bits |
-			    root->fs_info->avail_system_alloc_bits |
-			    root->fs_info->avail_metadata_alloc_bits;
-	} while (read_seqretry(&root->fs_info->profiles_lock, seq));
+		all_avail = fs_info->avail_data_alloc_bits |
+			    fs_info->avail_system_alloc_bits |
+			    fs_info->avail_metadata_alloc_bits;
+	} while (read_seqretry(&fs_info->profiles_lock, seq));
 
 	if ((all_avail & BTRFS_BLOCK_GROUP_RAID10) && num_devices <= 4) {
-		ret = BTRFS_ERROR_DEV_RAID10_MIN_NOT_MET;
-		goto out;
+		return BTRFS_ERROR_DEV_RAID10_MIN_NOT_MET;
 	}
 
 	if ((all_avail & BTRFS_BLOCK_GROUP_RAID1) && num_devices <= 2) {
-		ret = BTRFS_ERROR_DEV_RAID1_MIN_NOT_MET;
-		goto out;
+		return BTRFS_ERROR_DEV_RAID1_MIN_NOT_MET;
 	}
 
 	if ((all_avail & BTRFS_BLOCK_GROUP_RAID5) &&
-	    root->fs_info->fs_devices->rw_devices <= 2) {
-		ret = BTRFS_ERROR_DEV_RAID5_MIN_NOT_MET;
-		goto out;
+	    fs_info->fs_devices->rw_devices <= 2) {
+		return BTRFS_ERROR_DEV_RAID5_MIN_NOT_MET;
 	}
+
 	if ((all_avail & BTRFS_BLOCK_GROUP_RAID6) &&
-	    root->fs_info->fs_devices->rw_devices <= 3) {
-		ret = BTRFS_ERROR_DEV_RAID6_MIN_NOT_MET;
-		goto out;
+	    fs_info->fs_devices->rw_devices <= 3) {
+		return BTRFS_ERROR_DEV_RAID6_MIN_NOT_MET;
 	}
 
-out:
-	return ret;
+	return 0;
 }
 
 int btrfs_rm_device(struct btrfs_root *root, char *device_path)
@@ -1693,7 +1688,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 
 	mutex_lock(&uuid_mutex);
 
-	ret = __check_raid_min_devices(root);
+	ret = __check_raid_min_devices(root->fs_info);
 	if (ret)
 		goto out;
 
-- 
2.4.1

