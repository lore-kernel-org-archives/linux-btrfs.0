Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35329 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934140AbdBQOoH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:44:07 -0500
Received: by mail-wm0-f65.google.com with SMTP id u63so2926033wmu.2
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:44:06 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 18/38] btrfs: Make fille_holes take btrfs_inode
Date: Fri, 17 Feb 2017 16:43:09 +0200
Message-Id: <1487342609-20652-19-git-send-email-nborisov@suse.com>
In-Reply-To: <1487342609-20652-1-git-send-email-nborisov@suse.com>
References: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Nikolay Borisov <n.borisov.lkml@gmail.com>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/file.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 53fedf3dcaef..e37b643205e1 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2222,22 +2222,22 @@ static int hole_mergeable(struct btrfs_inode *inode, struct extent_buffer *leaf,
 	return 0;
 }
 
-static int fill_holes(struct btrfs_trans_handle *trans, struct inode *inode,
+static int fill_holes(struct btrfs_trans_handle *trans, struct btrfs_inode *inode,
 		      struct btrfs_path *path, u64 offset, u64 end)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
+	struct btrfs_root *root = inode->root;
 	struct extent_buffer *leaf;
 	struct btrfs_file_extent_item *fi;
 	struct extent_map *hole_em;
-	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
+	struct extent_map_tree *em_tree = &inode->extent_tree;
 	struct btrfs_key key;
 	int ret;
 
 	if (btrfs_fs_incompat(fs_info, NO_HOLES))
 		goto out;
 
-	key.objectid = btrfs_ino(BTRFS_I(inode));
+	key.objectid = btrfs_ino(inode);
 	key.type = BTRFS_EXTENT_DATA_KEY;
 	key.offset = offset;
 
@@ -2253,7 +2253,7 @@ static int fill_holes(struct btrfs_trans_handle *trans, struct inode *inode,
 	}
 
 	leaf = path->nodes[0];
-	if (hole_mergeable(BTRFS_I(inode), leaf, path->slots[0]-1, offset, end)) {
+	if (hole_mergeable(inode, leaf, path->slots[0]-1, offset, end)) {
 		u64 num_bytes;
 
 		path->slots[0]--;
@@ -2268,7 +2268,7 @@ static int fill_holes(struct btrfs_trans_handle *trans, struct inode *inode,
 		goto out;
 	}
 
-	if (hole_mergeable(BTRFS_I(inode), leaf, path->slots[0], offset, end)) {
+	if (hole_mergeable(inode, leaf, path->slots[0], offset, end)) {
 		u64 num_bytes;
 
 		key.offset = offset;
@@ -2285,7 +2285,7 @@ static int fill_holes(struct btrfs_trans_handle *trans, struct inode *inode,
 	}
 	btrfs_release_path(path);
 
-	ret = btrfs_insert_file_extent(trans, root, btrfs_ino(BTRFS_I(inode)),
+	ret = btrfs_insert_file_extent(trans, root, btrfs_ino(inode),
 			offset, 0, 0, end - offset, 0, end - offset, 0, 0, 0);
 	if (ret)
 		return ret;
@@ -2295,9 +2295,8 @@ static int fill_holes(struct btrfs_trans_handle *trans, struct inode *inode,
 
 	hole_em = alloc_extent_map();
 	if (!hole_em) {
-		btrfs_drop_extent_cache(BTRFS_I(inode), offset, end - 1, 0);
-		set_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
-			&BTRFS_I(inode)->runtime_flags);
+		btrfs_drop_extent_cache(inode, offset, end - 1, 0);
+		set_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &inode->runtime_flags);
 	} else {
 		hole_em->start = offset;
 		hole_em->len = end - offset;
@@ -2312,15 +2311,14 @@ static int fill_holes(struct btrfs_trans_handle *trans, struct inode *inode,
 		hole_em->generation = trans->transid;
 
 		do {
-			btrfs_drop_extent_cache(BTRFS_I(inode), offset, end - 1, 0);
+			btrfs_drop_extent_cache(inode, offset, end - 1, 0);
 			write_lock(&em_tree->lock);
 			ret = add_extent_mapping(em_tree, hole_em, 1);
 			write_unlock(&em_tree->lock);
 		} while (ret == -EEXIST);
 		free_extent_map(hole_em);
 		if (ret)
-			set_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
-				&BTRFS_I(inode)->runtime_flags);
+			set_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &inode->runtime_flags);
 	}
 
 	return 0;
@@ -2550,7 +2548,7 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 		trans->block_rsv = &fs_info->trans_block_rsv;
 
 		if (cur_offset < drop_end && cur_offset < ino_size) {
-			ret = fill_holes(trans, inode, path, cur_offset,
+			ret = fill_holes(trans, BTRFS_I(inode), path, cur_offset,
 					 drop_end);
 			if (ret) {
 				/*
@@ -2622,7 +2620,7 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	 * cur_offset == drop_end).
 	 */
 	if (cur_offset < ino_size && cur_offset < drop_end) {
-		ret = fill_holes(trans, inode, path, cur_offset, drop_end);
+		ret = fill_holes(trans, BTRFS_I(inode), path, cur_offset, drop_end);
 		if (ret) {
 			/* Same comment as above. */
 			btrfs_abort_transaction(trans, ret);
-- 
2.7.4

