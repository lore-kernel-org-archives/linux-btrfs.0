Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54398 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2403800AbeHPQJO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Aug 2018 12:09:14 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9DBACAE83
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Aug 2018 13:10:38 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 3/8] btrfs-progs: Add delayed refs infrastructure
Date: Thu, 16 Aug 2018 16:10:30 +0300
Message-Id: <1534425035-323-4-git-send-email-nborisov@suse.com>
In-Reply-To: <1534425035-323-1-git-send-email-nborisov@suse.com>
References: <1534425035-323-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This commit pulls those portions of the kernel implementation of
delayed refs which are necessary to have them working in user-space.
I've done the following modifications:

1. Replaced all kmem_cache_alloc calls to kmalloc.

2. Removed all locking-related code, since we are single threaded in
userspace.

3. Removed code which deals with data refs - delayed refs in user space
are going to be used only for cowonly trees.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 Makefile      |   3 +-
 ctree.h       |   3 +
 delayed-ref.c | 607 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 delayed-ref.h | 208 ++++++++++++++++++++
 extent-tree.c | 226 ++++++++++++++++++++++
 kerncompat.h  |   8 +
 transaction.h |   4 +
 7 files changed, 1058 insertions(+), 1 deletion(-)
 create mode 100644 delayed-ref.c
 create mode 100644 delayed-ref.h

diff --git a/Makefile b/Makefile
index fcfc815a2a5b..f4ab14ea74c8 100644
--- a/Makefile
+++ b/Makefile
@@ -116,7 +116,8 @@ objects = ctree.o disk-io.o kernel-lib/radix-tree.o extent-tree.o print-tree.o \
 	  qgroup.o free-space-cache.o kernel-lib/list_sort.o props.o \
 	  kernel-shared/ulist.o qgroup-verify.o backref.o string-table.o task-utils.o \
 	  inode.o file.o find-root.o free-space-tree.o help.o send-dump.o \
-	  fsfeatures.o kernel-lib/tables.o kernel-lib/raid56.o transaction.o
+	  fsfeatures.o kernel-lib/tables.o kernel-lib/raid56.o transaction.o \
+	  delayed-ref.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o check/main.o \
diff --git a/ctree.h b/ctree.h
index 4719962df67d..5242595fe355 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2790,4 +2790,7 @@ int btrfs_punch_hole(struct btrfs_trans_handle *trans,
 int btrfs_read_file(struct btrfs_root *root, u64 ino, u64 start, int len,
 		    char *dest);
 
+/* extent-tree.c */
+int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans, unsigned long nr);
+
 #endif
