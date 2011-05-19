From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 1/9] Btrfs: introduce sub transaction stuff
Date: Thu, 19 May 2011 16:11:24 +0800
Message-ID: <1305792692-10635-2-git-send-email-liubo2009@cn.fujitsu.com>
References: <1305792692-10635-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <josef@redhat.com>, <chris.mason@oracle.com>,
	Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1305792692-10635-1-git-send-email-liubo2009@cn.fujitsu.com>
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
 fs/btrfs/transaction.c |   13 +++++++++----
 fs/btrfs/transaction.h |    1 +
 fs/btrfs/tree-defrag.c |    2 +-
 fs/btrfs/tree-log.c    |   16 ++++++++++++++--
 11 files changed, 60 insertions(+), 37 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 84d7ca1..0c3b515 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -201,9 +201,9 @@ int btrfs_copy_root(struct btrfs_trans_handle *trans,
 	int level;
 	struct btrfs_disk_key disk_key;
 
-	WARN_ON(root->ref_cows && trans->transid !=
+	WARN_ON(root->ref_cows && trans->transaction->transid !=
 		root->fs_info->running_transaction->transid);
-	WARN_ON(root->ref_cows && trans->transid != root->last_trans);
+	WARN_ON(root->ref_cows && trans->transid < root->last_trans);
 
 	level = btrfs_header_level(buf);
 	if (level == 0)
@@ -398,9 +398,9 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 
 	btrfs_assert_tree_locked(buf);
 
-	WARN_ON(root->ref_cows && trans->transid !=
+	WARN_ON(root->ref_cows && trans->transaction->transid !=
 		root->fs_info->running_transaction->transid);
-	WARN_ON(root->ref_cows && trans->transid != root->last_trans);
+	WARN_ON(root->ref_cows && trans->transid < root->last_trans);
 
 	level = btrfs_header_level(buf);
 
@@ -466,7 +466,8 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 		else
 			parent_start = 0;
 
-		WARN_ON(trans->transid != btrfs_header_generation(parent));
+		WARN_ON(btrfs_header_generation(parent) <
+						trans->transaction->transid);
 		btrfs_set_node_blockptr(parent, parent_slot,
 					cow->start);
 		btrfs_set_node_ptr_generation(parent, parent_slot,
@@ -487,7 +488,7 @@ static inline int should_cow_block(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root,
 				   struct extent_buffer *buf)
 {
-	if (btrfs_header_generation(buf) == trans->transid &&
+	if (btrfs_header_generation(buf) >= trans->transaction->transid &&
 	    !btrfs_header_flag(buf, BTRFS_HEADER_FLAG_WRITTEN) &&
 	    !(root->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID &&
 	      btrfs_header_flag(buf, BTRFS_HEADER_FLAG_RELOC)))
@@ -515,7 +516,7 @@ noinline int btrfs_cow_block(struct btrfs_trans_handle *trans,
 		       root->fs_info->running_transaction->transid);
 		WARN_ON(1);
 	}
-	if (trans->transid != root->fs_info->generation) {
+	if (trans->transaction->transid != root->fs_info->generation) {
 		printk(KERN_CRIT "trans %llu running %llu\n",
 		       (unsigned long long)trans->transid,
 		       (unsigned long long)root->fs_info->generation);
@@ -618,7 +619,7 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 
 	if (trans->transaction != root->fs_info->running_transaction)
 		WARN_ON(1);
-	if (trans->transid != root->fs_info->generation)
+	if (trans->transaction->transid != root->fs_info->generation)
 		WARN_ON(1);
 
 	parent_nritems = btrfs_header_nritems(parent);
@@ -898,7 +899,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 	mid = path->nodes[level];
 
 	WARN_ON(!path->locks[level]);
-	WARN_ON(btrfs_header_generation(mid) != trans->transid);
+	WARN_ON(btrfs_header_generation(mid) < trans->transaction->transid);
 
 	orig_ptr = btrfs_node_blockptr(mid, orig_slot);
 
@@ -1105,7 +1106,7 @@ static noinline int push_nodes_for_insert(struct btrfs_trans_handle *trans,
 		return 1;
 
 	mid = path->nodes[level];
-	WARN_ON(btrfs_header_generation(mid) != trans->transid);
+	WARN_ON(btrfs_header_generation(mid) < trans->transaction->transid);
 
 	if (level < BTRFS_MAX_LEVEL - 1)
 		parent = path->nodes[level + 1];
@@ -1842,8 +1843,8 @@ static int push_node_left(struct btrfs_trans_handle *trans,
 	src_nritems = btrfs_header_nritems(src);
 	dst_nritems = btrfs_header_nritems(dst);
 	push_items = BTRFS_NODEPTRS_PER_BLOCK(root) - dst_nritems;
-	WARN_ON(btrfs_header_generation(src) != trans->transid);
-	WARN_ON(btrfs_header_generation(dst) != trans->transid);
+	WARN_ON(btrfs_header_generation(src) < trans->transaction->transid);
+	WARN_ON(btrfs_header_generation(dst) < trans->transaction->transid);
 
 	if (!empty && src_nritems <= 8)
 		return 1;
@@ -1905,8 +1906,8 @@ static int balance_node_right(struct btrfs_trans_handle *trans,
 	int dst_nritems;
 	int ret = 0;
 
-	WARN_ON(btrfs_header_generation(src) != trans->transid);
-	WARN_ON(btrfs_header_generation(dst) != trans->transid);
+	WARN_ON(btrfs_header_generation(src) < trans->transaction->transid);
+	WARN_ON(btrfs_header_generation(dst) < trans->transaction->transid);
 
 	src_nritems = btrfs_header_nritems(src);
 	dst_nritems = btrfs_header_nritems(dst);
@@ -1997,7 +1998,7 @@ static noinline int insert_new_root(struct btrfs_trans_handle *trans,
 	btrfs_set_node_key(c, &lower_key, 0);
 	btrfs_set_node_blockptr(c, 0, lower->start);
 	lower_gen = btrfs_header_generation(lower);
-	WARN_ON(lower_gen != trans->transid);
+	WARN_ON(lower_gen < trans->transaction->transid);
 
 	btrfs_set_node_ptr_generation(c, 0, lower_gen);
 
@@ -2077,7 +2078,7 @@ static noinline int split_node(struct btrfs_trans_handle *trans,
 	u32 c_nritems;
 
 	c = path->nodes[level];
-	WARN_ON(btrfs_header_generation(c) != trans->transid);
+	WARN_ON(btrfs_header_generation(c) < trans->transaction->transid);
 	if (c == root->node) {
 		/* trying to split the root, lets make a new one */
 		ret = insert_new_root(trans, root, path, level + 1);
@@ -3781,7 +3782,7 @@ static noinline int btrfs_del_leaf(struct btrfs_trans_handle *trans,
 {
 	int ret;
 
-	WARN_ON(btrfs_header_generation(leaf) != trans->transid);
+	WARN_ON(btrfs_header_generation(leaf) < trans->transaction->transid);
 	ret = del_ptr(trans, root, path, 1, path->slots[1]);
 	if (ret)
 		return ret;
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2e61fe1..ef68108 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -912,6 +912,7 @@ struct btrfs_fs_info {
 	struct mutex durable_block_rsv_mutex;
 
 	u64 generation;
+	u64 sub_generation;
 	u64 last_trans_committed;
 
 	/*
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index ef6865c..54842fe 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1014,7 +1014,7 @@ int clean_tree_block(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		     struct extent_buffer *buf)
 {
 	struct inode *btree_inode = root->fs_info->btree_inode;
-	if (btrfs_header_generation(buf) ==
+	if (btrfs_header_generation(buf) >=
 	    root->fs_info->running_transaction->transid) {
 		btrfs_assert_tree_locked(buf);
 
@@ -1649,7 +1649,7 @@ static int transaction_kthread(void *arg)
 
 		trans = btrfs_join_transaction(root, 1);
 		BUG_ON(IS_ERR(trans));
-		if (transid == trans->transid) {
+		if (transid == trans->transaction->transid) {
 			ret = btrfs_commit_transaction(trans, root);
 			BUG_ON(ret);
 		} else {
@@ -2064,6 +2064,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	csum_root->track_dirty = 1;
 
 	fs_info->generation = generation;
+	fs_info->sub_generation = generation;
 	fs_info->last_trans_committed = generation;
 	fs_info->data_alloc_profile = (u64)-1;
 	fs_info->metadata_alloc_profile = (u64)-1;
@@ -2715,7 +2716,7 @@ void btrfs_mark_buffer_dirty(struct extent_buffer *buf)
 	int was_dirty;
 
 	btrfs_assert_tree_locked(buf);
-	if (transid != root->fs_info->generation) {
+	if (transid < root->fs_info->generation) {
 		printk(KERN_CRIT "btrfs transid mismatch buffer %llu, "
 		       "found %llu running %llu\n",
 			(unsigned long long)buf->start,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 31f33ba..60f6109 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4455,7 +4455,7 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 	list_for_each_entry_safe(block_rsv, next_rsv,
 				 &fs_info->durable_block_rsv_list, list) {
 
-		idx = trans->transid & 0x1;
+		idx = trans->transaction->transid & 0x1;
 		if (block_rsv->freed[idx] > 0) {
 			block_rsv_add_bytes(block_rsv,
 					    block_rsv->freed[idx], 0);
@@ -4770,7 +4770,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 	if (block_rsv->space_info != cache->space_info)
 		goto out;
 
-	if (btrfs_header_generation(buf) == trans->transid) {
+	if (btrfs_header_generation(buf) >= trans->transaction->transid) {
 		if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID) {
 			ret = check_ref_cleanup(trans, root, buf->start);
 			if (!ret)
@@ -4820,7 +4820,8 @@ pin:
 
 		if (ret) {
 			spin_lock(&block_rsv->lock);
-			block_rsv->freed[trans->transid & 0x1] += buf->len;
+			block_rsv->freed[trans->transaction->transid & 0x1] +=
+								       buf->len;
 			spin_unlock(&block_rsv->lock);
 		}
 	}
@@ -6252,7 +6253,8 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
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
index a4157cf..4cec4c9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2091,7 +2091,7 @@ void btrfs_orphan_pre_snapshot(struct btrfs_trans_handle *trans,
 	 * space than it frees. So we should make sure there is enough
 	 * reserved space.
 	 */
-	index = trans->transid & 0x1;
+	index = trans->transaction->transid & 0x1;
 	if (block_rsv->reserved + block_rsv->freed[index] < block_rsv->size) {
 		num_bytes += block_rsv->size -
 			     (block_rsv->reserved + block_rsv->freed[index]);
@@ -2115,7 +2115,7 @@ void btrfs_orphan_post_snapshot(struct btrfs_trans_handle *trans,
 
 	/* refill source subvolume's orphan block reservation */
 	block_rsv = root->orphan_block_rsv;
-	index = trans->transid & 0x1;
+	index = trans->transaction->transid & 0x1;
 	if (block_rsv->reserved + block_rsv->freed[index] < block_rsv->size) {
 		num_bytes = block_rsv->size -
 			    (block_rsv->reserved + block_rsv->freed[index]);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f580a3a..142a82d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2438,7 +2438,7 @@ static noinline long btrfs_ioctl_start_sync(struct file *file, void __user *argp
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
-	transid = trans->transid;
+	transid = trans->transaction->transid;
 	ret = btrfs_commit_transaction_async(trans, root, 0);
 	if (ret) {
 		btrfs_end_transaction(trans, root);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 58250e0..9350f91 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -468,7 +468,7 @@ static int update_backref_cache(struct btrfs_trans_handle *trans,
 		return 0;
 	}
 
-	if (cache->last_trans == trans->transid)
+	if (cache->last_trans >= trans->transaction->transid)
 		return 0;
 
 	/*
@@ -1278,7 +1278,7 @@ static struct btrfs_root *create_reloc_root(struct btrfs_trans_handle *trans,
 		BUG_ON(ret);
 
 		btrfs_set_root_last_snapshot(&root->root_item,
-					     trans->transid - 1);
+					     trans->transaction->transid - 1);
 	} else {
 		/*
 		 * called by btrfs_reloc_post_snapshot_hook.
@@ -2255,7 +2255,7 @@ static int record_reloc_root_in_trans(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_root *root;
 
-	if (reloc_root->last_trans == trans->transid)
+	if (reloc_root->last_trans >= trans->transaction->transid)
 		return 0;
 
 	root = read_fs_root(reloc_root->fs_info, reloc_root->root_key.offset);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index c571734..cb0103c 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -58,9 +58,11 @@ static noinline int join_transaction(struct btrfs_root *root)
 		if (!cur_trans)
 			return -ENOMEM;
 		root->fs_info->generation++;
+		root->fs_info->sub_generation = root->fs_info->generation;
 		atomic_set(&cur_trans->num_writers, 1);
 		cur_trans->num_joined = 0;
 		cur_trans->transid = root->fs_info->generation;
+		cur_trans->sub_transid = cur_trans->transid;
 		init_waitqueue_head(&cur_trans->writer_wait);
 		init_waitqueue_head(&cur_trans->commit_wait);
 		cur_trans->in_commit = 0;
@@ -102,7 +104,7 @@ static noinline int join_transaction(struct btrfs_root *root)
 static noinline int record_root_in_trans(struct btrfs_trans_handle *trans,
 					 struct btrfs_root *root)
 {
-	if (root->ref_cows && root->last_trans < trans->transid) {
+	if (root->ref_cows && root->last_trans < trans->transaction->transid) {
 		WARN_ON(root == root->fs_info->extent_root);
 		WARN_ON(root->commit_root != root->node);
 
@@ -122,7 +124,7 @@ int btrfs_record_root_in_trans(struct btrfs_trans_handle *trans,
 		return 0;
 
 	mutex_lock(&root->fs_info->trans_mutex);
-	if (root->last_trans == trans->transid) {
+	if (root->last_trans >= trans->transaction->transid) {
 		mutex_unlock(&root->fs_info->trans_mutex);
 		return 0;
 	}
@@ -207,7 +209,7 @@ again:
 	if (type != TRANS_JOIN_NOLOCK)
 		mutex_unlock(&root->fs_info->trans_mutex);
 
-	h->transid = cur_trans->transid;
+	h->transid = cur_trans->sub_transid;
 	h->transaction = cur_trans;
 	h->blocks_used = 0;
 	h->block_group = 0;
@@ -1350,6 +1352,9 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	btrfs_prepare_extent_commit(trans, root);
 
 	cur_trans = root->fs_info->running_transaction;
+
+	root->fs_info->generation = cur_trans->sub_transid;
+
 	spin_lock(&root->fs_info->new_trans_lock);
 	root->fs_info->running_transaction = NULL;
 	spin_unlock(&root->fs_info->new_trans_lock);
@@ -1393,7 +1398,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 
 	cur_trans->commit_done = 1;
 
-	root->fs_info->last_trans_committed = cur_trans->transid;
+	root->fs_info->last_trans_committed = cur_trans->sub_transid;
 
 	wake_up(&cur_trans->commit_wait);
 
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index e441acc..6dcdd28 100644
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
index 992ab42..15f1912 100644
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
index c50271a..4ecd2c5 100644
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
+	mutex_lock(&root->fs_info->trans_mutex);
+
+	cur_trans = root->fs_info->running_transaction;
+	cur_trans->sub_transid++;
+	root->fs_info->sub_generation = cur_trans->sub_transid;
+
+	mutex_unlock(&root->fs_info->trans_mutex);
+
 	mutex_lock(&root->log_mutex);
 	if (root->log_root) {
 		if (!root->log_start_pid) {
@@ -1985,7 +1995,8 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	}
 
 	/* bail out if we need to do a full commit */
-	if (root->fs_info->last_trans_log_full_commit == trans->transid) {
+	if (root->fs_info->last_trans_log_full_commit >=
+						trans->transaction->transid) {
 		ret = -EAGAIN;
 		mutex_unlock(&root->log_mutex);
 		goto out;
@@ -2062,7 +2073,8 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
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

