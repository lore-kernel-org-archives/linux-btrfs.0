Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36615 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754512AbcKYJPg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Nov 2016 04:15:36 -0500
From: Christoph Hellwig <hch@lst.de>
To: linux-btrfs@vger.kernel.org
Cc: Liu Bo <bo.li.liu@oracle.com>, Omar Sandoval <osandov@osandov.com>
Subject: [PATCH 8/8] btrfs: use bio_for_each_segment_all in __btrfsic_submit_bio
Date: Fri, 25 Nov 2016 09:07:53 +0100
Message-Id: <1480061273-5722-9-git-send-email-hch@lst.de>
In-Reply-To: <1480061273-5722-1-git-send-email-hch@lst.de>
References: <1480061273-5722-1-git-send-email-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

And remove the bogus check for a NULL return value from kmap, which
can't happen.  While we're at it: I don't think that kmapping up to 256
will work without deadlocks on highmem machines, a better idea would
be to use vm_map_ram to map all of them into a single virtual address
range.  Incidentally that would also simplify the code a lot.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/check-integrity.c | 30 +++++++++++-------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index a6f657f..86f681f 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -2819,10 +2819,11 @@ static void __btrfsic_submit_bio(struct bio *bio)
 	 * btrfsic_mount(), this might return NULL */
 	dev_state = btrfsic_dev_state_lookup(bio->bi_bdev);
 	if (NULL != dev_state &&
-	    (bio_op(bio) == REQ_OP_WRITE) && NULL != bio->bi_io_vec) {
+	    (bio_op(bio) == REQ_OP_WRITE) && bio_has_data(bio)) {
 		unsigned int i;
 		u64 dev_bytenr;
 		u64 cur_bytenr;
+		struct bio_vec *bvec;
 		int bio_is_patched;
 		char **mapped_datav;
 
@@ -2840,32 +2841,23 @@ static void __btrfsic_submit_bio(struct bio *bio)
 		if (!mapped_datav)
 			goto leave;
 		cur_bytenr = dev_bytenr;
-		for (i = 0; i < bio->bi_vcnt; i++) {
-			BUG_ON(bio->bi_io_vec[i].bv_len != PAGE_SIZE);
-			mapped_datav[i] = kmap(bio->bi_io_vec[i].bv_page);
-			if (!mapped_datav[i]) {
-				while (i > 0) {
-					i--;
-					kunmap(bio->bi_io_vec[i].bv_page);
-				}
-				kfree(mapped_datav);
-				goto leave;
-			}
+
+		bio_for_each_segment_all(bvec, bio, i) {
+			BUG_ON(bvec->bv_len != PAGE_SIZE);
+			mapped_datav[i] = kmap(bvec->bv_page);
+
 			if (dev_state->state->print_mask &
 			    BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH_VERBOSE)
 				pr_info("#%u: bytenr=%llu, len=%u, offset=%u\n",
-				       i, cur_bytenr, bio->bi_io_vec[i].bv_len,
-				       bio->bi_io_vec[i].bv_offset);
-			cur_bytenr += bio->bi_io_vec[i].bv_len;
+				       i, cur_bytenr, bvec->bv_len, bvec->bv_offset);
+			cur_bytenr += bvec->bv_len;
 		}
 		btrfsic_process_written_block(dev_state, dev_bytenr,
 					      mapped_datav, bio->bi_vcnt,
 					      bio, &bio_is_patched,
 					      NULL, bio->bi_opf);
-		while (i > 0) {
-			i--;
-			kunmap(bio->bi_io_vec[i].bv_page);
-		}
+		bio_for_each_segment_all(bvec, bio, i)
+			kunmap(bvec->bv_page);
 		kfree(mapped_datav);
 	} else if (NULL != dev_state && (bio->bi_opf & REQ_PREFLUSH)) {
 		if (dev_state->state->print_mask &
-- 
2.1.4

