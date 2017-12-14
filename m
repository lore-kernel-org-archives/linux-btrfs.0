Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:65448 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750733AbdLNIYh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Dec 2017 03:24:37 -0500
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 81F0BAC010F
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Dec 2017 17:24:34 +0900 (JST)
Received: from g01jpexchkw36.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id 9B45932884E
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Dec 2017 17:24:33 +0900 (JST)
Subject: [PATCH v4 1/4] btrfs: add btrfs_mount_root() and new file_system_type
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
References: <7dbb897c-1f1d-b54b-0cea-2a1c6c1d5027@jp.fujitsu.com>
Message-ID: <6ca3533b-fb89-bbd8-822c-7d70dd7fd577@jp.fujitsu.com>
Date: Thu, 14 Dec 2017 17:24:30 +0900
MIME-Version: 1.0
In-Reply-To: <7dbb897c-1f1d-b54b-0cea-2a1c6c1d5027@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add btrfs_mount_root() and new file_system_type for preparation of cleanup
of btrfs_mount(). Code path is not changed yet.

btrfs_mount_root() is almost the same as current btrfs_mount(), but doesn't
have subvolume related part.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 fs/btrfs/super.c | 116 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 116 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 3a4dce153645..14189ad47466 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -66,6 +66,7 @@
 #include <trace/events/btrfs.h>
 
 static const struct super_operations btrfs_super_ops;
+static struct file_system_type btrfs_root_fs_type;
 static struct file_system_type btrfs_fs_type;
 
 static int btrfs_remount(struct super_block *sb, int *flags, char *data);
@@ -1555,6 +1556,112 @@ static int setup_security_options(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
+static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
+		int flags, const char *device_name, void *data)
+{
+	struct block_device *bdev = NULL;
+	struct super_block *s;
+	struct btrfs_fs_devices *fs_devices = NULL;
+	struct btrfs_fs_info *fs_info = NULL;
+	struct security_mnt_opts new_sec_opts;
+	fmode_t mode = FMODE_READ;
+	char *subvol_name = NULL;
+	u64 subvol_objectid = 0;
+	int error = 0;
+
+	if (!(flags & SB_RDONLY))
+		mode |= FMODE_WRITE;
+
+	error = btrfs_parse_early_options(data, mode, fs_type,
+					  &subvol_name, &subvol_objectid,
+					  &fs_devices);
+	if (error) {
+		kfree(subvol_name);
+		return ERR_PTR(error);
+	}
+
+	security_init_mnt_opts(&new_sec_opts);
+	if (data) {
+		error = parse_security_options(data, &new_sec_opts);
+		if (error)
+			return ERR_PTR(error);
+	}
+
+	error = btrfs_scan_one_device(device_name, mode, fs_type, &fs_devices);
+	if (error)
+		goto error_sec_opts;
+
+	/*
+	 * Setup a dummy root and fs_info for test/set super.  This is because
+	 * we don't actually fill this stuff out until open_ctree, but we need
+	 * it for searching for existing supers, so this lets us do that and
+	 * then open_ctree will properly initialize everything later.
+	 */
+	fs_info = kzalloc(sizeof(struct btrfs_fs_info), GFP_KERNEL);
+	if (!fs_info) {
+		error = -ENOMEM;
+		goto error_sec_opts;
+	}
+
+	fs_info->fs_devices = fs_devices;
+
+	fs_info->super_copy = kzalloc(BTRFS_SUPER_INFO_SIZE, GFP_KERNEL);
+	fs_info->super_for_commit = kzalloc(BTRFS_SUPER_INFO_SIZE, GFP_KERNEL);
+	security_init_mnt_opts(&fs_info->security_opts);
+	if (!fs_info->super_copy || !fs_info->super_for_commit) {
+		error = -ENOMEM;
+		goto error_fs_info;
+	}
+
+	error = btrfs_open_devices(fs_devices, mode, fs_type);
+	if (error)
+		goto error_fs_info;
+
+	if (!(flags & SB_RDONLY) && fs_devices->rw_devices == 0) {
+		error = -EACCES;
+		goto error_close_devices;
+	}
+
+	bdev = fs_devices->latest_bdev;
+	s = sget(fs_type, btrfs_test_super, btrfs_set_super, flags | SB_NOSEC,
+		 fs_info);
+	if (IS_ERR(s)) {
+		error = PTR_ERR(s);
+		goto error_close_devices;
+	}
+
+	if (s->s_root) {
+		btrfs_close_devices(fs_devices);
+		free_fs_info(fs_info);
+		if ((flags ^ s->s_flags) & SB_RDONLY)
+			error = -EBUSY;
+	} else {
+		snprintf(s->s_id, sizeof(s->s_id), "%pg", bdev);
+		btrfs_sb(s)->bdev_holder = fs_type;
+		error = btrfs_fill_super(s, fs_devices, data);
+	}
+	if (error) {
+		deactivate_locked_super(s);
+		goto error_sec_opts;
+	}
+
+	fs_info = btrfs_sb(s);
+	error = setup_security_options(fs_info, s, &new_sec_opts);
+	if (error) {
+		deactivate_locked_super(s);
+		goto error_sec_opts;
+	}
+
+	return dget(s->s_root);
+
+error_close_devices:
+	btrfs_close_devices(fs_devices);
+error_fs_info:
+	free_fs_info(fs_info);
+error_sec_opts:
+	security_free_mnt_opts(&new_sec_opts);
+	return ERR_PTR(error);
+}
 /*
  * Find a superblock for the given device / mount point.
  *
@@ -2174,6 +2281,15 @@ static struct file_system_type btrfs_fs_type = {
 	.kill_sb	= btrfs_kill_super,
 	.fs_flags	= FS_REQUIRES_DEV | FS_BINARY_MOUNTDATA,
 };
+
+static struct file_system_type btrfs_root_fs_type = {
+	.owner		= THIS_MODULE,
+	.name		= "btrfs",
+	.mount		= btrfs_mount_root,
+	.kill_sb	= btrfs_kill_super,
+	.fs_flags	= FS_REQUIRES_DEV | FS_BINARY_MOUNTDATA,
+};
+
 MODULE_ALIAS_FS("btrfs");
 
 static int btrfs_control_open(struct inode *inode, struct file *file)
-- 
2.13.6

