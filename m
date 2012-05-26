Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:56280 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651Ab2EZK7v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 May 2012 06:59:51 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Subject: [PATCH v2 09/15] Btrfs: add tree modification log functions
Date: Sat, 26 May 2012 12:59:43 +0200
Message-Id: <6cab54bb3633c4cfeb5127d1272c26c5b7d723af.1338027552.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
References: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
References: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The tree mod log will log modifications made fs-tree nodes. Most
modifications are done by autobalance of the tree. Such changes are recorded
as long as a block entry exists. When released, the log is cleaned.

With the tree modification log, it's possible to reconstruct a consistent
old state of the tree. This is required to do backref walking on a busy
file system.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/ctree.c |  409 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/ctree.h |    5 +
 2 files changed, 413 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 56485b3..6a7418d 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -18,6 +18,7 @@
 
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/rbtree.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
@@ -288,6 +289,413 @@ int btrfs_copy_root(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
+enum mod_log_op {
+	MOD_LOG_KEY_REPLACE,
+	MOD_LOG_KEY_ADD,
+	MOD_LOG_KEY_REMOVE,
+	MOD_LOG_KEY_REMOVE_WHILE_FREEING,
+	MOD_LOG_KEY_REMOVE_WHILE_MOVING,
+	MOD_LOG_MOVE_KEYS,
+	MOD_LOG_ROOT_REPLACE,
+};
+
+struct tree_mod_move {
+	int dst_slot;
+	int nr_items;
+};
+
+struct tree_mod_root {
+	u64 logical;
+	u8 level;
+};
+
+struct tree_mod_elem {
+	struct rb_node node;
+	u64 index;		/* shifted logical */
+	struct seq_list elem;
+	enum mod_log_op op;
+
+	/* this is used for MOD_LOG_KEY_* and MOD_LOG_MOVE_KEYS operations */
+	int slot;
+
+	/* this is used for MOD_LOG_KEY* and MOD_LOG_ROOT_REPLACE */
+	u64 generation;
+
+	/* those are used for op == MOD_LOG_KEY_{REPLACE,REMOVE} */
+	struct btrfs_disk_key key;
+	u64 blockptr;
+
+	/* this is used for op == MOD_LOG_MOVE_KEYS */
+	struct tree_mod_move move;
+
+	/* this is used for op == MOD_LOG_ROOT_REPLACE */
+	struct tree_mod_root old_root;
+};
+
+static inline void
+__get_tree_mod_seq(struct btrfs_fs_info *fs_info, struct seq_list *elem)
+{
+	elem->seq = atomic_inc_return(&fs_info->tree_mod_seq);
+	list_add_tail(&elem->list, &fs_info->tree_mod_seq_list);
+}
+
+void btrfs_get_tree_mod_seq(struct btrfs_fs_info *fs_info,
+			    struct seq_list *elem)
+{
+	elem->flags = 1;
+	spin_lock(&fs_info->tree_mod_seq_lock);
+	__get_tree_mod_seq(fs_info, elem);
+	spin_unlock(&fs_info->tree_mod_seq_lock);
+}
+
+void btrfs_put_tree_mod_seq(struct btrfs_fs_info *fs_info,
+			    struct seq_list *elem)
+{
+	struct rb_root *tm_root;
+	struct rb_node *node;
+	struct rb_node *next;
+	struct seq_list *cur_elem;
+	struct tree_mod_elem *tm;
+	u64 min_seq = (u64)-1;
+	u64 seq_putting = elem->seq;
+
+	if (!seq_putting)
+		return;
+
+	BUG_ON(!(elem->flags & 1));
+	spin_lock(&fs_info->tree_mod_seq_lock);
+	list_del(&elem->list);
+
+	list_for_each_entry(cur_elem, &fs_info->tree_mod_seq_list, list) {
+		if ((cur_elem->flags & 1) && cur_elem->seq < min_seq) {
+			if (seq_putting > cur_elem->seq) {
+				/*
+				 * blocker with lower sequence number exists, we
+				 * cannot remove anything from the log
+				 */
+				goto out;
+			}
+			min_seq = cur_elem->seq;
+		}
+	}
+
+	/*
+	 * anything that's lower than the lowest existing (read: blocked)
+	 * sequence number can be removed from the tree.
+	 */
+	write_lock(&fs_info->tree_mod_log_lock);
+	tm_root = &fs_info->tree_mod_log;
+	for (node = rb_first(tm_root); node; node = next) {
+		next = rb_next(node);
+		tm = container_of(node, struct tree_mod_elem, node);
+		if (tm->elem.seq > min_seq)
+			continue;
+		rb_erase(node, tm_root);
+		list_del(&tm->elem.list);
+		kfree(tm);
+	}
+	write_unlock(&fs_info->tree_mod_log_lock);
+out:
+	spin_unlock(&fs_info->tree_mod_seq_lock);
+}
+
+/*
+ * key order of the log:
+ *       index -> sequence
+ *
+ * the index is the shifted logical of the *new* root node for root replace
+ * operations, or the shifted logical of the affected block for all other
+ * operations.
+ */
+static noinline int
+__tree_mod_log_insert(struct btrfs_fs_info *fs_info, struct tree_mod_elem *tm)
+{
+	struct rb_root *tm_root;
+	struct rb_node **new;
+	struct rb_node *parent = NULL;
+	struct tree_mod_elem *cur;
+	int ret = 0;
+
+	BUG_ON(!tm || !tm->elem.seq);
+
+	write_lock(&fs_info->tree_mod_log_lock);
+	tm_root = &fs_info->tree_mod_log;
+	new = &tm_root->rb_node;
+	while (*new) {
+		cur = container_of(*new, struct tree_mod_elem, node);
+		parent = *new;
+		if (cur->index < tm->index)
+			new = &((*new)->rb_left);
+		else if (cur->index > tm->index)
+			new = &((*new)->rb_right);
+		else if (cur->elem.seq < tm->elem.seq)
+			new = &((*new)->rb_left);
+		else if (cur->elem.seq > tm->elem.seq)
+			new = &((*new)->rb_right);
+		else {
+			kfree(tm);
+			ret = -EEXIST;
+			goto unlock;
+		}
+	}
+
+	rb_link_node(&tm->node, parent, new);
+	rb_insert_color(&tm->node, tm_root);
+unlock:
+	write_unlock(&fs_info->tree_mod_log_lock);
+	return ret;
+}
+
+int tree_mod_alloc(struct btrfs_fs_info *fs_info, gfp_t flags,
+		   struct tree_mod_elem **tm_ret)
+{
+	struct tree_mod_elem *tm;
+	u64 seq = 0;
+
+	/*
+	 * we want to avoid a malloc/free cycle if there's no blocker in the
+	 * list.
+	 * we also want to avoid atomic malloc. so we must drop the spinlock
+	 * before calling kzalloc and recheck afterwards.
+	 */
+	spin_lock(&fs_info->tree_mod_seq_lock);
+	if (list_empty(&fs_info->tree_mod_seq_list))
+		goto out;
+
+	spin_unlock(&fs_info->tree_mod_seq_lock);
+	tm = *tm_ret = kzalloc(sizeof(*tm), flags);
+	if (!tm)
+		return -ENOMEM;
+
+	spin_lock(&fs_info->tree_mod_seq_lock);
+	if (list_empty(&fs_info->tree_mod_seq_list)) {
+		kfree(tm);
+		goto out;
+	}
+
+	__get_tree_mod_seq(fs_info, &tm->elem);
+	seq = tm->elem.seq;
+	tm->elem.flags = 0;
+
+out:
+	spin_unlock(&fs_info->tree_mod_seq_lock);
+	return seq;
+}
+
+static noinline int
+tree_mod_log_insert_key_mask(struct btrfs_fs_info *fs_info,
+			     struct extent_buffer *eb, int slot,
+			     enum mod_log_op op, gfp_t flags)
+{
+	struct tree_mod_elem *tm;
+	int ret;
+
+	ret = tree_mod_alloc(fs_info, flags, &tm);
+	if (ret <= 0)
+		return ret;
+
+	tm->index = eb->start >> PAGE_CACHE_SHIFT;
+	if (op != MOD_LOG_KEY_ADD) {
+		btrfs_node_key(eb, &tm->key, slot);
+		tm->blockptr = btrfs_node_blockptr(eb, slot);
+	}
+	tm->op = op;
+	tm->slot = slot;
+	tm->generation = btrfs_node_ptr_generation(eb, slot);
+
+	return __tree_mod_log_insert(fs_info, tm);
+}
+
+static noinline int
+tree_mod_log_insert_key(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
+			int slot, enum mod_log_op op)
+{
+	return tree_mod_log_insert_key_mask(fs_info, eb, slot, op, GFP_NOFS);
+}
+
+static noinline int
+tree_mod_log_insert_move(struct btrfs_fs_info *fs_info,
+			 struct extent_buffer *eb, int dst_slot, int src_slot,
+			 int nr_items, gfp_t flags)
+{
+	struct tree_mod_elem *tm;
+	int ret;
+	int i;
+
+	ret = tree_mod_alloc(fs_info, flags, &tm);
+	if (ret <= 0)
+		return ret;
+
+	for (i = 0; i + dst_slot < src_slot && i < nr_items; i++) {
+		ret = tree_mod_log_insert_key(fs_info, eb, i + dst_slot,
+					      MOD_LOG_KEY_REMOVE_WHILE_MOVING);
+		BUG_ON(ret < 0);
+	}
+
+	tm->index = eb->start >> PAGE_CACHE_SHIFT;
+	tm->slot = src_slot;
+	tm->move.dst_slot = dst_slot;
+	tm->move.nr_items = nr_items;
+	tm->op = MOD_LOG_MOVE_KEYS;
+
+	return __tree_mod_log_insert(fs_info, tm);
+}
+
+static noinline int
+tree_mod_log_insert_root(struct btrfs_fs_info *fs_info,
+			 struct extent_buffer *old_root,
+			 struct extent_buffer *new_root, gfp_t flags)
+{
+	struct tree_mod_elem *tm;
+	int ret;
+
+	ret = tree_mod_alloc(fs_info, flags, &tm);
+	if (ret <= 0)
+		return ret;
+
+	tm->index = new_root->start >> PAGE_CACHE_SHIFT;
+	tm->old_root.logical = old_root->start;
+	tm->old_root.level = btrfs_header_level(old_root);
+	tm->generation = btrfs_header_generation(old_root);
+	tm->op = MOD_LOG_ROOT_REPLACE;
+
+	return __tree_mod_log_insert(fs_info, tm);
+}
+
+static struct tree_mod_elem *
+__tree_mod_log_search(struct btrfs_fs_info *fs_info, u64 start, u64 min_seq,
+		      int smallest)
+{
+	struct rb_root *tm_root;
+	struct rb_node *node;
+	struct tree_mod_elem *cur = NULL;
+	struct tree_mod_elem *found = NULL;
+	u64 index = start >> PAGE_CACHE_SHIFT;
+
+	read_lock(&fs_info->tree_mod_log_lock);
+	tm_root = &fs_info->tree_mod_log;
+	node = tm_root->rb_node;
+	while (node) {
+		cur = container_of(node, struct tree_mod_elem, node);
+		if (cur->index < index) {
+			node = node->rb_left;
+		} else if (cur->index > index) {
+			node = node->rb_right;
+		} else if (cur->elem.seq < min_seq) {
+			node = node->rb_left;
+		} else if (!smallest) {
+			/* we want the node with the highest seq */
+			if (found)
+				BUG_ON(found->elem.seq > cur->elem.seq);
+			found = cur;
+			node = node->rb_left;
+		} else if (cur->elem.seq > min_seq) {
+			/* we want the node with the smallest seq */
+			if (found)
+				BUG_ON(found->elem.seq < cur->elem.seq);
+			found = cur;
+			node = node->rb_right;
+		} else {
+			found = cur;
+			break;
+		}
+	}
+	read_unlock(&fs_info->tree_mod_log_lock);
+
+	return found;
+}
+
+/*
+ * this returns the element from the log with the smallest time sequence
+ * value that's in the log (the oldest log item). any element with a time
+ * sequence lower than min_seq will be ignored.
+ */
+static struct tree_mod_elem *
+tree_mod_log_search_oldest(struct btrfs_fs_info *fs_info, u64 start,
+			   u64 min_seq)
+{
+	return __tree_mod_log_search(fs_info, start, min_seq, 1);
+}
+
+/*
+ * this returns the element from the log with the largest time sequence
+ * value that's in the log (the most recent log item). any element with
+ * a time sequence lower than min_seq will be ignored.
+ */
+static struct tree_mod_elem *
+tree_mod_log_search(struct btrfs_fs_info *fs_info, u64 start, u64 min_seq)
+{
+	return __tree_mod_log_search(fs_info, start, min_seq, 0);
+}
+
+static inline void
+tree_mod_log_eb_copy(struct btrfs_fs_info *fs_info, struct extent_buffer *dst,
+		     struct extent_buffer *src, unsigned long dst_offset,
+		     unsigned long src_offset, int nr_items)
+{
+	int ret;
+	int i;
+
+	/* speed this up by single seq for all operations? */
+	for (i = 0; i < nr_items; i++) {
+		ret = tree_mod_log_insert_key(fs_info, src, i + src_offset,
+					      MOD_LOG_KEY_REMOVE);
+		BUG_ON(ret < 0);
+		ret = tree_mod_log_insert_key(fs_info, dst, i + dst_offset,
+					      MOD_LOG_KEY_ADD);
+		BUG_ON(ret < 0);
+	}
+}
+
+static inline void
+tree_mod_log_eb_move(struct btrfs_fs_info *fs_info, struct extent_buffer *dst,
+		     int dst_offset, int src_offset, int nr_items)
+{
+	int ret;
+	ret = tree_mod_log_insert_move(fs_info, dst, dst_offset, src_offset,
+				       nr_items, GFP_NOFS);
+	BUG_ON(ret < 0);
+}
+
+static inline void
+tree_mod_log_set_node_key(struct btrfs_fs_info *fs_info,
+			  struct extent_buffer *eb,
+			  struct btrfs_disk_key *disk_key, int slot, int atomic)
+{
+	int ret;
+
+	ret = tree_mod_log_insert_key_mask(fs_info, eb, slot,
+					   MOD_LOG_KEY_REPLACE,
+					   atomic ? GFP_ATOMIC : GFP_NOFS);
+	BUG_ON(ret < 0);
+}
+
+static void tree_mod_log_free_eb(struct btrfs_fs_info *fs_info,
+				 struct extent_buffer *eb)
+{
+	int i;
+	int ret;
+	u32 nritems;
+
+	nritems = btrfs_header_nritems(eb);
+	for (i = nritems - 1; i >= 0; i--) {
+		ret = tree_mod_log_insert_key(fs_info, eb, i,
+					      MOD_LOG_KEY_REMOVE_WHILE_FREEING);
+		BUG_ON(ret < 0);
+	}
+}
+
+static inline void
+tree_mod_log_set_root_pointer(struct btrfs_root *root,
+			      struct extent_buffer *new_root_node)
+{
+	int ret;
+	tree_mod_log_free_eb(root->fs_info, root->node);
+	ret = tree_mod_log_insert_root(root->fs_info, root->node,
+				       new_root_node, GFP_NOFS);
+	BUG_ON(ret < 0);
+}
+
 /*
  * check if the tree block can be shared by multiple trees
  */
@@ -2271,7 +2679,6 @@ static noinline int split_node(struct btrfs_trans_handle *trans,
 			    (unsigned long)btrfs_header_chunk_tree_uuid(split),
 			    BTRFS_UUID_SIZE);
 
-
 	copy_extent_buffer(split, c,
 			   btrfs_node_key_ptr_offset(0),
 			   btrfs_node_key_ptr_offset(mid),
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 01639e1..e53bfb9 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3114,4 +3114,9 @@ struct seq_list {
 	u32 flags;
 };
 
+void btrfs_get_tree_mod_seq(struct btrfs_fs_info *fs_info,
+			    struct seq_list *elem);
+void btrfs_put_tree_mod_seq(struct btrfs_fs_info *fs_info,
+			    struct seq_list *elem);
+
 #endif
-- 
1.7.3.4

