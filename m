Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37185 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755050AbdDRBRx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Apr 2017 21:17:53 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v3I1Hqs4027542
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Apr 2017 01:17:53 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v3I1Hql5026006
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Apr 2017 01:17:52 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v3I1HqIk021779
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Apr 2017 01:17:52 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/6] Btrfs: use bio_clone_bioset_partial to simplify DIO submit
Date: Mon, 17 Apr 2017 18:16:23 -0700
Message-Id: <1492478187-24875-3-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1492478187-24875-1-git-send-email-bo.li.liu@oracle.com>
References: <1492478187-24875-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently when mapping bio to limit bio to a single stripe length, we
split bio by adding page to bio one by one, but later we don't modify
the vector of bio at all, thus we can use bio_clone_fast to use the
original bio vector directly.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_io.c |  15 +++++++
 fs/btrfs/extent_io.h |   1 +
 fs/btrfs/inode.c     | 122 +++++++++++++++++++--------------------------------
 3 files changed, 62 insertions(+), 76 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 0d4aea4..1b7156c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2726,6 +2726,21 @@ struct bio *btrfs_io_bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs)
 	return bio;
 }
 
+struct bio *btrfs_bio_clone_partial(struct bio *orig, gfp_t gfp_mask, int offset, int size)
+{
+	struct bio *bio;
+
+	bio = bio_clone_fast(orig, gfp_mask, btrfs_bioset);
+	if (bio) {
+		struct btrfs_io_bio *btrfs_bio = btrfs_io_bio(bio);
+		btrfs_bio->csum = NULL;
+		btrfs_bio->csum_allocated = NULL;
+		btrfs_bio->end_io = NULL;
+
+		bio_trim(bio, (offset >> 9), (size >> 9));
+	}
+	return bio;
+}
 
 static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
 				       unsigned long bio_flags)
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 3e4fad4..3b2bc88 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -460,6 +460,7 @@ btrfs_bio_alloc(struct block_device *bdev, u64 first_sector, int nr_vecs,
 		gfp_t gfp_flags);
 struct bio *btrfs_io_bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs);
 struct bio *btrfs_bio_clone(struct bio *bio, gfp_t gfp_mask);
+struct bio *btrfs_bio_clone_partial(struct bio *orig, gfp_t gfp_mask, int offset, int size);
 
 struct btrfs_fs_info;
 struct btrfs_inode;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a18510b..6215720 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8230,16 +8230,6 @@ static void btrfs_end_dio_bio(struct bio *bio)
 	bio_put(bio);
 }
 
