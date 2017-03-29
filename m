Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42856 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932348AbdC2RzP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Mar 2017 13:55:15 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH v2] Btrfs: enable repair during read for raid56 profile
Date: Wed, 29 Mar 2017 10:53:58 -0700
Message-Id: <1490810038-18488-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1490382815-25248-1-git-send-email-bo.li.liu@oracle.com>
References: <1490382815-25248-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now that scrub can fix data errors with the help of parity for raid56
profile, repair during read is able to as well.

Although the mirror num in raid56 scenario has different meanings, i.e.
0 or 1: read data directly
> 1:    do recover with parity,
it could be fit into how we repair bad block during read.

The trick is to use BTRFS_MAP_READ instead of BTRFS_MAP_WRITE to get the
device and position on it.

Cc: David Sterba <dsterba@suse.cz>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: Fix typo and add comments for why BTRFS_MAP_READ is used.

 fs/btrfs/extent_io.c | 40 +++++++++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d39a11c..7241f94 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2009,10 +2009,6 @@ int repair_io_failure(struct btrfs_inode *inode, u64 start, u64 length,
 	ASSERT(!(fs_info->sb->s_flags & MS_RDONLY));
 	BUG_ON(!mirror_num);
 
-	/* we can't repair anything in raid56 yet */
-	if (btrfs_is_parity_mirror(map_tree, logical, length, mirror_num))
-		return 0;
-
 	bio = btrfs_io_bio_alloc(GFP_NOFS, 1);
 	if (!bio)
 		return -EIO;
@@ -2025,17 +2021,35 @@ int repair_io_failure(struct btrfs_inode *inode, u64 start, u64 length,
 	 * read repair operation.
 	 */
 	btrfs_bio_counter_inc_blocked(fs_info);
-	ret = btrfs_map_block(fs_info, BTRFS_MAP_WRITE, logical,
-			      &map_length, &bbio, mirror_num);
-	if (ret) {
-		btrfs_bio_counter_dec(fs_info);
-		bio_put(bio);
-		return -EIO;
+	if (btrfs_is_parity_mirror(map_tree, logical, length, mirror_num)) {
+		/*
+		 * Note that we don't use BTRFS_MAP_WRITE because it's supposed
+		 * to update all raid stripes, but here we just want to correct
+		 * bad stripe, thus BTRFS_MAP_READ is abused to only get the bad
+		 * stripe's dev and sector.
+		 */
+		ret = btrfs_map_block(fs_info, BTRFS_MAP_READ, logical,
+				      &map_length, &bbio, 0);
+		if (ret) {
+			btrfs_bio_counter_dec(fs_info);
+			bio_put(bio);
+			return -EIO;
+		}
+		ASSERT(bbio->mirror_num == 1);
+	} else {
+		ret = btrfs_map_block(fs_info, BTRFS_MAP_WRITE, logical,
+				      &map_length, &bbio, mirror_num);
+		if (ret) {
+			btrfs_bio_counter_dec(fs_info);
+			bio_put(bio);
+			return -EIO;
+		}
+		BUG_ON(mirror_num != bbio->mirror_num);
 	}
-	BUG_ON(mirror_num != bbio->mirror_num);
-	sector = bbio->stripes[mirror_num-1].physical >> 9;
+
+	sector = bbio->stripes[bbio->mirror_num - 1].physical >> 9;
 	bio->bi_iter.bi_sector = sector;
-	dev = bbio->stripes[mirror_num-1].dev;
+	dev = bbio->stripes[bbio->mirror_num - 1].dev;
 	btrfs_put_bbio(bbio);
 	if (!dev || !dev->bdev || !dev->writeable) {
 		btrfs_bio_counter_dec(fs_info);
-- 
2.5.5

