Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22530 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbcEAXC1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 May 2016 19:02:27 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2] btrfs: cleanup assigning next active device with a check
Date: Mon,  2 May 2016 07:02:08 +0800
Message-Id: <1462143728-3000-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1460978752-27375-1-git-send-email-anand.jain@oracle.com>
References: <1460978752-27375-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Creates helper fucntion as needed by the device delete
and replace operations. Also now it checks if the next
device being assigned is an active device.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 v2: added comments, and BUG_ON if we can't find next_device.

 fs/btrfs/dev-replace.c |  8 +++----
 fs/btrfs/volumes.c     | 60 ++++++++++++++++++++++++++++++++++++--------------
 fs/btrfs/volumes.h     |  2 ++
 3 files changed, 48 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 6b37803a1a4a..50d0ed2fad2e 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -569,11 +569,9 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	ASSERT(list_empty(&src_device->resized_list));
 	tgt_device->commit_total_bytes = src_device->commit_total_bytes;
 	tgt_device->commit_bytes_used = src_device->bytes_used;
-	if (fs_info->sb->s_bdev &&
-		(fs_info->sb->s_bdev == src_device->bdev))
-		fs_info->sb->s_bdev = tgt_device->bdev;
-	if (fs_info->fs_devices->latest_bdev == src_device->bdev)
-		fs_info->fs_devices->latest_bdev = tgt_device->bdev;
+
+	btrfs_assign_next_active_device(fs_info, src_device, tgt_device);
+
 	list_add(&tgt_device->dev_alloc_list, &fs_info->fs_devices->alloc_list);
 	fs_info->fs_devices->rw_devices++;
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5f70c1235466..0bb15da2da40 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1742,10 +1742,49 @@ out:
 	return ret;
 }
 
+struct btrfs_device *btrfs_find_next_active_device(struct btrfs_fs_devices *fs_devs,
+					struct btrfs_device *device)
+{
+	struct btrfs_device *next_device;
+
+	list_for_each_entry(next_device, &fs_devs->devices, dev_list) {
+		if (next_device != device &&
+			!next_device->missing && next_device->bdev)
+			return next_device;
+	}
+	return NULL;
+}
+
+/*
+ * Helper function to check if the given device is part of
+ * s_bdev / latest_bdev and replace it with the provided or
+ * the next active device, in the context where this function
+ * called, there should be always be another device which is
+ * active.
+ */
+void btrfs_assign_next_active_device(struct btrfs_fs_info *fs_info,
+		struct btrfs_device *device, struct btrfs_device *this_dev)
+{
+	struct btrfs_device *next_device;
+
+	if (this_dev)
+		next_device = this_dev;
+	else
+		next_device = btrfs_find_next_active_device(fs_info->fs_devices,
+								device);
+	BUG_ON(!next_device); /* Logic error */
+
+	if (fs_info->sb->s_bdev &&
+			(fs_info->sb->s_bdev == device->bdev))
+		fs_info->sb->s_bdev = next_device->bdev;
+
+	if (fs_info->fs_devices->latest_bdev == device->bdev)
+		fs_info->fs_devices->latest_bdev = next_device->bdev;
+}
+
 int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 {
 	struct btrfs_device *device;
-	struct btrfs_device *next_device;
 	struct block_device *bdev;
 	struct buffer_head *bh = NULL;
 	struct btrfs_super_block *disk_super;
@@ -1896,13 +1935,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	if (device->missing)
 		device->fs_devices->missing_devices--;
 
-	next_device = list_entry(root->fs_info->fs_devices->devices.next,
-				 struct btrfs_device, dev_list);
-	if (root->fs_info->sb->s_bdev &&
-		(root->fs_info->sb->s_bdev == device->bdev))
-		root->fs_info->sb->s_bdev = next_device->bdev;
-	if (device->bdev == root->fs_info->fs_devices->latest_bdev)
-		root->fs_info->fs_devices->latest_bdev = next_device->bdev;
+	btrfs_assign_next_active_device(root->fs_info, device, NULL);
 
 	if (device->bdev) {
 		device->fs_devices->open_devices--;
@@ -2069,8 +2102,6 @@ void btrfs_rm_dev_replace_free_srcdev(struct btrfs_fs_info *fs_info,
 void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 				      struct btrfs_device *tgtdev)
 {
-	struct btrfs_device *next_device;
-
 	mutex_lock(&uuid_mutex);
 	WARN_ON(!tgtdev);
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
@@ -2082,13 +2113,8 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 
 	fs_info->fs_devices->num_devices--;
 
-	next_device = list_entry(fs_info->fs_devices->devices.next,
-				 struct btrfs_device, dev_list);
-	if (fs_info->sb->s_bdev &&
-		(tgtdev->bdev == fs_info->sb->s_bdev))
-		fs_info->sb->s_bdev = next_device->bdev;
-	if (tgtdev->bdev == fs_info->fs_devices->latest_bdev)
-		fs_info->fs_devices->latest_bdev = next_device->bdev;
+	btrfs_assign_next_active_device(fs_info, tgtdev, NULL);
+
 	list_del_rcu(&tgtdev->dev_list);
 
 	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 18c01739d46b..dbb018d82ec6 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -464,6 +464,8 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 			  struct btrfs_fs_devices **fs_devices_ret);
 int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
 void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices, int step);
+void btrfs_assign_next_active_device(struct btrfs_fs_info *fs_info,
+		struct btrfs_device *device, struct btrfs_device *this_dev);
 int btrfs_find_device_missing_or_by_path(struct btrfs_root *root,
 					 char *device_path,
 					 struct btrfs_device **device);
-- 
2.7.0

