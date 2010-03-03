From: jim owens <owens6336@gmail.com>
Subject: [PATCH V2] Btrfs: add direct I/O helper to return mirror count from
 extent_map.
Date: Wed, 03 Mar 2010 10:31:03 -0500
Message-ID: <4B8E80B7.3090404@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Direct I/O retry needs to know the number of mirror copies.

Signed-off-by: jim owens <jowens@hp.com>
Signed-off-by: jim owens <jim6336@gmail.com>
---

V2 fixes whitespace checkpatch warning

 fs/btrfs/volumes.c |   22 ++++++++++++++--------
 fs/btrfs/volumes.h |    1 +
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5ca2c6d..4cd4754 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2579,10 +2579,20 @@ void btrfs_mapping_tree_free(struct btrfs_mapping_tree *tree)
 	}
 }
 
+int btrfs_map_num_copies(struct extent_map *em)
+{
+	struct map_lookup *map = (struct map_lookup *)em->bdev;
+
+	if (map->type & (BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID1))
+		return map->num_stripes;
+	if (map->type & BTRFS_BLOCK_GROUP_RAID10)
+		return map->sub_stripes;
+	return 1;
+}
+
 int btrfs_num_copies(struct btrfs_mapping_tree *map_tree, u64 logical, u64 len)
 {
 	struct extent_map *em;
-	struct map_lookup *map;
 	struct extent_map_tree *em_tree = &map_tree->map_tree;
 	int ret;
 
@@ -2592,13 +2602,9 @@ int btrfs_num_copies(struct btrfs_mapping_tree *map_tree, u64 logical, u64 len)
 	BUG_ON(!em);
 
 	BUG_ON(em->start > logical || em->start + em->len < logical);
-	map = (struct map_lookup *)em->bdev;
-	if (map->type & (BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID1))
-		ret = map->num_stripes;
-	else if (map->type & BTRFS_BLOCK_GROUP_RAID10)
-		ret = map->sub_stripes;
-	else
-		ret = 1;
+
+	ret = btrfs_map_num_copies(em);
+
 	free_extent_map(em);
 	return ret;
 }
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 226200d..732c8c5 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -195,4 +195,5 @@ int find_free_dev_extent(struct btrfs_trans_handle *trans,
 int btrfs_map_stripe_count(struct extent_map *em);
 struct block_device *btrfs_map_stripe_bdev(struct extent_map *em, int stripe);
 u64 btrfs_map_stripe_physical(struct extent_map *em, int stripe);
+int btrfs_map_num_copies(struct extent_map *em);
 #endif
-- 
1.6.3.3
