Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:50451 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbbLaSZD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Dec 2015 13:25:03 -0500
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs: don't leave dangling dentry if symlink creation failed
Date: Thu, 31 Dec 2015 18:24:57 +0000
Message-Id: <1451586297-25713-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

When we are creating a symlink we might fail with an error after we
created its inode and added the corresponding directory indexes to its
parent inode. In this case we end up never removing the directory indexes
because the inode eviction handler, called for our symlink inode on the
final iput(), only removes items associated with the symlink inode and
not with the parent inode.

Example:

  $ mkfs.btrfs -f /dev/sdi
  $ mount /dev/sdi /mnt
  $ touch /mnt/foo
  $ ln -s /mnt/foo /mnt/bar
  ln: failed to create symbolic link ‘bar’: Cannot allocate memory
  $ umount /mnt
  $ btrfsck /dev/sdi
  Checking filesystem on /dev/sdi
  UUID: d5acb5ba-31bd-42da-b456-89dca2e716e1
  checking extents
  checking free space cache
  checking fs roots
  root 5 inode 258 errors 2001, no inode item, link count wrong
	unresolved ref dir 256 index 3 namelen 3 name bar filetype 7 errors 4, no inode ref
  found 131073 bytes used err is 1
  total csum bytes: 0
  total tree bytes: 131072
  total fs tree bytes: 32768
  total extent tree bytes: 16384
  btree space waste bytes: 124305
  file data blocks allocated: 262144
   referenced 262144
  btrfs-progs v4.2.3

So fix this by adding the directory index entries as the very last
step of symlink creation.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/inode.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index bdb0008..2ea2e0e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9693,10 +9693,6 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 	if (err)
 		goto out_unlock_inode;
 
-	err = btrfs_add_nondir(trans, dir, dentry, inode, 0, index);
-	if (err)
-		goto out_unlock_inode;
-
 	path = btrfs_alloc_path();
 	if (!path) {
 		err = -ENOMEM;
@@ -9733,6 +9729,13 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 	inode_set_bytes(inode, name_len);
 	btrfs_i_size_write(inode, name_len);
 	err = btrfs_update_inode(trans, root, inode);
+	/*
+	 * Last step, add directory indexes for our symlink inode. This is the
+	 * last step to avoid extra cleanup of these indexes if an error happens
+	 * elsewhere above.
+	 */
+	if (!err)
+		err = btrfs_add_nondir(trans, dir, dentry, inode, 0, index);
 	if (err) {
 		drop_inode = 1;
 		goto out_unlock_inode;
-- 
2.1.3

