From: Zheng Yan <zheng.yan@oracle.com>
Subject: [PATCH 4/4] update space balancing code
Date: Fri, 26 Sep 2008 00:51:23 +0800
Message-ID: <48DBC18B.8000702@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This patch updates the space balancing code to utilize the new
backref format. the new code can keeps the sharing of all data
extents and most of tree blocks.

To kepping the sharing of data extents, the space balance code
uses a seperate inode to move data, then updates the references
to point to the new location.

To keep the sharing of tree blocks, the space balance code uses
reloc trees to relocate tree blocks in reference counted roots.
There is one reloc tree for each subvol, all reloc trees share
same root key objectid. Reloc trees are snapshots of the latest
committed roots of subvols (root->commit_root). To relocate a
tree block referenced by a subvol, there are two steps. COW the
block through subvol's reloc tree, then update block pointer in
the subvol to point to the new block. Since all reloc trees share
same root key objectid, doing special handing for tree blocks
owned by them is easy. Once a tree block has been COWed in one
reloc tree, we can use the resulting new block directly when the
same block is required to COW again through other reloc trees.
By this way, relocated tree blocks are shared between reloc trees,
so they are also shared between subvols.

Regards
Yan Zheng

---
diff -r 6257b2588438 ctree.c
--- a/ctree.c	Thu Sep 25 14:38:26 2008 +0800
+++ b/ctree.c	Fri Sep 26 00:43:14 2008 +0800
@@ -179,7 +179,6 @@
 	struct extent_buffer *cow;
 	u32 nritems;
 	int ret = 0;
-	int different_trans = 0;
 	int level;
 	int unlock_orig = 0;
 
@@ -233,18 +232,46 @@
 	WARN_ON(btrfs_header_generation(buf) > trans->transid);
 	if (btrfs_header_generation(buf) != trans->transid) {
 		u32 nr_extents;
-		different_trans = 1;
 		ret = btrfs_inc_ref(trans, root, buf, cow, &nr_extents);
 		if (ret)
 			return ret;
 
 		ret = btrfs_cache_ref(trans, root, buf, nr_extents);
 		WARN_ON(ret);
+	} else if (btrfs_header_owner(buf) == BTRFS_TREE_RELOC_OBJECTID) {
+		/*
+		 * There are only two places that can drop reference to
+		 * tree blocks owned by living reloc trees, one is here,
+		 * the other place is btrfs_merge_path. In both places,
+		 * we check reference count while tree block is locked.
+		 * Furthermore, if reference count is one, it won't get
+		 * increased by someone else.
+		 */
+		u32 refs;
+		ret = btrfs_lookup_extent_ref(trans, root, buf->start,
+					      buf->len, &refs);
+		BUG_ON(ret);
+		if (refs == 1) {
+			ret = btrfs_update_ref(trans, root, buf, cow,
+					       0, nritems);
+			clean_tree_block(trans, root, buf);
+		} else {
+			ret = btrfs_inc_ref(trans, root, buf, cow, NULL);
+		}
+		BUG_ON(ret);
 	} else {
 		ret = btrfs_update_ref(trans, root, buf, cow, 0, nritems);
 		if (ret)
 			return ret;
 		clean_tree_block(trans, root, buf);
+	}
+
+	if (root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID) {
+		ret = btrfs_add_reloc_mapping(root, buf->start,
+					      buf->len, cow->start);
+		BUG_ON(ret);
+		ret = btrfs_reloc_tree_cache_ref(trans, root, cow, buf->start);
+		WARN_ON(ret);
 	}
 
 	if (buf == root->node) {
@@ -1464,6 +1491,130 @@
 	}
 
 	return ret;
+}
+
+int btrfs_merge_path(struct btrfs_trans_handle *trans,
+		     struct btrfs_root *root,
+		     struct btrfs_key *node_keys,
+		     u64 *nodes, int lowest_level)
+{
+	struct extent_buffer *eb;
+	struct extent_buffer *parent;
+	struct btrfs_key key;
+	u64 bytenr;
+	u64 generation;
+	u32 blocksize;
+	int level;
+	int slot;
+	int key_match;
+	int ret;
+
+	eb = btrfs_lock_root_node(root);
+	ret = btrfs_cow_block(trans, root, eb, NULL, 0, &eb, 0);
+	BUG_ON(ret);
+
+	parent = eb;
+	while (1) {
+		level = btrfs_header_level(parent);
+		if (level == 0 || level <= lowest_level)
+			break;
+
+		ret = bin_search(parent, &node_keys[lowest_level], level,
+				 &slot);
+		if (ret && slot > 0)
+			slot--;
+
+		bytenr = btrfs_node_blockptr(parent, slot);
+		if (nodes[level - 1] == bytenr)
+			break;
+
+		blocksize = btrfs_level_size(root, level - 1);
+		generation = btrfs_node_ptr_generation(parent, slot);
+		btrfs_node_key_to_cpu(eb, &key, slot);
+		key_match = !memcmp(&key, &node_keys[level - 1], sizeof(key));
+
+		/*
+		 * if node keys match and node pointer hasn't been modified
+		 * in the running transaction, we can merge the path. for
+		 * reloc trees, the node pointer check is skipped, this is
+		 * because the reloc trees are fully controlled by the space
+		 * balance code, no one else can modify them.
+		 */
+		if (!nodes[level - 1] || !key_match ||
+		    (generation == trans->transid &&
+		     root->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID)) {
+next_level:
+			if (level == 1 || level == lowest_level + 1)
+				break;
+
+			eb = read_tree_block(root, bytenr, blocksize,
+					     generation);
+			btrfs_tree_lock(eb);
+
+			ret = btrfs_cow_block(trans, root, eb, parent, slot,
+					      &eb, 0);
+			BUG_ON(ret);
+
+			btrfs_tree_unlock(parent);
+			free_extent_buffer(parent);
+			parent = eb;
+			continue;
+		}
+
+		if (generation == trans->transid) {
+			u32 refs;
+			BUG_ON(btrfs_header_owner(eb) !=
+			       BTRFS_TREE_RELOC_OBJECTID);
+			/*
+			 * lock the block to keep __btrfs_cow_block from
+			 * changing the reference count.
+			 */
+			eb = read_tree_block(root, bytenr, blocksize,
+					     generation);
+			btrfs_tree_lock(eb);
+
+			ret = btrfs_lookup_extent_ref(trans, root, bytenr,
+						      blocksize, &refs);
+			BUG_ON(ret);
+			/*
+			 * if replace block whose reference count is one,
+			 * we have to "drop the subtree". so skip it for
+			 * simplicity
+			 */
+			if (refs == 1) {
+				btrfs_tree_unlock(eb);
+				free_extent_buffer(eb);
+				goto next_level;
+			}
+		}
+
+		btrfs_set_node_blockptr(parent, slot, nodes[level - 1]);
+		btrfs_set_node_ptr_generation(parent, slot, trans->transid);
+		btrfs_mark_buffer_dirty(parent);
+
+		ret = btrfs_inc_extent_ref(trans, root,
+					nodes[level - 1],
+					blocksize, parent->start,
+					btrfs_header_owner(parent),
+					btrfs_header_generation(parent),
+					level - 1, 0);
+		BUG_ON(ret);
+		ret = btrfs_free_extent(trans, root, bytenr,
+					blocksize, parent->start,
+					btrfs_header_owner(parent),
+					btrfs_header_generation(parent),
+					level - 1, 0, 1);
+		BUG_ON(ret);
+
+		if (generation == trans->transid) {
+			btrfs_tree_unlock(eb);
+			free_extent_buffer(eb);
+		}
+		break;
+	}
+	btrfs_tree_unlock(parent);
+	free_extent_buffer(parent);
+	return 0;
 }
 
 /*
diff -r 6257b2588438 ctree.h
--- a/ctree.h	Thu Sep 25 14:38:26 2008 +0800
+++ b/ctree.h	Fri Sep 26 00:43:14 2008 +0800
@@ -604,6 +604,7 @@
 	struct mutex chunk_mutex;
 	struct mutex drop_mutex;
 	struct mutex volume_mutex;
+	struct mutex tree_reloc_mutex;
 	struct list_head trans_list;
 	struct list_head hashers;
 	struct list_head dead_roots;
@@ -647,6 +648,10 @@
 	struct task_struct *cleaner_kthread;
 	int thread_pool_size;
 
+	/* tree relocation relocated fields */
+	struct extent_io_tree reloc_mapping_tree;
+	struct list_head dead_reloc_roots;
+	struct btrfs_leaf_ref_tree reloc_ref_tree;
 	struct btrfs_leaf_ref_tree shared_ref_tree;
 
 	struct kobject super_kobj;
@@ -698,6 +703,7 @@
 	struct btrfs_leaf_ref_tree ref_tree_struct;
 	struct btrfs_dirty_root *dirty_root;
 	struct btrfs_root *log_root;
+	struct btrfs_root *reloc_root;
 
 	struct btrfs_root_item root_item;
 	struct btrfs_key root_key;
@@ -1520,7 +1526,6 @@
 struct extent_buffer *btrfs_init_new_buffer(struct btrfs_trans_handle *trans,
 					    struct btrfs_root *root,
 					    u64 bytenr, u32 blocksize);
-int btrfs_shrink_extent_tree(struct btrfs_root *root, u64 new_size);
 int btrfs_insert_extent_backref(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root,
 				 struct btrfs_path *path,
@@ -1585,10 +1590,29 @@
 			   struct btrfs_root *root, u64 bytes_used,
 			   u64 type, u64 chunk_objectid, u64 chunk_offset,
 			   u64 size);
+int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
+			     struct btrfs_root *root, u64 group_start);
+int btrfs_relocate_block_group(struct btrfs_root *root, u64 group_start);
+int btrfs_free_reloc_root(struct btrfs_root *root);
+int btrfs_drop_dead_reloc_roots(struct btrfs_root *root);
+int btrfs_add_reloc_mapping(struct btrfs_root *root, u64 orig_bytenr,
+			    u64 num_bytes, u64 new_bytenr);
+int btrfs_get_reloc_mapping(struct btrfs_root *root, u64 orig_bytenr,
+			    u64 num_bytes, u64 *new_bytenr);
+void btrfs_free_reloc_mappings(struct btrfs_root *root);
+int btrfs_reloc_tree_cache_ref(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *root,
+			       struct extent_buffer *buf, u64 orig_start);
+int btrfs_add_dead_reloc_root(struct btrfs_root *root);
+int btrfs_cleanup_reloc_trees(struct btrfs_root *root);
 /* ctree.c */
 int btrfs_previous_item(struct btrfs_root *root,
 			struct btrfs_path *path, u64 min_objectid,
 			int type);
+int btrfs_merge_path(struct btrfs_trans_handle *trans,
+		     struct btrfs_root *root,
+		     struct btrfs_key *node_keys,
+		     u64 *nodes, int lowest_level);
 int btrfs_set_item_key_safe(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root, struct btrfs_path *path,
 			    struct btrfs_key *new_key);
diff -r 6257b2588438 disk-io.c
--- a/disk-io.c	Thu Sep 25 14:38:26 2008 +0800
+++ b/disk-io.c	Fri Sep 26 00:43:14 2008 +0800
@@ -1430,6 +1430,10 @@
 			     fs_info->btree_inode->i_mapping, GFP_NOFS);
 	fs_info->do_barriers = 1;
 
+	extent_io_tree_init(&fs_info->reloc_mapping_tree,
+			    fs_info->btree_inode->i_mapping, GFP_NOFS);
+	INIT_LIST_HEAD(&fs_info->dead_reloc_roots);
+	btrfs_leaf_ref_tree_init(&fs_info->reloc_ref_tree);
 	btrfs_leaf_ref_tree_init(&fs_info->shared_ref_tree);
 
 	BTRFS_I(fs_info->btree_inode)->root = tree_root;
@@ -1445,6 +1449,7 @@
 	mutex_init(&fs_info->transaction_kthread_mutex);
 	mutex_init(&fs_info->cleaner_mutex);
 	mutex_init(&fs_info->volume_mutex);
+	mutex_init(&fs_info->tree_reloc_mutex);
 	init_waitqueue_head(&fs_info->transaction_throttle);
 	init_waitqueue_head(&fs_info->transaction_wait);
 	init_waitqueue_head(&fs_info->async_submit_wait);
@@ -1651,6 +1656,10 @@
 		ret = btrfs_recover_log_trees(log_tree_root);
 		BUG_ON(ret);
 	}
