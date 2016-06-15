Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:2559 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932487AbcFOCKV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jun 2016 22:10:21 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v11 10/13] btrfs: dedupe: Add ioctl for inband dedupelication
Date: Wed, 15 Jun 2016 10:09:58 +0800
Message-Id: <20160615021001.9588-11-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160615021001.9588-1-quwenruo@cn.fujitsu.com>
References: <20160615021001.9588-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Add ioctl interface for inband dedupelication, which includes:
1) enable
2) disable
3) status

And a pseudo RO compat flag, to imply that btrfs now supports inband
dedup.
However we don't add any ondisk format change, it's just a pseudo RO
compat flag.

All these ioctl interface are state-less, which means caller don't need
to bother previous dedupe state before calling them, and only need to
care the final desired state.

For example, if user want to enable dedupe with specified block size and
limit, just fill the ioctl structure and call enable ioctl.
No need to check if dedupe is already running.

These ioctls will handle things like re-configure or disable quite well.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/dedupe.c          | 48 ++++++++++++++++++++++++++++++++
 fs/btrfs/dedupe.h          | 15 ++++++++++
 fs/btrfs/disk-io.c         |  3 ++
 fs/btrfs/extent-tree.c     |  7 +++--
 fs/btrfs/ioctl.c           | 68 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/sysfs.c           |  2 ++
 include/uapi/linux/btrfs.h | 23 ++++++++++++++++
 7 files changed, 164 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/dedupe.c b/fs/btrfs/dedupe.c
index 4c5b3fc..74e396a 100644
--- a/fs/btrfs/dedupe.c
+++ b/fs/btrfs/dedupe.c
@@ -41,6 +41,33 @@ static inline struct inmem_hash *inmem_alloc_hash(u16 type)
 			GFP_NOFS);
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
 static int init_dedupe_info(struct btrfs_dedupe_info **ret_info, u16 type,
 			    u16 backend, u64 blocksize, u64 limit)
 {
@@ -395,6 +422,27 @@ static void unblock_all_writers(struct btrfs_fs_info *fs_info)
 	percpu_up_write(sb->s_writers.rw_sem + SB_FREEZE_WRITE - 1);
 }
 
