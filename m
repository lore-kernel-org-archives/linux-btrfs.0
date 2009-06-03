From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] Make sure all dirty blocks are written at commit time
Date: Wed, 03 Jun 2009 21:34:31 +0800
Message-ID: <4A267BE7.30704@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Write dirty block groups may allocate new block, thus
may add new delayed back ref. btrfs_run_delayed_refs may
make some block groups dirty. commit_cowonly_roots does
not handle the recursion properly, so some dirty blocks
can be left unwritten at commit time. This patch move
btrfs_run_delayed_refs into the loop that writes dirty
block groups, and make the code not break out of the loop
until there is no dirty block group and delayed back ref.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/ctree.c 2/fs/btrfs/ctree.c
--- 1/fs/btrfs/ctree.c	2009-06-02 10:53:14.614551240 +0800
+++ 2/fs/btrfs/ctree.c	2009-06-03 13:45:59.000000000 +0800
@@ -1043,9 +1043,6 @@ static noinline int balance_level(struct
 	    BTRFS_NODEPTRS_PER_BLOCK(root) / 4)
 		return 0;
 
-	if (btrfs_header_nritems(mid) > 2)
-		return 0;
-
 	if (btrfs_header_nritems(mid) < 2)
 		err_on_enospc = 1;
 
diff -urp 1/fs/btrfs/extent-tree.c 2/fs/btrfs/extent-tree.c
--- 1/fs/btrfs/extent-tree.c	2009-06-02 10:53:14.620550670 +0800
+++ 2/fs/btrfs/extent-tree.c	2009-06-03 10:52:58.000000000 +0800
@@ -2399,13 +2399,29 @@ fail:
 
 }
 
+static struct btrfs_block_group_cache *
+next_block_group(struct btrfs_root *root,
+		 struct btrfs_block_group_cache *cache)
+{
+	struct rb_node *node;
+	spin_lock(&root->fs_info->block_group_cache_lock);
+	node = rb_next(&cache->cache_node);
+	btrfs_put_block_group(cache);
+	if (node) {
+		cache = rb_entry(node, struct btrfs_block_group_cache,
+				 cache_node);
+		atomic_inc(&cache->count);
+	} else
+		cache = NULL;
+	spin_unlock(&root->fs_info->block_group_cache_lock);
+	return cache;
+}
+
 int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root)
 {
-	struct btrfs_block_group_cache *cache, *entry;
-	struct rb_node *n;
+	struct btrfs_block_group_cache *cache;
 	int err = 0;
-	int werr = 0;
 	struct btrfs_path *path;
 	u64 last = 0;
 
@@ -2414,39 +2430,35 @@ int btrfs_write_dirty_block_groups(struc
 		return -ENOMEM;
 
 	while (1) {
-		cache = NULL;
-		spin_lock(&root->fs_info->block_group_cache_lock);
-		for (n = rb_first(&root->fs_info->block_group_cache_tree);
-		     n; n = rb_next(n)) {
-			entry = rb_entry(n, struct btrfs_block_group_cache,
-					 cache_node);
-			if (entry->dirty) {
-				cache = entry;
-				break;
-			}
+		if (last == 0) {
+			err = btrfs_run_delayed_refs(trans, root,
+						     (unsigned long)-1);
+			BUG_ON(err);
 		}
-		spin_unlock(&root->fs_info->block_group_cache_lock);
 
-		if (!cache)
-			break;
+		cache = btrfs_lookup_first_block_group(root->fs_info, last);
+		while (cache) {
+			if (cache->dirty)
+				break;
+			cache = next_block_group(root, cache);
+		}
+		if (!cache) {
+			if (last == 0)
+				break;
+			last = 0;
+			continue;
+		}
 
 		cache->dirty = 0;
-		last += cache->key.offset;
+		last = cache->key.objectid + cache->key.offset;
 
-		err = write_one_cache_group(trans, root,
-					    path, cache);
-		/*
-		 * if we fail to write the cache group, we want
-		 * to keep it marked dirty in hopes that a later
-		 * write will work
-		 */
-		if (err) {
-			werr = err;
-			continue;
-		}
+		err = write_one_cache_group(trans, root, path, cache);
+		BUG_ON(err);
+		btrfs_put_block_group(cache);
 	}
+
 	btrfs_free_path(path);
-	return werr;
+	return 0;
 }
 
 int btrfs_extent_readonly(struct btrfs_root *root, u64 bytenr)
diff -urp 1/fs/btrfs/transaction.c 2/fs/btrfs/transaction.c
--- 1/fs/btrfs/transaction.c	2009-06-02 10:53:14.628551493 +0800
+++ 2/fs/btrfs/transaction.c	2009-06-03 09:56:34.000000000 +0800
@@ -444,9 +444,6 @@ static int update_cowonly_root(struct bt
 
 	btrfs_write_dirty_block_groups(trans, root);
 
-	ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
-	BUG_ON(ret);
-
 	while (1) {
 		old_root_bytenr = btrfs_root_bytenr(&root->root_item);
 		if (old_root_bytenr == root->node->start)
@@ -457,9 +454,8 @@ static int update_cowonly_root(struct bt
 					&root->root_key,
 					&root->root_item);
 		BUG_ON(ret);
-		btrfs_write_dirty_block_groups(trans, root);
 
-		ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
+		ret = btrfs_write_dirty_block_groups(trans, root);
 		BUG_ON(ret);
 	}
 	free_extent_buffer(root->commit_root);
@@ -495,9 +491,6 @@ static noinline int commit_cowonly_roots
 		root = list_entry(next, struct btrfs_root, dirty_list);
 
 		update_cowonly_root(trans, root);
-
-		ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
-		BUG_ON(ret);
 	}
 	return 0;
 }
