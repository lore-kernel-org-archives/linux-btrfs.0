Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62127 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755141AbbKRHY4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Nov 2015 02:24:56 -0500
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tAI7NoSC007932
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2015 15:24:02 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH 17/22] btrfs-progs: extent-tree: Enhance btrfs_record_file_extent
Date: Wed, 18 Nov 2015 15:22:17 +0800
Message-Id: <1447831342-15056-18-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1447831342-15056-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1447831342-15056-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs_record_file_extent() has some small problems like:
1) Can't handle overlap extent
2) May create extent larger than BTRFS_MAX_EXTENT_SIZE

So enhance it using previous added facilites.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 extent-tree.c | 160 ++++++++++++++++++++++++++++++++++++++++------------------
 utils.h       |   2 +
 2 files changed, 114 insertions(+), 48 deletions(-)

diff --git a/extent-tree.c b/extent-tree.c
index 9fa9377..a2f8fee 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -3917,7 +3917,7 @@ static void __get_extent_size(struct btrfs_root *root, struct btrfs_path *path,
 	BUG_ON(!(key.type == BTRFS_EXTENT_ITEM_KEY ||
 		 key.type == BTRFS_METADATA_ITEM_KEY));
 	*start = key.objectid;
-	if (key.type == BTRFS_EXTENT_DATA_KEY)
+	if (key.type == BTRFS_EXTENT_ITEM_KEY)
 		*len = key.offset;
 	else
 		*len = root->nodesize;
@@ -3971,16 +3971,11 @@ next:
 	return 0;
 }
 
