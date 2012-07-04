Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38056 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704Ab2GDNi7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jul 2012 09:38:59 -0400
Received: by mail-bk0-f46.google.com with SMTP id j10so2632560bkw.19
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Jul 2012 06:38:58 -0700 (PDT)
From: Alexander Block <ablock84@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Alexander Block <ablock84@googlemail.com>
Subject: [RFC PATCH 5/7] Btrfs: add btrfs_compare_trees function
Date: Wed,  4 Jul 2012 15:38:26 +0200
Message-Id: <1341409108-13567-6-git-send-email-ablock84@googlemail.com>
In-Reply-To: <1341409108-13567-1-git-send-email-ablock84@googlemail.com>
References: <1341409108-13567-1-git-send-email-ablock84@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is used to find the differences between
two trees. The tree compare skips whole subtrees if it
detects shared tree blocks and thus is pretty fast.

Signed-off-by: Alexander Block <ablock84@googlemail.com>
---
 fs/btrfs/ctree.c |  425 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ctree.h |   15 ++
 2 files changed, 440 insertions(+)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 33c8a03..d1c7efd 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -5007,6 +5007,431 @@ out:
 	return ret;
 }
 
+static void tree_move_down(struct btrfs_root *root,
+			   struct btrfs_path *path,
+			   int *level, int root_level)
+{
+	path->nodes[*level - 1] = read_node_slot(root, path->nodes[*level],
+					path->slots[*level]);
+	path->slots[*level - 1] = 0;
+	(*level)--;
+}
+
+static int tree_move_next_or_upnext(struct btrfs_root *root,
+				    struct btrfs_path *path,
+				    int *level, int root_level)
+{
+	int ret = 0;
+	int nritems;
+	nritems = btrfs_header_nritems(path->nodes[*level]);
+
+	path->slots[*level]++;
+
+	while (path->slots[*level] == nritems) {
+		if (*level == root_level)
+			return -1;
+
+		/* move upnext */
+		path->slots[*level] = 0;
+		free_extent_buffer(path->nodes[*level]);
+		path->nodes[*level] = NULL;
+		(*level)++;
+		path->slots[*level]++;
+
+		nritems = btrfs_header_nritems(path->nodes[*level]);
+		ret = 1;
+	}
+	return ret;
+}
+
+/*
+ * Returns 1 if it had to move up and next. 0 is returned if it moved only next
+ * or down.
+ */
+static int tree_advance(struct btrfs_root *root,
+			struct btrfs_path *path,
+			int *level, int root_level,
+			int allow_down,
+			struct btrfs_key *key)
+{
+	int ret;
+
+	if (*level == 0 || !allow_down) {
+		ret = tree_move_next_or_upnext(root, path, level, root_level);
+	} else {
+		tree_move_down(root, path, level, root_level);
+		ret = 0;
+	}
+	if (ret >= 0) {
+		if (*level == 0)
+			btrfs_item_key_to_cpu(path->nodes[*level], key,
+					path->slots[*level]);
+		else
+			btrfs_node_key_to_cpu(path->nodes[*level], key,
+					path->slots[*level]);
+	}
+	return ret;
+}
+
+static int tree_compare_item(struct btrfs_root *left_root,
+			     struct btrfs_path *left_path,
+			     struct btrfs_path *right_path,
+			     char *tmp_buf)
+{
+	int cmp;
+	int len1, len2;
+	unsigned long off1, off2;
+
+	len1 = btrfs_item_size_nr(left_path->nodes[0], left_path->slots[0]);
+	len2 = btrfs_item_size_nr(right_path->nodes[0], right_path->slots[0]);
+	if (len1 != len2)
+		return 1;
+
+	off1 = btrfs_item_ptr_offset(left_path->nodes[0], left_path->slots[0]);
+	off2 = btrfs_item_ptr_offset(right_path->nodes[0],
+				right_path->slots[0]);
+
+	read_extent_buffer(left_path->nodes[0], tmp_buf, off1, len1);
+
+	cmp = memcmp_extent_buffer(right_path->nodes[0], tmp_buf, off2, len1);
+	if (cmp)
+		return 1;
+	return 0;
+}
+
+#define ADVANCE 1
+#define ADVANCE_ONLY_NEXT -1
+
+/*
+ * This function compares two trees and calls the provided callback for
+ * every changed/new/deleted item it finds.
+ * If shared tree blocks are encountered, whole subtrees are skipped, making
+ * the compare pretty fast on snapshotted subvolumes.
+ *
+ * This currently works on commit roots only. As commit roots are read only,
+ * we don't do any locking. The commit roots are protected with transactions.
+ * Transactions are ended and rejoined when a commit is tried in between.
+ *
+ * This function checks for modifications done to the trees while comparing.
+ * If it detects a change, it aborts immediately.
+ */
+int btrfs_compare_trees(struct btrfs_root *left_root,
+			struct btrfs_root *right_root,
+			btrfs_changed_cb_t changed_cb, void *ctx)
+{
+	int ret;
+	int cmp;
+	struct btrfs_trans_handle *trans = NULL;
+	struct btrfs_path *left_path = NULL;
+	struct btrfs_path *right_path = NULL;
+	struct btrfs_key left_key;
+	struct btrfs_key right_key;
+	char *tmp_buf = NULL;
+	int left_root_level;
+	int right_root_level;
+	int left_level;
+	int right_level;
+	int left_end_reached;
+	int right_end_reached;
+	int advance_left;
+	int advance_right;
+	u64 left_blockptr;
+	u64 right_blockptr;
+	u64 left_start_ctransid;
+	u64 right_start_ctransid;
+	u64 ctransid;
+
+	left_path = btrfs_alloc_path();
+	if (!left_path) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	right_path = btrfs_alloc_path();
+	if (!right_path) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	tmp_buf = kmalloc(left_root->leafsize, GFP_NOFS);
+	if (!tmp_buf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	left_path->search_commit_root = 1;
+	left_path->skip_locking = 1;
+	right_path->search_commit_root = 1;
+	right_path->skip_locking = 1;
+
+	spin_lock(&left_root->root_times_lock);
+	left_start_ctransid = btrfs_root_ctransid(&left_root->root_item);
+	spin_unlock(&left_root->root_times_lock);
+
+	spin_lock(&right_root->root_times_lock);
+	right_start_ctransid = btrfs_root_ctransid(&right_root->root_item);
+	spin_unlock(&right_root->root_times_lock);
+
+	trans = btrfs_join_transaction(left_root);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		trans = NULL;
+		goto out;
+	}
+
+	/*
+	 * Strategy: Go to the first items of both trees. Then do
+	 *
+	 * If both trees are at level 0
+	 *   Compare keys of current items
+	 *     If left < right treat left item as new, advance left tree
+	 *       and repeat
+	 *     If left > right treat right item as deleted, advance right tree
+	 *       and repeat
+	 *     If left == right do deep compare of items, treat as changed if
+	 *       needed, advance both trees and repeat
+	 * If both trees are at the same level but not at level 0
+	 *   Compare keys of current nodes/leafs
+	 *     If left < right advance left tree and repeat
+	 *     If left > right advance right tree and repeat
+	 *     If left == right compare blockptrs of the next nodes/leafs
+	 *       If they match advance both trees but stay at the same level
+	 *         and repeat
+	 *       If they don't match advance both trees while allowing to go
+	 *         deeper and repeat
+	 * If tree levels are different
+	 *   Advance the tree that needs it and repeat
+	 *
+	 * Advancing a tree means:
+	 *   If we are at level 0, try to go to the next slot. If that's not
+	 *   possible, go one level up and repeat. Stop when we found a level
+	 *   where we could go to the next slot. We may at this point be on a
+	 *   node or a leaf.
+	 *
+	 *   If we are not at level 0 and not on shared tree blocks, go one
+	 *   level deeper.
+	 *
+	 *   If we are not at level 0 and on shared tree blocks, go one slot to
+	 *   the right if possible or go up and right.
+	 */
+
+	left_level = btrfs_header_level(left_root->commit_root);
+	left_root_level = left_level;
+	left_path->nodes[left_level] = left_root->commit_root;
+	extent_buffer_get(left_path->nodes[left_level]);
+
+	right_level = btrfs_header_level(right_root->commit_root);
+	right_root_level = right_level;
+	right_path->nodes[right_level] = right_root->commit_root;
+	extent_buffer_get(right_path->nodes[right_level]);
+
+	if (left_level == 0)
+		btrfs_item_key_to_cpu(left_path->nodes[left_level],
+				&left_key, left_path->slots[left_level]);
+	else
+		btrfs_node_key_to_cpu(left_path->nodes[left_level],
+				&left_key, left_path->slots[left_level]);
+	if (right_level == 0)
+		btrfs_item_key_to_cpu(right_path->nodes[right_level],
+				&right_key, right_path->slots[right_level]);
+	else
+		btrfs_node_key_to_cpu(right_path->nodes[right_level],
+				&right_key, right_path->slots[right_level]);
+
+	left_end_reached = right_end_reached = 0;
+	advance_left = advance_right = 0;
+
+	while (1) {
+		/*
+		 * We need to make sure the transaction does not get committed
+		 * while we do anything on commit roots. This means, we need to
+		 * join and leave transactions for every item that we process.
+		 */
+		if (trans && btrfs_should_end_transaction(trans, left_root)) {
+			btrfs_release_path(left_path);
+			btrfs_release_path(right_path);
+
+			ret = btrfs_end_transaction(trans, left_root);
+			trans = NULL;
+			if (ret < 0)
+				goto out;
+		}
+		/* now rejoin the transaction */
+		if (!trans) {
+			trans = btrfs_join_transaction(left_root);
+			if (IS_ERR(trans)) {
+				ret = PTR_ERR(trans);
+				trans = NULL;
+				goto out;
+			}
+
+			spin_lock(&left_root->root_times_lock);
+			ctransid = btrfs_root_ctransid(&left_root->root_item);
+			spin_unlock(&left_root->root_times_lock);
+			if (ctransid != left_start_ctransid)
+				left_start_ctransid = 0;
+
+			spin_lock(&right_root->root_times_lock);
+			ctransid = btrfs_root_ctransid(&right_root->root_item);
+			spin_unlock(&right_root->root_times_lock);
+			if (ctransid != right_start_ctransid)
+				left_start_ctransid = 0;
+
+			if (!left_start_ctransid || !right_start_ctransid) {
+				WARN(1, KERN_WARNING
+					"btrfs: btrfs_compare_tree detected "
+					"a change in one of the trees while "
+					"iterating. This is probably a "
+					"bug.\n");
+				ret = -EIO;
+				goto out;
+			}
+
+			/*
+			 * the commit root may have changed, so start again
+			 * where we stopped
+			 */
+			left_path->lowest_level = left_level;
+			right_path->lowest_level = right_level;
+			ret = btrfs_search_slot(NULL, left_root,
+					&left_key, left_path, 0, 0);
+			if (ret < 0)
+				goto out;
+			ret = btrfs_search_slot(NULL, right_root,
+					&right_key, right_path, 0, 0);
+			if (ret < 0)
+				goto out;
+		}
+
+		if (advance_left && !left_end_reached) {
+			ret = tree_advance(left_root, left_path, &left_level,
+					left_root_level,
+					advance_left != ADVANCE_ONLY_NEXT,
+					&left_key);
+			if (ret < 0)
+				left_end_reached = ADVANCE;
+			advance_left = 0;
+		}
+		if (advance_right && !right_end_reached) {
+			ret = tree_advance(right_root, right_path, &right_level,
+					right_root_level,
+					advance_right != ADVANCE_ONLY_NEXT,
+					&right_key);
+			if (ret < 0)
+				right_end_reached = ADVANCE;
+			advance_right = 0;
+		}
+
+		if (left_end_reached && right_end_reached) {
+			ret = 0;
+			goto out;
+		} else if (left_end_reached) {
+			if (right_level == 0) {
+				ret = changed_cb(left_root, right_root,
+						left_path, right_path,
+						&right_key,
+						BTRFS_COMPARE_TREE_DELETED,
+						ctx);
+				if (ret < 0)
+					goto out;
+			}
+			advance_right = ADVANCE;
+			continue;
+		} else if (right_end_reached) {
+			if (left_level == 0) {
+				ret = changed_cb(left_root, right_root,
+						left_path, right_path,
+						&left_key,
+						BTRFS_COMPARE_TREE_NEW,
+						ctx);
+				if (ret < 0)
+					goto out;
+			}
+			advance_left = ADVANCE;
+			continue;
+		}
+
+		if (left_level == 0 && right_level == 0) {
+			cmp = btrfs_comp_cpu_keys(&left_key, &right_key);
+			if (cmp < 0) {
+				ret = changed_cb(left_root, right_root,
+						left_path, right_path,
+						&left_key,
+						BTRFS_COMPARE_TREE_NEW,
+						ctx);
+				if (ret < 0)
+					goto out;
+				advance_left = ADVANCE;
+			} else if (cmp > 0) {
+				ret = changed_cb(left_root, right_root,
+						left_path, right_path,
+						&right_key,
+						BTRFS_COMPARE_TREE_DELETED,
+						ctx);
+				if (ret < 0)
+					goto out;
+				advance_right = ADVANCE;
+			} else {
+				ret = tree_compare_item(left_root, left_path,
+						right_path, tmp_buf);
+				if (ret) {
+					ret = changed_cb(left_root, right_root,
+						left_path, right_path,
+						&left_key,
+						BTRFS_COMPARE_TREE_CHANGED,
+						ctx);
+					if (ret < 0)
+						goto out;
+				}
+				advance_left = ADVANCE;
+				advance_right = ADVANCE;
+			}
+		} else if (left_level == right_level) {
+			cmp = btrfs_comp_cpu_keys(&left_key, &right_key);
+			if (cmp < 0) {
+				advance_left = ADVANCE;
+			} else if (cmp > 0) {
+				advance_right = ADVANCE;
+			} else {
+				left_blockptr = btrfs_node_blockptr(
+						left_path->nodes[left_level],
+						left_path->slots[left_level]);
+				right_blockptr = btrfs_node_blockptr(
+						right_path->nodes[right_level],
+						right_path->slots[right_level]);
+				if (left_blockptr == right_blockptr) {
+					/*
+					 * As we're on a shared block, don't
+					 * allow to go deeper.
+					 */
+					advance_left = ADVANCE_ONLY_NEXT;
+					advance_right = ADVANCE_ONLY_NEXT;
+				} else {
+					advance_left = ADVANCE;
+					advance_right = ADVANCE;
+				}
+			}
+		} else if (left_level < right_level) {
+			advance_right = ADVANCE;
+		} else {
+			advance_left = ADVANCE;
+		}
+	}
+
+out:
+	btrfs_free_path(left_path);
+	btrfs_free_path(right_path);
+	kfree(tmp_buf);
+
+	if (trans) {
+		if (!ret)
+			ret = btrfs_end_transaction(trans, left_root);
+		else
+			btrfs_end_transaction(trans, left_root);
+	}
+
+	return ret;
+}
+
 /*
  * this is similar to btrfs_next_leaf, but does not try to preserve
  * and fixup the path.  It looks for and returns the next key in the
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2bd5df8..74f273a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2721,6 +2721,21 @@ int btrfs_search_forward(struct btrfs_root *root, struct btrfs_key *min_key,
 			 struct btrfs_key *max_key,
 			 struct btrfs_path *path, int cache_only,
 			 u64 min_trans);
+enum btrfs_compare_tree_result {
+	BTRFS_COMPARE_TREE_NEW,
+	BTRFS_COMPARE_TREE_DELETED,
+	BTRFS_COMPARE_TREE_CHANGED,
+};
+typedef int (*btrfs_changed_cb_t)(struct btrfs_root *left_root,
+				  struct btrfs_root *right_root,
+				  struct btrfs_path *left_path,
+				  struct btrfs_path *right_path,
+				  struct btrfs_key *key,
+				  enum btrfs_compare_tree_result result,
+				  void *ctx);
+int btrfs_compare_trees(struct btrfs_root *left_root,
+			struct btrfs_root *right_root,
+			btrfs_changed_cb_t cb, void *ctx);
 int btrfs_cow_block(struct btrfs_trans_handle *trans,
 		    struct btrfs_root *root, struct extent_buffer *buf,
 		    struct extent_buffer *parent, int parent_slot,
-- 
1.7.10

