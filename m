Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:34412 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbbEKH6d (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 03:58:33 -0400
Received: by pdbqa5 with SMTP id qa5so138289455pdb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2015 00:58:33 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: Miao Xie <miaoxie@huawei.com>, Philip <bugzilla@philip-seeger.de>,
        Omar Sandoval <osandov@osandov.com>
Subject: [PATCH 1/4] Btrfs: remove misleading handling of missing device scrub
Date: Mon, 11 May 2015 00:58:12 -0700
Message-Id: <df4cc598a40b944f9533d92bd4d6805fd1d10b59.1431330020.git.osandov@osandov.com>
In-Reply-To: <cover.1431330020.git.osandov@osandov.com>
References: <cover.1431330020.git.osandov@osandov.com>
In-Reply-To: <cover.1431330020.git.osandov@osandov.com>
References: <cover.1431330020.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

scrub_submit() claims that it can handle a bio with a NULL block device,
but this is misleading, as calling bio_add_page() on a bio with a NULL
->bi_bdev would've already crashed. Delete this, as we're about to
properly handle a missing block device.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 fs/btrfs/scrub.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index ab58115..633fa7b 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2087,21 +2087,7 @@ static void scrub_submit(struct scrub_ctx *sctx)
 	sbio = sctx->bios[sctx->curr];
 	sctx->curr = -1;
 	scrub_pending_bio_inc(sctx);
-
-	if (!sbio->bio->bi_bdev) {
-		/*
-		 * this case should not happen. If btrfs_map_block() is
-		 * wrong, it could happen for dev-replace operations on
-		 * missing devices when no mirrors are available, but in
-		 * this case it should already fail the mount.
-		 * This case is handled correctly (but _very_ slowly).
-		 */
-		printk_ratelimited(KERN_WARNING
-			"BTRFS: scrub_submit(bio bdev == NULL) is unexpected!\n");
-		bio_endio(sbio->bio, -EIO);
-	} else {
-		btrfsic_submit_bio(READ, sbio->bio);
-	}
+	btrfsic_submit_bio(READ, sbio->bio);
 }
 
 static int scrub_add_page_to_rd_bio(struct scrub_ctx *sctx,
-- 
2.4.0

