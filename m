Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:44893 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932123AbbA0D4n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Jan 2015 22:56:43 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0R3u1W6020490
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Jan 2015 11:56:01 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 1/2] btrfs-progs: read_tree_block() and read_node_slot() cleanup.
Date: Tue, 27 Jan 2015 11:54:55 +0800
Message-ID: <1422330895-16703-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Allow read_tree_block() and read_node_slot() to return error pointer.
This should help caller to get more specified error number.

For existing callers, change (!eb) judgmentt to
(!extent_buffer_uptodate(eb)) to keep the compatibility, and for caller
missing the check, use PTR_ERR(eb) if possible.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
changelog:
v2:
   Add handle in free_extent_buffer() to deal with error pointer.
---
 backref.c             |  4 ++--
 btrfs-calc-size.c     |  2 +-
 btrfs-corrupt-block.c |  6 +++---
 btrfs-debug-tree.c    |  7 +++++--
 btrfs-image.c         |  6 +++---
 cmds-check.c          |  6 +++---
 cmds-restore.c        |  6 +++---
 ctree.c               | 29 ++++++++++++++++++++++-------
 disk-io.c             | 10 +++++-----
 extent-tree.c         |  6 ++++++
 extent_io.c           |  5 ++---
 print-tree.c          |  2 +-
 qgroup-verify.c       |  2 +-
 13 files changed, 57 insertions(+), 34 deletions(-)

