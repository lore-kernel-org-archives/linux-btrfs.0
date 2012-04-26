From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [RFC PATCH v2] Btrfs: improve space count for files with fragments
Date: Thu, 26 Apr 2012 14:39:23 +0800
Message-ID: <1335422363-31198-1-git-send-email-liubo2009@cn.fujitsu.com>
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
Here is the problem, it is possible that an _unshared_ file with lots of
fragments costs nearly double space than its i_size, like:
0k              20k
| --- extent --- |      turned to be on disk    <---  extent --->  <-- A -->
     | - A - |                                  | -------------- | | ----- |
     1k      19k                                       20k + 18k = 38k

                        but what users want is  <---  extent --->  <-- A -->
                                                | --- |     | -- | | ----- |
                                                    1k + 1k + 18k = 20k
so 18k is wasted.

With the current backref design, there is no easy way to fix this, because it
needs to touch several subtle parts, such as delayed ref stuff, extent backref.

So here I give it a try by splitting the extent which we're processing(the idea
comes from Chris :)).

The benifits:
As the above example shows, we'll get three individual extents: 1k + 1k + 18k,
with their checksums are well splitted.

The defects:
Yes, it makes the code much uglier.  And since we've disabled the merging of
delayed refs, we'll get some performance regression.

NOTE:
The patch may still have some bugs since we need more time to tune the subtle
things.

v1->v2:
rewrite the whole patch with a new approach.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       |    8 ++
 fs/btrfs/delayed-ref.c |   56 ++++++++++--
 fs/btrfs/delayed-ref.h |    7 ++
 fs/btrfs/extent-tree.c |  226 ++++++++++++++++++++++++++++++++++++++++++------
 fs/btrfs/extent_io.c   |    2 +-
 fs/btrfs/extent_io.h   |    2 +
 fs/btrfs/file.c        |  180 +++++++++++++++++++++++++++++++++++---
 7 files changed, 430 insertions(+), 51 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 5b8ef8e..77eb89f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2509,6 +2509,10 @@ int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *root,
 				     u64 root_objectid, u64 owner,
 				     u64 offset, struct btrfs_key *ins);
+int btrfs_alloc_pinned_file_extent(struct btrfs_trans_handle *trans,
+				     struct btrfs_root *root,
+				     u64 root_objectid, u64 owner,
+				     u64 offset, struct btrfs_key *ins);
 int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root,
 				   u64 root_objectid, u64 owner, u64 offset,
@@ -2530,6 +2534,10 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root,
 		      u64 bytenr, u64 num_bytes, u64 parent, u64 root_objectid,
 		      u64 owner, u64 offset, int for_cow);
