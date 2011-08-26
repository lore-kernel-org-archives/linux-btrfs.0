From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs: make some functions return void
Date: Fri, 26 Aug 2011 15:57:43 +0900
Message-ID: <201108260657.AA00034@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The type of some functions that return only 0 is changed to 'void'.
In addition, the check on the return value in the caller of these
functions becomes unnecessary. So, these check is removed.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/async-thread.c |   17 ++++--------
 fs/btrfs/async-thread.h |    4 +-
 fs/btrfs/compression.c  |   14 ++++------
 fs/btrfs/delayed-ref.c  |   61 ++++++++++++++++++++---------------------------
 fs/btrfs/disk-io.c      |   41 +++++++++++--------------------
 fs/btrfs/disk-io.h      |    2 +-
 fs/btrfs/extent-tree.c  |   11 +++-----
 fs/btrfs/extent_io.c    |   32 ++++++++++--------------
 fs/btrfs/extent_io.h    |    2 +-
 fs/btrfs/locking.c      |    3 +-
 fs/btrfs/locking.h      |    2 +-
 fs/btrfs/ordered-data.c |   30 ++++++++--------------
 fs/btrfs/ordered-data.h |   16 ++++++------
 fs/btrfs/root-tree.c    |    4 +--
 fs/btrfs/transaction.c  |    9 ++----
 fs/btrfs/transaction.h  |    4 +-
 fs/btrfs/tree-log.c     |   21 ++++++----------
 fs/btrfs/tree-log.h     |    8 +++---
 fs/btrfs/volumes.c      |   11 +++-----
 fs/btrfs/volumes.h      |    2 +-
 20 files changed, 118 insertions(+), 176 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 7ec1409..5e9998a 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -177,11 +177,11 @@ out:
 	spin_unlock_irqrestore(&workers->lock, flags);
 }
 
-static noinline int run_ordered_completions(struct btrfs_workers *workers,
-					    struct btrfs_work *work)
+static noinline void run_ordered_completions(struct btrfs_workers *workers,
+					     struct btrfs_work *work)
 {
 	if (!workers->ordered)
-		return 0;
+		return;
 
 	set_bit(WORK_DONE_BIT, &work->flags);
 
@@ -219,7 +219,6 @@ static noinline int run_ordered_completions(struct btrfs_workers *workers,
 	}
 
 	spin_unlock(&workers->order_lock);
-	return 0;
 }
 
 static void put_worker(struct btrfs_worker_thread *worker)
@@ -405,7 +404,7 @@ again:
 /*
  * this will wait for all the worker threads to shutdown
  */
-int btrfs_stop_workers(struct btrfs_workers *workers)
+void btrfs_stop_workers(struct btrfs_workers *workers)
 {
 	struct list_head *cur;
 	struct btrfs_worker_thread *worker;
@@ -433,7 +432,6 @@ int btrfs_stop_workers(struct btrfs_workers *workers)
 		put_worker(worker);
 	}
 	spin_unlock_irq(&workers->lock);
-	return 0;
 }
 
 /*
@@ -618,14 +616,14 @@ found:
  * it was taken from.  It is intended for use with long running work functions
  * that make some progress and want to give the cpu up for others.
  */
-int btrfs_requeue_work(struct btrfs_work *work)
+void btrfs_requeue_work(struct btrfs_work *work)
 {
 	struct btrfs_worker_thread *worker = work->worker;
 	unsigned long flags;
 	int wake = 0;
 
 	if (test_and_set_bit(WORK_QUEUED_BIT, &work->flags))
-		goto out;
+		return;
 
 	spin_lock_irqsave(&worker->lock, flags);
 	if (test_bit(WORK_HIGH_PRIO_BIT, &work->flags))
@@ -652,9 +650,6 @@ int btrfs_requeue_work(struct btrfs_work *work)
 	if (wake)
 		wake_up_process(worker->task);
 	spin_unlock_irqrestore(&worker->lock, flags);
-out:
-
-	return 0;
 }
 
 void btrfs_set_work_high_prio(struct btrfs_work *work)
