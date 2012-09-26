Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:50072 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754470Ab2IZLhD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Sep 2012 07:37:03 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q8QBax3F026028
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Sep 2012 19:36:59 +0800
Message-ID: <5062E8E3.2060805@cn.fujitsu.com>
Date: Wed, 26 Sep 2012 19:37:07 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [RFC][PATCH V2 2/4] Btrfs: introduce extent buffer cache for each
 i-node
References: <5062E563.7090105@cn.fujitsu.com>
In-Reply-To: <5062E563.7090105@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch introduce extent buffer cache for every i-node. By this
way, we needn't search the item from the root of b+ tree, and can
save the search time. Besides that we can also reduce the lock contention
of the root.

Implementation:
- add two field - chg_seq and free_seq - into the extent buffer structure.
  chg_seq is used to record the time that we change the extent buffer for
  the b+ tree balance. free_seq is used to record the time that the extent
  buffer is removed from the tree.
- define a structure named extent_buffer_cache which is used to keep the
  cached extent buffer, besides that, it also keep the transaction id,
  chg_seq and free_seq of the cached extent buffer. These variants can
  tell us if the cached extent buffer is stale or not.
- add two extent buffer caches into btrfs_inode struct, one for nodes/leaves
  of fs/file tree, the other for nodes/leaves of the log tree. We will pass
  these caches to btrfs_search_slot() by the "path" parameter.
- When we want to search fs/file trees or the relative log trees, we must
  try to search the cached extent buffer at first, if we can not find the
  item, we will do the common search. At some condition, we will jump to
  the common search directly:
  I. a new transaction starts.
  II. the cached extent buffer is stale.
  III. the cached extent buffer's level is below the level we must lock.
  and so on.
  And beside that, if we can not find the item, and the slot points to the
  first the item or the last item in the leaf, we must jump out the cached
  extent buffer search, and do the common search.
- After the common search (use btrfs_search_slot), we will cache the leaf
  or the level-1 node into the btrfs i-node object.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/acl.c          |    1 -
 fs/btrfs/btrfs_inode.h  |    6 +-
 fs/btrfs/compression.c  |    1 -
 fs/btrfs/ctree.c        |  313 ++++++++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/ctree.h        |   32 ++++-
 fs/btrfs/dir-item.c     |    2 +
 fs/btrfs/disk-io.c      |    2 +-
 fs/btrfs/export.c       |    1 -
 fs/btrfs/extent-tree.c  |    1 +
 fs/btrfs/extent_io.c    |    9 +-
 fs/btrfs/extent_io.h    |   38 ++++++
 fs/btrfs/file-item.c    |    4 +-
 fs/btrfs/file.c         |    5 +-
 fs/btrfs/inode-item.c   |   10 +-
 fs/btrfs/inode.c        |   36 ++++--
 fs/btrfs/ioctl.c        |    1 -
 fs/btrfs/ordered-data.c |    1 -
 fs/btrfs/relocation.c   |    1 -
 fs/btrfs/send.c         |    1 -
 fs/btrfs/super.c        |    1 -
 fs/btrfs/transaction.c  |    1 +
 fs/btrfs/transaction.h  |    1 -
 fs/btrfs/tree-log.c     |    6 +-
 fs/btrfs/xattr.c        |    2 +-
 24 files changed, 429 insertions(+), 47 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 761e2cd..c7302e5 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -25,7 +25,6 @@
 #include <linux/slab.h>
 
 #include "ctree.h"
-#include "btrfs_inode.h"
 #include "xattr.h"
 
 struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 5b2ad6b..115c249 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -22,7 +22,6 @@
 #include "extent_map.h"
 #include "extent_io.h"
 #include "ordered-data.h"
-#include "delayed-inode.h"
 
 /*
  * ordered_data_close is set by truncate when a file that used
@@ -39,6 +38,7 @@
 #define BTRFS_INODE_HAS_ORPHAN_ITEM		5
 #define BTRFS_INODE_HAS_ASYNC_EXTENT		6
 
+struct btrfs_delayed_node;
 /* in memory btrfs inode */
 struct btrfs_inode {
 	/* which subvolume this inode belongs to */
@@ -159,6 +159,9 @@ struct btrfs_inode {
 
 	struct btrfs_delayed_node *delayed_node;
 
+	struct extent_buffer_cache fs_eb_cache;
+	struct extent_buffer_cache log_eb_cache;
+
 	struct inode vfs_inode;
 };
 
@@ -212,5 +215,4 @@ static inline int btrfs_inode_in_log(struct inode *inode, u64 generation)
 	mutex_unlock(&root->log_mutex);
 	return ret;
 }
-
 #endif
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 43d1c5a..7cb135d 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -36,7 +36,6 @@
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
-#include "btrfs_inode.h"
 #include "volumes.h"
 #include "ordered-data.h"
 #include "compression.h"
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 3da5280..8803f8e 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -149,7 +149,10 @@ noinline void btrfs_release_path(struct btrfs_path *p)
 		}
 		free_extent_buffer(p->nodes[i]);
 		p->nodes[i] = NULL;
+		p->free_seq[i] = 0;
+		p->chg_seq[i] = 0;
 	}
+	p->max_level = 0;
 }
 
 /*
@@ -1053,6 +1056,9 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 		btrfs_free_tree_block(trans, root, buf, parent_start,
 				      last_ref);
 	}
+
+	write_seqcount_barrier(&buf->free_seq);
+
 	if (unlock_orig)
 		btrfs_tree_unlock(buf);
 	free_extent_buffer_stale(buf);
@@ -1734,6 +1740,9 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		path->locks[level] = 0;
 		path->nodes[level] = NULL;
 		clean_tree_block(trans, root, mid);
+
+		write_seqcount_barrier(&mid->free_seq);
+
 		btrfs_tree_unlock(mid);
 		/* once for the path */
 		free_extent_buffer(mid);
