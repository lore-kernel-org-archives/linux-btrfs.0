Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42858 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752286AbdEPRLY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 13:11:24 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4CF3AAD23
        for <linux-btrfs@vger.kernel.org>; Tue, 16 May 2017 17:11:23 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 02/10] btrfs: scrub: inline helper scrub_free_wr_ctx
Date: Tue, 16 May 2017 19:10:26 +0200
Message-Id: <2687350e220639faea9ecee8ea1322b4a59c1b7e.1494954480.git.dsterba@suse.com>
In-Reply-To: <cover.1494954480.git.dsterba@suse.com>
References: <cover.1494954480.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The helper scrub_free_wr_ctx is used only once and fits into
scrub_free_ctx as it continues sctx shutdown, no need to keep it
separate.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/scrub.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index e88edbeb7644..43c208dff67f 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -289,7 +289,6 @@ static void scrub_remap_extent(struct btrfs_fs_info *fs_info,
 			       u64 *extent_physical,
 			       struct btrfs_device **extent_dev,
 			       int *extent_mirror_num);
-static void scrub_free_wr_ctx(struct scrub_wr_ctx *wr_ctx);
 static int scrub_add_page_to_wr_bio(struct scrub_ctx *sctx,
 				    struct scrub_page *spage);
 static void scrub_wr_submit(struct scrub_ctx *sctx);
@@ -640,7 +639,10 @@ static noinline_for_stack void scrub_free_ctx(struct scrub_ctx *sctx)
 	if (!sctx)
 		return;
 
-	scrub_free_wr_ctx(&sctx->wr_ctx);
+	mutex_lock(&sctx->wr_ctx.wr_lock);
+	kfree(sctx->wr_ctx.wr_curr_bio);
+	sctx->wr_ctx.wr_curr_bio = NULL;
+	mutex_unlock(&sctx->wr_ctx.wr_lock);
 
 	/* this can happen when scrub is cancelled */
 	if (sctx->curr != -1) {
@@ -4337,14 +4339,6 @@ static void scrub_remap_extent(struct btrfs_fs_info *fs_info,
 	btrfs_put_bbio(bbio);
 }
 
-static void scrub_free_wr_ctx(struct scrub_wr_ctx *wr_ctx)
-{
-	mutex_lock(&wr_ctx->wr_lock);
-	kfree(wr_ctx->wr_curr_bio);
-	wr_ctx->wr_curr_bio = NULL;
-	mutex_unlock(&wr_ctx->wr_lock);
-}
-
 static int copy_nocow_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
 			    int mirror_num, u64 physical_for_dev_replace)
 {
-- 
2.12.0

