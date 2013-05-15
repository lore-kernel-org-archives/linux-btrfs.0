Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:48578 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757157Ab3EOHso (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 03:48:44 -0400
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: alex.btrfs@zadarastorage.com
Subject: [PATCH 05/17] Btrfs: cleanup the similar code of the fs root read
Date: Wed, 15 May 2013 15:48:19 +0800
Message-Id: <1368604111-25073-6-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
References: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are several functions whose code is similar, such as
  btrfs_find_last_root()
  btrfs_read_fs_root_no_radix()

Besides that, some functions are invoked twice, it is unnecessary,
for example, we are sure that all roots which is found in
  btrfs_find_orphan_roots()
have their orphan items, so it is unnecessary to check the orphan
item again.

So cleanup it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       |   6 +-
 fs/btrfs/disk-io.c     | 282 +++++++++++++++++++++++++------------------------
 fs/btrfs/disk-io.h     |  11 +-
 fs/btrfs/extent-tree.c |   6 +-
 fs/btrfs/relocation.c  |   5 +-
 fs/btrfs/root-tree.c   | 170 ++++++++++-------------------
 fs/btrfs/tree-log.c    |   3 +-
 fs/btrfs/volumes.c     |  13 ++-
 fs/btrfs/volumes.h     |   1 +
 9 files changed, 228 insertions(+), 269 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f9a48fd..845b77f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3369,9 +3369,9 @@ int __must_check btrfs_update_root(struct btrfs_trans_handle *trans,
 				   struct btrfs_root_item *item);
 void btrfs_read_root_item(struct extent_buffer *eb, int slot,
 			  struct btrfs_root_item *item);
-int btrfs_find_last_root(struct btrfs_root *root, u64 objectid, struct
-			 btrfs_root_item *item, struct btrfs_key *key);
-int btrfs_find_dead_roots(struct btrfs_root *root, u64 objectid);
+int btrfs_find_root(struct btrfs_root *root, struct btrfs_key *search_key,
+		    struct btrfs_path *path, struct btrfs_root_item *root_item,
+		    struct btrfs_key *root_key);
 int btrfs_find_orphan_roots(struct btrfs_root *tree_root);
 void btrfs_set_root_node(struct btrfs_root_item *item,
 			 struct extent_buffer *node);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8c1e4fb..42d6ba2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1234,39 +1234,6 @@ static void __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 	spin_lock_init(&root->root_item_lock);
 }
 
