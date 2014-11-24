Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33070 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752931AbaKXJJQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Nov 2014 04:09:16 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sAO98t7D012236
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Nov 2014 17:08:55 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/6] btrfs-progs: Import btrfs_insert/del/lookup_extref() functions.
Date: Mon, 24 Nov 2014 17:07:01 +0800
Message-ID: <1416820025-10373-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1416820025-10373-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1416820025-10373-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Import btrfs_insert/del/lookup_extref() functions form kernel for the
incoming btrfs_add_link() and btrfs_unlink() functions.

As the base of incoming btrfs 'lost+found' recovery mechanism.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 ctree.h      |  14 ++++
 inode-item.c | 206 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 220 insertions(+)

diff --git a/ctree.h b/ctree.h
index 89036de..e185e7a 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2389,6 +2389,20 @@ int btrfs_insert_inode(struct btrfs_trans_handle *trans, struct btrfs_root
 int btrfs_lookup_inode(struct btrfs_trans_handle *trans, struct btrfs_root
 		       *root, struct btrfs_path *path,
 		       struct btrfs_key *location, int mod);
+struct btrfs_inode_extref
+*btrfs_lookup_inode_extref(struct btrfs_trans_handle *trans,
+			   struct btrfs_path *path, struct btrfs_root *root,
+			   u64 ino, u64 parent_ino, u64 index, const char *name,
+			   int namelen, int ins_len);
+int btrfs_del_inode_extref(struct btrfs_trans_handle *trans,
+			   struct btrfs_root *root,
+			   const char *name, int name_len,
+			   u64 inode_objectid, u64 ref_objectid,
+			   u64 *index);
+int btrfs_insert_inode_extref(struct btrfs_trans_handle *trans,
+			      struct btrfs_root *root,
+			      const char *name, int name_len,
+			      u64 inode_objectid, u64 ref_objectid, u64 index);
 
 /* file-item.c */
 int btrfs_del_csums(struct btrfs_trans_handle *trans,
diff --git a/inode-item.c b/inode-item.c
index 8cc98c6..7337ac9 100644
--- a/inode-item.c
+++ b/inode-item.c
@@ -19,6 +19,7 @@
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
+#include "crc32c.h"
 
 static int find_name_in_backref(struct btrfs_path *path, const char * name,
 			 int name_len, struct btrfs_inode_ref **ref_ret)
@@ -145,3 +146,208 @@ int btrfs_insert_inode(struct btrfs_trans_handle *trans, struct btrfs_root
 				sizeof(*inode_item));
 	return ret;
 }
+
+static inline u64 btrfs_extref_hash(u64 parent_ino, const char *name,
+				    int namelen)
+{
+	return (u64) btrfs_crc32c(parent_ino, name, namelen);
+}
+
+static int
+btrfs_find_name_in_ext_backref(struct btrfs_path *path,
+			       u64 parent_ino, const char *name,
+			       int namelen,
+			       struct btrfs_inode_extref **extref_ret)
+{
+	struct extent_buffer *node;
+	struct btrfs_inode_extref *extref;
+	unsigned long ptr;
+	unsigned long name_ptr;
+	u32 item_size;
+	u32 cur_offset = 0;
+	int ref_name_len;
+	int slot;
+
+	node = path->nodes[0];
+	slot = path->slots[0];
+	item_size = btrfs_item_size_nr(node, slot);
+	ptr = btrfs_item_ptr_offset(node, slot);
+
+	/*
+	 * Search all extended backrefs in this item. We're only
+	 * looking through any collisions so most of the time this is
+	 * just going to compare against one buffer. If all is well,
+	 * we'll return success and the inode ref object.
+	 */
+	while (cur_offset < item_size) {
+		extref = (struct btrfs_inode_extref *) (ptr + cur_offset);
+		name_ptr = (unsigned long)(&extref->name);
+		ref_name_len = btrfs_inode_extref_name_len(node, extref);
+
+		if (ref_name_len == namelen &&
+		    btrfs_inode_extref_parent(node, extref) == parent_ino &&
+		    (memcmp_extent_buffer(node, name, name_ptr,
+					  namelen) == 0)) {
+			if (extref_ret)
+				*extref_ret = extref;
+			return 1;
+		}
+
+		cur_offset += ref_name_len + sizeof(*extref);
+	}
+	return 0;
+}
+
+struct btrfs_inode_extref
+*btrfs_lookup_inode_extref(struct btrfs_trans_handle *trans,
+			   struct btrfs_path *path, struct btrfs_root *root,
+			   u64 ino, u64 parent_ino, u64 index, const char *name,
+			   int namelen, int ins_len)
+{
+	struct btrfs_key key;
+	struct btrfs_inode_extref *extref;
+	int ret = 0;
+
+	key.objectid = ino;
+	key.type = BTRFS_INODE_EXTREF_KEY;
+	key.offset = btrfs_extref_hash(parent_ino, name, namelen);
+
+	ret = btrfs_search_slot(trans, root, &key, path, ins_len,
+				ins_len ? 1 : 0);
+	if (ret < 0)
+		return ERR_PTR(ret);
+	if (ret > 0)
+		return NULL;
+	if (!btrfs_find_name_in_ext_backref(path, parent_ino, name,
+					    namelen, &extref))
+		return NULL;
+	return extref;
+}
+
+int btrfs_del_inode_extref(struct btrfs_trans_handle *trans,
+			   struct btrfs_root *root,
+			   const char *name, int name_len,
+			   u64 inode_objectid, u64 ref_objectid,
+			   u64 *index)
+{
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	struct btrfs_inode_extref *extref;
+	struct extent_buffer *leaf;
+	int ret;
+	int del_len = name_len + sizeof(*extref);
+	unsigned long ptr;
+	unsigned long item_start;
+	u32 item_size;
+
+	key.objectid = inode_objectid;
+	key.type = BTRFS_INODE_EXTREF_KEY;
+	key.offset = btrfs_extref_hash(ref_objectid, name, name_len);
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+	if (ret > 0)
+		ret = -ENOENT;
+	if (ret < 0)
+		goto out;
+
+	/*
+	 * Sanity check - did we find the right item for this name?
+	 * This should always succeed so error here will make the FS
+	 * readonly.
+	 */
+	if (!btrfs_find_name_in_ext_backref(path, ref_objectid,
+					    name, name_len, &extref)) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	leaf = path->nodes[0];
+	item_size = btrfs_item_size_nr(leaf, path->slots[0]);
+	if (index)
+		*index = btrfs_inode_extref_index(leaf, extref);
+
+	if (del_len == item_size) {
+		/*
+		 * Common case only one ref in the item, remove the
+		 * whole item.
+		 */
+		ret = btrfs_del_item(trans, root, path);
+		goto out;
+	}
+
+	ptr = (unsigned long)extref;
+	item_start = btrfs_item_ptr_offset(leaf, path->slots[0]);
+
+	memmove_extent_buffer(leaf, ptr, ptr + del_len,
+			      item_size - (ptr + del_len - item_start));
+
+	btrfs_truncate_item(trans, root, path, item_size - del_len, 1);
+
+out:
+	btrfs_free_path(path);
+
+	return ret;
+}
+
+/*
+ * btrfs_insert_inode_extref() - Inserts an extended inode ref into a tree.
+ *
+ * The caller must have checked against BTRFS_LINK_MAX already.
+ */
+int btrfs_insert_inode_extref(struct btrfs_trans_handle *trans,
+			      struct btrfs_root *root,
+			      const char *name, int name_len,
+			      u64 inode_objectid, u64 ref_objectid, u64 index)
+{
+	struct btrfs_inode_extref *extref;
+	int ret;
+	int ins_len = name_len + sizeof(*extref);
+	unsigned long ptr;
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	struct extent_buffer *leaf;
+	struct btrfs_item *item;
+
+	key.objectid = inode_objectid;
+	key.type = BTRFS_INODE_EXTREF_KEY;
+	key.offset = btrfs_extref_hash(ref_objectid, name, name_len);
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	ret = btrfs_insert_empty_item(trans, root, path, &key,
+				      ins_len);
+	if (ret == -EEXIST) {
+		if (btrfs_find_name_in_ext_backref(path, ref_objectid,
+						   name, name_len, NULL))
+			goto out;
+
+		btrfs_extend_item(trans, root, path, ins_len);
+		ret = 0;
+	}
+	if (ret < 0)
+		goto out;
+
+	leaf = path->nodes[0];
+	item = btrfs_item_nr(path->slots[0]);
+	ptr = (unsigned long)btrfs_item_ptr(leaf, path->slots[0], char);
+	ptr += btrfs_item_size(leaf, item) - ins_len;
+	extref = (struct btrfs_inode_extref *)ptr;
+
+	btrfs_set_inode_extref_name_len(path->nodes[0], extref, name_len);
+	btrfs_set_inode_extref_index(path->nodes[0], extref, index);
+	btrfs_set_inode_extref_parent(path->nodes[0], extref, ref_objectid);
+
+	ptr = (unsigned long)&extref->name;
+	write_extent_buffer(path->nodes[0], name, ptr, name_len);
+	btrfs_mark_buffer_dirty(path->nodes[0]);
+
+out:
+	btrfs_free_path(path);
+	return ret;
+}
-- 
2.1.3

