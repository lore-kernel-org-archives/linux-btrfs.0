From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH 6.1/6] improve the balancing code
Date: Tue, 12 May 2009 14:06:02 +0800
Message-ID: <4A0911CA.8020503@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch contains some random changes required by
the balancing code.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urpN 6/fs/btrfs/ctree.c 7/fs/btrfs/ctree.c
--- 6/fs/btrfs/ctree.c	2009-05-11 15:53:33.000000000 +0800
+++ 7/fs/btrfs/ctree.c	2009-05-11 16:02:34.000000000 +0800
@@ -594,7 +594,7 @@ static int comp_keys(struct btrfs_disk_k
 /*
  * same as comp_keys only with two btrfs_key's
  */
-static int comp_cpu_keys(struct btrfs_key *k1, struct btrfs_key *k2)
+int btrfs_comp_cpu_keys(struct btrfs_key *k1, struct btrfs_key *k2)
 {
 	if (k1->objectid > k2->objectid)
 		return 1;
@@ -970,6 +970,12 @@ static int bin_search(struct extent_buff
 	return -1;
 }
 
+int btrfs_bin_search(struct extent_buffer *eb, struct btrfs_key *key,
+		     int level, int *slot)
+{
+	return bin_search(eb, key, level, slot);
+}
+
 /* given a node and slot number, this reads the blocks it points to.  The
  * extent buffer is returned with a reference taken (but unlocked).
  * NULL is returned on error.
@@ -1709,10 +1715,17 @@ int btrfs_search_slot(struct btrfs_trans
 		lowest_unlock = 2;
 
 again:
-	if (p->skip_locking)
-		b = btrfs_root_node(root);
-	else
-		b = btrfs_lock_root_node(root);
+	if (p->search_commit_root) {
+		b = root->commit_root;
+		extent_buffer_get(b);
+		if (!p->skip_locking)
+			btrfs_tree_lock(b);
+	} else {
+		if (p->skip_locking)
+			b = btrfs_root_node(root);
+		else
+			b = btrfs_lock_root_node(root);
+	}
 
 	while (b) {
 		level = btrfs_header_level(b);
@@ -1852,138 +1865,6 @@ done:
 	return ret;
 }
 
-int btrfs_merge_path(struct btrfs_trans_handle *trans,
-		     struct btrfs_root *root,
-		     struct btrfs_key *node_keys,
-		     u64 *nodes, int lowest_level)
-{
-	struct extent_buffer *eb;
-	struct extent_buffer *parent;
-	struct btrfs_key key;
-	u64 bytenr;
-	u64 generation;
-	u32 blocksize;
-	int level;
-	int slot;
-	int key_match;
-	int ret;
-
-	eb = btrfs_lock_root_node(root);
-	ret = btrfs_cow_block(trans, root, eb, NULL, 0, &eb);
-	BUG_ON(ret);
-
-	btrfs_set_lock_blocking(eb);
-
-	parent = eb;
-	while (1) {
-		level = btrfs_header_level(parent);
-		if (level == 0 || level <= lowest_level)
-			break;
-
-		ret = bin_search(parent, &node_keys[lowest_level], level,
-				 &slot);
-		if (ret && slot > 0)
-			slot--;
-
-		bytenr = btrfs_node_blockptr(parent, slot);
-		if (nodes[level - 1] == bytenr)
-			break;
-
-		blocksize = btrfs_level_size(root, level - 1);
-		generation = btrfs_node_ptr_generation(parent, slot);
-		btrfs_node_key_to_cpu(eb, &key, slot);
-		key_match = !memcmp(&key, &node_keys[level - 1], sizeof(key));
-
-		if (generation == trans->transid) {
-			eb = read_tree_block(root, bytenr, blocksize,
-					     generation);
-			btrfs_tree_lock(eb);
-			btrfs_set_lock_blocking(eb);
-		}
-
-		/*
-		 * if node keys match and node pointer hasn't been modified
-		 * in the running transaction, we can merge the path. for
-		 * blocks owened by reloc trees, the node pointer check is
-		 * skipped, this is because these blocks are fully controlled
-		 * by the space balance code, no one else can modify them.
-		 */
-		if (!nodes[level - 1] || !key_match ||
-		    (generation == trans->transid &&
-		     btrfs_header_owner(eb) != BTRFS_TREE_RELOC_OBJECTID)) {
-			if (level == 1 || level == lowest_level + 1) {
-				if (generation == trans->transid) {
-					btrfs_tree_unlock(eb);
-					free_extent_buffer(eb);
-				}
-				break;
-			}
-
-			if (generation != trans->transid) {
-				eb = read_tree_block(root, bytenr, blocksize,
-						generation);
-				btrfs_tree_lock(eb);
-				btrfs_set_lock_blocking(eb);
-			}
-
-			ret = btrfs_cow_block(trans, root, eb, parent, slot,
-					      &eb);
-			BUG_ON(ret);
-
-			if (root->root_key.objectid ==
-			    BTRFS_TREE_RELOC_OBJECTID) {
-				if (!nodes[level - 1]) {
-					nodes[level - 1] = eb->start;
-					memcpy(&node_keys[level - 1], &key,
-					       sizeof(node_keys[0]));
-				} else {
-					WARN_ON(1);
-				}
-			}
-
-			btrfs_tree_unlock(parent);
-			free_extent_buffer(parent);
-			parent = eb;
-			continue;
-		}
-
-		btrfs_set_node_blockptr(parent, slot, nodes[level - 1]);
-		btrfs_set_node_ptr_generation(parent, slot, trans->transid);
-		btrfs_mark_buffer_dirty(parent);
-
-		ret = btrfs_inc_extent_ref(trans, root,
-					nodes[level - 1],
-					blocksize, parent->start,
-					btrfs_header_owner(parent),
-					btrfs_header_generation(parent),
-					level - 1);
-		BUG_ON(ret);
-
-		/*
-		 * If the block was created in the running transaction,
-		 * it's possible this is the last reference to it, so we
-		 * should drop the subtree.
-		 */
-		if (generation == trans->transid) {
-			ret = btrfs_drop_subtree(trans, root, eb, parent);
-			BUG_ON(ret);
-			btrfs_tree_unlock(eb);
-			free_extent_buffer(eb);
-		} else {
-			ret = btrfs_free_extent(trans, root, bytenr,
-					blocksize, parent->start,
-					btrfs_header_owner(parent),
-					btrfs_header_generation(parent),
-					level - 1, 1);
-			BUG_ON(ret);
-		}
-		break;
-	}
-	btrfs_tree_unlock(parent);
-	free_extent_buffer(parent);
-	return 0;
-}
-
 /*
  * adjust the pointers going up the tree, starting at level
  * making sure the right key of each node is points to 'key'.
diff -urpN 6/fs/btrfs/ctree.h 7/fs/btrfs/ctree.h
--- 6/fs/btrfs/ctree.h	2009-05-11 15:53:33.000000000 +0800
+++ 7/fs/btrfs/ctree.h	2009-05-11 16:27:32.000000000 +0800
@@ -267,7 +267,8 @@ static inline unsigned long btrfs_chunk_
 }
 
 #define BTRFS_FSID_SIZE 16
-#define BTRFS_HEADER_FLAG_WRITTEN (1 << 0)
+#define BTRFS_HEADER_FLAG_WRITTEN 	(1 << 0)
+#define BTRFS_HEADER_FLAG_RELOC		(1 << 1)
 
 /*
  * every tree block (leaf or node) starts with this header.
@@ -720,12 +721,7 @@ struct btrfs_block_group_cache {
 	struct list_head cluster_list;
 };
 
-struct btrfs_leaf_ref_tree {
-	struct rb_root root;
-	struct list_head list;
-	spinlock_t lock;
-};
-
+struct reloc_control;
 struct btrfs_device;
 struct btrfs_fs_devices;
 struct btrfs_fs_info {
@@ -856,11 +852,6 @@ struct btrfs_fs_info {
 	struct task_struct *cleaner_kthread;
 	int thread_pool_size;
 
-	/* tree relocation relocated fields */
-	struct list_head dead_reloc_roots;
-	struct btrfs_leaf_ref_tree reloc_ref_tree;
-	struct btrfs_leaf_ref_tree shared_ref_tree;
-
 	struct kobject super_kobj;
 	struct completion kobj_unregister;
 	int do_barriers;
