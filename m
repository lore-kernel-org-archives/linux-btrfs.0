From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH 2/6] btrfs: mixed backrefs
Date: Mon, 11 May 2009 23:24:41 +0800
Message-ID: <4A084339.2030501@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The dead tree avoidance patch removes the need to modify the reference
counts of child blocks when a non shared tree block is cow'd. But we
still have to update back ref for all pointers in the block. This is
because the location of tree block is recorded in back ref items. We
can solve this by introducing a new type of back ref. The new back ref
provide information about the owner tree and level of the block in
which the pointer lives. These information allow us to find the block
by tree searching. The shortcoming of the new back ref is that it only
works for pointers in tree blocks referenced by their owner trees.
when a tree block loses its owner tree's reference, we update back ref
for all pointers in the block to full back ref.

This patch is the core part of the mixed backrefs.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 2/fs/btrfs/ctree.h 3/fs/btrfs/ctree.h
--- 2/fs/btrfs/ctree.h	2009-05-11 16:40:51.000000000 +0800
+++ 3/fs/btrfs/ctree.h	2009-05-11 16:56:01.000000000 +0800
@@ -421,23 +421,48 @@ struct btrfs_path {
 	unsigned int keep_locks:1;
 	unsigned int skip_locking:1;
 	unsigned int leave_spinning:1;
+	unsigned int search_commit_root:1;
 };
 
 /*
  * items in the extent btree are used to record the objectid of the
  * owner of the block and the number of references
  */
+
 struct btrfs_extent_item {
-	__le32 refs;
+	__le64 refs;
+	__le64 generation;
+	__le64 flags;
 } __attribute__ ((__packed__));
 
-struct btrfs_extent_ref {
+
+#define BTRFS_EXTENT_FLAG_DATA		(1ULL << 0)
+#define BTRFS_EXTENT_FLAG_TREE_BLOCK	(1ULL << 1)
+
+/* following flags only apply to tree blocks */
+
+/* tree block is not referenced by its owner tree */
+#define BTRFS_BLOCK_NO_OWNER_REF	(1ULL << 8)
+/* use full backrefs for extent pointers in the block */
+#define BTRFS_BLOCK_FULL_BACKREF	(1ULL << 9)
+
+struct btrfs_tree_block_info {
+	struct btrfs_disk_key key;
+	u8 level;
+} __attribute__ ((__packed__));
+
+struct btrfs_extent_data_ref {
 	__le64 root;
-	__le64 generation;
 	__le64 objectid;
-	__le32 num_refs;
+	__le64 offset;
+	__le32 count;
+} __attribute__ ((__packed__));
+
+struct btrfs_shared_data_ref {
+	__le32 count;
 } __attribute__ ((__packed__));
 
+
 /* dev extents record free space on individual devices.  The owner
  * field points back to the chunk allocation mapping tree that allocated
  * the extent.  The chunk tree uuid field is a way to double check the owner
@@ -891,7 +916,6 @@ struct btrfs_fs_info {
  * in ram representation of the tree.  extent_root is used for all allocations
  * and for the extent tree extent_root root.
  */
-struct btrfs_dirty_root;
 struct btrfs_root {
 	struct extent_buffer *node;
 
@@ -1018,7 +1042,16 @@ struct btrfs_root {
  * are used, and how many references there are to each block
  */
 #define BTRFS_EXTENT_ITEM_KEY	168
-#define BTRFS_EXTENT_REF_KEY	180
+
+#define BTRFS_TREE_BLOCK_INFO_KEY	174
+
+#define BTRFS_TREE_BLOCK_REF_KEY	180
+
+#define BTRFS_SHARED_BLOCK_REF_KEY	181
+
+#define BTRFS_EXTENT_DATA_REF_KEY	186
+
+#define BTRFS_SHARED_DATA_REF_KEY	187
 
 /*
  * block groups give us hints into the extent allocation trees.  Which
@@ -1318,24 +1351,39 @@ static inline u8 *btrfs_dev_extent_chunk
 	return (u8 *)((unsigned long)dev + ptr);
 }
 
-/* struct btrfs_extent_ref */
-BTRFS_SETGET_FUNCS(ref_root, struct btrfs_extent_ref, root, 64);
-BTRFS_SETGET_FUNCS(ref_generation, struct btrfs_extent_ref, generation, 64);
-BTRFS_SETGET_FUNCS(ref_objectid, struct btrfs_extent_ref, objectid, 64);
-BTRFS_SETGET_FUNCS(ref_num_refs, struct btrfs_extent_ref, num_refs, 32);
+/* struct btrfs_extent_item */
+BTRFS_SETGET_FUNCS(extent_refs, struct btrfs_extent_item, refs, 64);
+BTRFS_SETGET_FUNCS(extent_generation, struct btrfs_extent_item,
+		   generation, 64);
+BTRFS_SETGET_FUNCS(extent_flags, struct btrfs_extent_item, flags, 64);
 
-BTRFS_SETGET_STACK_FUNCS(stack_ref_root, struct btrfs_extent_ref, root, 64);
-BTRFS_SETGET_STACK_FUNCS(stack_ref_generation, struct btrfs_extent_ref,
-			 generation, 64);
-BTRFS_SETGET_STACK_FUNCS(stack_ref_objectid, struct btrfs_extent_ref,
-			 objectid, 64);
-BTRFS_SETGET_STACK_FUNCS(stack_ref_num_refs, struct btrfs_extent_ref,
-			 num_refs, 32);
+BTRFS_SETGET_FUNCS(tree_block_level, struct btrfs_tree_block_info, level, 8);
 
-/* struct btrfs_extent_item */
-BTRFS_SETGET_FUNCS(extent_refs, struct btrfs_extent_item, refs, 32);
-BTRFS_SETGET_STACK_FUNCS(stack_extent_refs, struct btrfs_extent_item,
-			 refs, 32);
+static inline void btrfs_tree_block_key(struct extent_buffer *eb,
+					struct btrfs_tree_block_info *item,
+					struct btrfs_disk_key *key)
+{
+	read_eb_member(eb, item, struct btrfs_tree_block_info, key, key);
+}
+
+static inline void btrfs_set_tree_block_key(struct extent_buffer *eb,
+					    struct btrfs_tree_block_info *item,
+					    struct btrfs_disk_key *key)
+{
+	write_eb_member(eb, item, struct btrfs_tree_block_info, key, key);
+}
+
+BTRFS_SETGET_FUNCS(extent_data_ref_root, struct btrfs_extent_data_ref,
+		   root, 64);
+BTRFS_SETGET_FUNCS(extent_data_ref_objectid, struct btrfs_extent_data_ref,
+		   objectid, 64);
+BTRFS_SETGET_FUNCS(extent_data_ref_offset, struct btrfs_extent_data_ref,
+		   offset, 64);
+BTRFS_SETGET_FUNCS(extent_data_ref_count, struct btrfs_extent_data_ref,
+		   count, 32);
+
+BTRFS_SETGET_FUNCS(shared_data_ref_count, struct btrfs_shared_data_ref,
+		   count, 32);
 
 /* struct btrfs_node */
 BTRFS_SETGET_FUNCS(key_blockptr, struct btrfs_key_ptr, blockptr, 64);
@@ -1791,39 +1839,32 @@ int btrfs_update_pinned_extents(struct b
 int btrfs_drop_leaf_ref(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root, struct extent_buffer *leaf);
 int btrfs_cross_ref_exist(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root, u64 objectid, u64 bytenr);
+			  struct btrfs_root *root,
+			  u64 objectid, u64 offset, u64 bytenr);
 int btrfs_copy_pinned(struct btrfs_root *root, struct extent_io_tree *copy);
 struct btrfs_block_group_cache *btrfs_lookup_block_group(
 						 struct btrfs_fs_info *info,
 						 u64 bytenr);
+void btrfs_put_block_group(struct btrfs_block_group_cache *cache);
 u64 btrfs_find_block_group(struct btrfs_root *root,
 			   u64 search_start, u64 search_hint, int owner);
 struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
-					     struct btrfs_root *root,
-					     u32 blocksize, u64 parent,
-					     u64 root_objectid,
-					     u64 ref_generation,
-					     int level,
-					     u64 hint,
-					     u64 empty_size);
+					struct btrfs_root *root, u32 blocksize,
+					u64 parent, u64 root_objectid,
+					struct btrfs_disk_key *key, int level,
+					u64 hint, u64 empty_size);
 struct extent_buffer *btrfs_init_new_buffer(struct btrfs_trans_handle *trans,
 					    struct btrfs_root *root,
 					    u64 bytenr, u32 blocksize,
 					    int level);
-int btrfs_alloc_extent(struct btrfs_trans_handle *trans,
-		       struct btrfs_root *root,
-		       u64 num_bytes, u64 parent, u64 min_bytes,
-		       u64 root_objectid, u64 ref_generation,
-		       u64 owner, u64 empty_size, u64 hint_byte,
-		       u64 search_end, struct btrfs_key *ins, u64 data);
-int btrfs_alloc_reserved_extent(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root, u64 parent,
-				u64 root_objectid, u64 ref_generation,
-				u64 owner, struct btrfs_key *ins);
-int btrfs_alloc_logged_extent(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root, u64 parent,
-				u64 root_objectid, u64 ref_generation,
-				u64 owner, struct btrfs_key *ins);
+int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
+				     struct btrfs_root *root,
+				     u64 root_objectid, u64 owner,
+				     u64 offset, struct btrfs_key *ins);
+int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
+				   struct btrfs_root *root,
+				   u64 root_objectid, u64 owner, u64 offset,
+				   struct btrfs_key *ins);
 int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 				  struct btrfs_root *root,
 				  u64 num_bytes, u64 min_alloc_size,
@@ -1831,18 +1872,17 @@ int btrfs_reserve_extent(struct btrfs_tr
 				  u64 search_end, struct btrfs_key *ins,
 				  u64 data);
 int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		  struct extent_buffer *orig_buf, struct extent_buffer *buf,
-		  u32 *nr_extents);
-int btrfs_cache_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		    struct extent_buffer *buf, u32 nr_extents);
-int btrfs_update_ref(struct btrfs_trans_handle *trans,
-		     struct btrfs_root *root, struct extent_buffer *orig_buf,
-		     struct extent_buffer *buf, int start_slot, int nr);
+		  struct extent_buffer *buf, int full_backref);
+int btrfs_dec_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		  struct extent_buffer *buf, int full_backref);
+int btrfs_set_block_flags(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *root,
+			  u64 bytenr, u64 num_bytes, u64 flags);
 int btrfs_free_extent(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root,
 		      u64 bytenr, u64 num_bytes, u64 parent,
-		      u64 root_objectid, u64 ref_generation,
-		      u64 owner_objectid, int pin);
+		      u64 root_objectid, u64 owner, u64 offset);
+
 int btrfs_free_reserved_extent(struct btrfs_root *root, u64 start, u64 len);
 int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root,
@@ -1850,13 +1890,8 @@ int btrfs_finish_extent_commit(struct bt
 int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root,
 			 u64 bytenr, u64 num_bytes, u64 parent,
-			 u64 root_objectid, u64 ref_generation,
-			 u64 owner_objectid);
-int btrfs_update_extent_ref(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root, u64 bytenr, u64 num_bytes,
-			    u64 orig_parent, u64 parent,
-			    u64 root_objectid, u64 ref_generation,
-			    u64 owner_objectid);
+			 u64 root_objectid, u64 owner, u64 offset);
+
 int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
 				    struct btrfs_root *root);
 int btrfs_extent_readonly(struct btrfs_root *root, u64 bytenr);
@@ -1919,6 +1954,8 @@ int btrfs_copy_root(struct btrfs_trans_h
 		      struct btrfs_root *root,
 		      struct extent_buffer *buf,
 		      struct extent_buffer **cow_ret, u64 new_root_objectid);
+int btrfs_block_can_be_shared(struct btrfs_root *root,
+			      struct extent_buffer *buf);
 int btrfs_extend_item(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, struct btrfs_path *path, u32 data_size);
 int btrfs_truncate_item(struct btrfs_trans_handle *trans,
diff -urp 2/fs/btrfs/extent-tree.c 3/fs/btrfs/extent-tree.c
--- 2/fs/btrfs/extent-tree.c	2009-05-11 15:28:11.000000000 +0800
+++ 3/fs/btrfs/extent-tree.c	2009-05-11 16:56:01.000000000 +0800
@@ -33,40 +33,28 @@
 #include "ref-cache.h"
 #include "free-space-cache.h"
 
-#define PENDING_EXTENT_INSERT 0
-#define PENDING_EXTENT_DELETE 1
-#define PENDING_BACKREF_UPDATE 2
-
-struct pending_extent_op {
-	int type;
-	u64 bytenr;
-	u64 num_bytes;
-	u64 parent;
-	u64 orig_parent;
-	u64 generation;
-	u64 orig_generation;
-	int level;
-	struct list_head list;
-	int del;
-};
-
-static int __btrfs_alloc_reserved_extent(struct btrfs_trans_handle *trans,
-					 struct btrfs_root *root, u64 parent,
-					 u64 root_objectid, u64 ref_generation,
-					 u64 owner, struct btrfs_key *ins,
-					 int ref_mod);
 static int update_reserved_extents(struct btrfs_root *root,
 				   u64 bytenr, u64 num, int reserve);
 static int update_block_group(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root,
 			      u64 bytenr, u64 num_bytes, int alloc,
 			      int mark_free);
-static noinline int __btrfs_free_extent(struct btrfs_trans_handle *trans,
-					struct btrfs_root *root,
-					u64 bytenr, u64 num_bytes, u64 parent,
-					u64 root_objectid, u64 ref_generation,
-					u64 owner_objectid, int pin,
-					int ref_to_drop);
+static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root,
+				u64 bytenr, u64 num_bytes, u64 parent,
+				u64 root_objectid, u64 owner_objectid,
+				u64 owner_offset, int refs_to_drop,
+				struct btrfs_delayed_extent_op *extra_op);
+static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
+				      struct btrfs_root *root, u64 parent,
+				      u64 root_objectid, u64 generation,
+				      u64 owner, u64 offset,
+				      struct btrfs_key *ins, int ref_mod);
+static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
+				     struct btrfs_root *root, u64 parent,
+				     u64 root_objectid, u64 generation,
+				     u64 flags, struct btrfs_disk_key *key,
+				     int level, struct btrfs_key *ins);
 
 static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *extent_root, u64 alloc_bytes,
