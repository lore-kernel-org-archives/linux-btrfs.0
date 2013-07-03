Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57544 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756260Ab3GCOAj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Jul 2013 10:00:39 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r63DODx4003962
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Jul 2013 21:24:14 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 06/12] Btrfs-progs: use rb-tree instead of extent cache tree for fs/file roots
Date: Wed, 3 Jul 2013 21:25:14 +0800
Message-Id: <1372857920-4678-7-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1372857920-4678-1-git-send-email-miaox@cn.fujitsu.com>
References: <1372857920-4678-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Because the fs/file roots are not extents, so it is better to use rb-tree
to manage them. Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 ctree.h   |  4 ++--
 disk-io.c | 50 ++++++++++++++++++++++++++++++++++++--------------
 2 files changed, 38 insertions(+), 16 deletions(-)

diff --git a/ctree.h b/ctree.h
index 3fe14b0..4347c8a 100644
--- a/ctree.h
+++ b/ctree.h
@@ -909,7 +909,7 @@ struct btrfs_fs_info {
 	struct btrfs_root *dev_root;
 	struct btrfs_root *csum_root;
 
-	struct cache_tree fs_root_cache;
+	struct rb_root fs_root_tree;
 
 	/* the log root tree is a directory of all the other log roots */
 	struct btrfs_root *log_root_tree;
@@ -993,7 +993,7 @@ struct btrfs_root {
 
 	/* the dirty list is only used by non-reference counted roots */
 	struct list_head dirty_list;
-	struct cache_extent cache;
+	struct rb_node rb_node;
 };
 
 /*
diff --git a/disk-io.c b/disk-io.c
index 4541573..7140367 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -681,15 +681,15 @@ int btrfs_free_fs_root(struct btrfs_root *root)
 	return 0;
 }
 
-static void __free_fs_root(struct cache_extent *cache)
+static void __free_fs_root(struct rb_node *node)
 {
 	struct btrfs_root *root;
 
-	root = container_of(cache, struct btrfs_root, cache);
+	root = container_of(node, struct btrfs_root, rb_node);
 	btrfs_free_fs_root(root);
 }
 
-FREE_EXTENT_CACHE_BASED_TREE(fs_roots, __free_fs_root);
+FREE_RB_BASED_TREE(fs_roots, __free_fs_root);
 
 struct btrfs_root *btrfs_read_fs_root_no_cache(struct btrfs_fs_info *fs_info,
 					       struct btrfs_key *location)
@@ -751,11 +751,35 @@ insert:
 	return root;
 }
 
+static int btrfs_fs_roots_compare_objectids(struct rb_node *node,
+					    void *data)
+{
+	u64 objectid = *((u64 *)data);
+	struct btrfs_root *root;
+
+	root = rb_entry(node, struct btrfs_root, rb_node);
+	if (objectid > root->objectid)
+		return 1;
+	else if (objectid < root->objectid)
+		return -1;
+	else
+		return 0;
+}
+
+static int btrfs_fs_roots_compare_roots(struct rb_node *node1,
+					struct rb_node *node2)
+{
+	struct btrfs_root *root;
+
+	root = rb_entry(node2, struct btrfs_root, rb_node);
+	return btrfs_fs_roots_compare_objectids(node1, (void *)&root->objectid);
+}
+
 struct btrfs_root *btrfs_read_fs_root(struct btrfs_fs_info *fs_info,
 				      struct btrfs_key *location)
 {
 	struct btrfs_root *root;
-	struct cache_extent *cache;
+	struct rb_node *node;
 	int ret;
 
 	if (location->objectid == BTRFS_ROOT_TREE_OBJECTID)
@@ -772,18 +796,17 @@ struct btrfs_root *btrfs_read_fs_root(struct btrfs_fs_info *fs_info,
 	BUG_ON(location->objectid == BTRFS_TREE_RELOC_OBJECTID ||
 	       location->offset != (u64)-1);
 
-	cache = find_cache_extent(&fs_info->fs_root_cache,
-				  location->objectid, 1);
-	if (cache)
-		return container_of(cache, struct btrfs_root, cache);
+	node = rb_search(&fs_info->fs_root_tree, (void *)&location->objectid,
+			 btrfs_fs_roots_compare_objectids, NULL);
+	if (node)
+		return container_of(node, struct btrfs_root, rb_node);
 
 	root = btrfs_read_fs_root_no_cache(fs_info, location);
 	if (IS_ERR(root))
 		return root;
 
-	root->cache.start = location->objectid;
-	root->cache.size = 1;
-	ret = insert_cache_extent(&fs_info->fs_root_cache, &root->cache);
+	ret = rb_insert(&fs_info->fs_root_tree, &root->rb_node,
+			btrfs_fs_roots_compare_roots);
 	BUG_ON(ret);
 	return root;
 }
@@ -835,8 +858,7 @@ struct btrfs_fs_info *btrfs_new_fs_info(int writable, u64 sb_bytenr)
 	extent_io_tree_init(&fs_info->pinned_extents);
 	extent_io_tree_init(&fs_info->pending_del);
 	extent_io_tree_init(&fs_info->extent_ins);
-
-	cache_tree_init(&fs_info->fs_root_cache);
+	fs_info->fs_root_tree = RB_ROOT;
 	cache_tree_init(&fs_info->mapping_tree.cache_tree);
 
 	mutex_init(&fs_info->fs_mutex);
@@ -1383,7 +1405,7 @@ int close_ctree(struct btrfs_root *root)
 	}
 	btrfs_free_block_groups(fs_info);
 
-	free_fs_roots_tree(&fs_info->fs_root_cache);
+	free_fs_roots_tree(&fs_info->fs_root_tree);
 
 	btrfs_release_all_roots(fs_info);
 	btrfs_close_devices(fs_info->fs_devices);
-- 
1.8.1.4

