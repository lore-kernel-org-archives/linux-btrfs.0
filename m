Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:59762 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933497AbdKHAyy (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 7 Nov 2017 19:54:54 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 3/3] btrfs: Cleanup existing name_len checks
Date: Wed,  8 Nov 2017 08:54:26 +0800
Message-Id: <20171108005426.17903-4-wqu@suse.com>
In-Reply-To: <20171108005426.17903-1-wqu@suse.com>
References: <20171108005426.17903-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since tree-checker has verified leaf when reading from disk, we don't
need the existing verify_dir_item() or btrfs_is_name_len_valid().

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Unlike checks in btrfs_mark_buffer_dirty(), the existing checks all
happen in read routine, so there is no need to worry about losing early
warning.
---
 fs/btrfs/ctree.h     |   5 ---
 fs/btrfs/dir-item.c  | 108 ---------------------------------------------------
 fs/btrfs/export.c    |   5 ---
 fs/btrfs/inode.c     |   4 --
 fs/btrfs/props.c     |   7 ----
 fs/btrfs/root-tree.c |   7 ----
 fs/btrfs/send.c      |   6 ---
 fs/btrfs/tree-log.c  |  47 +++++-----------------
 fs/btrfs/xattr.c     |   6 ---
 9 files changed, 9 insertions(+), 186 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f7df5536ab61..8835188a8d51 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3060,15 +3060,10 @@ struct btrfs_dir_item *btrfs_lookup_xattr(struct btrfs_trans_handle *trans,
 					  struct btrfs_path *path, u64 dir,
 					  const char *name, u16 name_len,
 					  int mod);
-int verify_dir_item(struct btrfs_fs_info *fs_info,
-		    struct extent_buffer *leaf, int slot,
-		    struct btrfs_dir_item *dir_item);
 struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_fs_info *fs_info,
 						 struct btrfs_path *path,
 						 const char *name,
 						 int name_len);
-bool btrfs_is_name_len_valid(struct extent_buffer *leaf, int slot,
-			     unsigned long start, u16 name_len);
 
 /* orphan.c */
 int btrfs_insert_orphan_item(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 41cb9196eaa8..cbe421605cd5 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -403,8 +403,6 @@ struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_fs_info *fs_info,
 			btrfs_dir_data_len(leaf, dir_item);
 		name_ptr = (unsigned long)(dir_item + 1);
 
-		if (verify_dir_item(fs_info, leaf, path->slots[0], dir_item))
-			return NULL;
 		if (btrfs_dir_name_len(leaf, dir_item) == name_len &&
 		    memcmp_extent_buffer(leaf, name, name_ptr, name_len) == 0)
 			return dir_item;
@@ -450,109 +448,3 @@ int btrfs_delete_one_dir_name(struct btrfs_trans_handle *trans,
 	}
 	return ret;
 }
