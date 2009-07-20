From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] Fix locking issue in btrfs_find_next_key
Date: Mon, 20 Jul 2009 19:30:43 +0800
Message-ID: <4A645563.9070001@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When need walking up the tree, btrfs_find_next_key assumes the
upper level tree block is properly locked. This isn't always true
even path->keep_locks is 1. This is because btrfs_find_next_key may
advance path->slots[] several times instead of only once. When
'path->slots[level] >= btrfs_header_nritems(path->nodes[level])' is
found, we can't guarantee the original value of 'path->slots[level]'
is 'btrfs_header_nritems(path->nodes[level]) - 1'. If it's not, the
tree block at 'level + 1' isn't locked.

This patch fixes the issue by explicitly checking the locking state,
re-searching the tree if it's not locked.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>
 
---
diff -urp 1/fs/btrfs/ctree.c 2/fs/btrfs/ctree.c
--- 1/fs/btrfs/ctree.c	2009-07-17 16:05:20.583924545 +0800
+++ 2/fs/btrfs/ctree.c	2009-07-20 14:52:49.715697336 +0800
@@ -1701,6 +1701,7 @@ int btrfs_search_slot(struct btrfs_trans
 	struct extent_buffer *b;
 	int slot;
 	int ret;
+	int err;
 	int level;
 	int lowest_unlock = 1;
 	u8 lowest_level = 0;
@@ -1737,8 +1738,6 @@ again:
 			p->locks[level] = 1;
 
 		if (cow) {
-			int wret;
-
 			/*
 			 * if we don't really need to cow this block
 			 * then we don't want to set the path blocking,
@@ -1749,12 +1748,12 @@ again:
 
 			btrfs_set_path_blocking(p);
 
-			wret = btrfs_cow_block(trans, root, b,
-					       p->nodes[level + 1],
-					       p->slots[level + 1], &b);
-			if (wret) {
+			err = btrfs_cow_block(trans, root, b,
+					      p->nodes[level + 1],
+					      p->slots[level + 1], &b);
+			if (err) {
 				free_extent_buffer(b);
-				ret = wret;
+				ret = err;
 				goto done;
 			}
 		}
@@ -1793,41 +1792,45 @@ cow_done:
 		ret = bin_search(b, key, level, &slot);
 
 		if (level != 0) {
-			if (ret && slot > 0)
+			int dec = 0;
+			if (ret && slot > 0) {
+				dec = 1;
 				slot -= 1;
+			}
 			p->slots[level] = slot;
-			ret = setup_nodes_for_search(trans, root, p, b, level,
+			err = setup_nodes_for_search(trans, root, p, b, level,
 						     ins_len);
-			if (ret == -EAGAIN)
+			if (err == -EAGAIN)
 				goto again;
-			else if (ret)
+			if (err) {
+				ret = err;
 				goto done;
+			}
 			b = p->nodes[level];
 			slot = p->slots[level];
 
 			unlock_up(p, level, lowest_unlock);
 
-			/* this is only true while dropping a snapshot */
 			if (level == lowest_level) {
-				ret = 0;
+				if (dec)
+					p->slots[level]++;
 				goto done;
 			}
 
-			ret = read_block_for_search(trans, root, p,
+			err = read_block_for_search(trans, root, p,
 						    &b, level, slot, key);
-			if (ret == -EAGAIN)
+			if (err == -EAGAIN)
 				goto again;
-
-			if (ret == -EIO)
+			if (err) {
+				ret = err;
 				goto done;
+			}
 
 			if (!p->skip_locking) {
-				int lret;
-
 				btrfs_clear_path_blocking(p, NULL);
-				lret = btrfs_try_spin_lock(b);
+				err = btrfs_try_spin_lock(b);
 
-				if (!lret) {
+				if (!err) {
 					btrfs_set_path_blocking(p);
 					btrfs_tree_lock(b);
 					btrfs_clear_path_blocking(p, b);
@@ -1837,16 +1840,14 @@ cow_done:
 			p->slots[level] = slot;
 			if (ins_len > 0 &&
 			    btrfs_leaf_free_space(root, b) < ins_len) {
-				int sret;
-
 				btrfs_set_path_blocking(p);
-				sret = split_leaf(trans, root, key,
-						      p, ins_len, ret == 0);
+				err = split_leaf(trans, root, key,
+						 p, ins_len, ret == 0);
 				btrfs_clear_path_blocking(p, NULL);
 
-				BUG_ON(sret > 0);
-				if (sret) {
-					ret = sret;
+				BUG_ON(err > 0);
+				if (err) {
+					ret = err;
 					goto done;
 				}
 			}
@@ -4042,10 +4043,9 @@ out:
  * calling this function.
  */
 int btrfs_find_next_key(struct btrfs_root *root, struct btrfs_path *path,
-			struct btrfs_key *key, int lowest_level,
+			struct btrfs_key *key, int level,
 			int cache_only, u64 min_trans)
 {
-	int level = lowest_level;
 	int slot;
 	struct extent_buffer *c;
 
@@ -4058,11 +4058,40 @@ int btrfs_find_next_key(struct btrfs_roo
 		c = path->nodes[level];
 next:
 		if (slot >= btrfs_header_nritems(c)) {
-			level++;
-			if (level == BTRFS_MAX_LEVEL)
+			int ret;
+			int orig_lowest;
+			struct btrfs_key cur_key;
+			if (level + 1 >= BTRFS_MAX_LEVEL ||
+			    !path->nodes[level + 1])
 				return 1;
-			continue;
+
+			if (path->locks[level + 1]) {
+				level++;
+				continue;
+			}
+
+			slot = btrfs_header_nritems(c) - 1;
+			if (level == 0)
+				btrfs_item_key_to_cpu(c, &cur_key, slot);
+			else
+				btrfs_node_key_to_cpu(c, &cur_key, slot);
+
+			orig_lowest = path->lowest_level;
+			btrfs_release_path(root, path);
+			path->lowest_level = level;
+			ret = btrfs_search_slot(NULL, root, &cur_key, path,
+						0, 0);
+			path->lowest_level = orig_lowest;
+			if (ret < 0)
+				return ret;
+
+			c = path->nodes[level];
+			slot = path->slots[level];
+			if (ret == 0)
+				slot++;
+			goto next;
 		}
+
 		if (level == 0)
 			btrfs_item_key_to_cpu(c, key, slot);
 		else {
diff -urp 1/fs/btrfs/relocation.c 2/fs/btrfs/relocation.c
--- 1/fs/btrfs/relocation.c	2009-07-17 16:05:20.628449970 +0800
+++ 2/fs/btrfs/relocation.c	2009-07-20 14:52:49.717697678 +0800
@@ -670,6 +670,8 @@ again:
 			err = ret;
 			goto out;
 		}
+		if (ret > 0 && path2->slots[level] > 0)
+			path2->slots[level]--;
 
 		eb = path2->nodes[level];
 		WARN_ON(btrfs_node_blockptr(eb, path2->slots[level]) !=
@@ -1609,6 +1611,7 @@ static noinline_for_stack int merge_relo
 		BUG_ON(level == 0);
 		path->lowest_level = level;
 		ret = btrfs_search_slot(NULL, reloc_root, &key, path, 0, 0);
+		path->lowest_level = 0;
 		if (ret < 0) {
 			btrfs_free_path(path);
 			return ret;
