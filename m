From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix various things with the listing ioctl
Date: Mon, 14 Dec 2009 14:17:22 -0500
Message-ID: <20091214191722.GB2165@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: taruishi.hiroak@jp.fujitsu.com, chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

With slab poisoning on you could panic the box simply by running btrfsctl -l
multiple times in a row on the same volume.  This patch fixes up the ioctl stuff
to be a bit cleaner, makes sure we always call btrfs_free_path() instead of
kfree(path) and make sure we do not kfree() our work names before we are done
using them.  There were several memory leaks and use after free problems
previously, they appear to be gone now, and as an added bonus doing btrfsctl -l
no longer panic's the box.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ioctl.c |   88 +++++++++++++++++++++++++++--------------------------
 1 files changed, 45 insertions(+), 43 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index c157eb7..9778324 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -759,18 +759,29 @@ static noinline int btrfs_search_path_in_tree(struct btrfs_fs_info *info,
 
 	if (dirid == BTRFS_FIRST_FREE_OBJECTID) {
 		name[0]='\0';
-		ret = 0;
-		goto out_direct;
+		return 0;
 	}
 
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
 	name_stack = kzalloc(BTRFS_PATH_NAME_MAX+1, GFP_NOFS);
+	if (!name_stack) {
+		btrfs_free_path(path);
+		return -ENOMEM;
+	}
+
 	ptr = &name_stack[BTRFS_PATH_NAME_MAX];
 
 	key.objectid = tree_id;
 	key.type = BTRFS_ROOT_ITEM_KEY;
 	key.offset = (u64)-1;
 	root = btrfs_read_fs_root_no_name(info, &key);
+	if (IS_ERR(root)) {
+		printk(KERN_ERR "could not find root %llu\n", tree_id);
+		return -ENOENT;
+	}
 
 	key.objectid = dirid;
 	key.type = BTRFS_INODE_REF_KEY;
@@ -778,14 +789,14 @@ static noinline int btrfs_search_path_in_tree(struct btrfs_fs_info *info,
 
 	while(1) {
 		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
-		if (ret<0)
+		if (ret < 0)
 			goto out;
 
 		l = path->nodes[0];
 		slot = path->slots[0];
 		btrfs_item_key_to_cpu(l, &key, slot);
 
-		if (ret>0 && (key.objectid != dirid ||
+		if (ret > 0 && (key.objectid != dirid ||
 					key.type != BTRFS_INODE_REF_KEY))
 			goto out;
 
@@ -814,11 +825,8 @@ static noinline int btrfs_search_path_in_tree(struct btrfs_fs_info *info,
 	name[total_len]='\0';
 	ret = 0;
 out:
-	btrfs_release_path(root, path);
-	kfree(path);
+	btrfs_free_path(path);
 	kfree(name_stack);
-
-out_direct:
 	return ret;
 }
 
@@ -857,6 +865,7 @@ static noinline int btrfs_ioctl_snap_listing(struct file *file,
 {
 	struct btrfs_ioctl_subvol_leaf *leaf;
 	struct btrfs_ioctl_subvol_args *svol;
+	struct inode *inode;
 	int rest, offset, idx, name_len, i;
 	struct btrfs_root *tree_root;
 	struct btrfs_root_ref *ref;
@@ -878,18 +887,18 @@ static noinline int btrfs_ioctl_snap_listing(struct file *file,
 
 	work_path = kzalloc(BTRFS_PATH_NAME_MAX + 1, GFP_NOFS);
 	if (!work_path) {
-		kfree(path);
+		btrfs_free_path(path);
 		return -ENOMEM;
 	}
 
 	svol = memdup_user(arg, sizeof(struct btrfs_ioctl_subvol_args));
 	if (IS_ERR(svol)) {
-		kfree(path);
+		btrfs_free_path(path);
 		kfree(work_path);
 		return PTR_ERR(svol);
 	}
 	if (svol->len < BTRFS_SUBVOL_LEAF_SIZE_MIN) {
-		kfree(path);
+		btrfs_free_path(path);
 		kfree(work_path);
 		kfree(svol);
 		return -EINVAL;
@@ -897,44 +906,42 @@ static noinline int btrfs_ioctl_snap_listing(struct file *file,
 
 	leaf = memdup_user(svol->leaf, svol->len);
 	if (IS_ERR(leaf)) {
-		kfree(path);
+		btrfs_free_path(path);
 		kfree(work_path);
 		kfree(svol);
 		return PTR_ERR(leaf);
 	}
-	if (leaf->len != svol->len)
-		goto out_inval;
+	if (leaf->len != svol->len) {
+		ret = -EINVAL;
+		goto out;
+	}
 
-	tree_root =
-		BTRFS_I(fdentry(file)->d_inode)->root->fs_info->tree_root;
+	inode = fdentry(file)->d_inode;
+	tree_root = BTRFS_I(inode)->root->fs_info->tree_root;
 	if (!leaf->parent_tree) {
-		leaf->parent_tree =
-			BTRFS_I(fdentry(file)->d_inode)->root->root_key.objectid;
+		leaf->parent_tree = BTRFS_I(inode)->root->root_key.objectid;
+
 		if (svol->base_path) {
-			work_path = kzalloc(BTRFS_PATH_NAME_MAX+1, GFP_NOFS);
-			if (!work_path) {
-				ret = -ENOMEM;
-				goto out;
-			}
 			vfs_path.mnt = file->f_path.mnt;
 			vfs_path.dentry = btrfs_walkup_dentry_to_root(fdentry(file));
 			f_path = d_path(&vfs_path, work_path, BTRFS_PATH_NAME_MAX);
-			if (!IS_ERR(f_path)) {
-				strcpy(svol->base_path, f_path);
-				strcat(svol->base_path, "/");
-				if (copy_to_user(svol->base_path, f_path,
-						 strlen(f_path))) {
-					ret = -EFAULT;
-					kfree(work_path);
-					goto out;
-				}
+			if (IS_ERR(f_path)) {
+				ret = PTR_ERR(f_path);
+				goto out;
+			}
+			strcpy(svol->base_path, f_path);
+			strcat(svol->base_path, "/");
+			if (copy_to_user(svol->base_path, f_path,
+					 strlen(f_path))) {
+				ret = -EFAULT;
+				goto out;
 			}
-			kfree(work_path);
 		}
 	} else {
 		if (leaf->parent_tree != BTRFS_FS_TREE_OBJECTID &&
 			leaf->parent_tree < BTRFS_FIRST_FREE_OBJECTID) {
-			goto out_inval;
+			ret = -EINVAL;
+			goto out;
 		}
 	}
 
@@ -954,7 +961,7 @@ static noinline int btrfs_ioctl_snap_listing(struct file *file,
 		if (err < 0) {
 			printk("search tree failed: code=%d\n", err);
 			ret = -EINVAL;
-			goto outr_error;
+			goto out;
 		}
 
 		l = path->nodes[0];
@@ -1003,19 +1010,14 @@ static noinline int btrfs_ioctl_snap_listing(struct file *file,
 		key.offset++;
 	}
 
-	if (copy_to_user(svol->leaf, leaf, svol->len)) {
+	if (copy_to_user(svol->leaf, leaf, svol->len))
 		ret = -EFAULT;
-	}
-	goto out;
 
-outr_error:
-	btrfs_release_path(tree_root, path);
-out_inval:
-	ret = -EINVAL;
 out:
-	kfree(path);
+	btrfs_free_path(path);
 	kfree(leaf);
 	kfree(svol);
+	kfree(work_path);
 	return ret;
 }
 
-- 
1.5.4.3