diff --git a/delayed-ref.c b/delayed-ref.c
new file mode 100644
index 000000000000..e8123436a58f
--- /dev/null
+++ b/delayed-ref.c
@@ -0,0 +1,607 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2009 Oracle.  All rights reserved.
+ */
+
+#include "ctree.h"
+#include "btrfs-list.h"
+#include "delayed-ref.h"
+#include "transaction.h"
+
+/*
+ * delayed back reference update tracking.  For subvolume trees
+ * we queue up extent allocations and backref maintenance for
+ * delayed processing.   This avoids deep call chains where we
+ * add extents in the middle of btrfs_search_slot, and it allows
+ * us to buffer up frequently modified backrefs in an rb tree instead
+ * of hammering updates on the extent allocation tree.
+ */
+
+/*
+ * compare two delayed tree backrefs with same bytenr and type
+ */
+static int comp_tree_refs(struct btrfs_delayed_tree_ref *ref1,
+			  struct btrfs_delayed_tree_ref *ref2)
+{
+	if (ref1->node.type == BTRFS_TREE_BLOCK_REF_KEY) {
+		if (ref1->root < ref2->root)
+			return -1;
+		if (ref1->root > ref2->root)
+			return 1;
+	} else {
+		if (ref1->parent < ref2->parent)
+			return -1;
+		if (ref1->parent > ref2->parent)
+			return 1;
+	}
+	return 0;
+}
+
+static int comp_refs(struct btrfs_delayed_ref_node *ref1,
+		     struct btrfs_delayed_ref_node *ref2,
+		     bool check_seq)
+{
+	int ret = 0;
+
+	if (ref1->type < ref2->type)
+		return -1;
+	if (ref1->type > ref2->type)
+		return 1;
+	if (ref1->type == BTRFS_TREE_BLOCK_REF_KEY ||
+	    ref1->type == BTRFS_SHARED_BLOCK_REF_KEY)
+		ret = comp_tree_refs(btrfs_delayed_node_to_tree_ref(ref1),
+				     btrfs_delayed_node_to_tree_ref(ref2));
+	else
+		BUG();
+
+	if (ret)
+		return ret;
+	if (check_seq) {
+		if (ref1->seq < ref2->seq)
+			return -1;
+		if (ref1->seq > ref2->seq)
+			return 1;
+	}
+	return 0;
+}
+
+/* insert a new ref to head ref rbtree */
+static struct btrfs_delayed_ref_head *htree_insert(struct rb_root *root,
+						   struct rb_node *node)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent_node = NULL;
+	struct btrfs_delayed_ref_head *entry;
+	struct btrfs_delayed_ref_head *ins;
+	u64 bytenr;
+
+	ins = rb_entry(node, struct btrfs_delayed_ref_head, href_node);
+	bytenr = ins->bytenr;
+	while (*p) {
+		parent_node = *p;
+		entry = rb_entry(parent_node, struct btrfs_delayed_ref_head,
+				 href_node);
+
+		if (bytenr < entry->bytenr)
+			p = &(*p)->rb_left;
+		else if (bytenr > entry->bytenr)
+			p = &(*p)->rb_right;
+		else
+			return entry;
+	}
+
+	rb_link_node(node, parent_node, p);
+	rb_insert_color(node, root);
+	return NULL;
+}
+
+static struct btrfs_delayed_ref_node* tree_insert(struct rb_root *root,
+		struct btrfs_delayed_ref_node *ins)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *node = &ins->ref_node;
+	struct rb_node *parent_node = NULL;
+	struct btrfs_delayed_ref_node *entry;
+
+	while (*p) {
+		int comp;
+
+		parent_node = *p;
+		entry = rb_entry(parent_node, struct btrfs_delayed_ref_node,
+				 ref_node);
+		comp = comp_refs(ins, entry, true);
+		if (comp < 0)
+			p = &(*p)->rb_left;
+		else if (comp > 0)
+			p = &(*p)->rb_right;
+		else
+			return entry;
+	}
+
+	rb_link_node(node, parent_node, p);
+	rb_insert_color(node, root);
+	return NULL;
+}
+
+/*
+ * find an head entry based on bytenr. This returns the delayed ref
+ * head if it was able to find one, or NULL if nothing was in that spot.
+ * If return_bigger is given, the next bigger entry is returned if no exact
+ * match is found.
+ */
+static struct btrfs_delayed_ref_head *
+find_ref_head(struct rb_root *root, u64 bytenr,
+	      int return_bigger)
+{
+	struct rb_node *n;
+	struct btrfs_delayed_ref_head *entry;
+
+	n = root->rb_node;
+	entry = NULL;
+	while (n) {
+		entry = rb_entry(n, struct btrfs_delayed_ref_head, href_node);
+
+		if (bytenr < entry->bytenr)
+			n = n->rb_left;
+		else if (bytenr > entry->bytenr)
+			n = n->rb_right;
+		else
+			return entry;
+	}
+	if (entry && return_bigger) {
+		if (bytenr > entry->bytenr) {
+			n = rb_next(&entry->href_node);
+			if (!n)
+				n = rb_first(root);
+			entry = rb_entry(n, struct btrfs_delayed_ref_head,
+					 href_node);
+			return entry;
+		}
+		return entry;
+	}
+	return NULL;
+}
+
+static inline void drop_delayed_ref(struct btrfs_trans_handle *trans,
+				    struct btrfs_delayed_ref_root *delayed_refs,
+				    struct btrfs_delayed_ref_head *head,
+				    struct btrfs_delayed_ref_node *ref)
+{
+	rb_erase(&ref->ref_node, &head->ref_tree);
+	RB_CLEAR_NODE(&ref->ref_node);
+	if (!list_empty(&ref->add_list))
+		list_del(&ref->add_list);
+	ref->in_tree = 0;
+	btrfs_put_delayed_ref(ref);
+	if (trans->delayed_ref_updates)
+		trans->delayed_ref_updates--;
+}
+
+static bool merge_ref(struct btrfs_trans_handle *trans,
+		      struct btrfs_delayed_ref_root *delayed_refs,
+		      struct btrfs_delayed_ref_head *head,
+		      struct btrfs_delayed_ref_node *ref,
+		      u64 seq)
+{
+	struct btrfs_delayed_ref_node *next;
+	struct rb_node *node = rb_next(&ref->ref_node);
+	bool done = false;
+
+	while (!done && node) {
+		int mod;
+
+		next = rb_entry(node, struct btrfs_delayed_ref_node, ref_node);
+		node = rb_next(node);
+		if (seq && next->seq >= seq)
+			break;
+		if (comp_refs(ref, next, false))
+			break;
+
+		if (ref->action == next->action) {
+			mod = next->ref_mod;
+		} else {
+			if (ref->ref_mod < next->ref_mod) {
+				swap(ref, next);
+				done = true;
+			}
+			mod = -next->ref_mod;
+		}
+
+		drop_delayed_ref(trans, delayed_refs, head, next);
+		ref->ref_mod += mod;
+		if (ref->ref_mod == 0) {
+			drop_delayed_ref(trans, delayed_refs, head, ref);
+			done = true;
+		} else {
+			/*
+			 * Can't have multiples of the same ref on a tree block.
+			 */
+			WARN_ON(ref->type == BTRFS_TREE_BLOCK_REF_KEY ||
+				ref->type == BTRFS_SHARED_BLOCK_REF_KEY);
+		}
+	}
+
+	return done;
+}
+
+void btrfs_merge_delayed_refs(struct btrfs_trans_handle *trans,
+			      struct btrfs_delayed_ref_root *delayed_refs,
+			      struct btrfs_delayed_ref_head *head)
+{
+	struct btrfs_delayed_ref_node *ref;
+	struct rb_node *node;
+
+	if (RB_EMPTY_ROOT(&head->ref_tree))
+		return;
+
+	/* We don't have too many refs to merge for data. */
+	if (head->is_data)
+		return;
+
+again:
+	for (node = rb_first(&head->ref_tree); node; node = rb_next(node)) {
+		ref = rb_entry(node, struct btrfs_delayed_ref_node, ref_node);
+		if (merge_ref(trans, delayed_refs, head, ref, 0))
+			goto again;
+	}
+}
+
+struct btrfs_delayed_ref_head *
+btrfs_select_ref_head(struct btrfs_trans_handle *trans)
+{
+	struct btrfs_delayed_ref_root *delayed_refs;
+	struct btrfs_delayed_ref_head *head;
+	u64 start;
+	bool loop = false;
+
+	delayed_refs = &trans->delayed_refs;
+
+again:
+	start = delayed_refs->run_delayed_start;
+	head = find_ref_head(&delayed_refs->href_root, start, 1);
+	if (!head && !loop) {
+		delayed_refs->run_delayed_start = 0;
+		start = 0;
+		loop = true;
+		head = find_ref_head(&delayed_refs->href_root, start, 1);
+		if (!head)
+			return NULL;
+	} else if (!head && loop) {
+		return NULL;
+	}
+
+	while (head->processing) {
+		struct rb_node *node;
+
+		node = rb_next(&head->href_node);
+		if (!node) {
+			if (loop)
+				return NULL;
+			delayed_refs->run_delayed_start = 0;
+			start = 0;
+			loop = true;
+			goto again;
+		}
+		head = rb_entry(node, struct btrfs_delayed_ref_head,
+				href_node);
+	}
+
+	head->processing = 1;
+	WARN_ON(delayed_refs->num_heads_ready == 0);
+	delayed_refs->num_heads_ready--;
+	delayed_refs->run_delayed_start = head->bytenr +
+		head->num_bytes;
+	return head;
+}
+
+/*
+ * Helper to insert the ref_node to the tail or merge with tail.
+ *
+ * Return 0 for insert.
+ * Return >0 for merge.
+ */
+static int insert_delayed_ref(struct btrfs_trans_handle *trans,
+			      struct btrfs_delayed_ref_root *root,
+			      struct btrfs_delayed_ref_head *href,
+			      struct btrfs_delayed_ref_node *ref)
+{
+	struct btrfs_delayed_ref_node *exist;
+	int mod;
+	int ret = 0;
+
+	exist = tree_insert(&href->ref_tree, ref);
+	if (!exist)
+		goto inserted;
+
+	/* Now we are sure we can merge */
+	ret = 1;
+	if (exist->action == ref->action) {
+		mod = ref->ref_mod;
+	} else {
+		/* Need to change action */
+		if (exist->ref_mod < ref->ref_mod) {
+			exist->action = ref->action;
+			mod = -exist->ref_mod;
+			exist->ref_mod = ref->ref_mod;
+			if (ref->action == BTRFS_ADD_DELAYED_REF)
+				list_add_tail(&exist->add_list,
+					      &href->ref_add_list);
+			else if (ref->action == BTRFS_DROP_DELAYED_REF) {
+				ASSERT(!list_empty(&exist->add_list));
+				list_del(&exist->add_list);
+			} else {
+				ASSERT(0);
+			}
+		} else
+			mod = -ref->ref_mod;
+	}
+	exist->ref_mod += mod;
+
+	/* remove existing tail if its ref_mod is zero */
+	if (exist->ref_mod == 0)
+		drop_delayed_ref(trans, root, href, exist);
+	return ret;
+inserted:
+	if (ref->action == BTRFS_ADD_DELAYED_REF)
+		list_add_tail(&ref->add_list, &href->ref_add_list);
+	trans->delayed_ref_updates++;
+	return ret;
+}
+
+/*
+ * helper function to update the accounting in the head ref
+ * existing and update must have the same bytenr
+ */
+static noinline void
+update_existing_head_ref(struct btrfs_delayed_ref_root *delayed_refs,
+			 struct btrfs_delayed_ref_head *existing,
+			 struct btrfs_delayed_ref_head *update,
+			 int *old_ref_mod_ret)
+{
+	int old_ref_mod;
+
+	BUG_ON(existing->is_data != update->is_data);
+
+	if (update->must_insert_reserved) {
+		/* if the extent was freed and then
+		 * reallocated before the delayed ref
+		 * entries were processed, we can end up
+		 * with an existing head ref without
+		 * the must_insert_reserved flag set.
+		 * Set it again here
+		 */
+		existing->must_insert_reserved = update->must_insert_reserved;
+
+		/*
+		 * update the num_bytes so we make sure the accounting
+		 * is done correctly
+		 */
+		existing->num_bytes = update->num_bytes;
+
+	}
+
+	if (update->extent_op) {
+		if (!existing->extent_op) {
+			existing->extent_op = update->extent_op;
+		} else {
+			if (update->extent_op->update_key) {
+				memcpy(&existing->extent_op->key,
+				       &update->extent_op->key,
+				       sizeof(update->extent_op->key));
+				existing->extent_op->update_key = true;
+			}
+			if (update->extent_op->update_flags) {
+				existing->extent_op->flags_to_set |=
+					update->extent_op->flags_to_set;
+				existing->extent_op->update_flags = true;
+			}
+			btrfs_free_delayed_extent_op(update->extent_op);
+		}
+	}
+	/*
+	 * update the reference mod on the head to reflect this new operation,
+	 * only need the lock for this case cause we could be processing it
+	 * currently, for refs we just added we know we're a-ok.
+	 */
+	old_ref_mod = existing->total_ref_mod;
+	if (old_ref_mod_ret)
+		*old_ref_mod_ret = old_ref_mod;
+	existing->ref_mod += update->ref_mod;
+	existing->total_ref_mod += update->ref_mod;
+
+}
+
+static void init_delayed_ref_head(struct btrfs_delayed_ref_head *head_ref,
+				  void *qrecord,
+				  u64 bytenr, u64 num_bytes, u64 ref_root,
+				  u64 reserved, int action, bool is_data,
+				  bool is_system)
+{
+	int count_mod = 1;
+	int must_insert_reserved = 0;
+
+	/* If reserved is provided, it must be a data extent. */
+	BUG_ON(!is_data && reserved);
+
+	/*
+	 * The head node stores the sum of all the mods, so dropping a ref
+	 * should drop the sum in the head node by one.
+	 */
+	if (action == BTRFS_UPDATE_DELAYED_HEAD)
+		count_mod = 0;
+	else if (action == BTRFS_DROP_DELAYED_REF)
+		count_mod = -1;
+
+	/*
+	 * BTRFS_ADD_DELAYED_EXTENT means that we need to update the reserved
+	 * accounting when the extent is finally added, or if a later
+	 * modification deletes the delayed ref without ever inserting the
+	 * extent into the extent allocation tree.  ref->must_insert_reserved
+	 * is the flag used to record that accounting mods are required.
+	 *
+	 * Once we record must_insert_reserved, switch the action to
+	 * BTRFS_ADD_DELAYED_REF because other special casing is not required.
+	 */
+	if (action == BTRFS_ADD_DELAYED_EXTENT)
+		must_insert_reserved = 1;
+	else
+		must_insert_reserved = 0;
+
+	head_ref->refs = 1;
+	head_ref->bytenr = bytenr;
+	head_ref->num_bytes = num_bytes;
+	head_ref->ref_mod = count_mod;
+	head_ref->must_insert_reserved = must_insert_reserved;
+	head_ref->is_data = is_data;
+	head_ref->is_system = is_system;
+	head_ref->ref_tree = RB_ROOT;
+	INIT_LIST_HEAD(&head_ref->ref_add_list);
+	RB_CLEAR_NODE(&head_ref->href_node);
+	head_ref->processing = 0;
+	head_ref->total_ref_mod = count_mod;
+}
+
+/*
+ * helper function to actually insert a head node into the rbtree.
+ * this does all the dirty work in terms of maintaining the correct
+ * overall modification count.
+ */
+static noinline struct btrfs_delayed_ref_head *
+add_delayed_ref_head(struct btrfs_trans_handle *trans,
+		     struct btrfs_delayed_ref_head *head_ref,
+		     void *qrecord,
+		     int action, int *qrecord_inserted_ret,
+		     int *old_ref_mod, int *new_ref_mod)
+{
+	struct btrfs_delayed_ref_head *existing;
+	struct btrfs_delayed_ref_root *delayed_refs;
+
+	delayed_refs = &trans->delayed_refs;
+
+	existing = htree_insert(&delayed_refs->href_root, &head_ref->href_node);
+	if (existing) {
+		update_existing_head_ref(delayed_refs, existing, head_ref, old_ref_mod);
+		/*
+		 * we've updated the existing ref, free the newly
+		 * allocated ref
+		 */
+		kfree(head_ref);
+		head_ref = existing;
+	} else {
+		if (old_ref_mod)
+			*old_ref_mod = 0;
+		delayed_refs->num_heads++;
+		delayed_refs->num_heads_ready++;
+		trans->delayed_ref_updates++;
+	}
+	if (new_ref_mod)
+		*new_ref_mod = head_ref->total_ref_mod;
+
+	return head_ref;
+}
+
+/*
+ * init_delayed_ref_common - Initialize the structure which represents a
+ *			     modification to a an extent.
+ *
+ * @fs_info:    Internal to the mounted filesystem mount structure.
+ *
+ * @ref:	The structure which is going to be initialized.
+ *
+ * @bytenr:	The logical address of the extent for which a modification is
+ *		going to be recorded.
+ *
+ * @num_bytes:  Size of the extent whose modification is being recorded.
+ *
+ * @ref_root:	The id of the root where this modification has originated, this
+ *		can be either one of the well-known metadata trees or the
+ *		subvolume id which references this extent.
+ *
+ * @action:	Can be one of BTRFS_ADD_DELAYED_REF/BTRFS_DROP_DELAYED_REF or
+ *		BTRFS_ADD_DELAYED_EXTENT
+ *
+ * @ref_type:	Holds the type of the extent which is being recorded, can be
+ *		one of BTRFS_SHARED_BLOCK_REF_KEY/BTRFS_TREE_BLOCK_REF_KEY
+ *		when recording a metadata extent or BTRFS_SHARED_DATA_REF_KEY/
+ *		BTRFS_EXTENT_DATA_REF_KEY when recording data extent
+ */
+static void init_delayed_ref_common(struct btrfs_fs_info *fs_info,
+				    struct btrfs_delayed_ref_node *ref,
+				    u64 bytenr, u64 num_bytes, u64 ref_root,
+				    int action, u8 ref_type)
+{
+	if (action == BTRFS_ADD_DELAYED_EXTENT)
+		action = BTRFS_ADD_DELAYED_REF;
+
+	ref->refs = 1;
+	ref->bytenr = bytenr;
+	ref->num_bytes = num_bytes;
+	ref->ref_mod = 1;
+	ref->action = action;
+	ref->is_head = 0;
+	ref->in_tree = 1;
+	ref->seq = 0;
+	ref->type = ref_type;
+	RB_CLEAR_NODE(&ref->ref_node);
+	INIT_LIST_HEAD(&ref->add_list);
+}
+
+/*
+ * add a delayed tree ref.  This does all of the accounting required
+ * to make sure the delayed ref is eventually processed before this
+ * transaction commits.
+ */
+int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
+			       struct btrfs_trans_handle *trans,
+			       u64 bytenr, u64 num_bytes, u64 parent,
+			       u64 ref_root, int level, int action,
+			       struct btrfs_delayed_extent_op *extent_op,
+			       int *old_ref_mod, int *new_ref_mod)
+{
+	struct btrfs_delayed_tree_ref *ref;
+	struct btrfs_delayed_ref_head *head_ref;
+	struct btrfs_delayed_ref_root *delayed_refs;
+	bool is_system = (ref_root == BTRFS_CHUNK_TREE_OBJECTID);
+	int ret;
+	u8 ref_type;
+
+	BUG_ON(extent_op && extent_op->is_data);
+	ref = kmalloc(sizeof(*ref), GFP_NOFS);
+	if (!ref)
+		return -ENOMEM;
+
+	if (parent)
+		ref_type = BTRFS_SHARED_BLOCK_REF_KEY;
+	else
+		ref_type = BTRFS_TREE_BLOCK_REF_KEY;
+	init_delayed_ref_common(fs_info, &ref->node, bytenr, num_bytes,
+				ref_root, action, ref_type);
+	ref->root = ref_root;
+	ref->parent = parent;
+	ref->level = level;
+
+	head_ref = kmalloc(sizeof(*head_ref), GFP_NOFS);
+	if (!head_ref)
+		goto free_ref;
+
+	init_delayed_ref_head(head_ref, NULL, bytenr, num_bytes,
+			      ref_root, 0, action, false, is_system);
+	head_ref->extent_op = extent_op;
+
+	delayed_refs = &trans->delayed_refs;
+
+	head_ref = add_delayed_ref_head(trans, head_ref, NULL, action, NULL,
+			old_ref_mod, new_ref_mod);
+
+	ret = insert_delayed_ref(trans, delayed_refs, head_ref, &ref->node);
+
+	if (ret > 0)
+		kfree(ref);
+
+	return 0;
+
+free_ref:
+	kfree(ref);
+
+	return -ENOMEM;
+}
diff --git a/delayed-ref.h b/delayed-ref.h
new file mode 100644
index 000000000000..30a68b2a278c
--- /dev/null
+++ b/delayed-ref.h
@@ -0,0 +1,208 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2008 Oracle.  All rights reserved.
+ */
+
+#ifndef BTRFS_DELAYED_REF_H
+#define BTRFS_DELAYED_REF_H
+
+#include "kerncompat.h"
+
+/* these are the possible values of struct btrfs_delayed_ref_node->action */
+#define BTRFS_ADD_DELAYED_REF    1 /* add one backref to the tree */
+#define BTRFS_DROP_DELAYED_REF   2 /* delete one backref from the tree */
+#define BTRFS_ADD_DELAYED_EXTENT 3 /* record a full extent allocation */
+#define BTRFS_UPDATE_DELAYED_HEAD 4 /* not changing ref count on head ref */
+
+struct btrfs_delayed_ref_node {
+	struct rb_node ref_node;
+	/*
+	 * If action is BTRFS_ADD_DELAYED_REF, also link this node to
+	 * ref_head->ref_add_list, then we do not need to iterate the
+	 * whole ref_head->ref_list to find BTRFS_ADD_DELAYED_REF nodes.
+	 */
+	struct list_head add_list;
+
+	/* the starting bytenr of the extent */
+	u64 bytenr;
+
+	/* the size of the extent */
+	u64 num_bytes;
+
+	/* seq number to keep track of insertion order */
+	u64 seq;
+
+	/* ref count on this data structure */
+	u64 refs;
+
+	/*
+	 * how many refs is this entry adding or deleting.  For
+	 * head refs, this may be a negative number because it is keeping
+	 * track of the total mods done to the reference count.
+	 * For individual refs, this will always be a positive number
+	 *
+	 * It may be more than one, since it is possible for a single
+	 * parent to have more than one ref on an extent
+	 */
+	int ref_mod;
+
+	unsigned int action:8;
+	unsigned int type:8;
+	/* is this node still in the rbtree? */
+	unsigned int is_head:1;
+	unsigned int in_tree:1;
+};
+
+struct btrfs_delayed_extent_op {
+	struct btrfs_disk_key key;
+	u8 level;
+	bool update_key;
+	bool update_flags;
+	bool is_data;
+	u64 flags_to_set;
+};
+
+/*
+ * the head refs are used to hold a lock on a given extent, which allows us
+ * to make sure that only one process is running the delayed refs
+ * at a time for a single extent.  They also store the sum of all the
+ * reference count modifications we've queued up.
+ */
+struct btrfs_delayed_ref_head {
+	u64 bytenr;
+	u64 num_bytes;
+	u64 refs;
+
+	struct rb_root ref_tree;
+	/* accumulate add BTRFS_ADD_DELAYED_REF nodes to this ref_add_list. */
+	struct list_head ref_add_list;
+
+	struct rb_node href_node;
+
+	struct btrfs_delayed_extent_op *extent_op;
+
+	/*
+	 * This is used to track the final ref_mod from all the refs associated
+	 * with this head ref, this is not adjusted as delayed refs are run,
+	 * this is meant to track if we need to do the csum accounting or not.
+	 */
+	int total_ref_mod;
+
+	/*
+	 * This is the current outstanding mod references for this bytenr.  This
+	 * is used with lookup_extent_info to get an accurate reference count
+	 * for a bytenr, so it is adjusted as delayed refs are run so that any
+	 * on disk reference count + ref_mod is accurate.
+	 */
+	int ref_mod;
+
+	/*
+	 * when a new extent is allocated, it is just reserved in memory
+	 * The actual extent isn't inserted into the extent allocation tree
+	 * until the delayed ref is processed.  must_insert_reserved is
+	 * used to flag a delayed ref so the accounting can be updated
+	 * when a full insert is done.
+	 *
+	 * It is possible the extent will be freed before it is ever
+	 * inserted into the extent allocation tree.  In this case
+	 * we need to update the in ram accounting to properly reflect
+	 * the free has happened.
+	 */
+	unsigned int must_insert_reserved:1;
+	unsigned int is_data:1;
+	unsigned int is_system:1;
+	unsigned int processing:1;
+};
+
+struct btrfs_delayed_tree_ref {
+	struct btrfs_delayed_ref_node node;
+	u64 root;
+	u64 parent;
+	int level;
+};
+
+struct btrfs_delayed_ref_root {
+	/* head ref rbtree */
+	struct rb_root href_root;
+
+	/* dirty extent records */
+	struct rb_root dirty_extent_root;
+
+	/* total number of head nodes in tree */
+	unsigned long num_heads;
+
+	/* total number of head nodes ready for processing */
+	unsigned long num_heads_ready;
+
+	/*
+	 * set when the tree is flushing before a transaction commit,
+	 * used by the throttling code to decide if new updates need
+	 * to be run right away
+	 */
+	int flushing;
+
+	u64 run_delayed_start;
+};
+
+
+static inline struct btrfs_delayed_extent_op *
+btrfs_alloc_delayed_extent_op(void)
+{
+	return kmalloc(sizeof(struct btrfs_delayed_extent_op), GFP_KERNEL);
+}
+
+static inline void
+btrfs_free_delayed_extent_op(struct btrfs_delayed_extent_op *op)
+{
+	if (op)
+		kfree(op);
+}
+
+static inline void btrfs_put_delayed_ref(struct btrfs_delayed_ref_node *ref)
+{
+	WARN_ON(ref->refs == 0);
+	if (--ref->refs) {
+		WARN_ON(ref->in_tree);
+		switch (ref->type) {
+		case BTRFS_TREE_BLOCK_REF_KEY:
+		case BTRFS_SHARED_BLOCK_REF_KEY:
+			kfree(ref);
+			break;
+		case BTRFS_EXTENT_DATA_REF_KEY:
+		case BTRFS_SHARED_DATA_REF_KEY:
+			kfree(ref);
+			break;
+		default:
+			BUG();
+		}
+	}
+}
+
+static inline void btrfs_put_delayed_ref_head(struct btrfs_delayed_ref_head *head)
+{
+	if (--head->refs)
+		kfree(head);
+}
+
+int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
+			       struct btrfs_trans_handle *trans,
+			       u64 bytenr, u64 num_bytes, u64 parent,
+			       u64 ref_root, int level, int action,
+			       struct btrfs_delayed_extent_op *extent_op,
+			       int *old_ref_mod, int *new_ref_mod);
+void btrfs_merge_delayed_refs(struct btrfs_trans_handle *trans,
+			      struct btrfs_delayed_ref_root *delayed_refs,
+			      struct btrfs_delayed_ref_head *head);
+
+struct btrfs_delayed_ref_head *
+btrfs_select_ref_head(struct btrfs_trans_handle *trans);
+
+/*
+ * helper functions to cast a node into its container
+ */
+static inline struct btrfs_delayed_tree_ref *
+btrfs_delayed_node_to_tree_ref(struct btrfs_delayed_ref_node *node)
+{
+	return container_of(node, struct btrfs_delayed_tree_ref, node);
+}
+#endif
diff --git a/extent-tree.c b/extent-tree.c
index f7b59f84bf3d..3356dd2e4cf6 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -4218,3 +4218,229 @@ u64 add_new_free_space(struct btrfs_block_group_cache *block_group,
 
 	return total_added;
 }
