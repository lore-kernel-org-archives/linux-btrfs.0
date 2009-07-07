From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] relocate file extents in in clusters
Date: Tue, 07 Jul 2009 17:40:18 +0800
Message-ID: <4A531802.5010604@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Relocate file extents in clusters instead of one by one,
so we can make better use of readahead.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/relocation.c 2/fs/btrfs/relocation.c
--- 1/fs/btrfs/relocation.c	2009-07-03 08:08:34.160847023 +0800
+++ 2/fs/btrfs/relocation.c	2009-07-07 17:23:16.007836927 +0800
@@ -121,6 +121,15 @@ struct inodevec {
 	int nr;
 };
 
+#define MAX_EXTENTS 128
+
+struct file_extent_cluster {
+	u64 start;
+	u64 end;
+	u64 boundary[MAX_EXTENTS];
+	unsigned int nr;
+};
+
 struct reloc_control {
 	/* block group to relocate */
 	struct btrfs_block_group_cache *block_group;
@@ -2526,51 +2535,94 @@ out:
 }
 
 static noinline_for_stack
-int relocate_inode_pages(struct inode *inode, u64 start, u64 len)
+int setup_extent_mapping(struct inode *inode, u64 start, u64 end,
+			 u64 block_start)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
+	struct extent_map *em;
+	int ret = 0;
+
+	em = alloc_extent_map(GFP_NOFS);
+	if (!em)
+		return -ENOMEM;
+
+	em->start = start;
+	em->len = end + 1 - start;
+	em->block_len = em->len;
+	em->block_start = block_start;
+	em->bdev = root->fs_info->fs_devices->latest_bdev;
+	set_bit(EXTENT_FLAG_PINNED, &em->flags);
+
+	lock_extent(&BTRFS_I(inode)->io_tree, start, end, GFP_NOFS);
+	while (1) {
+		spin_lock(&em_tree->lock);
+		ret = add_extent_mapping(em_tree, em);
+		spin_unlock(&em_tree->lock);
+		if (ret != -EEXIST) {
+			free_extent_map(em);
+			break;
+		}
+		btrfs_drop_extent_cache(inode, start, end, 0);
+	}
+	unlock_extent(&BTRFS_I(inode)->io_tree, start, end, GFP_NOFS);
+	return ret;
+}
+
+static int relocate_file_extent_cluster(struct inode *inode,
+					struct file_extent_cluster *cluster)
 {
 	u64 page_start;
 	u64 page_end;
-	unsigned long i;
-	unsigned long first_index;
+	u64 offset = BTRFS_I(inode)->index_cnt;
+	unsigned long index;
 	unsigned long last_index;
-	unsigned int total_read = 0;
-	unsigned int total_dirty = 0;
+	unsigned int dirty_page = 0;
 	struct page *page;
 	struct file_ra_state *ra;
-	struct btrfs_ordered_extent *ordered;
-	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
+	int nr = 0;
 	int ret = 0;
 
+	if (!cluster->nr)
+		return 0;
+
 	ra = kzalloc(sizeof(*ra), GFP_NOFS);
 	if (!ra)
 		return -ENOMEM;
 
+	index = (cluster->start - offset) >> PAGE_CACHE_SHIFT;
+	last_index = (cluster->end - offset) >> PAGE_CACHE_SHIFT;
+
 	mutex_lock(&inode->i_mutex);
-	first_index = start >> PAGE_CACHE_SHIFT;
-	last_index = (start + len - 1) >> PAGE_CACHE_SHIFT;
 
-	/* make sure the dirty trick played by the caller work */
-	ret = invalidate_inode_pages2_range(inode->i_mapping,
-					    first_index, last_index);
+	i_size_write(inode, cluster->end + 1 - offset);
+	ret = setup_extent_mapping(inode, cluster->start - offset,
+				   cluster->end - offset, cluster->start);
 	if (ret)
 		goto out_unlock;
 
 	file_ra_state_init(ra, inode->i_mapping);
 
-	for (i = first_index ; i <= last_index; i++) {
-		if (total_read % ra->ra_pages == 0) {
-			btrfs_force_ra(inode->i_mapping, ra, NULL, i,
-				min(last_index, ra->ra_pages + i - 1));
-		}
-		total_read++;
-again:
-		if (((u64)i << PAGE_CACHE_SHIFT) > i_size_read(inode))
-			BUG_ON(1);
-		page = grab_cache_page(inode->i_mapping, i);
+	WARN_ON(cluster->start != cluster->boundary[0]);
+	while (index <= last_index) {
+		page = find_lock_page(inode->i_mapping, index);
 		if (!page) {
-			ret = -ENOMEM;
-			goto out_unlock;
+			page_cache_sync_readahead(inode->i_mapping,
+						  ra, NULL, index,
+						  last_index + 1 - index);
+			page = grab_cache_page(inode->i_mapping, index);
+			if (!page) {
+				ret = -ENOMEM;
+				goto out_unlock;
+			}
 		}
+
+		if (PageReadahead(page)) {
+			page_cache_async_readahead(inode->i_mapping,
+						   ra, NULL, page, index,
+						   last_index + 1 - index);
+		}
+
 		if (!PageUptodate(page)) {
 			btrfs_readpage(NULL, page);
 			lock_page(page);
@@ -2581,75 +2633,79 @@ again:
 				goto out_unlock;
 			}
 		}
-		wait_on_page_writeback(page);
 
 		page_start = (u64)page->index << PAGE_CACHE_SHIFT;
 		page_end = page_start + PAGE_CACHE_SIZE - 1;
-		lock_extent(io_tree, page_start, page_end, GFP_NOFS);
 
-		ordered = btrfs_lookup_ordered_extent(inode, page_start);
-		if (ordered) {
-			unlock_extent(io_tree, page_start, page_end, GFP_NOFS);
-			unlock_page(page);
-			page_cache_release(page);
-			btrfs_start_ordered_extent(inode, ordered, 1);
-			btrfs_put_ordered_extent(ordered);
-			goto again;
-		}
+		lock_extent(&BTRFS_I(inode)->io_tree,
+			    page_start, page_end, GFP_NOFS);
+
 		set_page_extent_mapped(page);
 
-		if (i == first_index)
-			set_extent_bits(io_tree, page_start, page_end,
+		if (nr < cluster->nr &&
+		    page_start + offset == cluster->boundary[nr]) {
+			set_extent_bits(&BTRFS_I(inode)->io_tree,
+					page_start, page_end,
 					EXTENT_BOUNDARY, GFP_NOFS);
+			nr++;
+		}
 		btrfs_set_extent_delalloc(inode, page_start, page_end);
 
 		set_page_dirty(page);
-		total_dirty++;
+		dirty_page++;
 
-		unlock_extent(io_tree, page_start, page_end, GFP_NOFS);
+		unlock_extent(&BTRFS_I(inode)->io_tree,
+			      page_start, page_end, GFP_NOFS);
 		unlock_page(page);
 		page_cache_release(page);
+
+		index++;
+		if (nr < cluster->nr &&
+		    page_end + 1 + offset == cluster->boundary[nr]) {
+			balance_dirty_pages_ratelimited_nr(inode->i_mapping,
+							   dirty_page);
+			dirty_page = 0;
+		}
 	}
+	if (dirty_page) {
+		balance_dirty_pages_ratelimited_nr(inode->i_mapping,
+						   dirty_page);
+	}
+	WARN_ON(nr != cluster->nr);
 out_unlock:
 	mutex_unlock(&inode->i_mutex);
 	kfree(ra);
-	balance_dirty_pages_ratelimited_nr(inode->i_mapping, total_dirty);
 	return ret;
 }
 
 static noinline_for_stack
-int relocate_data_extent(struct inode *inode, struct btrfs_key *extent_key)
+int relocate_data_extent(struct inode *inode, struct btrfs_key *extent_key,
+			 struct file_extent_cluster *cluster)
 {
-	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
-	struct extent_map *em;
-	u64 start = extent_key->objectid - BTRFS_I(inode)->index_cnt;
-	u64 end = start + extent_key->offset - 1;
-
-	em = alloc_extent_map(GFP_NOFS);
-	em->start = start;
-	em->len = extent_key->offset;
-	em->block_len = extent_key->offset;
-	em->block_start = extent_key->objectid;
-	em->bdev = root->fs_info->fs_devices->latest_bdev;
-	set_bit(EXTENT_FLAG_PINNED, &em->flags);
+	int ret;
 
-	/* setup extent map to cheat btrfs_readpage */
-	lock_extent(&BTRFS_I(inode)->io_tree, start, end, GFP_NOFS);
-	while (1) {
-		int ret;
-		spin_lock(&em_tree->lock);
-		ret = add_extent_mapping(em_tree, em);
-		spin_unlock(&em_tree->lock);
-		if (ret != -EEXIST) {
-			free_extent_map(em);
-			break;
-		}
-		btrfs_drop_extent_cache(inode, start, end, 0);
+	if (cluster->nr > 0 && extent_key->objectid != cluster->end + 1) {
+		ret = relocate_file_extent_cluster(inode, cluster);
+		if (ret)
+			return ret;
+		cluster->nr = 0;
 	}
-	unlock_extent(&BTRFS_I(inode)->io_tree, start, end, GFP_NOFS);
 
-	return relocate_inode_pages(inode, start, extent_key->offset);
+	if (!cluster->nr)
+		cluster->start = extent_key->objectid;
+	else
+		BUG_ON(cluster->nr >= MAX_EXTENTS);
+	cluster->end = extent_key->objectid + extent_key->offset - 1;
+	cluster->boundary[cluster->nr] = extent_key->objectid;
+	cluster->nr++;
+
+	if (cluster->nr >= MAX_EXTENTS) {
+		ret = relocate_file_extent_cluster(inode, cluster);
+		if (ret)
+			return ret;
+		cluster->nr = 0;
+	}
+	return 0;
 }
 
 #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
@@ -3199,6 +3255,7 @@ static noinline_for_stack int relocate_b
 {
 	struct rb_root blocks = RB_ROOT;
 	struct btrfs_key key;
+	struct file_extent_cluster *cluster;
 	struct btrfs_trans_handle *trans = NULL;
 	struct btrfs_path *path;
 	struct btrfs_extent_item *ei;
@@ -3208,6 +3265,10 @@ static noinline_for_stack int relocate_b
 	int ret;
 	int err = 0;
 
+	cluster = kzalloc(sizeof(*cluster), GFP_NOFS);
+	if (!cluster)
+		return -ENOMEM;
+
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
@@ -3298,14 +3359,15 @@ static noinline_for_stack int relocate_b
 		}
 
 		nr = trans->blocks_used;
-		btrfs_end_transaction_throttle(trans, rc->extent_root);
+		btrfs_end_transaction(trans, rc->extent_root);
 		trans = NULL;
 		btrfs_btree_balance_dirty(rc->extent_root, nr);
 
 		if (rc->stage == MOVE_DATA_EXTENTS &&
 		    (flags & BTRFS_EXTENT_FLAG_DATA)) {
 			rc->found_file_extent = 1;
-			ret = relocate_data_extent(rc->data_inode, &key);
+			ret = relocate_data_extent(rc->data_inode,
+						   &key, cluster);
 			if (ret < 0) {
 				err = ret;
 				break;
@@ -3320,6 +3382,14 @@ static noinline_for_stack int relocate_b
 		btrfs_btree_balance_dirty(rc->extent_root, nr);
 	}
 
+	if (!err) {
+		ret = relocate_file_extent_cluster(rc->data_inode, cluster);
+		if (ret < 0)
+			err = ret;
+	}
+
+	kfree(cluster);
+
 	rc->create_reloc_root = 0;
 	smp_mb();
 
@@ -3340,8 +3410,7 @@ static noinline_for_stack int relocate_b
 }
 
 static int __insert_orphan_inode(struct btrfs_trans_handle *trans,
-				 struct btrfs_root *root,
-				 u64 objectid, u64 size)
+				 struct btrfs_root *root, u64 objectid)
 {
 	struct btrfs_path *path;
 	struct btrfs_inode_item *item;
@@ -3360,7 +3429,7 @@ static int __insert_orphan_inode(struct 
 	item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_inode_item);
 	memset_extent_buffer(leaf, 0, (unsigned long)item, sizeof(*item));
 	btrfs_set_inode_generation(leaf, item, 1);
-	btrfs_set_inode_size(leaf, item, size);
+	btrfs_set_inode_size(leaf, item, 0);
 	btrfs_set_inode_mode(leaf, item, S_IFREG | 0600);
 	btrfs_set_inode_flags(leaf, item, BTRFS_INODE_NOCOMPRESS);
 	btrfs_mark_buffer_dirty(leaf);
@@ -3396,12 +3465,7 @@ static struct inode *create_reloc_inode(
 	if (err)
 		goto out;
 
-	err = __insert_orphan_inode(trans, root, objectid, group->key.offset);
-	BUG_ON(err);
-
-	err = btrfs_insert_file_extent(trans, root, objectid, 0, 0, 0,
-				       group->key.offset, 0, group->key.offset,
-				       0, 0, 0);
+	err = __insert_orphan_inode(trans, root, objectid);
 	BUG_ON(err);
 
 	key.objectid = objectid;
@@ -3506,10 +3570,10 @@ int btrfs_relocate_block_group(struct bt
 		}
 	}
 
-	filemap_fdatawrite_range(fs_info->btree_inode->i_mapping,
-				 rc->block_group->key.objectid,
-				 rc->block_group->key.objectid +
-				 rc->block_group->key.offset - 1);
+	filemap_write_and_wait_range(fs_info->btree_inode->i_mapping,
+				     rc->block_group->key.objectid,
+				     rc->block_group->key.objectid +
+				     rc->block_group->key.offset - 1);
 
 	WARN_ON(rc->block_group->pinned > 0);
 	WARN_ON(rc->block_group->reserved > 0);
