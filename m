From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH V2 06/12] Btrfs: Integrate metadata reservation with start_transaction
Date: Mon, 26 Apr 2010 18:45:03 +0800
Message-ID: <4BD56EAF.4060006@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Besides simplify the code, this change makes sure all metadata
reservation for normal metadata operations are released after
committing transaction.

Changes since V1:

Add code that check if unlink and rmdir will free space.

Add ENOSPC handling for clone ioctl.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 2/fs/btrfs/ctree.h 3/fs/btrfs/ctree.h
--- 2/fs/btrfs/ctree.h	2010-04-26 17:25:43.083829363 +0800
+++ 3/fs/btrfs/ctree.h	2010-04-26 17:25:43.090830839 +0800
@@ -33,6 +33,7 @@
 
 struct btrfs_trans_handle;
 struct btrfs_transaction;
+struct btrfs_pending_snapshot;
 extern struct kmem_cache *btrfs_trans_handle_cachep;
 extern struct kmem_cache *btrfs_transaction_cachep;
 extern struct kmem_cache *btrfs_bit_radix_cachep;
@@ -969,6 +970,7 @@ struct btrfs_fs_info {
 	int do_barriers;
 	int closing;
 	int log_root_recovering;
+	int enospc_unlink;
 
 	u64 total_pinned;
 
@@ -1994,6 +1996,9 @@ void btrfs_put_block_group(struct btrfs_
 int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, unsigned long count);
 int btrfs_lookup_extent(struct btrfs_root *root, u64 start, u64 len);
+int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
+			     struct btrfs_root *root, u64 bytenr,
+			     u64 num_bytes, u64 *refs, u64 *flags);
 int btrfs_pin_extent(struct btrfs_root *root,
 		     u64 bytenr, u64 num, int reserved);
 int btrfs_drop_leaf_ref(struct btrfs_trans_handle *trans,
@@ -2074,8 +2079,6 @@ u64 btrfs_reduce_alloc_profile(struct bt
 void btrfs_set_inode_space_info(struct btrfs_root *root, struct inode *ionde);
 void btrfs_clear_space_info_full(struct btrfs_fs_info *info);
 
-int btrfs_reserve_metadata_space(struct btrfs_root *root, int num_items);
-int btrfs_unreserve_metadata_space(struct btrfs_root *root, int num_items);
 int btrfs_unreserve_metadata_for_delalloc(struct btrfs_root *root,
 					  struct inode *inode, int num_items);
 int btrfs_reserve_metadata_for_delalloc(struct btrfs_root *root,
@@ -2088,6 +2091,13 @@ void btrfs_delalloc_reserve_space(struct
 				 u64 bytes);
 void btrfs_delalloc_free_space(struct btrfs_root *root, struct inode *inode,
 			      u64 bytes);
+int btrfs_trans_reserve_metadata(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root,
+				int num_items, int *retries);
+void btrfs_trans_release_metadata(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root);
+int btrfs_snap_reserve_metadata(struct btrfs_trans_handle *trans,
+				struct btrfs_pending_snapshot *pending);
 void btrfs_init_block_rsv(struct btrfs_block_rsv *rsv);
 struct btrfs_block_rsv *btrfs_alloc_block_rsv(struct btrfs_root *root);
 void btrfs_free_block_rsv(struct btrfs_root *root,
@@ -2295,6 +2305,12 @@ int btrfs_del_inode_ref(struct btrfs_tra
 			   struct btrfs_root *root,
 			   const char *name, int name_len,
 			   u64 inode_objectid, u64 ref_objectid, u64 *index);
+struct btrfs_inode_ref *
+btrfs_lookup_inode_ref(struct btrfs_trans_handle *trans,
+			struct btrfs_root *root,
+			struct btrfs_path *path,
+			const char *name, int name_len,
+			u64 inode_objectid, u64 ref_objectid, int mod);
 int btrfs_insert_empty_inode(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
 			     struct btrfs_path *path, u64 objectid);
diff -urp 2/fs/btrfs/delayed-ref.c 3/fs/btrfs/delayed-ref.c
--- 2/fs/btrfs/delayed-ref.c	2010-04-26 17:25:43.077830472 +0800
+++ 3/fs/btrfs/delayed-ref.c	2010-04-26 17:25:43.091840130 +0800
@@ -318,107 +318,6 @@ out:
 }
 
 /*
- * helper function to lookup reference count and flags of extent.
- *
- * the head node for delayed ref is used to store the sum of all the
- * reference count modifications queued up in the rbtree. the head
- * node may also store the extent flags to set. This way you can check
- * to see what the reference count and extent flags would be if all of
- * the delayed refs are not processed.
- */
-int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *root, u64 bytenr,
-			     u64 num_bytes, u64 *refs, u64 *flags)
-{
-	struct btrfs_delayed_ref_node *ref;
-	struct btrfs_delayed_ref_head *head;
-	struct btrfs_delayed_ref_root *delayed_refs;
-	struct btrfs_path *path;
-	struct btrfs_extent_item *ei;
-	struct extent_buffer *leaf;
-	struct btrfs_key key;
-	u32 item_size;
-	u64 num_refs;
-	u64 extent_flags;
-	int ret;
-
-	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
-
-	key.objectid = bytenr;
-	key.type = BTRFS_EXTENT_ITEM_KEY;
-	key.offset = num_bytes;
-	delayed_refs = &trans->transaction->delayed_refs;
-again:
-	ret = btrfs_search_slot(trans, root->fs_info->extent_root,
-				&key, path, 0, 0);
-	if (ret < 0)
-		goto out;
-
-	if (ret == 0) {
-		leaf = path->nodes[0];
-		item_size = btrfs_item_size_nr(leaf, path->slots[0]);
-		if (item_size >= sizeof(*ei)) {
-			ei = btrfs_item_ptr(leaf, path->slots[0],
-					    struct btrfs_extent_item);
-			num_refs = btrfs_extent_refs(leaf, ei);
-			extent_flags = btrfs_extent_flags(leaf, ei);
-		} else {
-#ifdef BTRFS_COMPAT_EXTENT_TREE_V0
-			struct btrfs_extent_item_v0 *ei0;
-			BUG_ON(item_size != sizeof(*ei0));
-			ei0 = btrfs_item_ptr(leaf, path->slots[0],
-					     struct btrfs_extent_item_v0);
-			num_refs = btrfs_extent_refs_v0(leaf, ei0);
-			/* FIXME: this isn't correct for data */
-			extent_flags = BTRFS_BLOCK_FLAG_FULL_BACKREF;
-#else
-			BUG();
-#endif
-		}
-		BUG_ON(num_refs == 0);
-	} else {
-		num_refs = 0;
-		extent_flags = 0;
-		ret = 0;
-	}
-
-	spin_lock(&delayed_refs->lock);
-	ref = find_ref_head(&delayed_refs->root, bytenr, NULL);
-	if (ref) {
-		head = btrfs_delayed_node_to_head(ref);
-		if (!mutex_trylock(&head->mutex)) {
-			atomic_inc(&ref->refs);
-			spin_unlock(&delayed_refs->lock);
-
-			btrfs_release_path(root->fs_info->extent_root, path);
-
-			mutex_lock(&head->mutex);
-			mutex_unlock(&head->mutex);
-			btrfs_put_delayed_ref(ref);
-			goto again;
-		}
-		if (head->extent_op && head->extent_op->update_flags)
-			extent_flags |= head->extent_op->flags_to_set;
-		else
-			BUG_ON(num_refs == 0);
-
-		num_refs += ref->ref_mod;
-		mutex_unlock(&head->mutex);
-	}
-	WARN_ON(num_refs == 0);
-	if (refs)
-		*refs = num_refs;
-	if (flags)
-		*flags = extent_flags;
-out:
-	spin_unlock(&delayed_refs->lock);
-	btrfs_free_path(path);
-	return ret;
-}
-
-/*
  * helper function to update an extent delayed ref in the
  * rbtree.  existing and update must both have the same
  * bytenr and parent
diff -urp 2/fs/btrfs/delayed-ref.h 3/fs/btrfs/delayed-ref.h
--- 2/fs/btrfs/delayed-ref.h	2010-04-26 17:25:43.083829363 +0800
+++ 3/fs/btrfs/delayed-ref.h	2010-04-26 17:25:43.091840130 +0800
@@ -167,9 +167,6 @@ int btrfs_add_delayed_extent_op(struct b
 struct btrfs_delayed_ref_head *
 btrfs_find_delayed_ref_head(struct btrfs_trans_handle *trans, u64 bytenr);
 int btrfs_delayed_ref_pending(struct btrfs_trans_handle *trans, u64 bytenr);
-int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *root, u64 bytenr,
-			     u64 num_bytes, u64 *refs, u64 *flags);
 int btrfs_update_delayed_ref(struct btrfs_trans_handle *trans,
 			  u64 bytenr, u64 num_bytes, u64 orig_parent,
 			  u64 parent, u64 orig_ref_root, u64 ref_root,
diff -urp 2/fs/btrfs/disk-io.c 3/fs/btrfs/disk-io.c
--- 2/fs/btrfs/disk-io.c	2010-04-26 17:25:43.078829985 +0800
+++ 3/fs/btrfs/disk-io.c	2010-04-26 17:25:43.091840130 +0800
@@ -1531,7 +1531,7 @@ static int transaction_kthread(void *arg
 			goto sleep;
 		}
 		mutex_unlock(&root->fs_info->trans_mutex);
-		trans = btrfs_start_transaction(root, 1);
+		trans = btrfs_join_transaction(root, 1);
 		ret = btrfs_commit_transaction(trans, root);
 
 sleep:
@@ -2418,11 +2418,11 @@ int btrfs_commit_super(struct btrfs_root
 	down_write(&root->fs_info->cleanup_work_sem);
 	up_write(&root->fs_info->cleanup_work_sem);
 
-	trans = btrfs_start_transaction(root, 1);
+	trans = btrfs_join_transaction(root, 1);
 	ret = btrfs_commit_transaction(trans, root);
 	BUG_ON(ret);
 	/* run commit again to drop the original snapshot */
-	trans = btrfs_start_transaction(root, 1);
+	trans = btrfs_join_transaction(root, 1);
 	btrfs_commit_transaction(trans, root);
 	ret = btrfs_write_and_wait_transaction(NULL, root);
 	BUG_ON(ret);
diff -urp 2/fs/btrfs/extent-tree.c 3/fs/btrfs/extent-tree.c
--- 2/fs/btrfs/extent-tree.c	2010-04-26 17:25:43.084829085 +0800
+++ 3/fs/btrfs/extent-tree.c	2010-04-26 17:25:43.094110003 +0800
@@ -615,6 +615,113 @@ int btrfs_lookup_extent(struct btrfs_roo
 }
 
 /*
+ * helper function to lookup reference count and flags of extent.
+ *
+ * the head node for delayed ref is used to store the sum of all the
+ * reference count modifications queued up in the rbtree. the head
+ * node may also store the extent flags to set. This way you can check
+ * to see what the reference count and extent flags would be if all of
+ * the delayed refs are not processed.
+ */
+int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
+			     struct btrfs_root *root, u64 bytenr,
+			     u64 num_bytes, u64 *refs, u64 *flags)
+{
+	struct btrfs_delayed_ref_head *head;
+	struct btrfs_delayed_ref_root *delayed_refs;
+	struct btrfs_path *path;
+	struct btrfs_extent_item *ei;
+	struct extent_buffer *leaf;
+	struct btrfs_key key;
+	u32 item_size;
+	u64 num_refs;
+	u64 extent_flags;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	key.objectid = bytenr;
+	key.type = BTRFS_EXTENT_ITEM_KEY;
+	key.offset = num_bytes;
+	if (!trans) {
+		path->skip_locking = 1;
+		path->search_commit_root = 1;
+	}
+again:
+	ret = btrfs_search_slot(trans, root->fs_info->extent_root,
+				&key, path, 0, 0);
+	if (ret < 0)
+		goto out_free;
+
+	if (ret == 0) {
+		leaf = path->nodes[0];
+		item_size = btrfs_item_size_nr(leaf, path->slots[0]);
+		if (item_size >= sizeof(*ei)) {
+			ei = btrfs_item_ptr(leaf, path->slots[0],
+					    struct btrfs_extent_item);
+			num_refs = btrfs_extent_refs(leaf, ei);
+			extent_flags = btrfs_extent_flags(leaf, ei);
+		} else {
+#ifdef BTRFS_COMPAT_EXTENT_TREE_V0
+			struct btrfs_extent_item_v0 *ei0;
+			BUG_ON(item_size != sizeof(*ei0));
+			ei0 = btrfs_item_ptr(leaf, path->slots[0],
+					     struct btrfs_extent_item_v0);
+			num_refs = btrfs_extent_refs_v0(leaf, ei0);
+			/* FIXME: this isn't correct for data */
+			extent_flags = BTRFS_BLOCK_FLAG_FULL_BACKREF;
+#else
+			BUG();
+#endif
+		}
+		BUG_ON(num_refs == 0);
+	} else {
+		num_refs = 0;
+		extent_flags = 0;
+		ret = 0;
+	}
+
+	if (!trans)
+		goto out;
+
+	delayed_refs = &trans->transaction->delayed_refs;
+	spin_lock(&delayed_refs->lock);
+	head = btrfs_find_delayed_ref_head(trans, bytenr);
+	if (head) {
+		if (!mutex_trylock(&head->mutex)) {
+			atomic_inc(&head->node.refs);
+			spin_unlock(&delayed_refs->lock);
+
+			btrfs_release_path(root->fs_info->extent_root, path);
+
+			mutex_lock(&head->mutex);
+			mutex_unlock(&head->mutex);
+			btrfs_put_delayed_ref(&head->node);
+			goto again;
+		}
+		if (head->extent_op && head->extent_op->update_flags)
+			extent_flags |= head->extent_op->flags_to_set;
+		else
+			BUG_ON(num_refs == 0);
+
+		num_refs += head->node.ref_mod;
+		mutex_unlock(&head->mutex);
+	}
+	spin_unlock(&delayed_refs->lock);
+out:
+	WARN_ON(num_refs == 0);
+	if (refs)
+		*refs = num_refs;
+	if (flags)
+		*flags = extent_flags;
+out_free:
+	btrfs_free_path(path);
+	return ret;
+}
+
+/*
  * Back reference rules.  Back refs have three main goals:
  *
  * 1) differentiate between all holders of references to an extent so that
@@ -2948,113 +3055,6 @@ again:
 }
 
 /*
- * unreserve num_items number of items worth of metadata space.  This needs to
- * be paired with btrfs_reserve_metadata_space.
- *
- * NOTE: if you have the option, run this _AFTER_ you do a
- * btrfs_end_transaction, since btrfs_end_transaction will run delayed ref
- * oprations which will result in more used metadata, so we want to make sure we
- * can do that without issue.
- */
-int btrfs_unreserve_metadata_space(struct btrfs_root *root, int num_items)
-{
-	struct btrfs_fs_info *info = root->fs_info;
-	struct btrfs_space_info *meta_sinfo;
-	u64 num_bytes;
-	u64 alloc_target;
-	bool bug = false;
-
-	/* get the space info for where the metadata will live */
-	alloc_target = btrfs_get_alloc_profile(root, 0);
-	meta_sinfo = __find_space_info(info, alloc_target);
-
-	num_bytes = calculate_bytes_needed(root, num_items);
-
-	spin_lock(&meta_sinfo->lock);
-	if (meta_sinfo->bytes_may_use < num_bytes) {
-		bug = true;
-		meta_sinfo->bytes_may_use = 0;
-	} else {
-		meta_sinfo->bytes_may_use -= num_bytes;
-	}
-	spin_unlock(&meta_sinfo->lock);
-
-	BUG_ON(bug);
-
-	return 0;
-}
-
-/*
- * Reserve some metadata space for use.  We'll calculate the worste case number
- * of bytes that would be needed to modify num_items number of items.  If we
- * have space, fantastic, if not, you get -ENOSPC.  Please call
- * btrfs_unreserve_metadata_space when you are done for the _SAME_ number of
- * items you reserved, since whatever metadata you needed should have already
- * been allocated.
- *
- * This will commit the transaction to make more space if we don't have enough
- * metadata space.  THe only time we don't do this is if we're reserving space
- * inside of a transaction, then we will just return -ENOSPC and it is the
- * callers responsibility to handle it properly.
- */
-int btrfs_reserve_metadata_space(struct btrfs_root *root, int num_items)
-{
-	struct btrfs_fs_info *info = root->fs_info;
-	struct btrfs_space_info *meta_sinfo;
-	u64 num_bytes;
-	u64 used;
-	u64 alloc_target;
-	int retries = 0;
-
-	/* get the space info for where the metadata will live */
-	alloc_target = btrfs_get_alloc_profile(root, 0);
-	meta_sinfo = __find_space_info(info, alloc_target);
-
-	num_bytes = calculate_bytes_needed(root, num_items);
-again:
-	spin_lock(&meta_sinfo->lock);
-
-	if (unlikely(!meta_sinfo->bytes_root))
-		meta_sinfo->bytes_root = calculate_bytes_needed(root, 6);
-
-	if (!retries)
-		meta_sinfo->bytes_may_use += num_bytes;
-
-	used = meta_sinfo->bytes_used + meta_sinfo->bytes_reserved +
-		meta_sinfo->bytes_pinned + meta_sinfo->bytes_readonly +
-		meta_sinfo->bytes_super + meta_sinfo->bytes_root +
-		meta_sinfo->bytes_may_use + meta_sinfo->bytes_delalloc;
-
-	if (used > meta_sinfo->total_bytes) {
-		retries++;
-		if (retries == 1) {
-			if (maybe_allocate_chunk(NULL, root, meta_sinfo,
-						 num_bytes))
-				goto again;
-			retries++;
-		} else {
-			spin_unlock(&meta_sinfo->lock);
-		}
-
-		if (retries == 2) {
-			shrink_delalloc(NULL, root, meta_sinfo, num_bytes);
-			goto again;
-		}
-		spin_lock(&meta_sinfo->lock);
-		meta_sinfo->bytes_may_use -= num_bytes;
-		spin_unlock(&meta_sinfo->lock);
-
-		dump_space_info(meta_sinfo, 0, 0);
-		return -ENOSPC;
-	}
-
-	check_force_delalloc(meta_sinfo);
-	spin_unlock(&meta_sinfo->lock);
-
-	return 0;
-}
-
-/*
  * This will check the space that the inode allocates from to make sure we have
  * enough space for bytes.
  */
@@ -3094,9 +3094,9 @@ again:
 			spin_unlock(&data_sinfo->lock);
 alloc:
 			alloc_target = btrfs_get_alloc_profile(root, 1);
-			trans = btrfs_start_transaction(root, 1);
-			if (!trans)
-				return -ENOMEM;
+			trans = btrfs_join_transaction(root, 1);
+			if (IS_ERR(trans))
+				return PTR_ERR(trans);
 
 			ret = do_chunk_alloc(trans, root->fs_info->extent_root,
 					     bytes + 2 * 1024 * 1024,
@@ -3117,8 +3117,8 @@ alloc:
 		if (!committed && !root->fs_info->open_ioctl_trans) {
 			committed = 1;
 			trans = btrfs_join_transaction(root, 1);
-			if (!trans)
-				return -ENOMEM;
+			if (IS_ERR(trans))
+				return PTR_ERR(trans);
 			ret = btrfs_commit_transaction(trans, root);
 			if (ret)
 				return ret;
@@ -3700,6 +3700,59 @@ static void init_global_block_rsv(struct
 	fs_info->chunk_root->block_rsv = &fs_info->chunk_block_rsv;
 }
 
+static u64 calc_trans_metadata_size(struct btrfs_root *root, int num_items)
+{
+	return (root->leafsize + root->nodesize * (BTRFS_MAX_LEVEL - 1)) *
+		3 * num_items;
+}
+
+int btrfs_trans_reserve_metadata(struct btrfs_trans_handle *trans,
+				 struct btrfs_root *root,
+				 int num_items, int *retries)
+{
+	u64 num_bytes;
+	int ret;
+
+	if (num_items == 0 || root->fs_info->chunk_root == root)
+		return 0;
+
+	num_bytes = calc_trans_metadata_size(root, num_items);
+	ret = btrfs_block_rsv_add(trans, root, &root->fs_info->trans_block_rsv,
+				  num_bytes, retries);
+	if (!ret) {
+		trans->bytes_reserved += num_bytes;
+		trans->block_rsv = &root->fs_info->trans_block_rsv;
+	}
+	return ret;
+}
+
+void btrfs_trans_release_metadata(struct btrfs_trans_handle *trans,
+				  struct btrfs_root *root)
+{
+	if (!trans->bytes_reserved)
+		return;
+
+	BUG_ON(trans->block_rsv != &root->fs_info->trans_block_rsv);
+	btrfs_block_rsv_release(root, trans->block_rsv,
+				trans->bytes_reserved);
+	trans->bytes_reserved = 0;
+}
+
+int btrfs_snap_reserve_metadata(struct btrfs_trans_handle *trans,
+				struct btrfs_pending_snapshot *pending)
+{
+	struct btrfs_root *root = pending->root;
+	struct btrfs_block_rsv *src_rsv = get_block_rsv(trans, root);
+	struct btrfs_block_rsv *dst_rsv = &pending->block_rsv;
+	/*
+	 * two for root back/forward refs, two for directory entries
+	 * and one for root of the snapshot.
+	 */
+	u64 num_bytes = calc_trans_metadata_size(root, 5);
+	dst_rsv->space_info = src_rsv->space_info;
+	return block_rsv_migrate_bytes(src_rsv, dst_rsv, num_bytes);
+}
+
 static int update_block_group(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root,
 			      u64 bytenr, u64 num_bytes, int alloc)
@@ -5823,7 +5876,7 @@ int btrfs_drop_snapshot(struct btrfs_roo
 	wc = kzalloc(sizeof(*wc), GFP_NOFS);
 	BUG_ON(!wc);
 
-	trans = btrfs_start_transaction(tree_root, 1);
+	trans = btrfs_start_transaction(tree_root, 0);
 
 	if (btrfs_disk_key_objectid(&root_item->drop_progress) == 0) {
 		level = btrfs_header_level(root->node);
@@ -5919,7 +5972,9 @@ int btrfs_drop_snapshot(struct btrfs_roo
 			BUG_ON(ret);
 
 			btrfs_end_transaction(trans, tree_root);
-			trans = btrfs_start_transaction(tree_root, 1);
+			trans = btrfs_start_transaction(tree_root, 0);
+			if (IS_ERR(trans))
+				return PTR_ERR(trans);
 		} else {
 			unsigned long update;
 			update = trans->delayed_ref_updates;
diff -urp 2/fs/btrfs/file.c 3/fs/btrfs/file.c
--- 2/fs/btrfs/file.c	2010-04-26 17:25:43.079830335 +0800
+++ 3/fs/btrfs/file.c	2010-04-26 17:25:43.095105814 +0800
@@ -125,8 +125,7 @@ static noinline int dirty_and_release_pa
 	end_of_last_block = start_pos + num_bytes - 1;
 	err = btrfs_set_extent_delalloc(inode, start_pos, end_of_last_block,
 					NULL);
-	if (err)
-		return err;
+	BUG_ON(err);
 
 	for (i = 0; i < num_pages; i++) {
 		struct page *p = pages[i];
@@ -141,7 +140,7 @@ static noinline int dirty_and_release_pa
 		 * at this time.
 		 */
 	}
-	return err;
+	return 0;
 }
 
 /*
@@ -1007,7 +1006,7 @@ out_nolock:
 			num_written = err;
 
 		if ((file->f_flags & O_SYNC) || IS_SYNC(inode)) {
-			trans = btrfs_start_transaction(root, 1);
+			trans = btrfs_start_transaction(root, 0);
 			ret = btrfs_log_dentry_safe(trans, root,
 						    file->f_dentry);
 			if (ret == 0) {
@@ -1103,9 +1102,9 @@ int btrfs_sync_file(struct file *file, s
 	if (file && file->private_data)
 		btrfs_ioctl_trans_end(file);
 
-	trans = btrfs_start_transaction(root, 1);
-	if (!trans) {
-		ret = -ENOMEM;
+	trans = btrfs_start_transaction(root, 0);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
 		goto out;
 	}
 
diff -urp 2/fs/btrfs/inode.c 3/fs/btrfs/inode.c
--- 2/fs/btrfs/inode.c	2010-04-26 17:25:43.080830756 +0800
+++ 3/fs/btrfs/inode.c	2010-04-26 17:26:28.884834856 +0800
@@ -2134,7 +2134,7 @@ void btrfs_orphan_cleanup(struct btrfs_r
 		 * do a destroy_inode
 		 */
 		if (is_bad_inode(inode)) {
-			trans = btrfs_start_transaction(root, 1);
+			trans = btrfs_start_transaction(root, 0);
 			btrfs_orphan_del(trans, inode);
 			btrfs_end_transaction(trans, root);
 			iput(inode);
@@ -2477,44 +2477,217 @@ out:
 	return ret;
 }
 
-static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
+/* helper to check if there is any shared block in the path */
+static int check_path_shared(struct btrfs_root *root,
+			     struct btrfs_path *path)
+{
+	struct extent_buffer *eb;
+	int level;
+	int ret;
+	u64 refs;
+
+	for (level = 0; level < BTRFS_MAX_LEVEL; level++) {
+		if (!path->nodes[level])
+			break;
+		eb = path->nodes[level];
+		if (!btrfs_block_can_be_shared(root, eb))
+			continue;
+		ret = btrfs_lookup_extent_info(NULL, root, eb->start, eb->len,
+					       &refs, NULL);
+		if (refs > 1)
+			return 1;
+	}
+	return 0;
+}
+
+/*
+ * helper to start transaction for unlink and rmdir.
+ *
+ * unlink and rmdir are special in btrfs, they do not always free space.
+ * so in enospc case, we should make sure they will free space before
+ * allowing them to use the global metadata reservation.
+ */
+static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir,
+						       struct dentry *dentry)
 {
-	struct btrfs_root *root;
 	struct btrfs_trans_handle *trans;
+	struct btrfs_root *root = BTRFS_I(dir)->root;
+	struct btrfs_path *path;
+	struct btrfs_inode_ref *ref;
+	struct btrfs_dir_item *di;
 	struct inode *inode = dentry->d_inode;
+	u64 index;
+	int check_link = 1;
+	int err = -ENOSPC;
 	int ret;
-	unsigned long nr = 0;
 
-	root = BTRFS_I(dir)->root;
+	trans = btrfs_start_transaction(root, 10);
+	if (!IS_ERR(trans) || PTR_ERR(trans) != -ENOSPC)
+		return trans;
 
-	/*
-	 * 5 items for unlink inode
-	 * 1 for orphan
-	 */
-	ret = btrfs_reserve_metadata_space(root, 6);
-	if (ret)
-		return ret;
+	if (inode->i_ino == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)
+		return ERR_PTR(-ENOSPC);
 
-	trans = btrfs_start_transaction(root, 1);
+	/* check if there is someone else holds reference */
+	if (S_ISDIR(inode->i_mode) && atomic_read(&inode->i_count) > 1)
+		return ERR_PTR(-ENOSPC);
+
+	if (atomic_read(&inode->i_count) > 2)
+		return ERR_PTR(-ENOSPC);
+
+	if (xchg(&root->fs_info->enospc_unlink, 1))
+		return ERR_PTR(-ENOSPC);
+
+	path = btrfs_alloc_path();
+	if (!path) {
+		root->fs_info->enospc_unlink = 0;
+		return ERR_PTR(-ENOMEM);
+	}
+
+	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
-		btrfs_unreserve_metadata_space(root, 6);
-		return PTR_ERR(trans);
+		btrfs_free_path(path);
+		root->fs_info->enospc_unlink = 0;
+		return trans;
+	}
+
+	path->skip_locking = 1;
+	path->search_commit_root = 1;
+
+	ret = btrfs_lookup_inode(trans, root, path,
+				&BTRFS_I(dir)->location, 0);
+	if (ret < 0) {
+		err = ret;
+		goto out;
+	}
+	if (ret == 0) {
+		if (check_path_shared(root, path))
+			goto out;
+	} else {
+		check_link = 0;
+	}
+	btrfs_release_path(root, path);
+
+	ret = btrfs_lookup_inode(trans, root, path,
+				&BTRFS_I(inode)->location, 0);
+	if (ret < 0) {
+		err = ret;
+		goto out;
+	}
+	if (ret == 0) {
+		if (check_path_shared(root, path))
+			goto out;
+	} else {
+		check_link = 0;
+	}
+	btrfs_release_path(root, path);
+
+	if (ret == 0 && S_ISREG(inode->i_mode)) {
+		ret = btrfs_lookup_file_extent(trans, root, path,
+					       inode->i_ino, (u64)-1, 0);
+		if (ret < 0) {
+			err = ret;
+			goto out;
+		}
+		BUG_ON(ret == 0);
+		if (check_path_shared(root, path))
+			goto out;
+		btrfs_release_path(root, path);
+	}
+
+	if (!check_link) {
+		err = 0;
+		goto out;
+	}
+
+	di = btrfs_lookup_dir_item(trans, root, path, dir->i_ino,
+				dentry->d_name.name, dentry->d_name.len, 0);
+	if (IS_ERR(di)) {
+		err = PTR_ERR(di);
+		goto out;
+	}
+	if (di) {
+		if (check_path_shared(root, path))
+			goto out;
+	} else {
+		err = 0;
+		goto out;
+	}
+	btrfs_release_path(root, path);
+
+	ref = btrfs_lookup_inode_ref(trans, root, path,
+				dentry->d_name.name, dentry->d_name.len,
+				inode->i_ino, dir->i_ino, 0);
+	if (IS_ERR(ref)) {
+		err = PTR_ERR(ref);
+		goto out;
+	}
+	BUG_ON(!ref);
+	if (check_path_shared(root, path))
+		goto out;
+	index = btrfs_inode_ref_index(path->nodes[0], ref);
+	btrfs_release_path(root, path);
+
+	di = btrfs_lookup_dir_index_item(trans, root, path, dir->i_ino, index,
+				dentry->d_name.name, dentry->d_name.len, 0);
+	if (IS_ERR(di)) {
+		err = PTR_ERR(di);
+		goto out;
+	}
+	BUG_ON(ret == -ENOENT);
+	if (check_path_shared(root, path))
+		goto out;
+
+	err = 0;
+out:
+	btrfs_free_path(path);
+	if (err) {
+		btrfs_end_transaction(trans, root);
+		root->fs_info->enospc_unlink = 0;
+		return ERR_PTR(err);
 	}
 
+	trans->block_rsv = &root->fs_info->global_block_rsv;
+	return trans;
+}
+
+static void __unlink_end_trans(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *root)
+{
+	if (trans->block_rsv == &root->fs_info->global_block_rsv) {
+		BUG_ON(!root->fs_info->enospc_unlink);
+		root->fs_info->enospc_unlink = 0;
+	}
+	btrfs_end_transaction_throttle(trans, root);
+}
+
+static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
+{
+	struct btrfs_root *root = BTRFS_I(dir)->root;
+	struct btrfs_trans_handle *trans;
+	struct inode *inode = dentry->d_inode;
+	int ret;
+	unsigned long nr = 0;
+
+	trans = __unlink_start_trans(dir, dentry);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
 	btrfs_set_trans_block_group(trans, dir);
 
 	btrfs_record_unlink_dir(trans, dir, dentry->d_inode, 0);
 
 	ret = btrfs_unlink_inode(trans, root, dir, dentry->d_inode,
 				 dentry->d_name.name, dentry->d_name.len);
+	BUG_ON(ret);
 
-	if (inode->i_nlink == 0)
+	if (inode->i_nlink == 0) {
 		ret = btrfs_orphan_add(trans, inode);
+		BUG_ON(ret);
+	}
 
 	nr = trans->blocks_used;
-
-	btrfs_end_transaction_throttle(trans, root);
-	btrfs_unreserve_metadata_space(root, 6);
+	__unlink_end_trans(trans, root);
 	btrfs_btree_balance_dirty(root, nr);
 	return ret;
 }
@@ -2586,7 +2759,6 @@ static int btrfs_rmdir(struct inode *dir
 {
 	struct inode *inode = dentry->d_inode;
 	int err = 0;
-	int ret;
 	struct btrfs_root *root = BTRFS_I(dir)->root;
 	struct btrfs_trans_handle *trans;
 	unsigned long nr = 0;
@@ -2595,15 +2767,9 @@ static int btrfs_rmdir(struct inode *dir
 	    inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)
 		return -ENOTEMPTY;
 
-	ret = btrfs_reserve_metadata_space(root, 5);
-	if (ret)
-		return ret;
-
-	trans = btrfs_start_transaction(root, 1);
-	if (IS_ERR(trans)) {
-		btrfs_unreserve_metadata_space(root, 5);
+	trans = __unlink_start_trans(dir, dentry);
+	if (IS_ERR(trans))
 		return PTR_ERR(trans);
-	}
 
 	btrfs_set_trans_block_group(trans, dir);
 
@@ -2626,12 +2792,9 @@ static int btrfs_rmdir(struct inode *dir
 		btrfs_i_size_write(inode, 0);
 out:
 	nr = trans->blocks_used;
-	ret = btrfs_end_transaction_throttle(trans, root);
-	btrfs_unreserve_metadata_space(root, 5);
+	__unlink_end_trans(trans, root);
 	btrfs_btree_balance_dirty(root, nr);
 
-	if (ret && !err)
-		err = ret;
 	return err;
 }
 
@@ -3144,7 +3307,7 @@ int btrfs_cont_expand(struct inode *inod
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
-	struct extent_map *em;
+	struct extent_map *em = NULL;
 	struct extent_state *cached_state = NULL;
 	u64 mask = root->sectorsize - 1;
 	u64 hole_start = (inode->i_size + mask) & ~mask;
@@ -3182,11 +3345,11 @@ int btrfs_cont_expand(struct inode *inod
 			u64 hint_byte = 0;
 			hole_size = last_byte - cur_offset;
 
-			err = btrfs_reserve_metadata_space(root, 2);
-			if (err)
+			trans = btrfs_start_transaction(root, 2);
+			if (IS_ERR(trans)) {
+				err = PTR_ERR(trans);
 				break;
-
-			trans = btrfs_start_transaction(root, 1);
+			}
 			btrfs_set_trans_block_group(trans, inode);
 
 			err = btrfs_drop_extents(trans, inode, cur_offset,
@@ -3204,14 +3367,15 @@ int btrfs_cont_expand(struct inode *inod
 					last_byte - 1, 0);
 
 			btrfs_end_transaction(trans, root);
-			btrfs_unreserve_metadata_space(root, 2);
 		}
 		free_extent_map(em);
+		em = NULL;
 		cur_offset = last_byte;
 		if (cur_offset >= block_end)
 			break;
 	}
 
+	free_extent_map(em);
 	unlock_extent_cached(io_tree, hole_start, block_end - 1, &cached_state,
 			     GFP_NOFS);
 	return err;
@@ -3238,10 +3402,6 @@ static int btrfs_setattr_size(struct ino
 		}
 	}
 
-	ret = btrfs_reserve_metadata_space(root, 1);
-	if (ret)
-		return ret;
-
 	trans = btrfs_start_transaction(root, 1);
 	btrfs_set_trans_block_group(trans, inode);
 
@@ -3250,7 +3410,6 @@ static int btrfs_setattr_size(struct ino
 
 	nr = trans->blocks_used;
 	btrfs_end_transaction(trans, root);
-	btrfs_unreserve_metadata_space(root, 1);
 	btrfs_btree_balance_dirty(root, nr);
 
 	if (attr->ia_size > inode->i_size) {
@@ -4222,26 +4381,21 @@ static int btrfs_mknod(struct inode *dir
 	if (!new_valid_dev(rdev))
 		return -EINVAL;
 
+	err = btrfs_find_free_objectid(NULL, root, dir->i_ino, &objectid);
+	if (err)
+		return err;
+
 	/*
 	 * 2 for inode item and ref
 	 * 2 for dir items
 	 * 1 for xattr if selinux is on
 	 */
-	err = btrfs_reserve_metadata_space(root, 5);
-	if (err)
-		return err;
+	trans = btrfs_start_transaction(root, 5);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 
-	trans = btrfs_start_transaction(root, 1);
-	if (!trans)
-		goto fail;
 	btrfs_set_trans_block_group(trans, dir);
 
-	err = btrfs_find_free_objectid(trans, root, dir->i_ino, &objectid);
-	if (err) {
-		err = -ENOSPC;
-		goto out_unlock;
-	}
-
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
 				dentry->d_name.len,
 				dentry->d_parent->d_inode->i_ino, objectid,
@@ -4270,13 +4424,11 @@ static int btrfs_mknod(struct inode *dir
 out_unlock:
 	nr = trans->blocks_used;
 	btrfs_end_transaction_throttle(trans, root);
-fail:
-	btrfs_unreserve_metadata_space(root, 5);
+	btrfs_btree_balance_dirty(root, nr);
 	if (drop_inode) {
 		inode_dec_link_count(inode);
 		iput(inode);
 	}
-	btrfs_btree_balance_dirty(root, nr);
 	return err;
 }
 
@@ -4286,32 +4438,26 @@ static int btrfs_create(struct inode *di
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = BTRFS_I(dir)->root;
 	struct inode *inode = NULL;
-	int err;
 	int drop_inode = 0;
+	int err;
 	unsigned long nr = 0;
 	u64 objectid;
 	u64 index = 0;
 
+	err = btrfs_find_free_objectid(NULL, root, dir->i_ino, &objectid);
+	if (err)
+		return err;
 	/*
 	 * 2 for inode item and ref
 	 * 2 for dir items
 	 * 1 for xattr if selinux is on
 	 */
-	err = btrfs_reserve_metadata_space(root, 5);
-	if (err)
-		return err;
+	trans = btrfs_start_transaction(root, 5);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 
-	trans = btrfs_start_transaction(root, 1);
-	if (!trans)
-		goto fail;
 	btrfs_set_trans_block_group(trans, dir);
 
-	err = btrfs_find_free_objectid(trans, root, dir->i_ino, &objectid);
-	if (err) {
-		err = -ENOSPC;
-		goto out_unlock;
-	}
-
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
 				dentry->d_name.len,
 				dentry->d_parent->d_inode->i_ino,
@@ -4343,8 +4489,6 @@ static int btrfs_create(struct inode *di
 out_unlock:
 	nr = trans->blocks_used;
 	btrfs_end_transaction_throttle(trans, root);
-fail:
-	btrfs_unreserve_metadata_space(root, 5);
 	if (drop_inode) {
 		inode_dec_link_count(inode);
 		iput(inode);
@@ -4371,21 +4515,21 @@ static int btrfs_link(struct dentry *old
 	if (root->objectid != BTRFS_I(inode)->root->objectid)
 		return -EPERM;
 
-	/*
-	 * 1 item for inode ref
-	 * 2 items for dir items
-	 */
-	err = btrfs_reserve_metadata_space(root, 3);
-	if (err)
-		return err;
-
 	btrfs_inc_nlink(inode);
 
 	err = btrfs_set_inode_index(dir, &index);
 	if (err)
 		goto fail;
 
-	trans = btrfs_start_transaction(root, 1);
+	/*
+	 * 1 item for inode ref
+	 * 2 items for dir items
+	 */
+	trans = btrfs_start_transaction(root, 3);
+	if (IS_ERR(trans)) {
+		err = PTR_ERR(trans);
+		goto fail;
+	}
 
 	btrfs_set_trans_block_group(trans, dir);
 	atomic_inc(&inode->i_count);
@@ -4404,7 +4548,6 @@ static int btrfs_link(struct dentry *old
 	nr = trans->blocks_used;
 	btrfs_end_transaction_throttle(trans, root);
 fail:
-	btrfs_unreserve_metadata_space(root, 3);
 	if (drop_inode) {
 		inode_dec_link_count(inode);
 		iput(inode);
@@ -4424,28 +4567,20 @@ static int btrfs_mkdir(struct inode *dir
 	u64 index = 0;
 	unsigned long nr = 1;
 
+	err = btrfs_find_free_objectid(NULL, root, dir->i_ino, &objectid);
+	if (err)
+		return err;
+
 	/*
 	 * 2 items for inode and ref
 	 * 2 items for dir items
 	 * 1 for xattr if selinux is on
 	 */
-	err = btrfs_reserve_metadata_space(root, 5);
-	if (err)
-		return err;
-
-	trans = btrfs_start_transaction(root, 1);
-	if (!trans) {
-		err = -ENOMEM;
-		goto out_unlock;
-	}
+	trans = btrfs_start_transaction(root, 5);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 	btrfs_set_trans_block_group(trans, dir);
 
-	err = btrfs_find_free_objectid(trans, root, dir->i_ino, &objectid);
-	if (err) {
-		err = -ENOSPC;
-		goto out_fail;
-	}
-
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
 				dentry->d_name.len,
 				dentry->d_parent->d_inode->i_ino, objectid,
@@ -4485,9 +4620,6 @@ static int btrfs_mkdir(struct inode *dir
 out_fail:
 	nr = trans->blocks_used;
 	btrfs_end_transaction_throttle(trans, root);
-
-out_unlock:
-	btrfs_unreserve_metadata_space(root, 5);
 	if (drop_on_err)
 		iput(inode);
 	btrfs_btree_balance_dirty(root, nr);
@@ -5425,19 +5557,6 @@ static int btrfs_rename(struct inode *ol
 	if (S_ISDIR(old_inode->i_mode) && new_inode &&
 	    new_inode->i_size > BTRFS_EMPTY_DIR_SIZE)
 		return -ENOTEMPTY;
-
-	/*
-	 * We want to reserve the absolute worst case amount of items.  So if
-	 * both inodes are subvols and we need to unlink them then that would
-	 * require 4 item modifications, but if they are both normal inodes it
-	 * would require 5 item modifications, so we'll assume their normal
-	 * inodes.  So 5 * 2 is 10, plus 1 for the new link, so 11 total items
-	 * should cover the worst case number of items we'll modify.
-	 */
-	ret = btrfs_reserve_metadata_space(root, 11);
-	if (ret)
-		return ret;
-
 	/*
 	 * we're using rename to replace one file with another.
 	 * and the replacement file is large.  Start IO on it now so
@@ -5450,8 +5569,18 @@ static int btrfs_rename(struct inode *ol
 	/* close the racy window with snapshot create/destroy ioctl */
 	if (old_inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)
 		down_read(&root->fs_info->subvol_sem);
+	/*
+	 * We want to reserve the absolute worst case amount of items.  So if
+	 * both inodes are subvols and we need to unlink them then that would
+	 * require 4 item modifications, but if they are both normal inodes it
+	 * would require 5 item modifications, so we'll assume their normal
+	 * inodes.  So 5 * 2 is 10, plus 1 for the new link, so 11 total items
+	 * should cover the worst case number of items we'll modify.
+	 */
+	trans = btrfs_start_transaction(root, 20);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 
-	trans = btrfs_start_transaction(root, 1);
 	btrfs_set_trans_block_group(trans, new_dir);
 
 	if (dest != root)
@@ -5550,7 +5679,6 @@ out_fail:
 	if (old_inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)
 		up_read(&root->fs_info->subvol_sem);
 
-	btrfs_unreserve_metadata_space(root, 11);
 	return ret;
 }
 
@@ -5657,26 +5785,20 @@ static int btrfs_symlink(struct inode *d
 	if (name_len > BTRFS_MAX_INLINE_DATA_SIZE(root))
 		return -ENAMETOOLONG;
 
+	err = btrfs_find_free_objectid(NULL, root, dir->i_ino, &objectid);
+	if (err)
+		return err;
 	/*
 	 * 2 items for inode item and ref
 	 * 2 items for dir items
 	 * 1 item for xattr if selinux is on
 	 */
-	err = btrfs_reserve_metadata_space(root, 5);
-	if (err)
-		return err;
+	trans = btrfs_start_transaction(root, 5);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 
-	trans = btrfs_start_transaction(root, 1);
-	if (!trans)
-		goto out_fail;
 	btrfs_set_trans_block_group(trans, dir);
 
-	err = btrfs_find_free_objectid(trans, root, dir->i_ino, &objectid);
-	if (err) {
-		err = -ENOSPC;
-		goto out_unlock;
-	}
-
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
 				dentry->d_name.len,
 				dentry->d_parent->d_inode->i_ino, objectid,
@@ -5748,8 +5870,6 @@ static int btrfs_symlink(struct inode *d
 out_unlock:
 	nr = trans->blocks_used;
 	btrfs_end_transaction_throttle(trans, root);
-out_fail:
-	btrfs_unreserve_metadata_space(root, 5);
 	if (drop_inode) {
 		inode_dec_link_count(inode);
 		iput(inode);
@@ -5770,21 +5890,18 @@ static int prealloc_file_range(struct in
 	u64 i_size;
 
 	while (num_bytes > 0) {
-		trans = btrfs_start_transaction(root, 1);
+		trans = btrfs_start_transaction(root, 3);
+		if (IS_ERR(trans)) {
+			ret = PTR_ERR(trans);
+			break;
+		}
 
 		ret = btrfs_reserve_extent(trans, root, num_bytes,
 					   root->sectorsize, 0, alloc_hint,
 					   (u64)-1, &ins, 1);
 		if (ret) {
-			WARN_ON(1);
-			goto stop_trans;
-		}
-
-		ret = btrfs_reserve_metadata_space(root, 3);
-		if (ret) {
-			btrfs_free_reserved_extent(root, ins.objectid,
-						   ins.offset);
-			goto stop_trans;
+			btrfs_end_transaction(trans, root);
+			break;
 		}
 
 		ret = insert_reserved_file_extent(trans, inode,
@@ -5818,14 +5935,8 @@ static int prealloc_file_range(struct in
 		BUG_ON(ret);
 
 		btrfs_end_transaction(trans, root);
-		btrfs_unreserve_metadata_space(root, 3);
 	}
 	return ret;
-
-stop_trans:
-	btrfs_end_transaction(trans, root);
-	return ret;
-
 }
 
 static long btrfs_fallocate(struct inode *inode, int mode,
diff -urp 2/fs/btrfs/inode-item.c 3/fs/btrfs/inode-item.c
--- 2/fs/btrfs/inode-item.c	2010-04-26 17:25:43.084829085 +0800
+++ 3/fs/btrfs/inode-item.c	2010-04-26 17:25:43.098110567 +0800
@@ -49,6 +49,33 @@ static int find_name_in_backref(struct b
 	return 0;
 }
 
+struct btrfs_inode_ref *
+btrfs_lookup_inode_ref(struct btrfs_trans_handle *trans,
+			struct btrfs_root *root,
+			struct btrfs_path *path,
+			const char *name, int name_len,
+			u64 inode_objectid, u64 ref_objectid, int mod)
+{
+	struct btrfs_key key;
+	struct btrfs_inode_ref *ref;
+	int ins_len = mod < 0 ? -1 : 0;
+	int cow = mod != 0;
+	int ret;
+
+	key.objectid = inode_objectid;
+	key.type = BTRFS_INODE_REF_KEY;
+	key.offset = ref_objectid;
+
+	ret = btrfs_search_slot(trans, root, &key, path, ins_len, cow);
+	if (ret < 0)
+		return ERR_PTR(ret);
+	if (ret > 0)
+		return NULL;
+	if (!find_name_in_backref(path, name, name_len, &ref))
+		return NULL;
+	return ref;
+}
+
 int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   const char *name, int name_len,
diff -urp 2/fs/btrfs/ioctl.c 3/fs/btrfs/ioctl.c
--- 2/fs/btrfs/ioctl.c	2010-04-26 17:25:43.077830472 +0800
+++ 3/fs/btrfs/ioctl.c	2010-04-26 17:26:39.543082296 +0800
@@ -238,23 +238,19 @@ static noinline int create_subvol(struct
 	u64 new_dirid = BTRFS_FIRST_FREE_OBJECTID;
 	u64 index = 0;
 
+	ret = btrfs_find_free_objectid(NULL, root->fs_info->tree_root,
+				       0, &objectid);
+	if (ret)
+		return ret;
 	/*
 	 * 1 - inode item
 	 * 2 - refs
 	 * 1 - root item
 	 * 2 - dir items
 	 */
-	ret = btrfs_reserve_metadata_space(root, 6);
-	if (ret)
-		return ret;
-
-	trans = btrfs_start_transaction(root, 1);
-	BUG_ON(!trans);
-
-	ret = btrfs_find_free_objectid(trans, root->fs_info->tree_root,
-				       0, &objectid);
-	if (ret)
-		goto fail;
+	trans = btrfs_start_transaction(root, 6);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 
 	leaf = btrfs_alloc_free_block(trans, root, root->leafsize,
 				      0, objectid, NULL, 0, 0, 0);
@@ -344,13 +340,10 @@ fail:
 	err = btrfs_commit_transaction(trans, root);
 	if (err && !ret)
 		ret = err;
-
-	btrfs_unreserve_metadata_space(root, 6);
 	return ret;
 }
 
-static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
-			   char *name, int namelen)
+static int create_snapshot(struct btrfs_root *root, struct dentry *dentry)
 {
 	struct inode *inode;
 	struct btrfs_pending_snapshot *pending_snapshot;
@@ -360,40 +353,33 @@ static int create_snapshot(struct btrfs_
 	if (!root->ref_cows)
 		return -EINVAL;
 
-	/*
-	 * 1 - inode item
-	 * 2 - refs
-	 * 1 - root item
-	 * 2 - dir items
-	 */
-	ret = btrfs_reserve_metadata_space(root, 6);
-	if (ret)
-		goto fail;
-
 	pending_snapshot = kzalloc(sizeof(*pending_snapshot), GFP_NOFS);
-	if (!pending_snapshot) {
-		ret = -ENOMEM;
-		btrfs_unreserve_metadata_space(root, 6);
-		goto fail;
-	}
-	pending_snapshot->name = kmalloc(namelen + 1, GFP_NOFS);
-	if (!pending_snapshot->name) {
-		ret = -ENOMEM;
-		kfree(pending_snapshot);
-		btrfs_unreserve_metadata_space(root, 6);
-		goto fail;
-	}
-	memcpy(pending_snapshot->name, name, namelen);
-	pending_snapshot->name[namelen] = '\0';
+	if (!pending_snapshot)
+		return -ENOMEM;
+
+	btrfs_init_block_rsv(&pending_snapshot->block_rsv);
 	pending_snapshot->dentry = dentry;
-	trans = btrfs_start_transaction(root, 1);
-	BUG_ON(!trans);
 	pending_snapshot->root = root;
+
+	trans = btrfs_start_transaction(root->fs_info->extent_root, 5);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto fail;
+	}
+
+	ret = btrfs_snap_reserve_metadata(trans, pending_snapshot);
+	BUG_ON(ret);
+
 	list_add(&pending_snapshot->list,
 		 &trans->transaction->pending_snapshots);
-	ret = btrfs_commit_transaction(trans, root);
+	ret = btrfs_commit_transaction(trans, root->fs_info->extent_root);
 	BUG_ON(ret);
-	btrfs_unreserve_metadata_space(root, 6);
+
+	ret = pending_snapshot->error;
+	if (ret)
+		goto fail;
+
+	btrfs_orphan_cleanup(pending_snapshot->snap);
 
 	inode = btrfs_lookup_dentry(dentry->d_parent->d_inode, dentry);
 	if (IS_ERR(inode)) {
@@ -404,6 +390,7 @@ static int create_snapshot(struct btrfs_
 	d_instantiate(dentry, inode);
 	ret = 0;
 fail:
+	kfree(pending_snapshot);
 	return ret;
 }
 
@@ -455,8 +442,7 @@ static noinline int btrfs_mksubvol(struc
 		goto out_up_read;
 
 	if (snap_src) {
-		error = create_snapshot(snap_src, dentry,
-					name, namelen);
+		error = create_snapshot(snap_src, dentry);
 	} else {
 		error = create_subvol(BTRFS_I(dir)->root, dentry,
 				      name, namelen);
@@ -810,7 +796,7 @@ static noinline int btrfs_ioctl_resize(s
 		device->name, (unsigned long long)new_size);
 
 	if (new_size > old_size) {
-		trans = btrfs_start_transaction(root, 1);
+		trans = btrfs_start_transaction(root, 0);
 		ret = btrfs_grow_device(trans, device, new_size);
 		btrfs_commit_transaction(trans, root);
 	} else {
@@ -1299,7 +1285,13 @@ static noinline int btrfs_ioctl_snap_des
 	if (err)
 		goto out_up_write;
 
-	trans = btrfs_start_transaction(root, 1);
+	trans = btrfs_start_transaction(root, 0);
+	if (IS_ERR(trans)) {
+		err = PTR_ERR(trans);
+		goto out;
+	}
+	trans->block_rsv = &root->fs_info->global_block_rsv;
+
 	ret = btrfs_unlink_subvol(trans, root, dir,
 				dest->root_key.objectid,
 				dentry->d_name.name,
@@ -1544,12 +1536,6 @@ static noinline long btrfs_ioctl_clone(s
 		btrfs_wait_ordered_range(src, off, off+len);
 	}
 
-	trans = btrfs_start_transaction(root, 1);
-	BUG_ON(!trans);
-
-	/* punch hole in destination first */
-	btrfs_drop_extents(trans, inode, off, off + len, &hint_byte, 1);
-
 	/* clone data */
 	key.objectid = src->i_ino;
 	key.type = BTRFS_EXTENT_DATA_KEY;
@@ -1560,7 +1546,7 @@ static noinline long btrfs_ioctl_clone(s
 		 * note the key will change type as we walk through the
 		 * tree.
 		 */
-		ret = btrfs_search_slot(trans, root, &key, path, 0, 0);
+		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 		if (ret < 0)
 			goto out;
 
@@ -1623,12 +1609,31 @@ static noinline long btrfs_ioctl_clone(s
 			new_key.objectid = inode->i_ino;
 			new_key.offset = key.offset + destoff - off;
 
+			trans = btrfs_start_transaction(root, 1);
+			if (IS_ERR(trans)) {
+				ret = PTR_ERR(trans);
+				goto out;
+			}
+
 			if (type == BTRFS_FILE_EXTENT_REG ||
 			    type == BTRFS_FILE_EXTENT_PREALLOC) {
+				if (off > key.offset) {
+					datao += off - key.offset;
+					datal -= off - key.offset;
+				}
+
+				if (key.offset + datal > off + len)
+					datal = off + len - key.offset;
+
+				ret = btrfs_drop_extents(trans, inode,
+							 new_key.offset,
+							 new_key.offset + datal,
+							 &hint_byte, 1);
+				BUG_ON(ret);
+
 				ret = btrfs_insert_empty_item(trans, root, path,
 							      &new_key, size);
-				if (ret)
-					goto out;
+				BUG_ON(ret);
 
 				leaf = path->nodes[0];
 				slot = path->slots[0];
@@ -1639,14 +1644,6 @@ static noinline long btrfs_ioctl_clone(s
 				extent = btrfs_item_ptr(leaf, slot,
 						struct btrfs_file_extent_item);
 
-				if (off > key.offset) {
-					datao += off - key.offset;
-					datal -= off - key.offset;
-				}
-
-				if (key.offset + datal > off + len)
-					datal = off + len - key.offset;
-
 				/* disko == 0 means it's a hole */
 				if (!disko)
 					datao = 0;
@@ -1677,14 +1674,21 @@ static noinline long btrfs_ioctl_clone(s
 
 				if (comp && (skip || trim)) {
 					ret = -EINVAL;
+					btrfs_end_transaction(trans, root);
 					goto out;
 				}
 				size -= skip + trim;
 				datal -= skip + trim;
+
+				ret = btrfs_drop_extents(trans, inode,
+							 new_key.offset,
+							 new_key.offset + datal,
+							 &hint_byte, 1);
+				BUG_ON(ret);
+
 				ret = btrfs_insert_empty_item(trans, root, path,
 							      &new_key, size);
-				if (ret)
-					goto out;
+				BUG_ON(ret);
 
 				if (skip) {
 					u32 start =
@@ -1702,8 +1706,17 @@ static noinline long btrfs_ioctl_clone(s
 			}
 
 			btrfs_mark_buffer_dirty(leaf);
-		}
+			btrfs_release_path(root, path);
 
+			inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+			if (new_key.offset + datal > inode->i_size)
+				btrfs_i_size_write(inode,
+						   new_key.offset + datal);
+			BTRFS_I(inode)->flags = BTRFS_I(src)->flags;
+			ret = btrfs_update_inode(trans, root, inode);
+			BUG_ON(ret);
+			btrfs_end_transaction(trans, root);
+		}
 next:
 		btrfs_release_path(root, path);
 		key.offset++;
@@ -1711,17 +1724,7 @@ next:
 	ret = 0;
 out:
 	btrfs_release_path(root, path);
-	if (ret == 0) {
-		inode->i_mtime = inode->i_ctime = CURRENT_TIME;
-		if (destoff + olen > inode->i_size)
-			btrfs_i_size_write(inode, destoff + olen);
-		BTRFS_I(inode)->flags = BTRFS_I(src)->flags;
-		ret = btrfs_update_inode(trans, root, inode);
-	}
-	btrfs_end_transaction(trans, root);
 	unlock_extent(&BTRFS_I(src)->io_tree, off, off+len, GFP_NOFS);
-	if (ret)
-		vmtruncate(inode, 0);
 out_unlock:
 	mutex_unlock(&src->i_mutex);
 	mutex_unlock(&inode->i_mutex);
diff -urp 2/fs/btrfs/relocation.c 3/fs/btrfs/relocation.c
--- 2/fs/btrfs/relocation.c	2010-04-26 17:25:43.083829363 +0800
+++ 3/fs/btrfs/relocation.c	2010-04-26 17:25:43.099100581 +0800
@@ -1648,7 +1648,7 @@ static noinline_for_stack int merge_relo
 	}
 
 	if (level == 0 && rc->stage == UPDATE_DATA_PTRS) {
-		trans = btrfs_start_transaction(root, 1);
+		trans = btrfs_start_transaction(root, 0);
 
 		leaf = path->nodes[0];
 		btrfs_item_key_to_cpu(leaf, &key, 0);
@@ -1674,7 +1674,7 @@ static noinline_for_stack int merge_relo
 	while (1) {
 		leaf = NULL;
 		replaced = 0;
-		trans = btrfs_start_transaction(root, 1);
+		trans = btrfs_start_transaction(root, 0);
 		max_level = level;
 
 		ret = walk_down_reloc_tree(reloc_root, path, &level);
@@ -1802,7 +1802,7 @@ static void merge_func(struct btrfs_work
 
 		merge_reloc_root(async->rc, root);
 
-		trans = btrfs_start_transaction(root, 1);
+		trans = btrfs_start_transaction(root, 0);
 		btrfs_update_reloc_root(trans, root);
 		btrfs_end_transaction(trans, root);
 	}
@@ -3296,11 +3296,11 @@ static noinline_for_stack int relocate_b
 	rc->create_reloc_root = 1;
 	set_reloc_control(rc);
 
-	trans = btrfs_start_transaction(rc->extent_root, 1);
+	trans = btrfs_join_transaction(rc->extent_root, 1);
 	btrfs_commit_transaction(trans, rc->extent_root);
 
 	while (1) {
-		trans = btrfs_start_transaction(rc->extent_root, 1);
+		trans = btrfs_start_transaction(rc->extent_root, 0);
 
 		ret = find_next_extent(trans, rc, path);
 		if (ret < 0)
@@ -3410,7 +3410,7 @@ static noinline_for_stack int relocate_b
 	smp_mb();
 
 	if (rc->extents_found > 0) {
-		trans = btrfs_start_transaction(rc->extent_root, 1);
+		trans = btrfs_join_transaction(rc->extent_root, 1);
 		btrfs_commit_transaction(trans, rc->extent_root);
 	}
 
@@ -3419,7 +3419,7 @@ static noinline_for_stack int relocate_b
 	unset_reloc_control(rc);
 
 	/* get rid of pinned extents */
-	trans = btrfs_start_transaction(rc->extent_root, 1);
+	trans = btrfs_join_transaction(rc->extent_root, 1);
 	btrfs_commit_transaction(trans, rc->extent_root);
 
 	return err;
@@ -3474,7 +3474,7 @@ static struct inode *create_reloc_inode(
 	if (IS_ERR(root))
 		return ERR_CAST(root);
 
-	trans = btrfs_start_transaction(root, 1);
+	trans = btrfs_start_transaction(root, 6);
 	BUG_ON(!trans);
 
 	err = btrfs_find_free_objectid(trans, root, objectid, &objectid);
@@ -3618,7 +3618,7 @@ static noinline_for_stack int mark_garba
 	struct btrfs_trans_handle *trans;
 	int ret;
 
-	trans = btrfs_start_transaction(root->fs_info->tree_root, 1);
+	trans = btrfs_start_transaction(root->fs_info->tree_root, 0);
 
 	memset(&root->root_item.drop_progress, 0,
 		sizeof(root->root_item.drop_progress));
diff -urp 2/fs/btrfs/super.c 3/fs/btrfs/super.c
--- 2/fs/btrfs/super.c	2010-04-26 17:25:43.082830549 +0800
+++ 3/fs/btrfs/super.c	2010-04-26 17:25:43.100110640 +0800
@@ -497,7 +497,7 @@ int btrfs_sync_fs(struct super_block *sb
 	btrfs_start_delalloc_inodes(root, 0);
 	btrfs_wait_ordered_extents(root, 0, 0);
 
-	trans = btrfs_start_transaction(root, 1);
+	trans = btrfs_start_transaction(root, 0);
 	ret = btrfs_commit_transaction(trans, root);
 	return ret;
 }
diff -urp 2/fs/btrfs/transaction.c 3/fs/btrfs/transaction.c
--- 2/fs/btrfs/transaction.c	2010-04-26 17:25:43.077830472 +0800
+++ 3/fs/btrfs/transaction.c	2010-04-26 17:25:43.101085288 +0800
@@ -164,53 +164,89 @@ enum btrfs_trans_type {
 	TRANS_USERSPACE,
 };
 
+static int may_wait_transaction(struct btrfs_root *root, int type)
+{
+	if (!root->fs_info->log_root_recovering &&
+	    ((type == TRANS_START && !root->fs_info->open_ioctl_trans) ||
+	     type == TRANS_USERSPACE))
+		return 1;
+	return 0;
+}
+
 static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
-					     int num_blocks, int type)
+						    u64 num_items, int type)
 {
-	struct btrfs_trans_handle *h =
-		kmem_cache_alloc(btrfs_trans_handle_cachep, GFP_NOFS);
+	struct btrfs_trans_handle *h;
+	struct btrfs_transaction *cur_trans;
+	int retries = 0;
 	int ret;
+again:
+	h = kmem_cache_alloc(btrfs_trans_handle_cachep, GFP_NOFS);
+	if (!h)
+		return ERR_PTR(-ENOMEM);
 
 	mutex_lock(&root->fs_info->trans_mutex);
-	if (!root->fs_info->log_root_recovering &&
-	    ((type == TRANS_START && !root->fs_info->open_ioctl_trans) ||
-	     type == TRANS_USERSPACE))
+	if (may_wait_transaction(root, type))
 		wait_current_trans(root);
+
 	ret = join_transaction(root);
 	BUG_ON(ret);
 
-	h->transid = root->fs_info->running_transaction->transid;
-	h->transaction = root->fs_info->running_transaction;
-	h->blocks_reserved = num_blocks;
+	cur_trans = root->fs_info->running_transaction;
+	cur_trans->use_count++;
+	mutex_unlock(&root->fs_info->trans_mutex);
+
+	h->transid = cur_trans->transid;
+	h->transaction = cur_trans;
 	h->blocks_used = 0;
 	h->block_group = 0;
+	h->bytes_reserved = 0;
 	h->delayed_ref_updates = 0;
 	h->block_rsv = NULL;
 
-	if (!current->journal_info && type != TRANS_USERSPACE)
-		current->journal_info = h;
+	smp_mb();
+	if (cur_trans->blocked && may_wait_transaction(root, type)) {
+		btrfs_commit_transaction(h, root);
+		goto again;
+	}
+
+	if (num_items > 0) {
+		ret = btrfs_trans_reserve_metadata(h, root, num_items,
+						   &retries);
+		if (ret == -EAGAIN) {
+			btrfs_commit_transaction(h, root);
+			goto again;
+		}
+		if (ret < 0) {
+			btrfs_end_transaction(h, root);
+			return ERR_PTR(ret);
+		}
+	}
 
-	root->fs_info->running_transaction->use_count++;
+	mutex_lock(&root->fs_info->trans_mutex);
 	record_root_in_trans(h, root);
 	mutex_unlock(&root->fs_info->trans_mutex);
+
+	if (!current->journal_info && type != TRANS_USERSPACE)
+		current->journal_info = h;
 	return h;
 }
 
 struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *root,
-						   int num_blocks)
+						   int num_items)
 {
-	return start_transaction(root, num_blocks, TRANS_START);
+	return start_transaction(root, num_items, TRANS_START);
 }
 struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root,
 						   int num_blocks)
 {
-	return start_transaction(root, num_blocks, TRANS_JOIN);
+	return start_transaction(root, 0, TRANS_JOIN);
 }
 
 struct btrfs_trans_handle *btrfs_start_ioctl_transaction(struct btrfs_root *r,
 							 int num_blocks)
 {
-	return start_transaction(r, num_blocks, TRANS_USERSPACE);
+	return start_transaction(r, 0, TRANS_USERSPACE);
 }
 
 /* wait for a transaction commit to be fully complete */
@@ -311,6 +347,8 @@ static int __btrfs_end_transaction(struc
 		count++;
 	}
 
+	btrfs_trans_release_metadata(trans, root);
+
 	mutex_lock(&info->trans_mutex);
 	cur_trans = info->running_transaction;
 	WARN_ON(cur_trans != trans->transaction);
@@ -756,47 +794,49 @@ static noinline int create_pending_snaps
 	struct btrfs_root *root = pending->root;
 	struct btrfs_root *parent_root;
 	struct inode *parent_inode;
+	struct dentry *dentry;
 	struct extent_buffer *tmp;
 	struct extent_buffer *old;
 	int ret;
-	u64 objectid;
-	int namelen;
 	u64 index = 0;
-
-	parent_inode = pending->dentry->d_parent->d_inode;
-	parent_root = BTRFS_I(parent_inode)->root;
+	u64 objectid;
 
 	new_root_item = kmalloc(sizeof(*new_root_item), GFP_NOFS);
 	if (!new_root_item) {
-		ret = -ENOMEM;
+		pending->error = -ENOMEM;
 		goto fail;
 	}
+
 	ret = btrfs_find_free_objectid(trans, tree_root, 0, &objectid);
-	if (ret)
+	if (ret) {
+		pending->error = ret;
 		goto fail;
+	}
 
 	key.objectid = objectid;
-	/* record when the snapshot was created in key.offset */
-	key.offset = trans->transid;
-	btrfs_set_key_type(&key, BTRFS_ROOT_ITEM_KEY);
+	key.offset = (u64)-1;
+	key.type = BTRFS_ROOT_ITEM_KEY;
 
-	memcpy(&pending->root_key, &key, sizeof(key));
-	pending->root_key.offset = (u64)-1;
+	trans->block_rsv = &pending->block_rsv;
 
+	dentry = pending->dentry;
+	parent_inode = dentry->d_parent->d_inode;
+	parent_root = BTRFS_I(parent_inode)->root;
 	record_root_in_trans(trans, parent_root);
+
 	/*
 	 * insert the directory item
 	 */
-	namelen = strlen(pending->name);
 	ret = btrfs_set_inode_index(parent_inode, &index);
 	BUG_ON(ret);
 	ret = btrfs_insert_dir_item(trans, parent_root,
-			    pending->name, namelen,
-			    parent_inode->i_ino,
-			    &pending->root_key, BTRFS_FT_DIR, index);
+				dentry->d_name.name, dentry->d_name.len,
+				parent_inode->i_ino, &key,
+				BTRFS_FT_DIR, index);
 	BUG_ON(ret);
 
-	btrfs_i_size_write(parent_inode, parent_inode->i_size + namelen * 2);
+	btrfs_i_size_write(parent_inode, parent_inode->i_size +
+					 dentry->d_name.len * 2);
 	ret = btrfs_update_inode(trans, parent_root, parent_inode);
 	BUG_ON(ret);
 
@@ -813,22 +853,29 @@ static noinline int create_pending_snaps
 	free_extent_buffer(old);
 
 	btrfs_set_root_node(new_root_item, tmp);
-	ret = btrfs_insert_root(trans, root->fs_info->tree_root, &key,
-				new_root_item);
-	BUG_ON(ret);
+	/* record when the snapshot was created in key.offset */
+	key.offset = trans->transid;
+	ret = btrfs_insert_root(trans, tree_root, &key, new_root_item);
 	btrfs_tree_unlock(tmp);
 	free_extent_buffer(tmp);
+	BUG_ON(ret);
 
-	ret = btrfs_add_root_ref(trans, parent_root->fs_info->tree_root,
-				 pending->root_key.objectid,
+	/*
+	 * insert root back/forward references
+	 */
+	ret = btrfs_add_root_ref(trans, tree_root, objectid,
 				 parent_root->root_key.objectid,
-				 parent_inode->i_ino, index, pending->name,
-				 namelen);
+				 parent_inode->i_ino, index,
+				 dentry->d_name.name, dentry->d_name.len);
 	BUG_ON(ret);
 
+	key.offset = (u64)-1;
+	pending->snap = btrfs_read_fs_root_no_name(root->fs_info, &key);
+	BUG_ON(IS_ERR(pending->snap));
 fail:
 	kfree(new_root_item);
-	return ret;
+	btrfs_block_rsv_release(root, &pending->block_rsv, (u64)-1);
+	return 0;
 }
 
 /*
@@ -897,6 +944,8 @@ int btrfs_commit_transaction(struct btrf
 	ret = btrfs_run_delayed_refs(trans, root, 0);
 	BUG_ON(ret);
 
+	btrfs_trans_release_metadata(trans, root);
+
 	cur_trans = trans->transaction;
 	/*
 	 * set the flushing flag so procs in this transaction have to
diff -urp 2/fs/btrfs/transaction.h 3/fs/btrfs/transaction.h
--- 2/fs/btrfs/transaction.h	2010-04-26 17:25:43.078829985 +0800
+++ 3/fs/btrfs/transaction.h	2010-04-26 17:25:43.101085288 +0800
@@ -57,8 +57,11 @@ struct btrfs_trans_handle {
 struct btrfs_pending_snapshot {
 	struct dentry *dentry;
 	struct btrfs_root *root;
-	char *name;
-	struct btrfs_key root_key;
+	struct btrfs_root *snap;
+	/* block reservation for the operation */
+	struct btrfs_block_rsv block_rsv;
+	/* extra metadata reseration for relocation */
+	int error;
 	struct list_head list;
 };
 
@@ -85,11 +88,11 @@ static inline void btrfs_set_inode_last_
 int btrfs_end_transaction(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *root,
-						   int num_blocks);
+						   int num_items);
 struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root,
-						   int num_blocks);
+						  int num_blocks);
 struct btrfs_trans_handle *btrfs_start_ioctl_transaction(struct btrfs_root *r,
-						   int num_blocks);
+							 int num_blocks);
 int btrfs_write_and_wait_transaction(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *root);
 int btrfs_commit_tree_roots(struct btrfs_trans_handle *trans,
diff -urp 2/fs/btrfs/volumes.c 3/fs/btrfs/volumes.c
--- 2/fs/btrfs/volumes.c	2010-04-26 17:25:43.081830757 +0800
+++ 3/fs/btrfs/volumes.c	2010-04-26 17:25:43.102079703 +0800
@@ -1096,7 +1096,7 @@ static int btrfs_rm_dev_item(struct btrf
 	if (!path)
 		return -ENOMEM;
 
-	trans = btrfs_start_transaction(root, 1);
+	trans = btrfs_start_transaction(root, 0);
 	key.objectid = BTRFS_DEV_ITEMS_OBJECTID;
 	key.type = BTRFS_DEV_ITEM_KEY;
 	key.offset = device->devid;
@@ -1485,7 +1485,7 @@ int btrfs_init_new_device(struct btrfs_r
 		goto error;
 	}
 
-	trans = btrfs_start_transaction(root, 1);
+	trans = btrfs_start_transaction(root, 0);
 	lock_chunks(root);
 
 	device->barriers = 1;
@@ -1750,9 +1750,10 @@ static int btrfs_relocate_chunk(struct b
 
 	/* step one, relocate all the extents inside this chunk */
 	ret = btrfs_relocate_block_group(extent_root, chunk_offset);
-	BUG_ON(ret);
+	if (ret)
+		return ret;
 
-	trans = btrfs_start_transaction(root, 1);
+	trans = btrfs_start_transaction(root, 0);
 	BUG_ON(!trans);
 
 	lock_chunks(root);
@@ -1924,7 +1925,7 @@ int btrfs_balance(struct btrfs_root *dev
 			break;
 		BUG_ON(ret);
 
-		trans = btrfs_start_transaction(dev_root, 1);
+		trans = btrfs_start_transaction(dev_root, 0);
 		BUG_ON(!trans);
 
 		ret = btrfs_grow_device(trans, device, old_size);
@@ -2093,11 +2094,7 @@ again:
 	}
 
 	/* Shrinking succeeded, else we would be at "done". */
-	trans = btrfs_start_transaction(root, 1);
-	if (!trans) {
-		ret = -ENOMEM;
-		goto done;
-	}
+	trans = btrfs_start_transaction(root, 0);
 	lock_chunks(root);
 
 	device->disk_total_bytes = new_size;
diff -urp 2/fs/btrfs/xattr.c 3/fs/btrfs/xattr.c
--- 2/fs/btrfs/xattr.c	2010-04-26 17:25:43.082830549 +0800
+++ 3/fs/btrfs/xattr.c	2010-04-26 17:25:43.103080402 +0800
@@ -154,15 +154,10 @@ int __btrfs_setxattr(struct btrfs_trans_
 	if (trans)
 		return do_setxattr(trans, inode, name, value, size, flags);
 
-	ret = btrfs_reserve_metadata_space(root, 2);
-	if (ret)
-		return ret;
+	trans = btrfs_start_transaction(root, 2);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 
-	trans = btrfs_start_transaction(root, 1);
-	if (!trans) {
-		ret = -ENOMEM;
-		goto out;
-	}
 	btrfs_set_trans_block_group(trans, inode);
 
 	ret = do_setxattr(trans, inode, name, value, size, flags);
@@ -174,7 +169,6 @@ int __btrfs_setxattr(struct btrfs_trans_
 	BUG_ON(ret);
 out:
 	btrfs_end_transaction_throttle(trans, root);
-	btrfs_unreserve_metadata_space(root, 2);
 	return ret;
 }
 
