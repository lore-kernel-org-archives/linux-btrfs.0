Return-Path: <SRS0=c/cW=SL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 854E5C282DA
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Apr 2019 09:48:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 516E320830
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Apr 2019 09:48:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbfDIJsx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Apr 2019 05:48:53 -0400
Received: from verein.lst.de ([213.95.11.211]:49129 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726035AbfDIJsx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Apr 2019 05:48:53 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id BC46E68B02; Tue,  9 Apr 2019 11:48:39 +0200 (CEST)
Date:   Tue, 9 Apr 2019 11:48:39 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Omar Sandoval <osandov@fb.com>
Subject: Re: [PATCH] block: don't use for-inside-for in
 bio_for_each_segment_all
Message-ID: <20190409094839.GA6827@lst.de>
References: <20190406215428.3131-1-ming.lei@redhat.com> <20190407065205.GA8799@lst.de> <f0c82caf-24f3-dba7-0bf0-85dd0e056e73@suse.de> <20190408141203.GT22763@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190408141203.GT22763@bombadil.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 08, 2019 at 07:12:04AM -0700, Matthew Wilcox wrote:
> On Mon, Apr 08, 2019 at 08:07:55AM +0200, Hannes Reinecke wrote:
> > Oh yes, please do.
> > The macros are fast becoming unparseable :-)
> 
> I think something that would help is removing the mandatory 'i' parameter
> to this iterator.  Most of the users don't use it, and the ones that do
> can implement it themselves.  eg:

Yeah, I quickly hacked this up during a meeting yesterday and we have
exactly two users of the iterator.  Patch against the for-linus tree
below, although it conflicts with some of the 5.2 work.  Maybe it is
best to merge this just after the next rc1..

--
From 6a872f0186846a64a898b149be54d385f9f03f8b Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Mon, 8 Apr 2019 18:11:44 +0200
Subject: block: remove the i argument to bio_for_each_segment_all

