Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63760 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755080AbaJJU5m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Oct 2014 16:57:42 -0400
Received: from pps.filterd (m0004003 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s9AKsFoK012653
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 13:57:41 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0b-00082601.pphosted.com with ESMTP id 1pxmbv8mwc-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 13:57:41 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 08/12] Btrfs-progs: delete bogus dir indexes
Date: Fri, 10 Oct 2014 16:57:13 -0400
Message-ID: <1412974637-31334-9-git-send-email-jbacik@fb.com>
In-Reply-To: <1412974637-31334-1-git-send-email-jbacik@fb.com>
References: <1412974637-31334-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We may run across dir indexes that are corrupt in such a way that it makes them
useless, such as having a bad location key or a bad name.  In this case we can
just delete dir indexes that don't show up properly and then re-create what we
need.  When we delete dir indexes however we need to restart scanning the fs
tree as we could have greated bogus inode recs if the location key was bad, so
set it up so that if we had to delete an dir index we go ahead and free up our
inode recs and return -EAGAIN to check_fs_roots so it knows to restart the loop.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 cmds-check.c | 137 +++++++++++++++++++++++++++++++++++++++++++++++++++--------
 ctree.h      |   9 ++++
 dir-item.c   | 101 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 229 insertions(+), 18 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 9522077..8fdc542 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1585,35 +1585,99 @@ static int add_missing_dir_index(struct btrfs_root *root,
 	return 0;
 }
 