diff --git a/fs/btrfs/async-thread.h b/fs/btrfs/async-thread.h
index 5077746..6a9d3c1 100644
--- a/fs/btrfs/async-thread.h
+++ b/fs/btrfs/async-thread.h
@@ -111,9 +111,9 @@ struct btrfs_workers {
 
 int btrfs_queue_worker(struct btrfs_workers *workers, struct btrfs_work *work);
 int btrfs_start_workers(struct btrfs_workers *workers, int num_workers);
-int btrfs_stop_workers(struct btrfs_workers *workers);
+void btrfs_stop_workers(struct btrfs_workers *workers);
 void btrfs_init_workers(struct btrfs_workers *workers, char *name, int max,
 			struct btrfs_workers *async_starter);
-int btrfs_requeue_work(struct btrfs_work *work);
+void btrfs_requeue_work(struct btrfs_work *work);
 void btrfs_set_work_high_prio(struct btrfs_work *work);
 #endif
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 8ec5d86..9a9f138 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -225,8 +225,8 @@ out:
  * Clear the writeback bits on all of the file
  * pages for a compressed write
  */
-static noinline int end_compressed_writeback(struct inode *inode, u64 start,
-					     unsigned long ram_size)
+static noinline void end_compressed_writeback(struct inode *inode, u64 start,
+					      unsigned long ram_size)
 {
 	unsigned long index = start >> PAGE_CACHE_SHIFT;
 	unsigned long end_index = (start + ram_size - 1) >> PAGE_CACHE_SHIFT;
@@ -252,7 +252,6 @@ static noinline int end_compressed_writeback(struct inode *inode, u64 start,
 		index += ret;
 	}
 	/* the inode may be gone now */
-	return 0;
 }
 
 /*
@@ -434,9 +433,9 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 	return 0;
 }
 
-static noinline int add_ra_bio_pages(struct inode *inode,
-				     u64 compressed_end,
-				     struct compressed_bio *cb)
+static noinline void add_ra_bio_pages(struct inode *inode,
+				      u64 compressed_end,
+				      struct compressed_bio *cb)
 {
 	unsigned long end_index;
 	unsigned long pg_index;
@@ -458,7 +457,7 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 	tree = &BTRFS_I(inode)->io_tree;
 
 	if (isize == 0)
-		return 0;
+		return;
 
 	end_index = (i_size_read(inode) - 1) >> PAGE_CACHE_SHIFT;
 
@@ -542,7 +541,6 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 next:
 		last_offset += PAGE_CACHE_SIZE;
 	}
-	return 0;
 }
 
 /*
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 125cf76..0aae23c 100644
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
@@ -462,16 +462,15 @@ static noinline int add_delayed_ref_head(struct btrfs_trans_handle *trans,
 		delayed_refs->num_entries++;
 		trans->delayed_ref_updates++;
 	}
-	return 0;
 }
 
 /*
  * helper to insert a delayed tree ref into the rbtree.
  */
-static noinline int add_delayed_tree_ref(struct btrfs_trans_handle *trans,
-					 struct btrfs_delayed_ref_node *ref,
-					 u64 bytenr, u64 num_bytes, u64 parent,
-					 u64 ref_root, int level, int action)
+static noinline void add_delayed_tree_ref(struct btrfs_trans_handle *trans,
+					  struct btrfs_delayed_ref_node *ref,
+					  u64 bytenr, u64 num_bytes, u64 parent,
+					  u64 ref_root, int level, int action)
 {
 	struct btrfs_delayed_ref_node *existing;
 	struct btrfs_delayed_tree_ref *full_ref;
@@ -516,17 +515,16 @@ static noinline int add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 		delayed_refs->num_entries++;
 		trans->delayed_ref_updates++;
 	}
-	return 0;
 }
 
 /*
  * helper to insert a delayed data ref into the rbtree.
  */
