From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 3/4] Btrfs: Fix another partial discard bug in on RAID
Date: Mon, 13 Jul 2009 15:11:58 +0100
Message-ID: <1247494318.19180.270.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Each call to btrfs_map_block() will only return a single stripe length,
so we need to loop until we've freed as much as we need.

(We should actually move this whole function into volumes.c and let it
do cunning things so that it frees a single contiguous range on each
backing device. I'll do that when I have to unbreak it for RAID5 anyway.)

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 fs/btrfs/extent-tree.c |   25 +++++++++++++++----------
 1 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 1496925..d829ef3 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1421,23 +1421,28 @@ static int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
 	struct btrfs_multi_bio *multi = NULL;
 
 	/* Tell the block device(s) that the sectors can be discarded */
-	ret = btrfs_map_block(&root->fs_info->mapping_tree, WRITE,
-			      bytenr, &map_length, &multi, 0);
-	if (!ret) {
-		struct btrfs_bio_stripe *stripe = multi->stripes;
+	while (num_bytes) {
 		int i;
 
+		ret = btrfs_map_block(&root->fs_info->mapping_tree, WRITE,
+				      bytenr, &map_length, &multi, 0);
+		if (ret)
+			break;
+
+			
 		if (map_length > num_bytes)
 			map_length = num_bytes;
-
-		for (i = 0; i < multi->num_stripes; i++, stripe++) {
-			btrfs_issue_discard(stripe->dev->bdev,
-					    stripe->physical,
+			
+		for (i = 0; i < multi->num_stripes; i++)
+			btrfs_issue_discard(multi->stripes[i].dev->bdev,
+					    multi->stripes[i].physical,
 					    map_length);
-		}
+
 		kfree(multi);
-	}
 
+		num_bytes -= map_length;
+		bytenr += map_length;
+	}
 	return ret;
 #else
 	return 0;
-- 
1.6.2.5

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