@@ -1788,6 +1797,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 			ret = wret;
 		if (btrfs_header_nritems(right) == 0) {
 			clean_tree_block(trans, root, right);
+			write_seqcount_barrier(&right->free_seq);
 			btrfs_tree_unlock(right);
 			del_ptr(trans, root, path, level + 1, pslot + 1, 1);
 			root_sub_used(root, right->len);
@@ -1832,6 +1842,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 	}
 	if (btrfs_header_nritems(mid) == 0) {
 		clean_tree_block(trans, root, mid);
+		write_seqcount_barrier(&mid->free_seq);
 		btrfs_tree_unlock(mid);
 		del_ptr(trans, root, path, level + 1, pslot, 1);
 		root_sub_used(root, mid->len);
@@ -2504,6 +2515,9 @@ cow_done:
 		p->nodes[level] = b;
 		btrfs_clear_path_blocking(p, NULL, 0);
 
+		p->chg_seq[level] = raw_seqcount_begin(&b->chg_seq);
+		p->free_seq[level] = raw_seqcount_begin(&b->free_seq);
+
 		/*
 		 * we have a lock on b and as long as we aren't changing
 		 * the tree, there is no way to for the items in b to change.
@@ -2647,22 +2661,10 @@ done:
 }
 
 
-/*
- * look for key in the tree.  path is filled in with nodes along the way
- * if key is found, we return zero and you can find the item in the leaf
- * level of the path (level 0)
- *
- * If the key isn't found, the path points to the slot where it should
- * be inserted, and 1 is returned.  If there are other errors during the
- * search a negative error number is returned.
- *
- * if ins_len > 0, nodes and leaves will be split as we walk down the
- * tree.  if ins_len < 0, nodes will be merged as we walk down the tree (if
- * possible)
- */
-int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
-		      *root, struct btrfs_key *key, struct btrfs_path *p, int
-		      ins_len, int cow)
+static int btrfs_search_slot_root(struct btrfs_trans_handle *trans,
+				  struct btrfs_root *root,
+				  struct btrfs_key *key, struct btrfs_path *p,
+				  int ins_len, int cow)
 {
 	struct extent_buffer *b;
 	int ret;
@@ -2744,6 +2746,8 @@ again:
 	if (!p->skip_locking)
 		p->locks[level] = root_lock;
 
+	p->max_level = level;
+
 	ret = __search_slot(trans, root, b, key, p, ins_len, cow,
 			    lowest_unlock, &write_lock_level,
 			    min_write_lock_level, lowest_level, true);
@@ -2755,6 +2759,268 @@ again:
 	return ret;
 }
 
