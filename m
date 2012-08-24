Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47161 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687Ab2HXA0k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Aug 2012 20:26:40 -0400
Received: from /spool/local
	by e6.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <clinew@linux.vnet.ibm.com>;
	Thu, 23 Aug 2012 20:26:39 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id B714438C803D
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2012 20:26:36 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q7O0QaAs096178
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2012 20:26:36 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q7O0QZYt018622
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2012 21:26:36 -0300
From: clinew@linux.vnet.ibm.com
To: linux-btrfs@vger.kernel.org
Cc: cmm@linux.vnet.ibm.com, Wade Cline <wcline@us.ibm.com>
Subject: [PATCH] Clean-up of __tree_search() in extent_map.c
Date: Thu, 23 Aug 2012 17:26:20 -0700
Message-Id: <1345767980-7165-1-git-send-email-clinew@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wade Cline <wcline@us.ibm.com>

Removed extra variables orig_prev and prev_entry. Clarified variable
names. Added function documentation and code comments.

Signed-off-by: Wade Cline <wcline@us.ibm.com>
---
 fs/btrfs/extent_map.c |   60 +++++++++++++++++++++++++++---------------------
 1 files changed, 34 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 7c97b33..b1ac153 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -104,53 +104,61 @@ static struct rb_node *tree_insert(struct rb_root *root, u64 offset,
 	return NULL;
 }
 
-/*
- * search through the tree for an extent_map with a given offset.  If
- * it can't be found, try to find some neighboring extents
+/**
+ * __tree_search - Search for an extent_map with the given offset.
+ * @root:	The root of the tree to search.
+ * @offset:	Offset in bytes to search for.
+ * @prev_ret:	extent_map before the given offset.
+ * @next_ret:	extent_map after the given offset.
+ *
+ * Search through the tree for an extent_map with a given offset.  If
+ * it can't be found, try to find some neighboring extents.
  */
 static struct rb_node *__tree_search(struct rb_root *root, u64 offset,
 				     struct rb_node **prev_ret,
 				     struct rb_node **next_ret)
 {
-	struct rb_node *n = root->rb_node;
-	struct rb_node *prev = NULL;
-	struct rb_node *orig_prev = NULL;
-	struct extent_map *entry;
-	struct extent_map *prev_entry = NULL;
+	struct rb_node *node = root->rb_node;
+	struct rb_node *prev_node = NULL;
+	struct extent_map *entry = NULL;
 
-	while (n) {
-		entry = rb_entry(n, struct extent_map, rb_node);
-		prev = n;
-		prev_entry = entry;
+	/* Search for an extent map with the given offset. */
+	while (node) {
+		entry = rb_entry(node, struct extent_map, rb_node);
+		prev_node = node;
 
 		WARN_ON(!entry->in_tree);
 
 		if (offset < entry->start)
-			n = n->rb_left;
+			node = node->rb_left;
 		else if (offset >= extent_map_end(entry))
-			n = n->rb_right;
+			node = node->rb_right;
 		else
-			return n;
+			return node;
 	}
 
+	/* Search for an extent map before the given offset. */
 	if (prev_ret) {
-		orig_prev = prev;
-		while (prev && offset >= extent_map_end(prev_entry)) {
-			prev = rb_next(prev);
-			prev_entry = rb_entry(prev, struct extent_map, rb_node);
+		node = prev_node;
+		while (node && offset >= extent_map_end(entry)) {
+			node = rb_next(node);
+			entry = rb_entry(node, struct extent_map, rb_node);
 		}
-		*prev_ret = prev;
-		prev = orig_prev;
+		*prev_ret = node;
 	}
 
+	/* Search for an extent map after the given offset. */
 	if (next_ret) {
-		prev_entry = rb_entry(prev, struct extent_map, rb_node);
-		while (prev && offset < prev_entry->start) {
-			prev = rb_prev(prev);
-			prev_entry = rb_entry(prev, struct extent_map, rb_node);
+		node = prev_node;
+		entry = rb_entry(node, struct extent_map, rb_node);
+		while (node && offset < entry->start) {
+			node = rb_prev(node);
+			entry = rb_entry(node, struct extent_map, rb_node);
 		}
-		*next_ret = prev;
+		*next_ret = node;
 	}
+
+	/* None found. */
 	return NULL;
 }
 
-- 
1.7.8.6

