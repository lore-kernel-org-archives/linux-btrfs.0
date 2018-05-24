Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:46744 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S971634AbeEXVlp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 May 2018 17:41:45 -0400
Received: by mail-pl0-f66.google.com with SMTP id 30-v6so1819567pld.13
        for <linux-btrfs@vger.kernel.org>; Thu, 24 May 2018 14:41:44 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, linux-fsdevel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [RFC PATCH v4 4/6] Btrfs: prevent ioctls from interfering with a swap file
Date: Thu, 24 May 2018 14:41:28 -0700
Message-Id: <296f04a07350c9cc2032e03f78c1a7284747fb50.1527197312.git.osandov@fb.com>
In-Reply-To: <cover.1527197312.git.osandov@fb.com>
References: <cover.1527197312.git.osandov@fb.com>
In-Reply-To: <cover.1527197312.git.osandov@fb.com>
References: <cover.1527197312.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

When a swap file is active, we must make sure that the extents of the
file are not moved and that they don't become shared. That means that
the following are not safe:

- chattr +c (enable compression)
- reflink
- dedupe
- snapshot
- defrag
- balance
- device remove/replace/resize

Don't allow those to happen on an active swap file. Balance and device
remove/replace/resize in particular are disallowed entirely; in the
future, we can relax this so that relocation skips/errors out only on
chunks containing an active swap file.

