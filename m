Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:8752 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751135AbeBBI2J (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Feb 2018 03:28:09 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id D841549F19BC
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Feb 2018 16:28:01 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 02/10] btrfs-progs: extract btrfs_link_subvol from btrfs_mksubvol
Date: Fri, 2 Feb 2018 16:27:43 +0800
Message-ID: <20180202082751.26225-3-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180202082751.26225-1-lufq.fnst@cn.fujitsu.com>
References: <20180202082751.26225-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The original btrfs_mksubvol is too specific to specify the directory that
the subvolume will link to. Furthermore, in this transaction, we don't only
need to create root_ref/dir-item, but also update the refs or flags of
root_item. Extract a generic btrfs_link_subvol that allow the caller pass a
trans argument for later subvolume undelete.

No functional changes for the btrfs_mksubvol.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 convert/main.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ctree.h        |  5 +++--
 inode.c        | 46 +++++++++++++++++++++-------------------------
 3 files changed, 81 insertions(+), 27 deletions(-)

diff --git a/convert/main.c b/convert/main.c
index b3ea31d7af43..e997bdb822c5 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -1002,6 +1002,63 @@ err:
 	return ret;
 }
 
+/*
+ * Link the subvolume specified by @root_objectid to the root_dir of @root.
+ *
+ * @root		the root of the file tree which the subvolume will
+ *			be linked to.
+ * @subvol_name		the name of the subvolume which will be linked.
+ * @root_objectid	specify the subvolume which will be linked.
+ * @convert		the flag to determine whether to try to resolve
+ *			the name conflict.
+ *
+ * Return the root of the subvolume if success, otherwise return NULL.
+ */
+static struct btrfs_root *btrfs_mksubvol(struct btrfs_root *root,
+					 const char *subvol_name,
+					 u64 root_objectid,
+					 bool convert)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *subvol_root = NULL;
+	struct btrfs_key key;
+	u64 dirid = btrfs_root_dirid(&root->root_item);
+	int ret;
+
+
+	trans = btrfs_start_transaction(root, 1);
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
+	if (!subvol_root) {
+		error("unable to link subvolume %s", subvol_name);
+		goto fail;
+	}
+
+fail:
+	return subvol_root;
+}
+
 /*
  * Migrate super block to its default position and zero 0 ~ 16k
  */
diff --git a/ctree.h b/ctree.h
index 84bad186a349..18f7c79ddeec 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2788,8 +2788,9 @@ int btrfs_del_orphan_item(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root, u64 offset);
 int btrfs_mkdir(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		char *name, int namelen, u64 parent_ino, u64 *ino, int mode);
-struct btrfs_root *btrfs_mksubvol(struct btrfs_root *root, const char *base,
-				  u64 root_objectid, bool convert);
+int btrfs_link_subvol(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		      const char *base, u64 root_objectid, u64 dirid,
+		      bool convert);
 
 /* file.c */
 int btrfs_get_extent(struct btrfs_trans_handle *trans,
diff --git a/inode.c b/inode.c
index 8d0812c7cf50..478036562652 100644
--- a/inode.c
+++ b/inode.c
@@ -606,19 +606,28 @@ out:
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
+ * @convert		the flag to determine whether to try to resolve
+ *			the name conflict.
+ */
+int btrfs_link_subvol(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		      const char *base, u64 root_objectid, u64 dirid,
+		      bool convert)
 {
-	struct btrfs_trans_handle *trans;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_root *tree_root = fs_info->tree_root;
-	struct btrfs_root *new_root = NULL;
 	struct btrfs_path path;
 	struct btrfs_inode_item *inode_item;
 	struct extent_buffer *leaf;
 	struct btrfs_key key;
-	u64 dirid = btrfs_root_dirid(&root->root_item);
 	u64 index = 2;
 	char buf[BTRFS_NAME_LEN + 1]; /* for snprintf null */
 	int len;
@@ -627,8 +636,9 @@ struct btrfs_root *btrfs_mksubvol(struct btrfs_root *root,
 
 	len = strlen(base);
 	if (len == 0 || len > BTRFS_NAME_LEN)
-		return NULL;
+		return -EINVAL;
 
+	/* find the free dir_index */
 	btrfs_init_path(&path);
 	key.objectid = dirid;
 	key.type = BTRFS_DIR_INDEX_KEY;
@@ -649,12 +659,7 @@ struct btrfs_root *btrfs_mksubvol(struct btrfs_root *root,
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
@@ -675,6 +680,7 @@ struct btrfs_root *btrfs_mksubvol(struct btrfs_root *root,
 
 	memcpy(buf, base, len);
 	if (convert) {
+		/* try to resolve name conflict by adding the number suffix */
 		for (i = 0; i < 1024; i++) {
 			ret = btrfs_insert_dir_item(trans, root, buf, len,
 					dirid, &key, BTRFS_FT_DIR, index);
@@ -719,18 +725,8 @@ struct btrfs_root *btrfs_mksubvol(struct btrfs_root *root,
 		goto fail;
 	}
 
-	ret = btrfs_commit_transaction(trans, root);
-	if (ret) {
-		error("transaction commit failed: %d", ret);
-		goto fail;
-	}
 
-	new_root = btrfs_read_fs_root(fs_info, &key);
-	if (IS_ERR(new_root)) {
-		error("unable to fs read root: %lu", PTR_ERR(new_root));
-		new_root = NULL;
-	}
 fail:
-	btrfs_init_path(&path);
-	return new_root;
+	btrfs_release_path(&path);
+	return ret;
 }
-- 
2.16.1



