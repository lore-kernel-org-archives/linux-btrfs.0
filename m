From: Yan Zheng <zheng.yan@oracle.com>
Subject: Re: [PATCH] initial version of reference cache
Date: Fri, 25 Jul 2008 15:57:53 -0500 (CDT)
Message-ID: <5173538.1217019473986.JavaMail.oracle@acsmt302.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I miss two new created files in previous patch, please use this one. Thanks

---
diff -r eb4767aa190e Makefile
--- a/Makefile	Thu Jul 24 12:25:50 2008 -0400
+++ b/Makefile	Sat Jul 26 03:47:26 2008 +0800
@@ -6,7 +6,8 @@ btrfs-y := super.o ctree.o extent-tree.o
 	   hash.o file-item.o inode-item.o inode-map.o disk-io.o \
 	   transaction.o bit-radix.o inode.o file.o tree-defrag.o \
 	   extent_map.o sysfs.o struct-funcs.o xattr.o ordered-data.o \
-	   extent_io.o volumes.o async-thread.o ioctl.o locking.o orphan.o
+	   extent_io.o volumes.o async-thread.o ioctl.o locking.o orphan.o \
+	   ref-cache.o

 btrfs-$(CONFIG_FS_POSIX_ACL)	+= acl.o
 else
diff -r eb4767aa190e ctree.c
--- a/ctree.c	Thu Jul 24 12:25:50 2008 -0400
+++ b/ctree.c	Sat Jul 26 03:47:26 2008 +0800
@@ -165,7 +165,7 @@ int btrfs_copy_root(struct btrfs_trans_h
 	btrfs_clear_header_flag(cow, BTRFS_HEADER_FLAG_WRITTEN);

 	WARN_ON(btrfs_header_generation(buf) > trans->transid);
-	ret = btrfs_inc_ref(trans, new_root, buf);
+	ret = btrfs_inc_ref(trans, new_root, buf, 0);
 	kfree(new_root);

 	if (ret)
@@ -232,7 +232,7 @@ int __btrfs_cow_block(struct btrfs_trans
 	WARN_ON(btrfs_header_generation(buf) > trans->transid);
 	if (btrfs_header_generation(buf) != trans->transid) {
 		different_trans = 1;
-		ret = btrfs_inc_ref(trans, root, buf);
+		ret = btrfs_inc_ref(trans, root, buf, 1);
 		if (ret)
 			return ret;
 	} else {
diff -r eb4767aa190e ctree.h
--- a/ctree.h	Thu Jul 24 12:25:50 2008 -0400
+++ b/ctree.h	Sat Jul 26 03:47:26 2008 +0800
@@ -592,6 +592,10 @@ struct btrfs_fs_info {
 	u64 last_alloc;
 	u64 last_data_alloc;

+	spinlock_t ref_cache_lock;
+	u64 total_ref_cache_size;
+	u64 running_ref_cache_size;
+
 	u64 avail_data_alloc_bits;
 	u64 avail_metadata_alloc_bits;
 	u64 avail_system_alloc_bits;
@@ -613,6 +617,8 @@ struct btrfs_root {
 	spinlock_t node_lock;

 	struct extent_buffer *commit_root;
+	struct btrfs_leaf_ref_tree *ref_tree;
+
 	struct btrfs_root_item root_item;
 	struct btrfs_key root_key;
 	struct btrfs_fs_info *fs_info;
@@ -1430,7 +1436,7 @@ int btrfs_reserve_extent(struct btrfs_tr
 				  u64 search_end, struct btrfs_key *ins,
 				  u64 data);
 int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		  struct extent_buffer *buf);
+		  struct extent_buffer *buf, int cache_ref);
 int btrfs_free_extent(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, u64 bytenr, u64 num_bytes,
 		      u64 root_objectid, u64 ref_generation,
diff -r eb4767aa190e disk-io.c
--- a/disk-io.c	Thu Jul 24 12:25:50 2008 -0400
+++ b/disk-io.c	Sat Jul 26 03:47:26 2008 +0800
@@ -716,6 +716,7 @@ static int __setup_root(u32 nodesize, u3
 	root->node = NULL;
 	root->inode = NULL;
 	root->commit_root = NULL;
+	root->ref_tree = NULL;
 	root->sectorsize = sectorsize;
 	root->nodesize = nodesize;
 	root->leafsize = leafsize;
@@ -1165,12 +1166,19 @@ static int transaction_kthread(void *arg
 		vfs_check_frozen(root->fs_info->sb, SB_FREEZE_WRITE);
 		mutex_lock(&root->fs_info->transaction_kthread_mutex);

+		printk("btrfs: total reference cache size %Lu\n",
+			root->fs_info->total_ref_cache_size);
+
 		mutex_lock(&root->fs_info->trans_mutex);
 		cur = root->fs_info->running_transaction;
 		if (!cur) {
 			mutex_unlock(&root->fs_info->trans_mutex);
 			goto sleep;
 		}
+
+		printk("btrfs: running reference cache size %Lu\n",
+			root->fs_info->running_ref_cache_size);
+
 		now = get_seconds();
 		if (now < cur->start_time || now - cur->start_time < 30) {
 			mutex_unlock(&root->fs_info->trans_mutex);
@@ -1233,6 +1241,7 @@ struct btrfs_root *open_ctree(struct sup
 	spin_lock_init(&fs_info->hash_lock);
 	spin_lock_init(&fs_info->delalloc_lock);
 	spin_lock_init(&fs_info->new_trans_lock);
+	spin_lock_init(&fs_info->ref_cache_lock);

 	init_completion(&fs_info->kobj_unregister);
 	fs_info->tree_root = tree_root;
@@ -1699,6 +1708,11 @@ int close_ctree(struct btrfs_root *root)
 		printk("btrfs: at unmount delalloc count %Lu\n",
 		       fs_info->delalloc_bytes);
 	}
+	if (fs_info->total_ref_cache_size) {
+		printk("btrfs: at umount reference cache size %Lu\n",
+			fs_info->total_ref_cache_size);
+	}
+	
 	if (fs_info->extent_root->node)
 		free_extent_buffer(fs_info->extent_root->node);

diff -r eb4767aa190e extent-tree.c
--- a/extent-tree.c	Thu Jul 24 12:25:50 2008 -0400
+++ b/extent-tree.c	Sat Jul 26 03:47:26 2008 +0800
@@ -26,6 +26,7 @@
 #include "transaction.h"
 #include "volumes.h"
 #include "locking.h"
+#include "ref-cache.h"

 #define BLOCK_GROUP_DATA     EXTENT_WRITEBACK
 #define BLOCK_GROUP_METADATA EXTENT_UPTODATE
@@ -927,7 +928,7 @@ out:
 }

 int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		  struct extent_buffer *buf)
+		  struct extent_buffer *buf, int cache_ref)
 {
 	u64 bytenr;
 	u32 nritems;
@@ -937,6 +938,7 @@ int btrfs_inc_ref(struct btrfs_trans_han
 	int level;
 	int ret;
 	int faili;
+	int nr_file_extents = 0;

 	if (!root->ref_cows)
 		return 0;
@@ -959,6 +961,9 @@ int btrfs_inc_ref(struct btrfs_trans_han
 			if (disk_bytenr == 0)
 				continue;

+			if (buf != root->commit_root)
+				nr_file_extents++;
+
 			mutex_lock(&root->fs_info->alloc_mutex);
 			ret = __btrfs_inc_extent_ref(trans, root, disk_bytenr,
 				    btrfs_file_extent_disk_num_bytes(buf, fi),
@@ -988,6 +993,53 @@ int btrfs_inc_ref(struct btrfs_trans_han
 			}
 		}
 	}
+	/* cache orignal leaf block's references */
+	if (cache_ref && nr_file_extents > 0) {
+		struct btrfs_leaf_ref *ref;
+		struct btrfs_extent_info *info;
+
+		ref = btrfs_alloc_leaf_ref(nr_file_extents);
+		if (!ref) {
+			WARN_ON(1);
+			goto out;
+		}
+
+		btrfs_item_key_to_cpu(buf, &ref->key, 0);
+
+		ref->bytenr = buf->start;
+		ref->owner = btrfs_header_owner(buf);
+		ref->generation = btrfs_header_generation(buf);
+		ref->nritems = nr_file_extents;
+		info = ref->extents;
+		
+		for (i = 0; i < nritems; i++) {
+			u64 disk_bytenr;
+			btrfs_item_key_to_cpu(buf, &key, i);
+			if (btrfs_key_type(&key) != BTRFS_EXTENT_DATA_KEY)
+				continue;
+			fi = btrfs_item_ptr(buf, i,
+					    struct btrfs_file_extent_item);
+			if (btrfs_file_extent_type(buf, fi) ==
+			    BTRFS_FILE_EXTENT_INLINE)
+				continue;
+			disk_bytenr = btrfs_file_extent_disk_bytenr(buf, fi);
+			if (disk_bytenr == 0)
+				continue;
+
+			info->bytenr = disk_bytenr;
+			info->num_bytes =
+				btrfs_file_extent_disk_num_bytes(buf, fi);
+			info->objectid = key.objectid;
+			info->offset = key.offset;
+			info++;
+		}
+
+		BUG_ON(!root->ref_tree);
+		ret = btrfs_add_leaf_ref(root, ref);
+		WARN_ON(ret);
+		btrfs_free_leaf_ref(ref);
+	}
+out:
 	return 0;
 fail:
 	WARN_ON(1);
@@ -2215,9 +2267,9 @@ struct extent_buffer *btrfs_alloc_free_b
 	return buf;
 }

-static int noinline drop_leaf_ref(struct btrfs_trans_handle *trans,
-				  struct btrfs_root *root,
-				  struct extent_buffer *leaf)
+static int noinline drop_leaf_ref_no_cache(struct btrfs_trans_handle *trans,
+				  	   struct btrfs_root *root,
+					   struct extent_buffer *leaf)
 {
 	u64 leaf_owner;
 	u64 leaf_generation;
@@ -2266,6 +2318,30 @@ static int noinline drop_leaf_ref(struct
 	return 0;
 }

+static int noinline drop_leaf_ref(struct btrfs_trans_handle *trans,
+				  	 struct btrfs_root *root,
+					 struct btrfs_leaf_ref *ref)
+{
+	int i;
+	int ret;
+	struct btrfs_extent_info *info = ref->extents;
+
+	mutex_unlock(&root->fs_info->alloc_mutex);
+	for (i = 0; i < ref->nritems; i++) {
+		mutex_lock(&root->fs_info->alloc_mutex);
+		ret = __btrfs_free_extent(trans, root,
+					info->bytenr, info->num_bytes,
+					ref->owner, ref->generation,
+					info->objectid, info->offset, 0);
+		mutex_unlock(&root->fs_info->alloc_mutex);
+		BUG_ON(ret);
+		info++;
+	}
+	mutex_lock(&root->fs_info->alloc_mutex);
+
+	return 0;
+}
+
 static void noinline reada_walk_down(struct btrfs_root *root,
 				     struct extent_buffer *node,
 				     int slot)
@@ -2341,6 +2417,7 @@ static int noinline walk_down_tree(struc
 	struct extent_buffer *next;
 	struct extent_buffer *cur;
 	struct extent_buffer *parent;
+	struct btrfs_leaf_ref *ref;
 	u32 blocksize;
 	int ret;
 	u32 refs;
@@ -2370,7 +2447,7 @@ static int noinline walk_down_tree(struc
 		    btrfs_header_nritems(cur))
 			break;
 		if (*level == 0) {
-			ret = drop_leaf_ref(trans, root, cur);
+			ret = drop_leaf_ref_no_cache(trans, root, cur);
 			BUG_ON(ret);
 			break;
 		}
@@ -2391,6 +2468,21 @@ static int noinline walk_down_tree(struc
 			BUG_ON(ret);
 			continue;
 		}
+		
+		if (*level == 1) {
+			struct btrfs_key key;
+			btrfs_node_key_to_cpu(cur, &key, path->slots[*level]);
+			ref = btrfs_lookup_leaf_ref(root, &key);
+			if (ref) {
+				ret = drop_leaf_ref(trans, root, ref);
+				BUG_ON(ret);
+				btrfs_remove_leaf_ref(root, ref);
+				btrfs_free_leaf_ref(ref);
+				*level = 0;
+				break;
+			}
+		}
+
 		next = btrfs_find_tree_block(root, bytenr, blocksize);
 		if (!next || !btrfs_buffer_uptodate(next, ptr_gen)) {
 			free_extent_buffer(next);
@@ -2435,17 +2527,19 @@ out:
 	WARN_ON(*level >= BTRFS_MAX_LEVEL);

 	if (path->nodes[*level] == root->node) {
-		root_owner = root->root_key.objectid;
 		parent = path->nodes[*level];
+		bytenr = path->nodes[*level]->start;
 	} else {
 		parent = path->nodes[*level + 1];
-		root_owner = btrfs_header_owner(parent);
-	}
-
+		bytenr = btrfs_node_blockptr(parent, path->slots[*level + 1]);
+	}
+
+	blocksize = btrfs_level_size(root, *level);
+	root_owner = btrfs_header_owner(parent);
 	root_gen = btrfs_header_generation(parent);
-	ret = __btrfs_free_extent(trans, root, path->nodes[*level]->start,
-				path->nodes[*level]->len,
-				root_owner, root_gen, 0, 0, 1);
+
+	ret = __btrfs_free_extent(trans, root, bytenr, blocksize,
+				  root_owner, root_gen, 0, 0, 1);
 	free_extent_buffer(path->nodes[*level]);
 	path->nodes[*level] = NULL;
 	*level += 1;
diff -r eb4767aa190e ref-cache.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/ref-cache.c	Fri Jul 25 21:56:56 2008 +0800
@@ -0,0 +1,195 @@
+/*
+ * Copyright (C) 2008 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#include "ctree.h"
+#include "ref-cache.h"
+#include "transaction.h"
+
+struct btrfs_leaf_ref *btrfs_alloc_leaf_ref(int nr_extents)
+{
+	struct btrfs_leaf_ref *ref;
+
+	ref = kmalloc(btrfs_leaf_ref_size(nr_extents), GFP_NOFS);
+	if (ref) {
+		memset(ref, 0, sizeof(*ref));
+		atomic_set(&ref->usage, 1);
+	}
+	return ref;
+}
+
+void btrfs_free_leaf_ref(struct btrfs_leaf_ref *ref)
+{
+	if (!ref)
+		return;
+	WARN_ON(atomic_read(&ref->usage) == 0);
+	if (atomic_dec_and_test(&ref->usage)) {
+		BUG_ON(ref->in_tree);
+		kfree(ref);
+	}
+}
+
+static int comp_keys(struct btrfs_key *k1, struct btrfs_key *k2)
+{
+	if (k1->objectid > k2->objectid)
+		return 1;
+	if (k1->objectid < k2->objectid)
+		return -1;
+	if (k1->type > k2->type)
+		return 1;
+	if (k1->type < k2->type)
+		return -1;
+	if (k1->offset > k2->offset)
+		return 1;
+	if (k1->offset < k2->offset)
+		return -1;
+	return 0;
+}
+
+static struct rb_node *tree_insert(struct rb_root *root, struct btrfs_key *key,
+				   struct rb_node *node)
+{
+	struct rb_node ** p = &root->rb_node;
+	struct rb_node * parent = NULL;
+	struct btrfs_leaf_ref *entry;
+	int ret;
+
+	while(*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct btrfs_leaf_ref, rb_node);
+		WARN_ON(!entry->in_tree);
+
+		ret = comp_keys(key, &entry->key);
+		if (ret < 0)
+			p = &(*p)->rb_left;
+		else if (ret > 0)
+			p = &(*p)->rb_right;
+		else
+			return parent;
+	}
+	
+	entry = rb_entry(node, struct btrfs_leaf_ref, rb_node);
+	entry->in_tree = 1;
+	rb_link_node(node, parent, p);
+	rb_insert_color(node, root);
+	return NULL;
+}
+
+static struct rb_node *tree_search(struct rb_root *root, struct btrfs_key *key)
+{
+	struct rb_node * n = root->rb_node;
+	struct btrfs_leaf_ref *entry;
+	int ret;
+
+	while(n) {
+		entry = rb_entry(n, struct btrfs_leaf_ref, rb_node);
+		WARN_ON(!entry->in_tree);
+
+		ret = comp_keys(key, &entry->key);
+		if (ret < 0)
+			n = n->rb_left;
+		else if (ret > 0)
+			n = n->rb_right;
+		else
+			return n;
+	}
+	return NULL;
+}
+
+struct btrfs_leaf_ref *btrfs_lookup_leaf_ref(struct btrfs_root *root,
+					     struct btrfs_key *key)
+{
+	struct rb_node *rb;
+	struct btrfs_leaf_ref *ref = NULL;
+	struct btrfs_leaf_ref_tree *tree = root->ref_tree;
+
+	if (!tree)
+		return NULL;
+
+	spin_lock(&tree->lock);
+	if (tree->last && comp_keys(key, &tree->last->key) == 0) {
+		ref = tree->last;
+	} else {
+		rb = tree_search(&tree->root, key);
+		if (rb) {
+			ref = rb_entry(rb, struct btrfs_leaf_ref, rb_node);
+			tree->last = ref;
+		}
+	}
+	if (ref)
+		atomic_inc(&ref->usage);
+	spin_unlock(&tree->lock);
+	return ref;
+}
+
+int btrfs_add_leaf_ref(struct btrfs_root *root, struct btrfs_leaf_ref *ref)
+{
+	int ret = 0;
+	struct rb_node *rb;
+	size_t size = btrfs_leaf_ref_size(ref->nritems);
+	struct btrfs_leaf_ref_tree *tree = root->ref_tree;
+	struct btrfs_transaction *trans = root->fs_info->running_transaction;
+
+	spin_lock(&tree->lock);
+	rb = tree_insert(&tree->root, &ref->key, &ref->rb_node);
+	if (rb) {
+		ret = -EEXIST;
+	} else {
+		spin_lock(&root->fs_info->ref_cache_lock);
+		root->fs_info->total_ref_cache_size += size;
+		if (trans && tree->generation == trans->transid)
+			root->fs_info->running_ref_cache_size += size;
+		spin_unlock(&root->fs_info->ref_cache_lock);
+
+		tree->last = ref;
+		atomic_inc(&ref->usage);
+	}
+	spin_unlock(&tree->lock);
+	return ret;
+}
+
+int btrfs_remove_leaf_ref(struct btrfs_root *root, struct btrfs_leaf_ref *ref)
+{
+	size_t size = btrfs_leaf_ref_size(ref->nritems);
+	struct btrfs_leaf_ref_tree *tree = root->ref_tree;
+	struct btrfs_transaction *trans = root->fs_info->running_transaction;
+
+	BUG_ON(!ref->in_tree);
+	spin_lock(&tree->lock);
+	rb_erase(&ref->rb_node, &tree->root);
+	ref->in_tree = 0;
+	
+	spin_lock(&root->fs_info->ref_cache_lock);
+	root->fs_info->total_ref_cache_size -= size;
+	if (trans && tree->generation == trans->transid)
+		root->fs_info->running_ref_cache_size -= size;
+	spin_unlock(&root->fs_info->ref_cache_lock);
+
+	if (tree->last == ref) {
+		struct rb_node *next = rb_next(&ref->rb_node);
+		if (next) {
+			tree->last = rb_entry(next, struct btrfs_leaf_ref,
+					      rb_node);
+		} else
+			tree->last = NULL;
+	}
+	spin_unlock(&tree->lock);
+
+	btrfs_free_leaf_ref(ref);
+	return 0;
+}
+
diff -r eb4767aa190e ref-cache.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/ref-cache.h	Fri Jul 25 21:58:24 2008 +0800
@@ -0,0 +1,71 @@
+/*
+ * Copyright (C) 2008 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+struct btrfs_extent_info {
+	u64 bytenr;
+	u64 num_bytes;
+	u64 objectid;
+	u64 offset;
+};
+
+struct btrfs_leaf_ref {
+	struct rb_node rb_node;
+	struct btrfs_key key;
+	int in_tree;
+	atomic_t usage;
+
+	u64 bytenr;
+	u64 owner;
+	u64 generation;
+	int nritems;
+	struct btrfs_extent_info extents[];
+};
+
+struct btrfs_leaf_ref_tree {
+	struct rb_root root;
+	struct btrfs_leaf_ref *last;
+	u64 generation;
+	spinlock_t lock;
+};
+
+static inline size_t btrfs_leaf_ref_size(int nr_extents)
+{
+	return sizeof(struct btrfs_leaf_ref) +
+	       sizeof(struct btrfs_extent_info) * nr_extents;
+}
+
+static inline void btrfs_leaf_ref_tree_init(struct btrfs_leaf_ref_tree *tree)
+{
+	tree->root.rb_node = NULL;
+	tree->last = NULL;
+	tree->generation = 0;
+	spin_lock_init(&tree->lock);
+}
+
+static inline int btrfs_leaf_ref_tree_empty(struct btrfs_leaf_ref_tree *tree)
+{
+	return RB_EMPTY_ROOT(&tree->root);
+}
+
+void btrfs_leaf_ref_tree_init(struct btrfs_leaf_ref_tree *tree);
+struct btrfs_leaf_ref *btrfs_alloc_leaf_ref(int nr_extents);
+void btrfs_free_leaf_ref(struct btrfs_leaf_ref *ref);
+struct btrfs_leaf_ref *btrfs_lookup_leaf_ref(struct btrfs_root *root,
+					     struct btrfs_key *key);
+int btrfs_add_leaf_ref(struct btrfs_root *root, struct btrfs_leaf_ref *ref);
+int btrfs_remove_leaf_ref(struct btrfs_root *root, struct btrfs_leaf_ref *ref);
diff -r eb4767aa190e transaction.c
--- a/transaction.c	Thu Jul 24 12:25:50 2008 -0400
+++ b/transaction.c	Sat Jul 26 03:47:26 2008 +0800
@@ -24,12 +24,20 @@
 #include "disk-io.h"
 #include "transaction.h"
 #include "locking.h"
+#include "ref-cache.h"

 static int total_trans = 0;
 extern struct kmem_cache *btrfs_trans_handle_cachep;
 extern struct kmem_cache *btrfs_transaction_cachep;

 #define BTRFS_ROOT_TRANS_TAG 0
+
+struct dirty_root {
+	struct list_head list;
+	struct btrfs_root *root;
+	struct btrfs_root *latest_root;
+	struct btrfs_leaf_ref_tree ref_tree;
+};

 static noinline void put_transaction(struct btrfs_transaction *transaction)
 {
@@ -84,6 +92,7 @@ static noinline int join_transaction(str

 static noinline int record_root_in_trans(struct btrfs_root *root)
 {
+	struct dirty_root *dirty;
 	u64 running_trans_id = root->fs_info->running_transaction->transid;
 	if (root->ref_cows && root->last_trans < running_trans_id) {
 		WARN_ON(root == root->fs_info->extent_root);
@@ -91,7 +100,25 @@ static noinline int record_root_in_trans
 			radix_tree_tag_set(&root->fs_info->fs_roots_radix,
 				   (unsigned long)root->root_key.objectid,
 				   BTRFS_ROOT_TRANS_TAG);
+
+			dirty = kmalloc(sizeof(*dirty), GFP_NOFS);
+			BUG_ON(!dirty);
+			dirty->root = kmalloc(sizeof(*dirty->root), GFP_NOFS);
+			BUG_ON(!dirty->root);
+
+			dirty->latest_root = root;
+			INIT_LIST_HEAD(&dirty->list);
+			btrfs_leaf_ref_tree_init(&dirty->ref_tree);
+			dirty->ref_tree.generation = running_trans_id;
+
 			root->commit_root = btrfs_root_node(root);
+			root->ref_tree = &dirty->ref_tree;
+
+			memcpy(dirty->root, root, sizeof(*root));
+			spin_lock_init(&dirty->root->node_lock);
+			mutex_init(&dirty->root->objectid_mutex);
+			dirty->root->node = root->commit_root;
+			dirty->root->commit_root = NULL;
 		} else {
 			WARN_ON(1);
 		}
@@ -310,12 +337,6 @@ int btrfs_commit_tree_roots(struct btrfs
 	return 0;
 }

-struct dirty_root {
-	struct list_head list;
-	struct btrfs_root *root;
-	struct btrfs_root *latest_root;
-};
-
 int btrfs_add_dead_root(struct btrfs_root *root,
 			struct btrfs_root *latest,
 			struct list_head *dead_list)
@@ -325,8 +346,10 @@ int btrfs_add_dead_root(struct btrfs_roo
 	dirty = kmalloc(sizeof(*dirty), GFP_NOFS);
 	if (!dirty)
 		return -ENOMEM;
+	btrfs_leaf_ref_tree_init(&dirty->ref_tree);
 	dirty->root = root;
 	dirty->latest_root = latest;
+	root->ref_tree = NULL;
 	list_add(&dirty->list, dead_list);
 	return 0;
 }
@@ -354,11 +377,23 @@ static noinline int add_dirty_roots(stru
 			radix_tree_tag_clear(radix,
 				     (unsigned long)root->root_key.objectid,
 				     BTRFS_ROOT_TRANS_TAG);
+
+			BUG_ON(!root->ref_tree);
+			dirty = container_of(root->ref_tree, struct dirty_root,
+					     ref_tree);
+
 			if (root->commit_root == root->node) {
 				WARN_ON(root->node->start !=
 					btrfs_root_bytenr(&root->root_item));
+
+				BUG_ON(!btrfs_leaf_ref_tree_empty(
+							root->ref_tree));
 				free_extent_buffer(root->commit_root);
 				root->commit_root = NULL;
+				root->ref_tree = NULL;
+				
+				kfree(dirty->root);
+				kfree(dirty);

 				/* make sure to update the root on disk
 				 * so we get any updates to the block used
@@ -370,23 +405,12 @@ static noinline int add_dirty_roots(stru
 						&root->root_item);
 				continue;
 			}
-			dirty = kmalloc(sizeof(*dirty), GFP_NOFS);
-			BUG_ON(!dirty);
-			dirty->root = kmalloc(sizeof(*dirty->root), GFP_NOFS);
-			BUG_ON(!dirty->root);

 			memset(&root->root_item.drop_progress, 0,
 			       sizeof(struct btrfs_disk_key));
 			root->root_item.drop_level = 0;
-
-			memcpy(dirty->root, root, sizeof(*root));
-			dirty->root->node = root->commit_root;
-			dirty->latest_root = root;
-			spin_lock_init(&dirty->root->node_lock);
-			mutex_init(&dirty->root->objectid_mutex);
-
 			root->commit_root = NULL;
-
+			root->ref_tree = NULL;
 			root->root_key.offset = root->fs_info->generation;
 			btrfs_set_root_bytenr(&root->root_item,
 					      root->node->start);
@@ -409,6 +433,7 @@ static noinline int add_dirty_roots(stru
 				list_add(&dirty->list, list);
 			} else {
 				WARN_ON(1);
+				free_extent_buffer(dirty->root->node);
 				kfree(dirty->root);
 				kfree(dirty);
 			}
@@ -514,6 +539,9 @@ static noinline int drop_dirty_roots(str
 		ret = btrfs_end_transaction(trans, tree_root);
 		BUG_ON(ret);

+		if (dirty->root->ref_tree)
+			WARN_ON(!btrfs_leaf_ref_tree_empty(dirty->root->ref_tree));
+	
 		free_extent_buffer(dirty->root->node);
 		kfree(dirty->root);
 		kfree(dirty);
@@ -697,6 +725,10 @@ int btrfs_commit_transaction(struct btrf
 	ret = add_dirty_roots(trans, &root->fs_info->fs_roots_radix,
 			      &dirty_fs_roots);
 	BUG_ON(ret);
+
+	spin_lock(&root->fs_info->ref_cache_lock);
+	root->fs_info->running_ref_cache_size = 0;
+	spin_unlock(&root->fs_info->ref_cache_lock);

 	ret = btrfs_commit_tree_roots(trans, root);
 	BUG_ON(ret);

