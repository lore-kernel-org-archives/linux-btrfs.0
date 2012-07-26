Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:23049 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750946Ab2GZGz0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Jul 2012 02:55:26 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q6Q6tJQw027501
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Jul 2012 14:55:21 +0800
Message-ID: <5010E9A3.2010509@cn.fujitsu.com>
Date: Thu, 26 Jul 2012 14:54:27 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] Btrfs: fix error path in create_pending_snapshot()
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch fixes the following problem:
- If we failed to deal with the delayed dir items, we should abort transaction,
  just as its comment said. Fix it.
- If root reference or root back reference insertion failed, we should
  abort transaction. Fix it.
- Do not restore the trans->rsv if we doesn't change it.
- make the error path more clearly.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/transaction.c |   38 +++++++++++++++++---------------------
 1 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index b72b068..6d89603 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -932,18 +932,16 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	u64 objectid;
 	u64 root_flags;
 
-	rsv = trans->block_rsv;
-
 	new_root_item = kmalloc(sizeof(*new_root_item), GFP_NOFS);
 	if (!new_root_item) {
 		ret = pending->error = -ENOMEM;
-		goto fail;
+		goto root_item_alloc_fail;
 	}
 
 	ret = btrfs_find_free_objectid(tree_root, &objectid);
 	if (ret) {
 		pending->error = ret;
-		goto fail;
+		goto no_free_objectid;
 	}
 
 	btrfs_reloc_pre_snapshot(trans, pending, &to_reserve);
@@ -953,7 +951,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 						  to_reserve);
 		if (ret) {
 			pending->error = ret;
-			goto fail;
+			goto no_free_objectid;
 		}
 	}
 
@@ -961,6 +959,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	key.offset = (u64)-1;
 	key.type = BTRFS_ROOT_ITEM_KEY;
 
+	rsv = trans->block_rsv;
 	trans->block_rsv = &pending->block_rsv;
 
 	dentry = pending->dentry;
@@ -980,17 +979,16 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 				BTRFS_FT_DIR, index);
 	if (ret == -EEXIST) {
 		pending->error = -EEXIST;
-		dput(parent);
 		goto fail;
 	} else if (ret) {
-		goto abort_trans_dput;
+		goto abort_trans;
 	}
 
 	btrfs_i_size_write(parent_inode, parent_inode->i_size +
 					 dentry->d_name.len * 2);
 	ret = btrfs_update_inode(trans, parent_root, parent_inode);
 	if (ret)
-		goto abort_trans_dput;
+		goto abort_trans;
 
 	/*
 	 * pull in the delayed directory update
@@ -999,10 +997,8 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	 * snapshot
 	 */
 	ret = btrfs_run_delayed_items(trans, root);
-	if (ret) { /* Transaction aborted */
-		dput(parent);
-		goto fail;
-	}
+	if (ret)	/* Transaction aborted */
+		goto abort_trans;
 
 	record_root_in_trans(trans, root);
 	btrfs_set_root_last_snapshot(&root->root_item, trans->transid);
@@ -1021,7 +1017,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	if (ret) {
 		btrfs_tree_unlock(old);
 		free_extent_buffer(old);
-		goto abort_trans_dput;
+		goto abort_trans;
 	}
 
 	btrfs_set_lock_blocking(old);
@@ -1031,7 +1027,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	btrfs_tree_unlock(old);
 	free_extent_buffer(old);
 	if (ret)
-		goto abort_trans_dput;
+		goto abort_trans;
 
 	/* see comments in should_cow_block() */
 	root->force_cow = 1;
@@ -1044,7 +1040,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	btrfs_tree_unlock(tmp);
 	free_extent_buffer(tmp);
 	if (ret)
-		goto abort_trans_dput;
+		goto abort_trans;
 
 	/*
 	 * insert root back/forward references
@@ -1053,9 +1049,8 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 				 parent_root->root_key.objectid,
 				 btrfs_ino(parent_inode), index,
 				 dentry->d_name.name, dentry->d_name.len);
-	dput(parent);
 	if (ret)
-		goto fail;
+		goto abort_trans;
 
 	key.offset = (u64)-1;
 	pending->snap = btrfs_read_fs_root_no_name(root->fs_info, &key);
@@ -1067,16 +1062,17 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	ret = btrfs_reloc_post_snapshot(trans, pending);
 	if (ret)
 		goto abort_trans;
-	ret = 0;
 fail:
-	kfree(new_root_item);
+	dput(parent);
 	trans->block_rsv = rsv;
+no_free_objectid:
+	kfree(new_root_item);
+root_item_alloc_fail:
 	btrfs_block_rsv_release(root, &pending->block_rsv, (u64)-1);
 	return ret;
 
-abort_trans_dput:
-	dput(parent);
 abort_trans:
+	dput(parent);
 	btrfs_abort_transaction(trans, root, ret);
 	goto fail;
 }
-- 
1.7.6.5
