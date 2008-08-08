From: David Woodhouse <dwmw2@infradead.org>
Subject: block discard.
Date: Fri, 08 Aug 2008 14:43:18 +0100
Message-ID: <1218202998.12232.161.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Playing with the trim/punch/discard support, I tried the patch below. It
see it getting invoked at times, but when I create a large file and then
delete it, I don't see it getting invoked _enough_. And when I grep the
block device for the contents of the file, they're still there.

I have a suspicion my added code is only getting invoked for
metadata/tree extents, not the actual data extents. What'd I miss?

diff --git a/extent-tree.c b/extent-tree.c
index fff219e..e6908ad 100644
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
@@ -1743,6 +1744,22 @@ static int __free_extent(struct btrfs_trans_handle *trans, struct btrfs_root
 		ret = update_block_group(trans, root, bytenr, num_bytes, 0,
 					 mark_free);
 		BUG_ON(ret);
+
+
+		u64 map_length = num_bytes;
+		struct btrfs_multi_bio *multi = NULL;
+		ret = btrfs_map_block(&root->fs_info->mapping_tree, READ,
+				      bytenr, &map_length, &multi, 0);
+		if (!ret) {
+			int i;
+			for (i=0; i< multi->num_stripes; i++) {
+				blkdev_issue_discard(multi->stripes[i].dev->bdev,
+						     multi->stripes[i].physical >> 9,
+						     min(map_length, num_bytes) >> 9,
+						     NULL);
+			}
+			kfree(multi);
+		}
 	}
 	btrfs_free_path(path);
 	finish_current_insert(trans, extent_root);

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



