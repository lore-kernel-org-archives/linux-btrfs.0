Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52272 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602AbaLVLtu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Dec 2014 06:49:50 -0500
Received: by mail-wg0-f44.google.com with SMTP id b13so6470258wgh.3
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 03:49:49 -0800 (PST)
From: Dongsu Park <dongsu.park@profitbricks.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>,
        Ming Lin <mlin@minggr.net>, Dongsu Park <dongsu.park@profitbricks.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org
Subject: [RFC PATCH 05/17] btrfs: remove bio splitting and merge_bvec_fn() calls
Date: Mon, 22 Dec 2014 12:48:32 +0100
Message-Id: <e4b7b017eaa81784889ebb2a4e6a7d4366adf13a.1419241597.git.dongsu.park@profitbricks.com>
In-Reply-To: <bb0051ceb5805896089ded26c0f7f06758b25105.1419241597.git.dongsu.park@profitbricks.com>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
 <d26a9a0fc9a7d1529c115785ee5935d5750782bd.1419241597.git.dongsu.park@profitbricks.com>
 <f67d71b4a375ab504c2fc02e94a9d2a651686cab.1419241597.git.dongsu.park@profitbricks.com>
 <fe96db02d805ca6191dd605d03dac0d04c926fc1.1419241597.git.dongsu.park@profitbricks.com>
 <bb0051ceb5805896089ded26c0f7f06758b25105.1419241597.git.dongsu.park@profitbricks.com>
In-Reply-To: <cover.1419241597.git.dongsu.park@profitbricks.com>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Kent Overstreet <kmo@daterainc.com>

Btrfs has been doing bio splitting from btrfs_map_bio(), by checking
device limits as well as calling ->merge_bvec_fn() etc. That is not
necessary any more, because generic_make_request() is now able to
handle arbitrarily sized bios. So clean up unnecessary code paths.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
[dpark: add more description in commit message]
Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
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

