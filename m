From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH v3 3/3] Btrfs: Add BTRFS_IOC_SUBVOL_GETFLAGS/SETFLAGS ioctls
Date: Thu, 23 Dec 2010 16:16:33 +0800
Message-ID: <4D130561.9090704@cn.fujitsu.com>
References: <4D130514.9080704@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D130514.9080704@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

This allows us to set a snapshot or a subvolume readonly or writable
on the fly.

Usage:

Set BTRFS_SUBVOL_RDONLY of btrfs_ioctl_vol_arg_v2->flags, and then
call ioctl(BTRFS_IOCTL_SUBVOL_SETFLAGS);

Changelog for v3:

- Change to pass __u64 as ioctl parameter.

Changelog for v2:

- Add _GETFLAGS ioctl.
- Check if the passed fd is the root of a subvolume.
- Change the name from _SNAP_SETFLAGS to _SUBVOL_SETFLAGS.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |   83 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.h |    2 +
 2 files changed, 85 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f066ccb..ad19835 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1009,6 +1009,85 @@ out:
 	return ret;
 }
 
+static noinline int btrfs_ioctl_subvol_getflags(struct file *file,
+						void __user *arg)
+{
+	struct inode *inode = fdentry(file)->d_inode;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	int ret = 0;
+	u64 flags = 0;
+
+	if (inode->i_ino != BTRFS_FIRST_FREE_OBJECTID)
+		return -EINVAL;
+
+	down_read(&root->fs_info->subvol_sem);
+	if (btrfs_root_readonly(root))
+		flags |= BTRFS_SUBVOL_RDONLY;
+	up_read(&root->fs_info->subvol_sem);
+
+	if (copy_to_user(arg, &flags, sizeof(flags)))
+		ret = -EFAULT;
+
+	return ret;
+}
+
+static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
+					      void __user *arg)
+{
+	struct inode *inode = fdentry(file)->d_inode;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_trans_handle *trans;
+	u64 root_flags;
+	u64 flags;
+	int ret = 0;
+
+	if (root->fs_info->sb->s_flags & MS_RDONLY)
+		return -EROFS;
+
+	if (inode->i_ino != BTRFS_FIRST_FREE_OBJECTID)
+		return -EINVAL;
+
+	if (copy_from_user(&flags, arg, sizeof(flags)))
+		return -EFAULT;
+
+	if (flags & ~BTRFS_SUBVOL_CREATE_ASYNC)
+		return -EINVAL;
+
+	if (flags & ~BTRFS_SUBVOL_RDONLY)
+		return -EOPNOTSUPP;
+
+	down_write(&root->fs_info->subvol_sem);
+
+	/* nothing to do */
+	if (!!(flags & BTRFS_SUBVOL_RDONLY) == btrfs_root_readonly(root))
+		goto out;
+
+	root_flags = btrfs_root_flags(&root->root_item);
+	if (flags & BTRFS_SUBVOL_RDONLY)
+		btrfs_set_root_flags(&root->root_item,
+				     root_flags | BTRFS_ROOT_SUBVOL_RDONLY);
+	else
+		btrfs_set_root_flags(&root->root_item,
+				     root_flags & ~BTRFS_ROOT_SUBVOL_RDONLY);
+
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out_reset;
+	}
+
+	ret = btrfs_update_root(trans, root,
+				&root->root_key, &root->root_item);
+
+	btrfs_commit_transaction(trans, root);
+out_reset:
+	if (ret)
+		btrfs_set_root_flags(&root->root_item, root_flags);
+out:
+	up_write(&root->fs_info->subvol_sem);
+	return ret;
+}
+
 /*
  * helper to check if the subvolume references other subvolumes
  */
@@ -2282,6 +2361,10 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_snap_create(file, argp, 1);
 	case BTRFS_IOC_SNAP_DESTROY:
 		return btrfs_ioctl_snap_destroy(file, argp);
+	case BTRFS_IOC_SUBVOL_GETFLAGS:
+		return btrfs_ioctl_subvol_getflags(file, argp);
+	case BTRFS_IOC_SUBVOL_SETFLAGS:
+		return btrfs_ioctl_subvol_setflags(file, argp);
 	case BTRFS_IOC_DEFAULT_SUBVOL:
 		return btrfs_ioctl_default_subvol(file, argp);
 	case BTRFS_IOC_DEFRAG:
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 52ae489..1223223 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -194,4 +194,6 @@ struct btrfs_ioctl_space_args {
 #define BTRFS_IOC_WAIT_SYNC  _IOW(BTRFS_IOCTL_MAGIC, 22, __u64)
 #define BTRFS_IOC_SNAP_CREATE_V2 _IOW(BTRFS_IOCTL_MAGIC, 23, \
 				   struct btrfs_ioctl_vol_args_v2)
+#define BTRFS_IOC_SUBVOL_GETFLAGS _IOW(BTRFS_IOCTL_MAGIC, 25, __u64)
+#define BTRFS_IOC_SUBVOL_SETFLAGS _IOW(BTRFS_IOCTL_MAGIC, 26, __u64)
 #endif
-- 
1.6.3
