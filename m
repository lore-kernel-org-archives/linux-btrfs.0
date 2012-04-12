From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH 1/5] btrfs: extend readahead interface
Date: Thu, 12 Apr 2012 17:54:38 +0200
Message-ID: <32d2d06e11e45bde2f092d647991b712d2e825b6.1334241664.git.sensille@gmx.net>
References: <cover.1334241664.git.sensille@gmx.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1334241664.git.sensille@gmx.net>
In-Reply-To: <cover.1334241664.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

This extends the readahead interface with callbacks. The old readahead
behaviour is now moved into a callback that is used by default if no
other callback is given. For a detailed description of the callbacks
see the inline comments in reada.c.
It also fixes some cases where the hook has not been called. This is
not a problem with the default callback, as it just cut some branches
from readahead. With the callback mechanism, we want a guaranteed
delivery.
This patch also makes readaheads hierarchical. A readahead can have
sub-readaheads. The idea is that the content of one tree can trigger
readaheads to other trees.
Also added is a function to cancel all outstanding requests for a
given readahead and all its sub-readas.
As the interface changes slightly, scrub has been edited to reflect
the changes.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/ctree.h |   37 ++++-
 fs/btrfs/reada.c |  481 ++++++++++++++++++++++++++++++++++++++++++------------
 fs/btrfs/scrub.c |   29 ++--
 3 files changed, 420 insertions(+), 127 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8e4457e..52b8a91 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3020,6 +3020,13 @@ int btrfs_scrub_progress(struct btrfs_root *root, u64 devid,
 			 struct btrfs_scrub_progress *progress);
 
 /* reada.c */
