Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:35808 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758135AbcCVBit (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 21:38:49 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v8 14/27] btrfs: dedupe: Add support for adding hash for on-disk backend
Date: Tue, 22 Mar 2016 09:35:39 +0800
Message-Id: <1458610552-9845-15-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now on-disk backend can add hash now.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/dedupe.c | 83 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/fs/btrfs/dedupe.c b/fs/btrfs/dedupe.c
index c38137e..6a80afc 100644
--- a/fs/btrfs/dedupe.c
+++ b/fs/btrfs/dedupe.c
@@ -405,6 +405,87 @@ out:
 	return 0;
 }
 
+static int ondisk_search_bytenr(struct btrfs_trans_handle *trans,
+				struct btrfs_dedupe_info *dedupe_info,
+				struct btrfs_path *path, u64 bytenr,
+				int prepare_del);
+static int ondisk_search_hash(struct btrfs_dedupe_info *dedupe_info, u8 *hash,
+			      u64 *bytenr_ret, u32 *num_bytes_ret);
+static int ondisk_add(struct btrfs_trans_handle *trans,
+		      struct btrfs_dedupe_info *dedupe_info,
+		      struct btrfs_dedupe_hash *hash)
+{
+	struct btrfs_path *path;
+	struct btrfs_root *dedupe_root = dedupe_info->dedupe_root;
+	struct btrfs_key key;
+	struct btrfs_dedupe_hash_item *hash_item;
+	u64 bytenr;
+	u32 num_bytes;
+	int hash_len = btrfs_dedupe_sizes[dedupe_info->hash_type];
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	mutex_lock(&dedupe_info->lock);
+
+	ret = ondisk_search_bytenr(NULL, dedupe_info, path, hash->bytenr, 0);
+	if (ret < 0)
+		goto out;
+	if (ret > 0) {
+		ret = 0;
+		goto out;
+	}
+	btrfs_release_path(path);
+
+	ret = ondisk_search_hash(dedupe_info, hash->hash, &bytenr, &num_bytes);
+	if (ret < 0)
+		goto out;
+	/* Same hash found, don't re-add to save dedupe tree space */
+	if (ret > 0) {
+		ret = 0;
+		goto out;
+	}
+
+	/* Insert hash->bytenr item */
+	memcpy(&key.objectid, hash->hash + hash_len - 8, 8);
+	key.type = BTRFS_DEDUPE_HASH_ITEM_KEY;
+	key.offset = hash->bytenr;
+
+	ret = btrfs_insert_empty_item(trans, dedupe_root, path, &key,
+			sizeof(*hash_item) + hash_len);
+	WARN_ON(ret == -EEXIST);
+	if (ret < 0)
+		goto out;
+	hash_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
+				   struct btrfs_dedupe_hash_item);
+	btrfs_set_dedupe_hash_len(path->nodes[0], hash_item, hash->num_bytes);
+	write_extent_buffer(path->nodes[0], hash->hash,
+			    (unsigned long)(hash_item + 1), hash_len);
+	btrfs_mark_buffer_dirty(path->nodes[0]);
+	btrfs_release_path(path);
+
+	/* Then bytenr->hash item */
+	key.objectid = hash->bytenr;
+	key.type = BTRFS_DEDUPE_BYTENR_ITEM_KEY;
+	memcpy(&key.offset, hash->hash + hash_len - 8, 8);
+
+	ret = btrfs_insert_empty_item(trans, dedupe_root, path, &key, hash_len);
+	WARN_ON(ret == -EEXIST);
+	if (ret < 0)
+		goto out;
+	write_extent_buffer(path->nodes[0], hash->hash,
+			btrfs_item_ptr_offset(path->nodes[0], path->slots[0]),
+			hash_len);
+	btrfs_mark_buffer_dirty(path->nodes[0]);
+
+out:
+	mutex_unlock(&dedupe_info->lock);
+	btrfs_free_path(path);
+	return ret;
+}
+
 int btrfs_dedupe_add(struct btrfs_trans_handle *trans,
 		     struct btrfs_fs_info *fs_info,
 		     struct btrfs_dedupe_hash *hash)
@@ -426,6 +507,8 @@ int btrfs_dedupe_add(struct btrfs_trans_handle *trans,
 
 	if (dedupe_info->backend == BTRFS_DEDUPE_BACKEND_INMEMORY)
 		return inmem_add(dedupe_info, hash);
+	if (dedupe_info->backend == BTRFS_DEDUPE_BACKEND_ONDISK)
+		return ondisk_add(trans, dedupe_info, hash);
 	return -EINVAL;
 }
 
-- 
2.7.3



