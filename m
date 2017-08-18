Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:51744 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750810AbdHRJgi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 05:36:38 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, jared.e.vb@gmail.com
Subject: [PATCH] btrfs-progs: Allow inspect dump-tree to show specified tree block even some tree roots are corrupted
Date: Fri, 18 Aug 2017 18:36:30 +0900
Message-Id: <20170818093630.9892-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For btrfs inspect-internal dump-tree, if we use "-b" parameter to show
specified tree block, then we don't really need extra tree roots.

Only chunk root is needed to build up the whole chunk mapping so we can
read tree blocks.

This patch will add __OPEN_CTREE_RETURN_CHUNK_ROOT flag when show
speicifed tree block.
So even root tree is corrupted, we can still use inspect-internal
dump-tree to do some debugging.

Reported-by: Zirconium Hacker <jared.e.vb@gmail.com>
Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
 cmds-inspect-dump-tree.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index 93dff086..876ddcb5 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -222,6 +222,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 	int uuid_tree_only = 0;
 	int roots_only = 0;
 	int root_backups = 0;
+	unsigned open_ctree_flags = OPEN_CTREE_FS_PARTIAL;
 	u64 block_only = 0;
 	struct btrfs_root *tree_root_scan;
 	u64 tree_id = 0;
@@ -260,6 +261,11 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 			root_backups = 1;
 			break;
 		case 'b':
+			/*
+			 * If only showing one block, no need to fill roots
+			 * other than chunk root
+			 */
+			open_ctree_flags |= __OPEN_CTREE_RETURN_CHUNK_ROOT;
 			block_only = arg_strtou64(optarg);
 			break;
 		case 't': {
@@ -299,19 +305,14 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 
 	printf("%s\n", PACKAGE_STRING);
 
-	info = open_ctree_fs_info(argv[optind], 0, 0, 0, OPEN_CTREE_PARTIAL);
+	info = open_ctree_fs_info(argv[optind], 0, 0, 0, open_ctree_flags);
 	if (!info) {
 		error("unable to open %s", argv[optind]);
 		goto out;
 	}
 
-	root = info->fs_root;
-	if (!root) {
-		error("unable to open %s", argv[optind]);
-		goto out;
-	}
-
 	if (block_only) {
+		root = info->chunk_root;
 		leaf = read_tree_block(info,
 				      block_only,
 				      info->nodesize, 0);
@@ -337,6 +338,12 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 		goto close_root;
 	}
 
+	root = info->fs_root;
+	if (!root) {
+		error("unable to open %s", argv[optind]);
+		goto out;
+	}
+
 	if (!(extent_only || uuid_tree_only || tree_id)) {
 		if (roots_only) {
 			printf("root tree: %llu level %d\n",
-- 
2.14.0

