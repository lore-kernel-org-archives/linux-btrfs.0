Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:46310 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756331Ab2ETQGn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 May 2012 12:06:43 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 24/24] Btrfs: add qgroup inheritance
Date: Sun, 20 May 2012 18:06:35 +0200
Message-Id: <ae78a1e0e037ff4dc130b4fbaff8752f9c6e6bfd.1337525292.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
References: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
References: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Arne Jansen <sensille@gmx.net>

When creating a subvolume or snapshot, it is necessary
to initialize the qgroup account with a copy of some
other (tracking) qgroup. This patch adds parameters
to the ioctls to pass the information from which qgroup
to inherit.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/ioctl.c       |   59 ++++++++++++++++++++++++++++++++++-------------
 fs/btrfs/ioctl.h       |   11 ++++++++-
 fs/btrfs/transaction.c |    8 ++++++
 fs/btrfs/transaction.h |    1 +
 4 files changed, 61 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 869c335..c46ebdc 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -334,7 +334,8 @@ static noinline int btrfs_ioctl_fitrim(struct file *file, void __user *arg)
 static noinline int create_subvol(struct btrfs_root *root,
 				  struct dentry *dentry,
 				  char *name, int namelen,
-				  u64 *async_transid)
+				  u64 *async_transid,
+				  struct btrfs_qgroup_inherit **inherit)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_key key;
@@ -366,6 +367,11 @@ static noinline int create_subvol(struct btrfs_root *root,
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
+	ret = btrfs_qgroup_inherit(trans, root->fs_info, 0, objectid,
+				   inherit ? *inherit : NULL);
+	if (ret)
+		goto fail;
+
 	leaf = btrfs_alloc_free_block(trans, root, root->leafsize,
 				      0, objectid, NULL, 0, 0, 0);
 	if (IS_ERR(leaf)) {
@@ -482,7 +488,7 @@ fail:
 
 static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
 			   char *name, int namelen, u64 *async_transid,
-			   bool readonly)
+			   bool readonly, struct btrfs_qgroup_inherit **inherit)
 {
 	struct inode *inode;
 	struct btrfs_pending_snapshot *pending_snapshot;
@@ -500,6 +506,10 @@ static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
 	pending_snapshot->dentry = dentry;
 	pending_snapshot->root = root;
 	pending_snapshot->readonly = readonly;
+	if (inherit) {
+		pending_snapshot->inherit = *inherit;
+		*inherit = NULL;	/* take responsibility to free it */
+	}
 
 	trans = btrfs_start_transaction(root->fs_info->extent_root, 5);
 	if (IS_ERR(trans)) {
@@ -633,7 +643,8 @@ static inline int btrfs_may_create(struct inode *dir, struct dentry *child)
 static noinline int btrfs_mksubvol(struct path *parent,
 				   char *name, int namelen,
 				   struct btrfs_root *snap_src,
-				   u64 *async_transid, bool readonly)
+				   u64 *async_transid, bool readonly,
+				   struct btrfs_qgroup_inherit **inherit)
 {
 	struct inode *dir  = parent->dentry->d_inode;
 	struct dentry *dentry;
@@ -664,11 +675,11 @@ static noinline int btrfs_mksubvol(struct path *parent,
 		goto out_up_read;
 
 	if (snap_src) {
-		error = create_snapshot(snap_src, dentry,
-					name, namelen, async_transid, readonly);
+		error = create_snapshot(snap_src, dentry, name, namelen,
+					async_transid, readonly, inherit);
 	} else {
 		error = create_subvol(BTRFS_I(dir)->root, dentry,
-				      name, namelen, async_transid);
+				      name, namelen, async_transid, inherit);
 	}
 	if (!error)
 		fsnotify_mkdir(dir, dentry);
@@ -1367,11 +1378,9 @@ out:
 }
 
 static noinline int btrfs_ioctl_snap_create_transid(struct file *file,
-						    char *name,
-						    unsigned long fd,
-						    int subvol,
-						    u64 *transid,
-						    bool readonly)
+				char *name, unsigned long fd, int subvol,
+				u64 *transid, bool readonly,
+				struct btrfs_qgroup_inherit **inherit)
 {
 	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
 	struct file *src_file;
@@ -1395,7 +1404,7 @@ static noinline int btrfs_ioctl_snap_create_transid(struct file *file,
 
 	if (subvol) {
 		ret = btrfs_mksubvol(&file->f_path, name, namelen,
-				     NULL, transid, readonly);
+				     NULL, transid, readonly, inherit);
 	} else {
 		struct inode *src_inode;
 		src_file = fget(fd);
@@ -1414,7 +1423,7 @@ static noinline int btrfs_ioctl_snap_create_transid(struct file *file,
 		}
 		ret = btrfs_mksubvol(&file->f_path, name, namelen,
 				     BTRFS_I(src_inode)->root,
-				     transid, readonly);
+				     transid, readonly, inherit);
 		fput(src_file);
 	}
 out:
@@ -1434,7 +1443,7 @@ static noinline int btrfs_ioctl_snap_create(struct file *file,
 
 	ret = btrfs_ioctl_snap_create_transid(file, vol_args->name,
 					      vol_args->fd, subvol,
-					      NULL, false);
+					      NULL, false, NULL);
 
 	kfree(vol_args);
 	return ret;
