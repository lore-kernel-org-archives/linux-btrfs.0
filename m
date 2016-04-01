Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:12218 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758576AbcDAGfq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Apr 2016 02:35:46 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v10 17/21] btrfs: dedupe: Introduce interfaces to resume and cleanup dedupe info
Date: Fri,  1 Apr 2016 14:35:08 +0800
Message-Id: <1459492512-31435-18-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1459492512-31435-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1459492512-31435-1-git-send-email-quwenruo@cn.fujitsu.com>
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
 fs/btrfs/dedupe.c  | 197 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/dedupe.h  |  13 ++++
 fs/btrfs/disk-io.c |  25 ++++++-
 fs/btrfs/disk-io.h |   1 +
 4 files changed, 232 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/dedupe.c b/fs/btrfs/dedupe.c
index cfb7fea..a274c1c 100644
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
@@ -102,10 +104,69 @@ static int init_dedupe_info(struct btrfs_dedupe_info **ret_info, u16 type,
 	return 0;
 }
 
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
 static int check_dedupe_parameter(struct btrfs_fs_info *fs_info, u16 hash_type,
 				  u16 backend, u64 blocksize, u64 limit_nr,
 				  u64 limit_mem, u64 *ret_limit)
 {
+	u64 compat_ro_flag = btrfs_super_compat_ro_flags(fs_info->super_copy);
+
 	if (blocksize > BTRFS_DEDUPE_BLOCKSIZE_MAX ||
 	    blocksize < BTRFS_DEDUPE_BLOCKSIZE_MIN ||
 	    blocksize < fs_info->tree_root->sectorsize ||
@@ -140,8 +201,12 @@ static int check_dedupe_parameter(struct btrfs_fs_info *fs_info, u16 hash_type,
 			*ret_limit = min(tmp, limit_nr);
 		}
 	}
-	if (backend == BTRFS_DEDUPE_BACKEND_ONDISK)
+	if (backend == BTRFS_DEDUPE_BACKEND_ONDISK) {
+		/* Ondisk backend must use RO compat feature */
+		if (!(compat_ro_flag & BTRFS_FEATURE_COMPAT_RO_DEDUPE))
+			return -EOPNOTSUPP;
 		*ret_limit = 0;
+	}
 	return 0;
 }
 
