Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:12219 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751874AbeEGDKp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 May 2018 23:10:45 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id EB8EA4B34D33
        for <linux-btrfs@vger.kernel.org>; Mon,  7 May 2018 11:10:42 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v3 02/10] btrfs-progs: extract btrfs_link_subvol from btrfs_mksubvol
Date: Mon, 7 May 2018 11:10:25 +0800
Message-ID: <20180507031033.4125-3-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180507031033.4125-1-lufq.fnst@cn.fujitsu.com>
References: <20180507031033.4125-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The original btrfs_mksubvol is too specific to specify the directory that
the subvolume will link to. Furthermore, in this transaction, we don't only
need to create root_ref/dir-item, but also update the flags of root_item.
Extract a generic btrfs_link_subvol that allow the caller pass a trans
argument for later subvolume undelete. And rename the original
btrfs_mksubvol to link_subvol_for_convert since it is a less generic
btrfs_link_subvol.

No functional changes.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
V3:
rename the btrfs_mksubvol to link_subvol_for_convert;
remove the redundant parameter convert from link_subvol_for_convert;
rename convert to resolve_conflict in btrfs_link_subvol;
set root refs to 1 in btrfs_link_subvol.

 convert/main.c | 59 ++++++++++++++++++++++++++++++++++++++++++--
 ctree.h        |  5 ++--
 inode.c        | 66 ++++++++++++++++++++++++++++++++------------------
 3 files changed, 103 insertions(+), 27 deletions(-)

diff --git a/convert/main.c b/convert/main.c
index 80f3bed84c84..b092e25bccbb 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -1002,6 +1002,61 @@ err:
 	return ret;
 }
 
+/*
+ * Link the subvolume specified by @root_objectid to the root_dir of @root.
+ *
+ * @root		the root of the file tree which the subvolume will
+ *			be linked to.
+ * @subvol_name		the name of the subvolume which will be named.
+ * @root_objectid	specify the subvolume which will be linked.
+ *
+ * Return the root of the subvolume if success, otherwise return NULL.
+ */
+static struct btrfs_root *link_subvol_for_convert(struct btrfs_root *root,
+						  const char *subvol_name,
+						  u64 root_objectid)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *subvol_root = NULL;
+	struct btrfs_key key;
+	u64 dirid = btrfs_root_dirid(&root->root_item);
+	int ret;
+
+	/*
+	 * 2 for dir's dir_index and dir_item for the subvolume
+	 * 2 for the subvolume's root_ref and root_backref
+	 */
+	trans = btrfs_start_transaction(root, 4);
+	if (IS_ERR(trans)) {
+		error("unable to start transaction");
+		goto fail;
+	}
+
+	ret = btrfs_link_subvol(trans, root, subvol_name, root_objectid, dirid,
+				true);
+	if (ret) {
+		error("unable to link subvolume %s", subvol_name);
+		goto fail;
+	}
+
+	ret = btrfs_commit_transaction(trans, root);
+	if (ret) {
+		error("transaction commit failed: %d", ret);
+		goto fail;
+	}
+
+	key.objectid = root_objectid;
+	key.offset = (u64)-1;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+
+	subvol_root = btrfs_read_fs_root(root->fs_info, &key);
+	if (!subvol_root)
+		error("unable to link subvolume %s", subvol_name);
+
+fail:
+	return subvol_root;
+}
+
 /*
  * Migrate super block to its default position and zero 0 ~ 16k
  */
@@ -1194,8 +1249,8 @@ static int do_convert(const char *devname, u32 convert_flags, u32 nodesize,
 		task_deinit(ctx.info);
 	}
 
