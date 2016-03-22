Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:47035 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758156AbcCVBi6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 21:38:58 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v8 11/27] btrfs: dedupe: Introduce interfaces to resume and cleanup dedupe info
Date: Tue, 22 Mar 2016 09:35:36 +0800
Message-Id: <1458610552-9845-12-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since we will introduce a new on-disk based dedupe method, introduce new
interfaces to resume previous dedupe setup.

And since we introduce a new tree for status, also add disable handler
for it.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/dedupe.c  | 269 +++++++++++++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/dedupe.h  |  13 +++
 fs/btrfs/disk-io.c |  21 ++++-
 fs/btrfs/disk-io.h |   1 +
 4 files changed, 283 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/dedupe.c b/fs/btrfs/dedupe.c
index 7ef2c37..1112fec 100644
--- a/fs/btrfs/dedupe.c
+++ b/fs/btrfs/dedupe.c
@@ -21,6 +21,8 @@
 #include "transaction.h"
 #include "delayed-ref.h"
 #include "qgroup.h"
+#include "disk-io.h"
+#include "locking.h"
 
 struct inmem_hash {
 	struct rb_node hash_node;
@@ -41,10 +43,103 @@ static inline struct inmem_hash *inmem_alloc_hash(u16 type)
 			GFP_NOFS);
 }
 
