From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 2/4] Btrfs: Fix partial discard on RAID1
Date: Mon, 13 Jul 2009 15:11:49 +0100
Message-ID: <1247494309.19180.269.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs_discard_extent() we were only discarding half of a RAID1 or
RAID10 extent.

We should be telling btrfs_map_block() that we want to write, so it
tells us about _all_ mirrors. If we tell it we're going to read, it'll
only tell us about a single mirror at a time.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 fs/btrfs/extent-tree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a5aca39..1496925 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1421,7 +1421,7 @@ static int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
 	struct btrfs_multi_bio *multi = NULL;
 
 	/* Tell the block device(s) that the sectors can be discarded */
-	ret = btrfs_map_block(&root->fs_info->mapping_tree, READ,
+	ret = btrfs_map_block(&root->fs_info->mapping_tree, WRITE,
 			      bytenr, &map_length, &multi, 0);
 	if (!ret) {
 		struct btrfs_bio_stripe *stripe = multi->stripes;
-- 
1.6.2.5

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