+int btrfs_free_extent_nocsum(struct btrfs_trans_handle *trans,
+		      struct btrfs_root *root,
+		      u64 bytenr, u64 num_bytes, u64 parent, u64 root_objectid,
+		      u64 owner, u64 offset, int for_cow);
 
 int btrfs_free_reserved_extent(struct btrfs_root *root, u64 start, u64 len);
 int btrfs_free_and_pin_reserved_extent(struct btrfs_root *root,
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 69f22e3..059c7d3 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -91,6 +91,10 @@ static int comp_entry(struct btrfs_delayed_ref_node *ref2,
 		return -1;
 	if (ref1->bytenr > ref2->bytenr)
 		return 1;
+	if (ref1->num_bytes > ref2->num_bytes)
+		return -1;
+	if (ref1->num_bytes < ref2->num_bytes)
+		return 1;
 	if (ref1->is_head && ref2->is_head)
 		return 0;
 	if (ref2->is_head)
@@ -160,13 +164,14 @@ static struct btrfs_delayed_ref_node *tree_insert(struct rb_root *root,
  * match is found.
  */
 static struct btrfs_delayed_ref_node *find_ref_head(struct rb_root *root,
-				  u64 bytenr,
+				  u64 bytenr, u64 num_bytes,
 				  struct btrfs_delayed_ref_node **last,
 				  int return_bigger)
 {
 	struct rb_node *n;
 	struct btrfs_delayed_ref_node *entry;
 	int cmp = 0;
+	int precise = (num_bytes < (u64)-1) ? 1 : 0;
 
 again:
 	n = root->rb_node;
@@ -181,6 +186,10 @@ again:
 			cmp = -1;
 		else if (bytenr > entry->bytenr)
 			cmp = 1;
+		else if (precise && num_bytes > entry->num_bytes)
+			cmp = -1;
+		else if (precise && num_bytes < entry->num_bytes)
+			cmp = 1;
 		else if (!btrfs_delayed_ref_is_head(entry))
 			cmp = 1;
 		else
@@ -265,7 +274,7 @@ int btrfs_find_ref_cluster(struct btrfs_trans_handle *trans,
 		node = rb_first(&delayed_refs->root);
 	} else {
 		ref = NULL;
-		find_ref_head(&delayed_refs->root, start + 1, &ref, 1);
+		find_ref_head(&delayed_refs->root, start + 1, (u64)-1, &ref, 1);
 		if (ref) {
 			node = &ref->rb_node;
 		} else
@@ -390,6 +399,10 @@ update_existing_head_ref(struct btrfs_delayed_ref_node *existing,
 		existing->num_bytes = update->num_bytes;
 
 	}
+	if (!ref->drop_csum)
+		existing_ref->drop_csum = ref->drop_csum;
+	if (ref->use_pinned)
+		existing_ref->use_pinned = ref->use_pinned;
 
 	if (ref->extent_op) {
 		if (!existing_ref->extent_op) {
@@ -431,6 +444,8 @@ static noinline void add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 	struct btrfs_delayed_ref_root *delayed_refs;
 	int count_mod = 1;
 	int must_insert_reserved = 0;
+	int drop_csum = 1;
+	int use_pinned = 0;
 
 	/*
 	 * the head node stores the sum of all the mods, so dropping a ref
@@ -438,7 +453,8 @@ static noinline void add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 	 */
 	if (action == BTRFS_UPDATE_DELAYED_HEAD)
 		count_mod = 0;
-	else if (action == BTRFS_DROP_DELAYED_REF)
+	else if (action == BTRFS_DROP_DELAYED_REF ||
+		 action == BTRFS_DROP_DELAYED_REF_NOCSUM)
 		count_mod = -1;
 
 	/*
@@ -452,10 +468,15 @@ static noinline void add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 	 * Once we record must_insert_reserved, switch the action to
 	 * BTRFS_ADD_DELAYED_REF because other special casing is not required.
 	 */
-	if (action == BTRFS_ADD_DELAYED_EXTENT)
+	if (action == BTRFS_ADD_DELAYED_EXTENT ||
+	    action == BTRFS_ADD_DELAYED_EXTENT_PINNED)
 		must_insert_reserved = 1;
-	else
-		must_insert_reserved = 0;
+
+	if (action == BTRFS_DROP_DELAYED_REF_NOCSUM)
+		drop_csum = 0;
+	if (action == BTRFS_ADD_DELAYED_EXTENT_PINNED)
+		use_pinned = 1;
+
 
 	delayed_refs = &trans->transaction->delayed_refs;
 
@@ -473,6 +494,8 @@ static noinline void add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 	head_ref = btrfs_delayed_node_to_head(ref);
 	head_ref->must_insert_reserved = must_insert_reserved;
 	head_ref->is_data = is_data;
+	head_ref->drop_csum = drop_csum;
+	head_ref->use_pinned = use_pinned;
 
 	INIT_LIST_HEAD(&head_ref->cluster);
 	mutex_init(&head_ref->mutex);
@@ -570,7 +593,10 @@ static noinline void add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	struct btrfs_delayed_ref_root *delayed_refs;
 	u64 seq = 0;
 
-	if (action == BTRFS_ADD_DELAYED_EXTENT)
+	if (action == BTRFS_DROP_DELAYED_REF_NOCSUM)
+		action = BTRFS_DROP_DELAYED_REF;
+	if (action == BTRFS_ADD_DELAYED_EXTENT ||
+	    action == BTRFS_ADD_DELAYED_EXTENT_PINNED)
 		action = BTRFS_ADD_DELAYED_REF;
 
 	delayed_refs = &trans->transaction->delayed_refs;
@@ -752,7 +778,21 @@ btrfs_find_delayed_ref_head(struct btrfs_trans_handle *trans, u64 bytenr)
 	struct btrfs_delayed_ref_root *delayed_refs;
 
 	delayed_refs = &trans->transaction->delayed_refs;
-	ref = find_ref_head(&delayed_refs->root, bytenr, NULL, 0);
+	ref = find_ref_head(&delayed_refs->root, bytenr, (u64)-1, NULL, 0);
+	if (ref)
+		return btrfs_delayed_node_to_head(ref);
+	return NULL;
+}
+
+struct btrfs_delayed_ref_head *
+btrfs_find_delayed_ref_head_precisely(struct btrfs_trans_handle *trans,
+				      u64 bytenr, u64 num_bytes)
+{
+	struct btrfs_delayed_ref_node *ref;
+	struct btrfs_delayed_ref_root *delayed_refs;
+
+	delayed_refs = &trans->transaction->delayed_refs;
+	ref = find_ref_head(&delayed_refs->root, bytenr, num_bytes, NULL, 0);
 	if (ref)
 		return btrfs_delayed_node_to_head(ref);
 	return NULL;
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index d8f244d..5769d55 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -23,6 +23,8 @@
 #define BTRFS_DROP_DELAYED_REF   2 /* delete one backref from the tree */
 #define BTRFS_ADD_DELAYED_EXTENT 3 /* record a full extent allocation */
 #define BTRFS_UPDATE_DELAYED_HEAD 4 /* not changing ref count on head ref */
+#define BTRFS_ADD_DELAYED_EXTENT_PINNED 5
+#define BTRFS_DROP_DELAYED_REF_NOCSUM 6
 
 struct btrfs_delayed_ref_node {
 	struct rb_node rb_node;
@@ -95,6 +97,8 @@ struct btrfs_delayed_ref_head {
 	 * we need to update the in ram accounting to properly reflect
 	 * the free has happened.
 	 */
+	unsigned int drop_csum;
+	unsigned int use_pinned;
 	unsigned int must_insert_reserved:1;
 	unsigned int is_data:1;
 };
@@ -190,6 +194,9 @@ int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
 
 struct btrfs_delayed_ref_head *
 btrfs_find_delayed_ref_head(struct btrfs_trans_handle *trans, u64 bytenr);
+struct btrfs_delayed_ref_head *
+btrfs_find_delayed_ref_head_precisely(struct btrfs_trans_handle *trans,
+				      u64 bytenr, u64 num_bytes);
 int btrfs_delayed_ref_lock(struct btrfs_trans_handle *trans,
 			   struct btrfs_delayed_ref_head *head);
 int btrfs_find_ref_cluster(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a844204..0a4e1da 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -71,13 +71,15 @@ enum {
 
 static int update_block_group(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root,
-			      u64 bytenr, u64 num_bytes, int alloc);
+			      u64 bytenr, u64 num_bytes, int alloc,
+			      int use_pinned);
 static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
 				u64 bytenr, u64 num_bytes, u64 parent,
 				u64 root_objectid, u64 owner_objectid,
 				u64 owner_offset, int refs_to_drop,
-				struct btrfs_delayed_extent_op *extra_op);
+				struct btrfs_delayed_extent_op *extra_op,
+				int drop_csum);
 static void __run_delayed_extent_op(struct btrfs_delayed_extent_op *extent_op,
 				    struct extent_buffer *leaf,
 				    struct btrfs_extent_item *ei);
@@ -85,7 +87,8 @@ static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 				      struct btrfs_root *root,
 				      u64 parent, u64 root_objectid,
 				      u64 flags, u64 owner, u64 offset,
-				      struct btrfs_key *ins, int ref_mod);
+				      struct btrfs_key *ins, int ref_mod,
+				      int use_pinned);
 static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *root,
 				     u64 parent, u64 root_objectid,
@@ -809,7 +812,7 @@ again:
 
 	delayed_refs = &trans->transaction->delayed_refs;
 	spin_lock(&delayed_refs->lock);
-	head = btrfs_find_delayed_ref_head(trans, bytenr);
+	head = btrfs_find_delayed_ref_head_precisely(trans, bytenr, num_bytes);
 	if (head) {
 		if (!mutex_trylock(&head->mutex)) {
 			atomic_inc(&head->node.refs);
@@ -826,10 +829,9 @@ again:
 			btrfs_put_delayed_ref(&head->node);
 			goto again;
 		}
+
 		if (head->extent_op && head->extent_op->update_flags)
 			extent_flags |= head->extent_op->flags_to_set;
-		else
-			BUG_ON(num_refs == 0);
 
 		num_refs += head->node.ref_mod;
 		mutex_unlock(&head->mutex);
@@ -1958,7 +1960,8 @@ static int run_delayed_data_ref(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
 				struct btrfs_delayed_ref_node *node,
 				struct btrfs_delayed_extent_op *extent_op,
-				int insert_reserved)
+				int insert_reserved, int drop_csum,
+				int use_pinned)
 {
 	int ret = 0;
 	struct btrfs_delayed_data_ref *ref;
@@ -1985,7 +1988,8 @@ static int run_delayed_data_ref(struct btrfs_trans_handle *trans,
 		ret = alloc_reserved_file_extent(trans, root,
 						 parent, ref_root, flags,
 						 ref->objectid, ref->offset,
-						 &ins, node->ref_mod);
+						 &ins, node->ref_mod,
+						 use_pinned);
 	} else if (node->action == BTRFS_ADD_DELAYED_REF) {
 		ret = __btrfs_inc_extent_ref(trans, root, node->bytenr,
 					     node->num_bytes, parent,
@@ -1997,7 +2001,7 @@ static int run_delayed_data_ref(struct btrfs_trans_handle *trans,
 					  node->num_bytes, parent,
 					  ref_root, ref->objectid,
 					  ref->offset, node->ref_mod,
-					  extent_op);
+					  extent_op, drop_csum);
 	} else {
 		BUG();
 	}
@@ -2121,7 +2125,7 @@ static int run_delayed_tree_ref(struct btrfs_trans_handle *trans,
 	} else if (node->action == BTRFS_DROP_DELAYED_REF) {
 		ret = __btrfs_free_extent(trans, root, node->bytenr,
 					  node->num_bytes, parent, ref_root,
-					  ref->level, 0, 1, extent_op);
+					  ref->level, 0, 1, extent_op, 1);
 	} else {
 		BUG();
 	}
@@ -2133,7 +2137,8 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root,
 			       struct btrfs_delayed_ref_node *node,
 			       struct btrfs_delayed_extent_op *extent_op,
-			       int insert_reserved)
+			       int insert_reserved, int drop_csum,
+			       int use_pinned)
 {
 	int ret = 0;
 
@@ -2168,10 +2173,11 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 		ret = run_delayed_tree_ref(trans, root, node, extent_op,
 					   insert_reserved);
 	else if (node->type == BTRFS_EXTENT_DATA_REF_KEY ||
-		 node->type == BTRFS_SHARED_DATA_REF_KEY)
+		 node->type == BTRFS_SHARED_DATA_REF_KEY) {
 		ret = run_delayed_data_ref(trans, root, node, extent_op,
-					   insert_reserved);
-	else
+					   insert_reserved, drop_csum,
+					   use_pinned);
+	} else
 		BUG();
 	return ret;
 }
