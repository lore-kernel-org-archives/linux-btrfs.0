Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44894 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752676AbdGYUvB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Jul 2017 16:51:01 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 17E19AEC0
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Jul 2017 20:51:00 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 1/7] btrfs-progs: check: supplement extent backref list with rbtree
Date: Tue, 25 Jul 2017 16:51:32 -0400
Message-Id: <20170725205138.28376-1-jeffm@suse.com>
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

A previous version of this patch introduced a regression that would
have corrupted file systems during repair.  It was traced to the
compare algorithm honoring ->bytes regardless of whether the
reference had been found and a failure to reinsert nodes after
the target reference was found.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 cmds-check.c | 184 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 180 insertions(+), 4 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 23adc03..6a04553 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -87,6 +87,7 @@ static enum btrfs_check_mode check_mode = CHECK_MODE_DEFAULT;
 
 struct extent_backref {
 	struct list_head list;
+	struct rb_node node;
 	unsigned int is_data:1;
 	unsigned int found_extent_tree:1;
 	unsigned int full_backref:1;
@@ -99,6 +100,11 @@ static inline struct extent_backref* to_extent_backref(struct list_head *entry)
 	return list_entry(entry, struct extent_backref, list);
 }
 
+static inline struct extent_backref* rb_node_to_extent_backref(struct rb_node *node)
+{
+	return rb_entry(node, struct extent_backref, node);
+}
+
 struct data_backref {
 	struct extent_backref node;
 	union {
@@ -137,6 +143,51 @@ static inline struct data_backref* to_data_backref(struct extent_backref *back)
 	return container_of(back, struct data_backref, node);
 }
 
+static int compare_data_backref(struct rb_node *node1, struct rb_node *node2)
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
+	if (back1->found_ref && back2->found_ref) {
+		if (back1->disk_bytenr > back2->disk_bytenr)
+			return 1;
+		if (back1->disk_bytenr < back2->disk_bytenr)
+			return -1;
+
+		if (back1->bytes > back2->bytes)
+			return 1;
+		if (back1->bytes < back2->bytes)
+			return -1;
+	}
+
+	return 0;
+}
+
 /*
  * Much like data_backref, just removed the undetermined members
  * and change it to use list_head.
@@ -165,12 +216,54 @@ static inline struct tree_backref* to_tree_backref(struct extent_backref *back)
 	return container_of(back, struct tree_backref, node);
 }
 
+static int compare_tree_backref(struct rb_node *node1, struct rb_node *node2)
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
+static int compare_extent_backref(struct rb_node *node1, struct rb_node *node2)
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
@@ -5051,6 +5144,65 @@ out:
 	return ret;
 }
 
+static struct tree_backref *find_tree_backref(struct extent_record *rec,
+						u64 parent, u64 root)
+{
+	struct rb_node *node;
+	struct tree_backref *back = NULL;
+	struct tree_backref match = {
+		.node = {
+			.is_data = 0,
+		},
+	};
+
+	if (parent) {
+		match.parent = parent;
+		match.node.full_backref = 1;
+	} else {
+		match.root = root;
+	}
+
+	node = rb_search(&rec->backref_tree, &match.node.node,
+			 (rb_compare_keys)compare_extent_backref, NULL);
+	if (node)
+		back = to_tree_backref(rb_node_to_extent_backref(node));
+
+	return back;
+}
+
+static struct data_backref *find_data_backref(struct extent_record *rec,
+						u64 parent, u64 root,
+						u64 owner, u64 offset,
+						int found_ref,
+						u64 disk_bytenr, u64 bytes)
+{
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
+
+	if (parent) {
+		match.parent = parent;
+		match.node.full_backref = 1;
+	} else {
+		match.root = root;
+	}
+
+	node = rb_search(&rec->backref_tree, &match.node.node,
+			 (rb_compare_keys)compare_extent_backref, NULL);
+	if (node)
+		back = to_data_backref(rb_node_to_extent_backref(node));
+
+	return back;
+}
 /*
  * Iterate all item on the tree and call check_inode_item() to check.
  *
@@ -5316,7 +5468,7 @@ static int all_backpointers_checked(struct extent_record *rec, int print_errs)
 				goto out;
 			if (back->is_data) {
 				dback = to_data_backref(back);
-				fprintf(stderr, "Backref %llu %s %llu"
+				fprintf(stderr, "Data backref %llu %s %llu"
 					" owner %llu offset %llu num_refs %lu"
 					" not found in extent tree\n",
 					(unsigned long long)rec->start,
@@ -5330,7 +5482,7 @@ static int all_backpointers_checked(struct extent_record *rec, int print_errs)
 					(unsigned long)dback->num_refs);
 			} else {
 				tback = to_tree_backref(back);
-				fprintf(stderr, "Backref %llu parent %llu"
+				fprintf(stderr, "Tree backref %llu parent %llu"
 					" root %llu not found in extent tree\n",
 					(unsigned long long)rec->start,
 					(unsigned long long)tback->parent,
@@ -5888,6 +6040,7 @@ static int check_block(struct btrfs_root *root,
 	return ret;
 }
 
+#if 0
 static struct tree_backref *find_tree_backref(struct extent_record *rec,
 						u64 parent, u64 root)
 {
@@ -5915,6 +6068,7 @@ static struct tree_backref *find_tree_backref(struct extent_record *rec,
 	}
 	return NULL;
 }
+#endif
 
 static struct tree_backref *alloc_tree_backref(struct extent_record *rec,
 						u64 parent, u64 root)
@@ -5936,6 +6090,7 @@ static struct tree_backref *alloc_tree_backref(struct extent_record *rec,
 	return ref;
 }
 
+#if 0
 static struct data_backref *find_data_backref(struct extent_record *rec,
 						u64 parent, u64 root,
 						u64 owner, u64 offset,
@@ -5972,6 +6127,7 @@ static struct data_backref *find_data_backref(struct extent_record *rec,
 	}
 	return NULL;
 }
+#endif
 
 static struct data_backref *alloc_data_backref(struct extent_record *rec,
 						u64 parent, u64 root,
@@ -6088,6 +6244,7 @@ static int add_extent_rec_nolookup(struct cache_tree *extent_cache,
 	INIT_LIST_HEAD(&rec->backrefs);
 	INIT_LIST_HEAD(&rec->dups);
 	INIT_LIST_HEAD(&rec->list);
+	rec->backref_tree = RB_ROOT;
 	memcpy(&rec->parent_key, &tmpl->parent_key, sizeof(tmpl->parent_key));
 	rec->cache.start = tmpl->start;
 	rec->cache.size = tmpl->nr;
@@ -6220,6 +6377,7 @@ static int add_tree_backref(struct cache_tree *extent_cache, u64 bytenr,
 	struct tree_backref *back;
 	struct cache_extent *cache;
 	int ret;
+	int insert = false;
 
 	cache = lookup_cache_extent(extent_cache, bytenr, 1);
 	if (!cache) {
@@ -6254,6 +6412,7 @@ static int add_tree_backref(struct cache_tree *extent_cache, u64 bytenr,
 		back = alloc_tree_backref(rec, parent, root);
 		if (!back)
 			return -ENOMEM;
+		insert = true;
 	}
 
 	if (found_ref) {
@@ -6275,6 +6434,9 @@ static int add_tree_backref(struct cache_tree *extent_cache, u64 bytenr,
 		}
 		back->node.found_extent_tree = 1;
 	}
+	if (insert)
+		WARN_ON(rb_insert(&rec->backref_tree, &back->node.node,
+			compare_extent_backref));
 	check_extent_type(rec);
 	maybe_free_extent_rec(extent_cache, rec);
 	return 0;
@@ -6288,6 +6450,7 @@ static int add_data_backref(struct cache_tree *extent_cache, u64 bytenr,
 	struct data_backref *back;
 	struct cache_extent *cache;
 	int ret;
+	int insert = false;
 
 	cache = lookup_cache_extent(extent_cache, bytenr, 1);
 	if (!cache) {
@@ -6327,6 +6490,7 @@ static int add_data_backref(struct cache_tree *extent_cache, u64 bytenr,
 		back = alloc_data_backref(rec, parent, root, owner, offset,
 					  max_size);
 		BUG_ON(!back);
+		insert = true;
 	}
 
 	if (found_ref) {
@@ -6335,8 +6499,16 @@ static int add_data_backref(struct cache_tree *extent_cache, u64 bytenr,
 			BUG_ON(back->bytes != max_size);
 		back->node.found_ref = 1;
 		back->found_ref += 1;
-		back->bytes = max_size;
-		back->disk_bytenr = bytenr;
+		if (back->bytes != max_size || back->disk_bytenr != bytenr) {
+			back->bytes = max_size;
+			back->disk_bytenr = bytenr;
+
+			/* Need to reinsert if not already in the tree */
+			if (!insert) {
+				rb_erase(&back->node.node, &rec->backref_tree);
+				insert = true;
+			}
+		}
 		rec->refs += 1;
 		rec->content_checked = 1;
 		rec->owner_ref_checked = 1;
@@ -6355,6 +6527,10 @@ static int add_data_backref(struct cache_tree *extent_cache, u64 bytenr,
 		back->num_refs = num_refs;
 		back->node.found_extent_tree = 1;
 	}
+	if (insert)
+		WARN_ON(rb_insert(&rec->backref_tree, &back->node.node,
+			compare_extent_backref));
+
 	maybe_free_extent_rec(extent_cache, rec);
 	return 0;
 }
-- 
2.11.0

