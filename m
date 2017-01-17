Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35237 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751059AbdAQWlZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 17:41:25 -0500
Received: by mail-wm0-f67.google.com with SMTP id d140so25597018wmd.2
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jan 2017 14:41:25 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCHv2 22/24] btrfs: Make btrfs_log_inode take btrfs_inode
Date: Wed, 18 Jan 2017 00:31:48 +0200
Message-Id: <1484692310-3987-23-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484692310-3987-1-git-send-email-n.borisov.lkml@gmail.com>
References: <20170117161550.GW12081@twin.jikos.cz>
 <1484692310-3987-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/tree-log.c | 92 ++++++++++++++++++++++++++---------------------------
 1 file changed, 45 insertions(+), 47 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 1348ab5e3229..8c110d0e16c3 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -97,7 +97,7 @@
 #define LOG_WALK_REPLAY_ALL 3
 
 static int btrfs_log_inode(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root, struct inode *inode,
+			   struct btrfs_root *root, struct btrfs_inode *inode,
 			   int inode_only,
 			   const loff_t start,
 			   const loff_t end,
@@ -4589,7 +4589,7 @@ static int btrfs_check_ref_name_override(struct extent_buffer *eb,
  * This handles both files and directories.
  */
 static int btrfs_log_inode(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root, struct inode *inode,
+			   struct btrfs_root *root, struct btrfs_inode *inode,
 			   int inode_only,
 			   const loff_t start,
 			   const loff_t end,
@@ -4610,8 +4610,8 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 	int ins_start_slot = 0;
 	int ins_nr;
 	bool fast_search = false;
-	u64 ino = btrfs_ino(BTRFS_I(inode));
-	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
+	u64 ino = btrfs_ino(inode);
+	struct extent_map_tree *em_tree = &inode->extent_tree;
 	u64 logged_isize = 0;
 	bool need_log_inode_item = true;
 
@@ -4632,10 +4632,10 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 
 
 	/* today the code can only do partial logging of directories */
-	if (S_ISDIR(inode->i_mode) ||
+	if (S_ISDIR(inode->vfs_inode.i_mode) ||
 	    (!test_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
-		       &BTRFS_I(inode)->runtime_flags) &&
-	     inode_only >= LOG_INODE_EXISTS))
+		       &inode->runtime_flags) &&
+	     inode_only == LOG_INODE_EXISTS))
 		max_key.type = BTRFS_XATTR_ITEM_KEY;
 	else
 		max_key.type = (u8)-1;
@@ -4647,11 +4647,11 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 	 * order for the log replay code to mark inodes for link count
 	 * fixup (create temporary BTRFS_TREE_LOG_FIXUP_OBJECTID items).
 	 */
-	if (S_ISDIR(inode->i_mode) ||
-	    BTRFS_I(inode)->generation > fs_info->last_trans_committed)
-		ret = btrfs_commit_inode_delayed_items(trans, BTRFS_I(inode));
+	if (S_ISDIR(inode->vfs_inode.i_mode) ||
+	    inode->generation > fs_info->last_trans_committed)
+		ret = btrfs_commit_inode_delayed_items(trans, inode);
 	else
