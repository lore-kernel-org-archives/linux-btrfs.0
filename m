Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.137]:53668 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744Ab2KFQit (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Nov 2012 11:38:49 -0500
Received: from pizpot.store ([192.168.43.236])
	by jorabe.store (jorabe xp2) (RZmta 31.1 OK)
	with ESMTP id g02b97oA6CtSYe for <linux-btrfs@vger.kernel.org>;
	Tue, 6 Nov 2012 17:38:45 +0100 (CET)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 23/26] Btrfs: optionally avoid reads from device replace source drive
Date: Tue,  6 Nov 2012 17:38:41 +0100
Message-Id: <a613aade1db71edf1b63c6e16213448074f3d3cd.1352217244.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <cover.1352214751.git.sbehrens@giantdisaster.de>

It is desirable to be able to configure the device replace
procedure to avoid reading the source drive (the one to be
copied) whenever possible. This is useful when the number of
read errors on this disk is high, because it would delay the
copy procedure alot. Therefore there is an option to avoid
reading from the source disk unless the repair procedure
really needs to access it. The regular read req asks for
mapping the block with mirror_num == 0, in this case the
source disk is avoided whenever possible. The repair code
selects the mirror_num explicitly (mirror_num != 0), this
case is not changed by this commit.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/volumes.c | 46 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 164f9b1..edd5573 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4012,16 +4012,37 @@ int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
 	return ret;
 }
 
-static int find_live_mirror(struct map_lookup *map, int first, int num,
-			    int optimal)
+static int find_live_mirror(struct btrfs_fs_info *fs_info,
+			    struct map_lookup *map, int first, int num,
+			    int optimal, int dev_replace_is_ongoing)
 {
 	int i;
-	if (map->stripes[optimal].dev->bdev)
-		return optimal;
-	for (i = first; i < first + num; i++) {
-		if (map->stripes[i].dev->bdev)
-			return i;
+	int tolerance;
+	struct btrfs_device *srcdev;
+
+	if (dev_replace_is_ongoing &&
+	    fs_info->dev_replace.cont_reading_from_srcdev_mode ==
+	     BTRFS_DEV_REPLACE_ITEM_CONT_READING_FROM_SRCDEV_MODE_AVOID)
+		srcdev = fs_info->dev_replace.srcdev;
+	else
+		srcdev = NULL;
+
+	/*
+	 * try to avoid the drive that is the source drive for a
+	 * dev-replace procedure, only choose it if no other non-missing
+	 * mirror is available
+	 */
+	for (tolerance = 0; tolerance < 2; tolerance++) {
+		if (map->stripes[optimal].dev->bdev &&
+		    (tolerance || map->stripes[optimal].dev != srcdev))
+			return optimal;
+		for (i = first; i < first + num; i++) {
+			if (map->stripes[i].dev->bdev &&
+			    (tolerance || map->stripes[i].dev != srcdev))
+				return i;
+		}
 	}
+
 	/* we couldn't find one that doesn't fail.  Just return something
 	 * and the io error handling code will clean up eventually
 	 */
@@ -4121,9 +4142,10 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 		else if (mirror_num)
 			stripe_index = mirror_num - 1;
 		else {
-			stripe_index = find_live_mirror(map, 0,
+			stripe_index = find_live_mirror(fs_info, map, 0,
 					    map->num_stripes,
-					    current->pid % map->num_stripes);
+					    current->pid % map->num_stripes,
+					    dev_replace_is_ongoing);
 			mirror_num = stripe_index + 1;
 		}
 
@@ -4152,9 +4174,11 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 			stripe_index += mirror_num - 1;
 		else {
 			int old_stripe_index = stripe_index;
-			stripe_index = find_live_mirror(map, stripe_index,
+			stripe_index = find_live_mirror(fs_info, map,
+					      stripe_index,
 					      map->sub_stripes, stripe_index +
-					      current->pid % map->sub_stripes);
+					      current->pid % map->sub_stripes,
+					      dev_replace_is_ongoing);
 			mirror_num = stripe_index - old_stripe_index + 1;
 		}
 	} else {
-- 
1.8.0

