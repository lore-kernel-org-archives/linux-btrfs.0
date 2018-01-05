Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:14657 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751047AbeAELR3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jan 2018 06:17:29 -0500
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Qu Wenruo <quwenruo@cn.fujitsu.com>, Su Yue <suy.fnst@cn.fujitsu.com>
Subject: [v6 03/16] btrfs-progs: csum: Introduce function to read out data csums
Date: Fri, 5 Jan 2018 19:01:11 +0800
Message-ID: <1515150084-17231-4-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1515150084-17231-1-git-send-email-gujx@cn.fujitsu.com>
References: <1515150084-17231-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

Introduce a new function: btrfs_read_data_csums(), to read out csums
for sectors in range.

This is quite useful for read out data csum so we don't need to do it
using open code.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 Makefile     |   2 +-
 csum.c       | 130 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ctree.h      |   4 ++
 kerncompat.h |   3 ++
 utils.h      |   5 +++
 5 files changed, 143 insertions(+), 1 deletion(-)
 create mode 100644 csum.c

diff --git a/Makefile b/Makefile
index 6369e8f4..ab45ab7f 100644
--- a/Makefile
+++ b/Makefile
@@ -106,7 +106,7 @@ objects = ctree.o disk-io.o kernel-lib/radix-tree.o extent-tree.o print-tree.o \
 	  qgroup.o free-space-cache.o kernel-lib/list_sort.o props.o \
 	  kernel-shared/ulist.o qgroup-verify.o backref.o string-table.o task-utils.o \
 	  inode.o file.o find-root.o free-space-tree.o help.o send-dump.o \
