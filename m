Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34790 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbeIYEVY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Sep 2018 00:21:24 -0400
Received: by mail-pf1-f193.google.com with SMTP id k19-v6so9751433pfi.1
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Sep 2018 15:17:01 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>
Subject: [PATCH] Btrfs: get rid of btrfs_symlink_aops
Date: Mon, 24 Sep 2018 15:16:55 -0700
Message-Id: <0794275791ff92b445d78d3dd08c67a30a347bbb.1537827364.git.osandov@fb.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

The only aops we define for symlinks are identical to the aops for
regular files. This has been the case since symlink support was added in
commit 2b8d99a723a3 ("Btrfs: symlinks and hard links"). As far as I can
tell, there wasn't a good reason to have separate aops then, and there
isn't now, so let's just do what most other filesystems do and reuse the
same structure.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
Based on v4.19-rc5.

 fs/btrfs/inode.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3ea5339603cf..590063b0b6dc 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -64,7 +64,6 @@ static const struct inode_operations btrfs_dir_ro_inode_operations;
 static const struct inode_operations btrfs_special_inode_operations;
 static const struct inode_operations btrfs_file_inode_operations;
 static const struct address_space_operations btrfs_aops;
-static const struct address_space_operations btrfs_symlink_aops;
 static const struct file_operations btrfs_dir_file_operations;
 static const struct extent_io_ops btrfs_extent_io_ops;
 
@@ -3738,7 +3737,7 @@ static int btrfs_read_locked_inode(struct inode *inode)
 	case S_IFLNK:
 		inode->i_op = &btrfs_symlink_inode_operations;
 		inode_nohighmem(inode);
-		inode->i_mapping->a_ops = &btrfs_symlink_aops;
+		inode->i_mapping->a_ops = &btrfs_aops;
 		break;
 	default:
 		inode->i_op = &btrfs_special_inode_operations;
@@ -10191,7 +10190,7 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 
 	inode->i_op = &btrfs_symlink_inode_operations;
 	inode_nohighmem(inode);
-	inode->i_mapping->a_ops = &btrfs_symlink_aops;
+	inode->i_mapping->a_ops = &btrfs_aops;
 	inode_set_bytes(inode, name_len);
 	btrfs_i_size_write(BTRFS_I(inode), name_len);
 	err = btrfs_update_inode(trans, root, inode);
@@ -10567,13 +10566,6 @@ static const struct address_space_operations btrfs_aops = {
 	.error_remove_page = generic_error_remove_page,
 };
 
-static const struct address_space_operations btrfs_symlink_aops = {
-	.readpage	= btrfs_readpage,
-	.writepage	= btrfs_writepage,
-	.invalidatepage = btrfs_invalidatepage,
-	.releasepage	= btrfs_releasepage,
-};
-
 static const struct inode_operations btrfs_file_inode_operations = {
 	.getattr	= btrfs_getattr,
 	.setattr	= btrfs_setattr,
-- 
2.19.0
