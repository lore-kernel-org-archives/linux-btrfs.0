Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:65010 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752168AbcBBDIF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Feb 2016 22:08:05 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v5 11/19] btrfs: dedup: Introduce interfaces to resume and cleanup dedup info
Date: Tue,  2 Feb 2016 11:05:43 +0800
Message-Id: <1454382351-31775-12-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1454382351-31775-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1454382351-31775-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since we will introduce a new on-disk based dedup method, introduce new
interfaces to resume previous dedup setup.

And since we introduce a new tree for status, also add disable handler
for it.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/dedup.c   | 277 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 fs/btrfs/dedup.h   |  13 +++
 fs/btrfs/disk-io.c |  21 +++-
 fs/btrfs/disk-io.h |   1 +
 4 files changed, 287 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/dedup.c b/fs/btrfs/dedup.c
index f6b518a..4dd07b7 100644
--- a/fs/btrfs/dedup.c
+++ b/fs/btrfs/dedup.c
@@ -21,6 +21,8 @@
 #include "transaction.h"
 #include "delayed-ref.h"
 #include "qgroup.h"
+#include "disk-io.h"
+#include "locking.h"
 
 struct inmem_hash {
 	struct rb_node hash_node;
@@ -41,10 +43,105 @@ static inline struct inmem_hash *inmem_alloc_hash(u16 type)
 			GFP_NOFS);
 }
 