@@ -886,6 +877,8 @@ struct btrfs_fs_info {
 	 */
 	struct list_head space_info;
 
+	struct reloc_control *reloc_ctl;
+
 	spinlock_t delalloc_lock;
 	spinlock_t new_trans_lock;
 	u64 delalloc_bytes;
@@ -923,9 +916,6 @@ struct btrfs_root {
 	spinlock_t node_lock;
 
 	struct extent_buffer *commit_root;
-	struct btrfs_leaf_ref_tree *ref_tree;
-	struct btrfs_leaf_ref_tree ref_tree_struct;
-	struct btrfs_dirty_root *dirty_root;
 	struct btrfs_root *log_root;
 	struct btrfs_root *reloc_root;
 
@@ -1907,16 +1897,9 @@ int btrfs_make_block_group(struct btrfs_
 			   u64 size);
 int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root, u64 group_start);
-int btrfs_relocate_block_group(struct btrfs_root *root, u64 group_start);
-int btrfs_free_reloc_root(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root);
-int btrfs_drop_dead_reloc_roots(struct btrfs_root *root);
-int btrfs_reloc_tree_cache_ref(struct btrfs_trans_handle *trans,
-			       struct btrfs_root *root,
-			       struct extent_buffer *buf, u64 orig_start);
-int btrfs_add_dead_reloc_root(struct btrfs_root *root);
-int btrfs_cleanup_reloc_trees(struct btrfs_root *root);
-int btrfs_reloc_clone_csums(struct inode *inode, u64 file_pos, u64 len);
+int btrfs_prepare_block_group_relocation(struct btrfs_root *root,
+				struct btrfs_block_group_cache *group);
+
 u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags);
 void btrfs_set_inode_space_info(struct btrfs_root *root, struct inode *ionde);
 void btrfs_clear_space_info_full(struct btrfs_fs_info *info);
