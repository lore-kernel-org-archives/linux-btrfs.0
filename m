Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34092 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755000AbbHNKdg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 06:33:36 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 09/23] Btrfs: move check for min number of devices to a function
Date: Fri, 14 Aug 2015 18:32:54 +0800
Message-Id: <1439548388-29686-10-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
References: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_rm_device() has a section of the code to check for min number
of the devices required by various group profile. This patch move
that part of the code in the function __check_raid_min_devices()

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 78 ++++++++++++++++++++++++++++++------------------------
 1 file changed, 43 insertions(+), 35 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2f8b974..1573997 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1637,61 +1637,69 @@ out:
 	return ret;
 }
 
-int btrfs_rm_device(struct btrfs_root *root, char *device_path, u64 devid)
+static int __check_raid_min_devices(struct btrfs_fs_info *fs_info)
 {
-	struct btrfs_device *device;
-	struct btrfs_device *next_device;
-	struct block_device *bdev = NULL;
-	struct buffer_head *bh = NULL;
-	struct btrfs_super_block *disk_super = NULL;
-	struct btrfs_fs_devices *cur_devices;
 	u64 all_avail;
 	u64 num_devices;
-	u8 *dev_uuid;
 	unsigned seq;
-	int ret = 0;
-	bool clear_super = false;
-	char *dev_name = NULL;
-
-	mutex_lock(&uuid_mutex);
 
-	do {
-		seq = read_seqbegin(&root->fs_info->profiles_lock);
-
-		all_avail = root->fs_info->avail_data_alloc_bits |
-			    root->fs_info->avail_system_alloc_bits |
-			    root->fs_info->avail_metadata_alloc_bits;
-	} while (read_seqretry(&root->fs_info->profiles_lock, seq));
-
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
+
+	do {
+		seq = read_seqbegin(&fs_info->profiles_lock);
+
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
 
+	return 0;
+}
+
+int btrfs_rm_device(struct btrfs_root *root, char *device_path, u64 devid)
+{
+	struct btrfs_device *device;
+	struct btrfs_device *next_device;
+	struct block_device *bdev = NULL;
+	struct buffer_head *bh = NULL;
+	struct btrfs_super_block *disk_super = NULL;
+	struct btrfs_fs_devices *cur_devices;
+	u64 num_devices;
+	u8 *dev_uuid;
+	int ret = 0;
+	bool clear_super = false;
+	char *dev_name = NULL;
+
+	mutex_lock(&uuid_mutex);
+
+	ret = __check_raid_min_devices(root->fs_info);
+	if (ret)
+		goto out;
+
 	if (devid) {
 		device = btrfs_find_device(root->fs_info, devid,
 				NULL, NULL);
-- 
2.4.1

