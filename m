Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47008 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726068AbeHWK7b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Aug 2018 06:59:31 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 73729AFF7
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2018 07:31:12 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: dump-tree: Introduce --breadth-first option
Date: Thu, 23 Aug 2018 15:31:07 +0800
Message-Id: <20180823073107.17016-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

By default dump-tree does depth-first search.

For 2 level trees it's completely OK, but for 3 level trees, it would be
pretty hard to locate output of middle level tree nodes.

Introduce --breadth-first option to do breadth-first tree dump.
This is especially handy to inspect high level trees, e.g. comparing
tree reloc tree with its source tree.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Documentation/btrfs-inspect-internal.asciidoc |  5 ++
 cmds-inspect-dump-tree.c                      | 26 ++++--
 print-tree.c                                  | 89 +++++++++++++++++++
 print-tree.h                                  |  1 +
 4 files changed, 112 insertions(+), 9 deletions(-)

diff --git a/Documentation/btrfs-inspect-internal.asciidoc b/Documentation/btrfs-inspect-internal.asciidoc
index e2db64660b9a..5435455fe099 100644
--- a/Documentation/btrfs-inspect-internal.asciidoc
+++ b/Documentation/btrfs-inspect-internal.asciidoc
@@ -69,6 +69,9 @@ readable equivalents where possible.
 This is useful for analyzing filesystem state or inconsistencies and has
 a positive educational effect on understanding the internal filesystem structure.
 +
+By default *dump-tree* will dump the tree using depth-first search, this behavior
+can be changed by '--breadth-first' option.
++
 NOTE: contains file names, consider that if you're asked to send the dump for
 analysis. Does not contain file data.
 +
@@ -89,6 +92,8 @@ print only the uuid tree information, empty output if the tree does not exist
 print info of the specified block only
 --follow::::
 use with '-b', print all children tree blocks of '<block_num>'
+--breadth-first::::
+use breadth-first search to dump trees instead of default depth-first search
 -t <tree_id>::::
 print only the tree with the specified ID, where the ID can be numerical or
 common name in a flexible human readable form
diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index c8acd55a0c3a..ecda07d65ab6 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -200,6 +200,7 @@ const char * const cmd_inspect_dump_tree_usage[] = {
 	"-b|--block <block_num> print info from the specified block only",
 	"-t|--tree <tree_id>    print only tree with the given id (string or number)",
 	"--follow               use with -b, to show all children tree blocks of <block_num>",
+	"--breadth-first        do breadth-first search instead of default depth-first one",
 	NULL
 };
 
@@ -213,6 +214,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 	struct extent_buffer *leaf;
 	struct btrfs_disk_key disk_key;
 	struct btrfs_key found_key;
+	void (*print_tree_func) (struct extent_buffer *, int follow);
 	char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
 	int ret;
 	int slot;
@@ -227,6 +229,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 	u64 tree_id = 0;
 	bool follow = false;
 
