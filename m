Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39516 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752884AbeB0PhX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Feb 2018 10:37:23 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CFD68ACFC
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Feb 2018 15:37:21 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/3] btrfs: Remove root arg from btrfs_log_inode_parent
Date: Tue, 27 Feb 2018 17:37:17 +0200
Message-Id: <1519745838-25584-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1519745838-25584-1-git-send-email-nborisov@suse.com>
References: <1519745838-25584-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_log_inode_parent is called from 2 places (btrfs_log_dentry_safe
and btrfs_log_new_name) both of which pass inode->root as the root
argument and the inode itself. Remove the redundant root argument and
get a reference to the root directly from the inode, also remove
redundant root != inode->root check from the same function. No
functional change.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/tree-log.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 6eb702c8f80b..f6b1795c44ee 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5407,7 +5407,6 @@ static int btrfs_log_all_parents(struct btrfs_trans_handle *trans,
  * the last committed transaction
  */
 static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
-				  struct btrfs_root *root,
 				  struct btrfs_inode *inode,
 				  struct dentry *parent,
 				  const loff_t start,
@@ -5415,6 +5414,7 @@ static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 				  int inode_only,
 				  struct btrfs_log_ctx *ctx)
 {
+	struct btrfs_root *root = inode->root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct super_block *sb;
 	struct dentry *old_parent = NULL;
@@ -5440,7 +5440,7 @@ static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 		goto end_no_trans;
 	}
 
-	if (root != inode->root || btrfs_root_refs(&root->root_item) == 0) {
+	if (btrfs_root_refs(&root->root_item) == 0) {
 		ret = 1;
 		goto end_no_trans;
 	}
@@ -5580,8 +5580,8 @@ int btrfs_log_dentry_safe(struct btrfs_trans_handle *trans,
 	struct dentry *parent = dget_parent(dentry);
 	int ret;
 
-	ret = btrfs_log_inode_parent(trans, root, BTRFS_I(d_inode(dentry)),
-			parent, start, end, LOG_INODE_ALL, ctx);
+	ret = btrfs_log_inode_parent(trans, BTRFS_I(d_inode(dentry)), parent,
+				     start, end, LOG_INODE_ALL, ctx);
 	dput(parent);
 
 	return ret;
@@ -5843,7 +5843,6 @@ int btrfs_log_new_name(struct btrfs_trans_handle *trans,
 			struct dentry *parent)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
-	struct btrfs_root *root = inode->root;
 
 	/*
 	 * this will force the logging code to walk the dentry chain
@@ -5860,7 +5859,7 @@ int btrfs_log_new_name(struct btrfs_trans_handle *trans,
 	    (!old_dir || old_dir->logged_trans <= fs_info->last_trans_committed))
 		return 0;
 
-	return btrfs_log_inode_parent(trans, root, inode, parent, 0,
-				      LLONG_MAX, LOG_INODE_EXISTS, NULL);
+	return btrfs_log_inode_parent(trans, inode, parent, 0, LLONG_MAX,
+				      LOG_INODE_EXISTS, NULL);
 }
 
-- 
2.7.4

