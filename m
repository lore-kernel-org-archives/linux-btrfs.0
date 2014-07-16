Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:9425 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751521AbaGPEHU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 00:07:20 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6G47G4f002182
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Jul 2014 12:07:16 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] btrfs: Merge default subvolume mount codes into btrfs_mount_subvol().
Date: Wed, 16 Jul 2014 12:07:11 +0800
Message-ID: <1405483631-23037-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1405483631-23037-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1405483631-23037-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Old btrfs codes do the default subvolume search in get_default_root(),
which makes default subvolume mount will not info vfs that it's a
subtree mount.

Now since btrfs_mount_subvol() will mount all btrfs subvolume throught
mount_subtree() vfs API, merge the default subvolume searching codes
into it, and now btrfs handles all 3 types of subvolume mount in one
place.('subvol=' 'subvolid=' and default subvolume mount).

This is done by reuse the old dir_id->root_objectid search routine and
then reuse the subvolume_object mount routine in previous patch.

Reported-by: Stefan G.Weichinger <lists@xunil.at>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/super.c | 101 +++++++++++++++++++++++++++++--------------------------
 1 file changed, 53 insertions(+), 48 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 23363a2..7bed7a1 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -842,14 +842,10 @@ out:
 	return error;
 }
 
-static struct dentry *get_default_root(struct super_block *sb,
-				       u64 subvol_objectid)
+static struct dentry *get_default_root(struct super_block *sb)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
-	struct btrfs_root *root = fs_info->tree_root;
 	struct btrfs_root *new_root;
-	struct btrfs_dir_item *di;
-	struct btrfs_path *path;
 	struct btrfs_key location;
 	struct inode *inode;
 	struct dentry *dentry;
@@ -860,51 +856,15 @@ static struct dentry *get_default_root(struct super_block *sb,
 	 * We have a specific subvol we want to mount, just setup location and
 	 * go look up the root.
 	 */
-	if (subvol_objectid) {
-		location.objectid = subvol_objectid;
-		location.type = BTRFS_ROOT_ITEM_KEY;
-		location.offset = (u64)-1;
-		goto find_root;
-	}
-
-	path = btrfs_alloc_path();
-	if (!path)
-		return ERR_PTR(-ENOMEM);
-	path->leave_spinning = 1;
-
-	/*
-	 * Find the "default" dir item which points to the root item that we
-	 * will mount by default if we haven't been given a specific subvolume
-	 * to mount.
-	 */
-	dir_id = btrfs_super_root_dir(fs_info->super_copy);
-	di = btrfs_lookup_dir_item(NULL, root, path, dir_id, "default", 7, 0);
-	if (IS_ERR(di)) {
-		btrfs_free_path(path);
-		return ERR_CAST(di);
-	}
-	if (!di) {
-		/*
-		 * Ok the default dir item isn't there.  This is weird since
-		 * it's always been there, but don't freak out, just try and
-		 * mount to root most subvolume.
-		 */
-		btrfs_free_path(path);
-		dir_id = BTRFS_FIRST_FREE_OBJECTID;
-		new_root = fs_info->fs_root;
-		goto setup_root;
-	}
-
-	btrfs_dir_item_key_to_cpu(path->nodes[0], di, &location);
-	btrfs_free_path(path);
+	location.objectid = BTRFS_FS_TREE_OBJECTID;
+	location.type = BTRFS_ROOT_ITEM_KEY;
+	location.offset = (u64)-1;
 
-find_root:
 	new_root = btrfs_read_fs_root_no_name(fs_info, &location);
 	if (IS_ERR(new_root))
 		return ERR_CAST(new_root);
 
 	dir_id = btrfs_root_dirid(&new_root->root_item);
-setup_root:
 	location.objectid = dir_id;
 	location.type = BTRFS_INODE_ITEM_KEY;
 	location.offset = 0;
@@ -1137,7 +1097,7 @@ static int u64_to_strlen(u64 number)
 #define CLEAR_SUBVOLID		2
 /*
  * This will strip out the subvol=%s or subvolid=%s argument for an argumen
- * string and add subvolid=0 to make sure we get the actual tree root for path
+ * string and add subvolid=5 to make sure we get the actual tree root for path
  * walking to the subvol we want.
  */
 static char *setup_root_args(char *args, int flags, u64 subvol_objectid)
@@ -1198,6 +1158,14 @@ static char *setup_root_args(char *args, int flags, u64 subvol_objectid)
 	if (!buf)
 		return NULL;
 
+	if (!src) {
+		strcpy(dst, args);
+		strcpy(dst, ",");
+		strcpy(dst, subvol_string);
+		return dst;
+	}
+
+
 	/*
 	 * If the subvol= arg is not at the start of the string,
 	 * copy whatever precedes it into buf.
@@ -1311,6 +1279,37 @@ out:
 
 }
 
+static int find_default_subvol_objectid(struct btrfs_root *root,
+					u64 *subvol_objectid)
+{
+	struct btrfs_super_block *super = root->fs_info->super_copy;
+	struct btrfs_dir_item *di;
+	struct btrfs_key key;
+	struct btrfs_path *path;
+	u64 dir_id;
+	int ret = 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+	path->leave_spinning = 1;
+	dir_id = btrfs_super_root_dir(super);
+	di = btrfs_lookup_dir_item(NULL, root, path, dir_id, "defaults", 7, 0);
+	if (IS_ERR(di)) {
+		ret = PTR_ERR(di);
+		goto out;
+	}
+	if (!di) {
+		*subvol_objectid = BTRFS_FS_TREE_OBJECTID;
+		goto out;
+	}
+	btrfs_dir_item_key_to_cpu(path->nodes[0], di, &key);
+	*subvol_objectid = key.objectid;
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
 static struct dentry *mount_subvol(const char *subvol_name, u64 subvol_objectid,
 				   int flags, const char *device_name,
 				   char *data)
@@ -1359,8 +1358,15 @@ static struct dentry *mount_subvol(const char *subvol_name, u64 subvol_objectid,
 
 	if (IS_ERR(mnt))
 		return ERR_CAST(mnt);
+
 	tree_root = btrfs_sb(mnt->mnt_sb)->tree_root;
 
+	if (!subvol_name && !subvol_objectid) {
+		/* default subvolume mount */
+		ret = find_default_subvol_objectid(tree_root, &subvol_objectid);
+		if (ret < 0)
+			goto out;
+	}
 	if (!subvol_name) {
 		subvol_ret = find_subvol_by_id(tree_root, subvol_objectid);
 		if (IS_ERR(subvol_ret)) {
@@ -1421,8 +1427,7 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 		return ERR_PTR(error);
 	}
 
-	if (subvol_name || (subvol_objectid != 0 &&
-			    subvol_objectid != BTRFS_FS_TREE_OBJECTID)) {
+	if (subvol_objectid != BTRFS_FS_TREE_OBJECTID) {
 		root = mount_subvol(subvol_name, subvol_objectid, flags,
 				    device_name, data);
 		kfree(subvol_name);
@@ -1483,7 +1488,7 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 					 flags & MS_SILENT ? 1 : 0);
 	}
 
-	root = !error ? get_default_root(s, subvol_objectid) : ERR_PTR(error);
+	root = !error ? get_default_root(s) : ERR_PTR(error);
 	if (IS_ERR(root))
 		deactivate_locked_super(s);
 
-- 
2.0.1

