From: "Yan Zheng" <zheng.yan@oracle.com>
Subject: [PATCH] implement memory reclaim for leaf reference cache
Date: Wed, 30 Jul 2008 23:52:07 +0800
Message-ID: <3d0408630807300852q28b12252g3230cc136c075ce3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Chris Mason" <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

The memory reclaiming issue happens when snapshot exists. In that
case, some cache entries may not be used during old snapshot dropping,
so they will remain in the cache until umount. The patch adds a field
to struct btrfs_leaf_ref to record create time. Besides, the patch
makes all dead roots of a given snapshot linked together in order of
create time. After a old snapshot was completely dropped, we check the
dead root list and remove all cache entries created before the oldest
dead root in the list.

Regards
YZ
---
diff -r 0bc0f555f73f ctree.h
--- a/ctree.h	Wed Jul 30 11:17:56 2008 +0800
+++ b/ctree.h	Wed Jul 30 11:04:28 2008 +0800
@@ -666,7 +666,8 @@ struct btrfs_root {
 	/* the dirty list is only used by non-reference counted roots */
 	struct list_head dirty_list;

-	spinlock_t orphan_lock;
+	spinlock_t list_lock;
+	struct list_head dead_list;
 	struct list_head orphan_list;
 };

diff -r 0bc0f555f73f disk-io.c
--- a/disk-io.c	Wed Jul 30 11:17:56 2008 +0800
+++ b/disk-io.c	Wed Jul 30 15:15:04 2008 +0800
@@ -735,8 +735,9 @@ static int __setup_root(u32 nodesize, u3

 	INIT_LIST_HEAD(&root->dirty_list);
 	INIT_LIST_HEAD(&root->orphan_list);
+	INIT_LIST_HEAD(&root->dead_list);
 	spin_lock_init(&root->node_lock);
-	spin_lock_init(&root->orphan_lock);
+	spin_lock_init(&root->list_lock);
 	mutex_init(&root->objectid_mutex);

 	btrfs_leaf_ref_tree_init(&root->ref_tree_struct);
diff -r 0bc0f555f73f inode.c
--- a/inode.c	Wed Jul 30 11:17:56 2008 +0800
+++ b/inode.c	Wed Jul 30 11:06:20 2008 +0800
@@ -835,17 +835,17 @@ int btrfs_orphan_add(struct btrfs_trans_
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret = 0;

-	spin_lock(&root->orphan_lock);
+	spin_lock(&root->list_lock);

 	/* already on the orphan list, we're good */
 	if (!list_empty(&BTRFS_I(inode)->i_orphan)) {
-		spin_unlock(&root->orphan_lock);
+		spin_unlock(&root->list_lock);
 		return 0;
 	}

 	list_add(&BTRFS_I(inode)->i_orphan, &root->orphan_list);

-	spin_unlock(&root->orphan_lock);
+	spin_unlock(&root->list_lock);

 	/*
 	 * insert an orphan item to track this unlinked/truncated file
@@ -864,20 +864,20 @@ int btrfs_orphan_del(struct btrfs_trans_
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret = 0;

-	spin_lock(&root->orphan_lock);
+	spin_lock(&root->list_lock);

 	if (list_empty(&BTRFS_I(inode)->i_orphan)) {
-		spin_unlock(&root->orphan_lock);
+		spin_unlock(&root->list_lock);
 		return 0;
 	}

 	list_del_init(&BTRFS_I(inode)->i_orphan);
 	if (!trans) {
-		spin_unlock(&root->orphan_lock);
+		spin_unlock(&root->list_lock);
 		return 0;
 	}

-	spin_unlock(&root->orphan_lock);
+	spin_unlock(&root->list_lock);

 	ret = btrfs_del_orphan_item(trans, root, inode->i_ino);

@@ -973,9 +973,9 @@ void btrfs_orphan_cleanup(struct btrfs_r
 		 * add this inode to the orphan list so btrfs_orphan_del does
 		 * the proper thing when we hit it
 		 */
-		spin_lock(&root->orphan_lock);
+		spin_lock(&root->list_lock);
 		list_add(&BTRFS_I(inode)->i_orphan, &root->orphan_list);
-		spin_unlock(&root->orphan_lock);
+		spin_unlock(&root->list_lock);

 		/*
 		 * if this is a bad inode, means we actually succeeded in
@@ -3269,13 +3269,13 @@ void btrfs_destroy_inode(struct inode *i
 	    BTRFS_I(inode)->i_default_acl != BTRFS_ACL_NOT_CACHED)
 		posix_acl_release(BTRFS_I(inode)->i_default_acl);

-	spin_lock(&BTRFS_I(inode)->root->orphan_lock);
+	spin_lock(&BTRFS_I(inode)->root->list_lock);
 	if (!list_empty(&BTRFS_I(inode)->i_orphan)) {
 		printk(KERN_ERR "BTRFS: inode %lu: inode still on the orphan"
 		       " list\n", inode->i_ino);
 		dump_stack();
 	}
-	spin_unlock(&BTRFS_I(inode)->root->orphan_lock);
+	spin_unlock(&BTRFS_I(inode)->root->list_lock);

 	while(1) {
 		ordered = btrfs_lookup_first_ordered_extent(inode, (u64)-1);
diff -r 0bc0f555f73f ref-cache.c
--- a/ref-cache.c	Wed Jul 30 11:17:56 2008 +0800
+++ b/ref-cache.c	Wed Jul 30 15:50:33 2008 +0800
@@ -21,12 +21,18 @@
 #include "ref-cache.h"
 #include "transaction.h"

-struct btrfs_leaf_ref *btrfs_alloc_leaf_ref(int nr_extents)
+struct btrfs_leaf_ref *btrfs_alloc_leaf_ref(struct btrfs_root *root,
+					    int nr_extents)
 {
 	struct btrfs_leaf_ref *ref;
+	size_t size = btrfs_leaf_ref_size(nr_extents);

-	ref = kmalloc(btrfs_leaf_ref_size(nr_extents), GFP_NOFS);
+	ref = kmalloc(size, GFP_NOFS);
 	if (ref) {
+		spin_lock(&root->fs_info->ref_cache_lock);
+		root->fs_info->total_ref_cache_size += size;
+		spin_unlock(&root->fs_info->ref_cache_lock);
+
 		memset(ref, 0, sizeof(*ref));
 		atomic_set(&ref->usage, 1);
 		INIT_LIST_HEAD(&ref->list);
@@ -34,14 +40,20 @@ struct btrfs_leaf_ref *btrfs_alloc_leaf_
 	return ref;
 }

-void btrfs_free_leaf_ref(struct btrfs_leaf_ref *ref)
+void btrfs_free_leaf_ref(struct btrfs_root *root, struct btrfs_leaf_ref *ref)
 {
 	if (!ref)
 		return;
 	WARN_ON(atomic_read(&ref->usage) == 0);
 	if (atomic_dec_and_test(&ref->usage)) {
+		size_t size = btrfs_leaf_ref_size(ref->nritems);
+
 		BUG_ON(ref->in_tree);
 		kfree(ref);
+
+		spin_lock(&root->fs_info->ref_cache_lock);
+		root->fs_info->total_ref_cache_size -= size;
+		spin_unlock(&root->fs_info->ref_cache_lock);
 	}
 }

@@ -91,9 +103,8 @@ static struct rb_node *tree_search(struc
 	return NULL;
 }

-int btrfs_remove_leaf_refs(struct btrfs_root *root)
+int btrfs_remove_leaf_refs(struct btrfs_root *root, u64 max_root_gen)
 {
-	struct rb_node *rb;
 	struct btrfs_leaf_ref *ref = NULL;
 	struct btrfs_leaf_ref_tree *tree = root->ref_tree;

@@ -101,17 +112,18 @@ int btrfs_remove_leaf_refs(struct btrfs_
 		return 0;

 	spin_lock(&tree->lock);
-	while(!btrfs_leaf_ref_tree_empty(tree)) {
-		rb = rb_first(&tree->root);
-		ref = rb_entry(rb, struct btrfs_leaf_ref, rb_node);
+	while(!list_empty(&tree->list)) {
+		ref = list_entry(tree->list.next, struct btrfs_leaf_ref, list);
+		BUG_ON(!ref->in_tree);
+		if (ref->root_gen > max_root_gen)
+			break;
+
 		rb_erase(&ref->rb_node, &tree->root);
 		ref->in_tree = 0;
 		list_del_init(&ref->list);

 		spin_unlock(&tree->lock);
-
-		btrfs_free_leaf_ref(ref);
-
+		btrfs_free_leaf_ref(root, ref);
 		cond_resched();
 		spin_lock(&tree->lock);
 	}
@@ -143,7 +155,6 @@ int btrfs_add_leaf_ref(struct btrfs_root
 {
 	int ret = 0;
 	struct rb_node *rb;
-	size_t size = btrfs_leaf_ref_size(ref->nritems);
 	struct btrfs_leaf_ref_tree *tree = root->ref_tree;

 	spin_lock(&tree->lock);
@@ -151,9 +162,6 @@ int btrfs_add_leaf_ref(struct btrfs_root
 	if (rb) {
 		ret = -EEXIST;
 	} else {
-		spin_lock(&root->fs_info->ref_cache_lock);
-		root->fs_info->total_ref_cache_size += size;
-		spin_unlock(&root->fs_info->ref_cache_lock);
 		atomic_inc(&ref->usage);
 		list_add_tail(&ref->list, &tree->list);
 	}
@@ -163,23 +171,18 @@ int btrfs_add_leaf_ref(struct btrfs_root

 int btrfs_remove_leaf_ref(struct btrfs_root *root, struct btrfs_leaf_ref *ref)
 {
-	size_t size = btrfs_leaf_ref_size(ref->nritems);
 	struct btrfs_leaf_ref_tree *tree = root->ref_tree;

 	BUG_ON(!ref->in_tree);
 	spin_lock(&tree->lock);
 	
-	spin_lock(&root->fs_info->ref_cache_lock);
-	root->fs_info->total_ref_cache_size -= size;
-	spin_unlock(&root->fs_info->ref_cache_lock);
-
 	rb_erase(&ref->rb_node, &tree->root);
 	ref->in_tree = 0;
 	list_del_init(&ref->list);

 	spin_unlock(&tree->lock);

-	btrfs_free_leaf_ref(ref);
+	btrfs_free_leaf_ref(root, ref);
 	return 0;
 }

diff -r 0bc0f555f73f ref-cache.h
--- a/ref-cache.h	Wed Jul 30 11:17:56 2008 +0800
+++ b/ref-cache.h	Wed Jul 30 14:04:03 2008 +0800
@@ -30,6 +30,7 @@ struct btrfs_leaf_ref {
 	int in_tree;
 	atomic_t usage;

+	u64 root_gen;
 	u64 bytenr;
 	u64 owner;
 	u64 generation;
@@ -48,7 +49,6 @@ static inline void btrfs_leaf_ref_tree_i
 static inline void btrfs_leaf_ref_tree_init(struct btrfs_leaf_ref_tree *tree)
 {
 	tree->root.rb_node = NULL;
-	tree->last = NULL;
 	INIT_LIST_HEAD(&tree->list);
 	spin_lock_init(&tree->lock);
 }
@@ -59,12 +59,13 @@ static inline int btrfs_leaf_ref_tree_em
 }

 void btrfs_leaf_ref_tree_init(struct btrfs_leaf_ref_tree *tree);
-struct btrfs_leaf_ref *btrfs_alloc_leaf_ref(int nr_extents);
-void btrfs_free_leaf_ref(struct btrfs_leaf_ref *ref);
+struct btrfs_leaf_ref *btrfs_alloc_leaf_ref(struct btrfs_root *root,
+					    int nr_extents);
+void btrfs_free_leaf_ref(struct btrfs_root *root, struct btrfs_leaf_ref *ref);
 struct btrfs_leaf_ref *btrfs_lookup_leaf_ref(struct btrfs_root *root,
 					     u64 bytenr);
 int btrfs_add_leaf_ref(struct btrfs_root *root, struct btrfs_leaf_ref *ref);
-int btrfs_remove_leaf_refs(struct btrfs_root *root);
+int btrfs_remove_leaf_refs(struct btrfs_root *root, u64 max_root_gen);
 int btrfs_remove_leaf_ref(struct btrfs_root *root, struct btrfs_leaf_ref *ref);

 #endif
diff -r 0bc0f555f73f transaction.c
--- a/transaction.c	Wed Jul 30 11:17:56 2008 +0800
+++ b/transaction.c	Wed Jul 30 15:23:09 2008 +0800
@@ -98,20 +98,24 @@ static noinline int record_root_in_trans
 			BUG_ON(!dirty);
 			dirty->root = kmalloc(sizeof(*dirty->root), GFP_NOFS);
 			BUG_ON(!dirty->root);
-
 			dirty->latest_root = root;
 			INIT_LIST_HEAD(&dirty->list);

 			root->commit_root = btrfs_root_node(root);
-			root->dirty_root = dirty;

 			memcpy(dirty->root, root, sizeof(*root));
-			dirty->root->ref_tree = &root->ref_tree_struct;
-
 			spin_lock_init(&dirty->root->node_lock);
+			spin_lock_init(&dirty->root->list_lock);
 			mutex_init(&dirty->root->objectid_mutex);
+			INIT_LIST_HEAD(&dirty->root->dead_list);
 			dirty->root->node = root->commit_root;
 			dirty->root->commit_root = NULL;
+
+			spin_lock(&root->list_lock);
+			list_add(&dirty->root->dead_list, &root->dead_list);
+			spin_unlock(&root->list_lock);
+
+			root->dirty_root = dirty;
 		} else {
 			WARN_ON(1);
 		}
@@ -356,8 +360,6 @@ int btrfs_commit_tree_roots(struct btrfs
 		list_del_init(next);
 		root = list_entry(next, struct btrfs_root, dirty_list);
 		update_cowonly_root(trans, root);
-		if (root->fs_info->closing)
-			btrfs_remove_leaf_refs(root);
 	}
 	return 0;
 }
@@ -411,6 +413,10 @@ static noinline int add_dirty_roots(stru
 				free_extent_buffer(root->commit_root);
 				root->commit_root = NULL;
 				
+				spin_lock(&root->list_lock);
+				list_del_init(&dirty->root->dead_list);
+				spin_unlock(&root->list_lock);
+
 				kfree(dirty->root);
 				kfree(dirty);

@@ -497,6 +503,7 @@ static noinline int drop_dirty_roots(str
 	unsigned long nr;
 	u64 num_bytes;
 	u64 bytes_used;
+	u64 max_useless;
 	int ret = 0;
 	int err;

@@ -554,8 +561,23 @@ static noinline int drop_dirty_roots(str
 		}
 		mutex_unlock(&root->fs_info->drop_mutex);

+		spin_lock(&root->list_lock);
+		list_del_init(&dirty->root->dead_list);
+		if (!list_empty(&root->dead_list)) {
+			struct btrfs_root *oldest;
+			oldest = list_entry(root->dead_list.prev,
+					    struct btrfs_root, dead_list);
+			max_useless = oldest->root_key.offset - 1;
+		} else {
+			max_useless = root->root_key.offset - 1;
+		}
+		spin_unlock(&root->list_lock);
+
 		nr = trans->blocks_used;
 		ret = btrfs_end_transaction(trans, tree_root);
+		BUG_ON(ret);
+		
+		ret = btrfs_remove_leaf_refs(root, max_useless);
 		BUG_ON(ret);

 		free_extent_buffer(dirty->root->node);
@@ -785,10 +807,9 @@ int btrfs_commit_transaction(struct btrf
 	put_transaction(cur_trans);
 	put_transaction(cur_trans);

+	list_splice_init(&dirty_fs_roots, &root->fs_info->dead_roots);
 	if (root->fs_info->closing)
 		list_splice_init(&root->fs_info->dead_roots, &dirty_fs_roots);
-	else
-		list_splice_init(&dirty_fs_roots, &root->fs_info->dead_roots);

 	mutex_unlock(&root->fs_info->trans_mutex);
 	kmem_cache_free(btrfs_trans_handle_cachep, trans);
