From: Balaji Rao <balajirrao@gmail.com>
Subject: [RFC][PATCH] introduce a btrfs_iget helper
Date: Mon, 14 Jul 2008 11:52:16 +0530
Message-ID: <200807141152.16772.balajirrao@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

As suggest by Cristoph, this patch factors out a btrfs_iget helper from
btrfs_lookup. This is useful in situations such as in NFS export ops.

Comments ?

Signed-off-by: Balaji Rao <balajirrao@gmail.com>
diff -r 3f0eee804974 ctree.h
--- a/ctree.h	Thu Jun 26 10:34:20 2008 -0400
+++ b/ctree.h	Mon Jul 14 11:18:27 2008 +0530
@@ -1607,6 +1607,8 @@
 				struct btrfs_root *root);
 struct inode *btrfs_ilookup(struct super_block *s, u64 objectid,
 			    u64 root_objectid);
+struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
+				struct btrfs_root *root, int *is_new);
 int btrfs_commit_write(struct file *file, struct page *page,
 		       unsigned from, unsigned to);
 struct extent_map *btrfs_get_extent(struct inode *inode, struct page *page,
diff -r 3f0eee804974 inode.c
--- a/inode.c	Thu Jun 26 10:34:20 2008 -0400
+++ b/inode.c	Mon Jul 14 11:18:27 2008 +0530
@@ -1441,6 +1441,33 @@
 	return inode;
 }
 
+/* Get an inode object given its location and corresponding root.
+ * Returns in *is_new if the inode was read from disk
+ */
+struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
+				struct btrfs_root *root, int *is_new)
+{
+	struct inode *inode;
+
+	inode = btrfs_iget_locked(s, location->objectid, root);
+	if (!inode)
+		return ERR_PTR(-EACCES);
+
+	if (inode->i_state & I_NEW) {
+		BTRFS_I(inode)->root = root;
+		memcpy(&BTRFS_I(inode)->location, location, sizeof(*location));
+		btrfs_read_locked_inode(inode);
+		unlock_new_inode(inode);
+		if (is_new)
+			*is_new = 1;
+	} else {
+		if (is_new)
+			*is_new = 0;
+	}
+
+	return inode;
+}
+
 static struct dentry *btrfs_lookup(struct inode *dir, struct dentry *dentry,
 				   struct nameidata *nd)
 {
@@ -1449,7 +1476,7 @@
 	struct btrfs_root *root = bi->root;
 	struct btrfs_root *sub_root = root;
 	struct btrfs_key location;
-	int ret;
+	int ret, new;
 
 	if (dentry->d_name.len > BTRFS_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
@@ -1467,21 +1494,14 @@
 			return ERR_PTR(ret);
 		if (ret > 0)
 			return ERR_PTR(-ENOENT);
-		inode = btrfs_iget_locked(dir->i_sb, location.objectid,
-					  sub_root);
-		if (!inode)
-			return ERR_PTR(-EACCES);
-		if (inode->i_state & I_NEW) {
-			/* the inode and parent dir are two different roots */
-			if (sub_root != root) {
-				igrab(inode);
-				sub_root->inode = inode;
-			}
-			BTRFS_I(inode)->root = sub_root;
-			memcpy(&BTRFS_I(inode)->location, &location,
-			       sizeof(location));
-			btrfs_read_locked_inode(inode);
-			unlock_new_inode(inode);
+		inode = btrfs_iget(dir->i_sb, &location, sub_root, &new);
+		if (IS_ERR(inode))
+			return ERR_CAST(inode);
+
+		/* the inode and parent dir are two different roots */
+		if (new && root != sub_root) {
+			igrab(inode);
+			sub_root->inode = inode;
 		}
 	}
 	return d_splice_alias(inode, dentry);
