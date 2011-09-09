From: jeffm@suse.com
Subject: [patch v3 18/23] btrfs: disk-io.c: Make functions with no error conditions return void
Date: Thu, 08 Sep 2011 20:22:58 -0400
Message-ID: <20110909002733.211361706@suse.com>
References: <20110909002240.141223014@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: btrfs list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 btrfs_destroy_delalloc_inodes and __setup_root have no error conditions and
 should return void.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/disk-io.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -54,7 +54,7 @@ static int btrfs_destroy_ordered_extents
 static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 				      struct btrfs_root *root);
 static int btrfs_destroy_pending_snapshots(struct btrfs_transaction *t);
-static int btrfs_destroy_delalloc_inodes(struct btrfs_root *root);
+static void btrfs_destroy_delalloc_inodes(struct btrfs_root *root);
 static int btrfs_destroy_marked_extents(struct btrfs_root *root,
 					struct extent_io_tree *dirty_pages,
 					int mark);
@@ -1058,10 +1058,9 @@ int clean_tree_block(struct btrfs_trans_
 	return 0;
 }
 
-static int __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
-			u32 stripesize, struct btrfs_root *root,
-			struct btrfs_fs_info *fs_info,
-			u64 objectid)
+static void __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
+			 u32 stripesize, struct btrfs_root *root,
+			 struct btrfs_fs_info *fs_info, u64 objectid)
 {
 	root->node = NULL;
 	root->commit_root = NULL;
@@ -1114,7 +1113,6 @@ static int __setup_root(u32 nodesize, u3
 	root->defrag_running = 0;
 	root->root_key.objectid = objectid;
 	root->anon_dev = 0;
-	return 0;
 }
 
 static int find_and_setup_root(struct btrfs_root *tree_root,
@@ -2939,7 +2937,7 @@ static int btrfs_destroy_pending_snapsho
 	return 0;
 }
 
-static int btrfs_destroy_delalloc_inodes(struct btrfs_root *root)
+static void btrfs_destroy_delalloc_inodes(struct btrfs_root *root)
 {
 	struct btrfs_inode *btrfs_inode;
 	struct list_head splice;
@@ -2959,8 +2957,6 @@ static int btrfs_destroy_delalloc_inodes
 	}
 
 	spin_unlock(&root->fs_info->delalloc_lock);
-
-	return 0;
 }
 
 static int btrfs_destroy_marked_extents(struct btrfs_root *root,


