Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42882 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752592AbdEPRLj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 13:11:39 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 317DFAB5F
        for <linux-btrfs@vger.kernel.org>; Tue, 16 May 2017 17:11:32 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 05/10] btrfs: scrub: remove pages_per_wr_bio from scrub context
Date: Tue, 16 May 2017 19:10:35 +0200
Message-Id: <c96d636b05a4a3cd5f1be70df630594f021d664e.1494954480.git.dsterba@suse.com>
In-Reply-To: <cover.1494954480.git.dsterba@suse.com>
References: <cover.1494954480.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The only purpose seems to store SCRUB_PAGES_PER_WR_BIO, we can use the
constant directly.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/scrub.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index f0c7ec38e33c..2c1d344c8edd 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -182,7 +182,6 @@ struct scrub_ctx {
 
 	struct scrub_bio        *wr_curr_bio;
 	struct mutex            wr_lock;
-	int                     pages_per_wr_bio; /* <= SCRUB_PAGES_PER_WR_BIO */
 	atomic_t                flush_all_writes;
 	struct btrfs_device     *wr_tgtdev;
 
@@ -718,7 +717,6 @@ struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev, int is_dev_replace)
 	sctx->wr_curr_bio = NULL;
 	if (is_dev_replace) {
 		WARN_ON(!dev->bdev);
-		sctx->pages_per_wr_bio = SCRUB_PAGES_PER_WR_BIO;
 		sctx->wr_tgtdev = dev;
 		atomic_set(&sctx->flush_all_writes, 0);
 	}
@@ -1918,7 +1916,7 @@ static int scrub_add_page_to_wr_bio(struct scrub_ctx *sctx,
 		bio = sbio->bio;
 		if (!bio) {
 			bio = btrfs_io_bio_alloc(GFP_KERNEL,
-					sctx->pages_per_wr_bio);
+					SCRUB_PAGES_PER_WR_BIO);
 			if (!bio) {
 				mutex_unlock(&sctx->wr_lock);
 				return -ENOMEM;
@@ -1955,7 +1953,7 @@ static int scrub_add_page_to_wr_bio(struct scrub_ctx *sctx,
 	sbio->pagev[sbio->page_count] = spage;
 	scrub_page_get(spage);
 	sbio->page_count++;
-	if (sbio->page_count == sctx->pages_per_wr_bio)
+	if (sbio->page_count == SCRUB_PAGES_PER_WR_BIO)
 		scrub_wr_submit(sctx);
 	mutex_unlock(&sctx->wr_lock);
 
-- 
2.12.0

