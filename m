Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34850 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751140AbdFBQ7u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Jun 2017 12:59:50 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 56F6EAAB9
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Jun 2017 16:59:39 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 4/8] btrfs: btrfs_io_bio_alloc never fails, skip error handling
Date: Fri,  2 Jun 2017 18:58:39 +0200
Message-Id: <9035b5dbc57608ed73960504bfc1415ed579dac4.1496422340.git.dsterba@suse.com>
In-Reply-To: <cover.1496422340.git.dsterba@suse.com>
References: <cover.1496422340.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Update direct callers of btrfs_io_bio_alloc that do error handling, that
we can now remove.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/check-integrity.c |  5 -----
 fs/btrfs/disk-io.c         |  3 ---
 fs/btrfs/extent_io.c       |  5 -----
 fs/btrfs/raid56.c          |  3 ---
 fs/btrfs/scrub.c           | 25 -------------------------
 5 files changed, 41 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 6cabc8acee2a..8d1ba84b61f3 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -1639,11 +1639,6 @@ static int btrfsic_read_block(struct btrfsic_state *state,
 		unsigned int j;
 
 		bio = btrfs_io_bio_alloc(GFP_NOFS, num_pages - i);
-		if (!bio) {
-			pr_info("btrfsic: bio_alloc() for %u pages failed!\n",
-			       num_pages - i);
-			return -1;
-		}
 		bio->bi_bdev = block_ctx->dev->bdev;
 		bio->bi_iter.bi_sector = dev_bytenr >> 9;
 		bio_set_op_attrs(bio, REQ_OP_READ, 0);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index cb79bce3a972..9f2ffe2c6afb 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3533,9 +3533,6 @@ static int write_dev_flush(struct btrfs_device *device, int wait)
 	 */
 	device->flush_bio = NULL;
 	bio = btrfs_io_bio_alloc(GFP_NOFS, 0);
-	if (!bio)
-		return -ENOMEM;
-
 	bio->bi_end_io = btrfs_end_empty_barrier;
 	bio->bi_bdev = device->bdev;
 	bio->bi_opf = REQ_OP_WRITE | REQ_SYNC | REQ_PREFLUSH;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 17f80a18e787..a10906915bc9 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1988,8 +1988,6 @@ int repair_io_failure(struct btrfs_fs_info *fs_info, u64 ino, u64 start,
 	BUG_ON(!mirror_num);
 
 	bio = btrfs_io_bio_alloc(GFP_NOFS, 1);
-	if (!bio)
-		return -EIO;
 	bio->bi_iter.bi_size = 0;
 	map_length = length;
 
@@ -2334,9 +2332,6 @@ struct bio *btrfs_create_repair_bio(struct inode *inode, struct bio *failed_bio,
 	struct btrfs_io_bio *btrfs_bio;
 
 	bio = btrfs_io_bio_alloc(GFP_NOFS, 1);
-	if (!bio)
-		return NULL;
-
 	bio->bi_end_io = endio_func;
 	bio->bi_iter.bi_sector = failrec->logical >> 9;
 	bio->bi_bdev = fs_info->fs_devices->latest_bdev;
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index d8ea0eb76325..6938da452041 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1102,9 +1102,6 @@ static int rbio_add_io_page(struct btrfs_raid_bio *rbio,
 
 	/* put a new bio on the list */
 	bio = btrfs_io_bio_alloc(GFP_NOFS, bio_max_len >> PAGE_SHIFT?:1);
-	if (!bio)
-		return -ENOMEM;
-
 	bio->bi_iter.bi_size = 0;
 	bio->bi_bdev = stripe->dev->bdev;
 	bio->bi_iter.bi_sector = disk_start >> 9;
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index e99be644b19f..75f1966ca1d3 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1729,11 +1729,6 @@ static void scrub_recheck_block(struct btrfs_fs_info *fs_info,
 
 		WARN_ON(!page->page);
 		bio = btrfs_io_bio_alloc(GFP_NOFS, 1);
-		if (!bio) {
-			page->io_error = 1;
-			sblock->no_io_error_seen = 0;
-			continue;
-		}
 		bio->bi_bdev = page->dev->bdev;
 
 		bio_add_page(bio, page->page, PAGE_SIZE, 0);
@@ -1822,8 +1817,6 @@ static int scrub_repair_page_from_good_copy(struct scrub_block *sblock_bad,
 		}
 
 		bio = btrfs_io_bio_alloc(GFP_NOFS, 1);
-		if (!bio)
-			return -EIO;
 		bio->bi_bdev = page_bad->dev->bdev;
 		bio->bi_iter.bi_sector = page_bad->physical >> 9;
 		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
@@ -1915,10 +1908,6 @@ static int scrub_add_page_to_wr_bio(struct scrub_ctx *sctx,
 		if (!bio) {
 			bio = btrfs_io_bio_alloc(GFP_KERNEL,
 					sctx->pages_per_wr_bio);
-			if (!bio) {
-				mutex_unlock(&sctx->wr_lock);
-				return -ENOMEM;
-			}
 			sbio->bio = bio;
 		}
 
@@ -2320,8 +2309,6 @@ static int scrub_add_page_to_rd_bio(struct scrub_ctx *sctx,
 		if (!bio) {
 			bio = btrfs_io_bio_alloc(GFP_KERNEL,
 					sctx->pages_per_rd_bio);
-			if (!bio)
-				return -ENOMEM;
 			sbio->bio = bio;
 		}
 
@@ -2448,9 +2435,6 @@ static void scrub_missing_raid56_pages(struct scrub_block *sblock)
 	}
 
 	bio = btrfs_io_bio_alloc(GFP_NOFS, 0);
-	if (!bio)
-		goto bbio_out;
-
 	bio->bi_iter.bi_sector = logical >> 9;
 	bio->bi_private = sblock;
 	bio->bi_end_io = scrub_missing_raid56_end_io;
@@ -3027,9 +3011,6 @@ static void scrub_parity_check_and_repair(struct scrub_parity *sparity)
 		goto bbio_out;
 
 	bio = btrfs_io_bio_alloc(GFP_NOFS, 0);
-	if (!bio)
-		goto bbio_out;
-
 	bio->bi_iter.bi_sector = sparity->logic_start >> 9;
 	bio->bi_private = sparity;
 	bio->bi_end_io = scrub_parity_bio_endio;
@@ -4637,12 +4618,6 @@ static int write_page_nocow(struct scrub_ctx *sctx,
 		return -EIO;
 	}
 	bio = btrfs_io_bio_alloc(GFP_NOFS, 1);
-	if (!bio) {
-		spin_lock(&sctx->stat_lock);
-		sctx->stat.malloc_errors++;
-		spin_unlock(&sctx->stat_lock);
-		return -ENOMEM;
-	}
 	bio->bi_iter.bi_size = 0;
 	bio->bi_iter.bi_sector = physical_for_dev_replace >> 9;
 	bio->bi_bdev = dev->bdev;
-- 
2.12.0

