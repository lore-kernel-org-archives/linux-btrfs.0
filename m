Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:42730 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab2IFGkw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Sep 2012 02:40:52 -0400
Message-ID: <50484569.8080709@gmail.com>
Date: Thu, 06 Sep 2012 14:40:41 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] btrfs: remove unnecessary -ENOMEM BUG_ON check in extent-tree.c/exclude_super_stripes
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The memory allocation failure is BUG_ON in add_excluded_extent (following
the code path) and btrfs_rmap_block. No need to BUG_ON -ENOMEM inside
exclude_super_stripes itself.

Its return value is always 0, and useless for its callers. Set it as void
instead 0-returned.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/extent-tree.c |   20 +++++++-------------
 1 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ba58024..95492cc 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -234,39 +234,33 @@ static void free_excluded_extents(struct btrfs_root *root,
 			  start, end, EXTENT_UPTODATE, GFP_NOFS);
 }
 
-static int exclude_super_stripes(struct btrfs_root *root,
+static void exclude_super_stripes(struct btrfs_root *root,
 				 struct btrfs_block_group_cache *cache)
 {
 	u64 bytenr;
 	u64 *logical;
 	int stripe_len;
-	int i, nr, ret;
+	int i, nr;
 
 	if (cache->key.objectid < BTRFS_SUPER_INFO_OFFSET) {
 		stripe_len = BTRFS_SUPER_INFO_OFFSET - cache->key.objectid;
 		cache->bytes_super += stripe_len;
-		ret = add_excluded_extent(root, cache->key.objectid,
-					  stripe_len);
-		BUG_ON(ret); /* -ENOMEM */
+		add_excluded_extent(root, cache->key.objectid, stripe_len);
 	}
 
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		bytenr = btrfs_sb_offset(i);
-		ret = btrfs_rmap_block(&root->fs_info->mapping_tree,
-				       cache->key.objectid, bytenr,
-				       0, &logical, &nr, &stripe_len);
-		BUG_ON(ret); /* -ENOMEM */
+		btrfs_rmap_block(&root->fs_info->mapping_tree,
+				 cache->key.objectid, bytenr,
+				 0, &logical, &nr, &stripe_len);
 
 		while (nr--) {
 			cache->bytes_super += stripe_len;
-			ret = add_excluded_extent(root, logical[nr],
-						  stripe_len);
-			BUG_ON(ret); /* -ENOMEM */
+			add_excluded_extent(root, logical[nr], stripe_len);
 		}
 
 		kfree(logical);
 	}
-	return 0;
 }
 
 static struct btrfs_caching_control *
-- 
1.7.1
