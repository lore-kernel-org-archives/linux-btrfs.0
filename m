From: Sean Bartell <wingedtachikoma@gmail.com>
Subject: [PATCH] btrfs: handle errors for FS_IOC_SETFLAGS
Date: Wed, 30 Jun 2010 20:05:22 -0400
Message-ID: <20100701000522.GA5456@flcl.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Makes btrfs_ioctl_setflags return -ENOSPC and other errors when
necessary.

Signed-off-by: Sean Bartell <wingedtachikoma@gmail.com>
---
I ran chattr -R on a full FS and btrfs crashed. This overlaps with the patch
series being worked on by Jeff Mahoney.

 fs/btrfs/ioctl.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 4dbaf89..8db62c2 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -200,19 +200,26 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 
 
 	trans = btrfs_join_transaction(root, 1);
-	BUG_ON(!trans);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out_drop_write;
+	}
 
 	ret = btrfs_update_inode(trans, root, inode);
-	BUG_ON(ret);
+	if (ret)
+		goto out_endtrans;
 
 	btrfs_update_iflags(inode);
 	inode->i_ctime = CURRENT_TIME;
-	btrfs_end_transaction(trans, root);
 
+	ret = 0;
+out_endtrans:
+	btrfs_end_transaction(trans, root);
+out_drop_write:
 	mnt_drop_write(file->f_path.mnt);
- out_unlock:
+out_unlock:
 	mutex_unlock(&inode->i_mutex);
-	return 0;
+	return ret;
 }
 
 static int btrfs_ioctl_getversion(struct file *file, int __user *arg)
-- 
1.7.1

