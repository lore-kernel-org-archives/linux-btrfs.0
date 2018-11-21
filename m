Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B634C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 03:28:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3472E21104
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 03:28:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3472E21104
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbeKUOA2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Nov 2018 09:00:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44128 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726967AbeKUOA1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Nov 2018 09:00:27 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 81F973083390;
        Wed, 21 Nov 2018 03:27:55 +0000 (UTC)
Received: from localhost (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 091845D75D;
        Wed, 21 Nov 2018 03:27:47 +0000 (UTC)
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
Subject: [PATCH V11 13/19] block: move bounce_clone_bio into bio.c
Date:   Wed, 21 Nov 2018 11:23:21 +0800
Message-Id: <20181121032327.8434-14-ming.lei@redhat.com>
In-Reply-To: <20181121032327.8434-1-ming.lei@redhat.com>
References: <20181121032327.8434-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Wed, 21 Nov 2018 03:27:55 +0000 (UTC)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We will reuse bounce_clone_bio() for cloning bio in case of
!blk_queue_cluster(q), so move this helper into bio.c and
rename it as bio_clone_bioset().

No function change.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/bio.c    | 69 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 block/blk.h    |  2 ++
 block/bounce.c | 70 +---------------------------------------------------------
 3 files changed, 72 insertions(+), 69 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 2680aa42a625..0f1635b9ec50 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -647,6 +647,75 @@ struct bio *bio_clone_fast(struct bio *bio, gfp_t gfp_mask, struct bio_set *bs)
 }
 EXPORT_SYMBOL(bio_clone_fast);
 
