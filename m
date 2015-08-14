Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34096 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050AbbHNKdh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 06:33:37 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 10/23] Btrfs: rename btrfs_dev_replace_find_srcdev()
Date: Fri, 14 Aug 2015 18:32:55 +0800
Message-Id: <1439548388-29686-11-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
References: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patch renames btrfs_dev_replace_find_srcdev() to
btrfs_find_device_by_user_input() so that it can be used
by btrfs_rm_device() as well in the next patches.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c | 24 +-----------------------
 fs/btrfs/volumes.c     | 19 +++++++++++++++++++
 fs/btrfs/volumes.h     |  3 +++
 3 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 6eb9324..673a2c3 100644
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
@@ -343,7 +340,7 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 
 	/* the disk copy procedure reuses the scrub code */
 	mutex_lock(&fs_info->volume_mutex);
-	ret = btrfs_dev_replace_find_srcdev(root, args->start.srcdevid,
+	ret = btrfs_find_device_by_user_input(root, args->start.srcdevid,
 					    args->start.srcdev_name,
 					    &src_device);
 	if (ret) {
@@ -626,25 +623,6 @@ static void btrfs_dev_replace_update_device_in_mapping_tree(
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
index 1573997..101a473 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2089,6 +2089,25 @@ int btrfs_find_device_missing_or_by_path(struct btrfs_root *root,
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
index f4b0ed8..a093b36 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -429,6 +429,9 @@ void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices, int step);
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
2.4.1

