From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH 5/5] btrfs: log mode COW
Date: Tue, 11 May 2010 16:26:03 +0800
Message-ID: <4BE9149B.7010903@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The aim of this patch is solving extent tree performance issue
when free metadata space are scarce and fragmented. The basic idea
of log mode COW is: when cowing a non-shared block, we insert a log
entry that maps the new block to the old block into a special log
tree, and do not update the extent tree. After transaction is fully
committed, we copy the new block back to the old location. Since
tree blocks used by the log tree are not recorded in the extent
tree, updating extent tree is no longer recursive.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urpN 5/fs/btrfs/ctree.c 6/fs/btrfs/ctree.c
--- 5/fs/btrfs/ctree.c	2010-05-11 14:09:45.050108000 +0800
+++ 6/fs/btrfs/ctree.c	2010-05-11 11:34:33.781108000 +0800
@@ -276,15 +276,44 @@ int btrfs_block_can_be_shared(struct btr
 	return 0;
 }
 
+struct __btrfs_block_info {
+	u64 refs;
+	u64 flags;
+};
+
+static noinline int lookup_tree_block_info(struct btrfs_trans_handle *trans,
+					   struct btrfs_root *root,
+					   struct extent_buffer *buf,
+					   struct __btrfs_block_info *info)
+{
+	if (root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID ||
+	    root->root_key.objectid == BTRFS_EXTENT_LOG_OBJECTID) {
+		info->refs = 0;
+		info->flags = 0;
+	} else if (btrfs_block_can_be_shared(root, buf)) {
+		int ret;
+		ret = btrfs_lookup_extent_info(trans, root,
+						buf->start, buf->len,
+						&info->refs, &info->flags);
+		BUG_ON(ret);
+	} else {
+		info->refs = 1;
+		if (root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID ||
+		    btrfs_header_backref_rev(buf) < BTRFS_MIXED_BACKREF_REV)
+			info->flags |= BTRFS_BLOCK_FLAG_FULL_BACKREF;
+		else
+			info->flags = 0;
+	}
+	return 0;
+}
+
 static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 				       struct btrfs_root *root,
 				       struct extent_buffer *buf,
 				       struct extent_buffer *cow,