@@ -453,199 +441,469 @@ int btrfs_lookup_extent(struct btrfs_roo
  *    maintenance.  This is actually the same as #2, but with a slightly
  *    different use case.
  *
+ * There are two kinds of back refs. The implicit back refs is optimized
+ * for pointers in non-shared tree blocks. For a given pointer in a block,
+ * back refs of this kind provide information about the block's owner tree
+ * and the pointer's key. These information allow us to find the block by
+ * b-tree searching. The full back refs is for pointers in tree blocks not
+ * referenced by their owner trees. The location of tree block is recorded
+ * in the back refs. Actually the full back refs is generic, and can be
+ * used in all cases the implicit back refs is used. The major shortcoming
+ * of the full back refs is its overhead. Every time a tree block gets
+ * COWed, we have to update back refs entry for all pointers in it.
+ *
+ * For a newly allocated tree block, we use implicit back refs for
+ * pointers in it. This means most tree related operations only involve
+ * implicit back refs. For a tree block created in old transaction, the
+ * only way to drop a reference is COW the block. So we can detect the
+ * events that tree block loses its owner tree's reference and do the
+ * back refs conversion.
+ *
+ * When a tree block is COW'd through a tree, there are four cases:
+ *
+ * The reference count of the block is one and the tree is the block's
+ * owner tree. Nothing to do in this case.
+ *
+ * The reference count of the block is one and the tree is not the
+ * block's owner tree. In this case, full back refs is used for pointers
+ * in the block. Remove these full back refs, add implicit back refs for
+ * every pointers in the new block.
+ *
+ * The reference count of the block is greater than one and the tree is
+ * the block's owner tree. In this case, implicit back refs is used for
+ * pointers in the block. Add full back refs for every pointers in the
+ * block, increase lower level extents' reference counts. The original
+ * implicit back refs are entailed to the new block.
+ *
+ * The reference count of the block is greater than one and the tree is
+ * not the block's owner tree. Add implicit back refs for every pointer in
+ * the new block, increase lower level extents' reference count.
+ *
+ * Back Reference Key composing:
+ *
+ * The key objectid corresponds to the first byte in the extent,
+ * The key type is used to differentiate between types of back refs.
+ * There are different meanings of the key offset for different types
+ * of back refs.
+ *
  * File extents can be referenced by:
  *
  * - multiple snapshots, subvolumes, or different generations in one subvol
  * - different files inside a single subvolume
  * - different offsets inside a file (bookend extents in file.c)
  *
- * The extent ref structure has fields for:
+ * The extent ref structure for the implicit back refs has fields for:
  *
  * - Objectid of the subvolume root
- * - Generation number of the tree holding the reference
  * - objectid of the file holding the reference
- * - number of references holding by parent node (alway 1 for tree blocks)
- *
- * Btree leaf may hold multiple references to a file extent. In most cases,
- * these references are from same file and the corresponding offsets inside
- * the file are close together.
- *
- * When a file extent is allocated the fields are filled in:
- *     (root_key.objectid, trans->transid, inode objectid, 1)
- *
- * When a leaf is cow'd new references are added for every file extent found
- * in the leaf.  It looks similar to the create case, but trans->transid will
- * be different when the block is cow'd.
- *
- *     (root_key.objectid, trans->transid, inode objectid,
- *      number of references in the leaf)
+ * - original offset in the file
+ * - how many bookend extents
  *
- * When a file extent is removed either during snapshot deletion or
- * file truncation, we find the corresponding back reference and check
- * the following fields:
+ * The key offset for the implicit back refs is hash of the first
+ * three fields.
  *
- *     (btrfs_header_owner(leaf), btrfs_header_generation(leaf),
- *      inode objectid)
+ * The extent ref structure for the full back refs has field for:
  *
- * Btree extents can be referenced by:
+ * - number of pointers in the tree leaf
  *
- * - Different subvolumes
- * - Different generations of the same subvolume
+ * The key offset for the implicit back refs is the first byte of
+ * the tree leaf
  *
- * When a tree block is created, back references are inserted:
+ * When a file extent is allocated, The implicit back refs is used.
+ * the fields are filled in:
  *
- * (root->root_key.objectid, trans->transid, level, 1)
+ *     (root_key.objectid, inode objectid, offset in file, 1)
  *
- * When a tree block is cow'd, new back references are added for all the
- * blocks it points to. If the tree block isn't in reference counted root,
- * the old back references are removed. These new back references are of
- * the form (trans->transid will have increased since creation):
+ * When a file extent is removed file truncation, we find the
+ * corresponding implicit back refs and check the following fields:
  *
- * (root->root_key.objectid, trans->transid, level, 1)
+ *     (btrfs_header_owner(leaf), inode objectid, offset in file)
  *
- * When a backref is in deleting, the following fields are checked:
+ * Btree extents can be referenced by:
  *
- * if backref was for a tree root:
- *     (btrfs_header_owner(itself), btrfs_header_generation(itself), level)
- * else
- *     (btrfs_header_owner(parent), btrfs_header_generation(parent), level)
+ * - Different subvolumes
  *
- * Back Reference Key composing:
+ * Both the implicit back refs and the full back refs for tree blocks
+ * only consist of key. The key offset for the implicit back refs is
+ * objectid of block's owner tree. The key offset for the full back refs
+ * is the first byte of parent block.
  *
- * The key objectid corresponds to the first byte in the extent, the key
- * type is set to BTRFS_EXTENT_REF_KEY, and the key offset is the first
- * byte of parent extent. If a extent is tree root, the key offset is set
- * to the key objectid.
+ * When implicit back refs is used, information about the lowest key and
+ * level of the tree block are required. These information are stored in
+ * tree block info structure.
  */
 
-static noinline int lookup_extent_backref(struct btrfs_trans_handle *trans,
-					  struct btrfs_root *root,
-					  struct btrfs_path *path,
-					  u64 bytenr, u64 parent,
-					  u64 ref_root, u64 ref_generation,
-					  u64 owner_objectid, int del)
+static u64 hash_extent_data_ref(u64 root_objectid, u64 owner, u64 offset)
+{
+	u32 high_crc = ~(u32)0;
+	u32 low_crc = ~(u32)0;
+	__le64 lenum;
+
+	lenum = cpu_to_le64(root_objectid);
+	high_crc = btrfs_crc32c(high_crc, &lenum, sizeof(lenum));
+	lenum = cpu_to_le64(owner);
+	low_crc = btrfs_crc32c(low_crc, &lenum, sizeof(lenum));
+	lenum = cpu_to_le64(offset);
+	low_crc = btrfs_crc32c(low_crc, &lenum, sizeof(lenum));
+
+	return ((u64)high_crc << 31) ^ (u64)low_crc;
+}
+
+static int match_extent_data_ref(struct extent_buffer *leaf,
+				 struct btrfs_extent_data_ref *ref,
+				 u64 root_objectid, u64 owner, u64 offset)
+{
+	if (btrfs_extent_data_ref_root(leaf, ref) != root_objectid ||
+	    btrfs_extent_data_ref_objectid(leaf, ref) != owner ||
+	    btrfs_extent_data_ref_offset(leaf, ref) != offset)
+		return 0;
+	return 1;
+}
+
+static noinline int lookup_extent_data_ref(struct btrfs_trans_handle *trans,
+					   struct btrfs_root *root,
+					   struct btrfs_path *path,
+					   u64 bytenr, u64 parent,
+					   u64 root_objectid,
+					   u64 owner, u64 offset)
 {
 	struct btrfs_key key;
-	struct btrfs_extent_ref *ref;
+	struct btrfs_extent_data_ref *ref;
 	struct extent_buffer *leaf;
-	u64 ref_objectid;
+	u32 nritems;
 	int ret;
+	int recow;
+	int err = -ENOENT;
 
 	key.objectid = bytenr;
-	key.type = BTRFS_EXTENT_REF_KEY;
-	key.offset = parent;
+	if (parent) {
+		key.type = BTRFS_SHARED_DATA_REF_KEY;
+		key.offset = parent;
+	} else {
+		key.type = BTRFS_EXTENT_DATA_REF_KEY;
+		key.offset = hash_extent_data_ref(root_objectid,
+						  owner, offset);
+	}
+again:
+	recow = 0;
+	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+	if (ret < 0) {
+		err = ret;
+		goto fail;
+	}
 
-	ret = btrfs_search_slot(trans, root, &key, path, del ? -1 : 0, 1);
-	if (ret < 0)
-		goto out;
-	if (ret > 0) {
-		ret = -ENOENT;
-		goto out;
+	if (parent) {
+		if (ret > 0)
+			goto fail;
+		return 0;
 	}
 
 	leaf = path->nodes[0];
-	ref = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_ref);
-	ref_objectid = btrfs_ref_objectid(leaf, ref);
-	if (btrfs_ref_root(leaf, ref) != ref_root ||
-	    btrfs_ref_generation(leaf, ref) != ref_generation ||
-	    (ref_objectid != owner_objectid &&
-	     ref_objectid != BTRFS_MULTIPLE_OBJECTIDS)) {
-		ret = -EIO;
-		WARN_ON(1);
-		goto out;
+	nritems = btrfs_header_nritems(leaf);
+	while (1) {
+		if (path->slots[0] >= nritems) {
+			ret = btrfs_next_leaf(root, path);
+			if (ret < 0)
+				err = ret;
+			if (ret)
+				goto fail;
+
+			leaf = path->nodes[0];
+			nritems = btrfs_header_nritems(leaf);
+			recow = 1;
+		}
+
+		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+		if (key.objectid != bytenr ||
+		    key.type != BTRFS_EXTENT_DATA_REF_KEY)
+			goto fail;
+
+		ref = btrfs_item_ptr(leaf, path->slots[0],
+				     struct btrfs_extent_data_ref);
+
+		if (match_extent_data_ref(leaf, ref, root_objectid,
+					  owner, offset)) {
+			if (recow) {
+				btrfs_release_path(root, path);
+				goto again;
+			}
+			err = 0;
+			break;
+		}
+		path->slots[0]++;
 	}
-	ret = 0;
-out:
-	return ret;
+fail:
+	return err;
 }
 
-static noinline int insert_extent_backref(struct btrfs_trans_handle *trans,
-					  struct btrfs_root *root,
-					  struct btrfs_path *path,
-					  u64 bytenr, u64 parent,
-					  u64 ref_root, u64 ref_generation,
-					  u64 owner_objectid,
-					  int refs_to_add)
+static noinline int insert_extent_data_ref(struct btrfs_trans_handle *trans,
+					   struct btrfs_root *root,
+					   struct btrfs_path *path,
+					   u64 bytenr, u64 parent,
+					   u64 root_objectid, u64 owner,
+					   u64 offset, int refs_to_add)
 {
 	struct btrfs_key key;
 	struct extent_buffer *leaf;
-	struct btrfs_extent_ref *ref;
+	u32 size;
 	u32 num_refs;
 	int ret;
 
 	key.objectid = bytenr;
-	key.type = BTRFS_EXTENT_REF_KEY;
-	key.offset = parent;
+	if (parent) {
+		key.type = BTRFS_SHARED_DATA_REF_KEY;
+		key.offset = parent;
+		size = sizeof(struct btrfs_shared_data_ref);
+	} else {
+		key.type = BTRFS_EXTENT_DATA_REF_KEY;
+		key.offset = hash_extent_data_ref(root_objectid,
+						  owner, offset);
+		size = sizeof(struct btrfs_extent_data_ref);
+	}
 
-	ret = btrfs_insert_empty_item(trans, root, path, &key, sizeof(*ref));
-	if (ret == 0) {
-		leaf = path->nodes[0];
-		ref = btrfs_item_ptr(leaf, path->slots[0],
-				     struct btrfs_extent_ref);
-		btrfs_set_ref_root(leaf, ref, ref_root);
-		btrfs_set_ref_generation(leaf, ref, ref_generation);
-		btrfs_set_ref_objectid(leaf, ref, owner_objectid);
-		btrfs_set_ref_num_refs(leaf, ref, refs_to_add);
-	} else if (ret == -EEXIST) {
-		u64 existing_owner;
+	ret = btrfs_insert_empty_item(trans, root, path, &key, size);
+	if (ret && ret != -EEXIST)
+		goto fail;
 
-		BUG_ON(owner_objectid < BTRFS_FIRST_FREE_OBJECTID);
-		leaf = path->nodes[0];
+	leaf = path->nodes[0];
+	if (parent) {
+		struct btrfs_shared_data_ref *ref;
 		ref = btrfs_item_ptr(leaf, path->slots[0],
-				     struct btrfs_extent_ref);
-		if (btrfs_ref_root(leaf, ref) != ref_root ||
-		    btrfs_ref_generation(leaf, ref) != ref_generation) {
-			ret = -EIO;
-			WARN_ON(1);
-			goto out;
+				     struct btrfs_shared_data_ref);
+		if (ret == 0) {
+			btrfs_set_shared_data_ref_count(leaf, ref, refs_to_add);
+		} else {
+			num_refs = btrfs_shared_data_ref_count(leaf, ref);
+			num_refs += refs_to_add;
+			btrfs_set_shared_data_ref_count(leaf, ref, num_refs);
 		}
+	} else {
+		struct btrfs_extent_data_ref *ref;
+		while (ret == -EEXIST) {
+			ref = btrfs_item_ptr(leaf, path->slots[0],
+					     struct btrfs_extent_data_ref);
+			if (match_extent_data_ref(leaf, ref, root_objectid,
+						  owner, offset))
+				break;
+			btrfs_release_path(root, path);
+			key.offset++;
+			ret = btrfs_insert_empty_item(trans, root, path, &key,
+						      size);
+			if (ret && ret != -EEXIST)
+				goto fail;
 
-		num_refs = btrfs_ref_num_refs(leaf, ref);
-		BUG_ON(num_refs == 0);
-		btrfs_set_ref_num_refs(leaf, ref, num_refs + refs_to_add);
-
-		existing_owner = btrfs_ref_objectid(leaf, ref);
-		if (existing_owner != owner_objectid &&
-		    existing_owner != BTRFS_MULTIPLE_OBJECTIDS) {
-			btrfs_set_ref_objectid(leaf, ref,
-					BTRFS_MULTIPLE_OBJECTIDS);
+			leaf = path->nodes[0];
+		}
+		ref = btrfs_item_ptr(leaf, path->slots[0],
+				     struct btrfs_extent_data_ref);
+		if (ret == 0) {
+			btrfs_set_extent_data_ref_root(leaf, ref,
+						       root_objectid);
+			btrfs_set_extent_data_ref_objectid(leaf, ref, owner);
+			btrfs_set_extent_data_ref_offset(leaf, ref, offset);
+			btrfs_set_extent_data_ref_count(leaf, ref, refs_to_add);
+		} else {
+			num_refs = btrfs_extent_data_ref_count(leaf, ref);
+			num_refs += refs_to_add;
+			btrfs_set_extent_data_ref_count(leaf, ref, num_refs);
 		}
-		ret = 0;
-	} else {
-		goto out;
 	}
 	btrfs_unlock_up_safe(path, 1);
-	btrfs_mark_buffer_dirty(path->nodes[0]);
-out:
+	btrfs_mark_buffer_dirty(leaf);
+	ret = 0;
+fail:
 	btrfs_release_path(root, path);
 	return ret;
 }
 
-static noinline int remove_extent_backref(struct btrfs_trans_handle *trans,
-					  struct btrfs_root *root,
-					  struct btrfs_path *path,
-					  int refs_to_drop)
+static noinline int remove_extent_data_ref(struct btrfs_trans_handle *trans,
+					   struct btrfs_root *root,
+					   struct btrfs_path *path,
+					   int refs_to_drop)
 {
+	struct btrfs_key key;
+	struct btrfs_extent_data_ref *ref1 = NULL;
+	struct btrfs_shared_data_ref *ref2 = NULL;
 	struct extent_buffer *leaf;
-	struct btrfs_extent_ref *ref;
-	u32 num_refs;
+	u32 num_refs = 0;
 	int ret = 0;
 
 	leaf = path->nodes[0];
-	ref = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_ref);
-	num_refs = btrfs_ref_num_refs(leaf, ref);
+	btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+
+	if (key.type == BTRFS_EXTENT_DATA_REF_KEY) {
+		ref1 = btrfs_item_ptr(leaf, path->slots[0],
+				      struct btrfs_extent_data_ref);
+		num_refs = btrfs_extent_data_ref_count(leaf, ref1);
+	} else if (key.type == BTRFS_SHARED_DATA_REF_KEY) {
+		ref2 = btrfs_item_ptr(leaf, path->slots[0],
+				      struct btrfs_shared_data_ref);
+		num_refs = btrfs_shared_data_ref_count(leaf, ref2);
+	} else {
+		BUG();
+	}
+
 	BUG_ON(num_refs < refs_to_drop);
 	num_refs -= refs_to_drop;
+
 	if (num_refs == 0) {
 		ret = btrfs_del_item(trans, root, path);
 	} else {
-		btrfs_set_ref_num_refs(leaf, ref, num_refs);
+		if (key.type == BTRFS_EXTENT_DATA_REF_KEY)
+			btrfs_set_extent_data_ref_count(leaf, ref1, num_refs);
+		else
+			btrfs_set_shared_data_ref_count(leaf, ref2, num_refs);
+
 		btrfs_mark_buffer_dirty(leaf);
 	}
+	return ret;
+}
+
+static noinline u32 extent_data_ref_count(struct btrfs_root *root,
+					  struct btrfs_path *path)
+{
+	struct btrfs_key key;
+	struct extent_buffer *leaf;
+	u32 num_refs = 0;
+
+	leaf = path->nodes[0];
+	btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+
+	if (key.type == BTRFS_EXTENT_DATA_REF_KEY) {
+		struct btrfs_extent_data_ref *ref1;
+		ref1 = btrfs_item_ptr(leaf, path->slots[0],
+				      struct btrfs_extent_data_ref);
+		num_refs = btrfs_extent_data_ref_count(leaf, ref1);
+	} else if (key.type == BTRFS_SHARED_DATA_REF_KEY) {
+		struct btrfs_shared_data_ref *ref2;
+		ref2 = btrfs_item_ptr(leaf, path->slots[0],
+				      struct btrfs_shared_data_ref);
+		num_refs = btrfs_shared_data_ref_count(leaf, ref2);
+	} else {
+		BUG();
+	}
+	return num_refs;
+}
+
+static noinline int lookup_tree_block_ref(struct btrfs_trans_handle *trans,
+					  struct btrfs_root *root,
+					  struct btrfs_path *path,
+					  u64 bytenr, u64 parent,
+					  u64 root_objectid)
+{
+	struct btrfs_key key;
+	int ret;
+
+	key.objectid = bytenr;
+	if (parent) {
+		key.type = BTRFS_SHARED_BLOCK_REF_KEY;
+		key.offset = parent;
+	} else {
+		key.type = BTRFS_TREE_BLOCK_REF_KEY;
+		key.offset = root_objectid;
+	}
+
+	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+	if (ret > 0)
+		ret = -ENOENT;
+	return ret;
+}
+
+static noinline int insert_tree_block_ref(struct btrfs_trans_handle *trans,
+					  struct btrfs_root *root,
+					  struct btrfs_path *path,
+					  u64 bytenr, u64 parent,
+					  u64 root_objectid)
+{
+	struct btrfs_key key;
+	int ret;
+
+	key.objectid = bytenr;
+	if (parent) {
+		key.type = BTRFS_SHARED_BLOCK_REF_KEY;
+		key.offset = parent;
+	} else {
+		key.type = BTRFS_TREE_BLOCK_REF_KEY;
+		key.offset = root_objectid;
+	}
+
+	ret = btrfs_insert_empty_item(trans, root, path, &key, 0);
+	btrfs_release_path(root, path);
+	return ret;
+}
+
+static noinline int remove_tree_block_info(struct btrfs_trans_handle *trans,
+					   struct btrfs_root *root,
+					   struct btrfs_path *path, u64 bytenr)
+{
+	struct btrfs_key key;
+	int ret;
+
+	key.objectid = bytenr;
+	key.type = BTRFS_TREE_BLOCK_INFO_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+	if (ret > 0)
+		ret = -ENOENT;
+	if (ret == 0)
+		ret = btrfs_del_item(trans, root, path);
+
 	btrfs_release_path(root, path);
 	return ret;
 }
 
+static int lookup_extent_backref(struct btrfs_trans_handle *trans,
+				 struct btrfs_root *root,
+				 struct btrfs_path *path,
+				 u64 bytenr, u64 parent, u64 root_objectid,
+				 u64 owner, u64 offset)
+{
+	int ret;
+	if (owner < BTRFS_FIRST_FREE_OBJECTID) {
+		ret = lookup_tree_block_ref(trans, root, path, bytenr, parent,
+					    root_objectid);
+	} else {
+		ret = lookup_extent_data_ref(trans, root, path, bytenr, parent,
+					     root_objectid, owner, offset);
+	}
+	return ret;
+}
+
+static int insert_extent_backref(struct btrfs_trans_handle *trans,
+				 struct btrfs_root *root,
+				 struct btrfs_path *path,
+				 u64 bytenr, u64 parent, u64 root_objectid,
+				 u64 owner, u64 offset, int refs_to_add)
+{
+	int ret;
+	if (owner < BTRFS_FIRST_FREE_OBJECTID) {
+		BUG_ON(refs_to_add != 1);
+		ret = insert_tree_block_ref(trans, root, path, bytenr,
+					    parent, root_objectid);
+	} else {
+		ret = insert_extent_data_ref(trans, root, path, bytenr,
+					     parent, root_objectid,
+					     owner, offset, refs_to_add);
+	}
+	return ret;
+}
+
+static int remove_extent_backref(struct btrfs_trans_handle *trans,
+				 struct btrfs_root *root,
+				 struct btrfs_path *path,
+				 int refs_to_drop, int is_data)
+{
+	int ret;
+	if (is_data) {
+		ret = remove_extent_data_ref(trans, root, path, refs_to_drop);
+	} else {
+		BUG_ON(refs_to_drop != 1);
+		ret = btrfs_del_item(trans, root, path);
+	}
+	return ret;
+}
+
 #ifdef BIO_RW_DISCARD
 static void btrfs_issue_discard(struct block_device *bdev,
 				u64 start, u64 len)
@@ -686,71 +944,41 @@ static int btrfs_discard_extent(struct b
 #endif
 }
 
-static int __btrfs_update_extent_ref(struct btrfs_trans_handle *trans,
-				     struct btrfs_root *root, u64 bytenr,
-				     u64 num_bytes,
-				     u64 orig_parent, u64 parent,
-				     u64 orig_root, u64 ref_root,
-				     u64 orig_generation, u64 ref_generation,
-				     u64 owner_objectid)
-{
-	int ret;
-	int pin = owner_objectid < BTRFS_FIRST_FREE_OBJECTID;
-
-	ret = btrfs_update_delayed_ref(trans, bytenr, num_bytes,
-				       orig_parent, parent, orig_root,
-				       ref_root, orig_generation,
-				       ref_generation, owner_objectid, pin);
-	BUG_ON(ret);
-	return ret;
-}
-
-int btrfs_update_extent_ref(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root, u64 bytenr,
-			    u64 num_bytes, u64 orig_parent, u64 parent,
-			    u64 ref_root, u64 ref_generation,
-			    u64 owner_objectid)
-{
-	int ret;
-	if (ref_root == BTRFS_TREE_LOG_OBJECTID &&
-	    owner_objectid < BTRFS_FIRST_FREE_OBJECTID)
-		return 0;
-
-	ret = __btrfs_update_extent_ref(trans, root, bytenr, num_bytes,
-					orig_parent, parent, ref_root,
-					ref_root, ref_generation,
-					ref_generation, owner_objectid);
-	return ret;
-}
-static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
-				  struct btrfs_root *root, u64 bytenr,
-				  u64 num_bytes,
-				  u64 orig_parent, u64 parent,
-				  u64 orig_root, u64 ref_root,
-				  u64 orig_generation, u64 ref_generation,
-				  u64 owner_objectid)
+int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
+			 struct btrfs_root *root,
+			 u64 bytenr, u64 num_bytes, u64 parent,
+			 u64 root_objectid, u64 owner, u64 offset)
 {
 	int ret;
+	BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID &&
+	       root_objectid == BTRFS_TREE_LOG_OBJECTID);
 
-	ret = btrfs_add_delayed_ref(trans, bytenr, num_bytes, parent, ref_root,
-				    ref_generation, owner_objectid,
-				    BTRFS_ADD_DELAYED_REF, 0);
-	BUG_ON(ret);
+	if (owner < BTRFS_FIRST_FREE_OBJECTID) {
+		ret = btrfs_add_delayed_tree_ref(trans, bytenr, num_bytes,
+					parent, root_objectid, (int)owner,
+					BTRFS_ADD_DELAYED_REF, NULL);
+	} else {
+		ret = btrfs_add_delayed_data_ref(trans, bytenr, num_bytes,
+					parent, root_objectid, owner, offset,
+					BTRFS_ADD_DELAYED_REF, NULL);
+	}
 	return ret;
 }
 
