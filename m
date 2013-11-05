Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28553 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab3KEDqS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Nov 2013 22:46:18 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH v2] Btrfs: avoid heavy operations in btrfs_commit_super
Date: Tue,  5 Nov 2013 11:45:53 +0800
Message-Id: <1383623153-5861-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The 'git blame' history shows that, the old transaction commit code has to do
twice to ensure roots are updated and we have to flush metadata and super block
manually, however, right now all of these can be handled well inside
the transaction commit code without extra efforts.

And the error handling part remains same with the current code, -- 'return to
caller once we get error'.

This saves us a transaction commit and a flush of super block, which are both
heavy operations according to ftrace output analysis.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: remove @ret that is no longer used, thanks Stefan.

 fs/btrfs/disk-io.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 62176ad..e161740 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3528,7 +3528,6 @@ int btrfs_cleanup_fs_roots(struct btrfs_fs_info *fs_info)
 int btrfs_commit_super(struct btrfs_root *root)
 {
 	struct btrfs_trans_handle *trans;
-	int ret;
 
 	mutex_lock(&root->fs_info->cleaner_mutex);
 	btrfs_run_delayed_iputs(root);
@@ -3542,25 +3541,7 @@ int btrfs_commit_super(struct btrfs_root *root)
 	trans = btrfs_join_transaction(root);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
-	ret = btrfs_commit_transaction(trans, root);
-	if (ret)
-		return ret;
-	/* run commit again to drop the original snapshot */
-	trans = btrfs_join_transaction(root);
-	if (IS_ERR(trans))
-		return PTR_ERR(trans);
-	ret = btrfs_commit_transaction(trans, root);
-	if (ret)
-		return ret;
-	ret = btrfs_write_and_wait_transaction(NULL, root);
-	if (ret) {
-		btrfs_error(root->fs_info, ret,
-			    "Failed to sync btree inode to disk.");
-		return ret;
-	}
-
-	ret = write_ctree_super(NULL, root, 0);
-	return ret;
+	return btrfs_commit_transaction(trans, root);
 }
 
 int close_ctree(struct btrfs_root *root)
-- 
1.8.2.1

