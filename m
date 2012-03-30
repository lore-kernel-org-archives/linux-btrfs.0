From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH] Btrfs: don't count CRC or header errors twice while scrubbing
Date: Fri, 30 Mar 2012 13:58:31 +0200
Message-ID: <a1550959ef3f5776fcd0b0bf97487f1ef0863ef0.1333107802.git.sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Each CRC or header error was counted twice, this is now fixed.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
The patch is based on cmason/integration as of 3/30/2012.

 fs/btrfs/scrub.c |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index c9a2c1a..196d48f 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1254,12 +1254,6 @@ static int scrub_checksum_data(struct scrub_block *sblock)
 	if (memcmp(csum, on_disk_csum, sdev->csum_size))
 		fail = 1;
 
-	if (fail) {
-		spin_lock(&sdev->stat_lock);
-		++sdev->stat.csum_errors;
-		spin_unlock(&sdev->stat_lock);
-	}
-
 	return fail;
 }
 
@@ -1332,15 +1326,6 @@ static int scrub_checksum_tree_block(struct scrub_block *sblock)
 	if (memcmp(calculated_csum, on_disk_csum, sdev->csum_size))
 		++crc_fail;
 
-	if (crc_fail || fail) {
-		spin_lock(&sdev->stat_lock);
-		if (crc_fail)
-			++sdev->stat.csum_errors;
-		if (fail)
-			++sdev->stat.verify_errors;
-		spin_unlock(&sdev->stat_lock);
-	}
-
 	return fail || crc_fail;
 }
 
-- 
1.7.3.4

