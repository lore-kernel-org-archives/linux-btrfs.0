Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35153 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934382AbdBQOoU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:44:20 -0500
Received: by mail-wr0-f193.google.com with SMTP id q39so5487916wrb.2
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:44:19 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 32/38] btrfs: make btrfs_log_inode_parent take btrfs_inode
Date: Fri, 17 Feb 2017 16:43:23 +0200
Message-Id: <1487342609-20652-33-git-send-email-nborisov@suse.com>
In-Reply-To: <1487342609-20652-1-git-send-email-nborisov@suse.com>
References: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/tree-log.c | 45 +++++++++++++++++++++------------------------
 1 file changed, 21 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index cc616d424b7a..f36e4c49bc0e 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5395,7 +5395,7 @@ static int btrfs_log_all_parents(struct btrfs_trans_handle *trans,
  * the last committed transaction
  */
 static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
-			    	  struct btrfs_root *root, struct inode *inode,
+			      struct btrfs_root *root, struct btrfs_inode *inode,
 				  struct dentry *parent,
 				  const loff_t start,
 				  const loff_t end,
@@ -5409,9 +5409,9 @@ static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 	int ret = 0;
 	u64 last_committed = fs_info->last_trans_committed;
 	bool log_dentries = false;
-	struct inode *orig_inode = inode;
+	struct btrfs_inode *orig_inode = inode;
 
-	sb = inode->i_sb;
+	sb = inode->vfs_inode.i_sb;
 
 	if (btrfs_test_opt(fs_info, NOTREELOG)) {
 		ret = 1;
@@ -5428,18 +5428,17 @@ static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 		goto end_no_trans;
 	}
 
-	if (root != BTRFS_I(inode)->root ||
-	    btrfs_root_refs(&root->root_item) == 0) {
+	if (root != inode->root || btrfs_root_refs(&root->root_item) == 0) {
 		ret = 1;
 		goto end_no_trans;
 	}
 
-	ret = check_parent_dirs_for_sync(trans, BTRFS_I(inode), parent,
-					 sb, last_committed);
+	ret = check_parent_dirs_for_sync(trans, inode, parent, sb, 
+			last_committed);
 	if (ret)
 		goto end_no_trans;
 
-	if (btrfs_inode_in_log(BTRFS_I(inode), trans->transid)) {
+	if (btrfs_inode_in_log(inode, trans->transid)) {
 		ret = BTRFS_NO_LOG_SYNC;
 		goto end_no_trans;
 	}
@@ -5448,8 +5447,7 @@ static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto end_no_trans;
 
-	ret = btrfs_log_inode(trans, root, BTRFS_I(inode), inode_only,
-			start, end, ctx);
+	ret = btrfs_log_inode(trans, root, inode, inode_only, start, end, ctx);
 	if (ret)
 		goto end_trans;
 
@@ -5459,14 +5457,14 @@ static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 	 * we can use the last_unlink_trans field to record renames
 	 * and other fun in this file.
 	 */
-	if (S_ISREG(inode->i_mode) &&
-	    BTRFS_I(inode)->generation <= last_committed &&
-	    BTRFS_I(inode)->last_unlink_trans <= last_committed) {
+	if (S_ISREG(inode->vfs_inode.i_mode) &&
+	    inode->generation <= last_committed &&
+	    inode->last_unlink_trans <= last_committed) {
 		ret = 0;
 		goto end_trans;
 	}
 
-	if (S_ISDIR(inode->i_mode) && ctx && ctx->log_new_dentries)
+	if (S_ISDIR(inode->vfs_inode.i_mode) && ctx && ctx->log_new_dentries)
 		log_dentries = true;
 
 	/*
@@ -5510,8 +5508,8 @@ static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 	 * but the file inode does not have a matching BTRFS_INODE_REF_KEY item
 	 * and has a link count of 2.
 	 */
-	if (BTRFS_I(inode)->last_unlink_trans > last_committed) {
-		ret = btrfs_log_all_parents(trans, BTRFS_I(orig_inode), ctx);
+	if (inode->last_unlink_trans > last_committed) {
+		ret = btrfs_log_all_parents(trans, orig_inode, ctx);
 		if (ret)
 			goto end_trans;
 	}
@@ -5520,13 +5518,12 @@ static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 		if (!parent || d_really_is_negative(parent) || sb != parent->d_sb)
 			break;
 
-		inode = d_inode(parent);
-		if (root != BTRFS_I(inode)->root)
+		inode = BTRFS_I(d_inode(parent));
+		if (root != inode->root)
 			break;
 
-		if (BTRFS_I(inode)->generation > last_committed) {
-			ret = btrfs_log_inode(trans, root, BTRFS_I(inode),
-					      LOG_INODE_EXISTS,
+		if (inode->generation > last_committed) {
+			ret = btrfs_log_inode(trans, root, inode, LOG_INODE_EXISTS,
 					      0, LLONG_MAX, ctx);
 			if (ret)
 				goto end_trans;
@@ -5539,7 +5536,7 @@ static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 		old_parent = parent;
 	}
 	if (log_dentries)
-		ret = log_new_dir_dentries(trans, root, BTRFS_I(orig_inode), ctx);
+		ret = log_new_dir_dentries(trans, root, orig_inode, ctx);
 	else
 		ret = 0;
 end_trans:
@@ -5571,7 +5568,7 @@ int btrfs_log_dentry_safe(struct btrfs_trans_handle *trans,
 	struct dentry *parent = dget_parent(dentry);
 	int ret;
 
-	ret = btrfs_log_inode_parent(trans, root, d_inode(dentry), parent,
+	ret = btrfs_log_inode_parent(trans, root, BTRFS_I(d_inode(dentry)), parent,
 				     start, end, 0, ctx);
 	dput(parent);
 
@@ -5834,7 +5831,7 @@ int btrfs_log_new_name(struct btrfs_trans_handle *trans,
 	    (!old_dir || old_dir->logged_trans <= fs_info->last_trans_committed))
 		return 0;
 
-	return btrfs_log_inode_parent(trans, root, &inode->vfs_inode, parent, 0,
+	return btrfs_log_inode_parent(trans, root, inode, parent, 0,
 				      LLONG_MAX, 1, NULL);
 }
 
-- 
2.7.4

