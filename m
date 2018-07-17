Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:55220 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728983AbeGQJaF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jul 2018 05:30:05 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 4B3834B5CF46
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jul 2018 16:58:31 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: qgroup: cleanup the unused srcroot from btrfs_qgroup_inherit
Date: Tue, 17 Jul 2018 16:58:22 +0800
Message-ID: <20180717085822.21670-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since commit 0b246afa62b0 ("btrfs: root->fs_info cleanup, add fs_info
convenience variables"), the srcroot is no longer used to get fs_fino.
In fact, it can be dropped after commit 707e8a071528 ("btrfs: use nodesize
everywhere, kill leafsize").

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 52e05f031ee3..06e0e9b39340 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2286,22 +2286,6 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto out;
 
-	if (srcid) {
-		struct btrfs_root *srcroot;
-		struct btrfs_key srckey;
-
-		srckey.objectid = srcid;
-		srckey.type = BTRFS_ROOT_ITEM_KEY;
-		srckey.offset = (u64)-1;
-		srcroot = btrfs_read_fs_root_no_name(fs_info, &srckey);
-		if (IS_ERR(srcroot)) {
-			ret = PTR_ERR(srcroot);
-			goto out;
-		}
-
-		level_size = fs_info->nodesize;
-	}
-
 	/*
 	 * add qgroup to all inherited groups
 	 */
@@ -2358,6 +2342,7 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 		 * our counts don't go crazy, so at this point the only
 		 * difference between the two roots should be the root node.
 		 */
+		level_size = fs_info->nodesize;
 		dstgroup->rfer = srcgroup->rfer;
 		dstgroup->rfer_cmpr = srcgroup->rfer_cmpr;
 		dstgroup->excl = level_size;
-- 
2.18.0



