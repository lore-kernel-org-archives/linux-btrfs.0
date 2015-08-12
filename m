Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:49453 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933581AbbHLHIM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Aug 2015 03:08:12 -0400
From: Ming Lin <mlin@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Dongsu Park <dpark@posteo.net>, Mike Snitzer <snitzer@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lin <mlin@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
        Ming Lin <ming.l@ssi.samsung.com>
Subject: [PATCH v6 04/11] btrfs: remove bio splitting and merge_bvec_fn() calls
Date: Wed, 12 Aug 2015 00:07:14 -0700
Message-Id: <1439363241-31772-5-git-send-email-mlin@kernel.org>
In-Reply-To: <1439363241-31772-1-git-send-email-mlin@kernel.org>
References: <1439363241-31772-1-git-send-email-mlin@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Kent Overstreet <kent.overstreet@gmail.com>

Btrfs has been doing bio splitting from btrfs_map_bio(), by checking
device limits as well as calling ->merge_bvec_fn() etc. That is not
necessary any more, because generic_make_request() is now able to
handle arbitrarily sized bios. So clean up unnecessary code paths.

Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
Signed-off-by: Chris Mason <clm@fb.com>
[dpark: add more description in commit message]
Signed-off-by: Dongsu Park <dpark@posteo.net>
Signed-off-by: Ming Lin <ming.l@ssi.samsung.com>
---
 fs/btrfs/volumes.c | 72 ------------------------------------------------------
 1 file changed, 72 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index fbe7c10..1b52313 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5871,34 +5871,6 @@ static noinline void btrfs_schedule_bio(struct btrfs_root *root,
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
@@ -5932,38 +5904,6 @@ static void submit_stripe_bio(struct btrfs_root *root, struct btrfs_bio *bbio,
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
@@ -6036,18 +5976,6 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
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
-			continue;
-		}
-
 		if (dev_nr < total_devs - 1) {
 			bio = btrfs_bio_clone(first_bio, GFP_NOFS);
 			BUG_ON(!bio); /* -ENOMEM */
-- 
2.1.4

