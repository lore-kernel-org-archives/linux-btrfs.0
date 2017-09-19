Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm02.jp.fujitsu.com ([202.219.69.169]:38866 "EHLO
        mgwkm02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750733AbdISCF0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 22:05:26 -0400
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 05966AC00DE
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Sep 2017 11:05:14 +0900 (JST)
Received: from G01JPEXCHKW15.g01.fujitsu.local (G01JPEXCHKW15.g01.fujitsu.local [10.0.194.54])
        by g01jpfmpwkw01.exch.g01.fujitsu.local (Postfix) with ESMTP id 5E300692442
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Sep 2017 11:05:13 +0900 (JST)
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] btrfs: cleanup mount path
To: <linux-btrfs@vger.kernel.org>
Message-ID: <9ba19bc9-9562-23ba-ba6a-aa0820027538@jp.fujitsu.com>
Date: Tue, 19 Sep 2017 11:05:09 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Summary:
Cleanup mount path by avoiding calling btrfs_mount() twice.
This is for more understandable code and no functional change.

Explanation:
btrfs uses mount_subtree() to mount a subvolume directly.  This function
needs a vfsmount* of device's root (/), which is a return value of
vfs_kern_mount() (therefore root has to be mounted internally anyway).

Current approach of getting root's vfsmount* in mount time is a bit tricky:
1. mount systemcall calls vfs_kern_mount() on the way
2. btrfs_mount() is called 
3. btrfs_parse_early_options() parses "subvolid=" mount option and set the
   value to subvol_objectid. Otherwise, subvol_objectid has the initial
   value of 0
4. check subvol_objectid is 5 or not. This time id is not 5, and
   btrfs_mount() returns by calling mount_subvol()
5. In mount_subvol(), original mount options are modified to contain
   "subvolid=0" in setup_root_args(). Then, vfs_kern_mount() is called with
   this new options to get root's vfsmount*
6. btrfs_mount() is called again
7. btrfs_parse_early_options() parses "subvolid=0" and set 5 (instead of 0)
   to subvol_objectid
8. check subvol_objectid is 5 or not. This time id is 5 and mount_subvol()
   is not called. btrfs_mount() finishes mounting a root
9. (in mount_subvol()) with using a return vale of vfs_kern_mount(), it
   calls mount_subtree()
10 return subvolume's dentry

As illustrated above, calling btrfs_mount() twice complicates the problem.
Callback function of mount time (btrfs_mount()) is specified in struct
file_system_type which is passed to vfs_kern_mount(). Therefore, we can
avoid this by using another file_system_type for arguments of our
vfs_kern_mount() call. There is no need of modifying mount options.

In this approach: 
1. btrfs_mount() is called
2. parse "subvolid=" option and set the value to subvol_objectid
3. mount device's root by calling vfs_kern_mount() with different
   file_system_type specified. Then, different callback function is called
   (mount_root()). Most of this new function is the same as the original
   btrfs_mount()
4. return by calling mount_subtree()

I think this approach is the same as nfsv4, which is the only other
filesystem using mount_subtree() currently, and easy to understand.

Most of the change is done by just reorganizing the original code of
btrfs_mount()/mount_subvol() into btrfs_mount()/mount_subvol()/mount_root()

btrfs_parse_early_options() is split into two parts to avoid "device="
option will be handled twice (though it cause no harm). setup_root_args()
is deleted as not needed anymore.


Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 fs/btrfs/super.c | 226 ++++++++++++++++++++++++++++++-------------------------
 1 file changed, 123 insertions(+), 103 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 12540b6..3a183c0 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -66,6 +66,7 @@
 
 static const struct super_operations btrfs_super_ops;
 static struct file_system_type btrfs_fs_type;
+static struct file_system_type btrfs_root_fs_type;
 
 static int btrfs_remount(struct super_block *sb, int *flags, char *data);
 
@@ -447,7 +448,8 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 		case Opt_subvolrootid:
 		case Opt_device:
 			/*
-			 * These are parsed by btrfs_parse_early_options
+			 * These are parsed by btrfs_parse_subvol_options
+			 * and btrfs_parse_early_options
 			 * and can be happily ignored here.
 			 */
 			break;
