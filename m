From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 2/3] Btrfs: write out free space cache
Date: Wed, 15 Sep 2010 15:08:53 -0400
Message-ID: <1284577734-3161-3-git-send-email-josef@redhat.com>
References: <1284577734-3161-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1284577734-3161-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

This is a simple bit, just dump the free space cache out to our preallocated
inode when we're writing out dirty block groups.  There are a bunch of changes
in inode.c in order to account for special cases.  Mostly when we're doing the
writeout we're holding trans_mutex, so we need to use the nolock transacation
functions.  Also we can't do asynchronous completions since the async thread
could be blocked on already completed IO waiting for the transaction lock.  This
has been tested with xfstests and btrfs filesystem balance, as well as my ENOSPC
tests.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.h            |    1 +
 fs/btrfs/disk-io.c          |   17 +++-
 fs/btrfs/extent-tree.c      |   48 ++++++++
 fs/btrfs/free-space-cache.c |  275 +++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/free-space-cache.h |    5 +
 fs/btrfs/inode.c            |   60 ++++++++--
 6 files changed, 393 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 610710c..02a17af 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -982,6 +982,7 @@ struct btrfs_fs_info {
 	struct btrfs_workers endio_meta_workers;
 	struct btrfs_workers endio_meta_write_workers;
 	struct btrfs_workers endio_write_workers;
+	struct btrfs_workers endio_freespace_worker;
 	struct btrfs_workers submit_workers;
 	/*
 	 * fixup workers take dirty pages that didn't properly go through
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 163ee07..20d4056 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -481,9 +481,12 @@ static void end_workqueue_bio(struct bio *bio, int err)
 	end_io_wq->work.flags = 0;
 
 	if (bio->bi_rw & (1 << BIO_RW)) {
-		if (end_io_wq->metadata)
+		if (end_io_wq->metadata == 1)
 			btrfs_queue_worker(&fs_info->endio_meta_write_workers,
 					   &end_io_wq->work);
+		else if (end_io_wq->metadata == 2)
+			btrfs_queue_worker(&fs_info->endio_freespace_worker,
+					   &end_io_wq->work);
 		else
 			btrfs_queue_worker(&fs_info->endio_write_workers,
 					   &end_io_wq->work);
@@ -497,6 +500,13 @@ static void end_workqueue_bio(struct bio *bio, int err)
 	}
 }
 
+/*
+ * For the metadata arg you want
+ *
+ * 0 - if data
+ * 1 - if normal metadta
+ * 2 - if writing to the free space cache area
+ */
 int btrfs_bio_wq_end_io(struct btrfs_fs_info *info, struct bio *bio,
 			int metadata)
 {
@@ -1774,6 +1784,8 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	btrfs_init_workers(&fs_info->endio_write_workers, "endio-write",
 			   fs_info->thread_pool_size,
 			   &fs_info->generic_worker);
+	btrfs_init_workers(&fs_info->endio_freespace_worker, "freespace-write",
+			   1, &fs_info->generic_worker);
 
 	/*
 	 * endios are largely parallel and should have a very
@@ -1794,6 +1806,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	btrfs_start_workers(&fs_info->endio_meta_workers, 1);
 	btrfs_start_workers(&fs_info->endio_meta_write_workers, 1);
 	btrfs_start_workers(&fs_info->endio_write_workers, 1);
+	btrfs_start_workers(&fs_info->endio_freespace_worker, 1);
 
 	fs_info->bdi.ra_pages *= btrfs_super_num_devices(disk_super);
 	fs_info->bdi.ra_pages = max(fs_info->bdi.ra_pages,
@@ -2035,6 +2048,7 @@ fail_sb_buffer:
 	btrfs_stop_workers(&fs_info->endio_meta_workers);
 	btrfs_stop_workers(&fs_info->endio_meta_write_workers);
 	btrfs_stop_workers(&fs_info->endio_write_workers);
+	btrfs_stop_workers(&fs_info->endio_freespace_worker);
 	btrfs_stop_workers(&fs_info->submit_workers);
 fail_iput:
 	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
@@ -2468,6 +2482,7 @@ int close_ctree(struct btrfs_root *root)
 	btrfs_stop_workers(&fs_info->endio_meta_workers);
 	btrfs_stop_workers(&fs_info->endio_meta_write_workers);
 	btrfs_stop_workers(&fs_info->endio_write_workers);
+	btrfs_stop_workers(&fs_info->endio_freespace_worker);
 	btrfs_stop_workers(&fs_info->submit_workers);
 
 	btrfs_close_devices(fs_info->fs_devices);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b8151ad..6994423 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2847,6 +2847,8 @@ again:
 			continue;
 		}
 
+		if (cache->disk_cache_state == BTRFS_DC_SETUP)
+			cache->disk_cache_state = BTRFS_DC_NEED_WRITE;
 		cache->dirty = 0;
 		last = cache->key.objectid + cache->key.offset;
 
@@ -2855,6 +2857,52 @@ again:
 		btrfs_put_block_group(cache);
 	}
 
+	while (1) {
+		/*
+		 * I don't think this is needed since we're just marking our
+		 * preallocated extent as written, but just in case it can't
+		 * hurt.
+		 */
+		if (last == 0) {
+			err = btrfs_run_delayed_refs(trans, root,
+						     (unsigned long)-1);
+			BUG_ON(err);
+		}
+
+		cache = btrfs_lookup_first_block_group(root->fs_info, last);
+		while (cache) {
+			/*
+			 * Really this shouldn't happen, but it could if we
+			 * couldn't write the entire preallocated extent and
+			 * splitting the extent resulted in a new block.
+			 */
+			if (cache->dirty) {
+				btrfs_put_block_group(cache);
+				goto again;
+			}
+			if (cache->disk_cache_state == BTRFS_DC_NEED_WRITE)
+				break;
+			cache = next_block_group(root, cache);
+		}
+		if (!cache) {
+			if (last == 0)
+				break;
+			last = 0;
+			continue;
+		}
+
+		btrfs_write_out_cache(root, trans, cache, path);
+
+		/*
+		 * If we didn't have an error then the cache state is still
+		 * NEED_WRITE, so we can set it to WRITTEN.
+		 */
+		if (cache->disk_cache_state == BTRFS_DC_NEED_WRITE)
+			cache->disk_cache_state = BTRFS_DC_WRITTEN;
+		last = cache->key.objectid + cache->key.offset;
+		btrfs_put_block_group(cache);
+	}
+
 	btrfs_free_path(path);
 	return 0;
 }
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 05efcc7..3b02d40 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -28,6 +28,11 @@
 #define BITS_PER_BITMAP		(PAGE_CACHE_SIZE * 8)
 #define MAX_CACHE_BYTES_PER_GIG	(32 * 1024)
 
