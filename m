Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34231 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934257AbdBQOoS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:44:18 -0500
Received: by mail-wm0-f68.google.com with SMTP id c85so2932563wmi.1
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:44:18 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 31/38] btrfs: Make check_parent_dirs_for_sync take btrfs_inode
Date: Fri, 17 Feb 2017 16:43:22 +0200
Message-Id: <1487342609-20652-32-git-send-email-nborisov@suse.com>
In-Reply-To: <1487342609-20652-1-git-send-email-nborisov@suse.com>
References: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/tree-log.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 610fe04805b6..cc616d424b7a 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5050,14 +5050,14 @@ static bool btrfs_must_commit_transaction(struct btrfs_trans_handle *trans,
  * a full commit is required.
  */
 static noinline int check_parent_dirs_for_sync(struct btrfs_trans_handle *trans,
-					       struct inode *inode,
+					       struct btrfs_inode *inode,
 					       struct dentry *parent,
 					       struct super_block *sb,
 					       u64 last_committed)
 {
 	int ret = 0;
 	struct dentry *old_parent = NULL;
-	struct inode *orig_inode = inode;
+	struct btrfs_inode *orig_inode = inode;
 
 	/*
 	 * for regular files, if its inode is already on disk, we don't
@@ -5065,15 +5065,15 @@ static noinline int check_parent_dirs_for_sync(struct btrfs_trans_handle *trans,
 	 * we can use the last_unlink_trans field to record renames
 	 * and other fun in this file.
 	 */
-	if (S_ISREG(inode->i_mode) &&
-	    BTRFS_I(inode)->generation <= last_committed &&
-	    BTRFS_I(inode)->last_unlink_trans <= last_committed)
+	if (S_ISREG(inode->vfs_inode.i_mode) &&
+	    inode->generation <= last_committed &&
+	    inode->last_unlink_trans <= last_committed)
 			goto out;
 
-	if (!S_ISDIR(inode->i_mode)) {
+	if (!S_ISDIR(inode->vfs_inode.i_mode)) {
 		if (!parent || d_really_is_negative(parent) || sb != parent->d_sb)
 			goto out;
-		inode = d_inode(parent);
+		inode = BTRFS_I(d_inode(parent));
 	}
 
 	while (1) {
@@ -5084,10 +5084,10 @@ static noinline int check_parent_dirs_for_sync(struct btrfs_trans_handle *trans,
 		 * think this inode has already been logged.
 		 */
 		if (inode != orig_inode)
-			BTRFS_I(inode)->logged_trans = trans->transid;
+			inode->logged_trans = trans->transid;
 		smp_mb();
 
-		if (btrfs_must_commit_transaction(trans, BTRFS_I(inode))) {
+		if (btrfs_must_commit_transaction(trans, inode)) {
 			ret = 1;
 			break;
 		}
@@ -5096,8 +5096,8 @@ static noinline int check_parent_dirs_for_sync(struct btrfs_trans_handle *trans,
 			break;
 
 		if (IS_ROOT(parent)) {
-			inode = d_inode(parent);
-			if (btrfs_must_commit_transaction(trans, BTRFS_I(inode)))
+			inode = BTRFS_I(d_inode(parent));
+			if (btrfs_must_commit_transaction(trans, inode))
 				ret = 1;
 			break;
 		}
@@ -5105,7 +5105,7 @@ static noinline int check_parent_dirs_for_sync(struct btrfs_trans_handle *trans,
 		parent = dget_parent(parent);
 		dput(old_parent);
 		old_parent = parent;
-		inode = d_inode(parent);
+		inode = BTRFS_I(d_inode(parent));
 
 	}
 	dput(old_parent);
@@ -5434,7 +5434,7 @@ static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 		goto end_no_trans;
 	}
 
-	ret = check_parent_dirs_for_sync(trans, inode, parent,
+	ret = check_parent_dirs_for_sync(trans, BTRFS_I(inode), parent,
 					 sb, last_committed);
 	if (ret)
 		goto end_no_trans;
-- 
2.7.4

