Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33591 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbbFCAbK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Jun 2015 20:31:10 -0400
Received: by padj3 with SMTP id j3so78174882pad.0
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Jun 2015 17:31:09 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: Markus Schauler <mschauler@gmail.com>,
        Filipe David Manana <fdmanana@gmail.com>,
        Omar Sandoval <osandov@osandov.com>, <stable@vger.kernel.org>
Subject: [PATCH v2] Btrfs: don't invalidate root dentry when subvolume deletion fails
Date: Tue,  2 Jun 2015 17:31:00 -0700
Message-Id: <14b0605f7a3a50a29bdfd40161860a45c7ea7513.1433290960.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since commit bafc9b754f75 ("vfs: More precise tests in d_invalidate"),
mounted subvolumes can be deleted because d_invalidate() won't fail.
However, we run into problems when we attempt to delete the default
subvolume while it is mounted as the root filesystem:

	# btrfs subvol list /
	ID 257 gen 306 top level 5 path rootvol
	ID 267 gen 334 top level 5 path snap1
	# btrfs subvol get-default /
	ID 267 gen 334 top level 5 path snap1
	# btrfs inspect-internal rootid /
	267
	# mount -o subvol=/ /dev/vda1 /mnt
	# btrfs subvol del /mnt/snap1
	Delete subvolume (no-commit): '/mnt/snap1'
	ERROR: cannot delete '/mnt/snap1' - Operation not permitted
	# findmnt /
	findmnt: can't read /proc/mounts: No such file or directory
	# ls /proc
	#

Markus reported that this same scenario simply led to a kernel oops.

This happens because in btrfs_ioctl_snap_destroy(), we call
d_invalidate() before we check may_destroy_subvol(), which means that we
detach the submounts and drop the dentry before erroring out. Instead,
we should only invalidate the dentry once the deletion has succeeded.
Additionally, the shrink_dcache_sb() isn't necessary; d_invalidate()
will prune the dcache for the deleted subvolume.

Cc: <stable@vger.kernel.org>
Fixes: bafc9b754f75 ("vfs: More precise tests in d_invalidate")
Reported-by: Markus Schauler <mschauler@gmail.com>
Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
v1->v2:
- Move d_invalidate() to only happen if the whole deletion was
  successful instead of after may_destroy_subvol() succeeds (pointed out
  by Filipe)
- Remove unnecessary shrink_dcache_sb()

As I mentioned in the thread for v1
(http://thread.gmane.org/gmane.comp.file-systems.btrfs/45448), I don't
know why that shrink_dcache_sb() is in there. The commit that introduced
it, efefb1438be2 ("Btrfs: remove negative dentry when deleting
subvolumne"), doesn't explain why it was added, but maybe someone can
enlighten me :)

 fs/btrfs/ioctl.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 1c22c6518504..6f790bcddfc1 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2413,8 +2413,6 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 		goto out_unlock_inode;
 	}
 
-	d_invalidate(dentry);
-
 	down_write(&root->fs_info->subvol_sem);
 
 	err = may_destroy_subvol(dest);
@@ -2508,7 +2506,7 @@ out_up_write:
 out_unlock_inode:
 	mutex_unlock(&inode->i_mutex);
 	if (!err) {
-		shrink_dcache_sb(root->fs_info->sb);
+		d_invalidate(dentry);
 		btrfs_invalidate_inodes(dest);
 		d_delete(dentry);
 		ASSERT(dest->send_in_progress == 0);
-- 
2.4.2

