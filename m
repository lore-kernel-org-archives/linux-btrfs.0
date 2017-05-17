Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18977 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754434AbdEQXXd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 19:23:33 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v4HNNVI5014230
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 17 May 2017 23:23:31 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v4HNNVgk023490
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 17 May 2017 23:23:31 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v4HNNVZA023866
        for <linux-btrfs@vger.kernel.org>; Wed, 17 May 2017 23:23:31 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/8] Btrfs: make check-integrity use bvec_iter
Date: Wed, 17 May 2017 16:22:50 -0600
Message-Id: <20170517222252.29242-7-bo.li.liu@oracle.com>
In-Reply-To: <20170517222252.29242-1-bo.li.liu@oracle.com>
References: <20170517222252.29242-1-bo.li.liu@oracle.com>
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
index ab14c2e..6b080f1 100644
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
+		unsigned int segs = bio_segments(bio);
 
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
2.9.4

