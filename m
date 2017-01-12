Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36271 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750974AbdALOBJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jan 2017 09:01:09 -0500
Received: by mail-wm0-f68.google.com with SMTP id r126so3895025wmr.3
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Jan 2017 06:01:08 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCH 10/24] btrfs: Make copy_items take btrfs_inode
Date: Thu, 12 Jan 2017 16:00:36 +0200
Message-Id: <1484229650-24554-11-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484229650-24554-1-git-send-email-n.borisov.lkml@gmail.com>
References: <1484229650-24554-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/tree-log.c | 40 +++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 2b44835b4dea..4b0bbe05cdae 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3612,16 +3612,16 @@ static int log_inode_item(struct btrfs_trans_handle *trans,
 }
 
 static noinline int copy_items(struct btrfs_trans_handle *trans,
-			       struct inode *inode,
+			       struct btrfs_inode *inode,
 			       struct btrfs_path *dst_path,
 			       struct btrfs_path *src_path, u64 *last_extent,
 			       int start_slot, int nr, int inode_only,
 			       u64 logged_isize)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
 	unsigned long src_offset;
 	unsigned long dst_offset;
-	struct btrfs_root *log = BTRFS_I(inode)->root->log_root;
+	struct btrfs_root *log = inode->root->log_root;
 	struct btrfs_file_extent_item *extent;
 	struct btrfs_inode_item *inode_item;
 	struct extent_buffer *src = src_path->nodes[0];
@@ -3632,7 +3632,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 	char *ins_data;
 	int i;
 	struct list_head ordered_sums;
-	int skip_csum = BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM;
+	int skip_csum = inode->flags & BTRFS_INODE_NODATASUM;
 	bool has_extents = false;
 	bool need_find_last_extent = true;
 	bool done = false;
