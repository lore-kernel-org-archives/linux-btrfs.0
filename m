Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54432 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2403813AbeHPQJM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Aug 2018 12:09:12 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 40C19AE67
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Aug 2018 13:10:40 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 8/8] btrfs-progs: Merge alloc_reserved_tree_block(2|)
Date: Thu, 16 Aug 2018 16:10:35 +0300
Message-Id: <1534425035-323-9-git-send-email-nborisov@suse.com>
In-Reply-To: <1534425035-323-1-git-send-email-nborisov@suse.com>
References: <1534425035-323-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now that delayed refs have been wired let's merge the two function. In
the process also remove one BUG_ON since alloc_reserved_tree_block's
callers can handle errors. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 extent-tree.c | 77 +++++++++++++++++++++++------------------------------------
 1 file changed, 30 insertions(+), 47 deletions(-)

diff --git a/extent-tree.c b/extent-tree.c
index 1a63efdd9681..b9a30644720b 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -44,10 +44,6 @@ struct pending_extent_op {
 	int level;
 };
 
-static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
-				     u64 root_objectid, u64 generation,
-				     u64 flags, struct btrfs_disk_key *key,
-				     int level, struct btrfs_key *ins);
 static int __free_extent(struct btrfs_trans_handle *trans,
 			 u64 bytenr, u64 num_bytes, u64 parent,
 			 u64 root_objectid, u64 owner_objectid,
@@ -2528,16 +2524,22 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static int alloc_reserved_tree_block2(struct btrfs_trans_handle *trans,
+static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 				      struct btrfs_delayed_ref_node *node,
 				      struct btrfs_delayed_extent_op *extent_op)
 {
 
 	struct btrfs_delayed_tree_ref *ref = btrfs_delayed_node_to_tree_ref(node);
-	struct btrfs_key ins;
 	bool skinny_metadata = btrfs_fs_incompat(trans->fs_info, SKINNY_METADATA);
-	int ret;
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct btrfs_extent_item *extent_item;
+	struct btrfs_extent_inline_ref *iref;
+	struct extent_buffer *leaf;
+	struct btrfs_path *path;
+	struct btrfs_key ins;
+	u32 size = sizeof(*extent_item) + sizeof(*iref);
 	u64 start, end;
+	int ret;
 
 	ins.objectid = node->bytenr;
 	if (skinny_metadata) {
@@ -2546,6 +2548,8 @@ static int alloc_reserved_tree_block2(struct btrfs_trans_handle *trans,
 	} else {
 		ins.offset = node->num_bytes;
 		ins.type = BTRFS_EXTENT_ITEM_KEY;
+
+		size += sizeof(struct btrfs_tree_block_info);
 	}
 
 	if (ref->root == BTRFS_EXTENT_TREE_OBJECTID) {
@@ -2557,69 +2561,48 @@ static int alloc_reserved_tree_block2(struct btrfs_trans_handle *trans,
 		ASSERT(end == node->bytenr + node->num_bytes - 1);
 	}
 
-	ret = alloc_reserved_tree_block(trans, ref->root, trans->transid,
-					extent_op->flags_to_set,
-					&extent_op->key, ref->level, &ins);
-
-	if (ref->root == BTRFS_EXTENT_TREE_OBJECTID) {
-		clear_extent_bits(&trans->fs_info->extent_ins, start, end,
-				  EXTENT_LOCKED);
-	}
-
-	return ret;
-}
-
-static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
-				     u64 root_objectid, u64 generation,
-				     u64 flags, struct btrfs_disk_key *key,
-				     int level, struct btrfs_key *ins)
-{
-	int ret;
-	struct btrfs_fs_info *fs_info = trans->fs_info;
-	struct btrfs_extent_item *extent_item;
-	struct btrfs_tree_block_info *block_info;
-	struct btrfs_extent_inline_ref *iref;
-	struct btrfs_path *path;
-	struct extent_buffer *leaf;
-	u32 size = sizeof(*extent_item) + sizeof(*iref);
-	int skinny_metadata = btrfs_fs_incompat(fs_info, SKINNY_METADATA);
-
-	if (!skinny_metadata)
-		size += sizeof(*block_info);
-
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
 
 	ret = btrfs_insert_empty_item(trans, fs_info->extent_root, path,
-				      ins, size);
-	BUG_ON(ret);
+				      &ins, size);
+	if (ret)
+		return ret;
 
 	leaf = path->nodes[0];
 	extent_item = btrfs_item_ptr(leaf, path->slots[0],
 				     struct btrfs_extent_item);
 	btrfs_set_extent_refs(leaf, extent_item, 1);
-	btrfs_set_extent_generation(leaf, extent_item, generation);
+	btrfs_set_extent_generation(leaf, extent_item, trans->transid);
 	btrfs_set_extent_flags(leaf, extent_item,
-			       flags | BTRFS_EXTENT_FLAG_TREE_BLOCK);
+			       extent_op->flags_to_set |
+			       BTRFS_EXTENT_FLAG_TREE_BLOCK);
 
 	if (skinny_metadata) {
 		iref = (struct btrfs_extent_inline_ref *)(extent_item + 1);
 	} else {
+		struct btrfs_tree_block_info *block_info;
 		block_info = (struct btrfs_tree_block_info *)(extent_item + 1);
-		btrfs_set_tree_block_key(leaf, block_info, key);
-		btrfs_set_tree_block_level(leaf, block_info, level);
+		btrfs_set_tree_block_key(leaf, block_info, &extent_op->key);
+		btrfs_set_tree_block_level(leaf, block_info, ref->level);
 		iref = (struct btrfs_extent_inline_ref *)(block_info + 1);
 	}
 
 	btrfs_set_extent_inline_ref_type(leaf, iref, BTRFS_TREE_BLOCK_REF_KEY);
-	btrfs_set_extent_inline_ref_offset(leaf, iref, root_objectid);
+	btrfs_set_extent_inline_ref_offset(leaf, iref, ref->root);
 
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_free_path(path);
 
-	ret = update_block_group(fs_info, ins->objectid, fs_info->nodesize,
-				 1, 0);
+	ret = update_block_group(fs_info, ins.objectid, fs_info->nodesize, 1,
+				 0);
+
+	if (ref->root == BTRFS_EXTENT_TREE_OBJECTID) {
+		clear_extent_bits(&trans->fs_info->extent_ins, start, end,
+				  EXTENT_LOCKED);
+	}
+
 	return ret;
 }
 
@@ -4170,7 +4153,7 @@ static int run_delayed_tree_ref(struct btrfs_trans_handle *trans,
 	}
 	if (node->action == BTRFS_ADD_DELAYED_REF && insert_reserved) {
 		BUG_ON(!extent_op || !extent_op->update_flags);
-		ret = alloc_reserved_tree_block2(trans, node, extent_op);
+		ret = alloc_reserved_tree_block(trans, node, extent_op);
 	} else if (node->action == BTRFS_DROP_DELAYED_REF) {
 		struct btrfs_delayed_tree_ref *ref = btrfs_delayed_node_to_tree_ref(node);
 		ret =  __free_extent(trans, node->bytenr, node->num_bytes,
-- 
2.7.4
