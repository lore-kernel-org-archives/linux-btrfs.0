Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44907 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752824AbdGYUvC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Jul 2017 16:51:02 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 127F9AEC8
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Jul 2017 20:51:01 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 4/7] btrfs-progs: backref: push state tracking into a helper structure
Date: Tue, 25 Jul 2017 16:51:35 -0400
Message-Id: <20170725205138.28376-4-jeffm@suse.com>
In-Reply-To: <20170725205138.28376-1-jeffm@suse.com>
References: <20170725205138.28376-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

Eventually, we'll have several lists and trees, as well as some statistics.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 backref.c | 75 ++++++++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 45 insertions(+), 30 deletions(-)

diff --git a/backref.c b/backref.c
index e1f41e1..ac1b506 100644
--- a/backref.c
+++ b/backref.c
@@ -130,6 +130,15 @@ struct __prelim_ref {
 	u64 wanted_disk_byte;
 };
 
+struct pref_state {
+	struct list_head pending;
+};
+
+static void init_pref_state(struct pref_state *prefstate)
+{
+	INIT_LIST_HEAD(&prefstate->pending);
+}
+
 /*
  * the rules for all callers of this function are:
  * - obtaining the parent is the goal
@@ -169,11 +178,12 @@ struct __prelim_ref {
  * block might help in merging entries to gain some speed.
  */
 
