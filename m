Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:35808 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758156AbcCVBiy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 21:38:54 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v8 12/27] btrfs: dedupe: Add support for on-disk hash search
Date: Tue, 22 Mar 2016 09:35:37 +0800
Message-Id: <1458610552-9845-13-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now on-disk backend should be able to search hash now.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/dedupe.c | 133 +++++++++++++++++++++++++++++++++++++++++++++++-------
 fs/btrfs/dedupe.h |   1 +
 2 files changed, 118 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/dedupe.c b/fs/btrfs/dedupe.c
index 1112fec..f73a4c7 100644
--- a/fs/btrfs/dedupe.c
+++ b/fs/btrfs/dedupe.c
@@ -595,6 +595,79 @@ int btrfs_dedupe_disable(struct btrfs_fs_info *fs_info)
 	return ret;
 }
 
+ /*
+ * Return 0 for not found
+ * Return >0 for found and set bytenr_ret
+ * Return <0 for error
+ */
+static int ondisk_search_hash(struct btrfs_dedupe_info *dedupe_info, u8 *hash,
+			      u64 *bytenr_ret, u32 *num_bytes_ret)
+{
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	struct btrfs_root *dedupe_root = dedupe_info->dedupe_root;
+	u8 *buf = NULL;
+	u64 hash_key;
+	int hash_len = btrfs_dedupe_sizes[dedupe_info->hash_type];
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
+	key.type = BTRFS_DEDUPE_HASH_ITEM_KEY;
+	key.offset = (u64)-1;
+
+	ret = btrfs_search_slot(NULL, dedupe_root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+	WARN_ON(ret == 0);
+	while (1) {
+		struct extent_buffer *node;
+		struct btrfs_dedupe_hash_item *hash_item;
+		int slot;
+
+		ret = btrfs_previous_item(dedupe_root, path, hash_key,
+					  BTRFS_DEDUPE_HASH_ITEM_KEY);
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
+		if (key.type != BTRFS_DEDUPE_HASH_ITEM_KEY ||
+		    memcmp(&key.objectid, hash + hash_len - 8, 8))
+			break;
+		hash_item = btrfs_item_ptr(node, slot,
+				struct btrfs_dedupe_hash_item);
+		read_extent_buffer(node, buf, (unsigned long)(hash_item + 1),
+				   hash_len);
+		if (!memcmp(buf, hash, hash_len)) {
+			ret = 1;
+			*bytenr_ret = key.offset;
+			*num_bytes_ret = btrfs_dedupe_hash_len(node, hash_item);
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
@@ -625,9 +698,36 @@ inmem_search_hash(struct btrfs_dedupe_info *dedupe_info, u8 *hash)
 	return NULL;
 }
 
-static int inmem_search(struct btrfs_dedupe_info *dedupe_info,
-			struct inode *inode, u64 file_pos,
-			struct btrfs_dedupe_hash *hash)
+/* Wapper for different backends, caller needs to hold dedupe_info->lock */
+static inline int generic_search_hash(struct btrfs_dedupe_info *dedupe_info,
+				      u8 *hash, u64 *bytenr_ret,
+				      u32 *num_bytes_ret)
+{
+	if (dedupe_info->backend == BTRFS_DEDUPE_BACKEND_INMEMORY) {
+		struct inmem_hash *found_hash;
+		int ret;
+
+		found_hash = inmem_search_hash(dedupe_info, hash);
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
+	} else if (dedupe_info->backend == BTRFS_DEDUPE_BACKEND_ONDISK) {
+		return ondisk_search_hash(dedupe_info, hash, bytenr_ret,
+					  num_bytes_ret);
+	}
+	return -EINVAL;
+}
+
+static int generic_search(struct btrfs_dedupe_info *dedupe_info,
+			  struct inode *inode, u64 file_pos,
+			  struct btrfs_dedupe_hash *hash)
 {
 	int ret;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -637,9 +737,9 @@ static int inmem_search(struct btrfs_dedupe_info *dedupe_info,
 	struct btrfs_delayed_ref_head *insert_head;
 	struct btrfs_delayed_data_ref *insert_dref;
 	struct btrfs_qgroup_extent_record *insert_qrecord = NULL;
-	struct inmem_hash *found_hash;
 	int free_insert = 1;
 	u64 bytenr;
+	u64 tmp_bytenr;
 	u32 num_bytes;
 
 	insert_head = kmem_cache_alloc(btrfs_delayed_ref_head_cachep, GFP_NOFS);
@@ -671,14 +771,9 @@ static int inmem_search(struct btrfs_dedupe_info *dedupe_info,
 
 again:
 	mutex_lock(&dedupe_info->lock);
-	found_hash = inmem_search_hash(dedupe_info, hash->hash);
-	/* If we don't find a duplicated extent, just return. */
-	if (!found_hash) {
-		ret = 0;
+	ret = generic_search_hash(dedupe_info, hash->hash, &bytenr, &num_bytes);
+	if (ret <= 0)
 		goto out;
-	}
-	bytenr = found_hash->bytenr;
-	num_bytes = found_hash->num_bytes;
 
 	delayed_refs = &trans->transaction->delayed_refs;
 
@@ -717,12 +812,17 @@ again:
 
 	mutex_lock(&dedupe_info->lock);
 	/* Search again to ensure the hash is still here */
-	found_hash = inmem_search_hash(dedupe_info, hash->hash);
-	if (!found_hash) {
-		ret = 0;
+	ret = generic_search_hash(dedupe_info, hash->hash, &tmp_bytenr,
+				  &num_bytes);
+	if (ret <= 0) {
 		mutex_unlock(&head->mutex);
 		goto out;
 	}
+	if (tmp_bytenr != bytenr) {
+		mutex_unlock(&head->mutex);
+		mutex_unlock(&dedupe_info->lock);
+		goto again;
+	}
 	hash->bytenr = bytenr;
 	hash->num_bytes = num_bytes;
 
@@ -767,8 +867,9 @@ int btrfs_dedupe_search(struct btrfs_fs_info *fs_info,
 	if (WARN_ON(btrfs_dedupe_hash_hit(hash)))
 		return -EINVAL;
 
-	if (dedupe_info->backend == BTRFS_DEDUPE_BACKEND_INMEMORY)
-		ret = inmem_search(dedupe_info, inode, file_pos, hash);
+	if (dedupe_info->backend == BTRFS_DEDUPE_BACKEND_INMEMORY ||
+	    dedupe_info->backend == BTRFS_DEDUPE_BACKEND_ONDISK)
+		ret = generic_search(dedupe_info, inode, file_pos, hash);
 
 	/* It's possible hash->bytenr/num_bytenr already changed */
 	if (ret == 0) {
diff --git a/fs/btrfs/dedupe.h b/fs/btrfs/dedupe.h
index 120e630..467ddd5 100644
--- a/fs/btrfs/dedupe.h
+++ b/fs/btrfs/dedupe.h
@@ -146,6 +146,7 @@ int btrfs_dedupe_calc_hash(struct btrfs_fs_info *fs_info,
  * *INCREASED*, and hash->bytenr/num_bytes will record the existing
  * extent data.
  * Return 0 for a hash miss. Nothing is done
+ * Return < 0 for error
  */
 int btrfs_dedupe_search(struct btrfs_fs_info *fs_info,
 			struct inode *inode, u64 file_pos,
-- 
2.7.3



