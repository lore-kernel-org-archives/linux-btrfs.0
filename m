Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49685 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752875AbaKXJJR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Nov 2014 04:09:17 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sAO98uBh012240
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Nov 2014 17:08:56 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/6] btrfs-progs: Import lookup/del_inode_ref() function.
Date: Mon, 24 Nov 2014 17:07:02 +0800
Message-ID: <1416820025-10373-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1416820025-10373-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1416820025-10373-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Import lookup/del_inode_ref() function in inode-item.c, as base functions
for the incoming btrfs_add_link() and btrfs_unlink() functions.

Also modify btrfs_insert_inode_ref() and split_leaf() making them able
to deal with EXTENT_IREF incompat flag.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 ctree.c      |   6 ++++
 ctree.h      |  10 ++++++
 inode-item.c | 112 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 128 insertions(+)

diff --git a/ctree.c b/ctree.c
index 23399e2..bd6cb12 100644
--- a/ctree.c
+++ b/ctree.c
@@ -2015,6 +2015,12 @@ static noinline int split_leaf(struct btrfs_trans_handle *trans,
 	int split;
 	int num_doubles = 0;
 
+	l = path->nodes[0];
+	slot = path->slots[0];
+	if (extend && data_size + btrfs_item_size_nr(l, slot) +
+	    sizeof(struct btrfs_item) > BTRFS_LEAF_DATA_SIZE(root))
+		return -EOVERFLOW;
+
 	/* first try to make some room by pushing left and right */
 	if (data_size && ins_key->type != BTRFS_DIR_ITEM_KEY) {
 		wret = push_leaf_right(trans, root, path, data_size, 0);
diff --git a/ctree.h b/ctree.h
index e185e7a..32b1286 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2403,6 +2403,16 @@ int btrfs_insert_inode_extref(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root,
 			      const char *name, int name_len,
 			      u64 inode_objectid, u64 ref_objectid, u64 index);
+struct btrfs_inode_ref
+*btrfs_lookup_inode_ref(struct btrfs_trans_handle *trans,
+			struct btrfs_root *root,
+			struct btrfs_path *path,
+			const char *name, int namelen,
+			u64 ino, u64 parent_ino, u64 index, int ins_len);
+int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
+			struct btrfs_root *root,
+			const char *name, int name_len,
+			u64 ino, u64 parent_ino, u64 *index);
 
 /* file-item.c */
 int btrfs_del_csums(struct btrfs_trans_handle *trans,
diff --git a/inode-item.c b/inode-item.c
index 7337ac9..5a9b675 100644
--- a/inode-item.c
+++ b/inode-item.c
@@ -89,6 +89,8 @@ int btrfs_insert_inode_ref(struct btrfs_trans_handle *trans,
 		ptr = (unsigned long)(ref + 1);
 		ret = 0;
 	} else if (ret < 0) {
+		if (ret == EOVERFLOW)
+			ret = -EMLINK;
 		goto out;
 	} else {
 		ref = btrfs_item_ptr(path->nodes[0], path->slots[0],
@@ -102,6 +104,15 @@ int btrfs_insert_inode_ref(struct btrfs_trans_handle *trans,
 
 out:
 	btrfs_free_path(path);
+
+	if (ret == -EMLINK) {
+		if (btrfs_fs_incompat(root->fs_info,
+				      BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF))
+			ret = btrfs_insert_inode_extref(trans, root, name,
+							name_len,
+							inode_objectid,
+							ref_objectid, index);
+	}
 	return ret;
 }
 
@@ -147,6 +158,34 @@ int btrfs_insert_inode(struct btrfs_trans_handle *trans, struct btrfs_root
 	return ret;
 }
 
+struct btrfs_inode_ref
+*btrfs_lookup_inode_ref(struct btrfs_trans_handle *trans,
+			struct btrfs_root *root,
+			struct btrfs_path *path,
+			const char *name, int namelen,
+			u64 ino, u64 parent_ino, u64 index, int ins_len)
+{
+	struct btrfs_key key;
+	struct btrfs_inode_ref *ret_inode_ref = NULL;
+	int ret = 0;
+
+	key.objectid = ino;
+	key.type = BTRFS_INODE_REF_KEY;
+	key.offset = parent_ino;
+
+	ret = btrfs_search_slot(trans, root, &key, path, ins_len,
+				ins_len ? 1 : 0);
+	if (ret)
+		goto out;
+
+	find_name_in_backref(path, name, namelen, &ret_inode_ref);
+out:
+	if (ret < 0)
+		return ERR_PTR(ret);
+	else
+		return ret_inode_ref;
+}
+
 static inline u64 btrfs_extref_hash(u64 parent_ino, const char *name,
 				    int namelen)
 {
@@ -351,3 +390,76 @@ out:
 	btrfs_free_path(path);
 	return ret;
 }
+
+int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
+			struct btrfs_root *root,
+			const char *name, int name_len,
+			u64 ino, u64 parent_ino, u64 *index)
+{
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	struct btrfs_inode_ref *ref;
+	struct extent_buffer *leaf;
+	unsigned long ptr;
+	unsigned long item_start;
+	u32 item_size;
+	u32 sub_item_len;
+	int ret;
+	int search_ext_refs = 0;
+	int del_len = name_len + sizeof(*ref);
+
+	key.objectid = ino;
+	key.offset = parent_ino;
+	key.type = BTRFS_INODE_REF_KEY;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+	if (ret > 0) {
+		ret = -ENOENT;
+		search_ext_refs = 1;
+		goto out;
+	} else if (ret < 0) {
+		goto out;
+	}
+	if (!find_name_in_backref(path, name, name_len, &ref)) {
+		ret = -ENOENT;
+		search_ext_refs = 1;
+		goto out;
+	}
+	leaf = path->nodes[0];
+	item_size = btrfs_item_size_nr(leaf, path->slots[0]);
+
+	if (index)
+		*index = btrfs_inode_ref_index(leaf, ref);
+
+	if (del_len == item_size) {
+		ret = btrfs_del_item(trans, root, path);
+		goto out;
+	}
+	ptr = (unsigned long)ref;
+	sub_item_len = name_len + sizeof(*ref);
+	item_start = btrfs_item_ptr_offset(leaf, path->slots[0]);
+	memmove_extent_buffer(leaf, ptr, ptr + sub_item_len,
+			      item_size - (ptr + sub_item_len - item_start));
+	btrfs_truncate_item(trans, root, path, item_size - sub_item_len, 1);
+	btrfs_mark_buffer_dirty(path->nodes[0]);
+out:
+	btrfs_free_path(path);
+
+	if (search_ext_refs &&
+	    btrfs_fs_incompat(root->fs_info,
+		    BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF)) {
+		/*
+		 * No refs were found, or we could not find the
+		 * name in our ref array. Find and remove the extended
+		 * inode ref then.
+		 */
+		return btrfs_del_inode_extref(trans, root, name, name_len,
+					      ino, parent_ino, index);
+	}
+
+	return ret;
+}
-- 
2.1.3

