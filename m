Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45277 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758677Ab2HHTAY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Aug 2012 15:00:24 -0400
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>, Jan Schmidt <mail@jan-o-sch.net>,
        Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 3/3] btrfs: extended inode refs
Date: Wed,  8 Aug 2012 11:55:47 -0700
Message-Id: <1344452147-19409-4-git-send-email-mfasheh@suse.de>
In-Reply-To: <1344452147-19409-1-git-send-email-mfasheh@suse.de>
References: <1344452147-19409-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The iterate_irefs in backref.c is used to build path components from inode
refs. This patch adds code to iterate extended refs as well.

I had modify the callback function signature to abstract out some of the
differences between ref structures. iref_to_path() also needed similar
changes.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/backref.c |  134 +++++++++++++++++++++++++++++++++++++++++++---------
 fs/btrfs/backref.h |    2 -
 2 files changed, 112 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 658e09c..4a01f7c 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1194,11 +1194,10 @@ int btrfs_find_one_extref(struct btrfs_root *root, u64 inode_objectid,
  * value will be smaller than dest. callers must check this!
  */
 static char *iref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
-				struct btrfs_inode_ref *iref,
-				struct extent_buffer *eb_in, u64 parent,
-				char *dest, u32 size)
+			  u32 name_len, unsigned long name_off,
+			  struct extent_buffer *eb_in, u64 parent,
+			  char *dest, u32 size)
 {
-	u32 len;
 	int slot;
 	u64 next_inum;
 	int ret;
@@ -1206,17 +1205,17 @@ static char *iref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
 	struct extent_buffer *eb = eb_in;
 	struct btrfs_key found_key;
 	int leave_spinning = path->leave_spinning;
+	struct btrfs_inode_ref *iref;
 
 	if (bytes_left >= 0)
 		dest[bytes_left] = '\0';
 
 	path->leave_spinning = 1;
 	while (1) {
-		len = btrfs_inode_ref_name_len(eb, iref);
-		bytes_left -= len;
+		bytes_left -= name_len;
 		if (bytes_left >= 0)
 			read_extent_buffer(eb, dest + bytes_left,
-						(unsigned long)(iref + 1), len);
+					   name_off, name_len);
 		if (eb != eb_in) {
 			btrfs_tree_read_unlock_blocking(eb);
 			free_extent_buffer(eb);
@@ -1226,6 +1225,7 @@ static char *iref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
 			ret = -ENOENT;
 		if (ret)
 			break;
+
 		next_inum = found_key.offset;
 
 		/* regular exit ahead */
@@ -1241,8 +1241,11 @@ static char *iref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
 			btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
 		}
 		btrfs_release_path(path);
-
 		iref = btrfs_item_ptr(eb, slot, struct btrfs_inode_ref);
+
+		name_len = btrfs_inode_ref_name_len(eb, iref);
+		name_off = (unsigned long)(iref + 1);
+
 		parent = next_inum;
 		--bytes_left;
 		if (bytes_left >= 0)
@@ -1531,9 +1534,12 @@ int iterate_inodes_from_logical(u64 logical, struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
-static int iterate_irefs(u64 inum, struct btrfs_root *fs_root,
-				struct btrfs_path *path,
-				iterate_irefs_t *iterate, void *ctx)
+typedef int (iterate_irefs_t)(u64 parent, u32 name_len, unsigned long name_off,
+			      struct extent_buffer *eb, void *ctx);
+
+static int iterate_inode_refs(u64 inum, struct btrfs_root *fs_root,
+			      struct btrfs_path *path,
+			      iterate_irefs_t *iterate, void *ctx)
 {
 	int ret = 0;
 	int slot;
@@ -1550,7 +1556,7 @@ static int iterate_irefs(u64 inum, struct btrfs_root *fs_root,
 	while (!ret) {
 		path->leave_spinning = 1;
 		ret = inode_ref_info(inum, parent ? parent+1 : 0, fs_root, path,
-					&found_key);
+				     &found_key);
 		if (ret < 0)
 			break;
 		if (ret) {
@@ -1578,7 +1584,8 @@ static int iterate_irefs(u64 inum, struct btrfs_root *fs_root,
 				 "tree %llu\n", cur,
 				 (unsigned long long)found_key.objectid,
 				 (unsigned long long)fs_root->objectid);
-			ret = iterate(parent, iref, eb, ctx);
+			ret = iterate(parent, name_len,
+				      (unsigned long)(iref + 1), eb, ctx);
 			if (ret)
 				break;
 			len = sizeof(*iref) + name_len;
@@ -1593,12 +1600,98 @@ static int iterate_irefs(u64 inum, struct btrfs_root *fs_root,
 	return ret;
 }
 
+static int iterate_inode_extrefs(u64 inum, struct btrfs_root *fs_root,
+				 struct btrfs_path *path,
+				 iterate_irefs_t *iterate, void *ctx)
+{
+	int ret;
+	int slot;
+	u64 offset = 0;
+	u64 parent;
+	int found = 0;
+	struct extent_buffer *eb;
+	struct btrfs_inode_extref *extref;
+	struct extent_buffer *leaf;
+	u32 item_size;
+	u32 cur_offset;
+	unsigned long ptr;
+
+	while (1) {
+		ret = btrfs_find_one_extref(fs_root, inum, offset, path, &extref,
+					    &offset);
+		if (ret < 0)
+			break;
+		if (ret) {
+			ret = found ? 0 : -ENOENT;
+			break;
+		}
+		++found;
+
+		slot = path->slots[0];
+		eb = path->nodes[0];
+		/* make sure we can use eb after releasing the path */
+		atomic_inc(&eb->refs);
+
+		btrfs_tree_read_lock(eb);
+		btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
+		btrfs_release_path(path);
+
+		leaf = path->nodes[0];
+		item_size = btrfs_item_size_nr(leaf, path->slots[0]);
+		ptr = btrfs_item_ptr_offset(leaf, path->slots[0]);
+		cur_offset = 0;
+
+		while (cur_offset < item_size) {
+			u32 name_len;
+
+			extref = (struct btrfs_inode_extref *)(ptr + cur_offset);
+			parent = btrfs_inode_extref_parent(eb, extref);
+			name_len = btrfs_inode_extref_name_len(eb, extref);
+			ret = iterate(parent, name_len,
+				      (unsigned long)&extref->name, eb, ctx);
+			if (ret)
+				break;
+
+			cur_offset += btrfs_inode_extref_name_len(leaf, extref);
+			cur_offset += sizeof(*extref);
+		}
+		btrfs_tree_read_unlock_blocking(eb);
+		free_extent_buffer(eb);
+
+		offset++;
+	}
+
+	btrfs_release_path(path);
+
+	return ret;
+}
+
+static int iterate_irefs(u64 inum, struct btrfs_root *fs_root,
+			 struct btrfs_path *path, iterate_irefs_t *iterate,
+			 void *ctx)
+{
+	int ret;
+	int found_refs = 0;
+
+	ret = iterate_inode_refs(inum, fs_root, path, iterate, ctx);
+	if (!ret)
+		++found_refs;
+	else if (ret != -ENOENT)
+		return ret;
+
+	ret = iterate_inode_extrefs(inum, fs_root, path, iterate, ctx);
+	if (ret == -ENOENT && found_refs)
+		return 0;
+
+	return ret;
+}
+
 /*
  * returns 0 if the path could be dumped (probably truncated)
  * returns <0 in case of an error
  */
-static int inode_to_path(u64 inum, struct btrfs_inode_ref *iref,
-				struct extent_buffer *eb, void *ctx)
+static int inode_to_path(u64 inum, u32 name_len, unsigned long name_off,
+			 struct extent_buffer *eb, void *ctx)
 {
 	struct inode_fs_paths *ipath = ctx;
 	char *fspath;
@@ -1611,20 +1704,17 @@ static int inode_to_path(u64 inum, struct btrfs_inode_ref *iref,
 					ipath->fspath->bytes_left - s_ptr : 0;
 
 	fspath_min = (char *)ipath->fspath->val + (i + 1) * s_ptr;
-	fspath = iref_to_path(ipath->fs_root, ipath->btrfs_path, iref, eb,
-				inum, fspath_min, bytes_left);
+	fspath = iref_to_path(ipath->fs_root, ipath->btrfs_path, name_len,
+			      name_off, eb, inum, fspath_min,
+			      bytes_left);
 	if (IS_ERR(fspath))
 		return PTR_ERR(fspath);
 
 	if (fspath > fspath_min) {
-		pr_debug("path resolved: %s\n", fspath);
 		ipath->fspath->val[i] = (u64)(unsigned long)fspath;
 		++ipath->fspath->elem_cnt;
 		ipath->fspath->bytes_left = fspath - fspath_min;
 	} else {
-		pr_debug("missed path, not enough space. missing bytes: %lu, "
-			 "constructed so far: %s\n",
-			 (unsigned long)(fspath_min - fspath), fspath_min);
 		++ipath->fspath->elem_missed;
 		ipath->fspath->bytes_missing += fspath_min - fspath;
 		ipath->fspath->bytes_left = 0;
@@ -1646,7 +1736,7 @@ static int inode_to_path(u64 inum, struct btrfs_inode_ref *iref,
 int paths_from_inode(u64 inum, struct inode_fs_paths *ipath)
 {
 	return iterate_irefs(inum, ipath->fs_root, ipath->btrfs_path,
-				inode_to_path, ipath);
+			     inode_to_path, ipath);
 }
 
 struct btrfs_data_container *init_data_container(u32 total_bytes)
diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
index 9f3e251..c80889a 100644
--- a/fs/btrfs/backref.h
+++ b/fs/btrfs/backref.h
@@ -32,8 +32,6 @@ struct inode_fs_paths {
 
 typedef int (iterate_extent_inodes_t)(u64 inum, u64 offset, u64 root,
 		void *ctx);
-typedef int (iterate_irefs_t)(u64 parent, struct btrfs_inode_ref *iref,
-				struct extent_buffer *eb, void *ctx);
 
 int inode_item_info(u64 inum, u64 ioff, struct btrfs_root *fs_root,
 			struct btrfs_path *path);
-- 
1.7.7