-static int __must_check find_and_setup_root(struct btrfs_root *tree_root,
-					    struct btrfs_fs_info *fs_info,
-					    u64 objectid,
-					    struct btrfs_root *root)
-{
-	int ret;
-	u32 blocksize;
-	u64 generation;
-
-	__setup_root(tree_root->nodesize, tree_root->leafsize,
-		     tree_root->sectorsize, tree_root->stripesize,
-		     root, fs_info, objectid);
-	ret = btrfs_find_last_root(tree_root, objectid,
-				   &root->root_item, &root->root_key);
-	if (ret > 0)
-		return -ENOENT;
-	else if (ret < 0)
-		return ret;
-
-	generation = btrfs_root_generation(&root->root_item);
-	blocksize = btrfs_level_size(root, btrfs_root_level(&root->root_item));
-	root->commit_root = NULL;
-	root->node = read_tree_block(root, btrfs_root_bytenr(&root->root_item),
-				     blocksize, generation);
-	if (!root->node || !btrfs_buffer_uptodate(root->node, generation, 0)) {
-		free_extent_buffer(root->node);
-		root->node = NULL;
-		return -EIO;
-	}
-	root->commit_root = btrfs_root_node(root);
-	return 0;
-}
-
 static struct btrfs_root *btrfs_alloc_root(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_root *root = kzalloc(sizeof(*root), GFP_NOFS);
@@ -1451,70 +1418,73 @@ int btrfs_add_log_tree(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-struct btrfs_root *btrfs_read_fs_root_no_radix(struct btrfs_root *tree_root,
-					       struct btrfs_key *location)
+struct btrfs_root *btrfs_read_tree_root(struct btrfs_root *tree_root,
+					struct btrfs_key *key)
 {
 	struct btrfs_root *root;
 	struct btrfs_fs_info *fs_info = tree_root->fs_info;
 	struct btrfs_path *path;
-	struct extent_buffer *l;
 	u64 generation;
 	u32 blocksize;
-	int ret = 0;
-	int slot;
+	int ret;
 
-	root = btrfs_alloc_root(fs_info);
-	if (!root)
+	path = btrfs_alloc_path();
+	if (!path)
 		return ERR_PTR(-ENOMEM);
-	if (location->offset == (u64)-1) {
-		ret = find_and_setup_root(tree_root, fs_info,
-					  location->objectid, root);
-		if (ret) {
-			kfree(root);
-			return ERR_PTR(ret);
-		}
-		goto out;
+
+	root = btrfs_alloc_root(fs_info);
+	if (!root) {
+		ret = -ENOMEM;
+		goto alloc_fail;
 	}
 
 	__setup_root(tree_root->nodesize, tree_root->leafsize,
 		     tree_root->sectorsize, tree_root->stripesize,
-		     root, fs_info, location->objectid);
+		     root, fs_info, key->objectid);
 
-	path = btrfs_alloc_path();
-	if (!path) {
-		kfree(root);
-		return ERR_PTR(-ENOMEM);
-	}
-	ret = btrfs_search_slot(NULL, tree_root, location, path, 0, 0);
-	if (ret == 0) {
-		l = path->nodes[0];
-		slot = path->slots[0];
-		btrfs_read_root_item(l, slot, &root->root_item);
-		memcpy(&root->root_key, location, sizeof(*location));
-	}
-	btrfs_free_path(path);
+	ret = btrfs_find_root(tree_root, key, path,
+			      &root->root_item, &root->root_key);
 	if (ret) {
-		kfree(root);
 		if (ret > 0)
 			ret = -ENOENT;
-		return ERR_PTR(ret);
+		goto find_fail;
 	}
 
 	generation = btrfs_root_generation(&root->root_item);
 	blocksize = btrfs_level_size(root, btrfs_root_level(&root->root_item));
 	root->node = read_tree_block(root, btrfs_root_bytenr(&root->root_item),
 				     blocksize, generation);
-	if (!root->node || !extent_buffer_uptodate(root->node)) {
-		ret = (!root->node) ? -ENOMEM : -EIO;
-
-		free_extent_buffer(root->node);
-		kfree(root);
-		return ERR_PTR(ret);
+	if (!root->node) {
+		ret = -ENOMEM;
+		goto find_fail;
+	} else if (!btrfs_buffer_uptodate(root->node, generation, 0)) {
+		ret = -EIO;
+		goto read_fail;
 	}
-
 	root->commit_root = btrfs_root_node(root);
 out:
-	if (location->objectid != BTRFS_TREE_LOG_OBJECTID) {
+	btrfs_free_path(path);
+	return root;
+
+read_fail:
+	free_extent_buffer(root->node);
+find_fail:
+	kfree(root);
+alloc_fail:
+	root = ERR_PTR(ret);
+	goto out;
+}
+
+struct btrfs_root *btrfs_read_fs_root(struct btrfs_root *tree_root,
+				      struct btrfs_key *location)
+{
+	struct btrfs_root *root;
+
+	root = btrfs_read_tree_root(tree_root, location);
+	if (IS_ERR(root))
+		return root;
+
+	if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID) {
 		root->ref_cows = 1;
 		btrfs_check_and_init_root_item(&root->root_item);
 	}
@@ -1522,6 +1492,66 @@ out:
 	return root;
 }
 
+int btrfs_init_fs_root(struct btrfs_root *root)
+{
+	int ret;
+
+	root->free_ino_ctl = kzalloc(sizeof(*root->free_ino_ctl), GFP_NOFS);
+	root->free_ino_pinned = kzalloc(sizeof(*root->free_ino_pinned),
+					GFP_NOFS);
+	if (!root->free_ino_pinned || !root->free_ino_ctl) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	btrfs_init_free_ino_ctl(root);
+	mutex_init(&root->fs_commit_mutex);
+	spin_lock_init(&root->cache_lock);
+	init_waitqueue_head(&root->cache_wait);
+
+	ret = get_anon_bdev(&root->anon_dev);
+	if (ret)
+		goto fail;
+	return 0;
+fail:
+	kfree(root->free_ino_ctl);
+	kfree(root->free_ino_pinned);
+	return ret;
+}
+
+struct btrfs_root *btrfs_lookup_fs_root(struct btrfs_fs_info *fs_info,
+					u64 root_id)
+{
+	struct btrfs_root *root;
+
+	spin_lock(&fs_info->fs_roots_radix_lock);
+	root = radix_tree_lookup(&fs_info->fs_roots_radix,
+				 (unsigned long)root_id);
+	spin_unlock(&fs_info->fs_roots_radix_lock);
+	return root;
+}
+
+int btrfs_insert_fs_root(struct btrfs_fs_info *fs_info,
+			 struct btrfs_root *root)
+{
+	int ret;
+
+	ret = radix_tree_preload(GFP_NOFS & ~__GFP_HIGHMEM);
+	if (ret)
+		return ret;
+
+	spin_lock(&fs_info->fs_roots_radix_lock);
+	ret = radix_tree_insert(&fs_info->fs_roots_radix,
+				(unsigned long)root->root_key.objectid,
+				root);
+	if (ret == 0)
+		root->in_radix = 1;
+	spin_unlock(&fs_info->fs_roots_radix_lock);
+	radix_tree_preload_end();
+
+	return ret;
+}
+
 struct btrfs_root *btrfs_read_fs_root_no_name(struct btrfs_fs_info *fs_info,
 					      struct btrfs_key *location)
 {
@@ -1542,58 +1572,30 @@ struct btrfs_root *btrfs_read_fs_root_no_name(struct btrfs_fs_info *fs_info,
 		return fs_info->quota_root ? fs_info->quota_root :
 					     ERR_PTR(-ENOENT);
 again:
-	spin_lock(&fs_info->fs_roots_radix_lock);
-	root = radix_tree_lookup(&fs_info->fs_roots_radix,
-				 (unsigned long)location->objectid);
-	spin_unlock(&fs_info->fs_roots_radix_lock);
+	root = btrfs_lookup_fs_root(fs_info, location->objectid);
 	if (root)
 		return root;
 
-	root = btrfs_read_fs_root_no_radix(fs_info->tree_root, location);
+	root = btrfs_read_fs_root(fs_info->tree_root, location);
 	if (IS_ERR(root))
 		return root;
 
-	root->free_ino_ctl = kzalloc(sizeof(*root->free_ino_ctl), GFP_NOFS);
-	root->free_ino_pinned = kzalloc(sizeof(*root->free_ino_pinned),
-					GFP_NOFS);
-	if (!root->free_ino_pinned || !root->free_ino_ctl) {
-		ret = -ENOMEM;
+	if (btrfs_root_refs(&root->root_item) == 0) {
+		ret = -ENOENT;
 		goto fail;
 	}
 
-	btrfs_init_free_ino_ctl(root);
-	mutex_init(&root->fs_commit_mutex);
-	spin_lock_init(&root->cache_lock);
-	init_waitqueue_head(&root->cache_wait);
-
-	ret = get_anon_bdev(&root->anon_dev);
+	ret = btrfs_init_fs_root(root);
 	if (ret)
 		goto fail;
 
-	if (btrfs_root_refs(&root->root_item) == 0) {
-		ret = -ENOENT;
-		goto fail;
-	}
-
 	ret = btrfs_find_orphan_item(fs_info->tree_root, location->objectid);
 	if (ret < 0)
 		goto fail;
 	if (ret == 0)
 		root->orphan_item_inserted = 1;
 
-	ret = radix_tree_preload(GFP_NOFS & ~__GFP_HIGHMEM);
-	if (ret)
-		goto fail;
-
-	spin_lock(&fs_info->fs_roots_radix_lock);
-	ret = radix_tree_insert(&fs_info->fs_roots_radix,
-				(unsigned long)root->root_key.objectid,
-				root);
-	if (ret == 0)
-		root->in_radix = 1;
-
-	spin_unlock(&fs_info->fs_roots_radix_lock);
-	radix_tree_preload_end();
+	ret = btrfs_insert_fs_root(fs_info, root);
 	if (ret) {
 		if (ret == -EEXIST) {
 			free_fs_root(root);
@@ -1601,10 +1603,6 @@ again:
 		}
 		goto fail;
 	}
-
-	ret = btrfs_find_dead_roots(fs_info->tree_root,
-				    root->root_key.objectid);
-	WARN_ON(ret);
 	return root;
 fail:
 	free_fs_root(root);
@@ -2047,7 +2045,7 @@ static void del_fs_roots(struct btrfs_fs_info *fs_info)
 		list_del(&gang[0]->root_list);
 
 		if (gang[0]->in_radix) {
-			btrfs_free_fs_root(fs_info, gang[0]);
+			btrfs_drop_and_free_fs_root(fs_info, gang[0]);
 		} else {
 			free_extent_buffer(gang[0]->node);
 			free_extent_buffer(gang[0]->commit_root);
@@ -2062,7 +2060,7 @@ static void del_fs_roots(struct btrfs_fs_info *fs_info)
 		if (!ret)
 			break;
 		for (i = 0; i < ret; i++)
-			btrfs_free_fs_root(fs_info, gang[i]);
+			btrfs_drop_and_free_fs_root(fs_info, gang[i]);
 	}
 }
 
@@ -2094,14 +2092,8 @@ int open_ctree(struct super_block *sb,
 	int backup_index = 0;
 
 	tree_root = fs_info->tree_root = btrfs_alloc_root(fs_info);
-	extent_root = fs_info->extent_root = btrfs_alloc_root(fs_info);
-	csum_root = fs_info->csum_root = btrfs_alloc_root(fs_info);
 	chunk_root = fs_info->chunk_root = btrfs_alloc_root(fs_info);
-	dev_root = fs_info->dev_root = btrfs_alloc_root(fs_info);
-	quota_root = fs_info->quota_root = btrfs_alloc_root(fs_info);
-
-	if (!tree_root || !extent_root || !csum_root ||
-	    !chunk_root || !dev_root || !quota_root) {
+	if (!tree_root || !chunk_root) {
 		err = -ENOMEM;
 		goto fail;
 	}
@@ -2651,33 +2643,44 @@ retry_root_backup:
 	btrfs_set_root_node(&tree_root->root_item, tree_root->node);
 	tree_root->commit_root = btrfs_root_node(tree_root);
 
-	ret = find_and_setup_root(tree_root, fs_info,
-				  BTRFS_EXTENT_TREE_OBJECTID, extent_root);
-	if (ret)
+	location.objectid = BTRFS_EXTENT_TREE_OBJECTID;
+	location.type = BTRFS_ROOT_ITEM_KEY;
+	location.offset = 0;
+
+	extent_root = btrfs_read_tree_root(tree_root, &location);
+	if (IS_ERR(extent_root)) {
+		ret = PTR_ERR(extent_root);
 		goto recovery_tree_root;
+	}
 	extent_root->track_dirty = 1;
+	fs_info->extent_root = extent_root;
 
-	ret = find_and_setup_root(tree_root, fs_info,
-				  BTRFS_DEV_TREE_OBJECTID, dev_root);
-	if (ret)
+	location.objectid = BTRFS_DEV_TREE_OBJECTID;
+	dev_root = btrfs_read_tree_root(tree_root, &location);
+	if (IS_ERR(dev_root)) {
+		ret = PTR_ERR(dev_root);
 		goto recovery_tree_root;
+	}
 	dev_root->track_dirty = 1;
+	fs_info->dev_root = dev_root;
+	btrfs_init_devices_late(fs_info);
 
-	ret = find_and_setup_root(tree_root, fs_info,
-				  BTRFS_CSUM_TREE_OBJECTID, csum_root);
-	if (ret)
+	location.objectid = BTRFS_CSUM_TREE_OBJECTID;
+	csum_root = btrfs_read_tree_root(tree_root, &location);
+	if (IS_ERR(csum_root)) {
+		ret = PTR_ERR(csum_root);
 		goto recovery_tree_root;
+	}
 	csum_root->track_dirty = 1;
+	fs_info->csum_root = csum_root;
 
-	ret = find_and_setup_root(tree_root, fs_info,
-				  BTRFS_QUOTA_TREE_OBJECTID, quota_root);
-	if (ret) {
-		kfree(quota_root);
-		quota_root = fs_info->quota_root = NULL;
-	} else {
+	location.objectid = BTRFS_QUOTA_TREE_OBJECTID;
+	quota_root = btrfs_read_tree_root(tree_root, &location);
+	if (!IS_ERR(quota_root)) {
 		quota_root->track_dirty = 1;
 		fs_info->quota_enabled = 1;
 		fs_info->pending_quota_state = 1;
+		fs_info->quota_root = quota_root;
 	}
 
 	fs_info->generation = generation;
@@ -2830,7 +2833,7 @@ retry_root_backup:
 
 	location.objectid = BTRFS_FS_TREE_OBJECTID;
 	location.type = BTRFS_ROOT_ITEM_KEY;
-	location.offset = (u64)-1;
+	location.offset = 0;
 
 	fs_info->fs_root = btrfs_read_fs_root_no_name(fs_info, &location);
 	if (!fs_info->fs_root)
@@ -3379,7 +3382,9 @@ int write_ctree_super(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-void btrfs_free_fs_root(struct btrfs_fs_info *fs_info, struct btrfs_root *root)
+/* Drop a fs root from the radix tree and free it. */
+void btrfs_drop_and_free_fs_root(struct btrfs_fs_info *fs_info,
+				  struct btrfs_root *root)
 {
 	spin_lock(&fs_info->fs_roots_radix_lock);
 	radix_tree_delete(&fs_info->fs_roots_radix,
@@ -3413,6 +3418,11 @@ static void free_fs_root(struct btrfs_root *root)
 	kfree(root);
 }
 
+void btrfs_free_fs_root(struct btrfs_root *root)
+{
+	free_fs_root(root);
+}
+
 int btrfs_cleanup_fs_roots(struct btrfs_fs_info *fs_info)
 {
 	u64 root_objectid = 0;
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index be69ce1..534d583 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -63,14 +63,19 @@ struct buffer_head *btrfs_read_dev_super(struct block_device *bdev);
 int btrfs_commit_super(struct btrfs_root *root);
 struct extent_buffer *btrfs_find_tree_block(struct btrfs_root *root,
 					    u64 bytenr, u32 blocksize);
-struct btrfs_root *btrfs_read_fs_root_no_radix(struct btrfs_root *tree_root,
-					       struct btrfs_key *location);
+struct btrfs_root *btrfs_read_fs_root(struct btrfs_root *tree_root,
+				      struct btrfs_key *location);
+int btrfs_init_fs_root(struct btrfs_root *root);
+int btrfs_insert_fs_root(struct btrfs_fs_info *fs_info,
+			 struct btrfs_root *root);
 struct btrfs_root *btrfs_read_fs_root_no_name(struct btrfs_fs_info *fs_info,
 					      struct btrfs_key *location);
 int btrfs_cleanup_fs_roots(struct btrfs_fs_info *fs_info);
 void btrfs_btree_balance_dirty(struct btrfs_root *root);
 void btrfs_btree_balance_dirty_nodelay(struct btrfs_root *root);
-void btrfs_free_fs_root(struct btrfs_fs_info *fs_info, struct btrfs_root *root);
+void btrfs_drop_and_free_fs_root(struct btrfs_fs_info *fs_info,
+				 struct btrfs_root *root);
+void btrfs_free_fs_root(struct btrfs_root *root);
 void btrfs_mark_buffer_dirty(struct extent_buffer *buf);
 int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid,
 			  int atomic);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 7f7c7a6..08e42c8 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7441,8 +7441,8 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 	}
 
 	if (root->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID) {
-		ret = btrfs_find_last_root(tree_root, root->root_key.objectid,
-					   NULL, NULL);
+		ret = btrfs_find_root(tree_root, &root->root_key, path,
+				      NULL, NULL);
 		if (ret < 0) {
 			btrfs_abort_transaction(trans, tree_root, ret);
 			err = ret;
@@ -7459,7 +7459,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 	}
 
 	if (root->in_radix) {
-		btrfs_free_fs_root(tree_root->fs_info, root);
+		btrfs_drop_and_free_fs_root(tree_root->fs_info, root);
 	} else {
 		free_extent_buffer(root->node);
 		free_extent_buffer(root->commit_root);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 704a1b8..baaa66b 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1355,8 +1355,7 @@ static struct btrfs_root *create_reloc_root(struct btrfs_trans_handle *trans,
 	BUG_ON(ret);
 	kfree(root_item);
 
-	reloc_root = btrfs_read_fs_root_no_radix(root->fs_info->tree_root,
-						 &root_key);
+	reloc_root = btrfs_read_fs_root(root->fs_info->tree_root, &root_key);
 	BUG_ON(IS_ERR(reloc_root));
 	reloc_root->last_trans = trans->transid;
 	return reloc_root;
@@ -4271,7 +4270,7 @@ int btrfs_recover_relocation(struct btrfs_root *root)
 		    key.type != BTRFS_ROOT_ITEM_KEY)
 			break;
 
-		reloc_root = btrfs_read_fs_root_no_radix(root, &key);
+		reloc_root = btrfs_read_fs_root(root, &key);
 		if (IS_ERR(reloc_root)) {
 			err = PTR_ERR(reloc_root);
 			goto out;
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 5bf1ed5..79e6832 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -64,52 +64,59 @@ void btrfs_read_root_item(struct extent_buffer *eb, int slot,
 }
 
 /*
- * lookup the root with the highest offset for a given objectid.  The key we do
- * find is copied into 'key'.  If we find something return 0, otherwise 1, < 0
- * on error.
+ * btrfs_find_root - lookup the root by the key.
+ * root: the root of the root tree
+ * search_key: the key to search
+ * path: the path we search
+ * root_item: the root item of the tree we look for
+ * root_key: the reak key of the tree we look for
+ *
+ * If ->offset of 'seach_key' is -1ULL, it means we are not sure the offset
+ * of the search key, just lookup the root with the highest offset for a
+ * given objectid.
+ *
+ * If we find something return 0, otherwise > 0, < 0 on error.
  */
-int btrfs_find_last_root(struct btrfs_root *root, u64 objectid,
-			struct btrfs_root_item *item, struct btrfs_key *key)
+int btrfs_find_root(struct btrfs_root *root, struct btrfs_key *search_key,
+		    struct btrfs_path *path, struct btrfs_root_item *root_item,
+		    struct btrfs_key *root_key)
 {
-	struct btrfs_path *path;
-	struct btrfs_key search_key;
 	struct btrfs_key found_key;
 	struct extent_buffer *l;
 	int ret;
 	int slot;
 
-	search_key.objectid = objectid;
-	search_key.type = BTRFS_ROOT_ITEM_KEY;
-	search_key.offset = (u64)-1;
-
-	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
-	ret = btrfs_search_slot(NULL, root, &search_key, path, 0, 0);
+	ret = btrfs_search_slot(NULL, root, search_key, path, 0, 0);
 	if (ret < 0)
-		goto out;
+		return ret;
 
-	BUG_ON(ret == 0);
-	if (path->slots[0] == 0) {
-		ret = 1;
-		goto out;
+	if (search_key->offset != -1ULL) {	/* the search key is exact */
+		if (ret > 0)
+			goto out;
+	} else {
+		BUG_ON(ret == 0);		/* Logical error */
+		if (path->slots[0] == 0)
+			goto out;
+		path->slots[0]--;
+		ret = 0;
 	}
+
 	l = path->nodes[0];
-	slot = path->slots[0] - 1;
+	slot = path->slots[0];
+
 	btrfs_item_key_to_cpu(l, &found_key, slot);
-	if (found_key.objectid != objectid ||
+	if (found_key.objectid != search_key->objectid ||
 	    found_key.type != BTRFS_ROOT_ITEM_KEY) {
 		ret = 1;
 		goto out;
 	}
-	if (item)
-		btrfs_read_root_item(l, slot, item);
-	if (key)
-		memcpy(key, &found_key, sizeof(found_key));
 
-	ret = 0;
+	if (root_item)
+		btrfs_read_root_item(l, slot, root_item);
+	if (root_key)
+		memcpy(root_key, &found_key, sizeof(found_key));
 out:
-	btrfs_free_path(path);
+	btrfs_release_path(path);
 	return ret;
 }
 
@@ -212,86 +219,6 @@ int btrfs_insert_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	return btrfs_insert_item(trans, root, key, item, sizeof(*item));
 }
 
-/*
- * at mount time we want to find all the old transaction snapshots that were in
- * the process of being deleted if we crashed.  This is any root item with an
- * offset lower than the latest root.  They need to be queued for deletion to
- * finish what was happening when we crashed.
- */
-int btrfs_find_dead_roots(struct btrfs_root *root, u64 objectid)
-{
-	struct btrfs_root *dead_root;
-	struct btrfs_root_item *ri;
-	struct btrfs_key key;
-	struct btrfs_key found_key;
-	struct btrfs_path *path;
-	int ret;
-	u32 nritems;
-	struct extent_buffer *leaf;
-	int slot;
-
-	key.objectid = objectid;
-	btrfs_set_key_type(&key, BTRFS_ROOT_ITEM_KEY);
-	key.offset = 0;
-	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
-
-again:
-	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
-	if (ret < 0)
-		goto err;
-	while (1) {
-		leaf = path->nodes[0];
-		nritems = btrfs_header_nritems(leaf);
-		slot = path->slots[0];
-		if (slot >= nritems) {
-			ret = btrfs_next_leaf(root, path);
-			if (ret)
-				break;
-			leaf = path->nodes[0];
-			nritems = btrfs_header_nritems(leaf);
-			slot = path->slots[0];
-		}
-		btrfs_item_key_to_cpu(leaf, &key, slot);
-		if (btrfs_key_type(&key) != BTRFS_ROOT_ITEM_KEY)
-			goto next;
-
-		if (key.objectid < objectid)
-			goto next;
-
-		if (key.objectid > objectid)
-			break;
-
-		ri = btrfs_item_ptr(leaf, slot, struct btrfs_root_item);
-		if (btrfs_disk_root_refs(leaf, ri) != 0)
-			goto next;
-
-		memcpy(&found_key, &key, sizeof(key));
-		key.offset++;
-		btrfs_release_path(path);
-		dead_root =
-			btrfs_read_fs_root_no_radix(root->fs_info->tree_root,
-						    &found_key);
-		if (IS_ERR(dead_root)) {
-			ret = PTR_ERR(dead_root);
-			goto err;
-		}
-
-		ret = btrfs_add_dead_root(dead_root);
-		if (ret)
-			goto err;
-		goto again;
-next:
-		slot++;
-		path->slots[0]++;
-	}
-	ret = 0;
-err:
-	btrfs_free_path(path);
-	return ret;
-}
-
 int btrfs_find_orphan_roots(struct btrfs_root *tree_root)
 {
 	struct extent_buffer *leaf;
@@ -340,20 +267,29 @@ int btrfs_find_orphan_roots(struct btrfs_root *tree_root)
 		root_key.objectid = key.offset;
 		key.offset++;
 
-		root = btrfs_read_fs_root_no_name(tree_root->fs_info,
-						  &root_key);
-		if (!IS_ERR(root))
+		root = btrfs_read_fs_root(tree_root, &root_key);
+		if (IS_ERR(root)) {
+			err = PTR_ERR(root);
+			break;
+		}
+
+		if (btrfs_root_refs(&root->root_item) == 0) {
+			btrfs_add_dead_root(root);
 			continue;
+		}
 
-		ret = PTR_ERR(root);
-		if (ret != -ENOENT) {
-			err = ret;
+		err = btrfs_init_fs_root(root);
+		if (err) {
+			btrfs_free_fs_root(root);
 			break;
 		}
 
-		ret = btrfs_find_dead_roots(tree_root, root_key.objectid);
-		if (ret) {
-			err = ret;
+		root->orphan_item_inserted = 1;
+
+		err = btrfs_insert_fs_root(root->fs_info, root);
+		if (err) {
+			BUG_ON(err == -EEXIST);
+			btrfs_free_fs_root(root);
 			break;
 		}
 	}
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c276ac9..a59724e 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4016,8 +4016,7 @@ again:
 		if (found_key.objectid != BTRFS_TREE_LOG_OBJECTID)
 			break;
 
-		log = btrfs_read_fs_root_no_radix(log_root_tree,
-						  &found_key);
+		log = btrfs_read_fs_root(log_root_tree, &found_key);
 		if (IS_ERR(log)) {
 			ret = PTR_ERR(log);
 			btrfs_error(fs_info, ret,
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a191bac..746d092 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5397,7 +5397,6 @@ static struct btrfs_device *add_missing_dev(struct btrfs_root *root,
 		return NULL;
 	list_add(&device->dev_list,
 		 &fs_devices->devices);
-	device->dev_root = root->fs_info->dev_root;
 	device->devid = devid;
 	device->work.func = pending_bios_fn;
 	device->fs_devices = fs_devices;
@@ -5623,7 +5622,6 @@ static int read_one_dev(struct btrfs_root *root,
 	}
 
 	fill_device_from_item(leaf, dev_item, device);
-	device->dev_root = root->fs_info->dev_root;
 	device->in_fs_metadata = 1;
 	if (device->writeable && !device->is_tgtdev_for_dev_replace) {
 		device->fs_devices->total_rw_bytes += device->total_bytes;
@@ -5781,6 +5779,17 @@ error:
 	return ret;
 }
 
+void btrfs_init_devices_late(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
+	struct btrfs_device *device;
+
+	mutex_lock(&fs_devices->device_list_mutex);
+	list_for_each_entry(device, &fs_devices->devices, dev_list)
+		device->dev_root = fs_info->dev_root;
+	mutex_unlock(&fs_devices->device_list_mutex);
+}
+
 static void __btrfs_reset_dev_stats(struct btrfs_device *dev)
 {
 	int i;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 845ccbb..7772c2e 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -301,6 +301,7 @@ int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
 void btrfs_dev_stat_inc_and_print(struct btrfs_device *dev, int index);
 int btrfs_get_dev_stats(struct btrfs_root *root,
 			struct btrfs_ioctl_get_dev_stats *stats);
+void btrfs_init_devices_late(struct btrfs_fs_info *fs_info);
 int btrfs_init_dev_stats(struct btrfs_fs_info *fs_info);
 int btrfs_run_dev_stats(struct btrfs_trans_handle *trans,
 			struct btrfs_fs_info *fs_info);
-- 
1.8.1.4