+int btrfs_dedupe_cleanup(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_dedupe_info *dedupe_info;
+
+	fs_info->dedupe_enabled = 0;
+	/* same as disable */
+	smp_wmb();
+	dedupe_info = fs_info->dedupe_info;
+	fs_info->dedupe_info = NULL;
+
+	if (!dedupe_info)
+		return 0;
+
+	if (dedupe_info->backend == BTRFS_DEDUPE_BACKEND_INMEMORY)
+		inmem_destroy(dedupe_info);
+
+	crypto_free_shash(dedupe_info->dedupe_driver);
+	kfree(dedupe_info);
+	return 0;
+}
+
 int btrfs_dedupe_disable(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_dedupe_info *dedupe_info;
diff --git a/fs/btrfs/dedupe.h b/fs/btrfs/dedupe.h
index 9162d2c..f605a7f 100644
--- a/fs/btrfs/dedupe.h
+++ b/fs/btrfs/dedupe.h
@@ -91,6 +91,15 @@ static inline struct btrfs_dedupe_hash *btrfs_dedupe_alloc_hash(u16 type)
 int btrfs_dedupe_enable(struct btrfs_fs_info *fs_info, u16 type, u16 backend,
 			u64 blocksize, u64 limit_nr, u64 limit_mem);
 
+
+ /*
+ * Get inband dedupe info
+ * Since it needs to access different backends' hash size, which
+ * is not exported, we need such simple function.
+ */
+void btrfs_dedupe_status(struct btrfs_fs_info *fs_info,
+			 struct btrfs_ioctl_dedupe_args *dargs);
+
 /*
  * Disable dedupe and invalidate all its dedupe data.
  * Called at dedupe disable time.
@@ -102,6 +111,12 @@ int btrfs_dedupe_enable(struct btrfs_fs_info *fs_info, u16 type, u16 backend,
 int btrfs_dedupe_disable(struct btrfs_fs_info *fs_info);
 
 /*
+ * Cleanup current btrfs_dedupe_info
+ * Called in umount time
+ */
+int btrfs_dedupe_cleanup(struct btrfs_fs_info *fs_info);
+
+/*
  * Calculate hash for dedupe.
  * Caller must ensure [start, start + dedupe_bs) has valid data.
  *
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index dccd608..9918e2ff 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -50,6 +50,7 @@
 #include "sysfs.h"
 #include "qgroup.h"
 #include "compression.h"
+#include "dedupe.h"
 
 #ifdef CONFIG_X86
 #include <asm/cpufeature.h>
@@ -3902,6 +3903,8 @@ void close_ctree(struct btrfs_root *root)
 
 	btrfs_free_qgroup_config(fs_info);
 
+	btrfs_dedupe_cleanup(fs_info);
+
 	if (percpu_counter_sum(&fs_info->delalloc_bytes)) {
 		btrfs_info(fs_info, "at unmount delalloc count %lld",
 		       percpu_counter_sum(&fs_info->delalloc_bytes));
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e0db77e..f6213e7 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2427,10 +2427,13 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 				 * a new extent is revered, then deleted
 				 * in one tran, and inc/dec get merged to 0.
 				 *
-				 * In this case, we need to remove its dedup
+				 * In this case, we need to remove its dedupe
 				 * hash.
 				 */
-				btrfs_dedupe_del(trans, fs_info, node->bytenr);
+				ret = btrfs_dedupe_del(trans, fs_info,
+						       node->bytenr);
+				if (ret < 0)
+					return ret;
 				ret = btrfs_del_csums(trans, root,
 						      node->bytenr,
 						      node->num_bytes);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e6714e2..25aa620 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -61,6 +61,7 @@
 #include "qgroup.h"
 #include "tree-log.h"
 #include "compression.h"
+#include "dedupe.h"
 
 #ifdef CONFIG_64BIT
 /* If we have a 32-bit userspace and 64-bit kernel, then the UAPI
@@ -3268,6 +3269,69 @@ ssize_t btrfs_dedupe_file_range(struct file *src_file, u64 loff, u64 olen,
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
+		mutex_lock(&fs_info->dedupe_ioctl_lock);
+		btrfs_dedupe_status(fs_info, dargs);
+		mutex_unlock(&fs_info->dedupe_ioctl_lock);
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
@@ -5619,6 +5683,10 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_get_fslabel(file, argp);
 	case BTRFS_IOC_SET_FSLABEL:
 		return btrfs_ioctl_set_fslabel(file, argp);
+#ifdef CONFIG_BTRFS_DEBUG
+	case BTRFS_IOC_DEDUPE_CTL:
+		return btrfs_ioctl_dedupe_ctl(root, argp);
+#endif
 	case BTRFS_IOC_GET_SUPPORTED_FEATURES:
 		return btrfs_ioctl_get_supported_features(argp);
 	case BTRFS_IOC_GET_FEATURES:
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 4879656..4da84ca 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -206,6 +206,7 @@ BTRFS_FEAT_ATTR_INCOMPAT(raid56, RAID56);
 BTRFS_FEAT_ATTR_INCOMPAT(skinny_metadata, SKINNY_METADATA);
 BTRFS_FEAT_ATTR_INCOMPAT(no_holes, NO_HOLES);
 BTRFS_FEAT_ATTR_COMPAT_RO(free_space_tree, FREE_SPACE_TREE);
+BTRFS_FEAT_ATTR_COMPAT_RO(dedupe, DEDUPE);
 
 static struct attribute *btrfs_supported_feature_attrs[] = {
 	BTRFS_FEAT_ATTR_PTR(mixed_backref),
@@ -218,6 +219,7 @@ static struct attribute *btrfs_supported_feature_attrs[] = {
 	BTRFS_FEAT_ATTR_PTR(skinny_metadata),
 	BTRFS_FEAT_ATTR_PTR(no_holes),
 	BTRFS_FEAT_ATTR_PTR(free_space_tree),
+	BTRFS_FEAT_ATTR_PTR(dedupe),
 	NULL
 };
 
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index bc3416e..6f25b9f 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -240,6 +240,7 @@ struct btrfs_ioctl_fs_info_args {
  * struct btrfs_ioctl_feature_flags
  */
 #define BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE	(1ULL << 0)
+#define BTRFS_FEATURE_COMPAT_RO_DEDUPE		(1ULL << 1)
 
 #define BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF	(1ULL << 0)
 #define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(1ULL << 1)
@@ -636,6 +637,26 @@ struct btrfs_ioctl_get_dev_stats {
 
 /* Default dedupe limit on number of hash */
 #define BTRFS_DEDUPE_LIMIT_NR_DEFAULT	(32 * 1024)
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
 
 #define BTRFS_QUOTA_CTL_ENABLE	1
 #define BTRFS_QUOTA_CTL_DISABLE	2
@@ -845,6 +866,8 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 				    struct btrfs_ioctl_dev_replace_args)
 #define BTRFS_IOC_FILE_EXTENT_SAME _IOWR(BTRFS_IOCTL_MAGIC, 54, \
 					 struct btrfs_ioctl_same_args)
+#define BTRFS_IOC_DEDUPE_CTL	_IOWR(BTRFS_IOCTL_MAGIC, 55, \
+				      struct btrfs_ioctl_dedupe_args)
 #define BTRFS_IOC_GET_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 57, \
 				   struct btrfs_ioctl_feature_flags)
 #define BTRFS_IOC_SET_FEATURES _IOW(BTRFS_IOCTL_MAGIC, 57, \
-- 
2.8.3



