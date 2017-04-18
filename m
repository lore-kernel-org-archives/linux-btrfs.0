Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44705 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755751AbdDRBRz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Apr 2017 21:17:55 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v3I1Hr7E017647
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Apr 2017 01:17:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v3I1Hr48026023
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Apr 2017 01:17:53 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v3I1HrZv021782
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Apr 2017 01:17:53 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/6] Btrfs: change check-integrity to use bvec_iter
Date: Mon, 17 Apr 2017 18:16:26 -0700
Message-Id: <1492478187-24875-6-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1492478187-24875-1-git-send-email-bo.li.liu@oracle.com>
References: <1492478187-24875-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some check-integrity code depends on bio->bi_vcnt, this changes it to use
bio segments because some bios passing here may not have a reliable
bi_vcnt.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/check-integrity.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index ab14c2e..8e7ce48 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -2822,44 +2822,47 @@ static void __btrfsic_submit_bio(struct bio *bio)
 	dev_state = btrfsic_dev_state_lookup(bio->bi_bdev);
 	if (NULL != dev_state &&
 	    (bio_op(bio) == REQ_OP_WRITE) && bio_has_data(bio)) {
-		unsigned int i;
+		unsigned int i = 0;
 		u64 dev_bytenr;
 		u64 cur_bytenr;
-		struct bio_vec *bvec;
+		struct bio_vec bvec;
+		struct bvec_iter iter;
 		int bio_is_patched;
 		char **mapped_datav;
+		int segs = bio_segments(bio);
 
 		dev_bytenr = 512 * bio->bi_iter.bi_sector;
 		bio_is_patched = 0;
 		if (dev_state->state->print_mask &
 		    BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH)
 			pr_info("submit_bio(rw=%d,0x%x, bi_vcnt=%u, bi_sector=%llu (bytenr %llu), bi_bdev=%p)\n",
-			       bio_op(bio), bio->bi_opf, bio->bi_vcnt,
+			       bio_op(bio), bio->bi_opf, segs,
 			       (unsigned long long)bio->bi_iter.bi_sector,
 			       dev_bytenr, bio->bi_bdev);
 
-		mapped_datav = kmalloc_array(bio->bi_vcnt,
+		mapped_datav = kmalloc_array(segs,
 					     sizeof(*mapped_datav), GFP_NOFS);
 		if (!mapped_datav)
 			goto leave;
 		cur_bytenr = dev_bytenr;
 
-		bio_for_each_segment_all(bvec, bio, i) {
-			BUG_ON(bvec->bv_len != PAGE_SIZE);
-			mapped_datav[i] = kmap(bvec->bv_page);
+		bio_for_each_segment(bvec, bio, iter) {
+			BUG_ON(bvec.bv_len != PAGE_SIZE);
+			mapped_datav[i] = kmap(bvec.bv_page);
+			i++;
 
 			if (dev_state->state->print_mask &
 			    BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH_VERBOSE)
 				pr_info("#%u: bytenr=%llu, len=%u, offset=%u\n",
-				       i, cur_bytenr, bvec->bv_len, bvec->bv_offset);
-			cur_bytenr += bvec->bv_len;
+				       i, cur_bytenr, bvec.bv_len, bvec.bv_offset);
+			cur_bytenr += bvec.bv_len;
 		}
 		btrfsic_process_written_block(dev_state, dev_bytenr,
-					      mapped_datav, bio->bi_vcnt,
+					      mapped_datav, segs,
 					      bio, &bio_is_patched,
 					      NULL, bio->bi_opf);
-		bio_for_each_segment_all(bvec, bio, i)
-			kunmap(bvec->bv_page);
+		bio_for_each_segment(bvec, bio, iter)
+			kunmap(bvec.bv_page);
 		kfree(mapped_datav);
 	} else if (NULL != dev_state && (bio->bi_opf & REQ_PREFLUSH)) {
 		if (dev_state->state->print_mask &
-- 
2.5.5

