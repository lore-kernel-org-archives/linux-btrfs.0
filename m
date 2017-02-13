Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41838 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752369AbdBMJe7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 04:34:59 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DDCCCABD9
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 09:34:57 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 22/29] btrfs: remove unused parameters from scrub_setup_wr_ctx
Date: Mon, 13 Feb 2017 10:34:29 +0100
Message-Id: <035062e9f1048e95e2d605e070d5c08ee18e1895.1486977712.git.dsterba@suse.com>
In-Reply-To: <cover.1486977711.git.dsterba@suse.com>
References: <cover.1486977711.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Never used.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/scrub.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 9a94670536a6..f7dffacf61fa 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -282,9 +282,7 @@ static void scrub_remap_extent(struct btrfs_fs_info *fs_info,
 			       u64 *extent_physical,
 			       struct btrfs_device **extent_dev,
 			       int *extent_mirror_num);
-static int scrub_setup_wr_ctx(struct scrub_ctx *sctx,
-			      struct scrub_wr_ctx *wr_ctx,
-			      struct btrfs_fs_info *fs_info,
+static int scrub_setup_wr_ctx(struct scrub_wr_ctx *wr_ctx,
 			      struct btrfs_device *dev,
 			      int is_dev_replace);
 static void scrub_free_wr_ctx(struct scrub_wr_ctx *wr_ctx);
@@ -501,7 +499,7 @@ struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev, int is_dev_replace)
 	spin_lock_init(&sctx->stat_lock);
 	init_waitqueue_head(&sctx->list_wait);
 
-	ret = scrub_setup_wr_ctx(sctx, &sctx->wr_ctx, fs_info,
+	ret = scrub_setup_wr_ctx(&sctx->wr_ctx,
 				 fs_info->dev_replace.tgtdev, is_dev_replace);
 	if (ret) {
 		scrub_free_ctx(sctx);
@@ -4084,9 +4082,7 @@ static void scrub_remap_extent(struct btrfs_fs_info *fs_info,
 	btrfs_put_bbio(bbio);
 }
 
-static int scrub_setup_wr_ctx(struct scrub_ctx *sctx,
-			      struct scrub_wr_ctx *wr_ctx,
-			      struct btrfs_fs_info *fs_info,
+static int scrub_setup_wr_ctx(struct scrub_wr_ctx *wr_ctx,
 			      struct btrfs_device *dev,
 			      int is_dev_replace)
 {
-- 
2.10.1

