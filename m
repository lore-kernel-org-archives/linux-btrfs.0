From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 73/99] btrfs: add_delayed_data_ref should return void
Date: Wed, 23 Nov 2011 19:36:46 -0500
Message-ID: <20111124004228.267368419@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 add_delayed_data_ref has no error conditions and should return void.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/delayed-ref.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 3ae2401..b004960 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -520,11 +520,11 @@ static noinline void add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 /*
  * helper to insert a delayed data ref into the rbtree.
  */
-static noinline int add_delayed_data_ref(struct btrfs_trans_handle *trans,
-					 struct btrfs_delayed_ref_node *ref,
-					 u64 bytenr, u64 num_bytes, u64 parent,
-					 u64 ref_root, u64 owner, u64 offset,
-					 int action)
+static noinline void add_delayed_data_ref(struct btrfs_trans_handle *trans,
+					  struct btrfs_delayed_ref_node *ref,
+					  u64 bytenr, u64 num_bytes, u64 parent,
+					  u64 ref_root, u64 owner, u64 offset,
+					  int action)
 {
 	struct btrfs_delayed_ref_node *existing;
 	struct btrfs_delayed_data_ref *full_ref;
@@ -570,7 +570,6 @@ static noinline int add_delayed_data_ref(struct btrfs_trans_handle *trans,
 		delayed_refs->num_entries++;
 		trans->delayed_ref_updates++;
 	}
-	return 0;
 }
 
 /*
@@ -627,7 +626,6 @@ int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
 	struct btrfs_delayed_data_ref *ref;
 	struct btrfs_delayed_ref_head *head_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
-	int ret;
 
 	BUG_ON(extent_op && !extent_op->is_data);
 	ref = kmalloc(sizeof(*ref), GFP_NOFS);
@@ -651,9 +649,8 @@ int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
 	 */
 	add_delayed_ref_head(trans, &head_ref->node, bytenr, num_bytes,
 			     action, 1);
-	ret = add_delayed_data_ref(trans, &ref->node, bytenr, num_bytes,
-				   parent, ref_root, owner, offset, action);
-	BUG_ON(ret);
+	add_delayed_data_ref(trans, &ref->node, bytenr, num_bytes, parent,
+			     ref_root, owner, offset, action);
 	spin_unlock(&delayed_refs->lock);
 	return 0;
 }



