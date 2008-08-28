From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] btrfs: cleanup d_obtain_alias useage
Date: Fri, 29 Aug 2008 01:00:06 +0200
Message-ID: <20080828230006.GA19138@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

d_obtain_alias is intended as a tailcall that can pass in errors encoded
in the inode pointer if needed, so use it that way instead of
duplicating the error handling.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: btrfs-unstable/export.c
===================================================================
--- btrfs-unstable.orig/export.c	2008-08-28 19:56:13.000000000 -0300
+++ btrfs-unstable/export.c	2008-08-28 19:57:04.000000000 -0300
@@ -68,7 +68,6 @@ static struct dentry *btrfs_get_dentry(s
 {
 	struct btrfs_root *root;
 	struct inode *inode;
-	struct dentry *result;
 	struct btrfs_key key;
 
 	key.objectid = root_objectid;
@@ -92,11 +91,7 @@ static struct dentry *btrfs_get_dentry(s
 		return ERR_PTR(-ESTALE);
 	}
 
-	result = d_obtain_alias(inode);
-	if (!result)
-		return ERR_PTR(-ENOMEM);
-
-	return result;
+	return d_obtain_alias(inode);
 }
 
 static struct dentry *btrfs_fh_to_parent(struct super_block *sb, struct fid *fh,
@@ -148,8 +143,6 @@ static struct dentry *btrfs_fh_to_dentry
 static struct dentry *btrfs_get_parent(struct dentry *child)
 {
 	struct inode *dir = child->d_inode;
-	struct inode *inode;
-	struct dentry *parent;
 	struct btrfs_root *root = BTRFS_I(dir)->root;
 	struct btrfs_key key;
 	struct btrfs_path *path;
@@ -203,13 +196,7 @@ static struct dentry *btrfs_get_parent(s
 	btrfs_set_key_type(&key, BTRFS_INODE_ITEM_KEY);
 	key.offset = 0;
 
-	inode = btrfs_iget(root->fs_info->sb, &key, root, NULL);
-
-	parent = d_obtain_alias(inode);
-	if (!parent)
-		parent = ERR_PTR(-ENOMEM);
-
-	return parent;
+	return d_obtain_alias(btrfs_iget(root->fs_info->sb, &key, root, NULL));
 }
 
 const struct export_operations btrfs_export_ops = {
