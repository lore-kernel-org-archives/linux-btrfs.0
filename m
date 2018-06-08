Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44258 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752700AbeFHMsD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Jun 2018 08:48:03 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6771BAF9A
        for <linux-btrfs@vger.kernel.org>; Fri,  8 Jun 2018 12:48:02 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 04/15] btrfs-progs: Refactor the root used bytes are updated
Date: Fri,  8 Jun 2018 15:47:47 +0300
Message-Id: <1528462078-24490-5-git-send-email-nborisov@suse.com>
In-Reply-To: <1528462078-24490-1-git-send-email-nborisov@suse.com>
References: <1528462078-24490-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Instead of updating this during update_block_group, move the updating
code at the places where we free/allocate a block. This resembles the
current state of the kernel code. This is in prep for delayed refs.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 ctree.c       | 13 +++++++++++++
 extent-tree.c |  8 --------
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/ctree.c b/ctree.c
index 7b74716bf92f..8f3338b4693a 100644
--- a/ctree.c
+++ b/ctree.c
@@ -734,6 +734,8 @@ static int balance_level(struct btrfs_trans_handle *trans,
 		/* once for the path */
 		free_extent_buffer(mid);
 
+		root_sub_used(root, mid->len);
+
 		ret = btrfs_free_extent(trans, root, mid->start, mid->len,
 					0, root->root_key.objectid,
 					level, 1);
@@ -789,6 +791,8 @@ static int balance_level(struct btrfs_trans_handle *trans,
 			wret = btrfs_del_ptr(root, path, level + 1, pslot + 1);
 			if (wret)
 				ret = wret;
+
+			root_sub_used(root, right->len);
 			wret = btrfs_free_extent(trans, root, bytenr,
 						 blocksize, 0,
 						 root->root_key.objectid,
@@ -835,6 +839,8 @@ static int balance_level(struct btrfs_trans_handle *trans,
 		wret = btrfs_del_ptr(root, path, level + 1, pslot);
 		if (wret)
 			ret = wret;
+
+		root_sub_used(root, blocksize);
 		wret = btrfs_free_extent(trans, root, bytenr, blocksize,
 					 0, root->root_key.objectid,
 					 level, 0);
@@ -1466,6 +1472,8 @@ static int noinline insert_new_root(struct btrfs_trans_handle *trans,
 	btrfs_set_header_backref_rev(c, BTRFS_MIXED_BACKREF_REV);
 	btrfs_set_header_owner(c, root->root_key.objectid);
 
+	root_add_used(root, root->fs_info->nodesize);
+
 	write_extent_buffer(c, root->fs_info->fsid,
 			    btrfs_header_fsid(), BTRFS_FSID_SIZE);
 
@@ -1593,6 +1601,7 @@ static int split_node(struct btrfs_trans_handle *trans, struct btrfs_root
 			    btrfs_header_chunk_tree_uuid(split),
 			    BTRFS_UUID_SIZE);
 
+	root_add_used(root, root->fs_info->nodesize);
 
 	copy_extent_buffer(split, c,
 			   btrfs_node_key_ptr_offset(0),
@@ -2175,6 +2184,8 @@ static noinline int split_leaf(struct btrfs_trans_handle *trans,
 			    btrfs_header_chunk_tree_uuid(right),
 			    BTRFS_UUID_SIZE);
 
+	root_add_used(root, root->fs_info->nodesize);
+
 	if (split == 0) {
 		if (mid <= slot) {
 			btrfs_set_header_nritems(right, 0);
@@ -2694,6 +2705,8 @@ static noinline int btrfs_del_leaf(struct btrfs_trans_handle *trans,
 	if (ret)
 		return ret;
 
+	root_sub_used(root, leaf->len);
+
 	ret = btrfs_free_extent(trans, root, leaf->start, leaf->len,
 				0, root->root_key.objectid, 0, 0);
 	return ret;
diff --git a/extent-tree.c b/extent-tree.c
index c6f09b52800f..07b5fb99e8cf 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1932,14 +1932,6 @@ static int update_block_group(struct btrfs_root *root,
 		old_val -= num_bytes;
 	btrfs_set_super_bytes_used(info->super_copy, old_val);
 
-	/* block accounting for root item */
-	old_val = btrfs_root_used(&root->root_item);
-	if (alloc)
-		old_val += num_bytes;
-	else
-		old_val -= num_bytes;
-	btrfs_set_root_used(&root->root_item, old_val);
-
 	while(total) {
 		cache = btrfs_lookup_block_group(info, bytenr);
 		if (!cache) {
-- 
2.7.4

