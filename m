Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:41093 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1425093AbcBRFpg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Feb 2016 00:45:36 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, clm@fb.com
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v7 15/20] btrfs: dedup: Add ioctl for inband deduplication
Date: Thu, 18 Feb 2016 13:42:53 +0800
Message-Id: <1455774178-3595-16-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1455774178-3595-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1455774178-3595-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
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
 fs/btrfs/dedup.c           | 48 ++++++++++++++++++++++++++++++----
 fs/btrfs/dedup.h           | 10 +++++++-
 fs/btrfs/ioctl.c           | 64 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/sysfs.c           |  2 ++
 include/uapi/linux/btrfs.h | 24 +++++++++++++++++
 5 files changed, 142 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/dedup.c b/fs/btrfs/dedup.c
index 8972cff..b7ecb8f 100644
--- a/fs/btrfs/dedup.c
+++ b/fs/btrfs/dedup.c
@@ -135,12 +135,12 @@ out:
 }
 
 int btrfs_dedup_enable(struct btrfs_fs_info *fs_info, u16 type, u16 backend,
-		       u64 blocksize, u64 limit_nr)
+		       u64 blocksize, u64 limit_nr, u64 limit_mem)
 {
 	struct btrfs_dedup_info *dedup_info;
 	int create_tree;
 	u64 compat_ro_flag = btrfs_super_compat_ro_flags(fs_info->super_copy);
-	u64 limit = limit_nr;
+	u64 limit;
 	int ret = 0;
 
 	/* Sanity check */
@@ -153,11 +153,22 @@ int btrfs_dedup_enable(struct btrfs_fs_info *fs_info, u16 type, u16 backend,
 		return -EINVAL;
 	if (backend >= BTRFS_DEDUP_BACKEND_LAST)
 		return -EINVAL;
+	/* Only one limit is accept */
+	if (limit_nr && limit_mem)
+		return -EINVAL;
 
-	if (backend == BTRFS_DEDUP_BACKEND_INMEMORY && limit_nr == 0)
-		limit = 4096; /* default value */
-	if (backend == BTRFS_DEDUP_BACKEND_ONDISK && limit_nr != 0)
+	if (backend == BTRFS_DEDUP_BACKEND_INMEMORY) {
+		if (!limit_nr && !limit_mem)
+			limit = BTRFS_DEDUP_LIMIT_NR_DEFAULT;
+		else if (limit_nr)
+			limit = limit_nr;
+		else
+			limit = limit_mem / (sizeof(struct inmem_hash) +
+					btrfs_dedup_sizes[type]);
+	}
+	if (backend == BTRFS_DEDUP_BACKEND_ONDISK)
 		limit = 0;
+
 	/* Ondisk backend needs DEDUP RO compat feature */
 	if (!(compat_ro_flag & BTRFS_FEATURE_COMPAT_RO_DEDUP) &&
 	    backend == BTRFS_DEDUP_BACKEND_ONDISK)
@@ -208,6 +219,33 @@ out:
 	return ret;
 }
 
+void btrfs_dedup_status(struct btrfs_fs_info *fs_info,
+			struct btrfs_ioctl_dedup_args *dargs)
+{
+	struct btrfs_dedup_info *dedup_info = fs_info->dedup_info;
+
+	if (!fs_info->dedup_enabled || !dedup_info) {
+		dargs->status = 0;
+		dargs->blocksize = 0;
+		dargs->backend = 0;
+		dargs->hash_type = 0;
+		dargs->limit_nr = 0;
+		dargs->current_nr = 0;
+		return;
+	}
+	mutex_lock(&dedup_info->lock);
+	dargs->status = 1;
+	dargs->blocksize = dedup_info->blocksize;
+	dargs->backend = dedup_info->backend;
+	dargs->hash_type = dedup_info->hash_type;
+	dargs->limit_nr = dedup_info->limit_nr;
+	dargs->limit_mem = dedup_info->limit_nr *
+		(sizeof(struct inmem_hash) +
+		 btrfs_dedup_sizes[dedup_info->hash_type]);
+	dargs->current_nr = dedup_info->current_nr;
+	mutex_unlock(&dedup_info->lock);
+}
+
 int btrfs_dedup_resume(struct btrfs_fs_info *fs_info,
 		       struct btrfs_root *dedup_root)
 {
diff --git a/fs/btrfs/dedup.h b/fs/btrfs/dedup.h
index a580072..8a99a7f 100644
--- a/fs/btrfs/dedup.h
+++ b/fs/btrfs/dedup.h
@@ -100,7 +100,15 @@ static inline struct btrfs_dedup_hash *btrfs_dedup_alloc_hash(u16 type)
  * Called at dedup enable time.
  */
 int btrfs_dedup_enable(struct btrfs_fs_info *fs_info, u16 type, u16 backend,
-		       u64 blocksize, u64 limit_nr);
+		       u64 blocksize, u64 limit_nr, u64 limit_mem);
+
+/*
+ * Get inband dedup info
+ * Since it needs to access different backends' hash size, which
+ * is not exported, we need such simple function.
+ */
+void btrfs_dedup_status(struct btrfs_fs_info *fs_info,
+			struct btrfs_ioctl_dedup_args *dargs);
 
 /*
  * Disable dedup and invalidate all its dedup data.
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 77c61b4..eb37a3d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -59,6 +59,7 @@
 #include "props.h"
 #include "sysfs.h"
 #include "qgroup.h"
+#include "dedup.h"
 
 #ifdef CONFIG_64BIT
 /* If we have a 32-bit userspace and 64-bit kernel, then the UAPI
@@ -3257,6 +3258,67 @@ ssize_t btrfs_dedupe_file_range(struct file *src_file, u64 loff, u64 olen,
 	return olen;
 }
 
+static long btrfs_ioctl_dedup_ctl(struct btrfs_root *root, void __user *args)
+{
+	struct btrfs_ioctl_dedup_args *dargs;
+	struct btrfs_fs_info *fs_info = root->fs_info;
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
+		mutex_lock(&fs_info->dedup_ioctl_lock);
+		ret = btrfs_dedup_enable(fs_info, dargs->hash_type,
+					 dargs->backend, dargs->blocksize,
+					 dargs->limit_nr, dargs->limit_mem);
+		mutex_unlock(&fs_info->dedup_ioctl_lock);
+		if (ret < 0)
+			break;
+
+		/* Also copy the result to caller for further use */
+		btrfs_dedup_status(fs_info, dargs);
+		if (copy_to_user(args, dargs, sizeof(*dargs)))
+			ret = -EFAULT;
+		else
+			ret = 0;
+		break;
+	case BTRFS_DEDUP_CTL_DISABLE:
+		mutex_lock(&fs_info->dedup_ioctl_lock);
+		ret = btrfs_dedup_disable(fs_info);
+		mutex_unlock(&fs_info->dedup_ioctl_lock);
+		break;
+	case BTRFS_DEDUP_CTL_STATUS:
+		btrfs_dedup_status(fs_info, dargs);
+		if (copy_to_user(args, dargs, sizeof(*dargs)))
+			ret = -EFAULT;
+		else
+			ret = 0;
+		break;
+	default:
+		/*
+		 * Use this return value to inform progs that kernel
+		 * doesn't support such new command.
+		 */
+		ret = -EOPNOTSUPP;
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
@@ -5596,6 +5658,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_get_fslabel(file, argp);
 	case BTRFS_IOC_SET_FSLABEL:
 		return btrfs_ioctl_set_fslabel(file, argp);
+	case BTRFS_IOC_DEDUP_CTL:
+		return btrfs_ioctl_dedup_ctl(root, argp);
 	case BTRFS_IOC_GET_SUPPORTED_FEATURES:
 		return btrfs_ioctl_get_supported_features(file, argp);
 	case BTRFS_IOC_GET_FEATURES:
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 539e7b5..75e5ca85 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -203,6 +203,7 @@ BTRFS_FEAT_ATTR_INCOMPAT(raid56, RAID56);
 BTRFS_FEAT_ATTR_INCOMPAT(skinny_metadata, SKINNY_METADATA);
 BTRFS_FEAT_ATTR_INCOMPAT(no_holes, NO_HOLES);
 BTRFS_FEAT_ATTR_COMPAT_RO(free_space_tree, FREE_SPACE_TREE);
+BTRFS_FEAT_ATTR_COMPAT_RO(dedup, DEDUP);
 
 static struct attribute *btrfs_supported_feature_attrs[] = {
 	BTRFS_FEAT_ATTR_PTR(mixed_backref),
@@ -215,6 +216,7 @@ static struct attribute *btrfs_supported_feature_attrs[] = {
 	BTRFS_FEAT_ATTR_PTR(skinny_metadata),
 	BTRFS_FEAT_ATTR_PTR(no_holes),
 	BTRFS_FEAT_ATTR_PTR(free_space_tree),
+	BTRFS_FEAT_ATTR_PTR(dedup),
 	NULL
 };
 
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 3975e68..9261e3f 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -456,6 +456,28 @@ struct btrfs_ioctl_get_dev_stats {
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
+	__u64 limit_mem;	/* In/Out: For enable/status */
+	__u64 current_nr;	/* Out: For status output */
+	__u16 backend;		/* In/Out: For enable/status */
+	__u16 hash_type;	/* In/Out: For enable/status */
+	u8 status;		/* Out: For status output */
+	/* pad to 512 bytes */
+	u8 __unused[473];
+};
+
 #define BTRFS_QUOTA_CTL_ENABLE	1
 #define BTRFS_QUOTA_CTL_DISABLE	2
 #define BTRFS_QUOTA_CTL_RESCAN__NOTUSED	3
@@ -664,6 +686,8 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 				    struct btrfs_ioctl_dev_replace_args)
 #define BTRFS_IOC_FILE_EXTENT_SAME _IOWR(BTRFS_IOCTL_MAGIC, 54, \
 					 struct btrfs_ioctl_same_args)
+#define BTRFS_IOC_DEDUP_CTL	_IOWR(BTRFS_IOCTL_MAGIC, 55, \
+				      struct btrfs_ioctl_dedup_args)
 #define BTRFS_IOC_GET_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 57, \
 				   struct btrfs_ioctl_feature_flags)
 #define BTRFS_IOC_SET_FEATURES _IOW(BTRFS_IOCTL_MAGIC, 57, \
-- 
2.7.1



