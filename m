Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45355 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750717AbaCSRfT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Mar 2014 13:35:19 -0400
Received: from pps.filterd (m0004003 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s2JHYHQ6004794
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Mar 2014 10:35:18 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0b-00082601.pphosted.com with ESMTP id 1jq1fa2kdt-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Mar 2014 10:35:17 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: take into account total references when doing backref lookup V2
Date: Wed, 19 Mar 2014 13:35:14 -0400
Message-ID: <1395250514-28911-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I added an optimization for large files where we would stop searching for
backrefs once we had looked at the number of references we currently had for
this extent.  This works great most of the time, but for snapshots that point to
this extent and has changes in the original root this assumption falls on it
face.  So keep track of any delayed ref mods made and add in the actual ref
count as reported by the extent item and use that to limit how far down an inode
we'll search for extents.  Thanks,

Reportedy-by: Hugo Mills <hugo@carfax.org.uk>
Signed-off-by: Josef Bacik <jbacik@fb.com>
---
V1->V2: Just use the extent ref count and any delayed ref counts, this will work
out right, whereas the shared thing doesn't work out in some cases.

 fs/btrfs/backref.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 0be0e94..10db21f 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -220,7 +220,8 @@ static int __add_prelim_ref(struct list_head *head, u64 root_id,
 
 static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
 			   struct ulist *parents, struct __prelim_ref *ref,
-			   int level, u64 time_seq, const u64 *extent_item_pos)
+			   int level, u64 time_seq, const u64 *extent_item_pos,
+			   u64 total_refs)
 {
 	int ret = 0;
 	int slot;
@@ -249,7 +250,7 @@ static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
 	if (path->slots[0] >= btrfs_header_nritems(path->nodes[0]))
 		ret = btrfs_next_old_leaf(root, path, time_seq);
 
-	while (!ret && count < ref->count) {
+	while (!ret && count < total_refs) {
 		eb = path->nodes[0];
 		slot = path->slots[0];
 
@@ -306,7 +307,7 @@ static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
 				  struct btrfs_path *path, u64 time_seq,
 				  struct __prelim_ref *ref,
 				  struct ulist *parents,
-				  const u64 *extent_item_pos)
+				  const u64 *extent_item_pos, u64 total_refs)
 {
 	struct btrfs_root *root;
 	struct btrfs_key root_key;
@@ -364,7 +365,7 @@ static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
 	}
 
 	ret = add_all_parents(root, path, parents, ref, level, time_seq,
-			      extent_item_pos);
+			      extent_item_pos, total_refs);
 out:
 	path->lowest_level = 0;
 	btrfs_release_path(path);
@@ -377,7 +378,7 @@ out:
 static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 				   struct btrfs_path *path, u64 time_seq,
 				   struct list_head *head,
-				   const u64 *extent_item_pos)
+				   const u64 *extent_item_pos, u64 total_refs)
 {
 	int err;
 	int ret = 0;
@@ -403,7 +404,8 @@ static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 		if (ref->count == 0)
 			continue;
 		err = __resolve_indirect_ref(fs_info, path, time_seq, ref,
-					     parents, extent_item_pos);
+					     parents, extent_item_pos,
+					     total_refs);
 		/*
 		 * we can only tolerate ENOENT,otherwise,we should catch error
 		 * and return directly.
@@ -560,7 +562,7 @@ static void __merge_refs(struct list_head *head, int mode)
  * smaller or equal that seq to the list
  */
 static int __add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
-			      struct list_head *prefs)
+			      struct list_head *prefs, u64 *total_refs)
 {
 	struct btrfs_delayed_extent_op *extent_op = head->extent_op;
 	struct rb_node *n = &head->node.rb_node;
@@ -596,6 +598,7 @@ static int __add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
 		default:
 			BUG_ON(1);
 		}
+		*total_refs += (node->ref_mod * sgn);
 		switch (node->type) {
 		case BTRFS_TREE_BLOCK_REF_KEY: {
 			struct btrfs_delayed_tree_ref *ref;
@@ -656,7 +659,8 @@ static int __add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
  */
 static int __add_inline_refs(struct btrfs_fs_info *fs_info,
 			     struct btrfs_path *path, u64 bytenr,
-			     int *info_level, struct list_head *prefs)
+			     int *info_level, struct list_head *prefs,
+			     u64 *total_refs)
 {
 	int ret = 0;
 	int slot;
@@ -680,6 +684,7 @@ static int __add_inline_refs(struct btrfs_fs_info *fs_info,
 
 	ei = btrfs_item_ptr(leaf, slot, struct btrfs_extent_item);
 	flags = btrfs_extent_flags(leaf, ei);
+	*total_refs += btrfs_extent_refs(leaf, ei);
 	btrfs_item_key_to_cpu(leaf, &found_key, slot);
 
 	ptr = (unsigned long)(ei + 1);
@@ -862,6 +867,7 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 	struct list_head prefs;
 	struct __prelim_ref *ref;
 	struct extent_inode_elem *eie = NULL;
+	u64 total_refs = 0;
 
 	INIT_LIST_HEAD(&prefs);
 	INIT_LIST_HEAD(&prefs_delayed);
@@ -920,7 +926,7 @@ again:
 			}
 			spin_unlock(&delayed_refs->lock);
 			ret = __add_delayed_refs(head, time_seq,
-						 &prefs_delayed);
+						 &prefs_delayed, &total_refs);
 			mutex_unlock(&head->mutex);
 			if (ret)
 				goto out;
@@ -941,7 +947,8 @@ again:
 		    (key.type == BTRFS_EXTENT_ITEM_KEY ||
 		     key.type == BTRFS_METADATA_ITEM_KEY)) {
 			ret = __add_inline_refs(fs_info, path, bytenr,
-						&info_level, &prefs);
+						&info_level, &prefs,
+						&total_refs);
 			if (ret)
 				goto out;
 			ret = __add_keyed_refs(fs_info, path, bytenr,
@@ -961,7 +968,7 @@ again:
 	__merge_refs(&prefs, 1);
 
 	ret = __resolve_indirect_refs(fs_info, path, time_seq, &prefs,
-				      extent_item_pos);
+				      extent_item_pos, total_refs);
 	if (ret)
 		goto out;
 
-- 
1.8.3.1

