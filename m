Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46302 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752450AbcAGBIv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jan 2016 20:08:51 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id 0A08341887D9
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Jan 2016 09:08:26 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v3 12/16] btrfs: dedup: Introduce interfaces to resume and cleanup dedup info
Date: Thu, 7 Jan 2016 09:08:13 +0800
Message-ID: <1452128897-5433-13-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1452128897-5433-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1452128897-5433-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since we will introduce a new on-disk based dedup method, introduce new
interfaces to resume previous dedup setup.

And since we introduce a new tree for status, also add disable handler
for it.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Newly introduced
v3:
  None
---
 fs/btrfs/dedup.c   | 193 +++++++++++++++++++++++++++++++++++++++++++++++------
 fs/btrfs/dedup.h   |  11 +++
 fs/btrfs/disk-io.c |  26 +++++++-
 fs/btrfs/disk-io.h |   1 +
 4 files changed, 210 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/dedup.c b/fs/btrfs/dedup.c
index 4f24a2c..5edb923 100644
--- a/fs/btrfs/dedup.c
+++ b/fs/btrfs/dedup.c
@@ -20,6 +20,43 @@
 #include "btrfs_inode.h"
 #include "transaction.h"
 #include "delayed-ref.h"
+#include "disk-io.h"
+
+static int init_dedup_info(struct btrfs_fs_info *fs_info, u16 type, u16 backend,
+			   u64 blocksize, u64 limit)
+{
+	struct btrfs_dedup_info *dedup_info;
+	int ret;
+
+	fs_info->dedup_info = kzalloc(sizeof(*dedup_info), GFP_NOFS);
+	if (!fs_info->dedup_info)
+		return -ENOMEM;
+
+	dedup_info = fs_info->dedup_info;
+
+	dedup_info->hash_type = type;
+	dedup_info->backend = backend;
+	dedup_info->blocksize = blocksize;
+	dedup_info->limit_nr = limit;
+
+	/* Only support SHA256 yet */
+	dedup_info->dedup_driver = crypto_alloc_shash("sha256", 0, 0);
+	if (IS_ERR(dedup_info->dedup_driver)) {
+		btrfs_err(fs_info, "failed to init sha256 driver");
+		ret = PTR_ERR(dedup_info->dedup_driver);
+		kfree(fs_info->dedup_info);
+		fs_info->dedup_info = NULL;
+		return ret;
+	}
+
+	dedup_info->hash_root = RB_ROOT;
+	dedup_info->bytenr_root = RB_ROOT;
+	dedup_info->current_nr = 0;
+	INIT_LIST_HEAD(&dedup_info->lru_list);
+	spin_lock_init(&dedup_info->lock);
+	mutex_init(&dedup_info->ondisk_lock);
+	return 0;
+}
 
 struct inmem_hash {
 	struct rb_node hash_node;
@@ -44,6 +81,13 @@ int btrfs_dedup_enable(struct btrfs_fs_info *fs_info, u16 type, u16 backend,
 		       u64 blocksize, u64 limit)
 {
 	struct btrfs_dedup_info *dedup_info;
+	struct btrfs_root *dedup_root;
+	struct btrfs_key key;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_path *path;
+	struct btrfs_dedup_status_item *status;
+	int create_tree;
+	u64 compat_ro_flag = btrfs_super_compat_ro_flags(fs_info->super_copy);
 	int ret = 0;
 
 	/* Sanity check */
@@ -61,6 +105,18 @@ int btrfs_dedup_enable(struct btrfs_fs_info *fs_info, u16 type, u16 backend,
 	if (backend == BTRFS_DEDUP_BACKEND_ONDISK && limit != 0)
 		limit = 0;
 
+	/*
+	 * If current fs doesn't support DEDUP feature, don't enable
+	 * on-disk dedup.
+	 */
+	if (!(compat_ro_flag & BTRFS_FEATURE_COMPAT_RO_DEDUP) &&
+	    backend == BTRFS_DEDUP_BACKEND_ONDISK)
+		return -EINVAL;
+
+	/* Meaningless and unable to enable dedup for RO fs */
+	if (fs_info->sb->s_flags & MS_RDONLY)
+		return -EINVAL;
+
 	if (fs_info->dedup_info) {
 		dedup_info = fs_info->dedup_info;
 
@@ -80,32 +136,63 @@ int btrfs_dedup_enable(struct btrfs_fs_info *fs_info, u16 type, u16 backend,
 	}
 
 enable:
-	fs_info->dedup_info = kzalloc(sizeof(*dedup_info), GFP_NOFS);
-	if (!fs_info->dedup_info)
-		return -ENOMEM;
+	create_tree = compat_ro_flag & BTRFS_FEATURE_COMPAT_RO_DEDUP;
 
+	ret = init_dedup_info(fs_info, type, backend, blocksize, limit);
 	dedup_info = fs_info->dedup_info;
+	if (ret < 0)
+		goto out;
 
-	dedup_info->hash_type = type;
-	dedup_info->backend = backend;
-	dedup_info->blocksize = blocksize;
-	dedup_info->limit_nr = limit;
+	if (!create_tree)
+		goto out;
 
-	/* Only support SHA256 yet */
-	dedup_info->dedup_driver = crypto_alloc_shash("sha256", 0, 0);
-	if (IS_ERR(dedup_info->dedup_driver)) {
-		btrfs_err(fs_info, "failed to init sha256 driver");
-		ret = PTR_ERR(dedup_info->dedup_driver);
+	/* Create dedup tree for status at least */
+	path = btrfs_alloc_path();
+	if (!path) {
+		ret = -ENOMEM;
 		goto out;
 	}
 
-	dedup_info->hash_root = RB_ROOT;
-	dedup_info->bytenr_root = RB_ROOT;
-	dedup_info->current_nr = 0;
-	INIT_LIST_HEAD(&dedup_info->lru_list);
-	spin_lock_init(&dedup_info->lock);
+	trans = btrfs_start_transaction(fs_info->tree_root, 2);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		btrfs_free_path(path);
+		goto out;
+	}
+
+	dedup_root = btrfs_create_tree(trans, fs_info,
+				       BTRFS_DEDUP_TREE_OBJECTID);
+	if (IS_ERR(dedup_root)) {
+		ret = PTR_ERR(dedup_root);
+		btrfs_abort_transaction(trans, fs_info->tree_root, ret);
+		btrfs_free_path(path);
+		goto out;
+	}
+
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
+		btrfs_free_path(path);
+		goto out;
+	}
+	status = btrfs_item_ptr(path->nodes[0], path->slots[0],
+				struct btrfs_dedup_status_item);
+	btrfs_set_dedup_status_blocksize(path->nodes[0], status, blocksize);
+	btrfs_set_dedup_status_limit(path->nodes[0], status, limit);
+	btrfs_set_dedup_status_hash_type(path->nodes[0], status, type);
+	btrfs_set_dedup_status_backend(path->nodes[0], status, backend);
+	btrfs_mark_buffer_dirty(path->nodes[0]);
+
+	btrfs_free_path(path);
+	ret = btrfs_commit_transaction(trans, fs_info->tree_root);
 
-	fs_info->dedup_info = dedup_info;
 out:
 	if (ret < 0) {
 		kfree(dedup_info);
@@ -114,6 +201,68 @@ out:
 	return ret;
 }
 
+int btrfs_dedup_resume(struct btrfs_fs_info *fs_info,
+		       struct btrfs_root *dedup_root)
+{
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
+		return -ENOMEM;
+
+	key.objectid = 0;
+	key.type = BTRFS_DEDUP_STATUS_ITEM_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(NULL, dedup_root, &key, path, 0, 0);
+	if (ret > 0) {
+		ret = -ENOENT;
+		goto out;
+	} else if (ret < 0) {
+		goto out;
+	}
+
+	status = btrfs_item_ptr(path->nodes[0], path->slots[0],
+				struct btrfs_dedup_status_item);
+	blocksize = btrfs_dedup_status_blocksize(path->nodes[0], status);
+	limit = btrfs_dedup_status_limit(path->nodes[0], status);
+	type = btrfs_dedup_status_hash_type(path->nodes[0], status);
+	backend = btrfs_dedup_status_backend(path->nodes[0], status);
+
+	ret = init_dedup_info(fs_info, type, backend, blocksize, limit);
+	if (ret < 0)
+		goto out;
+	fs_info->dedup_info->dedup_root = dedup_root;
+
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
+static void inmem_destroy(struct btrfs_fs_info *fs_info);
+int btrfs_dedup_cleanup(struct btrfs_fs_info *fs_info)
+{
+	if (!fs_info->dedup_info)
+		return 0;
+	if (fs_info->dedup_info->backend == BTRFS_DEDUP_BACKEND_INMEMORY)
+		inmem_destroy(fs_info);
+	if (fs_info->dedup_info->dedup_root) {
+		free_root_extent_buffers(fs_info->dedup_info->dedup_root);
+		kfree(fs_info->dedup_info->dedup_root);
+	}
+	crypto_free_shash(fs_info->dedup_info->dedup_driver);
+	kfree(fs_info->dedup_info);
+	fs_info->dedup_info = NULL;
+	return 0;
+}
+
 static int inmem_insert_hash(struct rb_root *root,
 			     struct inmem_hash *hash, int hash_len)
 {
@@ -328,13 +477,19 @@ static void inmem_destroy(struct btrfs_fs_info *fs_info)
 int btrfs_dedup_disable(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_dedup_info *dedup_info = fs_info->dedup_info;
+	int ret = 0;
 
 	if (!dedup_info)
 		return 0;
 
 	if (dedup_info->backend == BTRFS_DEDUP_BACKEND_INMEMORY)
 		inmem_destroy(fs_info);
-	return 0;
+	if (dedup_info->dedup_root)
+		ret = btrfs_drop_snapshot(dedup_info->dedup_root, NULL, 1, 0);
+	crypto_free_shash(fs_info->dedup_info->dedup_driver);
+	kfree(fs_info->dedup_info);
+	fs_info->dedup_info = NULL;
+	return ret;
 }
 
 /*
diff --git a/fs/btrfs/dedup.h b/fs/btrfs/dedup.h
index 990e922..0503b98 100644
--- a/fs/btrfs/dedup.h
+++ b/fs/btrfs/dedup.h
@@ -109,6 +109,17 @@ int btrfs_dedup_enable(struct btrfs_fs_info *fs_info, u16 type, u16 backend,
 int btrfs_dedup_disable(struct btrfs_fs_info *fs_info);
 
 /*
+ * Restore previous dedup setup from disk
+ */
+int btrfs_dedup_resume(struct btrfs_fs_info *fs_info,
+		       struct btrfs_root *dedup_root);
+
+/*
+ * Free current btrfs_dedup_info
+ */
+int btrfs_dedup_cleanup(struct btrfs_fs_info *fs_info);
+
+/*
  * Calculate hash for dedup.
  * Caller must ensure [start, start + dedup_bs) has valid data.
  */
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index cf9dbff..0d84e17 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -49,6 +49,7 @@
 #include "raid56.h"
 #include "sysfs.h"
 #include "qgroup.h"
+#include "dedup.h"
 
 #ifdef CONFIG_X86
 #include <asm/cpufeature.h>
@@ -2127,7 +2128,7 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
 	btrfs_destroy_workqueue(fs_info->extent_workers);
 }
 
-static void free_root_extent_buffers(struct btrfs_root *root)
+void free_root_extent_buffers(struct btrfs_root *root)
 {
 	if (root) {
 		free_extent_buffer(root->node);
@@ -2449,7 +2450,25 @@ static int btrfs_read_roots(struct btrfs_fs_info *fs_info,
 		fs_info->uuid_root = root;
 	}
 
-	return 0;
+	location.objectid = BTRFS_DEDUP_TREE_OBJECTID;
+	root = btrfs_read_tree_root(tree_root, &location);
+	if (IS_ERR(root)) {
+		ret = PTR_ERR(root);
+		if (ret != -ENOENT)
+			return ret;
+		/* Just OK if there is no dedup root */
+		return 0;
+	}
+
+	set_bit(BTRFS_ROOT_TRACK_DIRTY, &root->state);
+	/* Found dedup root, resume previous dedup setup */
+	ret = btrfs_dedup_resume(fs_info, root);
+
+	if (ret < 0) {
+		free_root_extent_buffers(root);
+		kfree(root);
+	}
+	return ret;
 }
 
 int open_ctree(struct super_block *sb,
@@ -3836,6 +3855,9 @@ void close_ctree(struct btrfs_root *root)
 
 	btrfs_free_qgroup_config(fs_info);
 
+	/* Cleanup dedup info */
+	btrfs_dedup_cleanup(fs_info);
+
 	if (percpu_counter_sum(&fs_info->delalloc_bytes)) {
 		btrfs_info(fs_info, "at unmount delalloc count %lld",
 		       percpu_counter_sum(&fs_info->delalloc_bytes));
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index adeb318..4cbdce1 100644
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
2.6.4



