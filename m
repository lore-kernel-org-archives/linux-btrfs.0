Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:51679 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751698AbbG1JRO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jul 2015 05:17:14 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t6S9FJM9022606
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2015 17:15:19 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH RFC 02/14] btrfs: Use btrfs_fill_file_extent to reduce duplicated codes
Date: Tue, 28 Jul 2015 17:14:55 +0800
Message-ID: <3d3b88d18f562d2f0b917b9e7a3bfe3167845ca0.1438074833.git.quwenruo@cn.fujitsu.com>
In-Reply-To: <cover.1438074833.git.quwenruo@cn.fujitsu.com>
References: <cover.1438074833.git.quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use btrfs_fill_file_extent() function to replace the hand-coded codes.
As it has better check and takes less effort to maintain.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/file-item.c | 20 ++++----------------
 fs/btrfs/inode.c     | 38 ++++++--------------------------------
 2 files changed, 10 insertions(+), 48 deletions(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index e1d7c03..87a8d85 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -88,7 +88,6 @@ int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
 	struct btrfs_file_extent_item *item;
 	struct btrfs_key file_key;
 	struct btrfs_path *path;
-	struct extent_buffer *leaf;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -103,21 +102,10 @@ int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
 	if (ret < 0)
 		goto out;
 	BUG_ON(ret); /* Can't happen */
-	leaf = path->nodes[0];
-	item = btrfs_item_ptr(leaf, path->slots[0],
-			      struct btrfs_file_extent_item);
-	btrfs_set_file_extent_disk_bytenr(leaf, item, disk_offset);
-	btrfs_set_file_extent_disk_num_bytes(leaf, item, disk_num_bytes);
-	btrfs_set_file_extent_offset(leaf, item, offset);
-	btrfs_set_file_extent_num_bytes(leaf, item, num_bytes);
-	btrfs_set_file_extent_ram_bytes(leaf, item, ram_bytes);
-	btrfs_set_file_extent_generation(leaf, item, trans->transid);
-	btrfs_set_file_extent_type(leaf, item, BTRFS_FILE_EXTENT_REG);
-	btrfs_set_file_extent_compression(leaf, item, compression);
-	btrfs_set_file_extent_encryption(leaf, item, encryption);
-	btrfs_set_file_extent_other_encoding(leaf, item, other_encoding);
-
-	btrfs_mark_buffer_dirty(leaf);
+	btrfs_fill_file_extent(trans, path, disk_offset, disk_num_bytes,
+			       offset, num_bytes, ram_bytes,
+			       BTRFS_FILE_EXTENT_REG, compression, encryption,
+			       other_encoding);
 out:
 	btrfs_free_path(path);
 	return ret;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e33dff3..3221010 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2052,7 +2052,6 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_file_extent_item *fi;
 	struct btrfs_path *path;
-	struct extent_buffer *leaf;
 	struct btrfs_key ins;
 	int extent_inserted = 0;
 	int ret;
@@ -2087,21 +2086,9 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 		if (ret)
 			goto out;
 	}
-	leaf = path->nodes[0];
-	fi = btrfs_item_ptr(leaf, path->slots[0],
-			    struct btrfs_file_extent_item);
-	btrfs_set_file_extent_generation(leaf, fi, trans->transid);
-	btrfs_set_file_extent_type(leaf, fi, extent_type);
-	btrfs_set_file_extent_disk_bytenr(leaf, fi, disk_bytenr);
-	btrfs_set_file_extent_disk_num_bytes(leaf, fi, disk_num_bytes);
-	btrfs_set_file_extent_offset(leaf, fi, 0);
-	btrfs_set_file_extent_num_bytes(leaf, fi, num_bytes);
-	btrfs_set_file_extent_ram_bytes(leaf, fi, ram_bytes);
-	btrfs_set_file_extent_compression(leaf, fi, compression);
-	btrfs_set_file_extent_encryption(leaf, fi, encryption);
-	btrfs_set_file_extent_other_encoding(leaf, fi, other_encoding);
-
-	btrfs_mark_buffer_dirty(leaf);
+	btrfs_fill_file_extent(trans, path, disk_bytenr, disk_num_bytes, 0,
+			       num_bytes, ram_bytes, extent_type, compression,
+			       encryption, other_encoding);
 	btrfs_release_path(path);
 
 	inode_add_bytes(inode, num_bytes);
@@ -2391,7 +2378,6 @@ static noinline int relink_extent_backref(struct btrfs_path *path,
 				 struct sa_defrag_extent_backref *backref)
 {
 	struct btrfs_file_extent_item *extent;
-	struct btrfs_file_extent_item *item;
 	struct btrfs_ordered_extent *ordered;
 	struct btrfs_trans_handle *trans;
 	struct btrfs_fs_info *fs_info;
@@ -2548,21 +2534,9 @@ again:
 		goto out_free_path;
 	}
 
-	leaf = path->nodes[0];
-	item = btrfs_item_ptr(leaf, path->slots[0],
-				struct btrfs_file_extent_item);
-	btrfs_set_file_extent_disk_bytenr(leaf, item, new->bytenr);
-	btrfs_set_file_extent_disk_num_bytes(leaf, item, new->disk_len);
-	btrfs_set_file_extent_offset(leaf, item, start - new->file_pos);
-	btrfs_set_file_extent_num_bytes(leaf, item, len);
-	btrfs_set_file_extent_ram_bytes(leaf, item, new->len);
-	btrfs_set_file_extent_generation(leaf, item, trans->transid);
-	btrfs_set_file_extent_type(leaf, item, BTRFS_FILE_EXTENT_REG);
-	btrfs_set_file_extent_compression(leaf, item, new->compress_type);
-	btrfs_set_file_extent_encryption(leaf, item, 0);
-	btrfs_set_file_extent_other_encoding(leaf, item, 0);
-
-	btrfs_mark_buffer_dirty(leaf);
+	btrfs_fill_file_extent(trans, path, new->bytenr, new->disk_len,
+			       start - new->file_pos, len, new->len,
+			       BTRFS_FILE_EXTENT_REG, new->compress_type, 0, 0);
 	inode_add_bytes(inode, len);
 	btrfs_release_path(path);
 
-- 
2.4.6

