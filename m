Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:35154 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbbALLun (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Jan 2015 06:50:43 -0500
Received: by mail-we0-f181.google.com with SMTP id q58so18595108wes.12
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Jan 2015 03:50:42 -0800 (PST)
From: Dongsu Park <dongsu.park@profitbricks.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Kent Overstreet <kmo@daterainc.com>,
        Jens Axboe <axboe@kernel.dk>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
        Dongsu Park <dongsu.park@profitbricks.com>
Subject: [PATCH v2 5/9] btrfs: remove bio splitting and merge_bvec_fn() calls
Date: Mon, 12 Jan 2015 12:49:44 +0100
Message-Id: <c98bf7a8cccb8a831566a72f87e8be9511d70e41.1421052746.git.dongsu.park@profitbricks.com>
In-Reply-To: <ca2dd738a2c26bba51acedae96ddb6cb65658268.1421052746.git.dongsu.park@profitbricks.com>
References: <cover.1421052745.git.dongsu.park@profitbricks.com>
 <4e7cfbce77dcf72474e1b930ef017c9efaea36d7.1421052746.git.dongsu.park@profitbricks.com>
 <ed9c9f3b8190cd64cddbe58a753c811aee69471f.1421052746.git.dongsu.park@profitbricks.com>
 <641ab3a0eeb225316784b8a22a285eab911d48fd.1421052746.git.dongsu.park@profitbricks.com>
 <ca2dd738a2c26bba51acedae96ddb6cb65658268.1421052746.git.dongsu.park@profitbricks.com>
In-Reply-To: <cover.1421052745.git.dongsu.park@profitbricks.com>
References: <cover.1421052745.git.dongsu.park@profitbricks.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Kent Overstreet <kmo@daterainc.com>

Btrfs has been doing bio splitting from btrfs_map_bio(), by checking
device limits as well as calling ->merge_bvec_fn() etc. That is not
necessary any more, because generic_make_request() is now able to
handle arbitrarily sized bios. So clean up unnecessary code paths.

Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Signed-off-by: Chris Mason <clm@fb.com>
[dpark: add more description in commit message]
Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
---
 fs/btrfs/volumes.c | 73 ------------------------------------------------------
 1 file changed, 73 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 50c5a87..c627bf8 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5691,34 +5691,6 @@ static noinline void btrfs_schedule_bio(struct btrfs_root *root,
 				 &device->work);
 }
 
-static int bio_size_ok(struct block_device *bdev, struct bio *bio,
-		       sector_t sector)
-{
-	struct bio_vec *prev;
-	struct request_queue *q = bdev_get_queue(bdev);
-	unsigned int max_sectors = queue_max_sectors(q);
-	struct bvec_merge_data bvm = {
-		.bi_bdev = bdev,
-		.bi_sector = sector,
-		.bi_rw = bio->bi_rw,
-	};
-
-	if (WARN_ON(bio->bi_vcnt == 0))
-		return 1;
-
-	prev = &bio->bi_io_vec[bio->bi_vcnt - 1];
-	if (bio_sectors(bio) > max_sectors)
-		return 0;
-
-	if (!q->merge_bvec_fn)
-		return 1;
-
-	bvm.bi_size = bio->bi_iter.bi_size - prev->bv_len;
-	if (q->merge_bvec_fn(q, &bvm, prev) < prev->bv_len)
-		return 0;
-	return 1;
-}
-
 static void submit_stripe_bio(struct btrfs_root *root, struct btrfs_bio *bbio,
 			      struct bio *bio, u64 physical, int dev_nr,
 			      int rw, int async)
@@ -5752,38 +5724,6 @@ static void submit_stripe_bio(struct btrfs_root *root, struct btrfs_bio *bbio,
 		btrfsic_submit_bio(rw, bio);
 }
 
-static int breakup_stripe_bio(struct btrfs_root *root, struct btrfs_bio *bbio,
-			      struct bio *first_bio, struct btrfs_device *dev,
-			      int dev_nr, int rw, int async)
-{
-	struct bio_vec *bvec = first_bio->bi_io_vec;
-	struct bio *bio;
-	int nr_vecs = bio_get_nr_vecs(dev->bdev);
-	u64 physical = bbio->stripes[dev_nr].physical;
-
-again:
-	bio = btrfs_bio_alloc(dev->bdev, physical >> 9, nr_vecs, GFP_NOFS);
-	if (!bio)
-		return -ENOMEM;
-
-	while (bvec <= (first_bio->bi_io_vec + first_bio->bi_vcnt - 1)) {
-		if (bio_add_page(bio, bvec->bv_page, bvec->bv_len,
-				 bvec->bv_offset) < bvec->bv_len) {
-			u64 len = bio->bi_iter.bi_size;
-
-			atomic_inc(&bbio->stripes_pending);
-			submit_stripe_bio(root, bbio, bio, physical, dev_nr,
-					  rw, async);
-			physical += len;
-			goto again;
-		}
-		bvec++;
-	}
-
-	submit_stripe_bio(root, bbio, bio, physical, dev_nr, rw, async);
-	return 0;
-}
-
 static void bbio_error(struct btrfs_bio *bbio, struct bio *bio, u64 logical)
 {
 	atomic_inc(&bbio->error);
@@ -5862,19 +5802,6 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 			continue;
 		}
 
-		/*
-		 * Check and see if we're ok with this bio based on it's size
-		 * and offset with the given device.
-		 */
-		if (!bio_size_ok(dev->bdev, first_bio,
-				 bbio->stripes[dev_nr].physical >> 9)) {
-			ret = breakup_stripe_bio(root, bbio, first_bio, dev,
-						 dev_nr, rw, async_submit);
-			BUG_ON(ret);
-			dev_nr++;
-			continue;
-		}
-
 		if (dev_nr < total_devs - 1) {
 			bio = btrfs_bio_clone(first_bio, GFP_NOFS);
 			BUG_ON(!bio); /* -ENOMEM */
-- 
2.1.0

