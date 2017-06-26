Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39794 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751427AbdFZNZI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Jun 2017 09:25:08 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: scrub: fix target device intialization while setting up scrub context
Date: Mon, 26 Jun 2017 15:23:50 +0200
Message-Id: <20170626132350.26286-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The commit "btrfs: scrub: inline helper scrub_setup_wr_ctx" inlined a
helper but wrongly sets up the target device. Incidentally there's a
local variable with the same name as a parameter in the previous
function, so this got caught during runtime as crash in test btrfs/027.

Reported-by: Chris Mason <clm@fb.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/scrub.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 58a249cd5adc..738e784ba20d 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -714,9 +714,9 @@ struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev, int is_dev_replace)
 	mutex_init(&sctx->wr_lock);
 	sctx->wr_curr_bio = NULL;
 	if (is_dev_replace) {
-		WARN_ON(!dev->bdev);
+		WARN_ON(!fs_info->dev_replace.tgtdev);
 		sctx->pages_per_wr_bio = SCRUB_PAGES_PER_WR_BIO;
-		sctx->wr_tgtdev = dev;
+		sctx->wr_tgtdev = fs_info->dev_replace.tgtdev;
 		atomic_set(&sctx->flush_all_writes, 0);
 	}
 
-- 
2.13.0

