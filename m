Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:63568 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752461Ab3EFKQF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 May 2013 06:16:05 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r46AG4bl021246
	for <linux-btrfs@vger.kernel.org>; Mon, 6 May 2013 18:16:04 +0800
Message-ID: <51878334.4000807@cn.fujitsu.com>
Date: Mon, 06 May 2013 18:17:24 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V3] Btrfs: remove btrfs_sector_sum structure
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Using the structure btrfs_sector_sum to keep the checksum value is
unnecessary, because the extents that btrfs_sector_sum points to are
continuous, we can find out the expected checksums by btrfs_ordered_sum's
bytenr and the offset, so we can remove btrfs_sector_sum's bytenr. After
removing bytenr, there is only one member in the structure, so it makes
no sense to keep the structure, just remove it, and use a u32 array to
store the checksum value.

By this change, we don't use the while loop to get the checksums one by
one. Now, we can get several checksum value at one time, it improved the
performance by ~74% on my SSD (31MB/s -> 54MB/s).

test command:
 # dd if=/dev/zero of=/mnt/btrfs/file0 bs=1M count=1024 oflag=sync

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v2 -> v3:
- address the problem that the csums was inserted into the wrong range, this bug
  was reported by Josef.

Changelog v1 -> v2:
- modify the changelog and the title which can not explain this patch clearly
- fix the 64bit division problem on 32bit machine
---
 fs/btrfs/file-item.c    | 144 ++++++++++++++++++------------------------------
 fs/btrfs/ordered-data.c |  19 +++----
 fs/btrfs/ordered-data.h |  25 ++-------
 fs/btrfs/relocation.c   |  10 ----
 fs/btrfs/scrub.c        |  16 ++----
 5 files changed, 73 insertions(+), 141 deletions(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index b193bf3..a7bfc95 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -34,8 +34,7 @@
 
 #define MAX_ORDERED_SUM_BYTES(r) ((PAGE_SIZE - \
 				   sizeof(struct btrfs_ordered_sum)) / \
-				   sizeof(struct btrfs_sector_sum) * \
-				   (r)->sectorsize - (r)->sectorsize)
+				   sizeof(u32) * (r)->sectorsize)
 
 int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
@@ -297,7 +296,6 @@ int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
 	struct btrfs_ordered_sum *sums;
-	struct btrfs_sector_sum *sector_sum;
 	struct btrfs_csum_item *item;
 	LIST_HEAD(tmplist);
 	unsigned long offset;
@@ -368,34 +366,28 @@ int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 				      struct btrfs_csum_item);
 		while (start < csum_end) {
 			size = min_t(size_t, csum_end - start,
-					MAX_ORDERED_SUM_BYTES(root));
+				     MAX_ORDERED_SUM_BYTES(root));
 			sums = kzalloc(btrfs_ordered_sum_size(root, size),
-					GFP_NOFS);
+				       GFP_NOFS);
 			if (!sums) {
 				ret = -ENOMEM;
 				goto fail;
 			}
 
-			sector_sum = sums->sums;
 			sums->bytenr = start;
-			sums->len = size;
+			sums->len = (int)size;
 
 			offset = (start - key.offset) >>
 				root->fs_info->sb->s_blocksize_bits;
 			offset *= csum_size;
+			size >>= root->fs_info->sb->s_blocksize_bits;
 
-			while (size > 0) {
-				read_extent_buffer(path->nodes[0],
-						&sector_sum->sum,
-						((unsigned long)item) +
-						offset, csum_size);
-				sector_sum->bytenr = start;
-
-				size -= root->sectorsize;
-				start += root->sectorsize;
-				offset += csum_size;
-				sector_sum++;
-			}
+			read_extent_buffer(path->nodes[0],
+					   sums->sums,
+					   ((unsigned long)item) + offset,
+					   csum_size * size);
+
+			start += root->sectorsize * size;
 			list_add_tail(&sums->list, &tmplist);
 		}
 		path->slots[0]++;
