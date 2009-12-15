From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 2/4] btrfs: cleanup the code in lookup_extent_mapping()
Date: Tue, 15 Dec 2009 14:54:13 +0800
Message-ID: <4B273295.6000605@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

It is unnecessary to check whether the range intersects the prev extent, because
the end of the prev extent must be less than or equal the start of the range to
search.

This patch cleanups those unnecessary check code in lookup_extent_mapping()

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent_map.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 16744f4..ef49e31 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -330,11 +330,6 @@ struct extent_map *lookup_extent_mapping(struct extent_map_tree *tree,
 	u64 end = range_end(start, len);
 
 	rb_node = __tree_search(&tree->map, start, &prev, &next);
-	if (!rb_node && prev) {
-		em = rb_entry(prev, struct extent_map, rb_node);
-		if (end > em->start && start < extent_map_end(em))
-			goto found;
-	}
 	if (!rb_node && next) {
 		em = rb_entry(next, struct extent_map, rb_node);
 		if (end > em->start && start < extent_map_end(em))
-- 
1.6.5.2