-static noinline_for_stack int add_extent_ref(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root, u64 bytenr,
-			  u64 num_bytes, u64 parent, u64 ref_root,
-			  u64 ref_generation, u64 owner_objectid,
-			  int refs_to_add)
+static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
+				  struct btrfs_root *root,
+				  u64 bytenr, u64 num_bytes,
+				  u64 parent, u64 root_objectid,
+				  u64 owner, u64 offset, int refs_to_add,
+				  struct btrfs_delayed_extent_op *extra_op)
 {
-	struct btrfs_path *path;
-	int ret;
 	struct btrfs_key key;
+	struct btrfs_path *path;
 	struct extent_buffer *l;
 	struct btrfs_extent_item *item;
-	u32 refs;
+	u64 refs;
+	int ret;
+	int err = 0;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -766,14 +994,14 @@ static noinline_for_stack int add_extent
 	ret = btrfs_search_slot(trans, root->fs_info->extent_root, &key,
 				path, 0, 1);
 	if (ret < 0) {
-		btrfs_set_path_blocking(path);
-		return ret;
+		err = ret;
+		goto out;
 	}
 
 	if (ret > 0) {
 		WARN_ON(1);
-		btrfs_free_path(path);
-		return -EIO;
+		err = -EIO;
+		goto out;
 	}
 	l = path->nodes[0];
 
@@ -791,6 +1019,11 @@ static noinline_for_stack int add_extent
 
 	refs = btrfs_extent_refs(l, item);
 	btrfs_set_extent_refs(l, item, refs + refs_to_add);
+	if (extra_op && extra_op->update_flags) {
+		extra_op->update_flags = 0;
+		extra_op->flags_to_set |= btrfs_extent_flags(l, item);
+		btrfs_set_extent_flags(l, item, extra_op->flags_to_set);
+	}
 	btrfs_unlock_up_safe(path, 1);
 
 	btrfs_mark_buffer_dirty(path->nodes[0]);
@@ -802,56 +1035,208 @@ static noinline_for_stack int add_extent
 
 	/* now insert the actual backref */
 	ret = insert_extent_backref(trans, root->fs_info->extent_root,
-				    path, bytenr, parent,
-				    ref_root, ref_generation,
-				    owner_objectid, refs_to_add);
+				    path, bytenr, parent, root_objectid,
+				    owner, offset, refs_to_add);
 	BUG_ON(ret);
