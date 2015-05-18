Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34696 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbbERJQq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 May 2015 05:16:46 -0400
Received: by pabru16 with SMTP id ru16so144099031pab.1
        for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2015 02:16:45 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v3 3/6] Btrfs: clean up error handling in mount_subvol()
Date: Mon, 18 May 2015 02:16:28 -0700
Message-Id: <27552c486222b6a99a4a1b6eafc1e598638df4b0.1431939732.git.osandov@osandov.com>
In-Reply-To: <cover.1431939732.git.osandov@osandov.com>
References: <cover.1431939732.git.osandov@osandov.com>
In-Reply-To: <cover.1431939732.git.osandov@osandov.com>
References: <cover.1431939732.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In preparation for new functionality in mount_subvol(), give it
ownership of subvol_name and tidy up the error paths.

Reviewed-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 fs/btrfs/super.c | 61 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 33 insertions(+), 28 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b5d04e4..460e0ea 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1176,55 +1176,61 @@ static struct dentry *mount_subvol(const char *subvol_name, int flags,
 				   const char *device_name, char *data)
 {
 	struct dentry *root;
-	struct vfsmount *mnt;
+	struct vfsmount *mnt = NULL;
 	char *newargs;
+	int ret;
 
 	newargs = setup_root_args(data);
-	if (!newargs)
-		return ERR_PTR(-ENOMEM);
-	mnt = vfs_kern_mount(&btrfs_fs_type, flags, device_name,
-			     newargs);
+	if (!newargs) {
+		root = ERR_PTR(-ENOMEM);
+		goto out;
+	}
 
-	if (PTR_RET(mnt) == -EBUSY) {
+	mnt = vfs_kern_mount(&btrfs_fs_type, flags, device_name, newargs);
+	if (PTR_ERR_OR_ZERO(mnt) == -EBUSY) {
 		if (flags & MS_RDONLY) {
-			mnt = vfs_kern_mount(&btrfs_fs_type, flags & ~MS_RDONLY, device_name,
-					     newargs);
+			mnt = vfs_kern_mount(&btrfs_fs_type, flags & ~MS_RDONLY,
+					     device_name, newargs);
 		} else {
-			int r;
-			mnt = vfs_kern_mount(&btrfs_fs_type, flags | MS_RDONLY, device_name,
-					     newargs);
+			mnt = vfs_kern_mount(&btrfs_fs_type, flags | MS_RDONLY,
+					     device_name, newargs);
 			if (IS_ERR(mnt)) {
-				kfree(newargs);
-				return ERR_CAST(mnt);
+				root = ERR_CAST(mnt);
+				mnt = NULL;
+				goto out;
 			}
 
 			down_write(&mnt->mnt_sb->s_umount);
-			r = btrfs_remount(mnt->mnt_sb, &flags, NULL);
+			ret = btrfs_remount(mnt->mnt_sb, &flags, NULL);
 			up_write(&mnt->mnt_sb->s_umount);
-			if (r < 0) {
-				/* FIXME: release vfsmount mnt ??*/
-				kfree(newargs);
-				return ERR_PTR(r);
+			if (ret < 0) {
+				root = ERR_PTR(ret);
+				goto out;
 			}
 		}
 	}
-
-	kfree(newargs);
-
-	if (IS_ERR(mnt))
-		return ERR_CAST(mnt);
+	if (IS_ERR(mnt)) {
+		root = ERR_CAST(mnt);
+		mnt = NULL;
+		goto out;
+	}
 
 	root = mount_subtree(mnt, subvol_name);
+	/* mount_subtree() drops our reference on the vfsmount. */
+	mnt = NULL;
 
 	if (!IS_ERR(root) && !is_subvolume_inode(d_inode(root))) {
 		struct super_block *s = root->d_sb;
 		dput(root);
 		root = ERR_PTR(-EINVAL);
 		deactivate_locked_super(s);
-		printk(KERN_ERR "BTRFS: '%s' is not a valid subvolume\n",
-				subvol_name);
+		pr_err("BTRFS: '%s' is not a valid subvolume\n", subvol_name);
 	}
 
+out:
+	mntput(mnt);
+	kfree(newargs);
+	kfree(subvol_name);
 	return root;
 }
 
@@ -1310,9 +1316,8 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 	}
 
 	if (subvol_name) {
-		root = mount_subvol(subvol_name, flags, device_name, data);
-		kfree(subvol_name);
-		return root;
+		/* mount_subvol() will free subvol_name. */
+		return mount_subvol(subvol_name, flags, device_name, data);
 	}
 
 	security_init_mnt_opts(&new_sec_opts);
-- 
2.4.1

