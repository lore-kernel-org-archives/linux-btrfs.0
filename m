From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] btrfs: fix strange indentation in lookup_extent_mapping
Date: Tue, 10 Jun 2008 14:39:00 +0200
Message-ID: <20080610123900.GA31525@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: btrfs-unstable/extent_map.c
===================================================================
--- btrfs-unstable.orig/extent_map.c	2008-06-10 14:37:48.000000000 +0200
+++ btrfs-unstable/extent_map.c	2008-06-10 14:38:12.000000000 +0200
@@ -231,7 +231,13 @@ struct extent_map *lookup_extent_mapping
 {
 	struct extent_map *em;
 	struct rb_node *rb_node;
-	struct rb_node *prev = NULL; struct rb_node *next = NULL; u64 end = range_end(start, len); em = tree->last; if (em && end > em->start && start < extent_map_end(em)) goto found;
+	struct rb_node *prev = NULL;
+	struct rb_node *next = NULL;
+	u64 end = range_end(start, len);
+
+	em = tree->last;
+	if (em && end > em->start && start < extent_map_end(em))
+		goto found;
 
 	rb_node = __tree_search(&tree->map, start, &prev, &next);
 	if (!rb_node && prev) {