-		ret = btrfs_commit_inode_delayed_inode(BTRFS_I(inode));
+		ret = btrfs_commit_inode_delayed_inode(inode);
 
 	if (ret) {
 		btrfs_free_path(path);
@@ -4661,17 +4661,16 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 
 	if (inode_only == LOG_OTHER_INODE) {
 		inode_only = LOG_INODE_EXISTS;
-		mutex_lock_nested(&BTRFS_I(inode)->log_mutex,
-				  SINGLE_DEPTH_NESTING);
+		mutex_lock_nested(&inode->log_mutex, SINGLE_DEPTH_NESTING);
 	} else {
-		mutex_lock(&BTRFS_I(inode)->log_mutex);
+		mutex_lock(&inode->log_mutex);
 	}
 
 	/*
 	 * a brute force approach to making sure we get the most uptodate
 	 * copies of everything.
 	 */
-	if (S_ISDIR(inode->i_mode)) {
+	if (S_ISDIR(inode->vfs_inode.i_mode)) {
 		int max_key_type = BTRFS_DIR_LOG_INDEX_KEY;
 
 		if (inode_only == LOG_INODE_EXISTS)
@@ -4692,31 +4691,30 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 			 * (zeroes), as if an expanding truncate happened,
 			 * instead of getting a file of 4Kb only.
 			 */
-			err = logged_inode_size(log, BTRFS_I(inode), path,
-						&logged_isize);
+			err = logged_inode_size(log, inode, path, &logged_isize);
 			if (err)
 				goto out_unlock;
 		}
 		if (test_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
-			     &BTRFS_I(inode)->runtime_flags)) {
+			     &inode->runtime_flags)) {
 			if (inode_only == LOG_INODE_EXISTS) {
 				max_key.type = BTRFS_XATTR_ITEM_KEY;
 				ret = drop_objectid_items(trans, log, path, ino,
 							  max_key.type);
 			} else {
 				clear_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
-					  &BTRFS_I(inode)->runtime_flags);
+					  &inode->runtime_flags);
 				clear_bit(BTRFS_INODE_COPY_EVERYTHING,
-					  &BTRFS_I(inode)->runtime_flags);
+					  &inode->runtime_flags);
 				while(1) {
 					ret = btrfs_truncate_inode_items(trans,
-							 log, inode, 0, 0);
+							 log, &inode->vfs_inode, 0, 0);
 					if (ret != -EAGAIN)
 						break;
 				}
 			}
 		} else if (test_and_clear_bit(BTRFS_INODE_COPY_EVERYTHING,
-					      &BTRFS_I(inode)->runtime_flags) ||
+					      &inode->runtime_flags) ||
 			   inode_only == LOG_INODE_EXISTS) {
 			if (inode_only == LOG_INODE_ALL)
 				fast_search = true;
@@ -4757,13 +4755,12 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 
 		if ((min_key.type == BTRFS_INODE_REF_KEY ||
 		     min_key.type == BTRFS_INODE_EXTREF_KEY) &&
-		    BTRFS_I(inode)->generation == trans->transid) {
+		    inode->generation == trans->transid) {
 			u64 other_ino = 0;
 
 			ret = btrfs_check_ref_name_override(path->nodes[0],
-							    path->slots[0],
-							    &min_key, BTRFS_I(inode),
-							    &other_ino);
+							    path->slots[0], &min_key, inode, 
+								&other_ino);
 			if (ret < 0) {
 				err = ret;
 				goto out_unlock;
@@ -4778,7 +4775,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 					ins_nr = 1;
 					ins_start_slot = path->slots[0];
 				}
-				ret = copy_items(trans, BTRFS_I(inode), dst_path, path,
+				ret = copy_items(trans, inode, dst_path, path,
 						 &last_extent, ins_start_slot,
 						 ins_nr, inode_only,
 						 logged_isize);
@@ -4816,7 +4813,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 				 * update the log with the new name before we
 				 * unpin it.
 				 */
-				err = btrfs_log_inode(trans, root, other_inode,
+				err = btrfs_log_inode(trans, root, BTRFS_I(other_inode),
 						      LOG_OTHER_INODE,
 						      0, LLONG_MAX, ctx);
 				iput(other_inode);
@@ -4831,7 +4828,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 		if (min_key.type == BTRFS_XATTR_ITEM_KEY) {
 			if (ins_nr == 0)
 				goto next_slot;
-			ret = copy_items(trans, BTRFS_I(inode), dst_path, path,
+			ret = copy_items(trans, inode, dst_path, path,
 					 &last_extent, ins_start_slot,
 					 ins_nr, inode_only, logged_isize);
 			if (ret < 0) {
@@ -4856,7 +4853,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 			goto next_slot;
 		}
 
-		ret = copy_items(trans, BTRFS_I(inode), dst_path, path, &last_extent,
+		ret = copy_items(trans, inode, dst_path, path, &last_extent,
 				 ins_start_slot, ins_nr, inode_only,
 				 logged_isize);
 		if (ret < 0) {
@@ -4880,7 +4877,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 			goto again;
 		}
 		if (ins_nr) {
-			ret = copy_items(trans, BTRFS_I(inode), dst_path, path,
+			ret = copy_items(trans, inode, dst_path, path,
 					 &last_extent, ins_start_slot,
 					 ins_nr, inode_only, logged_isize);
 			if (ret < 0) {
@@ -4902,7 +4899,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 		}
 	}
 	if (ins_nr) {
-		ret = copy_items(trans, BTRFS_I(inode), dst_path, path, &last_extent,
+		ret = copy_items(trans, inode, dst_path, path, &last_extent,
 				 ins_start_slot, ins_nr, inode_only,
 				 logged_isize);
 		if (ret < 0) {
@@ -4915,13 +4912,13 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 
 	btrfs_release_path(path);
 	btrfs_release_path(dst_path);
-	err = btrfs_log_all_xattrs(trans, root, BTRFS_I(inode), path, dst_path);
+	err = btrfs_log_all_xattrs(trans, root, inode, path, dst_path);
 	if (err)
 		goto out_unlock;
 	if (max_key.type >= BTRFS_EXTENT_DATA_KEY && !fast_search) {
 		btrfs_release_path(path);
 		btrfs_release_path(dst_path);
-		err = btrfs_log_trailing_hole(trans, root, BTRFS_I(inode), path);
+		err = btrfs_log_trailing_hole(trans, root, inode, path);
 		if (err)
 			goto out_unlock;
 	}
@@ -4929,12 +4926,12 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 	btrfs_release_path(path);
 	btrfs_release_path(dst_path);
 	if (need_log_inode_item) {
-		err = log_inode_item(trans, log, dst_path, BTRFS_I(inode));
+		err = log_inode_item(trans, log, dst_path, inode);
 		if (err)
 			goto out_unlock;
 	}
 	if (fast_search) {
-		ret = btrfs_log_changed_extents(trans, root, BTRFS_I(inode), dst_path,
+		ret = btrfs_log_changed_extents(trans, root, inode, dst_path,
 						&logged_list, ctx, start, end);
 		if (ret) {
 			err = ret;
@@ -4972,8 +4969,8 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 		write_unlock(&em_tree->lock);
 	}
 
-	if (inode_only == LOG_INODE_ALL && S_ISDIR(inode->i_mode)) {
-		ret = log_directory_changes(trans, root, BTRFS_I(inode), path, dst_path,
+	if (inode_only == LOG_INODE_ALL && S_ISDIR(inode->vfs_inode.i_mode)) {
+		ret = log_directory_changes(trans, root, inode, path, dst_path,
 					    ctx);
 		if (ret) {
 			err = ret;
@@ -4981,16 +4978,16 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 		}
 	}
 
-	spin_lock(&BTRFS_I(inode)->lock);
-	BTRFS_I(inode)->logged_trans = trans->transid;
-	BTRFS_I(inode)->last_log_commit = BTRFS_I(inode)->last_sub_trans;
-	spin_unlock(&BTRFS_I(inode)->lock);
+	spin_lock(&inode->lock);
+	inode->logged_trans = trans->transid;
+	inode->last_log_commit = inode->last_sub_trans;
+	spin_unlock(&inode->lock);
 out_unlock:
 	if (unlikely(err))
 		btrfs_put_logged_extents(&logged_list);
 	else
 		btrfs_submit_logged_extents(&logged_list, log);
-	mutex_unlock(&BTRFS_I(inode)->log_mutex);
+	mutex_unlock(&inode->log_mutex);
 
 	btrfs_free_path(path);
 	btrfs_free_path(dst_path);
@@ -5238,7 +5235,7 @@ static int log_new_dir_dentries(struct btrfs_trans_handle *trans,
 			ctx->log_new_dentries = false;
 			if (type == BTRFS_FT_DIR || type == BTRFS_FT_SYMLINK)
 				log_mode = LOG_INODE_ALL;
-			ret = btrfs_log_inode(trans, root, di_inode,
+			ret = btrfs_log_inode(trans, root, BTRFS_I(di_inode),
 					      log_mode, 0, LLONG_MAX, ctx);
 			if (!ret &&
 			    btrfs_must_commit_transaction(trans, BTRFS_I(di_inode)))
@@ -5358,7 +5355,7 @@ static int btrfs_log_all_parents(struct btrfs_trans_handle *trans,
 
 			if (ctx)
 				ctx->log_new_dentries = false;
-			ret = btrfs_log_inode(trans, root, dir_inode,
+			ret = btrfs_log_inode(trans, root, BTRFS_I(dir_inode),
 					      LOG_INODE_ALL, 0, LLONG_MAX, ctx);
 			if (!ret &&
 			    btrfs_must_commit_transaction(trans, BTRFS_I(dir_inode)))
@@ -5438,7 +5435,8 @@ static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto end_no_trans;
 
-	ret = btrfs_log_inode(trans, root, inode, inode_only, start, end, ctx);
+	ret = btrfs_log_inode(trans, root, BTRFS_I(inode), inode_only,
+			start, end, ctx);
 	if (ret)
 		goto end_trans;
 
@@ -5514,7 +5512,7 @@ static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 			break;
 
 		if (BTRFS_I(inode)->generation > last_committed) {
-			ret = btrfs_log_inode(trans, root, inode,
+			ret = btrfs_log_inode(trans, root, BTRFS_I(inode),
 					      LOG_INODE_EXISTS,
 					      0, LLONG_MAX, ctx);
 			if (ret)
-- 
2.7.4

