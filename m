From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 4/4] Btrfs: add basic DIO read/write support V3
Date: Wed, 12 May 2010 16:40:53 -0400
Message-ID: <20100512204052.GD3597@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	akpm@linux-foundation.org, hch@infradead.org
To: linux-btrfs@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

V1->V2
-Use __blockdev_direct_IO instead of helper
-Use KM_IRQ0 for kmap instead of KM_USER0

V2->V3
-Update the submit function to work with my submit hook changes
-Add DIO write support

This provides basic DIO support for reads only.  It does not do any of the work
to recover from mismatching checksums, that will come later.  A few design
changes have been made from Jim's code (sorry Jim!)

1) Use the generic direct-io code.  Jim originally re-wrote all the generic DIO
code in order to account for all of BTRFS's oddities, but thanks to that work it
seems like the best bet is to just ignore compression and such and just opt to
fallback on buffered IO.

2) Fallback on buffered IO for compressed or inline extents.  Jim's code did
it's own buffering to make dio with compressed extents work.  Now we just
fallback onto normal buffered IO.

3) Lock the entire range during DIO.  I originally had it so we would lock the
extents as get_block was called, and then unlock them as the endio function was
called, which worked great, but if we ever had an error in the submit_io hook,
we could have locked an extent that would never be submitted for IO, so we
wouldn't be able to unlock it, so this solution fixed that problem and made it a
bit cleaner.

I've tested this with fsx and everything works great.  This patch depends on my
dio and filemap.c patches to work.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.h     |    7 +
 fs/btrfs/file-item.c |  258 +++++++++++++++++++++++++++++++-
 fs/btrfs/file.c      |   69 ++++++++-
 fs/btrfs/inode.c     |  414 +++++++++++++++++++++++++++++++++++++++++++++++---
 4 files changed, 716 insertions(+), 32 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 746a724..8f0c202 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2257,6 +2257,8 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
 		    struct btrfs_root *root, u64 bytenr, u64 len);
 int btrfs_lookup_bio_sums(struct btrfs_root *root, struct inode *inode,
 			  struct bio *bio, u32 *dst);
+int btrfs_lookup_bio_sums_dio(struct btrfs_root *root, struct inode *inode,
+			      struct bio *bio, u64 logical_offset, u32 *dst);
 int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
 			     u64 objectid, u64 pos,
@@ -2270,8 +2272,13 @@ int btrfs_lookup_file_extent(struct btrfs_trans_handle *trans,
 int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   struct btrfs_ordered_sum *sums);
+int btrfs_csum_file_blocks_dio(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *root, u64 disk_bytenr,
+			       u64 bytes, u32 *csums);
 int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
 		       struct bio *bio, u64 file_start, int contig);
+int btrfs_csum_one_bio_dio(struct btrfs_root *root, struct inode *inode,
+			   struct bio *bio, u32 *csums);
 int btrfs_csum_file_bytes(struct btrfs_root *root, struct inode *inode,
 			  u64 start, unsigned long len);
 struct btrfs_csum_item *btrfs_lookup_csum(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 54a2550..a3035f7 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -149,13 +149,14 @@ int btrfs_lookup_file_extent(struct btrfs_trans_handle *trans,
 }
 
 
-int btrfs_lookup_bio_sums(struct btrfs_root *root, struct inode *inode,
-			  struct bio *bio, u32 *dst)
+static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
+				   struct inode *inode, struct bio *bio,
+				   u64 logical_offset, u32 *dst, int dio)
 {
 	u32 sum;
 	struct bio_vec *bvec = bio->bi_io_vec;
 	int bio_index = 0;
-	u64 offset;
+	u64 offset = 0;
 	u64 item_start_offset = 0;
 	u64 item_last_offset = 0;
 	u64 disk_bytenr;
@@ -174,8 +175,11 @@ int btrfs_lookup_bio_sums(struct btrfs_root *root, struct inode *inode,
 	WARN_ON(bio->bi_vcnt <= 0);
 
 	disk_bytenr = (u64)bio->bi_sector << 9;
+	if (dio)
+		offset = logical_offset;
 	while (bio_index < bio->bi_vcnt) {
-		offset = page_offset(bvec->bv_page) + bvec->bv_offset;
+		if (!dio)
+			offset = page_offset(bvec->bv_page) + bvec->bv_offset;
 		ret = btrfs_find_ordered_sum(inode, offset, disk_bytenr, &sum);
 		if (ret == 0)
 			goto found;
@@ -238,6 +242,7 @@ found:
 		else
 			set_state_private(io_tree, offset, sum);
 		disk_bytenr += bvec->bv_len;
+		offset += bvec->bv_len;
 		bio_index++;
 		bvec++;
 	}
@@ -245,6 +250,18 @@ found:
 	return 0;
 }
 
+int btrfs_lookup_bio_sums(struct btrfs_root *root, struct inode *inode,
+			  struct bio *bio, u32 *dst)
+{
+	return __btrfs_lookup_bio_sums(root, inode, bio, 0, dst, 0);
+}
+
+int btrfs_lookup_bio_sums_dio(struct btrfs_root *root, struct inode *inode,
+			      struct bio *bio, u64 offset, u32 *dst)
+{
+	return __btrfs_lookup_bio_sums(root, inode, bio, offset, dst, 1);
+}
+
 int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 			     struct list_head *list)
 {
@@ -435,6 +452,30 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
 	return 0;
 }
 
