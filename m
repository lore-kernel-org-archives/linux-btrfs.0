Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 2.mo4.mail-out.ovh.net ([46.105.72.36]:48516 "EHLO
	2.mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbcBUXqf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Feb 2016 18:46:35 -0500
Received: from mail178.ha.ovh.net (b9.ovh.net [213.186.33.59])
	by mo4.mail-out.ovh.net (Postfix) with SMTP id A8972106406D
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Feb 2016 00:46:33 +0100 (CET)
From: Philippe Loctaux <phil@philippeloctaux.com>
To: clm@fb.com
Cc: jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Philippe Loctaux <phil@philippeloctaux.com>
Subject: [PATCH] Btrfs: ctree: added lines after variable declarations
Date: Mon, 22 Feb 2016 00:46:30 +0100
Message-Id: <1456098390-9859-1-git-send-email-phil@philippeloctaux.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Added lines after variable declarations, fixing 22 checkpatch warnings.

Signed-off-by: Philippe Loctaux <phil@philippeloctaux.com>
---
 fs/btrfs/ctree.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 769e0ff..c9fd42d 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -45,6 +45,7 @@ static int tree_mod_log_free_eb(struct btrfs_fs_info *fs_info,
 struct btrfs_path *btrfs_alloc_path(void)
 {
 	struct btrfs_path *path;
+
 	path = kmem_cache_zalloc(btrfs_path_cachep, GFP_NOFS);
 	return path;
 }
@@ -56,6 +57,7 @@ struct btrfs_path *btrfs_alloc_path(void)
 noinline void btrfs_set_path_blocking(struct btrfs_path *p)
 {
 	int i;
+
 	for (i = 0; i < BTRFS_MAX_LEVEL; i++) {
 		if (!p->nodes[i] || !p->locks[i])
 			continue;
@@ -873,6 +875,7 @@ tree_mod_log_eb_move(struct btrfs_fs_info *fs_info, struct extent_buffer *dst,
 		     int dst_offset, int src_offset, int nr_items)
 {
 	int ret;
+
 	ret = tree_mod_log_insert_move(fs_info, dst, dst_offset, src_offset,
 				       nr_items, GFP_NOFS);
 	BUG_ON(ret < 0);
@@ -943,6 +946,7 @@ tree_mod_log_set_root_pointer(struct btrfs_root *root,
 			      int log_removal)
 {
 	int ret;
+
 	ret = tree_mod_log_insert_root(root->fs_info, root->node,
 				       new_root_node, GFP_NOFS, log_removal);
 	BUG_ON(ret < 0);
@@ -1734,6 +1738,7 @@ static inline unsigned int leaf_data_end(struct btrfs_root *root,
 					 struct extent_buffer *leaf)
 {
 	u32 nr = btrfs_header_nritems(leaf);
+
 	if (nr == 0)
 		return BTRFS_LEAF_DATA_SIZE(root);
 	return btrfs_item_offset_nr(leaf, nr - 1);
@@ -2011,6 +2016,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 			right = NULL;
 		} else {
 			struct btrfs_disk_key right_key;
+
 			btrfs_node_key(right, &right_key, 0);
 			tree_mod_log_set_node_key(root->fs_info, parent,
 						  pslot + 1, 0);
@@ -2056,6 +2062,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 	} else {
 		/* update the parent key to reflect our changes */
 		struct btrfs_disk_key mid_key;
+
 		btrfs_node_key(mid, &mid_key, 0);
 		tree_mod_log_set_node_key(root->fs_info, parent,
 					  pslot, 0);
@@ -2154,6 +2161,7 @@ static noinline int push_nodes_for_insert(struct btrfs_trans_handle *trans,
 			ret = wret;
 		if (wret == 0) {
 			struct btrfs_disk_key disk_key;
+
 			orig_slot += left_nr;
 			btrfs_node_key(mid, &disk_key, 0);
 			tree_mod_log_set_node_key(root->fs_info, parent,
@@ -2382,6 +2390,7 @@ static noinline void unlock_up(struct btrfs_path *path, int level,
 		}
 		if (!no_skips && path->keep_locks) {
 			u32 nritems;
+
 			t = path->nodes[i];
 			nritems = btrfs_header_nritems(t);
 			if (nritems < 1 || path->slots[i] >= nritems - 1) {
@@ -2529,6 +2538,7 @@ setup_nodes_for_search(struct btrfs_trans_handle *trans,
 		       int *write_lock_level)
 {
 	int ret;
+
 	if ((p->search_for_split || ins_len > 0) && btrfs_header_nritems(b) >=
 	    BTRFS_NODEPTRS_PER_BLOCK(root) - 3) {
 		int sret;
@@ -2825,6 +2835,7 @@ cow_done:
 
 		if (level != 0) {
 			int dec = 0;
+
 			if (ret && slot > 0) {
 				dec = 1;
 				slot -= 1;
@@ -2993,6 +3004,7 @@ again:
 
 		if (level != 0) {
 			int dec = 0;
+
 			if (ret && slot > 0) {
 				dec = 1;
 				slot -= 1;
@@ -3139,6 +3151,7 @@ static void fixup_low_keys(struct btrfs_fs_info *fs_info,
 
 	for (i = level; i < BTRFS_MAX_LEVEL; i++) {
 		int tslot = path->slots[i];
+
 		if (!path->nodes[i])
 			break;
 		t = path->nodes[i];
@@ -3574,6 +3587,7 @@ noinline int btrfs_leaf_free_space(struct btrfs_root *root,
 {
 	int nritems = btrfs_header_nritems(leaf);
 	int ret;
+
 	ret = BTRFS_LEAF_DATA_SIZE(root) - leaf_space_used(leaf, 0, nritems);
 	if (ret < 0) {
 		btrfs_crit(root->fs_info,
@@ -3630,6 +3644,7 @@ static noinline int __push_leaf_right(struct btrfs_trans_handle *trans,
 				break;
 			if (path->slots[0] == i) {
 				int space = btrfs_leaf_free_space(root, left);
+
 				if (space + push_space * 2 > free_space)
 					break;
 			}
@@ -3849,6 +3864,7 @@ static noinline int __push_leaf_left(struct btrfs_trans_handle *trans,
 				break;
 			if (path->slots[0] == i) {
 				int space = btrfs_leaf_free_space(root, right);
+
 				if (space + push_space * 2 > free_space)
 					break;
 			}
@@ -4488,6 +4504,7 @@ int btrfs_split_item(struct btrfs_trans_handle *trans,
 		     unsigned long split_offset)
 {
 	int ret;
+
 	ret = setup_leaf_for_split(trans, root, path,
 				   sizeof(struct btrfs_item));
 	if (ret)
@@ -4578,6 +4595,7 @@ void btrfs_truncate_item(struct btrfs_root *root, struct btrfs_path *path,
 	/* first correct the data pointers */
 	for (i = slot; i < nritems; i++) {
 		u32 ioff;
+
 		item = btrfs_item_nr(i);
 
 		ioff = btrfs_token_item_offset(leaf, item, &token);
@@ -4592,6 +4610,7 @@ void btrfs_truncate_item(struct btrfs_root *root, struct btrfs_path *path,
 			      data_end, old_data_start + new_size - data_end);
 	} else {
 		struct btrfs_disk_key disk_key;
+
 		u64 offset;
 
 		btrfs_item_key(leaf, &disk_key, slot);
@@ -4679,6 +4698,7 @@ void btrfs_extend_item(struct btrfs_root *root, struct btrfs_path *path,
 	/* first correct the data pointers */
 	for (i = slot; i < nritems; i++) {
 		u32 ioff;
+
 		item = btrfs_item_nr(i);
 
 		ioff = btrfs_token_item_offset(leaf, item, &token);
@@ -4993,6 +5013,7 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		}
 	} else {
 		int used = leaf_space_used(leaf, 0, nritems);
+
 		if (slot == 0) {
 			struct btrfs_disk_key disk_key;
 
@@ -5234,6 +5255,7 @@ static int tree_move_next_or_upnext(struct btrfs_root *root,
 {
 	int ret = 0;
 	int nritems;
+
 	nritems = btrfs_header_nritems(path->nodes[*level]);
 
 	path->slots[*level]++;
@@ -5598,6 +5620,7 @@ next:
 			int ret;
 			int orig_lowest;
 			struct btrfs_key cur_key;
+
 			if (level + 1 >= BTRFS_MAX_LEVEL ||
 			    !path->nodes[level + 1])
 				return 1;
-- 
2.7.1

