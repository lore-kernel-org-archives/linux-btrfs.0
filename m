Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:47035 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758124AbcCVBit (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 21:38:49 -0400
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id AD0B5405641D
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Mar 2016 09:37:56 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v8 24/27] btrfs: dedupe: Preparation for compress-dedupe co-work
Date: Tue, 22 Mar 2016 09:35:49 +0800
Message-Id: <1458610552-9845-25-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For dedupe to work with compression, new members recording compression
algorithm and on-disk extent length are needed.

Add them for later compress-dedupe co-work.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/ctree.h        | 11 ++++++++-
 fs/btrfs/dedupe.c       | 64 +++++++++++++++++++++++++++++++++++++++----------
 fs/btrfs/dedupe.h       |  2 ++
 fs/btrfs/inode.c        |  2 ++
 fs/btrfs/ordered-data.c |  2 ++
 5 files changed, 67 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b19c1f1..88702e1 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -984,9 +984,14 @@ struct btrfs_dedupe_status_item {
  * Used for hash <-> bytenr search
  */
 struct btrfs_dedupe_hash_item {
-	/* length of dedupe range */
+	/* length of dedupe range in memory */
 	__le32 len;
 
+	/* length of dedupe range on disk */
+	__le32 disk_len;
+
+	u8 compression;
+
 	/* Hash follows */
 } __attribute__ ((__packed__));
 
@@ -3324,6 +3329,10 @@ BTRFS_SETGET_FUNCS(dedupe_status_backend, struct btrfs_dedupe_status_item,
 
 /* btrfs_dedupe_hash_item */
 BTRFS_SETGET_FUNCS(dedupe_hash_len, struct btrfs_dedupe_hash_item, len, 32);
+BTRFS_SETGET_FUNCS(dedupe_hash_disk_len, struct btrfs_dedupe_hash_item,
+		   disk_len, 32);
+BTRFS_SETGET_FUNCS(dedupe_hash_compression, struct btrfs_dedupe_hash_item,
+		   compression, 8);
 
 /* struct btrfs_file_extent_item */
 BTRFS_SETGET_FUNCS(file_extent_type, struct btrfs_file_extent_item, type, 8);
diff --git a/fs/btrfs/dedupe.c b/fs/btrfs/dedupe.c
index 294cbb5..1c89c8f 100644
--- a/fs/btrfs/dedupe.c
+++ b/fs/btrfs/dedupe.c
@@ -31,6 +31,8 @@ struct inmem_hash {
 
 	u64 bytenr;
 	u32 num_bytes;
+	u32 disk_num_bytes;
+	u8 compression;
 
 	u8 hash[];
 };
@@ -403,6 +405,8 @@ static int inmem_add(struct btrfs_dedupe_info *dedupe_info,
 	/* Copy the data out */
 	ihash->bytenr = hash->bytenr;
 	ihash->num_bytes = hash->num_bytes;
+	ihash->disk_num_bytes = hash->disk_num_bytes;
+	ihash->compression = hash->compression;
 	memcpy(ihash->hash, hash->hash, btrfs_dedupe_sizes[type]);
 
 	mutex_lock(&dedupe_info->lock);
@@ -448,7 +452,8 @@ static int ondisk_search_bytenr(struct btrfs_trans_handle *trans,
 				struct btrfs_path *path, u64 bytenr,
 				int prepare_del);
 static int ondisk_search_hash(struct btrfs_dedupe_info *dedupe_info, u8 *hash,
-			      u64 *bytenr_ret, u32 *num_bytes_ret);
+			      u64 *bytenr_ret, u32 *num_bytes_ret,
+			      u32 *disk_num_bytes_ret, u8 *compression);
 static int ondisk_add(struct btrfs_trans_handle *trans,
 		      struct btrfs_dedupe_info *dedupe_info,
 		      struct btrfs_dedupe_hash *hash)
@@ -477,7 +482,8 @@ static int ondisk_add(struct btrfs_trans_handle *trans,
 	}
 	btrfs_release_path(path);
 
-	ret = ondisk_search_hash(dedupe_info, hash->hash, &bytenr, &num_bytes);
+	ret = ondisk_search_hash(dedupe_info, hash->hash, &bytenr, &num_bytes,
+				 NULL, NULL);
 	if (ret < 0)
 		goto out;
 	/* Same hash found, don't re-add to save dedupe tree space */
@@ -499,6 +505,10 @@ static int ondisk_add(struct btrfs_trans_handle *trans,
 	hash_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
 				   struct btrfs_dedupe_hash_item);
 	btrfs_set_dedupe_hash_len(path->nodes[0], hash_item, hash->num_bytes);
+	btrfs_set_dedupe_hash_disk_len(path->nodes[0], hash_item,
+				       hash->disk_num_bytes);
+	btrfs_set_dedupe_hash_compression(path->nodes[0], hash_item,
+					  hash->compression);
 	write_extent_buffer(path->nodes[0], hash->hash,
 			    (unsigned long)(hash_item + 1), hash_len);
 	btrfs_mark_buffer_dirty(path->nodes[0]);
@@ -822,7 +832,8 @@ int btrfs_dedupe_disable(struct btrfs_fs_info *fs_info)
  * Return <0 for error
  */
 static int ondisk_search_hash(struct btrfs_dedupe_info *dedupe_info, u8 *hash,
-			      u64 *bytenr_ret, u32 *num_bytes_ret)
+			      u64 *bytenr_ret, u32 *num_bytes_ret,
+			      u32 *disk_num_bytes_ret, u8 *compression_ret)
 {
 	struct btrfs_path *path;
 	struct btrfs_key key;
@@ -878,8 +889,19 @@ static int ondisk_search_hash(struct btrfs_dedupe_info *dedupe_info, u8 *hash,
 				   hash_len);
 		if (!memcmp(buf, hash, hash_len)) {
 			ret = 1;
-			*bytenr_ret = key.offset;
-			*num_bytes_ret = btrfs_dedupe_hash_len(node, hash_item);
+			if (bytenr_ret)
+				*bytenr_ret = key.offset;
+			if (num_bytes_ret)
+				*num_bytes_ret =
+					btrfs_dedupe_hash_len(node, hash_item);
+			if (disk_num_bytes_ret)
+				*disk_num_bytes_ret =
+					btrfs_dedupe_hash_disk_len(node,
+							hash_item);
+			if (compression_ret)
+				*compression_ret =
+					btrfs_dedupe_hash_compression(node,
+							hash_item);
 			break;
 		}
 	}
@@ -922,7 +944,9 @@ inmem_search_hash(struct btrfs_dedupe_info *dedupe_info, u8 *hash)
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
@@ -933,15 +957,20 @@ static inline int generic_search_hash(struct btrfs_dedupe_info *dedupe_info,
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
@@ -962,6 +991,8 @@ static int generic_search(struct btrfs_dedupe_info *dedupe_info,
 	u64 bytenr;
 	u64 tmp_bytenr;
 	u32 num_bytes;
+	u32 disk_num_bytes;
+	u8 compression;
 
 	insert_head = kmem_cache_alloc(btrfs_delayed_ref_head_cachep, GFP_NOFS);
 	if (!insert_head)
@@ -992,7 +1023,8 @@ static int generic_search(struct btrfs_dedupe_info *dedupe_info,
 
 again:
 	mutex_lock(&dedupe_info->lock);
-	ret = generic_search_hash(dedupe_info, hash->hash, &bytenr, &num_bytes);
+	ret = generic_search_hash(dedupe_info, hash->hash, &bytenr, &num_bytes,
+				  &disk_num_bytes, &compression);
 	if (ret <= 0)
 		goto out;
 
@@ -1008,15 +1040,17 @@ again:
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
@@ -1034,7 +1068,7 @@ again:
 	mutex_lock(&dedupe_info->lock);
 	/* Search again to ensure the hash is still here */
 	ret = generic_search_hash(dedupe_info, hash->hash, &tmp_bytenr,
-				  &num_bytes);
+				  &num_bytes, &disk_num_bytes, &compression);
 	if (ret <= 0) {
 		mutex_unlock(&head->mutex);
 		goto out;
@@ -1046,12 +1080,14 @@ again:
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
@@ -1096,6 +1132,8 @@ int btrfs_dedupe_search(struct btrfs_fs_info *fs_info,
 	if (ret == 0) {
 		hash->num_bytes = 0;
 		hash->bytenr = 0;
+		hash->disk_num_bytes = 0;
+		hash->compression = 0;
 	}
 	return ret;
 }
diff --git a/fs/btrfs/dedupe.h b/fs/btrfs/dedupe.h
index 60479b1..ac6eeb3 100644
--- a/fs/btrfs/dedupe.h
+++ b/fs/btrfs/dedupe.h
@@ -53,6 +53,8 @@ static int btrfs_dedupe_sizes[] = { 32 };
 struct btrfs_dedupe_hash {
 	u64 bytenr;
 	u32 num_bytes;
+	u32 disk_num_bytes;
+	u8 compression;
 
 	/* last field is a variable length array of dedupe hash */
 	u8 hash[];
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b22663c..35d1ec4 100644
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
2.7.3



