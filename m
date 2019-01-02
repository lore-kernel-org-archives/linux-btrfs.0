Return-Path: <SRS0=VtQK=PK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,LOTS_OF_MONEY,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2BC9C43612
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 05:30:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F3FF21871
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 05:30:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbfABFaE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 2 Jan 2019 00:30:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:46522 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727638AbfABFaE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Jan 2019 00:30:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 11FE6AEED
        for <linux-btrfs@vger.kernel.org>; Wed,  2 Jan 2019 05:30:01 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: Introduce new incompat feature, BG_TREE
Date:   Wed,  2 Jan 2019 13:29:45 +0800
Message-Id: <20190102052945.16325-3-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190102052945.16325-1-wqu@suse.com>
References: <20190102052945.16325-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The overall idea of the new BG_TREE is pretty simple, put
BLOCK_GROUP_ITEMS into a separate tree.

This brings one obvious enhancement:
- Reduce mount time of large fs

However this feature doesn't accept mixed block groups (some in extent
tree, some in bg tree), this is designed to make kernel handle less
extra behavior, thus less bugs.

For existing fs to take advantage of this feature, btrfs-progs will
provide offline converting option.

[[Benchmark]]
Physical device:	HDD (7200RPM)
Nodesize:		4K  (to bump up tree height)
Used size:		250G
Total size:		500G
Extent data size:	1M

All file extents on disk is in 1M size, ensured by using fallocate.

Without patchset:
Use ftrace function graph:

  3)               |  open_ctree [btrfs]() {
  3)               |    btrfs_read_chunk_tree [btrfs]() {
  3) * 69033.31 us |    }
  3)               |    btrfs_verify_dev_extents [btrfs]() {
  3) * 90376.15 us |    }
  3)               |    btrfs_read_block_groups [btrfs]() {
  2) $ 2733853 us  |    } /* btrfs_read_block_groups [btrfs] */
  2) $ 3168384 us  |  } /* open_ctree [btrfs] */

 btrfs_read_block_groups() takes 87% of the total mount time,

With patchset, and use -O bg-tree mkfs option:
  7)               |  open_ctree [btrfs]() {
  7)               |    btrfs_read_chunk_tree [btrfs]() {
  7) # 2448.562 us |    }
  7)               |    btrfs_verify_dev_extents [btrfs]() {
  7) * 19802.02 us |    }
  7)               |    btrfs_read_block_groups [btrfs]() {
  7) # 8610.397 us |    }
  7) @ 113498.6 us |  }

  open_ctree() time is only 3% of original mount time.
  And btrfs_read_block_groups() only takes 7.6% of total open_ctree()
  execution time.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ctree.h                |   5 +-
 fs/btrfs/disk-io.c              |  13 ++++
 fs/btrfs/extent-tree.c          | 103 +++++++++++++++++++++++++++-----
 fs/btrfs/sysfs.c                |   2 +
 include/uapi/linux/btrfs.h      |   1 +
 include/uapi/linux/btrfs_tree.h |   3 +
 6 files changed, 110 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 80953528572d..8d27ce10e319 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -265,7 +265,8 @@ struct btrfs_super_block {
 	 BTRFS_FEATURE_INCOMPAT_RAID56 |		\
 	 BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF |		\
 	 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA |	\
-	 BTRFS_FEATURE_INCOMPAT_NO_HOLES)
+	 BTRFS_FEATURE_INCOMPAT_NO_HOLES |		\
+	 BTRFS_FEATURE_INCOMPAT_BG_TREE)
 
 #define BTRFS_FEATURE_INCOMPAT_SAFE_SET			\
 	(BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF)
