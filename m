Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:57414 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752559AbaLDCyt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Dec 2014 21:54:49 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sB42sSZY003327
	for <linux-btrfs@vger.kernel.org>; Thu, 4 Dec 2014 10:54:28 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/3] btrfs-progs: record and report leaf/node corruption in fs/subvol tree
Date: Thu, 4 Dec 2014 10:52:43 +0800
Message-ID: <1417661565-14595-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1417661565-14595-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1417661565-14595-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When leaf/node is corrupted in fs/subvolume root, btrfsck can ignore it
without much pain except some stderr messages complaining about it.
But this works fine doing read-only works, if we want to do deeper
recovery like rebuild missing inodes in the b+tree, it will cause
problem.

At least, info user that there is something wrong in the btree,
and this patch provides the base for later btree repair.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 50 insertions(+), 10 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 627b794..02d9b32 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1475,6 +1475,15 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
 			next = read_tree_block(root, bytenr, blocksize,
 					       ptr_gen);
 			if (!next) {
+				struct btrfs_key node_key;
+
+				btrfs_node_key_to_cpu(path->nodes[*level],
+						      &node_key,
+						      path->slots[*level]);
+				btrfs_add_corrupt_extent_record(root->fs_info,
+						&node_key,
+						path->nodes[*level]->start,
+						root->leafsize, *level);
 				err = -EIO;
 				goto out;
 			}
@@ -2614,6 +2623,16 @@ static int process_root_ref(struct extent_buffer *eb, int slot,
 	return 0;
 }
 
+static void free_corrupt_block(struct cache_extent *cache)
+{
+	struct btrfs_corrupt_block *corrupt;
+
+	corrupt = container_of(cache, struct btrfs_corrupt_block, cache);
+	free(corrupt);
+}
+
+FREE_EXTENT_CACHE_BASED_TREE(corrupt_blocks, free_corrupt_block);
+
 static int check_fs_root(struct btrfs_root *root,
 			 struct cache_tree *root_cache,
 			 struct walk_control *wc)
@@ -2626,8 +2645,17 @@ static int check_fs_root(struct btrfs_root *root,
 	struct shared_node root_node;
 	struct root_record *rec;
 	struct btrfs_root_item *root_item = &root->root_item;
+	struct cache_tree corrupt_blocks;
 	enum btrfs_tree_block_status status;
 
+	/*
+	 * Reuse the corrupt_block cache tree to record corrupted tree block
+	 *
+	 * Unlike the usage in extent tree check, here we do it in a per
+	 * fs/subvol tree base.
+	 */
+	cache_tree_init(&corrupt_blocks);
+	root->fs_info->corrupt_blocks = &corrupt_blocks;
 	if (root->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID) {
 		rec = get_root_rec(root_cache, root->root_key.objectid);
 		if (btrfs_root_refs(root_item) > 0)
@@ -2690,6 +2718,25 @@ static int check_fs_root(struct btrfs_root *root,
 skip_walking:
 	btrfs_release_path(&path);
 
+	if (!cache_tree_empty(&corrupt_blocks)) {
+		struct cache_extent *cache;
+		struct btrfs_corrupt_block *corrupt;
+
+		printf("The following tree block(s) is corrupted in tree %llu:\n",
+		       root->root_key.objectid);
+		cache = first_cache_extent(&corrupt_blocks);
+		while (cache) {
+			corrupt = container_of(cache,
+					       struct btrfs_corrupt_block,
+					       cache);
+			printf("\ttree block bytenr: %llu, level: %d, node key: (%llu, %u, %llu)\n",
+			       cache->start, corrupt->level,
+			       corrupt->key.objectid, corrupt->key.type,
+			       corrupt->key.offset);
+			cache = next_cache_extent(cache);
+		}
+	}
+
 	err = merge_root_recs(root, &root_node.root_cache, root_cache);
 	if (err < 0)
 		ret = err;
@@ -2703,6 +2750,9 @@ skip_walking:
 	err = check_inode_recs(root, &root_node.inode_cache);
 	if (!ret)
 		ret = err;
+
+	free_corrupt_blocks_tree(&corrupt_blocks);
+	root->fs_info->corrupt_blocks = NULL;
 	return ret;
 }
 
@@ -6274,16 +6324,6 @@ static int prune_corrupt_blocks(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-static void free_corrupt_block(struct cache_extent *cache)
-{
-	struct btrfs_corrupt_block *corrupt;
-
-	corrupt = container_of(cache, struct btrfs_corrupt_block, cache);
-	free(corrupt);
-}
-
-FREE_EXTENT_CACHE_BASED_TREE(corrupt_blocks, free_corrupt_block);
-
 static void reset_cached_block_groups(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_block_group_cache *cache;
-- 
2.1.3

