From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH v2 07/10] Btrfs: put back delayed refs that are too new
Date: Wed,  4 Jan 2012 18:35:45 +0100
Message-ID: <d1270cd91f308c9d22b2804720c36ccd32dbc35e.1325692561.git.list.btrfs@jan-o-sch.net>
References: <cover.1325692560.git.list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1325692560.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1325692560.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

From: Arne Jansen <sensille@gmx.net>

When processing a delayed ref, first check if there are still old refs in
the process of being added. If so, put this ref back to the tree. To avoid
looping on this ref, choose a newer one in the next loop.
btrfs_find_ref_cluster has to take care of that.

Signed-off-by: Arne Jansen <sensille@gmx.net>
Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/delayed-ref.c |   43 +++++++++++++++++++++++++------------------
 fs/btrfs/extent-tree.c |   27 ++++++++++++++++++++++-----
 2 files changed, 47 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index a405db0..ee18198 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -155,16 +155,22 @@ static struct btrfs_delayed_ref_node *tree_insert(struct rb_root *root,
 
 /*
  * find an head entry based on bytenr. This returns the delayed ref
- * head if it was able to find one, or NULL if nothing was in that spot
+ * head if it was able to find one, or NULL if nothing was in that spot.
+ * If return_bigger is given, the next bigger entry is returned if no exact
+ * match is found.
  */
 static struct btrfs_delayed_ref_node *find_ref_head(struct rb_root *root,
 				  u64 bytenr,
-				  struct btrfs_delayed_ref_node **last)
+				  struct btrfs_delayed_ref_node **last,
+				  int return_bigger)
 {
-	struct rb_node *n = root->rb_node;
+	struct rb_node *n;
 	struct btrfs_delayed_ref_node *entry;
-	int cmp;
+	int cmp = 0;
 
+again:
+	n = root->rb_node;
+	entry = NULL;
 	while (n) {
 		entry = rb_entry(n, struct btrfs_delayed_ref_node, rb_node);
 		WARN_ON(!entry->in_tree);
@@ -187,6 +193,19 @@ static struct btrfs_delayed_ref_node *find_ref_head(struct rb_root *root,
 		else
 			return entry;
 	}
+	if (entry && return_bigger) {
+		if (cmp > 0) {
+			n = rb_next(&entry->rb_node);
+			if (!n)
+				n = rb_first(root);
+			entry = rb_entry(n, struct btrfs_delayed_ref_node,
+					 rb_node);
+			bytenr = entry->bytenr;
+			return_bigger = 0;
+			goto again;
+		}
+		return entry;
+	}
 	return NULL;
 }
 
@@ -246,20 +265,8 @@ int btrfs_find_ref_cluster(struct btrfs_trans_handle *trans,
 		node = rb_first(&delayed_refs->root);
 	} else {
 		ref = NULL;
-		find_ref_head(&delayed_refs->root, start, &ref);
+		find_ref_head(&delayed_refs->root, start + 1, &ref, 1);
 		if (ref) {
-			struct btrfs_delayed_ref_node *tmp;
-
-			node = rb_prev(&ref->rb_node);
-			while (node) {
-				tmp = rb_entry(node,
-					       struct btrfs_delayed_ref_node,
-					       rb_node);
-				if (tmp->bytenr < start)
-					break;
-				ref = tmp;
-				node = rb_prev(&ref->rb_node);
-			}
 			node = &ref->rb_node;
 		} else
 			node = rb_first(&delayed_refs->root);
@@ -748,7 +755,7 @@ btrfs_find_delayed_ref_head(struct btrfs_trans_handle *trans, u64 bytenr)
 	struct btrfs_delayed_ref_root *delayed_refs;
 
 	delayed_refs = &trans->transaction->delayed_refs;
-	ref = find_ref_head(&delayed_refs->root, bytenr, NULL);
+	ref = find_ref_head(&delayed_refs->root, bytenr, NULL, 0);
 	if (ref)
 		return btrfs_delayed_node_to_head(ref);
 	return NULL;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index dc8b9a8..bbcca12 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2237,6 +2237,28 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
 		}
 
 		/*
+		 * locked_ref is the head node, so we have to go one
+		 * node back for any delayed ref updates
+		 */
+		ref = select_delayed_ref(locked_ref);
+
+		if (ref && ref->seq &&
+		    btrfs_check_delayed_seq(delayed_refs, ref->seq)) {
+			/*
+			 * there are still refs with lower seq numbers in the
+			 * process of being added. Don't run this ref yet.
+			 */
+			list_del_init(&locked_ref->cluster);
+			mutex_unlock(&locked_ref->mutex);
+			locked_ref = NULL;
+			delayed_refs->num_heads_ready++;
+			spin_unlock(&delayed_refs->lock);
+			cond_resched();
+			spin_lock(&delayed_refs->lock);
+			continue;
+		}
+
+		/*
 		 * record the must insert reserved flag before we
 		 * drop the spin lock.
 		 */
@@ -2246,11 +2268,6 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
 		extent_op = locked_ref->extent_op;
 		locked_ref->extent_op = NULL;
 
-		/*
-		 * locked_ref is the head node, so we have to go one
-		 * node back for any delayed ref updates
-		 */
-		ref = select_delayed_ref(locked_ref);
 		if (!ref) {
 			/* All delayed refs have been processed, Go ahead
 			 * and send the head node to run_one_delayed_ref,
-- 
1.7.3.4

