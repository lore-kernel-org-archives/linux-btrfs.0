From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] btrfs: don't export symbols
Date: Mon, 13 Apr 2009 15:33:56 +0200
Message-ID: <20090413133356.GC11746@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Currently the extent_map code is only for btrfs so don't export it's
symbols. 


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/btrfs/extent_map.c
===================================================================
--- linux-2.6.orig/fs/btrfs/extent_map.c	2009-04-13 13:15:06.919487729 +0200
+++ linux-2.6/fs/btrfs/extent_map.c	2009-04-13 13:16:14.001604970 +0200
@@ -38,7 +38,6 @@ void extent_map_tree_init(struct extent_
 	tree->map.rb_node = NULL;
 	spin_lock_init(&tree->lock);
 }
-EXPORT_SYMBOL(extent_map_tree_init);
 
 /**
  * alloc_extent_map - allocate new extent map structure
@@ -59,7 +58,6 @@ struct extent_map *alloc_extent_map(gfp_
 	atomic_set(&em->refs, 1);
 	return em;
 }
-EXPORT_SYMBOL(alloc_extent_map);
 
 /**
  * free_extent_map - drop reference count of an extent_map
@@ -78,7 +76,6 @@ void free_extent_map(struct extent_map *
 		kmem_cache_free(extent_map_cache, em);
 	}
 }
-EXPORT_SYMBOL(free_extent_map);
 
 static struct rb_node *tree_insert(struct rb_root *root, u64 offset,
 				   struct rb_node *node)
@@ -259,7 +256,6 @@ int add_extent_mapping(struct extent_map
 out:
 	return ret;
 }
-EXPORT_SYMBOL(add_extent_mapping);
 
 /* simple helper to do math around the end of an extent, handling wrap */
 static u64 range_end(u64 start, u64 len)
@@ -321,7 +317,6 @@ found:
 out:
 	return em;
 }
-EXPORT_SYMBOL(lookup_extent_mapping);
 
 /**
  * remove_extent_mapping - removes an extent_map from the extent tree
@@ -341,4 +336,3 @@ int remove_extent_mapping(struct extent_
 	em->in_tree = 0;
 	return ret;
 }
-EXPORT_SYMBOL(remove_extent_mapping);
