From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] Discard sector data in __free_extent()
Date: Wed, 13 Aug 2008 16:08:51 +0100
Message-ID: <1218640131.2977.303.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---

Jens has just said he'll take the block parts of this; it's harmless in
older kernels without BIO_RW_DISCARD defined.

 extent-tree.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/extent-tree.c b/extent-tree.c
index fff219e..e63b3b4 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -18,6 +18,7 @@
 #include <linux/sched.h>
 #include <linux/pagemap.h>
 #include <linux/writeback.h>
+#include <linux/blkdev.h>
 #include "hash.h"
 #include "crc32c.h"
 #include "ctree.h"
@@ -1716,6 +1717,10 @@ static int __free_extent(struct btrfs_trans_handle *trans, struct btrfs_root
 	if (refs == 0) {
 		u64 super_used;
 		u64 root_used;
+#ifdef BIO_RW_DISCARD
+		u64 map_length = num_bytes;
+		struct btrfs_multi_bio *multi = NULL;
+#endif
 
 		if (pin) {
 			ret = pin_down_bytes(root, bytenr, num_bytes, 0);
@@ -1743,6 +1748,26 @@ static int __free_extent(struct btrfs_trans_handle *trans, struct btrfs_root
 		ret = update_block_group(trans, root, bytenr, num_bytes, 0,
 					 mark_free);
 		BUG_ON(ret);
+
+#ifdef BIO_RW_DISCARD
+		/* Tell the block device(s) that the sectors can be discarded */
+		ret = btrfs_map_block(&root->fs_info->mapping_tree, READ,
+				      bytenr, &map_length, &multi, 0);
+		if (!ret) {
+			struct btrfs_bio_stripe *stripe = multi->stripes;
+			int i;
+
+			if (map_length > num_bytes)
+				map_length = num_bytes;
+
+			for (i = 0; i < multi->num_stripes; i++, stripe++) {
+				blkdev_issue_discard(stripe->dev->bdev,
+						     stripe->physical >> 9,
+						     map_length >> 9);
+			}
+			kfree(multi);
+		}
+#endif
 	}
 	btrfs_free_path(path);
 	finish_current_insert(trans, extent_root);
-- 
1.5.5.1


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



