Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:36430 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933296AbaLJVFk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 16:05:40 -0500
Received: from mail-in-05-z2.arcor-online.net (mail-in-05-z2.arcor-online.net [151.189.8.17])
	by mx.arcor.de (Postfix) with ESMTP id DD19982BF
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 22:05:38 +0100 (CET)
From: mwilck@arcor.de
To: linux-btrfs@vger.kernel.org
Cc: mwilck@arcor.de
Subject: [PATCH 02/18] btrfs-progs: btrfs-debug-tree: add option -B (backup root)
Date: Wed, 10 Dec 2014 21:51:32 +0100
Message-Id: <1418244708-7087-3-git-send-email-mwilck@arcor.de>
In-Reply-To: <1418244708-7087-1-git-send-email-mwilck@arcor.de>
References: <1418244708-7087-1-git-send-email-mwilck@arcor.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Martin Wilck <mwilck@arcor.de>

Option -B causes btrfs-debug-tree to dump the tree rooted at
the backup root number given instead of the real root.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 btrfs-debug-tree.c |   39 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 38 insertions(+), 1 deletions(-)

diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
index e61c71c..7cdc368 100644
--- a/btrfs-debug-tree.c
+++ b/btrfs-debug-tree.c
@@ -45,6 +45,8 @@ static int print_usage(void)
 		" block\n");
 	fprintf(stderr,
 		"\t-t tree_id : print only the tree with the given id\n");
+	fprintf(stderr,
+		"\t-B nr: use root backup <nr> instead of real root\n");
 	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
 	exit(1);
 }
@@ -140,6 +142,7 @@ int main(int ac, char **av)
 	int root_backups = 0;
 	u64 block_only = 0;
 	int block_follow = 0;
+	int use_backup = -1;
 	struct btrfs_root *tree_root_scan;
 	u64 tree_id = 0;
 
@@ -147,7 +150,7 @@ int main(int ac, char **av)
 
 	while(1) {
 		int c;
-		c = getopt(ac, av, "defb:rRut:");
+		c = getopt(ac, av, "defb:rRut:B:");
 		if (c < 0)
 			break;
 		switch(c) {
@@ -176,6 +179,9 @@ int main(int ac, char **av)
 			case 't':
 				tree_id = arg_strtou64(optarg);
 				break;
+			case 'B':
+				use_backup = arg_strtou64(optarg);
+				break;
 			default:
 				print_usage();
 		}
@@ -221,6 +227,37 @@ int main(int ac, char **av)
 		goto close_root;
 	}
 
+	if (use_backup >= BTRFS_NUM_BACKUP_ROOTS) {
+		fprintf(stderr, "Invalid backup root number %d\n",
+			use_backup);
+		exit(1);
+	} else if (use_backup >= 0) {
+		u64 bytenr, generation;
+		u32 blocksize;
+		struct btrfs_super_block *sb = info->super_copy;
+		struct btrfs_root_backup *backup = sb->super_roots + use_backup;
+		struct extent_buffer *eb;
+		bytenr = btrfs_backup_tree_root(backup);
+		generation = btrfs_backup_tree_root_gen(backup);
+		blocksize = btrfs_level_size(info->tree_root,
+					     btrfs_super_root_level(sb));
+		eb = info->tree_root->node;
+		info->tree_root->node = read_tree_block(root, bytenr,
+							blocksize, generation);
+		free_extent_buffer(eb);
+		bytenr = btrfs_backup_chunk_root(backup);
+		generation = btrfs_backup_chunk_root_gen(backup);
+		eb =  info->chunk_root->node;
+		info->chunk_root->node = read_tree_block(root, bytenr,
+							blocksize, generation);
+		free_extent_buffer(eb);
+		if (!extent_buffer_uptodate(info->tree_root->node) ||
+		    !extent_buffer_uptodate(info->tree_root->node)) {
+			fprintf(stderr, "Couldn't backup root\n");
+			return 1;
+		}
+	}
+
 	if (!(extent_only || uuid_tree_only || tree_id)) {
 		if (roots_only) {
 			printf("root tree: %llu level %d\n",
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