-static noinline int add_delayed_data_ref(struct btrfs_trans_handle *trans,
-					 struct btrfs_delayed_ref_node *ref,
-					 u64 bytenr, u64 num_bytes, u64 parent,
-					 u64 ref_root, u64 owner, u64 offset,
-					 int action)
+static noinline void add_delayed_data_ref(struct btrfs_trans_handle *trans,
+					  struct btrfs_delayed_ref_node *ref,
+					  u64 bytenr, u64 num_bytes, u64 parent,
+					  u64 ref_root, u64 owner, u64 offset,
+					  int action)
 {
 	struct btrfs_delayed_ref_node *existing;
 	struct btrfs_delayed_data_ref *full_ref;
@@ -572,7 +570,6 @@ static noinline int add_delayed_data_ref(struct btrfs_trans_handle *trans,
 		delayed_refs->num_entries++;
 		trans->delayed_ref_updates++;
 	}
-	return 0;
 }
 
 /*
@@ -588,7 +585,6 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 	struct btrfs_delayed_tree_ref *ref;
 	struct btrfs_delayed_ref_head *head_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
-	int ret;
 
 	BUG_ON(extent_op && extent_op->is_data);
 	ref = kmalloc(sizeof(*ref), GFP_NOFS);
@@ -610,13 +606,12 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
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
@@ -633,7 +628,6 @@ int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
 	struct btrfs_delayed_data_ref *ref;
 	struct btrfs_delayed_ref_head *head_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
-	int ret;
 
 	BUG_ON(extent_op && !extent_op->is_data);
 	ref = kmalloc(sizeof(*ref), GFP_NOFS);
@@ -655,13 +649,12 @@ int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
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
@@ -672,7 +665,6 @@ int btrfs_add_delayed_extent_op(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_delayed_ref_head *head_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
-	int ret;
 
 	head_ref = kmalloc(sizeof(*head_ref), GFP_NOFS);
 	if (!head_ref)
@@ -683,10 +675,9 @@ int btrfs_add_delayed_extent_op(struct btrfs_trans_handle *trans,
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
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 94ecac3..2d96241 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -50,10 +50,10 @@ static void free_fs_root(struct btrfs_root *root);
 static void btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 				    int read_only);
 static int btrfs_destroy_ordered_operations(struct btrfs_root *root);
-static int btrfs_destroy_ordered_extents(struct btrfs_root *root);
-static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
-				      struct btrfs_root *root);
-static int btrfs_destroy_pending_snapshots(struct btrfs_transaction *t);
+static void btrfs_destroy_ordered_extents(struct btrfs_root *root);
+static void btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
+				       struct btrfs_root *root);
+static void btrfs_destroy_pending_snapshots(struct btrfs_transaction *t);
 static int btrfs_destroy_delalloc_inodes(struct btrfs_root *root);
 static int btrfs_destroy_marked_extents(struct btrfs_root *root,
 					struct extent_io_tree *dirty_pages,
@@ -1056,10 +1056,10 @@ int clean_tree_block(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	return 0;
 }
 
-static int __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
-			u32 stripesize, struct btrfs_root *root,
-			struct btrfs_fs_info *fs_info,
-			u64 objectid)
+static void __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
+			 u32 stripesize, struct btrfs_root *root,
+			 struct btrfs_fs_info *fs_info,
+			 u64 objectid)
 {
 	root->node = NULL;
 	root->commit_root = NULL;
@@ -1116,8 +1116,6 @@ static int __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 	INIT_LIST_HEAD(&root->anon_super.s_list);
 	INIT_LIST_HEAD(&root->anon_super.s_instances);
 	init_rwsem(&root->anon_super.s_umount);
-
-	return 0;
 }
 
 static int find_and_setup_root(struct btrfs_root *tree_root,
@@ -2412,7 +2410,7 @@ int write_ctree_super(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-int btrfs_free_fs_root(struct btrfs_fs_info *fs_info, struct btrfs_root *root)
+void btrfs_free_fs_root(struct btrfs_fs_info *fs_info, struct btrfs_root *root)
 {
 	spin_lock(&fs_info->fs_roots_radix_lock);
 	radix_tree_delete(&fs_info->fs_roots_radix,
@@ -2425,7 +2423,6 @@ int btrfs_free_fs_root(struct btrfs_fs_info *fs_info, struct btrfs_root *root)
 	__btrfs_remove_free_space_cache(root->free_ino_pinned);
 	__btrfs_remove_free_space_cache(root->free_ino_ctl);
 	free_fs_root(root);
-	return 0;
 }
 
 static void free_fs_root(struct btrfs_root *root)
@@ -2444,7 +2441,7 @@ static void free_fs_root(struct btrfs_root *root)
 	kfree(root);
 }
 
-static int del_fs_roots(struct btrfs_fs_info *fs_info)
+static void del_fs_roots(struct btrfs_fs_info *fs_info)
 {
 	int ret;
 	struct btrfs_root *gang[8];
@@ -2473,7 +2470,6 @@ static int del_fs_roots(struct btrfs_fs_info *fs_info)
 		for (i = 0; i < ret; i++)
 			btrfs_free_fs_root(fs_info, gang[i]);
 	}
-	return 0;
 }
 
 int btrfs_cleanup_fs_roots(struct btrfs_fs_info *fs_info)
@@ -2834,7 +2830,7 @@ static int btrfs_destroy_ordered_operations(struct btrfs_root *root)
 	return 0;
 }
 
-static int btrfs_destroy_ordered_extents(struct btrfs_root *root)
+static void btrfs_destroy_ordered_extents(struct btrfs_root *root)
 {
 	struct list_head splice;
 	struct btrfs_ordered_extent *ordered;
@@ -2866,17 +2862,14 @@ static int btrfs_destroy_ordered_extents(struct btrfs_root *root)
 	}
 
 	spin_unlock(&root->fs_info->ordered_extent_lock);
-
-	return 0;
 }
 
-static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
-				      struct btrfs_root *root)
+static void btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
+				       struct btrfs_root *root)
 {
 	struct rb_node *node;
 	struct btrfs_delayed_ref_root *delayed_refs;
 	struct btrfs_delayed_ref_node *ref;
-	int ret = 0;
 
 	delayed_refs = &trans->delayed_refs;
 
@@ -2884,7 +2877,7 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 	if (delayed_refs->num_entries == 0) {
 		spin_unlock(&delayed_refs->lock);
 		printk(KERN_INFO "delayed_refs has NO entry\n");
-		return ret;
+		return;
 	}
 
 	node = rb_first(&delayed_refs->root);
@@ -2918,11 +2911,9 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 	}
 
 	spin_unlock(&delayed_refs->lock);
-
-	return ret;
 }
 
-static int btrfs_destroy_pending_snapshots(struct btrfs_transaction *t)
+static void btrfs_destroy_pending_snapshots(struct btrfs_transaction *t)
 {
 	struct btrfs_pending_snapshot *snapshot;
 	struct list_head splice;
@@ -2940,8 +2931,6 @@ static int btrfs_destroy_pending_snapshots(struct btrfs_transaction *t)
 
 		kfree(snapshot);
 	}
-
-	return 0;
 }
 
 static int btrfs_destroy_delalloc_inodes(struct btrfs_root *root)
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index bec3ea4..ac4df43 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -62,7 +62,7 @@ struct btrfs_root *btrfs_read_fs_root_no_name(struct btrfs_fs_info *fs_info,
 int btrfs_cleanup_fs_roots(struct btrfs_fs_info *fs_info);
 void btrfs_btree_balance_dirty(struct btrfs_root *root, unsigned long nr);
 void __btrfs_btree_balance_dirty(struct btrfs_root *root, unsigned long nr);
-int btrfs_free_fs_root(struct btrfs_fs_info *fs_info, struct btrfs_root *root);
+void btrfs_free_fs_root(struct btrfs_fs_info *fs_info, struct btrfs_root *root);
 void btrfs_mark_buffer_dirty(struct extent_buffer *buf);
 int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid);
 int btrfs_set_buffer_uptodate(struct extent_buffer *buf);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 80d6148..5f6c88c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4799,7 +4799,7 @@ static u64 stripe_align(struct btrfs_root *root, u64 val)
  * and look in the rbtree for a free extent of a given size, but this
  * is a good start.
  */
