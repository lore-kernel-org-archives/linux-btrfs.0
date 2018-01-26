Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:34399 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752400AbeAZIaw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 03:30:52 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 6F87A49F19B1
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 16:30:45 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 01/15] btrfs-progs: lowmem check: introduce repair_inode_item_mismatch()
Date: Fri, 26 Jan 2018 16:35:05 +0800
Message-ID: <20180126083519.28373-2-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

New function repair_inode_item_mismatch() only changes inode item'
filetype.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index f302724dd840..e3505a7f9d6b 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4913,6 +4913,58 @@ static void print_inode_ref_err(struct btrfs_root *root, struct btrfs_key *key,
 		      namebuf, filetype);
 }
 
+/*
+ * Change inode mode.
+ *
+ * Returns 0 means success.
+ * Returns <0 means error.
+ */
+static int repair_inode_item_mismatch(struct btrfs_root *root, u64 ino,
+				      u8 filetype)
+{
+	struct btrfs_key key;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_path path;
+	struct btrfs_inode_item *ii;
+	u32 mode;
+	int ret;
+
+	key.objectid = ino;
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.offset = 0;
+
+	btrfs_init_path(&path);
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		ret = -EIO;
+		goto out;
+	}
+
+	ret = btrfs_search_slot(trans, root, &key, &path, 0, 1);
+	if (ret > 0)
+		ret = -ENOENT;
+	if (ret)
+		goto fail;
+
+	ii = btrfs_item_ptr(path.nodes[0], path.slots[0],
+			    struct btrfs_inode_item);
+	mode = btrfs_inode_mode(path.nodes[0], ii);
+	mode &= ~S_IFMT;
+	mode |= btrfs_type_to_imode(filetype);
+
+	btrfs_set_inode_mode(path.nodes[0], ii, mode);
+	btrfs_mark_buffer_dirty(path.nodes[0]);
+	ret = 0;
+fail:
+	btrfs_commit_transaction(trans, root);
+out:
+	btrfs_release_path(&path);
+	if (ret)
+		error("failed to repair root %llu INODE ITEM[%llu] MISMATCH",
+		      root->objectid, ino);
+	return ret;
+}
+
 /*
  * Insert the missing inode item.
  *
-- 
2.16.1



