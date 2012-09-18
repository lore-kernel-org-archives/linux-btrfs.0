Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:7349 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754613Ab2IRFwm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Sep 2012 01:52:42 -0400
Message-ID: <50580C26.5030803@cn.fujitsu.com>
Date: Tue, 18 Sep 2012 13:52:38 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: David Sterba <dave@jikos.cz>
Subject: [PATCH] Btrfs: fix the missing error information in create_pending_snapshot()
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The macro btrfs_abort_transaction() can get the line number of the code
where the problem happens, so we should invoke it in the place that the
error occurs, or we will lose the line number.

Reported-by: David Sterba <dave@jikos.cz>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/transaction.c |   57 +++++++++++++++++++++++++++++------------------
 1 files changed, 35 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 7d3fc93..cf98dbc 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1042,7 +1042,8 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 		goto fail;
 	} else if (IS_ERR(dir_item)) {
 		ret = PTR_ERR(dir_item);
-		goto abort_trans;
+		btrfs_abort_transaction(trans, root, ret);
+		goto fail;
 	}
 	btrfs_release_path(path);
 
@@ -1053,8 +1054,10 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	 * snapshot
 	 */
 	ret = btrfs_run_delayed_items(trans, root);
-	if (ret)	/* Transaction aborted */
-		goto abort_trans;
+	if (ret) {	/* Transaction aborted */
+		btrfs_abort_transaction(trans, root, ret);
+		goto fail;
+	}
 
 	record_root_in_trans(trans, root);
 	btrfs_set_root_last_snapshot(&root->root_item, trans->transid);
@@ -1087,7 +1090,8 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	if (ret) {
 		btrfs_tree_unlock(old);
 		free_extent_buffer(old);
-		goto abort_trans;
+		btrfs_abort_transaction(trans, root, ret);
+		goto fail;
 	}
 
 	btrfs_set_lock_blocking(old);
@@ -1096,8 +1100,10 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	/* clean up in any case */
 	btrfs_tree_unlock(old);
 	free_extent_buffer(old);
-	if (ret)
-		goto abort_trans;
+	if (ret) {
+		btrfs_abort_transaction(trans, root, ret);
+		goto fail;
+	}
 
 	/* see comments in should_cow_block() */
 	root->force_cow = 1;
@@ -1109,8 +1115,10 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	ret = btrfs_insert_root(trans, tree_root, &key, new_root_item);
 	btrfs_tree_unlock(tmp);
 	free_extent_buffer(tmp);
-	if (ret)
-		goto abort_trans;
+	if (ret) {
+		btrfs_abort_transaction(trans, root, ret);
+		goto fail;
+	}
 
 	/*
 	 * insert root back/forward references
@@ -1119,23 +1127,30 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 				 parent_root->root_key.objectid,
 				 btrfs_ino(parent_inode), index,
 				 dentry->d_name.name, dentry->d_name.len);
-	if (ret)
-		goto abort_trans;
+	if (ret) {
+		btrfs_abort_transaction(trans, root, ret);
+		goto fail;
+	}
 
 	key.offset = (u64)-1;
 	pending->snap = btrfs_read_fs_root_no_name(root->fs_info, &key);
 	if (IS_ERR(pending->snap)) {
 		ret = PTR_ERR(pending->snap);
-		goto abort_trans;
+		btrfs_abort_transaction(trans, root, ret);
+		goto fail;
 	}
 
 	ret = btrfs_reloc_post_snapshot(trans, pending);
-	if (ret)
-		goto abort_trans;
+	if (ret) {
+		btrfs_abort_transaction(trans, root, ret);
+		goto fail;
+	}
 
 	ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
-	if (ret)
-		goto abort_trans;
+	if (ret) {
+		btrfs_abort_transaction(trans, root, ret);
+		goto fail;
+	}
 
 	ret = btrfs_insert_dir_item(trans, parent_root,
 				    dentry->d_name.name, dentry->d_name.len,
@@ -1143,15 +1158,17 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 				    BTRFS_FT_DIR, index);
 	/* We have check then name at the beginning, so it is impossible. */
 	BUG_ON(ret == -EEXIST);
-	if (ret)
-		goto abort_trans;
+	if (ret) {
+		btrfs_abort_transaction(trans, root, ret);
+		goto fail;
+	}
 
 	btrfs_i_size_write(parent_inode, parent_inode->i_size +
 					 dentry->d_name.len * 2);
 	parent_inode->i_mtime = parent_inode->i_ctime = CURRENT_TIME;
 	ret = btrfs_update_inode(trans, parent_root, parent_inode);
 	if (ret)
-		goto abort_trans;
+		btrfs_abort_transaction(trans, root, ret);
 fail:
 	dput(parent);
 	trans->block_rsv = rsv;
@@ -1162,10 +1179,6 @@ root_item_alloc_fail:
 path_alloc_fail:
 	btrfs_block_rsv_release(root, &pending->block_rsv, (u64)-1);
 	return ret;
-
-abort_trans:
-	btrfs_abort_transaction(trans, root, ret);
-	goto fail;
 }
 
 /*
-- 
1.7.6.5
