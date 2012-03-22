From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 15/35] btrfs: return void in functions without error conditions
Date: Wed, 21 Mar 2012 21:11:19 -0400
Message-ID: <20120322011135.082387855@suse.com>
References: <20120322011104.212214639@suse.com>
Cc: David Sterba <dsterba@suse.com>
To: Linux Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---

 fs/btrfs/async-thread.c      |   15 +--
 fs/btrfs/async-thread.h      |    4 
 fs/btrfs/compression.c       |    8 -
 fs/btrfs/compression.h       |    2 
 fs/btrfs/ctree.c             |  200 ++++++++++++++-----------------------------
 fs/btrfs/ctree.h             |   45 ++++-----
 fs/btrfs/delayed-inode.c     |    6 -
 fs/btrfs/delayed-ref.c       |   27 +----
 fs/btrfs/dir-item.c          |    9 -
 fs/btrfs/disk-io.c           |   39 +++-----
 fs/btrfs/disk-io.h           |    2 
 fs/btrfs/extent-tree.c       |   60 +++++-------
 fs/btrfs/extent_io.c         |   35 +++----
 fs/btrfs/extent_io.h         |    4 
 fs/btrfs/file-item.c         |   25 ++---
 fs/btrfs/inode-item.c        |    4 
 fs/btrfs/inode.c             |    7 -
 fs/btrfs/locking.c           |    6 -
 fs/btrfs/locking.h           |    4 
 fs/btrfs/ordered-data.c      |   48 +++-------
 fs/btrfs/ordered-data.h      |   24 ++---
 fs/btrfs/scrub.c             |   36 ++-----
 fs/btrfs/super.c             |    5 -
 fs/btrfs/transaction.c       |    3 
 fs/btrfs/tree-log.c          |   17 +--
 fs/btrfs/tree-log.h          |    2 
 fs/btrfs/volumes.c           |   18 +--
 fs/btrfs/volumes.h           |    4 
 include/trace/events/btrfs.h |   44 +++++++++
 29 files changed, 293 insertions(+), 410 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 0cc20b3..4270414 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -171,11 +171,11 @@ out:
 	spin_unlock_irqrestore(&workers->lock, flags);
 }
 
-static noinline int run_ordered_completions(struct btrfs_workers *workers,
+static noinline void run_ordered_completions(struct btrfs_workers *workers,
 					    struct btrfs_work *work)
 {
 	if (!workers->ordered)
-		return 0;
+		return;
 
 	set_bit(WORK_DONE_BIT, &work->flags);
 
@@ -213,7 +213,6 @@ static noinline int run_ordered_completions(struct btrfs_workers *workers,
 	}
 
 	spin_unlock(&workers->order_lock);
-	return 0;
 }
 
 static void put_worker(struct btrfs_worker_thread *worker)
@@ -399,7 +398,7 @@ again:
 /*
  * this will wait for all the worker threads to shutdown
  */
-int btrfs_stop_workers(struct btrfs_workers *workers)
+void btrfs_stop_workers(struct btrfs_workers *workers)
 {
 	struct list_head *cur;
 	struct btrfs_worker_thread *worker;
@@ -427,7 +426,6 @@ int btrfs_stop_workers(struct btrfs_workers *workers)
 		put_worker(worker);
 	}
 	spin_unlock_irq(&workers->lock);
-	return 0;
 }
 
 /*
@@ -615,14 +613,14 @@ found:
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
@@ -649,9 +647,6 @@ int btrfs_requeue_work(struct btrfs_work *work)
 	if (wake)
 		wake_up_process(worker->task);
 	spin_unlock_irqrestore(&worker->lock, flags);
-out:
-
-	return 0;
 }
 
 void btrfs_set_work_high_prio(struct btrfs_work *work)
diff --git a/fs/btrfs/async-thread.h b/fs/btrfs/async-thread.h
index f34cc31..063698b 100644
--- a/fs/btrfs/async-thread.h
+++ b/fs/btrfs/async-thread.h
@@ -111,9 +111,9 @@ struct btrfs_workers {
 
 void btrfs_queue_worker(struct btrfs_workers *workers, struct btrfs_work *work);
 int btrfs_start_workers(struct btrfs_workers *workers);
-int btrfs_stop_workers(struct btrfs_workers *workers);
+void btrfs_stop_workers(struct btrfs_workers *workers);
 void btrfs_init_workers(struct btrfs_workers *workers, char *name, int max,
 			struct btrfs_workers *async_starter);
-int btrfs_requeue_work(struct btrfs_work *work);
+void btrfs_requeue_work(struct btrfs_work *work);
 void btrfs_set_work_high_prio(struct btrfs_work *work);
 #endif
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index d02c27c..0ed1ed2 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -226,8 +226,8 @@ out:
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
@@ -253,7 +253,6 @@ static noinline int end_compressed_writeback(struct inode *inode, u64 start,
 		index += ret;
 	}
 	/* the inode may be gone now */
-	return 0;
 }
 
 /*
@@ -734,7 +733,7 @@ struct btrfs_compress_op *btrfs_compress_op[] = {
 	&btrfs_lzo_compress,
 };
 
-int __init btrfs_init_compress(void)
+void __init btrfs_init_compress(void)
 {
 	int i;
 
@@ -744,7 +743,6 @@ int __init btrfs_init_compress(void)
 		atomic_set(&comp_alloc_workspace[i], 0);
 		init_waitqueue_head(&comp_workspace_wait[i]);
 	}
-	return 0;
 }
 
 /*
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index a12059f..9afb0a6 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -19,7 +19,7 @@
 #ifndef __BTRFS_COMPRESSION_
 #define __BTRFS_COMPRESSION_
 
-int btrfs_init_compress(void);
+void btrfs_init_compress(void);
 void btrfs_exit_compress(void);
 
 int btrfs_compress_pages(int type, struct address_space *mapping,
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 0639a55..9d472c2 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -36,7 +36,7 @@ static int balance_node_right(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root,
 			      struct extent_buffer *dst_buf,
 			      struct extent_buffer *src_buf);
-static int del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+static void del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		   struct btrfs_path *path, int level, int slot);
 
 struct btrfs_path *btrfs_alloc_path(void)
@@ -1010,10 +1010,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		if (btrfs_header_nritems(right) == 0) {
 			clean_tree_block(trans, root, right);
 			btrfs_tree_unlock(right);
-			wret = del_ptr(trans, root, path, level + 1, pslot +
-				       1);
-			if (wret)
-				ret = wret;
+			del_ptr(trans, root, path, level + 1, pslot + 1);
 			root_sub_used(root, right->len);
 			btrfs_free_tree_block(trans, root, right, 0, 1, 0);
 			free_extent_buffer(right);
@@ -1051,9 +1048,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 	if (btrfs_header_nritems(mid) == 0) {
 		clean_tree_block(trans, root, mid);
 		btrfs_tree_unlock(mid);
-		wret = del_ptr(trans, root, path, level + 1, pslot);
-		if (wret)
-			ret = wret;
+		del_ptr(trans, root, path, level + 1, pslot);
 		root_sub_used(root, mid->len);
 		btrfs_free_tree_block(trans, root, mid, 0, 1, 0);
 		free_extent_buffer(mid);
@@ -1881,15 +1876,12 @@ done:
  * fixing up pointers when a given leaf/node is not in slot 0 of the
  * higher levels
  *
- * If this fails to write a tree block, it returns -1, but continues
- * fixing up the blocks in ram so the tree is consistent.
  */