+#undef READA_DEBUG
+struct reada_extctl;
+struct reada_control;
+typedef void (*reada_cb_t)(struct btrfs_root *root, struct reada_control *rc,
+			   u64 wanted_generation, struct extent_buffer *eb,
+			   u64 start, int err, struct btrfs_key *top,
+			   void *ctx);
 struct reada_control {
 	struct btrfs_root	*root;		/* tree to prefetch */
 	struct btrfs_key	key_start;
@@ -3027,12 +3034,34 @@ struct reada_control {
 	atomic_t		elems;
 	struct kref		refcnt;
 	wait_queue_head_t	wait;
+	struct reada_control	*parent;
+	reada_cb_t		callback;
+#ifdef READA_DEBUG
+	int			not_first;
+#endif
 };
-struct reada_control *btrfs_reada_add(struct btrfs_root *root,
-			      struct btrfs_key *start, struct btrfs_key *end);
-int btrfs_reada_wait(void *handle);
+struct reada_control *btrfs_reada_alloc(struct reada_control *parent,
+			struct btrfs_root *root,
+			struct btrfs_key *key_start, struct btrfs_key *key_end,
+			reada_cb_t callback);
+int btrfs_reada_add(struct reada_control *parent,
+			struct btrfs_root *root,
+			struct btrfs_key *key_start, struct btrfs_key *key_end,
+			reada_cb_t callback, void *ctx,
+			struct reada_control **rcp);
+int btrfs_reada_wait(struct reada_control *handle);
 void btrfs_reada_detach(void *handle);
 int btree_readahead_hook(struct btrfs_root *root, struct extent_buffer *eb,
 			 u64 start, int err);
-
+int reada_add_block(struct reada_control *rc, u64 logical,
+		   struct btrfs_key *top, int level, u64 generation, void *ctx);
+void reada_control_elem_get(struct reada_control *rc);
+void reada_control_elem_put(struct reada_control *rc);
+void reada_start_machine(struct btrfs_fs_info *fs_info);
+int btrfs_reada_abort(struct btrfs_fs_info *fs_info, struct reada_control *rc);
+
+/* droptree.c */
+int btrfs_droptree_pause(struct btrfs_fs_info *fs_info);
+void btrfs_droptree_continue(struct btrfs_fs_info *fs_info);
+void droptree_drop_list(struct btrfs_fs_info *fs_info, struct list_head *list);
 #endif
diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 2373b39..0d88163 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -27,18 +27,18 @@
 #include "volumes.h"
 #include "disk-io.h"
 #include "transaction.h"
-
-#undef DEBUG
+#include "locking.h"
 
 /*
  * This is the implementation for the generic read ahead framework.
  *
  * To trigger a readahead, btrfs_reada_add must be called. It will start
- * a read ahead for the given range [start, end) on tree root. The returned
+ * a readahead for the given range [start, end) on tree root. The returned
  * handle can either be used to wait on the readahead to finish
  * (btrfs_reada_wait), or to send it to the background (btrfs_reada_detach).
+ * If no return pointer is given, the readahead is started in the background.
  *
- * The read ahead works as follows:
+ * The readahead works as follows:
  * On btrfs_reada_add, the root of the tree is inserted into a radix_tree.
  * reada_start_machine will then search for extents to prefetch and trigger
  * some reads. When a read finishes for a node, all contained node/leaf
@@ -52,6 +52,27 @@
  * Any number of readaheads can be started in parallel. The read order will be
  * determined globally, i.e. 2 parallel readaheads will normally finish faster
  * than the 2 started one after another.
+ *
+ * In addition to the default behaviour, a callback can be passed to reada_add.
+ * This callback will be called for each completed read, in an unspecified
+ * order. This callback can then enqueue further reada requests via
+ * reada_add_block or create sub-readaheads with btrfs_reada_add (detached).
+ * The rules for custom callbacks are:
+ *  - The elem count must never go to zero unless the reada is completed. So
+ *    either enqueue further blocks or create sub-readaheads with itself as
+ *    parent. Each sub-readahead will add one to the parent's element count.
+ *    If you need to defer some work, keep the count from dropping to zero
+ *    by calling reada_control_elem_get(). When finished, return it with
+ *    reada_control_elem_put(). This might also free the rc.
+ *  - The extent buffer passed to the callback will be read locked, spinning.
+ *  - The callback is called in the context of the checksum workers
+ *  - The callback is also called if the read failed. This is signaled via
+ *    the err parameter. In this case the eb might be NULL. Make sure to
+ *    properly update your data structures even in error cases to not leave
+ *    refs anywhere.
+ *
+ * If no callback is given, the default callback is used giving the initially
+ * described behaviour.
  */
 
 #define MAX_MIRRORS 2
@@ -60,6 +81,7 @@
 struct reada_extctl {
 	struct list_head	list;
 	struct reada_control	*rc;
+	void			*ctx;
 	u64			generation;
 };
 
@@ -97,30 +119,87 @@ struct reada_machine_work {
 static void reada_extent_put(struct btrfs_fs_info *, struct reada_extent *);
 static void reada_control_release(struct kref *kref);
 static void reada_zone_release(struct kref *kref);
-static void reada_start_machine(struct btrfs_fs_info *fs_info);
 static void __reada_start_machine(struct btrfs_fs_info *fs_info);
 
-static int reada_add_block(struct reada_control *rc, u64 logical,
-			   struct btrfs_key *top, int level, u64 generation);
+/*
+ * this is the default callback for readahead. It just descends into the
+ * tree within the range given at creation. if an error occurs, just cut
+ * this part of the tree
+ */
+static void readahead_descend(struct btrfs_root *root, struct reada_control *rc,
+			      u64 wanted_generation, struct extent_buffer *eb,
+			      u64 start, int err, struct btrfs_key *top,
+			      void *ctx)
+{
+	int nritems;
+	u64 generation;
+	int level;
+	int i;
+
+	BUG_ON(err == -EAGAIN); /* FIXME: not yet implemented, don't cancel
+				 * readahead with default callback */
+
+	if (err || eb == NULL) {
+		/*
+		 * this is the error case, the extent buffer has not been
+		 * read correctly. We won't access anything from it and
+		 * just cleanup our data structures. Effectively this will
+		 * cut the branch below this node from read ahead.
+		 */
+		return;
+	}
+
+	level = btrfs_header_level(eb);
+	if (level == 0) {
+		/*
+		 * if this is a leaf, ignore the content.
+		 */
+		return;
+	}
+
+	nritems = btrfs_header_nritems(eb);
+	generation = btrfs_header_generation(eb);
+
+	/*
+	 * if the generation doesn't match, just ignore this node.
+	 * This will cut off a branch from prefetch. Alternatively one could
+	 * start a new (sub-) prefetch for this branch, starting again from
+	 * root.
+	 */
+	if (wanted_generation != generation)
+		return;
+
+	for (i = 0; i < nritems; i++) {
+		u64 n_gen;
+		struct btrfs_key key;
+		struct btrfs_key next_key;
+		u64 bytenr;
+
+		btrfs_node_key_to_cpu(eb, &key, i);
+		if (i + 1 < nritems)
+			btrfs_node_key_to_cpu(eb, &next_key, i + 1);
+		else
+			next_key = *top;
+		bytenr = btrfs_node_blockptr(eb, i);
+		n_gen = btrfs_node_ptr_generation(eb, i);
+
+		if (btrfs_comp_cpu_keys(&key, &rc->key_end) < 0 &&
+		    btrfs_comp_cpu_keys(&next_key, &rc->key_start) > 0)
+			reada_add_block(rc, bytenr, &next_key,
+					level - 1, n_gen, ctx);
+	}
+}
 
-/* recurses */
 /* in case of err, eb might be NULL */
 static int __readahead_hook(struct btrfs_root *root, struct extent_buffer *eb,
 			    u64 start, int err)
 {
-	int level = 0;
-	int nritems;
-	int i;
-	u64 bytenr;
-	u64 generation;
 	struct reada_extent *re;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct list_head list;
 	unsigned long index = start >> PAGE_CACHE_SHIFT;
 	struct btrfs_device *for_dev;
-
-	if (eb)
-		level = btrfs_header_level(eb);
+	struct reada_extctl *rec;
 
 	/* find extent */
 	spin_lock(&fs_info->reada_lock);
@@ -142,65 +221,21 @@ static int __readahead_hook(struct btrfs_root *root, struct extent_buffer *eb,
 	re->scheduled_for = NULL;
 	spin_unlock(&re->lock);
 
-	if (err == 0) {
-		nritems = level ? btrfs_header_nritems(eb) : 0;
-		generation = btrfs_header_generation(eb);
-		/*
-		 * FIXME: currently we just set nritems to 0 if this is a leaf,
-		 * effectively ignoring the content. In a next step we could
-		 * trigger more readahead depending from the content, e.g.
-		 * fetch the checksums for the extents in the leaf.
-		 */
-	} else {
+	/*
+	 * call hooks for all registered readaheads
+	 */
+	list_for_each_entry(rec, &list, list) {
+		btrfs_tree_read_lock(eb);
 		/*
-		 * this is the error case, the extent buffer has not been
-		 * read correctly. We won't access anything from it and
-		 * just cleanup our data structures. Effectively this will
-		 * cut the branch below this node from read ahead.
+		 * we set the lock to blocking, as the callback might want to
+		 * sleep on allocations.
 		 */
-		nritems = 0;
-		generation = 0;
+		btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
+		rec->rc->callback(root, rec->rc, rec->generation, eb, start,
+				  err, &re->top, rec->ctx);
+		btrfs_tree_read_unlock_blocking(eb);
 	}
 
-	for (i = 0; i < nritems; i++) {
-		struct reada_extctl *rec;
-		u64 n_gen;
-		struct btrfs_key key;
-		struct btrfs_key next_key;
-
-		btrfs_node_key_to_cpu(eb, &key, i);
-		if (i + 1 < nritems)
-			btrfs_node_key_to_cpu(eb, &next_key, i + 1);
-		else
-			next_key = re->top;
-		bytenr = btrfs_node_blockptr(eb, i);
-		n_gen = btrfs_node_ptr_generation(eb, i);
-
-		list_for_each_entry(rec, &list, list) {
-			struct reada_control *rc = rec->rc;
-
-			/*
-			 * if the generation doesn't match, just ignore this
-			 * extctl. This will probably cut off a branch from
-			 * prefetch. Alternatively one could start a new (sub-)
-			 * prefetch for this branch, starting again from root.
-			 * FIXME: move the generation check out of this loop
-			 */
-#ifdef DEBUG
-			if (rec->generation != generation) {
-				printk(KERN_DEBUG "generation mismatch for "
-						"(%llu,%d,%llu) %llu != %llu\n",
-				       key.objectid, key.type, key.offset,
-				       rec->generation, generation);
-			}
-#endif
-			if (rec->generation == generation &&
-			    btrfs_comp_cpu_keys(&key, &rc->key_end) < 0 &&
-			    btrfs_comp_cpu_keys(&next_key, &rc->key_start) > 0)
-				reada_add_block(rc, bytenr, &next_key,
-						level - 1, n_gen);
-		}
-	}
 	/*
 	 * free extctl records
 	 */
@@ -213,12 +248,7 @@ static int __readahead_hook(struct btrfs_root *root, struct extent_buffer *eb,
 		rc = rec->rc;
 		kfree(rec);
 
-		kref_get(&rc->refcnt);
-		if (atomic_dec_and_test(&rc->elems)) {
-			kref_put(&rc->refcnt, reada_control_release);
-			wake_up(&rc->wait);
-		}
-		kref_put(&rc->refcnt, reada_control_release);
+		reada_control_elem_put(rc);
 
 		reada_extent_put(fs_info, re);	/* one ref for each entry */
 	}
@@ -352,7 +382,8 @@ again:
 	blocksize = btrfs_level_size(root, level);
 	re->logical = logical;
 	re->blocksize = blocksize;
-	re->top = *top;
+	if (top)
+		re->top = *top;
 	INIT_LIST_HEAD(&re->extctl);
 	spin_lock_init(&re->lock);
 	kref_init(&re->refcnt);
@@ -503,6 +534,47 @@ static void reada_extent_put(struct btrfs_fs_info *fs_info,
 	kfree(re);
 }
 
+void reada_control_elem_get(struct reada_control *rc)
+{
+#ifndef READA_DEBUG
+	atomic_inc(&rc->elems);
+#else
+	int new = atomic_inc_return(&rc->elems);
+
+	if (rc->not_first && new == 1) {
+		/*
+		 * warn if we try to get an elem although it
+		 * was already down to zero
+		 */
+		WARN_ON(1);
+	}
+	rc->not_first = 1;
+#endif
+}
+
+void reada_control_elem_put(struct reada_control *rc)
+{
+	struct reada_control *next_rc;
+
+	do {
+		next_rc = NULL;
+		kref_get(&rc->refcnt);
+		if (atomic_dec_and_test(&rc->elems)) {
+			/*
+			 * when the last elem is finished, wake all
+			 * waiters. Also, if we have a parent, remove
+			 * our element from there and wake the waiters.
+			 * Walk up the chain of parents as long as
+			 * we finish the last elem. Drop our ref.
+			 */
+			kref_put(&rc->refcnt, reada_control_release);
+			wake_up(&rc->wait);
+			next_rc = rc->parent;
+		}
+		kref_put(&rc->refcnt, reada_control_release);
+	} while ((rc = next_rc));
+}
+
 static void reada_zone_release(struct kref *kref)
 {
 	struct reada_zone *zone = container_of(kref, struct reada_zone, refcnt);
@@ -521,12 +593,87 @@ static void reada_control_release(struct kref *kref)
 	kfree(rc);
 }
 
-static int reada_add_block(struct reada_control *rc, u64 logical,
-			   struct btrfs_key *top, int level, u64 generation)
+/*
+ * context to pass from reada_add_block to worker in case the extent is
+ * already uptodate in memory
+ */
+struct reada_uptodate_ctx {
+	struct btrfs_key	top;
+	struct extent_buffer	*eb;
+	struct reada_control	*rc;
+	u64			logical;
+	u64			generation;
+	void			*ctx;
+	struct btrfs_work	work;
+};
+
+/* worker for immediate processing of uptodate blocks */
+static void reada_add_block_uptodate(struct btrfs_work *work)
+{
+	struct reada_uptodate_ctx *ruc;
+
+	ruc = container_of(work, struct reada_uptodate_ctx, work);
+
+	btrfs_tree_read_lock(ruc->eb);
+	/*
+	 * we set the lock to blocking, as the callback might want to sleep
+	 * on allocations.
+	 */
+	btrfs_set_lock_blocking_rw(ruc->eb, BTRFS_READ_LOCK);
+	ruc->rc->callback(ruc->rc->root, ruc->rc, ruc->generation, ruc->eb,
+			 ruc->logical, 0, &ruc->top, ruc->ctx);
+	btrfs_tree_read_unlock_blocking(ruc->eb);
+
+	reada_control_elem_put(ruc->rc);
+	free_extent_buffer(ruc->eb);
+	kfree(ruc);
+}
+
+int reada_add_block(struct reada_control *rc, u64 logical,
+		    struct btrfs_key *top, int level, u64 generation,
+		    void *ctx)
 {
 	struct btrfs_root *root = rc->root;
 	struct reada_extent *re;
 	struct reada_extctl *rec;
+	struct extent_buffer *eb;
+	struct inode *btree_inode;
+
+	/*
+	 * first check if the buffer is already uptodate in memory. In this
+	 * case it wouldn't make much sense to go through the reada dance.
+	 * Instead process it as soon as possible, but in worker context to
+	 * prevent recursion.
+	 */
+	eb = btrfs_find_tree_block(root, logical,
+				   btrfs_level_size(root, level));
+	btree_inode = eb->first_page->mapping->host;
+
+	if (eb && btrfs_buffer_uptodate(eb, generation)) {
+		struct reada_uptodate_ctx *ruc;
+
+		ruc = kzalloc(sizeof(*ruc), GFP_NOFS);
+		if (!ruc) {
+			free_extent_buffer(eb);
+			return -1;
+		}
+		ruc->rc = rc;
+		ruc->ctx = ctx;
+		ruc->generation = generation;
+		ruc->logical = logical;
+		ruc->eb = eb;
+		if (top)
+			ruc->top = *top;
+		ruc->work.func = reada_add_block_uptodate;
+		reada_control_elem_get(rc);
+
+		btrfs_queue_worker(&root->fs_info->readahead_workers,
+				   &ruc->work);
+
+		return 0;
+	}
+	if (eb)
+		free_extent_buffer(eb);
 
 	re = reada_find_extent(root, logical, top, level); /* takes one ref */
 	if (!re)
@@ -539,14 +686,17 @@ static int reada_add_block(struct reada_control *rc, u64 logical,
 	}
 
 	rec->rc = rc;
+	rec->ctx = ctx;
 	rec->generation = generation;
-	atomic_inc(&rc->elems);
+	reada_control_elem_get(rc);
 
 	spin_lock(&re->lock);
 	list_add_tail(&rec->list, &re->extctl);
 	spin_unlock(&re->lock);
 
-	/* leave the ref on the extent */
+	reada_start_machine(root->fs_info);
+
+	/* leave the ref on re */
 
 	return 0;
 }
@@ -750,10 +900,14 @@ static void __reada_start_machine(struct btrfs_fs_info *fs_info)
 		reada_start_machine(fs_info);
 }
 
-static void reada_start_machine(struct btrfs_fs_info *fs_info)
+void reada_start_machine(struct btrfs_fs_info *fs_info)
 {
 	struct reada_machine_work *rmw;
 
+	/*
+	 * FIXME if there are still requests in flight, we don't need to
+	 * kick a worker. Add a check to prevent unnecessary work
+	 */
 	rmw = kzalloc(sizeof(*rmw), GFP_NOFS);
 	if (!rmw) {
 		/* FIXME we cannot handle this properly right now */
@@ -765,7 +919,7 @@ static void reada_start_machine(struct btrfs_fs_info *fs_info)
 	btrfs_queue_worker(&fs_info->readahead_workers, &rmw->work);
 }
 
-#ifdef DEBUG
+#ifdef READA_DEBUG
 static void dump_devs(struct btrfs_fs_info *fs_info, int all)
 {
 	struct btrfs_device *device;
@@ -870,15 +1024,49 @@ static void dump_devs(struct btrfs_fs_info *fs_info, int all)
 #endif
 
 /*
- * interface
+ * if parent is given, the caller has to hold a ref on parent
  */
-struct reada_control *btrfs_reada_add(struct btrfs_root *root,
-			struct btrfs_key *key_start, struct btrfs_key *key_end)
+struct reada_control *btrfs_reada_alloc(struct reada_control *parent,
+			struct btrfs_root *root,
+			struct btrfs_key *key_start, struct btrfs_key *key_end,
+			reada_cb_t callback)
+{
+	struct reada_control *rc;
+
+	rc = kzalloc(sizeof(*rc), GFP_NOFS);
+	if (!rc)
+		return ERR_PTR(-ENOMEM);
+
+	rc->root = root;
+	rc->parent = parent;
+	rc->callback = callback ? callback : readahead_descend;
+	if (key_start)
+		rc->key_start = *key_start;
+	if (key_end)
+		rc->key_end = *key_end;
+	atomic_set(&rc->elems, 0);
+	init_waitqueue_head(&rc->wait);
+	kref_init(&rc->refcnt);
+	if (parent) {
+		/*
+		 * we just add one element to the parent as long as we're
+		 * not finished
+		 */
+		reada_control_elem_get(parent);
+	}
+
+	return rc;
+}
+
+int btrfs_reada_add(struct reada_control *parent, struct btrfs_root *root,
+		    struct btrfs_key *key_start, struct btrfs_key *key_end,
+		    reada_cb_t callback, void *ctx, struct reada_control **rcp)
 {
 	struct reada_control *rc;
 	u64 start;
 	u64 generation;
 	int level;
+	int ret;
 	struct extent_buffer *node;
 	static struct btrfs_key max_key = {
 		.objectid = (u64)-1,
@@ -886,17 +1074,18 @@ struct reada_control *btrfs_reada_add(struct btrfs_root *root,
 		.offset = (u64)-1
 	};
 
-	rc = kzalloc(sizeof(*rc), GFP_NOFS);
+	rc = btrfs_reada_alloc(parent, root, key_start, key_end, callback);
 	if (!rc)
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 
-	rc->root = root;
-	rc->key_start = *key_start;
-	rc->key_end = *key_end;
-	atomic_set(&rc->elems, 0);
-	init_waitqueue_head(&rc->wait);
-	kref_init(&rc->refcnt);
-	kref_get(&rc->refcnt); /* one ref for having elements */
+	if (rcp) {
+		*rcp = rc;
+		/*
+		 * as we return the rc, get an addition ref on it for
+		 * the caller
+		 */
+		kref_get(&rc->refcnt);
+	}
 
 	node = btrfs_root_node(root);
 	start = node->start;
@@ -904,35 +1093,36 @@ struct reada_control *btrfs_reada_add(struct btrfs_root *root,
 	generation = btrfs_header_generation(node);
 	free_extent_buffer(node);
 
-	reada_add_block(rc, start, &max_key, level, generation);
+	ret = reada_add_block(rc, start, &max_key, level, generation, ctx);
 
 	reada_start_machine(root->fs_info);
 
-	return rc;
+	return ret;
 }
 
-#ifdef DEBUG
-int btrfs_reada_wait(void *handle)
+#ifdef READA_DEBUG
+int btrfs_reada_wait(struct reada_control *rc)
 {
-	struct reada_control *rc = handle;
+	struct btrfs_fs_info *fs_info = rc->root->fs_info;
+	int i;
 
 	while (atomic_read(&rc->elems)) {
 		wait_event_timeout(rc->wait, atomic_read(&rc->elems) == 0,
-				   5 * HZ);
-		dump_devs(rc->root->fs_info, rc->elems < 10 ? 1 : 0);
+				   1 * HZ);
+		dump_devs(fs_info, atomic_read(&rc->elems) < 10 ? 1 : 0);
+		printk(KERN_DEBUG "reada_wait on %p: %d elems\n", rc,
+			atomic_read(&rc->elems));
 	}
 
-	dump_devs(rc->root->fs_info, rc->elems < 10 ? 1 : 0);
+	dump_devs(fs_info, atomic_read(&rc->elems) < 10 ? 1 : 0);
 
 	kref_put(&rc->refcnt, reada_control_release);
 
 	return 0;
 }
 #else
-int btrfs_reada_wait(void *handle)
+int btrfs_reada_wait(struct reada_control *rc)
 {
-	struct reada_control *rc = handle;
-
 	while (atomic_read(&rc->elems)) {
 		wait_event(rc->wait, atomic_read(&rc->elems) == 0);
 	}
@@ -949,3 +1139,80 @@ void btrfs_reada_detach(void *handle)
 
 	kref_put(&rc->refcnt, reada_control_release);
 }
+
+/*
+ * abort all readahead for a specific reada_control
+ * this function does not wait for outstanding requests to finish, so
+ * when it returns, the abort is not fully complete. This function will
+ * cancel all currently enqueued readaheads for the given rc and all children
+ * of it.
+ */
+int btrfs_reada_abort(struct btrfs_fs_info *fs_info, struct reada_control *rc)
+{
+	struct reada_extent *re = NULL;
+	struct list_head list;
+	int ret;
+	u64 logical = 0;
+	struct reada_extctl *rec;
+	struct reada_extctl *tmp;
+
+	INIT_LIST_HEAD(&list);
+
+	while (1) {
+		spin_lock(&fs_info->reada_lock);
+		ret = radix_tree_gang_lookup(&fs_info->reada_tree, (void **)&re,
+					     logical >> PAGE_CACHE_SHIFT, 1);
+		if (ret == 1)
+			kref_get(&re->refcnt);
+		spin_unlock(&fs_info->reada_lock);
+
+		if (ret != 1)
+			break;
+
+		/*
+		 * take out all extctls that should get deleted into another
+		 * list
+		 */
+		spin_lock(&re->lock);
+		if (re->scheduled_for) {
+			spin_unlock(&re->lock);
+			goto next;
+		}
+
+		list_for_each_entry_safe(rec, tmp, &re->extctl, list) {
+			struct reada_control *it;
+
+			for (it = rec->rc; it; it = it->parent) {
+				if (it == rc) {
+					list_move(&rec->list, &list);
+					break;
+				}
+			}
+		}
+		spin_unlock(&re->lock);
+
+		/*
+		 * now cancel all extctls in the list
+		 */
+		while (!list_empty(&list)) {
+			struct reada_control *tmp_rc;
+
+			rec = list_first_entry(&list, struct reada_extctl,
+					       list);
+			rec->rc->callback(rec->rc->root, rec->rc, 0, NULL,
+					  re->logical,
+					  -EAGAIN, &re->top, rec->ctx);
+			list_del(&rec->list);
+			tmp_rc = rec->rc;
+			kfree(rec);
+
+			reada_control_elem_put(tmp_rc);
+			reada_extent_put(fs_info, re);
+		}
+next:
+		logical = re->logical + PAGE_CACHE_SIZE;
+		reada_extent_put(fs_info, re);	/* our ref */
+	}
+
+	return 1;
+}
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index abc0fbf..80140a8 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1136,7 +1136,6 @@ static noinline_for_stack int scrub_stripe(struct scrub_dev *sdev,
 	u64 generation;
 	int mirror_num;
 	struct reada_control *reada1;
-	struct reada_control *reada2;
 	struct btrfs_key key_start;
 	struct btrfs_key key_end;
 
@@ -1189,23 +1188,21 @@ static noinline_for_stack int scrub_stripe(struct scrub_dev *sdev,
 	key_start.objectid = logical;
 	key_start.type = BTRFS_EXTENT_ITEM_KEY;
 	key_start.offset = (u64)0;
+	key_end = key_start;
 	key_end.objectid = base + offset + nstripes * increment;
-	key_end.type = BTRFS_EXTENT_ITEM_KEY;
-	key_end.offset = (u64)0;
-	reada1 = btrfs_reada_add(root, &key_start, &key_end);
-
-	key_start.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
-	key_start.type = BTRFS_EXTENT_CSUM_KEY;
-	key_start.offset = logical;
-	key_end.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
-	key_end.type = BTRFS_EXTENT_CSUM_KEY;
-	key_end.offset = base + offset + nstripes * increment;
-	reada2 = btrfs_reada_add(csum_root, &key_start, &key_end);
-
-	if (!IS_ERR(reada1))
+	ret = btrfs_reada_add(NULL, root, &key_start, &key_end,
+			      NULL, NULL, &reada1);
+	/* if readahead fails, we just go ahead without it */
+	if (ret == 0) {
+		key_start.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
+		key_start.type = BTRFS_EXTENT_CSUM_KEY;
+		key_start.offset = logical;
+		key_end = key_start;
+		key_end.offset = base + offset + nstripes * increment;
+		ret = btrfs_reada_add(reada1, csum_root, &key_start,
+				      &key_end, NULL, NULL, NULL);
 		btrfs_reada_wait(reada1);
-	if (!IS_ERR(reada2))
-		btrfs_reada_wait(reada2);
+	}
 
 	mutex_lock(&fs_info->scrub_lock);
 	while (atomic_read(&fs_info->scrub_pause_req)) {
-- 
1.7.3.4

