Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43607 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751719AbeEUJ1c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 May 2018 05:27:32 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E7334ADAF
        for <linux-btrfs@vger.kernel.org>; Mon, 21 May 2018 09:27:30 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/4] btrfs: Simplify alloc_reserved_tree_block interface
Date: Mon, 21 May 2018 12:27:21 +0300
Message-Id: <1526894843-8732-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1526894843-8732-1-git-send-email-nborisov@suse.com>
References: <1526894843-8732-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function currently takes 7 parameters, most of which are
proxies for values from btrfs_delayed_ref_node struct which is not
passed. This patch simplifies the interface of the function by
simply passing said delayed ref node struct to the function. This
enables us to:

1. Move locals variables and init code related to them from
run_delayed_tree_ref which should only be used inside
alloc_reserved_tree_block, such as skinny_metadata and the btrfs_key,
representing the extent being inserted. This removes the need for the
"ins" argument. Instead, it's replaced by a local var with a more
verbose name - extent_key.

2. Now that we have a reference to the node in alloc_reserved_tree_block
the delayed_tree_ref struct can be referenced inside the function and
this enable removing the "ref->level", "parent" and "ref_root"
arguments.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 71 +++++++++++++++++++++++++++-----------------------
 1 file changed, 39 insertions(+), 32 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e80fbfa11a89..fe7f7f5d99dc 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -66,9 +66,8 @@ static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 				      u64 flags, u64 owner, u64 offset,
 				      struct btrfs_key *ins, int ref_mod);
 static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
-				     u64 parent, u64 root_objectid,
-				     u64 flags, struct btrfs_disk_key *key,
-				     int level, struct btrfs_key *ins);
+				     struct btrfs_delayed_ref_node *node,
+				     u64 flags, struct btrfs_disk_key *key);
 static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 			  struct btrfs_fs_info *fs_info, u64 flags,
 			  int force);
