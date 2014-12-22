Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:60930 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672AbaLVLty (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Dec 2014 06:49:54 -0500
Received: by mail-wi0-f170.google.com with SMTP id bs8so10254324wib.1
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 03:49:53 -0800 (PST)
From: Dongsu Park <dongsu.park@profitbricks.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>,
        Ming Lin <mlin@minggr.net>, Dongsu Park <dongsu.park@profitbricks.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org
Subject: [RFC PATCH 06/17] btrfs: make use of immutable biovecs
Date: Mon, 22 Dec 2014 12:48:33 +0100
Message-Id: <83a9ee8a309f8e08490c5dd715a608ea054f5c33.1419241597.git.dongsu.park@profitbricks.com>
In-Reply-To: <e4b7b017eaa81784889ebb2a4e6a7d4366adf13a.1419241597.git.dongsu.park@profitbricks.com>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
 <d26a9a0fc9a7d1529c115785ee5935d5750782bd.1419241597.git.dongsu.park@profitbricks.com>
 <f67d71b4a375ab504c2fc02e94a9d2a651686cab.1419241597.git.dongsu.park@profitbricks.com>
 <fe96db02d805ca6191dd605d03dac0d04c926fc1.1419241597.git.dongsu.park@profitbricks.com>
 <bb0051ceb5805896089ded26c0f7f06758b25105.1419241597.git.dongsu.park@profitbricks.com>
 <e4b7b017eaa81784889ebb2a4e6a7d4366adf13a.1419241597.git.dongsu.park@profitbricks.com>
In-Reply-To: <cover.1419241597.git.dongsu.park@profitbricks.com>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Kent Overstreet <kmo@daterainc.com>

Make use of the new API for immutable biovecs, instead of iterating
bi_io_vec[] manually just like done in the old era. That means, e.g.
calling bio_for_each_segment() by passing bvec and iter literally,
using bio_advance_iter() for looking up the next range of biovec.

This is going to be important for future block layer refactoring, and
using the standard primitives makes the code easier to audit.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
[dpark: apply this conversion also in check-integrity.c, and add more
 descrption in commit message]
Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
---
 fs/btrfs/check-integrity.c | 22 ++++++++++-------
 fs/btrfs/extent_io.c       | 12 ++++++---
 fs/btrfs/file-item.c       | 61 +++++++++++++++++-----------------------------
 fs/btrfs/inode.c           | 22 ++++++-----------
 4 files changed, 53 insertions(+), 64 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index d897ef8..74ce4a2 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -2963,6 +2963,9 @@ int btrfsic_submit_bh(int rw, struct buffer_head *bh)
 static void __btrfsic_submit_bio(int rw, struct bio *bio)
 {
 	struct btrfsic_dev_state *dev_state;
+	struct bio_vec bvec = { 0 };
+	struct bvec_iter iter = bio->bi_iter;
+	struct page *page;
 
 	if (!btrfsic_is_initialized)
 		return;
@@ -2979,7 +2982,7 @@ static void __btrfsic_submit_bio(int rw, struct bio *bio)
 		int bio_is_patched;
 		char **mapped_datav;
 
-		dev_bytenr = 512 * bio->bi_iter.bi_sector;
+		dev_bytenr = 512 * iter.bi_sector;
 		bio_is_patched = 0;
 		if (dev_state->state->print_mask &
 		    BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH)
@@ -2987,7 +2990,7 @@ static void __btrfsic_submit_bio(int rw, struct bio *bio)
 			       "submit_bio(rw=0x%x, bi_vcnt=%u,"
 			       " bi_sector=%llu (bytenr %llu), bi_bdev=%p)\n",
 			       rw, bio->bi_vcnt,
-			       (unsigned long long)bio->bi_iter.bi_sector,
+			       (unsigned long long)iter.bi_sector,
 			       dev_bytenr, bio->bi_bdev);
 
 		mapped_datav = kmalloc(sizeof(*mapped_datav) * bio->bi_vcnt,
@@ -2995,13 +2998,14 @@ static void __btrfsic_submit_bio(int rw, struct bio *bio)
 		if (!mapped_datav)
 			goto leave;
 		cur_bytenr = dev_bytenr;
-		for (i = 0; i < bio->bi_vcnt; i++) {
-			BUG_ON(bio->bi_io_vec[i].bv_len != PAGE_CACHE_SIZE);
-			mapped_datav[i] = kmap(bio->bi_io_vec[i].bv_page);
+
+		bio_for_each_segment(bvec, bio, iter) {
+			BUG_ON(bvec.bv_len != PAGE_CACHE_SIZE);
+			mapped_datav[i] = kmap(bvec.bv_page);
 			if (!mapped_datav[i]) {
 				while (i > 0) {
 					i--;
-					kunmap(bio->bi_io_vec[i].bv_page);
+					kunmap(bvec.bv_page);
 				}
 				kfree(mapped_datav);
 				goto leave;
@@ -3011,8 +3015,8 @@ static void __btrfsic_submit_bio(int rw, struct bio *bio)
 				printk(KERN_INFO
 				       "#%u: bytenr=%llu, len=%u, offset=%u\n",
 				       i, cur_bytenr, bio->bi_io_vec[i].bv_len,
-				       bio->bi_io_vec[i].bv_offset);
-			cur_bytenr += bio->bi_io_vec[i].bv_len;
+				       bvec.bv_offset);
+			cur_bytenr += bvec.bv_len;
 		}
 		btrfsic_process_written_block(dev_state, dev_bytenr,
 					      mapped_datav, bio->bi_vcnt,
@@ -3020,7 +3024,7 @@ static void __btrfsic_submit_bio(int rw, struct bio *bio)
 					      NULL, rw);
 		while (i > 0) {
 			i--;
-			kunmap(bio->bi_io_vec[i].bv_page);
+			kunmap(bvec.bv_page);
 		}
 		kfree(mapped_datav);
 	} else if (NULL != dev_state && (rw & REQ_FLUSH)) {
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4ebabd2..038b242 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2749,12 +2749,18 @@ static int __must_check submit_one_bio(int rw, struct bio *bio,
 				       int mirror_num, unsigned long bio_flags)
 {
 	int ret = 0;
-	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
-	struct page *page = bvec->bv_page;
+	struct bio_vec bvec = { 0 };
+	struct bvec_iter iter;
+	struct page *page;
 	struct extent_io_tree *tree = bio->bi_private;
 	u64 start;
 
-	start = page_offset(page) + bvec->bv_offset;
+	bio_for_each_segment(bvec, bio, iter)
+		if (bio_iter_last(bvec, iter))
+			break;
+
+	page = bvec.bv_page;
+	start = page_offset(page) + bvec.bv_offset;
 
 	bio->bi_private = NULL;
 
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 84a2d18..7816cb8 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -162,7 +162,7 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 				   struct inode *inode, struct bio *bio,
 				   u64 logical_offset, u32 *dst, int dio)
 {
-	struct bio_vec *bvec = bio->bi_io_vec;
+	struct bvec_iter iter = bio->bi_iter;
 	struct btrfs_io_bio *btrfs_bio = btrfs_io_bio(bio);
 	struct btrfs_csum_item *item = NULL;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
@@ -171,10 +171,8 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 	u64 offset = 0;
 	u64 item_start_offset = 0;
 	u64 item_last_offset = 0;
-	u64 disk_bytenr;
 	u32 diff;
 	int nblocks;
-	int bio_index = 0;
 	int count;
 	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
 
@@ -204,8 +202,6 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 	if (bio->bi_iter.bi_size > PAGE_CACHE_SIZE * 8)
 		path->reada = 2;
 
-	WARN_ON(bio->bi_vcnt <= 0);
-
 	/*
 	 * the free space stuff is only read when it hasn't been
 	 * updated in the current transaction.  So, we can safely
@@ -217,12 +213,13 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 		path->skip_locking = 1;
 	}
 
-	disk_bytenr = (u64)bio->bi_iter.bi_sector << 9;
 	if (dio)
 		offset = logical_offset;
-	while (bio_index < bio->bi_vcnt) {
+	while (iter.bi_size) {
+		u64 disk_bytenr = (u64)iter.bi_sector << 9;
+		struct bio_vec bvec = bio_iter_iovec(bio, iter);
 		if (!dio)
-			offset = page_offset(bvec->bv_page) + bvec->bv_offset;
+			offset = page_offset(bvec.bv_page) + bvec.bv_offset;
 		count = btrfs_find_ordered_sum(inode, offset, disk_bytenr,
 					       (u32 *)csum, nblocks);
 		if (count)
@@ -243,7 +240,7 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 				if (BTRFS_I(inode)->root->root_key.objectid ==
 				    BTRFS_DATA_RELOC_TREE_OBJECTID) {
 					set_extent_bits(io_tree, offset,
-						offset + bvec->bv_len - 1,
+						offset + bvec.bv_len - 1,
 						EXTENT_NODATASUM, GFP_NOFS);
 				} else {
 					btrfs_info(BTRFS_I(inode)->root->fs_info,
@@ -281,12 +278,9 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 found:
 		csum += count * csum_size;
 		nblocks -= count;
-		bio_index += count;
-		while (count--) {
-			disk_bytenr += bvec->bv_len;
-			offset += bvec->bv_len;
-			bvec++;
-		}
+		bio_advance_iter(bio, &iter,
+				 count << inode->i_sb->s_blocksize_bits);
+		offset += count << inode->i_sb->s_blocksize_bits;
 	}
 	btrfs_free_path(path);
 	return 0;
@@ -429,14 +423,12 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
 	struct btrfs_ordered_sum *sums;
 	struct btrfs_ordered_extent *ordered;
 	char *data;
-	struct bio_vec *bvec = bio->bi_io_vec;
-	int bio_index = 0;
+	struct bio_vec bvec;
+	struct bvec_iter iter;
 	int index;
-	unsigned long total_bytes = 0;
 	unsigned long this_sum_bytes = 0;
 	u64 offset;
 
-	WARN_ON(bio->bi_vcnt <= 0);
 	sums = kzalloc(btrfs_ordered_sum_size(root, bio->bi_iter.bi_size),
 		       GFP_NOFS);
 	if (!sums)
@@ -448,53 +440,46 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
 	if (contig)
 		offset = file_start;
 	else
-		offset = page_offset(bvec->bv_page) + bvec->bv_offset;
+		offset = page_offset(bio_page(bio)) + bio_offset(bio);
 
 	ordered = btrfs_lookup_ordered_extent(inode, offset);
 	BUG_ON(!ordered); /* Logic error */
 	sums->bytenr = (u64)bio->bi_iter.bi_sector << 9;
 	index = 0;
 
-	while (bio_index < bio->bi_vcnt) {
+	bio_for_each_segment(bvec, bio, iter) {
 		if (!contig)
-			offset = page_offset(bvec->bv_page) + bvec->bv_offset;
+			offset = page_offset(bvec.bv_page) + bvec.bv_offset;
 
 		if (offset >= ordered->file_offset + ordered->len ||
 		    offset < ordered->file_offset) {
-			unsigned long bytes_left;
 			sums->len = this_sum_bytes;
 			this_sum_bytes = 0;
 			btrfs_add_ordered_sum(inode, ordered, sums);
 			btrfs_put_ordered_extent(ordered);
 
-			bytes_left = bio->bi_iter.bi_size - total_bytes;
-
-			sums = kzalloc(btrfs_ordered_sum_size(root, bytes_left),
-				       GFP_NOFS);
+			sums = kzalloc(btrfs_ordered_sum_size(root,
+				       iter.bi_size), GFP_NOFS);
 			BUG_ON(!sums); /* -ENOMEM */
-			sums->len = bytes_left;
+			sums->len = iter.bi_size;
 			ordered = btrfs_lookup_ordered_extent(inode, offset);
 			BUG_ON(!ordered); /* Logic error */
-			sums->bytenr = ((u64)bio->bi_iter.bi_sector << 9) +
-				       total_bytes;
+			sums->bytenr = ((u64)iter.bi_sector) << 9;
 			index = 0;
 		}
 
-		data = kmap_atomic(bvec->bv_page);
+		data = kmap_atomic(bvec.bv_page);
 		sums->sums[index] = ~(u32)0;
-		sums->sums[index] = btrfs_csum_data(data + bvec->bv_offset,
+		sums->sums[index] = btrfs_csum_data(data + bvec.bv_offset,
 						    sums->sums[index],
-						    bvec->bv_len);
+						    bvec.bv_len);
 		kunmap_atomic(data);
 		btrfs_csum_final(sums->sums[index],
 				 (char *)(sums->sums + index));
 
-		bio_index++;
 		index++;
-		total_bytes += bvec->bv_len;
-		this_sum_bytes += bvec->bv_len;
-		offset += bvec->bv_len;
-		bvec++;
+		offset += bvec.bv_len;
+		this_sum_bytes += bvec.bv_len;
 	}
 	this_sum_bytes = 0;
 	btrfs_add_ordered_sum(inode, ordered, sums);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e687bb0..9c513d8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7784,12 +7784,11 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct bio *bio;
 	struct bio *orig_bio = dip->orig_bio;
-	struct bio_vec *bvec = orig_bio->bi_io_vec;
+	struct bio_vec bvec;
+	struct bvec_iter iter;
 	u64 start_sector = orig_bio->bi_iter.bi_sector;
 	u64 file_offset = dip->logical_offset;
-	u64 submit_len = 0;
 	u64 map_length;
-	int nr_pages = 0;
 	int ret;
 	int async_submit = 0;
 
@@ -7821,10 +7820,12 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 	btrfs_io_bio(bio)->logical = file_offset;
 	atomic_inc(&dip->pending_bios);
 
-	while (bvec <= (orig_bio->bi_io_vec + orig_bio->bi_vcnt - 1)) {
-		if (map_length < submit_len + bvec->bv_len ||
-		    bio_add_page(bio, bvec->bv_page, bvec->bv_len,
-				 bvec->bv_offset) < bvec->bv_len) {
+	bio_for_each_segment(bvec, orig_bio, iter) {
+		if (map_length < bio->bi_iter.bi_size + bvec.bv_len ||
+		    bio_add_page(bio, bvec.bv_page, bvec.bv_len,
+				 bvec.bv_offset) < bvec.bv_len) {
+			unsigned submit_len = bio->bi_iter.bi_size;
+
 			/*
 			 * inc the count before we submit the bio so
 			 * we know the end IO handler won't happen before
@@ -7844,9 +7845,6 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 			start_sector += submit_len >> 9;
 			file_offset += submit_len;
 
-			submit_len = 0;
-			nr_pages = 0;
-
 			bio = btrfs_dio_bio_alloc(orig_bio->bi_bdev,
 						  start_sector, GFP_NOFS);
 			if (!bio)
@@ -7863,10 +7861,6 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 				bio_put(bio);
 				goto out_err;
 			}
-		} else {
-			submit_len += bvec->bv_len;
-			nr_pages++;
-			bvec++;
 		}
 	}
 
-- 
2.1.0