-static int fixup_low_keys(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root, struct btrfs_path *path,
-			  struct btrfs_disk_key *key, int level)
+static void fixup_low_keys(struct btrfs_trans_handle *trans,
+			   struct btrfs_root *root, struct btrfs_path *path,
+			   struct btrfs_disk_key *key, int level)
 {
 	int i;
-	int ret = 0;
 	struct extent_buffer *t;
 
 	for (i = level; i < BTRFS_MAX_LEVEL; i++) {
@@ -1902,7 +1894,6 @@ static int fixup_low_keys(struct btrfs_trans_handle *trans,
 		if (tslot != 0)
 			break;
 	}
-	return ret;
 }
 
 /*
@@ -1911,9 +1902,9 @@ static int fixup_low_keys(struct btrfs_trans_handle *trans,
  * This function isn't completely safe. It's the caller's responsibility
  * that the new key won't break the order
  */
-int btrfs_set_item_key_safe(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root, struct btrfs_path *path,
-			    struct btrfs_key *new_key)
+void btrfs_set_item_key_safe(struct btrfs_trans_handle *trans,
+			     struct btrfs_root *root, struct btrfs_path *path,
+			     struct btrfs_key *new_key)
 {
 	struct btrfs_disk_key disk_key;
 	struct extent_buffer *eb;
@@ -1923,13 +1914,11 @@ int btrfs_set_item_key_safe(struct btrfs_trans_handle *trans,
 	slot = path->slots[0];
 	if (slot > 0) {
 		btrfs_item_key(eb, &disk_key, slot - 1);
-		if (comp_keys(&disk_key, new_key) >= 0)
-			return -1;
+		BUG_ON(comp_keys(&disk_key, new_key) >= 0);
 	}
 	if (slot < btrfs_header_nritems(eb) - 1) {
 		btrfs_item_key(eb, &disk_key, slot + 1);
-		if (comp_keys(&disk_key, new_key) <= 0)
-			return -1;
+		BUG_ON(comp_keys(&disk_key, new_key) <= 0);
 	}
 
 	btrfs_cpu_key_to_disk(&disk_key, new_key);
@@ -1937,7 +1926,6 @@ int btrfs_set_item_key_safe(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(eb);
 	if (slot == 0)
 		fixup_low_keys(trans, root, path, &disk_key, 1);
-	return 0;
 }
 
 /*
@@ -2140,12 +2128,11 @@ static noinline int insert_new_root(struct btrfs_trans_handle *trans,
  *
  * slot and level indicate where you want the key to go, and
  * blocknr is the block the key points to.
- *
- * returns zero on success and < 0 on any error
  */
-static int insert_ptr(struct btrfs_trans_handle *trans, struct btrfs_root
-		      *root, struct btrfs_path *path, struct btrfs_disk_key
-		      *key, u64 bytenr, int slot, int level)
+static void insert_ptr(struct btrfs_trans_handle *trans,
+		       struct btrfs_root *root, struct btrfs_path *path,
+		       struct btrfs_disk_key *key, u64 bytenr,
+		       int slot, int level)
 {
 	struct extent_buffer *lower;
 	int nritems;
@@ -2155,8 +2142,7 @@ static int insert_ptr(struct btrfs_trans_handle *trans, struct btrfs_root
 	lower = path->nodes[level];
 	nritems = btrfs_header_nritems(lower);
 	BUG_ON(slot > nritems);
-	if (nritems == BTRFS_NODEPTRS_PER_BLOCK(root))
-		BUG();
+	BUG_ON(nritems == BTRFS_NODEPTRS_PER_BLOCK(root));
 	if (slot != nritems) {
 		memmove_extent_buffer(lower,
 			      btrfs_node_key_ptr_offset(slot + 1),
@@ -2169,7 +2155,6 @@ static int insert_ptr(struct btrfs_trans_handle *trans, struct btrfs_root
 	btrfs_set_node_ptr_generation(lower, slot, trans->transid);
 	btrfs_set_header_nritems(lower, nritems + 1);
 	btrfs_mark_buffer_dirty(lower);
-	return 0;
 }
 
 /*
@@ -2190,7 +2175,6 @@ static noinline int split_node(struct btrfs_trans_handle *trans,
 	struct btrfs_disk_key disk_key;
 	int mid;
 	int ret;
-	int wret;
 	u32 c_nritems;
 
 	c = path->nodes[level];
@@ -2247,11 +2231,8 @@ static noinline int split_node(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(c);
 	btrfs_mark_buffer_dirty(split);
 
-	wret = insert_ptr(trans, root, path, &disk_key, split->start,
-			  path->slots[level + 1] + 1,
-			  level + 1);
-	if (wret)
-		ret = wret;
+	insert_ptr(trans, root, path, &disk_key, split->start,
+		   path->slots[level + 1] + 1, level + 1);
 
 	if (path->slots[level] >= mid) {
 		path->slots[level] -= mid;
@@ -2537,7 +2518,6 @@ static noinline int __push_leaf_left(struct btrfs_trans_handle *trans,
 	u32 old_left_nritems;
 	u32 nr;
 	int ret = 0;
-	int wret;
 	u32 this_item_size;
 	u32 old_left_item_size;
 
@@ -2643,9 +2623,7 @@ static noinline int __push_leaf_left(struct btrfs_trans_handle *trans,
 		clean_tree_block(trans, root, right);
 
 	btrfs_item_key(right, &disk_key, 0);
-	wret = fixup_low_keys(trans, root, path, &disk_key, 1);
-	if (wret)
-		ret = wret;
+	fixup_low_keys(trans, root, path, &disk_key, 1);
 
 	/* then fixup the leaf pointer in the path */
 	if (path->slots[0] < push_items) {
@@ -2738,21 +2716,17 @@ out:
 /*
  * split the path's leaf in two, making sure there is at least data_size
  * available for the resulting leaf level of the path.
- *
- * returns 0 if all went well and < 0 on failure.
  */
-static noinline int copy_for_split(struct btrfs_trans_handle *trans,
-			       struct btrfs_root *root,
-			       struct btrfs_path *path,
-			       struct extent_buffer *l,
-			       struct extent_buffer *right,
-			       int slot, int mid, int nritems)
+static noinline void copy_for_split(struct btrfs_trans_handle *trans,
+				    struct btrfs_root *root,
+				    struct btrfs_path *path,
+				    struct extent_buffer *l,
+				    struct extent_buffer *right,
+				    int slot, int mid, int nritems)
 {
 	int data_copy_size;
 	int rt_data_off;
 	int i;
-	int ret = 0;
-	int wret;
 	struct btrfs_disk_key disk_key;
 
 	nritems = nritems - mid;
@@ -2780,12 +2754,9 @@ static noinline int copy_for_split(struct btrfs_trans_handle *trans,
 	}
 
 	btrfs_set_header_nritems(l, mid);
-	ret = 0;
 	btrfs_item_key(right, &disk_key, 0);
-	wret = insert_ptr(trans, root, path, &disk_key, right->start,
-			  path->slots[1] + 1, 1);
-	if (wret)
-		ret = wret;
+	insert_ptr(trans, root, path, &disk_key, right->start,
+		   path->slots[1] + 1, 1);
 
 	btrfs_mark_buffer_dirty(right);
 	btrfs_mark_buffer_dirty(l);
@@ -2803,8 +2774,6 @@ static noinline int copy_for_split(struct btrfs_trans_handle *trans,
 	}
 
 	BUG_ON(path->slots[0] < 0);
-
-	return ret;
 }
 
 /*
@@ -2993,12 +2962,8 @@ again:
 	if (split == 0) {
 		if (mid <= slot) {
 			btrfs_set_header_nritems(right, 0);
-			wret = insert_ptr(trans, root, path,
-					  &disk_key, right->start,
-					  path->slots[1] + 1, 1);
-			if (wret)
-				ret = wret;
-
+			insert_ptr(trans, root, path, &disk_key, right->start,
+				   path->slots[1] + 1, 1);
 			btrfs_tree_unlock(path->nodes[0]);
 			free_extent_buffer(path->nodes[0]);
 			path->nodes[0] = right;
@@ -3006,29 +2971,21 @@ again:
 			path->slots[1] += 1;
 		} else {
 			btrfs_set_header_nritems(right, 0);
-			wret = insert_ptr(trans, root, path,
-					  &disk_key,
-					  right->start,
+			insert_ptr(trans, root, path, &disk_key, right->start,
 					  path->slots[1], 1);
-			if (wret)
-				ret = wret;
 			btrfs_tree_unlock(path->nodes[0]);
 			free_extent_buffer(path->nodes[0]);
 			path->nodes[0] = right;
 			path->slots[0] = 0;
-			if (path->slots[1] == 0) {
-				wret = fixup_low_keys(trans, root,
-						path, &disk_key, 1);
-				if (wret)
-					ret = wret;
-			}
+			if (path->slots[1] == 0)
+				fixup_low_keys(trans, root, path,
+					       &disk_key, 1);
 		}
 		btrfs_mark_buffer_dirty(right);
 		return ret;
 	}
 
-	ret = copy_for_split(trans, root, path, l, right, slot, mid, nritems);
-	BUG_ON(ret);
+	copy_for_split(trans, root, path, l, right, slot, mid, nritems);
 
 	if (split == 2) {
 		BUG_ON(num_doubles != 0);
@@ -3036,7 +2993,7 @@ again:
 		goto again;
 	}
 
-	return ret;
+	return 0;
 
 push_for_double:
 	push_for_double_split(trans, root, path, data_size);
@@ -3238,11 +3195,9 @@ int btrfs_duplicate_item(struct btrfs_trans_handle *trans,
 		return ret;
 
 	path->slots[0]++;
-	ret = setup_items_for_insert(trans, root, path, new_key, &item_size,
-				     item_size, item_size +
-				     sizeof(struct btrfs_item), 1);
-	BUG_ON(ret);
-
+	setup_items_for_insert(trans, root, path, new_key, &item_size,
+			       item_size, item_size +
+			       sizeof(struct btrfs_item), 1);
 	leaf = path->nodes[0];
 	memcpy_extent_buffer(leaf,
 			     btrfs_item_ptr_offset(leaf, path->slots[0]),
@@ -3257,10 +3212,10 @@ int btrfs_duplicate_item(struct btrfs_trans_handle *trans,
  * off the end of the item or if we shift the item to chop bytes off
  * the front.
  */
-int btrfs_truncate_item(struct btrfs_trans_handle *trans,
-			struct btrfs_root *root,
-			struct btrfs_path *path,
-			u32 new_size, int from_end)
+void btrfs_truncate_item(struct btrfs_trans_handle *trans,
+			 struct btrfs_root *root,
+			 struct btrfs_path *path,
+			 u32 new_size, int from_end)
 {
 	int slot;
 	struct extent_buffer *leaf;
@@ -3277,7 +3232,7 @@ int btrfs_truncate_item(struct btrfs_trans_handle *trans,
 
 	old_size = btrfs_item_size_nr(leaf, slot);
 	if (old_size == new_size)
-		return 0;
+		return;
 
 	nritems = btrfs_header_nritems(leaf);
 	data_end = leaf_data_end(root, leaf);
@@ -3350,15 +3305,14 @@ int btrfs_truncate_item(struct btrfs_trans_handle *trans,
 		btrfs_print_leaf(root, leaf);
 		BUG();
 	}
-	return 0;
 }
 
 /*
  * make the item pointed to by the path bigger, data_size is the new size.
  */
-int btrfs_extend_item(struct btrfs_trans_handle *trans,
-		      struct btrfs_root *root, struct btrfs_path *path,
-		      u32 data_size)
+void btrfs_extend_item(struct btrfs_trans_handle *trans,
+		       struct btrfs_root *root, struct btrfs_path *path,
+		       u32 data_size)
 {
 	int slot;
 	struct extent_buffer *leaf;
@@ -3416,7 +3370,6 @@ int btrfs_extend_item(struct btrfs_trans_handle *trans,
 		btrfs_print_leaf(root, leaf);
 		BUG();
 	}
-	return 0;
 }
 
 /*
@@ -3544,7 +3497,7 @@ int btrfs_insert_some_items(struct btrfs_trans_handle *trans,
 	ret = 0;
 	if (slot == 0) {
 		btrfs_cpu_key_to_disk(&disk_key, cpu_key);
-		ret = fixup_low_keys(trans, root, path, &disk_key, 1);
+		fixup_low_keys(trans, root, path, &disk_key, 1);
 	}
 
 	if (btrfs_leaf_free_space(root, leaf) < 0) {
@@ -3562,17 +3515,16 @@ out:
  * to save stack depth by doing the bulk of the work in a function
  * that doesn't call btrfs_search_slot
  */
-int setup_items_for_insert(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root, struct btrfs_path *path,
-			   struct btrfs_key *cpu_key, u32 *data_size,
-			   u32 total_data, u32 total_size, int nr)
+void setup_items_for_insert(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root, struct btrfs_path *path,
+			    struct btrfs_key *cpu_key, u32 *data_size,
+			    u32 total_data, u32 total_size, int nr)
 {
 	struct btrfs_item *item;
 	int i;
 	u32 nritems;
 	unsigned int data_end;
 	struct btrfs_disk_key disk_key;
-	int ret;
 	struct extent_buffer *leaf;
 	int slot;
 
@@ -3633,10 +3585,9 @@ int setup_items_for_insert(struct btrfs_trans_handle *trans,
 
 	btrfs_set_header_nritems(leaf, nritems + nr);
 
-	ret = 0;
 	if (slot == 0) {
 		btrfs_cpu_key_to_disk(&disk_key, cpu_key);
-		ret = fixup_low_keys(trans, root, path, &disk_key, 1);
+		fixup_low_keys(trans, root, path, &disk_key, 1);
 	}
 	btrfs_unlock_up_safe(path, 1);
 	btrfs_mark_buffer_dirty(leaf);
@@ -3645,7 +3596,6 @@ int setup_items_for_insert(struct btrfs_trans_handle *trans,
 		btrfs_print_leaf(root, leaf);
 		BUG();
 	}
-	return ret;
 }
 
 /*
@@ -3672,16 +3622,14 @@ int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
 	if (ret == 0)
 		return -EEXIST;
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	slot = path->slots[0];
 	BUG_ON(slot < 0);
 
-	ret = setup_items_for_insert(trans, root, path, cpu_key, data_size,
+	setup_items_for_insert(trans, root, path, cpu_key, data_size,
 			       total_data, total_size, nr);
-
-out:
-	return ret;
+	return 0;
 }
 
 /*
@@ -3717,13 +3665,11 @@ int btrfs_insert_item(struct btrfs_trans_handle *trans, struct btrfs_root
  * the tree should have been previously balanced so the deletion does not
  * empty a node.
  */
-static int del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		   struct btrfs_path *path, int level, int slot)
+static void del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		    struct btrfs_path *path, int level, int slot)
 {
 	struct extent_buffer *parent = path->nodes[level];
 	u32 nritems;
-	int ret = 0;
-	int wret;
 
 	nritems = btrfs_header_nritems(parent);
 	if (slot != nritems - 1) {
@@ -3743,12 +3689,9 @@ static int del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		struct btrfs_disk_key disk_key;
 
 		btrfs_node_key(parent, &disk_key, 0);
-		wret = fixup_low_keys(trans, root, path, &disk_key, level + 1);
-		if (wret)
-			ret = wret;
+		fixup_low_keys(trans, root, path, &disk_key, level + 1);
 	}
 	btrfs_mark_buffer_dirty(parent);
-	return ret;
 }
 
 /*
@@ -3761,17 +3704,13 @@ static int del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
  * The path must have already been setup for deleting the leaf, including
  * all the proper balancing.  path->nodes[1] must be locked.
  */
-static noinline int btrfs_del_leaf(struct btrfs_trans_handle *trans,
-				   struct btrfs_root *root,
-				   struct btrfs_path *path,
-				   struct extent_buffer *leaf)
+static noinline void btrfs_del_leaf(struct btrfs_trans_handle *trans,
+				    struct btrfs_root *root,
+				    struct btrfs_path *path,
+				    struct extent_buffer *leaf)
 {
-	int ret;
-
 	WARN_ON(btrfs_header_generation(leaf) != trans->transid);
-	ret = del_ptr(trans, root, path, 1, path->slots[1]);
-	if (ret)
-		return ret;
+	del_ptr(trans, root, path, 1, path->slots[1]);
 
 	/*
 	 * btrfs_free_extent is expensive, we want to make sure we
@@ -3782,7 +3721,6 @@ static noinline int btrfs_del_leaf(struct btrfs_trans_handle *trans,
 	root_sub_used(root, leaf->len);
 
 	btrfs_free_tree_block(trans, root, leaf, 0, 1, 0);
-	return 0;
 }
 /*
  * delete the item at the leaf level in path.  If that empties
@@ -3839,8 +3777,7 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		} else {
 			btrfs_set_path_blocking(path);
 			clean_tree_block(trans, root, leaf);
-			ret = btrfs_del_leaf(trans, root, path, leaf);
-			BUG_ON(ret);
+			btrfs_del_leaf(trans, root, path, leaf);
 		}
 	} else {
 		int used = leaf_space_used(leaf, 0, nritems);
@@ -3848,10 +3785,7 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 			struct btrfs_disk_key disk_key;
 
 			btrfs_item_key(leaf, &disk_key, 0);
-			wret = fixup_low_keys(trans, root, path,
-					      &disk_key, 1);
-			if (wret)
-				ret = wret;
+			fixup_low_keys(trans, root, path, &disk_key, 1);
 		}
 
 		/* delete the leaf if it is mostly empty */
@@ -3879,9 +3813,9 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 
 			if (btrfs_header_nritems(leaf) == 0) {
 				path->slots[1] = slot;
-				ret = btrfs_del_leaf(trans, root, path, leaf);
-				BUG_ON(ret);
+				btrfs_del_leaf(trans, root, path, leaf);
 				free_extent_buffer(leaf);
+				ret = 0;
 			} else {
 				/* if we're still in the path, make sure
 				 * we're dirty.  Otherwise, one of the
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 339e637..30c5a24 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2485,8 +2485,8 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 int btrfs_free_reserved_extent(struct btrfs_root *root, u64 start, u64 len);
 int btrfs_free_and_pin_reserved_extent(struct btrfs_root *root,
 				       u64 start, u64 len);
-int btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root);
+void btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
+				 struct btrfs_root *root);
 int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root);
 int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
@@ -2549,8 +2549,8 @@ void btrfs_block_rsv_release(struct btrfs_root *root,
 			     u64 num_bytes);
 int btrfs_set_block_group_ro(struct btrfs_root *root,
 			     struct btrfs_block_group_cache *cache);
-int btrfs_set_block_group_rw(struct btrfs_root *root,
-			     struct btrfs_block_group_cache *cache);
+void btrfs_set_block_group_rw(struct btrfs_root *root,
+			      struct btrfs_block_group_cache *cache);
 void btrfs_put_block_group_cache(struct btrfs_fs_info *info);
 u64 btrfs_account_ro_block_groups_free_space(struct btrfs_space_info *sinfo);
 int btrfs_error_unpin_extent_range(struct btrfs_root *root,
@@ -2569,9 +2569,9 @@ int btrfs_comp_cpu_keys(struct btrfs_key *k1, struct btrfs_key *k2);
 int btrfs_previous_item(struct btrfs_root *root,
 			struct btrfs_path *path, u64 min_objectid,
 			int type);
-int btrfs_set_item_key_safe(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root, struct btrfs_path *path,
-			    struct btrfs_key *new_key);
+void btrfs_set_item_key_safe(struct btrfs_trans_handle *trans,
+			     struct btrfs_root *root, struct btrfs_path *path,
+			     struct btrfs_key *new_key);
 struct extent_buffer *btrfs_root_node(struct btrfs_root *root);
 struct extent_buffer *btrfs_lock_root_node(struct btrfs_root *root);
 int btrfs_find_next_key(struct btrfs_root *root, struct btrfs_path *path,
@@ -2591,12 +2591,13 @@ int btrfs_copy_root(struct btrfs_trans_handle *trans,
 		      struct extent_buffer **cow_ret, u64 new_root_objectid);
 int btrfs_block_can_be_shared(struct btrfs_root *root,
 			      struct extent_buffer *buf);
-int btrfs_extend_item(struct btrfs_trans_handle *trans, struct btrfs_root
-		      *root, struct btrfs_path *path, u32 data_size);
-int btrfs_truncate_item(struct btrfs_trans_handle *trans,
-			struct btrfs_root *root,
-			struct btrfs_path *path,
-			u32 new_size, int from_end);
+void btrfs_extend_item(struct btrfs_trans_handle *trans,
+		       struct btrfs_root *root, struct btrfs_path *path,
+		       u32 data_size);
+void btrfs_truncate_item(struct btrfs_trans_handle *trans,
+			 struct btrfs_root *root,
+			 struct btrfs_path *path,
+			 u32 new_size, int from_end);
 int btrfs_split_item(struct btrfs_trans_handle *trans,
 		     struct btrfs_root *root,
 		     struct btrfs_path *path,
@@ -2630,10 +2631,10 @@ static inline int btrfs_del_item(struct btrfs_trans_handle *trans,
 	return btrfs_del_items(trans, root, path, path->slots[0], 1);
 }
 
-int setup_items_for_insert(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root, struct btrfs_path *path,
-			   struct btrfs_key *cpu_key, u32 *data_size,
-			   u32 total_data, u32 total_size, int nr);
+void setup_items_for_insert(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root, struct btrfs_path *path,
+			    struct btrfs_key *cpu_key, u32 *data_size,
+			    u32 total_data, u32 total_size, int nr);
 int btrfs_insert_item(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, struct btrfs_key *key, void *data, u32 data_size);
 int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
@@ -2911,7 +2912,7 @@ int btrfs_orphan_cleanup(struct btrfs_root *root);
 void btrfs_orphan_commit_root(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root);
 int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size);
-int btrfs_invalidate_inodes(struct btrfs_root *root);
+void btrfs_invalidate_inodes(struct btrfs_root *root);
 void btrfs_add_delayed_iput(struct inode *inode);
 void btrfs_run_delayed_iputs(struct btrfs_root *root);
 int btrfs_prealloc_file_range(struct inode *inode, int mode,
@@ -3021,10 +3022,10 @@ void btrfs_reloc_post_snapshot(struct btrfs_trans_handle *trans,
 /* scrub.c */
 int btrfs_scrub_dev(struct btrfs_root *root, u64 devid, u64 start, u64 end,
 		    struct btrfs_scrub_progress *progress, int readonly);
-int btrfs_scrub_pause(struct btrfs_root *root);
-int btrfs_scrub_pause_super(struct btrfs_root *root);
-int btrfs_scrub_continue(struct btrfs_root *root);
-int btrfs_scrub_continue_super(struct btrfs_root *root);
+void btrfs_scrub_pause(struct btrfs_root *root);
+void btrfs_scrub_pause_super(struct btrfs_root *root);
+void btrfs_scrub_continue(struct btrfs_root *root);
+void btrfs_scrub_continue_super(struct btrfs_root *root);
 int btrfs_scrub_cancel(struct btrfs_root *root);
 int btrfs_scrub_cancel_dev(struct btrfs_root *root, struct btrfs_device *dev);
 int btrfs_scrub_cancel_devid(struct btrfs_root *root, u64 devid);
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index fe4cd0f..6829590 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -836,10 +836,8 @@ static int btrfs_batch_insert_items(struct btrfs_trans_handle *trans,
 	btrfs_clear_path_blocking(path, NULL, 0);
 
 	/* insert the keys of the items */
-	ret = setup_items_for_insert(trans, root, path, keys, data_size,
-				     total_data_size, total_size, nitems);
-	if (ret)
-		goto error;
+	setup_items_for_insert(trans, root, path, keys, data_size,
+			       total_data_size, total_size, nitems);
 
 	/* insert the dir index items */
 	slot = path->slots[0];
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 29ecd54..69f22e3 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -420,7 +420,7 @@ update_existing_head_ref(struct btrfs_delayed_ref_node *existing,
  * this does all the dirty work in terms of maintaining the correct
  * overall modification count.
  */
-static noinline int add_delayed_ref_head(struct btrfs_fs_info *fs_info,
+static noinline void add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 					struct btrfs_trans_handle *trans,
 					struct btrfs_delayed_ref_node *ref,
 					u64 bytenr, u64 num_bytes,
@@ -494,13 +494,12 @@ static noinline int add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 		delayed_refs->num_entries++;
 		trans->delayed_ref_updates++;
 	}
-	return 0;
 }
 
 /*
  * helper to insert a delayed tree ref into the rbtree.
  */
-static noinline int add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
+static noinline void add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 					 struct btrfs_trans_handle *trans,
 					 struct btrfs_delayed_ref_node *ref,
 					 u64 bytenr, u64 num_bytes, u64 parent,
@@ -554,13 +553,12 @@ static noinline int add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 		delayed_refs->num_entries++;
 		trans->delayed_ref_updates++;
 	}
-	return 0;
 }
 
 /*
  * helper to insert a delayed data ref into the rbtree.
  */
-static noinline int add_delayed_data_ref(struct btrfs_fs_info *fs_info,
+static noinline void add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 					 struct btrfs_trans_handle *trans,
 					 struct btrfs_delayed_ref_node *ref,
 					 u64 bytenr, u64 num_bytes, u64 parent,
@@ -616,7 +614,6 @@ static noinline int add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 		delayed_refs->num_entries++;
 		trans->delayed_ref_updates++;
 	}
-	return 0;
 }
 
 /*
@@ -634,7 +631,6 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 	struct btrfs_delayed_tree_ref *ref;
 	struct btrfs_delayed_ref_head *head_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
-	int ret;
 
 	BUG_ON(extent_op && extent_op->is_data);
 	ref = kmalloc(sizeof(*ref), GFP_NOFS);
@@ -656,14 +652,12 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 	 * insert both the head node and the new ref without dropping
 	 * the spin lock
 	 */
-	ret = add_delayed_ref_head(fs_info, trans, &head_ref->node, bytenr,
+	add_delayed_ref_head(fs_info, trans, &head_ref->node, bytenr,
 				   num_bytes, action, 0);
-	BUG_ON(ret);
 
-	ret = add_delayed_tree_ref(fs_info, trans, &ref->node, bytenr,
+	add_delayed_tree_ref(fs_info, trans, &ref->node, bytenr,
 				   num_bytes, parent, ref_root, level, action,
 				   for_cow);
-	BUG_ON(ret);
 	if (!need_ref_seq(for_cow, ref_root) &&
 	    waitqueue_active(&delayed_refs->seq_wait))
 		wake_up(&delayed_refs->seq_wait);
@@ -685,7 +679,6 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	struct btrfs_delayed_data_ref *ref;
 	struct btrfs_delayed_ref_head *head_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
-	int ret;
 
 	BUG_ON(extent_op && !extent_op->is_data);
 	ref = kmalloc(sizeof(*ref), GFP_NOFS);
@@ -707,14 +700,12 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	 * insert both the head node and the new ref without dropping
 	 * the spin lock
 	 */
-	ret = add_delayed_ref_head(fs_info, trans, &head_ref->node, bytenr,
+	add_delayed_ref_head(fs_info, trans, &head_ref->node, bytenr,
 				   num_bytes, action, 1);
-	BUG_ON(ret);
 
-	ret = add_delayed_data_ref(fs_info, trans, &ref->node, bytenr,
+	add_delayed_data_ref(fs_info, trans, &ref->node, bytenr,
 				   num_bytes, parent, ref_root, owner, offset,
 				   action, for_cow);
-	BUG_ON(ret);
 	if (!need_ref_seq(for_cow, ref_root) &&
 	    waitqueue_active(&delayed_refs->seq_wait))
 		wake_up(&delayed_refs->seq_wait);
@@ -729,7 +720,6 @@ int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_delayed_ref_head *head_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
-	int ret;
 
 	head_ref = kmalloc(sizeof(*head_ref), GFP_NOFS);
 	if (!head_ref)
@@ -740,10 +730,9 @@ int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
 	delayed_refs = &trans->transaction->delayed_refs;
 	spin_lock(&delayed_refs->lock);
 
-	ret = add_delayed_ref_head(fs_info, trans, &head_ref->node, bytenr,
+	add_delayed_ref_head(fs_info, trans, &head_ref->node, bytenr,
 				   num_bytes, BTRFS_UPDATE_DELAYED_HEAD,
 				   extent_op->is_data);
-	BUG_ON(ret);
 
 	if (waitqueue_active(&delayed_refs->seq_wait))
 		wake_up(&delayed_refs->seq_wait);
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 31d84e7..7674330 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -49,9 +49,8 @@ static struct btrfs_dir_item *insert_with_overflow(struct btrfs_trans_handle
 		di = btrfs_match_dir_item_name(root, path, name, name_len);
 		if (di)
 			return ERR_PTR(-EEXIST);
-		ret = btrfs_extend_item(trans, root, path, data_size);
-	}
-	if (ret < 0)
+		btrfs_extend_item(trans, root, path, data_size);
+	} else if (ret < 0)
 		return ERR_PTR(ret);
 	WARN_ON(ret > 0);
 	leaf = path->nodes[0];
@@ -383,8 +382,8 @@ int btrfs_delete_one_dir_name(struct btrfs_trans_handle *trans,
 		start = btrfs_item_ptr_offset(leaf, path->slots[0]);
 		memmove_extent_buffer(leaf, ptr, ptr + sub_item_len,
 			item_len - (ptr + sub_item_len - start));
-		ret = btrfs_truncate_item(trans, root, path,
-					  item_len - sub_item_len, 1);
+		btrfs_truncate_item(trans, root, path,
+				    item_len - sub_item_len, 1);
 	}
 	return ret;
 }
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2e4428b..73ccadc 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -50,12 +50,12 @@ static void end_workqueue_fn(struct btrfs_work *work);
 static void free_fs_root(struct btrfs_root *root);
 static void btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 				    int read_only);
-static int btrfs_destroy_ordered_operations(struct btrfs_root *root);
-static int btrfs_destroy_ordered_extents(struct btrfs_root *root);
+static void btrfs_destroy_ordered_operations(struct btrfs_root *root);
+static void btrfs_destroy_ordered_extents(struct btrfs_root *root);
 static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 				      struct btrfs_root *root);
-static int btrfs_destroy_pending_snapshots(struct btrfs_transaction *t);
-static int btrfs_destroy_delalloc_inodes(struct btrfs_root *root);
+static void btrfs_destroy_pending_snapshots(struct btrfs_transaction *t);
+static void btrfs_destroy_delalloc_inodes(struct btrfs_root *root);
 static int btrfs_destroy_marked_extents(struct btrfs_root *root,
 					struct extent_io_tree *dirty_pages,
 					int mark);
@@ -1139,10 +1139,10 @@ void clean_tree_block(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	}
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
@@ -1194,7 +1194,6 @@ static int __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 	root->defrag_running = 0;
 	root->root_key.objectid = objectid;
 	root->anon_dev = 0;
-	return 0;
 }
 
 static int __must_check find_and_setup_root(struct btrfs_root *tree_root,
@@ -2897,7 +2896,7 @@ int write_ctree_super(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-int btrfs_free_fs_root(struct btrfs_fs_info *fs_info, struct btrfs_root *root)
+void btrfs_free_fs_root(struct btrfs_fs_info *fs_info, struct btrfs_root *root)
 {
 	spin_lock(&fs_info->fs_roots_radix_lock);
 	radix_tree_delete(&fs_info->fs_roots_radix,
@@ -2910,7 +2909,6 @@ int btrfs_free_fs_root(struct btrfs_fs_info *fs_info, struct btrfs_root *root)
 	__btrfs_remove_free_space_cache(root->free_ino_pinned);
 	__btrfs_remove_free_space_cache(root->free_ino_ctl);
 	free_fs_root(root);
-	return 0;
 }
 
 static void free_fs_root(struct btrfs_root *root)
@@ -2927,7 +2925,7 @@ static void free_fs_root(struct btrfs_root *root)
 	kfree(root);
 }
 
-static int del_fs_roots(struct btrfs_fs_info *fs_info)
+static void del_fs_roots(struct btrfs_fs_info *fs_info)
 {
 	int ret;
 	struct btrfs_root *gang[8];
@@ -2956,7 +2954,6 @@ static int del_fs_roots(struct btrfs_fs_info *fs_info)
 		for (i = 0; i < ret; i++)
 			btrfs_free_fs_root(fs_info, gang[i]);
 	}
-	return 0;
 }
 
 int btrfs_cleanup_fs_roots(struct btrfs_fs_info *fs_info)
@@ -3299,7 +3296,7 @@ int btrfs_error_commit_super(struct btrfs_root *root)
 	return ret;
 }
 
-static int btrfs_destroy_ordered_operations(struct btrfs_root *root)
+static void btrfs_destroy_ordered_operations(struct btrfs_root *root)
 {
 	struct btrfs_inode *btrfs_inode;
 	struct list_head splice;
@@ -3321,11 +3318,9 @@ static int btrfs_destroy_ordered_operations(struct btrfs_root *root)
 
 	spin_unlock(&root->fs_info->ordered_extent_lock);
 	mutex_unlock(&root->fs_info->ordered_operations_mutex);
-
-	return 0;
 }
 
-static int btrfs_destroy_ordered_extents(struct btrfs_root *root)
+static void btrfs_destroy_ordered_extents(struct btrfs_root *root)
 {
 	struct list_head splice;
 	struct btrfs_ordered_extent *ordered;
@@ -3357,8 +3352,6 @@ static int btrfs_destroy_ordered_extents(struct btrfs_root *root)
 	}
 
 	spin_unlock(&root->fs_info->ordered_extent_lock);
-
-	return 0;
 }
 
 static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
@@ -3413,7 +3406,7 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 	return ret;
 }
 
-static int btrfs_destroy_pending_snapshots(struct btrfs_transaction *t)
+static void btrfs_destroy_pending_snapshots(struct btrfs_transaction *t)
 {
 	struct btrfs_pending_snapshot *snapshot;
 	struct list_head splice;
@@ -3431,11 +3424,9 @@ static int btrfs_destroy_pending_snapshots(struct btrfs_transaction *t)
 
 		kfree(snapshot);
 	}
-
-	return 0;
 }
 
-static int btrfs_destroy_delalloc_inodes(struct btrfs_root *root)
+static void btrfs_destroy_delalloc_inodes(struct btrfs_root *root)
 {
 	struct btrfs_inode *btrfs_inode;
 	struct list_head splice;
@@ -3455,8 +3446,6 @@ static int btrfs_destroy_delalloc_inodes(struct btrfs_root *root)
 	}
 
 	spin_unlock(&root->fs_info->delalloc_lock);
-
-	return 0;
 }
 
 static int btrfs_destroy_marked_extents(struct btrfs_root *root,
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index ca34237..1608492 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -64,7 +64,7 @@ struct btrfs_root *btrfs_read_fs_root_no_name(struct btrfs_fs_info *fs_info,
 int btrfs_cleanup_fs_roots(struct btrfs_fs_info *fs_info);
 void btrfs_btree_balance_dirty(struct btrfs_root *root, unsigned long nr);
 void __btrfs_btree_balance_dirty(struct btrfs_root *root, unsigned long nr);
-int btrfs_free_fs_root(struct btrfs_fs_info *fs_info, struct btrfs_root *root);
+void btrfs_free_fs_root(struct btrfs_fs_info *fs_info, struct btrfs_root *root);
 void btrfs_mark_buffer_dirty(struct extent_buffer *buf);
 int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid);
 int btrfs_set_buffer_uptodate(struct extent_buffer *buf);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c32a9bf..0daa1df 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1010,7 +1010,7 @@ static int convert_extent_item_v0(struct btrfs_trans_handle *trans,
 		return ret;
 	BUG_ON(ret);
 
-	ret = btrfs_extend_item(trans, root, path, new_size);
+	btrfs_extend_item(trans, root, path, new_size);
 
 	leaf = path->nodes[0];
 	item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_item);
@@ -1592,13 +1592,13 @@ out:
  * helper to add new inline back ref
  */
 static noinline_for_stack
-int setup_inline_extent_backref(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root,
-				struct btrfs_path *path,
-				struct btrfs_extent_inline_ref *iref,
-				u64 parent, u64 root_objectid,
-				u64 owner, u64 offset, int refs_to_add,
-				struct btrfs_delayed_extent_op *extent_op)
+void setup_inline_extent_backref(struct btrfs_trans_handle *trans,
+				 struct btrfs_root *root,
+				 struct btrfs_path *path,
+				 struct btrfs_extent_inline_ref *iref,
+				 u64 parent, u64 root_objectid,
+				 u64 owner, u64 offset, int refs_to_add,
+				 struct btrfs_delayed_extent_op *extent_op)
 {
 	struct extent_buffer *leaf;
 	struct btrfs_extent_item *ei;
@@ -1608,7 +1608,6 @@ int setup_inline_extent_backref(struct btrfs_trans_handle *trans,
 	u64 refs;
 	int size;
 	int type;
-	int ret;
 
 	leaf = path->nodes[0];
 	ei = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_item);
@@ -1617,7 +1616,7 @@ int setup_inline_extent_backref(struct btrfs_trans_handle *trans,
 	type = extent_ref_type(parent, owner);
 	size = btrfs_extent_inline_ref_size(type);
 
-	ret = btrfs_extend_item(trans, root, path, size);
+	btrfs_extend_item(trans, root, path, size);
 
 	ei = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_item);
 	refs = btrfs_extent_refs(leaf, ei);
@@ -1652,7 +1651,6 @@ int setup_inline_extent_backref(struct btrfs_trans_handle *trans,
 		btrfs_set_extent_inline_ref_offset(leaf, iref, root_objectid);
 	}
 	btrfs_mark_buffer_dirty(leaf);
-	return 0;
 }
 
 static int lookup_extent_backref(struct btrfs_trans_handle *trans,
@@ -1687,12 +1685,12 @@ static int lookup_extent_backref(struct btrfs_trans_handle *trans,
  * helper to update/remove inline back ref
  */
 static noinline_for_stack
-int update_inline_extent_backref(struct btrfs_trans_handle *trans,
-				 struct btrfs_root *root,
-				 struct btrfs_path *path,
-				 struct btrfs_extent_inline_ref *iref,
-				 int refs_to_mod,
-				 struct btrfs_delayed_extent_op *extent_op)
+void update_inline_extent_backref(struct btrfs_trans_handle *trans,
+				  struct btrfs_root *root,
+				  struct btrfs_path *path,
+				  struct btrfs_extent_inline_ref *iref,
+				  int refs_to_mod,
+				  struct btrfs_delayed_extent_op *extent_op)
 {
 	struct extent_buffer *leaf;
 	struct btrfs_extent_item *ei;
@@ -1703,7 +1701,6 @@ int update_inline_extent_backref(struct btrfs_trans_handle *trans,
 	u32 item_size;
 	int size;
 	int type;
-	int ret;
 	u64 refs;
 
 	leaf = path->nodes[0];
@@ -1745,10 +1742,9 @@ int update_inline_extent_backref(struct btrfs_trans_handle *trans,
 			memmove_extent_buffer(leaf, ptr, ptr + size,
 					      end - ptr - size);
 		item_size -= size;
-		ret = btrfs_truncate_item(trans, root, path, item_size, 1);
+		btrfs_truncate_item(trans, root, path, item_size, 1);
 	}
 	btrfs_mark_buffer_dirty(leaf);
-	return 0;
 }
 
 static noinline_for_stack
@@ -1768,13 +1764,13 @@ int insert_inline_extent_backref(struct btrfs_trans_handle *trans,
 					   root_objectid, owner, offset, 1);
 	if (ret == 0) {
 		BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID);
-		ret = update_inline_extent_backref(trans, root, path, iref,
-						   refs_to_add, extent_op);
+		update_inline_extent_backref(trans, root, path, iref,
+					     refs_to_add, extent_op);
 	} else if (ret == -ENOENT) {
-		ret = setup_inline_extent_backref(trans, root, path, iref,
-						  parent, root_objectid,
-						  owner, offset, refs_to_add,
-						  extent_op);
+		setup_inline_extent_backref(trans, root, path, iref, parent,
+					    root_objectid, owner, offset,
+					    refs_to_add, extent_op);
+		ret = 0;
 	}
 	return ret;
 }
@@ -1804,12 +1800,12 @@ static int remove_extent_backref(struct btrfs_trans_handle *trans,
 				 struct btrfs_extent_inline_ref *iref,
 				 int refs_to_drop, int is_data)
 {
-	int ret;
+	int ret = 0;
 
 	BUG_ON(!is_data && refs_to_drop != 1);
 	if (iref) {
-		ret = update_inline_extent_backref(trans, root, path, iref,
-						   -refs_to_drop, NULL);
+		update_inline_extent_backref(trans, root, path, iref,
+					     -refs_to_drop, NULL);
 	} else if (is_data) {
 		ret = remove_extent_data_ref(trans, root, path, refs_to_drop);
 	} else {
@@ -4734,7 +4730,7 @@ static int btrfs_update_reserved_bytes(struct btrfs_block_group_cache *cache,
 	return ret;
 }
 
-int btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
+void btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -4764,7 +4760,6 @@ int btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
 	up_write(&fs_info->extent_commit_sem);
 
 	update_global_block_rsv(fs_info);
-	return 0;
 }
 
 static int unpin_extent_range(struct btrfs_root *root, u64 start, u64 end)
@@ -7189,7 +7184,7 @@ u64 btrfs_account_ro_block_groups_free_space(struct btrfs_space_info *sinfo)
 	return free_bytes;
 }
 
-int btrfs_set_block_group_rw(struct btrfs_root *root,
+void btrfs_set_block_group_rw(struct btrfs_root *root,
 			      struct btrfs_block_group_cache *cache)
 {
 	struct btrfs_space_info *sinfo = cache->space_info;
@@ -7205,7 +7200,6 @@ int btrfs_set_block_group_rw(struct btrfs_root *root,
 	cache->ro = 0;
 	spin_unlock(&cache->lock);
 	spin_unlock(&sinfo->lock);
-	return 0;
 }
 
 /*
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8368baa..65216fa 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -142,6 +142,7 @@ static struct extent_state *alloc_extent_state(gfp_t mask)
 #endif
 	atomic_set(&state->refs, 1);
 	init_waitqueue_head(&state->wq);
+	trace_alloc_extent_state(state, mask, _RET_IP_);
 	return state;
 }
 
@@ -159,6 +160,7 @@ void free_extent_state(struct extent_state *state)
 		list_del(&state->leak_list);
 		spin_unlock_irqrestore(&leak_lock, flags);
 #endif
+		trace_free_extent_state(state, _RET_IP_);
 		kmem_cache_free(extent_state_cache, state);
 	}
 }
@@ -617,8 +619,8 @@ search_again:
 	goto again;
 }
 
-static int wait_on_state(struct extent_io_tree *tree,
-			 struct extent_state *state)
+static void wait_on_state(struct extent_io_tree *tree,
+			  struct extent_state *state)
 		__releases(tree->lock)
 		__acquires(tree->lock)
 {
@@ -628,7 +630,6 @@ static int wait_on_state(struct extent_io_tree *tree,
 	schedule();
 	spin_lock(&tree->lock);
 	finish_wait(&state->wq, &wait);
-	return 0;
 }
 
 /*
@@ -636,7 +637,7 @@ static int wait_on_state(struct extent_io_tree *tree,
  * The range [start, end] is inclusive.
  * The tree lock is taken by this function
  */
-int wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits)
+void wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits)
 {
 	struct extent_state *state;
 	struct rb_node *node;
@@ -673,7 +674,6 @@ again:
 	}
 out:
 	spin_unlock(&tree->lock);
-	return 0;
 }
 
 static void set_state_bits(struct extent_io_tree *tree,
@@ -1359,9 +1359,9 @@ out:
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
@@ -1371,7 +1371,7 @@ static noinline int __unlock_for_delalloc(struct inode *inode,
 	int i;
 
 	if (index == locked_page->index && end_index == index)
-		return 0;
+		return;
 
 	while (nr_pages > 0) {
 		ret = find_get_pages_contig(inode->i_mapping, index,
@@ -1386,7 +1386,6 @@ static noinline int __unlock_for_delalloc(struct inode *inode,
 		index += ret;
 		cond_resched();
 	}
-	return 0;
 }
 
 static noinline int lock_delalloc_pages(struct inode *inode,
@@ -1777,39 +1776,34 @@ int test_range_bit(struct extent_io_tree *tree, u64 start, u64 end,
  * helper function to set a given page up to date if all the
  * extents in the tree for that page are up to date
  */
-static int check_page_uptodate(struct extent_io_tree *tree,
-			       struct page *page)
+static void check_page_uptodate(struct extent_io_tree *tree, struct page *page)
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
+static void check_page_locked(struct extent_io_tree *tree, struct page *page)
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
 
 /*
@@ -3835,7 +3829,7 @@ void free_extent_buffer(struct extent_buffer *eb)
 	WARN_ON(1);
 }
 
-int clear_extent_buffer_dirty(struct extent_io_tree *tree,
+void clear_extent_buffer_dirty(struct extent_io_tree *tree,
 			      struct extent_buffer *eb)
 {
 	unsigned long i;
@@ -3867,7 +3861,6 @@ int clear_extent_buffer_dirty(struct extent_io_tree *tree,
 		ClearPageError(page);
 		unlock_page(page);
 	}
-	return 0;
 }
 
 int set_extent_buffer_dirty(struct extent_io_tree *tree,
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index cecc351..f7f321e 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -287,8 +287,8 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 			   unsigned long src_offset, unsigned long len);
 void memset_extent_buffer(struct extent_buffer *eb, char c,
 			  unsigned long start, unsigned long len);
-int wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits);
-int clear_extent_buffer_dirty(struct extent_io_tree *tree,
+void wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits);
+void clear_extent_buffer_dirty(struct extent_io_tree *tree,
 			      struct extent_buffer *eb);
 int set_extent_buffer_dirty(struct extent_io_tree *tree,
 			     struct extent_buffer *eb);
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index c7fb3a4..edb69b4 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -483,18 +483,17 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
  * This calls btrfs_truncate_item with the correct args based on the
  * overlap, and fixes up the key as required.
  */
-static noinline int truncate_one_csum(struct btrfs_trans_handle *trans,
-				      struct btrfs_root *root,
-				      struct btrfs_path *path,
-				      struct btrfs_key *key,
-				      u64 bytenr, u64 len)
+static noinline void truncate_one_csum(struct btrfs_trans_handle *trans,
+				       struct btrfs_root *root,
+				       struct btrfs_path *path,
+				       struct btrfs_key *key,
+				       u64 bytenr, u64 len)
 {
 	struct extent_buffer *leaf;
 	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
 	u64 csum_end;
 	u64 end_byte = bytenr + len;
 	u32 blocksize_bits = root->fs_info->sb->s_blocksize_bits;
-	int ret;
 
 	leaf = path->nodes[0];
 	csum_end = btrfs_item_size_nr(leaf, path->slots[0]) / csum_size;
@@ -510,7 +509,7 @@ static noinline int truncate_one_csum(struct btrfs_trans_handle *trans,
 		 */
 		u32 new_size = (bytenr - key->offset) >> blocksize_bits;
 		new_size *= csum_size;
-		ret = btrfs_truncate_item(trans, root, path, new_size, 1);
+		btrfs_truncate_item(trans, root, path, new_size, 1);
 	} else if (key->offset >= bytenr && csum_end > end_byte &&
 		   end_byte > key->offset) {
 		/*
@@ -522,15 +521,13 @@ static noinline int truncate_one_csum(struct btrfs_trans_handle *trans,
 		u32 new_size = (csum_end - end_byte) >> blocksize_bits;
 		new_size *= csum_size;
 
-		ret = btrfs_truncate_item(trans, root, path, new_size, 0);
+		btrfs_truncate_item(trans, root, path, new_size, 0);
 
 		key->offset = end_byte;
-		ret = btrfs_set_item_key_safe(trans, root, path, key);
-		BUG_ON(ret);
+		btrfs_set_item_key_safe(trans, root, path, key);
 	} else {
 		BUG();
 	}
-	return 0;
 }
 
 /*
@@ -639,9 +636,7 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
 
 			key.offset = end_byte - 1;
 		} else {
-			ret = truncate_one_csum(trans, root, path,
-						&key, bytenr, len);
-			BUG_ON(ret);
+			truncate_one_csum(trans, root, path, &key, bytenr, len);
 			if (key.offset < bytenr)
 				break;
 		}
@@ -772,7 +767,7 @@ again:
 		if (diff != csum_size)
 			goto insert;
 
-		ret = btrfs_extend_item(trans, root, path, diff);
+		btrfs_extend_item(trans, root, path, diff);
 		goto csum;
 	}
 
diff --git a/fs/btrfs/inode-item.c b/fs/btrfs/inode-item.c
index baa74f3..c079240 100644
--- a/fs/btrfs/inode-item.c
+++ b/fs/btrfs/inode-item.c
@@ -128,7 +128,7 @@ int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
 	item_start = btrfs_item_ptr_offset(leaf, path->slots[0]);
 	memmove_extent_buffer(leaf, ptr, ptr + sub_item_len,
 			      item_size - (ptr + sub_item_len - item_start));
-	ret = btrfs_truncate_item(trans, root, path,
+	btrfs_truncate_item(trans, root, path,
 				  item_size - sub_item_len, 1);
 out:
 	btrfs_free_path(path);
@@ -165,7 +165,7 @@ int btrfs_insert_inode_ref(struct btrfs_trans_handle *trans,
 			goto out;
 
 		old_size = btrfs_item_size_nr(path->nodes[0], path->slots[0]);
-		ret = btrfs_extend_item(trans, root, path, ins_len);
+		btrfs_extend_item(trans, root, path, ins_len);
 		ref = btrfs_item_ptr(path->nodes[0], path->slots[0],
 				     struct btrfs_inode_ref);
 		ref = (struct btrfs_inode_ref *)((unsigned long)ref + old_size);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5394bdb..dc800ee 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3164,8 +3164,8 @@ search_again:
 				}
 				size =
 				    btrfs_file_extent_calc_inline_size(size);
-				ret = btrfs_truncate_item(trans, root, path,
-							  size, 1);
+				btrfs_truncate_item(trans, root, path,
+						    size, 1);
 			} else if (root->ref_cows) {
 				inode_sub_bytes(inode, item_end + 1 -
 						found_key.offset);
@@ -3782,7 +3782,7 @@ static void inode_tree_del(struct inode *inode)
 	}
 }
 
-int btrfs_invalidate_inodes(struct btrfs_root *root)
+void btrfs_invalidate_inodes(struct btrfs_root *root)
 {
 	struct rb_node *node;
 	struct rb_node *prev;
@@ -3842,7 +3842,6 @@ again:
 		node = rb_next(node);
 	}
 	spin_unlock(&root->inode_lock);
-	return 0;
 }
 
 static int btrfs_init_locked_inode(struct inode *inode, void *p)
diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index 5e178d8..272f911 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -208,7 +208,7 @@ void btrfs_tree_read_unlock_blocking(struct extent_buffer *eb)
  * take a spinning write lock.  This will wait for both
  * blocking readers or writers
  */
-int btrfs_tree_lock(struct extent_buffer *eb)
+void btrfs_tree_lock(struct extent_buffer *eb)
 {
 again:
 	wait_event(eb->read_lock_wq, atomic_read(&eb->blocking_readers) == 0);
@@ -230,13 +230,12 @@ again:
 	atomic_inc(&eb->spinning_writers);
 	atomic_inc(&eb->write_locks);
 	eb->lock_owner = current->pid;
-	return 0;
 }
 
 /*
  * drop a spinning or a blocking write lock.
  */
-int btrfs_tree_unlock(struct extent_buffer *eb)
+void btrfs_tree_unlock(struct extent_buffer *eb)
 {
 	int blockers = atomic_read(&eb->blocking_writers);
 
@@ -255,7 +254,6 @@ int btrfs_tree_unlock(struct extent_buffer *eb)
 		atomic_dec(&eb->spinning_writers);
 		write_unlock(&eb->lock);
 	}
-	return 0;
 }
 
 void btrfs_assert_tree_locked(struct extent_buffer *eb)
diff --git a/fs/btrfs/locking.h b/fs/btrfs/locking.h
index 17247dd..ca52681 100644
--- a/fs/btrfs/locking.h
+++ b/fs/btrfs/locking.h
@@ -24,8 +24,8 @@
 #define BTRFS_WRITE_LOCK_BLOCKING 3
 #define BTRFS_READ_LOCK_BLOCKING 4
 
-int btrfs_tree_lock(struct extent_buffer *eb);
-int btrfs_tree_unlock(struct extent_buffer *eb);
+void btrfs_tree_lock(struct extent_buffer *eb);
+void btrfs_tree_unlock(struct extent_buffer *eb);
 int btrfs_try_spin_lock(struct extent_buffer *eb);
 
 void btrfs_tree_read_lock(struct extent_buffer *eb);
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 2857f28..bbf6d0d 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -257,9 +257,9 @@ int btrfs_add_ordered_extent_compress(struct inode *inode, u64 file_offset,
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
 
@@ -267,7 +267,6 @@ int btrfs_add_ordered_sum(struct inode *inode,
 	spin_lock(&tree->lock);
 	list_add_tail(&sum->list, &entry->list);
 	spin_unlock(&tree->lock);
-	return 0;
 }
 
 /*
@@ -392,7 +391,7 @@ out:
  * used to drop a reference on an ordered extent.  This will free
  * the extent if the last reference is dropped
  */
-int btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry)
+void btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry)
 {
 	struct list_head *cur;
 	struct btrfs_ordered_sum *sum;
@@ -408,7 +407,6 @@ int btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry)
 		}
 		kfree(entry);
 	}
-	return 0;
 }
 
 /*
@@ -416,8 +414,8 @@ int btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry)
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
@@ -444,35 +442,30 @@ static int __btrfs_remove_ordered_extent(struct inode *inode,
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
@@ -520,7 +513,6 @@ int btrfs_wait_ordered_extents(struct btrfs_root *root,
 		spin_lock(&root->fs_info->ordered_extent_lock);
 	}
 	spin_unlock(&root->fs_info->ordered_extent_lock);
-	return 0;
 }
 
 /*
@@ -533,7 +525,7 @@ int btrfs_wait_ordered_extents(struct btrfs_root *root,
  * extra check to make sure the ordered operation list really is empty
  * before we return
  */
-int btrfs_run_ordered_operations(struct btrfs_root *root, int wait)
+void btrfs_run_ordered_operations(struct btrfs_root *root, int wait)
 {
 	struct btrfs_inode *btrfs_inode;
 	struct inode *inode;
@@ -581,8 +573,6 @@ again:
 
 	spin_unlock(&root->fs_info->ordered_extent_lock);
 	mutex_unlock(&root->fs_info->ordered_operations_mutex);
-
-	return 0;
 }
 
 /*
@@ -617,7 +607,7 @@ void btrfs_start_ordered_extent(struct inode *inode,
 /*
  * Used to wait on ordered extents across a large range of bytes.
  */
-int btrfs_wait_ordered_range(struct inode *inode, u64 start, u64 len)
+void btrfs_wait_ordered_range(struct inode *inode, u64 start, u64 len)
 {
 	u64 end;
 	u64 orig_end;
@@ -672,7 +662,6 @@ again:
 		schedule_timeout(1);
 		goto again;
 	}
-	return 0;
 }
 
 /*
@@ -956,9 +945,8 @@ out:
  * If trans is not null, we'll do a friendly check for a transaction that
  * is already flushing things and force the IO down ourselves.
  */
-int btrfs_add_ordered_operation(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root,
-				struct inode *inode)
+void btrfs_add_ordered_operation(struct btrfs_trans_handle *trans,
+				 struct btrfs_root *root, struct inode *inode)
 {
 	u64 last_mod;
 
@@ -969,7 +957,7 @@ int btrfs_add_ordered_operation(struct btrfs_trans_handle *trans,
 	 * commit, we can safely return without doing anything
 	 */
 	if (last_mod < root->fs_info->last_trans_committed)
-		return 0;
+		return;
 
 	/*
 	 * the transaction is already committing.  Just start the IO and
@@ -977,7 +965,7 @@ int btrfs_add_ordered_operation(struct btrfs_trans_handle *trans,
 	 */
 	if (trans && root->fs_info->running_transaction->blocked) {
 		btrfs_wait_ordered_range(inode, 0, (u64)-1);
-		return 0;
+		return;
 	}
 
 	spin_lock(&root->fs_info->ordered_extent_lock);
@@ -986,6 +974,4 @@ int btrfs_add_ordered_operation(struct btrfs_trans_handle *trans,
 			      &root->fs_info->ordered_operations);
 	}
 	spin_unlock(&root->fs_info->ordered_extent_lock);
-
-	return 0;
 }
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index ff1f69a..c355ad4 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -138,8 +138,8 @@ btrfs_ordered_inode_tree_init(struct btrfs_ordered_inode_tree *t)
 	t->last = NULL;
 }
 
-int btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry);
-int btrfs_remove_ordered_extent(struct inode *inode,
+void btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry);
+void btrfs_remove_ordered_extent(struct inode *inode,
 				struct btrfs_ordered_extent *entry);
 int btrfs_dec_test_ordered_pending(struct inode *inode,
 				   struct btrfs_ordered_extent **cached,
@@ -154,14 +154,14 @@ int btrfs_add_ordered_extent_dio(struct inode *inode, u64 file_offset,
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
 				struct btrfs_ordered_extent *entry, int wait);
-int btrfs_wait_ordered_range(struct inode *inode, u64 start, u64 len);
+void btrfs_wait_ordered_range(struct inode *inode, u64 start, u64 len);
 struct btrfs_ordered_extent *
 btrfs_lookup_first_ordered_extent(struct inode * inode, u64 file_offset);
 struct btrfs_ordered_extent *btrfs_lookup_ordered_range(struct inode *inode,
@@ -170,10 +170,10 @@ struct btrfs_ordered_extent *btrfs_lookup_ordered_range(struct inode *inode,
 int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
 				struct btrfs_ordered_extent *ordered);
 int btrfs_find_ordered_sum(struct inode *inode, u64 offset, u64 disk_bytenr, u32 *sum);
-int btrfs_run_ordered_operations(struct btrfs_root *root, int wait);
-int btrfs_add_ordered_operation(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root,
-				struct inode *inode);
-int btrfs_wait_ordered_extents(struct btrfs_root *root,
-			       int nocow_only, int delay_iput);
+void btrfs_run_ordered_operations(struct btrfs_root *root, int wait);
+void btrfs_add_ordered_operation(struct btrfs_trans_handle *trans,
+				 struct btrfs_root *root,
+				 struct inode *inode);
+void btrfs_wait_ordered_extents(struct btrfs_root *root,
+				int nocow_only, int delay_iput);
 #endif
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index abc0fbf..a2e8aa4 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -948,12 +948,12 @@ static int scrub_checksum_super(struct scrub_bio *sbio, void *buffer)
 	return fail;
 }
 
-static int scrub_submit(struct scrub_dev *sdev)
+static void scrub_submit(struct scrub_dev *sdev)
 {
 	struct scrub_bio *sbio;
 
 	if (sdev->curr == -1)
-		return 0;
+		return;
 
 	sbio = sdev->bios[sdev->curr];
 	sbio->err = 0;
@@ -961,8 +961,6 @@ static int scrub_submit(struct scrub_dev *sdev)
 	atomic_inc(&sdev->in_flight);
 
 	btrfsic_submit_bio(READ, sbio->bio);
-
-	return 0;
 }
 
 static int scrub_page(struct scrub_dev *sdev, u64 logical, u64 len,
@@ -1008,9 +1006,7 @@ again:
 		sbio->bio = bio;
 	} else if (sbio->physical + sbio->count * PAGE_SIZE != physical ||
 		   sbio->logical + sbio->count * PAGE_SIZE != logical) {
-		ret = scrub_submit(sdev);
-		if (ret)
-			return ret;
+		scrub_submit(sdev);
 		goto again;
 	}
 	sbio->spag[sbio->count].flags = flags;
@@ -1025,9 +1021,7 @@ again:
 	ret = bio_add_page(sbio->bio, page, PAGE_SIZE, 0);
 	if (!ret) {
 		__free_page(page);
-		ret = scrub_submit(sdev);
-		if (ret)
-			return ret;
+		scrub_submit(sdev);
 		goto again;
 	}
 
@@ -1036,13 +1030,8 @@ again:
 		memcpy(sbio->spag[sbio->count].csum, csum, sdev->csum_size);
 	}
 	++sbio->count;
-	if (sbio->count == SCRUB_PAGES_PER_BIO || force) {
-		int ret;
-
-		ret = scrub_submit(sdev);
-		if (ret)
-			return ret;
-	}
+	if (sbio->count == SCRUB_PAGES_PER_BIO || force)
+		scrub_submit(sdev);
 
 	return 0;
 }
@@ -1656,7 +1645,7 @@ int btrfs_scrub_dev(struct btrfs_root *root, u64 devid, u64 start, u64 end,
 	return ret;
 }
 
-int btrfs_scrub_pause(struct btrfs_root *root)
+void btrfs_scrub_pause(struct btrfs_root *root)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 
@@ -1671,29 +1660,24 @@ int btrfs_scrub_pause(struct btrfs_root *root)
 		mutex_lock(&fs_info->scrub_lock);
 	}
 	mutex_unlock(&fs_info->scrub_lock);
-
-	return 0;
 }
 
-int btrfs_scrub_continue(struct btrfs_root *root)
+void btrfs_scrub_continue(struct btrfs_root *root)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 
 	atomic_dec(&fs_info->scrub_pause_req);
 	wake_up(&fs_info->scrub_pause_wait);
-	return 0;
 }
 
