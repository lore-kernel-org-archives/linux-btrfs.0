Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:32903 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbbERJQr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 May 2015 05:16:47 -0400
Received: by padbw4 with SMTP id bw4so144024264pad.0
        for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2015 02:16:46 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v3 4/6] Btrfs: fail on mismatched subvol and subvolid mount options
Date: Mon, 18 May 2015 02:16:29 -0700
Message-Id: <700c0dd2e687adf196a986aa8a21d70f116c2cb0.1431939732.git.osandov@osandov.com>
In-Reply-To: <cover.1431939732.git.osandov@osandov.com>
References: <cover.1431939732.git.osandov@osandov.com>
In-Reply-To: <cover.1431939732.git.osandov@osandov.com>
References: <cover.1431939732.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's nothing to stop a user from passing both subvol= and subvolid=
to mount, but if they don't refer to the same subvolume, someone is
going to be surprised at some point. Error out on this case, but allow
users to pass in both if they do match (which they could, for example,
get out of /proc/mounts).

Reviewed-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 fs/btrfs/super.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 460e0ea..d3e312b 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1172,8 +1172,9 @@ static char *setup_root_args(char *args)
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
@@ -1219,12 +1220,27 @@ static struct dentry *mount_subvol(const char *subvol_name, int flags,
 	/* mount_subtree() drops our reference on the vfsmount. */
 	mnt = NULL;
 
-	if (!IS_ERR(root) && !is_subvolume_inode(d_inode(root))) {
+	if (!IS_ERR(root)) {
 		struct super_block *s = root->d_sb;
-		dput(root);
-		root = ERR_PTR(-EINVAL);
-		deactivate_locked_super(s);
-		pr_err("BTRFS: '%s' is not a valid subvolume\n", subvol_name);
+		struct inode *root_inode = d_inode(root);
+		u64 root_objectid = BTRFS_I(root_inode)->root->root_key.objectid;
+
+		ret = 0;
+		if (!is_subvolume_inode(root_inode)) {
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
@@ -1317,7 +1333,8 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 
 	if (subvol_name) {
 		/* mount_subvol() will free subvol_name. */
-		return mount_subvol(subvol_name, flags, device_name, data);
+		return mount_subvol(subvol_name, subvol_objectid, flags,
+				    device_name, data);
 	}
 
 	security_init_mnt_opts(&new_sec_opts);
-- 
2.4.1

