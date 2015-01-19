Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52325 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751522AbbASGr0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Jan 2015 01:47:26 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0J6kmKR022593
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Jan 2015 14:46:48 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 10/10] btrfs-progs: Allow open_ctree use backup tree root or search it automatically if primary tree root is corrupted.
Date: Mon, 19 Jan 2015 14:45:12 +0800
Message-ID: <1421649912-14539-11-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1421649912-14539-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1421649912-14539-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Allow open_ctree to try its best to open tree root on damaged file system.

With this patch, open_ctree will follow the below priority to read tree
root, providing better chance to open damaged btrfs fs.
1) Using root bytenr in SB to read tree root
Normal routine if not specified to use backup roots or specified root
tree bytenr.

2) Using backup root if specified or 1) fails
Backup will be automatically used without user specification if
normal routine fails

3) Try to search possible tree root in all its metadata chunks
The last chance, searching through all the metadata space.
May takes a long time but still worth a try since above methods all
fails.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 disk-io.c | 104 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 96 insertions(+), 8 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 71ca31f..6673a99 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -35,6 +35,7 @@
 #include "utils.h"
 #include "print-tree.h"
 #include "rbtree-utils.h"
+#include "find-root.h"
 
 static int check_tree_block(struct btrfs_root *root, struct extent_buffer *buf)
 {
@@ -894,9 +895,33 @@ int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info, u64 root_tree_bytenr,
 	blocksize = btrfs_level_size(root, btrfs_super_root_level(sb));
 	generation = btrfs_super_generation(sb);
 
-	if (!root_tree_bytenr && !(flags & OPEN_CTREE_BACKUP_ROOT)) {
+	/*
+	 * If root bytenr is specified, use it and if fails, just return error,
+	 * not to try other method.
+	 */
+	if (root_tree_bytenr) {
+		root->node = read_tree_block(root, root_tree_bytenr,
+					     blocksize, generation);
+		if (!extent_buffer_uptodate(root->node)) {
+			fprintf(stderr, "Couldn't read tree root at %llu\n",
+				root_tree_bytenr);
+			return -EIO;
+		} else
+			goto extent_tree;
+	}
+	/* Normal root bytenr from super */
+	if (!(flags & OPEN_CTREE_BACKUP_ROOT)) {
 		root_tree_bytenr = btrfs_super_root(sb);
-	} else if (flags & OPEN_CTREE_BACKUP_ROOT) {
+		root->node = read_tree_block(root, root_tree_bytenr,
+					     blocksize, generation);
+		if (!extent_buffer_uptodate(root->node)) {
+			fprintf(stderr,
+				"Couldn't read tree root, try backup\n");
+			ret = -EAGAIN;
+		} else
+			goto extent_tree;
+	}
+	if ((flags & OPEN_CTREE_BACKUP_ROOT) || ret == -EAGAIN) {
 		struct btrfs_root_backup *backup;
 		int index = find_best_backup_root(sb);
 		if (index >= BTRFS_NUM_BACKUP_ROOTS) {
@@ -906,15 +931,78 @@ int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info, u64 root_tree_bytenr,
 		backup = fs_info->super_copy->super_roots + index;
 		root_tree_bytenr = btrfs_backup_tree_root(backup);
 		generation = btrfs_backup_tree_root_gen(backup);
+		root->node = read_tree_block(root, root_tree_bytenr,
+					     blocksize, generation);
+		if (!extent_buffer_uptodate(root->node)) {
+			fprintf(stderr,
+				"Couldn't read backup tree root, try searching tree root\n");
+			ret = -EAGAIN;
+		} else {
+			ret = 0;
+			goto extent_tree;
+		}
 	}
 
-	root->node = read_tree_block(root, root_tree_bytenr, blocksize,
-				     generation);
-	if (!extent_buffer_uptodate(root->node)) {
-		fprintf(stderr, "Couldn't read tree root\n");
-		return -EIO;
-	}
+	/* Last chance, search the tree root */
+	if (ret == -EAGAIN) {
+		struct btrfs_find_root_filter filter = {0};
+		struct btrfs_find_root_gen_cache *gen_cache;
+		struct cache_tree result;
+		struct cache_extent *cache;
+		struct cache_extent *tree_block;
+
+		filter.objectid = BTRFS_ROOT_TREE_OBJECTID;
+		cache_tree_init(&result);
+
+		printf("Searching tree root, may take some time\n");
+		ret = btrfs_find_root_search(fs_info->chunk_root, &filter,
+					     &result, NULL);
+		if (ret < 0) {
+			fprintf(stderr, "Couldn't search tree root: %s\n",
+				strerror(-ret));
+			btrfs_find_root_free(&result);
+			return ret;
+		}
+		if (cache_tree_empty(&result)) {
+			fprintf(stderr, "Fail to find any tree root\n");
+			btrfs_find_root_free(&result);
+			return -ENOENT;
+		}
 
+		/* Find the newest root as tree root */
+		root_tree_bytenr = 0;
+		cache = last_cache_extent(&result);
+		while (cache) {
+			gen_cache = container_of(cache,
+					struct btrfs_find_root_gen_cache,
+					cache);
+			if (last_cache_extent(&gen_cache->eb_tree) !=
+			    first_cache_extent(&gen_cache->eb_tree)) {
+				cache = prev_cache_extent(cache);
+				continue;
+			}
+			tree_block = first_cache_extent(&gen_cache->eb_tree);
+			root_tree_bytenr = tree_block->start;
+			generation = gen_cache->cache.start;
+			break;
+		}
+		btrfs_find_root_free(&result);
+		if (!root_tree_bytenr) {
+			fprintf(stderr,
+				"Couldn't find any valid old tree root\n");
+			return -EINVAL;
+		} else
+			printf("Using tree root at %llu, gen: %llu\n",
+			       root_tree_bytenr, generation);
+		root->node = read_tree_block(root, root_tree_bytenr,
+					     blocksize, generation);
+		if (!extent_buffer_uptodate(root->node)) {
+			fprintf(stderr,
+				"Couldn't read the most possible tree root\n");
+			return -EIO;
+		}
+	}
+extent_tree:
 	ret = setup_root_or_create_block(fs_info, flags, fs_info->extent_root,
 					 BTRFS_EXTENT_TREE_OBJECTID, "extent");
 	if (ret)
-- 
2.2.2

