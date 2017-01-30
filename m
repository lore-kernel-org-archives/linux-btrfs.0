Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32692 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754240AbdA3U0U (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jan 2017 15:26:20 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] Btrfs: kill trans in run_delalloc_nocow and btrfs_cross_ref_exist
Date: Mon, 30 Jan 2017 12:25:28 -0800
Message-Id: <1485807928-17351-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

run_delalloc_nocow has used trans in two places where they don't actually need
@trans.

For btrfs_lookup_file_extent, we search for file extents without COWing
anything, and for btrfs_cross_ref_exist, the only place where we need @trans is
deferencing it in order to get running_transaction which we could easily get
from the global fs_info.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.h       |  3 +--
 fs/btrfs/extent-tree.c | 22 ++++++++++++----------
 fs/btrfs/inode.c       | 38 +++-----------------------------------
 3 files changed, 16 insertions(+), 47 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 6a82371..73b2d51 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2577,8 +2577,7 @@ int btrfs_pin_extent_for_log_replay(struct btrfs_fs_info *fs_info,
 				    u64 bytenr, u64 num_bytes);
 int btrfs_exclude_logged_extents(struct btrfs_fs_info *fs_info,
 				 struct extent_buffer *eb);
-int btrfs_cross_ref_exist(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root,
+int btrfs_cross_ref_exist(struct btrfs_root *root,
 			  u64 objectid, u64 offset, u64 bytenr);
 struct btrfs_block_group_cache *btrfs_lookup_block_group(
 						 struct btrfs_fs_info *info,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ed254b8..097fa4a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3025,8 +3025,7 @@ int btrfs_set_disk_extent_flags(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static noinline int check_delayed_ref(struct btrfs_trans_handle *trans,
-				      struct btrfs_root *root,
+static noinline int check_delayed_ref(struct btrfs_root *root,
 				      struct btrfs_path *path,
 				      u64 objectid, u64 offset, u64 bytenr)
 {
@@ -3034,9 +3033,14 @@ static noinline int check_delayed_ref(struct btrfs_trans_handle *trans,
 	struct btrfs_delayed_ref_node *ref;
 	struct btrfs_delayed_data_ref *data_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
+	struct btrfs_transaction *cur_trans;
 	int ret = 0;
 
-	delayed_refs = &trans->transaction->delayed_refs;
+	cur_trans = root->fs_info->running_transaction;
+	if (!cur_trans)
+		return 0;
+
+	delayed_refs = &cur_trans->delayed_refs;
 	spin_lock(&delayed_refs->lock);
 	head = btrfs_find_delayed_ref_head(delayed_refs, bytenr);
 	if (!head) {
@@ -3087,8 +3091,7 @@ static noinline int check_delayed_ref(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static noinline int check_committed_ref(struct btrfs_trans_handle *trans,
-					struct btrfs_root *root,
+static noinline int check_committed_ref(struct btrfs_root *root,
 					struct btrfs_path *path,
 					u64 objectid, u64 offset, u64 bytenr)
 {
@@ -3159,9 +3162,8 @@ static noinline int check_committed_ref(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-int btrfs_cross_ref_exist(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root,
-			  u64 objectid, u64 offset, u64 bytenr)
+int btrfs_cross_ref_exist(struct btrfs_root *root, u64 objectid, u64 offset,
+			  u64 bytenr)
 {
 	struct btrfs_path *path;
 	int ret;
@@ -3172,12 +3174,12 @@ int btrfs_cross_ref_exist(struct btrfs_trans_handle *trans,
 		return -ENOENT;
 
 	do {
-		ret = check_committed_ref(trans, root, path, objectid,
+		ret = check_committed_ref(root, path, objectid,
 					  offset, bytenr);
 		if (ret && ret != -ENOENT)
 			goto out;
 
-		ret2 = check_delayed_ref(trans, root, path, objectid,
+		ret2 = check_delayed_ref(root, path, objectid,
 					 offset, bytenr);
 	} while (ret2 == -EAGAIN);
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 082b968..3d3753a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1250,7 +1250,6 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct btrfs_trans_handle *trans;
 	struct extent_buffer *leaf;
 	struct btrfs_path *path;
 	struct btrfs_file_extent_item *fi;
@@ -1286,30 +1285,10 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 
 	nolock = btrfs_is_free_space_inode(inode);
 
-	if (nolock)
-		trans = btrfs_join_transaction_nolock(root);
-	else
-		trans = btrfs_join_transaction(root);
-
-	if (IS_ERR(trans)) {
-		extent_clear_unlock_delalloc(inode, start, end, end,
-					     locked_page,
-					     EXTENT_LOCKED | EXTENT_DELALLOC |
-					     EXTENT_DO_ACCOUNTING |
-					     EXTENT_DEFRAG, PAGE_UNLOCK |
-					     PAGE_CLEAR_DIRTY |
-					     PAGE_SET_WRITEBACK |
-					     PAGE_END_WRITEBACK);
-		btrfs_free_path(path);
-		return PTR_ERR(trans);
-	}
-
-	trans->block_rsv = &fs_info->delalloc_block_rsv;
-
 	cow_start = (u64)-1;
 	cur_offset = start;
 	while (1) {
-		ret = btrfs_lookup_file_extent(trans, root, path, ino,
+		ret = btrfs_lookup_file_extent(NULL, root, path, ino,
 					       cur_offset, 0);
 		if (ret < 0)
 			goto error;
@@ -1382,7 +1361,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 				goto out_check;
 			if (btrfs_extent_readonly(fs_info, disk_bytenr))
 				goto out_check;
-			if (btrfs_cross_ref_exist(trans, root, ino,
+			if (btrfs_cross_ref_exist(root, ino,
 						  found_key.offset -
 						  extent_offset, disk_bytenr))
 				goto out_check;
@@ -1534,10 +1513,6 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 	}
 
 error:
-	err = btrfs_end_transaction(trans);
-	if (!ret)
-		ret = err;
-
 	if (ret && cur_offset < end)
 		extent_clear_unlock_delalloc(inode, cur_offset, end, end,
 					     locked_page, EXTENT_LOCKED |
@@ -7275,7 +7250,6 @@ noinline int can_nocow_extent(struct inode *inode, u64 offset, u64 *len,
 			      u64 *ram_bytes)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-	struct btrfs_trans_handle *trans;
 	struct btrfs_path *path;
 	int ret;
 	struct extent_buffer *leaf;
@@ -7378,15 +7352,9 @@ noinline int can_nocow_extent(struct inode *inode, u64 offset, u64 *len,
 	 * look for other files referencing this extent, if we
 	 * find any we must cow
 	 */
-	trans = btrfs_join_transaction(root);
-	if (IS_ERR(trans)) {
-		ret = 0;
-		goto out;
-	}
 
-	ret = btrfs_cross_ref_exist(trans, root, btrfs_ino(inode),
+	ret = btrfs_cross_ref_exist(root, btrfs_ino(inode),
 				    key.offset - backref_offset, disk_bytenr);
-	btrfs_end_transaction(trans);
 	if (ret) {
 		ret = 0;
 		goto out;
-- 
2.5.5

