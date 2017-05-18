Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43366 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932218AbdERDjd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 23:39:33 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 32/32] btrfs-progs: Refactor read_node_slot function to get rid of btrfs_root parameter
Date: Thu, 18 May 2017 11:38:57 +0800
Message-ID: <20170518033857.15002-33-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
References: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-restore.c |  5 +++--
 ctree.c        | 37 ++++++++++++++++++++++---------------
 ctree.h        |  2 +-
 3 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index ae01430c..06c88b26 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -181,6 +181,7 @@ static int next_leaf(struct btrfs_root *root, struct btrfs_path *path)
 	int offset = 1;
 	struct extent_buffer *c;
 	struct extent_buffer *next = NULL;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 
 again:
 	for (; level < BTRFS_MAX_LEVEL; level++) {
@@ -210,7 +211,7 @@ again:
 		if (path->reada)
 			reada_for_search(root, path, level, slot, 0);
 
-		next = read_node_slot(root, c, slot);
+		next = read_node_slot(fs_info, c, slot);
 		if (extent_buffer_uptodate(next))
 			break;
 		offset++;
@@ -226,7 +227,7 @@ again:
 			break;
 		if (path->reada)
 			reada_for_search(root, path, level, 0, 0);
-		next = read_node_slot(root, next, 0);
+		next = read_node_slot(fs_info, next, 0);
 		if (!extent_buffer_uptodate(next))
 			goto again;
 	}
diff --git a/ctree.c b/ctree.c
index 09273818..43f283c1 100644
--- a/ctree.c
+++ b/ctree.c
@@ -637,7 +637,7 @@ static int bin_search(struct extent_buffer *eb, struct btrfs_key *key,
 					  slot);
 }
 
