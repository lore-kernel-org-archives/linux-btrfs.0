From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 33/99] btrfs: btrfs_start_transaction non-looped error push-up
Date: Wed, 23 Nov 2011 19:36:06 -0500
Message-ID: <20111124004223.639372444@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
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
@@ -6374,7 +6374,11 @@ int btrfs_drop_snapshot(struct btrfs_roo
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
@@ -4118,7 +4118,8 @@ static noinline_for_stack int mark_garba
 	int ret;
 
 	trans = btrfs_start_transaction(root->fs_info->tree_root, 0);
-	BUG_ON(IS_ERR(trans));
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 
 	memset(&root->root_item.drop_progress, 0,
 		sizeof(root->root_item.drop_progress));
@@ -4198,7 +4199,8 @@ int btrfs_recover_relocation(struct btrf
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
@@ -3171,7 +3171,10 @@ int btrfs_recover_log_trees(struct btrfs
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
@@ -1932,7 +1932,8 @@ static int btrfs_relocate_chunk(struct b
 		return ret;
 
 	trans = btrfs_start_transaction(root, 0);
-	BUG_ON(IS_ERR(trans));
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 
 	lock_chunks(root);
 