-/*
- * Record a file extent. Do all the required works, such as inserting
- * file extent item, inserting extent item and backref item into extent
- * tree and updating block accounting.
- */
-int btrfs_record_file_extent(struct btrfs_trans_handle *trans,
+static int __btrfs_record_file_extent(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root, u64 objectid,
 			      struct btrfs_inode_item *inode,
 			      u64 file_pos, u64 disk_bytenr,
-			      u64 num_bytes)
+			      u64 *ret_num_bytes)
 {
 	int ret;
 	struct btrfs_fs_info *info = root->fs_info;
@@ -3988,36 +3983,100 @@ int btrfs_record_file_extent(struct btrfs_trans_handle *trans,
 	struct extent_buffer *leaf;
 	struct btrfs_file_extent_item *fi;
 	struct btrfs_key ins_key;
-	struct btrfs_path path;
+	struct btrfs_path *path;
 	struct btrfs_extent_item *ei;
 	u64 nbytes;
+	u64 extent_num_bytes;
+	u64 extent_bytenr;
+	u64 extent_offset;
+	u64 num_bytes = *ret_num_bytes;
 
+	num_bytes = min_t(u64, num_bytes, BTRFS_MAX_EXTENT_SIZE);
 	if (disk_bytenr == 0) {
 		ret = btrfs_insert_file_extent(trans, root, objectid,
 						file_pos, disk_bytenr,
 						num_bytes, num_bytes);
+		*ret_num_bytes = num_bytes;
 		return ret;
 	}
 
-	btrfs_init_path(&path);
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	/* First to check extent overlap */
+	ret = btrfs_search_overlap_extent(extent_root, path, disk_bytenr,
+					  num_bytes);
+	if (ret < 0)
+		goto fail;
+	if (ret > 0) {
+		/* Found overlap */
+		u64 cur_start;
+		u64 cur_len;
+
+		__get_extent_size(extent_root, path, &cur_start, &cur_len);
+		/*
+		 * Now we only support subset of exist extent
+		 * No complicated split, as in btrfs-convert caller, it
+		 * won't happen
+		 */
+		BUG_ON(disk_bytenr < cur_start);
+
+		extent_bytenr = cur_start;
+		extent_num_bytes = cur_len;
+		extent_offset = disk_bytenr - extent_bytenr;
+	} else {
+		/* No overlap at all, create new extent */
+		btrfs_release_path(path);
+		ins_key.objectid = disk_bytenr;
+		ins_key.offset = num_bytes;
+		ins_key.type = BTRFS_EXTENT_ITEM_KEY;
+
+		ret = btrfs_insert_empty_item(trans, extent_root, path,
+					      &ins_key, sizeof(*ei));
+		if (ret == 0) {
+			leaf = path->nodes[0];
+			ei = btrfs_item_ptr(leaf, path->slots[0],
+					    struct btrfs_extent_item);
+
+			btrfs_set_extent_refs(leaf, ei, 0);
+			btrfs_set_extent_generation(leaf, ei, 0);
+			btrfs_set_extent_flags(leaf, ei,
+					       BTRFS_EXTENT_FLAG_DATA);
+
+			btrfs_mark_buffer_dirty(leaf);
+
+			ret = btrfs_update_block_group(trans, root, disk_bytenr,
+						       num_bytes, 1, 0);
+			if (ret)
+				goto fail;
+		} else if (ret != -EEXIST) {
+			goto fail;
+		}
+		btrfs_extent_post_op(trans, extent_root);
+		extent_bytenr = disk_bytenr;
+		extent_num_bytes = num_bytes;
+		extent_offset = 0;
+	}
 
+	btrfs_release_path(path);
 	ins_key.objectid = objectid;
 	ins_key.offset = file_pos;
 	btrfs_set_key_type(&ins_key, BTRFS_EXTENT_DATA_KEY);
-	ret = btrfs_insert_empty_item(trans, root, &path, &ins_key,
+	ret = btrfs_insert_empty_item(trans, root, path, &ins_key,
 				      sizeof(*fi));
 	if (ret)
 		goto fail;
-	leaf = path.nodes[0];
-	fi = btrfs_item_ptr(leaf, path.slots[0],
+	leaf = path->nodes[0];
+	fi = btrfs_item_ptr(leaf, path->slots[0],
 			    struct btrfs_file_extent_item);
 	btrfs_set_file_extent_generation(leaf, fi, trans->transid);
 	btrfs_set_file_extent_type(leaf, fi, BTRFS_FILE_EXTENT_REG);
-	btrfs_set_file_extent_disk_bytenr(leaf, fi, disk_bytenr);
-	btrfs_set_file_extent_disk_num_bytes(leaf, fi, num_bytes);
-	btrfs_set_file_extent_offset(leaf, fi, 0);
+	btrfs_set_file_extent_disk_bytenr(leaf, fi, extent_bytenr);
+	btrfs_set_file_extent_disk_num_bytes(leaf, fi, extent_num_bytes);
+	btrfs_set_file_extent_offset(leaf, fi, extent_offset);
 	btrfs_set_file_extent_num_bytes(leaf, fi, num_bytes);
-	btrfs_set_file_extent_ram_bytes(leaf, fi, num_bytes);
+	btrfs_set_file_extent_ram_bytes(leaf, fi, extent_num_bytes);
 	btrfs_set_file_extent_compression(leaf, fi, 0);
 	btrfs_set_file_extent_encryption(leaf, fi, 0);
 	btrfs_set_file_extent_other_encoding(leaf, fi, 0);
@@ -4026,41 +4085,46 @@ int btrfs_record_file_extent(struct btrfs_trans_handle *trans,
 	nbytes = btrfs_stack_inode_nbytes(inode) + num_bytes;
 	btrfs_set_stack_inode_nbytes(inode, nbytes);
 
-	btrfs_release_path(&path);
-
-	ins_key.objectid = disk_bytenr;
-	ins_key.offset = num_bytes;
-	ins_key.type = BTRFS_EXTENT_ITEM_KEY;
-
-	ret = btrfs_insert_empty_item(trans, extent_root, &path,
-				      &ins_key, sizeof(*ei));
-	if (ret == 0) {
-		leaf = path.nodes[0];
-		ei = btrfs_item_ptr(leaf, path.slots[0],
-				    struct btrfs_extent_item);
-
-		btrfs_set_extent_refs(leaf, ei, 0);
-		btrfs_set_extent_generation(leaf, ei, 0);
-		btrfs_set_extent_flags(leaf, ei, BTRFS_EXTENT_FLAG_DATA);
-
-		btrfs_mark_buffer_dirty(leaf);
-
-		ret = btrfs_update_block_group(trans, root, disk_bytenr,
-					       num_bytes, 1, 0);
-		if (ret)
-			goto fail;
-	} else if (ret != -EEXIST) {
-		goto fail;
-	}
-	btrfs_extent_post_op(trans, extent_root);
+	btrfs_release_path(path);
 
-	ret = btrfs_inc_extent_ref(trans, root, disk_bytenr, num_bytes, 0,
-				   root->root_key.objectid,
-				   objectid, file_pos);
+	ret = btrfs_inc_extent_ref(trans, root, extent_bytenr, extent_num_bytes,
+				   0, root->root_key.objectid, objectid,
+				   file_pos - extent_offset);
 	if (ret)
 		goto fail;
 	ret = 0;
+	*ret_num_bytes = min(extent_num_bytes, num_bytes);
 fail:
-	btrfs_release_path(&path);
+	btrfs_free_path(path);
+	return ret;
+}
+
+/*
+ * Record a file extent. Do all the required works, such as inserting
+ * file extent item, inserting extent item and backref item into extent
+ * tree and updating block accounting.
+ */
+int btrfs_record_file_extent(struct btrfs_trans_handle *trans,
+			     struct btrfs_root *root, u64 objectid,
+			     struct btrfs_inode_item *inode,
+			     u64 file_pos, u64 disk_bytenr,
+			     u64 num_bytes)
+{
+	u64 cur_disk_bytenr = disk_bytenr;
+	u64 cur_file_pos = file_pos;
+	u64 cur_num_bytes = num_bytes;
+	int ret = 0;
+
+	while (num_bytes > 0) {
+		ret = __btrfs_record_file_extent(trans, root, objectid,
+						 inode, cur_file_pos,
+						 cur_disk_bytenr,
+						 &cur_num_bytes);
+		if (ret < 0)
+			break;
+		cur_disk_bytenr += cur_num_bytes;
+		cur_file_pos += cur_num_bytes;
+		num_bytes -= cur_num_bytes;
+	}
 	return ret;
 }
diff --git a/utils.h b/utils.h
index cec30dc..1fcc72e 100644
--- a/utils.h
+++ b/utils.h
@@ -31,6 +31,8 @@
 		(BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF		\
 		| BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA)
 
+#define BTRFS_MAX_EXTENT_SIZE	(128 * 1024 * 1024)
+
 #define BTRFS_CONVERT_META_GROUP_SIZE (32 * 1024 * 1024)
 
 /*
-- 
2.6.2

