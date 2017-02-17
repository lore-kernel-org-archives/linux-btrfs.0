Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33572 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934242AbdBQOn7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:43:59 -0500
Received: by mail-wr0-f193.google.com with SMTP id i10so5519522wrb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:43:53 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 05/38] btrfs: Make btrfs_i_size_write take btrfs_inode
Date: Fri, 17 Feb 2017 16:42:56 +0200
Message-Id: <1487342609-20652-6-git-send-email-nborisov@suse.com>
In-Reply-To: <1487342609-20652-1-git-send-email-nborisov@suse.com>
References: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/btrfs_inode.h      |  6 +++---
 fs/btrfs/delayed-inode.c    |  2 +-
 fs/btrfs/free-space-cache.c |  2 +-
 fs/btrfs/inode.c            | 19 +++++++++----------
 fs/btrfs/ioctl.c            |  4 ++--
 fs/btrfs/transaction.c      |  2 +-
 fs/btrfs/tree-log.c         |  2 +-
 7 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 819a6d27218a..46d117b77bd2 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -237,10 +237,10 @@ static inline u64 btrfs_ino(struct btrfs_inode *inode)
 	return ino;
 }
 
-static inline void btrfs_i_size_write(struct inode *inode, u64 size)
+static inline void btrfs_i_size_write(struct btrfs_inode *inode, u64 size)
 {
-	i_size_write(inode, size);
-	BTRFS_I(inode)->disk_i_size = size;
+	i_size_write(&inode->vfs_inode, size);
+	inode->disk_i_size = size;
 }
 
 static inline bool btrfs_is_free_space_inode(struct inode *inode)
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index f7a6ee5ccc80..1aff676f0e5b 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1790,7 +1790,7 @@ int btrfs_fill_inode(struct inode *inode, u32 *rdev)
 
 	i_uid_write(inode, btrfs_stack_inode_uid(inode_item));
 	i_gid_write(inode, btrfs_stack_inode_gid(inode_item));
-	btrfs_i_size_write(inode, btrfs_stack_inode_size(inode_item));
+	btrfs_i_size_write(BTRFS_I(inode), btrfs_stack_inode_size(inode_item));
 	inode->i_mode = btrfs_stack_inode_mode(inode_item);
 	set_nlink(inode, btrfs_stack_inode_nlink(inode_item));
 	inode_set_bytes(inode, btrfs_stack_inode_nbytes(inode_item));
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 1a131f7d6c1b..c0f313cbbbf2 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -260,7 +260,7 @@ int btrfs_truncate_free_space_cache(struct btrfs_trans_handle *trans,
 		btrfs_free_path(path);
 	}
 