+
+static void cleanup_extent_op(struct btrfs_trans_handle *trans,
+			     struct btrfs_fs_info *fs_info,
+			     struct btrfs_delayed_ref_head *head)
+{
+	struct btrfs_delayed_extent_op *extent_op = head->extent_op;
+
+	if (!extent_op)
+		return;
+	head->extent_op = NULL;
+	btrfs_free_delayed_extent_op(extent_op);
+}
+
+static void unselect_delayed_ref_head(struct btrfs_delayed_ref_root *delayed_refs,
+				      struct btrfs_delayed_ref_head *head)
+{
+	head->processing = 0;
+	delayed_refs->num_heads_ready++;
+}
+
+static int cleanup_ref_head(struct btrfs_trans_handle *trans,
+			    struct btrfs_fs_info *fs_info,
+			    struct btrfs_delayed_ref_head *head)
+{
+	struct btrfs_delayed_ref_root *delayed_refs;
+
+	delayed_refs = &trans->delayed_refs;
+
+	cleanup_extent_op(trans, fs_info, head);
+
+	/*
+	 * Need to drop our head ref lock and re-acquire the delayed ref lock
+	 * and then re-check to make sure nobody got added.
+	 */
+	if (!RB_EMPTY_ROOT(&head->ref_tree) || head->extent_op)
+		return 1;
+
+	delayed_refs->num_heads--;
+	rb_erase(&head->href_node, &delayed_refs->href_root);
+	RB_CLEAR_NODE(&head->href_node);
+
+	if (head->must_insert_reserved)
+		btrfs_pin_extent(fs_info, head->bytenr, head->num_bytes);
+
+	btrfs_put_delayed_ref_head(head);
+	return 0;
+}
+
+static inline struct btrfs_delayed_ref_node *
+select_delayed_ref(struct btrfs_delayed_ref_head *head)
+{
+	struct btrfs_delayed_ref_node *ref;
+
+	if (RB_EMPTY_ROOT(&head->ref_tree))
+		return NULL;
+	/*
+	 * Select a delayed ref of type BTRFS_ADD_DELAYED_REF first.
+	 * This is to prevent a ref count from going down to zero, which deletes
+	 * the extent item from the extent tree, when there still are references
+	 * to add, which would fail because they would not find the extent item.
+	 */
+	if (!list_empty(&head->ref_add_list))
+		return list_first_entry(&head->ref_add_list,
+					struct btrfs_delayed_ref_node,
+					add_list);
+	ref = rb_entry(rb_first(&head->ref_tree),
+		       struct btrfs_delayed_ref_node, ref_node);
+	ASSERT(list_empty(&ref->add_list));
+	return ref;
+}
+
+
+static int run_delayed_tree_ref(struct btrfs_trans_handle *trans,
+				struct btrfs_fs_info *fs_info,
+				struct btrfs_delayed_ref_node *node,
+				struct btrfs_delayed_extent_op *extent_op,
+				int insert_reserved)
+{
+	int ret = 0;
+	struct btrfs_delayed_tree_ref *ref;
+	u64 parent = 0;
+	u64 ref_root = 0;
+
+	ref = btrfs_delayed_node_to_tree_ref(node);
+
+	if (node->type == BTRFS_SHARED_BLOCK_REF_KEY)
+			parent = ref->parent;
+	ref_root = ref->root;
+
+	if (node->ref_mod != 1) {
+		printf("btree block(%llu) has %d references rather than 1: action %d ref_root %llu parent %llu",
+			node->bytenr, node->ref_mod, node->action, ref_root,
+			parent);
+		return -EIO;
+	}
+	if (node->action == BTRFS_ADD_DELAYED_REF && insert_reserved) {
+		BUG_ON(!extent_op || !extent_op->update_flags);
+		ret = alloc_reserved_tree_block2(trans, node, extent_op);
+	} else if (node->action == BTRFS_DROP_DELAYED_REF) {
+		ret = __free_extent2(trans, node, extent_op);
+	} else {
+		BUG();
+	}
+
+	return ret;
+}
+
+/* helper function to actually process a single delayed ref entry */
+static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
+			       struct btrfs_fs_info *fs_info,
+			       struct btrfs_delayed_ref_node *node,
+			       struct btrfs_delayed_extent_op *extent_op,
+			       int insert_reserved)
+{
+	int ret = 0;
+
+	if (node->type == BTRFS_TREE_BLOCK_REF_KEY ||
+		node->type == BTRFS_SHARED_BLOCK_REF_KEY) {
+		ret = run_delayed_tree_ref(trans, fs_info, node, extent_op,
+					   insert_reserved);
+	} else
+		BUG();
+	return ret;
+}
+
+int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans, unsigned long nr)
+{
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct btrfs_delayed_ref_root *delayed_refs;
+	struct btrfs_delayed_ref_node *ref;
+	struct btrfs_delayed_ref_head *locked_ref = NULL;
+	struct btrfs_delayed_extent_op *extent_op;
+	int ret;
+	int must_insert_reserved = 0;
+
+	delayed_refs = &trans->delayed_refs;
+	while (1) {
+		if (!locked_ref) {
+			locked_ref = btrfs_select_ref_head(trans);
+			if (!locked_ref)
+				break;
+		}
+		/*
+		 * We need to try and merge add/drops of the same ref since we
+		 * can run into issues with relocate dropping the implicit ref
+		 * and then it being added back again before the drop can
+		 * finish.	If we merged anything we need to re-loop so we can
+		 * get a good ref.
+		 * Or we can get node references of the same type that weren't
+		 * merged when created due to bumps in the tree mod seq, and
+		 * we need to merge them to prevent adding an inline extent
+		 * backref before dropping it (triggering a BUG_ON at
+		 * insert_inline_extent_backref()).
+		 */
+		btrfs_merge_delayed_refs(trans, delayed_refs, locked_ref);
+		ref = select_delayed_ref(locked_ref);
+		/*
+		 * We're done processing refs in this ref_head, clean everything
+		 * up and move on to the next ref_head.
+		 */
+		if (!ref) {
+			ret = cleanup_ref_head(trans, fs_info, locked_ref);
+			if (ret > 0 ) {
+				/* We dropped our lock, we need to loop. */
+				ret = 0;
+				continue;
+			} else if (ret) {
+				return ret;
+			}
+			locked_ref = NULL;
+			continue;
+		}
+
+		ref->in_tree = 0;
+		rb_erase(&ref->ref_node, &locked_ref->ref_tree);
+		RB_CLEAR_NODE(&ref->ref_node);
+		if (!list_empty(&ref->add_list))
+				list_del(&ref->add_list);
+		/*
+		 * When we play the delayed ref, also correct the ref_mod on
+		 * head
+		 */
+		switch (ref->action) {
+		case BTRFS_ADD_DELAYED_REF:
+		case BTRFS_ADD_DELAYED_EXTENT:
+			locked_ref->ref_mod -= ref->ref_mod;
+			break;
+		case BTRFS_DROP_DELAYED_REF:
+			locked_ref->ref_mod += ref->ref_mod;
+			break;
+		default:
+			WARN_ON(1);
+		}
+
+		/*
+		 * Record the must-insert_reserved flag before we drop the spin
+		 * lock.
+		 */
+		must_insert_reserved = locked_ref->must_insert_reserved;
+		locked_ref->must_insert_reserved = 0;
+
+		extent_op = locked_ref->extent_op;
+		locked_ref->extent_op = NULL;
+
+		ret = run_one_delayed_ref(trans, fs_info, ref, extent_op,
+					  must_insert_reserved);
+
+		btrfs_free_delayed_extent_op(extent_op);
+		/*
+		 * If we are re-initing extent tree in this transaction
+		 * failure in freeing old roots are expected (because we don't
+		 * have the old extent tree, hence backref resolution will
+		 * return -EIO).
+		 */
+		if (ret && (!trans->reinit_extent_tree ||
+		     ref->action != BTRFS_DROP_DELAYED_REF)) {
+			unselect_delayed_ref_head(delayed_refs, locked_ref);
+			btrfs_put_delayed_ref(ref);
+			return ret;
+		}
+
+		btrfs_put_delayed_ref(ref);
+	}
+
+	return 0;
+}
diff --git a/kerncompat.h b/kerncompat.h
index fa96715fb70c..1a2bc18c3ac2 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -263,6 +263,14 @@ static inline int IS_ERR_OR_NULL(const void *ptr)
 	return !ptr || IS_ERR(ptr);
 }
 
+/**
+ * swap - swap values of @a and @b
+ * @a: first value
+ * @b: second value
+ */
+#define swap(a, b) \
+        do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
+
 /*
  * This looks more complex than it should be. But we need to
  * get the type for the ~ right in round_down (it needs to be
diff --git a/transaction.h b/transaction.h
index 750e329e1ba8..34060252dd5c 100644
--- a/transaction.h
+++ b/transaction.h
@@ -21,6 +21,7 @@
 
 #include "kerncompat.h"
 #include "ctree.h"
+#include "delayed-ref.h"
 
 struct btrfs_trans_handle {
 	struct btrfs_fs_info *fs_info;
@@ -28,9 +29,12 @@ struct btrfs_trans_handle {
 	u64 alloc_exclude_start;
 	u64 alloc_exclude_nr;
 	bool reinit_extent_tree;
+	u64 delayed_ref_updates;
 	unsigned long blocks_reserved;
 	unsigned long blocks_used;
 	struct btrfs_block_group_cache *block_group;
+	struct btrfs_delayed_ref_root delayed_refs;
+
 };
 
 struct btrfs_trans_handle* btrfs_start_transaction(struct btrfs_root *root,
-- 
2.7.4