@@ -3674,7 +3674,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 						    dst_path->slots[0],
 						    struct btrfs_inode_item);
 			fill_inode_item(trans, dst_path->nodes[0], inode_item,
-					inode, inode_only == LOG_INODE_EXISTS,
+					&inode->vfs_inode, inode_only == LOG_INODE_EXISTS,
 					logged_isize);
 		} else {
 			copy_extent_buffer(dst_path->nodes[0], src, dst_offset,
@@ -3782,7 +3782,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 	if (need_find_last_extent) {
 		u64 len;
 
-		ret = btrfs_prev_leaf(BTRFS_I(inode)->root, src_path);
+		ret = btrfs_prev_leaf(inode->root, src_path);
 		if (ret < 0)
 			return ret;
 		if (ret)
@@ -3791,7 +3791,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 			src_path->slots[0]--;
 		src = src_path->nodes[0];
 		btrfs_item_key_to_cpu(src, &key, src_path->slots[0]);
-		if (key.objectid != btrfs_ino(BTRFS_I(inode)) ||
+		if (key.objectid != btrfs_ino(inode) ||
 		    key.type != BTRFS_EXTENT_DATA_KEY)
 			goto fill_holes;
 		extent = btrfs_item_ptr(src, src_path->slots[0],
@@ -3824,8 +3824,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 	if (need_find_last_extent) {
 		/* btrfs_prev_leaf could return 1 without releasing the path */
 		btrfs_release_path(src_path);
-		ret = btrfs_search_slot(NULL, BTRFS_I(inode)->root, &first_key,
-					src_path, 0, 0);
+		ret = btrfs_search_slot(NULL, inode->root, &first_key, src_path, 0, 0);
 		if (ret < 0)
 			return ret;
 		ASSERT(ret == 0);
@@ -3845,7 +3844,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 		u64 extent_end;
 
 		if (i >= btrfs_header_nritems(src_path->nodes[0])) {
-			ret = btrfs_next_leaf(BTRFS_I(inode)->root, src_path);
+			ret = btrfs_next_leaf(inode->root, src_path);
 			if (ret < 0)
 				return ret;
 			ASSERT(ret == 0);
@@ -3856,7 +3855,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 		btrfs_item_key_to_cpu(src, &key, i);
 		if (!btrfs_comp_cpu_keys(&key, &last_key))
 			done = true;
-		if (key.objectid != btrfs_ino(BTRFS_I(inode)) ||
+		if (key.objectid != btrfs_ino(inode) ||
 		    key.type != BTRFS_EXTENT_DATA_KEY) {
 			i++;
 			continue;
@@ -3879,9 +3878,8 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 		}
 		offset = *last_extent;
 		len = key.offset - *last_extent;
-		ret = btrfs_insert_file_extent(trans, log, btrfs_ino(BTRFS_I(inode)),
-					       offset, 0, 0, len, 0, len, 0,
-					       0, 0);
+		ret = btrfs_insert_file_extent(trans, log, btrfs_ino(inode),
+					       offset, 0, 0, len, 0, len, 0, 0, 0);
 		if (ret)
 			break;
 		*last_extent = extent_end;
@@ -4305,7 +4303,7 @@ static int btrfs_log_all_xattrs(struct btrfs_trans_handle *trans,
 			if (ins_nr > 0) {
 				u64 last_extent = 0;
 
-				ret = copy_items(trans, inode, dst_path, path,
+				ret = copy_items(trans, BTRFS_I(inode), dst_path, path,
 						 &last_extent, start_slot,
 						 ins_nr, 1, 0);
 				/* can't be 1, extent items aren't processed */
@@ -4335,7 +4333,7 @@ static int btrfs_log_all_xattrs(struct btrfs_trans_handle *trans,
 	if (ins_nr > 0) {
 		u64 last_extent = 0;
 
-		ret = copy_items(trans, inode, dst_path, path,
+		ret = copy_items(trans, BTRFS_I(inode), dst_path, path,
 				 &last_extent, start_slot,
 				 ins_nr, 1, 0);
 		/* can't be 1, extent items aren't processed */
@@ -4777,7 +4775,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 					ins_nr = 1;
 					ins_start_slot = path->slots[0];
 				}
-				ret = copy_items(trans, inode, dst_path, path,
+				ret = copy_items(trans, BTRFS_I(inode), dst_path, path,
 						 &last_extent, ins_start_slot,
 						 ins_nr, inode_only,
 						 logged_isize);
@@ -4830,7 +4828,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 		if (min_key.type == BTRFS_XATTR_ITEM_KEY) {
 			if (ins_nr == 0)
 				goto next_slot;
-			ret = copy_items(trans, inode, dst_path, path,
+			ret = copy_items(trans, BTRFS_I(inode), dst_path, path,
 					 &last_extent, ins_start_slot,
 					 ins_nr, inode_only, logged_isize);
 			if (ret < 0) {
@@ -4855,7 +4853,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 			goto next_slot;
 		}
 
-		ret = copy_items(trans, inode, dst_path, path, &last_extent,
+		ret = copy_items(trans, BTRFS_I(inode), dst_path, path, &last_extent,
 				 ins_start_slot, ins_nr, inode_only,
 				 logged_isize);
 		if (ret < 0) {
@@ -4879,7 +4877,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 			goto again;
 		}
 		if (ins_nr) {
-			ret = copy_items(trans, inode, dst_path, path,
+			ret = copy_items(trans, BTRFS_I(inode), dst_path, path,
 					 &last_extent, ins_start_slot,
 					 ins_nr, inode_only, logged_isize);
 			if (ret < 0) {
@@ -4901,7 +4899,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 		}
 	}
 	if (ins_nr) {
-		ret = copy_items(trans, inode, dst_path, path, &last_extent,
+		ret = copy_items(trans, BTRFS_I(inode), dst_path, path, &last_extent,
 				 ins_start_slot, ins_nr, inode_only,
 				 logged_isize);
 		if (ret < 0) {
-- 
2.7.4

