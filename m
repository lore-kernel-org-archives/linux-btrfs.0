From: jim owens <jowens@hp.com>
Subject: Btrfs: btrfs_discard_extent must use WRITE with btrfs_map_block.
Date: Thu, 17 Dec 2009 19:48:46 -0500
Message-ID: <4B2AD16E.70608@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

WRITE is needed on btrfs_map_block() to fetch all raid stripes,
READ only returns one device and we want to discard all copies.

Signed-off-by: jim owens <jowens@hp.com>
---
 fs/btrfs/extent-tree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 86bc625..adc59fa 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1585,7 +1585,7 @@ static int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
 		return 0;
 
 	/* Tell the block device(s) that the sectors can be discarded */
-	ret = btrfs_map_block(&root->fs_info->mapping_tree, READ,
+	ret = btrfs_map_block(&root->fs_info->mapping_tree, WRITE,
 			      bytenr, &map_length, &multi, 0);
 	if (!ret) {
 		struct btrfs_bio_stripe *stripe = multi->stripes;
-- 
1.5.6.3
