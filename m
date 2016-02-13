Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43097 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbcBMCCI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Feb 2016 21:02:08 -0500
From: Anand Jain <anand.jain@oracle.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 08/13] btrfs: create helper btrfs_find_device_by_user_input()
Date: Sat, 13 Feb 2016 10:01:35 +0800
Message-Id: <1455328900-1476-9-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1455328900-1476-1-git-send-email-anand.jain@oracle.com>
References: <1455328900-1476-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patch renames btrfs_dev_replace_find_srcdev() to
btrfs_find_device_by_user_input() and moves it to volumes.c, so that
delete device can use it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2: changed title from
    'Btrfs: rename btrfs_dev_replace_find_srcdev()'
    and commit update
 fs/btrfs/dev-replace.c | 24 +-----------------------
 fs/btrfs/volumes.c     | 19 +++++++++++++++++++
 fs/btrfs/volumes.h     |  3 +++
 3 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 01ce5fc..b3e3f94 100644
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
index 191eb82..889fc0c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2124,6 +2124,25 @@ int btrfs_find_device_missing_or_by_path(struct btrfs_root *root,
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
index 1939ebd..5087393 100644
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
2.7.0