+static int check_search_result_valid(struct btrfs_path *p, int ins_len,
+				     int start_level, bool is_found)
+{
+	int i;
+
+	if (ins_len < 0 && p->slots[start_level] == 0) {
+		for (i = start_level - 1; i >= 0; i--) {
+			if (p->slots[i] != 0)
+				return 1;
+		}
+		return 0;
+	}
+
+	if (is_found)
+		return 1;
+
+	if (p->slots[start_level] == 0) {
+		for (i = start_level - 1; i >= 0; i--) {
+			if (p->slots[i] != 0)
+				return 1;
+		}
+		return 0;
+	}
+
+	while (start_level >= 0 && !p->locks[start_level])
+		start_level--;
+
+	if (start_level < 0)
+		return 0;
+
+	for (i = start_level; i >= 0; i--) {
+		if (i > 0 &&
+		    p->slots[i] < btrfs_header_nritems(p->nodes[i]) - 1)
+				return 1;
+		if (i == 0 &&
+		    p->slots[i] != btrfs_header_nritems(p->nodes[i]))
+				return 1;
+	}
+	return 0;
+}
+
+static int btrfs_search_slot_node(struct btrfs_trans_handle *trans,
+				  struct btrfs_root *root,
+				  struct extent_buffer *cached_eb,
+				  unsigned free_seq,
+				  struct btrfs_key *key,
+				  struct btrfs_path *p,
+				  int ins_len, int cow)
+{
+	struct btrfs_key tmp_key;
+	int ret;
+	int level;
+	int lowest_unlock = 1;
+	int write_lock_level = 0;
+	int min_write_lock_level = 0;
+	int root_lock;
+	u8 lowest_level = 0;
+
+	if (cow && (p->keep_locks || p->lowest_level))
+		return -ERESTART;
+
+	BUG_ON(p->search_commit_root);
+	BUG_ON(!cached_eb);
+
+	lowest_level = p->lowest_level;
+	WARN_ON(lowest_level && ins_len > 0);
+	WARN_ON(p->nodes[0] != NULL);
+
+	if (ins_len < 0) {
+		lowest_unlock = 2;
+		write_lock_level = 1;
+	}
+
+	if (!cow)
+		write_lock_level = -1;
+
+	min_write_lock_level = write_lock_level;
+again:
+	level = btrfs_header_level(cached_eb);
+	if (level < write_lock_level || level < lowest_level)
+		return -ERESTART;
+
+	if (test_bit(EXTENT_BUFFER_STALE, &cached_eb->bflags))
+		return -ERESTART;
+
+	if (cow && btrfs_header_generation(cached_eb) != trans->transid)
+		return -ERESTART;
+
+	extent_buffer_get(cached_eb);
+
+	root_lock = 0;
+	if (!p->skip_locking) {
+		if (level <= write_lock_level) {
+			btrfs_tree_lock(cached_eb);
+			root_lock = BTRFS_WRITE_LOCK;
+		} else {
+			btrfs_tree_read_lock(cached_eb);
+			root_lock = BTRFS_READ_LOCK;
+		}
+	}
+
+	level = btrfs_header_level(cached_eb);
+	p->nodes[level] = cached_eb;
+	p->locks[level] = root_lock;
+
+	if (read_seqcount_retry(&cached_eb->free_seq, free_seq)) {
+		btrfs_release_path(p);
+		return -ERESTART;
+	} else if (cow &&
+		   btrfs_header_generation(cached_eb) != trans->transid) {
+		btrfs_release_path(p);
+		return -ERESTART;
+	} else if (level < write_lock_level || level < lowest_level) {
+		btrfs_release_path(p);
+		return -ERESTART;
+	} else if (test_bit(EXTENT_BUFFER_STALE, &cached_eb->bflags)) {
+		btrfs_release_path(p);
+		return -ERESTART;
+	}
+
+	if (level > 0)
+		btrfs_node_key_to_cpu(cached_eb, &tmp_key, 0);
+	else
+		btrfs_item_key_to_cpu(cached_eb, &tmp_key, 0);
+
+	if (btrfs_comp_cpu_keys(key, &tmp_key) < 0) {
+		btrfs_release_path(p);
+		return -ERESTART;
+	}
+
+	if (level > 0)
+		btrfs_node_key_to_cpu(cached_eb, &tmp_key,
+				      btrfs_header_nritems(cached_eb) - 1);
+	else
+		btrfs_item_key_to_cpu(cached_eb, &tmp_key,
+				      btrfs_header_nritems(cached_eb) - 1);
+
+	if (btrfs_comp_cpu_keys(key, &tmp_key) > 0) {
+		btrfs_release_path(p);
+		return -ERESTART;
+	}
+
+	ret = __search_slot(trans, root, cached_eb, key, p, ins_len, cow,
+			    lowest_unlock, &write_lock_level,
+			    min_write_lock_level, lowest_level, false);
+	if (ret == -EAGAIN)
+		goto again;
+
+	if (ret >= 0) {
+		if (!check_search_result_valid(p, ins_len, level, !ret)) {
+			ret = -ERESTART;
+			btrfs_release_path(p);
+		}
+	}
+
+	return ret;
+}
+
+/*
+ * look for key in the tree.  path is filled in with nodes along the way
+ * if key is found, we return zero and you can find the item in the leaf
+ * level of the path (level 0)
+ *
+ * If the key isn't found, the path points to the slot where it should
+ * be inserted, and 1 is returned.  If there are other errors during the
+ * search a negative error number is returned.
+ *
+ * if ins_len > 0, nodes and leaves will be split as we walk down the
+ * tree.  if ins_len < 0, nodes will be merged as we walk down the tree (if
+ * possible)
+ */
+int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		      struct btrfs_key *key, struct btrfs_path *p, int ins_len,
+		      int cow)
+{
+	struct extent_buffer_cache *eb_cache = NULL;
+	struct extent_buffer *cached_eb;
+	unsigned seq;
+	int cache_level;
+	int ret;
+
+	if (unlikely(p->search_commit_root || p->keep_locks ||
+		     (cow && p->lowest_level)))
+		goto common_search;
+
+	if (p->eb_cache) {
+		eb_cache = p->eb_cache;
+
+		btrfs_lock_extent_buffer_cache(eb_cache);
+		cached_eb = eb_cache->cached_eb;
+		if (!cached_eb) {
+			btrfs_unlock_extent_buffer_cache(eb_cache);
+			goto common_search;
+		}
+
+		if (trans && trans->transid != eb_cache->transid) {
+			btrfs_unlock_extent_buffer_cache(eb_cache);
+			goto common_search;
+		}
+
+		seq = eb_cache->free_seq;
+		if (read_seqcount_retry(&cached_eb->free_seq, seq)) {
+			btrfs_unlock_extent_buffer_cache(eb_cache);
+			goto common_search;
+		}
+
+		seq = eb_cache->chg_seq;
+		smp_rmb();
+		if (raw_seqcount_begin(&cached_eb->chg_seq) - seq > 5) {
+			btrfs_unlock_extent_buffer_cache(eb_cache);
+			goto common_search;
+		}
+		seq = eb_cache->free_seq;
+		extent_buffer_get(cached_eb);
+		btrfs_unlock_extent_buffer_cache(eb_cache);
+
+		ret = btrfs_search_slot_node(trans, root, cached_eb, seq,
+					     key, p, ins_len, cow);
+		free_extent_buffer(cached_eb);
+		if (ret >= 0)
+			return ret;
+
+		if (ret != -ERESTART)
+			return ret;
+	}
+common_search:
+	ret = btrfs_search_slot_root(trans, root, key, p, ins_len, cow);
+	if (ret >= 0 && eb_cache) {
+		if (p->max_level <= 1)
+			goto out;
+
+		cache_level = 1;
+		if (ins_len >= 0 &&
+		    (read_seqcount_retry(&p->nodes[cache_level]->free_seq,
+					 p->free_seq[cache_level]) ||
+		     read_seqcount_retry(&p->nodes[cache_level]->chg_seq,
+					 p->chg_seq[cache_level])))
+			cache_level = 0;
+
+		btrfs_lock_extent_buffer_cache(eb_cache);
+		eb_cache->chg_seq =
+			read_seqcount_begin(&p->nodes[cache_level]->chg_seq);
+		eb_cache->free_seq =
+			read_seqcount_begin(&p->nodes[cache_level]->free_seq);
+
+		if (eb_cache->cached_eb == p->nodes[cache_level]) {
+			btrfs_unlock_extent_buffer_cache(eb_cache);
+			goto out;
+		}
+
+		cached_eb = eb_cache->cached_eb;
+		eb_cache->cached_eb = p->nodes[cache_level];
+		if (trans)
+			eb_cache->transid = trans->transid;
+		btrfs_unlock_extent_buffer_cache(eb_cache);
+		free_extent_buffer(cached_eb);
+		extent_buffer_get(p->nodes[cache_level]);
+	}
+out:
+	return ret;
+}
+
 /*
  * Like btrfs_search_slot, this looks for a key in the given tree. It uses the
  * current state of the tree together with the operations recorded in the tree
@@ -3056,6 +3322,8 @@ static int push_node_left(struct btrfs_trans_handle *trans,
 	}
 	btrfs_set_header_nritems(src, src_nritems - push_items);
 	btrfs_set_header_nritems(dst, dst_nritems + push_items);
+	write_seqcount_barrier(&src->chg_seq);
+	write_seqcount_barrier(&dst->chg_seq);
 	btrfs_mark_buffer_dirty(src);
 	btrfs_mark_buffer_dirty(dst);
 
@@ -3118,6 +3386,8 @@ static int balance_node_right(struct btrfs_trans_handle *trans,
 	btrfs_set_header_nritems(src, src_nritems - push_items);
 	btrfs_set_header_nritems(dst, dst_nritems + push_items);
 
+	write_seqcount_barrier(&src->chg_seq);
+	write_seqcount_barrier(&dst->chg_seq);
 	btrfs_mark_buffer_dirty(src);
 	btrfs_mark_buffer_dirty(dst);
 
@@ -3313,6 +3583,8 @@ static noinline int split_node(struct btrfs_trans_handle *trans,
 	btrfs_set_header_nritems(c, mid);
 	ret = 0;
 
+	write_seqcount_barrier(&c->chg_seq);
+	write_seqcount_barrier(&split->chg_seq);
 	btrfs_mark_buffer_dirty(c);
 	btrfs_mark_buffer_dirty(split);
 
@@ -3484,11 +3756,13 @@ static noinline int __push_leaf_right(struct btrfs_trans_handle *trans,
 	left_nritems -= push_items;
 	btrfs_set_header_nritems(left, left_nritems);
 
+	write_seqcount_barrier(&left->chg_seq);
 	if (left_nritems)
 		btrfs_mark_buffer_dirty(left);
 	else
 		clean_tree_block(trans, root, left);
 
+	write_seqcount_barrier(&right->chg_seq);
 	btrfs_mark_buffer_dirty(right);
 
 	btrfs_item_key(right, &disk_key, 0);
@@ -3709,6 +3983,8 @@ static noinline int __push_leaf_left(struct btrfs_trans_handle *trans,
 		btrfs_set_token_item_offset(right, item, push_space, &token);
 	}
 
+	write_seqcount_barrier(&left->chg_seq);
+	write_seqcount_barrier(&right->chg_seq);
 	btrfs_mark_buffer_dirty(left);
 	if (right_nritems)
 		btrfs_mark_buffer_dirty(right);
@@ -3856,6 +4132,8 @@ static noinline void copy_for_split(struct btrfs_trans_handle *trans,
 	insert_ptr(trans, root, path, &disk_key, right->start,
 		   path->slots[1] + 1, 1);
 
+	write_seqcount_barrier(&right->chg_seq);
+	write_seqcount_barrier(&l->chg_seq);
 	btrfs_mark_buffer_dirty(right);
 	btrfs_mark_buffer_dirty(l);
 	BUG_ON(path->slots[0] != slot);
@@ -4401,6 +4679,7 @@ void btrfs_truncate_item(struct btrfs_trans_handle *trans,
 
 	item = btrfs_item_nr(leaf, slot);
 	btrfs_set_item_size(leaf, item, new_size);
+	write_seqcount_barrier(&leaf->chg_seq);
 	btrfs_mark_buffer_dirty(leaf);
 
 	if (btrfs_leaf_free_space(root, leaf) < 0) {
@@ -4838,6 +5117,8 @@ static noinline void btrfs_del_leaf(struct btrfs_trans_handle *trans,
 	WARN_ON(btrfs_header_generation(leaf) != trans->transid);
 	del_ptr(trans, root, path, 1, path->slots[1], 1);
 
+	write_seqcount_barrier(&leaf->free_seq);
+
 	/*
 	 * btrfs_free_extent is expensive, we want to make sure we
 	 * aren't holding any locks when we call it
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index c38734a..ddda52e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -548,9 +548,14 @@ struct btrfs_path {
 	int slots[BTRFS_MAX_LEVEL];
 	/* if there is real range locking, this locks field will change */
 	int locks[BTRFS_MAX_LEVEL];
