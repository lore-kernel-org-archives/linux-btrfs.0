From: Dan Carpenter <error27@gmail.com>
Subject: [patch 5/11] btrfs: remove unneeded null check in btrfs_rename()
Date: Sat, 29 May 2010 11:45:08 +0200
Message-ID: <20100529094508.GF5483@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yan Zheng <zheng.yan@oracle.com>, Josef Bacik <josef@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Chris Mason <chris.mason@oracle.com>,
	kernel-janitors@vger.kernel.org
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

"old_inode" cannot be null here, because we dereference it
unconditionally throughout the function.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index fa6ccc1..0bc29be 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6487,10 +6487,8 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	 * make sure the inode gets flushed if it is replacing
 	 * something.
 	 */
-	if (new_inode && new_inode->i_size &&
-	    old_inode && S_ISREG(old_inode->i_mode)) {
+	if (new_inode && new_inode->i_size && S_ISREG(old_inode->i_mode))
 		btrfs_add_ordered_operation(trans, root, old_inode);
-	}
 
 	old_dir->i_ctime = old_dir->i_mtime = ctime;
 	new_dir->i_ctime = new_dir->i_mtime = ctime;
