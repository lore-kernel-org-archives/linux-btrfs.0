From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: use the normal checksumming infrastructure for free space cache
Date: Fri, 10 Jun 2011 15:40:27 -0400
Message-ID: <1307734827-10697-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We used to store the checksums of the space cache directly in the space cache,
however that doesn't work out too well if we have more space than we can fit the
checksums into the first page.  So instead use the normal checksumming
infrastructure.  There were problems with doing this originally but those
problems don't exist now so this works out fine.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/free-space-cache.c |  137 +++++++++----------------------------------
 1 files changed, 28 insertions(+), 109 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 38f3fd9..17c26aa 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -98,6 +98,12 @@ struct inode *lookup_free_space_inode(struct btrfs_root *root,
 		return inode;
 
 	spin_lock(&block_group->lock);
+	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM) {
+		printk(KERN_INFO "Old style space inode found, converting.\n");
+		BTRFS_I(inode)->flags &= ~BTRFS_INODE_NODATASUM;
+		block_group->disk_cache_state = BTRFS_DC_CLEAR;
+	}
+
 	if (!btrfs_fs_closing(root->fs_info)) {
 		block_group->inode = igrab(inode);
 		block_group->iref = 1;
@@ -135,7 +141,7 @@ int __create_free_space_inode(struct btrfs_root *root,
 	btrfs_set_inode_gid(leaf, inode_item, 0);
 	btrfs_set_inode_mode(leaf, inode_item, S_IFREG | 0600);
 	btrfs_set_inode_flags(leaf, inode_item, BTRFS_INODE_NOCOMPRESS |
-			      BTRFS_INODE_PREALLOC | BTRFS_INODE_NODATASUM);
+			      BTRFS_INODE_PREALLOC);
 	btrfs_set_inode_nlink(leaf, inode_item, 1);
 	btrfs_set_inode_transid(leaf, inode_item, trans->transid);
 	btrfs_set_inode_block_group(leaf, inode_item, offset);
@@ -239,17 +245,12 @@ int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 	struct btrfs_free_space_header *header;
 	struct extent_buffer *leaf;
 	struct page *page;
-	u32 *checksums = NULL, *crc;
-	char *disk_crcs = NULL;
 	struct btrfs_key key;
 	struct list_head bitmaps;
 	u64 num_entries;
 	u64 num_bitmaps;
 	u64 generation;
-	u32 cur_crc = ~(u32)0;
 	pgoff_t index = 0;
-	unsigned long first_page_offset;
-	int num_checksums;
 	int ret = 0;
 
 	INIT_LIST_HEAD(&bitmaps);
@@ -292,16 +293,6 @@ int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 	if (!num_entries)
 		goto out;
 
-	/* Setup everything for doing checksumming */
-	num_checksums = i_size_read(inode) / PAGE_CACHE_SIZE;
-	checksums = crc = kzalloc(sizeof(u32) * num_checksums, GFP_NOFS);
-	if (!checksums)
-		goto out;
-	first_page_offset = (sizeof(u32) * num_checksums) + sizeof(u64);
-	disk_crcs = kzalloc(first_page_offset, GFP_NOFS);
-	if (!disk_crcs)
-		goto out;
-
 	ret = readahead_cache(inode);
 	if (ret)
 		goto out;
@@ -311,17 +302,11 @@ int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 		struct btrfs_free_space *e;
 		void *addr;
 		unsigned long offset = 0;
-		unsigned long start_offset = 0;
 		int need_loop = 0;
 
 		if (!num_entries && !num_bitmaps)
 			break;
 
-		if (index == 0) {
-			start_offset = first_page_offset;
-			offset = start_offset;
-		}
-
 		page = grab_cache_page(inode->i_mapping, index);
 		if (!page)
 			goto free_cache;
@@ -342,8 +327,7 @@ int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 		if (index == 0) {
 			u64 *gen;
 
-			memcpy(disk_crcs, addr, first_page_offset);
-			gen = addr + (sizeof(u32) * num_checksums);
+			gen = addr;
 			if (*gen != BTRFS_I(inode)->generation) {
 				printk(KERN_ERR "btrfs: space cache generation"
 				       " (%llu) does not match inode (%llu)\n",
@@ -355,24 +339,10 @@ int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 				page_cache_release(page);
 				goto free_cache;
 			}
-			crc = (u32 *)disk_crcs;
-		}
-		entry = addr + start_offset;
-
-		/* First lets check our crc before we do anything fun */
-		cur_crc = ~(u32)0;
-		cur_crc = btrfs_csum_data(root, addr + start_offset, cur_crc,
-					  PAGE_CACHE_SIZE - start_offset);
-		btrfs_csum_final(cur_crc, (char *)&cur_crc);
-		if (cur_crc != *crc) {
-			printk(KERN_ERR "btrfs: crc mismatch for page %lu\n",
-			       index);
-			kunmap(page);
-			unlock_page(page);
-			page_cache_release(page);
-			goto free_cache;
+			addr += sizeof(u64);
+			offset += sizeof(u64);
 		}
-		crc++;
+		entry = addr;
 
 		while (1) {
 			if (!num_entries)
@@ -470,8 +440,6 @@ next:
 
 	ret = 1;
 out:
-	kfree(checksums);
-	kfree(disk_crcs);
 	return ret;
 free_cache:
 	__btrfs_remove_free_space_cache(ctl);
@@ -569,8 +537,6 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 	struct btrfs_key key;
 	u64 start, end, len;
 	u64 bytes = 0;
-	u32 *crc, *checksums;
-	unsigned long first_page_offset;
 	int index = 0, num_pages = 0;
 	int entries = 0;
 	int bitmaps = 0;
@@ -590,34 +556,13 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 	num_pages = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >>
 		PAGE_CACHE_SHIFT;
 
-	/* Since the first page has all of our checksums and our generation we
-	 * need to calculate the offset into the page that we can start writing
-	 * our entries.
-	 */
-	first_page_offset = (sizeof(u32) * num_pages) + sizeof(u64);
-
 	filemap_write_and_wait(inode->i_mapping);
 	btrfs_wait_ordered_range(inode, inode->i_size &
 				 ~(root->sectorsize - 1), (u64)-1);
 
-	/* make sure we don't overflow that first page */
-	if (first_page_offset + sizeof(struct btrfs_free_space_entry) >= PAGE_CACHE_SIZE) {
-		/* this is really the same as running out of space, where we also return 0 */
-		printk(KERN_CRIT "Btrfs: free space cache was too big for the crc page\n");
-		ret = 0;
-		goto out_update;
-	}
-
-	/* We need a checksum per page. */
-	crc = checksums = kzalloc(sizeof(u32) * num_pages, GFP_NOFS);
-	if (!crc)
-		return -1;
-
 	pages = kzalloc(sizeof(struct page *) * num_pages, GFP_NOFS);
-	if (!pages) {
-		kfree(crc);
+	if (!pages)
 		return -1;
-	}
 
 	/* Get the cluster for this block_group if it exists */
 	if (block_group && !list_empty(&block_group->cluster_list))
@@ -648,7 +593,7 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 				unlock_page(pages[i]);
 				page_cache_release(pages[i]);
 			}
-			goto out_free;
+			goto out;
 		}
 		pages[index] = page;
 		index++;
@@ -670,15 +615,9 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 		struct btrfs_free_space_entry *entry;
 		void *addr;
 		unsigned long offset = 0;
-		unsigned long start_offset = 0;
 
 		next_page = false;
 
-		if (index == 0) {
-			start_offset = first_page_offset;
-			offset = start_offset;
-		}
-
 		if (index >= num_pages) {
 			out_of_space = true;
 			break;
@@ -687,9 +626,17 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 		page = pages[index];
 
 		addr = kmap(page);
-		entry = addr + start_offset;
+		if (index == 0) {
+			u64 *gen;
 
-		memset(addr, 0, PAGE_CACHE_SIZE);
+			gen = addr;
+			*gen = trans->transid;
+			addr += sizeof(u64);
+			offset += sizeof(u64);
+		}
+		entry = addr;
+
+		memset(addr, 0, PAGE_CACHE_SIZE - offset);
 		while (node && !next_page) {
 			struct btrfs_free_space *e;
 
@@ -752,14 +699,8 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 				next_page = true;
 			entry++;
 		}
-		*crc = ~(u32)0;
-		*crc = btrfs_csum_data(root, addr + start_offset, *crc,
-				       PAGE_CACHE_SIZE - start_offset);
 		kunmap(page);
 
-		btrfs_csum_final(*crc, (char *)crc);
-		crc++;
-
 		bytes += PAGE_CACHE_SIZE;
 
 		index++;
@@ -779,11 +720,7 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 
 		addr = kmap(page);
 		memcpy(addr, entry->bitmap, PAGE_CACHE_SIZE);
-		*crc = ~(u32)0;
-		*crc = btrfs_csum_data(root, addr, *crc, PAGE_CACHE_SIZE);
 		kunmap(page);
-		btrfs_csum_final(*crc, (char *)crc);
-		crc++;
 		bytes += PAGE_CACHE_SIZE;
 
 		list_del_init(&entry->list);
@@ -796,7 +733,7 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 				     i_size_read(inode) - 1, &cached_state,
 				     GFP_NOFS);
 		ret = 0;
-		goto out_free;
+		goto out;
 	}
 
 	/* Zero out the rest of the pages just to make sure */
