Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35250 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751059AbdAQWlc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 17:41:32 -0500
Received: by mail-wm0-f68.google.com with SMTP id d140so25597139wmd.2
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jan 2017 14:41:31 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCHv2 16/24] btrfs: Make log_directory_changes take btrfs_inode
Date: Wed, 18 Jan 2017 00:31:42 +0200
Message-Id: <1484692310-3987-17-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484692310-3987-1-git-send-email-n.borisov.lkml@gmail.com>
References: <20170117161550.GW12081@twin.jikos.cz>
 <1484692310-3987-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/tree-log.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 8d7197a0eceb..38cda7869bf9 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3450,7 +3450,7 @@ static noinline int log_dir_items(struct btrfs_trans_handle *trans,
  * key logged by this transaction.
  */
 static noinline int log_directory_changes(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root, struct inode *inode,
+			  struct btrfs_root *root, struct btrfs_inode *inode,
 			  struct btrfs_path *path,
 			  struct btrfs_path *dst_path,
 			  struct btrfs_log_ctx *ctx)
@@ -3464,9 +3464,8 @@ static noinline int log_directory_changes(struct btrfs_trans_handle *trans,
 	min_key = 0;
 	max_key = 0;
 	while (1) {
-		ret = log_dir_items(trans, root, BTRFS_I(inode), path,
-				    dst_path, key_type, ctx, min_key,
-				    &max_key);
+		ret = log_dir_items(trans, root, inode, path, dst_path, key_type, 
+				ctx, min_key, &max_key);
 		if (ret)
 			return ret;
 		if (max_key == (u64)-1)
@@ -4977,7 +4976,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 	}
 
 	if (inode_only == LOG_INODE_ALL && S_ISDIR(inode->i_mode)) {
-		ret = log_directory_changes(trans, root, inode, path, dst_path,
+		ret = log_directory_changes(trans, root, BTRFS_I(inode), path, dst_path,
 					    ctx);
 		if (ret) {
 			err = ret;
-- 
2.7.4

