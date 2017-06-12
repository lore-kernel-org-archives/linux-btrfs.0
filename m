Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33113 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753442AbdFLPaq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Jun 2017 11:30:46 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 38823AB46
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Jun 2017 15:30:45 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/3] btrfs: sink gfp parameter to btrfs_io_bio_alloc
Date: Mon, 12 Jun 2017 17:29:41 +0200
Message-Id: <12ee2bbac3ad848182e50d90d1c810703d0504a1.1497281195.git.dsterba@suse.com>
In-Reply-To: <cover.1497281195.git.dsterba@suse.com>
References: <cover.1497281195.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can hardcode GFP_NOFS to btrfs_io_bio_alloc, although it means we
change it back from GFP_KERNEL in scrub. I'd rather save a few stack
bytes from not passing the gfp flags in the remaining, more imporatant,
contexts and the bio allocating API now looks more consistent.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/check-integrity.c |  2 +-
 fs/btrfs/disk-io.c         |  2 +-
 fs/btrfs/extent_io.c       |  8 ++++----
 fs/btrfs/extent_io.h       |  2 +-
 fs/btrfs/raid56.c          |  2 +-
 fs/btrfs/scrub.c           | 16 +++++++---------
 6 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 160879c802d0..e3b1d08dd03c 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -1638,7 +1638,7 @@ static int btrfsic_read_block(struct btrfsic_state *state,
 		struct bio *bio;
 		unsigned int j;
 
-		bio = btrfs_io_bio_alloc(GFP_NOFS, num_pages - i);
+		bio = btrfs_io_bio_alloc(num_pages - i);
 		bio->bi_bdev = block_ctx->dev->bdev;
 		bio->bi_iter.bi_sector = dev_bytenr >> 9;
 		bio_set_op_attrs(bio, REQ_OP_READ, 0);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 9f2ffe2c6afb..8b57c280e5cd 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3532,7 +3532,7 @@ static int write_dev_flush(struct btrfs_device *device, int wait)
 	 * caller
 	 */
 	device->flush_bio = NULL;
-	bio = btrfs_io_bio_alloc(GFP_NOFS, 0);
+	bio = btrfs_io_bio_alloc(0);
 	bio->bi_end_io = btrfs_end_empty_barrier;
 	bio->bi_bdev = device->bdev;
 	bio->bi_opf = REQ_OP_WRITE | REQ_SYNC | REQ_PREFLUSH;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index cbd0a9a1daa5..29a6111a68d2 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1987,7 +1987,7 @@ int repair_io_failure(struct btrfs_fs_info *fs_info, u64 ino, u64 start,
 	ASSERT(!(fs_info->sb->s_flags & MS_RDONLY));
 	BUG_ON(!mirror_num);
 
-	bio = btrfs_io_bio_alloc(GFP_NOFS, 1);
+	bio = btrfs_io_bio_alloc(1);
 	bio->bi_iter.bi_size = 0;
 	map_length = length;
 
@@ -2331,7 +2331,7 @@ struct bio *btrfs_create_repair_bio(struct inode *inode, struct bio *failed_bio,
 	struct btrfs_io_bio *btrfs_failed_bio;
 	struct btrfs_io_bio *btrfs_bio;
 
-	bio = btrfs_io_bio_alloc(GFP_NOFS, 1);
+	bio = btrfs_io_bio_alloc(1);
 	bio->bi_end_io = endio_func;
 	bio->bi_iter.bi_sector = failrec->logical >> 9;
 	bio->bi_bdev = fs_info->fs_devices->latest_bdev;
@@ -2692,12 +2692,12 @@ struct bio *btrfs_bio_clone(struct bio *bio)
 	return new;
 }
 
-struct bio *btrfs_io_bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs)
+struct bio *btrfs_io_bio_alloc(unsigned int nr_iovecs)
 {
 	struct bio *bio;
 
 	/* Bio allocation backed by a bioset does not fail */
-	bio = bio_alloc_bioset(gfp_mask, nr_iovecs, btrfs_bioset);
+	bio = bio_alloc_bioset(GFP_NOFS, nr_iovecs, btrfs_bioset);
 	btrfs_io_bio_init(btrfs_io_bio(bio));
 	return bio;
 }
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 8071e3977614..1e508a8f876e 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -463,7 +463,7 @@ void extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
 				 unsigned bits_to_clear,
 				 unsigned long page_ops);
 struct bio *btrfs_bio_alloc(struct block_device *bdev, u64 first_byte);
