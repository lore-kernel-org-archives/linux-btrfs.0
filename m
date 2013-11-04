Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:62040 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab3KDXgl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Nov 2013 18:36:41 -0500
Received: by mail-pb0-f50.google.com with SMTP id uo15so33996pbc.23
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Nov 2013 15:36:40 -0800 (PST)
From: Kent Overstreet <kmo@daterainc.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Cc: axboe@kernel.dk, hch@infradead.org, Kent Overstreet <kmo@daterainc.com>,
        Joern Engel <joern@logfs.org>,
        Prasad Joshi <prasadjoshi.linux@gmail.com>
Subject: [PATCH 2/9] block: submit_bio_wait() conversions
Date: Mon,  4 Nov 2013 15:36:20 -0800
Message-Id: <1383608187-27368-3-git-send-email-kmo@daterainc.com>
In-Reply-To: <1383608187-27368-1-git-send-email-kmo@daterainc.com>
References: <1383608187-27368-1-git-send-email-kmo@daterainc.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It was being open coded in a few places.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Joern Engel <joern@logfs.org>
Cc: Prasad Joshi <prasadjoshi.linux@gmail.com>
---
 block/blk-flush.c   | 19 +------------------
 fs/logfs/dev_bdev.c |  8 +-------
 2 files changed, 2 insertions(+), 25 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 5580b05..9288aaf 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -502,15 +502,6 @@ void blk_abort_flushes(struct request_queue *q)
 	}
 }
 
-static void bio_end_flush(struct bio *bio, int err)
-{
-	if (err)
-		clear_bit(BIO_UPTODATE, &bio->bi_flags);
-	if (bio->bi_private)
-		complete(bio->bi_private);
-	bio_put(bio);
-}
-
 /**
  * blkdev_issue_flush - queue a flush
  * @bdev:	blockdev to issue flush for
@@ -526,7 +517,6 @@ static void bio_end_flush(struct bio *bio, int err)
 int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
 		sector_t *error_sector)
 {
-	DECLARE_COMPLETION_ONSTACK(wait);
 	struct request_queue *q;
 	struct bio *bio;
 	int ret = 0;
@@ -548,13 +538,9 @@ int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
 		return -ENXIO;
 
 	bio = bio_alloc(gfp_mask, 0);
-	bio->bi_end_io = bio_end_flush;
 	bio->bi_bdev = bdev;
-	bio->bi_private = &wait;
 
-	bio_get(bio);
-	submit_bio(WRITE_FLUSH, bio);
-	wait_for_completion_io(&wait);
+	ret = submit_bio_wait(WRITE_FLUSH, bio);
 
 	/*
 	 * The driver must store the error location in ->bi_sector, if
@@ -564,9 +550,6 @@ int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
 	if (error_sector)
 		*error_sector = bio->bi_iter.bi_sector;
 
-	if (!bio_flagged(bio, BIO_UPTODATE))
-		ret = -EIO;
-
 	bio_put(bio);
 	return ret;
 }
diff --git a/fs/logfs/dev_bdev.c b/fs/logfs/dev_bdev.c
index ca42715..80adce7 100644
--- a/fs/logfs/dev_bdev.c
+++ b/fs/logfs/dev_bdev.c
@@ -23,7 +23,6 @@ static int sync_request(struct page *page, struct block_device *bdev, int rw)
 {
 	struct bio bio;
 	struct bio_vec bio_vec;
-	struct completion complete;
 
 	bio_init(&bio);
 	bio.bi_max_vecs = 1;
@@ -35,13 +34,8 @@ static int sync_request(struct page *page, struct block_device *bdev, int rw)
 	bio.bi_iter.bi_size = PAGE_SIZE;
 	bio.bi_bdev = bdev;
 	bio.bi_iter.bi_sector = page->index * (PAGE_SIZE >> 9);
-	init_completion(&complete);
-	bio.bi_private = &complete;
-	bio.bi_end_io = request_complete;
 
-	submit_bio(rw, &bio);
-	wait_for_completion(&complete);
-	return test_bit(BIO_UPTODATE, &bio.bi_flags) ? 0 : -EIO;
+	return submit_bio_wait(rw, &bio);
 }
 
 static int bdev_readpage(void *_sb, struct page *page)
-- 
1.8.4.rc3

