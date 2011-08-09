From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs: forced readonly when btrfs_drop_snapshot() fails
Date: Tue, 09 Aug 2011 16:11:13 +0900
Message-ID: <201108090711.AA00032@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The filesystem turns readonly instead of returning the error to the
caller when detected error in btrfs_drop_snapshot().
and, because the caller doesn't check the error, the function type is
changed to 'void'.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/ctree.h       |    4 ++--
 fs/btrfs/extent-tree.c |   22 ++++++++++++++--------
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index a6263bd..8842936 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2367,8 +2367,8 @@ static inline int btrfs_insert_empty_item(struct btrfs_trans_handle *trans,
 int btrfs_next_leaf(struct btrfs_root *root, struct btrfs_path *path);
 int btrfs_prev_leaf(struct btrfs_root *root, struct btrfs_path *path);
 int btrfs_leaf_free_space(struct btrfs_root *root, struct extent_buffer *leaf);
-int btrfs_drop_snapshot(struct btrfs_root *root,
-			struct btrfs_block_rsv *block_rsv, int update_ref);
+void btrfs_drop_snapshot(struct btrfs_root *root,
+			 struct btrfs_block_rsv *block_rsv, int update_ref);
 int btrfs_drop_subtree(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root,
 			struct extent_buffer *node,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 66bac22..7f2aec6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6269,8 +6269,8 @@ static noinline int walk_up_tree(struct btrfs_trans_handle *trans,
  * also make sure backrefs for the shared block and all lower level
  * blocks are properly updated.
  */
-int btrfs_drop_snapshot(struct btrfs_root *root,
-			struct btrfs_block_rsv *block_rsv, int update_ref)
+void btrfs_drop_snapshot(struct btrfs_root *root,
+			 struct btrfs_block_rsv *block_rsv, int update_ref)
 {
 	struct btrfs_path *path;
 	struct btrfs_trans_handle *trans;
@@ -6283,13 +6283,16 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 	int level;
 
 	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
+	if (!path) {
+		err = -ENOMEM;
+		goto out;
+	}
 
 	wc = kzalloc(sizeof(*wc), GFP_NOFS);
 	if (!wc) {
 		btrfs_free_path(path);
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto out;
 	}
 
 	trans = btrfs_start_transaction(tree_root, 0);
@@ -6318,7 +6321,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 		path->lowest_level = 0;
 		if (ret < 0) {
 			err = ret;
-			goto out;
+			goto out_free;
 		}
 		WARN_ON(ret > 0);
 
@@ -6425,11 +6428,14 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 		free_extent_buffer(root->commit_root);
 		kfree(root);
 	}
-out:
+out_free:
 	btrfs_end_transaction_throttle(trans, tree_root);
 	kfree(wc);
 	btrfs_free_path(path);
-	return err;
+out:
+	if (err)
+		btrfs_std_error(root->fs_info, err);
+	return;
 }
 
 /*


