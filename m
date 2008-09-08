From: Zheng Yan <zheng.yan@oracle.com>
Subject: [PATCH 1/4] update space balancing code for the new backref format
Date: Tue, 09 Sep 2008 02:42:17 +0800
Message-ID: <48C57209.6090004@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	yanzheng@21cn.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This patch updates the space balancing code to utilize the new backref
format. By using the new format, we can walk up the reference chain and
find all references to a given extent quickly.

This patch improves the space balancing for data extents. To relocate
a data block group, there are two stages. Data are moved to the new
location in the first stage. In the second stage, the references are
updated to reflect the new location.

Regards
Yan Zheng

---
diff -r 325653e288b3 ctree.h
--- a/ctree.h	Tue Sep 09 02:15:47 2008 +0800
+++ b/ctree.h	Tue Sep 09 02:16:08 2008 +0800
@@ -1484,7 +1484,6 @@
 struct extent_buffer *btrfs_init_new_buffer(struct btrfs_trans_handle *trans,
 					    struct btrfs_root *root,
 					    u64 bytenr, u32 blocksize);
-int btrfs_shrink_extent_tree(struct btrfs_root *root, u64 new_size);
 int btrfs_insert_extent_backref(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root,
 				 struct btrfs_path *path,
@@ -1548,6 +1547,9 @@
 			   struct btrfs_root *root, u64 bytes_used,
 			   u64 type, u64 chunk_objectid, u64 chunk_offset,
 			   u64 size);
+int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
+			     struct btrfs_root *root, u64 group_start);
+int btrfs_relocate_block_group(struct btrfs_root *root, u64 group_start);
 /* ctree.c */
 int btrfs_previous_item(struct btrfs_root *root,
 			struct btrfs_path *path, u64 min_objectid,
@@ -1791,6 +1793,8 @@
 int btrfs_update_inode(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root,
 			      struct inode *inode);
+int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode);
+int btrfs_orphan_del(struct btrfs_trans_handle *trans, struct inode *inode);
 
 /* ioctl.c */
 long btrfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
diff -r 325653e288b3 extent-tree.c
--- a/extent-tree.c	Tue Sep 09 02:15:47 2008 +0800
+++ b/extent-tree.c	Tue Sep 09 02:16:08 2008 +0800
@@ -35,6 +35,18 @@
 
 #define BLOCK_GROUP_DIRTY EXTENT_DIRTY
 