diff --git a/backref.c b/backref.c
index 593f936..9a2efca 100644
--- a/backref.c
+++ b/backref.c
@@ -451,7 +451,7 @@ static int __add_missing_keys(struct btrfs_fs_info *fs_info,
 		BUG_ON(!ref->wanted_disk_byte);
 		eb = read_tree_block(fs_info->tree_root, ref->wanted_disk_byte,
 				     fs_info->tree_root->leafsize, 0);
-		if (!eb || !extent_buffer_uptodate(eb)) {
+		if (!extent_buffer_uptodate(eb)) {
 			free_extent_buffer(eb);
 			return -EIO;
 		}
@@ -808,7 +808,7 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 							ref->level);
 				eb = read_tree_block(fs_info->extent_root,
 							   ref->parent, bsz, 0);
-				if (!eb || !extent_buffer_uptodate(eb)) {
+				if (!extent_buffer_uptodate(eb)) {
 					free_extent_buffer(eb);
 					ret = -EIO;
 					goto out;
diff --git a/btrfs-calc-size.c b/btrfs-calc-size.c
index 501111c..354f70d 100644
--- a/btrfs-calc-size.c
+++ b/btrfs-calc-size.c
@@ -159,7 +159,7 @@ static int walk_nodes(struct btrfs_root *root, struct btrfs_path *path,
 			tmp = read_tree_block(root, cur_blocknr,
 					      btrfs_level_size(root, level - 1),
 					      btrfs_node_ptr_generation(b, i));
-			if (!tmp) {
+			if (!extent_buffer_uptodate(tmp)) {
 				fprintf(stderr, "Failed to read blocknr %Lu\n",
 					btrfs_node_blockptr(b, i));
 				continue;
diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index b477e87..af03ad1 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -160,7 +160,7 @@ static int corrupt_keys_in_block(struct btrfs_root *root, u64 bytenr)
 	struct extent_buffer *eb;
 
 	eb = read_tree_block(root, bytenr, root->leafsize, 0);
-	if (!eb)
+	if (!extent_buffer_uptodate(eb))
 		return -EIO;;
 
 	corrupt_keys(NULL, root, eb);
@@ -288,7 +288,7 @@ static void btrfs_corrupt_extent_tree(struct btrfs_trans_handle *trans,
 		next = read_tree_block(root, btrfs_node_blockptr(eb, i),
 				       root->leafsize,
 				       btrfs_node_ptr_generation(eb, i));
-		if (!next)
+		if (!extent_buffer_uptodate(next))
 			continue;
 		btrfs_corrupt_extent_tree(trans, root, next);
 		free_extent_buffer(next);
@@ -696,7 +696,7 @@ static int corrupt_metadata_block(struct btrfs_root *root, u64 block,
 	}
 
 	eb = read_tree_block(root, block, root->leafsize, 0);
-	if (!eb) {
+	if (!extent_buffer_uptodate(eb)) {
 		fprintf(stderr, "Couldn't read in tree block %s\n", field);
 		return -EINVAL;
 	}
diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
index 9cdb35f..3efd434 100644
--- a/btrfs-debug-tree.c
+++ b/btrfs-debug-tree.c
@@ -68,6 +68,8 @@ static void print_extents(struct btrfs_root *root, struct extent_buffer *eb)
 					     btrfs_node_blockptr(eb, i),
 					     size,
 					     btrfs_node_ptr_generation(eb, i));
+		if (!extent_buffer_uptodate(next))
+			continue;
 		if (btrfs_is_leaf(next) &&
 		    btrfs_header_level(eb) != 1)
 			BUG();
@@ -202,7 +204,8 @@ int main(int ac, char **av)
 				      block_only,
 				      root->leafsize, 0);
 
-		if (leaf && btrfs_header_level(leaf) != 0) {
+		if (extent_buffer_uptodate(leaf) &&
+		    btrfs_header_level(leaf) != 0) {
 			free_extent_buffer(leaf);
 			leaf = NULL;
 		}
@@ -212,7 +215,7 @@ int main(int ac, char **av)
 					      block_only,
 					      root->nodesize, 0);
 		}
-		if (!leaf) {
+		if (!extent_buffer_uptodate(leaf)) {
 			fprintf(stderr, "failed to read %llu\n",
 				(unsigned long long)block_only);
 			goto close_root;
diff --git a/btrfs-image.c b/btrfs-image.c
index cb17f16..667822c 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -910,7 +910,7 @@ static int flush_pending(struct metadump_struct *md, int done)
 		while (!md->data && size > 0) {
 			u64 this_read = min(blocksize, size);
 			eb = read_tree_block(md->root, start, this_read, 0);
-			if (!eb) {
+			if (!extent_buffer_uptodate(eb)) {
 				free(async->buffer);
 				free(async);
 				fprintf(stderr,
@@ -1039,7 +1039,7 @@ static int copy_tree_blocks(struct btrfs_root *root, struct extent_buffer *eb,
 			ri = btrfs_item_ptr(eb, i, struct btrfs_root_item);
 			bytenr = btrfs_disk_root_bytenr(eb, ri);
 			tmp = read_tree_block(root, bytenr, root->leafsize, 0);
-			if (!tmp) {
+			if (!extent_buffer_uptodate(tmp)) {
 				fprintf(stderr,
 					"Error reading log root block\n");
 				return -EIO;
@@ -1051,7 +1051,7 @@ static int copy_tree_blocks(struct btrfs_root *root, struct extent_buffer *eb,
 		} else {
 			bytenr = btrfs_node_blockptr(eb, i);
 			tmp = read_tree_block(root, bytenr, root->leafsize, 0);
-			if (!tmp) {
+			if (!extent_buffer_uptodate(tmp)) {
 				fprintf(stderr, "Error reading log block\n");
 				return -EIO;
 			}
diff --git a/cmds-check.c b/cmds-check.c
index bafa743..bbbf432 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1759,7 +1759,7 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
 			reada_walk_down(root, cur, path->slots[*level]);
 			next = read_tree_block(root, bytenr, blocksize,
 					       ptr_gen);
-			if (!next) {
+			if (!extent_buffer_uptodate(next)) {
 				struct btrfs_key node_key;
 
 				btrfs_node_key_to_cpu(path->nodes[*level],
@@ -8099,7 +8099,7 @@ static int pin_down_tree_blocks(struct btrfs_fs_info *fs_info,
 			 */
 			tmp = read_tree_block(fs_info->extent_root, bytenr,
 					      leafsize, 0);
-			if (!tmp) {
+			if (!extent_buffer_uptodate(tmp)) {
 				fprintf(stderr, "Error reading root block\n");
 				return -EIO;
 			}
@@ -8118,7 +8118,7 @@ static int pin_down_tree_blocks(struct btrfs_fs_info *fs_info,
 
 			tmp = read_tree_block(fs_info->extent_root, bytenr,
 					      leafsize, 0);
-			if (!tmp) {
+			if (!extent_buffer_uptodate(tmp)) {
 				fprintf(stderr, "Error reading tree block\n");
 				return -EIO;
 			}
diff --git a/cmds-restore.c b/cmds-restore.c
index 859deaf..efc2414 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -199,7 +199,7 @@ again:
 			reada_for_search(root, path, level, slot, 0);
 
 		next = read_node_slot(root, c, slot);
-		if (next)
+		if (extent_buffer_uptodate(next))
 			break;
 		offset++;
 	}
@@ -215,7 +215,7 @@ again:
 		if (path->reada)
 			reada_for_search(root, path, level, 0, 0);
 		next = read_node_slot(root, next, 0);
-		if (!next)
+		if (!extent_buffer_uptodate(next))
 			goto again;
 	}
 	return 0;
@@ -1263,7 +1263,7 @@ int cmd_restore(int argc, char **argv)
 	if (fs_location != 0) {
 		free_extent_buffer(root->node);
 		root->node = read_tree_block(root, fs_location, root->leafsize, 0);
-		if (!root->node) {
+		if (!extent_buffer_uptodate(root->node)) {
 			fprintf(stderr, "Failed to read fs location\n");
 			ret = 1;
 			goto out;
diff --git a/ctree.c b/ctree.c
index 589efa3..130c61f 100644
--- a/ctree.c
+++ b/ctree.c
@@ -677,7 +677,7 @@ static int balance_level(struct btrfs_trans_handle *trans,
 
 		/* promote the child to a root */
 		child = read_node_slot(root, mid, 0);
-		BUG_ON(!child);
+		BUG_ON(!extent_buffer_uptodate(child));
 		ret = btrfs_cow_block(trans, root, child, mid, 0, &child);
 		BUG_ON(ret);
 
@@ -701,7 +701,7 @@ static int balance_level(struct btrfs_trans_handle *trans,
 		return 0;
 
 	left = read_node_slot(root, parent, pslot - 1);
-	if (left) {
+	if (extent_buffer_uptodate(left)) {
 		wret = btrfs_cow_block(trans, root, left,
 				       parent, pslot - 1, &left);
 		if (wret) {
@@ -710,7 +710,7 @@ static int balance_level(struct btrfs_trans_handle *trans,
 		}
 	}
 	right = read_node_slot(root, parent, pslot + 1);
-	if (right) {
+	if (extent_buffer_uptodate(right)) {
 		wret = btrfs_cow_block(trans, root, right,
 				       parent, pslot + 1, &right);
 		if (wret) {
@@ -864,7 +864,7 @@ static int noinline push_nodes_for_insert(struct btrfs_trans_handle *trans,
 	left = read_node_slot(root, parent, pslot - 1);
 
 	/* first, try to make some room in the middle buffer */
-	if (left) {
+	if (extent_buffer_uptodate(left)) {
 		u32 left_nr;
 		left_nr = btrfs_header_nritems(left);
 		if (left_nr >= BTRFS_NODEPTRS_PER_BLOCK(root) - 1) {
@@ -907,7 +907,7 @@ static int noinline push_nodes_for_insert(struct btrfs_trans_handle *trans,
 	/*
 	 * then try to empty the right most buffer into the middle
 	 */
-	if (right) {
+	if (extent_buffer_uptodate(right)) {
 		u32 right_nr;
 		right_nr = btrfs_header_nritems(right);
 		if (right_nr >= BTRFS_NODEPTRS_PER_BLOCK(root) - 1) {
@@ -1651,6 +1651,11 @@ static int push_leaf_right(struct btrfs_trans_handle *trans, struct btrfs_root
 		return 1;
 
 	right = read_node_slot(root, upper, slot + 1);
+	if (!extent_buffer_uptodate(right)) {
+		if (IS_ERR(right))
+			return PTR_ERR(right);
+		return -EIO;
+	}
 	free_space = btrfs_leaf_free_space(root, right);
 	if (free_space < data_size) {
 		free_extent_buffer(right);
@@ -2770,6 +2775,11 @@ int btrfs_prev_leaf(struct btrfs_root *root, struct btrfs_path *path)
 		slot--;
 
 		next = read_node_slot(root, c, slot);
+		if (!extent_buffer_uptodate(next)) {
+			if (IS_ERR(next))
+				return PTR_ERR(next);
+			return -EIO;
+		}
 		break;
 	}
 	path->slots[level] = slot;
@@ -2785,6 +2795,11 @@ int btrfs_prev_leaf(struct btrfs_root *root, struct btrfs_path *path)
 		if (!level)
 			break;
 		next = read_node_slot(root, next, slot);
+		if (!extent_buffer_uptodate(next)) {
+			if (IS_ERR(next))
+				return PTR_ERR(next);
+			return -EIO;
+		}
 	}
 	return 0;
 }
@@ -2818,7 +2833,7 @@ int btrfs_next_leaf(struct btrfs_root *root, struct btrfs_path *path)
 			reada_for_search(root, path, level, slot, 0);
 
 		next = read_node_slot(root, c, slot);
-		if (!next)
+		if (!extent_buffer_uptodate(next))
 			return -EIO;
 		break;
 	}
@@ -2834,7 +2849,7 @@ int btrfs_next_leaf(struct btrfs_root *root, struct btrfs_path *path)
 		if (path->reada)
 			reada_for_search(root, path, level, 0, 0);
 		next = read_node_slot(root, next, 0);
-		if (!next)
+		if (!extent_buffer_uptodate(next))
 			return -EIO;
 	}
 	return 0;
diff --git a/disk-io.c b/disk-io.c
index 521e1bd..a4d236f 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -261,7 +261,7 @@ struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 
 	eb = btrfs_find_create_tree_block(root, bytenr, blocksize);
 	if (!eb)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	if (btrfs_buffer_uptodate(eb, parent_transid))
 		return eb;
@@ -286,6 +286,7 @@ struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 				printk("read block failed check_tree_block\n");
 			else
 				printk("Csum didn't match\n");
+			ret = -EIO;
 			break;
 		}
 		num_copies = btrfs_num_copies(&root->fs_info->mapping_tree,
@@ -306,7 +307,7 @@ struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 		}
 	}
 	free_extent_buffer(eb);
-	return NULL;
+	return ERR_PTR(ret);
 }
 
 int write_and_map_eb(struct btrfs_trans_handle *trans,
@@ -642,7 +643,7 @@ out:
 	blocksize = btrfs_level_size(root, btrfs_root_level(&root->root_item));
 	root->node = read_tree_block(root, btrfs_root_bytenr(&root->root_item),
 				     blocksize, generation);
-	if (!root->node) {
+	if (!extent_buffer_uptodate(root->node)) {
 		free(root);
 		return ERR_PTR(-EIO);
 	}
@@ -1071,8 +1072,7 @@ int btrfs_setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info)
 	fs_info->chunk_root->node = read_tree_block(fs_info->chunk_root,
 						    btrfs_super_chunk_root(sb),
 						    blocksize, generation);
-	if (!fs_info->chunk_root->node ||
-	    !extent_buffer_uptodate(fs_info->chunk_root->node)) {
+	if (!extent_buffer_uptodate(fs_info->chunk_root->node)) {
 		fprintf(stderr, "Couldn't read chunk root\n");
 		return -EIO;
 	}
diff --git a/extent-tree.c b/extent-tree.c
index d614e7e..9eea55d 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -2962,6 +2962,12 @@ static int noinline walk_down_tree(struct btrfs_trans_handle *trans,
 			next = read_tree_block(root, bytenr, blocksize,
 					       ptr_gen);
 			mutex_lock(&root->fs_info->fs_mutex);
+			if (!extent_buffer_uptodate(next)) {
+				if (IS_ERR(next))
+					ret = PTR_ERR(next);
+				ret = -EIO;
+				break;
+			}
 		}
 		WARN_ON(*level <= 0);
 		if (path->nodes[*level-1])
diff --git a/extent_io.c b/extent_io.c
index 9c982f9..c442efd 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -577,7 +577,7 @@ struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src)
 
 void free_extent_buffer(struct extent_buffer *eb)
 {
-	if (!eb)
+	if (!eb || IS_ERR(eb))
 		return;
 
 	eb->refs--;
@@ -845,9 +845,8 @@ int clear_extent_buffer_uptodate(struct extent_io_tree *tree,
 
 int extent_buffer_uptodate(struct extent_buffer *eb)
 {
-	if (!eb)
+	if (!eb || IS_ERR(eb))
 		return 0;
-
 	if (eb->flags & EXTENT_UPTODATE)
 		return 1;
 	return 0;
diff --git a/print-tree.c b/print-tree.c
index 70a7acc..3a7c13c 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -1060,7 +1060,7 @@ void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *eb, int fol
 					     btrfs_node_blockptr(eb, i),
 					     size,
 					     btrfs_node_ptr_generation(eb, i));
-		if (!next) {
+		if (!extent_buffer_uptodate(next)) {
 			fprintf(stderr, "failed to read %llu in tree %llu\n",
 				(unsigned long long)btrfs_node_blockptr(eb, i),
 				(unsigned long long)btrfs_header_owner(eb));
diff --git a/qgroup-verify.c b/qgroup-verify.c
index c98c751..f7a94bf 100644
--- a/qgroup-verify.c
+++ b/qgroup-verify.c
@@ -513,7 +513,7 @@ static int travel_tree(struct btrfs_fs_info *info, struct btrfs_root *root,
 //	       bytenr, num_bytes, ref_parent);
 
 	eb = read_tree_block(root, bytenr, num_bytes, 0);
-	if (!eb)
+	if (!extent_buffer_uptodate(eb))
 		return -EIO;
 
 	ret = 0;
-- 
2.2.2

