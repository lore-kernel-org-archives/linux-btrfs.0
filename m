Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:32429 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751048AbeC0HHK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 03:07:10 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 5016F48AE772
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 15:07:09 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 05/10] btrfs-progs: undelete-subvol: introduce recover_dead_root
Date: Tue, 27 Mar 2018 15:06:53 +0800
Message-ID: <20180327070658.13064-6-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180327070658.13064-1-lufq.fnst@cn.fujitsu.com>
References: <20180327070658.13064-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function will find the root_item specified by the subvol_id,
clear the BTRFS_ROOT_SUBVOL_DEAD flag and set root_refs to one.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 ctree.h           |  1 +
 undelete-subvol.c | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/ctree.h b/ctree.h
index 4bff0b821472..7c0b8150bc4e 100644
--- a/ctree.h
+++ b/ctree.h
@@ -184,6 +184,7 @@ static int btrfs_csum_sizes[] = { 4 };
 #define BTRFS_FT_MAX		9
 
 #define BTRFS_ROOT_SUBVOL_RDONLY	(1ULL << 0)
+#define BTRFS_ROOT_SUBVOL_DEAD		(1ULL << 48)
 
 /*
  * the key defines the order in the tree, and so it also defines (optimal)
diff --git a/undelete-subvol.c b/undelete-subvol.c
index 00fcc4895778..781057df2b84 100644
--- a/undelete-subvol.c
+++ b/undelete-subvol.c
@@ -12,6 +12,9 @@
  */
 
 #include "ctree.h"
+#include "transaction.h"
+#include "disk-io.h"
+#include "messages.h"
 
 /*
  * Determines whether the subvolume is intact, according to the drop_progress
@@ -51,3 +54,55 @@ out:
 	btrfs_release_path(&path);
 	return ret;
 }
+
+/*
+ * Clear BTRFS_ROOT_SUBVOL_DEAD flag and set the root_refs to one.
+ *
+ * @root	the root of root tree.
+ * @subvol_id	specify the root_item which will be modified.
+ *
+ * Return 0 if no error occurred.
+ */
+static int recover_dead_root(struct btrfs_trans_handle *trans,
+			     struct btrfs_root *root, u64 subvol_id)
+{
+	struct btrfs_key key;
+	struct btrfs_path path;
+	struct extent_buffer *leaf;
+	struct btrfs_root_item root_item;
+	u64 root_flags;
+	u64 offset;
+	int ret;
+
+	key.objectid = subvol_id;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = 0;
+
+	btrfs_init_path(&path);
+	ret = btrfs_search_slot(trans, root, &key, &path, 0, 0);
+	if (ret) {
+		error("couldn't find ROOT_ITEM for %llu failed: %d",
+				subvol_id, ret);
+		goto out;
+	}
+
+	leaf = path.nodes[0];
+
+	offset = btrfs_item_ptr_offset(leaf, path.slots[0]);
+	read_extent_buffer(leaf, &root_item, offset, sizeof(root_item));
+
+	/* Clear BTRFS_ROOT_SUBVOL_DEAD */
+	root_flags = btrfs_root_flags(&root_item);
+	btrfs_set_root_flags(&root_item,
+			     root_flags & ~BTRFS_ROOT_SUBVOL_DEAD);
+
+	/* Increase the refs */
+	btrfs_set_root_refs(&root_item, 1);
+
+	write_extent_buffer(leaf, &root_item, offset, sizeof(root_item));
+	btrfs_mark_buffer_dirty(leaf);
+
+out:
+	btrfs_release_path(&path);
+	return ret;
+}
-- 
2.16.2