Note that we don't have to worry about chattr -C (disable nocow), which
we ignore for non-empty files, because an active swapfile must be
non-empty and can't be truncated. We also don't have to worry about
autodefrag because it's only done on COW files. Truncate and fallocate
are already taken care of by the generic code. Device add doesn't do
relocation so it's not an issue, either.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/ctree.h   |  6 ++++++
 fs/btrfs/disk-io.c |  3 +++
 fs/btrfs/ioctl.c   | 51 ++++++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/volumes.c |  8 ++++++++
 4 files changed, 64 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 6deb39d8415d..280d7f5e2fe4 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1117,6 +1117,9 @@ struct btrfs_fs_info {
 	u32 sectorsize;
 	u32 stripesize;
 
+	/* Number of active swapfiles */
+	atomic_t nr_swapfiles;
+
 #ifdef CONFIG_BTRFS_FS_REF_VERIFY
 	spinlock_t ref_verify_lock;
 	struct rb_root block_tree;
@@ -1282,6 +1285,9 @@ struct btrfs_root {
 	spinlock_t qgroup_meta_rsv_lock;
 	u64 qgroup_meta_rsv_pertrans;
 	u64 qgroup_meta_rsv_prealloc;
+
+	/* Number of active swapfiles */
+	atomic_t nr_swapfiles;
 };
 
 struct btrfs_file_private {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 22171bbe86e3..b42fd6b41b20 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1215,6 +1215,7 @@ static void __setup_root(struct btrfs_root *root, struct btrfs_fs_info *fs_info,
 	atomic_set(&root->log_batch, 0);
 	refcount_set(&root->refs, 1);
 	atomic_set(&root->will_be_snapshotted, 0);
+	atomic_set(&root->nr_swapfiles, 0);
 	root->log_transid = 0;
 	root->log_transid_committed = -1;
 	root->last_log_commit = 0;
@@ -2825,6 +2826,8 @@ int open_ctree(struct super_block *sb,
 	fs_info->sectorsize = 4096;
 	fs_info->stripesize = 4096;
 
+	atomic_set(&fs_info->nr_swapfiles, 0);
+
 	ret = btrfs_alloc_stripe_hash_table(fs_info);
 	if (ret) {
 		err = ret;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 82be4a94334b..5f068aabe612 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -295,6 +295,11 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	} else if (fsflags & FS_COMPR_FL) {
 		const char *comp;
 
+		if (IS_SWAPFILE(inode)) {
+			ret = -ETXTBSY;
+			goto out_unlock;
+		}
+
 		binode->flags |= BTRFS_INODE_COMPRESS;
 		binode->flags &= ~BTRFS_INODE_NOCOMPRESS;
 
@@ -767,6 +772,12 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 	if (!test_bit(BTRFS_ROOT_REF_COWS, &root->state))
 		return -EINVAL;
 
+	if (atomic_read(&root->nr_swapfiles)) {
+		btrfs_info(fs_info,
+			   "cannot create snapshot with active swapfile");
+		return -ETXTBSY;
+	}
+
 	pending_snapshot = kzalloc(sizeof(*pending_snapshot), GFP_KERNEL);
 	if (!pending_snapshot)
 		return -ENOMEM;
@@ -1504,9 +1515,13 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 		}
 
 		inode_lock(inode);
-		if (do_compress)
-			BTRFS_I(inode)->defrag_compress = compress_type;
-		ret = cluster_pages_for_defrag(inode, pages, i, cluster);
+		if (IS_SWAPFILE(inode)) {
+			ret = -ETXTBSY;
+		} else {
+			if (do_compress)
+				BTRFS_I(inode)->defrag_compress = compress_type;
+			ret = cluster_pages_for_defrag(inode, pages, i, cluster);
+		}
 		if (ret < 0) {
 			inode_unlock(inode);
 			goto out_ra;
@@ -1602,6 +1617,12 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 		return BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
 	}
 
+	if (atomic_read(&fs_info->nr_swapfiles)) {
+		btrfs_info(fs_info, "cannot resize with active swapfile");
+		ret = -ETXTBSY;
+		goto out;
+	}
+
 	vol_args = memdup_user(arg, sizeof(*vol_args));
 	if (IS_ERR(vol_args)) {
 		ret = PTR_ERR(vol_args);
@@ -3614,6 +3635,11 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 		goto out;
 	}
 
+	if (IS_SWAPFILE(src) || IS_SWAPFILE(dst)) {
+		ret = -ETXTBSY;
+		goto out;
+	}
+
 	for (i = 0; i < chunk_count; i++) {
 		ret = btrfs_extent_same_range(src, loff, BTRFS_MAX_DEDUPE_LEN,
 					      dst, dst_loff, &cmp);
@@ -4286,6 +4312,11 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
 		goto out_unlock;
 	}
 
+	if (IS_SWAPFILE(src) || IS_SWAPFILE(inode)) {
+		ret = -ETXTBSY;
+		goto out_unlock;
+	}
+
 	/* determine range to clone */
 	ret = -EINVAL;
 	if (off + len > src->i_size || off + len < off)
@@ -4764,7 +4795,13 @@ static long btrfs_ioctl_dev_replace(struct btrfs_fs_info *fs_info,
 		if (test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags)) {
 			ret = BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
 		} else {
-			ret = btrfs_dev_replace_by_ioctl(fs_info, p);
+			if (atomic_read(&fs_info->nr_swapfiles)) {
+				btrfs_info(fs_info,
+					   "cannot replace device with active swapfile");
+				ret = -ETXTBSY;
+			} else {
+				ret = btrfs_dev_replace_by_ioctl(fs_info, p);
+			}
 			clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
 		}
 		break;
@@ -5024,6 +5061,12 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
 locked:
 	BUG_ON(!test_bit(BTRFS_FS_EXCL_OP, &fs_info->flags));
 
+	if (atomic_read(&fs_info->nr_swapfiles)) {
+		btrfs_info(fs_info, "cannot balance with active swapfile");
+		ret = -ETXTBSY;
+		goto out_unlock;
+	}
+
 	if (arg) {
 		bargs = memdup_user(arg, sizeof(*bargs));
 		if (IS_ERR(bargs)) {
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9cfac177214f..33b3d329ebb9 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1954,6 +1954,13 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 	if (test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags))
 		return BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
 
+	if (atomic_read(&fs_info->nr_swapfiles)) {
+		btrfs_info(fs_info,
+			   "cannot remove device with active swapfile");
+		ret = -ETXTBSY;
+		goto out_clear;
+	}
+
 	mutex_lock(&uuid_mutex);
 
 	num_devices = fs_devices->num_devices;
@@ -2072,6 +2079,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 
 out:
 	mutex_unlock(&uuid_mutex);
+out_clear:
 	clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
 	return ret;
 
-- 
2.17.0

