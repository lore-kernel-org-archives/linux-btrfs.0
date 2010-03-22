From: Sage Weil <sage@newdream.net>
Subject: [PATCH 3/5] Btrfs: add SNAP_CREATE_ASYNC ioctl
Date: Mon, 22 Mar 2010 12:13:28 -0700
Message-ID: <1269285210-19085-4-git-send-email-sage@newdream.net>
References: <1269285210-19085-1-git-send-email-sage@newdream.net>
 <1269285210-19085-2-git-send-email-sage@newdream.net>
 <1269285210-19085-3-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1269285210-19085-3-git-send-email-sage@newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

Create a snap without waiting for it to commit to disk.  The ioctl is
ordered such that subsequent operations will not be contained by the
created snapshot, and the commit is initiated, but the ioctl does not
wait for the snapshot to commit to disk.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/ioctl.c |   41 +++++++++++++++++++++++++++++------------
 fs/btrfs/ioctl.h |    2 ++
 2 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 8e29712..7ea4ff0 100644
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
@@ -342,7 +343,12 @@ static noinline int create_subvol(struct btrfs_root *root,
 
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
 
@@ -351,7 +357,7 @@ fail:
 }
 
 static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
-			   char *name, int namelen)
+			   char *name, int namelen, u64 *async_transid)
 {
 	struct inode *inode;
 	struct btrfs_pending_snapshot *pending_snapshot;
@@ -392,7 +398,12 @@ static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
 	pending_snapshot->root = root;
 	list_add(&pending_snapshot->list,
 		 &trans->transaction->pending_snapshots);
-	ret = btrfs_commit_transaction(trans, root);
+	if (async_transid) {
+		*async_transid = trans->transid;
+		ret = btrfs_commit_transaction_async(trans, root, 1);
+	} else {
+		ret = btrfs_commit_transaction(trans, root);
+	}
 	BUG_ON(ret);
 	btrfs_unreserve_metadata_space(root, 6);
 
@@ -425,7 +436,8 @@ static inline int btrfs_may_create(struct inode *dir, struct dentry *child)
  */
 static noinline int btrfs_mksubvol(struct path *parent,
 				   char *name, int namelen,
-				   struct btrfs_root *snap_src)
+				   struct btrfs_root *snap_src,
+				   u64 *async_transid)
 {
 	struct inode *dir  = parent->dentry->d_inode;
 	struct dentry *dentry;
@@ -457,10 +469,10 @@ static noinline int btrfs_mksubvol(struct path *parent,
 
 	if (snap_src) {
 		error = create_snapshot(snap_src, dentry,
-					name, namelen);
+					name, namelen, async_transid);
 	} else {
 		error = create_subvol(BTRFS_I(dir)->root, dentry,
-				      name, namelen);
+				      name, namelen, async_transid);
 	}
 	if (!error)
 		fsnotify_mkdir(dir, dentry);
@@ -825,12 +837,14 @@ out_unlock:
 }
 
 static noinline int btrfs_ioctl_snap_create(struct file *file,
-					    void __user *arg, int subvol)
+					    void __user *arg, int subvol,
+					    int async)
 {
 	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
 	struct btrfs_ioctl_vol_args *vol_args;
 	struct file *src_file;
 	int namelen;
+	u64 transid = 0;
 	int ret = 0;
 
 	if (root->fs_info->sb->s_flags & MS_RDONLY)
@@ -849,7 +863,7 @@ static noinline int btrfs_ioctl_snap_create(struct file *file,
 
 	if (subvol) {
 		ret = btrfs_mksubvol(&file->f_path, vol_args->name, namelen,
-				     NULL);
+				     NULL, async ? &transid : NULL);
 	} else {
 		struct inode *src_inode;
 		src_file = fget(vol_args->fd);
@@ -867,7 +881,8 @@ static noinline int btrfs_ioctl_snap_create(struct file *file,
 			goto out;
 		}
 		ret = btrfs_mksubvol(&file->f_path, vol_args->name, namelen,
-				     BTRFS_I(src_inode)->root);
+				     BTRFS_I(src_inode)->root,
+				     async ? &transid : NULL);
 		fput(src_file);
 	}
 out:
@@ -2009,9 +2024,11 @@ long btrfs_ioctl(struct file *file, unsigned int
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
index e9a2f7e..d9169d8 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -180,4 +180,6 @@ struct btrfs_ioctl_space_args {
 				    struct btrfs_ioctl_space_args)
 #define BTRFS_IOC_START_SYNC _IOR(BTRFS_IOCTL_MAGIC, 21, __u64)
 #define BTRFS_IOC_WAIT_SYNC  _IOW(BTRFS_IOCTL_MAGIC, 22, __u64)
+#define BTRFS_IOC_SNAP_CREATE_ASYNC _IOW(BTRFS_IOCTL_MAGIC, 23, \
+				   struct btrfs_ioctl_vol_args)
 #endif
-- 
1.6.6.1

