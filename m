Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9686C04E87
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 02:06:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AA6B216E3
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 02:06:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8AA6B216E3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbeI1I0V (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 04:26:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:58302 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726118AbeI1I0V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 04:26:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C2E32ABB1
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 02:04:58 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 5/6] btrfs-progs: print-tree: Introduce --bfs and --dfs options
Date:   Fri, 28 Sep 2018 10:04:45 +0800
Message-Id: <20180928020446.21467-6-wqu@suse.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20180928020446.21467-1-wqu@suse.com>
References: <20180928020446.21467-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Originally print-tree uses depth first search to print trees.
This works fine until we reach 3 level trees (root node level is 2).

For tall trees whose root level is 2 or higher, DFS will mix nodes and
leaves like the following example:

Level 2                       A
                             / \
Level 1                     B   C
                          / |   | \
Level 0                  D  E   F  G

DFS will cause the following output sequence:
A   B   D   E   C   F   G
Which in term of node/leave is:
N   N   L   L   N   L   L

Such mixed node/leave result is sometimes hard for human to read.

This patch will introduce 2 new options, --bfs and --dfs.
--dfs keeps the original output sequence, and to keep things compatible
it's the default behavior.

While --bfs uses breadth-first search, and will cause better output
sequence like:
A   B   C   D   E   F   G
Which in term of node/leave is:
N   N   N   L   L   L   L

Much better sorted for human.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Documentation/btrfs-inspect-internal.asciidoc |  4 +
 cmds-inspect-dump-tree.c                      | 31 +++++---
 print-tree.c                                  | 73 ++++++++++++-------
 print-tree.h                                  | 14 +++-
 4 files changed, 84 insertions(+), 38 deletions(-)

diff --git a/Documentation/btrfs-inspect-internal.asciidoc b/Documentation/btrfs-inspect-internal.asciidoc
index e2db64660b9a..0abdb27ceb95 100644
--- a/Documentation/btrfs-inspect-internal.asciidoc
+++ b/Documentation/btrfs-inspect-internal.asciidoc
@@ -89,6 +89,10 @@ print only the uuid tree information, empty output if the tree does not exist
 print info of the specified block only
 --follow::::
 use with '-b', print all children tree blocks of '<block_num>'
+--dfs::::
+use depth-first search to print trees. (default)
+--bfs::::
+use breadth-first search to print trees.
 -t <tree_id>::::
 print only the tree with the specified ID, where the ID can be numerical or
 common name in a flexible human readable form
diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index c8acd55a0c3a..d78fa14356de 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -221,6 +221,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 	int uuid_tree_only = 0;
 	int roots_only = 0;
 	int root_backups = 0;
+	int traverse = BTRFS_PRINT_TREE_DEFAULT;
 	unsigned open_ctree_flags;
 	u64 block_only = 0;
 	struct btrfs_root *tree_root_scan;
@@ -238,7 +239,8 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 	optind = 0;
 	while (1) {
 		int c;
-		enum { GETOPT_VAL_FOLLOW = 256 };
+		enum { GETOPT_VAL_FOLLOW = 256, GETOPT_VAL_DFS,
+		       GETOPT_VAL_BFS };
 		static const struct option long_options[] = {
 			{ "extents", no_argument, NULL, 'e'},
 			{ "device", no_argument, NULL, 'd'},
@@ -248,6 +250,8 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 			{ "block", required_argument, NULL, 'b'},
 			{ "tree", required_argument, NULL, 't'},
 			{ "follow", no_argument, NULL, GETOPT_VAL_FOLLOW },
+			{ "bfs", no_argument, NULL, GETOPT_VAL_BFS },
+			{ "dfs", no_argument, NULL, GETOPT_VAL_DFS },
 			{ NULL, 0, NULL, 0 }
 		};
 
@@ -303,6 +307,12 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 		case GETOPT_VAL_FOLLOW:
 			follow = true;
 			break;
+		case GETOPT_VAL_DFS:
+			traverse = BTRFS_PRINT_TREE_DFS;
+			break;
+		case GETOPT_VAL_BFS:
+			traverse = BTRFS_PRINT_TREE_BFS;
+			break;
 		default:
 			usage(cmd_inspect_dump_tree_usage);
 		}