+struct reference_path {
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
 static int finish_current_insert(struct btrfs_trans_handle *trans, struct
 				 btrfs_root *extent_root);
 static int del_pending_extents(struct btrfs_trans_handle *trans, struct
@@ -868,7 +880,7 @@
 	int ret;
 
 	key.objectid = bytenr;
-	key.offset = 0;
+	key.offset = (u64)-1;
 	key.type = BTRFS_EXTENT_ITEM_KEY;
 
 	path = btrfs_alloc_path();
@@ -877,7 +889,10 @@
 	if (ret < 0)
 		goto out;
 	BUG_ON(ret == 0);
-
+	if (ret < 0 || path->slots[0] == 0)
+		goto out;
+
+	path->slots[0]--;
 	leaf = path->nodes[0];
 	btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
 
@@ -914,7 +929,7 @@
 					  struct btrfs_extent_ref);
 		ref_generation = btrfs_ref_generation(leaf, ref_item);
 		/*
-		 * For (parent_gen > 0 && parent_gen > ref_gen):
+		 * For (parent_gen > 0 && parent_gen > ref_generation):
 		 *
 		 * we reach here through the oldest root, therefore
 		 * all other reference from same snapshot should have
@@ -924,8 +939,7 @@
 		    (parent_gen > 0 && parent_gen > ref_generation) ||
 		    (ref_objectid >= BTRFS_FIRST_FREE_OBJECTID &&
 		     ref_objectid != btrfs_ref_objectid(leaf, ref_item))) {
-			if (ref_count)
-				*ref_count = 2;
+			*ref_count = 2;
 			break;
 		}
 
@@ -1539,6 +1553,219 @@
 	return start;
 }
 
+static int noinline __next_reference_path(struct btrfs_trans_handle *trans,
+					  struct btrfs_root *extent_root,
+					  struct reference_path *ref_path,
+					  int first_time)
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
+		    found_key.type == BTRFS_EXTENT_REF_KEY)
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
+		    found_key.type != BTRFS_EXTENT_REF_KEY) {
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
+				     struct btrfs_extent_ref);
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
+		if (found_key.objectid == found_key.offset) {
+			ref_path->root_objectid = btrfs_ref_root(leaf, ref);
+			ref_path->root_generation =
+					btrfs_ref_generation(leaf, ref);
+			ret = 0;
+			goto out;
+		}
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
+					btrfs_ref_generation(leaf, ref);
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
+static int first_reference_path(struct btrfs_trans_handle *trans,
+				struct btrfs_root *extent_root,
+				struct reference_path *ref_path,
+				u64 extent_start)
+{
+	memset(ref_path, 0, sizeof(*ref_path));
+	ref_path->extent_start = extent_start;
+
+	return __next_reference_path(trans, extent_root, ref_path, 1);
+}
+
+static int next_reference_path(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *extent_root,
+			       struct reference_path *ref_path)
+{
+	return __next_reference_path(trans, extent_root, ref_path, 0);
+}
 
 int btrfs_update_pinned_extents(struct btrfs_root *root,
 				u64 bytenr, u64 num, int pin)
@@ -2972,37 +3199,43 @@
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
@@ -3011,9 +3244,11 @@
 			if (!PageUptodate(page)) {
 				unlock_page(page);
 				page_cache_release(page);
+				ret = -EIO;
 				goto out_unlock;
 			}
 		}
+
 		wait_on_page_writeback(page);
 
 		page_start = (u64)page->index << PAGE_CACHE_SHIFT;
@@ -3031,14 +3266,13 @@
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
@@ -3046,347 +3280,676 @@
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
-			ret = 0;
-			goto out;
-		}
-		ret = btrfs_search_root(root->fs_info->tree_root,
-					root_search_start, &root_search_start);
-		if (ret)
-			break;
-
-		root_location.objectid = root_search_start;
-		cur_root = btrfs_read_fs_root_no_name(root->fs_info,
-						      &root_location);
-		if (!cur_root) {
-			ret = 1;
-			break;
-		}
-	}
-out:
-	path->lowest_level = 0;
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
+	balance_dirty_pages_ratelimited_nr(inode->i_mapping, total_dirty);
+	return ret;
+}
+
+static int noinline relocate_data_extent(struct inode *reloc_inode,
+					 struct btrfs_key *extent_key)
+{
+	struct btrfs_root *root = BTRFS_I(reloc_inode)->root;
+	struct extent_map_tree *em_tree = &BTRFS_I(reloc_inode)->extent_tree;
+	struct extent_map *em;
+
+	em = alloc_extent_map(GFP_NOFS);
+	BUG_ON(!em || IS_ERR(em));
+
+	em->start = extent_key->objectid;
+	em->len = extent_key->offset;
+	em->block_start = em->start;
+	em->bdev = root->fs_info->fs_devices->latest_bdev;
+	set_bit(EXTENT_FLAG_PINNED, &em->flags);
+
+	/* setup extent map manually to cheat btrfs_readpage */
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
+		WARN_ON(1);
+		btrfs_drop_extent_cache(reloc_inode, em->start,
+					em->start + em->len - 1);
+	}
+	mutex_unlock(&BTRFS_I(reloc_inode)->extent_mutex);
+
+	return relocate_inode_pages(reloc_inode, extent_key->objectid,
+				    extent_key->offset);
+}
+
+struct disk_extent {
+	u64 disk_bytenr;
+	u64 disk_num_bytes;
+	u64 offset;
+	u64 num_bytes;
+};
+
+static int noinline get_new_locations(struct inode *reloc_inode,
+				      struct btrfs_key *extent_key,
+				      struct btrfs_path *path,
+				      struct disk_extent **extents,
+				      int *nr_extents)
+{
+	struct btrfs_root *root = BTRFS_I(reloc_inode)->root;
+	struct btrfs_file_extent_item *fi;
+	struct extent_buffer *leaf;
+	struct disk_extent *exts;
+	struct btrfs_key found_key;
+	u64 cur_pos = extent_key->objectid;
+	u32 nritems;
+	int nr = 0;
+	int max = 2;
+	int ret;
+
+	exts = kmalloc(sizeof(*exts) * max, GFP_NOFS);
+	if (!exts)
+		return -ENOMEM;
+
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
+			kfree(old);
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
+		if (cur_pos >= extent_key->objectid + extent_key->offset)
+			break;
+
+		path->slots[0]++;
+	}
+
+	WARN_ON(cur_pos > extent_key->objectid + extent_key->offset);
+	if (cur_pos < extent_key->objectid + extent_key->offset) {
+		ret = -ENOENT;
+		goto out;
+	}
+	ret = 0;
+out:
+	btrfs_release_path(root, path);
+	if (ret) {
+		kfree(exts);
+	} else {
+		*extents = exts;
+		*nr_extents = nr;
+	}
+	return ret;
+}
+
+static int noinline update_leaf_references(struct btrfs_root *root,
+					   struct btrfs_path *path,
+					   struct btrfs_key *extent_key,
+					   struct reference_path *ref_path,
+					   struct disk_extent *new_extents,
+					   int nr_extents)
+{
+	struct btrfs_trans_handle *trans;
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
+	trans = btrfs_join_transaction(root, 1);
+	BUG_ON(!trans);
+
+	first_pos = ref_path->owner_offset;
+	if (ref_path->owner_objectid != BTRFS_MULTIPLE_OBJECTIDS) {
+		key.objectid = ref_path->owner_objectid;
+		key.offset = ref_path->owner_offset;
+		key.type = BTRFS_EXTENT_DATA_KEY;
+	} else {
 		struct extent_buffer *eb;
-		int needs_lock = 0;
-
-		eb = read_tree_block(found_root, extent_key->objectid,
-				     extent_key->offset, 0);
+		u64 leaf_start = ref_path->nodes[0];
+		u64 leaf_size = btrfs_level_size(root, 0);
+
+		/*
+		 * All tree blocks in the reference path have been flushed
+		 * to disk and can't be reused until we commit the running
+		 * transaction. So reading the leaf block is safe.
+		 */
+		eb = read_tree_block(root, leaf_start, leaf_size, 0);
+		BUG_ON(!eb);
 		btrfs_tree_lock(eb);
-		level = btrfs_header_level(eb);
-
-		if (level == 0)
-			btrfs_item_key_to_cpu(eb, &found_key, 0);
-		else
-			btrfs_node_key_to_cpu(eb, &found_key, 0);
+
+		btrfs_item_key_to_cpu(eb, &key, 0);
 
 		btrfs_tree_unlock(eb);
 		free_extent_buffer(eb);
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
+
+			/*
+			 * Some code call btrfs_commit_transaction while
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
+						key.offset + num_bytes - 1);
+
+			ret = btrfs_inc_extent_ref(trans, root,
+						new_extents[0].disk_bytenr,
+						new_extents[0].disk_num_bytes,
+						leaf->start,
+						btrfs_header_owner(leaf),
+						btrfs_header_generation(leaf),
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
+
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
+						key.offset + extent_len - 1);
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
+	btrfs_end_transaction(trans, root);
+	return ret;
+}
+
+static int noinline relocate_tree_block(struct btrfs_root *root,
+					struct btrfs_path *path,
+					struct btrfs_key *first_key,
+					int level)
+{
+	struct btrfs_trans_handle *trans;
+	int needs_lock = 0;
+	int ret;
+
+	trans = btrfs_join_transaction(root, 1);
+	BUG_ON(!trans);
+
+	if (root == root->fs_info->extent_root ||
+	    root == root->fs_info->chunk_root ||
+	    root == root->fs_info->dev_root) {
+		needs_lock = 1;
+		mutex_lock(&root->fs_info->alloc_mutex);
+	}
+
+	path->lowest_level = level;
+	ret = btrfs_search_slot(trans, root, first_key, path, 0, 1);
+	BUG_ON(ret < 0);
+	path->lowest_level = 0;
+	btrfs_release_path(root, path);
+
+	if (root == root->fs_info->extent_root)
+		btrfs_extent_post_op(trans, root);
+	if (needs_lock)
+		mutex_unlock(&root->fs_info->alloc_mutex);
+
+	btrfs_end_transaction(trans, root);
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
+						struct reference_path *ref_path)
+{
+	struct btrfs_key root_key;
+
+	root_key.objectid = ref_path->root_objectid;
+	root_key.type = BTRFS_ROOT_ITEM_KEY;
+	if (ref_path->root_generation == 0)
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
+					struct inode *reloc_inode, int pass)
+{
+	struct btrfs_trans_handle *trans;
+	struct reference_path *ref_path = NULL;
+	struct btrfs_root *found_root;
+	struct disk_extent *new_extents = NULL;
+	int nr_extents = 0;
+	int loops;
+	int ret;
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
+			ret = first_reference_path(trans, extent_root, ref_path,
+						   extent_key->objectid);
+		} else {
+			ret = next_reference_path(trans, extent_root, ref_path);
+		}
+		if (ret < 0)
+			goto out;
+		if (ret > 0)
+			break;
+
+		if (ref_path->root_objectid == BTRFS_TREE_LOG_OBJECTID)
+			continue;
+		/*
+		 * reading tree blocks created in the running transaction
+		 * isn't safe, since they may be freed before flushed to
+		 * the disk.
+		 */
+		if (ref_path->root_generation > 0 &&
+		    ref_path->root_generation == trans->transid)
+			continue;
+
+		found_root = read_ref_root(extent_root->fs_info, ref_path);
+		BUG_ON(!found_root);
+
+		/* no need to process reference paths rooted at dead roots */
+		if (ref_path->root_generation > 0 &&
+		    ref_path->root_generation != found_root->root_key.offset)
+			continue;
+
+		if (found_root == BTRFS_I(reloc_inode)->root &&
+		    ref_path->owner_objectid == reloc_inode->i_ino) {
+			WARN_ON(1);
+			continue;
+		}
+
+		if (ref_path->owner_objectid >= BTRFS_FIRST_FREE_OBJECTID) {
+			/*
+			 * move data in pass 0, update extent pointers
+			 * in the rest passes
+			 */
+			if (pass == 0) {
+				ret = relocate_data_extent(reloc_inode,
+							   extent_key);
+				if (ret < 0)
+					goto out;
+				break;
+			}
+			if (!new_extents) {
+				ret = get_new_locations(reloc_inode,
+							extent_key, path,
+							&new_extents,
+							&nr_extents);
+				if (ret < 0)
+					goto out;
+			}
+			ret = update_leaf_references(found_root, path,
+						     extent_key, ref_path,
+						     new_extents, nr_extents);
+			if (ret < 0)
+				goto out;
+		} else {
+			int level;
+			struct extent_buffer *eb;
+			struct btrfs_key first_key;
+
+			eb = read_tree_block(found_root, extent_key->objectid,
+					     extent_key->offset, 0);
+			btrfs_tree_lock(eb);
+			level = btrfs_header_level(eb);
+			WARN_ON(ref_path->owner_objectid != level);
+
+			if (level == 0)
+				btrfs_item_key_to_cpu(eb, &first_key, 0);
+			else
+				btrfs_node_key_to_cpu(eb, &first_key, 0);
+
+			btrfs_tree_unlock(eb);
+			free_extent_buffer(eb);
+
+			/*
+			 * right here almost anything could happen to our key,
+			 * but that's ok.  The cow below will either relocate it
+			 * or someone else will have relocated it.  Either way,
+			 * it is in a different spot than it was before and
+			 * we're happy.
+			 */
+
+			ret = relocate_tree_block(found_root, path,
+						  &first_key, level);
+			if (ret < 0)
+				goto out;
+		}
+	}
+	ret = 0;
+out:
+	btrfs_end_transaction(trans, extent_root);
+	if (new_extents)
+		kfree(new_extents);
+	kfree(ref_path);
+	mutex_lock(&extent_root->fs_info->alloc_mutex);
 	return ret;
 }
 