+
+	ret = btrfs_cleanup_reloc_trees(tree_root);
+	BUG_ON(ret);
+
 	fs_info->last_trans_committed = btrfs_super_generation(disk_super);
 	return tree_root;
 
diff -r 6257b2588438 extent-tree.c
--- a/extent-tree.c	Thu Sep 25 14:38:26 2008 +0800
+++ b/extent-tree.c	Fri Sep 26 00:43:14 2008 +0800
@@ -1834,6 +1834,7 @@
 		u64 header_owner = btrfs_header_owner(buf);
 		u64 header_transid = btrfs_header_generation(buf);
 		if (header_owner != BTRFS_TREE_LOG_OBJECTID &&
+		    header_owner != BTRFS_TREE_RELOC_OBJECTID &&
 		    header_transid == trans->transid &&
 		    !btrfs_header_flag(buf, BTRFS_HEADER_FLAG_WRITTEN)) {
 			clean_tree_block(NULL, root, buf);
@@ -2487,6 +2488,7 @@
 		return -ENOSPC;
 	}
 	btrfs_add_free_space(cache, start, len);
+	update_reserved_extents(root, start, len, 0);
 	maybe_unlock_mutex(root);
 	return 0;
 }
@@ -2947,6 +2949,10 @@
 		 */
 		if (*level == 1) {
 			ref = btrfs_lookup_leaf_ref(root, bytenr);
+			if (ref && ref->generation != ptr_gen) {
+				btrfs_free_leaf_ref(root, ref);
+				ref = NULL;
+			}
 			if (ref) {
 				ret = cache_drop_leaf_ref(trans, root, ref);
 				BUG_ON(ret);
@@ -3153,30 +3159,6 @@
 	return ret;
 }
 
-int btrfs_free_block_groups(struct btrfs_fs_info *info)
-{
-	struct btrfs_block_group_cache *block_group;
-	struct rb_node *n;
-
-	mutex_lock(&info->alloc_mutex);
-	spin_lock(&info->block_group_cache_lock);
-	while ((n = rb_last(&info->block_group_cache_tree)) != NULL) {
-		block_group = rb_entry(n, struct btrfs_block_group_cache,
-				       cache_node);
-
-		btrfs_remove_free_space_cache(block_group);
-		rb_erase(&block_group->cache_node,
-			 &info->block_group_cache_tree);
-		spin_lock(&block_group->space_info->lock);
-		list_del(&block_group->list);
-		spin_unlock(&block_group->space_info->lock);
-		kfree(block_group);
-	}
-	spin_unlock(&info->block_group_cache_lock);
-	mutex_unlock(&info->alloc_mutex);
-	return 0;
-}
-
 static unsigned long calc_ra(unsigned long start, unsigned long last,
 			     unsigned long nr)
 {
@@ -3188,37 +3170,43 @@
 {
 	u64 page_start;
 	u64 page_end;
+	unsigned long first_index;
 	unsigned long last_index;
 	unsigned long i;
 	struct page *page;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct file_ra_state *ra;
-	unsigned long total_read = 0;
-	unsigned long ra_pages;
 	struct btrfs_ordered_extent *ordered;
-	struct btrfs_trans_handle *trans;
+	unsigned int total_read = 0;
+	unsigned int total_dirty = 0;
+	int ret = 0;
 
 	ra = kzalloc(sizeof(*ra), GFP_NOFS);
 
 	mutex_lock(&inode->i_mutex);
-	i = start >> PAGE_CACHE_SHIFT;
+	first_index = start >> PAGE_CACHE_SHIFT;
 	last_index = (start + len - 1) >> PAGE_CACHE_SHIFT;
 
-	ra_pages = BTRFS_I(inode)->root->fs_info->bdi.ra_pages;
+	/* make sure the dirty trick played by the caller work */
+	ret = invalidate_inode_pages2_range(inode->i_mapping,
+					    first_index, last_index);
+	if (ret)
+		goto out_unlock;
 
 	file_ra_state_init(ra, inode->i_mapping);
 
-	for (; i <= last_index; i++) {
-		if (total_read % ra_pages == 0) {
+	for (i = first_index ; i <= last_index; i++) {
+		if (total_read % ra->ra_pages == 0) {
 			btrfs_force_ra(inode->i_mapping, ra, NULL, i,
-				       calc_ra(i, last_index, ra_pages));
+				       calc_ra(i, last_index, ra->ra_pages));
 		}
 		total_read++;
 again:
 		if (((u64)i << PAGE_CACHE_SHIFT) > i_size_read(inode))
-			goto truncate_racing;
+			BUG_ON(1);
 		page = grab_cache_page(inode->i_mapping, i);
 		if (!page) {
+			ret = -ENOMEM;
 			goto out_unlock;
 		}
 		if (!PageUptodate(page)) {
@@ -3227,6 +3215,7 @@
 			if (!PageUptodate(page)) {
 				unlock_page(page);
 				page_cache_release(page);
+				ret = -EIO;
 				goto out_unlock;
 			}
 		}
@@ -3247,14 +3236,13 @@
 		}
 		set_page_extent_mapped(page);
 
-		/*
-		 * make sure page_mkwrite is called for this page if userland
-		 * wants to change it from mmap
-		 */
-		clear_page_dirty_for_io(page);
-
 		btrfs_set_extent_delalloc(inode, page_start, page_end);
+		if (i == first_index)
+			set_extent_bits(io_tree, page_start, page_end,
+					EXTENT_BOUNDARY, GFP_NOFS);
+
 		set_page_dirty(page);
+		total_dirty++;
 
 		unlock_extent(io_tree, page_start, page_end, GFP_NOFS);
 		unlock_page(page);
@@ -3262,347 +3250,1457 @@
 	}
 
 out_unlock:
-	/* we have to start the IO in order to get the ordered extents
-	 * instantiated.  This allows the relocation to code to wait
-	 * for all the ordered extents to hit the disk.
-	 *
-	 * Otherwise, it would constantly loop over the same extents
-	 * because the old ones don't get deleted  until the IO is
-	 * started
-	 */
-	btrfs_fdatawrite_range(inode->i_mapping, start, start + len - 1,
-			       WB_SYNC_NONE);
 	kfree(ra);
-	trans = btrfs_start_transaction(BTRFS_I(inode)->root, 1);
-	if (trans) {
-		btrfs_end_transaction(trans, BTRFS_I(inode)->root);
-		mark_inode_dirty(inode);
-	}
 	mutex_unlock(&inode->i_mutex);
-	return 0;
-
-truncate_racing:
-	vmtruncate(inode, inode->i_size);
-	balance_dirty_pages_ratelimited_nr(inode->i_mapping,
-					   total_read);
-	goto out_unlock;
-}
-
-/*
- * The back references tell us which tree holds a ref on a block,
- * but it is possible for the tree root field in the reference to
- * reflect the original root before a snapshot was made.  In this
- * case we should search through all the children of a given root
- * to find potential holders of references on a block.
- *
- * Instead, we do something a little less fancy and just search
- * all the roots for a given key/block combination.
- */
-static int find_root_for_ref(struct btrfs_root *root,
-			     struct btrfs_path *path,
-			     struct btrfs_key *key0,
-			     int level,
-			     int file_key,
-			     struct btrfs_root **found_root,
-			     u64 bytenr)
-{
-	struct btrfs_key root_location;
-	struct btrfs_root *cur_root = *found_root;
-	struct btrfs_file_extent_item *file_extent;
-	u64 root_search_start = BTRFS_FS_TREE_OBJECTID;
-	u64 found_bytenr;
-	int ret;
-
-	root_location.offset = (u64)-1;
-	root_location.type = BTRFS_ROOT_ITEM_KEY;
-	path->lowest_level = level;
-	path->reada = 0;
-	while(1) {
-		ret = btrfs_search_slot(NULL, cur_root, key0, path, 0, 0);
-		found_bytenr = 0;
-		if (ret == 0 && file_key) {
-			struct extent_buffer *leaf = path->nodes[0];
-			file_extent = btrfs_item_ptr(leaf, path->slots[0],
-					     struct btrfs_file_extent_item);
-			if (btrfs_file_extent_type(leaf, file_extent) ==
-			    BTRFS_FILE_EXTENT_REG) {
-				found_bytenr =
-					btrfs_file_extent_disk_bytenr(leaf,
-							       file_extent);
-		       }
-		} else if (!file_key) {
-			if (path->nodes[level])
-				found_bytenr = path->nodes[level]->start;
-		}
-
-		btrfs_release_path(cur_root, path);
-
-		if (found_bytenr == bytenr) {
-			*found_root = cur_root;
+	balance_dirty_pages_ratelimited_nr(inode->i_mapping, total_dirty);
+	return ret;
+}
+
+static int noinline relocate_data_extent(struct inode *reloc_inode,
+					 struct btrfs_key *extent_key,
+					 u64 offset)
+{
+	struct btrfs_root *root = BTRFS_I(reloc_inode)->root;
+	struct extent_map_tree *em_tree = &BTRFS_I(reloc_inode)->extent_tree;
+	struct extent_map *em;
+
+	em = alloc_extent_map(GFP_NOFS);
+	BUG_ON(!em || IS_ERR(em));
+
+	em->start = extent_key->objectid - offset;
+	em->len = extent_key->offset;
+	em->block_start = extent_key->objectid;
+	em->bdev = root->fs_info->fs_devices->latest_bdev;
+	set_bit(EXTENT_FLAG_PINNED, &em->flags);
+
+	/* setup extent map to cheat btrfs_readpage */
+	mutex_lock(&BTRFS_I(reloc_inode)->extent_mutex);
+	while (1) {
+		int ret;
+		spin_lock(&em_tree->lock);
+		ret = add_extent_mapping(em_tree, em);
+		spin_unlock(&em_tree->lock);
+		if (ret != -EEXIST) {
+			free_extent_map(em);
+			break;
+		}
+		btrfs_drop_extent_cache(reloc_inode, em->start,
+					em->start + em->len - 1, 0);
+	}
+	mutex_unlock(&BTRFS_I(reloc_inode)->extent_mutex);
+
+	return relocate_inode_pages(reloc_inode, extent_key->objectid - offset,
+				    extent_key->offset);
+}
+
+struct btrfs_ref_path {
+	u64 extent_start;
+	u64 nodes[BTRFS_MAX_LEVEL];
+	u64 root_objectid;
+	u64 root_generation;
+	u64 owner_objectid;
+	u64 owner_offset;
+	u32 num_refs;
+	int lowest_level;
+	int current_level;
+};
+
+struct disk_extent {
+	u64 disk_bytenr;
+	u64 disk_num_bytes;
+	u64 offset;
+	u64 num_bytes;
+};
+
+static int is_cowonly_root(u64 root_objectid)
+{
+	if (root_objectid == BTRFS_ROOT_TREE_OBJECTID ||
+	    root_objectid == BTRFS_EXTENT_TREE_OBJECTID ||
+	    root_objectid == BTRFS_CHUNK_TREE_OBJECTID ||
+	    root_objectid == BTRFS_DEV_TREE_OBJECTID ||
+	    root_objectid == BTRFS_TREE_LOG_OBJECTID)
+		return 1;
+	return 0;
+}
+
+static int noinline __next_ref_path(struct btrfs_trans_handle *trans,
+				    struct btrfs_root *extent_root,
+				    struct btrfs_ref_path *ref_path,
+				    int first_time)
+{
+	struct extent_buffer *leaf;
+	struct btrfs_path *path;
+	struct btrfs_extent_ref *ref;
+	struct btrfs_key key;
+	struct btrfs_key found_key;
+	u64 bytenr;
+	u32 nritems;
+	int level;
+	int ret = 1;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	mutex_lock(&extent_root->fs_info->alloc_mutex);
+
+	if (first_time) {
+		ref_path->lowest_level = -1;
+		ref_path->current_level = -1;
+		goto walk_up;
+	}
+walk_down:
+	level = ref_path->current_level - 1;
+	while (level >= -1) {
+		u64 parent;
+		if (level < ref_path->lowest_level)
+			break;
+
+		if (level >= 0) {
+			bytenr = ref_path->nodes[level];
+		} else {
+			bytenr = ref_path->extent_start;
+		}
+		BUG_ON(bytenr == 0);
+
+		parent = ref_path->nodes[level + 1];
+		ref_path->nodes[level + 1] = 0;
+		ref_path->current_level = level;
+		BUG_ON(parent == 0);
+
+		key.objectid = bytenr;
+		key.offset = parent + 1;
+		key.type = BTRFS_EXTENT_REF_KEY;
+
+		ret = btrfs_search_slot(trans, extent_root, &key, path, 0, 0);
+		if (ret < 0)
+			goto out;
+		BUG_ON(ret == 0);
+
+		leaf = path->nodes[0];
+		nritems = btrfs_header_nritems(leaf);
+		if (path->slots[0] >= nritems) {
+			ret = btrfs_next_leaf(extent_root, path);
+			if (ret < 0)
+				goto out;
+			if (ret > 0)
+				goto next;
+			leaf = path->nodes[0];
+		}
+
+		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
+		if (found_key.objectid == bytenr &&
+				found_key.type == BTRFS_EXTENT_REF_KEY)
+			goto found;
+next:
+		level--;
+		btrfs_release_path(extent_root, path);
+		if (need_resched()) {
+			mutex_unlock(&extent_root->fs_info->alloc_mutex);
+			cond_resched();
+			mutex_lock(&extent_root->fs_info->alloc_mutex);
+		}
+	}
+	/* reached lowest level */
+	ret = 1;
+	goto out;
+walk_up:
+	level = ref_path->current_level;
+	while (level < BTRFS_MAX_LEVEL - 1) {
+		u64 ref_objectid;
+		if (level >= 0) {
+			bytenr = ref_path->nodes[level];
+		} else {
+			bytenr = ref_path->extent_start;
+		}
+		BUG_ON(bytenr == 0);
+
+		key.objectid = bytenr;
+		key.offset = 0;
+		key.type = BTRFS_EXTENT_REF_KEY;
+
+		ret = btrfs_search_slot(trans, extent_root, &key, path, 0, 0);
+		if (ret < 0)
+			goto out;
+
+		leaf = path->nodes[0];
+		nritems = btrfs_header_nritems(leaf);
+		if (path->slots[0] >= nritems) {
+			ret = btrfs_next_leaf(extent_root, path);
+			if (ret < 0)
+				goto out;
+			if (ret > 0) {
+				/* the extent was freed by someone */
+				if (ref_path->lowest_level == level)
+					goto out;
+				btrfs_release_path(extent_root, path);
+				goto walk_down;
+			}
+			leaf = path->nodes[0];
+		}
+
+		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
+		if (found_key.objectid != bytenr ||
+				found_key.type != BTRFS_EXTENT_REF_KEY) {
+			/* the extent was freed by someone */
+			if (ref_path->lowest_level == level) {
+				ret = 1;
+				goto out;
+			}
+			btrfs_release_path(extent_root, path);
+			goto walk_down;
+		}
+found:
+		ref = btrfs_item_ptr(leaf, path->slots[0],
+				struct btrfs_extent_ref);
+		ref_objectid = btrfs_ref_objectid(leaf, ref);
+		if (ref_objectid < BTRFS_FIRST_FREE_OBJECTID) {
+			if (first_time) {
+				level = (int)ref_objectid;
+				BUG_ON(level >= BTRFS_MAX_LEVEL);
+				ref_path->lowest_level = level;
+				ref_path->current_level = level;
+				ref_path->nodes[level] = bytenr;
+			} else {
+				WARN_ON(ref_objectid != level);
+			}
+		} else {
+			WARN_ON(level != -1);
+		}
+		first_time = 0;
+
+		if (ref_path->lowest_level == level) {
+			ref_path->owner_objectid = ref_objectid;
+			ref_path->owner_offset = btrfs_ref_offset(leaf, ref);
+			ref_path->num_refs = btrfs_ref_num_refs(leaf, ref);
+		}
+
+		/*
+		 * the block is tree root or the block isn't in reference
+		 * counted tree.
+		 */
+		if (found_key.objectid == found_key.offset ||
+		    is_cowonly_root(btrfs_ref_root(leaf, ref))) {
+			ref_path->root_objectid = btrfs_ref_root(leaf, ref);
+			ref_path->root_generation =
+				btrfs_ref_generation(leaf, ref);
+			if (level < 0) {
+				/* special reference from the tree log */
+				ref_path->nodes[0] = found_key.offset;
+				ref_path->current_level = 0;
+			}
 			ret = 0;
 			goto out;
 		}
-		ret = btrfs_search_root(root->fs_info->tree_root,
-					root_search_start, &root_search_start);
-		if (ret)
-			break;
-
-		root_location.objectid = root_search_start;
-		cur_root = btrfs_read_fs_root_no_name(root->fs_info,
-						      &root_location);
-		if (!cur_root) {
+
+		level++;
+		BUG_ON(ref_path->nodes[level] != 0);
+		ref_path->nodes[level] = found_key.offset;
+		ref_path->current_level = level;
+
+		/*
+		 * the reference was created in the running transaction,
+		 * no need to continue walking up.
+		 */
+		if (btrfs_ref_generation(leaf, ref) == trans->transid) {
+			ref_path->root_objectid = btrfs_ref_root(leaf, ref);
+			ref_path->root_generation =
+				btrfs_ref_generation(leaf, ref);
+			ret = 0;
+			goto out;
+		}
+
+		btrfs_release_path(extent_root, path);
+		if (need_resched()) {
+			mutex_unlock(&extent_root->fs_info->alloc_mutex);
+			cond_resched();
+			mutex_lock(&extent_root->fs_info->alloc_mutex);
+		}
+	}
+	/* reached max tree level, but no tree root found. */
+	BUG();
+out:
+	mutex_unlock(&extent_root->fs_info->alloc_mutex);
+	btrfs_free_path(path);
+	return ret;
+}
+
+static int btrfs_first_ref_path(struct btrfs_trans_handle *trans,
+				struct btrfs_root *extent_root,
+				struct btrfs_ref_path *ref_path,
+				u64 extent_start)
+{
+	memset(ref_path, 0, sizeof(*ref_path));
+	ref_path->extent_start = extent_start;
+
+	return __next_ref_path(trans, extent_root, ref_path, 1);
+}
+
+static int btrfs_next_ref_path(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *extent_root,
+			       struct btrfs_ref_path *ref_path)
+{
+	return __next_ref_path(trans, extent_root, ref_path, 0);
+}
+
+static int noinline get_new_locations(struct inode *reloc_inode,
+				      struct btrfs_key *extent_key,
+				      u64 offset, int no_fragment,
+				      struct disk_extent **extents,
+				      int *nr_extents)
+{
+	struct btrfs_root *root = BTRFS_I(reloc_inode)->root;
+	struct btrfs_path *path;
+	struct btrfs_file_extent_item *fi;
+	struct extent_buffer *leaf;
+	struct disk_extent *exts = *extents;
+	struct btrfs_key found_key;
+	u64 cur_pos;
+	u64 last_byte;
+	u32 nritems;
+	int nr = 0;
+	int max = *nr_extents;
+	int ret;
+
+	WARN_ON(!no_fragment && *extents);
+	if (!exts) {
+		max = 1;
+		exts = kmalloc(sizeof(*exts) * max, GFP_NOFS);
+		if (!exts)
+			return -ENOMEM;
+	}
+
+	path = btrfs_alloc_path();
+	BUG_ON(!path);
+
+	cur_pos = extent_key->objectid - offset;
+	last_byte = extent_key->objectid + extent_key->offset;
+	ret = btrfs_lookup_file_extent(NULL, root, path, reloc_inode->i_ino,
+				       cur_pos, 0);
+	if (ret < 0)
+		goto out;
+	if (ret > 0) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	while (1) {
+		leaf = path->nodes[0];
+		nritems = btrfs_header_nritems(leaf);
+		if (path->slots[0] >= nritems) {
+			ret = btrfs_next_leaf(root, path);
+			if (ret < 0)
+				goto out;
+			if (ret > 0)
+				break;
+			leaf = path->nodes[0];
+		}
+
+		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
+		if (found_key.offset != cur_pos ||
+		    found_key.type != BTRFS_EXTENT_DATA_KEY ||
+		    found_key.objectid != reloc_inode->i_ino)
+			break;
+
+		fi = btrfs_item_ptr(leaf, path->slots[0],
+				    struct btrfs_file_extent_item);
+		if (btrfs_file_extent_type(leaf, fi) !=
+		    BTRFS_FILE_EXTENT_REG ||
+		    btrfs_file_extent_disk_bytenr(leaf, fi) == 0)
+			break;
+
+		if (nr == max) {
+			struct disk_extent *old = exts;
+			max *= 2;
+			exts = kzalloc(sizeof(*exts) * max, GFP_NOFS);
+			memcpy(exts, old, sizeof(*exts) * nr);
+			if (old != *extents)
+				kfree(old);
+		}
+
+		exts[nr].disk_bytenr =
+			btrfs_file_extent_disk_bytenr(leaf, fi);
+		exts[nr].disk_num_bytes =
+			btrfs_file_extent_disk_num_bytes(leaf, fi);
+		exts[nr].offset = btrfs_file_extent_offset(leaf, fi);
+		exts[nr].num_bytes = btrfs_file_extent_num_bytes(leaf, fi);
+		WARN_ON(exts[nr].offset > 0);
+		WARN_ON(exts[nr].num_bytes != exts[nr].disk_num_bytes);
+
+		cur_pos += exts[nr].num_bytes;
+		nr++;
+
+		if (cur_pos + offset >= last_byte)
+			break;
+
+		if (no_fragment) {
 			ret = 1;
-			break;
-		}
-	}
-out:
+			goto out;
+		}
+		path->slots[0]++;
+	}
+
+	WARN_ON(cur_pos + offset > last_byte);
+	if (cur_pos + offset < last_byte) {
+		ret = -ENOENT;
+		goto out;
+	}
+	ret = 0;
+out:
+	btrfs_free_path(path);
+	if (ret) {
+		if (exts != *extents)
+			kfree(exts);
+	} else {
+		*extents = exts;
+		*nr_extents = nr;
+	}
+	return ret;
+}
+
+static int noinline replace_one_extent(struct btrfs_trans_handle *trans,
+					struct btrfs_root *root,
+					struct btrfs_path *path,
+					struct btrfs_key *extent_key,
+					struct btrfs_key *leaf_key,
+					struct btrfs_ref_path *ref_path,
+					struct disk_extent *new_extents,
+					int nr_extents)
+{
+	struct extent_buffer *leaf;
+	struct btrfs_file_extent_item *fi;
+	struct inode *inode = NULL;
+	struct btrfs_key key;
+	u64 lock_start = 0;
+	u64 lock_end = 0;
+	u64 num_bytes;
+	u64 ext_offset;
+	u64 first_pos;
+	u32 nritems;
+	int extent_locked = 0;
+	int ret;
+
+	first_pos = ref_path->owner_offset;
+	if (ref_path->owner_objectid != BTRFS_MULTIPLE_OBJECTIDS) {
+		key.objectid = ref_path->owner_objectid;
+		key.offset = ref_path->owner_offset;
+		key.type = BTRFS_EXTENT_DATA_KEY;
+	} else {
+		memcpy(&key, leaf_key, sizeof(key));
+	}
+
+	while (1) {
+		ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
+		if (ret < 0)
+			goto out;
+
+		leaf = path->nodes[0];
+		nritems = btrfs_header_nritems(leaf);
+next:
+		if (extent_locked && ret > 0) {
+			/*
+			 * the file extent item was modified by someone
+			 * before the extent got locked.
+			 */
+			mutex_unlock(&BTRFS_I(inode)->extent_mutex);
+			unlock_extent(&BTRFS_I(inode)->io_tree, lock_start,
+				      lock_end, GFP_NOFS);
+			extent_locked = 0;
+		}
+
+		if (path->slots[0] >= nritems) {
+			if (ref_path->owner_objectid ==
+			    BTRFS_MULTIPLE_OBJECTIDS)
+				break;
+
+			BUG_ON(extent_locked);
+			ret = btrfs_next_leaf(root, path);
+			if (ret < 0)
+				goto out;
+			if (ret > 0)
+				break;
+			leaf = path->nodes[0];
+			nritems = btrfs_header_nritems(leaf);
+		}
+
+		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+
+		if (ref_path->owner_objectid != BTRFS_MULTIPLE_OBJECTIDS) {
+			if ((key.objectid > ref_path->owner_objectid) ||
+			    (key.objectid == ref_path->owner_objectid &&
+			     key.type > BTRFS_EXTENT_DATA_KEY) ||
+			    (key.offset >= first_pos + extent_key->offset))
+				break;
+		}
+
+		if (inode && key.objectid != inode->i_ino) {
+			BUG_ON(extent_locked);
+			btrfs_release_path(root, path);
+			mutex_unlock(&inode->i_mutex);
+			iput(inode);
+			inode = NULL;
+			continue;
+		}
+
+		if (key.type != BTRFS_EXTENT_DATA_KEY) {
+			path->slots[0]++;
+			ret = 1;
+			goto next;
+		}
+		fi = btrfs_item_ptr(leaf, path->slots[0],
+				    struct btrfs_file_extent_item);
+		if ((btrfs_file_extent_type(leaf, fi) !=
+		     BTRFS_FILE_EXTENT_REG) ||
+		    (btrfs_file_extent_disk_bytenr(leaf, fi) !=
+		     extent_key->objectid)) {
+			path->slots[0]++;
+			ret = 1;
+			goto next;
+		}
+
+		num_bytes = btrfs_file_extent_num_bytes(leaf, fi);
+		ext_offset = btrfs_file_extent_offset(leaf, fi);
+
+		if (first_pos > key.offset - ext_offset)
+			first_pos = key.offset - ext_offset;
+
+		if (!extent_locked) {
+			lock_start = key.offset;
+			lock_end = lock_start + num_bytes - 1;
+		} else {
+			BUG_ON(lock_start != key.offset);
+			BUG_ON(lock_end - lock_start + 1 < num_bytes);
+		}
+
+		if (!inode) {
+			btrfs_release_path(root, path);
+
+			inode = btrfs_iget_locked(root->fs_info->sb,
+						  key.objectid, root);
+			if (inode->i_state & I_NEW) {
+				BTRFS_I(inode)->root = root;
+				BTRFS_I(inode)->location.objectid =
+					key.objectid;
+				BTRFS_I(inode)->location.type =
+					BTRFS_INODE_ITEM_KEY;
+				BTRFS_I(inode)->location.offset = 0;
+				btrfs_read_locked_inode(inode);
+				unlock_new_inode(inode);
+			}
+			/*
+			 * some code call btrfs_commit_transaction while
+			 * holding the i_mutex, so we can't use mutex_lock
+			 * here.
+			 */
+			if (is_bad_inode(inode) ||
+			    !mutex_trylock(&inode->i_mutex)) {
+				iput(inode);
+				inode = NULL;
+				key.offset = (u64)-1;
+				goto skip;
+			}
+		}
+
+		if (!extent_locked) {
+			struct btrfs_ordered_extent *ordered;
+
+			btrfs_release_path(root, path);
+
+			lock_extent(&BTRFS_I(inode)->io_tree, lock_start,
+				    lock_end, GFP_NOFS);
+			ordered = btrfs_lookup_first_ordered_extent(inode,
+								    lock_end);
+			if (ordered &&
+			    ordered->file_offset <= lock_end &&
+			    ordered->file_offset + ordered->len > lock_start) {
+				unlock_extent(&BTRFS_I(inode)->io_tree,
+					      lock_start, lock_end, GFP_NOFS);
+				btrfs_start_ordered_extent(inode, ordered, 1);
+				btrfs_put_ordered_extent(ordered);
+				key.offset += num_bytes;
+				goto skip;
+			}
+			if (ordered)
+				btrfs_put_ordered_extent(ordered);
+
+			mutex_lock(&BTRFS_I(inode)->extent_mutex);
+			extent_locked = 1;
+			continue;
+		}
+
+		if (nr_extents == 1) {
+			/* update extent pointer in place */
+			btrfs_set_file_extent_generation(leaf, fi,
+						trans->transid);
+			btrfs_set_file_extent_disk_bytenr(leaf, fi,
+						new_extents[0].disk_bytenr);
+			btrfs_set_file_extent_disk_num_bytes(leaf, fi,
+						new_extents[0].disk_num_bytes);
+			ext_offset += new_extents[0].offset;
+			btrfs_set_file_extent_offset(leaf, fi, ext_offset);
+			btrfs_mark_buffer_dirty(leaf);
+
+			btrfs_drop_extent_cache(inode, key.offset,
+						key.offset + num_bytes - 1, 0);
+
+			ret = btrfs_inc_extent_ref(trans, root,
+						new_extents[0].disk_bytenr,
+						new_extents[0].disk_num_bytes,
+						leaf->start,
+						root->root_key.objectid,
+						trans->transid,
+						key.objectid, key.offset);
+			BUG_ON(ret);
+
+			ret = btrfs_free_extent(trans, root,
+						extent_key->objectid,
+						extent_key->offset,
+						leaf->start,
+						btrfs_header_owner(leaf),
+						btrfs_header_generation(leaf),
+						key.objectid, key.offset, 0);
+			BUG_ON(ret);
+
+			btrfs_release_path(root, path);
+			key.offset += num_bytes;
+		} else {
+			u64 alloc_hint;
+			u64 extent_len;
+			int i;
+			/*
+			 * drop old extent pointer at first, then insert the
+			 * new pointers one bye one
+			 */
+			btrfs_release_path(root, path);
+			ret = btrfs_drop_extents(trans, root, inode, key.offset,
+						 key.offset + num_bytes,
+						 key.offset, &alloc_hint);
+			BUG_ON(ret);
+
+			for (i = 0; i < nr_extents; i++) {
+				if (ext_offset >= new_extents[i].num_bytes) {
+					ext_offset -= new_extents[i].num_bytes;
+					continue;
+				}
+				extent_len = min(new_extents[i].num_bytes -
+						 ext_offset, num_bytes);
+
+				ret = btrfs_insert_empty_item(trans, root,
+							      path, &key,
+							      sizeof(*fi));
+				BUG_ON(ret);
+
+				leaf = path->nodes[0];
+				fi = btrfs_item_ptr(leaf, path->slots[0],
+						struct btrfs_file_extent_item);
+				btrfs_set_file_extent_generation(leaf, fi,
+							trans->transid);
+				btrfs_set_file_extent_type(leaf, fi,
+							BTRFS_FILE_EXTENT_REG);
+				btrfs_set_file_extent_disk_bytenr(leaf, fi,
+						new_extents[i].disk_bytenr);
+				btrfs_set_file_extent_disk_num_bytes(leaf, fi,
+						new_extents[i].disk_num_bytes);
+				btrfs_set_file_extent_num_bytes(leaf, fi,
+							extent_len);
+				ext_offset += new_extents[i].offset;
+				btrfs_set_file_extent_offset(leaf, fi,
+							ext_offset);
+				btrfs_mark_buffer_dirty(leaf);
+
+				btrfs_drop_extent_cache(inode, key.offset,
+						key.offset + extent_len - 1, 0);
+
+				ret = btrfs_inc_extent_ref(trans, root,
+						new_extents[i].disk_bytenr,
+						new_extents[i].disk_num_bytes,
+						leaf->start,
+						root->root_key.objectid,
+						trans->transid,
+						key.objectid, key.offset);
+				BUG_ON(ret);
+				btrfs_release_path(root, path);
+
+				inode->i_blocks += extent_len >> 9;
+
+				ext_offset = 0;
+				num_bytes -= extent_len;
+				key.offset += extent_len;
+
+				if (num_bytes == 0)
+					break;
+			}
+			BUG_ON(i >= nr_extents);
+		}
+
+		if (extent_locked) {
+			mutex_unlock(&BTRFS_I(inode)->extent_mutex);
+			unlock_extent(&BTRFS_I(inode)->io_tree, lock_start,
+				      lock_end, GFP_NOFS);
+			extent_locked = 0;
+		}
+skip:
+		if (ref_path->owner_objectid != BTRFS_MULTIPLE_OBJECTIDS &&
+		    key.offset >= first_pos + extent_key->offset)
+			break;
+
+		cond_resched();
+	}
+	ret = 0;
+out:
+	btrfs_release_path(root, path);
+	if (inode) {
+		mutex_unlock(&inode->i_mutex);
+		if (extent_locked) {
+			mutex_unlock(&BTRFS_I(inode)->extent_mutex);
+			unlock_extent(&BTRFS_I(inode)->io_tree, lock_start,
+				      lock_end, GFP_NOFS);
+		}
+		iput(inode);
+	}
+	return ret;
+}
+
+int btrfs_add_reloc_mapping(struct btrfs_root *root, u64 orig_bytenr,
+			    u64 num_bytes, u64 new_bytenr)
+{
+	set_extent_bits(&root->fs_info->reloc_mapping_tree,
+			orig_bytenr, orig_bytenr + num_bytes - 1,
+			EXTENT_LOCKED, GFP_NOFS);
+	set_state_private(&root->fs_info->reloc_mapping_tree,
+			  orig_bytenr, new_bytenr);
+	return 0;
+}
+
+int btrfs_get_reloc_mapping(struct btrfs_root *root, u64 orig_bytenr,
+			    u64 num_bytes, u64 *new_bytenr)
+{
+	u64 bytenr;
+	u64 cur_bytenr = orig_bytenr;
+	u64 prev_bytenr = orig_bytenr;
+	int ret;
+
+	while (1) {
+		ret = get_state_private(&root->fs_info->reloc_mapping_tree,
+					cur_bytenr, &bytenr);
+		if (ret)
+			break;
+		prev_bytenr = cur_bytenr;
+		cur_bytenr = bytenr;
+	}
+
+	if (orig_bytenr == cur_bytenr)
+		return -ENOENT;
+
+	if (prev_bytenr != orig_bytenr) {
+		set_state_private(&root->fs_info->reloc_mapping_tree,
+				  orig_bytenr, cur_bytenr);
+	}
+	*new_bytenr = cur_bytenr;
+	return 0;
+}
+
+void btrfs_free_reloc_mappings(struct btrfs_root *root)
+{
+	clear_extent_bits(&root->fs_info->reloc_mapping_tree,
+			  0, (u64)-1, -1, GFP_NOFS);
+}
+
+int btrfs_reloc_tree_cache_ref(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *root,
+			       struct extent_buffer *buf, u64 orig_start)
+{
+	int level;
+	int ret;
+
+	BUG_ON(btrfs_header_generation(buf) != trans->transid);
+	BUG_ON(root->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID);
+
+	level = btrfs_header_level(buf);
+	if (level == 0) {
+		struct btrfs_leaf_ref *ref;
+		struct btrfs_leaf_ref *orig_ref;
+
+		orig_ref = btrfs_lookup_leaf_ref(root, orig_start);
+		if (!orig_ref)
+			return -ENOENT;
+
+		ref = btrfs_alloc_leaf_ref(root, orig_ref->nritems);
+		if (!ref) {
+			btrfs_free_leaf_ref(root, orig_ref);
+			return -ENOMEM;
+		}
+
+		ref->nritems = orig_ref->nritems;
+		memcpy(ref->extents, orig_ref->extents,
+			sizeof(ref->extents[0]) * ref->nritems);
+
+		btrfs_free_leaf_ref(root, orig_ref);
+
+		ref->root_gen = trans->transid;
+		ref->bytenr = buf->start;
+		ref->owner = btrfs_header_owner(buf);
+		ref->generation = btrfs_header_generation(buf);
+		ret = btrfs_add_leaf_ref(root, ref, 0);
+		WARN_ON(ret);
+		btrfs_free_leaf_ref(root, ref);
+	}
+	return 0;
+}
+
+static int noinline invalidate_extent_cache(struct btrfs_root *root,
+					struct extent_buffer *leaf,
+					struct btrfs_block_group_cache *group,
+					struct btrfs_root *target_root)
+{
+	struct btrfs_key key;
+	struct inode *inode = NULL;
+	struct btrfs_file_extent_item *fi;
+	u64 num_bytes;
+	u64 skip_objectid = 0;
+	u32 nritems;
+	u32 i;
+
+	nritems = btrfs_header_nritems(leaf);
+	for (i = 0; i < nritems; i++) {
+		btrfs_item_key_to_cpu(leaf, &key, i);
+		if (key.objectid == skip_objectid ||
+		    key.type != BTRFS_EXTENT_DATA_KEY)
+			continue;
+		fi = btrfs_item_ptr(leaf, i, struct btrfs_file_extent_item);
+		if (btrfs_file_extent_type(leaf, fi) ==
+		    BTRFS_FILE_EXTENT_INLINE)
+			continue;
+		if (btrfs_file_extent_disk_bytenr(leaf, fi) == 0)
+			continue;
+		if (!inode || inode->i_ino != key.objectid) {
+			iput(inode);
+			inode = btrfs_ilookup(target_root->fs_info->sb,
+					      key.objectid, target_root, 1);
+		}
+		if (!inode) {
+			skip_objectid = key.objectid;
+			continue;
+		}
+		num_bytes = btrfs_file_extent_num_bytes(leaf, fi);
+
+		lock_extent(&BTRFS_I(inode)->io_tree, key.offset,
+			    key.offset + num_bytes - 1, GFP_NOFS);
+		mutex_lock(&BTRFS_I(inode)->extent_mutex);
+		btrfs_drop_extent_cache(inode, key.offset,
+					key.offset + num_bytes - 1, 1);
+		mutex_unlock(&BTRFS_I(inode)->extent_mutex);
+		unlock_extent(&BTRFS_I(inode)->io_tree, key.offset,
+			      key.offset + num_bytes - 1, GFP_NOFS);
+		cond_resched();
+	}
+	iput(inode);
+	return 0;
+}
+
+static int noinline replace_extents_in_leaf(struct btrfs_trans_handle *trans,
+					struct btrfs_root *root,
+					struct extent_buffer *leaf,
+					struct btrfs_block_group_cache *group,
+					struct inode *reloc_inode)
+{
+	struct btrfs_key key;
+	struct btrfs_key extent_key;
+	struct btrfs_file_extent_item *fi;
+	struct btrfs_leaf_ref *ref;
+	struct disk_extent *new_extent;
+	u64 bytenr;
+	u64 num_bytes;
+	u32 nritems;
+	u32 i;
+	int ext_index;
+	int nr_extent;
+	int ret;
+
+	new_extent = kmalloc(sizeof(*new_extent), GFP_NOFS);
+	BUG_ON(!new_extent);
+
+	ref = btrfs_lookup_leaf_ref(root, leaf->start);
+	BUG_ON(!ref);
+
+	ext_index = -1;
+	nritems = btrfs_header_nritems(leaf);
+	for (i = 0; i < nritems; i++) {
+		btrfs_item_key_to_cpu(leaf, &key, i);
+		if (btrfs_key_type(&key) != BTRFS_EXTENT_DATA_KEY)
+			continue;
+		fi = btrfs_item_ptr(leaf, i, struct btrfs_file_extent_item);
+		if (btrfs_file_extent_type(leaf, fi) ==
+		    BTRFS_FILE_EXTENT_INLINE)
+			continue;
+		bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
+		num_bytes = btrfs_file_extent_disk_num_bytes(leaf, fi);
+		if (bytenr == 0)
+			continue;
+
+		ext_index++;
+		if (bytenr >= group->key.objectid + group->key.offset ||
+		    bytenr + num_bytes <= group->key.objectid)
+			continue;
+
+		extent_key.objectid = bytenr;
+		extent_key.offset = num_bytes;
+		extent_key.type = BTRFS_EXTENT_ITEM_KEY;
+		nr_extent = 1;
+		ret = get_new_locations(reloc_inode, &extent_key,
+					group->key.objectid, 1,
+					&new_extent, &nr_extent);
+		if (ret > 0)
+			continue;
+		BUG_ON(ret < 0);
+
+		BUG_ON(ref->extents[ext_index].bytenr != bytenr);
+		BUG_ON(ref->extents[ext_index].num_bytes != num_bytes);
+		ref->extents[ext_index].bytenr = new_extent->disk_bytenr;
+		ref->extents[ext_index].num_bytes = new_extent->disk_num_bytes;
+
+		btrfs_set_file_extent_generation(leaf, fi, trans->transid);
+		btrfs_set_file_extent_disk_bytenr(leaf, fi,
+						new_extent->disk_bytenr);
+		btrfs_set_file_extent_disk_num_bytes(leaf, fi,
+						new_extent->disk_num_bytes);
+		new_extent->offset += btrfs_file_extent_offset(leaf, fi);
+		btrfs_set_file_extent_offset(leaf, fi, new_extent->offset);
+		btrfs_mark_buffer_dirty(leaf);
+
+		ret = btrfs_inc_extent_ref(trans, root,
+					new_extent->disk_bytenr,
+					new_extent->disk_num_bytes,
+					leaf->start,
+					root->root_key.objectid,
+					trans->transid,
+					key.objectid, key.offset);
+		BUG_ON(ret);
+		ret = btrfs_free_extent(trans, root,
+					bytenr, num_bytes, leaf->start,
+					btrfs_header_owner(leaf),
+					btrfs_header_generation(leaf),
+					key.objectid, key.offset, 0);
+		BUG_ON(ret);
+		cond_resched();
+	}
+	kfree(new_extent);
+	BUG_ON(ext_index + 1 != ref->nritems);
+	btrfs_free_leaf_ref(root, ref);
+	return 0;
+}
+
+int btrfs_free_reloc_root(struct btrfs_root *root)
+{
+	struct btrfs_root *reloc_root;
+
+	if (root->reloc_root) {
+		reloc_root = root->reloc_root;
+		root->reloc_root = NULL;
+		list_add(&reloc_root->dead_list,
+			 &root->fs_info->dead_reloc_roots);
+	}
+	return 0;
+}
+
+int btrfs_drop_dead_reloc_roots(struct btrfs_root *root)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *reloc_root;
+	struct btrfs_root *prev_root = NULL;
+	struct list_head dead_roots;
+	int ret;
+	unsigned long nr;
+
+	INIT_LIST_HEAD(&dead_roots);
+	list_splice_init(&root->fs_info->dead_reloc_roots, &dead_roots);
+
+	while (!list_empty(&dead_roots)) {
+		reloc_root = list_entry(dead_roots.prev,
+					struct btrfs_root, dead_list);
+		list_del_init(&reloc_root->dead_list);
+
+		BUG_ON(reloc_root->commit_root != NULL);
+		while (1) {
+			trans = btrfs_join_transaction(root, 1);
+			BUG_ON(!trans);
+
+			mutex_lock(&root->fs_info->drop_mutex);
+			ret = btrfs_drop_snapshot(trans, reloc_root);
+			if (ret != -EAGAIN)
+				break;
+			mutex_unlock(&root->fs_info->drop_mutex);
+
+			nr = trans->blocks_used;
+			ret = btrfs_end_transaction(trans, root);
+			BUG_ON(ret);
+			btrfs_btree_balance_dirty(root, nr);
+		}
+
+		free_extent_buffer(reloc_root->node);
+
+		ret = btrfs_del_root(trans, root->fs_info->tree_root,
+				     &reloc_root->root_key);
+		BUG_ON(ret);
+		mutex_unlock(&root->fs_info->drop_mutex);
+
+		nr = trans->blocks_used;
+		ret = btrfs_end_transaction(trans, root);
+		BUG_ON(ret);
+		btrfs_btree_balance_dirty(root, nr);
+
+		kfree(prev_root);
+		prev_root = reloc_root;
+	}
+	if (prev_root) {
+		btrfs_remove_leaf_refs(prev_root, (u64)-1, 0);
+		kfree(prev_root);
+	}
+	return 0;
+}
+
+int btrfs_add_dead_reloc_root(struct btrfs_root *root)
+{
+	list_add(&root->dead_list, &root->fs_info->dead_reloc_roots);
+	return 0;
+}
+
+int btrfs_cleanup_reloc_trees(struct btrfs_root *root)
+{
+	struct btrfs_root *reloc_root;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_key location;
+	int found;
+	int ret;
+
+	mutex_lock(&root->fs_info->tree_reloc_mutex);
+	ret = btrfs_find_dead_roots(root, BTRFS_TREE_RELOC_OBJECTID, NULL);
+	BUG_ON(ret);
+	found = !list_empty(&root->fs_info->dead_reloc_roots);
+	mutex_unlock(&root->fs_info->tree_reloc_mutex);
+
+	if (found) {
+		trans = btrfs_start_transaction(root, 1);
+		BUG_ON(!trans);
+		ret = btrfs_commit_transaction(trans, root);
+		BUG_ON(ret);
+	}
+
+	location.objectid = BTRFS_DATA_RELOC_TREE_OBJECTID;
+	location.offset = (u64)-1;
+	location.type = BTRFS_ROOT_ITEM_KEY;
+
+	reloc_root = btrfs_read_fs_root_no_name(root->fs_info, &location);
+	BUG_ON(!reloc_root);
+	btrfs_orphan_cleanup(reloc_root);
+	return 0;
+}
+
+static int noinline init_reloc_tree(struct btrfs_trans_handle *trans,
+				    struct btrfs_root *root)
+{
+	struct btrfs_root *reloc_root;
+	struct extent_buffer *eb;
+	struct btrfs_root_item *root_item;
+	struct btrfs_key root_key;
+	int ret;
+
+	BUG_ON(!root->ref_cows);
+	if (root->reloc_root)
+		return 0;
+
+	root_item = kmalloc(sizeof(*root_item), GFP_NOFS);
+	BUG_ON(!root_item);
+
+	ret = btrfs_copy_root(trans, root, root->commit_root,
+			      &eb, BTRFS_TREE_RELOC_OBJECTID);
+	BUG_ON(ret);
+
+	root_key.objectid = BTRFS_TREE_RELOC_OBJECTID;
+	root_key.offset = root->root_key.objectid;
+	root_key.type = BTRFS_ROOT_ITEM_KEY;
+
+	memcpy(root_item, &root->root_item, sizeof(root_item));
+	btrfs_set_root_refs(root_item, 0);
+	btrfs_set_root_bytenr(root_item, eb->start);
+	btrfs_set_root_level(root_item, btrfs_header_level(eb));
+	memset(&root_item->drop_progress, 0, sizeof(root_item->drop_progress));
+	root_item->drop_level = 0;
+
+	btrfs_tree_unlock(eb);
+	free_extent_buffer(eb);
+
+	ret = btrfs_insert_root(trans, root->fs_info->tree_root,
+				&root_key, root_item);
+	BUG_ON(ret);
+	kfree(root_item);
+
+	reloc_root = btrfs_read_fs_root_no_radix(root->fs_info->tree_root,
+						 &root_key);
+	BUG_ON(!reloc_root);
+	reloc_root->last_trans = trans->transid;
+	reloc_root->commit_root = NULL;
+	reloc_root->ref_tree = &root->fs_info->reloc_ref_tree;
+
+	root->reloc_root = reloc_root;
+	return 0;
+}
+
+/*
+ * Core function of space balance.
+ *
+ * The idea is using reloc trees to relocate tree blocks in reference
+ * counted roots. There is one reloc tree for each subvol, all reloc
+ * trees share same key objectid. Reloc trees are snapshots of the
+ * latest committed roots (subvol root->commit_root). To relocate a tree
+ * block referenced by a subvol, the code COW the block through the reloc
+ * tree, then update pointer in the subvol to point to the new block.
+ * Since all reloc trees share same key objectid, we can easily do special
+ * handing to share tree blocks between reloc trees. Once a tree block has
+ * been COWed in one reloc tree, we can use the result when the same block
+ * is COWed again through other reloc trees.
+ */
+static int noinline relocate_one_path(struct btrfs_trans_handle *trans,
+				      struct btrfs_root *root,
+				      struct btrfs_path *path,
+				      struct btrfs_key *first_key,
+				      struct btrfs_ref_path *ref_path,
+				      struct btrfs_block_group_cache *group,
+				      struct inode *reloc_inode)
+{
+	struct btrfs_root *reloc_root;
+	struct extent_buffer *eb = NULL;
+	struct btrfs_key *keys;
+	u64 *nodes;
+	int level;
+	int lowest_merge;
+	int lowest_level = 0;
+	int update_refs;
+	int ret;
+
+	if (ref_path->owner_objectid < BTRFS_FIRST_FREE_OBJECTID)
+		lowest_level = ref_path->owner_objectid;
+
+	if (is_cowonly_root(ref_path->root_objectid)) {
+		path->lowest_level = lowest_level;
+		ret = btrfs_search_slot(trans, root, first_key, path, 0, 1);
+		BUG_ON(ret < 0);
+		path->lowest_level = 0;
+		btrfs_release_path(root, path);
+		return 0;
+	}
+
+	keys = kzalloc(sizeof(*keys) * BTRFS_MAX_LEVEL, GFP_NOFS);
+	BUG_ON(!keys);
+	nodes = kzalloc(sizeof(*nodes) * BTRFS_MAX_LEVEL, GFP_NOFS);
+	BUG_ON(!nodes);
+
+	mutex_lock(&root->fs_info->tree_reloc_mutex);
+	ret = init_reloc_tree(trans, root);
+	BUG_ON(ret);
+	reloc_root = root->reloc_root;
+
+	path->lowest_level = lowest_level;
+	ret = btrfs_search_slot(trans, reloc_root, first_key, path, 0, 0);
+	BUG_ON(ret);
+	/*
+	 * get relocation mapping for tree blocks in the path
+	 */
+	lowest_merge = BTRFS_MAX_LEVEL;
+	for (level = BTRFS_MAX_LEVEL - 1; level >= lowest_level; level--) {
+		u64 new_bytenr;
+		eb = path->nodes[level];
+		if (!eb || eb == reloc_root->node)
+			continue;
+		ret = btrfs_get_reloc_mapping(reloc_root, eb->start, eb->len,
+					      &new_bytenr);
+		if (ret)
+			continue;
+		if (level == 0)
+			btrfs_item_key_to_cpu(eb, &keys[level], 0);
+		else
+			btrfs_node_key_to_cpu(eb, &keys[level], 0);
+		nodes[level] = new_bytenr;
+		lowest_merge = level;
+	}
+
+	update_refs = 0;
+	if (ref_path->owner_objectid >= BTRFS_FIRST_FREE_OBJECTID) {
+		eb = path->nodes[0];
+		if (btrfs_header_generation(eb) < trans->transid)
+			update_refs = 1;
+	}
+
+	btrfs_release_path(reloc_root, path);
+	/*
+	 * merge tree blocks that already relocated in other reloc trees
+	 */
+	if (lowest_merge != BTRFS_MAX_LEVEL) {
+		ret = btrfs_merge_path(trans, reloc_root, keys, nodes,
+				       lowest_merge);
+		BUG_ON(ret < 0);
+	}
+	/*
+	 * cow any tree blocks that still haven't been relocated
+	 */
+	ret = btrfs_search_slot(trans, reloc_root, first_key, path, 0, 1);
+	BUG_ON(ret);
+	/*
+	 * if we are relocating data block group, update extent pointers
+	 * in the newly created tree leaf.
+	 */
+	eb = path->nodes[0];
+	if (update_refs && nodes[0] != eb->start) {
+		ret = replace_extents_in_leaf(trans, reloc_root, eb, group,
+					      reloc_inode);
+		BUG_ON(ret);
+	}
+
+	memset(keys, 0, sizeof(*keys) * BTRFS_MAX_LEVEL);
+	memset(nodes, 0, sizeof(*nodes) * BTRFS_MAX_LEVEL);
+	for (level = BTRFS_MAX_LEVEL - 1; level >= lowest_level; level--) {
+		eb = path->nodes[level];
+		if (!eb || eb == reloc_root->node)
+			continue;
+		BUG_ON(btrfs_header_owner(eb) != BTRFS_TREE_RELOC_OBJECTID);
+		nodes[level] = eb->start;
+		if (level == 0)
+			btrfs_item_key_to_cpu(eb, &keys[level], 0);
+		else
+			btrfs_node_key_to_cpu(eb, &keys[level], 0);
+	}
+
+	if (ref_path->owner_objectid >= BTRFS_FIRST_FREE_OBJECTID) {
+		eb = path->nodes[0];
+		extent_buffer_get(eb);
+	}
+	btrfs_release_path(reloc_root, path);
+	/*
+	 * replace tree blocks in the fs tree with tree blocks in
+	 * the reloc tree.
+	 */
+	ret = btrfs_merge_path(trans, root, keys, nodes, lowest_level);
+	BUG_ON(ret < 0);
+
+	if (ref_path->owner_objectid >= BTRFS_FIRST_FREE_OBJECTID) {
+		ret = invalidate_extent_cache(reloc_root, eb, group, root);
+		BUG_ON(ret);
+		free_extent_buffer(eb);
+	}
+	mutex_unlock(&root->fs_info->tree_reloc_mutex);
+
 	path->lowest_level = 0;
-	return ret;
-}
-
-/*
- * note, this releases the path
- */
-static int noinline relocate_one_reference(struct btrfs_root *extent_root,
-				  struct btrfs_path *path,
-				  struct btrfs_key *extent_key,
-				  u64 *last_file_objectid,
-				  u64 *last_file_offset,
-				  u64 *last_file_root,
-				  u64 last_extent)
-{
-	struct inode *inode;
-	struct btrfs_root *found_root;
-	struct btrfs_key root_location;
-	struct btrfs_key found_key;
-	struct btrfs_extent_ref *ref;
-	u64 ref_root;
-	u64 ref_gen;
-	u64 ref_objectid;
-	u64 ref_offset;
-	int ret;
-	int level;
-
-	WARN_ON(!mutex_is_locked(&extent_root->fs_info->alloc_mutex));
-
-	ref = btrfs_item_ptr(path->nodes[0], path->slots[0],
-			     struct btrfs_extent_ref);
-	ref_root = btrfs_ref_root(path->nodes[0], ref);
-	ref_gen = btrfs_ref_generation(path->nodes[0], ref);
-	ref_objectid = btrfs_ref_objectid(path->nodes[0], ref);
-	ref_offset = btrfs_ref_offset(path->nodes[0], ref);
-	btrfs_release_path(extent_root, path);
-
-	root_location.objectid = ref_root;
-	if (ref_gen == 0)
-		root_location.offset = 0;
-	else
-		root_location.offset = (u64)-1;
-	root_location.type = BTRFS_ROOT_ITEM_KEY;
-
-	found_root = btrfs_read_fs_root_no_name(extent_root->fs_info,
-						&root_location);
-	BUG_ON(!found_root);
-	mutex_unlock(&extent_root->fs_info->alloc_mutex);
-
-	if (ref_objectid >= BTRFS_FIRST_FREE_OBJECTID) {
-		found_key.objectid = ref_objectid;
-		found_key.type = BTRFS_EXTENT_DATA_KEY;
-		found_key.offset = ref_offset;
-		level = 0;
-
-		if (last_extent == extent_key->objectid &&
-		    *last_file_objectid == ref_objectid &&
-		    *last_file_offset == ref_offset &&
-		    *last_file_root == ref_root)
-			goto out;
-
-		ret = find_root_for_ref(extent_root, path, &found_key,
-					level, 1, &found_root,
-					extent_key->objectid);
-
-		if (ret)
-			goto out;
-
-		if (last_extent == extent_key->objectid &&
-		    *last_file_objectid == ref_objectid &&
-		    *last_file_offset == ref_offset &&
-		    *last_file_root == ref_root)
-			goto out;
-
-		inode = btrfs_iget_locked(extent_root->fs_info->sb,
-					  ref_objectid, found_root);
-		if (inode->i_state & I_NEW) {
-			/* the inode and parent dir are two different roots */
-			BTRFS_I(inode)->root = found_root;
-			BTRFS_I(inode)->location.objectid = ref_objectid;
-			BTRFS_I(inode)->location.type = BTRFS_INODE_ITEM_KEY;
-			BTRFS_I(inode)->location.offset = 0;
-			btrfs_read_locked_inode(inode);
-			unlock_new_inode(inode);
-
-		}
-		/* this can happen if the reference is not against
-		 * the latest version of the tree root
-		 */
-		if (is_bad_inode(inode))
-			goto out;
-
-		*last_file_objectid = inode->i_ino;
-		*last_file_root = found_root->root_key.objectid;
-		*last_file_offset = ref_offset;
-
-		relocate_inode_pages(inode, ref_offset, extent_key->offset);
-		iput(inode);
-	} else {
-		struct btrfs_trans_handle *trans;
-		struct extent_buffer *eb;
-		int needs_lock = 0;
-
-		eb = read_tree_block(found_root, extent_key->objectid,
-				     extent_key->offset, 0);
-		btrfs_tree_lock(eb);
-		level = btrfs_header_level(eb);
-
-		if (level == 0)
-			btrfs_item_key_to_cpu(eb, &found_key, 0);
-		else
-			btrfs_node_key_to_cpu(eb, &found_key, 0);
-
-		btrfs_tree_unlock(eb);
-		free_extent_buffer(eb);
-
-		ret = find_root_for_ref(extent_root, path, &found_key,
-					level, 0, &found_root,
-					extent_key->objectid);
-
-		if (ret)
-			goto out;
-
-		/*
-		 * right here almost anything could happen to our key,
-		 * but that's ok.  The cow below will either relocate it
-		 * or someone else will have relocated it.  Either way,
-		 * it is in a different spot than it was before and
-		 * we're happy.
-		 */
-
-		trans = btrfs_start_transaction(found_root, 1);
-
-		if (found_root == extent_root->fs_info->extent_root ||
-		    found_root == extent_root->fs_info->chunk_root ||
-		    found_root == extent_root->fs_info->dev_root) {
-			needs_lock = 1;
-			mutex_lock(&extent_root->fs_info->alloc_mutex);
-		}
-
-		path->lowest_level = level;
-		path->reada = 2;
-		ret = btrfs_search_slot(trans, found_root, &found_key, path,
-					0, 1);
-		path->lowest_level = 0;
-		btrfs_release_path(found_root, path);
-
-		if (found_root == found_root->fs_info->extent_root)
-			btrfs_extent_post_op(trans, found_root);
-		if (needs_lock)
-			mutex_unlock(&extent_root->fs_info->alloc_mutex);
-
-		btrfs_end_transaction(trans, found_root);
-
-	}
-out:
-	mutex_lock(&extent_root->fs_info->alloc_mutex);
-	return 0;
-}
-
-static int noinline del_extent_zero(struct btrfs_root *extent_root,
+	kfree(nodes);
+	kfree(keys);
+	return 0;
+}
+
+static int noinline relocate_tree_block(struct btrfs_trans_handle *trans,
+					struct btrfs_root *root,
+					struct btrfs_path *path,
+					struct btrfs_key *first_key,
+					struct btrfs_ref_path *ref_path)
+{
+	int ret;
+	int needs_lock = 0;
+
+	if (root == root->fs_info->extent_root ||
+	    root == root->fs_info->chunk_root ||
+	    root == root->fs_info->dev_root) {
+		needs_lock = 1;
+		mutex_lock(&root->fs_info->alloc_mutex);
+	}
+
+	ret = relocate_one_path(trans, root, path, first_key,
+				ref_path, NULL, NULL);
+	BUG_ON(ret);
+
+	if (root == root->fs_info->extent_root)
+		btrfs_extent_post_op(trans, root);
+	if (needs_lock)
+		mutex_unlock(&root->fs_info->alloc_mutex);
+
+	return 0;
+}
+
+static int noinline del_extent_zero(struct btrfs_trans_handle *trans,
+				    struct btrfs_root *extent_root,
 				    struct btrfs_path *path,
 				    struct btrfs_key *extent_key)
 {
 	int ret;
-	struct btrfs_trans_handle *trans;
-
-	trans = btrfs_start_transaction(extent_root, 1);
+
+	mutex_lock(&extent_root->fs_info->alloc_mutex);
 	ret = btrfs_search_slot(trans, extent_root, extent_key, path, -1, 1);
-	if (ret > 0) {
-		ret = -EIO;
-		goto out;
-	}
-	if (ret < 0)
+	if (ret)
 		goto out;
 	ret = btrfs_del_item(trans, extent_root, path);
 out:
-	btrfs_end_transaction(trans, extent_root);
-	return ret;
+	btrfs_release_path(extent_root, path);
+	mutex_unlock(&extent_root->fs_info->alloc_mutex);
+	return ret;
+}
+
+static struct btrfs_root noinline *read_ref_root(struct btrfs_fs_info *fs_info,
+						struct btrfs_ref_path *ref_path)
+{
+	struct btrfs_key root_key;
+
+	root_key.objectid = ref_path->root_objectid;
+	root_key.type = BTRFS_ROOT_ITEM_KEY;
+	if (is_cowonly_root(ref_path->root_objectid))
+		root_key.offset = 0;
+	else
+		root_key.offset = (u64)-1;
+
+	return btrfs_read_fs_root_no_name(fs_info, &root_key);
 }
 
 static int noinline relocate_one_extent(struct btrfs_root *extent_root,
 					struct btrfs_path *path,
-					struct btrfs_key *extent_key)
-{
-	struct btrfs_key key;
-	struct btrfs_key found_key;
-	struct extent_buffer *leaf;
-	u64 last_file_objectid = 0;
-	u64 last_file_root = 0;
-	u64 last_file_offset = (u64)-1;
-	u64 last_extent = 0;
-	u32 nritems;
-	u32 item_size;
-	int ret = 0;
+					struct btrfs_key *extent_key,
+					struct btrfs_block_group_cache *group,
+					struct inode *reloc_inode, int pass)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *found_root;
+	struct btrfs_ref_path *ref_path = NULL;
+	struct disk_extent *new_extents = NULL;
+	int nr_extents = 0;
+	int loops;
+	int ret;
+	int level;
+	struct btrfs_key first_key;
+	u64 prev_block = 0;
+
+	mutex_unlock(&extent_root->fs_info->alloc_mutex);
+
+	trans = btrfs_start_transaction(extent_root, 1);
+	BUG_ON(!trans);
 
 	if (extent_key->objectid == 0) {
-		ret = del_extent_zero(extent_root, path, extent_key);
-		goto out;
-	}
-	key.objectid = extent_key->objectid;
-	key.type = BTRFS_EXTENT_REF_KEY;
-	key.offset = 0;
-
-	while(1) {
-		ret = btrfs_search_slot(NULL, extent_root, &key, path, 0, 0);
-
-		if (ret < 0)
-			goto out;
-
-		ret = 0;
-		leaf = path->nodes[0];
-		nritems = btrfs_header_nritems(leaf);
-		if (path->slots[0] == nritems) {
-			ret = btrfs_next_leaf(extent_root, path);
-			if (ret > 0) {
-				ret = 0;
-				goto out;
-			}
-			if (ret < 0)
-				goto out;
-			leaf = path->nodes[0];
-		}
-
-		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
-		if (found_key.objectid != extent_key->objectid) {
-			break;
-		}
-
-		if (found_key.type != BTRFS_EXTENT_REF_KEY) {
-			break;
-		}
-
-		key.offset = found_key.offset + 1;
-		item_size = btrfs_item_size_nr(leaf, path->slots[0]);
-
-		ret = relocate_one_reference(extent_root, path, extent_key,
-					     &last_file_objectid,
-					     &last_file_offset,
-					     &last_file_root, last_extent);
-		if (ret)
-			goto out;
-		last_extent = extent_key->objectid;
-	}
-	ret = 0;
-out:
-	btrfs_release_path(extent_root, path);
+		ret = del_extent_zero(trans, extent_root, path, extent_key);
+		goto out;
+	}
+
+	ref_path = kmalloc(sizeof(*ref_path), GFP_NOFS);
+	if (!ref_path) {
+	       ret = -ENOMEM;
+	       goto out;
+	}
+
+	for (loops = 0; ; loops++) {
+		if (loops == 0) {
+			ret = btrfs_first_ref_path(trans, extent_root, ref_path,
+						   extent_key->objectid);
+		} else {
+			ret = btrfs_next_ref_path(trans, extent_root, ref_path);
+		}
+		if (ret < 0)
+			goto out;
+		if (ret > 0)
+			break;
+
+		if (ref_path->root_objectid == BTRFS_TREE_LOG_OBJECTID ||
+		    ref_path->root_objectid == BTRFS_TREE_RELOC_OBJECTID)
+			continue;
+
+		found_root = read_ref_root(extent_root->fs_info, ref_path);
+		BUG_ON(!found_root);
+		/*
+		 * for reference counted tree, only process reference paths
+		 * rooted at the latest committed root.
+		 */
+		if (found_root->ref_cows &&
+		    ref_path->root_generation != found_root->root_key.offset)
+			continue;
+
+		if (ref_path->owner_objectid >= BTRFS_FIRST_FREE_OBJECTID) {
+			if (pass == 0) {
+				/*
+				 * copy data extents to new locations
+				 */
+				u64 group_start = group->key.objectid;
+				ret = relocate_data_extent(reloc_inode,
+							   extent_key,
+							   group_start);
+				if (ret < 0)
+					goto out;
+				break;
+			}
+			level = 0;
+		} else {
+			level = ref_path->owner_objectid;
+		}
+
+		if (prev_block != ref_path->nodes[level]) {
+			struct extent_buffer *eb;
+			u64 block_start = ref_path->nodes[level];
+			u64 block_size = btrfs_level_size(found_root, level);
+
+			eb = read_tree_block(found_root, block_start,
+					     block_size, 0);
+			btrfs_tree_lock(eb);
+			BUG_ON(level != btrfs_header_level(eb));
+
+			if (level == 0)
+				btrfs_item_key_to_cpu(eb, &first_key, 0);
+			else
+				btrfs_node_key_to_cpu(eb, &first_key, 0);
+
+			btrfs_tree_unlock(eb);
+			free_extent_buffer(eb);
+			prev_block = block_start;
+		}
+
+		if (ref_path->owner_objectid >= BTRFS_FIRST_FREE_OBJECTID &&
+		    pass >= 2) {
+			/*
+			 * use fallback method to process the remaining
+			 * references.
+			 */
+			if (!new_extents) {
+				u64 group_start = group->key.objectid;
+				ret = get_new_locations(reloc_inode,
+							extent_key,
+							group_start, 0,
+							&new_extents,
+							&nr_extents);
+				if (ret < 0)
+					goto out;
+			}
+			btrfs_record_root_in_trans(found_root);
+			ret = replace_one_extent(trans, found_root,
+						path, extent_key,
+						&first_key, ref_path,
+						new_extents, nr_extents);
+			if (ret < 0)
+				goto out;
+			continue;
+		}
+
+		btrfs_record_root_in_trans(found_root);
+		if (ref_path->owner_objectid < BTRFS_FIRST_FREE_OBJECTID) {
+			ret = relocate_tree_block(trans, found_root, path,
+						  &first_key, ref_path);
+		} else {
+			/*
+			 * try to update data extent references while
+			 * keeping metadata shared between snapshots.
+			 */
+			ret = relocate_one_path(trans, found_root, path,
+						&first_key, ref_path,
+						group, reloc_inode);
+		}
+		if (ret < 0)
+			goto out;
+	}
+	ret = 0;
+out:
+	btrfs_end_transaction(trans, extent_root);
+	kfree(new_extents);
+	kfree(ref_path);
+	mutex_lock(&extent_root->fs_info->alloc_mutex);
 	return ret;
 }
 