@@ -341,7 +351,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 				(unsigned long long)block_only);
 			goto close_root;
 		}
-		btrfs_print_tree(leaf, follow);
+		btrfs_print_tree(leaf, follow, BTRFS_PRINT_TREE_DEFAULT);
 		free_extent_buffer(leaf);
 		goto close_root;
 	}
@@ -368,17 +378,20 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 		} else {
 			if (info->tree_root->node) {
 				printf("root tree\n");
-				btrfs_print_tree(info->tree_root->node, 1);
+				btrfs_print_tree(info->tree_root->node, 1,
+						 traverse);
 			}
 
 			if (info->chunk_root->node) {
 				printf("chunk tree\n");
-				btrfs_print_tree(info->chunk_root->node, 1);
+				btrfs_print_tree(info->chunk_root->node, 1,
+						 traverse);
 			}
 
 			if (info->log_root_tree) {
 				printf("log root tree\n");
-				btrfs_print_tree(info->log_root_tree->node, 1);
+				btrfs_print_tree(info->log_root_tree->node, 1,
+						 traverse);
 			}
 		}
 	}
@@ -398,7 +411,7 @@ again:
 			goto close_root;
 		}
 		printf("root tree\n");
-		btrfs_print_tree(info->tree_root->node, 1);
+		btrfs_print_tree(info->tree_root->node, 1, traverse);
 		goto close_root;
 	}
 
@@ -408,7 +421,7 @@ again:
 			goto close_root;
 		}
 		printf("chunk tree\n");
-		btrfs_print_tree(info->chunk_root->node, 1);
+		btrfs_print_tree(info->chunk_root->node, 1, traverse);
 		goto close_root;
 	}
 
@@ -418,7 +431,7 @@ again:
 			goto close_root;
 		}
 		printf("log root tree\n");
-		btrfs_print_tree(info->log_root_tree->node, 1);
+		btrfs_print_tree(info->log_root_tree->node, 1, traverse);
 		goto close_root;
 	}
 
@@ -564,7 +577,7 @@ again:
 					       btrfs_header_level(buf));
 				} else {
 					printf(" \n");
-					btrfs_print_tree(buf, 1);
+					btrfs_print_tree(buf, 1, traverse);
 				}
 			}
 			free_extent_buffer(buf);
diff --git a/print-tree.c b/print-tree.c
index 685d2be8c35a..118fe9531d7e 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -1438,7 +1438,8 @@ static void bfs_print_children(struct extent_buffer *root_eb)
 
 		/* Print all sibling tree blocks */
 		while (1) {
-			btrfs_print_tree(path.nodes[cur_level], 0);
+			btrfs_print_tree(path.nodes[cur_level], 0,
+					 BTRFS_PRINT_TREE_BFS);
 			ret = btrfs_next_sibling_tree_block(fs_info, &path);
 			if (ret < 0)
 				goto out;
@@ -1453,7 +1454,41 @@ out:
 	return;
 }
 
