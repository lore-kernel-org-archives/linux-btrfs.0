From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [RFC PATCH 2/4] btrfs: restructure btrfs_real_readdir()
Date: Wed, 01 Dec 2010 16:09:29 +0800
Message-ID: <4CF602B9.4030603@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

- restructure btrfs_real_readdir(), it will be used later.
- add no memory check for btrfs_alloc_path()

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/inode.c |   98 +++++++++++++++++++++++++++++++++++------------------
 1 files changed, 65 insertions(+), 33 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0f34cae..46b9d1a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4158,16 +4158,21 @@ static unsigned char btrfs_filetype_table[] = {
 	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK
 };
 
+/*
+ * Return value:
+ * 0  - Reached end of directory/root in the ctree.
+ * 1  - buffer is full
+ * <0 - error happened
+ */
 static int btrfs_real_readdir(struct file *filp, void *dirent,
-			      filldir_t filldir)
+			      filldir_t filldir, struct btrfs_root *root,
+			      int key_type, struct btrfs_path *path)
 {
 	struct inode *inode = filp->f_dentry->d_inode;
-	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_item *item;
 	struct btrfs_dir_item *di;
 	struct btrfs_key key;
 	struct btrfs_key found_key;
-	struct btrfs_path *path;
 	int ret;
 	u32 nritems;
 	struct extent_buffer *leaf;
@@ -4178,36 +4183,10 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 	u32 di_cur;
 	u32 di_total;
 	u32 di_len;
-	int key_type = BTRFS_DIR_INDEX_KEY;
 	char tmp_name[32];
 	char *name_ptr;
 	int name_len;
 
-	/* FIXME, use a real flag for deciding about the key type */
-	if (root->fs_info->tree_root == root)
-		key_type = BTRFS_DIR_ITEM_KEY;
-
-	/* special case for "." */
-	if (filp->f_pos == 0) {
-		over = filldir(dirent, ".", 1,
-			       1, inode->i_ino,
-			       DT_DIR);
-		if (over)
-			return 0;
-		filp->f_pos = 1;
-	}
-	/* special case for .., just use the back ref */
-	if (filp->f_pos == 1) {
-		u64 pino = parent_ino(filp->f_path.dentry);
-		over = filldir(dirent, "..", 2,
-			       2, pino, DT_DIR);
-		if (over)
-			return 0;
-		filp->f_pos = 2;
-	}
-	path = btrfs_alloc_path();
-	path->reada = 2;
-
 	btrfs_set_key_type(&key, key_type);
 	key.offset = filp->f_pos;
 	key.objectid = inode->i_ino;
@@ -4224,7 +4203,9 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 		if (advance || slot >= nritems) {
 			if (slot >= nritems - 1) {
 				ret = btrfs_next_leaf(root, path);
-				if (ret)
+				if (ret < 0)
+					goto err;
+				else if (ret > 0)
 					break;
 				leaf = path->nodes[0];
 				nritems = btrfs_header_nritems(leaf);
@@ -4287,8 +4268,10 @@ skip:
 			if (name_ptr != tmp_name)
 				kfree(name_ptr);
 
-			if (over)
-				goto nopos;
+			if (over) {
+				ret = 1;
+				goto err;
+			}
 			di_len = btrfs_dir_name_len(leaf, di) +
 				 btrfs_dir_data_len(leaf, di) + sizeof(*di);
 			di_cur += di_len;
@@ -4296,6 +4279,55 @@ skip:
 		}
 	}
 
+	ret = 0;
+err:
+	btrfs_release_path(root, path);
+	return ret;
+}
+
+static int btrfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
+{
+	struct inode *inode = filp->f_dentry->d_inode;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_path *path;
+	int key_type = BTRFS_DIR_INDEX_KEY;
+	int ret;
+	int over = 0;
+
+	/* FIXME, use a real flag for deciding about the key type */
+	if (root->fs_info->tree_root == root)
+		key_type = BTRFS_DIR_ITEM_KEY;
+
+	/* special case for "." */
+	if (filp->f_pos == 0) {
+		over = filldir(dirent, ".", 1,
+			       1, inode->i_ino,
+			       DT_DIR);
+		if (over)
+			return 0;
+		filp->f_pos = 1;
+	}
+	/* special case for .., just use the back ref */
+	if (filp->f_pos == 1) {
+		u64 pino = parent_ino(filp->f_path.dentry);
+		over = filldir(dirent, "..", 2,
+			       2, pino, DT_DIR);
+		if (over)
+			return 0;
+		filp->f_pos = 2;
+	}
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+	path->reada = 2;
+
+	ret = btrfs_real_readdir(filp, dirent, filldir, root, key_type, path);
+	if (ret < 0)
+		goto err;
+	else if (ret > 0)
+		goto nopos;
+
 	/* Reached end of directory/root. Bump pos past the last item. */
 	if (key_type == BTRFS_DIR_INDEX_KEY)
 		/*
@@ -7238,7 +7270,7 @@ static const struct inode_operations btrfs_dir_ro_inode_operations = {
 static const struct file_operations btrfs_dir_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
-	.readdir	= btrfs_real_readdir,
+	.readdir	= btrfs_readdir,
 	.unlocked_ioctl	= btrfs_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= btrfs_ioctl,
-- 
1.7.0.1
