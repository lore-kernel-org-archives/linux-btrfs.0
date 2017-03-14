Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33948 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750912AbdCNIFW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Mar 2017 04:05:22 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH v3 6/7] btrfs-progs: convert: Introduce function to check if convert image is able to be rolled back
Date: Tue, 14 Mar 2017 16:05:08 +0800
Message-ID: <20170314080509.31163-7-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170314080509.31163-1-quwenruo@cn.fujitsu.com>
References: <20170314080509.31163-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a function, check_convert_image() to check if that image is
rollback-able.

This means all file extents excepts one in btrfs reserved ranges, must
be mapped 1:1 on disk.

1:1 mapped file extents must match the following condition:
1) Their file_offset(key.offset) matches its disk_bytenr
2) The corresponding chunk must be mapped 1:1 on disk
   That's to say, it's a SINGLE chunk, and chunk logical matches with
   stripe physical.

Above 2 conditions ensured that file extent lies the exactly the same
position as old filesystem.

For data in reserved ranges of btrfs, they are relocated to new places,
and in that case, we use btrfs_read_file() to read out the content for
later rollback use.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 convert/main.c | 179 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 179 insertions(+)

diff --git a/convert/main.c b/convert/main.c
index 505b4a70..3ad7b2fb 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -1537,6 +1537,185 @@ static int read_reserved_ranges(struct btrfs_root *root, u64 ino,
 	return ret;
 }
 
+static bool is_subset_of_reserved_ranges(u64 start, u64 len)
+{
+	int i;
+	bool ret = false;
+
+	for (i = 0; i < ARRAY_SIZE(btrfs_reserved_ranges); i++) {
+		const struct simple_range *range = &btrfs_reserved_ranges[i];
+
+		if (start >= range->start && start + len <= range_end(range)) {
+			ret = true;
+			break;
+		}
+	}
+	return ret;
+}
+
+static bool is_chunk_direct_mapped(struct btrfs_fs_info *fs_info, u64 start)
+{
+	struct cache_extent *ce;
+	struct map_lookup *map;
+	bool ret = false;
+
+	ce = search_cache_extent(&fs_info->mapping_tree.cache_tree, start);
+	if (!ce)
+		goto out;
+	if (ce->start > start || ce->start + ce->size < start)
+		goto out;
+
+	map = container_of(ce, struct map_lookup, ce);
+
+	/* Not SINGLE chunk */
+	if (map->num_stripes != 1)
+		goto out;
+
+	/* Chunk's logical doesn't match with phisical, not 1:1 mapped */
+	if (map->ce.start != map->stripes[0].physical)
+		goto out;
+	ret = true;
+out:
+	return ret;
+}
+
+/*
+ * Iterate all file extents of the convert image.
+ *
+ * All file extents except ones in btrfs_reserved_ranges[] must be mapped 1:1
+ * on disk. (Means their file_offset must match their on disk bytenr)
+ *
+ * File extents in reserved ranges can be relocated to other place, and in
+ * that case we will read them out for later use.
+ */
+static int check_convert_image(struct btrfs_root *image_root, u64 ino,
+			       u64 total_size, char *reserved_ranges[])
+{
+	struct btrfs_key key;
+	struct btrfs_path path;
+	struct btrfs_fs_info *fs_info = image_root->fs_info;
+	u64 checked_bytes = 0;
+	int ret;
+
+	key.objectid = ino;
+	key.offset = 0;
+	key.type = BTRFS_EXTENT_DATA_KEY;
+
+	btrfs_init_path(&path);
+	ret = btrfs_search_slot(NULL, image_root, &key, &path, 0, 0);
+	/*
+	 * It's possible that some fs doesn't store any(including sb)
+	 * data into 0~1M range, and NO_HOLES is enabled.
+	 *
+	 * So only needs to check ret < 0 case
+	 */
+	if (ret < 0) {
+		error("failed to iterate file extents at offset 0: %s",
+			strerror(-ret));
+		btrfs_release_path(&path);
+		return ret;
+	}
+
+	/* Loop from the first file extents */
+	while (1) {
+		struct btrfs_file_extent_item *fi;
+		struct extent_buffer *leaf = path.nodes[0];
+		u64 disk_bytenr;
+		u64 file_offset;
+		u64 ram_bytes;
+		int slot = path.slots[0];
+
+		if (slot >= btrfs_header_nritems(leaf))
+			goto next;
+		btrfs_item_key_to_cpu(leaf, &key, slot);
+
+		/*
+		 * Iteration is done, exit normally, we have extra check out of
+		 * the loop
+		 */
+		if (key.objectid != ino || key.type != BTRFS_EXTENT_DATA_KEY) {
+			ret = 0;
+			break;
+		}
+		file_offset = key.offset;
+		fi = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
+		if (btrfs_file_extent_type(leaf, fi) != BTRFS_FILE_EXTENT_REG) {
+			ret = -EINVAL;
+			error(
+		"ino %llu offset %llu doesn't have a regular file extent",
+				ino, file_offset);
+			break;
+		}
+		if (btrfs_file_extent_compression(leaf, fi) ||
+		    btrfs_file_extent_encryption(leaf, fi) ||
+		    btrfs_file_extent_other_encoding(leaf, fi)) {
+			ret = -EINVAL;
+			error(
+			"ino %llu offset %llu doesn't have a plain file extent",
+				ino, file_offset);
+			break;
+		}
+
+		disk_bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
+		ram_bytes = btrfs_file_extent_ram_bytes(leaf, fi);
+
+		checked_bytes += ram_bytes;
+		/* Skip hole */
+		if (disk_bytenr == 0)
+			goto next;
+
+		/*
+		 * Most file extent must be 1:1 mapped, which means 2 things:
+		 * 1) File extent file offset == disk_bytenr
+		 * 2) That data chunk's logical == chunk's physical
+		 *
+		 * So file extent's file offset == physical position on disk.
+		 *
+		 * And after rolling back btrfs reserved range, other part
+		 * remains what old fs used to be.
+		 */
+		if (file_offset != disk_bytenr ||
+		    !is_chunk_direct_mapped(fs_info, disk_bytenr)) {
+			/*
+			 * Only file extent in btrfs reserved ranges are allow
+			 * non-1:1 mapped
+			 */
+			if (!is_subset_of_reserved_ranges(file_offset,
+							ram_bytes)) {
+				ret = -EINVAL;
+				error(
+		"ino %llu offset %llu file extent should not be relocated",
+					ino, file_offset);
+				break;
+			}
+		}
+next:
+		ret = btrfs_next_item(image_root, &path);
+		if (ret) {
+			if (ret > 0)
+				ret = 0;
+			break;
+		}
+	}
+	btrfs_release_path(&path);
+	/*
+	 * For HOLES mode (without NO_HOLES), we must ensure file extents
+	 * cover the whole range of the image
+	 */
+	if (!ret && !btrfs_fs_incompat(fs_info, NO_HOLES)) {
+		if (checked_bytes != total_size) {
+			error("inode %llu has some file extents not checked",
+				ino);
+			return -EINVAL;
+		}
+	}
+
+	/* So far so good, read out old data located in btrfs reserved ranges */
+	ret = read_reserved_ranges(image_root, ino, total_size,
+				   reserved_ranges);
+	return ret;
+}
+
 static int do_rollback(const char *devname)
 {
 	int fd = -1;
-- 
2.12.0