-void btrfs_print_tree(struct extent_buffer *eb, int follow)
+static void dfs_print_children(struct extent_buffer *root_eb)
+{
+	struct btrfs_fs_info *fs_info = root_eb->fs_info;
+	struct extent_buffer *next;
+	int nr = btrfs_header_nritems(root_eb);
+	int root_eb_level = btrfs_header_level(root_eb);
+	int i;
+
+	for (i = 0; i < nr; i++) {
+		next = read_tree_block(fs_info,
+				btrfs_node_blockptr(root_eb, i),
+				btrfs_node_ptr_generation(root_eb, i));
+		if (!extent_buffer_uptodate(next)) {
+			fprintf(stderr, "failed to read %llu in tree %llu\n",
+				btrfs_node_blockptr(root_eb, i),
+				btrfs_header_owner(root_eb));
+			continue;
+		}
+		if (btrfs_header_level(next) != root_eb_level - 1) {
+			warning(
+"eb corrupted: parent bytenr %llu slot %d level %d child bytenr %llu level has %d expect %d, skipping the slot",
+				btrfs_header_bytenr(root_eb), i,
+				root_eb_level,
+				btrfs_header_bytenr(next),
+				btrfs_header_level(next),
+				root_eb_level - 1);
+			free_extent_buffer(next);
+			continue;
+		}
+		btrfs_print_tree(next, 1, BTRFS_PRINT_TREE_DFS);
+		free_extent_buffer(next);
+	}
+}
+
+void btrfs_print_tree(struct extent_buffer *eb, int follow, int traverse)
 {
 	u32 i;
 	u32 nr;
@@ -1461,10 +1496,13 @@ void btrfs_print_tree(struct extent_buffer *eb, int follow)
 	struct btrfs_fs_info *fs_info = eb->fs_info;
 	struct btrfs_disk_key disk_key;
 	struct btrfs_key key;
-	struct extent_buffer *next;
 
 	if (!eb)
 		return;
+	if (traverse != BTRFS_PRINT_TREE_DFS &&
+	    traverse != BTRFS_PRINT_TREE_BFS)
+		traverse = BTRFS_PRINT_TREE_DEFAULT;
+
 	nr = btrfs_header_nritems(eb);
 	if (btrfs_is_leaf(eb)) {
 		btrfs_print_leaf(eb);
@@ -1503,30 +1541,9 @@ void btrfs_print_tree(struct extent_buffer *eb, int follow)
 	if (follow && !fs_info)
 		return;
 
-	for (i = 0; i < nr; i++) {
-		next = read_tree_block(fs_info,
-				btrfs_node_blockptr(eb, i),
-				btrfs_node_ptr_generation(eb, i));
-		if (!extent_buffer_uptodate(next)) {
-			fprintf(stderr, "failed to read %llu in tree %llu\n",
-				(unsigned long long)btrfs_node_blockptr(eb, i),
-				(unsigned long long)btrfs_header_owner(eb));
-			continue;
-		}
-		if (btrfs_header_level(next) != btrfs_header_level(eb) - 1) {
-			warning(
-"eb corrupted: parent bytenr %llu slot %d level %d child bytenr %llu level has %d expect %d, skipping the slot",
-				btrfs_header_bytenr(eb), i,
-				btrfs_header_level(eb),
-				btrfs_header_bytenr(next),
-				btrfs_header_level(next),
-				btrfs_header_level(eb) - 1);
-			free_extent_buffer(next);
-			continue;
-		}
-		btrfs_print_tree(next, 1);
-		free_extent_buffer(next);
-	}
-
+	if (traverse == BTRFS_PRINT_TREE_DFS)
+		dfs_print_children(eb);
+	else
+		bfs_print_children(eb);
 	return;
 }
diff --git a/print-tree.h b/print-tree.h
index 62667d7f6195..1d8c8b09b0c5 100644
--- a/print-tree.h
+++ b/print-tree.h
@@ -20,7 +20,19 @@
 #define __PRINT_TREE_H__
 
 void btrfs_print_leaf(struct extent_buffer *l);
-void btrfs_print_tree(struct extent_buffer *t, int follow);
+
+/*
+ * Print a tree block (apply to both node and leaf).
+ *
+ * @t:		Tree block
+ * @follow:	Set non-zero to print all its children.
+ * @traverse:	The traverse order. Support DFS and BFS.
+ *		Will fallback to DFS for unknown order.
+ */
+#define BTRFS_PRINT_TREE_DFS		0
+#define BTRFS_PRINT_TREE_BFS		1
+#define BTRFS_PRINT_TREE_DEFAULT	BTRFS_PRINT_TREE_DFS
+void btrfs_print_tree(struct extent_buffer *t, int follow, int traverse);
 void btrfs_print_key(struct btrfs_disk_key *disk_key);
 void print_chunk_item(struct extent_buffer *eb, struct btrfs_chunk *chunk);
 void print_extent_item(struct extent_buffer *eb, int slot, int metadata);
-- 
2.19.0