@@ -3682,84 +4780,155 @@
 	return 0;
 }
 
-int btrfs_shrink_extent_tree(struct btrfs_root *root, u64 shrink_start)
-{
-	struct btrfs_trans_handle *trans;
-	struct btrfs_root *tree_root = root->fs_info->tree_root;
-	struct btrfs_path *path;
+static int __insert_orphan_inode(struct btrfs_trans_handle *trans,
+				 struct btrfs_root *root,
+				 u64 objectid, u64 size)
+{
+	struct btrfs_path *path;
+	struct btrfs_inode_item *item;
+	struct extent_buffer *leaf;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	ret = btrfs_insert_empty_inode(trans, root, path, objectid);
+	if (ret)
+		goto out;
+
+	leaf = path->nodes[0];
+	item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_inode_item);
+	memset_extent_buffer(leaf, 0, (unsigned long)item, sizeof(*item));
+	btrfs_set_inode_generation(leaf, item, 1);
+	btrfs_set_inode_size(leaf, item, size);
+	btrfs_set_inode_mode(leaf, item, S_IFREG | 0600);
+	btrfs_set_inode_flags(leaf, item, BTRFS_INODE_NODATASUM);
+	btrfs_mark_buffer_dirty(leaf);
+	btrfs_release_path(root, path);
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
+static struct inode noinline *create_reloc_inode(struct btrfs_fs_info *fs_info,
+					struct btrfs_block_group_cache *group)
+{
+	struct inode *inode = NULL;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *root;
+	struct btrfs_key root_key;
+	u64 objectid = BTRFS_FIRST_FREE_OBJECTID;
+	int err = 0;
+
+	root_key.objectid = BTRFS_DATA_RELOC_TREE_OBJECTID;
+	root_key.type = BTRFS_ROOT_ITEM_KEY;
+	root_key.offset = (u64)-1;
+	root = btrfs_read_fs_root_no_name(fs_info, &root_key);
+	if (IS_ERR(root))
+		return ERR_CAST(root);
+
+	trans = btrfs_start_transaction(root, 1);
+	BUG_ON(!trans);
+
+	err = btrfs_find_free_objectid(trans, root, objectid, &objectid);
+	if (err)
+		goto out;
+
+	err = __insert_orphan_inode(trans, root, objectid, group->key.offset);
+	BUG_ON(err);
+
+	err = btrfs_insert_file_extent(trans, root, objectid, 0, 0, 0,
+				       group->key.offset, 0);
+	BUG_ON(err);
+
+	inode = btrfs_iget_locked(root->fs_info->sb, objectid, root);
+	if (inode->i_state & I_NEW) {
+		BTRFS_I(inode)->root = root;
+		BTRFS_I(inode)->location.objectid = objectid;
+		BTRFS_I(inode)->location.type = BTRFS_INODE_ITEM_KEY;
+		BTRFS_I(inode)->location.offset = 0;
+		btrfs_read_locked_inode(inode);
+		unlock_new_inode(inode);
+		BUG_ON(is_bad_inode(inode));
+	} else {
+		BUG_ON(1);
+	}
+
+	err = btrfs_orphan_add(trans, inode);
+out:
+	btrfs_end_transaction(trans, root);
+	if (err) {
+		if (inode)
+			iput(inode);
+		inode = ERR_PTR(err);
+	}
+	return inode;
+}
+
+int btrfs_relocate_block_group(struct btrfs_root *root, u64 group_start)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_path *path;
+	struct btrfs_fs_info *info = root->fs_info;
+	struct extent_buffer *leaf;
+	struct inode *reloc_inode;
+	struct btrfs_block_group_cache *block_group;
+	struct btrfs_key key;
 	u64 cur_byte;
 	u64 total_found;
-	u64 shrink_last_byte;
-	struct btrfs_block_group_cache *shrink_block_group;
-	struct btrfs_key key;
-	struct btrfs_key found_key;
-	struct extent_buffer *leaf;
 	u32 nritems;
 	int ret;
 	int progress;
-
-	mutex_lock(&root->fs_info->alloc_mutex);
-	shrink_block_group = btrfs_lookup_block_group(root->fs_info,
-						      shrink_start);
-	BUG_ON(!shrink_block_group);
-
-	shrink_last_byte = shrink_block_group->key.objectid +
-		shrink_block_group->key.offset;
-
-	shrink_block_group->space_info->total_bytes -=
-		shrink_block_group->key.offset;
-	path = btrfs_alloc_path();
+	int pass = 0;
+
 	root = root->fs_info->extent_root;
-	path->reada = 2;
+
+	block_group = btrfs_lookup_block_group(info, group_start);
+	BUG_ON(!block_group);
 
 	printk("btrfs relocating block group %llu flags %llu\n",
-	       (unsigned long long)shrink_start,
-	       (unsigned long long)shrink_block_group->flags);
-
-	__alloc_chunk_for_shrink(root, shrink_block_group, 1);
-
+	       (unsigned long long)block_group->key.objectid,
+	       (unsigned long long)block_group->flags);
+
+	path = btrfs_alloc_path();
+	BUG_ON(!path);
+
+	reloc_inode = create_reloc_inode(info, block_group);
+	BUG_ON(IS_ERR(reloc_inode));
+
+	mutex_lock(&root->fs_info->alloc_mutex);
+
+	__alloc_chunk_for_shrink(root, block_group, 1);
+	block_group->ro = 1;
+	block_group->space_info->total_bytes -= block_group->key.offset;
+
+	mutex_unlock(&root->fs_info->alloc_mutex);
+
+	btrfs_start_delalloc_inodes(info->tree_root);
+	btrfs_wait_ordered_extents(info->tree_root, 0);
 again:
