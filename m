From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Updated performance results
Date: Thu, 17 Sep 2009 16:17:14 -0400
Message-ID: <20090917201714.GE18165@think>
References: <20090807231240.GD3710@think>
 <4A9C0D19.5010108@austin.ibm.com>
 <20090911192955.GB2894@think>
 <4AAAC2B6.8040105@austin.ibm.com>
 <20090914135130.GE8839@think>
 <4AAEB89C.3040100@austin.ibm.com>
 <20090916005225.GG23965@think>
 <4AB280AD.5080306@hp.com>
 <4AB28245.2000704@austin.ibm.com>
 <20090917185220.GA18165@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Steven Pratt <slpratt@austin.ibm.com>,
	Eric Whitney <eric.whitney@hp.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090917185220.GA18165@think>
List-ID: <linux-btrfs.vger.kernel.org>

[ crashes on runs involving unmounts ]

The run is still going here, but it has survived longer than before.
I'm trying with Yan Zheng's patch:

From: Yan Zheng <zheng.yan@oracle.com>
Date: Fri, 11 Sep 2009 16:11:19 -0400
Subject: [PATCH] Btrfs: improve async block group caching

This patch gets rid of two limitations of async block group caching.
The old code delays handling pinned extents when block group is in
caching. To allocate logged file extents, the old code need wait
until block group is fully cached. To get rid of the limitations,
This patch introduces a data structure to track the progress of
caching. Base on the caching progress, we know which extents should
be added to the free space cache when handling the pinned extents.
The logged file extents are also handled in a similar way.

This patch also changes how pinned extents are tracked. The old
code uses one tree to track pinned extents, and copy the pinned
extents tree at transaction commit time. This patch makes it use
two trees to track pinned extents. One tree for extents that are
pinned in the running transaction, one tree for extents that can
be unpinned. At transaction commit time, we swap the two trees.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>
Signed-off-by: Chris Mason <chris.mason@oracle.com>
---
 fs/btrfs/ctree.h       |   29 ++-
 fs/btrfs/disk-io.c     |    7 +-
 fs/btrfs/extent-tree.c |  586 +++++++++++++++++++++++++++++-------------------
 fs/btrfs/transaction.c |   15 +-
 fs/btrfs/tree-log.c    |    4 +-
 5 files changed, 382 insertions(+), 259 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 732d5b8..3b6df71 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -726,6 +726,15 @@ enum btrfs_caching_type {
 	BTRFS_CACHE_FINISHED	= 2,
 };
 
+struct btrfs_caching_control {
+	struct list_head list;
+	struct mutex mutex;
+	wait_queue_head_t wait;
+	struct btrfs_block_group_cache *block_group;
+	u64 progress;
+	atomic_t count;
+};
+
 struct btrfs_block_group_cache {
 	struct btrfs_key key;
 	struct btrfs_block_group_item item;
@@ -742,8 +751,9 @@ struct btrfs_block_group_cache {
 	int dirty;
 
 	/* cache tracking stuff */
-	wait_queue_head_t caching_q;
 	int cached;
+	struct btrfs_caching_control *caching_ctl;
+	u64 last_byte_to_unpin;
 
 	struct btrfs_space_info *space_info;
 
@@ -788,7 +798,8 @@ struct btrfs_fs_info {
 	spinlock_t block_group_cache_lock;
 	struct rb_root block_group_cache_tree;
 
-	struct extent_io_tree pinned_extents;
+	struct extent_io_tree freed_extents[2];
+	struct extent_io_tree *pinned_extents;
 
 	/* logical->physical extent mapping */
 	struct btrfs_mapping_tree mapping_tree;
@@ -825,8 +836,6 @@ struct btrfs_fs_info {
 	struct mutex drop_mutex;
 	struct mutex volume_mutex;
 	struct mutex tree_reloc_mutex;
-	struct rw_semaphore extent_commit_sem;
-
 	/*
 	 * this protects the ordered operations list only while we are
 	 * processing all of the entries on it.  This way we make
@@ -835,10 +844,12 @@ struct btrfs_fs_info {
 	 * before jumping into the main commit.
 	 */
 	struct mutex ordered_operations_mutex;
+	struct rw_semaphore extent_commit_sem;
 
 	struct list_head trans_list;
 	struct list_head hashers;
 	struct list_head dead_roots;
+	struct list_head caching_block_groups;
 
 	atomic_t nr_async_submits;
 	atomic_t async_submit_draining;
@@ -1920,8 +1931,8 @@ void btrfs_put_block_group(struct btrfs_block_group_cache *cache);
 int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, unsigned long count);
 int btrfs_lookup_extent(struct btrfs_root *root, u64 start, u64 len);
-int btrfs_update_pinned_extents(struct btrfs_root *root,
-				u64 bytenr, u64 num, int pin);
+int btrfs_pin_extent(struct btrfs_root *root,
+		     u64 bytenr, u64 num, int reserved);
 int btrfs_drop_leaf_ref(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root, struct extent_buffer *leaf);
 int btrfs_cross_ref_exist(struct btrfs_trans_handle *trans,
@@ -1971,9 +1982,10 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 		      u64 root_objectid, u64 owner, u64 offset);
 
 int btrfs_free_reserved_extent(struct btrfs_root *root, u64 start, u64 len);
+int btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root);
 int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
-			       struct btrfs_root *root,
-			       struct extent_io_tree *unpin);
+			       struct btrfs_root *root);
 int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root,
 			 u64 bytenr, u64 num_bytes, u64 parent,
@@ -2006,7 +2018,6 @@ void btrfs_delalloc_reserve_space(struct btrfs_root *root, struct inode *inode,
 				 u64 bytes);
 void btrfs_delalloc_free_space(struct btrfs_root *root, struct inode *inode,
 			      u64 bytes);
