Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:27258 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbcBEBYy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Feb 2016 20:24:54 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v6 14/19] btrfs: dedup: Add support for adding hash for on-disk backend
Date: Fri,  5 Feb 2016 09:22:34 +0800
Message-Id: <1454635359-10013-15-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1454635359-10013-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1454635359-10013-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now on-disk backend can add hash now.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/dedup.c | 83 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/fs/btrfs/dedup.c b/fs/btrfs/dedup.c
index 59b32a5..8972cff 100644
--- a/fs/btrfs/dedup.c
+++ b/fs/btrfs/dedup.c
@@ -404,6 +404,87 @@ out:
 	return 0;
 }
 
+static int ondisk_search_bytenr(struct btrfs_trans_handle *trans,
+				struct btrfs_dedup_info *dedup_info,
+				struct btrfs_path *path, u64 bytenr,
+				int prepare_del);
+static int ondisk_search_hash(struct btrfs_dedup_info *dedup_info, u8 *hash,
+			      u64 *bytenr_ret, u32 *num_bytes_ret);
+static int ondisk_add(struct btrfs_trans_handle *trans,
+		      struct btrfs_dedup_info *dedup_info,
+		      struct btrfs_dedup_hash *hash)
+{
+	struct btrfs_path *path;
+	struct btrfs_root *dedup_root = dedup_info->dedup_root;
+	struct btrfs_key key;
+	struct btrfs_dedup_hash_item *hash_item;
+	u64 bytenr;
+	u32 num_bytes;
+	int hash_len = btrfs_dedup_sizes[dedup_info->hash_type];
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	mutex_lock(&dedup_info->lock);
+
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
+	mutex_unlock(&dedup_info->lock);
+	btrfs_free_path(path);
+	return ret;
+}
+
 int btrfs_dedup_add(struct btrfs_trans_handle *trans,
 		    struct btrfs_fs_info *fs_info,
 		    struct btrfs_dedup_hash *hash)
@@ -425,6 +506,8 @@ int btrfs_dedup_add(struct btrfs_trans_handle *trans,
 
 	if (dedup_info->backend == BTRFS_DEDUP_BACKEND_INMEMORY)
 		return inmem_add(dedup_info, hash);
+	if (dedup_info->backend == BTRFS_DEDUP_BACKEND_ONDISK)
+		return ondisk_add(trans, dedup_info, hash);
 	return -EINVAL;
 }
 
-- 
2.7.0



