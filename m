From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 51/66] btrfs: add_delayed_ref_head should return void
Date: Mon, 24 Oct 2011 21:03:27 -0400
Message-ID: <20111025010856.417533857@suse.com>
References: <20111025010236.322699279@suse.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 add_delayed_ref_head has no error conditions and should return void.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/delayed-ref.c |   29 ++++++++++-------------------
 1 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 125cf76..caa9ade 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -390,10 +390,10 @@ update_existing_head_ref(struct btrfs_delayed_ref_node *existing,
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
@@ -462,7 +462,6 @@ static noinline int add_delayed_ref_head(struct btrfs_trans_handle *trans,
 		delayed_refs->num_entries++;
 		trans->delayed_ref_updates++;
 	}
-	return 0;
 }
 
 /*
@@ -610,10 +609,8 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
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
@@ -655,10 +652,8 @@ int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
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
@@ -672,7 +667,6 @@ int btrfs_add_delayed_extent_op(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_delayed_ref_head *head_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
-	int ret;
 
 	head_ref = kmalloc(sizeof(*head_ref), GFP_NOFS);
 	if (!head_ref)
@@ -683,11 +677,8 @@ int btrfs_add_delayed_extent_op(struct btrfs_trans_handle *trans,
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



