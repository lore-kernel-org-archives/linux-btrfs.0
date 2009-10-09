From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH] Remove negative dentry when deleting subvolumne
Date: Fri, 09 Oct 2009 17:20:22 +0800
Message-ID: <4ACF0056.2090108@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The use of btrfs_dentry_delete is removing dentries from the
dcache when deleting subvolumne. btrfs_dentry_delete ignores
negative dentries. This is incorrect since if we don't remove
the negative dentry, its parent dentry can't be removed.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/inode.c 2/fs/btrfs/inode.c
--- 1/fs/btrfs/inode.c	2009-10-02 14:36:55.383120732 +0800
+++ 2/fs/btrfs/inode.c	2009-10-09 09:54:01.591286200 +0800
@@ -3598,12 +3598,14 @@ static int btrfs_dentry_delete(struct de
 {
 	struct btrfs_root *root;
 
-	if (!dentry->d_inode)
-		return 0;
+	if (!dentry->d_inode && !IS_ROOT(dentry))
+		dentry = dentry->d_parent;
 
-	root = BTRFS_I(dentry->d_inode)->root;
-	if (btrfs_root_refs(&root->root_item) == 0)
-		return 1;
+	if (dentry->d_inode) {
+		root = BTRFS_I(dentry->d_inode)->root;
+		if (btrfs_root_refs(&root->root_item) == 0)
+			return 1;
+	}
 	return 0;
 }
 
diff -urp 1/fs/btrfs/ioctl.c 2/fs/btrfs/ioctl.c
--- 1/fs/btrfs/ioctl.c	2009-09-30 13:51:41.430296197 +0800
+++ 2/fs/btrfs/ioctl.c	2009-10-09 09:53:11.601275678 +0800
@@ -830,6 +830,7 @@ out_up_write:
 out_unlock:
 	mutex_unlock(&inode->i_mutex);
 	if (!err) {
+		shrink_dcache_sb(root->fs_info->sb);
 		btrfs_invalidate_inodes(dest);
 		d_delete(dentry);
 	}