@@ -3466,85 +4029,155 @@
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
+static struct inode noinline *create_orphan_inode(struct btrfs_fs_info *fs_info,
+						  u64 root_objectid, u64 size)
+{
+	struct inode *inode = NULL;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *root;
+	struct btrfs_key root_key;
+	u64 objectid = BTRFS_FIRST_FREE_OBJECTID;
+	int err = 0;
+
+	root_key.objectid = root_objectid;
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
+	err = __insert_orphan_inode(trans, root, objectid, size);
+	BUG_ON(err);
+
+	err = btrfs_insert_file_extent(trans, root, objectid, 0, 0, 0,
+				       size, 0);
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
-	struct btrfs_fs_info *info = root->fs_info;
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
-again:
-
-	shrink_block_group->ro = 1;
-
+	       (unsigned long long)block_group->key.objectid,
+	       (unsigned long long)block_group->flags);
+
+	path = btrfs_alloc_path();
+	BUG_ON(!path);
+
+	reloc_inode = create_orphan_inode(info, BTRFS_FS_TREE_OBJECTID,
+					  MAX_LFS_FILESIZE);
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
+again:
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
@@ -3560,107 +4193,79 @@
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
+		ret = relocate_one_extent(root, path, &key, reloc_inode, pass);
+		BUG_ON(ret < 0);
+
 		key.objectid = cur_byte;
