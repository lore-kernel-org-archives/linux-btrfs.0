From: Josef Bacik <josef@redhat.com>
Subject: [PATCH][RFC] Btrfs: kill trans_mutex PLEASE TEST
Date: Fri, 15 Apr 2011 12:58:43 -0400
Message-ID: <1302886723-2059-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch depends on

[PATCH] Btrfs: if we've already started a trans handle, use that one

We use trans_mutex for lots of things, here's a basic list

1) To serialize trans_handles joining the currently running transaction
2) To make sure that no new trans handles are started while we are committing
3) To protect the dead_roots list and the transaction lists

Really the serializing trans_handles joining is not too hard, and can really get
bogged down in acquiring a reference to the transaction.  So replace the
trans_mutex with a trans_lock spinlock and use it to do the following

1) Protect fs_info->running_transaction.  All trans handles have to do is check
this, and then take a reference of the transaction and keep on going.
2) Protect the fs_info->trans_list.  This doesn't get used too much, basically
it just holds the current transactions, which will usually just be the currently
committing transaction and the currently running transaction at most.
3) Protect the dead roots list.  This is only ever processed by splicing the
list so this is relatively simple.
4) Protect the fs_info->reloc_ctl stuff.  This is very lightweight and was using
the trans_mutex before, so this is a pretty straightforward change.
5) Protect fs_info->no_trans_join.  Because we don't hold the trans_lock over
the entirety of the commit we need to have a way to block new people from
creating a new transaction while we're doing our work.  So we set no_trans_join
and in join_transaction we test to see if that is set, and if it is we do a
wait_on_commit.
6) Make the transaction use count atomic so we don't need to take locks to
modify it when we're dropping references.
7) Add a commit_lock to the transaction to make sure multiple people trying to
commit the same transaction don't race and commit at the same time.
8) Make open_ioctl_trans an atomic so we don't have to take any locks for ioctl
trans.

