Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:34347 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752341AbdH3R2G (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Aug 2017 13:28:06 -0400
Received: by mail-pf0-f178.google.com with SMTP id l87so11274661pfj.1
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Aug 2017 10:28:06 -0700 (PDT)
From: Yingyi Luo <yingyil@google.com>
To: linux-btrfs@vger.kernel.org
Cc: drosen@google.com, yingyil <yingyil@google.com>
Subject: [PATCH 1/4 v2] btrfs-progs: convert: move link_subvol out of main
Date: Wed, 30 Aug 2017 10:24:47 -0700
Message-Id: <20170830172450.27460-2-yingyil@google.com>
In-Reply-To: <20170830172450.27460-1-yingyil@google.com>
References: <20170825232101.10859-1-yingyil@google.com>
 <20170830172450.27460-1-yingyil@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: yingyil <yingyil@google.com>

link_subvol() is moved to utils.c and renamed as btrfs_link_subvol().
The change cascades down to the callchain.

Signed-off-by: yingyil <yingyil@google.com>
---
v2: split the original patch to make code movement into a separate patch.

 convert/main.c | 125 +--------------------------------------------------------
 utils.c        | 123 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.h        |   3 ++
 3 files changed, 127 insertions(+), 124 deletions(-)

diff --git a/convert/main.c b/convert/main.c
index 03da9e49..8f7fec25 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -834,129 +834,6 @@ out:
 	return ret;
 }
 
