From: Balaji Rao <balajirrao@gmail.com>
Subject: [PATCH] Remove unused variable in fixup_tree_root_location
Date: Sun, 13 Jul 2008 23:02:15 +0530
Message-ID: <200807132302.15944.balajirrao@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Remove a unused variable 'path' in fixup_tree_root_location.

Signed-off-by: Balaji Rao <balajirrao@gmail.com>

diff -r 3f0eee804974 inode.c
--- a/inode.c	Thu Jun 26 10:34:20 2008 -0400
+++ b/inode.c	Sun Jul 13 21:30:47 2008 +0530
@@ -1365,16 +1365,12 @@
 			     struct btrfs_root **sub_root,
 			     struct dentry *dentry)
 {
-	struct btrfs_path *path;
 	struct btrfs_root_item *ri;
 
 	if (btrfs_key_type(location) != BTRFS_ROOT_ITEM_KEY)
 		return 0;
 	if (location->objectid == BTRFS_ROOT_TREE_OBJECTID)
 		return 0;
-
-	path = btrfs_alloc_path();
-	BUG_ON(!path);
 
 	*sub_root = btrfs_read_fs_root(root->fs_info, location,
 					dentry->d_name.name,
@@ -1387,7 +1383,6 @@
 	btrfs_set_key_type(location, BTRFS_INODE_ITEM_KEY);
 	location->offset = 0;
 
-	btrfs_free_path(path);
 	return 0;
 }
 

-- 
Warm Regards,
Balaji Rao
