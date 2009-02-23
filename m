From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] Fix reference count lookup race
Date: Mon, 23 Feb 2009 21:59:48 +0800
Message-ID: <49A2ABD4.5090501@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

hello,

btrfs_lookup_extent_ref is used to check the reference
count for a given extent, it returns the sum of the
reference count recorded in BTRFS_EXTENT_ITEM and the
reference count modifications queued up in the delayed
back references. Since we can't get these two counts
atomically, it's possible someone else jumps in and
processes the delayed back references. This patch makes
btrfs_lookup_extent_ref properly the race. Thank you,

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/ctree.h 2/fs/btrfs/ctree.h
--- 1/fs/btrfs/ctree.h	2009-02-23 09:02:35.759728725 +0800
+++ 2/fs/btrfs/ctree.h	2009-02-23 21:19:43.000000000 +0800
@@ -1704,9 +1704,6 @@ static inline struct dentry *fdentry(str
 int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, unsigned long count);
 int btrfs_lookup_extent(struct btrfs_root *root, u64 start, u64 len);
-int btrfs_lookup_extent_ref(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root, u64 bytenr,
-			    u64 num_bytes, u32 *refs);
 int btrfs_update_pinned_extents(struct btrfs_root *root,
 				u64 bytenr, u64 num, int pin);
 int btrfs_drop_leaf_ref(struct btrfs_trans_handle *trans,
diff -urp 1/fs/btrfs/delayed-ref.c 2/fs/btrfs/delayed-ref.c
--- 1/fs/btrfs/delayed-ref.c	2009-02-23 09:02:35.759728725 +0800
+++ 2/fs/btrfs/delayed-ref.c	2009-02-23 21:19:43.000000000 +0800
@@ -194,58 +194,77 @@ out:
 }
 
 /*
- * the head node for a given bytenr is used to store the sum of all the
+ * helper function to lookup reference count
+ *
+ * the head node for delayed ref is used to store the sum of all the
  * reference count modifications queued up in the rbtree.  This way you
  * can check to see what the reference count would be if all of the
  * delayed refs are processed.
  */
