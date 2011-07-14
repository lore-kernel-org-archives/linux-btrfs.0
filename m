From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 11/16] Btrfs: clean up code for extent_map lookup
Date: Thu, 14 Jul 2011 11:18:15 +0800
Message-ID: <4E1E5FF7.7060202@cn.fujitsu.com>
References: <4E1E5F59.5030208@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E1E5F59.5030208@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

lookup_extent_map() and search_extent_map() can share most of code.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/extent_map.c |   85 +++++++++++++++++--------------------------------
 1 files changed, 29 insertions(+), 56 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 911a9db..df7a803 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -299,19 +299,8 @@ static u64 range_end(u64 start, u64 len)
 	return start + len;
 }
 
-/**
- * lookup_extent_mapping - lookup extent_map
- * @tree:	tree to lookup in
- * @start:	byte offset to start the search
- * @len:	length of the lookup range
- *
- * Find and return the first extent_map struct in @tree that intersects the
- * [start, len] range.  There may be additional objects in the tree that
- * intersect, so check the object returned carefully to make sure that no
- * additional lookups are needed.
- */
-struct extent_map *lookup_extent_mapping(struct extent_map_tree *tree,
-					 u64 start, u64 len)
+struct extent_map *__lookup_extent_mapping(struct extent_map_tree *tree,
+					   u64 start, u64 len, int strict)
 {
 	struct extent_map *em;
 	struct rb_node *rb_node;
@@ -320,38 +309,42 @@ struct extent_map *lookup_extent_mapping(struct extent_map_tree *tree,
 	u64 end = range_end(start, len);
 
 	rb_node = __tree_search(&tree->map, start, &prev, &next);
-	if (!rb_node && prev) {
-		em = rb_entry(prev, struct extent_map, rb_node);
-		if (end > em->start && start < extent_map_end(em))
-			goto found;
-	}
-	if (!rb_node && next) {
-		em = rb_entry(next, struct extent_map, rb_node);
-		if (end > em->start && start < extent_map_end(em))
-			goto found;
-	}
 	if (!rb_node) {
-		em = NULL;
-		goto out;
-	}
-	if (IS_ERR(rb_node)) {
-		em = ERR_CAST(rb_node);
-		goto out;
+		if (prev)
+			rb_node = prev;
+		else if (next)
+			rb_node = next;
+		else
+			return NULL;
 	}
+
 	em = rb_entry(rb_node, struct extent_map, rb_node);
-	if (end > em->start && start < extent_map_end(em))
-		goto found;
 
-	em = NULL;
-	goto out;
+	if (strict && !(end > em->start && start < extent_map_end(em)))
+		return NULL;
 
-found:
 	atomic_inc(&em->refs);
-out:
 	return em;
 }
 
 /**
+ * lookup_extent_mapping - lookup extent_map
+ * @tree:	tree to lookup in
+ * @start:	byte offset to start the search
+ * @len:	length of the lookup range
+ *
+ * Find and return the first extent_map struct in @tree that intersects the
+ * [start, len] range.  There may be additional objects in the tree that
+ * intersect, so check the object returned carefully to make sure that no
+ * additional lookups are needed.
+ */
+struct extent_map *lookup_extent_mapping(struct extent_map_tree *tree,
+					 u64 start, u64 len)
+{
+	return __lookup_extent_mapping(tree, start, len, 1);
+}
+
+/**
  * search_extent_mapping - find a nearby extent map
  * @tree:	tree to lookup in
  * @start:	byte offset to start the search
@@ -365,27 +358,7 @@ out:
 struct extent_map *search_extent_mapping(struct extent_map_tree *tree,
 					 u64 start, u64 len)
 {
-	struct extent_map *em;
-	struct rb_node *rb_node;
-	struct rb_node *prev = NULL;
-	struct rb_node *next = NULL;
-
-	rb_node = __tree_search(&tree->map, start, &prev, &next);
-	if (!rb_node && prev) {
-		em = rb_entry(prev, struct extent_map, rb_node);
-		goto found;
-	}
-	if (!rb_node && next) {
-		em = rb_entry(next, struct extent_map, rb_node);
-		goto found;
-	}
-	if (!rb_node)
-		return NULL;
-
-	em = rb_entry(rb_node, struct extent_map, rb_node);
-found:
-	atomic_inc(&em->refs);
-	return em;
+	return __lookup_extent_mapping(tree, start, len, 0);
 }
 
 /**
-- 
1.7.3.1
