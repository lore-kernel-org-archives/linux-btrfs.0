Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44274 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752769AbeFHMsG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Jun 2018 08:48:06 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AC476AF8F
        for <linux-btrfs@vger.kernel.org>; Fri,  8 Jun 2018 12:48:05 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 15/15] btrfs-progs: Remove old delayed refs infrastructure
Date: Fri,  8 Jun 2018 15:47:58 +0300
Message-Id: <1528462078-24490-16-git-send-email-nborisov@suse.com>
In-Reply-To: <1528462078-24490-1-git-send-email-nborisov@suse.com>
References: <1528462078-24490-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Given that the new delayed refs infrastructure is implemented and
wired up, there is no point in keeping the old code. So just remove it.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 ctree.h       |   2 -
 extent-tree.c | 137 ----------------------------------------------------------
 2 files changed, 139 deletions(-)

diff --git a/ctree.h b/ctree.h
index d1ea45571d1e..3e9ca2ca8432 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1098,7 +1098,6 @@ struct btrfs_fs_info {
 	struct extent_io_tree free_space_cache;
 	struct extent_io_tree block_group_cache;
 	struct extent_io_tree pinned_extents;
-	struct extent_io_tree pending_del;
 	struct extent_io_tree extent_ins;
 	struct extent_io_tree *excluded_extents;
 
@@ -2503,7 +2502,6 @@ int btrfs_fix_block_accounting(struct btrfs_trans_handle *trans);
 void btrfs_pin_extent(struct btrfs_fs_info *fs_info, u64 bytenr, u64 num_bytes);
 void btrfs_unpin_extent(struct btrfs_fs_info *fs_info,
 			u64 bytenr, u64 num_bytes);
-int btrfs_extent_post_op(struct btrfs_trans_handle *trans);
 struct btrfs_block_group_cache *btrfs_lookup_block_group(struct
 							 btrfs_fs_info *info,
 							 u64 bytenr);
diff --git a/extent-tree.c b/extent-tree.c
index 9d085158f2d8..b9d51b388c9a 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -52,8 +52,6 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 			 u64 bytenr, u64 num_bytes, u64 parent,
 			 u64 root_objectid, u64 owner_objectid,
 			 u64 owner_offset, int refs_to_drop);
-static int finish_current_insert(struct btrfs_trans_handle *trans);
-static int del_pending_extents(struct btrfs_trans_handle *trans);
 static struct btrfs_block_group_cache *
 btrfs_find_block_group(struct btrfs_root *root, struct btrfs_block_group_cache
 		       *hint, u64 search_start, int data, int owner);
@@ -1422,13 +1420,6 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	return err;
 }
 
-int btrfs_extent_post_op(struct btrfs_trans_handle *trans)
-{
-	finish_current_insert(trans);
-	del_pending_extents(trans);
-	return 0;
-}
-
 int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 			     struct btrfs_fs_info *fs_info, u64 bytenr,
 			     u64 offset, int metadata, u64 *refs, u64 *flags)
@@ -2013,74 +2004,6 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-static int extent_root_pending_ops(struct btrfs_fs_info *info)
-{
-	u64 start;
-	u64 end;
-	int ret;
-
-	ret = find_first_extent_bit(&info->extent_ins, 0, &start,
-				    &end, EXTENT_LOCKED);
-	if (!ret) {
-		ret = find_first_extent_bit(&info->pending_del, 0, &start, &end,
-					    EXTENT_LOCKED);
-	}
-	return ret == 0;
-
-}
-static int finish_current_insert(struct btrfs_trans_handle *trans)
-{
-	u64 start;
-	u64 end;
-	u64 priv;
-	struct btrfs_fs_info *info = trans->fs_info;
-	struct btrfs_root *extent_root = info->extent_root;
-	struct pending_extent_op *extent_op;
-	struct btrfs_key key;
-	int ret;
-	int skinny_metadata =
-		btrfs_fs_incompat(extent_root->fs_info, SKINNY_METADATA);
-
-
-	while(1) {
-		ret = find_first_extent_bit(&info->extent_ins, 0, &start,
-					    &end, EXTENT_LOCKED);
-		if (ret)
-			break;
-
-		ret = get_state_private(&info->extent_ins, start, &priv);
-		BUG_ON(ret);
-		extent_op = (struct pending_extent_op *)(unsigned long)priv;
-
-		if (extent_op->type == PENDING_EXTENT_INSERT) {
-			key.objectid = start;
-			if (skinny_metadata) {
-				key.offset = extent_op->level;
-				key.type = BTRFS_METADATA_ITEM_KEY;
-			} else {
-				key.offset = extent_op->num_bytes;
-				key.type = BTRFS_EXTENT_ITEM_KEY;
-			}
-
-			ret = alloc_reserved_tree_block(trans,
-						extent_root->root_key.objectid,
-						trans->transid,
-						extent_op->flags,
-						&extent_op->key,
-						extent_op->level, &key);
-			BUG_ON(ret);
-		} else {
-			BUG_ON(1);
-		}
-
-
-		printf("shouldn't be executed\n");
-		clear_extent_bits(&info->extent_ins, start, end, EXTENT_LOCKED);
-		kfree(extent_op);
-	}
-	return 0;
-}
-
 static int pin_down_bytes(struct btrfs_trans_handle *trans, u64 bytenr,
 			  u64 num_bytes, int is_data)
 {
@@ -2377,66 +2300,6 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-/*
- * find all the blocks marked as pending in the radix tree and remove
- * them from the extent map
- */
-static int del_pending_extents(struct btrfs_trans_handle *trans)
-{
-	int ret;
-	int err = 0;
-	u64 start;
-	u64 end;
-	u64 priv;
-	struct extent_io_tree *pending_del;
-	struct extent_io_tree *extent_ins;
-	struct pending_extent_op *extent_op;
-	struct btrfs_fs_info *fs_info = trans->fs_info;
-	struct btrfs_root *extent_root = fs_info->extent_root;
-
-	extent_ins = &extent_root->fs_info->extent_ins;
-	pending_del = &extent_root->fs_info->pending_del;
-
-	while(1) {
-		ret = find_first_extent_bit(pending_del, 0, &start, &end,
-					    EXTENT_LOCKED);
-		if (ret)
-			break;
-
-		ret = get_state_private(pending_del, start, &priv);
-		BUG_ON(ret);
-		extent_op = (struct pending_extent_op *)(unsigned long)priv;
-
-		clear_extent_bits(pending_del, start, end, EXTENT_LOCKED);
-
-		if (!test_range_bit(extent_ins, start, end,
-				    EXTENT_LOCKED, 0)) {
-			ret = __free_extent(trans, start, end + 1 - start, 0,
-					    extent_root->root_key.objectid,
-					    extent_op->level, 0, 1);
-			kfree(extent_op);
-		} else {
-			kfree(extent_op);
-			ret = get_state_private(extent_ins, start, &priv);
-			BUG_ON(ret);
-			extent_op = (struct pending_extent_op *)
-							(unsigned long)priv;
-
-			clear_extent_bits(extent_ins, start, end,
-					  EXTENT_LOCKED);
-
-			if (extent_op->type == PENDING_BACKREF_UPDATE)
-				BUG_ON(1);
-
-			kfree(extent_op);
-		}
-		if (ret)
-			err = ret;
-	}
-	return err;
-}
-
-
 int btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root,
 			  struct extent_buffer *buf,
-- 
2.7.4