@@ -854,11 +856,58 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
  * only when we need to allocate a new super block.
  */
 static int btrfs_parse_early_options(const char *options, fmode_t flags,
-		void *holder, char **subvol_name, u64 *subvol_objectid,
-		struct btrfs_fs_devices **fs_devices)
+		void *holder, struct btrfs_fs_devices **fs_devices)
 {
 	substring_t args[MAX_OPT_ARGS];
 	char *device_name, *opts, *orig, *p;
+	int error = 0;
+
+	if (!options)
+		return 0;
+
+	/*
+	 * strsep changes the string, duplicate it because btrfs_parse_options
+	 * gets called later
+	 */
+	opts = kstrdup(options, GFP_KERNEL);
+	if (!opts)
+		return -ENOMEM;
+	orig = opts;
+
+	while ((p = strsep(&opts, ",")) != NULL) {
+		int token;
+		if (!*p)
+			continue;
+
+		token = match_token(p, tokens, args);
+		switch (token) {
+		case Opt_device:
+			device_name = match_strdup(&args[0]);
+			if (!device_name) {
+				error = -ENOMEM;
+				goto out;
+			}
+			error = btrfs_scan_one_device(device_name,
+					flags, holder, fs_devices);
+			kfree(device_name);
+			if (error)
+				goto out;
+			break;
+		default:
+			break;
+		}
+	}
+
+out:
+	kfree(orig);
+	return error;
+}
+
+static int btrfs_parse_subvol_options(const char *options, fmode_t flags,
+		void *holder, char **subvol_name, u64 *subvol_objectid)
+{
+	substring_t args[MAX_OPT_ARGS];
+	char *opts, *orig, *p;
 	char *num = NULL;
 	int error = 0;
 
@@ -866,8 +915,8 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
 		return 0;
 
 	/*
-	 * strsep changes the string, duplicate it because parse_options
-	 * gets called twice
+	 * strsep changes the string, duplicate it because
+	 * btrfs_parse_early_options gets called later
 	 */
 	opts = kstrdup(options, GFP_KERNEL);
 	if (!opts)
@@ -906,18 +955,6 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
 		case Opt_subvolrootid:
 			pr_warn("BTRFS: 'subvolrootid' mount option is deprecated and has no effect\n");
 			break;
-		case Opt_device:
-			device_name = match_strdup(&args[0]);
-			if (!device_name) {
-				error = -ENOMEM;
-				goto out;
-			}
-			error = btrfs_scan_one_device(device_name,
-					flags, holder, fs_devices);
-			kfree(device_name);
-			if (error)
-				goto out;
-			break;
 		default:
 			break;
 		}
@@ -1325,85 +1362,13 @@ static inline int is_subvolume_inode(struct inode *inode)
 	return 0;
 }
 
