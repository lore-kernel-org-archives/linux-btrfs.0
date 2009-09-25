From: Sage Weil <sage@newdream.net>
Subject: [PATCH] Btrfs: fix error cases for ioctl transactions
Date: Fri, 25 Sep 2009 12:58:31 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0909251258050.20862@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Fix leak of vfsmount write reference and open_ioctl_trans reference on
ENOMEM.  Clean up the error paths while we're at it.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/ioctl.c |   41 ++++++++++++++++++++++-------------------
 1 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index eab3603..647838b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1216,15 +1216,15 @@ static long btrfs_ioctl_trans_start(struct file *file)
 	struct inode *inode = fdentry(file)->d_inode;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_trans_handle *trans;
-	int ret = 0;
+	int ret;
 
+	ret = -EPERM;
 	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
+		goto out;
 
-	if (file->private_data) {
-		ret = -EINPROGRESS;
+	ret = -EINPROGRESS;
+	if (file->private_data)
 		goto out;
-	}
 
 	ret = mnt_want_write(file->f_path.mnt);
 	if (ret)
@@ -1234,12 +1234,19 @@ static long btrfs_ioctl_trans_start(struct file *file)
 	root->fs_info->open_ioctl_trans++;
 	mutex_unlock(&root->fs_info->trans_mutex);
 
+	ret = -ENOMEM;
 	trans = btrfs_start_ioctl_transaction(root, 0);
-	if (trans)
-		file->private_data = trans;
-	else
-		ret = -ENOMEM;
-	/*printk(KERN_INFO "btrfs_ioctl_trans_start on %p\n", file);*/
+	if (!trans)
+		goto out_drop;
+
+	file->private_data = trans;
+	return 0;
+
+out_drop:
+	mutex_lock(&root->fs_info->trans_mutex);
+	root->fs_info->open_ioctl_trans--;
+	mutex_unlock(&root->fs_info->trans_mutex);
+	mnt_drop_write(file->f_path.mnt);
 out:
 	return ret;
 }
@@ -1255,24 +1262,20 @@ long btrfs_ioctl_trans_end(struct file *file)
 	struct inode *inode = fdentry(file)->d_inode;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_trans_handle *trans;
-	int ret = 0;
 
 	trans = file->private_data;
-	if (!trans) {
-		ret = -EINVAL;
-		goto out;
-	}
-	btrfs_end_transaction(trans, root);
+	if (!trans)
+		return -EINVAL;
 	file->private_data = NULL;
 
+	btrfs_end_transaction(trans, root);
+
 	mutex_lock(&root->fs_info->trans_mutex);
 	root->fs_info->open_ioctl_trans--;
 	mutex_unlock(&root->fs_info->trans_mutex);
 
 	mnt_drop_write(file->f_path.mnt);
-
-out:
-	return ret;
+	return 0;
 }
 
 long btrfs_ioctl(struct file *file, unsigned int
-- 
1.5.6.5