+	unsigned free_seq[BTRFS_MAX_LEVEL];
+	unsigned chg_seq[BTRFS_MAX_LEVEL];
 	int reada;
 	/* keep some upper locks as we walk down */
 	int lowest_level;
+	int max_level;
+
+	struct extent_buffer_cache *eb_cache;
 
 	/*
 	 * set by btrfs_split_item, tells search_slot to keep all locks
@@ -2730,6 +2735,27 @@ static inline u32 btrfs_level_size(struct btrfs_root *root, int level)
 	return root->nodesize;
 }
 
+#include "btrfs_inode.h"
+
+static inline void btrfs_path_set_eb_cache(struct btrfs_root *root,
+					   struct inode *inode,
+					   struct btrfs_path *path)
+{
+	WARN_ON(path->eb_cache);
+
+	if (!path->search_commit_root) {
+		if (root->objectid == BTRFS_TREE_LOG_OBJECTID)
+			path->eb_cache = &BTRFS_I(inode)->log_eb_cache;
+		else
+			path->eb_cache = &BTRFS_I(inode)->fs_eb_cache;
+	}
+}
+
+static inline void btrfs_path_clear_eb_cache(struct btrfs_path *path)
+{
+	path->eb_cache = NULL;
+}
+
 /* helper function to cast into the data area of the leaf. */
 #define btrfs_item_ptr(leaf, slot, type) \
 	((type *)(btrfs_leaf_data(leaf) + \
@@ -3167,11 +3193,11 @@ int btrfs_find_orphan_item(struct btrfs_root *root, u64 offset);
 int btrfs_insert_inode_ref(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   const char *name, int name_len,
-			   u64 inode_objectid, u64 ref_objectid, u64 index);
+			   struct inode *inode, u64 ref_objectid, u64 index);
 int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   const char *name, int name_len,
-			   u64 inode_objectid, u64 ref_objectid, u64 *index);
+			   struct inode *inode, u64 ref_objectid, u64 *index);
 struct btrfs_inode_ref *
 btrfs_lookup_inode_ref(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root,
@@ -3194,7 +3220,7 @@ int btrfs_lookup_bio_sums_dio(struct btrfs_root *root, struct inode *inode,
 			      struct bio *bio, u64 logical_offset);
 int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
-			     u64 objectid, u64 pos,
+			     struct inode *inode, u64 pos,
 			     u64 disk_offset, u64 disk_num_bytes,
 			     u64 num_bytes, u64 offset, u64 ram_bytes,
 			     u8 compression, u8 encryption, u16 other_encoding);
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index c1a074d..de8caa3 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -20,6 +20,7 @@
 #include "disk-io.h"
 #include "hash.h"
 #include "transaction.h"
