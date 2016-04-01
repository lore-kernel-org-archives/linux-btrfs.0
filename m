Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:33345 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758635AbcDAGfr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Apr 2016 02:35:47 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v10 20/21] btrfs: dedupe: Add support for adding hash for on-disk backend
Date: Fri,  1 Apr 2016 14:35:11 +0800
Message-Id: <1459492512-31435-21-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1459492512-31435-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1459492512-31435-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now on-disk backend can add hash now.

Since all needed on-disk backend functions are added, also allow on-disk
backend to be used, by changing DEDUPE_BACKEND_COUNT from 1(inmemory
only) to 2 (inmemory + ondisk).

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/dedupe.c | 83 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/dedupe.h |  3 +-
 2 files changed, 84 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/dedupe.c b/fs/btrfs/dedupe.c
index 7c5d58a..1f0178e 100644
--- a/fs/btrfs/dedupe.c
+++ b/fs/btrfs/dedupe.c
@@ -437,6 +437,87 @@ out:
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
+	u64 hash_offset;
+	u64 bytenr;
+	u32 num_bytes;
+	int hash_len = btrfs_dedupe_sizes[dedupe_info->hash_type];
+	int ret;
+
+	if (WARN_ON(hash_len <= 8 ||
+	    !IS_ALIGNED(hash->bytenr, dedupe_root->sectorsize)))
+		return -EINVAL;
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
+	/* The last 8 bit will not be included into hash */
+	ret = btrfs_insert_empty_item(trans, dedupe_root, path, &key,
+				      hash_len - 8);
+	WARN_ON(ret == -EEXIST);
+	if (ret < 0)
+		goto out;
+	hash_offset = btrfs_item_ptr_offset(path->nodes[0], path->slots[0]);
+	write_extent_buffer(path->nodes[0], hash->hash,
+			    hash_offset, hash_len - 8);
+	btrfs_mark_buffer_dirty(path->nodes[0]);
+	btrfs_release_path(path);
+
+	/* Then bytenr->hash item */
+	key.objectid = hash->bytenr;
+	key.type = BTRFS_DEDUPE_BYTENR_ITEM_KEY;
+	memcpy(&key.offset, hash->hash + hash_len - 8, 8);
+
+	ret = btrfs_insert_empty_item(trans, dedupe_root, path, &key, 0);
+	WARN_ON(ret == -EEXIST);
+	if (ret < 0)
+		goto out;
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
@@ -458,6 +539,8 @@ int btrfs_dedupe_add(struct btrfs_trans_handle *trans,
 
 	if (dedupe_info->backend == BTRFS_DEDUPE_BACKEND_INMEMORY)
 		return inmem_add(dedupe_info, hash);
+	if (dedupe_info->backend == BTRFS_DEDUPE_BACKEND_ONDISK)
+		return ondisk_add(trans, dedupe_info, hash);
 	return -EINVAL;
 }
 
diff --git a/fs/btrfs/dedupe.h b/fs/btrfs/dedupe.h
index bfcacd7..1573456 100644
--- a/fs/btrfs/dedupe.h
+++ b/fs/btrfs/dedupe.h
@@ -31,8 +31,7 @@
 #define BTRFS_DEDUPE_BACKEND_INMEMORY		0
 #define BTRFS_DEDUPE_BACKEND_ONDISK		1
 
-/* Only support inmemory yet, so count is still only 1 */
-#define BTRFS_DEDUPE_BACKEND_COUNT		1
+#define BTRFS_DEDUPE_BACKEND_COUNT		2
 
 /* Dedup block size limit and default value */
 #define BTRFS_DEDUPE_BLOCKSIZE_MAX	(8 * 1024 * 1024)
-- 
2.7.4



