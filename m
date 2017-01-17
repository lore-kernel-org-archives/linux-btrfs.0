Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33738 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751353AbdAQWjv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 17:39:51 -0500
Received: by mail-wm0-f66.google.com with SMTP id r144so41966062wme.0
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jan 2017 14:39:45 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCHv2 10/24] btrfs: Make copy_items take btrfs_inode
Date: Wed, 18 Jan 2017 00:31:36 +0200
Message-Id: <1484692310-3987-11-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484692310-3987-1-git-send-email-n.borisov.lkml@gmail.com>
References: <20170117161550.GW12081@twin.jikos.cz>
 <1484692310-3987-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/tree-log.c | 40 +++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 7669e95be423..12872bf492bd 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3613,16 +3613,16 @@ static int log_inode_item(struct btrfs_trans_handle *trans,
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
@@ -3633,7 +3633,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 	char *ins_data;
 	int i;
 	struct list_head ordered_sums;
-	int skip_csum = BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM;
+	int skip_csum = inode->flags & BTRFS_INODE_NODATASUM;
 	bool has_extents = false;
 	bool need_find_last_extent = true;
 	bool done = false;
@@ -3675,7 +3675,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 						    dst_path->slots[0],
 						    struct btrfs_inode_item);
 			fill_inode_item(trans, dst_path->nodes[0], inode_item,
-					inode, inode_only == LOG_INODE_EXISTS,
+					&inode->vfs_inode, inode_only == LOG_INODE_EXISTS,
 					logged_isize);
 		} else {
 			copy_extent_buffer(dst_path->nodes[0], src, dst_offset,
@@ -3783,7 +3783,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 	if (need_find_last_extent) {
 		u64 len;
 
-		ret = btrfs_prev_leaf(BTRFS_I(inode)->root, src_path);
+		ret = btrfs_prev_leaf(inode->root, src_path);
 		if (ret < 0)
 			return ret;
 		if (ret)
@@ -3792,7 +3792,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 			src_path->slots[0]--;
 		src = src_path->nodes[0];
 		btrfs_item_key_to_cpu(src, &key, src_path->slots[0]);
-		if (key.objectid != btrfs_ino(BTRFS_I(inode)) ||
+		if (key.objectid != btrfs_ino(inode) ||
 		    key.type != BTRFS_EXTENT_DATA_KEY)
 			goto fill_holes;
 		extent = btrfs_item_ptr(src, src_path->slots[0],
@@ -3825,8 +3825,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 	if (need_find_last_extent) {
 		/* btrfs_prev_leaf could return 1 without releasing the path */
 		btrfs_release_path(src_path);
-		ret = btrfs_search_slot(NULL, BTRFS_I(inode)->root, &first_key,
-					src_path, 0, 0);
+		ret = btrfs_search_slot(NULL, inode->root, &first_key, src_path, 0, 0);
 		if (ret < 0)
 			return ret;
 		ASSERT(ret == 0);
@@ -3846,7 +3845,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 		u64 extent_end;
 
 		if (i >= btrfs_header_nritems(src_path->nodes[0])) {
-			ret = btrfs_next_leaf(BTRFS_I(inode)->root, src_path);
+			ret = btrfs_next_leaf(inode->root, src_path);
 			if (ret < 0)
 				return ret;
 			ASSERT(ret == 0);
@@ -3857,7 +3856,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 		btrfs_item_key_to_cpu(src, &key, i);
 		if (!btrfs_comp_cpu_keys(&key, &last_key))
 			done = true;
-		if (key.objectid != btrfs_ino(BTRFS_I(inode)) ||
+		if (key.objectid != btrfs_ino(inode) ||
 		    key.type != BTRFS_EXTENT_DATA_KEY) {
 			i++;
 			continue;
@@ -3880,9 +3879,8 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
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
@@ -4306,7 +4304,7 @@ static int btrfs_log_all_xattrs(struct btrfs_trans_handle *trans,
 			if (ins_nr > 0) {
 				u64 last_extent = 0;
 
-				ret = copy_items(trans, inode, dst_path, path,
+				ret = copy_items(trans, BTRFS_I(inode), dst_path, path,
 						 &last_extent, start_slot,
 						 ins_nr, 1, 0);
 				/* can't be 1, extent items aren't processed */
@@ -4336,7 +4334,7 @@ static int btrfs_log_all_xattrs(struct btrfs_trans_handle *trans,
 	if (ins_nr > 0) {
 		u64 last_extent = 0;
 
-		ret = copy_items(trans, inode, dst_path, path,
+		ret = copy_items(trans, BTRFS_I(inode), dst_path, path,
 				 &last_extent, start_slot,
 				 ins_nr, 1, 0);
 		/* can't be 1, extent items aren't processed */
@@ -4784,7 +4782,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 					ins_nr = 1;
 					ins_start_slot = path->slots[0];
 				}
-				ret = copy_items(trans, inode, dst_path, path,
+				ret = copy_items(trans, BTRFS_I(inode), dst_path, path,
 						 &last_extent, ins_start_slot,
 						 ins_nr, inode_only,
 						 logged_isize);
@@ -4837,7 +4835,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 		if (min_key.type == BTRFS_XATTR_ITEM_KEY) {
 			if (ins_nr == 0)
 				goto next_slot;
-			ret = copy_items(trans, inode, dst_path, path,
+			ret = copy_items(trans, BTRFS_I(inode), dst_path, path,
 					 &last_extent, ins_start_slot,
 					 ins_nr, inode_only, logged_isize);
 			if (ret < 0) {
@@ -4862,7 +4860,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 			goto next_slot;
 		}
 
-		ret = copy_items(trans, inode, dst_path, path, &last_extent,
+		ret = copy_items(trans, BTRFS_I(inode), dst_path, path, &last_extent,
 				 ins_start_slot, ins_nr, inode_only,
 				 logged_isize);
 		if (ret < 0) {
@@ -4886,7 +4884,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 			goto again;
 		}
 		if (ins_nr) {
-			ret = copy_items(trans, inode, dst_path, path,
+			ret = copy_items(trans, BTRFS_I(inode), dst_path, path,
 					 &last_extent, ins_start_slot,
 					 ins_nr, inode_only, logged_isize);
 			if (ret < 0) {
@@ -4908,7 +4906,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
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

