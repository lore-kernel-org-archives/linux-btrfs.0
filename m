From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] batch extent inserts/updates/deletions on the extent root
Date: Tue, 11 Nov 2008 15:57:03 -0500
Message-ID: <20081111205702.GD11076@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

While profiling the allocator I noticed a good amount of time was being spent in
finish_current_insert and del_pending_extents, and as the filesystem filled up
more and more time was being spent in those functions.  This patch aims to try
and reduce that problem.  This happens two ways

1) track if we tried to delete an extent that we are going to update or insert.
Once we get into finish_current_insert we discard any of the extents that were
marked for deletion.  This saves us from doing unnecessary work almost every
time finish_current_insert runs.

2) Batch insertion/updates/deletions.  Instead of doing a btrfs_search_slot for
each individual extent and doing the needed operation, we instead keep the leaf
around and see if there is anything else we can do on that leaf.  On the insert
case I introduced a btrfs_insert_some_items, which will take an array of keys
with an array of data_sizes and try and squeeze in as many of those keys as
possible, and then return how many keys it was able to insert.  In the update
case we search for an extent ref, update the ref and then loop through the leaf
to see if any of the other refs we are looking to update are on that leaf, and
then once we are done we release the path and search for the next ref we need to
update.  And finally for the deletion we try and delete the extent+ref in pairs,
so we will try to find extent+ref pairs next to the extent we are trying to free
and free them in bulk if possible.

This along with the other cluster fix that Chris pushed out a bit ago helps make
the allocator preform more uniformly as it fills up the disk.  There is still a
slight drop as we fill up the disk since we start having to stick new blocks in
odd places which results in more COW's than on a empty fs, but the drop is not
nearly as severe as it was before.  Thank you,

Signed-off-by: Josef Bacik <jbacik@redhat.com>


diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index f82f8db..925983b 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -431,6 +431,25 @@ static int comp_keys(struct btrfs_disk_key *disk, struct btrfs_key *k2)
 	return 0;
 }
 
