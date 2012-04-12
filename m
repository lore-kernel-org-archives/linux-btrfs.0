From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH RFC] Btrfs: improve space count for files with fragments
Date: Thu, 12 Apr 2012 17:05:02 +0800
Message-ID: <1334221502-9222-1-git-send-email-liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Here is a simple scenario:

$ dd if=/dev/zero of=/mnt/btrfs/foobar bs=1k count=20;sync
$ btrfs fi df /mnt/btrfs

we get 20K used, but then

$ dd if=/dev/zero of=/mnt/btrfs/foobar bs=1k count=4 seek=4 conv=notrunc;sync
$ btrfs fi df /mnt/btrfs

we get 24K used.

Here is the problem, it is possible that a file with lots of fragments costs
nearly double space than its i_size, like:

0k              20k
| --- extent --- |      turned to be on disk    <---  extent --->  <-- A -->
     | - A - |                                  | -------------- | | ----- |
     1k      19k                                       20k + 18k = 38k

                        but what users want is  <---  extent --->  <-- A -->
                                                | --- |     | -- | | ----- |
                                                    1k + 1k + 18k = 20k

18K is wasted.

With the current backref design, it is really hard to fix this except a format
change.
So my choice is to pick up a special inline backref to indicates how much
space the extent costs, and the benifit is that it does not need to touch
the backref design too much.

a) When we do random write on the extent, we'll update the space of the extent
   by updating the special inline backref.

b) When we free the extent, we'll get the right space recorded in the special
   inline bakcref to update the space count info.

c) Besides, we are forbidden to add the range to the free space in such cases:

   | --- extent ---|
   | - A - |

   this part, A, includes the _start_ of the extent.
   We know that our data checksum item is taking this _start_ as a index,
   so just leave A's space where it is, do not free it.

NOTE:
   This has compatability issue, so please use this on a fresh-build btrfs.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       |    4 +
 fs/btrfs/delayed-ref.c |   30 +++++++++-
 fs/btrfs/extent-tree.c |  148 +++++++++++++++++++++++++++++++++++++++++++-----
 fs/btrfs/extent_io.c   |   14 +++++
 fs/btrfs/extent_io.h   |    5 ++
 fs/btrfs/file.c        |  145 +++++++++++++++++++++++++++++++++++++++++------
 fs/btrfs/inode.c       |   19 +++++-
 fs/btrfs/relocation.c  |    7 ++
 8 files changed, 334 insertions(+), 38 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 5b8ef8e..6d66a23 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2972,6 +2972,10 @@ int btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
 extern const struct file_operations btrfs_file_operations;
 int btrfs_drop_extents(struct btrfs_trans_handle *trans, struct inode *inode,
 		       u64 start, u64 end, u64 *hint_byte, int drop_cache);
