Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:47215 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754633AbdKAMWc (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 1 Nov 2017 08:22:32 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 2/2] btrfs: Cleanup existing name_len checks
Date: Wed,  1 Nov 2017 20:22:13 +0800
Message-Id: <20171101122213.7122-2-wqu@suse.com>
In-Reply-To: <20171101122213.7122-1-wqu@suse.com>
References: <20171101122213.7122-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since tree-checker has verified leaf when reading from disk, we don't
need the existing checker.

This cleanup reverts the following commits:
fbc326159a01 ("btrfs: Verify dir_item in iterate_object_props")
64c7b01446f4 ("btrfs: Check name_len before in btrfs_del_root_ref")
488d7c456653 ("btrfs: Check name_len before reading btrfs_get_name")
59b0a7f2c7c1 ("btrfs: Check name_len before read in iterate_dir_item")
3c1d41844896 ("btrfs: Check name_len in btrfs_check_ref_name_override")
8ee8c2d62d5f ("btrfs: Verify dir_item in replay_xattr_deletes")
26a836cec2ea ("btrfs: Check name_len on add_inode_ref call path")
e79a33270d05 ("btrfs: Check name_len with boundary in verify dir_item")
19c6dcbfa746 ("btrfs: Introduce btrfs_is_name_len_valid to avoid reading beyond boundary")

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ctree.h     |  4 +--
 fs/btrfs/dir-item.c  | 76 ++--------------------------------------------------
 fs/btrfs/export.c    |  5 ----
 fs/btrfs/inode.c     |  2 +-
 fs/btrfs/props.c     |  7 -----
 fs/btrfs/root-tree.c |  7 -----
 fs/btrfs/send.c      |  6 -----
 fs/btrfs/tree-log.c  | 43 ++++++++---------------------
 fs/btrfs/xattr.c     |  2 +-
 9 files changed, 16 insertions(+), 136 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f7df5536ab61..b674fb244e03 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3061,14 +3061,12 @@ struct btrfs_dir_item *btrfs_lookup_xattr(struct btrfs_trans_handle *trans,
 					  const char *name, u16 name_len,
 					  int mod);
 int verify_dir_item(struct btrfs_fs_info *fs_info,
-		    struct extent_buffer *leaf, int slot,
+		    struct extent_buffer *leaf,
 		    struct btrfs_dir_item *dir_item);
 struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_fs_info *fs_info,
 						 struct btrfs_path *path,
 						 const char *name,
 						 int name_len);
-bool btrfs_is_name_len_valid(struct extent_buffer *leaf, int slot,
-			     unsigned long start, u16 name_len);
 
 /* orphan.c */
 int btrfs_insert_orphan_item(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 41cb9196eaa8..c24d615e3d7f 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -395,6 +395,8 @@ struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_fs_info *fs_info,
 
 	leaf = path->nodes[0];
 	dir_item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_dir_item);
