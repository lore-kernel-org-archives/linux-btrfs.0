Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85D8CC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 03:25:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BA9621104
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 03:25:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5BA9621104
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbeKUN6B (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Nov 2018 08:58:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48870 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726165AbeKUN6B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Nov 2018 08:58:01 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 47485C050DFB;
        Wed, 21 Nov 2018 03:25:30 +0000 (UTC)
Received: from localhost (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 187B47E102;
        Wed, 21 Nov 2018 03:25:18 +0000 (UTC)
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
Subject: [PATCH V11 03/19] block: introduce bio_for_each_bvec()
Date:   Wed, 21 Nov 2018 11:23:11 +0800
Message-Id: <20181121032327.8434-4-ming.lei@redhat.com>
In-Reply-To: <20181121032327.8434-1-ming.lei@redhat.com>
References: <20181121032327.8434-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Wed, 21 Nov 2018 03:25:30 +0000 (UTC)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This helper is used for iterating over multi-page bvec for bio
split & merge code.

Reviewed-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/bio.h  | 25 ++++++++++++++++++++++---
 include/linux/bvec.h | 36 +++++++++++++++++++++++++++++-------
 2 files changed, 51 insertions(+), 10 deletions(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 056fb627edb3..7560209d6a8a 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -76,6 +76,9 @@
 #define bio_data_dir(bio) \
 	(op_is_write(bio_op(bio)) ? WRITE : READ)
 
+#define bio_iter_mp_iovec(bio, iter)				\
+	segment_iter_bvec((bio)->bi_io_vec, (iter))
+
 /*
  * Check whether this bio carries any data or not. A NULL bio is allowed.
  */
@@ -135,18 +138,24 @@ static inline bool bio_full(struct bio *bio)
 #define bio_for_each_segment_all(bvl, bio, i)				\
 	for (i = 0, bvl = (bio)->bi_io_vec; i < (bio)->bi_vcnt; i++, bvl++)
 
-static inline void bio_advance_iter(struct bio *bio, struct bvec_iter *iter,
-				    unsigned bytes)
+static inline void __bio_advance_iter(struct bio *bio, struct bvec_iter *iter,
+				      unsigned bytes, unsigned max_seg_len)
 {
 	iter->bi_sector += bytes >> 9;
 
 	if (bio_no_advance_iter(bio))
 		iter->bi_size -= bytes;
 	else
-		bvec_iter_advance(bio->bi_io_vec, iter, bytes);
+		__bvec_iter_advance(bio->bi_io_vec, iter, bytes, max_seg_len);
 		/* TODO: It is reasonable to complete bio with error here. */
 }
 
+static inline void bio_advance_iter(struct bio *bio, struct bvec_iter *iter,
+				    unsigned bytes)
+{
+	__bio_advance_iter(bio, iter, bytes, PAGE_SIZE);
+}
+
 #define __bio_for_each_segment(bvl, bio, iter, start)			\
 	for (iter = (start);						\
 	     (iter).bi_size &&						\
@@ -156,6 +165,16 @@ static inline void bio_advance_iter(struct bio *bio, struct bvec_iter *iter,
 #define bio_for_each_segment(bvl, bio, iter)				\
 	__bio_for_each_segment(bvl, bio, iter, (bio)->bi_iter)
 
+#define __bio_for_each_bvec(bvl, bio, iter, start)		\
+	for (iter = (start);						\
+	     (iter).bi_size &&						\
+		((bvl = bio_iter_mp_iovec((bio), (iter))), 1);	\
+	     __bio_advance_iter((bio), &(iter), (bvl).bv_len, BVEC_MAX_LEN))
+
+/* returns one real segment(multi-page bvec) each time */
+#define bio_for_each_bvec(bvl, bio, iter)			\
+	__bio_for_each_bvec(bvl, bio, iter, (bio)->bi_iter)
+
 #define bio_iter_last(bvec, iter) ((iter).bi_size == (bvec).bv_len)
 
 static inline unsigned bio_segments(struct bio *bio)
diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index ed90bbf4c9c9..b279218c5c4d 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -25,6 +25,8 @@
 #include <linux/errno.h>
 #include <linux/mm.h>
 
+#define BVEC_MAX_LEN  ((unsigned int)-1)
+
 /*
  * was unsigned short, but we might as well be ready for > 64kB I/O pages
  */
@@ -87,8 +89,15 @@ struct bvec_iter {
 	.bv_offset	= bvec_iter_offset((bvec), (iter)),	\
 })
 
-static inline bool bvec_iter_advance(const struct bio_vec *bv,
-		struct bvec_iter *iter, unsigned bytes)
+#define segment_iter_bvec(bvec, iter)				\
+((struct bio_vec) {							\
+	.bv_page	= segment_iter_page((bvec), (iter)),	\
+	.bv_len		= segment_iter_len((bvec), (iter)),	\
+	.bv_offset	= segment_iter_offset((bvec), (iter)),	\
+})
+
+static inline bool __bvec_iter_advance(const struct bio_vec *bv,
+		struct bvec_iter *iter, unsigned bytes, unsigned max_seg_len)
 {
 	if (WARN_ONCE(bytes > iter->bi_size,
 		     "Attempted to advance past end of bvec iter\n")) {
@@ -97,12 +106,18 @@ static inline bool bvec_iter_advance(const struct bio_vec *bv,
 	}
 
 	while (bytes) {
-		unsigned iter_len = bvec_iter_len(bv, *iter);
-		unsigned len = min(bytes, iter_len);
+		unsigned segment_len = segment_iter_len(bv, *iter);
 
-		bytes -= len;
-		iter->bi_size -= len;
-		iter->bi_bvec_done += len;
+		if (max_seg_len < BVEC_MAX_LEN)
+			segment_len = min_t(unsigned, segment_len,
+					    max_seg_len -
+					    bvec_iter_offset(bv, *iter));
+
+		segment_len = min(bytes, segment_len);
+
+		bytes -= segment_len;
+		iter->bi_size -= segment_len;
+		iter->bi_bvec_done += segment_len;
 
 		if (iter->bi_bvec_done == __bvec_iter_bvec(bv, *iter)->bv_len) {
 			iter->bi_bvec_done = 0;
@@ -136,6 +151,13 @@ static inline bool bvec_iter_rewind(const struct bio_vec *bv,
 	return true;
 }
 
+static inline bool bvec_iter_advance(const struct bio_vec *bv,
+				     struct bvec_iter *iter,
+				     unsigned bytes)
+{
+	return __bvec_iter_advance(bv, iter, bytes, PAGE_SIZE);
+}
+
 #define for_each_bvec(bvl, bio_vec, iter, start)			\
 	for (iter = (start);						\
 	     (iter).bi_size &&						\
-- 
2.9.5

