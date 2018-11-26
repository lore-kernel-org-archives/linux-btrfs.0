Return-Path: <SRS0=mYd/=OF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3AA8C43610
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 02:19:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8ABE120865
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 02:19:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8ABE120865
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbeKZNMH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 26 Nov 2018 08:12:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53042 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbeKZNMG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Nov 2018 08:12:06 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 648E899C4B;
        Mon, 26 Nov 2018 02:19:30 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0FBBD194A7;
        Mon, 26 Nov 2018 02:19:20 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>,
        Omar Sandoval <osandov@fb.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Dave Chinner <dchinner@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>,
        linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>,
        Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
        Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org,
        Boaz Harrosh <ooo@electrozaur.com>,
        Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V12 09/20] block: use bio_for_each_bvec() to compute multi-page bvec count
Date:   Mon, 26 Nov 2018 10:17:09 +0800
Message-Id: <20181126021720.19471-10-ming.lei@redhat.com>
In-Reply-To: <20181126021720.19471-1-ming.lei@redhat.com>
References: <20181126021720.19471-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Mon, 26 Nov 2018 02:19:30 +0000 (UTC)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

First it is more efficient to use bio_for_each_bvec() in both
blk_bio_segment_split() and __blk_recalc_rq_segments() to compute how
many multi-page bvecs there are in the bio.

Secondly once bio_for_each_bvec() is used, the bvec may need to be
splitted because its length can be very longer than max segment size,
so we have to split the big bvec into several segments.

Thirdly when splitting multi-page bvec into segments, the max segment
limit may be reached, so the bio split need to be considered under
this situation too.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-merge.c | 100 +++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 80 insertions(+), 20 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 51ec6ca56a0a..2d8f388d43de 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -161,6 +161,70 @@ static inline unsigned get_max_io_size(struct request_queue *q,
 	return sectors;
 }
 
+static unsigned get_max_segment_size(struct request_queue *q,
+				     unsigned offset)
+{
+	unsigned long mask = queue_segment_boundary(q);
+
+	return min_t(unsigned long, mask - (mask & offset) + 1,
+		     queue_max_segment_size(q));
+}
+
+/*
+ * Split the bvec @bv into segments, and update all kinds of
+ * variables.
+ */
+static bool bvec_split_segs(struct request_queue *q, struct bio_vec *bv,
+		unsigned *nsegs, unsigned *last_seg_size,
+		unsigned *front_seg_size, unsigned *sectors)
+{
+	unsigned len = bv->bv_len;
+	unsigned total_len = 0;
+	unsigned new_nsegs = 0, seg_size = 0;
+
+	/*
+	 * Multipage bvec may be too big to hold in one segment,
+	 * so the current bvec has to be splitted as multiple
+	 * segments.
+	 */
+	while (len && new_nsegs + *nsegs < queue_max_segments(q)) {
+		seg_size = get_max_segment_size(q, bv->bv_offset + total_len);
+		seg_size = min(seg_size, len);
+
+		new_nsegs++;
+		total_len += seg_size;
+		len -= seg_size;
+
+		if ((bv->bv_offset + total_len) & queue_virt_boundary(q))
+			break;
+	}
+
+	if (!new_nsegs)
+		return !!len;
+
+	/* update front segment size */
+	if (!*nsegs) {
+		unsigned first_seg_size;
+
+		if (new_nsegs == 1)
+			first_seg_size = get_max_segment_size(q, bv->bv_offset);
+		else
+			first_seg_size = queue_max_segment_size(q);
+
+		if (*front_seg_size < first_seg_size)
+			*front_seg_size = first_seg_size;
+	}
+
+	/* update other varibles */
+	*last_seg_size = seg_size;
+	*nsegs += new_nsegs;
+	if (sectors)
+		*sectors += total_len >> 9;
+
+	/* split in the middle of the bvec if len != 0 */
+	return !!len;
+}
+
 static struct bio *blk_bio_segment_split(struct request_queue *q,
 					 struct bio *bio,
 					 struct bio_set *bs,
@@ -174,7 +238,7 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
 	struct bio *new = NULL;
 	const unsigned max_sectors = get_max_io_size(q, bio);
 
-	bio_for_each_segment(bv, bio, iter) {
+	bio_for_each_bvec(bv, bio, iter) {
 		/*
 		 * If the queue doesn't support SG gaps and adding this
 		 * offset would create a gap, disallow it.
@@ -189,8 +253,12 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
 			 */
 			if (nsegs < queue_max_segments(q) &&
 			    sectors < max_sectors) {
-				nsegs++;
-				sectors = max_sectors;
+				/* split in the middle of bvec */
+				bv.bv_len = (max_sectors - sectors) << 9;
+				bvec_split_segs(q, &bv, &nsegs,
+						&seg_size,
+						&front_seg_size,
+						&sectors);
 			}
 			goto split;
 		}
@@ -212,14 +280,12 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
 		if (nsegs == queue_max_segments(q))
 			goto split;
 
-		if (nsegs == 1 && seg_size > front_seg_size)
-			front_seg_size = seg_size;
-
-		nsegs++;
 		bvprv = bv;
 		bvprvp = &bvprv;
-		seg_size = bv.bv_len;
-		sectors += bv.bv_len >> 9;
+
+		if (bvec_split_segs(q, &bv, &nsegs, &seg_size,
+				    &front_seg_size, &sectors))
+			goto split;
 
 	}
 
@@ -233,8 +299,6 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
 			bio = new;
 	}
 
-	if (nsegs == 1 && seg_size > front_seg_size)
-		front_seg_size = seg_size;
 	bio->bi_seg_front_size = front_seg_size;
 	if (seg_size > bio->bi_seg_back_size)
 		bio->bi_seg_back_size = seg_size;
@@ -296,6 +360,7 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 {
 	struct bio_vec bv, bvprv = { NULL };
 	unsigned int seg_size, nr_phys_segs;
+	unsigned front_seg_size = bio->bi_seg_front_size;
 	struct bio *fbio, *bbio;
 	struct bvec_iter iter;
 	bool prev = false;
@@ -316,7 +381,7 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 	seg_size = 0;
 	nr_phys_segs = 0;
 	for_each_bio(bio) {
-		bio_for_each_segment(bv, bio, iter) {
+		bio_for_each_bvec(bv, bio, iter) {
 			/*
 			 * If SG merging is disabled, each bio vector is
 			 * a segment
@@ -336,20 +401,15 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 				continue;
 			}
 new_segment:
-			if (nr_phys_segs == 1 && seg_size >
-			    fbio->bi_seg_front_size)
-				fbio->bi_seg_front_size = seg_size;
-
-			nr_phys_segs++;
 			bvprv = bv;
 			prev = true;
-			seg_size = bv.bv_len;
+			bvec_split_segs(q, &bv, &nr_phys_segs, &seg_size,
+					&front_seg_size, NULL);
 		}
 		bbio = bio;
 	}
 
-	if (nr_phys_segs == 1 && seg_size > fbio->bi_seg_front_size)
-		fbio->bi_seg_front_size = seg_size;
+	fbio->bi_seg_front_size = front_seg_size;
 	if (seg_size > bbio->bi_seg_back_size)
 		bbio->bi_seg_back_size = seg_size;
 
-- 
2.9.5

