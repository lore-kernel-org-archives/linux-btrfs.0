From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH v2 06/10] Btrfs: add sequence numbers to delayed refs
Date: Wed,  4 Jan 2012 18:35:44 +0100
Message-ID: <00f04b88791ff49dc64ada18819d40a5b0671709.1325692561.git.list.btrfs@jan-o-sch.net>
References: <cover.1325692560.git.list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1325692560.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1325692560.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

From: Arne Jansen <sensille@gmx.net>

Sequence numbers are needed to reconstruct the backrefs of a given extent to
a certain point in time. The total set of backrefs consist of the set of
backrefs recorded on disk plus the enqueued delayed refs for it that existed
at that moment.

This patch also adds a list that records all delayed refs which are
currently in the process of being added.

When walking all refs of an extent in btrfs_find_all_roots(), we freeze the
current state of delayed refs, honor anythinh up to this point and prevent
processing newer delayed refs to assert consistency.

Signed-off-by: Arne Jansen <sensille@gmx.net>
Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/delayed-ref.c |   34 +++++++++++++++++++++++
 fs/btrfs/delayed-ref.h |   70 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/transaction.c |    4 +++
 3 files changed, 108 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index babd37b..a405db0 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -101,6 +101,11 @@ static int comp_entry(struct btrfs_delayed_ref_node *ref2,
 		return -1;
 	if (ref1->type > ref2->type)
 		return 1;
+	/* merging of sequenced refs is not allowed */
+	if (ref1->seq < ref2->seq)
+		return -1;
+	if (ref1->seq > ref2->seq)
+		return 1;
 	if (ref1->type == BTRFS_TREE_BLOCK_REF_KEY ||
 	    ref1->type == BTRFS_SHARED_BLOCK_REF_KEY) {
 		return comp_tree_refs(btrfs_delayed_node_to_tree_ref(ref2),
@@ -209,6 +214,24 @@ int btrfs_delayed_ref_lock(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
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
+	if (seq >= elem->seq) {
+		pr_debug("holding back delayed_ref %llu, lowest is %llu (%p)\n",
+			 seq, elem->seq, delayed_refs);
+		return 1;
+	}
+	return 0;
+}
+
 int btrfs_find_ref_cluster(struct btrfs_trans_handle *trans,
 			   struct list_head *cluster, u64 start)
 {
@@ -438,6 +461,7 @@ static noinline int add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 	ref->action  = 0;
 	ref->is_head = 1;
 	ref->in_tree = 1;
+	ref->seq = 0;
 
 	head_ref = btrfs_delayed_node_to_head(ref);
 	head_ref->must_insert_reserved = must_insert_reserved;
@@ -479,6 +503,7 @@ static noinline int add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 	struct btrfs_delayed_ref_node *existing;
 	struct btrfs_delayed_tree_ref *full_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
+	u64 seq = 0;
 
 	if (action == BTRFS_ADD_DELAYED_EXTENT)
 		action = BTRFS_ADD_DELAYED_REF;
@@ -494,6 +519,10 @@ static noinline int add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 	ref->is_head = 0;
 	ref->in_tree = 1;
 
+	if (need_ref_seq(for_cow, ref_root))
+		seq = inc_delayed_seq(delayed_refs);
+	ref->seq = seq;
+
 	full_ref = btrfs_delayed_node_to_tree_ref(ref);
 	full_ref->parent = parent;
 	full_ref->root = ref_root;
@@ -534,6 +563,7 @@ static noinline int add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	struct btrfs_delayed_ref_node *existing;
 	struct btrfs_delayed_data_ref *full_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
+	u64 seq = 0;
 
 	if (action == BTRFS_ADD_DELAYED_EXTENT)
 		action = BTRFS_ADD_DELAYED_REF;
@@ -549,6 +579,10 @@ static noinline int add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	ref->is_head = 0;
 	ref->in_tree = 1;
 
+	if (need_ref_seq(for_cow, ref_root))
+		seq = inc_delayed_seq(delayed_refs);
+	ref->seq = seq;
+
 	full_ref = btrfs_delayed_node_to_data_ref(ref);
 	full_ref->parent = parent;
 	full_ref->root = ref_root;
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index a5fb2bc..174416f 100644
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
 
@@ -136,6 +139,20 @@ struct btrfs_delayed_ref_root {
 	int flushing;
 
 	u64 run_delayed_start;
+
+	/*
+	 * seq number of delayed refs. We need to know if a backref was being
+	 * added before the currently processed ref or afterwards.
+	 */
+	u64 seq;
+
+	/*
+	 * seq_list holds a list of all seq numbers that are currently being
+	 * added to the list. While walking backrefs (btrfs_find_all_roots,
+	 * qgroups), which might take some time, no newer ref must be processed,
+	 * as it might influence the outcome of the walk.
+	 */
+	struct list_head seq_head;
 };
 
 static inline void btrfs_put_delayed_ref(struct btrfs_delayed_ref_node *ref)
@@ -171,6 +188,59 @@ int btrfs_delayed_ref_lock(struct btrfs_trans_handle *trans,
 			   struct btrfs_delayed_ref_head *head);
 int btrfs_find_ref_cluster(struct btrfs_trans_handle *trans,
 			   struct list_head *cluster, u64 search_start);
+
+struct seq_list {
+	struct list_head list;
+	u64 seq;
+};
+
+static inline u64 inc_delayed_seq(struct btrfs_delayed_ref_root *delayed_refs)
+{
+	assert_spin_locked(&delayed_refs->lock);
+	++delayed_refs->seq;
+	return delayed_refs->seq;
+}
+
+static inline void
+btrfs_get_delayed_seq(struct btrfs_delayed_ref_root *delayed_refs,
+		      struct seq_list *elem)
+{
+	assert_spin_locked(&delayed_refs->lock);
+	elem->seq = delayed_refs->seq;
+	list_add_tail(&elem->list, &delayed_refs->seq_head);
+}
+
+static inline void
+btrfs_put_delayed_seq(struct btrfs_delayed_ref_root *delayed_refs,
+		      struct seq_list *elem)
+{
+	spin_lock(&delayed_refs->lock);
+	list_del(&elem->list);
+	spin_unlock(&delayed_refs->lock);
+}
+
+int btrfs_check_delayed_seq(struct btrfs_delayed_ref_root *delayed_refs,
+			    u64 seq);
+
+/*
+ * delayed refs with a ref_seq > 0 must be held back during backref walking.
+ * this only applies to items in one of the fs-trees. for_cow items never need
+ * to be held back, so they won't get a ref_seq number.
+ */
+static inline int need_ref_seq(int for_cow, u64 rootid)
+{
+	if (for_cow)
+		return 0;
+
+	if (rootid == BTRFS_FS_TREE_OBJECTID)
+		return 1;
+
+	if ((s64)rootid >= (s64)BTRFS_FIRST_FREE_OBJECTID)
+		return 1;
+
+	return 0;
+}
+
 /*
  * a node might live in a head or a regular ref, this lets you
  * test for the proper type to use.
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index a2bfedc..31a7393 100644
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
@@ -108,8 +110,10 @@ loop:
 	cur_trans->delayed_refs.num_heads = 0;
 	cur_trans->delayed_refs.flushing = 0;
 	cur_trans->delayed_refs.run_delayed_start = 0;
+	cur_trans->delayed_refs.seq = 1;
 	spin_lock_init(&cur_trans->commit_lock);
 	spin_lock_init(&cur_trans->delayed_refs.lock);
+	INIT_LIST_HEAD(&cur_trans->delayed_refs.seq_head);
 
 	INIT_LIST_HEAD(&cur_trans->pending_snapshots);
 	list_add_tail(&cur_trans->list, &root->fs_info->trans_list);
-- 
1.7.3.4

