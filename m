Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18597 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab3L3IN3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Dec 2013 03:13:29 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Marcel Ritter <ritter.marcel@gmail.com>,
        Christian Robert <christian.robert@polymtl.ca>,
        "alanqk@gmail.com" <alanqk@gmail.com>
Subject: [PATCH v8 12/14] Btrfs: add ioctl of dedup control
Date: Mon, 30 Dec 2013 16:12:52 +0800
Message-Id: <1388391175-29539-13-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1388391175-29539-1-git-send-email-bo.li.liu@oracle.com>
References: <1388391175-29539-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So far we have 4 commands to control dedup behaviour,
- btrfs dedup enable
Create the dedup tree, and it's the very first step when you're going to use
the dedup feature.

- btrfs dedup disable
Delete the dedup tree, after this we're not able to use dedup any more unless
you enable it again.

- btrfs dedup on [-b]
Switch on the dedup feature temporarily, and it's the second step of applying
dedup with writes.  Option '-b' is used to set dedup blocksize.
The default blocksize is 8192(no special reason, you may argue), and the current
limit is [4096, 128 * 1024], because 4K is the generic page size and 128K is the
upper limit of btrfs's compression.

- btrfs dedup off
Switch off the dedup feature temporarily, but the dedup tree remains.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.h           |   3 +
 fs/btrfs/disk-io.c         |   1 +
 fs/btrfs/ioctl.c           | 167 +++++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/btrfs.h |  11 +++
 4 files changed, 182 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 52b2843..1b89d6c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1715,6 +1715,9 @@ struct btrfs_fs_info {
 	u64 dedup_bs;
 
 	int dedup_type;
+
+	/* protect user change for dedup operations */
+	struct mutex dedup_ioctl_mutex;
 };
 
 /*
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2c83de7..9c9667d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2314,6 +2314,7 @@ int open_ctree(struct super_block *sb,
 	mutex_init(&fs_info->dev_replace.lock_finishing_cancel_unmount);
 	mutex_init(&fs_info->dev_replace.lock_management_lock);
 	mutex_init(&fs_info->dev_replace.lock);
+	mutex_init(&fs_info->dedup_ioctl_mutex);
 
 	spin_lock_init(&fs_info->qgroup_lock);
 	mutex_init(&fs_info->qgroup_ioctl_lock);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 347bf61..75fb3de 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4481,6 +4481,171 @@ out_unlock:
 	return ret;
 }
 
+static long btrfs_enable_dedup(struct btrfs_root *root)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_trans_handle *trans = NULL;
+	struct btrfs_root *dedup_root;
+	int ret = 0;
+
+	mutex_lock(&fs_info->dedup_ioctl_mutex);
+	if (fs_info->dedup_root) {
+		pr_info("btrfs: dedup has already been enabled\n");
+		mutex_unlock(&fs_info->dedup_ioctl_mutex);
+		return 0;
+	}
+
+	trans = btrfs_start_transaction(root, 2);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		mutex_unlock(&fs_info->dedup_ioctl_mutex);
+		return ret;
+	}
+
+	dedup_root = btrfs_create_tree(trans, fs_info,
+				       BTRFS_DEDUP_TREE_OBJECTID);
+	if (IS_ERR(dedup_root))
+		ret = PTR_ERR(dedup_root);
+
+	if (ret)
+		btrfs_end_transaction(trans, root);
+	else
+		ret = btrfs_commit_transaction(trans, root);
+
+	if (!ret) {
+		pr_info("btrfs: dedup enabled\n");
+		fs_info->dedup_root = dedup_root;
+		fs_info->dedup_root->block_rsv = &fs_info->global_block_rsv;
+		btrfs_set_fs_incompat(fs_info, DEDUP);
+	}
+
+	mutex_unlock(&fs_info->dedup_ioctl_mutex);
+	return ret;
+}
+
+static long btrfs_disable_dedup(struct btrfs_root *root)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_root *dedup_root;
+	int ret;
+
+	mutex_lock(&fs_info->dedup_ioctl_mutex);
+	if (!fs_info->dedup_root) {
+		pr_info("btrfs: dedup has been disabled\n");
+		mutex_unlock(&fs_info->dedup_ioctl_mutex);
+		return 0;
+	}
+
+	if (fs_info->dedup_bs != 0) {
+		pr_info("btrfs: cannot disable dedup until switching off dedup!\n");
+		mutex_unlock(&fs_info->dedup_ioctl_mutex);
+		return -EBUSY;
+	}
+
+	dedup_root = fs_info->dedup_root;
+
+	ret = btrfs_drop_snapshot(dedup_root, NULL, 1, 0);
+
+	if (!ret) {
+		fs_info->dedup_root = NULL;
+		pr_info("btrfs: dedup disabled\n");
+	}
+
+	mutex_unlock(&fs_info->dedup_ioctl_mutex);
+	WARN_ON(ret < 0 && ret != -EAGAIN && ret != -EROFS);
+	return ret;
+}
+
+static long btrfs_set_dedup_bs(struct btrfs_root *root, u64 bs)
+{
+	struct btrfs_fs_info *info = root->fs_info;
+	int ret = 0;
+
+	mutex_lock(&info->dedup_ioctl_mutex);
+	if (!info->dedup_root) {
+		pr_info("btrfs: dedup is disabled, we cannot switch on/off dedup\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	bs = ALIGN(bs, root->sectorsize);
+	bs = min_t(u64, bs, (128 * 1024ULL));
+
+	if (bs == info->dedup_bs) {
+		if (info->dedup_bs == 0)
+			pr_info("btrfs: switch OFF dedup(it's already off)\n");
+		else
+			pr_info("btrfs: switch ON dedup(its bs is already %llu)\n",
+				bs);
+		goto out;
+	}
+
+	/*
+	 * The dedup works similar to compression, both use async workqueue to
+	 * reach better performance.  We drain the on-going async works here
+	 * so that new dedup writes will apply with the new dedup blocksize.
+	 */
+	atomic_inc(&info->async_submit_draining);
+	while (atomic_read(&info->nr_async_submits) ||
+	       atomic_read(&info->async_delalloc_pages)) {
+		wait_event(info->async_submit_wait,
+			   (atomic_read(&info->nr_async_submits) == 0 &&
+			    atomic_read(&info->async_delalloc_pages) == 0));
+	}
+
+	/*
+	 * dedup_bs = 0: dedup off;
+	 * dedup_bs > 0: dedup on;
+	 */
+	info->dedup_bs = bs;
+	if (info->dedup_bs == 0) {
+		pr_info("btrfs: switch OFF dedup\n");
+	} else {
+		info->dedup_bs = bs;
+		pr_info("btrfs: switch ON dedup(dedup blocksize %llu)\n",
+			info->dedup_bs);
+	}
+	atomic_dec(&info->async_submit_draining);
+
+out:
+	mutex_unlock(&info->dedup_ioctl_mutex);
+	return ret;
+}
+
+static long btrfs_ioctl_dedup_ctl(struct btrfs_root *root, void __user *args)
+{
+	struct btrfs_ioctl_dedup_args *dargs;
+	int ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	dargs = memdup_user(args, sizeof(*dargs));
+	if (IS_ERR(dargs)) {
+		ret = PTR_ERR(dargs);
+		goto out;
+	}
+
+	switch (dargs->cmd) {
+	case BTRFS_DEDUP_CTL_ENABLE:
+		ret = btrfs_enable_dedup(root);
+		break;
+	case BTRFS_DEDUP_CTL_DISABLE:
+		ret = btrfs_disable_dedup(root);
+		break;
+	case BTRFS_DEDUP_CTL_SET_BS:
+		/* dedup on/off */
+		ret = btrfs_set_dedup_bs(root, dargs->bs);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	kfree(dargs);
+out:
+	return ret;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -4599,6 +4764,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_set_fslabel(file, argp);
 	case BTRFS_IOC_FILE_EXTENT_SAME:
 		return btrfs_ioctl_file_extent_same(file, argp);
+	case BTRFS_IOC_DEDUP_CTL:
+		return btrfs_ioctl_dedup_ctl(root, argp);
 	}
 
 	return -ENOTTY;
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 45e6189..eda8b92 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -399,6 +399,15 @@ struct btrfs_ioctl_get_dev_stats {
 	__u64 unused[128 - 2 - BTRFS_DEV_STAT_VALUES_MAX]; /* pad to 1k */
 };
 
+/* deduplication control ioctl modes */
+#define BTRFS_DEDUP_CTL_ENABLE 1
+#define BTRFS_DEDUP_CTL_DISABLE 2
+#define BTRFS_DEDUP_CTL_SET_BS 3
+struct btrfs_ioctl_dedup_args {
+	__u64 cmd;
+	__u64 bs;
+};
+
 #define BTRFS_QUOTA_CTL_ENABLE	1
 #define BTRFS_QUOTA_CTL_DISABLE	2
 #define BTRFS_QUOTA_CTL_RESCAN__NOTUSED	3
@@ -606,5 +615,7 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 				    struct btrfs_ioctl_dev_replace_args)
 #define BTRFS_IOC_FILE_EXTENT_SAME _IOWR(BTRFS_IOCTL_MAGIC, 54, \
 					 struct btrfs_ioctl_same_args)
+#define BTRFS_IOC_DEDUP_CTL _IOWR(BTRFS_IOCTL_MAGIC, 55, \
+				 struct btrfs_ioctl_dedup_args)
 
 #endif /* _UAPI_LINUX_BTRFS_H */
-- 
1.8.2.1

