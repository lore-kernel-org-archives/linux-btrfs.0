Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46302 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752472AbcAGBIx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jan 2016 20:08:53 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id 5827A41887F9
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Jan 2016 09:08:28 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v3 16/16] btrfs: dedup: Add ioctl for inband deduplication
Date: Thu, 7 Jan 2016 09:08:17 +0800
Message-ID: <1452128897-5433-17-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1452128897-5433-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1452128897-5433-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Add ioctl interface for inband deduplication, which includes:
1) enable
2) disable
3) status

We will later add ioctl to disable inband dedup for given file/dir.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/ctree.h           |  1 +
 fs/btrfs/disk-io.c         |  1 +
 fs/btrfs/ioctl.c           | 63 ++++++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/btrfs.h | 23 +++++++++++++++++
 4 files changed, 88 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 87158ac..4845933 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1865,6 +1865,7 @@ struct btrfs_fs_info {
 
 	/* reference to inband de-duplication info */
 	struct btrfs_dedup_info *dedup_info;
+	struct mutex dedup_ioctl_mutex;
 };
 
 struct btrfs_subvolume_writers {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 0d84e17..341f4f0 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2562,6 +2562,7 @@ int open_ctree(struct super_block *sb,
 	mutex_init(&fs_info->delete_unused_bgs_mutex);
 	mutex_init(&fs_info->reloc_mutex);
 	mutex_init(&fs_info->delalloc_root_mutex);
+	mutex_init(&fs_info->dedup_ioctl_mutex);
 	seqlock_init(&fs_info->profiles_lock);
 	init_rwsem(&fs_info->delayed_iput_sem);
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7375cf2..6749c84 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -59,6 +59,7 @@
 #include "props.h"
 #include "sysfs.h"
 #include "qgroup.h"
+#include "dedup.h"
 
 #ifdef CONFIG_64BIT
 /* If we have a 32-bit userspace and 64-bit kernel, then the UAPI
@@ -3206,6 +3207,66 @@ out:
 	return ret;
 }
 
+static long btrfs_ioctl_dedup_ctl(struct btrfs_root *root, void __user *args)
+{
+	struct btrfs_ioctl_dedup_args *dargs;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_dedup_info *dedup_info;
+	int ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	dargs = memdup_user(args, sizeof(*dargs));
+	if (IS_ERR(dargs)) {
+		ret = PTR_ERR(dargs);
+		return ret;
+	}
+
+	if (dargs->cmd >= BTRFS_DEDUP_CTL_LAST) {
+		ret = -EINVAL;
+		goto out;
+	}
+	switch (dargs->cmd) {
+	case BTRFS_DEDUP_CTL_ENABLE:
+		ret = btrfs_dedup_enable(fs_info, dargs->hash_type,
+					 dargs->backend, dargs->blocksize,
+					 dargs->limit_nr);
+		break;
+	case BTRFS_DEDUP_CTL_DISABLE:
+		ret = btrfs_dedup_disable(fs_info);
+		break;
+	case BTRFS_DEDUP_CTL_STATUS:
+		dedup_info = fs_info->dedup_info;
+		if (dedup_info) {
+			dargs->status = 1;
+			dargs->blocksize = dedup_info->blocksize;
+			dargs->backend = dedup_info->backend;
+			dargs->hash_type = dedup_info->hash_type;
+			dargs->limit_nr = dedup_info->limit_nr;
+			dargs->current_nr = dedup_info->current_nr;
+		} else {
+			dargs->status = 0;
+			dargs->blocksize = 0;
+			dargs->backend = 0;
+			dargs->hash_type = 0;
+			dargs->limit_nr = 0;
+			dargs->current_nr = 0;
+		}
+		if (copy_to_user(args, dargs, sizeof(*dargs)))
+			ret = -EFAULT;
+		else
+			ret = 0;
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+out:
+	kfree(dargs);
+	return ret;
+}
+
 static int clone_finish_inode_update(struct btrfs_trans_handle *trans,
 				     struct inode *inode,
 				     u64 endoff,
@@ -5565,6 +5626,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_set_fslabel(file, argp);
 	case BTRFS_IOC_FILE_EXTENT_SAME:
 		return btrfs_ioctl_file_extent_same(file, argp);
+	case BTRFS_IOC_DEDUP_CTL:
+		return btrfs_ioctl_dedup_ctl(root, argp);
 	case BTRFS_IOC_GET_SUPPORTED_FEATURES:
 		return btrfs_ioctl_get_supported_features(file, argp);
 	case BTRFS_IOC_GET_FEATURES:
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index dea8931..b33da24 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -445,6 +445,27 @@ struct btrfs_ioctl_get_dev_stats {
 	__u64 unused[128 - 2 - BTRFS_DEV_STAT_VALUES_MAX]; /* pad to 1k */
 };
 
+/*
+ * de-duplication control modes
+ * For re-config, re-enable will handle it
+ * TODO: Add support to disable per-file/dir dedup operation
+ */
+#define BTRFS_DEDUP_CTL_ENABLE	1
+#define BTRFS_DEDUP_CTL_DISABLE 2
+#define BTRFS_DEDUP_CTL_STATUS	3
+#define BTRFS_DEDUP_CTL_LAST	4
+struct btrfs_ioctl_dedup_args {
+	__u16 cmd;		/* In: command(see above macro) */
+	__u64 blocksize;	/* In/Out: For enable/status */
+	__u64 limit_nr;		/* In/Out: For enable/status */
+	__u64 current_nr;	/* Out: For status output */
+	__u16 backend;		/* In/Out: For enable/status */
+	__u16 hash_type;	/* In/Out: For enable/status */
+	u8 status;		/* Out: For status output */
+	/* pad to 512 bytes */
+	u8 __unused[489];
+};
+
 #define BTRFS_QUOTA_CTL_ENABLE	1
 #define BTRFS_QUOTA_CTL_DISABLE	2
 #define BTRFS_QUOTA_CTL_RESCAN__NOTUSED	3
@@ -653,6 +674,8 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 				    struct btrfs_ioctl_dev_replace_args)
 #define BTRFS_IOC_FILE_EXTENT_SAME _IOWR(BTRFS_IOCTL_MAGIC, 54, \
 					 struct btrfs_ioctl_same_args)
+#define BTRFS_IOC_DEDUP_CTL	_IOWR(BTRFS_IOCTL_MAGIC, 55, \
+				      struct btrfs_ioctl_dedup_args)
 #define BTRFS_IOC_GET_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 57, \
 				   struct btrfs_ioctl_feature_flags)
 #define BTRFS_IOC_SET_FEATURES _IOW(BTRFS_IOCTL_MAGIC, 57, \
-- 
2.6.4