+/* block core only helper */
+struct bio *bio_clone_bioset(struct bio *bio_src, gfp_t gfp_mask,
+			     struct bio_set *bs)
+{
+	struct bvec_iter iter;
+	struct bio_vec bv;
+	struct bio *bio;
+
+	/*
+	 * Pre immutable biovecs, __bio_clone() used to just do a memcpy from
+	 * bio_src->bi_io_vec to bio->bi_io_vec.
+	 *
+	 * We can't do that anymore, because:
+	 *
+	 *  - The point of cloning the biovec is to produce a bio with a biovec
+	 *    the caller can modify: bi_idx and bi_bvec_done should be 0.
+	 *
+	 *  - The original bio could've had more than BIO_MAX_PAGES biovecs; if
+	 *    we tried to clone the whole thing bio_alloc_bioset() would fail.
+	 *    But the clone should succeed as long as the number of biovecs we
+	 *    actually need to allocate is fewer than BIO_MAX_PAGES.
+	 *
+	 *  - Lastly, bi_vcnt should not be looked at or relied upon by code
+	 *    that does not own the bio - reason being drivers don't use it for
+	 *    iterating over the biovec anymore, so expecting it to be kept up
+	 *    to date (i.e. for clones that share the parent biovec) is just
+	 *    asking for trouble and would force extra work on
+	 *    __bio_clone_fast() anyways.
+	 */
+
+	bio = bio_alloc_bioset(gfp_mask, bio_segments(bio_src), bs);
+	if (!bio)
+		return NULL;
+	bio->bi_disk		= bio_src->bi_disk;
+	bio->bi_opf		= bio_src->bi_opf;
+	bio->bi_ioprio		= bio_src->bi_ioprio;
+	bio->bi_write_hint	= bio_src->bi_write_hint;
+	bio->bi_iter.bi_sector	= bio_src->bi_iter.bi_sector;
+	bio->bi_iter.bi_size	= bio_src->bi_iter.bi_size;
+
+	switch (bio_op(bio)) {
+	case REQ_OP_DISCARD:
+	case REQ_OP_SECURE_ERASE:
+	case REQ_OP_WRITE_ZEROES:
+		break;
+	case REQ_OP_WRITE_SAME:
+		bio->bi_io_vec[bio->bi_vcnt++] = bio_src->bi_io_vec[0];
+		break;
+	default:
+		bio_for_each_segment(bv, bio_src, iter)
+			bio->bi_io_vec[bio->bi_vcnt++] = bv;
+		break;
+	}
+
+	if (bio_integrity(bio_src)) {
+		int ret;
+
+		ret = bio_integrity_clone(bio, bio_src, gfp_mask);
+		if (ret < 0) {
+			bio_put(bio);
+			return NULL;
+		}
+	}
+
+	bio_clone_blkcg_association(bio, bio_src);
+
+	return bio;
+}
+
 /**
  *	bio_add_pc_page	-	attempt to add page to bio
  *	@q: the target queue
diff --git a/block/blk.h b/block/blk.h
index 816a9abb87cd..31c0e45aba3a 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -336,6 +336,8 @@ static inline int blk_iolatency_init(struct request_queue *q) { return 0; }
 
 struct bio *blk_next_bio(struct bio *bio, unsigned int nr_pages, gfp_t gfp);
 
+struct bio *bio_clone_bioset(struct bio *bio_src, gfp_t gfp_mask, struct bio_set *bs);
+
 #ifdef CONFIG_BLK_DEV_ZONED
 void blk_queue_free_zone_bitmaps(struct request_queue *q);
 #else
diff --git a/block/bounce.c b/block/bounce.c
index 7338041e3042..4947c36173b2 100644
--- a/block/bounce.c
+++ b/block/bounce.c
@@ -215,74 +215,6 @@ static void bounce_end_io_read_isa(struct bio *bio)
 	__bounce_end_io_read(bio, &isa_page_pool);
 }
 
-static struct bio *bounce_clone_bio(struct bio *bio_src, gfp_t gfp_mask,
-		struct bio_set *bs)
-{
-	struct bvec_iter iter;
-	struct bio_vec bv;
-	struct bio *bio;
-
-	/*
-	 * Pre immutable biovecs, __bio_clone() used to just do a memcpy from
-	 * bio_src->bi_io_vec to bio->bi_io_vec.
-	 *
-	 * We can't do that anymore, because:
-	 *
-	 *  - The point of cloning the biovec is to produce a bio with a biovec
-	 *    the caller can modify: bi_idx and bi_bvec_done should be 0.
-	 *
-	 *  - The original bio could've had more than BIO_MAX_PAGES biovecs; if
-	 *    we tried to clone the whole thing bio_alloc_bioset() would fail.
-	 *    But the clone should succeed as long as the number of biovecs we
-	 *    actually need to allocate is fewer than BIO_MAX_PAGES.
-	 *
-	 *  - Lastly, bi_vcnt should not be looked at or relied upon by code
-	 *    that does not own the bio - reason being drivers don't use it for
-	 *    iterating over the biovec anymore, so expecting it to be kept up
-	 *    to date (i.e. for clones that share the parent biovec) is just
-	 *    asking for trouble and would force extra work on
-	 *    __bio_clone_fast() anyways.
-	 */
-
-	bio = bio_alloc_bioset(gfp_mask, bio_segments(bio_src), bs);
-	if (!bio)
-		return NULL;
-	bio->bi_disk		= bio_src->bi_disk;
-	bio->bi_opf		= bio_src->bi_opf;
-	bio->bi_ioprio		= bio_src->bi_ioprio;
-	bio->bi_write_hint	= bio_src->bi_write_hint;
-	bio->bi_iter.bi_sector	= bio_src->bi_iter.bi_sector;
-	bio->bi_iter.bi_size	= bio_src->bi_iter.bi_size;
-
-	switch (bio_op(bio)) {
-	case REQ_OP_DISCARD:
-	case REQ_OP_SECURE_ERASE:
-	case REQ_OP_WRITE_ZEROES:
-		break;
-	case REQ_OP_WRITE_SAME:
-		bio->bi_io_vec[bio->bi_vcnt++] = bio_src->bi_io_vec[0];
-		break;
-	default:
-		bio_for_each_segment(bv, bio_src, iter)
-			bio->bi_io_vec[bio->bi_vcnt++] = bv;
-		break;
-	}
-
-	if (bio_integrity(bio_src)) {
-		int ret;
-
-		ret = bio_integrity_clone(bio, bio_src, gfp_mask);
-		if (ret < 0) {
-			bio_put(bio);
-			return NULL;
-		}
-	}
-
-	bio_clone_blkcg_association(bio, bio_src);
-
-	return bio;
-}
-
 static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
 			       mempool_t *pool)
 {
@@ -311,7 +243,7 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
 		generic_make_request(*bio_orig);
 		*bio_orig = bio;
 	}
-	bio = bounce_clone_bio(*bio_orig, GFP_NOIO, passthrough ? NULL :
+	bio = bio_clone_bioset(*bio_orig, GFP_NOIO, passthrough ? NULL :
 			&bounce_bio_set);
 
 	bio_for_each_segment_all(to, bio, i, iter_all) {
-- 
2.9.5

