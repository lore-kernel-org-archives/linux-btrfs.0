From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH] btrfs: fix race in reada
Date: Sat, 25 Feb 2012 09:09:30 +0100
Message-ID: <1330157370-6764-1-git-send-email-sensille@gmx.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When inserting into the radix tree returns EEXIST, get the existing
entry without giving up the spinlock in between.
There was a race for both the zones trees and the extent tree.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/reada.c |   36 ++++++++++++++++--------------------
 1 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 2373b39..85ce503 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -250,14 +250,12 @@ static struct reada_zone *reada_find_zone(struct btrfs_fs_info *fs_info,
 					  struct btrfs_bio *bbio)
 {
 	int ret;
-	int looped = 0;
 	struct reada_zone *zone;
 	struct btrfs_block_group_cache *cache = NULL;
 	u64 start;
 	u64 end;
 	int i;
 
-again:
 	zone = NULL;
 	spin_lock(&fs_info->reada_lock);
 	ret = radix_tree_gang_lookup(&dev->reada_zones, (void **)&zone,
@@ -274,9 +272,6 @@ again:
 		spin_unlock(&fs_info->reada_lock);
 	}
 
-	if (looped)
-		return NULL;
-
 	cache = btrfs_lookup_block_group(fs_info, logical);
 	if (!cache)
 		return NULL;
@@ -307,13 +302,14 @@ again:
 	ret = radix_tree_insert(&dev->reada_zones,
 				(unsigned long)zone->end >> PAGE_CACHE_SHIFT,
 				zone);
-	spin_unlock(&fs_info->reada_lock);
-
-	if (ret) {
+	if (ret == -EEXIST) {
 		kfree(zone);
-		looped = 1;
-		goto again;
+		ret = radix_tree_gang_lookup(&dev->reada_zones, (void **)&zone,
+					     logical >> PAGE_CACHE_SHIFT, 1);
+		if (ret == 1)
+			kref_get(&zone->refcnt);
 	}
+	spin_unlock(&fs_info->reada_lock);
 
 	return zone;
 }
@@ -323,8 +319,8 @@ static struct reada_extent *reada_find_extent(struct btrfs_root *root,
 					      struct btrfs_key *top, int level)
 {
 	int ret;
-	int looped = 0;
 	struct reada_extent *re = NULL;
+	struct reada_extent *re_exist = NULL;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
 	struct btrfs_bio *bbio = NULL;
@@ -335,14 +331,13 @@ static struct reada_extent *reada_find_extent(struct btrfs_root *root,
 	int i;
 	unsigned long index = logical >> PAGE_CACHE_SHIFT;
 
-again:
 	spin_lock(&fs_info->reada_lock);
 	re = radix_tree_lookup(&fs_info->reada_tree, index);
 	if (re)
 		kref_get(&re->refcnt);
 	spin_unlock(&fs_info->reada_lock);
 
-	if (re || looped)
+	if (re)
 		return re;
 
 	re = kzalloc(sizeof(*re), GFP_NOFS);
@@ -398,12 +393,15 @@ again:
 	/* insert extent in reada_tree + all per-device trees, all or nothing */
 	spin_lock(&fs_info->reada_lock);
 	ret = radix_tree_insert(&fs_info->reada_tree, index, re);
+	if (ret == -EEXIST) {
+		re_exist = radix_tree_lookup(&fs_info->reada_tree, index);
+		BUG_ON(!re_exist);
+		kref_get(&re_exist->refcnt);
+		spin_unlock(&fs_info->reada_lock);
+		goto error;
+	}
 	if (ret) {
 		spin_unlock(&fs_info->reada_lock);
-		if (ret != -ENOMEM) {
-			/* someone inserted the extent in the meantime */
-			looped = 1;
-		}
 		goto error;
 	}
 	for (i = 0; i < nzones; ++i) {
@@ -450,9 +448,7 @@ error:
 	}
 	kfree(bbio);
 	kfree(re);
-	if (looped)
-		goto again;
-	return NULL;
+	return re_exist;
 }
 
 static void reada_kref_dummy(struct kref *kr)
-- 
1.7.3.4

