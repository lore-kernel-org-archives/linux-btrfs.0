From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 33/35] btrfs: handle errors when excluding super extents
Date: Wed, 21 Mar 2012 21:11:37 -0400
Message-ID: <20120322011137.642386355@suse.com>
References: <20120322011104.212214639@suse.com>
Cc: David Sterba <dsterba@suse.com>, David Sterba <dsterba@suse.cz>
To: Linux Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Some images produced by btrfs-image cause a mount crash in rmap block
when excluding superblock extents. Handle the errors gracefully.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/extent-tree.c |   19 ++++++++++++++++---
 fs/btrfs/volumes.c     |   20 +++++++++++++++++---
 2 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0bdb9fa..8055d58 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -250,10 +250,17 @@ static int exclude_super_stripes(struct btrfs_root *root,
 
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		bytenr = btrfs_sb_offset(i);
+		if (bytenr <= cache->key.objectid + cache->key.offset)
+			break;
+		logical = NULL;
 		ret = btrfs_rmap_block(&root->fs_info->mapping_tree,
 				       cache->key.objectid, bytenr,
 				       0, &logical, &nr, &stripe_len);
-		BUG_ON(ret); /* -ENOMEM */
+		if (ret < 0) {
+			kfree(logical);
+			free_excluded_extents(root, cache);
+			goto out;
+		}
 
 		while (nr--) {
 			cache->bytes_super += stripe_len;
@@ -264,7 +271,9 @@ static int exclude_super_stripes(struct btrfs_root *root,
 
 		kfree(logical);
 	}
-	return 0;
+
+out:
+	return ret;
 }
 
 static struct btrfs_caching_control *
@@ -7665,7 +7674,11 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		 * info has super bytes accounted for, otherwise we'll think
 		 * we have more space than we actually do.
 		 */
-		exclude_super_stripes(root, cache);
+		ret = exclude_super_stripes(root, cache);
+		if (ret < 0) {
+			kfree(cache);
+			goto error;
+		}
 
 		/*
 		 * check for two cases, either we are full, and therefore
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f818f48..3400fbd 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3911,12 +3911,22 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 	u64 length;
 	u64 stripe_nr;
 	int i, j, nr = 0;
+	int ret = 0;
 
 	read_lock(&em_tree->lock);
 	em = lookup_extent_mapping(em_tree, chunk_start, 1);
 	read_unlock(&em_tree->lock);
 
-	BUG_ON(!em || em->start != chunk_start);
+	if (!em)
+		return -ENOENT;
+
+	if (em->start != chunk_start) {
+		printk(KERN_DEBUG "btrfs: rmap em->start %llu != %llu\n",
+				em->start, chunk_start);
+		ret = -EINVAL;
+		goto out_error;
+	}
+
 	map = (struct map_lookup *)em->bdev;
 
 	length = em->len;
@@ -3926,7 +3936,10 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 		do_div(length, map->num_stripes);
 
 	buf = kzalloc(sizeof(u64) * map->num_stripes, GFP_NOFS);
-	BUG_ON(!buf); /* -ENOMEM */
+	if (!buf) {
+		ret = -ENOMEM;
+		goto out_error;
+	}
 
 	for (i = 0; i < map->num_stripes; i++) {
 		if (devid && map->stripes[i].dev->devid != devid)
@@ -3960,8 +3973,9 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 	*naddrs = nr;
 	*stripe_len = map->stripe_len;
 
+out_error:
 	free_extent_map(em);
-	return 0;
+	return ret;
 }
 
 static void btrfs_end_bio(struct bio *bio, int err)
-- 
1.7.9



