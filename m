Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:44223 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694Ab2EZK7w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 May 2012 06:59:52 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Subject: [PATCH v2 12/15] Btrfs: add btrfs_search_old_slot
Date: Sat, 26 May 2012 12:59:46 +0200
Message-Id: <d881acc95cc2579d648e30f0c873f4d97e1089cf.1338027552.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
References: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
References: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The tree modification log together with the current state of the tree gives
a consistent, old version of the tree. btrfs_search_old_slot is used to
search through this old version and return old (dummy!) extent buffers.
Naturally, this function cannot do any tree modifications.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/ctree.c |  319 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/ctree.h |    2 +
 2 files changed, 317 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 1edec6f..e23281d 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -964,6 +964,207 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
+/*
+ * returns the logical address of the oldest predecessor of the given root.
+ * entries older than time_seq are ignored.
+ */
+static struct tree_mod_elem *
+__tree_mod_log_oldest_root(struct btrfs_fs_info *fs_info,
+			   struct btrfs_root *root, u64 time_seq)
+{
+	struct tree_mod_elem *tm;
+	struct tree_mod_elem *found = NULL;
+	u64 root_logical = root->node->start;
+	int looped = 0;
+
+	if (!time_seq)
+		return 0;
+
+	/*
+	 * the very last operation that's logged for a root is the replacement
+	 * operation (if it is replaced at all). this has the index of the *new*
+	 * root, making it the very first operation that's logged for this root.
+	 */
+	while (1) {
+		tm = tree_mod_log_search_oldest(fs_info, root_logical,
+						time_seq);
+		if (!looped && !tm)
+			return 0;
+		/*
+		 * we must have key remove operations in the log before the
+		 * replace operation.
+		 */
+		BUG_ON(!tm);
+
+		if (tm->op != MOD_LOG_ROOT_REPLACE)
+			break;
+
+		found = tm;
+		root_logical = tm->old_root.logical;
+		BUG_ON(root_logical == root->node->start);
+		looped = 1;
+	}
+
+	return found;
+}
+
+/*
+ * tm is a pointer to the first operation to rewind within eb. then, all
+ * previous operations will be rewinded (until we reach something older than
+ * time_seq).
+ */
+static void
+__tree_mod_log_rewind(struct extent_buffer *eb, u64 time_seq,
+		      struct tree_mod_elem *first_tm)
+{
+	u32 n;
+	struct rb_node *next;
+	struct tree_mod_elem *tm = first_tm;
+	unsigned long o_dst;
+	unsigned long o_src;
+	unsigned long p_size = sizeof(struct btrfs_key_ptr);
+
+	n = btrfs_header_nritems(eb);
+	while (tm && tm->elem.seq >= time_seq) {
+		/*
+		 * all the operations are recorded with the operator used for
+		 * the modification. as we're going backwards, we do the
+		 * opposite of each operation here.
+		 */
+		switch (tm->op) {
+		case MOD_LOG_KEY_REMOVE_WHILE_FREEING:
+			BUG_ON(tm->slot < n);
+		case MOD_LOG_KEY_REMOVE_WHILE_MOVING:
+		case MOD_LOG_KEY_REMOVE:
+			btrfs_set_node_key(eb, &tm->key, tm->slot);
+			btrfs_set_node_blockptr(eb, tm->slot, tm->blockptr);
+			btrfs_set_node_ptr_generation(eb, tm->slot,
+						      tm->generation);
+			n++;
+			break;
+		case MOD_LOG_KEY_REPLACE:
+			BUG_ON(tm->slot >= n);
+			btrfs_set_node_key(eb, &tm->key, tm->slot);
+			btrfs_set_node_blockptr(eb, tm->slot, tm->blockptr);
+			btrfs_set_node_ptr_generation(eb, tm->slot,
+						      tm->generation);
+			break;
+		case MOD_LOG_KEY_ADD:
+			if (tm->slot != n - 1) {
+				o_dst = btrfs_node_key_ptr_offset(tm->slot);
+				o_src = btrfs_node_key_ptr_offset(tm->slot + 1);
+				memmove_extent_buffer(eb, o_dst, o_src, p_size);
+			}
+			n--;
+			break;
+		case MOD_LOG_MOVE_KEYS:
+			memmove_extent_buffer(eb, tm->slot, tm->move.dst_slot,
+					      tm->move.nr_items * p_size);
+			break;
+		case MOD_LOG_ROOT_REPLACE:
+			/*
+			 * this operation is special. for roots, this must be
+			 * handled explicitly before rewinding.
+			 * for non-roots, this operation may exist if the node
+			 * was a root: root A -> child B; then A gets empty and
+			 * B is promoted to the new root. in the mod log, we'll
+			 * have a root-replace operation for B, a tree block
+			 * that is no root. we simply ignore that operation.
+			 */
+			break;
+		}
+		next = rb_next(&tm->node);
+		if (!next)
+			break;
+		tm = container_of(next, struct tree_mod_elem, node);
+		if (tm->index != first_tm->index)
+			break;
+	}
+	btrfs_set_header_nritems(eb, n);
+}
+
+static struct extent_buffer *
+tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
+		    u64 time_seq)
+{
+	struct extent_buffer *eb_rewin;
+	struct tree_mod_elem *tm;
+
+	if (!time_seq)
+		return eb;
+
+	if (btrfs_header_level(eb) == 0)
+		return eb;
+
+	tm = tree_mod_log_search(fs_info, eb->start, time_seq);
+	if (!tm)
+		return eb;
+
+	if (tm->op == MOD_LOG_KEY_REMOVE_WHILE_FREEING) {
+		BUG_ON(tm->slot != 0);
+		eb_rewin = alloc_dummy_extent_buffer(eb->start,
+						fs_info->tree_root->nodesize);
+		BUG_ON(!eb_rewin);
+		btrfs_set_header_bytenr(eb_rewin, eb->start);
+		btrfs_set_header_backref_rev(eb_rewin,
+					     btrfs_header_backref_rev(eb));
+		btrfs_set_header_owner(eb_rewin, btrfs_header_owner(eb));
+	} else {
+		eb_rewin = btrfs_clone_extent_buffer(eb);
+		BUG_ON(!eb_rewin);
+	}
+
+	extent_buffer_get(eb_rewin);
+	free_extent_buffer(eb);
+
+	__tree_mod_log_rewind(eb_rewin, time_seq, tm);
+
+	return eb_rewin;
+}
+
+static inline struct extent_buffer *
+get_old_root(struct btrfs_root *root, u64 time_seq)
+{
+	struct tree_mod_elem *tm;
+	struct extent_buffer *eb;
+	struct tree_mod_root *old_root;
+	u64 old_generation;
+
+	tm = __tree_mod_log_oldest_root(root->fs_info, root, time_seq);
+	if (!tm)
+		return root->node;
+
+	old_root = &tm->old_root;
+	old_generation = tm->generation;
+
+	tm = tree_mod_log_search(root->fs_info, old_root->logical, time_seq);
+	/*
+	 * there was an item in the log when __tree_mod_log_oldest_root
+	 * returned. this one must not go away, because the time_seq passed to
+	 * us must be blocking its removal.
+	 */
+	BUG_ON(!tm);
+
+	if (old_root->logical == root->node->start) {
+		/* there are logged operations for the current root */
+		eb = btrfs_clone_extent_buffer(root->node);
+	} else {
+		/* there's a root replace operation for the current root */
+		eb = alloc_dummy_extent_buffer(tm->index << PAGE_CACHE_SHIFT,
+					       root->nodesize);
+		btrfs_set_header_bytenr(eb, eb->start);
+		btrfs_set_header_backref_rev(eb, BTRFS_MIXED_BACKREF_REV);
+		btrfs_set_header_owner(eb, root->root_key.objectid);
+	}
+	if (!eb)
+		return NULL;
+	btrfs_set_header_level(eb, old_root->level);
+	btrfs_set_header_generation(eb, old_generation);
+	__tree_mod_log_rewind(eb, time_seq, tm);
+
+	return eb;
+}
+
 static inline int should_cow_block(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root,
 				   struct extent_buffer *buf)
