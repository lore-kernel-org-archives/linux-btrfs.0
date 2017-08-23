Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:47372 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753057AbdHWCeB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 22:34:01 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 5993D472278F
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Aug 2017 10:34:02 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Su Yue <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 4/6] btrfs-progs: check: Introduce repair_chunk_item()
Date: Wed, 23 Aug 2017 10:33:48 +0800
Message-ID: <20170823023350.2940-5-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20170823023350.2940-1-lufq.fnst@cn.fujitsu.com>
References: <20170823023350.2940-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Su Yue <suy.fnst@cn.fujitsu.com>

Because this patchset concentrates on repair of extent tree,
repair_chunk_item() now only inserts missed chunk group item into
extent tree.

There are some things left TODO, for example dev_item.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 0f26394..726e330 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -11543,6 +11543,50 @@ out:
 }
 
 /*
+ * Add block group item to the extent tree if @err contains
+ * REFERENCER_MISSING.
+ * TO DO: repair error about dev_item.
+ *
+ * Returns error after repair.
+ */
+static int repair_chunk_item(struct btrfs_trans_handle *trans,
+			     struct btrfs_root *chunk_root,
+			     struct btrfs_path *path, int err)
+{
+	struct btrfs_chunk *chunk;
+	struct btrfs_key chunk_key;
+	struct extent_buffer *eb = path->nodes[0];
+	u64 length;
+	int slot = path->slots[0];
+	u64 type;
+	int ret = 0;
+
+	btrfs_item_key_to_cpu(eb, &chunk_key, slot);
+	if (chunk_key.type != BTRFS_CHUNK_ITEM_KEY)
+		return err;
+	chunk = btrfs_item_ptr(eb, slot, struct btrfs_chunk);
+	type = btrfs_chunk_type(path->nodes[0], chunk);
+	length = btrfs_chunk_length(eb, chunk);
+
+	if (err & REFERENCER_MISSING) {
+		ret = btrfs_make_block_group(trans, chunk_root->fs_info, 0,
+		     type, chunk_key.objectid, chunk_key.offset, length);
+		if (ret) {
+			error("fail to add block group item[%llu %llu]",
+			      chunk_key.offset, length);
+			goto out;
+		} else {
+			err &= ~REFERENCER_MISSING;
+			printf("Added block group item[%llu %llu]\n",
+			       chunk_key.offset, length);
+		}
+	}
+
+out:
+	return err;
+}
+
+/*
  * Check a chunk item.
  * Including checking all referred dev_extents and block group
  */
@@ -11729,6 +11773,8 @@ again:
 		break;
 	case BTRFS_CHUNK_ITEM_KEY:
 		ret = check_chunk_item(fs_info, eb, slot);
+		if (repair && ret)
+			ret = repair_chunk_item(trans, root, path, ret);
 		err |= ret;
 		break;
 	case BTRFS_DEV_EXTENT_KEY:
-- 
2.7.4