@@ -1448,6 +1457,7 @@ static noinline int btrfs_ioctl_snap_create_v2(struct file *file,
 	u64 transid = 0;
 	u64 *ptr = NULL;
 	bool readonly = false;
+	struct btrfs_qgroup_inherit *inherit = NULL;
 
 	vol_args = memdup_user(arg, sizeof(*vol_args));
 	if (IS_ERR(vol_args))
@@ -1455,7 +1465,8 @@ static noinline int btrfs_ioctl_snap_create_v2(struct file *file,
 	vol_args->name[BTRFS_SUBVOL_NAME_MAX] = '\0';
 
 	if (vol_args->flags &
-	    ~(BTRFS_SUBVOL_CREATE_ASYNC | BTRFS_SUBVOL_RDONLY)) {
+	    ~(BTRFS_SUBVOL_CREATE_ASYNC | BTRFS_SUBVOL_RDONLY |
+	      BTRFS_SUBVOL_QGROUP_INHERIT)) {
 		ret = -EOPNOTSUPP;
 		goto out;
 	}
@@ -1464,10 +1475,21 @@ static noinline int btrfs_ioctl_snap_create_v2(struct file *file,
 		ptr = &transid;
 	if (vol_args->flags & BTRFS_SUBVOL_RDONLY)
 		readonly = true;
+	if (vol_args->flags & BTRFS_SUBVOL_QGROUP_INHERIT) {
+		if (vol_args->size > PAGE_CACHE_SIZE) {
+			ret = -EINVAL;
+			goto out;
+		}
+		inherit = memdup_user(vol_args->qgroup_inherit, vol_args->size);
+		if (IS_ERR(inherit)) {
+			ret = PTR_ERR(inherit);
+			goto out;
+		}
+	}
 
 	ret = btrfs_ioctl_snap_create_transid(file, vol_args->name,
-					      vol_args->fd, subvol,
-					      ptr, readonly);
+					      vol_args->fd, subvol, ptr,
+					      readonly, &inherit);
 
 	if (ret == 0 && ptr &&
 	    copy_to_user(arg +
@@ -1476,6 +1498,7 @@ static noinline int btrfs_ioctl_snap_create_v2(struct file *file,
 		ret = -EFAULT;
 out:
 	kfree(vol_args);
+	kfree(inherit);
 	return ret;
 }
 
@@ -3540,6 +3563,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_snap_create_v2(file, argp, 0);
 	case BTRFS_IOC_SUBVOL_CREATE:
 		return btrfs_ioctl_snap_create(file, argp, 1);
+	case BTRFS_IOC_SUBVOL_CREATE_V2:
+		return btrfs_ioctl_snap_create_v2(file, argp, 1);
 	case BTRFS_IOC_SNAP_DESTROY:
 		return btrfs_ioctl_snap_destroy(file, argp);
 	case BTRFS_IOC_SUBVOL_GETFLAGS:
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index f7002c8..2b54e7a 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -32,6 +32,7 @@ struct btrfs_ioctl_vol_args {
 
 #define BTRFS_SUBVOL_CREATE_ASYNC	(1ULL << 0)
 #define BTRFS_SUBVOL_RDONLY		(1ULL << 1)
+#define BTRFS_SUBVOL_QGROUP_INHERIT	(1ULL << 2)
 #define BTRFS_FSID_SIZE 16
 #define BTRFS_UUID_SIZE 16
 
@@ -64,7 +65,13 @@ struct btrfs_ioctl_vol_args_v2 {
 	__s64 fd;
 	__u64 transid;
 	__u64 flags;
-	__u64 unused[4];
+	union {
+		struct {
+			__u64 size;
+			struct btrfs_qgroup_inherit __user *qgroup_inherit;
+		};
+		__u64 unused[4];
+	};
 	char name[BTRFS_SUBVOL_NAME_MAX + 1];
 };
 
@@ -353,6 +360,8 @@ struct btrfs_ioctl_qgroup_create_args {
 #define BTRFS_IOC_WAIT_SYNC  _IOW(BTRFS_IOCTL_MAGIC, 22, __u64)
 #define BTRFS_IOC_SNAP_CREATE_V2 _IOW(BTRFS_IOCTL_MAGIC, 23, \
 				   struct btrfs_ioctl_vol_args_v2)
+#define BTRFS_IOC_SUBVOL_CREATE_V2 _IOW(BTRFS_IOCTL_MAGIC, 24, \
+				   struct btrfs_ioctl_vol_args_v2)
 #define BTRFS_IOC_SUBVOL_GETFLAGS _IOW(BTRFS_IOCTL_MAGIC, 25, __u64)
 #define BTRFS_IOC_SUBVOL_SETFLAGS _IOW(BTRFS_IOCTL_MAGIC, 26, __u64)
 #define BTRFS_IOC_SCRUB _IOWR(BTRFS_IOCTL_MAGIC, 27, \
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 69b52bd..ce93f92 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -969,6 +969,14 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 		}
 	}
 
+	ret = btrfs_qgroup_inherit(trans, fs_info, root->root_key.objectid,
+				   objectid, pending->inherit);
+	kfree(pending->inherit);
+	if (ret) {
+		pending->error = ret;
+		goto fail;
+	}
+
 	key.objectid = objectid;
 	key.offset = (u64)-1;
 	key.type = BTRFS_ROOT_ITEM_KEY;
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index addfa2d..37c3d9d 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -70,6 +70,7 @@ struct btrfs_pending_snapshot {
 	struct dentry *dentry;
 	struct btrfs_root *root;
 	struct btrfs_root *snap;
+	struct btrfs_qgroup_inherit *inherit;
 	/* block reservation for the operation */
 	struct btrfs_block_rsv block_rsv;
 	/* extra metadata reseration for relocation */
-- 
1.7.3.4

