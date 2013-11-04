Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:59579 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab3KDXgq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Nov 2013 18:36:46 -0500
Received: by mail-pd0-f177.google.com with SMTP id p10so7318579pdj.22
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Nov 2013 15:36:45 -0800 (PST)
From: Kent Overstreet <kmo@daterainc.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Cc: axboe@kernel.dk, hch@infradead.org, Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 7/9] blk-lib.c: generic_make_request() handles large bios now
Date: Mon,  4 Nov 2013 15:36:25 -0800
Message-Id: <1383608187-27368-8-git-send-email-kmo@daterainc.com>
In-Reply-To: <1383608187-27368-1-git-send-email-kmo@daterainc.com>
References: <1383608187-27368-1-git-send-email-kmo@daterainc.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

generic_make_request() will now do for us what the code in blk-lib.c was
doing manually, with the bio_batch stuff - we still need some looping in
case we're trying to discard/zeroout more than around a gigabyte, but
when we can submit that much at a time doing the submissions in parallel
really shouldn't matter.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-lib.c | 175 ++++++++++----------------------------------------------
 1 file changed, 30 insertions(+), 145 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 2da76c9..368c36a 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -9,23 +9,6 @@
 
 #include "blk.h"
 
-struct bio_batch {
-	atomic_t		done;
-	unsigned long		flags;
-	struct completion	*wait;
-};
-
-static void bio_batch_end_io(struct bio *bio, int err)
-{
-	struct bio_batch *bb = bio->bi_private;
-
-	if (err && (err != -EOPNOTSUPP))
-		clear_bit(BIO_UPTODATE, &bb->flags);
-	if (atomic_dec_and_test(&bb->done))
-		complete(bb->wait);
-	bio_put(bio);
-}
-
 /**
  * blkdev_issue_discard - queue a discard
  * @bdev:	blockdev to issue discard for
@@ -40,15 +23,10 @@ static void bio_batch_end_io(struct bio *bio, int err)
 int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, unsigned long flags)
 {
-	DECLARE_COMPLETION_ONSTACK(wait);
 	struct request_queue *q = bdev_get_queue(bdev);
 	int type = REQ_WRITE | REQ_DISCARD;
-	unsigned int max_discard_sectors, granularity;
-	int alignment;
-	struct bio_batch bb;
 	struct bio *bio;
 	int ret = 0;
-	struct blk_plug plug;
 
 	if (!q)
 		return -ENXIO;
@@ -56,78 +34,28 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	if (!blk_queue_discard(q))
 		return -EOPNOTSUPP;
 
-	/* Zero-sector (unknown) and one-sector granularities are the same.  */
-	granularity = max(q->limits.discard_granularity >> 9, 1U);
-	alignment = (bdev_discard_alignment(bdev) >> 9) % granularity;
-
-	/*
-	 * Ensure that max_discard_sectors is of the proper
-	 * granularity, so that requests stay aligned after a split.
-	 */
-	max_discard_sectors = min(q->limits.max_discard_sectors, UINT_MAX >> 9);
-	max_discard_sectors -= max_discard_sectors % granularity;
-	if (unlikely(!max_discard_sectors)) {
-		/* Avoid infinite loop below. Being cautious never hurts. */
-		return -EOPNOTSUPP;
-	}
-
 	if (flags & BLKDEV_DISCARD_SECURE) {
 		if (!blk_queue_secdiscard(q))
 			return -EOPNOTSUPP;
 		type |= REQ_SECURE;
 	}
 
-	atomic_set(&bb.done, 1);
-	bb.flags = 1 << BIO_UPTODATE;
-	bb.wait = &wait;
-
-	blk_start_plug(&plug);
 	while (nr_sects) {
-		unsigned int req_sects;
-		sector_t end_sect, tmp;
-
 		bio = bio_alloc(gfp_mask, 1);
-		if (!bio) {
-			ret = -ENOMEM;
-			break;
-		}
-
-		req_sects = min_t(sector_t, nr_sects, max_discard_sectors);
-
-		/*
-		 * If splitting a request, and the next starting sector would be
-		 * misaligned, stop the discard at the previous aligned sector.
-		 */
-		end_sect = sector + req_sects;
-		tmp = end_sect;
-		if (req_sects < nr_sects &&
-		    sector_div(tmp, granularity) != alignment) {
-			end_sect = end_sect - alignment;
-			sector_div(end_sect, granularity);
-			end_sect = end_sect * granularity + alignment;
-			req_sects = end_sect - sector;
-		}
+		if (!bio)
+			return -ENOMEM;
 
-		bio->bi_iter.bi_sector = sector;
-		bio->bi_end_io = bio_batch_end_io;
 		bio->bi_bdev = bdev;
-		bio->bi_private = &bb;
+		bio->bi_iter.bi_sector = sector;
+		bio->bi_iter.bi_size = min_t(sector_t, nr_sects, 1 << 20) << 9;
 
-		bio->bi_iter.bi_size = req_sects << 9;
-		nr_sects -= req_sects;
-		sector = end_sect;
+		sector += bio_sectors(bio);
+		nr_sects -= bio_sectors(bio);
 
-		atomic_inc(&bb.done);
-		submit_bio(type, bio);
+		ret = submit_bio_wait(type, bio);
+		if (ret)
+			break;
 	}
