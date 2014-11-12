Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:30933 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753281AbaKLFvu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Nov 2014 00:51:50 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sAC5pZej008672
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Nov 2014 13:51:35 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/4] btrfs-progs: Automatic using backup tree root or searching tree root if fail to read it.
Date: Wed, 12 Nov 2014 13:52:14 +0800
Message-ID: <1415771534-7979-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1415771534-7979-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1415771534-7979-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Allow open_ctree to try its best to open tree root on damaged file
system.

With this patch, open_ctree will follow the below procedure to read tree
root to provide a better chance to open damaged btrfs fs.
1) Using root bytenr in SB to read tree root
Normal routine if not specified to use backup roots.

2) Using backup root if specified or 1) fails
Backup will be automatically used without user specification if normal
routine fails

3) Try to search possible tree root in all its metadata chunks
The last chance, searching through all the metadata space.
May takes a long time but still worth a try since above methods all
fails.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 disk-io.c | 90 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 83 insertions(+), 7 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 45fd58a..7292557 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -35,6 +35,7 @@
 #include "utils.h"
 #include "print-tree.h"
 #include "rbtree-utils.h"
+#include "find-root.h"
 
 static int check_tree_block(struct btrfs_root *root, struct extent_buffer *buf)
 {
@@ -865,9 +866,34 @@ int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info, u64 root_tree_bytenr,
 	blocksize = btrfs_level_size(root, btrfs_super_root_level(sb));
 	generation = btrfs_super_generation(sb);
 
-	if (!root_tree_bytenr && !(flags & OPEN_CTREE_BACKUP_ROOT)) {
+	/*
+	 * If use specific the root bytenr, use it and if fails,
+	 * just return error, stop trying other method.
+	 */
+	if (root_tree_bytenr) {
+		root->node = read_tree_block(root, root_tree_bytenr, blocksize,
+					     generation);
+		if (!extent_buffer_uptodate(root->node)) {
+			fprintf(stderr, "Couldn't read tree root\n");
+			return -EIO;
+		} else
+			goto extent_tree;
+	}
+
+	/* Normal root bytenr from super */
+	if (!(flags & OPEN_CTREE_BACKUP_ROOT)) {
 		root_tree_bytenr = btrfs_super_root(sb);
-	} else if (flags & OPEN_CTREE_BACKUP_ROOT) {
+		root->node = read_tree_block(root, root_tree_bytenr, blocksize,
+					     generation);
+		if (!extent_buffer_uptodate(root->node)) {
+			fprintf(stderr, "Couldn't read tree root, try backup\n");
+			ret = -EAGAIN;
+		} else
+			goto extent_tree;
+	}
+
+	/* Backup tree roots */
+	if ((flags & OPEN_CTREE_BACKUP_ROOT) || ret == -EAGAIN) {
 		struct btrfs_root_backup *backup;
 		int index = find_best_backup_root(sb);
 		if (index >= BTRFS_NUM_BACKUP_ROOTS) {
@@ -877,15 +903,65 @@ int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info, u64 root_tree_bytenr,
 		backup = fs_info->super_copy->super_roots + index;
 		root_tree_bytenr = btrfs_backup_tree_root(backup);
 		generation = btrfs_backup_tree_root_gen(backup);
+		root->node = read_tree_block(root, root_tree_bytenr, blocksize,
+					     generation);
+		if (!extent_buffer_uptodate(root->node)) {
+			fprintf(stderr, "Couldn't read backup tree root, try searching tree root\n");
+			ret = -EAGAIN;
+		} else
+			goto extent_tree;
 	}
 
-	root->node = read_tree_block(root, root_tree_bytenr, blocksize,
-				     generation);
-	if (!extent_buffer_uptodate(root->node)) {
-		fprintf(stderr, "Couldn't read tree root\n");
-		return -EIO;
+	/* Last chance, searching the tree root */
+	if (ret == -EAGAIN) {
+		struct find_root_search_filter search;
+		struct list_head result_list;
+		struct find_root_gen_entry *gene;
+		struct find_root_eb_entry *ebe;
+
+		search.super_gen = btrfs_super_generation(fs_info->super_copy);
+		search.objectid = BTRFS_ROOT_TREE_OBJECTID;
+		search.search_all = 0;
+		search.level = 0;
+		search.generation = 0;
+		INIT_LIST_HEAD(&result_list);
+
+		printf("Searching tree root...");
+		ret = find_root_start(fs_info->chunk_root, &result_list,
+				      &search);
+		if (ret < 0) {
+			fprintf(stderr, "Fail to search the tree root\n");
+			find_root_free(&result_list);
+			return -EIO;
+		}
+
+		if (list_empty(&result_list)) {
+			fprintf(stderr, "Fail to find and tree root\n");
+			find_root_free(&result_list);
+			return -EIO;
+		}
+		gene = list_entry(result_list.prev, struct find_root_gen_entry,
+				  gen_list);
+		if ((gene->eb_list.next)->next != (&gene->eb_list)) {
+			/* Serveral same level leaf found, not root */
+			fprintf(stderr, "Fail to find and tree root\n");
+			find_root_free(&result_list);
+			return -EIO;
+		}
+		/* Not the most possible root is found use it  */
+		ebe = list_entry(gene->eb_list.next, struct find_root_eb_entry,
+				 list);
+		root_tree_bytenr = btrfs_header_bytenr(ebe->eb);
+		find_root_free(&result_list);
+		root->node = read_tree_block(root, root_tree_bytenr, blocksize,
+					     generation);
+		if (!extent_buffer_uptodate(root->node)) {
+			fprintf(stderr, "Couldn't read most possible tree root\n");
+			return -EIO;
+		}
 	}
 
+extent_tree:
 	ret = find_and_setup_root(root, fs_info, BTRFS_EXTENT_TREE_OBJECTID,
 				  fs_info->extent_root);
 	if (ret) {
-- 
2.1.3

