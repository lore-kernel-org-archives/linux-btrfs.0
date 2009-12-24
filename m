From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: [PATCH] btrfs-progs: New utility to swap subvolumes
Date: Thu, 24 Dec 2009 11:18:57 +0900
Message-ID: <4B32CF91.8080908@jp.fujitsu.com>
References: <4B32CF4D.90406@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B32CF4D.90406@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Add btrfsrevert utility to swap subvolumes.

Signed-off-by: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
---
 Makefile      |    5
 btrfsrevert.c |  778 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 782 insertions(+), 1 deletion(-)

Index: b/Makefile
===================================================================
--- a/Makefile	2009-12-24 10:45:24.000000000 +0900
+++ b/Makefile	2009-12-24 10:45:43.000000000 +0900
@@ -17,7 +17,7 @@ bindir = $(prefix)/bin
 LIBS=-luuid

 progs = btrfsctl mkfs.btrfs btrfs-debug-tree btrfs-show btrfs-vol btrfsck \
-	btrfs-map-logical
+	btrfs-map-logical btrfsrevert

 # make C=1 to enable sparse
 ifdef C
@@ -63,6 +63,9 @@ btrfs-map-logical: $(objects) btrfs-map-
 btrfs-image: $(objects) btrfs-image.o
 	gcc $(CFLAGS) -o btrfs-image $(objects) btrfs-image.o -lpthread -lz $(LDFLAGS) $(LIBS)

+btrfsrevert: $(objects) btrfsrevert.o
+	gcc $(CFLAGS) -o btrfsrevert $(objects) btrfsrevert.o $(LDFLAGS) $(LIBS)
+
 dir-test: $(objects) dir-test.o
 	gcc $(CFLAGS) -o dir-test $(objects) dir-test.o $(LDFLAGS) $(LIBS)

