Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:38889 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab3IPIya (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Sep 2013 04:54:30 -0400
Received: by mail-bk0-f47.google.com with SMTP id mx12so1348061bkb.6
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Sep 2013 01:54:29 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: don't store NULL byte in symlink extents
Date: Mon, 16 Sep 2013 09:53:28 +0100
Message-Id: <1379321608-22651-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It is not necessary to store the NULL byte in a symlink inline file
extent. There's currently no code that requires the NULL byte to be
present in the extent. This change also doesn't break file format
compatibility nor the send/receive feature.

The VFS also doesn't need the NULL byte to be present in the extent,
as it reads up to inode->i_size bytes (which already excluded the NULL
byte) and sets the NULL byte for us (in fs/namei.c:page_getlink()).

So with this change we save 1 byte per symlink file extent (which is
always inlined in the btree leaf) without losing backward and forward
compatibility.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 85a4900..15e9d36 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8334,7 +8334,7 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 	struct btrfs_file_extent_item *ei;
 	struct extent_buffer *leaf;
 
-	name_len = strlen(symname) + 1;
+	name_len = strlen(symname);
 	if (name_len > BTRFS_MAX_INLINE_DATA_SIZE(root))
 		return -ENAMETOOLONG;
 
@@ -8422,7 +8422,7 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 	inode->i_mapping->a_ops = &btrfs_symlink_aops;
 	inode->i_mapping->backing_dev_info = &root->fs_info->bdi;
 	inode_set_bytes(inode, name_len);
-	btrfs_i_size_write(inode, name_len - 1);
+	btrfs_i_size_write(inode, name_len);
 	err = btrfs_update_inode(trans, root, inode);
 	if (err)
 		drop_inode = 1;
-- 
1.7.9.5

