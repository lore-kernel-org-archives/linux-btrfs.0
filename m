Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56810 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754915AbeCHOfw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 09:35:52 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8760EAE85
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 14:35:51 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 11/22] btrfs: drop unused fs_info parameter from tree_mod_log_eb_move
Date: Thu,  8 Mar 2018 15:33:31 +0100
Message-Id: <d81002ac1327d0818f5971bfb16b6b63c26e7cd8.1520518876.git.dsterba@suse.com>
In-Reply-To: <cover.1520518876.git.dsterba@suse.com>
References: <cover.1520518876.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 632beadf5725..5585433eac40 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -859,8 +859,7 @@ tree_mod_log_eb_copy(struct btrfs_fs_info *fs_info, struct extent_buffer *dst,
 	return ret;
 }
 
-static inline void
-tree_mod_log_eb_move(struct btrfs_fs_info *fs_info, struct extent_buffer *dst,
+static inline void tree_mod_log_eb_move(struct extent_buffer *dst,
 		     int dst_offset, int src_offset, int nr_items)
 {
 	int ret;
@@ -3305,7 +3304,7 @@ static int balance_node_right(struct btrfs_trans_handle *trans,
 	if (max_push < push_items)
 		push_items = max_push;
 
-	tree_mod_log_eb_move(fs_info, dst, push_items, 0, dst_nritems);
+	tree_mod_log_eb_move(dst, push_items, 0, dst_nritems);
 	memmove_extent_buffer(dst, btrfs_node_key_ptr_offset(push_items),
 				      btrfs_node_key_ptr_offset(0),
 				      (dst_nritems) *
@@ -3424,8 +3423,8 @@ static void insert_ptr(struct btrfs_trans_handle *trans,
 	BUG_ON(nritems == BTRFS_NODEPTRS_PER_BLOCK(fs_info));
 	if (slot != nritems) {
 		if (level)
-			tree_mod_log_eb_move(fs_info, lower, slot + 1,
-					     slot, nritems - slot);
+			tree_mod_log_eb_move(lower, slot + 1, slot,
+					nritems - slot);
 		memmove_extent_buffer(lower,
 			      btrfs_node_key_ptr_offset(slot + 1),
 			      btrfs_node_key_ptr_offset(slot),
@@ -4897,8 +4896,8 @@ static void del_ptr(struct btrfs_root *root, struct btrfs_path *path,
 	nritems = btrfs_header_nritems(parent);
 	if (slot != nritems - 1) {
 		if (level)
-			tree_mod_log_eb_move(fs_info, parent, slot,
-					     slot + 1, nritems - slot - 1);
+			tree_mod_log_eb_move(parent, slot, slot + 1,
+					nritems - slot - 1);
 		memmove_extent_buffer(parent,
 			      btrfs_node_key_ptr_offset(slot),
 			      btrfs_node_key_ptr_offset(slot + 1),
-- 
2.16.2