-
-	shrink_block_group->ro = 1;
-
 	total_found = 0;
 	progress = 0;
-	key.objectid = shrink_start;
+	key.objectid = block_group->key.objectid;
 	key.offset = 0;
 	key.type = 0;
 	cur_byte = key.objectid;
 
-	mutex_unlock(&root->fs_info->alloc_mutex);
-
-	btrfs_start_delalloc_inodes(root);
-	btrfs_wait_ordered_extents(tree_root, 0);
-
-	mutex_lock(&root->fs_info->alloc_mutex);
-
-	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
-	if (ret < 0)
-		goto out;
-
-	ret = btrfs_previous_item(root, path, 0, BTRFS_EXTENT_ITEM_KEY);
-	if (ret < 0)
-		goto out;
-
-	if (ret == 0) {
-		leaf = path->nodes[0];
-		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
-		if (found_key.objectid + found_key.offset > shrink_start &&
-		    found_key.objectid < shrink_last_byte) {
-			cur_byte = found_key.objectid;
-			key.objectid = cur_byte;
-		}
-	}
-	btrfs_release_path(root, path);
+	trans = btrfs_start_transaction(info->tree_root, 1);
+	btrfs_commit_transaction(trans, info->tree_root);
+
+	mutex_lock(&root->fs_info->cleaner_mutex);
+	btrfs_clean_old_snapshots(info->tree_root);
+	btrfs_remove_leaf_refs(info->tree_root, (u64)-1, 1);
+	mutex_unlock(&root->fs_info->cleaner_mutex);
+
+	mutex_lock(&root->fs_info->alloc_mutex);
 
 	while(1) {
 		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 		if (ret < 0)
 			goto out;
-
 next:
 		leaf = path->nodes[0];
 		nritems = btrfs_header_nritems(leaf);
@@ -3775,109 +4944,76 @@
 			nritems = btrfs_header_nritems(leaf);
 		}
 