@@ -811,20 +748,6 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 		index++;
 	}
 
-	/* Write the checksums and trans id to the first page */
-	{
-		void *addr;
-		u64 *gen;
-
-		page = pages[0];
-
-		addr = kmap(page);
-		memcpy(addr, checksums, sizeof(u32) * num_pages);
-		gen = addr + (sizeof(u32) * num_pages);
-		*gen = trans->transid;
-		kunmap(page);
-	}
-
 	ret = btrfs_dirty_pages(root, inode, pages, num_pages, 0,
 					    bytes, &cached_state);
 	btrfs_drop_pages(pages, num_pages);
@@ -833,7 +756,7 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 
 	if (ret) {
 		ret = 0;
-		goto out_free;
+		goto out;
 	}
 
 	BTRFS_I(inode)->generation = trans->transid;
@@ -850,7 +773,7 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 		clear_extent_bit(&BTRFS_I(inode)->io_tree, 0, bytes - 1,
 				 EXTENT_DIRTY | EXTENT_DELALLOC |
 				 EXTENT_DO_ACCOUNTING, 0, 0, NULL, GFP_NOFS);
-		goto out_free;
+		goto out;
 	}
 	leaf = path->nodes[0];
 	if (ret > 0) {
@@ -866,7 +789,7 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 					 EXTENT_DO_ACCOUNTING, 0, 0, NULL,
 					 GFP_NOFS);
 			btrfs_release_path(path);
-			goto out_free;
+			goto out;
 		}
 	}
 	header = btrfs_item_ptr(leaf, path->slots[0],
@@ -879,11 +802,7 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 
 	ret = 1;
 
-out_free:
-	kfree(checksums);
-	kfree(pages);
-
-out_update:
+out:
 	if (ret != 1) {
 		invalidate_inode_pages2_range(inode->i_mapping, 0, index);
 		BTRFS_I(inode)->generation = 0;
-- 
1.7.2.3

