From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH V2 05/12] Btrfs: Introduce contexts for metadata reservation
Date: Mon, 26 Apr 2010 18:44:52 +0800
Message-ID: <4BD56EA4.1090502@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Introducing metadata reseravtion contexts has two major advantages.
First, it makes metadata reseravtion more traceable. Second, it can
reclaim freed space and re-add them to the itself after transaction
committed.

Besides add btrfs_block_rsv structure and related helper functions,
This patch contains following changes:

Move code that decides if freed tree block should be pinned into
btrfs_free_tree_block().

Make space accounting more accuracy, mainly for handling read only
block groups.
diff -urp 2/fs/btrfs/ctree.c 3/fs/btrfs/ctree.c
--- 2/fs/btrfs/ctree.c	2010-04-26 17:24:55.227081691 +0800
+++ 3/fs/btrfs/ctree.c	2010-04-26 17:24:55.245079481 +0800
@@ -279,7 +279,8 @@ int btrfs_block_can_be_shared(struct btr
 static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 				       struct btrfs_root *root,
 				       struct extent_buffer *buf,
-				       struct extent_buffer *cow)
+				       struct extent_buffer *cow,
+				       int *last_ref)
 {
 	u64 refs;
 	u64 owner;
@@ -365,6 +366,7 @@ static noinline int update_ref_for_cow(s
 			BUG_ON(ret);
 		}
 		clean_tree_block(trans, root, buf);
+		*last_ref = 1;
 	}
 	return 0;
 }
