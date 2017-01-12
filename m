Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34208 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751037AbdALOBO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jan 2017 09:01:14 -0500
Received: by mail-wm0-f65.google.com with SMTP id c85so3882470wmi.1
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Jan 2017 06:01:13 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCH 16/24] btrfs: Make log_directory_changes take btrfs_inode
Date: Thu, 12 Jan 2017 16:00:42 +0200
Message-Id: <1484229650-24554-17-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484229650-24554-1-git-send-email-n.borisov.lkml@gmail.com>
References: <1484229650-24554-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/tree-log.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 84c1ab4c8a7f..7a500ff14681 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3449,7 +3449,7 @@ static noinline int log_dir_items(struct btrfs_trans_handle *trans,
  * key logged by this transaction.
  */
 static noinline int log_directory_changes(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root, struct inode *inode,
+			  struct btrfs_root *root, struct btrfs_inode *inode,
 			  struct btrfs_path *path,
 			  struct btrfs_path *dst_path,
 			  struct btrfs_log_ctx *ctx)
@@ -3463,9 +3463,8 @@ static noinline int log_directory_changes(struct btrfs_trans_handle *trans,
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
@@ -4970,7 +4969,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 	}
 
 	if (inode_only == LOG_INODE_ALL && S_ISDIR(inode->i_mode)) {
-		ret = log_directory_changes(trans, root, inode, path, dst_path,
+		ret = log_directory_changes(trans, root, BTRFS_I(inode), path, dst_path,
 					    ctx);
 		if (ret) {
 			err = ret;
-- 
2.7.4