+static int init_dedup_info(struct btrfs_dedup_info **ret_info, u16 type,
+			   u16 backend, u64 blocksize, u64 limit)
+{
+	struct btrfs_dedup_info *dedup_info;
+
+	dedup_info = kzalloc(sizeof(*dedup_info), GFP_NOFS);
+	if (!dedup_info)
+		return -ENOMEM;
+
+	dedup_info->hash_type = type;
+	dedup_info->backend = backend;
+	dedup_info->blocksize = blocksize;
+	dedup_info->limit_nr = limit;
+
+	/* only support SHA256 yet */
+	dedup_info->dedup_driver = crypto_alloc_shash("sha256", 0, 0);
+	if (IS_ERR(dedup_info->dedup_driver)) {
+		int ret;
+
+		ret = PTR_ERR(dedup_info->dedup_driver);
+		kfree(dedup_info);
+		return ret;
+	}
+
+	dedup_info->hash_root = RB_ROOT;
+	dedup_info->bytenr_root = RB_ROOT;
+	dedup_info->current_nr = 0;
+	INIT_LIST_HEAD(&dedup_info->lru_list);
+	mutex_init(&dedup_info->lock);
+	init_waitqueue_head(&dedup_info->refs_wq);
+	atomic_set(&dedup_info->refs, 0);
+
+	*ret_info = dedup_info;
+	return 0;
+}
+
+static int init_dedup_tree(struct btrfs_fs_info *fs_info,
+			   struct btrfs_dedup_info *dedup_info)
+{
+	struct btrfs_root *dedup_root;
+	struct btrfs_key key;
+	struct btrfs_path *path;
+	struct btrfs_dedup_status_item *status;
+	struct btrfs_trans_handle *trans;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	trans = btrfs_start_transaction(fs_info->tree_root, 2);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
+	}
+	dedup_root = btrfs_create_tree(trans, fs_info,
+				       BTRFS_DEDUP_TREE_OBJECTID);
+	if (IS_ERR(dedup_root)) {
+		ret = PTR_ERR(dedup_root);
+		btrfs_abort_transaction(trans, fs_info->tree_root, ret);
+		goto out;
+	}
+	dedup_info->dedup_root = dedup_root;
+
+	key.objectid = 0;
+	key.type = BTRFS_DEDUP_STATUS_ITEM_KEY;
+	key.offset = 0;
+
+	ret = btrfs_insert_empty_item(trans, dedup_root, path, &key,
+				      sizeof(*status));
+	if (ret < 0) {
+		btrfs_abort_transaction(trans, fs_info->tree_root, ret);
+		goto out;
+	}
+
+	status = btrfs_item_ptr(path->nodes[0], path->slots[0],
+				struct btrfs_dedup_status_item);
+	btrfs_set_dedup_status_blocksize(path->nodes[0], status,
+					 dedup_info->blocksize);
+	btrfs_set_dedup_status_limit(path->nodes[0], status,
+			dedup_info->limit_nr);
+	btrfs_set_dedup_status_hash_type(path->nodes[0], status,
+			dedup_info->hash_type);
+	btrfs_set_dedup_status_backend(path->nodes[0], status,
+			dedup_info->backend);
+	btrfs_mark_buffer_dirty(path->nodes[0]);
+out:
+	btrfs_free_path(path);
+	if (ret == 0)
+		btrfs_commit_transaction(trans, fs_info->tree_root);
+	return ret;
+}
+
 int btrfs_dedup_enable(struct btrfs_fs_info *fs_info, u16 type, u16 backend,
 		       u64 blocksize, u64 limit_nr)
 {
 	struct btrfs_dedup_info *dedup_info;
+	int create_tree;
+	u64 compat_ro_flag = btrfs_super_compat_ro_flags(fs_info->super_copy);
 	u64 limit = limit_nr;
 	int ret = 0;
 
@@ -63,10 +160,17 @@ int btrfs_dedup_enable(struct btrfs_fs_info *fs_info, u16 type, u16 backend,
 		limit = 4096; /* default value */
 	if (backend == BTRFS_DEDUP_BACKEND_ONDISK && limit_nr != 0)
 		limit = 0;
+	/* Ondisk backend needs DEDUP RO compat feature */
+	if (!(compat_ro_flag & BTRFS_FEATURE_COMPAT_RO_DEDUP) &&
+	    backend == BTRFS_DEDUP_BACKEND_ONDISK)
+		return -EOPNOTSUPP;
+
+	/* Meaningless and unable to enable dedup for RO fs */
+	if (fs_info->sb->s_flags & MS_RDONLY)
+		return -EROFS;
 
 	dedup_info = btrfs_dedup_get_info(fs_info);
 	if (dedup_info) {
-
 		/* Check if we are re-enable for different dedup config */
 		if (dedup_info->blocksize != blocksize ||
 		    dedup_info->hash_type != type ||
@@ -83,42 +187,107 @@ int btrfs_dedup_enable(struct btrfs_fs_info *fs_info, u16 type, u16 backend,
 		btrfs_dedup_put_info(dedup_info);
 		return 0;
 	}
-
+	dedup_info = NULL;
 enable:
-	dedup_info = kzalloc(sizeof(*dedup_info), GFP_NOFS);
-	if (dedup_info)
+	create_tree = compat_ro_flag & BTRFS_FEATURE_COMPAT_RO_DEDUP;
+
+	ret = init_dedup_info(&dedup_info, type, backend, blocksize, limit);
+	if (ret < 0)
+		return ret;
+	if (create_tree) {
+		ret = init_dedup_tree(fs_info, dedup_info);
+		if (ret < 0)
+			goto out;
+	}
+
+	spin_lock(&fs_info->dedup_ref_lock);
+	fs_info->dedup_info = dedup_info;
+	spin_unlock(&fs_info->dedup_ref_lock);
+out:
+	if (ret < 0) {
+		crypto_free_shash(dedup_info->dedup_driver);
+		kfree(dedup_info);
+	}
+	return ret;
+}
+
+int btrfs_dedup_resume(struct btrfs_fs_info *fs_info,
+		       struct btrfs_root *dedup_root)
+{
+	struct btrfs_dedup_info *dedup_info;
+	struct btrfs_dedup_status_item *status;
+	struct btrfs_key key;
+	struct btrfs_path *path;
+	u64 blocksize;
+	u64 limit;
+	u16 type;
+	u16 backend;
+	int ret = 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
 		return -ENOMEM;
 
-	dedup_info->hash_type = type;
-	dedup_info->backend = backend;
-	dedup_info->blocksize = blocksize;
-	dedup_info->limit_nr = limit;
+	key.objectid = 0;
+	key.type = BTRFS_DEDUP_STATUS_ITEM_KEY;
+	key.offset = 0;
 
-	/* Only support SHA256 yet */
-	dedup_info->dedup_driver = crypto_alloc_shash("sha256", 0, 0);
-	if (IS_ERR(dedup_info->dedup_driver)) {
-		btrfs_err(fs_info, "failed to init sha256 driver");
-		ret = PTR_ERR(dedup_info->dedup_driver);
+	ret = btrfs_search_slot(NULL, dedup_root, &key, path, 0, 0);
+	if (ret > 0) {
+		ret = -ENOENT;
+		goto out;
+	} else if (ret < 0) {
 		goto out;
 	}
 
-	dedup_info->hash_root = RB_ROOT;
-	dedup_info->bytenr_root = RB_ROOT;
-	dedup_info->current_nr = 0;
-	INIT_LIST_HEAD(&dedup_info->lru_list);
-	mutex_init(&dedup_info->lock);
-	init_waitqueue_head(&dedup_info->refs_wq);
-	atomic_set(&dedup_info->refs, 0);
+	status = btrfs_item_ptr(path->nodes[0], path->slots[0],
+				struct btrfs_dedup_status_item);
+	blocksize = btrfs_dedup_status_blocksize(path->nodes[0], status);
+	limit = btrfs_dedup_status_limit(path->nodes[0], status);
+	type = btrfs_dedup_status_hash_type(path->nodes[0], status);
+	backend = btrfs_dedup_status_backend(path->nodes[0], status);
+
+	ret = init_dedup_info(&dedup_info, type, backend, blocksize, limit);
+	if (ret < 0)
+		goto out;
+	dedup_info->dedup_root = dedup_root;
 
 	spin_lock(&fs_info->dedup_ref_lock);
 	fs_info->dedup_info = dedup_info;
 	spin_unlock(&fs_info->dedup_ref_lock);
+
 out:
-	if (ret < 0)
-		kfree(dedup_info);
+	btrfs_free_path(path);
 	return ret;
 }
 
+static void inmem_destroy(struct btrfs_dedup_info *dedup_info);
+int btrfs_dedup_cleanup(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_dedup_info *dedup_info;
+
+	/* same as disable */
+	spin_lock(&fs_info->dedup_ref_lock);
+	dedup_info = fs_info->dedup_info;
+	fs_info->dedup_info = NULL;
+	spin_unlock(&fs_info->dedup_ref_lock);
+
+	if (!dedup_info)
+		return 0;
+
+	wait_event(dedup_info->refs_wq, atomic_read(&dedup_info->refs) == 0);
+
+	if (dedup_info->backend == BTRFS_DEDUP_BACKEND_INMEMORY)
+		inmem_destroy(dedup_info);
+	if (dedup_info->dedup_root) {
+		free_root_extent_buffers(dedup_info->dedup_root);
+		kfree(dedup_info->dedup_root);
+	}
+	crypto_free_shash(dedup_info->dedup_driver);
+	kfree(dedup_info);
+	return 0;
+}
+
 static int inmem_insert_hash(struct rb_root *root,
 			     struct inmem_hash *hash, int hash_len)
 {
@@ -318,9 +487,69 @@ static void inmem_destroy(struct btrfs_dedup_info *dedup_info)
 	mutex_unlock(&dedup_info->lock);
 }
 
+static int remove_dedup_tree(struct btrfs_root *dedup_root)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_fs_info *fs_info = dedup_root->fs_info;
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	struct extent_buffer *node;
+	int ret;
+	int nr;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+	trans = btrfs_start_transaction(fs_info->tree_root, 2);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
+	}
+
+	path->leave_spinning = 1;
+	key.objectid = 0;
+	key.offset = 0;
+	key.type = 0;
+
+	while (1) {
+		ret = btrfs_search_slot(trans, dedup_root, &key, path, -1, 1);
+		if (ret < 0)
+			goto out;
+		node = path->nodes[0];
+		nr = btrfs_header_nritems(node);
+		if (nr == 0) {
+			btrfs_release_path(path);
+			break;
+		}
+		path->slots[0] = 0;
+		ret = btrfs_del_items(trans, dedup_root, path, 0, nr);
+		if (ret)
+			goto out;
+		btrfs_release_path(path);
+	}
+
+	ret = btrfs_del_root(trans, fs_info->tree_root, &dedup_root->root_key);
+	if (ret)
+		goto out;
+
+	list_del(&dedup_root->dirty_list);
+	btrfs_tree_lock(dedup_root->node);
+	clean_tree_block(trans, fs_info, dedup_root->node);
+	btrfs_tree_unlock(dedup_root->node);
+	btrfs_free_tree_block(trans, dedup_root, dedup_root->node, 0 , 1);
+	free_extent_buffer(dedup_root->node);
+	free_extent_buffer(dedup_root->commit_root);
+	kfree(dedup_root);
+	ret = btrfs_commit_transaction(trans, fs_info->tree_root);
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
 int btrfs_dedup_disable(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_dedup_info *dedup_info;
+	int ret = 0;
 
 	/* Here we don't want to increase refs of dedup_info */
 	spin_lock(&fs_info->dedup_ref_lock);
@@ -339,10 +568,12 @@ int btrfs_dedup_disable(struct btrfs_fs_info *fs_info)
 	/* now we are OK to clean up everything */
 	if (dedup_info->backend == BTRFS_DEDUP_BACKEND_INMEMORY)
 		inmem_destroy(dedup_info);
+	if (dedup_info->dedup_root)
+		ret = remove_dedup_tree(dedup_info->dedup_root);
 
 	crypto_free_shash(dedup_info->dedup_driver);
 	kfree(dedup_info);
-	return 0;
+	return ret;
 }
 
 /*
diff --git a/fs/btrfs/dedup.h b/fs/btrfs/dedup.h
index 834d66a..cf8eae6 100644
--- a/fs/btrfs/dedup.h
+++ b/fs/btrfs/dedup.h
@@ -113,6 +113,19 @@ int btrfs_dedup_enable(struct btrfs_fs_info *fs_info, u16 type, u16 backend,
 int btrfs_dedup_disable(struct btrfs_fs_info *fs_info);
 
 /*
+ * Restore previous dedup setup from disk
+ * Called at mount time
+ */
+int btrfs_dedup_resume(struct btrfs_fs_info *fs_info,
+		       struct btrfs_root *dedup_root);
+
+/*
+ * Cleanup current btrfs_dedup_info
+ * Called in umount time
+ */
+int btrfs_dedup_cleanup(struct btrfs_fs_info *fs_info);
+
+/*
  * Caller need to grab a valid dedup_info by this function,
  * not grab it from fs_info directly.
  */
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7893851..c775bec 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -50,6 +50,7 @@
 #include "raid56.h"
 #include "sysfs.h"
 #include "qgroup.h"
+#include "dedup.h"
 
 #ifdef CONFIG_X86
 #include <asm/cpufeature.h>
@@ -2155,7 +2156,7 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
 	btrfs_destroy_workqueue(fs_info->extent_workers);
 }
 
-static void free_root_extent_buffers(struct btrfs_root *root)
+void free_root_extent_buffers(struct btrfs_root *root)
 {
 	if (root) {
 		free_extent_buffer(root->node);
@@ -2487,7 +2488,21 @@ static int btrfs_read_roots(struct btrfs_fs_info *fs_info,
 		fs_info->free_space_root = root;
 	}
 
-	return 0;
+	location.objectid = BTRFS_DEDUP_TREE_OBJECTID;
+	root = btrfs_read_tree_root(tree_root, &location);
+	if (IS_ERR(root)) {
+		ret = PTR_ERR(root);
+		if (ret != -ENOENT)
+			return ret;
+		return 0;
+	}
+	set_bit(BTRFS_ROOT_TRACK_DIRTY, &root->state);
+	ret = btrfs_dedup_resume(fs_info, root);
+	if (ret < 0) {
+		free_root_extent_buffers(root);
+		kfree(root);
+	}
+	return ret;
 }
 
 int open_ctree(struct super_block *sb,
@@ -3875,6 +3890,8 @@ void close_ctree(struct btrfs_root *root)
 
 	btrfs_free_qgroup_config(fs_info);
 
+	btrfs_dedup_cleanup(fs_info);
+
 	if (percpu_counter_sum(&fs_info->delalloc_bytes)) {
 		btrfs_info(fs_info, "at unmount delalloc count %lld",
 		       percpu_counter_sum(&fs_info->delalloc_bytes));
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 8e79d00..42c4ff2 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -70,6 +70,7 @@ struct btrfs_root *btrfs_read_fs_root(struct btrfs_root *tree_root,
 int btrfs_init_fs_root(struct btrfs_root *root);
 int btrfs_insert_fs_root(struct btrfs_fs_info *fs_info,
 			 struct btrfs_root *root);
+void free_root_extent_buffers(struct btrfs_root *root);
 void btrfs_free_fs_roots(struct btrfs_fs_info *fs_info);
 
 struct btrfs_root *btrfs_get_fs_root(struct btrfs_fs_info *fs_info,
-- 
2.7.0



