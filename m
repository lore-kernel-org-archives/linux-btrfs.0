Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42878 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752450AbdEPRLa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 13:11:30 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3CE93AB5F
        for <linux-btrfs@vger.kernel.org>; Tue, 16 May 2017 17:11:29 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 04/10] btrfs: scrub: embed scrub_wr_ctx into scrub context
Date: Tue, 16 May 2017 19:10:32 +0200
Message-Id: <7166ca82005acb7369df3a528885da09eca5c6bb.1494954480.git.dsterba@suse.com>
In-Reply-To: <cover.1494954480.git.dsterba@suse.com>
References: <cover.1494954480.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The structure scrub_wr_ctx is not used anywhere just the scrub context,
we can move the members there. The tgtdev is renamed so it's more clear
that it belongs to the "wr" part.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/scrub.c | 103 ++++++++++++++++++++++++++-----------------------------
 1 file changed, 49 insertions(+), 54 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 333f63a59059..f0c7ec38e33c 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -161,14 +161,6 @@ struct scrub_parity {
 	unsigned long		bitmap[0];
 };
 
-struct scrub_wr_ctx {
-	struct scrub_bio *wr_curr_bio;
-	struct btrfs_device *tgtdev;
-	int pages_per_wr_bio; /* <= SCRUB_PAGES_PER_WR_BIO */
-	atomic_t flush_all_writes;
-	struct mutex wr_lock;
-};
-
 struct scrub_ctx {
 	struct scrub_bio	*bios[SCRUB_BIOS_PER_SCTX];
 	struct btrfs_fs_info	*fs_info;
@@ -187,7 +179,12 @@ struct scrub_ctx {
 	u32			nodesize;
 
 	int			is_dev_replace;
-	struct scrub_wr_ctx	wr_ctx;
+
+	struct scrub_bio        *wr_curr_bio;
+	struct mutex            wr_lock;
+	int                     pages_per_wr_bio; /* <= SCRUB_PAGES_PER_WR_BIO */
+	atomic_t                flush_all_writes;
+	struct btrfs_device     *wr_tgtdev;
 
 	/*
 	 * statistics
@@ -658,7 +655,7 @@ static noinline_for_stack void scrub_free_ctx(struct scrub_ctx *sctx)
 		kfree(sbio);
 	}
 
-	kfree(sctx->wr_ctx.wr_curr_bio);
+	kfree(sctx->wr_curr_bio);
 	scrub_free_csums(sctx);
 	kfree(sctx);
 }
@@ -716,14 +713,14 @@ struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev, int is_dev_replace)
 	spin_lock_init(&sctx->stat_lock);
 	init_waitqueue_head(&sctx->list_wait);
 
-	WARN_ON(sctx->wr_ctx.wr_curr_bio != NULL);
-	mutex_init(&sctx->wr_ctx.wr_lock);
-	sctx->wr_ctx.wr_curr_bio = NULL;
+	WARN_ON(sctx->wr_curr_bio != NULL);
+	mutex_init(&sctx->wr_lock);
+	sctx->wr_curr_bio = NULL;
 	if (is_dev_replace) {
 		WARN_ON(!dev->bdev);
-		sctx->wr_ctx.pages_per_wr_bio = SCRUB_PAGES_PER_WR_BIO;
-		sctx->wr_ctx.tgtdev = dev;
-		atomic_set(&sctx->wr_ctx.flush_all_writes, 0);
+		sctx->pages_per_wr_bio = SCRUB_PAGES_PER_WR_BIO;
+		sctx->wr_tgtdev = dev;
+		atomic_set(&sctx->flush_all_writes, 0);
 	}
 
 	return sctx;
@@ -1896,35 +1893,34 @@ static int scrub_write_page_to_dev_replace(struct scrub_block *sblock,
 static int scrub_add_page_to_wr_bio(struct scrub_ctx *sctx,
 				    struct scrub_page *spage)
 {
-	struct scrub_wr_ctx *wr_ctx = &sctx->wr_ctx;
 	struct scrub_bio *sbio;
 	int ret;
 
-	mutex_lock(&wr_ctx->wr_lock);
+	mutex_lock(&sctx->wr_lock);
 again:
-	if (!wr_ctx->wr_curr_bio) {
-		wr_ctx->wr_curr_bio = kzalloc(sizeof(*wr_ctx->wr_curr_bio),
+	if (!sctx->wr_curr_bio) {
+		sctx->wr_curr_bio = kzalloc(sizeof(*sctx->wr_curr_bio),
 					      GFP_KERNEL);
-		if (!wr_ctx->wr_curr_bio) {
-			mutex_unlock(&wr_ctx->wr_lock);
+		if (!sctx->wr_curr_bio) {
+			mutex_unlock(&sctx->wr_lock);
 			return -ENOMEM;
 		}
-		wr_ctx->wr_curr_bio->sctx = sctx;
-		wr_ctx->wr_curr_bio->page_count = 0;
+		sctx->wr_curr_bio->sctx = sctx;
+		sctx->wr_curr_bio->page_count = 0;
 	}
-	sbio = wr_ctx->wr_curr_bio;
+	sbio = sctx->wr_curr_bio;
 	if (sbio->page_count == 0) {
 		struct bio *bio;
 
 		sbio->physical = spage->physical_for_dev_replace;
 		sbio->logical = spage->logical;
-		sbio->dev = wr_ctx->tgtdev;
+		sbio->dev = sctx->wr_tgtdev;
 		bio = sbio->bio;
 		if (!bio) {
 			bio = btrfs_io_bio_alloc(GFP_KERNEL,
-					wr_ctx->pages_per_wr_bio);
+					sctx->pages_per_wr_bio);
 			if (!bio) {
-				mutex_unlock(&wr_ctx->wr_lock);
+				mutex_unlock(&sctx->wr_lock);
 				return -ENOMEM;
 			}
 			sbio->bio = bio;
@@ -1949,7 +1945,7 @@ static int scrub_add_page_to_wr_bio(struct scrub_ctx *sctx,
 		if (sbio->page_count < 1) {
 			bio_put(sbio->bio);
 			sbio->bio = NULL;
-			mutex_unlock(&wr_ctx->wr_lock);
+			mutex_unlock(&sctx->wr_lock);
 			return -EIO;
 		}
 		scrub_wr_submit(sctx);
@@ -1959,23 +1955,22 @@ static int scrub_add_page_to_wr_bio(struct scrub_ctx *sctx,
 	sbio->pagev[sbio->page_count] = spage;
 	scrub_page_get(spage);
 	sbio->page_count++;
-	if (sbio->page_count == wr_ctx->pages_per_wr_bio)
+	if (sbio->page_count == sctx->pages_per_wr_bio)
 		scrub_wr_submit(sctx);
-	mutex_unlock(&wr_ctx->wr_lock);
+	mutex_unlock(&sctx->wr_lock);
 
 	return 0;
 }
 
 static void scrub_wr_submit(struct scrub_ctx *sctx)
 {
-	struct scrub_wr_ctx *wr_ctx = &sctx->wr_ctx;
 	struct scrub_bio *sbio;
 
-	if (!wr_ctx->wr_curr_bio)
+	if (!sctx->wr_curr_bio)
 		return;
 
-	sbio = wr_ctx->wr_curr_bio;
-	wr_ctx->wr_curr_bio = NULL;
+	sbio = sctx->wr_curr_bio;
+	sctx->wr_curr_bio = NULL;
 	WARN_ON(!sbio->bio->bi_bdev);
 	scrub_pending_bio_inc(sctx);
 	/* process all writes in a single worker thread. Then the block layer
@@ -2418,10 +2413,10 @@ static void scrub_missing_raid56_worker(struct btrfs_work *work)
 	scrub_block_put(sblock);
 
 	if (sctx->is_dev_replace &&
-	    atomic_read(&sctx->wr_ctx.flush_all_writes)) {
-		mutex_lock(&sctx->wr_ctx.wr_lock);
+	    atomic_read(&sctx->flush_all_writes)) {
+		mutex_lock(&sctx->wr_lock);
 		scrub_wr_submit(sctx);
-		mutex_unlock(&sctx->wr_ctx.wr_lock);
+		mutex_unlock(&sctx->wr_lock);
 	}
 
 	scrub_pending_bio_dec(sctx);
@@ -2626,10 +2621,10 @@ static void scrub_bio_end_io_worker(struct btrfs_work *work)
 	spin_unlock(&sctx->list_lock);
 
 	if (sctx->is_dev_replace &&
-	    atomic_read(&sctx->wr_ctx.flush_all_writes)) {
-		mutex_lock(&sctx->wr_ctx.wr_lock);
+	    atomic_read(&sctx->flush_all_writes)) {
+		mutex_lock(&sctx->wr_lock);
 		scrub_wr_submit(sctx);
-		mutex_unlock(&sctx->wr_ctx.wr_lock);
+		mutex_unlock(&sctx->wr_lock);
 	}
 
 	scrub_pending_bio_dec(sctx);
@@ -3303,9 +3298,9 @@ static noinline_for_stack int scrub_raid56_parity(struct scrub_ctx *sctx,
 						logic_end - logic_start);
 	scrub_parity_put(sparity);
 	scrub_submit(sctx);
-	mutex_lock(&sctx->wr_ctx.wr_lock);
+	mutex_lock(&sctx->wr_lock);
 	scrub_wr_submit(sctx);
-	mutex_unlock(&sctx->wr_ctx.wr_lock);
+	mutex_unlock(&sctx->wr_lock);
 
 	btrfs_release_path(path);
 	return ret < 0 ? ret : 0;
@@ -3461,14 +3456,14 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 		 */
 		if (atomic_read(&fs_info->scrub_pause_req)) {
 			/* push queued extents */
-			atomic_set(&sctx->wr_ctx.flush_all_writes, 1);
+			atomic_set(&sctx->flush_all_writes, 1);
 			scrub_submit(sctx);
-			mutex_lock(&sctx->wr_ctx.wr_lock);
+			mutex_lock(&sctx->wr_lock);
 			scrub_wr_submit(sctx);
-			mutex_unlock(&sctx->wr_ctx.wr_lock);
+			mutex_unlock(&sctx->wr_lock);
 			wait_event(sctx->list_wait,
 				   atomic_read(&sctx->bios_in_flight) == 0);
-			atomic_set(&sctx->wr_ctx.flush_all_writes, 0);
+			atomic_set(&sctx->flush_all_writes, 0);
 			scrub_blocked_if_needed(fs_info);
 		}
 
@@ -3675,9 +3670,9 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 out:
 	/* push queued extents */
 	scrub_submit(sctx);
-	mutex_lock(&sctx->wr_ctx.wr_lock);
+	mutex_lock(&sctx->wr_lock);
 	scrub_wr_submit(sctx);
-	mutex_unlock(&sctx->wr_ctx.wr_lock);
+	mutex_unlock(&sctx->wr_lock);
 
 	blk_finish_plug(&plug);
 	btrfs_free_path(path);
@@ -3914,11 +3909,11 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 		 * write requests are really completed when bios_in_flight
 		 * changes to 0.
 		 */
-		atomic_set(&sctx->wr_ctx.flush_all_writes, 1);
+		atomic_set(&sctx->flush_all_writes, 1);
 		scrub_submit(sctx);
-		mutex_lock(&sctx->wr_ctx.wr_lock);
+		mutex_lock(&sctx->wr_lock);
 		scrub_wr_submit(sctx);
-		mutex_unlock(&sctx->wr_ctx.wr_lock);
+		mutex_unlock(&sctx->wr_lock);
 
 		wait_event(sctx->list_wait,
 			   atomic_read(&sctx->bios_in_flight) == 0);
@@ -3932,7 +3927,7 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 		 */
 		wait_event(sctx->list_wait,
 			   atomic_read(&sctx->workers_pending) == 0);
-		atomic_set(&sctx->wr_ctx.flush_all_writes, 0);
+		atomic_set(&sctx->flush_all_writes, 0);
 
 		scrub_pause_off(fs_info);
 
@@ -4637,7 +4632,7 @@ static int write_page_nocow(struct scrub_ctx *sctx,
 	struct btrfs_device *dev;
 	int ret;
 
-	dev = sctx->wr_ctx.tgtdev;
+	dev = sctx->wr_tgtdev;
 	if (!dev)
 		return -EIO;
 	if (!dev->bdev) {
-- 
2.12.0

