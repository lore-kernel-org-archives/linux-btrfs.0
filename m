Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:19727 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932107AbeAKHb0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 02:31:26 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 3289049F5B38
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 15:31:25 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v3 16/17] btrfs-progs: lowmem check: introduce repair_block_accounting()
Date: Thu, 11 Jan 2018 15:35:10 +0800
Message-ID: <20180111073511.25288-17-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180111073511.25288-1-suy.fnst@cn.fujitsu.com>
References: <20180111073511.25288-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce repair_block_accounting() which calls
btrfs_fix_block_accounting() to repair block group accouting.

Replace btrfs_fix_block_accounting() with the new function.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 1c93b1178b23..4d6245fa909b 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -13775,6 +13775,30 @@ static int try_avoid_extents_overwrite(struct btrfs_fs_info *fs_info)
 	return ret;
 }
 
+/*
+ * Wrapper function for btrfs_fix_block_accounting().
+ *
+ * Returns 0     on success.
+ * Returns != 0  on error.
+ */
+static int repair_block_accounting(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_trans_handle *trans = NULL;
+	struct btrfs_root *root = fs_info->extent_root;
+	int ret;
+
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		error("fail to start transaction %s", strerror(-ret));
+		return ret;
+	}
+
+	ret = btrfs_fix_block_accounting(trans, root);
+	btrfs_commit_transaction(trans, root);
+	return ret;
+}
+
 /*
  * Low memory usage version check_chunks_and_extents.
  */
@@ -13861,7 +13885,7 @@ out:
 		modify_block_groups_cache(fs_info, BTRFS_BLOCK_GROUP_METADATA,
 					  0);
 
-		ret = btrfs_fix_block_accounting(trans, root);
+		ret = repair_block_accounting(fs_info);
 		if (ret)
 			err |= ret;
 		else
-- 
2.15.1



