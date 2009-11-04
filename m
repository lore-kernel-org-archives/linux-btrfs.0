From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 03/10] btrfs: fix btrfs_read_fs_root* return values
Date: Wed, 04 Nov 2009 14:03:49 -0500
Message-ID: <20091104190432.777456189@suse.com>
References: <20091104190346.971762946@suse.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 The btrfs_read_fs_root* functions return ERR_PTR values but the return
 is being checked for NULL instead.

 This patch fixes up the checks to use IS_ERR.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/disk-io.c     |    4 +++-
 fs/btrfs/extent-tree.c |    6 +++---
 fs/btrfs/tree-log.c    |    4 ++--
 3 files changed, 8 insertions(+), 6 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1987,8 +1987,10 @@ struct btrfs_root *open_ctree(struct sup
 	location.offset = (u64)-1;
 
 	fs_info->fs_root = btrfs_read_fs_root_no_name(fs_info, &location);
-	if (!fs_info->fs_root)
+	if (IS_ERR(fs_info->fs_root)) {
+		err = PTR_ERR(fs_info->fs_root);
 		goto fail_trans_kthread;
+	}
 
 	return tree_root;
 
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6712,7 +6712,7 @@ int btrfs_cleanup_reloc_trees(struct btr
 	location.type = BTRFS_ROOT_ITEM_KEY;
 
 	reloc_root = btrfs_read_fs_root_no_name(root->fs_info, &location);
-	BUG_ON(!reloc_root);
+	BUG_ON(IS_ERR(reloc_root));
 	btrfs_orphan_cleanup(reloc_root);
 	return 0;
 }
@@ -6757,7 +6757,7 @@ static noinline int init_reloc_tree(stru
 
 	reloc_root = btrfs_read_fs_root_no_radix(root->fs_info->tree_root,
 						 &root_key);
-	BUG_ON(!reloc_root);
+	BUG_ON(IS_ERR(reloc_root));
 	reloc_root->last_trans = trans->transid;
 	reloc_root->commit_root = NULL;
 	reloc_root->ref_tree = &root->fs_info->reloc_ref_tree;
@@ -6976,7 +6976,7 @@ static noinline int relocate_one_extent(
 			continue;
 
 		found_root = read_ref_root(extent_root->fs_info, ref_path);
-		BUG_ON(!found_root);
+		BUG_ON(IS_ERR(found_root));
 		/*
 		 * for reference counted tree, only process reference paths
 		 * rooted at the latest committed root.
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3042,7 +3042,7 @@ again:
 
 		log = btrfs_read_fs_root_no_radix(log_root_tree,
 						  &found_key);
-		BUG_ON(!log);
+		BUG_ON(IS_ERR(log));
 
 
 		tmp_key.objectid = found_key.offset;
@@ -3050,7 +3050,7 @@ again:
 		tmp_key.offset = (u64)-1;
 
 		wc.replay_dest = btrfs_read_fs_root_no_name(fs_info, &tmp_key);
-		BUG_ON(!wc.replay_dest);
+		BUG_ON(IS_ERR(wc.replay_dest));
 
 		wc.replay_dest->log_root = log;
 		btrfs_record_root_in_trans(trans, wc.replay_dest);

