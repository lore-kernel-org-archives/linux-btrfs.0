Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33557 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751045AbdAQWjf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 17:39:35 -0500
Received: by mail-wm0-f67.google.com with SMTP id r144so41964649wme.0
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jan 2017 14:39:34 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCHv2 15/24] btrfs: Make log_dir_items take btrfs_inode
Date: Wed, 18 Jan 2017 00:31:41 +0200
Message-Id: <1484692310-3987-16-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484692310-3987-1-git-send-email-n.borisov.lkml@gmail.com>
References: <20170117161550.GW12081@twin.jikos.cz>
 <1484692310-3987-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/tree-log.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index e293ae0e18d7..8d7197a0eceb 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3260,7 +3260,7 @@ static noinline int insert_dir_log_key(struct btrfs_trans_handle *trans,
  * to replay anything deleted before the fsync
  */
 static noinline int log_dir_items(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root, struct inode *inode,
+			  struct btrfs_root *root, struct btrfs_inode *inode,
 			  struct btrfs_path *path,
 			  struct btrfs_path *dst_path, int key_type,
 			  struct btrfs_log_ctx *ctx,
@@ -3275,7 +3275,7 @@ static noinline int log_dir_items(struct btrfs_trans_handle *trans,
 	int nritems;
 	u64 first_offset = min_offset;
 	u64 last_offset = (u64)-1;
-	u64 ino = btrfs_ino(BTRFS_I(inode));
+	u64 ino = btrfs_ino(inode);
 
 	log = root->log_root;
 
@@ -3464,7 +3464,7 @@ static noinline int log_directory_changes(struct btrfs_trans_handle *trans,
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

