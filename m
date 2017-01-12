Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36211 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750917AbdALOBE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jan 2017 09:01:04 -0500
Received: by mail-wm0-f66.google.com with SMTP id r126so3894550wmr.3
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Jan 2017 06:01:04 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCH 08/24] btrfs: Make logged_inode_size take btrfs_inode
Date: Thu, 12 Jan 2017 16:00:34 +0200
Message-Id: <1484229650-24554-9-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484229650-24554-1-git-send-email-n.borisov.lkml@gmail.com>
References: <1484229650-24554-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/tree-log.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index ffe9aad04be5..0fc963454c82 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4240,13 +4240,13 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static int logged_inode_size(struct btrfs_root *log, struct inode *inode,
+static int logged_inode_size(struct btrfs_root *log, struct btrfs_inode *inode,
 			     struct btrfs_path *path, u64 *size_ret)
 {
 	struct btrfs_key key;
 	int ret;
 
-	key.objectid = btrfs_ino(BTRFS_I(inode));
+	key.objectid = btrfs_ino(inode);
 	key.type = BTRFS_INODE_ITEM_KEY;
 	key.offset = 0;
 
@@ -4692,7 +4692,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 			 * (zeroes), as if an expanding truncate happened,
 			 * instead of getting a file of 4Kb only.
 			 */
-			err = logged_inode_size(log, inode, path,
+			err = logged_inode_size(log, BTRFS_I(inode), path,
 						&logged_isize);
 			if (err)
 				goto out_unlock;
-- 
2.7.4

