From: liubo <liubo2009@cn.fujitsu.com>
Subject: [RFC PATCH 4/4 v2] Btrfs: deal with filesystem state at mount, umount
Date: Wed, 01 Dec 2010 18:21:50 +0800
Message-ID: <4CF621BE.2080201@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>, liubo <liubo2009@cn.fujitsu.com>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Since there is a filesystem state, we should deal with it carefully at mount,
 umount and remount.

- At mount, the FS state should be checked if there is error on these FS.
  If it does have, btrfsck is recommended.
- At umount, the FS state should be saved into disk for consistency.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c |   47 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 46 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b40dfe4..663d360 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -43,6 +43,8 @@
 static struct extent_io_ops btree_extent_io_ops;
 static void end_workqueue_fn(struct btrfs_work *work);
 static void free_fs_root(struct btrfs_root *root);
+static void btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
+				     int read_only);
 
 /*
  * end_io_wq structs are used to do processing in task context when an IO is
@@ -1700,6 +1702,11 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	if (!btrfs_super_root(disk_super))
 		goto fail_iput;
 
+	/* check filesystem state */
+	fs_info->fs_state |= btrfs_super_flags(disk_super);
+
+	btrfs_check_super_valid(fs_info, sb->s_flags & MS_RDONLY);
+
 	ret = btrfs_parse_options(tree_root, options);
 	if (ret) {
 		err = ret;
@@ -2405,10 +2412,17 @@ int btrfs_commit_super(struct btrfs_root *root)
 	up_write(&root->fs_info->cleanup_work_sem);
 
 	trans = btrfs_join_transaction(root, 1);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
 	ret = btrfs_commit_transaction(trans, root);
 	BUG_ON(ret);
+
 	/* run commit again to drop the original snapshot */
 	trans = btrfs_join_transaction(root, 1);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
 	btrfs_commit_transaction(trans, root);
 	ret = btrfs_write_and_wait_transaction(NULL, root);
 	BUG_ON(ret);
@@ -2426,8 +2440,28 @@ int close_ctree(struct btrfs_root *root)
 	smp_mb();
 
 	btrfs_put_block_group_cache(fs_info);
+
+	/*
+	 * Here come 2 situations when btrfs flips readonly:
+	 *
+	 * 1. when btrfs flips readonly somewhere else before
+	 * btrfs_commit_super, sb->s_flags has MS_RDONLY flag,
+	 * and btrfs will skip to write sb directly to keep
+	 * ERROR state on disk.
+	 *
+	 * 2. when btrfs flips readonly just in btrfs_commit_super,
+	 * and in such case, btrfs cannnot write sb via btrfs_commit_super,
+	 * and since fs_state has been set BTRFS_SUPER_FLAG_ERROR flag,
+	 * btrfs will directly write sb.
+	 */
 	if (!(fs_info->sb->s_flags & MS_RDONLY)) {
-		ret =  btrfs_commit_super(root);
+		ret = btrfs_commit_super(root);
+		if (ret)
+			printk(KERN_ERR "btrfs: commit super ret %d\n", ret);
+	}
+
+	if (fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR) {
+		ret = write_ctree_super(NULL, root, 0);
 		if (ret)
 			printk(KERN_ERR "btrfs: commit super ret %d\n", ret);
 	}
@@ -2603,6 +2637,17 @@ out:
 	return 0;
 }
 
+static void btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
+			      int read_only)
+{
+	if (read_only)
+		return;
+
+	if (fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR)
+		printk(KERN_WARNING "warning: mount fs with errors, "
+		       "running btfsck is recommended\n");
+}
+
 static struct extent_io_ops btree_extent_io_ops = {
 	.write_cache_pages_lock_hook = btree_lock_page_hook,
 	.readpage_end_io_hook = btree_readpage_end_io_hook,
-- 
1.7.1
