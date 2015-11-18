Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23505 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754945AbbKRHYz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Nov 2015 02:24:55 -0500
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tAI7NoSE007932
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2015 15:24:04 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH 19/22] btrfs-progs: convert: Introduce function to migrate reserved ranges
Date: Wed, 18 Nov 2015 15:22:19 +0800
Message-Id: <1447831342-15056-20-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1447831342-15056-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1447831342-15056-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce new function, migrate_reserved_ranges() to migrate used ext2
data in btrfs reserved space.

Unlike old implement, which will need to relocate all the complicated
csum and reference relocation, above patches already ensure such
reserved ranges won't be allocated.
So here we only need copy these data out and create new
extent/csum/reference.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-convert.c | 123 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 122 insertions(+), 1 deletion(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 18701b1..657fc1d 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -1504,8 +1504,123 @@ static int create_image_file_range_v2(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+/*
+ * Relocate used ext2 data in one reserved ranges
+ *
+ * Since all ext2 data in reserved range is not covered by any chunk nor
+ * data extent, we don't need to handle any reference but add new
+ * extent/reference
+ */
+static int migrate_one_reserved_range(struct btrfs_trans_handle *trans,
+				      struct btrfs_root *root,
+				      struct cache_tree *used,
+				      struct btrfs_inode_item *inode, int fd,
+				      u64 ino, u64 start, u64 len, int datacsum)
+{
+	u64 cur_off = start;
+	u64 cur_len = len;
+	struct cache_extent *cache;
+	struct btrfs_key key;
+	struct extent_buffer *eb;
+	int ret = 0;
+
+	while (cur_off < start + len) {
+		cache = lookup_cache_extent(used, cur_off, cur_len);
+		if (!cache)
+			break;
+		cur_off = max(cache->start, cur_off);
+		cur_len = min(cache->start + cache->size, start + len) -
+			  cur_off;
+		BUG_ON(cur_len < root->sectorsize);
+
+		/* reserve extent for the data */
+		ret = btrfs_reserve_extent(trans, root, cur_len, 0, 0, (u64)-1, &key, 1);
+		if (ret < 0)
+			break;
+
+		eb = malloc(sizeof(*eb) + cur_len);
+		if (!eb) {
+			ret = -ENOMEM;
+			break;
+		}
+
+		ret = pread(fd, eb->data, cur_len, cur_off);
+		if (ret < cur_len) {
+			ret = (ret < 0 ? ret : -EIO);
+			free(eb);
+			break;
+		}
+		eb->start = key.objectid;
+		eb->len = key.offset;
+
+		/* Write the data */
+		ret = write_and_map_eb(trans, root, eb);
+		free(eb);
+		if (ret < 0)
+			break;
+
+		/* Now handle extent item and file extent things */
+		ret = btrfs_record_file_extent(trans, root, ino, inode, cur_off,
+					       key.objectid, key.offset);
+		if (ret < 0)
+			break;
+		/* Finally, insert csum items */
+		if (datacsum)
+			ret = csum_disk_extent(trans, root, key.objectid,
+					       key.offset);
+
+		cur_off += key.offset;
+		cur_len = start + len - cur_off;
+	}
+	return ret;
+}
+
+/*
+ * Relocate the used ext2 data in reserved ranges
+ * [0,1M)
+ * [btrfs_sb_offset(1), +BTRFS_STRIPE_LEN)
+ * [btrfs_sb_offset(2), +BTRFS_STRIPE_LEN)
+ */
+static int migrate_reserved_ranges(struct btrfs_trans_handle *trans,
+				   struct btrfs_root *root,
+				   struct cache_tree *used,
+				   struct btrfs_inode_item *inode, int fd,
+				   u64 ino, u64 total_bytes, int datacsum)
+{
+	u64 cur_off;
+	u64 cur_len;
+	int ret = 0;
+
+	/* 0 ~ 1M */
+	cur_off = 0;
+	cur_len = 1024 * 1024;
+	ret = migrate_one_reserved_range(trans, root, used, inode, fd, ino,
+					 cur_off, cur_len, datacsum);
+	if (ret < 0)
+		return ret;
+
+	/* second sb(fisrt sb is included in 0~1M) */
+	cur_off = btrfs_sb_offset(1);
+	cur_len = min(total_bytes, cur_off + BTRFS_STRIPE_LEN) - cur_off;
+	if (cur_off < total_bytes)
+		return ret;
+	ret = migrate_one_reserved_range(trans, root, used, inode, fd, ino,
+					 cur_off, cur_len, datacsum);
+	if (ret < 0)
+		return ret;
+
+	/* Last sb */
+	cur_off = btrfs_sb_offset(2);
+	cur_len = min(total_bytes, cur_off + BTRFS_STRIPE_LEN) - cur_off;
+	if (cur_off < total_bytes)
+		return ret;
+	ret = migrate_one_reserved_range(trans, root, used, inode, fd, ino,
+					 cur_off, cur_len, datacsum);
+	return ret;
+}
+
 static int create_ext2_image_v2(struct btrfs_root *root,
-				struct btrfs_mkfs_config *cfg, u64 size,
+				struct btrfs_mkfs_config *cfg, int fd, u64 size,
 				char *name, int datacsum)
 {
 	struct btrfs_inode_item buf;
@@ -1565,6 +1680,12 @@ static int create_ext2_image_v2(struct btrfs_root *root,
 		cur += len;
 	}
 
+	/* handle the reserved ranges */
+	ret = migrate_reserved_ranges(trans, root, &cfg->convert_used, &buf, fd,
+				      ino, cfg->num_bytes, datacsum);
+	if (ret < 0)
+		goto out;
+
 	key.objectid = ino;
 	key.type = BTRFS_INODE_ITEM_KEY;
 	key.offset = 0;
-- 
2.6.2

