Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35714 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751139AbdAQWjA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 17:39:00 -0500
Received: by mail-wm0-f65.google.com with SMTP id d140so25584638wmd.2
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jan 2017 14:38:59 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCHv2 12/24] btrfs: Make btrfs_log_trailing_hole take btrfs_inode
Date: Wed, 18 Jan 2017 00:31:38 +0200
Message-Id: <1484692310-3987-13-git-send-email-n.borisov.lkml@gmail.com>
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
index 1301c517c2f0..9f2c42016825 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4372,7 +4372,7 @@ static int btrfs_log_all_xattrs(struct btrfs_trans_handle *trans,
  */
 static int btrfs_log_trailing_hole(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root,
-				   struct inode *inode,
+				   struct btrfs_inode *inode,
 				   struct btrfs_path *path)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -4382,8 +4382,8 @@ static int btrfs_log_trailing_hole(struct btrfs_trans_handle *trans,
 	u64 hole_size;
 	struct extent_buffer *leaf;
 	struct btrfs_root *log = root->log_root;
-	const u64 ino = btrfs_ino(BTRFS_I(inode));
-	const u64 i_size = i_size_read(inode);
+	const u64 ino = btrfs_ino(inode);
+	const u64 i_size = i_size_read(&inode->vfs_inode);
 
 	if (!btrfs_fs_incompat(fs_info, NO_HOLES))
 		return 0;
@@ -4925,7 +4925,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 	if (max_key.type >= BTRFS_EXTENT_DATA_KEY && !fast_search) {
 		btrfs_release_path(path);
 		btrfs_release_path(dst_path);
-		err = btrfs_log_trailing_hole(trans, root, inode, path);
+		err = btrfs_log_trailing_hole(trans, root, BTRFS_I(inode), path);
 		if (err)
 			goto out_unlock;
 	}
-- 
2.7.4