-static noinline int
+static noinline void
 wait_block_group_cache_progress(struct btrfs_block_group_cache *cache,
 				u64 num_bytes)
 {
@@ -4808,16 +4808,15 @@ wait_block_group_cache_progress(struct btrfs_block_group_cache *cache,
 
 	caching_ctl = get_caching_control(cache);
 	if (!caching_ctl)
-		return 0;
+		return;
 
 	wait_event(caching_ctl->wait, block_group_cache_done(cache) ||
 		   (cache->free_space_ctl->free_space >= num_bytes));
 
 	put_caching_control(caching_ctl);
-	return 0;
 }
 
-static noinline int
+static noinline void
 wait_block_group_cache_done(struct btrfs_block_group_cache *cache)
 {
 	struct btrfs_caching_control *caching_ctl;
@@ -4825,12 +4824,11 @@ wait_block_group_cache_done(struct btrfs_block_group_cache *cache)
 
 	caching_ctl = get_caching_control(cache);
 	if (!caching_ctl)
-		return 0;
+		return;
 
 	wait_event(caching_ctl->wait, block_group_cache_done(cache));
 
 	put_caching_control(caching_ctl);
-	return 0;
 }
 
 static int get_block_group_index(struct btrfs_block_group_cache *cache)
@@ -6443,7 +6441,6 @@ out_free:
 out:
 	if (err)
 		btrfs_std_error(root->fs_info, err);
-	return;
 }
 
 /*
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8491712..99717f8 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -596,8 +596,8 @@ search_again:
 	goto again;
 }
 
-static int wait_on_state(struct extent_io_tree *tree,
-			 struct extent_state *state)
+static void wait_on_state(struct extent_io_tree *tree,
+			  struct extent_state *state)
 		__releases(tree->lock)
 		__acquires(tree->lock)
 {
@@ -607,7 +607,6 @@ static int wait_on_state(struct extent_io_tree *tree,
 	schedule();
 	spin_lock(&tree->lock);
 	finish_wait(&state->wq, &wait);
-	return 0;
 }
 
 /*
@@ -615,7 +614,7 @@ static int wait_on_state(struct extent_io_tree *tree,
  * The range [start, end] is inclusive.
  * The tree lock is taken by this function
  */
-int wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits)
+void wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits)
 {
 	struct extent_state *state;
 	struct rb_node *node;
@@ -652,7 +651,6 @@ again:
 	}
 out:
 	spin_unlock(&tree->lock);
