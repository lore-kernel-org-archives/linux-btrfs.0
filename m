From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 3/3] Btrfs: load free space cache if it exists
Date: Wed, 22 Sep 2010 14:39:42 -0400
Message-ID: <1285180782-29364-4-git-send-email-josef@redhat.com>
References: <1285180782-29364-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1285180782-29364-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

This patch actually loads the free space cache if it exists.  The only thing
that really changes here is that we need to cache the block group if we're going
to remove an extent from it.  Previously we did not do this since the caching
kthread would pick it up.  With the on disk cache we don't have this luxury so
we need to make sure we read the on disk cache in first, and then remove the
extent, that way when the extent is unpinned the free space is added to the
block group.  This has been tested with all sorts of things.

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c      |   50 +++++++-
 fs/btrfs/free-space-cache.c |  296 +++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/free-space-cache.h |    2 +
 3 files changed, 345 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 6994423..8db9330 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -421,7 +421,9 @@ err:
 	return 0;
 }
 
-static int cache_block_group(struct btrfs_block_group_cache *cache)
+static int cache_block_group(struct btrfs_block_group_cache *cache,
+			     struct btrfs_trans_handle *trans,
+			     int load_cache_only)
 {
 	struct btrfs_fs_info *fs_info = cache->fs_info;
 	struct btrfs_caching_control *caching_ctl;
@@ -432,6 +434,36 @@ static int cache_block_group(struct btrfs_block_group_cache *cache)
 	if (cache->cached != BTRFS_CACHE_NO)
 		return 0;
 
+	/*
+	 * We can't do the read from on-disk cache during a commit since we need
+	 * to have the normal tree locking.
+	 */
+	if (!trans->transaction->in_commit) {
+		spin_lock(&cache->lock);
+		if (cache->cached != BTRFS_CACHE_NO) {
+			spin_unlock(&cache->lock);
+			return 0;
+		}
+		cache->cached = BTRFS_CACHE_STARTED;
+		spin_unlock(&cache->lock);
+
+		ret = load_free_space_cache(fs_info, cache);
+
+		spin_lock(&cache->lock);
+		if (ret == 1) {
+			cache->cached = BTRFS_CACHE_FINISHED;
+			cache->last_byte_to_unpin = (u64)-1;
+		} else {
+			cache->cached = BTRFS_CACHE_NO;
+		}
+		spin_unlock(&cache->lock);
+		if (ret == 1)
+			return 0;
+	}
+
+	if (load_cache_only)
+		return 0;
+
 	caching_ctl = kzalloc(sizeof(*caching_ctl), GFP_KERNEL);
 	BUG_ON(!caching_ctl);
 
@@ -3985,6 +4017,14 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 			factor = 2;
 		else
 			factor = 1;
+		/*
+		 * If this block group has free space cache written out, we
+		 * need to make sure to load it if we are removing space.  This
+		 * is because we need the unpinning stage to actually add the
+		 * space back to the block group, otherwise we will leak space.
+		 */
+		if (!alloc && cache->cached == BTRFS_CACHE_NO)
+			cache_block_group(cache, trans, 1);
 
 		byte_in_group = bytenr - cache->key.objectid;
 		WARN_ON(byte_in_group > cache->key.offset);
@@ -4829,6 +4869,10 @@ have_block_group:
 		if (unlikely(block_group->cached == BTRFS_CACHE_NO)) {
 			u64 free_percent;
 
+			ret = cache_block_group(block_group, trans, 1);
+			if (block_group->cached == BTRFS_CACHE_FINISHED)
+				goto have_block_group;
+
 			free_percent = btrfs_block_group_used(&block_group->item);
 			free_percent *= 100;
 			free_percent = div64_u64(free_percent,
@@ -4849,7 +4893,7 @@ have_block_group:
 			if (loop > LOOP_CACHING_NOWAIT ||
 			    (loop > LOOP_FIND_IDEAL &&
 			     atomic_read(&space_info->caching_threads) < 2)) {
-				ret = cache_block_group(block_group);
+				ret = cache_block_group(block_group, trans, 0);
 				BUG_ON(ret);
 			}
 			found_uncached_bg = true;
@@ -5406,7 +5450,7 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 	u64 num_bytes = ins->offset;
 
 	block_group = btrfs_lookup_block_group(root->fs_info, ins->objectid);
-	cache_block_group(block_group);
+	cache_block_group(block_group, trans, 0);
 	caching_ctl = get_caching_control(block_group);
 
 	if (!caching_ctl) {
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 8fe0aee..c2e8c71 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -187,6 +187,302 @@ int btrfs_truncate_free_space_cache(struct btrfs_root *root,
 	return btrfs_update_inode(trans, root, inode);
 }
 
+static int readahead_cache(struct inode *inode)
+{
+	struct file_ra_state *ra;
+	unsigned long last_index;
+
+	ra = kzalloc(sizeof(*ra), GFP_NOFS);
+	if (!ra)
+		return -ENOMEM;
+
+	file_ra_state_init(ra, inode->i_mapping);
+	last_index = (i_size_read(inode) - 1) >> PAGE_CACHE_SHIFT;
+
+	page_cache_sync_readahead(inode->i_mapping, ra, NULL, 0, last_index);
+
+	kfree(ra);
+
+	return 0;
+}
+
+int load_free_space_cache(struct btrfs_fs_info *fs_info,
+			  struct btrfs_block_group_cache *block_group)
+{
+	struct btrfs_root *root = fs_info->tree_root;
+	struct inode *inode;
+	struct btrfs_free_space_header *header;
+	struct extent_buffer *leaf;
+	struct page *page;
+	struct btrfs_path *path;
+	u32 *checksums = NULL, *crc;
+	char *disk_crcs = NULL;
+	struct btrfs_key key;
+	struct list_head bitmaps;
+	u64 num_entries;
+	u64 num_bitmaps;
+	u64 generation;
+	u32 cur_crc = ~(u32)0;
+	pgoff_t index = 0;
+	unsigned long first_page_offset;
+	int num_checksums;
+	int ret = 0;
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
+		printk(KERN_ERR "not reading block group %llu, dcs is %d\n", block_group->key.objectid,
+		       block_group->disk_cache_state);
+		spin_unlock(&block_group->lock);
+		return 0;
+	}
+	spin_unlock(&block_group->lock);
+
+	INIT_LIST_HEAD(&bitmaps);
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
+	/* Nothing in the space cache, goodbye */
+	if (!i_size_read(inode)) {
+		btrfs_free_path(path);
+		goto out;
+	}
+
+	key.objectid = BTRFS_FREE_SPACE_OBJECTID;
+	key.offset = block_group->key.objectid;
+	key.type = 0;
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret) {
+		btrfs_free_path(path);
+		goto out;
+	}
+
+	leaf = path->nodes[0];
+	header = btrfs_item_ptr(leaf, path->slots[0],
+				struct btrfs_free_space_header);
+	num_entries = btrfs_free_space_entries(leaf, header);
+	num_bitmaps = btrfs_free_space_bitmaps(leaf, header);
+	generation = btrfs_free_space_generation(leaf, header);
+	btrfs_free_path(path);
+
+	if (BTRFS_I(inode)->generation != generation) {
+		printk(KERN_ERR "btrfs: free space inode generation (%llu) did"
+		       " not match free space cache generation (%llu) for "
+		       "block group %llu\n",
+		       (unsigned long long)BTRFS_I(inode)->generation,
+		       (unsigned long long)generation,
+		       (unsigned long long)block_group->key.objectid);
+		goto out;
+	}
+
+	if (!num_entries)
+		goto out;
+
+	/* Setup everything for doing checksumming */
+	num_checksums = i_size_read(inode) / PAGE_CACHE_SIZE;
+	checksums = crc = kzalloc(sizeof(u32) * num_checksums, GFP_NOFS);
+	if (!checksums)
+		goto out;
+	first_page_offset = (sizeof(u32) * num_checksums) + sizeof(u64);
+	disk_crcs = kzalloc(first_page_offset, GFP_NOFS);
+	if (!disk_crcs)
+		goto out;
+
+	ret = readahead_cache(inode);
+	if (ret) {
+		ret = 0;
+		goto out;
+	}
+
+	while (1) {
+		struct btrfs_free_space_entry *entry;
+		struct btrfs_free_space *e;
+		void *addr;
+		unsigned long offset = 0;
+		unsigned long start_offset = 0;
+		int need_loop = 0;
+
+		if (!num_entries && !num_bitmaps)
+			break;
+
+		if (index == 0) {
+			start_offset = first_page_offset;
+			offset = start_offset;
+		}
+
+		page = grab_cache_page(inode->i_mapping, index);
+		if (!page) {
+			ret = 0;
+			goto free_cache;
+		}
+
+		if (!PageUptodate(page)) {
+			btrfs_readpage(NULL, page);
+			lock_page(page);
+			if (!PageUptodate(page)) {
+				unlock_page(page);
+				page_cache_release(page);
+				printk(KERN_ERR "btrfs: error reading free "
+				       "space cache: %llu\n",
+				       (unsigned long long)
+				       block_group->key.objectid);
+				goto free_cache;
+			}
+		}
+		addr = kmap(page);
+
+		if (index == 0) {
+			u64 *gen;
+
+			memcpy(disk_crcs, addr, first_page_offset);
+			gen = addr + (sizeof(u32) * num_checksums);
+			if (*gen != BTRFS_I(inode)->generation) {
+				printk(KERN_ERR "btrfs: space cache generation"
+				       " (%llu) does not match inode (%llu) "
+				       "for block group %llu\n",
+				       (unsigned long long)*gen,
+				       (unsigned long long)
+				       BTRFS_I(inode)->generation,
+				       (unsigned long long)
+				       block_group->key.objectid);
+				kunmap(page);
+				unlock_page(page);
+				page_cache_release(page);
+				goto free_cache;
+			}
+			crc = (u32 *)disk_crcs;
+		}
+		entry = addr + start_offset;
+
+		/* First lets check our crc before we do anything fun */
+		cur_crc = ~(u32)0;
+		cur_crc = btrfs_csum_data(root, addr + start_offset, cur_crc,
+					  PAGE_CACHE_SIZE - start_offset);
+		btrfs_csum_final(cur_crc, (char *)&cur_crc);
+		if (cur_crc != *crc) {
+			printk(KERN_ERR "btrfs: crc mismatch for page %lu in "
+			       "block group %llu\n", index,
+			       (unsigned long long)block_group->key.objectid);
+			kunmap(page);
+			unlock_page(page);
+			page_cache_release(page);
+			goto free_cache;
+		}
+		crc++;
+
+		while (1) {
+			if (!num_entries)
+				break;
+
+			need_loop = 1;
+			e = kzalloc(sizeof(struct btrfs_free_space), GFP_NOFS);
+			if (!e) {
+				kunmap(page);
+				unlock_page(page);
+				page_cache_release(page);
+				goto free_cache;
+			}
+
+			e->offset = le64_to_cpu(entry->offset);
+			e->bytes = le64_to_cpu(entry->bytes);
+			if (!e->bytes) {
+				kunmap(page);
+				kfree(e);
+				unlock_page(page);
+				page_cache_release(page);
+				goto free_cache;
+			}
+
+			if (entry->type == BTRFS_FREE_SPACE_EXTENT) {
+				spin_lock(&block_group->tree_lock);
+				ret = link_free_space(block_group, e);
+				spin_unlock(&block_group->tree_lock);
+				BUG_ON(ret);
+			} else {
+				e->bitmap = kzalloc(PAGE_CACHE_SIZE, GFP_NOFS);
+				if (!e->bitmap) {
+					kunmap(page);
+					kfree(e);
+					unlock_page(page);
+					page_cache_release(page);
+					goto free_cache;
+				}
+				spin_lock(&block_group->tree_lock);
+				ret = link_free_space(block_group, e);
+				block_group->total_bitmaps++;
+				recalculate_thresholds(block_group);
+				spin_unlock(&block_group->tree_lock);
+				list_add_tail(&e->list, &bitmaps);
+			}
+
+			num_entries--;
+			offset += sizeof(struct btrfs_free_space_entry);
+			if (offset + sizeof(struct btrfs_free_space_entry) >=
+			    PAGE_CACHE_SIZE)
+				break;
+			entry++;
+		}
+
+		/*
+		 * We read an entry out of this page, we need to move on to the
+		 * next page.
+		 */
+		if (need_loop) {
+			kunmap(page);
+			goto next;
+		}
+
+		/*
+		 * We add the bitmaps at the end of the entries in order that
+		 * the bitmap entries are added to the cache.
+		 */
+		e = list_entry(bitmaps.next, struct btrfs_free_space, list);
+		list_del_init(&e->list);
+		memcpy(e->bitmap, addr, PAGE_CACHE_SIZE);
+		kunmap(page);
+		num_bitmaps--;
+next:
+		unlock_page(page);
+		page_cache_release(page);
+		index++;
+	}
+
+	ret = 1;
+out:
+	kfree(checksums);
+	kfree(disk_crcs);
+	iput(inode);
+	return ret;
+
+free_cache:
+	/* This cache is bogus, make sure it gets cleared */
+	spin_lock(&block_group->lock);
+	block_group->disk_cache_state = BTRFS_DC_CLEAR;
+	spin_unlock(&block_group->lock);
+	btrfs_remove_free_space_cache(block_group);
+	goto out;
+}
+
 int btrfs_write_out_cache(struct btrfs_root *root,
 			  struct btrfs_trans_handle *trans,
 			  struct btrfs_block_group_cache *block_group,
diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index 189f740..e49ca5c 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -39,6 +39,8 @@ int btrfs_truncate_free_space_cache(struct btrfs_root *root,
 				    struct btrfs_trans_handle *trans,
 				    struct btrfs_path *path,
 				    struct inode *inode);
+int load_free_space_cache(struct btrfs_fs_info *fs_info,
+			  struct btrfs_block_group_cache *block_group);
 int btrfs_write_out_cache(struct btrfs_root *root,
 			  struct btrfs_trans_handle *trans,
 			  struct btrfs_block_group_cache *block_group,
-- 
1.6.6.1

