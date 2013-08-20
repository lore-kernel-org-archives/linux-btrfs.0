Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:50366 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab3HTLUb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Aug 2013 07:20:31 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chris Mason <chris.mason@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 11/12] Btrfs: Do not truncate sector_t on 32-bit with CONFIG_LBDAF=y
Date: Tue, 20 Aug 2013 13:20:17 +0200
Message-Id: <1376997618-13573-12-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1376997618-13573-1-git-send-email-geert@linux-m68k.org>
References: <1376997618-13573-1-git-send-email-geert@linux-m68k.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

sector_t may be either "u64" (always 64 bit) or "unsigned long" (32 or 64
bit).  Casting it to "unsigned long" will truncate it on 32-bit platforms
where CONFIG_LBDAF=y.

Cast to "unsigned long long" and format using "ll" instead.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 fs/btrfs/check-integrity.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 2fe6f31..01f9cc3 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -2949,9 +2949,10 @@ int btrfsic_submit_bh(int rw, struct buffer_head *bh)
 		if (dev_state->state->print_mask &
 		    BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH)
 			printk(KERN_INFO
-			       "submit_bh(rw=0x%x, blocknr=%lu (bytenr %llu),"
+			       "submit_bh(rw=0x%x, blocknr=%llu (bytenr %llu),"
 			       " size=%lu, data=%p, bdev=%p)\n",
-			       rw, (unsigned long)bh->b_blocknr, dev_bytenr,
+			       rw, (unsigned long long)bh->b_blocknr,
+			       dev_bytenr,
 			       (unsigned long)bh->b_size, bh->b_data,
 			       bh->b_bdev);
 		btrfsic_process_written_block(dev_state, dev_bytenr,
@@ -3018,9 +3019,10 @@ void btrfsic_submit_bio(int rw, struct bio *bio)
 		    BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH)
 			printk(KERN_INFO
 			       "submit_bio(rw=0x%x, bi_vcnt=%u,"
-			       " bi_sector=%lu (bytenr %llu), bi_bdev=%p)\n",
-			       rw, bio->bi_vcnt, (unsigned long)bio->bi_sector,
-			       dev_bytenr, bio->bi_bdev);
+			       " bi_sector=%llu (bytenr %llu), bi_bdev=%p)\n",
+			       rw, bio->bi_vcnt,
+			       (unsigned long long)bio->bi_sector, dev_bytenr,
+			       bio->bi_bdev);
 
 		mapped_datav = kmalloc(sizeof(*mapped_datav) * bio->bi_vcnt,
 				       GFP_NOFS);
-- 
1.7.9.5