-	return 0;
 }
 
 static void set_state_bits(struct extent_io_tree *tree,
@@ -1146,9 +1144,9 @@ out:
 	return found;
 }
 
-static noinline int __unlock_for_delalloc(struct inode *inode,
-					  struct page *locked_page,
-					  u64 start, u64 end)
+static noinline void __unlock_for_delalloc(struct inode *inode,
+					   struct page *locked_page,
+					   u64 start, u64 end)
 {
 	int ret;
 	struct page *pages[16];
@@ -1158,7 +1156,7 @@ static noinline int __unlock_for_delalloc(struct inode *inode,
 	int i;
 
 	if (index == locked_page->index && end_index == index)
-		return 0;
+		return;
 
 	while (nr_pages > 0) {
 		ret = find_get_pages_contig(inode->i_mapping, index,
@@ -1173,7 +1171,6 @@ static noinline int __unlock_for_delalloc(struct inode *inode,
 		index += ret;
 		cond_resched();
 	}
-	return 0;
 }
 
 static noinline int lock_delalloc_pages(struct inode *inode,
@@ -1564,39 +1561,36 @@ int test_range_bit(struct extent_io_tree *tree, u64 start, u64 end,
  * helper function to set a given page up to date if all the
  * extents in the tree for that page are up to date
  */
-static int check_page_uptodate(struct extent_io_tree *tree,
-			       struct page *page)
+static void check_page_uptodate(struct extent_io_tree *tree,
+				struct page *page)
 {
 	u64 start = (u64)page->index << PAGE_CACHE_SHIFT;
 	u64 end = start + PAGE_CACHE_SIZE - 1;
 	if (test_range_bit(tree, start, end, EXTENT_UPTODATE, 1, NULL))
 		SetPageUptodate(page);
-	return 0;
 }
 
 /*
  * helper function to unlock a page if all the extents in the tree
  * for that page are unlocked
  */
-static int check_page_locked(struct extent_io_tree *tree,
-			     struct page *page)
+static void check_page_locked(struct extent_io_tree *tree,
+			      struct page *page)
 {
 	u64 start = (u64)page->index << PAGE_CACHE_SHIFT;
 	u64 end = start + PAGE_CACHE_SIZE - 1;
 	if (!test_range_bit(tree, start, end, EXTENT_LOCKED, 0, NULL))
 		unlock_page(page);
-	return 0;
 }
 
 /*
  * helper function to end page writeback if all the extents
  * in the tree for that page are done with writeback
  */
-static int check_page_writeback(struct extent_io_tree *tree,
-			     struct page *page)
+static void check_page_writeback(struct extent_io_tree *tree,
+				 struct page *page)
 {
 	end_page_writeback(page);
-	return 0;
 }
 
 /* lots and lots of room for performance fixes in the end_bio funcs */
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 7b2f0c3..3dc201b 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -274,7 +274,7 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 			   unsigned long src_offset, unsigned long len);
 void memset_extent_buffer(struct extent_buffer *eb, char c,
 			  unsigned long start, unsigned long len);
-int wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits);
+void wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits);
 int clear_extent_buffer_dirty(struct extent_io_tree *tree,
 			      struct extent_buffer *eb);
 int set_extent_buffer_dirty(struct extent_io_tree *tree,
diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index d77b67c..77d5bbd 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -160,7 +160,7 @@ void btrfs_tree_read_unlock_blocking(struct extent_buffer *eb)
  * take a spinning write lock.  This will wait for both
  * blocking readers or writers
  */
-int btrfs_tree_lock(struct extent_buffer *eb)
+void btrfs_tree_lock(struct extent_buffer *eb)
 {
 again:
 	wait_event(eb->read_lock_wq, atomic_read(&eb->blocking_readers) == 0);
@@ -181,7 +181,6 @@ again:
 	WARN_ON(atomic_read(&eb->spinning_writers));
 	atomic_inc(&eb->spinning_writers);
 	atomic_inc(&eb->write_locks);
-	return 0;
 }
 
 /*
diff --git a/fs/btrfs/locking.h b/fs/btrfs/locking.h
index 17247dd..d7cb036 100644
--- a/fs/btrfs/locking.h
+++ b/fs/btrfs/locking.h
@@ -24,7 +24,7 @@
 #define BTRFS_WRITE_LOCK_BLOCKING 3
 #define BTRFS_READ_LOCK_BLOCKING 4
 
-int btrfs_tree_lock(struct extent_buffer *eb);
+void btrfs_tree_lock(struct extent_buffer *eb);
 int btrfs_tree_unlock(struct extent_buffer *eb);
 int btrfs_try_spin_lock(struct extent_buffer *eb);
 
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index a1c9404..8f4d150 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -249,9 +249,9 @@ int btrfs_add_ordered_extent_compress(struct inode *inode, u64 file_offset,
  * when an ordered extent is finished.  If the list covers more than one
  * ordered extent, it is split across multiples.
  */
-int btrfs_add_ordered_sum(struct inode *inode,
-			  struct btrfs_ordered_extent *entry,
-			  struct btrfs_ordered_sum *sum)
+void btrfs_add_ordered_sum(struct inode *inode,
+			   struct btrfs_ordered_extent *entry,
+			   struct btrfs_ordered_sum *sum)
 {
 	struct btrfs_ordered_inode_tree *tree;
 
@@ -259,7 +259,6 @@ int btrfs_add_ordered_sum(struct inode *inode,
 	spin_lock(&tree->lock);
 	list_add_tail(&sum->list, &entry->list);
 	spin_unlock(&tree->lock);
-	return 0;
 }
 
 /*
@@ -384,7 +383,7 @@ out:
  * used to drop a reference on an ordered extent.  This will free
  * the extent if the last reference is dropped
  */
-int btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry)
+void btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry)
 {
 	struct list_head *cur;
 	struct btrfs_ordered_sum *sum;
@@ -400,7 +399,6 @@ int btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry)
 		}
 		kfree(entry);
 	}
