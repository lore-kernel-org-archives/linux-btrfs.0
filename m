From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH v2 5/7] Btrfs: Make the code for reading/writing free space
 cache generic
Date: Mon, 25 Apr 2011 16:59:29 +0800
Message-ID: <4DB537F1.6020604@cn.fujitsu.com>
References: <4DB5378B.2070904@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DB5378B.2070904@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Extract out block group specific code from lookup_free_space_inode(),
create_free_space_inode(), load_free_space_cache() and
btrfs_write_out_cache(), so the code can be used to read/write
free ino cache.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/free-space-cache.c |  358 ++++++++++++++++++++++++-------------------
 1 files changed, 204 insertions(+), 154 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 2ce89bf..fcbdcef 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -33,9 +33,9 @@
 static int link_free_space(struct btrfs_free_space_ctl *ctl,
 			   struct btrfs_free_space *info);
 
-struct inode *lookup_free_space_inode(struct btrfs_root *root,
-				      struct btrfs_block_group_cache
-				      *block_group, struct btrfs_path *path)
+static struct inode *__lookup_free_space_inode(struct btrfs_root *root,
+					       struct btrfs_path *path,
+					       u64 offset)
 {
 	struct btrfs_key key;
 	struct btrfs_key location;
@@ -45,15 +45,8 @@ struct inode *lookup_free_space_inode(struct btrfs_root *root,
 	struct inode *inode = NULL;
 	int ret;
 
-	spin_lock(&block_group->lock);
-	if (block_group->inode)
-		inode = igrab(block_group->inode);
-	spin_unlock(&block_group->lock);
-	if (inode)
-		return inode;
-
 	key.objectid = BTRFS_FREE_SPACE_OBJECTID;
-	key.offset = block_group->key.objectid;
+	key.offset = offset;
 	key.type = 0;
 
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
@@ -83,6 +76,27 @@ struct inode *lookup_free_space_inode(struct btrfs_root *root,
 
 	inode->i_mapping->flags &= ~__GFP_FS;
 
+	return inode;
+}
+
+struct inode *lookup_free_space_inode(struct btrfs_root *root,
+				      struct btrfs_block_group_cache
+				      *block_group, struct btrfs_path *path)
+{
+	struct inode *inode = NULL;
+
+	spin_lock(&block_group->lock);
+	if (block_group->inode)
+		inode = igrab(block_group->inode);
+	spin_unlock(&block_group->lock);
+	if (inode)
+		return inode;
+
+	inode = __lookup_free_space_inode(root, path,
+					  block_group->key.objectid);
+	if (IS_ERR(inode))
+		return inode;
+
 	spin_lock(&block_group->lock);
 	if (!root->fs_info->closing) {
 		block_group->inode = igrab(inode);
@@ -93,24 +107,18 @@ struct inode *lookup_free_space_inode(struct btrfs_root *root,
 	return inode;
 }
 
-int create_free_space_inode(struct btrfs_root *root,
-			    struct btrfs_trans_handle *trans,
-			    struct btrfs_block_group_cache *block_group,
-			    struct btrfs_path *path)
+int __create_free_space_inode(struct btrfs_root *root,
+			      struct btrfs_trans_handle *trans,
+			      struct btrfs_path *path, u64 ino, u64 offset)
 {
 	struct btrfs_key key;
 	struct btrfs_disk_key disk_key;
 	struct btrfs_free_space_header *header;
 	struct btrfs_inode_item *inode_item;
 	struct extent_buffer *leaf;
-	u64 objectid;
 	int ret;
 
-	ret = btrfs_find_free_objectid(root, &objectid);
-	if (ret < 0)
-		return ret;
-
-	ret = btrfs_insert_empty_inode(trans, root, path, objectid);
+	ret = btrfs_insert_empty_inode(trans, root, path, ino);
 	if (ret)
 		return ret;
 
@@ -130,13 +138,12 @@ int create_free_space_inode(struct btrfs_root *root,
 			      BTRFS_INODE_PREALLOC | BTRFS_INODE_NODATASUM);
 	btrfs_set_inode_nlink(leaf, inode_item, 1);
 	btrfs_set_inode_transid(leaf, inode_item, trans->transid);
-	btrfs_set_inode_block_group(leaf, inode_item,
-				    block_group->key.objectid);
+	btrfs_set_inode_block_group(leaf, inode_item, offset);
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_release_path(root, path);
 
 	key.objectid = BTRFS_FREE_SPACE_OBJECTID;
-	key.offset = block_group->key.objectid;
+	key.offset = offset;
 	key.type = 0;
 
 	ret = btrfs_insert_empty_item(trans, root, path, &key,
@@ -156,6 +163,22 @@ int create_free_space_inode(struct btrfs_root *root,
 	return 0;
 }
 
+int create_free_space_inode(struct btrfs_root *root,
+			    struct btrfs_trans_handle *trans,
+			    struct btrfs_block_group_cache *block_group,
+			    struct btrfs_path *path)
+{
+	int ret;
+	u64 ino;
+
+	ret = btrfs_find_free_objectid(root, &ino);
+	if (ret < 0)
+		return ret;
+
+	return __create_free_space_inode(root, trans, path, ino,
+					 block_group->key.objectid);
+}
+
 int btrfs_truncate_free_space_cache(struct btrfs_root *root,
 				    struct btrfs_trans_handle *trans,
 				    struct btrfs_path *path,
@@ -208,16 +231,13 @@ static int readahead_cache(struct inode *inode)
 	return 0;
 }
 
-int load_free_space_cache(struct btrfs_fs_info *fs_info,
-			  struct btrfs_block_group_cache *block_group)
+int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
+			    struct btrfs_free_space_ctl *ctl,
+			    struct btrfs_path *path, u64 offset)
 {
-	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
-	struct btrfs_root *root = fs_info->tree_root;
-	struct inode *inode;
 	struct btrfs_free_space_header *header;
 	struct extent_buffer *leaf;
 	struct page *page;
-	struct btrfs_path *path;
 	u32 *checksums = NULL, *crc;
 	char *disk_crcs = NULL;
 	struct btrfs_key key;
@@ -225,76 +245,47 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 	u64 num_entries;
 	u64 num_bitmaps;
 	u64 generation;
-	u64 used = btrfs_block_group_used(&block_group->item);
 	u32 cur_crc = ~(u32)0;
 	pgoff_t index = 0;
 	unsigned long first_page_offset;
 	int num_checksums;
-	int ret = 0;
-
-	/*
-	 * If we're unmounting then just return, since this does a search on the
-	 * normal root and not the commit root and we could deadlock.
-	 */
-	smp_mb();
-	if (fs_info->closing)
-		return 0;
-
-	/*
-	 * If this block group has been marked to be cleared for one reason or
-	 * another then we can't trust the on disk cache, so just return.
-	 */
-	spin_lock(&block_group->lock);
-	if (block_group->disk_cache_state != BTRFS_DC_WRITTEN) {
-		spin_unlock(&block_group->lock);
-		return 0;
-	}
-	spin_unlock(&block_group->lock);
+	int ret = 0, ret2;
 
 	INIT_LIST_HEAD(&bitmaps);
 
-	path = btrfs_alloc_path();
-	if (!path)
-		return 0;
-
-	inode = lookup_free_space_inode(root, block_group, path);
-	if (IS_ERR(inode)) {
-		btrfs_free_path(path);
-		return 0;
-	}
-
 	/* Nothing in the space cache, goodbye */
-	if (!i_size_read(inode)) {
-		btrfs_free_path(path);
+	if (!i_size_read(inode))
 		goto out;
-	}
 
 	key.objectid = BTRFS_FREE_SPACE_OBJECTID;
-	key.offset = block_group->key.objectid;
+	key.offset = offset;
 	key.type = 0;
 
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
-	if (ret) {
-		btrfs_free_path(path);
+	if (ret < 0)
+		goto out;
+	else if (ret > 0) {
+		btrfs_release_path(root, path);
+		ret = 0;
 		goto out;
 	}
 
+	ret = -1;
+
 	leaf = path->nodes[0];
 	header = btrfs_item_ptr(leaf, path->slots[0],
 				struct btrfs_free_space_header);
 	num_entries = btrfs_free_space_entries(leaf, header);
 	num_bitmaps = btrfs_free_space_bitmaps(leaf, header);
 	generation = btrfs_free_space_generation(leaf, header);
-	btrfs_free_path(path);
+	btrfs_release_path(root, path);
 
 	if (BTRFS_I(inode)->generation != generation) {
 		printk(KERN_ERR "btrfs: free space inode generation (%llu) did"
-		       " not match free space cache generation (%llu) for "
-		       "block group %llu\n",
+		       " not match free space cache generation (%llu)\n",
 		       (unsigned long long)BTRFS_I(inode)->generation,
-		       (unsigned long long)generation,
-		       (unsigned long long)block_group->key.objectid);
-		goto free_cache;
+		       (unsigned long long)generation);
+		goto out;
 	}
 
 	if (!num_entries)
@@ -311,10 +302,8 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 		goto out;
 
 	ret = readahead_cache(inode);
-	if (ret) {
-		ret = 0;
+	if (ret)
 		goto out;
-	}
 
 	while (1) {
 		struct btrfs_free_space_entry *entry;
@@ -333,10 +322,8 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 		}
 
 		page = grab_cache_page(inode->i_mapping, index);
-		if (!page) {
-			ret = 0;
+		if (!page)
 			goto free_cache;
-		}
 
 		if (!PageUptodate(page)) {
 			btrfs_readpage(NULL, page);
@@ -345,9 +332,7 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 				unlock_page(page);
 				page_cache_release(page);
 				printk(KERN_ERR "btrfs: error reading free "
-				       "space cache: %llu\n",
-				       (unsigned long long)
-				       block_group->key.objectid);
+				       "space cache\n");
 				goto free_cache;
 			}
 		}
@@ -360,13 +345,10 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 			gen = addr + (sizeof(u32) * num_checksums);
 			if (*gen != BTRFS_I(inode)->generation) {
 				printk(KERN_ERR "btrfs: space cache generation"
-				       " (%llu) does not match inode (%llu) "
-				       "for block group %llu\n",
+				       " (%llu) does not match inode (%llu)\n",
 				       (unsigned long long)*gen,
 				       (unsigned long long)
-				       BTRFS_I(inode)->generation,
-				       (unsigned long long)
-				       block_group->key.objectid);
+				       BTRFS_I(inode)->generation);
 				kunmap(page);
 				unlock_page(page);
 				page_cache_release(page);
@@ -382,9 +364,8 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 					  PAGE_CACHE_SIZE - start_offset);
 		btrfs_csum_final(cur_crc, (char *)&cur_crc);
 		if (cur_crc != *crc) {
-			printk(KERN_ERR "btrfs: crc mismatch for page %lu in "
-			       "block group %llu\n", index,
-			       (unsigned long long)block_group->key.objectid);
+			printk(KERN_ERR "btrfs: crc mismatch for page %lu\n",
+			       index);
 			kunmap(page);
 			unlock_page(page);
 			page_cache_release(page);
@@ -432,7 +413,7 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 					goto free_cache;
 				}
 				spin_lock(&ctl->tree_lock);
-				ret = link_free_space(ctl, e);
+				ret2 = link_free_space(ctl, e);
 				ctl->total_bitmaps++;
 				ctl->op->recalc_thresholds(ctl);
 				spin_unlock(&ctl->tree_lock);
@@ -471,42 +452,96 @@ next:
 		index++;
 	}
 
-	spin_lock(&ctl->tree_lock);
-	if (ctl->free_space != (block_group->key.offset - used -
-				block_group->bytes_super)) {
-		spin_unlock(&ctl->tree_lock);
-		printk(KERN_ERR "block group %llu has an wrong amount of free "
-		       "space\n", block_group->key.objectid);
-		ret = 0;
-		goto free_cache;
-	}
-	spin_unlock(&ctl->tree_lock);
-
 	ret = 1;
 out:
 	kfree(checksums);
 	kfree(disk_crcs);
-	iput(inode);
 	return ret;
-
 free_cache:
-	/* This cache is bogus, make sure it gets cleared */
-	spin_lock(&block_group->lock);
-	block_group->disk_cache_state = BTRFS_DC_CLEAR;
-	spin_unlock(&block_group->lock);
-	btrfs_remove_free_space_cache(block_group);
+	__btrfs_remove_free_space_cache(ctl);
 	goto out;
 }
 
-int btrfs_write_out_cache(struct btrfs_root *root,
-			  struct btrfs_trans_handle *trans,
-			  struct btrfs_block_group_cache *block_group,
-			  struct btrfs_path *path)
+int load_free_space_cache(struct btrfs_fs_info *fs_info,
+			  struct btrfs_block_group_cache *block_group)
 {
 	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
+	struct btrfs_root *root = fs_info->tree_root;
+	struct inode *inode;
+	struct btrfs_path *path;
+	int ret;
+	bool matched;
+	u64 used = btrfs_block_group_used(&block_group->item);
+
+	/*
+	 * If we're unmounting then just return, since this does a search on the
+	 * normal root and not the commit root and we could deadlock.
+	 */
+	smp_mb();
+	if (fs_info->closing)
+		return 0;
+
+	/*
+	 * If this block group has been marked to be cleared for one reason or
+	 * another then we can't trust the on disk cache, so just return.
+	 */
+	spin_lock(&block_group->lock);
+	if (block_group->disk_cache_state != BTRFS_DC_WRITTEN) {
+		spin_unlock(&block_group->lock);
+		return 0;
+	}
+	spin_unlock(&block_group->lock);
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return 0;
+
+	inode = lookup_free_space_inode(root, block_group, path);
+	if (IS_ERR(inode)) {
+		btrfs_free_path(path);
+		return 0;
+	}
+
+	ret = __load_free_space_cache(fs_info->tree_root, inode, ctl,
+				      path, block_group->key.objectid);
+	btrfs_free_path(path);
+	if (ret <= 0)
+		goto out;
+
+	spin_lock(&ctl->tree_lock);
+	matched = (ctl->free_space == (block_group->key.offset - used -
+				       block_group->bytes_super));
+	spin_unlock(&ctl->tree_lock);
+
+	if (!matched) {
+		__btrfs_remove_free_space_cache(ctl);
+		printk(KERN_ERR "block group %llu has an wrong amount of free "
+		       "space\n", block_group->key.objectid);
+		ret = -1;
+	}
+out:
+	if (ret < 0) {
+		/* This cache is bogus, make sure it gets cleared */
+		spin_lock(&block_group->lock);
+		block_group->disk_cache_state = BTRFS_DC_CLEAR;
+		spin_unlock(&block_group->lock);
+
+		printk(KERN_ERR "btrfs: failed to load free space cache "
+		       "for block group %llu\n", block_group->key.objectid);
+	}
+
+	iput(inode);
+	return ret;
+}
+
+int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
+			    struct btrfs_free_space_ctl *ctl,
+			    struct btrfs_block_group_cache *block_group,
+			    struct btrfs_trans_handle *trans,
+			    struct btrfs_path *path, u64 offset)
+{
 	struct btrfs_free_space_header *header;
 	struct extent_buffer *leaf;
-	struct inode *inode;
 	struct rb_node *node;
 	struct list_head *pos, *n;
 	struct page **pages;
@@ -523,35 +558,18 @@ int btrfs_write_out_cache(struct btrfs_root *root,
 	int index = 0, num_pages = 0;
 	int entries = 0;
 	int bitmaps = 0;
-	int ret = 0;
+	int ret = -1;
 	bool next_page = false;
 	bool out_of_space = false;
 
-	root = root->fs_info->tree_root;
-
 	INIT_LIST_HEAD(&bitmap_list);
 
-	spin_lock(&block_group->lock);
-	if (block_group->disk_cache_state < BTRFS_DC_SETUP) {
-		spin_unlock(&block_group->lock);
-		return 0;
-	}
-	spin_unlock(&block_group->lock);
-
-	inode = lookup_free_space_inode(root, block_group, path);
-	if (IS_ERR(inode))
-		return 0;
-
-	if (!i_size_read(inode)) {
-		iput(inode);
-		return 0;
-	}
-
 	node = rb_first(&ctl->free_space_offset);
-	if (!node) {
-		iput(inode);
+	if (!node)
 		return 0;
-	}
+
+	if (!i_size_read(inode))
+		return -1;
 
 	num_pages = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >>
 		PAGE_CACHE_SHIFT;
@@ -561,16 +579,13 @@ int btrfs_write_out_cache(struct btrfs_root *root,
 
 	/* We need a checksum per page. */
 	crc = checksums = kzalloc(sizeof(u32) * num_pages, GFP_NOFS);
-	if (!crc) {
-		iput(inode);
-		return 0;
-	}
+	if (!crc)
+		return -1;
 
 	pages = kzalloc(sizeof(struct page *) * num_pages, GFP_NOFS);
 	if (!pages) {
 		kfree(crc);
-		iput(inode);
-		return 0;
+		return -1;
 	}
 
 	/* Since the first page has all of our checksums and our generation we
@@ -580,7 +595,7 @@ int btrfs_write_out_cache(struct btrfs_root *root,
 	first_page_offset = (sizeof(u32) * num_pages) + sizeof(u64);
 
 	/* Get the cluster for this block_group if it exists */
-	if (!list_empty(&block_group->cluster_list))
+	if (block_group && !list_empty(&block_group->cluster_list))
 		cluster = list_entry(block_group->cluster_list.next,
 				     struct btrfs_free_cluster,
 				     block_group_list);
@@ -622,7 +637,8 @@ int btrfs_write_out_cache(struct btrfs_root *root,
 	 * When searching for pinned extents, we need to start at our start
 	 * offset.
 	 */
-	start = block_group->key.objectid;
+	if (block_group)
+		start = block_group->key.objectid;
 
 	/* Write out the extent entries */
 	do {
@@ -680,8 +696,9 @@ int btrfs_write_out_cache(struct btrfs_root *root,
 		 * We want to add any pinned extents to our free space cache
 		 * so we don't leak the space
 		 */
-		while (!next_page && (start < block_group->key.objectid +
-				      block_group->key.offset)) {
+		while (block_group && !next_page &&
+		       (start < block_group->key.objectid +
+			block_group->key.offset)) {
 			ret = find_first_extent_bit(unpin, start, &start, &end,
 						    EXTENT_DIRTY);
 			if (ret) {
@@ -799,12 +816,12 @@ int btrfs_write_out_cache(struct btrfs_root *root,
 	filemap_write_and_wait(inode->i_mapping);
 
 	key.objectid = BTRFS_FREE_SPACE_OBJECTID;
-	key.offset = block_group->key.objectid;
+	key.offset = offset;
 	key.type = 0;
 
 	ret = btrfs_search_slot(trans, root, &key, path, 1, 1);
 	if (ret < 0) {
-		ret = 0;
+		ret = -1;
 		clear_extent_bit(&BTRFS_I(inode)->io_tree, 0, bytes - 1,
 				 EXTENT_DIRTY | EXTENT_DELALLOC |
 				 EXTENT_DO_ACCOUNTING, 0, 0, NULL, GFP_NOFS);
@@ -817,8 +834,8 @@ int btrfs_write_out_cache(struct btrfs_root *root,
 		path->slots[0]--;
 		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
 		if (found_key.objectid != BTRFS_FREE_SPACE_OBJECTID ||
-		    found_key.offset != block_group->key.objectid) {
-			ret = 0;
+		    found_key.offset != offset) {
+			ret = -1;
 			clear_extent_bit(&BTRFS_I(inode)->io_tree, 0, bytes - 1,
 					 EXTENT_DIRTY | EXTENT_DELALLOC |
 					 EXTENT_DO_ACCOUNTING, 0, 0, NULL,
@@ -838,16 +855,49 @@ int btrfs_write_out_cache(struct btrfs_root *root,
 	ret = 1;
 
 out_free:
-	if (ret == 0) {
+	if (ret != 1) {
 		invalidate_inode_pages2_range(inode->i_mapping, 0, index);
-		spin_lock(&block_group->lock);
-		block_group->disk_cache_state = BTRFS_DC_ERROR;
-		spin_unlock(&block_group->lock);
 		BTRFS_I(inode)->generation = 0;
 	}
 	kfree(checksums);
 	kfree(pages);
 	btrfs_update_inode(trans, root, inode);
+	return ret;
+}
+
+int btrfs_write_out_cache(struct btrfs_root *root,
+			  struct btrfs_trans_handle *trans,
+			  struct btrfs_block_group_cache *block_group,
+			  struct btrfs_path *path)
+{
+	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
+	struct inode *inode;
+	int ret = 0;
+
+	root = root->fs_info->tree_root;
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
+	ret = __btrfs_write_out_cache(root, inode, ctl, block_group, trans,
+				      path, block_group->key.objectid);
+	if (ret < 0) {
+		spin_lock(&block_group->lock);
+		block_group->disk_cache_state = BTRFS_DC_ERROR;
+		spin_unlock(&block_group->lock);
+
+		printk(KERN_ERR "btrfs: failed to write free space cace "
+		       "for block group %llu\n", block_group->key.objectid);
+	}
+
 	iput(inode);
 	return ret;
 }
-- 
1.7.3.1
