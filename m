Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp11.hushmail.com ([65.39.178.133]:33767 "EHLO
	smtp11.hushmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab2E0Pvr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 May 2012 11:51:47 -0400
Received: from smtp11.hushmail.com (localhost.localdomain [127.0.0.1])
	by smtp11.hushmail.com (Postfix) with SMTP id 0A7691CC0EB
	for <linux-btrfs@vger.kernel.org>; Sun, 27 May 2012 15:45:24 +0000 (UTC)
Received: from smtp.hushmail.com (w8.hushmail.com [65.39.178.52])
	by smtp11.hushmail.com (Postfix) with ESMTP
	for <linux-btrfs@vger.kernel.org>; Sun, 27 May 2012 15:45:23 +0000 (UTC)
MIME-Version: 1.0
Date: Sun, 27 May 2012 07:45:23 -0800
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH] Decrease Metadata Fragment Using A Caterpillar Band Method
From: "WeiFeng Liu" <weifeng.liu@hushmail.com>
Content-Type: text/plain; charset="UTF-8"
Message-Id: <20120527154523.9775014DBDE@smtp.hushmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

	I made an attempt to partly decrease fragment by using a preallocated
area of multiple size of a std blocksize for a tree block when it is COWed.
	The basic idea is that if any a tree block need to be created, 
we offer, say, 2 or 4 multiples of a std blocksize for it, then use the
first block in the continuous blocks. When this block need a cow in the
future, a new free block in these continuous blocks is grabbed, and
the old one is freed for next cow. In the most ideal condition only 2
continuous blocks are kept for any times of cowing a block -- image a
caterpillar band by which my method is named. 
	Following graphic demostrate the way in the real world by using a area
of 4 multipled std blocksize. The reason I use 4 rather than 2 blocks is that 
we can pick up another free block in the area if the old one is not freed
before it can be used in a cow, this give some tolerance to avoid always to
create a new caterpillar instantly if an old block is occupied.

A --> B --> C --> D -->|
^                      |
|                      v
|---------<------------|


Pros: 
1 Lower computing and searching cost when alloc a tree block.
2 In cows of a block based on finite compact blocks like a ca in theory,
and thereby decrease the chances of fragment.

Cons:
1 Acquire more space for metadata and not suit for user data, obviously.
2 Conflict with SSD wearing leveling optimizing, obviously.

Implementation Notes:
struct btrfs_fs_info has a field cater_factor to store the multiples from
mount option, and struct btrfs_header has a u8 member, it's left-hand 4 bits
to record this block's location index and right-hand 4 bits for multiples,
such a combination indicates how many continuous blocks form a caterpillar
and which slot this tree block resides in the caterpillar.

When cow a block that is already in a caterpillar, simply search a free block
from the first block(index 0) untill the last block(max index) in the
caterpillar.

Cow a block that has not yet been in a caterpillar, firstly we create a
caterpillar using multiples(fs_info->cater_factor), then pick up the first
block in the created caterpillar and give index 0 for the block.

Discard a block that is in a caterpillar, the whole caterpillar can be freed
if no other block is occupied or needed in the caterpillar.

By the time, little tests havw done for the initial patch, both further reviews
and buf-fixs are needed before mature if there are some interesting appeared on
it.

signed-off-by WeiFeng Liu 523f28f9b3d9c710cacc31dbba644efb1678cf62
(weifeng.liu@hushmail.com)
---

--- a/fs/btrfs/ctree.c	2012-05-21 18:42:51.000000000 +0000
+++ b/fs/btrfs/ctree.c	2012-05-27 19:12:16.865575580 +0000
@@ -444,9 +444,21 @@ static noinline int __btrfs_cow_block(st
 	} else
 		parent_start = 0;
 
