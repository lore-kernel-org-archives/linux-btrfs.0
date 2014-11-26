Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42028 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751414AbaKZAvD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 19:51:03 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sAQ0oibZ005313
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Nov 2014 08:50:44 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/6] btrfs-progs: Add btrfs_unlink() and btrfs_add_link() functions.
Date: Wed, 26 Nov 2014 08:48:59 +0800
Message-ID: <1416962940-25352-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add btrfs_unlink() and btrfs_add_link() functions in inode.c,
for the incoming btrfs_mkdir() and later inode operations functions.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
Changlog:
v2:
   Do dir name conflicting check before adding inode_backref or
   dir_item/index.
---
 Makefile     |   2 +-
 cmds-check.c |   7 +-
 ctree.h      |  12 ++
 inode.c      | 376 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 390 insertions(+), 7 deletions(-)
 create mode 100644 inode.c

diff --git a/Makefile b/Makefile
index 4cae30c..d7a5cbe 100644
--- a/Makefile
+++ b/Makefile
@@ -10,7 +10,7 @@ objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o inode-map.o \
 	  extent-cache.o extent_io.o volumes.o utils.o repair.o \
 	  qgroup.o raid6.o free-space-cache.o list_sort.o props.o \
-	  ulist.o qgroup-verify.o backref.o
+	  ulist.o qgroup-verify.o backref.o inode.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
diff --git a/cmds-check.c b/cmds-check.c
index 9fc1410..6419caf 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1599,14 +1599,9 @@ static int repair_inode_orphan_item(struct btrfs_trans_handle *trans,
 				    struct btrfs_path *path,
 				    struct inode_record *rec)
 {
-	struct btrfs_key key;
 	int ret;
 
-	key.objectid = BTRFS_ORPHAN_OBJECTID;
-	key.type = BTRFS_ORPHAN_ITEM_KEY;
-	key.offset = rec->ino;
-
-	ret = btrfs_insert_empty_item(trans, root, path, &key, 0);
+	ret = btrfs_add_orphan_item(trans, root, path, rec->ino);
 	btrfs_release_path(path);
 	if (!ret)
 		rec->errors &= ~I_ERR_NO_ORPHAN_ITEM;
diff --git a/ctree.h b/ctree.h
index 32b1286..17b3b20 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2444,4 +2444,16 @@ static inline int is_fstree(u64 rootid)
 		return 1;
 	return 0;
 }
+
+/* inode.c */
+int btrfs_add_link(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		   u64 ino, u64 parent_ino, char *name, int namelen,
+		   u8 type, u64 *index, int add_backref);
+int btrfs_unlink(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		 u64 ino, u64 parent_ino, u64 index, const char *name,
+		 int namelen, int add_orphan);
+int btrfs_add_orphan_item(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *root,
+			  struct btrfs_path *path,
+			  u64 ino);
 #endif
