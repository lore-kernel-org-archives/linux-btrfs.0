Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:49183 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751637AbdIVGAF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Sep 2017 02:00:05 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 54C46AC0127
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Sep 2017 15:00:00 +0900 (JST)
Subject: [PATCH v2 3/3] btrfs: introduce new btrfs_mount()
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <anand.jain@oracle.com>
References: <afc0d4c0-e89c-9786-8583-e4bedaf9557e@jp.fujitsu.com>
Message-ID: <66665dfc-2a24-8c34-8662-6b87ba681d06@jp.fujitsu.com>
Date: Fri, 22 Sep 2017 14:59:55 +0900
MIME-Version: 1.0
In-Reply-To: <afc0d4c0-e89c-9786-8583-e4bedaf9557e@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce new btrfs_mount() using previous setups.

This will do:
(1) parse subvol id related options for later use in mount_subtree()
(2) mount device's root by calling vfs_kern_mount() with
    btrfs_root_fs_type. As a result, mount_root() is called
(3) return by calling mount_subtree()

The code of (2) is moved from the first part of mount_subvol().
setup_root_args() is deleted as not needed anymore.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 fs/btrfs/super.c | 132 ++++++++++++++++++++++++-------------------------------
 1 file changed, 58 insertions(+), 74 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 9498743..47c0692 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1367,85 +1367,13 @@ static inline int is_subvolume_inode(struct inode *inode)
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
@@ -1501,7 +1429,6 @@ static struct dentry *mount_subvol(const char *subvol_name, u64 subvol_objectid,
 
 out:
 	mntput(mnt);
-	kfree(newargs);
 	kfree(subvol_name);
 	return root;
 }
@@ -1665,6 +1592,63 @@ static struct dentry *mount_root(struct file_system_type *fs_type, int flags,
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
-- 
2.9.5