-int btrfs_scrub_pause_super(struct btrfs_root *root)
+void btrfs_scrub_pause_super(struct btrfs_root *root)
 {
 	down_write(&root->fs_info->scrub_super_lock);
-	return 0;
 }
 
-int btrfs_scrub_continue_super(struct btrfs_root *root)
+void btrfs_scrub_continue_super(struct btrfs_root *root)
 {
 	up_write(&root->fs_info->scrub_super_lock);
-	return 0;
 }
 
 int btrfs_scrub_cancel(struct btrfs_root *root)
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 9774e38..ae7963b 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1408,9 +1408,7 @@ static int __init init_btrfs_fs(void)
 	if (err)
 		return err;
 
-	err = btrfs_init_compress();
-	if (err)
-		goto free_sysfs;
+	btrfs_init_compress();
 
 	err = btrfs_init_cachep();
 	if (err)
@@ -1451,7 +1449,6 @@ free_cachep:
 	btrfs_destroy_cachep();
 free_compress:
 	btrfs_exit_compress();
-free_sysfs:
 	btrfs_exit_sysfs();
 	return err;
 }
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 04b77e3..6e256d9 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1214,8 +1214,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 
 		if (flush_on_commit || snap_pending) {
 			btrfs_start_delalloc_inodes(root, 1);
-			ret = btrfs_wait_ordered_extents(root, 0, 1);
-			BUG_ON(ret);
+			btrfs_wait_ordered_extents(root, 0, 1);
 		}
 
 		ret = btrfs_run_delayed_items(trans, root);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 966cc74..37b52b8 100644
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
 
 
@@ -378,12 +377,11 @@ insert:
 		u32 found_size;
 		found_size = btrfs_item_size_nr(path->nodes[0],
 						path->slots[0]);