+int btrfs_return_space_to_free_space(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root, u64 disk_bytenr,
+				u64 num_bytes, u64 owner, u64 drop_start,
+				u64 num_dec);
 int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 			      struct inode *inode, u64 start, u64 end);
 int btrfs_release_file(struct inode *inode, struct file *file);
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 69f22e3..8a2640a 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -59,6 +59,8 @@ static int comp_data_refs(struct btrfs_delayed_data_ref *ref2,
 			  struct btrfs_delayed_data_ref *ref1)
 {
 	if (ref1->node.type == BTRFS_EXTENT_DATA_REF_KEY) {
+		if (ref2->root == 0 && ref1->root == 0)
+			return 0;
 		if (ref1->root < ref2->root)
 			return -1;
 		if (ref1->root > ref2->root)
@@ -355,6 +357,19 @@ update_existing_ref(struct btrfs_trans_handle *trans,
 		 * reference count
 		 */
 		existing->ref_mod += update->ref_mod;
+
+		/* for ref_root is 0 */
+		{
+			struct btrfs_delayed_data_ref *full_existing_ref;
+			struct btrfs_delayed_data_ref *full_ref;
+
+			full_existing_ref =
+				       btrfs_delayed_node_to_data_ref(existing);
+			full_ref = btrfs_delayed_node_to_data_ref(update);
+
+			if (full_existing_ref->root == 0 && full_ref->root == 0)
+				full_existing_ref->offset += full_ref->offset;
+		}
 	}
 }
 
@@ -579,7 +594,10 @@ static noinline void add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	atomic_set(&ref->refs, 1);
 	ref->bytenr = bytenr;
 	ref->num_bytes = num_bytes;
-	ref->ref_mod = 1;
+	if (ref_root != 0)
+		ref->ref_mod = 1;
+	else
+		ref->ref_mod = 0;
 	ref->action = action;
 	ref->is_head = 0;
 	ref->in_tree = 1;
@@ -753,7 +771,15 @@ btrfs_find_delayed_ref_head(struct btrfs_trans_handle *trans, u64 bytenr)
 
 	delayed_refs = &trans->transaction->delayed_refs;
 	ref = find_ref_head(&delayed_refs->root, bytenr, NULL, 0);
-	if (ref)
+	if (ref) {
+		if (ref->type == BTRFS_EXTENT_DATA_REF_KEY) {
+			struct btrfs_delayed_data_ref *my_full_ref;
+
+			my_full_ref = btrfs_delayed_node_to_data_ref(ref);
+			if (my_full_ref->root == 0) /* special one: root == 0 */
+				return NULL;
+		}
 		return btrfs_delayed_node_to_head(ref);
+	}
 	return NULL;
 }
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a844204..59ffb1d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -78,6 +78,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 				u64 root_objectid, u64 owner_objectid,
 				u64 owner_offset, int refs_to_drop,
 				struct btrfs_delayed_extent_op *extra_op);
+static int unpin_extent_range(struct btrfs_root *root, u64 start, u64 end);
 static void __run_delayed_extent_op(struct btrfs_delayed_extent_op *extent_op,
 				    struct extent_buffer *leaf,
 				    struct btrfs_extent_item *ei);
