From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: inline checksums into the space cache
Date: Fri,  7 Oct 2011 10:55:14 -0400
Message-ID: <1317999314-6042-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Yeah yeah I know this is how we used to do it and then I changed it, but damnit
I'm changing it back.  The fact is that writing out checksums will modify
metadata, which could cause us to dirty a block group we've already written out,
so we have to truncate it and all of it's checksums and re-write it which will
write new checksums which could dirty a blockg roup that has already been
written and you see where I'm going with this?  This can cause unmount or really
anything that depends on a transaction to commit to take it's sweet damned time
to happen.  So go back to the way it was, only this time we're specifically
setting NODATACOW because we can't go through the COW pathway anyway and we're
doing our own built-in cow'ing by truncating the free space cache.  The other
new thing is once we truncate the old cache and preallocate the new space, we
don't need to do that song and dance at all for the rest of the transaction, we
can just overwrite the existing space with the new cache if the block group
changes for whatever reason, and the NODATACOW will let us do this fine.  So
keep track of which transaction we last cleared our cache in and if we cleared
it in this transaction just say we're all setup and carry on.  This survives
xfstests and stress.sh.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.h            |    1 +
 fs/btrfs/extent-tree.c      |   18 +++--
 fs/btrfs/free-space-cache.c |  175 ++++++++++++++++++++++++++++---------------
 fs/btrfs/inode-map.c        |    6 +-
 fs/btrfs/inode.c            |    2 +-
 5 files changed, 130 insertions(+), 72 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1eafccb..ea60897 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -838,6 +838,7 @@ struct btrfs_block_group_cache {
 	u64 bytes_super;
 	u64 flags;
 	u64 sectorsize;
+	u64 cache_generation;
 	unsigned int ro:1;
 	unsigned int dirty:1;
 	unsigned int iref:1;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f95e550..0abf70c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2717,6 +2717,13 @@ again:
 		goto again;
 	}
 
+	/* We've already setup this transaction, go ahead and exit */
+	if (block_group->cache_generation == trans->transid &&
+	    i_size_read(inode)) {
+		dcs = BTRFS_DC_SETUP;
+		goto out_put;
+	}
+
 	/*
 	 * We want to set the generation to 0, that way if anything goes wrong
 	 * from here on out we know not to trust this cache when we load up next
@@ -2756,19 +2763,16 @@ again:
 	num_pages *= 16;
 	num_pages *= PAGE_CACHE_SIZE;
 
-	ret = btrfs_delalloc_reserve_space(inode, num_pages);
+	ret = btrfs_check_data_free_space(inode, num_pages);
 	if (ret)
 		goto out_put;
 
 	ret = btrfs_prealloc_file_range_trans(inode, trans, 0, 0, num_pages,
 					      num_pages, num_pages,
 					      &alloc_hint);
-	if (!ret) {
+	if (!ret)
 		dcs = BTRFS_DC_SETUP;
-		btrfs_free_reserved_data_space(inode, num_pages);
-	} else {
-		btrfs_delalloc_release_space(inode, num_pages);
-	}
+	btrfs_free_reserved_data_space(inode, num_pages);
 
 out_put:
 	iput(inode);
@@ -2776,6 +2780,8 @@ out_free:
 	btrfs_release_path(path);
 out:
 	spin_lock(&block_group->lock);
+	if (!ret)
+		block_group->cache_generation = trans->transid;
 	block_group->disk_cache_state = dcs;
 	spin_unlock(&block_group->lock);
 
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index abc924c..39463eb 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -99,9 +99,11 @@ struct inode *lookup_free_space_inode(struct btrfs_root *root,
 		return inode;
 
 	spin_lock(&block_group->lock);
-	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM) {
+	if (!(BTRFS_I(inode)->flags & (BTRFS_INODE_NODATASUM |
+				       BTRFS_INODE_NODATACOW))) {
 		printk(KERN_INFO "Old style space inode found, converting.\n");
-		BTRFS_I(inode)->flags &= ~BTRFS_INODE_NODATASUM;
+		BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM |
+			BTRFS_INODE_NODATACOW;
 		block_group->disk_cache_state = BTRFS_DC_CLEAR;
 	}
 
@@ -142,7 +144,8 @@ int __create_free_space_inode(struct btrfs_root *root,
 	btrfs_set_inode_gid(leaf, inode_item, 0);
 	btrfs_set_inode_mode(leaf, inode_item, S_IFREG | 0600);
 	btrfs_set_inode_flags(leaf, inode_item, BTRFS_INODE_NOCOMPRESS |
-			      BTRFS_INODE_PREALLOC);
+			      BTRFS_INODE_PREALLOC | BTRFS_INODE_NODATASUM |
+			      BTRFS_INODE_NODATACOW);
 	btrfs_set_inode_nlink(leaf, inode_item, 1);
 	btrfs_set_inode_transid(leaf, inode_item, trans->transid);
 	btrfs_set_inode_block_group(leaf, inode_item, offset);
@@ -339,26 +342,21 @@ static void io_ctl_set_generation(struct io_ctl *io_ctl, u64 generation)
 
 	io_ctl_map_page(io_ctl, 1);
 
-	/*
-	 * Skip the first 64bits to make sure theres a bogus crc for old
-	 * kernels
-	 */
-	io_ctl->cur += sizeof(u64);
+	/* Skip the csum areas */
+	io_ctl->cur += (sizeof(u32) * io_ctl->num_pages);
 
 	val = io_ctl->cur;
 	*val = cpu_to_le64(generation);
 	io_ctl->cur += sizeof(u64);
