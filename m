From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 11/65] btrfs: btrfs_drop_snapshot should return int
Date: Mon, 03 Oct 2011 23:22:41 -0400
Message-ID: <20111004032301.184852976@suse.com>
References: <20111004032230.458853274@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: BtrFS List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Commit cb1b69f4 (Btrfs: forced readonly when btrfs_drop_snapshot() fails)
made btrfs_drop_snapshot return void because there were no callers checking
the return value. That is the wrong order to handle error propogation since
the caller will have no idea that an error has occured and continue on
as if nothing went wrong.

The next patch checks the btrfs_drop_snapshot return values, so re-add it
here.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h       |    4 ++--
 fs/btrfs/extent-tree.c |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2366,8 +2366,8 @@ static inline int btrfs_insert_empty_ite
 int btrfs_next_leaf(struct btrfs_root *root, struct btrfs_path *path);
 int btrfs_prev_leaf(struct btrfs_root *root, struct btrfs_path *path);
 int btrfs_leaf_free_space(struct btrfs_root *root, struct extent_buffer *leaf);
-void btrfs_drop_snapshot(struct btrfs_root *root,
-			 struct btrfs_block_rsv *block_rsv, int update_ref);
+int btrfs_drop_snapshot(struct btrfs_root *root,
+			struct btrfs_block_rsv *block_rsv, int update_ref);
 int btrfs_drop_subtree(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root,
 			struct extent_buffer *node,
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6303,8 +6303,8 @@ static noinline int walk_up_tree(struct
  * also make sure backrefs for the shared block and all lower level
  * blocks are properly updated.
  */
-void btrfs_drop_snapshot(struct btrfs_root *root,
-			 struct btrfs_block_rsv *block_rsv, int update_ref)
+int btrfs_drop_snapshot(struct btrfs_root *root,
+			struct btrfs_block_rsv *block_rsv, int update_ref)
 {
 	struct btrfs_path *path;
 	struct btrfs_trans_handle *trans;
@@ -6469,7 +6469,7 @@ out_free:
 out:
 	if (err)
 		btrfs_std_error(root->fs_info, err);
-	return;
+	return err;
 }
 
 /*