-		if (found_size > item_size) {
+		if (found_size > item_size)
 			btrfs_truncate_item(trans, root, path, item_size, 1);
-		} else if (found_size < item_size) {
-			ret = btrfs_extend_item(trans, root, path,
-						item_size - found_size);
-		}
+		else if (found_size < item_size)
+			btrfs_extend_item(trans, root, path,
+					  item_size - found_size);
 	} else if (ret) {
 		return ret;
 	}
@@ -1963,8 +1961,8 @@ static int wait_log_commit(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-static int wait_for_writer(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root)
+static void wait_for_writer(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root)
 {
 	DEFINE_WAIT(wait);
 	while (root->fs_info->last_trans_log_full_commit !=
@@ -1978,7 +1976,6 @@ static int wait_for_writer(struct btrfs_trans_handle *trans,
 		mutex_lock(&root->log_mutex);
 		finish_wait(&root->log_writer_wait, &wait);
 	}
-	return 0;
 }
 
 /*
diff --git a/fs/btrfs/tree-log.h b/fs/btrfs/tree-log.h
index 2270ac5..862ac81 100644
--- a/fs/btrfs/tree-log.h
+++ b/fs/btrfs/tree-log.h
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
index ef41f28..43778b5 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -67,7 +67,7 @@ static void free_fs_devices(struct btrfs_fs_devices *fs_devices)
 	kfree(fs_devices);
 }
 
-int btrfs_cleanup_fs_uuids(void)
+void btrfs_cleanup_fs_uuids(void)
 {
 	struct btrfs_fs_devices *fs_devices;
 
@@ -77,7 +77,6 @@ int btrfs_cleanup_fs_uuids(void)
 		list_del(&fs_devices->list);
 		free_fs_devices(fs_devices);
 	}
-	return 0;
 }
 
 static noinline struct btrfs_device *__find_device(struct list_head *head,
@@ -130,7 +129,7 @@ static void requeue_list(struct btrfs_pending_bios *pending_bios,
  * the list if the block device is congested.  This way, multiple devices
  * can make progress from a single worker thread.
  */
-static noinline int run_scheduled_bios(struct btrfs_device *device)
+static noinline void run_scheduled_bios(struct btrfs_device *device)
 {
 	struct bio *pending;
 	struct backing_dev_info *bdi;
@@ -316,7 +315,6 @@ loop_lock:
 
 done:
 	blk_finish_plug(&plug);
-	return 0;
 }
 
 static void pending_bios_fn(struct btrfs_work *work)
@@ -455,7 +453,7 @@ error:
 	return ERR_PTR(-ENOMEM);
 }
 
-int btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices)
+void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices)
 {
 	struct btrfs_device *device, *next;
 
@@ -503,7 +501,6 @@ again:
 	fs_devices->latest_trans = latest_transid;
 
 	mutex_unlock(&uuid_mutex);
-	return 0;
 }
 
 static void __free_device(struct work_struct *work)
