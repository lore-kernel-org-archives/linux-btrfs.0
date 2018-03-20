Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:62029 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750888AbeCTGqJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Mar 2018 02:46:09 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id E4B6BAC00DB
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Mar 2018 15:46:03 +0900 (JST)
Received: from G01JPEXCHKW16.g01.fujitsu.local (G01JPEXCHKW16.g01.fujitsu.local [10.0.194.55])
        by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id 08AA13284A2
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Mar 2018 15:46:03 +0900 (JST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] btrfs: Allow non-privileged user to delete empty subvolume by
 default
Message-ID: <5164078e-4e15-d6df-7356-fa4f5d70a2db@jp.fujitsu.com>
Date: Tue, 20 Mar 2018 15:45:37 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Deletion of subvolume by non-privileged user is completely restricted
by default because we can delete a subvolume even if it is not empty
and may cause data loss. In other words, when user_subvol_rm_allowed
mount option is used, a user can delete a subvolume containing the
directory which cannot be deleted directly by the user.

However, there should be no harm to allow users to delete empty subvolumes
when rmdir(2) would have been allowed if they were normal directories.
This patch allows deletion of empty subvolume by default.

Note that user_subvol_rm_allowed option requires write+exec permission
of the subvolume to be deleted, but they are not required for empty
subvolume.

The comment in the code is also updated accordingly.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 fs/btrfs/ioctl.c | 55 +++++++++++++++++++++++++++++++------------------------
 1 file changed, 31 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 111ee282b777..838406a7a7f5 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2366,36 +2366,43 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 	dest = BTRFS_I(inode)->root;
 	if (!capable(CAP_SYS_ADMIN)) {
 		/*
-		 * Regular user.  Only allow this with a special mount
-		 * option, when the user has write+exec access to the
-		 * subvol root, and when rmdir(2) would have been
-		 * allowed.
+		 * By default, regular user is only allowed to delete
+		 * empty subvols when rmdir(2) would have been allowed
+		 * if they were normal directories.
 		 *
-		 * Note that this is _not_ check that the subvol is
-		 * empty or doesn't contain data that we wouldn't
+		 * If the mount option 'user_subvol_rm_allowed' is set,
+		 * it allows users to delete non-empty subvols when the
+		 * user has write+exec access to the subvol root and when
+		 * rmdir(2) would have been allowed (except the emptiness
+		 * check).
+		 *
+		 * Note that this option does _not_ check that if the subvol
+		 * is empty or doesn't contain data that the user wouldn't
 		 * otherwise be able to delete.
 		 *
-		 * Users who want to delete empty subvols should try
-		 * rmdir(2).
+		 * Users who want to delete empty subvols created by
+		 * snapshot (ino number == 2) can use rmdir(2).
 		 */
-		err = -EPERM;
-		if (!btrfs_test_opt(fs_info, USER_SUBVOL_RM_ALLOWED))
-			goto out_dput;
+		err = -ENOTEMPTY;
+		if (inode->i_size != BTRFS_EMPTY_DIR_SIZE) {
+			if (!btrfs_test_opt(fs_info, USER_SUBVOL_RM_ALLOWED))
+				goto out_dput;
 
-		/*
-		 * Do not allow deletion if the parent dir is the same
-		 * as the dir to be deleted.  That means the ioctl
-		 * must be called on the dentry referencing the root
-		 * of the subvol, not a random directory contained
-		 * within it.
-		 */
-		err = -EINVAL;
-		if (root == dest)
-			goto out_dput;
+			/*
+			 * Do not allow deletion if the parent dir is the same
+			 * as the dir to be deleted.  That means the ioctl
+			 * must be called on the dentry referencing the root
+			 * of the subvol, not a random directory contained
+			 * within it.
+			 */
+			err = -EINVAL;
+			if (root == dest)
+				goto out_dput;
 
-		err = inode_permission(inode, MAY_WRITE | MAY_EXEC);
-		if (err)
-			goto out_dput;
+			err = inode_permission(inode, MAY_WRITE | MAY_EXEC);
+			if (err)
+				goto out_dput;
+		}
 	}
 
 	/* check if subvolume may be deleted by a user */
-- 
2.14.3

