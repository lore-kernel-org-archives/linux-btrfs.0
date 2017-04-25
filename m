Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8789 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1167147AbdDYIBc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Apr 2017 04:01:32 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: Fix memory leak when 0 sized block group item is found
Date: Tue, 25 Apr 2017 16:01:17 +0800
Message-ID: <20170425080117.18694-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When a 0 sized block group item is found, set_extent_bits() will not
really set any bits.
While set_state_private() still inserts allocated block group cache into
block group extent_io_tree.

So at close_ctree() time, we won't free the private block group cache
stored since we can't find any bit set for the 0 sized block group.

To fix it, at btrfs_read_block_groups() we skip any 0 sized block group,
so such leak won't happen.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 extent-tree.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/extent-tree.c b/extent-tree.c
index 3e32e43b..b12ee290 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -3250,6 +3250,7 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		}
 		leaf = path->nodes[0];
 		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
+
 		cache = kzalloc(sizeof(*cache), GFP_NOFS);
 		if (!cache) {
 			ret = -ENOMEM;
@@ -3266,6 +3267,17 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		if (found_key.offset == 0)
 			key.objectid++;
 		btrfs_release_path(path);
+
+		/*
+		 * Skip 0 sized block group, don't insert them into block
+		 * group cache tree, as its length is 0, it won't get
+		 * freed at close_ctree() time.
+		 */
+		if (found_key.offset == 0) {
+			free(cache);
+			continue;
+		}
+
 		cache->flags = btrfs_block_group_flags(&cache->item);
 		bit = 0;
 		if (cache->flags & BTRFS_BLOCK_GROUP_DATA) {
-- 
2.12.2



