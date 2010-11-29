From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 5/5] btrfs: Add ioctl to set snapshot readonly/writable
Date: Mon, 29 Nov 2010 16:03:55 +0800
Message-ID: <4CF35E6B.2030307@cn.fujitsu.com>
References: <4CF35E17.6050705@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CF35E17.6050705@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

This allows us to set a snapshot readonly or writable on the fly.

Usage:

Set BTRFS_SNAPSHOT_RDONLY/WRITABLE of btrfs_ioctl_vol_arg_v2->flags,
and then call ioctl(BTRFS_IOCTL_SNAP_SETFLAGS);

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |   88 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/ioctl.h |    3 ++
 2 files changed, 87 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7f9c571..34d8683 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -939,6 +939,24 @@ out:
 	return ret;
 }
 
+static int snap_check_flags(u64 flags, bool create)
+{
+	u64 valid_flags = BTRFS_SNAPSHOT_RDONLY | BTRFS_SNAPSHOT_WRITABLE;
+
+	if (create)
+		valid_flags |= BTRFS_SNAPSHOT_CREATE_ASYNC;
+
+	if (flags & valid_flags)
+		return -EINVAL;
+
+	/* readonly and writable are mutually exclusive */
+	if ((flags & BTRFS_SNAPSHOT_RDONLY) &&
+	    (flags & BTRFS_SNAPSHOT_WRITABLE))
+		return -EINVAL;
+
+	return 0;
+}
+
 static noinline int btrfs_ioctl_snap_create(struct file *file,
 					    void __user *arg, int subvol,
 					    bool v2)
@@ -957,11 +975,9 @@ static noinline int btrfs_ioctl_snap_create(struct file *file,
 		if (IS_ERR(vol_args_v2))
 			return PTR_ERR(vol_args_v2);
 
-		if (vol_args_v2->flags &
-		    ~(BTRFS_SNAPSHOT_CREATE_ASYNC | BTRFS_SNAPSHOT_RDONLY)) {
-			ret = -EINVAL;
+		ret = snap_check_flags(vol_args_v2->flags, true);
+		if (ret)
 			goto out;
-		}
 
 		name = vol_args_v2->name;
 		fd = vol_args_v2->fd;
@@ -995,6 +1011,65 @@ out:
 	return ret;
 }
 
+static noinline int btrfs_ioctl_snap_setflags(struct file *file,
+					      void __user *arg)
+{
+	struct inode *inode = fdentry(file)->d_inode;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_ioctl_vol_args_v2 *vol_args_v2;
+	u64 root_flags;
+	u64 flags;
+	int err;
+
+	if (root->fs_info->sb->s_flags & MS_RDONLY)
+		return -EROFS;
+
+	vol_args_v2 = memdup_user(arg, sizeof(*vol_args_v2));
+	if (IS_ERR(vol_args_v2))
+		return PTR_ERR(vol_args_v2);
+	flags = vol_args_v2->flags;
+
+	err = snap_check_flags(flags, false);
+	if (err)
+		goto out;
+
+	down_write(&root->fs_info->subvol_sem);
+
+	/* nothing to do */
+	if ((BTRFS_SNAPSHOT_RDONLY && root->readonly) ||
+	    (BTRFS_SNAPSHOT_WRITABLE && !root->readonly))
+		goto out_unlock;
+
+	root_flags = btrfs_root_flags(&root->root_item);
+	if (flags & BTRFS_SNAPSHOT_RDONLY) {
+		btrfs_set_root_flags(&root->root_item,
+				     root_flags | BTRFS_ROOT_SNAP_RDONLY);
+		root->readonly = true;
+	}
+	if (flags & BTRFS_SNAPSHOT_WRITABLE) {
+		btrfs_set_root_flags(&root->root_item,
+				     root_flags & ~BTRFS_ROOT_SNAP_RDONLY);
+		root->readonly = false;
+	}
+
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		err = PTR_ERR(trans);
+		goto out_unlock;
+	}
+
+	err = btrfs_update_root(trans, root,
+				&root->root_key, &root->root_item);
+
+	btrfs_commit_transaction(trans, root);
+out_unlock:
+	up_write(&root->fs_info->subvol_sem);
+out:
+	kfree(vol_args_v2);
+	return err;
+}
+
 /*
  * helper to check if the subvolume references other subvolumes
  */
@@ -1503,6 +1578,9 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
 	struct btrfs_ioctl_defrag_range_args *range;
 	int ret;
 
+	if (root->readonly)
+		return -EROFS;
+
 	ret = mnt_want_write(file->f_path.mnt);
 	if (ret)
 		return ret;
@@ -2266,6 +2344,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_snap_create(file, argp, 1, 0);
 	case BTRFS_IOC_SNAP_DESTROY:
 		return btrfs_ioctl_snap_destroy(file, argp);
+	case BTRFS_IOC_SNAP_SETFLAGS:
+		return btrfs_ioctl_snap_setflags(file, argp);
 	case BTRFS_IOC_DEFAULT_SUBVOL:
 		return btrfs_ioctl_default_subvol(file, argp);
 	case BTRFS_IOC_DEFRAG:
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index ff15fb2..559fd27 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -32,6 +32,7 @@ struct btrfs_ioctl_vol_args {
 
 #define BTRFS_SNAPSHOT_CREATE_ASYNC	(1ULL << 0)
 #define BTRFS_SNAPSHOT_RDONLY		(1ULL << 1)
+#define BTRFS_SNAPSHOT_WRITABLE		(1ULL << 2)
 
 #define BTRFS_SNAPSHOT_NAME_MAX 4039
 struct btrfs_ioctl_vol_args_v2 {
@@ -194,4 +195,6 @@ struct btrfs_ioctl_space_args {
 #define BTRFS_IOC_WAIT_SYNC  _IOW(BTRFS_IOCTL_MAGIC, 22, __u64)
 #define BTRFS_IOC_SNAP_CREATE_V2 _IOW(BTRFS_IOCTL_MAGIC, 23, \
 				   struct btrfs_ioctl_vol_args_v2)
+#define BTRFS_IOC_SNAP_SETFLAGS _IOW(BTRFS_IOCTL_MAGIC, 24, \
+				   struct btrfs_ioctl_vol_args_v2)
 #endif
-- 
1.6.3