+static void recalculate_thresholds(struct btrfs_block_group_cache
+				   *block_group);
+static int link_free_space(struct btrfs_block_group_cache *block_group,
+			   struct btrfs_free_space *info);
+
 struct inode *lookup_free_space_inode(struct btrfs_root *root,
 				      struct btrfs_block_group_cache
 				      *block_group, struct btrfs_path *path)
@@ -182,6 +187,276 @@ int btrfs_truncate_free_space_cache(struct btrfs_root *root,
 	return btrfs_update_inode(trans, root, inode);
 }
 
+int btrfs_write_out_cache(struct btrfs_root *root,
+			  struct btrfs_trans_handle *trans,
+			  struct btrfs_block_group_cache *block_group,
+			  struct btrfs_path *path)
+{
+	struct btrfs_free_space_header *header;
+	struct extent_buffer *leaf;
+	struct inode *inode;
+	struct rb_node *node;
+	struct list_head *pos, *n;
+	struct list_head bitmap_list;
+	struct btrfs_key key;
+	u64 bytes = 0;
+	u32 *crc, *checksums;
+	pgoff_t index = 0, last_index = 0;
+	unsigned long first_page_offset;
+	int num_checksums;
+	int entries = 0;
+	int bitmaps = 0;
+	int ret = 0;
+
+	root = root->fs_info->tree_root;
+
+	INIT_LIST_HEAD(&bitmap_list);
+
+	spin_lock(&block_group->lock);
+	if (block_group->disk_cache_state < BTRFS_DC_SETUP) {
+		spin_unlock(&block_group->lock);
+		return 0;
+	}
+	spin_unlock(&block_group->lock);
+
+	inode = lookup_free_space_inode(root, block_group, path);
+	if (IS_ERR(inode))
+		return 0;
+
+	if (!i_size_read(inode)) {
+		iput(inode);
+		return 0;
+	}
+
+	last_index = (i_size_read(inode) - 1) >> PAGE_CACHE_SHIFT;
+	filemap_write_and_wait(inode->i_mapping);
+	btrfs_wait_ordered_range(inode, inode->i_size &
+				 ~(root->sectorsize - 1), (u64)-1);
+
+	/* We need a checksum per page. */
+	num_checksums = i_size_read(inode) / PAGE_CACHE_SIZE;
+	crc = checksums  = kzalloc(sizeof(u32) * num_checksums, GFP_NOFS);
+	if (!crc) {
+		iput(inode);
+		return 0;
+	}
+
+	/* Since the first page has all of our checksums and our generation we
+	 * need to calculate the offset into the page that we can start writing
+	 * our entries.
+	 */
+	first_page_offset = (sizeof(u32) * num_checksums) + sizeof(u64);
+
+	node = rb_first(&block_group->free_space_offset);
+	if (!node)
+		goto out_free;
+
+	do {
+		struct btrfs_free_space_entry *entry;
+		void *addr;
+		struct page *page;
+		unsigned long offset = 0;
+		unsigned long start_offset = 0;
+
+		if (index == 0) {
+			start_offset = first_page_offset;
+			offset = start_offset;
+		}
+
+		page = grab_cache_page(inode->i_mapping, index);
+		if (!page)
+			goto out_free;
+
+		addr = kmap(page);
+		entry = addr + start_offset;
+
+		memset(addr, 0, PAGE_CACHE_SIZE);
+		while (1) {
+			struct btrfs_free_space *e;
+
+			e = rb_entry(node, struct btrfs_free_space, offset_index);
+			entries++;
+
+			entry->offset = cpu_to_le64(e->offset);
+			entry->bytes = cpu_to_le64(e->bytes);
+			if (e->bitmap) {
+				entry->type = BTRFS_FREE_SPACE_BITMAP;
+				list_add_tail(&e->list, &bitmap_list);
+				bitmaps++;
+			} else {
+				entry->type = BTRFS_FREE_SPACE_EXTENT;
+			}
+			node = rb_next(node);
+			if (!node)
+				break;
+			offset += sizeof(struct btrfs_free_space_entry);
+			if (offset + sizeof(struct btrfs_free_space_entry) >=
+			    PAGE_CACHE_SIZE)
+				break;
+			entry++;
+		}
+		*crc = ~(u32)0;
+		*crc = btrfs_csum_data(root, addr + start_offset, *crc,
+				       PAGE_CACHE_SIZE - start_offset);
+		kunmap(addr);
+
+		btrfs_csum_final(*crc, (char *)crc);
+		crc++;
+
+		bytes += PAGE_CACHE_SIZE;
+
+		ClearPageChecked(page);
+		set_page_extent_mapped(page);
+		SetPageUptodate(page);
+		set_page_dirty(page);
+		unlock_page(page);
+		page_cache_release(page);
+		index++;
+	} while (node);
+
+	list_for_each_safe(pos, n, &bitmap_list) {
+		struct page *page;
+		void *addr;
+		struct btrfs_free_space *entry =
+			list_entry(pos, struct btrfs_free_space, list);
+
+		page = grab_cache_page(inode->i_mapping, index);
+		if (!page)
+			goto out_free;
+
+		addr = kmap(page);
+		memcpy(addr, entry->bitmap, PAGE_CACHE_SIZE);
+		*crc = ~(u32)0;
+		*crc = btrfs_csum_data(root, addr, *crc, PAGE_CACHE_SIZE);
+		kunmap(addr);
+		btrfs_csum_final(*crc, (char *)crc);
+		crc++;
+		bytes += PAGE_CACHE_SIZE;
+
+		ClearPageChecked(page);
+		set_page_extent_mapped(page);
+		SetPageUptodate(page);
+		set_page_dirty(page);
+		unlock_page(page);
+		page_cache_release(page);
+		list_del_init(&entry->list);
+		index++;
+	}
+
+	while (index <= last_index) {
+		struct page *page;
+		void *addr;
+
+		page = grab_cache_page(inode->i_mapping, index);
+		if (!page) {
+			/* Since this is just an optimization so we don't split
+			 * the preallocated extent, don't freak-out, just
+			 * break.
+			 */
+			break;
+		}
+		addr = kmap(page);
+		memset(addr, 0, PAGE_CACHE_SIZE);
+		kunmap(addr);
+		ClearPageChecked(page);
+		set_page_extent_mapped(page);
+		SetPageUptodate(page);
+		set_page_dirty(page);
+		unlock_page(page);
+		page_cache_release(page);
+		bytes += PAGE_CACHE_SIZE;
+		index++;
+	}
+
+	btrfs_set_extent_delalloc(inode, 0, bytes - 1, NULL);
+
+	{
+		struct page *page;
+		void *addr;
+		u64 *gen;
+
+		page = grab_cache_page(inode->i_mapping, 0);
+		if (!page)
+			goto out_free;
+
+		if (!PageUptodate(page)) {
+			btrfs_readpage(NULL, page);
+			lock_page(page);
+			if (!PageUptodate(page)) {
+				unlock_page(page);
+				page_cache_release(page);
+				goto out_free;
+			}
+		}
+
+		addr = kmap(page);
+		memcpy(addr, checksums, sizeof(u32) * num_checksums);
+		gen = addr + (sizeof(u32) * num_checksums);
+		*gen = trans->transid;
+		kunmap(addr);
+		ClearPageChecked(page);
+		set_page_extent_mapped(page);
+		SetPageUptodate(page);
+		set_page_dirty(page);
+		unlock_page(page);
+		page_cache_release(page);
+	}
+	BTRFS_I(inode)->generation = trans->transid;
+	filemap_write_and_wait(inode->i_mapping);
+
+	key.objectid = BTRFS_FREE_SPACE_OBJECTID;
+	key.offset = block_group->key.objectid;
+	key.type = 0;
+
+	ret = btrfs_search_slot(trans, root, &key, path, 1, 1);
+	if (ret < 0) {
+		ret = 0;
+		clear_extent_bit(&BTRFS_I(inode)->io_tree, 0, bytes - 1,
+				 EXTENT_DIRTY | EXTENT_DELALLOC |
+				 EXTENT_DO_ACCOUNTING, 0, 0, NULL, GFP_NOFS);
+		goto out_free;
+	}
+	leaf = path->nodes[0];
+	if (ret > 0) {
+		struct btrfs_key found_key;
+		BUG_ON(!path->slots[0]);
+		path->slots[0]--;
+		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
+		if (found_key.objectid != BTRFS_FREE_SPACE_OBJECTID ||
+		    found_key.offset != block_group->key.objectid) {
+			ret = 0;
+			clear_extent_bit(&BTRFS_I(inode)->io_tree, 0, bytes - 1,
+					 EXTENT_DIRTY | EXTENT_DELALLOC |
+					 EXTENT_DO_ACCOUNTING, 0, 0, NULL,
+					 GFP_NOFS);
+			btrfs_release_path(root, path);
+			goto out_free;
+		}
+	}
+	header = btrfs_item_ptr(leaf, path->slots[0],
+				struct btrfs_free_space_header);
+	btrfs_set_free_space_entries(leaf, header, entries);
+	btrfs_set_free_space_bitmaps(leaf, header, bitmaps);
+	btrfs_set_free_space_generation(leaf, header, trans->transid);
+	btrfs_mark_buffer_dirty(leaf);
+	btrfs_release_path(root, path);
+
+	ret = 1;
+
+out_free:
+	if (ret == 0) {
+		invalidate_inode_pages2_range(inode->i_mapping, 0, index);
+		spin_lock(&block_group->lock);
+		block_group->disk_cache_state = BTRFS_DC_ERROR;
+		spin_unlock(&block_group->lock);
+		BTRFS_I(inode)->generation = 0;
+	}
+	kfree(checksums);
+	btrfs_update_inode(trans, root, inode);
+	iput(inode);
+	return ret;
+}
+
 static inline unsigned long offset_to_bit(u64 bitmap_start, u64 sectorsize,
 					  u64 offset)
 {
diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index 45be29e..189f740 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -34,10 +34,15 @@ int create_free_space_inode(struct btrfs_root *root,
 			    struct btrfs_trans_handle *trans,
 			    struct btrfs_block_group_cache *block_group,
 			    struct btrfs_path *path);
+
 int btrfs_truncate_free_space_cache(struct btrfs_root *root,
 				    struct btrfs_trans_handle *trans,
 				    struct btrfs_path *path,
 				    struct inode *inode);
+int btrfs_write_out_cache(struct btrfs_root *root,
+			  struct btrfs_trans_handle *trans,
+			  struct btrfs_block_group_cache *block_group,
+			  struct btrfs_path *path);
 int btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
 			 u64 bytenr, u64 size);
 int btrfs_remove_free_space(struct btrfs_block_group_cache *block_group,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 16b708a..1d17518 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -764,6 +764,7 @@ static noinline int cow_file_range(struct inode *inode,
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
 	int ret = 0;
 
+	BUG_ON(root == root->fs_info->tree_root);
 	trans = btrfs_join_transaction(root, 1);
 	BUG_ON(!trans);
 	btrfs_set_trans_block_group(trans, inode);
@@ -1035,10 +1036,16 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 	int type;
 	int nocow;
 	int check_prev = 1;
+	bool nolock = false;
 
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
-	trans = btrfs_join_transaction(root, 1);
+	if (root == root->fs_info->tree_root) {
+		nolock = true;
+		trans = btrfs_join_transaction_nolock(root, 1);
+	} else {
+		trans = btrfs_join_transaction(root, 1);
+	}
 	BUG_ON(!trans);
 
 	cow_start = (u64)-1;
@@ -1211,8 +1218,13 @@ out_check:
 		BUG_ON(ret);
 	}
 
-	ret = btrfs_end_transaction(trans, root);
-	BUG_ON(ret);
+	if (nolock) {
+		ret = btrfs_end_transaction_nolock(trans, root);
+		BUG_ON(ret);
+	} else {
+		ret = btrfs_end_transaction(trans, root);
+		BUG_ON(ret);
+	}
 	btrfs_free_path(path);
 	return 0;
 }
