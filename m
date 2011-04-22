From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 08/12] btrfs: drop unused parameter from extent_map_tree_init
Date: Fri, 22 Apr 2011 11:42:42 +0200
Message-ID: <51c3b6e36524bbf6ad863ac3268a95e5f846d85d.1303398927.git.dsterba@suse.cz>
References: <cover.1303398927.git.dsterba@suse.cz>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1303398927.git.dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

the GFP flags are not stored anywhere and all allocations are done via
alloc_extent_map(GFP_NOFS).

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/disk-io.c    |    3 +--
 fs/btrfs/extent_map.c |    3 +--
 fs/btrfs/extent_map.h |    2 +-
 fs/btrfs/inode.c      |    2 +-
 fs/btrfs/volumes.c    |    2 +-
 5 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 598deb3..59c5bee 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1713,8 +1713,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	RB_CLEAR_NODE(&BTRFS_I(fs_info->btree_inode)->rb_node);
 	extent_io_tree_init(&BTRFS_I(fs_info->btree_inode)->io_tree,
 			     fs_info->btree_inode->i_mapping);
-	extent_map_tree_init(&BTRFS_I(fs_info->btree_inode)->extent_tree,
-			     GFP_NOFS);
+	extent_map_tree_init(&BTRFS_I(fs_info->btree_inode)->extent_tree);
 
 	BTRFS_I(fs_info->btree_inode)->io_tree.ops = &btree_extent_io_ops;
 
diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index a24a3f2..3c8f374 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -28,12 +28,11 @@ void extent_map_exit(void)
 /**
  * extent_map_tree_init - initialize extent map tree
  * @tree:		tree to initialize
- * @mask:		flags for memory allocations during tree operations
  *
  * Initialize the extent tree @tree.  Should be called for each new inode
  * or other user of the extent_map interface.
  */
-void extent_map_tree_init(struct extent_map_tree *tree, gfp_t mask)
+void extent_map_tree_init(struct extent_map_tree *tree)
 {
 	tree->map = RB_ROOT;
 	rwlock_init(&tree->lock);
diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index 28b44db..255813c 100644
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -49,7 +49,7 @@ static inline u64 extent_map_block_end(struct extent_map *em)
 	return em->block_start + em->block_len;
 }
 
-void extent_map_tree_init(struct extent_map_tree *tree, gfp_t mask);
+void extent_map_tree_init(struct extent_map_tree *tree);
 struct extent_map *lookup_extent_mapping(struct extent_map_tree *tree,
 					 u64 start, u64 len);
 int add_extent_mapping(struct extent_map_tree *tree,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 137f3ca..4ef41fe 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6780,7 +6780,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	ei->force_compress = BTRFS_COMPRESS_NONE;
 
 	inode = &ei->vfs_inode;
-	extent_map_tree_init(&ei->extent_tree, GFP_NOFS);
+	extent_map_tree_init(&ei->extent_tree);
 	extent_io_tree_init(&ei->io_tree, &inode->i_data);
 	extent_io_tree_init(&ei->io_failure_tree, &inode->i_data);
 	mutex_init(&ei->log_mutex);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 309a57b..64b30d3 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2839,7 +2839,7 @@ int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset)
 
 void btrfs_mapping_init(struct btrfs_mapping_tree *tree)
 {
-	extent_map_tree_init(&tree->map_tree, GFP_NOFS);
+	extent_map_tree_init(&tree->map_tree);
 }
 
 void btrfs_mapping_tree_free(struct btrfs_mapping_tree *tree)
-- 
1.7.5.rc3