-/*
- * This will add subvolid=0 to the argument string while removing any subvol=
- * and subvolid= arguments to make sure we get the top-level root for path
- * walking to the subvol we want.
- */
-static char *setup_root_args(char *args)
-{
-	char *buf, *dst, *sep;
-
-	if (!args)
-		return kstrdup("subvolid=0", GFP_NOFS);
-
-	/* The worst case is that we add ",subvolid=0" to the end. */
-	buf = dst = kmalloc(strlen(args) + strlen(",subvolid=0") + 1, GFP_NOFS);
-	if (!buf)
-		return NULL;
-
-	while (1) {
-		sep = strchrnul(args, ',');
-		if (!strstarts(args, "subvol=") &&
-		    !strstarts(args, "subvolid=")) {
-			memcpy(dst, args, sep - args);
-			dst += sep - args;
-			*dst++ = ',';
-		}
-		if (*sep)
-			args = sep + 1;
-		else
-			break;
-	}
-	strcpy(dst, "subvolid=0");
-
-	return buf;
-}
-
 static struct dentry *mount_subvol(const char *subvol_name, u64 subvol_objectid,
 				   int flags, const char *device_name,
-				   char *data)
+				   char *data, struct vfsmount *mnt)
 {
 	struct dentry *root;
-	struct vfsmount *mnt = NULL;
-	char *newargs;
 	int ret;
 
-	newargs = setup_root_args(data);
-	if (!newargs) {
-		root = ERR_PTR(-ENOMEM);
-		goto out;
-	}
-
-	mnt = vfs_kern_mount(&btrfs_fs_type, flags, device_name, newargs);
-	if (PTR_ERR_OR_ZERO(mnt) == -EBUSY) {
-		if (flags & MS_RDONLY) {
-			mnt = vfs_kern_mount(&btrfs_fs_type, flags & ~MS_RDONLY,
-					     device_name, newargs);
-		} else {
-			mnt = vfs_kern_mount(&btrfs_fs_type, flags | MS_RDONLY,
-					     device_name, newargs);
-			if (IS_ERR(mnt)) {
-				root = ERR_CAST(mnt);
-				mnt = NULL;
-				goto out;
-			}
-
-			down_write(&mnt->mnt_sb->s_umount);
-			ret = btrfs_remount(mnt->mnt_sb, &flags, NULL);
-			up_write(&mnt->mnt_sb->s_umount);
-			if (ret < 0) {
-				root = ERR_PTR(ret);
-				goto out;
-			}
-		}
-	}
-	if (IS_ERR(mnt)) {
-		root = ERR_CAST(mnt);
-		mnt = NULL;
-		goto out;
-	}
-
 	if (!subvol_name) {
 		if (!subvol_objectid) {
 			ret = get_default_subvol_objectid(btrfs_sb(mnt->mnt_sb),
@@ -1459,7 +1424,6 @@ static struct dentry *mount_subvol(const char *subvol_name, u64 subvol_objectid,
 
 out:
 	mntput(mnt);
-	kfree(newargs);
 	kfree(subvol_name);
 	return root;
 }
@@ -1517,10 +1481,10 @@ static int setup_security_options(struct btrfs_fs_info *fs_info,
 /*
  * Find a superblock for the given device / mount point.
  *
- * Note:  This is based on get_sb_bdev from fs/super.c with a few additions
+ * Note:  This is based on mount_bdev from fs/super.c with a few additions
  *	  for multiple device setup.  Make sure to keep it in sync.
  */
-static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
+static struct dentry *mount_root(struct file_system_type *fs_type, int flags,
 		const char *device_name, void *data)
 {
 	struct block_device *bdev = NULL;
@@ -1529,27 +1493,17 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 	struct btrfs_fs_info *fs_info = NULL;
 	struct security_mnt_opts new_sec_opts;
 	fmode_t mode = FMODE_READ;
-	char *subvol_name = NULL;
-	u64 subvol_objectid = 0;
 	int error = 0;
 
 	if (!(flags & MS_RDONLY))
 		mode |= FMODE_WRITE;
 
 	error = btrfs_parse_early_options(data, mode, fs_type,
-					  &subvol_name, &subvol_objectid,
 					  &fs_devices);
 	if (error) {
-		kfree(subvol_name);
 		return ERR_PTR(error);
 	}
 
-	if (subvol_name || subvol_objectid != BTRFS_FS_TREE_OBJECTID) {
-		/* mount_subvol() will free subvol_name. */
-		return mount_subvol(subvol_name, subvol_objectid, flags,
-				    device_name, data);
-	}
-
 	security_init_mnt_opts(&new_sec_opts);
 	if (data) {
 		error = parse_security_options(data, &new_sec_opts);
@@ -1633,6 +1587,63 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 	return ERR_PTR(error);
 }
 
+static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
+		const char *device_name, void *data)
+{
+	struct vfsmount *mnt_root;
+	struct dentry *root;
+	fmode_t mode = FMODE_READ;
+	char *subvol_name = NULL;
+	u64 subvol_objectid = 0;
+	int error = 0;
+
+	if (!(flags & MS_RDONLY))
+		mode |= FMODE_WRITE;
+
+	error = btrfs_parse_subvol_options(data, mode, fs_type,
+					  &subvol_name, &subvol_objectid);
+	if (error) {
+		kfree(subvol_name);
+		return ERR_PTR(error);
+	}
+
+	/* mount device's root (/) */
+	mnt_root = vfs_kern_mount(&btrfs_root_fs_type, flags, device_name, data);
+	if (PTR_ERR_OR_ZERO(mnt_root) == -EBUSY) {
+		if (flags & MS_RDONLY) {
+			mnt_root = vfs_kern_mount(&btrfs_root_fs_type, flags & ~MS_RDONLY,
+					     device_name, data);
+		} else {
+			mnt_root = vfs_kern_mount(&btrfs_root_fs_type, flags | MS_RDONLY,
+					     device_name, data);
+			if (IS_ERR(mnt_root)) {
+				root = ERR_CAST(mnt_root);
+				goto out;
+			}
+
+			down_write(&mnt_root->mnt_sb->s_umount);
+			error = btrfs_remount(mnt_root->mnt_sb, &flags, NULL);
+			up_write(&mnt_root->mnt_sb->s_umount);
+			if (error < 0) {
+				root = ERR_PTR(error);
+				mntput(mnt_root);
+				goto out;
+			}
+		}
+	}
+	if (IS_ERR(mnt_root)) {
+		root = ERR_CAST(mnt_root);
+		goto out;
+	}
+
+	/* mount_subvol() will free subvol_name and mnt_root */
+	root = mount_subvol(subvol_name, subvol_objectid, flags,
+				    device_name, data, mnt_root);
+
+out:
+	return root;
+}
+
 static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
 				     int new_pool_size, int old_pool_size)
 {
@@ -2133,6 +2144,15 @@ static struct file_system_type btrfs_fs_type = {
 	.kill_sb	= btrfs_kill_super,
 	.fs_flags	= FS_REQUIRES_DEV | FS_BINARY_MOUNTDATA,
 };
+
+static struct file_system_type btrfs_root_fs_type = {
+	.owner		= THIS_MODULE,
+	.name		= "btrfs",
+	.mount		= mount_root,
+	.kill_sb	= btrfs_kill_super,
+	.fs_flags	= FS_REQUIRES_DEV | FS_BINARY_MOUNTDATA,
+};
+
 MODULE_ALIAS_FS("btrfs");
 
 static int btrfs_control_open(struct inode *inode, struct file *file)
-- 
2.9.5