+out:
 	btrfs_free_path(path);
 	return 0;
 }
 
-int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
-			 struct btrfs_root *root,
-			 u64 bytenr, u64 num_bytes, u64 parent,
-			 u64 ref_root, u64 ref_generation,
-			 u64 owner_objectid)
+static int run_delayed_data_ref(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root,
+				struct btrfs_delayed_ref_node *node,
+				struct btrfs_delayed_extent_op *extent_op,
+				int insert_reserved)
 {
-	int ret;
-	if (ref_root == BTRFS_TREE_LOG_OBJECTID &&
-	    owner_objectid < BTRFS_FIRST_FREE_OBJECTID)
-		return 0;
+	int ret = 0;
+	struct btrfs_delayed_data_ref *ref;
+	struct btrfs_key ins;
+	u64 parent = 0;
+	u64 ref_root = 0;
+
+	ins.objectid = node->bytenr;
+	ins.offset = node->num_bytes;
+	ins.type = BTRFS_EXTENT_ITEM_KEY;
+
+	ref = btrfs_delayed_node_to_data_ref(node);
+	if (node->type == BTRFS_SHARED_DATA_REF_KEY)
+		parent = ref->parent;
+	else
+		ref_root = ref->root;
 
-	ret = __btrfs_inc_extent_ref(trans, root, bytenr, num_bytes, 0, parent,
-				     0, ref_root, 0, ref_generation,
-				     owner_objectid);
+	if (node->action == BTRFS_ADD_DELAYED_REF && insert_reserved) {
+		BUG_ON(extent_op);
+		ret = alloc_reserved_file_extent(trans, root, parent,
+						 ref_root, trans->transid,
+						 ref->objectid, ref->offset,
+						 &ins, node->ref_mod);
+		update_reserved_extents(root, ins.objectid, ins.offset, 0);
+	} else if (node->action == BTRFS_ADD_DELAYED_REF) {
+		ret = __btrfs_inc_extent_ref(trans, root, node->bytenr,
+					     node->num_bytes, parent,
+					     ref_root, ref->objectid,
+					     ref->offset, node->ref_mod,
+					     extent_op);
+	} else if (node->action == BTRFS_DROP_DELAYED_REF) {
+		ret = __btrfs_free_extent(trans, root, node->bytenr,
+					  node->num_bytes, parent,
+					  ref_root, ref->objectid,
+					  ref->offset, node->ref_mod,
+					  extent_op);
+	} else {
+		BUG();
+	}
 	return ret;
 }
 
-static int drop_delayed_ref(struct btrfs_trans_handle *trans,
-					struct btrfs_root *root,
-					struct btrfs_delayed_ref_node *node)
+static int run_delayed_tree_ref(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root,
+				struct btrfs_delayed_ref_node *node,
+				struct btrfs_delayed_extent_op *extent_op,
+				int insert_reserved)
 {
 	int ret = 0;
-	struct btrfs_delayed_ref *ref = btrfs_delayed_node_to_ref(node);
+	struct btrfs_delayed_tree_ref *ref;
+	struct btrfs_key ins;
+	u64 parent = 0;
+	u64 ref_root = 0;
 
-	BUG_ON(node->ref_mod == 0);
-	ret = __btrfs_free_extent(trans, root, node->bytenr, node->num_bytes,
-				  node->parent, ref->root, ref->generation,
-				  ref->owner_objectid, ref->pin, node->ref_mod);
+	ins.objectid = node->bytenr;
+	ins.offset = node->num_bytes;
+	ins.type = BTRFS_EXTENT_ITEM_KEY;
+
+	ref = btrfs_delayed_node_to_tree_ref(node);
+	if (node->type == BTRFS_SHARED_BLOCK_REF_KEY)
+		parent = ref->parent;
+	else
+		ref_root = ref->root;
 
+	BUG_ON(node->ref_mod != 1);
+	if (node->action == BTRFS_ADD_DELAYED_REF && insert_reserved) {
+		BUG_ON(!extent_op || !extent_op->update_flags ||
+		       !extent_op->update_key);
+		extent_op->update_key = 0;
+		extent_op->update_flags = 0;
+		ret = alloc_reserved_tree_block(trans, root, parent,
+						ref_root, trans->transid,
+						extent_op->flags_to_set,
+						&extent_op->key,
+						ref->level, &ins);
+		update_reserved_extents(root, ins.objectid, ins.offset, 0);
+	} else if (node->action == BTRFS_ADD_DELAYED_REF) {
+		ret = __btrfs_inc_extent_ref(trans, root, node->bytenr,
+					     node->num_bytes, parent, ref_root,
+					     ref->level, 0, 1, extent_op);
+	} else if (node->action == BTRFS_DROP_DELAYED_REF) {
+		ret = __btrfs_free_extent(trans, root, node->bytenr,
+					  node->num_bytes, parent, ref_root,
+					  ref->level, 0, 1, extent_op);
+	} else {
+		BUG();
+	}
 	return ret;
 }
 
-/* helper function to actually process a single delayed ref entry */
-static noinline int run_one_delayed_ref(struct btrfs_trans_handle *trans,
-					struct btrfs_root *root,
-					struct btrfs_delayed_ref_node *node,
-					int insert_reserved)
+static int run_delayed_extent_op(struct btrfs_trans_handle *trans,
+				 struct btrfs_root *root,
+				 struct btrfs_delayed_ref_node *node,
+				 struct btrfs_delayed_extent_op *extent_op)
 {
+	struct btrfs_key key;
+	struct btrfs_path *path;
+	struct extent_buffer *leaf = NULL;
 	int ret;
-	struct btrfs_delayed_ref *ref;
+	int err = 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	if (extent_op->update_flags) {
+		struct btrfs_extent_item *ei;
+
+		path->reada = 1;
+		path->leave_spinning = 1;
+		key.objectid = node->bytenr;
+		key.type = BTRFS_EXTENT_ITEM_KEY;
+		key.offset = node->num_bytes;
+
+		ret = btrfs_search_slot(trans, root->fs_info->extent_root, &key,
+					path, 0, 1);
+		if (ret < 0) {
+			err = ret;
+			goto out;
+		}
+		if (ret > 0) {
+			err = -EIO;
+			goto out;
+		}
+		leaf = path->nodes[0];
+		ei = btrfs_item_ptr(leaf, path->slots[0],
+				    struct btrfs_extent_item);
+		extent_op->flags_to_set |= btrfs_extent_flags(leaf, ei);
+		btrfs_set_extent_flags(leaf, ei, extent_op->flags_to_set);
+	}
+
+	if (extent_op->update_key) {
+		struct btrfs_tree_block_info *binfo;
+		if (leaf && path->slots[0] + 1 < btrfs_header_nritems(leaf)) {
+			path->slots[0]++;
+			btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+			BUG_ON(key.objectid != node->bytenr ||
+			       key.type != BTRFS_TREE_BLOCK_INFO_KEY);
+			binfo = btrfs_item_ptr(leaf, path->slots[0],
+						struct btrfs_tree_block_info);
+			btrfs_set_tree_block_key(leaf, binfo, &extent_op->key);
+			goto out;
+		}
+
+		if (leaf) {
+			btrfs_unlock_up_safe(path, 1);
+			btrfs_mark_buffer_dirty(leaf);
+			btrfs_release_path(root->fs_info->extent_root, path);
+			leaf = NULL;
+		}
+
+		path->reada = 1;
+		path->leave_spinning = 1;
+		key.objectid = node->bytenr;
+		key.type = BTRFS_TREE_BLOCK_INFO_KEY;
+		key.offset = 0;
 
-	if (node->parent == (u64)-1) {
+		ret = btrfs_search_slot(trans, root->fs_info->extent_root, &key,
+					path, 0, 1);
+		if (ret < 0) {
+			err = ret;
+			goto out;
+		}
+		if (ret > 0) {
+			err = -EIO;
+			goto out;
+		}
+		leaf = path->nodes[0];
+		binfo = btrfs_item_ptr(leaf, path->slots[0],
+					struct btrfs_tree_block_info);
+		btrfs_set_tree_block_key(leaf, binfo, &extent_op->key);
+	}
+out:
+	if (leaf) {
+		btrfs_unlock_up_safe(path, 1);
+		btrfs_mark_buffer_dirty(leaf);
+	}
+	btrfs_free_path(path);
+	return err;
+}
+
+/* helper function to actually process a single delayed ref entry */
+static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *root,
+			       struct btrfs_delayed_ref_node *node,
+			       struct btrfs_delayed_extent_op *extent_op,
+			       int insert_reserved)
+{
+	if (btrfs_delayed_ref_is_head(node)) {
 		struct btrfs_delayed_ref_head *head;
 		/*
 		 * we've hit the end of the chain and we were supposed
@@ -859,7 +1244,10 @@ static noinline int run_one_delayed_ref(
 		 * deleted before we ever needed to insert it, so all
 		 * we have to do is clean up the accounting
 		 */
+		BUG_ON(extent_op);
 		if (insert_reserved) {
+			btrfs_update_pinned_extents(root, node->bytenr,
+						    node->num_bytes, 1);
 			update_reserved_extents(root, node->bytenr,
 						node->num_bytes, 0);
 		}
@@ -868,35 +1256,16 @@ static noinline int run_one_delayed_ref(
 		return 0;
 	}
 
-	ref = btrfs_delayed_node_to_ref(node);
-	if (ref->action == BTRFS_ADD_DELAYED_REF) {
-		if (insert_reserved) {
-			struct btrfs_key ins;
-
-			ins.objectid = node->bytenr;
-			ins.offset = node->num_bytes;
-			ins.type = BTRFS_EXTENT_ITEM_KEY;
-
-			/* record the full extent allocation */
-			ret = __btrfs_alloc_reserved_extent(trans, root,
-					node->parent, ref->root,
-					ref->generation, ref->owner_objectid,
-					&ins, node->ref_mod);
-			update_reserved_extents(root, node->bytenr,
-						node->num_bytes, 0);
-		} else {
-			/* just add one backref */
-			ret = add_extent_ref(trans, root, node->bytenr,
-				     node->num_bytes,
-				     node->parent, ref->root, ref->generation,
-				     ref->owner_objectid, node->ref_mod);
-		}
-		BUG_ON(ret);
-	} else if (ref->action == BTRFS_DROP_DELAYED_REF) {
-		WARN_ON(insert_reserved);
-		ret = drop_delayed_ref(trans, root, node);
-	}
-	return 0;
+	if (node->type == BTRFS_TREE_BLOCK_REF_KEY ||
+	    node->type == BTRFS_SHARED_BLOCK_REF_KEY)
+		return run_delayed_tree_ref(trans, root, node, extent_op,
+					    insert_reserved);
+	else if (node->type == BTRFS_EXTENT_DATA_REF_KEY ||
+		 node->type == BTRFS_SHARED_DATA_REF_KEY)
+		return run_delayed_data_ref(trans, root, node, extent_op,
+					    insert_reserved);
+	BUG();
+	return -1;
 }
 
 static noinline struct btrfs_delayed_ref_node *
@@ -919,7 +1288,7 @@ again:
 				rb_node);
 		if (ref->bytenr != head->node.bytenr)
 			break;
-		if (btrfs_delayed_node_to_ref(ref)->action == action)
+		if (ref->action == action)
 			return ref;
 		node = rb_prev(node);
 	}
