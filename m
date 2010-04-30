From: Bill Pemberton <wfp5p@virginia.edu>
Subject: [PATCH] btrfs: fix shadows sparse warning
Date: Fri, 30 Apr 2010 09:55:12 -0400
Message-ID: <1272635712-9599-1-git-send-email-wfp5p@virginia.edu>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Fix sparse warnings:

fs/btrfs/free-space-cache.c:1078:40: warning: symbol 'node' shadows an earlier one
fs/btrfs/free-space-cache.c:1230:32: warning: symbol 'node' shadows an earlier one

Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
---
 fs/btrfs/free-space-cache.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index f488fac..c0d91fb 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1075,8 +1075,6 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group_cache *block_group,
 
 	while(1) {
 		if (entry->bytes < bytes || entry->offset < min_start) {
-			struct rb_node *node;
-
 			node = rb_next(&entry->offset_index);
 			if (!node)
 				break;
@@ -1227,7 +1225,7 @@ again:
 	 */
 	while (entry->bitmap || found_bitmap ||
 	       (!entry->bitmap && entry->bytes < min_bytes)) {
-		struct rb_node *node = rb_next(&entry->offset_index);
+		node = rb_next(&entry->offset_index);
 
 		if (entry->bitmap && entry->bytes > bytes + empty_size) {
 			ret = btrfs_bitmap_cluster(block_group, entry, cluster,
-- 
1.7.0.6

