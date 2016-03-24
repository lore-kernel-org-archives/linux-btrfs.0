Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40608 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027AbcCXKsb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Mar 2016 06:48:31 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 3/3] btrfs: refactor btrfs_dev_replace_start for reuse
Date: Thu, 24 Mar 2016 18:48:14 +0800
Message-Id: <1458816494-483-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1458816494-483-1-git-send-email-anand.jain@oracle.com>
References: <1458816494-483-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A refactor patch, and avoids user input verification in the
btrfs_dev_replace_start(), and so this function can be reused.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c | 62 ++++++++++++++++++++++++++++++--------------------
 fs/btrfs/dev-replace.h |  4 +++-
 fs/btrfs/ioctl.c       |  2 +-
 3 files changed, 41 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 025f42ef5ab3..2b926867d136 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -305,8 +305,8 @@ void btrfs_after_dev_replace_commit(struct btrfs_fs_info *fs_info)
 		dev_replace->cursor_left_last_write_of_item;
 }
 
-int btrfs_dev_replace_start(struct btrfs_root *root,
-			    struct btrfs_ioctl_dev_replace_args *args)
+int btrfs_dev_replace_start(struct btrfs_root *root, char *tgtdev_name,
+				u64 srcdevid, char *srcdev_name, int read_src)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -315,29 +315,16 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 	struct btrfs_device *tgt_device = NULL;
 	struct btrfs_device *src_device = NULL;
 
-	switch (args->start.cont_reading_from_srcdev_mode) {
-	case BTRFS_IOCTL_DEV_REPLACE_CONT_READING_FROM_SRCDEV_MODE_ALWAYS:
-	case BTRFS_IOCTL_DEV_REPLACE_CONT_READING_FROM_SRCDEV_MODE_AVOID:
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	if ((args->start.srcdevid == 0 && args->start.srcdev_name[0] == '\0') ||
-	    args->start.tgtdev_name[0] == '\0')
-		return -EINVAL;
-
 	/* the disk copy procedure reuses the scrub code */
 	mutex_lock(&fs_info->volume_mutex);
-	ret = btrfs_dev_replace_find_srcdev(root, args->start.srcdevid,
-					    args->start.srcdev_name,
-					    &src_device);
+	ret = btrfs_dev_replace_find_srcdev(root, srcdevid,
+					    srcdev_name, &src_device);
 	if (ret) {
 		mutex_unlock(&fs_info->volume_mutex);
 		return ret;
 	}
 
-	ret = btrfs_init_dev_replace_tgtdev(root, args->start.tgtdev_name,
+	ret = btrfs_init_dev_replace_tgtdev(root, tgtdev_name,
 					    src_device, &tgt_device);
 	mutex_unlock(&fs_info->volume_mutex);
 	if (ret)
@@ -364,12 +351,11 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 		break;
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED:
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED:
-		args->result = BTRFS_IOCTL_DEV_REPLACE_RESULT_ALREADY_STARTED;
+		ret = BTRFS_IOCTL_DEV_REPLACE_RESULT_ALREADY_STARTED;
 		goto leave;
 	}
 
-	dev_replace->cont_reading_from_srcdev_mode =
-		args->start.cont_reading_from_srcdev_mode;
+	dev_replace->cont_reading_from_srcdev_mode = read_src;
 	WARN_ON(!src_device);
 	dev_replace->srcdev = src_device;
 	WARN_ON(!tgt_device);
@@ -394,7 +380,6 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 	dev_replace->cursor_right = 0;
 	dev_replace->is_valid = 1;
 	dev_replace->item_needs_writeback = 1;
-	args->result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR;
 	btrfs_dev_replace_unlock(dev_replace, 1);
 
 	btrfs_wait_ordered_roots(fs_info, -1);
@@ -416,10 +401,8 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 			      &dev_replace->scrub_progress, 0, 1);
 
 	ret = btrfs_dev_replace_finishing(fs_info, ret);
-	/* don't warn if EINPROGRESS, someone else might be running scrub */
 	if (ret == -EINPROGRESS) {
-		args->result = BTRFS_IOCTL_DEV_REPLACE_RESULT_SCRUB_INPROGRESS;
-		ret = 0;
+		ret = BTRFS_IOCTL_DEV_REPLACE_RESULT_SCRUB_INPROGRESS;
 	} else {
 		WARN_ON(ret);
 	}
@@ -437,6 +420,35 @@ leave:
 	return ret;
 }
 
+int btrfs_dev_replace_by_ioctl(struct btrfs_root *root,
+			    struct btrfs_ioctl_dev_replace_args *args)
+{
+	int ret;
+
+	switch (args->start.cont_reading_from_srcdev_mode) {
+	case BTRFS_IOCTL_DEV_REPLACE_CONT_READING_FROM_SRCDEV_MODE_ALWAYS:
+	case BTRFS_IOCTL_DEV_REPLACE_CONT_READING_FROM_SRCDEV_MODE_AVOID:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if ((args->start.srcdevid == 0 && args->start.srcdev_name[0] == '\0') ||
+	    args->start.tgtdev_name[0] == '\0')
+		return -EINVAL;
+
+	ret = btrfs_dev_replace_start(root, args->start.tgtdev_name,
+					args->start.srcdevid,
+					args->start.srcdev_name,
+					args->start.cont_reading_from_srcdev_mode);
+	args->result = ret;
+	/* don't warn if EINPROGRESS, someone else might be running scrub */
+	if (ret == BTRFS_IOCTL_DEV_REPLACE_RESULT_SCRUB_INPROGRESS)
+		ret = 0;
+
+	return ret;
+}
+
 /*
  * blocked until all flighting bios are finished.
  */
diff --git a/fs/btrfs/dev-replace.h b/fs/btrfs/dev-replace.h
index 29e3ef5f96bd..e922b42d91df 100644
--- a/fs/btrfs/dev-replace.h
+++ b/fs/btrfs/dev-replace.h
@@ -25,8 +25,10 @@ int btrfs_init_dev_replace(struct btrfs_fs_info *fs_info);
 int btrfs_run_dev_replace(struct btrfs_trans_handle *trans,
 			  struct btrfs_fs_info *fs_info);
 void btrfs_after_dev_replace_commit(struct btrfs_fs_info *fs_info);
-int btrfs_dev_replace_start(struct btrfs_root *root,
+int btrfs_dev_replace_by_ioctl(struct btrfs_root *root,
 			    struct btrfs_ioctl_dev_replace_args *args);
+int btrfs_dev_replace_start(struct btrfs_root *root, char *tgtdev_name,
+				u64 srcdevid, char *srcdev_name, int read_src);
 void btrfs_dev_replace_status(struct btrfs_fs_info *fs_info,
 			      struct btrfs_ioctl_dev_replace_args *args);
 int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 053e677839fe..a811089c3890 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4376,7 +4376,7 @@ static long btrfs_ioctl_dev_replace(struct btrfs_root *root, void __user *arg)
 			1)) {
 			ret = BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
 		} else {
-			ret = btrfs_dev_replace_start(root, p);
+			ret = btrfs_dev_replace_by_ioctl(root, p);
 			atomic_set(
 			 &root->fs_info->mutually_exclusive_operation_running,
 			 0);
-- 
2.7.0

