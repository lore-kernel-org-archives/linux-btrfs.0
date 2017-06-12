Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46124 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752054AbdFLSGE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Jun 2017 14:06:04 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH v3] Btrfs: change how we iterate bios in endio
Date: Mon, 12 Jun 2017 11:05:12 -0600
Message-Id: <20170612170512.1837-1-bo.li.liu@oracle.com>
In-Reply-To: <20170517222252.29242-5-bo.li.liu@oracle.com>
References: <20170517222252.29242-5-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since dio submit has used bio_clone_fast, the submitted bio may not have a
reliable bi_vcnt, for the bio vector iterations in checksum related
functions, bio->bi_iter is not modified yet and it's safe to use
bio_for_each_segment, while for those bio vector iterations in dio read's
endio, we now save a copy of bvec_iter in struct btrfs_io_bio when cloning
bios and use the helper __bio_for_each_segment with the saved bvec_iter to
access each bvec.

Also for dio reads which don't get split, we also need to save a copy of
bio iterator in btrfs_bio_clone to let __bio_for_each_segments to access
each bvec in dio read's endio.  Note that it doesn't affect other calls of
btrfs_bio_clone() because they don't need to use this iterator.

Cc: David Sterba <dsterba@suse.cz>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: Fix null pointer crash in the case of non-split dio reads.

 fs/btrfs/extent_io.c |  2 ++
 fs/btrfs/file-item.c | 31 +++++++++++++++----------------
 fs/btrfs/inode.c     | 35 +++++++++++++++++++----------------
 fs/btrfs/volumes.h   |  1 +
 4 files changed, 37 insertions(+), 32 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 89b824d..79be8c2 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2719,6 +2719,7 @@ struct bio *btrfs_bio_clone(struct bio *bio, gfp_t gfp_mask)
 		btrfs_bio->csum = NULL;
 		btrfs_bio->csum_allocated = NULL;
 		btrfs_bio->end_io = NULL;
+		btrfs_bio->iter = bio->bi_iter;
 	}
 	return new;
 }
@@ -2755,6 +2756,7 @@ struct bio *btrfs_bio_clone_partial(struct bio *orig, gfp_t gfp_mask,
 	btrfs_bio->end_io = NULL;
 
 	bio_trim(bio, offset >> 9, size >> 9);
+	btrfs_bio->iter = bio->bi_iter;
 	return bio;
 }
 
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 64fcb31..9f6062c 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -164,7 +164,8 @@ static int __btrfs_lookup_bio_sums(struct inode *inode, struct bio *bio,
 				   u64 logical_offset, u32 *dst, int dio)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-	struct bio_vec *bvec;
+	struct bio_vec bvec;
+	struct bvec_iter iter;
 	struct btrfs_io_bio *btrfs_bio = btrfs_io_bio(bio);
 	struct btrfs_csum_item *item = NULL;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
