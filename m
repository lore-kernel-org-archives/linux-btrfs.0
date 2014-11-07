Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:55785 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751285AbaKGUkX (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Fri, 7 Nov 2014 15:40:23 -0500
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: oliva@gnu.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs: make xattr replace operations atomic
Date: Fri,  7 Nov 2014 20:39:25 +0000
Message-Id: <1415392765-1877-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Replacing a xattr consists of doing a lookup for its existing value, delete
the current value from the respective leaf, release the search path and then
finally insert the new value. This leaves a time window where readers (getxattr,
listxattrs) won't see any value for the xattr. Xattrs are used to store ACLs,
so this has security implications.

This change also fixes 2 other existing issues which were:

*) Deleting the old xattr value without verifying first if the new xattr will
   fit in the existing leaf item (in case multiple xattrs are packed in the
   same item due to name hash collision);

*) Returning -EEXIST when the flag XATTR_CREATE is given and the xattr doesn't
   exist but we have have an existing item that packs muliple xattrs with
   the same name hash as the input xattr. In this case we should return ENOSPC.

A test case for xfstests follows soon.

Thanks to Alexandre Oliva for reporting the non-atomicity of the xattr replace
implementation.

Reported-by: Alexandre Oliva <oliva@gnu.org>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ctree.h    |   4 ++
 fs/btrfs/dir-item.c |  10 ++--
 fs/btrfs/xattr.c    | 142 ++++++++++++++++++++++++++++++----------------------
 3 files changed, 88 insertions(+), 68 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index a5e471a..9a47dfe 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3687,6 +3687,10 @@ struct btrfs_dir_item *btrfs_lookup_xattr(struct btrfs_trans_handle *trans,
 int verify_dir_item(struct btrfs_root *root,
 		    struct extent_buffer *leaf,
 		    struct btrfs_dir_item *dir_item);
+struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_root *root,
+						 struct btrfs_path *path,
+						 const char *name,
+						 int name_len);
 
 /* orphan.c */
 int btrfs_insert_orphan_item(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 65bf60e..c14e682 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -21,10 +21,6 @@
 #include "hash.h"
 #include "transaction.h"
 
-static struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_root *root,
-			      struct btrfs_path *path,
-			      const char *name, int name_len);
-
 /*
  * insert a name into a directory, doing overflow properly if there is a hash
  * collision.  data_size indicates how big the item inserted should be.  On
@@ -385,9 +381,9 @@ struct btrfs_dir_item *btrfs_lookup_xattr(struct btrfs_trans_handle *trans,
  * this walks through all the entries in a dir item and finds one
  * for a specific name.
  */
