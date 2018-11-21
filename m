Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B7E9C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 03:26:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DFA021104
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 03:26:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0DFA021104
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbeKUN6i (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Nov 2018 08:58:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58696 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726165AbeKUN6h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Nov 2018 08:58:37 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 59539308428D;
        Wed, 21 Nov 2018 03:26:06 +0000 (UTC)
Received: from localhost (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA5367D2CF;
        Wed, 21 Nov 2018 03:25:48 +0000 (UTC)
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
Subject: [PATCH V11 05/19] block: use bio_for_each_bvec() to map sg
Date:   Wed, 21 Nov 2018 11:23:13 +0800
Message-Id: <20181121032327.8434-6-ming.lei@redhat.com>
In-Reply-To: <20181121032327.8434-1-ming.lei@redhat.com>
References: <20181121032327.8434-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Wed, 21 Nov 2018 03:26:06 +0000 (UTC)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

It is more efficient to use bio_for_each_bvec() to map sg, meantime
we have to consider splitting multipage bvec as done in blk_bio_segment_split().

Reviewed-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-merge.c | 68 +++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 48 insertions(+), 20 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index ec0b93fa1ff8..8829c51b4e75 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -455,6 +455,52 @@ static int blk_phys_contig_segment(struct request_queue *q, struct bio *bio,
 	return biovec_phys_mergeable(q, &end_bv, &nxt_bv);
 }
 
+static struct scatterlist *blk_next_sg(struct scatterlist **sg,
+		struct scatterlist *sglist)
+{
+	if (!*sg)
+		return sglist;
+
+	/*
+	 * If the driver previously mapped a shorter list, we could see a
+	 * termination bit prematurely unless it fully inits the sg table
+	 * on each mapping. We KNOW that there must be more entries here
+	 * or the driver would be buggy, so force clear the termination bit
+	 * to avoid doing a full sg_init_table() in drivers for each command.
+	 */
+	sg_unmark_end(*sg);
+	return sg_next(*sg);
+}
+
+static unsigned blk_bvec_map_sg(struct request_queue *q,
+		struct bio_vec *bvec, struct scatterlist *sglist,
+		struct scatterlist **sg)
+{
+	unsigned nbytes = bvec->bv_len;
+	unsigned nsegs = 0, total = 0;
+
+	while (nbytes > 0) {
+		unsigned seg_size;
+		struct page *pg;
+		unsigned offset, idx;
+
+		*sg = blk_next_sg(sg, sglist);
+
+		seg_size = min(nbytes, queue_max_segment_size(q));
+		offset = (total + bvec->bv_offset) % PAGE_SIZE;
+		idx = (total + bvec->bv_offset) / PAGE_SIZE;
+		pg = nth_page(bvec->bv_page, idx);
+
+		sg_set_page(*sg, pg, seg_size, offset);
+
+		total += seg_size;
+		nbytes -= seg_size;
+		nsegs++;
+	}
+
+	return nsegs;
+}
+
 static inline void
 __blk_segment_map_sg(struct request_queue *q, struct bio_vec *bvec,
 		     struct scatterlist *sglist, struct bio_vec *bvprv,
@@ -472,25 +518,7 @@ __blk_segment_map_sg(struct request_queue *q, struct bio_vec *bvec,
 		(*sg)->length += nbytes;
 	} else {
 new_segment:
-		if (!*sg)
-			*sg = sglist;
-		else {
-			/*
-			 * If the driver previously mapped a shorter
-			 * list, we could see a termination bit
-			 * prematurely unless it fully inits the sg
-			 * table on each mapping. We KNOW that there
-			 * must be more entries here or the driver
-			 * would be buggy, so force clear the
-			 * termination bit to avoid doing a full
-			 * sg_init_table() in drivers for each command.
-			 */
-			sg_unmark_end(*sg);
-			*sg = sg_next(*sg);
-		}
-
-		sg_set_page(*sg, bvec->bv_page, nbytes, bvec->bv_offset);
-		(*nsegs)++;
+		(*nsegs) += blk_bvec_map_sg(q, bvec, sglist, sg);
 	}
 	*bvprv = *bvec;
 }
@@ -512,7 +540,7 @@ static int __blk_bios_map_sg(struct request_queue *q, struct bio *bio,
 	int cluster = blk_queue_cluster(q), nsegs = 0;
 
 	for_each_bio(bio)
-		bio_for_each_segment(bvec, bio, iter)
+		bio_for_each_bvec(bvec, bio, iter)
 			__blk_segment_map_sg(q, &bvec, sglist, &bvprv, sg,
 					     &nsegs, &cluster);
 
-- 
2.9.5

