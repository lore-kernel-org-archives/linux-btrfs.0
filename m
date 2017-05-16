Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42874 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752450AbdEPRLh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 13:11:37 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4EF79AD23
        for <linux-btrfs@vger.kernel.org>; Tue, 16 May 2017 17:11:26 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 03/10] btrfs: scrub: simplify cleanup of wr_ctx in scrub_free_ctx
Date: Tue, 16 May 2017 19:10:29 +0200
Message-Id: <d14a9943b4c755604d3021c8af1377723667b6ad.1494954480.git.dsterba@suse.com>
In-Reply-To: <cover.1494954480.git.dsterba@suse.com>
References: <cover.1494954480.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We don't need to take the mutex and zero out wr_cur_bio, as this is
called after the scrub finished.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/scrub.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 43c208dff67f..333f63a59059 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -639,11 +639,6 @@ static noinline_for_stack void scrub_free_ctx(struct scrub_ctx *sctx)
 	if (!sctx)
 		return;
 
-	mutex_lock(&sctx->wr_ctx.wr_lock);
-	kfree(sctx->wr_ctx.wr_curr_bio);
-	sctx->wr_ctx.wr_curr_bio = NULL;
-	mutex_unlock(&sctx->wr_ctx.wr_lock);
-
 	/* this can happen when scrub is cancelled */
 	if (sctx->curr != -1) {
 		struct scrub_bio *sbio = sctx->bios[sctx->curr];
@@ -663,6 +658,7 @@ static noinline_for_stack void scrub_free_ctx(struct scrub_ctx *sctx)
 		kfree(sbio);
 	}
 
+	kfree(sctx->wr_ctx.wr_curr_bio);
 	scrub_free_csums(sctx);
 	kfree(sctx);
 }
-- 
2.12.0