-		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
-
-		if (found_key.objectid >= shrink_last_byte)
+		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+
+		if (key.objectid >= block_group->key.objectid +
+		    block_group->key.offset)
 			break;
 
 		if (progress && need_resched()) {
-			memcpy(&key, &found_key, sizeof(key));
-			cond_resched();
-			btrfs_release_path(root, path);
-			btrfs_search_slot(NULL, root, &key, path, 0, 0);
+			btrfs_release_path(root, path);
+			mutex_unlock(&root->fs_info->alloc_mutex);
+			cond_resched();
+			mutex_lock(&root->fs_info->alloc_mutex);
 			progress = 0;
-			goto next;
+			continue;
 		}
 		progress = 1;
 
-		if (btrfs_key_type(&found_key) != BTRFS_EXTENT_ITEM_KEY ||
-		    found_key.objectid + found_key.offset <= cur_byte) {
-			memcpy(&key, &found_key, sizeof(key));
-			key.offset++;
+		if (btrfs_key_type(&key) != BTRFS_EXTENT_ITEM_KEY ||
+		    key.objectid + key.offset <= cur_byte) {
 			path->slots[0]++;
 			goto next;
 		}
 
 		total_found++;
-		cur_byte = found_key.objectid + found_key.offset;
+		cur_byte = key.objectid + key.offset;
+		btrfs_release_path(root, path);
+
+		__alloc_chunk_for_shrink(root, block_group, 0);
+		ret = relocate_one_extent(root, path, &key, block_group,
+					  reloc_inode, pass);
+		BUG_ON(ret < 0);
+
 		key.objectid = cur_byte;
-		btrfs_release_path(root, path);
-		ret = relocate_one_extent(root, path, &found_key);
-		__alloc_chunk_for_shrink(root, shrink_block_group, 0);
+		key.type = 0;
+		key.offset = 0;
 	}
 
 	btrfs_release_path(root, path);