-static struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_root *root,
-			      struct btrfs_path *path,
-			      const char *name, int name_len)
+struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_root *root,
+						 struct btrfs_path *path,
+						 const char *name, int name_len)
 {
 	struct btrfs_dir_item *dir_item;
 	unsigned long name_ptr;
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index dcf2013..3c8fba1 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -91,7 +91,7 @@ static int do_setxattr(struct btrfs_trans_handle *trans,
 		       struct inode *inode, const char *name,
 		       const void *value, size_t size, int flags)
 {
-	struct btrfs_dir_item *di;
+	struct btrfs_dir_item *di = NULL;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_path *path;
 	size_t name_len = strlen(name);
@@ -104,83 +104,103 @@ static int do_setxattr(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
-	if (flags & XATTR_REPLACE) {
-		di = btrfs_lookup_xattr(trans, root, path, btrfs_ino(inode), name,
-					name_len, -1);
-		if (IS_ERR(di)) {
-			ret = PTR_ERR(di);
-			goto out;
-		} else if (!di) {
+	if (!value && ((flags & XATTR_REPLACE) || !flags)) {
+		/*
+		 * We're deleting only a xattr (no replace).
+		 * Don't follow the path below because it could leave a leaf
+		 * empty.
+		 */
+		di = btrfs_lookup_xattr(trans, root, path, btrfs_ino(inode),
+					name, name_len, -1);
+		if (!di && (flags & XATTR_REPLACE))
 			ret = -ENODATA;
-			goto out;
-		}
-		ret = btrfs_delete_one_dir_name(trans, root, path, di);
-		if (ret)
-			goto out;
-		btrfs_release_path(path);
+		else if (di)
+			ret = btrfs_delete_one_dir_name(trans, root, path, di);
+		goto out;
+	}
 
+	ret = btrfs_insert_xattr_item(trans, root, path, btrfs_ino(inode),
+				      name, name_len, value, size);
+	if (ret == -EOVERFLOW) {
 		/*
-		 * remove the attribute
+		 * We have an existing item in a leaf, split_leaf couldn't
+		 * expand it. That item might have or not a dir_item that
+		 * matches our target xattr, so lets check.
 		 */
-		if (!value)
-			goto out;
-	} else {
-		di = btrfs_lookup_xattr(NULL, root, path, btrfs_ino(inode),
-					name, name_len, 0);
-		if (IS_ERR(di)) {
-			ret = PTR_ERR(di);
+		ret = 0;
+		di = btrfs_match_dir_item_name(root, path, name, name_len);
+		if (!di && (flags & XATTR_CREATE)) {
+			ret = -ENOSPC;
 			goto out;
 		}
-		if (!di && !value)
-			goto out;
-		btrfs_release_path(path);
+	} else if (ret == -EEXIST) {
+		ret = 0;
+		di = btrfs_match_dir_item_name(root, path, name, name_len);
+		ASSERT(di); /* logic error */
+	} else if (ret) {
+		goto out;
 	}
 
-again:
-	ret = btrfs_insert_xattr_item(trans, root, path, btrfs_ino(inode),
-				      name, name_len, value, size);
-	/*
-	 * If we're setting an xattr to a new value but the new value is say
-	 * exactly BTRFS_MAX_XATTR_SIZE, we could end up with EOVERFLOW getting
-	 * back from split_leaf.  This is because it thinks we'll be extending
-	 * the existing item size, but we're asking for enough space to add the
-	 * item itself.  So if we get EOVERFLOW just set ret to EEXIST and let
-	 * the rest of the function figure it out.
-	 */
-	if (ret == -EOVERFLOW)
+	if (di && (flags & XATTR_CREATE))
 		ret = -EEXIST;
+	if (!di && (flags & XATTR_REPLACE))
+		ret = -ENODATA;
+	if (ret)
+		goto out;
 
-	if (ret == -EEXIST) {
-		if (flags & XATTR_CREATE)
-			goto out;
+	if (di) {
 		/*
-		 * We can't use the path we already have since we won't have the
-		 * proper locking for a delete, so release the path and
-		 * re-lookup to delete the thing.
+		 * We're doing a replace, and it must be atomic, that is, at
+		 * any point in time we have either the old or the new xattr
+		 * value in the tree. We don't want readers (getxattr and
+		 * listxattrs) to miss a value, this is specially important
+		 * for ACLs.
 		 */
-		btrfs_release_path(path);
-		di = btrfs_lookup_xattr(trans, root, path, btrfs_ino(inode),
-					name, name_len, -1);
-		if (IS_ERR(di)) {
-			ret = PTR_ERR(di);
-			goto out;
-		} else if (!di) {
-			/* Shouldn't happen but just in case... */
-			btrfs_release_path(path);
-			goto again;
+		const int slot = path->slots[0];
+		struct extent_buffer *leaf = path->nodes[0];
+		const u16 old_data_len = btrfs_dir_data_len(leaf, di);
+		const u32 item_size = btrfs_item_size_nr(leaf, slot);
+		const u32 data_size = sizeof(*di) + name_len + size;
+		struct btrfs_item *item;
+		unsigned long data_ptr;
+		char *ptr;
+
+		if (size > old_data_len) {
+			if (btrfs_leaf_free_space(root, leaf) <
+			    (size - old_data_len)) {
+				ret = -ENOSPC;
+				goto out;
+			}
 		}
 
-		ret = btrfs_delete_one_dir_name(trans, root, path, di);
-		if (ret)
-			goto out;
+		if (old_data_len + name_len + sizeof(*di) == item_size) {
+			/* No other xattrs packed in the same leaf item. */
+			if (size > old_data_len)
+				btrfs_extend_item(root, path,
+						  size - old_data_len);
+			else if (size < old_data_len)
+				btrfs_truncate_item(root, path, data_size, 1);
+		} else {
+			/* There are other xattrs packed in the same item. */
+			ret = btrfs_delete_one_dir_name(trans, root, path, di);
+			if (ret)
+				goto out;
+			btrfs_extend_item(root, path, data_size);
+		}
 
+		item = btrfs_item_nr(slot);
+		ptr = btrfs_item_ptr(leaf, slot, char);
+		ptr += btrfs_item_size(leaf, item) - data_size;
+		di = (struct btrfs_dir_item *)ptr;
+		btrfs_set_dir_data_len(leaf, di, size);
+		data_ptr = ((unsigned long)(di + 1)) + name_len;
+		write_extent_buffer(leaf, value, data_ptr, size);
+	} else {
 		/*
-		 * We have a value to set, so go back and try to insert it now.
+		 * Insert, and we had space for the xattr, so path->slots[0] is
+		 * where our xattr dir_item is and btrfs_insert_xattr_item()
+		 * filled it.
 		 */
-		if (value) {
-			btrfs_release_path(path);
-			goto again;
-		}
 	}
 out:
 	btrfs_free_path(path);
-- 
1.9.1

