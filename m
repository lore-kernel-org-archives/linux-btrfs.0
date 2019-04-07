Return-Path: <SRS0=Yn0v=SJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18AF5C282DE
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Apr 2019 08:53:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5D8C20B1F
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Apr 2019 08:53:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbfDGIxe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 7 Apr 2019 04:53:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58032 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725996AbfDGIxd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 7 Apr 2019 04:53:33 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EBD95F74A7;
        Sun,  7 Apr 2019 08:53:32 +0000 (UTC)
Received: from localhost (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B43C719C56;
        Sun,  7 Apr 2019 08:53:29 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH V2] block: don't use for-inside-for in bio_for_each_segment_all
Date:   Sun,  7 Apr 2019 16:53:25 +0800
Message-Id: <20190407085325.9380-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Sun, 07 Apr 2019 08:53:33 +0000 (UTC)
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
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/bio.h  | 20 ++++++++++++--------
 include/linux/bvec.h | 23 +++++++++++++++--------
 2 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index bb6090aa165d..9c583bf98ff9 100644
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
+					 struct bvec_iter_all *iter)
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
index f6275c4da13a..67eda310b643 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -47,8 +47,9 @@ struct bvec_iter {
 
 struct bvec_iter_all {
 	struct bio_vec	bv;
-	int		idx;
-	unsigned	done;
+	int		idx;		/* current index into bvec table */
+	unsigned	bvec_done;	/* number of bytes completed in
+					   currnet bvec	*/
 };
 
 static inline struct page *bvec_nth_page(struct page *page, int idx)
@@ -145,18 +146,18 @@ static inline bool bvec_iter_advance(const struct bio_vec *bv,
 
 static inline struct bio_vec *bvec_init_iter_all(struct bvec_iter_all *iter_all)
 {
-	iter_all->bv.bv_page = NULL;
-	iter_all->done = 0;
+	iter_all->bvec_done = 0;
+	iter_all->idx = 0;
 
 	return &iter_all->bv;
 }
 
-static inline void mp_bvec_next_segment(const struct bio_vec *bvec,
-					struct bvec_iter_all *iter_all)
+static inline void bvec_advance(const struct bio_vec *bvec,
+		struct bvec_iter_all *iter_all)
 {
 	struct bio_vec *bv = &iter_all->bv;
 
-	if (bv->bv_page) {
+	if (iter_all->bvec_done) {
 		bv->bv_page = nth_page(bv->bv_page, 1);
 		bv->bv_offset = 0;
 	} else {
@@ -164,7 +165,13 @@ static inline void mp_bvec_next_segment(const struct bio_vec *bvec,
 		bv->bv_offset = bvec->bv_offset;
 	}
 	bv->bv_len = min_t(unsigned int, PAGE_SIZE - bv->bv_offset,
-			   bvec->bv_len - iter_all->done);
+			   bvec->bv_len - iter_all->bvec_done);
+	iter_all->bvec_done += bv->bv_len;
+
+	if (iter_all->bvec_done == bvec->bv_len) {
+		iter_all->idx++;
+		iter_all->bvec_done = 0;
+	}
 }
 
 /*
-- 
2.9.5

