From: Sage Weil <sage@newdream.net>
Subject: [PATCH 4/6] Btrfs: add SNAP_CREATE_ASYNC ioctl
Date: Mon, 25 Oct 2010 12:07:40 -0700
Message-ID: <1288033662-21464-5-git-send-email-sage@newdream.net>
References: <1288033662-21464-1-git-send-email-sage@newdream.net>
 <1288033662-21464-2-git-send-email-sage@newdream.net>
 <1288033662-21464-3-git-send-email-sage@newdream.net>
 <1288033662-21464-4-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1288033662-21464-4-git-send-email-sage@newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

Create a snap without waiting for it to commit to disk.  The ioctl is
ordered such that subsequent operations will not be contained by the
created snapshot, and the commit is initiated, but the ioctl does not
wait for the snapshot to commit to disk.

We return the specific transid to userspace so that an application can wait
for this specific snapshot creation to commit via the WAIT_SYNC ioctl.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/ioctl.c |   89 ++++++++++++++++++++++++++++++++++++++++++++++--------
 fs/btrfs/ioctl.h |    7 ++++
 2 files changed, 83 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 6306051..679b8a8 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -224,7 +224,8 @@ static int btrfs_ioctl_getversion(struct file *file, int __user *arg)
 
 static noinline int create_subvol(struct btrfs_root *root,
 				  struct dentry *dentry,
-				  char *name, int namelen)
+				  char *name, int namelen,
+				  u64 *async_transid)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_key key;
@@ -338,13 +339,19 @@ static noinline int create_subvol(struct btrfs_root *root,
 
 	d_instantiate(dentry, btrfs_lookup_dentry(dir, dentry));
 fail:
-	err = btrfs_commit_transaction(trans, root);
+	if (async_transid) {
+		*async_transid = trans->transid;
+		err = btrfs_commit_transaction_async(trans, root, 1);
+	} else {
+		err = btrfs_commit_transaction(trans, root);
+	}
 	if (err && !ret)
 		ret = err;
 	return ret;
 }
 
-static int create_snapshot(struct btrfs_root *root, struct dentry *dentry)
+static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
+			   char *name, int namelen, u64 *async_transid)
 {
 	struct inode *inode;
 	struct btrfs_pending_snapshot *pending_snapshot;
@@ -373,7 +380,14 @@ static int create_snapshot(struct btrfs_root *root, struct dentry *dentry)
 
 	list_add(&pending_snapshot->list,
 		 &trans->transaction->pending_snapshots);
-	ret = btrfs_commit_transaction(trans, root->fs_info->extent_root);
+	if (async_transid) {
+		*async_transid = trans->transid;
+		ret = btrfs_commit_transaction_async(trans,
+				     root->fs_info->extent_root, 1);
+	} else {
+		ret = btrfs_commit_transaction(trans,
+					       root->fs_info->extent_root);
+	}
 	BUG_ON(ret);
 
 	ret = pending_snapshot->error;
@@ -412,7 +426,8 @@ static inline int btrfs_may_create(struct inode *dir, struct dentry *child)
  */
 static noinline int btrfs_mksubvol(struct path *parent,
 				   char *name, int namelen,
-				   struct btrfs_root *snap_src)
+				   struct btrfs_root *snap_src,
+				   u64 *async_transid)
 {
 	struct inode *dir  = parent->dentry->d_inode;
 	struct dentry *dentry;
@@ -443,10 +458,11 @@ static noinline int btrfs_mksubvol(struct path *parent,
 		goto out_up_read;
 
 	if (snap_src) {
-		error = create_snapshot(snap_src, dentry);
+		error = create_snapshot(snap_src, dentry,
+					name, namelen, async_transid);
 	} else {
 		error = create_subvol(BTRFS_I(dir)->root, dentry,
-				      name, namelen);
+				      name, namelen, async_transid);
 	}
 	if (!error)
 		fsnotify_mkdir(dir, dentry);
@@ -801,8 +817,10 @@ out_unlock:
 	return ret;
 }
 
