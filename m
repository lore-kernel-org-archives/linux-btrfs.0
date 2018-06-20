Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48955 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754071AbeFTMtZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 08:49:25 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 79422ADBD
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 12:49:24 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 17/34] btrfs: Remove fs_info argument from __btrfs_inc_extent_ref
Date: Wed, 20 Jun 2018 15:48:59 +0300
Message-Id: <1529498956-4241-18-git-send-email-nborisov@suse.com>
In-Reply-To: <1529498956-4241-1-git-send-email-nborisov@suse.com>
References: <1529498956-4241-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function already takes a transaction which holds a reference to
the fs_info struct. Use that reference and remove the extra arg. No
functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 449ebd1bb8c9..b72a6d7d84c3 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2197,12 +2197,12 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 }
 
 static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
-				  struct btrfs_fs_info *fs_info,
 				  struct btrfs_delayed_ref_node *node,
 				  u64 parent, u64 root_objectid,
 				  u64 owner, u64 offset, int refs_to_add,
 				  struct btrfs_delayed_extent_op *extent_op)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
 	struct btrfs_extent_item *item;
@@ -2286,10 +2286,9 @@ static int run_delayed_data_ref(struct btrfs_trans_handle *trans,
 						 ref->offset, &ins,
 						 node->ref_mod);
 	} else if (node->action == BTRFS_ADD_DELAYED_REF) {
-		ret = __btrfs_inc_extent_ref(trans, fs_info, node, parent,
-					     ref_root, ref->objectid,
-					     ref->offset, node->ref_mod,
-					     extent_op);
+		ret = __btrfs_inc_extent_ref(trans, node, parent, ref_root,
+					     ref->objectid, ref->offset,
+					     node->ref_mod, extent_op);
 	} else if (node->action == BTRFS_DROP_DELAYED_REF) {
 		ret = __btrfs_free_extent(trans, node, parent,
 					  ref_root, ref->objectid,
@@ -2439,10 +2438,8 @@ static int run_delayed_tree_ref(struct btrfs_trans_handle *trans,
 		BUG_ON(!extent_op || !extent_op->update_flags);
 		ret = alloc_reserved_tree_block(trans, node, extent_op);
 	} else if (node->action == BTRFS_ADD_DELAYED_REF) {
-		ret = __btrfs_inc_extent_ref(trans, fs_info, node,
-					     parent, ref_root,
-					     ref->level, 0, 1,
-					     extent_op);
+		ret = __btrfs_inc_extent_ref(trans, node, parent, ref_root,
+					     ref->level, 0, 1, extent_op);
 	} else if (node->action == BTRFS_DROP_DELAYED_REF) {
 		ret = __btrfs_free_extent(trans, node, parent, ref_root,
 					  ref->level, 0, 1, extent_op);
-- 
2.7.4

