From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH v1 08/10] Btrfs: add waitqueue instead of doing busy waiting for more delayed refs
Date: Thu, 22 Dec 2011 17:03:22 +0100
Message-ID: <32cd9117f52538ff0a83adbb7a3a0713799d1598.1324568416.git.list.btrfs@jan-o-sch.net>
References: <cover.1324568415.git.list.btrfs@jan-o-sch.net>
Cc: lizf@cn.fujitsu.com, sensille@gmx.net
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1324568415.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1324568415.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

Now that we may be holding back delayed refs for a limited period, we
might end up having no runnable delayed refs. Without this commit, we'd
do busy waiting in that thread until another (runnable) ref arives.
Instead, we're detecting this situation and use a waitqueue, such that
we only try to run more refs after
	a) another runnable ref was added  or
	b) delayed refs are no longer held back

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/delayed-ref.c |    8 ++++++
 fs/btrfs/delayed-ref.h |    7 +++++
 fs/btrfs/extent-tree.c |   59 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/transaction.c |    1 +
 4 files changed, 74 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index ee18198..66e4f29 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -664,6 +664,9 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 				   num_bytes, parent, ref_root, level, action,
 				   for_cow);
 	BUG_ON(ret);
+	if (!need_ref_seq(for_cow, ref_root) &&
+	    waitqueue_active(&delayed_refs->seq_wait))
+		wake_up(&delayed_refs->seq_wait);
 	spin_unlock(&delayed_refs->lock);
 	return 0;
 }
@@ -712,6 +715,9 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 				   num_bytes, parent, ref_root, owner, offset,
 				   action, for_cow);
 	BUG_ON(ret);
+	if (!need_ref_seq(for_cow, ref_root) &&
+	    waitqueue_active(&delayed_refs->seq_wait))
+		wake_up(&delayed_refs->seq_wait);
 	spin_unlock(&delayed_refs->lock);
 	return 0;
 }
@@ -739,6 +745,8 @@ int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
 				   extent_op->is_data);
 	BUG_ON(ret);
 
+	if (waitqueue_active(&delayed_refs->seq_wait))
+		wake_up(&delayed_refs->seq_wait);
 	spin_unlock(&delayed_refs->lock);
 	return 0;
 }
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index 174416f..d8f244d 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -153,6 +153,12 @@ struct btrfs_delayed_ref_root {
 	 * as it might influence the outcome of the walk.
 	 */
 	struct list_head seq_head;
+
+	/*
+	 * when the only refs we have in the list must not be processed, we want
+	 * to wait for more refs to show up or for the end of backref walking.
+	 */
+	wait_queue_head_t seq_wait;
 };
 
 static inline void btrfs_put_delayed_ref(struct btrfs_delayed_ref_node *ref)
