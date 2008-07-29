From: "Yan Zheng" <zheng.yan@oracle.com>
Subject: [PATCH] btrfs-convert new dir index support
Date: Wed, 30 Jul 2008 02:22:30 +0800
Message-ID: <3d0408630807291122t7e7d7341x2c54e8f83cfc4af8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Radoslaw Szkodzinski" <astralstorm@gen2.org>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This patch updates btrfs-convert for the new dir index stuff.

Please apply Radoslaw Szkodzinski's btrfs-convert patch first, this
one depends on it.

Regards
YZ
---
diff -r e91284e397df convert.c
--- a/convert.c	Wed Jul 30 01:42:11 2008 +0800
+++ b/convert.c	Wed Jul 30 01:46:02 2008 +0800
@@ -188,6 +188,7 @@ struct dir_iterate_data {
 	struct btrfs_root *root;
 	struct btrfs_inode_item *inode;
 	u64 objectid;
+	u64 index_cnt;
 	u64 parent;
 	int errcode;
 };
@@ -242,7 +243,8 @@ static int dir_iterate_proc(ext2_ino_t d
 		goto fail;
 	ret = btrfs_insert_inode_ref(idata->trans, idata->root,
 				     dirent->name, dirent->name_len,
-				     objectid, idata->objectid);
+				     objectid, idata->objectid,
+				     idata->index_cnt++);
 	if (ret)
 		goto fail;
 	inode_size = btrfs_stack_inode_size(idata->inode) +
@@ -266,6 +268,7 @@ static int create_dir_entries(struct btr
 		.root		= root,
 		.inode		= btrfs_inode,
 		.objectid	= objectid,
+		.index_cnt	= 2,
 		.parent		= 0,
 		.errcode	= 0,
 	};
@@ -277,7 +280,7 @@ static int create_dir_entries(struct btr
 	ret = data.errcode;
 	if (ret == 0 && data.parent == objectid) {
 		ret = btrfs_insert_inode_ref(trans, root, "..", 2,
-					     objectid, objectid);
+					     objectid, objectid, 0);
 	}
 	return ret;
 error:
@@ -959,11 +962,9 @@ static int copy_single_inode(struct btrf
 	struct btrfs_key inode_key;
 	struct btrfs_inode_item btrfs_inode;

-	if (!ext2_inode->i_links_count &&
-	    (!ext2_inode->i_mode || ext2_inode->i_dtime)) {
-		printf("skip inode %u\n", ext2_ino);
+	if (ext2_inode->i_links_count == 0)
 		return 0;
-	}
+
 	copy_inode_item(&btrfs_inode, ext2_inode);
 	if (!datacsum && S_ISREG(ext2_inode->i_mode)) {
 		u32 flags = btrfs_stack_inode_flags(&btrfs_inode) |
@@ -1313,7 +1314,7 @@ next:
 		goto fail;
 	ret = btrfs_insert_inode_ref(trans, root, name, strlen(name),
 				     objectid,
-				     btrfs_root_dirid(&root->root_item));
+				     btrfs_root_dirid(&root->root_item), 0);
 	if (ret)
 		goto fail;
 	location.objectid = btrfs_root_dirid(&root->root_item);
@@ -1378,7 +1379,8 @@ struct btrfs_root *create_subvol(struct
 		goto fail;
 	ret = btrfs_insert_inode_ref(trans, tree_root, name, strlen(name),
 				     objectid,
-				     btrfs_super_root_dir(&fs_info->super_copy));
+				     btrfs_super_root_dir(&fs_info->super_copy),
+				     0);
 	if (ret)
 		goto fail;
 	ret = btrfs_commit_transaction(trans, root);
@@ -1611,7 +1613,7 @@ static int init_btrfs(struct btrfs_root
 		goto err;
 	ret = btrfs_insert_inode_ref(trans, fs_info->tree_root, "default", 7,
 				location.objectid,
-				btrfs_super_root_dir(&fs_info->super_copy));
+				btrfs_super_root_dir(&fs_info->super_copy), 0);
 	if (ret)
 		goto err;
 	btrfs_set_root_dirid(&fs_info->fs_root->root_item,