-void btrfs_free_pinned_extents(struct btrfs_fs_info *info);
 /* ctree.c */
 int btrfs_bin_search(struct extent_buffer *eb, struct btrfs_key *key,
 		     int level, int *slot);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 253da7e..16dae12 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1563,6 +1563,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	INIT_LIST_HEAD(&fs_info->hashers);
 	INIT_LIST_HEAD(&fs_info->delalloc_inodes);
 	INIT_LIST_HEAD(&fs_info->ordered_operations);
+	INIT_LIST_HEAD(&fs_info->caching_block_groups);
 	spin_lock_init(&fs_info->delalloc_lock);
 	spin_lock_init(&fs_info->new_trans_lock);
 	spin_lock_init(&fs_info->ref_cache_lock);
@@ -1621,8 +1622,11 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	spin_lock_init(&fs_info->block_group_cache_lock);
 	fs_info->block_group_cache_tree.rb_node = NULL;
 
-	extent_io_tree_init(&fs_info->pinned_extents,
+	extent_io_tree_init(&fs_info->freed_extents[0],
 			     fs_info->btree_inode->i_mapping, GFP_NOFS);
+	extent_io_tree_init(&fs_info->freed_extents[1],
+			     fs_info->btree_inode->i_mapping, GFP_NOFS);
+	fs_info->pinned_extents = &fs_info->freed_extents[0];
 	fs_info->do_barriers = 1;
 
 	BTRFS_I(fs_info->btree_inode)->root = tree_root;
@@ -2359,7 +2363,6 @@ int close_ctree(struct btrfs_root *root)
 	free_extent_buffer(root->fs_info->csum_root->commit_root);
 
 	btrfs_free_block_groups(root->fs_info);
-	btrfs_free_pinned_extents(root->fs_info);
 
 	del_fs_roots(fs_info);
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index edd86ae..9bcb9c0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -32,12 +32,12 @@
 #include "locking.h"
 #include "free-space-cache.h"
 
-static int update_reserved_extents(struct btrfs_root *root,
-				   u64 bytenr, u64 num, int reserve);
 static int update_block_group(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root,
 			      u64 bytenr, u64 num_bytes, int alloc,
 			      int mark_free);
+static int update_reserved_extents(struct btrfs_block_group_cache *cache,
+				   u64 num_bytes, int reserve);
 static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
 				u64 bytenr, u64 num_bytes, u64 parent,
@@ -57,10 +57,17 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 				     u64 parent, u64 root_objectid,
 				     u64 flags, struct btrfs_disk_key *key,
 				     int level, struct btrfs_key *ins);
-
 static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *extent_root, u64 alloc_bytes,
 			  u64 flags, int force);
+static int pin_down_bytes(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *root,
+			  struct btrfs_path *path,
+			  u64 bytenr, u64 num_bytes,
+			  int is_data, int reserved,
+			  struct extent_buffer **must_clean);
+static int find_next_key(struct btrfs_path *path, int level,
+			 struct btrfs_key *key);
 
 static noinline int
 block_group_cache_done(struct btrfs_block_group_cache *cache)
@@ -153,34 +160,34 @@ block_group_cache_tree_search(struct btrfs_fs_info *info, u64 bytenr,
 	return ret;
 }
 
-/*
- * We always set EXTENT_LOCKED for the super mirror extents so we don't
- * overwrite them, so those bits need to be unset.  Also, if we are unmounting
- * with pinned extents still sitting there because we had a block group caching,
- * we need to clear those now, since we are done.
- */
-void btrfs_free_pinned_extents(struct btrfs_fs_info *info)
+static int add_excluded_extent(struct btrfs_root *root,
+			       u64 start, u64 num_bytes)
 {
-	u64 start, end, last = 0;
-	int ret;
+	u64 end = start + num_bytes - 1;
+	set_extent_bits(&root->fs_info->freed_extents[0],
+			start, end, EXTENT_UPTODATE, GFP_NOFS);
+	set_extent_bits(&root->fs_info->freed_extents[1],
+			start, end, EXTENT_UPTODATE, GFP_NOFS);
+	return 0;
+}
 
-	while (1) {
-		ret = find_first_extent_bit(&info->pinned_extents, last,
-					    &start, &end,
-					    EXTENT_LOCKED|EXTENT_DIRTY);
-		if (ret)
-			break;
+static void free_excluded_extents(struct btrfs_root *root,
+				  struct btrfs_block_group_cache *cache)
+{
+	u64 start, end;
 
-		clear_extent_bits(&info->pinned_extents, start, end,
-				  EXTENT_LOCKED|EXTENT_DIRTY, GFP_NOFS);
-		last = end+1;
-	}
+	start = cache->key.objectid;
+	end = start + cache->key.offset - 1;
+
+	clear_extent_bits(&root->fs_info->freed_extents[0],
+			  start, end, EXTENT_UPTODATE, GFP_NOFS);
+	clear_extent_bits(&root->fs_info->freed_extents[1],
+			  start, end, EXTENT_UPTODATE, GFP_NOFS);
 }
 
-static int remove_sb_from_cache(struct btrfs_root *root,
-				struct btrfs_block_group_cache *cache)
+static int exclude_super_stripes(struct btrfs_root *root,
+				 struct btrfs_block_group_cache *cache)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 bytenr;
 	u64 *logical;
 	int stripe_len;
@@ -192,17 +199,41 @@ static int remove_sb_from_cache(struct btrfs_root *root,
 				       cache->key.objectid, bytenr,
 				       0, &logical, &nr, &stripe_len);
 		BUG_ON(ret);
+
 		while (nr--) {
-			try_lock_extent(&fs_info->pinned_extents,
-					logical[nr],
-					logical[nr] + stripe_len - 1, GFP_NOFS);
+			ret = add_excluded_extent(root, logical[nr],
+						  stripe_len);
+			BUG_ON(ret);
 		}
