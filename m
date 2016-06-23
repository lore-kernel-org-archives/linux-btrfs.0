Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51854 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbcFWT0J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 15:26:09 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 1A121ACBD
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jun 2016 19:26:08 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs-progs: check: supplement extent backref list with rbtree
Date: Thu, 23 Jun 2016 15:26:05 -0400
Message-Id: <1466709966-31506-3-git-send-email-jeffm@suse.com>
In-Reply-To: <1466709966-31506-1-git-send-email-jeffm@suse.com>
References: <1466709966-31506-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

For the pathlogical case, like xfstests generic/297 that creates a
large file consisting of one, repeating reflinked extent, fsck can
take hours.  The root cause is that calling find_data_backref while
iterating the extent records is an O(n^2) algorithm.  For my
example test run, n was 2*2^20 and fsck was at 8 hours and counting.

This patch supplements the list with an rbtree and drops the runtime
of that testcase to about 20 seconds.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 cmds-check.c | 199 ++++++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 149 insertions(+), 50 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index a202a9d..4785f00 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -77,6 +77,7 @@ static struct cache_tree *roots_info_cache = NULL;
 
 struct extent_backref {
 	struct list_head list;
+	struct rb_node node;
 	unsigned int is_data:1;
 	unsigned int found_extent_tree:1;
 	unsigned int full_backref:1;
@@ -90,6 +91,12 @@ to_extent_backref(struct list_head *entry)
 	return list_entry(entry, struct extent_backref, list);
 }
 
