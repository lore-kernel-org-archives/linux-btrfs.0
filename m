Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:40324 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726708AbeIDLXw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Sep 2018 07:23:52 -0400
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH v15 11/13] btrfs: dedupe: Add ioctl for inband deduplication
Date: Tue, 4 Sep 2018 14:59:40 +0800
Message-ID: <20180904065942.3621-12-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180904065942.3621-1-lufq.fnst@cn.fujitsu.com>
References: <20180904065942.3621-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Add ioctl interface for inband deduplication, which includes:
1) enable
2) disable
3) status

And a pseudo RO compat flag, to imply that btrfs now supports inband
dedup.
However we don't add any ondisk format change, it's just a pseudo RO
compat flag.

All these ioctl interfaces are state-less, which means caller don't need
to bother previous dedupe state before calling them, and only need to
care the final desired state.

For example, if user want to enable dedupe with specified block size and
limit, just fill the ioctl structure and call enable ioctl.
No need to check if dedupe is already running.

These ioctls will handle things like re-configure or disable quite well.

Also, for invalid parameters, enable ioctl interface will set the field
of the first encountered invalid parameter to (-1) to inform caller.
While for limit_nr/limit_mem, the value will be (0).

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/dedupe.c          | 50 +++++++++++++++++++++++++++++
 fs/btrfs/dedupe.h          | 17 +++++++---
 fs/btrfs/disk-io.c         |  3 ++
 fs/btrfs/ioctl.c           | 65 ++++++++++++++++++++++++++++++++++++++
 fs/btrfs/sysfs.c           |  2 ++
 include/uapi/linux/btrfs.h | 12 ++++++-
 6 files changed, 143 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/dedupe.c b/fs/btrfs/dedupe.c
