Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34712 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656Ab2HTUe6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Aug 2012 16:34:58 -0400
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>,
        Jan Schmidt <list.btrfs@jan-o-sch.net>, Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH v4 1/4] btrfs: extended inode refs
Date: Mon, 20 Aug 2012 13:29:18 -0700
Message-Id: <1345494561-28758-2-git-send-email-mfasheh@suse.de>
In-Reply-To: <1345494561-28758-1-git-send-email-mfasheh@suse.de>
References: <1345494561-28758-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds basic support for extended inode refs. This includes support
for link and unlink of the refs, which basically gets us support for rename
as well.

Inode creation does not need changing - extended refs are only added after
the ref array is full.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/ctree.h      |   52 ++++++++--
 fs/btrfs/hash.h       |   10 ++
 fs/btrfs/inode-item.c |  282 +++++++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/inode.c      |   23 +++--
 4 files changed, 340 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index fa5c45b..9fa4ebe 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -151,6 +151,13 @@ struct btrfs_ordered_sum;
  */
 #define BTRFS_NAME_LEN 255
 
+/*
+ * Theoretical limit is larger, but we keep this down to a sane
+ * value. That should limit greatly the possibility of collisions on
+ * inode ref items.
+ */
+#define BTRFS_LINK_MAX 65535U
+
 /* 32 bytes in various csum fields */
 #define BTRFS_CSUM_SIZE 32
 
@@ -486,6 +493,8 @@ struct btrfs_super_block {
  */
 #define BTRFS_FEATURE_INCOMPAT_BIG_METADATA	(1ULL << 5)
 
+#define BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF	(1ULL << 6)
+
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
 #define BTRFS_FEATURE_COMPAT_RO_SUPP		0ULL
 #define BTRFS_FEATURE_INCOMPAT_SUPP			\
@@ -493,7 +502,8 @@ struct btrfs_super_block {
 	 BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL |	\
 	 BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS |		\
 	 BTRFS_FEATURE_INCOMPAT_BIG_METADATA |		\
-	 BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO)
+	 BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO |		\
+	 BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF)
 
 /*
  * A leaf is full of items. offset and size tell us where to find
@@ -640,6 +650,14 @@ struct btrfs_inode_ref {
 	/* name goes here */
 } __attribute__ ((__packed__));
 
