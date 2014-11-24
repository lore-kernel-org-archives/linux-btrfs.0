Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49685 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752962AbaKXJJS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Nov 2014 04:09:18 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sAO990uv012254
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Nov 2014 17:09:00 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 6/6] btrfs-progs: Add fixing function for inodes whose nlink dismatch
Date: Mon, 24 Nov 2014 17:07:05 +0800
Message-ID: <1416820025-10373-7-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1416820025-10373-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1416820025-10373-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[BUG]
At least two users have already hit a bug in btrfs causing file
missing(Chromium config file).
The missing file's nlink is still 1 but its backref points to non-exist
parent inode.

This should be a kernel bug, but btrfsck fix is needed anyway.

[FIX]
For such nlink mismatch inode, we will delete all the invalid backref,
if there is no valid backref for it, create 'lost+found' under the root
of the subvolume and add link to the directory.

Reported-by: Mike Gavrilov <mikhail.v.gavrilov@gmail.com>
Reported-by: Ed Tomlinson <edt@aei.ca>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 276 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 272 insertions(+), 4 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 6419caf..2b3263b 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -27,6 +27,7 @@
 #include <unistd.h>
 #include <getopt.h>
 #include <uuid/uuid.h>
+#include <math.h>
 #include "ctree.h"
 #include "volumes.h"
 #include "repair.h"
@@ -1777,6 +1778,73 @@ static int create_inode_item(struct btrfs_root *root,
 	return 0;
 }
 
