Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19130 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750866AbaFEUPz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Jun 2014 16:15:55 -0400
Received: from pps.filterd (m0044012 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s55KBPrC003394
	for <linux-btrfs@vger.kernel.org>; Thu, 5 Jun 2014 13:15:54 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0a-00082601.pphosted.com with ESMTP id 1ma8fw3q69-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 05 Jun 2014 13:15:54 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: make fiemap not blow when you have lots of snapshots
Date: Thu, 5 Jun 2014 16:15:51 -0400
Message-ID: <1401999351-8281-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have been iterating all references for each extent we have in a file when we
do fiemap to see if it is shared.  This is fine when you have a few clones or a
few snapshots, but when you have 5k snapshots suddenly fiemap just sits there
and stares at you.  So add btrfs_check_shared which will use the backref walking
code but will short circuit as soon as it finds a root or inode that doesn't
match the one we currently have.  This makes fiemap on my testbox go from
looking at me blankly for a day to spitting out actual output in a reasonable
amount of time.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/backref.c   | 109 +++++++++++++++++++++++++++++++++++++++++++++------
 fs/btrfs/backref.h   |   3 ++
 fs/btrfs/extent_io.c |  44 ++++++++-------------
 3 files changed, 118 insertions(+), 38 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 84d0912..baacc41 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -25,6 +25,9 @@
 #include "delayed-ref.h"
 #include "locking.h"
 
+/* Just an arbitrary number so we can be sure this happened */
+#define BACKREF_FOUND_SHARED 6
+
 struct extent_inode_elem {
 	u64 inum;
 	u64 offset;
@@ -378,7 +381,8 @@ out:
 static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 				   struct btrfs_path *path, u64 time_seq,
 				   struct list_head *head,
-				   const u64 *extent_item_pos, u64 total_refs)
+				   const u64 *extent_item_pos, u64 total_refs,
+				   u64 root_objectid)
 {
 	int err;
 	int ret = 0;
@@ -403,6 +407,10 @@ static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 			continue;
 		if (ref->count == 0)
 			continue;
+		if (root_objectid && ref->root_id != root_objectid) {
+			ret = BACKREF_FOUND_SHARED;
+			goto out;
+		}
 		err = __resolve_indirect_ref(fs_info, path, time_seq, ref,
 					     parents, extent_item_pos,
 					     total_refs);
@@ -562,7 +570,8 @@ static void __merge_refs(struct list_head *head, int mode)
  * smaller or equal that seq to the list
  */
 static int __add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
-			      struct list_head *prefs, u64 *total_refs)
+			      struct list_head *prefs, u64 *total_refs,
+			      u64 inum)
 {
 	struct btrfs_delayed_extent_op *extent_op = head->extent_op;
 	struct rb_node *n = &head->node.rb_node;
@@ -626,6 +635,16 @@ static int __add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
 			key.objectid = ref->objectid;
 			key.type = BTRFS_EXTENT_DATA_KEY;
 			key.offset = ref->offset;
+
+			/*
+			 * Found a inum that doesn't match our known inum, we
+			 * know it's shared.
+			 */
+			if (inum && ref->objectid != inum) {
+				ret = BACKREF_FOUND_SHARED;
+				break;
+			}
+
 			ret = __add_prelim_ref(prefs, ref->root, &key, 0, 0,
 					       node->bytenr,
 					       node->ref_mod * sgn, GFP_ATOMIC);
@@ -660,7 +679,7 @@ static int __add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
 static int __add_inline_refs(struct btrfs_fs_info *fs_info,
 			     struct btrfs_path *path, u64 bytenr,
 			     int *info_level, struct list_head *prefs,
-			     u64 *total_refs)
+			     u64 *total_refs, u64 inum)
 {
 	int ret = 0;
 	int slot;
@@ -745,6 +764,12 @@ static int __add_inline_refs(struct btrfs_fs_info *fs_info,
 								      dref);
 			key.type = BTRFS_EXTENT_DATA_KEY;
 			key.offset = btrfs_extent_data_ref_offset(leaf, dref);
+
+			if (inum && key.objectid != inum) {
+				ret = BACKREF_FOUND_SHARED;
+				break;
+			}
+
 			root = btrfs_extent_data_ref_root(leaf, dref);
 			ret = __add_prelim_ref(prefs, root, &key, 0, 0,
 					       bytenr, count, GFP_NOFS);
@@ -766,7 +791,7 @@ static int __add_inline_refs(struct btrfs_fs_info *fs_info,
  */
 static int __add_keyed_refs(struct btrfs_fs_info *fs_info,
 			    struct btrfs_path *path, u64 bytenr,
-			    int info_level, struct list_head *prefs)
+			    int info_level, struct list_head *prefs, u64 inum)
 {
 	struct btrfs_root *extent_root = fs_info->extent_root;
 	int ret;
@@ -828,6 +853,12 @@ static int __add_keyed_refs(struct btrfs_fs_info *fs_info,
 								      dref);
 			key.type = BTRFS_EXTENT_DATA_KEY;
 			key.offset = btrfs_extent_data_ref_offset(leaf, dref);
+
+			if (inum && key.objectid != inum) {
+				ret = BACKREF_FOUND_SHARED;
+				break;
+			}
+
 			root = btrfs_extent_data_ref_root(leaf, dref);
 			ret = __add_prelim_ref(prefs, root, &key, 0, 0,
 					       bytenr, count, GFP_NOFS);
@@ -855,7 +886,8 @@ static int __add_keyed_refs(struct btrfs_fs_info *fs_info,
 static int find_parent_nodes(struct btrfs_trans_handle *trans,
 			     struct btrfs_fs_info *fs_info, u64 bytenr,
 			     u64 time_seq, struct ulist *refs,
-			     struct ulist *roots, const u64 *extent_item_pos)
+			     struct ulist *roots, const u64 *extent_item_pos,
+			     u64 root_objectid, u64 inum)
 {
 	struct btrfs_key key;
 	struct btrfs_path *path;
@@ -930,7 +962,8 @@ again:
 			}
 			spin_unlock(&delayed_refs->lock);
 			ret = __add_delayed_refs(head, time_seq,
-						 &prefs_delayed, &total_refs);
+						 &prefs_delayed, &total_refs,
+						 inum);
 			mutex_unlock(&head->mutex);
 			if (ret)
 				goto out;
@@ -952,11 +985,11 @@ again:
 		     key.type == BTRFS_METADATA_ITEM_KEY)) {
 			ret = __add_inline_refs(fs_info, path, bytenr,
 						&info_level, &prefs,
-						&total_refs);
+						&total_refs, inum);
 			if (ret)
 				goto out;
 			ret = __add_keyed_refs(fs_info, path, bytenr,
-					       info_level, &prefs);
+					       info_level, &prefs, inum);
 			if (ret)
 				goto out;
 		}
