Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31727 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031401AbbD2CbV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Apr 2015 22:31:21 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t3T2U3DY018306
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2015 10:30:03 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 02/18] btrfs: delayed-ref: Use list to replace the ref_root in ref_head.
Date: Wed, 29 Apr 2015 10:28:55 +0800
Message-ID: <1430274551-9277-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1430274551-9277-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1430274551-9277-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch replace the rbtree used in ref_head to list.
This has the following advantage:
1) Easier merge logic.
With the new list implement, we only need to care merging the tail
ref_node with the new ref_node.
And this can be done quite easy at insert time, no need to do a
indicated merge at run_delayed_refs().

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  None
---
 fs/btrfs/backref.c     |   9 +--
 fs/btrfs/delayed-ref.c | 156 ++++++++++++++++++++++++++-----------------------
 fs/btrfs/delayed-ref.h |  18 +++++-
 fs/btrfs/disk-io.c     |   8 +--
 fs/btrfs/extent-tree.c |  46 +++------------
 5 files changed, 114 insertions(+), 123 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 7f14275..a4c31dc 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -572,8 +572,8 @@ static int __add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
 			      struct list_head *prefs, u64 *total_refs,
 			      u64 inum)
 {
+	struct btrfs_delayed_ref_node *node;
 	struct btrfs_delayed_extent_op *extent_op = head->extent_op;
-	struct rb_node *n = &head->node.rb_node;
 	struct btrfs_key key;
 	struct btrfs_key op_key = {0};
 	int sgn;
@@ -583,12 +583,7 @@ static int __add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
 		btrfs_disk_key_to_cpu(&op_key, &extent_op->key);
 
 	spin_lock(&head->lock);
-	n = rb_first(&head->ref_root);
-	while (n) {
-		struct btrfs_delayed_ref_node *node;
-		node = rb_entry(n, struct btrfs_delayed_ref_node,
-				rb_node);
-		n = rb_next(n);
+	list_for_each_entry(node, &head->ref_list, list) {
 		if (node->seq > seq)
 			continue;
 
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 6d16bea..f5f706f 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -268,7 +268,7 @@ static inline void drop_delayed_ref(struct btrfs_trans_handle *trans,
 		rb_erase(&head->href_node, &delayed_refs->href_root);
 	} else {
 		assert_spin_locked(&head->lock);
-		rb_erase(&ref->rb_node, &head->ref_root);
+		list_del(&ref->list);
 	}
 	ref->in_tree = 0;
 	btrfs_put_delayed_ref(ref);
@@ -328,48 +328,6 @@ static int merge_ref(struct btrfs_trans_handle *trans,
 	return done;
 }
 
-void btrfs_merge_delayed_refs(struct btrfs_trans_handle *trans,
-			      struct btrfs_fs_info *fs_info,
-			      struct btrfs_delayed_ref_root *delayed_refs,
-			      struct btrfs_delayed_ref_head *head)
-{
-	struct rb_node *node;
-	u64 seq = 0;
-
-	assert_spin_locked(&head->lock);
-	/*
-	 * We don't have too much refs to merge in the case of delayed data
-	 * refs.
-	 */
-	if (head->is_data)
-		return;
-
-	spin_lock(&fs_info->tree_mod_seq_lock);
-	if (!list_empty(&fs_info->tree_mod_seq_list)) {
-		struct seq_list *elem;
-
-		elem = list_first_entry(&fs_info->tree_mod_seq_list,
-					struct seq_list, list);
-		seq = elem->seq;
-	}
-	spin_unlock(&fs_info->tree_mod_seq_lock);
-
-	node = rb_first(&head->ref_root);
-	while (node) {
-		struct btrfs_delayed_ref_node *ref;
-
-		ref = rb_entry(node, struct btrfs_delayed_ref_node,
-			       rb_node);
-		/* We can't merge refs that are outside of our seq count */
-		if (seq && ref->seq >= seq)
-			break;
-		if (merge_ref(trans, delayed_refs, head, ref, seq))
-			node = rb_first(&head->ref_root);
-		else
-			node = rb_next(&ref->rb_node);
-	}
-}
-
 int btrfs_check_delayed_seq(struct btrfs_fs_info *fs_info,
 			    struct btrfs_delayed_ref_root *delayed_refs,
 			    u64 seq)
@@ -485,6 +443,74 @@ update_existing_ref(struct btrfs_trans_handle *trans,
 }
 
 /*
+ * Helper to insert the ref_node to the tail or merge with tail.
+ *
+ * Return 0 for insert.
+ * Return >0 for merge.
+ */
+static int
+add_delayed_ref_tail_merge(struct btrfs_trans_handle *trans,
+			   struct btrfs_delayed_ref_root *root,
+			   struct btrfs_delayed_ref_head *href,
+			   struct btrfs_delayed_ref_node *ref)
+{
+	struct btrfs_delayed_ref_node *exist;
+	int mod;
+	int ret = 0;
+
+	spin_lock(&href->lock);
+	/* Check whether we can merge the tail node with ref */
+	if (list_empty(&href->ref_list))
+		goto add_tail;
+	exist = list_entry(href->ref_list.prev, struct btrfs_delayed_ref_node,
+			   list);
+	/* No need to compare bytenr nor is_head */
+	if (exist->type != ref->type || exist->no_quota != ref->no_quota ||
+	    exist->seq != ref->seq)
+		goto add_tail;
+
+	if ((exist->type == BTRFS_TREE_BLOCK_REF_KEY ||
+	     exist->type == BTRFS_SHARED_BLOCK_REF_KEY) &&
+	    comp_tree_refs(btrfs_delayed_node_to_tree_ref(exist),
+			   btrfs_delayed_node_to_tree_ref(ref),
+			   ref->type))
+		goto add_tail;
+	if ((exist->type == BTRFS_EXTENT_DATA_REF_KEY ||
+	     exist->type == BTRFS_SHARED_DATA_REF_KEY) &&
+	    comp_data_refs(btrfs_delayed_node_to_data_ref(exist),
+			   btrfs_delayed_node_to_data_ref(ref)))
+		goto add_tail;
+
+	/* Now we are sure we can merge */
+	ret = 1;
+	if (exist->action == ref->action) {
+		mod = ref->ref_mod;
+	} else {
+		/* Need to change action */
+		if (exist->ref_mod < ref->ref_mod) {
+			exist->action = ref->action;
+			mod = -exist->ref_mod;
+			exist->ref_mod = ref->ref_mod;
+		} else
+			mod = -ref->ref_mod;
+	}
+	exist->ref_mod += mod;
+
+	/* remove existing tail if its ref_mod is zero */
+	if (exist->ref_mod == 0)
+		drop_delayed_ref(trans, root, href, exist);
+	spin_unlock(&href->lock);
+	return ret;
+
+add_tail:
+	list_add_tail(&ref->list, &href->ref_list);
+	atomic_inc(&root->num_entries);
+	trans->delayed_ref_updates++;
+	spin_unlock(&href->lock);
+	return ret;
+}
+
+/*
  * helper function to update the accounting in the head ref
  * existing and update must have the same bytenr
  */
@@ -603,7 +629,7 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 	head_ref = btrfs_delayed_node_to_head(ref);
 	head_ref->must_insert_reserved = must_insert_reserved;
 	head_ref->is_data = is_data;
-	head_ref->ref_root = RB_ROOT;
+	INIT_LIST_HEAD(&head_ref->ref_list);
 	head_ref->processing = 0;
 
 	spin_lock_init(&head_ref->lock);
@@ -641,10 +667,10 @@ add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 		     u64 num_bytes, u64 parent, u64 ref_root, int level,
 		     int action, int no_quota)
 {
-	struct btrfs_delayed_ref_node *existing;
 	struct btrfs_delayed_tree_ref *full_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
 	u64 seq = 0;
+	int ret;
 
 	if (action == BTRFS_ADD_DELAYED_EXTENT)
 		action = BTRFS_ADD_DELAYED_REF;
@@ -675,21 +701,14 @@ add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 
 	trace_add_delayed_tree_ref(ref, full_ref, action);
 
-	spin_lock(&head_ref->lock);
-	existing = tree_insert(&head_ref->ref_root, &ref->rb_node);
-	if (existing) {
-		update_existing_ref(trans, delayed_refs, head_ref, existing,
-				    ref);
-		/*
-		 * we've updated the existing ref, free the newly
-		 * allocated ref
-		 */
+	ret = add_delayed_ref_tail_merge(trans, delayed_refs, head_ref, ref);
+
+	/*
+	 * XXX: memory should be freed at the same level allocated.
+	 * But bad practice is anywhere... Follow it now. Need cleanup.
+	 */
+	if (ret > 0)
 		kmem_cache_free(btrfs_delayed_tree_ref_cachep, full_ref);
-	} else {
-		atomic_inc(&delayed_refs->num_entries);
-		trans->delayed_ref_updates++;
-	}
-	spin_unlock(&head_ref->lock);
 }
 
 /*
@@ -703,10 +722,10 @@ add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 		     u64 num_bytes, u64 parent, u64 ref_root, u64 owner,
 		     u64 offset, int action, int no_quota)
 {
-	struct btrfs_delayed_ref_node *existing;
 	struct btrfs_delayed_data_ref *full_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
 	u64 seq = 0;
+	int ret;
 
 	if (action == BTRFS_ADD_DELAYED_EXTENT)
 		action = BTRFS_ADD_DELAYED_REF;
@@ -740,21 +759,10 @@ add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 
 	trace_add_delayed_data_ref(ref, full_ref, action);
 
-	spin_lock(&head_ref->lock);
-	existing = tree_insert(&head_ref->ref_root, &ref->rb_node);
-	if (existing) {
-		update_existing_ref(trans, delayed_refs, head_ref, existing,
-				    ref);
-		/*
-		 * we've updated the existing ref, free the newly
-		 * allocated ref
-		 */
+	ret = add_delayed_ref_tail_merge(trans, delayed_refs, head_ref, ref);
+
+	if (ret > 0)
 		kmem_cache_free(btrfs_delayed_data_ref_cachep, full_ref);
-	} else {
-		atomic_inc(&delayed_refs->num_entries);
-		trans->delayed_ref_updates++;
-	}
-	spin_unlock(&head_ref->lock);
 }
 
 /*
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index a764e23..a5f6a66 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -24,9 +24,25 @@
 #define BTRFS_ADD_DELAYED_EXTENT 3 /* record a full extent allocation */
 #define BTRFS_UPDATE_DELAYED_HEAD 4 /* not changing ref count on head ref */
 
