From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs: remove unneeded BUG_ON()
Date: Wed, 22 Jun 2011 14:19:15 +0900
Message-ID: <201106220519.AA00026@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The following functions always return 0.
  - add_delayed_ref_head()
  - add_delayed_tree_ref()
  - add_delayed_data_ref()
  - add_excluded_extent()

Therefore, check by BUG_ON() is unnecessary at the caller of these
functions. 

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/delayed-ref.c |   32 +++++++++++++-------------------
 fs/btrfs/extent-tree.c |   14 ++++----------
 2 files changed, 17 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 125cf76..ce0c728 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -588,7 +588,6 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 	struct btrfs_delayed_tree_ref *ref;
 	struct btrfs_delayed_ref_head *head_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
-	int ret;
 
 	BUG_ON(extent_op && extent_op->is_data);
 	ref = kmalloc(sizeof(*ref), GFP_NOFS);
@@ -610,13 +609,12 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 	 * insert both the head node and the new ref without dropping
 	 * the spin lock
 	 */
-	ret = add_delayed_ref_head(trans, &head_ref->node, bytenr, num_bytes,
-				   action, 0);
-	BUG_ON(ret);
+	add_delayed_ref_head(trans, &head_ref->node, bytenr, num_bytes,
+			     action, 0);
+
+	add_delayed_tree_ref(trans, &ref->node, bytenr, num_bytes,
+			     parent, ref_root, level, action);
 
-	ret = add_delayed_tree_ref(trans, &ref->node, bytenr, num_bytes,
-				   parent, ref_root, level, action);
-	BUG_ON(ret);
 	spin_unlock(&delayed_refs->lock);
 	return 0;
 }
@@ -633,7 +631,6 @@ int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
 	struct btrfs_delayed_data_ref *ref;
 	struct btrfs_delayed_ref_head *head_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
-	int ret;
 
 	BUG_ON(extent_op && !extent_op->is_data);
 	ref = kmalloc(sizeof(*ref), GFP_NOFS);
@@ -655,13 +652,12 @@ int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
 	 * insert both the head node and the new ref without dropping
 	 * the spin lock
 	 */
-	ret = add_delayed_ref_head(trans, &head_ref->node, bytenr, num_bytes,
-				   action, 1);
-	BUG_ON(ret);
+	add_delayed_ref_head(trans, &head_ref->node, bytenr, num_bytes,
+			     action, 1);
+
+	add_delayed_data_ref(trans, &ref->node, bytenr, num_bytes,
+			     parent, ref_root, owner, offset, action);
 
-	ret = add_delayed_data_ref(trans, &ref->node, bytenr, num_bytes,
-				   parent, ref_root, owner, offset, action);
-	BUG_ON(ret);
 	spin_unlock(&delayed_refs->lock);
 	return 0;
 }
@@ -672,7 +668,6 @@ int btrfs_add_delayed_extent_op(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_delayed_ref_head *head_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
-	int ret;
 
 	head_ref = kmalloc(sizeof(*head_ref), GFP_NOFS);
 	if (!head_ref)
@@ -683,10 +678,9 @@ int btrfs_add_delayed_extent_op(struct btrfs_trans_handle *trans,
 	delayed_refs = &trans->transaction->delayed_refs;
 	spin_lock(&delayed_refs->lock);
 
-	ret = add_delayed_ref_head(trans, &head_ref->node, bytenr,
-				   num_bytes, BTRFS_UPDATE_DELAYED_HEAD,
-				   extent_op->is_data);
-	BUG_ON(ret);
+	add_delayed_ref_head(trans, &head_ref->node, bytenr,
+			     num_bytes, BTRFS_UPDATE_DELAYED_HEAD,
+			     extent_op->is_data);
 
 	spin_unlock(&delayed_refs->lock);
 	return 0;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 1f61bf5..15286d1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -225,9 +225,7 @@ static int exclude_super_stripes(struct btrfs_root *root,
 	if (cache->key.objectid < BTRFS_SUPER_INFO_OFFSET) {
 		stripe_len = BTRFS_SUPER_INFO_OFFSET - cache->key.objectid;
 		cache->bytes_super += stripe_len;
-		ret = add_excluded_extent(root, cache->key.objectid,
-					  stripe_len);
-		BUG_ON(ret);
+		add_excluded_extent(root, cache->key.objectid, stripe_len);
 	}
 
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
@@ -239,9 +237,7 @@ static int exclude_super_stripes(struct btrfs_root *root,
 
 		while (nr--) {
 			cache->bytes_super += stripe_len;
-			ret = add_excluded_extent(root, logical[nr],
-						  stripe_len);
-			BUG_ON(ret);
+			add_excluded_extent(root, logical[nr], stripe_len);
 		}
 
 		kfree(logical);
@@ -5581,8 +5577,7 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 		mutex_lock(&caching_ctl->mutex);
 
 		if (start >= caching_ctl->progress) {
-			ret = add_excluded_extent(root, start, num_bytes);
-			BUG_ON(ret);
+			add_excluded_extent(root, start, num_bytes);
 		} else if (start + num_bytes <= caching_ctl->progress) {
 			ret = btrfs_remove_free_space(block_group,
 						      start, num_bytes);
@@ -5596,8 +5591,7 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 			start = caching_ctl->progress;
 			num_bytes = ins->objectid + ins->offset -
 				    caching_ctl->progress;
-			ret = add_excluded_extent(root, start, num_bytes);
-			BUG_ON(ret);
+			add_excluded_extent(root, start, num_bytes);
 		}
 
 		mutex_unlock(&caching_ctl->mutex);


