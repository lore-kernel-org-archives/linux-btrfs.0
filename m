Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39695 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbbJFPTm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Oct 2015 11:19:42 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH V2 3/7] Btrfs: create helper btrfs_find_device_by_user_input()
Date: Tue,  6 Oct 2015 23:19:20 +0800
Message-Id: <1444144764-2384-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1444144764-2384-1-git-send-email-anand.jain@oracle.com>
References: <1444144764-2384-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patch renames btrfs_dev_replace_find_srcdev() to
btrfs_find_device_by_user_input() and moves it to volumes.c.
so that delete device can use it.

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
index 3a1a920..c093f49 100644
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
@@ -628,25 +625,6 @@ static void btrfs_dev_replace_update_device_in_mapping_tree(
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
index 35ee3ca..9243f8e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2052,6 +2052,25 @@ int btrfs_find_device_missing_or_by_path(struct btrfs_root *root,
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
index a6e3b37..15ee0dd 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -430,6 +430,9 @@ void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices, int step);
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

