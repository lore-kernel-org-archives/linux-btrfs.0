From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH v0 11/18] btrfs: add sequence numbers to delayed refs
Date: Thu,  6 Oct 2011 17:54:21 +0200
Message-ID: <a8a7ee0e9054a13296d532fb543891275292a4c7.1317915011.git.sensille@gmx.net>
References: <cover.1317915010.git.sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1317915010.git.sensille@gmx.net>
In-Reply-To: <cover.1317915010.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

Sequence numbers are needed to reconstruct the backrefs
of a given extent to a certain point in time. The total
set of backrefs consist of the set of backrefs recorded
on disk plus the enqueued delayed refs for it that existed
at that moment.
This patch also add a list that records all delayed refs
that are currently in the process of being added. With
qgroups enabled add a delayed ref involves walking the
backrefs of the extent. During this time, no delayed ref
that is newer must be processed.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/delayed-ref.c |   71 +++++++++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/delayed-ref.h |   21 ++++++++++++++
 fs/btrfs/transaction.c |    4 +++
 3 files changed, 92 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index babd37b..2c8544b 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -23,6 +23,11 @@
 #include "delayed-ref.h"
 #include "transaction.h"
 
+struct seq_list {
+	struct list_head list;
+	u64 seq;
+};
+
 /*
  * delayed back reference update tracking.  For subvolume trees
  * we queue up extent allocations and backref maintenance for
@@ -101,6 +106,11 @@ static int comp_entry(struct btrfs_delayed_ref_node *ref2,
 		return -1;
 	if (ref1->type > ref2->type)
 		return 1;
+	/* with quota enable, merging of refs is not allowed */
+	if (ref1->seq < ref2->seq)
+		return -1;
+	if (ref1->seq > ref2->seq)
+		return 1;
 	if (ref1->type == BTRFS_TREE_BLOCK_REF_KEY ||
 	    ref1->type == BTRFS_SHARED_BLOCK_REF_KEY) {
 		return comp_tree_refs(btrfs_delayed_node_to_tree_ref(ref2),
@@ -209,6 +219,39 @@ int btrfs_delayed_ref_lock(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
+static u64 get_delayed_seq(struct btrfs_delayed_ref_root *delayed_refs,
+			   struct seq_list *elem)
+{
+	assert_spin_locked(&delayed_refs->lock);
+	elem->seq = ++delayed_refs->seq;
+	list_add_tail(&elem->list, &delayed_refs->seq_head);
+
+	return elem->seq;
+}
+
+static void put_delayed_seq(struct btrfs_delayed_ref_root *delayed_refs,
+			    struct seq_list *elem)
+{
+	spin_lock(&delayed_refs->lock);
+	list_del(&elem->list);
+	spin_unlock(&delayed_refs->lock);
+}
+
+int btrfs_check_delayed_seq(struct btrfs_delayed_ref_root *delayed_refs,
+			    u64 seq)
+{
+	struct seq_list *elem;
+
+	assert_spin_locked(&delayed_refs->lock);
+	if (list_empty(&delayed_refs->seq_head))
+		return 0;
+
+	elem = list_first_entry(&delayed_refs->seq_head, struct seq_list, list);
+	if (seq >= elem->seq)
+		return 1;
+	return 0;
+}
+
 int btrfs_find_ref_cluster(struct btrfs_trans_handle *trans,
 			   struct list_head *cluster, u64 start)
 {
@@ -438,6 +481,7 @@ static noinline int add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 	ref->action  = 0;
 	ref->is_head = 1;
 	ref->in_tree = 1;
+	ref->seq = 0;
 
 	head_ref = btrfs_delayed_node_to_head(ref);
 	head_ref->must_insert_reserved = must_insert_reserved;
@@ -474,11 +518,12 @@ static noinline int add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 					 struct btrfs_delayed_ref_node *ref,
 					 u64 bytenr, u64 num_bytes, u64 parent,
 					 u64 ref_root, int level, int action,
-					 int for_cow)
+					 int for_cow, struct seq_list *seq_elem)
 {
 	struct btrfs_delayed_ref_node *existing;
 	struct btrfs_delayed_tree_ref *full_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
+	u64 seq = 0;
 
 	if (action == BTRFS_ADD_DELAYED_EXTENT)
 		action = BTRFS_ADD_DELAYED_REF;
@@ -494,6 +539,10 @@ static noinline int add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 	ref->is_head = 0;
 	ref->in_tree = 1;
 
+	if (fs_info->quota_enabled && !for_cow && is_fstree(ref_root))
+		seq = get_delayed_seq(delayed_refs, seq_elem);
+	ref->seq = seq;
+
 	full_ref = btrfs_delayed_node_to_tree_ref(ref);
 	full_ref->parent = parent;
 	full_ref->root = ref_root;
@@ -529,11 +578,13 @@ static noinline int add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 					 struct btrfs_delayed_ref_node *ref,
 					 u64 bytenr, u64 num_bytes, u64 parent,
 					 u64 ref_root, u64 owner, u64 offset,
-					 int action, int for_cow)
+					 int action, int for_cow,
+					 struct seq_list *seq_elem)
 {
 	struct btrfs_delayed_ref_node *existing;
 	struct btrfs_delayed_data_ref *full_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
+	u64 seq = 0;
 
 	if (action == BTRFS_ADD_DELAYED_EXTENT)
 		action = BTRFS_ADD_DELAYED_REF;
@@ -549,6 +600,10 @@ static noinline int add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	ref->is_head = 0;
 	ref->in_tree = 1;
 
+	if (fs_info->quota_enabled && !for_cow && is_fstree(ref_root))
+		seq = get_delayed_seq(delayed_refs, seq_elem);
+	ref->seq = seq;
+
 	full_ref = btrfs_delayed_node_to_data_ref(ref);
 	full_ref->parent = parent;
 	full_ref->root = ref_root;
@@ -594,6 +649,7 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 	struct btrfs_delayed_ref_head *head_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
 	int ret;
+	struct seq_list seq_elem;
 
 	BUG_ON(extent_op && extent_op->is_data);
 	ref = kmalloc(sizeof(*ref), GFP_NOFS);
@@ -621,9 +677,12 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 
 	ret = add_delayed_tree_ref(fs_info, trans, &ref->node, bytenr,
 				   num_bytes, parent, ref_root, level, action,
-				   for_cow);
+				   for_cow, &seq_elem);
 	BUG_ON(ret);
 	spin_unlock(&delayed_refs->lock);
+	if (fs_info->quota_enabled && !for_cow && is_fstree(ref_root))
+		put_delayed_seq(delayed_refs, &seq_elem);
+
 	return 0;
 }
 