-struct bio *btrfs_io_bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs);
+struct bio *btrfs_io_bio_alloc(unsigned int nr_iovecs);
 struct bio *btrfs_bio_clone(struct bio *bio);
 struct bio *btrfs_bio_clone_partial(struct bio *orig, int offset, int size);
 
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 7dd55448ac68..b9abb0b01021 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1098,7 +1098,7 @@ static int rbio_add_io_page(struct btrfs_raid_bio *rbio,
 	}
 
 	/* put a new bio on the list */
-	bio = btrfs_io_bio_alloc(GFP_NOFS, bio_max_len >> PAGE_SHIFT?:1);
+	bio = btrfs_io_bio_alloc(bio_max_len >> PAGE_SHIFT ?: 1);
 	bio->bi_iter.bi_size = 0;
 	bio->bi_bdev = stripe->dev->bdev;
 	bio->bi_iter.bi_sector = disk_start >> 9;
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 1e2dfea00b2f..58a249cd5adc 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1737,7 +1737,7 @@ static void scrub_recheck_block(struct btrfs_fs_info *fs_info,
 		}
 
 		WARN_ON(!page->page);
-		bio = btrfs_io_bio_alloc(GFP_NOFS, 1);
+		bio = btrfs_io_bio_alloc(1);
 		bio->bi_bdev = page->dev->bdev;
 
 		bio_add_page(bio, page->page, PAGE_SIZE, 0);
@@ -1825,7 +1825,7 @@ static int scrub_repair_page_from_good_copy(struct scrub_block *sblock_bad,
 			return -EIO;
 		}
 
-		bio = btrfs_io_bio_alloc(GFP_NOFS, 1);
+		bio = btrfs_io_bio_alloc(1);
 		bio->bi_bdev = page_bad->dev->bdev;
 		bio->bi_iter.bi_sector = page_bad->physical >> 9;
 		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
@@ -1915,8 +1915,7 @@ static int scrub_add_page_to_wr_bio(struct scrub_ctx *sctx,
 		sbio->dev = sctx->wr_tgtdev;
 		bio = sbio->bio;
 		if (!bio) {
-			bio = btrfs_io_bio_alloc(GFP_KERNEL,
-					sctx->pages_per_wr_bio);
+			bio = btrfs_io_bio_alloc(sctx->pages_per_wr_bio);
 			sbio->bio = bio;
 		}
 
@@ -2316,8 +2315,7 @@ static int scrub_add_page_to_rd_bio(struct scrub_ctx *sctx,
 		sbio->dev = spage->dev;
 		bio = sbio->bio;
 		if (!bio) {
-			bio = btrfs_io_bio_alloc(GFP_KERNEL,
-					sctx->pages_per_rd_bio);
+			bio = btrfs_io_bio_alloc(sctx->pages_per_rd_bio);
 			sbio->bio = bio;
 		}
 
@@ -2443,7 +2441,7 @@ static void scrub_missing_raid56_pages(struct scrub_block *sblock)
 		goto bbio_out;
 	}
 
-	bio = btrfs_io_bio_alloc(GFP_NOFS, 0);
+	bio = btrfs_io_bio_alloc(0);
 	bio->bi_iter.bi_sector = logical >> 9;
 	bio->bi_private = sblock;
 	bio->bi_end_io = scrub_missing_raid56_end_io;
@@ -3019,7 +3017,7 @@ static void scrub_parity_check_and_repair(struct scrub_parity *sparity)
 	if (ret || !bbio || !bbio->raid_map)
 		goto bbio_out;
 
-	bio = btrfs_io_bio_alloc(GFP_NOFS, 0);
+	bio = btrfs_io_bio_alloc(0);
 	bio->bi_iter.bi_sector = sparity->logic_start >> 9;
 	bio->bi_private = sparity;
 	bio->bi_end_io = scrub_parity_bio_endio;
@@ -4626,7 +4624,7 @@ static int write_page_nocow(struct scrub_ctx *sctx,
 			"scrub write_page_nocow(bdev == NULL) is unexpected");
 		return -EIO;
 	}
-	bio = btrfs_io_bio_alloc(GFP_NOFS, 1);
+	bio = btrfs_io_bio_alloc(1);
 	bio->bi_iter.bi_size = 0;
 	bio->bi_iter.bi_sector = physical_for_dev_replace >> 9;
 	bio->bi_bdev = dev->bdev;
-- 
2.13.0

