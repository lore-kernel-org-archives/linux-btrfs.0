Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56835 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755544AbeCHOgF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 09:36:05 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8E2C3AE19
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 14:36:04 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 15/22] btrfs: kill trivial wrapper tree_mod_log_eb_move
Date: Thu,  8 Mar 2018 15:33:40 +0100
Message-Id: <a8a6a4c1ac0d7693438ac62e6af90b1b14a85220.1520518876.git.dsterba@suse.com>
In-Reply-To: <cover.1520518876.git.dsterba@suse.com>
References: <cover.1520518876.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The wrapper is effectively an alias for tree_mod_log_insert_move but
also hides the missing error handling. To make that more visible, lift
the BUG_ON to the callers.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 7d39ef6ce20a..45c17433bb76 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -837,14 +837,6 @@ tree_mod_log_eb_copy(struct btrfs_fs_info *fs_info, struct extent_buffer *dst,
 	return ret;
 }
 
-static inline void tree_mod_log_eb_move(struct extent_buffer *dst,
-		     int dst_offset, int src_offset, int nr_items)
-{
-	int ret;
-	ret = tree_mod_log_insert_move(dst, dst_offset, src_offset, nr_items);
-	BUG_ON(ret < 0);
-}
-
 static noinline void tree_mod_log_set_node_key(struct extent_buffer *eb,
 		int slot, int atomic)
 {
@@ -3225,8 +3217,8 @@ static int push_node_left(struct btrfs_trans_handle *trans,
 
 	if (push_items < src_nritems) {
 		/*
-		 * don't call tree_mod_log_eb_move here, key removal was already
-		 * fully logged by tree_mod_log_eb_copy above.
+		 * Don't call tree_mod_log_insert_move here, key removal was
+		 * already fully logged by tree_mod_log_eb_copy above.
 		 */
 		memmove_extent_buffer(src, btrfs_node_key_ptr_offset(0),
 				      btrfs_node_key_ptr_offset(push_items),
@@ -3281,7 +3273,8 @@ static int balance_node_right(struct btrfs_trans_handle *trans,
 	if (max_push < push_items)
 		push_items = max_push;
 
-	tree_mod_log_eb_move(dst, push_items, 0, dst_nritems);
+	ret = tree_mod_log_insert_move(dst, push_items, 0, dst_nritems);
+	BUG_ON(ret < 0);
 	memmove_extent_buffer(dst, btrfs_node_key_ptr_offset(push_items),
 				      btrfs_node_key_ptr_offset(0),
 				      (dst_nritems) *
@@ -3399,9 +3392,11 @@ static void insert_ptr(struct btrfs_trans_handle *trans,
 	BUG_ON(slot > nritems);
 	BUG_ON(nritems == BTRFS_NODEPTRS_PER_BLOCK(fs_info));
 	if (slot != nritems) {
-		if (level)
-			tree_mod_log_eb_move(lower, slot + 1, slot,
+		if (level) {
+			ret = tree_mod_log_insert_move(lower, slot + 1, slot,
 					nritems - slot);
+			BUG_ON(ret < 0);
+		}
 		memmove_extent_buffer(lower,
 			      btrfs_node_key_ptr_offset(slot + 1),
 			      btrfs_node_key_ptr_offset(slot),
@@ -4872,9 +4867,11 @@ static void del_ptr(struct btrfs_root *root, struct btrfs_path *path,
 
 	nritems = btrfs_header_nritems(parent);
 	if (slot != nritems - 1) {
-		if (level)
-			tree_mod_log_eb_move(parent, slot, slot + 1,
+		if (level) {
+			ret = tree_mod_log_insert_move(parent, slot, slot + 1,
 					nritems - slot - 1);
+			BUG_ON(ret < 0);
+		}
 		memmove_extent_buffer(parent,
 			      btrfs_node_key_ptr_offset(slot),
 			      btrfs_node_key_ptr_offset(slot + 1),
-- 
2.16.2