-	io_ctl->size -= sizeof(u64) * 2;
+	io_ctl->size -= sizeof(u64) + (sizeof(u32) * io_ctl->num_pages);
 }
 
 static int io_ctl_check_generation(struct io_ctl *io_ctl, u64 generation)
 {
 	u64 *gen;
 
-	io_ctl_map_page(io_ctl, 0);
-
-	/* Skip the bogus crc area */
-	io_ctl->cur += sizeof(u64);
+	/* Skip the crc area */
+	io_ctl->cur += sizeof(u32) * io_ctl->num_pages;
 	gen = io_ctl->cur;
 	if (le64_to_cpu(*gen) != generation) {
 		printk_ratelimited(KERN_ERR "btrfs: space cache generation "
@@ -368,7 +366,54 @@ static int io_ctl_check_generation(struct io_ctl *io_ctl, u64 generation)
 		return -EIO;
 	}
 	io_ctl->cur += sizeof(u64);
-	io_ctl->size -= sizeof(u64) * 2;
+	io_ctl->size -= sizeof(u64) + (sizeof(u32) * io_ctl->num_pages);
+	return 0;
+}
+
+static void io_ctl_set_crc(struct io_ctl *io_ctl, int index)
+{
+	u32 *tmp;
+	u32 crc = ~(u32)0;
+	unsigned offset = 0;
+
+	if (index == 0)
+		offset = sizeof(u32) * io_ctl->num_pages;;
+
+	crc = btrfs_csum_data(io_ctl->root, io_ctl->orig + offset, crc,
+			      PAGE_CACHE_SIZE - offset);
+	btrfs_csum_final(crc, (char *)&crc);
+	io_ctl_unmap_page(io_ctl);
+	tmp = kmap(io_ctl->pages[0]);
+	tmp += index;
+	*tmp = crc;
+	kunmap(io_ctl->pages[0]);
+}
+
+static int io_ctl_check_crc(struct io_ctl *io_ctl, int index)
+{
+	u32 *tmp, val;
+	u32 crc = ~(u32)0;
+	unsigned offset = 0;
+
+	if (index == 0)
+		offset = sizeof(u32) * io_ctl->num_pages;
+
+	tmp = kmap(io_ctl->pages[0]);
+	tmp += index;
+	val = *tmp;
+	kunmap(io_ctl->pages[0]);
+
+	io_ctl_map_page(io_ctl, 0);
+	crc = btrfs_csum_data(io_ctl->root, io_ctl->orig + offset, crc,
+			      PAGE_CACHE_SIZE - offset);
+	btrfs_csum_final(crc, (char *)&crc);
+	if (val != crc) {
+		printk_ratelimited(KERN_ERR "btrfs: csum mismatch on free "
+				   "space cache\n");
+		io_ctl_unmap_page(io_ctl);
+		return -EIO;
+	}
+
 	return 0;
 }
 
@@ -391,22 +436,7 @@ static int io_ctl_add_entry(struct io_ctl *io_ctl, u64 offset, u64 bytes,
 	if (io_ctl->size >= sizeof(struct btrfs_free_space_entry))
 		return 0;
 
-	/*
-	 * index == 1 means the current page is 0, we need to generate a bogus
-	 * crc for older kernels.
-	 */
-	if (io_ctl->index == 1) {
-		u32 *tmp;
-		u32 crc = ~(u32)0;
-
-		crc = btrfs_csum_data(io_ctl->root, io_ctl->orig + sizeof(u64),
-				      crc, PAGE_CACHE_SIZE - sizeof(u64));
-		btrfs_csum_final(crc, (char *)&crc);
-		crc++;
-		tmp = io_ctl->orig;
-		*tmp = crc;
-	}
-	io_ctl_unmap_page(io_ctl);
+	io_ctl_set_crc(io_ctl, io_ctl->index - 1);
 
 	/* No more pages to map */
 	if (io_ctl->index >= io_ctl->num_pages)
@@ -427,14 +457,14 @@ static int io_ctl_add_bitmap(struct io_ctl *io_ctl, void *bitmap)
 	 * map the next one if there is any left.
 	 */
 	if (io_ctl->cur != io_ctl->orig) {
-		io_ctl_unmap_page(io_ctl);
+		io_ctl_set_crc(io_ctl, io_ctl->index - 1);
 		if (io_ctl->index >= io_ctl->num_pages)
 			return -ENOSPC;
 		io_ctl_map_page(io_ctl, 0);
 	}
 
 	memcpy(io_ctl->cur, bitmap, PAGE_CACHE_SIZE);
-	io_ctl_unmap_page(io_ctl);
+	io_ctl_set_crc(io_ctl, io_ctl->index - 1);
 	if (io_ctl->index < io_ctl->num_pages)
 		io_ctl_map_page(io_ctl, 0);
 	return 0;
@@ -442,51 +472,60 @@ static int io_ctl_add_bitmap(struct io_ctl *io_ctl, void *bitmap)
 
 static void io_ctl_zero_remaining_pages(struct io_ctl *io_ctl)
 {
-	io_ctl_unmap_page(io_ctl);
+	/*
+	 * If we're not on the boundary we know we've modified the page and we
+	 * need to crc the page.
+	 */
+	if (io_ctl->cur != io_ctl->orig)
+		io_ctl_set_crc(io_ctl, io_ctl->index - 1);
+	else
+		io_ctl_unmap_page(io_ctl);
 
 	while (io_ctl->index < io_ctl->num_pages) {
 		io_ctl_map_page(io_ctl, 1);
-		io_ctl_unmap_page(io_ctl);
+		io_ctl_set_crc(io_ctl, io_ctl->index - 1);
 	}
 }
 
-static u8 io_ctl_read_entry(struct io_ctl *io_ctl,
-			    struct btrfs_free_space *entry)
+static int io_ctl_read_entry(struct io_ctl *io_ctl,
+			    struct btrfs_free_space *entry, u8 *type)
 {
 	struct btrfs_free_space_entry *e;
-	u8 type;
 
 	e = io_ctl->cur;
 	entry->offset = le64_to_cpu(e->offset);
 	entry->bytes = le64_to_cpu(e->bytes);
-	type = e->type;
+	*type = e->type;
 	io_ctl->cur += sizeof(struct btrfs_free_space_entry);
 	io_ctl->size -= sizeof(struct btrfs_free_space_entry);
 
 	if (io_ctl->size >= sizeof(struct btrfs_free_space_entry))
-		return type;
+		return 0;
 
 	io_ctl_unmap_page(io_ctl);
 
 	if (io_ctl->index >= io_ctl->num_pages)
-		return type;
+		return 0;
 
-	io_ctl_map_page(io_ctl, 0);
-	return type;
+	return io_ctl_check_crc(io_ctl, io_ctl->index);
 }
 
-static void io_ctl_read_bitmap(struct io_ctl *io_ctl,
-			       struct btrfs_free_space *entry)
+static int io_ctl_read_bitmap(struct io_ctl *io_ctl,
+			      struct btrfs_free_space *entry)
 {
-	BUG_ON(!io_ctl->cur);
-	if (io_ctl->cur != io_ctl->orig) {
+	int ret;
+
+	if (io_ctl->cur && io_ctl->cur != io_ctl->orig)
 		io_ctl_unmap_page(io_ctl);
-		io_ctl_map_page(io_ctl, 0);
-	}
+
+	ret = io_ctl_check_crc(io_ctl, io_ctl->index);
+	if (ret)
+		return ret;
+
 	memcpy(entry->bitmap, io_ctl->cur, PAGE_CACHE_SIZE);
 	io_ctl_unmap_page(io_ctl);
-	if (io_ctl->index < io_ctl->num_pages)
-		io_ctl_map_page(io_ctl, 0);
+
+	return 0;
 }
 
 int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
@@ -553,6 +592,10 @@ int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 	if (ret)
 		goto out;
 
+	ret = io_ctl_check_crc(&io_ctl, 0);
+	if (ret)
+		goto free_cache;
+
 	ret = io_ctl_check_generation(&io_ctl, generation);
 	if (ret)
 		goto free_cache;
@@ -563,7 +606,12 @@ int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 		if (!e)
 			goto free_cache;
 
-		type = io_ctl_read_entry(&io_ctl, e);
+		ret = io_ctl_read_entry(&io_ctl, e, &type);
+		if (ret) {
+			kmem_cache_free(btrfs_free_space_cachep, e);
+			goto free_cache;
+		}
+
 		if (!e->bytes) {
 			kmem_cache_free(btrfs_free_space_cachep, e);
 			goto free_cache;
@@ -611,7 +659,9 @@ int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 	 */
 	list_for_each_entry_safe(e, n, &bitmaps, list) {
 		list_del_init(&e->list);
-		io_ctl_read_bitmap(&io_ctl, e);
+		ret = io_ctl_read_bitmap(&io_ctl, e);
+		if (ret)
+			goto free_cache;
 	}
 
 	io_ctl_drop_pages(&io_ctl);
@@ -632,7 +682,7 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 	struct btrfs_root *root = fs_info->tree_root;
 	struct inode *inode;
 	struct btrfs_path *path;
-	int ret;
+	int ret = 0;
 	bool matched;
 	u64 used = btrfs_block_group_used(&block_group->item);
 
@@ -664,6 +714,14 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 		return 0;
 	}
 
+	/* We may have converted the inode and made the cache invalid. */
+	spin_lock(&block_group->lock);
+	if (block_group->disk_cache_state != BTRFS_DC_WRITTEN) {
+		spin_unlock(&block_group->lock);
+		goto out;
+	}
+	spin_unlock(&block_group->lock);
+
 	ret = __load_free_space_cache(fs_info->tree_root, inode, ctl,
 				      path, block_group->key.objectid);
 	btrfs_free_path(path);
@@ -864,8 +922,8 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
 	if (ret < 0) {
 		clear_extent_bit(&BTRFS_I(inode)->io_tree, 0, inode->i_size - 1,
-				 EXTENT_DIRTY | EXTENT_DELALLOC |
-				 EXTENT_DO_ACCOUNTING, 0, 0, NULL, GFP_NOFS);
+				 EXTENT_DIRTY | EXTENT_DELALLOC, 0, 0, NULL,
+				 GFP_NOFS);
 		goto out;
 	}
 	leaf = path->nodes[0];
@@ -878,9 +936,8 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 		    found_key.offset != offset) {
 			clear_extent_bit(&BTRFS_I(inode)->io_tree, 0,
 					 inode->i_size - 1,
-					 EXTENT_DIRTY | EXTENT_DELALLOC |
-					 EXTENT_DO_ACCOUNTING, 0, 0, NULL,
-					 GFP_NOFS);
+					 EXTENT_DIRTY | EXTENT_DELALLOC, 0, 0,
+					 NULL, GFP_NOFS);
 			btrfs_release_path(path);
 			goto out;
 		}
