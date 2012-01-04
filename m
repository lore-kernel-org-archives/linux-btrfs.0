From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH v2 09/10] Btrfs: added btrfs_find_all_roots()
Date: Wed,  4 Jan 2012 18:35:47 +0100
Message-ID: <8da6d5815c592b713ecaf4f4f8b631f8359c96c4.1325692561.git.list.btrfs@jan-o-sch.net>
References: <cover.1325692560.git.list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1325692560.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1325692560.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

This function gets a byte number (a data extent), collects all the leafs
pointing to it and walks up the trees to find all fs roots pointing to those
leafs. It also returns the list of all leafs pointing to that extent.

It does proper locking for the involved trees, can be used on busy file
systems and honors delayed refs.

Signed-off-by: Arne Jansen <sensille@gmx.net>
Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/backref.c |  783 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/backref.h |    5 +
 2 files changed, 788 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 22c64ff..03c30a1 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -19,6 +19,9 @@
 #include "ctree.h"
 #include "disk-io.h"
 #include "backref.h"
+#include "ulist.h"
+#include "transaction.h"
+#include "delayed-ref.h"
 
 struct __data_ref {
 	struct list_head list;
@@ -32,6 +35,786 @@ struct __shared_ref {
 	u64 disk_byte;
 };
 
+/*
+ * this structure records all encountered refs on the way up to the root
+ */
+struct __prelim_ref {
+	struct list_head list;
+	u64 root_id;
+	struct btrfs_key key;
+	int level;
+	int count;
+	u64 parent;
+	u64 wanted_disk_byte;
+};
+
+static int __add_prelim_ref(struct list_head *head, u64 root_id,
+			    struct btrfs_key *key, int level, u64 parent,
+			    u64 wanted_disk_byte, int count)
+{
+	struct __prelim_ref *ref;
+
+	/* in case we're adding delayed refs, we're holding the refs spinlock */
+	ref = kmalloc(sizeof(*ref), GFP_ATOMIC);
+	if (!ref)
+		return -ENOMEM;
+
+	ref->root_id = root_id;
+	if (key)
+		ref->key = *key;
+	else
+		memset(&ref->key, 0, sizeof(ref->key));
+
+	ref->level = level;
+	ref->count = count;
+	ref->parent = parent;
+	ref->wanted_disk_byte = wanted_disk_byte;
+	list_add_tail(&ref->list, head);
+
+	return 0;
+}
+
+static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
+				struct ulist *parents,
+				struct extent_buffer *eb, int level,
+				u64 wanted_objectid, u64 wanted_disk_byte)
+{
+	int ret;
+	int slot;
+	struct btrfs_file_extent_item *fi;
+	struct btrfs_key key;
+	u64 disk_byte;
+
+add_parent:
+	ret = ulist_add(parents, eb->start, 0, GFP_NOFS);
+	if (ret < 0)
+		return ret;
+
+	if (level != 0)
+		return 0;
+
+	/*
+	 * if the current leaf is full with EXTENT_DATA items, we must
+	 * check the next one if that holds a reference as well.
+	 * ref->count cannot be used to skip this check.
+	 * repeat this until we don't find any additional EXTENT_DATA items.
+	 */
+	while (1) {
+		ret = btrfs_next_leaf(root, path);
+		if (ret < 0)
+			return ret;
+		if (ret)
+			return 0;
+
+		eb = path->nodes[0];
+		for (slot = 0; slot < btrfs_header_nritems(eb); ++slot) {
+			btrfs_item_key_to_cpu(eb, &key, slot);
+			if (key.objectid != wanted_objectid ||
+			    key.type != BTRFS_EXTENT_DATA_KEY)
+				return 0;
+			fi = btrfs_item_ptr(eb, slot,
+						struct btrfs_file_extent_item);
+			disk_byte = btrfs_file_extent_disk_bytenr(eb, fi);
+			if (disk_byte == wanted_disk_byte)
+				goto add_parent;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * resolve an indirect backref in the form (root_id, key, level)
+ * to a logical address
+ */
+static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
+					struct __prelim_ref *ref,
+					struct ulist *parents)
+{
+	struct btrfs_path *path;
+	struct btrfs_root *root;
+	struct btrfs_key root_key;
+	struct btrfs_key key = {0};
+	struct extent_buffer *eb;
+	int ret = 0;
+	int root_level;
+	int level = ref->level;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	root_key.objectid = ref->root_id;
+	root_key.type = BTRFS_ROOT_ITEM_KEY;
+	root_key.offset = (u64)-1;
+	root = btrfs_read_fs_root_no_name(fs_info, &root_key);
+	if (IS_ERR(root)) {
+		ret = PTR_ERR(root);
+		goto out;
+	}
+
+	rcu_read_lock();
+	root_level = btrfs_header_level(root->node);
+	rcu_read_unlock();
+
+	if (root_level + 1 == level)
+		goto out;
+
+	path->lowest_level = level;
+	ret = btrfs_search_slot(NULL, root, &ref->key, path, 0, 0);
+	pr_debug("search slot in root %llu (level %d, ref count %d) returned "
+		 "%d for key (%llu %u %llu)\n",
+		 (unsigned long long)ref->root_id, level, ref->count, ret,
+		 (unsigned long long)ref->key.objectid, ref->key.type,
+		 (unsigned long long)ref->key.offset);
+	if (ret < 0)
+		goto out;
+
+	eb = path->nodes[level];
+	if (!eb) {
+		WARN_ON(1);
+		ret = 1;
+		goto out;
+	}
+
+	if (level == 0) {
+		if (ret == 1 && path->slots[0] >= btrfs_header_nritems(eb)) {
+			ret = btrfs_next_leaf(root, path);
+			if (ret)
+				goto out;
+			eb = path->nodes[0];
+		}
+
+		btrfs_item_key_to_cpu(eb, &key, path->slots[0]);
+	}
+
+	/* the last two parameters will only be used for level == 0 */
+	ret = add_all_parents(root, path, parents, eb, level, key.objectid,
+				ref->wanted_disk_byte);
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
+/*
+ * resolve all indirect backrefs from the list
+ */
+static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
+				   struct list_head *head)
+{
+	int err;
+	int ret = 0;
+	struct __prelim_ref *ref;
+	struct __prelim_ref *ref_safe;
+	struct __prelim_ref *new_ref;
+	struct ulist *parents;
+	struct ulist_node *node;
+
+	parents = ulist_alloc(GFP_NOFS);
+	if (!parents)
+		return -ENOMEM;
+
+	/*
+	 * _safe allows us to insert directly after the current item without
+	 * iterating over the newly inserted items.
+	 * we're also allowed to re-assign ref during iteration.
+	 */
+	list_for_each_entry_safe(ref, ref_safe, head, list) {
+		if (ref->parent)	/* already direct */
+			continue;
+		if (ref->count == 0)
+			continue;
+		err = __resolve_indirect_ref(fs_info, ref, parents);
+		if (err) {
+			if (ret == 0)
+				ret = err;
+			continue;
+		}
+
+		/* we put the first parent into the ref at hand */
+		node = ulist_next(parents, NULL);
+		ref->parent = node ? node->val : 0;
+
+		/* additional parents require new refs being added here */
+		while ((node = ulist_next(parents, node))) {
+			new_ref = kmalloc(sizeof(*new_ref), GFP_NOFS);
+			if (!new_ref) {
+				ret = -ENOMEM;
+				break;
+			}
+			memcpy(new_ref, ref, sizeof(*ref));
+			new_ref->parent = node->val;
+			list_add(&new_ref->list, &ref->list);
+		}
+		ulist_reinit(parents);
+	}
+
+	ulist_free(parents);
+	return ret;
+}
+
+/*
+ * merge two lists of backrefs and adjust counts accordingly
+ *
+ * mode = 1: merge identical keys, if key is set
+ * mode = 2: merge identical parents
+ */
+static int __merge_refs(struct list_head *head, int mode)
+{
+	struct list_head *pos1;
+
+	list_for_each(pos1, head) {
+		struct list_head *n2;
+		struct list_head *pos2;
+		struct __prelim_ref *ref1;
+
+		ref1 = list_entry(pos1, struct __prelim_ref, list);
+
+		if (mode == 1 && ref1->key.type == 0)
+			continue;
+		for (pos2 = pos1->next, n2 = pos2->next; pos2 != head;
+		     pos2 = n2, n2 = pos2->next) {
+			struct __prelim_ref *ref2;
+
+			ref2 = list_entry(pos2, struct __prelim_ref, list);
+
+			if (mode == 1) {
+				if (memcmp(&ref1->key, &ref2->key,
+					   sizeof(ref1->key)) ||
+				    ref1->level != ref2->level ||
+				    ref1->root_id != ref2->root_id)
+					continue;
+				ref1->count += ref2->count;
+			} else {
+				if (ref1->parent != ref2->parent)
+					continue;
+				ref1->count += ref2->count;
+			}
+			list_del(&ref2->list);
+			kfree(ref2);
+		}
+
+	}
+	return 0;
+}
+
+/*
+ * add all currently queued delayed refs from this head whose seq nr is
+ * smaller or equal that seq to the list
+ */
+static int __add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
+			      struct btrfs_key *info_key,
+			      struct list_head *prefs)
+{
+	struct btrfs_delayed_extent_op *extent_op = head->extent_op;
+	struct rb_node *n = &head->node.rb_node;
+	int sgn;
+	int ret;
+
+	if (extent_op && extent_op->update_key)
+		btrfs_disk_key_to_cpu(info_key, &extent_op->key);
+
+	while ((n = rb_prev(n))) {
+		struct btrfs_delayed_ref_node *node;
+		node = rb_entry(n, struct btrfs_delayed_ref_node,
+				rb_node);
+		if (node->bytenr != head->node.bytenr)
+			break;
+		WARN_ON(node->is_head);
+
+		if (node->seq > seq)
+			continue;
+
+		switch (node->action) {
+		case BTRFS_ADD_DELAYED_EXTENT:
+		case BTRFS_UPDATE_DELAYED_HEAD:
+			WARN_ON(1);
+			continue;
+		case BTRFS_ADD_DELAYED_REF:
+			sgn = 1;
+			break;
+		case BTRFS_DROP_DELAYED_REF:
+			sgn = -1;
+			break;
+		default:
+			BUG_ON(1);
+		}
+		switch (node->type) {
+		case BTRFS_TREE_BLOCK_REF_KEY: {
+			struct btrfs_delayed_tree_ref *ref;
+
+			ref = btrfs_delayed_node_to_tree_ref(node);
+			ret = __add_prelim_ref(prefs, ref->root, info_key,
+					       ref->level + 1, 0, node->bytenr,
+					       node->ref_mod * sgn);
+			break;
+		}
+		case BTRFS_SHARED_BLOCK_REF_KEY: {
+			struct btrfs_delayed_tree_ref *ref;
+
+			ref = btrfs_delayed_node_to_tree_ref(node);
+			ret = __add_prelim_ref(prefs, ref->root, info_key,
+					       ref->level + 1, ref->parent,
+					       node->bytenr,
+					       node->ref_mod * sgn);
+			break;
+		}
+		case BTRFS_EXTENT_DATA_REF_KEY: {
+			struct btrfs_delayed_data_ref *ref;
+			struct btrfs_key key;
+
+			ref = btrfs_delayed_node_to_data_ref(node);
+
+			key.objectid = ref->objectid;
+			key.type = BTRFS_EXTENT_DATA_KEY;
+			key.offset = ref->offset;
+			ret = __add_prelim_ref(prefs, ref->root, &key, 0, 0,
+					       node->bytenr,
+					       node->ref_mod * sgn);
+			break;
+		}
+		case BTRFS_SHARED_DATA_REF_KEY: {
+			struct btrfs_delayed_data_ref *ref;
+			struct btrfs_key key;
+
+			ref = btrfs_delayed_node_to_data_ref(node);
+
+			key.objectid = ref->objectid;
+			key.type = BTRFS_EXTENT_DATA_KEY;
+			key.offset = ref->offset;
+			ret = __add_prelim_ref(prefs, ref->root, &key, 0,
+					       ref->parent, node->bytenr,
+					       node->ref_mod * sgn);
+			break;
+		}
+		default:
+			WARN_ON(1);
+		}
+		BUG_ON(ret);
+	}
+
+	return 0;
+}
+
+/*
+ * add all inline backrefs for bytenr to the list
+ */
+static int __add_inline_refs(struct btrfs_fs_info *fs_info,
+			     struct btrfs_path *path, u64 bytenr,
+			     struct btrfs_key *info_key, int *info_level,
+			     struct list_head *prefs)
+{
+	int ret;
+	int slot;
+	struct extent_buffer *leaf;
+	struct btrfs_key key;
+	unsigned long ptr;
+	unsigned long end;
+	struct btrfs_extent_item *ei;
+	u64 flags;
+	u64 item_size;
+
+	/*
+	 * enumerate all inline refs
+	 */
+	leaf = path->nodes[0];
+	slot = path->slots[0] - 1;
+
+	item_size = btrfs_item_size_nr(leaf, slot);
+	BUG_ON(item_size < sizeof(*ei));
+
+	ei = btrfs_item_ptr(leaf, slot, struct btrfs_extent_item);
+	flags = btrfs_extent_flags(leaf, ei);
+
+	ptr = (unsigned long)(ei + 1);
+	end = (unsigned long)ei + item_size;
+
+	if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
+		struct btrfs_tree_block_info *info;
+		struct btrfs_disk_key disk_key;
+
+		info = (struct btrfs_tree_block_info *)ptr;
+		*info_level = btrfs_tree_block_level(leaf, info);
+		btrfs_tree_block_key(leaf, info, &disk_key);
+		btrfs_disk_key_to_cpu(info_key, &disk_key);
+		ptr += sizeof(struct btrfs_tree_block_info);
+		BUG_ON(ptr > end);
+	} else {
+		BUG_ON(!(flags & BTRFS_EXTENT_FLAG_DATA));
+	}
+
+	while (ptr < end) {
+		struct btrfs_extent_inline_ref *iref;
+		u64 offset;
+		int type;
+
+		iref = (struct btrfs_extent_inline_ref *)ptr;
+		type = btrfs_extent_inline_ref_type(leaf, iref);
+		offset = btrfs_extent_inline_ref_offset(leaf, iref);
+
+		switch (type) {
+		case BTRFS_SHARED_BLOCK_REF_KEY:
+			ret = __add_prelim_ref(prefs, 0, info_key,
+						*info_level + 1, offset,
+						bytenr, 1);
+			break;
+		case BTRFS_SHARED_DATA_REF_KEY: {
+			struct btrfs_shared_data_ref *sdref;
+			int count;
+
+			sdref = (struct btrfs_shared_data_ref *)(iref + 1);
+			count = btrfs_shared_data_ref_count(leaf, sdref);
+			ret = __add_prelim_ref(prefs, 0, NULL, 0, offset,
+					       bytenr, count);
+			break;
+		}
+		case BTRFS_TREE_BLOCK_REF_KEY:
+			ret = __add_prelim_ref(prefs, offset, info_key,
+					       *info_level + 1, 0, bytenr, 1);
+			break;
+		case BTRFS_EXTENT_DATA_REF_KEY: {
+			struct btrfs_extent_data_ref *dref;
+			int count;
+			u64 root;
+
+			dref = (struct btrfs_extent_data_ref *)(&iref->offset);
+			count = btrfs_extent_data_ref_count(leaf, dref);
+			key.objectid = btrfs_extent_data_ref_objectid(leaf,
+								      dref);
+			key.type = BTRFS_EXTENT_DATA_KEY;
+			key.offset = btrfs_extent_data_ref_offset(leaf, dref);
+			root = btrfs_extent_data_ref_root(leaf, dref);
+			ret = __add_prelim_ref(prefs, root, &key, 0, 0, bytenr,
+						count);
+			break;
+		}
+		default:
+			WARN_ON(1);
+		}
+		BUG_ON(ret);
+		ptr += btrfs_extent_inline_ref_size(type);
+	}
+
+	return 0;
+}
+
+/*
+ * add all non-inline backrefs for bytenr to the list
+ */
+static int __add_keyed_refs(struct btrfs_fs_info *fs_info,
+			    struct btrfs_path *path, u64 bytenr,
+			    struct btrfs_key *info_key, int info_level,
+			    struct list_head *prefs)
+{
+	struct btrfs_root *extent_root = fs_info->extent_root;
+	int ret;
+	int slot;
+	struct extent_buffer *leaf;
+	struct btrfs_key key;
+
+	while (1) {
+		ret = btrfs_next_item(extent_root, path);
+		if (ret < 0)
+			break;
+		if (ret) {
+			ret = 0;
+			break;
+		}
+
+		slot = path->slots[0];
+		leaf = path->nodes[0];
+		btrfs_item_key_to_cpu(leaf, &key, slot);
+
+		if (key.objectid != bytenr)
+			break;
+		if (key.type < BTRFS_TREE_BLOCK_REF_KEY)
+			continue;
+		if (key.type > BTRFS_SHARED_DATA_REF_KEY)
+			break;
+
+		switch (key.type) {
+		case BTRFS_SHARED_BLOCK_REF_KEY:
+			ret = __add_prelim_ref(prefs, 0, info_key,
+						info_level + 1, key.offset,
+						bytenr, 1);
+			break;
+		case BTRFS_SHARED_DATA_REF_KEY: {
+			struct btrfs_shared_data_ref *sdref;
+			int count;
+
+			sdref = btrfs_item_ptr(leaf, slot,
+					      struct btrfs_shared_data_ref);
+			count = btrfs_shared_data_ref_count(leaf, sdref);
+			ret = __add_prelim_ref(prefs, 0, NULL, 0, key.offset,
+						bytenr, count);
+			break;
+		}
+		case BTRFS_TREE_BLOCK_REF_KEY:
+			ret = __add_prelim_ref(prefs, key.offset, info_key,
+						info_level + 1, 0, bytenr, 1);
+			break;
+		case BTRFS_EXTENT_DATA_REF_KEY: {
+			struct btrfs_extent_data_ref *dref;
+			int count;
+			u64 root;
+
+			dref = btrfs_item_ptr(leaf, slot,
+					      struct btrfs_extent_data_ref);
+			count = btrfs_extent_data_ref_count(leaf, dref);
+			key.objectid = btrfs_extent_data_ref_objectid(leaf,
+								      dref);
+			key.type = BTRFS_EXTENT_DATA_KEY;
+			key.offset = btrfs_extent_data_ref_offset(leaf, dref);
+			root = btrfs_extent_data_ref_root(leaf, dref);
+			ret = __add_prelim_ref(prefs, root, &key, 0, 0,
+						bytenr, count);
+			break;
+		}
+		default:
+			WARN_ON(1);
+		}
+		BUG_ON(ret);
+	}
+
+	return ret;
+}
+
+/*
+ * this adds all existing backrefs (inline backrefs, backrefs and delayed
+ * refs) for the given bytenr to the refs list, merges duplicates and resolves
+ * indirect refs to their parent bytenr.
+ * When roots are found, they're added to the roots list
+ *
+ * FIXME some caching might speed things up
+ */
+static int find_parent_nodes(struct btrfs_trans_handle *trans,
+			     struct btrfs_fs_info *fs_info, u64 bytenr,
+			     u64 seq, struct ulist *refs, struct ulist *roots)
+{
+	struct btrfs_key key;
+	struct btrfs_path *path;
+	struct btrfs_key info_key = { 0 };
+	struct btrfs_delayed_ref_root *delayed_refs = NULL;
+	struct btrfs_delayed_ref_head *head = NULL;
+	int info_level = 0;
+	int ret;
+	struct list_head prefs_delayed;
+	struct list_head prefs;
+	struct __prelim_ref *ref;
+
+	INIT_LIST_HEAD(&prefs);
+	INIT_LIST_HEAD(&prefs_delayed);
+
+	key.objectid = bytenr;
+	key.type = BTRFS_EXTENT_ITEM_KEY;
+	key.offset = (u64)-1;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	/*
+	 * grab both a lock on the path and a lock on the delayed ref head.
+	 * We need both to get a consistent picture of how the refs look
+	 * at a specified point in time
+	 */
+again:
+	ret = btrfs_search_slot(trans, fs_info->extent_root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+	BUG_ON(ret == 0);
+
+	/*
+	 * look if there are updates for this ref queued and lock the head
+	 */
+	delayed_refs = &trans->transaction->delayed_refs;
+	spin_lock(&delayed_refs->lock);
+	head = btrfs_find_delayed_ref_head(trans, bytenr);
+	if (head) {
+		if (!mutex_trylock(&head->mutex)) {
+			atomic_inc(&head->node.refs);
+			spin_unlock(&delayed_refs->lock);
+
+			btrfs_release_path(path);
+
+			/*
+			 * Mutex was contended, block until it's
+			 * released and try again
+			 */
+			mutex_lock(&head->mutex);
+			mutex_unlock(&head->mutex);
+			btrfs_put_delayed_ref(&head->node);
+			goto again;
+		}
+		ret = __add_delayed_refs(head, seq, &info_key, &prefs_delayed);
+		if (ret)
+			goto out;
+	}
+	spin_unlock(&delayed_refs->lock);
+
+	if (path->slots[0]) {
+		struct extent_buffer *leaf;
+		int slot;
+
+		leaf = path->nodes[0];
+		slot = path->slots[0] - 1;
+		btrfs_item_key_to_cpu(leaf, &key, slot);
+		if (key.objectid == bytenr &&
+		    key.type == BTRFS_EXTENT_ITEM_KEY) {
+			ret = __add_inline_refs(fs_info, path, bytenr,
+						&info_key, &info_level, &prefs);
+			if (ret)
+				goto out;
+			ret = __add_keyed_refs(fs_info, path, bytenr, &info_key,
+					       info_level, &prefs);
+			if (ret)
+				goto out;
+		}
+	}
+	btrfs_release_path(path);
+
+	/*
+	 * when adding the delayed refs above, the info_key might not have
+	 * been known yet. Go over the list and replace the missing keys
+	 */
+	list_for_each_entry(ref, &prefs_delayed, list) {
+		if ((ref->key.offset | ref->key.type | ref->key.objectid) == 0)
+			memcpy(&ref->key, &info_key, sizeof(ref->key));
+	}
+	list_splice_init(&prefs_delayed, &prefs);
+
+	ret = __merge_refs(&prefs, 1);
+	if (ret)
+		goto out;
+
+	ret = __resolve_indirect_refs(fs_info, &prefs);
+	if (ret)
+		goto out;
+
+	ret = __merge_refs(&prefs, 2);
+	if (ret)
+		goto out;
+
+	while (!list_empty(&prefs)) {
+		ref = list_first_entry(&prefs, struct __prelim_ref, list);
+		list_del(&ref->list);
+		if (ref->count < 0)
+			WARN_ON(1);
+		if (ref->count && ref->root_id && ref->parent == 0) {
+			/* no parent == root of tree */
+			ret = ulist_add(roots, ref->root_id, 0, GFP_NOFS);
+			BUG_ON(ret < 0);
+		}
+		if (ref->count && ref->parent) {
+			ret = ulist_add(refs, ref->parent, 0, GFP_NOFS);
+			BUG_ON(ret < 0);
+		}
+		kfree(ref);
+	}
+
+out:
+	if (head)
+		mutex_unlock(&head->mutex);
+	btrfs_free_path(path);
+	while (!list_empty(&prefs)) {
+		ref = list_first_entry(&prefs, struct __prelim_ref, list);
+		list_del(&ref->list);
+		kfree(ref);
+	}
+	while (!list_empty(&prefs_delayed)) {
+		ref = list_first_entry(&prefs_delayed, struct __prelim_ref,
+				       list);
+		list_del(&ref->list);
+		kfree(ref);
+	}
+
+	return ret;
+}
+
+/*
+ * Finds all leafs with a reference to the specified combination of bytenr and
+ * offset. key_list_head will point to a list of corresponding keys (caller must
+ * free each list element). The leafs will be stored in the leafs ulist, which
+ * must be freed with ulist_free.
+ *
+ * returns 0 on success, <0 on error
+ */
+static int btrfs_find_all_leafs(struct btrfs_trans_handle *trans,
+				struct btrfs_fs_info *fs_info, u64 bytenr,
+				u64 num_bytes, u64 seq, struct ulist **leafs)
+{
+	struct ulist *tmp;
+	int ret;
+
+	tmp = ulist_alloc(GFP_NOFS);
+	if (!tmp)
+		return -ENOMEM;
+	*leafs = ulist_alloc(GFP_NOFS);
+	if (!*leafs) {
+		ulist_free(tmp);
+		return -ENOMEM;
+	}
+
+	ret = find_parent_nodes(trans, fs_info, bytenr, seq, *leafs, tmp);
+	ulist_free(tmp);
+
+	if (ret < 0 && ret != -ENOENT) {
+		ulist_free(*leafs);
+		return ret;
+	}
+
+	return 0;
+}
+
+/*
+ * walk all backrefs for a given extent to find all roots that reference this
+ * extent. Walking a backref means finding all extents that reference this
+ * extent and in turn walk the backrefs of those, too. Naturally this is a
+ * recursive process, but here it is implemented in an iterative fashion: We
+ * find all referencing extents for the extent in question and put them on a
+ * list. In turn, we find all referencing extents for those, further appending
+ * to the list. The way we iterate the list allows adding more elements after
+ * the current while iterating. The process stops when we reach the end of the
+ * list. Found roots are added to the roots list.
+ *
+ * returns 0 on success, < 0 on error.
+ */
+int btrfs_find_all_roots(struct btrfs_trans_handle *trans,
+				struct btrfs_fs_info *fs_info, u64 bytenr,
+				u64 num_bytes, u64 seq, struct ulist **roots)
+{
+	struct ulist *tmp;
+	struct ulist_node *node = NULL;
+	int ret;
+
+	tmp = ulist_alloc(GFP_NOFS);
+	if (!tmp)
+		return -ENOMEM;
+	*roots = ulist_alloc(GFP_NOFS);
+	if (!*roots) {
+		ulist_free(tmp);
+		return -ENOMEM;
+	}
+
+	while (1) {
+		ret = find_parent_nodes(trans, fs_info, bytenr, seq,
+					tmp, *roots);
+		if (ret < 0 && ret != -ENOENT) {
+			ulist_free(tmp);
+			ulist_free(*roots);
+			return ret;
+		}
+		node = ulist_next(tmp, node);
+		if (!node)
+			break;
+		bytenr = node->val;
+	}
+
+	ulist_free(tmp);
+	return 0;
+}
+
+
 static int __inode_info(u64 inum, u64 ioff, u8 key_type,
 			struct btrfs_root *fs_root, struct btrfs_path *path,
 			struct btrfs_key *found_key)
diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
index 9261883..d00dfa9 100644
--- a/fs/btrfs/backref.h
+++ b/fs/btrfs/backref.h
@@ -20,6 +20,7 @@
 #define __BTRFS_BACKREF__
 
 #include "ioctl.h"
+#include "ulist.h"
 
 struct inode_fs_paths {
 	struct btrfs_path		*btrfs_path;
@@ -54,6 +55,10 @@ int iterate_inodes_from_logical(u64 logical, struct btrfs_fs_info *fs_info,
 
 int paths_from_inode(u64 inum, struct inode_fs_paths *ipath);
 
+int btrfs_find_all_roots(struct btrfs_trans_handle *trans,
+				struct btrfs_fs_info *fs_info, u64 bytenr,
+				u64 num_bytes, u64 seq, struct ulist **roots);
+
 struct btrfs_data_container *init_data_container(u32 total_bytes);
 struct inode_fs_paths *init_ipath(s32 total_bytes, struct btrfs_root *fs_root,
 					struct btrfs_path *path);
-- 
1.7.3.4