+	if (verify_dir_item(fs_info, leaf, dir_item))
+		return NULL;
 
 	total_len = btrfs_item_size_nr(leaf, path->slots[0]);
 	while (cur < total_len) {
@@ -403,8 +405,6 @@ struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_fs_info *fs_info,
 			btrfs_dir_data_len(leaf, dir_item);
 		name_ptr = (unsigned long)(dir_item + 1);
 
-		if (verify_dir_item(fs_info, leaf, path->slots[0], dir_item))
-			return NULL;
 		if (btrfs_dir_name_len(leaf, dir_item) == name_len &&
 		    memcmp_extent_buffer(leaf, name, name_ptr, name_len) == 0)
 			return dir_item;
@@ -453,11 +453,9 @@ int btrfs_delete_one_dir_name(struct btrfs_trans_handle *trans,
 
 int verify_dir_item(struct btrfs_fs_info *fs_info,
 		    struct extent_buffer *leaf,
-		    int slot,
 		    struct btrfs_dir_item *dir_item)
 {
 	u16 namelen = BTRFS_NAME_LEN;
-	int ret;
 	u8 type = btrfs_dir_type(leaf, dir_item);
 
 	if (type >= BTRFS_FT_MAX) {
@@ -474,12 +472,6 @@ int verify_dir_item(struct btrfs_fs_info *fs_info,
 		return 1;
 	}
 
-	namelen = btrfs_dir_name_len(leaf, dir_item);
-	ret = btrfs_is_name_len_valid(leaf, slot,
-				      (unsigned long)(dir_item + 1), namelen);
-	if (!ret)
-		return 1;
-
 	/* BTRFS_MAX_XATTR_SIZE is the same for all dir items */
 	if ((btrfs_dir_data_len(leaf, dir_item) +
 	     btrfs_dir_name_len(leaf, dir_item)) >
@@ -492,67 +484,3 @@ int verify_dir_item(struct btrfs_fs_info *fs_info,
 
 	return 0;
 }
-
-bool btrfs_is_name_len_valid(struct extent_buffer *leaf, int slot,
-			     unsigned long start, u16 name_len)
-{
-	struct btrfs_fs_info *fs_info = leaf->fs_info;
-	struct btrfs_key key;
-	u32 read_start;
-	u32 read_end;
-	u32 item_start;
-	u32 item_end;
-	u32 size;
-	bool ret = true;
-
-	ASSERT(start > BTRFS_LEAF_DATA_OFFSET);
-
-	read_start = start - BTRFS_LEAF_DATA_OFFSET;
-	read_end = read_start + name_len;
-	item_start = btrfs_item_offset_nr(leaf, slot);
-	item_end = btrfs_item_end_nr(leaf, slot);
-
-	btrfs_item_key_to_cpu(leaf, &key, slot);
-
-	switch (key.type) {
-	case BTRFS_DIR_ITEM_KEY:
-	case BTRFS_XATTR_ITEM_KEY:
-	case BTRFS_DIR_INDEX_KEY:
-		size = sizeof(struct btrfs_dir_item);
-		break;
-	case BTRFS_INODE_REF_KEY:
-		size = sizeof(struct btrfs_inode_ref);
-		break;
-	case BTRFS_INODE_EXTREF_KEY:
-		size = sizeof(struct btrfs_inode_extref);
-		break;
-	case BTRFS_ROOT_REF_KEY:
-	case BTRFS_ROOT_BACKREF_KEY:
-		size = sizeof(struct btrfs_root_ref);
-		break;
-	default:
-		ret = false;
-		goto out;
-	}
-
-	if (read_start < item_start) {
-		ret = false;
-		goto out;
-	}
-	if (read_end > item_end) {
-		ret = false;
-		goto out;
-	}
-
-	/* there shall be item(s) before name */
-	if (read_start - item_start < size) {
-		ret = false;
-		goto out;
-	}
-
-out:
-	if (!ret)
-		btrfs_crit(fs_info, "invalid dir item name len: %u",
-			   (unsigned int)name_len);
-	return ret;
-}
diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
index fa66980726c9..87144c9f9593 100644
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -282,11 +282,6 @@ static int btrfs_get_name(struct dentry *parent, char *name,
 		name_len = btrfs_inode_ref_name_len(leaf, iref);
 	}
 
-	ret = btrfs_is_name_len_valid(leaf, path->slots[0], name_ptr, name_len);
-	if (!ret) {
-		btrfs_free_path(path);
-		return -EIO;
-	}
 	read_extent_buffer(leaf, name, name_ptr, name_len);
 	btrfs_free_path(path);
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7b751348abdc..976f96000b2c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5953,7 +5953,7 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 		if (btrfs_should_delete_dir_index(&del_list, found_key.offset))
 			goto next;
 		di = btrfs_item_ptr(leaf, slot, struct btrfs_dir_item);
-		if (verify_dir_item(fs_info, leaf, slot, di))
+		if (verify_dir_item(fs_info, leaf, di))
 			goto next;
 
 		name_len = btrfs_dir_name_len(leaf, di);
diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index f6a05f836629..c39a940d0c75 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -164,7 +164,6 @@ static int iterate_object_props(struct btrfs_root *root,
 						 size_t),
 				void *ctx)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	int ret;
 	char *name_buf = NULL;
 	char *value_buf = NULL;
@@ -215,12 +214,6 @@ static int iterate_object_props(struct btrfs_root *root,
 			name_ptr = (unsigned long)(di + 1);
 			data_ptr = name_ptr + name_len;
 
-			if (verify_dir_item(fs_info, leaf,
-					    path->slots[0], di)) {
-				ret = -EIO;
-				goto out;
-			}
-
 			if (name_len <= XATTR_BTRFS_PREFIX_LEN ||
 			    memcmp_extent_buffer(leaf, XATTR_BTRFS_PREFIX,
 						 name_ptr,
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 3338407ef0f0..aab0194efe46 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -387,13 +387,6 @@ int btrfs_del_root_ref(struct btrfs_trans_handle *trans,
 		WARN_ON(btrfs_root_ref_dirid(leaf, ref) != dirid);
 		WARN_ON(btrfs_root_ref_name_len(leaf, ref) != name_len);
 		ptr = (unsigned long)(ref + 1);
-		ret = btrfs_is_name_len_valid(leaf, path->slots[0], ptr,
-					      name_len);
-		if (!ret) {
-			err = -EIO;
-			goto out;
-		}
-
 		WARN_ON(memcmp_extent_buffer(leaf, name, ptr, name_len));
 		*sequence = btrfs_root_ref_sequence(leaf, ref);
 
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index c10e4c70f02d..2a2dc603da13 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1059,12 +1059,6 @@ static int iterate_dir_item(struct btrfs_root *root, struct btrfs_path *path,
 			}
 		}
 
-		ret = btrfs_is_name_len_valid(eb, path->slots[0],
-			  (unsigned long)(di + 1), name_len + data_len);
-		if (!ret) {
-			ret = -EIO;
-			goto out;
-		}
 		if (name_len + data_len > buf_len) {
 			buf_len = name_len + data_len;
 			if (is_vmalloc_addr(buf)) {
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index aa7c71cff575..e8a4a38b190d 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1173,19 +1173,15 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-static int extref_get_fields(struct extent_buffer *eb, int slot,
-			     unsigned long ref_ptr, u32 *namelen, char **name,
-			     u64 *index, u64 *parent_objectid)
+static int extref_get_fields(struct extent_buffer *eb, unsigned long ref_ptr,
+			     u32 *namelen, char **name, u64 *index,
+			     u64 *parent_objectid)
 {
 	struct btrfs_inode_extref *extref;
 
 	extref = (struct btrfs_inode_extref *)ref_ptr;
 
 	*namelen = btrfs_inode_extref_name_len(eb, extref);
-	if (!btrfs_is_name_len_valid(eb, slot, (unsigned long)&extref->name,
-				     *namelen))
-		return -EIO;
-
 	*name = kmalloc(*namelen, GFP_NOFS);
 	if (*name == NULL)
 		return -ENOMEM;
@@ -1200,19 +1196,14 @@ static int extref_get_fields(struct extent_buffer *eb, int slot,
 	return 0;
 }
 
-static int ref_get_fields(struct extent_buffer *eb, int slot,
-			  unsigned long ref_ptr, u32 *namelen, char **name,
-			  u64 *index)
+static int ref_get_fields(struct extent_buffer *eb, unsigned long ref_ptr,
+			  u32 *namelen, char **name, u64 *index)
 {
 	struct btrfs_inode_ref *ref;
 
 	ref = (struct btrfs_inode_ref *)ref_ptr;
 
 	*namelen = btrfs_inode_ref_name_len(eb, ref);
-	if (!btrfs_is_name_len_valid(eb, slot, (unsigned long)(ref + 1),
-				     *namelen))
-		return -EIO;
-
 	*name = kmalloc(*namelen, GFP_NOFS);
 	if (*name == NULL)
 		return -ENOMEM;
@@ -1287,8 +1278,8 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 
 	while (ref_ptr < ref_end) {
 		if (log_ref_ver) {
-			ret = extref_get_fields(eb, slot, ref_ptr, &namelen,
-					  &name, &ref_index, &parent_objectid);
+			ret = extref_get_fields(eb, ref_ptr, &namelen, &name,
+						&ref_index, &parent_objectid);
 			/*
 			 * parent object can change from one array
 			 * item to another.
@@ -1300,8 +1291,8 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 				goto out;
 			}
 		} else {
-			ret = ref_get_fields(eb, slot, ref_ptr, &namelen,
-					     &name, &ref_index);
+			ret = ref_get_fields(eb, ref_ptr, &namelen, &name,
+					     &ref_index);
 		}
 		if (ret)
 			goto out;
@@ -1848,7 +1839,7 @@ static noinline int replay_one_dir_item(struct btrfs_trans_handle *trans,
 	ptr_end = ptr + item_size;
 	while (ptr < ptr_end) {
 		di = (struct btrfs_dir_item *)ptr;
-		if (verify_dir_item(fs_info, eb, slot, di))
+		if (verify_dir_item(fs_info, eb, di))
 			return -EIO;
 		name_len = btrfs_dir_name_len(eb, di);
 		ret = replay_one_name(trans, root, path, eb, di, key);
@@ -2024,7 +2015,7 @@ static noinline int check_item_in_log(struct btrfs_trans_handle *trans,
 	ptr_end = ptr + item_size;
 	while (ptr < ptr_end) {
 		di = (struct btrfs_dir_item *)ptr;
-		if (verify_dir_item(fs_info, eb, slot, di)) {
+		if (verify_dir_item(fs_info, eb, di)) {
 			ret = -EIO;
 			goto out;
 		}
@@ -2109,7 +2100,6 @@ static int replay_xattr_deletes(struct btrfs_trans_handle *trans,
 			      struct btrfs_path *path,
 			      const u64 ino)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_key search_key;
 	struct btrfs_path *log_path;
 	int i;
@@ -2151,11 +2141,6 @@ static int replay_xattr_deletes(struct btrfs_trans_handle *trans,
 			u32 this_len = sizeof(*di) + name_len + data_len;
 			char *name;
 
-			ret = verify_dir_item(fs_info, path->nodes[0], i, di);
-			if (ret) {
-				ret = -EIO;
-				goto out;
-			}
 			name = kmalloc(name_len, GFP_NOFS);
 			if (!name) {
 				ret = -ENOMEM;
@@ -4572,12 +4557,6 @@ static int btrfs_check_ref_name_override(struct extent_buffer *eb,
 			this_len = sizeof(*extref) + this_name_len;
 		}
 
-		ret = btrfs_is_name_len_valid(eb, slot, name_ptr,
-					      this_name_len);
-		if (!ret) {
-			ret = -EIO;
-			goto out;
-		}
 		if (this_name_len > name_len) {
 			char *new_name;
 
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 2c7e53f9ff1b..b3cbf80c5acf 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -336,7 +336,7 @@ ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size)
 			u32 this_len = sizeof(*di) + name_len + data_len;
 			unsigned long name_ptr = (unsigned long)(di + 1);
 
-			if (verify_dir_item(fs_info, leaf, slot, di)) {
+			if (verify_dir_item(fs_info, leaf, di)) {
 				ret = -EIO;
 				goto err;
 			}
-- 
2.14.3

