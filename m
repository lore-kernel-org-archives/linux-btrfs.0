Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36448 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751069AbdALOBU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jan 2017 09:01:20 -0500
Received: by mail-wm0-f65.google.com with SMTP id r126so3896210wmr.3
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Jan 2017 06:01:20 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCH 21/24] btrfs: Make log_inode_item take btrfs_inode
Date: Thu, 12 Jan 2017 16:00:47 +0200
Message-Id: <1484229650-24554-22-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484229650-24554-1-git-send-email-n.borisov.lkml@gmail.com>
References: <1484229650-24554-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/tree-log.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index a24983cd455c..002db48541ff 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3591,19 +3591,18 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 
 static int log_inode_item(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *log, struct btrfs_path *path,
-			  struct inode *inode)
+			  struct btrfs_inode *inode)
 {
 	struct btrfs_inode_item *inode_item;
 	int ret;
 
 	ret = btrfs_insert_empty_item(trans, log, path,
-				      &BTRFS_I(inode)->location,
-				      sizeof(*inode_item));
+				      &inode->location, sizeof(*inode_item));
 	if (ret && ret != -EEXIST)
 		return ret;
 	inode_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
 				    struct btrfs_inode_item);
-	fill_inode_item(trans, path->nodes[0], inode_item, inode, 0, 0);
+	fill_inode_item(trans, path->nodes[0], inode_item, &inode->vfs_inode, 0, 0);
 	btrfs_release_path(path);
 	return 0;
 }
@@ -4923,7 +4922,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 	btrfs_release_path(path);
 	btrfs_release_path(dst_path);
 	if (need_log_inode_item) {
-		err = log_inode_item(trans, log, dst_path, inode);
+		err = log_inode_item(trans, log, dst_path, BTRFS_I(inode));
 		if (err)
 			goto out_unlock;
 	}
-- 
2.7.4

