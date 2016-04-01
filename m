Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:12218 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758634AbcDAGfs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Apr 2016 02:35:48 -0400
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 7B1024056407
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Apr 2016 14:35:24 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v10 21/21] btrfs: dedupe: Preparation for compress-dedupe co-work
Date: Fri,  1 Apr 2016 14:35:12 +0800
Message-Id: <1459492512-31435-22-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1459492512-31435-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1459492512-31435-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For dedupe to work with compression, new members recording compression
algorithm and on-disk extent length are needed.

Add them for later compress-dedupe co-work.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/ctree.h        | 22 +++++++++++++-
 fs/btrfs/dedupe.c       | 78 ++++++++++++++++++++++++++++++++++++-------------
 fs/btrfs/dedupe.h       |  2 ++
 fs/btrfs/inode.c        |  2 ++
 fs/btrfs/ordered-data.c |  2 ++
 5 files changed, 85 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 659790c..fdbe66b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -982,8 +982,22 @@ struct btrfs_dedupe_status_item {
  * Offset: Bytenr of the hash
  *
  * Used for hash <-> bytenr search
- * Hash exclude the last 64 bit follows
  */
+struct btrfs_dedupe_hash_item {
+	/*
+	 * length of dedupe range on disk
+	 * For in-memory length, it's always
+	 * dedupe_info->block_size
+	 */
+	__le32 disk_len;
+
+	u8 compression;
+
+	/*
+	 * Hash follows, exclude the last 64bit,
+	 * as it's already in key.objectid.
+	 */
+} __attribute__ ((__packed__));
 
 /*
  * Objectid: bytenr
@@ -3316,6 +3330,12 @@ BTRFS_SETGET_FUNCS(dedupe_status_hash_type, struct btrfs_dedupe_status_item,
 BTRFS_SETGET_FUNCS(dedupe_status_backend, struct btrfs_dedupe_status_item,
 		   backend, 16);
 
+/* btrfs_dedupe_hash_item */
+BTRFS_SETGET_FUNCS(dedupe_hash_disk_len, struct btrfs_dedupe_hash_item,
+		   disk_len, 32);
+BTRFS_SETGET_FUNCS(dedupe_hash_compression, struct btrfs_dedupe_hash_item,
+		   compression, 8);
+
 /* struct btrfs_file_extent_item */
 BTRFS_SETGET_FUNCS(file_extent_type, struct btrfs_file_extent_item, type, 8);
 BTRFS_SETGET_STACK_FUNCS(stack_file_extent_disk_bytenr,
diff --git a/fs/btrfs/dedupe.c b/fs/btrfs/dedupe.c
index 1f0178e..e91420d 100644
--- a/fs/btrfs/dedupe.c
+++ b/fs/btrfs/dedupe.c
@@ -31,6 +31,8 @@ struct inmem_hash {
 
 	u64 bytenr;
 	u32 num_bytes;
+	u32 disk_num_bytes;
+	u8 compression;
 
 	u8 hash[];
 };
@@ -397,6 +399,8 @@ static int inmem_add(struct btrfs_dedupe_info *dedupe_info,
 	/* Copy the data out */
 	ihash->bytenr = hash->bytenr;
 	ihash->num_bytes = hash->num_bytes;
+	ihash->disk_num_bytes = hash->disk_num_bytes;
+	ihash->compression = hash->compression;
 	memcpy(ihash->hash, hash->hash, btrfs_dedupe_sizes[type]);
 
 	mutex_lock(&dedupe_info->lock);
@@ -442,7 +446,8 @@ static int ondisk_search_bytenr(struct btrfs_trans_handle *trans,
 				struct btrfs_path *path, u64 bytenr,
 				int prepare_del);
 static int ondisk_search_hash(struct btrfs_dedupe_info *dedupe_info, u8 *hash,
-			      u64 *bytenr_ret, u32 *num_bytes_ret);
+			      u64 *bytenr_ret, u32 *num_bytes_ret,
+			      u32 *disk_num_bytes_ret, u8 *compression);
 static int ondisk_add(struct btrfs_trans_handle *trans,
 		      struct btrfs_dedupe_info *dedupe_info,
 		      struct btrfs_dedupe_hash *hash)
@@ -450,7 +455,7 @@ static int ondisk_add(struct btrfs_trans_handle *trans,
 	struct btrfs_path *path;
 	struct btrfs_root *dedupe_root = dedupe_info->dedupe_root;
 	struct btrfs_key key;
-	u64 hash_offset;
+	struct btrfs_dedupe_hash_item *hash_item;
 	u64 bytenr;
 	u32 num_bytes;
 	int hash_len = btrfs_dedupe_sizes[dedupe_info->hash_type];
@@ -475,7 +480,8 @@ static int ondisk_add(struct btrfs_trans_handle *trans,
 	}
 	btrfs_release_path(path);
 
-	ret = ondisk_search_hash(dedupe_info, hash->hash, &bytenr, &num_bytes);
+	ret = ondisk_search_hash(dedupe_info, hash->hash, &bytenr, &num_bytes,
+				 NULL, NULL);
 	if (ret < 0)
 		goto out;
 	/* Same hash found, don't re-add to save dedupe tree space */
@@ -491,13 +497,18 @@ static int ondisk_add(struct btrfs_trans_handle *trans,
 
 	/* The last 8 bit will not be included into hash */
 	ret = btrfs_insert_empty_item(trans, dedupe_root, path, &key,
-				      hash_len - 8);
+				      sizeof(*hash_item) + hash_len - 8);
 	WARN_ON(ret == -EEXIST);
 	if (ret < 0)
 		goto out;
-	hash_offset = btrfs_item_ptr_offset(path->nodes[0], path->slots[0]);
+	hash_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
+				   struct btrfs_dedupe_hash_item);
+	btrfs_set_dedupe_hash_disk_len(path->nodes[0], hash_item,
+				       hash->disk_num_bytes);
+	btrfs_set_dedupe_hash_compression(path->nodes[0], hash_item,
+					  hash->compression);
 	write_extent_buffer(path->nodes[0], hash->hash,
-			    hash_offset, hash_len - 8);
+			    (unsigned long)(hash_item + 1), hash_len - 8);
 	btrfs_mark_buffer_dirty(path->nodes[0]);
 	btrfs_release_path(path);
 
@@ -845,7 +856,7 @@ static int memcmp_ondisk_hash(const struct btrfs_key *key,
 			      struct extent_buffer *node, int slot,
 			      int hash_len, const u8 *src)
 {
-	u64 offset;
+	struct btrfs_dedupe_hash_item *hash_item;
 	int ret;
 
 	/* Return value doesn't make sense in this case though */
@@ -853,8 +864,10 @@ static int memcmp_ondisk_hash(const struct btrfs_key *key,
 		return -EINVAL;
 
 	/* compare the hash exlcuding the last 64 bits */
-	offset = btrfs_item_ptr_offset(node, slot);
-	ret = memcmp_extent_buffer(node, src, offset, hash_len - 8);
+	hash_item = btrfs_item_ptr(node, slot,
+				   struct btrfs_dedupe_hash_item);
+	ret = memcmp_extent_buffer(node, src, (unsigned long)(hash_item + 1),
+				   hash_len - 8);
 	if (ret)
 		return ret;
 	return memcmp(&key->objectid, src + hash_len - 8, 8);
@@ -866,7 +879,8 @@ static int memcmp_ondisk_hash(const struct btrfs_key *key,
  * Return <0 for error
  */
 static int ondisk_search_hash(struct btrfs_dedupe_info *dedupe_info, u8 *hash,
-			      u64 *bytenr_ret, u32 *num_bytes_ret)
+			      u64 *bytenr_ret, u32 *num_bytes_ret,
+			      u32 *disk_num_bytes_ret, u8 *compression_ret)
 {
 	struct btrfs_path *path;
 	struct btrfs_key key;
@@ -930,8 +944,16 @@ static int ondisk_search_hash(struct btrfs_dedupe_info *dedupe_info, u8 *hash,
 			continue;
 		/* Found */
 		ret = 1;
-		*bytenr_ret = key.offset;
-		*num_bytes_ret = dedupe_info->blocksize;
+		if (bytenr_ret)
+			*bytenr_ret = key.offset;
+		if (num_bytes_ret)
+			*num_bytes_ret = dedupe_info->blocksize;
+		if (disk_num_bytes_ret)
+			*disk_num_bytes_ret = btrfs_dedupe_hash_disk_len(node,
+					hash_item);
+		if (compression_ret)
+			*compression_ret = btrfs_dedupe_hash_compression(node,
+					hash_item);
 		break;
 	}
 out:
@@ -973,7 +995,9 @@ inmem_search_hash(struct btrfs_dedupe_info *dedupe_info, u8 *hash)
 /* Wapper for different backends, caller needs to hold dedupe_info->lock */
 static inline int generic_search_hash(struct btrfs_dedupe_info *dedupe_info,
 				      u8 *hash, u64 *bytenr_ret,
-				      u32 *num_bytes_ret)
+				      u32 *num_bytes_ret,
+				      u32 *disk_num_bytes_ret,
+				      u8 *compression_ret)
 {
 	if (dedupe_info->backend == BTRFS_DEDUPE_BACKEND_INMEMORY) {
 		struct inmem_hash *found_hash;
@@ -984,15 +1008,20 @@ static inline int generic_search_hash(struct btrfs_dedupe_info *dedupe_info,
 			ret = 1;
 			*bytenr_ret = found_hash->bytenr;
 			*num_bytes_ret = found_hash->num_bytes;
+			*disk_num_bytes_ret = found_hash->disk_num_bytes;
+			*compression_ret = found_hash->compression;
 		} else {
 			ret = 0;
 			*bytenr_ret = 0;
 			*num_bytes_ret = 0;
+			*disk_num_bytes_ret = 0;
+			*compression_ret = 0;
 		}
 		return ret;
 	} else if (dedupe_info->backend == BTRFS_DEDUPE_BACKEND_ONDISK) {
 		return ondisk_search_hash(dedupe_info, hash, bytenr_ret,
-					  num_bytes_ret);
+					  num_bytes_ret, disk_num_bytes_ret,
+					  compression_ret);
 	}
 	return -EINVAL;
 }
@@ -1013,6 +1042,8 @@ static int generic_search(struct btrfs_dedupe_info *dedupe_info,
 	u64 bytenr;
 	u64 tmp_bytenr;
 	u32 num_bytes;
+	u32 disk_num_bytes;
+	u8 compression;
 
 	insert_head = kmem_cache_alloc(btrfs_delayed_ref_head_cachep, GFP_NOFS);
 	if (!insert_head)
@@ -1043,7 +1074,8 @@ static int generic_search(struct btrfs_dedupe_info *dedupe_info,
 
 again:
 	mutex_lock(&dedupe_info->lock);
-	ret = generic_search_hash(dedupe_info, hash->hash, &bytenr, &num_bytes);
+	ret = generic_search_hash(dedupe_info, hash->hash, &bytenr, &num_bytes,
+				  &disk_num_bytes, &compression);
 	if (ret <= 0)
 		goto out;
 
@@ -1059,15 +1091,17 @@ again:
 		 */
 		btrfs_add_delayed_data_ref_locked(root->fs_info, trans,
 				insert_dref, insert_head, insert_qrecord,
-				bytenr, num_bytes, 0, root->root_key.objectid,
-				btrfs_ino(inode), file_pos, 0,
-				BTRFS_ADD_DELAYED_REF);
+				bytenr, disk_num_bytes, 0,
+				root->root_key.objectid, btrfs_ino(inode),
+				file_pos, 0, BTRFS_ADD_DELAYED_REF);
 		spin_unlock(&delayed_refs->lock);
 
 		/* add_delayed_data_ref_locked will free unused memory */
 		free_insert = 0;
 		hash->bytenr = bytenr;
 		hash->num_bytes = num_bytes;
+		hash->disk_num_bytes = disk_num_bytes;
+		hash->compression = compression;
 		ret = 1;
 		goto out;
 	}
@@ -1085,7 +1119,7 @@ again:
 	mutex_lock(&dedupe_info->lock);
 	/* Search again to ensure the hash is still here */
 	ret = generic_search_hash(dedupe_info, hash->hash, &tmp_bytenr,
-				  &num_bytes);
+				  &num_bytes, &disk_num_bytes, &compression);
 	if (ret <= 0) {
 		mutex_unlock(&head->mutex);
 		goto out;
@@ -1097,12 +1131,14 @@ again:
 	}
 	hash->bytenr = bytenr;
 	hash->num_bytes = num_bytes;
+	hash->disk_num_bytes = disk_num_bytes;
+	hash->compression = compression;
 
 	/*
 	 * Increase the extent ref right now, to avoid delayed ref run
 	 * Or we may increase ref on non-exist extent.
 	 */
-	btrfs_inc_extent_ref(trans, root, bytenr, num_bytes, 0,
+	btrfs_inc_extent_ref(trans, root, bytenr, disk_num_bytes, 0,
 			     root->root_key.objectid,
 			     btrfs_ino(inode), file_pos);
 	mutex_unlock(&head->mutex);
@@ -1147,6 +1183,8 @@ int btrfs_dedupe_search(struct btrfs_fs_info *fs_info,
 	if (ret == 0) {
 		hash->num_bytes = 0;
 		hash->bytenr = 0;
+		hash->disk_num_bytes = 0;
+		hash->compression = 0;
 	}
 	return ret;
 }
diff --git a/fs/btrfs/dedupe.h b/fs/btrfs/dedupe.h
index 1573456..9298b8b 100644
--- a/fs/btrfs/dedupe.h
+++ b/fs/btrfs/dedupe.h
@@ -54,6 +54,8 @@ static int btrfs_dedupe_sizes[] = { 32 };
 struct btrfs_dedupe_hash {
 	u64 bytenr;
 	u32 num_bytes;
+	u32 disk_num_bytes;
+	u8 compression;
 
 	/* last field is a variable length array of dedupe hash */
 	u8 hash[];
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c80fd74..d49ef5c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2314,6 +2314,8 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	if (hash && hash->bytenr == 0) {
 		hash->bytenr = ins.objectid;
 		hash->num_bytes = ins.offset;
+		hash->disk_num_bytes = hash->num_bytes;
+		hash->compression = BTRFS_COMPRESS_NONE;
 		ret = btrfs_dedupe_add(trans, root->fs_info, hash);
 	}
 
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index ef24ad1..695c0e2 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -227,6 +227,8 @@ static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 		}
 		entry->hash->bytenr = hash->bytenr;
 		entry->hash->num_bytes = hash->num_bytes;
+		entry->hash->disk_num_bytes = hash->disk_num_bytes;
+		entry->hash->compression = hash->compression;
 		memcpy(entry->hash->hash, hash->hash,
 		       btrfs_dedupe_sizes[dedupe_info->hash_type]);
 	}
-- 
2.7.4



