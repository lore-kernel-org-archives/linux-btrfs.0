Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34008 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S966221AbeF2I44 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 04:56:56 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E8096AD6B
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2018 08:56:54 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 07/14] btrfs: open-code bio_set_op_attrs
Date: Fri, 29 Jun 2018 10:56:53 +0200
Message-Id: <6f48cf82f4b7bd05303b64b5c28beb7daba1dac4.1530262400.git.dsterba@suse.com>
In-Reply-To: <cover.1530262400.git.dsterba@suse.com>
References: <cover.1530262400.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The helper is trivial and marked as deprecated.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/check-integrity.c |  2 +-
 fs/btrfs/compression.c     |  4 ++--
 fs/btrfs/extent_io.c       |  2 +-
 fs/btrfs/inode.c           |  2 +-
 fs/btrfs/raid56.c          | 10 +++++-----
 fs/btrfs/scrub.c           |  6 +++---
 6 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index dc062b195c46..7addfa41b393 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -1624,7 +1624,7 @@ static int btrfsic_read_block(struct btrfsic_state *state,
 		bio = btrfs_io_bio_alloc(num_pages - i);
 		bio_set_dev(bio, block_ctx->dev->bdev);
 		bio->bi_iter.bi_sector = dev_bytenr >> 9;
-		bio_set_op_attrs(bio, REQ_OP_READ, 0);
+		bio->bi_opf = REQ_OP_READ;
 
 		for (j = i; j < num_pages; j++) {
 			ret = bio_add_page(bio, block_ctx->pagev[j],
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index f48794a36068..70dace47258b 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -609,7 +609,7 @@ blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	cb->len = bio->bi_iter.bi_size;
 
 	comp_bio = btrfs_bio_alloc(bdev, cur_disk_byte);
-	bio_set_op_attrs (comp_bio, REQ_OP_READ, 0);
+	comp_bio->bi_opf = REQ_OP_READ;
 	comp_bio->bi_private = cb;
 	comp_bio->bi_end_io = end_compressed_bio_read;
 	refcount_set(&cb->pending_bios, 1);
@@ -656,7 +656,7 @@ blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 			}
 
 			comp_bio = btrfs_bio_alloc(bdev, cur_disk_byte);
-			bio_set_op_attrs(comp_bio, REQ_OP_READ, 0);
+			comp_bio->bi_opf = REQ_OP_READ;
 			comp_bio->bi_private = cb;
 			comp_bio->bi_end_io = end_compressed_bio_read;
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 94ca8d644de9..8d86531150cd 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2401,7 +2401,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 				      start - page_offset(page),
 				      (int)phy_offset, failed_bio->bi_end_io,
 				      NULL);
-	bio_set_op_attrs(bio, REQ_OP_READ, read_mode);
+	bio->bi_opf = REQ_OP_READ | read_mode;
 
 	btrfs_debug(btrfs_sb(inode->i_sb),
 		"Repair Read Error: submitting new read[%#x] to this_mirror=%d, in_validation=%d",
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 02e12e8bffc4..0d0df4fae4b0 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7861,7 +7861,7 @@ static blk_status_t dio_read_error(struct inode *inode, struct bio *failed_bio,
 	isector >>= inode->i_sb->s_blocksize_bits;
 	bio = btrfs_create_repair_bio(inode, failed_bio, failrec, page,
 				pgoff, isector, repair_endio, repair_arg);
-	bio_set_op_attrs(bio, REQ_OP_READ, read_mode);
+	bio->bi_opf = REQ_OP_READ | read_mode;
 
 	btrfs_debug(BTRFS_I(inode)->root->fs_info,
 		    "repair DIO read error: submitting new dio read[%#x] to this_mirror=%d, in_validation=%d",
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 42631079c492..1a1b7d6c44cb 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1330,7 +1330,7 @@ static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
 
 		bio->bi_private = rbio;
 		bio->bi_end_io = raid_write_end_io;
-		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
+		bio->bi_opf = REQ_OP_WRITE;
 
 		submit_bio(bio);
 	}
@@ -1586,7 +1586,7 @@ static int raid56_rmw_stripe(struct btrfs_raid_bio *rbio)
 
 		bio->bi_private = rbio;
 		bio->bi_end_io = raid_rmw_end_io;
-		bio_set_op_attrs(bio, REQ_OP_READ, 0);
+		bio->bi_opf = REQ_OP_READ;
 
 		btrfs_bio_wq_end_io(rbio->fs_info, bio, BTRFS_WQ_ENDIO_RAID56);
 
@@ -2130,7 +2130,7 @@ static int __raid56_parity_recover(struct btrfs_raid_bio *rbio)
 
 		bio->bi_private = rbio;
 		bio->bi_end_io = raid_recover_end_io;
-		bio_set_op_attrs(bio, REQ_OP_READ, 0);
+		bio->bi_opf = REQ_OP_READ;
 
 		btrfs_bio_wq_end_io(rbio->fs_info, bio, BTRFS_WQ_ENDIO_RAID56);
 
@@ -2502,7 +2502,7 @@ static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
 
 		bio->bi_private = rbio;
 		bio->bi_end_io = raid_write_end_io;
-		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
+		bio->bi_opf = REQ_OP_WRITE;
 
 		submit_bio(bio);
 	}
@@ -2684,7 +2684,7 @@ static void raid56_parity_scrub_stripe(struct btrfs_raid_bio *rbio)
 
 		bio->bi_private = rbio;
 		bio->bi_end_io = raid56_parity_scrub_end_io;
-		bio_set_op_attrs(bio, REQ_OP_READ, 0);
+		bio->bi_opf = REQ_OP_READ;
 
 		btrfs_bio_wq_end_io(rbio->fs_info, bio, BTRFS_WQ_ENDIO_RAID56);
 
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 572306036477..4b127ecd5de5 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1865,7 +1865,7 @@ static int scrub_repair_page_from_good_copy(struct scrub_block *sblock_bad,
 		bio = btrfs_io_bio_alloc(1);
 		bio_set_dev(bio, page_bad->dev->bdev);
 		bio->bi_iter.bi_sector = page_bad->physical >> 9;
-		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
+		bio->bi_opf = REQ_OP_WRITE;
 
 		ret = bio_add_page(bio, page_good->page, PAGE_SIZE, 0);
 		if (PAGE_SIZE != ret) {
@@ -1960,7 +1960,7 @@ static int scrub_add_page_to_wr_bio(struct scrub_ctx *sctx,
 		bio->bi_end_io = scrub_wr_bio_end_io;
 		bio_set_dev(bio, sbio->dev->bdev);
 		bio->bi_iter.bi_sector = sbio->physical >> 9;
-		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
+		bio->bi_opf = REQ_OP_WRITE;
 		sbio->status = 0;
 	} else if (sbio->physical + sbio->page_count * PAGE_SIZE !=
 		   spage->physical_for_dev_replace ||
@@ -2360,7 +2360,7 @@ static int scrub_add_page_to_rd_bio(struct scrub_ctx *sctx,
 		bio->bi_end_io = scrub_bio_end_io;
 		bio_set_dev(bio, sbio->dev->bdev);
 		bio->bi_iter.bi_sector = sbio->physical >> 9;
-		bio_set_op_attrs(bio, REQ_OP_READ, 0);
+		bio->bi_opf = REQ_OP_READ;
 		sbio->status = 0;
 	} else if (sbio->physical + sbio->page_count * PAGE_SIZE !=
 		   spage->physical ||
-- 
2.17.1