+struct btrfs_inode_extref {
+	__le64 parent_objectid;
+	__le64 index;
+	__le16 name_len;
+	__u8   name[0];
+	/* name goes here */
+} __attribute__ ((__packed__));
+
 struct btrfs_timespec {
 	__le64 sec;
 	__le32 nsec;
@@ -1457,6 +1475,7 @@ struct btrfs_ioctl_defrag_range_args {
  */
 #define BTRFS_INODE_ITEM_KEY		1
 #define BTRFS_INODE_REF_KEY		12
+#define BTRFS_INODE_EXTREF_KEY		13
 #define BTRFS_XATTR_ITEM_KEY		24
 #define BTRFS_ORPHAN_ITEM_KEY		48
 /* reserve 2-15 close to the inode for later flexibility */
@@ -1778,6 +1797,13 @@ BTRFS_SETGET_STACK_FUNCS(block_group_flags,
 BTRFS_SETGET_FUNCS(inode_ref_name_len, struct btrfs_inode_ref, name_len, 16);
 BTRFS_SETGET_FUNCS(inode_ref_index, struct btrfs_inode_ref, index, 64);
 
+/* struct btrfs_inode_extref */
+BTRFS_SETGET_FUNCS(inode_extref_parent, struct btrfs_inode_extref,
+		   parent_objectid, 64);
+BTRFS_SETGET_FUNCS(inode_extref_name_len, struct btrfs_inode_extref,
+		   name_len, 16);
+BTRFS_SETGET_FUNCS(inode_extref_index, struct btrfs_inode_extref, index, 64);
+
 /* struct btrfs_inode_item */
 BTRFS_SETGET_FUNCS(inode_generation, struct btrfs_inode_item, generation, 64);
 BTRFS_SETGET_FUNCS(inode_sequence, struct btrfs_inode_item, sequence, 64);
@@ -2884,12 +2910,12 @@ int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   const char *name, int name_len,
 			   u64 inode_objectid, u64 ref_objectid, u64 *index);
-struct btrfs_inode_ref *
-btrfs_lookup_inode_ref(struct btrfs_trans_handle *trans,
-			struct btrfs_root *root,
-			struct btrfs_path *path,
-			const char *name, int name_len,
-			u64 inode_objectid, u64 ref_objectid, int mod);
+int btrfs_get_inode_ref_index(struct btrfs_trans_handle *trans,
+			      struct btrfs_root *root,
+			      struct btrfs_path *path,
+			      const char *name, int name_len,
+			      u64 inode_objectid, u64 ref_objectid, int mod,
+			      u64 *ret_index);
 int btrfs_insert_empty_inode(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
 			     struct btrfs_path *path, u64 objectid);
@@ -2897,6 +2923,18 @@ int btrfs_lookup_inode(struct btrfs_trans_handle *trans, struct btrfs_root
 		       *root, struct btrfs_path *path,
 		       struct btrfs_key *location, int mod);
 
+struct btrfs_inode_extref *
+btrfs_lookup_inode_extref(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *root,
+			  struct btrfs_path *path,
+			  const char *name, int name_len,
+			  u64 inode_objectid, u64 ref_objectid, int ins_len,
+			  int cow);
+
+int btrfs_find_name_in_ext_backref(struct btrfs_path *path, const char *name,
+				   int name_len,
+				   struct btrfs_inode_extref **extref_ret);
+
 /* file-item.c */
 int btrfs_del_csums(struct btrfs_trans_handle *trans,
 		    struct btrfs_root *root, u64 bytenr, u64 len);
diff --git a/fs/btrfs/hash.h b/fs/btrfs/hash.h
index db2ff97..1d98281 100644
--- a/fs/btrfs/hash.h
+++ b/fs/btrfs/hash.h
@@ -24,4 +24,14 @@ static inline u64 btrfs_name_hash(const char *name, int len)
 {
 	return crc32c((u32)~1, name, len);
 }
+
+/*
+ * Figure the key offset of an extended inode ref
+ */
+static inline u64 btrfs_extref_hash(u64 parent_objectid, const char *name,
+				    int len)
+{
+	return (u64) crc32c(parent_objectid, name, len);
+}
+
 #endif
diff --git a/fs/btrfs/inode-item.c b/fs/btrfs/inode-item.c
index a13cf1a..ad11b30 100644
--- a/fs/btrfs/inode-item.c
+++ b/fs/btrfs/inode-item.c
@@ -18,6 +18,7 @@
 
 #include "ctree.h"
 #include "disk-io.h"
+#include "hash.h"
 #include "transaction.h"
 #include "print-tree.h"
 
@@ -50,18 +51,56 @@ static int find_name_in_backref(struct btrfs_path *path, const char *name,
 	return 0;
 }
 
-struct btrfs_inode_ref *
+int btrfs_find_name_in_ext_backref(struct btrfs_path *path, const char *name,
+				   int name_len,
+				   struct btrfs_inode_extref **extref_ret)
+{
+	struct extent_buffer *leaf;
+	struct btrfs_inode_extref *extref;
+	unsigned long ptr;
+	unsigned long name_ptr;
+	u32 item_size;
+	u32 cur_offset = 0;
+	int ref_name_len;
+
+	leaf = path->nodes[0];
+	item_size = btrfs_item_size_nr(leaf, path->slots[0]);
+	ptr = btrfs_item_ptr_offset(leaf, path->slots[0]);
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
+		ref_name_len = btrfs_inode_extref_name_len(leaf, extref);
+
+		if (ref_name_len == name_len
+		    && (memcmp_extent_buffer(leaf, name, name_ptr, name_len) == 0)) {
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
+static struct btrfs_inode_ref *
 btrfs_lookup_inode_ref(struct btrfs_trans_handle *trans,
-			struct btrfs_root *root,
-			struct btrfs_path *path,
-			const char *name, int name_len,
-			u64 inode_objectid, u64 ref_objectid, int mod)
+		       struct btrfs_root *root,
+		       struct btrfs_path *path,
+		       const char *name, int name_len,
+		       u64 inode_objectid, u64 ref_objectid, int ins_len,
+		       int cow)
 {
+	int ret;
 	struct btrfs_key key;
 	struct btrfs_inode_ref *ref;
-	int ins_len = mod < 0 ? -1 : 0;
-	int cow = mod != 0;
-	int ret;
 
 	key.objectid = inode_objectid;
 	key.type = BTRFS_INODE_REF_KEY;
@@ -77,13 +116,149 @@ btrfs_lookup_inode_ref(struct btrfs_trans_handle *trans,
 	return ref;
 }
 
-int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
+/* Returns NULL if no extref found */
+struct btrfs_inode_extref *
+btrfs_lookup_inode_extref(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *root,
+			  struct btrfs_path *path,
+			  const char *name, int name_len,
+			  u64 inode_objectid, u64 ref_objectid, int ins_len,
+			  int cow)
+{
+	int ret;
+	struct btrfs_key key;
+	struct btrfs_inode_extref *extref;
+
+	key.objectid = inode_objectid;
+	key.type = BTRFS_INODE_EXTREF_KEY;
+	key.offset = btrfs_extref_hash(ref_objectid, name, name_len);
+
+	ret = btrfs_search_slot(trans, root, &key, path, ins_len, cow);
+	if (ret < 0)
+		return ERR_PTR(ret);
+	if (ret > 0)
+		return NULL;
+	if (!btrfs_find_name_in_ext_backref(path, name, name_len, &extref))
+		return NULL;
+	return extref;
+}
+
+int btrfs_get_inode_ref_index(struct btrfs_trans_handle *trans,
+			      struct btrfs_root *root,
+			      struct btrfs_path *path,
+			      const char *name, int name_len,
+			      u64 inode_objectid, u64 ref_objectid, int mod,
+			      u64 *ret_index)
+{
+	struct btrfs_inode_ref *ref;
+	struct btrfs_inode_extref *extref;
+	int ins_len = mod < 0 ? -1 : 0;
+	int cow = mod != 0;
+
+	ref = btrfs_lookup_inode_ref(trans, root, path, name, name_len,
+				     inode_objectid, ref_objectid, ins_len,
+				     cow);
+	if (IS_ERR(ref))
+		return PTR_ERR(ref);
+
+	if (ref != NULL) {
+		*ret_index = btrfs_inode_ref_index(path->nodes[0], ref);
+		return 0;
+	}
+
+	btrfs_release_path(path);
+
+	extref = btrfs_lookup_inode_extref(trans, root, path, name,
+					   name_len, inode_objectid,
+					   ref_objectid, ins_len, cow);
+	if (IS_ERR(extref))
+		return PTR_ERR(extref);
+
+	if (extref) {
+		*ret_index = btrfs_inode_extref_index(path->nodes[0], extref);
+		return 0;
+	}
+
+	return -ENOENT;
+}
+
+int btrfs_del_inode_extref(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   const char *name, int name_len,
 			   u64 inode_objectid, u64 ref_objectid, u64 *index)
 {
 	struct btrfs_path *path;
 	struct btrfs_key key;
+	struct btrfs_inode_extref *extref;
+	struct extent_buffer *leaf;
+	int ret;
+	int del_len = name_len + sizeof(*extref);
+	unsigned long ptr;
+	unsigned long item_start;
+	u32 item_size;
+
+	key.objectid = inode_objectid;
+	btrfs_set_key_type(&key, BTRFS_INODE_EXTREF_KEY);
+	key.offset = btrfs_extref_hash(ref_objectid, name, name_len);
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	path->leave_spinning = 1;
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
+	if (!btrfs_find_name_in_ext_backref(path, name, name_len, &extref)) {
+		btrfs_std_error(root->fs_info, -ENOENT);
+		ret = -EROFS;
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
+int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
+			struct btrfs_root *root,
+			const char *name, int name_len,
+			u64 inode_objectid, u64 ref_objectid, u64 *index)
+{
+	struct btrfs_path *path;
+	struct btrfs_key key;
 	struct btrfs_inode_ref *ref;
 	struct extent_buffer *leaf;
 	unsigned long ptr;
@@ -91,6 +266,7 @@ int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
 	u32 item_size;
 	u32 sub_item_len;
 	int ret;
+	int search_ext_refs = 0;
 	int del_len = name_len + sizeof(*ref);
 
 	key.objectid = inode_objectid;
@@ -106,12 +282,14 @@ int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
 	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
 	if (ret > 0) {
 		ret = -ENOENT;
+		search_ext_refs = 1;
 		goto out;
 	} else if (ret < 0) {
 		goto out;
 	}
 	if (!find_name_in_backref(path, name, name_len, &ref)) {
 		ret = -ENOENT;
+		search_ext_refs = 1;
 		goto out;
 	}
 	leaf = path->nodes[0];
@@ -129,8 +307,77 @@ int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
 	item_start = btrfs_item_ptr_offset(leaf, path->slots[0]);
 	memmove_extent_buffer(leaf, ptr, ptr + sub_item_len,
 			      item_size - (ptr + sub_item_len - item_start));
-	btrfs_truncate_item(trans, root, path,
-				  item_size - sub_item_len, 1);
+	btrfs_truncate_item(trans, root, path, item_size - sub_item_len, 1);
+out:
+	btrfs_free_path(path);
+
+	if (search_ext_refs) {
+		/*
+		 * No refs were found, or we could not find the
+		 * name in our ref array. Find and remove the extended
+		 * inode ref then.
+		 */
+		return btrfs_del_inode_extref(trans, root, name, name_len,
+					      inode_objectid, ref_objectid, index);
+	}
+
+	return ret;
+}
+
+/*
+ * btrfs_insert_inode_extref() - Inserts an extended inode ref into a tree.
+ *
+ * The caller must have checked against BTRFS_LINK_MAX already.
+ */
+static int btrfs_insert_inode_extref(struct btrfs_trans_handle *trans,
+				     struct btrfs_root *root,
+				     const char *name, int name_len,
+				     u64 inode_objectid, u64 ref_objectid, u64 index)
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
+	path->leave_spinning = 1;
+	ret = btrfs_insert_empty_item(trans, root, path, &key,
+				      ins_len);
+	if (ret == -EEXIST) {
+		if (btrfs_find_name_in_ext_backref(path, name, name_len, NULL))
+			goto out;
+
+		btrfs_extend_item(trans, root, path, ins_len);
+		ret = 0;
+	}
+	if (ret < 0)
+		goto out;
+
+	leaf = path->nodes[0];
+	item = btrfs_item_nr(leaf, path->slots[0]);
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
 out:
 	btrfs_free_path(path);
 	return ret;
@@ -191,6 +438,19 @@ int btrfs_insert_inode_ref(struct btrfs_trans_handle *trans,
 
 out:
 	btrfs_free_path(path);
+
+	if (ret == -EMLINK) {
+		struct btrfs_super_block *disk_super = root->fs_info->super_copy;
+		/* We ran out of space in the ref array. Need to
+		 * add an extended ref. */
+		if (btrfs_super_incompat_flags(disk_super)
+		    & BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF)
+			ret = btrfs_insert_inode_extref(trans, root, name,
+							name_len,
+							inode_objectid,
+							ref_objectid, index);
+	}
+
 	return ret;
 }
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a7d1921..b96f0dc 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2890,7 +2890,6 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir,
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = BTRFS_I(dir)->root;
 	struct btrfs_path *path;
-	struct btrfs_inode_ref *ref;
 	struct btrfs_dir_item *di;
 	struct inode *inode = dentry->d_inode;
 	u64 index;
@@ -3004,17 +3003,17 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir,
 	}
 	btrfs_release_path(path);
 
-	ref = btrfs_lookup_inode_ref(trans, root, path,
-				dentry->d_name.name, dentry->d_name.len,
-				ino, dir_ino, 0);
-	if (IS_ERR(ref)) {
-		err = PTR_ERR(ref);
+	ret = btrfs_get_inode_ref_index(trans, root, path, dentry->d_name.name,
+					dentry->d_name.len, ino, dir_ino, 0,
+					&index);
+	if (ret) {
+		err = ret;
 		goto out;
 	}
-	BUG_ON(!ref); /* Logic error */
+
 	if (check_path_shared(root, path))
 		goto out;
-	index = btrfs_inode_ref_index(path->nodes[0], ref);
+
 	btrfs_release_path(path);
 
 	/*
@@ -4673,6 +4672,12 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	btrfs_set_key_type(&key[0], BTRFS_INODE_ITEM_KEY);
 	key[0].offset = 0;
 
+	/*
+	 * Start new inodes with an inode_ref. This is slightly more
+	 * efficient for small numbers of hard links since they will
+	 * be packed into one item. Extended refs will kick in if we
+	 * add more hard links than can fit in the ref item.
+	 */
 	key[1].objectid = objectid;
 	btrfs_set_key_type(&key[1], BTRFS_INODE_REF_KEY);
 	key[1].offset = ref_objectid;
@@ -4975,7 +4980,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	if (root->objectid != BTRFS_I(inode)->root->objectid)
 		return -EXDEV;
 
-	if (inode->i_nlink == ~0U)
+	if (inode->i_nlink >= BTRFS_LINK_MAX)
 		return -EMLINK;
 
 	err = btrfs_set_inode_index(dir, &index);
-- 
1.7.7