+#include "delayed-inode.h"
 
 /*
  * insert a name into a directory, doing overflow properly if there is a hash
@@ -144,6 +145,7 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans, struct btrfs_root
 	btrfs_cpu_key_to_disk(&disk_key, location);
 
 	data_size = sizeof(*dir_item) + name_len;
+	btrfs_path_set_eb_cache(root, dir, path);
 	dir_item = insert_with_overflow(trans, root, path, &key, data_size,
 					name, name_len);
 	if (IS_ERR(dir_item)) {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 29c69e6..a8a8943 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -35,7 +35,6 @@
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
-#include "btrfs_inode.h"
 #include "volumes.h"
 #include "print-tree.h"
 #include "async-thread.h"
@@ -45,6 +44,7 @@
 #include "inode-map.h"
 #include "check-integrity.h"
 #include "rcu-string.h"
+#include "delayed-inode.h"
 
 static struct extent_io_ops btree_extent_io_ops;
 static void end_workqueue_fn(struct btrfs_work *work);
diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
index 614f34a..f4f39fa 100644
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -2,7 +2,6 @@
 #include <linux/types.h>
 #include "ctree.h"
 #include "disk-io.h"
-#include "btrfs_inode.h"
 #include "print-tree.h"
 #include "export.h"
 #include "compat.h"
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ba58024..af0ea25 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -33,6 +33,7 @@
 #include "volumes.h"
 #include "locking.h"
 #include "free-space-cache.h"
+#include "delayed-inode.h"
 
 #undef SCRAMBLE_DELAYED_REFS
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 49085f2..f8ecd72 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -16,7 +16,6 @@
 #include "extent_map.h"
 #include "compat.h"
 #include "ctree.h"
-#include "btrfs_inode.h"
 #include "volumes.h"
 #include "check-integrity.h"
 #include "locking.h"
@@ -3774,6 +3773,12 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		return -ENOMEM;
 	path->leave_spinning = 1;
 
+	/*
+	 * we are sure we will search the fs/file tree, so needn't call
+	 * btrfs_path_set_eb_cache
+	 */
+	path->eb_cache = &BTRFS_I(inode)->fs_eb_cache;
+
 	start = ALIGN(start, BTRFS_I(inode)->root->sectorsize);
 	len = ALIGN(len, BTRFS_I(inode)->root->sectorsize);
 
@@ -3965,6 +3970,8 @@ static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
 	eb->lock_nested = 0;
 	init_waitqueue_head(&eb->write_lock_wq);
 	init_waitqueue_head(&eb->read_lock_wq);
