Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42623 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbaCXX6h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Mar 2014 19:58:37 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 2BBACACCC
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Mar 2014 23:58:36 +0000 (UTC)
Message-ID: <5330C6A8.5050206@suse.com>
Date: Mon, 24 Mar 2014 19:58:32 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: David Sterba <dsterba@suse.cz>, Arvin Schnell <aschnell@suse.de>
Subject: [PATCH] btrfs: extend BTRFS_IOC_SNAP_CREATE_V2 to snapshot by subvolid
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The BTRFS_IOC_SNAP_CREATE_V2 ioctl is limited by requiring that a file
descriptor be passed in order to create the snapshot. This means that
snapshots may only be created of trees that are available in the mounted
namespace. We have a need to create snapshots from subvolumes outside
of the namespace. This is already possible by mounting the numbered
subvolume by ID on a separate mount point, creating the snapshot, and
unmounting it. That's a tedious and unnecessary process since the ioctl
can be extended so easily.

This patch adds a new BTRFS_SUBVOL_CREATE_SUBVOLID flag that instructs
the ioctl to use the fd argument (which is now a union) as a subvolume
id instead. The subvolume ID is used to look up the root and instantiate
the inode so proper permission checking takes place.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ioctl.c           |   77 +++++++++++++++++++++++++++++++++++----------
 include/uapi/linux/btrfs.h |    6 ++-
 2 files changed, 65 insertions(+), 18 deletions(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1535,8 +1535,8 @@ out:
 }
 
 static noinline int btrfs_ioctl_snap_create_transid(struct file *file,
-				char *name, unsigned long fd, int subvol,
-				u64 *transid, bool readonly,
+				char *name, struct inode *src_inode,
+				int subvol, u64 *transid, bool readonly,
 				struct btrfs_qgroup_inherit *inherit)
 {
 	int namelen;
@@ -1562,14 +1562,6 @@ static noinline int btrfs_ioctl_snap_cre
 		ret = btrfs_mksubvol(&file->f_path, name, namelen,
 				     NULL, transid, readonly, inherit);
 	} else {
-		struct fd src = fdget(fd);
-		struct inode *src_inode;
-		if (!src.file) {
-			ret = -EINVAL;
-			goto out_drop_write;
-		}
-
-		src_inode = file_inode(src.file);
 		if (src_inode->i_sb != file_inode(file)->i_sb) {
 			btrfs_info(BTRFS_I(src_inode)->root->fs_info,
 				   "Snapshot src from another FS");
@@ -1585,7 +1577,6 @@ static noinline int btrfs_ioctl_snap_cre
 					     BTRFS_I(src_inode)->root,
 					     transid, readonly, inherit);
 		}
-		fdput(src);
 	}
 out_drop_write:
 	mnt_drop_write_file(file);
@@ -1597,6 +1588,7 @@ static noinline int btrfs_ioctl_snap_cre
 					    void __user *arg, int subvol)
 {
 	struct btrfs_ioctl_vol_args *vol_args;
+	struct fd src;
 	int ret;
 
 	vol_args = memdup_user(arg, sizeof(*vol_args));
@@ -1604,10 +1596,19 @@ static noinline int btrfs_ioctl_snap_cre
 		return PTR_ERR(vol_args);
 	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
 
+	if (!subvol) {
+		src = fdget(vol_args->fd);
+		if (!src.file) {
+			ret = -EINVAL;
+			goto out_free;
+		}
+	}
+
 	ret = btrfs_ioctl_snap_create_transid(file, vol_args->name,
-					      vol_args->fd, subvol,
+					      file_inode(src.file), subvol,
 					      NULL, false, NULL);
-
+	fdput(src);
+out_free:
 	kfree(vol_args);
 	return ret;
 }
@@ -1621,6 +1622,8 @@ static noinline int btrfs_ioctl_snap_cre
 	u64 *ptr = NULL;
 	bool readonly = false;
 	struct btrfs_qgroup_inherit *inherit = NULL;
+	struct fd src;
+	struct inode *src_inode = NULL;
 
 	vol_args = memdup_user(arg, sizeof(*vol_args));
 	if (IS_ERR(vol_args))
@@ -1629,7 +1632,7 @@ static noinline int btrfs_ioctl_snap_cre
 
 	if (vol_args->flags &
 	    ~(BTRFS_SUBVOL_CREATE_ASYNC | BTRFS_SUBVOL_RDONLY |
-	      BTRFS_SUBVOL_QGROUP_INHERIT)) {
+	      BTRFS_SUBVOL_QGROUP_INHERIT|BTRFS_SUBVOL_CREATE_SUBVOLID)) {
 		ret = -EOPNOTSUPP;
 		goto out;
 	}
@@ -1650,9 +1653,49 @@ static noinline int btrfs_ioctl_snap_cre
 		}
 	}
 
-	ret = btrfs_ioctl_snap_create_transid(file, vol_args->name,
-					      vol_args->fd, subvol, ptr,
-					      readonly, inherit);
+	if (!subvol) {
+		if (vol_args->flags & BTRFS_SUBVOL_CREATE_SUBVOLID) {
+			struct super_block *sb = file_inode(file)->i_sb;
+			struct btrfs_root *root;
+			struct btrfs_key location = {
+				.objectid = vol_args->subvolid,
+				.offset = -1,
+				.type = BTRFS_ROOT_ITEM_KEY,
+			};
+
+			root = btrfs_get_fs_root(btrfs_sb(sb), &location, true);
+			if (IS_ERR(root)) {
+				ret = PTR_ERR(root);
+				goto out;
+			}
+
+			location.objectid = btrfs_root_dirid(&root->root_item);
+			location.type = BTRFS_INODE_ITEM_KEY;
+			location.offset = 0;
+			src_inode = btrfs_iget(sb, &location, root, NULL);
+			if (IS_ERR(src_inode)) {
+				ret = PTR_ERR(src_inode);
+				goto out;
+			}
+		} else {
+			src = fdget(vol_args->fd);
+			if (!src.file) {
+				ret = -EINVAL;
+				goto out;
+			}
+			src_inode = file_inode(src.file);
+		}
+	}
+
+	ret = btrfs_ioctl_snap_create_transid(file, vol_args->name, src_inode,
+					      subvol, ptr, readonly, inherit);
+
+	if (!subvol) {
+		if (vol_args->flags & BTRFS_SUBVOL_CREATE_SUBVOLID)
+			iput(src_inode);
+		else
+			fdput(src);
+	}
 
 	if (ret == 0 && ptr &&
 	    copy_to_user(arg +
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -36,6 +36,7 @@ struct btrfs_ioctl_vol_args {
 #define BTRFS_SUBVOL_CREATE_ASYNC	(1ULL << 0)
 #define BTRFS_SUBVOL_RDONLY		(1ULL << 1)
 #define BTRFS_SUBVOL_QGROUP_INHERIT	(1ULL << 2)
+#define BTRFS_SUBVOL_CREATE_SUBVOLID	(1ULL << 3)
 #define BTRFS_FSID_SIZE 16
 #define BTRFS_UUID_SIZE 16
 
@@ -65,7 +66,10 @@ struct btrfs_ioctl_qgroup_limit_args {
 
 #define BTRFS_SUBVOL_NAME_MAX 4039
 struct btrfs_ioctl_vol_args_v2 {
-	__s64 fd;
+	union {
+		__s64 fd;
+		__u64 subvolid;
+	};
 	__u64 transid;
 	__u64 flags;
 	union {

-- 
Jeff Mahoney
SUSE Labs