+static int delete_dir_index(struct btrfs_root *root,
+			    struct cache_tree *inode_cache,
+			    struct inode_record *rec,
+			    struct inode_backref *backref)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_dir_item *di;
+	struct btrfs_path *path;
+	int ret = 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		btrfs_free_path(path);
+		return PTR_ERR(trans);
+	}
+
+
+	fprintf(stderr, "Deleting bad dir index [%llu,%u,%llu] root %llu\n",
+		(unsigned long long)backref->dir,
+		BTRFS_DIR_INDEX_KEY, (unsigned long long)backref->index,
+		(unsigned long long)root->objectid);
+
+	di = btrfs_lookup_dir_index(trans, root, path, backref->dir,
+				    backref->name, backref->namelen,
+				    backref->index, -1);
+	if (IS_ERR(di)) {
+		ret = PTR_ERR(di);
+		btrfs_free_path(path);
+		btrfs_commit_transaction(trans, root);
+		if (ret == -ENOENT)
+			return 0;
+		return ret;
+	}
+
+	if (!di)
+		ret = btrfs_del_item(trans, root, path);
+	else
+		ret = btrfs_delete_one_dir_name(trans, root, path, di);
+	BUG_ON(ret);
+	btrfs_free_path(path);
+	btrfs_commit_transaction(trans, root);
+	return ret;
+}
+
 static int repair_inode_backrefs(struct btrfs_root *root,
 				 struct inode_record *rec,
-				 struct cache_tree *inode_cache)
+				 struct cache_tree *inode_cache,
+				 int delete)
 {
 	struct inode_backref *tmp, *backref;
 	u64 root_dirid = btrfs_root_dirid(&root->root_item);
 	int ret = 0;
+	int repaired = 0;
 
 	list_for_each_entry_safe(backref, tmp, &rec->backrefs, list) {
 		/* Index 0 for root dir's are special, don't mess with it */
 		if (rec->ino == root_dirid && backref->index == 0)
 			continue;
 
-		if (!backref->found_dir_index && backref->found_inode_ref) {
-			ret = add_missing_dir_index(root, inode_cache, rec,
-						    backref);
+		if (delete && backref->found_dir_index &&
+		    !backref->found_inode_ref) {
+			ret = delete_dir_index(root, inode_cache, rec, backref);
 			if (ret)
 				break;
+			repaired++;
+			list_del(&backref->list);
+			free(backref);
 		}
 
-		if (backref->found_dir_item && backref->found_dir_index) {
-			if (!backref->errors && backref->found_inode_ref) {
-				list_del(&backref->list);
-				free(backref);
+		if (!delete && !backref->found_dir_index &&
+		    backref->found_dir_item && backref->found_inode_ref) {
+			ret = add_missing_dir_index(root, inode_cache, rec,
+						    backref);
+			if (ret)
+				break;
+			repaired++;
+			if (backref->found_dir_item &&
+			    backref->found_dir_index &&
+			    backref->found_dir_index) {
+				if (!backref->errors &&
+				    backref->found_inode_ref) {
+					list_del(&backref->list);
+					free(backref);
+				}
 			}
 		}
-	}
 
-	return ret;
+	}
+	return ret ? ret : repaired;
 }
 
 static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
@@ -1651,7 +1715,9 @@ static int check_inode_recs(struct btrfs_root *root,
 	struct ptr_node *node;
 	struct inode_record *rec;
 	struct inode_backref *backref;
+	int stage = 0;
 	int ret;
+	int err = 0;
 	u64 error = 0;
 	u64 root_dirid = btrfs_root_dirid(&root->root_item);
 
@@ -1665,22 +1731,52 @@ static int check_inode_recs(struct btrfs_root *root,
 	 * We need to repair backrefs first because we could change some of the
 	 * errors in the inode recs.
 	 *
+	 * We also need to go through and delete invalid backrefs first and then
+	 * add the correct ones second.  We do this because we may get EEXIST
+	 * when adding back the correct index because we hadn't yet deleted the
+	 * invalid index.
+	 *
 	 * For example, if we were missing a dir index then the directories
 	 * isize would be wrong, so if we fixed the isize to what we thought it
 	 * would be and then fixed the backref we'd still have a invalid fs, so
 	 * we need to add back the dir index and then check to see if the isize
 	 * is still wrong.
 	 */
-	cache = search_cache_extent(inode_cache, 0);
-	while (repair && cache) {
-		node = container_of(cache, struct ptr_node, cache);
-		rec = node->data;
-		cache = next_cache_extent(cache);
+	while (stage < 3) {
+		stage++;
+		if (stage == 3 && !err)
+			break;
 
-		if (list_empty(&rec->backrefs))
-			continue;
-		repair_inode_backrefs(root, rec, inode_cache);
+		cache = search_cache_extent(inode_cache, 0);
+		while (repair && cache) {
+			node = container_of(cache, struct ptr_node, cache);
+			rec = node->data;
+			cache = next_cache_extent(cache);
+
+			/* Need to free everything up and rescan */
+			if (stage == 3) {
+				remove_cache_extent(inode_cache, &node->cache);
+				free(node);
+				free_inode_rec(rec);
+				continue;
+			}
+
+			if (list_empty(&rec->backrefs))
+				continue;
+
+			ret = repair_inode_backrefs(root, rec, inode_cache,
+						    stage == 1);
+			if (ret < 0) {
+				err = ret;
+				stage = 2;
+				break;
+			} if (ret > 0) {
+				err = -EAGAIN;
+			}
+		}
 	}
+	if (err)
+		return err;
 
 	rec = get_inode_rec(inode_cache, root_dirid, 0);
 	if (rec) {
@@ -2216,6 +2312,11 @@ again:
 				goto next;
 			}
 			ret = check_fs_root(tmp_root, root_cache, &wc);
+			if (ret == -EAGAIN) {
+				free_root_recs_tree(root_cache);
+				btrfs_release_path(&path);
+				goto again;
+			}
 			if (ret)
 				err = 1;
 		} else if (key.type == BTRFS_ROOT_REF_KEY ||
diff --git a/ctree.h b/ctree.h
index eaab667..89036de 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2360,6 +2360,15 @@ struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
 					     struct btrfs_path *path, u64 dir,
 					     const char *name, int name_len,
 					     int mod);
+struct btrfs_dir_item *btrfs_lookup_dir_index(struct btrfs_trans_handle *trans,
+					      struct btrfs_root *root,
+					      struct btrfs_path *path, u64 dir,
+					      const char *name, int name_len,
+					      u64 index, int mod);
+int btrfs_delete_one_dir_name(struct btrfs_trans_handle *trans,
+			      struct btrfs_root *root,
+			      struct btrfs_path *path,
+			      struct btrfs_dir_item *di);
 int btrfs_insert_xattr_item(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root, const char *name,
 			    u16 name_len, const void *data, u16 data_len,
diff --git a/dir-item.c b/dir-item.c
index 7b145ad..43ae364 100644
--- a/dir-item.c
+++ b/dir-item.c
@@ -16,6 +16,7 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#include <linux/limits.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "hash.h"
@@ -219,6 +220,98 @@ struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
 	return btrfs_match_dir_item_name(root, path, name, name_len);
 }
 
+struct btrfs_dir_item *btrfs_lookup_dir_index(struct btrfs_trans_handle *trans,
+					      struct btrfs_root *root,
+					      struct btrfs_path *path, u64 dir,
+					      const char *name, int name_len,
+					      u64 index, int mod)
+{
+	int ret;
+	struct btrfs_key key;
+	int ins_len = mod < 0 ? -1 : 0;
+	int cow = mod != 0;
+
+	key.objectid = dir;
+	key.type = BTRFS_DIR_INDEX_KEY;
+	key.offset = index;
+
+	ret = btrfs_search_slot(trans, root, &key, path, ins_len, cow);
+	if (ret < 0)
+		return ERR_PTR(ret);
+	if (ret > 0)
+		return ERR_PTR(-ENOENT);
+
+	return btrfs_match_dir_item_name(root, path, name, name_len);
+}
+
+/*
+ * given a pointer into a directory item, delete it.  This
+ * handles items that have more than one entry in them.
+ */
+int btrfs_delete_one_dir_name(struct btrfs_trans_handle *trans,
+			      struct btrfs_root *root,
+			      struct btrfs_path *path,
+			      struct btrfs_dir_item *di)
+{
+
+	struct extent_buffer *leaf;
+	u32 sub_item_len;
+	u32 item_len;
+	int ret = 0;
+
+	leaf = path->nodes[0];
+	sub_item_len = sizeof(*di) + btrfs_dir_name_len(leaf, di) +
+		btrfs_dir_data_len(leaf, di);
+	item_len = btrfs_item_size_nr(leaf, path->slots[0]);
+	if (sub_item_len == item_len) {
+		ret = btrfs_del_item(trans, root, path);
+	} else {
+		/* MARKER */
+		unsigned long ptr = (unsigned long)di;
+		unsigned long start;
+
+		start = btrfs_item_ptr_offset(leaf, path->slots[0]);
+		memmove_extent_buffer(leaf, ptr, ptr + sub_item_len,
+			item_len - (ptr + sub_item_len - start));
+		btrfs_truncate_item(trans, root, path, item_len - sub_item_len, 1);
+	}
+	return ret;
+}
+
+int verify_dir_item(struct btrfs_root *root,
+		    struct extent_buffer *leaf,
+		    struct btrfs_dir_item *dir_item)
+{
+	u16 namelen = BTRFS_NAME_LEN;
+	u8 type = btrfs_dir_type(leaf, dir_item);
+
+	if (type >= BTRFS_FT_MAX) {
+		fprintf(stderr, "invalid dir item type: %d",
+		       (int)type);
+		return 1;
+	}
+
+	if (type == BTRFS_FT_XATTR)
+		namelen = XATTR_NAME_MAX;
+
+	if (btrfs_dir_name_len(leaf, dir_item) > namelen) {
+		fprintf(stderr, "invalid dir item name len: %u",
+		       (unsigned)btrfs_dir_data_len(leaf, dir_item));
+		return 1;
+	}
+
+	/* BTRFS_MAX_XATTR_SIZE is the same for all dir items */
+	if ((btrfs_dir_data_len(leaf, dir_item) +
+	     btrfs_dir_name_len(leaf, dir_item)) > BTRFS_MAX_XATTR_SIZE(root)) {
+		fprintf(stderr, "invalid dir item name + data len: %u + %u",
+		       (unsigned)btrfs_dir_name_len(leaf, dir_item),
+		       (unsigned)btrfs_dir_data_len(leaf, dir_item));
+		return 1;
+	}
+
+	return 0;
+}
+
 static struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_root *root,
 			      struct btrfs_path *path,
 			      const char *name, int name_len)
@@ -233,10 +326,18 @@ static struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_root *root,
 	leaf = path->nodes[0];
 	dir_item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_dir_item);
 	total_len = btrfs_item_size_nr(leaf, path->slots[0]);
+	if (verify_dir_item(root, leaf, dir_item))
+		return NULL;
+
 	while(cur < total_len) {
 		this_len = sizeof(*dir_item) +
 			btrfs_dir_name_len(leaf, dir_item) +
 			btrfs_dir_data_len(leaf, dir_item);
+		if (this_len > (total_len - cur)) {
+			fprintf(stderr, "invalid dir item size\n");
+			return NULL;
+		}
+
 		name_ptr = (unsigned long)(dir_item + 1);
 
 		if (btrfs_dir_name_len(leaf, dir_item) == name_len &&
-- 
1.8.3.1

