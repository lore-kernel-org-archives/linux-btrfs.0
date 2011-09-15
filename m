From: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 16/20] btrfs: make add_delayed_ref_head() void
Date: Thu, 15 Sep 2011 10:34:55 -0700
Message-ID: <1316108099-5099-17-git-send-email-mfasheh@suse.de>
References: <1316108099-5099-1-git-send-email-mfasheh@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>,
	Mark Fasheh <mfasheh@suse.de>, Mark Fasheh <mfasheh@suse.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1316108099-5099-1-git-send-email-mfasheh@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

From: Mark Fasheh <mfasheh@suse.com>

This is trivial as the function always returns success. We can remove 3
BUG_ON(ret) lines as a result.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/btrfs/delayed-ref.c |   26 ++++++++++----------------
 1 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 125cf76..b5c3d7c 100644
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
+					  struct btrfs_delayed_ref_node *ref,
+					  u64 bytenr, u64 num_bytes,
+					  int action, int is_data)
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
@@ -610,9 +609,8 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 	 * insert both the head node and the new ref without dropping
 	 * the spin lock
 	 */
-	ret = add_delayed_ref_head(trans, &head_ref->node, bytenr, num_bytes,
-				   action, 0);
-	BUG_ON(ret);
+	add_delayed_ref_head(trans, &head_ref->node, bytenr, num_bytes, action,
+			     0);
 
 	ret = add_delayed_tree_ref(trans, &ref->node, bytenr, num_bytes,
 				   parent, ref_root, level, action);
@@ -655,9 +653,8 @@ int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
 	 * insert both the head node and the new ref without dropping
 	 * the spin lock
 	 */
-	ret = add_delayed_ref_head(trans, &head_ref->node, bytenr, num_bytes,
-				   action, 1);
-	BUG_ON(ret);
+	add_delayed_ref_head(trans, &head_ref->node, bytenr, num_bytes,
+			     action, 1);
 
 	ret = add_delayed_data_ref(trans, &ref->node, bytenr, num_bytes,
 				   parent, ref_root, owner, offset, action);
@@ -672,7 +669,6 @@ int btrfs_add_delayed_extent_op(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_delayed_ref_head *head_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
-	int ret;
 
 	head_ref = kmalloc(sizeof(*head_ref), GFP_NOFS);
 	if (!head_ref)
@@ -683,10 +679,8 @@ int btrfs_add_delayed_extent_op(struct btrfs_trans_handle *trans,
 	delayed_refs = &trans->transaction->delayed_refs;
 	spin_lock(&delayed_refs->lock);
 
-	ret = add_delayed_ref_head(trans, &head_ref->node, bytenr,
-				   num_bytes, BTRFS_UPDATE_DELAYED_HEAD,
-				   extent_op->is_data);
-	BUG_ON(ret);
+	add_delayed_ref_head(trans, &head_ref->node, bytenr, num_bytes,
+			     BTRFS_UPDATE_DELAYED_HEAD, extent_op->is_data);
 
 	spin_unlock(&delayed_refs->lock);
 	return 0;
-- 
1.7.6