+
 		kfree(logical);
 	}
-
 	return 0;
 }
 
+static struct btrfs_caching_control *
+get_caching_control(struct btrfs_block_group_cache *cache)
+{
+	struct btrfs_caching_control *ctl;
+
+	spin_lock(&cache->lock);
+	if (cache->cached != BTRFS_CACHE_STARTED) {
+		spin_unlock(&cache->lock);
+		return NULL;
+	}
+
+	ctl = cache->caching_ctl;
+	atomic_inc(&ctl->count);
+	spin_unlock(&cache->lock);
+	return ctl;
+}
+
+static void put_caching_control(struct btrfs_caching_control *ctl)
+{
+	if (atomic_dec_and_test(&ctl->count))
+		kfree(ctl);
+}
+
 /*
  * this is only called by cache_block_group, since we could have freed extents
  * we need to check the pinned_extents for any extents that can't be used yet
@@ -215,9 +246,9 @@ static u64 add_new_free_space(struct btrfs_block_group_cache *block_group,
 	int ret;
 
 	while (start < end) {
-		ret = find_first_extent_bit(&info->pinned_extents, start,
+		ret = find_first_extent_bit(info->pinned_extents, start,
 					    &extent_start, &extent_end,
-					    EXTENT_DIRTY|EXTENT_LOCKED);
+					    EXTENT_DIRTY | EXTENT_UPTODATE);
 		if (ret)
 			break;
 
@@ -249,22 +280,24 @@ static int caching_kthread(void *data)
 {
 	struct btrfs_block_group_cache *block_group = data;
 	struct btrfs_fs_info *fs_info = block_group->fs_info;
-	u64 last = 0;
+	struct btrfs_caching_control *caching_ctl = block_group->caching_ctl;
+	struct btrfs_root *extent_root = fs_info->extent_root;
 	struct btrfs_path *path;
-	int ret = 0;
-	struct btrfs_key key;
 	struct extent_buffer *leaf;
-	int slot;
+	struct btrfs_key key;
 	u64 total_found = 0;
-
-	BUG_ON(!fs_info);
+	u64 last = 0;
+	u32 nritems;
+	int ret = 0;
 
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
 
-	atomic_inc(&block_group->space_info->caching_threads);
+	exclude_super_stripes(extent_root, block_group);
+
 	last = max_t(u64, block_group->key.objectid, BTRFS_SUPER_INFO_OFFSET);
+
 	/*
 	 * We don't want to deadlock with somebody trying to allocate a new
 	 * extent for the extent root while also trying to search the extent
@@ -277,74 +310,64 @@ static int caching_kthread(void *data)
 
 	key.objectid = last;
 	key.offset = 0;
-	btrfs_set_key_type(&key, BTRFS_EXTENT_ITEM_KEY);
+	key.type = BTRFS_EXTENT_ITEM_KEY;
 again:
+	mutex_lock(&caching_ctl->mutex);
 	/* need to make sure the commit_root doesn't disappear */
 	down_read(&fs_info->extent_commit_sem);
 
-	ret = btrfs_search_slot(NULL, fs_info->extent_root, &key, path, 0, 0);
+	ret = btrfs_search_slot(NULL, extent_root, &key, path, 0, 0);
 	if (ret < 0)
 		goto err;
 