+int btrfs_csum_one_bio_dio(struct btrfs_root *root, struct inode *inode,
+			   struct bio *bio, u32 *csums)
+{
+	char *data;
+	struct bio_vec *bvec = bio->bi_io_vec;
+	int bio_index = 0;
+	u32 sum;
+
+	WARN_ON(bio->bi_vcnt <= 0);
+
+	while (bio_index < bio->bi_vcnt) {
+		data = kmap_atomic(bvec->bv_page, KM_USER0);
+		sum = ~(u32)0;
+		sum = btrfs_csum_data(root, data + bvec->bv_offset,
+					sum, bvec->bv_len);
+		kunmap_atomic(data, KM_USER0);
+		btrfs_csum_final(sum, (char *)&sum);
+
+		*csums++ = sum;
+		bio_index++;
+		bvec++;
+	}
+	return 0;
+}
 /*
  * helper function for csum removal, this expects the
  * key to describe the csum pointed to by the path, and it expects
@@ -833,3 +874,212 @@ out:
 fail_unlock:
 	goto out;
 }
+
+int btrfs_csum_file_blocks_dio(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *root, u64 disk_bytenr,
+			       u64 bytes, u32 *csums)
+{
+	u64 bytenr = disk_bytenr;
+	int ret;
+	struct btrfs_key file_key;
+	struct btrfs_key found_key;
+	u64 next_offset;
+	u64 total_bytes = 0;
+	int found_next;
+	struct btrfs_path *path;
+	struct btrfs_csum_item *item;
+	struct btrfs_csum_item *item_end;
+	struct extent_buffer *leaf = NULL;
+	u64 csum_offset;
+	u32 *csum = csums;
+	u32 nritems;
+	u32 ins_size;
+	char *eb_map;
+	char *eb_token;
+	unsigned long map_len;
+	unsigned long map_start;
+	u16 csum_size =
+		btrfs_super_csum_size(&root->fs_info->super_copy);
+
+	path = btrfs_alloc_path();
+	BUG_ON(!path);
+again:
+	next_offset = (u64)-1;
+	found_next = 0;
+	file_key.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
+	file_key.offset = bytenr;
+	btrfs_set_key_type(&file_key, BTRFS_EXTENT_CSUM_KEY);
+
+	item = btrfs_lookup_csum(trans, root, path, bytenr, 1);
+	if (!IS_ERR(item)) {
+		leaf = path->nodes[0];
+		ret = 0;
+		goto found;
+	}
+	ret = PTR_ERR(item);
+	if (ret == -EFBIG) {
+		u32 item_size;
+
+		/* we found one, but it isn't big enough yet */
+		leaf = path->nodes[0];
+		item_size = btrfs_item_size_nr(leaf, path->slots[0]);
+		if ((item_size / csum_size) >=
+		    MAX_CSUM_ITEMS(root, csum_size)) {
+			/* already at max size, make a new one */
+			goto insert;
+		}
+	} else {
+		int slot = path->slots[0] + 1;
+
+		/* we didn't find a csum item, insert one */
+		nritems = btrfs_header_nritems(path->nodes[0]);
+		if (path->slots[0] >= nritems - 1) {
+			ret = btrfs_next_leaf(root, path);
+			if (ret == 1)
+				found_next = 1;
+			if (ret != 0)
+				goto insert;
+			slot = 0;
+		}
+		btrfs_item_key_to_cpu(path->nodes[0], &found_key, slot);
+		if (found_key.objectid != BTRFS_EXTENT_CSUM_OBJECTID ||
+		    found_key.type != BTRFS_EXTENT_CSUM_KEY) {
+			found_next = 1;
+			goto insert;
+		}
+		next_offset = found_key.offset;
+		found_next = 1;
+		goto insert;
+	}
+
+	/*
+	 * at this point, we know the tree has an item, but it isn't big
+	 * enough yet to put our csum in.  Grow it
+	 */
+	btrfs_release_path(root, path);
+	ret = btrfs_search_slot(trans, root, &file_key, path,
+				csum_size, 1);
+	if (ret < 0)
+		goto fail_unlock;
+
+	if (ret > 0) {
+		if (path->slots[0] == 0)
+			goto insert;
+		path->slots[0]--;
+	}
+
+	leaf = path->nodes[0];
+	btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
+	csum_offset = (bytenr - found_key.offset) >>
+			root->fs_info->sb->s_blocksize_bits;
+
+	if (btrfs_key_type(&found_key) != BTRFS_EXTENT_CSUM_KEY ||
+	    found_key.objectid != BTRFS_EXTENT_CSUM_OBJECTID ||
+	    csum_offset >= MAX_CSUM_ITEMS(root, csum_size)) {
+		goto insert;
+	}
+
+	if (csum_offset >= btrfs_item_size_nr(leaf, path->slots[0]) /
+	    csum_size) {
+		u32 diff = (csum_offset + 1) * csum_size;
+
+		/*
+		 * is the item big enough already?  we dropped our lock
+		 * before and need to recheck
+		 */
+		if (diff < btrfs_item_size_nr(leaf, path->slots[0]))
+			goto csum;
+
+		diff = diff - btrfs_item_size_nr(leaf, path->slots[0]);
+		if (diff != csum_size)
+			goto insert;
+
+		ret = btrfs_extend_item(trans, root, path, diff);
+		BUG_ON(ret);
+		goto csum;
+	}
+
+insert:
+	btrfs_release_path(root, path);
+	csum_offset = 0;
+	if (found_next) {
+		u64 tmp = (bytes - total_bytes);
+
+		tmp >>= root->fs_info->sb->s_blocksize_bits;
+		tmp = max((u64)1, tmp);
+		tmp = min(tmp, (u64)MAX_CSUM_ITEMS(root, csum_size));
+		ins_size = csum_size * tmp;
+	} else {
+		ins_size = csum_size;
+	}
+	path->leave_spinning = 1;
+	ret = btrfs_insert_empty_item(trans, root, path, &file_key,
+				      ins_size);
+	path->leave_spinning = 0;
+	if (ret < 0)
+		goto fail_unlock;
+	if (ret != 0) {
+		WARN_ON(1);
+		goto fail_unlock;
+	}
+csum:
+	leaf = path->nodes[0];
+	item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_csum_item);
+	ret = 0;
+	item = (struct btrfs_csum_item *)((unsigned char *)item +
+					  csum_offset * csum_size);
+found:
+	item_end = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_csum_item);
+	item_end = (struct btrfs_csum_item *)((unsigned char *)item_end +
+				      btrfs_item_size_nr(leaf, path->slots[0]));
+	eb_token = NULL;
+next_sector:
+
+	if (!eb_token ||
+	   (unsigned long)item + csum_size >= map_start + map_len) {
+		int err;
+
+		if (eb_token)
+			unmap_extent_buffer(leaf, eb_token, KM_USER1);
+		eb_token = NULL;
+		err = map_private_extent_buffer(leaf, (unsigned long)item,
+						csum_size,
+						&eb_token, &eb_map,
+						&map_start, &map_len, KM_USER1);
+		if (err)
+			eb_token = NULL;
+	}
+	if (eb_token) {
+		memcpy(eb_token + ((unsigned long)item & (PAGE_CACHE_SIZE - 1)),
+		       csum, csum_size);
+	} else {
+		write_extent_buffer(leaf, csum, (unsigned long)item,
+				    csum_size);
+	}
+
+	total_bytes += root->sectorsize;
+	bytenr += root->sectorsize;
+	csum++;
+	if (total_bytes < bytes) {
+		item = (struct btrfs_csum_item *)((char *)item +
+						  csum_size);
+		if (item < item_end)
+			goto next_sector;
+	}
+	if (eb_token) {
+		unmap_extent_buffer(leaf, eb_token, KM_USER1);
+		eb_token = NULL;
+	}
+	btrfs_mark_buffer_dirty(path->nodes[0]);
+	if (total_bytes < bytes) {
+		btrfs_release_path(root, path);
+		cond_resched();
+		goto again;
+	}
+out:
+	btrfs_free_path(path);
+	return ret;
+
+fail_unlock:
+	goto out;
+}
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 29ff749..dace07b 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -823,6 +823,47 @@ again:
 	return 0;
 }
 
