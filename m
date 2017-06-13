Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29819 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752543AbdFMJTv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Jun 2017 05:19:51 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 14/19] btrfs-progs: Refactor btrfs_read_sys_array/chunk_tree to use btrfs_fs_info
Date: Tue, 13 Jun 2017 17:19:30 +0800
Message-ID: <20170613091935.23277-15-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
References: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 disk-io.c |  4 ++--
 volumes.c | 25 +++++++++++--------------
 volumes.h |  4 ++--
 3 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index a11e6262..8cf800ea 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1173,7 +1173,7 @@ int btrfs_setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info,
 	btrfs_setup_root(fs_info->chunk_root, fs_info,
 			BTRFS_CHUNK_TREE_OBJECTID);
 
-	ret = btrfs_read_sys_array(fs_info->chunk_root);
+	ret = btrfs_read_sys_array(fs_info);
 	if (ret)
 		return ret;
 
@@ -1207,7 +1207,7 @@ int btrfs_setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info,
 	}
 
 	if (!(btrfs_super_flags(sb) & BTRFS_SUPER_FLAG_METADUMP)) {
-		ret = btrfs_read_chunk_tree(fs_info->chunk_root);
+		ret = btrfs_read_chunk_tree(fs_info);
 		if (ret) {
 			fprintf(stderr, "Couldn't read chunk tree\n");
 			return ret;
diff --git a/volumes.c b/volumes.c
index e4f67d3a..db8b931f 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1783,11 +1783,10 @@ int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
  *
  * For sys chunk in superblock, pass -1 to indicate sys chunk.
  */
-static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
+static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
 			  struct extent_buffer *leaf,
 			  struct btrfs_chunk *chunk, int slot)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
 	struct map_lookup *map;
 	struct cache_extent *ce;
@@ -1846,7 +1845,7 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 			printf("warning, device %llu is missing\n",
 			       (unsigned long long)devid);
 			list_add(&map->stripes[i].dev->dev_list,
-				 &root->fs_info->fs_devices->devices);
+				 &fs_info->fs_devices->devices);
 		}
 
 	}
@@ -1913,11 +1912,10 @@ out:
 	return ret;
 }
 
-static int read_one_dev(struct btrfs_root *root,
+static int read_one_dev(struct btrfs_fs_info *fs_info,
 			struct extent_buffer *leaf,
 			struct btrfs_dev_item *dev_item)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_device *device;
 	u64 devid;
 	int ret = 0;
@@ -1953,9 +1951,9 @@ static int read_one_dev(struct btrfs_root *root,
 	return ret;
 }
 
-int btrfs_read_sys_array(struct btrfs_root *root)
+int btrfs_read_sys_array(struct btrfs_fs_info *fs_info)
 {
-	struct btrfs_super_block *super_copy = root->fs_info->super_copy;
+	struct btrfs_super_block *super_copy = fs_info->super_copy;
 	struct extent_buffer *sb;
 	struct btrfs_disk_key *disk_key;
 	struct btrfs_chunk *chunk;
@@ -1968,7 +1966,7 @@ int btrfs_read_sys_array(struct btrfs_root *root)
 	u32 cur_offset;
 	struct btrfs_key key;
 
-	sb = btrfs_find_create_tree_block(root->fs_info,
+	sb = btrfs_find_create_tree_block(fs_info,
 					  BTRFS_SUPER_INFO_OFFSET,
 					  BTRFS_SUPER_INFO_SIZE);
 	if (!sb)
@@ -2016,7 +2014,7 @@ int btrfs_read_sys_array(struct btrfs_root *root)
 			if (cur_offset + len > array_size)
 				goto out_short_read;
 
-			ret = read_one_chunk(root, &key, sb, chunk, -1);
+			ret = read_one_chunk(fs_info, &key, sb, chunk, -1);
 			if (ret)
 				break;
 		} else {
@@ -2040,17 +2038,16 @@ out_short_read:
 	return -EIO;
 }
 
-int btrfs_read_chunk_tree(struct btrfs_root *root)
+int btrfs_read_chunk_tree(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
 	struct btrfs_key key;
 	struct btrfs_key found_key;
+	struct btrfs_root *root = fs_info->chunk_root;
 	int ret;
 	int slot;
 
-	root = root->fs_info->chunk_root;
-
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
@@ -2083,12 +2080,12 @@ int btrfs_read_chunk_tree(struct btrfs_root *root)
 			struct btrfs_dev_item *dev_item;
 			dev_item = btrfs_item_ptr(leaf, slot,
 						  struct btrfs_dev_item);
-			ret = read_one_dev(root, leaf, dev_item);
+			ret = read_one_dev(fs_info, leaf, dev_item);
 			BUG_ON(ret);
 		} else if (found_key.type == BTRFS_CHUNK_ITEM_KEY) {
 			struct btrfs_chunk *chunk;
 			chunk = btrfs_item_ptr(leaf, slot, struct btrfs_chunk);
-			ret = read_one_chunk(root, &found_key, leaf, chunk,
+			ret = read_one_chunk(fs_info, &found_key, leaf, chunk,
 					     slot);
 			BUG_ON(ret);
 		}
diff --git a/volumes.h b/volumes.h
index 8647656f..859fb020 100644
--- a/volumes.h
+++ b/volumes.h
@@ -204,8 +204,8 @@ static inline int btrfs_next_bg_system(struct btrfs_fs_info *fs_info,
 int btrfs_rmap_block(struct btrfs_fs_info *fs_info,
 		     u64 chunk_start, u64 physical, u64 devid,
 		     u64 **logical, int *naddrs, int *stripe_len);
-int btrfs_read_sys_array(struct btrfs_root *root);
-int btrfs_read_chunk_tree(struct btrfs_root *root);
+int btrfs_read_sys_array(struct btrfs_fs_info *fs_info);
+int btrfs_read_chunk_tree(struct btrfs_fs_info *fs_info);
 int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *extent_root, u64 *start,
 		      u64 *num_bytes, u64 type);
-- 
2.13.1