-	return 0;
 }
 
 /*
@@ -408,8 +406,8 @@ int btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry)
  * and you must wake_up entry->wait.  You must hold the tree lock
  * while you call this function.
  */
-static int __btrfs_remove_ordered_extent(struct inode *inode,
-				struct btrfs_ordered_extent *entry)
+static void __btrfs_remove_ordered_extent(struct inode *inode,
+					  struct btrfs_ordered_extent *entry)
 {
 	struct btrfs_ordered_inode_tree *tree;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -436,35 +434,30 @@ static int __btrfs_remove_ordered_extent(struct inode *inode,
 		list_del_init(&BTRFS_I(inode)->ordered_operations);
 	}
 	spin_unlock(&root->fs_info->ordered_extent_lock);
-
-	return 0;
 }
 
 /*
  * remove an ordered extent from the tree.  No references are dropped
  * but any waiters are woken.
  */
-int btrfs_remove_ordered_extent(struct inode *inode,
-				struct btrfs_ordered_extent *entry)
+void btrfs_remove_ordered_extent(struct inode *inode,
+				 struct btrfs_ordered_extent *entry)
 {
 	struct btrfs_ordered_inode_tree *tree;
-	int ret;
 
 	tree = &BTRFS_I(inode)->ordered_tree;
 	spin_lock(&tree->lock);
-	ret = __btrfs_remove_ordered_extent(inode, entry);
+	__btrfs_remove_ordered_extent(inode, entry);
 	spin_unlock(&tree->lock);
 	wake_up(&entry->wait);
-
-	return ret;
 }
 
 /*
  * wait for all the ordered extents in a root.  This is done when balancing
  * space between drives.
  */
-int btrfs_wait_ordered_extents(struct btrfs_root *root,
-			       int nocow_only, int delay_iput)
+void btrfs_wait_ordered_extents(struct btrfs_root *root,
+				int nocow_only, int delay_iput)
 {
 	struct list_head splice;
 	struct list_head *cur;
@@ -512,7 +505,6 @@ int btrfs_wait_ordered_extents(struct btrfs_root *root,
 		spin_lock(&root->fs_info->ordered_extent_lock);
 	}
 	spin_unlock(&root->fs_info->ordered_extent_lock);
-	return 0;
 }
 
 /*
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index ff1f69a..14405fd 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -138,9 +138,9 @@ btrfs_ordered_inode_tree_init(struct btrfs_ordered_inode_tree *t)
 	t->last = NULL;
 }
 
-int btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry);
-int btrfs_remove_ordered_extent(struct inode *inode,
-				struct btrfs_ordered_extent *entry);
+void btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry);
+void btrfs_remove_ordered_extent(struct inode *inode,
+				 struct btrfs_ordered_extent *entry);
 int btrfs_dec_test_ordered_pending(struct inode *inode,
 				   struct btrfs_ordered_extent **cached,
 				   u64 file_offset, u64 io_size);
@@ -154,9 +154,9 @@ int btrfs_add_ordered_extent_dio(struct inode *inode, u64 file_offset,
 int btrfs_add_ordered_extent_compress(struct inode *inode, u64 file_offset,
 				      u64 start, u64 len, u64 disk_len,
 				      int type, int compress_type);
-int btrfs_add_ordered_sum(struct inode *inode,
-			  struct btrfs_ordered_extent *entry,
-			  struct btrfs_ordered_sum *sum);
+void btrfs_add_ordered_sum(struct inode *inode,
+			   struct btrfs_ordered_extent *entry,
+			   struct btrfs_ordered_sum *sum);
 struct btrfs_ordered_extent *btrfs_lookup_ordered_extent(struct inode *inode,
 							 u64 file_offset);
 void btrfs_start_ordered_extent(struct inode *inode,
@@ -174,6 +174,6 @@ int btrfs_run_ordered_operations(struct btrfs_root *root, int wait);
 int btrfs_add_ordered_operation(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
 				struct inode *inode);
-int btrfs_wait_ordered_extents(struct btrfs_root *root,
-			       int nocow_only, int delay_iput);
+void btrfs_wait_ordered_extents(struct btrfs_root *root,
+				int nocow_only, int delay_iput);
 #endif
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index f409990..5488d63 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -191,9 +191,7 @@ again:
 			goto err;
 		}
 
-		ret = btrfs_add_dead_root(dead_root);
-		if (ret)
-			goto err;
+		btrfs_add_dead_root(dead_root);
 		goto again;
 next:
 		slot++;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 7dc36fa..3dec77d 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -775,12 +775,11 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans,
  * a dirty root struct and adds it into the list of dead roots that need to
  * be deleted
  */