Index: b/btrfsrevert.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ b/btrfsrevert.c	2009-12-24 10:45:43.000000000 +0900
@@ -0,0 +1,778 @@
+/*
+ * Copyright (C) 2008 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#define _XOPEN_SOURCE 500
+#define _GNU_SOURCE 1
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <dirent.h>
+#include <uuid/uuid.h>
+#include "kerncompat.h"
+#include "ctree.h"
+#include "disk-io.h"
+#include "transaction.h"
+#include "utils.h"
+#include "version.h"
+#include "ioctl.h"
+#include "hash.h"
+#include <mcheck.h>
+
+#define BTRFS_REVERTED_TREE_LOCATION ".old_trees"
+
+struct tree_info {
+	u64 id, parent_treeid;
+	u64 parent_dirid, index;
+	int name_len;
+	char *name;
+};
+
+struct revert_packet {
+	struct tree_info source, target, backup;
+};
+
+static void print_usage(void)
+{
+	fprintf(stderr, "usage: btrfsrevert [options] device\n");
+	fprintf(stderr, "\t-s source tree\n");
+	fprintf(stderr, "\t-t target tree\n");
+}
+
+static int find_file_tree(struct btrfs_root *root, struct tree_info *tinfo)
+{
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	struct btrfs_root_ref *ref;
+	int ret;
+
+	if (tinfo->id == BTRFS_FS_TREE_OBJECTID) {
+		tinfo->name = malloc(9);
+		strcpy(tinfo->name, "default");
+		tinfo->name_len = 8;
+		return 0;
+	}
+	if (tinfo->id < BTRFS_FIRST_FREE_OBJECTID ||
+		BTRFS_LAST_FREE_OBJECTID < tinfo->id)
+			return 2;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	key.objectid = tinfo->id;
+	key.type = BTRFS_ROOT_BACKREF_KEY;
+	key.offset = (u64)-1;
+
+	ret = btrfs_search_slot(NULL, root->fs_info->tree_root, &key,
+		path, 0, 0);
+	if (ret < 0)
+		goto out;
+
+	BUG_ON(ret == 0);
+	if (path->slots[0] == 0) {
+		ret = btrfs_prev_leaf(root->fs_info->tree_root, path);
+
+		if (ret)
+			goto out;
+	} else
+		path->slots[0]--;
+
+	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+	if (key.objectid == tinfo->id && key.type == BTRFS_ROOT_BACKREF_KEY) {
+		ret = 0;
+		tinfo->parent_treeid = key.offset;
+		ref = btrfs_item_ptr(path->nodes[0], path->slots[0],
+			struct btrfs_root_ref);
+		tinfo->parent_dirid = btrfs_root_ref_dirid(path->nodes[0], ref);
+		tinfo->index = btrfs_root_ref_sequence(path->nodes[0], ref);
+		tinfo->name_len = btrfs_root_ref_name_len(path->nodes[0], ref);
+		tinfo->name = malloc(tinfo->name_len + 1);
+		if (tinfo->name) {
+			tinfo->name[tinfo->name_len] = '\0';
+			read_extent_buffer(path->nodes[0], tinfo->name,
+				(long)(ref + 1), tinfo->name_len);
+		} else
+			ret = -ENOMEM;
+	} else
+		ret = 1;
+
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
+static int btrfs_revert_root(struct btrfs_fs_info *fs_info,
+		struct revert_packet *rvp)
+{
+	printf("Root swap is not implemented yet.\n");
+	return 0;
+}
+
+static int btrfs_update_root_ref(struct btrfs_trans_handle *trans,
+		struct btrfs_root *root, struct btrfs_key *ref_key,
+		struct tree_info *f_tinfo, struct tree_info *t_tinfo,
+		char *new_name)
+{
+	struct btrfs_root *tree_root = root->fs_info->tree_root;
+	struct btrfs_root_ref *oldref;
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	int ret, name_len, new_name_len = strlen(new_name);
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+	if (f_tinfo->parent_treeid != t_tinfo->parent_treeid) {
+		if (ref_key->type == BTRFS_ROOT_REF_KEY) {
+			ret = btrfs_add_root_ref(trans, root->fs_info->tree_root,
+				t_tinfo->parent_treeid, BTRFS_ROOT_REF_KEY, f_tinfo->id,
+				t_tinfo->parent_dirid, t_tinfo->index, new_name,
+				strlen(new_name));
+			if (ret)
+				goto error;
+			ref_key->objectid = t_tinfo->parent_treeid;
+			ref_key->offset = f_tinfo->id;
+
+			key.objectid = f_tinfo->parent_treeid;
+			key.type = BTRFS_ROOT_REF_KEY;
+			key.offset = f_tinfo->id;
+			ret = btrfs_search_slot(trans, tree_root, &key, path,
+				-(sizeof(struct btrfs_root_ref) + f_tinfo->name_len), 1);
+			if (ret)
+				goto error;
+			ret = btrfs_del_item(trans, tree_root, path);
+			if (ret)
+				goto error;
+		} else if (ref_key->type == BTRFS_ROOT_BACKREF_KEY) {
+			ret = btrfs_add_root_ref(trans, root->fs_info->tree_root,
+				f_tinfo->id, BTRFS_ROOT_BACKREF_KEY, t_tinfo->parent_treeid,
+				t_tinfo->parent_dirid, t_tinfo->index, new_name,
+				strlen(new_name));
+			if (ret)
+				goto error;
+			ref_key->objectid = f_tinfo->id;
+			ref_key->offset = t_tinfo->parent_treeid;
+
+			key.objectid = f_tinfo->id;
+			key.type = BTRFS_ROOT_BACKREF_KEY;
+			key.offset = f_tinfo->parent_treeid;
+			ret = btrfs_search_slot(trans, tree_root, &key, path,
+				-(sizeof(struct btrfs_root_ref) + f_tinfo->name_len), 1);
+			if (ret)
+				goto error;
+			ret = btrfs_del_item(trans, tree_root, path);
+			if (ret)
+				goto error;
+		}
+		btrfs_release_path(tree_root, path);
+	}
+
+	ret = btrfs_search_slot(trans, tree_root, ref_key, path,
+		strlen(new_name) - f_tinfo->name_len, 1);
+	if (ret)
+		goto error;
+
+	oldref = btrfs_item_ptr(path->nodes[0], path->slots[0],
+		struct btrfs_root_ref);
+	name_len = btrfs_root_ref_name_len(path->nodes[0], oldref);
+
+	if (name_len < new_name_len) {
+		ret = btrfs_extend_item(trans, tree_root, path,
+			new_name_len - name_len);
+		if (ret)
+			goto error;
+	} else {
+		ret = btrfs_truncate_item(trans, tree_root, path,
+			sizeof(*oldref) + new_name_len, 1);
+		if (ret)
+			goto error;
+	}
+	oldref = btrfs_item_ptr(path->nodes[0], path->slots[0],
+		struct btrfs_root_ref);
+	write_extent_buffer(path->nodes[0], new_name,
+		(unsigned long)(oldref + 1), new_name_len);
+	btrfs_set_root_ref_name_len(path->nodes[0], oldref, new_name_len);
+	btrfs_set_root_ref_dirid(path->nodes[0], oldref, t_tinfo->parent_dirid);
+	btrfs_set_root_ref_sequence(path->nodes[0], oldref, t_tinfo->index);
+
+	btrfs_free_path(path);
+	return 0;
+
+error:
+	btrfs_free_path(path);
+	return 1;
+}
+
+static int btrfs_find_highest_index(struct btrfs_root *fs_root,
+		u64 i_no, u64 *index)
+{
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	int ret;
+
+	key.objectid = i_no;
+	key.type = BTRFS_DIR_INDEX_KEY;
+	key.offset = (u64)-1;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+	ret = btrfs_search_slot(NULL, fs_root, &key, path, 0, 0);
+	if (ret <0)
+		goto out;
+	BUG_ON(ret == 0);
+	if (path->slots[0] == 0) {
+		*index = 1ULL;
+	} else {
+		path->slots[0]--;
+		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+		if (key.objectid == i_no && key.type == BTRFS_DIR_INDEX_KEY)
+			*index = key.offset;
+		else {
+			*index = 1ULL;
+		}
+	}
+	ret = 0;
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
+static int btrfs_update_parent_dir_size(struct btrfs_trans_handle *trans,
+		struct btrfs_root *fs_root, struct btrfs_path *path, u64 parent_id,
+		int name_len)
+{
+	struct btrfs_key parent_key = {parent_id, BTRFS_INODE_ITEM_KEY, 0ULL};;
+	struct btrfs_inode_item *parent_inode;
+	u64 dir_size;
+	int ret;
+
+	ret = btrfs_search_slot(trans, fs_root, &parent_key, path, 0, 1);
+	BUG_ON(ret);
+
+	parent_inode = btrfs_item_ptr(path->nodes[0], path->slots[0],
+			struct btrfs_inode_item);
+
+	dir_size = btrfs_inode_size(path->nodes[0], parent_inode);
+	btrfs_set_inode_size(path->nodes[0], parent_inode, dir_size+name_len*2);
+	btrfs_mark_buffer_dirty(path->nodes[0]);
+
+	return 0;
+}
+
+static int btrfs_create_dir(struct btrfs_root *root, u64 dirid,
+		char *dir_name, struct revert_packet *rvp)
+{
+	struct btrfs_inode_item inode_item;
+	struct btrfs_dir_item *dir_item;
+	struct btrfs_path *path;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_key location, found_key;
+	int ret;
+	u64 objectid, index = 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	dir_item = btrfs_lookup_dir_item(NULL, root, path, dirid,
+		dir_name, strlen(dir_name), 0);
+
+	if (dir_item) {
+		btrfs_dir_item_key_to_cpu(path->nodes[0], dir_item, &found_key);
+		if (rvp) {
+			rvp->backup.id = root->root_key.objectid;
+			rvp->backup.parent_dirid = found_key.objectid;
+			rvp->backup.parent_treeid = root->root_key.objectid;
+		}
+		btrfs_free_path(path);
+		return 0;
+	}
+
+	btrfs_release_path(root, path);
+
+	ret = btrfs_find_highest_inode(root, &objectid);
+	if (ret)
+		return -1;
+
+	ret = btrfs_find_highest_index(root, BTRFS_FIRST_FREE_OBJECTID, &index);
+	if (ret)
+		return -1;
+
+	trans = btrfs_start_transaction(root, 1);
+	if (!trans)
+		return -ENOMEM;
+
+	objectid++;
+	index++;
+	if (rvp) {
+		rvp->backup.id = root->root_key.objectid;
+		rvp->backup.parent_dirid = objectid;
+		rvp->backup.parent_treeid = root->root_key.objectid;
+	}
+
+	memset(&inode_item, 0, sizeof(inode_item));
+	btrfs_set_stack_inode_generation(&inode_item, trans->transid);
+	btrfs_set_stack_inode_size(&inode_item, 0);
+	btrfs_set_stack_inode_nlink(&inode_item, 1);
+	btrfs_set_stack_inode_nbytes(&inode_item, root->leafsize);
+	btrfs_set_stack_inode_mode(&inode_item, S_IFDIR | 0555);
+	ret = btrfs_insert_inode(trans, root, objectid, &inode_item);
+	if (ret)
+		goto out;
+	ret = btrfs_insert_inode_ref(trans, root, dir_name, strlen(dir_name),
+			objectid, BTRFS_FIRST_FREE_OBJECTID, index);
+	if (ret)
+		goto out;
+
+	location.objectid = objectid;
+	location.offset = 0ULL;
+	location.type = BTRFS_INODE_ITEM_KEY;
+
+	ret = btrfs_insert_dir_item(trans, root, dir_name, strlen(dir_name),
+			BTRFS_FIRST_FREE_OBJECTID, &location, BTRFS_FT_DIR, index);
+	if (ret)
+		goto out;
+	ret = btrfs_update_parent_dir_size(trans, root, path,
+		BTRFS_FIRST_FREE_OBJECTID, strlen(dir_name));
+
+	btrfs_commit_transaction(trans, root);
+out:
+	btrfs_free_path(path);
+	return 0;
+}
+
+static char *generate_uuid_string(char *name)
+{
+	uuid_t uuid;
+	int len = strlen(name);
+	char *ret_name;
+
+	if (len + 37 > BTRFS_VOL_NAME_MAX)
+		len = BTRFS_VOL_NAME_MAX - 37;
+	ret_name = malloc(38+len);
+	if (!ret_name)
+		return NULL;
+	ret_name[37+len]='\0';
+	strncpy(ret_name, name, len);
+	ret_name[len] = '_';
+	uuid_generate_time(uuid);
+	uuid_unparse(uuid, ret_name + len + 1);
+
+	return ret_name;
+}
+
+static int btrfs_create_backup_link(struct btrfs_trans_handle *trans,
+		struct btrfs_root *backup_root, char *name, struct revert_packet *rvp)
+{
+	struct btrfs_dir_item *dir_item;
+	struct btrfs_path *path;
+	struct btrfs_key location, ref_key;
+	struct btrfs_root *tree_root = backup_root->fs_info->tree_root;
+	int ret;
+
+	if (!name)
+		return -1;
+	path = btrfs_alloc_path();
+	if (!path) {
+		return -ENOMEM;
+	}
+
+	dir_item = btrfs_lookup_dir_item(NULL, backup_root, path,
+		rvp->backup.parent_dirid, name, strlen(name), 0);
+	if (dir_item)
+		goto error;
+
+	btrfs_release_path(backup_root, path);
+
+	ret = btrfs_find_highest_index(backup_root, rvp->backup.parent_dirid,
+		&rvp->backup.index);
+	if (ret)
+		goto error;
+
+	rvp->backup.index++;
+
+	location.objectid = rvp->target.id;
+	location.type = BTRFS_ROOT_ITEM_KEY;
+	location.offset = (u64)-1;
+
+	ret = btrfs_insert_dir_item(trans, backup_root, name, strlen(name),
+			rvp->backup.parent_dirid, &location, BTRFS_FT_DIR,
+			rvp->backup.index);
+	if (ret)
+		goto error;
+
+	ret = btrfs_update_parent_dir_size(trans, backup_root, path,
+		rvp->backup.parent_dirid, strlen(name));
+	if (ret)
+		goto error;
+
+	btrfs_free_path(path);
+
+	ref_key.objectid = rvp->target.id;
+	ref_key.type = BTRFS_ROOT_BACKREF_KEY;
+	ref_key.offset = rvp->target.parent_treeid;
+	ret = btrfs_update_root_ref(trans, tree_root, &ref_key, &rvp->target,
+		&rvp->backup, name);
+	if (ret)
+		return -1;
+
+	ref_key.objectid = rvp->target.parent_treeid;
+	ref_key.type = BTRFS_ROOT_REF_KEY;
+	ref_key.offset = rvp->target.id;
+	ret = btrfs_update_root_ref(trans, tree_root, &ref_key, &rvp->target,
+		&rvp->backup, name);
+	if (ret)
+		return -1;
+
+	return 0;
+
+error:
+	btrfs_free_path(path);
+	return -1;
+}
+
+static u64 btrfs_find_current_root(struct btrfs_root *root)
+{
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	struct btrfs_dir_item *dir_item;
+	struct btrfs_root *tree_root = root->fs_info->tree_root;
+	int ret;
+	char *default_name = "default";
+
+	key.objectid = BTRFS_ROOT_TREE_DIR_OBJECTID;
+	key.type = BTRFS_DIR_ITEM_KEY;
+	key.offset = btrfs_name_hash(default_name, strlen(default_name));
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return 0ULL;
+	ret = btrfs_search_slot(NULL, tree_root, &key, path, 0, 0);
+	BUG_ON(ret);
+
+	dir_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
+		struct btrfs_dir_item);
+	BUG_ON(IS_ERR(dir_item));
+
+	btrfs_dir_item_key_to_cpu(path->nodes[0], dir_item, &key);
+
+	btrfs_free_path(path);
+	return key.objectid;
+}
+
+static struct btrfs_root *btrfs_read_fs_root_by_objectid(
+		struct btrfs_fs_info *fs_info, u64 tree_id)
+{
+	struct btrfs_key key;
+
+	key.objectid = tree_id;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = (u64)-1;
+
+	return btrfs_read_fs_root(fs_info, &key);
+}
+
+static void btrfs_update_dir_location(struct btrfs_trans_handle *trans,
+		struct btrfs_path *path, u64 tree_id)
+{
+	struct btrfs_dir_item *di_ref;
+	struct btrfs_key location;
+	struct btrfs_disk_key disk_location;
+
+	di_ref = btrfs_item_ptr(path->nodes[0], path->slots[0],
+		struct btrfs_dir_item);
+	BUG_ON(!di_ref);
+	location.objectid = tree_id;
+	location.type = BTRFS_ROOT_ITEM_KEY;
+	location.offset = (u64)-1;
+
+	btrfs_cpu_key_to_disk(&disk_location, &location);
+	btrfs_set_dir_item_key(path->nodes[0], di_ref, &disk_location);
+
+	btrfs_mark_buffer_dirty(path->nodes[0]);
+}
+
+static int btrfs_switch_dir_item(struct btrfs_trans_handle *trans,
+		struct btrfs_root *root, struct revert_packet *rvp)
+{
+	struct btrfs_root *tree_root, *file_root;
+	struct btrfs_key key;
+	struct btrfs_path *path;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+	file_root = btrfs_read_fs_root_by_objectid(root->fs_info,
+		rvp->target.parent_treeid);
+	if (IS_ERR(file_root))
+		return -EINVAL;
+	tree_root = btrfs_read_fs_root_by_objectid(root->fs_info,
+		BTRFS_ROOT_TREE_OBJECTID);
+	BUG_ON(IS_ERR(tree_root));
+
+	key.objectid = rvp->target.parent_dirid;
+	key.type = BTRFS_DIR_ITEM_KEY;
+	key.offset = btrfs_name_hash(rvp->target.name, rvp->target.name_len);
+
+	ret = btrfs_search_slot(trans, file_root, &key, path, 0, 1);
+	BUG_ON(ret);
+
+	btrfs_update_dir_location(trans, path, rvp->source.id);
+	btrfs_release_path(file_root, path);
+
+	key.objectid = rvp->target.parent_dirid;
+	key.type = BTRFS_DIR_INDEX_KEY;
+	key.offset = rvp->target.index;
+	ret = btrfs_search_slot(trans, file_root, &key, path, 0, 1);
+	BUG_ON(ret);
+
+	btrfs_update_dir_location(trans, path, rvp->source.id);
+	btrfs_free_path(path);
+
+	key.objectid = rvp->source.parent_treeid;
+	key.type = BTRFS_ROOT_REF_KEY;
+	key.offset = rvp->source.id;
+	ret = btrfs_update_root_ref(trans, tree_root, &key, &rvp->source,
+		&rvp->target, rvp->target.name);
+	if (ret)
+		return ret;
+
+	key.objectid = rvp->source.id;
+	key.type = BTRFS_ROOT_BACKREF_KEY;
+	key.offset = rvp->source.parent_treeid;
+	ret = btrfs_update_root_ref(trans, tree_root, &key, &rvp->source,
+		&rvp->target, rvp->target.name);
+
+	return ret;
+}
+
+static int btrfs_del_dir_item(struct btrfs_trans_handle *trans,
+		struct btrfs_root *root, struct tree_info *tinfo)
+{
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	int ret, del_size;
+
+	path = btrfs_alloc_path();
+	key.objectid = tinfo->parent_dirid;
+	key.type = BTRFS_DIR_ITEM_KEY;
+	key.offset = btrfs_name_hash(tinfo->name, tinfo->name_len);
+	del_size = sizeof(struct btrfs_dir_item) + tinfo->name_len;
+
+	ret = btrfs_search_slot(trans, root, &key, path, -del_size, 1);
+	BUG_ON(ret);
+	ret = btrfs_del_item(trans, root, path);
+	if (ret)
+		goto out;
+	btrfs_release_path(root, path);
+
+	key.objectid = tinfo->parent_dirid;
+	key.type = BTRFS_DIR_INDEX_KEY;
+	key.offset = tinfo->index;
+
+	ret = btrfs_search_slot(trans, root, &key, path, -del_size, 1);
+	BUG_ON(ret);
+	ret = btrfs_del_item(trans, root, path);
+	if (ret)
+		goto out;
+	btrfs_release_path(root, path);
+
+	ret = btrfs_update_parent_dir_size(trans, root, path,
+		tinfo->parent_dirid, -tinfo->name_len);
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
+static int btrfs_revert_directory(struct btrfs_fs_info *fs_info,
+		struct revert_packet *rvp)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *backup_root, *target_root, *source_root;
+	int ret;
+	char *store_name;
+
+	store_name = generate_uuid_string(rvp->target.name);
+	printf("\tOld target subvolume is moved to default filesystem root\n");
+	printf("\t  (path = /%s/%s)\n",
+		BTRFS_REVERTED_TREE_LOCATION, store_name);
+
+	ret = btrfs_create_dir(fs_info->fs_root, BTRFS_FIRST_FREE_OBJECTID,
+		BTRFS_REVERTED_TREE_LOCATION, rvp);
+	if(ret)
+		goto out_error;
+
+	backup_root = btrfs_read_fs_root_by_objectid(fs_info, rvp->backup.id);
+	if (!backup_root)
+		goto out_error;
+	trans = btrfs_start_transaction(backup_root, 1);
+	if (!trans)
+		goto out_error;
+	ret = btrfs_create_backup_link(trans, backup_root, store_name, rvp);
+	if (ret)
+		goto out_error;
+	btrfs_commit_transaction(trans, backup_root);
+
+	target_root = btrfs_read_fs_root_by_objectid(fs_info,
+		rvp->target.parent_treeid);
+	if (!target_root)
+		goto out_error;
+	trans = btrfs_start_transaction(target_root, 1);
+	if (!trans)
+		goto out_error;
+	ret = btrfs_switch_dir_item(trans, backup_root, rvp);
+	if (ret)
+		goto out_error;
+	btrfs_commit_transaction(trans, target_root);
+
+	source_root = btrfs_read_fs_root_by_objectid(fs_info,
+		rvp->source.parent_treeid);
+	if (!source_root)
+		goto out_error;
+	trans = btrfs_start_transaction(source_root, 1);
+	if (!trans)
+		goto out_error;
+	ret = btrfs_del_dir_item(trans, source_root, &rvp->source);
+	if (ret)
+		goto out_error;
+	btrfs_commit_transaction(trans, source_root);
+
+	free(store_name);
+	return 0;
+
+out_error:
+	free(store_name);
+	return -1;
+}
+
+static char *device;
+
+int main(int argc, char *argv[])
+{
+	struct btrfs_root *root = NULL;
+	struct revert_packet rv_packet;
+	u64 cur_root;
+	int ret = 1;
+
+	rv_packet.source.id = 0ULL;
+	rv_packet.target.id = 0ULL;
+	rv_packet.source.name = NULL;
+	rv_packet.target.name = NULL;
+	while(1) {
+		int c = getopt(argc, argv, "s:t:");
+		if (c < 0)
+			break;
+		switch(c) {
+		case 's':
+			rv_packet.source.id = atoll(optarg);
+			break;
+		case 't':
+			rv_packet.target.id = atoll(optarg);
+			break;
+		default:
+			print_usage();
+			ret = 1;
+			goto out;
+		}
+	}
+
+	if (rv_packet.source.id == 0ULL) {
+		fprintf(stderr, "source tree is not specified\n");
+		goto error;
+	}
+	if (rv_packet.target.id == 0ULL) {
+		fprintf(stderr, "target tree is not specified\n");
+		goto error;
+	}
+	if (rv_packet.source.id == rv_packet.target.id) {
+		fprintf(stderr, "source tree and target tree are a same tree\n");
+		goto error;
+	}
+
+	argc = argc - optind;
+	device = argv[optind];
+	if (argc != 1) {
+		fprintf(stderr, "device not specified\n");
+		goto error;
+	}
+
+	if (check_mounted(device)) {
+		fprintf(stderr, "%s is mounted\n", device);
+		goto error;
+	}
+
+	root = open_ctree(device, 0, 1);
+	if (!root) {
+		printf("ctree open error.\n");
+		goto error;
+	}
+
+	cur_root = btrfs_find_current_root(root);
+
+	if (find_file_tree(root, &rv_packet.source)) {
+		printf("source tree not exist\n");
+		goto error_out;
+	}
+	if (find_file_tree(root, &rv_packet.target)) {
+		printf("target tree not exist\n");
+		goto error_out;
+	}
+	if (rv_packet.source.id == BTRFS_FS_TREE_OBJECTID)
+		if(rv_packet.target.id != cur_root) {
+			printf("filesystem root(id=%llu) cannot replaces non-root tree(id=%llu)\n",
+				rv_packet.source.id, rv_packet.target.id);
+			goto error_out;
+		}
+
+	printf("tree reverting utilitiy\n");
+	printf("\t subvolume\t: \"%s\"\n", rv_packet.target.name);
+	printf("\t subvolume id\t: [before] %llu -> [after] %llu\n",
+		rv_packet.target.id, rv_packet.source.id);
+
+	if (rv_packet.target.id == cur_root) {
+		ret = btrfs_revert_root(root->fs_info, &rv_packet);
+	} else {
+ 		ret = btrfs_revert_directory(root->fs_info, &rv_packet);
+	}
+
+	printf("operation complete\n");
+close_out:
+	close_ctree(root);
+
+out:
+	if (rv_packet.source.name)
+		free(rv_packet.source.name);
+	if (rv_packet.target.name)
+		free(rv_packet.target.name);
+
+	printf("%s\n",BTRFS_BUILD_VERSION);
+	return ret;
+
+error_out:
+	ret = 1;
+	goto close_out;
+
+error:
+	ret = 1;
+	goto out;
+}