+	mutex_unlock(&root->fs_info->alloc_mutex);
+
+	if (pass == 0) {
+		btrfs_wait_ordered_range(reloc_inode, 0, (u64)-1);
+		invalidate_mapping_pages(reloc_inode->i_mapping, 0, -1);
+		WARN_ON(reloc_inode->i_mapping->nrpages);
+	}
 
 	if (total_found > 0) {
-		printk("btrfs relocate found %llu last extent was %llu\n",
-		       (unsigned long long)total_found,
-		       (unsigned long long)found_key.objectid);
-		mutex_unlock(&root->fs_info->alloc_mutex);
-		trans = btrfs_start_transaction(tree_root, 1);
-		btrfs_commit_transaction(trans, tree_root);
-
-		btrfs_clean_old_snapshots(tree_root);
-
-		btrfs_start_delalloc_inodes(root);
-		btrfs_wait_ordered_extents(tree_root, 0);
-
-		trans = btrfs_start_transaction(tree_root, 1);
-		btrfs_commit_transaction(trans, tree_root);
-		mutex_lock(&root->fs_info->alloc_mutex);
+		printk("btrfs found %llu extents in pass %d\n",
+		       (unsigned long long)total_found, pass);
+		pass++;
 		goto again;
 	}
 
-	/*
-	 * we've freed all the extents, now remove the block
-	 * group item from the tree
-	 */
-	mutex_unlock(&root->fs_info->alloc_mutex);
-
-	trans = btrfs_start_transaction(root, 1);
-
-	mutex_lock(&root->fs_info->alloc_mutex);
-	memcpy(&key, &shrink_block_group->key, sizeof(key));
-
-	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
-	if (ret > 0)
-		ret = -EIO;
-	if (ret < 0) {
-		btrfs_end_transaction(trans, root);
-		goto out;
-	}
-
-	spin_lock(&root->fs_info->block_group_cache_lock);
-	rb_erase(&shrink_block_group->cache_node,
-		 &root->fs_info->block_group_cache_tree);
-	spin_unlock(&root->fs_info->block_group_cache_lock);
-
-	ret = btrfs_remove_free_space(shrink_block_group, key.objectid,
-				      key.offset);
-	if (ret) {
-		btrfs_end_transaction(trans, root);
-		goto out;
-	}
-	/*
-	memset(shrink_block_group, 0, sizeof(*shrink_block_group));
-	kfree(shrink_block_group);
-	*/
-
-	btrfs_del_item(trans, root, path);
-	btrfs_release_path(root, path);
-	mutex_unlock(&root->fs_info->alloc_mutex);
-	btrfs_commit_transaction(trans, root);
-
-	mutex_lock(&root->fs_info->alloc_mutex);
-
-	/* the code to unpin extents might set a few bits in the free
-	 * space cache for this range again
-	 */
-	/* XXX? */
-	ret = btrfs_remove_free_space(shrink_block_group, key.objectid,
-				      key.offset);
-out:
-	btrfs_free_path(path);
-	mutex_unlock(&root->fs_info->alloc_mutex);
+	/* delete reloc_inode */
+	iput(reloc_inode);
+
+	/* unpin extents in this range */
+	trans = btrfs_start_transaction(info->tree_root, 1);
+	btrfs_commit_transaction(trans, info->tree_root);
+
+	mutex_lock(&root->fs_info->alloc_mutex);
+
+	spin_lock(&block_group->lock);
+	WARN_ON(block_group->pinned > 0);
+	WARN_ON(block_group->reserved > 0);
+	WARN_ON(btrfs_block_group_used(&block_group->item) > 0);
+	spin_unlock(&block_group->lock);
+	ret = 0;
+out:
+	mutex_unlock(&root->fs_info->alloc_mutex);
+	btrfs_free_path(path);
 	return ret;
 }
 