@@ -417,23 +409,20 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
 		       struct bio *bio, u64 file_start, int contig)
 {
 	struct btrfs_ordered_sum *sums;
-	struct btrfs_sector_sum *sector_sum;
 	struct btrfs_ordered_extent *ordered;
 	char *data;
 	struct bio_vec *bvec = bio->bi_io_vec;
 	int bio_index = 0;
+	int index;
 	unsigned long total_bytes = 0;
 	unsigned long this_sum_bytes = 0;
 	u64 offset;
-	u64 disk_bytenr;
 
 	WARN_ON(bio->bi_vcnt <= 0);
 	sums = kzalloc(btrfs_ordered_sum_size(root, bio->bi_size), GFP_NOFS);
 	if (!sums)
 		return -ENOMEM;
 
-	sector_sum = sums->sums;
-	disk_bytenr = (u64)bio->bi_sector << 9;
 	sums->len = bio->bi_size;
 	INIT_LIST_HEAD(&sums->list);
 
@@ -444,7 +433,8 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
 
 	ordered = btrfs_lookup_ordered_extent(inode, offset);
 	BUG_ON(!ordered); /* Logic error */
-	sums->bytenr = ordered->start;
+	sums->bytenr = (u64)bio->bi_sector << 9;
+	index = 0;
 
 	while (bio_index < bio->bi_vcnt) {
 		if (!contig)
@@ -463,28 +453,27 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
 			sums = kzalloc(btrfs_ordered_sum_size(root, bytes_left),
 				       GFP_NOFS);
 			BUG_ON(!sums); /* -ENOMEM */
-			sector_sum = sums->sums;
 			sums->len = bytes_left;
 			ordered = btrfs_lookup_ordered_extent(inode, offset);
 			BUG_ON(!ordered); /* Logic error */
-			sums->bytenr = ordered->start;
+			sums->bytenr = ((u64)bio->bi_sector << 9) +
+				       total_bytes;
+			index = 0;
 		}
 
 		data = kmap_atomic(bvec->bv_page);
-		sector_sum->sum = ~(u32)0;
-		sector_sum->sum = btrfs_csum_data(data + bvec->bv_offset,
-						  sector_sum->sum,
-						  bvec->bv_len);
+		sums->sums[index] = ~(u32)0;
+		sums->sums[index] = btrfs_csum_data(data + bvec->bv_offset,
+						    sums->sums[index],
+						    bvec->bv_len);
 		kunmap_atomic(data);
-		btrfs_csum_final(sector_sum->sum,
-				 (char *)&sector_sum->sum);
-		sector_sum->bytenr = disk_bytenr;
+		btrfs_csum_final(sums->sums[index],
+				 (char *)(sums->sums + index));
 
-		sector_sum++;
 		bio_index++;
+		index++;
 		total_bytes += bvec->bv_len;
 		this_sum_bytes += bvec->bv_len;
-		disk_bytenr += bvec->bv_len;
 		offset += bvec->bv_len;
 		bvec++;
 	}
@@ -672,62 +661,46 @@ out:
 	return ret;
 }
 
-static u64 btrfs_sector_sum_left(struct btrfs_ordered_sum *sums,
-				 struct btrfs_sector_sum *sector_sum,
-				 u64 total_bytes, u64 sectorsize)
-{
-	u64 tmp = sectorsize;
-	u64 next_sector = sector_sum->bytenr;
-	struct btrfs_sector_sum *next = sector_sum + 1;
-
-	while ((tmp + total_bytes) < sums->len) {
-		if (next_sector + sectorsize != next->bytenr)
-			break;
-		tmp += sectorsize;
-		next_sector = next->bytenr;
-		next++;
-	}
-	return tmp;
-}
-
 int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   struct btrfs_ordered_sum *sums)
 {
-	u64 bytenr;
-	int ret;
 	struct btrfs_key file_key;
 	struct btrfs_key found_key;
-	u64 next_offset;
-	u64 total_bytes = 0;
-	int found_next;
 	struct btrfs_path *path;
 	struct btrfs_csum_item *item;
 	struct btrfs_csum_item *item_end;
 	struct extent_buffer *leaf = NULL;
+	u64 next_offset;
+	u64 total_bytes = 0;
 	u64 csum_offset;
-	struct btrfs_sector_sum *sector_sum;
+	u64 bytenr;
 	u32 nritems;
 	u32 ins_size;
+	int index = 0;
+	int found_next;
+	int ret;
 	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
 
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
-
-	sector_sum = sums->sums;
 again:
 	next_offset = (u64)-1;
 	found_next = 0;
+	bytenr = sums->bytenr + total_bytes;
 	file_key.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
-	file_key.offset = sector_sum->bytenr;
-	bytenr = sector_sum->bytenr;
+	file_key.offset = bytenr;
 	btrfs_set_key_type(&file_key, BTRFS_EXTENT_CSUM_KEY);
 
-	item = btrfs_lookup_csum(trans, root, path, sector_sum->bytenr, 1);
+	item = btrfs_lookup_csum(trans, root, path, bytenr, 1);
 	if (!IS_ERR(item)) {
-		leaf = path->nodes[0];
 		ret = 0;
+		leaf = path->nodes[0];
+		item_end = btrfs_item_ptr(leaf, path->slots[0],
+					  struct btrfs_csum_item);
+		item_end = (struct btrfs_csum_item *)((char *)item_end +
+			   btrfs_item_size_nr(leaf, path->slots[0]));
 		goto found;
 	}
 	ret = PTR_ERR(item);
@@ -807,8 +780,7 @@ again:
 
 		free_space = btrfs_leaf_free_space(root, leaf) -
 					 sizeof(struct btrfs_item) - csum_size;
-		tmp = btrfs_sector_sum_left(sums, sector_sum, total_bytes,
-					    root->sectorsize);
+		tmp = sums->len - total_bytes;
 		tmp >>= root->fs_info->sb->s_blocksize_bits;
 		WARN_ON(tmp < 1);
 
@@ -822,6 +794,7 @@ again:
 		diff *= csum_size;
 
 		btrfs_extend_item(root, path, diff);
+		ret = 0;
 		goto csum;
 	}
 
