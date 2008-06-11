From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] btrfs: kerneldoc comments for extent_map.c
Date: Wed, 11 Jun 2008 16:15:10 +0200
Message-ID: <20080611141510.GA20088@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Add kerneldoc comments for all exported functions.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: btrfs-unstable/extent_map.c
===================================================================
--- btrfs-unstable.orig/extent_map.c	2008-06-11 16:05:31.000000000 +0200
+++ btrfs-unstable/extent_map.c	2008-06-11 16:13:37.000000000 +0200
@@ -31,6 +31,14 @@ void extent_map_exit(void)
 		kmem_cache_destroy(extent_map_cache);
 }
 
+/**
+ * extent_map_tree_init - initialize extent map tree
+ * @tree:		tree to initialize
+ * @mask:		flags for memory allocations during tree operations
+ *
+ * Initialize the extent tree @tree.  Should be called for each new inode
+ * or other user of the extent_map interface.
+ */
 void extent_map_tree_init(struct extent_map_tree *tree, gfp_t mask)
 {
 	tree->map.rb_node = NULL;
@@ -39,6 +47,14 @@ void extent_map_tree_init(struct extent_
 }
 EXPORT_SYMBOL(extent_map_tree_init);
 
+/**
+ * alloc_extent_map - allocate new extent map structure
+ * @mask:	memory allocation flags
+ *
+ * Allocate a new extent_map structure.  The new structure is
+ * returned with a reference count of one and needs to be
+ * freed using free_extent_map()
+ */
 struct extent_map *alloc_extent_map(gfp_t mask)
 {
 	struct extent_map *em;
@@ -52,6 +68,13 @@ struct extent_map *alloc_extent_map(gfp_
 }
 EXPORT_SYMBOL(alloc_extent_map);
 
+/**
+ * free_extent_map - drop reference count of an extent_map
+ * @em:		extent map beeing releasead
+ *
+ * Drops the reference out on @em by one and free the structure
+ * if the reference count hits zero.
+ */
 void free_extent_map(struct extent_map *em)
 {
 	if (!em)
@@ -166,10 +189,15 @@ static int mergable_maps(struct extent_m
 	return 0;
 }
 
-/*
- * add_extent_mapping tries a simple forward/backward merge with existing
- * mappings.  The extent_map struct passed in will be inserted into
- * the tree directly (no copies made, just a reference taken).
+/**
+ * add_extent_mapping - add new extent map to the extent tree
+ * @tree:	tree to insert new map in
+ * @em:		map to insert
+ *
+ * Insert @em into @tree or perform a simple forward/backward merge with
+ * existing mappings.  The extent_map struct passed in will be inserted
+ * into the tree directly, with an additional reference taken, or a
+ * reference dropped if the merge attempt was sucessfull.
  */
 int add_extent_mapping(struct extent_map_tree *tree,
 		       struct extent_map *em)
@@ -220,11 +248,16 @@ static u64 range_end(u64 start, u64 len)
 	return start + len;
 }
 
-/*
- * lookup_extent_mapping returns the first extent_map struct in the
- * tree that intersects the [start, len] range.  There may
- * be additional objects in the tree that intersect, so check the object
- * returned carefully to make sure you don't need additional lookups.
+/**
+ * lookup_extent_mapping - lookup extent_map
+ * @tree:	tree to lookup in
+ * @start:	byte offset to start the search
+ * @len:	length of the lookup range
+ *
+ * Find and return the first extent_map struct in @tree that intersects the
+ * [start, len] range.  There may be additional objects in the tree that
+ * intersect, so check the object returned carefully to make sure that no
+ * additional lookups are needed.
  */
 struct extent_map *lookup_extent_mapping(struct extent_map_tree *tree,
 					 u64 start, u64 len)
@@ -273,9 +306,13 @@ out:
 }
 EXPORT_SYMBOL(lookup_extent_mapping);
 
-/*
- * removes an extent_map struct from the tree.  No reference counts are
- * dropped, and no checks are done to  see if the range is in use
+/**
+ * remove_extent_mapping - removes an extent_map from the extent tree
+ * @tree:	extent tree to remove from
+ * @em:		extent map beeing removed
+ *
+ * Removes @em from @tree.  No reference counts are dropped, and no checks
+ * are done to see if the range is in use
  */
 int remove_extent_mapping(struct extent_map_tree *tree, struct extent_map *em)
 {