@@ -1536,6 +1537,17 @@ int lookup_inline_extent_backref(struct btrfs_trans_handle *trans,
 		if (type == BTRFS_EXTENT_DATA_REF_KEY) {
 			struct btrfs_extent_data_ref *dref;
 			dref = (struct btrfs_extent_data_ref *)(&iref->offset);
+
+			/* a special backref for space count */
+			if (btrfs_extent_data_ref_root(leaf, dref) == 0) {
+				if (root_objectid == 0) {
+					err = 0;
+					break;
+				}
+				ptr += btrfs_extent_inline_ref_size(type);
+				continue;
+			}
+
 			if (match_extent_data_ref(leaf, dref, root_objectid,
 						  owner, offset)) {
 				err = 0;
@@ -1694,6 +1706,7 @@ void update_inline_extent_backref(struct btrfs_trans_handle *trans,
 				  struct btrfs_root *root,
 				  struct btrfs_path *path,
 				  struct btrfs_extent_inline_ref *iref,
+				  u64 root_objectid, u64 offset_to_mod,
 				  int refs_to_mod,
 				  struct btrfs_delayed_extent_op *extent_op)
 {
@@ -1707,6 +1720,7 @@ void update_inline_extent_backref(struct btrfs_trans_handle *trans,
 	int size;
 	int type;
 	u64 refs;
+	u64 offset = 0;
 
 	leaf = path->nodes[0];
 	ei = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_item);
@@ -1722,6 +1736,9 @@ void update_inline_extent_backref(struct btrfs_trans_handle *trans,
 	if (type == BTRFS_EXTENT_DATA_REF_KEY) {
 		dref = (struct btrfs_extent_data_ref *)(&iref->offset);
 		refs = btrfs_extent_data_ref_count(leaf, dref);
+		/* FIXME: liubo */
+		offset = btrfs_extent_data_ref_offset(leaf, dref);
+		offset -= offset_to_mod;
 	} else if (type == BTRFS_SHARED_DATA_REF_KEY) {
 		sref = (struct btrfs_shared_data_ref *)(iref + 1);
 		refs = btrfs_shared_data_ref_count(leaf, sref);
@@ -1734,10 +1751,15 @@ void update_inline_extent_backref(struct btrfs_trans_handle *trans,
 	refs += refs_to_mod;
 
 	if (refs > 0) {
-		if (type == BTRFS_EXTENT_DATA_REF_KEY)
+		if (type == BTRFS_EXTENT_DATA_REF_KEY) {
 			btrfs_set_extent_data_ref_count(leaf, dref, refs);
-		else
+
+			if (root_objectid == 0)
+				btrfs_set_extent_data_ref_offset(leaf,
+								 dref, offset);
+		} else {
 			btrfs_set_shared_data_ref_count(leaf, sref, refs);
+		}
 	} else {
 		size =  btrfs_extent_inline_ref_size(type);
 		item_size = btrfs_item_size_nr(leaf, path->slots[0]);
@@ -1770,6 +1792,7 @@ int insert_inline_extent_backref(struct btrfs_trans_handle *trans,
 	if (ret == 0) {
 		BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID);
 		update_inline_extent_backref(trans, root, path, iref,
+					     root_objectid, offset,
 					     refs_to_add, extent_op);
 	} else if (ret == -ENOENT) {
 		setup_inline_extent_backref(trans, root, path, iref, parent,
@@ -1810,6 +1833,7 @@ static int remove_extent_backref(struct btrfs_trans_handle *trans,
 	BUG_ON(!is_data && refs_to_drop != 1);
 	if (iref) {
 		update_inline_extent_backref(trans, root, path, iref,
+					     -1, 0,
 					     -refs_to_drop, NULL);
 	} else if (is_data) {
 		ret = remove_extent_data_ref(trans, root, path, refs_to_drop);
@@ -2364,6 +2388,30 @@ static void wait_for_more_refs(struct btrfs_delayed_ref_root *delayed_refs,
 	spin_lock(&delayed_refs->lock);
 }
 
+static void btrfs_balance_pinned_extents(struct btrfs_trans_handle *trans,
+					 struct btrfs_root *root)
+{
+	struct extent_io_tree *pin;
+	u64 start;
+	u64 end;
+	int ret;
+
+	pin = root->fs_info->pinned_extents;
+
+	while (1) {
+		ret = find_first_extent_bit(pin, 0, &start, &end,
+					    EXTENT_PINNED);
+		if (ret)
+			break;
+
+		clear_extent_pinned(pin, start, end, GFP_NOFS);
+
+		ret = update_block_group(trans, root, start, end - start + 1,0);
+		BUG_ON(ret);
+		cond_resched();
+	}
+}
+
 /*
  * this starts processing the delayed reference count updates and
  * extent insertions we have queued up so far.  count can be
@@ -2501,6 +2549,7 @@ again:
 	}
 out:
 	spin_unlock(&delayed_refs->lock);
+	btrfs_balance_pinned_extents(trans, root);
 	return 0;
 }
 
@@ -2609,6 +2658,8 @@ static noinline int check_committed_ref(struct btrfs_trans_handle *trans,
 	struct btrfs_extent_item *ei;
 	struct btrfs_key key;
 	u32 item_size;
+	u32 bi_size;
+	unsigned long ptr;
 	int ret;
 
 	key.objectid = bytenr;
@@ -2633,6 +2684,7 @@ static noinline int check_committed_ref(struct btrfs_trans_handle *trans,
 
 	ret = 1;
 	item_size = btrfs_item_size_nr(leaf, path->slots[0]);
+	bi_size = btrfs_extent_inline_ref_size(BTRFS_EXTENT_DATA_REF_KEY);
 #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
 	if (item_size < sizeof(*ei)) {
 		WARN_ON(item_size != sizeof(struct btrfs_extent_item_v0));
@@ -2640,21 +2692,35 @@ static noinline int check_committed_ref(struct btrfs_trans_handle *trans,
 	}
 #endif
 	ei = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_item);
+	WARN_ON(item_size < sizeof(*ei) + bi_size);
 
-	if (item_size != sizeof(*ei) +
-	    btrfs_extent_inline_ref_size(BTRFS_EXTENT_DATA_REF_KEY))
-		goto out;
+	iref = (struct btrfs_extent_inline_ref *)(ei + 1);
+	ref = (struct btrfs_extent_data_ref *)(&iref->offset);
+
+	/*
+	 * if ref_root is 0, this backref is a special one for space count.
+	 */
+	if (btrfs_extent_data_ref_root(leaf, ref) == 0) {
+		if (item_size != sizeof(*ei) + bi_size * 2)
+			goto out;
+
+		ptr = (unsigned long)iref;
+		ptr += bi_size;
+		iref = (struct btrfs_extent_inline_ref *)ptr;
+		ref = (struct btrfs_extent_data_ref *)(&iref->offset);
+	} else {
+		if (item_size != sizeof(*ei) + bi_size)
+			goto out;
+	}
 
 	if (btrfs_extent_generation(leaf, ei) <=
 	    btrfs_root_last_snapshot(&root->root_item))
 		goto out;
 
-	iref = (struct btrfs_extent_inline_ref *)(ei + 1);
 	if (btrfs_extent_inline_ref_type(leaf, iref) !=
 	    BTRFS_EXTENT_DATA_REF_KEY)
 		goto out;
 
-	ref = (struct btrfs_extent_data_ref *)(&iref->offset);
 	if (btrfs_extent_refs(leaf, ei) !=
 	    btrfs_extent_data_ref_count(leaf, ref) ||
 	    btrfs_extent_data_ref_root(leaf, ref) !=
@@ -4671,6 +4737,7 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 			cache->space_info->bytes_reserved -= num_bytes;
 			cache->space_info->bytes_used += num_bytes;
 			cache->space_info->disk_used += num_bytes * factor;
+
 			spin_unlock(&cache->lock);
 			spin_unlock(&cache->space_info->lock);
 		} else {
@@ -4680,6 +4747,7 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 			cache->space_info->bytes_pinned += num_bytes;
 			cache->space_info->bytes_used -= num_bytes;
 			cache->space_info->disk_used -= num_bytes * factor;
+
 			spin_unlock(&cache->lock);
 			spin_unlock(&cache->space_info->lock);
 
@@ -4687,6 +4755,7 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 					 bytenr, bytenr + num_bytes - 1,
 					 GFP_NOFS | __GFP_NOFAIL);
 		}
+
 		btrfs_put_block_group(cache);
 		total -= num_bytes;
 		bytenr += num_bytes;
@@ -4936,6 +5005,25 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
+static inline u64 get_real_num_bytes(struct extent_buffer *leaf,
+				     struct btrfs_extent_item *ei)
+{
+	struct btrfs_extent_inline_ref *iref;
+	struct btrfs_extent_data_ref *ref;
+	u64 num_bytes;
+
+	iref = (struct btrfs_extent_inline_ref *)(ei + 1);
+	ref = (struct btrfs_extent_data_ref *)(&iref->offset);
+
+	BUG_ON(!iref || !ref);
+	if (btrfs_extent_data_ref_root(leaf, ref) != 0)
+		return 0;
+
+	num_bytes = btrfs_extent_data_ref_offset(leaf, ref);
+
+	return num_bytes;
+}
+
 static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
 				u64 bytenr, u64 num_bytes, u64 parent,
@@ -5068,8 +5156,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 	}
 #endif
 	BUG_ON(item_size < sizeof(*ei));
-	ei = btrfs_item_ptr(leaf, extent_slot,
-			    struct btrfs_extent_item);
+	ei = btrfs_item_ptr(leaf, extent_slot, struct btrfs_extent_item);
 	if (owner_objectid < BTRFS_FIRST_FREE_OBJECTID) {
 		struct btrfs_tree_block_info *bi;
 		BUG_ON(item_size < sizeof(*ei) + sizeof(*bi));
@@ -5102,6 +5189,8 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 				goto abort;
 		}
 	} else {
+		u64 to_free = 0;
+
 		if (found_extent) {
 			BUG_ON(is_data && refs_to_drop !=
 			       extent_data_ref_count(root, path, iref));
@@ -5114,6 +5203,12 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 			}
 		}
 
+		if (is_data)
+			to_free = get_real_num_bytes(leaf, ei);
+
+		if (!to_free)
+			to_free = num_bytes;
+
 		ret = btrfs_del_items(trans, extent_root, path, path->slots[0],
 				      num_to_del);
 		if (ret)
@@ -5126,7 +5221,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 				goto abort;
 		}
 
-		ret = update_block_group(trans, root, bytenr, num_bytes, 0);
+		ret = update_block_group(trans, root, bytenr, to_free, 0);
 		if (ret)
 			goto abort;
 	}
@@ -5289,6 +5384,7 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 					parent, root_objectid, (int)owner,
 					BTRFS_DROP_DELAYED_REF, NULL, for_cow);
 	} else {
+		BUG_ON(root_objectid == 0);
 		ret = btrfs_add_delayed_data_ref(fs_info, trans, bytenr,
 						num_bytes,
 						parent, root_objectid, owner,
@@ -5954,7 +6050,12 @@ static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 	else
 		type = BTRFS_EXTENT_DATA_REF_KEY;
 
-	size = sizeof(*extent_item) + btrfs_extent_inline_ref_size(type);
+	if (parent > 0)
+		size = sizeof(*extent_item) +
+					 btrfs_extent_inline_ref_size(type);
+	else
+		size = sizeof(*extent_item) +
+					 btrfs_extent_inline_ref_size(type) * 2;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -5976,22 +6077,41 @@ static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 	btrfs_set_extent_flags(leaf, extent_item,
 			       flags | BTRFS_EXTENT_FLAG_DATA);
 
-	iref = (struct btrfs_extent_inline_ref *)(extent_item + 1);
-	btrfs_set_extent_inline_ref_type(leaf, iref, type);
 	if (parent > 0) {
 		struct btrfs_shared_data_ref *ref;
+
+		iref = (struct btrfs_extent_inline_ref *)(extent_item + 1);
+		btrfs_set_extent_inline_ref_type(leaf, iref, type);
+
 		ref = (struct btrfs_shared_data_ref *)(iref + 1);
 		btrfs_set_extent_inline_ref_offset(leaf, iref, parent);
 		btrfs_set_shared_data_ref_count(leaf, ref, ref_mod);
 	} else {
 		struct btrfs_extent_data_ref *ref;
+		unsigned long ptr;
+
+		/* special extent backref for read disk num bytes */
+		iref = (struct btrfs_extent_inline_ref *)(extent_item + 1);
+		btrfs_set_extent_inline_ref_type(leaf, iref, type);
+
+		ref = (struct btrfs_extent_data_ref *)(&iref->offset);
+		btrfs_set_extent_data_ref_root(leaf, ref, 0);
+		btrfs_set_extent_data_ref_objectid(leaf, ref, owner);
+		btrfs_set_extent_data_ref_offset(leaf, ref, ins->offset);
+		btrfs_set_extent_data_ref_count(leaf, ref, ref_mod);
+
+		/* first extent backref */
+		ptr = (unsigned long)iref;
+		ptr += btrfs_extent_inline_ref_size(type);
+		iref = (struct btrfs_extent_inline_ref *)ptr;
+		btrfs_set_extent_inline_ref_type(leaf, iref, type);
+
 		ref = (struct btrfs_extent_data_ref *)(&iref->offset);
 		btrfs_set_extent_data_ref_root(leaf, ref, root_objectid);
 		btrfs_set_extent_data_ref_objectid(leaf, ref, owner);
 		btrfs_set_extent_data_ref_offset(leaf, ref, offset);
 		btrfs_set_extent_data_ref_count(leaf, ref, ref_mod);
 	}
-
 	btrfs_mark_buffer_dirty(path->nodes[0]);
 	btrfs_free_path(path);
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8d904dd..61a4484 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1127,6 +1127,13 @@ int set_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
 			      NULL, mask);
 }
 
+int set_extent_pinned(struct extent_io_tree *tree, u64 start, u64 end,
+		     gfp_t mask)
+{
+	return set_extent_bit(tree, start, end, EXTENT_PINNED, NULL,
+			      NULL, mask);
+}
+
 int set_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
 		    int bits, gfp_t mask)
 {
@@ -1156,6 +1163,13 @@ int clear_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
 				EXTENT_DO_ACCOUNTING, 0, 0, NULL, mask);
 }
 
+int clear_extent_pinned(struct extent_io_tree *tree, u64 start, u64 end,
+			gfp_t mask)
+{
+	return clear_extent_bit(tree, start, end,
+				EXTENT_PINNED, 0, 0, NULL, mask);
+}
+
 int set_extent_new(struct extent_io_tree *tree, u64 start, u64 end,
 		     gfp_t mask)
 {
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index faf10eb..c67ab75 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -19,6 +19,7 @@
 #define EXTENT_FIRST_DELALLOC (1 << 12)
 #define EXTENT_NEED_WAIT (1 << 13)
 #define EXTENT_DAMAGED (1 << 14)
+#define EXTENT_PINNED (1 << 15)
 #define EXTENT_IOBITS (EXTENT_LOCKED | EXTENT_WRITEBACK)
 #define EXTENT_CTLBITS (EXTENT_DO_ACCOUNTING | EXTENT_FIRST_DELALLOC)
 
@@ -231,6 +232,10 @@ int set_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
 		     gfp_t mask);
 int clear_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
 		       gfp_t mask);
+int set_extent_pinned(struct extent_io_tree *tree, u64 start, u64 end,
+		      gfp_t mask);
+int clear_extent_pinned(struct extent_io_tree *tree, u64 start, u64 end,
+			gfp_t mask);
 int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		       int bits, int clear_bits, gfp_t mask);
 int set_extent_delalloc(struct extent_io_tree *tree, u64 start, u64 end,
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index d83260d..bfd3836 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -538,6 +538,31 @@ int btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
 	return 0;
 }
 
+int btrfs_return_space_to_free_space(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root, u64 disk_bytenr,
+				u64 num_bytes, u64 owner, u64 drop_start,
+				u64 num_dec)
+{
+	int ret;
+
+	/*
+	 * now we're going to insert a special backref
+	 * whose "offset" field indicates how much space
+	 * the extent want to make a decrement.
+	 */
+	ret = btrfs_inc_extent_ref(trans, root,
+				disk_bytenr, num_bytes, 0,
+				0, owner, num_dec, 0);
+	BUG_ON(ret); /* -ENOMEM */
+
+	/* add [key.offset, end] to free space */
+	set_extent_pinned(root->fs_info->pinned_extents,
+			drop_start, drop_start + num_dec - 1,
+			GFP_NOFS | __GFP_NOFAIL);
+
+	return 0;
+}
+
 /*
  * this is very complex, but the basic idea is to drop all extents
  * in the range start - end.  hint_block is filled in with a block number
@@ -562,10 +587,15 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans, struct inode *inode,
 	u64 num_bytes = 0;
 	u64 extent_offset = 0;
 	u64 extent_end = 0;
+	u64 num_dec = 0;
+	u64 orig = 0;
+	u64 drop_start = 0;
 	int del_nr = 0;
 	int del_slot = 0;
 	int extent_type;
+	int first_half;
 	int recow;
+	int shared = 1;
 	int ret;
 
 	if (drop_cache)
@@ -639,6 +669,29 @@ next_slot:
 			continue;
 		}
 
+		if (extent_type == BTRFS_FILE_EXTENT_REG ||
+		    extent_type == BTRFS_FILE_EXTENT_PREALLOC) {
+			/* for dummy extents */
+			if (disk_bytenr == 0 && num_bytes == 0) {
+				shared = 1;
+			} else {
+				u64 refs = 0;
+				/* for shared extents, we cannot
+				 * reclaim the space
+				 */
+				ret = btrfs_lookup_extent_info(trans, root,
+							 disk_bytenr, num_bytes,
+							 &refs, NULL);
+				if (refs > 1)
+					shared = 1;
+				else
+					shared = 0;
+			}
+		}
+
+		first_half = 0;
+		orig = extent_offset;
+
 		/*
 		 *     | - range to drop - |
 		 *  | -------- extent -------- |
@@ -663,23 +716,30 @@ next_slot:
 					    struct btrfs_file_extent_item);
 			btrfs_set_file_extent_num_bytes(leaf, fi,
 							start - key.offset);
-
 			fi = btrfs_item_ptr(leaf, path->slots[0],
 					    struct btrfs_file_extent_item);
 
+			first_half = 1;
+
 			extent_offset += start - key.offset;
-			btrfs_set_file_extent_offset(leaf, fi, extent_offset);
-			btrfs_set_file_extent_num_bytes(leaf, fi,
-							extent_end - start);
-			btrfs_mark_buffer_dirty(leaf);
 
 			if (disk_bytenr > 0) {
 				ret = btrfs_inc_extent_ref(trans, root,
-						disk_bytenr, num_bytes, 0,
-						root->root_key.objectid,
-						new_key.objectid,
-						start - extent_offset, 0);
-				BUG_ON(ret); /* -ENOMEM */
+					disk_bytenr, num_bytes, 0,
+					root->root_key.objectid,
+					new_key.objectid,
+					new_key.offset - extent_offset, 0);
+				BUG_ON(ret);
+
+				if (!shared) {
+					num_dec = end - start;
+					drop_start = disk_bytenr +
+								 extent_offset;
+					btrfs_return_space_to_free_space(
+						trans, root, disk_bytenr,
+						num_bytes, new_key.objectid,
+						drop_start, num_dec);
+				}
 				*hint_byte = disk_bytenr;
 			}
 			key.offset = start;
