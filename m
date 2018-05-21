Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43610 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751724AbeEUJ1c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 May 2018 05:27:32 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3D334AEA6
        for <linux-btrfs@vger.kernel.org>; Mon, 21 May 2018 09:27:31 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/4] btrfs: Pass btrfs_delayed_extent_op to alloc_reserved_tree_block
Date: Mon, 21 May 2018 12:27:22 +0300
Message-Id: <1526894843-8732-4-git-send-email-nborisov@suse.com>
In-Reply-To: <1526894843-8732-1-git-send-email-nborisov@suse.com>
References: <1526894843-8732-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Instead of taking only specific member of this structure, which results
in 2 extra arguments, just take the delayed_extent_op struct and
reference the arguments inside the functions. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index fe7f7f5d99dc..4d092d14cbe9 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -67,7 +67,7 @@ static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 				      struct btrfs_key *ins, int ref_mod);
 static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 				     struct btrfs_delayed_ref_node *node,
-				     u64 flags, struct btrfs_disk_key *key);
+				     struct btrfs_delayed_extent_op *extent_op);
 static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 			  struct btrfs_fs_info *fs_info, u64 flags,
 			  int force);
@@ -2448,9 +2448,7 @@ static int run_delayed_tree_ref(struct btrfs_trans_handle *trans,
 	}
 	if (node->action == BTRFS_ADD_DELAYED_REF && insert_reserved) {
 		BUG_ON(!extent_op || !extent_op->update_flags);
-		ret = alloc_reserved_tree_block(trans, node,
-						extent_op->flags_to_set,
-						&extent_op->key);
+		ret = alloc_reserved_tree_block(trans, node, extent_op);
 	} else if (node->action == BTRFS_ADD_DELAYED_REF) {
 		ret = __btrfs_inc_extent_ref(trans, fs_info, node,
 					     parent, ref_root,
@@ -8131,7 +8129,7 @@ static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 
 static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 				     struct btrfs_delayed_ref_node *node,
-				     u64 flags, struct btrfs_disk_key *key)
+				     struct btrfs_delayed_extent_op *extent_op)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	int ret;
@@ -8145,6 +8143,7 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	u32 size = sizeof(*extent_item) + sizeof(*iref);
 	u64 num_bytes;
 	u64 parent;
+	u64 flags = extent_op->flags_to_set;
 	bool skinny_metadata = btrfs_fs_incompat(fs_info, SKINNY_METADATA);
 
 	ref = btrfs_delayed_node_to_tree_ref(node);
@@ -8197,7 +8196,7 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 		iref = (struct btrfs_extent_inline_ref *)(extent_item + 1);
 	} else {
 		block_info = (struct btrfs_tree_block_info *)(extent_item + 1);
-		btrfs_set_tree_block_key(leaf, block_info, key);
+		btrfs_set_tree_block_key(leaf, block_info, &extent_op->key);
 		btrfs_set_tree_block_level(leaf, block_info, ref->level);
 		iref = (struct btrfs_extent_inline_ref *)(block_info + 1);
 	}
-- 
2.7.4