+	seqcount_init(&eb->chg_seq);
+	seqcount_init(&eb->free_seq);
 
 #if LEAK_DEBUG
 	spin_lock_irqsave(&leak_lock, flags);
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 25900af..536b729 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -138,6 +138,11 @@ struct extent_buffer {
 	struct rcu_head rcu_head;
 	pid_t lock_owner;
 
+	/* trace the time of changing */
+	seqcount_t chg_seq;
+	/* trace the time that this extent buffer is erased from the tree */
+	seqcount_t free_seq;
+
 	/* count of read lock holders on the extent buffer */
 	atomic_t write_locks;
 	atomic_t read_locks;
@@ -164,6 +169,39 @@ struct extent_buffer {
 	struct page **pages;
 };
 
+struct extent_buffer_cache {
+	struct extent_buffer *cached_eb;
+	u64 transid;
+	unsigned chg_seq;
+	unsigned free_seq;
+	spinlock_t lock;
+	bool need_lock;
+};
+
+static inline void btrfs_lock_extent_buffer_cache(
+					struct extent_buffer_cache *cache)
+{
+	if (cache->need_lock)
+		spin_lock(&cache->lock);
+}
+
+static inline void btrfs_unlock_extent_buffer_cache(
+					struct extent_buffer_cache *cache)
+{
+	if (cache->need_lock)
+		spin_unlock(&cache->lock);
+}
+
+static inline void extent_buffer_cache_init(struct extent_buffer_cache *cache)
+{
+	cache->cached_eb = NULL;
+	cache->chg_seq = 0;
+	cache->free_seq = 0;
+	cache->need_lock = 0;
+	cache->transid = 0;
+	spin_lock_init(&cache->lock);
+}
+
 static inline void extent_set_compress_type(unsigned long *bio_flags,
 					    int compress_type)
 {
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 857d93c..699c0f3 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -38,7 +38,7 @@
 
 int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
-			     u64 objectid, u64 pos,
+			     struct inode *inode, u64 pos,
 			     u64 disk_offset, u64 disk_num_bytes,
 			     u64 num_bytes, u64 offset, u64 ram_bytes,
 			     u8 compression, u8 encryption, u16 other_encoding)
@@ -48,6 +48,7 @@ int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
 	struct btrfs_key file_key;
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
+	u64 objectid = btrfs_ino(inode);
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -57,6 +58,7 @@ int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
 	btrfs_set_key_type(&file_key, BTRFS_EXTENT_DATA_KEY);
 
 	path->leave_spinning = 1;
+	btrfs_path_set_eb_cache(root, inode, path);
 	ret = btrfs_insert_empty_item(trans, root, path, &file_key,
 				      sizeof(*item));
 	if (ret < 0)
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 9aa01ec..c14b24a 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -33,7 +33,6 @@
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
-#include "btrfs_inode.h"
 #include "ioctl.h"
 #include "print-tree.h"
 #include "tree-log.h"
@@ -610,8 +609,10 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans, struct inode *inode,
 
 	while (1) {
 		recow = 0;
+		btrfs_path_set_eb_cache(root, inode, path);
 		ret = btrfs_lookup_file_extent(trans, root, path, ino,
 					       search_start, modify_tree);
+		btrfs_path_clear_eb_cache(path);
 		if (ret < 0)
 			break;
 		if (ret > 0 && path->slots[0] > 0 && search_start == start) {
@@ -626,7 +627,9 @@ next_slot:
 		leaf = path->nodes[0];
 		if (path->slots[0] >= btrfs_header_nritems(leaf)) {
 			BUG_ON(del_nr > 0);
+			btrfs_path_set_eb_cache(root, inode, path);
 			ret = btrfs_next_leaf(root, path);
+			btrfs_path_clear_eb_cache(path);
 			if (ret < 0)
 				break;
 			if (ret > 0) {
diff --git a/fs/btrfs/inode-item.c b/fs/btrfs/inode-item.c
index a13cf1a..3b02f80 100644
--- a/fs/btrfs/inode-item.c
+++ b/fs/btrfs/inode-item.c
@@ -80,7 +80,7 @@ btrfs_lookup_inode_ref(struct btrfs_trans_handle *trans,
 int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   const char *name, int name_len,
-			   u64 inode_objectid, u64 ref_objectid, u64 *index)
+			   struct inode *inode, u64 ref_objectid, u64 *index)
 {
 	struct btrfs_path *path;
 	struct btrfs_key key;
@@ -93,7 +93,7 @@ int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
 	int ret;
 	int del_len = name_len + sizeof(*ref);
 
-	key.objectid = inode_objectid;
+	key.objectid = btrfs_ino(inode);
 	key.offset = ref_objectid;
 	btrfs_set_key_type(&key, BTRFS_INODE_REF_KEY);
 
@@ -103,6 +103,7 @@ int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
 
 	path->leave_spinning = 1;
 
+	btrfs_path_set_eb_cache(root, inode, path);
 	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
 	if (ret > 0) {
 		ret = -ENOENT;
@@ -140,7 +141,7 @@ out:
 int btrfs_insert_inode_ref(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   const char *name, int name_len,
-			   u64 inode_objectid, u64 ref_objectid, u64 index)
+			   struct inode *inode, u64 ref_objectid, u64 index)
 {
 	struct btrfs_path *path;
 	struct btrfs_key key;
@@ -149,7 +150,7 @@ int btrfs_insert_inode_ref(struct btrfs_trans_handle *trans,
 	int ret;
 	int ins_len = name_len + sizeof(*ref);
 
-	key.objectid = inode_objectid;
+	key.objectid = btrfs_ino(inode);
 	key.offset = ref_objectid;
 	btrfs_set_key_type(&key, BTRFS_INODE_REF_KEY);
 
@@ -158,6 +159,7 @@ int btrfs_insert_inode_ref(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 
 	path->leave_spinning = 1;
+	btrfs_path_set_eb_cache(root, inode, path);
 	ret = btrfs_insert_empty_item(trans, root, path, &key,
 				      ins_len);
 	if (ret == -EEXIST) {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 6ba80b9..0e27d67 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -43,7 +43,6 @@
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
-#include "btrfs_inode.h"
 #include "ioctl.h"
 #include "print-tree.h"
 #include "ordered-data.h"
@@ -54,6 +53,7 @@
 #include "locking.h"
 #include "free-space-cache.h"
 #include "inode-map.h"
+#include "delayed-inode.h"
 
 struct btrfs_iget_args {
 	u64 ino;
@@ -148,6 +148,7 @@ static noinline int insert_inline_extent(struct btrfs_trans_handle *trans,
 	datasize = btrfs_file_extent_calc_inline_size(cur_size);
 
 	inode_add_bytes(inode, size);
+	btrfs_path_set_eb_cache(root, inode, path);
 	ret = btrfs_insert_empty_item(trans, root, path, &key,
 				      datasize);
 	if (ret) {
@@ -1177,8 +1178,10 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 	cow_start = (u64)-1;
 	cur_offset = start;
 	while (1) {
+		btrfs_path_set_eb_cache(root, inode, path);
 		ret = btrfs_lookup_file_extent(trans, root, path, ino,
 					       cur_offset, 0);
+		btrfs_path_clear_eb_cache(path);
 		if (ret < 0) {
 			btrfs_abort_transaction(trans, root, ret);
 			goto error;
@@ -1195,7 +1198,9 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 next_slot:
 		leaf = path->nodes[0];
 		if (path->slots[0] >= btrfs_header_nritems(leaf)) {
+			btrfs_path_set_eb_cache(root, inode, path);
 			ret = btrfs_next_leaf(root, path);
+			btrfs_path_clear_eb_cache(path);
 			if (ret < 0) {
 				btrfs_abort_transaction(trans, root, ret);
 				goto error;
@@ -1810,6 +1815,7 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	ins.objectid = btrfs_ino(inode);
 	ins.offset = file_pos;
 	ins.type = BTRFS_EXTENT_DATA_KEY;
+	btrfs_path_set_eb_cache(root, inode, path);
 	ret = btrfs_insert_empty_item(trans, root, path, &ins, sizeof(*fi));
 	if (ret)
 		goto out;
@@ -2783,6 +2789,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 	}
 
 	path->leave_spinning = 1;
+	btrfs_path_set_eb_cache(root, dir, path);
 	di = btrfs_lookup_dir_item(trans, root, path, dir_ino,
 				    name, name_len, -1);
 	if (IS_ERR(di)) {
@@ -2800,7 +2807,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 		goto err;
 	btrfs_release_path(path);
 
-	ret = btrfs_del_inode_ref(trans, root, name, name_len, ino,
+	ret = btrfs_del_inode_ref(trans, root, name, name_len, inode,
 				  dir_ino, &index);
 	if (ret) {
 		printk(KERN_INFO "btrfs failed to delete reference to %.*s, "
@@ -3119,8 +3126,10 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
+	btrfs_path_set_eb_cache(root, dir, path);
 	di = btrfs_lookup_dir_item(trans, root, path, dir_ino,
 				   name, name_len, -1);
+	btrfs_path_clear_eb_cache(path);
 	if (IS_ERR_OR_NULL(di)) {
 		if (!di)
 			ret = -ENOENT;
@@ -3265,6 +3274,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 	path->reada = -1;
+	path->leave_spinning = 1;
 
 	if (root->ref_cows || root == root->fs_info->tree_root)
 		btrfs_drop_extent_cache(inode, new_size & (~mask), (u64)-1, 0);
@@ -3282,8 +3292,8 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 	key.offset = (u64)-1;
 	key.type = (u8)-1;
 
+	btrfs_path_set_eb_cache(root, inode, path);
 search_again:
-	path->leave_spinning = 1;
 	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
 	if (ret < 0) {
 		err = ret;
@@ -3631,7 +3641,7 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
 			}
 
 			err = btrfs_insert_file_extent(trans, root,
-					btrfs_ino(inode), cur_offset, 0,
+					inode, cur_offset, 0,
 					0, hole_size, 0, hole_size,
 					0, 0, 0);
 			if (err) {
@@ -3865,6 +3875,7 @@ static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
 	if (!path)
 		return -ENOMEM;
 
+	btrfs_path_set_eb_cache(root, dir, path);
 	di = btrfs_lookup_dir_item(NULL, root, path, btrfs_ino(dir), name,
 				    namelen, 0);
 	if (IS_ERR(di))
@@ -4329,6 +4340,7 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 	key.offset = filp->f_pos;
 	key.objectid = btrfs_ino(inode);
 
+	btrfs_path_set_eb_cache(root, inode, path);
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 	if (ret < 0)
 		goto err;
@@ -4687,6 +4699,7 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	sizes[1] = name_len + sizeof(*ref);
 
 	path->leave_spinning = 1;
+	btrfs_path_set_eb_cache(root, inode, path);
 	ret = btrfs_insert_empty_items(trans, root, path, key, sizes, 2);
 	if (ret != 0)
 		goto fail;
@@ -4776,7 +4789,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 					 key.objectid, root->root_key.objectid,
 					 parent_ino, index, name, name_len);
 	} else if (add_backref) {
-		ret = btrfs_insert_inode_ref(trans, root, name, name_len, ino,
+		ret = btrfs_insert_inode_ref(trans, root, name, name_len, inode,
 					     parent_ino, index);
 	}
 
@@ -4816,7 +4829,7 @@ fail_dir_item:
 		int err;
 
 		err = btrfs_del_inode_ref(trans, root, name, name_len,
-					  ino, parent_ino, &local_index);
+					  inode, parent_ino, &local_index);
 	}
 	return ret;
 }
@@ -5228,6 +5241,7 @@ again:
 		path->reada = 1;
 	}
 
+	btrfs_path_set_eb_cache(root, inode, path);
 	ret = btrfs_lookup_file_extent(trans, root, path,
 				       objectid, start, trans != NULL);
 	if (ret < 0) {
@@ -5698,6 +5712,7 @@ static noinline int can_nocow_odirect(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
+	btrfs_path_set_eb_cache(root, inode, path);
 	ret = btrfs_lookup_file_extent(trans, root, path, btrfs_ino(inode),
 				       offset, 0);
 	if (ret < 0)
@@ -6983,6 +6998,11 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	INIT_LIST_HEAD(&ei->ordered_operations);
 	RB_CLEAR_NODE(&ei->rb_node);
 
+	extent_buffer_cache_init(&ei->fs_eb_cache);
+	extent_buffer_cache_init(&ei->log_eb_cache);
+	ei->fs_eb_cache.need_lock = true;
+	ei->log_eb_cache.need_lock = true;
+
 	return inode;
 }
 
@@ -7048,6 +7068,8 @@ void btrfs_destroy_inode(struct inode *inode)
 	btrfs_drop_extent_cache(inode, 0, (u64)-1, 0);
 free:
 	btrfs_remove_delayed_node(inode);
+	free_extent_buffer(BTRFS_I(inode)->fs_eb_cache.cached_eb);
+	free_extent_buffer(BTRFS_I(inode)->log_eb_cache.cached_eb);
 	call_rcu(&inode->i_rcu, btrfs_i_callback);
 }
 
@@ -7226,7 +7248,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		ret = btrfs_insert_inode_ref(trans, dest,
 					     new_dentry->d_name.name,
 					     new_dentry->d_name.len,
-					     old_ino,
+					     old_inode,
 					     btrfs_ino(new_dir), index);
 		if (ret)
 			goto out_fail;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a1fbca0..e5b1419 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -46,7 +46,6 @@
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
-#include "btrfs_inode.h"
 #include "ioctl.h"
 #include "print-tree.h"
 #include "volumes.h"
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 643335a..f373889 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -22,7 +22,6 @@
 #include <linux/pagevec.h>
 #include "ctree.h"
 #include "transaction.h"
-#include "btrfs_inode.h"
 #include "extent_io.h"
 
 static u64 entry_end(struct btrfs_ordered_extent *entry)
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index c5dbd91..78ff29f 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -27,7 +27,6 @@
 #include "transaction.h"
 #include "volumes.h"
 #include "locking.h"
-#include "btrfs_inode.h"
 #include "async-thread.h"
 #include "free-space-cache.h"
 #include "inode-map.h"
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index bf232c8..74a5081 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -30,7 +30,6 @@
 #include "backref.h"
 #include "locking.h"
 #include "disk-io.h"
-#include "btrfs_inode.h"
 #include "transaction.h"
 
 static int g_verbose = 0;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 073c236..bc0584c 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -46,7 +46,6 @@
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
-#include "btrfs_inode.h"
 #include "ioctl.h"
 #include "print-tree.h"
 #include "xattr.h"
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 3ee8d58..109c26c 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -30,6 +30,7 @@
 #include "tree-log.h"
 #include "inode-map.h"
 #include "volumes.h"
+#include "delayed-inode.h"
 
 #define BTRFS_ROOT_TRANS_TAG 0
 
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index e8b8416..65e2282 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -18,7 +18,6 @@
 
 #ifndef __BTRFS_TRANSACTION__
 #define __BTRFS_TRANSACTION__
-#include "btrfs_inode.h"
 #include "delayed-ref.h"
 #include "ctree.h"
 
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c86670f..d0e608a 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -25,6 +25,7 @@
 #include "print-tree.h"
 #include "compat.h"
 #include "tree-log.h"
+#include "delayed-inode.h"
 
 /* magic values for the inode_only field in btrfs_log_inode:
  *
@@ -2294,6 +2295,7 @@ int btrfs_del_dir_entries_in_log(struct btrfs_trans_handle *trans,
 		goto out_unlock;
 	}
 
+	btrfs_path_set_eb_cache(log, dir, path);
 	di = btrfs_lookup_dir_item(trans, log, path, dir_ino,
 				   name, name_len, -1);
 	if (IS_ERR(di)) {
@@ -2385,7 +2387,7 @@ int btrfs_del_inode_ref_in_log(struct btrfs_trans_handle *trans,
 	log = root->log_root;
 	mutex_lock(&BTRFS_I(inode)->log_mutex);
 
-	ret = btrfs_del_inode_ref(trans, log, name, name_len, btrfs_ino(inode),
+	ret = btrfs_del_inode_ref(trans, log, name, name_len, inode,
 				  dirid, &index);
 	mutex_unlock(&BTRFS_I(inode)->log_mutex);
 	if (ret == -ENOSPC) {
@@ -2868,6 +2870,8 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 		return ret;
 	}
 
+	btrfs_path_set_eb_cache(root, inode, path);
+	btrfs_path_set_eb_cache(log, inode, dst_path);
 	mutex_lock(&BTRFS_I(inode)->log_mutex);
 
 	/*
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 3f4e2d6..3a6547c 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -23,7 +23,6 @@
 #include <linux/xattr.h>
 #include <linux/security.h>
 #include "ctree.h"
-#include "btrfs_inode.h"
 #include "transaction.h"
 #include "xattr.h"
 #include "disk-io.h"
@@ -102,6 +101,7 @@ static int do_setxattr(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
+	btrfs_path_set_eb_cache(root, inode, path);
 	if (flags & XATTR_REPLACE) {
 		di = btrfs_lookup_xattr(trans, root, path, btrfs_ino(inode), name,
 					name_len, -1);
-- 
1.7.10.2