+	leaf = path->nodes[0];
+	nritems = btrfs_header_nritems(leaf);
+
 	while (1) {
 		smp_mb();
-		if (block_group->fs_info->closing > 1) {
+		if (fs_info->closing > 1) {
 			last = (u64)-1;
 			break;
 		}
 
-		leaf = path->nodes[0];
-		slot = path->slots[0];
-		if (slot >= btrfs_header_nritems(leaf)) {
-			ret = btrfs_next_leaf(fs_info->extent_root, path);
-			if (ret < 0)
-				goto err;
-			else if (ret)
+		if (path->slots[0] < nritems) {
+			btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+		} else {
+			ret = find_next_key(path, 0, &key);
+			if (ret)
 				break;
 
-			if (need_resched() ||
-			    btrfs_transaction_in_commit(fs_info)) {
-				leaf = path->nodes[0];
-
-				/* this shouldn't happen, but if the
-				 * leaf is empty just move on.
-				 */
-				if (btrfs_header_nritems(leaf) == 0)
-					break;
-				/*
-				 * we need to copy the key out so that
-				 * we are sure the next search advances
-				 * us forward in the btree.
-				 */
-				btrfs_item_key_to_cpu(leaf, &key, 0);
-				btrfs_release_path(fs_info->extent_root, path);
-				up_read(&fs_info->extent_commit_sem);
+			caching_ctl->progress = last;
+			btrfs_release_path(extent_root, path);
+			up_read(&fs_info->extent_commit_sem);
+			mutex_unlock(&caching_ctl->mutex);
+			if (btrfs_transaction_in_commit(fs_info))
 				schedule_timeout(1);
-				goto again;
-			}
+			else
+				cond_resched();
+			goto again;
+		}
 
+		if (key.objectid < block_group->key.objectid) {
+			path->slots[0]++;
 			continue;
 		}
-		btrfs_item_key_to_cpu(leaf, &key, slot);
-		if (key.objectid < block_group->key.objectid)
-			goto next;
 
 		if (key.objectid >= block_group->key.objectid +
 		    block_group->key.offset)
 			break;
 
-		if (btrfs_key_type(&key) == BTRFS_EXTENT_ITEM_KEY) {
+		if (key.type == BTRFS_EXTENT_ITEM_KEY) {
 			total_found += add_new_free_space(block_group,
 							  fs_info, last,
 							  key.objectid);
 			last = key.objectid + key.offset;
-		}
 
-		if (total_found > (1024 * 1024 * 2)) {
-			total_found = 0;
-			wake_up(&block_group->caching_q);
+			if (total_found > (1024 * 1024 * 2)) {
+				total_found = 0;
+				wake_up(&caching_ctl->wait);
+			}
 		}
-next:
 		path->slots[0]++;
 	}
 	ret = 0;
@@ -352,33 +375,65 @@ next:
 	total_found += add_new_free_space(block_group, fs_info, last,
 					  block_group->key.objectid +
 					  block_group->key.offset);
+	caching_ctl->progress = (u64)-1;
 
 	spin_lock(&block_group->lock);
+	block_group->caching_ctl = NULL;
 	block_group->cached = BTRFS_CACHE_FINISHED;
 	spin_unlock(&block_group->lock);
 
 err:
 	btrfs_free_path(path);
 	up_read(&fs_info->extent_commit_sem);
-	atomic_dec(&block_group->space_info->caching_threads);
-	wake_up(&block_group->caching_q);
 
+	free_excluded_extents(extent_root, block_group);
+
+	mutex_unlock(&caching_ctl->mutex);
+	wake_up(&caching_ctl->wait);
+
+	put_caching_control(caching_ctl);
+	atomic_dec(&block_group->space_info->caching_threads);
 	return 0;
 }
 
 static int cache_block_group(struct btrfs_block_group_cache *cache)
 {
+	struct btrfs_fs_info *fs_info = cache->fs_info;
+	struct btrfs_caching_control *caching_ctl;
 	struct task_struct *tsk;
 	int ret = 0;
 
+	smp_mb();
+	if (cache->cached != BTRFS_CACHE_NO)
+		return 0;
+
+	caching_ctl = kzalloc(sizeof(*caching_ctl), GFP_KERNEL);
+	BUG_ON(!caching_ctl);
+
+	INIT_LIST_HEAD(&caching_ctl->list);
+	mutex_init(&caching_ctl->mutex);
+	init_waitqueue_head(&caching_ctl->wait);
+	caching_ctl->block_group = cache;
+	caching_ctl->progress = cache->key.objectid;
+	/* one for caching kthread, one for caching block group list */
+	atomic_set(&caching_ctl->count, 2);
+
 	spin_lock(&cache->lock);
 	if (cache->cached != BTRFS_CACHE_NO) {
 		spin_unlock(&cache->lock);
-		return ret;
+		kfree(caching_ctl);
+		return 0;
 	}
+	cache->caching_ctl = caching_ctl;
 	cache->cached = BTRFS_CACHE_STARTED;
 	spin_unlock(&cache->lock);
 
+	down_write(&fs_info->extent_commit_sem);
+	list_add_tail(&caching_ctl->list, &fs_info->caching_block_groups);
+	up_write(&fs_info->extent_commit_sem);
+
+	atomic_inc(&cache->space_info->caching_threads);
+
 	tsk = kthread_run(caching_kthread, cache, "btrfs-cache-%llu\n",
 			  cache->key.objectid);
 	if (IS_ERR(tsk)) {
@@ -1656,7 +1711,6 @@ static int run_delayed_data_ref(struct btrfs_trans_handle *trans,
 						 parent, ref_root, flags,
 						 ref->objectid, ref->offset,
 						 &ins, node->ref_mod);
-		update_reserved_extents(root, ins.objectid, ins.offset, 0);
 	} else if (node->action == BTRFS_ADD_DELAYED_REF) {
 		ret = __btrfs_inc_extent_ref(trans, root, node->bytenr,
 					     node->num_bytes, parent,
@@ -1782,7 +1836,6 @@ static int run_delayed_tree_ref(struct btrfs_trans_handle *trans,
 						extent_op->flags_to_set,
 						&extent_op->key,
 						ref->level, &ins);
-		update_reserved_extents(root, ins.objectid, ins.offset, 0);
 	} else if (node->action == BTRFS_ADD_DELAYED_REF) {
 		ret = __btrfs_inc_extent_ref(trans, root, node->bytenr,
 					     node->num_bytes, parent, ref_root,
@@ -1817,16 +1870,32 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 		BUG_ON(extent_op);
 		head = btrfs_delayed_node_to_head(node);
 		if (insert_reserved) {
+			int mark_free = 0;
+			struct extent_buffer *must_clean = NULL;
+
+			ret = pin_down_bytes(trans, root, NULL,
+					     node->bytenr, node->num_bytes,
+					     head->is_data, 1, &must_clean);
+			if (ret > 0)
+				mark_free = 1;
+
+			if (must_clean) {
+				clean_tree_block(NULL, root, must_clean);
+				btrfs_tree_unlock(must_clean);
+				free_extent_buffer(must_clean);
+			}
 			if (head->is_data) {
 				ret = btrfs_del_csums(trans, root,
 						      node->bytenr,
 						      node->num_bytes);
 				BUG_ON(ret);
 			}
-			btrfs_update_pinned_extents(root, node->bytenr,
-						    node->num_bytes, 1);
-			update_reserved_extents(root, node->bytenr,
-						node->num_bytes, 0);
+			if (mark_free) {
+				ret = btrfs_free_reserved_extent(root,
+							node->bytenr,
+							node->num_bytes);
+				BUG_ON(ret);
+			}
 		}
 		mutex_unlock(&head->mutex);
 		return 0;
@@ -3008,10 +3077,12 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 		num_bytes = min(total, cache->key.offset - byte_in_group);
 		if (alloc) {
 			old_val += num_bytes;
+			btrfs_set_block_group_used(&cache->item, old_val);
+			cache->reserved -= num_bytes;
 			cache->space_info->bytes_used += num_bytes;
+			cache->space_info->bytes_reserved -= num_bytes;
 			if (cache->ro)
 				cache->space_info->bytes_readonly -= num_bytes;
-			btrfs_set_block_group_used(&cache->item, old_val);
 			spin_unlock(&cache->lock);
 			spin_unlock(&cache->space_info->lock);
 		} else {
@@ -3056,127 +3127,136 @@ static u64 first_logical_byte(struct btrfs_root *root, u64 search_start)
 	return bytenr;
 }
 
-int btrfs_update_pinned_extents(struct btrfs_root *root,
-				u64 bytenr, u64 num, int pin)
+/*
+ * this function must be called within transaction
+ */
+int btrfs_pin_extent(struct btrfs_root *root,
+		     u64 bytenr, u64 num_bytes, int reserved)
 {
-	u64 len;
-	struct btrfs_block_group_cache *cache;
 	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_block_group_cache *cache;
 
-	if (pin)
-		set_extent_dirty(&fs_info->pinned_extents,
-				bytenr, bytenr + num - 1, GFP_NOFS);
-
-	while (num > 0) {
-		cache = btrfs_lookup_block_group(fs_info, bytenr);
-		BUG_ON(!cache);
-		len = min(num, cache->key.offset -
-			  (bytenr - cache->key.objectid));
-		if (pin) {
-			spin_lock(&cache->space_info->lock);
-			spin_lock(&cache->lock);
-			cache->pinned += len;
-			cache->space_info->bytes_pinned += len;
-			spin_unlock(&cache->lock);
-			spin_unlock(&cache->space_info->lock);
-			fs_info->total_pinned += len;
-		} else {
-			int unpin = 0;
+	cache = btrfs_lookup_block_group(fs_info, bytenr);
+	BUG_ON(!cache);
 
-			/*
-			 * in order to not race with the block group caching, we
-			 * only want to unpin the extent if we are cached.  If
-			 * we aren't cached, we want to start async caching this
-			 * block group so we can free the extent the next time
-			 * around.
-			 */
-			spin_lock(&cache->space_info->lock);
-			spin_lock(&cache->lock);
-			unpin = (cache->cached == BTRFS_CACHE_FINISHED);
-			if (likely(unpin)) {
-				cache->pinned -= len;
-				cache->space_info->bytes_pinned -= len;
-				fs_info->total_pinned -= len;
-			}
-			spin_unlock(&cache->lock);
-			spin_unlock(&cache->space_info->lock);
+	spin_lock(&cache->space_info->lock);
+	spin_lock(&cache->lock);
+	cache->pinned += num_bytes;
+	cache->space_info->bytes_pinned += num_bytes;
+	if (reserved) {
+		cache->reserved -= num_bytes;
+		cache->space_info->bytes_reserved -= num_bytes;
+	}
+	spin_unlock(&cache->lock);
+	spin_unlock(&cache->space_info->lock);
 
-			if (likely(unpin))
-				clear_extent_dirty(&fs_info->pinned_extents,
-						   bytenr, bytenr + len -1,
-						   GFP_NOFS);
-			else
-				cache_block_group(cache);
+	btrfs_put_block_group(cache);
 
-			if (unpin)
-				btrfs_add_free_space(cache, bytenr, len);
-		}
-		btrfs_put_block_group(cache);
-		bytenr += len;
-		num -= len;
+	set_extent_dirty(fs_info->pinned_extents,
+			 bytenr, bytenr + num_bytes - 1, GFP_NOFS);
+	return 0;
+}
+
+static int update_reserved_extents(struct btrfs_block_group_cache *cache,
+				   u64 num_bytes, int reserve)
+{
+	spin_lock(&cache->space_info->lock);
+	spin_lock(&cache->lock);
+	if (reserve) {
+		cache->reserved += num_bytes;
+		cache->space_info->bytes_reserved += num_bytes;
+	} else {
+		cache->reserved -= num_bytes;
+		cache->space_info->bytes_reserved -= num_bytes;
 	}
+	spin_unlock(&cache->lock);
+	spin_unlock(&cache->space_info->lock);
 	return 0;
 }
 
-static int update_reserved_extents(struct btrfs_root *root,
-				   u64 bytenr, u64 num, int reserve)
+int btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root)
 {
-	u64 len;
-	struct btrfs_block_group_cache *cache;
 	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_caching_control *next;
+	struct btrfs_caching_control *caching_ctl;
+	struct btrfs_block_group_cache *cache;
 
-	while (num > 0) {
-		cache = btrfs_lookup_block_group(fs_info, bytenr);
-		BUG_ON(!cache);
-		len = min(num, cache->key.offset -
-			  (bytenr - cache->key.objectid));
+	down_write(&fs_info->extent_commit_sem);
 
-		spin_lock(&cache->space_info->lock);
-		spin_lock(&cache->lock);
-		if (reserve) {
-			cache->reserved += len;
-			cache->space_info->bytes_reserved += len;
+	list_for_each_entry_safe(caching_ctl, next,
+				 &fs_info->caching_block_groups, list) {
+		cache = caching_ctl->block_group;
+		if (block_group_cache_done(cache)) {
+			cache->last_byte_to_unpin = (u64)-1;
+			list_del_init(&caching_ctl->list);
+			put_caching_control(caching_ctl);
 		} else {
-			cache->reserved -= len;
-			cache->space_info->bytes_reserved -= len;
+			cache->last_byte_to_unpin = caching_ctl->progress;
 		}
-		spin_unlock(&cache->lock);
-		spin_unlock(&cache->space_info->lock);
-		btrfs_put_block_group(cache);
-		bytenr += len;
-		num -= len;
 	}
+
+	if (fs_info->pinned_extents == &fs_info->freed_extents[0])
+		fs_info->pinned_extents = &fs_info->freed_extents[1];
+	else
+		fs_info->pinned_extents = &fs_info->freed_extents[0];
+
+	up_write(&fs_info->extent_commit_sem);
 	return 0;
 }
 
-int btrfs_copy_pinned(struct btrfs_root *root, struct extent_io_tree *copy)
+static int unpin_extent_range(struct btrfs_root *root, u64 start, u64 end)
 {
-	u64 last = 0;
-	u64 start;
-	u64 end;
-	struct extent_io_tree *pinned_extents = &root->fs_info->pinned_extents;
-	int ret;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_block_group_cache *cache = NULL;
+	u64 len;
 
-	while (1) {
-		ret = find_first_extent_bit(pinned_extents, last,
-					    &start, &end, EXTENT_DIRTY);
-		if (ret)
-			break;
+	while (start <= end) {
+		if (!cache ||
+		    start >= cache->key.objectid + cache->key.offset) {
+			if (cache)
+				btrfs_put_block_group(cache);
+			cache = btrfs_lookup_block_group(fs_info, start);
+			BUG_ON(!cache);
+		}
+
+		len = cache->key.objectid + cache->key.offset - start;
+		len = min(len, end + 1 - start);
+
+		if (start < cache->last_byte_to_unpin) {
+			len = min(len, cache->last_byte_to_unpin - start);
+			btrfs_add_free_space(cache, start, len);
+		}
+
+		spin_lock(&cache->space_info->lock);
+		spin_lock(&cache->lock);
+		cache->pinned -= len;
+		cache->space_info->bytes_pinned -= len;
+		spin_unlock(&cache->lock);
+		spin_unlock(&cache->space_info->lock);
 
-		set_extent_dirty(copy, start, end, GFP_NOFS);
-		last = end + 1;
+		start += len;
 	}
+
+	if (cache)
+		btrfs_put_block_group(cache);
 	return 0;
 }
 
 int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
-			       struct btrfs_root *root,
-			       struct extent_io_tree *unpin)
+			       struct btrfs_root *root)
 {
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct extent_io_tree *unpin;
 	u64 start;
 	u64 end;
 	int ret;
 
+	if (fs_info->pinned_extents == &fs_info->freed_extents[0])
+		unpin = &fs_info->freed_extents[1];
+	else
+		unpin = &fs_info->freed_extents[0];
+
 	while (1) {
 		ret = find_first_extent_bit(unpin, 0, &start, &end,
 					    EXTENT_DIRTY);
@@ -3185,10 +3265,8 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 
 		ret = btrfs_discard_extent(root, start, end + 1 - start);
 
-		/* unlocks the pinned mutex */
-		btrfs_update_pinned_extents(root, start, end + 1 - start, 0);
 		clear_extent_dirty(unpin, start, end, GFP_NOFS);
-
+		unpin_extent_range(root, start, end);
 		cond_resched();
 	}
 
@@ -3198,7 +3276,8 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 static int pin_down_bytes(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root,
 			  struct btrfs_path *path,
-			  u64 bytenr, u64 num_bytes, int is_data,
+			  u64 bytenr, u64 num_bytes,
+			  int is_data, int reserved,
 			  struct extent_buffer **must_clean)
 {
 	int err = 0;
@@ -3230,15 +3309,15 @@ static int pin_down_bytes(struct btrfs_trans_handle *trans,
 	}
 	free_extent_buffer(buf);
 pinit:
-	btrfs_set_path_blocking(path);
+	if (path)
+		btrfs_set_path_blocking(path);
 	/* unlocks the pinned mutex */
-	btrfs_update_pinned_extents(root, bytenr, num_bytes, 1);
+	btrfs_pin_extent(root, bytenr, num_bytes, reserved);
 
 	BUG_ON(err < 0);
 	return 0;
 }
 
-
 static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
 				u64 bytenr, u64 num_bytes, u64 parent,
@@ -3412,7 +3491,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 		}
 
 		ret = pin_down_bytes(trans, root, path, bytenr,
-				     num_bytes, is_data, &must_clean);
+				     num_bytes, is_data, 0, &must_clean);
 		if (ret > 0)
 			mark_free = 1;
 		BUG_ON(ret < 0);
@@ -3543,8 +3622,7 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 	if (root_objectid == BTRFS_TREE_LOG_OBJECTID) {
 		WARN_ON(owner >= BTRFS_FIRST_FREE_OBJECTID);
 		/* unlocks the pinned mutex */
-		btrfs_update_pinned_extents(root, bytenr, num_bytes, 1);
-		update_reserved_extents(root, bytenr, num_bytes, 0);
+		btrfs_pin_extent(root, bytenr, num_bytes, 1);
 		ret = 0;
 	} else if (owner < BTRFS_FIRST_FREE_OBJECTID) {
 		ret = btrfs_add_delayed_tree_ref(trans, bytenr, num_bytes,
@@ -3584,19 +3662,33 @@ static noinline int
 wait_block_group_cache_progress(struct btrfs_block_group_cache *cache,
 				u64 num_bytes)
 {
+	struct btrfs_caching_control *caching_ctl;
 	DEFINE_WAIT(wait);
 
-	prepare_to_wait(&cache->caching_q, &wait, TASK_UNINTERRUPTIBLE);
-
-	if (block_group_cache_done(cache)) {
-		finish_wait(&cache->caching_q, &wait);
+	caching_ctl = get_caching_control(cache);
+	if (!caching_ctl)
 		return 0;
-	}
-	schedule();
-	finish_wait(&cache->caching_q, &wait);
 
-	wait_event(cache->caching_q, block_group_cache_done(cache) ||
+	wait_event(caching_ctl->wait, block_group_cache_done(cache) ||
 		   (cache->free_space >= num_bytes));
+
+	put_caching_control(caching_ctl);
+	return 0;
+}
+
+static noinline int
+wait_block_group_cache_done(struct btrfs_block_group_cache *cache)
+{
+	struct btrfs_caching_control *caching_ctl;
+	DEFINE_WAIT(wait);
+
+	caching_ctl = get_caching_control(cache);
+	if (!caching_ctl)
+		return 0;
+
+	wait_event(caching_ctl->wait, block_group_cache_done(cache));
+
+	put_caching_control(caching_ctl);
 	return 0;
 }
 
@@ -3880,6 +3972,8 @@ checks:
 					     search_start - offset);
 		BUG_ON(offset > search_start);
 
+		update_reserved_extents(block_group, num_bytes, 1);
+
 		/* we are all good, lets return */
 		break;
 loop:
@@ -3972,12 +4066,12 @@ static void dump_space_info(struct btrfs_space_info *info, u64 bytes)
 	up_read(&info->groups_sem);
 }
 
-static int __btrfs_reserve_extent(struct btrfs_trans_handle *trans,
-				  struct btrfs_root *root,
-				  u64 num_bytes, u64 min_alloc_size,
-				  u64 empty_size, u64 hint_byte,
-				  u64 search_end, struct btrfs_key *ins,
-				  u64 data)
+int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
+			 struct btrfs_root *root,
+			 u64 num_bytes, u64 min_alloc_size,
+			 u64 empty_size, u64 hint_byte,
+			 u64 search_end, struct btrfs_key *ins,
+			 u64 data)
 {
 	int ret;
 	u64 search_start = 0;
@@ -4043,25 +4137,8 @@ int btrfs_free_reserved_extent(struct btrfs_root *root, u64 start, u64 len)
 	ret = btrfs_discard_extent(root, start, len);
 
 	btrfs_add_free_space(cache, start, len);
+	update_reserved_extents(cache, len, 0);
 	btrfs_put_block_group(cache);
-	update_reserved_extents(root, start, len, 0);
-
-	return ret;
-}
-
-int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
-				  struct btrfs_root *root,
-				  u64 num_bytes, u64 min_alloc_size,
-				  u64 empty_size, u64 hint_byte,
-				  u64 search_end, struct btrfs_key *ins,
-				  u64 data)
-{
-	int ret;
-	ret = __btrfs_reserve_extent(trans, root, num_bytes, min_alloc_size,
-				     empty_size, hint_byte, search_end, ins,
-				     data);
-	if (!ret)
-		update_reserved_extents(root, ins->objectid, ins->offset, 1);
 
 	return ret;
 }
@@ -4222,15 +4299,46 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 {
 	int ret;
 	struct btrfs_block_group_cache *block_group;
+	struct btrfs_caching_control *caching_ctl;
+	u64 start = ins->objectid;
+	u64 num_bytes = ins->offset;
 
 	block_group = btrfs_lookup_block_group(root->fs_info, ins->objectid);
 	cache_block_group(block_group);
-	wait_event(block_group->caching_q,
-		   block_group_cache_done(block_group));
+	caching_ctl = get_caching_control(block_group);
 
-	ret = btrfs_remove_free_space(block_group, ins->objectid,
-				      ins->offset);
-	BUG_ON(ret);
+	if (!caching_ctl) {
+		BUG_ON(!block_group_cache_done(block_group));
+		ret = btrfs_remove_free_space(block_group, start, num_bytes);
+		BUG_ON(ret);
+	} else {
+		mutex_lock(&caching_ctl->mutex);
+
+		if (start >= caching_ctl->progress) {
+			ret = add_excluded_extent(root, start, num_bytes);
+			BUG_ON(ret);
+		} else if (start + num_bytes <= caching_ctl->progress) {
+			ret = btrfs_remove_free_space(block_group,
+						      start, num_bytes);
+			BUG_ON(ret);
+		} else {
+			num_bytes = caching_ctl->progress - start;
+			ret = btrfs_remove_free_space(block_group,
+						      start, num_bytes);
+			BUG_ON(ret);
+
+			start = caching_ctl->progress;
+			num_bytes = ins->objectid + ins->offset -
+				    caching_ctl->progress;
+			ret = add_excluded_extent(root, start, num_bytes);
+			BUG_ON(ret);
+		}
+
+		mutex_unlock(&caching_ctl->mutex);
+		put_caching_control(caching_ctl);
+	}
+
+	update_reserved_extents(block_group, ins->offset, 1);
 	btrfs_put_block_group(block_group);
 	ret = alloc_reserved_file_extent(trans, root, 0, root_objectid,
 					 0, owner, offset, ins, 1);
@@ -4254,9 +4362,9 @@ static int alloc_tree_block(struct btrfs_trans_handle *trans,
 	int ret;
 	u64 flags = 0;
 
-	ret = __btrfs_reserve_extent(trans, root, num_bytes, num_bytes,
-				     empty_size, hint_byte, search_end,
-				     ins, 0);
+	ret = btrfs_reserve_extent(trans, root, num_bytes, num_bytes,
+				   empty_size, hint_byte, search_end,
+				   ins, 0);
 	if (ret)
 		return ret;
 
@@ -4267,7 +4375,6 @@ static int alloc_tree_block(struct btrfs_trans_handle *trans,
 	} else
 		BUG_ON(parent > 0);
 
-	update_reserved_extents(root, ins->objectid, ins->offset, 1);
 	if (root_objectid != BTRFS_TREE_LOG_OBJECTID) {
 		struct btrfs_delayed_extent_op *extent_op;
 		extent_op = kmalloc(sizeof(*extent_op), GFP_NOFS);
@@ -7164,8 +7271,18 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 {
 	struct btrfs_block_group_cache *block_group;
 	struct btrfs_space_info *space_info;
+	struct btrfs_caching_control *caching_ctl;
 	struct rb_node *n;
 
+	down_write(&info->extent_commit_sem);
+	while (!list_empty(&info->caching_block_groups)) {
+		caching_ctl = list_entry(info->caching_block_groups.next,
+					 struct btrfs_caching_control, list);
+		list_del(&caching_ctl->list);
+		put_caching_control(caching_ctl);
+	}
+	up_write(&info->extent_commit_sem);
+
 	spin_lock(&info->block_group_cache_lock);
 	while ((n = rb_last(&info->block_group_cache_tree)) != NULL) {
 		block_group = rb_entry(n, struct btrfs_block_group_cache,
@@ -7179,8 +7296,7 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 		up_write(&block_group->space_info->groups_sem);
 
 		if (block_group->cached == BTRFS_CACHE_STARTED)
-			wait_event(block_group->caching_q,
-				   block_group_cache_done(block_group));
+			wait_block_group_cache_done(block_group);
 
 		btrfs_remove_free_space_cache(block_group);
 
@@ -7250,7 +7366,6 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		spin_lock_init(&cache->lock);
 		spin_lock_init(&cache->tree_lock);
 		cache->fs_info = info;
-		init_waitqueue_head(&cache->caching_q);
 		INIT_LIST_HEAD(&cache->list);
 		INIT_LIST_HEAD(&cache->cluster_list);
 
@@ -7272,8 +7387,6 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		cache->flags = btrfs_block_group_flags(&cache->item);
 		cache->sectorsize = root->sectorsize;
 
-		remove_sb_from_cache(root, cache);
-
 		/*
 		 * check for two cases, either we are full, and therefore
 		 * don't need to bother with the caching work since we won't
@@ -7282,13 +7395,17 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		 * time, particularly in the full case.
 		 */
 		if (found_key.offset == btrfs_block_group_used(&cache->item)) {
+			cache->last_byte_to_unpin = (u64)-1;
 			cache->cached = BTRFS_CACHE_FINISHED;
 		} else if (btrfs_block_group_used(&cache->item) == 0) {
+			exclude_super_stripes(root, cache);
+			cache->last_byte_to_unpin = (u64)-1;
 			cache->cached = BTRFS_CACHE_FINISHED;
 			add_new_free_space(cache, root->fs_info,
 					   found_key.objectid,
 					   found_key.objectid +
 					   found_key.offset);
+			free_excluded_extents(root, cache);
 		}
 
 		ret = update_space_info(info, cache->flags, found_key.offset,
@@ -7345,7 +7462,6 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	atomic_set(&cache->count, 1);
 	spin_lock_init(&cache->lock);
 	spin_lock_init(&cache->tree_lock);
-	init_waitqueue_head(&cache->caching_q);
 	INIT_LIST_HEAD(&cache->list);
 	INIT_LIST_HEAD(&cache->cluster_list);
 
@@ -7354,12 +7470,15 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	cache->flags = type;
 	btrfs_set_block_group_flags(&cache->item, type);
 
+	cache->last_byte_to_unpin = (u64)-1;
 	cache->cached = BTRFS_CACHE_FINISHED;
-	remove_sb_from_cache(root, cache);
+	exclude_super_stripes(root, cache);
 
 	add_new_free_space(cache, root->fs_info, chunk_offset,
 			   chunk_offset + size);
 
+	free_excluded_extents(root, cache);
+
 	ret = update_space_info(root->fs_info, cache->flags, size, bytes_used,
 				&cache->space_info);
 	BUG_ON(ret);
@@ -7428,8 +7547,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	up_write(&block_group->space_info->groups_sem);
 
 	if (block_group->cached == BTRFS_CACHE_STARTED)
-		wait_event(block_group->caching_q,
-			   block_group_cache_done(block_group));
+		wait_block_group_cache_done(block_group);
 
 	btrfs_remove_free_space_cache(block_group);
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index cdbb502..6ed6186 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -874,7 +874,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	unsigned long timeout = 1;
 	struct btrfs_transaction *cur_trans;
 	struct btrfs_transaction *prev_trans = NULL;
-	struct extent_io_tree *pinned_copy;
 	DEFINE_WAIT(wait);
 	int ret;
 	int should_grow = 0;
@@ -915,13 +914,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 		return 0;
 	}
 
-	pinned_copy = kmalloc(sizeof(*pinned_copy), GFP_NOFS);
-	if (!pinned_copy)
-		return -ENOMEM;
-
-	extent_io_tree_init(pinned_copy,
-			     root->fs_info->btree_inode->i_mapping, GFP_NOFS);
-
 	trans->transaction->in_commit = 1;
 	trans->transaction->blocked = 1;
 	if (cur_trans->list.prev != &root->fs_info->trans_list) {
@@ -1019,6 +1011,8 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	ret = commit_cowonly_roots(trans, root);
 	BUG_ON(ret);
 
+	btrfs_prepare_extent_commit(trans, root);
+
 	cur_trans = root->fs_info->running_transaction;
 	spin_lock(&root->fs_info->new_trans_lock);
 	root->fs_info->running_transaction = NULL;
@@ -1042,8 +1036,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	memcpy(&root->fs_info->super_for_commit, &root->fs_info->super_copy,
 	       sizeof(root->fs_info->super_copy));
 
-	btrfs_copy_pinned(root, pinned_copy);
-
 	trans->transaction->blocked = 0;
 
 	wake_up(&root->fs_info->transaction_wait);
@@ -1059,8 +1051,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	 */
 	mutex_unlock(&root->fs_info->tree_log_mutex);
 
-	btrfs_finish_extent_commit(trans, root, pinned_copy);
-	kfree(pinned_copy);
+	btrfs_finish_extent_commit(trans, root);
 
 	/* do the directory inserts of any pending snapshot creations */
 	finish_pending_snapshots(trans, root->fs_info);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 8661a73..f4a7b62 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -263,8 +263,8 @@ static int process_one_buffer(struct btrfs_root *log,
 			      struct walk_control *wc, u64 gen)
 {
 	if (wc->pin)
-		btrfs_update_pinned_extents(log->fs_info->extent_root,
-					    eb->start, eb->len, 1);
+		btrfs_pin_extent(log->fs_info->extent_root,
+				 eb->start, eb->len, 0);
 
 	if (btrfs_buffer_uptodate(eb, gen)) {
 		if (wc->write)
-- 
1.6.4.1