+	print_tree_func = btrfs_print_tree;
 	/*
 	 * For debug-tree, we care nothing about extent tree (it's just backref
 	 * and usage accounting, only makes sense for RW operations).
@@ -238,7 +241,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 	optind = 0;
 	while (1) {
 		int c;
-		enum { GETOPT_VAL_FOLLOW = 256 };
+		enum { GETOPT_VAL_FOLLOW = 256, GETOPT_VAL_BREADTH_FIRST };
 		static const struct option long_options[] = {
 			{ "extents", no_argument, NULL, 'e'},
 			{ "device", no_argument, NULL, 'd'},
@@ -248,6 +251,8 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 			{ "block", required_argument, NULL, 'b'},
 			{ "tree", required_argument, NULL, 't'},
 			{ "follow", no_argument, NULL, GETOPT_VAL_FOLLOW },
+			{ "breadth-first", no_argument, NULL,
+				GETOPT_VAL_BREADTH_FIRST },
 			{ NULL, 0, NULL, 0 }
 		};
 
@@ -303,6 +308,9 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 		case GETOPT_VAL_FOLLOW:
 			follow = true;
 			break;
+		case GETOPT_VAL_BREADTH_FIRST:
+			print_tree_func = btrfs_print_tree_breadth_first;
+			break;
 		default:
 			usage(cmd_inspect_dump_tree_usage);
 		}
@@ -341,7 +349,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 				(unsigned long long)block_only);
 			goto close_root;
 		}
-		btrfs_print_tree(leaf, follow);
+		print_tree_func(leaf, follow);
 		free_extent_buffer(leaf);
 		goto close_root;
 	}
@@ -368,17 +376,17 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 		} else {
 			if (info->tree_root->node) {
 				printf("root tree\n");
-				btrfs_print_tree(info->tree_root->node, 1);
+				print_tree_func(info->tree_root->node, 1);
 			}
 
 			if (info->chunk_root->node) {
 				printf("chunk tree\n");
-				btrfs_print_tree(info->chunk_root->node, 1);
+				print_tree_func(info->chunk_root->node, 1);
 			}
 
 			if (info->log_root_tree) {
 				printf("log root tree\n");
-				btrfs_print_tree(info->log_root_tree->node, 1);
+				print_tree_func(info->log_root_tree->node, 1);
 			}
 		}
 	}
@@ -398,7 +406,7 @@ again:
 			goto close_root;
 		}
 		printf("root tree\n");
-		btrfs_print_tree(info->tree_root->node, 1);
+		print_tree_func(info->tree_root->node, 1);
 		goto close_root;
 	}
 
@@ -408,7 +416,7 @@ again:
 			goto close_root;
 		}
 		printf("chunk tree\n");
-		btrfs_print_tree(info->chunk_root->node, 1);
+		print_tree_func(info->chunk_root->node, 1);
 		goto close_root;
 	}
 
@@ -418,7 +426,7 @@ again:
 			goto close_root;
 		}
 		printf("log root tree\n");
-		btrfs_print_tree(info->log_root_tree->node, 1);
+		print_tree_func(info->log_root_tree->node, 1);
 		goto close_root;
 	}
 
@@ -564,7 +572,7 @@ again:
 					       btrfs_header_level(buf));
 				} else {
 					printf(" \n");
-					btrfs_print_tree(buf, 1);
+					print_tree_func(buf, 1);
 				}
 			}
 			free_extent_buffer(buf);
diff --git a/print-tree.c b/print-tree.c
index 31f6fa12522f..0717a2d882c5 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -1458,3 +1458,92 @@ void btrfs_print_tree(struct extent_buffer *eb, int follow)
 
 	return;
 }
+
+struct bfs_entry {
+	struct list_head list;
+	u64 bytenr;
+};
+
+/*
+ * breadth-first search version of btrfs_print_tree().
+ *
+ * Useful for high tree levels
+ */
+void btrfs_print_tree_breadth_first(struct extent_buffer *eb, int follow)
+{
+	LIST_HEAD(search_list);
+	struct bfs_entry *entry;
+
+	if (!eb)
+		return;
+	if (!follow) {
+		btrfs_print_tree(eb, follow);
+		return;
+	}
+	entry = malloc(sizeof(*entry));
+	if (!entry) {
+		error("failed to alloc memory for breadth-first search");
+		return;
+	}
+	entry->bytenr = eb->start;
+	list_add_tail(&entry->list, &search_list);
+	while (!list_empty(&search_list)) {
+		struct extent_buffer *current;
+		struct extent_buffer *child;
+		u64 bytenr;
+		int i;
+		int nr;
+
+		entry = list_entry(search_list.next, struct bfs_entry, list);
+		bytenr = entry->bytenr;
+		list_del(&entry->list);
+		free(entry);
+
+		current = read_tree_block(eb->fs_info, bytenr, 0);
+		btrfs_print_tree(current, 0);
+
+		if (!btrfs_header_level(current)) {
+			free_extent_buffer(current);
+			continue;
+		}
+
+		nr = btrfs_header_nritems(current);
+
+		/* Do child tree block check and queue them for later print */
+		for (i = 0; i < nr; i++) {
+			u64 blockptr = btrfs_node_blockptr(current, i);
+
+			/* read_tree_block will do transid check */
+			child = read_tree_block(eb->fs_info, blockptr,
+					btrfs_node_ptr_generation(current, i));
+			if (!extent_buffer_uptodate(child)) {
+				error("failed to read %llu in tree %llu\n",
+					blockptr,
+					btrfs_header_owner(current));
+				continue;
+			}
+			if (btrfs_header_level(current) !=
+			    btrfs_header_level(child) + 1) {
+				warning(
+"eb corrupted: parent bytenr %llu slot %d level %d child bytenr %llu level has %d expect %d, skipping the slot",
+					btrfs_header_bytenr(current), i,
+					btrfs_header_level(current),
+					btrfs_header_bytenr(child),
+					btrfs_header_level(child),
+					btrfs_header_level(current) + 1);
+				free_extent_buffer(child);
+				continue;
+			}
+			free_extent_buffer(child);
+			entry = malloc(sizeof(*entry));
+			if (!entry) {
+				error(
+			"failed to alloc memory for breadth-first search");
+				continue;
+			}
+			entry->bytenr = blockptr;
+			list_add_tail(&entry->list, &search_list);
+		}
+		free_extent_buffer(current);
+	}
+}
diff --git a/print-tree.h b/print-tree.h
index 62667d7f6195..1bf3906bacbd 100644
--- a/print-tree.h
+++ b/print-tree.h
@@ -21,6 +21,7 @@
 
 void btrfs_print_leaf(struct extent_buffer *l);
 void btrfs_print_tree(struct extent_buffer *t, int follow);
+void btrfs_print_tree_breadth_first(struct extent_buffer *eb, int follow);
 void btrfs_print_key(struct btrfs_disk_key *disk_key);
 void print_chunk_item(struct extent_buffer *eb, struct btrfs_chunk *chunk);
 void print_extent_item(struct extent_buffer *eb, int slot, int metadata);
-- 
2.18.0