@@ -2194,7 +2200,8 @@ again:
 			break;
 		ref = rb_entry(node, struct btrfs_delayed_ref_node,
 				rb_node);
-		if (ref->bytenr != head->node.bytenr)
+		if (ref->bytenr != head->node.bytenr ||
+		    ref->num_bytes != head->node.num_bytes)
 			break;
 		if (ref->action == action)
 			return ref;
@@ -2222,6 +2229,8 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
 	int ret;
 	int count = 0;
 	int must_insert_reserved = 0;
+	int drop_csum = 0;
+	int use_pinned = 0;
 
 	delayed_refs = &trans->transaction->delayed_refs;
 	while (1) {
@@ -2255,7 +2264,6 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
 		 * node back for any delayed ref updates
 		 */
 		ref = select_delayed_ref(locked_ref);
-
 		if (ref && ref->seq &&
 		    btrfs_check_delayed_seq(delayed_refs, ref->seq)) {
 			/*
@@ -2277,7 +2285,11 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
 		 * drop the spin lock.
 		 */
 		must_insert_reserved = locked_ref->must_insert_reserved;
+		drop_csum = locked_ref->drop_csum;
+		use_pinned = locked_ref->use_pinned;
 		locked_ref->must_insert_reserved = 0;
+		locked_ref->drop_csum = 0;
+		locked_ref->use_pinned = 0;
 
 		extent_op = locked_ref->extent_op;
 		locked_ref->extent_op = NULL;
@@ -2325,7 +2337,8 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
 		spin_unlock(&delayed_refs->lock);
 
 		ret = run_one_delayed_ref(trans, root, ref, extent_op,
-					  must_insert_reserved);
+					  must_insert_reserved, drop_csum,
+					  use_pinned);
 
 		btrfs_put_delayed_ref(ref);
 		kfree(extent_op);
@@ -4611,9 +4624,57 @@ void btrfs_delalloc_release_space(struct inode *inode, u64 num_bytes)
 	btrfs_free_reserved_data_space(inode, num_bytes);
 }
 