-	btrfs_i_size_write(inode, 0);
+	btrfs_i_size_write(BTRFS_I(inode), 0);
 	truncate_pagecache(inode, 0);
 
 	/*
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a4ccfffa4082..5d5e9474b09b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3623,7 +3623,7 @@ static int btrfs_read_locked_inode(struct inode *inode)
 	set_nlink(inode, btrfs_inode_nlink(leaf, inode_item));
 	i_uid_write(inode, btrfs_inode_uid(leaf, inode_item));
 	i_gid_write(inode, btrfs_inode_gid(leaf, inode_item));
-	btrfs_i_size_write(inode, btrfs_inode_size(leaf, inode_item));
+	btrfs_i_size_write(BTRFS_I(inode), btrfs_inode_size(leaf, inode_item));
 
 	inode->i_atime.tv_sec = btrfs_timespec_sec(leaf, &inode_item->atime);
 	inode->i_atime.tv_nsec = btrfs_timespec_nsec(leaf, &inode_item->atime);
@@ -3994,8 +3994,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto out;
 
-	btrfs_i_size_write(&dir->vfs_inode,
-			dir->vfs_inode.i_size - name_len * 2);
+	btrfs_i_size_write(dir, dir->vfs_inode.i_size - name_len * 2);
 	inode_inc_iversion(&inode->vfs_inode);
 	inode_inc_iversion(&dir->vfs_inode);
 	inode->vfs_inode.i_ctime = dir->vfs_inode.i_mtime =
@@ -4143,7 +4142,7 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
-	btrfs_i_size_write(dir, dir->i_size - name_len * 2);
+	btrfs_i_size_write(BTRFS_I(dir), dir->i_size - name_len * 2);
 	inode_inc_iversion(dir);
 	dir->i_mtime = dir->i_ctime = current_time(dir);
 	ret = btrfs_update_inode_fallback(trans, root, dir);
@@ -4190,7 +4189,7 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 			BTRFS_I(d_inode(dentry)), dentry->d_name.name,
 			dentry->d_name.len);
 	if (!err) {
-		btrfs_i_size_write(inode, 0);
+		btrfs_i_size_write(BTRFS_I(inode), 0);
 		/*
 		 * Propagate the last_unlink_trans value of the deleted dir to
 		 * its parent directory. This is to prevent an unrecoverable
@@ -5220,7 +5219,7 @@ void btrfs_evict_inode(struct inode *inode)
 	rsv->failfast = 1;
 	global_rsv = &fs_info->global_block_rsv;
 
-	btrfs_i_size_write(inode, 0);
+	btrfs_i_size_write(BTRFS_I(inode), 0);
 
 	/*
 	 * This is a bit simpler than btrfs_truncate since we've already
@@ -6284,7 +6283,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 		return ret;
 	}
 
-	btrfs_i_size_write(parent_inode, parent_inode->i_size +
+	btrfs_i_size_write(BTRFS_I(parent_inode), parent_inode->i_size +
 			   name_len * 2);
 	inode_inc_iversion(parent_inode);
 	parent_inode->i_mtime = parent_inode->i_ctime =
@@ -6588,7 +6587,7 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	if (err)
 		goto out_fail_inode;
 
-	btrfs_i_size_write(inode, 0);
+	btrfs_i_size_write(BTRFS_I(inode), 0);
 	err = btrfs_update_inode(trans, root, inode);
 	if (err)
 		goto out_fail_inode;
@@ -9204,7 +9203,7 @@ int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
 	inode->i_fop = &btrfs_dir_file_operations;
 
 	set_nlink(inode, 1);
-	btrfs_i_size_write(inode, 0);
+	btrfs_i_size_write(BTRFS_I(inode), 0);
 	unlock_new_inode(inode);
 
 	err = btrfs_subvol_inherit_props(trans, new_root, parent_root);
@@ -10231,7 +10230,7 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 	inode_nohighmem(inode);
 	inode->i_mapping->a_ops = &btrfs_symlink_aops;
 	inode_set_bytes(inode, name_len);
-	btrfs_i_size_write(inode, name_len);
+	btrfs_i_size_write(BTRFS_I(inode), name_len);
 	err = btrfs_update_inode(trans, root, inode);
 	/*
 	 * Last step, add directory indexes for our symlink inode. This is the
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index be206285ba81..2c964acdc9fb 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -594,7 +594,7 @@ static noinline int create_subvol(struct inode *dir,
 		goto fail;
 	}
 
-	btrfs_i_size_write(dir, dir->i_size + namelen * 2);
+	btrfs_i_size_write(BTRFS_I(dir), dir->i_size + namelen * 2);
 	ret = btrfs_update_inode(trans, root, dir);
 	BUG_ON(ret);
 
@@ -3288,7 +3288,7 @@ static int clone_finish_inode_update(struct btrfs_trans_handle *trans,
 	if (endoff > destoff + olen)
 		endoff = destoff + olen;
 	if (endoff > inode->i_size)
-		btrfs_i_size_write(inode, endoff);
+		btrfs_i_size_write(BTRFS_I(inode), endoff);
 
 	ret = btrfs_update_inode(trans, root, inode);
 	if (ret) {
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 05c2bbff2a28..61b807de3e16 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1653,7 +1653,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 		goto fail;
 	}
 
-	btrfs_i_size_write(parent_inode, parent_inode->i_size +
+	btrfs_i_size_write(BTRFS_I(parent_inode), parent_inode->i_size +
 					 dentry->d_name.len * 2);
 	parent_inode->i_mtime = parent_inode->i_ctime =
 		current_time(parent_inode);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index a92a73139065..610fe04805b6 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1785,7 +1785,7 @@ static noinline int replay_one_name(struct btrfs_trans_handle *trans,
 out:
 	btrfs_release_path(path);
 	if (!ret && update_size) {
-		btrfs_i_size_write(dir, dir->i_size + name_len * 2);
+		btrfs_i_size_write(BTRFS_I(dir), dir->i_size + name_len * 2);
 		ret = btrfs_update_inode(trans, root, dir);
 	}
 	kfree(name);
-- 
2.7.4

