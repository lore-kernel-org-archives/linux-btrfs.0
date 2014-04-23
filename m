Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:58594 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077AbaDWNaQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 09:30:16 -0400
From: "J S, Ajesh" <ajesh.js@hp.com>
To: "clm@fb.com" <clm@fb.com>, "jbacik@fb.com" <jbacik@fb.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 001/001] btrfs: Mechanism to modify the permission of a
 subvolume
Date: Wed, 23 Apr 2014 13:28:01 +0000
Message-ID: <1C24A869E87C7B45BE3E2BB439AB8F8C0D13DAE0@G5W2738.americas.hpqcorp.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Ajesh JS <ajesh.js@hp.com>

This patch provides a mechanism to modify the permission of a subvolume in a btrfs file system
This helps to apply a policy of having read-write subvolume inside a read-only subvolume.
One use case is to have the whole root file system as a read-only subvolume and have /etc as a read-write subvolume inside.

Signed-off-by: Ajesh JS <ajesh.js@hp.com>
Reviewed-by: Liverance Fletcher <fletch@hp.com>; Clemenceau, <Matthieu matthieu.clemenceau@hp.com>
"-------------------------------------------------------------------------"
diff -rup linux-3.13.6/fs/btrfs/ioctl.c linux-3.13.6_btrfs/fs/btrfs/ioctl.c
--- linux-3.13.6/fs/btrfs/ioctl.c	2014-03-07 11:37:02.000000000 +0530
+++ linux-3.13.6_btrfs/fs/btrfs/ioctl.c	2014-03-19 14:25:28.375139699 +0530
@@ -1636,6 +1636,68 @@ out:
 	return ret;
 }
 
+static noinline int btrfs_ioctl_subvol_modify(struct file *file,
+						void __user *arg)
+{
+	struct btrfs_ioctl_vol_args_v2 *vol_args;
+	struct inode *inode = file_inode(file);
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_trans_handle *trans;
+	u64 root_flags;
+	u64 flags;
+	int ret = 0;
+
+	ret = mnt_want_write_file(file);
+	if (ret)
+		goto out;
+
+	if (btrfs_ino(inode) != BTRFS_FIRST_FREE_OBJECTID) {
+		ret = -EINVAL;
+		goto out_drop_write;
+	}
+	vol_args = memdup_user(arg, sizeof(*vol_args));
+	if (IS_ERR(vol_args))
+		goto out_drop_write;
+	vol_args->name[BTRFS_SUBVOL_NAME_MAX] = '\0';
+	flags = vol_args->flags;
+	if (!inode_owner_or_capable(inode)) {
+		ret = -EACCES;
+		goto out_drop_write;
+	}
+
+	down_write(&root->fs_info->subvol_sem);
+	root_flags = btrfs_root_flags(&root->root_item);
+
+	if (flags & BTRFS_SUBVOL_RDONLY) {
+		btrfs_set_root_flags(&root->root_item,
+					root_flags | BTRFS_ROOT_SUBVOL_RDONLY);
+		printk(KERN_INFO "Setting %s to ro\n", vol_args->name);
+	} else {
+		btrfs_set_root_flags(&root->root_item,
+					root_flags & ~BTRFS_ROOT_SUBVOL_RDONLY);
+		printk(KERN_INFO "Setting %s to rw\n", vol_args->name);
+	}
+
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out_reset;
+	}
+
+	ret = btrfs_update_root(trans, root->fs_info->tree_root,
+					&root->root_key, &root->root_item);
+	btrfs_commit_transaction(trans, root);
+
+out_reset:
+	if (ret)
+		btrfs_set_root_flags(&root->root_item, root_flags);
+	up_write(&root->fs_info->subvol_sem);
+out_drop_write:
+	mnt_drop_write_file(file);
+out:
+	return ret;
+}
+
 static noinline int btrfs_ioctl_subvol_getflags(struct file *file,
 						void __user *arg)
 {
@@ -4509,6 +4571,8 @@ long btrfs_ioctl(struct file *file, unsi
 		return btrfs_ioctl_snap_create(file, argp, 1);
 	case BTRFS_IOC_SUBVOL_CREATE_V2:
 		return btrfs_ioctl_snap_create_v2(file, argp, 1);
+	case BTRFS_IOC_SUBVOL_MODIFY:
+		return btrfs_ioctl_subvol_modify(file, argp);
 	case BTRFS_IOC_SNAP_DESTROY:
 		return btrfs_ioctl_snap_destroy(file, argp);
 	case BTRFS_IOC_SUBVOL_GETFLAGS:
diff -rup linux-3.13.6/include/uapi/linux/btrfs.h linux-3.13.6_btrfs/include/uapi/linux/btrfs.h
--- linux-3.13.6/include/uapi/linux/btrfs.h	2014-03-07 11:37:02.000000000 +0530
+++ linux-3.13.6_btrfs/include/uapi/linux/btrfs.h	2014-03-19 15:34:30.648255239 +0530
@@ -606,5 +606,7 @@ static inline char *btrfs_err_str(enum b
 				    struct btrfs_ioctl_dev_replace_args)
 #define BTRFS_IOC_FILE_EXTENT_SAME _IOWR(BTRFS_IOCTL_MAGIC, 54, \
 					 struct btrfs_ioctl_same_args)
+#define BTRFS_IOC_SUBVOL_MODIFY _IOW(BTRFS_IOCTL_MAGIC, 55, \
+				   struct btrfs_ioctl_vol_args_v2)
 
 #endif /* _UAPI_LINUX_BTRFS_H */
