From: Christian Parpart <trapni@gentoo.org>
Subject: [PATCH] deny sys_{rename,link} across subvolumes of same disk
Date: Thu, 9 Oct 2008 03:40:50 +0200
Message-ID: <200810090340.50462.trapni@gentoo.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_iEW7IjMJD6kmME5"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--Boundary-00=_iEW7IjMJD6kmME5
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This patch denies renames and linking of inodes across subvolumes, as it 
causes disk format corruption.

I guess a long-term goal *might* be to just handle these special cases with 
care, to allow them by properly handling this case in the implementation, 
however, I wasn't unable to do that with my limited knowledge.

Best regards,
Christian Parpart.



--Boundary-00=_iEW7IjMJD6kmME5
Content-Type: text/x-patch;
  charset="us-ascii";
  name="cross-subvol-change-fix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="cross-subvol-change-fix.diff"

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ff0c359..20a3772 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2748,6 +2748,10 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	if (inode->i_nlink == 0)
 		return -ENOENT;
 
+	/* do not allow sys_link's with other subvols of the same device */
+	if (root->objectid != BTRFS_I(inode)->root->objectid)
+		return -EPERM;
+
 	btrfs_inc_nlink(inode);
 	err = btrfs_check_free_space(root, 1, 0);
 	if (err)
@@ -3577,6 +3581,10 @@ static int btrfs_rename(struct inode * old_dir, struct dentry *old_dentry,
 		return -ENOTEMPTY;
 	}
 
+	/* do not allow sys_rename's with other subvols of the same device */
+	if (root->objectid != BTRFS_I(new_dir)->root->objectid)
+		return -EPERM;
+
 	ret = btrfs_check_free_space(root, 1, 0);
 	if (ret)
 		goto out_unlock;

--Boundary-00=_iEW7IjMJD6kmME5--