@@ -758,6 +759,7 @@ struct btrfs_fs_info {
 	struct btrfs_root *quota_root;
 	struct btrfs_root *uuid_root;
 	struct btrfs_root *free_space_root;
+	struct btrfs_root *bg_root;
 
 	/* the log root tree is a directory of all the other log roots */
 	struct btrfs_root *log_root_tree;
@@ -2957,6 +2959,7 @@ static inline void free_fs_info(struct btrfs_fs_info *fs_info)
 	kfree(fs_info->quota_root);
 	kfree(fs_info->uuid_root);
 	kfree(fs_info->free_space_root);
+	kfree(fs_info->bg_root);
 	kfree(fs_info->super_copy);
 	kfree(fs_info->super_for_commit);
 	security_free_mnt_opts(&fs_info->security_opts);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b0ab41da91d1..b9986f1fcd7a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1568,6 +1568,8 @@ struct btrfs_root *btrfs_get_fs_root(struct btrfs_fs_info *fs_info,
 	if (location->objectid == BTRFS_FREE_SPACE_TREE_OBJECTID)
 		return fs_info->free_space_root ? fs_info->free_space_root :
 						  ERR_PTR(-ENOENT);
+	if (location->objectid == BTRFS_BLOCK_GROUP_TREE_OBJECTID)
+		return fs_info->bg_root ? fs_info->bg_root : ERR_PTR(-ENOENT);
 again:
 	root = btrfs_lookup_fs_root(fs_info, location->objectid);
 	if (root) {
@@ -2065,6 +2067,7 @@ static void free_root_pointers(struct btrfs_fs_info *info, int chunk_root)
 	if (chunk_root)
 		free_root_extent_buffers(info->chunk_root);
 	free_root_extent_buffers(info->free_space_root);
+	free_root_extent_buffers(info->bg_root);
 }
 
 void btrfs_free_fs_roots(struct btrfs_fs_info *fs_info)
@@ -2336,6 +2339,16 @@ static int btrfs_read_roots(struct btrfs_fs_info *fs_info)
 	set_bit(BTRFS_ROOT_TRACK_DIRTY, &root->state);
 	fs_info->extent_root = root;
 
+	if (btrfs_fs_incompat(fs_info, BG_TREE)) {
+		location.objectid = BTRFS_BLOCK_GROUP_TREE_OBJECTID;
+		root = btrfs_read_tree_root(tree_root, &location);
+		if (IS_ERR(root)) {
+			ret = PTR_ERR(root);
+			goto out;
+		}
+		set_bit(BTRFS_ROOT_TRACK_DIRTY, &root->state);
+		fs_info->bg_root = root;
+	}
 	location.objectid = BTRFS_DEV_TREE_OBJECTID;
 	root = btrfs_read_tree_root(tree_root, &location);
 	if (IS_ERR(root)) {
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 367b1a6cce60..32f71305fa49 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3298,11 +3298,15 @@ static int write_one_cache_group(struct btrfs_trans_handle *trans,
 				 struct btrfs_block_group_cache *cache)
 {
 	int ret;
-	struct btrfs_root *extent_root = fs_info->extent_root;
+	struct btrfs_root *root;
 	unsigned long bi;
 	struct extent_buffer *leaf;
 
-	ret = btrfs_search_slot(trans, extent_root, &cache->key, path, 0, 1);
+	if (btrfs_fs_incompat(fs_info, BG_TREE))
+		root = fs_info->bg_root;
+	else
+		root = fs_info->extent_root;
+	ret = btrfs_search_slot(trans, root, &cache->key, path, 0, 1);
 	if (ret) {
 		if (ret > 0)
 			ret = -ENOENT;
@@ -10047,6 +10051,56 @@ static int read_one_block_group(struct btrfs_fs_info *info,
 	return ret;
 }
 
+static int read_block_group_tree(struct btrfs_fs_info *info, int need_clear)
+{
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	int ret;
+
+	key.objectid = 0;
+	key.offset = 0;
+	key.type = 0;
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	ret = btrfs_search_slot(NULL, info->bg_root, &key, path, 0, 0);
+	if (ret < 0)
+		return ret;
+	if (ret == 0) {
+		btrfs_err(info,
+			  "found invalid block group bytenr %llu len %llu",
+			  key.objectid, key.offset);
+		ret = -EUCLEAN;
+		goto out;
+	}
+
+	while (1) {
+		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+		if (key.type != BTRFS_BLOCK_GROUP_ITEM_KEY) {
+			btrfs_err(info,
+		"found invalid key (%llu, %u, %llu) in block group tree",
+				  key.objectid, key.type, key.offset);
+			ret = -EUCLEAN;
+			goto out;
+		}
+
+		ret = read_one_block_group(info, path, need_clear);
+		if (ret < 0)
+			goto out;
+		ret = btrfs_next_item(info->bg_root, path);
+		if (ret < 0)
+			goto out;
+		if (ret > 0) {
+			ret = 0;
+			goto out;
+		}
+	}
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
 int btrfs_read_block_groups(struct btrfs_fs_info *info)
 {
 	struct btrfs_path *path;
@@ -10072,21 +10126,28 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 	if (btrfs_test_opt(info, CLEAR_CACHE))
 		need_clear = 1;
 
-	while (1) {
-		ret = find_first_block_group(info, path, &key);
-		if (ret > 0)
-			break;
-		if (ret != 0)
+	if (btrfs_fs_incompat(info, BG_TREE)) {
+		ret = read_block_group_tree(info, need_clear);
+		if (ret < 0)
 			goto error;
+	} else {
+		while (1) {
+			ret = find_first_block_group(info, path, &key);
+			if (ret > 0)
+				break;
+			if (ret != 0)
+				goto error;
 
-		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+			btrfs_item_key_to_cpu(path->nodes[0], &key,
+					      path->slots[0]);
 
-		ret = read_one_block_group(info, path, need_clear);
-		if (ret < 0)
-			goto error;
+			ret = read_one_block_group(info, path, need_clear);
+			if (ret < 0)
+				goto error;
 
-		key.objectid = key.objectid + key.offset;
-		btrfs_release_path(path);
+			key.objectid = key.objectid + key.offset;
+			btrfs_release_path(path);
+		}
 	}
 
 	list_for_each_entry_rcu(space_info, &info->space_info, list) {
@@ -10123,7 +10184,7 @@ void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_block_group_cache *block_group;
-	struct btrfs_root *extent_root = fs_info->extent_root;
+	struct btrfs_root *root;
 	struct btrfs_block_group_item item;
 	struct btrfs_key key;
 	int ret = 0;
@@ -10131,6 +10192,11 @@ void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans)
 	if (!trans->can_flush_pending_bgs)
 		return;
 
+	if (btrfs_fs_incompat(fs_info, BG_TREE))
+		root = fs_info->bg_root;
+	else
+		root = fs_info->extent_root;
+
 	while (!list_empty(&trans->new_bgs)) {
 		block_group = list_first_entry(&trans->new_bgs,
 					       struct btrfs_block_group_cache,
@@ -10143,7 +10209,7 @@ void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans)
 		memcpy(&key, &block_group->key, sizeof(key));
 		spin_unlock(&block_group->lock);
 
-		ret = btrfs_insert_item(trans, extent_root, &key, &item,
+		ret = btrfs_insert_item(trans, root, &key, &item,
 					sizeof(item));
 		if (ret)
 			btrfs_abort_transaction(trans, ret);
@@ -10254,7 +10320,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 			     u64 group_start, struct extent_map *em)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
-	struct btrfs_root *root = fs_info->extent_root;
+	struct btrfs_root *root;
 	struct btrfs_path *path;
 	struct btrfs_block_group_cache *block_group;
 	struct btrfs_free_cluster *cluster;
@@ -10272,6 +10338,11 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	BUG_ON(!block_group);
 	BUG_ON(!block_group->ro);
 
+	if (btrfs_fs_incompat(fs_info, BG_TREE))
+		root = fs_info->bg_root;
+	else
+		root = fs_info->extent_root;
+
 	trace_btrfs_remove_block_group(block_group);
 	/*
 	 * Free the reserved super bytes from this block group before
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 3717c864ba23..103528a2826b 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -191,6 +191,7 @@ BTRFS_FEAT_ATTR_INCOMPAT(extended_iref, EXTENDED_IREF);
 BTRFS_FEAT_ATTR_INCOMPAT(raid56, RAID56);
 BTRFS_FEAT_ATTR_INCOMPAT(skinny_metadata, SKINNY_METADATA);
 BTRFS_FEAT_ATTR_INCOMPAT(no_holes, NO_HOLES);
+BTRFS_FEAT_ATTR_INCOMPAT(bg_tree, BG_TREE);
 BTRFS_FEAT_ATTR_COMPAT_RO(free_space_tree, FREE_SPACE_TREE);
 
 static struct attribute *btrfs_supported_feature_attrs[] = {
@@ -205,6 +206,7 @@ static struct attribute *btrfs_supported_feature_attrs[] = {
 	BTRFS_FEAT_ATTR_PTR(skinny_metadata),
 	BTRFS_FEAT_ATTR_PTR(no_holes),
 	BTRFS_FEAT_ATTR_PTR(free_space_tree),
+	BTRFS_FEAT_ATTR_PTR(bg_tree),
 	NULL
 };
 
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 5ca1d21fc4a7..6e85ef49d97f 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -269,6 +269,7 @@ struct btrfs_ioctl_fs_info_args {
 #define BTRFS_FEATURE_INCOMPAT_RAID56		(1ULL << 7)
 #define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
 #define BTRFS_FEATURE_INCOMPAT_NO_HOLES		(1ULL << 9)
+#define BTRFS_FEATURE_INCOMPAT_BG_TREE		(1ULL << 11)
 
 struct btrfs_ioctl_feature_flags {
 	__u64 compat_flags;
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index aff1356c2bb8..6b21a6700a9e 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -48,6 +48,9 @@
 /* tracks free space in block groups. */
 #define BTRFS_FREE_SPACE_TREE_OBJECTID 10ULL
 
+/* sotre BLOCK_GROUP_ITEMs in a seprate tree */
+#define BTRFS_BLOCK_GROUP_TREE_OBJECTID 11ULL
+
 /* device stats in the device tree */
 #define BTRFS_DEV_STATS_OBJECTID 0ULL
 
-- 
2.20.1

