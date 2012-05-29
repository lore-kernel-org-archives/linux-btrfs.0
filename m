Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp11.hushmail.com ([65.39.178.133]:43263 "EHLO
	smtp11.hushmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab2E2QPx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 May 2012 12:15:53 -0400
Received: from smtp11.hushmail.com (localhost.localdomain [127.0.0.1])
	by smtp11.hushmail.com (Postfix) with SMTP id D55041CC0AB
	for <linux-btrfs@vger.kernel.org>; Tue, 29 May 2012 16:15:52 +0000 (UTC)
Received: from smtp.hushmail.com (w6.hushmail.com [65.39.178.92])
	by smtp11.hushmail.com (Postfix) with ESMTP
	for <linux-btrfs@vger.kernel.org>; Tue, 29 May 2012 16:15:52 +0000 (UTC)
MIME-Version: 1.0
Date: Tue, 29 May 2012 08:15:52 -0800
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Subject: Decrease meta fragments by using a caterpillar band Method (Ver. 2)
From: "WeiFeng Liu" <weifeng.liu@hushmail.com>
Content-Type: text/plain; charset="UTF-8"
Message-Id: <20120529161552.74E9AA6E44@smtp.hushmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


This is a several bugs fixed version since my first patch commit, and added
patch of btrfs-prog


Introduction and brief speculate of values and penalties:

	When a tree block need to be created, we offer, say, 2 or 3 blocks for it, 
then pick one from the continuous blocks. If this tree block needs a cow,
another free block from these continuous blocks can be grabbed, and the old one
is freed for next cow.

	In the most ideal condition only 2 continuous blocks are kept for any times
of cowing a tree block -- image a caterpillar band by which my method is named.

	Given a scene that there are two file systems: one with COW and the other
NOCOW, each has 1GB space for metadata with it's first 100MB has been used, and
let me focus only on ops of modifying metadata and ignore deleting metadata for
simple reason. 

	As we can image that the NOCOW fs would likely keep the layout of its 100MB
meta to most neat: changes can be overwritten in the original places and leave
the rest 900MB untouched. But it is lack of the excellent feature to assure data
integrity which owned only by COW fs.

	However, only modifying metadata though, the COW fs would make holes in 
the first 100MB and write COWed meta into the rest 900MB space, in the extreme
condition, the whole 1GB space would be fragmented finally and scattered by that
100MB metadata. I don't think btrfs will be easily trap into such bad state, as
I understood we have extent, chunk, cluster and maybe other methods(tell me
please) to slow fragmenting, but it seems that there are no dedicate method
(fix me) to help COW getting rid of this type of fragments which NOCOW fs does
not incline to make.

	I introduce the caterpillar band method as a compromise. It use 300MB for
meta to avoid such fragments and without lost of COW feature, in the instance,
that means three countinues blocks are used for a single tree block, the tree
block will be circularly updated(cowed) within its three countinues blocks.

	Penalties? Yes there are, thanks to Arne Jansen and Liu Bo. As Arne Jansen
indicated, the most disadvantage of the method will be that this will basically
limit us to 1/3th of platter speed to write meta when using spinning drives and
to 1/4th if using four countinues blocks for a tree block.

	About readahead, which will be also down to the 1/3th of NOCOW fs rate, but
I would discreetly think it as an advantage rather than penalty comparing worse
condition which COW would get -- nearly since the first COW, the new tree blocks
cowed would be 50MB far away from their original neighbor blocks normally, and
after frequent random modify ops, would the worst conditition be that every
dozen of tree blocks newly cowed are more than 50MB far away from their original
neighbor blocks if in equal probability?

	So permit me to think readahead is only usefull for NOCOW fs in this
scenario, because it always keeps its original 100MB continued, and my way would
keep 1/3 readahead rate vs maybe-zero by pure COW if worstly.

	Of course, both penalties and values are only for metadata and will not
affect user date read/write, my patch is only applied for cow tree blocks. 
	But if there are large number of small files(size<4k), values and penalties
will also affect those small user data R/W.

	I have not made tests for my patch by now, it still need some time to get
more check for both strategy and code in patch and fix possible bugs before
test, any comments are welcome.


Thanks

signed-off-by WeiFeng Liu
523f28f9b3d9c710cacc31dbba644efb1678cf62

---
diff -uprN a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
--- a/fs/btrfs/ctree.c	2012-05-21 18:42:51.000000000 +0000
+++ b/fs/btrfs/ctree.c	2012-05-29 23:08:19.000000000 +0000
@@ -444,9 +444,21 @@ static noinline int __btrfs_cow_block(st
 	} else
 		parent_start = 0;
 
-	cow = btrfs_alloc_free_block(trans, root, buf->len, parent_start,
-				     root->root_key.objectid, &disk_key,
-				     level, search_start, empty_size, 1);
+ 	if (root->fs_info->cater_factor > 1) {	
+		if (btrfs_cater_factor(btrfs_header_cater(buf)) > 1)			
+			cow = btrfs_grab_cater_block(trans, root, buf, parent_start,
+							root->root_key.objectid, &disk_key,
+							level, search_start, empty_size, 1);
+		else			
+			cow = btrfs_alloc_free_block_cater(trans, root, buf->len, 
+							parent_start,
+							root->root_key.objectid, &disk_key,
+							level, search_start, empty_size, 1);
+	} else {
+		cow = btrfs_alloc_free_block(trans, root, buf->len, parent_start,
+ 				     root->root_key.objectid, &disk_key,
+ 				     level, search_start, empty_size, 1);
+	}
 	if (IS_ERR(cow))
 		return PTR_ERR(cow);
 
diff -uprN a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
--- a/fs/btrfs/ctree.h	2012-05-21 18:42:51.000000000 +0000
+++ b/fs/btrfs/ctree.h	2012-05-29 23:08:19.000000000 +0000
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
@@ -2445,7 +2462,20 @@ struct extent_buffer *btrfs_alloc_free_b
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
 					u64 hint, u64 empty_size, int for_cow);
