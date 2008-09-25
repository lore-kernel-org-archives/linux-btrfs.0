From: Zheng Yan <zheng.yan@oracle.com>
Subject: [PATCH 2/4] Add shared reference cache
Date: Thu, 25 Sep 2008 17:24:39 +0800
Message-ID: <48DB58D7.4080406@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This patch adds shared reference cache support. The new space
balancing code plays with multiple subvols at the same time, So
the old per-subvol reference cache isn't fit for it.

Regards
Yan Zheng

---
diff -r 47aa0c51998a ctree.h
--- a/ctree.h	Thu Sep 25 16:00:36 2008 +0800
+++ b/ctree.h	Thu Sep 25 16:02:11 2008 +0800
@@ -80,6 +80,10 @@
 /* does write ahead logging to speed up fsyncs */
 #define BTRFS_TREE_LOG_OBJECTID -6ULL
 #define BTRFS_TREE_LOG_FIXUP_OBJECTID -7ULL
+
+/* for space balancing */
+#define BTRFS_TREE_RELOC_OBJECTID -8ULL
+#define BTRFS_DATA_RELOC_TREE_OBJECTID -9ULL
 
 /* dummy objectid represents multiple objectids */
 #define BTRFS_MULTIPLE_OBJECTIDS -255ULL
@@ -539,6 +543,12 @@
 	struct list_head list;
 };
 
