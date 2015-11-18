Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21484 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754992AbbKRHYv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Nov 2015 02:24:51 -0500
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tAI7NoSA007932
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2015 15:24:01 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH 15/22] btrfs-progs: Introduce function to create convert data chunks
Date: Wed, 18 Nov 2015 15:22:15 +0800
Message-Id: <1447831342-15056-16-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1447831342-15056-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1447831342-15056-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce new function, make_convert_data_chunks(), to build up data
chunks for convert.

It will call a modified verion of btrfs_alloc_data_chunk() to force
data chunks to cover all known ext* data.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-convert.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 mkfs.c          |  2 +-
 volumes.c       | 46 ++++++++++++++++++++++++++++++++++------------
 volumes.h       |  2 +-
 4 files changed, 85 insertions(+), 14 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 3bee049..4626bbd 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -1688,6 +1688,55 @@ static int create_subvol(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
+/*
+ * New make_btrfs_v2() has handle system and meta chunks quite well.
+ * So only need to add remaining data chunks.
+ */
+static int make_convert_data_block_groups(struct btrfs_trans_handle *trans,
+					  struct btrfs_fs_info *fs_info,
+					  struct btrfs_mkfs_config *cfg)
+{
+	struct btrfs_root *extent_root = fs_info->extent_root;
+	struct cache_tree *data_chunks = &cfg->convert_data_chunks;
+	struct cache_extent *cache;
+	u64 max_chunk_size;
+	int ret = 0;
+
+	/*
+	 * Don't create data chunk over 10% of the convert device
+	 * And for single chunk, don't create chunk larger than 1G.
+	 */
+	max_chunk_size = cfg->num_bytes / 10;
+	max_chunk_size = min((u64)(1024 * 1024 * 1024), max_chunk_size);
+	max_chunk_size = round_down(max_chunk_size, extent_root->sectorsize);
+
+	for (cache = first_cache_extent(data_chunks); cache;
+	     cache = next_cache_extent(cache)) {
+		u64 cur = cache->start;
+
+		while (cur < cache->start + cache->size) {
+			u64 len;
+			u64 cur_backup = cur;
+
+			len = min(max_chunk_size,
+				  cache->start + cache->size - cur);
+			ret = btrfs_alloc_data_chunk(trans, extent_root,
+					&cur_backup, len,
+					BTRFS_BLOCK_GROUP_DATA, 1);
+			if (ret < 0)
+				break;
+			ret = btrfs_make_block_group(trans, extent_root, 0,
+					BTRFS_BLOCK_GROUP_DATA,
+					BTRFS_FIRST_CHUNK_TREE_OBJECTID,
+					cur, len);
+			if (ret < 0)
+				break;
+			cur += len;
+		}
+	}
+	return ret;
+}
+
 static int init_btrfs(struct btrfs_root *root)
 {
 	int ret;
diff --git a/mkfs.c b/mkfs.c
index 306be51..3d62732 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -974,7 +974,7 @@ static int create_chunks(struct btrfs_trans_handle *trans,
 		size_of_data = minimum_data_chunk_size;
 
 	ret = btrfs_alloc_data_chunk(trans, root->fs_info->extent_root,
-				     &chunk_start, size_of_data, data_type);
+				     &chunk_start, size_of_data, data_type, 0);
 	BUG_ON(ret);
 	ret = btrfs_make_block_group(trans, root->fs_info->extent_root, 0,
 				     data_type, BTRFS_FIRST_CHUNK_TREE_OBJECTID,
diff --git a/volumes.c b/volumes.c
index 4e683bb..edc381e 100644
--- a/volumes.c
+++ b/volumes.c
@@ -399,7 +399,7 @@ static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 				  struct btrfs_device *device,
 				  u64 chunk_tree, u64 chunk_objectid,
 				  u64 chunk_offset,
-				  u64 num_bytes, u64 *start)
+				  u64 num_bytes, u64 *start, int convert)
 {
 	int ret;
 	struct btrfs_path *path;
@@ -412,9 +412,15 @@ static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
-	ret = find_free_dev_extent(trans, device, path, num_bytes, start);
-	if (ret) {
-		goto err;
+	/*
+	 * For convert case, just skip search free dev_extent, as caller
+	 * is responsible to ensure it's free.
+	 */
+	if (!convert) {
+		ret = find_free_dev_extent(trans, device, path, num_bytes,
+					   start);
+		if (ret)
+			goto err;
 	}
 
 	key.objectid = device->devid;
@@ -973,7 +979,7 @@ again:
 		ret = btrfs_alloc_dev_extent(trans, device,
 			     info->chunk_root->root_key.objectid,
 			     BTRFS_FIRST_CHUNK_TREE_OBJECTID, key.offset,
-			     calc_size, &dev_offset);
+			     calc_size, &dev_offset, 0);
 		BUG_ON(ret);
 
 		device->bytes_used += calc_size;
@@ -1029,9 +1035,17 @@ again:
 	return ret;
 }
 
+/*
+ * Alloc a DATA chunk with SINGLE profile.
+ *
+ * If 'convert' is set, it will alloc a chunk with 1:1 mapping
+ * (btrfs logical bytenr == on-disk bytenr)
+ * For that case, caller must ensure the chunk and dev_extent is not
+ * occupied.
+ */
 int btrfs_alloc_data_chunk(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *extent_root, u64 *start,
-			   u64 num_bytes, u64 type)
+			   u64 num_bytes, u64 type, int convert)
 {
 	u64 dev_offset;
 	struct btrfs_fs_info *info = extent_root->fs_info;
@@ -1052,10 +1066,17 @@ int btrfs_alloc_data_chunk(struct btrfs_trans_handle *trans,
 
 	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
 	key.type = BTRFS_CHUNK_ITEM_KEY;
-	ret = find_next_chunk(chunk_root, BTRFS_FIRST_CHUNK_TREE_OBJECTID,
-			      &key.offset);
-	if (ret)
-		return ret;
+	if (convert) {
+		BUG_ON(*start != round_down(*start, extent_root->sectorsize));
+		key.offset = *start;
+		dev_offset = *start;
+	} else {
+		ret = find_next_chunk(chunk_root,
+				      BTRFS_FIRST_CHUNK_TREE_OBJECTID,
+				      &key.offset);
+		if (ret)
+			return ret;
+	}
 
 	chunk = kmalloc(btrfs_chunk_item_size(num_stripes), GFP_NOFS);
 	if (!chunk)
@@ -1080,7 +1101,7 @@ int btrfs_alloc_data_chunk(struct btrfs_trans_handle *trans,
 		ret = btrfs_alloc_dev_extent(trans, device,
 			     info->chunk_root->root_key.objectid,
 			     BTRFS_FIRST_CHUNK_TREE_OBJECTID, key.offset,
-			     calc_size, &dev_offset);
+			     calc_size, &dev_offset, convert);
 		BUG_ON(ret);
 
 		device->bytes_used += calc_size;
@@ -1117,7 +1138,8 @@ int btrfs_alloc_data_chunk(struct btrfs_trans_handle *trans,
 	ret = btrfs_insert_item(trans, chunk_root, &key, chunk,
 				btrfs_chunk_item_size(num_stripes));
 	BUG_ON(ret);
-	*start = key.offset;
+	if (!convert)
+		*start = key.offset;
 
 	map->ce.start = key.offset;
 	map->ce.size = num_bytes;
diff --git a/volumes.h b/volumes.h
index eb434f1..fccd964 100644
--- a/volumes.h
+++ b/volumes.h
@@ -191,7 +191,7 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		      u64 *num_bytes, u64 type);
 int btrfs_alloc_data_chunk(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *extent_root, u64 *start,
-			   u64 num_bytes, u64 type);
+			   u64 num_bytes, u64 type, int convert);
 int btrfs_read_super_device(struct btrfs_root *root, struct extent_buffer *buf);
 int btrfs_add_device(struct btrfs_trans_handle *trans,
 		     struct btrfs_root *root,
-- 
2.6.2

