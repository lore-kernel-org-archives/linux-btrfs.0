Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57366 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753104Ab2F2Jz3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jun 2012 05:55:29 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q5T9oU0H012674
	for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2012 17:50:51 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/3] Btrfs: add default support for subvol getflags
Date: Fri, 29 Jun 2012 17:59:53 +0800
Message-Id: <1340963995-32549-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is kernel side patch for 'btrfs subvolume get-default'.

Our 'btrfs subvolume get-default' did not work as wish, because we do not have
APIs to fetch the subvolume's default state.

This patch treats default state as a flag and returns it to user space.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |   37 +++++++++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.h |    1 +
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2cf6b1b..60fff96 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1487,6 +1487,39 @@ out:
 	return ret;
 }
 
+/* Return 1 for default, otherwise return 0. */
+static int btrfs_root_default(struct btrfs_root *root)
+{
+	struct btrfs_path *path;
+	struct btrfs_disk_key disk_key;
+	struct btrfs_key key;
+	struct btrfs_dir_item *di;
+	int is_default = 0;
+	u64 dir_id;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	dir_id = btrfs_super_root_dir(root->fs_info->super_copy);
+	di = btrfs_lookup_dir_item(NULL, root->fs_info->tree_root, path,
+				   dir_id, "default", 7, 0);
+	if (IS_ERR_OR_NULL(di)) {
+		btrfs_free_path(path);
+		printk(KERN_ERR "Umm, no default dir item!\n");
+		return -ENOENT;
+	}
+	btrfs_dir_item_key(path->nodes[0], di, &disk_key);
+	btrfs_disk_key_to_cpu(&key, &disk_key);
+	if (btrfs_comp_cpu_keys(&key, &root->root_key))
+		is_default = 0;
+	else
+		is_default = 1;
+
+	btrfs_free_path(path);
+	return is_default;
+}
+
 static noinline int btrfs_ioctl_subvol_getflags(struct file *file,
 						void __user *arg)
 {
@@ -1501,6 +1534,10 @@ static noinline int btrfs_ioctl_subvol_getflags(struct file *file,
 	down_read(&root->fs_info->subvol_sem);
 	if (btrfs_root_readonly(root))
 		flags |= BTRFS_SUBVOL_RDONLY;
+
+	ret = btrfs_root_default(root);
+	if (ret > 0)
+		flags |= BTRFS_SUBVOL_DEFAULT;
 	up_read(&root->fs_info->subvol_sem);
 
 	if (copy_to_user(arg, &flags, sizeof(flags)))
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 497c530..3186d2d 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -32,6 +32,7 @@ struct btrfs_ioctl_vol_args {
 
 #define BTRFS_SUBVOL_CREATE_ASYNC	(1ULL << 0)
 #define BTRFS_SUBVOL_RDONLY		(1ULL << 1)
+#define BTRFS_SUBVOL_DEFAULT		(1ULL << 2)
 #define BTRFS_FSID_SIZE 16
 #define BTRFS_UUID_SIZE 16
 
-- 
1.6.5.2

