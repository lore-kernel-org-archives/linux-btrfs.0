Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60017 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751430AbbASGrX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Jan 2015 01:47:23 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0J6kjbF022581
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Jan 2015 14:46:45 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 07/10] btrfs-progs: Swith btrfs-find-root to use the find-root infrastructure.
Date: Mon, 19 Jan 2015 14:45:09 +0800
Message-ID: <1421649912-14539-8-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1421649912-14539-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1421649912-14539-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since the new find-root infrastructure is here with better root
judgement with less codes, just switch to it.

To switch to the new infrastructure, new print function is added and
output format is slighted changed.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-find-root.c | 81 ++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 71 insertions(+), 10 deletions(-)

diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index 45c48c2..c451c7b 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -34,6 +34,8 @@
 #include "volumes.h"
 #include "utils.h"
 #include "crc32c.h"
+#include "extent-cache.h"
+#include "find-root.h"
 
 static u16 csum_size = 0;
 static u64 search_objectid = BTRFS_ROOT_TREE_OBJECTID;
@@ -333,22 +335,70 @@ static void get_root_gen_and_level(u64 objectid, struct btrfs_fs_info *fs_info,
 	}
 }
 
+static void print_one_result(struct cache_extent *tree_block,
+			     u8 level, u64 generation,
+			     struct btrfs_find_root_filter *filter)
+{
+	int unsure = 0;
+
+	if (filter->match_gen == (u64)-1 || filter->match_level == (u8)-1)
+		unsure = 1;
+	printf("Well block %llu(gen: %llu level: %u) seems good, ",
+	       tree_block->start, generation, level);
+	if (unsure)
+		printf("but we are unsure about the correct generation/level\n");
+	else
+		printf("but generation/level doesn't match, want gen: %llu level: %u\n",
+		       filter->match_gen, filter->match_level);
+}
+
+static void print_find_root_result(struct cache_tree *result,
+				   struct btrfs_find_root_filter *filter)
+{
+	struct btrfs_find_root_gen_cache *gen_cache;
+	struct cache_extent *cache;
+	struct cache_extent *tree_block;
+	u64 generation = 0;
+	u8 level = 0;
+
+	for (cache = last_cache_extent(result);
+	     cache; cache = prev_cache_extent(cache)) {
+		gen_cache = container_of(cache,
+				struct btrfs_find_root_gen_cache, cache);
+		level = gen_cache->highest_level;
+		generation = cache->start;
+		if (level == filter->match_level &&
+		    generation == filter->match_gen)
+			continue;
+		for (tree_block = last_cache_extent(&gen_cache->eb_tree);
+		     tree_block; tree_block = prev_cache_extent(tree_block))
+			print_one_result(tree_block, level, generation, filter);
+	}
+}
+
 int main(int argc, char **argv)
 {
 	struct btrfs_root *root;
+	struct btrfs_find_root_filter filter = {0};
+	struct cache_tree result;
+	struct cache_extent *found;
 	int opt;
 	int ret;
 
+	/* Default to search root tree */
+	filter.objectid = BTRFS_ROOT_TREE_OBJECTID;
+	filter.match_gen = (u64)-1;
+	filter.match_level = (u8)-1;
 	while ((opt = getopt(argc, argv, "l:o:g:")) != -1) {
 		switch(opt) {
 			case 'o':
-				search_objectid = arg_strtou64(optarg);
+				filter.objectid = arg_strtou64(optarg);
 				break;
 			case 'g':
-				search_generation = arg_strtou64(optarg);
+				filter.generation = arg_strtou64(optarg);
 				break;
 			case 'l':
-				search_level = arg_strtou64(optarg);
+				filter.level = arg_strtou64(optarg);
 				break;
 			default:
 				usage();
@@ -369,13 +419,24 @@ int main(int argc, char **argv)
 		fprintf(stderr, "Open ctree failed\n");
 		exit(1);
 	}
-
-	if (search_generation == 0)
-		get_root_gen_and_level(search_objectid, root->fs_info,
-				       &search_generation, NULL);
-
-	csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
-	ret = find_root(root);
+	cache_tree_init(&result);
+
+	get_root_gen_and_level(filter.objectid, root->fs_info,
+			       &filter.match_gen, &filter.match_level);
+	ret = btrfs_find_root_search(root, &filter, &result, &found);
+	if (ret < 0) {
+		fprintf(stderr, "Fail to search the tree root: %s\n",
+			strerror(-ret));
+		goto out;
+	}
+	if (ret > 0) {
+		printf("Found tree root at %llu gen %llu level %u\n",
+		       found->start, filter.match_gen, filter.match_level);
+		ret = 0;
+	}
+	print_find_root_result(&result, &filter);
+out:
+	btrfs_find_root_free(&result);
 	close_ctree(root);
 	return ret;
 }
-- 
2.2.2