@@ -700,8 +760,33 @@ next_slot:
 			btrfs_set_file_extent_num_bytes(leaf, fi,
 							extent_end - end);
 			btrfs_mark_buffer_dirty(leaf);
+
 			if (disk_bytenr > 0) {
-				inode_sub_bytes(inode, end - key.offset);
+				num_dec = end - key.offset;
+
+				/*
+				 *    |---range to drop---|
+				 *    |-------extent-----------|
+				 *  start
+				 *
+				 *  if start is 0,
+				 *  this range includes the checksum start,
+				 *  so we cannot add this range to free space.
+				 *
+				 *  if orig is not 0 and first_half is 0, it
+				 *  indicates that the above case will not
+				 *  take place.
+				 */
+				if (orig && !first_half && !shared) {
+					drop_start = disk_bytenr + orig;
+					btrfs_return_space_to_free_space(trans,
+							 root, disk_bytenr,
+							 num_bytes,
+							 new_key.objectid,
+							 drop_start, num_dec);
+				}
+
+				inode_sub_bytes(inode, num_dec);
 				*hint_byte = disk_bytenr;
 			}
 			break;
@@ -719,8 +804,19 @@ next_slot:
 			btrfs_set_file_extent_num_bytes(leaf, fi,
 							start - key.offset);
 			btrfs_mark_buffer_dirty(leaf);