-	image_root = btrfs_mksubvol(root, subvol_name,
-				    CONV_IMAGE_SUBVOL_OBJECTID, true);
+	image_root = link_subvol_for_convert(root, subvol_name,
+					     CONV_IMAGE_SUBVOL_OBJECTID);
 	if (!image_root) {
 		error("unable to link subvolume %s", subvol_name);
 		goto fail;
diff --git a/ctree.h b/ctree.h
index 46a1dbfd2f27..2ac1eb532986 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2800,8 +2800,9 @@ int btrfs_del_orphan_item(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root, u64 offset);
 int btrfs_mkdir(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		char *name, int namelen, u64 parent_ino, u64 *ino, int mode);
-struct btrfs_root *btrfs_mksubvol(struct btrfs_root *root, const char *base,
-				  u64 root_objectid, bool convert);
+int btrfs_link_subvol(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		      const char *base, u64 root_objectid, u64 dirid,
+		      bool resolve_conflict);
 
 /* file.c */
 int btrfs_get_extent(struct btrfs_trans_handle *trans,
diff --git a/inode.c b/inode.c
index 8d0812c7cf50..f9b72533f3a9 100644
--- a/inode.c
+++ b/inode.c
@@ -606,20 +606,31 @@ out:
 	return ret;
 }
 
-struct btrfs_root *btrfs_mksubvol(struct btrfs_root *root,
-				  const char *base, u64 root_objectid,
-				  bool convert)
+/*
+ * Link the subvolume specified by @root_objectid to the directory specified by
+ * @dirid on the file tree specified by @root.
+ *
+ * @root		the root of the file tree where the directory on.
+ * @base		the name of the subvolume which will be linked.
+ * @root_objectid	specify the subvolume which will be linked.
+ * @dirid		specify the directory which the subvolume will be
+ *			linked to.
+ * @resolve_conflict	the flag to determine whether to try to resolve
+ *			the name conflict.
+ */
+int btrfs_link_subvol(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		      const char *base, u64 root_objectid, u64 dirid,
+		      bool resolve_conflict)
 {
-	struct btrfs_trans_handle *trans;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_root *tree_root = fs_info->tree_root;
-	struct btrfs_root *new_root = NULL;
 	struct btrfs_path path;
 	struct btrfs_inode_item *inode_item;
+	struct btrfs_root_item root_item;
 	struct extent_buffer *leaf;
 	struct btrfs_key key;
-	u64 dirid = btrfs_root_dirid(&root->root_item);
 	u64 index = 2;
+	u64 offset;
 	char buf[BTRFS_NAME_LEN + 1]; /* for snprintf null */
 	int len;
 	int i;
@@ -627,8 +638,9 @@ struct btrfs_root *btrfs_mksubvol(struct btrfs_root *root,
 
 	len = strlen(base);
 	if (len == 0 || len > BTRFS_NAME_LEN)
-		return NULL;
+		return -EINVAL;
 
+	/* find the free dir_index */
 	btrfs_init_path(&path);
 	key.objectid = dirid;
 	key.type = BTRFS_DIR_INDEX_KEY;
@@ -649,12 +661,7 @@ struct btrfs_root *btrfs_mksubvol(struct btrfs_root *root,
 	}
 	btrfs_release_path(&path);
 
-	trans = btrfs_start_transaction(root, 1);
-	if (IS_ERR(trans)) {
-		error("unable to start transaction");
-		goto fail;
-	}
-
+	/* add the dir_item/dir_index */
 	key.objectid = dirid;
 	key.offset = 0;
 	key.type =  BTRFS_INODE_ITEM_KEY;
@@ -674,7 +681,8 @@ struct btrfs_root *btrfs_mksubvol(struct btrfs_root *root,
 	key.type = BTRFS_ROOT_ITEM_KEY;
 
 	memcpy(buf, base, len);
-	if (convert) {
+	if (resolve_conflict) {
+		/* try to resolve name conflict by adding the number suffix */
 		for (i = 0; i < 1024; i++) {
 			ret = btrfs_insert_dir_item(trans, root, buf, len,
 					dirid, &key, BTRFS_FT_DIR, index);
@@ -719,18 +727,30 @@ struct btrfs_root *btrfs_mksubvol(struct btrfs_root *root,
 		goto fail;
 	}
 
-	ret = btrfs_commit_transaction(trans, root);
+
+	/* set root refs of the subvolume to 1 */
+	key.objectid = root_objectid;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(trans, tree_root, &key, &path, 0, 0);
 	if (ret) {
-		error("transaction commit failed: %d", ret);
+		error("couldn't find ROOT_ITEM for %llu failed: %d",
+				root_objectid, ret);
 		goto fail;
 	}
 
-	new_root = btrfs_read_fs_root(fs_info, &key);
-	if (IS_ERR(new_root)) {
-		error("unable to fs read root: %lu", PTR_ERR(new_root));
-		new_root = NULL;
-	}
+	leaf = path.nodes[0];
+
+	offset = btrfs_item_ptr_offset(leaf, path.slots[0]);
+	read_extent_buffer(leaf, &root_item, offset, sizeof(root_item));
+
+	btrfs_set_root_refs(&root_item, 1);
+
+	write_extent_buffer(leaf, &root_item, offset, sizeof(root_item));
+	btrfs_mark_buffer_dirty(leaf);
+
 fail:
-	btrfs_init_path(&path);
-	return new_root;
+	btrfs_release_path(&path);
+	return ret;
 }
-- 
2.17.0



