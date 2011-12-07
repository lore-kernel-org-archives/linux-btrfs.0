From: Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH] BTRFS: Establish i_ops before calling d_instantiate
Date: Tue, 06 Dec 2011 16:39:50 -0800
Message-ID: <4EDEB5D6.4040202@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Casey Schaufler <casey@schaufler-ca.com>,
	LSM <linux-security-module@vger.kernel.org>,
	LKLM <linux-kernel@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Casey Schaufler <casey@schaufler-ca.com>

The Smack LSM hook for security_d_instantiate checks
the inode's i_op->getxattr value to determine if the
containing filesystem supports extended attributes.
The BTRFS filesystem sets the inode's i_op value only
after it has instantiated the inode. This results in
Smack incorrectly giving new BTRFS inodes attributes
from the filesystem defaults on the assumption that
values can't be stored on the filesystem. This patch
moves the assignment of inode operation vectors ahead
of the calls to d_instantiate, letting Smack know that
the filesystem supports extended attributes. There
should be no impact on the performance or behavior of
BTRFS.


Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---

  fs/btrfs/inode.c |   31 ++++++++++++++++++++++++++-----
  1 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2c984f7..df0efca 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4555,11 +4555,18 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
  		goto out_unlock;
  	}
  
+	/*
+	 * If the active LSM wants to access the inode during
+	 * d_instantiate it needs these. Smack checks to see
+	 * if the filesystem supports xattrs by looking at the
+	 * ops vector.
+	 */
+	inode->i_op = &btrfs_special_inode_operations;
+
  	err = btrfs_add_nondir(trans, dir, dentry, inode, 0, index);
  	if (err)
  		drop_inode = 1;
  	else {
-		inode->i_op = &btrfs_special_inode_operations;
  		init_special_inode(inode, inode->i_mode, rdev);
  		btrfs_update_inode(trans, root, inode);
  	}
@@ -4613,14 +4620,21 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
  		goto out_unlock;
  	}
  
+	/*
+	 * If the active LSM wants to access the inode during
+	 * d_instantiate it needs these. Smack checks to see
+	 * if the filesystem supports xattrs by looking at the
+	 * ops vector.
+	 */
+	inode->i_fop = &btrfs_file_operations;
+	inode->i_op = &btrfs_file_inode_operations;
+
  	err = btrfs_add_nondir(trans, dir, dentry, inode, 0, index);
  	if (err)
  		drop_inode = 1;
  	else {
  		inode->i_mapping->a_ops = &btrfs_aops;
  		inode->i_mapping->backing_dev_info = &root->fs_info->bdi;
-		inode->i_fop = &btrfs_file_operations;
-		inode->i_op = &btrfs_file_inode_operations;
  		BTRFS_I(inode)->io_tree.ops = &btrfs_extent_io_ops;
  	}
  out_unlock:
@@ -7076,14 +7090,21 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
  		goto out_unlock;
  	}
  
+	/*
+	 * If the active LSM wants to access the inode during
+	 * d_instantiate it needs these. Smack checks to see
+	 * if the filesystem supports xattrs by looking at the
+	 * ops vector.
+	 */
+	inode->i_fop = &btrfs_file_operations;
+	inode->i_op = &btrfs_file_inode_operations;
+
  	err = btrfs_add_nondir(trans, dir, dentry, inode, 0, index);
  	if (err)
  		drop_inode = 1;
  	else {
  		inode->i_mapping->a_ops = &btrfs_aops;
  		inode->i_mapping->backing_dev_info = &root->fs_info->bdi;
-		inode->i_fop = &btrfs_file_operations;
-		inode->i_op = &btrfs_file_inode_operations;
  		BTRFS_I(inode)->io_tree.ops = &btrfs_extent_io_ops;
  	}
  	if (drop_inode)