+/* Check the dir_item/index conflicts before insert */
+static int check_dir_conflict(struct btrfs_root *root,
+			      char *name, int namelen,
+			      u64 dir, u64 index)
+{
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	struct btrfs_inode_item *inode_item;
+	struct btrfs_dir_item *dir_item;
+	int ret = 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	/* Given dir exists? */
+	key.objectid = dir;
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.offset = 0;
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+	if (ret > 0) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	/* Is it a dir? */
+	inode_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
+				    struct btrfs_inode_item);
+	if (!(btrfs_inode_mode(path->nodes[0], inode_item) &
+	      S_IFDIR)) {
+		ret = -ENOTDIR;
+		goto out;
+	}
+	btrfs_release_path(path);
+
+	/* Name conflicting? */
+	dir_item = btrfs_lookup_dir_item(NULL, root, path, dir, name,
+					 namelen, 0);
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
+	/*  Index conflicting? */
+	dir_item = btrfs_lookup_dir_index(NULL, root, path, dir, name,
+					  namelen, index, 0);
+	if (IS_ERR(dir_item)) {
+		ret = PTR_ERR(dir_item);
+		goto out;
+	}
+	if (dir_item) {
+		ret = -EEXIST;
+		goto out;
+	}
+
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
 static int repair_inode_backrefs(struct btrfs_root *root,
 				 struct inode_record *rec,
 				 struct cache_tree *inode_cache,
@@ -1837,6 +1905,18 @@ static int repair_inode_backrefs(struct btrfs_root *root,
 			struct btrfs_trans_handle *trans;
 			struct btrfs_key location;
 
+			ret = check_dir_conflict(root, backref->name,
+						 backref->namelen,
+						 backref->dir,
+						 backref->index);
+			if (ret) {
+				/*
+				 * let nlink fixing routine to handle it,
+				 * which can do it better.
+				 */
+				ret = 0;
+				break;
+			}
 			location.objectid = rec->ino;
 			location.type = BTRFS_INODE_ITEM_KEY;
 			location.offset = 0;
@@ -1874,20 +1954,206 @@ static int repair_inode_backrefs(struct btrfs_root *root,
 	return ret ? ret : repaired;
 }
 
+/*
+ * Search for the inode_ref of given 'ino' to get the filename and
+ * btrfs type.
+ * This will only use the first inode_ref.
+ */
+static int find_file_name_type(struct btrfs_root *root,
+			       struct btrfs_path *path,
+			       u64 ino, char *buf,
+			       int *namelen, u8 *type)
+{
+	struct btrfs_key key;
+	struct btrfs_key found_key;
+	struct btrfs_inode_ref *inode_ref;
+	struct btrfs_inode_item *inode_item;
+	struct extent_buffer *node;
+	u32 ret_namelen;
+	int slot;
+	int ret = 0;
+
+	/* Search for name in backref(Use the first one) */
+	key.objectid = ino;
+	key.type = BTRFS_INODE_REF_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+	node = path->nodes[0];
+	slot = path->slots[0];
+	btrfs_item_key_to_cpu(node, &found_key, slot);
+	if (found_key.objectid != ino ||
+	    found_key.type != BTRFS_INODE_REF_KEY) {
+		ret = -ENOENT;
+		goto out;
+	}
+	inode_ref = btrfs_item_ptr(node, slot, struct btrfs_inode_ref);
+	ret_namelen = btrfs_inode_ref_name_len(node, inode_ref);
+	read_extent_buffer(node, buf, (unsigned long)(inode_ref + 1),
+			   ret_namelen);
+	/* Search for inode type */
+	ret = btrfs_previous_item(root, path, ino, BTRFS_INODE_ITEM_KEY);
+	if (ret) {
+		if (ret > 0)
+			ret = -ENOENT;
+		goto out;
+	}
+	node = path->nodes[0];
+	slot = path->slots[0];
+	inode_item = btrfs_item_ptr(node, slot, struct btrfs_inode_item);
+
+	if (namelen)
+		*namelen = ret_namelen;
+	if (type)
+		*type = imode_to_type(btrfs_inode_mode(node, inode_item));
+out:
+	btrfs_release_path(path);
+	return ret;
+}
+
+
+static int remove_all_invalid_backref(struct btrfs_trans_handle *trans,
+				      struct btrfs_root *root,
+				      struct inode_record *rec)
+{
+	struct inode_backref *backref;
+	struct inode_backref *tmp;
+	int ret = 0;
+
+	list_for_each_entry_safe(backref, tmp, &rec->backrefs, list) {
+		if (backref->found_dir_item &&
+		    backref->found_inode_ref &&
+		    backref->found_dir_index)
+			continue;
+
+		/*
+		 * We can only handle case that has inode ref but points to
+		 * invalid dir_index/dir_item.
+		 */
+		if (!backref->found_inode_ref)
+			return -ENOENT;
+		ret = btrfs_unlink(trans, root, rec->ino, backref->dir,
+				   backref->index, backref->name,
+				   backref->namelen, 0);
+		if (ret < 0)
+			goto out;
+		list_del(&backref->list);
+		free(backref);
+		rec->nlink--;
+	}
+out:
+	return ret;
+}
+
+
+static int repair_inode_nlinks(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *root,
+			       struct btrfs_path *path,
+			       struct inode_record *rec)
+{
+	char *dir_name = "lost+found";
+	char namebuf[BTRFS_NAME_LEN] = {0};
+	u64 lost_found_ino;
+	u32 mode = 0700;
+	u8 type = 0;
+	int namelen = 0;
+	int ret = 0;
+
+	/*
+	 * Get file name and type first before these invalid inode ref
+	 * are deleted by remove_all_invalid_backref()
+	 */
+	ret = find_file_name_type(root, path, rec->ino, namebuf,
+				  &namelen, &type);
+	if (ret < 0) {
+		fprintf(stderr,
+			"Fail to get file name of inode %llu: %s\n",
+			rec->ino, strerror(-ret));
+		goto out;
+	}
+	ret = remove_all_invalid_backref(trans, root, rec);
+	if (ret < 0) {
+		fprintf(stderr,
+			"Fail to cleanup invalid backref for inode %llu: %s\n",
+			rec->ino, strerror(-ret));
+		goto out;
+	}
+
+	if (rec->found_link == 0) {
+		ret = btrfs_mkdir(trans, root, dir_name, strlen(dir_name),
+				  BTRFS_FIRST_FREE_OBJECTID, &lost_found_ino,
+				  mode);
+		if (ret < 0) {
+			fprintf(stderr, "Failed to create '%s' dir: %s",
+				dir_name, strerror(-ret));
+			goto out;
+		}
+		ret = btrfs_add_link(trans, root, rec->ino, lost_found_ino,
+				     namebuf, namelen, type, NULL, 1);
+		if (ret == -EEXIST) {
+			/*
+			 * Conflicting file name, add ".INO" as suffix
+			 * +1 for '.' and +1 for log10
+			 */
+			if (namelen + log10(rec->ino) + 2 > BTRFS_NAME_LEN) {
+				ret = -EFBIG;
+				goto out;
+			}
+			snprintf(namebuf + namelen, BTRFS_NAME_LEN - namelen,
+				 ".%llu", rec->ino);
+			namelen += (log10(rec->ino) + 2);
+			ret = btrfs_add_link(trans, root, rec->ino,
+					     lost_found_ino, namebuf,
+					     namelen, type, NULL, 1);
+		}
+		if (ret < 0) {
+			fprintf(stderr,
+				"Fail to link the inode %llu to %s dir: %s",
+				rec->ino, dir_name, strerror(-ret));
+			goto out;
+		}
+		/*
+		 * Just increase the found_link, don't actually add the
+		 * backref. This will make things easiler and this inode
+		 * record will be freed after the repair is done.
+		 * So fsck will not report problem about this inode.
+		 */
+		rec->found_link++;
+		printf("Moving file '%.*s' to '%s' dir due to its invalid backref\n",
+		       namelen, namebuf, dir_name);
+	}
+	rec->errors &= ~I_ERR_LINK_COUNT_WRONG;
+	printf("Fixed the nlink of inode %llu\n", rec->ino);
+out:
+	btrfs_release_path(path);
+	return ret;
+}
+
 static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_path *path;
 	int ret = 0;
 
-	if (!(rec->errors & (I_ERR_DIR_ISIZE_WRONG | I_ERR_NO_ORPHAN_ITEM)))
+	if (!(rec->errors & (I_ERR_DIR_ISIZE_WRONG |
+			     I_ERR_NO_ORPHAN_ITEM |
+			     I_ERR_LINK_COUNT_WRONG)))
 		return rec->errors;
 
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
 
-	trans = btrfs_start_transaction(root, 1);
+	/*
+	 * For nlink repair, it may create a dir and add link, so
+	 * 2 for parent(256)'s dir_index and dir_item
+	 * 2 for lost+found dir's inode_item and inode_ref
+	 * 1 for the new inode_ref of the file
+	 * 2 for lost+found dir's dir_index and dir_item for the file
+	 */
+	trans = btrfs_start_transaction(root, 7);
 	if (IS_ERR(trans)) {
 		btrfs_free_path(path);
 		return PTR_ERR(trans);
@@ -1897,6 +2163,8 @@ static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
 		ret = repair_inode_isize(trans, root, path, rec);
 	if (!ret && rec->errors & I_ERR_NO_ORPHAN_ITEM)
 		ret = repair_inode_orphan_item(trans, root, path, rec);
+	if (!ret && rec->errors & I_ERR_LINK_COUNT_WRONG)
+		ret = repair_inode_nlinks(trans, root, path, rec);
 	btrfs_commit_transaction(trans, root);
 	btrfs_free_path(path);
 	return ret;
@@ -2032,6 +2300,8 @@ static int check_inode_recs(struct btrfs_root *root,
 			}
 		}
 
+		if (rec->found_link != rec->nlink)
+			rec->errors |= I_ERR_LINK_COUNT_WRONG;
 		if (repair) {
 			ret = try_repair_inode(root, rec);
 			if (ret == 0 && can_free_inode_rec(rec)) {
@@ -2044,8 +2314,6 @@ static int check_inode_recs(struct btrfs_root *root,
 		error++;
 		if (!rec->found_inode_item)
 			rec->errors |= I_ERR_NO_INODE_ITEM;
-		if (rec->found_link != rec->nlink)
-			rec->errors |= I_ERR_LINK_COUNT_WRONG;
 		print_inode_error(root, rec);
 		list_for_each_entry(backref, &rec->backrefs, list) {
 			if (!backref->found_dir_item)
-- 
2.1.3