diff --git a/inode.c b/inode.c
new file mode 100644
index 0000000..f085d30
--- /dev/null
+++ b/inode.c
@@ -0,0 +1,376 @@
+/*
+ * Copyright (C) 2014 Fujitsu.  All rights reserved.
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
+/*
+ * Unlike inode.c in kernel, which can use most of the kernel infrastructure
+ * like inode/dentry things, in user-land, we can only use inode number to
+ * do directly operation on extent buffer, which may cause extra searching,
+ * but should not be a huge problem since progs is less performence sensitive.
+ */
+#include <sys/stat.h>
+#include "ctree.h"
+#include "transaction.h"
+#include "disk-io.h"
+#include "time.h"
+
+/*
+ * Find a free inode index for later btrfs_add_link().
+ * Currently just search from the largest dir_index and +1.
+ */
+static int btrfs_find_free_dir_index(struct btrfs_root *root, u64 dir_ino,
+				     u64 *ret_ino)
+{
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	struct btrfs_key found_key;
+	u64 ret_val = 2;
+	int ret = 0;
+
+	if (!ret_ino)
+		return 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	key.objectid = dir_ino;
+	key.type = BTRFS_DIR_INDEX_KEY;
+	key.offset = (u64)-1;
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+	ret = 0;
+	if (path->slots[0] == 0) {
+		ret = btrfs_prev_leaf(root, path);
+		if (ret < 0)
+			goto out;
+		if (ret > 0) {
+			/*
+			 * This shouldn't happen since there must be a leaf
+			 * containing the DIR_ITEM.
+			 * Can only happen when the previous leaf is corrupted.
+			 */
+			ret = -EIO;
+			goto out;
+		}
+	} else {
+		path->slots[0]--;
+	}
+	btrfs_item_key_to_cpu(path->nodes[0], &found_key, path->slots[0]);
+	if (found_key.objectid != dir_ino ||
+	    found_key.type != BTRFS_DIR_INDEX_KEY)
+		goto out;
+	ret_val = found_key.offset + 1;
+out:
+	btrfs_free_path(path);
+	if (ret == 0)
+		*ret_ino = ret_val;
+	return ret;
+}
+
+/*
+ * Add dir_item/index for 'parent_ino'
+ * if add_backref is true, also insert a backref from the ino to parent dir
+ * and update the nlink(Kernel version does not do this thing)
+ *
+ * Currently only supports adding link from an inode to another inode.
+ */
+int btrfs_add_link(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		   u64 ino, u64 parent_ino, char *name, int namelen,
+		   u8 type, u64 *index, int add_backref)
+{
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	struct btrfs_inode_item *inode_item;
+	struct btrfs_dir_item *dir_item;
+	u32 nlink;
+	u64 inode_size;
+	u64 ret_index = 0;
+	int ret = 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	/*
+	 * Check name conflict, index won't conflict.
+	 */
+	dir_item = btrfs_lookup_dir_item(NULL, root, path, parent_ino,
+					 name, namelen, 0);
+	if (IS_ERR(dir_item)) {
+		ret = PTR_ERR(dir_item);
+		goto out;
+	}
+	if (dir_item) {
+		ret = -EEXIST;
+		goto out;
+	}
+	btrfs_release_path(path);
+
+	ret = btrfs_find_free_dir_index(root, parent_ino, &ret_index);
+	if (ret < 0)
+		goto out;
+
+	/* Add inode ref */
+	if (add_backref) {
+		ret = btrfs_insert_inode_ref(trans, root, name, namelen,
+					     ino, parent_ino, ret_index);
+		if (ret < 0)
+			goto out;
+
+		/* Update nlinks for the inode */
+		key.objectid = ino;
+		key.type = BTRFS_INODE_ITEM_KEY;
+		key.offset = 0;
+		ret = btrfs_search_slot(trans, root, &key, path, 1, 1);
+		if (ret) {
+			if (ret > 0)
+				ret = -ENOENT;
+			goto out;
+		}
+		inode_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
+				    struct btrfs_inode_item);
+		nlink = btrfs_inode_nlink(path->nodes[0], inode_item);
+		nlink++;
+		btrfs_set_inode_nlink(path->nodes[0], inode_item, nlink);
+		btrfs_mark_buffer_dirty(path->nodes[0]);
+		btrfs_release_path(path);
+	}
+
+	/* Add dir_item and dir_index */
+	key.objectid = ino;
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.offset = 0;
+	ret = btrfs_insert_dir_item(trans, root, name, namelen, parent_ino,
+				    &key, type, ret_index);
+	if (ret < 0)
+		goto out;
+
+	/* Update inode size of the parent inode */
+	key.objectid = parent_ino;
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.offset = 0;
+	ret = btrfs_search_slot(trans, root, &key, path, 1, 1);
+	if (ret)
+		goto out;
+	inode_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
+				    struct btrfs_inode_item);
+	inode_size = btrfs_inode_size(path->nodes[0], inode_item);
+	inode_size += namelen * 2;
+	btrfs_set_inode_size(path->nodes[0], inode_item, inode_size);
+	btrfs_mark_buffer_dirty(path->nodes[0]);
+	btrfs_release_path(path);
+
+out:
+	btrfs_free_path(path);
+	if (ret == 0 && index)
+		*index = ret_index;
+	return ret;
+}
+
+int btrfs_add_orphan_item(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *root,
+			  struct btrfs_path *path,
+			  u64 ino)
+{
+	struct btrfs_key key;
+	int ret = 0;
+
+	key.objectid = BTRFS_ORPHAN_OBJECTID;
+	key.type = BTRFS_ORPHAN_ITEM_KEY;
+	key.offset = ino;
+
+	ret = btrfs_insert_empty_item(trans, root, path, &key, 0);
+	return ret;
+}
+
+/*
+ * Unlink an inode, which will remove its backref and corresponding dir_index/
+ * dir_item if any of them exists.
+ *
+ * If an inode's nlink is reduced to 0 and 'add_orphan' is true, it will be
+ * added to orphan inode and wairing to be deleted by next kernel mount.
+ */
+int btrfs_unlink(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		 u64 ino, u64 parent_ino, u64 index, const char *name,
+		 int namelen, int add_orphan)
+{
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	struct btrfs_inode_item *inode_item;
+	struct btrfs_inode_ref *inode_ref;
+	struct btrfs_dir_item *dir_item;
+	u64 inode_size;
+	u32 nlinks;
+	int del_inode_ref = 0;
+	int del_dir_item = 0;
+	int del_dir_index = 0;
+	int ret = 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	/* check the ref and backref exists */
+	inode_ref = btrfs_lookup_inode_ref(trans, root, path, name, namelen,
+					   ino, parent_ino, index, 0);
+	if (IS_ERR(inode_ref)) {
+		ret = PTR_ERR(inode_ref);
+		goto out;
+	}
+	if (inode_ref)
+		del_inode_ref = 1;
+	btrfs_release_path(path);
+
+	dir_item = btrfs_lookup_dir_item(NULL, root, path, parent_ino,
+					 name, namelen, 0);
+	if (IS_ERR(dir_item)) {
+		ret = PTR_ERR(dir_item);
+		goto out;
+	}
+	if (dir_item)
+		del_dir_item = 1;
+	btrfs_release_path(path);
+
+	dir_item = btrfs_lookup_dir_index(NULL, root, path, parent_ino,
+					  name, namelen, index, 0);
+	/*
+	 * Since lookup_dir_index() will return -ENOENT when not found,
+	 * we need to do extra check.
+	 */
+	if (IS_ERR(dir_item) && PTR_ERR(dir_item) == -ENOENT)
+		dir_item = NULL;
+	if (IS_ERR(dir_item)) {
+		ret = PTR_ERR(dir_item);
+		goto out;
+	}
+	if (dir_item)
+		del_dir_index = 1;
+	btrfs_release_path(path);
+
+	if (!del_inode_ref && !del_dir_item && !del_dir_index) {
+		/* All not found, shouldn't happen */
+		ret = -ENOENT;
+		goto out;
+	}
+
+	if (del_inode_ref) {
+		/* Only decrease nlink when deleting inode_ref */
+		key.objectid = ino;
+		key.type = BTRFS_INODE_ITEM_KEY;
+		key.offset = 0;
+		ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+		if (ret) {
+			if (ret > 0)
+				ret = -ENOENT;
+			goto out;
+		}
+		inode_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
+					    struct btrfs_inode_item);
+		nlinks = btrfs_inode_nlink(path->nodes[0], inode_item);
+		if (nlinks > 0)
+			nlinks--;
+		btrfs_set_inode_nlink(path->nodes[0], inode_item, nlinks);
+		btrfs_mark_buffer_dirty(path->nodes[0]);
+		btrfs_release_path(path);
+
+		/* For nlinks == 0, add it to orphan list if needed */
+		if (nlinks == 0 && add_orphan) {
+			ret = btrfs_add_orphan_item(trans, root, path, ino);
+			btrfs_mark_buffer_dirty(path->nodes[0]);
+			btrfs_release_path(path);
+		}
+
+		ret = btrfs_del_inode_ref(trans, root, name, namelen, ino,
+					  parent_ino, &index);
+		if (ret < 0)
+			goto out;
+	}
+
+	if (del_dir_index) {
+		dir_item = btrfs_lookup_dir_index(trans, root, path,
+						  parent_ino, name, namelen,
+						  index, -1);
+		if (IS_ERR(dir_item)) {
+			ret = PTR_ERR(dir_item);
+			goto out;
+		}
+		if (!dir_item) {
+			ret = -ENOENT;
+			goto out;
+		}
+		ret = btrfs_delete_one_dir_name(trans, root, path, dir_item);
+		if (ret)
+			goto out;
+		btrfs_release_path(path);
+
+		/* Update inode size of the parent inode */
+		key.objectid = parent_ino;
+		key.type = BTRFS_INODE_ITEM_KEY;
+		key.offset = 0;
+		ret = btrfs_search_slot(trans, root, &key, path, 1, 1);
+		if (ret)
+			goto out;
+		inode_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
+					    struct btrfs_inode_item);
+		inode_size = btrfs_inode_size(path->nodes[0], inode_item);
+		if (inode_size >= namelen)
+			inode_size -= namelen;
+		btrfs_set_inode_size(path->nodes[0], inode_item, inode_size);
+		btrfs_mark_buffer_dirty(path->nodes[0]);
+		btrfs_release_path(path);
+	}
+
+	if (del_dir_item) {
+		dir_item = btrfs_lookup_dir_item(trans, root, path, parent_ino,
+						 name, namelen, -1);
+		if (IS_ERR(dir_item)) {
+			ret = PTR_ERR(dir_item);
+			goto out;
+		}
+		if (!dir_item) {
+			ret = -ENOENT;
+			goto out;
+		}
+		ret = btrfs_delete_one_dir_name(trans, root, path, dir_item);
+		if (ret < 0)
+			goto out;
+		btrfs_release_path(path);
+
+		/* Update inode size of the parent inode */
+		key.objectid = parent_ino;
+		key.type = BTRFS_INODE_ITEM_KEY;
+		key.offset = 0;
+		ret = btrfs_search_slot(trans, root, &key, path, 1, 1);
+		if (ret)
+			goto out;
+		inode_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
+					    struct btrfs_inode_item);
+		inode_size = btrfs_inode_size(path->nodes[0], inode_item);
+		if (inode_size >= namelen)
+			inode_size -= namelen;
+		btrfs_set_inode_size(path->nodes[0], inode_item, inode_size);
+		btrfs_mark_buffer_dirty(path->nodes[0]);
+		btrfs_release_path(path);
+	}
+
+out:
+	btrfs_free_path(path);
+	return ret;
+}
-- 
2.1.3

