Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49641 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933478AbeE1QNr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 May 2018 12:13:47 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7647BADCA
        for <linux-btrfs@vger.kernel.org>; Mon, 28 May 2018 16:13:45 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 03/11] btrfs-progs: check: Remove root parameter from del_pending_extents
Date: Mon, 28 May 2018 09:36:42 +0300
Message-Id: <1527489410-3564-4-git-send-email-nborisov@suse.com>
In-Reply-To: <1527489410-3564-1-git-send-email-nborisov@suse.com>
References: <1527489410-3564-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function always operates on the extent root which can be
referenced from trans->fs_info. Do that to simplify function's
signature.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 extent-tree.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/extent-tree.c b/extent-tree.c
index 3132ccc8d44f..e950ba6de3cc 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -56,8 +56,7 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 			 u64 owner_offset, int refs_to_drop);
 static int finish_current_insert(struct btrfs_trans_handle *trans, struct
 				 btrfs_root *extent_root);
-static int del_pending_extents(struct btrfs_trans_handle *trans, struct
-			       btrfs_root *extent_root);
+static int del_pending_extents(struct btrfs_trans_handle *trans);
 static struct btrfs_block_group_cache *
 btrfs_find_block_group(struct btrfs_root *root, struct btrfs_block_group_cache
 		       *hint, u64 search_start, int data, int owner);
@@ -1423,7 +1422,7 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 out:
 	btrfs_free_path(path);
 	finish_current_insert(trans, root->fs_info->extent_root);
-	del_pending_extents(trans, root->fs_info->extent_root);
+	del_pending_extents(trans);
 	BUG_ON(err);
 	return err;
 }
@@ -1432,7 +1431,7 @@ int btrfs_extent_post_op(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root)
 {
 	finish_current_insert(trans, root->fs_info->extent_root);
-	del_pending_extents(trans, root->fs_info->extent_root);
+	del_pending_extents(trans);
 	return 0;
 }
 
@@ -1612,7 +1611,7 @@ int btrfs_set_block_flags(struct btrfs_trans_handle *trans,
 out:
 	btrfs_free_path(path);
 	finish_current_insert(trans, root->fs_info->extent_root);
-	del_pending_extents(trans, root->fs_info->extent_root);
+	del_pending_extents(trans);
 	return ret;
 }
 
@@ -1728,7 +1727,7 @@ static int write_one_cache_group(struct btrfs_trans_handle *trans,
 	btrfs_release_path(path);
 fail:
 	finish_current_insert(trans, extent_root);
-	pending_ret = del_pending_extents(trans, extent_root);
+	pending_ret = del_pending_extents(trans);
 	if (ret)
 		return ret;
 	if (pending_ret)
@@ -2397,8 +2396,7 @@ static int __free_extent(struct btrfs_trans_handle *trans,
  * find all the blocks marked as pending in the radix tree and remove
  * them from the extent map
  */
-static int del_pending_extents(struct btrfs_trans_handle *trans, struct
-			       btrfs_root *extent_root)
+static int del_pending_extents(struct btrfs_trans_handle *trans)
 {
 	int ret;
 	int err = 0;
@@ -2408,6 +2406,8 @@ static int del_pending_extents(struct btrfs_trans_handle *trans, struct
 	struct extent_io_tree *pending_del;
 	struct extent_io_tree *extent_ins;
 	struct pending_extent_op *extent_op;
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct btrfs_root *extent_root = fs_info->extent_root;
 
 	extent_ins = &extent_root->fs_info->extent_ins;
 	pending_del = &extent_root->fs_info->pending_del;
@@ -2497,7 +2497,7 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 	}
 	ret = __free_extent(trans, root, bytenr, num_bytes, parent,
 			    root_objectid, owner, offset, 1);
-	pending_ret = del_pending_extents(trans, root->fs_info->extent_root);
+	pending_ret = del_pending_extents(trans);
 	return ret ? ret : pending_ret;
 }
 
@@ -2790,7 +2790,7 @@ static int alloc_tree_block(struct btrfs_trans_handle *trans,
 						generation, flags,
 						key, level, ins);
 		finish_current_insert(trans, root->fs_info->extent_root);
-		del_pending_extents(trans, root->fs_info->extent_root);
+		del_pending_extents(trans);
 	}
 	return ret;
 }
@@ -3318,7 +3318,7 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 
 	ret = finish_current_insert(trans, extent_root);
 	BUG_ON(ret);
-	ret = del_pending_extents(trans, extent_root);
+	ret = del_pending_extents(trans);
 	BUG_ON(ret);
 
 	return 0;
@@ -3417,7 +3417,7 @@ int btrfs_make_block_groups(struct btrfs_trans_handle *trans,
 		BUG_ON(ret);
 
 		finish_current_insert(trans, extent_root);
-		ret = del_pending_extents(trans, extent_root);
+		ret = del_pending_extents(trans);
 		BUG_ON(ret);
 
 		cur_start = cache->key.objectid + cache->key.offset;
@@ -3805,7 +3805,7 @@ int btrfs_fix_block_accounting(struct btrfs_trans_handle *trans)
 		ret = finish_current_insert(trans, root);
 		if (ret)
 			return ret;
-		ret = del_pending_extents(trans, root);
+		ret = del_pending_extents(trans);
 		if (ret)
 			return ret;
 	}
-- 
2.7.4

