From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 09/12] btrfs: drop gfp parameter from alloc_extent_map
Date: Fri, 22 Apr 2011 11:42:50 +0200
Message-ID: <a3d26863b49a9bb5da67680c0279b96d6bd0cac1.1303398927.git.dsterba@suse.cz>
References: <cover.1303398927.git.dsterba@suse.cz>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1303398927.git.dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

pass GFP_NOFS directly to kmem_cache_alloc

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/disk-io.c     |    2 +-
 fs/btrfs/extent-tree.c |    2 +-
 fs/btrfs/extent_map.c  |    5 ++---
 fs/btrfs/extent_map.h  |    2 +-
 fs/btrfs/file.c        |    4 ++--
 fs/btrfs/inode.c       |   12 ++++++------
 fs/btrfs/relocation.c  |    2 +-
 fs/btrfs/volumes.c     |    4 ++--
 8 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 59c5bee..1fb8e0c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -154,7 +154,7 @@ static struct extent_map *btree_get_extent(struct inode *inode,
 	}
 	read_unlock(&em_tree->lock);
 
-	em = alloc_extent_map(GFP_NOFS);
+	em = alloc_extent_map();
 	if (!em) {
 		em = ERR_PTR(-ENOMEM);
 		goto out;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9e94f8b..e03bc1b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6688,7 +6688,7 @@ static noinline int relocate_data_extent(struct inode *reloc_inode,
 	u64 start = extent_key->objectid - offset;
 	u64 end = start + extent_key->offset - 1;
 
-	em = alloc_extent_map(GFP_NOFS);
+	em = alloc_extent_map();
 	BUG_ON(!em);
 
 	em->start = start;
diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 3c8f374..2d04103 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -40,16 +40,15 @@ void extent_map_tree_init(struct extent_map_tree *tree)
 
 /**
  * alloc_extent_map - allocate new extent map structure
- * @mask:	memory allocation flags
  *
  * Allocate a new extent_map structure.  The new structure is
  * returned with a reference count of one and needs to be
  * freed using free_extent_map()
  */
-struct extent_map *alloc_extent_map(gfp_t mask)
+struct extent_map *alloc_extent_map(void)
 {
 	struct extent_map *em;
-	em = kmem_cache_alloc(extent_map_cache, mask);
+	em = kmem_cache_alloc(extent_map_cache, GFP_NOFS);
 	if (!em)
 		return NULL;
 	em->in_tree = 0;
diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index 255813c..33a7890 100644
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -56,7 +56,7 @@ int add_extent_mapping(struct extent_map_tree *tree,
 		       struct extent_map *em);
 int remove_extent_mapping(struct extent_map_tree *tree, struct extent_map *em);
 
-struct extent_map *alloc_extent_map(gfp_t mask);
+struct extent_map *alloc_extent_map(void);
 void free_extent_map(struct extent_map *em);
 int __init extent_map_init(void);
 void extent_map_exit(void);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 83abd27..80eabe8 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -191,9 +191,9 @@ int btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
 	}
 	while (1) {
 		if (!split)
-			split = alloc_extent_map(GFP_NOFS);
+			split = alloc_extent_map();
 		if (!split2)
-			split2 = alloc_extent_map(GFP_NOFS);
+			split2 = alloc_extent_map();
 		BUG_ON(!split || !split2);
 
 		write_lock(&em_tree->lock);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4ef41fe..3a1d4c1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -649,7 +649,7 @@ retry:
 					async_extent->start +
 					async_extent->ram_size - 1, 0);
 
-		em = alloc_extent_map(GFP_NOFS);
+		em = alloc_extent_map();
 		BUG_ON(!em);
 		em->start = async_extent->start;
 		em->len = async_extent->ram_size;
@@ -826,7 +826,7 @@ static noinline int cow_file_range(struct inode *inode,
 					   (u64)-1, &ins, 1);
 		BUG_ON(ret);
 
-		em = alloc_extent_map(GFP_NOFS);
+		em = alloc_extent_map();
 		BUG_ON(!em);
 		em->start = start;
 		em->orig_start = em->start;
@@ -1176,7 +1176,7 @@ out_check:
 			struct extent_map *em;
 			struct extent_map_tree *em_tree;
 			em_tree = &BTRFS_I(inode)->extent_tree;
-			em = alloc_extent_map(GFP_NOFS);
+			em = alloc_extent_map();
 			BUG_ON(!em);
 			em->start = cur_offset;
 			em->orig_start = em->start;
@@ -5064,7 +5064,7 @@ again:
 		else
 			goto out;
 	}
-	em = alloc_extent_map(GFP_NOFS);
+	em = alloc_extent_map();
 	if (!em) {
 		err = -ENOMEM;
 		goto out;
@@ -5377,7 +5377,7 @@ struct extent_map *btrfs_get_extent_fiemap(struct inode *inode, struct page *pag
 		u64 hole_start = start;
 		u64 hole_len = len;
 
-		em = alloc_extent_map(GFP_NOFS);
+		em = alloc_extent_map();
 		if (!em) {
 			err = -ENOMEM;
 			goto out;
@@ -5478,7 +5478,7 @@ static struct extent_map *btrfs_new_extent_direct(struct inode *inode,
 	}
 
 	if (!em) {
-		em = alloc_extent_map(GFP_NOFS);
+		em = alloc_extent_map();
 		if (!em) {
 			em = ERR_PTR(-ENOMEM);
 			goto out;
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index f3edf45..2097a88 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2870,7 +2870,7 @@ int setup_extent_mapping(struct inode *inode, u64 start, u64 end,
 	struct extent_map *em;
 	int ret = 0;
 
-	em = alloc_extent_map(GFP_NOFS);
+	em = alloc_extent_map();
 	if (!em)
 		return -ENOMEM;
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 64b30d3..d48bbe6 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2599,7 +2599,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 
 	trace_btrfs_chunk_alloc(info->chunk_root, map, start, *num_bytes);
 
-	em = alloc_extent_map(GFP_NOFS);
+	em = alloc_extent_map();
 	if (!em) {
 		ret = -ENOMEM;
 		goto error;
@@ -3489,7 +3489,7 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 		free_extent_map(em);
 	}
 
-	em = alloc_extent_map(GFP_NOFS);
+	em = alloc_extent_map();
 	if (!em)
 		return -ENOMEM;
 	num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
-- 
1.7.5.rc3

