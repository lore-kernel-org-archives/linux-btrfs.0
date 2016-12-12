Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wj0-f194.google.com ([209.85.210.194]:32813 "EHLO
        mail-wj0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753025AbcLLONo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Dec 2016 09:13:44 -0500
Received: by mail-wj0-f194.google.com with SMTP id kp2so11757861wjc.0
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Dec 2016 06:13:43 -0800 (PST)
From: Seraphime Kirkovski <kirkseraph@gmail.com>
To: clm@fb.com
Cc: jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        Seraphime Kirkovski <kirkseraph@gmail.com>
Subject: [PATCH] Btrfs: Coding style fixes
Date: Mon, 12 Dec 2016 15:10:05 +0100
Message-Id: <20161212141005.24071-1-kirkseraph@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Per Documentation/CodingStyle remove brackets on single expression
if statements, add missing spaces after `,` and around `=`,
remove unnecessary line continuations, add missing blank lines
after declarations and fix mixed spaces and tabs.

Signed-off-by: Seraphime Kirkovski <kirkseraph@gmail.com>
---
 fs/btrfs/ioctl.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7acbd2c..fc6dc14 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -200,9 +200,9 @@ static int btrfs_ioctl_getflags(struct file *file, void __user *arg)
 
 static int check_flags(unsigned int flags)
 {
-	if (flags & ~(FS_IMMUTABLE_FL | FS_APPEND_FL | \
-		      FS_NOATIME_FL | FS_NODUMP_FL | \
-		      FS_SYNC_FL | FS_DIRSYNC_FL | \
+	if (flags & ~(FS_IMMUTABLE_FL | FS_APPEND_FL |
+		      FS_NOATIME_FL | FS_NODUMP_FL |
+		      FS_SYNC_FL | FS_DIRSYNC_FL |
 		      FS_NOCOMP_FL | FS_COMPR_FL |
 		      FS_NOCOW_FL))
 		return -EOPNOTSUPP;
@@ -301,7 +301,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 		if (S_ISREG(mode)) {
 			if (inode->i_size == 0)
 				ip->flags &= ~(BTRFS_INODE_NODATACOW
-				             | BTRFS_INODE_NODATASUM);
+						| BTRFS_INODE_NODATASUM);
 		} else {
 			ip->flags &= ~BTRFS_INODE_NODATACOW;
 		}
@@ -394,7 +394,7 @@ static noinline int btrfs_ioctl_fitrim(struct file *file, void __user *arg)
 		q = bdev_get_queue(device->bdev);
 		if (blk_queue_discard(q)) {
 			num_devices++;
-			minlen = min((u64)q->limits.discard_granularity,
+			minlen = min_t(u64, q->limits.discard_granularity,
 				     minlen);
 		}
 	}
@@ -1464,9 +1464,8 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 		atomic_dec(&root->fs_info->async_submit_draining);
 	}
 
-	if (range->compress_type == BTRFS_COMPRESS_LZO) {
+	if (range->compress_type == BTRFS_COMPRESS_LZO)
 		btrfs_set_fs_incompat(root->fs_info, COMPRESS_LZO);
-	}
 
 	ret = defrag_count;
 
@@ -1659,6 +1658,7 @@ static noinline int btrfs_ioctl_snap_create_transid(struct file *file,
 	} else {
 		struct fd src = fdget(fd);
 		struct inode *src_inode;
+
 		if (!src.file) {
 			ret = -EINVAL;
 			goto out_drop_write;
@@ -2236,7 +2236,7 @@ static noinline int btrfs_search_path_in_tree(struct btrfs_fs_info *info,
 	struct btrfs_path *path;
 
 	if (dirid == BTRFS_FIRST_FREE_OBJECTID) {
-		name[0]='\0';
+		name[0] = '\0';
 		return 0;
 	}
 
@@ -2679,7 +2679,7 @@ static long btrfs_ioctl_add_dev(struct btrfs_root *root, void __user *arg)
 	ret = btrfs_init_new_device(root, vol_args->name);
 
 	if (!ret)
-		btrfs_info(root->fs_info, "disk added %s",vol_args->name);
+		btrfs_info(root->fs_info, "disk added %s", vol_args->name);
 
 	kfree(vol_args);
 out:
@@ -2773,7 +2773,7 @@ static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
 	mutex_unlock(&root->fs_info->volume_mutex);
 
 	if (!ret)
-		btrfs_info(root->fs_info, "disk deleted %s",vol_args->name);
+		btrfs_info(root->fs_info, "disk deleted %s", vol_args->name);
 	kfree(vol_args);
 out:
 	atomic_set(&root->fs_info->mutually_exclusive_operation_running, 0);
@@ -2927,6 +2927,7 @@ static int lock_extent_range(struct inode *inode, u64 off, u64 len,
 	 */
 	while (1) {
 		struct btrfs_ordered_extent *ordered;
+
 		lock_extent(&BTRFS_I(inode)->io_tree, off, off + len - 1);
 		ordered = btrfs_lookup_first_ordered_extent(inode,
 							    off + len - 1);
@@ -3895,11 +3896,10 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
 	if (S_ISDIR(src->i_mode) || S_ISDIR(inode->i_mode))
 		return -EISDIR;
 
-	if (!same_inode) {
+	if (!same_inode)
 		btrfs_double_inode_lock(src, inode);
-	} else {
+	else
 		inode_lock(src);
-	}
 
 	/* determine range to clone */
 	ret = -EINVAL;
@@ -4972,11 +4972,10 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
 	}
 
 	/* FIXME: check if the IDs really exist */
-	if (sa->create) {
+	if (sa->create)
 		ret = btrfs_create_qgroup(trans, root->fs_info, sa->qgroupid);
-	} else {
+	else
 		ret = btrfs_remove_qgroup(trans, root->fs_info, sa->qgroupid);
-	}
 
 	err = btrfs_end_transaction(trans, root);
 	if (err && !ret)
-- 
2.10.2