@@ -1934,7 +2135,7 @@ static int
 read_block_for_search(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root, struct btrfs_path *p,
 		       struct extent_buffer **eb_ret, int level, int slot,
-		       struct btrfs_key *key)
+		       struct btrfs_key *key, u64 time_seq)
 {
 	u64 blocknr;
 	u64 gen;
@@ -2288,7 +2489,7 @@ cow_done:
 			}
 
 			err = read_block_for_search(trans, root, p,
-						    &b, level, slot, key);
+						    &b, level, slot, key, 0);
 			if (err == -EAGAIN)
 				goto again;
 			if (err) {
@@ -2360,6 +2561,116 @@ done:
 }
 
 /*
+ * Like btrfs_search_slot, this looks for a key in the given tree. It uses the
+ * current state of the tree together with the operations recorded in the tree
+ * modification log to search for the key in a previous version of this tree, as
+ * denoted by the time_seq parameter.
+ *
+ * Naturally, there is no support for insert, delete or cow operations.
+ *
+ * The resulting path and return value will be set up as if we called
+ * btrfs_search_slot at that point in time with ins_len and cow both set to 0.
+ */
+int btrfs_search_old_slot(struct btrfs_root *root, struct btrfs_key *key,
+			  struct btrfs_path *p, u64 time_seq)
+{
+	struct extent_buffer *b;
+	int slot;
+	int ret;
+	int err;
+	int level;
+	int lowest_unlock = 1;
+	u8 lowest_level = 0;
+
+	lowest_level = p->lowest_level;
+	WARN_ON(p->nodes[0] != NULL);
+
+	if (p->search_commit_root) {
+		BUG_ON(time_seq);
+		return btrfs_search_slot(NULL, root, key, p, 0, 0);
+	}
+
+again:
+	level = 0;
+	b = get_old_root(root, time_seq);
+	extent_buffer_get(b);
+	level = btrfs_header_level(b);
+	btrfs_tree_read_lock(b);
+	p->locks[level] = BTRFS_READ_LOCK;
+
+	while (b) {
+		level = btrfs_header_level(b);
+		p->nodes[level] = b;
+		btrfs_clear_path_blocking(p, NULL, 0);
+
+		/*
+		 * we have a lock on b and as long as we aren't changing
+		 * the tree, there is no way to for the items in b to change.
+		 * It is safe to drop the lock on our parent before we
+		 * go through the expensive btree search on b.
+		 */
+		btrfs_unlock_up_safe(p, level + 1);
+
+		ret = bin_search(b, key, level, &slot);
+
+		if (level != 0) {
+			int dec = 0;
+			if (ret && slot > 0) {
+				dec = 1;
+				slot -= 1;
+			}
+			p->slots[level] = slot;
+			unlock_up(p, level, lowest_unlock, 0, NULL);
+
+			if (level == lowest_level) {
+				if (dec)
+					p->slots[level]++;
+				goto done;
+			}
+
+			err = read_block_for_search(NULL, root, p, &b, level,
+						    slot, key, time_seq);
+			if (err == -EAGAIN)
+				goto again;
+			if (err) {
+				ret = err;
+				goto done;
+			}
+
+			level = btrfs_header_level(b);
+			err = btrfs_try_tree_read_lock(b);
+			if (!err) {
+				btrfs_set_path_blocking(p);
+				btrfs_tree_read_lock(b);
+				btrfs_clear_path_blocking(p, b,
+							  BTRFS_READ_LOCK);
+			}
+			p->locks[level] = BTRFS_READ_LOCK;
+			p->nodes[level] = b;
+			b = tree_mod_log_rewind(root->fs_info, b, time_seq);
+			if (b != p->nodes[level]) {
+				btrfs_tree_unlock_rw(p->nodes[level],
+						     p->locks[level]);
+				p->locks[level] = 0;
+				p->nodes[level] = b;
+			}
+		} else {
+			p->slots[level] = slot;
+			unlock_up(p, level, lowest_unlock, 0, NULL);
+			goto done;
+		}
+	}
+	ret = 1;
+done:
+	if (!p->leave_spinning)
+		btrfs_set_path_blocking(p);
+	if (ret < 0)
+		btrfs_release_path(p);
+
+	return ret;
+}
+
+/*
  * adjust the pointers going up the tree, starting at level
  * making sure the right key of each node is points to 'key'.
  * This is used after shifting pointers to the left, so it stops
@@ -4739,7 +5050,7 @@ again:
 		next = c;
 		next_rw_lock = path->locks[level];
 		ret = read_block_for_search(NULL, root, path, &next, level,
-					    slot, &key);
+					    slot, &key, 0);
 		if (ret == -EAGAIN)
 			goto again;
 
@@ -4776,7 +5087,7 @@ again:
 			break;
 
 		ret = read_block_for_search(NULL, root, path, &next, level,
-					    0, &key);
+					    0, &key, 0);
 		if (ret == -EAGAIN)
 			goto again;
 
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e53bfb9..6ba21b1 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2668,6 +2668,8 @@ int btrfs_duplicate_item(struct btrfs_trans_handle *trans,
 int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, struct btrfs_key *key, struct btrfs_path *p, int
 		      ins_len, int cow);
+int btrfs_search_old_slot(struct btrfs_root *root, struct btrfs_key *key,
+			  struct btrfs_path *p, u64 time_seq);
 int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root, struct extent_buffer *parent,
 		       int start_slot, int cache_only, u64 *last_ret,
-- 
1.7.3.4

