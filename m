Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:56801 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751920AbeEGDKq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 May 2018 23:10:46 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 0E9774B31495
        for <linux-btrfs@vger.kernel.org>; Mon,  7 May 2018 11:10:44 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v3 04/10] btrfs-progs: undelete-subvol: introduce is_subvol_intact
Date: Mon, 7 May 2018 11:10:27 +0800
Message-ID: <20180507031033.4125-5-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180507031033.4125-1-lufq.fnst@cn.fujitsu.com>
References: <20180507031033.4125-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function is used to determine whether the subvolume is intact.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
V3:
add SPDX-License-Identifier;
pass btrfs_fs_info instead of btrfs_root;
use btrfs_read_fs_root instead of manually search;
remove empty header file.

 Makefile          |  3 ++-
 undelete-subvol.c | 30 ++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 1 deletion(-)
 create mode 100644 undelete-subvol.c

diff --git a/Makefile b/Makefile
index cbd855336b2f..6a425e3a65dd 100644
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
index 000000000000..26e156092011
--- /dev/null
+++ b/undelete-subvol.c
@@ -0,0 +1,30 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2018 Fujitsu.  All rights reserved.
+ */
+
+#include "ctree.h"
+#include "disk-io.h"
+
+/*
+ * Determines whether the subvolume is intact, according to the drop_progress
+ * of the root item specified by @subvol_id.
+ *
+ * Return true if the subvolume is intact, otherwise return false.
+ */
+static bool is_subvol_intact(struct btrfs_fs_info *fs_info, u64 subvol_id)
+{
+	struct btrfs_key key;
+	struct btrfs_root *root;
+
+	key.objectid = subvol_id;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = -1;
+
+	root = btrfs_read_fs_root(fs_info, &key);
+	if (IS_ERR(root))
+		return false;
+
+	/* the subvolume is intact if the objectid of drop_progress == 0 */
+	return !btrfs_disk_key_objectid(&root->root_item.drop_progress);
+}
-- 
2.17.0



