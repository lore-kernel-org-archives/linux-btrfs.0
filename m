From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] Process delayed back reference insertion before deletion
Date: Mon, 23 Feb 2009 22:11:31 +0800
Message-ID: <49A2AE93.2020009@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

hello,

This patch makes btrfs_run_delayed_refs processes delayed back
reference insertion before deletion. This prevents the reference
count in BTRFS_EXTENT_ITEM going down to zero when there still
are pending delayed back references. This patch fixes the issue
that BTRFS_EXTENT_ITEM with zero reference count left in the
extent tree. Thank you,

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/extent-tree.c 2/fs/btrfs/extent-tree.c
--- 1/fs/btrfs/extent-tree.c	2009-02-23 09:02:35.763717851 +0800
+++ 2/fs/btrfs/extent-tree.c	2009-02-23 21:20:08.000000000 +0800
@@ -1533,6 +1533,37 @@ static noinline int run_one_delayed_ref(
 	return 0;
 }
 
+static noinline struct btrfs_delayed_ref_node *
+select_delayed_ref(struct btrfs_delayed_ref_head *head)
+{
+	struct rb_node *node;
+	struct btrfs_delayed_ref_node *ref;
+	int action = BTRFS_ADD_DELAYED_REF;
+again:
+	/*
+	 * select delayed ref of type BTRFS_ADD_DELAYED_REF first.
+	 * this prevents ref count from going down to zero when
+	 * there still are pending delayed ref.
+	 */
+	node = rb_prev(&head->node.rb_node);
+	while (1) {
+		if (!node)
+			break;
+		ref = rb_entry(node, struct btrfs_delayed_ref_node,
+				rb_node);
+		if (ref->bytenr != head->node.bytenr)
+			break;
+		if (btrfs_delayed_node_to_ref(ref)->action == action)
+			return ref;
+		node = rb_prev(node);
+	}
+	if (action == BTRFS_ADD_DELAYED_REF) {
+		action = BTRFS_DROP_DELAYED_REF;
+		goto again;
+	}
+	return NULL;
+}
+
 /*
  * this starts processing the delayed reference count updates and
  * extent insertions we have queued up so far.  count can be
@@ -1592,23 +1623,13 @@ again:
 		 * locked_ref is the head node, so we have to go one
 		 * node back for any delayed ref updates
 		 */
-		node = rb_prev(&locked_ref->node.rb_node);
-		if (node) {
-			ref = rb_entry(node, struct btrfs_delayed_ref_node,
-				       rb_node);
-			/* if the byte numbers don't match, there are
-			 * no updates for this head node.  Go ahead
-			 * and send the head node to run_one_delayed_ref
+
+		ref = select_delayed_ref(locked_ref);
+		if (!ref) {
+			/* All delayed refs have been processed, Go ahead
+			 * and send the head node to run_one_delayed_ref,
 			 * so that any accounting fixes can happen
 			 */
-			if (ref->bytenr != locked_ref->node.bytenr) {
-				ref = &locked_ref->node;
-				locked_ref = NULL;
-			}
-		} else {
-			/* there is no previous node at  all, just
-			 * process the head ref
-			 */
 			ref = &locked_ref->node;
 			locked_ref = NULL;
 		}
@@ -2996,7 +3017,6 @@ static int __free_extent(struct btrfs_tr
 	int extent_slot = 0;
 	int found_extent = 0;
 	int num_to_del = 1;
-	int cache_pending;
 	struct btrfs_extent_item *ei;
 	u32 refs;
 
@@ -3065,14 +3085,13 @@ static int __free_extent(struct btrfs_tr
 	 * we're not allowed to delete the extent item if there
 	 * are other delayed ref updates pending
 	 */
-	cache_pending = btrfs_delayed_ref_pending(trans, bytenr);
 
 	BUG_ON(refs < refs_to_drop);
 	refs -= refs_to_drop;
 	btrfs_set_extent_refs(leaf, ei, refs);
 	btrfs_mark_buffer_dirty(leaf);
 
-	if (!cache_pending && refs == 0 && found_extent &&
+	if (refs == 0 && found_extent &&
 	    path->slots[0] == extent_slot + 1) {
 		struct btrfs_extent_ref *ref;
 		ref = btrfs_item_ptr(leaf, path->slots[0],
@@ -3089,7 +3108,7 @@ static int __free_extent(struct btrfs_tr
 					    refs_to_drop);
 		BUG_ON(ret);
 		/* if refs are 0, we need to setup the path for deletion */
-		if (refs == 0 && !cache_pending) {
+		if (refs == 0) {
 			btrfs_release_path(extent_root, path);
 			ret = btrfs_search_slot(trans, extent_root, &key, path,
 						-1, 1);
@@ -3097,7 +3116,7 @@ static int __free_extent(struct btrfs_tr
 		}
 	}
 
-	if (!cache_pending && refs == 0) {
+	if (refs == 0) {
 		u64 super_used;
 		u64 root_used;
 
