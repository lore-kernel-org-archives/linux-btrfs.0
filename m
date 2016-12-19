Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:42029 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751979AbcLSG5D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Dec 2016 01:57:03 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
        by cn.fujitsu.com (Postfix) with ESMTP id E27AE41B4BDD
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Dec 2016 14:56:51 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 4/6] btrfs-progs: convert: Introduce new function to check if we can rollback
Date: Mon, 19 Dec 2016 14:56:40 +0800
Message-Id: <20161219065642.25078-5-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161219065642.25078-1-quwenruo@cn.fujitsu.com>
References: <20161219065642.25078-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce new function, check_rollback(), to collect data and check if
we can rollback the image.

The check part is quite straight forward:
Ensure all the file extents, except the ones inside reserved ranges, are
mapped 1:1 on disk.

The ones inside reserved ranges, 0~1M, 1st sb +64K, 2nd sb +64K, can be
mapped to anywhere, as btrfs needs to put super blocks in them.

Such behavir can meet both old convert(one large chunk) and new
convert(only old image file is 1:1 mapped).

Also, the function will read out the data in btrfs reserved ranges for
later rollback usage.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 convert/main.c | 214 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 214 insertions(+)

diff --git a/convert/main.c b/convert/main.c
index 87c52c1..5b9141b 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -2781,6 +2781,220 @@ static int record_reloc_data(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
+static int check_image_file_extents(struct btrfs_root *image_root, u64 ino,
+				    u64 total_size, char *reloc_ranges[3])
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
+		u64 extent_offset;
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
+		extent_offset = btrfs_file_extent_offset(leaf, fi);
+
+		checked_bytes += ram_bytes;
+		/* Skip hole */
+		if (disk_bytenr == 0)
+			goto next;
+
+		if (file_offset != disk_bytenr) {
+			/*
+			 * Only file extent in btrfs reserved ranges are allow
+			 * non-1:1 mapped
+			 */
+			if (!is_range_subset_of_reserved_ranges(file_offset,
+							ram_bytes)) {
+				ret = -EINVAL;
+				error(
+		"ino %llu offset %llu file extent should not be relocated",
+					ino, file_offset);
+				break;
+			}
+		}
+		ret = record_reloc_data(fs_info, file_offset,
+				disk_bytenr + extent_offset, ram_bytes,
+				reloc_ranges);
+		if (ret < 0) {
+			error("ino %llu offset %llu failed to read extent data",
+				ino, file_offset);
+			break;
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
+			ret = -EINVAL;
+			error("inode %llu has some file extents not checked",
+				ino);
+		}
+	}
+	return ret;
+}
+
+/*
+ * Check and record needed blocks for rollback.
+ *
+ * It will record data for superblock and reserved ranges to reloc_ranges[].
+ * So we can rollback the fs after close_ctree().
+ */
+static int check_rollback(struct btrfs_fs_info *fs_info, char *reloc_ranges[3])
+{
+	struct btrfs_root *image_root;
+	struct btrfs_dir_item *dir;
+	struct btrfs_path path;
+	struct btrfs_key key;
+	struct btrfs_inode_item *inode_item;
+	char *image_name = "image";
+	u64 ino;
+	u64 root_dir;
+	u64 total_bytes;
+	int ret;
+
+	btrfs_init_path(&path);
+
+	/*
+	 * Search for root backref, or after subvolume delete(orphan),
+	 * we can still rollback if the subvolume is just orphan.
+	 */
+	key.objectid = CONV_IMAGE_SUBVOL_OBJECTID;
+	key.type = BTRFS_ROOT_BACKREF_KEY;
+	key.offset = BTRFS_FS_TREE_OBJECTID;
+
+	ret = btrfs_search_slot(NULL, fs_info->tree_root, &key, &path, 0, 0);
+	btrfs_release_path(&path);
+	if (ret > 0) {
+		error("unable to convert ext2 image subvolume, is it deleted?");
+		return -ENOENT;
+	} else if (ret < 0) {
+		error("failed to find ext2 image subvolume: %s",
+			strerror(-ret));
+		return ret;
+	}
+
+	/* Search convert subvolume */
+	key.objectid = CONV_IMAGE_SUBVOL_OBJECTID;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = (u64)-1;
+
+	image_root = btrfs_read_fs_root(fs_info, &key);
+	if (IS_ERR(image_root)) {
+		ret = PTR_ERR(image_root);
+		error("failed to open convert image subvolume: %s",
+			strerror(-ret));
+		return ret;
+	}
+
+	/* Search the image file */
+	root_dir = btrfs_root_dirid(&image_root->root_item);
+	dir = btrfs_lookup_dir_item(NULL, image_root, &path, root_dir,
+			image_name, strlen(image_name), 0);
+
+	if (!dir || IS_ERR(dir)) {
+		btrfs_release_path(&path);
+		if (dir)
+			ret = PTR_ERR(dir);
+		else
+			ret = -ENOENT;
+		error("failed to locate file %s: %s", image_name,
+			strerror(-ret));
+		return ret;
+	}
+	btrfs_dir_item_key_to_cpu(path.nodes[0], dir, &key);
+	btrfs_release_path(&path);
+
+	/* Get total size of the original image */
+	ino = key.objectid;
+
+	ret = btrfs_lookup_inode(NULL, image_root, &path, &key, 0);
+	if (ret < 0) {
+		btrfs_release_path(&path);
+		error("unable to find inode %llu: %s", ino, strerror(-ret));
+		return ret;
+	}
+	inode_item = btrfs_item_ptr(path.nodes[0], path.slots[0],
+				    struct btrfs_inode_item);
+	total_bytes = btrfs_inode_size(path.nodes[0], inode_item);
+	btrfs_release_path(&path);
+
+	/* Main function to check every file extent of the image file */
+	ret = check_image_file_extents(image_root, ino, total_bytes,
+					reloc_ranges);
+	return ret;
+}
+
 static int do_rollback(const char *devname)
 {
 	int fd = -1;
-- 
2.10.2



