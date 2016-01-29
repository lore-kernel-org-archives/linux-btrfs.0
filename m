Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:34115 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751867AbcA2FQq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jan 2016 00:16:46 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, David Sterba <dsterba@suse.com>
Subject: [PATCH v3 18/22] btrfs-progs: convert: Introduce init_btrfs_v2 function.
Date: Fri, 29 Jan 2016 13:03:28 +0800
Message-Id: <1454043812-7893-19-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1454043812-7893-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1454043812-7893-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce new init_btrfs_v2() function for later newer do_convert().

Since we have good enough chunk allocation, a lot of wired chunk hack
won't ever be used.
We only need to insert data chunks and create needed subvolume.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 btrfs-convert.c | 61 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 8956a86..ce6c59b 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2302,6 +2302,67 @@ static int make_convert_data_block_groups(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+/*
+ * Init the temp btrfs to a operational status.
+ *
+ * It will fix the extent usage accounting(XXX: Do we really need?) and
+ * insert needed data chunks, to ensure all old fs data extents are covered
+ * by DATA chunks, preventing wrong chunks are allocated.
+ *
+ * And also create convert image subvolume and relocation tree.
+ * (XXX: Not need again?)
+ * But the convert image subvolume is *NOT* linked to fs tree yet.
+ */
+static int init_btrfs_v2(struct btrfs_mkfs_config *cfg, struct btrfs_root *root,
+			 struct btrfs_convert_context *cctx, int datacsum,
+			 int packing, int noxattr)
+{
+	struct btrfs_key location;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	int ret;
+
+	trans = btrfs_start_transaction(root, 1);
+	BUG_ON(!trans);
+	ret = btrfs_fix_block_accounting(trans, root);
+	if (ret)
+		goto err;
+	ret = make_convert_data_block_groups(trans, fs_info, cfg, cctx);
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
+	/* subvol for fs image file */
+	ret = create_subvol(trans, root, CONV_IMAGE_SUBVOL_OBJECTID);
+	if (ret < 0)
+		goto err;
+	/* subvol for data relocation tree */
+	ret = create_subvol(trans, root, BTRFS_DATA_RELOC_TREE_OBJECTID);
+	if (ret < 0)
+		goto err;
+
+	ret = btrfs_commit_transaction(trans, root);
+err:
+	return ret;
+}
+
 static int init_btrfs(struct btrfs_root *root)
 {
 	int ret;
-- 
2.7.0



