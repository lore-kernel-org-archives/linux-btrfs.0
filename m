Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm02.jp.fujitsu.com ([202.219.69.169]:41110 "EHLO
        mgwkm02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751637AbdIVF6r (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Sep 2017 01:58:47 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id C6E8BAC0138
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Sep 2017 14:58:43 +0900 (JST)
Subject: [PATCH v2 1/3] btrfs: change btrfs_mount() to mount_root()
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <anand.jain@oracle.com>
References: <afc0d4c0-e89c-9786-8583-e4bedaf9557e@jp.fujitsu.com>
Message-ID: <9dbf0a2a-8723-fc60-2d16-3b0911c17f4b@jp.fujitsu.com>
Date: Fri, 22 Sep 2017 14:58:38 +0900
MIME-Version: 1.0
In-Reply-To: <afc0d4c0-e89c-9786-8583-e4bedaf9557e@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove subvol related part from btrfs_mount() and change its name to
mount_root(). Also, file_system_type having mount_root() is defined
for the third patch.

New btrfs_mount() will be introduced in the third patch.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 fs/btrfs/super.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 12540b6..3c32677 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -66,6 +66,7 @@
 
 static const struct super_operations btrfs_super_ops;
 static struct file_system_type btrfs_fs_type;
+static struct file_system_type btrfs_root_fs_type;
 
 static int btrfs_remount(struct super_block *sb, int *flags, char *data);
 
@@ -1517,10 +1518,10 @@ static int setup_security_options(struct btrfs_fs_info *fs_info,
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
@@ -1529,27 +1530,17 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
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
@@ -2133,6 +2124,15 @@ static struct file_system_type btrfs_fs_type = {
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

