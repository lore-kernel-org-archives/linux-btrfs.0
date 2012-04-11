From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: inc iversion whenever we modify ctime
Date: Wed, 11 Apr 2012 13:25:37 -0400
Message-ID: <1334165137-3016-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The cthon tests are failing some because the iversion didn't change whenever
we do some operations.  Basically iversion needs to change anytime the ctime
would have changed, so go through and make everybody change their iversion
if we change their ctime.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |   11 +++++++++++
 fs/btrfs/ioctl.c |    2 ++
 fs/btrfs/xattr.c |    1 +
 3 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7d3dd2f..261021c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2752,6 +2752,8 @@ err:
 		goto out;
 
 	btrfs_i_size_write(dir, dir->i_size - name_len * 2);
+	inode_inc_iversion(inode);
+	inode_inc_iversion(dir);
 	inode->i_ctime = dir->i_mtime = dir->i_ctime = CURRENT_TIME;
 	btrfs_update_inode(trans, root, dir);
 out:
@@ -3089,6 +3091,7 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	}
 
 	btrfs_i_size_write(dir, dir->i_size - name_len * 2);
+	inode_inc_iversion(dir);
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
 	ret = btrfs_update_inode(trans, root, dir);
 	if (ret)
@@ -3638,6 +3641,7 @@ static int btrfs_setattr(struct dentry *dentry, struct iattr *attr)
 
 	if (attr->ia_valid) {
 		setattr_copy(inode, attr);
+		inode_inc_iversion(inode);
 		err = btrfs_dirty_inode(inode);
 
 		if (!err && attr->ia_valid & ATTR_MODE)
@@ -4720,6 +4724,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 
 	btrfs_i_size_write(parent_inode, parent_inode->i_size +
 			   name_len * 2);
+	inode_inc_iversion(parent_inode);
 	parent_inode->i_mtime = parent_inode->i_ctime = CURRENT_TIME;
 	ret = btrfs_update_inode(trans, root, parent_inode);
 	if (ret)
@@ -4927,6 +4932,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	}
 
 	btrfs_inc_nlink(inode);
+	inode_inc_iversion(inode);
 	inode->i_ctime = CURRENT_TIME;
 	ihold(inode);
 
@@ -7182,6 +7188,9 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (new_inode && new_inode->i_size && S_ISREG(old_inode->i_mode))
 		btrfs_add_ordered_operation(trans, root, old_inode);
 
+	inode_inc_iversion(old_dir);
+	inode_inc_iversion(new_dir);
+	inode_inc_iversion(old_inode);
 	old_dir->i_ctime = old_dir->i_mtime = ctime;
 	new_dir->i_ctime = new_dir->i_mtime = ctime;
 	old_inode->i_ctime = ctime;
@@ -7208,6 +7217,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	}
 
 	if (new_inode) {
+		inode_inc_iversion(new_inode);
 		new_inode->i_ctime = CURRENT_TIME;
 		if (unlikely(btrfs_ino(new_inode) ==
 			     BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)) {
@@ -7479,6 +7489,7 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 		cur_offset += ins.offset;
 		*alloc_hint = ins.objectid + ins.offset;
 
+		inode_inc_iversion(inode);
 		inode->i_ctime = CURRENT_TIME;
 		BTRFS_I(inode)->flags |= BTRFS_INODE_PREALLOC;
 		if (!(mode & FALLOC_FL_KEEP_SIZE) &&
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 18cc23d..a037290 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -261,6 +261,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	}
 
 	btrfs_update_iflags(inode);
+	inode_inc_iversion(inode);
 	inode->i_ctime = CURRENT_TIME;
 	ret = btrfs_update_inode(trans, root, inode);
 
@@ -2619,6 +2620,7 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 			btrfs_mark_buffer_dirty(leaf);
 			btrfs_release_path(path);
 
+			inode_inc_iversion(inode);
 			inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 
 			/*
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index e7a5659..3f4e2d6 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -196,6 +196,7 @@ int __btrfs_setxattr(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto out;
 
+	inode_inc_iversion(inode);
 	inode->i_ctime = CURRENT_TIME;
 	ret = btrfs_update_inode(trans, root, inode);
 	BUG_ON(ret);
-- 
1.7.7.6

