Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34904 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbcBOReO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Feb 2016 12:34:14 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Anand Jain <anand.jain@oracle.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 04/15] btrfs: create helper btrfs_find_device_by_user_input()
Date: Mon, 15 Feb 2016 18:34:10 +0100
Message-Id: <ed9831b09fa6538cf03ec6a30b65f7d96eb5dc75.1455556900.git.dsterba@suse.com>
In-Reply-To: <cover.1455556900.git.dsterba@suse.com>
References: <cover.1455556900.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

The patch renames btrfs_dev_replace_find_srcdev() to
btrfs_find_device_by_user_input() and moves it to volumes.c, so that
delete device can use it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/dev-replace.c | 24 +-----------------------
 fs/btrfs/volumes.c     | 19 +++++++++++++++++++
 fs/btrfs/volumes.h     |  3 +++
 3 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index cbb7dbfb3fff..12d941d9b0e8 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -44,9 +44,6 @@ static void btrfs_dev_replace_update_device_in_mapping_tree(
 						struct btrfs_fs_info *fs_info,
 						struct btrfs_device *srcdev,
 						struct btrfs_device *tgtdev);
-static int btrfs_dev_replace_find_srcdev(struct btrfs_root *root, u64 srcdevid,
-					 char *srcdev_name,
-					 struct btrfs_device **device);
 static u64 __btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info);
 static int btrfs_dev_replace_kthread(void *data);
 static int btrfs_dev_replace_continue_on_mount(struct btrfs_fs_info *fs_info);
@@ -329,7 +326,7 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 
 	/* the disk copy procedure reuses the scrub code */
 	mutex_lock(&fs_info->volume_mutex);
-	ret = btrfs_dev_replace_find_srcdev(root, args->start.srcdevid,
+	ret = btrfs_find_device_by_user_input(root, args->start.srcdevid,
 					    args->start.srcdev_name,
 					    &src_device);
 	if (ret) {
@@ -624,25 +621,6 @@ static void btrfs_dev_replace_update_device_in_mapping_tree(
 	write_unlock(&em_tree->lock);
 }
 
-static int btrfs_dev_replace_find_srcdev(struct btrfs_root *root, u64 srcdevid,
-					 char *srcdev_name,
-					 struct btrfs_device **device)
-{
-	int ret;
-
-	if (srcdevid) {
-		ret = 0;
-		*device = btrfs_find_device(root->fs_info, srcdevid, NULL,
-					    NULL);
-		if (!*device)
-			ret = -ENOENT;
-	} else {
-		ret = btrfs_find_device_missing_or_by_path(root, srcdev_name,
-							   device);
-	}
-	return ret;
-}
-
 void btrfs_dev_replace_status(struct btrfs_fs_info *fs_info,
 			      struct btrfs_ioctl_dev_replace_args *args)
 {
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ffc9a215e6ec..ffaa1306a35f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2125,6 +2125,25 @@ int btrfs_find_device_missing_or_by_path(struct btrfs_root *root,
 	}
 }
 
+int btrfs_find_device_by_user_input(struct btrfs_root *root, u64 srcdevid,
+					 char *srcdev_name,
+					 struct btrfs_device **device)
+{
+	int ret;
+
+	if (srcdevid) {
+		ret = 0;
+		*device = btrfs_find_device(root->fs_info, srcdevid, NULL,
+					    NULL);
+		if (!*device)
+			ret = -ENOENT;
+	} else {
+		ret = btrfs_find_device_missing_or_by_path(root, srcdev_name,
+							   device);
+	}
+	return ret;
+}
+
 /*
  * does all the dirty work required for changing file system's UUID.
  */
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 1939ebde63df..508739314e43 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -448,6 +448,9 @@ void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices, int step);
 int btrfs_find_device_missing_or_by_path(struct btrfs_root *root,
 					 char *device_path,
 					 struct btrfs_device **device);
+int btrfs_find_device_by_user_input(struct btrfs_root *root, u64 srcdevid,
+					 char *srcdev_name,
+					 struct btrfs_device **device);
 struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
 					const u64 *devid,
 					const u8 *uuid);
-- 
2.7.1

