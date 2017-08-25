Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f45.google.com ([74.125.83.45]:37231 "EHLO
        mail-pg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932550AbdHYXZj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Aug 2017 19:25:39 -0400
Received: by mail-pg0-f45.google.com with SMTP id 83so6215644pgb.4
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Aug 2017 16:25:38 -0700 (PDT)
From: Yingyi Luo <yingyil@google.com>
To: linux-btrfs@vger.kernel.org
Cc: yingyil <yingyil@google.com>
Subject: [PATCH 1/1] btrfs-progs: mkfs: add subvolume support to mkfs
Date: Fri, 25 Aug 2017 16:21:01 -0700
Message-Id: <20170825232101.10859-2-yingyil@google.com>
In-Reply-To: <20170825232101.10859-1-yingyil@google.com>
References: <20170825232101.10859-1-yingyil@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: yingyil <yingyil@google.com>

Add -S/--subvol [NAME] option to configure. It enables users to create a
subvolume under the toplevel volume and populate the created subvolume
with files from the rootdir specified by -r/--rootdir option.

Two functions link_subvol() and create_subvol() are moved from
convert/main.c to utils.c to enable code reuse.

Signed-off-by: yingyil <yingyil@google.com>
---
 convert/main.c | 161 ---------------------------------------------------------
 mkfs/main.c    |  73 ++++++++++++++++++++++++--
 utils.c        | 161 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.h        |   5 ++
 4 files changed, 234 insertions(+), 166 deletions(-)

diff --git a/convert/main.c b/convert/main.c
index 0deccd9..93609ed 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -832,167 +832,6 @@ out:
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
-static int create_subvol(struct btrfs_trans_handle *trans,
-			 struct btrfs_root *root, u64 root_objectid)
-{
-	struct extent_buffer *tmp;
-	struct btrfs_root *new_root;
-	struct btrfs_key key;
-	struct btrfs_root_item root_item;
-	int ret;
-
-	ret = btrfs_copy_root(trans, root, root->node, &tmp,
-			      root_objectid);
-	if (ret)
-		return ret;
-
-	memcpy(&root_item, &root->root_item, sizeof(root_item));
-	btrfs_set_root_bytenr(&root_item, tmp->start);
-	btrfs_set_root_level(&root_item, btrfs_header_level(tmp));
-	btrfs_set_root_generation(&root_item, trans->transid);
-	free_extent_buffer(tmp);
-
-	key.objectid = root_objectid;
-	key.type = BTRFS_ROOT_ITEM_KEY;
-	key.offset = trans->transid;
-	ret = btrfs_insert_root(trans, root->fs_info->tree_root,
-				&key, &root_item);
-
-	key.offset = (u64)-1;
-	new_root = btrfs_read_fs_root(root->fs_info, &key);
-	if (!new_root || IS_ERR(new_root)) {
-		error("unable to fs read root: %lu", PTR_ERR(new_root));
-		return PTR_ERR(new_root);
-	}
-
-	ret = btrfs_make_root_dir(trans, new_root, BTRFS_FIRST_FREE_OBJECTID);
-
-	return ret;
-}
-
 /*
  * New make_btrfs() has handle system and meta chunks quite well.
  * So only need to add remaining data chunks.
diff --git a/mkfs/main.c b/mkfs/main.c
index 2b109a5..107cfc2 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -365,6 +365,7 @@ static void print_usage(int ret)
 	printf("  creation:\n");
 	printf("\t-b|--byte-count SIZE    set filesystem size to SIZE (on the first device)\n");
 	printf("\t-r|--rootdir DIR        copy files from DIR to the image root directory\n");
+	printf("\t-S|--subvol NAME        create a sunvolume with NAME and copy files from ROOTDIR to the subvolume\n");
 	printf("\t-K|--nodiscard          do not perform whole device TRIM\n");
 	printf("\t-f|--force              force overwrite of existing filesystem\n");
 	printf("  general:\n");
@@ -413,6 +414,18 @@ static char *parse_label(const char *input)
 	return strdup(input);
 }
 
+static char *parse_subvol_name(const char *input)
+{
+	int len = strlen(input);
+
+	if (len >= BTRFS_SUBVOL_NAME_MAX) {
+		error("subvolume name %s is too long (max %d)",
+			input, BTRFS_SUBVOL_NAME_MAX - 1);
+		exit(1);
+	}
+	return strdup(input);
+}
+
 static int add_directory_items(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root, u64 objectid,
 			       ino_t parent_inum, const char *name,
@@ -1420,6 +1433,8 @@ int main(int argc, char **argv)
 	int discard = 1;
 	int ssd = 0;
 	int force_overwrite = 0;
+	char *subvol_name = NULL;
+	int subvol_name_set = 0;
 	char *source_dir = NULL;
 	int source_dir_set = 0;
 	u64 num_of_meta_chunks = 0;
@@ -1446,6 +1461,7 @@ int main(int argc, char **argv)
 			{ "sectorsize", required_argument, NULL, 's' },
 			{ "data", required_argument, NULL, 'd' },
 			{ "version", no_argument, NULL, 'V' },
+			{ "subvol", required_argument, NULL, 'S'},
 			{ "rootdir", required_argument, NULL, 'r' },
 			{ "nodiscard", no_argument, NULL, 'K' },
 			{ "features", required_argument, NULL, 'O' },
@@ -1455,7 +1471,7 @@ int main(int argc, char **argv)
 			{ NULL, 0, NULL, 0}
 		};
 
-		c = getopt_long(argc, argv, "A:b:fl:n:s:m:d:L:O:r:U:VMKq",
+		c = getopt_long(argc, argv, "A:b:fl:n:s:m:d:L:O:S:r:U:VMKq",
 				long_options, NULL);
 		if (c < 0)
 			break;
@@ -1517,6 +1533,10 @@ int main(int argc, char **argv)
 						PACKAGE_STRING);
 				exit(0);
 				break;
+			case 'S':
+				subvol_name = parse_subvol_name(optarg);
+				subvol_name_set = 1;
+				break;
 			case 'r':
 				source_dir = optarg;
 				source_dir_set = 1;
@@ -1537,6 +1557,11 @@ int main(int argc, char **argv)
 		}
 	}
 
+	if (subvol_name_set && !source_dir_set) {
+		error("root directory needs to be set");
+		exit(1);
+	}
+
 	if (verbose) {
 		printf("%s\n", PACKAGE_STRING);
 		printf("See %s for more information.\n\n", PACKAGE_URL);
@@ -1876,10 +1901,48 @@ raid_groups:
 			goto out;
 		}
 
-		ret = make_image(source_dir, root, fd);
-		if (ret) {
-			error("error wihle filling filesystem: %d", ret);
-			goto out;
+		if (subvol_name_set) {
+			u64 dirid, objectid;
+			struct btrfs_root *file_root;
+
+			dirid = btrfs_root_dirid(&fs_info->tree_root->root_item);
+			ret = btrfs_find_free_objectid(NULL, fs_info->tree_root, dirid, &objectid);
+			if (ret) {
+				error("unable to find a free objectid: %d", ret);
+				goto out;
+			}
+			trans = btrfs_start_transaction(root, 1);
+			if (!trans) {
+				error("unable to start transaction");
+				ret = -EINVAL;
+				goto out;
+			}
+			ret = create_subvol(trans, root, objectid);
+			if (ret < 0) {
+				error("failed to create subvolume: %d", ret);
+				goto out;
+			}
+			ret = btrfs_commit_transaction(trans, root);
+			if (ret) {
+				error("unable to commit transaction: %d", ret);
+				goto out;
+			}
+			file_root = link_subvol(root, subvol_name, objectid);
+			if (!file_root) {
+				error("unable to link the subvolume %s", subvol_name);
+				goto out;
+			}
+			ret = make_image(source_dir, file_root, fd);
+			if (ret) {
+				error("error while filling filesystem: %d", ret);
+				goto out;
+			}
+		} else {
+			ret = make_image(source_dir, root, fd);
+			if (ret) {
+				error("error while filling filesystem: %d", ret);
+				goto out;
+			}
 		}
 	}
 	ret = cleanup_temp_chunks(fs_info, &allocation, data_profile,
diff --git a/utils.c b/utils.c
index bb04913..c9bbbed 100644
--- a/utils.c
+++ b/utils.c
@@ -2574,3 +2574,164 @@ u8 rand_u8(void)
 void btrfs_config_init(void)
 {
 }
+
+struct btrfs_root *link_subvol(struct btrfs_root *root,
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
+        }
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
+		ret = btrfs_insert_dir_item(trans, root, buf, len,
+					    dirid, &key, BTRFS_FT_DIR, index);
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
+        /* now add the forward ref */
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
+
+int create_subvol(struct btrfs_trans_handle *trans,
+		  struct btrfs_root *root, u64 root_objectid)
+{
+	struct extent_buffer *tmp;
+	struct btrfs_root *new_root;
+	struct btrfs_key key;
+	struct btrfs_root_item root_item;
+	int ret;
+
+	ret = btrfs_copy_root(trans, root, root->node, &tmp,
+			      root_objectid);
+	if (ret)
+		return ret;
+
+	memcpy(&root_item, &root->root_item, sizeof(root_item));
+	btrfs_set_root_bytenr(&root_item, tmp->start);
+	btrfs_set_root_level(&root_item, btrfs_header_level(tmp));
+	btrfs_set_root_generation(&root_item, trans->transid);
+	free_extent_buffer(tmp);
+
+	key.objectid = root_objectid;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = trans->transid;
+	ret = btrfs_insert_root(trans, root->fs_info->tree_root,
+				&key, &root_item);
+
+	key.offset = (u64)-1;
+	new_root = btrfs_read_fs_root(root->fs_info, &key);
+	if (!new_root || IS_ERR(new_root)) {
+		error("unable to fs read root: %lu", PTR_ERR(new_root));
+		return PTR_ERR(new_root);
+	}
+
+	ret = btrfs_make_root_dir(trans, new_root, BTRFS_FIRST_FREE_OBJECTID);
+
+	return ret;
+}
diff --git a/utils.h b/utils.h
index 091f8fa..777476f 100644
--- a/utils.h
+++ b/utils.h
@@ -170,4 +170,9 @@ u64 rand_u64(void);
 unsigned int rand_range(unsigned int upper);
 void init_rand_seed(u64 seed);
 
+struct btrfs_root *link_subvol(struct btrfs_root *root,
+			       const char *base, u64 root_objectid);
+int create_subvol(struct btrfs_trans_handle *trans,
+		  struct btrfs_root *root, u64 root_objectid);
+
 #endif
-- 
2.14.1.342.g6490525c54-goog

