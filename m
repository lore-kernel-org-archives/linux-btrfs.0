Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:59660 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750821AbeC3FtM (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 30 Mar 2018 01:49:12 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 5/5] btrfs-progs: print-tree: Remove btrfs_root parameter
Date: Fri, 30 Mar 2018 13:48:57 +0800
Message-Id: <20180330054857.6106-6-wqu@suse.com>
In-Reply-To: <20180330054857.6106-1-wqu@suse.com>
References: <20180330054857.6106-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just like kernel cleanup made by David, btrfs_print_leaf() and
btrfs_print_tree() doesn't need btrfs_root parameter at all.

With previous patches as preparation, now we can remove the btrfs_root
parameter.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 cmds-inspect-dump-tree.c | 31 ++++++++++++++-----------------
 ctree.c                  | 16 ++++++++--------
 extent-tree.c            |  8 ++++----
 print-tree.c             | 20 +++++++++++---------
 print-tree.h             |  4 ++--
 5 files changed, 39 insertions(+), 40 deletions(-)

diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index 0802b31e9596..b0cd49b32664 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -33,8 +33,9 @@
 #include "utils.h"
 #include "help.h"
 
-static void print_extents(struct btrfs_root *root, struct extent_buffer *eb)
+static void print_extents(struct extent_buffer *eb)
 {
+	struct btrfs_fs_info *fs_info = eb->fs_info;
 	struct extent_buffer *next;
 	int i;
 	u32 nr;
@@ -43,13 +44,13 @@ static void print_extents(struct btrfs_root *root, struct extent_buffer *eb)
 		return;
 
 	if (btrfs_is_leaf(eb)) {
-		btrfs_print_leaf(root, eb);
+		btrfs_print_leaf(eb);
 		return;
 	}
 
 	nr = btrfs_header_nritems(eb);
 	for (i = 0; i < nr; i++) {
-		next = read_tree_block(root->fs_info,
+		next = read_tree_block(fs_info,
 				btrfs_node_blockptr(eb, i),
 				btrfs_node_ptr_generation(eb, i));
 		if (!extent_buffer_uptodate(next))
@@ -68,7 +69,7 @@ static void print_extents(struct btrfs_root *root, struct extent_buffer *eb)
 				btrfs_header_level(eb));
 			goto out;
 		}
-		print_extents(root, next);
+		print_extents(next);
 		free_extent_buffer(next);
 	}
 
@@ -331,7 +332,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 				(unsigned long long)block_only);
 			goto close_root;
 		}
-		btrfs_print_tree(root, leaf, follow);
+		btrfs_print_tree(leaf, follow);
 		free_extent_buffer(leaf);
 		goto close_root;
 	}
@@ -358,20 +359,17 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 		} else {
 			if (info->tree_root->node) {
 				printf("root tree\n");
-				btrfs_print_tree(info->tree_root,
-						 info->tree_root->node, 1);
+				btrfs_print_tree(info->tree_root->node, 1);
 			}
 
 			if (info->chunk_root->node) {
 				printf("chunk tree\n");
-				btrfs_print_tree(info->chunk_root,
-						 info->chunk_root->node, 1);
+				btrfs_print_tree(info->chunk_root->node, 1);
 			}
 
 			if (info->log_root_tree) {
 				printf("log root tree\n");
-				btrfs_print_tree(info->log_root_tree,
-						info->log_root_tree->node, 1);
+				btrfs_print_tree(info->log_root_tree->node, 1);
 			}
 		}
 	}
@@ -391,7 +389,7 @@ again:
 			goto close_root;
 		}
 		printf("root tree\n");
-		btrfs_print_tree(info->tree_root, info->tree_root->node, 1);
+		btrfs_print_tree(info->tree_root->node, 1);
 		goto close_root;
 	}
 
@@ -401,7 +399,7 @@ again:
 			goto close_root;
 		}
 		printf("chunk tree\n");
-		btrfs_print_tree(info->chunk_root, info->chunk_root->node, 1);
+		btrfs_print_tree(info->chunk_root->node, 1);
 		goto close_root;
 	}
 
@@ -411,8 +409,7 @@ again:
 			goto close_root;
 		}
 		printf("log root tree\n");
-		btrfs_print_tree(info->log_root_tree, info->log_root_tree->node,
-				 1);
+		btrfs_print_tree(info->log_root_tree->node, 1);
 		goto close_root;
 	}
 
@@ -548,7 +545,7 @@ again:
 				printf(" tree ");
 				btrfs_print_key(&disk_key);
 				printf("\n");
-				print_extents(tree_root_scan, buf);
+				print_extents(buf);
 			} else if (!skip) {
 				printf(" tree ");
 				btrfs_print_key(&disk_key);
@@ -558,7 +555,7 @@ again:
 					       btrfs_header_level(buf));
 				} else {
 					printf(" \n");
-					btrfs_print_tree(tree_root_scan, buf, 1);
+					btrfs_print_tree(buf, 1);
 				}
 			}
 			free_extent_buffer(buf);
