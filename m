Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45466 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750861AbeFAI1u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Jun 2018 04:27:50 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 47468AE28
        for <linux-btrfs@vger.kernel.org>; Fri,  1 Jun 2018 08:27:49 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v1.1] btrfs-progs: inspect-dump-tree: Allow '-b|--block' to be specified multiple times
Date: Fri,  1 Jun 2018 16:27:46 +0800
Message-Id: <20180601082746.3638-1-wqu@suse.com>
In-Reply-To: <20180601051526.19564-2-wqu@suse.com>
References: <20180601051526.19564-2-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Reuse extent-cache facility to record multiple bytenr so '-b|--block'
can be specified multiple times.

Despite that, add a sector size alignment check before we try to print a
tree block.
(Please note that, nodesize alignment check is not suitable here as meta
chunk start bytenr could be unaligned to nodesize)

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Documentation/btrfs-inspect-internal.asciidoc |   2 +-
 cmds-inspect-dump-tree.c                      | 109 +++++++++++++++---
 2 files changed, 91 insertions(+), 20 deletions(-)

diff --git a/Documentation/btrfs-inspect-internal.asciidoc b/Documentation/btrfs-inspect-internal.asciidoc
index e2db64660b9a..ba8529f57660 100644
--- a/Documentation/btrfs-inspect-internal.asciidoc
+++ b/Documentation/btrfs-inspect-internal.asciidoc
@@ -86,7 +86,7 @@ the respective tree root block offset
 -u|--uuid::::
 print only the uuid tree information, empty output if the tree does not exist
 -b <block_num>::::
-print info of the specified block only
+print info of the specified block only, can be specified multiple times.
 --follow::::
 use with '-b', print all children tree blocks of '<block_num>'
 -t <tree_id>::::
diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index 92a2a45b267e..d67406141394 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -198,11 +198,92 @@ const char * const cmd_inspect_dump_tree_usage[] = {
 	"-R|--backups           same as --roots plus print backup root info",
 	"-u|--uuid              print only the uuid tree",
 	"-b|--block <block_num> print info from the specified block only",
+	"                       can be specified multiple times",
 	"-t|--tree <tree_id>    print only tree with the given id (string or number)",
 	"--follow               use with -b, to show all children tree blocks of <block_num>",
 	NULL
 };
 
+/*
+ * Helper function to record all tree block bytenr so we don't need to put
+ * all code into deep indent.
+ *
+ * Return >0 if we hit a duplicated bytenr (already recorded)
+ * Return 0 if nothing went wrong
+ * Return <0 if error happens (ENOMEM)
+ *
+ * For != 0 return value, all warning/error will be outputted by this function.
+ */
+static int dump_add_tree_block(struct cache_tree *tree, u64 bytenr)
+{
+	int ret;
+
+	/*
+	 * We don't really care about the size and we don't have
+	 * nodesize before we open the fs, so just use 1 as size here.
+	 */
+	ret = add_cache_extent(tree, bytenr, 1);
+	if (ret == -EEXIST) {
+		warning("tree block bytenr %llu is duplicated", bytenr);
+		return 1;
+	}
+	if (ret < 0) {
+		error("failed to record tree block bytenr %llu: %d(%s)",
+			bytenr, ret, strerror(-ret));
+		return ret;
+	}
+	return ret;
+}
+
+/*
+ * Print all tree blocks recorded.
+ * All tree block bytenr record will also be freed in this function.
+ *
+ * Return 0 if nothing wrong happened for *each* tree blocks
+ * Return <0 if anything wrong happened, and return value will be the last
+ * error.
+ */
+static int dump_print_tree_blocks(struct btrfs_fs_info *fs_info,
+				  struct cache_tree *tree, bool follow)
+{
+	struct cache_extent *ce;
+	struct extent_buffer *eb;
+	u64 bytenr;
+	int ret = 0;
+
+	ce = first_cache_extent(tree);
+	while (ce) {
+		bytenr = ce->start;
+
+		/*
+		 * Please note that here we can't check it against nodesize,
+		 * as it's possible a chunk is just aligned to sectorsize but
+		 * not aligned to nodesize.
+		 */
+		if (!IS_ALIGNED(bytenr, fs_info->sectorsize)) {
+			error(
+		"tree block bytenr %llu is not aligned to sectorsize %u",
+			      bytenr, fs_info->sectorsize);
+			ret = -EINVAL;
+			goto next;
+		}
+
+		eb = read_tree_block(fs_info, bytenr, 0);
+		if (!extent_buffer_uptodate(eb)) {
+			error("failed to read tree block %llu", bytenr);
+			ret = -EIO;
+			goto next;
+		}
+		btrfs_print_tree(eb, follow);
+		free_extent_buffer(eb);
+next:
+		remove_cache_extent(tree, ce);
+		free(ce);
+		ce = first_cache_extent(tree);
+	}
+	return ret;
+}
+
 int cmd_inspect_dump_tree(int argc, char **argv)
 {
 	struct btrfs_root *root;
@@ -213,6 +294,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 	struct extent_buffer *leaf;
 	struct btrfs_disk_key disk_key;
 	struct btrfs_key found_key;
+	struct cache_tree block_root;	/* for multiple --block parameters */
 	char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
 	int ret;
 	int slot;
@@ -222,7 +304,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 	int roots_only = 0;
 	int root_backups = 0;
 	unsigned open_ctree_flags;
-	u64 block_only = 0;
+	u64 block_bytenr;
 	struct btrfs_root *tree_root_scan;
 	u64 tree_id = 0;
 	bool follow = false;
@@ -235,6 +317,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 	 * tree blocks as possible.
 	 */
 	open_ctree_flags = OPEN_CTREE_PARTIAL | OPEN_CTREE_NO_BLOCK_GROUPS;
+	cache_tree_init(&block_root);
 	while (1) {
 		int c;
 		enum { GETOPT_VAL_FOLLOW = 256 };
@@ -276,7 +359,10 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 			 * other than chunk root
 			 */
 			open_ctree_flags |= __OPEN_CTREE_RETURN_CHUNK_ROOT;
-			block_only = arg_strtou64(optarg);
+			block_bytenr = arg_strtou64(optarg);
+			ret = dump_add_tree_block(&block_root, block_bytenr);
+			if (ret < 0)
+				goto out;
 			break;
 		case 't': {
 			const char *end = NULL;
@@ -324,24 +410,9 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 		goto out;
 	}
 
-	if (block_only) {
+	if (!cache_tree_empty(&block_root)) {
 		root = info->chunk_root;
-		leaf = read_tree_block(info, block_only, 0);
-		if (extent_buffer_uptodate(leaf) &&
-		    btrfs_header_level(leaf) != 0) {
-			free_extent_buffer(leaf);
-			leaf = NULL;
-		}
-
-		if (!leaf)
-			leaf = read_tree_block(info, block_only, 0);
-		if (!extent_buffer_uptodate(leaf)) {
-			error("failed to read %llu",
-				(unsigned long long)block_only);
-			goto close_root;
-		}
-		btrfs_print_tree(leaf, follow);
-		free_extent_buffer(leaf);
+		ret = dump_print_tree_blocks(info, &block_root, follow);
 		goto close_root;
 	}
 
-- 
2.17.1