+static int check_to_use_pinned(struct btrfs_fs_info *info,
+				struct btrfs_block_group_cache *cache,
+				u64 bytenr, u64 num_bytes)
+{
+	u64 pin_start = 0;
+	u64 pin_end = 0;
+	int ret;
+
+	if (!(cache->space_info->flags & BTRFS_BLOCK_GROUP_DATA))
+		return 0;
+
+	ret = find_first_extent_bit(info->pinned_extents, bytenr,
+			    &pin_start, &pin_end, EXTENT_DIRTY);
+	if (ret || pin_start > bytenr || pin_end < bytenr + num_bytes - 1)
+		return 0;
+	return 1;
+}
+
+static noinline
+u64 get_pinned_update_number(struct btrfs_fs_info *info, u64 bytenr,
+			     u64 num_bytes)
+{
+	u64 update = 0;
+	int ret;
+	u64 start = 0;
+	u64 end = 0;
+
+	while (1) {
+		ret = find_first_extent_bit(info->pinned_extents,
+				bytenr, &start, &end, EXTENT_PINNED);
+		if (ret)
+			break;
+		if (start > bytenr + num_bytes - 1)
+			break;
+
+		end = min_t(u64, bytenr + num_bytes - 1, end);
+
+		update += end - start + 1;
+		clear_extent_bits(info->pinned_extents,
+				 start, end,
+				 EXTENT_PINNED | EXTENT_DIRTY,
+				 GFP_NOFS | __GFP_NOFAIL);
+	}
+
+	return update;
+}
+
 static int update_block_group(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root,
-			      u64 bytenr, u64 num_bytes, int alloc)
+			      u64 bytenr, u64 num_bytes, int alloc,
+			      int use_pinned)
 {
 	struct btrfs_block_group_cache *cache = NULL;
 	struct btrfs_fs_info *info = root->fs_info;
@@ -4621,6 +4682,7 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 	u64 old_val;
 	u64 byte_in_group;
 	int factor;
+	int found = 0;
 
 	/* block accounting for super block */
 	spin_lock(&info->delalloc_lock);
@@ -4654,6 +4716,11 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 		byte_in_group = bytenr - cache->key.objectid;
 		WARN_ON(byte_in_group > cache->key.offset);
 
+		/* try to use the pinned extents (special cases) */
+		if (alloc)
+			found = check_to_use_pinned(info, cache, bytenr,
+						    num_bytes);
+
 		spin_lock(&cache->space_info->lock);
 		spin_lock(&cache->lock);
 
@@ -4667,12 +4734,28 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 		if (alloc) {
 			old_val += num_bytes;
 			btrfs_set_block_group_used(&cache->item, old_val);
-			cache->reserved -= num_bytes;
-			cache->space_info->bytes_reserved -= num_bytes;
+			if (!use_pinned) {
+				cache->reserved -= num_bytes;
+				cache->space_info->bytes_reserved -= num_bytes;
+			} else if (found) {
+				cache->pinned -= num_bytes;
+				cache->space_info->bytes_pinned -= num_bytes;
+			}
 			cache->space_info->bytes_used += num_bytes;
 			cache->space_info->disk_used += num_bytes * factor;
 			spin_unlock(&cache->lock);
 			spin_unlock(&cache->space_info->lock);
+
+			if (use_pinned && found) {
+				clear_extent_dirty(info->pinned_extents,
+						 bytenr, bytenr + num_bytes - 1,
+						 GFP_NOFS | __GFP_NOFAIL);
+			} else if (use_pinned && !found) {
+				set_extent_bits(info->pinned_extents,
+						 bytenr, bytenr + num_bytes - 1,
+						 EXTENT_PINNED,
+						 GFP_NOFS | __GFP_NOFAIL);
+			}
 		} else {
 			old_val -= num_bytes;
 			btrfs_set_block_group_used(&cache->item, old_val);
@@ -4686,6 +4769,22 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 			set_extent_dirty(info->pinned_extents,
 					 bytenr, bytenr + num_bytes - 1,
 					 GFP_NOFS | __GFP_NOFAIL);
+			if (cache->space_info->flags & BTRFS_BLOCK_GROUP_DATA) {
+				u64 update = 0;
+
+				update = get_pinned_update_number(
+						info, bytenr, num_bytes);
+
+				if (update) {
+					spin_lock(&cache->space_info->lock);
+					spin_lock(&cache->lock);
+					cache->pinned -= update;
+					cache->space_info->bytes_pinned -=
+									 update;
+					spin_unlock(&cache->lock);
+					spin_unlock(&cache->space_info->lock);
+				}
+			}
 		}
 		btrfs_put_block_group(cache);
 		total -= num_bytes;
@@ -4936,12 +5035,45 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
+static int btrfs_drop_csums(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root,
+			    u64 bytenr, u64 num_bytes, int drop_csum)
+{
+	struct extent_io_tree *tree = root->fs_info->pinned_extents;
+	u64 start = 0;
+	u64 end = 0;
+	int ret = 0;
+
+	if (drop_csum)
+		return btrfs_del_csums(trans, root, bytenr, num_bytes);
+
+	while (1) {
+		ret = find_first_extent_bit(tree, bytenr, &start, &end,
+					    EXTENT_DROP_CSUM);
+		if (ret)
+			break;
+		if (start > bytenr + num_bytes - 1)
+			break;
+
+		end = min_t(u64, bytenr + num_bytes - 1, end);
+		clear_extent_bit(tree, start, end, EXTENT_DROP_CSUM, 0, 0, NULL,
+				 GFP_NOFS | __GFP_NOFAIL);
+		ret = btrfs_del_csums(trans, root, start, end - start + 1);
+		if (ret)
+			goto out;
+	}
+	ret = 0;
+out:
+	return ret;
+}
+
 static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
 				u64 bytenr, u64 num_bytes, u64 parent,
 				u64 root_objectid, u64 owner_objectid,
 				u64 owner_offset, int refs_to_drop,
-				struct btrfs_delayed_extent_op *extent_op)
+				struct btrfs_delayed_extent_op *extent_op,
+				int drop_csum)
 {
 	struct btrfs_key key;
 	struct btrfs_path *path;
@@ -5024,9 +5156,10 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 	} else if (ret == -ENOENT) {
 		btrfs_print_leaf(extent_root, path->nodes[0]);
 		WARN_ON(1);
-		printk(KERN_ERR "btrfs unable to find ref byte nr %llu "
+		printk(KERN_ERR "btrfs unable to find ref byte nr %llu num %llu "
 		       "parent %llu root %llu  owner %llu offset %llu\n",
 		       (unsigned long long)bytenr,
+		       (unsigned long long)num_bytes,
 		       (unsigned long long)parent,
 		       (unsigned long long)root_objectid,
 		       (unsigned long long)owner_objectid,
@@ -5121,12 +5254,13 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 		btrfs_release_path(path);
 
 		if (is_data) {
-			ret = btrfs_del_csums(trans, root, bytenr, num_bytes);
+			ret = btrfs_drop_csums(trans, root, bytenr, num_bytes,
+					       drop_csum);
 			if (ret)
 				goto abort;
 		}
 
-		ret = update_block_group(trans, root, bytenr, num_bytes, 0);
+		ret = update_block_group(trans, root, bytenr, num_bytes, 0, 0);
 		if (ret)
 			goto abort;
 	}
@@ -5298,6 +5432,23 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	return ret;
 }
 
+int btrfs_free_extent_nocsum(struct btrfs_trans_handle *trans,
+			     struct btrfs_root *root,
+			     u64 bytenr, u64 num_bytes, u64 parent,
+			     u64 root_objectid, u64 owner, u64 offset,
+			     int for_cow)
+{
+	int ret;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+
+	ret = btrfs_add_delayed_data_ref(fs_info, trans, bytenr,
+					num_bytes,
+					parent, root_objectid, owner,
+					offset, BTRFS_DROP_DELAYED_REF_NOCSUM,
+					NULL, for_cow);
+	return ret;
+}
+
 static u64 stripe_align(struct btrfs_root *root, u64 val)
 {
 	u64 mask = ((u64)root->stripesize - 1);
@@ -5938,7 +6089,8 @@ static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 				      struct btrfs_root *root,
 				      u64 parent, u64 root_objectid,
 				      u64 flags, u64 owner, u64 offset,
-				      struct btrfs_key *ins, int ref_mod)
+				      struct btrfs_key *ins, int ref_mod,
+				      int use_pinned)
 {
 	int ret;
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -5995,7 +6147,8 @@ static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(path->nodes[0]);
 	btrfs_free_path(path);
 
-	ret = update_block_group(trans, root, ins->objectid, ins->offset, 1);
+	ret = update_block_group(trans, root, ins->objectid,
+				 ins->offset, 1, use_pinned);
 	if (ret) { /* -ENOENT, logic error */
 		printk(KERN_ERR "btrfs update block group failed for %llu "
 		       "%llu\n", (unsigned long long)ins->objectid,
@@ -6059,7 +6212,7 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_free_path(path);
 
-	ret = update_block_group(trans, root, ins->objectid, ins->offset, 1);
+	ret = update_block_group(trans, root, ins->objectid, ins->offset, 1, 0);
 	if (ret) { /* -ENOENT, logic error */
 		printk(KERN_ERR "btrfs update block group failed for %llu "
 		       "%llu\n", (unsigned long long)ins->objectid,
@@ -6085,6 +6238,23 @@ int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+int btrfs_alloc_pinned_file_extent(struct btrfs_trans_handle *trans,
+				     struct btrfs_root *root,
+				     u64 root_objectid, u64 owner,
+				     u64 offset, struct btrfs_key *ins)
+{
+	int ret;
+
+	BUG_ON(root_objectid == BTRFS_TREE_LOG_OBJECTID);
+
+	ret = btrfs_add_delayed_data_ref(root->fs_info, trans, ins->objectid,
+					 ins->offset, 0,
+					 root_objectid, owner, offset,
+					 BTRFS_ADD_DELAYED_EXTENT_PINNED,
+					 NULL, 0);
+	return ret;
+}
+
 /*
  * this is used by the tree logging recovery code.  It records that
  * an extent has been allocated and makes sure to clear the free
@@ -6141,7 +6311,7 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 	BUG_ON(ret); /* logic error */
 	btrfs_put_block_group(block_group);
 	ret = alloc_reserved_file_extent(trans, root, 0, root_objectid,
-					 0, owner, offset, ins, 1);
+					 0, owner, offset, ins, 1, 0);
 	return ret;
 }
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8d904dd..bbae2c3 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -27,7 +27,7 @@ static struct kmem_cache *extent_buffer_cache;
 static LIST_HEAD(buffers);
 static LIST_HEAD(states);
 
-#define LEAK_DEBUG 0
+#define LEAK_DEBUG 1
 #if LEAK_DEBUG
 static DEFINE_SPINLOCK(leak_lock);
 #endif
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index faf10eb..af50703 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -19,6 +19,8 @@
 #define EXTENT_FIRST_DELALLOC (1 << 12)
 #define EXTENT_NEED_WAIT (1 << 13)
 #define EXTENT_DAMAGED (1 << 14)
+#define EXTENT_DROP_CSUM (1 << 15)
+#define EXTENT_PINNED (1 << 16)
 #define EXTENT_IOBITS (EXTENT_LOCKED | EXTENT_WRITEBACK)
 #define EXTENT_CTLBITS (EXTENT_DO_ACCOUNTING | EXTENT_FIRST_DELALLOC)
 
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index d83260d..88c5764 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -538,6 +538,90 @@ int btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
 	return 0;
 }
 
+static int check_shared_file_extent(struct btrfs_trans_handle *trans,
+				    struct btrfs_root *root,
+				    struct btrfs_path *path,
+				    struct btrfs_key *key)
+{
+	struct extent_buffer *l = path->nodes[0];
+	struct btrfs_file_extent_item *fi;
+	u64 bytenr;
+	u64 ext_off;
+	u64 num;
+	u64 refs = 0;
+	int type;
+	int share;
+	int ret = 0;
+
+	if (root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID)
+		return 1;
+
+	fi = btrfs_item_ptr(l, path->slots[0], struct btrfs_file_extent_item);
+	bytenr = btrfs_file_extent_disk_bytenr(l, fi);
+	num = btrfs_file_extent_disk_num_bytes(l, fi);
+	ext_off = btrfs_file_extent_offset(l, fi);
+	type = btrfs_file_extent_type(l, fi);
+
+	share = 1;
+	if (type == BTRFS_FILE_EXTENT_REG ||
+	    type == BTRFS_FILE_EXTENT_PREALLOC) {
+		/* for dummy extents */
+		if (bytenr == 0)
+			goto out;
+		/* for compressed extents */
+		if (btrfs_file_extent_compression(l, fi) ||
+		    btrfs_file_extent_encryption(l, fi) ||
+		    btrfs_file_extent_other_encoding(l, fi))
+			goto out;
+		/* if there are any cow copies or snapshots */
+		if (btrfs_file_extent_generation(l, fi) <=
+		    btrfs_root_last_snapshot(&root->root_item))
+			goto out;
+		ret = btrfs_lookup_extent_info(trans, root, bytenr, num,
+					       &refs, NULL);
+		BUG_ON(ret);
+		if (refs > 1)
+			goto out;
+		share = 0;
+	}
+out:
+	return share;
+}
+
+static void btrfs_update_disk_extent_csum(struct btrfs_root *root,
+					  u64 bytenr, u64 len, gfp_t mask)
+{
+	set_extent_bit(root->fs_info->pinned_extents, bytenr, bytenr + len - 1,
+		       EXTENT_DROP_CSUM, NULL, NULL, mask);
+}
+
+static int btrfs_split_file_extent(struct btrfs_trans_handle *trans,
+				   struct btrfs_root *root,
+				   u64 bytenr, u64 num,
+				   struct btrfs_key *key, u64 offset,
+				   u64 ext_off, u64 len, int free)
+{
+	struct btrfs_key ins_key;
+	int ret;
+
+	if (free) {
+		ret = btrfs_free_extent_nocsum(trans, root, bytenr, num, 0,
+					root->root_key.objectid,
+					key->objectid, offset, 0);
+		BUG_ON(ret);
+	}
+
+	ins_key.objectid = bytenr + ext_off;
+	ins_key.type = BTRFS_EXTENT_ITEM_KEY;
+	ins_key.offset = len;
+	ret = btrfs_alloc_pinned_file_extent(trans, root,
+				root->root_key.objectid, key->objectid,
+				key->offset, &ins_key);
+	BUG_ON(ret);
+
+	return 0;
+}
+
 /*
  * this is very complex, but the basic idea is to drop all extents
  * in the range start - end.  hint_block is filled in with a block number
@@ -562,11 +646,16 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans, struct inode *inode,
 	u64 num_bytes = 0;
 	u64 extent_offset = 0;
 	u64 extent_end = 0;
+	u64 orig_offset = 0;
+	u64 fi_len = 0;
+	u64 de_offset = 0;
 	int del_nr = 0;
 	int del_slot = 0;
 	int extent_type;
 	int recow;
+	int del_whole;
 	int ret;
+	int share = 0;
 
 	if (drop_cache)
 		btrfs_drop_extent_cache(inode, start, end - 1, 0);
@@ -639,6 +728,13 @@ next_slot:
 			continue;
 		}
 
+		del_whole = 1;
+		/* file position where the allocated extent starts */
+		orig_offset = key.offset - extent_offset;
+		de_offset = extent_offset;
+
+		share = check_shared_file_extent(trans, root, path, &key);
+
 		/*
 		 *     | - range to drop - |
 		 *  | -------- extent -------- |
@@ -658,30 +754,40 @@ next_slot:
 			if (ret < 0)
 				break;
 
+			fi_len = start - key.offset;
 			leaf = path->nodes[0];
 			fi = btrfs_item_ptr(leaf, path->slots[0] - 1,
 					    struct btrfs_file_extent_item);
 			btrfs_set_file_extent_num_bytes(leaf, fi,
-							start - key.offset);
-
+							fi_len);
+			if (!share) {
+				btrfs_set_file_extent_disk_num_bytes(leaf, fi,
+							fi_len);
+			}
 			fi = btrfs_item_ptr(leaf, path->slots[0],
 					    struct btrfs_file_extent_item);
-
-			extent_offset += start - key.offset;
-			btrfs_set_file_extent_offset(leaf, fi, extent_offset);
-			btrfs_set_file_extent_num_bytes(leaf, fi,
-							extent_end - start);
+			extent_offset += fi_len;
 			btrfs_mark_buffer_dirty(leaf);
 
 			if (disk_bytenr > 0) {
-				ret = btrfs_inc_extent_ref(trans, root,
+				if (!share) {
+					ret = btrfs_split_file_extent(trans,
+						root, disk_bytenr, num_bytes,
+						&key, orig_offset, de_offset,
+						fi_len, del_whole);
+					BUG_ON(ret);
+					del_whole = 0;
+				} else {
+					ret = btrfs_inc_extent_ref(trans, root,
 						disk_bytenr, num_bytes, 0,
 						root->root_key.objectid,
 						new_key.objectid,
 						start - extent_offset, 0);
-				BUG_ON(ret); /* -ENOMEM */
-				*hint_byte = disk_bytenr;
+					BUG_ON(ret);
+				}
 			}
