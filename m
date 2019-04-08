Return-Path: <SRS0=zp8L=SK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77C26C282DE
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 11:02:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E3FD20857
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 11:02:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbfDHLCt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Apr 2019 07:02:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57532 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725881AbfDHLCt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Apr 2019 07:02:49 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2D57261D07;
        Mon,  8 Apr 2019 11:02:49 +0000 (UTC)
Received: from localhost (ovpn-8-31.pek2.redhat.com [10.72.8.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2461E68D51;
        Mon,  8 Apr 2019 11:02:44 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH V3] block: don't use for-inside-for in bio_for_each_segment_all
Date:   Mon,  8 Apr 2019 19:02:38 +0800
Message-Id: <20190408110238.30478-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Mon, 08 Apr 2019 11:02:49 +0000 (UTC)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Commit 6dc4f100c175 ("block: allow bio_for_each_segment_all() to
iterate over multi-page bvec") changes bio_for_each_segment_all()
to use for-inside-for.

This way breaks all bio_for_each_segment_all() call with error out
branch via 'break', since now 'break' can only break from the inner
loop.

Fixes this issue by implementing bio_for_each_segment_all() via
single 'for' loop, and now the logic is very similar with normal
bvec iterator.

Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: Omar Sandoval <osandov@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Reported-and-Tested-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
Fixes: 6dc4f100c175 ("block: allow bio_for_each_segment_all() to iterate over multi-page bvec")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
V3:
	- don't rename for avoiding conflict with hch's patches
V2:
	- address comments: avoid explicated expressiones in macro, naming


 include/linux/bio.h  | 20 ++++++++++++--------
 include/linux/bvec.h | 14 ++++++++++----
 2 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index bb6090aa165d..e584673c1881 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -120,19 +120,23 @@ static inline bool bio_full(struct bio *bio)
 	return bio->bi_vcnt >= bio->bi_max_vecs;
 }
 
-#define mp_bvec_for_each_segment(bv, bvl, i, iter_all)			\
-	for (bv = bvec_init_iter_all(&iter_all);			\
-		(iter_all.done < (bvl)->bv_len) &&			\
-		(mp_bvec_next_segment((bvl), &iter_all), 1);		\
-		iter_all.done += bv->bv_len, i += 1)
+static inline bool bio_next_segment(const struct bio *bio,
+				    struct bvec_iter_all *iter)
+{
+	if (iter->idx >= bio->bi_vcnt)
+		return false;
+
+	bvec_advance(&bio->bi_io_vec[iter->idx], iter);
+	return true;
+}
 
 /*
  * drivers should _never_ use the all version - the bio may have been split
  * before it got to the driver and the driver won't own all of it
  */
-#define bio_for_each_segment_all(bvl, bio, i, iter_all)		\
-	for (i = 0, iter_all.idx = 0; iter_all.idx < (bio)->bi_vcnt; iter_all.idx++)	\
-		mp_bvec_for_each_segment(bvl, &((bio)->bi_io_vec[iter_all.idx]), i, iter_all)
+#define bio_for_each_segment_all(bvl, bio, i, iter)			\
+	for (i = 0, bvl = bvec_init_iter_all(&iter);			\
+	     bio_next_segment((bio), &iter); i++)
 
 static inline void bio_advance_iter(struct bio *bio, struct bvec_iter *iter,
 				    unsigned bytes)
diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index f6275c4da13a..3bc91879e1e2 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -145,18 +145,18 @@ static inline bool bvec_iter_advance(const struct bio_vec *bv,
 
 static inline struct bio_vec *bvec_init_iter_all(struct bvec_iter_all *iter_all)
 {
-	iter_all->bv.bv_page = NULL;
 	iter_all->done = 0;
+	iter_all->idx = 0;
 
 	return &iter_all->bv;
 }
 
-static inline void mp_bvec_next_segment(const struct bio_vec *bvec,
-					struct bvec_iter_all *iter_all)
+static inline void bvec_advance(const struct bio_vec *bvec,
+				struct bvec_iter_all *iter_all)
 {
 	struct bio_vec *bv = &iter_all->bv;
 
-	if (bv->bv_page) {
+	if (iter_all->done) {
 		bv->bv_page = nth_page(bv->bv_page, 1);
 		bv->bv_offset = 0;
 	} else {
@@ -165,6 +165,12 @@ static inline void mp_bvec_next_segment(const struct bio_vec *bvec,
 	}
 	bv->bv_len = min_t(unsigned int, PAGE_SIZE - bv->bv_offset,
 			   bvec->bv_len - iter_all->done);
+	iter_all->done += bv->bv_len;
+
+	if (iter_all->done == bvec->bv_len) {
+		iter_all->idx++;
+		iter_all->done = 0;
+	}
 }
 
 /*
-- 
2.9.5