@@ -972,7 +1005,8 @@ again:
 	__merge_refs(&prefs, 1);
 
 	ret = __resolve_indirect_refs(fs_info, path, time_seq, &prefs,
-				      extent_item_pos, total_refs);
+				      extent_item_pos, total_refs,
+				      root_objectid);
 	if (ret)
 		goto out;
 
@@ -982,6 +1016,11 @@ again:
 		ref = list_first_entry(&prefs, struct __prelim_ref, list);
 		WARN_ON(ref->count < 0);
 		if (roots && ref->count && ref->root_id && ref->parent == 0) {
+			if (root_objectid && ref->root_id != root_objectid) {
+				ret = BACKREF_FOUND_SHARED;
+				goto out;
+			}
+
 			/* no parent == root of tree */
 			ret = ulist_add(roots, ref->root_id, 0, GFP_NOFS);
 			if (ret < 0)
@@ -1085,7 +1124,7 @@ static int btrfs_find_all_leafs(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 
 	ret = find_parent_nodes(trans, fs_info, bytenr,
-				time_seq, *leafs, NULL, extent_item_pos);
+				time_seq, *leafs, NULL, extent_item_pos, 0, 0);
 	if (ret < 0 && ret != -ENOENT) {
 		free_leaf_list(*leafs);
 		return ret;
@@ -1128,7 +1167,7 @@ static int __btrfs_find_all_roots(struct btrfs_trans_handle *trans,
 	ULIST_ITER_INIT(&uiter);
 	while (1) {
 		ret = find_parent_nodes(trans, fs_info, bytenr,
-					time_seq, tmp, *roots, NULL);
+					time_seq, tmp, *roots, NULL, 0, 0);
 		if (ret < 0 && ret != -ENOENT) {
 			ulist_free(tmp);
 			ulist_free(*roots);
@@ -1159,6 +1198,54 @@ int btrfs_find_all_roots(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+int btrfs_check_shared(struct btrfs_trans_handle *trans,
+		       struct btrfs_fs_info *fs_info, u64 root_objectid,
+		       u64 inum, u64 bytenr)
+{
+	struct ulist *tmp = NULL;
+	struct ulist *roots = NULL;
+	struct ulist_iterator uiter;
+	struct ulist_node *node;
+	struct seq_list elem = {};
+	int ret = 0;
+
+	tmp = ulist_alloc(GFP_NOFS);
+	roots = ulist_alloc(GFP_NOFS);
+	if (!tmp || !roots) {
+		ulist_free(tmp);
+		ulist_free(roots);
+		return -ENOMEM;
+	}
+
+	if (trans)
+		btrfs_get_tree_mod_seq(fs_info, &elem);
+	else
+		down_read(&fs_info->commit_root_sem);
+	ULIST_ITER_INIT(&uiter);
+	while (1) {
+		ret = find_parent_nodes(trans, fs_info, bytenr, elem.seq, tmp,
+					roots, NULL, root_objectid, inum);
+		if (ret == BACKREF_FOUND_SHARED) {
+			ret = 1;
+			break;
+		}
+		if (ret < 0 && ret != -ENOENT)
+			break;
+		node = ulist_next(tmp, &uiter);
+		if (!node)
+			break;
+		bytenr = node->val;
+		cond_resched();
+	}
+	if (trans)
+		btrfs_put_tree_mod_seq(fs_info, &elem);
+	else
+		up_read(&fs_info->commit_root_sem);
+	ulist_free(tmp);
+	ulist_free(roots);
+	return ret;
+}
+
 /*
  * this makes the path point to (inum INODE_ITEM ioff)
  */
diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
index 94e9442..71fef59 100644
--- a/fs/btrfs/backref.h
+++ b/fs/btrfs/backref.h
@@ -71,6 +71,9 @@ int btrfs_find_one_extref(struct btrfs_root *root, u64 inode_objectid,
 			  u64 start_off, struct btrfs_path *path,
 			  struct btrfs_inode_extref **ret_extref,
 			  u64 *found_off);
+int btrfs_check_shared(struct btrfs_trans_handle *trans,
+		       struct btrfs_fs_info *fs_info, u64 root_objectid,
+		       u64 inum, u64 bytenr);
 
 int __init btrfs_prelim_ref_init(void);
 void btrfs_prelim_ref_exit(void);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8285ed0..d5fb685 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4113,19 +4113,6 @@ static struct extent_map *get_extent_skip_holes(struct inode *inode,
 	return NULL;
 }
 
-static noinline int count_ext_ref(u64 inum, u64 offset, u64 root_id, void *ctx)
-{
-	unsigned long cnt = *((unsigned long *)ctx);
-
-	cnt++;
-	*((unsigned long *)ctx) = cnt;
-
-	/* Now we're sure that the extent is shared. */
-	if (cnt > 1)
-		return 1;
-	return 0;
-}
-
 int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		__u64 start, __u64 len, get_extent_t *get_extent)
 {
@@ -4142,6 +4129,7 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	struct extent_map *em = NULL;
 	struct extent_state *cached_state = NULL;
 	struct btrfs_path *path;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int end = 0;
 	u64 em_start = 0;
 	u64 em_len = 0;
@@ -4155,15 +4143,15 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		return -ENOMEM;
 	path->leave_spinning = 1;
 
-	start = ALIGN(start, BTRFS_I(inode)->root->sectorsize);
-	len = ALIGN(len, BTRFS_I(inode)->root->sectorsize);
+	start = ALIGN(start, root->sectorsize);
+	len = ALIGN(len, root->sectorsize);
 
 	/*
 	 * lookup the last file extent.  We're not using i_size here
 	 * because there might be preallocation past i_size
 	 */
-	ret = btrfs_lookup_file_extent(NULL, BTRFS_I(inode)->root,
-				       path, btrfs_ino(inode), -1, 0);
+	ret = btrfs_lookup_file_extent(NULL, root, path, btrfs_ino(inode), -1,
+				       0);
 	if (ret < 0) {
 		btrfs_free_path(path);
 		return ret;
@@ -4256,25 +4244,27 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		} else if (em->block_start == EXTENT_MAP_DELALLOC) {
 			flags |= (FIEMAP_EXTENT_DELALLOC |
 				  FIEMAP_EXTENT_UNKNOWN);
-		} else {
-			unsigned long ref_cnt = 0;
+		} else if (fieinfo->fi_extents_max) {
+			u64 bytenr = em->block_start -
+				(em->start - em->orig_start);
 
 			disko = em->block_start + offset_in_extent;
 
 			/*
 			 * As btrfs supports shared space, this information
 			 * can be exported to userspace tools via
-			 * flag FIEMAP_EXTENT_SHARED.
+			 * flag FIEMAP_EXTENT_SHARED.  If fi_extents_max == 0
+			 * then we're just getting a count and we can skip the
+			 * lookup stuff.
 			 */
-			ret = iterate_inodes_from_logical(
-					em->block_start,
-					BTRFS_I(inode)->root->fs_info,
-					path, count_ext_ref, &ref_cnt);
-			if (ret < 0 && ret != -ENOENT)
+			ret = btrfs_check_shared(NULL, root->fs_info,
+						 root->objectid,
+						 btrfs_ino(inode), bytenr);
+			if (ret < 0)
 				goto out_free;
-
-			if (ref_cnt > 1)
+			if (ret)
 				flags |= FIEMAP_EXTENT_SHARED;
+			ret = 0;
 		}
 		if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags))
 			flags |= FIEMAP_EXTENT_ENCODED;
-- 
1.8.3.1

