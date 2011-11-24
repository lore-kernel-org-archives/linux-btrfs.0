From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 72/99] btrfs: add_delayed_tree_ref should return void
Date: Wed, 23 Nov 2011 19:36:45 -0500
Message-ID: <20111124004228.151628388@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 add_delayed_tree_ref has no error conditions and should return void.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/delayed-ref.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index caa9ade..3ae2401 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -467,10 +467,10 @@ static noinline void add_delayed_ref_head(struct btrfs_trans_handle *trans,
 /*
  * helper to insert a delayed tree ref into the rbtree.
  */
-static noinline int add_delayed_tree_ref(struct btrfs_trans_handle *trans,
-					 struct btrfs_delayed_ref_node *ref,
-					 u64 bytenr, u64 num_bytes, u64 parent,
-					 u64 ref_root, int level, int action)
+static noinline void add_delayed_tree_ref(struct btrfs_trans_handle *trans,
+					  struct btrfs_delayed_ref_node *ref,
+					  u64 bytenr, u64 num_bytes, u64 parent,
+					  u64 ref_root, int level, int action)
 {
 	struct btrfs_delayed_ref_node *existing;
 	struct btrfs_delayed_tree_ref *full_ref;
@@ -515,7 +515,6 @@ static noinline int add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 		delayed_refs->num_entries++;
 		trans->delayed_ref_updates++;
 	}
-	return 0;
 }
 
 /*
@@ -587,7 +586,6 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 	struct btrfs_delayed_tree_ref *ref;
 	struct btrfs_delayed_ref_head *head_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
-	int ret;
 
 	BUG_ON(extent_op && extent_op->is_data);
 	ref = kmalloc(sizeof(*ref), GFP_NOFS);
@@ -611,9 +609,8 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 	 */
 	add_delayed_ref_head(trans, &head_ref->node, bytenr, num_bytes,
 			     action, 0);
-	ret = add_delayed_tree_ref(trans, &ref->node, bytenr, num_bytes,
-				   parent, ref_root, level, action);
-	BUG_ON(ret);
+	add_delayed_tree_ref(trans, &ref->node, bytenr, num_bytes, parent,
+			     ref_root, level, action);
 	spin_unlock(&delayed_refs->lock);
 	return 0;
 }



