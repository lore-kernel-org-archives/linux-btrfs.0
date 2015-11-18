Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23505 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755211AbbKRHY7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Nov 2015 02:24:59 -0500
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tAI7NoSF007932
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2015 15:24:04 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH 20/22] btrfs-progs: Enhance record_file_blocks to handle reserved ranges
Date: Wed, 18 Nov 2015 15:22:20 +0800
Message-Id: <1447831342-15056-21-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1447831342-15056-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1447831342-15056-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Enhance record_file_blocks() function to handle reserved ranges.

Unlike most of file extents, ext* data in reserved ranges are not mapped
on disk with 1:1 bytenr.
So we can't use bytenr directly.

But thanks for calling create_ext2_image_v2() before copying inodes, we
have a image in convert subvolume as a logical <-> disk bytenr mapping.

So use it to handle reserved ranges for record_file_blocks().

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-convert.c | 99 +++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 90 insertions(+), 9 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 657fc1d..993ee80 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -464,7 +464,9 @@ static int csum_disk_extent(struct btrfs_trans_handle *trans,
 struct blk_iterate_data {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root;
+	struct btrfs_root *convert_root;
 	struct btrfs_inode_item *inode;
+	u64 convert_ino;
 	u64 objectid;
 	u64 first_block;
 	u64 disk_block;
@@ -480,6 +482,8 @@ static void init_blk_iterate_data(struct blk_iterate_data *data,
 				  struct btrfs_inode_item *inode,
 				  u64 objectid, int checksum)
 {
+	struct btrfs_key key;
+
 	data->trans		= trans;
 	data->root		= root;
 	data->inode		= inode;
@@ -490,25 +494,100 @@ static void init_blk_iterate_data(struct blk_iterate_data *data,
 	data->boundary		= (u64)-1;
 	data->checksum		= checksum;
 	data->errcode		= 0;
+
+	key.objectid = CONV_IMAGE_SUBVOL_OBJECTID;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = (u64)-1;
+	data->convert_root = btrfs_read_fs_root(root->fs_info, &key);
+	/* Impossible since previously we just opened that subvolume */
+	BUG_ON(!data->convert_root || IS_ERR(data->convert_root));
+	data->convert_ino = BTRFS_FIRST_FREE_OBJECTID + 1;
 }
 
 static int record_file_blocks(struct blk_iterate_data *data,
 			      u64 file_block, u64 disk_block, u64 num_blocks)
 {
-	int ret;
+	int ret = 0;
 	struct btrfs_root *root = data->root;
+	struct btrfs_root *convert_root = data->convert_root;
+	struct btrfs_path *path;
 	u64 file_pos = file_block * root->sectorsize;
-	u64 disk_bytenr = disk_block * root->sectorsize;
+	u64 old_disk_bytenr = disk_block * root->sectorsize;
 	u64 num_bytes = num_blocks * root->sectorsize;
-	ret = btrfs_record_file_extent(data->trans, data->root,
-				       data->objectid, data->inode, file_pos,
-				       disk_bytenr, num_bytes);
-
-	if (ret || !data->checksum || disk_bytenr == 0)
-		return ret;
+	u64 cur_off = old_disk_bytenr;
 
-	return csum_disk_extent(data->trans, data->root, disk_bytenr,
+	if (old_disk_bytenr == 0)
+		return btrfs_record_file_extent(data->trans, root,
+				data->objectid, data->inode, file_pos, 0,
 				num_bytes);
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+	/*
+	 * Since the logical mapping of converted image is not all 1:1,
+	 * especially for the reserved ranges, so we shouldn't use disk_bytenr
+	 * directly, but search in convert_subvolume.
+	 * Which acts like another logical <-> disk mapping layer.
+	 */
+	while (cur_off < old_disk_bytenr + num_bytes) {
+		struct btrfs_key key;
+		struct btrfs_file_extent_item *fi;
+		struct extent_buffer *node;
+		int slot;
+		u64 extent_disk_bytenr;
+		u64 extent_num_bytes;
+		u64 real_disk_bytenr;
+		u64 cur_len;
+
+		key.objectid = data->convert_ino;
+		key.type = BTRFS_EXTENT_DATA_KEY;
+		key.offset = cur_off;
+
+		ret = btrfs_search_slot(NULL, convert_root, &key, path, 0, 0);
+		if (ret < 0)
+			break;
+		if (ret > 0) {
+			ret = btrfs_previous_item(convert_root, path,
+						  data->convert_ino,
+						  BTRFS_EXTENT_DATA_KEY);
+			if (ret < 0)
+				break;
+			if (ret > 0) {
+				ret = -ENOENT;
+				break;
+			}
+		}
+		node = path->nodes[0];
+		slot = path->slots[0];
+		btrfs_item_key_to_cpu(node, &key, slot);
+		BUG_ON(key.type != BTRFS_EXTENT_DATA_KEY ||
+		       key.objectid != data->convert_ino ||
+		       key.offset > cur_off);
+		fi = btrfs_item_ptr(node, slot, struct btrfs_file_extent_item);
+		extent_disk_bytenr = btrfs_file_extent_disk_bytenr(node, fi);
+		extent_num_bytes = btrfs_file_extent_disk_num_bytes(node, fi);
+		BUG_ON(cur_off - key.offset >= extent_num_bytes);
+		btrfs_release_path(path);
+
+		real_disk_bytenr = cur_off - key.offset + extent_disk_bytenr;
+		cur_len = min(key.offset + extent_num_bytes,
+			      old_disk_bytenr + num_bytes) - cur_off;
+		ret = btrfs_record_file_extent(data->trans, data->root,
+				data->objectid, data->inode, file_pos,
+				real_disk_bytenr, cur_len);
+		if (ret < 0)
+			break;
+		cur_off += cur_len;
+		file_pos += cur_len;
+		/*
+		 * Here we don't need to care about data checksum
+		 * As all the ext* data is already calculated for csum, so no
+		 * need to calculate it again
+		 */
+	}
+
+	btrfs_free_path(path);
+	return ret;
 }
 
 static int block_iterate_proc(u64 disk_block, u64 file_block,
@@ -1638,6 +1717,8 @@ static int create_ext2_image_v2(struct btrfs_root *root,
 				       &ino);
 	if (ret < 0)
 		goto out;
+	/* Shouldn't happen, and we need this const ino for later use */
+	BUG_ON(ino != BTRFS_FIRST_FREE_OBJECTID + 1);
 	ret = btrfs_new_inode(trans, root, ino, 0600 | S_IFREG);
 	if (ret < 0)
 		goto out;
-- 
2.6.2

