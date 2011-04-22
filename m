From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 07/12] btrfs: drop unused argument from extent_io_tree_init
Date: Fri, 22 Apr 2011 11:42:13 +0200
Message-ID: <8bb203cde372f8a3eae5e9e7fceff9a49e67ebf4.1303398927.git.dsterba@suse.cz>
References: <cover.1303398927.git.dsterba@suse.cz>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1303398927.git.dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

all callers pass GFP_NOFS, but the GFP mask argument is not used in the
function; GFP_ATOMIC is passed to radix tree initialization and it's the
only correct one, since we're using the preload/insert mechanism of
radix tree.
Let's drop the gfp mask from btrfs function, this will not change
behaviour.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/disk-io.c     |    9 ++++-----
 fs/btrfs/extent_io.c   |    2 +-
 fs/btrfs/extent_io.h   |    2 +-
 fs/btrfs/inode.c       |    4 ++--
 fs/btrfs/relocation.c  |    2 +-
 fs/btrfs/transaction.c |    3 +--
 6 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 5e5d07c..598deb3 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1080,7 +1080,7 @@ static int __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 	root->log_transid = 0;
 	root->last_log_commit = 0;
 	extent_io_tree_init(&root->dirty_log_pages,
-			     fs_info->btree_inode->i_mapping, GFP_NOFS);
+			     fs_info->btree_inode->i_mapping);
 
 	memset(&root->root_key, 0, sizeof(root->root_key));
 	memset(&root->root_item, 0, sizeof(root->root_item));
@@ -1712,8 +1712,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 
 	RB_CLEAR_NODE(&BTRFS_I(fs_info->btree_inode)->rb_node);
 	extent_io_tree_init(&BTRFS_I(fs_info->btree_inode)->io_tree,
-			     fs_info->btree_inode->i_mapping,
-			     GFP_NOFS);
+			     fs_info->btree_inode->i_mapping);
 	extent_map_tree_init(&BTRFS_I(fs_info->btree_inode)->extent_tree,
 			     GFP_NOFS);
 
@@ -1729,9 +1728,9 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	fs_info->block_group_cache_tree = RB_ROOT;
 
 	extent_io_tree_init(&fs_info->freed_extents[0],
-			     fs_info->btree_inode->i_mapping, GFP_NOFS);
+			     fs_info->btree_inode->i_mapping);
 	extent_io_tree_init(&fs_info->freed_extents[1],
-			     fs_info->btree_inode->i_mapping, GFP_NOFS);
+			     fs_info->btree_inode->i_mapping);
 	fs_info->pinned_extents = &fs_info->freed_extents[0];
 	fs_info->do_barriers = 1;
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 29909b1..7a36b75 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -101,7 +101,7 @@ void extent_io_exit(void)
 }
 
 void extent_io_tree_init(struct extent_io_tree *tree,
-			  struct address_space *mapping, gfp_t mask)
+			 struct address_space *mapping)
 {
 	tree->state = RB_ROOT;
 	INIT_RADIX_TREE(&tree->buffer, GFP_ATOMIC);
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index b9ce2f7..e9cfe8d 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -169,7 +169,7 @@ typedef struct extent_map *(get_extent_t)(struct inode *inode,
 					  int create);
 
 void extent_io_tree_init(struct extent_io_tree *tree,
-			  struct address_space *mapping, gfp_t mask);
+			 struct address_space *mapping);
 int try_release_extent_mapping(struct extent_map_tree *map,
 			       struct extent_io_tree *tree, struct page *page,
 			       gfp_t mask);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f1dc7a8..137f3ca 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6781,8 +6781,8 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 
 	inode = &ei->vfs_inode;
 	extent_map_tree_init(&ei->extent_tree, GFP_NOFS);
-	extent_io_tree_init(&ei->io_tree, &inode->i_data, GFP_NOFS);
-	extent_io_tree_init(&ei->io_failure_tree, &inode->i_data, GFP_NOFS);
+	extent_io_tree_init(&ei->io_tree, &inode->i_data);
+	extent_io_tree_init(&ei->io_failure_tree, &inode->i_data);
 	mutex_init(&ei->log_mutex);
 	btrfs_ordered_inode_tree_init(&ei->ordered_tree);
 	INIT_LIST_HEAD(&ei->i_orphan);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index fed0aae..f3edf45 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3935,7 +3935,7 @@ static struct reloc_control *alloc_reloc_control(void)
 	INIT_LIST_HEAD(&rc->reloc_roots);
 	backref_cache_init(&rc->backref_cache);
 	mapping_tree_init(&rc->reloc_root_tree);
-	extent_io_tree_init(&rc->processed_blocks, NULL, GFP_NOFS);
+	extent_io_tree_init(&rc->processed_blocks, NULL);
 	return rc;
 }
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index c571734..955f76e 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -80,8 +80,7 @@ static noinline int join_transaction(struct btrfs_root *root)
 		INIT_LIST_HEAD(&cur_trans->pending_snapshots);
 		list_add_tail(&cur_trans->list, &root->fs_info->trans_list);
 		extent_io_tree_init(&cur_trans->dirty_pages,
-				     root->fs_info->btree_inode->i_mapping,
-				     GFP_NOFS);
+				     root->fs_info->btree_inode->i_mapping);
 		spin_lock(&root->fs_info->new_trans_lock);
 		root->fs_info->running_transaction = cur_trans;
 		spin_unlock(&root->fs_info->new_trans_lock);
-- 
1.7.5.rc3