@@ -3916,6 +5052,30 @@
 	ret = -ENOENT;
 out:
 	return ret;
+}
+
+int btrfs_free_block_groups(struct btrfs_fs_info *info)
+{
+	struct btrfs_block_group_cache *block_group;
+	struct rb_node *n;
+
+	mutex_lock(&info->alloc_mutex);
+	spin_lock(&info->block_group_cache_lock);
+	while ((n = rb_last(&info->block_group_cache_tree)) != NULL) {
+		block_group = rb_entry(n, struct btrfs_block_group_cache,
+				       cache_node);
+
+		btrfs_remove_free_space_cache(block_group);
+		rb_erase(&block_group->cache_node,
+			 &info->block_group_cache_tree);
+		spin_lock(&block_group->space_info->lock);
+		list_del(&block_group->list);
+		spin_unlock(&block_group->space_info->lock);
+		kfree(block_group);
+	}
+	spin_unlock(&info->block_group_cache_lock);
+	mutex_unlock(&info->alloc_mutex);
+	return 0;
 }
 
 int btrfs_read_block_groups(struct btrfs_root *root)
@@ -4035,3 +5195,46 @@
 
 	return 0;
 }
+
+int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
+			     struct btrfs_root *root, u64 group_start)
+{
+	struct btrfs_path *path;
+	struct btrfs_block_group_cache *block_group;
+	struct btrfs_key key;
+	int ret;
+
+	BUG_ON(!mutex_is_locked(&root->fs_info->alloc_mutex));
+	root = root->fs_info->extent_root;
+
+	block_group = btrfs_lookup_block_group(root->fs_info, group_start);
+	BUG_ON(!block_group);
+
+	memcpy(&key, &block_group->key, sizeof(key));
+
+	path = btrfs_alloc_path();
+	BUG_ON(!path);
+
+	btrfs_remove_free_space_cache(block_group);
+	rb_erase(&block_group->cache_node,
+		 &root->fs_info->block_group_cache_tree);
+	spin_lock(&block_group->space_info->lock);
+	list_del(&block_group->list);
+	spin_unlock(&block_group->space_info->lock);
+
+	/*
+	memset(shrink_block_group, 0, sizeof(*shrink_block_group));
+	kfree(shrink_block_group);
+	*/
+
+	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+	if (ret > 0)
+		ret = -EIO;
+	if (ret < 0)
+		goto out;
+
+	ret = btrfs_del_item(trans, root, path);
+out:
+	btrfs_free_path(path);
+	return ret;
+}
diff -r 6257b2588438 root-tree.c
--- a/root-tree.c	Thu Sep 25 14:38:26 2008 +0800
+++ b/root-tree.c	Fri Sep 26 00:43:14 2008 +0800
@@ -210,7 +210,10 @@
 			goto err;
 		}
 