@@ -150,11 +215,16 @@ int btrfs_dedupe_enable(struct btrfs_fs_info *fs_info, u16 type, u16 backend,
 {
 	struct btrfs_dedupe_info *dedupe_info;
 	u64 limit = 0;
+	u64 compat_ro_flag = btrfs_super_compat_ro_flags(fs_info->super_copy);
+	int create_tree;
 	int ret = 0;
 
 	/* only one limit is accepted for enable*/
 	if (limit_nr && limit_mem)
 		return -EINVAL;
+	/* enable and disable may modify ondisk data, so block RO fs*/
+	if (fs_info->sb->s_flags & MS_RDONLY)
+		return -EROFS;
 
 	ret = check_dedupe_parameter(fs_info, type, backend, blocksize,
 				     limit_nr, limit_mem, &limit);
@@ -179,9 +249,19 @@ int btrfs_dedupe_enable(struct btrfs_fs_info *fs_info, u16 type, u16 backend,
 	}
 
 enable:
+	create_tree = compat_ro_flag & BTRFS_FEATURE_COMPAT_RO_DEDUPE;
+
 	ret = init_dedupe_info(&dedupe_info, type, backend, blocksize, limit);
 	if (ret < 0)
 		return ret;
+	if (create_tree) {
+		ret = init_dedupe_tree(fs_info, dedupe_info);
+		if (ret < 0) {
+			crypto_free_shash(dedupe_info->dedupe_driver);
+			kfree(dedupe_info);
+			return ret;
+		}
+	}
 	fs_info->dedupe_info = dedupe_info;
 	/* We must ensure dedupe_enabled is modified after dedupe_info */
 	smp_wmb();
@@ -189,6 +269,55 @@ enable:
 	return ret;
 }
 
+int btrfs_dedupe_resume(struct btrfs_fs_info *fs_info,
+			struct btrfs_root *dedupe_root)
+{
+	struct btrfs_dedupe_info *dedupe_info;
+	struct btrfs_dedupe_status_item *status;
+	struct btrfs_key key;
+	struct btrfs_path *path;
+	u64 blocksize;
+	u64 limit_nr;
+	u64 limit;
+	u16 type;
+	u16 backend;
+	int ret = 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	key.objectid = 0;
+	key.type = BTRFS_DEDUPE_STATUS_ITEM_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(NULL, dedupe_root, &key, path, 0, 0);
+	if (ret > 0) {
+		ret = -ENOENT;
+		goto out;
+	} else if (ret < 0) {
+		goto out;
+	}
+	status = btrfs_item_ptr(path->nodes[0], path->slots[0],
+				struct btrfs_dedupe_status_item);
+	blocksize = btrfs_dedupe_status_blocksize(path->nodes[0], status);
+	limit_nr = btrfs_dedupe_status_limit(path->nodes[0], status);
+	type = btrfs_dedupe_status_hash_type(path->nodes[0], status);
+	backend = btrfs_dedupe_status_backend(path->nodes[0], status);
+
+	ret = check_dedupe_parameter(fs_info, type, backend, blocksize,
+				     limit_nr, 0, &limit);
+	if (ret < 0)
+		goto out;
+	ret = init_dedupe_info(&dedupe_info, type, backend, blocksize, limit);
+	if (ret < 0)
+		goto out;
+	dedupe_info->dedupe_root = dedupe_root;
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
 static int inmem_insert_hash(struct rb_root *root,
 			     struct inmem_hash *hash, int hash_len)
 {
@@ -413,12 +542,74 @@ int btrfs_dedupe_cleanup(struct btrfs_fs_info *fs_info)
 
 	if (dedupe_info->backend == BTRFS_DEDUPE_BACKEND_INMEMORY)
 		inmem_destroy(dedupe_info);
-
+	if (dedupe_info->dedupe_root) {
+		free_root_extent_buffers(dedupe_info->dedupe_root);
+		kfree(dedupe_info->dedupe_root);
+	}
 	crypto_free_shash(dedupe_info->dedupe_driver);
 	kfree(dedupe_info);
 	return 0;
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
@@ -452,6 +643,8 @@ int btrfs_dedupe_disable(struct btrfs_fs_info *fs_info)
 	/* now we are OK to clean up everything */
 	if (dedupe_info->backend == BTRFS_DEDUPE_BACKEND_INMEMORY)
 		inmem_destroy(dedupe_info);
+	if (dedupe_info->dedupe_root)
+		ret = remove_dedupe_tree(dedupe_info->dedupe_root);
 
 	crypto_free_shash(dedupe_info->dedupe_driver);
 	kfree(dedupe_info);
diff --git a/fs/btrfs/dedupe.h b/fs/btrfs/dedupe.h
index 1ac1bcb..2038ab8 100644
--- a/fs/btrfs/dedupe.h
+++ b/fs/btrfs/dedupe.h
@@ -123,6 +123,19 @@ void btrfs_dedupe_status(struct btrfs_fs_info *fs_info,
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
  * Cleanup current btrfs_dedupe_info
  * Called in umount time
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c7eda03..4ba27b0 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2162,7 +2162,7 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
 	btrfs_destroy_workqueue(fs_info->extent_workers);
 }
 
-static void free_root_extent_buffers(struct btrfs_root *root)
+void free_root_extent_buffers(struct btrfs_root *root)
 {
 	if (root) {
 		free_extent_buffer(root->node);
@@ -2496,7 +2496,28 @@ static int btrfs_read_roots(struct btrfs_fs_info *fs_info,
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
+
+	set_bit(BTRFS_ROOT_TRACK_DIRTY, &root->state);
+	ret = btrfs_dedupe_resume(fs_info, root);
+	if (ret < 0) {
+		if (ret == -EINVAL)
+			btrfs_err(fs_info,
+				"invalid dedupe parameter found");
+		if (ret == -EOPNOTSUPP)
+			btrfs_err(fs_info,
+				"unsupported dedupe parameter found");
+		free_root_extent_buffers(root);
+		kfree(root);
+	}
+	return ret;
 }
 
 int open_ctree(struct super_block *sb,
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
2.7.4



