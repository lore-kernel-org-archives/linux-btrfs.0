Return-Path: <SRS0=mYd/=OF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D109C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 02:19:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFFEE20865
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 02:19:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DFFEE20865
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbeKZNLi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 26 Nov 2018 08:11:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48186 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726457AbeKZNLi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Nov 2018 08:11:38 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D235A8535D;
        Mon, 26 Nov 2018 02:19:01 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8AEF82D1E3;
        Mon, 26 Nov 2018 02:18:50 +0000 (UTC)
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
Subject: [PATCH V12 07/20] block: introduce multi-page bvec helpers
Date:   Mon, 26 Nov 2018 10:17:07 +0800
Message-Id: <20181126021720.19471-8-ming.lei@redhat.com>
In-Reply-To: <20181126021720.19471-1-ming.lei@redhat.com>
References: <20181126021720.19471-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Mon, 26 Nov 2018 02:19:02 +0000 (UTC)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patch introduces helpers of 'bvec_iter_*' for multi-page bvec
support.

The introduced helpers treate one bvec as real multi-page segment,
which may include more than one pages.

The existed helpers of bvec_iter_* are interfaces for supporting current
bvec iterator which is thought as single-page by drivers, fs, dm and
etc. These introduced helpers will build single-page bvec in flight, so
this way won't break current bio/bvec users, which needn't any change.

Follows some multi-page bvec background:

- bvecs stored in bio->bi_io_vec is always multi-page style

- bvec(struct bio_vec) represents one physically contiguous I/O
  buffer, now the buffer may include more than one page after
  multi-page bvec is supported, and all these pages represented
  by one bvec is physically contiguous. Before multi-page bvec
  support, at most one page is included in one bvec, we call it
  single-page bvec.

- .bv_page of the bvec points to the 1st page in the multi-page bvec

- .bv_offset of the bvec is the offset of the buffer in the bvec

The effect on the current drivers/filesystem/dm/bcache/...:

- almost everyone supposes that one bvec only includes one single
  page, so we keep the sp interface not changed, for example,
  bio_for_each_segment() still returns single-page bvec

- bio_for_each_segment_all() will return single-page bvec too

- during iterating, iterator variable(struct bvec_iter) is always
  updated in multi-page bvec style, and bvec_iter_advance() is kept
  not changed

- returned(copied) single-page bvec is built in flight by bvec
  helpers from the stored multi-page bvec

Reviewed-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/bvec.h | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index 716a87b26a6a..babc6316c117 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -23,6 +23,7 @@
 #include <linux/kernel.h>
 #include <linux/bug.h>
 #include <linux/errno.h>
+#include <linux/mm.h>
 
 /*
  * was unsigned short, but we might as well be ready for > 64kB I/O pages
@@ -50,16 +51,32 @@ struct bvec_iter {
  */
 #define __bvec_iter_bvec(bvec, iter)	(&(bvec)[(iter).bi_idx])
 
-#define segment_iter_page(bvec, iter)				\
+/* multi-page (segment) helpers */
+#define bvec_iter_page(bvec, iter)				\
 	(__bvec_iter_bvec((bvec), (iter))->bv_page)
 
-#define segment_iter_len(bvec, iter)				\
+#define bvec_iter_len(bvec, iter)				\
 	min((iter).bi_size,					\
 	    __bvec_iter_bvec((bvec), (iter))->bv_len - (iter).bi_bvec_done)
 
-#define segment_iter_offset(bvec, iter)				\
+#define bvec_iter_offset(bvec, iter)				\
 	(__bvec_iter_bvec((bvec), (iter))->bv_offset + (iter).bi_bvec_done)
 
+#define bvec_iter_page_idx(bvec, iter)			\
+	(bvec_iter_offset((bvec), (iter)) / PAGE_SIZE)
+
+/* For building single-page bvec(segment) in flight */
+ #define segment_iter_offset(bvec, iter)				\
+	(bvec_iter_offset((bvec), (iter)) % PAGE_SIZE)
+
+#define segment_iter_len(bvec, iter)				\
+	min_t(unsigned, bvec_iter_len((bvec), (iter)),		\
+	      PAGE_SIZE - segment_iter_offset((bvec), (iter)))
+
+#define segment_iter_page(bvec, iter)				\
+	nth_page(bvec_iter_page((bvec), (iter)),		\
+		 bvec_iter_page_idx((bvec), (iter)))
+
 #define segment_iter_bvec(bvec, iter)				\
 ((struct bio_vec) {						\
 	.bv_page	= segment_iter_page((bvec), (iter)),	\
@@ -67,8 +84,6 @@ struct bvec_iter {
 	.bv_offset	= segment_iter_offset((bvec), (iter)),	\
 })
 
-#define bvec_iter_len  segment_iter_len
-
 static inline bool bvec_iter_advance(const struct bio_vec *bv,
 		struct bvec_iter *iter, unsigned bytes)
 {
-- 
2.9.5