@@ -216,6 +222,7 @@ btrfs_put_delayed_seq(struct btrfs_delayed_ref_root *delayed_refs,
 {
 	spin_lock(&delayed_refs->lock);
 	list_del(&elem->list);
+	wake_up(&delayed_refs->seq_wait);
 	spin_unlock(&delayed_refs->lock);
 }
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index bbcca12..0a435e2 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2300,7 +2300,12 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
 		ref->in_tree = 0;
 		rb_erase(&ref->rb_node, &delayed_refs->root);
 		delayed_refs->num_entries--;
-
+		/*
+		 * we modified num_entries, but as we're currently running
+		 * delayed refs, skip
+		 *     wake_up(&delayed_refs->seq_wait);
+		 * here.
+		 */
 		spin_unlock(&delayed_refs->lock);
 
 		ret = run_one_delayed_ref(trans, root, ref, extent_op,
@@ -2317,6 +2322,23 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
 	return count;
 }
 
+
+static void wait_for_more_refs(struct btrfs_delayed_ref_root *delayed_refs,
+			unsigned long num_refs)
+{
+	struct list_head *first_seq = delayed_refs->seq_head.next;
+
+	spin_unlock(&delayed_refs->lock);
+	pr_debug("waiting for more refs (num %ld, first %p)\n",
+		 num_refs, first_seq);
+	wait_event(delayed_refs->seq_wait,
+		   num_refs != delayed_refs->num_entries ||
+		   delayed_refs->seq_head.next != first_seq);
+	pr_debug("done waiting for more refs (num %ld, first %p)\n",
+		 delayed_refs->num_entries, delayed_refs->seq_head.next);
+	spin_lock(&delayed_refs->lock);
+}
+
 /*
  * this starts processing the delayed reference count updates and
  * extent insertions we have queued up so far.  count can be
@@ -2332,8 +2354,11 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 	struct btrfs_delayed_ref_node *ref;
 	struct list_head cluster;
 	int ret;
+	u64 delayed_start;
 	int run_all = count == (unsigned long)-1;
 	int run_most = 0;
+	unsigned long num_refs = 0;
+	int consider_waiting;
 
 	if (root == root->fs_info->extent_root)
 		root = root->fs_info->tree_root;
@@ -2341,6 +2366,7 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 	delayed_refs = &trans->transaction->delayed_refs;
 	INIT_LIST_HEAD(&cluster);
 again:
+	consider_waiting = 0;
 	spin_lock(&delayed_refs->lock);
 	if (count == 0) {
 		count = delayed_refs->num_entries * 2;
@@ -2357,11 +2383,35 @@ again:
 		 * of refs to process starting at the first one we are able to
 		 * lock
 		 */
+		delayed_start = delayed_refs->run_delayed_start;
 		ret = btrfs_find_ref_cluster(trans, &cluster,
 					     delayed_refs->run_delayed_start);
 		if (ret)
 			break;
 
+		if (delayed_start >= delayed_refs->run_delayed_start) {
+			if (consider_waiting == 0) {
+				/*
+				 * btrfs_find_ref_cluster looped. let's do one
+				 * more cycle. if we don't run any delayed ref
+				 * during that cycle (because we can't because
+				 * all of them are blocked) and if the number of
+				 * refs doesn't change, we avoid busy waiting.
+				 */
+				consider_waiting = 1;
+				num_refs = delayed_refs->num_entries;
+			} else {
+				wait_for_more_refs(delayed_refs, num_refs);
+				/*
+				 * after waiting, things have changed. we
+				 * dropped the lock and someone else might have
+				 * run some refs, built new clusters and so on.
+				 * therefore, we restart staleness detection.
+				 */
+				consider_waiting = 0;
+			}
+		}
+
 		ret = run_clustered_refs(trans, root, &cluster);
 		BUG_ON(ret < 0);
 
@@ -2369,6 +2419,11 @@ again:
 
 		if (count == 0)
 			break;
+
+		if (ret || delayed_refs->run_delayed_start == 0) {
+			/* refs were run, let's reset staleness detection */
+			consider_waiting = 0;
+		}
 	}
 
 	if (run_all) {
@@ -4933,6 +4988,8 @@ static noinline int check_ref_cleanup(struct btrfs_trans_handle *trans,
 	rb_erase(&head->node.rb_node, &delayed_refs->root);
 
 	delayed_refs->num_entries--;
+	if (waitqueue_active(&delayed_refs->seq_wait))
+		wake_up(&delayed_refs->seq_wait);
 
 	/*
 	 * we don't take a ref on the node because we're removing it from the
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 31a7393..04c5c7c 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -111,6 +111,7 @@ loop:
 	cur_trans->delayed_refs.flushing = 0;
 	cur_trans->delayed_refs.run_delayed_start = 0;
 	cur_trans->delayed_refs.seq = 1;
+	init_waitqueue_head(&cur_trans->delayed_refs.seq_wait);
 	spin_lock_init(&cur_trans->commit_lock);
 	spin_lock_init(&cur_trans->delayed_refs.lock);
 	INIT_LIST_HEAD(&cur_trans->delayed_refs.seq_head);
-- 
1.7.3.4