-		btrfs_release_path(root, path);
-		ret = relocate_one_extent(root, path, &found_key);
-		__alloc_chunk_for_shrink(root, shrink_block_group, 0);
-	}
-
-	btrfs_release_path(root, path);
+		key.type = 0;
+		key.offset = 0;
+	}
+
+	btrfs_release_path(root, path);
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
+		printk("btrfs relocate found %llu extents in pass %d\n",
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
-	clear_extent_bits(&info->block_group_cache, key.objectid,
-			  key.objectid + key.offset - 1,
+	/* delete reloc_inode */
+	iput(reloc_inode);
+
+	/* unpin extents in this range */
+	trans = btrfs_start_transaction(info->tree_root, 1);
+	btrfs_commit_transaction(trans, info->tree_root);
+
+	mutex_lock(&root->fs_info->alloc_mutex);
+
+	block_group->cached = 1;
+	clear_extent_bits(&root->fs_info->free_space_cache,
+			  key.objectid, key.objectid + key.offset - 1,
 			  (unsigned int)-1, GFP_NOFS);
 
-
-	clear_extent_bits(&info->free_space_cache,
-			   key.objectid, key.objectid + key.offset - 1,
-			   (unsigned int)-1, GFP_NOFS);
-
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
-	clear_extent_bits(&info->free_space_cache,
-			   key.objectid, key.objectid + key.offset - 1,
-			   (unsigned int)-1, GFP_NOFS);
-out:
-	btrfs_free_path(path);
-	mutex_unlock(&root->fs_info->alloc_mutex);
+	spin_lock(&block_group->lock);
+	WARN_ON(block_group->pinned > 0);
+	WARN_ON(btrfs_block_group_used(&block_group->item) > 0);
+	spin_unlock(&block_group->lock);
+	ret = 0;
+out:
+	mutex_unlock(&root->fs_info->alloc_mutex);
+	btrfs_free_path(path);
 	return ret;
 }
 
@@ -3838,5 +4443,51 @@
 	BUG_ON(ret);
 	set_avail_alloc_bits(extent_root->fs_info, type);
 
-	return 0;
-}
+	ret = cache_block_group(extent_root, cache);
+	WARN_ON(ret);
+
+	return 0;
+}
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
+	clear_extent_bits(&root->fs_info->block_group_cache,
+			  key.objectid, key.objectid + key.offset - 1,
+			  (unsigned int)-1, GFP_NOFS);
+
+	clear_extent_bits(&root->fs_info->free_space_cache,
+			  key.objectid, key.objectid + key.offset - 1,
+			  (unsigned int)-1, GFP_NOFS);
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
diff -r 325653e288b3 extent_io.c
--- a/extent_io.c	Tue Sep 09 02:15:47 2008 +0800
+++ b/extent_io.c	Tue Sep 09 02:16:08 2008 +0800
@@ -292,7 +292,7 @@
 	struct extent_state *other;
 	struct rb_node *other_node;
 