+/*
+ * XXX: Qu: I really hate the design that ref_head and tree/data ref shares the
+ * same ref_node structure.
+ * Ref_head is in a higher logic level than tree/data ref, and duplicated
+ * bytenr/num_bytes in ref_node is really a waste or memory, they should be
+ * referred from ref_head.
+ * This gets more disgusting after we use list to store tree/data ref in
+ * ref_head. Must clean this mess up later.
+ */
 struct btrfs_delayed_ref_node {
+	/*
+	 * ref_head use rb tree, stored in ref_root->href.
+	 * indexed by bytenr
+	 */
 	struct rb_node rb_node;
 
+	/*data/tree ref use list, stored in ref_head->ref_list. */
+	struct list_head list;
+
 	/* the starting bytenr of the extent */
 	u64 bytenr;
 
@@ -83,7 +99,7 @@ struct btrfs_delayed_ref_head {
 	struct mutex mutex;
 
 	spinlock_t lock;
-	struct rb_root ref_root;
+	struct list_head ref_list;
 
 	struct rb_node href_node;
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 639f266..eaeab39 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4016,6 +4016,7 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 
 	while ((node = rb_first(&delayed_refs->href_root)) != NULL) {
 		struct btrfs_delayed_ref_head *head;
+		struct btrfs_delayed_ref_node *tmp;
 		bool pin_bytes = false;
 
 		head = rb_entry(node, struct btrfs_delayed_ref_head,
@@ -4031,11 +4032,10 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 			continue;
 		}
 		spin_lock(&head->lock);
-		while ((node = rb_first(&head->ref_root)) != NULL) {
-			ref = rb_entry(node, struct btrfs_delayed_ref_node,
-				       rb_node);
+		list_for_each_entry_safe_reverse(ref, tmp, &head->ref_list,
+						 list) {
 			ref->in_tree = 0;
-			rb_erase(&ref->rb_node, &head->ref_root);
+			list_del(&ref->list);
 			atomic_dec(&delayed_refs->num_entries);
 			btrfs_put_delayed_ref(ref);
 		}
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8b353ad..e0d3fcc 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2323,28 +2323,14 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static noinline struct btrfs_delayed_ref_node *
+static inline struct btrfs_delayed_ref_node *
 select_delayed_ref(struct btrfs_delayed_ref_head *head)
 {
-	struct rb_node *node;
-	struct btrfs_delayed_ref_node *ref, *last = NULL;;
+	if (list_empty(&head->ref_list))
+		return NULL;
 
-	/*
-	 * select delayed ref of type BTRFS_ADD_DELAYED_REF first.
-	 * this prevents ref count from going down to zero when
-	 * there still are pending delayed ref.
-	 */
-	node = rb_first(&head->ref_root);
-	while (node) {
-		ref = rb_entry(node, struct btrfs_delayed_ref_node,
-				rb_node);
-		if (ref->action == BTRFS_ADD_DELAYED_REF)
-			return ref;
-		else if (last == NULL)
-			last = ref;
-		node = rb_next(node);
-	}
-	return last;
+	return list_entry(head->ref_list.next, struct btrfs_delayed_ref_node,
+			  list);
 }
 
 /*
@@ -2396,16 +2382,7 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 			}
 		}
 
-		/*
-		 * We need to try and merge add/drops of the same ref since we
-		 * can run into issues with relocate dropping the implicit ref
-		 * and then it being added back again before the drop can
-		 * finish.  If we merged anything we need to re-loop so we can
-		 * get a good ref.
-		 */
 		spin_lock(&locked_ref->lock);
-		btrfs_merge_delayed_refs(trans, fs_info, delayed_refs,
-					 locked_ref);
 
 		/*
 		 * locked_ref is the head node, so we have to go one
@@ -2482,7 +2459,7 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 			spin_unlock(&locked_ref->lock);
 			spin_lock(&delayed_refs->lock);
 			spin_lock(&locked_ref->lock);
-			if (rb_first(&locked_ref->ref_root) ||
+			if (!list_empty(&locked_ref->ref_list) ||
 			    locked_ref->extent_op) {
 				spin_unlock(&locked_ref->lock);
 				spin_unlock(&delayed_refs->lock);
@@ -2496,7 +2473,7 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 		} else {
 			actual_count++;
 			ref->in_tree = 0;
-			rb_erase(&ref->rb_node, &locked_ref->ref_root);
+			list_del(&ref->list);
 		}
 		atomic_dec(&delayed_refs->num_entries);
 
@@ -2874,7 +2851,6 @@ static noinline int check_delayed_ref(struct btrfs_trans_handle *trans,
 	struct btrfs_delayed_ref_node *ref;
 	struct btrfs_delayed_data_ref *data_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
-	struct rb_node *node;
 	int ret = 0;
 
 	delayed_refs = &trans->transaction->delayed_refs;
@@ -2903,11 +2879,7 @@ static noinline int check_delayed_ref(struct btrfs_trans_handle *trans,
 	spin_unlock(&delayed_refs->lock);
 
 	spin_lock(&head->lock);
-	node = rb_first(&head->ref_root);
-	while (node) {
-		ref = rb_entry(node, struct btrfs_delayed_ref_node, rb_node);
-		node = rb_next(node);
-
+	list_for_each_entry(ref, &head->ref_list, list) {
 		/* If it's a shared ref we know a cross reference exists */
 		if (ref->type != BTRFS_EXTENT_DATA_REF_KEY) {
 			ret = 1;
@@ -6135,7 +6107,7 @@ static noinline int check_ref_cleanup(struct btrfs_trans_handle *trans,
 		goto out_delayed_unlock;
 
 	spin_lock(&head->lock);
-	if (rb_first(&head->ref_root))
+	if (!list_empty(&head->ref_list))
 		goto out;
 
 	if (head->extent_op) {
-- 
2.3.6