-int btrfs_add_dead_root(struct btrfs_root *root)
+void btrfs_add_dead_root(struct btrfs_root *root)
 {
 	spin_lock(&root->fs_info->trans_lock);
 	list_add(&root->root_list, &root->fs_info->dead_roots);
 	spin_unlock(&root->fs_info->trans_lock);
-	return 0;
 }
 
 /*
@@ -1232,8 +1231,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 
 		if (flush_on_commit || snap_pending) {
 			btrfs_start_delalloc_inodes(root, 1);
-			ret = btrfs_wait_ordered_extents(root, 0, 1);
-			BUG_ON(ret);
+			btrfs_wait_ordered_extents(root, 0, 1);
 		}
 
 		ret = btrfs_run_delayed_items(trans, root);
@@ -1396,7 +1394,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 /*
  * interface function to delete all the snapshots we have scheduled for deletion
  */
-int btrfs_clean_old_snapshots(struct btrfs_root *root)
+void btrfs_clean_old_snapshots(struct btrfs_root *root)
 {
 	LIST_HEAD(list);
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -1417,5 +1415,4 @@ int btrfs_clean_old_snapshots(struct btrfs_root *root)
 		else
 			btrfs_drop_snapshot(root, NULL, 1);
 	}
-	return 0;
 }
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 02564e6..ea3813d 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -89,9 +89,9 @@ int btrfs_wait_for_commit(struct btrfs_root *root, u64 transid);
 int btrfs_write_and_wait_transaction(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *root);
 
-int btrfs_add_dead_root(struct btrfs_root *root);
+void btrfs_add_dead_root(struct btrfs_root *root);
 int btrfs_defrag_root(struct btrfs_root *root, int cacheonly);
