Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:40005 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751072AbdLNIZI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Dec 2017 03:25:08 -0500
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 7336EAC013D
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Dec 2017 17:25:05 +0900 (JST)
Received: from g01jpexchkw35.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw01.exch.g01.fujitsu.local (Postfix) with ESMTP id AF12769272E
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Dec 2017 17:25:04 +0900 (JST)
Subject: [PATCH v4 2/4] btrfs: cleanup btrfs_mount() using btrfs_mount_root()
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
References: <7dbb897c-1f1d-b54b-0cea-2a1c6c1d5027@jp.fujitsu.com>
Message-ID: <eba24d5a-d5ad-b928-27b8-3c7f0b6a0e43@jp.fujitsu.com>
Date: Thu, 14 Dec 2017 17:25:01 +0900
MIME-Version: 1.0
In-Reply-To: <7dbb897c-1f1d-b54b-0cea-2a1c6c1d5027@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Cleanup btrfs_mount() by using btrfs_mount_root(). This avoids getting
btrfs_mount() called twice in mount path.

Old btrfs_mount() will do:
0. VFS layer calls vfs_kern_mount() with registered file_system_type
   (for btrfs, btrfs_fs_type). btrfs_mount() is called on the way.
1. btrfs_parse_early_options() parses "subvolid=" mount option and set the
   value to subvol_objectid. Otherwise, subvol_objectid has the initial
   value of 0
2. check subvol_objectid is 5 or not. Assume this time id is not 5, then
   btrfs_mount() returns by calling mount_subvol()
3. In mount_subvol(), original mount options are modified to contain
   "subvolid=0" in setup_root_args(). Then, vfs_kern_mount() is called with
   btrfs_fs_type and new options
4. btrfs_mount() is called again
5. btrfs_parse_early_options() parses "subvolid=0" and set 5 (instead of 0)
   to subvol_objectid
6. check subvol_objectid is 5 or not. This time id is 5 and mount_subvol()
   is not called. btrfs_mount() finishes mounting a root
7. (in mount_subvol()) with using a return vale of vfs_kern_mount(), it
   calls mount_subtree()
8. return subvolume's dentry

Reusing the same file_system_type (and btrfs_mount()) for vfs_kern_mount()
is the cause of complication.

Instead, new btrfs_mount() will do:
1. parse subvol id related options for later use in mount_subvol()
2. mount device's root by calling vfs_kern_mount() with
   btrfs_root_fs_type, which is not registered to VFS by
   register_filesystem(). As a result, btrfs_mount_root() is called
3. return by calling mount_subvol()

The code of 2. is moved from the first part of mount_subvol().

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 fs/btrfs/super.c | 193 +++++++++++++++++++------------------------------------
 1 file changed, 65 insertions(+), 128 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 14189ad47466..ce93d87b2a69 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -66,6 +66,11 @@
 #include <trace/events/btrfs.h>
 
 static const struct super_operations btrfs_super_ops;
+/*
+ * btrfs_root_fs_type is used internally while
+ * btrfs_fs_type is used for VFS layer.
+ * See the comment at btrfs_mount for more detail.
+ */
 static struct file_system_type btrfs_root_fs_type;
 static struct file_system_type btrfs_fs_type;
 
