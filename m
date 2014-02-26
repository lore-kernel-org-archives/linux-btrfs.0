Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:47395 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbaBZXkW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Feb 2014 18:40:22 -0500
Received: by mail-pb0-f51.google.com with SMTP id un15so1684872pbc.38
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Feb 2014 15:40:21 -0800 (PST)
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>, Chris Mason <clm@fb.com>,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 6/9] btrfs: Convert to bio_for_each_segment()
Date: Wed, 26 Feb 2014 15:39:54 -0800
Message-Id: <1393457997-17618-7-git-send-email-kmo@daterainc.com>
In-Reply-To: <1393457997-17618-1-git-send-email-kmo@daterainc.com>
References: <1393457997-17618-1-git-send-email-kmo@daterainc.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is going to be important for future (hopeful) block layer refactoring, and
using the standard primitives makes the code easier to audit.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org
---
 fs/btrfs/extent_io.c | 12 ++++++++---
 fs/btrfs/file-item.c | 59 ++++++++++++++++++++--------------------------------
 fs/btrfs/inode.c     | 22 +++++++-------------
 3 files changed, 39 insertions(+), 54 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 85bbd01f12..0a84847123 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2632,12 +2632,18 @@ static int __must_check submit_one_bio(int rw, struct bio *bio,
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
index 127555b29f..c41642ea69 100644
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
-		while (count--) {
-			disk_bytenr += bvec->bv_len;
-			offset += bvec->bv_len;
-			bio_index++;
-			bvec++;
-		}
+		bio_advance_iter(bio, &iter,
+				 count << inode->i_sb->s_blocksize_bits);
+		offset += count << inode->i_sb->s_blocksize_bits;
 	}
 	btrfs_free_path(path);
 	return 0;
@@ -439,14 +433,12 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
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
@@ -458,53 +450,46 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
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
+			sums = kzalloc(btrfs_ordered_sum_size(root, iter.bi_size),
 				       GFP_NOFS);
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
index d3d4448629..2475908a7b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7161,12 +7161,11 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
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
 	int ret = 0;
 	int async_submit = 0;
 
@@ -7197,10 +7196,12 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 	bio->bi_end_io = btrfs_end_dio_bio;
 	atomic_inc(&dip->pending_bios);
 
-	while (bvec <= (orig_bio->bi_io_vec + orig_bio->bi_vcnt - 1)) {
-		if (unlikely(map_length < submit_len + bvec->bv_len ||
-		    bio_add_page(bio, bvec->bv_page, bvec->bv_len,
-				 bvec->bv_offset) < bvec->bv_len)) {
+	bio_for_each_segment(bvec, orig_bio, iter) {
+		if (unlikely(map_length < bio->bi_iter.bi_size + bvec.bv_len ||
+		    bio_add_page(bio, bvec.bv_page, bvec.bv_len,
+				 bvec.bv_offset) < bvec.bv_len)) {
+			unsigned submit_len = bio->bi_iter.bi_size;
+
 			/*
 			 * inc the count before we submit the bio so
 			 * we know the end IO handler won't happen before
@@ -7220,9 +7221,6 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 			start_sector += submit_len >> 9;
 			file_offset += submit_len;
 
-			submit_len = 0;
-			nr_pages = 0;
-
 			bio = btrfs_dio_bio_alloc(orig_bio->bi_bdev,
 						  start_sector, GFP_NOFS);
 			if (!bio)
@@ -7238,10 +7236,6 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
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
1.9.0

