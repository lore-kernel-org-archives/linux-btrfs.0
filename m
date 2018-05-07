Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:45920 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751938AbeEGDKr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 May 2018 23:10:47 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 8B3E14B34D40
        for <linux-btrfs@vger.kernel.org>; Mon,  7 May 2018 11:10:45 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v3 07/10] btrfs-progs: undelete-subvol: introduce btrfs_undelete_subvols
Date: Mon, 7 May 2018 11:10:30 +0800
Message-ID: <20180507031033.4125-8-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180507031033.4125-1-lufq.fnst@cn.fujitsu.com>
References: <20180507031033.4125-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function default will traverse the all orphan items on the tree root,
and recover the all intact subvolumes. If subvol_id is specified, then only
the corresponding subvolume will be recovered.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
V3:
pass btrfs_fs_info instead of btrfs_root;
rename btrfs_undelete_intact_subvols to btrfs_undelete_subvols;
use btrfs_previous_item to iterate.
V2: add subvol_id argument to specify subvol_id instead of recovering
all subvolumes.

 undelete-subvol.c | 70 +++++++++++++++++++++++++++++++++++++++++++++++
 undelete-subvol.h | 11 ++++++++
 2 files changed, 81 insertions(+)
 create mode 100644 undelete-subvol.h

diff --git a/undelete-subvol.c b/undelete-subvol.c
index 9851998ec3df..6b9803d4c590 100644
--- a/undelete-subvol.c
+++ b/undelete-subvol.c
@@ -7,6 +7,7 @@
 #include "disk-io.h"
 #include "transaction.h"
 #include "messages.h"
+#include "undelete-subvol.h"
 
 /*
  * Determines whether the subvolume is intact, according to the drop_progress
@@ -155,3 +156,72 @@ static int link_subvol_to_lostfound(struct btrfs_fs_info *fs_info,
 out:
 	return ret;
 }
+
+/*
+ * Traverse all orphan items on the root tree, restore them to the lost+found
+ * directory if the corresponding subvolumes are still intact left on the disk.
+ *
+ * @subvol_id	if not set to 0, skip other subvolumes and only recover the
+ *		subvolume specified by @subvol_id.
+ *
+ * Return 0 if no error occurred even if no subvolume was recovered.
+ */
+int btrfs_undelete_subvols(struct btrfs_fs_info *fs_info, u64 subvol_id)
+{
+	struct btrfs_root *root = fs_info->tree_root;
+	struct btrfs_key key;
+	struct btrfs_path path;
+	u64 found_count = 0;
+	u64 recovered_count = 0;
+	int ret = 0;
+
+	key.objectid = BTRFS_ORPHAN_OBJECTID;
+	key.type = BTRFS_ORPHAN_ITEM_KEY;
+	key.offset = subvol_id ? subvol_id + 1 : (u64)-1;
+
+	btrfs_init_path(&path);
+	while (subvol_id != key.offset) {
+		ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
+		if (ret < 0) {
+			error("search ORPHAN_ITEM for %llu failed.\n",
+			      key.offset);
+			btrfs_release_path(&path);
+			break;
+		}
+
+		ret = btrfs_previous_item(root, &path, BTRFS_ORPHAN_OBJECTID,
+					  BTRFS_ORPHAN_ITEM_KEY);
+		if (ret) {
+			btrfs_release_path(&path);
+			break;
+		}
+
+		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
+		btrfs_release_path(&path);
+
+		/* If subvol_id is non-zero, skip other deleted subvolume. */
+		if (subvol_id && subvol_id != key.offset) {
+			ret = -ENOENT;
+			break;
+		}
+
+		if (!is_subvol_intact(fs_info, key.offset))
+			continue;
+
+		/* Here we can confirm there is an intact subvolume. */
+		found_count++;
+		ret = link_subvol_to_lostfound(fs_info, key.offset);
+		if (ret == 0) {
+			recovered_count++;
+			printf(
+		"Recovered subvolume %llu to lost+found successfully.\n",
+				key.offset);
+		}
+
+	}
+
+	printf("Found %llu deleted subvols left intact\n", found_count);
+	printf("Recovered %llu deleted subvols\n", found_count);
+
+	return ret;
+}
diff --git a/undelete-subvol.h b/undelete-subvol.h
new file mode 100644
index 000000000000..a98d8ab90cea
--- /dev/null
+++ b/undelete-subvol.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2018 Fujitsu.  All rights reserved.
+ */
+
+#ifndef __BTRFS_UNDELETE_SUBVOLUME_H__
+#define __BTRFS_UNDELETE_SUBVOLUME_H__
+
+int btrfs_undelete_subvols(struct btrfs_fs_info *fs_info, u64 subvol_id);
+
+#endif
-- 
2.17.0



