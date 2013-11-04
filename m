Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:35816 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab3KDXgm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Nov 2013 18:36:42 -0500
Received: by mail-pb0-f50.google.com with SMTP id uo15so34233pbc.37
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Nov 2013 15:36:41 -0800 (PST)
From: Kent Overstreet <kmo@daterainc.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Cc: axboe@kernel.dk, hch@infradead.org, Kent Overstreet <kmo@daterainc.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Asai Thambi S P <asamymuthupa@micron.com>
Subject: [PATCH 3/9] block: Move bouncing to generic_make_request()
Date: Mon,  4 Nov 2013 15:36:21 -0800
Message-Id: <1383608187-27368-4-git-send-email-kmo@daterainc.com>
In-Reply-To: <1383608187-27368-1-git-send-email-kmo@daterainc.com>
References: <1383608187-27368-1-git-send-email-kmo@daterainc.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Next patch is going to make generic_make_request() handle arbitrary
sized bios by splitting them if necessary. It makes more sense to call
blk_queue_bounce() first, partly so it's working on larger bios - but also the
code that splits bios, and __blk_recalc_rq_segments(), won't have to take into
account bouncing (as it'll already have been done).

Also, __blk_recalc_rq_segments() now doesn't have to take into account
potential bouncing - it's already been done.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Asai Thambi S P <asamymuthupa@micron.com>
---
 block/blk-core.c                  | 14 +++++++-------
 block/blk-merge.c                 | 13 ++++---------
 drivers/block/mtip32xx/mtip32xx.c |  2 --
 drivers/block/pktcdvd.c           |  2 --
 4 files changed, 11 insertions(+), 20 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index d9cab97..3c7467e 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1466,13 +1466,6 @@ void blk_queue_bio(struct request_queue *q, struct bio *bio)
 	struct request *req;
 	unsigned int request_count = 0;
 
-	/*
-	 * low level driver can indicate that it wants pages above a
-	 * certain limit bounced to low memory (ie for highmem, or even
-	 * ISA dma in theory)
-	 */
-	blk_queue_bounce(q, &bio);
-
 	if (bio_integrity_enabled(bio) && bio_integrity_prep(bio)) {
 		bio_endio(bio, -EIO);
 		return;
@@ -1822,6 +1815,13 @@ void generic_make_request(struct bio *bio)
 	do {
 		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
 
+		/*
+		 * low level driver can indicate that it wants pages above a
+		 * certain limit bounced to low memory (ie for highmem, or even
+		 * ISA dma in theory)
+		 */
+		blk_queue_bounce(q, &bio);
+
 		q->make_request_fn(q, bio);
 
 		bio = bio_list_pop(current->bio_list);
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 953b8df..9680ec73 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -13,7 +13,7 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 					     struct bio *bio)
 {
 	struct bio_vec bv, bvprv = { NULL };
-	int cluster, high, highprv = 1;
+	int cluster, prev = 0;
 	unsigned int seg_size, nr_phys_segs;
 	struct bio *fbio, *bbio;
 	struct bvec_iter iter;
@@ -27,13 +27,7 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 	nr_phys_segs = 0;
 	for_each_bio(bio) {
 		bio_for_each_segment(bv, bio, iter) {
-			/*
-			 * the trick here is making sure that a high page is
-			 * never considered part of another segment, since that
-			 * might change with the bounce page.
-			 */
-			high = page_to_pfn(bv.bv_page) > queue_bounce_pfn(q);
-			if (!high && !highprv && cluster) {
+			if (prev && cluster) {
 				if (seg_size + bv.bv_len
 				    > queue_max_segment_size(q))
 					goto new_segment;
@@ -44,6 +38,7 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 
 				seg_size += bv.bv_len;
 				bvprv = bv;
+				prev = 1;
 				continue;
 			}
 new_segment:
@@ -53,8 +48,8 @@ new_segment:
 
 			nr_phys_segs++;
 			bvprv = bv;
+			prev = 1;
 			seg_size = bv.bv_len;
-			highprv = high;
 		}
 		bbio = bio;
 	}
diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 52b2f2a..d4c669b 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -4016,8 +4016,6 @@ static void mtip_make_request(struct request_queue *queue, struct bio *bio)
 
 	sg = mtip_hw_get_scatterlist(dd, &tag, unaligned);
 	if (likely(sg != NULL)) {
-		blk_queue_bounce(queue, &bio);
-
 		if (unlikely((bio)->bi_vcnt > MTIP_MAX_SG)) {
 			dev_warn(&dd->pdev->dev,
 				"Maximum number of SGL entries exceeded\n");
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 1bf1f22..7991cc8 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2486,8 +2486,6 @@ static void pkt_make_request(struct request_queue *q, struct bio *bio)
 		goto end_io;
 	}
 
-	blk_queue_bounce(q, &bio);
-
 	do {
 		sector_t zone = get_zone(bio->bi_iter.bi_sector, pd);
 		sector_t last_zone = get_zone(bio_end_sector(bio) - 1, pd);
-- 
1.8.4.rc3

