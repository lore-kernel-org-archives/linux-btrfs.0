Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:12219 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751936AbeEGDKr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 May 2018 23:10:47 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 9A7C24B314A2
        for <linux-btrfs@vger.kernel.org>; Mon,  7 May 2018 11:10:44 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v3 05/10] btrfs-progs: undelete-subvol: introduce recover_dead_root
Date: Mon, 7 May 2018 11:10:28 +0800
Message-ID: <20180507031033.4125-6-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180507031033.4125-1-lufq.fnst@cn.fujitsu.com>
References: <20180507031033.4125-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function will find the root_item specified by the subvol_id
and clear the BTRFS_ROOT_SUBVOL_DEAD flag.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
V3:
remove btrfs_root argument;
don't modify root_refs.

 ctree.h           |  1 +
 undelete-subvol.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/ctree.h b/ctree.h
index 2ac1eb532986..6e2046145f7c 100644
--- a/ctree.h
+++ b/ctree.h
@@ -186,6 +186,7 @@ static int btrfs_csum_sizes[] = { 4 };
 #define BTRFS_FT_MAX		9
 
 #define BTRFS_ROOT_SUBVOL_RDONLY	(1ULL << 0)
+#define BTRFS_ROOT_SUBVOL_DEAD		(1ULL << 48)
 
 /*
  * the key defines the order in the tree, and so it also defines (optimal)
diff --git a/undelete-subvol.c b/undelete-subvol.c
index 26e156092011..6d3ef19977d6 100644
--- a/undelete-subvol.c
+++ b/undelete-subvol.c
@@ -5,6 +5,8 @@
 
 #include "ctree.h"
 #include "disk-io.h"
+#include "transaction.h"
+#include "messages.h"
 
 /*
  * Determines whether the subvolume is intact, according to the drop_progress
@@ -28,3 +30,52 @@ static bool is_subvol_intact(struct btrfs_fs_info *fs_info, u64 subvol_id)
 	/* the subvolume is intact if the objectid of drop_progress == 0 */
 	return !btrfs_disk_key_objectid(&root->root_item.drop_progress);
 }
+
+/*
+ * Clear BTRFS_ROOT_SUBVOL_DEAD flag.
+ *
+ * @subvol_id	specify the root_item which will be modified.
+ *
+ * Return 0 if no error occurred.
+ */
+static int recover_dead_root(struct btrfs_trans_handle *trans, u64 subvol_id)
+{
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct btrfs_root *root = fs_info->tree_root;
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
+	write_extent_buffer(leaf, &root_item, offset, sizeof(root_item));
+	btrfs_mark_buffer_dirty(leaf);
+
+out:
+	btrfs_release_path(&path);
+	return ret;
+}
-- 
2.17.0



