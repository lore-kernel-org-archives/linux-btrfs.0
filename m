Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:56399 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab3KDXgt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Nov 2013 18:36:49 -0500
Received: by mail-pd0-f174.google.com with SMTP id z10so7403083pdj.33
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Nov 2013 15:36:48 -0800 (PST)
From: Kent Overstreet <kmo@daterainc.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Cc: axboe@kernel.dk, hch@infradead.org, Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 6/9] mtip32xx: handle arbitrary size bios
Date: Mon,  4 Nov 2013 15:36:24 -0800
Message-Id: <1383608187-27368-7-git-send-email-kmo@daterainc.com>
In-Reply-To: <1383608187-27368-1-git-send-email-kmo@daterainc.com>
References: <1383608187-27368-1-git-send-email-kmo@daterainc.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We get a measurable performance increase by handling this in the driver when
we're already looping over the biovec, instead of handling it separately in
generic_make_request() (or bio_add_page() originally)

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
---
 drivers/block/mtip32xx/mtip32xx.c | 46 +++++++++++++--------------------------
 1 file changed, 15 insertions(+), 31 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index d4c669b..c5a7a96 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -2648,24 +2648,6 @@ static void mtip_hw_submit_io(struct driver_data *dd, sector_t sector,
 }
 
 /*
- * Release a command slot.
- *
- * @dd  Pointer to the driver data structure.
- * @tag Slot tag
- *
- * return value
- *      None
- */
-static void mtip_hw_release_scatterlist(struct driver_data *dd, int tag,
-								int unaligned)
-{
-	struct semaphore *sem = unaligned ? &dd->port->cmd_slot_unal :
-							&dd->port->cmd_slot;
-	release_slot(dd->port, tag);
-	up(sem);
-}
-
-/*
  * Obtain a command slot and return its associated scatter list.
  *
  * @dd  Pointer to the driver data structure.
@@ -4016,21 +3998,22 @@ static void mtip_make_request(struct request_queue *queue, struct bio *bio)
 
 	sg = mtip_hw_get_scatterlist(dd, &tag, unaligned);
 	if (likely(sg != NULL)) {
-		if (unlikely((bio)->bi_vcnt > MTIP_MAX_SG)) {
-			dev_warn(&dd->pdev->dev,
-				"Maximum number of SGL entries exceeded\n");
-			bio_io_error(bio);
-			mtip_hw_release_scatterlist(dd, tag, unaligned);
-			return;
-		}
-
 		/* Create the scatter list for this bio. */
 		bio_for_each_segment(bvec, bio, iter) {
-			sg_set_page(&sg[nents],
-					bvec.bv_page,
-					bvec.bv_len,
-					bvec.bv_offset);
-			nents++;
+			if (unlikely(nents == MTIP_MAX_SG)) {
+				struct bio *split = bio_clone(bio, GFP_NOIO);
+
+				split->bi_iter = iter;
+				bio->bi_iter.bi_size -= iter.bi_size;
+				bio_chain(split, bio);
+				generic_make_request(split);
+				break;
+			}
+
+			sg_set_page(&sg[nents++],
+				    bvec.bv_page,
+				    bvec.bv_len,
+				    bvec.bv_offset);
 		}
 
 		/* Issue the read/write. */
@@ -4145,6 +4128,7 @@ skip_create_disk:
 	blk_queue_max_hw_sectors(dd->queue, 0xffff);
 	blk_queue_max_segment_size(dd->queue, 0x400000);
 	blk_queue_io_min(dd->queue, 4096);
+	set_bit(QUEUE_FLAG_LARGEBIOS,	&dd->queue->queue_flags);
 
 	/*
 	 * write back cache is not supported in the device. FUA depends on
-- 
1.8.4.rc3