-	if (state->state & EXTENT_IOBITS)
+	if (state->state & (EXTENT_IOBITS | EXTENT_BOUNDARY))
 		return 0;
 
 	other_node = rb_prev(&state->rb_node);
@@ -1070,7 +1070,8 @@
 
 	while(1) {
 		state = rb_entry(node, struct extent_state, rb_node);
-		if (found && state->start != cur_start) {
+		if (found && (state->start != cur_start ||
+			      (state->state & EXTENT_BOUNDARY))) {
 			goto out;
 		}
 		if (!(state->state & EXTENT_DELALLOC)) {
@@ -1078,7 +1079,7 @@
 				*end = state->end;
 			goto out;
 		}
-		if (!found) {
+		if (!found && !(state->state & EXTENT_BOUNDARY)) {
 			struct extent_state *prev_state;
 			struct rb_node *prev_node = node;
 			while(1) {
@@ -1088,7 +1089,11 @@
 				prev_state = rb_entry(prev_node,
 						      struct extent_state,
 						      rb_node);
-				if (!(prev_state->state & EXTENT_DELALLOC))
+				if ((prev_state->end + 1 != state->start) ||
+				    !(prev_state->state & EXTENT_DELALLOC))
+					break;
+				if ((cur_start - prev_state->start) * 2 >
+				     max_bytes)
 					break;
 				state = prev_state;
 				node = prev_node;
diff -r 325653e288b3 extent_io.h
--- a/extent_io.h	Tue Sep 09 02:15:47 2008 +0800
+++ b/extent_io.h	Tue Sep 09 02:16:08 2008 +0800
@@ -15,6 +15,7 @@
 #define EXTENT_BUFFER_FILLED (1 << 8)
 #define EXTENT_ORDERED (1 << 9)
 #define EXTENT_ORDERED_METADATA (1 << 10)
+#define EXTENT_BOUNDARY (1 << 11)
 #define EXTENT_IOBITS (EXTENT_LOCKED | EXTENT_WRITEBACK)
 
 /*
diff -r 325653e288b3 file.c
--- a/file.c	Tue Sep 09 02:15:47 2008 +0800
+++ b/file.c	Tue Sep 09 02:16:08 2008 +0800
@@ -371,6 +371,7 @@
 	u64 len = end - start + 1;
 	int ret;
 	int testend = 1;
+	unsigned long flags;
 
 	WARN_ON(end < start);
 	if (end == (u64)-1) {
@@ -389,6 +390,7 @@
 			spin_unlock(&em_tree->lock);
 			break;
 		}
+		flags = em->flags;
 		clear_bit(EXTENT_FLAG_PINNED, &em->flags);
 		remove_extent_mapping(em_tree, em);
 
@@ -398,7 +400,7 @@
 			split->len = start - em->start;
 			split->block_start = em->block_start;
 			split->bdev = em->bdev;
-			split->flags = em->flags;
+			split->flags = flags;
 			ret = add_extent_mapping(em_tree, split);
 			BUG_ON(ret);
 			free_extent_map(split);
@@ -412,7 +414,7 @@
 			split->start = start + len;
 			split->len = em->start + em->len - (start + len);
 			split->bdev = em->bdev;
-			split->flags = em->flags;
+			split->flags = flags;
 
 			split->block_start = em->block_start + diff;
 
diff -r 325653e288b3 inode.c
--- a/inode.c	Tue Sep 09 02:15:47 2008 +0800
+++ b/inode.c	Tue Sep 09 02:16:08 2008 +0800
@@ -1709,7 +1709,7 @@
 	btrfs_wait_ordered_range(inode, 0, (u64)-1);
 
 	btrfs_i_size_write(inode, 0);
-	trans = btrfs_start_transaction(root, 1);
+	trans = btrfs_join_transaction(root, 1);
 
 	btrfs_set_trans_block_group(trans, inode);
 	ret = btrfs_truncate_inode_items(trans, root, inode, inode->i_size, 0);
diff -r 325653e288b3 ordered-data.c
--- a/ordered-data.c	Tue Sep 09 02:15:47 2008 +0800
+++ b/ordered-data.c	Tue Sep 09 02:16:08 2008 +0800
@@ -309,7 +309,6 @@
 {
 	struct list_head splice;
 	struct list_head *cur;
-	struct list_head *tmp;
 	struct btrfs_ordered_extent *ordered;
 	struct inode *inode;
 
@@ -317,37 +316,35 @@
 
 	spin_lock(&root->fs_info->ordered_extent_lock);
 	list_splice_init(&root->fs_info->ordered_extents, &splice);
-	list_for_each_safe(cur, tmp, &splice) {
+	while (!list_empty(&splice)) {
 		cur = splice.next;
 		ordered = list_entry(cur, struct btrfs_ordered_extent,
 				     root_extent_list);
 		if (nocow_only &&
 		    !test_bit(BTRFS_ORDERED_NOCOW, &ordered->flags)) {
+			list_move(&ordered->root_extent_list,
+				  &root->fs_info->ordered_extents);
 			cond_resched_lock(&root->fs_info->ordered_extent_lock);
 			continue;
 		}
 
 		list_del_init(&ordered->root_extent_list);
 		atomic_inc(&ordered->refs);
-		inode = ordered->inode;
 
-		/*
-		 * the inode can't go away until all the pages are gone
-		 * and the pages won't go away while there is still
-		 * an ordered extent and the ordered extent won't go
-		 * away until it is off this list.  So, we can safely
-		 * increment i_count here and call iput later
-		 */
-		atomic_inc(&inode->i_count);
+		inode = igrab(ordered->inode);
+
 		spin_unlock(&root->fs_info->ordered_extent_lock);
 
-		btrfs_start_ordered_extent(inode, ordered, 1);
-		btrfs_put_ordered_extent(ordered);
-		iput(inode);
+		if (inode) {
+			btrfs_start_ordered_extent(inode, ordered, 1);
+			btrfs_put_ordered_extent(ordered);
+			iput(inode);
+		} else {
+			btrfs_put_ordered_extent(ordered);
+		}
 
 		spin_lock(&root->fs_info->ordered_extent_lock);
 	}
-	list_splice_init(&splice, &root->fs_info->ordered_extents);
 	spin_unlock(&root->fs_info->ordered_extent_lock);
 	return 0;
 }
diff -r 325653e288b3 transaction.c
--- a/transaction.c	Tue Sep 09 02:15:47 2008 +0800
+++ b/transaction.c	Tue Sep 09 02:16:08 2008 +0800
@@ -682,7 +682,7 @@
 	memcpy(new_root_item, &root->root_item, sizeof(*new_root_item));
 
 	key.objectid = objectid;
-	key.offset = 1;
+	key.offset = trans->transid;
 	btrfs_set_key_type(&key, BTRFS_ROOT_ITEM_KEY);
 
 	old = btrfs_lock_root_node(root);
diff -r 325653e288b3 volumes.c
--- a/volumes.c	Tue Sep 09 02:15:47 2008 +0800
+++ b/volumes.c	Tue Sep 09 02:16:08 2008 +0800
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
 