+/* Copied from read-write.c */
+static void wait_on_retry_sync_kiocb(struct kiocb *iocb)
+{
+	set_current_state(TASK_UNINTERRUPTIBLE);
+	if (!kiocbIsKicked(iocb))
+		schedule();
+	else
+		kiocbClearKicked(iocb);
+	__set_current_state(TASK_RUNNING);
+}
+
+/*
+ * Just a copy of what do_sync_write does.
+ */
+static ssize_t __btrfs_direct_write(struct file *file, const char __user *buf,
+				    size_t count, loff_t pos, loff_t *ppos)
+{
+	struct iovec iov = { .iov_base = (void __user *)buf, .iov_len = count };
+	unsigned long nr_segs = 1;
+	struct kiocb kiocb;
+	ssize_t ret;
+
+	init_sync_kiocb(&kiocb, file);
+	kiocb.ki_pos = pos;
+	kiocb.ki_left = count;
+	kiocb.ki_nbytes = count;
+
+	while (1) {
+		ret = generic_file_direct_write(&kiocb, &iov, &nr_segs, pos,
+						ppos, count, count);
+		if (ret != -EIOCBRETRY)
+			break;
+		wait_on_retry_sync_kiocb(&kiocb);
+	}
+
+	if (ret == -EIOCBQUEUED)
+		ret = wait_on_sync_kiocb(&kiocb);
+	*ppos = kiocb.ki_pos;
+	return ret;
+}
+
 static ssize_t btrfs_file_write(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos)
 {
@@ -839,12 +880,11 @@ static ssize_t btrfs_file_write(struct file *file, const char __user *buf,
 	unsigned long first_index;
 	unsigned long last_index;
 	int will_write;
+	int buffered = 0;
 
 	will_write = ((file->f_flags & O_DSYNC) || IS_SYNC(inode) ||
 		      (file->f_flags & O_DIRECT));
 
-	nrptrs = min((count + PAGE_CACHE_SIZE - 1) / PAGE_CACHE_SIZE,
-		     PAGE_CACHE_SIZE / (sizeof(struct page *)));
 	pinned[0] = NULL;
 	pinned[1] = NULL;
 
@@ -875,13 +915,34 @@ static ssize_t btrfs_file_write(struct file *file, const char __user *buf,
 		goto out;
 
 	file_update_time(file);
+	BTRFS_I(inode)->sequence++;
+
+	if (unlikely(file->f_flags & O_DIRECT)) {
+		num_written = __btrfs_direct_write(file, buf, count, pos,
+						   ppos);
+		pos += num_written;
+		count -= num_written;
+
+		/* We've written everything we wanted to, exit */
+		if (num_written < 0 || !count)
+			goto out;
 
+		/*
+		 * We are going to do buffered for the rest of the range, so we
+		 * need to make sure to invalidate the buffered pages when we're
+		 * done.
+		 */
+		buffered = 1;
+		buf += num_written;
+	}
+
+	nrptrs = min((count + PAGE_CACHE_SIZE - 1) / PAGE_CACHE_SIZE,
+		     PAGE_CACHE_SIZE / (sizeof(struct page *)));
 	pages = kmalloc(nrptrs * sizeof(struct page *), GFP_KERNEL);
 
 	/* generic_write_checks can change our pos */
 	start_pos = pos;
 
-	BTRFS_I(inode)->sequence++;
 	first_index = pos >> PAGE_CACHE_SHIFT;
 	last_index = (pos + count) >> PAGE_CACHE_SHIFT;
 
@@ -1023,7 +1084,7 @@ out_nolock:
 				btrfs_end_transaction(trans, root);
 			}
 		}
-		if (file->f_flags & O_DIRECT) {
+		if (file->f_flags & O_DIRECT && buffered) {
 			invalidate_mapping_pages(inode->i_mapping,
 			      start_pos >> PAGE_CACHE_SHIFT,
 			     (start_pos + num_written - 1) >> PAGE_CACHE_SHIFT);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2bfdc64..daeed60 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -697,6 +697,38 @@ retry:
 	return 0;
 }
 
+static u64 get_extent_allocation_hint(struct inode *inode, u64 start,
+				      u64 num_bytes)
+{
+	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
+	struct extent_map *em;
+	u64 alloc_hint = 0;
+
+	read_lock(&em_tree->lock);
+	em = search_extent_mapping(em_tree, start, num_bytes);
+	if (em) {
+		/*
+		 * if block start isn't an actual block number then find the
+		 * first block in this inode and use that as a hint.  If that
+		 * block is also bogus then just don't worry about it.
+		 */
+		if (em->block_start >= EXTENT_MAP_LAST_BYTE) {
+			free_extent_map(em);
+			em = search_extent_mapping(em_tree, 0, 0);
+			if (em && em->block_start < EXTENT_MAP_LAST_BYTE)
+				alloc_hint = em->block_start;
+			if (em)
+				free_extent_map(em);
+		} else {
+			alloc_hint = em->block_start;
+			free_extent_map(em);
+		}
+	}
+	read_unlock(&em_tree->lock);
+
+	return alloc_hint;
+}
+
 /*
  * when extent_io.c finds a delayed allocation range in the file,
  * the call backs end up in this code.  The basic idea is to
@@ -769,29 +801,7 @@ static noinline int cow_file_range(struct inode *inode,
 	BUG_ON(disk_num_bytes >
 	       btrfs_super_total_bytes(&root->fs_info->super_copy));
 
-
-	read_lock(&BTRFS_I(inode)->extent_tree.lock);
-	em = search_extent_mapping(&BTRFS_I(inode)->extent_tree,
-				   start, num_bytes);
-	if (em) {
-		/*
-		 * if block start isn't an actual block number then find the
-		 * first block in this inode and use that as a hint.  If that
-		 * block is also bogus then just don't worry about it.
-		 */
-		if (em->block_start >= EXTENT_MAP_LAST_BYTE) {
-			free_extent_map(em);
-			em = search_extent_mapping(em_tree, 0, 0);
-			if (em && em->block_start < EXTENT_MAP_LAST_BYTE)
-				alloc_hint = em->block_start;
-			if (em)
-				free_extent_map(em);
-		} else {
-			alloc_hint = em->block_start;
-			free_extent_map(em);
-		}
-	}
-	read_unlock(&BTRFS_I(inode)->extent_tree.lock);
+	alloc_hint = get_extent_allocation_hint(inode, start, num_bytes);
 	btrfs_drop_extent_cache(inode, start, start + num_bytes - 1, 0);
 
 	while (disk_num_bytes > 0) {
@@ -4875,11 +4885,367 @@ out:
 	return em;
 }
 
+static struct extent_map *btrfs_new_extent_direct(struct inode *inode,
+						  u64 start, u64 len)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_trans_handle *trans;
+	struct extent_map *em;
+	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
+	struct btrfs_key ins;
+	u64 alloc_hint;
+	int ret;
+
+	btrfs_drop_extent_cache(inode, start, start + len - 1, 0);
+
+	trans = btrfs_start_transaction(root, 1);
+	if (!trans)
+		return ERR_PTR(-ENOMEM);
+
+	alloc_hint = get_extent_allocation_hint(inode, start, len);
+	ret = btrfs_reserve_extent(trans, root, len, root->sectorsize, 0,
+				   alloc_hint, (u64)-1, &ins, 1);
+	if (ret) {
+		em = ERR_PTR(ret);
+		goto out;
+	}
+
+	em = alloc_extent_map(GFP_NOFS);
+	if (!em) {
+		em = ERR_PTR(-ENOMEM);
+		goto out;
+	}
+
+	em->start = start;
+	em->orig_start = em->start;
+	em->len = ins.offset;
+
+	em->block_start = ins.objectid;
+	em->block_len = ins.offset;
+	em->bdev = root->fs_info->fs_devices->latest_bdev;
+	set_bit(EXTENT_FLAG_PINNED, &em->flags);
+
+	while (1) {
+		write_lock(&em_tree->lock);
+		ret = add_extent_mapping(em_tree, em);
+		write_unlock(&em_tree->lock);
+		if (ret != -EEXIST)
+			break;
+		btrfs_drop_extent_cache(inode, start, start + em->len - 1, 0);
+	}
+
+out:
+	btrfs_end_transaction(trans, root);
+	return em;
+}
+
+static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
+				   struct buffer_head *bh_result, int create)
+{
+	struct extent_map *em;
+	u64 start = iblock << inode->i_blkbits;
+	u64 len = bh_result->b_size;
+
+	em = btrfs_get_extent(inode, NULL, 0, start, len, 0);
+	if (IS_ERR(em))
+		return PTR_ERR(em);
+
+	/*
+	 * Ok for INLINE and COMPRESSED extents we need to fallback on buffered
+	 * io.  INLINE is special, and we could probably kludge it in here, but
+	 * it's still buffered so for safety lets just fall back to the generic
+	 * buffered path.
+	 *
+	 * For COMPRESSED we _have_ to read the entire extent in so we can
+	 * decompress it, so there will be buffering required no matter what we
+	 * do, so go ahead and fallback to buffered.
+	 *
+	 * We return -ENOTBLK because thats what makes DIO go ahead and go back
+	 * to buffered IO.  Don't blame me, this is the price we pay for using
+	 * the generic code.
+	 */
+	if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags) ||
+	    em->block_start == EXTENT_MAP_INLINE) {
+		free_extent_map(em);
+		return -ENOTBLK;
+	}
+
+	/* Just a good old fashioned hole, return */
+	if (!create && (em->block_start == EXTENT_MAP_HOLE ||
+			test_bit(EXTENT_FLAG_PREALLOC, &em->flags))) {
+		free_extent_map(em);
+		return 0;
+	}
+
+	/*
+	 * We don't allocate a new extent in the following cases
+	 *
+	 * 1) The inode is marked as NODATACOW.  In this case we'll just use the
+	 * existing extent.
+	 * 2) The extent is marked as PREALLOC.  We're good to go here and can
+	 * just use the extent.
+	 *
+	 */
+	if (create &&
+	    (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW) ||
+	     !test_bit(EXTENT_FLAG_PREALLOC, &em->flags))) {
+		free_extent_map(em);
+		em = btrfs_new_extent_direct(inode, start, len);
+		if (IS_ERR(em))
+			return PTR_ERR(em);
+	}
+
+	bh_result->b_blocknr = (em->block_start + (start - em->start)) >>
+		inode->i_blkbits;
+	bh_result->b_size = em->len - (start - em->start);
+	bh_result->b_bdev = em->bdev;
+	set_buffer_mapped(bh_result);
+	if (create && !test_bit(EXTENT_FLAG_PREALLOC, &em->flags))
+		set_buffer_new(bh_result);
+
+	free_extent_map(em);
+
+	return 0;
+}
+
+struct btrfs_dio_private {
+	struct inode *inode;
+	u64 logical_offset;
+	u64 disk_bytenr;
+	u64 bytes;
+	u32 *csums;
+	void *private;
+	bool prealloc;
+};
+
+static void btrfs_endio_direct_read(struct bio *bio, int err)
+{
+	struct bio_vec *bvec_end = bio->bi_io_vec + bio->bi_vcnt - 1;
+	struct bio_vec *bvec = bio->bi_io_vec;
+	struct btrfs_dio_private *dip = bio->bi_private;
+	struct inode *inode = dip->inode;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	u64 start;
+	u32 *private = dip->csums;
+
+	start = dip->logical_offset;
+	do {
+		if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)) {
+			struct page *page = bvec->bv_page;
+			char *kaddr;
+			u32 csum = ~(u32)0;
+
+			kaddr = kmap_atomic(page, KM_IRQ0);
+			csum = btrfs_csum_data(root, kaddr + bvec->bv_offset,
+					       csum, bvec->bv_len);
+			btrfs_csum_final(csum, (char *)&csum);
+			kunmap_atomic(kaddr, KM_IRQ0);
+
+			if (csum != *private) {
+				printk(KERN_ERR "btrfs csum failed ino %lu off"
+				      " %llu csum %u private %u\n",
+				      inode->i_ino, (unsigned long long)start,
+				      csum, *private);
+				err = -EIO;
+			}
+		}
+
+		start += bvec->bv_len;
+		private++;
+		bvec++;
+	} while (bvec <= bvec_end);
+
+	bio->bi_private = dip->private;
+
+	kfree(dip->csums);
+	kfree(dip);
+	dio_end_io(bio, err);
+}
+
+static void btrfs_endio_direct_write(struct bio *bio, int err)
+{
+	struct btrfs_dio_private *dip = bio->bi_private;
+	struct inode *inode = dip->inode;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_trans_handle *trans;
+	u32 *csums = dip->csums;
+	int ret;
+
+	if (err)
+		goto out;
+
+	trans = btrfs_join_transaction(root, 1);
+	if (!trans) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	if (dip->prealloc) {
+		ret = btrfs_mark_extent_written(trans, inode,
+						dip->logical_offset,
+						dip->logical_offset +
+						dip->bytes);
+		if (ret) {
+			err = ret;
+			btrfs_end_transaction(trans, root);
+			goto out;
+		}
+	} else {
+		ret = insert_reserved_file_extent(trans, inode,
+						  dip->logical_offset,
+						  dip->disk_bytenr,
+						  dip->bytes,
+						  dip->bytes,
+						  dip->bytes,
+						  0, 0, 0,
+						  BTRFS_FILE_EXTENT_REG);
+		unpin_extent_cache(&BTRFS_I(inode)->extent_tree,
+				   dip->logical_offset, dip->bytes);
+		if (ret) {
+			err = ret;
+			btrfs_end_transaction(trans, root);
+			goto out;
+		}
+	}
+
+	ret = btrfs_csum_file_blocks_dio(trans, root->fs_info->csum_root,
+					 dip->disk_bytenr, dip->bytes,
+					 csums);
+	BUG_ON(ret);
+
+	if (dip->logical_offset + dip->bytes > i_size_read(inode)) {
+		i_size_write(inode, dip->logical_offset + dip->bytes);
+		BTRFS_I(inode)->disk_i_size = i_size_read(inode);
+		mark_inode_dirty(inode);
+	}
+
+	btrfs_end_transaction(trans, root);
+out:
+	bio->bi_private = dip->private;
+
+	kfree(dip->csums);
+	kfree(dip);
+	dio_end_io(bio, err);
+}
+
+static void btrfs_submit_direct(int rw, struct bio *bio, struct inode *inode,
+				loff_t file_offset)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct extent_map *em;
+	struct btrfs_dio_private *dip;
+	struct bio_vec *bvec = bio->bi_io_vec;
+	u64 start;
+	int skip_sum;
+	int write = rw & (1 << BIO_RW);
+	int ret = 0;
+
+	skip_sum = BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM;
+
+	dip = kmalloc(sizeof(*dip), GFP_NOFS);
+	if (!dip) {
+		bio_endio(bio, -ENOMEM);
+		return;
+	}
+	dip->csums = NULL;
+
+	if (!skip_sum) {
+		dip->csums = kmalloc(sizeof(u32) * bio->bi_vcnt, GFP_NOFS);
+		if (!dip->csums) {
+			kfree(dip);
+			bio_endio(bio, -ENOMEM);
+		}
+	}
+
+	dip->private = bio->bi_private;
+	dip->inode = inode;
+	dip->logical_offset = file_offset;
+
+	start = dip->logical_offset;
+	em = btrfs_get_extent(inode, NULL, 0, start, bvec->bv_len, 0);
+	if (IS_ERR(em)) {
+		ret = PTR_ERR(em);
+		goto out_err;
+	}
+
+	dip->prealloc = test_bit(EXTENT_FLAG_PREALLOC, &em->flags);
+	if (em->block_start >= EXTENT_MAP_LAST_BYTE) {
+		printk(KERN_ERR "dio to inode resulted in a bad extent "
+		       "(%llu) %llu\n", (unsigned long long)em->block_start,
+		       (unsigned long long)start);
+		ret = -EIO;
+		free_extent_map(em);
+		goto out_err;
+	}
+	free_extent_map(em);
+
+	dip->bytes = 0;
+	do {
+		dip->bytes += bvec->bv_len;
+		bvec++;
+	} while (bvec <= (bio->bi_io_vec + bio->bi_vcnt - 1));
+
+	dip->disk_bytenr = bio->bi_sector << 9;
+	bio->bi_private = dip;
+
+	if (write)
+		bio->bi_end_io = btrfs_endio_direct_write;
+	else
+		bio->bi_end_io = btrfs_endio_direct_read;
+
+	ret = btrfs_bio_wq_end_io(root->fs_info, bio, 0);
+	if (ret)
+		goto out_err;
+
+	if (write && !skip_sum)
+		btrfs_csum_one_bio_dio(root, inode, bio, dip->csums);
+	else if (!skip_sum)
+		btrfs_lookup_bio_sums_dio(root, inode, bio,
+					  dip->logical_offset, dip->csums);
+
+	ret = btrfs_map_bio(root, rw, bio, 0, 0);
+	if (ret)
+		goto out_err;
+	return;
+out_err:
+	kfree(dip->csums);
+	kfree(dip);
+	bio_endio(bio, ret);
+}
+
 static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 			const struct iovec *iov, loff_t offset,
 			unsigned long nr_segs)
 {
-	return -EINVAL;
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file->f_mapping->host;
+	struct extent_state *cached_state = NULL;
+	struct btrfs_ordered_extent *ordered;
+	ssize_t ret;
+
+	while (1) {
+		lock_extent_bits(&BTRFS_I(inode)->io_tree, offset,
+				 offset + iov_length(iov, nr_segs) - 1, 0,
+				 &cached_state, GFP_NOFS);
+		ordered = btrfs_lookup_ordered_extent(inode, offset);
+		if (!ordered)
+			break;
+		unlock_extent_cached(&BTRFS_I(inode)->io_tree, offset,
+				     offset + iov_length(iov, nr_segs) - 1,
+				     &cached_state, GFP_NOFS);
+		btrfs_start_ordered_extent(inode, ordered, 1);
+		btrfs_put_ordered_extent(ordered);
+		cond_resched();
+	}
+
+	ret = __blockdev_direct_IO(rw, iocb, inode, NULL, iov, offset, nr_segs,
+				   btrfs_get_blocks_direct, NULL,
+				   btrfs_submit_direct, 0);
+
+	unlock_extent_cached(&BTRFS_I(inode)->io_tree, offset,
+			     offset + iov_length(iov, nr_segs) - 1,
+			     &cached_state, GFP_NOFS);
+	return ret;
 }
 
 static int btrfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
-- 
1.6.6.1