+/*
+ * same as comp_keys only with two btrfs_key's
+ */
+static int comp_cpu_keys(struct btrfs_key *k1, struct btrfs_key *k2)
+{
+	if (k1->objectid > k2->objectid)
+		return 1;
+	if (k1->objectid < k2->objectid)
+		return -1;
+	if (k1->type > k2->type)
+		return 1;
+	if (k1->type < k2->type)
+		return -1;
+	if (k1->offset > k2->offset)
+		return 1;
+	if (k1->offset < k2->offset)
+		return -1;
+	return 0;
+}
 
 /*
  * this is used by the defrag code to go through all the
@@ -3002,6 +3021,157 @@ int btrfs_extend_item(struct btrfs_trans_handle *trans,
 /*
  * Given a key and some data, insert items into the tree.
  * This does all the path init required, making room in the tree if needed.
+ * Returns the number of keys that were inserted.
+ */
+int btrfs_insert_some_items(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root,
+			    struct btrfs_path *path,
+			    struct btrfs_key *cpu_key, u32 *data_size,
+			    int nr)
+{
+	struct extent_buffer *leaf;
+	struct btrfs_item *item;
+	int ret = 0;
+	int slot;
+	int slot_orig;
+	int i;
+	u32 nritems;
+	u32 total_data = 0;
+	u32 total_size = 0;
+	unsigned int data_end;
+	struct btrfs_disk_key disk_key;
+	struct btrfs_key found_key;
+
+	found_key.objectid = 0;
+	nr = min_t(int, nr, BTRFS_NODEPTRS_PER_BLOCK(root));
+
+	for (i = 0; i < nr; i++)
+		total_data += data_size[i];
+
+	total_data = min_t(u32, total_data, BTRFS_LEAF_DATA_SIZE(root));
+	total_size = total_data + (nr * sizeof(struct btrfs_item));
+	ret = btrfs_search_slot(trans, root, cpu_key, path, total_size, 1);
+	if (ret == 0)
+		return -EEXIST;
+	if (ret < 0)
+		goto out;
+
+	slot_orig = path->slots[0];
+	leaf = path->nodes[0];
+
+	nritems = btrfs_header_nritems(leaf);
+	data_end = leaf_data_end(root, leaf);
+
+	if (btrfs_leaf_free_space(root, leaf) < total_size) {
+		for (i = nr; i >= 0; i--) {
+			total_data -= data_size[i];
+			total_size -= data_size[i] + sizeof(struct btrfs_item);
+			if (total_size < btrfs_leaf_free_space(root, leaf))
+				break;
+		}
+		nr = i;
+	}
+
+	slot = path->slots[0];
+	BUG_ON(slot < 0);
+
+	if (slot != nritems) {
+		unsigned int old_data = btrfs_item_end_nr(leaf, slot);
+
+		item = btrfs_item_nr(leaf, slot);
+		btrfs_item_key_to_cpu(leaf, &found_key, slot);
+
+		/* figure out how many keys we can insert in here */
+		total_data = data_size[0];
+		for (i = 1; i < nr; i++) {
+			if (comp_cpu_keys(&found_key, cpu_key + i) <= 0)
+				break;
+			total_data += data_size[i];
+		}
+		nr = i;
+
+		if (old_data < data_end) {
+			btrfs_print_leaf(root, leaf);
+			printk("slot %d old_data %d data_end %d\n",
+			       slot, old_data, data_end);
+			BUG_ON(1);
+		}
+		/*
+		 * item0..itemN ... dataN.offset..dataN.size .. data0.size
+		 */
+		/* first correct the data pointers */
+		WARN_ON(leaf->map_token);
+		for (i = slot; i < nritems; i++) {
+			u32 ioff;
+
+			item = btrfs_item_nr(leaf, i);
+			if (!leaf->map_token) {
+				map_extent_buffer(leaf, (unsigned long)item,
+					sizeof(struct btrfs_item),
+					&leaf->map_token, &leaf->kaddr,
+					&leaf->map_start, &leaf->map_len,
+					KM_USER1);
+			}
+
+			ioff = btrfs_item_offset(leaf, item);
+			btrfs_set_item_offset(leaf, item, ioff - total_data);
+		}
+		if (leaf->map_token) {
+			unmap_extent_buffer(leaf, leaf->map_token, KM_USER1);
+			leaf->map_token = NULL;
+		}
+
+		/* shift the items */
+		memmove_extent_buffer(leaf, btrfs_item_nr_offset(slot + nr),
+			      btrfs_item_nr_offset(slot),
+			      (nritems - slot) * sizeof(struct btrfs_item));
+
+		/* shift the data */
+		memmove_extent_buffer(leaf, btrfs_leaf_data(leaf) +
+			      data_end - total_data, btrfs_leaf_data(leaf) +
+			      data_end, old_data - data_end);
+		data_end = old_data;
+	} else {
+		/*
+		 * this sucks but it has to be done, if we are inserting at
+		 * the end of the leaf only insert 1 of the items, since we
+		 * have no way of knowing whats on the next leaf and we'd have
+		 * to drop our current locks to figure it out
+		 */
+		nr = 1;
+	}
+
+	/* setup the item for the new data */
+	for (i = 0; i < nr; i++) {
+		btrfs_cpu_key_to_disk(&disk_key, cpu_key + i);
+		btrfs_set_item_key(leaf, &disk_key, slot + i);
+		item = btrfs_item_nr(leaf, slot + i);
+		btrfs_set_item_offset(leaf, item, data_end - data_size[i]);
+		data_end -= data_size[i];
+		btrfs_set_item_size(leaf, item, data_size[i]);
+	}
+	btrfs_set_header_nritems(leaf, nritems + nr);
+	btrfs_mark_buffer_dirty(leaf);
+
+	ret = 0;
+	if (slot == 0) {
+		btrfs_cpu_key_to_disk(&disk_key, cpu_key);
+		ret = fixup_low_keys(trans, root, path, &disk_key, 1);
+	}
+
+	if (btrfs_leaf_free_space(root, leaf) < 0) {
+		btrfs_print_leaf(root, leaf);
+		BUG();
+	}
+out:
+	if (!ret)
+		ret = nr;
+	return ret;
+}
+
+/*
+ * Given a key and some data, insert items into the tree.
+ * This does all the path init required, making room in the tree if needed.
  */
 int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root,
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b3b15ee..573e2eb 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1720,6 +1720,11 @@ static inline int btrfs_del_item(struct btrfs_trans_handle *trans,
 
 int btrfs_insert_item(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, struct btrfs_key *key, void *data, u32 data_size);
+int btrfs_insert_some_items(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root,
+			    struct btrfs_path *path,
+			    struct btrfs_key *cpu_key, u32 *data_size,
+			    int nr);
 int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
 			     struct btrfs_path *path,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a546cd8..98c9819 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -42,6 +42,8 @@ struct pending_extent_op {
 	u64 generation;
 	u64 orig_generation;
 	int level;
+	struct list_head list;
+	int del;
 };
 
 static int finish_current_insert(struct btrfs_trans_handle *trans, struct
@@ -52,6 +54,13 @@ static struct btrfs_block_group_cache *
 __btrfs_find_block_group(struct btrfs_root *root,
 			 struct btrfs_block_group_cache *hint,
 			 u64 search_start, int data, int owner);
+static int pin_down_bytes(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *root,
+			  u64 bytenr, u64 num_bytes, int is_data);
+static int update_block_group(struct btrfs_trans_handle *trans,
+			      struct btrfs_root *root,
+			      u64 bytenr, u64 num_bytes, int alloc,
+			      int mark_free);
 
 static int block_group_bits(struct btrfs_block_group_cache *cache, u64 bits)
 {
@@ -559,6 +568,251 @@ out:
 	return ret;
 }
 
+/*
+ * updates all the backrefs that are pending on update_list for the
+ * extent_root
+ */
+static int noinline update_backrefs(struct btrfs_trans_handle *trans,
+				    struct btrfs_root *extent_root,
+				    struct btrfs_path *path,
+				    struct list_head *update_list)
+{
+	struct btrfs_key key;
+	struct btrfs_extent_ref *ref;
+	struct btrfs_fs_info *info = extent_root->fs_info;
+	struct pending_extent_op *op;
+	struct extent_buffer *leaf;
+	int ret = 0;
+	struct list_head *cur = update_list->next;
+	u64 ref_objectid;
+	u64 ref_root = extent_root->root_key.objectid;
+
+	op = list_entry(cur, struct pending_extent_op, list);
+
+search:
+	key.objectid = op->bytenr;
+	key.type = BTRFS_EXTENT_REF_KEY;
+	key.offset = op->orig_parent;
+
+	ret = btrfs_search_slot(trans, extent_root, &key, path, 0, 1);
+	BUG_ON(ret);
+
+	leaf = path->nodes[0];
+
+loop:
+	ref = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_ref);
+
+	ref_objectid = btrfs_ref_objectid(leaf, ref);
+
+	if (btrfs_ref_root(leaf, ref) != ref_root ||
+	    btrfs_ref_generation(leaf, ref) != op->orig_generation ||
+	    (ref_objectid != op->level &&
+	     ref_objectid != BTRFS_MULTIPLE_OBJECTIDS)) {
+		printk(KERN_ERR "couldn't find %Lu, parent %Lu, root %Lu, "
+		       "owner %u\n", op->bytenr, op->orig_parent,
+		       ref_root, op->level);
+		btrfs_print_leaf(extent_root, leaf);
+		BUG();
+	}
+
+	key.objectid = op->bytenr;
+	key.offset = op->parent;
+	key.type = BTRFS_EXTENT_REF_KEY;
+	ret = btrfs_set_item_key_safe(trans, extent_root, path, &key);
+	BUG_ON(ret);
+	ref = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_ref);
+	btrfs_set_ref_generation(leaf, ref, op->generation);
+
+	cur = cur->next;
+
+	list_del_init(&op->list);
+	unlock_extent(&info->extent_ins, op->bytenr,
+		      op->bytenr + op->num_bytes - 1, GFP_NOFS);
+	kfree(op);
+
+	if (cur == update_list) {
+		btrfs_mark_buffer_dirty(path->nodes[0]);
+		btrfs_release_path(extent_root, path);
+		goto out;
+	}
+
+	op = list_entry(cur, struct pending_extent_op, list);
+
+	path->slots[0]++;
+	while (path->slots[0] < btrfs_header_nritems(leaf)) {
+		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+		if (key.objectid == op->bytenr &&
+		    key.type == BTRFS_EXTENT_REF_KEY)
+			goto loop;
+		path->slots[0]++;
+	}
+
+	btrfs_mark_buffer_dirty(path->nodes[0]);
+	btrfs_release_path(extent_root, path);
+	goto search;
+
+out:
+	return 0;
+}
+
+static int noinline insert_extents(struct btrfs_trans_handle *trans,
+				   struct btrfs_root *extent_root,
+				   struct btrfs_path *path,
+				   struct list_head *insert_list, int nr)
+{
+	struct btrfs_key *keys;
+	u32 *data_size;
+	struct pending_extent_op *op;
+	struct extent_buffer *leaf;
+	struct list_head *cur = insert_list->next;
+	struct btrfs_fs_info *info = extent_root->fs_info;
+	u64 ref_root = extent_root->root_key.objectid;
+	int i = 0, last = 0, ret;
+	int total = nr * 2;
+
+	if (!nr)
+		return 0;
+
+	keys = kzalloc(total * sizeof(struct btrfs_key), GFP_NOFS);
+	if (!keys)
+		return -ENOMEM;
+
+	data_size = kzalloc(total * sizeof(u32), GFP_NOFS);
+	if (!data_size) {
+		kfree(keys);
+		return -ENOMEM;
+	}
+
+	list_for_each_entry(op, insert_list, list) {
+		keys[i].objectid = op->bytenr;
+		keys[i].offset = op->num_bytes;
+		keys[i].type = BTRFS_EXTENT_ITEM_KEY;
+		data_size[i] = sizeof(struct btrfs_extent_item);
+		i++;
+
+		keys[i].objectid = op->bytenr;
+		keys[i].offset = op->parent;
+		keys[i].type = BTRFS_EXTENT_REF_KEY;
+		data_size[i] = sizeof(struct btrfs_extent_ref);
+		i++;
+	}
+
+	op = list_entry(cur, struct pending_extent_op, list);
+	i = 0;
+	while (i < total) {
+		int c;
+		ret = btrfs_insert_some_items(trans, extent_root, path,
+					      keys+i, data_size+i, total-i);
+		BUG_ON(ret < 0);
+
+		if (last && ret > 1)
+			BUG();
+
+		leaf = path->nodes[0];
+		for (c = 0; c < ret; c++) {
+			int ref_first = keys[i].type == BTRFS_EXTENT_REF_KEY;
+
+			/*
+			 * if the first item we inserted was a backref, then
+			 * the EXTENT_ITEM will be the odd c's, else it will
+			 * be the even c's
+			 */
+			if ((ref_first && (c % 2)) ||
+			    (!ref_first && !(c % 2))) {
+				struct btrfs_extent_item *itm;
+
+				itm = btrfs_item_ptr(leaf, path->slots[0] + c,
+						     struct btrfs_extent_item);
+				btrfs_set_extent_refs(path->nodes[0], itm, 1);
+				op->del++;
+			} else {
+				struct btrfs_extent_ref *ref;
+
+				ref = btrfs_item_ptr(leaf, path->slots[0] + c,
+						     struct btrfs_extent_ref);
+				btrfs_set_ref_root(leaf, ref, ref_root);
+				btrfs_set_ref_generation(leaf, ref,
+							 op->generation);
+				btrfs_set_ref_objectid(leaf, ref, op->level);
+				btrfs_set_ref_num_refs(leaf, ref, 1);
+				op->del++;
+			}
+
+			/*
+			 * using del to see when its ok to free up the
+			 * pending_extent_op.  In the case where we insert the
+			 * last item on the list in order to help do batching
+			 * we need to not free the extent op until we actually
+			 * insert the extent_item
+			 */
+			if (op->del == 2) {
+				unlock_extent(&info->extent_ins, op->bytenr,
+					      op->bytenr + op->num_bytes - 1,
+					      GFP_NOFS);
+				cur = cur->next;
+				list_del_init(&op->list);
+				kfree(op);
+				if (cur != insert_list)
+					op = list_entry(cur,
+						struct pending_extent_op,
+						list);
+			}
+		}
+		btrfs_mark_buffer_dirty(leaf);
+		btrfs_release_path(extent_root, path);
+
+		/*
+		 * Ok backref's and items usually go right next to eachother,
+		 * but if we could only insert 1 item that means that we
+		 * inserted on the end of a leaf, and we have no idea what may
+		 * be on the next leaf so we just play it safe.  In order to
+		 * try and help this case we insert the last thing on our
+		 * insert list so hopefully it will end up being the last
+		 * thing on the leaf and everything else will be before it,
+		 * which will let us insert a whole bunch of crap at the same
+		 * time.
+		 */
+		if (ret == 1 && !last && (i + ret < total)) {
+			/*
+			 * last: where we will pick up the next time around
+			 * i: our current key to insert, will be total - 1
+			 * cur: the current op we are screwing with
+			 * op: duh
+			 */
+			last = i + ret;
+			i = total - 1;
+			cur = insert_list->prev;
+			op = list_entry(cur, struct pending_extent_op, list);
+		} else if (last) {
+			/*
+			 * ok we successfully inserted the last item on the
+			 * list, lets reset everything
+			 *
+			 * i: our current key to insert, so where we left off
+			 *    last time
+			 * last: done with this
+			 * cur: the op we are messing with
+			 * op: duh
+			 * total: since we inserted the last key, we need to
+			 *        decrement total so we dont overflow
+			 */
+			i = last;
+			last = 0;
+			cur = insert_list->next;
+			op = list_entry(cur, struct pending_extent_op, list);
+			total--;
+		} else {
+			i += ret;
+		}
+
+		cond_resched();
+	}
+	ret = 0;
+	kfree(keys);
+	kfree(data_size);
+	return ret;
+}
+
 static int noinline insert_extent_backref(struct btrfs_trans_handle *trans,
 					  struct btrfs_root *root,
 					  struct btrfs_path *path,
@@ -642,6 +896,267 @@ static int noinline remove_extent_backref(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+static int noinline free_extents(struct btrfs_trans_handle *trans,
+				 struct btrfs_root *extent_root,
+				 struct list_head *del_list)
+{
+	struct btrfs_fs_info *info = extent_root->fs_info;
+	struct btrfs_path *path;
+	struct btrfs_key key, found_key;
+	struct extent_buffer *leaf;
+	struct list_head *cur;
+	struct pending_extent_op *op;
+	struct btrfs_extent_item *ei;
+	int ret, num_to_del, extent_slot = 0, found_extent = 0;
+	u32 refs;
+	u64 bytes_freed = 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+	path->reada = 1;
+
+search:
+	/* search for the backref for the current ref we want to delete */
+	cur = del_list->next;
+	op = list_entry(cur, struct pending_extent_op, list);
+	ret = lookup_extent_backref(trans, extent_root, path, op->bytenr,
+				    op->orig_parent,
+				    extent_root->root_key.objectid,
+				    op->orig_generation, op->level, 1);
+	if (ret) {
+		printk("Unable to find backref byte nr %Lu root %Lu gen %Lu "
+		       "owner %u\n", op->bytenr,
+		       extent_root->root_key.objectid, op->orig_generation,
+		       op->level);
+		btrfs_print_leaf(extent_root, path->nodes[0]);
+		WARN_ON(1);
+		goto out;
+	}
+
+	extent_slot = path->slots[0];
+	num_to_del = 1;
+	found_extent = 0;
+
+	/*
+	 * if we aren't the first item on the leaf we can move back one and see
+	 * if our ref is right next to our extent item
+	 */
+	if (likely(extent_slot)) {
+		extent_slot--;
+		btrfs_item_key_to_cpu(path->nodes[0], &found_key,
+				      extent_slot);
+		if (found_key.objectid == op->bytenr &&
+		    found_key.type == BTRFS_EXTENT_ITEM_KEY &&
+		    found_key.offset == op->num_bytes) {
+			num_to_del++;
+			found_extent = 1;
+		}
+	}
+
+	/*
+	 * if we didn't find the extent we need to delete the backref and then
+	 * search for the extent item key so we can update its ref count
+	 */
+	if (!found_extent) {
+		key.objectid = op->bytenr;
+		key.type = BTRFS_EXTENT_ITEM_KEY;
+		key.offset = op->num_bytes;
+
+		ret = remove_extent_backref(trans, extent_root, path);
+		BUG_ON(ret);
+		btrfs_release_path(extent_root, path);
+		ret = btrfs_search_slot(trans, extent_root, &key, path, -1, 1);
+		BUG_ON(ret);
+		extent_slot = path->slots[0];
+	}
+
+	/* this is where we update the ref count for the extent */
+	leaf = path->nodes[0];
+	ei = btrfs_item_ptr(leaf, extent_slot, struct btrfs_extent_item);
+	refs = btrfs_extent_refs(leaf, ei);
+	BUG_ON(refs == 0);
+	refs--;
+	btrfs_set_extent_refs(leaf, ei, refs);
+
+	btrfs_mark_buffer_dirty(leaf);
+
+	/*
+	 * This extent needs deleting.  The reason cur_slot is extent_slot +
+	 * num_to_del is because extent_slot points to the slot where the extent
+	 * is, and if the backref was not right next to the extent we will be
+	 * deleting at least 1 item, and will want to start searching at the
+	 * slot directly next to extent_slot.  However if we did find the
+	 * backref next to the extent item them we will be deleting at least 2
+	 * items and will want to start searching directly after the ref slot
+	 */
+	if (!refs) {
+		struct list_head *pos, *n, *end;
+		int cur_slot = extent_slot+num_to_del;
+		u64 super_used;
+		u64 root_used;
+
+		path->slots[0] = extent_slot;
+		bytes_freed = op->num_bytes;
+
+		/*
+		 * we need to see if we can delete multiple things at once, so
+		 * start looping through the list of extents we are wanting to
+		 * delete and see if their extent/backref's are right next to
+		 * eachother and the extents only have 1 ref
+		 */
+		for (pos = cur->next; pos != del_list; pos = pos->next) {
+			struct pending_extent_op *tmp;
+
+			tmp = list_entry(pos, struct pending_extent_op, list);
+
+			/* we only want to delete extent+ref at this stage */
+			if (cur_slot >= btrfs_header_nritems(leaf) - 1)
+				break;
+
+			btrfs_item_key_to_cpu(leaf, &found_key, cur_slot);
+			if (found_key.objectid != tmp->bytenr ||
+			    found_key.type != BTRFS_EXTENT_ITEM_KEY ||
+			    found_key.offset != tmp->num_bytes)
+				break;
+
+			/* check to make sure this extent only has one ref */
+			ei = btrfs_item_ptr(leaf, cur_slot,
+					    struct btrfs_extent_item);
+			if (btrfs_extent_refs(leaf, ei) != 1)
+				break;
+
+			btrfs_item_key_to_cpu(leaf, &found_key, cur_slot+1);
+			if (found_key.objectid != tmp->bytenr ||
+			    found_key.type != BTRFS_EXTENT_REF_KEY ||
+			    found_key.offset != tmp->orig_parent)
+				break;
+
+			/*
+			 * the ref is right next to the extent, we can set the
+			 * ref count to 0 since we will delete them both now
+			 */
+			btrfs_set_extent_refs(leaf, ei, 0);
+
+			/* pin down the bytes for this extent */
+			mutex_lock(&info->pinned_mutex);
+			ret = pin_down_bytes(trans, extent_root, tmp->bytenr,
+					     tmp->num_bytes, tmp->level >=
+					     BTRFS_FIRST_FREE_OBJECTID);
+			mutex_unlock(&info->pinned_mutex);
+			BUG_ON(ret < 0);
+
+			/*
+			 * use the del field to tell if we need to go ahead and
+			 * free up the extent when we delete the item or not.
+			 */
+			tmp->del = ret;
+			bytes_freed += tmp->num_bytes;
+
+			num_to_del += 2;
+			cur_slot += 2;
+		}
+		end = pos;
+
+		/* update the free space counters */
+		spin_lock_irq(&info->delalloc_lock);
+		super_used = btrfs_super_bytes_used(&info->super_copy);
+		btrfs_set_super_bytes_used(&info->super_copy,
+					   super_used - bytes_freed);
+		spin_unlock_irq(&info->delalloc_lock);
+
+		root_used = btrfs_root_used(&extent_root->root_item);
+		btrfs_set_root_used(&extent_root->root_item,
+				    root_used - bytes_freed);
+
+		/* delete the items */
+		ret = btrfs_del_items(trans, extent_root, path,
+				      path->slots[0], num_to_del);
+		BUG_ON(ret);
+
+		/*
+		 * loop through the extents we deleted and do the cleanup work
+		 * on them
+		 */
+		for (pos = cur, n = pos->next; pos != end;
+		     pos = n, n = pos->next) {
+			struct pending_extent_op *tmp;
+#ifdef BIO_RW_DISCARD
+			u64 map_length;
+			struct btrfs_multi_bio *multi = NULL;
+#endif
+			tmp = list_entry(pos, struct pending_extent_op, list);
+
+			/*
+			 * remember tmp->del tells us wether or not we pinned
+			 * down the extent
+			 */
+			ret = update_block_group(trans, extent_root,
+						 tmp->bytenr, tmp->num_bytes, 0,
+						 tmp->del);
+			BUG_ON(ret);
+
+#ifdef BIO_RW_DISCARD
+			ret = btrfs_map_block(&info->mapping_tree, READ,
+					      tmp->bytenr, &map_length, &multi,
+					      0);
+			if (!ret) {
+				struct btrfs_bio_stripe *stripe;
+				int i;
+
+				stripe = multi->stripe;
+
+				if (map_length > tmp->num_bytes)
+					map_length = tmp->num_bytes;
+
+				for (i = 0; i < multi->num_stripes;
+				     i++, stripe++)
+					blkdev_issue_discard(stripe->dev->bdev,
+							stripe->physical >> 9,
+							map_length >> 9);
+				kfree(multi);
+			}
+#endif
+			list_del_init(&tmp->list);
+			unlock_extent(&info->extent_ins, tmp->bytenr,
+				      tmp->bytenr + tmp->num_bytes - 1,
+				      GFP_NOFS);
+			kfree(tmp);
+		}
+	} else if (refs && found_extent) {
+		/*
+		 * the ref and extent were right next to eachother, but the
+		 * extent still has a ref, so just free the backref and keep
+		 * going
+		 */
+		ret = remove_extent_backref(trans, extent_root, path);
+		BUG_ON(ret);
+
+		list_del_init(&op->list);
+		unlock_extent(&info->extent_ins, op->bytenr,
+			      op->bytenr + op->num_bytes - 1, GFP_NOFS);
+		kfree(op);
+	} else {
+		/*
+		 * the extent has multiple refs and the backref we were looking
+		 * for was not right next to it, so just unlock and go next,
+		 * we're good to go
+		 */
+		list_del_init(&op->list);
+		unlock_extent(&info->extent_ins, op->bytenr,
+			      op->bytenr + op->num_bytes - 1, GFP_NOFS);
+		kfree(op);
+	}
+
+	btrfs_release_path(extent_root, path);
+	if (!list_empty(del_list))
+		goto search;
+
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
 static int __btrfs_update_extent_ref(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *root, u64 bytenr,
 				     u64 orig_parent, u64 parent,
@@ -685,6 +1200,8 @@ static int __btrfs_update_extent_ref(struct btrfs_trans_handle *trans,
 			extent_op->generation = ref_generation;
 			extent_op->orig_generation = orig_generation;
 			extent_op->level = (int)owner_objectid;
+			INIT_LIST_HEAD(&extent_op->list);
+			extent_op->del = 0;
 
 			set_extent_bits(&root->fs_info->extent_ins,
 					bytenr, bytenr + num_bytes - 1,
@@ -1426,9 +1943,8 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 
 	while(total) {
 		cache = btrfs_lookup_block_group(info, bytenr);
-		if (!cache) {
+		if (!cache)
 			return -1;
-		}
 		byte_in_group = bytenr - cache->key.objectid;
 		WARN_ON(byte_in_group > cache->key.offset);
 
@@ -1605,102 +2121,176 @@ static int finish_current_insert(struct btrfs_trans_handle *trans,
 	u64 end;
 	u64 priv;
 	u64 search = 0;
+	u64 skipped = 0;
 	struct btrfs_fs_info *info = extent_root->fs_info;
 	struct btrfs_path *path;
-	struct btrfs_extent_ref *ref;
-	struct pending_extent_op *extent_op;
-	struct btrfs_key key;
-	struct btrfs_extent_item extent_item;
+	struct pending_extent_op *extent_op, *tmp;
+	struct list_head insert_list, update_list;
 	int ret;
-	int err = 0;
+	int num_inserts = 0, max_inserts;
 
-	btrfs_set_stack_extent_refs(&extent_item, 1);
 	path = btrfs_alloc_path();
+	INIT_LIST_HEAD(&insert_list);
+	INIT_LIST_HEAD(&update_list);
 
-	while(1) {
-		mutex_lock(&info->extent_ins_mutex);
+	max_inserts = extent_root->leafsize /
+		(2 * sizeof(struct btrfs_key) + 2 * sizeof(struct btrfs_item) +
+		 sizeof(struct btrfs_extent_ref) +
+		 sizeof(struct btrfs_extent_item));
+again:
+	mutex_lock(&info->extent_ins_mutex);
+	while (1) {
 		ret = find_first_extent_bit(&info->extent_ins, search, &start,
 					    &end, EXTENT_WRITEBACK);
 		if (ret) {
-			mutex_unlock(&info->extent_ins_mutex);
-			if (search && all) {
-				search = 0;
+			if (skipped && all && !num_inserts) {
+				skipped = 0;
 				continue;
 			}
+			mutex_unlock(&info->extent_ins_mutex);
 			break;
 		}
 
 		ret = try_lock_extent(&info->extent_ins, start, end, GFP_NOFS);
 		if (!ret) {
+			skipped = 1;
 			search = end + 1;
-			mutex_unlock(&info->extent_ins_mutex);
-			cond_resched();
+			if (need_resched()) {
+				mutex_unlock(&info->extent_ins_mutex);
+				cond_resched();
+				mutex_lock(&info->extent_ins_mutex);
+			}
 			continue;
 		}
-		BUG_ON(ret < 0);
 
 		ret = get_state_private(&info->extent_ins, start, &priv);
 		BUG_ON(ret);
-		extent_op = (struct pending_extent_op *)(unsigned long)priv;
-
-		mutex_unlock(&info->extent_ins_mutex);
+		extent_op = (struct pending_extent_op *)(unsigned long) priv;
 
 		if (extent_op->type == PENDING_EXTENT_INSERT) {
-			key.objectid = start;
-			key.offset = end + 1 - start;
-			key.type = BTRFS_EXTENT_ITEM_KEY;
-			err = btrfs_insert_item(trans, extent_root, &key,
-					&extent_item, sizeof(extent_item));
-			BUG_ON(err);
+			num_inserts++;
+			list_add_tail(&extent_op->list, &insert_list);
+			search = end + 1;
+			if (num_inserts == max_inserts) {
+				mutex_unlock(&info->extent_ins_mutex);
+				break;
+			}
+		} else if (extent_op->type == PENDING_BACKREF_UPDATE) {
+			list_add_tail(&extent_op->list, &update_list);
+			search = end + 1;
+		} else {
+			BUG();
+		}
+	}
 
-			mutex_lock(&info->extent_ins_mutex);
-			clear_extent_bits(&info->extent_ins, start, end,
-					  EXTENT_WRITEBACK, GFP_NOFS);
-			mutex_unlock(&info->extent_ins_mutex);
+	/*
+	 * process teh update list, clear the writeback bit for it, and if
+	 * somebody marked this thing for deletion then just unlock it and be
+	 * done, the free_extents will handle it
+	 */
+	mutex_lock(&info->extent_ins_mutex);
+	list_for_each_entry_safe(extent_op, tmp, &update_list, list) {
+		clear_extent_bits(&info->extent_ins, extent_op->bytenr,
+				  extent_op->bytenr + extent_op->num_bytes - 1,
+				  EXTENT_WRITEBACK, GFP_NOFS);
+		if (extent_op->del) {
+			list_del_init(&extent_op->list);
+			unlock_extent(&info->extent_ins, extent_op->bytenr,
+				      extent_op->bytenr + extent_op->num_bytes
+				      - 1, GFP_NOFS);
+			kfree(extent_op);
+		}
+	}
+	mutex_unlock(&info->extent_ins_mutex);
 
-			err = insert_extent_backref(trans, extent_root, path,
-						start, extent_op->parent,
-						extent_root->root_key.objectid,
-						extent_op->generation,
-						extent_op->level);
-			BUG_ON(err);
-		} else if (extent_op->type == PENDING_BACKREF_UPDATE) {
-			err = lookup_extent_backref(trans, extent_root, path,
-						start, extent_op->orig_parent,
-						extent_root->root_key.objectid,
-						extent_op->orig_generation,
-						extent_op->level, 0);
-			BUG_ON(err);
+	/*
+	 * still have things left on the update list, go ahead an update
+	 * everything
+	 */
+	if (!list_empty(&update_list)) {
+		ret = update_backrefs(trans, extent_root, path, &update_list);
+		BUG_ON(ret);
+	}
 
-			mutex_lock(&info->extent_ins_mutex);
-			clear_extent_bits(&info->extent_ins, start, end,
-					  EXTENT_WRITEBACK, GFP_NOFS);
-			mutex_unlock(&info->extent_ins_mutex);
+	/*
+	 * if no inserts need to be done, but we skipped some extents and we
+	 * need to make sure everything is cleaned then reset everything and
+	 * go back to the beginning
+	 */
+	if (!num_inserts && all && skipped) {
+		search = 0;
+		skipped = 0;
+		INIT_LIST_HEAD(&update_list);
+		INIT_LIST_HEAD(&insert_list);
+		goto again;
+	} else if (!num_inserts) {
+		goto out;
+	}
 
-			key.objectid = start;
-			key.offset = extent_op->parent;
-			key.type = BTRFS_EXTENT_REF_KEY;
-			err = btrfs_set_item_key_safe(trans, extent_root, path,
-						      &key);
-			BUG_ON(err);
-			ref = btrfs_item_ptr(path->nodes[0], path->slots[0],
-					     struct btrfs_extent_ref);
-			btrfs_set_ref_generation(path->nodes[0], ref,
-						 extent_op->generation);
-			btrfs_mark_buffer_dirty(path->nodes[0]);
-			btrfs_release_path(extent_root, path);
-		} else {
-			BUG_ON(1);
+	/*
+	 * process the insert extents list.  Again if we are deleting this
+	 * extent, then just unlock it, pin down the bytes if need be, and be
+	 * done with it.  Saves us from having to actually insert the extent
+	 * into the tree and then subsequently come along and delete it
+	 */
+	mutex_lock(&info->extent_ins_mutex);
+	list_for_each_entry_safe(extent_op, tmp, &insert_list, list) {
+		clear_extent_bits(&info->extent_ins, extent_op->bytenr,
+				  extent_op->bytenr + extent_op->num_bytes - 1,
+				  EXTENT_WRITEBACK, GFP_NOFS);
+		if (extent_op->del) {
+			list_del_init(&extent_op->list);
+			unlock_extent(&info->extent_ins, extent_op->bytenr,
+				      extent_op->bytenr + extent_op->num_bytes
+				      - 1, GFP_NOFS);
+
+			mutex_lock(&extent_root->fs_info->pinned_mutex);
+			ret = pin_down_bytes(trans, extent_root,
+					     extent_op->bytenr,
+					     extent_op->num_bytes, 0);
+			mutex_unlock(&extent_root->fs_info->pinned_mutex);
+
+			ret = update_block_group(trans, extent_root,
+						 extent_op->bytenr,
+						 extent_op->num_bytes,
+						 0, ret > 0);
+			BUG_ON(ret);
+			kfree(extent_op);
+			num_inserts--;
 		}
-		kfree(extent_op);
-		unlock_extent(&info->extent_ins, start, end, GFP_NOFS);
-		if (all)
-			search = 0;
-		else
-			search = end + 1;
+	}
+	mutex_unlock(&info->extent_ins_mutex);
 
-		cond_resched();
+	ret = insert_extents(trans, extent_root, path, &insert_list,
+			     num_inserts);
+	BUG_ON(ret);
+
+	/*
+	 * if we broke out of the loop in order to insert stuff because we hit
+	 * the maximum number of inserts at a time we can handle, then loop
+	 * back and pick up where we left off
+	 */
+	if (num_inserts == max_inserts) {
+		INIT_LIST_HEAD(&insert_list);
+		INIT_LIST_HEAD(&update_list);
+		num_inserts = 0;
+		goto again;
 	}
+
+	/*
+	 * again, if we need to make absolutely sure there are no more pending
+	 * extent operations left and we know that we skipped some, go back to
+	 * the beginning and do it all again
+	 */
+	if (all && skipped) {
+		INIT_LIST_HEAD(&insert_list);
+		INIT_LIST_HEAD(&update_list);
+		search = 0;
+		skipped = 0;
+		num_inserts = 0;
+		goto again;
+	}
+out:
 	btrfs_free_path(path);
 	return 0;
 }
@@ -1802,6 +2392,12 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 			btrfs_release_path(extent_root, path);
 			ret = btrfs_search_slot(trans, extent_root,
 						&key, path, -1, 1);
+			if (ret) {
+				printk(KERN_ERR "umm, got %d back from search"
+				       ", was looking for %Lu\n", ret,
+				       bytenr);
+				btrfs_print_leaf(extent_root, path->nodes[0]);
+			}
 			BUG_ON(ret);
 			extent_slot = path->slots[0];
 		}
@@ -1921,32 +2517,42 @@ static int del_pending_extents(struct btrfs_trans_handle *trans, struct
 	u64 end;
 	u64 priv;
 	u64 search = 0;
+	int nr = 0, skipped = 0;
 	struct extent_io_tree *pending_del;
 	struct extent_io_tree *extent_ins;
 	struct pending_extent_op *extent_op;
 	struct btrfs_fs_info *info = extent_root->fs_info;
+	struct list_head delete_list;
 
+	INIT_LIST_HEAD(&delete_list);
 	extent_ins = &extent_root->fs_info->extent_ins;
 	pending_del = &extent_root->fs_info->pending_del;
 
+again:
+	mutex_lock(&info->extent_ins_mutex);
 	while(1) {
-		mutex_lock(&info->extent_ins_mutex);
 		ret = find_first_extent_bit(pending_del, search, &start, &end,
 					    EXTENT_WRITEBACK);
 		if (ret) {
-			mutex_unlock(&info->extent_ins_mutex);
-			if (all && search) {
+			if (all && skipped && !nr) {
 				search = 0;
 				continue;
 			}
+			mutex_unlock(&info->extent_ins_mutex);
 			break;
 		}
 
 		ret = try_lock_extent(extent_ins, start, end, GFP_NOFS);
 		if (!ret) {
 			search = end+1;
-			mutex_unlock(&info->extent_ins_mutex);
-			cond_resched();
+			skipped = 1;
+
+			if (need_resched()) {
+				mutex_unlock(&info->extent_ins_mutex);
+				cond_resched();
+				mutex_lock(&info->extent_ins_mutex);
+			}
+
 			continue;
 		}
 		BUG_ON(ret < 0);
@@ -1959,15 +2565,8 @@ static int del_pending_extents(struct btrfs_trans_handle *trans, struct
 				  GFP_NOFS);
 		if (!test_range_bit(extent_ins, start, end,
 				    EXTENT_WRITEBACK, 0)) {
-			mutex_unlock(&info->extent_ins_mutex);
-free_extent:
-			ret = __free_extent(trans, extent_root,
-					    start, end + 1 - start,
-					    extent_op->orig_parent,
-					    extent_root->root_key.objectid,
-					    extent_op->orig_generation,
-					    extent_op->level, 1, 0);
-			kfree(extent_op);
+			list_add_tail(&extent_op->list, &delete_list);
+			nr++;
 		} else {
 			kfree(extent_op);
 
@@ -1980,10 +2579,12 @@ free_extent:
 			clear_extent_bits(&info->extent_ins, start, end,
 					  EXTENT_WRITEBACK, GFP_NOFS);
 
-			mutex_unlock(&info->extent_ins_mutex);
-
-			if (extent_op->type == PENDING_BACKREF_UPDATE)
-				goto free_extent;
+			if (extent_op->type == PENDING_BACKREF_UPDATE) {
+				list_add_tail(&extent_op->list, &delete_list);
+				search = end + 1;
+				nr++;
+				continue;
+			}
 
 			mutex_lock(&extent_root->fs_info->pinned_mutex);
 			ret = pin_down_bytes(trans, extent_root, start,
@@ -1993,19 +2594,34 @@ free_extent:
 			ret = update_block_group(trans, extent_root, start,
 						end + 1 - start, 0, ret > 0);
 
+			unlock_extent(extent_ins, start, end, GFP_NOFS);
 			BUG_ON(ret);
 			kfree(extent_op);
 		}
 		if (ret)
 			err = ret;
-		unlock_extent(extent_ins, start, end, GFP_NOFS);
 
-		if (all)
-			search = 0;
-		else
-			search = end + 1;
-		cond_resched();
+		search = end + 1;
+
+		if (need_resched()) {
+			mutex_unlock(&info->extent_ins_mutex);
+			cond_resched();
+			mutex_lock(&info->extent_ins_mutex);
+		}
 	}
+
+	if (nr) {
+		ret = free_extents(trans, extent_root, &delete_list);
+		BUG_ON(ret);
+	}
+
+	if (all && skipped) {
+		INIT_LIST_HEAD(&delete_list);
+		search = 0;
+		nr = 0;
+		goto again;
+	}
+
 	return err;
 }
 
@@ -2024,7 +2640,29 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 
 	WARN_ON(num_bytes < root->sectorsize);
 	if (root == extent_root) {
-		struct pending_extent_op *extent_op;
+		struct pending_extent_op *extent_op = NULL;
+
+		mutex_lock(&root->fs_info->extent_ins_mutex);
+		if (test_range_bit(&root->fs_info->extent_ins, bytenr,
+				bytenr + num_bytes - 1, EXTENT_WRITEBACK, 0)) {
+			u64 priv;
+			ret = get_state_private(&root->fs_info->extent_ins,
+						bytenr, &priv);
+			BUG_ON(ret);
+			extent_op = (struct pending_extent_op *)
+						(unsigned long)priv;
+
+			extent_op->del = 1;
+			if (extent_op->type == PENDING_EXTENT_INSERT) {
+				mutex_unlock(&root->fs_info->extent_ins_mutex);
+				return 0;
+			}
+		}
+
+		if (extent_op) {
+			ref_generation = extent_op->orig_generation;
+			parent = extent_op->orig_parent;
+		}
 
 		extent_op = kmalloc(sizeof(*extent_op), GFP_NOFS);
 		BUG_ON(!extent_op);
@@ -2037,8 +2675,9 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 		extent_op->generation = ref_generation;
 		extent_op->orig_generation = ref_generation;
 		extent_op->level = (int)owner_objectid;
+		INIT_LIST_HEAD(&extent_op->list);
+		extent_op->del = 0;
 
-		mutex_lock(&root->fs_info->extent_ins_mutex);
 		set_extent_bits(&root->fs_info->pending_del,
 				bytenr, bytenr + num_bytes - 1,
 				EXTENT_WRITEBACK, GFP_NOFS);
@@ -2516,6 +3155,8 @@ static int __btrfs_alloc_reserved_extent(struct btrfs_trans_handle *trans,
 		extent_op->generation = ref_generation;
 		extent_op->orig_generation = 0;
 		extent_op->level = (int)owner;
+		INIT_LIST_HEAD(&extent_op->list);
+		extent_op->del = 0;
 
 		mutex_lock(&root->fs_info->extent_ins_mutex);
 		set_extent_bits(&root->fs_info->extent_ins, ins->objectid,