@@ -2430,10 +2429,8 @@ static int run_delayed_tree_ref(struct btrfs_trans_handle *trans,
 {
 	int ret = 0;
 	struct btrfs_delayed_tree_ref *ref;
-	struct btrfs_key ins;
 	u64 parent = 0;
 	u64 ref_root = 0;
-	bool skinny_metadata = btrfs_fs_incompat(fs_info, SKINNY_METADATA);
 
 	ref = btrfs_delayed_node_to_tree_ref(node);
 	trace_run_delayed_tree_ref(fs_info, node, ref, node->action);
@@ -2442,15 +2439,6 @@ static int run_delayed_tree_ref(struct btrfs_trans_handle *trans,
 		parent = ref->parent;
 	ref_root = ref->root;
 
-	ins.objectid = node->bytenr;
-	if (skinny_metadata) {
-		ins.offset = ref->level;
-		ins.type = BTRFS_METADATA_ITEM_KEY;
-	} else {
-		ins.offset = node->num_bytes;
-		ins.type = BTRFS_EXTENT_ITEM_KEY;
-	}
-
 	if (node->ref_mod != 1) {
 		btrfs_err(fs_info,
 	"btree block(%llu) has %d references rather than 1: action %d ref_root %llu parent %llu",
@@ -2460,10 +2448,9 @@ static int run_delayed_tree_ref(struct btrfs_trans_handle *trans,
 	}
 	if (node->action == BTRFS_ADD_DELAYED_REF && insert_reserved) {
 		BUG_ON(!extent_op || !extent_op->update_flags);
-		ret = alloc_reserved_tree_block(trans, parent, ref_root,
+		ret = alloc_reserved_tree_block(trans, node,
 						extent_op->flags_to_set,
-						&extent_op->key,
-						ref->level, &ins);
+						&extent_op->key);
 	} else if (node->action == BTRFS_ADD_DELAYED_REF) {
 		ret = __btrfs_inc_extent_ref(trans, fs_info, node,
 					     parent, ref_root,
@@ -8143,37 +8130,57 @@ static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 }
 
 static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
-				     u64 parent, u64 root_objectid,
-				     u64 flags, struct btrfs_disk_key *key,
-				     int level, struct btrfs_key *ins)
+				     struct btrfs_delayed_ref_node *node,
+				     u64 flags, struct btrfs_disk_key *key)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	int ret;
 	struct btrfs_extent_item *extent_item;
+	struct btrfs_key extent_key;
 	struct btrfs_tree_block_info *block_info;
 	struct btrfs_extent_inline_ref *iref;
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
+	struct btrfs_delayed_tree_ref *ref;
 	u32 size = sizeof(*extent_item) + sizeof(*iref);
-	u64 num_bytes = ins->offset;
+	u64 num_bytes;
+	u64 parent;
 	bool skinny_metadata = btrfs_fs_incompat(fs_info, SKINNY_METADATA);
 
-	if (!skinny_metadata)
+	ref = btrfs_delayed_node_to_tree_ref(node);
+
+	if (node->type == BTRFS_SHARED_BLOCK_REF_KEY)
+		parent = ref->parent;
+	else
+		parent = 0;
+
+	extent_key.objectid = node->bytenr;
+	if (skinny_metadata) {
+		extent_key.offset = ref->level;
+		extent_key.type = BTRFS_METADATA_ITEM_KEY;
+		num_bytes = fs_info->nodesize;
+	} else {
+		extent_key.offset = node->num_bytes;
+		extent_key.type = BTRFS_EXTENT_ITEM_KEY;
 		size += sizeof(*block_info);
+		num_bytes = node->num_bytes;
+	}
 
 	path = btrfs_alloc_path();
 	if (!path) {
-		btrfs_free_and_pin_reserved_extent(fs_info, ins->objectid,
+		btrfs_free_and_pin_reserved_extent(fs_info,
+						   extent_key.objectid,
 						   fs_info->nodesize);
 		return -ENOMEM;
 	}
 
 	path->leave_spinning = 1;
 	ret = btrfs_insert_empty_item(trans, fs_info->extent_root, path,
-				      ins, size);
+				      &extent_key, size);
 	if (ret) {
 		btrfs_free_path(path);
-		btrfs_free_and_pin_reserved_extent(fs_info, ins->objectid,
+		btrfs_free_and_pin_reserved_extent(fs_info,
+						   extent_key.objectid,
 						   fs_info->nodesize);
 		return ret;
 	}
@@ -8188,11 +8195,10 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 
 	if (skinny_metadata) {
 		iref = (struct btrfs_extent_inline_ref *)(extent_item + 1);
-		num_bytes = fs_info->nodesize;
 	} else {
 		block_info = (struct btrfs_tree_block_info *)(extent_item + 1);
 		btrfs_set_tree_block_key(leaf, block_info, key);
-		btrfs_set_tree_block_level(leaf, block_info, level);
+		btrfs_set_tree_block_level(leaf, block_info, ref->level);
 		iref = (struct btrfs_extent_inline_ref *)(block_info + 1);
 	}
 
@@ -8204,25 +8210,26 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	} else {
 		btrfs_set_extent_inline_ref_type(leaf, iref,
 						 BTRFS_TREE_BLOCK_REF_KEY);
-		btrfs_set_extent_inline_ref_offset(leaf, iref, root_objectid);
+		btrfs_set_extent_inline_ref_offset(leaf, iref, ref->root);
 	}
 
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_free_path(path);
 
-	ret = remove_from_free_space_tree(trans, ins->objectid, num_bytes);
+	ret = remove_from_free_space_tree(trans, extent_key.objectid,
+					  num_bytes);
 	if (ret)
 		return ret;
 
-	ret = update_block_group(trans, fs_info, ins->objectid,
+	ret = update_block_group(trans, fs_info, extent_key.objectid,
 				 fs_info->nodesize, 1);
 	if (ret) { /* -ENOENT, logic error */
 		btrfs_err(fs_info, "update block group failed for %llu %llu",
-			ins->objectid, ins->offset);
+			extent_key.objectid, extent_key.offset);
 		BUG();
 	}
 
-	trace_btrfs_reserved_extent_alloc(fs_info, ins->objectid,
+	trace_btrfs_reserved_extent_alloc(fs_info, extent_key.objectid,
 					  fs_info->nodesize);
 	return ret;
 }
-- 
2.7.4