-struct extent_buffer *read_node_slot(struct btrfs_root *root,
+struct extent_buffer *read_node_slot(struct btrfs_fs_info *fs_info,
 				   struct extent_buffer *parent, int slot)
 {
 	int level = btrfs_header_level(parent);
@@ -649,8 +649,8 @@ struct extent_buffer *read_node_slot(struct btrfs_root *root,
 	if (level == 0)
 		return NULL;
 
-	return read_tree_block(root->fs_info, btrfs_node_blockptr(parent, slot),
-		       root->fs_info->nodesize,
+	return read_tree_block(fs_info, btrfs_node_blockptr(parent, slot),
+		       fs_info->nodesize,
 		       btrfs_node_ptr_generation(parent, slot));
 }
 
@@ -662,6 +662,7 @@ static int balance_level(struct btrfs_trans_handle *trans,
 	struct extent_buffer *mid;
 	struct extent_buffer *left = NULL;
 	struct extent_buffer *parent = NULL;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	int ret = 0;
 	int wret;
 	int pslot;
@@ -692,7 +693,7 @@ static int balance_level(struct btrfs_trans_handle *trans,
 			return 0;
 
 		/* promote the child to a root */
-		child = read_node_slot(root, mid, 0);
+		child = read_node_slot(fs_info, mid, 0);
 		BUG_ON(!extent_buffer_uptodate(child));
 		ret = btrfs_cow_block(trans, root, child, mid, 0, &child);
 		BUG_ON(ret);
@@ -715,7 +716,7 @@ static int balance_level(struct btrfs_trans_handle *trans,
 	    BTRFS_NODEPTRS_PER_BLOCK(root) / 4)
 		return 0;
 
-	left = read_node_slot(root, parent, pslot - 1);
+	left = read_node_slot(fs_info, parent, pslot - 1);
 	if (extent_buffer_uptodate(left)) {
 		wret = btrfs_cow_block(trans, root, left,
 				       parent, pslot - 1, &left);
@@ -724,7 +725,7 @@ static int balance_level(struct btrfs_trans_handle *trans,
 			goto enospc;
 		}
 	}
-	right = read_node_slot(root, parent, pslot + 1);
+	right = read_node_slot(fs_info, parent, pslot + 1);
 	if (extent_buffer_uptodate(right)) {
 		wret = btrfs_cow_block(trans, root, right,
 				       parent, pslot + 1, &right);
@@ -854,6 +855,7 @@ static int noinline push_nodes_for_insert(struct btrfs_trans_handle *trans,
 	struct extent_buffer *mid;
 	struct extent_buffer *left = NULL;
 	struct extent_buffer *parent = NULL;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	int ret = 0;
 	int wret;
 	int pslot;
@@ -873,7 +875,7 @@ static int noinline push_nodes_for_insert(struct btrfs_trans_handle *trans,
 	if (!parent)
 		return 1;
 
-	left = read_node_slot(root, parent, pslot - 1);
+	left = read_node_slot(fs_info, parent, pslot - 1);
 
 	/* first, try to make some room in the middle buffer */
 	if (extent_buffer_uptodate(left)) {
@@ -914,7 +916,7 @@ static int noinline push_nodes_for_insert(struct btrfs_trans_handle *trans,
 		}
 		free_extent_buffer(left);
 	}
-	right= read_node_slot(root, parent, pslot + 1);
+	right= read_node_slot(fs_info, parent, pslot + 1);
 
 	/*
 	 * then try to empty the right most buffer into the middle
@@ -1102,6 +1104,7 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
 	int ret;
 	int level;
 	int should_reada = p->reada;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	u8 lowest_level = 0;
 
 	lowest_level = p->lowest_level;
@@ -1169,7 +1172,7 @@ again:
 				reada_for_search(root, p, level, slot,
 						 key->objectid);
 
-			b = read_node_slot(root, b, slot);
+			b = read_node_slot(fs_info, b, slot);
 			if (!extent_buffer_uptodate(b))
 				return -EIO;
 		} else {
@@ -1644,6 +1647,7 @@ static int push_leaf_right(struct btrfs_trans_handle *trans, struct btrfs_root
 	struct extent_buffer *right;
 	struct extent_buffer *upper;
 	struct btrfs_disk_key disk_key;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	int slot;
 	u32 i;
 	int free_space;
@@ -1665,7 +1669,7 @@ static int push_leaf_right(struct btrfs_trans_handle *trans, struct btrfs_root
 	if (slot >= btrfs_header_nritems(upper) - 1)
 		return 1;
 
-	right = read_node_slot(root, upper, slot + 1);
+	right = read_node_slot(fs_info, upper, slot + 1);
 	if (!extent_buffer_uptodate(right)) {
 		if (IS_ERR(right))
 			return PTR_ERR(right);
@@ -1797,6 +1801,7 @@ static int push_leaf_left(struct btrfs_trans_handle *trans, struct btrfs_root
 	struct btrfs_disk_key disk_key;
 	struct extent_buffer *right = path->nodes[0];
 	struct extent_buffer *left;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	int slot;
 	int i;
 	int free_space;
@@ -1821,7 +1826,7 @@ static int push_leaf_left(struct btrfs_trans_handle *trans, struct btrfs_root
 		return 1;
 	}
 
-	left = read_node_slot(root, path->nodes[1], slot - 1);
+	left = read_node_slot(fs_info, path->nodes[1], slot - 1);
 	free_space = btrfs_leaf_free_space(root, left);
 	if (free_space < data_size) {
 		free_extent_buffer(left);
@@ -2770,6 +2775,7 @@ int btrfs_prev_leaf(struct btrfs_root *root, struct btrfs_path *path)
 	int level = 1;
 	struct extent_buffer *c;
 	struct extent_buffer *next = NULL;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 
 	while(level < BTRFS_MAX_LEVEL) {
 		if (!path->nodes[level])
@@ -2785,7 +2791,7 @@ int btrfs_prev_leaf(struct btrfs_root *root, struct btrfs_path *path)
 		}
 		slot--;
 
-		next = read_node_slot(root, c, slot);
+		next = read_node_slot(fs_info, c, slot);
 		if (!extent_buffer_uptodate(next)) {
 			if (IS_ERR(next))
 				return PTR_ERR(next);
@@ -2805,7 +2811,7 @@ int btrfs_prev_leaf(struct btrfs_root *root, struct btrfs_path *path)
 		path->slots[level] = slot;
 		if (!level)
 			break;
-		next = read_node_slot(root, next, slot);
+		next = read_node_slot(fs_info, next, slot);
 		if (!extent_buffer_uptodate(next)) {
 			if (IS_ERR(next))
 				return PTR_ERR(next);
@@ -2826,6 +2832,7 @@ int btrfs_next_leaf(struct btrfs_root *root, struct btrfs_path *path)
 	int level = 1;
 	struct extent_buffer *c;
 	struct extent_buffer *next = NULL;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 
 	while(level < BTRFS_MAX_LEVEL) {
 		if (!path->nodes[level])
@@ -2843,7 +2850,7 @@ int btrfs_next_leaf(struct btrfs_root *root, struct btrfs_path *path)
 		if (path->reada)
 			reada_for_search(root, path, level, slot, 0);
 
-		next = read_node_slot(root, c, slot);
+		next = read_node_slot(fs_info, c, slot);
 		if (!extent_buffer_uptodate(next))
 			return -EIO;
 		break;
@@ -2859,7 +2866,7 @@ int btrfs_next_leaf(struct btrfs_root *root, struct btrfs_path *path)
 			break;
 		if (path->reada)
 			reada_for_search(root, path, level, 0, 0);
-		next = read_node_slot(root, next, 0);
+		next = read_node_slot(fs_info, next, 0);
 		if (!extent_buffer_uptodate(next))
 			return -EIO;
 	}
diff --git a/ctree.h b/ctree.h
index 602c9562..cf337ae5 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2533,7 +2533,7 @@ btrfs_check_leaf(struct btrfs_root *root, struct btrfs_disk_key *parent_key,
 		 struct extent_buffer *buf);
 void reada_for_search(struct btrfs_root *root, struct btrfs_path *path,
 			     int level, int slot, u64 objectid);
-struct extent_buffer *read_node_slot(struct btrfs_root *root,
+struct extent_buffer *read_node_slot(struct btrfs_fs_info *fs_info,
 				   struct extent_buffer *parent, int slot);
 int btrfs_previous_item(struct btrfs_root *root,
 			struct btrfs_path *path, u64 min_objectid,
-- 
2.13.0



