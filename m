From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill unused flags field in struct extent_map
Date: Tue, 17 Jun 2008 21:40:23 +0200
Message-ID: <20080617194023.GA18189@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: btrfs-unstable/extent_map.c
===================================================================
--- btrfs-unstable.orig/extent_map.c	2008-06-11 16:17:02.000000000 +0200
+++ btrfs-unstable/extent_map.c	2008-06-11 16:17:11.000000000 +0200
@@ -62,7 +62,6 @@ struct extent_map *alloc_extent_map(gfp_
 	if (!em || IS_ERR(em))
 		return em;
 	em->in_tree = 0;
-	em->flags = 0;
 	atomic_set(&em->refs, 1);
 	return em;
 }
@@ -174,7 +173,6 @@ static inline struct rb_node *tree_searc
 static int mergable_maps(struct extent_map *prev, struct extent_map *next)
 {
 	if (extent_map_end(prev) == next->start &&
-	    prev->flags == next->flags &&
 	    prev->bdev == next->bdev &&
 	    ((next->block_start == EXTENT_MAP_HOLE &&
 	      prev->block_start == EXTENT_MAP_HOLE) ||
Index: btrfs-unstable/extent_map.h
===================================================================
--- btrfs-unstable.orig/extent_map.h	2008-06-11 16:16:00.000000000 +0200
+++ btrfs-unstable/extent_map.h	2008-06-11 16:17:44.000000000 +0200
@@ -15,7 +15,6 @@ struct extent_map {
 	u64 start;
 	u64 len;
 	u64 block_start;
-	unsigned long flags;
 	struct block_device *bdev;
 	atomic_t refs;
 	int in_tree;
Index: btrfs-unstable/file.c
===================================================================
--- btrfs-unstable.orig/file.c	2008-06-11 16:17:20.000000000 +0200
+++ btrfs-unstable/file.c	2008-06-11 16:17:31.000000000 +0200
@@ -380,7 +380,6 @@ int btrfs_drop_extent_cache(struct inode
 			split->len = start - em->start;
 			split->block_start = em->block_start;
 			split->bdev = em->bdev;
-			split->flags = em->flags;
 			ret = add_extent_mapping(em_tree, split);
 			BUG_ON(ret);
 			free_extent_map(split);
@@ -394,8 +393,6 @@ int btrfs_drop_extent_cache(struct inode
 			split->start = start + len;
 			split->len = em->start + em->len - (start + len);
 			split->bdev = em->bdev;
-			split->flags = em->flags;
-
 			split->block_start = em->block_start + diff;
 
 			ret = add_extent_mapping(em_tree, split);