diff --git a/ctree.c b/ctree.c
index 20848f0f7024..d1c41925d71c 100644
--- a/ctree.c
+++ b/ctree.c
@@ -2315,7 +2315,7 @@ split:
 
 	ret = 0;
 	if (btrfs_leaf_free_space(root->fs_info, leaf) < 0) {
-		btrfs_print_leaf(root, leaf);
+		btrfs_print_leaf(leaf);
 		BUG();
 	}
 	kfree(buf);
@@ -2411,7 +2411,7 @@ int btrfs_truncate_item(struct btrfs_root *root, struct btrfs_path *path,
 
 	ret = 0;
 	if (btrfs_leaf_free_space(root->fs_info, leaf) < 0) {
-		btrfs_print_leaf(root, leaf);
+		btrfs_print_leaf(leaf);
 		BUG();
 	}
 	return ret;
@@ -2436,7 +2436,7 @@ int btrfs_extend_item(struct btrfs_root *root, struct btrfs_path *path,
 	data_end = leaf_data_end(root->fs_info, leaf);
 
 	if (btrfs_leaf_free_space(root->fs_info, leaf) < data_size) {
-		btrfs_print_leaf(root, leaf);
+		btrfs_print_leaf(leaf);
 		BUG();
 	}
 	slot = path->slots[0];
@@ -2444,7 +2444,7 @@ int btrfs_extend_item(struct btrfs_root *root, struct btrfs_path *path,
 
 	BUG_ON(slot < 0);
 	if (slot >= nritems) {
-		btrfs_print_leaf(root, leaf);
+		btrfs_print_leaf(leaf);
 		printk("slot %d too large, nritems %d\n", slot, nritems);
 		BUG_ON(1);
 	}
@@ -2473,7 +2473,7 @@ int btrfs_extend_item(struct btrfs_root *root, struct btrfs_path *path,
 
 	ret = 0;
 	if (btrfs_leaf_free_space(root->fs_info, leaf) < 0) {
-		btrfs_print_leaf(root, leaf);
+		btrfs_print_leaf(leaf);
 		BUG();
 	}
 	return ret;
@@ -2522,7 +2522,7 @@ int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
 	data_end = leaf_data_end(root->fs_info, leaf);
 
 	if (btrfs_leaf_free_space(root->fs_info, leaf) < total_size) {
-		btrfs_print_leaf(root, leaf);
+		btrfs_print_leaf(leaf);
 		printk("not enough freespace need %u have %d\n",
 		       total_size, btrfs_leaf_free_space(root->fs_info, leaf));
 		BUG();
@@ -2535,7 +2535,7 @@ int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
 		unsigned int old_data = btrfs_item_end_nr(leaf, slot);
 
 		if (old_data < data_end) {
-			btrfs_print_leaf(root, leaf);
+			btrfs_print_leaf(leaf);
 			printk("slot %d old_data %d data_end %d\n",
 			       slot, old_data, data_end);
 			BUG_ON(1);
@@ -2583,7 +2583,7 @@ int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
 	}
 
 	if (btrfs_leaf_free_space(root->fs_info, leaf) < 0) {
-		btrfs_print_leaf(root, leaf);
+		btrfs_print_leaf(leaf);
 		BUG();
 	}
 
diff --git a/extent-tree.c b/extent-tree.c
index e2ae74a7fe66..ea205ccf4c30 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1070,7 +1070,7 @@ again:
 		printf("Size is %u, needs to be %u, slot %d\n",
 		       (unsigned)item_size,
 		       (unsigned)sizeof(*ei), path->slots[0]);
-		btrfs_print_leaf(root, leaf);
+		btrfs_print_leaf(leaf);
 		return -EINVAL;
 	}
 	BUG_ON(item_size < sizeof(*ei));
@@ -1587,7 +1587,7 @@ again:
 	}
 
 	if (ret != 0) {
-		btrfs_print_leaf(root, path->nodes[0]);
+		btrfs_print_leaf(path->nodes[0]);
 		printk("failed to find block number %Lu\n",
 			(unsigned long long)bytenr);
 		BUG();
@@ -2273,7 +2273,7 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 				printk(KERN_ERR "umm, got %d back from search"
 				       ", was looking for %llu\n", ret,
 				       (unsigned long long)bytenr);
-				btrfs_print_leaf(extent_root, path->nodes[0]);
+				btrfs_print_leaf(path->nodes[0]);
 			}
 			BUG_ON(ret);
 			extent_slot = path->slots[0];
@@ -2311,7 +2311,7 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 			printk(KERN_ERR "umm, got %d back from search"
 			       ", was looking for %llu\n", ret,
 			       (unsigned long long)bytenr);
-			btrfs_print_leaf(extent_root, path->nodes[0]);
+			btrfs_print_leaf(path->nodes[0]);
 		}
 		BUG_ON(ret);
 		extent_slot = path->slots[0];
diff --git a/print-tree.c b/print-tree.c
index 418ea5b4e7d4..a1a7954abdae 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -1173,8 +1173,9 @@ static void header_flags_to_str(u64 flags, char *ret)
 	}
 }
 
