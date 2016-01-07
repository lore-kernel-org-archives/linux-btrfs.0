Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43542 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752519AbcAGBIv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jan 2016 20:08:51 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id BEF0941887F7
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Jan 2016 09:08:27 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v3 15/16] btrfs: dedup: Add support for adding hash for on-disk backend
Date: Thu, 7 Jan 2016 09:08:16 +0800
Message-ID: <1452128897-5433-16-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1452128897-5433-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1452128897-5433-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now on-disk backend can add hash now.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

---
v3:
  Fix a bug in writing extent buffer with wrong offset.
  Add handler for same bytenr different hashes case.
---
 fs/btrfs/dedup.c | 84 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/fs/btrfs/dedup.c b/fs/btrfs/dedup.c
index f448e27..3e09fd8 100644
--- a/fs/btrfs/dedup.c
+++ b/fs/btrfs/dedup.c
@@ -246,6 +246,8 @@ out:
 	return ret;
 }
 
+static int ondisk_search_hash(struct btrfs_dedup_info *dedup_info, u8 *hash,
+			      u64 *bytenr_ret, u64 *num_bytes_ret);
 static void inmem_destroy(struct btrfs_fs_info *fs_info);
 int btrfs_dedup_cleanup(struct btrfs_fs_info *fs_info)
 {
@@ -392,6 +394,86 @@ out:
 	return 0;
 }
 
+static int ondisk_search_bytenr(struct btrfs_trans_handle *trans,
+				struct btrfs_dedup_info *dedup_info,
+				struct btrfs_path *path, u64 bytenr,
+				int prepare_del);
+static int ondisk_add(struct btrfs_trans_handle *trans,
+		      struct btrfs_dedup_info *dedup_info,
+		      struct btrfs_dedup_hash *hash)
+{
+	struct btrfs_path *path;
+	struct btrfs_root *dedup_root = dedup_info->dedup_root;
+	struct btrfs_key key;
+	struct btrfs_dedup_hash_item *hash_item;
+	u64 bytenr;
+	u64 num_bytes;
+	int hash_len = btrfs_dedup_sizes[dedup_info->hash_type];
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	mutex_lock(&dedup_info->ondisk_lock);
+
+	/* Search for duplicated bytenr, refer inmem_add() for reason */
+	ret = ondisk_search_bytenr(NULL, dedup_info, path, hash->bytenr, 0);
+	if (ret < 0)
+		goto out;
+	if (ret > 0) {
+		ret = 0;
+		goto out;
+	}
+	btrfs_release_path(path);
+
+	ret = ondisk_search_hash(dedup_info, hash->hash, &bytenr, &num_bytes);
+	if (ret < 0)
+		goto out;
+	/* Same hash found, don't re-add to save dedup tree space */
+	if (ret > 0) {
+		ret = 0;
+		goto out;
+	}
+
+	/* Insert hash->bytenr item */
+	memcpy(&key.objectid, hash->hash + hash_len - 8, 8);
+	key.type = BTRFS_DEDUP_HASH_ITEM_KEY;
+	key.offset = hash->bytenr;
+
+	ret = btrfs_insert_empty_item(trans, dedup_root, path, &key,
+			sizeof(*hash_item) + hash_len);
+	WARN_ON(ret == -EEXIST);
+	if (ret < 0)
+		goto out;
+	hash_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
+				   struct btrfs_dedup_hash_item);
+	btrfs_set_dedup_hash_len(path->nodes[0], hash_item, hash->num_bytes);
+	write_extent_buffer(path->nodes[0], hash->hash,
+			    (unsigned long)(hash_item + 1), hash_len);
+	btrfs_mark_buffer_dirty(path->nodes[0]);
+	btrfs_release_path(path);
+
+	/* Then bytenr->hash item */
+	key.objectid = hash->bytenr;
+	key.type = BTRFS_DEDUP_BYTENR_ITEM_KEY;
+	memcpy(&key.offset, hash->hash + hash_len - 8, 8);
+
+	ret = btrfs_insert_empty_item(trans, dedup_root, path, &key, hash_len);
+	WARN_ON(ret == -EEXIST);
+	if (ret < 0)
+		goto out;
+	write_extent_buffer(path->nodes[0], hash->hash,
+			btrfs_item_ptr_offset(path->nodes[0], path->slots[0]),
+			hash_len);
+	btrfs_mark_buffer_dirty(path->nodes[0]);
+
+out:
+	mutex_unlock(&dedup_info->ondisk_lock);
+	btrfs_free_path(path);
+	return ret;
+}
+
 int btrfs_dedup_add(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		    struct btrfs_dedup_hash *hash)
 {
@@ -406,6 +488,8 @@ int btrfs_dedup_add(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 
 	if (dedup_info->backend == BTRFS_DEDUP_BACKEND_INMEMORY)
 		return inmem_add(dedup_info, hash);
+	if (dedup_info->backend == BTRFS_DEDUP_BACKEND_ONDISK)
+		return ondisk_add(trans, dedup_info, hash);
 	return -EINVAL;
 }
 
-- 
2.6.4