@@ -177,7 +178,7 @@ static int __btrfs_lookup_bio_sums(struct inode *inode, struct bio *bio,
 	u64 page_bytes_left;
 	u32 diff;
 	int nblocks;
-	int count = 0, i;
+	int count = 0;
 	u16 csum_size = btrfs_super_csum_size(fs_info->super_copy);
 
 	path = btrfs_alloc_path();
@@ -206,8 +207,6 @@ static int __btrfs_lookup_bio_sums(struct inode *inode, struct bio *bio,
 	if (bio->bi_iter.bi_size > PAGE_SIZE * 8)
 		path->reada = READA_FORWARD;
 
-	WARN_ON(bio->bi_vcnt <= 0);
-
 	/*
 	 * the free space stuff is only read when it hasn't been
 	 * updated in the current transaction.  So, we can safely
@@ -223,13 +222,13 @@ static int __btrfs_lookup_bio_sums(struct inode *inode, struct bio *bio,
 	if (dio)
 		offset = logical_offset;
 
-	bio_for_each_segment_all(bvec, bio, i) {
-		page_bytes_left = bvec->bv_len;
+	bio_for_each_segment(bvec, bio, iter) {
+		page_bytes_left = bvec.bv_len;
 		if (count)
 			goto next;
 
 		if (!dio)
-			offset = page_offset(bvec->bv_page) + bvec->bv_offset;
+			offset = page_offset(bvec.bv_page) + bvec.bv_offset;
 		count = btrfs_find_ordered_sum(inode, offset, disk_bytenr,
 					       (u32 *)csum, nblocks);
 		if (count)
@@ -440,15 +439,15 @@ int btrfs_csum_one_bio(struct inode *inode, struct bio *bio,
 	struct btrfs_ordered_sum *sums;
 	struct btrfs_ordered_extent *ordered = NULL;
 	char *data;
-	struct bio_vec *bvec;
+	struct bvec_iter iter;
+	struct bio_vec bvec;
 	int index;
 	int nr_sectors;
-	int i, j;
 	unsigned long total_bytes = 0;
 	unsigned long this_sum_bytes = 0;
+	int i;
 	u64 offset;
 
-	WARN_ON(bio->bi_vcnt <= 0);
 	sums = kzalloc(btrfs_ordered_sum_size(fs_info, bio->bi_iter.bi_size),
 		       GFP_NOFS);
 	if (!sums)
@@ -465,19 +464,19 @@ int btrfs_csum_one_bio(struct inode *inode, struct bio *bio,
 	sums->bytenr = (u64)bio->bi_iter.bi_sector << 9;
 	index = 0;
 
-	bio_for_each_segment_all(bvec, bio, j) {
+	bio_for_each_segment(bvec, bio, iter) {
 		if (!contig)
-			offset = page_offset(bvec->bv_page) + bvec->bv_offset;
+			offset = page_offset(bvec.bv_page) + bvec.bv_offset;
 
 		if (!ordered) {
 			ordered = btrfs_lookup_ordered_extent(inode, offset);
 			BUG_ON(!ordered); /* Logic error */
 		}
 
-		data = kmap_atomic(bvec->bv_page);
+		data = kmap_atomic(bvec.bv_page);
 
 		nr_sectors = BTRFS_BYTES_TO_BLKS(fs_info,
-						 bvec->bv_len + fs_info->sectorsize
+						 bvec.bv_len + fs_info->sectorsize
 						 - 1);
 
 		for (i = 0; i < nr_sectors; i++) {
@@ -504,12 +503,12 @@ int btrfs_csum_one_bio(struct inode *inode, struct bio *bio,
 					+ total_bytes;
 				index = 0;
 
-				data = kmap_atomic(bvec->bv_page);
+				data = kmap_atomic(bvec.bv_page);
 			}
 
 			sums->sums[index] = ~(u32)0;
 			sums->sums[index]
-				= btrfs_csum_data(data + bvec->bv_offset
+				= btrfs_csum_data(data + bvec.bv_offset
 						+ (i * fs_info->sectorsize),
 						sums->sums[index],
 						fs_info->sectorsize);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 58ff494..160a25b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7981,6 +7981,7 @@ static int dio_read_error(struct inode *inode, struct bio *failed_bio,
 	struct bio *bio;
 	int isector;
 	int read_mode = 0;
+	int segs;
 	int ret;
 
 	BUG_ON(bio_op(failed_bio) == REQ_OP_WRITE);
@@ -7996,9 +7997,9 @@ static int dio_read_error(struct inode *inode, struct bio *failed_bio,
 		return -EIO;
 	}
 
-	if ((failed_bio->bi_vcnt > 1)
-		|| (failed_bio->bi_io_vec->bv_len
-			> btrfs_inode_sectorsize(inode)))
+	segs = bio_segments(failed_bio);
+	if (segs > 1 ||
+	    (failed_bio->bi_io_vec->bv_len > btrfs_inode_sectorsize(inode)))
 		read_mode |= REQ_FAILFAST_DEV;
 
 	isector = start - btrfs_io_bio(failed_bio)->logical;
@@ -8056,13 +8057,13 @@ static int __btrfs_correct_data_nocsum(struct inode *inode,
 				       struct btrfs_io_bio *io_bio)
 {
 	struct btrfs_fs_info *fs_info;
-	struct bio_vec *bvec;
+	struct bio_vec bvec;
+	struct bvec_iter iter;
 	struct btrfs_retry_complete done;
 	u64 start;
 	unsigned int pgoff;
 	u32 sectorsize;
 	int nr_sectors;
-	int i;
 	int ret;
 
 	fs_info = BTRFS_I(inode)->root->fs_info;
@@ -8070,17 +8071,18 @@ static int __btrfs_correct_data_nocsum(struct inode *inode,
 
 	start = io_bio->logical;
 	done.inode = inode;
+	io_bio->bio.bi_iter = io_bio->iter;
 
-	bio_for_each_segment_all(bvec, &io_bio->bio, i) {
-		nr_sectors = BTRFS_BYTES_TO_BLKS(fs_info, bvec->bv_len);
-		pgoff = bvec->bv_offset;
+	bio_for_each_segment(bvec, &io_bio->bio, iter) {
+		nr_sectors = BTRFS_BYTES_TO_BLKS(fs_info, bvec.bv_len);
+		pgoff = bvec.bv_offset;
 
 next_block_or_try_again:
 		done.uptodate = 0;
 		done.start = start;
 		init_completion(&done.done);
 
-		ret = dio_read_error(inode, &io_bio->bio, bvec->bv_page,
+		ret = dio_read_error(inode, &io_bio->bio, bvec.bv_page,
 				pgoff, start, start + sectorsize - 1,
 				io_bio->mirror_num,
 				btrfs_retry_endio_nocsum, &done);
@@ -8145,7 +8147,8 @@ static int __btrfs_subio_endio_read(struct inode *inode,
 				    struct btrfs_io_bio *io_bio, int err)
 {
 	struct btrfs_fs_info *fs_info;
-	struct bio_vec *bvec;
+	struct bio_vec bvec;
+	struct bvec_iter iter;
 	struct btrfs_retry_complete done;
 	u64 start;
 	u64 offset = 0;
@@ -8153,7 +8156,6 @@ static int __btrfs_subio_endio_read(struct inode *inode,
 	int nr_sectors;
 	unsigned int pgoff;
 	int csum_pos;
-	int i;
 	int uptodate = !!(err == 0);
 	int ret;
 
@@ -8163,16 +8165,17 @@ static int __btrfs_subio_endio_read(struct inode *inode,
 	err = 0;
 	start = io_bio->logical;
 	done.inode = inode;
+	io_bio->bio.bi_iter = io_bio->iter;
 
-	bio_for_each_segment_all(bvec, &io_bio->bio, i) {
-		nr_sectors = BTRFS_BYTES_TO_BLKS(fs_info, bvec->bv_len);
+	bio_for_each_segment(bvec, &io_bio->bio, iter) {
+		nr_sectors = BTRFS_BYTES_TO_BLKS(fs_info, bvec.bv_len);
 
-		pgoff = bvec->bv_offset;
+		pgoff = bvec.bv_offset;
 next_block:
 		if (uptodate) {
 			csum_pos = BTRFS_BYTES_TO_BLKS(fs_info, offset);
 			ret = __readpage_endio_check(inode, io_bio, csum_pos,
-						     bvec->bv_page, pgoff,
+						     bvec.bv_page, pgoff,
 						     start, sectorsize);
 			if (likely(!ret))
 				goto next;
@@ -8182,7 +8185,7 @@ static int __btrfs_subio_endio_read(struct inode *inode,
 		done.start = start;
 		init_completion(&done.done);
 
-		ret = dio_read_error(inode, &io_bio->bio, bvec->bv_page,
+		ret = dio_read_error(inode, &io_bio->bio, bvec.bv_page,
 				pgoff, start, start + sectorsize - 1,
 				io_bio->mirror_num,
 				btrfs_retry_endio, &done);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index c7d0fbc..7a5a17c 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -279,6 +279,7 @@ struct btrfs_io_bio {
 	u8 csum_inline[BTRFS_BIO_INLINE_CSUM_SIZE];
 	u8 *csum_allocated;
 	btrfs_io_bio_end_io_t *end_io;
+	struct bvec_iter iter;
 	struct bio bio;
 };
 
-- 
2.9.4

