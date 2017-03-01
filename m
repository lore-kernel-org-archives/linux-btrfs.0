Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45969 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751560AbdCADSF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Feb 2017 22:18:05 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 1F36C4871CE3
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Mar 2017 11:13:18 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo@cn.fujitsu.com>
Subject: [PATCH 14/20] btrfs-progs: cmds-check.c: repair_fs_first_inode
Date: Wed, 1 Mar 2017 11:13:57 +0800
Message-ID: <20170301031403.23902-15-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
References: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce 'repair_fs_first_inode' to repair first inode errors.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 69 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 6dafbd7d..85e87884 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -5506,6 +5506,71 @@ out:
 }
 
 /*
+ * Normal INODE_ITEM_MISSING and INODE_REF_MISSING are handled in backref
+ * dir. Root dir should be handled specially because root dir is the root
+ * of fs.
+ *
+ * returns 0 means success
+ * returns <0 means failure
+ */
+static int repair_fs_first_inode(struct btrfs_root *root, int *err_ret)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_key key;
+	struct btrfs_path path;
+	int filetype = BTRFS_FT_DIR;
+	int ret = 0;
+
+	ASSERT(err_ret);
+	btrfs_init_path(&path);
+
+	if (*err_ret & INODE_REF_MISSING) {
+		key.objectid = BTRFS_FIRST_FREE_OBJECTID;
+		key.type = BTRFS_INODE_REF_KEY;
+		key.offset = BTRFS_FIRST_FREE_OBJECTID;
+
+		trans = btrfs_start_transaction(root, 1);
+		if (IS_ERR(trans))
+			return PTR_ERR(trans);
+
+		btrfs_release_path(&path);
+		ret = btrfs_search_slot(trans, root, &key, &path, 1, 1);
+		if (ret < 0 || !ret)
+			goto out;
+
+		ret = btrfs_insert_inode_ref(trans, root, "..", strlen(".."),
+					     BTRFS_FIRST_FREE_OBJECTID,
+					     BTRFS_FIRST_FREE_OBJECTID, 0);
+		if (ret > 0)
+			ret = -ret;
+		if (ret) {
+			error("Failed to insert first inode ref");
+			goto out;
+		}
+		printf("Add INODE_REF[%llu %llu] name %s",
+		       BTRFS_FIRST_FREE_OBJECTID, BTRFS_FIRST_FREE_OBJECTID,
+		       "..");
+		*err_ret &= ~INODE_REF_MISSING;
+		btrfs_commit_transaction(trans, root);
+	}
+
+	if (*err_ret & INODE_ITEM_MISSING) {
+		ret = repair_inode_item_missing(root,
+						BTRFS_FIRST_FREE_OBJECTID,
+						filetype, *err_ret);
+		if (ret)
+			goto out;
+		*err_ret &= ~INODE_ITEM_MISSING;
+	}
+
+out:
+	if (ret)
+		error("Failed to repair first inode");
+	btrfs_release_path(&path);
+	return ret;
+}
+
+/*
  * check first root dir's inode_item, inde_ref
  *
  * returns 0 means no error
@@ -5560,6 +5625,10 @@ static int check_fs_first_inode(struct btrfs_root *root, unsigned int ext_ref)
 
 out:
 	btrfs_release_path(&path);
+
+	if (err && repair)
+		repair_fs_first_inode(root, &err);
+
 	if (err & (INODE_ITEM_MISSING | INODE_ITEM_MISMATCH))
 		error("root dir INODE_ITEM is %s",
 		      err & INODE_ITEM_MISMATCH ? "mismatch" : "missing");
-- 
2.11.1