@@ -1931,13 +1914,12 @@ void btrfs_delalloc_reserve_space(struct
 void btrfs_delalloc_free_space(struct btrfs_root *root, struct inode *inode,
 			      u64 bytes);
 /* ctree.c */
+int btrfs_bin_search(struct extent_buffer *eb, struct btrfs_key *key,
+		     int level, int *slot);
+int btrfs_comp_cpu_keys(struct btrfs_key *k1, struct btrfs_key *k2);
 int btrfs_previous_item(struct btrfs_root *root,
 			struct btrfs_path *path, u64 min_objectid,
 			int type);
-int btrfs_merge_path(struct btrfs_trans_handle *trans,
-		     struct btrfs_root *root,
-		     struct btrfs_key *node_keys,
-		     u64 *nodes, int lowest_level);
 int btrfs_set_item_key_safe(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root, struct btrfs_path *path,
 			    struct btrfs_key *new_key);
@@ -2244,4 +2226,12 @@ int btrfs_check_acl(struct inode *inode,
 int btrfs_init_acl(struct inode *inode, struct inode *dir);
 int btrfs_acl_chmod(struct inode *inode);
 
+/* relocation.c */
+int btrfs_relocate_block_group(struct btrfs_root *root, u64 group_start);
+int btrfs_init_reloc_root(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *root);
+int btrfs_update_reloc_root(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root);
+int btrfs_recover_relocation(struct btrfs_root *root);
+int btrfs_reloc_clone_csums(struct inode *inode, u64 file_pos, u64 len);
 #endif
diff -urpN 6/fs/btrfs/disk-io.c 7/fs/btrfs/disk-io.c
--- 6/fs/btrfs/disk-io.c	2009-05-11 15:59:02.000000000 +0800
+++ 7/fs/btrfs/disk-io.c	2009-05-11 16:49:50.000000000 +0800
@@ -36,7 +36,6 @@
 #include "print-tree.h"
 #include "async-thread.h"
 #include "locking.h"
-#include "ref-cache.h"
 #include "tree-log.h"
 #include "free-space-cache.h"
 
@@ -886,7 +885,6 @@ static int __setup_root(u32 nodesize, u3
 {
 	root->node = NULL;
 	root->commit_root = NULL;
-	root->ref_tree = NULL;
 	root->sectorsize = sectorsize;
 	root->nodesize = nodesize;
 	root->leafsize = leafsize;
@@ -922,9 +920,6 @@ static int __setup_root(u32 nodesize, u3
 	extent_io_tree_init(&root->dirty_log_pages,
 			     fs_info->btree_inode->i_mapping, GFP_NOFS);
 
-	btrfs_leaf_ref_tree_init(&root->ref_tree_struct);
-	root->ref_tree = &root->ref_tree_struct;
-
 	memset(&root->root_key, 0, sizeof(root->root_key));
 	memset(&root->root_item, 0, sizeof(root->root_item));
 	memset(&root->defrag_progress, 0, sizeof(root->defrag_progress));
@@ -1553,7 +1548,6 @@ struct btrfs_root *open_ctree(struct sup
 	INIT_LIST_HEAD(&fs_info->ordered_operations);
 	spin_lock_init(&fs_info->delalloc_lock);
 	spin_lock_init(&fs_info->new_trans_lock);
-	spin_lock_init(&fs_info->ref_cache_lock);
 
 	init_completion(&fs_info->kobj_unregister);
 	fs_info->tree_root = tree_root;
@@ -1614,10 +1608,6 @@ struct btrfs_root *open_ctree(struct sup
 			     fs_info->btree_inode->i_mapping, GFP_NOFS);
 	fs_info->do_barriers = 1;
 
-	INIT_LIST_HEAD(&fs_info->dead_reloc_roots);
-	btrfs_leaf_ref_tree_init(&fs_info->reloc_ref_tree);
-	btrfs_leaf_ref_tree_init(&fs_info->shared_ref_tree);
-
 	BTRFS_I(fs_info->btree_inode)->root = tree_root;
 	memset(&BTRFS_I(fs_info->btree_inode)->location, 0,
 	       sizeof(struct btrfs_key));
@@ -1885,7 +1875,7 @@ struct btrfs_root *open_ctree(struct sup
 	}
 
 	if (!(sb->s_flags & MS_RDONLY)) {
-		ret = btrfs_cleanup_reloc_trees(tree_root);
+		ret = btrfs_recover_relocation(tree_root);
 		BUG_ON(ret);
 	}
 
diff -urpN 6/fs/btrfs/extent-tree.c 7/fs/btrfs/extent-tree.c
--- 6/fs/btrfs/extent-tree.c	2009-05-11 15:53:33.000000000 +0800
+++ 7/fs/btrfs/extent-tree.c	2009-05-11 16:46:47.000000000 +0800
@@ -30,7 +30,6 @@
 #include "transaction.h"
 #include "volumes.h"
 #include "locking.h"
-#include "ref-cache.h"
 #include "free-space-cache.h"
 
 static int update_reserved_extents(struct btrfs_root *root,
@@ -5861,6 +5860,16 @@ static int __alloc_chunk_for_shrink(stru
 	return 0;
 }
 
+int btrfs_prepare_block_group_relocation(struct btrfs_root *root,
+					 struct btrfs_block_group_cache *group)
+
+{
+	__alloc_chunk_for_shrink(root, group, 1);
+	set_block_group_readonly(group);
+	return 0;
+}
+
+#if 0
 static int __insert_orphan_inode(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root,
 				 u64 objectid, u64 size)
diff -urpN 6/fs/btrfs/inode.c 7/fs/btrfs/inode.c
--- 6/fs/btrfs/inode.c	2009-05-11 15:59:02.000000000 +0800
+++ 7/fs/btrfs/inode.c	2009-05-11 16:50:56.000000000 +0800
@@ -48,7 +48,6 @@
 #include "ordered-data.h"
 #include "xattr.h"
 #include "tree-log.h"
-#include "ref-cache.h"
 #include "compression.h"
 #include "locking.h"
 
diff -urpN 6/fs/btrfs/Makefile 7/fs/btrfs/Makefile
--- 6/fs/btrfs/Makefile	2009-05-11 15:23:29.000000000 +0800
+++ 7/fs/btrfs/Makefile	2009-05-11 16:52:46.000000000 +0800
@@ -6,5 +6,5 @@ btrfs-y += super.o ctree.o extent-tree.o
 	   transaction.o inode.o file.o tree-defrag.o \
 	   extent_map.o sysfs.o struct-funcs.o xattr.o ordered-data.o \
 	   extent_io.o volumes.o async-thread.o ioctl.o locking.o orphan.o \
-	   ref-cache.o export.o tree-log.o acl.o free-space-cache.o zlib.o \
-	   compression.o delayed-ref.o
+	   export.o tree-log.o acl.o free-space-cache.o zlib.o \
+	   compression.o delayed-ref.o relocation.o
diff -urpN 6/fs/btrfs/transaction.c 7/fs/btrfs/transaction.c
--- 6/fs/btrfs/transaction.c	2009-05-11 15:40:07.000000000 +0800
+++ 7/fs/btrfs/transaction.c	2009-05-11 16:50:27.000000000 +0800
@@ -25,7 +25,6 @@
 #include "disk-io.h"
 #include "transaction.h"
 #include "locking.h"
-#include "ref-cache.h"
 #include "tree-log.h"
 
 #define BTRFS_ROOT_TRANS_TAG 0
diff -urpN 6/fs/btrfs/volumes.c 7/fs/btrfs/volumes.c
--- 6/fs/btrfs/volumes.c	2009-05-11 15:28:11.000000000 +0800
+++ 7/fs/btrfs/volumes.c	2009-05-11 16:02:34.000000000 +0800
@@ -1670,8 +1670,6 @@ static int btrfs_relocate_chunk(struct b
 	int ret;
 	int i;
 
-	printk(KERN_INFO "btrfs relocating chunk %llu\n",
-	       (unsigned long long)chunk_offset);
 	root = root->fs_info->chunk_root;
 	extent_root = root->fs_info->extent_root;
 	em_tree = &root->fs_info->mapping_tree.map_tree;