@@ -3967,7 +3964,7 @@ struct async_sched {
  * This will add one bio to the pending list for a device and make sure
  * the work struct is scheduled.
  */
-static noinline int schedule_bio(struct btrfs_root *root,
+static noinline void schedule_bio(struct btrfs_root *root,
 				 struct btrfs_device *device,
 				 int rw, struct bio *bio)
 {
@@ -3979,7 +3976,7 @@ static noinline int schedule_bio(struct btrfs_root *root,
 		bio_get(bio);
 		btrfsic_submit_bio(rw, bio);
 		bio_put(bio);
-		return 0;
+		return;
 	}
 
 	/*
@@ -4013,7 +4009,6 @@ static noinline int schedule_bio(struct btrfs_root *root,
 	if (should_queue)
 		btrfs_queue_worker(&root->fs_info->submit_workers,
 				   &device->work);
-	return 0;
 }
 
 int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
@@ -4215,7 +4210,7 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 	return 0;
 }
 
-static int fill_device_from_item(struct extent_buffer *leaf,
+static void fill_device_from_item(struct extent_buffer *leaf,
 				 struct btrfs_dev_item *dev_item,
 				 struct btrfs_device *device)
 {
@@ -4232,8 +4227,6 @@ static int fill_device_from_item(struct extent_buffer *leaf,
 
 	ptr = (unsigned long)btrfs_device_uuid(dev_item);
 	read_extent_buffer(leaf, device->uuid, ptr, BTRFS_UUID_SIZE);
-
-	return 0;
 }
 
 static int open_seed_devices(struct btrfs_root *root, u8 *fsid)
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 19ac950..bb6b03f 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -260,12 +260,12 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 			  struct btrfs_fs_devices **fs_devices_ret);
 int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
-int btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices);
+void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices);
 int btrfs_add_device(struct btrfs_trans_handle *trans,
 		     struct btrfs_root *root,
 		     struct btrfs_device *device);
 int btrfs_rm_device(struct btrfs_root *root, char *device_path);
-int btrfs_cleanup_fs_uuids(void);
+void btrfs_cleanup_fs_uuids(void);
 int btrfs_num_copies(struct btrfs_mapping_tree *map_tree, u64 logical, u64 len);
 int btrfs_grow_device(struct btrfs_trans_handle *trans,
 		      struct btrfs_device *device, u64 new_size);
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 84f3001..91b91e8 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -6,6 +6,7 @@
 
 #include <linux/writeback.h>
 #include <linux/tracepoint.h>
+#include <trace/events/gfpflags.h>
 
 struct btrfs_root;
 struct btrfs_fs_info;
@@ -862,6 +863,49 @@ TRACE_EVENT(btrfs_setup_cluster,
 		  __entry->size, __entry->max_size, __entry->bitmap)
 );
 
+struct extent_state;
+TRACE_EVENT(alloc_extent_state,
+
+	TP_PROTO(struct extent_state *state, gfp_t mask, unsigned long IP),
+
+	TP_ARGS(state, mask, IP),
+
+	TP_STRUCT__entry(
+		__field(struct extent_state *, state)
+		__field(gfp_t, mask)
+		__field(unsigned long, ip)
+	),
+
+	TP_fast_assign(
+		__entry->state	= state,
+		__entry->mask	= mask,
+		__entry->ip	= IP
+	),
+
+	TP_printk("state=%p; mask = %s; caller = %pF", __entry->state,
+		  show_gfp_flags(__entry->mask), (void *)__entry->ip)
+);
+
+TRACE_EVENT(free_extent_state,
+
+	TP_PROTO(struct extent_state *state, unsigned long IP),
+
+	TP_ARGS(state, IP),
+
+	TP_STRUCT__entry(
+		__field(struct extent_state *, state)
+		__field(unsigned long, ip)
+	),
+
+	TP_fast_assign(
+		__entry->state	= state,
+		__entry->ip = IP
+	),
+
+	TP_printk(" state=%p; caller = %pF", __entry->state,
+		  (void *)__entry->ip)
+);
+
 #endif /* _TRACE_BTRFS_H */
 
 /* This part must be outside protection */
-- 
1.7.9



