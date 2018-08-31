Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34488 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727477AbeIACq0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Aug 2018 22:46:26 -0400
Received: by mail-pl1-f196.google.com with SMTP id f6-v6so6078856plo.1
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2018 15:36:51 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH v5 4/6] Btrfs: prevent ioctls from interfering with a swap file
Date: Fri, 31 Aug 2018 15:36:39 -0700
Message-Id: <a82cb0e54321aa399008961853fdeaefa037b24d.1535754957.git.osandov@fb.com>
In-Reply-To: <cover.1535754957.git.osandov@fb.com>
References: <cover.1535754957.git.osandov@fb.com>
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
 fs/btrfs/volumes.c |  6 ++++++
 4 files changed, 62 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 53af9f5253f4..1c767a6394ae 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1121,6 +1121,9 @@ struct btrfs_fs_info {
 	u32 sectorsize;
 	u32 stripesize;
 
+	/* Number of active swapfiles */
+	atomic_t nr_swapfiles;
+
 #ifdef CONFIG_BTRFS_FS_REF_VERIFY
 	spinlock_t ref_verify_lock;
 	struct rb_root block_tree;
@@ -1285,6 +1288,9 @@ struct btrfs_root {
 	spinlock_t qgroup_meta_rsv_lock;
 	u64 qgroup_meta_rsv_pertrans;
 	u64 qgroup_meta_rsv_prealloc;
+
+	/* Number of active swapfiles */
+	atomic_t nr_swapfiles;
 };
 
 struct btrfs_file_private {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 5124c15705ce..50ee5cd3efae 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1187,6 +1187,7 @@ static void __setup_root(struct btrfs_root *root, struct btrfs_fs_info *fs_info,
 	atomic_set(&root->log_batch, 0);
 	refcount_set(&root->refs, 1);
 	atomic_set(&root->will_be_snapshotted, 0);
+	atomic_set(&root->nr_swapfiles, 0);
 	root->log_transid = 0;
 	root->log_transid_committed = -1;
 	root->last_log_commit = 0;
@@ -2781,6 +2782,8 @@ int open_ctree(struct super_block *sb,
 	fs_info->sectorsize = 4096;
 	fs_info->stripesize = 4096;
 
+	atomic_set(&fs_info->nr_swapfiles, 0);
+
 	ret = btrfs_alloc_stripe_hash_table(fs_info);
 	if (ret) {
 		err = ret;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 63600dc2ac4c..cc230dcd32a4 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -290,6 +290,11 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	} else if (fsflags & FS_COMPR_FL) {
 		const char *comp;
 
+		if (IS_SWAPFILE(inode)) {
+			ret = -ETXTBSY;
+			goto out_unlock;
+		}
+
 		binode->flags |= BTRFS_INODE_COMPRESS;
 		binode->flags &= ~BTRFS_INODE_NOCOMPRESS;
 
@@ -751,6 +756,12 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 	if (!test_bit(BTRFS_ROOT_REF_COWS, &root->state))
 		return -EINVAL;
 
+	if (atomic_read(&root->nr_swapfiles)) {
+		btrfs_info(fs_info,
+			   "cannot snapshot subvolume with active swapfile");
+		return -ETXTBSY;
+	}
+
 	pending_snapshot = kzalloc(sizeof(*pending_snapshot), GFP_KERNEL);
 	if (!pending_snapshot)
 		return -ENOMEM;
@@ -1487,9 +1498,13 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
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
@@ -1585,6 +1600,12 @@ static noinline int btrfs_ioctl_resize(struct file *file,
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
@@ -3538,6 +3559,11 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 		goto out_unlock;
 	}
 
+	if (IS_SWAPFILE(src) || IS_SWAPFILE(dst)) {
+		ret = -ETXTBSY;
+		goto out_unlock;
+	}
+
 	tail_len = olen % BTRFS_MAX_DEDUPE_LEN;
 	chunk_count = div_u64(olen, BTRFS_MAX_DEDUPE_LEN);
 	if (chunk_count == 0)
@@ -4234,6 +4260,11 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
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
@@ -4712,7 +4743,13 @@ static long btrfs_ioctl_dev_replace(struct btrfs_fs_info *fs_info,
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
@@ -4972,6 +5009,12 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
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
index da86706123ff..c03ef5322689 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1863,6 +1863,12 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 	u64 num_devices;
 	int ret = 0;
 
+	if (atomic_read(&fs_info->nr_swapfiles)) {
+		btrfs_info(fs_info,
+			   "cannot remove device with active swapfile");
+		return -ETXTBSY;
+	}
+
 	mutex_lock(&uuid_mutex);
 
 	num_devices = fs_devices->num_devices;
-- 
2.18.0
