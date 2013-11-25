Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:47292 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab3KYD2p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Nov 2013 22:28:45 -0500
Received: by mail-we0-f178.google.com with SMTP id u56so3237272wes.23
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Nov 2013 19:28:44 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: faster and more efficient extent map insertion
Date: Mon, 25 Nov 2013 03:23:51 +0000
Message-Id: <1385349831-1438-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before this change, adding an extent map to the extent map tree of an
inode required 2 tree nevigations:

1) doing a tree navigation to search for an existing extent map starting
   at the same offset or an extent map that overlaps the extent map we
   want to insert;

2) Another tree navigation to add the extent map to the tree (if the
   former tree search didn't found anything).

This change just merges these 2 steps into a single one.
While running first few btrfs xfstests I had noticed these trees easily
had a few hundred elements, and then with the following sysbench test it
reached over 1100 elements very often.

Test:

  sysbench --test=fileio --file-num=32 --file-total-size=10G \
    --file-test-mode=seqwr --num-threads=512 --file-block-size=8192 \
    --max-requests=1000000 --file-io-mode=sync [prepare|run]

(fs created with mkfs.btrfs -l 4096 -f /dev/sdb3 before each sysbench
prepare phase)

Before this patch:

run 1 - 41.894Mb/sec
run 2 - 40.527Mb/sec
run 3 - 40.922Mb/sec
run 4 - 49.433Mb/sec
run 5 - 40.959Mb/sec

average - 42.75Mb/sec

After this patch:

run 1 - 48.036Mb/sec
run 2 - 50.21Mb/sec
run 3 - 50.929Mb/sec
run 4 - 46.881Mb/sec
run 5 - 53.192Mb/sec

average - 49.85Mb/sec

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/extent_map.c |   72 ++++++++++++++++++++++++++++---------------------
 1 file changed, 41 insertions(+), 31 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index a4a7a1a..b60955d 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -79,12 +79,21 @@ void free_extent_map(struct extent_map *em)
 	}
 }
 
-static struct rb_node *tree_insert(struct rb_root *root, u64 offset,
-				   struct rb_node *node)
+/* simple helper to do math around the end of an extent, handling wrap */
+static u64 range_end(u64 start, u64 len)
+{
+	if (start + len < start)
+		return (u64)-1;
+	return start + len;
+}
+
+static int tree_insert(struct rb_root *root, struct extent_map *em)
 {
 	struct rb_node **p = &root->rb_node;
 	struct rb_node *parent = NULL;
-	struct extent_map *entry;
+	struct extent_map *entry = NULL;
+	struct rb_node *orig_parent = NULL;
+	u64 end = range_end(em->start, em->len);
 
 	while (*p) {
 		parent = *p;
@@ -92,19 +101,37 @@ static struct rb_node *tree_insert(struct rb_root *root, u64 offset,
 
 		WARN_ON(!entry->in_tree);
 
-		if (offset < entry->start)
+		if (em->start < entry->start)
 			p = &(*p)->rb_left;
-		else if (offset >= extent_map_end(entry))
+		else if (em->start >= extent_map_end(entry))
 			p = &(*p)->rb_right;
 		else
-			return parent;
+			return -EEXIST;
 	}
 
-	entry = rb_entry(node, struct extent_map, rb_node);
-	entry->in_tree = 1;
-	rb_link_node(node, parent, p);
-	rb_insert_color(node, root);
-	return NULL;
+	orig_parent = parent;
+	while (parent && em->start >= extent_map_end(entry)) {
+		parent = rb_next(parent);
+		entry = rb_entry(parent, struct extent_map, rb_node);
+	}
+	if (parent)
+		if (end > entry->start && em->start < extent_map_end(entry))
+			return -EEXIST;
+
+	parent = orig_parent;
+	entry = rb_entry(parent, struct extent_map, rb_node);
+	while (parent && em->start < entry->start) {
+		parent = rb_prev(parent);
+		entry = rb_entry(parent, struct extent_map, rb_node);
+	}
+	if (parent)
+		if (end > entry->start && em->start < extent_map_end(entry))
+			return -EEXIST;
+
+	em->in_tree = 1;
+	rb_link_node(&em->rb_node, orig_parent, p);
+	rb_insert_color(&em->rb_node, root);
+	return 0;
 }
 
 /*
@@ -310,20 +337,11 @@ int add_extent_mapping(struct extent_map_tree *tree,
 		       struct extent_map *em, int modified)
 {
 	int ret = 0;
-	struct rb_node *rb;
-	struct extent_map *exist;
 
-	exist = lookup_extent_mapping(tree, em->start, em->len);
-	if (exist) {
-		free_extent_map(exist);
-		ret = -EEXIST;
-		goto out;
-	}
-	rb = tree_insert(&tree->map, em->start, &em->rb_node);
-	if (rb) {
-		ret = -EEXIST;
+	ret = tree_insert(&tree->map, em);
+	if (ret)
 		goto out;
-	}
+
 	atomic_inc(&em->refs);
 
 	em->mod_start = em->start;
@@ -337,14 +355,6 @@ out:
 	return ret;
 }
 
-/* simple helper to do math around the end of an extent, handling wrap */
-static u64 range_end(u64 start, u64 len)
-{
-	if (start + len < start)
-		return (u64)-1;
-	return start + len;
-}
-
 static struct extent_map *
 __lookup_extent_mapping(struct extent_map_tree *tree,
 			u64 start, u64 len, int strict)
-- 
1.7.9.5