-	  fsfeatures.o kernel-lib/tables.o kernel-lib/raid56.o transaction.o
+	  fsfeatures.o kernel-lib/tables.o kernel-lib/raid56.o transaction.o csum.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
diff --git a/csum.c b/csum.c
new file mode 100644
index 00000000..a2ce755e
--- /dev/null
+++ b/csum.c
@@ -0,0 +1,130 @@
+/*
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include "kerncompat.h"
+#include "kernel-lib/bitops.h"
+#include "ctree.h"
+#include "utils.h"
+
+/*
+ * TODO:
+ * 1) Add write support for csum
+ *    So we can write new data extents and add csum into csum tree
+ *
+ * Get csums of range[@start, @start + len).
+ *
+ * @start:    Start offset, shall be aligned to sectorsize.
+ * @len:      Length, shall be aligned to sectorsize.
+ * @csum_ret: The size of csum_ret shall be @len / sectorsize * csum_size.
+ * @bit_map:  Every bit corresponds to the offset have csum or not.
+ *            The size in byte of bit_map should be
+ *            calculate_bitmap_len(csum_ret's size / csum_size).
+ *
+ * Returns 0  means success
+ * Returns >0 means on error
+ * Returns <0 means on fatal error
+ */
+
+int btrfs_read_data_csums(struct btrfs_fs_info *fs_info, u64 start, u64 len,
+			  void *csum_ret, unsigned long *bitmap_ret)
+
+{
+	struct btrfs_path path;
+	struct btrfs_key key;
+	struct btrfs_root *csum_root = fs_info->csum_root;
+	u32 item_offset;
+	u32 item_size;
+	u32 final_offset;
+	u32 final_len;
+	u32 i;
+	u32 sectorsize = fs_info->sectorsize;
+	u16 csum_size = btrfs_super_csum_size(fs_info->super_copy);
+	u64 cur_start;
+	u64 cur_end;
+	int found = 0;
+	int ret;
+
+	ASSERT(IS_ALIGNED(start, sectorsize));
+	ASSERT(IS_ALIGNED(len, sectorsize));
+	ASSERT(csum_ret);
+	ASSERT(bitmap_ret);
+
+	memset(bitmap_ret, 0, calculate_bitmap_len(len / sectorsize));
+	btrfs_init_path(&path);
+
+	key.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
+	key.type = BTRFS_EXTENT_CSUM_KEY;
+	key.offset = start;
+
+	ret = btrfs_search_slot(NULL, csum_root, &key, &path, 0, 0);
+	if (ret < 0)
+		goto out;
+	if (ret > 0) {
+		ret = btrfs_previous_item(csum_root, &path,
+					  BTRFS_EXTENT_CSUM_OBJECTID,
+					  BTRFS_EXTENT_CSUM_KEY);
+		if (ret < 0)
+			goto out;
+	}
+	/* The csum tree may be empty. */
+	if (!btrfs_header_nritems(path.nodes[0]))
+		goto next;
+
+	while (1) {
+		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
+
+		if (!IS_ALIGNED(key.offset, sectorsize)) {
+			error("csum item bytenr %llu is not aligned to %u",
+			      key.offset, sectorsize);
+			ret = -EIO;
+			break;
+		}
+		/* exceeds end */
+		if (key.offset >= start + len)
+			break;
+
+		item_offset = btrfs_item_ptr_offset(path.nodes[0],
+						    path.slots[0]);
+		item_size = btrfs_item_size_nr(path.nodes[0], path.slots[0]);
+
+		if (key.offset + item_size / csum_size * sectorsize < start)
+			goto next;
+
+		/* get start of the extent */
+		cur_start = max(start, key.offset);
+		/* get end of the extent */
+		cur_end = min(start + len, key.offset + item_size / csum_size *
+			      sectorsize);
+
+		final_offset = (cur_start - key.offset) / sectorsize *
+			csum_size + item_offset;
+		final_len = (cur_end - cur_start) / sectorsize * csum_size;
+		read_extent_buffer(path.nodes[0],
+				   (csum_ret + (cur_start - start) /
+				    sectorsize * csum_size),
+				   final_offset, final_len);
+
+		for (i = 0; i != final_len / csum_size; i++)
+			set_bit(i + (cur_start - start) / sectorsize,
+				bitmap_ret);
+
+		found = 1;
+next:
+		ret = btrfs_next_item(csum_root, &path);
+		if (ret)
+			break;
+	}
+out:
+	if (ret >= 0)
+		ret = !found;
+	btrfs_release_path(&path);
+	return ret;
+}
diff --git a/ctree.h b/ctree.h
index b92df1c1..a7d26455 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2761,4 +2761,8 @@ int btrfs_punch_hole(struct btrfs_trans_handle *trans,
 int btrfs_read_file(struct btrfs_root *root, u64 ino, u64 start, int len,
 		    char *dest);
 
+/* csum.c */
+int btrfs_read_data_csums(struct btrfs_fs_info *fs_info, u64 start, u64 len,
+			  void *csum_ret, unsigned long *bitmap_ret);
+
 #endif
diff --git a/kerncompat.h b/kerncompat.h
index fa96715f..4eb62f68 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -273,6 +273,9 @@ static inline int IS_ERR_OR_NULL(const void *ptr)
 #define round_up(x, y) ((((x)-1) | __round_mask(x, y))+1)
 #define round_down(x, y) ((x) & ~__round_mask(x, y))
 
+#define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
+#define DIV_ROUND_UP __KERNEL_DIV_ROUND_UP
+
 /*
  * printk
  */
diff --git a/utils.h b/utils.h
index a82d46f6..5d869a50 100644
--- a/utils.h
+++ b/utils.h
@@ -29,6 +29,7 @@
 #include "sizes.h"
 #include "messages.h"
 #include "ioctl.h"
+#include "kerncompat.h"
 
 #define BTRFS_SCAN_MOUNTED	(1ULL << 0)
 #define BTRFS_SCAN_LBLKID	(1ULL << 1)
@@ -76,6 +77,10 @@ struct seen_fsid {
 	DIR *dirstream;
 	int fd;
 };
+static inline int calculate_bitmap_len(int nsectors)
+{
+	return (DIV_ROUND_UP(nsectors, BITS_PER_LONG) * sizeof(long));
+}
 
 int btrfs_make_root_dir(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root, u64 objectid);
-- 
2.14.3