-	cow = btrfs_alloc_free_block(trans, root, buf->len, parent_start,
+	if (root->fs_info->cater_factor > 1) {	
+		if (btrfs_cater_factor(btrfs_header_cater(buf)) > 1)			
+			cow = btrfs_grab_cater_block(trans, root, buf, parent_start,
+								root->root_key.objectid, &disk_key,
+								level, search_start, empty_size, 1);
+		else			
+			cow = btrfs_alloc_free_block_cater(trans, root, buf->len, parent_start,
+								root->root_key.objectid, &disk_key,
+								level, search_start, empty_size, 1);
+	} else {
+		cow = btrfs_alloc_free_block(trans, root, buf->len, parent_start,
 				     root->root_key.objectid, &disk_key,
 				     level, search_start, empty_size, 1);
+	}
+	
 	if (IS_ERR(cow))
 		return PTR_ERR(cow);
 
diff -urpN a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
--- a/fs/btrfs/ctree.h	2012-05-21 18:42:51.000000000 +0000
+++ b/fs/btrfs/ctree.h	2012-05-27 19:12:16.839574840 +0000
@@ -341,6 +341,7 @@ struct btrfs_header {
 	__le64 owner;
 	__le32 nritems;
 	u8 level;
+	u8 cater_index_factor;
 } __attribute__ ((__packed__));
 
 #define BTRFS_NODEPTRS_PER_BLOCK(r) (((r)->nodesize - \
@@ -544,6 +545,7 @@ struct btrfs_extent_item {
 	__le64 refs;
 	__le64 generation;
 	__le64 flags;
+	u8 cater_index_factor;
 } __attribute__ ((__packed__));
 
 struct btrfs_extent_item_v0 {
@@ -1222,6 +1224,7 @@ struct btrfs_fs_info {
 
 	unsigned data_chunk_allocations;
 	unsigned metadata_ratio;
+	unsigned cater_factor;
 
 	void *bdev_holder;
 
@@ -1761,6 +1764,8 @@ BTRFS_SETGET_FUNCS(extent_refs, struct b
 BTRFS_SETGET_FUNCS(extent_generation, struct btrfs_extent_item,
 		   generation, 64);
 BTRFS_SETGET_FUNCS(extent_flags, struct btrfs_extent_item, flags, 64);
+BTRFS_SETGET_FUNCS(extent_cater, struct btrfs_extent_item,
+			cater_index_factor, 8);
 
 BTRFS_SETGET_FUNCS(extent_refs_v0, struct btrfs_extent_item_v0, refs, 32);
 
@@ -1781,6 +1786,16 @@ static inline void btrfs_set_tree_block_
 	write_eb_member(eb, item, struct btrfs_tree_block_info, key, key);
 }
 
+static inline u8 btrfs_cater_factor(u8 cater_index_factor)
+{
+	return (cater_index_factor & 15);
+}
+
+static inline u8 btrfs_cater_index(u8 cater_index_factor)
+{
+	return (cater_index_factor >> 4);
+}
+
 BTRFS_SETGET_FUNCS(extent_data_ref_root, struct btrfs_extent_data_ref,
 		   root, 64);
 BTRFS_SETGET_FUNCS(extent_data_ref_objectid, struct btrfs_extent_data_ref,
@@ -2042,6 +2057,8 @@ BTRFS_SETGET_HEADER_FUNCS(header_owner,
 BTRFS_SETGET_HEADER_FUNCS(header_nritems, struct btrfs_header, nritems, 32);
 BTRFS_SETGET_HEADER_FUNCS(header_flags, struct btrfs_header, flags, 64);
 BTRFS_SETGET_HEADER_FUNCS(header_level, struct btrfs_header, level, 8);
+BTRFS_SETGET_HEADER_FUNCS(header_cater, struct btrfs_header,
+			cater_index_factor, 8);
 
 static inline int btrfs_header_flag(struct extent_buffer *eb, u64 flag)
 {
@@ -2445,6 +2462,19 @@ struct extent_buffer *btrfs_alloc_free_b
 					struct btrfs_root *root, u32 blocksize,
 					u64 parent, u64 root_objectid,
 					struct btrfs_disk_key *key, int level,
+					u64 hint, u64 empty_size, int for_cow);
+int btrfs_cater_blocks_free(struct btrfs_root *root, u64 start, u64 len,
+					u8 factor, u8 index);
+struct extent_buffer *btrfs_grab_cater_block(struct btrfs_trans_handle *trans,
+					struct btrfs_root *root, struct extent_buffer *buf,
+					u64 parent, u64 root_objectid,
+					struct btrfs_disk_key *key, int level,
+					u64 hint, u64 empty_size, int for_cow);
+struct extent_buffer *btrfs_alloc_free_block_cater(
+					struct btrfs_trans_handle *trans,
+					struct btrfs_root *root, u32 blocksize,
+					u64 parent, u64 root_objectid,
+					struct btrfs_disk_key *key, int level,
 					u64 hint, u64 empty_size, int for_cow);
 void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
diff -urpN a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
--- a/fs/btrfs/delayed-ref.h	2012-05-21 18:42:51.000000000 +0000
+++ b/fs/btrfs/delayed-ref.h	2012-05-27 19:12:16.839574840 +0000
@@ -63,6 +63,7 @@ struct btrfs_delayed_extent_op {
 	unsigned int update_key:1;
 	unsigned int update_flags:1;
 	unsigned int is_data:1;
+	u8 cater_index_factor;
 };
 
 /*
diff -urpN a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
--- a/fs/btrfs/extent-tree.c	2012-05-21 18:42:51.000000000 +0000
+++ b/fs/btrfs/extent-tree.c	2012-05-27 19:12:16.865575580 +0000
@@ -86,11 +86,21 @@ static int alloc_reserved_file_extent(st
 				      u64 parent, u64 root_objectid,
 				      u64 flags, u64 owner, u64 offset,
 				      struct btrfs_key *ins, int ref_mod);
+static int alloc_reserved_file_extent_cater(struct btrfs_trans_handle *trans,
+				      struct btrfs_root *root,
+				      u64 parent, u64 root_objectid,
+				      u64 flags, u64 owner, u64 offset,
+				      struct btrfs_key *ins, int ref_mod, u8 cater);
 static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *root,
 				     u64 parent, u64 root_objectid,
 				     u64 flags, struct btrfs_disk_key *key,
 				     int level, struct btrfs_key *ins);
+static int alloc_reserved_tree_block_cater(struct btrfs_trans_handle *trans,
+				     struct btrfs_root *root,
+				     u64 parent, u64 root_objectid,
+				     u64 flags, struct btrfs_disk_key *key,
+				     int level, struct btrfs_key *ins, u8 cater);
 static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *extent_root, u64 alloc_bytes,
 			  u64 flags, int force);
@@ -1978,10 +1988,16 @@ static int run_delayed_data_ref(struct b
 			BUG_ON(extent_op->update_key);
 			flags |= extent_op->flags_to_set;
 		}
-		ret = alloc_reserved_file_extent(trans, root,
+		if (extent_op->cater_index_factor < 2)
+			ret = alloc_reserved_file_extent(trans, root,
 						 parent, ref_root, flags,
 						 ref->objectid, ref->offset,
 						 &ins, node->ref_mod);
+		else
+			ret = alloc_reserved_file_extent_cater(trans, root,
+						 parent, ref_root, flags,
+						 ref->objectid, ref->offset,
+						 &ins, node->ref_mod, extent_op->cater_index_factor);
 	} else if (node->action == BTRFS_ADD_DELAYED_REF) {
 		ret = __btrfs_inc_extent_ref(trans, root, node->bytenr,
 					     node->num_bytes, parent,
@@ -2102,11 +2118,18 @@ static int run_delayed_tree_ref(struct b
 	if (node->action == BTRFS_ADD_DELAYED_REF && insert_reserved) {
 		BUG_ON(!extent_op || !extent_op->update_flags ||
 		       !extent_op->update_key);
-		ret = alloc_reserved_tree_block(trans, root,
+		if (extent_op->cater_index_factor < 2)
+			ret = alloc_reserved_tree_block(trans, root,
 						parent, ref_root,
 						extent_op->flags_to_set,
 						&extent_op->key,
 						ref->level, &ins);
+		else
+			ret = alloc_reserved_tree_block_cater(trans, root,
+						parent, ref_root,
+						extent_op->flags_to_set,
+						&extent_op->key,
+						ref->level, &ins, extent_op->cater_index_factor);
 	} else if (node->action == BTRFS_ADD_DELAYED_REF) {
 		ret = __btrfs_inc_extent_ref(trans, root, node->bytenr,
 					     node->num_bytes, parent, ref_root,
@@ -4860,6 +4883,8 @@ static int __btrfs_free_extent(struct bt
 	int num_to_del = 1;
 	u32 item_size;
 	u64 refs;
+	u8 factor = btrfs_cater_factor(extent_op->cater_index_factor);
+	u8 index = btrfs_cater_index(extent_op->cater_index_factor);
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -5023,7 +5048,11 @@ static int __btrfs_free_extent(struct bt
 			     bytenr >> PAGE_CACHE_SHIFT,
 			     (bytenr + num_bytes - 1) >> PAGE_CACHE_SHIFT);
 		}
-
+		
+		if (btrfs_cater_blocks_free(root, bytenr, num_bytes, factor, index)) {
+			bytenr = bytenr - num_bytes * index;
+			num_bytes = num_bytes * index;
+		}
 		ret = update_block_group(trans, root, bytenr, num_bytes, 0);
 		BUG_ON(ret);
 	}
@@ -5926,6 +5955,7 @@ static int alloc_reserved_file_extent(st
 	btrfs_set_extent_generation(leaf, extent_item, trans->transid);
 	btrfs_set_extent_flags(leaf, extent_item,
 			       flags | BTRFS_EXTENT_FLAG_DATA);
+	btrfs_set_extent_cater(leaf, extent_item, 0);
 
 	iref = (struct btrfs_extent_inline_ref *)(extent_item + 1);
 	btrfs_set_extent_inline_ref_type(leaf, iref, type);
@@ -5956,6 +5986,84 @@ static int alloc_reserved_file_extent(st
 	return ret;
 }
 
+static int alloc_reserved_file_extent_cater(struct btrfs_trans_handle *trans,
+				      struct btrfs_root *root,
+				      u64 parent, u64 root_objectid,
+				      u64 flags, u64 owner, u64 offset,
+				      struct btrfs_key *ins, int ref_mod, u8 cater)
+{
+	int ret;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_extent_item *extent_item;
+	struct btrfs_extent_inline_ref *iref;
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+	int type;
+	u32 size;
+	u8 factor = btrfs_cater_factor(cater);
+	u8 index = btrfs_cater_index(cater);
+	u64 bytenr = ins->objectid;
+	u64 num_bytes = ins->offset;
+
+	if (parent > 0)
+		type = BTRFS_SHARED_DATA_REF_KEY;
+	else
+		type = BTRFS_EXTENT_DATA_REF_KEY;
+
+	size = sizeof(*extent_item) + btrfs_extent_inline_ref_size(type);
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	path->leave_spinning = 1;
+	ret = btrfs_insert_empty_item(trans, fs_info->extent_root, path,
+				      ins, size);
+	BUG_ON(ret);
+
+	leaf = path->nodes[0];
+	extent_item = btrfs_item_ptr(leaf, path->slots[0],
+				     struct btrfs_extent_item);
+	btrfs_set_extent_refs(leaf, extent_item, ref_mod);
+	btrfs_set_extent_generation(leaf, extent_item, trans->transid);
+	btrfs_set_extent_flags(leaf, extent_item,
+			       flags | BTRFS_EXTENT_FLAG_DATA);
+	btrfs_set_extent_cater(leaf, extent_item, cater);
+
+	iref = (struct btrfs_extent_inline_ref *)(extent_item + 1);
+	btrfs_set_extent_inline_ref_type(leaf, iref, type);
+	if (parent > 0) {
+		struct btrfs_shared_data_ref *ref;
+		ref = (struct btrfs_shared_data_ref *)(iref + 1);
+		btrfs_set_extent_inline_ref_offset(leaf, iref, parent);
+		btrfs_set_shared_data_ref_count(leaf, ref, ref_mod);
+	} else {
+		struct btrfs_extent_data_ref *ref;
+		ref = (struct btrfs_extent_data_ref *)(&iref->offset);
+		btrfs_set_extent_data_ref_root(leaf, ref, root_objectid);
+		btrfs_set_extent_data_ref_objectid(leaf, ref, owner);
+		btrfs_set_extent_data_ref_offset(leaf, ref, offset);
+		btrfs_set_extent_data_ref_count(leaf, ref, ref_mod);
+	}
+
+	btrfs_mark_buffer_dirty(path->nodes[0]);
+	btrfs_free_path(path);
+
+	if (btrfs_cater_blocks_free(root, bytenr, num_bytes, factor, index)) {
+		bytenr = bytenr - num_bytes * index;
+		num_bytes = num_bytes * index;
+	}
+	ret = update_block_group(trans, root, bytenr, num_bytes, 1);
+
+	if (ret) {
+		printk(KERN_ERR "btrfs update block group failed for %llu "
+		       "%llu\n", (unsigned long long)ins->objectid,
+		       (unsigned long long)ins->offset);
+		BUG();
+	}
+	return ret;
+}
+
 static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *root,
 				     u64 parent, u64 root_objectid,
@@ -5987,6 +6095,8 @@ static int alloc_reserved_tree_block(str
 	btrfs_set_extent_generation(leaf, extent_item, trans->transid);
 	btrfs_set_extent_flags(leaf, extent_item,
 			       flags | BTRFS_EXTENT_FLAG_TREE_BLOCK);
+	btrfs_set_extent_cater(leaf, extent_item, 0);
+	
 	block_info = (struct btrfs_tree_block_info *)(extent_item + 1);
 
 	btrfs_set_tree_block_key(leaf, block_info, key);
@@ -6017,6 +6127,77 @@ static int alloc_reserved_tree_block(str
 	return ret;
 }
 
+static int alloc_reserved_tree_block_cater(struct btrfs_trans_handle *trans,
+				     struct btrfs_root *root,
+				     u64 parent, u64 root_objectid,
+				     u64 flags, struct btrfs_disk_key *key,
+				     int level, struct btrfs_key *ins, u8 cater)
+{
+	int ret;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_extent_item *extent_item;
+	struct btrfs_tree_block_info *block_info;
+	struct btrfs_extent_inline_ref *iref;
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+	u32 size = sizeof(*extent_item) + sizeof(*block_info) + sizeof(*iref);
+	u8 factor = btrfs_cater_factor(cater);
+	u8 index = btrfs_cater_index(cater);
+	u64 bytenr = ins->objectid;
+	u64 num_bytes = ins->offset;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	path->leave_spinning = 1;
+	ret = btrfs_insert_empty_item(trans, fs_info->extent_root, path,
+				      ins, size);
+	BUG_ON(ret);
+
+	leaf = path->nodes[0];
+	extent_item = btrfs_item_ptr(leaf, path->slots[0],
+				     struct btrfs_extent_item);
+	btrfs_set_extent_refs(leaf, extent_item, 1);
+	btrfs_set_extent_generation(leaf, extent_item, trans->transid);
+	btrfs_set_extent_flags(leaf, extent_item,
+			       flags | BTRFS_EXTENT_FLAG_TREE_BLOCK);
+	btrfs_set_extent_cater(leaf, extent_item, cater);
+	
+	block_info = (struct btrfs_tree_block_info *)(extent_item + 1);
+
+	btrfs_set_tree_block_key(leaf, block_info, key);
+	btrfs_set_tree_block_level(leaf, block_info, level);
+
+	iref = (struct btrfs_extent_inline_ref *)(block_info + 1);
+	if (parent > 0) {
+		BUG_ON(!(flags & BTRFS_BLOCK_FLAG_FULL_BACKREF));
+		btrfs_set_extent_inline_ref_type(leaf, iref,
+						 BTRFS_SHARED_BLOCK_REF_KEY);
+		btrfs_set_extent_inline_ref_offset(leaf, iref, parent);
+	} else {
+		btrfs_set_extent_inline_ref_type(leaf, iref,
+						 BTRFS_TREE_BLOCK_REF_KEY);
+		btrfs_set_extent_inline_ref_offset(leaf, iref, root_objectid);
+	}
+
+	btrfs_mark_buffer_dirty(leaf);
+	btrfs_free_path(path);
+
+	if (btrfs_cater_blocks_free(root, bytenr, num_bytes, factor, index)) {
+		bytenr = bytenr - num_bytes * index;
+		num_bytes = num_bytes * index;
+	}
+	ret = update_block_group(trans, root, bytenr, num_bytes, 1);
+	if (ret) {
+		printk(KERN_ERR "btrfs update block group failed for %llu "
+		       "%llu\n", (unsigned long long)ins->objectid,
+		       (unsigned long long)ins->offset);
+		BUG();
+	}
+	return ret;
+}
+
 int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *root,
 				     u64 root_objectid, u64 owner,
@@ -6246,6 +6427,195 @@ struct extent_buffer *btrfs_alloc_free_b
 
 		ret = btrfs_add_delayed_tree_ref(root->fs_info, trans,
 					ins.objectid,
+					ins.offset, parent, root_objectid,
+					level, BTRFS_ADD_DELAYED_EXTENT,
+					extent_op, for_cow);
+		BUG_ON(ret);
+	}
+	return buf;
+}
+
+int btrfs_cater_blocks_free(struct btrfs_root *root, u64 start, u64 len,
+				u8 factor, u8 index)
+{
+	u8 i;
+	int ret;
+	u64 bytenr, cur;
+	struct extent_io_tree *tree;
+	struct extent_buffer *eb;
+
+	if (factor < 2 )
+		return 0;
+
+	bytenr = start - len * index;
+	tree = &((BTRFS_I(root->fs_info->btree_inode))->io_tree);
+
+	for (i = 0; i < factor; i++) {
+		if (i == index)
+			continue;
+		cur = bytenr + len * index;
+		ret = btrfs_lookup_extent(root, cur, len);
+		BUG_ON(ret);
+		if (ret == 0)
+			return 0;
+
+		rcu_read_lock();
+		eb = radix_tree_lookup(&tree->buffer, cur >> PAGE_CACHE_SHIFT);
+		if (eb)
+			return 0;
+		rcu_read_unlock();
+	}
+	
+	return 1;
+}
+
+static noinline struct extent_buffer *__btrfs_grab_cater_block(
+					struct btrfs_trans_handle *trans,
+					struct btrfs_root *root,
+					u64 blockprt, u32 blocksize,
+					u64 parent, u64 root_objectid,
+					struct btrfs_disk_key *key, int level,
+					int for_cow, u8 index)
+{
+	struct btrfs_key ins;
+	struct extent_buffer *buf;
+	u64 flags = 0;
+	int ret;
+	u8 factor = root->fs_info->cater_factor;
+
+	if (factor < 2)
+		return NULL;
+		
+	ins.objectid = blockprt - blocksize * index;
+	ins.offset = blocksize;
+	
+	/* 
+	 * Here reserving metadata is needed, and unreserving somewhere
+	 * is also needed, it should be fixed in the future - WeiFeng Liu. 
+	 */
+	buf = btrfs_init_new_buffer(trans, root, ins.objectid,
+				    blocksize, level);
+	BUG_ON(IS_ERR(buf));
+
+	if (root_objectid == BTRFS_TREE_RELOC_OBJECTID) {
+		if (parent == 0)
+			parent = ins.objectid;
+		flags |= BTRFS_BLOCK_FLAG_FULL_BACKREF;
+	} else
+		BUG_ON(parent > 0);
+
+	if (root_objectid != BTRFS_TREE_LOG_OBJECTID) {
+		struct btrfs_delayed_extent_op *extent_op;
+		extent_op = kmalloc(sizeof(*extent_op), GFP_NOFS);
+		BUG_ON(!extent_op);
+		if (key)
+			memcpy(&extent_op->key, key, sizeof(extent_op->key));
+		else
+			memset(&extent_op->key, 0, sizeof(extent_op->key));
+		extent_op->flags_to_set = flags;
+		extent_op->update_key = 1;
+		extent_op->update_flags = 1;
+		extent_op->is_data = 0;
+		extent_op->cater_index_factor = ((index << 4) | factor);
+
+		ret = btrfs_add_delayed_tree_ref(root->fs_info, trans,
+					ins.objectid,
+					ins.offset, parent, root_objectid,
+					level, BTRFS_ADD_DELAYED_EXTENT,
+					extent_op, for_cow);
+		BUG_ON(ret);
+	}
+	return buf;
+}
+
+struct extent_buffer *btrfs_grab_cater_block(struct btrfs_trans_handle *trans,
+					struct btrfs_root *root, struct extent_buffer *buf,
+					u64 parent, u64 root_objectid,
+					struct btrfs_disk_key *key, int level,
+					u64 hint, u64 empty_size, int for_cow)
+{
+	u8 factor, index, i;
+	int ret;
+	u64 bytenr, cur;
+	struct extent_buffer *eb = NULL;
+	
+	index = btrfs_cater_index(btrfs_header_cater(buf));
+	factor = btrfs_cater_factor(btrfs_header_cater(buf));
+	if (factor < 2)
+		return NULL;
+
+	bytenr = buf->start - buf->len * index;
+	for (i = 0; i < factor; i++) {
+		if (i == index)
+		continue;
+	cur = bytenr + buf->len * i;
+	ret = btrfs_lookup_extent(root, cur, buf->len);	
+	BUG_ON(ret);
+	if (ret == 0)
+		continue;
+	eb = __btrfs_grab_cater_block(trans, root, cur, buf->len,
+								parent, root_objectid,
+								key, level, for_cow, i);
+	if (eb)
+		break;
+	}
+	
+	return eb;
+}
+
+struct extent_buffer *btrfs_alloc_free_block_cater(struct btrfs_trans_handle *trans,
+					struct btrfs_root *root, u32 blocksize,
+					u64 parent, u64 root_objectid,
+					struct btrfs_disk_key *key, int level,
+					u64 hint, u64 empty_size, int for_cow)
+{
+	struct btrfs_key ins;
+	struct btrfs_block_rsv *block_rsv;
+	struct extent_buffer *buf;
+	u64 flags = 0;
+	int ret;
+	u8 factor = root->fs_info->cater_factor;
+
+	if (factor > 1)
+		blocksize = blocksize * factor;
+	block_rsv = use_block_rsv(trans, root, blocksize);
+	if (IS_ERR(block_rsv))
+		return ERR_CAST(block_rsv);
+
+	ret = btrfs_reserve_extent(trans, root, blocksize, blocksize,
+				   empty_size, hint, (u64)-1, &ins, 0);
+	if (ret) {
+		unuse_block_rsv(root->fs_info, block_rsv, blocksize);
+		return ERR_PTR(ret);
+	}
+
+	buf = btrfs_init_new_buffer(trans, root, ins.objectid,
+				    blocksize, level);
+	BUG_ON(IS_ERR(buf));
+
+	if (root_objectid == BTRFS_TREE_RELOC_OBJECTID) {
+		if (parent == 0)
+			parent = ins.objectid;
+		flags |= BTRFS_BLOCK_FLAG_FULL_BACKREF;
+	} else
+		BUG_ON(parent > 0);
+
+	if (root_objectid != BTRFS_TREE_LOG_OBJECTID) {
+		struct btrfs_delayed_extent_op *extent_op;
+		extent_op = kmalloc(sizeof(*extent_op), GFP_NOFS);
+		BUG_ON(!extent_op);
+		if (key)
+			memcpy(&extent_op->key, key, sizeof(extent_op->key));
+		else
+			memset(&extent_op->key, 0, sizeof(extent_op->key));
+		extent_op->flags_to_set = flags;
+		extent_op->update_key = 1;
+		extent_op->update_flags = 1;
+		extent_op->is_data = 0;
+		extent_op->cater_index_factor = factor;
+
+		ret = btrfs_add_delayed_tree_ref(root->fs_info, trans,
+					ins.objectid,
 					ins.offset, parent, root_objectid,
 					level, BTRFS_ADD_DELAYED_EXTENT,
 					extent_op, for_cow);
diff -urpN a/fs/btrfs/super.c b/fs/btrfs/super.c
--- a/fs/btrfs/super.c	2012-05-21 18:42:51.000000000 +0000
+++ b/fs/btrfs/super.c	2012-05-27 19:12:16.839574840 +0000
@@ -166,7 +166,7 @@ enum {
 	Opt_enospc_debug, Opt_subvolrootid, Opt_defrag, Opt_inode_cache,
 	Opt_no_space_cache, Opt_recovery, Opt_skip_balance,
 	Opt_check_integrity, Opt_check_integrity_including_extent_data,
-	Opt_check_integrity_print_mask,
+	Opt_check_integrity_print_mask, Opt_cater_factor,
 	Opt_err,
 };
 
@@ -206,6 +206,7 @@ static match_table_t tokens = {
 	{Opt_check_integrity, "check_int"},
 	{Opt_check_integrity_including_extent_data, "check_int_data"},
 	{Opt_check_integrity_print_mask, "check_int_print_mask=%d"},
+	{Opt_cater_factor, "cater_factor=%d"},
 	{Opt_err, NULL},
 };
 
@@ -407,6 +408,14 @@ int btrfs_parse_options(struct btrfs_roo
 		case Opt_skip_balance:
 			btrfs_set_opt(info->mount_opt, SKIP_BALANCE);
 			break;
+		case Opt_cater_factor:
+			match_int(&args[0], &intarg);
+			if (intarg > 16 || intarg < 1)
+				info->cater_factor = 1;
+			else
+				info->cater_factor = intarg;
+			printk(KERN_INFO "btrfs: cater_factor is %d\n",
+						(unsigned char)info->cater_factor);
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 		case Opt_check_integrity_including_extent_data:
 			printk(KERN_INFO "btrfs: enabling check integrity"