We only have two callers that need the simple loop iterator, and
they can easily do it themselves.

Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c                       | 26 +++++++++-----------------
 block/bounce.c                    |  3 +--
 drivers/md/bcache/btree.c         |  6 ++++--
 drivers/md/dm-crypt.c             |  3 +--
 drivers/md/raid1.c                |  6 +++---
 drivers/staging/erofs/data.c      |  3 +--
 drivers/staging/erofs/unzip_vle.c |  3 +--
 fs/block_dev.c                    |  6 ++----
 fs/btrfs/compression.c            |  3 +--
 fs/btrfs/disk-io.c                |  4 ++--
 fs/btrfs/extent_io.c              | 10 ++++------
 fs/btrfs/inode.c                  |  8 ++++----
 fs/btrfs/raid56.c                 |  3 +--
 fs/crypto/bio.c                   |  3 +--
 fs/direct-io.c                    |  3 +--
 fs/ext4/page-io.c                 |  3 +--
 fs/ext4/readpage.c                |  3 +--
 fs/f2fs/data.c                    |  9 +++------
 fs/gfs2/lops.c                    |  3 +--
 fs/gfs2/meta_io.c                 |  3 +--
 fs/iomap.c                        |  6 ++----
 fs/mpage.c                        |  3 +--
 fs/xfs/xfs_aops.c                 |  3 +--
 include/linux/bio.h               |  5 ++---
 24 files changed, 49 insertions(+), 79 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index b64cedc7f87c..8620ba0487e2 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1127,11 +1127,10 @@ static struct bio_map_data *bio_alloc_map_data(struct iov_iter *data,
  */
 static int bio_copy_from_iter(struct bio *bio, struct iov_iter *iter)
 {
-	int i;
 	struct bio_vec *bvec;
 	struct bvec_iter_all iter_all;
 
-	bio_for_each_segment_all(bvec, bio, i, iter_all) {
+	bio_for_each_segment_all(bvec, bio, iter_all) {
 		ssize_t ret;
 
 		ret = copy_page_from_iter(bvec->bv_page,
@@ -1159,11 +1158,10 @@ static int bio_copy_from_iter(struct bio *bio, struct iov_iter *iter)
  */
 static int bio_copy_to_iter(struct bio *bio, struct iov_iter iter)
 {
-	int i;
 	struct bio_vec *bvec;
 	struct bvec_iter_all iter_all;
 
-	bio_for_each_segment_all(bvec, bio, i, iter_all) {
+	bio_for_each_segment_all(bvec, bio, iter_all) {
 		ssize_t ret;
 
 		ret = copy_page_to_iter(bvec->bv_page,
@@ -1184,10 +1182,9 @@ static int bio_copy_to_iter(struct bio *bio, struct iov_iter iter)
 void bio_free_pages(struct bio *bio)
 {
 	struct bio_vec *bvec;
-	int i;
 	struct bvec_iter_all iter_all;
 
-	bio_for_each_segment_all(bvec, bio, i, iter_all)
+	bio_for_each_segment_all(bvec, bio, iter_all)
 		__free_page(bvec->bv_page);
 }
 EXPORT_SYMBOL(bio_free_pages);
@@ -1429,7 +1426,7 @@ struct bio *bio_map_user_iov(struct request_queue *q,
 	return bio;
 
  out_unmap:
-	bio_for_each_segment_all(bvec, bio, j, iter_all) {
+	bio_for_each_segment_all(bvec, bio, iter_all) {
 		put_page(bvec->bv_page);
 	}
 	bio_put(bio);
@@ -1439,13 +1436,12 @@ struct bio *bio_map_user_iov(struct request_queue *q,
 static void __bio_unmap_user(struct bio *bio)
 {
 	struct bio_vec *bvec;
-	int i;
 	struct bvec_iter_all iter_all;
 
 	/*
 	 * make sure we dirty pages we wrote to
 	 */
-	bio_for_each_segment_all(bvec, bio, i, iter_all) {
+	bio_for_each_segment_all(bvec, bio, iter_all) {
 		if (bio_data_dir(bio) == READ)
 			set_page_dirty_lock(bvec->bv_page);
 
@@ -1536,10 +1532,9 @@ static void bio_copy_kern_endio_read(struct bio *bio)
 {
 	char *p = bio->bi_private;
 	struct bio_vec *bvec;
-	int i;
 	struct bvec_iter_all iter_all;
 
-	bio_for_each_segment_all(bvec, bio, i, iter_all) {
+	bio_for_each_segment_all(bvec, bio, iter_all) {
 		memcpy(p, page_address(bvec->bv_page), bvec->bv_len);
 		p += bvec->bv_len;
 	}
@@ -1647,10 +1642,9 @@ struct bio *bio_copy_kern(struct request_queue *q, void *data, unsigned int len,
 void bio_set_pages_dirty(struct bio *bio)
 {
 	struct bio_vec *bvec;
-	int i;
 	struct bvec_iter_all iter_all;
 
-	bio_for_each_segment_all(bvec, bio, i, iter_all) {
+	bio_for_each_segment_all(bvec, bio, iter_all) {
 		if (!PageCompound(bvec->bv_page))
 			set_page_dirty_lock(bvec->bv_page);
 	}
@@ -1659,10 +1653,9 @@ void bio_set_pages_dirty(struct bio *bio)
 static void bio_release_pages(struct bio *bio)
 {
 	struct bio_vec *bvec;
-	int i;
 	struct bvec_iter_all iter_all;
 
-	bio_for_each_segment_all(bvec, bio, i, iter_all)
+	bio_for_each_segment_all(bvec, bio, iter_all)
 		put_page(bvec->bv_page);
 }
 
@@ -1709,10 +1702,9 @@ void bio_check_pages_dirty(struct bio *bio)
 {
 	struct bio_vec *bvec;
 	unsigned long flags;
-	int i;
 	struct bvec_iter_all iter_all;
 
-	bio_for_each_segment_all(bvec, bio, i, iter_all) {
+	bio_for_each_segment_all(bvec, bio, iter_all) {
 		if (!PageDirty(bvec->bv_page) && !PageCompound(bvec->bv_page))
 			goto defer;
 	}
diff --git a/block/bounce.c b/block/bounce.c
index 47eb7e936e22..f8ed677a1bf7 100644
--- a/block/bounce.c
+++ b/block/bounce.c
@@ -163,14 +163,13 @@ static void bounce_end_io(struct bio *bio, mempool_t *pool)
 {
 	struct bio *bio_orig = bio->bi_private;
 	struct bio_vec *bvec, orig_vec;
-	int i;
 	struct bvec_iter orig_iter = bio_orig->bi_iter;
 	struct bvec_iter_all iter_all;
 
 	/*
 	 * free up bounce indirect pages used
 	 */
-	bio_for_each_segment_all(bvec, bio, i, iter_all) {
+	bio_for_each_segment_all(bvec, bio, iter_all) {
 		orig_vec = bio_iter_iovec(bio_orig, orig_iter);
 		if (bvec->bv_page != orig_vec.bv_page) {
 			dec_zone_page_state(bvec->bv_page, NR_BOUNCE);
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 64def336f053..aa793fef52eb 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -429,14 +429,16 @@ static void do_btree_node_write(struct btree *b)
 		       bset_sector_offset(&b->keys, i));
 
 	if (!bch_bio_alloc_pages(b->bio, __GFP_NOWARN|GFP_NOWAIT)) {
-		int j;
+		int j = 0;
 		struct bio_vec *bv;
 		void *base = (void *) ((unsigned long) i & ~(PAGE_SIZE - 1));
 		struct bvec_iter_all iter_all;
 
-		bio_for_each_segment_all(bv, b->bio, j, iter_all)
+		bio_for_each_segment_all(bv, b->bio, iter_all) {
 			memcpy(page_address(bv->bv_page),
 			       base + j * PAGE_SIZE, PAGE_SIZE);
+			j++;
+		}
 
 		bch_submit_bbio(b->bio, b->c, &k.key, 0);
 
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index dd6565798778..cca68546945b 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1445,11 +1445,10 @@ static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned size)
 
 static void crypt_free_buffer_pages(struct crypt_config *cc, struct bio *clone)
 {
-	unsigned int i;
 	struct bio_vec *bv;
 	struct bvec_iter_all iter_all;
 
-	bio_for_each_segment_all(bv, clone, i, iter_all) {
+	bio_for_each_segment_all(bv, clone, iter_all) {
 		BUG_ON(!bv->bv_page);
 		mempool_free(bv->bv_page, &cc->page_pool);
 	}
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index fdf451aac369..0c8a098d220e 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2110,7 +2110,7 @@ static void process_checks(struct r1bio *r1_bio)
 		}
 	r1_bio->read_disk = primary;
 	for (i = 0; i < conf->raid_disks * 2; i++) {
-		int j;
+		int j = 0;
 		struct bio *pbio = r1_bio->bios[primary];
 		struct bio *sbio = r1_bio->bios[i];
 		blk_status_t status = sbio->bi_status;
@@ -2125,8 +2125,8 @@ static void process_checks(struct r1bio *r1_bio)
 		/* Now we can 'fixup' the error value */
 		sbio->bi_status = 0;
 
-		bio_for_each_segment_all(bi, sbio, j, iter_all)
-			page_len[j] = bi->bv_len;
+		bio_for_each_segment_all(bi, sbio, iter_all)
+			page_len[j++] = bi->bv_len;
 
 		if (!status) {
 			for (j = vcnt; j-- ; ) {
diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
index 526e0dbea5b5..1116bb630f2a 100644
--- a/drivers/staging/erofs/data.c
+++ b/drivers/staging/erofs/data.c
@@ -17,12 +17,11 @@
 
 static inline void read_endio(struct bio *bio)
 {
-	int i;
 	struct bio_vec *bvec;
 	const blk_status_t err = bio->bi_status;
 	struct bvec_iter_all iter_all;
 
-	bio_for_each_segment_all(bvec, bio, i, iter_all) {
+	bio_for_each_segment_all(bvec, bio, iter_all) {
 		struct page *page = bvec->bv_page;
 
 		/* page is already locked */
diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 31eef8395774..59b9f37d5c00 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -844,14 +844,13 @@ static void z_erofs_vle_unzip_kickoff(void *ptr, int bios)
 static inline void z_erofs_vle_read_endio(struct bio *bio)
 {
 	const blk_status_t err = bio->bi_status;
-	unsigned int i;
 	struct bio_vec *bvec;
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
 	struct address_space *mc = NULL;
 #endif
 	struct bvec_iter_all iter_all;
 
-	bio_for_each_segment_all(bvec, bio, i, iter_all) {
+	bio_for_each_segment_all(bvec, bio, iter_all) {
 		struct page *page = bvec->bv_page;
 		bool cachemngd = false;
 
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 78d3257435c0..2bddc2339ab1 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -210,7 +210,6 @@ __blkdev_direct_IO_simple(struct kiocb *iocb, struct iov_iter *iter,
 	struct bio bio;
 	ssize_t ret;
 	blk_qc_t qc;
-	int i;
 	struct bvec_iter_all iter_all;
 
 	if ((pos | iov_iter_alignment(iter)) &
@@ -261,7 +260,7 @@ __blkdev_direct_IO_simple(struct kiocb *iocb, struct iov_iter *iter,
 	}
 	__set_current_state(TASK_RUNNING);
 
-	bio_for_each_segment_all(bvec, &bio, i, iter_all) {
+	bio_for_each_segment_all(bvec, &bio, iter_all) {
 		if (should_dirty && !PageCompound(bvec->bv_page))
 			set_page_dirty_lock(bvec->bv_page);
 		put_page(bvec->bv_page);
@@ -339,9 +338,8 @@ static void blkdev_bio_end_io(struct bio *bio)
 		if (!bio_flagged(bio, BIO_NO_PAGE_REF)) {
 			struct bvec_iter_all iter_all;
 			struct bio_vec *bvec;
-			int i;
 
-			bio_for_each_segment_all(bvec, bio, i, iter_all)
+			bio_for_each_segment_all(bvec, bio, iter_all)
 				put_page(bvec->bv_page);
 		}
 		bio_put(bio);
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 4f2a8ae0aa42..6313dc65209e 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -160,7 +160,6 @@ static void end_compressed_bio_read(struct bio *bio)
 	if (cb->errors) {
 		bio_io_error(cb->orig_bio);
 	} else {
-		int i;
 		struct bio_vec *bvec;
 		struct bvec_iter_all iter_all;
 
@@ -169,7 +168,7 @@ static void end_compressed_bio_read(struct bio *bio)
 		 * checked so the end_io handlers know about it
 		 */
 		ASSERT(!bio_flagged(bio, BIO_CLONED));
-		bio_for_each_segment_all(bvec, cb->orig_bio, i, iter_all)
+		bio_for_each_segment_all(bvec, cb->orig_bio, iter_all)
 			SetPageChecked(bvec->bv_page);
 
 		bio_endio(cb->orig_bio);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6fe9197f6ee4..c333e79408ff 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -832,11 +832,11 @@ static blk_status_t btree_csum_one_bio(struct bio *bio)
 {
 	struct bio_vec *bvec;
 	struct btrfs_root *root;
-	int i, ret = 0;
+	int ret = 0;
 	struct bvec_iter_all iter_all;
 
 	ASSERT(!bio_flagged(bio, BIO_CLONED));
-	bio_for_each_segment_all(bvec, bio, i, iter_all) {
+	bio_for_each_segment_all(bvec, bio, iter_all) {
 		root = BTRFS_I(bvec->bv_page->mapping->host)->root;
 		ret = csum_dirty_buffer(root->fs_info, bvec->bv_page);
 		if (ret)
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index ca8b8e785cf3..c85505c36fa6 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2451,11 +2451,10 @@ static void end_bio_extent_writepage(struct bio *bio)
 	struct bio_vec *bvec;
 	u64 start;
 	u64 end;
-	int i;
 	struct bvec_iter_all iter_all;
 
 	ASSERT(!bio_flagged(bio, BIO_CLONED));
-	bio_for_each_segment_all(bvec, bio, i, iter_all) {
+	bio_for_each_segment_all(bvec, bio, iter_all) {
 		struct page *page = bvec->bv_page;
 		struct inode *inode = page->mapping->host;
 		struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
@@ -2523,11 +2522,10 @@ static void end_bio_extent_readpage(struct bio *bio)
 	u64 extent_len = 0;
 	int mirror;
 	int ret;
-	int i;
 	struct bvec_iter_all iter_all;
 
 	ASSERT(!bio_flagged(bio, BIO_CLONED));
-	bio_for_each_segment_all(bvec, bio, i, iter_all) {
+	bio_for_each_segment_all(bvec, bio, iter_all) {
 		struct page *page = bvec->bv_page;
 		struct inode *inode = page->mapping->host;
 		struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
@@ -3643,11 +3641,11 @@ static void end_bio_extent_buffer_writepage(struct bio *bio)
 {
 	struct bio_vec *bvec;
 	struct extent_buffer *eb;
-	int i, done;
+	int done;
 	struct bvec_iter_all iter_all;
 
 	ASSERT(!bio_flagged(bio, BIO_CLONED));
-	bio_for_each_segment_all(bvec, bio, i, iter_all) {
+	bio_for_each_segment_all(bvec, bio, iter_all) {
 		struct page *page = bvec->bv_page;
 
 		eb = (struct extent_buffer *)page->private;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 82fdda8ff5ab..10a8d08d3d29 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7828,7 +7828,6 @@ static void btrfs_retry_endio_nocsum(struct bio *bio)
 	struct inode *inode = done->inode;
 	struct bio_vec *bvec;
 	struct extent_io_tree *io_tree, *failure_tree;
-	int i;
 	struct bvec_iter_all iter_all;
 
 	if (bio->bi_status)
@@ -7841,7 +7840,7 @@ static void btrfs_retry_endio_nocsum(struct bio *bio)
 
 	done->uptodate = 1;
 	ASSERT(!bio_flagged(bio, BIO_CLONED));
-	bio_for_each_segment_all(bvec, bio, i, iter_all)
+	bio_for_each_segment_all(bvec, bio, iter_all)
 		clean_io_failure(BTRFS_I(inode)->root->fs_info, failure_tree,
 				 io_tree, done->start, bvec->bv_page,
 				 btrfs_ino(BTRFS_I(inode)), 0);
@@ -7919,7 +7918,7 @@ static void btrfs_retry_endio(struct bio *bio)
 	struct bio_vec *bvec;
 	int uptodate;
 	int ret;
-	int i;
+	int i = 0;
 	struct bvec_iter_all iter_all;
 
 	if (bio->bi_status)
@@ -7934,7 +7933,7 @@ static void btrfs_retry_endio(struct bio *bio)
 	failure_tree = &BTRFS_I(inode)->io_failure_tree;
 
 	ASSERT(!bio_flagged(bio, BIO_CLONED));
-	bio_for_each_segment_all(bvec, bio, i, iter_all) {
+	bio_for_each_segment_all(bvec, bio, iter_all) {
 		ret = __readpage_endio_check(inode, io_bio, i, bvec->bv_page,
 					     bvec->bv_offset, done->start,
 					     bvec->bv_len);
@@ -7946,6 +7945,7 @@ static void btrfs_retry_endio(struct bio *bio)
 					 bvec->bv_offset);
 		else
 			uptodate = 0;
+		i++;
 	}
 
 	done->uptodate = uptodate;
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 67a6f7d47402..f3d0576dd327 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1442,12 +1442,11 @@ static int fail_bio_stripe(struct btrfs_raid_bio *rbio,
 static void set_bio_pages_uptodate(struct bio *bio)
 {
 	struct bio_vec *bvec;
-	int i;
 	struct bvec_iter_all iter_all;
 
 	ASSERT(!bio_flagged(bio, BIO_CLONED));
 
-	bio_for_each_segment_all(bvec, bio, i, iter_all)
+	bio_for_each_segment_all(bvec, bio, iter_all)
 		SetPageUptodate(bvec->bv_page);
 }
 
diff --git a/fs/crypto/bio.c b/fs/crypto/bio.c
index 5759bcd018cd..8f3a8bc15d98 100644
--- a/fs/crypto/bio.c
+++ b/fs/crypto/bio.c
@@ -29,10 +29,9 @@
 static void __fscrypt_decrypt_bio(struct bio *bio, bool done)
 {
 	struct bio_vec *bv;
-	int i;
 	struct bvec_iter_all iter_all;
 
-	bio_for_each_segment_all(bv, bio, i, iter_all) {
+	bio_for_each_segment_all(bv, bio, iter_all) {
 		struct page *page = bv->bv_page;
 		int ret = fscrypt_decrypt_page(page->mapping->host, page,
 				PAGE_SIZE, 0, page->index);
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 9bb015bc4a83..fbe885d68035 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -538,7 +538,6 @@ static struct bio *dio_await_one(struct dio *dio)
 static blk_status_t dio_bio_complete(struct dio *dio, struct bio *bio)
 {
 	struct bio_vec *bvec;
-	unsigned i;
 	blk_status_t err = bio->bi_status;
 
 	if (err) {
@@ -553,7 +552,7 @@ static blk_status_t dio_bio_complete(struct dio *dio, struct bio *bio)
 	} else {
 		struct bvec_iter_all iter_all;
 
-		bio_for_each_segment_all(bvec, bio, i, iter_all) {
+		bio_for_each_segment_all(bvec, bio, iter_all) {
 			struct page *page = bvec->bv_page;
 
 			if (dio->op == REQ_OP_READ && !PageCompound(page) &&
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 3e9298e6a705..4690618a92e9 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -61,11 +61,10 @@ static void buffer_io_error(struct buffer_head *bh)
 
 static void ext4_finish_bio(struct bio *bio)
 {
-	int i;
 	struct bio_vec *bvec;
 	struct bvec_iter_all iter_all;
 
-	bio_for_each_segment_all(bvec, bio, i, iter_all) {
+	bio_for_each_segment_all(bvec, bio, iter_all) {
 		struct page *page = bvec->bv_page;
 #ifdef CONFIG_FS_ENCRYPTION
 		struct page *data_page = NULL;
diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
index 3adadf461825..3629a74b7f94 100644
--- a/fs/ext4/readpage.c
+++ b/fs/ext4/readpage.c
@@ -71,7 +71,6 @@ static inline bool ext4_bio_encrypted(struct bio *bio)
 static void mpage_end_io(struct bio *bio)
 {
 	struct bio_vec *bv;
-	int i;
 	struct bvec_iter_all iter_all;
 
 	if (ext4_bio_encrypted(bio)) {
@@ -82,7 +81,7 @@ static void mpage_end_io(struct bio *bio)
 			return;
 		}
 	}
-	bio_for_each_segment_all(bv, bio, i, iter_all) {
+	bio_for_each_segment_all(bv, bio, iter_all) {
 		struct page *page = bv->bv_page;
 
 		if (!bio->bi_status) {
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 9727944139f2..64040e998439 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -86,10 +86,9 @@ static void __read_end_io(struct bio *bio)
 {
 	struct page *page;
 	struct bio_vec *bv;
-	int i;
 	struct bvec_iter_all iter_all;
 
-	bio_for_each_segment_all(bv, bio, i, iter_all) {
+	bio_for_each_segment_all(bv, bio, iter_all) {
 		page = bv->bv_page;
 
 		/* PG_error was set if any post_read step failed */
@@ -164,7 +163,6 @@ static void f2fs_write_end_io(struct bio *bio)
 {
 	struct f2fs_sb_info *sbi = bio->bi_private;
 	struct bio_vec *bvec;
-	int i;
 	struct bvec_iter_all iter_all;
 
 	if (time_to_inject(sbi, FAULT_WRITE_IO)) {
@@ -172,7 +170,7 @@ static void f2fs_write_end_io(struct bio *bio)
 		bio->bi_status = BLK_STS_IOERR;
 	}
 
-	bio_for_each_segment_all(bvec, bio, i, iter_all) {
+	bio_for_each_segment_all(bvec, bio, iter_all) {
 		struct page *page = bvec->bv_page;
 		enum count_type type = WB_DATA_TYPE(page);
 
@@ -349,7 +347,6 @@ static bool __has_merged_page(struct f2fs_bio_info *io, struct inode *inode,
 {
 	struct bio_vec *bvec;
 	struct page *target;
-	int i;
 	struct bvec_iter_all iter_all;
 
 	if (!io->bio)
@@ -358,7 +355,7 @@ static bool __has_merged_page(struct f2fs_bio_info *io, struct inode *inode,
 	if (!inode && !page && !ino)
 		return true;
 
-	bio_for_each_segment_all(bvec, io->bio, i, iter_all) {
+	bio_for_each_segment_all(bvec, io->bio, iter_all) {
 
 		if (bvec->bv_page->mapping)
 			target = bvec->bv_page;
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 8722c60b11fe..6f09b5e3dd6e 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -207,7 +207,6 @@ static void gfs2_end_log_write(struct bio *bio)
 	struct gfs2_sbd *sdp = bio->bi_private;
 	struct bio_vec *bvec;
 	struct page *page;
-	int i;
 	struct bvec_iter_all iter_all;
 
 	if (bio->bi_status) {
@@ -216,7 +215,7 @@ static void gfs2_end_log_write(struct bio *bio)
 		wake_up(&sdp->sd_logd_waitq);
 	}
 
-	bio_for_each_segment_all(bvec, bio, i, iter_all) {
+	bio_for_each_segment_all(bvec, bio, iter_all) {
 		page = bvec->bv_page;
 		if (page_has_buffers(page))
 			gfs2_end_log_write_bh(sdp, bvec, bio->bi_status);
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 3201342404a7..ff86e1d4f8ff 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -189,10 +189,9 @@ struct buffer_head *gfs2_meta_new(struct gfs2_glock *gl, u64 blkno)
 static void gfs2_meta_read_endio(struct bio *bio)
 {
 	struct bio_vec *bvec;
-	int i;
 	struct bvec_iter_all iter_all;
 
-	bio_for_each_segment_all(bvec, bio, i, iter_all) {
+	bio_for_each_segment_all(bvec, bio, iter_all) {
 		struct page *page = bvec->bv_page;
 		struct buffer_head *bh = page_buffers(page);
 		unsigned int len = bvec->bv_len;
diff --git a/fs/iomap.c b/fs/iomap.c
index abdd18e404f8..12a656271076 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -273,10 +273,9 @@ iomap_read_end_io(struct bio *bio)
 {
 	int error = blk_status_to_errno(bio->bi_status);
 	struct bio_vec *bvec;
-	int i;
 	struct bvec_iter_all iter_all;
 
-	bio_for_each_segment_all(bvec, bio, i, iter_all)
+	bio_for_each_segment_all(bvec, bio, iter_all)
 		iomap_read_page_end_io(bvec, error);
 	bio_put(bio);
 }
@@ -1592,9 +1591,8 @@ static void iomap_dio_bio_end_io(struct bio *bio)
 		if (!bio_flagged(bio, BIO_NO_PAGE_REF)) {
 			struct bvec_iter_all iter_all;
 			struct bio_vec *bvec;
-			int i;
 
-			bio_for_each_segment_all(bvec, bio, i, iter_all)
+			bio_for_each_segment_all(bvec, bio, iter_all)
 				put_page(bvec->bv_page);
 		}
 		bio_put(bio);
diff --git a/fs/mpage.c b/fs/mpage.c
index 3f19da75178b..436a85260394 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -47,10 +47,9 @@
 static void mpage_end_io(struct bio *bio)
 {
 	struct bio_vec *bv;
-	int i;
 	struct bvec_iter_all iter_all;
 
-	bio_for_each_segment_all(bv, bio, i, iter_all) {
+	bio_for_each_segment_all(bv, bio, iter_all) {
 		struct page *page = bv->bv_page;
 		page_endio(page, bio_op(bio),
 			   blk_status_to_errno(bio->bi_status));
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 3619e9e8d359..47941bbaac02 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -98,7 +98,6 @@ xfs_destroy_ioend(
 
 	for (bio = &ioend->io_inline_bio; bio; bio = next) {
 		struct bio_vec	*bvec;
-		int		i;
 		struct bvec_iter_all iter_all;
 
 		/*
@@ -111,7 +110,7 @@ xfs_destroy_ioend(
 			next = bio->bi_private;
 
 		/* walk each page on bio, ending page IO on them */
-		bio_for_each_segment_all(bvec, bio, i, iter_all)
+		bio_for_each_segment_all(bvec, bio, iter_all)
 			xfs_finish_page_writeback(inode, bvec, error);
 		bio_put(bio);
 	}
diff --git a/include/linux/bio.h b/include/linux/bio.h
index e584673c1881..077cecdf9437 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -134,9 +134,8 @@ static inline bool bio_next_segment(const struct bio *bio,
  * drivers should _never_ use the all version - the bio may have been split
  * before it got to the driver and the driver won't own all of it
  */
-#define bio_for_each_segment_all(bvl, bio, i, iter)			\
-	for (i = 0, bvl = bvec_init_iter_all(&iter);			\
-	     bio_next_segment((bio), &iter); i++)
+#define bio_for_each_segment_all(bvl, bio, iter) \
+	for (bvl = bvec_init_iter_all(&iter); bio_next_segment((bio), &iter); )
 
 static inline void bio_advance_iter(struct bio *bio, struct bvec_iter *iter,
 				    unsigned bytes)
-- 
2.20.1

