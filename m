From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH 3/6] btrfs: update delayed back ref for the mixed back ref
Date: Mon, 11 May 2009 23:24:52 +0800
Message-ID: <4A084344.4070603@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch updates the delayed back ref for the mixed back ref.
It defines different data structures and interfaces for tree
block and file data.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 3/fs/btrfs/delayed-ref.c 4/fs/btrfs/delayed-ref.c
--- 3/fs/btrfs/delayed-ref.c	2009-05-11 16:54:52.000000000 +0800
+++ 4/fs/btrfs/delayed-ref.c	2009-05-11 16:44:39.000000000 +0800
@@ -29,27 +29,87 @@
  * add extents in the middle of btrfs_search_slot, and it allows
  * us to buffer up frequently modified backrefs in an rb tree instead
  * of hammering updates on the extent allocation tree.
- *
- * Right now this code is only used for reference counted trees, but
- * the long term goal is to get rid of the similar code for delayed
- * extent tree modifications.
  */
 
 /*
- * entries in the rb tree are ordered by the byte number of the extent
- * and by the byte number of the parent block.
+ * compare two delayed tree backrefs with same bytenr and type
+ */
+static int comp_tree_refs(struct btrfs_delayed_tree_ref *ref2,
+			  struct btrfs_delayed_tree_ref *ref1)
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
+/*
+ * compare two delayed data backrefs with same bytenr and type
+ */
+static int comp_data_refs(struct btrfs_delayed_data_ref *ref2,
+			  struct btrfs_delayed_data_ref *ref1)
+{
+	if (ref1->node.type == BTRFS_EXTENT_DATA_REF_KEY) {
+		if (ref1->root < ref2->root)
+			return -1;
+		if (ref1->root > ref2->root)
+			return 1;
+		if (ref1->objectid < ref2->objectid)
+			return -1;
+		if (ref1->objectid > ref2->objectid)
+			return 1;
+		if (ref1->offset < ref2->offset)
+			return -1;
+		if (ref1->offset > ref2->offset)
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
+/*
+ * entries in the rb tree are ordered by the byte number of the extent,
+ * type of the delayed backrefs and content of delayed backrefs.
  */
-static int comp_entry(struct btrfs_delayed_ref_node *ref,
-		      u64 bytenr, u64 parent)
+static int comp_entry(struct btrfs_delayed_ref_node *ref2,
+		      struct btrfs_delayed_ref_node *ref1)
 {
-	if (bytenr < ref->bytenr)
+	if (ref1->bytenr < ref2->bytenr)
 		return -1;
-	if (bytenr > ref->bytenr)
+	if (ref1->bytenr > ref2->bytenr)
 		return 1;
-	if (parent < ref->parent)
+	if (ref1->is_head && ref2->is_head)
+		return 0;
+	if (ref2->is_head)
+		return -1;
+	if (ref1->is_head)
+		return 1;
+	if (ref1->type < ref2->type)
 		return -1;
-	if (parent > ref->parent)
+	if (ref1->type > ref2->type)
 		return 1;
+	if (ref1->type == BTRFS_TREE_BLOCK_REF_KEY ||
+	    ref1->type == BTRFS_SHARED_BLOCK_REF_KEY) {
+		return comp_tree_refs(btrfs_delayed_node_to_tree_ref(ref2),
+				      btrfs_delayed_node_to_tree_ref(ref1));
+	} else if (ref1->type == BTRFS_EXTENT_DATA_REF_KEY ||
+		   ref1->type == BTRFS_SHARED_DATA_REF_KEY) {
+		return comp_data_refs(btrfs_delayed_node_to_data_ref(ref2),
+				      btrfs_delayed_node_to_data_ref(ref1));
+	}
+	BUG();
 	return 0;
 }
 
@@ -59,20 +119,21 @@ static int comp_entry(struct btrfs_delay
  * inserted.
  */
 static struct btrfs_delayed_ref_node *tree_insert(struct rb_root *root,
-						  u64 bytenr, u64 parent,
 						  struct rb_node *node)
 {
 	struct rb_node **p = &root->rb_node;
 	struct rb_node *parent_node = NULL;
 	struct btrfs_delayed_ref_node *entry;
+	struct btrfs_delayed_ref_node *ins;
 	int cmp;
 
+	ins = rb_entry(node, struct btrfs_delayed_ref_node, rb_node);
 	while (*p) {
 		parent_node = *p;
 		entry = rb_entry(parent_node, struct btrfs_delayed_ref_node,
 				 rb_node);
 
-		cmp = comp_entry(entry, bytenr, parent);
+		cmp = comp_entry(entry, ins);
 		if (cmp < 0)
 			p = &(*p)->rb_left;
 		else if (cmp > 0)
@@ -81,18 +142,17 @@ static struct btrfs_delayed_ref_node *tr
 			return entry;
 	}
 
-	entry = rb_entry(node, struct btrfs_delayed_ref_node, rb_node);
 	rb_link_node(node, parent_node, p);
 	rb_insert_color(node, root);
 	return NULL;
 }
 
 /*
- * find an entry based on (bytenr,parent).  This returns the delayed
- * ref if it was able to find one, or NULL if nothing was in that spot
+ * find an head entry based on bytenr. This returns the delayed ref
+ * head if it was able to find one, or NULL if nothing was in that spot
  */
-static struct btrfs_delayed_ref_node *tree_search(struct rb_root *root,
-				  u64 bytenr, u64 parent,
+static struct btrfs_delayed_ref_node *find_ref_head(struct rb_root *root,
+				  u64 bytenr,
 				  struct btrfs_delayed_ref_node **last)
 {
 	struct rb_node *n = root->rb_node;
@@ -105,7 +165,15 @@ static struct btrfs_delayed_ref_node *tr
 		if (last)
 			*last = entry;
 
-		cmp = comp_entry(entry, bytenr, parent);
+		if (bytenr < entry->bytenr)
+			cmp = -1;
+		else if (bytenr > entry->bytenr)
+			cmp = 1;
+		else if (!btrfs_delayed_ref_is_head(entry))
+			cmp = 1;
+		else
+			cmp = 0;
+
 		if (cmp < 0)
 			n = n->rb_left;
 		else if (cmp > 0)
@@ -154,7 +222,7 @@ int btrfs_find_ref_cluster(struct btrfs_
 		node = rb_first(&delayed_refs->root);
 	} else {
 		ref = NULL;
-		tree_search(&delayed_refs->root, start, (u64)-1, &ref);
+		find_ref_head(&delayed_refs->root, start, &ref);
 		if (ref) {
 			struct btrfs_delayed_ref_node *tmp;
 
@@ -234,7 +302,7 @@ int btrfs_delayed_ref_pending(struct btr
 	delayed_refs = &trans->transaction->delayed_refs;
 	spin_lock(&delayed_refs->lock);
 
-	ref = tree_search(&delayed_refs->root, bytenr, (u64)-1, NULL);
+	ref = find_ref_head(&delayed_refs->root, bytenr, NULL);
 	if (ref) {
 		prev_node = rb_prev(&ref->rb_node);
 		if (!prev_node)
@@ -250,16 +318,17 @@ out:
 }
 
 /*
- * helper function to lookup reference count
+ * helper function to lookup reference count and flags of extent.
  *
  * the head node for delayed ref is used to store the sum of all the
- * reference count modifications queued up in the rbtree.  This way you
- * can check to see what the reference count would be if all of the
- * delayed refs are processed.
- */
-int btrfs_lookup_extent_ref(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root, u64 bytenr,
-			    u64 num_bytes, u32 *refs)
+ * reference count modifications queued up in the rbtree. the head
+ * node may also store the extent flags to set. This way you can check
+ * to see what the reference count and extent flags would be if all of
+ * the delayed refs are not processed.
+ */
+int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
+			     struct btrfs_root *root, u64 bytenr,
+			     u64 num_bytes, u64 *refs, u64 *flags)
 {
 	struct btrfs_delayed_ref_node *ref;
 	struct btrfs_delayed_ref_head *head;
@@ -268,7 +337,8 @@ int btrfs_lookup_extent_ref(struct btrfs
 	struct extent_buffer *leaf;
 	struct btrfs_extent_item *ei;
 	struct btrfs_key key;
-	u32 num_refs;
+	u64 num_refs;
+	u64 extent_flags;
 	int ret;
 
 	path = btrfs_alloc_path();
@@ -290,34 +360,42 @@ again:
 		ei = btrfs_item_ptr(leaf, path->slots[0],
 				    struct btrfs_extent_item);
 		num_refs = btrfs_extent_refs(leaf, ei);
+		extent_flags = btrfs_extent_flags(leaf, ei);
+		BUG_ON(num_refs == 0);
 	} else {
 		num_refs = 0;
+		extent_flags = 0;
 		ret = 0;
 	}
 
+
 	spin_lock(&delayed_refs->lock);
-	ref = tree_search(&delayed_refs->root, bytenr, (u64)-1, NULL);
+	ref = find_ref_head(&delayed_refs->root, bytenr, NULL);
 	if (ref) {
 		head = btrfs_delayed_node_to_head(ref);
-		if (mutex_trylock(&head->mutex)) {
-			num_refs += ref->ref_mod;
-			mutex_unlock(&head->mutex);
-			*refs = num_refs;
-			goto out;
-		}
+		if (!mutex_trylock(&head->mutex)) {
+			atomic_inc(&ref->refs);
+			spin_unlock(&delayed_refs->lock);
 
-		atomic_inc(&ref->refs);
-		spin_unlock(&delayed_refs->lock);
+			btrfs_release_path(root->fs_info->extent_root, path);
 
-		btrfs_release_path(root->fs_info->extent_root, path);
+			mutex_lock(&head->mutex);
+			mutex_unlock(&head->mutex);
+			btrfs_put_delayed_ref(ref);
+			goto again;
+		}
+		if (head->extent_op && head->extent_op->update_flags)
+			extent_flags |= head->extent_op->flags_to_set;
+		else
+			BUG_ON(num_refs == 0);
 
-		mutex_lock(&head->mutex);
+		num_refs += ref->ref_mod;
 		mutex_unlock(&head->mutex);
-		btrfs_put_delayed_ref(ref);
-		goto again;
-	} else {
-		*refs = num_refs;
 	}
+	if (refs)
+		*refs = num_refs;
+	if (flags)
+		*flags = extent_flags;
 out:
 	spin_unlock(&delayed_refs->lock);
 	btrfs_free_path(path);
@@ -338,16 +416,7 @@ update_existing_ref(struct btrfs_trans_h
 		    struct btrfs_delayed_ref_node *existing,
 		    struct btrfs_delayed_ref_node *update)
 {
-	struct btrfs_delayed_ref *existing_ref;
-	struct btrfs_delayed_ref *ref;
-
-	existing_ref = btrfs_delayed_node_to_ref(existing);
-	ref = btrfs_delayed_node_to_ref(update);
-
-	if (ref->pin)
-		existing_ref->pin = 1;
-
-	if (ref->action != existing_ref->action) {
+	if (update->action != existing->action) {
 		/*
 		 * this is effectively undoing either an add or a
 		 * drop.  We decrement the ref_mod, and if it goes
@@ -363,20 +432,13 @@ update_existing_ref(struct btrfs_trans_h
 			delayed_refs->num_entries--;
 			if (trans->delayed_ref_updates)
 				trans->delayed_ref_updates--;
+		} else {
+			WARN_ON(existing->type == BTRFS_TREE_BLOCK_REF_KEY ||
+				existing->type == BTRFS_SHARED_BLOCK_REF_KEY);
 		}
 	} else {
-		if (existing_ref->action == BTRFS_ADD_DELAYED_REF) {
-			/* if we're adding refs, make sure all the
-			 * details match up.  The extent could
-			 * have been totally freed and reallocated
-			 * by a different owner before the delayed
-			 * ref entries were removed.
-			 */
-			existing_ref->owner_objectid = ref->owner_objectid;
-			existing_ref->generation = ref->generation;
-			existing_ref->root = ref->root;
-			existing->num_bytes = update->num_bytes;
-		}
+		WARN_ON(existing->type == BTRFS_TREE_BLOCK_REF_KEY ||
+			existing->type == BTRFS_SHARED_BLOCK_REF_KEY);
 		/*
 		 * the action on the existing ref matches
 		 * the action on the ref we're trying to add.
@@ -420,6 +482,24 @@ update_existing_head_ref(struct btrfs_de
 
 	}
 
+	if (ref->extent_op) {
+		if (!existing_ref->extent_op) {
+			existing_ref->extent_op = ref->extent_op;
+		} else {
+			if (ref->extent_op->update_key) {
+				memcpy(&existing_ref->extent_op->key,
+				       &ref->extent_op->key,
+				       sizeof(ref->extent_op->key));
+				existing_ref->extent_op->update_key = 1;
+			}
+			if (ref->extent_op->update_flags) {
+				existing_ref->extent_op->flags_to_set |=
+					ref->extent_op->flags_to_set;
+				existing_ref->extent_op->update_flags = 1;
+			}
+			kfree(ref->extent_op);
+		}
+	}
 	/*
 	 * update the reference mod on the head to reflect this new operation
 	 */
@@ -427,19 +507,15 @@ update_existing_head_ref(struct btrfs_de
 }
 
 /*
- * helper function to actually insert a delayed ref into the rbtree.
+ * helper function to actually insert a head node into the rbtree.
  * this does all the dirty work in terms of maintaining the correct
- * overall modification count in the head node and properly dealing
- * with updating existing nodes as new modifications are queued.
+ * overall modification count.
  */
-static noinline int __btrfs_add_delayed_ref(struct btrfs_trans_handle *trans,
-			  struct btrfs_delayed_ref_node *ref,
-			  u64 bytenr, u64 num_bytes, u64 parent, u64 ref_root,
-			  u64 ref_generation, u64 owner_objectid, int action,
-			  int pin)
+static noinline int add_delayed_ref_head(struct btrfs_trans_handle *trans,
+					struct btrfs_delayed_ref_node *ref,
+					u64 bytenr, u64 num_bytes, int action)
 {
 	struct btrfs_delayed_ref_node *existing;
-	struct btrfs_delayed_ref *full_ref;
 	struct btrfs_delayed_ref_head *head_ref = NULL;
 	struct btrfs_delayed_ref_root *delayed_refs;
 	int count_mod = 1;
@@ -449,12 +525,10 @@ static noinline int __btrfs_add_delayed_
 	 * the head node stores the sum of all the mods, so dropping a ref
 	 * should drop the sum in the head node by one.
 	 */
-	if (parent == (u64)-1) {
-		if (action == BTRFS_DROP_DELAYED_REF)
-			count_mod = -1;
-		else if (action == BTRFS_UPDATE_DELAYED_HEAD)
-			count_mod = 0;
-	}
+	if (action == BTRFS_UPDATE_DELAYED_HEAD)
+		count_mod = 0;
+	else if (action == BTRFS_DROP_DELAYED_REF)
+		count_mod = -1;
 
 	/*
 	 * BTRFS_ADD_DELAYED_EXTENT means that we need to update
@@ -467,57 +541,147 @@ static noinline int __btrfs_add_delayed_
 	 * Once we record must_insert_reserved, switch the action to
 	 * BTRFS_ADD_DELAYED_REF because other special casing is not required.
 	 */
-	if (action == BTRFS_ADD_DELAYED_EXTENT) {
+	if (action == BTRFS_ADD_DELAYED_EXTENT)
 		must_insert_reserved = 1;
-		action = BTRFS_ADD_DELAYED_REF;
-	} else {
+	else
 		must_insert_reserved = 0;
-	}
-
 
 	delayed_refs = &trans->transaction->delayed_refs;
 
 	/* first set the basic ref node struct up */
 	atomic_set(&ref->refs, 1);
 	ref->bytenr = bytenr;
-	ref->parent = parent;
+	ref->num_bytes = num_bytes;
 	ref->ref_mod = count_mod;
+	ref->type  = 0;
+	ref->action  = 0;
+	ref->is_head = 1;
 	ref->in_tree = 1;
+
+	head_ref = btrfs_delayed_node_to_head(ref);
+	head_ref->must_insert_reserved = must_insert_reserved;
+
+	INIT_LIST_HEAD(&head_ref->cluster);
+	mutex_init(&head_ref->mutex);
+
+	existing = tree_insert(&delayed_refs->root, &ref->rb_node);
+
+	if (existing) {
+		update_existing_head_ref(existing, ref);
+		/*
+		 * we've updated the existing ref, free the newly
+		 * allocated ref
+		 */
+		kfree(ref);
+	} else {
+		delayed_refs->num_heads++;
+		delayed_refs->num_heads_ready++;
+		delayed_refs->num_entries++;
+		trans->delayed_ref_updates++;
+	}
+	return 0;
+}
+
+/*
+ * helper to insert a delayed tree ref into the rbtree.
+ */
+static noinline int add_delayed_tree_ref(struct btrfs_trans_handle *trans,
+					 struct btrfs_delayed_ref_node *ref,
+					 u64 bytenr, u64 num_bytes, u64 parent,
+					 u64 ref_root, int level, int action)
+{
+	struct btrfs_delayed_ref_node *existing;
+	struct btrfs_delayed_tree_ref *full_ref;
+	struct btrfs_delayed_ref_root *delayed_refs;
+
+	if (action == BTRFS_ADD_DELAYED_EXTENT)
+		action = BTRFS_ADD_DELAYED_REF;
+
+	delayed_refs = &trans->transaction->delayed_refs;
+
+	/* first set the basic ref node struct up */
+	atomic_set(&ref->refs, 1);
+	ref->bytenr = bytenr;
 	ref->num_bytes = num_bytes;
+	ref->ref_mod = 1;
+	ref->action = action;
+	ref->is_head = 0;
+	ref->in_tree = 1;
 
-	if (btrfs_delayed_ref_is_head(ref)) {
-		head_ref = btrfs_delayed_node_to_head(ref);
-		head_ref->must_insert_reserved = must_insert_reserved;
-		INIT_LIST_HEAD(&head_ref->cluster);
-		mutex_init(&head_ref->mutex);
+	full_ref = btrfs_delayed_node_to_tree_ref(ref);
+	if (parent) {
+		full_ref->parent = parent;
+		ref->type = BTRFS_SHARED_BLOCK_REF_KEY;
 	} else {
-		full_ref = btrfs_delayed_node_to_ref(ref);
 		full_ref->root = ref_root;
-		full_ref->generation = ref_generation;
-		full_ref->owner_objectid = owner_objectid;
-		full_ref->pin = pin;
-		full_ref->action = action;
+		ref->type = BTRFS_TREE_BLOCK_REF_KEY;
 	}
+	full_ref->level = level;
 
-	existing = tree_insert(&delayed_refs->root, bytenr,
-			       parent, &ref->rb_node);
+	existing = tree_insert(&delayed_refs->root, &ref->rb_node);
 
 	if (existing) {
-		if (btrfs_delayed_ref_is_head(ref))
-			update_existing_head_ref(existing, ref);
-		else
-			update_existing_ref(trans, delayed_refs, existing, ref);
+		update_existing_ref(trans, delayed_refs, existing, ref);
+		/*
+		 * we've updated the existing ref, free the newly
+		 * allocated ref
+		 */
+		kfree(ref);
+	} else {
+		delayed_refs->num_entries++;
+		trans->delayed_ref_updates++;
+	}
+	return 0;
+}
+
+/*
+ * helper to insert a delayed data ref into the rbtree.
+ */
+static noinline int add_delayed_data_ref(struct btrfs_trans_handle *trans,
+					 struct btrfs_delayed_ref_node *ref,
+					 u64 bytenr, u64 num_bytes, u64 parent,
+					 u64 ref_root, u64 owner, u64 offset,
+					 int action)
+{
+	struct btrfs_delayed_ref_node *existing;
+	struct btrfs_delayed_data_ref *full_ref;
+	struct btrfs_delayed_ref_root *delayed_refs;
+
+	if (action == BTRFS_ADD_DELAYED_EXTENT)
+		action = BTRFS_ADD_DELAYED_REF;
+
+	delayed_refs = &trans->transaction->delayed_refs;
+
+	/* first set the basic ref node struct up */
+	atomic_set(&ref->refs, 1);
+	ref->bytenr = bytenr;
+	ref->num_bytes = num_bytes;
+	ref->ref_mod = 1;
+	ref->action = action;
+	ref->is_head = 0;
+	ref->in_tree = 1;
+
+	full_ref = btrfs_delayed_node_to_data_ref(ref);
+	if (parent) {
+		full_ref->parent = parent;
+		ref->type = BTRFS_SHARED_DATA_REF_KEY;
+	} else {
+		full_ref->root = ref_root;
+		ref->type = BTRFS_EXTENT_DATA_REF_KEY;
+	}
+	full_ref->objectid = owner;
+	full_ref->offset = offset;
+
+	existing = tree_insert(&delayed_refs->root, &ref->rb_node);
 
+	if (existing) {
+		update_existing_ref(trans, delayed_refs, existing, ref);
 		/*
 		 * we've updated the existing ref, free the newly
 		 * allocated ref
 		 */
 		kfree(ref);
 	} else {
-		if (btrfs_delayed_ref_is_head(ref)) {
-			delayed_refs->num_heads++;
-			delayed_refs->num_heads_ready++;
-		}
 		delayed_refs->num_entries++;
 		trans->delayed_ref_updates++;
 	}
@@ -525,16 +689,16 @@ static noinline int __btrfs_add_delayed_
 }
 
 /*
- * add a delayed ref to the tree.  This does all of the accounting required
+ * add a delayed tree ref.  This does all of the accounting required
  * to make sure the delayed ref is eventually processed before this
  * transaction commits.
  */
-int btrfs_add_delayed_ref(struct btrfs_trans_handle *trans,
-			  u64 bytenr, u64 num_bytes, u64 parent, u64 ref_root,
-			  u64 ref_generation, u64 owner_objectid, int action,
-			  int pin)
+int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
+			       u64 bytenr, u64 num_bytes, u64 parent,
+			       u64 ref_root,  int level, int action,
+			       struct btrfs_delayed_extent_op *extent_op)
 {
-	struct btrfs_delayed_ref *ref;
+	struct btrfs_delayed_tree_ref *ref;
 	struct btrfs_delayed_ref_head *head_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
 	int ret;
@@ -543,19 +707,58 @@ int btrfs_add_delayed_ref(struct btrfs_t
 	if (!ref)
 		return -ENOMEM;
 
+	head_ref = kmalloc(sizeof(*head_ref), GFP_NOFS);
+	if (!head_ref) {
+		kfree(ref);
+		return -ENOMEM;
+	}
+
+	head_ref->extent_op = extent_op;
+
+	delayed_refs = &trans->transaction->delayed_refs;
+	spin_lock(&delayed_refs->lock);
+
 	/*
-	 * the parent = 0 case comes from cases where we don't actually
-	 * know the parent yet.  It will get updated later via a add/drop
-	 * pair.
+	 * insert both the head node and the new ref without dropping
+	 * the spin lock
 	 */
-	if (parent == 0)
-		parent = bytenr;
+	ret = add_delayed_ref_head(trans, &head_ref->node, bytenr, num_bytes,
+				   action);
+	BUG_ON(ret);
+
+	ret = add_delayed_tree_ref(trans, &ref->node, bytenr, num_bytes,
+				   parent, ref_root, level, action);
+	BUG_ON(ret);
+	spin_unlock(&delayed_refs->lock);
+	return 0;
+}
+
+/*
+ * add a delayed data ref. it's similar to btrfs_add_delayed_tree_ref.
+ */
+int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
+			       u64 bytenr, u64 num_bytes,
+			       u64 parent, u64 ref_root,
+			       u64 owner, u64 offset, int action,
+			       struct btrfs_delayed_extent_op *extent_op)
+{
+	struct btrfs_delayed_data_ref *ref;
+	struct btrfs_delayed_ref_head *head_ref;
+	struct btrfs_delayed_ref_root *delayed_refs;
+	int ret;
+
+	ref = kmalloc(sizeof(*ref), GFP_NOFS);
+	if (!ref)
+		return -ENOMEM;
 
 	head_ref = kmalloc(sizeof(*head_ref), GFP_NOFS);
 	if (!head_ref) {
 		kfree(ref);
 		return -ENOMEM;
 	}
+
+	head_ref->extent_op = extent_op;
+
 	delayed_refs = &trans->transaction->delayed_refs;
 	spin_lock(&delayed_refs->lock);
 
@@ -563,18 +766,42 @@ int btrfs_add_delayed_ref(struct btrfs_t
 	 * insert both the head node and the new ref without dropping
 	 * the spin lock
 	 */
-	ret = __btrfs_add_delayed_ref(trans, &head_ref->node, bytenr, num_bytes,
-				      (u64)-1, 0, 0, 0, action, pin);
+	ret = add_delayed_ref_head(trans, &head_ref->node, bytenr, num_bytes,
+				   action);
 	BUG_ON(ret);
 
-	ret = __btrfs_add_delayed_ref(trans, &ref->node, bytenr, num_bytes,
-				      parent, ref_root, ref_generation,
-				      owner_objectid, action, pin);
+	ret = add_delayed_data_ref(trans, &ref->node, bytenr, num_bytes,
+				   parent, ref_root, owner, offset, action);
 	BUG_ON(ret);
 	spin_unlock(&delayed_refs->lock);
 	return 0;
 }
 
+int btrfs_add_delayed_extent_op(struct btrfs_trans_handle *trans,
+				u64 bytenr, u64 num_bytes,
+				struct btrfs_delayed_extent_op *extent_op)
+{
+	struct btrfs_delayed_ref_head *head_ref;
+	struct btrfs_delayed_ref_root *delayed_refs;
+	int ret;
+
+	head_ref = kmalloc(sizeof(*head_ref), GFP_NOFS);
+	if (!head_ref)
+		return -ENOMEM;
+
+	head_ref->extent_op = extent_op;
+
+	delayed_refs = &trans->transaction->delayed_refs;
+	spin_lock(&delayed_refs->lock);
+
+	ret = add_delayed_ref_head(trans, &head_ref->node, bytenr, num_bytes,
+				   BTRFS_UPDATE_DELAYED_HEAD);
+	BUG_ON(ret);
+
+	spin_unlock(&delayed_refs->lock);
+	return 0;
+}
+
 /*
  * this does a simple search for the head node for a given extent.
  * It must be called with the delayed ref spinlock held, and it returns
@@ -587,7 +814,7 @@ btrfs_find_delayed_ref_head(struct btrfs
 	struct btrfs_delayed_ref_root *delayed_refs;
 
 	delayed_refs = &trans->transaction->delayed_refs;
-	ref = tree_search(&delayed_refs->root, bytenr, (u64)-1, NULL);
+	ref = find_ref_head(&delayed_refs->root, bytenr, NULL);
 	if (ref)
 		return btrfs_delayed_node_to_head(ref);
 	return NULL;
@@ -603,6 +830,7 @@ btrfs_find_delayed_ref_head(struct btrfs
  *
  * It is the same as doing a ref add and delete in two separate calls.
  */
+#if 0
 int btrfs_update_delayed_ref(struct btrfs_trans_handle *trans,
 			  u64 bytenr, u64 num_bytes, u64 orig_parent,
 			  u64 parent, u64 orig_ref_root, u64 ref_root,
@@ -666,3 +894,4 @@ int btrfs_update_delayed_ref(struct btrf
 	spin_unlock(&delayed_refs->lock);
 	return 0;
 }
+#endif
diff -urp 3/fs/btrfs/delayed-ref.h 4/fs/btrfs/delayed-ref.h
--- 3/fs/btrfs/delayed-ref.h	2009-05-11 16:54:52.000000000 +0800
+++ 4/fs/btrfs/delayed-ref.h	2009-05-11 16:56:25.000000000 +0800
@@ -30,9 +30,6 @@ struct btrfs_delayed_ref_node {
 	/* the starting bytenr of the extent */
 	u64 bytenr;
 
-	/* the parent our backref will point to */
-	u64 parent;
-
 	/* the size of the extent */
 	u64 num_bytes;
 
@@ -50,10 +47,20 @@ struct btrfs_delayed_ref_node {
 	 */
 	int ref_mod;
 
+	unsigned int action:8;
+	unsigned int type:8;
 	/* is this node still in the rbtree? */
+	unsigned int is_head:1;
 	unsigned int in_tree:1;
 };
 
+struct btrfs_delayed_extent_op {
+	struct btrfs_disk_key key;
+	u64 flags_to_set;
+	unsigned int update_key:1;
+	unsigned int update_flags:1;
+};
+
 /*
  * the head refs are used to hold a lock on a given extent, which allows us
  * to make sure that only one process is running the delayed refs
@@ -71,6 +78,7 @@ struct btrfs_delayed_ref_head {
 
 	struct list_head cluster;
 
+	struct btrfs_delayed_extent_op *extent_op;
 	/*
 	 * when a new extent is allocated, it is just reserved in memory
 	 * The actual extent isn't inserted into the extent allocation tree
@@ -86,25 +94,23 @@ struct btrfs_delayed_ref_head {
 	unsigned int must_insert_reserved:1;
 };
 
-struct btrfs_delayed_ref {
+struct btrfs_delayed_tree_ref {
 	struct btrfs_delayed_ref_node node;
+	union {
+		u64 root;
+		u64 parent;
+	};
+	int level;
+};
 
-	/* the root objectid our ref will point to */
-	u64 root;
-
-	/* the generation for the backref */
-	u64 generation;
-
-	/* owner_objectid of the backref  */
-	u64 owner_objectid;
-
-	/* operation done by this entry in the rbtree */
-	u8 action;
-
-	/* if pin == 1, when the extent is freed it will be pinned until
-	 * transaction commit
-	 */
-	unsigned int pin:1;
+struct btrfs_delayed_data_ref {
+	struct btrfs_delayed_ref_node node;
+	union {
+		u64 root;
+		u64 parent;
+	};
+	u64 objectid;
+	u64 offset;
 };
 
 struct btrfs_delayed_ref_root {
@@ -143,17 +149,25 @@ static inline void btrfs_put_delayed_ref
 	}
 }
 
-int btrfs_add_delayed_ref(struct btrfs_trans_handle *trans,
-			  u64 bytenr, u64 num_bytes, u64 parent, u64 ref_root,
-			  u64 ref_generation, u64 owner_objectid, int action,
-			  int pin);
+int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
+			       u64 bytenr, u64 num_bytes, u64 parent,
+			       u64 ref_root, int level, int action,
+			       struct btrfs_delayed_extent_op *extent_op);
+int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
+			       u64 bytenr, u64 num_bytes,
+			       u64 parent, u64 ref_root,
+			       u64 owner, u64 offset, int action,
+			       struct btrfs_delayed_extent_op *extent_op);
+int btrfs_add_delayed_extent_op(struct btrfs_trans_handle *trans,
+				u64 bytenr, u64 num_bytes,
+				struct btrfs_delayed_extent_op *extent_op);
 
 struct btrfs_delayed_ref_head *
 btrfs_find_delayed_ref_head(struct btrfs_trans_handle *trans, u64 bytenr);
 int btrfs_delayed_ref_pending(struct btrfs_trans_handle *trans, u64 bytenr);
-int btrfs_lookup_extent_ref(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root, u64 bytenr,
-			    u64 num_bytes, u32 *refs);
+int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
+			     struct btrfs_root *root, u64 bytenr,
+			     u64 num_bytes, u64 *refs, u64 *flags);
 int btrfs_update_delayed_ref(struct btrfs_trans_handle *trans,
 			  u64 bytenr, u64 num_bytes, u64 orig_parent,
 			  u64 parent, u64 orig_ref_root, u64 ref_root,
@@ -169,18 +183,24 @@ int btrfs_find_ref_cluster(struct btrfs_
  */
 static int btrfs_delayed_ref_is_head(struct btrfs_delayed_ref_node *node)
 {
-	return node->parent == (u64)-1;
+	return node->is_head;
 }
 
 /*
  * helper functions to cast a node into its container
  */
-static inline struct btrfs_delayed_ref *
-btrfs_delayed_node_to_ref(struct btrfs_delayed_ref_node *node)
+static inline struct btrfs_delayed_tree_ref *
+btrfs_delayed_node_to_tree_ref(struct btrfs_delayed_ref_node *node)
 {
 	WARN_ON(btrfs_delayed_ref_is_head(node));
-	return container_of(node, struct btrfs_delayed_ref, node);
+	return container_of(node, struct btrfs_delayed_tree_ref, node);
+}
 
+static inline struct btrfs_delayed_data_ref *
+btrfs_delayed_node_to_data_ref(struct btrfs_delayed_ref_node *node)
+{
+	WARN_ON(btrfs_delayed_ref_is_head(node));
+	return container_of(node, struct btrfs_delayed_data_ref, node);
 }
 
 static inline struct btrfs_delayed_ref_head *
@@ -188,6 +208,5 @@ btrfs_delayed_node_to_head(struct btrfs_
 {
 	WARN_ON(!btrfs_delayed_ref_is_head(node));
 	return container_of(node, struct btrfs_delayed_ref_head, node);
-
 }
 #endif