@@ -942,7 +999,6 @@ int btrfs_write_out_cache(struct btrfs_root *root,
 	ret = __btrfs_write_out_cache(root, inode, ctl, block_group, trans,
 				      path, block_group->key.objectid);
 	if (ret) {
-		btrfs_delalloc_release_metadata(inode, inode->i_size);
 		spin_lock(&block_group->lock);
 		block_group->disk_cache_state = BTRFS_DC_ERROR;
 		spin_unlock(&block_group->lock);
@@ -2735,7 +2791,6 @@ int btrfs_write_out_ino_cache(struct btrfs_root *root,
 
 	ret = __btrfs_write_out_cache(root, inode, ctl, NULL, trans, path, 0);
 	if (ret) {
-		btrfs_delalloc_release_metadata(inode, inode->i_size);
 #ifdef DEBUG
 		printk(KERN_ERR "btrfs: failed to write free ino cache "
 		       "for root %llu\n", root->root_key.objectid);
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index 53dcbdf..a3f3b42 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -465,16 +465,12 @@ again:
 	/* Just to make sure we have enough space */
 	prealloc += 8 * PAGE_CACHE_SIZE;
 
-	ret = btrfs_delalloc_reserve_space(inode, prealloc);
+	ret = btrfs_check_data_free_space(inode, prealloc);
 	if (ret)
 		goto out_put;
 
 	ret = btrfs_prealloc_file_range_trans(inode, trans, 0, 0, prealloc,
 					      prealloc, prealloc, &alloc_hint);
-	if (ret) {
-		btrfs_delalloc_release_space(inode, prealloc);
-		goto out_put;
-	}
 	btrfs_free_reserved_data_space(inode, prealloc);
 
 out_put:
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 595a807..27cd15a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1792,11 +1792,11 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 	}
 	ret = 0;
 out:
-	btrfs_delalloc_release_metadata(inode, ordered_extent->len);
 	if (nolock) {
 		if (trans)
 			btrfs_end_transaction_nolock(trans, root);
 	} else {
+		btrfs_delalloc_release_metadata(inode, ordered_extent->len);
 		if (trans)
 			btrfs_end_transaction(trans, root);
 	}
-- 
1.7.5.2

