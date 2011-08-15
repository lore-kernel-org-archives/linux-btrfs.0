From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch v2 9/9] btrfs: Push up non-looped btrfs_start_transaction failures
Date: Mon, 15 Aug 2011 15:50:51 -0400
Message-ID: <20110815195233.207781853@suse.com>
References: <20110815195042.559654068@suse.com>
To: Btrfs Development List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 This patch handles btrfs_start_transaction failures that don't occur
 in a loop and are obvious to simply push up. In all cases except the
 mark_garbage_root case, the error is already handled by BUG_ON in the
 caller.

 Update v2: This version also checks the returns from btrfs_drop_snapshot.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c |    6 +++++-
 fs/btrfs/relocation.c  |    9 ++++++---
 fs/btrfs/transaction.c |    6 ++++--
 fs/btrfs/tree-log.c    |    5 ++++-
 fs/btrfs/volumes.c     |    3 ++-
 5 files changed, 21 insertions(+), 8 deletions(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6319,7 +6319,11 @@ int btrfs_drop_snapshot(struct btrfs_roo
 	}
 
 	trans = btrfs_start_transaction(tree_root, 0);
-	BUG_ON(IS_ERR(trans));
+	if (IS_ERR(trans)) {
+		kfree(wc);
+		btrfs_free_path(path);
+		return PTR_ERR(trans);
+	}
 
 	if (block_rsv)
 		trans->block_rsv = block_rsv;
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2251,7 +2251,8 @@ again:
 		} else {
 			list_del_init(&reloc_root->root_list);
 		}
-		btrfs_drop_snapshot(reloc_root, rc->block_rsv, 0);
+		ret = btrfs_drop_snapshot(reloc_root, rc->block_rsv, 0);
+		BUG_ON(ret < 0);
 	}
 
 	if (found) {
@@ -4096,7 +4097,8 @@ static noinline_for_stack int mark_garba
 	int ret;
 
 	trans = btrfs_start_transaction(root->fs_info->tree_root, 0);
-	BUG_ON(IS_ERR(trans));
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 
 	memset(&root->root_item.drop_progress, 0,
 		sizeof(root->root_item.drop_progress));
@@ -4176,7 +4178,8 @@ int btrfs_recover_relocation(struct btrf
 					err = ret;
 					goto out;
 				}
-				mark_garbage_root(reloc_root);
+				ret = mark_garbage_root(reloc_root);
+				BUG_ON(ret < 0);
 			}
 		}
 
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1400,6 +1400,7 @@ int btrfs_commit_transaction(struct btrf
  */
 int btrfs_clean_old_snapshots(struct btrfs_root *root)
 {
+	int ret;
 	LIST_HEAD(list);
 	struct btrfs_fs_info *fs_info = root->fs_info;
 
@@ -1415,9 +1416,10 @@ int btrfs_clean_old_snapshots(struct btr
 
 		if (btrfs_header_backref_rev(root->node) <
 		    BTRFS_MIXED_BACKREF_REV)
-			btrfs_drop_snapshot(root, NULL, 0);
+			ret = btrfs_drop_snapshot(root, NULL, 0);
 		else
-			btrfs_drop_snapshot(root, NULL, 1);
+			ret = btrfs_drop_snapshot(root, NULL, 1);
+		BUG_ON(ret < 0);
 	}
 	return 0;
 }
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3151,7 +3151,10 @@ int btrfs_recover_log_trees(struct btrfs
 	fs_info->log_root_recovering = 1;
 
 	trans = btrfs_start_transaction(fs_info->tree_root, 0);
-	BUG_ON(IS_ERR(trans));
+	if (IS_ERR(trans)) {
+		btrfs_free_path(path);
+		return PTR_ERR(trans);
+	}
 
 	wc.trans = trans;
 	wc.pin = 1;
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1876,7 +1876,8 @@ static int btrfs_relocate_chunk(struct b
 		return ret;
 
 	trans = btrfs_start_transaction(root, 0);
-	BUG_ON(IS_ERR(trans));
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 
 	lock_chunks(root);
 


