Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:37471 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755937Ab2HFUZh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Aug 2012 16:25:37 -0400
From: Arne Jansen <sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Cc: list.btrfs@jan-o-sch.net
Subject: [PATCH] Btrfs: fix deadlock in wait_for_more_refs
Date: Mon,  6 Aug 2012 22:18:51 +0200
Message-Id: <1344284331-24328-1-git-send-email-sensille@gmx.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit a168650c introduced a waiting mechanism to prevent busy waiting in
btrfs_run_delayed_refs. This can deadlock with btrfs_run_ordered_operations,
where a tree_mod_seq is held while waiting for the io to complete, while
the end_io calls btrfs_run_delayed_refs.
This whole mechanism is unnecessary. If not enough runnable refs are
available to satisfy count, just return as count is more like a guideline
than a strict requirement.
In case we have to run all refs, commit transaction makes sure that no
other threads are working in the transaction anymore, so we just assert
here that no refs are blocked.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/ctree.c       |    6 ----
 fs/btrfs/ctree.h       |    1 -
 fs/btrfs/delayed-ref.c |    8 -----
 fs/btrfs/disk-io.c     |    2 -
 fs/btrfs/extent-tree.c |   77 +++++++++++++-----------------------------------
 5 files changed, 21 insertions(+), 73 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 9d7621f..08e0b11 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -421,12 +421,6 @@ void btrfs_put_tree_mod_seq(struct btrfs_fs_info *fs_info,
 	spin_unlock(&fs_info->tree_mod_seq_lock);
 
 	/*
-	 * we removed the lowest blocker from the blocker list, so there may be
-	 * more processible delayed refs.
-	 */
-	wake_up(&fs_info->tree_mod_seq_wait);
-
-	/*
 	 * anything that's lower than the lowest existing (read: blocked)
 	 * sequence number can be removed from the tree.
 	 */
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index adb1cd7..2b90942 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1252,7 +1252,6 @@ struct btrfs_fs_info {
 	atomic_t tree_mod_seq;
 	struct list_head tree_mod_seq_list;
 	struct seq_list tree_mod_seq_elem;
-	wait_queue_head_t tree_mod_seq_wait;
 
 	/* this protects tree_mod_log */
 	rwlock_t tree_mod_log_lock;
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index da7419e..7561431 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -662,9 +662,6 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 	add_delayed_tree_ref(fs_info, trans, &ref->node, bytenr,
 				   num_bytes, parent, ref_root, level, action,
 				   for_cow);
-	if (!need_ref_seq(for_cow, ref_root) &&
-	    waitqueue_active(&fs_info->tree_mod_seq_wait))
-		wake_up(&fs_info->tree_mod_seq_wait);
 	spin_unlock(&delayed_refs->lock);
 	if (need_ref_seq(for_cow, ref_root))
 		btrfs_qgroup_record_ref(trans, &ref->node, extent_op);
@@ -713,9 +710,6 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	add_delayed_data_ref(fs_info, trans, &ref->node, bytenr,
 				   num_bytes, parent, ref_root, owner, offset,
 				   action, for_cow);
-	if (!need_ref_seq(for_cow, ref_root) &&
-	    waitqueue_active(&fs_info->tree_mod_seq_wait))
-		wake_up(&fs_info->tree_mod_seq_wait);
 	spin_unlock(&delayed_refs->lock);
 	if (need_ref_seq(for_cow, ref_root))
 		btrfs_qgroup_record_ref(trans, &ref->node, extent_op);
@@ -744,8 +738,6 @@ int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
 				   num_bytes, BTRFS_UPDATE_DELAYED_HEAD,
 				   extent_op->is_data);
 
-	if (waitqueue_active(&fs_info->tree_mod_seq_wait))
-		wake_up(&fs_info->tree_mod_seq_wait);
 	spin_unlock(&delayed_refs->lock);
 	return 0;
 }
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 502b20c..a7ad8fc 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2035,8 +2035,6 @@ int open_ctree(struct super_block *sb,
 	fs_info->free_chunk_space = 0;
 	fs_info->tree_mod_log = RB_ROOT;
 
-	init_waitqueue_head(&fs_info->tree_mod_seq_wait);
-
 	/* readahead state */
 	INIT_RADIX_TREE(&fs_info->reada_tree, GFP_NOFS & ~__GFP_WAIT);
 	spin_lock_init(&fs_info->reada_lock);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4e1b153..a9ca92e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2318,12 +2318,6 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
 		ref->in_tree = 0;
 		rb_erase(&ref->rb_node, &delayed_refs->root);
 		delayed_refs->num_entries--;
-		/*
-		 * we modified num_entries, but as we're currently running
-		 * delayed refs, skip
-		 *     wake_up(&delayed_refs->seq_wait);
-		 * here.
-		 */
 		spin_unlock(&delayed_refs->lock);
 
 		ret = run_one_delayed_ref(trans, root, ref, extent_op,
@@ -2350,22 +2344,6 @@ next:
 	return count;
 }
 
-static void wait_for_more_refs(struct btrfs_fs_info *fs_info,
-			       struct btrfs_delayed_ref_root *delayed_refs,
-			       unsigned long num_refs,
-			       struct list_head *first_seq)
-{
-	spin_unlock(&delayed_refs->lock);
-	pr_debug("waiting for more refs (num %ld, first %p)\n",
-		 num_refs, first_seq);
-	wait_event(fs_info->tree_mod_seq_wait,
-		   num_refs != delayed_refs->num_entries ||
-		   fs_info->tree_mod_seq_list.next != first_seq);
-	pr_debug("done waiting for more refs (num %ld, first %p)\n",
-		 delayed_refs->num_entries, fs_info->tree_mod_seq_list.next);
-	spin_lock(&delayed_refs->lock);
-}
-
 #ifdef SCRAMBLE_DELAYED_REFS
 /*
  * Normally delayed refs get processed in ascending bytenr order. This
@@ -2460,13 +2438,11 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 	struct btrfs_delayed_ref_root *delayed_refs;
 	struct btrfs_delayed_ref_node *ref;
 	struct list_head cluster;
-	struct list_head *first_seq = NULL;
 	int ret;
 	u64 delayed_start;
 	int run_all = count == (unsigned long)-1;
 	int run_most = 0;
-	unsigned long num_refs = 0;
-	int consider_waiting;
+	int loops;
 
 	/* We'll clean this up in btrfs_cleanup_transaction */
 	if (trans->aborted)
@@ -2484,7 +2460,7 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 	delayed_refs = &trans->transaction->delayed_refs;
 	INIT_LIST_HEAD(&cluster);
 again:
-	consider_waiting = 0;
+	loops = 0;
 	spin_lock(&delayed_refs->lock);
 
 #ifdef SCRAMBLE_DELAYED_REFS
@@ -2512,31 +2488,6 @@ again:
 		if (ret)
 			break;
 
-		if (delayed_start >= delayed_refs->run_delayed_start) {
-			if (consider_waiting == 0) {
-				/*
-				 * btrfs_find_ref_cluster looped. let's do one
-				 * more cycle. if we don't run any delayed ref
-				 * during that cycle (because we can't because
-				 * all of them are blocked) and if the number of
-				 * refs doesn't change, we avoid busy waiting.
-				 */
-				consider_waiting = 1;
-				num_refs = delayed_refs->num_entries;
-				first_seq = root->fs_info->tree_mod_seq_list.next;
-			} else {
-				wait_for_more_refs(root->fs_info, delayed_refs,
-						   num_refs, first_seq);
-				/*
-				 * after waiting, things have changed. we
-				 * dropped the lock and someone else might have
-				 * run some refs, built new clusters and so on.
-				 * therefore, we restart staleness detection.
-				 */
-				consider_waiting = 0;
-			}
-		}
-
 		ret = run_clustered_refs(trans, root, &cluster);
 		if (ret < 0) {
 			spin_unlock(&delayed_refs->lock);
@@ -2549,9 +2500,26 @@ again:
 		if (count == 0)
 			break;
 
-		if (ret || delayed_refs->run_delayed_start == 0) {
+		if (delayed_start >= delayed_refs->run_delayed_start) {
+			if (loops == 0) {
+				/*
+				 * btrfs_find_ref_cluster looped. let's do one
+				 * more cycle. if we don't run any delayed ref
+				 * during that cycle (because we can't because
+				 * all of them are blocked), bail out.
+				 */
+				loops = 1;
+			} else {
+				/*
+				 * no runnable refs left, stop trying
+				 */
+				BUG_ON(run_all);
+				break;
+			}
+		}
+		if (ret) {
 			/* refs were run, let's reset staleness detection */
-			consider_waiting = 0;
+			loops = 0;
 		}
 	}
 
@@ -5294,9 +5262,6 @@ static noinline int check_ref_cleanup(struct btrfs_trans_handle *trans,
 	rb_erase(&head->node.rb_node, &delayed_refs->root);
 
 	delayed_refs->num_entries--;
-	smp_mb();
-	if (waitqueue_active(&root->fs_info->tree_mod_seq_wait))
-		wake_up(&root->fs_info->tree_mod_seq_wait);
 
 	/*
 	 * we don't take a ref on the node because we're removing it from the
-- 
1.7.3.4

