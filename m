Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33944 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750863AbdAQWlN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 17:41:13 -0500
Received: by mail-wm0-f66.google.com with SMTP id c85so9428995wmi.1
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jan 2017 14:40:23 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCHv2 17/24] btrfs: Make log_new_dir_dentries take btrfs_inode
Date: Wed, 18 Jan 2017 00:31:43 +0200
Message-Id: <1484692310-3987-18-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484692310-3987-1-git-send-email-n.borisov.lkml@gmail.com>
References: <20170117161550.GW12081@twin.jikos.cz>
 <1484692310-3987-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/tree-log.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 38cda7869bf9..b0cc56fe86e9 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5155,7 +5155,7 @@ struct btrfs_dir_list {
  */
 static int log_new_dir_dentries(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
-				struct inode *start_inode,
+				struct btrfs_inode *start_inode,
 				struct btrfs_log_ctx *ctx)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -5174,7 +5174,7 @@ static int log_new_dir_dentries(struct btrfs_trans_handle *trans,
 		btrfs_free_path(path);
 		return -ENOMEM;
 	}
-	dir_elem->ino = btrfs_ino(BTRFS_I(start_inode));
+	dir_elem->ino = btrfs_ino(start_inode);
 	list_add_tail(&dir_elem->list, &dir_list);
 
 	while (!list_empty(&dir_list)) {
@@ -5368,7 +5368,7 @@ static int btrfs_log_all_parents(struct btrfs_trans_handle *trans,
 				ret = 1;
 			if (!ret && ctx && ctx->log_new_dentries)
 				ret = log_new_dir_dentries(trans, root,
-							   dir_inode, ctx);
+							   BTRFS_I(dir_inode), ctx);
 			iput(dir_inode);
 			if (ret)
 				goto out;
@@ -5531,7 +5531,7 @@ static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 		old_parent = parent;
 	}
 	if (log_dentries)
-		ret = log_new_dir_dentries(trans, root, orig_inode, ctx);
+		ret = log_new_dir_dentries(trans, root, BTRFS_I(orig_inode), ctx);
 	else
 		ret = 0;
 end_trans:
-- 
2.7.4

