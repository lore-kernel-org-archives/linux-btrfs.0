Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62127 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755227AbbKRHY6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Nov 2015 02:24:58 -0500
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tAI7NoSG007932
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2015 15:24:05 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH 21/22] btrfs-progs: convert: Introduce init_btrfs_v2 function.
Date: Wed, 18 Nov 2015 15:22:21 +0800
Message-Id: <1447831342-15056-22-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1447831342-15056-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1447831342-15056-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce new init_btrfs_v2() function for later newer do_convert().

Since we have good enough chunk allocation, a lot of wired chunk hack
won't ever be used.
We only need to insert data chunks and create needed subvolume/inode.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-convert.c | 96 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 96 insertions(+)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 993ee80..9e8158d 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2092,6 +2092,102 @@ static int make_convert_data_block_groups(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+/*
+ * Init the temp btrfs to a operational status.
+ *
+ * It will fix the extent usage accounting and insert needed data chunks, to
+ * ensure all ext* data extents are covered by DATA chunks, preventing wrong
+ * chunks are allocated.
+ * And also create convert image subvolume and relocation tree.
+ */
+static int init_btrfs_v2(struct btrfs_mkfs_config *cfg, ext2_filsys ext2_fs,
+			 struct btrfs_root *root, int datacsum, int packing,
+			 int noxattr)
+{
+	struct btrfs_key location;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct ext2_inode ext2_inode;
+	ext2_inode_scan ext2_scan;
+	ext2_ino_t ext2_ino;
+	int found_root = 0;
+	int ret;
+
+	trans = btrfs_start_transaction(root, 1);
+	BUG_ON(!trans);
+	ret = btrfs_fix_block_accounting(trans, root);
+	if (ret)
+		goto err;
+	ret = make_convert_data_block_groups(trans, fs_info, cfg);
+	if (ret)
+		goto err;
+	ret = btrfs_make_root_dir(trans, fs_info->tree_root,
+				  BTRFS_ROOT_TREE_DIR_OBJECTID);
+	if (ret)
+		goto err;
+	memcpy(&location, &root->root_key, sizeof(location));
+	location.offset = (u64)-1;
+	ret = btrfs_insert_dir_item(trans, fs_info->tree_root, "default", 7,
+				btrfs_super_root_dir(fs_info->super_copy),
+				&location, BTRFS_FT_DIR, 0);
+	if (ret)
+		goto err;
+	ret = btrfs_insert_inode_ref(trans, fs_info->tree_root, "default", 7,
+				location.objectid,
+				btrfs_super_root_dir(fs_info->super_copy), 0);
+	if (ret)
+		goto err;
+	btrfs_set_root_dirid(&fs_info->fs_root->root_item,
+			     BTRFS_FIRST_FREE_OBJECTID);
+
+	/* subvol for ext2 image file */
+	ret = create_subvol(trans, root, CONV_IMAGE_SUBVOL_OBJECTID);
+	BUG_ON(ret);
+	/* subvol for data relocation */
+	ret = create_subvol(trans, root, BTRFS_DATA_RELOC_TREE_OBJECTID);
+	BUG_ON(ret);
+
+	/*
+	 * Copy root inode for fs_root. Or we will be unable to do
+	 * link_subvol().
+	 * And it can't be done before create_subvol(), as it will copy
+	 * tree root, including all its contents.
+	 */
+	ret = ext2fs_open_inode_scan(ext2_fs, 0, &ext2_scan);
+	if (ret) {
+		fprintf(stderr, "ext2fs_open_inode_scan: %s\n",
+			error_message(ret));
+		return -EIO;
+	}
+
+	while (!(ret = ext2fs_get_next_inode(ext2_scan, &ext2_ino,
+					     &ext2_inode))) {
+		if (ext2_ino == 0 || ext2_ino >= EXT2_GOOD_OLD_FIRST_INO)
+			break;
+		if (ext2_ino == EXT2_ROOT_INO) {
+			found_root = 1;
+			break;
+		}
+	}
+	ext2fs_close_inode_scan(ext2_scan);
+
+	if (found_root) {
+		ret = copy_single_inode(trans, root, BTRFS_FIRST_FREE_OBJECTID,
+					ext2_fs, ext2_ino, &ext2_inode,
+					datacsum, packing, noxattr);
+		if (ret < 0)
+			goto err;
+	} else {
+		ret = -ENOENT;
+		goto err;
+	}
+
+	ret = btrfs_commit_transaction(trans, root);
+	BUG_ON(ret);
+err:
+	return ret;
+}
+
 static int init_btrfs(struct btrfs_root *root)
 {
 	int ret;
-- 
2.6.2