@@ -642,6 +701,7 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	struct btrfs_delayed_ref_head *head_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
 	int ret;
+	struct seq_list seq_elem;
 
 	BUG_ON(extent_op && !extent_op->is_data);
 	ref = kmalloc(sizeof(*ref), GFP_NOFS);
@@ -669,9 +729,12 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 
 	ret = add_delayed_data_ref(fs_info, trans, &ref->node, bytenr,
 				   num_bytes, parent, ref_root, owner, offset,
-				   action, for_cow);
+				   action, for_cow, &seq_elem);
 	BUG_ON(ret);
 	spin_unlock(&delayed_refs->lock);
+	if (fs_info->quota_enabled && !for_cow && is_fstree(ref_root))
+		put_delayed_seq(delayed_refs, &seq_elem);
+
 	return 0;
 }
 
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index a5fb2bc..80e6f1c 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -33,6 +33,9 @@ struct btrfs_delayed_ref_node {
 	/* the size of the extent */
 	u64 num_bytes;
 
+	/* seq number to keep track of insertion order */
+	u64 seq;
+
 	/* ref count on this data structure */
 	atomic_t refs;
 
@@ -136,6 +139,21 @@ struct btrfs_delayed_ref_root {
 	int flushing;
 
 	u64 run_delayed_start;
+
+	/*
+	 * seq number of delayed refs. For qgroups we need to know if a backref
+	 * was being added before the currently processed ref or afterwards.
+	 */
+	u64 seq;
+
+	/*
+	 * seq_list holds a list of all seq numbers that are currently being
+	 * added to the list. When qgroups are active, the addition of a delayed
+	 * ref requires a walking of the backrefs which might take some time.
+	 * During this time, no newer ref must be processed, as it might
+	 * influence the outcome of the walk.
+	 */
+	struct list_head seq_head;
 };
 
 static inline void btrfs_put_delayed_ref(struct btrfs_delayed_ref_node *ref)
@@ -171,6 +189,9 @@ int btrfs_delayed_ref_lock(struct btrfs_trans_handle *trans,
 			   struct btrfs_delayed_ref_head *head);
 int btrfs_find_ref_cluster(struct btrfs_trans_handle *trans,
 			   struct list_head *cluster, u64 search_start);
+int btrfs_check_delayed_seq(struct btrfs_delayed_ref_root *delayed_refs,
+			    u64 seq);
+
 /*
  * a node might live in a head or a regular ref, this lets you
  * test for the proper type to use.
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index d7f32da..c8642a7 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -36,6 +36,8 @@ static noinline void put_transaction(struct btrfs_transaction *transaction)
 	WARN_ON(atomic_read(&transaction->use_count) == 0);
 	if (atomic_dec_and_test(&transaction->use_count)) {
 		BUG_ON(!list_empty(&transaction->list));
+		WARN_ON(transaction->delayed_refs.root.rb_node);
+		WARN_ON(!list_empty(&transaction->delayed_refs.seq_head));
 		memset(transaction, 0, sizeof(*transaction));
 		kmem_cache_free(btrfs_transaction_cachep, transaction);
 	}
@@ -105,8 +107,10 @@ static noinline int join_transaction(struct btrfs_root *root, int nofail)
 	cur_trans->delayed_refs.num_heads = 0;
 	cur_trans->delayed_refs.flushing = 0;
 	cur_trans->delayed_refs.run_delayed_start = 0;
+	cur_trans->delayed_refs.seq = 0;
 	spin_lock_init(&cur_trans->commit_lock);
 	spin_lock_init(&cur_trans->delayed_refs.lock);
+	INIT_LIST_HEAD(&cur_trans->delayed_refs.seq_head);
 
 	INIT_LIST_HEAD(&cur_trans->pending_snapshots);
 	list_add_tail(&cur_trans->list, &root->fs_info->trans_list);
-- 
1.7.3.4

