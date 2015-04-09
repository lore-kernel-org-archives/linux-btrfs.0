Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:36392 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbbDIVf0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Apr 2015 17:35:26 -0400
Received: by pabsx10 with SMTP id sx10so270114pab.3
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Apr 2015 14:35:25 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v2 3/6] Btrfs: clean up error handling in mount_subvol()
Date: Thu,  9 Apr 2015 14:34:53 -0700
Message-Id: <607a31672e1eb72dafbca88c816187dd3b0846a6.1428614837.git.osandov@osandov.com>
In-Reply-To: <cover.1428614837.git.osandov@osandov.com>
References: <cover.1428614837.git.osandov@osandov.com>
In-Reply-To: <cover.1428614837.git.osandov@osandov.com>
References: <cover.1428614837.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In preparation for new functionality in mount_subvol(), give it
ownership of subvol_name and tidy up the error paths.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 fs/btrfs/super.c | 61 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 33 insertions(+), 28 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index bac3c9a..ab100e5 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1167,55 +1167,61 @@ static struct dentry *mount_subvol(const char *subvol_name, int flags,
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
 
 	if (!IS_ERR(root) && !is_subvolume_inode(root->d_inode)) {
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
 
@@ -1301,9 +1307,8 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
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
2.3.5

