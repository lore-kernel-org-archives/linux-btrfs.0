Return-Path: <SRS0=k9FD=SI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFF32C282DC
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 13:47:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C98D8218D4
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 13:47:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726471AbfDFNrd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 6 Apr 2019 09:47:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48282 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726353AbfDFNrc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 6 Apr 2019 09:47:32 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 83ACF3082E23;
        Sat,  6 Apr 2019 13:47:32 +0000 (UTC)
Received: from ming.t460p (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E55955C1B4;
        Sat,  6 Apr 2019 13:47:25 +0000 (UTC)
Date:   Sat, 6 Apr 2019 21:47:19 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: No way to break bio_for_each_segment_all() macro?
Message-ID: <20190406134718.GC3018@ming.t460p>
References: <ac2ba6e0-5312-1ec5-471e-edd16d6cde3a@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac2ba6e0-5312-1ec5-471e-edd16d6cde3a@gmx.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Sat, 06 Apr 2019 13:47:32 +0000 (UTC)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Apr 06, 2019 at 09:53:07AM +0800, Qu Wenruo wrote:
> Hi,
> 
> I'm looking into a strange behavior that we can't break
> bio_for_each_segment_all() after commit 6dc4f100c175 ("block: allow
> bio_for_each_segment_all() to iterate over multi-page bvec").
> 
> It's screwing up all bio_for_each_segment_all() call with error out branch.
> 

Please test the following patch:

--

diff --git a/include/linux/bio.h b/include/linux/bio.h
index bb6090aa165d..7bd7e64e02f8 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -120,19 +120,15 @@ static inline bool bio_full(struct bio *bio)
 	return bio->bi_vcnt >= bio->bi_max_vecs;
 }
 
-#define mp_bvec_for_each_segment(bv, bvl, i, iter_all)			\
-	for (bv = bvec_init_iter_all(&iter_all);			\
-		(iter_all.done < (bvl)->bv_len) &&			\
-		(mp_bvec_next_segment((bvl), &iter_all), 1);		\
-		iter_all.done += bv->bv_len, i += 1)
-
 /*
  * drivers should _never_ use the all version - the bio may have been split
  * before it got to the driver and the driver won't own all of it
  */
-#define bio_for_each_segment_all(bvl, bio, i, iter_all)		\
-	for (i = 0, iter_all.idx = 0; iter_all.idx < (bio)->bi_vcnt; iter_all.idx++)	\
-		mp_bvec_for_each_segment(bvl, &((bio)->bi_io_vec[iter_all.idx]), i, iter_all)
+#define bio_for_each_segment_all(bvl, bio, i, iter_all)			\
+	for (i = 0, bvl = bvec_init_iter_all(&iter_all);		\
+		iter_all.idx < (bio)->bi_vcnt &&			\
+		(mp_bvec_advance(&((bio)->bi_io_vec[iter_all.idx]),	\
+				 &iter_all), 1); i++)
 
 static inline void bio_advance_iter(struct bio *bio, struct bvec_iter *iter,
 				    unsigned bytes)
diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index f6275c4da13a..6e4996dfc847 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -48,7 +48,7 @@ struct bvec_iter {
 struct bvec_iter_all {
 	struct bio_vec	bv;
 	int		idx;
-	unsigned	done;
+	unsigned	bv_done;
 };
 
 static inline struct page *bvec_nth_page(struct page *page, int idx)
@@ -145,18 +145,18 @@ static inline bool bvec_iter_advance(const struct bio_vec *bv,
 
 static inline struct bio_vec *bvec_init_iter_all(struct bvec_iter_all *iter_all)
 {
-	iter_all->bv.bv_page = NULL;
-	iter_all->done = 0;
+	iter_all->bv_done = 0;
+	iter_all->idx = 0;
 
 	return &iter_all->bv;
 }
 
-static inline void mp_bvec_next_segment(const struct bio_vec *bvec,
-					struct bvec_iter_all *iter_all)
+static inline void mp_bvec_advance(const struct bio_vec *bvec,
+				   struct bvec_iter_all *iter_all)
 {
 	struct bio_vec *bv = &iter_all->bv;
 
-	if (bv->bv_page) {
+	if (iter_all->bv_done) {
 		bv->bv_page = nth_page(bv->bv_page, 1);
 		bv->bv_offset = 0;
 	} else {
@@ -164,7 +164,13 @@ static inline void mp_bvec_next_segment(const struct bio_vec *bvec,
 		bv->bv_offset = bvec->bv_offset;
 	}
 	bv->bv_len = min_t(unsigned int, PAGE_SIZE - bv->bv_offset,
-			   bvec->bv_len - iter_all->done);
+			   bvec->bv_len - iter_all->bv_done);
+	iter_all->bv_done += bv->bv_len;
+
+	if (iter_all->bv_done == bvec->bv_len) {
+		iter_all->idx++;
+		iter_all->bv_done = 0;
+	}
 }
 
 /*

Thanks,
Ming
