From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 01/12] Btrfs: introduce sub transaction stuff
Date: Thu, 30 Jun 2011 15:36:21 +0800
Message-ID: <1309419392-17770-2-git-send-email-liubo2009@cn.fujitsu.com>
References: <1309419392-17770-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <dave@jikos.cz>, <chris.mason@oracle.com>, <josef@redhat.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1309419392-17770-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new concept "sub transaction",
the relation between transaction and sub transaction is

transaction A       ---> transid = x
   sub trans a(1)   ---> sub_transid = x+1
   sub trans a(2)   ---> sub_transid = x+2
     ... ...
   sub trans a(n-1) ---> sub_transid = x+n-1
   sub trans a(n)   ---> sub_transid = x+n
transaction B       ---> transid = x+n+1
     ... ...

And the most important is
a) a trans handler's transid now gets value from sub transid instead of transid.
b) when a transaction commits, transid may not added by 1, but depend on the
   biggest sub_transaction of the last neighbour transaction,
   i.e.
        B->transid = a(n)->transid + 1,
        (B->transid - A->transid) >= 1
c) we start a new sub transaction after a fsync.

We also ship some 'trans->transid' to 'trans->transaction->transid' to
ensure btrfs works well and to get rid of WARNings.

These are used for the new log code.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/ctree.c       |   35 ++++++++++++++++++-----------------
 fs/btrfs/ctree.h       |    1 +
 fs/btrfs/disk-io.c     |    7 ++++---
 fs/btrfs/extent-tree.c |   10 ++++++----
 fs/btrfs/inode.c       |    4 ++--
 fs/btrfs/ioctl.c       |    2 +-
 fs/btrfs/relocation.c  |    6 +++---
 fs/btrfs/transaction.c |   13 ++++++++-----
 fs/btrfs/transaction.h |    1 +
 fs/btrfs/tree-defrag.c |    2 +-
 fs/btrfs/tree-log.c    |   16 ++++++++++++++--
 11 files changed, 59 insertions(+), 38 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 2e66786..f35b517 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -194,9 +194,9 @@ int btrfs_copy_root(struct btrfs_trans_handle *trans,
 	int level;
 	struct btrfs_disk_key disk_key;
 
-	WARN_ON(root->ref_cows && trans->transid !=
+	WARN_ON(root->ref_cows && trans->transaction->transid !=
 		root->fs_info->running_transaction->transid);
-	WARN_ON(root->ref_cows && trans->transid != root->last_trans);
+	WARN_ON(root->ref_cows && trans->transid < root->last_trans);
 
 	level = btrfs_header_level(buf);
 	if (level == 0)
@@ -391,9 +391,9 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 
 	btrfs_assert_tree_locked(buf);
 
-	WARN_ON(root->ref_cows && trans->transid !=
+	WARN_ON(root->ref_cows && trans->transaction->transid !=
 		root->fs_info->running_transaction->transid);
-	WARN_ON(root->ref_cows && trans->transid != root->last_trans);
+	WARN_ON(root->ref_cows && trans->transid < root->last_trans);
 
 	level = btrfs_header_level(buf);
 
@@ -459,7 +459,8 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 		else
 			parent_start = 0;
 
-		WARN_ON(trans->transid != btrfs_header_generation(parent));
+		WARN_ON(btrfs_header_generation(parent) <
+						trans->transaction->transid);
 		btrfs_set_node_blockptr(parent, parent_slot,
 					cow->start);
 		btrfs_set_node_ptr_generation(parent, parent_slot,
@@ -480,7 +481,7 @@ static inline int should_cow_block(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root,
 				   struct extent_buffer *buf)
 {
-	if (btrfs_header_generation(buf) == trans->transid &&
+	if (btrfs_header_generation(buf) >= trans->transaction->transid &&
 	    !btrfs_header_flag(buf, BTRFS_HEADER_FLAG_WRITTEN) &&
 	    !(root->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID &&
 	      btrfs_header_flag(buf, BTRFS_HEADER_FLAG_RELOC)))
@@ -508,7 +509,7 @@ noinline int btrfs_cow_block(struct btrfs_trans_handle *trans,
 		       root->fs_info->running_transaction->transid);
 		WARN_ON(1);
 	}
-	if (trans->transid != root->fs_info->generation) {
+	if (trans->transaction->transid != root->fs_info->generation) {
 		printk(KERN_CRIT "trans %llu running %llu\n",
 		       (unsigned long long)trans->transid,
 		       (unsigned long long)root->fs_info->generation);
@@ -611,7 +612,7 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 
 	if (trans->transaction != root->fs_info->running_transaction)
 		WARN_ON(1);
-	if (trans->transid != root->fs_info->generation)
+	if (trans->transaction->transid != root->fs_info->generation)
 		WARN_ON(1);
 
 	parent_nritems = btrfs_header_nritems(parent);
@@ -891,7 +892,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 	mid = path->nodes[level];
 
 	WARN_ON(!path->locks[level]);
-	WARN_ON(btrfs_header_generation(mid) != trans->transid);
+	WARN_ON(btrfs_header_generation(mid) < trans->transaction->transid);
 
 	orig_ptr = btrfs_node_blockptr(mid, orig_slot);
 
@@ -1098,7 +1099,7 @@ static noinline int push_nodes_for_insert(struct btrfs_trans_handle *trans,
 		return 1;
 
 	mid = path->nodes[level];
-	WARN_ON(btrfs_header_generation(mid) != trans->transid);
+	WARN_ON(btrfs_header_generation(mid) < trans->transaction->transid);
 
 	if (level < BTRFS_MAX_LEVEL - 1)
 		parent = path->nodes[level + 1];
@@ -1855,8 +1856,8 @@ static int push_node_left(struct btrfs_trans_handle *trans,
 	src_nritems = btrfs_header_nritems(src);
 	dst_nritems = btrfs_header_nritems(dst);
 	push_items = BTRFS_NODEPTRS_PER_BLOCK(root) - dst_nritems;
-	WARN_ON(btrfs_header_generation(src) != trans->transid);
-	WARN_ON(btrfs_header_generation(dst) != trans->transid);
+	WARN_ON(btrfs_header_generation(src) < trans->transaction->transid);
+	WARN_ON(btrfs_header_generation(dst) < trans->transaction->transid);
 
 	if (!empty && src_nritems <= 8)
 		return 1;
@@ -1918,8 +1919,8 @@ static int balance_node_right(struct btrfs_trans_handle *trans,
 	int dst_nritems;
 	int ret = 0;
 
-	WARN_ON(btrfs_header_generation(src) != trans->transid);
-	WARN_ON(btrfs_header_generation(dst) != trans->transid);
+	WARN_ON(btrfs_header_generation(src) < trans->transaction->transid);
+	WARN_ON(btrfs_header_generation(dst) < trans->transaction->transid);
 
 	src_nritems = btrfs_header_nritems(src);
 	dst_nritems = btrfs_header_nritems(dst);
@@ -2010,7 +2011,7 @@ static noinline int insert_new_root(struct btrfs_trans_handle *trans,
 	btrfs_set_node_key(c, &lower_key, 0);
 	btrfs_set_node_blockptr(c, 0, lower->start);
 	lower_gen = btrfs_header_generation(lower);
-	WARN_ON(lower_gen != trans->transid);
+	WARN_ON(lower_gen < trans->transaction->transid);
 
 	btrfs_set_node_ptr_generation(c, 0, lower_gen);
 
@@ -2090,7 +2091,7 @@ static noinline int split_node(struct btrfs_trans_handle *trans,
 	u32 c_nritems;
 
 	c = path->nodes[level];
-	WARN_ON(btrfs_header_generation(c) != trans->transid);
+	WARN_ON(btrfs_header_generation(c) < trans->transaction->transid);
 	if (c == root->node) {
 		/* trying to split the root, lets make a new one */
 		ret = insert_new_root(trans, root, path, level + 1);
@@ -3788,7 +3789,7 @@ static noinline int btrfs_del_leaf(struct btrfs_trans_handle *trans,
 {
 	int ret;
 
-	WARN_ON(btrfs_header_generation(leaf) != trans->transid);
+	WARN_ON(btrfs_header_generation(leaf) < trans->transaction->transid);
 	ret = del_ptr(trans, root, path, 1, path->slots[1]);
 	if (ret)
 		return ret;
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8e948ec..54fcc62 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -923,6 +923,7 @@ struct btrfs_fs_info {
 	struct mutex durable_block_rsv_mutex;
 
 	u64 generation;
+	u64 sub_generation;
 	u64 last_trans_committed;
 
 	/*
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1ac8db5..b7e80c3 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1001,7 +1001,7 @@ int clean_tree_block(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		     struct extent_buffer *buf)
 {
 	struct inode *btree_inode = root->fs_info->btree_inode;
-	if (btrfs_header_generation(buf) ==
+	if (btrfs_header_generation(buf) >=
 	    root->fs_info->running_transaction->transid) {
 		btrfs_assert_tree_locked(buf);
 
@@ -1525,7 +1525,7 @@ static int transaction_kthread(void *arg)
 
 		trans = btrfs_join_transaction(root);
 		BUG_ON(IS_ERR(trans));
-		if (transid == trans->transid) {
+		if (transid == trans->transaction->transid) {
 			ret = btrfs_commit_transaction(trans, root);
 			BUG_ON(ret);
 		} else {
@@ -1963,6 +1963,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	csum_root->track_dirty = 1;
 
 	fs_info->generation = generation;
+	fs_info->sub_generation = generation;
 	fs_info->last_trans_committed = generation;
 	fs_info->data_alloc_profile = (u64)-1;
 	fs_info->metadata_alloc_profile = (u64)-1;
@@ -2631,7 +2632,7 @@ void btrfs_mark_buffer_dirty(struct extent_buffer *buf)
 	int was_dirty;
 
 	btrfs_assert_tree_locked(buf);
-	if (transid != root->fs_info->generation) {
+	if (transid < root->fs_info->generation) {
 		printk(KERN_CRIT "btrfs transid mismatch buffer %llu, "
 		       "found %llu running %llu\n",
 			(unsigned long long)buf->start,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 1f61bf5..dbd94c8 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4345,7 +4345,7 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 	list_for_each_entry_safe(block_rsv, next_rsv,
 				 &fs_info->durable_block_rsv_list, list) {
 
-		idx = trans->transid & 0x1;
+		idx = trans->transaction->transid & 0x1;
 		if (block_rsv->freed[idx] > 0) {
 			block_rsv_add_bytes(block_rsv,
 					    block_rsv->freed[idx], 0);
@@ -4660,7 +4660,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 	if (block_rsv->space_info != cache->space_info)
 		goto out;
 
-	if (btrfs_header_generation(buf) == trans->transid) {
+	if (btrfs_header_generation(buf) >= trans->transaction->transid) {
 		if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID) {
 			ret = check_ref_cleanup(trans, root, buf->start);
 			if (!ret)
@@ -4710,7 +4710,8 @@ pin:
 
 		if (ret) {
 			spin_lock(&block_rsv->lock);
-			block_rsv->freed[trans->transid & 0x1] += buf->len;
+			block_rsv->freed[trans->transaction->transid & 0x1] +=
+								       buf->len;
 			spin_unlock(&block_rsv->lock);
 		}
 	}
@@ -6147,7 +6148,8 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
 		}
 		/* make block locked assertion in clean_tree_block happy */
 		if (!path->locks[level] &&
-		    btrfs_header_generation(eb) == trans->transid) {
+		    btrfs_header_generation(eb) >=
+						 trans->transaction->transid) {
 			btrfs_tree_lock(eb);
 			btrfs_set_lock_blocking(eb);
 			path->locks[level] = 1;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5813dec..6291445 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2107,7 +2107,7 @@ void btrfs_orphan_pre_snapshot(struct btrfs_trans_handle *trans,
 	 * space than it frees. So we should make sure there is enough
 	 * reserved space.
 	 */
-	index = trans->transid & 0x1;
+	index = trans->transaction->transid & 0x1;
 	if (block_rsv->reserved + block_rsv->freed[index] < block_rsv->size) {
 		num_bytes += block_rsv->size -
 			     (block_rsv->reserved + block_rsv->freed[index]);
@@ -2131,7 +2131,7 @@ void btrfs_orphan_post_snapshot(struct btrfs_trans_handle *trans,
 
 	/* refill source subvolume's orphan block reservation */
 	block_rsv = root->orphan_block_rsv;
-	index = trans->transid & 0x1;
+	index = trans->transaction->transid & 0x1;
 	if (block_rsv->reserved + block_rsv->freed[index] < block_rsv->size) {
 		num_bytes = block_rsv->size -
 			    (block_rsv->reserved + block_rsv->freed[index]);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a3c4751..29026a7 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2757,7 +2757,7 @@ static noinline long btrfs_ioctl_start_sync(struct file *file, void __user *argp
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
-	transid = trans->transid;
+	transid = trans->transaction->transid;
 	ret = btrfs_commit_transaction_async(trans, root, 0);
 	if (ret) {
 		btrfs_end_transaction(trans, root);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 086b1e6..759cc47 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -469,7 +469,7 @@ static int update_backref_cache(struct btrfs_trans_handle *trans,
 		return 0;
 	}
 
-	if (cache->last_trans == trans->transid)
+	if (cache->last_trans >= trans->transaction->transid)
 		return 0;
 
 	/*
@@ -1281,7 +1281,7 @@ static struct btrfs_root *create_reloc_root(struct btrfs_trans_handle *trans,
 		BUG_ON(ret);
 
 		btrfs_set_root_last_snapshot(&root->root_item,
-					     trans->transid - 1);
+					     trans->transaction->transid - 1);
 	} else {
 		/*
 		 * called by btrfs_reloc_post_snapshot_hook.
@@ -2271,7 +2271,7 @@ static int record_reloc_root_in_trans(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_root *root;
 
-	if (reloc_root->last_trans == trans->transid)
+	if (reloc_root->last_trans >= trans->transaction->transid)
 		return 0;
 
 	root = read_fs_root(reloc_root->fs_info, reloc_root->root_key.offset);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 51dcec8..5e96887 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -113,7 +113,9 @@ static noinline int join_transaction(struct btrfs_root *root, int nofail)
 	extent_io_tree_init(&cur_trans->dirty_pages,
 			     root->fs_info->btree_inode->i_mapping);
 	root->fs_info->generation++;
+	root->fs_info->sub_generation = root->fs_info->generation;
 	cur_trans->transid = root->fs_info->generation;
+	cur_trans->sub_transid = cur_trans->transid;
 	root->fs_info->running_transaction = cur_trans;
 	spin_unlock(&root->fs_info->trans_lock);
 
@@ -129,7 +131,7 @@ static noinline int join_transaction(struct btrfs_root *root, int nofail)
 static int record_root_in_trans(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root)
 {
-	if (root->ref_cows && root->last_trans < trans->transid) {
+	if (root->ref_cows && root->last_trans < trans->transaction->transid) {
 		WARN_ON(root == root->fs_info->extent_root);
 		WARN_ON(root->commit_root != root->node);
 
@@ -146,7 +148,7 @@ static int record_root_in_trans(struct btrfs_trans_handle *trans,
 		smp_wmb();
 
 		spin_lock(&root->fs_info->fs_roots_radix_lock);
-		if (root->last_trans == trans->transid) {
+		if (root->last_trans >= trans->transaction->transid) {
 			spin_unlock(&root->fs_info->fs_roots_radix_lock);
 			return 0;
 		}
@@ -194,7 +196,7 @@ int btrfs_record_root_in_trans(struct btrfs_trans_handle *trans,
 	 * and barriers
 	 */
 	smp_rmb();
-	if (root->last_trans == trans->transid &&
+	if (root->last_trans >= trans->transaction->transid &&
 	    !root->in_trans_setup)
 		return 0;
 
@@ -295,7 +297,7 @@ again:
 
 	cur_trans = root->fs_info->running_transaction;
 
-	h->transid = cur_trans->transid;
+	h->transid = cur_trans->sub_transid;
 	h->transaction = cur_trans;
 	h->blocks_used = 0;
 	h->bytes_reserved = 0;
@@ -1388,6 +1390,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 
 	trans->transaction->blocked = 0;
 	spin_lock(&root->fs_info->trans_lock);
+	root->fs_info->generation = cur_trans->sub_transid;
 	root->fs_info->running_transaction = NULL;
 	root->fs_info->trans_no_join = 0;
 	spin_unlock(&root->fs_info->trans_lock);
@@ -1409,7 +1412,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 
 	cur_trans->commit_done = 1;
 
-	root->fs_info->last_trans_committed = cur_trans->transid;
+	root->fs_info->last_trans_committed = cur_trans->sub_transid;
 
 	wake_up(&cur_trans->commit_wait);
 
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 02564e6..45876b0 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -23,6 +23,7 @@
 
 struct btrfs_transaction {
 	u64 transid;
+	u64 sub_transid;
 	/*
 	 * total writers in this transaction, it must be zero before the
 	 * transaction can end
diff --git a/fs/btrfs/tree-defrag.c b/fs/btrfs/tree-defrag.c
index 3b580ee..a2569af 100644
--- a/fs/btrfs/tree-defrag.c
+++ b/fs/btrfs/tree-defrag.c
@@ -139,7 +139,7 @@ done:
 	if (ret != -EAGAIN) {
 		memset(&root->defrag_progress, 0,
 		       sizeof(root->defrag_progress));
-		root->defrag_trans_start = trans->transid;
+		root->defrag_trans_start = trans->transaction->transid;
 	}
 	return ret;
 }
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 4ce8a9f..917fd07 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -134,9 +134,19 @@ static noinline int replay_dir_deletes(struct btrfs_trans_handle *trans,
 static int start_log_trans(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root)
 {
+	struct btrfs_transaction *cur_trans;
 	int ret;
 	int err = 0;
 
+	/* start a new sub transaction */
+	spin_lock(&root->fs_info->trans_lock);
+
+	cur_trans = root->fs_info->running_transaction;
+	cur_trans->sub_transid++;
+	root->fs_info->sub_generation = cur_trans->sub_transid;
+
+	spin_unlock(&root->fs_info->trans_lock);
+
 	mutex_lock(&root->log_mutex);
 	if (root->log_root) {
 		if (!root->log_start_pid) {
@@ -2001,7 +2011,8 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	}
 
 	/* bail out if we need to do a full commit */
-	if (root->fs_info->last_trans_log_full_commit == trans->transid) {
+	if (root->fs_info->last_trans_log_full_commit >=
+						trans->transaction->transid) {
 		ret = -EAGAIN;
 		mutex_unlock(&root->log_mutex);
 		goto out;
@@ -2078,7 +2089,8 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	 * now that we've moved on to the tree of log tree roots,
 	 * check the full commit flag again
 	 */
-	if (root->fs_info->last_trans_log_full_commit == trans->transid) {
+	if (root->fs_info->last_trans_log_full_commit >=
+						trans->transaction->transid) {
 		btrfs_wait_marked_extents(log, &log->dirty_log_pages, mark);
 		mutex_unlock(&log_root_tree->log_mutex);
 		ret = -EAGAIN;
-- 
1.6.5.2