-void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *eb)
+void btrfs_print_leaf(struct extent_buffer *eb)
 {
+	struct btrfs_fs_info *fs_info = eb->fs_info;
 	struct btrfs_item *item;
 	struct btrfs_disk_key disk_key;
 	char flags_str[128];
@@ -1190,7 +1191,7 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *eb)
 
 	printf("leaf %llu items %d free space %d generation %llu owner ",
 		(unsigned long long)btrfs_header_bytenr(eb), nr,
-		btrfs_leaf_free_space(root->fs_info, eb),
+		btrfs_leaf_free_space(fs_info, eb),
 		(unsigned long long)btrfs_header_generation(eb));
 	print_objectid(stdout, btrfs_header_owner(eb), 0);
 	printf("\n");
@@ -1290,7 +1291,7 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *eb)
 			printf("\t\tcsum item\n");
 			break;
 		case BTRFS_EXTENT_CSUM_KEY:
-			print_extent_csum(eb, root->fs_info, item_size,
+			print_extent_csum(eb, fs_info, item_size,
 					offset);
 			break;
 		case BTRFS_EXTENT_DATA_KEY:
@@ -1351,10 +1352,11 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *eb)
 	}
 }
 
-void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *eb, int follow)
+void btrfs_print_tree(struct extent_buffer *eb, int follow)
 {
 	u32 i;
 	u32 nr;
+	struct btrfs_fs_info *fs_info = eb->fs_info;
 	struct btrfs_disk_key disk_key;
 	struct btrfs_key key;
 	struct extent_buffer *next;
@@ -1363,13 +1365,13 @@ void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *eb, int fol
 		return;
 	nr = btrfs_header_nritems(eb);
 	if (btrfs_is_leaf(eb)) {
-		btrfs_print_leaf(root, eb);
+		btrfs_print_leaf(eb);
 		return;
 	}
 	printf("node %llu level %d items %d free %u generation %llu owner ",
 	       (unsigned long long)eb->start,
 	        btrfs_header_level(eb), nr,
-		(u32)BTRFS_NODEPTRS_PER_BLOCK(root->fs_info) - nr,
+		(u32)BTRFS_NODEPTRS_PER_BLOCK(fs_info) - nr,
 		(unsigned long long)btrfs_header_generation(eb));
 	print_objectid(stdout, btrfs_header_owner(eb), 0);
 	printf("\n");
@@ -1383,7 +1385,7 @@ void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *eb, int fol
 		btrfs_print_key(&disk_key);
 		printf(" block %llu (%llu) gen %llu\n",
 		       (unsigned long long)blocknr,
-		       (unsigned long long)blocknr / root->fs_info->nodesize,
+		       (unsigned long long)blocknr / fs_info->nodesize,
 		       (unsigned long long)btrfs_node_ptr_generation(eb, i));
 		fflush(stdout);
 	}
@@ -1391,7 +1393,7 @@ void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *eb, int fol
 		return;
 
 	for (i = 0; i < nr; i++) {
-		next = read_tree_block(root->fs_info,
+		next = read_tree_block(fs_info,
 				btrfs_node_blockptr(eb, i),
 				btrfs_node_ptr_generation(eb, i));
 		if (!extent_buffer_uptodate(next)) {
@@ -1411,7 +1413,7 @@ void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *eb, int fol
 			free_extent_buffer(next);
 			continue;
 		}
-		btrfs_print_tree(root, next, 1);
+		btrfs_print_tree(next, 1);
 		free_extent_buffer(next);
 	}
 
diff --git a/print-tree.h b/print-tree.h
index df58b846788b..62667d7f6195 100644
--- a/print-tree.h
+++ b/print-tree.h
@@ -19,8 +19,8 @@
 #ifndef __PRINT_TREE_H__
 #define __PRINT_TREE_H__
 
-void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l);
-void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *t, int follow);
+void btrfs_print_leaf(struct extent_buffer *l);
+void btrfs_print_tree(struct extent_buffer *t, int follow);
 void btrfs_print_key(struct btrfs_disk_key *disk_key);
 void print_chunk_item(struct extent_buffer *eb, struct btrfs_chunk *chunk);
 void print_extent_item(struct extent_buffer *eb, int slot, int metadata);
-- 
2.16.3

