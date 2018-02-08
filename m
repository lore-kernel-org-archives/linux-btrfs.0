Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:3171 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752111AbeBHDXX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Feb 2018 22:23:23 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id C6FB048AE768
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Feb 2018 11:23:20 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v4 16/18] btrfs-progs: lowmem check: introduce repair_block_accounting()
Date: Thu, 8 Feb 2018 11:27:35 +0800
Message-ID: <20180208032737.31561-17-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180208032737.31561-1-suy.fnst@cn.fujitsu.com>
References: <20180208032737.31561-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce repair_block_accounting() which calls
btrfs_fix_block_accounting() to repair block group accouting.

Replace btrfs_fix_block_accounting() with the new function.

Note: This patch and next patches cause error in lowmem repair like:
"Error: Commit_root already set when starting transaction".
This error will disappear after removing @trans finished.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 check/mode-lowmem.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index d92278d2993c..40a179f75319 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -537,6 +537,30 @@ static int end_avoid_extents_overwrite(struct btrfs_fs_info *fs_info)
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
  * This function only handles BACKREF_MISSING,
  * If corresponding extent item exists, increase the ref, else insert an extent
@@ -4930,7 +4954,7 @@ out:
 
 		reset_cached_block_groups(fs_info);
 		/* update block accounting */
-		ret = btrfs_fix_block_accounting(trans, root);
+		ret = repair_block_accounting(fs_info);
 		if (ret)
 			err |= ret;
 		else
-- 
2.16.1



