Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:59307 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754037Ab2KZImq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Nov 2012 03:42:46 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id qAQ8gh7U006636
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2012 16:42:44 +0800
Message-ID: <50B32B9B.1010706@cn.fujitsu.com>
Date: Mon, 26 Nov 2012 16:43:07 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/9] Btrfs: get write access when setting the default subvolume
References: <50B32ABF.7040803@cn.fujitsu.com>
In-Reply-To: <50B32ABF.7040803@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When wen want to set the default subvolume, we must get write access, or
we will change the R/O file system.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c | 40 ++++++++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 5102747..7d0214b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2823,12 +2823,19 @@ static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
 	struct btrfs_disk_key disk_key;
 	u64 objectid = 0;
 	u64 dir_id;
+	int ret;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (copy_from_user(&objectid, argp, sizeof(objectid)))
-		return -EFAULT;
+	ret = mnt_want_write_file(file);
+	if (ret)
+		return ret;
+
+	if (copy_from_user(&objectid, argp, sizeof(objectid))) {
+		ret = -EFAULT;
+		goto out;
+	}
 
 	if (!objectid)
 		objectid = root->root_key.objectid;
@@ -2838,21 +2845,28 @@ static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
 	location.offset = (u64)-1;
 
 	new_root = btrfs_read_fs_root_no_name(root->fs_info, &location);
-	if (IS_ERR(new_root))
-		return PTR_ERR(new_root);
+	if (IS_ERR(new_root)) {
+		ret = PTR_ERR(new_root);
+		goto out;
+	}
 
-	if (btrfs_root_refs(&new_root->root_item) == 0)
-		return -ENOENT;
+	if (btrfs_root_refs(&new_root->root_item) == 0) {
+		ret = -ENOENT;
+		goto out;
+	}
 
 	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
 	path->leave_spinning = 1;
 
 	trans = btrfs_start_transaction(root, 1);
 	if (IS_ERR(trans)) {
 		btrfs_free_path(path);
-		return PTR_ERR(trans);
+		ret = PTR_ERR(trans);
+		goto out;
 	}
 
 	dir_id = btrfs_super_root_dir(root->fs_info->super_copy);
@@ -2863,7 +2877,8 @@ static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
 		btrfs_end_transaction(trans, root);
 		printk(KERN_ERR "Umm, you don't have the default dir item, "
 		       "this isn't going to work\n");
-		return -ENOENT;
+		ret = -ENOENT;
+		goto out;
 	}
 
 	btrfs_cpu_key_to_disk(&disk_key, &new_root->root_key);
@@ -2873,8 +2888,9 @@ static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
 
 	btrfs_set_fs_incompat(root->fs_info, DEFAULT_SUBVOL);
 	btrfs_end_transaction(trans, root);
-
-	return 0;
+out:
+	mnt_drop_write_file(file);
+	return ret;
 }
 
 void btrfs_get_block_group_info(struct list_head *groups_list,
-- 
1.7.11.7