-int btrfs_clean_old_snapshots(struct btrfs_root *root);
+void btrfs_clean_old_snapshots(struct btrfs_root *root);
 int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root);
 int btrfs_commit_transaction_async(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 786639f..58793a1 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -212,14 +212,13 @@ int btrfs_pin_log_trans(struct btrfs_root *root)
  * indicate we're done making changes to the log tree
  * and wake up anyone waiting to do a sync
  */
-int btrfs_end_log_trans(struct btrfs_root *root)
+void btrfs_end_log_trans(struct btrfs_root *root)
 {
 	if (atomic_dec_and_test(&root->log_writers)) {
 		smp_mb();
 		if (waitqueue_active(&root->log_writer_wait))
 			wake_up(&root->log_writer_wait);
 	}
-	return 0;
 }
 
 
@@ -1933,8 +1932,8 @@ static int update_log_root(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static int wait_log_commit(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root, unsigned long transid)
+static void wait_log_commit(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root, unsigned long transid)
 {
 	DEFINE_WAIT(wait);
 	int index = transid % 2;
@@ -1958,11 +1957,10 @@ static int wait_log_commit(struct btrfs_trans_handle *trans,
 		mutex_lock(&root->log_mutex);
 	} while (root->log_transid < transid + 2 &&
 		 atomic_read(&root->log_commit[index]));
-	return 0;
 }
 
-static int wait_for_writer(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root)
+static void wait_for_writer(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root)
 {
 	DEFINE_WAIT(wait);
 	while (atomic_read(&root->log_writers)) {
@@ -1975,7 +1973,6 @@ static int wait_for_writer(struct btrfs_trans_handle *trans,
 		mutex_lock(&root->log_mutex);
 		finish_wait(&root->log_writer_wait, &wait);
 	}
-	return 0;
 }
 
 /*
@@ -2190,23 +2187,21 @@ static void free_log_tree(struct btrfs_trans_handle *trans,
  * free all the extents used by the tree log.  This should be called
  * at commit time of the full transaction
  */
-int btrfs_free_log(struct btrfs_trans_handle *trans, struct btrfs_root *root)
+void btrfs_free_log(struct btrfs_trans_handle *trans, struct btrfs_root *root)
 {
 	if (root->log_root) {
 		free_log_tree(trans, root->log_root);
 		root->log_root = NULL;
 	}
-	return 0;
 }
 
-int btrfs_free_log_root_tree(struct btrfs_trans_handle *trans,
-			     struct btrfs_fs_info *fs_info)
+void btrfs_free_log_root_tree(struct btrfs_trans_handle *trans,
+			      struct btrfs_fs_info *fs_info)
 {
 	if (fs_info->log_root_tree) {
 		free_log_tree(trans, fs_info->log_root_tree);
 		fs_info->log_root_tree = NULL;
 	}
-	return 0;
 }
 
 /*
diff --git a/fs/btrfs/tree-log.h b/fs/btrfs/tree-log.h
index 2270ac5..1055a78 100644
--- a/fs/btrfs/tree-log.h
+++ b/fs/btrfs/tree-log.h
@@ -24,9 +24,9 @@
 
 int btrfs_sync_log(struct btrfs_trans_handle *trans,
 		   struct btrfs_root *root);
-int btrfs_free_log(struct btrfs_trans_handle *trans, struct btrfs_root *root);
-int btrfs_free_log_root_tree(struct btrfs_trans_handle *trans,
-			     struct btrfs_fs_info *fs_info);
+void btrfs_free_log(struct btrfs_trans_handle *trans, struct btrfs_root *root);
+void btrfs_free_log_root_tree(struct btrfs_trans_handle *trans,
+			      struct btrfs_fs_info *fs_info);
 int btrfs_recover_log_trees(struct btrfs_root *tree_root);
 int btrfs_log_dentry_safe(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root, struct dentry *dentry);
@@ -38,7 +38,7 @@ int btrfs_del_inode_ref_in_log(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root,
 			       const char *name, int name_len,
 			       struct inode *inode, u64 dirid);
-int btrfs_end_log_trans(struct btrfs_root *root);
+void btrfs_end_log_trans(struct btrfs_root *root);
 int btrfs_pin_log_trans(struct btrfs_root *root);
 int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 		    struct btrfs_root *root, struct inode *inode,
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f2a4cc7..9a88e98 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -65,7 +65,7 @@ static void free_fs_devices(struct btrfs_fs_devices *fs_devices)
 	kfree(fs_devices);
 }
 
-int btrfs_cleanup_fs_uuids(void)
+void btrfs_cleanup_fs_uuids(void)
 {
 	struct btrfs_fs_devices *fs_devices;
 
@@ -75,7 +75,6 @@ int btrfs_cleanup_fs_uuids(void)
 		list_del(&fs_devices->list);
 		free_fs_devices(fs_devices);
 	}
-	return 0;
 }
 
 static noinline struct btrfs_device *__find_device(struct list_head *head,
@@ -3491,9 +3490,9 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 	return 0;
 }
 
-static int fill_device_from_item(struct extent_buffer *leaf,
-				 struct btrfs_dev_item *dev_item,
-				 struct btrfs_device *device)
+static void fill_device_from_item(struct extent_buffer *leaf,
+				  struct btrfs_dev_item *dev_item,
+				  struct btrfs_device *device)
 {
 	unsigned long ptr;
 
@@ -3508,8 +3507,6 @@ static int fill_device_from_item(struct extent_buffer *leaf,
 
 	ptr = (unsigned long)btrfs_device_uuid(dev_item);
 	read_extent_buffer(leaf, device->uuid, ptr, BTRFS_UUID_SIZE);
-
-	return 0;
 }
 
 static int open_seed_devices(struct btrfs_root *root, u8 *fsid)
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 6d866db..f019e54 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -202,7 +202,7 @@ int btrfs_add_device(struct btrfs_trans_handle *trans,
 		     struct btrfs_root *root,
 		     struct btrfs_device *device);
 int btrfs_rm_device(struct btrfs_root *root, char *device_path);
-int btrfs_cleanup_fs_uuids(void);
+void btrfs_cleanup_fs_uuids(void);
 int btrfs_num_copies(struct btrfs_mapping_tree *map_tree, u64 logical, u64 len);
 int btrfs_grow_device(struct btrfs_trans_handle *trans,
 		      struct btrfs_device *device, u64 new_size);

