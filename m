Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34526 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751377AbdAQWlS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 17:41:18 -0500
Received: by mail-wm0-f65.google.com with SMTP id c85so9433544wmi.1
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jan 2017 14:41:17 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCHv2 11/24] btrfs: Make btrfs_log_all_xattrs take btrfs_inode
Date: Wed, 18 Jan 2017 00:31:37 +0200
Message-Id: <1484692310-3987-12-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484692310-3987-1-git-send-email-n.borisov.lkml@gmail.com>
References: <20170117161550.GW12081@twin.jikos.cz>
 <1484692310-3987-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/tree-log.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 12872bf492bd..1301c517c2f0 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4277,13 +4277,13 @@ static int logged_inode_size(struct btrfs_root *log, struct btrfs_inode *inode,
  */
 static int btrfs_log_all_xattrs(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
-				struct inode *inode,
+				struct btrfs_inode *inode,
 				struct btrfs_path *path,
 				struct btrfs_path *dst_path)
 {
 	int ret;
 	struct btrfs_key key;
-	const u64 ino = btrfs_ino(BTRFS_I(inode));
+	const u64 ino = btrfs_ino(inode);
 	int ins_nr = 0;
 	int start_slot = 0;
 
@@ -4304,7 +4304,7 @@ static int btrfs_log_all_xattrs(struct btrfs_trans_handle *trans,
 			if (ins_nr > 0) {
 				u64 last_extent = 0;
 
-				ret = copy_items(trans, BTRFS_I(inode), dst_path, path,
+				ret = copy_items(trans, inode, dst_path, path,
 						 &last_extent, start_slot,
 						 ins_nr, 1, 0);
 				/* can't be 1, extent items aren't processed */
@@ -4334,7 +4334,7 @@ static int btrfs_log_all_xattrs(struct btrfs_trans_handle *trans,
 	if (ins_nr > 0) {
 		u64 last_extent = 0;
 
-		ret = copy_items(trans, BTRFS_I(inode), dst_path, path,
+		ret = copy_items(trans, inode, dst_path, path,
 				 &last_extent, start_slot,
 				 ins_nr, 1, 0);
 		/* can't be 1, extent items aren't processed */
@@ -4919,7 +4919,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 
 	btrfs_release_path(path);
 	btrfs_release_path(dst_path);
-	err = btrfs_log_all_xattrs(trans, root, inode, path, dst_path);
+	err = btrfs_log_all_xattrs(trans, root, BTRFS_I(inode), path, dst_path);
 	if (err)
 		goto out_unlock;
 	if (max_key.type >= BTRFS_EXTENT_DATA_KEY && !fast_search) {
-- 
2.7.4

