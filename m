Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:32821 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbbC1LC0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Mar 2015 07:02:26 -0400
Received: by pabxg6 with SMTP id xg6so119974299pab.0
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Mar 2015 04:02:26 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>
Cc: Filipe Manana <fdmanana@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Omar Sandoval <osandov@osandov.com>
Subject: [PATCH] btrfs: unlock i_mutex after attempting to delete subvolume during send
Date: Sat, 28 Mar 2015 04:02:06 -0700
Message-Id: <74abba0fe653d9ac27bfe4f14ae3e8f65b5b7317.1427539655.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Whenever the check for a send in progress introduced in commit
521e0546c970 (btrfs: protect snapshots from deleting during send) is
hit, we return without unlocking inode->i_mutex. This is easy to see
with lockdep enabled:

[  +0.000059] ================================================
[  +0.000028] [ BUG: lock held when returning to user space! ]
[  +0.000029] 4.0.0-rc5-00096-g3c435c1 #93 Not tainted
[  +0.000026] ------------------------------------------------
[  +0.000029] btrfs/211 is leaving the kernel with locks still held!
[  +0.000029] 1 lock held by btrfs/211:
[  +0.000023]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<ffffffff8135b8df>] btrfs_ioctl_snap_destroy+0x2df/0x7a0

Make sure we unlock it in the error path.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 fs/btrfs/ioctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 74609b9..9fde01f 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2403,7 +2403,7 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 			"Attempt to delete subvolume %llu during send",
 			dest->root_key.objectid);
 		err = -EPERM;
-		goto out_dput;
+		goto out_unlock_inode;
 	}
 
 	d_invalidate(dentry);
@@ -2498,6 +2498,7 @@ out_up_write:
 				root_flags & ~BTRFS_ROOT_SUBVOL_DEAD);
 		spin_unlock(&dest->root_item_lock);
 	}
+out_unlock_inode:
 	mutex_unlock(&inode->i_mutex);
 	if (!err) {
 		shrink_dcache_sb(root->fs_info->sb);
-- 
2.3.4

