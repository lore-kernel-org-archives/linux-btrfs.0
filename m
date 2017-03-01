Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:57673 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751592AbdCADSC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Feb 2017 22:18:02 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 986694871CE1
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Mar 2017 11:13:18 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo@cn.fujitsu.com>
Subject: [PATCH 15/20] btrfs-progs: cmds-check.c: introduce repair_ternary_lowmem
Date: Wed, 1 Mar 2017 11:13:58 +0800
Message-ID: <20170301031403.23902-16-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
References: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce 'repair_ternary_lowmem' to repair error while checking
dir_item/index, inode_ref by the rule:
1. If two of three is missing or mismatched, delete the existed one.
2. If one of three is missing or mismatched, add the missing one.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 85e87884..9a76107e 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4388,6 +4388,63 @@ static void print_inode_ref_err(struct btrfs_root *root, struct btrfs_key *key,
 		       namebuf, filetype);
 }
 
+static int repair_inode_item_missing(struct btrfs_root *root, u64 ino,
+				     u8 filetype, int err);
+/*
+ * The ternary contains dir item, dir index and relative inode ref.
+ * the repair function will handle errs: INODE_MISSING, DIR_INDEX_MISSING
+ * DIR_INDEX_MISMATCH, DIR_ITEM_MISSING, DIR_ITEM_MISMATCH by the follow
+ * strategy:
+ * If two of three is missing or mismatched, delete the existed one.
+ * If one of three is missing or mismatched, add the missing one.
+ *
+ * returns 0 mens success.
+ */
+int repair_ternary_lowmem(struct btrfs_root *root, u64 dir_ino, u64 ino,
+			  u64 index, char *name, int name_len, u8 filetype,
+			  int err)
+{
+	struct btrfs_trans_handle *trans;
+	int stage = 0;
+	int ret;
+
+	if (!err)
+		return 0;
+	/*
+	 * stage shall be one of follow valild values:
+	 *	0: Fine, nothing to do.
+	 *	1: One of three is wrong, so add missing one.
+	 *	2: Two of three is wrong, so delete existed one.
+	 */
+	if (err & (DIR_INDEX_MISMATCH | DIR_INDEX_MISSING))
+		++stage;
+	if (err & (DIR_ITEM_MISMATCH | DIR_ITEM_MISSING))
+		++stage;
+	if (err & (INODE_REF_MISSING))
+		++stage;
+
+	/* stage must be smllarer than 3 */
+	ASSERT(stage < 3);
+
+	trans = btrfs_start_transaction(root, 2);
+	if (stage == 2) {
+		ret = btrfs_unlink(trans, root, ino, dir_ino, index, name,
+				   name_len, 0);
+		if (ret)
+			goto out;
+	}
+	if (stage == 1) {
+		ret = btrfs_add_link(trans, root, ino, dir_ino, name, name_len,
+			       filetype, &index, 1, 1);
+		if (ret)
+			goto out;
+	}
+
+	btrfs_commit_transaction(trans, root);
+out:
+	return ret;
+}
+
 /*
  * Traverse the given INODE_REF and call find_dir_item() to find related
  * DIR_ITEM/DIR_INDEX.If repair is enable, research @ref_key and
-- 
2.11.1