I have tested this with xfstests, but obviously it is a pretty hairy change so
lots of testing is greatly appreciated.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.h       |    6 +-
 fs/btrfs/disk-io.c     |   30 +++---
 fs/btrfs/extent-tree.c |    3 +-
 fs/btrfs/file.c        |    4 +-
 fs/btrfs/ioctl.c       |   12 +--
 fs/btrfs/relocation.c  |   16 ++--
 fs/btrfs/transaction.c |  271 +++++++++++++++++++++++++-----------------------
 fs/btrfs/transaction.h |    4 +-
 8 files changed, 177 insertions(+), 169 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index a566780..d5f043e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -918,7 +918,6 @@ struct btrfs_fs_info {
 	 * is required instead of the faster short fsync log commits
 	 */
 	u64 last_trans_log_full_commit;
-	u64 open_ioctl_trans;
 	unsigned long mount_opt:20;
 	unsigned long compress_type:4;
 	u64 max_inline;
@@ -935,7 +934,6 @@ struct btrfs_fs_info {
 	struct super_block *sb;
 	struct inode *btree_inode;
 	struct backing_dev_info bdi;
-	struct mutex trans_mutex;
 	struct mutex tree_log_mutex;
 	struct mutex transaction_kthread_mutex;
 	struct mutex cleaner_mutex;
@@ -956,6 +954,7 @@ struct btrfs_fs_info {
 	struct rw_semaphore subvol_sem;
 	struct srcu_struct subvol_srcu;
 
+	spinlock_t trans_lock;
 	struct list_head trans_list;
 	struct list_head hashers;
 	struct list_head dead_roots;
@@ -968,6 +967,7 @@ struct btrfs_fs_info {
 	atomic_t async_submit_draining;
 	atomic_t nr_async_bios;
 	atomic_t async_delalloc_pages;
+	atomic_t open_ioctl_trans;
 
 	/*
 	 * this is used by the balancing code to wait for all the pending
@@ -1031,6 +1031,7 @@ struct btrfs_fs_info {
 	int closing;
 	int log_root_recovering;
 	int enospc_unlink;
+	int trans_no_join;
 
 	u64 total_pinned;
 
@@ -1052,7 +1053,6 @@ struct btrfs_fs_info {
 	struct reloc_control *reloc_ctl;
 
 	spinlock_t delalloc_lock;
-	spinlock_t new_trans_lock;
 	u64 delalloc_bytes;
 
 	/* data_alloc_cluster is only used in ssd mode */
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 0a141df..c650a1d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1551,22 +1551,22 @@ static int transaction_kthread(void *arg)
 		vfs_check_frozen(root->fs_info->sb, SB_FREEZE_WRITE);
 		mutex_lock(&root->fs_info->transaction_kthread_mutex);
 
-		spin_lock(&root->fs_info->new_trans_lock);
+		spin_lock(&root->fs_info->trans_lock);
 		cur = root->fs_info->running_transaction;
 		if (!cur) {
-			spin_unlock(&root->fs_info->new_trans_lock);
+			spin_unlock(&root->fs_info->trans_lock);
 			goto sleep;
 		}
 
 		now = get_seconds();
 		if (!cur->blocked &&
 		    (now < cur->start_time || now - cur->start_time < 30)) {
-			spin_unlock(&root->fs_info->new_trans_lock);
+			spin_unlock(&root->fs_info->trans_lock);
 			delay = HZ * 5;
 			goto sleep;
 		}
 		transid = cur->transid;
-		spin_unlock(&root->fs_info->new_trans_lock);
+		spin_unlock(&root->fs_info->trans_lock);
 
 		trans = btrfs_join_transaction(root);
 		BUG_ON(IS_ERR(trans));
@@ -1658,7 +1658,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	INIT_LIST_HEAD(&fs_info->ordered_operations);
 	INIT_LIST_HEAD(&fs_info->caching_block_groups);
 	spin_lock_init(&fs_info->delalloc_lock);
-	spin_lock_init(&fs_info->new_trans_lock);
+	spin_lock_init(&fs_info->trans_lock);
 	spin_lock_init(&fs_info->ref_cache_lock);
 	spin_lock_init(&fs_info->fs_roots_radix_lock);
 	spin_lock_init(&fs_info->delayed_iput_lock);
@@ -1687,6 +1687,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	fs_info->sb = sb;
 	fs_info->max_inline = 8192 * 1024;
 	fs_info->metadata_ratio = 0;
+	fs_info->trans_no_join = 0;
 
 	fs_info->thread_pool_size = min_t(unsigned long,
 					  num_online_cpus() + 2, 8);
@@ -1735,7 +1736,6 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	fs_info->do_barriers = 1;
 
 
-	mutex_init(&fs_info->trans_mutex);
 	mutex_init(&fs_info->ordered_operations_mutex);
 	mutex_init(&fs_info->tree_log_mutex);
 	mutex_init(&fs_info->chunk_mutex);
@@ -3005,10 +3005,13 @@ static int btrfs_cleanup_transaction(struct btrfs_root *root)
 
 	WARN_ON(1);
 
-	mutex_lock(&root->fs_info->trans_mutex);
 	mutex_lock(&root->fs_info->transaction_kthread_mutex);
 
+	spin_lock(&root->fs_info->trans_lock);
 	list_splice_init(&root->fs_info->trans_list, &list);
+	root->fs_info->trans_no_join = 1;
+	spin_unlock(&root->fs_info->trans_lock);
+
 	while (!list_empty(&list)) {
 		t = list_entry(list.next, struct btrfs_transaction, list);
 		if (!t)
@@ -3033,23 +3036,18 @@ static int btrfs_cleanup_transaction(struct btrfs_root *root)
 		t->blocked = 0;
 		if (waitqueue_active(&root->fs_info->transaction_wait))
 			wake_up(&root->fs_info->transaction_wait);
-		mutex_unlock(&root->fs_info->trans_mutex);
 
-		mutex_lock(&root->fs_info->trans_mutex);
 		t->commit_done = 1;
 		if (waitqueue_active(&t->commit_wait))
 			wake_up(&t->commit_wait);
-		mutex_unlock(&root->fs_info->trans_mutex);
-
-		mutex_lock(&root->fs_info->trans_mutex);
 
 		btrfs_destroy_pending_snapshots(t);
 
 		btrfs_destroy_delalloc_inodes(root);
 
-		spin_lock(&root->fs_info->new_trans_lock);
+		spin_lock(&root->fs_info->trans_lock);
 		root->fs_info->running_transaction = NULL;
-		spin_unlock(&root->fs_info->new_trans_lock);
+		spin_unlock(&root->fs_info->trans_lock);
 
 		btrfs_destroy_marked_extents(root, &t->dirty_pages,
 					     EXTENT_DIRTY);
@@ -3063,8 +3061,10 @@ static int btrfs_cleanup_transaction(struct btrfs_root *root)
 		kmem_cache_free(btrfs_transaction_cachep, t);
 	}
 
+	spin_lock(&root->fs_info->trans_lock);
+	root->fs_info->trans_no_join = 0;
+	spin_unlock(&root->fs_info->trans_lock);
 	mutex_unlock(&root->fs_info->transaction_kthread_mutex);
-	mutex_unlock(&root->fs_info->trans_mutex);
 
 	return 0;
 }
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0714a57..a33d9a3 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3180,7 +3180,8 @@ alloc:
 
 		/* commit the current transaction and try again */
 commit_trans:
-		if (!committed && !root->fs_info->open_ioctl_trans) {
+		if (!committed &&
+		    !atomic_read(&root->fs_info->open_ioctl_trans)) {
 			committed = 1;
 			trans = btrfs_join_transaction(root);
 			if (IS_ERR(trans))
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 75899a0..cd5e82e 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1222,14 +1222,12 @@ int btrfs_sync_file(struct file *file, int datasync)
 	 * the current transaction, we can bail out now without any
 	 * syncing
 	 */
-	mutex_lock(&root->fs_info->trans_mutex);
+	smp_mb();
 	if (BTRFS_I(inode)->last_trans <=
 	    root->fs_info->last_trans_committed) {
 		BTRFS_I(inode)->last_trans = 0;
-		mutex_unlock(&root->fs_info->trans_mutex);
 		goto out;
 	}
-	mutex_unlock(&root->fs_info->trans_mutex);
 
 	/*
 	 * ok we haven't committed the transaction yet, lets do a commit
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 3696f23..31070d0 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2171,9 +2171,7 @@ static long btrfs_ioctl_trans_start(struct file *file)
 	if (ret)
 		goto out;
 
-	mutex_lock(&root->fs_info->trans_mutex);
-	root->fs_info->open_ioctl_trans++;
-	mutex_unlock(&root->fs_info->trans_mutex);
+	atomic_inc(&root->fs_info->open_ioctl_trans);
 
 	ret = -ENOMEM;
 	trans = btrfs_start_ioctl_transaction(root);
@@ -2184,9 +2182,7 @@ static long btrfs_ioctl_trans_start(struct file *file)
 	return 0;
 
 out_drop:
-	mutex_lock(&root->fs_info->trans_mutex);
-	root->fs_info->open_ioctl_trans--;
-	mutex_unlock(&root->fs_info->trans_mutex);
+	atomic_dec(&root->fs_info->open_ioctl_trans);
 	mnt_drop_write(file->f_path.mnt);
 out:
 	return ret;
@@ -2420,9 +2416,7 @@ long btrfs_ioctl_trans_end(struct file *file)
 
 	btrfs_end_transaction(trans, root);
 
-	mutex_lock(&root->fs_info->trans_mutex);
-	root->fs_info->open_ioctl_trans--;
-	mutex_unlock(&root->fs_info->trans_mutex);
+	atomic_dec(&root->fs_info->open_ioctl_trans);
 
 	mnt_drop_write(file->f_path.mnt);
 	return 0;
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index db5b15c..057ddec 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2136,10 +2136,10 @@ int prepare_to_merge(struct reloc_control *rc, int err)
 	u64 num_bytes = 0;
 	int ret;
 
-	mutex_lock(&root->fs_info->trans_mutex);
+	spin_lock(&root->fs_info->trans_lock);
 	rc->merging_rsv_size += root->nodesize * (BTRFS_MAX_LEVEL - 1) * 2;
 	rc->merging_rsv_size += rc->nodes_relocated * 2;
-	mutex_unlock(&root->fs_info->trans_mutex);
+	spin_unlock(&root->fs_info->trans_lock);
 again:
 	if (!err) {
 		num_bytes = rc->merging_rsv_size;
@@ -2208,9 +2208,9 @@ int merge_reloc_roots(struct reloc_control *rc)
 	int ret;
 again:
 	root = rc->extent_root;
-	mutex_lock(&root->fs_info->trans_mutex);
+	spin_lock(&root->fs_info->trans_lock);
 	list_splice_init(&rc->reloc_roots, &reloc_roots);
-	mutex_unlock(&root->fs_info->trans_mutex);
+	spin_unlock(&root->fs_info->trans_lock);
 
 	while (!list_empty(&reloc_roots)) {
 		found = 1;
@@ -3583,17 +3583,17 @@ next:
 static void set_reloc_control(struct reloc_control *rc)
 {
 	struct btrfs_fs_info *fs_info = rc->extent_root->fs_info;
-	mutex_lock(&fs_info->trans_mutex);
+	spin_lock(&fs_info->trans_lock);
 	fs_info->reloc_ctl = rc;
-	mutex_unlock(&fs_info->trans_mutex);
+	spin_unlock(&fs_info->trans_lock);
 }
 
 static void unset_reloc_control(struct reloc_control *rc)
 {
 	struct btrfs_fs_info *fs_info = rc->extent_root->fs_info;
-	mutex_lock(&fs_info->trans_mutex);
+	spin_lock(&fs_info->trans_lock);
 	fs_info->reloc_ctl = NULL;
-	mutex_unlock(&fs_info->trans_mutex);
+	spin_unlock(&fs_info->trans_lock);
 }
 
 static int check_extent_flags(u64 flags)
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 46f4056..43816f8 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -34,6 +34,7 @@ static noinline void put_transaction(struct btrfs_transaction *transaction)
 {
 	WARN_ON(atomic_read(&transaction->use_count) == 0);
 	if (atomic_dec_and_test(&transaction->use_count)) {
+		BUG_ON(!list_empty(&transaction->list));
 		memset(transaction, 0, sizeof(*transaction));
 		kmem_cache_free(btrfs_transaction_cachep, transaction);
 	}
@@ -48,47 +49,73 @@ static noinline void switch_commit_root(struct btrfs_root *root)
 /*
  * either allocate a new transaction or hop into the existing one
  */
-static noinline int join_transaction(struct btrfs_root *root)
+static noinline int join_transaction(struct btrfs_root *root, int nofail)
 {
 	struct btrfs_transaction *cur_trans;
+
+	spin_lock(&root->fs_info->trans_lock);
+	if (root->fs_info->trans_no_join) {
+		if (!nofail) {
+			spin_unlock(&root->fs_info->trans_lock);
+			return -EBUSY;
+		}
+	}
+
 	cur_trans = root->fs_info->running_transaction;
-	if (!cur_trans) {
-		cur_trans = kmem_cache_alloc(btrfs_transaction_cachep,
-					     GFP_NOFS);
-		if (!cur_trans)
-			return -ENOMEM;
-		root->fs_info->generation++;
-		atomic_set(&cur_trans->num_writers, 1);
-		cur_trans->num_joined = 0;
-		cur_trans->transid = root->fs_info->generation;
-		init_waitqueue_head(&cur_trans->writer_wait);
-		init_waitqueue_head(&cur_trans->commit_wait);
-		cur_trans->in_commit = 0;
-		cur_trans->blocked = 0;
-		atomic_set(&cur_trans->use_count, 1);
-		cur_trans->commit_done = 0;
-		cur_trans->start_time = get_seconds();
-
-		cur_trans->delayed_refs.root = RB_ROOT;
-		cur_trans->delayed_refs.num_entries = 0;
-		cur_trans->delayed_refs.num_heads_ready = 0;
-		cur_trans->delayed_refs.num_heads = 0;
-		cur_trans->delayed_refs.flushing = 0;
-		cur_trans->delayed_refs.run_delayed_start = 0;
-		spin_lock_init(&cur_trans->delayed_refs.lock);
-
-		INIT_LIST_HEAD(&cur_trans->pending_snapshots);
-		list_add_tail(&cur_trans->list, &root->fs_info->trans_list);
-		extent_io_tree_init(&cur_trans->dirty_pages,
-				     root->fs_info->btree_inode->i_mapping,
-				     GFP_NOFS);
-		spin_lock(&root->fs_info->new_trans_lock);
-		root->fs_info->running_transaction = cur_trans;
-		spin_unlock(&root->fs_info->new_trans_lock);
-	} else {
+	if (cur_trans) {
+		atomic_inc(&cur_trans->use_count);
+		atomic_inc(&cur_trans->num_writers);
+		cur_trans->num_joined++;
+		spin_unlock(&root->fs_info->trans_lock);
+		return 0;
+	}
+	spin_unlock(&root->fs_info->trans_lock);
+
+	cur_trans = kmem_cache_alloc(btrfs_transaction_cachep, GFP_NOFS);
+	if (!cur_trans)
+		return -ENOMEM;
+	spin_lock(&root->fs_info->trans_lock);
+	if (root->fs_info->running_transaction) {
+		kmem_cache_free(btrfs_transaction_cachep, cur_trans);
+		cur_trans = root->fs_info->running_transaction;
+		atomic_inc(&cur_trans->use_count);
 		atomic_inc(&cur_trans->num_writers);
 		cur_trans->num_joined++;
+		spin_unlock(&root->fs_info->trans_lock);
+		return 0;
 	}
+	atomic_set(&cur_trans->num_writers, 1);
+	cur_trans->num_joined = 0;
+	init_waitqueue_head(&cur_trans->writer_wait);
+	init_waitqueue_head(&cur_trans->commit_wait);
+	cur_trans->in_commit = 0;
+	cur_trans->blocked = 0;
+	/*
+	 * One for this trans handle, one so it will live on until we
+	 * commit the transaction.
+	 */
+	atomic_set(&cur_trans->use_count, 2);
+	cur_trans->commit_done = 0;
+	cur_trans->start_time = get_seconds();
+
+	cur_trans->delayed_refs.root = RB_ROOT;
+	cur_trans->delayed_refs.num_entries = 0;
+	cur_trans->delayed_refs.num_heads_ready = 0;
+	cur_trans->delayed_refs.num_heads = 0;
+	cur_trans->delayed_refs.flushing = 0;
+	cur_trans->delayed_refs.run_delayed_start = 0;
+	spin_lock_init(&cur_trans->commit_lock);
+	spin_lock_init(&cur_trans->delayed_refs.lock);
+
+	INIT_LIST_HEAD(&cur_trans->pending_snapshots);
+	list_add_tail(&cur_trans->list, &root->fs_info->trans_list);
+	extent_io_tree_init(&cur_trans->dirty_pages,
+			     root->fs_info->btree_inode->i_mapping,
+			     GFP_NOFS);
+	root->fs_info->generation++;
+	cur_trans->transid = root->fs_info->generation;
+	root->fs_info->running_transaction = cur_trans;
+	spin_unlock(&root->fs_info->trans_lock);
 
 	return 0;
 }
@@ -99,39 +126,28 @@ static noinline int join_transaction(struct btrfs_root *root)
  * to make sure the old root from before we joined the transaction is deleted
  * when the transaction commits
  */
-static noinline int record_root_in_trans(struct btrfs_trans_handle *trans,
-					 struct btrfs_root *root)
+int btrfs_record_root_in_trans(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *root)
 {
 	if (root->ref_cows && root->last_trans < trans->transid) {
 		WARN_ON(root == root->fs_info->extent_root);
 		WARN_ON(root->commit_root != root->node);
 
+		spin_lock(&root->fs_info->fs_roots_radix_lock);
+		if (root->last_trans == trans->transid) {
+			spin_unlock(&root->fs_info->fs_roots_radix_lock);
+			return 0;
+		}
+		root->last_trans = trans->transid;
 		radix_tree_tag_set(&root->fs_info->fs_roots_radix,
 			   (unsigned long)root->root_key.objectid,
 			   BTRFS_ROOT_TRANS_TAG);
-		root->last_trans = trans->transid;
+		spin_unlock(&root->fs_info->fs_roots_radix_lock);
 		btrfs_init_reloc_root(trans, root);
 	}
 	return 0;
 }
 
-int btrfs_record_root_in_trans(struct btrfs_trans_handle *trans,
-			       struct btrfs_root *root)
-{
-	if (!root->ref_cows)
-		return 0;
-
-	mutex_lock(&root->fs_info->trans_mutex);
-	if (root->last_trans == trans->transid) {
-		mutex_unlock(&root->fs_info->trans_mutex);
-		return 0;
-	}
-
-	record_root_in_trans(trans, root);
-	mutex_unlock(&root->fs_info->trans_mutex);
-	return 0;
-}
-
 /* wait for commit against the current transaction to become unblocked
  * when this is done, it is safe to start a new transaction, but the current
  * transaction might not be fully on disk.
@@ -140,21 +156,23 @@ static void wait_current_trans(struct btrfs_root *root)
 {
 	struct btrfs_transaction *cur_trans;
 
+	spin_lock(&root->fs_info->trans_lock);
 	cur_trans = root->fs_info->running_transaction;
 	if (cur_trans && cur_trans->blocked) {
 		DEFINE_WAIT(wait);
 		atomic_inc(&cur_trans->use_count);
+		spin_unlock(&root->fs_info->trans_lock);
 		while (1) {
 			prepare_to_wait(&root->fs_info->transaction_wait, &wait,
 					TASK_UNINTERRUPTIBLE);
 			if (!cur_trans->blocked)
 				break;
-			mutex_unlock(&root->fs_info->trans_mutex);
 			schedule();
-			mutex_lock(&root->fs_info->trans_mutex);
 		}
 		finish_wait(&root->fs_info->transaction_wait, &wait);
 		put_transaction(cur_trans);
+	} else {
+		spin_unlock(&root->fs_info->trans_lock);
 	}
 }
 
@@ -167,10 +185,16 @@ enum btrfs_trans_type {
 
 static int may_wait_transaction(struct btrfs_root *root, int type)
 {
-	if (!root->fs_info->log_root_recovering &&
-	    ((type == TRANS_START && !root->fs_info->open_ioctl_trans) ||
-	     type == TRANS_USERSPACE))
+	if (root->fs_info->log_root_recovering)
+		return 0;
+
+	if (type == TRANS_USERSPACE)
+		return 1;
+
+	if (type == TRANS_START &&
+	    !atomic_read(&root->fs_info->open_ioctl_trans))
 		return 1;
+
 	return 0;
 }
 
@@ -198,23 +222,21 @@ again:
 	if (!h)
 		return ERR_PTR(-ENOMEM);
 
-	if (type != TRANS_JOIN_NOLOCK)
-		mutex_lock(&root->fs_info->trans_mutex);
 	if (may_wait_transaction(root, type))
 		wait_current_trans(root);
 
-	ret = join_transaction(root);
+	do {
+		ret = join_transaction(root, type == TRANS_JOIN_NOLOCK);
+		if (ret == -EBUSY)
+			wait_current_trans(root);
+	} while (ret == -EBUSY);
+
 	if (ret < 0) {
 		kmem_cache_free(btrfs_trans_handle_cachep, h);
-		if (type != TRANS_JOIN_NOLOCK)
-			mutex_unlock(&root->fs_info->trans_mutex);
 		return ERR_PTR(ret);
 	}
 
 	cur_trans = root->fs_info->running_transaction;
-	atomic_inc(&cur_trans->use_count);
-	if (type != TRANS_JOIN_NOLOCK)
-		mutex_unlock(&root->fs_info->trans_mutex);
 
 	h->transid = cur_trans->transid;
 	h->transaction = cur_trans;
@@ -253,11 +275,7 @@ again:
 	}
 
 got_it:
-	if (type != TRANS_JOIN_NOLOCK)
-		mutex_lock(&root->fs_info->trans_mutex);
-	record_root_in_trans(h, root);
-	if (type != TRANS_JOIN_NOLOCK)
-		mutex_unlock(&root->fs_info->trans_mutex);
+	btrfs_record_root_in_trans(h, root);
 
 	if (!current->journal_info && type != TRANS_USERSPACE)
 		current->journal_info = h;
@@ -289,17 +307,13 @@ static noinline int wait_for_commit(struct btrfs_root *root,
 				    struct btrfs_transaction *commit)
 {
 	DEFINE_WAIT(wait);
-	mutex_lock(&root->fs_info->trans_mutex);
 	while (!commit->commit_done) {
 		prepare_to_wait(&commit->commit_wait, &wait,
 				TASK_UNINTERRUPTIBLE);
 		if (commit->commit_done)
 			break;
-		mutex_unlock(&root->fs_info->trans_mutex);
 		schedule();
-		mutex_lock(&root->fs_info->trans_mutex);
 	}
-	mutex_unlock(&root->fs_info->trans_mutex);
 	finish_wait(&commit->commit_wait, &wait);
 	return 0;
 }
@@ -309,50 +323,49 @@ int btrfs_wait_for_commit(struct btrfs_root *root, u64 transid)
 	struct btrfs_transaction *cur_trans = NULL, *t;
 	int ret;
 
-	mutex_lock(&root->fs_info->trans_mutex);
-
 	ret = 0;
 	if (transid) {
 		if (transid <= root->fs_info->last_trans_committed)
-			goto out_unlock;
+			goto out;
 
 		/* find specified transaction */
+		spin_lock(&root->fs_info->trans_lock);
 		list_for_each_entry(t, &root->fs_info->trans_list, list) {
 			if (t->transid == transid) {
 				cur_trans = t;
+				atomic_inc(&cur_trans->use_count);
 				break;
 			}
 			if (t->transid > transid)
 				break;
 		}
+		spin_unlock(&root->fs_info->trans_lock);
 		ret = -EINVAL;
 		if (!cur_trans)
-			goto out_unlock;  /* bad transid */
+			goto out;  /* bad transid */
 	} else {
 		/* find newest transaction that is committing | committed */
+		spin_lock(&root->fs_info->trans_lock);
 		list_for_each_entry_reverse(t, &root->fs_info->trans_list,
 					    list) {
 			if (t->in_commit) {
 				if (t->commit_done)
-					goto out_unlock;
+					goto out;
 				cur_trans = t;
+				atomic_inc(&cur_trans->use_count);
 				break;
 			}
 		}
+		spin_unlock(&root->fs_info->trans_lock);
 		if (!cur_trans)
-			goto out_unlock;  /* nothing committing|committed */
+			goto out;  /* nothing committing|committed */
 	}
 
-	atomic_inc(&cur_trans->use_count);
-	mutex_unlock(&root->fs_info->trans_mutex);
-
 	wait_for_commit(root, cur_trans);
 
-	mutex_lock(&root->fs_info->trans_mutex);
 	put_transaction(cur_trans);
 	ret = 0;
-out_unlock:
-	mutex_unlock(&root->fs_info->trans_mutex);
+out:
 	return ret;
 }
 
@@ -401,10 +414,8 @@ harder:
 
 void btrfs_throttle(struct btrfs_root *root)
 {
-	mutex_lock(&root->fs_info->trans_mutex);
-	if (!root->fs_info->open_ioctl_trans)
+	if (!atomic_read(&root->fs_info->open_ioctl_trans))
 		wait_current_trans(root);
-	mutex_unlock(&root->fs_info->trans_mutex);
 }
 
 static int should_end_transaction(struct btrfs_trans_handle *trans,
@@ -422,6 +433,7 @@ int btrfs_should_end_transaction(struct btrfs_trans_handle *trans,
 	struct btrfs_transaction *cur_trans = trans->transaction;
 	int updates;
 
+	smp_mb();
 	if (cur_trans->blocked || cur_trans->delayed_refs.flushing)
 		return 1;
 
@@ -467,9 +479,11 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 
 	btrfs_trans_release_metadata(trans, root);
 
-	if (lock && !root->fs_info->open_ioctl_trans &&
-	    should_end_transaction(trans, root))
+	if (lock && !atomic_read(&root->fs_info->open_ioctl_trans) &&
+	    should_end_transaction(trans, root)) {
 		trans->transaction->blocked = 1;
+		smp_wmb();
+	}
 
 	if (lock && cur_trans->blocked && !cur_trans->in_commit) {
 		if (throttle)
@@ -739,9 +753,9 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans,
  */
 int btrfs_add_dead_root(struct btrfs_root *root)
 {
-	mutex_lock(&root->fs_info->trans_mutex);
+	spin_lock(&root->fs_info->trans_lock);
 	list_add(&root->root_list, &root->fs_info->dead_roots);
-	mutex_unlock(&root->fs_info->trans_mutex);
+	spin_unlock(&root->fs_info->trans_lock);
 	return 0;
 }
 
@@ -757,6 +771,7 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans,
 	int ret;
 	int err = 0;
 
+	spin_lock(&fs_info->fs_roots_radix_lock);
 	while (1) {
 		ret = radix_tree_gang_lookup_tag(&fs_info->fs_roots_radix,
 						 (void **)gang, 0,
@@ -769,6 +784,7 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans,
 			radix_tree_tag_clear(&fs_info->fs_roots_radix,
 					(unsigned long)root->root_key.objectid,
 					BTRFS_ROOT_TRANS_TAG);
+			spin_unlock(&fs_info->fs_roots_radix_lock);
 
 			btrfs_free_log(trans, root);
 			btrfs_update_reloc_root(trans, root);
@@ -783,10 +799,12 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans,
 			err = btrfs_update_root(trans, fs_info->tree_root,
 						&root->root_key,
 						&root->root_item);
+			spin_lock(&fs_info->fs_roots_radix_lock);
 			if (err)
 				break;
 		}
 	}
+	spin_unlock(&fs_info->fs_roots_radix_lock);
 	return err;
 }
 
@@ -972,7 +990,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	parent = dget_parent(dentry);
 	parent_inode = parent->d_inode;
 	parent_root = BTRFS_I(parent_inode)->root;
-	record_root_in_trans(trans, parent_root);
+	btrfs_record_root_in_trans(trans, parent_root);
 
 	/*
 	 * insert the directory item
@@ -990,7 +1008,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	ret = btrfs_update_inode(trans, parent_root, parent_inode);
 	BUG_ON(ret);
 
-	record_root_in_trans(trans, root);
+	btrfs_record_root_in_trans(trans, root);
 	btrfs_set_root_last_snapshot(&root->root_item, trans->transid);
 	memcpy(new_root_item, &root->root_item, sizeof(*new_root_item));
 	btrfs_check_and_init_root_item(new_root_item);
@@ -1080,20 +1098,20 @@ static void update_super_roots(struct btrfs_root *root)
 int btrfs_transaction_in_commit(struct btrfs_fs_info *info)
 {
 	int ret = 0;
-	spin_lock(&info->new_trans_lock);
+	spin_lock(&info->trans_lock);
 	if (info->running_transaction)
 		ret = info->running_transaction->in_commit;
-	spin_unlock(&info->new_trans_lock);
+	spin_unlock(&info->trans_lock);
 	return ret;
 }
 
 int btrfs_transaction_blocked(struct btrfs_fs_info *info)
 {
 	int ret = 0;
-	spin_lock(&info->new_trans_lock);
+	spin_lock(&info->trans_lock);
 	if (info->running_transaction)
 		ret = info->running_transaction->blocked;
-	spin_unlock(&info->new_trans_lock);
+	spin_unlock(&info->trans_lock);
 	return ret;
 }
 
@@ -1117,9 +1135,7 @@ static void wait_current_trans_commit_start(struct btrfs_root *root,
 				    &wait);
 			break;
 		}
-		mutex_unlock(&root->fs_info->trans_mutex);
 		schedule();
-		mutex_lock(&root->fs_info->trans_mutex);
 		finish_wait(&root->fs_info->transaction_blocked_wait, &wait);
 	}
 }
@@ -1145,9 +1161,7 @@ static void wait_current_trans_commit_start_and_unblock(struct btrfs_root *root,
 				    &wait);
 			break;
 		}
-		mutex_unlock(&root->fs_info->trans_mutex);
 		schedule();
-		mutex_lock(&root->fs_info->trans_mutex);
 		finish_wait(&root->fs_info->transaction_wait,
 			    &wait);
 	}
@@ -1193,22 +1207,18 @@ int btrfs_commit_transaction_async(struct btrfs_trans_handle *trans,
 	}
 
 	/* take transaction reference */
-	mutex_lock(&root->fs_info->trans_mutex);
 	cur_trans = trans->transaction;
 	atomic_inc(&cur_trans->use_count);
-	mutex_unlock(&root->fs_info->trans_mutex);
 
 	btrfs_end_transaction(trans, root);
 	schedule_delayed_work(&ac->work, 0);
 
 	/* wait for transaction to start and unblock */
-	mutex_lock(&root->fs_info->trans_mutex);
 	if (wait_for_unblock)
 		wait_current_trans_commit_start_and_unblock(root, cur_trans);
 	else
 		wait_current_trans_commit_start(root, cur_trans);
 	put_transaction(cur_trans);
-	mutex_unlock(&root->fs_info->trans_mutex);
 
 	return 0;
 }
@@ -1252,38 +1262,41 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	ret = btrfs_run_delayed_refs(trans, root, 0);
 	BUG_ON(ret);
 
-	mutex_lock(&root->fs_info->trans_mutex);
+	spin_lock(&cur_trans->commit_lock);
 	if (cur_trans->in_commit) {
+		spin_unlock(&cur_trans->commit_lock);
 		atomic_inc(&cur_trans->use_count);
-		mutex_unlock(&root->fs_info->trans_mutex);
 		btrfs_end_transaction(trans, root);
 
 		ret = wait_for_commit(root, cur_trans);
 		BUG_ON(ret);
 
-		mutex_lock(&root->fs_info->trans_mutex);
 		put_transaction(cur_trans);
-		mutex_unlock(&root->fs_info->trans_mutex);
 
 		return 0;
 	}
 
 	trans->transaction->in_commit = 1;
 	trans->transaction->blocked = 1;
+	spin_unlock(&cur_trans->commit_lock);
 	wake_up(&root->fs_info->transaction_blocked_wait);
 
+	spin_lock(&root->fs_info->trans_lock);
 	if (cur_trans->list.prev != &root->fs_info->trans_list) {
 		prev_trans = list_entry(cur_trans->list.prev,
 					struct btrfs_transaction, list);
 		if (!prev_trans->commit_done) {
 			atomic_inc(&prev_trans->use_count);
-			mutex_unlock(&root->fs_info->trans_mutex);
+			spin_unlock(&root->fs_info->trans_lock);
 
 			wait_for_commit(root, prev_trans);
 
-			mutex_lock(&root->fs_info->trans_mutex);
 			put_transaction(prev_trans);
+		} else {
+			spin_unlock(&root->fs_info->trans_lock);
 		}
+	} else {
+		spin_unlock(&root->fs_info->trans_lock);
 	}
 
 	if (now < cur_trans->start_time || now - cur_trans->start_time < 1)
@@ -1291,12 +1304,12 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 
 	do {
 		int snap_pending = 0;
+
 		joined = cur_trans->num_joined;
 		if (!list_empty(&trans->transaction->pending_snapshots))
 			snap_pending = 1;
 
 		WARN_ON(cur_trans != trans->transaction);
-		mutex_unlock(&root->fs_info->trans_mutex);
 
 		if (flush_on_commit || snap_pending) {
 			btrfs_start_delalloc_inodes(root, 1);
@@ -1316,14 +1329,15 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 		prepare_to_wait(&cur_trans->writer_wait, &wait,
 				TASK_UNINTERRUPTIBLE);
 
-		smp_mb();
 		if (atomic_read(&cur_trans->num_writers) > 1)
 			schedule_timeout(MAX_SCHEDULE_TIMEOUT);
 		else if (should_grow)
 			schedule_timeout(1);
 
-		mutex_lock(&root->fs_info->trans_mutex);
 		finish_wait(&cur_trans->writer_wait, &wait);
+		spin_lock(&root->fs_info->trans_lock);
+		root->fs_info->trans_no_join = 1;
+		spin_unlock(&root->fs_info->trans_lock);
 	} while (atomic_read(&cur_trans->num_writers) > 1 ||
 		 (should_grow && cur_trans->num_joined != joined));
 
@@ -1364,9 +1378,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	btrfs_prepare_extent_commit(trans, root);
 
 	cur_trans = root->fs_info->running_transaction;
-	spin_lock(&root->fs_info->new_trans_lock);
-	root->fs_info->running_transaction = NULL;
-	spin_unlock(&root->fs_info->new_trans_lock);
 
 	btrfs_set_root_node(&root->fs_info->tree_root->root_item,
 			    root->fs_info->tree_root->node);
@@ -1387,10 +1398,13 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	       sizeof(root->fs_info->super_copy));
 
 	trans->transaction->blocked = 0;
+	spin_lock(&root->fs_info->trans_lock);
+	root->fs_info->running_transaction = NULL;
+	root->fs_info->trans_no_join = 0;
+	spin_unlock(&root->fs_info->trans_lock);
 
 	wake_up(&root->fs_info->transaction_wait);
 
-	mutex_unlock(&root->fs_info->trans_mutex);
 	ret = btrfs_write_and_wait_transaction(trans, root);
 	BUG_ON(ret);
 	write_ctree_super(trans, root, 0);
@@ -1403,22 +1417,21 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 
 	btrfs_finish_extent_commit(trans, root);
 
-	mutex_lock(&root->fs_info->trans_mutex);
-
 	cur_trans->commit_done = 1;
 
 	root->fs_info->last_trans_committed = cur_trans->transid;
 
 	wake_up(&cur_trans->commit_wait);
 
+	spin_lock(&root->fs_info->trans_lock);
 	list_del_init(&cur_trans->list);
+	spin_unlock(&root->fs_info->trans_lock);
+
 	put_transaction(cur_trans);
 	put_transaction(cur_trans);
 
 	trace_btrfs_transaction_commit(root);
 
-	mutex_unlock(&root->fs_info->trans_mutex);
-
 	if (current->journal_info == trans)
 		current->journal_info = NULL;
 
@@ -1438,9 +1451,9 @@ int btrfs_clean_old_snapshots(struct btrfs_root *root)
 	LIST_HEAD(list);
 	struct btrfs_fs_info *fs_info = root->fs_info;
 
-	mutex_lock(&fs_info->trans_mutex);
+	spin_lock(&fs_info->trans_lock);
 	list_splice_init(&fs_info->dead_roots, &list);
-	mutex_unlock(&fs_info->trans_mutex);
+	spin_unlock(&fs_info->trans_lock);
 
 	while (!list_empty(&list)) {
 		root = list_entry(list.next, struct btrfs_root, root_list);
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 154314f..11c6efc 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -28,10 +28,12 @@ struct btrfs_transaction {
 	 * transaction can end
 	 */
 	atomic_t num_writers;
+	atomic_t use_count;
 
 	unsigned long num_joined;
+
+	spinlock_t commit_lock;
 	int in_commit;
-	atomic_t use_count;
 	int commit_done;
 	int blocked;
 	struct list_head list;
-- 
1.7.2.3