-static struct bio *btrfs_dio_bio_alloc(struct block_device *bdev,
-				       u64 first_sector, gfp_t gfp_flags)
-{
-	struct bio *bio;
-	bio = btrfs_bio_alloc(bdev, first_sector, BIO_MAX_PAGES, gfp_flags);
-	if (bio)
-		bio_associate_current(bio);
-	return bio;
-}
-
 static inline int btrfs_lookup_and_bind_dio_csum(struct inode *inode,
 						 struct btrfs_dio_private *dip,
 						 struct bio *bio,
@@ -8329,24 +8319,22 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct bio *bio;
 	struct bio *orig_bio = dip->orig_bio;
-	struct bio_vec *bvec;
 	u64 start_sector = orig_bio->bi_iter.bi_sector;
 	u64 file_offset = dip->logical_offset;
-	u64 submit_len = 0;
 	u64 map_length;
-	u32 blocksize = fs_info->sectorsize;
 	int async_submit = 0;
-	int nr_sectors;
+	int submit_len;
+	int clone_offset = 0;
+	int clone_len;
 	int ret;
-	int i, j;
 
-	map_length = orig_bio->bi_iter.bi_size;
+	submit_len = map_length = orig_bio->bi_iter.bi_size;
 	ret = btrfs_map_block(fs_info, btrfs_op(orig_bio), start_sector << 9,
 			      &map_length, NULL, 0);
 	if (ret)
 		return -EIO;
 
-	if (map_length >= orig_bio->bi_iter.bi_size) {
+	if (map_length >= submit_len) {
 		bio = orig_bio;
 		dip->flags |= BTRFS_DIO_ORIG_BIO_SUBMITTED;
 		goto submit;
@@ -8358,70 +8346,52 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip,
 	else
 		async_submit = 1;
 
-	bio = btrfs_dio_bio_alloc(orig_bio->bi_bdev, start_sector, GFP_NOFS);
-	if (!bio)
-		return -ENOMEM;
-
-	bio->bi_opf = orig_bio->bi_opf;
-	bio->bi_private = dip;
-	bio->bi_end_io = btrfs_end_dio_bio;
-	btrfs_io_bio(bio)->logical = file_offset;
+	/* bio split */
 	atomic_inc(&dip->pending_bios);
+	while (submit_len > 0) {
+		/* map_length < submit_len, it's a int */
+		clone_len = min(submit_len, (int)map_length);
+		bio = btrfs_bio_clone_partial(orig_bio, GFP_NOFS, clone_offset, clone_len);
+		if (!bio)
+			goto out_err;
+		/* the above clone call also clone blkcg of orig_bio */
+
+		bio->bi_private = dip;
+		bio->bi_end_io = btrfs_end_dio_bio;
+		btrfs_io_bio(bio)->logical = file_offset;
+
+		ASSERT(submit_len >= clone_len);
+		submit_len -= clone_len;
+		if (submit_len == 0)
+			break;
 
-	bio_for_each_segment_all(bvec, orig_bio, j) {
-		nr_sectors = BTRFS_BYTES_TO_BLKS(fs_info, bvec->bv_len);
-		i = 0;
-next_block:
-		if (unlikely(map_length < submit_len + blocksize ||
-		    bio_add_page(bio, bvec->bv_page, blocksize,
-			    bvec->bv_offset + (i * blocksize)) < blocksize)) {
-			/*
-			 * inc the count before we submit the bio so
-			 * we know the end IO handler won't happen before
-			 * we inc the count. Otherwise, the dip might get freed
-			 * before we're done setting it up
-			 */
-			atomic_inc(&dip->pending_bios);
-			ret = __btrfs_submit_dio_bio(bio, inode,
-						     file_offset, skip_sum,
-						     async_submit);
-			if (ret) {
-				bio_put(bio);
-				atomic_dec(&dip->pending_bios);
-				goto out_err;
-			}
-
-			start_sector += submit_len >> 9;
-			file_offset += submit_len;
-
-			submit_len = 0;
+		/*
+		 * increase the count before we submit the bio so we know the
+		 * end IO handler won't happen before we increase the
+		 * count. Otherwise, the dip might get freed before we're done
+		 * setting it up.
+		 */
+		atomic_inc(&dip->pending_bios);
 
-			bio = btrfs_dio_bio_alloc(orig_bio->bi_bdev,
-						  start_sector, GFP_NOFS);
-			if (!bio)
-				goto out_err;
-			bio->bi_opf = orig_bio->bi_opf;
-			bio->bi_private = dip;
-			bio->bi_end_io = btrfs_end_dio_bio;
-			btrfs_io_bio(bio)->logical = file_offset;
+		ret = __btrfs_submit_dio_bio(bio, inode,
+					     file_offset, skip_sum,
+					     async_submit);
+		if (ret) {
+			bio_put(bio);
+			atomic_dec(&dip->pending_bios);
+			goto out_err;
+		}
 
-			map_length = orig_bio->bi_iter.bi_size;
-			ret = btrfs_map_block(fs_info, btrfs_op(orig_bio),
-					      start_sector << 9,
-					      &map_length, NULL, 0);
-			if (ret) {
-				bio_put(bio);
-				goto out_err;
-			}
+		clone_offset += clone_len;
+		start_sector += clone_len >> 9;
+		file_offset += clone_len;
 
-			goto next_block;
-		} else {
-			submit_len += blocksize;
-			if (--nr_sectors) {
-				i++;
-				goto next_block;
-			}
-		}
+		map_length = submit_len;
+		ret = btrfs_map_block(fs_info, btrfs_op(orig_bio),
+				      (start_sector << 9),
+				      &map_length, NULL, 0);
+		if (ret)
+			goto out_err;
 	}
 
 submit:
-- 
2.5.5

