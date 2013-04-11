Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:35554 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751225Ab3DKKe3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Apr 2013 06:34:29 -0400
Message-ID: <516691F0.4080204@cn.fujitsu.com>
Date: Thu, 11 Apr 2013 18:35:28 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 2/2] Btrfs: introduce noextiref mount option
References: <51669144.20107@cn.fujitsu.com>
In-Reply-To: <51669144.20107@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now, we set incompat flag EXTEND_IREF when we actually need insert a
extend inode reference, not when making a fs. But some users may hope
that the fs still can be mounted on the old kernel, and don't hope we
insert any extend inode references. So we introduce noextiref mount
option to close this function.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Cc: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/ctree.h      |  1 +
 fs/btrfs/disk-io.c    |  9 +++++++++
 fs/btrfs/inode-item.c |  2 +-
 fs/btrfs/super.c      | 41 ++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index a883e47..db88963 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1911,6 +1911,7 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_MOUNT_CHECK_INTEGRITY	(1 << 20)
 #define BTRFS_MOUNT_CHECK_INTEGRITY_INCLUDING_EXTENT_DATA (1 << 21)
 #define BTRFS_MOUNT_PANIC_ON_FATAL_ERROR	(1 << 22)
+#define BTRFS_MOUNT_NOEXTIREF		(1 << 23)
 
 #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
 #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index ab8ef37..ee00448 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2269,6 +2269,15 @@ int open_ctree(struct super_block *sb,
 		goto fail_alloc;
 	}
 
+	if ((btrfs_super_incompat_flags(disk_super) &
+	     BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF) &&
+	    btrfs_test_opt(tree_root, NOEXTIREF)) {
+		printk(KERN_ERR "BTRFS: couldn't mount because the extend iref"
+		       "can not be close.\n");
+		err = -EINVAL;
+		goto fail_alloc;
+	}
+
 	if (btrfs_super_leafsize(disk_super) !=
 	    btrfs_super_nodesize(disk_super)) {
 		printk(KERN_ERR "BTRFS: couldn't mount because metadata "
diff --git a/fs/btrfs/inode-item.c b/fs/btrfs/inode-item.c
index f07eb45..7c4f880 100644
--- a/fs/btrfs/inode-item.c
+++ b/fs/btrfs/inode-item.c
@@ -442,7 +442,7 @@ int btrfs_insert_inode_ref(struct btrfs_trans_handle *trans,
 out:
 	btrfs_free_path(path);
 
-	if (ret == -EMLINK) {
+	if (ret == -EMLINK && !btrfs_test_opt(root, NOEXTIREF)) {
 		/*
 		 * We ran out of space in the ref array. Need to add an
 		 * extended ref.
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0f03569..fd375b3 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -315,7 +315,7 @@ enum {
 	Opt_nodatacow, Opt_max_inline, Opt_alloc_start, Opt_nobarrier, Opt_ssd,
 	Opt_nossd, Opt_ssd_spread, Opt_thread_pool, Opt_noacl, Opt_compress,
 	Opt_compress_type, Opt_compress_force, Opt_compress_force_type,
-	Opt_notreelog, Opt_ratio, Opt_flushoncommit, Opt_discard,
+	Opt_notreelog, Opt_noextiref, Opt_ratio, Opt_flushoncommit, Opt_discard,
 	Opt_space_cache, Opt_clear_cache, Opt_user_subvol_rm_allowed,
 	Opt_enospc_debug, Opt_subvolrootid, Opt_defrag, Opt_inode_cache,
 	Opt_no_space_cache, Opt_recovery, Opt_skip_balance,
@@ -344,6 +344,7 @@ static match_table_t tokens = {
 	{Opt_nossd, "nossd"},
 	{Opt_noacl, "noacl"},
 	{Opt_notreelog, "notreelog"},
+	{Opt_noextiref, "noextiref"},
 	{Opt_flushoncommit, "flushoncommit"},
 	{Opt_ratio, "metadata_ratio=%d"},
 	{Opt_discard, "discard"},
@@ -535,6 +536,10 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			printk(KERN_INFO "btrfs: disabling tree log\n");
 			btrfs_set_opt(info->mount_opt, NOTREELOG);
 			break;
+		case Opt_noextiref:
+			printk(KERN_INFO "btrfs: disabling extend inode ref\n");
+			btrfs_set_opt(info->mount_opt, NOEXTIREF);
+			break;
 		case Opt_flushoncommit:
 			printk(KERN_INFO "btrfs: turning on flush-on-commit\n");
 			btrfs_set_opt(info->mount_opt, FLUSHONCOMMIT);
@@ -1202,6 +1207,35 @@ static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
 			      new_pool_size);
 }
 
+static int btrfs_close_extend_iref(struct btrfs_fs_info *fs_info,
+				   unsigned long old_opts)
+{
+	struct btrfs_trans_handle *trans;
+	int ret;
+
+	if (btrfs_raw_test_opt(old_opts, NOEXTIREF) ||
+	    !btrfs_raw_test_opt(fs_info->mount_opt, NOEXTIREF))
+		return 0;
+
+	trans = btrfs_attach_transaction(fs_info->tree_root);
+	if (IS_ERR(trans)) {
+		if (PTR_ERR(trans) != -ENOENT)
+			return PTR_ERR(trans);
+	} else {
+		ret = btrfs_commit_transaction(trans, fs_info->tree_root);
+		if (ret)
+			return ret;
+	}
+
+	if (btrfs_super_incompat_flags(fs_info->super_copy) &
+	    BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF) {
+		printk(KERN_ERR "BTRFS: could not close extend iref.\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static inline void btrfs_remount_prepare(struct btrfs_fs_info *fs_info)
 {
 	set_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state);
@@ -1259,6 +1293,11 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 	}
 
 	btrfs_remount_begin(fs_info, old_opts, *flags);
+
+	ret = btrfs_close_extend_iref(fs_info, old_opts);
+	if (ret)
+		goto restore;
+
 	btrfs_resize_thread_pool(fs_info,
 		fs_info->thread_pool_size, old_thread_pool_size);
 
-- 
1.8.0.1

