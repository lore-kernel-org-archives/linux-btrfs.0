Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52058 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751790AbdF2D4V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Jun 2017 23:56:21 -0400
From: Edmund Nadolski <enadolski@suse.com>
To: enadolski@suse.com, jeffm@suse.com, linux-btrfs@vger.kernel.org,
        lufq.fnst@cn.fujitsu.com
Subject: [PATCH v2 10/13] btrfs: backref, add tracepoints for prelim_ref insertion and merging
Date: Wed, 28 Jun 2017 21:57:02 -0600
Message-Id: <20170629035705.1589-11-enadolski@suse.com>
In-Reply-To: <20170629035705.1589-1-enadolski@suse.com>
References: <20170629035705.1589-1-enadolski@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

This patch adds a tracepoint event for prelim_ref insertion and
merging.  For each, the ref being inserted or merged and the count
of tree nodes is issued.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/backref.c           | 117 ++++++++++++++++++++++---------------------
 fs/btrfs/backref.h           |  12 +++++
 fs/btrfs/super.c             |   1 +
 include/trace/events/btrfs.h |  58 +++++++++++++++++++++
 4 files changed, 131 insertions(+), 57 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 5e5f8d7..54180f4 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -26,6 +26,8 @@
 #include "delayed-ref.h"
 #include "locking.h"
 
+#include <trace/events/btrfs.h>
+
 /* Just an arbitrary number so we can be sure this happened */
 #define BACKREF_FOUND_SHARED 6
 
@@ -120,20 +122,6 @@ static int find_extent_in_eb(const struct extent_buffer *eb,
 	return 0;
 }
 