+struct btrfs_leaf_ref_tree {
+	struct rb_root root;
+	struct list_head list;
+	spinlock_t lock;
+};
+
 struct btrfs_device;
 struct btrfs_fs_devices;
 struct btrfs_fs_info {
@@ -637,6 +647,8 @@
 	struct task_struct *cleaner_kthread;
 	int thread_pool_size;
 
+	struct btrfs_leaf_ref_tree shared_ref_tree;
+
 	struct kobject super_kobj;
 	struct completion kobj_unregister;
 	int do_barriers;
@@ -668,13 +680,6 @@
 	u64 system_alloc_profile;
 
 	void *bdev_holder;
-};
-
-struct btrfs_leaf_ref_tree {
-	struct rb_root root;
-	struct btrfs_leaf_ref *last;
-	struct list_head list;
-	spinlock_t lock;
 };
 
 /*
diff -r 47aa0c51998a disk-io.c
--- a/disk-io.c	Thu Sep 25 16:00:36 2008 +0800
+++ b/disk-io.c	Thu Sep 25 16:02:11 2008 +0800
@@ -1430,6 +1430,8 @@
 			     fs_info->btree_inode->i_mapping, GFP_NOFS);
 	fs_info->do_barriers = 1;
 
+	btrfs_leaf_ref_tree_init(&fs_info->shared_ref_tree);
+
 	BTRFS_I(fs_info->btree_inode)->root = tree_root;
 	memset(&BTRFS_I(fs_info->btree_inode)->location, 0,
 	       sizeof(struct btrfs_key));
diff -r 47aa0c51998a extent-tree.c
--- a/extent-tree.c	Thu Sep 25 16:00:36 2008 +0800
+++ b/extent-tree.c	Thu Sep 25 16:02:11 2008 +0800
@@ -1091,15 +1091,25 @@
 int btrfs_cache_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		    struct extent_buffer *buf, u32 nr_extents)
 {
-	u32 nritems;
 	struct btrfs_key key;
 	struct btrfs_file_extent_item *fi;
-	int i;
-	int level;
-	int ret = 0;
+	u64 root_gen;
+	u32 nritems;
+	int i;
+	int level;
+	int ret = 0;
+	int shared = 0;
 
 	if (!root->ref_cows)
 		return 0;
+
+	if (root->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID) {
+		shared = 0;
+		root_gen = root->root_key.offset;
+	} else {
+		shared = 1;
+		root_gen = trans->transid - 1;
+	}
 
 	level = btrfs_header_level(buf);
 	nritems = btrfs_header_nritems(buf);
@@ -1114,7 +1124,7 @@
 			goto out;
 		}
 
-		ref->root_gen = root->root_key.offset;
+		ref->root_gen = root_gen;
 		ref->bytenr = buf->start;
 		ref->owner = btrfs_header_owner(buf);
 		ref->generation = btrfs_header_generation(buf);
@@ -1143,8 +1153,7 @@
 			info++;
 		}
 
-		BUG_ON(!root->ref_tree);
-		ret = btrfs_add_leaf_ref(root, ref);
+		ret = btrfs_add_leaf_ref(root, ref, shared);
 		WARN_ON(ret);
 		btrfs_free_leaf_ref(root, ref);
 	}
diff -r 47aa0c51998a ref-cache.c
--- a/ref-cache.c	Thu Sep 25 16:00:36 2008 +0800
+++ b/ref-cache.c	Thu Sep 25 16:02:11 2008 +0800
@@ -78,7 +78,6 @@
 	}
 
 	entry = rb_entry(node, struct btrfs_leaf_ref, rb_node);
-	entry->in_tree = 1;
 	rb_link_node(node, parent, p);
 	rb_insert_color(node, root);
 	return NULL;
@@ -103,23 +102,29 @@
 	return NULL;
 }
 
-int btrfs_remove_leaf_refs(struct btrfs_root *root, u64 max_root_gen)
+int btrfs_remove_leaf_refs(struct btrfs_root *root, u64 max_root_gen,
+			   int shared)
 {
 	struct btrfs_leaf_ref *ref = NULL;
 	struct btrfs_leaf_ref_tree *tree = root->ref_tree;
 
+	if (shared)
+		tree = &root->fs_info->shared_ref_tree;
 	if (!tree)
 		return 0;
 
 	spin_lock(&tree->lock);
 	while(!list_empty(&tree->list)) {
 		ref = list_entry(tree->list.next, struct btrfs_leaf_ref, list);
-		BUG_ON(!ref->in_tree);
+		BUG_ON(ref->tree != tree);
 		if (ref->root_gen > max_root_gen)
 			break;
+		if (!xchg(&ref->in_tree, 0)) {
+			cond_resched_lock(&tree->lock);
+			continue;
+		}
 
 		rb_erase(&ref->rb_node, &tree->root);
-		ref->in_tree = 0;
 		list_del_init(&ref->list);
 
 		spin_unlock(&tree->lock);
@@ -137,25 +142,34 @@
 	struct rb_node *rb;
 	struct btrfs_leaf_ref *ref = NULL;
 	struct btrfs_leaf_ref_tree *tree = root->ref_tree;
-
-	if (!tree)
-		return NULL;
-
-	spin_lock(&tree->lock);
-	rb = tree_search(&tree->root, bytenr);
-	if (rb)
-		ref = rb_entry(rb, struct btrfs_leaf_ref, rb_node);
-	if (ref)
-		atomic_inc(&ref->usage);
-	spin_unlock(&tree->lock);
-	return ref;
+again:
+	if (tree) {
+		spin_lock(&tree->lock);
+		rb = tree_search(&tree->root, bytenr);
+		if (rb)
+			ref = rb_entry(rb, struct btrfs_leaf_ref, rb_node);
+		if (ref)
+			atomic_inc(&ref->usage);
+		spin_unlock(&tree->lock);
+		if (ref)
+			return ref;
+	}
+	if (tree != &root->fs_info->shared_ref_tree) {
+		tree = &root->fs_info->shared_ref_tree;
+		goto again;
+	}
+	return NULL;
 }
 
-int btrfs_add_leaf_ref(struct btrfs_root *root, struct btrfs_leaf_ref *ref)
+int btrfs_add_leaf_ref(struct btrfs_root *root, struct btrfs_leaf_ref *ref,
+		       int shared)
 {
 	int ret = 0;
 	struct rb_node *rb;
 	struct btrfs_leaf_ref_tree *tree = root->ref_tree;
+
+	if (shared)
+		tree = &root->fs_info->shared_ref_tree;
 
 	spin_lock(&tree->lock);
 	rb = tree_insert(&tree->root, ref->bytenr, &ref->rb_node);
@@ -163,6 +177,8 @@
 		ret = -EEXIST;
 	} else {
 		atomic_inc(&ref->usage);
+		ref->tree = tree;
+		ref->in_tree = 1;
 		list_add_tail(&ref->list, &tree->list);
 	}
 	spin_unlock(&tree->lock);
@@ -171,13 +187,15 @@
 
 int btrfs_remove_leaf_ref(struct btrfs_root *root, struct btrfs_leaf_ref *ref)
 {
-	struct btrfs_leaf_ref_tree *tree = root->ref_tree;
+	struct btrfs_leaf_ref_tree *tree;
 
-	BUG_ON(!ref->in_tree);
+	if (!xchg(&ref->in_tree, 0))
+		return 0;
+
+	tree = ref->tree;
 	spin_lock(&tree->lock);
 
 	rb_erase(&ref->rb_node, &tree->root);
-	ref->in_tree = 0;
 	list_del_init(&ref->list);
 
 	spin_unlock(&tree->lock);
diff -r 47aa0c51998a ref-cache.h
--- a/ref-cache.h	Thu Sep 25 16:00:36 2008 +0800
+++ b/ref-cache.h	Thu Sep 25 16:02:11 2008 +0800
@@ -27,6 +27,7 @@
 
 struct btrfs_leaf_ref {
 	struct rb_node rb_node;
+	struct btrfs_leaf_ref_tree *tree;
 	int in_tree;
 	atomic_t usage;
 
@@ -64,8 +65,10 @@
 void btrfs_free_leaf_ref(struct btrfs_root *root, struct btrfs_leaf_ref *ref);
 struct btrfs_leaf_ref *btrfs_lookup_leaf_ref(struct btrfs_root *root,
 					     u64 bytenr);
-int btrfs_add_leaf_ref(struct btrfs_root *root, struct btrfs_leaf_ref *ref);
-int btrfs_remove_leaf_refs(struct btrfs_root *root, u64 max_root_gen);
+int btrfs_add_leaf_ref(struct btrfs_root *root, struct btrfs_leaf_ref *ref,
+		       int shared);
+int btrfs_remove_leaf_refs(struct btrfs_root *root, u64 max_root_gen,
+			   int shared);
 int btrfs_remove_leaf_ref(struct btrfs_root *root, struct btrfs_leaf_ref *ref);
 
 #endif
diff -r 47aa0c51998a transaction.c
--- a/transaction.c	Thu Sep 25 16:00:36 2008 +0800
+++ b/transaction.c	Thu Sep 25 16:02:11 2008 +0800
@@ -650,7 +650,7 @@
 		ret = btrfs_end_transaction(trans, tree_root);
 		BUG_ON(ret);
 
-		ret = btrfs_remove_leaf_refs(root, max_useless);
+		ret = btrfs_remove_leaf_refs(root, max_useless, 0);
 		BUG_ON(ret);
 
 		free_extent_buffer(dirty->root->node);
