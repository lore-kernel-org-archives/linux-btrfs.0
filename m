Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:56162 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752069AbeC0HHT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 03:07:19 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 3F89748AE76C
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 15:07:10 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 07/10] btrfs-progs: undelete-subvol: introduce btrfs_undelete_intact_subvols
Date: Tue, 27 Mar 2018 15:06:55 +0800
Message-ID: <20180327070658.13064-8-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180327070658.13064-1-lufq.fnst@cn.fujitsu.com>
References: <20180327070658.13064-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function default will traverse the all orphan items on the tree root,
and recover the all intact subvolumes. If subvol_id is specified, then only
the corresponding subvolume will be recovered.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
v2: add subvol_id argumenta to specify subvol_id instead of recovering
all subvolumes.

 undelete-subvol.c | 70 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 undelete-subvol.h |  2 ++
 2 files changed, 72 insertions(+)

diff --git a/undelete-subvol.c b/undelete-subvol.c
index 9243e35545c5..5b494ca086ab 100644
--- a/undelete-subvol.c
+++ b/undelete-subvol.c
@@ -15,6 +15,7 @@
 #include "transaction.h"
 #include "disk-io.h"
 #include "messages.h"
+#include "undelete-subvol.h"
 
 /*
  * Determines whether the subvolume is intact, according to the drop_progress
@@ -182,3 +183,72 @@ static int link_subvol_to_lostfound(struct btrfs_root *root, u64 subvol_id)
 out:
 	return ret;
 }
+
+/*
+ * Traverse all orphan items on the root tree, restore them to the lost+found
+ * directory if the corresponding subvolumes are still intact left on the disk.
+ *
+ * @root	the root of the root tree.
+ * @subvol_id	if not set to 0, skip other subvolumes and only recover the
+ *		subvolume specified by @subvol_id.
+ *
+ * Return 0 if no error occurred even if no subvolume was recovered.
+ */
+int btrfs_undelete_intact_subvols(struct btrfs_root *root, u64 subvol_id)
+{
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
+			break;
+		}
+
+		path.slots[0]--;
+		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
+
+		btrfs_release_path(&path);
+
+		/* No more BTRFS_ORPHAN_ITEM, so we don't need to continue. */
+		if (key.type != BTRFS_ORPHAN_ITEM_KEY) {
+			ret = 0;
+			break;
+		}
+
+		/* If subvol_id is non-zero, skip other deleted subvolume. */
+		if (subvol_id && subvol_id != key.offset) {
+			ret = -ENOENT;
+			break;
+		}
+
+		if (!is_subvol_intact(root, key.offset))
+			continue;
+
+		/* Here we can confirm there is an intact subvolume. */
+		found_count++;
+		ret = link_subvol_to_lostfound(root, key.offset);
+		if (ret == 0) {
+			recovered_count++;
+			printf(
+		"Recovered subvolume %llu to lost+found successfully.\n",
+				key.offset);
+		}
+
+	}
+
+	printf("Found %llu subvols left intact\n", found_count);
+	printf("Recovered %llu subvols\n", found_count);
+
+	return ret;
+}
diff --git a/undelete-subvol.h b/undelete-subvol.h
index 7cfd100cce37..f773210c46fe 100644
--- a/undelete-subvol.h
+++ b/undelete-subvol.h
@@ -14,4 +14,6 @@
 #ifndef __BTRFS_UNDELETE_SUBVOLUME_H__
 #define __BTRFS_UNDELETE_SUBVOLUME_H__
 
+int btrfs_undelete_intact_subvols(struct btrfs_root *root, u64 subvol_id);
+
 #endif
-- 
2.16.2



