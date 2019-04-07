Return-Path: <SRS0=Yn0v=SJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA3CCC282DF
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Apr 2019 06:52:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9396021738
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Apr 2019 06:52:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbfDGGwT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 7 Apr 2019 02:52:19 -0400
Received: from verein.lst.de ([213.95.11.211]:35776 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726019AbfDGGwT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 7 Apr 2019 02:52:19 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 38C8A68B02; Sun,  7 Apr 2019 08:52:06 +0200 (CEST)
Date:   Sun, 7 Apr 2019 08:52:05 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] block: don't use for-inside-for in
 bio_for_each_segment_all
Message-ID: <20190407065205.GA8799@lst.de>
References: <20190406215428.3131-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190406215428.3131-1-ming.lei@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The change itself looks fine to be, but a few comments on semingly
unrelated changes:

> +#define bio_for_each_segment_all(bvl, bio, i, iter_all)			\
> +	for (i = 0, bvl = bvec_init_iter_all(&iter_all);		\
> +		iter_all.idx < (bio)->bi_vcnt &&			\
> +		(mp_bvec_advance(&((bio)->bi_io_vec[iter_all.idx]),	\
> +				 &iter_all), 1); i++)

Instead of the complicated expression inside the for loop test
expression can't we move the index check into mp_bvec_advance and let
it return a bool?

> diff --git a/include/linux/bvec.h b/include/linux/bvec.h
> index f6275c4da13a..6e4996dfc847 100644
> --- a/include/linux/bvec.h
> +++ b/include/linux/bvec.h
> @@ -48,7 +48,7 @@ struct bvec_iter {
>  struct bvec_iter_all {
>  	struct bio_vec	bv;
>  	int		idx;
> -	unsigned	done;
> +	unsigned	bv_done;

Why the rename here?

> +static inline void mp_bvec_advance(const struct bio_vec *bvec,
> +				   struct bvec_iter_all *iter_all)

If we rename this we should probably drop the mp_ prefix..

Also not for this patch, but we should really consider moving this
function out of line given how big it is.


Here is how I'd do this with my slight changes:


diff --git a/include/linux/bio.h b/include/linux/bio.h
index bb915591557b..fd7629ac9f11 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -120,19 +120,42 @@ static inline bool bio_full(struct bio *bio)
 	return bio->bi_vcnt >= bio->bi_max_vecs;
 }
 
-#define mp_bvec_for_each_segment(bv, bvl, i, iter_all)			\
-	for (bv = bvec_init_iter_all(&iter_all);			\
-		(iter_all.done < (bvl)->bv_len) &&			\
-		(mp_bvec_next_segment((bvl), &iter_all), 1);		\
-		iter_all.done += bv->bv_len, i += 1)
+static inline bool __bio_next_segment_all(struct bio *bio,
+		struct bvec_iter_all *iter_all)
+{
+	struct bio_vec *bvec = &bio->bi_io_vec[iter_all->idx];
+	struct bio_vec *bv = &iter_all->bv;
+
+	if (iter_all->idx >= bio->bi_vcnt)
+		return false;
+
+	if (iter_all->done) {
+		bv->bv_page = nth_page(bv->bv_page, 1);
+		bv->bv_offset = 0;
+	} else {
+		bv->bv_page = bvec->bv_page;
+		bv->bv_offset = bvec->bv_offset;
+	}
+	bv->bv_len = min_t(unsigned int, PAGE_SIZE - bv->bv_offset,
+			   bvec->bv_len - iter_all->done);
+	iter_all->done += bv->bv_len;
+
+	if (iter_all->done == bvec->bv_len) {
+		iter_all->idx++;
+		iter_all->done = 0;
+	}
+
+	return true;
+}
 
 /*
  * drivers should _never_ use the all version - the bio may have been split
  * before it got to the driver and the driver won't own all of it
  */
-#define bio_for_each_segment_all(bvl, bio, i, iter_all)		\
-	for (i = 0, iter_all.idx = 0; iter_all.idx < (bio)->bi_vcnt; iter_all.idx++)	\
-		mp_bvec_for_each_segment(bvl, &((bio)->bi_io_vec[iter_all.idx]), i, iter_all)
+#define bio_for_each_segment_all(bvl, bio, i, iter_all)			\
+	for (i = 0, bvl = bvec_init_iter_all(&iter_all);		\
+	     __bio_next_segment_all(bio, &iter_all);			\
+	     i++)
 
 static inline void bio_advance_iter(struct bio *bio, struct bvec_iter *iter,
 				    unsigned bytes)
diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index f6275c4da13a..bcebfc522498 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -145,28 +145,12 @@ static inline bool bvec_iter_advance(const struct bio_vec *bv,
 
 static inline struct bio_vec *bvec_init_iter_all(struct bvec_iter_all *iter_all)
 {
-	iter_all->bv.bv_page = NULL;
 	iter_all->done = 0;
+	iter_all->idx = 0;
 
 	return &iter_all->bv;
 }
 
-static inline void mp_bvec_next_segment(const struct bio_vec *bvec,
-					struct bvec_iter_all *iter_all)
-{
-	struct bio_vec *bv = &iter_all->bv;
-
-	if (bv->bv_page) {
-		bv->bv_page = nth_page(bv->bv_page, 1);
-		bv->bv_offset = 0;
-	} else {
-		bv->bv_page = bvec->bv_page;
-		bv->bv_offset = bvec->bv_offset;
-	}
-	bv->bv_len = min_t(unsigned int, PAGE_SIZE - bv->bv_offset,
-			   bvec->bv_len - iter_all->done);
-}
-
 /*
  * Get the last single-page segment from the multi-page bvec and store it
  * in @seg
