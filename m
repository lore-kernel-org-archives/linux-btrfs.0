Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:47161 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab3KXECf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Nov 2013 23:02:35 -0500
Received: by mail-pb0-f47.google.com with SMTP id um1so3503232pbc.34
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Nov 2013 20:02:34 -0800 (PST)
From: Kent Overstreet <kmo@daterainc.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Cc: Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        Joern Engel <joern@logfs.org>,
        Prasad Joshi <prasadjoshi.linux@gmail.com>, Neil Brown <neilb@suse.de>,
        Chris Mason <chris.mason@fusionio.com>
Subject: [PATCH] block: submit_bio_wait() conversions
Date: Sat, 23 Nov 2013 20:03:30 -0800
Message-Id: <1385265810-16095-1-git-send-email-kmo@daterainc.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It was being open coded in a few places.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Joern Engel <joern@logfs.org>
Cc: Prasad Joshi <prasadjoshi.linux@gmail.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Chris Mason <chris.mason@fusionio.com>
---
 block/blk-flush.c          | 19 +------------------
 drivers/md/md.c            | 12 +-----------
 fs/btrfs/check-integrity.c | 32 +++++++++++++-------------------
 fs/btrfs/check-integrity.h |  2 ++
 fs/btrfs/extent_io.c       | 12 +-----------
 fs/btrfs/scrub.c           | 33 ++++-----------------------------
 fs/hfsplus/wrapper.c       | 17 +----------------
 fs/logfs/dev_bdev.c        | 13 +------------
 8 files changed, 24 insertions(+), 116 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 331e627..fb6f3c0 100644
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
 		*error_sector = bio->bi_sector;
 
-	if (!bio_flagged(bio, BIO_UPTODATE))
-		ret = -EIO;
-
 	bio_put(bio);
 	return ret;
 }
diff --git a/drivers/md/md.c b/drivers/md/md.c
index b6b7a28..8700de3 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -776,16 +776,10 @@ void md_super_wait(struct mddev *mddev)
 	finish_wait(&mddev->sb_wait, &wq);
 }
 
