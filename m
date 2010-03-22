From: jim owens <owens6336@gmail.com>
Subject: [PATCH V3 05/18] Btrfs: btrfs_discard_extent must use WRITE with
 btrfs_map_block.
Date: Sun, 21 Mar 2010 23:22:38 -0400
Message-ID: <4BA6E27E.3030508@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


WRITE is needed on btrfs_map_block() to fetch all raid stripes,
READ only returns one device and we want to discard all copies.

Signed-off-by: jim owens <owens6336@gmail.com>
---
 fs/btrfs/extent-tree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f01e41a..53ad905 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1602,7 +1602,7 @@ static int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
 		return 0;
 
 	/* Tell the block device(s) that the sectors can be discarded */
-	ret = btrfs_map_block(&root->fs_info->mapping_tree, READ,
+	ret = btrfs_map_block(&root->fs_info->mapping_tree, WRITE,
 			      bytenr, &map_length, &multi, 0);
 	if (!ret) {
 		struct btrfs_bio_stripe *stripe = multi->stripes;
-- 
1.6.3.3