-static noinline int btrfs_ioctl_snap_create(struct file *file,
-					    void __user *arg, int subvol)
+static noinline int btrfs_ioctl_snap_create_transid(struct file *file,
+						    void __user *arg,
+						    int subvol,
+						    u64 *transid)
 {
 	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
 	struct btrfs_ioctl_vol_args *vol_args;
@@ -826,7 +844,7 @@ static noinline int btrfs_ioctl_snap_create(struct file *file,
 
 	if (subvol) {
 		ret = btrfs_mksubvol(&file->f_path, vol_args->name, namelen,
-				     NULL);
+				     NULL, transid);
 	} else {
 		struct inode *src_inode;
 		src_file = fget(vol_args->fd);
@@ -844,7 +862,8 @@ static noinline int btrfs_ioctl_snap_create(struct file *file,
 			goto out;
 		}
 		ret = btrfs_mksubvol(&file->f_path, vol_args->name, namelen,
-				     BTRFS_I(src_inode)->root);
+				     BTRFS_I(src_inode)->root,
+				     transid);
 		fput(src_file);
 	}
 out:
@@ -852,6 +871,48 @@ out:
 	return ret;
 }
 
+static noinline int btrfs_async_vol_args(void __user *arg,
+			     struct btrfs_ioctl_vol_args **vol_args,
+			     u64 __user **ptransid)
+{
+	struct btrfs_ioctl_async_vol_args *async_args;
+
+	async_args = memdup_user(arg, sizeof(*async_args));
+	if (IS_ERR(async_args))
+		return PTR_ERR(async_args);
+	*vol_args = async_args->args;
+	*ptransid = async_args->transid;
+	kfree(async_args);
+	return 0;
+}
+
+static noinline int btrfs_ioctl_snap_create(struct file *file,
+					    void __user *arg, int subvol,
+					    int async)
+{
+	struct btrfs_ioctl_vol_args *vol_args = arg;
+	u64 __user *ptransid = NULL;
+	u64 transid = 0;
+	int ret;
+
+	if (async) {
+		ret = btrfs_async_vol_args(arg, &vol_args, &ptransid);
+		if (ret < 0)
+			return ret;
+	}
+
+	ret = btrfs_ioctl_snap_create_transid(file, vol_args,
+					      subvol, &transid);
+
+	if (!ret && async && ptransid) {
+		if (copy_to_user(ptransid, &transid,
+				 sizeof(transid)))
+			return -EFAULT;
+	}
+
+	return ret;
+}
+
 /*
  * helper to check if the subvolume references other subvolumes
  */
@@ -2028,9 +2089,11 @@ long btrfs_ioctl(struct file *file, unsigned int
 	case FS_IOC_GETVERSION:
 		return btrfs_ioctl_getversion(file, argp);
 	case BTRFS_IOC_SNAP_CREATE:
-		return btrfs_ioctl_snap_create(file, argp, 0);
+		return btrfs_ioctl_snap_create(file, argp, 0, 0);
+	case BTRFS_IOC_SNAP_CREATE_ASYNC:
+		return btrfs_ioctl_snap_create(file, argp, 0, 1);
 	case BTRFS_IOC_SUBVOL_CREATE:
-		return btrfs_ioctl_snap_create(file, argp, 1);
+		return btrfs_ioctl_snap_create(file, argp, 1, 0);
 	case BTRFS_IOC_SNAP_DESTROY:
 		return btrfs_ioctl_snap_destroy(file, argp);
 	case BTRFS_IOC_DEFAULT_SUBVOL:
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index e9a2f7e..8f28626 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -30,6 +30,11 @@ struct btrfs_ioctl_vol_args {
 	char name[BTRFS_PATH_NAME_MAX + 1];
 };
 
+struct btrfs_ioctl_async_vol_args {
+	struct btrfs_ioctl_vol_args *args;
+	__u64 *transid;
+};
+
 #define BTRFS_INO_LOOKUP_PATH_MAX 4080
 struct btrfs_ioctl_ino_lookup_args {
 	__u64 treeid;
@@ -180,4 +185,6 @@ struct btrfs_ioctl_space_args {
 				    struct btrfs_ioctl_space_args)
 #define BTRFS_IOC_START_SYNC _IOR(BTRFS_IOCTL_MAGIC, 21, __u64)
 #define BTRFS_IOC_WAIT_SYNC  _IOW(BTRFS_IOCTL_MAGIC, 22, __u64)
+#define BTRFS_IOC_SNAP_CREATE_ASYNC _IOW(BTRFS_IOCTL_MAGIC, 23, \
+				   struct btrfs_ioctl_async_vol_args)
 #endif
-- 
1.6.6.1

