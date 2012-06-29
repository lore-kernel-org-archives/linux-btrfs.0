Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:54334 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751554Ab2F2Jza (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jun 2012 05:55:30 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q5T9oVmM012676
	for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2012 17:50:52 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/3] Btrfs: update subvol_getflags/setflags to know new args from user
Date: Fri, 29 Jun 2012 17:59:54 +0800
Message-Id: <1340963995-32549-2-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1340963995-32549-1-git-send-email-liubo2009@cn.fujitsu.com>
References: <1340963995-32549-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've modified 'btrfs subvolume list' to show a subvolume's attributes,
such as readonly and default, and adopted a new structure for args for
subvol_getflags/setflags.

So here is the kernel side update.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |  100 ++++++++++++++++++++++++++++++++++++++++-------------
 fs/btrfs/ioctl.h |    5 +++
 2 files changed, 80 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 60fff96..f9c2180 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1487,6 +1487,31 @@ out:
 	return ret;
 }
 
+static struct btrfs_root *__btrfs_subvol_get_root(struct btrfs_root *root,
+						  u64 root_id)
+{
+	struct btrfs_key root_key;
+	struct btrfs_root *root_ret = NULL;
+
+	if (root->objectid == root_id || !root_id) {
+		root_ret = root;
+		goto get_root;
+	}
+
+	root_key.objectid = root_id;
+	root_key.type = BTRFS_ROOT_ITEM_KEY;
+	root_key.offset = (u64)-1;
+	root_ret = btrfs_read_fs_root_no_name(root->fs_info, &root_key);
+	/* root_ret won't be NULL */
+	if (IS_ERR(root_ret))
+		return root_ret;
+get_root:
+	if (btrfs_root_refs(&root_ret->root_item) == 0)
+		return ERR_PTR(-ENOENT);
+
+	return root_ret;
+}
+
 /* Return 1 for default, otherwise return 0. */ 
 static int btrfs_root_default(struct btrfs_root *root)
 {
@@ -1525,24 +1550,38 @@ static noinline int btrfs_ioctl_subvol_getflags(struct file *file,
 {
 	struct inode *inode = fdentry(file)->d_inode;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_root *new_root = NULL;
 	int ret = 0;
-	u64 flags = 0;
+	struct btrfs_ioctl_get_set_flags_args *get_args;
 
 	if (btrfs_ino(inode) != BTRFS_FIRST_FREE_OBJECTID)
 		return -EINVAL;
 
-	down_read(&root->fs_info->subvol_sem);
-	if (btrfs_root_readonly(root))
-		flags |= BTRFS_SUBVOL_RDONLY;
+	get_args = memdup_user(arg, sizeof(*get_args));
+	if (IS_ERR(get_args))
+		return PTR_ERR(get_args);
 
-	ret = btrfs_root_default(root);
-	if (ret > 0)
-		flags |= BTRFS_SUBVOL_DEFAULT;
-	up_read(&root->fs_info->subvol_sem);
+	new_root = __btrfs_subvol_get_root(root, get_args->objectid);
+	if (IS_ERR(new_root)) {
+		ret = PTR_ERR(new_root);
+		goto out;
+	}
 
-	if (copy_to_user(arg, &flags, sizeof(flags)))
+	down_read(&new_root->fs_info->subvol_sem);
+	if (btrfs_root_readonly(new_root))
+		get_args->flags |= BTRFS_SUBVOL_RDONLY;
+	ret = btrfs_root_default(new_root);
+	if (ret > 0) {
+		get_args->flags |= BTRFS_SUBVOL_DEFAULT;
+		ret = 0;
+	}
+	up_read(&new_root->fs_info->subvol_sem);
+
+	if (copy_to_user(arg, get_args, sizeof(*get_args)))
 		ret = -EFAULT;
 
+out:
+	kfree(get_args);
 	return ret;
 }
 
@@ -1551,8 +1590,10 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
 {
 	struct inode *inode = fdentry(file)->d_inode;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_root *new_root = NULL;
 	struct btrfs_trans_handle *trans;
-	u64 root_flags;
+	struct btrfs_ioctl_get_set_flags_args *set_args = NULL;
+	u64 root_flags, new_root_flags;
 	u64 flags;
 	int ret = 0;
 
@@ -1565,11 +1606,19 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
 		goto out_drop_write;
 	}
 
-	if (copy_from_user(&flags, arg, sizeof(flags))) {
-		ret = -EFAULT;
+	set_args = memdup_user(arg, sizeof(*set_args));
+	if (IS_ERR(set_args)) {
+		ret = PTR_ERR(set_args);
+		goto out_drop_write;
+	}
+
+	new_root = __btrfs_subvol_get_root(root, set_args->objectid);
+	if (IS_ERR(new_root)) {
+		ret = PTR_ERR(new_root);
 		goto out_drop_write;
 	}
 
+	flags = set_args->flags;
 	if (flags & BTRFS_SUBVOL_CREATE_ASYNC) {
 		ret = -EINVAL;
 		goto out_drop_write;
@@ -1585,38 +1634,39 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
 		goto out_drop_write;
 	}
 
-	down_write(&root->fs_info->subvol_sem);
+	down_write(&new_root->fs_info->subvol_sem);
 
 	/* nothing to do */
-	if (!!(flags & BTRFS_SUBVOL_RDONLY) == btrfs_root_readonly(root))
+	if (!!(flags & BTRFS_SUBVOL_RDONLY) == btrfs_root_readonly(new_root))
 		goto out_drop_sem;
 
-	root_flags = btrfs_root_flags(&root->root_item);
+	new_root_flags = root_flags = btrfs_root_flags(&new_root->root_item);
 	if (flags & BTRFS_SUBVOL_RDONLY)
-		btrfs_set_root_flags(&root->root_item,
-				     root_flags | BTRFS_ROOT_SUBVOL_RDONLY);
+		new_root_flags |= BTRFS_ROOT_SUBVOL_RDONLY;
 	else
-		btrfs_set_root_flags(&root->root_item,
-				     root_flags & ~BTRFS_ROOT_SUBVOL_RDONLY);
+		new_root_flags &= ~BTRFS_ROOT_SUBVOL_RDONLY;
 
-	trans = btrfs_start_transaction(root, 1);
+	btrfs_set_root_flags(&new_root->root_item, new_root_flags);
+
+	trans = btrfs_start_transaction(new_root, 1);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		goto out_reset;
 	}
 
-	ret = btrfs_update_root(trans, root->fs_info->tree_root,
-				&root->root_key, &root->root_item);
+	ret = btrfs_update_root(trans, new_root->fs_info->tree_root,
+				&new_root->root_key, &new_root->root_item);
 
-	btrfs_commit_transaction(trans, root);
+	btrfs_commit_transaction(trans, new_root);
 out_reset:
 	if (ret)
-		btrfs_set_root_flags(&root->root_item, root_flags);
+		btrfs_set_root_flags(&new_root->root_item, root_flags);
 out_drop_sem:
-	up_write(&root->fs_info->subvol_sem);
+	up_write(&new_root->fs_info->subvol_sem);
 out_drop_write:
 	mnt_drop_write_file(file);
 out:
+	kfree(set_args);
 	return ret;
 }
 
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 3186d2d..1fa0ce2 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -45,6 +45,11 @@ struct btrfs_ioctl_vol_args_v2 {
 	char name[BTRFS_SUBVOL_NAME_MAX + 1];
 };
 
+struct btrfs_ioctl_get_set_flags_args {
+	__u64 objectid;
+	__u64 flags;
+};
+
 /*
  * structure to report errors and progress to userspace, either as a
  * result of a finished scrub, a canceled scrub or a progress inquiry
-- 
1.6.5.2

