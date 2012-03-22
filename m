From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 18/35] btrfs: btrfs_drop_snapshot should return int
Date: Wed, 21 Mar 2012 21:11:22 -0400
Message-ID: <20120322011135.521534164@suse.com>
References: <20120322011104.212214639@suse.com>
Cc: David Sterba <dsterba@suse.com>
To: Linux Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Commit cb1b69f4 (Btrfs: forced readonly when btrfs_drop_snapshot() fails)
made btrfs_drop_snapshot return void because there were no callers checking
the return value. That is the wrong order to handle error propogation since
the caller will have no idea that an error has occured and continue on
as if nothing went wrong.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h       |    6 +++---
 fs/btrfs/extent-tree.c |    4 ++--
 fs/btrfs/relocation.c  |    3 ++-
 fs/btrfs/transaction.c |    7 +++++--
 4 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 30c5a24..f6bca05 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2661,9 +2661,9 @@ static inline int btrfs_next_item(struct btrfs_root *root, struct btrfs_path *p)
 }
 int btrfs_prev_leaf(struct btrfs_root *root, struct btrfs_path *path);
 int btrfs_leaf_free_space(struct btrfs_root *root, struct extent_buffer *leaf);
-void btrfs_drop_snapshot(struct btrfs_root *root,
-			 struct btrfs_block_rsv *block_rsv, int update_ref,
-			 int for_reloc);
+int __must_check btrfs_drop_snapshot(struct btrfs_root *root,
+				     struct btrfs_block_rsv *block_rsv,
+				     int update_ref, int for_reloc);
 int btrfs_drop_subtree(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root,
 			struct extent_buffer *node,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0daa1df..cd6f8ae 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6734,7 +6734,7 @@ static noinline int walk_up_tree(struct btrfs_trans_handle *trans,
  * also make sure backrefs for the shared block and all lower level
  * blocks are properly updated.
  */
-void btrfs_drop_snapshot(struct btrfs_root *root,
+int btrfs_drop_snapshot(struct btrfs_root *root,
 			 struct btrfs_block_rsv *block_rsv, int update_ref,
 			 int for_reloc)
 {
@@ -6902,7 +6902,7 @@ out_free:
 out:
 	if (err)
 		btrfs_std_error(root->fs_info, err);
-	return;
+	return err;
 }
 
 /*
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 5e89a5e..a87678e 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2272,7 +2272,8 @@ again:
 		} else {
 			list_del_init(&reloc_root->root_list);
 		}
-		btrfs_drop_snapshot(reloc_root, rc->block_rsv, 0, 1);
+		ret = btrfs_drop_snapshot(reloc_root, rc->block_rsv, 0, 1);
+		BUG_ON(ret < 0);
 	}
 
 	if (found) {
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 6e256d9..fb5cd5a 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1387,6 +1387,8 @@ int btrfs_clean_old_snapshots(struct btrfs_root *root)
 	spin_unlock(&fs_info->trans_lock);
 
 	while (!list_empty(&list)) {
+		int ret;
+
 		root = list_entry(list.next, struct btrfs_root, root_list);
 		list_del(&root->root_list);
 
@@ -1394,9 +1396,10 @@ int btrfs_clean_old_snapshots(struct btrfs_root *root)
 
 		if (btrfs_header_backref_rev(root->node) <
 		    BTRFS_MIXED_BACKREF_REV)
-			btrfs_drop_snapshot(root, NULL, 0, 0);
+			ret = btrfs_drop_snapshot(root, NULL, 0, 0);
 		else
-			btrfs_drop_snapshot(root, NULL, 1, 0);
+			ret =btrfs_drop_snapshot(root, NULL, 1, 0);
+		BUG_ON(ret < 0);
 	}
 	return 0;
 }
-- 
1.7.9