-/*
- * this structure records all encountered refs on the way up to the root
- */
-struct prelim_ref {
-	struct rb_node rbnode;
-	u64 root_id;
-	struct btrfs_key key_for_search;
-	int level;
-	int count;
-	struct extent_inode_elem *inode_list;
-	u64 parent;
-	u64 wanted_disk_byte;
-};
-
 struct preftree {
 	struct rb_root root;
 	unsigned int count;
@@ -212,7 +200,8 @@ static int prelim_ref_compare(struct prelim_ref *ref1,
  *
  * Callers should assumed that newref has been freed after calling.
  */
-static void prelim_ref_insert(struct preftree *preftree,
+static void prelim_ref_insert(const struct btrfs_fs_info *fs_info,
+			      struct preftree *preftree,
 			      struct prelim_ref *newref)
 {
 	struct rb_root *root;
@@ -243,6 +232,8 @@ static void prelim_ref_insert(struct preftree *preftree,
 				ref->inode_list = newref->inode_list;
 			else
 				eie->next = newref->inode_list;
+			trace_btrfs_prelim_ref_merge(fs_info, ref, newref,
+						     preftree->count);
 			ref->count += newref->count;
 			free_pref(newref);
 			return;
@@ -250,6 +241,7 @@ static void prelim_ref_insert(struct preftree *preftree,
 	}
 
 	preftree->count++;
+	trace_btrfs_prelim_ref_insert(fs_info, newref, NULL, preftree->count);
 	rb_link_node(&newref->rbnode, parent, p);
 	rb_insert_color(&newref->rbnode, root);
 }
@@ -308,7 +300,8 @@ static void prelim_release(struct preftree *preftree)
  * additional information that's available but not required to find the parent
  * block might help in merging entries to gain some speed.
  */
-static int add_prelim_ref(struct preftree *preftree, u64 root_id,
+static int add_prelim_ref(const struct btrfs_fs_info *fs_info,
+			  struct preftree *preftree, u64 root_id,
 			  const struct btrfs_key *key, int level, u64 parent,
 			  u64 wanted_disk_byte, int count, gfp_t gfp_mask)
 {
@@ -355,28 +348,30 @@ static int add_prelim_ref(struct preftree *preftree, u64 root_id,
 	ref->count = count;
 	ref->parent = parent;
 	ref->wanted_disk_byte = wanted_disk_byte;
-	prelim_ref_insert(preftree, ref);
+	prelim_ref_insert(fs_info, preftree, ref);
 
 	return 0;
 }
 
 /* direct refs use root == 0, key == NULL */
-static int add_direct_ref(struct preftrees *preftrees, int level, u64 parent,
+static int add_direct_ref(const struct btrfs_fs_info *fs_info,
+			  struct preftrees *preftrees, int level, u64 parent,
 			  u64 wanted_disk_byte, int count, gfp_t gfp_mask)
 {
-	return add_prelim_ref(&preftrees->direct, 0, NULL, level, parent,
-			      wanted_disk_byte, count, gfp_mask);
+	return add_prelim_ref(fs_info, &preftrees->direct, 0, NULL, level,
+			      parent, wanted_disk_byte, count, gfp_mask);
 }
 
 /* indirect refs use parent == 0 */
-static int add_indirect_ref(struct preftrees *preftrees, u64 root_id,
+static int add_indirect_ref(const struct btrfs_fs_info *fs_info,
+			    struct preftrees *preftrees, u64 root_id,
 			    const struct btrfs_key *key, int level,
 			    u64 wanted_disk_byte, int count, gfp_t gfp_mask)
 {
 	struct preftree *tree = &preftrees->indirect;
 	if (!key)
 		tree = &preftrees->indirect_missing_keys;
-	return add_prelim_ref(tree, root_id, key, level, 0,
+	return add_prelim_ref(fs_info, tree, root_id, key, level, 0,
 			      wanted_disk_byte, count, gfp_mask);
 }
 
@@ -654,11 +649,11 @@ static int resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 			memcpy(new_ref, ref, sizeof(*ref));
 			new_ref->parent = node->val;
 			new_ref->inode_list = unode_aux_to_inode_list(node);
-			prelim_ref_insert(&preftrees->direct, new_ref);
+			prelim_ref_insert(fs_info, &preftrees->direct, new_ref);
 		}
 
 		/* Now it's a direct ref, put it in the the direct tree */
-		prelim_ref_insert(&preftrees->direct, ref);
+		prelim_ref_insert(fs_info, &preftrees->direct, ref);
 
 		ulist_reinit(parents);
 	}
@@ -702,7 +697,7 @@ static int add_missing_keys(struct btrfs_fs_info *fs_info,
 			btrfs_node_key_to_cpu(eb, &ref->key_for_search, 0);
 		btrfs_tree_read_unlock(eb);
 		free_extent_buffer(eb);
-		prelim_ref_insert(&preftrees->indirect, ref);
+		prelim_ref_insert(fs_info, &preftrees->indirect, ref);
 	}
 	return 0;
 }
@@ -711,7 +706,8 @@ static int add_missing_keys(struct btrfs_fs_info *fs_info,
  * add all currently queued delayed refs from this head whose seq nr is
  * smaller or equal that seq to the list
  */
-static int add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
+static int add_delayed_refs(const struct btrfs_fs_info *fs_info,
+			    struct btrfs_delayed_ref_head *head, u64 seq,
 			    struct preftrees *preftrees, u64 *total_refs,
 			    u64 inum)
 {
@@ -754,8 +750,9 @@ static int add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
 			struct btrfs_delayed_tree_ref *ref;
 
 			ref = btrfs_delayed_node_to_tree_ref(node);
-			ret = add_indirect_ref(preftrees, ref->root, &tmp_op_key,
-					       ref->level + 1, node->bytenr,
+			ret = add_indirect_ref(fs_info, preftrees, ref->root,
+					       &tmp_op_key, ref->level + 1,
+					       node->bytenr,
 					       node->ref_mod * sgn,
 					       GFP_ATOMIC);
 			break;
@@ -766,9 +763,9 @@ static int add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
 
 			ref = btrfs_delayed_node_to_tree_ref(node);
 
-			ret = add_direct_ref(preftrees, ref->level + 1,
-					     ref->parent, node->bytenr,
-					     node->ref_mod * sgn,
+			ret = add_direct_ref(fs_info, preftrees,
+					     ref->level + 1, ref->parent,
+					     node->bytenr, node->ref_mod * sgn,
 					     GFP_ATOMIC);
 			break;
 		}
@@ -790,8 +787,8 @@ static int add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
 				break;
 			}
 
-			ret = add_indirect_ref(preftrees, ref->root, &key, 0,
-					       node->bytenr,
+			ret = add_indirect_ref(fs_info, preftrees, ref->root,
+					       &key, 0, node->bytenr,
 					       node->ref_mod * sgn,
 					       GFP_ATOMIC);
 			break;
@@ -802,8 +799,8 @@ static int add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
 
 			ref = btrfs_delayed_node_to_data_ref(node);
 
-			ret = add_direct_ref(preftrees, 0, ref->parent,
-					     node->bytenr,
+			ret = add_direct_ref(fs_info, preftrees, 0,
+					     ref->parent, node->bytenr,
 					     node->ref_mod * sgn,
 					     GFP_ATOMIC);
 			break;
@@ -821,7 +818,8 @@ static int add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
 /*
  * add all inline backrefs for bytenr to the list
  */
-static int add_inline_refs(struct btrfs_path *path, u64 bytenr,
+static int add_inline_refs(const struct btrfs_fs_info *fs_info,
+			   struct btrfs_path *path, u64 bytenr,
 			   int *info_level, struct preftrees *preftrees,
 			   u64 *total_refs, u64 inum)
 {
@@ -878,7 +876,8 @@ static int add_inline_refs(struct btrfs_path *path, u64 bytenr,
 
 		switch (type) {
 		case BTRFS_SHARED_BLOCK_REF_KEY:
-			ret = add_direct_ref(preftrees, *info_level + 1, offset,
+			ret = add_direct_ref(fs_info, preftrees,
+					     *info_level + 1, offset,
 					     bytenr, 1, GFP_NOFS);
 			break;
 		case BTRFS_SHARED_DATA_REF_KEY: {
@@ -888,14 +887,14 @@ static int add_inline_refs(struct btrfs_path *path, u64 bytenr,
 			sdref = (struct btrfs_shared_data_ref *)(iref + 1);
 			count = btrfs_shared_data_ref_count(leaf, sdref);
 
-			ret = add_direct_ref(preftrees, 0, offset,
+			ret = add_direct_ref(fs_info, preftrees, 0, offset,
 					     bytenr, count, GFP_NOFS);
 			break;
 		}
 		case BTRFS_TREE_BLOCK_REF_KEY:
-			ret = add_indirect_ref(preftrees, offset, NULL,
-					       *info_level + 1, bytenr, 1,
-					       GFP_NOFS);
+			ret = add_indirect_ref(fs_info, preftrees, offset,
+					       NULL, *info_level + 1,
+					       bytenr, 1, GFP_NOFS);
 			break;
 		case BTRFS_EXTENT_DATA_REF_KEY: {
 			struct btrfs_extent_data_ref *dref;
@@ -916,8 +915,9 @@ static int add_inline_refs(struct btrfs_path *path, u64 bytenr,
 
 			root = btrfs_extent_data_ref_root(leaf, dref);
 
-			ret = add_indirect_ref(preftrees, root, &key, 0, bytenr,
-					       count, GFP_NOFS);
+			ret = add_indirect_ref(fs_info, preftrees, root,
+					       &key, 0, bytenr, count,
+					       GFP_NOFS);
 			break;
 		}
 		default:
@@ -968,9 +968,9 @@ static int add_keyed_refs(struct btrfs_fs_info *fs_info,
 		switch (key.type) {
 		case BTRFS_SHARED_BLOCK_REF_KEY:
 			/* SHARED DIRECT METADATA backref */
-			ret = add_direct_ref(preftrees, info_level + 1,
-					     key.offset, bytenr, 1,
-					     GFP_NOFS);
+			ret = add_direct_ref(fs_info, preftrees,
+					     info_level + 1, key.offset,
+					     bytenr, 1, GFP_NOFS);
 			break;
 		case BTRFS_SHARED_DATA_REF_KEY: {
 			/* SHARED DIRECT FULL backref */
@@ -980,15 +980,16 @@ static int add_keyed_refs(struct btrfs_fs_info *fs_info,
 			sdref = btrfs_item_ptr(leaf, slot,
 					      struct btrfs_shared_data_ref);
 			count = btrfs_shared_data_ref_count(leaf, sdref);
-			ret = add_direct_ref(preftrees, 0, key.offset, bytenr,
-					     count, GFP_NOFS);
+			ret = add_direct_ref(fs_info, preftrees, 0,
+					     key.offset, bytenr, count,
+					     GFP_NOFS);
 			break;
 		}
 		case BTRFS_TREE_BLOCK_REF_KEY:
 			/* NORMAL INDIRECT METADATA backref */
-			ret = add_indirect_ref(preftrees, key.offset, NULL,
-					       info_level + 1, bytenr, 1,
-					       GFP_NOFS);
+			ret = add_indirect_ref(fs_info, preftrees, key.offset,
+					       NULL, info_level + 1, bytenr,
+					       1, GFP_NOFS);
 			break;
 		case BTRFS_EXTENT_DATA_REF_KEY: {
 			/* NORMAL INDIRECT DATA backref */
@@ -1010,8 +1011,9 @@ static int add_keyed_refs(struct btrfs_fs_info *fs_info,
 			}
 
 			root = btrfs_extent_data_ref_root(leaf, dref);
-			ret = add_indirect_ref(preftrees, root, &key, 0, bytenr,
-					       count, GFP_NOFS);
+			ret = add_indirect_ref(fs_info, preftrees, root,
+					       &key, 0, bytenr, count,
+					       GFP_NOFS);
 			break;
 		}
 		default:
@@ -1124,8 +1126,8 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 				goto again;
 			}
 			spin_unlock(&delayed_refs->lock);
-			ret = add_delayed_refs(head, time_seq, &preftrees,
-					       &total_refs, inum);
+			ret = add_delayed_refs(fs_info, head, time_seq,
+					       &preftrees, &total_refs, inum);
 			mutex_unlock(&head->mutex);
 			if (ret)
 				goto out;
@@ -1145,8 +1147,9 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 		if (key.objectid == bytenr &&
 		    (key.type == BTRFS_EXTENT_ITEM_KEY ||
 		     key.type == BTRFS_METADATA_ITEM_KEY)) {
-			ret = add_inline_refs(path, bytenr, &info_level,
-					      &preftrees, &total_refs, inum);
+			ret = add_inline_refs(fs_info, path, bytenr,
+					      &info_level, &preftrees,
+					      &total_refs, inum);
 			if (ret)
 				goto out;
 			ret = add_keyed_refs(fs_info, path, bytenr, info_level,
diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
index f9428aa..e410335 100644
--- a/fs/btrfs/backref.h
+++ b/fs/btrfs/backref.h
@@ -72,4 +72,16 @@ int btrfs_check_shared(struct btrfs_root *root, u64 inum, u64 bytenr);
 
 int __init btrfs_prelim_ref_init(void);
 void btrfs_prelim_ref_exit(void);
+
+struct prelim_ref {
+	struct rb_node rbnode;
+	u64 root_id;
+	struct btrfs_key key_for_search;
+	int level;
+	int count;
+	struct extent_inode_elem *inode_list;
+	u64 parent;
+	u64 wanted_disk_byte;
+};
+
 #endif
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 74e4779..83f2d8c 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -61,6 +61,7 @@
 #include "tests/btrfs-tests.h"
 
 #include "qgroup.h"
+#include "backref.h"
 #define CREATE_TRACE_POINTS
 #include <trace/events/btrfs.h>
 
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 42560fe..1da36b0 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -26,6 +26,7 @@ struct btrfs_work;
 struct __btrfs_workqueue;
 struct btrfs_qgroup_extent_record;
 struct btrfs_qgroup;
+struct prelim_ref;
 
 #define show_ref_type(type)						\
 	__print_symbolic(type,						\
@@ -1636,6 +1637,63 @@ TRACE_EVENT(qgroup_meta_reserve,
 		show_root_type(__entry->refroot), __entry->diff)
 );
 
+DECLARE_EVENT_CLASS(btrfs__prelim_ref,
+	TP_PROTO(const struct btrfs_fs_info *fs_info,
+		 const struct prelim_ref *oldref,
+		 const struct prelim_ref *newref, u64 tree_size),
+	TP_ARGS(fs_info, newref, oldref, tree_size),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,  root_id		)
+		__field(	u64,  objectid		)
+		__field(	 u8,  type		)
+		__field(	u64,  offset		)
+		__field(	int,  level		)
+		__field(	int,  old_count		)
+		__field(	u64,  parent		)
+		__field(	u64,  bytenr		)
+		__field(	int,  mod_count		)
+		__field(	u64, tree_size		)
+	),
+
+	TP_fast_assign_btrfs(fs_info,
+		__entry->root_id	= oldref->root_id;
+		__entry->objectid	= oldref->key_for_search.objectid;
+		__entry->type		= oldref->key_for_search.type;
+		__entry->offset		= oldref->key_for_search.offset;
+		__entry->level		= oldref->level;
+		__entry->old_count	= oldref->count;
+		__entry->parent		= oldref->parent;
+		__entry->bytenr		= oldref->wanted_disk_byte;
+		__entry->mod_count	= newref ? newref->count : 0;
+		__entry->tree_size	= tree_size;
+	),
+
+	TP_printk_btrfs("root=%llu, key=[%llu, %u, %llu], level=%d, count=[%d+%d=%d], parent=%llu, wanted_disk_byte=%llu, nodes=%llu",
+			(unsigned long long)__entry->root_id,
+			(unsigned long long)__entry->objectid, __entry->type,
+			(unsigned long long)__entry->offset, __entry->level,
+			__entry->old_count, __entry->mod_count,
+			__entry->old_count + __entry->mod_count,
+			(unsigned long long)__entry->parent,
+			(unsigned long long)__entry->bytenr,
+			(unsigned long long)__entry->tree_size)
+);
+
+DEFINE_EVENT(btrfs__prelim_ref, btrfs_prelim_ref_merge,
+	TP_PROTO(const struct btrfs_fs_info *fs_info,
+		 const struct prelim_ref *oldref,
+		 const struct prelim_ref *newref, u64 tree_size),
+	TP_ARGS(fs_info, oldref, newref, tree_size)
+);
+
+DEFINE_EVENT(btrfs__prelim_ref, btrfs_prelim_ref_insert,
+	TP_PROTO(const struct btrfs_fs_info *fs_info,
+		 const struct prelim_ref *oldref,
+		 const struct prelim_ref *newref, u64 tree_size),
+	TP_ARGS(fs_info, oldref, newref, tree_size)
+);
+
 #endif /* _TRACE_BTRFS_H */
 
 /* This part must be outside protection */
-- 
2.10.2

