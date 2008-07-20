From: Balaji Rao <balajirrao@gmail.com>
Subject: [PATCH] Introduce btrfs_iget helper - updated
Date: Mon, 21 Jul 2008 02:01:04 +0530
Message-ID: <200807210201.04981.balajirrao@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

This patch introduces a btrfs_iget helper to be used in NFS support.

This applies to kernel-unstable/tip.

---
Signed-off-by: Balaji Rao <balajirrao@gmail.com>

diff -r 179ee631a0fc ctree.h
--- a/ctree.h	Fri Jul 18 20:42:20 2008 -0400
+++ b/ctree.h	Mon Jul 21 01:44:54 2008 +0530
@@ -1630,6 +1630,8 @@
 				struct btrfs_root *root);
 struct inode *btrfs_ilookup(struct super_block *s, u64 objectid,
 			    u64 root_objectid);
+struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
+				struct btrfs_root *root, int *is_new);
 int btrfs_commit_write(struct file *file, struct page *page,
 		       unsigned from, unsigned to);
 struct extent_map *btrfs_get_extent(struct inode *inode, struct page *page,
diff -r 179ee631a0fc inode.c
--- a/inode.c	Fri Jul 18 20:42:20 2008 -0400
+++ b/inode.c	Mon Jul 21 01:44:54 2008 +0530
@@ -1651,6 +1651,33 @@
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
@@ -1659,7 +1686,7 @@
 	struct btrfs_root *root = bi->root;
 	struct btrfs_root *sub_root = root;
 	struct btrfs_key location;
-	int ret;
+	int ret, new;
 
 	if (dentry->d_name.len > BTRFS_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
@@ -1677,21 +1704,14 @@
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
