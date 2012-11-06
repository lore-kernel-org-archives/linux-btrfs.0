Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.136]:42279 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394Ab2KFQit (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Nov 2012 11:38:49 -0500
Received: from pizpot.store ([192.168.43.236])
	by jorabe.store (jorabe xp1) (RZmta 31.1 OK)
	with ESMTP id X02b46oA6CtA5q for <linux-btrfs@vger.kernel.org>;
	Tue, 6 Nov 2012 17:38:44 +0100 (CET)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 05/26] Btrfs: in scrub repair code, simplify alloc error handling
Date: Tue,  6 Nov 2012 17:38:23 +0100
Message-Id: <d01894ea56da98ccd313cf9fae7f9000affe1dca.1352217243.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <cover.1352214751.git.sbehrens@giantdisaster.de>

In the scrub repair code, the code is changed to handle memory
allocation errors a little bit smarter. The change is to handle
it just like a read error. This simplifies the code and removes
a couple of lines of code, since the code to handle read errors
is there anyway.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/scrub.c | 61 ++++++++++++++++++++++++--------------------------------
 1 file changed, 26 insertions(+), 35 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 7d38f40..fcd5bcc 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -151,10 +151,10 @@ static int scrub_setup_recheck_block(struct scrub_ctx *sctx,
 				     struct btrfs_mapping_tree *map_tree,
 				     u64 length, u64 logical,
 				     struct scrub_block *sblock);
-static int scrub_recheck_block(struct btrfs_fs_info *fs_info,
-			       struct scrub_block *sblock, int is_metadata,
-			       int have_csum, u8 *csum, u64 generation,
-			       u16 csum_size);
+static void scrub_recheck_block(struct btrfs_fs_info *fs_info,
+				struct scrub_block *sblock, int is_metadata,
+				int have_csum, u8 *csum, u64 generation,
+				u16 csum_size);
 static void scrub_recheck_block_checksum(struct btrfs_fs_info *fs_info,
 					 struct scrub_block *sblock,
 					 int is_metadata, int have_csum,
@@ -718,16 +718,8 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 	sblock_bad = sblocks_for_recheck + failed_mirror_index;
 
 	/* build and submit the bios for the failed mirror, check checksums */
-	ret = scrub_recheck_block(fs_info, sblock_bad, is_metadata, have_csum,
-				  csum, generation, sctx->csum_size);
-	if (ret) {
-		spin_lock(&sctx->stat_lock);
-		sctx->stat.read_errors++;
-		sctx->stat.uncorrectable_errors++;
-		spin_unlock(&sctx->stat_lock);
-		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_READ_ERRS);
-		goto out;
-	}
+	scrub_recheck_block(fs_info, sblock_bad, is_metadata, have_csum,
+			    csum, generation, sctx->csum_size);
 
 	if (!sblock_bad->header_error && !sblock_bad->checksum_error &&
 	    sblock_bad->no_io_error_seen) {
@@ -843,10 +835,11 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 		sblock_other = sblocks_for_recheck + mirror_index;
 
 		/* build and submit the bios, check checksums */
-		ret = scrub_recheck_block(fs_info, sblock_other, is_metadata,
-					  have_csum, csum, generation,
-					  sctx->csum_size);
-		if (!ret && !sblock_other->header_error &&
+		scrub_recheck_block(fs_info, sblock_other, is_metadata,
+				    have_csum, csum, generation,
+				    sctx->csum_size);
+
+		if (!sblock_other->header_error &&
 		    !sblock_other->checksum_error &&
 		    sblock_other->no_io_error_seen) {
 			int force_write = is_metadata || have_csum;
@@ -931,10 +924,10 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 			 * is verified, but most likely the data comes out
 			 * of the page cache.
 			 */
-			ret = scrub_recheck_block(fs_info, sblock_bad,
-						  is_metadata, have_csum, csum,
-						  generation, sctx->csum_size);
-			if (!ret && !sblock_bad->header_error &&
+			scrub_recheck_block(fs_info, sblock_bad,
+					    is_metadata, have_csum, csum,
+					    generation, sctx->csum_size);
+			if (!sblock_bad->header_error &&
 			    !sblock_bad->checksum_error &&
 			    sblock_bad->no_io_error_seen)
 				goto corrected_error;
@@ -1061,10 +1054,10 @@ leave_nomem:
  * to take those pages that are not errored from all the mirrors so that
  * the pages that are errored in the just handled mirror can be repaired.
  */
-static int scrub_recheck_block(struct btrfs_fs_info *fs_info,
-			       struct scrub_block *sblock, int is_metadata,
-			       int have_csum, u8 *csum, u64 generation,
-			       u16 csum_size)
+static void scrub_recheck_block(struct btrfs_fs_info *fs_info,
+				struct scrub_block *sblock, int is_metadata,
+				int have_csum, u8 *csum, u64 generation,
+				u16 csum_size)
 {
 	int page_num;
 
@@ -1074,7 +1067,6 @@ static int scrub_recheck_block(struct btrfs_fs_info *fs_info,
 
 	for (page_num = 0; page_num < sblock->page_count; page_num++) {
 		struct bio *bio;
-		int ret;
 		struct scrub_page *page = sblock->pagev[page_num];
 		DECLARE_COMPLETION_ONSTACK(complete);
 
@@ -1086,18 +1078,17 @@ static int scrub_recheck_block(struct btrfs_fs_info *fs_info,
 
 		WARN_ON(!page->page);
 		bio = bio_alloc(GFP_NOFS, 1);
-		if (!bio)
-			return -EIO;
+		if (!bio) {
+			page->io_error = 1;
+			sblock->no_io_error_seen = 0;
+			continue;
+		}
 		bio->bi_bdev = page->dev->bdev;
 		bio->bi_sector = page->physical >> 9;
 		bio->bi_end_io = scrub_complete_bio_end_io;
 		bio->bi_private = &complete;
 
-		ret = bio_add_page(bio, page->page, PAGE_SIZE, 0);
-		if (PAGE_SIZE != ret) {
-			bio_put(bio);
-			return -EIO;
-		}
+		bio_add_page(bio, page->page, PAGE_SIZE, 0);
 		btrfsic_submit_bio(READ, bio);
 
 		/* this will also unplug the queue */
@@ -1114,7 +1105,7 @@ static int scrub_recheck_block(struct btrfs_fs_info *fs_info,
 					     have_csum, csum, generation,
 					     csum_size);
 
-	return 0;
+	return;
 }
 
 static void scrub_recheck_block_checksum(struct btrfs_fs_info *fs_info,
-- 
1.8.0