+static inline struct extent_backref *
+rb_node_to_extent_backref(struct rb_node *node)
+{
+	return rb_entry(node, struct extent_backref, node);
+}
+
 struct data_backref {
 	struct extent_backref node;
 	union {
@@ -111,6 +118,57 @@ to_data_backref(struct extent_backref *back)
 	return container_of(back, struct data_backref, node);
 }
 
+static int compare_data_backref(struct rb_node *node1,
+				struct rb_node *node2)
+{
+	struct extent_backref *ext1 = rb_node_to_extent_backref(node1);
+	struct extent_backref *ext2 = rb_node_to_extent_backref(node2);
+	struct data_backref *back1 = to_data_backref(ext1);
+	struct data_backref *back2 = to_data_backref(ext2);
+
+	WARN_ON(!ext1->is_data);
+	WARN_ON(!ext2->is_data);
+
+	/* parent and root are a union, so this covers both */
+	if (back1->parent > back2->parent)
+		return 1;
+	if (back1->parent < back2->parent)
+		return -1;
+
+	/* This is a full backref and the parents match. */
+	if (back1->node.full_backref)
+		return 0;
+
+	if (back1->owner > back2->owner)
+		return 1;
+	if (back1->owner < back2->owner)
+		return -1;
+
+	if (back1->offset > back2->offset)
+		return 1;
+	if (back1->offset < back2->offset)
+		return -1;
+
+	if (back1->bytes > back2->bytes)
+		return 1;
+	if (back1->bytes < back2->bytes)
+		return -1;
+
+	if (back1->found_ref && back2->found_ref) {
+		if (back1->disk_bytenr > back2->disk_bytenr)
+			return 1;
+		if (back1->disk_bytenr < back2->disk_bytenr)
+			return -1;
+
+		if (back1->found_ref > back2->found_ref)
+			return 1;
+		if (back1->found_ref < back2->found_ref)
+			return -1;
+	}
+
+	return 0;
+}
+
 /*
  * Much like data_backref, just removed the undetermined members
  * and change it to use list_head.
@@ -140,12 +198,56 @@ to_tree_backref(struct extent_backref *back)
 	return container_of(back, struct tree_backref, node);
 }
 
+static int compare_tree_backref(struct rb_node *node1,
+				struct rb_node *node2)
+{
+	struct extent_backref *ext1 = rb_node_to_extent_backref(node1);
+	struct extent_backref *ext2 = rb_node_to_extent_backref(node2);
+	struct tree_backref *back1 = to_tree_backref(ext1);
+	struct tree_backref *back2 = to_tree_backref(ext2);
+
+	WARN_ON(ext1->is_data);
+	WARN_ON(ext2->is_data);
+
+	/* parent and root are a union, so this covers both */
+	if (back1->parent > back2->parent)
+		return 1;
+	if (back1->parent < back2->parent)
+		return -1;
+
+	return 0;
+}
+
+static int compare_extent_backref(struct rb_node *node1,
+				  struct rb_node *node2)
+{
+	struct extent_backref *ext1 = rb_node_to_extent_backref(node1);
+	struct extent_backref *ext2 = rb_node_to_extent_backref(node2);
+
+	if (ext1->is_data > ext2->is_data)
+		return 1;
+
+	if (ext1->is_data < ext2->is_data)
+		return -1;
+
+	if (ext1->full_backref > ext2->full_backref)
+		return 1;
+	if (ext1->full_backref < ext2->full_backref)
+		return -1;
+
+	if (ext1->is_data)
+		return compare_data_backref(node1, node2);
+	else
+		return compare_tree_backref(node1, node2);
+}
+
 /* Explicit initialization for extent_record::flag_block_full_backref */
 enum { FLAG_UNSET = 2 };
 
 struct extent_record {
 	struct list_head backrefs;
 	struct list_head dups;
+	struct rb_root backref_tree;
 	struct list_head list;
 	struct cache_extent cache;
 	struct btrfs_disk_key parent_key;
@@ -4379,32 +4481,30 @@ static int check_block(struct btrfs_root *root,
 	return ret;
 }
 
+
 static struct tree_backref *find_tree_backref(struct extent_record *rec,
 						u64 parent, u64 root)
 {
-	struct list_head *cur = rec->backrefs.next;
-	struct extent_backref *node;
-	struct tree_backref *back;
+	struct rb_node *node;
+	struct tree_backref *back = NULL;
+	struct tree_backref match = {
+		.node = {
+			.is_data = 0,
+		},
+	};
 
-	while(cur != &rec->backrefs) {
-		node = to_extent_backref(cur);
-		cur = cur->next;
-		if (node->is_data)
-			continue;
-		back = to_tree_backref(node);
-		if (parent > 0) {
-			if (!node->full_backref)
-				continue;
-			if (parent == back->parent)
-				return back;
-		} else {
-			if (node->full_backref)
-				continue;
-			if (back->root == root)
-				return back;
-		}
-	}
-	return NULL;
+	if (parent) {
+		match.parent = parent;
+		match.node.full_backref = 1;
+	} else
+		match.root = root;
+
+	node = rb_search(&rec->backref_tree, &match.node.node,
+			 (rb_compare_keys)compare_extent_backref, NULL);
+	if (node)
+		back = to_tree_backref(rb_node_to_extent_backref(node));
+
+	return back;
 }
 
 static struct tree_backref *alloc_tree_backref(struct extent_record *rec,
@@ -4423,6 +4523,7 @@ static struct tree_backref *alloc_tree_backref(struct extent_record *rec,
 		ref->node.full_backref = 0;
 	}
 	list_add_tail(&ref->node.list, &rec->backrefs);
+	rb_insert(&rec->backref_tree, &ref->node.node, compare_extent_backref);
 
 	return ref;
 }
@@ -4433,35 +4534,31 @@ static struct data_backref *find_data_backref(struct extent_record *rec,
 						int found_ref,
 						u64 disk_bytenr, u64 bytes)
 {
-	struct list_head *cur = rec->backrefs.next;
-	struct extent_backref *node;
-	struct data_backref *back;
+	struct rb_node *node;
+	struct data_backref *back = NULL;
+	struct data_backref match = {
+		.node = {
+			.is_data = 1,
+		},
+		.owner = owner,
+		.offset = offset,
+		.bytes = bytes,
+		.found_ref = found_ref,
+		.disk_bytenr = disk_bytenr,
+	};
 
-	while(cur != &rec->backrefs) {
-		node = to_extent_backref(cur);
-		cur = cur->next;
-		if (!node->is_data)
-			continue;
-		back = to_data_backref(node);
-		if (parent > 0) {
-			if (!node->full_backref)
-				continue;
-			if (parent == back->parent)
-				return back;
-		} else {
-			if (node->full_backref)
-				continue;
-			if (back->root == root && back->owner == owner &&
-			    back->offset == offset) {
-				if (found_ref && node->found_ref &&
-				    (back->bytes != bytes ||
-				    back->disk_bytenr != disk_bytenr))
-					continue;
-				return back;
-			}
-		}
-	}
-	return NULL;
+	if (parent) {
+		match.parent = parent;
+		match.node.full_backref = 1;
+	} else
+		match.root = root;
+
+	node = rb_search(&rec->backref_tree, &match.node.node,
+			 (rb_compare_keys)compare_extent_backref, NULL);
+	if (node)
+		back = to_data_backref(rb_node_to_extent_backref(node));
+
+	return back;
 }
 
 static struct data_backref *alloc_data_backref(struct extent_record *rec,
@@ -4491,6 +4588,7 @@ static struct data_backref *alloc_data_backref(struct extent_record *rec,
 	ref->found_ref = 0;
 	ref->num_refs = 0;
 	list_add_tail(&ref->node.list, &rec->backrefs);
+	rb_insert(&rec->backref_tree, &ref->node.node, compare_extent_backref);
 	if (max_size > rec->max_size)
 		rec->max_size = max_size;
 	return ref;
@@ -4578,6 +4676,7 @@ static int add_extent_rec_nolookup(struct cache_tree *extent_cache,
 	INIT_LIST_HEAD(&rec->backrefs);
 	INIT_LIST_HEAD(&rec->dups);
 	INIT_LIST_HEAD(&rec->list);
+	rec->backref_tree = RB_ROOT;
 	memcpy(&rec->parent_key, &tmpl->parent_key, sizeof(tmpl->parent_key));
 	rec->cache.start = tmpl->start;
 	rec->cache.size = tmpl->nr;
-- 
2.7.1

