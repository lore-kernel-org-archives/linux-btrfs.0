From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 12/16] Btrfs: clean up code for merging extent maps
Date: Thu, 14 Jul 2011 11:18:33 +0800
Message-ID: <4E1E6009.1010903@cn.fujitsu.com>
References: <4E1E5F59.5030208@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E1E5F59.5030208@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

unpin_extent_cache() and add_extent_mapping() shares the same code
that merges extent maps.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/extent_map.c |   59 +++++++++++++++++-------------------------------
 1 files changed, 21 insertions(+), 38 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index df7a803..7c97b33 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -183,22 +183,10 @@ static int mergable_maps(struct extent_map *prev, struct extent_map *next)
 	return 0;
 }
 
-int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len)
+static void try_merge_map(struct extent_map_tree *tree, struct extent_map *em)
 {
-	int ret = 0;
 	struct extent_map *merge = NULL;
 	struct rb_node *rb;
-	struct extent_map *em;
-
-	write_lock(&tree->lock);
-	em = lookup_extent_mapping(tree, start, len);
-
-	WARN_ON(!em || em->start != start);
-
-	if (!em)
-		goto out;
-
-	clear_bit(EXTENT_FLAG_PINNED, &em->flags);
 
 	if (em->start != 0) {
 		rb = rb_prev(&em->rb_node);
@@ -225,6 +213,24 @@ int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len)
 		merge->in_tree = 0;
 		free_extent_map(merge);
 	}
+}
+
+int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len)
+{
+	int ret = 0;
+	struct extent_map *em;
+
+	write_lock(&tree->lock);
+	em = lookup_extent_mapping(tree, start, len);
+
+	WARN_ON(!em || em->start != start);
+
+	if (!em)
+		goto out;
+
+	clear_bit(EXTENT_FLAG_PINNED, &em->flags);
+
+	try_merge_map(tree, em);
 
 	free_extent_map(em);
 out:
@@ -247,7 +253,6 @@ int add_extent_mapping(struct extent_map_tree *tree,
 		       struct extent_map *em)
 {
 	int ret = 0;
-	struct extent_map *merge = NULL;
 	struct rb_node *rb;
 	struct extent_map *exist;
 
@@ -263,30 +268,8 @@ int add_extent_mapping(struct extent_map_tree *tree,
 		goto out;
 	}
 	atomic_inc(&em->refs);
-	if (em->start != 0) {
-		rb = rb_prev(&em->rb_node);
-		if (rb)
-			merge = rb_entry(rb, struct extent_map, rb_node);
-		if (rb && mergable_maps(merge, em)) {
-			em->start = merge->start;
-			em->len += merge->len;
-			em->block_len += merge->block_len;
-			em->block_start = merge->block_start;
-			merge->in_tree = 0;
-			rb_erase(&merge->rb_node, &tree->map);
-			free_extent_map(merge);
-		}
-	 }
-	rb = rb_next(&em->rb_node);
-	if (rb)
-		merge = rb_entry(rb, struct extent_map, rb_node);
-	if (rb && mergable_maps(em, merge)) {
-		em->len += merge->len;
-		em->block_len += merge->len;
-		rb_erase(&merge->rb_node, &tree->map);
-		merge->in_tree = 0;
-		free_extent_map(merge);
-	}
+
+	try_merge_map(tree, em);
 out:
 	return ret;
 }
-- 
1.7.3.1