+static int init_dedupe_info(struct btrfs_dedupe_info **ret_info, u16 type,
+			    u16 backend, u64 blocksize, u64 limit)
+{
+	struct btrfs_dedupe_info *dedupe_info;
+
+	dedupe_info = kzalloc(sizeof(*dedupe_info), GFP_NOFS);
+	if (!dedupe_info)
+		return -ENOMEM;
+
+	dedupe_info->hash_type = type;
+	dedupe_info->backend = backend;
+	dedupe_info->blocksize = blocksize;
+	dedupe_info->limit_nr = limit;
+
+	/* only support SHA256 yet */
+	dedupe_info->dedupe_driver = crypto_alloc_shash("sha256", 0, 0);
+	if (IS_ERR(dedupe_info->dedupe_driver)) {
+		int ret;
+
+		ret = PTR_ERR(dedupe_info->dedupe_driver);
+		kfree(dedupe_info);
+		return ret;
+	}
+
+	dedupe_info->hash_root = RB_ROOT;
+	dedupe_info->bytenr_root = RB_ROOT;
+	dedupe_info->current_nr = 0;
+	INIT_LIST_HEAD(&dedupe_info->lru_list);
+	mutex_init(&dedupe_info->lock);
+
+	*ret_info = dedupe_info;
+	return 0;
+}
+
+static int init_dedupe_tree(struct btrfs_fs_info *fs_info,
+			    struct btrfs_dedupe_info *dedupe_info)
+{
+	struct btrfs_root *dedupe_root;
+	struct btrfs_key key;
+	struct btrfs_path *path;
+	struct btrfs_dedupe_status_item *status;
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
+	dedupe_root = btrfs_create_tree(trans, fs_info,
+				       BTRFS_DEDUPE_TREE_OBJECTID);
+	if (IS_ERR(dedupe_root)) {
+		ret = PTR_ERR(dedupe_root);
+		btrfs_abort_transaction(trans, fs_info->tree_root, ret);
+		goto out;
+	}
+	dedupe_info->dedupe_root = dedupe_root;
+
+	key.objectid = 0;
+	key.type = BTRFS_DEDUPE_STATUS_ITEM_KEY;
+	key.offset = 0;
+
+	ret = btrfs_insert_empty_item(trans, dedupe_root, path, &key,
+				      sizeof(*status));
+	if (ret < 0) {
+		btrfs_abort_transaction(trans, fs_info->tree_root, ret);
+		goto out;
+	}
+
+	status = btrfs_item_ptr(path->nodes[0], path->slots[0],
+				struct btrfs_dedupe_status_item);
+	btrfs_set_dedupe_status_blocksize(path->nodes[0], status,
+					 dedupe_info->blocksize);
+	btrfs_set_dedupe_status_limit(path->nodes[0], status,
+			dedupe_info->limit_nr);
+	btrfs_set_dedupe_status_hash_type(path->nodes[0], status,
+			dedupe_info->hash_type);
+	btrfs_set_dedupe_status_backend(path->nodes[0], status,
+			dedupe_info->backend);
+	btrfs_mark_buffer_dirty(path->nodes[0]);
+out:
+	btrfs_free_path(path);
+	if (ret == 0)
+		btrfs_commit_transaction(trans, fs_info->tree_root);
+	return ret;
+}
+
 int btrfs_dedupe_enable(struct btrfs_fs_info *fs_info, u16 type, u16 backend,
 			u64 blocksize, u64 limit_nr)
 {
 	struct btrfs_dedupe_info *dedupe_info;
+	int create_tree;
+	u64 compat_ro_flag = btrfs_super_compat_ro_flags(fs_info->super_copy);
 	u64 limit = limit_nr;
 	int ret = 0;
 
@@ -63,6 +158,14 @@ int btrfs_dedupe_enable(struct btrfs_fs_info *fs_info, u16 type, u16 backend,
 		limit = BTRFS_DEDUPE_LIMIT_NR_DEFAULT;
 	if (backend == BTRFS_DEDUPE_BACKEND_ONDISK && limit_nr != 0)
 		limit = 0;
+	/* Ondisk backend needs DEDUP RO compat feature */
+	if (!(compat_ro_flag & BTRFS_FEATURE_COMPAT_RO_DEDUPE) &&
+	    backend == BTRFS_DEDUPE_BACKEND_ONDISK)
+		return -EOPNOTSUPP;
+
+	/* Meaningless and unable to enable dedupe for RO fs */
+	if (fs_info->sb->s_flags & MS_RDONLY)
+		return -EROFS;
 
 	dedupe_info = fs_info->dedupe_info;
 	if (dedupe_info) {
@@ -81,29 +184,71 @@ int btrfs_dedupe_enable(struct btrfs_fs_info *fs_info, u16 type, u16 backend,
 		return 0;
 	}
 
+	dedupe_info = NULL;
 enable:
-	dedupe_info = kzalloc(sizeof(*dedupe_info), GFP_NOFS);
-	if (dedupe_info)
+	create_tree = compat_ro_flag & BTRFS_FEATURE_COMPAT_RO_DEDUPE;
+
+	ret = init_dedupe_info(&dedupe_info, type, backend, blocksize, limit);
+	if (ret < 0)
+		return ret;
+	if (create_tree) {
+		ret = init_dedupe_tree(fs_info, dedupe_info);
+		if (ret < 0)
+			goto out;
+	}
+
+	fs_info->dedupe_info = dedupe_info;
+	/* We must ensure dedupe_enabled is modified after dedupe_info */
+	smp_wmb();
+	fs_info->dedupe_enabled = 1;
+out:
+	if (ret < 0) {
+		crypto_free_shash(dedupe_info->dedupe_driver);
+		kfree(dedupe_info);
+	}
+	return ret;
+}
+
+int btrfs_dedupe_resume(struct btrfs_fs_info *fs_info,
+			struct btrfs_root *dedupe_root)
+{
+	struct btrfs_dedupe_info *dedupe_info;
+	struct btrfs_dedupe_status_item *status;
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
 
-	dedupe_info->hash_type = type;
-	dedupe_info->backend = backend;
-	dedupe_info->blocksize = blocksize;
-	dedupe_info->limit_nr = limit;
+	key.objectid = 0;
+	key.type = BTRFS_DEDUPE_STATUS_ITEM_KEY;
+	key.offset = 0;
 
-	/* Only support SHA256 yet */
-	dedupe_info->dedupe_driver = crypto_alloc_shash("sha256", 0, 0);
-	if (IS_ERR(dedupe_info->dedupe_driver)) {
-		btrfs_err(fs_info, "failed to init sha256 driver");
-		ret = PTR_ERR(dedupe_info->dedupe_driver);
+	ret = btrfs_search_slot(NULL, dedupe_root, &key, path, 0, 0);
+	if (ret > 0) {
+		ret = -ENOENT;
+		goto out;
+	} else if (ret < 0) {
 		goto out;
 	}
 
-	dedupe_info->hash_root = RB_ROOT;
-	dedupe_info->bytenr_root = RB_ROOT;
-	dedupe_info->current_nr = 0;
-	INIT_LIST_HEAD(&dedupe_info->lru_list);
-	mutex_init(&dedupe_info->lock);
+	status = btrfs_item_ptr(path->nodes[0], path->slots[0],
+				struct btrfs_dedupe_status_item);
+	blocksize = btrfs_dedupe_status_blocksize(path->nodes[0], status);
+	limit = btrfs_dedupe_status_limit(path->nodes[0], status);
+	type = btrfs_dedupe_status_hash_type(path->nodes[0], status);
+	backend = btrfs_dedupe_status_backend(path->nodes[0], status);
+
+	ret = init_dedupe_info(&dedupe_info, type, backend, blocksize, limit);
+	if (ret < 0)
+		goto out;
+	dedupe_info->dedupe_root = dedupe_root;
 
 	fs_info->dedupe_info = dedupe_info;
 	/* We must ensure dedupe_enabled is modified after dedupe_info */
@@ -111,11 +256,36 @@ enable:
 	fs_info->dedupe_enabled = 1;
 
 out:
-	if (ret < 0)
-		kfree(dedupe_info);
+	btrfs_free_path(path);
 	return ret;
 }
 
+static void inmem_destroy(struct btrfs_dedupe_info *dedupe_info);
+int btrfs_dedupe_cleanup(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_dedupe_info *dedupe_info;
+
+	fs_info->dedupe_enabled = 0;
+
+	/* same as disable */
+	smp_wmb();
+	dedupe_info = fs_info->dedupe_info;
+	fs_info->dedupe_info = NULL;
+
+	if (!dedupe_info)
+		return 0;
+
+	if (dedupe_info->backend == BTRFS_DEDUPE_BACKEND_INMEMORY)
+		inmem_destroy(dedupe_info);
+	if (dedupe_info->dedupe_root) {
+		free_root_extent_buffers(dedupe_info->dedupe_root);
+		kfree(dedupe_info->dedupe_root);
+	}
+	crypto_free_shash(dedupe_info->dedupe_driver);
+	kfree(dedupe_info);
+	return 0;
+}
+
 static int inmem_insert_hash(struct rb_root *root,
 			     struct inmem_hash *hash, int hash_len)
 {
@@ -325,6 +495,65 @@ static void inmem_destroy(struct btrfs_dedupe_info *dedupe_info)
 	mutex_unlock(&dedupe_info->lock);
 }
 
+static int remove_dedupe_tree(struct btrfs_root *dedupe_root)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_fs_info *fs_info = dedupe_root->fs_info;
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
+		ret = btrfs_search_slot(trans, dedupe_root, &key, path, -1, 1);
+		if (ret < 0)
+			goto out;
+		node = path->nodes[0];
+		nr = btrfs_header_nritems(node);
+		if (nr == 0) {
+			btrfs_release_path(path);
+			break;
+		}
+		path->slots[0] = 0;
+		ret = btrfs_del_items(trans, dedupe_root, path, 0, nr);
+		if (ret)
+			goto out;
+		btrfs_release_path(path);
+	}
+
+	ret = btrfs_del_root(trans, fs_info->tree_root, &dedupe_root->root_key);
+	if (ret)
+		goto out;
+
+	list_del(&dedupe_root->dirty_list);
+	btrfs_tree_lock(dedupe_root->node);
+	clean_tree_block(trans, fs_info, dedupe_root->node);
+	btrfs_tree_unlock(dedupe_root->node);
+	btrfs_free_tree_block(trans, dedupe_root, dedupe_root->node, 0, 1);
+	free_extent_buffer(dedupe_root->node);
+	free_extent_buffer(dedupe_root->commit_root);
+	kfree(dedupe_root);
+	ret = btrfs_commit_transaction(trans, fs_info->tree_root);
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
 int btrfs_dedupe_disable(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_dedupe_info *dedupe_info;
@@ -358,10 +587,12 @@ int btrfs_dedupe_disable(struct btrfs_fs_info *fs_info)
 	/* now we are OK to clean up everything */
 	if (dedupe_info->backend == BTRFS_DEDUPE_BACKEND_INMEMORY)
 		inmem_destroy(dedupe_info);
+	if (dedupe_info->dedupe_root)
+		ret = remove_dedupe_tree(dedupe_info->dedupe_root);
 
 	crypto_free_shash(dedupe_info->dedupe_driver);
 	kfree(dedupe_info);
-	return 0;
+	return ret;
 }
 
 /*
diff --git a/fs/btrfs/dedupe.h b/fs/btrfs/dedupe.h
index 537f0b8..120e630 100644
--- a/fs/btrfs/dedupe.h
+++ b/fs/btrfs/dedupe.h
@@ -112,6 +112,19 @@ int btrfs_dedupe_enable(struct btrfs_fs_info *fs_info, u16 type, u16 backend,
  */
 int btrfs_dedupe_disable(struct btrfs_fs_info *fs_info);
 
+ /*
+ * Restore previous dedupe setup from disk
+ * Called at mount time
+ */
+int btrfs_dedupe_resume(struct btrfs_fs_info *fs_info,
+		       struct btrfs_root *dedupe_root);
+
+/*
+ * Cleanup current btrfs_dedupe_info
+ * Called in umount time
+ */
+int btrfs_dedupe_cleanup(struct btrfs_fs_info *fs_info);
+
 /*
  * Calculate hash for dedup.
  * Caller must ensure [start, start + dedupe_bs) has valid data.
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 57ae928..44d098d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -51,6 +51,7 @@
 #include "sysfs.h"
 #include "qgroup.h"
 #include "compression.h"
+#include "dedupe.h"
 
 #ifdef CONFIG_X86
 #include <asm/cpufeature.h>
@@ -2156,7 +2157,7 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
 	btrfs_destroy_workqueue(fs_info->extent_workers);
 }
 
-static void free_root_extent_buffers(struct btrfs_root *root)
+void free_root_extent_buffers(struct btrfs_root *root)
 {
 	if (root) {
 		free_extent_buffer(root->node);
@@ -2490,7 +2491,21 @@ static int btrfs_read_roots(struct btrfs_fs_info *fs_info,
 		fs_info->free_space_root = root;
 	}
 
-	return 0;
+	location.objectid = BTRFS_DEDUPE_TREE_OBJECTID;
+	root = btrfs_read_tree_root(tree_root, &location);
+	if (IS_ERR(root)) {
+		ret = PTR_ERR(root);
+		if (ret != -ENOENT)
+			return ret;
+		return 0;
+	}
+	set_bit(BTRFS_ROOT_TRACK_DIRTY, &root->state);
+	ret = btrfs_dedupe_resume(fs_info, root);
+	if (ret < 0) {
+		free_root_extent_buffers(root);
+		kfree(root);
+	}
+	return ret;
 }
 
 int open_ctree(struct super_block *sb,
@@ -3885,6 +3900,8 @@ void close_ctree(struct btrfs_root *root)
 
 	btrfs_free_qgroup_config(fs_info);
 
+	btrfs_dedupe_cleanup(fs_info);
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
2.7.3