-static struct btrfs_root* link_subvol(struct btrfs_root *root,
-		const char *base, u64 root_objectid)
-{
-	struct btrfs_trans_handle *trans;
-	struct btrfs_fs_info *fs_info = root->fs_info;
-	struct btrfs_root *tree_root = fs_info->tree_root;
-	struct btrfs_root *new_root = NULL;
-	struct btrfs_path path;
-	struct btrfs_inode_item *inode_item;
-	struct extent_buffer *leaf;
-	struct btrfs_key key;
-	u64 dirid = btrfs_root_dirid(&root->root_item);
-	u64 index = 2;
-	char buf[BTRFS_NAME_LEN + 1]; /* for snprintf null */
-	int len;
-	int i;
-	int ret;
-
-	len = strlen(base);
-	if (len == 0 || len > BTRFS_NAME_LEN)
-		return NULL;
-
-	btrfs_init_path(&path);
-	key.objectid = dirid;
-	key.type = BTRFS_DIR_INDEX_KEY;
-	key.offset = (u64)-1;
-
-	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
-	if (ret <= 0) {
-		error("search for DIR_INDEX dirid %llu failed: %d",
-				(unsigned long long)dirid, ret);
-		goto fail;
-	}
-
-	if (path.slots[0] > 0) {
-		path.slots[0]--;
-		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
-		if (key.objectid == dirid && key.type == BTRFS_DIR_INDEX_KEY)
-			index = key.offset + 1;
-	}
-	btrfs_release_path(&path);
-
-	trans = btrfs_start_transaction(root, 1);
-	if (!trans) {
-		error("unable to start transaction");
-		goto fail;
-	}
-
-	key.objectid = dirid;
-	key.offset = 0;
-	key.type =  BTRFS_INODE_ITEM_KEY;
-
-	ret = btrfs_lookup_inode(trans, root, &path, &key, 1);
-	if (ret) {
-		error("search for INODE_ITEM %llu failed: %d",
-				(unsigned long long)dirid, ret);
-		goto fail;
-	}
-	leaf = path.nodes[0];
-	inode_item = btrfs_item_ptr(leaf, path.slots[0],
-				    struct btrfs_inode_item);
-
-	key.objectid = root_objectid;
-	key.offset = (u64)-1;
-	key.type = BTRFS_ROOT_ITEM_KEY;
-
-	memcpy(buf, base, len);
-	for (i = 0; i < 1024; i++) {
-		ret = btrfs_insert_dir_item(trans, root, buf, len,
-					    dirid, &key, BTRFS_FT_DIR, index);
-		if (ret != -EEXIST)
-			break;
-		len = snprintf(buf, ARRAY_SIZE(buf), "%s%d", base, i);
-		if (len < 1 || len > BTRFS_NAME_LEN) {
-			ret = -EINVAL;
-			break;
-		}
-	}
-	if (ret)
-		goto fail;
-
-	btrfs_set_inode_size(leaf, inode_item, len * 2 +
-			     btrfs_inode_size(leaf, inode_item));
-	btrfs_mark_buffer_dirty(leaf);
-	btrfs_release_path(&path);
-
-	/* add the backref first */
-	ret = btrfs_add_root_ref(trans, tree_root, root_objectid,
-				 BTRFS_ROOT_BACKREF_KEY,
-				 root->root_key.objectid,
-				 dirid, index, buf, len);
-	if (ret) {
-		error("unable to add root backref for %llu: %d",
-				root->root_key.objectid, ret);
-		goto fail;
-	}
-
-	/* now add the forward ref */
-	ret = btrfs_add_root_ref(trans, tree_root, root->root_key.objectid,
-				 BTRFS_ROOT_REF_KEY, root_objectid,
-				 dirid, index, buf, len);
-	if (ret) {
-		error("unable to add root ref for %llu: %d",
-				root->root_key.objectid, ret);
-		goto fail;
-	}
-
-	ret = btrfs_commit_transaction(trans, root);
-	if (ret) {
-		error("transaction commit failed: %d", ret);
-		goto fail;
-	}
-
-	new_root = btrfs_read_fs_root(fs_info, &key);
-	if (IS_ERR(new_root)) {
-		error("unable to fs read root: %lu", PTR_ERR(new_root));
-		new_root = NULL;
-	}
-fail:
-	btrfs_init_path(&path);
-	return new_root;
-}
-
 static int create_subvol(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root, u64 root_objectid)
 {
@@ -1315,7 +1192,7 @@ static int do_convert(const char *devname, u32 convert_flags, u32 nodesize,
 		task_deinit(ctx.info);
 	}
 
-	image_root = link_subvol(root, subvol_name, CONV_IMAGE_SUBVOL_OBJECTID);
+	image_root = btrfs_link_subvol(root, subvol_name, CONV_IMAGE_SUBVOL_OBJECTID);
 	if (!image_root) {
 		error("unable to link subvolume %s", subvol_name);
 		goto fail;
diff --git a/utils.c b/utils.c
index bb049133..32382328 100644
--- a/utils.c
+++ b/utils.c
@@ -2574,3 +2574,126 @@ u8 rand_u8(void)
 void btrfs_config_init(void)
 {
 }
+
+struct btrfs_root *btrfs_link_subvol(struct btrfs_root *root,
+		const char *base, u64 root_objectid)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_root *tree_root = fs_info->tree_root;
+	struct btrfs_root *new_root = NULL;
+	struct btrfs_path path;
+	struct btrfs_inode_item *inode_item;
+	struct extent_buffer *leaf;
+	struct btrfs_key key;
+	u64 dirid = btrfs_root_dirid(&root->root_item);
+	u64 index = 2;
+	char buf[BTRFS_NAME_LEN + 1]; /* for snprintf null */
+	int len;
+	int i;
+	int ret;
+
+	len = strlen(base);
+	if (len == 0 || len > BTRFS_NAME_LEN)
+		return NULL;
+
+	btrfs_init_path(&path);
+	key.objectid = dirid;
+	key.type = BTRFS_DIR_INDEX_KEY;
+	key.offset = (u64)-1;
+
+	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
+	if (ret <= 0) {
+		error("search for DIR_INDEX dirid %llu failed: %d",
+				(unsigned long long)dirid, ret);
+		goto fail;
+	}
+
+	if (path.slots[0] > 0) {
+		path.slots[0]--;
+		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
+		if (key.objectid == dirid && key.type == BTRFS_DIR_INDEX_KEY)
+			index = key.offset + 1;
+	}
+	btrfs_release_path(&path);
+
+	trans = btrfs_start_transaction(root, 1);
+	if (!trans) {
+		error("unable to start transaction");
+		goto fail;
+	}
+
+	key.objectid = dirid;
+	key.offset = 0;
+	key.type =  BTRFS_INODE_ITEM_KEY;
+
+	ret = btrfs_lookup_inode(trans, root, &path, &key, 1);
+	if (ret) {
+		error("search for INODE_ITEM %llu failed: %d",
+				(unsigned long long)dirid, ret);
+		goto fail;
+	}
+	leaf = path.nodes[0];
+	inode_item = btrfs_item_ptr(leaf, path.slots[0],
+				    struct btrfs_inode_item);
+
+	key.objectid = root_objectid;
+	key.offset = (u64)-1;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+
+	memcpy(buf, base, len);
+	for (i = 0; i < 1024; i++) {
+		ret = btrfs_insert_dir_item(trans, root, buf, len, dirid,
+					    &key, BTRFS_FT_DIR, index);
+		if (ret != -EEXIST)
+			break;
+		len = snprintf(buf, ARRAY_SIZE(buf), "%s%d", base, i);
+		if (len < 1 || len > BTRFS_NAME_LEN) {
+			ret = -EINVAL;
+			break;
+		}
+	}
+	if (ret)
+		goto fail;
+
+	btrfs_set_inode_size(leaf, inode_item, len * 2 +
+			     btrfs_inode_size(leaf, inode_item));
+	btrfs_mark_buffer_dirty(leaf);
+	btrfs_release_path(&path);
+
+	/* add the backref first */
+	ret = btrfs_add_root_ref(trans, tree_root, root_objectid,
+				 BTRFS_ROOT_BACKREF_KEY,
+				 root->root_key.objectid,
+				 dirid, index, buf, len);
+	if (ret) {
+		error("unable to add root backref for %llu: %d",
+				root->root_key.objectid, ret);
+		goto fail;
+	}
+
+	/* now add the forward ref */
+	ret = btrfs_add_root_ref(trans, tree_root, root->root_key.objectid,
+				 BTRFS_ROOT_REF_KEY, root_objectid,
+				 dirid, index, buf, len);
+	if (ret) {
+		error("unable to add root ref for %llu: %d",
+				root->root_key.objectid, ret);
+		goto fail;
+	}
+
+	ret = btrfs_commit_transaction(trans, root);
+	if (ret) {
+		error("transaction commit failed: %d", ret);
+		goto fail;
+	}
+
+	new_root = btrfs_read_fs_root(fs_info, &key);
+	if (IS_ERR(new_root)) {
+		error("unable to fs read root: %lu", PTR_ERR(new_root));
+		new_root = NULL;
+	}
+fail:
+	btrfs_init_path(&path);
+	return new_root;
+}
diff --git a/utils.h b/utils.h
index 091f8fab..886590fd 100644
--- a/utils.h
+++ b/utils.h
@@ -170,4 +170,7 @@ u64 rand_u64(void);
 unsigned int rand_range(unsigned int upper);
 void init_rand_seed(u64 seed);
 
+struct btrfs_root *btrfs_link_subvol(struct btrfs_root *root, const char *base,
+				     u64 root_objectid);
+
 #endif
-- 
2.14.1.342.g6490525c54-goog

