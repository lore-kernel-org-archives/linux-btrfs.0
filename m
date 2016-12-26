Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:2344 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751392AbcLZGaL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Dec 2016 01:30:11 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
        by cn.fujitsu.com (Postfix) with ESMTP id 4076C41B4BDF
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Dec 2016 14:29:44 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 08/19] btrfs-progs: csum: Introduce function to read out one data csum
Date: Mon, 26 Dec 2016 14:29:28 +0800
Message-Id: <20161226062939.5841-9-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161226062939.5841-1-quwenruo@cn.fujitsu.com>
References: <20161226062939.5841-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new function: btrfs_read_one_data_csum(), to read out a csum
for a sectorsize.

This is quite useful for read out data csum so we don't need to do it
using open code.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Makefile.in |  2 +-
 csum.c      | 96 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ctree.h     |  3 ++
 3 files changed, 100 insertions(+), 1 deletion(-)
 create mode 100644 csum.c

diff --git a/Makefile.in b/Makefile.in
index c3f0eeda..bb619bfe 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -99,7 +99,7 @@ objects = ctree.o disk-io.o kernel-lib/radix-tree.o extent-tree.o print-tree.o \
 	  qgroup.o free-space-cache.o kernel-lib/list_sort.o props.o \
 	  ulist.o qgroup-verify.o backref.o string-table.o task-utils.o \
 	  inode.o file.o find-root.o free-space-tree.o help.o send-dump.o \
-	  kernel-lib/tables.o kernel-lib/raid56.o
+	  kernel-lib/tables.o kernel-lib/raid56.o csum.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
diff --git a/csum.c b/csum.c
new file mode 100644
index 00000000..53195eaf
--- /dev/null
+++ b/csum.c
@@ -0,0 +1,96 @@
+/*
+ * Copyright (C) 2016 Fujitsu.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#include "ctree.h"
+#include "utils.h"
+/*
+ * TODO:
+ * 1) Add write support for csum
+ *    So we can write new data extents and add csum into csum tree
+ * 2) Add csum range search function
+ *    So we don't need to search csum tree in a per-sectorsize loop.
+ */
+
+int btrfs_read_one_data_csum(struct btrfs_fs_info *fs_info, u64 bytenr,
+			     void *csum_ret)
+{
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	struct btrfs_root *csum_root = fs_info->csum_root;
+	u32 item_offset;
+	u32 item_size;
+	u32 final_offset;
+	u32 sectorsize = fs_info->tree_root->sectorsize;
+	u16 csum_size = btrfs_super_csum_size(fs_info->super_copy);
+	int ret;
+
+	if (!csum_ret) {
+		error("wrong parameter for %s", __func__);
+		return -EINVAL;
+	}
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	key.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
+	key.type = BTRFS_EXTENT_CSUM_KEY;
+	key.offset = bytenr;
+
+	ret = btrfs_search_slot(NULL, csum_root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+	if (ret == 0) {
+		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+		if (!IS_ALIGNED(key.offset, sectorsize)) {
+			error("csum item bytenr %llu is not aligned to %u",
+			      key.offset, sectorsize);
+			ret = -EIO;
+			goto out;
+		}
+		u32 offset = btrfs_item_ptr_offset(path->nodes[0],
+						      path->slots[0]);
+
+		read_extent_buffer(path->nodes[0], csum_ret, offset, csum_size);
+		goto out;
+	}
+	ret = btrfs_previous_item(csum_root, path, BTRFS_EXTENT_CSUM_OBJECTID,
+				  BTRFS_EXTENT_CSUM_KEY);
+	if (ret)
+		goto out;
+	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+	if (!IS_ALIGNED(key.offset, sectorsize)) {
+		error("csum item bytenr %llu is not aligned to %u",
+		      key.offset, sectorsize);
+		ret = -EIO;
+		goto out;
+	}
+	item_offset = btrfs_item_ptr_offset(path->nodes[0], path->slots[0]);
+	item_size = btrfs_item_size_nr(path->nodes[0], path->slots[0]);
+	if (key.offset + item_size / csum_size * sectorsize <= bytenr) {
+		ret = 1;
+		goto out;
+	}
+
+	final_offset = (bytenr - key.offset) / sectorsize * csum_size +
+		       item_offset;
+	read_extent_buffer(path->nodes[0], csum_ret, final_offset, csum_size);
+	ret = 0;
+out:
+	btrfs_free_path(path);
+	return ret;
+};
diff --git a/ctree.h b/ctree.h
index dd02ef86..506b107e 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2798,4 +2798,7 @@ int btrfs_get_extent(struct btrfs_trans_handle *trans,
 int btrfs_punch_hole(struct btrfs_trans_handle *trans,
 		     struct btrfs_root *root,
 		     u64 ino, u64 offset, u64 len);
+/* csum.c */
+int btrfs_read_one_data_csum(struct btrfs_fs_info *fs_info, u64 bytenr,
+			     void *csum_ret);
 #endif
-- 
2.11.0