index 9b0a90dd8e42..a147e148bbb8 100644
--- a/fs/btrfs/dedupe.c
+++ b/fs/btrfs/dedupe.c
@@ -29,6 +29,35 @@ static inline struct inmem_hash *inmem_alloc_hash(u16 algo)
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
+		dargs->hash_algo = 0;
+		dargs->limit_nr = 0;
+		dargs->current_nr = 0;
+		memset(dargs->__unused, -1, sizeof(dargs->__unused));
+		return;
+	}
+	mutex_lock(&dedupe_info->lock);
+	dargs->status = 1;
+	dargs->blocksize = dedupe_info->blocksize;
+	dargs->backend = dedupe_info->backend;
+	dargs->hash_algo = dedupe_info->hash_algo;
+	dargs->limit_nr = dedupe_info->limit_nr;
+	dargs->limit_mem = dedupe_info->limit_nr *
+		(sizeof(struct inmem_hash) +
+		 btrfs_hash_sizes[dedupe_info->hash_algo]);
+	dargs->current_nr = dedupe_info->current_nr;
+	mutex_unlock(&dedupe_info->lock);
+	memset(dargs->__unused, -1, sizeof(dargs->__unused));
+}
+
 static struct btrfs_dedupe_info *
 init_dedupe_info(struct btrfs_ioctl_dedupe_args *dargs)
 {
@@ -402,6 +431,27 @@ static void unblock_all_writers(struct btrfs_fs_info *fs_info)
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
index 8157b17c4d11..fdd00355d6b5 100644
--- a/fs/btrfs/dedupe.h
+++ b/fs/btrfs/dedupe.h
@@ -90,6 +90,15 @@ static inline struct btrfs_dedupe_hash *btrfs_dedupe_alloc_hash(u16 algo)
 int btrfs_dedupe_enable(struct btrfs_fs_info *fs_info,
 			struct btrfs_ioctl_dedupe_args *dargs);
 
+
+/*
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
@@ -101,12 +110,10 @@ int btrfs_dedupe_enable(struct btrfs_fs_info *fs_info,
 int btrfs_dedupe_disable(struct btrfs_fs_info *fs_info);
 
 /*
- * Get current dedupe status.
- * Return 0 for success
- * No possible error yet
+ * Cleanup current btrfs_dedupe_info
+ * Called in umount time
  */
-void btrfs_dedupe_status(struct btrfs_fs_info *fs_info,
-			 struct btrfs_ioctl_dedupe_args *dargs);
+int btrfs_dedupe_cleanup(struct btrfs_fs_info *fs_info);
 
 /*
  * Calculate hash for dedupe.
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 06683b3f2f0b..43a0324c749c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -38,6 +38,7 @@
 #include "compression.h"
 #include "tree-checker.h"
 #include "ref-verify.h"
+#include "dedupe.h"
 
 #ifdef CONFIG_X86
 #include <asm/cpufeature.h>
@@ -3982,6 +3983,8 @@ void close_ctree(struct btrfs_fs_info *fs_info)
 	btrfs_free_qgroup_config(fs_info);
 	ASSERT(list_empty(&fs_info->delalloc_roots));
 
+	btrfs_dedupe_cleanup(fs_info);
+
 	if (percpu_counter_sum(&fs_info->delalloc_bytes)) {
 		btrfs_info(fs_info, "at unmount delalloc count %lld",
 		       percpu_counter_sum(&fs_info->delalloc_bytes));
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7110318b08f2..510941419ff6 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3614,6 +3614,69 @@ int btrfs_dedupe_file_range(struct file *src_file, loff_t src_loff,
 	return btrfs_extent_same(src, src_loff, olen, dst, dst_loff);
 }
 
+static long btrfs_ioctl_dedupe_ctl(struct btrfs_root *root, void __user *args)
+{
+	struct btrfs_ioctl_dedupe_args *dargs;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	int ret = 0;
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
+		ret = btrfs_dedupe_enable(fs_info, dargs);
+		/*
+		 * Also copy the result to caller for further use
+		 * if enable succeeded.
+		 * For error case, dargs is already set up with
+		 * special values indicating error reason.
+		 */
+		if (!ret)
+			btrfs_dedupe_status(fs_info, dargs);
+		mutex_unlock(&fs_info->dedupe_ioctl_lock);
+		break;
+	case BTRFS_DEDUPE_CTL_DISABLE:
+		mutex_lock(&fs_info->dedupe_ioctl_lock);
+		ret = btrfs_dedupe_disable(fs_info);
+		btrfs_dedupe_status(fs_info, dargs);
+		mutex_unlock(&fs_info->dedupe_ioctl_lock);
+		break;
+	case BTRFS_DEDUPE_CTL_STATUS:
+		mutex_lock(&fs_info->dedupe_ioctl_lock);
+		btrfs_dedupe_status(fs_info, dargs);
+		mutex_unlock(&fs_info->dedupe_ioctl_lock);
+		break;
+	default:
+		/*
+		 * Use this return value to inform progs that kernel
+		 * doesn't support such new command.
+		 */
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+	/*
+	 * All ioctl subcommand will modify user dargs,
+	 * Don't override return value unless copy fails
+	 */
+	if (copy_to_user(args, dargs, sizeof(*dargs)))
+		ret = -EFAULT;
+out:
+	kfree(dargs);
+	return ret;
+}
+
 static int clone_finish_inode_update(struct btrfs_trans_handle *trans,
 				     struct inode *inode,
 				     u64 endoff,
@@ -5933,6 +5996,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_get_fslabel(file, argp);
 	case BTRFS_IOC_SET_FSLABEL:
 		return btrfs_ioctl_set_fslabel(file, argp);
+	case BTRFS_IOC_DEDUPE_CTL:
+		return btrfs_ioctl_dedupe_ctl(root, argp);
 	case BTRFS_IOC_GET_SUPPORTED_FEATURES:
 		return btrfs_ioctl_get_supported_features(argp);
 	case BTRFS_IOC_GET_FEATURES:
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 3717c864ba23..26f6f283fac2 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -192,6 +192,7 @@ BTRFS_FEAT_ATTR_INCOMPAT(raid56, RAID56);
 BTRFS_FEAT_ATTR_INCOMPAT(skinny_metadata, SKINNY_METADATA);
 BTRFS_FEAT_ATTR_INCOMPAT(no_holes, NO_HOLES);
 BTRFS_FEAT_ATTR_COMPAT_RO(free_space_tree, FREE_SPACE_TREE);
+BTRFS_FEAT_ATTR_COMPAT_RO(dedupe, DEDUPE);
 
 static struct attribute *btrfs_supported_feature_attrs[] = {
 	BTRFS_FEAT_ATTR_PTR(mixed_backref),
@@ -205,6 +206,7 @@ static struct attribute *btrfs_supported_feature_attrs[] = {
 	BTRFS_FEAT_ATTR_PTR(skinny_metadata),
 	BTRFS_FEAT_ATTR_PTR(no_holes),
 	BTRFS_FEAT_ATTR_PTR(free_space_tree),
+	BTRFS_FEAT_ATTR_PTR(dedupe),
 	NULL
 };
 
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index ba879ac931f2..5ee51fac3652 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -253,6 +253,7 @@ struct btrfs_ioctl_fs_info_args {
  * first mount when booting older kernel versions.
  */
 #define BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE_VALID	(1ULL << 1)
+#define BTRFS_FEATURE_COMPAT_RO_DEDUPE		(1ULL << 2)
 
 #define BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF	(1ULL << 0)
 #define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(1ULL << 1)
@@ -685,7 +686,14 @@ struct btrfs_ioctl_get_dev_stats {
 
 /* Default dedupe limit on number of hash */
 #define BTRFS_DEDUPE_LIMIT_NR_DEFAULT	(32 * 1024)
-
+/*
+ * de-duplication control modes
+ * For re-config, re-enable will handle it
+ */
+#define BTRFS_DEDUPE_CTL_ENABLE	1
+#define BTRFS_DEDUPE_CTL_DISABLE 2
+#define BTRFS_DEDUPE_CTL_STATUS	3
+#define BTRFS_DEDUPE_CTL_LAST	4
 /*
  * This structure is used for dedupe enable/disable/configure
  * and status ioctl.
@@ -961,6 +969,8 @@ enum btrfs_err_code {
 				    struct btrfs_ioctl_dev_replace_args)
 #define BTRFS_IOC_FILE_EXTENT_SAME _IOWR(BTRFS_IOCTL_MAGIC, 54, \
 					 struct btrfs_ioctl_same_args)
+#define BTRFS_IOC_DEDUPE_CTL	_IOWR(BTRFS_IOCTL_MAGIC, 55, \
+				      struct btrfs_ioctl_dedupe_args)
 #define BTRFS_IOC_GET_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 57, \
 				   struct btrfs_ioctl_feature_flags)
 #define BTRFS_IOC_SET_FEATURES _IOW(BTRFS_IOCTL_MAGIC, 57, \
-- 
2.18.0