-int btrfs_delayed_ref_count_mod(struct btrfs_trans_handle *trans, u64 bytenr)
+int btrfs_lookup_extent_ref(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root, u64 bytenr,
+			    u64 num_bytes, u32 *refs)
 {
 	struct btrfs_delayed_ref_node *ref;
 	struct btrfs_delayed_ref_head *head;
 	struct btrfs_delayed_ref_root *delayed_refs;
-	int ret = 0;
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+	struct btrfs_extent_item *ei;
+	struct btrfs_key key;
+	u32 num_refs;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
 
+	key.objectid = bytenr;
+	key.type = BTRFS_EXTENT_ITEM_KEY;
+	key.offset = num_bytes;
 	delayed_refs = &trans->transaction->delayed_refs;
 again:
+	ret = btrfs_search_slot(trans, root->fs_info->extent_root,
+				&key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+
+	if (ret == 0) {
+		leaf = path->nodes[0];
+		ei = btrfs_item_ptr(leaf, path->slots[0],
+				    struct btrfs_extent_item);
+		num_refs = btrfs_extent_refs(leaf, ei);
+	} else {
+		num_refs = 0;
+		ret = 0;
+	}
+
 	spin_lock(&delayed_refs->lock);
 	ref = tree_search(&delayed_refs->root, bytenr, (u64)-1);
 	if (ref) {
 		head = btrfs_delayed_node_to_head(ref);
-		/* common case first, grab the lock and copy out the
-		 * refs
-		 */
 		if (mutex_trylock(&head->mutex)) {
-			ret = ref->ref_mod;
+			num_refs += ref->ref_mod;
 			mutex_unlock(&head->mutex);
+			*refs = num_refs;
 			goto out;
 		}
-		/* lock contention, we need to wait for anyone
-		 * changing the refs on this extent.
-		 */
+
 		atomic_inc(&ref->refs);
 		spin_unlock(&delayed_refs->lock);
 
+		btrfs_release_path(root->fs_info->extent_root, path);
+
 		mutex_lock(&head->mutex);
-		/*
-		 * make sure we're still in the rb tree.  If not,
-		 * search again to make sure a new head hasn't been
-		 * inserted.  We can only trust our answer when we're
-		 * in the tree and we have the mutex locked.
-		 */
-		if (!ref->in_tree) {
-			mutex_unlock(&head->mutex);
-			btrfs_put_delayed_ref(ref);
-			goto again;
-		}
-		ret = ref->ref_mod;
 		mutex_unlock(&head->mutex);
 		btrfs_put_delayed_ref(ref);
-		goto out_nolock;
+		goto again;
+	} else {
+		*refs = num_refs;
 	}
 out:
 	spin_unlock(&delayed_refs->lock);
-out_nolock:
+	btrfs_free_path(path);
 	return ret;
 }
 
diff -urp 1/fs/btrfs/delayed-ref.h 2/fs/btrfs/delayed-ref.h
--- 1/fs/btrfs/delayed-ref.h	2009-02-23 09:02:35.759728725 +0800
+++ 2/fs/btrfs/delayed-ref.h	2009-02-23 21:19:43.000000000 +0800
@@ -144,7 +144,9 @@ int btrfs_delayed_ref_pending(struct btr
 int btrfs_lock_delayed_ref(struct btrfs_trans_handle *trans,
 			   struct btrfs_delayed_ref_node *ref,
 			   struct btrfs_delayed_ref_head **next_ret);
-int btrfs_delayed_ref_count_mod(struct btrfs_trans_handle *trans, u64 bytenr);
+int btrfs_lookup_extent_ref(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root, u64 bytenr,
+			    u64 num_bytes, u32 *refs);
 
 /*
  * a node might live in a head or a regular ref, this lets you
diff -urp 1/fs/btrfs/extent-tree.c 2/fs/btrfs/extent-tree.c
--- 1/fs/btrfs/extent-tree.c	2009-02-23 09:02:35.763717851 +0800
+++ 2/fs/btrfs/extent-tree.c	2009-02-23 21:19:43.000000000 +0800
@@ -1424,42 +1424,6 @@ int btrfs_finish_extent_mods(struct btrf
 	return 0;
 }
 
-int btrfs_lookup_extent_ref(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root, u64 bytenr,
-			    u64 num_bytes, u32 *refs)
-{
-	struct btrfs_path *path;
-	int ret;
-	struct btrfs_key key;
-	struct extent_buffer *l;
-	struct btrfs_extent_item *item;
-
-	WARN_ON(num_bytes < root->sectorsize);
-	path = btrfs_alloc_path();
-	path->reada = 1;
-	key.objectid = bytenr;
-	key.offset = num_bytes;
-	btrfs_set_key_type(&key, BTRFS_EXTENT_ITEM_KEY);
-	ret = btrfs_search_slot(trans, root->fs_info->extent_root, &key, path,
-				0, 0);
-	if (ret < 0)
-		goto out;
-	if (ret != 0) {
-		btrfs_print_leaf(root, path->nodes[0]);
-		printk(KERN_INFO "btrfs failed to find block number %llu\n",
-		       (unsigned long long)bytenr);
-		BUG();
-	}
-	l = path->nodes[0];
-	item = btrfs_item_ptr(l, path->slots[0], struct btrfs_extent_item);
-	*refs = btrfs_extent_refs(l, item);
-out:
-	btrfs_free_path(path);
-	if (ret == 0 && trans)
-		*refs += btrfs_delayed_ref_count_mod(trans, bytenr);
-	return 0;
-}
-
 static int drop_delayed_ref(struct btrfs_trans_handle *trans,
 					struct btrfs_root *root,
 					struct btrfs_delayed_ref_node *node)
@@ -4546,8 +4511,6 @@ static noinline int walk_down_subtree(st
 			path->slots[*level]++;
 			btrfs_tree_unlock(next);
 			free_extent_buffer(next);
-			btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
-			btrfs_extent_post_op(trans, root);
 			continue;
 		}
 
@@ -4575,8 +4538,6 @@ out:
 	path->nodes[*level] = NULL;
 	*level += 1;
 	cond_resched();
-	btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
-	btrfs_extent_post_op(trans, root);
 	return 0;
 }
 
@@ -4764,7 +4725,6 @@ int btrfs_drop_subtree(struct btrfs_tran
 	path->slots[level] = 0;
 
 	while (1) {
-		btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
 		wret = walk_down_subtree(trans, root, path, &level);
 		if (wret < 0)
 			ret = wret;
@@ -4779,7 +4739,6 @@ int btrfs_drop_subtree(struct btrfs_tran
 	}
 
 	btrfs_free_path(path);
-	btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
 	return ret;
 }
 
@@ -6141,9 +6100,6 @@ static noinline int relocate_one_extent(
 	trans = btrfs_start_transaction(extent_root, 1);
 	BUG_ON(!trans);
 
-	btrfs_run_delayed_refs(trans, extent_root, (unsigned long)-1);
-	btrfs_extent_post_op(trans, extent_root);
-
 	if (extent_key->objectid == 0) {
 		ret = del_extent_zero(trans, extent_root, path, extent_key);
 		goto out;
@@ -6156,9 +6112,6 @@ static noinline int relocate_one_extent(
 	}
 
 	for (loops = 0; ; loops++) {
-		btrfs_run_delayed_refs(trans, extent_root, (unsigned long)-1);
-		btrfs_extent_post_op(trans, extent_root);
-
 		if (loops == 0) {
 			ret = btrfs_first_ref_path(trans, extent_root, ref_path,
 						   extent_key->objectid);
@@ -6268,9 +6221,6 @@ static noinline int relocate_one_extent(
 	}
 	ret = 0;
 out:
-	btrfs_run_delayed_refs(trans, extent_root, (unsigned long)-1);
-	btrfs_extent_post_op(trans, extent_root);
-
 	btrfs_end_transaction(trans, extent_root);
 	kfree(new_extents);
 	kfree(ref_path);
@@ -6533,9 +6483,7 @@ again:
 	mutex_unlock(&root->fs_info->cleaner_mutex);
 
 	trans = btrfs_start_transaction(info->tree_root, 1);
-	btrfs_run_delayed_refs(trans, info->tree_root, (unsigned long)-1);
-	btrfs_extent_post_op(trans, root);
-	btrfs_end_transaction(trans, info->tree_root);
+	btrfs_commit_transaction(trans, info->tree_root);
 
 	while (1) {
 		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);

