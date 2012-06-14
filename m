Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.136]:55370 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116Ab2FNOme (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jun 2012 10:42:34 -0400
Received: from pizpot.store ([192.168.43.236])
	by jorabe.store (jorabe xp1) (RZmta 29.13 OK)
	with ESMTP id X0788bo5EARWiO for <linux-btrfs@vger.kernel.org>;
	Thu, 14 Jun 2012 16:42:31 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: don't count I/O statistic read errors for missing devices
Date: Thu, 14 Jun 2012 16:42:31 +0200
Message-Id: <1339684951-11688-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It is normal behaviour of the low level btrfs function btrfs_map_bio()
to complete a bio with -EIO if the device is missing, instead of just
preventing the bio creation in an earlier step.
This used to cause I/O statistic read error increments and annoying
printk_ratelimited messages. This commit fixes the issue.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
Reported-by: Carey Underwood <cwillu@cwillu.com>
---
 fs/btrfs/volumes.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 7782020..19b51ad 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4045,16 +4045,18 @@ static void btrfs_end_bio(struct bio *bio, int err)
 
 			BUG_ON(stripe_index >= bbio->num_stripes);
 			dev = bbio->stripes[stripe_index].dev;
-			if (bio->bi_rw & WRITE)
-				btrfs_dev_stat_inc(dev,
-						   BTRFS_DEV_STAT_WRITE_ERRS);
-			else
-				btrfs_dev_stat_inc(dev,
-						   BTRFS_DEV_STAT_READ_ERRS);
-			if ((bio->bi_rw & WRITE_FLUSH) == WRITE_FLUSH)
-				btrfs_dev_stat_inc(dev,
-						   BTRFS_DEV_STAT_FLUSH_ERRS);
-			btrfs_dev_stat_print_on_error(dev);
+			if (dev->bdev) {
+				if (bio->bi_rw & WRITE)
+					btrfs_dev_stat_inc(dev,
+						BTRFS_DEV_STAT_WRITE_ERRS);
+				else
+					btrfs_dev_stat_inc(dev,
+						BTRFS_DEV_STAT_READ_ERRS);
+				if ((bio->bi_rw & WRITE_FLUSH) == WRITE_FLUSH)
+					btrfs_dev_stat_inc(dev,
+						BTRFS_DEV_STAT_FLUSH_ERRS);
+				btrfs_dev_stat_print_on_error(dev);
+			}
 		}
 	}
 
-- 
1.7.10.4

