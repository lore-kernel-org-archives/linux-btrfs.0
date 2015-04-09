Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:36452 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778AbbDIVf3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Apr 2015 17:35:29 -0400
Received: by pabsx10 with SMTP id sx10so271271pab.3
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Apr 2015 14:35:28 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v2 5/6] Btrfs: unify subvol= and subvolid= mounting
Date: Thu,  9 Apr 2015 14:34:55 -0700
Message-Id: <074cb88847c0034aa1fc28f78f69c3dd1d5bd938.1428614837.git.osandov@osandov.com>
In-Reply-To: <cover.1428614837.git.osandov@osandov.com>
References: <cover.1428614837.git.osandov@osandov.com>
In-Reply-To: <cover.1428614837.git.osandov@osandov.com>
References: <cover.1428614837.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently, mounting a subvolume with subvolid= takes a different code
path than mounting with subvol=. This isn't really a big deal except for
the fact that mounts done with subvolid= or the default subvolume don't
have a dentry that's connected to the dentry tree like in the subvol=
case. To unify the code paths, when given subvolid= or using the default
subvolume ID, translate it into a subvolume name by walking
ROOT_BACKREFs in the root tree and INODE_REFs in the filesystem trees.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 fs/btrfs/super.c | 229 +++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 171 insertions(+), 58 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 20b470d..80a8047 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -841,33 +841,153 @@ out:
 	return error;
 }
 
-static struct dentry *get_default_root(struct super_block *sb,
-				       u64 subvol_objectid)
+static char *get_subvol_name_from_objectid(struct btrfs_fs_info *fs_info,
+					   u64 subvol_objectid)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
 	struct btrfs_root *root = fs_info->tree_root;
-	struct btrfs_root *new_root;
-	struct btrfs_dir_item *di;
-	struct btrfs_path *path;
-	struct btrfs_key location;
-	struct inode *inode;
-	u64 dir_id;
-	int new = 0;
+	struct btrfs_root *fs_root;
+	struct btrfs_root_ref *root_ref;
+	struct btrfs_inode_ref *inode_ref;
+	struct btrfs_key key;
+	struct btrfs_path *path = NULL;
+	char *name = NULL, *ptr;
+	u64 dirid;
+	int len;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path) {
+		ret = -ENOMEM;
+		goto err;
+	}
+	path->leave_spinning = 1;
+
+	name = kmalloc(PATH_MAX, GFP_NOFS);
+	if (!name) {
+		ret = -ENOMEM;
+		goto err;
+	}
+	ptr = name + PATH_MAX - 1;
+	ptr[0] = '\0';
 
 	/*
-	 * We have a specific subvol we want to mount, just setup location and
-	 * go look up the root.
+	 * Walk up the subvolume trees in the tree of tree roots by root
+	 * backrefs until we hit the top-level subvolume.
 	 */
