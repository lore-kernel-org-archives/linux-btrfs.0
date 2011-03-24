From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs: check return value of read_tree_block()
Date: Thu, 24 Mar 2011 15:33:21 +0900
Message-ID: <201103240633.AA00011@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch is checking return value of read_tree_block(),
and if it is NULL, error processing.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/ctree.c       |    3 +++
 fs/btrfs/extent-tree.c |    6 ++++++
 fs/btrfs/relocation.c  |    6 ++++++
 3 files changed, 15 insertions(+)

diff -urNp linux-2.6.38/fs/btrfs/ctree.c linux-2.6.38.new/fs/btrfs/ctree.c
--- linux-2.6.38/fs/btrfs/ctree.c	2011-03-15 10:20:32.000000000 +0900
+++ linux-2.6.38.new/fs/btrfs/ctree.c	2011-03-24 11:12:54.000000000 +0900
@@ -686,6 +686,8 @@ int btrfs_realloc_node(struct btrfs_tran
 			if (!cur) {
 				cur = read_tree_block(root, blocknr,
 							 blocksize, gen);
+				if (!cur)
+					return -EIO;
 			} else if (!uptodate) {
 				btrfs_read_buffer(cur, gen);
 			}
@@ -4217,6 +4219,7 @@ find_next_key:
 		}
 		btrfs_set_path_blocking(path);
 		cur = read_node_slot(root, cur, slot);
+		BUG_ON(!cur);
 
 		btrfs_tree_lock(cur);
 
diff -urNp linux-2.6.38/fs/btrfs/extent-tree.c linux-2.6.38.new/fs/btrfs/extent-tree.c
--- linux-2.6.38/fs/btrfs/extent-tree.c	2011-03-15 10:20:32.000000000 +0900
+++ linux-2.6.38.new/fs/btrfs/extent-tree.c	2011-03-24 11:32:55.000000000 +0900
@@ -6047,6 +6047,8 @@ static noinline int do_walk_down(struct 
 		if (reada && level == 1)
 			reada_walk_down(trans, root, wc, path);
 		next = read_tree_block(root, bytenr, blocksize, generation);
+		if (!next)
+			return -EIO;
 		btrfs_tree_lock(next);
 		btrfs_set_lock_blocking(next);
 	}
@@ -7906,6 +7908,10 @@ static noinline int relocate_one_extent(
 
 			eb = read_tree_block(found_root, block_start,
 					     block_size, 0);
+			if (!eb) {
+				ret = -EIO;
+				goto out;
+			}
 			btrfs_tree_lock(eb);
 			BUG_ON(level != btrfs_header_level(eb));
 
diff -urNp linux-2.6.38/fs/btrfs/relocation.c linux-2.6.38.new/fs/btrfs/relocation.c
--- linux-2.6.38/fs/btrfs/relocation.c	2011-03-15 10:20:32.000000000 +0900
+++ linux-2.6.38.new/fs/btrfs/relocation.c	2011-03-24 11:43:53.000000000 +0900
@@ -1724,6 +1724,7 @@ again:
 
 			eb = read_tree_block(dest, old_bytenr, blocksize,
 					     old_ptr_gen);
+			BUG_ON(!eb);
 			btrfs_tree_lock(eb);
 			if (cow) {
 				ret = btrfs_cow_block(trans, dest, eb, parent,
@@ -2513,6 +2514,10 @@ static int do_relocation(struct btrfs_tr
 		blocksize = btrfs_level_size(root, node->level);
 		generation = btrfs_node_ptr_generation(upper->eb, slot);
 		eb = read_tree_block(root, bytenr, blocksize, generation);
+		if (!eb) {
+			err = -EIO;
+			goto next;
+		}
 		btrfs_tree_lock(eb);
 		btrfs_set_lock_blocking(eb);
 
@@ -2670,6 +2675,7 @@ static int get_tree_block_key(struct rel
 	BUG_ON(block->key_ready);
 	eb = read_tree_block(rc->extent_root, block->bytenr,
 			     block->key.objectid, block->key.offset);
+	BUG_ON(!eb);
 	WARN_ON(btrfs_header_level(eb) != block->level);
 	if (block->level == 0)
 		btrfs_item_key_to_cpu(eb, &block->key, 0);


