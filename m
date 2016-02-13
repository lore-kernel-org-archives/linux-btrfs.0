Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43088 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbcBMCCF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Feb 2016 21:02:05 -0500
From: Anand Jain <anand.jain@oracle.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 06/13] btrfs: create helper function __check_raid_min_devices()
Date: Sat, 13 Feb 2016 10:01:33 +0800
Message-Id: <1455328900-1476-7-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1455328900-1476-1-git-send-email-anand.jain@oracle.com>
References: <1455328900-1476-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

move a section of btrfs_rm_device() code to check for min number of the
devices into the function __check_raid_min_devices()

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2: commit update and title renamed from
    Btrfs: move check for min number of devices to a function
 fs/btrfs/volumes.c | 51 ++++++++++++++++++++++++++++++++-------------------
 1 file changed, 32 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 76133e0..506d1fd 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1703,23 +1703,20 @@ out:
 	return ret;
 }
 
-int btrfs_rm_device(struct btrfs_root *root, char *device_path)
+static int __check_raid_min_devices(struct btrfs_root *root)
 {
-	struct btrfs_device *device;
-	struct btrfs_device *next_device;
-	struct block_device *bdev;
-	struct buffer_head *bh = NULL;
-	struct btrfs_super_block *disk_super;
-	struct btrfs_fs_devices *cur_devices;
 	u64 all_avail;
-	u64 devid;
 	u64 num_devices;
-	u8 *dev_uuid;
 	unsigned seq;
 	int ret = 0;
-	bool clear_super = false;
 
-	mutex_lock(&uuid_mutex);
+	num_devices = root->fs_info->fs_devices->num_devices;
+	btrfs_dev_replace_lock(&root->fs_info->dev_replace);
+	if (btrfs_dev_replace_is_ongoing(&root->fs_info->dev_replace)) {
+		WARN_ON(num_devices < 1);
+		num_devices--;
+	}
+	btrfs_dev_replace_unlock(&root->fs_info->dev_replace);
 
 	do {
 		seq = read_seqbegin(&root->fs_info->profiles_lock);
@@ -1729,14 +1726,6 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 			    root->fs_info->avail_metadata_alloc_bits;
 	} while (read_seqretry(&root->fs_info->profiles_lock, seq));
 
-	num_devices = root->fs_info->fs_devices->num_devices;
-	btrfs_dev_replace_lock(&root->fs_info->dev_replace);
-	if (btrfs_dev_replace_is_ongoing(&root->fs_info->dev_replace)) {
-		WARN_ON(num_devices < 1);
-		num_devices--;
-	}
-	btrfs_dev_replace_unlock(&root->fs_info->dev_replace);
-
 	if ((all_avail & BTRFS_BLOCK_GROUP_RAID10) && num_devices <= 4) {
 		ret = BTRFS_ERROR_DEV_RAID10_MIN_NOT_MET;
 		goto out;
@@ -1758,6 +1747,30 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 		goto out;
 	}
 
+out:
+	return ret;
+}
+
+int btrfs_rm_device(struct btrfs_root *root, char *device_path)
+{
+	struct btrfs_device *device;
+	struct btrfs_device *next_device;
+	struct block_device *bdev;
+	struct buffer_head *bh = NULL;
+	struct btrfs_super_block *disk_super;
+	struct btrfs_fs_devices *cur_devices;
+	u64 devid;
+	u64 num_devices;
+	u8 *dev_uuid;
+	int ret = 0;
+	bool clear_super = false;
+
+	mutex_lock(&uuid_mutex);
+
+	ret = __check_raid_min_devices(root);
+	if (ret)
+		goto out;
+
 	if (strcmp(device_path, "missing") == 0) {
 		struct list_head *devices;
 		struct btrfs_device *tmp;
-- 
2.7.0

