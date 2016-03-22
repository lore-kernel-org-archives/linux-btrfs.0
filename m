Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:47035 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758157AbcCVBiz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 21:38:55 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v8 15/27] btrfs: dedupe: Add ioctl for inband dedupelication
Date: Tue, 22 Mar 2016 09:35:40 +0800
Message-Id: <1458610552-9845-16-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Add ioctl interface for inband dedupelication, which includes:
1) enable
2) disable
3) status

We will later add ioctl to disable inband dedupe for given file/dir.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/dedupe.c          | 48 ++++++++++++++++++++++++++++++----
 fs/btrfs/dedupe.h          | 10 +++++++-
 fs/btrfs/ioctl.c           | 64 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/sysfs.c           |  2 ++
 include/uapi/linux/btrfs.h | 25 +++++++++++++++++-
 5 files changed, 142 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/dedupe.c b/fs/btrfs/dedupe.c
index 6a80afc..294cbb5 100644
--- a/fs/btrfs/dedupe.c
+++ b/fs/btrfs/dedupe.c
@@ -135,12 +135,12 @@ out:
 }
 
 int btrfs_dedupe_enable(struct btrfs_fs_info *fs_info, u16 type, u16 backend,
-			u64 blocksize, u64 limit_nr)
+			u64 blocksize, u64 limit_nr, u64 limit_mem)
 {
 	struct btrfs_dedupe_info *dedupe_info;
 	int create_tree;
 	u64 compat_ro_flag = btrfs_super_compat_ro_flags(fs_info->super_copy);
-	u64 limit = limit_nr;
+	u64 limit;
 	int ret = 0;
 
 	/* Sanity check */
@@ -153,11 +153,22 @@ int btrfs_dedupe_enable(struct btrfs_fs_info *fs_info, u16 type, u16 backend,
 		return -EINVAL;
 	if (backend >= BTRFS_DEDUPE_BACKEND_COUNT)
 		return -EINVAL;
+	/* Only one limit is accept */
+	if (limit_nr && limit_mem)
+		return -EINVAL;
 
-	if (backend == BTRFS_DEDUPE_BACKEND_INMEMORY && limit_nr == 0)
-		limit = BTRFS_DEDUPE_LIMIT_NR_DEFAULT;
-	if (backend == BTRFS_DEDUPE_BACKEND_ONDISK && limit_nr != 0)
+	if (backend == BTRFS_DEDUPE_BACKEND_INMEMORY) {
+		if (!limit_nr && !limit_mem)
+			limit = BTRFS_DEDUPE_LIMIT_NR_DEFAULT;
+		else if (limit_nr)
+			limit = limit_nr;
+		else
+			limit = limit_mem / (sizeof(struct inmem_hash) +
+					btrfs_dedupe_sizes[type]);
+	}
+	if (backend == BTRFS_DEDUPE_BACKEND_ONDISK)
 		limit = 0;
+
 	/* Ondisk backend needs DEDUP RO compat feature */
 	if (!(compat_ro_flag & BTRFS_FEATURE_COMPAT_RO_DEDUPE) &&
 	    backend == BTRFS_DEDUPE_BACKEND_ONDISK)
@@ -209,6 +220,33 @@ out:
 	return ret;
 }
 
+void btrfs_dedupe_status(struct btrfs_fs_info *fs_info,
+			 struct btrfs_ioctl_dedupe_args *dargs)
+{
+	struct btrfs_dedupe_info *dedupe_info = fs_info->dedupe_info;
+
+	if (!fs_info->dedupe_enabled || !dedupe_info) {
+		dargs->status = 0;
+		dargs->blocksize = 0;
+		dargs->backend = 0;
+		dargs->hash_type = 0;
+		dargs->limit_nr = 0;
+		dargs->current_nr = 0;
+		return;
+	}
+	mutex_lock(&dedupe_info->lock);
+	dargs->status = 1;
+	dargs->blocksize = dedupe_info->blocksize;
+	dargs->backend = dedupe_info->backend;
+	dargs->hash_type = dedupe_info->hash_type;
+	dargs->limit_nr = dedupe_info->limit_nr;
+	dargs->limit_mem = dedupe_info->limit_nr *
+		(sizeof(struct inmem_hash) +
+		 btrfs_dedupe_sizes[dedupe_info->hash_type]);
+	dargs->current_nr = dedupe_info->current_nr;
+	mutex_unlock(&dedupe_info->lock);
+}
+
 int btrfs_dedupe_resume(struct btrfs_fs_info *fs_info,
 			struct btrfs_root *dedupe_root)
 {
diff --git a/fs/btrfs/dedupe.h b/fs/btrfs/dedupe.h
index 467ddd5..60479b1 100644
--- a/fs/btrfs/dedupe.h
+++ b/fs/btrfs/dedupe.h
@@ -104,7 +104,15 @@ static inline struct btrfs_dedupe_hash *btrfs_dedupe_alloc_hash(u16 type)
  * Called at dedupe enable time.
  */
 int btrfs_dedupe_enable(struct btrfs_fs_info *fs_info, u16 type, u16 backend,
-			u64 blocksize, u64 limit_nr);
+			u64 blocksize, u64 limit_nr, u64 limit_mem);
+
+/*
+ * Get inband dedupe info
+ * Since it needs to access different backends' hash size, which
+ * is not exported, we need such simple function.
+ */
+void btrfs_dedupe_status(struct btrfs_fs_info *fs_info,
+			 struct btrfs_ioctl_dedupe_args *dargs);
 
 /*
  * Disable dedupe and invalidate all its dedupe data.
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 053e677..49bca5f 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -61,6 +61,7 @@
 #include "qgroup.h"
 #include "tree-log.h"
 #include "compression.h"
+#include "dedupe.h"
 
 #ifdef CONFIG_64BIT
 /* If we have a 32-bit userspace and 64-bit kernel, then the UAPI
@@ -3206,6 +3207,67 @@ ssize_t btrfs_dedupe_file_range(struct file *src_file, u64 loff, u64 olen,
 	return olen;
 }
 
+static long btrfs_ioctl_dedupe_ctl(struct btrfs_root *root, void __user *args)
+{
+	struct btrfs_ioctl_dedupe_args *dargs;
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
+	if (dargs->cmd >= BTRFS_DEDUPE_CTL_LAST) {
+		ret = -EINVAL;
+		goto out;
+	}
+	switch (dargs->cmd) {
+	case BTRFS_DEDUPE_CTL_ENABLE:
+		mutex_lock(&fs_info->dedupe_ioctl_lock);
+		ret = btrfs_dedupe_enable(fs_info, dargs->hash_type,
+					 dargs->backend, dargs->blocksize,
+					 dargs->limit_nr, dargs->limit_mem);
+		mutex_unlock(&fs_info->dedupe_ioctl_lock);
+		if (ret < 0)
+			break;
+
+		/* Also copy the result to caller for further use */
+		btrfs_dedupe_status(fs_info, dargs);
+		if (copy_to_user(args, dargs, sizeof(*dargs)))
+			ret = -EFAULT;
+		else
+			ret = 0;
+		break;
+	case BTRFS_DEDUPE_CTL_DISABLE:
+		mutex_lock(&fs_info->dedupe_ioctl_lock);
+		ret = btrfs_dedupe_disable(fs_info);
+		mutex_unlock(&fs_info->dedupe_ioctl_lock);
+		break;
+	case BTRFS_DEDUPE_CTL_STATUS:
+		btrfs_dedupe_status(fs_info, dargs);
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
@@ -5542,6 +5604,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_get_fslabel(file, argp);
 	case BTRFS_IOC_SET_FSLABEL:
 		return btrfs_ioctl_set_fslabel(file, argp);
+	case BTRFS_IOC_DEDUPE_CTL:
+		return btrfs_ioctl_dedupe_ctl(root, argp);
 	case BTRFS_IOC_GET_SUPPORTED_FEATURES:
 		return btrfs_ioctl_get_supported_features(argp);
 	case BTRFS_IOC_GET_FEATURES:
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 539e7b5..18686d1 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -203,6 +203,7 @@ BTRFS_FEAT_ATTR_INCOMPAT(raid56, RAID56);
 BTRFS_FEAT_ATTR_INCOMPAT(skinny_metadata, SKINNY_METADATA);
 BTRFS_FEAT_ATTR_INCOMPAT(no_holes, NO_HOLES);
 BTRFS_FEAT_ATTR_COMPAT_RO(free_space_tree, FREE_SPACE_TREE);
+BTRFS_FEAT_ATTR_COMPAT_RO(dedupe, DEDUPE);
 
 static struct attribute *btrfs_supported_feature_attrs[] = {
 	BTRFS_FEAT_ATTR_PTR(mixed_backref),
@@ -215,6 +216,7 @@ static struct attribute *btrfs_supported_feature_attrs[] = {
 	BTRFS_FEAT_ATTR_PTR(skinny_metadata),
 	BTRFS_FEAT_ATTR_PTR(no_holes),
 	BTRFS_FEAT_ATTR_PTR(free_space_tree),
+	BTRFS_FEAT_ATTR_PTR(dedupe),
 	NULL
 };
 
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index dea8931..de08f53 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -359,7 +359,7 @@ struct btrfs_ioctl_same_extent_info {
 	__u64 bytes_deduped;	/* out - total # of bytes we were able
 				 * to dedupe from this file */
 	/* status of this dedupe operation:
-	 * 0 if dedup succeeds
+	 * 0 if dedupe succeeds
 	 * < 0 for error
 	 * == BTRFS_SAME_DATA_DIFFERS if data differs
 	 */
@@ -445,6 +445,27 @@ struct btrfs_ioctl_get_dev_stats {
 	__u64 unused[128 - 2 - BTRFS_DEV_STAT_VALUES_MAX]; /* pad to 1k */
 };
 
+/*
+ * de-duplication control modes
+ * For re-config, re-enable will handle it
+ */
+#define BTRFS_DEDUPE_CTL_ENABLE	1
+#define BTRFS_DEDUPE_CTL_DISABLE 2
+#define BTRFS_DEDUPE_CTL_STATUS	3
+#define BTRFS_DEDUPE_CTL_LAST	4
+struct btrfs_ioctl_dedupe_args {
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
@@ -653,6 +674,8 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 				    struct btrfs_ioctl_dev_replace_args)
 #define BTRFS_IOC_FILE_EXTENT_SAME _IOWR(BTRFS_IOCTL_MAGIC, 54, \
 					 struct btrfs_ioctl_same_args)
+#define BTRFS_IOC_DEDUPE_CTL	_IOWR(BTRFS_IOCTL_MAGIC, 55, \
+				      struct btrfs_ioctl_dedupe_args)
 #define BTRFS_IOC_GET_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 57, \
 				   struct btrfs_ioctl_feature_flags)
 #define BTRFS_IOC_SET_FEATURES _IOW(BTRFS_IOCTL_MAGIC, 57, \
-- 
2.7.3