+
+			de_offset += fi_len;
 			key.offset = start;
 		}
 		/*
@@ -696,11 +802,38 @@ next_slot:
 			btrfs_set_item_key_safe(trans, root, path, &new_key);
 
 			extent_offset += end - key.offset;
-			btrfs_set_file_extent_offset(leaf, fi, extent_offset);
-			btrfs_set_file_extent_num_bytes(leaf, fi,
-							extent_end - end);
+			fi_len = extent_end - end;
+			if (!share) {
+				btrfs_set_file_extent_disk_bytenr(leaf, fi,
+						disk_bytenr + extent_offset);
+				btrfs_set_file_extent_offset(leaf, fi, 0);
+				btrfs_set_file_extent_num_bytes(leaf, fi,
+							fi_len);
+				btrfs_set_file_extent_disk_num_bytes(leaf, fi,
+							fi_len);
+			} else {
+				btrfs_set_file_extent_offset(leaf, fi,
+							extent_offset);
+				btrfs_set_file_extent_num_bytes(leaf, fi,
+							fi_len);
+			}
 			btrfs_mark_buffer_dirty(leaf);
 			if (disk_bytenr > 0) {
+				if (!share) {
+					ret = btrfs_split_file_extent(trans,
+							root, disk_bytenr,
+							num_bytes, &new_key,
+							orig_offset,
+							extent_offset,
+							fi_len,
+							del_whole);
+					BUG_ON(ret);
+					btrfs_update_disk_extent_csum(
+						root,
+						disk_bytenr + de_offset,
+						end - key.offset, GFP_NOFS);
+
+				}
 				inode_sub_bytes(inode, end - key.offset);
 				*hint_byte = disk_bytenr;
 			}
@@ -716,10 +849,29 @@ next_slot:
 			BUG_ON(del_nr > 0);
 			BUG_ON(extent_type == BTRFS_FILE_EXTENT_INLINE);
 
+			fi_len = start - key.offset;
 			btrfs_set_file_extent_num_bytes(leaf, fi,
-							start - key.offset);
+							fi_len);
+			if (!share) {
+				btrfs_set_file_extent_disk_num_bytes(leaf, fi,
+							fi_len);
+			}
 			btrfs_mark_buffer_dirty(leaf);
 			if (disk_bytenr > 0) {
+				if (!share) {
+					ret = btrfs_split_file_extent(trans,
+							root, disk_bytenr,
+							num_bytes, &key,
+							orig_offset, 0,
+							fi_len,
+							del_whole);
+					BUG_ON(ret);
+					btrfs_update_disk_extent_csum(
+						root,
+						disk_bytenr + de_offset +
+						fi_len,
+						extent_end - start, GFP_NOFS);
+				}
 				inode_sub_bytes(inode, extent_end - start);
 				*hint_byte = disk_bytenr;
 			}
-- 
1.6.5.2

