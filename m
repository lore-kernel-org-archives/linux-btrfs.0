Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:51320 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755105AbbBJK1v (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 05:27:51 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1AAR4Mm000975
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 18:27:04 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 5/7] btrfs: qgroup: Apply qgroup type to subvol creating.
Date: Tue, 10 Feb 2015 18:24:20 +0800
Message-ID: <1423563862-9151-10-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1423563862-9151-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1423563862-9151-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Although we have a type in each qgroup, the all qgroups
are created in a default mode. This patch provide a
method to user to specify the type of qgroup for a sub volume.

It uses an unused byte in btrfs_ioctl_vol_args_v2 to pass
a qgroup type from userspace to kernel. Then kernel can
create a qgroup with requested type to the subvolume.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c           | 38 ++++++++++++++++++++++++++++----------
 fs/btrfs/qgroup.c          |  9 ++++++---
 fs/btrfs/qgroup.h          |  2 +-
 fs/btrfs/transaction.c     |  2 +-
 include/uapi/linux/btrfs.h |  1 +
 5 files changed, 37 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b1f46e8..a6d83c4 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -432,7 +432,8 @@ static noinline int create_subvol(struct inode *dir,
 				  struct dentry *dentry,
 				  char *name, int namelen,
 				  u64 *async_transid,
-				  struct btrfs_qgroup_inherit *inherit)
+				  struct btrfs_qgroup_inherit *inherit,
+				  u8 qgroup_type)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_key key;
@@ -476,7 +477,7 @@ static noinline int create_subvol(struct inode *dir,
 	trans->block_rsv = &block_rsv;
 	trans->bytes_reserved = block_rsv.size;
 
-	ret = btrfs_qgroup_inherit(trans, root->fs_info, 0, objectid, inherit);
+	ret = btrfs_qgroup_inherit(trans, root->fs_info, 0, objectid, inherit, qgroup_type);
 	if (ret)
 		goto fail;
 
@@ -808,7 +809,8 @@ static noinline int btrfs_mksubvol(struct path *parent,
 				   char *name, int namelen,
 				   struct btrfs_root *snap_src,
 				   u64 *async_transid, bool readonly,
-				   struct btrfs_qgroup_inherit *inherit)
+				   struct btrfs_qgroup_inherit *inherit,
+				   u8 qgroup_type)
 {
 	struct inode *dir  = parent->dentry->d_inode;
 	struct dentry *dentry;
@@ -851,7 +853,7 @@ static noinline int btrfs_mksubvol(struct path *parent,
 					async_transid, readonly, inherit);
 	} else {
 		error = create_subvol(dir, dentry, name, namelen,
-				      async_transid, inherit);
+				      async_transid, inherit, qgroup_type);
 	}
 	if (!error)
 		fsnotify_mkdir(dir, dentry);
@@ -1594,7 +1596,8 @@ out:
 static noinline int btrfs_ioctl_snap_create_transid(struct file *file,
 				char *name, unsigned long fd, int subvol,
 				u64 *transid, bool readonly,
-				struct btrfs_qgroup_inherit *inherit)
+				struct btrfs_qgroup_inherit *inherit,
+				u8 qgroup_type)
 {
 	int namelen;
 	int ret = 0;
@@ -1617,7 +1620,8 @@ static noinline int btrfs_ioctl_snap_create_transid(struct file *file,
 
 	if (subvol) {
 		ret = btrfs_mksubvol(&file->f_path, name, namelen,
-				     NULL, transid, readonly, inherit);
+				     NULL, transid, readonly, inherit,
+				     qgroup_type);
 	} else {
 		struct fd src = fdget(fd);
 		struct inode *src_inode;
@@ -1640,7 +1644,8 @@ static noinline int btrfs_ioctl_snap_create_transid(struct file *file,
 		} else {
 			ret = btrfs_mksubvol(&file->f_path, name, namelen,
 					     BTRFS_I(src_inode)->root,
-					     transid, readonly, inherit);
+					     transid, readonly, inherit,
+					     qgroup_type);
 		}
 		fdput(src);
 	}
@@ -1663,7 +1668,8 @@ static noinline int btrfs_ioctl_snap_create(struct file *file,
 
 	ret = btrfs_ioctl_snap_create_transid(file, vol_args->name,
 					      vol_args->fd, subvol,
-					      NULL, false, NULL);
+					      NULL, false, NULL,
+					      BTRFS_QGROUP_TYPE_DEFAULT);
 
 	kfree(vol_args);
 	return ret;