-	blk_finish_plug(&plug);
-
-	/* Wait for bios in-flight */
-	if (!atomic_dec_and_test(&bb.done))
-		wait_for_completion_io(&wait);
-
-	if (!test_bit(BIO_UPTODATE, &bb.flags))
-		ret = -EIO;
 
 	return ret;
 }
@@ -148,61 +76,37 @@ int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 			    sector_t nr_sects, gfp_t gfp_mask,
 			    struct page *page)
 {
-	DECLARE_COMPLETION_ONSTACK(wait);
 	struct request_queue *q = bdev_get_queue(bdev);
-	unsigned int max_write_same_sectors;
-	struct bio_batch bb;
 	struct bio *bio;
 	int ret = 0;
 
 	if (!q)
 		return -ENXIO;
 
-	max_write_same_sectors = q->limits.max_write_same_sectors;
-
-	if (max_write_same_sectors == 0)
+	if (!q->limits.max_write_same_sectors)
 		return -EOPNOTSUPP;
 
-	atomic_set(&bb.done, 1);
-	bb.flags = 1 << BIO_UPTODATE;
-	bb.wait = &wait;
-
 	while (nr_sects) {
 		bio = bio_alloc(gfp_mask, 1);
-		if (!bio) {
-			ret = -ENOMEM;
-			break;
-		}
+		if (!bio)
+			return -ENOMEM;
 
-		bio->bi_iter.bi_sector = sector;
-		bio->bi_end_io = bio_batch_end_io;
 		bio->bi_bdev = bdev;
-		bio->bi_private = &bb;
+		bio->bi_iter.bi_sector = sector;
+		bio->bi_iter.bi_size = min_t(sector_t, nr_sects, 1 << 20) << 9;
 		bio->bi_vcnt = 1;
 		bio->bi_io_vec->bv_page = page;
 		bio->bi_io_vec->bv_offset = 0;
 		bio->bi_io_vec->bv_len = bdev_logical_block_size(bdev);
 
-		if (nr_sects > max_write_same_sectors) {
-			bio->bi_iter.bi_size = max_write_same_sectors << 9;
-			nr_sects -= max_write_same_sectors;
-			sector += max_write_same_sectors;
-		} else {
-			bio->bi_iter.bi_size = nr_sects << 9;
-			nr_sects = 0;
-		}
+		sector += bio_sectors(bio);
+		nr_sects -= bio_sectors(bio);
 
-		atomic_inc(&bb.done);
-		submit_bio(REQ_WRITE | REQ_WRITE_SAME, bio);
+		ret = submit_bio_wait(REQ_WRITE | REQ_WRITE_SAME, bio);
+		if (ret)
+			break;
 	}
 
-	/* Wait for bios in-flight */
-	if (!atomic_dec_and_test(&bb.done))
-		wait_for_completion_io(&wait);
-
-	if (!test_bit(BIO_UPTODATE, &bb.flags))
-		ret = -ENOTSUPP;
-
 	return ret;
 }
 EXPORT_SYMBOL(blkdev_issue_write_same);
@@ -217,33 +121,22 @@ EXPORT_SYMBOL(blkdev_issue_write_same);
  * Description:
  *  Generate and issue number of bios with zerofiled pages.
  */
-
 int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
-			sector_t nr_sects, gfp_t gfp_mask)
+			   sector_t nr_sects, gfp_t gfp_mask)
 {
-	int ret;
+	int ret = 0;
 	struct bio *bio;
-	struct bio_batch bb;
 	unsigned int sz;
-	DECLARE_COMPLETION_ONSTACK(wait);
-
-	atomic_set(&bb.done, 1);
-	bb.flags = 1 << BIO_UPTODATE;
-	bb.wait = &wait;
 
-	ret = 0;
-	while (nr_sects != 0) {
+	while (nr_sects) {
 		bio = bio_alloc(gfp_mask,
-				min(nr_sects, (sector_t)BIO_MAX_PAGES));
-		if (!bio) {
-			ret = -ENOMEM;
-			break;
-		}
+				min(nr_sects / (PAGE_SIZE >> 9),
+				    (sector_t)BIO_MAX_PAGES));
+		if (!bio)
+			return -ENOMEM;
 
 		bio->bi_iter.bi_sector = sector;
 		bio->bi_bdev   = bdev;
-		bio->bi_end_io = bio_batch_end_io;
-		bio->bi_private = &bb;
 
 		while (nr_sects != 0) {
 			sz = min((sector_t) PAGE_SIZE >> 9 , nr_sects);
@@ -253,18 +146,11 @@ int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 			if (ret < (sz << 9))
 				break;
 		}
-		ret = 0;
-		atomic_inc(&bb.done);
-		submit_bio(WRITE, bio);
-	}
-
-	/* Wait for bios in-flight */
-	if (!atomic_dec_and_test(&bb.done))
-		wait_for_completion_io(&wait);
 
-	if (!test_bit(BIO_UPTODATE, &bb.flags))
-		/* One of bios in the batch was completed with error.*/
-		ret = -EIO;
+		ret = submit_bio_wait(WRITE, bio);
+		if (ret)
+			break;
+	}
 
 	return ret;
 }
@@ -279,7 +165,6 @@ int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
  * Description:
  *  Generate and issue number of bios with zerofiled pages.
  */
-
 int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 			 sector_t nr_sects, gfp_t gfp_mask)
 {
-- 
1.8.4.rc3