-		ret = btrfs_add_dead_root(dead_root, latest);
+		if (objectid == BTRFS_TREE_RELOC_OBJECTID)
+			ret = btrfs_add_dead_reloc_root(dead_root);
+		else
+			ret = btrfs_add_dead_root(dead_root, latest);
 		if (ret)
 			goto err;
 		goto again;
diff -r 6257b2588438 transaction.c
--- a/transaction.c	Thu Sep 25 14:38:26 2008 +0800
+++ b/transaction.c	Fri Sep 26 00:43:14 2008 +0800
@@ -477,6 +477,7 @@
 			dirty = root->dirty_root;
 
 			btrfs_free_log(trans, root);
+			btrfs_free_reloc_root(root);
 
 			if (root->commit_root == root->node) {
 				WARN_ON(root->node->start !=
@@ -855,6 +856,11 @@
 	 * with the tree-log code.
 	 */
 	mutex_lock(&root->fs_info->tree_log_mutex);
+	/*
+	 * keep tree reloc code from adding new reloc trees
+	 */
+	mutex_lock(&root->fs_info->tree_reloc_mutex);
+
 
 	ret = add_dirty_roots(trans, &root->fs_info->fs_roots_radix,
 			      &dirty_fs_roots);
@@ -864,6 +870,8 @@
 	 * safe to free the root of tree log roots
 	 */
 	btrfs_free_log_root_tree(trans, root->fs_info);
+
+	btrfs_free_reloc_mappings(root);
 
 	ret = btrfs_commit_tree_roots(trans, root);
 	BUG_ON(ret);
@@ -910,9 +918,12 @@
 	mutex_unlock(&root->fs_info->tree_log_mutex);
 
 	btrfs_finish_extent_commit(trans, root, pinned_copy);
+	kfree(pinned_copy);
+
+	btrfs_drop_dead_reloc_roots(root);
+	mutex_unlock(&root->fs_info->tree_reloc_mutex);
+
 	mutex_lock(&root->fs_info->trans_mutex);
-
-	kfree(pinned_copy);
 
 	cur_trans->commit_done = 1;
 	root->fs_info->last_trans_committed = cur_trans->transid;
diff -r 6257b2588438 volumes.c
--- a/volumes.c	Thu Sep 25 14:38:26 2008 +0800
+++ b/volumes.c	Fri Sep 26 00:43:14 2008 +0800
@@ -1268,7 +1268,7 @@
 	em_tree = &root->fs_info->mapping_tree.map_tree;
 
 	/* step one, relocate all the extents inside this chunk */
-	ret = btrfs_shrink_extent_tree(extent_root, chunk_offset);
+	ret = btrfs_relocate_block_group(extent_root, chunk_offset);
 	BUG_ON(ret);
 
 	trans = btrfs_start_transaction(root, 1);
@@ -1308,15 +1308,18 @@
 		BUG_ON(ret);
 	}
 
+	ret = btrfs_remove_block_group(trans, extent_root, chunk_offset);
+	BUG_ON(ret);
+
 	spin_lock(&em_tree->lock);
 	remove_extent_mapping(em_tree, em);
+	spin_unlock(&em_tree->lock);
+
 	kfree(map);
 	em->bdev = NULL;
 
 	/* once for the tree */
 	free_extent_map(em);
-	spin_unlock(&em_tree->lock);
-
 	/* once for us */
 	free_extent_map(em);
 
