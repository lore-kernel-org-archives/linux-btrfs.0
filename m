Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46667 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750860AbdCNIFW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Mar 2017 04:05:22 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH v3 4/7] btrfs-progs: file: Introduce function to read out file content
Date: Tue, 14 Mar 2017 16:05:06 +0800
Message-ID: <20170314080509.31163-5-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170314080509.31163-1-quwenruo@cn.fujitsu.com>
References: <20170314080509.31163-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new function, btrfs_read_file(), to read out data of a file
inode.

This function will iterate through EXTENT_DATA items and handle
inline/prealloc/hole file extents.

Compression is not supported yet.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 ctree.h |   2 +
 file.c  | 169 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 171 insertions(+)

diff --git a/ctree.h b/ctree.h
index 1d0622d9..63d6d047 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2776,4 +2776,6 @@ int btrfs_get_extent(struct btrfs_trans_handle *trans,
 int btrfs_punch_hole(struct btrfs_trans_handle *trans,
 		     struct btrfs_root *root,
 		     u64 ino, u64 offset, u64 len);
+int btrfs_read_file(struct btrfs_root *root, u64 ino, u64 start, int len,
+		    char *dest);
 #endif
diff --git a/file.c b/file.c
index dd0b04b8..06c1e2dd 100644
--- a/file.c
+++ b/file.c
@@ -18,6 +18,8 @@
 
 #include <sys/stat.h>
 #include "ctree.h"
+#include "utils.h"
+#include "disk-io.h"
 #include "transaction.h"
 #include "kerncompat.h"
 
@@ -160,3 +162,170 @@ out:
 	btrfs_free_path(path);
 	return ret;
 }
+
+/*
+ * Read out content of one inode.
+ *
+ * @root:  fs/subvolume root containing the inode
+ * @ino:   inode number
+ * @start: offset inside the file, aligned to sectorsize
+ * @len:   length to read, aligned to sectorisize
+ * @dest:  where data will be stored
+ *
+ * NOTE:
+ * 1) compression data is not supported yet.
+ * 2) @start and @len must be aligned to sectorsize
+ * 3) data read out is also aligned to sectorsize, not truncated to inode size
+ *
+ * Return < 0 for fatal error during read.
+ * Otherwise return the number of suceeful read out data.
+ */
+int btrfs_read_file(struct btrfs_root *root, u64 ino, u64 start, int len,
+		    char *dest)
+{
+	struct btrfs_key key;
+	struct btrfs_path path;
+	struct extent_buffer *leaf;
+	struct btrfs_inode_item *ii;
+	u64 isize;
+	int no_holes = btrfs_fs_incompat(root->fs_info, NO_HOLES);
+	int slot;
+	int read = 0;
+	int ret;
+
+	if (!IS_ALIGNED(start, root->sectorsize) ||
+	    !IS_ALIGNED(len, root->sectorsize)) {
+		warning("@start and @len must be aligned to %u for function %s",
+			root->sectorsize, __func__);
+		return -EINVAL;
+	}
+
+	btrfs_init_path(&path);
+	key.objectid = ino;
+	key.offset = start;
+	key.type = BTRFS_EXTENT_DATA_KEY;
+
+	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
+	if (ret < 0)
+		goto out;
+
+	if (ret > 0) {
+		ret = btrfs_previous_item(root, &path, ino,
+					  BTRFS_EXTENT_DATA_KEY);
+		if (ret > 0) {
+			ret = -ENOENT;
+			goto out;
+		}
+	}
+
+	/*
+	 * Reset @dest to all 0, so we don't need to care about holes in
+	 * no_hole mode, but focus on reading non-hole part.
+	 */
+	memset(dest, 0, len);
+	while (1) {
+		struct btrfs_file_extent_item *fi;
+		u64 extent_start;
+		u64 extent_len;
+		u64 read_start;
+		u64 read_len;
+		u64 read_len_ret;
+		u64 disk_bytenr;
+
+		leaf = path.nodes[0];
+		slot = path.slots[0];
+
+		btrfs_item_key_to_cpu(leaf, &key, slot);
+		if (key.objectid > ino)
+			break;
+		if (key.type != BTRFS_EXTENT_DATA_KEY || key.objectid != ino)
+			goto next;
+
+		extent_start = key.offset;
+		if (extent_start >= start + len)
+			break;
+
+		fi = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
+		if (btrfs_file_extent_compression(leaf, fi) !=
+		    BTRFS_COMPRESS_NONE) {
+			ret = -ENOTTY;
+			break;
+		}
+
+		/* Inline extent, one inode should only one inline extent */
+		if (btrfs_file_extent_type(leaf, fi) ==
+		    BTRFS_FILE_EXTENT_INLINE) {
+			extent_len = btrfs_file_extent_inline_len(leaf, slot,
+								  fi);
+			if (extent_start + extent_len <= start)
+				goto next;
+			read_extent_buffer(leaf, dest,
+				btrfs_file_extent_inline_start(fi), extent_len);
+			read += round_up(extent_len, root->sectorsize);
+			break;
+		}
+
+		extent_len = btrfs_file_extent_num_bytes(leaf, fi);
+		if (extent_start + extent_len <= start)
+			goto next;
+
+		read_start = max(start, extent_start);
+		read_len = min(start + len, extent_start + extent_len) -
+			   read_start;
+
+		/* We have already zeroed @dest, nothing to do */
+		if (btrfs_file_extent_type(leaf, fi) ==
+		    BTRFS_FILE_EXTENT_PREALLOC ||
+		    btrfs_file_extent_disk_num_bytes(leaf, fi) == 0) {
+			read += read_len;
+			goto next;
+		}
+
+		disk_bytenr = btrfs_file_extent_disk_bytenr(leaf, fi) +
+			      btrfs_file_extent_offset(leaf, fi);
+		read_len_ret = read_len;
+		ret = read_extent_data(root, dest + read_start - start,
+					disk_bytenr, &read_len_ret, 0);
+		if (ret < 0)
+			break;
+		/* Short read, something went wrong */
+		if (read_len_ret != read_len)
+			return -EIO;
+		read += read_len;
+next:
+		ret = btrfs_next_item(root, &path);
+		if (ret > 0) {
+			ret = 0;
+			break;
+		}
+	}
+
+	/*
+	 * Special trick for no_holes, since for no_holes we don't have good
+	 * method to account skipped and tailling holes, we used
+	 * min(inode size, len) as return value
+	 */
+	if (no_holes) {
+		btrfs_release_path(&path);
+		key.objectid = ino;
+		key.offset = 0;
+		key.type = BTRFS_INODE_ITEM_KEY;
+		ret = btrfs_lookup_inode(NULL, root, &path, &key, 0);
+		if (ret < 0)
+			goto out;
+		if (ret > 0) {
+			ret = -ENOENT;
+			goto out;
+		}
+		ii = btrfs_item_ptr(path.nodes[0], path.slots[0],
+				    struct btrfs_inode_item);
+		isize = round_up(btrfs_inode_size(path.nodes[0], ii),
+				 root->sectorsize);
+		read = min_t(u64, isize - start, len);
+	}
+out:
+	btrfs_release_path(&path);
+	if (!ret)
+		ret = read;
+	return ret;
+}
-- 
2.12.0



