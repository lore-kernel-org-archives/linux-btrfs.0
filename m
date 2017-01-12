Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35775 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751038AbdALOBO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jan 2017 09:01:14 -0500
Received: by mail-wm0-f66.google.com with SMTP id l2so3919985wml.2
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Jan 2017 06:01:14 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCH 15/24] btrfs: Make log_dir_items take btrfs_inode
Date: Thu, 12 Jan 2017 16:00:41 +0200
Message-Id: <1484229650-24554-16-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484229650-24554-1-git-send-email-n.borisov.lkml@gmail.com>
References: <1484229650-24554-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/tree-log.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 5abe54963049..84c1ab4c8a7f 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3259,7 +3259,7 @@ static noinline int insert_dir_log_key(struct btrfs_trans_handle *trans,
  * to replay anything deleted before the fsync
  */
 static noinline int log_dir_items(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root, struct inode *inode,
+			  struct btrfs_root *root, struct btrfs_inode *inode,
 			  struct btrfs_path *path,
 			  struct btrfs_path *dst_path, int key_type,
 			  struct btrfs_log_ctx *ctx,
@@ -3274,7 +3274,7 @@ static noinline int log_dir_items(struct btrfs_trans_handle *trans,
 	int nritems;
 	u64 first_offset = min_offset;
 	u64 last_offset = (u64)-1;
-	u64 ino = btrfs_ino(BTRFS_I(inode));
+	u64 ino = btrfs_ino(inode);
 
 	log = root->log_root;
 
@@ -3463,7 +3463,7 @@ static noinline int log_directory_changes(struct btrfs_trans_handle *trans,
 	min_key = 0;
 	max_key = 0;
 	while (1) {
-		ret = log_dir_items(trans, root, inode, path,
+		ret = log_dir_items(trans, root, BTRFS_I(inode), path,
 				    dst_path, key_type, ctx, min_key,
 				    &max_key);
 		if (ret)
-- 
2.7.4

