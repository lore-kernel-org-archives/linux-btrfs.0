From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 50/65] btrfs: add_delayed_ref_head should return void
Date: Mon, 03 Oct 2011 23:23:20 -0400
Message-ID: <20111004032305.646306087@suse.com>
References: <20111004032230.458853274@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: BtrFS List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 add_delayed_ref_head has no error conditions and should return void.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/delayed-ref.c |   29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -390,10 +390,10 @@ update_existing_head_ref(struct btrfs_de
  * this does all the dirty work in terms of maintaining the correct
  * overall modification count.
  */
-static noinline int add_delayed_ref_head(struct btrfs_trans_handle *trans,
-					struct btrfs_delayed_ref_node *ref,
-					u64 bytenr, u64 num_bytes,
-					int action, int is_data)
+static noinline void add_delayed_ref_head(struct btrfs_trans_handle *trans,
+					 struct btrfs_delayed_ref_node *ref,
+					 u64 bytenr, u64 num_bytes,
+					 int action, int is_data)
 {
 	struct btrfs_delayed_ref_node *existing;
 	struct btrfs_delayed_ref_head *head_ref = NULL;
@@ -462,7 +462,6 @@ static noinline int add_delayed_ref_head
 		delayed_refs->num_entries++;
 		trans->delayed_ref_updates++;
 	}
-	return 0;
 }
 
 /*
@@ -610,10 +609,8 @@ int btrfs_add_delayed_tree_ref(struct bt
 	 * insert both the head node and the new ref without dropping
 	 * the spin lock
 	 */
-	ret = add_delayed_ref_head(trans, &head_ref->node, bytenr, num_bytes,
-				   action, 0);
-	BUG_ON(ret);
-
+	add_delayed_ref_head(trans, &head_ref->node, bytenr, num_bytes,
+			     action, 0);
 	ret = add_delayed_tree_ref(trans, &ref->node, bytenr, num_bytes,
 				   parent, ref_root, level, action);
 	BUG_ON(ret);
@@ -655,10 +652,8 @@ int btrfs_add_delayed_data_ref(struct bt
 	 * insert both the head node and the new ref without dropping
 	 * the spin lock
 	 */
-	ret = add_delayed_ref_head(trans, &head_ref->node, bytenr, num_bytes,
-				   action, 1);
-	BUG_ON(ret);
-
+	add_delayed_ref_head(trans, &head_ref->node, bytenr, num_bytes,
+			     action, 1);
 	ret = add_delayed_data_ref(trans, &ref->node, bytenr, num_bytes,
 				   parent, ref_root, owner, offset, action);
 	BUG_ON(ret);
@@ -672,7 +667,6 @@ int btrfs_add_delayed_extent_op(struct b
 {
 	struct btrfs_delayed_ref_head *head_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
-	int ret;
 
 	head_ref = kmalloc(sizeof(*head_ref), GFP_NOFS);
 	if (!head_ref)
@@ -683,11 +677,8 @@ int btrfs_add_delayed_extent_op(struct b
 	delayed_refs = &trans->transaction->delayed_refs;
 	spin_lock(&delayed_refs->lock);
 
-	ret = add_delayed_ref_head(trans, &head_ref->node, bytenr,
-				   num_bytes, BTRFS_UPDATE_DELAYED_HEAD,
-				   extent_op->is_data);
-	BUG_ON(ret);
-
+	add_delayed_ref_head(trans, &head_ref->node, bytenr, num_bytes,
+			     BTRFS_UPDATE_DELAYED_HEAD, extent_op->is_data);
 	spin_unlock(&delayed_refs->lock);
 	return 0;
 }



