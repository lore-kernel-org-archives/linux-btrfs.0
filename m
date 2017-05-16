Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42850 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752159AbdEPRLV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 13:11:21 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3B2B3AB5F
        for <linux-btrfs@vger.kernel.org>; Tue, 16 May 2017 17:11:20 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 01/10] btrfs: scrub: inline helper scrub_setup_wr_ctx
Date: Tue, 16 May 2017 19:10:23 +0200
Message-Id: <ced1e3b678f1dc836b9fa2718f2ea3e5dca1a2bb.1494954480.git.dsterba@suse.com>
In-Reply-To: <cover.1494954480.git.dsterba@suse.com>
References: <cover.1494954480.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The helper scrub_setup_wr_ctx is used only once and fits into
scrub_setup_ctx as it continues intialization, no need to keep it
separate.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/scrub.c | 36 +++++++++---------------------------
 1 file changed, 9 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index c7b45eb2403d..e88edbeb7644 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -289,9 +289,6 @@ static void scrub_remap_extent(struct btrfs_fs_info *fs_info,
 			       u64 *extent_physical,
 			       struct btrfs_device **extent_dev,
 			       int *extent_mirror_num);
-static int scrub_setup_wr_ctx(struct scrub_wr_ctx *wr_ctx,
-			      struct btrfs_device *dev,
-			      int is_dev_replace);
 static void scrub_free_wr_ctx(struct scrub_wr_ctx *wr_ctx);
 static int scrub_add_page_to_wr_bio(struct scrub_ctx *sctx,
 				    struct scrub_page *spage);
@@ -680,7 +677,6 @@ struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev, int is_dev_replace)
 	struct scrub_ctx *sctx;
 	int		i;
 	struct btrfs_fs_info *fs_info = dev->fs_info;
-	int ret;
 
 	sctx = kzalloc(sizeof(*sctx), GFP_KERNEL);
 	if (!sctx)
@@ -722,12 +718,16 @@ struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev, int is_dev_replace)
 	spin_lock_init(&sctx->stat_lock);
 	init_waitqueue_head(&sctx->list_wait);
 
-	ret = scrub_setup_wr_ctx(&sctx->wr_ctx,
-				 fs_info->dev_replace.tgtdev, is_dev_replace);
-	if (ret) {
-		scrub_free_ctx(sctx);
-		return ERR_PTR(ret);
+	WARN_ON(sctx->wr_ctx.wr_curr_bio != NULL);
+	mutex_init(&sctx->wr_ctx.wr_lock);
+	sctx->wr_ctx.wr_curr_bio = NULL;
+	if (is_dev_replace) {
+		WARN_ON(!dev->bdev);
+		sctx->wr_ctx.pages_per_wr_bio = SCRUB_PAGES_PER_WR_BIO;
+		sctx->wr_ctx.tgtdev = dev;
+		atomic_set(&sctx->wr_ctx.flush_all_writes, 0);
 	}
+
 	return sctx;
 
 nomem:
@@ -4337,24 +4337,6 @@ static void scrub_remap_extent(struct btrfs_fs_info *fs_info,
 	btrfs_put_bbio(bbio);
 }
 
-static int scrub_setup_wr_ctx(struct scrub_wr_ctx *wr_ctx,
-			      struct btrfs_device *dev,
-			      int is_dev_replace)
-{
-	WARN_ON(wr_ctx->wr_curr_bio != NULL);
-
-	mutex_init(&wr_ctx->wr_lock);
-	wr_ctx->wr_curr_bio = NULL;
-	if (!is_dev_replace)
-		return 0;
-
-	WARN_ON(!dev->bdev);
-	wr_ctx->pages_per_wr_bio = SCRUB_PAGES_PER_WR_BIO;
-	wr_ctx->tgtdev = dev;
-	atomic_set(&wr_ctx->flush_all_writes, 0);
-	return 0;
-}
-
 static void scrub_free_wr_ctx(struct scrub_wr_ctx *wr_ctx)
 {
 	mutex_lock(&wr_ctx->wr_lock);
-- 
2.12.0