-static int __add_prelim_ref(struct list_head *head, u64 root_id,
+static int __add_prelim_ref(struct pref_state *prefstate, u64 root_id,
 			    struct btrfs_key *key, int level,
 			    u64 parent, u64 wanted_disk_byte, int count,
 			    gfp_t gfp_mask)
 {
+	struct list_head *head = &prefstate->pending;
 	struct __prelim_ref *ref;
 
 	if (root_id == BTRFS_DATA_RELOC_TREE_OBJECTID)
@@ -345,10 +355,11 @@ out:
  * resolve all indirect backrefs from the list
  */
 static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
+				   struct pref_state *prefstate,
 				   struct btrfs_path *path, u64 time_seq,
-				   struct list_head *head,
 				   const u64 *extent_item_pos, u64 total_refs)
 {
+	struct list_head *head = &prefstate->pending;
 	int err;
 	int ret = 0;
 	struct __prelim_ref *ref;
@@ -436,8 +447,9 @@ static inline int ref_for_same_block(struct __prelim_ref *ref1,
  * read tree blocks and add keys where required.
  */
 static int __add_missing_keys(struct btrfs_fs_info *fs_info,
-			      struct list_head *head)
+			      struct pref_state *prefstate)
 {
+	struct list_head *head = &prefstate->pending;
 	struct list_head *pos;
 	struct extent_buffer *eb;
 
@@ -475,8 +487,9 @@ static int __add_missing_keys(struct btrfs_fs_info *fs_info,
  *           having a parent).
  * mode = 2: merge identical parents
  */
-static void __merge_refs(struct list_head *head, int mode)
+static void __merge_refs(struct pref_state *prefstate, int mode)
 {
+	struct list_head *head = &prefstate->pending;
 	struct list_head *pos1;
 
 	list_for_each(pos1, head) {
@@ -527,9 +540,9 @@ static void __merge_refs(struct list_head *head, int mode)
  * add all inline backrefs for bytenr to the list
  */
 static int __add_inline_refs(struct btrfs_fs_info *fs_info,
+			     struct pref_state *prefstate,
 			     struct btrfs_path *path, u64 bytenr,
-			     int *info_level, struct list_head *prefs,
-			     u64 *total_refs)
+			     int *info_level, u64 *total_refs)
 {
 	int ret = 0;
 	int slot;
@@ -541,7 +554,6 @@ static int __add_inline_refs(struct btrfs_fs_info *fs_info,
 	struct btrfs_extent_item *ei;
 	u64 flags;
 	u64 item_size;
-
 	/*
 	 * enumerate all inline refs
 	 */
@@ -584,7 +596,7 @@ static int __add_inline_refs(struct btrfs_fs_info *fs_info,
 
 		switch (type) {
 		case BTRFS_SHARED_BLOCK_REF_KEY:
-			ret = __add_prelim_ref(prefs, 0, NULL,
+			ret = __add_prelim_ref(prefstate, 0, NULL,
 						*info_level + 1, offset,
 						bytenr, 1, GFP_NOFS);
 			break;
@@ -594,12 +606,12 @@ static int __add_inline_refs(struct btrfs_fs_info *fs_info,
 
 			sdref = (struct btrfs_shared_data_ref *)(iref + 1);
 			count = btrfs_shared_data_ref_count(leaf, sdref);
-			ret = __add_prelim_ref(prefs, 0, NULL, 0, offset,
+			ret = __add_prelim_ref(prefstate, 0, NULL, 0, offset,
 					       bytenr, count, GFP_NOFS);
 			break;
 		}
 		case BTRFS_TREE_BLOCK_REF_KEY:
-			ret = __add_prelim_ref(prefs, offset, NULL,
+			ret = __add_prelim_ref(prefstate, offset, NULL,
 					       *info_level + 1, 0,
 					       bytenr, 1, GFP_NOFS);
 			break;
@@ -615,7 +627,7 @@ static int __add_inline_refs(struct btrfs_fs_info *fs_info,
 			key.type = BTRFS_EXTENT_DATA_KEY;
 			key.offset = btrfs_extent_data_ref_offset(leaf, dref);
 			root = btrfs_extent_data_ref_root(leaf, dref);
-			ret = __add_prelim_ref(prefs, root, &key, 0, 0,
+			ret = __add_prelim_ref(prefstate, root, &key, 0, 0,
 					       bytenr, count, GFP_NOFS);
 			break;
 		}
@@ -634,8 +646,9 @@ static int __add_inline_refs(struct btrfs_fs_info *fs_info,
  * add all non-inline backrefs for bytenr to the list
  */
 static int __add_keyed_refs(struct btrfs_fs_info *fs_info,
+			    struct pref_state *prefstate,
 			    struct btrfs_path *path, u64 bytenr,
-			    int info_level, struct list_head *prefs)
+			    int info_level)
 {
 	struct btrfs_root *extent_root = fs_info->extent_root;
 	int ret;
@@ -665,7 +678,7 @@ static int __add_keyed_refs(struct btrfs_fs_info *fs_info,
 
 		switch (key.type) {
 		case BTRFS_SHARED_BLOCK_REF_KEY:
-			ret = __add_prelim_ref(prefs, 0, NULL,
+			ret = __add_prelim_ref(prefstate, 0, NULL,
 						info_level + 1, key.offset,
 						bytenr, 1, GFP_NOFS);
 			break;
@@ -676,12 +689,12 @@ static int __add_keyed_refs(struct btrfs_fs_info *fs_info,
 			sdref = btrfs_item_ptr(leaf, slot,
 					      struct btrfs_shared_data_ref);
 			count = btrfs_shared_data_ref_count(leaf, sdref);
-			ret = __add_prelim_ref(prefs, 0, NULL, 0, key.offset,
+			ret = __add_prelim_ref(prefstate, 0, NULL, 0, key.offset,
 						bytenr, count, GFP_NOFS);
 			break;
 		}
 		case BTRFS_TREE_BLOCK_REF_KEY:
-			ret = __add_prelim_ref(prefs, key.offset, NULL,
+			ret = __add_prelim_ref(prefstate, key.offset, NULL,
 					       info_level + 1, 0,
 					       bytenr, 1, GFP_NOFS);
 			break;
@@ -698,7 +711,7 @@ static int __add_keyed_refs(struct btrfs_fs_info *fs_info,
 			key.type = BTRFS_EXTENT_DATA_KEY;
 			key.offset = btrfs_extent_data_ref_offset(leaf, dref);
 			root = btrfs_extent_data_ref_root(leaf, dref);
-			ret = __add_prelim_ref(prefs, root, &key, 0, 0,
+			ret = __add_prelim_ref(prefstate, root, &key, 0, 0,
 					       bytenr, count, GFP_NOFS);
 			break;
 		}
@@ -730,12 +743,12 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 	struct btrfs_path *path;
 	int info_level = 0;
 	int ret;
-	struct list_head prefs;
+	struct pref_state prefstate;
 	struct __prelim_ref *ref;
 	struct extent_inode_elem *eie = NULL;
 	u64 total_refs = 0;
 
-	INIT_LIST_HEAD(&prefs);
+	init_pref_state(&prefstate);
 
 	key.objectid = bytenr;
 	key.offset = (u64)-1;
@@ -764,34 +777,35 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 		if (key.objectid == bytenr &&
 		    (key.type == BTRFS_EXTENT_ITEM_KEY ||
 		     key.type == BTRFS_METADATA_ITEM_KEY)) {
-			ret = __add_inline_refs(fs_info, path, bytenr,
-						&info_level, &prefs,
+			ret = __add_inline_refs(fs_info, &prefstate, path,
+						bytenr, &info_level,
 						&total_refs);
 			if (ret)
 				goto out;
-			ret = __add_keyed_refs(fs_info, path, bytenr,
-					       info_level, &prefs);
+			ret = __add_keyed_refs(fs_info, &prefstate, path,
+					       bytenr, info_level);
 			if (ret)
 				goto out;
 		}
 	}
 	btrfs_release_path(path);
 
-	ret = __add_missing_keys(fs_info, &prefs);
+	ret = __add_missing_keys(fs_info, &prefstate);
 	if (ret)
 		goto out;
 
-	__merge_refs(&prefs, 1);
+	__merge_refs(&prefstate, 1);
 
-	ret = __resolve_indirect_refs(fs_info, path, time_seq, &prefs,
+	ret = __resolve_indirect_refs(fs_info, &prefstate, path, time_seq,
 				      extent_item_pos, total_refs);
 	if (ret)
 		goto out;
 
-	__merge_refs(&prefs, 2);
+	__merge_refs(&prefstate, 2);
 
-	while (!list_empty(&prefs)) {
-		ref = list_first_entry(&prefs, struct __prelim_ref, list);
+	while (!list_empty(&prefstate.pending)) {
+		ref = list_first_entry(&prefstate.pending,
+				       struct __prelim_ref, list);
 		WARN_ON(ref->count < 0);
 		if (roots && ref->count && ref->root_id && ref->parent == 0) {
 			/* no parent == root of tree */
@@ -842,8 +856,9 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 
 out:
 	btrfs_free_path(path);
-	while (!list_empty(&prefs)) {
-		ref = list_first_entry(&prefs, struct __prelim_ref, list);
+	while (!list_empty(&prefstate.pending)) {
+		ref = list_first_entry(&prefstate.pending,
+				       struct __prelim_ref, list);
 		list_del(&ref->list);
 		kfree(ref);
 	}
-- 
2.11.0

