From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 9/9] btrfs: Push up non-looped btrfs_start_transaction failures
Date: Wed, 10 Aug 2011 19:20:36 -0400
Message-ID: <20110810232123.600894199@suse.com>
References: <20110810232027.129702612@suse.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 This patch handles btrfs_start_transaction failures that don't occur
 in a loop and are obvious to simply push up. In all cases except the
 mark_garbage_root case, the error is already handled by BUG_ON in the
 caller.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c |    6 +++++-
 fs/btrfs/relocation.c  |    6 ++++--
 fs/btrfs/tree-log.c    |    5 ++++-
 fs/btrfs/volumes.c     |    3 ++-
 4 files changed, 15 insertions(+), 5 deletions(-)

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
@@ -4096,7 +4096,8 @@ static noinline_for_stack int mark_garba
 	int ret;
 
 	trans = btrfs_start_transaction(root->fs_info->tree_root, 0);
-	BUG_ON(IS_ERR(trans));
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 
 	memset(&root->root_item.drop_progress, 0,
 		sizeof(root->root_item.drop_progress));
@@ -4176,7 +4177,8 @@ int btrfs_recover_relocation(struct btrf
 					err = ret;
 					goto out;
 				}
-				mark_garbage_root(reloc_root);
+				ret = mark_garbage_root(reloc_root);
+				BUG_ON(ret);
 			}
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
 


