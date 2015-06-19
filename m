Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15047 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753219AbbFSSyC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Jun 2015 14:54:02 -0400
From: Omar Sandoval <osandov@fb.com>
To: <linux-btrfs@vger.kernel.org>
CC: Miao Xie <miaoxie@huawei.com>, Zhao Lei <zhaolei@cn.fujitsu.com>,
        wangyf <wangyf-fnst@cn.fujitsu.com>,
        Philip <bugzilla@philip-seeger.de>, Omar Sandoval <osandov@fb.com>
Subject: [PATCH v2 1/5] Btrfs: remove misleading handling of missing device scrub
Date: Fri, 19 Jun 2015 11:52:48 -0700
Message-ID: <e04f4ab233652d2fd4e332b8293480f07837b39e.1434739053.git.osandov@fb.com>
In-Reply-To: <cover.1434739053.git.osandov@fb.com>
References: <cover.1434739053.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

scrub_submit() claims that it can handle a bio with a NULL block device,
but this is misleading, as calling bio_add_page() on a bio with a NULL
->bi_bdev would've already crashed. Delete this, as we're about to
properly handle a missing block device.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/scrub.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index ab5811545a98..633fa7b19b7d 100644
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
1.8.5.6

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
