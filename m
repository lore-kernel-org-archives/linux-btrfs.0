Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:36999 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751932AbeEVRrZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 13:47:25 -0400
Received: by mail-qt0-f194.google.com with SMTP id q13-v6so24532759qtp.4
        for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2018 10:47:25 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH 1/2] btrfs: kill btrfs_write_inode
Date: Tue, 22 May 2018 13:47:22 -0400
Message-Id: <20180522174723.13620-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

We don't actually need this.  It used to be in place for O_SYNC writes,
but we've used the normal fsync() path for that for years now.  The
other case we hit this is through sync(), which will commit the
transaction anyway.  All this does is make us commit the transaction a
bunch for no reason, and it could deadlock with delayed iput's.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/inode.c | 26 --------------------------
 fs/btrfs/super.c |  1 -
 2 files changed, 27 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 92b629212c81..5d47206604ca 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6263,32 +6263,6 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 	return ret;
 }
 
-int btrfs_write_inode(struct inode *inode, struct writeback_control *wbc)
-{
-	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct btrfs_trans_handle *trans;
-	int ret = 0;
-	bool nolock = false;
-
-	if (test_bit(BTRFS_INODE_DUMMY, &BTRFS_I(inode)->runtime_flags))
-		return 0;
-
-	if (btrfs_fs_closing(root->fs_info) &&
-			btrfs_is_free_space_inode(BTRFS_I(inode)))
-		nolock = true;
-
-	if (wbc->sync_mode == WB_SYNC_ALL) {
-		if (nolock)
-			trans = btrfs_join_transaction_nolock(root);
-		else
-			trans = btrfs_join_transaction(root);
-		if (IS_ERR(trans))
-			return PTR_ERR(trans);
-		ret = btrfs_commit_transaction(trans);
-	}
-	return ret;
-}
-
 /*
  * This is somewhat expensive, updating the tree every time the
  * inode changes.  But, it is most likely to find the inode in cache.
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 4a584a7ad371..0a4fb69e0ddf 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2331,7 +2331,6 @@ static const struct super_operations btrfs_super_ops = {
 	.sync_fs	= btrfs_sync_fs,
 	.show_options	= btrfs_show_options,
 	.show_devname	= btrfs_show_devname,
-	.write_inode	= btrfs_write_inode,
 	.alloc_inode	= btrfs_alloc_inode,
 	.destroy_inode	= btrfs_destroy_inode,
 	.statfs		= btrfs_statfs,
-- 
2.14.3