-				       int *last_ref)
+				       struct __btrfs_block_info *info)
 {
-	u64 refs;
 	u64 owner;
-	u64 flags;
 	u64 new_flags = 0;
 	int ret;
 
@@ -305,28 +334,14 @@ static noinline int update_ref_for_cow(s
 	 * are only allowed for blocks use full backrefs.
 	 */
 
-	if (btrfs_block_can_be_shared(root, buf)) {
-		ret = btrfs_lookup_extent_info(trans, root, buf->start,
-					       buf->len, &refs, &flags);
-		BUG_ON(ret);
-		BUG_ON(refs == 0);
-	} else {
-		refs = 1;
-		if (root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID ||
-		    btrfs_header_backref_rev(buf) < BTRFS_MIXED_BACKREF_REV)
-			flags = BTRFS_BLOCK_FLAG_FULL_BACKREF;
-		else
-			flags = 0;
-	}
-
 	owner = btrfs_header_owner(buf);
 	BUG_ON(owner == BTRFS_TREE_RELOC_OBJECTID &&
-	       !(flags & BTRFS_BLOCK_FLAG_FULL_BACKREF));
+	       !(info->flags & BTRFS_BLOCK_FLAG_FULL_BACKREF));
 
-	if (refs > 1) {
+	if (info->refs > 1) {
 		if ((owner == root->root_key.objectid ||
 		     root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID) &&
-		    !(flags & BTRFS_BLOCK_FLAG_FULL_BACKREF)) {
+		    !(info->flags & BTRFS_BLOCK_FLAG_FULL_BACKREF)) {
 			ret = btrfs_inc_ref(trans, root, buf, 1);
 			BUG_ON(ret);
 
@@ -349,11 +364,11 @@ static noinline int update_ref_for_cow(s
 		}
 		if (new_flags != 0) {
 			ret = btrfs_update_tree_block_info(trans, root, buf,
-							   NULL, new_flags, 0);
+							NULL, new_flags, 0);
 			BUG_ON(ret);
 		}
 	} else {
-		if (flags & BTRFS_BLOCK_FLAG_FULL_BACKREF) {
+		if (info->flags & BTRFS_BLOCK_FLAG_FULL_BACKREF) {
 			if (root->root_key.objectid ==
 			    BTRFS_TREE_RELOC_OBJECTID)
 				ret = btrfs_inc_ref(trans, root, cow, 1);
@@ -362,61 +377,41 @@ static noinline int update_ref_for_cow(s
 			BUG_ON(ret);
 			ret = btrfs_dec_ref(trans, root, buf, 1);
 			BUG_ON(ret);
+		} else {
+			BUG_ON(root->root_key.objectid != owner);
+			BUG_ON(root->root_key.objectid ==
+			       BTRFS_TREE_RELOC_OBJECTID);
 		}
 		clean_tree_block(trans, root, buf);
-		*last_ref = 1;
 	}
 	return 0;
 }
 
-/*
- * does the dirty work in cow of a single block.  The parent block (if
- * supplied) is updated to point to the new cow copy.  The new buffer is marked
- * dirty and returned locked.  If you modify the block it needs to be marked
- * dirty again.
- *
- * search_start -- an allocation hint for the new block
- *
- * empty_size -- a hint that you plan on doing more cow.  This is the size in
- * bytes the allocator should try to find free next to the block it returns.
- * This is just a hint and may be ignored by the allocator.
- */
-static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *root,
-			     struct extent_buffer *buf,
-			     struct extent_buffer *parent, int parent_slot,
-			     struct extent_buffer **cow_ret,
-			     u64 search_start, u64 empty_size)
+static noinline int do_cow_block(struct btrfs_trans_handle *trans,
+				 struct btrfs_root *root,
+				 struct extent_buffer *buf,
+				 struct extent_buffer *parent,
+				 struct extent_buffer **cow_ret,
+				 struct __btrfs_block_info *info,
+				 u64 search_start, u64 empty_size)
 {
 	struct btrfs_disk_key disk_key;
 	struct extent_buffer *cow;
 	int level;
-	int unlock_orig = 0;
-	int last_ref = 0;
 	u64 parent_start;
 
-	if (*cow_ret == buf)
-		unlock_orig = 1;
-
-	btrfs_assert_tree_locked(buf);
-
-	WARN_ON(root->ref_cows && trans->transid !=
-		root->fs_info->running_transaction->transid);
-	WARN_ON(root->ref_cows && trans->transid != root->last_trans);
-
 	level = btrfs_header_level(buf);
-
-	if (level == 0)
-		btrfs_item_key(buf, &disk_key, 0);
-	else
-		btrfs_node_key(buf, &disk_key, 0);
-
-	if (root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID) {
-		if (parent)
-			parent_start = parent->start;
+	if (btrfs_header_nritems(buf) > 0) {
+		if (level == 0)
+			btrfs_item_key(buf, &disk_key, 0);
 		else
-			parent_start = 0;
+			btrfs_node_key(buf, &disk_key, 0);
 	} else
+		memset(&disk_key, 0, sizeof(disk_key));
+
+	if (parent && root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID)
+		parent_start = parent->start;
+	else
 		parent_start = 0;
 
 	cow = btrfs_alloc_free_block(trans, root, buf->len, parent_start,
@@ -426,13 +421,13 @@ static noinline int __btrfs_cow_block(st
 		return PTR_ERR(cow);
 
 	/* cow is set to blocking by btrfs_init_new_buffer */
-
 	copy_extent_buffer(cow, buf, 0, 0, cow->len);
 	btrfs_set_header_bytenr(cow, cow->start);
 	btrfs_set_header_generation(cow, trans->transid);
 	btrfs_set_header_backref_rev(cow, BTRFS_MIXED_BACKREF_REV);
 	btrfs_clear_header_flag(cow, BTRFS_HEADER_FLAG_WRITTEN |
-				     BTRFS_HEADER_FLAG_RELOC);
+				     BTRFS_HEADER_FLAG_RELOC |
+				     BTRFS_HEADER_FLAG_LOGS);
 	if (root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID)
 		btrfs_set_header_flag(cow, BTRFS_HEADER_FLAG_RELOC);
 	else
@@ -442,41 +437,115 @@ static noinline int __btrfs_cow_block(st
 			    (unsigned long)btrfs_header_fsid(cow),
 			    BTRFS_FSID_SIZE);
 
-	update_ref_for_cow(trans, root, buf, cow, &last_ref);
+	if (info->refs > 0)
+		update_ref_for_cow(trans, root, buf, cow, info);
+
+	btrfs_mark_buffer_dirty(cow);
+	*cow_ret = cow;
+	return 0;
+}
+
+static noinline int setup_ptr_for_cow(struct btrfs_trans_handle *trans,
+				      struct btrfs_root *root,
+				      struct extent_buffer *buf,
+				      struct extent_buffer *cow,
+				      struct extent_buffer *parent, int pslot,
+				      int free_old, int last_ref)
+{
+	u64 parent_start;
 
 	if (buf == root->node) {
 		WARN_ON(parent && parent != buf);
-		if (root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID ||
-		    btrfs_header_backref_rev(buf) < BTRFS_MIXED_BACKREF_REV)
-			parent_start = buf->start;
-		else
-			parent_start = 0;
 
+		extent_buffer_get(cow);
 		spin_lock(&root->node_lock);
 		root->node = cow;
-		extent_buffer_get(cow);
 		spin_unlock(&root->node_lock);
 
-		btrfs_free_tree_block(trans, root, buf, parent_start,
-				      last_ref);
 		free_extent_buffer(buf);
 		add_root_to_dirty_list(root);
+
+		if (!free_old)
+			goto out;
+
+		if (root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID ||
+		    btrfs_header_backref_rev(buf) < BTRFS_MIXED_BACKREF_REV)
+			parent_start = buf->start;
+		else
+			parent_start = 0;
+		btrfs_free_tree_block(trans, root, buf, parent_start,
+				      last_ref);
 	} else {
+		btrfs_set_node_blockptr(parent, pslot, cow->start);
+		btrfs_set_node_ptr_generation(parent, pslot, trans->transid);
+		btrfs_mark_buffer_dirty(parent);
+
+		if (!free_old)
+			goto out;
+
 		if (root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID)
 			parent_start = parent->start;
 		else
 			parent_start = 0;
-
-		WARN_ON(trans->transid != btrfs_header_generation(parent));
-		btrfs_set_node_blockptr(parent, parent_slot,
-					cow->start);
-		btrfs_set_node_ptr_generation(parent, parent_slot,
-					      trans->transid);
-		btrfs_mark_buffer_dirty(parent);
 		btrfs_free_tree_block(trans, root, buf, parent_start,
 				      last_ref);
 	}
-	if (unlock_orig)
+out:
+	return 0;
+}
+
+/*
+ * does the dirty work in cow of a single block.  The parent block (if
+ * supplied) is updated to point to the new cow copy.  The new buffer is marked
+ * dirty and returned locked.  If you modify the block it needs to be marked
+ * dirty again.
+ *
+ * search_start -- an allocation hint for the new block
+ *
+ * empty_size -- a hint that you plan on doing more cow.  This is the size in
+ * bytes the allocator should try to find free next to the block it returns.
+ * This is just a hint and may be ignored by the allocator.
+ */
+static int __btrfs_cow_block(struct btrfs_trans_handle *trans,
+			     struct btrfs_root *root,
+			     struct extent_buffer *buf,
+			     struct extent_buffer *parent, int parent_slot,
+			     struct extent_buffer **cow_ret,
+			     u64 search_start, u64 empty_size)
+{
+	struct __btrfs_block_info info;
+	struct extent_buffer *cow;
+	int ret;
+
+	btrfs_assert_tree_locked(buf);
+	WARN_ON(root->ref_cows && trans->transid !=
+		root->fs_info->running_transaction->transid);
+	WARN_ON(root->ref_cows && trans->transid != root->last_trans);
+
+	lookup_tree_block_info(trans, root, buf, &info);
+
+	if (info.refs == 1 && !(info.flags & BTRFS_BLOCK_FLAG_FULL_BACKREF)) {
+		ret = btrfs_log_cow_block(trans, root, buf, &cow,
+					  search_start, empty_size);
+		if (!ret) {
+			setup_ptr_for_cow(trans, root, buf, cow, parent,
+					  parent_slot, 0, 1);
+			goto done;
+		}
+		if (ret != -EAGAIN)
+			return ret;
+	}
+
+	BUG_ON(btrfs_header_flags(buf) & BTRFS_HEADER_FLAG_LOGS);
+	ret = do_cow_block(trans, root, buf, parent, &cow, &info,
+			   search_start, empty_size);
+	if (ret)
+		return ret;
+
+	setup_ptr_for_cow(trans, root, buf, cow, parent, parent_slot,
+			  1, info.refs <= 1);
+done:
+	if (*cow_ret == buf)
 		btrfs_tree_unlock(buf);
 	free_extent_buffer(buf);
 	btrfs_mark_buffer_dirty(cow);
diff -urpN 5/fs/btrfs/ctree.h 6/fs/btrfs/ctree.h
--- 5/fs/btrfs/ctree.h	2010-05-11 14:15:29.168108000 +0800
+++ 6/fs/btrfs/ctree.h	2010-05-11 09:02:42.521108000 +0800
@@ -96,6 +96,11 @@ struct btrfs_ordered_sum;
  * for fsyncs
  */
 #define BTRFS_EXTENT_CSUM_OBJECTID -10ULL
+/*
+ * extent log tree stores information about translations
+ * from log block to original block.
+ */
+#define BTRFS_EXTENT_LOG_OBJECTID -11ULL
 
 /* dummy objectid represents multiple objectids */
 #define BTRFS_MULTIPLE_OBJECTIDS -255ULL
@@ -273,9 +278,14 @@ static inline unsigned long btrfs_chunk_
 #define BTRFS_FSID_SIZE 16
 #define BTRFS_HEADER_FLAG_WRITTEN	(1ULL << 0)
 #define BTRFS_HEADER_FLAG_RELOC		(1ULL << 1)
+#define BTRFS_HEADER_FLAG_LOG0		(1ULL << 2)
+#define BTRFS_HEADER_FLAG_LOG1		(1ULL << 3)
 #define BTRFS_SUPER_FLAG_SEEDING	(1ULL << 32)
 #define BTRFS_SUPER_FLAG_METADUMP	(1ULL << 33)
 
+#define BTRFS_HEADER_FLAG_LOGS		(BTRFS_HEADER_FLAG_LOG0 | \
+					 BTRFS_HEADER_FLAG_LOG1)
+
 #define BTRFS_BACKREF_REV_MAX		256
 #define BTRFS_BACKREF_REV_SHIFT		56
 #define BTRFS_BACKREF_REV_MASK		(((u64)BTRFS_BACKREF_REV_MAX - 1) << \
@@ -446,11 +456,17 @@ struct btrfs_path {
 	unsigned int search_commit_root:1;
 };
 
+struct btrfs_block_log_item {
+	__le64 owner;
+	struct btrfs_disk_key key;
+	u8 level;
+	__le16 flags;
+} __attribute__ ((__packed__));
+
 /*
  * items in the extent btree are used to record the objectid of the
  * owner of the block and the number of references
  */
-
 struct btrfs_extent_item {
 	__le64 refs;
 	__le64 generation;
@@ -798,6 +814,7 @@ struct btrfs_block_group_cache {
 struct reloc_control;
 struct btrfs_device;
 struct btrfs_fs_devices;
+struct btrfs_extent_log;
 struct btrfs_fs_info {
 	u8 fsid[BTRFS_FSID_SIZE];
 	u8 chunk_tree_uuid[BTRFS_UUID_SIZE];
@@ -962,6 +979,8 @@ struct btrfs_fs_info {
 
 	struct reloc_control *reloc_ctl;
 
+	struct btrfs_extent_log *extent_log;
+
 	spinlock_t delalloc_lock;
 	spinlock_t new_trans_lock;
 	u64 delalloc_bytes;
@@ -1024,6 +1043,7 @@ struct btrfs_root {
 
 	u64 objectid;
 	u64 last_trans;
+	u64 last_log_trans;
 
 	/* data allocations are done in sectorsize units */
 	u32 sectorsize;
@@ -1043,6 +1063,7 @@ struct btrfs_root {
 	int track_dirty;
 	int in_radix;
 	int clean_orphans;
+	int no_logs;
 
 	u64 defrag_trans_start;
 	struct btrfs_key defrag_progress;
@@ -1081,12 +1102,12 @@ struct btrfs_root {
 #define BTRFS_ORPHAN_ITEM_KEY		48
 /* reserve 2-15 close to the inode for later flexibility */
 
+#define BTRFS_DIR_LOG_ITEM_KEY  60
+#define BTRFS_DIR_LOG_INDEX_KEY 72
 /*
  * dir items are the name -> inode pointers in a directory.  There is one
  * for every name in a directory.
  */
-#define BTRFS_DIR_LOG_ITEM_KEY  60
-#define BTRFS_DIR_LOG_INDEX_KEY 72
 #define BTRFS_DIR_ITEM_KEY	84
 #define BTRFS_DIR_INDEX_KEY	96
 /*
@@ -1119,6 +1140,7 @@ struct btrfs_root {
  */
 #define BTRFS_ROOT_REF_KEY	156
 
+#define BTRFS_BLOCK_LOG_ITEM_KEY 162
 /*
  * extent items are in the extent map tree.  These record which blocks
  * are used, and how many references there are to each block
@@ -1438,6 +1460,24 @@ static inline u8 *btrfs_dev_extent_chunk
 	return (u8 *)((unsigned long)dev + ptr);
 }
 
+BTRFS_SETGET_FUNCS(block_log_owner, struct btrfs_block_log_item, owner, 64);
+BTRFS_SETGET_FUNCS(block_log_level, struct btrfs_block_log_item, level, 8);
+BTRFS_SETGET_FUNCS(block_log_flags, struct btrfs_block_log_item, flags, 16);
+
+static inline void btrfs_block_log_key(struct extent_buffer *eb,
+					struct btrfs_block_log_item *item,
+					struct btrfs_disk_key *key)
+{
+	read_eb_member(eb, item, struct btrfs_block_log_item, key, key);
+}
+
+static inline void btrfs_set_block_log_key(struct extent_buffer *eb,
+					struct btrfs_block_log_item *item,
+					struct btrfs_disk_key *key)
+{
+	write_eb_member(eb, item, struct btrfs_block_log_item, key, key);
+}
+
 BTRFS_SETGET_FUNCS(extent_refs, struct btrfs_extent_item, refs, 64);
 BTRFS_SETGET_FUNCS(extent_generation, struct btrfs_extent_item,
 		   generation, 64);
@@ -1996,6 +2036,9 @@ void btrfs_free_tree_block(struct btrfs_
 			   struct btrfs_root *root,
 			   struct extent_buffer *buf,
 			   u64 parent, int last_ref);
+void btrfs_free_logged_tree_block(struct btrfs_trans_handle *trans,
+				  struct btrfs_root *root,
+				  u64 bytenr, u32 blocksize, int level);
 void btrfs_free_reserved_tree_block(struct btrfs_trans_handle *trans,
 				    struct btrfs_root *root,
 				    u64 bytenr, u32 blocksize,
@@ -2008,6 +2051,8 @@ int btrfs_alloc_reserved_file_extent(str
 				     struct btrfs_root *root,
 				     u64 root_objectid, u64 owner,
 				     u64 offset, struct btrfs_key *ins);
+int btrfs_reserve_log_tree_block(struct btrfs_root *root,
+				 u64 bytenr, u32 blocksize);
 int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root,
 				   u64 root_objectid, u64 owner, u64 offset,
@@ -2079,6 +2124,35 @@ void btrfs_delalloc_reserve_space(struct
 				 u64 bytes);
 void btrfs_delalloc_free_space(struct btrfs_root *root, struct inode *inode,
 			      u64 bytes);
+/* extent-log.c */
+int btrfs_init_extent_log(struct btrfs_fs_info *fs_info);
+void btrfs_cleanup_extent_log(struct btrfs_fs_info *fs_info);
+int btrfs_flush_extent_log(struct btrfs_trans_handle *trans,
+			   struct btrfs_root *root, int flush_all);
+int btrfs_prepare_extent_log_commit(struct btrfs_trans_handle *trans,
+				    struct btrfs_root *root);
+int btrfs_finish_extent_log_commit(struct btrfs_root *root);
+int btrfs_async_replay_extent_log(struct btrfs_root *root);
+int btrfs_replay_extent_log(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root, int replay_all);
+int btrfs_log_cow_block(struct btrfs_trans_handle *trans,
+			struct btrfs_root *root,
+			struct extent_buffer *buf,
+			struct extent_buffer **cow_ret,
+			u64 hint, u64 empty_size);
+int btrfs_log_update_block_key(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root,
+				struct extent_buffer *buf,
+				struct btrfs_disk_key *key);
+void btrfs_log_free_tree_block(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *root,
+			       struct extent_buffer *buf, u64 *orig_bytenr,
+			       struct extent_buffer **orig_buf);
+int btrfs_recover_extent_log(struct btrfs_fs_info *fs_info);
+int btrfs_enable_extent_log(struct btrfs_root *root, int global);
+int btrfs_disable_extent_log(struct btrfs_root *root, int global);
+int btrfs_disable_extent_log_sync(struct btrfs_root *root, int global);
+int btrfs_set_extent_log_mode(struct btrfs_fs_info *fs_info, int mode);
 /* ctree.c */
 int btrfs_bin_search(struct extent_buffer *eb, struct btrfs_key *key,
 		     int level, int *slot);
diff -urpN 5/fs/btrfs/disk-io.c 6/fs/btrfs/disk-io.c
--- 5/fs/btrfs/disk-io.c	2010-04-14 14:49:56.559944000 +0800
+++ 6/fs/btrfs/disk-io.c	2010-05-11 11:42:02.839107000 +0800
@@ -895,11 +895,13 @@ static int __setup_root(u32 nodesize, u3
 	root->ref_cows = 0;
 	root->track_dirty = 0;
 	root->in_radix = 0;
+	root->no_logs = 0;
 	root->clean_orphans = 0;
 
 	root->fs_info = fs_info;
 	root->objectid = objectid;
 	root->last_trans = 0;
+	root->last_log_trans = 0;
 	root->highest_objectid = 0;
 	root->name = NULL;
 	root->in_sysfs = 0;
@@ -966,6 +968,7 @@ static int find_and_setup_root(struct bt
 				     blocksize, generation);
 	BUG_ON(!root->node);
 	root->commit_root = btrfs_root_node(root);
+	root->last_log_trans = generation;
 	return 0;
 }
 
@@ -1006,7 +1009,8 @@ int btrfs_free_log_root_tree(struct btrf
 }
 
 static struct btrfs_root *alloc_log_tree(struct btrfs_trans_handle *trans,
-					 struct btrfs_fs_info *fs_info)
+					 struct btrfs_fs_info *fs_info,
+					 u64 objectid)
 {
 	struct btrfs_root *root;
 	struct btrfs_root *tree_root = fs_info->tree_root;
@@ -1020,9 +1024,9 @@ static struct btrfs_root *alloc_log_tree
 		     tree_root->sectorsize, tree_root->stripesize,
 		     root, fs_info, BTRFS_TREE_LOG_OBJECTID);
 
-	root->root_key.objectid = BTRFS_TREE_LOG_OBJECTID;
+	root->root_key.objectid = objectid;
 	root->root_key.type = BTRFS_ROOT_ITEM_KEY;
-	root->root_key.offset = BTRFS_TREE_LOG_OBJECTID;
+	root->root_key.offset = 0;
 	/*
 	 * log trees do not get reference counted because they go away
 	 * before a real commit is actually done.  They do store pointers
@@ -1031,8 +1035,15 @@ static struct btrfs_root *alloc_log_tree
 	 */
 	root->ref_cows = 0;
 
-	leaf = btrfs_alloc_free_block(trans, root, root->leafsize, 0,
-				      BTRFS_TREE_LOG_OBJECTID, NULL, 0, 0, 0);
+	if (objectid == BTRFS_EXTENT_LOG_OBJECTID) {
+		/* use extent tree's reservation context */
+		leaf = btrfs_alloc_free_block(trans, fs_info->extent_root,
+					      root->leafsize, 0, objectid,
+					      NULL, 0, 0, 0);
+	} else {
+		leaf = btrfs_alloc_free_block(trans, root, root->leafsize, 0,
+					      objectid, NULL, 0, 0, 0);
+	}
 	if (IS_ERR(leaf)) {
 		kfree(root);
 		return ERR_CAST(leaf);
@@ -1042,23 +1053,36 @@ static struct btrfs_root *alloc_log_tree
 	btrfs_set_header_bytenr(leaf, leaf->start);
 	btrfs_set_header_generation(leaf, trans->transid);
 	btrfs_set_header_backref_rev(leaf, BTRFS_MIXED_BACKREF_REV);
-	btrfs_set_header_owner(leaf, BTRFS_TREE_LOG_OBJECTID);
-	root->node = leaf;
+	btrfs_set_header_owner(leaf, objectid);
 
-	write_extent_buffer(root->node, root->fs_info->fsid,
-			    (unsigned long)btrfs_header_fsid(root->node),
+	write_extent_buffer(leaf, root->fs_info->fsid,
+			    (unsigned long)btrfs_header_fsid(leaf),
 			    BTRFS_FSID_SIZE);
+	write_extent_buffer(leaf, root->fs_info->chunk_tree_uuid,
+			    (unsigned long)btrfs_header_chunk_tree_uuid(leaf),
+			    BTRFS_UUID_SIZE);
+	root->node = leaf;
+
 	btrfs_mark_buffer_dirty(root->node);
 	btrfs_tree_unlock(root->node);
 	return root;
 }
 
+struct btrfs_root *
+btrfs_alloc_extent_log_tree(struct btrfs_trans_handle *trans,
+			    struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_root *root;
+	root = alloc_log_tree(trans, fs_info, BTRFS_EXTENT_LOG_OBJECTID);
+	return root;
+}
+
 int btrfs_init_log_root_tree(struct btrfs_trans_handle *trans,
 			     struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_root *log_root;
 
-	log_root = alloc_log_tree(trans, fs_info);
+	log_root = alloc_log_tree(trans, fs_info, BTRFS_TREE_LOG_OBJECTID);
 	if (IS_ERR(log_root))
 		return PTR_ERR(log_root);
 	WARN_ON(fs_info->log_root_tree);
@@ -1072,7 +1096,8 @@ int btrfs_add_log_tree(struct btrfs_tran
 	struct btrfs_root *log_root;
 	struct btrfs_inode_item *inode_item;
 
-	log_root = alloc_log_tree(trans, root->fs_info);
+	log_root = alloc_log_tree(trans, root->fs_info,
+				  BTRFS_TREE_LOG_OBJECTID);
 	if (IS_ERR(log_root))
 		return PTR_ERR(log_root);
 
@@ -1145,6 +1170,7 @@ struct btrfs_root *btrfs_read_fs_root_no
 	root->node = read_tree_block(root, btrfs_root_bytenr(&root->root_item),
 				     blocksize, generation);
 	root->commit_root = btrfs_root_node(root);
+	root->last_log_trans = generation;
 	BUG_ON(!root->node);
 out:
 	if (location->objectid != BTRFS_TREE_LOG_OBJECTID)
@@ -1502,47 +1528,73 @@ static int transaction_kthread(void *arg
 	struct btrfs_root *root = arg;
 	struct btrfs_trans_handle *trans;
 	struct btrfs_transaction *cur;
+	u64 transid;
 	unsigned long now;
 	unsigned long delay;
+	int replay_log;
+	int commit_trans;
 	int ret;
 
 	do {
-		smp_mb();
-		if (root->fs_info->closing)
-			break;
-
 		delay = HZ * 30;
+		replay_log = 0;
+		commit_trans = 0;
 		vfs_check_frozen(root->fs_info->sb, SB_FREEZE_WRITE);
 		mutex_lock(&root->fs_info->transaction_kthread_mutex);
 
-		mutex_lock(&root->fs_info->trans_mutex);
+		spin_lock(&root->fs_info->new_trans_lock);
 		cur = root->fs_info->running_transaction;
 		if (!cur) {
-			mutex_unlock(&root->fs_info->trans_mutex);
+			spin_unlock(&root->fs_info->new_trans_lock);
 			goto sleep;
 		}
 
+		replay_log = cur->replay_log;
+
 		now = get_seconds();
-		if (now < cur->start_time || now - cur->start_time < 30) {
-			mutex_unlock(&root->fs_info->trans_mutex);
+		if (cur->blocked || now - cur->start_time > 30)
+			commit_trans = 1;
+
+		transid = cur->transid;
+		spin_unlock(&root->fs_info->new_trans_lock);
+
+		if (!replay_log && !commit_trans) {
 			delay = HZ * 5;
 			goto sleep;
 		}
-		mutex_unlock(&root->fs_info->trans_mutex);
-		trans = btrfs_start_transaction(root, 1);
-		ret = btrfs_commit_transaction(trans, root);
 
+		trans = btrfs_join_transaction(root, 1);
+		BUG_ON(IS_ERR(trans));
+
+		if (transid != trans->transid) {
+			smp_mb();
+			if (!root->fs_info->closing) {
+				btrfs_end_transaction(trans, root);
+				goto sleep;
+			}
+			commit_trans = 1;
+		}
+
+		if (commit_trans) {
+			ret = btrfs_commit_transaction(trans, root);
+			BUG_ON(ret);
+		} else {
+			if (replay_log) {
+				ret = btrfs_replay_extent_log(trans, root, 0);
+				BUG_ON(ret);
+			}
+			btrfs_end_transaction(trans, root);
+		}
 sleep:
 		wake_up_process(root->fs_info->cleaner_kthread);
 		mutex_unlock(&root->fs_info->transaction_kthread_mutex);
 
 		if (freezing(current)) {
 			refrigerator();
-		} else {
-			if (root->fs_info->closing)
-				break;
+		} else if (!replay_log && !commit_trans) {
 			set_current_state(TASK_INTERRUPTIBLE);
-			schedule_timeout(delay);
+			if (!kthread_should_stop())
+				schedule_timeout(delay);
 			__set_current_state(TASK_RUNNING);
 		}
 	} while (!kthread_should_stop());
@@ -1593,6 +1645,12 @@ struct btrfs_root *open_ctree(struct sup
 		goto fail;
 	}
 
+	ret = btrfs_init_extent_log(fs_info);
+	if (ret) {
+		err = ret;
+		goto fail_srcu;
+	}
+
 	ret = setup_bdi(fs_info, &fs_info->bdi);
 	if (ret) {
 		err = ret;
@@ -1951,6 +2009,13 @@ struct btrfs_root *open_ctree(struct sup
 		btrfs_set_opt(fs_info->mount_opt, SSD);
 	}
 
+	ret = btrfs_recover_extent_log(fs_info);
+	if (ret) {
+		printk(KERN_WARNING "btrfs: failed to recover extent log\n");
+		err = -EIO;
+		goto fail_trans_kthread;
+	}
+
 	if (btrfs_super_log_root(disk_super) != 0) {
 		u64 bytenr = btrfs_super_log_root(disk_super);
 
@@ -1990,7 +2055,7 @@ struct btrfs_root *open_ctree(struct sup
 		if (ret < 0) {
 			printk(KERN_WARNING
 			       "btrfs: failed to recover relocation\n");
-			err = -EINVAL;
+			err = -EIO;
 			goto fail_trans_kthread;
 		}
 	}
@@ -2022,7 +2087,6 @@ fail_cleaner:
 	 */
 	filemap_write_and_wait(fs_info->btree_inode->i_mapping);
 	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
-
 fail_block_groups:
 	btrfs_free_block_groups(fs_info);
 	free_extent_buffer(csum_root->node);
@@ -2060,6 +2124,7 @@ fail_bdi:
 	bdi_destroy(&fs_info->bdi);
 fail_srcu:
 	cleanup_srcu_struct(&fs_info->subvol_srcu);
+	btrfs_cleanup_extent_log(fs_info);
 fail:
 	kfree(extent_root);
 	kfree(tree_root);
@@ -2438,6 +2503,8 @@ int close_ctree(struct btrfs_root *root)
 	kthread_stop(root->fs_info->transaction_kthread);
 	kthread_stop(root->fs_info->cleaner_kthread);
 
+	btrfs_disable_extent_log(root, 1);
+
 	if (!(fs_info->sb->s_flags & MS_RDONLY)) {
 		ret =  btrfs_commit_super(root);
 		if (ret)
@@ -2467,6 +2534,8 @@ int close_ctree(struct btrfs_root *root)
 	free_extent_buffer(root->fs_info->csum_root->node);
 	free_extent_buffer(root->fs_info->csum_root->commit_root);
 
+	btrfs_cleanup_extent_log(fs_info);
+
 	btrfs_free_block_groups(root->fs_info);
 
 	del_fs_roots(fs_info);
diff -urpN 5/fs/btrfs/disk-io.h 6/fs/btrfs/disk-io.h
--- 5/fs/btrfs/disk-io.h	2010-04-13 15:44:56.107812000 +0800
+++ 6/fs/btrfs/disk-io.h	2010-05-11 11:48:09.584114000 +0800
@@ -101,6 +101,9 @@ int btrfs_init_log_root_tree(struct btrf
 			     struct btrfs_fs_info *fs_info);
 int btrfs_add_log_tree(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root);
+struct btrfs_root *
+btrfs_alloc_extent_log_tree(struct btrfs_trans_handle *trans,
+			    struct btrfs_fs_info *fs_info);
 int btree_lock_page_hook(struct page *page);
 
 
diff -urpN 5/fs/btrfs/extent-log.c 6/fs/btrfs/extent-log.c
--- 5/fs/btrfs/extent-log.c	1970-01-01 07:00:00.000000000 +0700
+++ 6/fs/btrfs/extent-log.c	2010-05-11 12:50:40.726106000 +0800
@@ -0,0 +1,1560 @@
+/*
+ * Copyright (C) 2010 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#include <linux/sched.h>
+#include <linux/rbtree.h>
+#include "ctree.h"
+#include "transaction.h"
+#include "disk-io.h"
+#include "locking.h"
+#include "tree-log.h"
+#include "print-tree.h"
+#include "compat.h"
+
+struct extent_log_entry {
+	struct rb_node rb_node;
+	/* the starting bytenr of the new block */
+	u64 bytenr;
+	/* the starting bytenr of the old block */
+	u64 orig_bytenr;
+	union {
+		/* generation of the old block */
+		u64 generation;
+		/* owner tree objectid */
+		u64 owner;
+	};
+	u32 blocksize;
+	/* key of the new block */
+	struct btrfs_disk_key key;
+	/* owner tree */
+	struct btrfs_root *root;
+	unsigned int level:8;
+	unsigned int op_type:8;
+	unsigned int running:1;
+	unsigned int key_change:1;
+};
+
+enum extent_log_entry_type {
+	INSERT_LOG = 1,
+	UPDATE_LOG = 2,
+	DELETE_LOG = 3,
+};
+
+struct extent_log_struct {
+	struct btrfs_root *log_root;
+	struct rb_root op_tree;
+	spinlock_t lock;
+	atomic_t num_entries;
+	int root_inserted;
+};
+
+struct btrfs_extent_log {
+	struct extent_log_struct *active_log;
+	struct extent_log_struct *commit_log;
+	struct extent_log_struct logs[2];
+	struct mutex log_mutex;
+	struct rw_semaphore replay_sem;
+	wait_queue_head_t replay_wait;
+	int log_index;
+	int log_mode;
+	int disabled;
+	int replaying;
+	int recovering;
+	u64 last_trans;
+	u64 last_replayed;
+};
+
+enum extent_log_mode {
+	LOG_NONE,
+	LOG_COWONLY,
+	LOG_ALL,
+};
+
+#define BTRFS_LOG_FLAG_KEY_CHANGED	(1 << 0)
+
+static struct rb_node *op_tree_insert(struct rb_root *root, u64 bytenr,
+				      struct rb_node *node)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct extent_log_entry *entry;
+
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct extent_log_entry, rb_node);
+
+		if (bytenr < entry->bytenr)
+			p = &(*p)->rb_left;
+		else if (bytenr > entry->bytenr)
+			p = &(*p)->rb_right;
+		else
+			return parent;
+	}
+
+	rb_link_node(node, parent, p);
+	rb_insert_color(node, root);
+	return NULL;
+}
+
+static struct rb_node *op_tree_search(struct rb_root *root, u64 bytenr)
+{
+	struct rb_node *n = root->rb_node;
+	struct extent_log_entry *entry;
+
+	while (n) {
+		entry = rb_entry(n, struct extent_log_entry, rb_node);
+
+		if (bytenr < entry->bytenr)
+			n = n->rb_left;
+		else if (bytenr > entry->bytenr)
+			n = n->rb_right;
+		else
+			return n;
+	}
+	return NULL;
+}
+
+int btrfs_init_extent_log(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_extent_log *extent_log;
+	int i;
+
+	extent_log = kzalloc(sizeof(struct btrfs_extent_log), GFP_NOFS);
+	if (!extent_log)
+		return -ENOMEM;
+
+	mutex_init(&extent_log->log_mutex);
+	init_rwsem(&extent_log->replay_sem);
+	init_waitqueue_head(&extent_log->replay_wait);
+
+	for (i = 0; i < 2; i++) {
+		extent_log->logs[i].op_tree = RB_ROOT;
+		spin_lock_init(&extent_log->logs[i].lock);
+	}
+
+	fs_info->extent_log = extent_log;
+	return 0;
+}
+
+static struct extent_log_entry *alloc_extent_log_entry(void)
+{
+	return kzalloc(sizeof(struct extent_log_entry), GFP_NOFS);
+}
+
+static void free_extent_log_entry(struct extent_log_entry *entry)
+{
+	kfree(entry);
+}
+
+static void setup_extent_log_entry(struct extent_log_entry *entry,
+				   u64 bytenr, u64 orig_bytenr,
+				   u32 blocksize, u64 generation,
+				   struct btrfs_disk_key *key, int level,
+				   struct btrfs_root *root, int op_type)
+{
+	entry->bytenr = bytenr;
+	entry->orig_bytenr = orig_bytenr;
+	entry->blocksize = blocksize;
+	entry->generation = generation;
+	entry->level = level;
+	entry->root = root;
+	entry->op_type = op_type;
+	if (key)
+		memcpy(&entry->key, key, sizeof(entry->key));
+}
+
+static void check_extent_log_entry(struct extent_log_entry *entry)
+{
+	if (entry->op_type == INSERT_LOG) {
+		WARN_ON(entry->bytenr == entry->orig_bytenr);
+	} else {
+		WARN_ON(entry->op_type != UPDATE_LOG &&
+			entry->op_type != DELETE_LOG);
+		WARN_ON(entry->op_type == DELETE_LOG &&
+			entry->bytenr != entry->orig_bytenr);
+	}
+}
+
+/*
+ * helper to add log entry into the in-memory tree
+ */
+static int insert_extent_log_entry(struct extent_log_struct *log,
+				   struct extent_log_entry *entry,
+				   u64 *to_delete)
+{
+	struct rb_node *rb_node;
+	struct extent_log_entry *exist;
+
+	check_extent_log_entry(entry);
+	if (entry->op_type == INSERT_LOG)
+		atomic_inc(&log->num_entries);
+	else if (entry->op_type == DELETE_LOG)
+		atomic_dec(&log->num_entries);
+	else
+		WARN_ON(atomic_read(&log->num_entries) == 0);
+
+	spin_lock(&log->lock);
+	if (entry->op_type == INSERT_LOG) {
+		rb_node = op_tree_insert(&log->op_tree, entry->bytenr,
+				      &entry->rb_node);
+		spin_unlock(&log->lock);
+		BUG_ON(rb_node);
+		return 0;
+	}
+
+	while (1) {
+		rb_node = op_tree_search(&log->op_tree, entry->orig_bytenr);
+		if (!rb_node) {
+			rb_node = op_tree_insert(&log->op_tree, entry->bytenr,
+						 &entry->rb_node);
+			spin_unlock(&log->lock);
+			BUG_ON(rb_node);
+			return 0;
+		}
+
+		exist = rb_entry(rb_node, struct extent_log_entry, rb_node);
+		WARN_ON(exist->op_type == DELETE_LOG);
+		WARN_ON(exist->root != entry->root);
+		WARN_ON(exist->level != entry->level);
+
+		if (!exist->running)
+			break;
+
+		spin_unlock(&log->lock);
+		schedule_timeout(1);
+		spin_lock(&log->lock);
+	}
+
+	if (entry->op_type == UPDATE_LOG) {
+		exist->key_change = entry->key_change;
+		memcpy(&exist->key, &entry->key, sizeof(exist->key));
+		if (entry->bytenr != entry->orig_bytenr) {
+			if (exist->bytenr != exist->orig_bytenr)
+				*to_delete = exist->bytenr;
+			rb_erase(&exist->rb_node, &log->op_tree);
+			exist->bytenr = entry->bytenr;
+			rb_node = op_tree_insert(&log->op_tree, exist->bytenr,
+						 &exist->rb_node);
+			check_extent_log_entry(exist);
+			spin_unlock(&log->lock);
+			BUG_ON(rb_node);
+		} else {
+			spin_unlock(&log->lock);
+		}
+		free_extent_log_entry(entry);
+		return 0;
+	}
+
+	if (exist->op_type == INSERT_LOG) {
+		*to_delete = exist->bytenr;
+		rb_erase(&exist->rb_node, &log->op_tree);
+		spin_unlock(&log->lock);
+		free_extent_log_entry(entry);
+		free_extent_log_entry(exist);
+	} else {
+		exist->op_type = entry->op_type;
+		if (exist->bytenr != exist->orig_bytenr) {
+			*to_delete = exist->bytenr;
+			rb_erase(&exist->rb_node, &log->op_tree);
+			exist->bytenr = exist->orig_bytenr;
+			rb_node = op_tree_insert(&log->op_tree, exist->bytenr,
+						 &exist->rb_node);
+			check_extent_log_entry(exist);
+			spin_unlock(&log->lock);
+			BUG_ON(rb_node);
+		} else {
+			spin_unlock(&log->lock);
+		}
+		free_extent_log_entry(entry);
+	}
+	return 0;
+}
+
+/*
+ * lookup log entry that corresponds to log block.
+ * the parameter 'entry' is an input/output parameter.
+ */
+static int lookup_extent_log_entry(struct extent_log_struct *log,
+				   struct extent_log_entry *entry)
+{
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+	struct btrfs_block_log_item *log_item;
+	struct rb_node *rb_node;
+	struct extent_log_entry *exist;
+	struct btrfs_key key;
+	int flags;
+	int ret = 0;
+
+	WARN_ON(atomic_read(&log->num_entries) == 0);
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	spin_lock(&log->lock);
+	while (1) {
+		exist = NULL;
+		rb_node = op_tree_search(&log->op_tree, entry->orig_bytenr);
+		if (!rb_node)
+			break;
+
+		exist = rb_entry(rb_node, struct extent_log_entry,
+				 rb_node);
+		if (!exist->running) {
+			exist->running = 1;
+			break;
+		}
+
+		spin_unlock(&log->lock);
+		schedule_timeout(1);
+		spin_lock(&log->lock);
+	}
+	spin_unlock(&log->lock);
+
+	if (exist) {
+		WARN_ON(exist->op_type == DELETE_LOG);
+		WARN_ON(entry->root != exist->root);
+		WARN_ON(entry->level != exist->level);
+		entry->orig_bytenr = exist->orig_bytenr;
+		entry->key_change = exist->key_change;
+		memcpy(&entry->key, &exist->key, sizeof(entry->key));
+		if (exist->op_type == INSERT_LOG) {
+			entry->generation = exist->generation;
+			goto out;
+		}
+	}
+
+	key.objectid = entry->orig_bytenr;
+	key.type = BTRFS_BLOCK_LOG_ITEM_KEY;
+	key.offset = (u64)-1;
+
+	ret = btrfs_search_slot(NULL, log->log_root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+	BUG_ON(ret == 0);
+
+	leaf = path->nodes[0];
+	if (path->slots[0] > 0) {
+		btrfs_item_key_to_cpu(leaf, &key, path->slots[0] - 1);
+		if (key.objectid == entry->orig_bytenr &&
+		    key.type == BTRFS_BLOCK_LOG_ITEM_KEY) {
+			path->slots[0]--;
+			ret = 0;
+		}
+	}
+	if (ret > 0) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	log_item = btrfs_item_ptr(leaf, path->slots[0],
+				  struct btrfs_block_log_item);
+	WARN_ON(btrfs_block_log_owner(leaf, log_item) !=
+		entry->root->root_key.objectid);
+	WARN_ON(entry->level != btrfs_block_log_level(leaf, log_item));
+	flags = btrfs_block_log_flags(leaf, log_item);
+	entry->orig_bytenr = key.offset;
+	entry->generation = 0;
+	if (flags & BTRFS_LOG_FLAG_KEY_CHANGED)
+		entry->key_change = 1;
+	if (!exist)
+		btrfs_block_log_key(leaf, log_item, &entry->key);
+	ret = 0;
+out:
+	if (exist) {
+		spin_lock(&log->lock);
+		exist->running = 0;
+		spin_unlock(&log->lock);
+	}
+
+	btrfs_free_path(path);
+	return ret;
+}
+
+static int flush_extent_log_entry(struct btrfs_trans_handle *trans,
+				  struct extent_log_struct *log,
+				  struct extent_log_entry *entry,
+				  u64 *to_delete)
+{
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+	struct btrfs_block_log_item *log_item;
+	struct btrfs_key key;
+	int flags = 0;
+	int ins;
+	int ret = 0;
+
+	BUG_ON(!entry->running);
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	if (entry->key_change)
+		flags |= BTRFS_LOG_FLAG_KEY_CHANGED;
+
+	if (entry->op_type == INSERT_LOG) {
+		BUG_ON(entry->bytenr == entry->orig_bytenr);
+		key.objectid = entry->bytenr;
+		key.type = BTRFS_BLOCK_LOG_ITEM_KEY;
+		key.offset = entry->orig_bytenr;
+		ret = btrfs_insert_empty_item(trans, log->log_root, path,
+					      &key, sizeof(*log_item));
+		if (ret)
+			goto out;
+
+		leaf = path->nodes[0];
+		log_item = btrfs_item_ptr(leaf, path->slots[0],
+					  struct btrfs_block_log_item);
+		btrfs_set_block_log_owner(leaf, log_item,
+					  entry->root->root_key.objectid);
+		btrfs_set_block_log_level(leaf, log_item, entry->level);
+		btrfs_set_block_log_flags(leaf, log_item, flags);
+		btrfs_set_block_log_key(leaf, log_item, &entry->key);
+		btrfs_mark_buffer_dirty(leaf);
+		goto out;
+	}
+
+	if (entry->op_type == UPDATE_LOG &&
+	    entry->bytenr == entry->orig_bytenr)
+		ins = 0;
+	else
+		ins = -1;
+
+	key.objectid = entry->orig_bytenr;
+	key.type = BTRFS_BLOCK_LOG_ITEM_KEY;
+	key.offset = (u64)-1;
+	ret = btrfs_search_slot(trans, log->log_root, &key, path, ins, 1);
+	if (ret < 0)
+		goto out;
+	BUG_ON(ret == 0);
+
+	leaf = path->nodes[0];
+	if (path->slots[0] > 0) {
+		btrfs_item_key_to_cpu(leaf, &key, path->slots[0] - 1);
+		if (key.objectid == entry->orig_bytenr &&
+		    key.type == BTRFS_BLOCK_LOG_ITEM_KEY) {
+			path->slots[0]--;
+			ret = 0;
+		}
+	}
+	if (ret > 0) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	log_item = btrfs_item_ptr(leaf, path->slots[0],
+				  struct btrfs_block_log_item);
+	WARN_ON(btrfs_block_log_level(leaf, log_item) != entry->level);
+	WARN_ON(btrfs_block_log_owner(leaf, log_item) !=
+		entry->root->root_key.objectid);
+	flags |= btrfs_block_log_flags(leaf, log_item);
+
+	if (entry->op_type == UPDATE_LOG &&
+	    entry->bytenr == entry->orig_bytenr) {
+		btrfs_set_block_log_flags(leaf, log_item, flags);
+		btrfs_set_block_log_key(leaf, log_item, &entry->key);
+		btrfs_mark_buffer_dirty(leaf);
+	} else {
+		ret = btrfs_del_item(trans, log->log_root, path);
+		btrfs_release_path(log->log_root, path);
+		BUG_ON(ret);
+
+		if (entry->op_type == DELETE_LOG) {
+			*to_delete = entry->orig_bytenr;
+			goto out;
+		}
+
+		key.objectid = entry->bytenr;
+		BUG_ON(key.objectid == key.offset);
+		ret = btrfs_insert_empty_item(trans, log->log_root, path,
+					      &key, sizeof(*log_item));
+		if (ret)
+			goto out;
+
+		leaf = path->nodes[0];
+		log_item = btrfs_item_ptr(leaf, path->slots[0],
+					  struct btrfs_block_log_item);
+		btrfs_set_block_log_owner(leaf, log_item,
+					  entry->root->root_key.objectid);
+		btrfs_set_block_log_level(leaf, log_item, entry->level);
+		btrfs_set_block_log_flags(leaf, log_item, flags);
+		btrfs_set_block_log_key(leaf, log_item, &entry->key);
+		btrfs_mark_buffer_dirty(leaf);
+
+		*to_delete = entry->orig_bytenr;
+	}
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
+static struct extent_buffer *find_tree_block(struct btrfs_root *root,
+					     u64 bytenr, u32 blocksize,
+					     u64 generation)
+{
+	struct extent_buffer *buf;
+	buf = btrfs_find_tree_block(root, bytenr, blocksize);
+	if (buf && !btrfs_buffer_uptodate(buf, generation)) {
+		free_extent_buffer(buf);
+		buf = NULL;
+	}
+	return buf;
+}
+/*
+ * helper flush in-memory log entries into extent log tree
+ */
+static int flush_extent_log_entries(struct btrfs_trans_handle *trans,
+				    struct btrfs_extent_log *extent_log,
+				    int flush_commit, int flush_all)
+{
+	struct rb_node *rb_node;
+	struct extent_log_struct *log;
+	struct extent_log_entry *entry = NULL;
+	struct extent_buffer *buf;
+	u64 search = 0;
+	u64 to_delete;
+	int ret;
+
+	if (flush_commit)
+		log = extent_log->commit_log;
+	else
+		log = extent_log->active_log;
+
+	if (!log)
+		return 0;
+
+	while (1) {
+		spin_lock(&log->lock);
+		if (search == 0)
+			rb_node = rb_first(&log->op_tree);
+		else
+			rb_node = op_tree_search(&log->op_tree, search);
+
+		while (rb_node) {
+			entry = rb_entry(rb_node, struct extent_log_entry,
+					 rb_node);
+			if (!entry->running) {
+				entry->running = 1;
+				break;
+			}
+			search = entry->bytenr;
+			rb_node = rb_next(rb_node);
+		}
+		spin_unlock(&log->lock);
+
+		if (!rb_node) {
+			if (flush_all && search > 0) {
+				search = 0;
+				schedule_timeout(1);
+				continue;
+			}
+			break;
+		}
+
+		to_delete = 0;
+		ret = flush_extent_log_entry(trans, log, entry, &to_delete);
+		BUG_ON(ret);
+
+		spin_lock(&log->lock);
+		rb_erase(&entry->rb_node, &log->op_tree);
+		spin_unlock(&log->lock);
+
+		if (to_delete > 0) {
+			BUG_ON(!entry->root || entry->generation == 0);
+			buf = find_tree_block(entry->root, to_delete,
+					      entry->blocksize,
+					      entry->generation);
+
+			btrfs_free_reserved_tree_block(trans, entry->root,
+							to_delete,
+							entry->blocksize, buf);
+			if (buf)
+				free_extent_buffer(buf);
+		}
+
+		free_extent_log_entry(entry);
+		cond_resched();
+	}
+	return 0;
+}
+
+/*
+ * helper insert root item of extent log tree into root tree.
+ * we can't do this in start_extent_log_trans(), because it may
+ * deadlock.
+ */
+static int insert_log_root(struct btrfs_trans_handle *trans,
+			   struct btrfs_fs_info *fs_info,
+			   struct extent_log_struct *log)
+{
+	if (!xchg(&log->root_inserted, 1)) {
+		int ret;
+		ret = btrfs_insert_root(trans, fs_info->tree_root,
+					&log->log_root->root_key,
+					&log->log_root->root_item);
+		BUG_ON(ret);
+		log->log_root->track_dirty = 1;
+	}
+	return 0;
+}
+
+int btrfs_flush_extent_log(struct btrfs_trans_handle *trans,
+			   struct btrfs_root *root, int flush_all)
+{
+	struct btrfs_extent_log *extent_log = root->fs_info->extent_log;
+
+	if (extent_log->active_log)
+		insert_log_root(trans, root->fs_info, extent_log->active_log);
+
+	flush_extent_log_entries(trans, extent_log, 0, 0);
+	flush_extent_log_entries(trans, extent_log, 1, 0);
+
+	if (flush_all) {
+		flush_extent_log_entries(trans, extent_log, 0, 1);
+		flush_extent_log_entries(trans, extent_log, 1, 1);
+	}
+	return 0;
+}
+
+int btrfs_prepare_extent_log_commit(struct btrfs_trans_handle *trans,
+				    struct btrfs_root *root)
+{
+	struct btrfs_extent_log *extent_log = root->fs_info->extent_log;
+
+	BUG_ON(extent_log->replaying);
+	BUG_ON(extent_log->commit_log);
+	if (extent_log->active_log) {
+		BUG_ON(!extent_log->active_log->root_inserted);
+		extent_log->commit_log = extent_log->active_log;
+		extent_log->commit_log->log_root->track_dirty = 0;
+		extent_log->active_log = NULL;
+	}
+	return 0;
+}
+
+/*
+ * called after a fs transaction is fully committed. this function
+ * marks the committed extent log ready for replaying.
+ */
+int btrfs_finish_extent_log_commit(struct btrfs_root *root)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_extent_log *extent_log = fs_info->extent_log;
+
+	if (!extent_log->commit_log)
+		return 0;
+
+	extent_log->replaying = 1;
+
+	spin_lock(&fs_info->new_trans_lock);
+	if (fs_info->running_transaction) {
+		fs_info->running_transaction->replay_log = 1;
+		wake_up_process(fs_info->transaction_kthread);
+	}
+	spin_unlock(&fs_info->new_trans_lock);
+
+	if (waitqueue_active(&extent_log->replay_wait))
+		wake_up(&extent_log->replay_wait);
+
+	return 0;
+}
+
+/*
+ * called after a new transaction is started.
+ */
+int btrfs_async_replay_extent_log(struct btrfs_root *root)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_extent_log *extent_log = fs_info->extent_log;
+
+	if (extent_log->commit_log && extent_log->replaying) {
+		fs_info->running_transaction->replay_log = 1;
+		wake_up_process(fs_info->transaction_kthread);
+	}
+	return 0;
+}
+
+static noinline_for_stack
+int replay_extent_log(struct btrfs_trans_handle *trans,
+		      struct btrfs_fs_info *fs_info,
+		      struct extent_log_struct *log)
+{
+	struct btrfs_path *path;
+	struct extent_buffer *buf;
+	struct btrfs_block_log_item *log_item;
+	struct btrfs_root *root = NULL;
+	struct rb_node *rb_node;
+	struct extent_log_entry *entry;
+	struct rb_root entries = RB_ROOT;
+	struct btrfs_key key;
+	u32 nritems;
+	int count = 0;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+	/*
+	 * search extent log tree and read log entries into memory
+	 */
+	key.objectid = 0;
+	key.type = 0;
+	key.offset = 0;
+	ret = btrfs_search_slot(trans, log->log_root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+	BUG_ON(ret == 0);
+
+	buf = path->nodes[0];
+	nritems = btrfs_header_nritems(buf);
+	if (nritems == 0) {
+		BUG_ON(btrfs_header_level(buf) > 0);
+		ret = 0;
+		goto out;
+	}
+
+	while (1) {
+		if (path->slots[0] >= nritems) {
+			if (count >= 128)
+				break;
+
+			ret = btrfs_next_leaf(log->log_root, path);
+			if (ret < 0)
+				goto out;
+			if (ret > 0)
+				break;
+			buf = path->nodes[0];
+			nritems = btrfs_header_nritems(buf);
+		}
+
+		entry = alloc_extent_log_entry();
+		if (!entry) {
+			if (count == 0) {
+				ret = -ENOMEM;
+				goto out;
+			}
+			break;
+		}
+
+		btrfs_item_key_to_cpu(buf, &key, path->slots[0]);
+		BUG_ON(key.type != BTRFS_BLOCK_LOG_ITEM_KEY);
+
+		log_item = btrfs_item_ptr(buf, path->slots[0],
+					  struct btrfs_block_log_item);
+		entry->bytenr = key.objectid;
+		entry->orig_bytenr = key.offset;
+		entry->owner = btrfs_block_log_owner(buf, log_item);
+		entry->level = btrfs_block_log_level(buf, log_item);
+		btrfs_block_log_key(buf, log_item, &entry->key);
+
+		rb_node = op_tree_insert(&entries, entry->bytenr,
+					 &entry->rb_node);
+		BUG_ON(rb_node);
+
+		count++;
+		path->slots[0]++;
+	}
+	btrfs_release_path(log->log_root, path);
+
+	/*
+	 * replay log entries by cowing corresponding log blocks.
+	 * btrfs_log_cow_block() will do the dirty work.
+	 */
+	while (!RB_EMPTY_ROOT(&entries)) {
+		rb_node = rb_first(&entries);
+		entry = rb_entry(rb_node, struct extent_log_entry,
+				 rb_node);
+
+		if (!root || root->root_key.objectid != entry->owner) {
+			key.objectid = entry->owner;
+			key.type = BTRFS_ROOT_ITEM_KEY;
+			key.offset = (u64)-1;
+			root = btrfs_read_fs_root_no_name(fs_info, &key);
+			BUG_ON(IS_ERR(root));
+
+			btrfs_record_root_in_trans(trans, root);
+		}
+
+		btrfs_disk_key_to_cpu(&key, &entry->key);
+		path->lowest_level = entry->level;
+
+		ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
+		BUG_ON(ret < 0);
+
+		buf = path->nodes[entry->level];
+		if (buf && buf->start == entry->bytenr) {
+			btrfs_set_header_flag(buf, BTRFS_HEADER_FLAG_WRITTEN);
+			btrfs_mark_buffer_dirty(buf);
+		} else {
+			rb_erase(&entry->rb_node, &entries);
+			free_extent_log_entry(entry);
+		}
+
+		btrfs_release_path(root, path);
+	}
+	ret = -EAGAIN;
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
+static void free_log_root(struct btrfs_root *log_root)
+{
+	free_extent_buffer(log_root->node);
+	free_extent_buffer(log_root->commit_root);
+	kfree(log_root);
+}
+
+static int delete_log_root(struct btrfs_trans_handle *trans,
+			   struct btrfs_fs_info *fs_info,
+			   struct extent_log_struct *log)
+{
+	struct btrfs_root *log_root;
+	int ret;
+
+	log_root = log->log_root;
+	log->log_root = NULL;
+
+	BUG_ON(btrfs_header_nritems(log_root->node) > 0);
+
+	btrfs_set_root_refs(&log_root->root_item, 0);
+	ret = btrfs_update_root(trans, fs_info->tree_root,
+				&log_root->root_key, &log_root->root_item);
+	BUG_ON(ret);
+
+	ret = btrfs_del_root(trans, fs_info->tree_root, &log_root->root_key);
+	BUG_ON(ret);
+	log->root_inserted = 0;
+
+	btrfs_tree_lock(log_root->node);
+	btrfs_set_lock_blocking(log_root->node);
+	clean_tree_block(trans, log_root, log_root->node);
+	btrfs_tree_unlock(log_root->node);
+
+	btrfs_free_reserved_tree_block(trans, log_root, 0, 0, log_root->node);
+
+	free_log_root(log_root);
+	return 0;
+}
+
+static void wait_for_replay(struct btrfs_extent_log *extent_log)
+{
+	DEFINE_WAIT(wait);
+	while (extent_log->commit_log && !extent_log->replaying) {
+		prepare_to_wait(&extent_log->replay_wait,
+				&wait, TASK_UNINTERRUPTIBLE);
+		smp_mb();
+		if (extent_log->commit_log && !extent_log->replaying)
+			schedule();
+		finish_wait(&extent_log->replay_wait, &wait);
+	}
+}
+
+/*
+ * function to replay extent log
+ */
+int btrfs_replay_extent_log(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root, int replay_all)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_extent_log *extent_log = fs_info->extent_log;
+	int loops = 0;
+	int complete = 0;
+	int ret;
+
+	if (!extent_log->commit_log)
+		return 0;
+
+	if (!extent_log->replaying) {
+		if (!replay_all)
+			return 0;
+		wait_for_replay(extent_log);
+	}
+
+	down_read(&extent_log->replay_sem);
+	if (extent_log->commit_log)
+		flush_extent_log_entries(trans, extent_log, 1, 1);
+
+	while (1) {
+		if (!extent_log->commit_log)
+			break;
+
+		BUG_ON(!extent_log->replaying);
+		ret = replay_extent_log(trans, fs_info,
+					extent_log->commit_log);
+		if (ret != -EAGAIN) {
+			BUG_ON(ret);
+			complete = 1;
+			break;
+		}
+
+		flush_extent_log_entries(trans, extent_log, 1, 1);
+
+		if (++loops >= 16 && !replay_all)
+			break;
+	}
+	up_read(&extent_log->replay_sem);
+
+	if (!extent_log->commit_log || !complete)
+		return 0;
+
+	down_write(&extent_log->replay_sem);
+	if (extent_log->commit_log) {
+		BUG_ON(!RB_EMPTY_ROOT(&extent_log->commit_log->op_tree));
+		BUG_ON(atomic_read(&extent_log->commit_log->num_entries));
+		trans->transaction->replay_log = 0;
+
+		delete_log_root(trans, fs_info, extent_log->commit_log);
+		extent_log->commit_log = NULL;
+		extent_log->replaying = 0;
+		extent_log->recovering = 0;
+		extent_log->last_replayed = fs_info->last_trans_committed;
+	}
+	up_write(&extent_log->replay_sem);
+
+	return 0;
+}
+
+static noinline_for_stack
+int start_extent_log_trans(struct btrfs_trans_handle *trans,
+			   struct btrfs_root *root,
+			   struct btrfs_extent_log *extent_log)
+{
+	int err = 0;
+
+	if (extent_log->log_mode == LOG_NONE ||
+	    extent_log->disabled || root->no_logs)
+		return -EAGAIN;
+
+	if (extent_log->log_mode == LOG_COWONLY && root->ref_cows)
+		return -EAGAIN;
+
+	if (root->last_log_trans == trans->transid)
+		return 0;
+
+	mutex_lock(&extent_log->log_mutex);
+	if (root->no_logs || extent_log->disabled) {
+		err = -EAGAIN;
+		goto out_unlock;
+	}
+
+	if (!extent_log->active_log) {
+		int index;
+		struct btrfs_root *log_root;
+
+		index = (extent_log->log_index + 1) & 0x1;
+		BUG_ON(extent_log->logs[index].log_root);
+		BUG_ON(extent_log->logs[index].root_inserted);
+		BUG_ON(atomic_read(&extent_log->logs[index].num_entries));
+		BUG_ON(!RB_EMPTY_ROOT(&extent_log->logs[index].op_tree));
+
+		log_root = btrfs_alloc_extent_log_tree(trans, root->fs_info);
+		if (IS_ERR(log_root)) {
+			err = PTR_ERR(log_root);
+			goto out_unlock;
+		}
+
+		log_root->root_key.offset = index;
+		btrfs_set_root_refs(&log_root->root_item, 1);
+		btrfs_set_root_node(&log_root->root_item, log_root->node);
+
+		extent_log->log_index = index;
+		extent_log->logs[index].log_root = log_root;
+		extent_log->logs[index].root_inserted = 0;
+		extent_log->active_log = &extent_log->logs[index];
+		extent_log->last_trans = trans->transid;
+	}
+	smp_mb();
+	root->last_log_trans = trans->transid;
+out_unlock:
+	mutex_unlock(&extent_log->log_mutex);
+	return err;
+}
+
+static int copy_tree_block(struct btrfs_trans_handle *trans,
+			   struct btrfs_root *root,
+			   struct extent_buffer *buf,
+			   struct extent_buffer *cow, u64 flags)
+{
+	copy_extent_buffer(cow, buf, 0, 0, cow->len);
+	btrfs_set_header_bytenr(cow, cow->start);
+	btrfs_set_header_generation(cow, trans->transid);
+	btrfs_set_header_backref_rev(cow, BTRFS_MIXED_BACKREF_REV);
+	btrfs_clear_header_flag(cow, BTRFS_HEADER_FLAG_WRITTEN |
+				     BTRFS_HEADER_FLAG_RELOC |
+				     BTRFS_HEADER_FLAG_LOGS);
+	btrfs_set_header_owner(cow, root->root_key.objectid);
+	btrfs_set_header_flag(cow, flags);
+
+	write_extent_buffer(cow, root->fs_info->fsid,
+			    (unsigned long)btrfs_header_fsid(cow),
+			    BTRFS_FSID_SIZE);
+	return 0;
+}
+
+/*
+ * called when a block needs cow. this function decides if logged cow
+ * should be used and does the dirty work.
+ */
+int btrfs_log_cow_block(struct btrfs_trans_handle *trans,
+			struct btrfs_root *root,
+			struct extent_buffer *buf,
+			struct extent_buffer **cow_ret,
+			u64 hint, u64 empty_size)
+{
+	struct btrfs_extent_log *extent_log = root->fs_info->extent_log;
+	struct btrfs_root *log_root;
+	struct extent_log_entry *entry;
+	struct extent_buffer *cow;
+	struct btrfs_disk_key disk_key;
+	u64 flags;
+	u64 generation;
+	u64 to_delete = 0;
+	u32 blocksize = buf->len;
+	int level;
+	int index;
+	int ret;
+
+	BUG_ON(root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID ||
+	       root->root_key.objectid == BTRFS_EXTENT_LOG_OBJECTID ||
+	       root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID);
+	BUG_ON(root->root_key.objectid != btrfs_header_owner(buf));
+
+	flags = btrfs_header_flags(buf);
+	if (!(flags & BTRFS_HEADER_FLAG_LOGS)) {
+
+
+		if (btrfs_extent_readonly(root, buf->start))
+			return -EAGAIN;
+		/*
+		 * the block is not log block, start a new log
+		 * transaction if required.
+		 */
+		ret = start_extent_log_trans(trans, root, extent_log);
+		if (ret)
+			return ret;
+	}
+
+	entry = alloc_extent_log_entry();
+	if (!entry)
+		return -ENOMEM;
+
+	clean_tree_block(trans, root, buf);
+
+	level = btrfs_header_level(buf);
+	generation = btrfs_header_generation(buf);
+
+	if (btrfs_header_nritems(buf) > 0) {
+		if (level == 0)
+			btrfs_item_key(buf, &disk_key, 0);
+		else
+			btrfs_node_key(buf, &disk_key, 0);
+	} else
+		memset(&disk_key, 0, sizeof(disk_key));
+
+	if (!(flags & BTRFS_HEADER_FLAG_LOGS)) {
+		/*
+		 * the block is not log block. cow it by using
+		 * a log block.
+		 */
+		log_root = extent_log->active_log->log_root;
+		cow = btrfs_reserve_tree_block(trans, root,
+						blocksize, level,
+						hint, empty_size);
+		if (IS_ERR(cow)) {
+			ret = PTR_ERR(cow);
+			goto err;
+		}
+
+		if (extent_log->active_log == &extent_log->logs[0])
+			flags = BTRFS_HEADER_FLAG_LOG0;
+		else
+			flags = BTRFS_HEADER_FLAG_LOG1;
+
+		copy_tree_block(trans, root, buf, cow, flags);
+		/*
+		 * insert log entry that maps the log block to the original
+		 * block
+		 */
+		setup_extent_log_entry(entry, cow->start, buf->start,
+					blocksize, generation, &disk_key,
+					level, root, INSERT_LOG);
+		insert_extent_log_entry(extent_log->active_log, entry, NULL);
+
+		*cow_ret = cow;
+		return 0;
+	}
+
+	BUG_ON((flags & BTRFS_HEADER_FLAG_LOG0) &&
+	       (flags & BTRFS_HEADER_FLAG_LOG1));
+	flags &= BTRFS_HEADER_FLAG_LOGS;
+
+	if (flags & BTRFS_HEADER_FLAG_LOG0)
+		index = 0;
+	else
+		index = 1;
+
+	smp_mb();
+	if (!extent_log->replaying ||
+	    extent_log->active_log == &extent_log->logs[index]) {
+		/*
+		 * the block belongs log transaction that is not
+		 * fully committed. cow it by using a new log block.
+		 */
+		log_root = extent_log->logs[index].log_root;
+		cow = btrfs_reserve_tree_block(trans, root,
+						blocksize, level,
+						hint, empty_size);
+		if (IS_ERR(cow)) {
+			ret = PTR_ERR(cow);
+			goto err;
+		}
+
+		copy_tree_block(trans, root, buf, cow, flags);
+
+		/* update log entry and free the old log block */
+		setup_extent_log_entry(entry, cow->start, buf->start,
+					blocksize, generation, &disk_key,
+					level, root, UPDATE_LOG);
+		insert_extent_log_entry(&extent_log->logs[index], entry,
+					&to_delete);
+		if (to_delete > 0) {
+			BUG_ON(buf->start != to_delete);
+			btrfs_free_reserved_tree_block(trans, root, 0, 0, buf);
+		}
+
+		*cow_ret = cow;
+		return 0;
+	}
+
+	/*
+	 * the block belongs log transaction that is fully committed.
+	 * copy the log block to the original block.
+	 */
+	BUG_ON(extent_log->commit_log != &extent_log->logs[index]);
+	log_root = extent_log->commit_log->log_root;
+
+	setup_extent_log_entry(entry, buf->start, buf->start, blocksize,
+			       0, NULL, level, root, 0);
+
+	/* lookup the original block */
+	ret = lookup_extent_log_entry(extent_log->commit_log, entry);
+	BUG_ON(ret);
+	BUG_ON(entry->bytenr == entry->orig_bytenr);
+
+	if (btrfs_extent_readonly(root, entry->orig_bytenr)) {
+		cow = btrfs_alloc_free_block(trans, root, blocksize,
+					0, root->root_key.objectid,
+					&disk_key, level, hint, empty_size);
+		to_delete = entry->orig_bytenr;
+	} else {
+		cow = btrfs_init_new_buffer(trans, root, entry->orig_bytenr,
+					blocksize, level);
+	}
+	if (IS_ERR(cow)) {
+		ret = PTR_ERR(cow);
+		goto err;
+	}
+
+	copy_tree_block(trans, root, buf, cow, 0);
+
+	if (to_delete > 0) {
+		btrfs_free_logged_tree_block(trans, root, to_delete,
+					     blocksize, level);
+	} else {
+		ret = btrfs_update_tree_block_info(trans, root, cow,
+						   &disk_key, 0, 1);
+		BUG_ON(ret);
+	}
+
+	/* delete log entry and free the log block */
+	setup_extent_log_entry(entry, buf->start, buf->start, blocksize,
+			       generation, NULL, level, root, DELETE_LOG);
+
+	to_delete = 0;
+	insert_extent_log_entry(extent_log->commit_log, entry, &to_delete);
+	if (to_delete > 0) {
+		BUG_ON(buf->start != to_delete);
+		btrfs_free_reserved_tree_block(trans, root, 0, 0, buf);
+	}
+
+	*cow_ret = cow;
+	return 0;
+err:
+	free_extent_log_entry(entry);
+	return ret;
+}
+
+/*
+ * called when changing tree block's key. this function checks if the
+ * block is a log block and update key field in corresponding log entry.
+ */
+int btrfs_log_update_block_key(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root,
+				struct extent_buffer *buf,
+				struct btrfs_disk_key *disk_key)
+{
+	struct btrfs_extent_log *extent_log = root->fs_info->extent_log;
+	struct extent_log_entry *entry;
+	int index;
+	u64 flags;
+
+	flags = btrfs_header_flags(buf);
+	if (!(flags & BTRFS_HEADER_FLAG_LOGS))
+		return -EAGAIN;
+
+	BUG_ON(root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID ||
+	       root->root_key.objectid == BTRFS_EXTENT_LOG_OBJECTID ||
+	       root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID);
+	BUG_ON(root->root_key.objectid != btrfs_header_owner(buf));
+	BUG_ON((flags & BTRFS_HEADER_FLAG_LOG0) &&
+	       (flags & BTRFS_HEADER_FLAG_LOG1));
+
+	entry = alloc_extent_log_entry();
+	BUG_ON(!entry);
+
+	if (flags & BTRFS_HEADER_FLAG_LOG0)
+		index = 0;
+	else
+		index = 1;
+
+	setup_extent_log_entry(entry, buf->start, buf->start, buf->len,
+			       trans->transid, disk_key,
+			       btrfs_header_level(buf), root, UPDATE_LOG);
+	entry->key_change = 1;
+
+	insert_extent_log_entry(&extent_log->logs[index], entry, NULL);
+	return 0;
+}
+
+/*
+ * called when freeing a tree block. this function checks if the
+ * block is a log block, frees it and returns location of the
+ * original block.
+ */
+void btrfs_log_free_tree_block(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *root,
+			       struct extent_buffer *buf, u64 *orig_bytenr,
+			       struct extent_buffer **orig_buf)
+{
+	struct btrfs_extent_log *extent_log = root->fs_info->extent_log;
+	struct extent_log_entry *entry;
+	int index;
+	int level;
+	int ret;
+	u64 flags;
+	u64 to_delete = 0;
+
+	flags = btrfs_header_flags(buf);
+	if (!(flags & BTRFS_HEADER_FLAG_LOGS)) {
+		*orig_bytenr = buf->start;
+		*orig_buf = buf;
+		return;
+	}
+
+	BUG_ON(root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID ||
+	       root->root_key.objectid == BTRFS_EXTENT_LOG_OBJECTID ||
+	       root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID);
+	BUG_ON(root->root_key.objectid != btrfs_header_owner(buf));
+	BUG_ON((flags & BTRFS_HEADER_FLAG_LOG0) &&
+	       (flags & BTRFS_HEADER_FLAG_LOG1));
+
+	entry = alloc_extent_log_entry();
+	BUG_ON(!entry);
+
+	/* lookup the original block */
+	if (flags & BTRFS_HEADER_FLAG_LOG0)
+		index = 0;
+	else
+		index = 1;
+
+	level = btrfs_header_level(buf);
+	setup_extent_log_entry(entry, buf->start, buf->start, buf->len,
+			       0, NULL, level, root, 0);
+
+	/* lookup the original block */
+	ret = lookup_extent_log_entry(&extent_log->logs[index], entry);
+	BUG_ON(ret);
+
+	BUG_ON(entry->bytenr == entry->orig_bytenr);
+	*orig_bytenr = entry->orig_bytenr;
+	if (entry->generation > 0)
+		*orig_buf = find_tree_block(root, entry->orig_bytenr,
+					    entry->blocksize,
+					    entry->generation);
+	else
+		*orig_buf = NULL;
+
+	/* free the log block */
+	setup_extent_log_entry(entry, buf->start, buf->start, buf->len,
+			       trans->transid, NULL, level, root, DELETE_LOG);
+
+	insert_extent_log_entry(&extent_log->logs[index], entry,
+				&to_delete);
+	if (to_delete > 0) {
+		BUG_ON(buf->start != to_delete);
+		btrfs_free_reserved_tree_block(trans, root, 0, 0, buf);
+	}
+}
+
+/*
+ * hepler to process tree blocks in extent log tree.
+ */
+static int process_one_buffer(struct btrfs_root *root,
+			      struct extent_buffer *buf, void *data)
+{
+	struct btrfs_extent_log *extent_log = data;
+	struct btrfs_block_log_item *log_item;
+	struct btrfs_key key;
+	int level;
+	int slot;
+	int ret;
+	int reserve;
+	u32 nritems;
+	u32 blocksize;
+
+	BUG_ON(!extent_log->commit_log);
+
+	reserve = !extent_log->recovering;
+	if (reserve) {
+		/*
+		 * update accounting and prevent allocator from using
+		 * the block
+		 */
+		ret = btrfs_reserve_log_tree_block(root, buf->start,
+						   buf->len);
+		BUG_ON(ret);
+	} else {
+		btrfs_free_reserved_extent(root, buf->start, buf->len);
+	}
+
+	level = btrfs_header_level(buf);
+	if (level > 0)
+		return 0;
+
+	nritems = btrfs_header_nritems(buf);
+	for (slot = 0; slot < nritems; slot++) {
+		btrfs_item_key_to_cpu(buf, &key, slot);
+		if (key.type != BTRFS_BLOCK_LOG_ITEM_KEY) {
+			WARN_ON(1);
+			continue;
+		}
+
+		log_item = btrfs_item_ptr(buf, slot,
+					  struct btrfs_block_log_item);
+		level = btrfs_block_log_level(buf, log_item);
+		blocksize = btrfs_level_size(root, level);
+
+		if (reserve) {
+			ret = btrfs_reserve_log_tree_block(root,
+							   key.objectid,
+							   blocksize);
+			BUG_ON(ret);
+			atomic_inc(&extent_log->commit_log->num_entries);
+		} else {
+			btrfs_free_reserved_extent(root, key.objectid,
+						   blocksize);
+			atomic_dec(&extent_log->commit_log->num_entries);
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * called during mount to recover extent log
+ */
+int btrfs_recover_extent_log(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_extent_log *extent_log = fs_info->extent_log;
+	struct btrfs_root *log_root;
+	struct btrfs_key key;
+	int index;
+	int ret;
+
+	extent_log->last_replayed = fs_info->last_trans_committed;
+
+	key.objectid = BTRFS_EXTENT_LOG_OBJECTID;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = (u64)-1;
+
+	log_root = btrfs_read_fs_root_no_radix(fs_info->tree_root, &key);
+	if (IS_ERR(log_root)) {
+		ret = PTR_ERR(log_root);
+		if (ret == -ENOENT)
+			ret = 0;
+		return ret;
+	}
+	log_root->ref_cows = 0;
+
+	/* prepare extent log structure for replaying the log */
+	BUG_ON(log_root->root_key.offset > 1);
+
+	index = log_root->root_key.offset;
+	extent_log->log_index = index;
+	extent_log->logs[index].log_root = log_root;
+	extent_log->logs[index].root_inserted = 1;
+	extent_log->commit_log = &extent_log->logs[index];
+
+	extent_log->last_trans = fs_info->last_trans_committed;
+	extent_log->last_replayed = extent_log->last_trans - 1;
+
+	/* walk the log tree to record log blocks */
+	ret = btrfs_walk_log_tree(log_root, extent_log, process_one_buffer);
+	BUG_ON(ret);
+
+	extent_log->replaying = 1;
+	extent_log->recovering = 1;
+	/* extent log will be replayed when new transaction starts */
+	return 0;
+}
+
+void btrfs_cleanup_extent_log(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_extent_log *extent_log;
+	struct btrfs_root *log_root;
+	int ret;
+
+	extent_log = fs_info->extent_log;
+	fs_info->extent_log = NULL;
+
+	if (!extent_log)
+		return;
+
+	if (extent_log->recovering) {
+		/*
+		 * the fs was mounted in read only mode,
+		 * undo what btrfs_recover_extent_log() did.
+		 */
+		log_root = extent_log->commit_log->log_root;
+		ret = btrfs_walk_log_tree(log_root, extent_log,
+					  process_one_buffer);
+		BUG_ON(ret);
+		free_log_root(log_root);
+		extent_log->commit_log->log_root = NULL;
+		extent_log->commit_log = NULL;
+	}
+
+	WARN_ON(extent_log->active_log || extent_log->commit_log);
+	WARN_ON(atomic_read(&extent_log->logs[0].num_entries) > 0 ||
+		atomic_read(&extent_log->logs[1].num_entries) > 0);
+	WARN_ON(extent_log->logs[0].log_root ||
+		extent_log->logs[1].log_root);
+	WARN_ON(!RB_EMPTY_ROOT(&extent_log->logs[0].op_tree) ||
+		!RB_EMPTY_ROOT(&extent_log->logs[1].op_tree));
+
+	kfree(extent_log);
+}
+
+int btrfs_enable_extent_log(struct btrfs_root *root, int global)
+{
+	struct btrfs_extent_log *extent_log = root->fs_info->extent_log;
+
+	mutex_lock(&extent_log->log_mutex);
+	if (global) {
+		BUG_ON(extent_log->disabled <= 0);
+		extent_log->disabled--;
+	} else {
+		BUG_ON(root->no_logs <= 0);
+		root->no_logs--;
+	}
+	mutex_unlock(&extent_log->log_mutex);
+	return 0;
+}
+
+int btrfs_disable_extent_log(struct btrfs_root *root, int global)
+{
+	struct btrfs_extent_log *extent_log = root->fs_info->extent_log;
+
+	mutex_lock(&extent_log->log_mutex);
+	if (global)
+		extent_log->disabled++;
+	else
+		root->no_logs++;
+	mutex_unlock(&extent_log->log_mutex);
+	return 0;
+}
+
+/*
+ * disable log and wait until all logs are replayed
+ */
+int btrfs_disable_extent_log_sync(struct btrfs_root *root, int global)
+{
+	struct btrfs_extent_log *extent_log = root->fs_info->extent_log;
+	struct btrfs_trans_handle *trans;
+	u64 last_trans;
+	int ret;
+
+	mutex_lock(&extent_log->log_mutex);
+	if (global) {
+		extent_log->disabled++;
+		last_trans = extent_log->last_trans;
+	} else {
+		root->no_logs++;
+		last_trans = root->last_log_trans;
+	}
+	mutex_unlock(&extent_log->log_mutex);
+
+	trans = btrfs_join_transaction(root, 0);
+	BUG_ON(IS_ERR(trans));
+
+	if (last_trans >= trans->transid || extent_log->recovering) {
+		ret = btrfs_commit_transaction(trans, root);
+		BUG_ON(ret);
+	} else {
+		btrfs_end_transaction(trans, root);
+	}
+
+	while (1) {
+		down_write(&extent_log->replay_sem);
+		if (last_trans > extent_log->last_replayed ||
+		    extent_log->recovering)
+			ret = 0;
+		else
+			ret = 1;
+		up_write(&extent_log->replay_sem);
+		if (ret)
+			break;
+
+		trans = btrfs_join_transaction(root, 0);
+		BUG_ON(IS_ERR(trans));
+
+		ret = btrfs_replay_extent_log(trans, root, 1);
+		BUG_ON(ret);
+
+		btrfs_end_transaction(trans, root);
+	}
+
+	return 0;
+}
+
+int btrfs_set_extent_log_mode(struct btrfs_fs_info *fs_info, int mode)
+{
+	struct btrfs_extent_log *extent_log = fs_info->extent_log;
+
+	if (mode < LOG_NONE || mode > LOG_ALL) {
+		printk(KERN_INFO "btrfs: invalid extent log mode %d\n", mode);
+		return -EINVAL;
+	}
+
+	extent_log->log_mode = mode;
+	printk(KERN_INFO "btrfs: extent log mode %d\n", mode);
+	return 0;
+}
diff -urpN 5/fs/btrfs/extent-tree.c 6/fs/btrfs/extent-tree.c
--- 5/fs/btrfs/extent-tree.c	2010-05-11 14:19:12.501357982 +0800
+++ 6/fs/btrfs/extent-tree.c	2010-05-11 14:23:58.024107372 +0800
@@ -184,6 +184,17 @@ static int add_excluded_extent(struct bt
 	return 0;
 }
 
+static int remove_excluded_extent(struct btrfs_root *root,
+				  u64 start, u64 num_bytes)
+{
+	u64 end = start + num_bytes - 1;
+	clear_extent_bits(&root->fs_info->freed_extents[0],
+			  start, end, EXTENT_UPTODATE, GFP_NOFS);
+	clear_extent_bits(&root->fs_info->freed_extents[1],
+			  start, end, EXTENT_UPTODATE, GFP_NOFS);
+	return 0;
+}
+
 static void free_excluded_extents(struct btrfs_root *root,
 				  struct btrfs_block_group_cache *cache)
 {
@@ -2058,6 +2069,8 @@ static noinline int run_clustered_refs(s
 		kfree(extent_op);
 		count++;
 
+		btrfs_flush_extent_log(trans, root, 0);
+
 		cond_resched();
 		spin_lock(&delayed_refs->lock);
 	}
@@ -2160,9 +2173,14 @@ int btrfs_update_tree_block_key(struct b
 	struct btrfs_delayed_extent_op *extent_op;
 	int ret;
 
-	if (root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID)
+	if (root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID ||
+	    root->root_key.objectid == BTRFS_EXTENT_LOG_OBJECTID)
 		return 0;
 
+	ret = btrfs_log_update_block_key(trans, root, eb, key);
+	if (!ret || ret != -EAGAIN)
+		return ret;
+
 	extent_op = kzalloc(sizeof(*extent_op), GFP_NOFS);
 	if (!extent_op)
 		return -ENOMEM;
@@ -2185,6 +2203,8 @@ int btrfs_update_tree_block_info(struct 
 	struct btrfs_delayed_extent_op *extent_op;
 	int ret;
 
+	BUG_ON(btrfs_header_flags(eb) & BTRFS_HEADER_FLAG_LOGS);
+
 	extent_op = kzalloc(sizeof(*extent_op), GFP_NOFS);
 	if (!extent_op)
 		return -ENOMEM;
@@ -2514,6 +2534,8 @@ static int __btrfs_mod_ref(struct btrfs_
 	int (*process_func)(struct btrfs_trans_handle *, struct btrfs_root *,
 			    u64, u64, u64, u64, u64, u64);
 
+	BUG_ON(btrfs_header_flags(buf) & BTRFS_HEADER_FLAG_LOGS);
+
 	ref_root = btrfs_header_owner(buf);
 	nritems = btrfs_header_nritems(buf);
 	level = btrfs_header_level(buf);
@@ -3595,10 +3617,13 @@ int btrfs_pin_extent(struct btrfs_root *
 	spin_unlock(&cache->lock);
 	spin_unlock(&cache->space_info->lock);
 
-	btrfs_put_block_group(cache);
-
 	set_extent_dirty(fs_info->pinned_extents,
 			 bytenr, bytenr + num_bytes - 1, GFP_NOFS);
+
+	if (!block_group_cache_done(cache))
+		remove_excluded_extent(root, bytenr, num_bytes);
+
+	btrfs_put_block_group(cache);
 	return 0;
 }
 
@@ -3647,6 +3672,9 @@ int btrfs_prepare_extent_commit(struct b
 		fs_info->pinned_extents = &fs_info->freed_extents[0];
 
 	up_write(&fs_info->extent_commit_sem);
+
+	btrfs_prepare_extent_log_commit(trans, root);
+
 	return 0;
 }
 
@@ -3715,6 +3743,8 @@ int btrfs_finish_extent_commit(struct bt
 		cond_resched();
 	}
 
+	btrfs_finish_extent_log_commit(root);
+
 	return ret;
 }
 
@@ -4073,7 +4103,8 @@ int btrfs_free_extent(struct btrfs_trans
 	 * tree log blocks never actually go into the extent allocation
 	 * tree, just update pinning info and exit early.
 	 */
-	if (root_objectid == BTRFS_TREE_LOG_OBJECTID) {
+	if (root_objectid == BTRFS_TREE_LOG_OBJECTID ||
+	    root_objectid == BTRFS_EXTENT_LOG_OBJECTID) {
 		WARN_ON(owner >= BTRFS_FIRST_FREE_OBJECTID);
 		/* unlocks the pinned mutex */
 		btrfs_pin_extent(root, bytenr, num_bytes, 1);
@@ -4105,7 +4136,8 @@ void btrfs_free_tree_block(struct btrfs_
 	int level;
 	int ret;
 
-	if (root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID) {
+	if (root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID ||
+	    root->root_key.objectid == BTRFS_EXTENT_LOG_OBJECTID) {
 		BUG_ON(!last_ref);
 		btrfs_free_reserved_tree_block(trans, root,
 					       bytenr, blocksize, buf);
@@ -4113,6 +4145,8 @@ void btrfs_free_tree_block(struct btrfs_
 	}
 
 	level = btrfs_header_level(buf);
+	btrfs_log_free_tree_block(trans, root, buf, &bytenr, &orig_buf);
+
 	ret = btrfs_free_extent(trans, root, bytenr, blocksize, parent,
 				root->root_key.objectid, level, 0);
 	BUG_ON(ret);
@@ -4121,6 +4155,18 @@ void btrfs_free_tree_block(struct btrfs_
 		free_extent_buffer(orig_buf);
 }
 
+void btrfs_free_logged_tree_block(struct btrfs_trans_handle *trans,
+				  struct btrfs_root *root,
+				  u64 bytenr, u32 blocksize, int level)
+{
+	int ret;
+
+	ret = btrfs_add_delayed_tree_ref(trans, bytenr, blocksize, 0,
+					 root->root_key.objectid, level,
+					 BTRFS_DROP_DELAYED_REF, NULL);
+	BUG_ON(ret);
+}
+
 void btrfs_free_reserved_tree_block(struct btrfs_trans_handle *trans,
 				    struct btrfs_root *root,
 				    u64 bytenr, u32 blocksize,
@@ -4893,6 +4939,25 @@ int btrfs_alloc_reserved_file_extent(str
 	return ret;
 }
 
+int btrfs_reserve_log_tree_block(struct btrfs_root *root,
+				 u64 bytenr, u32 blocksize)
+{
+	struct btrfs_block_group_cache *block_group;
+	int ret;
+
+	block_group = btrfs_lookup_block_group(root->fs_info, bytenr);
+	BUG_ON(!block_group);
+
+	ret = add_excluded_extent(root, bytenr, blocksize);
+	BUG_ON(ret);
+
+	ret = update_reserved_extents(block_group, blocksize, 1);
+	BUG_ON(ret);
+	btrfs_put_block_group(block_group);
+
+	return 0;
+}
+
 /*
  * this is used by the tree logging recovery code.  It records that
  * an extent has been allocated and makes sure to clear the free
@@ -5020,7 +5085,8 @@ int btrfs_alloc_reserved_tree_block(stru
 	struct btrfs_delayed_extent_op *extent_op;
 	int ret;
 
-	if (root_objectid == BTRFS_TREE_LOG_OBJECTID)
+	if (root_objectid == BTRFS_TREE_LOG_OBJECTID ||
+	    root_objectid == BTRFS_EXTENT_LOG_OBJECTID)
 		return 0;
 
 	if (root_objectid == BTRFS_TREE_RELOC_OBJECTID) {
@@ -5190,6 +5256,8 @@ static noinline int walk_down_proc(struc
 	u64 flag = BTRFS_BLOCK_FLAG_FULL_BACKREF;
 	int ret;
 
+	BUG_ON(btrfs_header_flags(eb) & BTRFS_HEADER_FLAG_LOGS);
+
 	if (wc->stage == UPDATE_BACKREF &&
 	    btrfs_header_owner(eb) != root->root_key.objectid)
 		return 1;
diff -urpN 5/fs/btrfs/ioctl.c 6/fs/btrfs/ioctl.c
--- 5/fs/btrfs/ioctl.c	2010-04-14 14:49:57.578939000 +0800
+++ 6/fs/btrfs/ioctl.c	2010-05-11 10:08:02.043108000 +0800
@@ -313,6 +313,7 @@ static noinline int create_subvol(struct
 	new_root = btrfs_read_fs_root_no_name(root->fs_info, &key);
 	BUG_ON(IS_ERR(new_root));
 
+	new_root->last_log_trans = 0;
 	btrfs_record_root_in_trans(trans, new_root);
 
 	ret = btrfs_create_subvol_root(trans, new_root, new_dirid,
@@ -360,6 +361,8 @@ static int create_snapshot(struct btrfs_
 	if (!root->ref_cows)
 		return -EINVAL;
 
+	btrfs_disable_extent_log_sync(root, 0);
+
 	/*
 	 * 1 - inode item
 	 * 2 - refs
@@ -401,9 +404,11 @@ static int create_snapshot(struct btrfs_
 		goto fail;
 	}
 	BUG_ON(!inode);
+	BTRFS_I(inode)->root->last_log_trans = 0;
 	d_instantiate(dentry, inode);
 	ret = 0;
 fail:
+	btrfs_enable_extent_log(root, 0);
 	return ret;
 }
 
@@ -1321,6 +1326,8 @@ static noinline int btrfs_ioctl_snap_des
 	ret = btrfs_commit_transaction(trans, root);
 	BUG_ON(ret);
 	inode->i_flags |= S_DEAD;
+
+	btrfs_disable_extent_log_sync(dest, 0);
 out_up_write:
 	up_write(&root->fs_info->subvol_sem);
 out_unlock:
diff -urpN 5/fs/btrfs/Makefile 6/fs/btrfs/Makefile
--- 5/fs/btrfs/Makefile	2010-04-13 15:41:51.337812000 +0800
+++ 6/fs/btrfs/Makefile	2010-05-11 14:27:27.032122327 +0800
@@ -7,4 +7,4 @@ btrfs-y += super.o ctree.o extent-tree.o
 	   extent_map.o sysfs.o struct-funcs.o xattr.o ordered-data.o \
 	   extent_io.o volumes.o async-thread.o ioctl.o locking.o orphan.o \
 	   export.o tree-log.o acl.o free-space-cache.o zlib.o \
-	   compression.o delayed-ref.o relocation.o
+	   compression.o delayed-ref.o relocation.o extent-log.o
diff -urpN 5/fs/btrfs/relocation.c 6/fs/btrfs/relocation.c
--- 5/fs/btrfs/relocation.c	2010-04-14 14:49:58.099940000 +0800
+++ 6/fs/btrfs/relocation.c	2010-05-11 09:58:23.180136000 +0800
@@ -3293,6 +3293,8 @@ static noinline_for_stack int relocate_b
 	clear_extent_bits(&rc->processed_blocks, 0, (u64)-1, EXTENT_DIRTY,
 			  GFP_NOFS);
 
+	btrfs_disable_extent_log_sync(rc->extent_root, 1);
+
 	rc->create_reloc_root = 1;
 	set_reloc_control(rc);
 
@@ -3418,6 +3420,8 @@ static noinline_for_stack int relocate_b
 
 	unset_reloc_control(rc);
 
+	btrfs_enable_extent_log(rc->extent_root, 1);
+
 	/* get rid of pinned extents */
 	trans = btrfs_start_transaction(rc->extent_root, 1);
 	btrfs_commit_transaction(trans, rc->extent_root);
diff -urpN 5/fs/btrfs/super.c 6/fs/btrfs/super.c
--- 5/fs/btrfs/super.c	2010-04-14 14:49:58.178936000 +0800
+++ 6/fs/btrfs/super.c	2010-05-11 10:00:07.235359000 +0800
@@ -67,7 +67,7 @@ enum {
 	Opt_nodatacow, Opt_max_inline, Opt_alloc_start, Opt_nobarrier, Opt_ssd,
 	Opt_nossd, Opt_ssd_spread, Opt_thread_pool, Opt_noacl, Opt_compress,
 	Opt_compress_force, Opt_notreelog, Opt_ratio, Opt_flushoncommit,
-	Opt_discard, Opt_err,
+	Opt_discard, Opt_log_mode, Opt_err,
 };
 
 static match_table_t tokens = {
@@ -91,6 +91,7 @@ static match_table_t tokens = {
 	{Opt_flushoncommit, "flushoncommit"},
 	{Opt_ratio, "metadata_ratio=%d"},
 	{Opt_discard, "discard"},
+	{Opt_log_mode, "log_mode=%d"},
 	{Opt_err, NULL},
 };
 
@@ -234,6 +235,11 @@ int btrfs_parse_options(struct btrfs_roo
 		case Opt_discard:
 			btrfs_set_opt(info->mount_opt, DISCARD);
 			break;
+		case Opt_log_mode:
+			intarg = 0;
+			if (!match_int(&args[0], &intarg))
+				btrfs_set_extent_log_mode(info, intarg);
+			break;
 		case Opt_err:
 			printk(KERN_INFO "btrfs: unrecognized mount option "
 			       "'%s'\n", p);
@@ -497,7 +503,7 @@ int btrfs_sync_fs(struct super_block *sb
 	btrfs_start_delalloc_inodes(root, 0);
 	btrfs_wait_ordered_extents(root, 0, 0);
 
-	trans = btrfs_start_transaction(root, 1);
+	trans = btrfs_join_transaction(root, 1);
 	ret = btrfs_commit_transaction(trans, root);
 	return ret;
 }
diff -urpN 5/fs/btrfs/transaction.c 6/fs/btrfs/transaction.c
--- 5/fs/btrfs/transaction.c	2010-04-14 14:49:58.391967000 +0800
+++ 6/fs/btrfs/transaction.c	2010-05-11 12:40:52.363355000 +0800
@@ -67,6 +67,7 @@ static noinline int join_transaction(str
 		cur_trans->blocked = 0;
 		cur_trans->use_count = 1;
 		cur_trans->commit_done = 0;
+		cur_trans->replay_log = 0;
 		cur_trans->start_time = get_seconds();
 
 		cur_trans->delayed_refs.root = RB_ROOT;
@@ -85,6 +86,8 @@ static noinline int join_transaction(str
 		spin_lock(&root->fs_info->new_trans_lock);
 		root->fs_info->running_transaction = cur_trans;
 		spin_unlock(&root->fs_info->new_trans_lock);
+
+		btrfs_async_replay_extent_log(root);
 	} else {
 		cur_trans->num_writers++;
 		cur_trans->num_joined++;
@@ -312,6 +315,8 @@ static int __btrfs_end_transaction(struc
 		count++;
 	}
 
+	btrfs_flush_extent_log(trans, root, 0);
+
 	mutex_lock(&info->trans_mutex);
 	cur_trans = info->running_transaction;
 	WARN_ON(cur_trans != trans->transaction);
@@ -547,12 +552,16 @@ static noinline int commit_cowonly_roots
 	ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
 	BUG_ON(ret);
 
+	btrfs_flush_extent_log(trans, root, 1);
+
 	while (!list_empty(&fs_info->dirty_cowonly_roots)) {
 		next = fs_info->dirty_cowonly_roots.next;
 		list_del_init(next);
 		root = list_entry(next, struct btrfs_root, dirty_list);
 
 		update_cowonly_root(trans, root);
+
+		btrfs_flush_extent_log(trans, root, 1);
 	}
 
 	down_write(&fs_info->extent_commit_sem);
@@ -975,6 +984,9 @@ int btrfs_commit_transaction(struct btrf
 		 */
 		btrfs_run_ordered_operations(root, 1);
 
+		ret = btrfs_replay_extent_log(trans, root, 1);
+		BUG_ON(ret);
+
 		smp_mb();
 		if (cur_trans->num_writers > 1 || should_grow)
 			schedule_timeout(timeout);
@@ -1058,14 +1070,12 @@ int btrfs_commit_transaction(struct btrf
 	 */
 	mutex_unlock(&root->fs_info->tree_log_mutex);
 
+	root->fs_info->last_trans_committed = cur_trans->transid;
 	btrfs_finish_extent_commit(trans, root);
 
 	mutex_lock(&root->fs_info->trans_mutex);
 
 	cur_trans->commit_done = 1;
-
-	root->fs_info->last_trans_committed = cur_trans->transid;
-
 	wake_up(&cur_trans->commit_wait);
 
 	put_transaction(cur_trans);
diff -urpN 5/fs/btrfs/transaction.h 6/fs/btrfs/transaction.h
--- 5/fs/btrfs/transaction.h	2010-04-13 15:44:56.117812000 +0800
+++ 6/fs/btrfs/transaction.h	2010-05-11 10:04:06.950174000 +0800
@@ -34,6 +34,7 @@ struct btrfs_transaction {
 	int use_count;
 	int commit_done;
 	int blocked;
+	int replay_log;
 	struct list_head list;
 	struct extent_io_tree dirty_pages;
 	unsigned long start_time;
diff -urpN 5/fs/btrfs/tree-log.c 6/fs/btrfs/tree-log.c
--- 5/fs/btrfs/tree-log.c	2010-05-11 13:27:58.658108000 +0800
+++ 6/fs/btrfs/tree-log.c	2010-05-11 11:43:21.095107000 +0800
@@ -3188,3 +3188,40 @@ int btrfs_log_new_name(struct btrfs_tran
 	return btrfs_log_inode_parent(trans, root, inode, parent, 1);
 }
 
+struct __walker_struct {
+	int (*proc)(struct btrfs_root *root,
+		    struct extent_buffer *eb, void *data);
+	void *data;
+};
+
+static int __process_buffer(struct btrfs_root *root,
+			    struct extent_buffer *eb,
+			    struct walk_control *wc, u64 gen)
+{
+	struct __walker_struct *walker;
+	int ret;
+
+	walker = (struct __walker_struct *)wc->replay_dest;
+
+	ret = btrfs_read_buffer(eb, gen);
+	BUG_ON(ret);
+
+	ret = walker->proc(root, eb, walker->data);
+	return ret;
+}
+
+int btrfs_walk_log_tree(struct btrfs_root *root, void *data,
+			int (*proc)(struct btrfs_root *root,
+				    struct extent_buffer *eb, void *data))
+{
+	struct __walker_struct walker = {
+		.proc = proc,
+		.data = data,
+	};
+	struct walk_control wc = {
+		.process_func = __process_buffer,
+		.replay_dest = (struct btrfs_root *)&walker,
+	};
+
+	return walk_log_tree(NULL, root, &wc);
+}
diff -urpN 5/fs/btrfs/tree-log.h 6/fs/btrfs/tree-log.h
--- 5/fs/btrfs/tree-log.h	2010-04-13 15:44:56.120829000 +0800
+++ 6/fs/btrfs/tree-log.h	2010-05-11 10:04:29.372108000 +0800
@@ -48,4 +48,7 @@ void btrfs_record_unlink_dir(struct btrf
 int btrfs_log_new_name(struct btrfs_trans_handle *trans,
 			struct inode *inode, struct inode *old_dir,
 			struct dentry *parent);
+int btrfs_walk_log_tree(struct btrfs_root *root, void *data,
+			int (*proc)(struct btrfs_root *root,
+				    struct extent_buffer *eb, void *data));
 #endif