@@ -1289,6 +1301,8 @@ static int btrfs_set_bit_hook(struct inode *inode,
 	if (!(state->state & EXTENT_DELALLOC) && (*bits & EXTENT_DELALLOC)) {
 		struct btrfs_root *root = BTRFS_I(inode)->root;
 		u64 len = state->end + 1 - state->start;
+		int do_list = (root->root_key.objectid !=
+			       BTRFS_ROOT_TREE_OBJECTID);
 
 		if (*bits & EXTENT_FIRST_DELALLOC)
 			*bits &= ~EXTENT_FIRST_DELALLOC;
@@ -1298,7 +1312,7 @@ static int btrfs_set_bit_hook(struct inode *inode,
 		spin_lock(&root->fs_info->delalloc_lock);
 		BTRFS_I(inode)->delalloc_bytes += len;
 		root->fs_info->delalloc_bytes += len;
-		if (list_empty(&BTRFS_I(inode)->delalloc_inodes)) {
+		if (do_list && list_empty(&BTRFS_I(inode)->delalloc_inodes)) {
 			list_add_tail(&BTRFS_I(inode)->delalloc_inodes,
 				      &root->fs_info->delalloc_inodes);
 		}
@@ -1321,6 +1335,8 @@ static int btrfs_clear_bit_hook(struct inode *inode,
 	if ((state->state & EXTENT_DELALLOC) && (*bits & EXTENT_DELALLOC)) {
 		struct btrfs_root *root = BTRFS_I(inode)->root;
 		u64 len = state->end + 1 - state->start;
+		int do_list = (root->root_key.objectid !=
+			       BTRFS_ROOT_TREE_OBJECTID);
 
 		if (*bits & EXTENT_FIRST_DELALLOC)
 			*bits &= ~EXTENT_FIRST_DELALLOC;
@@ -1330,14 +1346,15 @@ static int btrfs_clear_bit_hook(struct inode *inode,
 		if (*bits & EXTENT_DO_ACCOUNTING)
 			btrfs_delalloc_release_metadata(inode, len);
 
-		if (root->root_key.objectid != BTRFS_DATA_RELOC_TREE_OBJECTID)
+		if (root->root_key.objectid != BTRFS_DATA_RELOC_TREE_OBJECTID
+		    && do_list)
 			btrfs_free_reserved_data_space(inode, len);
 
 		spin_lock(&root->fs_info->delalloc_lock);
 		root->fs_info->delalloc_bytes -= len;
 		BTRFS_I(inode)->delalloc_bytes -= len;
 
-		if (BTRFS_I(inode)->delalloc_bytes == 0 &&
+		if (do_list && BTRFS_I(inode)->delalloc_bytes == 0 &&
 		    !list_empty(&BTRFS_I(inode)->delalloc_inodes)) {
 			list_del_init(&BTRFS_I(inode)->delalloc_inodes);
 		}
@@ -1426,7 +1443,10 @@ static int btrfs_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 
 	skip_sum = BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM;
 
-	ret = btrfs_bio_wq_end_io(root->fs_info, bio, 0);
+	if (root == root->fs_info->tree_root)
+		ret = btrfs_bio_wq_end_io(root->fs_info, bio, 2);
+	else
+		ret = btrfs_bio_wq_end_io(root->fs_info, bio, 0);
 	BUG_ON(ret);
 
 	if (!(rw & (1 << BIO_RW))) {
@@ -1662,6 +1682,7 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 	struct extent_state *cached_state = NULL;
 	int compressed = 0;
 	int ret;
+	bool nolock = false;
 
 	ret = btrfs_dec_test_ordered_pending(inode, &ordered_extent, start,
 					     end - start + 1);
@@ -1669,11 +1690,17 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 		return 0;
 	BUG_ON(!ordered_extent);
 
+	nolock = (root == root->fs_info->tree_root);
+
 	if (test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags)) {
 		BUG_ON(!list_empty(&ordered_extent->list));
 		ret = btrfs_ordered_update_i_size(inode, 0, ordered_extent);
 		if (!ret) {
-			trans = btrfs_join_transaction(root, 1);
+			if (nolock)
+				trans = btrfs_join_transaction_nolock(root, 1);
+			else
+				trans = btrfs_join_transaction(root, 1);
+			BUG_ON(!trans);
 			btrfs_set_trans_block_group(trans, inode);
 			trans->block_rsv = &root->fs_info->delalloc_block_rsv;
 			ret = btrfs_update_inode(trans, root, inode);
@@ -1686,7 +1713,10 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 			 ordered_extent->file_offset + ordered_extent->len - 1,
 			 0, &cached_state, GFP_NOFS);
 
-	trans = btrfs_join_transaction(root, 1);
+	if (nolock)
+		trans = btrfs_join_transaction_nolock(root, 1);
+	else
+		trans = btrfs_join_transaction(root, 1);
 	btrfs_set_trans_block_group(trans, inode);
 	trans->block_rsv = &root->fs_info->delalloc_block_rsv;
 
@@ -1725,9 +1755,15 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 	ret = btrfs_update_inode(trans, root, inode);
 	BUG_ON(ret);
 out:
-	btrfs_delalloc_release_metadata(inode, ordered_extent->len);
-	if (trans)
-		btrfs_end_transaction(trans, root);
+	if (nolock) {
+		if (trans)
+			btrfs_end_transaction_nolock(trans, root);
+	} else {
+		btrfs_delalloc_release_metadata(inode, ordered_extent->len);
+		if (trans)
+			btrfs_end_transaction(trans, root);
+	}
+
 	/* once for us */
 	btrfs_put_ordered_extent(ordered_extent);
 	/* once for the tree */
-- 
1.6.6.1

