From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH V2 04/12] Btrfs: Kill init_btrfs_i()
Date: Mon, 26 Apr 2010 18:44:45 +0800
Message-ID: <4BD56E9D.3010704@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

All code in init_btrfs_i can be moved into btrfs_alloc_inode()


Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 2/fs/btrfs/inode.c 3/fs/btrfs/inode.c
--- 2/fs/btrfs/inode.c	2010-04-26 17:24:41.254078880 +0800
+++ 3/fs/btrfs/inode.c	2010-04-26 17:24:41.270103836 +0800
@@ -3595,40 +3595,10 @@ again:
 	return 0;
 }
 
-static noinline void init_btrfs_i(struct inode *inode)
-{
-	struct btrfs_inode *bi = BTRFS_I(inode);
-
-	bi->generation = 0;
-	bi->sequence = 0;
-	bi->last_trans = 0;
-	bi->last_sub_trans = 0;
-	bi->logged_trans = 0;
-	bi->delalloc_bytes = 0;
-	bi->reserved_bytes = 0;
-	bi->disk_i_size = 0;
-	bi->flags = 0;
-	bi->index_cnt = (u64)-1;
-	bi->last_unlink_trans = 0;
-	bi->ordered_data_close = 0;
-	bi->force_compress = 0;
-	extent_map_tree_init(&BTRFS_I(inode)->extent_tree, GFP_NOFS);
-	extent_io_tree_init(&BTRFS_I(inode)->io_tree,
-			     inode->i_mapping, GFP_NOFS);
-	extent_io_tree_init(&BTRFS_I(inode)->io_failure_tree,
-			     inode->i_mapping, GFP_NOFS);
-	INIT_LIST_HEAD(&BTRFS_I(inode)->delalloc_inodes);
-	INIT_LIST_HEAD(&BTRFS_I(inode)->ordered_operations);
-	RB_CLEAR_NODE(&BTRFS_I(inode)->rb_node);
-	btrfs_ordered_inode_tree_init(&BTRFS_I(inode)->ordered_tree);
-	mutex_init(&BTRFS_I(inode)->log_mutex);
-}
-
 static int btrfs_init_locked_inode(struct inode *inode, void *p)
 {
 	struct btrfs_iget_args *args = p;
 	inode->i_ino = args->ino;
-	init_btrfs_i(inode);
 	BTRFS_I(inode)->root = args->root;
 	btrfs_set_inode_space_info(args->root, inode);
 	return 0;
@@ -3691,8 +3661,6 @@ static struct inode *new_simple_dir(stru
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 
-	init_btrfs_i(inode);
-
 	BTRFS_I(inode)->root = root;
 	memcpy(&BTRFS_I(inode)->location, key, sizeof(*key));
 	BTRFS_I(inode)->dummy_inode = 1;
@@ -4091,7 +4059,6 @@ static struct inode *btrfs_new_inode(str
 	 * btrfs_get_inode_index_count has an explanation for the magic
 	 * number
 	 */
-	init_btrfs_i(inode);
 	BTRFS_I(inode)->index_cnt = 2;
 	BTRFS_I(inode)->root = root;
 	BTRFS_I(inode)->generation = trans->transid;
@@ -5262,21 +5229,46 @@ unsigned long btrfs_force_ra(struct addr
 struct inode *btrfs_alloc_inode(struct super_block *sb)
 {
 	struct btrfs_inode *ei;
+	struct inode *inode;
 
 	ei = kmem_cache_alloc(btrfs_inode_cachep, GFP_NOFS);
 	if (!ei)
 		return NULL;
+
+	ei->root = NULL;
+	ei->space_info = NULL;
+	ei->generation = 0;
+	ei->sequence = 0;
 	ei->last_trans = 0;
 	ei->last_sub_trans = 0;
 	ei->logged_trans = 0;
+	ei->delalloc_bytes = 0;
+	ei->reserved_bytes = 0;
+	ei->disk_i_size = 0;
+	ei->flags = 0;
+	ei->index_cnt = (u64)-1;
+	ei->last_unlink_trans = 0;
+
+	spin_lock_init(&ei->accounting_lock);
 	ei->outstanding_extents = 0;
 	ei->reserved_extents = 0;
-	ei->root = NULL;
-	spin_lock_init(&ei->accounting_lock);
+
+	ei->ordered_data_close = 0;
+	ei->dummy_inode = 0;
+	ei->force_compress = 0;
+
+	inode = &ei->vfs_inode;
+	extent_map_tree_init(&ei->extent_tree, GFP_NOFS);
+	extent_io_tree_init(&ei->io_tree, &inode->i_data, GFP_NOFS);
+	extent_io_tree_init(&ei->io_failure_tree, &inode->i_data, GFP_NOFS);
+	mutex_init(&ei->log_mutex);
 	btrfs_ordered_inode_tree_init(&ei->ordered_tree);
 	INIT_LIST_HEAD(&ei->i_orphan);
+	INIT_LIST_HEAD(&ei->delalloc_inodes);
 	INIT_LIST_HEAD(&ei->ordered_operations);
-	return &ei->vfs_inode;
+	RB_CLEAR_NODE(&ei->rb_node);
+
+	return inode;
 }
 
 void btrfs_destroy_inode(struct inode *inode)
