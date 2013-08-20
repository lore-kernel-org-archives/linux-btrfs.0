Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:32816 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab3HTLUb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Aug 2013 07:20:31 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chris Mason <chris.mason@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 12/12] Btrfs: Use %z to format size_t
Date: Tue, 20 Aug 2013 13:20:18 +0200
Message-Id: <1376997618-13573-13-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1376997618-13573-1-git-send-email-geert@linux-m68k.org>
References: <1376997618-13573-1-git-send-email-geert@linux-m68k.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 fs/btrfs/check-integrity.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 01f9cc3..3754aa6 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -2950,11 +2950,9 @@ int btrfsic_submit_bh(int rw, struct buffer_head *bh)
 		    BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH)
 			printk(KERN_INFO
 			       "submit_bh(rw=0x%x, blocknr=%llu (bytenr %llu),"
-			       " size=%lu, data=%p, bdev=%p)\n",
+			       " size=%zu, data=%p, bdev=%p)\n",
 			       rw, (unsigned long long)bh->b_blocknr,
-			       dev_bytenr,
-			       (unsigned long)bh->b_size, bh->b_data,
-			       bh->b_bdev);
+			       dev_bytenr, bh->b_size, bh->b_data, bh->b_bdev);
 		btrfsic_process_written_block(dev_state, dev_bytenr,
 					      &bh->b_data, 1, NULL,
 					      NULL, bh, rw);
-- 
1.7.9.5

