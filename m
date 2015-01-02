Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:38705 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750714AbbABHOg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Jan 2015 02:14:36 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t027E2nR008893
	for <linux-btrfs@vger.kernel.org>; Fri, 2 Jan 2015 15:14:03 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 2/5] btrfs-progs: Add btrfs_get_extent() and btrfs_punch_hole().
Date: Fri, 2 Jan 2015 15:12:30 +0800
Message-ID: <1420182753-2724-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1420182753-2724-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1420182753-2724-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add btrfs_get_extent() and btrfs_punch_hole() for btrfs-progs.

Btrfs_get_extent() will act much like kernel one, return the first
extent that covers the given range.
The difference will be that progs btrfs_get_extent() can't handle
no-holes feature, which means caller should handle it carefully.

Btrfs_punch_hole() will punch a hole in given range of given inode,
however it differs from kernel one since it won't zero any page or drop
any extents if there is any extent in the hole range.

These functions are mainly used for later I_ERR_FILE_EXTENT_DISCOUNT
repair function.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
Changelog:
v2:
   None
---
 Makefile |   2 +-
 ctree.h  |   9 ++++
 file.c   | 162 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 172 insertions(+), 1 deletion(-)
 create mode 100644 file.c

diff --git a/Makefile b/Makefile
index 8b843bb..e14959e 100644
--- a/Makefile
+++ b/Makefile
@@ -12,7 +12,7 @@ objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  extent-cache.o extent_io.o volumes.o utils.o repair.o \
 	  qgroup.o raid6.o free-space-cache.o list_sort.o props.o \
 	  ulist.o qgroup-verify.o backref.o string-table.o task-utils.o \
-	  inode.o
+	  inode.o file.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
diff --git a/ctree.h b/ctree.h
index 0963fc0..5dbc767 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2468,4 +2468,13 @@ int btrfs_add_orphan_item(struct btrfs_trans_handle *trans,
 			  u64 ino);
 int btrfs_mkdir(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		char *name, int namelen, u64 parent_ino, u64 *ino, int mode);
+
+/* file.c */
+int btrfs_get_extent(struct btrfs_trans_handle *trans,
+		     struct btrfs_root *root,
+		     struct btrfs_path *path,
+		     u64 ino, u64 offset, u64 len, int ins_len);
+int btrfs_punch_hole(struct btrfs_trans_handle *trans,
+		     struct btrfs_root *root,
+		     u64 ino, u64 offset, u64 len);
 #endif
diff --git a/file.c b/file.c
new file mode 100644
index 0000000..0e9253e
--- /dev/null
+++ b/file.c
@@ -0,0 +1,162 @@
+/*
+ * Copyright (C) 2014 Fujitsu.  All rights reserved.
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
+#include <sys/stat.h>
+#include "ctree.h"
+#include "transaction.h"
+#include "kerncompat.h"
+
+/*
+ * Get the first file extent that covers (part of) the given range
+ * Unlike kernel using extent_map to handle hole even no-hole is enabled,
+ * progs don't have such infrastructure, so caller should do extra care
+ * for no-hole.
+ *
+ * return 0 for found, and path points to the file extent.
+ * return >0 for not found, and path points to the insert position.
+ * return <0 for error.
+ */
+int btrfs_get_extent(struct btrfs_trans_handle *trans,
+		     struct btrfs_root *root,
+		     struct btrfs_path *path,
+		     u64 ino, u64 offset, u64 len, int ins_len)
+{
+	struct btrfs_key key;
+	struct btrfs_key found_key;
+	struct btrfs_file_extent_item *fi_item;
+	u64 end = 0;
+	int ret = 0;
+	int not_found = 1;
+
+	key.objectid = ino;
+	key.type = BTRFS_EXTENT_DATA_KEY;
+	key.offset = offset;
+
+	ret = btrfs_search_slot(trans, root, &key, path, ins_len,
+				ins_len ? 1 : 0);
+	if (ret <= 0)
+		goto out;
+	if (ret > 0) {
+		/* Check preivous file extent */
+		ret = btrfs_previous_item(root, path, ino,
+					  BTRFS_EXTENT_DATA_KEY);
+		if (ret < 0)
+			goto out;
+		if (ret > 0)
+			goto check_next;
+	}
+	btrfs_item_key_to_cpu(path->nodes[0], &found_key, path->slots[0]);
+	if (found_key.objectid != ino ||
+	    found_key.type != BTRFS_EXTENT_DATA_KEY)
+		goto check_next;
+
+	fi_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
+				 struct btrfs_file_extent_item);
+	end = found_key.offset +
+	      btrfs_file_extent_ram_bytes(path->nodes[0], fi_item);
+	/*
+	 * existing file extent
+	 * |--------|	  |----|
+	 *      |-------|
+	 *      offset + len
+	 * OR
+	 * |---------------|
+	 *	|-------|
+	 */
+	if (end > offset) {
+		not_found = 0;
+		goto out;
+	}
+check_next:
+	ret = btrfs_next_item(root, path);
+	if (ret)
+		goto out;
+
+	btrfs_item_key_to_cpu(path->nodes[0], &found_key, path->slots[0]);
+	if (found_key.objectid != ino ||
+	    found_key.type != BTRFS_EXTENT_DATA_KEY) {
+		ret = 1;
+		goto out;
+	}
+	if (found_key.offset < offset + len)
+		/*
+		 * existing file extent
+		 * |---|	|------|
+		 *	|-------|
+		 *	offset + len
+		 */
+		not_found = 0;
+	else
+		/*
+		 * existing file extent
+		 * |----|		|----|
+		 *		|----|
+		 *		offset + len
+		 */
+		not_found = 1;
+
+	/*
+	 * To keep the search hehavior consistent with search_slot(),
+	 * we need to go back to the prev leaf's nritem slot if
+	 * we are at the first slot of the leaf.
+	 */
+	if (path->slots[0] == 0) {
+		ret = btrfs_prev_leaf(root, path);
+		/* Not possible */
+		if (ret)
+			goto out;
+		path->slots[0] = btrfs_header_nritems(path->nodes[0]);
+	}
+
+out:
+	if (ret == 0)
+		ret = not_found;
+	return ret;
+}
+
+/*
+ * Punch hole ranged [offset,len) for the file given by ino and root.
+ *
+ * Unlink kernel punch_hole, which will not zero/free existing extent,
+ * instead it will return -EEXIST if there is any extents in the hole
+ * range.
+ */
+int btrfs_punch_hole(struct btrfs_trans_handle *trans,
+		     struct btrfs_root *root,
+		     u64 ino, u64 offset, u64 len)
+{
+	struct btrfs_path *path;
+	int ret = 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	ret = btrfs_get_extent(NULL, root, path, ino, offset, len, 0);
+	if (ret < 0)
+		goto out;
+	if (ret == 0) {
+		ret = -EEXIST;
+		goto out;
+	}
+
+	ret = btrfs_insert_file_extent(trans, root, ino, offset, 0, 0, len);
+out:
+	btrfs_free_path(path);
+	return ret;
+}
-- 
2.2.1

