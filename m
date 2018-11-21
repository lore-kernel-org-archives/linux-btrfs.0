Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5304EC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 03:28:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25D8F21104
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 03:28:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 25D8F21104
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbeKUOBD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Nov 2018 09:01:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44324 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726705AbeKUOBC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Nov 2018 09:01:02 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9E45D3083390;
        Wed, 21 Nov 2018 03:28:30 +0000 (UTC)
Received: from localhost (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 072B117A6A;
        Wed, 21 Nov 2018 03:28:17 +0000 (UTC)
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
Subject: [PATCH V11 15/19] block: enable multipage bvecs
Date:   Wed, 21 Nov 2018 11:23:23 +0800
Message-Id: <20181121032327.8434-16-ming.lei@redhat.com>
In-Reply-To: <20181121032327.8434-1-ming.lei@redhat.com>
References: <20181121032327.8434-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Wed, 21 Nov 2018 03:28:31 +0000 (UTC)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patch pulls the trigger for multi-page bvecs.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/bio.c       | 32 +++++++++++++++++++++++++++-----
 fs/iomap.c        |  2 +-
 fs/xfs/xfs_aops.c |  2 +-
 3 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 0f1635b9ec50..854676edc438 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -823,7 +823,7 @@ EXPORT_SYMBOL(bio_add_pc_page);
  * @len: length of the data to add
  * @off: offset of the data in @page
  *
- * Try to add the data at @page + @off to the last bvec of @bio.  This is a
+ * Try to add the data at @page + @off to the last page of @bio.  This is a
  * a useful optimisation for file systems with a block size smaller than the
  * page size.
  *
@@ -836,10 +836,13 @@ bool __bio_try_merge_page(struct bio *bio, struct page *page,
 		return false;
 
 	if (bio->bi_vcnt > 0) {
-		struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
+		struct bio_vec bv;
+		struct bio_vec *seg = &bio->bi_io_vec[bio->bi_vcnt - 1];
 
-		if (page == bv->bv_page && off == bv->bv_offset + bv->bv_len) {
-			bv->bv_len += len;
+		bvec_last_segment(seg, &bv);
+
+		if (page == bv.bv_page && off == bv.bv_offset + bv.bv_len) {
+			seg->bv_len += len;
 			bio->bi_iter.bi_size += len;
 			return true;
 		}
@@ -848,6 +851,25 @@ bool __bio_try_merge_page(struct bio *bio, struct page *page,
 }
 EXPORT_SYMBOL_GPL(__bio_try_merge_page);
 
+static bool bio_try_merge_segment(struct bio *bio, struct page *page,
+				  unsigned int len, unsigned int off)
+{
+	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
+		return false;
+
+	if (bio->bi_vcnt > 0) {
+		struct bio_vec *seg = &bio->bi_io_vec[bio->bi_vcnt - 1];
+
+		if (page_to_phys(seg->bv_page) + seg->bv_offset + seg->bv_len ==
+		    page_to_phys(page) + off) {
+			seg->bv_len += len;
+			bio->bi_iter.bi_size += len;
+			return true;
+		}
+	}
+	return false;
+}
+
 /**
  * __bio_add_page - add page to a bio in a new segment
  * @bio: destination bio
@@ -888,7 +910,7 @@ EXPORT_SYMBOL_GPL(__bio_add_page);
 int bio_add_page(struct bio *bio, struct page *page,
 		 unsigned int len, unsigned int offset)
 {
-	if (!__bio_try_merge_page(bio, page, len, offset)) {
+	if (!bio_try_merge_segment(bio, page, len, offset)) {
 		if (bio_full(bio))
 			return 0;
 		__bio_add_page(bio, page, len, offset);
diff --git a/fs/iomap.c b/fs/iomap.c
index f5fb8bf75cc8..ccc2ba115f4d 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -344,7 +344,7 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		ctx->bio->bi_end_io = iomap_read_end_io;
 	}
 
-	__bio_add_page(ctx->bio, page, plen, poff);
+	bio_add_page(ctx->bio, page, plen, poff);
 done:
 	/*
 	 * Move the caller beyond our range so that it keeps making progress.
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 1f1829e506e8..5c2190216614 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -621,7 +621,7 @@ xfs_add_to_ioend(
 			atomic_inc(&iop->write_count);
 		if (bio_full(wpc->ioend->io_bio))
 			xfs_chain_bio(wpc->ioend, wbc, bdev, sector);
-		__bio_add_page(wpc->ioend->io_bio, page, len, poff);
+		bio_add_page(wpc->ioend->io_bio, page, len, poff);
 	}
 
 	wpc->ioend->io_size += len;
-- 
2.9.5

