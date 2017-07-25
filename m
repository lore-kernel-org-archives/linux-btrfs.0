Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44903 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752809AbdGYUvC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Jul 2017 16:51:02 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0371BAEC2
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Jul 2017 20:51:01 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 2/7] btrfs-progs: check: switch to iterating over the backref_tree
Date: Tue, 25 Jul 2017 16:51:33 -0400
Message-Id: <20170725205138.28376-2-jeffm@suse.com>
In-Reply-To: <20170725205138.28376-1-jeffm@suse.com>
References: <20170725205138.28376-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

We now have two data structures that can be used to iterate the same data
set, and there may be quite a few of them in memory.  Eliminating the
list_head member will reduce memory consumption while iterating over
the extent backrefs.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 cmds-check.c | 83 ++++++++++++++++++++++++++----------------------------------
 1 file changed, 36 insertions(+), 47 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 6a04553..b46a686 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -86,7 +86,6 @@ enum btrfs_check_mode {
 static enum btrfs_check_mode check_mode = CHECK_MODE_DEFAULT;
 
 struct extent_backref {
-	struct list_head list;
 	struct rb_node node;
 	unsigned int is_data:1;
 	unsigned int found_extent_tree:1;
@@ -95,11 +94,6 @@ struct extent_backref {
 	unsigned int broken:1;
 };
 
-static inline struct extent_backref* to_extent_backref(struct list_head *entry)
-{
-	return list_entry(entry, struct extent_backref, list);
-}
-
 static inline struct extent_backref* rb_node_to_extent_backref(struct rb_node *node)
 {
 	return rb_entry(node, struct extent_backref, node);
@@ -5452,16 +5446,14 @@ out:
 
 static int all_backpointers_checked(struct extent_record *rec, int print_errs)
 {
-	struct list_head *cur = rec->backrefs.next;
-	struct extent_backref *back;
+	struct extent_backref *back, *tmp;
 	struct tree_backref *tback;
 	struct data_backref *dback;
 	u64 found = 0;
 	int err = 0;
 
-	while(cur != &rec->backrefs) {
-		back = to_extent_backref(cur);
-		cur = cur->next;
+	rbtree_postorder_for_each_entry_safe(back, tmp,
+					     &rec->backref_tree, node) {
 		if (!back->found_extent_tree) {
 			err = 1;
 			if (!print_errs)
@@ -5564,17 +5556,16 @@ out:
 	return err;
 }
 
-static int free_all_extent_backrefs(struct extent_record *rec)
+static void __free_one_backref(struct rb_node *node)
 {
-	struct extent_backref *back;
-	struct list_head *cur;
-	while (!list_empty(&rec->backrefs)) {
-		cur = rec->backrefs.next;
-		back = to_extent_backref(cur);
-		list_del(cur);
-		free(back);
-	}
-	return 0;
+	struct extent_backref *back = rb_node_to_extent_backref(node);
+
+	free(back);
+}
+
+static void free_all_extent_backrefs(struct extent_record *rec)
+{
+	rb_free_nodes(&rec->backref_tree, __free_one_backref);
 }
 
 static void free_extent_record_cache(struct cache_tree *extent_cache)
@@ -5613,7 +5604,7 @@ static int check_owner_ref(struct btrfs_root *root,
 			    struct extent_record *rec,
 			    struct extent_buffer *buf)
 {
-	struct extent_backref *node;
+	struct extent_backref *node, *tmp;
 	struct tree_backref *back;
 	struct btrfs_root *ref_root;
 	struct btrfs_key key;
@@ -5623,7 +5614,8 @@ static int check_owner_ref(struct btrfs_root *root,
 	int found = 0;
 	int ret;
 
-	list_for_each_entry(node, &rec->backrefs, list) {
+	rbtree_postorder_for_each_entry_safe(node, tmp,
+					     &rec->backref_tree, node) {
 		if (node->is_data)
 			continue;
 		if (!node->found_ref)
@@ -5668,14 +5660,12 @@ static int check_owner_ref(struct btrfs_root *root,
 
 static int is_extent_tree_record(struct extent_record *rec)
 {
-	struct list_head *cur = rec->backrefs.next;
-	struct extent_backref *node;
+	struct extent_backref *node, *tmp;
 	struct tree_backref *back;
 	int is_extent = 0;
 
-	while(cur != &rec->backrefs) {
-		node = to_extent_backref(cur);
-		cur = cur->next;
+	rbtree_postorder_for_each_entry_safe(node, tmp,
+					     &rec->backref_tree, node) {
 		if (node->is_data)
 			return 0;
 		back = to_tree_backref(node);
@@ -6085,7 +6075,6 @@ static struct tree_backref *alloc_tree_backref(struct extent_record *rec,
 		ref->root = root;
 		ref->node.full_backref = 0;
 	}
-	list_add_tail(&ref->node.list, &rec->backrefs);
 
 	return ref;
 }
@@ -6155,7 +6144,6 @@ static struct data_backref *alloc_data_backref(struct extent_record *rec,
 	ref->bytes = max_size;
 	ref->found_ref = 0;
 	ref->num_refs = 0;
-	list_add_tail(&ref->node.list, &rec->backrefs);
 	if (max_size > rec->max_size)
 		rec->max_size = max_size;
 	return ref;
@@ -6188,12 +6176,12 @@ static void check_extent_type(struct extent_record *rec)
 	 * Check SYSTEM extent, as it's also marked as metadata, we can only
 	 * make sure it's a SYSTEM extent by its backref
 	 */
-	if (!list_empty(&rec->backrefs)) {
+	if (!RB_EMPTY_ROOT(&rec->backref_tree)) {
 		struct extent_backref *node;
 		struct tree_backref *tback;
 		u64 bg_type;
 
-		node = to_extent_backref(rec->backrefs.next);
+		node = rb_node_to_extent_backref(rb_first(&rec->backref_tree));
 		if (node->is_data) {
 			/* tree block shouldn't have data backref */
 			rec->wrong_chunk_type = 1;
@@ -8191,7 +8179,7 @@ static int free_extent_hook(struct btrfs_trans_handle *trans,
 			back->node.found_extent_tree = 0;
 
 		if (!back->node.found_extent_tree && back->node.found_ref) {
-			list_del(&back->node.list);
+			rb_erase(&back->node.node, &rec->backref_tree);
 			free(back);
 		}
 	} else {
@@ -8210,7 +8198,7 @@ static int free_extent_hook(struct btrfs_trans_handle *trans,
 			back->node.found_extent_tree = 0;
 		}
 		if (!back->node.found_extent_tree && back->node.found_ref) {
-			list_del(&back->node.list);
+			rb_erase(&back->node.node, &rec->backref_tree);
 			free(back);
 		}
 	}
@@ -8651,7 +8639,7 @@ out:
 static int verify_backrefs(struct btrfs_fs_info *info, struct btrfs_path *path,
 			   struct extent_record *rec)
 {
-	struct extent_backref *back;
+	struct extent_backref *back, *tmp;
 	struct data_backref *dback;
 	struct extent_entry *entry, *best = NULL;
 	LIST_HEAD(entries);
@@ -8667,7 +8655,8 @@ static int verify_backrefs(struct btrfs_fs_info *info, struct btrfs_path *path,
 	if (rec->metadata)
 		return 0;
 
-	list_for_each_entry(back, &rec->backrefs, list) {
+	rbtree_postorder_for_each_entry_safe(back, tmp,
+					     &rec->backref_tree, node) {
 		if (back->full_backref || !back->is_data)
 			continue;
 
@@ -8793,7 +8782,8 @@ static int verify_backrefs(struct btrfs_fs_info *info, struct btrfs_path *path,
 	 * Ok great we all agreed on an extent record, let's go find the real
 	 * references and fix up the ones that don't match.
 	 */
-	list_for_each_entry(back, &rec->backrefs, list) {
+	rbtree_postorder_for_each_entry_safe(back, tmp,
+					     &rec->backref_tree, node) {
 		if (back->full_backref || !back->is_data)
 			continue;
 
@@ -9017,7 +9007,7 @@ static int find_possible_backrefs(struct btrfs_fs_info *info,
 				  struct extent_record *rec)
 {
 	struct btrfs_root *root;
-	struct extent_backref *back;
+	struct extent_backref *back, *tmp;
 	struct data_backref *dback;
 	struct cache_extent *cache;
 	struct btrfs_file_extent_item *fi;
@@ -9025,7 +9015,8 @@ static int find_possible_backrefs(struct btrfs_fs_info *info,
 	u64 bytenr, bytes;
 	int ret;
 
-	list_for_each_entry(back, &rec->backrefs, list) {
+	rbtree_postorder_for_each_entry_safe(back, tmp,
+					     &rec->backref_tree, node) {
 		/* Don't care about full backrefs (poor unloved backrefs) */
 		if (back->full_backref || !back->is_data)
 			continue;
@@ -9113,7 +9104,7 @@ static int record_orphan_data_extents(struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_key key;
 	struct btrfs_root *dest_root;
-	struct extent_backref *back;
+	struct extent_backref *back, *tmp;
 	struct data_backref *dback;
 	struct orphan_data_extent *orphan;
 	struct btrfs_path path;
@@ -9123,7 +9114,8 @@ static int record_orphan_data_extents(struct btrfs_fs_info *fs_info,
 	if (rec->metadata)
 		return 1;
 	btrfs_init_path(&path);
-	list_for_each_entry(back, &rec->backrefs, list) {
+	rbtree_postorder_for_each_entry_safe(back, tmp,
+					     &rec->backref_tree, node) {
 		if (back->full_backref || !back->is_data ||
 		    !back->found_extent_tree)
 			continue;
@@ -9191,9 +9183,8 @@ static int fixup_extent_refs(struct btrfs_fs_info *info,
 	struct btrfs_trans_handle *trans = NULL;
 	int ret;
 	struct btrfs_path path;
-	struct list_head *cur = rec->backrefs.next;
 	struct cache_extent *cache;
-	struct extent_backref *back;
+	struct extent_backref *back, *tmp;
 	int allocated = 0;
 	u64 flags = 0;
 
@@ -9241,10 +9232,8 @@ static int fixup_extent_refs(struct btrfs_fs_info *info,
 	}
 
 	/* step three, recreate all the refs we did find */
-	while(cur != &rec->backrefs) {
-		back = to_extent_backref(cur);
-		cur = cur->next;
-
+	rbtree_postorder_for_each_entry_safe(back, tmp,
+					     &rec->backref_tree, node) {
 		/*
 		 * if we didn't find any references, don't create a
 		 * new extent record
-- 
2.11.0

