Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43546 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1425215AbeE1PyN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 May 2018 11:54:13 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 230B5ADC6
        for <linux-btrfs@vger.kernel.org>; Mon, 28 May 2018 15:54:12 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 04/11] btrfs-progs: check: Remove root argument from finish_current_insert
Date: Mon, 28 May 2018 09:36:43 +0300
Message-Id: <1527489410-3564-5-git-send-email-nborisov@suse.com>
In-Reply-To: <1527489410-3564-1-git-send-email-nborisov@suse.com>
References: <1527489410-3564-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just reference it directly from trans->fs_info.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 extent-tree.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/extent-tree.c b/extent-tree.c
index e950ba6de3cc..89fed5b73b1f 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -54,8 +54,7 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 			 u64 bytenr, u64 num_bytes, u64 parent,
 			 u64 root_objectid, u64 owner_objectid,
 			 u64 owner_offset, int refs_to_drop);
-static int finish_current_insert(struct btrfs_trans_handle *trans, struct
-				 btrfs_root *extent_root);
+static int finish_current_insert(struct btrfs_trans_handle *trans);
 static int del_pending_extents(struct btrfs_trans_handle *trans);
 static struct btrfs_block_group_cache *
 btrfs_find_block_group(struct btrfs_root *root, struct btrfs_block_group_cache
@@ -1421,7 +1420,7 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 		err = ret;
 out:
 	btrfs_free_path(path);
-	finish_current_insert(trans, root->fs_info->extent_root);
+	finish_current_insert(trans);
 	del_pending_extents(trans);
 	BUG_ON(err);
 	return err;
@@ -1430,7 +1429,7 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 int btrfs_extent_post_op(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root)
 {
-	finish_current_insert(trans, root->fs_info->extent_root);
+	finish_current_insert(trans);
 	del_pending_extents(trans);
 	return 0;
 }
@@ -1610,7 +1609,7 @@ int btrfs_set_block_flags(struct btrfs_trans_handle *trans,
 	btrfs_set_extent_flags(l, item, flags);
 out:
 	btrfs_free_path(path);
-	finish_current_insert(trans, root->fs_info->extent_root);
+	finish_current_insert(trans);
 	del_pending_extents(trans);
 	return ret;
 }
@@ -1726,7 +1725,7 @@ static int write_one_cache_group(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_release_path(path);
 fail:
-	finish_current_insert(trans, extent_root);
+	finish_current_insert(trans);
 	pending_ret = del_pending_extents(trans);
 	if (ret)
 		return ret;
@@ -2056,13 +2055,13 @@ static int extent_root_pending_ops(struct btrfs_fs_info *info)
 	return ret == 0;
 
 }
-static int finish_current_insert(struct btrfs_trans_handle *trans,
-				 struct btrfs_root *extent_root)
+static int finish_current_insert(struct btrfs_trans_handle *trans)
 {
 	u64 start;
 	u64 end;
 	u64 priv;
-	struct btrfs_fs_info *info = extent_root->fs_info;
+	struct btrfs_fs_info *info = trans->fs_info;
+	struct btrfs_root *extent_root = info->extent_root;
 	struct pending_extent_op *extent_op;
 	struct btrfs_key key;
 	int ret;
@@ -2388,7 +2387,7 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 	}
 fail:
 	btrfs_free_path(path);
-	finish_current_insert(trans, extent_root);
+	finish_current_insert(trans);
 	return ret;
 }
 
@@ -2789,7 +2788,7 @@ static int alloc_tree_block(struct btrfs_trans_handle *trans,
 		ret = alloc_reserved_tree_block(trans, root, root_objectid,
 						generation, flags,
 						key, level, ins);
-		finish_current_insert(trans, root->fs_info->extent_root);
+		finish_current_insert(trans);
 		del_pending_extents(trans);
 	}
 	return ret;
@@ -3316,7 +3315,7 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 				sizeof(cache->item));
 	BUG_ON(ret);
 
-	ret = finish_current_insert(trans, extent_root);
+	ret = finish_current_insert(trans);
 	BUG_ON(ret);
 	ret = del_pending_extents(trans);
 	BUG_ON(ret);
@@ -3416,7 +3415,7 @@ int btrfs_make_block_groups(struct btrfs_trans_handle *trans,
 					sizeof(cache->item));
 		BUG_ON(ret);
 
-		finish_current_insert(trans, extent_root);
+		finish_current_insert(trans);
 		ret = del_pending_extents(trans);
 		BUG_ON(ret);
 
@@ -3802,7 +3801,7 @@ int btrfs_fix_block_accounting(struct btrfs_trans_handle *trans)
 	struct btrfs_root *root = fs_info->extent_root;
 
 	while(extent_root_pending_ops(fs_info)) {
-		ret = finish_current_insert(trans, root);
+		ret = finish_current_insert(trans);
 		if (ret)
 			return ret;
 		ret = del_pending_extents(trans);
-- 
2.7.4

