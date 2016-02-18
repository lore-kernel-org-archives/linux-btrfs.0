Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:24930 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1425126AbcBRFpo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Feb 2016 00:45:44 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, clm@fb.com
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v7 12/20] btrfs: dedup: Add support for on-disk hash search
Date: Thu, 18 Feb 2016 13:42:50 +0800
Message-Id: <1455774178-3595-13-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1455774178-3595-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1455774178-3595-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now on-disk backend should be able to search hash now.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/dedup.c | 133 ++++++++++++++++++++++++++++++++++++++++++++++++-------
 fs/btrfs/dedup.h |   1 +
 2 files changed, 118 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/dedup.c b/fs/btrfs/dedup.c
index ad7b7e1..61a5d7a 100644
--- a/fs/btrfs/dedup.c
+++ b/fs/btrfs/dedup.c
@@ -594,6 +594,79 @@ int btrfs_dedup_disable(struct btrfs_fs_info *fs_info)
 	return ret;
 }
 
+ /*
+ * Return 0 for not found
+ * Return >0 for found and set bytenr_ret
+ * Return <0 for error
+ */
+static int ondisk_search_hash(struct btrfs_dedup_info *dedup_info, u8 *hash,
+			      u64 *bytenr_ret, u32 *num_bytes_ret)
+{
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	struct btrfs_root *dedup_root = dedup_info->dedup_root;
+	u8 *buf = NULL;
+	u64 hash_key;
+	int hash_len = btrfs_dedup_sizes[dedup_info->hash_type];
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	buf = kmalloc(hash_len, GFP_NOFS);
+	if (!buf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	memcpy(&hash_key, hash + hash_len - 8, 8);
+	key.objectid = hash_key;
+	key.type = BTRFS_DEDUP_HASH_ITEM_KEY;
+	key.offset = (u64)-1;
+
+	ret = btrfs_search_slot(NULL, dedup_root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+	WARN_ON(ret == 0);
+	while (1) {
+		struct extent_buffer *node;
+		struct btrfs_dedup_hash_item *hash_item;
+		int slot;
+
+		ret = btrfs_previous_item(dedup_root, path, hash_key,
+					  BTRFS_DEDUP_HASH_ITEM_KEY);
+		if (ret < 0)
+			goto out;
+		if (ret > 0) {
+			ret = 0;
+			goto out;
+		}
+
+		node = path->nodes[0];
+		slot = path->slots[0];
+		btrfs_item_key_to_cpu(node, &key, slot);
+
+		if (key.type != BTRFS_DEDUP_HASH_ITEM_KEY ||
+		    memcmp(&key.objectid, hash + hash_len - 8, 8))
+			break;
+		hash_item = btrfs_item_ptr(node, slot,
+				struct btrfs_dedup_hash_item);
+		read_extent_buffer(node, buf, (unsigned long)(hash_item + 1),
+				   hash_len);
+		if (!memcmp(buf, hash, hash_len)) {
+			ret = 1;
+			*bytenr_ret = key.offset;
+			*num_bytes_ret = btrfs_dedup_hash_len(node, hash_item);
+			break;
+		}
+	}
+out:
+	kfree(buf);
+	btrfs_free_path(path);
+	return ret;
+}
+
 /*
  * Caller must ensure the corresponding ref head is not being run.
  */
@@ -624,9 +697,36 @@ inmem_search_hash(struct btrfs_dedup_info *dedup_info, u8 *hash)
 	return NULL;
 }
 
-static int inmem_search(struct btrfs_dedup_info *dedup_info,
-			struct inode *inode, u64 file_pos,
-			struct btrfs_dedup_hash *hash)
+/* Wapper for different backends, caller needs to hold dedup_info->lock */
+static inline int generic_search_hash(struct btrfs_dedup_info *dedup_info,
+				      u8 *hash, u64 *bytenr_ret,
+				      u32 *num_bytes_ret)
+{
+	if (dedup_info->backend == BTRFS_DEDUP_BACKEND_INMEMORY) {
+		struct inmem_hash *found_hash;
+		int ret;
+
+		found_hash = inmem_search_hash(dedup_info, hash);
+		if (found_hash) {
+			ret = 1;
+			*bytenr_ret = found_hash->bytenr;
+			*num_bytes_ret = found_hash->num_bytes;
+		} else {
+			ret = 0;
+			*bytenr_ret = 0;
+			*num_bytes_ret = 0;
+		}
+		return ret;
+	} else if (dedup_info->backend == BTRFS_DEDUP_BACKEND_ONDISK) {
+		return ondisk_search_hash(dedup_info, hash, bytenr_ret,
+					  num_bytes_ret);
+	}
+	return -EINVAL;
+}
+
+static int generic_search(struct btrfs_dedup_info *dedup_info,
+			  struct inode *inode, u64 file_pos,
+			  struct btrfs_dedup_hash *hash)
 {
 	int ret;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -636,9 +736,9 @@ static int inmem_search(struct btrfs_dedup_info *dedup_info,
 	struct btrfs_delayed_ref_head *insert_head;
 	struct btrfs_delayed_data_ref *insert_dref;
 	struct btrfs_qgroup_extent_record *insert_qrecord = NULL;
-	struct inmem_hash *found_hash;
 	int free_insert = 1;
 	u64 bytenr;
+	u64 tmp_bytenr;
 	u32 num_bytes;
 
 	insert_head = kmem_cache_alloc(btrfs_delayed_ref_head_cachep, GFP_NOFS);
@@ -670,14 +770,9 @@ static int inmem_search(struct btrfs_dedup_info *dedup_info,
 
 again:
 	mutex_lock(&dedup_info->lock);
-	found_hash = inmem_search_hash(dedup_info, hash->hash);
-	/* If we don't find a duplicated extent, just return. */
-	if (!found_hash) {
-		ret = 0;
+	ret = generic_search_hash(dedup_info, hash->hash, &bytenr, &num_bytes);
+	if (ret <= 0)
 		goto out;
-	}
-	bytenr = found_hash->bytenr;
-	num_bytes = found_hash->num_bytes;
 
 	delayed_refs = &trans->transaction->delayed_refs;
 
@@ -716,12 +811,17 @@ again:
 
 	mutex_lock(&dedup_info->lock);
 	/* Search again to ensure the hash is still here */
-	found_hash = inmem_search_hash(dedup_info, hash->hash);
-	if (!found_hash) {
-		ret = 0;
+	ret = generic_search_hash(dedup_info, hash->hash, &tmp_bytenr,
+				  &num_bytes);
+	if (ret <= 0) {
 		mutex_unlock(&head->mutex);
 		goto out;
 	}
+	if (tmp_bytenr != bytenr) {
+		mutex_unlock(&head->mutex);
+		mutex_unlock(&dedup_info->lock);
+		goto again;
+	}
 	hash->bytenr = bytenr;
 	hash->num_bytes = num_bytes;
 
@@ -763,8 +863,9 @@ int btrfs_dedup_search(struct btrfs_fs_info *fs_info,
 	if (WARN_ON(dedup_info == NULL))
 		return -EINVAL;
 
-	if (dedup_info->backend == BTRFS_DEDUP_BACKEND_INMEMORY)
-		ret = inmem_search(dedup_info, inode, file_pos, hash);
+	if (dedup_info->backend == BTRFS_DEDUP_BACKEND_INMEMORY ||
+	    dedup_info->backend == BTRFS_DEDUP_BACKEND_ONDISK)
+		ret = generic_search(dedup_info, inode, file_pos, hash);
 
 	/* It's possible hash->bytenr/num_bytenr already changed */
 	if (ret == 0) {
diff --git a/fs/btrfs/dedup.h b/fs/btrfs/dedup.h
index 31c6b17..a580072 100644
--- a/fs/btrfs/dedup.h
+++ b/fs/btrfs/dedup.h
@@ -142,6 +142,7 @@ int btrfs_dedup_calc_hash(struct btrfs_fs_info *fs_info,
  * *INCREASED*, and hash->bytenr/num_bytes will record the existing
  * extent data.
  * Return 0 for a hash miss. Nothing is done
+ * Return < 0 for error
  */
 int btrfs_dedup_search(struct btrfs_fs_info *fs_info,
 		       struct inode *inode, u64 file_pos,
-- 
2.7.1



