Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:33627 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751873AbeBBI2J (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Feb 2018 03:28:09 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 5A97D49F19B7
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Feb 2018 16:28:04 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 07/10] btrfs-progs: undelete-subvol: introduce btrfs_undelete_intact_subvols
Date: Fri, 2 Feb 2018 16:27:48 +0800
Message-ID: <20180202082751.26225-8-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180202082751.26225-1-lufq.fnst@cn.fujitsu.com>
References: <20180202082751.26225-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function will traverse the all orphan items on the tree root, and
recover the all intact subvolumes.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 undelete-subvol.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 undelete-subvol.h |  2 ++
 2 files changed, 62 insertions(+)

diff --git a/undelete-subvol.c b/undelete-subvol.c
index 9243e35545c5..b0852510a5c2 100644
--- a/undelete-subvol.c
+++ b/undelete-subvol.c
@@ -15,6 +15,7 @@
 #include "transaction.h"
 #include "disk-io.h"
 #include "messages.h"
+#include "undelete-subvol.h"
 
 /*
  * Determines whether the subvolume is intact, according to the drop_progress
@@ -182,3 +183,62 @@ static int link_subvol_to_lostfound(struct btrfs_root *root, u64 subvol_id)
 out:
 	return ret;
 }
+
+/*
+ * Traverse all orphan items on the root tree, restore them to the lost+found
+ * directory if the corresponding subvolumes are still intact left on the disk.
+ *
+ * @root	the root of the root tree.
+ *
+ * Return 0 if no error occurred.
+ */
+int btrfs_undelete_intact_subvols(struct btrfs_root *root)
+{
+	struct btrfs_key key;
+	struct btrfs_path path;
+	u64 found_count = 0;
+	u64 recovered_count = 0;
+	int ret;
+
+	key.objectid = BTRFS_ORPHAN_OBJECTID;
+	key.type = BTRFS_ORPHAN_ITEM_KEY;
+	key.offset = (u64)-1;
+
+	btrfs_init_path(&path);
+	while (1) {
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
+		/* No more BTRFS_ORPHAN_ITEM, so we don't need to continue. */
+		if (key.type != BTRFS_ORPHAN_ITEM_KEY) {
+			ret = 0;
+			break;
+		}
+
+		if (is_subvol_intact(root, key.offset)) {
+			/* Here we can confirm there is an intact subvolume. */
+			found_count++;
+			ret = link_subvol_to_lostfound(root, key.offset);
+			if (ret == 0) {
+				recovered_count++;
+				printf(
+		"Recovered subvolume %llu to lost+found successfully.\n",
+					key.offset);
+			}
+		}
+
+		btrfs_release_path(&path);
+	}
+
+	printf("Found %llu subvols left intact\n", found_count);
+	printf("Recovered %llu subvols\n", found_count);
+	btrfs_release_path(&path);
+	return ret;
+}
diff --git a/undelete-subvol.h b/undelete-subvol.h
index 7cfd100cce37..5ceb034beaf3 100644
--- a/undelete-subvol.h
+++ b/undelete-subvol.h
@@ -14,4 +14,6 @@
 #ifndef __BTRFS_UNDELETE_SUBVOLUME_H__
 #define __BTRFS_UNDELETE_SUBVOLUME_H__
 
+int btrfs_undelete_intact_subvols(struct btrfs_root *root);
+
 #endif
-- 
2.16.1