-	if (subvol_objectid) {
-		location.objectid = subvol_objectid;
-		location.type = BTRFS_ROOT_ITEM_KEY;
-		location.offset = (u64)-1;
-		goto find_root;
+	while (subvol_objectid != BTRFS_FS_TREE_OBJECTID) {
+		key.objectid = subvol_objectid;
+		key.type = BTRFS_ROOT_BACKREF_KEY;
+		key.offset = (u64)-1;
+
+		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+		if (ret < 0) {
+			goto err;
+		} else if (ret > 0) {
+			ret = btrfs_previous_item(root, path, subvol_objectid,
+						  BTRFS_ROOT_BACKREF_KEY);
+			if (ret < 0) {
+				goto err;
+			} else if (ret > 0) {
+				ret = -ENOENT;
+				goto err;
+			}
+		}
+
+		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+		subvol_objectid = key.offset;
+
+		root_ref = btrfs_item_ptr(path->nodes[0], path->slots[0],
+					  struct btrfs_root_ref);
+		len = btrfs_root_ref_name_len(path->nodes[0], root_ref);
+		ptr -= len + 1;
+		if (ptr < name) {
+			ret = -ENAMETOOLONG;
+			goto err;
+		}
+		read_extent_buffer(path->nodes[0], ptr + 1,
+				   (unsigned long)(root_ref + 1), len);
+		ptr[0] = '/';
+		dirid = btrfs_root_ref_dirid(path->nodes[0], root_ref);
+		btrfs_release_path(path);
+
+		key.objectid = subvol_objectid;
+		key.type = BTRFS_ROOT_ITEM_KEY;
+		key.offset = (u64)-1;
+		fs_root = btrfs_read_fs_root_no_name(fs_info, &key);
+		if (IS_ERR(fs_root)) {
+			ret = PTR_ERR(fs_root);
+			goto err;
+		}
+
+		/*
+		 * Walk up the filesystem tree by inode refs until we hit the
+		 * root directory.
+		 */
+		while (dirid != BTRFS_FIRST_FREE_OBJECTID) {
+			key.objectid = dirid;
+			key.type = BTRFS_INODE_REF_KEY;
+			key.offset = (u64)-1;
+
+			ret = btrfs_search_slot(NULL, fs_root, &key, path, 0, 0);
+			if (ret < 0) {
+				goto err;
+			} else if (ret > 0) {
+				ret = btrfs_previous_item(fs_root, path, dirid,
+							  BTRFS_INODE_REF_KEY);
+				if (ret < 0) {
+					goto err;
+				} else if (ret > 0) {
+					ret = -ENOENT;
+					goto err;
+				}
+			}
+
+			btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+			dirid = key.offset;
+
+			inode_ref = btrfs_item_ptr(path->nodes[0],
+						   path->slots[0],
+						   struct btrfs_inode_ref);
+			len = btrfs_inode_ref_name_len(path->nodes[0],
+						       inode_ref);
+			ptr -= len + 1;
+			if (ptr < name) {
+				ret = -ENAMETOOLONG;
+				goto err;
+			}
+			read_extent_buffer(path->nodes[0], ptr + 1,
+					   (unsigned long)(inode_ref + 1), len);
+			ptr[0] = '/';
+			btrfs_release_path(path);
+		}
 	}
 
+	btrfs_free_path(path);
+	if (ptr == name + PATH_MAX - 1) {
+		name[0] = '/';
+		name[1] = '\0';
+	} else {
+		memmove(name, ptr, name + PATH_MAX - ptr);
+	}
+	return name;
+
+err:
+	btrfs_free_path(path);
+	kfree(name);
+	return ERR_PTR(ret);
+}
+
+static int get_default_subvol_objectid(struct btrfs_fs_info *fs_info, u64 *objectid)
+{
+	struct btrfs_root *root = fs_info->tree_root;
+	struct btrfs_dir_item *di;
+	struct btrfs_path *path;
+	struct btrfs_key location;
+	u64 dir_id;
+
 	path = btrfs_alloc_path();
 	if (!path)
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 	path->leave_spinning = 1;
 
 	/*
@@ -879,49 +999,23 @@ static struct dentry *get_default_root(struct super_block *sb,
 	di = btrfs_lookup_dir_item(NULL, root, path, dir_id, "default", 7, 0);
 	if (IS_ERR(di)) {
 		btrfs_free_path(path);
-		return ERR_CAST(di);
+		return PTR_ERR(di);
 	}
 	if (!di) {
 		/*
 		 * Ok the default dir item isn't there.  This is weird since
 		 * it's always been there, but don't freak out, just try and
-		 * mount to root most subvolume.
+		 * mount the top-level subvolume.
 		 */
 		btrfs_free_path(path);
-		dir_id = BTRFS_FIRST_FREE_OBJECTID;
-		new_root = fs_info->fs_root;
-		goto setup_root;
+		*objectid = BTRFS_FS_TREE_OBJECTID;
+		return 0;
 	}
 
 	btrfs_dir_item_key_to_cpu(path->nodes[0], di, &location);
 	btrfs_free_path(path);
