Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:21967 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751867AbcA2FRH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jan 2016 00:17:07 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, David Sterba <dsterba@suse.com>
Subject: [PATCH v3 17/22] btrfs-progs: convert: Enhance record_file_blocks to handle reserved ranges
Date: Fri, 29 Jan 2016 13:03:27 +0800
Message-Id: <1454043812-7893-18-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1454043812-7893-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1454043812-7893-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Enhance record_file_blocks() to handle reserved ranges.

Old file system can use the space in btrfs reserved ranges.
So we could not use the bytenr of old filesystem directly.

Thanks to previous patches, we have a full fs image in convert_root, and
it has already relocated the blocks in reserved ranges.
So here we just search the convert_root to get correct disk_bytenr and
use it.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 btrfs-convert.c | 103 +++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 94 insertions(+), 9 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index f6126db..8956a86 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -629,7 +629,9 @@ static int csum_disk_extent(struct btrfs_trans_handle *trans,
 struct blk_iterate_data {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root;
+	struct btrfs_root *convert_root;
 	struct btrfs_inode_item *inode;
+	u64 convert_ino;
 	u64 objectid;
 	u64 first_block;
 	u64 disk_block;
@@ -645,6 +647,8 @@ static void init_blk_iterate_data(struct blk_iterate_data *data,
 				  struct btrfs_inode_item *inode,
 				  u64 objectid, int checksum)
 {
+	struct btrfs_key key;
+
 	data->trans		= trans;
 	data->root		= root;
 	data->inode		= inode;
@@ -655,25 +659,106 @@ static void init_blk_iterate_data(struct blk_iterate_data *data,
 	data->boundary		= (u64)-1;
 	data->checksum		= checksum;
 	data->errcode		= 0;
+
+	key.objectid = CONV_IMAGE_SUBVOL_OBJECTID;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = (u64)-1;
+	data->convert_root = btrfs_read_fs_root(root->fs_info, &key);
+	/* Impossible as we just opened it before */
+	BUG_ON(!data->convert_root || IS_ERR(data->convert_root));
+	data->convert_ino = BTRFS_FIRST_FREE_OBJECTID + 1;
 }
 
+/*
+ * Record a file extent in original file system into btrfs one.
+ * The special point is, old disk_block can point to a reserved range.
+ * So here, we don't use disk_block directly but search convert_root
+ * to get the real disk_bytenr.
+ */
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
+	/* Hole, pass it to record_file_extent directly */
+	if (old_disk_bytenr == 0)
+		return btrfs_record_file_extent(data->trans, root,
+				data->objectid, data->inode, file_pos, 0,
 				num_bytes);
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	/*
+	 * Search real disk bytenr from convert root
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
+					data->objectid, data->inode, file_pos,
+					real_disk_bytenr, cur_len);
+		if (ret < 0)
+			break;
+		cur_off += cur_len;
+		file_pos += cur_len;
+
+		/*
+		 * No need to care about csum
+		 * As every byte of old fs image is calculated for csum, no
+		 * need to waste cpu cycle now.
+		 */
+	}
+	btrfs_free_path(path);
+	return ret;
 }
 
 static int block_iterate_proc(u64 disk_block, u64 file_block,
-- 
2.7.0