-
-int verify_dir_item(struct btrfs_fs_info *fs_info,
-		    struct extent_buffer *leaf,
-		    int slot,
-		    struct btrfs_dir_item *dir_item)
-{
-	u16 namelen = BTRFS_NAME_LEN;
-	int ret;
-	u8 type = btrfs_dir_type(leaf, dir_item);
-
-	if (type >= BTRFS_FT_MAX) {
-		btrfs_crit(fs_info, "invalid dir item type: %d", (int)type);
-		return 1;
-	}
-
-	if (type == BTRFS_FT_XATTR)
-		namelen = XATTR_NAME_MAX;
-
-	if (btrfs_dir_name_len(leaf, dir_item) > namelen) {
-		btrfs_crit(fs_info, "invalid dir item name len: %u",
-		       (unsigned)btrfs_dir_name_len(leaf, dir_item));
-		return 1;
-	}
-
-	namelen = btrfs_dir_name_len(leaf, dir_item);
-	ret = btrfs_is_name_len_valid(leaf, slot,
-				      (unsigned long)(dir_item + 1), namelen);
-	if (!ret)
-		return 1;
-
-	/* BTRFS_MAX_XATTR_SIZE is the same for all dir items */
-	if ((btrfs_dir_data_len(leaf, dir_item) +
-	     btrfs_dir_name_len(leaf, dir_item)) >
-					BTRFS_MAX_XATTR_SIZE(fs_info)) {
-		btrfs_crit(fs_info, "invalid dir item name + data len: %u + %u",
-			   (unsigned)btrfs_dir_name_len(leaf, dir_item),
-			   (unsigned)btrfs_dir_data_len(leaf, dir_item));
-		return 1;
-	}
-
-	return 0;
-}
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
index b93fe05a39c7..ce5569606b2c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5878,7 +5878,6 @@ static int btrfs_filldir(void *addr, int entries, struct dir_context *ctx)
 static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 {
 	struct inode *inode = file_inode(file);
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_file_private *private = file->private_data;
 	struct btrfs_dir_item *di;
@@ -5946,9 +5945,6 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 		if (btrfs_should_delete_dir_index(&del_list, found_key.offset))
 			goto next;
 		di = btrfs_item_ptr(leaf, slot, struct btrfs_dir_item);
-		if (verify_dir_item(fs_info, leaf, slot, di))
-			goto next;
-
 		name_len = btrfs_dir_name_len(leaf, di);
 		if ((total_len + sizeof(struct dir_entry) + name_len) >=
 		    PAGE_SIZE) {
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
index aa7c71cff575..1f79405fd933 100644
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
@@ -1835,7 +1826,6 @@ static noinline int replay_one_dir_item(struct btrfs_trans_handle *trans,
 					struct extent_buffer *eb, int slot,
 					struct btrfs_key *key)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	int ret = 0;
 	u32 item_size = btrfs_item_size_nr(eb, slot);
 	struct btrfs_dir_item *di;
@@ -1848,8 +1838,6 @@ static noinline int replay_one_dir_item(struct btrfs_trans_handle *trans,
 	ptr_end = ptr + item_size;
 	while (ptr < ptr_end) {
 		di = (struct btrfs_dir_item *)ptr;
-		if (verify_dir_item(fs_info, eb, slot, di))
-			return -EIO;
 		name_len = btrfs_dir_name_len(eb, di);
 		ret = replay_one_name(trans, root, path, eb, di, key);
 		if (ret < 0)
@@ -2024,11 +2012,6 @@ static noinline int check_item_in_log(struct btrfs_trans_handle *trans,
 	ptr_end = ptr + item_size;
 	while (ptr < ptr_end) {
 		di = (struct btrfs_dir_item *)ptr;
-		if (verify_dir_item(fs_info, eb, slot, di)) {
-			ret = -EIO;
-			goto out;
-		}
-
 		name_len = btrfs_dir_name_len(eb, di);
 		name = kmalloc(name_len, GFP_NOFS);
 		if (!name) {
@@ -2109,7 +2092,6 @@ static int replay_xattr_deletes(struct btrfs_trans_handle *trans,
 			      struct btrfs_path *path,
 			      const u64 ino)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_key search_key;
 	struct btrfs_path *log_path;
 	int i;
@@ -2151,11 +2133,6 @@ static int replay_xattr_deletes(struct btrfs_trans_handle *trans,
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
@@ -4572,12 +4549,6 @@ static int btrfs_check_ref_name_override(struct extent_buffer *eb,
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
index 2c7e53f9ff1b..ad298c248da4 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -267,7 +267,6 @@ ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size)
 {
 	struct btrfs_key key;
 	struct inode *inode = d_inode(dentry);
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_path *path;
 	int ret = 0;
@@ -336,11 +335,6 @@ ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size)
 			u32 this_len = sizeof(*di) + name_len + data_len;
 			unsigned long name_ptr = (unsigned long)(di + 1);
 
-			if (verify_dir_item(fs_info, leaf, slot, di)) {
-				ret = -EIO;
-				goto err;
-			}
-
 			total_size += name_len + 1;
 			/*
 			 * We are just looking for how big our buffer needs to
-- 
2.15.0