@@ -1404,48 +1409,11 @@ static char *setup_root_args(char *args)
 
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
-		if (flags & SB_RDONLY) {
-			mnt = vfs_kern_mount(&btrfs_fs_type, flags & ~SB_RDONLY,
-					     device_name, newargs);
-		} else {
-			mnt = vfs_kern_mount(&btrfs_fs_type, flags | SB_RDONLY,
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
@@ -1501,7 +1469,6 @@ static struct dentry *mount_subvol(const char *subvol_name, u64 subvol_objectid,
 
 out:
 	mntput(mnt);
-	kfree(newargs);
 	kfree(subvol_name);
 	return root;
 }
@@ -1556,6 +1523,12 @@ static int setup_security_options(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
+/*
+ * Find a superblock for the given device / mount point.
+ *
+ * Note: This is based on mount_bdev from fs/super.c with a few additions
+ *       for multiple device setup.  Make sure to keep it in sync.
+ */
 static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
 		int flags, const char *device_name, void *data)
 {
@@ -1662,20 +1635,35 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
 	security_free_mnt_opts(&new_sec_opts);
 	return ERR_PTR(error);
 }
+
 /*
- * Find a superblock for the given device / mount point.
+ * Mount function which is called by VFS layer.
+ *
+ * In order to allow mounting a subvolume directly, btrfs uses
+ * mount_subtree() which needs vfsmount* of device's root (/).
+ * This means device's root has to be mounted internally in any case.
+ *
+ * Operation flow:
+ *   1. Parse subvol id related options for later use in mount_subvol().
+ *
+ *   2. Mount device's root (/) by calling vfs_kern_mount().
  *
- * Note:  This is based on get_sb_bdev from fs/super.c with a few additions
- *	  for multiple device setup.  Make sure to keep it in sync.
+ *      NOTE: vfs_kern_mount() is used by VFS to call btrfs_mount() in the
+ *      first place. In order to avoid calling btrfs_mount() again, we use
+ *      different file_system_type which is not registered to VFS by
+ *      register_filesystem() (btrfs_root_fs_type). As a result,
+ *      btrfs_mount_root() is called. The return value will be used by
+ *      mount_subtree() in mount_subvol().
+ *
+ *   3. Call mount_subvol() to get the dentry of subvolume. Since there is
+ *      "btrfs subvolume set-default", mount_subvol() is called always.
  */
 static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 		const char *device_name, void *data)
 {
-	struct block_device *bdev = NULL;
-	struct super_block *s;
 	struct btrfs_fs_devices *fs_devices = NULL;
-	struct btrfs_fs_info *fs_info = NULL;
-	struct security_mnt_opts new_sec_opts;
+	struct vfsmount *mnt_root;
+	struct dentry *root;
 	fmode_t mode = FMODE_READ;
 	char *subvol_name = NULL;
 	u64 subvol_objectid = 0;
@@ -1692,93 +1680,42 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 		return ERR_PTR(error);
 	}
 
-	if (subvol_name || subvol_objectid != BTRFS_FS_TREE_OBJECTID) {
-		/* mount_subvol() will free subvol_name. */
-		return mount_subvol(subvol_name, subvol_objectid, flags,
-				    device_name, data);
-	}
-
-	security_init_mnt_opts(&new_sec_opts);
-	if (data) {
-		error = parse_security_options(data, &new_sec_opts);
-		if (error)
-			return ERR_PTR(error);
-	}
-
-	error = btrfs_scan_one_device(device_name, mode, fs_type, &fs_devices);
-	if (error)
-		goto error_sec_opts;
-
-	/*
-	 * Setup a dummy root and fs_info for test/set super.  This is because
-	 * we don't actually fill this stuff out until open_ctree, but we need
-	 * it for searching for existing supers, so this lets us do that and
-	 * then open_ctree will properly initialize everything later.
-	 */
-	fs_info = kzalloc(sizeof(struct btrfs_fs_info), GFP_KERNEL);
-	if (!fs_info) {
-		error = -ENOMEM;
-		goto error_sec_opts;
-	}
-
-	fs_info->fs_devices = fs_devices;
-
-	fs_info->super_copy = kzalloc(BTRFS_SUPER_INFO_SIZE, GFP_KERNEL);
-	fs_info->super_for_commit = kzalloc(BTRFS_SUPER_INFO_SIZE, GFP_KERNEL);
-	security_init_mnt_opts(&fs_info->security_opts);
-	if (!fs_info->super_copy || !fs_info->super_for_commit) {
-		error = -ENOMEM;
-		goto error_fs_info;
-	}
-
-	error = btrfs_open_devices(fs_devices, mode, fs_type);
-	if (error)
-		goto error_fs_info;
-
-	if (!(flags & SB_RDONLY) && fs_devices->rw_devices == 0) {
-		error = -EACCES;
-		goto error_close_devices;
-	}
-
-	bdev = fs_devices->latest_bdev;
-	s = sget(fs_type, btrfs_test_super, btrfs_set_super, flags | SB_NOSEC,
-		 fs_info);
-	if (IS_ERR(s)) {
-		error = PTR_ERR(s);
-		goto error_close_devices;
-	}
+	/* mount device's root (/) */
+	mnt_root = vfs_kern_mount(&btrfs_root_fs_type, flags,
+					device_name, data);
+	if (PTR_ERR_OR_ZERO(mnt_root) == -EBUSY) {
+		if (flags & SB_RDONLY) {
+			mnt_root = vfs_kern_mount(&btrfs_root_fs_type,
+				flags & ~SB_RDONLY, device_name, data);
+		} else {
+			mnt_root = vfs_kern_mount(&btrfs_root_fs_type,
+				flags | SB_RDONLY, device_name, data);
+			if (IS_ERR(mnt_root)) {
+				root = ERR_CAST(mnt_root);
+				goto out;
+			}
 
-	if (s->s_root) {
-		btrfs_close_devices(fs_devices);
-		free_fs_info(fs_info);
-		if ((flags ^ s->s_flags) & SB_RDONLY)
-			error = -EBUSY;
-	} else {
-		snprintf(s->s_id, sizeof(s->s_id), "%pg", bdev);
-		btrfs_sb(s)->bdev_holder = fs_type;
-		error = btrfs_fill_super(s, fs_devices, data);
-	}
-	if (error) {
-		deactivate_locked_super(s);
-		goto error_sec_opts;
+			down_write(&mnt_root->mnt_sb->s_umount);
+			error = btrfs_remount(mnt_root->mnt_sb, &flags, NULL);
+			up_write(&mnt_root->mnt_sb->s_umount);
+			if (error < 0) {
+				root = ERR_PTR(error);
+				mntput(mnt_root);
+				goto out;
+			}
+		}
 	}
-
-	fs_info = btrfs_sb(s);
-	error = setup_security_options(fs_info, s, &new_sec_opts);
-	if (error) {
-		deactivate_locked_super(s);
-		goto error_sec_opts;
+	if (IS_ERR(mnt_root)) {
+		root = ERR_CAST(mnt_root);
+		goto out;
 	}
 
-	return dget(s->s_root);
+	/* mount_subvol() will free subvol_name and mnt_root */
+	root = mount_subvol(subvol_name, subvol_objectid, flags,
+				    device_name, data, mnt_root);
 
-error_close_devices:
-	btrfs_close_devices(fs_devices);
-error_fs_info:
-	free_fs_info(fs_info);
-error_sec_opts:
-	security_free_mnt_opts(&new_sec_opts);
-	return ERR_PTR(error);
+out:
+	return root;
 }
 
 static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
-- 
2.13.6