@@ -831,8 +804,7 @@ insert:
 	if (found_next) {
 		u64 tmp;
 
-		tmp = btrfs_sector_sum_left(sums, sector_sum, total_bytes,
-					    root->sectorsize);
+		tmp = sums->len - total_bytes;
 		tmp >>= root->fs_info->sb->s_blocksize_bits;
 		tmp = min(tmp, (next_offset - file_key.offset) >>
 					 root->fs_info->sb->s_blocksize_bits);
@@ -853,31 +825,25 @@ insert:
 		WARN_ON(1);
 		goto fail_unlock;
 	}
-csum:
 	leaf = path->nodes[0];
+csum:
 	item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_csum_item);
-	ret = 0;
+	item_end = (struct btrfs_csum_item *)((unsigned char *)item +
+				      btrfs_item_size_nr(leaf, path->slots[0]));
 	item = (struct btrfs_csum_item *)((unsigned char *)item +
 					  csum_offset * csum_size);
 found:
-	item_end = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_csum_item);
-	item_end = (struct btrfs_csum_item *)((unsigned char *)item_end +
-				      btrfs_item_size_nr(leaf, path->slots[0]));
-next_sector:
-
-	write_extent_buffer(leaf, &sector_sum->sum, (unsigned long)item, csum_size);
-
-	total_bytes += root->sectorsize;
-	sector_sum++;
-	if (total_bytes < sums->len) {
-		item = (struct btrfs_csum_item *)((char *)item +
-						  csum_size);
-		if (item < item_end && bytenr + PAGE_CACHE_SIZE ==
-		    sector_sum->bytenr) {
-			bytenr = sector_sum->bytenr;
-			goto next_sector;
-		}
-	}
+	ins_size = (u32)(sums->len - total_bytes) >>
+		   root->fs_info->sb->s_blocksize_bits;
+	ins_size *= csum_size;
+	ins_size = min_t(u32, (unsigned long)item_end - (unsigned long)item,
+			      ins_size);
+	write_extent_buffer(leaf, sums->sums + index, (unsigned long)item,
+			    ins_size);
+
+	ins_size /= csum_size;
+	total_bytes += ins_size * root->sectorsize;
+	index += ins_size;
 
 	btrfs_mark_buffer_dirty(path->nodes[0]);
 	if (total_bytes < sums->len) {
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 1ddd728..937c40c 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -989,7 +989,6 @@ int btrfs_find_ordered_sum(struct inode *inode, u64 offset, u64 disk_bytenr,
 			   u32 *sum, int len)
 {
 	struct btrfs_ordered_sum *ordered_sum;
-	struct btrfs_sector_sum *sector_sums;
 	struct btrfs_ordered_extent *ordered;
 	struct btrfs_ordered_inode_tree *tree = &BTRFS_I(inode)->ordered_tree;
 	unsigned long num_sectors;
@@ -1007,18 +1006,16 @@ int btrfs_find_ordered_sum(struct inode *inode, u64 offset, u64 disk_bytenr,
 		    disk_bytenr < ordered_sum->bytenr + ordered_sum->len) {
 			i = (disk_bytenr - ordered_sum->bytenr) >>
 			    inode->i_sb->s_blocksize_bits;
-			sector_sums = ordered_sum->sums + i;
 			num_sectors = ordered_sum->len >>
 				      inode->i_sb->s_blocksize_bits;
-			for (; i < num_sectors; i++) {
-				if (sector_sums[i].bytenr == disk_bytenr) {
-					sum[index] = sector_sums[i].sum;
-					index++;
-					if (index == len)
-						goto out;
-					disk_bytenr += sectorsize;
-				}
-			}
+			num_sectors = min_t(int, len - index, num_sectors - i);
+			memcpy(sum + index, ordered_sum->sums + i,
+			       num_sectors);
+
+			index += (int)num_sectors;
+			if (index == len)
+				goto out;
+			disk_bytenr += num_sectors * sectorsize;
 		}
 	}
 out:
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 58b0e3b..888bcbb 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -26,18 +26,6 @@ struct btrfs_ordered_inode_tree {
 	struct rb_node *last;
 };
 
-/*
- * these are used to collect checksums done just before bios submission.
- * They are attached via a list into the ordered extent, and
- * checksum items are inserted into the tree after all the blocks in
- * the ordered extent are on disk
- */
-struct btrfs_sector_sum {
-	/* bytenr on disk */
-	u64 bytenr;
-	u32 sum;
-};
-
 struct btrfs_ordered_sum {
 	/* bytenr is the start of this extent on disk */
 	u64 bytenr;
@@ -45,10 +33,10 @@ struct btrfs_ordered_sum {
 	/*
 	 * this is the length in bytes covered by the sums array below.
 	 */
-	unsigned long len;
+	int len;
 	struct list_head list;
-	/* last field is a variable length array of btrfs_sector_sums */
-	struct btrfs_sector_sum sums[];
+	/* last field is a variable length array of csums */
+	u32 sums[];
 };
 
 /*
@@ -149,11 +137,8 @@ struct btrfs_ordered_extent {
 static inline int btrfs_ordered_sum_size(struct btrfs_root *root,
 					 unsigned long bytes)
 {
-	unsigned long num_sectors = (bytes + root->sectorsize - 1) /
-		root->sectorsize;
-	num_sectors++;
-	return sizeof(struct btrfs_ordered_sum) +
-		num_sectors * sizeof(struct btrfs_sector_sum);
+	int num_sectors = (int)DIV_ROUND_UP(bytes, root->sectorsize);
+	return sizeof(struct btrfs_ordered_sum) + num_sectors * sizeof(u32);
 }
 
 static inline void
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 704a1b8..aca3c30 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4390,10 +4390,8 @@ out:
 int btrfs_reloc_clone_csums(struct inode *inode, u64 file_pos, u64 len)
 {
 	struct btrfs_ordered_sum *sums;
-	struct btrfs_sector_sum *sector_sum;
 	struct btrfs_ordered_extent *ordered;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	size_t offset;
 	int ret;
 	u64 disk_bytenr;
 	LIST_HEAD(list);
@@ -4411,16 +4409,8 @@ int btrfs_reloc_clone_csums(struct inode *inode, u64 file_pos, u64 len)
 		sums = list_entry(list.next, struct btrfs_ordered_sum, list);
 		list_del_init(&sums->list);
 
-		sector_sum = sums->sums;
 		sums->bytenr = ordered->start;
 
-		offset = 0;
-		while (offset < sums->len) {
-			sector_sum->bytenr += ordered->start - disk_bytenr;
-			sector_sum++;
-			offset += root->sectorsize;
-		}
-
 		btrfs_add_ordered_sum(inode, ordered, sums);
 	}
 out:
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index f489e24..a2a772c 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2126,8 +2126,7 @@ static int scrub_find_csum(struct scrub_ctx *sctx, u64 logical, u64 len,
 			   u8 *csum)
 {
 	struct btrfs_ordered_sum *sum = NULL;
-	int ret = 0;
-	unsigned long i;
+	unsigned long index;
 	unsigned long num_sectors;
 
 	while (!list_empty(&sctx->csum_list)) {
@@ -2146,19 +2145,14 @@ static int scrub_find_csum(struct scrub_ctx *sctx, u64 logical, u64 len,
 	if (!sum)
 		return 0;
 
+	index = ((u32)(logical - sum->bytenr)) / sctx->sectorsize;
 	num_sectors = sum->len / sctx->sectorsize;
-	for (i = 0; i < num_sectors; ++i) {
-		if (sum->sums[i].bytenr == logical) {
-			memcpy(csum, &sum->sums[i].sum, sctx->csum_size);
-			ret = 1;
-			break;
-		}
-	}
-	if (ret && i == num_sectors - 1) {
+	memcpy(csum, sum->sums + index, sctx->csum_size);
+	if (index == num_sectors - 1) {
 		list_del(&sum->list);
 		kfree(sum);
 	}
-	return ret;
+	return 1;
 }
 
 /* scrub extent tries to collect up to 64 kB for each bio */
-- 
1.8.0.1