+
 			if (disk_bytenr > 0) {
-				inode_sub_bytes(inode, extent_end - start);
+				num_dec = extent_end - start;
+				if (!shared) {
+					drop_start = disk_bytenr + orig +
+						     start - key.offset;
+					btrfs_return_space_to_free_space(
+							trans, root,
+							disk_bytenr, num_bytes,
+							new_key.objectid,
+							drop_start, num_dec);
+				}
+				inode_sub_bytes(inode, num_dec);
 				*hint_byte = disk_bytenr;
 			}
 			if (end == extent_end)
@@ -743,20 +839,33 @@ next_slot:
 				del_nr++;
 			}
 
+			num_dec = extent_end - key.offset;
 			if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
-				inode_sub_bytes(inode,
-						extent_end - key.offset);
+				inode_sub_bytes(inode, num_dec);
 				extent_end = ALIGN(extent_end,
 						   root->sectorsize);
 			} else if (disk_bytenr > 0) {
 				ret = btrfs_free_extent(trans, root,
 						disk_bytenr, num_bytes, 0,
 						root->root_key.objectid,
-						key.objectid, key.offset -
-						extent_offset, 0);
+						key.objectid,
+						key.offset - extent_offset, 0);
 				BUG_ON(ret); /* -ENOMEM */
