Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:17620 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1161732AbcEaCq3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 May 2016 22:46:29 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: convert: Add support to rollback new convert image
Date: Tue, 31 May 2016 10:46:00 +0800
Message-Id: <20160531024600.11382-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For new btrfs-convert, it's less restrict for metadata chunk allocation.
While the may_rollback() function is still following the restrict 1:1
mapping check for all chunks, it will not allow some new convert image
to be rolled back.

Add new per extent check for new convert to allow it to be rolled back.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-convert.c | 79 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 78 insertions(+), 1 deletion(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index f776a4f..c28dae6 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2315,6 +2315,65 @@ fail:
 	return -1;
 }
 
+/*
+ * Check if a non 1:1 mapped chunk can be rolled back.
+ * For new convert, it's OK while for old convert it's NG
+ */
+static int may_rollback_chunk(struct btrfs_fs_info *fs_info, u64 bytenr)
+{
+	struct btrfs_block_group_cache *bg;
+	struct btrfs_key key;
+	struct btrfs_path path;
+	struct btrfs_root *extent_root = fs_info->extent_root;
+	u64 bg_start;
+	u64 bg_end;
+	int ret;
+
+	bg = btrfs_lookup_first_block_group(fs_info, bytenr);
+	if (!bg)
+		return -ENOENT;
+	bg_start = bg->key.objectid;
+	bg_end = bg->key.objectid + bg->key.offset;
+
+	key.objectid = bg_end;
+	key.type = BTRFS_METADATA_ITEM_KEY;
+	key.offset = 0;
+	btrfs_init_path(&path);
+
+	ret = btrfs_search_slot(NULL, extent_root, &key, &path, 0, 0);
+	if (ret < 0)
+		return ret;
+
+	while (1) {
+		struct btrfs_extent_item *ei;
+
+		ret = btrfs_previous_extent_item(extent_root, &path, bg_start);
+		if (ret > 0) {
+			ret = 0;
+			break;
+		}
+		if (ret < 0)
+			break;
+
+		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
+		if (key.type == BTRFS_METADATA_ITEM_KEY)
+			continue;
+		/* Now it's EXTENT_ITEM_KEY only */
+		ei = btrfs_item_ptr(path.nodes[0], path.slots[0],
+				    struct btrfs_extent_item);
+		/*
+		 * Found data extent, means this is old convert
+		 * must follow 1:1 mapping.
+		 */
+		if (btrfs_extent_flags(path.nodes[0], ei) & BTRFS_EXTENT_FLAG_DATA) {
+			ret = -EINVAL;
+			break;
+		}
+	}
+	btrfs_release_path(&path);
+	return ret;
+}
+
 static int may_rollback(struct btrfs_root *root)
 {
 	struct btrfs_fs_info *info = root->fs_info;
@@ -2351,8 +2410,26 @@ static int may_rollback(struct btrfs_root *root)
 		physical = multi->stripes[0].physical;
 		kfree(multi);
 
-		if (num_stripes != 1 || physical != bytenr)
+		if (num_stripes != 1) {
+			error("Num stripes for bytenr %llu is not 1\n",
+			      bytenr);
 			goto fail;
+		}
+
+		/*
+		 * Extra check for new convert, as metadata chunk from
+		 * new convert is much more free than old convert, it doesn't
+		 * need to do 1:1 mapping.
+		 */
+		if (physical != bytenr) {
+			/*
+			 * Check if it's a metadata chunk and has only
+			 * metadata extent
+			 */
+			ret = may_rollback_chunk(info, bytenr);
+			if (ret < 0)
+				goto fail;
+		}
 next:
 		bytenr += length;
 		if (bytenr >= total_bytes)
-- 
2.8.3



