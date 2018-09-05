Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34118 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726272AbeIEK6O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Sep 2018 06:58:14 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 479D0AEEA
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Sep 2018 06:29:35 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/4] btrfs-progs: print-tree: Use breadth-first search for btrfs_print_tree()
Date: Wed,  5 Sep 2018 14:29:24 +0800
Message-Id: <20180905062924.23836-5-wqu@suse.com>
In-Reply-To: <20180905062924.23836-1-wqu@suse.com>
References: <20180905062924.23836-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_print_tree() uses depth-first search to print a subtree, it works
fine until we have 3 level tree.

In that case, leaves and nodes will be printed in a depth-first order,
making it pretty hard to locate level 1 nodes.

This patch will use breadth-first search for btrfs_print_tree().
It will use btrfs_path::lowest_level to indicate current level, and
print out tree blocks level by level (breadth-first).

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 print-tree.c | 99 ++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 73 insertions(+), 26 deletions(-)

diff --git a/print-tree.c b/print-tree.c
index 31f6fa12522f..0509ec3da46e 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -1381,6 +1381,78 @@ void btrfs_print_leaf(struct extent_buffer *eb)
 	}
 }
 
+/* Helper function to reach the most left tree block at @path->lowest_level */
+static int search_leftmost_tree_block(struct btrfs_fs_info *fs_info,
+				      struct btrfs_path *path, int root_level)
+{
+	int i;
+	int ret = 0;
+
+	/* Release all nodes expect path->nodes[root_level] */
+	for (i = 0; i < root_level; i++) {
+		path->slots[i] = 0;
+		if (!path->nodes[i])
+			continue;
+		free_extent_buffer(path->nodes[i]);
+	}
+
+	/* Reach the leftmost tree block by always reading out slot 0 */
+	for (i = root_level; i > path->lowest_level; i--) {
+		struct extent_buffer *eb;
+
+		path->slots[i] = 0;
+		eb = read_node_slot(fs_info, path->nodes[i], 0);
+		if (!extent_buffer_uptodate(eb)) {
+			ret = -EIO;
+			goto out;
+		}
+		path->nodes[i - 1] = eb;
+	}
+out:
+	return ret;
+}
+
+static void bfs_print_children(struct extent_buffer *root_eb)
+{
+	struct btrfs_fs_info *fs_info = root_eb->fs_info;
+	struct btrfs_path path;
+	int root_level = btrfs_header_level(root_eb);
+	int cur_level;
+	int ret;
+
+	if (root_level < 1)
+		return;
+
+	btrfs_init_path(&path);
+	/* For path */
+	extent_buffer_get(root_eb);
+	path.nodes[root_level] = root_eb;
+
+	for (cur_level = root_level - 1; cur_level >= 0; cur_level--) {
+		path.lowest_level = cur_level;
+
+		/* Use the leftmost tree block as start point */
+		ret = search_leftmost_tree_block(fs_info, &path, root_level);
+		if (ret < 0)
+			goto out;
+
+		/* Print all sibling tree blocks */
+		while (1) {
+			btrfs_print_tree(path.nodes[cur_level], 0);
+			ret = btrfs_next_sibling_tree_block(fs_info, &path);
+			if (ret < 0)
+				goto out;
+			if (ret > 0) {
+				ret = 0;
+				break;
+			}
+		}
+	}
+out:
+	btrfs_release_path(&path);
+	return;
+}
+
 void btrfs_print_tree(struct extent_buffer *eb, int follow)
 {
 	u32 i;
@@ -1389,7 +1461,6 @@ void btrfs_print_tree(struct extent_buffer *eb, int follow)
 	struct btrfs_fs_info *fs_info = eb->fs_info;
 	struct btrfs_disk_key disk_key;
 	struct btrfs_key key;
-	struct extent_buffer *next;
 
 	if (!eb)
 		return;
@@ -1431,30 +1502,6 @@ void btrfs_print_tree(struct extent_buffer *eb, int follow)
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
+	bfs_print_children(eb);
 	return;
 }
-- 
2.18.0