-				inode_sub_bytes(inode,
-						extent_end - key.offset);
+
+				/*
+				 * orig is 0 --> include checksum start
+				 * DO NOT add this extent back to free space
+				 */
+				if (num_dec < num_bytes && orig && !shared) {
+					drop_start = disk_bytenr + orig;
+					btrfs_return_space_to_free_space(trans,
+							root, disk_bytenr,
+							num_bytes,
+							new_key.objectid,
+							drop_start, num_dec);
+				}
+
+				inode_sub_bytes(inode, num_dec);
 				*hint_byte = disk_bytenr;
 			}
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 115bc05..78ce1cc 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3165,6 +3165,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 	u64 extent_offset = 0;
 	u64 item_end = 0;
 	u64 mask = root->sectorsize - 1;
+	u64 num_dec = 0;
 	u32 found_type = (u8)-1;
 	int found_extent;
 	int del_item;
@@ -3257,7 +3258,6 @@ search_again:
 			goto delete;
 
 		if (extent_type != BTRFS_FILE_EXTENT_INLINE) {
-			u64 num_dec;
 			extent_start = btrfs_file_extent_disk_bytenr(leaf, fi);
 			if (!del_item) {
 				u64 orig_num_bytes =
@@ -3277,7 +3277,7 @@ search_again:
 				extent_num_bytes =
 					btrfs_file_extent_disk_num_bytes(leaf,
 									 fi);
-				extent_offset = found_key.offset -
+				extent_offset =
 					btrfs_file_extent_offset(leaf, fi);
 
 				/* FIXME blocksize != 4096 */
@@ -3334,9 +3334,20 @@ delete:
 			btrfs_set_path_blocking(path);
 			ret = btrfs_free_extent(trans, root, extent_start,
 						extent_num_bytes, 0,
-						btrfs_header_owner(leaf),
-						ino, extent_offset, 0);
+						btrfs_header_owner(leaf), ino,
+						found_key.offset -
+							 extent_offset, 0);
 			BUG_ON(ret);
+
+			/* add this extent to free space */
+			if (extent_offset) {
+				u64 drop_start;
+
+				drop_start = extent_start + extent_offset;
+				btrfs_return_space_to_free_space(trans, root,
+						extent_start, extent_num_bytes,
+						ino, drop_start, num_dec);
+			}
 		}
 
 		if (found_type == BTRFS_INODE_ITEM_KEY)
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 017281d..e091689 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -31,6 +31,7 @@
 #include "async-thread.h"
 #include "free-space-cache.h"
 #include "inode-map.h"
+#include "print-tree.h"
 
 /*
  * backref_node, mapping_node and tree_block start with this
@@ -1617,6 +1618,7 @@ int replace_file_extents(struct btrfs_trans_handle *trans,
 
 		ret = get_new_location(rc->data_inode, &new_bytenr,
 				       bytenr, num_bytes);
+
 		if (ret > 0) {
 			WARN_ON(1);
 			continue;
@@ -1627,6 +1629,7 @@ int replace_file_extents(struct btrfs_trans_handle *trans,
 		dirty = 1;
 
 		key.offset -= btrfs_file_extent_offset(leaf, fi);
+
 		ret = btrfs_inc_extent_ref(trans, root, new_bytenr,
 					   num_bytes, parent,
 					   btrfs_header_owner(leaf),
@@ -3329,6 +3332,10 @@ static int find_data_references(struct reloc_control *rc,
 	ref_offset = btrfs_extent_data_ref_offset(leaf, ref);
 	ref_count = btrfs_extent_data_ref_count(leaf, ref);
 
+	/* ref_root 0 is a special extent backref for space count */
+	if (ref_root == 0)
+		return 0;
+
 	/*
 	 * This is an extent belonging to the free space cache, lets just delete
 	 * it and redo the search.
-- 
1.6.5.2