-
-find_root:
-	new_root = btrfs_read_fs_root_no_name(fs_info, &location);
-	if (IS_ERR(new_root))
-		return ERR_CAST(new_root);
-
-	dir_id = btrfs_root_dirid(&new_root->root_item);
-setup_root:
-	location.objectid = dir_id;
-	location.type = BTRFS_INODE_ITEM_KEY;
-	location.offset = 0;
-
-	inode = btrfs_iget(sb, &location, new_root, &new);
-	if (IS_ERR(inode))
-		return ERR_CAST(inode);
-
-	/*
-	 * If we're just mounting the root most subvol put the inode and return
-	 * a reference to the dentry.  We will have already gotten a reference
-	 * to the inode in btrfs_fill_super so we're good to go.
-	 */
-	if (!new && sb->s_root->d_inode == inode) {
-		iput(inode);
-		return dget(sb->s_root);
-	}
-
-	return d_obtain_root(inode);
+	*objectid = location.objectid;
+	return 0;
 }
 
 static int btrfs_fill_super(struct super_block *sb,
@@ -1207,6 +1301,25 @@ static struct dentry *mount_subvol(const char *subvol_name, u64 subvol_objectid,
 		goto out;
 	}
 
+	if (!subvol_name) {
+		if (!subvol_objectid) {
+			ret = get_default_subvol_objectid(btrfs_sb(mnt->mnt_sb),
+							  &subvol_objectid);
+			if (ret) {
+				root = ERR_PTR(ret);
+				goto out;
+			}
+		}
+		subvol_name = get_subvol_name_from_objectid(btrfs_sb(mnt->mnt_sb),
+							    subvol_objectid);
+		if (IS_ERR(subvol_name)) {
+			root = ERR_CAST(subvol_name);
+			subvol_name = NULL;
+			goto out;
+		}
+
+	}
+
 	root = mount_subtree(mnt, subvol_name);
 	/* mount_subtree() drops our reference on the vfsmount. */
 	mnt = NULL;
@@ -1222,6 +1335,11 @@ static struct dentry *mount_subvol(const char *subvol_name, u64 subvol_objectid,
 			ret = -EINVAL;
 		}
 		if (subvol_objectid && root_objectid != subvol_objectid) {
+			/*
+			 * This will also catch a race condition where a
+			 * subvolume which was passed by ID is renamed and
+			 * another subvolume is renamed over the old location.
+			 */
 			pr_err("BTRFS: subvol '%s' does not match subvolid %llu\n",
 			       subvol_name, subvol_objectid);
 			ret = -EINVAL;
@@ -1301,7 +1419,6 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 {
 	struct block_device *bdev = NULL;
 	struct super_block *s;
-	struct dentry *root;
 	struct btrfs_fs_devices *fs_devices = NULL;
 	struct btrfs_fs_info *fs_info = NULL;
 	struct security_mnt_opts new_sec_opts;
@@ -1321,7 +1438,7 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 		return ERR_PTR(error);
 	}
 
-	if (subvol_name) {
+	if (subvol_name || subvol_objectid != BTRFS_FS_TREE_OBJECTID) {
 		/* mount_subvol() will free subvol_name. */
 		return mount_subvol(subvol_name, subvol_objectid, flags,
 				    device_name, data);
@@ -1390,23 +1507,19 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 		error = btrfs_fill_super(s, fs_devices, data,
 					 flags & MS_SILENT ? 1 : 0);
 	}
-
-	root = !error ? get_default_root(s, subvol_objectid) : ERR_PTR(error);
-	if (IS_ERR(root)) {
+	if (error) {
 		deactivate_locked_super(s);
-		error = PTR_ERR(root);
 		goto error_sec_opts;
 	}
 
 	fs_info = btrfs_sb(s);
 	error = setup_security_options(fs_info, s, &new_sec_opts);
 	if (error) {
-		dput(root);
 		deactivate_locked_super(s);
 		goto error_sec_opts;
 	}
 
-	return root;
+	return dget(s->s_root);
 
 error_close_devices:
 	btrfs_close_devices(fs_devices);
-- 
2.3.5

