Return-Path: <SRS0=mYd/=OF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A097C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 02:20:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57C3B20855
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 02:20:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 57C3B20855
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbeKZNN0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 26 Nov 2018 08:13:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39542 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbeKZNNZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Nov 2018 08:13:25 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 44AF3811D3;
        Mon, 26 Nov 2018 02:20:49 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 58ADA5C22D;
        Mon, 26 Nov 2018 02:20:48 +0000 (UTC)
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
Subject: [PATCH V12 16/20] block: enable multipage bvecs
Date:   Mon, 26 Nov 2018 10:17:16 +0800
Message-Id: <20181126021720.19471-17-ming.lei@redhat.com>
In-Reply-To: <20181126021720.19471-1-ming.lei@redhat.com>
References: <20181126021720.19471-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Mon, 26 Nov 2018 02:20:49 +0000 (UTC)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patch pulls the trigger for multi-page bvecs.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/bio.c         | 22 +++++++++++++++-------
 fs/iomap.c          |  4 ++--
 fs/xfs/xfs_aops.c   |  4 ++--
 include/linux/bio.h |  2 +-
 4 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 75fde30af51f..8bf9338d4783 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -753,6 +753,8 @@ EXPORT_SYMBOL(bio_add_pc_page);
  * @page: page to add
  * @len: length of the data to add
  * @off: offset of the data in @page
+ * @same_page: if %true only merge if the new data is in the same physical
+ *		page as the last segment of the bio.
  *
  * Try to add the data at @page + @off to the last bvec of @bio.  This is a
  * a useful optimisation for file systems with a block size smaller than the
@@ -761,19 +763,25 @@ EXPORT_SYMBOL(bio_add_pc_page);
  * Return %true on success or %false on failure.
  */
 bool __bio_try_merge_page(struct bio *bio, struct page *page,
-		unsigned int len, unsigned int off)
+		unsigned int len, unsigned int off, bool same_page)
 {
 	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
 		return false;
 
 	if (bio->bi_vcnt > 0) {
 		struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
+		phys_addr_t vec_end_addr = page_to_phys(bv->bv_page) +
+			bv->bv_offset + bv->bv_len;
+		phys_addr_t page_addr = page_to_phys(page);
 
-		if (page == bv->bv_page && off == bv->bv_offset + bv->bv_len) {
-			bv->bv_len += len;
-			bio->bi_iter.bi_size += len;
-			return true;
-		}
+		if (vec_end_addr != page_addr + off)
+			return false;
+		if (same_page && ((vec_end_addr - 1) & PAGE_MASK) != page_addr)
+			return false;
+
+		bv->bv_len += len;
+		bio->bi_iter.bi_size += len;
+		return true;
 	}
 	return false;
 }
@@ -819,7 +827,7 @@ EXPORT_SYMBOL_GPL(__bio_add_page);
 int bio_add_page(struct bio *bio, struct page *page,
 		 unsigned int len, unsigned int offset)
 {
-	if (!__bio_try_merge_page(bio, page, len, offset)) {
+	if (!__bio_try_merge_page(bio, page, len, offset, false)) {
 		if (bio_full(bio))
 			return 0;
 		__bio_add_page(bio, page, len, offset);
diff --git a/fs/iomap.c b/fs/iomap.c
index 1f648d098a3b..ec5527b0fba4 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -313,7 +313,7 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 	 */
 	sector = iomap_sector(iomap, pos);
 	if (ctx->bio && bio_end_sector(ctx->bio) == sector) {
-		if (__bio_try_merge_page(ctx->bio, page, plen, poff))
+		if (__bio_try_merge_page(ctx->bio, page, plen, poff, true))
 			goto done;
 		is_contig = true;
 	}
@@ -344,7 +344,7 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		ctx->bio->bi_end_io = iomap_read_end_io;
 	}
 
-	__bio_add_page(ctx->bio, page, plen, poff);
+	bio_add_page(ctx->bio, page, plen, poff);
 done:
 	/*
 	 * Move the caller beyond our range so that it keeps making progress.
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 1f1829e506e8..b9fd44168f61 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -616,12 +616,12 @@ xfs_add_to_ioend(
 				bdev, sector);
 	}
 
-	if (!__bio_try_merge_page(wpc->ioend->io_bio, page, len, poff)) {
+	if (!__bio_try_merge_page(wpc->ioend->io_bio, page, len, poff, true)) {
 		if (iop)
 			atomic_inc(&iop->write_count);
 		if (bio_full(wpc->ioend->io_bio))
 			xfs_chain_bio(wpc->ioend, wbc, bdev, sector);
-		__bio_add_page(wpc->ioend->io_bio, page, len, poff);
+		bio_add_page(wpc->ioend->io_bio, page, len, poff);
 	}
 
 	wpc->ioend->io_size += len;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index c35997dd02c2..5505f74aef8b 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -441,7 +441,7 @@ extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
 			   unsigned int, unsigned int);
 bool __bio_try_merge_page(struct bio *bio, struct page *page,
-		unsigned int len, unsigned int off);
+		unsigned int len, unsigned int off, bool same_page);
 void __bio_add_page(struct bio *bio, struct page *page,
 		unsigned int len, unsigned int off);
 int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter);
-- 
2.9.5