-static void bi_complete(struct bio *bio, int error)
-{
-	complete((struct completion*)bio->bi_private);
-}
-
 int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
 		 struct page *page, int rw, bool metadata_op)
 {
 	struct bio *bio = bio_alloc_mddev(GFP_NOIO, 1, rdev->mddev);
-	struct completion event;
 	int ret;
 
 	rw |= REQ_SYNC;
@@ -801,11 +795,7 @@ int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
 	else
 		bio->bi_sector = sector + rdev->data_offset;
 	bio_add_page(bio, page, size, 0);
-	init_completion(&event);
-	bio->bi_private = &event;
-	bio->bi_end_io = bi_complete;
-	submit_bio(rw, bio);
-	wait_for_completion(&event);
+	submit_bio_wait(rw, bio);
 
 	ret = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	bio_put(bio);
diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index b50764b..131d828 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -333,7 +333,6 @@ static void btrfsic_release_block_ctx(struct btrfsic_block_data_ctx *block_ctx);
 static int btrfsic_read_block(struct btrfsic_state *state,
 			      struct btrfsic_block_data_ctx *block_ctx);
 static void btrfsic_dump_database(struct btrfsic_state *state);
-static void btrfsic_complete_bio_end_io(struct bio *bio, int err);
 static int btrfsic_test_for_metadata(struct btrfsic_state *state,
 				     char **datav, unsigned int num_pages);
 static void btrfsic_process_written_block(struct btrfsic_dev_state *dev_state,
@@ -1687,7 +1686,6 @@ static int btrfsic_read_block(struct btrfsic_state *state,
 	for (i = 0; i < num_pages;) {
 		struct bio *bio;
 		unsigned int j;
-		DECLARE_COMPLETION_ONSTACK(complete);
 
 		bio = btrfs_io_bio_alloc(GFP_NOFS, num_pages - i);
 		if (!bio) {
@@ -1698,8 +1696,6 @@ static int btrfsic_read_block(struct btrfsic_state *state,
 		}
 		bio->bi_bdev = block_ctx->dev->bdev;
 		bio->bi_sector = dev_bytenr >> 9;
-		bio->bi_end_io = btrfsic_complete_bio_end_io;
-		bio->bi_private = &complete;
 
 		for (j = i; j < num_pages; j++) {
 			ret = bio_add_page(bio, block_ctx->pagev[j],
@@ -1712,12 +1708,7 @@ static int btrfsic_read_block(struct btrfsic_state *state,
 			       "btrfsic: error, failed to add a single page!\n");
 			return -1;
 		}
-		submit_bio(READ, bio);
-
-		/* this will also unplug the queue */
-		wait_for_completion(&complete);
-
-		if (!test_bit(BIO_UPTODATE, &bio->bi_flags)) {
+		if (submit_bio_wait(READ, bio)) {
 			printk(KERN_INFO
 			       "btrfsic: read error at logical %llu dev %s!\n",
 			       block_ctx->start, block_ctx->dev->name);
@@ -1740,11 +1731,6 @@ static int btrfsic_read_block(struct btrfsic_state *state,
 	return block_ctx->len;
 }
 
-static void btrfsic_complete_bio_end_io(struct bio *bio, int err)
-{
-	complete((struct completion *)bio->bi_private);
-}
-
 static void btrfsic_dump_database(struct btrfsic_state *state)
 {
 	struct list_head *elem_all;
@@ -3008,14 +2994,12 @@ int btrfsic_submit_bh(int rw, struct buffer_head *bh)
 	return submit_bh(rw, bh);
 }
 
-void btrfsic_submit_bio(int rw, struct bio *bio)
+static void __btrfsic_submit_bio(int rw, struct bio *bio)
 {
 	struct btrfsic_dev_state *dev_state;
 
-	if (!btrfsic_is_initialized) {
-		submit_bio(rw, bio);
+	if (!btrfsic_is_initialized)
 		return;
-	}
 
 	mutex_lock(&btrfsic_mutex);
 	/* since btrfsic_submit_bio() is also called before
@@ -3106,10 +3090,20 @@ void btrfsic_submit_bio(int rw, struct bio *bio)
 	}
 leave:
 	mutex_unlock(&btrfsic_mutex);
+}
 
+void btrfsic_submit_bio(int rw, struct bio *bio)
+{
+	__btrfsic_submit_bio(rw, bio);
 	submit_bio(rw, bio);
 }
 
+int btrfsic_submit_bio_wait(int rw, struct bio *bio)
+{
+	__btrfsic_submit_bio(rw, bio);
+	return submit_bio_wait(rw, bio);
+}
+
 int btrfsic_mount(struct btrfs_root *root,
 		  struct btrfs_fs_devices *fs_devices,
 		  int including_extent_data, u32 print_mask)
diff --git a/fs/btrfs/check-integrity.h b/fs/btrfs/check-integrity.h
index 8b59175..13b8566 100644
--- a/fs/btrfs/check-integrity.h
+++ b/fs/btrfs/check-integrity.h
@@ -22,9 +22,11 @@
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 int btrfsic_submit_bh(int rw, struct buffer_head *bh);
 void btrfsic_submit_bio(int rw, struct bio *bio);
+int btrfsic_submit_bio_wait(int rw, struct bio *bio);
 #else
 #define btrfsic_submit_bh submit_bh
 #define btrfsic_submit_bio submit_bio
+#define btrfsic_submit_bio_wait submit_bio_wait
 #endif
 
 int btrfsic_mount(struct btrfs_root *root,
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8e457fc..ff43802 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1952,11 +1952,6 @@ static int free_io_failure(struct inode *inode, struct io_failure_record *rec,
 	return err;
 }
 
-static void repair_io_failure_callback(struct bio *bio, int err)
-{
-	complete(bio->bi_private);
-}
-
 /*
  * this bypasses the standard btrfs submit functions deliberately, as
  * the standard behavior is to write all copies in a raid setup. here we only
@@ -1973,7 +1968,6 @@ int repair_io_failure(struct btrfs_fs_info *fs_info, u64 start,
 {
 	struct bio *bio;
 	struct btrfs_device *dev;
-	DECLARE_COMPLETION_ONSTACK(compl);
 	u64 map_length = 0;
 	u64 sector;
 	struct btrfs_bio *bbio = NULL;
@@ -1990,8 +1984,6 @@ int repair_io_failure(struct btrfs_fs_info *fs_info, u64 start,
 	bio = btrfs_io_bio_alloc(GFP_NOFS, 1);
 	if (!bio)
 		return -EIO;
-	bio->bi_private = &compl;
-	bio->bi_end_io = repair_io_failure_callback;
 	bio->bi_size = 0;
 	map_length = length;
 
@@ -2012,10 +2004,8 @@ int repair_io_failure(struct btrfs_fs_info *fs_info, u64 start,
 	}
 	bio->bi_bdev = dev->bdev;
 	bio_add_page(bio, page, length, start - page_offset(page));
-	btrfsic_submit_bio(WRITE_SYNC, bio);
-	wait_for_completion(&compl);
 
-	if (!test_bit(BIO_UPTODATE, &bio->bi_flags)) {
+	if (btrfsic_submit_bio_wait(WRITE_SYNC, bio)) {
 		/* try to remap that extent elsewhere? */
 		bio_put(bio);
 		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_WRITE_ERRS);
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 561e2f1..1fd3f33 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -208,7 +208,6 @@ static void scrub_recheck_block_checksum(struct btrfs_fs_info *fs_info,
 					 int is_metadata, int have_csum,
 					 const u8 *csum, u64 generation,
 					 u16 csum_size);
-static void scrub_complete_bio_end_io(struct bio *bio, int err);
 static int scrub_repair_block_from_good_copy(struct scrub_block *sblock_bad,
 					     struct scrub_block *sblock_good,
 					     int force_write);
@@ -1294,7 +1293,6 @@ static void scrub_recheck_block(struct btrfs_fs_info *fs_info,
 	for (page_num = 0; page_num < sblock->page_count; page_num++) {
 		struct bio *bio;
 		struct scrub_page *page = sblock->pagev[page_num];
-		DECLARE_COMPLETION_ONSTACK(complete);
 
 		if (page->dev->bdev == NULL) {
 			page->io_error = 1;
@@ -1311,18 +1309,11 @@ static void scrub_recheck_block(struct btrfs_fs_info *fs_info,
 		}
 		bio->bi_bdev = page->dev->bdev;
 		bio->bi_sector = page->physical >> 9;
-		bio->bi_end_io = scrub_complete_bio_end_io;
-		bio->bi_private = &complete;
 
 		bio_add_page(bio, page->page, PAGE_SIZE, 0);
-		btrfsic_submit_bio(READ, bio);
-
-		/* this will also unplug the queue */
-		wait_for_completion(&complete);
-
-		page->io_error = !test_bit(BIO_UPTODATE, &bio->bi_flags);
-		if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
+		if (btrfsic_submit_bio_wait(READ, bio))
 			sblock->no_io_error_seen = 0;
+
 		bio_put(bio);
 	}
 
@@ -1391,11 +1382,6 @@ static void scrub_recheck_block_checksum(struct btrfs_fs_info *fs_info,
 		sblock->checksum_error = 1;
 }
 
-static void scrub_complete_bio_end_io(struct bio *bio, int err)
-{
-	complete((struct completion *)bio->bi_private);
-}
-
 static int scrub_repair_block_from_good_copy(struct scrub_block *sblock_bad,
 					     struct scrub_block *sblock_good,
 					     int force_write)
@@ -1430,7 +1416,6 @@ static int scrub_repair_page_from_good_copy(struct scrub_block *sblock_bad,
 	    sblock_bad->checksum_error || page_bad->io_error) {
 		struct bio *bio;
 		int ret;
-		DECLARE_COMPLETION_ONSTACK(complete);
 
 		if (!page_bad->dev->bdev) {
 			printk_ratelimited(KERN_WARNING
@@ -1443,19 +1428,14 @@ static int scrub_repair_page_from_good_copy(struct scrub_block *sblock_bad,
 			return -EIO;
 		bio->bi_bdev = page_bad->dev->bdev;
 		bio->bi_sector = page_bad->physical >> 9;
-		bio->bi_end_io = scrub_complete_bio_end_io;
-		bio->bi_private = &complete;
 
 		ret = bio_add_page(bio, page_good->page, PAGE_SIZE, 0);
 		if (PAGE_SIZE != ret) {
 			bio_put(bio);
 			return -EIO;
 		}
-		btrfsic_submit_bio(WRITE, bio);
 
-		/* this will also unplug the queue */
-		wait_for_completion(&complete);
-		if (!bio_flagged(bio, BIO_UPTODATE)) {
+		if (btrfsic_submit_bio_wait(WRITE, bio)) {
 			btrfs_dev_stat_inc_and_print(page_bad->dev,
 				BTRFS_DEV_STAT_WRITE_ERRS);
 			btrfs_dev_replace_stats_inc(
@@ -3375,7 +3355,6 @@ static int write_page_nocow(struct scrub_ctx *sctx,
 	struct bio *bio;
 	struct btrfs_device *dev;
 	int ret;
-	DECLARE_COMPLETION_ONSTACK(compl);
 
 	dev = sctx->wr_ctx.tgtdev;
 	if (!dev)
@@ -3392,8 +3371,6 @@ static int write_page_nocow(struct scrub_ctx *sctx,
 		spin_unlock(&sctx->stat_lock);
 		return -ENOMEM;
 	}
-	bio->bi_private = &compl;
-	bio->bi_end_io = scrub_complete_bio_end_io;
 	bio->bi_size = 0;
 	bio->bi_sector = physical_for_dev_replace >> 9;
 	bio->bi_bdev = dev->bdev;
@@ -3404,10 +3381,8 @@ leave_with_eio:
 		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_WRITE_ERRS);
 		return -EIO;
 	}
-	btrfsic_submit_bio(WRITE_SYNC, bio);
-	wait_for_completion(&compl);
 
-	if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
+	if (btrfsic_submit_bio_wait(WRITE_SYNC, bio))
 		goto leave_with_eio;
 
 	bio_put(bio);
diff --git a/fs/hfsplus/wrapper.c b/fs/hfsplus/wrapper.c
index b51a607..e9a97a0 100644
--- a/fs/hfsplus/wrapper.c
+++ b/fs/hfsplus/wrapper.c
@@ -24,13 +24,6 @@ struct hfsplus_wd {
 	u16 embed_count;
 };
 
-static void hfsplus_end_io_sync(struct bio *bio, int err)
-{
-	if (err)
-		clear_bit(BIO_UPTODATE, &bio->bi_flags);
-	complete(bio->bi_private);
-}
-
 /*
  * hfsplus_submit_bio - Perfrom block I/O
  * @sb: super block of volume for I/O
@@ -53,7 +46,6 @@ static void hfsplus_end_io_sync(struct bio *bio, int err)
 int hfsplus_submit_bio(struct super_block *sb, sector_t sector,
 		void *buf, void **data, int rw)
 {
-	DECLARE_COMPLETION_ONSTACK(wait);
 	struct bio *bio;
 	int ret = 0;
 	u64 io_size;
@@ -73,8 +65,6 @@ int hfsplus_submit_bio(struct super_block *sb, sector_t sector,
 	bio = bio_alloc(GFP_NOIO, 1);
 	bio->bi_sector = sector;
 	bio->bi_bdev = sb->s_bdev;
-	bio->bi_end_io = hfsplus_end_io_sync;
-	bio->bi_private = &wait;
 
 	if (!(rw & WRITE) && data)
 		*data = (u8 *)buf + offset;
@@ -93,12 +83,7 @@ int hfsplus_submit_bio(struct super_block *sb, sector_t sector,
 		buf = (u8 *)buf + len;
 	}
 
-	submit_bio(rw, bio);
-	wait_for_completion(&wait);
-
-	if (!bio_flagged(bio, BIO_UPTODATE))
-		ret = -EIO;
-
+	ret = submit_bio_wait(rw, bio);
 out:
 	bio_put(bio);
 	return ret < 0 ? ret : 0;
diff --git a/fs/logfs/dev_bdev.c b/fs/logfs/dev_bdev.c
index 550475c..0f95f0d 100644
--- a/fs/logfs/dev_bdev.c
+++ b/fs/logfs/dev_bdev.c
@@ -14,16 +14,10 @@
 
 #define PAGE_OFS(ofs) ((ofs) & (PAGE_SIZE-1))
 
-static void request_complete(struct bio *bio, int err)
-{
-	complete((struct completion *)bio->bi_private);
-}
-
 static int sync_request(struct page *page, struct block_device *bdev, int rw)
 {
 	struct bio bio;
 	struct bio_vec bio_vec;
-	struct completion complete;
 
 	bio_init(&bio);
 	bio.bi_max_vecs = 1;
@@ -35,13 +29,8 @@ static int sync_request(struct page *page, struct block_device *bdev, int rw)
 	bio.bi_size = PAGE_SIZE;
 	bio.bi_bdev = bdev;
 	bio.bi_sector = page->index * (PAGE_SIZE >> 9);
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
1.8.4.4