@@ -1673,11 +1679,13 @@ static noinline int btrfs_ioctl_snap_create_v2(struct file *file,
 					       void __user *arg, int subvol)
 {
 	struct btrfs_ioctl_vol_args_v2 *vol_args;
+	struct btrfs_root *root = BTRFS_I(file_inode(file))->root;
 	int ret;
 	u64 transid = 0;
 	u64 *ptr = NULL;
 	bool readonly = false;
 	struct btrfs_qgroup_inherit *inherit = NULL;
+	u8 qgroup_type = 0;
 
 	vol_args = memdup_user(arg, sizeof(*vol_args));
 	if (IS_ERR(vol_args))
@@ -1707,9 +1715,19 @@ static noinline int btrfs_ioctl_snap_create_v2(struct file *file,
 		}
 	}
 
+	qgroup_type = vol_args->qgroup_type;
+	if (qgroup_type) {
+		if (!btrfs_fs_incompat(root->fs_info, QGROUP_TYPE)) {
+			ret = -EINVAL;
+			goto free_args;
+		}
+	} else {
+		qgroup_type = BTRFS_QGROUP_TYPE_DEFAULT;
+	}
+
 	ret = btrfs_ioctl_snap_create_transid(file, vol_args->name,
 					      vol_args->fd, subvol, ptr,
-					      readonly, inherit);
+					      readonly, inherit, qgroup_type);
 	if (ret)
 		goto free_inherit;
 
@@ -4674,7 +4692,7 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
 	}
 
 	/* FIXME: check if the IDs really exist */
-	if (sa->create) {
+	if (sa->create & 0x1) {
 		u8 type = (sa->create >> BTRFS_QGROUP_TYPE_SHIFT);
 		if (type) {
 			if (!btrfs_fs_incompat(root->fs_info, QGROUP_TYPE)) {
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 0129dae..ba1997f 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2262,7 +2262,7 @@ out:
  */
 int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 			 struct btrfs_fs_info *fs_info, u64 srcid, u64 objectid,
-			 struct btrfs_qgroup_inherit *inherit)
+			 struct btrfs_qgroup_inherit *inherit, u8 type)
 {
 	int ret = 0;
 	int i;
@@ -2273,6 +2273,9 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 	u32 level_size = 0;
 	u64 nums;
 
+	if (!type)
+		type = BTRFS_QGROUP_TYPE_DEFAULT;
+
 	mutex_lock(&fs_info->qgroup_ioctl_lock);
 	if (!fs_info->quota_enabled)
 		goto out;
@@ -2304,7 +2307,7 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 	/*
 	 * create a tracking group for the subvol itself
 	 */
-	ret = add_qgroup_item(trans, quota_root, objectid, BTRFS_QGROUP_TYPE_DEFAULT);
+	ret = add_qgroup_item(trans, quota_root, objectid, type);
 	if (ret)
 		goto out;
 
@@ -2347,7 +2350,7 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 
 	spin_lock(&fs_info->qgroup_lock);
 
-	dstgroup = add_qgroup_rb(fs_info, objectid, BTRFS_QGROUP_TYPE_DEFAULT);
+	dstgroup = add_qgroup_rb(fs_info, objectid, type);
 	if (IS_ERR(dstgroup)) {
 		ret = PTR_ERR(dstgroup);
 		goto unlock;
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 0be0548..52cfdc2 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -117,7 +117,7 @@ int btrfs_run_qgroups(struct btrfs_trans_handle *trans,
 		      struct btrfs_fs_info *fs_info);
 int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 			 struct btrfs_fs_info *fs_info, u64 srcid, u64 objectid,
-			 struct btrfs_qgroup_inherit *inherit);
+			 struct btrfs_qgroup_inherit *inherit, u8 type);
 int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes, u8 type);
 void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes, u8 type);
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 358f3ab..dfe2201 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1388,7 +1388,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_qgroup_inherit(trans, fs_info,
 				   root->root_key.objectid,
-				   objectid, pending->inherit);
+				   objectid, pending->inherit, 0);
 	if (ret) {
 		btrfs_abort_transaction(trans, root, ret);
 		goto fail;
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index d4014e6..cb7a882 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -73,6 +73,7 @@ struct btrfs_ioctl_vol_args_v2 {
 		struct {
 			__u64 size;
 			struct btrfs_qgroup_inherit __user *qgroup_inherit;
+			__u8 qgroup_type;
 		};
 		__u64 unused[4];
 	};
-- 
1.8.4.2

