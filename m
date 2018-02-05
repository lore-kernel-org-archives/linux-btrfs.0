Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36058 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752583AbeBEIlV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Feb 2018 03:41:21 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7BCCEABC8
        for <linux-btrfs@vger.kernel.org>; Mon,  5 Feb 2018 08:41:19 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2 1/4] btrfs: Remove userspace transaction ioctls
Date: Mon,  5 Feb 2018 10:41:13 +0200
Message-Id: <1517820076-13613-1-git-send-email-nborisov@suse.com>
In-Reply-To: <1515590477-22878-1-git-send-email-nborisov@suse.com>
References: <1515590477-22878-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 3558d4f88ec8 ("btrfs: Deprecate userspace transaction ioctls")
marked the beginning of the end of userspace transaction. This commit
finishes the job!

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---

V2:
 * Also remove the usage of btrfs_ioctl_trans_end from btrfs_release_file so 
 that the patch compiles on its own as well.

 fs/btrfs/ctree.h |  1 -
 fs/btrfs/file.c  |  8 -----
 fs/btrfs/ioctl.c | 95 --------------------------------------------------------
 3 files changed, 104 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1a462ab85c49..6a4752177ad8 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3193,7 +3193,6 @@ void btrfs_destroy_inode(struct inode *inode);
 int btrfs_drop_inode(struct inode *inode);
 int __init btrfs_init_cachep(void);
 void btrfs_destroy_cachep(void);
-long btrfs_ioctl_trans_end(struct file *file);
 struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
 			 struct btrfs_root *root, int *was_new);
 struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index cba2ac371ce0..101e0c7fea92 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1996,8 +1996,6 @@ int btrfs_release_file(struct inode *inode, struct file *filp)
 {
 	struct btrfs_file_private *private = filp->private_data;
 
-	if (private && private->trans)
-		btrfs_ioctl_trans_end(filp);
 	if (private && private->filldir_buf)
 		kfree(private->filldir_buf);
 	kfree(private);
@@ -2189,12 +2187,6 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	}
 
 	/*
-	 * ok we haven't committed the transaction yet, lets do a commit
-	 */
-	if (file->private_data)
-		btrfs_ioctl_trans_end(file);
-
-	/*
 	 * We use start here because we will need to wait on the IO to complete
 	 * in btrfs_sync_log, which could require joining a transaction (for
 	 * example checking cross references in the nocow path).  If we use join
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f573cad72b7e..3094e079fc4f 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3935,73 +3935,6 @@ int btrfs_clone_file_range(struct file *src_file, loff_t off,
 	return btrfs_clone_files(dst_file, src_file, off, len, destoff);
 }
 
-/*
- * there are many ways the trans_start and trans_end ioctls can lead
- * to deadlocks.  They should only be used by applications that
- * basically own the machine, and have a very in depth understanding
- * of all the possible deadlocks and enospc problems.
- */
-static long btrfs_ioctl_trans_start(struct file *file)
-{
-	struct inode *inode = file_inode(file);
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct btrfs_trans_handle *trans;
-	struct btrfs_file_private *private;
-	int ret;
-	static bool warned = false;
-
-	ret = -EPERM;
-	if (!capable(CAP_SYS_ADMIN))
-		goto out;
-
-	if (!warned) {
-		btrfs_warn(fs_info,
-			"Userspace transaction mechanism is considered "
-			"deprecated and slated to be removed in 4.17. "
-			"If you have a valid use case please "
-			"speak up on the mailing list");
-		WARN_ON(1);
-		warned = true;
-	}
-
-	ret = -EINPROGRESS;
-	private = file->private_data;
-	if (private && private->trans)
-		goto out;
-	if (!private) {
-		private = kzalloc(sizeof(struct btrfs_file_private),
-				  GFP_KERNEL);
-		if (!private)
-			return -ENOMEM;
-		file->private_data = private;
-	}
-
-	ret = -EROFS;
-	if (btrfs_root_readonly(root))
-		goto out;
-
-	ret = mnt_want_write_file(file);
-	if (ret)
-		goto out;
-
-	atomic_inc(&fs_info->open_ioctl_trans);
-
-	ret = -ENOMEM;
-	trans = btrfs_start_ioctl_transaction(root);
-	if (IS_ERR(trans))
-		goto out_drop;
-
-	private->trans = trans;
-	return 0;
-
-out_drop:
-	atomic_dec(&fs_info->open_ioctl_trans);
-	mnt_drop_write_file(file);
-out:
-	return ret;
-}
-
 static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
 {
 	struct inode *inode = file_inode(file);
@@ -4243,30 +4176,6 @@ static long btrfs_ioctl_space_info(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
-/*
- * there are many ways the trans_start and trans_end ioctls can lead
- * to deadlocks.  They should only be used by applications that
- * basically own the machine, and have a very in depth understanding
- * of all the possible deadlocks and enospc problems.
- */
-long btrfs_ioctl_trans_end(struct file *file)
-{
-	struct inode *inode = file_inode(file);
-	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct btrfs_file_private *private = file->private_data;
-
-	if (!private || !private->trans)
-		return -EINVAL;
-
-	btrfs_end_transaction(private->trans);
-	private->trans = NULL;
-
-	atomic_dec(&root->fs_info->open_ioctl_trans);
-
-	mnt_drop_write_file(file);
-	return 0;
-}
-
 static noinline long btrfs_ioctl_start_sync(struct btrfs_root *root,
 					    void __user *argp)
 {
@@ -5573,10 +5482,6 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_dev_info(fs_info, argp);
 	case BTRFS_IOC_BALANCE:
 		return btrfs_ioctl_balance(file, NULL);
-	case BTRFS_IOC_TRANS_START:
-		return btrfs_ioctl_trans_start(file);
-	case BTRFS_IOC_TRANS_END:
-		return btrfs_ioctl_trans_end(file);
 	case BTRFS_IOC_TREE_SEARCH:
 		return btrfs_ioctl_tree_search(file, argp);
 	case BTRFS_IOC_TREE_SEARCH_V2:
-- 
2.7.4

