Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:51089 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750844AbbG1JRN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jul 2015 05:17:13 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t6S9FJgN022602
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2015 17:15:19 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH RFC 01/14] btrfs: file-item: Introduce btrfs_setup_file_extent function.
Date: Tue, 28 Jul 2015 17:14:54 +0800
Message-ID: <9b3ad56c16210ec630d643471694754aadcccaac.1438074833.git.quwenruo@cn.fujitsu.com>
In-Reply-To: <cover.1438074833.git.quwenruo@cn.fujitsu.com>
References: <cover.1438074833.git.quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This new function is just used to fill the file extent with given
numbers.

This is mainly used for later cleanup of duplicated file extent setup
codes in inode.c, but also centralized the safety check for later
expansion.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/ctree.h     |  5 +++++
 fs/btrfs/file-item.c | 40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index aac314e..68ffd26 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3825,6 +3825,11 @@ int btrfs_lookup_bio_sums(struct btrfs_root *root, struct inode *inode,
 			  struct bio *bio, u32 *dst);
 int btrfs_lookup_bio_sums_dio(struct btrfs_root *root, struct inode *inode,
 			      struct bio *bio, u64 logical_offset);
+void btrfs_fill_file_extent(struct btrfs_trans_handle *trans,
+			    struct btrfs_path *path, u64 disk_bytenr,
+			    u64 disk_num_bytes, u64 offset, u64 num_bytes,
+			    u64 ram_bytes, u8 type, u8 compression,
+			    u8 encryption, u16 other_encoding);
 int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
 			     u64 objectid, u64 pos,
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 58ece65..e1d7c03 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -37,6 +37,46 @@
 				   sizeof(struct btrfs_ordered_sum)) / \
 				   sizeof(u32) * (r)->sectorsize)
 
+/*
+ * Fill contents of the file extent.
+ *
+ * The file extent is indicated by path.
+ * It's mainlly used to reduce the duplicated codes, but also added some extra
+ * safety check.
+ */
+void btrfs_fill_file_extent(struct btrfs_trans_handle *trans,
+			    struct btrfs_path *path, u64 disk_bytenr,
+			    u64 disk_num_bytes, u64 offset, u64 num_bytes,
+			    u64 ram_bytes, u8 type, u8 compression,
+			    u8 encryption, u16 other_encoding)
+{
+	struct btrfs_key key;
+	struct extent_buffer *node = path->nodes[0];
+	struct btrfs_file_extent_item *item;
+	int slot = path->slots[0];
+
+	BUG_ON(encryption || other_encoding);
+	BUG_ON(type == BTRFS_FILE_EXTENT_INLINE);
+
+	btrfs_item_key_to_cpu(node, &key, slot);
+	WARN_ON(key.type != BTRFS_EXTENT_DATA_KEY);
+
+	item = btrfs_item_ptr(node, slot, struct btrfs_file_extent_item);
+
+	btrfs_set_file_extent_generation(node, item, trans->transid);
+	btrfs_set_file_extent_disk_bytenr(node, item, disk_bytenr);
+	btrfs_set_file_extent_disk_num_bytes(node, item, disk_num_bytes);
+	btrfs_set_file_extent_offset(node, item, offset);
+	btrfs_set_file_extent_num_bytes(node, item, num_bytes);
+	btrfs_set_file_extent_ram_bytes(node, item, ram_bytes);
+	btrfs_set_file_extent_type(node, item, type);
+	btrfs_set_file_extent_compression(node, item, compression);
+	btrfs_set_file_extent_other_encoding(node, item, 0);
+	btrfs_set_file_extent_encryption(node, item, 0);
+
+	btrfs_mark_buffer_dirty(node);
+}
+
 int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
 			     u64 objectid, u64 pos,
-- 
2.4.6