@@ -937,6 +1306,7 @@ static noinline int run_clustered_refs(s
 	struct btrfs_delayed_ref_root *delayed_refs;
 	struct btrfs_delayed_ref_node *ref;
 	struct btrfs_delayed_ref_head *locked_ref = NULL;
+	struct btrfs_delayed_extent_op *extent_op;
 	int ret;
 	int count = 0;
 	int must_insert_reserved = 0;
@@ -975,6 +1345,9 @@ static noinline int run_clustered_refs(s
 		must_insert_reserved = locked_ref->must_insert_reserved;
 		locked_ref->must_insert_reserved = 0;
 
+		extent_op = locked_ref->extent_op;
+		locked_ref->extent_op = NULL;
+
 		/*
 		 * locked_ref is the head node, so we have to go one
 		 * node back for any delayed ref updates
@@ -986,6 +1359,25 @@ static noinline int run_clustered_refs(s
 			 * so that any accounting fixes can happen
 			 */
 			ref = &locked_ref->node;
+
+			if (extent_op && must_insert_reserved) {
+				kfree(extent_op);
+				extent_op = NULL;
+			}
+
+			if (extent_op) {
+				spin_unlock(&delayed_refs->lock);
+
+				ret = run_delayed_extent_op(trans, root,
+							    ref, extent_op);
+				BUG_ON(ret);
+				kfree(extent_op);
+
+				cond_resched();
+				spin_lock(&delayed_refs->lock);
+				continue;
+			}
+
 			list_del_init(&locked_ref->cluster);
 			locked_ref = NULL;
 		}
@@ -993,14 +1385,24 @@ static noinline int run_clustered_refs(s
 		ref->in_tree = 0;
 		rb_erase(&ref->rb_node, &delayed_refs->root);
 		delayed_refs->num_entries--;
+
 		spin_unlock(&delayed_refs->lock);
 
-		ret = run_one_delayed_ref(trans, root, ref,
+		ret = run_one_delayed_ref(trans, root, ref, extent_op,
 					  must_insert_reserved);
 		BUG_ON(ret);
-		btrfs_put_delayed_ref(ref);
 
+		if (extent_op &&
+		    (extent_op->update_key || extent_op->update_flags)) {
+			ret = run_delayed_extent_op(trans, root, ref,
+						    extent_op);
+			BUG_ON(ret);
+		}
+
+		btrfs_put_delayed_ref(ref);
+		kfree(extent_op);
 		count++;
+
 		cond_resched();
 		spin_lock(&delayed_refs->lock);
 	}
@@ -1095,20 +1497,44 @@ out:
 	return 0;
 }
 
+int btrfs_set_block_flags(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *root,
+			  u64 bytenr, u64 num_bytes, u64 flags)
+{
+	struct btrfs_delayed_extent_op *extent_op;
+	int ret;
+
+	extent_op = kmalloc(sizeof(*extent_op), GFP_NOFS);
+	if (!extent_op)
+		return -ENOMEM;
+
+	extent_op->flags_to_set = flags;
+	extent_op->update_flags = 1;
+	extent_op->update_key = 0;
+
+	ret = btrfs_add_delayed_extent_op(trans, bytenr, num_bytes, extent_op);
+	if (ret)
+		kfree(extent_op);
+	return ret;
+}
+
 int btrfs_cross_ref_exist(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root, u64 objectid, u64 bytenr)
+			  struct btrfs_root *root,
+			  u64 objectid, u64 offset, u64 bytenr)
 {
 	struct btrfs_root *extent_root = root->fs_info->extent_root;
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
-	struct btrfs_extent_ref *ref_item;
+	struct btrfs_extent_data_ref *ref;
+	struct btrfs_extent_item *ei;
 	struct btrfs_key key;
 	struct btrfs_key found_key;
 	u64 ref_root;
-	u64 last_snapshot;
 	u32 nritems;
 	int ret;
 
+	/* FIXME: check the delayed refs */
+
 	key.objectid = bytenr;
 	key.offset = (u64)-1;
 	key.type = BTRFS_EXTENT_ITEM_KEY;
@@ -1131,7 +1557,13 @@ int btrfs_cross_ref_exist(struct btrfs_t
 	    found_key.type != BTRFS_EXTENT_ITEM_KEY)
 		goto out;
 
-	last_snapshot = btrfs_root_last_snapshot(&root->root_item);
+	ei = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_item);
+	if (btrfs_extent_generation(leaf, ei) <=
+	    btrfs_root_last_snapshot(&root->root_item)) {
+		ret = 1;
+		goto out;
+	}
+
 	while (1) {
 		leaf = path->nodes[0];
 		nritems = btrfs_header_nritems(leaf);
@@ -1147,25 +1579,27 @@ int btrfs_cross_ref_exist(struct btrfs_t
 		if (found_key.objectid != bytenr)
 			break;
 
-		if (found_key.type != BTRFS_EXTENT_REF_KEY) {
+		if (found_key.type != BTRFS_EXTENT_DATA_REF_KEY ||
+		    found_key.type != BTRFS_SHARED_DATA_REF_KEY) {
 			path->slots[0]++;
 			continue;
 		}
 
-		ref_item = btrfs_item_ptr(leaf, path->slots[0],
-					  struct btrfs_extent_ref);
-		ref_root = btrfs_ref_root(leaf, ref_item);
-		if ((ref_root != root->root_key.objectid &&
-		     ref_root != BTRFS_TREE_LOG_OBJECTID) ||
-		     objectid != btrfs_ref_objectid(leaf, ref_item)) {
+		if (found_key.type == BTRFS_SHARED_DATA_REF_KEY) {
 			ret = 1;
 			goto out;
 		}
-		if (btrfs_ref_generation(leaf, ref_item) <= last_snapshot) {
+
+		ref = btrfs_item_ptr(leaf, path->slots[0],
+				     struct btrfs_extent_data_ref);
+		ref_root = btrfs_extent_data_ref_root(leaf, ref);
+		if ((ref_root != root->root_key.objectid &&
+		     ref_root != BTRFS_TREE_LOG_OBJECTID) ||
+		     objectid != btrfs_extent_data_ref_objectid(leaf, ref) ||
+		     offset != btrfs_extent_data_ref_offset(leaf, ref)) {
 			ret = 1;
 			goto out;
 		}
-
 		path->slots[0]++;
 	}
 	ret = 0;
@@ -1174,6 +1608,7 @@ out:
 	return ret;
 }
 
+/*
 int btrfs_cache_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		    struct extent_buffer *buf, u32 nr_extents)
 {
@@ -1236,246 +1671,102 @@ int btrfs_cache_ref(struct btrfs_trans_h
 				btrfs_file_extent_disk_num_bytes(buf, fi);
 			info->objectid = key.objectid;
 			info->offset = key.offset;
-			info++;
-		}
-
-		ret = btrfs_add_leaf_ref(root, ref, shared);
-		if (ret == -EEXIST && shared) {
-			struct btrfs_leaf_ref *old;
-			old = btrfs_lookup_leaf_ref(root, ref->bytenr);
-			BUG_ON(!old);
-			btrfs_remove_leaf_ref(root, old);
-			btrfs_free_leaf_ref(root, old);
-			ret = btrfs_add_leaf_ref(root, ref, shared);
-		}
-		WARN_ON(ret);
-		btrfs_free_leaf_ref(root, ref);
-	}
-out:
-	return ret;
-}
-
-/* when a block goes through cow, we update the reference counts of
- * everything that block points to.  The internal pointers of the block
- * can be in just about any order, and it is likely to have clusters of
- * things that are close together and clusters of things that are not.
- *
- * To help reduce the seeks that come with updating all of these reference
- * counts, sort them by byte number before actual updates are done.
- *
- * struct refsort is used to match byte number to slot in the btree block.
- * we sort based on the byte number and then use the slot to actually
- * find the item.
- *
- * struct refsort is smaller than strcut btrfs_item and smaller than
- * struct btrfs_key_ptr.  Since we're currently limited to the page size
- * for a btree block, there's no way for a kmalloc of refsorts for a
- * single node to be bigger than a page.
- */
-struct refsort {
-	u64 bytenr;
-	u32 slot;
-};
-
-/*
- * for passing into sort()
- */
-static int refsort_cmp(const void *a_void, const void *b_void)
-{
-	const struct refsort *a = a_void;
-	const struct refsort *b = b_void;
-
-	if (a->bytenr < b->bytenr)
-		return -1;
-	if (a->bytenr > b->bytenr)
-		return 1;
-	return 0;
-}
-
-
-noinline int btrfs_inc_ref(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root,
-			   struct extent_buffer *orig_buf,
-			   struct extent_buffer *buf, u32 *nr_extents)
-{
-	u64 bytenr;
-	u64 ref_root;
-	u64 orig_root;
-	u64 ref_generation;
-	u64 orig_generation;
-	struct refsort *sorted;
-	u32 nritems;
-	u32 nr_file_extents = 0;
-	struct btrfs_key key;
-	struct btrfs_file_extent_item *fi;
-	int i;
-	int level;
-	int ret = 0;
-	int faili = 0;
-	int refi = 0;
-	int slot;
-	int (*process_func)(struct btrfs_trans_handle *, struct btrfs_root *,
-			    u64, u64, u64, u64, u64, u64, u64, u64, u64);
-
-	ref_root = btrfs_header_owner(buf);
-	ref_generation = btrfs_header_generation(buf);
-	orig_root = btrfs_header_owner(orig_buf);
-	orig_generation = btrfs_header_generation(orig_buf);
-
-	nritems = btrfs_header_nritems(buf);
-	level = btrfs_header_level(buf);
-
-	sorted = kmalloc(sizeof(struct refsort) * nritems, GFP_NOFS);
-	BUG_ON(!sorted);
-
-	if (root->ref_cows) {
-		process_func = __btrfs_inc_extent_ref;
-	} else {
-		if (level == 0 &&
-		    root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID)
-			goto out;
-		if (level != 0 &&
-		    root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID)
-			goto out;
-		process_func = __btrfs_update_extent_ref;
-	}
-
-	/*
-	 * we make two passes through the items.  In the first pass we
-	 * only record the byte number and slot.  Then we sort based on
-	 * byte number and do the actual work based on the sorted results
-	 */
-	for (i = 0; i < nritems; i++) {
-		cond_resched();
-		if (level == 0) {
-			btrfs_item_key_to_cpu(buf, &key, i);
-			if (btrfs_key_type(&key) != BTRFS_EXTENT_DATA_KEY)
-				continue;
-			fi = btrfs_item_ptr(buf, i,
-					    struct btrfs_file_extent_item);
-			if (btrfs_file_extent_type(buf, fi) ==
-			    BTRFS_FILE_EXTENT_INLINE)
-				continue;
-			bytenr = btrfs_file_extent_disk_bytenr(buf, fi);
-			if (bytenr == 0)
-				continue;
-
-			nr_file_extents++;
-			sorted[refi].bytenr = bytenr;
-			sorted[refi].slot = i;
-			refi++;
-		} else {
-			bytenr = btrfs_node_blockptr(buf, i);
-			sorted[refi].bytenr = bytenr;
-			sorted[refi].slot = i;
-			refi++;
-		}
-	}
-	/*
-	 * if refi == 0, we didn't actually put anything into the sorted
-	 * array and we're done
-	 */
-	if (refi == 0)
-		goto out;
-
-	sort(sorted, refi, sizeof(struct refsort), refsort_cmp, NULL);
-
-	for (i = 0; i < refi; i++) {
-		cond_resched();
-		slot = sorted[i].slot;
-		bytenr = sorted[i].bytenr;
-
-		if (level == 0) {
-			btrfs_item_key_to_cpu(buf, &key, slot);
-			fi = btrfs_item_ptr(buf, slot,
-					    struct btrfs_file_extent_item);
-
-			bytenr = btrfs_file_extent_disk_bytenr(buf, fi);
-			if (bytenr == 0)
-				continue;
-
-			ret = process_func(trans, root, bytenr,
-				   btrfs_file_extent_disk_num_bytes(buf, fi),
-				   orig_buf->start, buf->start,
-				   orig_root, ref_root,
-				   orig_generation, ref_generation,
-				   key.objectid);
-
-			if (ret) {
-				faili = slot;
-				WARN_ON(1);
-				goto fail;
-			}
-		} else {
-			ret = process_func(trans, root, bytenr, buf->len,
-					   orig_buf->start, buf->start,
-					   orig_root, ref_root,
-					   orig_generation, ref_generation,
-					   level - 1);
-			if (ret) {
-				faili = slot;
-				WARN_ON(1);
-				goto fail;
-			}
+			info++;
+		}
+
+		ret = btrfs_add_leaf_ref(root, ref, shared);
+		if (ret == -EEXIST && shared) {
+			struct btrfs_leaf_ref *old;
+			old = btrfs_lookup_leaf_ref(root, ref->bytenr);
+			BUG_ON(!old);
+			btrfs_remove_leaf_ref(root, old);
+			btrfs_free_leaf_ref(root, old);
+			ret = btrfs_add_leaf_ref(root, ref, shared);
 		}
+		WARN_ON(ret);
+		btrfs_free_leaf_ref(root, ref);
 	}
 out:
-	kfree(sorted);
-	if (nr_extents) {
-		if (level == 0)
-			*nr_extents = nr_file_extents;
-		else
-			*nr_extents = nritems;
-	}
-	return 0;
-fail:
-	kfree(sorted);
-	WARN_ON(1);
 	return ret;
 }
+*/
+
+/* when a block goes through cow, we update the reference counts of
+ * everything that block points to.  The internal pointers of the block
+ * can be in just about any order, and it is likely to have clusters of
+ * things that are close together and clusters of things that are not.
+ *
+ * To help reduce the seeks that come with updating all of these reference
+ * counts, sort them by byte number before actual updates are done.
+ *
+ * struct refsort is used to match byte number to slot in the btree block.
+ * we sort based on the byte number and then use the slot to actually
+ * find the item.
+ *
+ * struct refsort is smaller than strcut btrfs_item and smaller than
+ * struct btrfs_key_ptr.  Since we're currently limited to the page size
+ * for a btree block, there's no way for a kmalloc of refsorts for a
+ * single node to be bigger than a page.
+ */
+struct refsort {
+	u64 bytenr;
+	u32 slot;
+};
+
+/*
+ * for passing into sort()
+ */
+static int refsort_cmp(const void *a_void, const void *b_void)
+{
+	const struct refsort *a = a_void;
+	const struct refsort *b = b_void;
 
-int btrfs_update_ref(struct btrfs_trans_handle *trans,
-		     struct btrfs_root *root, struct extent_buffer *orig_buf,
-		     struct extent_buffer *buf, int start_slot, int nr)
+	if (a->bytenr < b->bytenr)
+		return -1;
+	if (a->bytenr > b->bytenr)
+		return 1;
+	return 0;
+}
 
+static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
+			   struct btrfs_root *root,
+			   struct extent_buffer *buf,
+			   int full_backref, int inc)
 {
 	u64 bytenr;
+	u64 num_bytes;
+	u64 parent;
 	u64 ref_root;
-	u64 orig_root;
-	u64 ref_generation;
-	u64 orig_generation;
+	u32 nritems;
 	struct btrfs_key key;
 	struct btrfs_file_extent_item *fi;
 	int i;
-	int ret;
-	int slot;
 	int level;
+	int ret = 0;
+	int (*process_func)(struct btrfs_trans_handle *, struct btrfs_root *,
+			    u64, u64, u64, u64, u64, u64);
+	if (inc)
+		process_func = btrfs_inc_extent_ref;
+	else
+		process_func = btrfs_free_extent;
 
-	BUG_ON(start_slot < 0);
-	BUG_ON(start_slot + nr > btrfs_header_nritems(buf));
+	BUG_ON(!root->ref_cows);
 
 	ref_root = btrfs_header_owner(buf);
-	ref_generation = btrfs_header_generation(buf);
-	orig_root = btrfs_header_owner(orig_buf);
-	orig_generation = btrfs_header_generation(orig_buf);
+	nritems = btrfs_header_nritems(buf);
 	level = btrfs_header_level(buf);
 
-	if (!root->ref_cows) {
-		if (level == 0 &&
-		    root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID)
-			return 0;
-		if (level != 0 &&
-		    root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID)
-			return 0;
-	}
+	if (full_backref)
+		parent = buf->start;
+	else
+		parent = 0;
 
-	for (i = 0, slot = start_slot; i < nr; i++, slot++) {
-		cond_resched();
+	for (i = 0; i < nritems; i++) {
 		if (level == 0) {
-			btrfs_item_key_to_cpu(buf, &key, slot);
+			btrfs_item_key_to_cpu(buf, &key, i);
 			if (btrfs_key_type(&key) != BTRFS_EXTENT_DATA_KEY)
 				continue;
-			fi = btrfs_item_ptr(buf, slot,
+			fi = btrfs_item_ptr(buf, i,
 					    struct btrfs_file_extent_item);
 			if (btrfs_file_extent_type(buf, fi) ==
 			    BTRFS_FILE_EXTENT_INLINE)
@@ -1483,28 +1774,39 @@ int btrfs_update_ref(struct btrfs_trans_
 			bytenr = btrfs_file_extent_disk_bytenr(buf, fi);
 			if (bytenr == 0)
 				continue;
-			ret = __btrfs_update_extent_ref(trans, root, bytenr,
-				    btrfs_file_extent_disk_num_bytes(buf, fi),
-				    orig_buf->start, buf->start,
-				    orig_root, ref_root, orig_generation,
-				    ref_generation, key.objectid);
+
+			num_bytes = btrfs_file_extent_disk_num_bytes(buf, fi);
+			key.offset -= btrfs_file_extent_offset(buf, fi);
+			ret = process_func(trans, root, bytenr, num_bytes,
+					   parent, ref_root, key.objectid,
+					   key.offset);
 			if (ret)
 				goto fail;
 		} else {
-			bytenr = btrfs_node_blockptr(buf, slot);
-			ret = __btrfs_update_extent_ref(trans, root, bytenr,
-					    buf->len, orig_buf->start,
-					    buf->start, orig_root, ref_root,
-					    orig_generation, ref_generation,
-					    level - 1);
+			bytenr = btrfs_node_blockptr(buf, i);
+			num_bytes = btrfs_level_size(root, level - 1);
+			ret = process_func(trans, root, bytenr, num_bytes,
+					   parent, ref_root, level - 1, 0);
 			if (ret)
 				goto fail;
 		}
 	}
 	return 0;
 fail:
-	WARN_ON(1);
-	return -1;
+	BUG();
+	return ret;
+}
+
+int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		  struct extent_buffer *buf, int full_backref)
+{
+	return __btrfs_mod_ref(trans, root, buf, full_backref, 1);
+}
+
+int btrfs_dec_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		  struct extent_buffer *buf, int full_backref)
+{
+	return __btrfs_mod_ref(trans, root, buf, full_backref, 0);
 }
 
 static int write_one_cache_group(struct btrfs_trans_handle *trans,
@@ -2007,6 +2309,24 @@ static int update_block_group(struct btr
 	u64 old_val;
 	u64 byte_in_group;
 
+	/* block accounting for super block */
+	spin_lock(&info->delalloc_lock);
+	old_val = btrfs_super_bytes_used(&info->super_copy);
+	if (alloc)
+		old_val += num_bytes;
+	else
+		old_val -= num_bytes;
+	btrfs_set_super_bytes_used(&info->super_copy, old_val);
+
+	/* block accounting for root item */
+	old_val = btrfs_root_used(&root->root_item);
+	if (alloc)
+		old_val += num_bytes;
+	else
+		old_val -= num_bytes;
+	btrfs_set_root_used(&root->root_item, old_val);
+	spin_unlock(&info->delalloc_lock);
+
 	while (total) {
 		cache = btrfs_lookup_block_group(info, bytenr);
 		if (!cache)
@@ -2235,51 +2555,51 @@ pinit:
 	return 0;
 }
 
-/*
- * remove an extent from the root, returns 0 on success
- */
-static int __free_extent(struct btrfs_trans_handle *trans,
-			 struct btrfs_root *root,
-			 u64 bytenr, u64 num_bytes, u64 parent,
-			 u64 root_objectid, u64 ref_generation,
-			 u64 owner_objectid, int pin, int mark_free,
-			 int refs_to_drop)
+
+static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root,
+				u64 bytenr, u64 num_bytes, u64 parent,
+				u64 root_objectid, u64 owner_objectid,
+				u64 owner_offset, int refs_to_drop,
+				struct btrfs_delayed_extent_op *extra_op)
 {
-	struct btrfs_path *path;
 	struct btrfs_key key;
+	struct btrfs_path *path;
 	struct btrfs_fs_info *info = root->fs_info;
 	struct btrfs_root *extent_root = info->extent_root;
 	struct extent_buffer *leaf;
+	struct btrfs_extent_item *ei;
 	int ret;
+	int is_data;
 	int extent_slot = 0;
 	int found_extent = 0;
 	int num_to_del = 1;
-	struct btrfs_extent_item *ei;
-	u32 refs;
+	u64 refs;
+
 
-	key.objectid = bytenr;
-	btrfs_set_key_type(&key, BTRFS_EXTENT_ITEM_KEY);
-	key.offset = num_bytes;
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
 
 	path->reada = 1;
 	path->leave_spinning = 1;
+
+	is_data = owner_objectid >= BTRFS_FIRST_FREE_OBJECTID;
+	BUG_ON(!is_data && refs_to_drop != 1);
+
 	ret = lookup_extent_backref(trans, extent_root, path,
 				    bytenr, parent, root_objectid,
-				    ref_generation, owner_objectid, 1);
+				    owner_objectid, owner_offset);
 	if (ret == 0) {
-		struct btrfs_key found_key;
 		extent_slot = path->slots[0];
 		while (extent_slot > 0) {
 			extent_slot--;
-			btrfs_item_key_to_cpu(path->nodes[0], &found_key,
+			btrfs_item_key_to_cpu(path->nodes[0], &key,
 					      extent_slot);
-			if (found_key.objectid != bytenr)
+			if (key.objectid != bytenr)
 				break;
-			if (found_key.type == BTRFS_EXTENT_ITEM_KEY &&
-			    found_key.offset == num_bytes) {
+			if (key.type == BTRFS_EXTENT_ITEM_KEY &&
+			    key.offset == num_bytes) {
 				found_extent = 1;
 				break;
 			}
@@ -2288,10 +2608,15 @@ static int __free_extent(struct btrfs_tr
 		}
 		if (!found_extent) {
 			ret = remove_extent_backref(trans, extent_root, path,
-						    refs_to_drop);
+						    refs_to_drop, is_data);
 			BUG_ON(ret);
 			btrfs_release_path(extent_root, path);
 			path->leave_spinning = 1;
+
+			key.objectid = bytenr;
+			key.type = BTRFS_EXTENT_ITEM_KEY;
+			key.offset = num_bytes;
+
 			ret = btrfs_search_slot(trans, extent_root,
 						&key, path, -1, 1);
 			if (ret) {
@@ -2307,18 +2632,23 @@ static int __free_extent(struct btrfs_tr
 		btrfs_print_leaf(extent_root, path->nodes[0]);
 		WARN_ON(1);
 		printk(KERN_ERR "btrfs unable to find ref byte nr %llu "
-		       "parent %llu root %llu gen %llu owner %llu\n",
+		       "parent %llu root %llu  owner %llu offset %llu\n",
 		       (unsigned long long)bytenr,
 		       (unsigned long long)parent,
 		       (unsigned long long)root_objectid,
-		       (unsigned long long)ref_generation,
-		       (unsigned long long)owner_objectid);
+		       (unsigned long long)owner_objectid,
+		       (unsigned long long)owner_offset);
 	}
 
 	leaf = path->nodes[0];
 	ei = btrfs_item_ptr(leaf, extent_slot,
 			    struct btrfs_extent_item);
 	refs = btrfs_extent_refs(leaf, ei);
+	if (extra_op && extra_op->update_flags) {
+		extra_op->update_flags = 0;
+		extra_op->flags_to_set |= btrfs_extent_flags(leaf, ei);
+		btrfs_set_extent_flags(leaf, ei, extra_op->flags_to_set);
+	}
 
 	/*
 	 * we're not allowed to delete the extent item if there
@@ -2330,59 +2660,44 @@ static int __free_extent(struct btrfs_tr
 	btrfs_set_extent_refs(leaf, ei, refs);
 	btrfs_mark_buffer_dirty(leaf);
 
-	if (refs == 0 && found_extent &&
-	    path->slots[0] == extent_slot + 1) {
-		struct btrfs_extent_ref *ref;
-		ref = btrfs_item_ptr(leaf, path->slots[0],
-				     struct btrfs_extent_ref);
-		BUG_ON(btrfs_ref_num_refs(leaf, ref) != refs_to_drop);
-		/* if the back ref and the extent are next to each other
-		 * they get deleted below in one shot
-		 */
-		path->slots[0] = extent_slot;
-		num_to_del = 2;
-	} else if (found_extent) {
-		/* otherwise delete the extent back ref */
-		ret = remove_extent_backref(trans, extent_root, path,
-					    refs_to_drop);
-		BUG_ON(ret);
-		/* if refs are 0, we need to setup the path for deletion */
+	if (found_extent) {
 		if (refs == 0) {
-			btrfs_release_path(extent_root, path);
-			path->leave_spinning = 1;
-			ret = btrfs_search_slot(trans, extent_root, &key, path,
-						-1, 1);
+			if (is_data) {
+				BUG_ON(refs_to_drop !=
+				       extent_data_ref_count(root, path));
+				num_to_del = 2;
+			} else {
+				BUG_ON(path->slots[0] != extent_slot + 2);
+				btrfs_item_key_to_cpu(leaf, &key,
+						      extent_slot + 1);
+				BUG_ON(key.type != BTRFS_TREE_BLOCK_INFO_KEY);
+				num_to_del = 3;
+			}
+			path->slots[0] = extent_slot;
+		} else {
+			ret = remove_extent_backref(trans, extent_root, path,
+						    refs_to_drop, is_data);
 			BUG_ON(ret);
 		}
+	} else {
+		if (refs == 0 && !is_data &&
+		    path->slots[0] < btrfs_header_nritems(leaf) - 1) {
+			btrfs_item_key_to_cpu(leaf, &key, path->slots[0] + 1);
+			BUG_ON(key.objectid != bytenr ||
+			       key.type != BTRFS_TREE_BLOCK_INFO_KEY);
+			num_to_del = 2;
+		}
 	}
 
 	if (refs == 0) {
-		u64 super_used;
-		u64 root_used;
+		int mark_free = 0;
 		struct extent_buffer *must_clean = NULL;
 
-		if (pin) {
-			ret = pin_down_bytes(trans, root, path,
-				bytenr, num_bytes,
-				owner_objectid >= BTRFS_FIRST_FREE_OBJECTID,
-				&must_clean);
-			if (ret > 0)
-				mark_free = 1;
-			BUG_ON(ret < 0);
-		}
-
-		/* block accounting for super block */
-		spin_lock(&info->delalloc_lock);
-		super_used = btrfs_super_bytes_used(&info->super_copy);
-		btrfs_set_super_bytes_used(&info->super_copy,
-					   super_used - num_bytes);
-
-		/* block accounting for root item */
-		root_used = btrfs_root_used(&root->root_item);
-		btrfs_set_root_used(&root->root_item,
-					   root_used - num_bytes);
-		spin_unlock(&info->delalloc_lock);
-
+		ret = pin_down_bytes(trans, root, path, bytenr,
+				     num_bytes, is_data, &must_clean);
+		if (ret > 0)
+			mark_free = 1;
+		BUG_ON(ret < 0);
 		/*
 		 * it is going to be very rare for someone to be waiting
 		 * on the block we're freeing.  del_items might need to
@@ -2403,10 +2718,15 @@ static int __free_extent(struct btrfs_tr
 			free_extent_buffer(must_clean);
 		}
 
-		if (owner_objectid >= BTRFS_FIRST_FREE_OBJECTID) {
+		if (is_data) {
 			ret = btrfs_del_csums(trans, root, bytenr, num_bytes);
 			BUG_ON(ret);
 		} else {
+			if (num_to_del == 1) {
+				ret = remove_tree_block_info(trans, extent_root,
+							     path, bytenr);
+				BUG_ON(ret);
+			}
 			invalidate_mapping_pages(info->btree_inode->i_mapping,
 			     bytenr >> PAGE_CACHE_SHIFT,
 			     (bytenr + num_bytes - 1) >> PAGE_CACHE_SHIFT);
@@ -2420,33 +2740,6 @@ static int __free_extent(struct btrfs_tr
 	return ret;
 }
 
-/*
- * remove an extent from the root, returns 0 on success
- */
-static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
-					struct btrfs_root *root,
-					u64 bytenr, u64 num_bytes, u64 parent,
-					u64 root_objectid, u64 ref_generation,
-					u64 owner_objectid, int pin,
-					int refs_to_drop)
-{
-	WARN_ON(num_bytes < root->sectorsize);
-
-	/*
-	 * if metadata always pin
-	 * if data pin when any transaction has committed this
-	 */
-	if (owner_objectid < BTRFS_FIRST_FREE_OBJECTID ||
-	    ref_generation != trans->transid)
-		pin = 1;
-
-	if (ref_generation != trans->transid)
-		pin = 1;
-
-	return __free_extent(trans, root, bytenr, num_bytes, parent,
-			    root_objectid, ref_generation,
-			    owner_objectid, pin, pin == 0, refs_to_drop);
-}
 
 /*
  * when we free an extent, it is possible (and likely) that we free the last
@@ -2479,6 +2772,13 @@ static noinline int check_ref_cleanup(st
 	if (ref->bytenr == bytenr)
 		goto out;
 
+	if (head->extent_op) {
+		if (!head->must_insert_reserved)
+			goto out;
+		kfree(head->extent_op);
+		head->extent_op = NULL;
+	}
+
 	/*
 	 * waiting for the lock here would deadlock.  If someone else has it
 	 * locked they are already in the process of dropping it anyway
@@ -2507,7 +2807,8 @@ static noinline int check_ref_cleanup(st
 	spin_unlock(&delayed_refs->lock);
 
 	ret = run_one_delayed_ref(trans, root->fs_info->tree_root,
-				  &head->node, head->must_insert_reserved);
+				  &head->node, head->extent_op,
+				  head->must_insert_reserved);
 	BUG_ON(ret);
 	btrfs_put_delayed_ref(&head->node);
 	return 0;
@@ -2519,8 +2820,7 @@ out:
 int btrfs_free_extent(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root,
 		      u64 bytenr, u64 num_bytes, u64 parent,
-		      u64 root_objectid, u64 ref_generation,
-		      u64 owner_objectid, int pin)
+		      u64 root_objectid, u64 owner, u64 offset)
 {
 	int ret;
 
@@ -2531,20 +2831,24 @@ int btrfs_free_extent(struct btrfs_trans
 	 * data extents referenced by the tree log do need to have
 	 * their reference counts bumped.
 	 */
-	if (root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID &&
-	    owner_objectid < BTRFS_FIRST_FREE_OBJECTID) {
+	if (root_objectid == BTRFS_TREE_LOG_OBJECTID &&
+	    owner < BTRFS_FIRST_FREE_OBJECTID) {
 		/* unlocks the pinned mutex */
 		btrfs_update_pinned_extents(root, bytenr, num_bytes, 1);
 		update_reserved_extents(root, bytenr, num_bytes, 0);
 		ret = 0;
-	} else {
-		ret = btrfs_add_delayed_ref(trans, bytenr, num_bytes, parent,
-				       root_objectid, ref_generation,
-				       owner_objectid,
-				       BTRFS_DROP_DELAYED_REF, 1);
+	} else if (owner < BTRFS_FIRST_FREE_OBJECTID) {
+		ret = btrfs_add_delayed_tree_ref(trans, bytenr, num_bytes,
+					parent, root_objectid, (int)owner,
+					BTRFS_DROP_DELAYED_REF, NULL);
 		BUG_ON(ret);
 		ret = check_ref_cleanup(trans, root, bytenr);
 		BUG_ON(ret);
+	} else {
+		ret = btrfs_add_delayed_data_ref(trans, bytenr, num_bytes,
+					parent, root_objectid, owner,
+					offset, BTRFS_DROP_DELAYED_REF, NULL);
+		BUG_ON(ret);
 	}
 	return ret;
 }
@@ -2944,74 +3248,140 @@ int btrfs_reserve_extent(struct btrfs_tr
 	return ret;
 }
 
-static int __btrfs_alloc_reserved_extent(struct btrfs_trans_handle *trans,
-					 struct btrfs_root *root, u64 parent,
-					 u64 root_objectid, u64 ref_generation,
-					 u64 owner, struct btrfs_key *ins,
-					 int ref_mod)
+static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
+				      struct btrfs_root *root, u64 parent,
+				      u64 root_objectid, u64 generation,
+				      u64 owner, u64 offset,
+				      struct btrfs_key *ins, int ref_mod)
 {
 	int ret;
-	u64 super_used;
-	u64 root_used;
-	u64 num_bytes = ins->offset;
 	u32 sizes[2];
-	struct btrfs_fs_info *info = root->fs_info;
-	struct btrfs_root *extent_root = info->extent_root;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_extent_item *extent_item;
-	struct btrfs_extent_ref *ref;
 	struct btrfs_path *path;
 	struct btrfs_key keys[2];
 
-	if (parent == 0)
-		parent = ins->objectid;
+	memcpy(&keys[0], ins, sizeof(*ins));
+	keys[1].objectid = ins->objectid;
+	sizes[0] = sizeof(*extent_item);
+	if (parent) {
+		keys[1].type = BTRFS_EXTENT_DATA_REF_KEY;
+		keys[1].offset = parent;
+		sizes[1] = sizeof(struct btrfs_shared_data_ref);
+	} else {
+		keys[1].type = BTRFS_EXTENT_DATA_REF_KEY;
+		keys[1].offset = hash_extent_data_ref(root_objectid,
+						      owner, offset);
+		sizes[1] = sizeof(struct btrfs_extent_data_ref);
+	}
 
-	/* block accounting for super block */
-	spin_lock(&info->delalloc_lock);
-	super_used = btrfs_super_bytes_used(&info->super_copy);
-	btrfs_set_super_bytes_used(&info->super_copy, super_used + num_bytes);
+	path = btrfs_alloc_path();
+	BUG_ON(!path);
 
-	/* block accounting for root item */
-	root_used = btrfs_root_used(&root->root_item);
-	btrfs_set_root_used(&root->root_item, root_used + num_bytes);
-	spin_unlock(&info->delalloc_lock);
+	path->leave_spinning = 1;
+	ret = btrfs_insert_empty_items(trans, fs_info->extent_root, path,
+					keys, sizes, 2);
+	BUG_ON(ret);
+
+	extent_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
+				     struct btrfs_extent_item);
+	btrfs_set_extent_refs(path->nodes[0], extent_item, ref_mod);
+	btrfs_set_extent_generation(path->nodes[0], extent_item, generation);
+	btrfs_set_extent_flags(path->nodes[0], extent_item,
+			       BTRFS_EXTENT_FLAG_DATA);
+
+	if (parent) {
+		struct btrfs_shared_data_ref *ref;
+		ref = btrfs_item_ptr(path->nodes[0], path->slots[0] + 1,
+				     struct btrfs_shared_data_ref);
+		btrfs_set_shared_data_ref_count(path->nodes[0], ref, ref_mod);
+	} else {
+		struct btrfs_extent_data_ref *ref;
+		ref = btrfs_item_ptr(path->nodes[0], path->slots[0] + 1,
+				     struct btrfs_extent_data_ref);
+		btrfs_set_extent_data_ref_root(path->nodes[0], ref,
+					       root_objectid);
+		btrfs_set_extent_data_ref_objectid(path->nodes[0], ref, owner);
+		btrfs_set_extent_data_ref_offset(path->nodes[0], ref, offset);
+		btrfs_set_extent_data_ref_count(path->nodes[0], ref, ref_mod);
+	}
+
+	btrfs_mark_buffer_dirty(path->nodes[0]);
+	btrfs_free_path(path);
+
+	if (ret)
+		goto out;
+
+	ret = update_block_group(trans, root, ins->objectid, ins->offset,
+				 1, 0);
+	if (ret) {
+		printk(KERN_ERR "btrfs update block group failed for %llu "
+		       "%llu\n", (unsigned long long)ins->objectid,
+		       (unsigned long long)ins->offset);
+		BUG();
+	}
+out:
+	return ret;
+}
+
+static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
+				     struct btrfs_root *root, u64 parent,
+				     u64 root_objectid, u64 generation,
+				     u64 flags, struct btrfs_disk_key *key,
+				     int level, struct btrfs_key *ins)
+{
+	int ret;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_extent_item *extent_item;
+	struct btrfs_tree_block_info *block_info;
+	struct btrfs_path *path;
+	struct btrfs_key keys[3];
+	u32 sizes[3];
 
 	memcpy(&keys[0], ins, sizeof(*ins));
 	keys[1].objectid = ins->objectid;
-	keys[1].type = BTRFS_EXTENT_REF_KEY;
-	keys[1].offset = parent;
+	keys[1].type = BTRFS_TREE_BLOCK_INFO_KEY;
+	keys[1].offset = 0;
+	keys[2].objectid = ins->objectid;
+	if (parent) {
+		keys[2].type = BTRFS_SHARED_BLOCK_REF_KEY;
+		keys[2].offset = parent;
+	} else {
+		keys[2].type = BTRFS_TREE_BLOCK_REF_KEY;
+		keys[2].offset = root_objectid;
+	}
 	sizes[0] = sizeof(*extent_item);
-	sizes[1] = sizeof(*ref);
+	sizes[1] = sizeof(*block_info);
+	sizes[2] = 0;
 
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
 
 	path->leave_spinning = 1;
-	ret = btrfs_insert_empty_items(trans, extent_root, path, keys,
-				       sizes, 2);
+	ret = btrfs_insert_empty_items(trans, fs_info->extent_root, path,
+					keys, sizes, 3);
 	BUG_ON(ret);
 
 	extent_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
 				     struct btrfs_extent_item);
-	btrfs_set_extent_refs(path->nodes[0], extent_item, ref_mod);
-	ref = btrfs_item_ptr(path->nodes[0], path->slots[0] + 1,
-			     struct btrfs_extent_ref);
+	btrfs_set_extent_refs(path->nodes[0], extent_item, 1);
+	btrfs_set_extent_generation(path->nodes[0], extent_item, generation);
+	btrfs_set_extent_flags(path->nodes[0], extent_item,
+			       flags | BTRFS_EXTENT_FLAG_TREE_BLOCK);
+	block_info = btrfs_item_ptr(path->nodes[0], path->slots[0] + 1,
+				    struct btrfs_tree_block_info);
 
-	btrfs_set_ref_root(path->nodes[0], ref, root_objectid);
-	btrfs_set_ref_generation(path->nodes[0], ref, ref_generation);
-	btrfs_set_ref_objectid(path->nodes[0], ref, owner);
-	btrfs_set_ref_num_refs(path->nodes[0], ref, ref_mod);
+	btrfs_set_tree_block_key(path->nodes[0], block_info, key);
+	btrfs_set_tree_block_level(path->nodes[0], block_info, level);
 
 	btrfs_mark_buffer_dirty(path->nodes[0]);
-
-	trans->alloc_exclude_start = 0;
-	trans->alloc_exclude_nr = 0;
 	btrfs_free_path(path);
 
 	if (ret)
 		goto out;
 
-	ret = update_block_group(trans, root, ins->objectid,
-				 ins->offset, 1, 0);
+	ret = update_block_group(trans, root, ins->objectid, ins->offset,
+				 1, 0);
 	if (ret) {
 		printk(KERN_ERR "btrfs update block group failed for %llu "
 		       "%llu\n", (unsigned long long)ins->objectid,
@@ -3022,21 +3392,18 @@ out:
 	return ret;
 }
 
-int btrfs_alloc_reserved_extent(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root, u64 parent,
-				u64 root_objectid, u64 ref_generation,
-				u64 owner, struct btrfs_key *ins)
+int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
+				     struct btrfs_root *root,
+				     u64 root_objectid, u64 owner,
+				     u64 offset, struct btrfs_key *ins)
 {
 	int ret;
 
-	if (root_objectid == BTRFS_TREE_LOG_OBJECTID)
-		return 0;
+	BUG_ON(root_objectid == BTRFS_TREE_LOG_OBJECTID);
 
-	ret = btrfs_add_delayed_ref(trans, ins->objectid,
-				    ins->offset, parent, root_objectid,
-				    ref_generation, owner,
-				    BTRFS_ADD_DELAYED_EXTENT, 0);
-	BUG_ON(ret);
+	ret = btrfs_add_delayed_data_ref(trans, ins->objectid, ins->offset,
+					 0, root_objectid, owner, offset,
+					 BTRFS_ADD_DELAYED_EXTENT, NULL);
 	return ret;
 }
 
@@ -3045,10 +3412,10 @@ int btrfs_alloc_reserved_extent(struct b
  * an extent has been allocated and makes sure to clear the free
  * space cache bits as well
  */
-int btrfs_alloc_logged_extent(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root, u64 parent,
-				u64 root_objectid, u64 ref_generation,
-				u64 owner, struct btrfs_key *ins)
+int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
+				   struct btrfs_root *root,
+				   u64 root_objectid, u64 owner, u64 offset,
+				   struct btrfs_key *ins)
 {
 	int ret;
 	struct btrfs_block_group_cache *block_group;
@@ -3062,8 +3429,9 @@ int btrfs_alloc_logged_extent(struct btr
 				      ins->offset);
 	BUG_ON(ret);
 	btrfs_put_block_group(block_group);
-	ret = __btrfs_alloc_reserved_extent(trans, root, parent, root_objectid,
-					    ref_generation, owner, ins, 1);
+	ret = alloc_reserved_file_extent(trans, root, 0, root_objectid,
+					 trans->transid, owner, offset,
+					 ins, 1);
 	return ret;
 }
 
@@ -3074,26 +3442,47 @@ int btrfs_alloc_logged_extent(struct btr
  *
  * returns 0 if everything worked, non-zero otherwise.
  */
-int btrfs_alloc_extent(struct btrfs_trans_handle *trans,
-		       struct btrfs_root *root,
-		       u64 num_bytes, u64 parent, u64 min_alloc_size,
-		       u64 root_objectid, u64 ref_generation,
-		       u64 owner_objectid, u64 empty_size, u64 hint_byte,
-		       u64 search_end, struct btrfs_key *ins, u64 data)
+static int alloc_tree_block(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root,
+			    u64 num_bytes, u64 parent, u64 root_objectid,
+			    struct btrfs_disk_key *key, int level,
+			    u64 empty_size, u64 hint_byte, u64 search_end,
+			    struct btrfs_key *ins)
 {
 	int ret;
-	ret = __btrfs_reserve_extent(trans, root, num_bytes,
-				     min_alloc_size, empty_size, hint_byte,
-				     search_end, ins, data);
+	u64 flags = 0;
+
+	ret = __btrfs_reserve_extent(trans, root, num_bytes, num_bytes,
+				     empty_size, hint_byte, search_end,
+				     ins, 0);
 	BUG_ON(ret);
+
+	if (root_objectid == BTRFS_TREE_RELOC_OBJECTID) {
+		if (parent == 0)
+			parent = ins->objectid;
+		flags |= BTRFS_BLOCK_FULL_BACKREF;
+	} else
+		BUG_ON(parent > 0);
+
+	update_reserved_extents(root, ins->objectid, ins->offset, 1);
 	if (root_objectid != BTRFS_TREE_LOG_OBJECTID) {
-		ret = btrfs_add_delayed_ref(trans, ins->objectid,
-					    ins->offset, parent, root_objectid,
-					    ref_generation, owner_objectid,
-					    BTRFS_ADD_DELAYED_EXTENT, 0);
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
+
+		ret = btrfs_add_delayed_tree_ref(trans, ins->objectid,
+					ins->offset, parent, root_objectid,
+					level, BTRFS_ADD_DELAYED_EXTENT,
+					extent_op);
 		BUG_ON(ret);
 	}
-	update_reserved_extents(root, ins->objectid, ins->offset, 1);
 	return ret;
 }
 
@@ -3132,21 +3521,17 @@ struct extent_buffer *btrfs_init_new_buf
  * returns the tree buffer or NULL.
  */
 struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
-					     struct btrfs_root *root,
-					     u32 blocksize, u64 parent,
-					     u64 root_objectid,
-					     u64 ref_generation,
-					     int level,
-					     u64 hint,
-					     u64 empty_size)
+					struct btrfs_root *root, u32 blocksize,
+					u64 parent, u64 root_objectid,
+					struct btrfs_disk_key *key, int level,
+					u64 hint, u64 empty_size)
 {
 	struct btrfs_key ins;
 	int ret;
 	struct extent_buffer *buf;
 
-	ret = btrfs_alloc_extent(trans, root, blocksize, parent, blocksize,
-				 root_objectid, ref_generation, level,
-				 empty_size, hint, (u64)-1, &ins, 0);
+	ret = alloc_tree_block(trans, root, blocksize, parent, root_objectid,
+			       key, level, empty_size, hint, (u64)-1, &ins);
 	if (ret) {
 		BUG_ON(ret > 0);
 		return ERR_PTR(ret);
@@ -3161,7 +3546,8 @@ int btrfs_drop_leaf_ref(struct btrfs_tra
 			struct btrfs_root *root, struct extent_buffer *leaf)
 {
 	u64 leaf_owner;
-	u64 leaf_generation;
+	u64 disk_bytenr;
+	u64 leaf_start;
 	struct refsort *sorted;
 	struct btrfs_key key;
 	struct btrfs_file_extent_item *fi;
@@ -3174,7 +3560,6 @@ int btrfs_drop_leaf_ref(struct btrfs_tra
 	BUG_ON(!btrfs_is_leaf(leaf));
 	nritems = btrfs_header_nritems(leaf);
 	leaf_owner = btrfs_header_owner(leaf);
-	leaf_generation = btrfs_header_generation(leaf);
 
 	sorted = kmalloc(sizeof(*sorted) * nritems, GFP_NOFS);
 	/* we do this loop twice.  The first time we build a list
@@ -3183,7 +3568,6 @@ int btrfs_drop_leaf_ref(struct btrfs_tra
 	 * extent freeing.
 	 */
 	for (i = 0; i < nritems; i++) {
-		u64 disk_bytenr;
 		cond_resched();
 
 		btrfs_item_key_to_cpu(leaf, &key, i);
@@ -3215,8 +3599,13 @@ int btrfs_drop_leaf_ref(struct btrfs_tra
 
 	sort(sorted, refi, sizeof(struct refsort), refsort_cmp, NULL);
 
+	if (leaf_owner == root->root_key.objectid)
+		leaf_start = 0;
+	else
+		leaf_start = leaf->start;
+
 	for (i = 0; i < refi; i++) {
-		u64 disk_bytenr;
+		u64 num_bytes;
 
 		disk_bytenr = sorted[i].bytenr;
 		slot = sorted[i].slot;
@@ -3229,10 +3618,11 @@ int btrfs_drop_leaf_ref(struct btrfs_tra
 
 		fi = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
 
-		ret = btrfs_free_extent(trans, root, disk_bytenr,
-				btrfs_file_extent_disk_num_bytes(leaf, fi),
-				leaf->start, leaf_owner, leaf_generation,
-				key.objectid, 0);
+		num_bytes = btrfs_file_extent_disk_num_bytes(leaf, fi);
+		key.offset -= btrfs_file_extent_offset(leaf, fi);
+		ret = btrfs_free_extent(trans, root, disk_bytenr, num_bytes,
+					leaf_start, leaf_owner, key.objectid,
+					key.offset);
 		BUG_ON(ret);
 
 		atomic_inc(&root->fs_info->throttle_gen);
@@ -3244,6 +3634,8 @@ out:
 	return 0;
 }
 
+#if 0
+
 static noinline int cache_drop_leaf_ref(struct btrfs_trans_handle *trans,
 					struct btrfs_root *root,
 					struct btrfs_leaf_ref *ref)
@@ -3286,13 +3678,14 @@ static noinline int cache_drop_leaf_ref(
 	return 0;
 }
 
+
 static int drop_snap_lookup_refcount(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *root, u64 start,
 				     u64 len, u32 *refs)
 {
 	int ret;
 
-	ret = btrfs_lookup_extent_ref(trans, root, start, len, refs);
+	ret = btrfs_lookup_extent_refs(trans, root, start, len, refs);
 	BUG_ON(ret);
 
 #if 0 /* some debugging code in case we see problems here */
@@ -3327,6 +3720,7 @@ static int drop_snap_lookup_refcount(str
 	return ret;
 }
 
+
 /*
  * this is used while deleting old snapshots, and it drops the refs
  * on a whole subtree starting from a level 1 node.
@@ -3620,32 +4014,36 @@ out:
 	cond_resched();
 	return 0;
 }
+#endif
 
 /*
  * helper function for drop_subtree, this function is similar to
  * walk_down_tree. The main difference is that it checks reference
  * counts while tree blocks are locked.
  */
-static noinline int walk_down_subtree(struct btrfs_trans_handle *trans,
-				      struct btrfs_root *root,
-				      struct btrfs_path *path, int *level)
+static noinline int walk_down_tree(struct btrfs_trans_handle *trans,
+				   struct btrfs_root *root,
+				   struct btrfs_path *path, int *level)
 {
 	struct extent_buffer *next;
 	struct extent_buffer *cur;
 	struct extent_buffer *parent;
 	u64 bytenr;
 	u64 ptr_gen;
+	u64 refs;
+	u64 flags;
 	u32 blocksize;
-	u32 refs;
 	int ret;
 
 	cur = path->nodes[*level];
-	ret = btrfs_lookup_extent_ref(trans, root, cur->start, cur->len,
-				      &refs);
+	ret = btrfs_lookup_extent_info(trans, root, cur->start, cur->len,
+				       &refs, &flags);
 	BUG_ON(ret);
 	if (refs > 1)
 		goto out;
 
+	BUG_ON(!(flags & BTRFS_BLOCK_FULL_BACKREF));
+
 	while (*level >= 0) {
 		cur = path->nodes[*level];
 		if (*level == 0) {
@@ -3667,16 +4065,15 @@ static noinline int walk_down_subtree(st
 		btrfs_tree_lock(next);
 		btrfs_set_lock_blocking(next);
 
-		ret = btrfs_lookup_extent_ref(trans, root, bytenr, blocksize,
-					      &refs);
+		ret = btrfs_lookup_extent_info(trans, root, bytenr, blocksize,
+					       &refs, &flags);
 		BUG_ON(ret);
 		if (refs > 1) {
 			parent = path->nodes[*level];
 			ret = btrfs_free_extent(trans, root, bytenr,
-					blocksize, parent->start,
-					btrfs_header_owner(parent),
-					btrfs_header_generation(parent),
-					*level - 1, 1);
+						blocksize, parent->start,
+						btrfs_header_owner(parent),
+						*level - 1, 0);
 			BUG_ON(ret);
 			path->slots[*level]++;
 			btrfs_tree_unlock(next);
@@ -3684,6 +4081,8 @@ static noinline int walk_down_subtree(st
 			continue;
 		}
 
+		BUG_ON(!(flags & BTRFS_BLOCK_FULL_BACKREF));
+
 		*level = btrfs_header_level(next);
 		path->nodes[*level] = next;
 		path->slots[*level] = 0;
@@ -3691,13 +4090,15 @@ static noinline int walk_down_subtree(st
 		cond_resched();
 	}
 out:
-	parent = path->nodes[*level + 1];
+	if (path->nodes[*level] == root->node)
+		parent = path->nodes[*level];
+	else
+		parent = path->nodes[*level + 1];
 	bytenr = path->nodes[*level]->start;
 	blocksize = path->nodes[*level]->len;
 
-	ret = btrfs_free_extent(trans, root, bytenr, blocksize,
-			parent->start, btrfs_header_owner(parent),
-			btrfs_header_generation(parent), *level, 1);
+	ret = btrfs_free_extent(trans, root, bytenr, blocksize, parent->start,
+				btrfs_header_owner(parent), *level, 0);
 	BUG_ON(ret);
 
 	if (path->locks[*level]) {
@@ -3721,8 +4122,6 @@ static noinline int walk_up_tree(struct 
 				 struct btrfs_path *path,
 				 int *level, int max_level)
 {
-	u64 root_owner;
-	u64 root_gen;
 	struct btrfs_root_item *root_item = &root->root_item;
 	int i;
 	int slot;
@@ -3731,23 +4130,21 @@ static noinline int walk_up_tree(struct 
 	for (i = *level; i < max_level && path->nodes[i]; i++) {
 		slot = path->slots[i];
 		if (slot < btrfs_header_nritems(path->nodes[i]) - 1) {
-			struct extent_buffer *node;
-			struct btrfs_disk_key disk_key;
-
 			/*
 			 * there is more work to do in this level.
 			 * Update the drop_progress marker to reflect
 			 * the work we've done so far, and then bump
 			 * the slot number
 			 */
-			node = path->nodes[i];
 			path->slots[i]++;
-			*level = i;
 			WARN_ON(*level == 0);
-			btrfs_node_key(node, &disk_key, path->slots[i]);
-			memcpy(&root_item->drop_progress,
-			       &disk_key, sizeof(disk_key));
-			root_item->drop_level = i;
+			if (max_level == BTRFS_MAX_LEVEL) {
+				btrfs_node_key(path->nodes[i],
+					       &root_item->drop_progress,
+					       path->slots[i]);
+				root_item->drop_level = i;
+			}
+			*level = i;
 			return 0;
 		} else {
 			struct extent_buffer *parent;
@@ -3761,22 +4158,20 @@ static noinline int walk_up_tree(struct 
 			else
 				parent = path->nodes[*level + 1];
 
-			root_owner = btrfs_header_owner(parent);
-			root_gen = btrfs_header_generation(parent);
-
-			clean_tree_block(trans, root, path->nodes[*level]);
+			clean_tree_block(trans, root, path->nodes[i]);
 			ret = btrfs_free_extent(trans, root,
-						path->nodes[*level]->start,
-						path->nodes[*level]->len,
-						parent->start, root_owner,
-						root_gen, *level, 1);
+						path->nodes[i]->start,
+						path->nodes[i]->len,
+						parent->start,
+						btrfs_header_owner(parent),
+						*level, 0);
 			BUG_ON(ret);
 			if (path->locks[*level]) {
-				btrfs_tree_unlock(path->nodes[*level]);
-				path->locks[*level] = 0;
+				btrfs_tree_unlock(path->nodes[i]);
+				path->locks[i] = 0;
 			}
-			free_extent_buffer(path->nodes[*level]);
-			path->nodes[*level] = NULL;
+			free_extent_buffer(path->nodes[i]);
+			path->nodes[i] = NULL;
 			*level = i + 1;
 		}
 	}
@@ -3795,21 +4190,18 @@ int btrfs_drop_snapshot(struct btrfs_tra
 	int wret;
 	int level;
 	struct btrfs_path *path;
-	int i;
-	int orig_level;
 	int update_count;
 	struct btrfs_root_item *root_item = &root->root_item;
 
-	WARN_ON(!mutex_is_locked(&root->fs_info->drop_mutex));
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
 
 	level = btrfs_header_level(root->node);
-	orig_level = level;
 	if (btrfs_disk_key_objectid(&root_item->drop_progress) == 0) {
-		path->nodes[level] = root->node;
-		extent_buffer_get(root->node);
+		path->nodes[level] = btrfs_lock_root_node(root);
+		btrfs_set_lock_blocking(path->nodes[level]);
 		path->slots[level] = 0;
+		path->locks[level] = 1;
 	} else {
 		struct btrfs_key key;
 		struct btrfs_disk_key found_key;
@@ -3831,12 +4223,7 @@ int btrfs_drop_snapshot(struct btrfs_tra
 		 * unlock our path, this is safe because only this
 		 * function is allowed to delete this snapshot
 		 */
-		for (i = 0; i < BTRFS_MAX_LEVEL; i++) {
-			if (path->nodes[i] && path->locks[i]) {
-				path->locks[i] = 0;
-				btrfs_tree_unlock(path->nodes[i]);
-			}
-		}
+		btrfs_unlock_up_safe(path, 0);
 	}
 	while (1) {
 		unsigned long update;
@@ -3868,12 +4255,6 @@ int btrfs_drop_snapshot(struct btrfs_tra
 				break;
 		}
 	}
-	for (i = 0; i <= orig_level; i++) {
-		if (path->nodes[i]) {
-			free_extent_buffer(path->nodes[i]);
-			path->nodes[i] = NULL;
-		}
-	}
 out:
 	btrfs_free_path(path);
 	return ret;
@@ -3906,7 +4287,7 @@ int btrfs_drop_subtree(struct btrfs_tran
 	path->slots[level] = 0;
 
 	while (1) {
-		wret = walk_down_subtree(trans, root, path, &level);
+		wret = walk_down_tree(trans, root, path, &level);
 		if (wret < 0)
 			ret = wret;
 		if (wret != 0)
@@ -3923,6 +4304,8 @@ int btrfs_drop_subtree(struct btrfs_tran
 	return ret;
 }
 
+#if 0
+
 static unsigned long calc_ra(unsigned long start, unsigned long last,
 			     unsigned long nr)
 {
@@ -5404,6 +5787,7 @@ out:
 	kfree(ref_path);
 	return ret;
 }
+#endif
 
 static u64 update_block_group_flags(struct btrfs_root *root, u64 flags)
 {
@@ -5756,6 +6140,7 @@ out:
 	btrfs_free_path(path);
 	return ret;
 }
+#endif
 
 static int find_first_block_group(struct btrfs_root *root,
 		struct btrfs_path *path, struct btrfs_key *key)



