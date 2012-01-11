From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 04/11] Btrfs: remove BUG_ON()s in btrfs_ioctl_setflags()
Date: Wed, 11 Jan 2012 13:52:56 +0800
Message-ID: <4F0D23B8.8060601@cn.fujitsu.com>
References: <4F0D236E.2010306@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F0D236E.2010306@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

We can recover from errors and return -errno to user space.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index c04f02c..9619fb0 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -176,6 +176,8 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	struct btrfs_trans_handle *trans;
 	unsigned int flags, oldflags;
 	int ret;
+	u64 ip_oldflags;
+	unsigned int i_oldflags;
 
 	if (btrfs_root_readonly(root))
 		return -EROFS;
@@ -192,6 +194,9 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 
 	mutex_lock(&inode->i_mutex);
 
+	ip_oldflags = ip->flags;
+	i_oldflags = inode->i_flags;
+
 	flags = btrfs_mask_flags(inode->i_mode, flags);
 	oldflags = btrfs_flags_to_ioctl(ip->flags);
 	if ((flags ^ oldflags) & (FS_APPEND_FL | FS_IMMUTABLE_FL)) {
@@ -250,18 +255,23 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	}
 
 	trans = btrfs_join_transaction(root);
-	BUG_ON(IS_ERR(trans));
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out_drop;
+	}
 
 	btrfs_update_iflags(inode);
 	inode->i_ctime = CURRENT_TIME;
 	ret = btrfs_update_inode(trans, root, inode);
-	BUG_ON(ret);
 
 	btrfs_end_transaction(trans, root);
+ out_drop:
+	if (ret) {
+		ip->flags = ip_oldflags;
+		inode->i_flags = i_oldflags;
+	}
 
 	mnt_drop_write(file->f_path.mnt);
-
-	ret = 0;
  out_unlock:
 	mutex_unlock(&inode->i_mutex);
 	return ret;
-- 
1.7.3.1
