Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:61498 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753782Ab3AJMnO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jan 2013 07:43:14 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r0AChCGk022026
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jan 2013 20:43:12 +0800
Message-ID: <50EEB786.8080605@cn.fujitsu.com>
Date: Thu, 10 Jan 2013 20:43:50 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 02/11] Btrfs: use atomic for fs_info->last_trans_committed
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

fs_info->last_trans_committed is a 64bits variant, we might get a wrong
value on the 32bit machines if we access it directly. Fix it by atomic
operation.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.h        |  2 +-
 fs/btrfs/disk-io.c      |  2 +-
 fs/btrfs/file.c         |  2 +-
 fs/btrfs/ioctl.c        |  2 +-
 fs/btrfs/ordered-data.c |  2 +-
 fs/btrfs/scrub.c        |  2 +-
 fs/btrfs/transaction.c  |  5 +++--
 fs/btrfs/tree-log.c     | 16 +++++++++-------
 8 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index c3edb22..34a60a8 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1279,7 +1279,7 @@ struct btrfs_fs_info {
 	struct btrfs_block_rsv empty_block_rsv;
 
 	atomic64_t generation;
-	u64 last_trans_committed;
+	atomic64_t last_trans_committed;
 
 	/*
 	 * this is updated to the current trans every time a full commit
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2d69541..9263c6e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2502,7 +2502,7 @@ retry_root_backup:
 	}
 
 	atomic64_set(&fs_info->generation, generation);
-	fs_info->last_trans_committed = generation;
+	atomic64_set(&fs_info->last_trans_committed, generation);
 
 	ret = btrfs_recover_balance(fs_info);
 	if (ret) {
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 024246b..3e9fa0e 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1683,7 +1683,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	if (btrfs_inode_in_log(inode,
 	    atomic64_read(&root->fs_info->generation)) ||
 	    BTRFS_I(inode)->last_trans <=
-	    root->fs_info->last_trans_committed) {
+	    atomic64_read(&root->fs_info->last_trans_committed)) {
 		BTRFS_I(inode)->last_trans = 0;
 
 		/*
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7624212..804c57f 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3110,7 +3110,7 @@ static noinline long btrfs_ioctl_start_sync(struct btrfs_root *root,
 			return PTR_ERR(trans);
 
 		/* No running transaction, don't bother */
-		transid = root->fs_info->last_trans_committed;
+		transid = atomic64_read(&root->fs_info->last_trans_committed);
 		goto out;
 	}
 	transid = trans->transid;
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index f107312..f376621 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -975,7 +975,7 @@ void btrfs_add_ordered_operation(struct btrfs_trans_handle *trans,
 	 * if this file hasn't been changed since the last transaction
 	 * commit, we can safely return without doing anything
 	 */
-	if (last_mod < root->fs_info->last_trans_committed)
+	if (last_mod < atomic64_read(&root->fs_info->last_trans_committed))
 		return;
 
 	spin_lock(&root->fs_info->ordered_extent_lock);
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index bdbb94f..af0b566 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2703,7 +2703,7 @@ static noinline_for_stack int scrub_supers(struct scrub_ctx *sctx,
 	if (root->fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR)
 		return -EIO;
 
-	gen = root->fs_info->last_trans_committed;
+	gen = atomic64_read(&root->fs_info->last_trans_committed);
 
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		bytenr = btrfs_sb_offset(i);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index e7992ca..7999bf8 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -459,7 +459,8 @@ int btrfs_wait_for_commit(struct btrfs_root *root, u64 transid)
 	int ret = 0;
 
 	if (transid) {
-		if (transid <= root->fs_info->last_trans_committed)
+		if (transid <=
+		    atomic64_read(&root->fs_info->last_trans_committed))
 			goto out;
 
 		ret = -EINVAL;
@@ -1713,7 +1714,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 
 	cur_trans->commit_done = 1;
 
-	root->fs_info->last_trans_committed = cur_trans->transid;
+	atomic64_set(&root->fs_info->last_trans_committed, cur_trans->transid);
 
 	wake_up(&cur_trans->commit_wait);
 
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 83186c7..e6c8eb2 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3392,7 +3392,7 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 	INIT_LIST_HEAD(&extents);
 
 	write_lock(&tree->lock);
-	test_gen = root->fs_info->last_trans_committed;
+	test_gen = atomic64_read(&root->fs_info->last_trans_committed);
 
 	list_for_each_entry_safe(em, n, &tree->modified_extents, list) {
 		list_del_init(&em->list);
@@ -3496,7 +3496,8 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 
 	/* Only run delayed items if we are a dir or a new file */
 	if (S_ISDIR(inode->i_mode) ||
-	    BTRFS_I(inode)->generation > root->fs_info->last_trans_committed) {
+	    BTRFS_I(inode)->generation >
+	    atomic64_read(&root->fs_info->last_trans_committed)) {
 		ret = btrfs_commit_inode_delayed_items(trans, inode);
 		if (ret) {
 			btrfs_free_path(path);
@@ -3738,7 +3739,8 @@ int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 	struct super_block *sb;
 	struct dentry *old_parent = NULL;
 	int ret = 0;
-	u64 last_committed = root->fs_info->last_trans_committed;
+	u64 last_committed = atomic64_read(
+			     &root->fs_info->last_trans_committed);
 
 	sb = inode->i_sb;
 
@@ -3748,7 +3750,7 @@ int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 	}
 
 	if (root->fs_info->last_trans_log_full_commit >
-	    root->fs_info->last_trans_committed) {
+	    atomic64_read(&root->fs_info->last_trans_committed)) {
 		ret = 1;
 		goto end_no_trans;
 	}
@@ -3800,7 +3802,7 @@ int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 			break;
 
 		if (BTRFS_I(inode)->generation >
-		    root->fs_info->last_trans_committed) {
+		    atomic64_read(&root->fs_info->last_trans_committed)) {
 			ret = btrfs_log_inode(trans, root, inode, inode_only);
 			if (ret)
 				goto end_trans;
@@ -4063,9 +4065,9 @@ int btrfs_log_new_name(struct btrfs_trans_handle *trans,
 	 * from hasn't been logged, we don't need to log it
 	 */
 	if (BTRFS_I(inode)->logged_trans <=
-	    root->fs_info->last_trans_committed &&
+	    atomic64_read(&root->fs_info->last_trans_committed) &&
 	    (!old_dir || BTRFS_I(old_dir)->logged_trans <=
-		    root->fs_info->last_trans_committed))
+		    atomic64_read(&root->fs_info->last_trans_committed)))
 		return 0;
 
 	return btrfs_log_inode_parent(trans, root, inode, parent, 1);
-- 
1.7.11.7