@@ -391,6 +393,7 @@ static noinline int __btrfs_cow_block(st
 	struct btrfs_disk_key disk_key;
 	struct extent_buffer *cow;
 	int level;
+	int last_ref = 0;
 	int unlock_orig = 0;
 	u64 parent_start;
 
@@ -441,7 +444,7 @@ static noinline int __btrfs_cow_block(st
 			    (unsigned long)btrfs_header_fsid(cow),
 			    BTRFS_FSID_SIZE);
 
-	update_ref_for_cow(trans, root, buf, cow);
+	update_ref_for_cow(trans, root, buf, cow, &last_ref);
 
 	if (buf == root->node) {
 		WARN_ON(parent && parent != buf);
@@ -456,8 +459,8 @@ static noinline int __btrfs_cow_block(st
 		extent_buffer_get(cow);
 		spin_unlock(&root->node_lock);
 
-		btrfs_free_tree_block(trans, root, buf->start, buf->len,
-				parent_start, root->root_key.objectid, level);
+		btrfs_free_tree_block(trans, root, buf, parent_start,
+				      last_ref);
 		free_extent_buffer(buf);
 		add_root_to_dirty_list(root);
 	} else {
@@ -472,8 +475,8 @@ static noinline int __btrfs_cow_block(st
 		btrfs_set_node_ptr_generation(parent, parent_slot,
 					      trans->transid);
 		btrfs_mark_buffer_dirty(parent);
-		btrfs_free_tree_block(trans, root, buf->start, buf->len,
-				parent_start, root->root_key.objectid, level);
+		btrfs_free_tree_block(trans, root, buf, parent_start,
+				      last_ref);
 	}
 	if (unlock_orig)
 		btrfs_tree_unlock(buf);
@@ -948,6 +951,22 @@ int btrfs_bin_search(struct extent_buffe
 	return bin_search(eb, key, level, slot);
 }
 
+static void root_add_used(struct btrfs_root *root, u32 size)
+{
+	spin_lock(&root->accounting_lock);
+	btrfs_set_root_used(&root->root_item,
+			    btrfs_root_used(&root->root_item) + size);
+	spin_unlock(&root->accounting_lock);
+}
+
+static void root_sub_used(struct btrfs_root *root, u32 size)
+{
+	spin_lock(&root->accounting_lock);
+	btrfs_set_root_used(&root->root_item,
+			    btrfs_root_used(&root->root_item) - size);
+	spin_unlock(&root->accounting_lock);
+}
+
 /* given a node and slot number, this reads the blocks it points to.  The
  * extent buffer is returned with a reference taken (but unlocked).
  * NULL is returned on error.
@@ -1018,7 +1037,11 @@ static noinline int balance_level(struct
 		btrfs_tree_lock(child);
 		btrfs_set_lock_blocking(child);
 		ret = btrfs_cow_block(trans, root, child, mid, 0, &child);
-		BUG_ON(ret);
+		if (ret) {
+			btrfs_tree_unlock(child);
+			free_extent_buffer(child);
+			goto enospc;
+		}
 
 		spin_lock(&root->node_lock);
 		root->node = child;
@@ -1033,11 +1056,12 @@ static noinline int balance_level(struct
 		btrfs_tree_unlock(mid);
 		/* once for the path */
 		free_extent_buffer(mid);
-		ret = btrfs_free_tree_block(trans, root, mid->start, mid->len,
-					    0, root->root_key.objectid, level);
+
+		root_sub_used(root, mid->len);
+		btrfs_free_tree_block(trans, root, mid, 0, 1);
 		/* once for the root ptr */
 		free_extent_buffer(mid);
-		return ret;
+		return 0;
 	}
 	if (btrfs_header_nritems(mid) >
 	    BTRFS_NODEPTRS_PER_BLOCK(root) / 4)
@@ -1087,23 +1111,16 @@ static noinline int balance_level(struct
 		if (wret < 0 && wret != -ENOSPC)
 			ret = wret;
 		if (btrfs_header_nritems(right) == 0) {
-			u64 bytenr = right->start;
-			u32 blocksize = right->len;
-
 			clean_tree_block(trans, root, right);
 			btrfs_tree_unlock(right);
-			free_extent_buffer(right);
-			right = NULL;
 			wret = del_ptr(trans, root, path, level + 1, pslot +
 				       1);
 			if (wret)
 				ret = wret;
-			wret = btrfs_free_tree_block(trans, root,
-						     bytenr, blocksize, 0,
-						     root->root_key.objectid,
-						     level);
-			if (wret)
-				ret = wret;
+			root_sub_used(root, right->len);
+			btrfs_free_tree_block(trans, root, right, 0, 1);
+			free_extent_buffer(right);
+			right = NULL;
 		} else {
 			struct btrfs_disk_key right_key;
 			btrfs_node_key(right, &right_key, 0);
@@ -1135,21 +1152,15 @@ static noinline int balance_level(struct
 		BUG_ON(wret == 1);
 	}
 	if (btrfs_header_nritems(mid) == 0) {
-		/* we've managed to empty the middle node, drop it */
-		u64 bytenr = mid->start;
-		u32 blocksize = mid->len;
-
 		clean_tree_block(trans, root, mid);
 		btrfs_tree_unlock(mid);
-		free_extent_buffer(mid);
-		mid = NULL;
 		wret = del_ptr(trans, root, path, level + 1, pslot);
 		if (wret)
 			ret = wret;
-		wret = btrfs_free_tree_block(trans, root, bytenr, blocksize,
-					 0, root->root_key.objectid, level);
-		if (wret)
-			ret = wret;
+		root_sub_used(root, mid->len);
+		btrfs_free_tree_block(trans, root, mid, 0, 1);
+		free_extent_buffer(mid);
+		mid = NULL;
 	} else {
 		/* update the parent key to reflect our changes */
 		struct btrfs_disk_key mid_key;
@@ -1739,7 +1750,6 @@ again:
 					      p->nodes[level + 1],
 					      p->slots[level + 1], &b);
 			if (err) {
-				free_extent_buffer(b);
 				ret = err;
 				goto done;
 			}
@@ -2075,6 +2085,8 @@ static noinline int insert_new_root(stru
 	if (IS_ERR(c))
 		return PTR_ERR(c);
 
+	root_add_used(root, root->nodesize);
+
 	memset_extent_buffer(c, 0, 0, sizeof(struct btrfs_header));
 	btrfs_set_header_nritems(c, 1);
 	btrfs_set_header_level(c, level);
@@ -2133,6 +2145,7 @@ static int insert_ptr(struct btrfs_trans
 	int nritems;
 
 	BUG_ON(!path->nodes[level]);
+	btrfs_assert_tree_locked(path->nodes[level]);
 	lower = path->nodes[level];
 	nritems = btrfs_header_nritems(lower);
 	BUG_ON(slot > nritems);
@@ -2201,6 +2214,8 @@ static noinline int split_node(struct bt
 	if (IS_ERR(split))
 		return PTR_ERR(split);
 
+	root_add_used(root, root->nodesize);
+
 	memset_extent_buffer(split, 0, 0, sizeof(struct btrfs_header));
 	btrfs_set_header_level(split, btrfs_header_level(c));
 	btrfs_set_header_bytenr(split, split->start);
@@ -2414,6 +2429,9 @@ static noinline int __push_leaf_right(st
 
 	if (left_nritems)
 		btrfs_mark_buffer_dirty(left);
+	else
+		clean_tree_block(trans, root, left);
+
 	btrfs_mark_buffer_dirty(right);
 
 	btrfs_item_key(right, &disk_key, 0);
@@ -2659,6 +2677,8 @@ static noinline int __push_leaf_left(str
 	btrfs_mark_buffer_dirty(left);
 	if (right_nritems)
 		btrfs_mark_buffer_dirty(right);
+	else
+		clean_tree_block(trans, root, right);
 
 	btrfs_item_key(right, &disk_key, 0);
 	wret = fixup_low_keys(trans, root, path, &disk_key, 1);
@@ -2668,8 +2688,6 @@ static noinline int __push_leaf_left(str
 	/* then fixup the leaf pointer in the path */
 	if (path->slots[0] < push_items) {
 		path->slots[0] += old_left_nritems;
-		if (btrfs_header_nritems(path->nodes[0]) == 0)
-			clean_tree_block(trans, root, path->nodes[0]);
 		btrfs_tree_unlock(path->nodes[0]);
 		free_extent_buffer(path->nodes[0]);
 		path->nodes[0] = left;
@@ -2931,10 +2949,10 @@ again:
 	right = btrfs_alloc_free_block(trans, root, root->leafsize, 0,
 					root->root_key.objectid,
 					&disk_key, 0, l->start, 0);
-	if (IS_ERR(right)) {
-		BUG_ON(1);
+	if (IS_ERR(right))
 		return PTR_ERR(right);
-	}
+
+	root_add_used(root, root->leafsize);
 
 	memset_extent_buffer(right, 0, 0, sizeof(struct btrfs_header));
 	btrfs_set_header_bytenr(right, right->start);
@@ -3053,7 +3071,8 @@ static noinline int setup_leaf_for_split
 
 	btrfs_set_path_blocking(path);
 	ret = split_leaf(trans, root, &key, path, ins_len, 1);
-	BUG_ON(ret);
+	if (ret)
+		goto err;
 
 	path->keep_locks = 0;
 	btrfs_unlock_up_safe(path, 1);
@@ -3795,9 +3814,10 @@ static noinline int btrfs_del_leaf(struc
 	 */
 	btrfs_unlock_up_safe(path, 0);
 
-	ret = btrfs_free_tree_block(trans, root, leaf->start, leaf->len,
-				    0, root->root_key.objectid, 0);
-	return ret;
+	root_sub_used(root, leaf->len);
+
+	btrfs_free_tree_block(trans, root, leaf, 0, 1);
+	return 0;
 }
 /*
  * delete the item at the leaf level in path.  If that empties
@@ -3864,6 +3884,8 @@ int btrfs_del_items(struct btrfs_trans_h
 		if (leaf == root->node) {
 			btrfs_set_header_level(leaf, 0);
 		} else {
+			btrfs_set_path_blocking(path);
+			clean_tree_block(trans, root, leaf);
 			ret = btrfs_del_leaf(trans, root, path, leaf);
 			BUG_ON(ret);
 		}
diff -urp 2/fs/btrfs/ctree.h 3/fs/btrfs/ctree.h
--- 2/fs/btrfs/ctree.h	2010-04-26 17:24:55.237085267 +0800
+++ 3/fs/btrfs/ctree.h	2010-04-26 17:24:55.246080391 +0800
@@ -706,6 +706,20 @@ struct btrfs_space_info {
 	atomic_t caching_threads;
 };
 
+struct btrfs_block_rsv {
+	u64 size;
+	u64 reserved;
+	u64 freed[2];
+	struct btrfs_space_info *space_info;
+	struct list_head list;
+	spinlock_t lock;
+	atomic_t usage;
+	unsigned int priority:8;
+	unsigned int durable:1;
+	unsigned int refill_used:1;
+	unsigned int full:1;
+};
+
 /*
  * free clusters are used to claim free space in relatively large chunks,
  * allowing us to do less seeky writes.  They are used for all metadata
@@ -756,6 +770,7 @@ struct btrfs_block_group_cache {
 	spinlock_t lock;
 	u64 pinned;
 	u64 reserved;
+	u64 reserved_pinned;
 	u64 bytes_super;
 	u64 flags;
 	u64 sectorsize;
@@ -821,6 +836,22 @@ struct btrfs_fs_info {
 	/* logical->physical extent mapping */
 	struct btrfs_mapping_tree mapping_tree;
 
+	/* block reservation for extent, checksum and root tree */
+	struct btrfs_block_rsv global_block_rsv;
+	/* block reservation for delay allocation */
+	struct btrfs_block_rsv delalloc_block_rsv;
+	/* block reservation for metadata operations */
+	struct btrfs_block_rsv trans_block_rsv;
+	/* block reservation for chunk tree */
+	struct btrfs_block_rsv chunk_block_rsv;
+
+	struct btrfs_block_rsv empty_block_rsv;
+
+	/* list of block reservations that cross multiple transactions */
+	struct list_head durable_block_rsv_list;
+
+	struct mutex durable_block_rsv_mutex;
+
 	u64 generation;
 	u64 last_trans_committed;
 
@@ -1007,6 +1038,9 @@ struct btrfs_root {
 	struct completion kobj_unregister;
 	struct mutex objectid_mutex;
 
+	spinlock_t accounting_lock;
+	struct btrfs_block_rsv *block_rsv;
+
 	struct mutex log_mutex;
 	wait_queue_head_t log_writer_wait;
 	wait_queue_head_t log_commit_wait[2];
@@ -1979,10 +2013,10 @@ struct extent_buffer *btrfs_alloc_free_b
 					u64 parent, u64 root_objectid,
 					struct btrfs_disk_key *key, int level,
 					u64 hint, u64 empty_size);
-int btrfs_free_tree_block(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root,
-			  u64 bytenr, u32 blocksize,
-			  u64 parent, u64 root_objectid, int level);
+void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
+			   struct btrfs_root *root,
+			   struct extent_buffer *buf,
+			   u64 parent, int last_ref);
 struct extent_buffer *btrfs_init_new_buffer(struct btrfs_trans_handle *trans,
 					    struct btrfs_root *root,
 					    u64 bytenr, u32 blocksize,
@@ -2036,9 +2070,6 @@ int btrfs_make_block_group(struct btrfs_
 			   u64 size);
 int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root, u64 group_start);
-int btrfs_prepare_block_group_relocation(struct btrfs_root *root,
-				struct btrfs_block_group_cache *group);
-
 u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags);
 void btrfs_set_inode_space_info(struct btrfs_root *root, struct inode *ionde);
 void btrfs_clear_space_info_full(struct btrfs_fs_info *info);
@@ -2057,6 +2088,30 @@ void btrfs_delalloc_reserve_space(struct
 				 u64 bytes);
 void btrfs_delalloc_free_space(struct btrfs_root *root, struct inode *inode,
 			      u64 bytes);
+void btrfs_init_block_rsv(struct btrfs_block_rsv *rsv);
+struct btrfs_block_rsv *btrfs_alloc_block_rsv(struct btrfs_root *root);
+void btrfs_free_block_rsv(struct btrfs_root *root,
+			  struct btrfs_block_rsv *rsv);
+void btrfs_add_durable_block_rsv(struct btrfs_fs_info *fs_info,
+				 struct btrfs_block_rsv *rsv);
+int btrfs_block_rsv_add(struct btrfs_trans_handle *trans,
+			struct btrfs_root *root,
+			struct btrfs_block_rsv *block_rsv,
+			u64 num_bytes, int *retries);
+int btrfs_block_rsv_check(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *root,
+			  struct btrfs_block_rsv *block_rsv,
+			  u64 min_reserved, int min_factor);
+int btrfs_block_rsv_migrate(struct btrfs_block_rsv *src_rsv,
+			    struct btrfs_block_rsv *dst_rsv,
+			    u64 num_bytes);
+void btrfs_block_rsv_release(struct btrfs_root *root,
+			     struct btrfs_block_rsv *block_rsv,
+			     u64 num_bytes);
+int btrfs_set_block_group_ro(struct btrfs_root *root,
+			     struct btrfs_block_group_cache *cache);
+int btrfs_set_block_group_rw(struct btrfs_root *root,
+			     struct btrfs_block_group_cache *cache);
 /* ctree.c */
 int btrfs_bin_search(struct extent_buffer *eb, struct btrfs_key *key,
 		     int level, int *slot);
diff -urp 2/fs/btrfs/disk-io.c 3/fs/btrfs/disk-io.c
--- 2/fs/btrfs/disk-io.c	2010-04-26 17:24:55.225081619 +0800
+++ 3/fs/btrfs/disk-io.c	2010-04-26 17:24:55.247080601 +0800
@@ -904,6 +904,7 @@ static int __setup_root(u32 nodesize, u3
 	root->name = NULL;
 	root->in_sysfs = 0;
 	root->inode_tree = RB_ROOT;
+	root->block_rsv = NULL;
 
 	INIT_LIST_HEAD(&root->dirty_list);
 	INIT_LIST_HEAD(&root->orphan_list);
@@ -911,6 +912,7 @@ static int __setup_root(u32 nodesize, u3
 	spin_lock_init(&root->node_lock);
 	spin_lock_init(&root->list_lock);
 	spin_lock_init(&root->inode_lock);
+	spin_lock_init(&root->accounting_lock);
 	mutex_init(&root->objectid_mutex);
 	mutex_init(&root->log_mutex);
 	init_waitqueue_head(&root->log_writer_wait);
@@ -1629,6 +1631,13 @@ struct btrfs_root *open_ctree(struct sup
 	INIT_LIST_HEAD(&fs_info->dirty_cowonly_roots);
 	INIT_LIST_HEAD(&fs_info->space_info);
 	btrfs_mapping_init(&fs_info->mapping_tree);
+	btrfs_init_block_rsv(&fs_info->global_block_rsv);
+	btrfs_init_block_rsv(&fs_info->delalloc_block_rsv);
+	btrfs_init_block_rsv(&fs_info->trans_block_rsv);
+	btrfs_init_block_rsv(&fs_info->chunk_block_rsv);
+	btrfs_init_block_rsv(&fs_info->empty_block_rsv);
+	INIT_LIST_HEAD(&fs_info->durable_block_rsv_list);
+	mutex_init(&fs_info->durable_block_rsv_mutex);
 	atomic_set(&fs_info->nr_async_submits, 0);
 	atomic_set(&fs_info->async_delalloc_pages, 0);
 	atomic_set(&fs_info->async_submit_draining, 0);
diff -urp 2/fs/btrfs/extent-tree.c 3/fs/btrfs/extent-tree.c
--- 2/fs/btrfs/extent-tree.c	2010-04-26 17:24:55.239079753 +0800
+++ 3/fs/btrfs/extent-tree.c	2010-04-26 17:25:29.283857877 +0800
@@ -34,10 +34,9 @@
 
 static int update_block_group(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root,
-			      u64 bytenr, u64 num_bytes, int alloc,
-			      int mark_free);
-static int update_reserved_extents(struct btrfs_block_group_cache *cache,
-				   u64 num_bytes, int reserve);
+			      u64 bytenr, u64 num_bytes, int alloc);
+static int update_reserved_bytes(struct btrfs_block_group_cache *cache,
+				 u64 num_bytes, int reserve, int sinfo);
 static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
 				u64 bytenr, u64 num_bytes, u64 parent,
@@ -60,12 +59,6 @@ static int alloc_reserved_tree_block(str
 static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *extent_root, u64 alloc_bytes,
 			  u64 flags, int force);
-static int pin_down_bytes(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root,
-			  struct btrfs_path *path,
-			  u64 bytenr, u64 num_bytes,
-			  int is_data, int reserved,
-			  struct extent_buffer **must_clean);
 static int find_next_key(struct btrfs_path *path, int level,
 			 struct btrfs_key *key);
 static void dump_space_info(struct btrfs_space_info *info, u64 bytes,
@@ -96,8 +89,12 @@ void btrfs_get_block_group(struct btrfs_
 
 void btrfs_put_block_group(struct btrfs_block_group_cache *cache)
 {
-	if (atomic_dec_and_test(&cache->count))
+	if (atomic_dec_and_test(&cache->count)) {
+		WARN_ON(cache->pinned > 0);
+		WARN_ON(cache->reserved > 0);
+		WARN_ON(cache->reserved_pinned > 0);
 		kfree(cache);
+	}
 }
 
 /*
@@ -324,7 +321,7 @@ static int caching_kthread(void *data)
 
 	exclude_super_stripes(extent_root, block_group);
 	spin_lock(&block_group->space_info->lock);
-	block_group->space_info->bytes_super += block_group->bytes_super;
+	block_group->space_info->bytes_readonly += block_group->bytes_super;
 	spin_unlock(&block_group->space_info->lock);
 
 	last = max_t(u64, block_group->key.objectid, BTRFS_SUPER_INFO_OFFSET);
@@ -1879,7 +1876,6 @@ static int run_delayed_tree_ref(struct b
 	return ret;
 }
 
-
 /* helper function to actually process a single delayed ref entry */
 static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root,
@@ -1899,32 +1895,14 @@ static int run_one_delayed_ref(struct bt
 		BUG_ON(extent_op);
 		head = btrfs_delayed_node_to_head(node);
 		if (insert_reserved) {
-			int mark_free = 0;
-			struct extent_buffer *must_clean = NULL;
-
-			ret = pin_down_bytes(trans, root, NULL,
-					     node->bytenr, node->num_bytes,
-					     head->is_data, 1, &must_clean);
-			if (ret > 0)
-				mark_free = 1;
-
-			if (must_clean) {
-				clean_tree_block(NULL, root, must_clean);
-				btrfs_tree_unlock(must_clean);
-				free_extent_buffer(must_clean);
-			}
+			btrfs_pin_extent(root, node->bytenr,
+					 node->num_bytes, 1);
 			if (head->is_data) {
 				ret = btrfs_del_csums(trans, root,
 						      node->bytenr,
 						      node->num_bytes);
 				BUG_ON(ret);
 			}
-			if (mark_free) {
-				ret = btrfs_free_reserved_extent(root,
-							node->bytenr,
-							node->num_bytes);
-				BUG_ON(ret);
-			}
 		}
 		mutex_unlock(&head->mutex);
 		return 0;
@@ -2355,6 +2333,8 @@ int btrfs_cross_ref_exist(struct btrfs_t
 		ret = 0;
 out:
 	btrfs_free_path(path);
+	if (root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID)
+		WARN_ON(ret > 0);
 	return ret;
 }
 
@@ -2705,7 +2685,7 @@ static int update_space_info(struct btrf
 	found->bytes_pinned = 0;
 	found->bytes_reserved = 0;
 	found->bytes_readonly = 0;
-	found->bytes_delalloc = 0;
+	found->bytes_may_use = 0;
 	found->full = 0;
 	found->force_alloc = 0;
 	*space_info = found;
@@ -2730,19 +2710,6 @@ static void set_avail_alloc_bits(struct 
 	}
 }
 
-static void set_block_group_readonly(struct btrfs_block_group_cache *cache)
-{
-	spin_lock(&cache->space_info->lock);
-	spin_lock(&cache->lock);
-	if (!cache->ro) {
-		cache->space_info->bytes_readonly += cache->key.offset -
-					btrfs_block_group_used(&cache->item);
-		cache->ro = 1;
-	}
-	spin_unlock(&cache->lock);
-	spin_unlock(&cache->space_info->lock);
-}
-
 u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags)
 {
 	u64 num_devices = root->fs_info->fs_devices->rw_devices;
@@ -2801,11 +2768,8 @@ static u64 btrfs_get_alloc_profile(struc
 
 void btrfs_set_inode_space_info(struct btrfs_root *root, struct inode *inode)
 {
-	u64 alloc_target;
-
-	alloc_target = btrfs_get_alloc_profile(root, 1);
 	BTRFS_I(inode)->space_info = __find_space_info(root->fs_info,
-						       alloc_target);
+						       BTRFS_BLOCK_GROUP_DATA);
 }
 
 static u64 calculate_bytes_needed(struct btrfs_root *root, int num_items)
@@ -3411,10 +3375,334 @@ static int shrink_delalloc(struct btrfs_
 	return reclaimed >= to_reclaim;
 }
 
+static int should_retry_reserve(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root,
+				struct btrfs_block_rsv *block_rsv,
+				u64 num_bytes, int *retries)
+{
+	struct btrfs_space_info *space_info = block_rsv->space_info;
+	int ret;
+
+	if ((*retries) > 2)
+		return -ENOSPC;
+
+	ret = maybe_allocate_chunk(trans, root, space_info, num_bytes);
+	if (ret)
+		return 1;
+
+	if (trans && trans->transaction->in_commit)
+		return -ENOSPC;
+
+	ret = shrink_delalloc(trans, root, space_info, num_bytes);
+	if (ret)
+		return ret;
+
+	spin_lock(&space_info->lock);
+	if (space_info->bytes_pinned < num_bytes)
+		ret = 1;
+	spin_unlock(&space_info->lock);
+	if (ret)
+		return -ENOSPC;
+
+	(*retries)++;
+
+	if (trans)
+		return -EAGAIN;
+
+	trans = btrfs_join_transaction(root, 1);
+	BUG_ON(IS_ERR(trans));
+	ret = btrfs_commit_transaction(trans, root);
+	BUG_ON(ret);
+
+	return 1;
+}
+
+static int reserve_metadata_bytes(struct btrfs_block_rsv *block_rsv,
+				  u64 num_bytes)
+{
+	struct btrfs_space_info *space_info = block_rsv->space_info;
+	u64 unused;
+	int ret = -ENOSPC;
+
+	spin_lock(&space_info->lock);
+	unused = space_info->bytes_used + space_info->bytes_reserved +
+		 space_info->bytes_pinned + space_info->bytes_readonly;
+
+	if (unused < space_info->total_bytes)
+		unused = space_info->total_bytes - unused;
+	else
+		unused = 0;
+
+	if (unused >= num_bytes) {
+		if (block_rsv->priority >= 10) {
+			space_info->bytes_reserved += num_bytes;
+			ret = 0;
+		} else {
+			if ((unused + block_rsv->reserved) *
+			    block_rsv->priority >=
+			    (num_bytes + block_rsv->reserved) * 10) {
+				space_info->bytes_reserved += num_bytes;
+				ret = 0;
+			}
+		}
+	}
+	spin_unlock(&space_info->lock);
+
+	return ret;
+}
+
+static struct btrfs_block_rsv *get_block_rsv(struct btrfs_trans_handle *trans,
+					     struct btrfs_root *root)
+{
+	struct btrfs_block_rsv *block_rsv;
+	if (root->ref_cows)
+		block_rsv = trans->block_rsv;
+	else
+		block_rsv = root->block_rsv;
+
+	if (!block_rsv)
+		block_rsv = &root->fs_info->empty_block_rsv;
+
+	return block_rsv;
+}
+
+static int block_rsv_use_bytes(struct btrfs_block_rsv *block_rsv,
+			       u64 num_bytes)
+{
+	int ret = -ENOSPC;
+	spin_lock(&block_rsv->lock);
+	if (block_rsv->reserved >= num_bytes) {
+		block_rsv->reserved -= num_bytes;
+		if (block_rsv->reserved < block_rsv->size)
+			block_rsv->full = 0;
+		ret = 0;
+	}
+	spin_unlock(&block_rsv->lock);
+	return ret;
+}
+
+static void block_rsv_add_bytes(struct btrfs_block_rsv *block_rsv,
+				u64 num_bytes, int update_size)
+{
+	spin_lock(&block_rsv->lock);
+	block_rsv->reserved += num_bytes;
+	if (update_size)
+		block_rsv->size += num_bytes;
+	else if (block_rsv->reserved >= block_rsv->size)
+		block_rsv->full = 1;
+	spin_unlock(&block_rsv->lock);
+}
+
+void block_rsv_release_bytes(struct btrfs_block_rsv *block_rsv,
+			     struct btrfs_block_rsv *dest, u64 num_bytes)
+{
+	struct btrfs_space_info *space_info = block_rsv->space_info;
+
+	spin_lock(&block_rsv->lock);
+	if (num_bytes == (u64)-1)
+		num_bytes = block_rsv->size;
+	block_rsv->size -= num_bytes;
+	if (block_rsv->reserved >= block_rsv->size) {
+		num_bytes = block_rsv->reserved - block_rsv->size;
+		block_rsv->reserved = block_rsv->size;
+		block_rsv->full = 1;
+	} else {
+		num_bytes = 0;
+	}
+	spin_unlock(&block_rsv->lock);
+
+	if (num_bytes > 0) {
+		if (dest) {
+			block_rsv_add_bytes(dest, num_bytes, 0);
+		} else {
+			spin_lock(&space_info->lock);
+			space_info->bytes_reserved -= num_bytes;
+			spin_unlock(&space_info->lock);
+		}
+	}
+}
+
+static int block_rsv_migrate_bytes(struct btrfs_block_rsv *src,
+				   struct btrfs_block_rsv *dst, u64 num_bytes)
+{
+	int ret;
+
+	ret = block_rsv_use_bytes(src, num_bytes);
+	if (ret)
+		return ret;
+
+	block_rsv_add_bytes(dst, num_bytes, 1);
+	return 0;
+}
+
+void btrfs_init_block_rsv(struct btrfs_block_rsv *rsv)
+{
+	memset(rsv, 0, sizeof(*rsv));
+	spin_lock_init(&rsv->lock);
+	atomic_set(&rsv->usage, 1);
+	rsv->priority = 6;
+	INIT_LIST_HEAD(&rsv->list);
+}
+
+struct btrfs_block_rsv *btrfs_alloc_block_rsv(struct btrfs_root *root)
+{
+	struct btrfs_block_rsv *block_rsv;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	u64 alloc_target;
+
+	block_rsv = kmalloc(sizeof(*block_rsv), GFP_NOFS);
+	if (!block_rsv)
+		return NULL;
+
+	btrfs_init_block_rsv(block_rsv);
+
+	alloc_target = btrfs_get_alloc_profile(root, 0);
+	block_rsv->space_info = __find_space_info(fs_info,
+						  BTRFS_BLOCK_GROUP_METADATA);
+
+	return block_rsv;
+}
+
+void btrfs_free_block_rsv(struct btrfs_root *root,
+			  struct btrfs_block_rsv *rsv)
+{
+	if (rsv && atomic_dec_and_test(&rsv->usage)) {
+		btrfs_block_rsv_release(root, rsv, (u64)-1);
+		if (!rsv->durable)
+			kfree(rsv);
+	}
+}
+
+/*
+ * make the block_rsv struct be able to capture freed space.
+ * the captured space will re-add to the the block_rsv struct
+ * after transaction commit
+ */
+void btrfs_add_durable_block_rsv(struct btrfs_fs_info *fs_info,
+				 struct btrfs_block_rsv *block_rsv)
+{
+	block_rsv->durable = 1;
+	mutex_lock(&fs_info->durable_block_rsv_mutex);
+	list_add_tail(&block_rsv->list, &fs_info->durable_block_rsv_list);
+	mutex_unlock(&fs_info->durable_block_rsv_mutex);
+}
+
+int btrfs_block_rsv_add(struct btrfs_trans_handle *trans,
+			struct btrfs_root *root,
+			struct btrfs_block_rsv *block_rsv,
+			u64 num_bytes, int *retries)
+{
+	int ret;
+
+	if (num_bytes == 0)
+		return 0;
+again:
+	ret = reserve_metadata_bytes(block_rsv, num_bytes);
+	if (!ret) {
+		block_rsv_add_bytes(block_rsv, num_bytes, 1);
+		return 0;
+	}
+
+	ret = should_retry_reserve(trans, root, block_rsv, num_bytes, retries);
+	if (ret > 0)
+		goto again;
+
+	return ret;
+}
+
+int btrfs_block_rsv_check(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *root,
+			  struct btrfs_block_rsv *block_rsv,
+			  u64 min_reserved, int min_factor)
+{
+	u64 num_bytes = 0;
+	int commit_trans = 0;
+	int ret = -ENOSPC;
+
+	if (!block_rsv)
+		return 0;
+
+	spin_lock(&block_rsv->lock);
+	if (min_factor > 0)
+		num_bytes = div_factor(block_rsv->size, min_factor);
+	if (min_reserved > num_bytes)
+		num_bytes = min_reserved;
+
+	if (block_rsv->reserved >= num_bytes) {
+		ret = 0;
+	} else {
+		num_bytes -= block_rsv->reserved;
+		if (block_rsv->durable &&
+		    block_rsv->freed[0] + block_rsv->freed[1] >= num_bytes)
+			commit_trans = 1;
+	}
+	spin_unlock(&block_rsv->lock);
+	if (!ret)
+		return 0;
+
+	if (block_rsv->refill_used) {
+		ret = reserve_metadata_bytes(block_rsv, num_bytes);
+		if (!ret) {
+			block_rsv_add_bytes(block_rsv, num_bytes, 0);
+			return 0;
+		}
+	}
+
+	if (commit_trans) {
+		if (trans)
+			return -EAGAIN;
+
+		trans = btrfs_join_transaction(root, 1);
+		BUG_ON(IS_ERR(trans));
+		ret = btrfs_commit_transaction(trans, root);
+		return 0;
+	}
+
+	WARN_ON(1);
+	printk(KERN_INFO"block_rsv size %llu reserved %llu freed %llu %llu\n",
+		block_rsv->size, block_rsv->reserved,
+		block_rsv->freed[0], block_rsv->freed[1]);
+
+	return -ENOSPC;
+}
+
+int btrfs_block_rsv_migrate(struct btrfs_block_rsv *src_rsv,
+			    struct btrfs_block_rsv *dst_rsv,
+			    u64 num_bytes)
+{
+	return block_rsv_migrate_bytes(src_rsv, dst_rsv, num_bytes);
+}
+
+void btrfs_block_rsv_release(struct btrfs_root *root,
+			     struct btrfs_block_rsv *block_rsv,
+			     u64 num_bytes)
+{
+	struct btrfs_block_rsv *global_rsv = &root->fs_info->global_block_rsv;
+	if (global_rsv->full || global_rsv == block_rsv ||
+	    block_rsv->space_info != global_rsv->space_info)
+		global_rsv = NULL;
+	block_rsv_release_bytes(block_rsv, global_rsv, num_bytes);
+}
+
+static void init_global_block_rsv(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_space_info *space_info;
+
+	space_info = __find_space_info(fs_info, BTRFS_BLOCK_GROUP_SYSTEM);
+	fs_info->chunk_block_rsv.space_info = space_info;
+	fs_info->chunk_block_rsv.priority = 10;
+
+	space_info = __find_space_info(fs_info, BTRFS_BLOCK_GROUP_METADATA);
+	fs_info->trans_block_rsv.space_info = space_info;
+	fs_info->empty_block_rsv.space_info = space_info;
+	fs_info->empty_block_rsv.priority = 10;
+
+	fs_info->chunk_root->block_rsv = &fs_info->chunk_block_rsv;
+}
+
 static int update_block_group(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root,
-			      u64 bytenr, u64 num_bytes, int alloc,
-			      int mark_free)
+			      u64 bytenr, u64 num_bytes, int alloc)
 {
 	struct btrfs_block_group_cache *cache;
 	struct btrfs_fs_info *info = root->fs_info;
@@ -3458,30 +3746,21 @@ static int update_block_group(struct btr
 			cache->space_info->bytes_reserved -= num_bytes;
 			cache->space_info->bytes_used += num_bytes;
 			cache->space_info->disk_used += num_bytes * factor;
-			if (cache->ro)
-				cache->space_info->bytes_readonly -= num_bytes;
 			spin_unlock(&cache->lock);
 			spin_unlock(&cache->space_info->lock);
 		} else {
 			old_val -= num_bytes;
 			btrfs_set_block_group_used(&cache->item, old_val);
+			cache->pinned += num_bytes;
+			cache->space_info->bytes_pinned += num_bytes;
 			cache->space_info->bytes_used -= num_bytes;
 			cache->space_info->disk_used -= num_bytes * factor;
-			if (cache->ro)
-				cache->space_info->bytes_readonly += num_bytes;
 			spin_unlock(&cache->lock);
 			spin_unlock(&cache->space_info->lock);
-			if (mark_free) {
-				int ret;
 
-				ret = btrfs_discard_extent(root, bytenr,
-							   num_bytes);
-				WARN_ON(ret);
-
-				ret = btrfs_add_free_space(cache, bytenr,
-							   num_bytes);
-				WARN_ON(ret);
-			}
+			set_extent_dirty(info->pinned_extents,
+					 bytenr, bytenr + num_bytes - 1,
+					 GFP_NOFS | __GFP_NOFAIL);
 		}
 		btrfs_put_block_group(cache);
 		total -= num_bytes;
@@ -3505,18 +3784,10 @@ static u64 first_logical_byte(struct btr
 	return bytenr;
 }
 
-/*
- * this function must be called within transaction
- */
-int btrfs_pin_extent(struct btrfs_root *root,
-		     u64 bytenr, u64 num_bytes, int reserved)
+static int pin_down_extent(struct btrfs_root *root,
+			   struct btrfs_block_group_cache *cache,
+			   u64 bytenr, u64 num_bytes, int reserved)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
-	struct btrfs_block_group_cache *cache;
-
-	cache = btrfs_lookup_block_group(fs_info, bytenr);
-	BUG_ON(!cache);
-
 	spin_lock(&cache->space_info->lock);
 	spin_lock(&cache->lock);
 	cache->pinned += num_bytes;
@@ -3528,28 +3799,68 @@ int btrfs_pin_extent(struct btrfs_root *
 	spin_unlock(&cache->lock);
 	spin_unlock(&cache->space_info->lock);
 
-	btrfs_put_block_group(cache);
+	set_extent_dirty(root->fs_info->pinned_extents, bytenr,
+			 bytenr + num_bytes - 1, GFP_NOFS | __GFP_NOFAIL);
+	return 0;
+}
 
-	set_extent_dirty(fs_info->pinned_extents,
-			 bytenr, bytenr + num_bytes - 1, GFP_NOFS);
+/*
+ * this function must be called within transaction
+ */
+int btrfs_pin_extent(struct btrfs_root *root,
+		     u64 bytenr, u64 num_bytes, int reserved)
+{
+	struct btrfs_block_group_cache *cache;
+
+	cache = btrfs_lookup_block_group(root->fs_info, bytenr);
+	BUG_ON(!cache);
+
+	pin_down_extent(root, cache, bytenr, num_bytes, reserved);
+
+	btrfs_put_block_group(cache);
 	return 0;
 }
 
-static int update_reserved_extents(struct btrfs_block_group_cache *cache,
-				   u64 num_bytes, int reserve)
+/*
+ * update size of reserved extents. this function may return -EAGAIN
+ * if 'reserve' is true or 'sinfo' is false.
+ */
+static int update_reserved_bytes(struct btrfs_block_group_cache *cache,
+				 u64 num_bytes, int reserve, int sinfo)
 {
-	spin_lock(&cache->space_info->lock);
-	spin_lock(&cache->lock);
-	if (reserve) {
-		cache->reserved += num_bytes;
-		cache->space_info->bytes_reserved += num_bytes;
+	int ret = 0;
+	if (sinfo) {
+		struct btrfs_space_info *space_info = cache->space_info;
+		spin_lock(&space_info->lock);
+		spin_lock(&cache->lock);
+		if (reserve) {
+			if (cache->ro) {
+				ret = -EAGAIN;
+			} else {
+				cache->reserved += num_bytes;
+				space_info->bytes_reserved += num_bytes;
+			}
+		} else {
+			if (cache->ro)
+				space_info->bytes_readonly += num_bytes;
+			cache->reserved -= num_bytes;
+			space_info->bytes_reserved -= num_bytes;
+		}
+		spin_unlock(&cache->lock);
+		spin_unlock(&space_info->lock);
 	} else {
-		cache->reserved -= num_bytes;
-		cache->space_info->bytes_reserved -= num_bytes;
+		spin_lock(&cache->lock);
+		if (cache->ro) {
+			ret = -EAGAIN;
+		} else {
+			if (reserve)
+				cache->reserved += num_bytes;
+			else
+				cache->reserved -= num_bytes;
+		}
+		spin_unlock(&cache->lock);
 	}
-	spin_unlock(&cache->lock);
-	spin_unlock(&cache->space_info->lock);
-	return 0;
+	return ret;
 }
 
 int btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
@@ -3606,14 +3917,21 @@ static int unpin_extent_range(struct btr
 			btrfs_add_free_space(cache, start, len);
 		}
 
+		start += len;
+
 		spin_lock(&cache->space_info->lock);
 		spin_lock(&cache->lock);
 		cache->pinned -= len;
 		cache->space_info->bytes_pinned -= len;
+		if (cache->ro) {
+			cache->space_info->bytes_readonly += len;
+		} else if (cache->reserved_pinned > 0) {
+			len = min(len, cache->reserved_pinned);
+			cache->reserved_pinned -= len;
+			cache->space_info->bytes_reserved += len;
+		}
 		spin_unlock(&cache->lock);
 		spin_unlock(&cache->space_info->lock);
-
-		start += len;
 	}
 
 	if (cache)
@@ -3626,8 +3944,11 @@ int btrfs_finish_extent_commit(struct bt
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct extent_io_tree *unpin;
+	struct btrfs_block_rsv *block_rsv;
+	struct btrfs_block_rsv *next_rsv;
 	u64 start;
 	u64 end;
+	int idx;
 	int ret;
 
 	if (fs_info->pinned_extents == &fs_info->freed_extents[0])
@@ -3648,59 +3969,30 @@ int btrfs_finish_extent_commit(struct bt
 		cond_resched();
 	}
 
-	return ret;
-}
-
-static int pin_down_bytes(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root,
-			  struct btrfs_path *path,
-			  u64 bytenr, u64 num_bytes,
-			  int is_data, int reserved,
-			  struct extent_buffer **must_clean)
-{
-	int err = 0;
-	struct extent_buffer *buf;
-
-	if (is_data)
-		goto pinit;
-
-	/*
-	 * discard is sloooow, and so triggering discards on
-	 * individual btree blocks isn't a good plan.  Just
-	 * pin everything in discard mode.
-	 */
-	if (btrfs_test_opt(root, DISCARD))
-		goto pinit;
-
-	buf = btrfs_find_tree_block(root, bytenr, num_bytes);
-	if (!buf)
-		goto pinit;
-
-	/* we can reuse a block if it hasn't been written
-	 * and it is from this transaction.  We can't
-	 * reuse anything from the tree log root because
-	 * it has tiny sub-transactions.
-	 */
-	if (btrfs_buffer_uptodate(buf, 0) &&
-	    btrfs_try_tree_lock(buf)) {
-		u64 header_owner = btrfs_header_owner(buf);
-		u64 header_transid = btrfs_header_generation(buf);
-		if (header_owner != BTRFS_TREE_LOG_OBJECTID &&
-		    header_transid == trans->transid &&
-		    !btrfs_header_flag(buf, BTRFS_HEADER_FLAG_WRITTEN)) {
-			*must_clean = buf;
-			return 1;
+	mutex_lock(&fs_info->durable_block_rsv_mutex);
+	list_for_each_entry_safe(block_rsv, next_rsv,
+				 &fs_info->durable_block_rsv_list, list) {
+
+		idx = trans->transid & 0x1;
+		if (block_rsv->freed[idx] > 0) {
+			block_rsv_add_bytes(block_rsv,
+					    block_rsv->freed[idx], 0);
+			block_rsv->freed[idx] = 0;
+		}
+		if (atomic_read(&block_rsv->usage) == 0) {
+			btrfs_block_rsv_release(root, block_rsv, (u64)-1);
+
+			if (block_rsv->freed[0] == 0 &&
+			    block_rsv->freed[1] == 0) {
+				list_del_init(&block_rsv->list);
+				kfree(block_rsv);
+			}
+		} else {
+			btrfs_block_rsv_release(root, block_rsv, 0);
 		}
-		btrfs_tree_unlock(buf);
 	}
-	free_extent_buffer(buf);
-pinit:
-	if (path)
-		btrfs_set_path_blocking(path);
-	/* unlocks the pinned mutex */
-	btrfs_pin_extent(root, bytenr, num_bytes, reserved);
+	mutex_unlock(&fs_info->durable_block_rsv_mutex);
 
-	BUG_ON(err < 0);
 	return 0;
 }
 
@@ -3861,9 +4153,6 @@ static int __btrfs_free_extent(struct bt
 			BUG_ON(ret);
 		}
 	} else {
-		int mark_free = 0;
-		struct extent_buffer *must_clean = NULL;
-
 		if (found_extent) {
 			BUG_ON(is_data && refs_to_drop !=
 			       extent_data_ref_count(root, path, iref));
@@ -3876,31 +4165,11 @@ static int __btrfs_free_extent(struct bt
 			}
 		}
 
-		ret = pin_down_bytes(trans, root, path, bytenr,
-				     num_bytes, is_data, 0, &must_clean);
-		if (ret > 0)
-			mark_free = 1;
-		BUG_ON(ret < 0);
-		/*
-		 * it is going to be very rare for someone to be waiting
-		 * on the block we're freeing.  del_items might need to
-		 * schedule, so rather than get fancy, just force it
-		 * to blocking here
-		 */
-		if (must_clean)
-			btrfs_set_lock_blocking(must_clean);
-
 		ret = btrfs_del_items(trans, extent_root, path, path->slots[0],
 				      num_to_del);
 		BUG_ON(ret);
 		btrfs_release_path(extent_root, path);
 
-		if (must_clean) {
-			clean_tree_block(NULL, root, must_clean);
-			btrfs_tree_unlock(must_clean);
-			free_extent_buffer(must_clean);
-		}
-
 		if (is_data) {
 			ret = btrfs_del_csums(trans, root, bytenr, num_bytes);
 			BUG_ON(ret);
@@ -3910,8 +4179,7 @@ static int __btrfs_free_extent(struct bt
 			     (bytenr + num_bytes - 1) >> PAGE_CACHE_SHIFT);
 		}
 
-		ret = update_block_group(trans, root, bytenr, num_bytes, 0,
-					 mark_free);
+		ret = update_block_group(trans, root, bytenr, num_bytes, 0);
 		BUG_ON(ret);
 	}
 	btrfs_free_path(path);
@@ -3919,7 +4187,7 @@ static int __btrfs_free_extent(struct bt
 }
 
 /*
- * when we free an extent, it is possible (and likely) that we free the last
+ * when we free an block, it is possible (and likely) that we free the last
  * delayed ref for that extent as well.  This searches the delayed ref tree for
  * a given extent, and if there are no other delayed refs to be processed, it
  * removes it from the tree.
@@ -3931,7 +4199,7 @@ static noinline int check_ref_cleanup(st
 	struct btrfs_delayed_ref_root *delayed_refs;
 	struct btrfs_delayed_ref_node *ref;
 	struct rb_node *node;
-	int ret;
+	int ret = 0;
 
 	delayed_refs = &trans->transaction->delayed_refs;
 	spin_lock(&delayed_refs->lock);
@@ -3983,17 +4251,99 @@ static noinline int check_ref_cleanup(st
 	list_del_init(&head->cluster);
 	spin_unlock(&delayed_refs->lock);
 
-	ret = run_one_delayed_ref(trans, root->fs_info->tree_root,
-				  &head->node, head->extent_op,
-				  head->must_insert_reserved);
-	BUG_ON(ret);
+	BUG_ON(head->extent_op);
+	if (head->must_insert_reserved)
+		ret = 1;
+
+	mutex_unlock(&head->mutex);
 	btrfs_put_delayed_ref(&head->node);
-	return 0;
+	return ret;
 out:
 	spin_unlock(&delayed_refs->lock);
 	return 0;
 }
 
+void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
+			   struct btrfs_root *root,
+			   struct extent_buffer *buf,
+			   u64 parent, int last_ref)
+{
+	struct btrfs_block_rsv *block_rsv;
+	struct btrfs_block_group_cache *cache = NULL;
+	int ret;
+
+	if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID) {
+		ret = btrfs_add_delayed_tree_ref(trans, buf->start, buf->len,
+						parent, root->root_key.objectid,
+						btrfs_header_level(buf),
+						BTRFS_DROP_DELAYED_REF, NULL);
+		BUG_ON(ret);
+	}
+
+	if (!last_ref)
+		return;
+
+	block_rsv = get_block_rsv(trans, root);
+	cache = btrfs_lookup_block_group(root->fs_info, buf->start);
+	BUG_ON(block_rsv->space_info != cache->space_info);
+
+	if (btrfs_header_generation(buf) == trans->transid) {
+		if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID) {
+			ret = check_ref_cleanup(trans, root, buf->start);
+			if (!ret)
+				goto pin;
+		}
+
+		if (btrfs_header_flag(buf, BTRFS_HEADER_FLAG_WRITTEN)) {
+			pin_down_extent(root, cache, buf->start, buf->len, 1);
+			goto pin;
+		}
+
+		WARN_ON(test_bit(EXTENT_BUFFER_DIRTY, &buf->bflags));
+
+		btrfs_add_free_space(cache, buf->start, buf->len);
+		ret = update_reserved_bytes(cache, buf->len, 0, 0);
+		if (ret == -EAGAIN) {
+			/* block group became read-only */
+			update_reserved_bytes(cache, buf->len, 0, 1);
+			goto out;
+		}
+
+		ret = 1;
+		spin_lock(&block_rsv->lock);
+		if (block_rsv->reserved < block_rsv->size) {
+			block_rsv->reserved += buf->len;
+			ret = 0;
+		}
+		spin_unlock(&block_rsv->lock);
+
+		if (ret) {
+			spin_lock(&cache->space_info->lock);
+			cache->space_info->bytes_reserved -= buf->len;
+			spin_unlock(&cache->space_info->lock);
+		}
+		goto out;
+	}
+pin:
+	if (block_rsv->durable && !cache->ro) {
+		ret = 0;
+		spin_lock(&cache->lock);
+		if (!cache->ro) {
+			cache->reserved_pinned += buf->len;
+			ret = 1;
+		}
+		spin_unlock(&cache->lock);
+
+		if (ret) {
+			spin_lock(&block_rsv->lock);
+			block_rsv->freed[trans->transid & 0x1] += buf->len;
+			spin_unlock(&block_rsv->lock);
+		}
+	}
+out:
+	btrfs_put_block_group(cache);
+}
+
 int btrfs_free_extent(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root,
 		      u64 bytenr, u64 num_bytes, u64 parent,
@@ -4015,8 +4365,6 @@ int btrfs_free_extent(struct btrfs_trans
 					parent, root_objectid, (int)owner,
 					BTRFS_DROP_DELAYED_REF, NULL);
 		BUG_ON(ret);
-		ret = check_ref_cleanup(trans, root, bytenr);
-		BUG_ON(ret);
 	} else {
 		ret = btrfs_add_delayed_data_ref(trans, bytenr, num_bytes,
 					parent, root_objectid, owner,
@@ -4026,21 +4374,6 @@ int btrfs_free_extent(struct btrfs_trans
 	return ret;
 }
 
-int btrfs_free_tree_block(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root,
-			  u64 bytenr, u32 blocksize,
-			  u64 parent, u64 root_objectid, int level)
-{
-	u64 used;
-	spin_lock(&root->node_lock);
-	used = btrfs_root_used(&root->root_item) - blocksize;
-	btrfs_set_root_used(&root->root_item, used);
-	spin_unlock(&root->node_lock);
-
-	return btrfs_free_extent(trans, root, bytenr, blocksize,
-				 parent, root_objectid, level, 0);
-}
-
 static u64 stripe_align(struct btrfs_root *root, u64 val)
 {
 	u64 mask = ((u64)root->stripesize - 1);
@@ -4130,7 +4463,6 @@ static noinline int find_free_extent(str
 				     u64 num_bytes, u64 empty_size,
 				     u64 search_start, u64 search_end,
 				     u64 hint_byte, struct btrfs_key *ins,
-				     u64 exclude_start, u64 exclude_nr,
 				     int data)
 {
 	int ret = 0;
@@ -4142,8 +4474,8 @@ static noinline int find_free_extent(str
 	int done_chunk_alloc = 0;
 	struct btrfs_space_info *space_info;
 	int last_ptr_loop = 0;
-	int index = 0;
 	int loop = 0;
+	int index = 0;
 	bool found_uncached_bg = false;
 	bool failed_cluster_refill = false;
 	bool failed_alloc = false;
@@ -4414,23 +4746,22 @@ checks:
 			goto loop;
 		}
 
-		if (exclude_nr > 0 &&
-		    (search_start + num_bytes > exclude_start &&
-		     search_start < exclude_start + exclude_nr)) {
-			search_start = exclude_start + exclude_nr;
+		ins->objectid = search_start;
+		ins->offset = num_bytes;
 
+		if (offset < search_start)
+			btrfs_add_free_space(block_group, offset,
+					     search_start - offset);
+		BUG_ON(offset > search_start);
+
+		ret = update_reserved_bytes(block_group, num_bytes, 1,
+					    (data & BTRFS_BLOCK_GROUP_DATA));
+		if (ret == -EAGAIN) {
 			btrfs_add_free_space(block_group, offset, num_bytes);
-			/*
-			 * if search_start is still in this block group
-			 * then we just re-search this block group
-			 */
-			if (search_start >= block_group->key.objectid &&
-			    search_start < (block_group->key.objectid +
-					    block_group->key.offset))
-				goto have_block_group;
 			goto loop;
 		}
 
+		/* we are all good, lets return */
 		ins->objectid = search_start;
 		ins->offset = num_bytes;
 
@@ -4438,10 +4769,6 @@ checks:
 			btrfs_add_free_space(block_group, offset,
 					     search_start - offset);
 		BUG_ON(offset > search_start);
-
-		update_reserved_extents(block_group, num_bytes, 1);
-
-		/* we are all good, lets return */
 		break;
 loop:
 		failed_cluster_refill = false;
@@ -4615,9 +4942,8 @@ again:
 
 	WARN_ON(num_bytes < root->sectorsize);
 	ret = find_free_extent(trans, root, num_bytes, empty_size,
-			       search_start, search_end, hint_byte, ins,
-			       trans->alloc_exclude_start,
-			       trans->alloc_exclude_nr, data);
+			       search_start, search_end, hint_byte,
+			       ins, data);
 
 	if (ret == -ENOSPC && num_bytes > min_alloc_size) {
 		num_bytes = num_bytes >> 1;
@@ -4655,7 +4981,7 @@ int btrfs_free_reserved_extent(struct bt
 	ret = btrfs_discard_extent(root, start, len);
 
 	btrfs_add_free_space(cache, start, len);
-	update_reserved_extents(cache, len, 0);
+	update_reserved_bytes(cache, len, 0, 1);
 	btrfs_put_block_group(cache);
 
 	return ret;
@@ -4718,8 +5044,7 @@ static int alloc_reserved_file_extent(st
 	btrfs_mark_buffer_dirty(path->nodes[0]);
 	btrfs_free_path(path);
 
-	ret = update_block_group(trans, root, ins->objectid, ins->offset,
-				 1, 0);
+	ret = update_block_group(trans, root, ins->objectid, ins->offset, 1);
 	if (ret) {
 		printk(KERN_ERR "btrfs update block group failed for %llu "
 		       "%llu\n", (unsigned long long)ins->objectid,
@@ -4779,8 +5104,7 @@ static int alloc_reserved_tree_block(str
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_free_path(path);
 
-	ret = update_block_group(trans, root, ins->objectid, ins->offset,
-				 1, 0);
+	ret = update_block_group(trans, root, ins->objectid, ins->offset, 1);
 	if (ret) {
 		printk(KERN_ERR "btrfs update block group failed for %llu "
 		       "%llu\n", (unsigned long long)ins->objectid,
@@ -4856,73 +5180,14 @@ int btrfs_alloc_logged_file_extent(struc
 		put_caching_control(caching_ctl);
 	}
 
-	update_reserved_extents(block_group, ins->offset, 1);
+	ret = update_reserved_bytes(block_group, ins->offset, 1, 1);
+	BUG_ON(ret);
 	btrfs_put_block_group(block_group);
 	ret = alloc_reserved_file_extent(trans, root, 0, root_objectid,
 					 0, owner, offset, ins, 1);
 	return ret;
 }
 
-/*
- * finds a free extent and does all the dirty work required for allocation
- * returns the key for the extent through ins, and a tree buffer for
- * the first block of the extent through buf.
- *
- * returns 0 if everything worked, non-zero otherwise.
- */
-static int alloc_tree_block(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root,
-			    u64 num_bytes, u64 parent, u64 root_objectid,
-			    struct btrfs_disk_key *key, int level,
-			    u64 empty_size, u64 hint_byte, u64 search_end,
-			    struct btrfs_key *ins)
-{
-	int ret;
-	u64 flags = 0;
-
-	ret = btrfs_reserve_extent(trans, root, num_bytes, num_bytes,
-				   empty_size, hint_byte, search_end,
-				   ins, 0);
-	if (ret)
-		return ret;
-
-	if (root_objectid == BTRFS_TREE_RELOC_OBJECTID) {
-		if (parent == 0)
-			parent = ins->objectid;
-		flags |= BTRFS_BLOCK_FLAG_FULL_BACKREF;
-	} else
-		BUG_ON(parent > 0);
-
-	if (root_objectid != BTRFS_TREE_LOG_OBJECTID) {
-		struct btrfs_delayed_extent_op *extent_op;
-		extent_op = kmalloc(sizeof(*extent_op), GFP_NOFS);
-		BUG_ON(!extent_op);
-		if (key)
-			memcpy(&extent_op->key, key, sizeof(extent_op->key));
-		else
-			memset(&extent_op->key, 0, sizeof(extent_op->key));
-		extent_op->flags_to_set = flags;
-		extent_op->update_key = 1;
-		extent_op->update_flags = 1;
-		extent_op->is_data = 0;
-
-		ret = btrfs_add_delayed_tree_ref(trans, ins->objectid,
-					ins->offset, parent, root_objectid,
-					level, BTRFS_ADD_DELAYED_EXTENT,
-					extent_op);
-		BUG_ON(ret);
-	}
-
-	if (root_objectid == root->root_key.objectid) {
-		u64 used;
-		spin_lock(&root->node_lock);
-		used = btrfs_root_used(&root->root_item) + num_bytes;
-		btrfs_set_root_used(&root->root_item, used);
-		spin_unlock(&root->node_lock);
-	}
-	return ret;
-}
-
 struct extent_buffer *btrfs_init_new_buffer(struct btrfs_trans_handle *trans,
 					    struct btrfs_root *root,
 					    u64 bytenr, u32 blocksize,
@@ -4961,8 +5226,45 @@ struct extent_buffer *btrfs_init_new_buf
 	return buf;
 }
 
+static struct btrfs_block_rsv *
+use_block_rsv(struct btrfs_trans_handle *trans,
+	      struct btrfs_root *root, u32 blocksize)
+{
+	struct btrfs_block_rsv *block_rsv;
+	int ret;
+
+	block_rsv = get_block_rsv(trans, root);
+
+	if (block_rsv->size == 0) {
+		ret = reserve_metadata_bytes(block_rsv, blocksize);
+		if (ret)
+			return ERR_PTR(ret);
+		return block_rsv;
+	}
+
+	ret = block_rsv_use_bytes(block_rsv, blocksize);
+	if (!ret)
+		return block_rsv;
+
+	WARN_ON(1);
+	printk(KERN_INFO"block_rsv size %llu reserved %llu freed %llu %llu\n",
+		block_rsv->size, block_rsv->reserved,
+		block_rsv->freed[0], block_rsv->freed[1]);
+
+	return ERR_PTR(-ENOSPC);
+}
+
+static void unuse_block_rsv(struct btrfs_block_rsv *block_rsv, u32 blocksize)
+{
+	block_rsv_add_bytes(block_rsv, blocksize, 0);
+	block_rsv_release_bytes(block_rsv, NULL, 0);
+}
+
 /*
- * helper function to allocate a block for a given tree
+ * finds a free extent and does all the dirty work required for allocation
+ * returns the key for the extent through ins, and a tree buffer for
+ * the first block of the extent through buf.
+ *
  * returns the tree buffer or NULL.
  */
 struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
@@ -4972,18 +5274,53 @@ struct extent_buffer *btrfs_alloc_free_b
 					u64 hint, u64 empty_size)
 {
 	struct btrfs_key ins;
-	int ret;
+	struct btrfs_block_rsv *block_rsv;
 	struct extent_buffer *buf;
+	u64 flags = 0;
+	int ret;
+
+
+	block_rsv = use_block_rsv(trans, root, blocksize);
+	if (IS_ERR(block_rsv))
+		return ERR_CAST(block_rsv);
 
-	ret = alloc_tree_block(trans, root, blocksize, parent, root_objectid,
-			       key, level, empty_size, hint, (u64)-1, &ins);
+	ret = btrfs_reserve_extent(trans, root, blocksize, blocksize,
+				   empty_size, hint, (u64)-1, &ins, 0);
 	if (ret) {
-		BUG_ON(ret > 0);
+		unuse_block_rsv(block_rsv, blocksize);
 		return ERR_PTR(ret);
 	}
 
 	buf = btrfs_init_new_buffer(trans, root, ins.objectid,
 				    blocksize, level);
+	BUG_ON(IS_ERR(buf));
+
+	if (root_objectid == BTRFS_TREE_RELOC_OBJECTID) {
+		if (parent == 0)
+			parent = ins.objectid;
+		flags |= BTRFS_BLOCK_FLAG_FULL_BACKREF;
+	} else
+		BUG_ON(parent > 0);
+
+	if (root_objectid != BTRFS_TREE_LOG_OBJECTID) {
+		struct btrfs_delayed_extent_op *extent_op;
+		extent_op = kmalloc(sizeof(*extent_op), GFP_NOFS);
+		BUG_ON(!extent_op);
+		if (key)
+			memcpy(&extent_op->key, key, sizeof(extent_op->key));
+		else
+			memset(&extent_op->key, 0, sizeof(extent_op->key));
+		extent_op->flags_to_set = flags;
+		extent_op->update_key = 1;
+		extent_op->update_flags = 1;
+		extent_op->is_data = 0;
+
+		ret = btrfs_add_delayed_tree_ref(trans, ins.objectid,
+					ins.offset, parent, root_objectid,
+					level, BTRFS_ADD_DELAYED_EXTENT,
+					extent_op);
+		BUG_ON(ret);
+	}
 	return buf;
 }
 
@@ -5308,7 +5645,7 @@ static noinline int walk_up_proc(struct 
 				 struct btrfs_path *path,
 				 struct walk_control *wc)
 {
-	int ret = 0;
+	int ret;
 	int level = wc->level;
 	struct extent_buffer *eb = path->nodes[level];
 	u64 parent = 0;
@@ -5386,13 +5723,11 @@ static noinline int walk_up_proc(struct 
 			       btrfs_header_owner(path->nodes[level + 1]));
 	}
 
-	ret = btrfs_free_extent(trans, root, eb->start, eb->len, parent,
-				root->root_key.objectid, level, 0);
-	BUG_ON(ret);
+	btrfs_free_tree_block(trans, root, eb, parent, wc->refs[level] == 1);
 out:
 	wc->refs[level] = 0;
 	wc->flags[level] = 0;
-	return ret;
+	return 0;
 }
 
 static noinline int walk_down_tree(struct btrfs_trans_handle *trans,
@@ -7215,48 +7550,80 @@ static u64 update_block_group_flags(stru
 	return flags;
 }
 
-static int __alloc_chunk_for_shrink(struct btrfs_root *root,
-		     struct btrfs_block_group_cache *shrink_block_group,
-		     int force)
+static int set_block_group_ro(struct btrfs_block_group_cache *cache)
 {
-	struct btrfs_trans_handle *trans;
-	u64 new_alloc_flags;
-	u64 calc;
+	struct btrfs_space_info *sinfo = cache->space_info;
+	u64 num_bytes;
+	int ret = -ENOSPC;
 
-	spin_lock(&shrink_block_group->lock);
-	if (btrfs_block_group_used(&shrink_block_group->item) +
-	    shrink_block_group->reserved > 0) {
-		spin_unlock(&shrink_block_group->lock);
+	if (cache->ro)
+		return 0;
 
-		trans = btrfs_start_transaction(root, 1);
-		spin_lock(&shrink_block_group->lock);
+	spin_lock(&sinfo->lock);
+	spin_lock(&cache->lock);
+	num_bytes = cache->key.offset - cache->reserved - cache->pinned -
+		    cache->bytes_super - btrfs_block_group_used(&cache->item);
 
-		new_alloc_flags = update_block_group_flags(root,
-						   shrink_block_group->flags);
-		if (new_alloc_flags != shrink_block_group->flags) {
-			calc =
-			     btrfs_block_group_used(&shrink_block_group->item);
-		} else {
-			calc = shrink_block_group->key.offset;
-		}
-		spin_unlock(&shrink_block_group->lock);
+	if (sinfo->bytes_used + sinfo->bytes_reserved + sinfo->bytes_pinned +
+	    sinfo->bytes_may_use + sinfo->bytes_readonly +
+	    cache->reserved_pinned + num_bytes < sinfo->total_bytes) {
+		sinfo->bytes_readonly += num_bytes;
+		sinfo->bytes_reserved += cache->reserved_pinned;
+		cache->reserved_pinned = 0;
+		cache->ro = 1;
+		ret = 0;
+	}
+	spin_unlock(&cache->lock);
+	spin_unlock(&sinfo->lock);
+	return ret;
+}
 
-		do_chunk_alloc(trans, root->fs_info->extent_root,
-			       calc + 2 * 1024 * 1024, new_alloc_flags, force);
+int btrfs_set_block_group_ro(struct btrfs_root *root,
+			     struct btrfs_block_group_cache *cache)
 
-		btrfs_end_transaction(trans, root);
-	} else
-		spin_unlock(&shrink_block_group->lock);
-	return 0;
-}
+{
+	struct btrfs_trans_handle *trans;
+	u64 alloc_flags;
+	int ret;
 
+	BUG_ON(cache->ro);
 
-int btrfs_prepare_block_group_relocation(struct btrfs_root *root,
-					 struct btrfs_block_group_cache *group)
+	trans = btrfs_join_transaction(root, 1);
+	BUG_ON(IS_ERR(trans));
 
+	alloc_flags = update_block_group_flags(root, cache->flags);
+	if (alloc_flags != cache->flags)
+		do_chunk_alloc(trans, root, 2 * 1024 * 1024, alloc_flags, 1);
+
+	ret = set_block_group_ro(cache);
+	if (!ret)
+		goto out;
+	alloc_flags = get_alloc_profile(root, cache->space_info->flags);
+	ret = do_chunk_alloc(trans, root, 2 * 1024 * 1024, alloc_flags, 1);
+	if (ret < 0)
+		goto out;
+	ret = set_block_group_ro(cache);
+out:
+	btrfs_end_transaction(trans, root);
+	return ret;
+}
+
+int btrfs_set_block_group_rw(struct btrfs_root *root,
+			      struct btrfs_block_group_cache *cache)
 {
-	__alloc_chunk_for_shrink(root, group, 1);
-	set_block_group_readonly(group);
+	struct btrfs_space_info *sinfo = cache->space_info;
+	u64 num_bytes;
+
+	BUG_ON(!cache->ro);
+
+	spin_lock(&sinfo->lock);
+	spin_lock(&cache->lock);
+	num_bytes = cache->key.offset - cache->reserved - cache->pinned -
+		    cache->bytes_super - btrfs_block_group_used(&cache->item);
+	sinfo->bytes_readonly -= num_bytes;
+	cache->ro = 0;
+	spin_unlock(&cache->lock);
+	spin_unlock(&sinfo->lock);
 	return 0;
 }
 
@@ -7427,7 +7794,11 @@ int btrfs_free_block_groups(struct btrfs
 		space_info = list_entry(info->space_info.next,
 					struct btrfs_space_info,
 					list);
-
+		if (space_info->bytes_pinned > 0 ||
+		    space_info->bytes_reserved > 0) {
+			WARN_ON(1);
+			dump_space_info(space_info, 0, 0);
+		}
 		list_del(&space_info->list);
 		kfree(space_info);
 	}
@@ -7475,7 +7846,7 @@ int btrfs_read_block_groups(struct btrfs
 		cache = kzalloc(sizeof(*cache), GFP_NOFS);
 		if (!cache) {
 			ret = -ENOMEM;
-			break;
+			goto error;
 		}
 
 		atomic_set(&cache->count, 1);
@@ -7532,7 +7903,7 @@ int btrfs_read_block_groups(struct btrfs
 		BUG_ON(ret);
 		cache->space_info = space_info;
 		spin_lock(&cache->space_info->lock);
-		cache->space_info->bytes_super += cache->bytes_super;
+		cache->space_info->bytes_readonly += cache->bytes_super;
 		spin_unlock(&cache->space_info->lock);
 
 		__link_block_group(space_info, cache);
@@ -7542,7 +7913,7 @@ int btrfs_read_block_groups(struct btrfs
 
 		set_avail_alloc_bits(root->fs_info, cache->flags);
 		if (btrfs_chunk_readonly(root, cache->key.objectid))
-			set_block_group_readonly(cache);
+			set_block_group_ro(cache);
 	}
 
 	list_for_each_entry_rcu(space_info, &root->fs_info->space_info, list) {
@@ -7556,10 +7927,12 @@ int btrfs_read_block_groups(struct btrfs
 		 * mirrored block groups.
 		 */
 		list_for_each_entry(cache, &space_info->block_groups[3], list)
-			set_block_group_readonly(cache);
+			set_block_group_ro(cache);
 		list_for_each_entry(cache, &space_info->block_groups[4], list)
-			set_block_group_readonly(cache);
+			set_block_group_ro(cache);
 	}
+
+	init_global_block_rsv(info);
 	ret = 0;
 error:
 	btrfs_free_path(path);
@@ -7620,7 +7993,7 @@ int btrfs_make_block_group(struct btrfs_
 	BUG_ON(ret);
 
 	spin_lock(&cache->space_info->lock);
-	cache->space_info->bytes_super += cache->bytes_super;
+	cache->space_info->bytes_readonly += cache->bytes_super;
 	spin_unlock(&cache->space_info->lock);
 
 	__link_block_group(cache->space_info, cache);
diff -urp 2/fs/btrfs/relocation.c 3/fs/btrfs/relocation.c
--- 2/fs/btrfs/relocation.c	2010-04-26 17:24:55.238079821 +0800
+++ 3/fs/btrfs/relocation.c	2010-04-26 17:24:55.253080191 +0800
@@ -3513,6 +3513,7 @@ int btrfs_relocate_block_group(struct bt
 	struct btrfs_fs_info *fs_info = extent_root->fs_info;
 	struct reloc_control *rc;
 	int ret;
+	int rw = 0;
 	int err = 0;
 
 	rc = kzalloc(sizeof(*rc), GFP_NOFS);
@@ -3523,15 +3524,22 @@ int btrfs_relocate_block_group(struct bt
 	extent_io_tree_init(&rc->processed_blocks, NULL, GFP_NOFS);
 	INIT_LIST_HEAD(&rc->reloc_roots);
 
+	rc->extent_root = extent_root;
 	rc->block_group = btrfs_lookup_block_group(fs_info, group_start);
 	BUG_ON(!rc->block_group);
 
+	if (!rc->block_group->ro) {
+		ret = btrfs_set_block_group_ro(extent_root, rc->block_group);
+		if (ret) {
+			err = ret;
+			goto out;
+		}
+		rw = 1;
+	}
+
 	btrfs_init_workers(&rc->workers, "relocate",
 			   fs_info->thread_pool_size, NULL);
 
-	rc->extent_root = extent_root;
-	btrfs_prepare_block_group_relocation(extent_root, rc->block_group);
-
 	rc->data_inode = create_reloc_inode(fs_info, rc->block_group);
 	if (IS_ERR(rc->data_inode)) {
 		err = PTR_ERR(rc->data_inode);
@@ -3596,6 +3604,8 @@ int btrfs_relocate_block_group(struct bt
 	WARN_ON(rc->block_group->reserved > 0);
 	WARN_ON(btrfs_block_group_used(&rc->block_group->item) > 0);
 out:
+	if (err && rw)
+		btrfs_set_block_group_rw(extent_root, rc->block_group);
 	iput(rc->data_inode);
 	btrfs_stop_workers(&rc->workers);
 	btrfs_put_block_group(rc->block_group);
diff -urp 2/fs/btrfs/transaction.c 3/fs/btrfs/transaction.c
--- 2/fs/btrfs/transaction.c	2010-04-26 17:24:55.222858330 +0800
+++ 3/fs/btrfs/transaction.c	2010-04-26 17:24:55.253080191 +0800
@@ -184,9 +184,8 @@ static struct btrfs_trans_handle *start_
 	h->blocks_reserved = num_blocks;
 	h->blocks_used = 0;
 	h->block_group = 0;
-	h->alloc_exclude_nr = 0;
-	h->alloc_exclude_start = 0;
 	h->delayed_ref_updates = 0;
+	h->block_rsv = NULL;
 
 	if (!current->journal_info && type != TRANS_USERSPACE)
 		current->journal_info = h;
diff -urp 2/fs/btrfs/transaction.h 3/fs/btrfs/transaction.h
--- 2/fs/btrfs/transaction.h	2010-04-26 17:24:55.226081480 +0800
+++ 3/fs/btrfs/transaction.h	2010-04-26 17:24:55.254080681 +0800
@@ -45,13 +45,13 @@ struct btrfs_transaction {
 
 struct btrfs_trans_handle {
 	u64 transid;
+	u64 block_group;
+	u64 bytes_reserved;
 	unsigned long blocks_reserved;
 	unsigned long blocks_used;
-	struct btrfs_transaction *transaction;
-	u64 block_group;
-	u64 alloc_exclude_start;
-	u64 alloc_exclude_nr;
 	unsigned long delayed_ref_updates;
+	struct btrfs_transaction *transaction;
+	struct btrfs_block_rsv *block_rsv;
 };
 
 struct btrfs_pending_snapshot {
Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
