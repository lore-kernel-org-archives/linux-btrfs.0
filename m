Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:32429 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751938AbeC0HHQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 03:07:16 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id CD49648AE76D
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 15:07:08 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 04/10] btrfs-progs: undelete-subvol: introduce is_subvol_intact
Date: Tue, 27 Mar 2018 15:06:52 +0800
Message-ID: <20180327070658.13064-5-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180327070658.13064-1-lufq.fnst@cn.fujitsu.com>
References: <20180327070658.13064-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function is used to determine whether the subvolume is intact.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 Makefile          |  3 ++-
 undelete-subvol.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 undelete-subvol.h | 17 +++++++++++++++++
 3 files changed, 72 insertions(+), 1 deletion(-)
 create mode 100644 undelete-subvol.c
 create mode 100644 undelete-subvol.h

diff --git a/Makefile b/Makefile
index 6065522a615f..cb38984c7386 100644
--- a/Makefile
+++ b/Makefile
@@ -116,7 +116,8 @@ objects = ctree.o disk-io.o kernel-lib/radix-tree.o extent-tree.o print-tree.o \
 	  qgroup.o free-space-cache.o kernel-lib/list_sort.o props.o \
 	  kernel-shared/ulist.o qgroup-verify.o backref.o string-table.o task-utils.o \
 	  inode.o file.o find-root.o free-space-tree.o help.o send-dump.o \
-	  fsfeatures.o kernel-lib/tables.o kernel-lib/raid56.o transaction.o
+	  fsfeatures.o kernel-lib/tables.o kernel-lib/raid56.o transaction.o \
+	  undelete-subvol.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o check/main.o \
diff --git a/undelete-subvol.c b/undelete-subvol.c
new file mode 100644
index 000000000000..00fcc4895778
--- /dev/null
+++ b/undelete-subvol.c
@@ -0,0 +1,53 @@
+/*
+ * Copyright (C) 2018 Fujitsu.  All rights reserved.
+ *
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
+#include "ctree.h"
+
+/*
+ * Determines whether the subvolume is intact, according to the drop_progress
+ * of the root item specified by subvol_id.
+ *
+ * Return true if the subvolume is intact, otherwise return false.
+ */
+static bool is_subvol_intact(struct btrfs_root *root, u64 subvol_id)
+{
+	struct btrfs_path path;
+	struct btrfs_key key;
+	struct extent_buffer *leaf;
+	struct btrfs_root_item root_item;
+	u64 offset;
+	int ret;
+
+	key.objectid = subvol_id;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = 0;
+
+	btrfs_init_path(&path);
+	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
+	if (ret) {
+		ret = false;
+		goto out;
+	}
+
+	leaf = path.nodes[0];
+	offset = btrfs_item_ptr_offset(leaf, path.slots[0]);
+
+	read_extent_buffer(leaf, &root_item, offset, sizeof(root_item));
+
+	/* the subvolume is intact if the objectid of drop_progress == 0 */
+	ret = btrfs_disk_key_objectid(&root_item.drop_progress) ? false : true;
+
+out:
+	btrfs_release_path(&path);
+	return ret;
+}
diff --git a/undelete-subvol.h b/undelete-subvol.h
new file mode 100644
index 000000000000..7cfd100cce37
--- /dev/null
+++ b/undelete-subvol.h
@@ -0,0 +1,17 @@
+/*
+ * Copyright (C) 2018 Fujitsu.  All rights reserved.
+ *
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
+#ifndef __BTRFS_UNDELETE_SUBVOLUME_H__
+#define __BTRFS_UNDELETE_SUBVOLUME_H__
+
+#endif
-- 
2.16.2



