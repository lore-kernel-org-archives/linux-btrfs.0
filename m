Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33398 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbbDIVf1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Apr 2015 17:35:27 -0400
Received: by paboj16 with SMTP id oj16so405291pab.0
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Apr 2015 14:35:27 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v2 4/6] Btrfs: fail on mismatched subvol and subvolid mount options
Date: Thu,  9 Apr 2015 14:34:54 -0700
Message-Id: <40c40f7f26acb30eea471b8c7b7bc01cce74be4d.1428614837.git.osandov@osandov.com>
In-Reply-To: <cover.1428614837.git.osandov@osandov.com>
References: <cover.1428614837.git.osandov@osandov.com>
In-Reply-To: <cover.1428614837.git.osandov@osandov.com>
References: <cover.1428614837.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's nothing to stop a user from passing both subvol= and subvolid=
to mount, but if they don't refer to the same subvolume, someone is
going to be surprised at some point. Error out on this case, but allow
users to pass in both if they do match (which they could, for example,
get out of /proc/mounts).

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 fs/btrfs/super.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index ab100e5..20b470d 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1163,8 +1163,9 @@ static char *setup_root_args(char *args)
 	return buf;
 }
 
-static struct dentry *mount_subvol(const char *subvol_name, int flags,
-				   const char *device_name, char *data)
+static struct dentry *mount_subvol(const char *subvol_name, u64 subvol_objectid,
+				   int flags, const char *device_name,
+				   char *data)
 {
 	struct dentry *root;
 	struct vfsmount *mnt = NULL;
@@ -1210,12 +1211,26 @@ static struct dentry *mount_subvol(const char *subvol_name, int flags,
 	/* mount_subtree() drops our reference on the vfsmount. */
 	mnt = NULL;
 
-	if (!IS_ERR(root) && !is_subvolume_inode(root->d_inode)) {
+	if (!IS_ERR(root)) {
 		struct super_block *s = root->d_sb;
-		dput(root);
-		root = ERR_PTR(-EINVAL);
-		deactivate_locked_super(s);
-		pr_err("BTRFS: '%s' is not a valid subvolume\n", subvol_name);
+		u64 root_objectid = BTRFS_I(root->d_inode)->root->root_key.objectid;
+
+		ret = 0;
+		if (!is_subvolume_inode(root->d_inode)) {
+			pr_err("BTRFS: '%s' is not a valid subvolume\n",
+			       subvol_name);
+			ret = -EINVAL;
+		}
+		if (subvol_objectid && root_objectid != subvol_objectid) {
+			pr_err("BTRFS: subvol '%s' does not match subvolid %llu\n",
+			       subvol_name, subvol_objectid);
+			ret = -EINVAL;
+		}
+		if (ret) {
+			dput(root);
+			root = ERR_PTR(ret);
+			deactivate_locked_super(s);
+		}
 	}
 
 out:
@@ -1308,7 +1323,8 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 
 	if (subvol_name) {
 		/* mount_subvol() will free subvol_name. */
-		return mount_subvol(subvol_name, flags, device_name, data);
+		return mount_subvol(subvol_name, subvol_objectid, flags,
+				    device_name, data);
 	}
 
 	security_init_mnt_opts(&new_sec_opts);
-- 
2.3.5

