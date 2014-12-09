Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10669 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752870AbaLII2G (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Dec 2014 03:28:06 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sB98RPOF013501
	for <linux-btrfs@vger.kernel.org>; Tue, 9 Dec 2014 16:27:25 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v4 12/13] btrfs-progs: Recover btree by dropping corrupted leaf/node.
Date: Tue, 9 Dec 2014 16:27:31 +0800
Message-ID: <1418113652-25088-13-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1418113652-25088-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1418113652-25088-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current btrfsck can skip corrupted leaf and even repair some corrupted
one if their bytenr or key order is wrong.

However when it comes to csum error leaf, btrfsck can only skip them,
which is OK for read-only iteration, but is bad for write.

This patch introduce the new repair_btree() function to recover the
btree, deleting all the corrupted leaf/node including corresponding
extent, allowing later write into the btree.

This patch provides the basis for later recovery with corrupted leaves.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
Changelog:
v2:
   Newly introduced.
v3:
   Fix a wrong arguement passed to btrfs_start_transaction().
---
 cmds-check.c | 102 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 102 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 2245cea..e68966b 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2647,6 +2647,97 @@ static void free_corrupt_block(struct cache_extent *cache)
 
 FREE_EXTENT_CACHE_BASED_TREE(corrupt_blocks, free_corrupt_block);
 
+/*
+ * Repair the btree of the given root.
+ *
+ * The fix is to remove the node key in corrupt_blocks cache_tree.
+ * and rebalance the tree.
+ * After the fix, the btree should be writeable.
+ */
+static int repair_btree(struct btrfs_root *root,
+			struct cache_tree *corrupt_blocks)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_path *path;
+	struct btrfs_corrupt_block *corrupt;
+	struct cache_extent *cache;
+	struct btrfs_key key;
+	u64 offset;
+	int level;
+	int ret = 0;
+
+	if (cache_tree_empty(corrupt_blocks))
+		return 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		fprintf(stderr, "Error starting transaction: %s\n",
+			strerror(-ret));
+		return ret;
+	}
+	cache = first_cache_extent(corrupt_blocks);
+	while (cache) {
+		corrupt = container_of(cache, struct btrfs_corrupt_block,
+				       cache);
+		level = corrupt->level;
+		path->lowest_level = level;
+		key.objectid = corrupt->key.objectid;
+		key.type = corrupt->key.type;
+		key.offset = corrupt->key.offset;
+
+		/*
+		 * Here we don't want to do any tree balance, since it may
+		 * cause a balance with corrupted brother leaf/node,
+		 * so ins_len set to 0 here.
+		 * Balance will be done after all corrupt node/leaf is deleted.
+		 */
+		ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
+		if (ret < 0)
+			goto out;
+		offset = btrfs_node_blockptr(path->nodes[level],
+					     path->slots[level]);
+
+		/* Remove the ptr */
+		ret = btrfs_del_ptr(trans, root, path, level,
+				    path->slots[level]);
+		if (ret < 0)
+			goto out;
+		/*
+		 * Remove the corresponding extent
+		 * return value is not concerned.
+		 */
+		btrfs_release_path(path);
+		ret = btrfs_free_extent(trans, root, offset, root->nodesize,
+					0, root->root_key.objectid,
+					level - 1, 0);
+		cache = next_cache_extent(cache);
+	}
+
+	/* Balance the btree using btrfs_search_slot() */
+	cache = first_cache_extent(corrupt_blocks);
+	while (cache) {
+		corrupt = container_of(cache, struct btrfs_corrupt_block,
+				       cache);
+		memcpy(&key, &corrupt->key, sizeof(key));
+		ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+		if (ret < 0)
+			goto out;
+		/* return will always >0 since it won't find the item */
+		ret = 0;
+		btrfs_release_path(path);
+		cache = next_cache_extent(cache);
+	}
+out:
+	btrfs_free_path(path);
+	btrfs_commit_transaction(trans, root);
+	return ret;
+}
+
 static int check_fs_root(struct btrfs_root *root,
 			 struct cache_tree *root_cache,
 			 struct walk_control *wc)
@@ -2749,6 +2840,17 @@ skip_walking:
 			       corrupt->key.offset);
 			cache = next_cache_extent(cache);
 		}
+		if (repair) {
+			printf("Try to repair the btree for root %llu\n",
+			       root->root_key.objectid);
+			ret = repair_btree(root, &corrupt_blocks);
+			if (ret < 0)
+				fprintf(stderr, "Failed to repair btree: %s\n",
+					strerror(-ret));
+			if (!ret)
+				printf("Btree for root %llu is fixed\n",
+				       root->root_key.objectid);
+		}
 	}
 
 	err = merge_root_recs(root, &root_node.root_cache, root_cache);
-- 
2.1.3