+struct extent_buffer *btrfs_alloc_free_block_cater(
+					struct btrfs_trans_handle *trans,
+					struct btrfs_root *root, u32 blocksize,
+					u64 parent, u64 root_objectid,
+					struct btrfs_disk_key *key, int level,
+ 					u64 hint, u64 empty_size, int for_cow);
 void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   struct extent_buffer *buf,
@@ -2453,7 +2483,7 @@ void btrfs_free_tree_block(struct btrfs_
 struct extent_buffer *btrfs_init_new_buffer(struct btrfs_trans_handle *trans,
 					    struct btrfs_root *root,
 					    u64 bytenr, u32 blocksize,
-					    int level);
+					    int level, u8 cater);
 int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *root,
 				     u64 root_objectid, u64 owner,
diff -uprN a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
--- a/fs/btrfs/delayed-ref.h	2012-05-21 18:42:51.000000000 +0000
+++ b/fs/btrfs/delayed-ref.h	2012-05-29 23:08:19.000000000 +0000
@@ -63,6 +63,7 @@ struct btrfs_delayed_extent_op {
 	unsigned int update_key:1;
 	unsigned int update_flags:1;
 	unsigned int is_data:1;
+	u8 cater_index_factor;
 };
 
 /*
diff -uprN a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
--- a/fs/btrfs/extent-tree.c	2012-05-21 18:42:51.000000000 +0000
+++ b/fs/btrfs/extent-tree.c	2012-05-29 23:08:19.000000000 +0000
@@ -87,10 +87,15 @@ static int alloc_reserved_file_extent(st
 				      u64 flags, u64 owner, u64 offset,
 				      struct btrfs_key *ins, int ref_mod);
 static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
-				     struct btrfs_root *root,
-				     u64 parent, u64 root_objectid,
-				     u64 flags, struct btrfs_disk_key *key,
-				     int level, struct btrfs_key *ins);
+						struct btrfs_root *root,
+						u64 parent, u64 root_objectid,
+						u64 flags, struct btrfs_disk_key *key,
+						int level, struct btrfs_key *ins);
+static int alloc_reserved_tree_block_cater(struct btrfs_trans_handle *trans,
+						struct btrfs_root *root,
+						u64 parent, u64 root_objectid,
+						u64 flags, struct btrfs_disk_key *key,
+						int level, struct btrfs_key *ins, u8 cater);
 static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *extent_root, u64 alloc_bytes,
 			  u64 flags, int force);
@@ -1979,9 +1984,9 @@ static int run_delayed_data_ref(struct b
 			flags |= extent_op->flags_to_set;
 		}
 		ret = alloc_reserved_file_extent(trans, root,
-						 parent, ref_root, flags,
-						 ref->objectid, ref->offset,
-						 &ins, node->ref_mod);
+						parent, ref_root, flags,
+						ref->objectid, ref->offset,
+						&ins, node->ref_mod);
 	} else if (node->action == BTRFS_ADD_DELAYED_REF) {
 		ret = __btrfs_inc_extent_ref(trans, root, node->bytenr,
 					     node->num_bytes, parent,
@@ -2101,12 +2106,19 @@ static int run_delayed_tree_ref(struct b
 	BUG_ON(node->ref_mod != 1);
 	if (node->action == BTRFS_ADD_DELAYED_REF && insert_reserved) {
 		BUG_ON(!extent_op || !extent_op->update_flags ||
-		       !extent_op->update_key);
-		ret = alloc_reserved_tree_block(trans, root,
+		       !extent_op->update_key);						
+		if (btrfs_cater_factor(extent_op->cater_index_factor < 2))
+			ret = alloc_reserved_tree_block(trans, root,
+ 						parent, ref_root,
+ 						extent_op->flags_to_set,
+ 						&extent_op->key,
+ 						ref->level, &ins);
+		else
+			ret = alloc_reserved_tree_block_cater(trans, root,
 						parent, ref_root,
 						extent_op->flags_to_set,
 						&extent_op->key,
-						ref->level, &ins);
+						ref->level, &ins, extent_op->cater_index_factor);
 	} else if (node->action == BTRFS_ADD_DELAYED_REF) {
 		ret = __btrfs_inc_extent_ref(trans, root, node->bytenr,
 					     node->num_bytes, parent, ref_root,
@@ -4860,6 +4872,8 @@ static int __btrfs_free_extent(struct bt
 	int num_to_del = 1;
 	u32 item_size;
 	u64 refs;
+	u8 factor = btrfs_cater_factor(extent_op->cater_index_factor);
+	u8 index = btrfs_cater_index(extent_op->cater_index_factor);
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -5024,6 +5038,10 @@ static int __btrfs_free_extent(struct bt
 			     (bytenr + num_bytes - 1) >> PAGE_CACHE_SHIFT);
 		}
 
+		if (btrfs_cater_blocks_free(root, bytenr, num_bytes, factor, index)) {
+			bytenr = bytenr - num_bytes * index;
+			num_bytes = num_bytes * index;
+		}
 		ret = update_block_group(trans, root, bytenr, num_bytes, 0);
 		BUG_ON(ret);
 	}
@@ -5926,6 +5944,7 @@ static int alloc_reserved_file_extent(st
 	btrfs_set_extent_generation(leaf, extent_item, trans->transid);
 	btrfs_set_extent_flags(leaf, extent_item,
 			       flags | BTRFS_EXTENT_FLAG_DATA);
+	btrfs_set_extent_cater(leaf, extent_item, 0);
 
 	iref = (struct btrfs_extent_inline_ref *)(extent_item + 1);
 	btrfs_set_extent_inline_ref_type(leaf, iref, type);
@@ -5987,6 +6006,7 @@ static int alloc_reserved_tree_block(str
 	btrfs_set_extent_generation(leaf, extent_item, trans->transid);
 	btrfs_set_extent_flags(leaf, extent_item,
 			       flags | BTRFS_EXTENT_FLAG_TREE_BLOCK);
+	btrfs_set_extent_cater(leaf, extent_item, 0);
 	block_info = (struct btrfs_tree_block_info *)(extent_item + 1);
 
 	btrfs_set_tree_block_key(leaf, block_info, key);
@@ -6017,6 +6037,77 @@ static int alloc_reserved_tree_block(str
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
@@ -6096,7 +6187,7 @@ int btrfs_alloc_logged_file_extent(struc
 struct extent_buffer *btrfs_init_new_buffer(struct btrfs_trans_handle *trans,
 					    struct btrfs_root *root,
 					    u64 bytenr, u32 blocksize,
-					    int level)
+					    int level, u8 cater)
 {
 	struct extent_buffer *buf;
 
@@ -6104,6 +6195,7 @@ struct extent_buffer *btrfs_init_new_buf
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 	btrfs_set_header_generation(buf, trans->transid);
+	btrfs_set_header_cater(buf, cater);
 	btrfs_set_buffer_lockdep_class(root->root_key.objectid, buf, level);
 	btrfs_tree_lock(buf);
 	clean_tree_block(trans, root, buf);
@@ -6221,7 +6313,201 @@ struct extent_buffer *btrfs_alloc_free_b
 	}
 
 	buf = btrfs_init_new_buffer(trans, root, ins.objectid,
-				    blocksize, level);
+				    blocksize, level, 0);
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
+		extent_op->cater_index_factor = 0;
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
+					int for_cow, u8 index, u8 factor)
+{
+	struct btrfs_key ins;
+	struct btrfs_block_rsv *block_rsv;
+	struct extent_buffer *buf;
+	u64 flags = 0;
+	int ret;
+	u8 cater;
+
+	if (factor < 2)
+		return NULL;
+
+	cater = (index << 4 | factor);
+	ins.objectid = blockprt - blocksize * index;
+	ins.offset = blocksize;
+	
+	/* 
+	 * Here reserving metadata is needed, and unreserving somewhere after 
+	 * commit transaction is also needed, it should be fixed in the future
+	 * - WeiFeng Liu. 
+	 */
+	buf = btrfs_init_new_buffer(trans, root, ins.objectid,
+				    blocksize, level, cater);
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
+			continue;
+	cur = bytenr + buf->len * i;
+	ret = btrfs_lookup_extent(root, cur, buf->len);	
+	BUG_ON(ret);
+	if (ret == 0)
+			continue;
+	eb = __btrfs_grab_cater_block(trans, root, cur, buf->len,
+					parent, root_objectid,
+					key, level, for_cow, i, factor);
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
+
+	if (factor > 1)
+		blocksize = blocksize * factor;
+
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
+				    blocksize, level, factor);
 	BUG_ON(IS_ERR(buf));
 
 	if (root_objectid == BTRFS_TREE_RELOC_OBJECTID) {
@@ -6243,6 +6529,7 @@ struct extent_buffer *btrfs_alloc_free_b
 		extent_op->update_key = 1;
 		extent_op->update_flags = 1;
 		extent_op->is_data = 0;
+		extent_op->cater_index_factor = factor;
 
 		ret = btrfs_add_delayed_tree_ref(root->fs_info, trans,
 					ins.objectid,
diff -uprN a/fs/btrfs/super.c b/fs/btrfs/super.c
--- a/fs/btrfs/super.c	2012-05-21 18:42:51.000000000 +0000
+++ b/fs/btrfs/super.c	2012-05-29 23:08:19.000000000 +0000
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
 
@@ -407,6 +408,15 @@ int btrfs_parse_options(struct btrfs_roo
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
+			break;
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 		case Opt_check_integrity_including_extent_data:
 			printk(KERN_INFO "btrfs: enabling check integrity"

