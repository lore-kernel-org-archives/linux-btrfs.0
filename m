From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [RFC][PATCH] Btrfs: introduce extent buffer cache for each i-node
Date: Thu, 16 Feb 2012 17:46:31 +0800
Message-ID: <4F3CD077.3020304@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch introduce extent buffer cache for every i-node. By this
way, we needn't search the item from the root of b+ tree, and can
save the search time. Besides that we can also reduce the lock contention
of the root.

Implementation:
- add two pointers of extent buffer into btrfs_inode struct, one for
  nodes/leaves of fs/file tree, the other for nodes/leaves of the log tree.
- add a BTRFS_HEADER_FLAG_COWED flag, which is used to mark the cowed
  nodes/leaves
- When we want to search fs/file trees or the relative log trees, we must
  try to search the cached extent buffer at first, if we can not find the
  item, we will do the common search. At some condition, we will jump to
  the common search directly:
  I. a new transaction starts.
  II. the cached extent buffer was cowed.
  III. the cached extent buffer's level is below the level we must lock.
  and so on.
  And beside that, if we can not find the item, and the slot points to the
  first the item or the last item in the leaf, we must jump out the cached
  extent buffer search, and do the common search.
- After the common search (use btrfs_search_slot), we will cache the leaf
  or the level-1 node into the btrfs i-node object.

I have do small file write performance (inline file) by sysbench for the patch,
and found it can make btrfs 5%~10% faster.

Surely, I will do function test(such as xfstests) and run more performance test
next to validate this patch. And there is some redundant code in this patch. I
will cleanup it in the next version.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/btrfs_inode.h |    3 +
 fs/btrfs/ctree.c       |  358 ++++++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/ctree.h       |   41 +++++-
 fs/btrfs/dir-item.c    |   28 +++--
 fs/btrfs/extent_io.c   |    2 +-
 fs/btrfs/file-item.c   |   14 +-
 fs/btrfs/file.c        |    5 +-
 fs/btrfs/inode-item.c  |   11 +-
 fs/btrfs/inode.c       |   44 ++++---
 fs/btrfs/ioctl.c       |    2 +-
 fs/btrfs/relocation.c  |    2 +-
 fs/btrfs/super.c       |    3 +-
 fs/btrfs/tree-log.c    |   19 ++-
 fs/btrfs/xattr.c       |    2 +-
 14 files changed, 463 insertions(+), 71 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 9b9b15f..2374920 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -164,6 +164,9 @@ struct btrfs_inode {
 
 	struct btrfs_delayed_node *delayed_node;
 
+	struct extent_buffer *fs_eb;
+	struct extent_buffer *log_eb;
+
 	struct inode vfs_inode;
 };
 
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 0639a55..693e499 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -458,6 +458,7 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 	btrfs_set_header_backref_rev(cow, BTRFS_MIXED_BACKREF_REV);
 	btrfs_clear_header_flag(cow, BTRFS_HEADER_FLAG_WRITTEN |
 				     BTRFS_HEADER_FLAG_RELOC);
+	btrfs_set_header_flag(buf, BTRFS_HEADER_FLAG_COWED);
 	if (root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID)
 		btrfs_set_header_flag(cow, BTRFS_HEADER_FLAG_RELOC);
 	else
@@ -1533,6 +1534,22 @@ read_block_for_search(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+static int check_nodes_need_balance(struct btrfs_root *root,
+				    struct btrfs_path *p,
+				    struct extent_buffer *b,
+				    int level, int ins_len)
+{
+	if ((p->search_for_split || ins_len > 0) && btrfs_header_nritems(b) >=
+	    BTRFS_NODEPTRS_PER_BLOCK(root) - 3)
+		return 1;
+
+	if (ins_len < 0 &&
+	    btrfs_header_nritems(b) < BTRFS_NODEPTRS_PER_BLOCK(root) / 2)
+		return 1;
+
+	return 0;
+}
+
 /*
  * helper function for btrfs_search_slot.  This does all of the checks
  * for node-level blocks and does any balancing required based on
@@ -1874,6 +1891,299 @@ done:
 	return ret;
 }
 
+static int btrfs_search_cached_extent_buffer(struct btrfs_trans_handle *trans,
+			struct btrfs_root *root, struct btrfs_inode *inode,
+			struct btrfs_key *key, struct btrfs_path *p,
+			int ins_len, int cow)
+{
+	struct extent_buffer *b;
+	int slot;
+	int ret;
+	int err;
+	int level;
+	int lowest_unlock = 1;
+	int write_lock_level = 0;
+	u8 lowest_level = 0;
+
+	if (cow && (p->keep_locks || p->lowest_level))
+		return -EAGAIN;
+
+	if (unlikely(p->search_commit_root))
+		return -EAGAIN;
+
+	lowest_level = p->lowest_level;
+	WARN_ON(lowest_level && ins_len > 0);
+	WARN_ON(p->nodes[0] != NULL);
+
+	if (ins_len < 0) {
+		lowest_unlock = 2;
+		write_lock_level = 1;
+	}
+
+	if (!cow)
+		write_lock_level = -1;
+
+again:
+	if (unlikely(root->objectid == BTRFS_TREE_LOG_OBJECTID))
+		b = inode->log_eb;
+	else
+		b = inode->fs_eb;
+
+	if (!b)
+		return -EAGAIN;
+
+	level = btrfs_header_level(b);
+	if (level < write_lock_level || level < lowest_level)
+		return -EAGAIN;
+
+	if (btrfs_header_flag(b, BTRFS_HEADER_FLAG_COWED))
+		return -EAGAIN;
+
+	extent_buffer_get(b);
+	p->nodes[level] = b;
+
+	if (!p->skip_locking) {
+		WARN_ON(p->search_commit_root);
+
+		if (level <= write_lock_level) {
+			btrfs_tree_lock(b);
+			p->locks[level] = BTRFS_WRITE_LOCK;
+		} else {
+			btrfs_tree_read_lock(b);
+			p->locks[level] = BTRFS_READ_LOCK;
+		}
+	}
+
+	while (b) {
+		level = btrfs_header_level(b);
+
+		if (cow) {
+			/*
+			 * if we don't really need to cow this block
+			 * then we don't want to set the path blocking,
+			 * so we test it here
+			 */
+			if (!should_cow_block(trans, root, b))
+				goto cow_done;
+
+			if (level + 1 >= BTRFS_MAX_LEVEL ||
+			    !p->nodes[level + 1]) {
+				ret = -EAGAIN;
+				goto done;
+			}
+
+			btrfs_set_path_blocking(p);
+
+			/*
+			 * must have write locks on this node and the
+			 * parent
+			 */
+			if (level + 1 > write_lock_level) {
+				write_lock_level = level + 1;
+				btrfs_release_path(p);
+				goto again;
+			}
+
+			err = btrfs_cow_block(trans, root, b,
+					      p->nodes[level + 1],
+					      p->slots[level + 1], &b);
+			if (err) {
+				ret = err;
+				goto done;
+			}
+		}
+cow_done:
+		BUG_ON(!cow && ins_len);
+
+		p->nodes[level] = b;
+		btrfs_clear_path_blocking(p, NULL, 0);
+
+		/*
+		 * we have a lock on b and as long as we aren't changing
+		 * the tree, there is no way to for the items in b to change.
+		 * It is safe to drop the lock on our parent before we
+		 * go through the expensive btree search on b.
+		 *
+		 * If cow is true, then we might be changing slot zero,
+		 * which may require changing the parent.  So, we can't
+		 * drop the lock until after we know which slot we're
+		 * operating on.
+		 */
+		if (!cow)
+			btrfs_unlock_up_safe(p, level + 1);
+
+		ret = bin_search(b, key, level, &slot);
+
+		if (level != 0) {
+			int dec = 0;
+			if (ret && slot > 0) {
+				dec = 1;
+				slot -= 1;
+			}
+			p->slots[level] = slot;
+			if (level + 1 >= BTRFS_MAX_LEVEL ||
+			    !p->nodes[level + 1]) {
+				err = check_nodes_need_balance(root, p, b,
+							       level, ins_len);
+				if (err) {
+					ret = -EAGAIN;
+					goto done;
+				}
+			} else {
+				err = setup_nodes_for_search(trans, root, p, b,
+							     level, ins_len,
+							     &write_lock_level);
+				if (err == -EAGAIN)
+					goto again;
+				if (err) {
+					ret = err;
+					goto done;
+				}
+			}
+			b = p->nodes[level];
+			slot = p->slots[level];
+
+			/*
+			 * slot 0 is special, if we change the key
+			 * we have to update the parent pointer
+			 * which means we must have a write lock
+			 * on the parent
+			 */
+			if (slot == 0 && cow &&
+			    write_lock_level < level + 1) {
+				write_lock_level = level + 1;
+				btrfs_release_path(p);
+				goto again;
+			}
+
+			unlock_up(p, level, lowest_unlock);
+
+			if (level == lowest_level) {
+				if (dec)
+					p->slots[level]++;
+				goto done;
+			}
+
+			err = read_block_for_search(trans, root, p,
+						    &b, level, slot, key);
+			if (err == -EAGAIN)
+				goto again;
+			if (err) {
+				ret = err;
+				goto done;
+			}
+
+			if (!p->skip_locking) {
+				level = btrfs_header_level(b);
+				if (level <= write_lock_level) {
+					err = btrfs_try_tree_write_lock(b);
+					if (!err) {
+						btrfs_set_path_blocking(p);
+						btrfs_tree_lock(b);
+						btrfs_clear_path_blocking(p, b,
+							BTRFS_WRITE_LOCK);
+					}
+					p->locks[level] = BTRFS_WRITE_LOCK;
+				} else {
+					err = btrfs_try_tree_read_lock(b);
+					if (!err) {
+						btrfs_set_path_blocking(p);
+						btrfs_tree_read_lock(b);
+						btrfs_clear_path_blocking(p, b,
+							BTRFS_READ_LOCK);
+					}
+					p->locks[level] = BTRFS_READ_LOCK;
+				}
+				p->nodes[level] = b;
+			}
+		} else {
+			p->slots[level] = slot;
+			if (ins_len > 0 &&
+			    btrfs_leaf_free_space(root, b) < ins_len) {
+				if (write_lock_level < 1) {
+					write_lock_level = 1;
+					btrfs_release_path(p);
+					goto again;
+				}
+
+				if (!p->nodes[1]) {
+					ret = -EAGAIN;
+					goto done;
+				}
+
+				btrfs_set_path_blocking(p);
+				err = split_leaf(trans, root, key,
+						 p, ins_len, ret == 0);
+				btrfs_clear_path_blocking(p, NULL, 0);
+
+				BUG_ON(err > 0);
+				if (err) {
+					ret = err;
+					goto done;
+				}
+			}
+			if (!p->search_for_split)
+				unlock_up(p, level, lowest_unlock);
+			goto done;
+		}
+	}
+	ret = 1;
+done:
+	/*
+	 * we don't really know what they plan on doing with the path
+	 * from here on, so for now just mark it as blocking
+	 */
+	if (!p->leave_spinning)
+		btrfs_set_path_blocking(p);
+	if (ret < 0) {
+		btrfs_release_path(p);
+	} else if ((ins_len < 0 && p->slots[1] == 0) ||
+		   (ret > 0 &&
+		    (p->slots[0] == 0 ||
+		     p->slots[0] == btrfs_header_nritems(p->nodes[0])))) {
+			ret = -EAGAIN;
+			btrfs_release_path(p);
+	}
+
+	return ret;
+}
+
+int btrfs_search_slot_for_inode(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root,
+				struct inode *inode,
+				struct btrfs_key *key, struct btrfs_path *p,
+				int ins_len, int cow)
+{
+	struct extent_buffer *eb;
+	int cache_level = 0;
+	int ret;
+
+	if (!p->search_commit_root) {
+		ret = btrfs_search_cached_extent_buffer(trans, root,
+							BTRFS_I(inode),
+							key, p,	ins_len, cow);
+		if (ret >= 0)
+			return ret;
+	}
+
+	ret = btrfs_search_slot(trans, root, key, p, ins_len, cow);
+	if (ret >= 0 && !p->search_commit_root) {
+		if (ins_len < 0 && p->nodes[1])
+			cache_level = 1;
+		if (unlikely(root->objectid == BTRFS_TREE_LOG_OBJECTID)) {
+			eb = BTRFS_I(inode)->log_eb;
+			BTRFS_I(inode)->log_eb = p->nodes[cache_level];
+		} else {
+			eb = BTRFS_I(inode)->fs_eb;
+			BTRFS_I(inode)->fs_eb = p->nodes[cache_level];
+		}
+		free_extent_buffer(eb);
+		extent_buffer_get(p->nodes[cache_level]);
+	}
+
+	return ret;
+}
+
 /*
  * adjust the pointers going up the tree, starting at level
  * making sure the right key of each node is points to 'key'.
@@ -3648,15 +3958,12 @@ int setup_items_for_insert(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-/*
- * Given a key and some data, insert items into the tree.
- * This does all the path init required, making room in the tree if needed.
- */
-int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root,
-			    struct btrfs_path *path,
-			    struct btrfs_key *cpu_key, u32 *data_size,
-			    int nr)
+static int __btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
+				      struct btrfs_root *root,
+				      struct inode *inode,
+				      struct btrfs_path *path,
+				      struct btrfs_key *cpu_key, u32 *data_size,
+				      int nr)
 {
 	int ret = 0;
 	int slot;
@@ -3668,7 +3975,12 @@ int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
 		total_data += data_size[i];
 
 	total_size = total_data + (nr * sizeof(struct btrfs_item));
-	ret = btrfs_search_slot(trans, root, cpu_key, path, total_size, 1);
+	if (inode)
+		ret = btrfs_search_slot_for_inode(trans, root, inode, cpu_key,
+						  path, total_size, 1);
+	else
+		ret = btrfs_search_slot(trans, root, cpu_key, path, total_size,
+					1);
 	if (ret == 0)
 		return -EEXIST;
 	if (ret < 0)
@@ -3685,6 +3997,32 @@ out:
 }
 
 /*
+ * Given a key and some data, insert items into the tree.
+ * This does all the path init required, making room in the tree if needed.
+ */
+int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
+			     struct btrfs_root *root,
+			     struct btrfs_path *path,
+			     struct btrfs_key *cpu_key, u32 *data_size,
+			     int nr)
+{
+	return __btrfs_insert_empty_items(trans, root, NULL, path, cpu_key,
+					  data_size, nr);
+}
+
+int btrfs_insert_empty_items_for_inode(struct btrfs_trans_handle *trans,
+				       struct btrfs_root *root,
+				       struct inode *inode,
+				       struct btrfs_path *path,
+				       struct btrfs_key *cpu_key,
+				       u32 *data_size,
+				       int nr)
+{
+	return __btrfs_insert_empty_items(trans, root, inode, path, cpu_key,
+					  data_size, nr);
+}
+
+/*
  * Given a key and some data, insert an item into the tree.
  * This does all the path init required, making room in the tree if needed.
  */
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3c2cbf7..67b2a7c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -306,6 +306,7 @@ static inline unsigned long btrfs_chunk_item_size(int num_stripes)
 
 #define BTRFS_HEADER_FLAG_WRITTEN	(1ULL << 0)
 #define BTRFS_HEADER_FLAG_RELOC		(1ULL << 1)
+#define BTRFS_HEADER_FLAG_COWED		(1ULL << 2)
 
 /*
  * File system states
@@ -2608,6 +2609,11 @@ int btrfs_duplicate_item(struct btrfs_trans_handle *trans,
 int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, struct btrfs_key *key, struct btrfs_path *p, int
 		      ins_len, int cow);
+int btrfs_search_slot_for_inode(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root,
+				struct inode *inode,
+				struct btrfs_key *key, struct btrfs_path *p,
+				int ins_len, int cow);
 int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root, struct extent_buffer *parent,
 		       int start_slot, int cache_only, u64 *last_ret,
@@ -2649,6 +2655,25 @@ static inline int btrfs_insert_empty_item(struct btrfs_trans_handle *trans,
 	return btrfs_insert_empty_items(trans, root, path, key, &data_size, 1);
 }
 
+int btrfs_insert_empty_items_for_inode(struct btrfs_trans_handle *trans,
+				       struct btrfs_root *root,
+				       struct inode *inode,
+				       struct btrfs_path *path,
+				       struct btrfs_key *cpu_key,
+				       u32 *data_size,
+				       int nr);
+static inline int btrfs_insert_empty_item_for_inode(
+					struct btrfs_trans_handle *trans,
+					struct btrfs_root *root,
+					struct inode *inode,
+					struct btrfs_path *path,
+					struct btrfs_key *key,
+					u32 data_size)
+{
+	return btrfs_insert_empty_items_for_inode(trans, root, inode, path,
+						  key, &data_size, 1);
+}
+
 int btrfs_next_leaf(struct btrfs_root *root, struct btrfs_path *path);
 static inline int btrfs_next_item(struct btrfs_root *root, struct btrfs_path *p)
 {
@@ -2741,7 +2766,8 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans,
 			  struct btrfs_key *location, u8 type, u64 index);
 struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
 					     struct btrfs_root *root,
-					     struct btrfs_path *path, u64 dir,
+					     struct inode *dir,
+					     struct btrfs_path *path, u64 dirid,
 					     const char *name, int name_len,
 					     int mod);
 struct btrfs_dir_item *
@@ -2763,7 +2789,8 @@ int btrfs_delete_one_dir_name(struct btrfs_trans_handle *trans,
 			      struct btrfs_dir_item *di);
 int btrfs_insert_xattr_item(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root,
-			    struct btrfs_path *path, u64 objectid,
+			    struct inode *inode,
+			    struct btrfs_path *path,
 			    const char *name, u16 name_len,
 			    const void *data, u16 data_len);
 struct btrfs_dir_item *btrfs_lookup_xattr(struct btrfs_trans_handle *trans,
@@ -2788,9 +2815,9 @@ int btrfs_insert_inode_ref(struct btrfs_trans_handle *trans,
 			   const char *name, int name_len,
 			   u64 inode_objectid, u64 ref_objectid, u64 index);
 int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root,
-			   const char *name, int name_len,
-			   u64 inode_objectid, u64 ref_objectid, u64 *index);
+			struct btrfs_root *root,
+			const char *name, int name_len,
+			struct inode *inode, u64 ref_objectid, u64 *index);
 struct btrfs_inode_ref *
 btrfs_lookup_inode_ref(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root,
@@ -2813,13 +2840,13 @@ int btrfs_lookup_bio_sums_dio(struct btrfs_root *root, struct inode *inode,
 			      struct bio *bio, u64 logical_offset, u32 *dst);
 int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
-			     u64 objectid, u64 pos,
+			     struct inode *inode, u64 pos,
 			     u64 disk_offset, u64 disk_num_bytes,
 			     u64 num_bytes, u64 offset, u64 ram_bytes,
 			     u8 compression, u8 encryption, u16 other_encoding);
 int btrfs_lookup_file_extent(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
-			     struct btrfs_path *path, u64 objectid,
+			     struct btrfs_path *path, struct inode *inode,
 			     u64 bytenr, int mod);
 int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 31d84e7..050998f 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -32,6 +32,7 @@
 static struct btrfs_dir_item *insert_with_overflow(struct btrfs_trans_handle
 						   *trans,
 						   struct btrfs_root *root,
+						   struct inode *inode,
 						   struct btrfs_path *path,
 						   struct btrfs_key *cpu_key,
 						   u32 data_size,
@@ -43,7 +44,8 @@ static struct btrfs_dir_item *insert_with_overflow(struct btrfs_trans_handle
 	struct btrfs_item *item;
 	struct extent_buffer *leaf;
 
-	ret = btrfs_insert_empty_item(trans, root, path, cpu_key, data_size);
+	ret = btrfs_insert_empty_item_for_inode(trans, root, inode, path,
+						cpu_key, data_size);
 	if (ret == -EEXIST) {
 		struct btrfs_dir_item *di;
 		di = btrfs_match_dir_item_name(root, path, name, name_len);
@@ -68,7 +70,8 @@ static struct btrfs_dir_item *insert_with_overflow(struct btrfs_trans_handle
  */
 int btrfs_insert_xattr_item(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root,
-			    struct btrfs_path *path, u64 objectid,
+			    struct inode *inode,
+			    struct btrfs_path *path,
 			    const char *name, u16 name_len,
 			    const void *data, u16 data_len)
 {
@@ -82,13 +85,13 @@ int btrfs_insert_xattr_item(struct btrfs_trans_handle *trans,
 
 	BUG_ON(name_len + data_len > BTRFS_MAX_XATTR_SIZE(root));
 
-	key.objectid = objectid;
+	key.objectid = btrfs_ino(inode);
 	btrfs_set_key_type(&key, BTRFS_XATTR_ITEM_KEY);
 	key.offset = btrfs_name_hash(name, name_len);
 
 	data_size = sizeof(*dir_item) + name_len + data_len;
-	dir_item = insert_with_overflow(trans, root, path, &key, data_size,
-					name, name_len);
+	dir_item = insert_with_overflow(trans, root, inode, path, &key,
+					data_size, name, name_len);
 	if (IS_ERR(dir_item))
 		return PTR_ERR(dir_item);
 	memset(&location, 0, sizeof(location));
@@ -144,7 +147,7 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans, struct btrfs_root
 	btrfs_cpu_key_to_disk(&disk_key, location);
 
 	data_size = sizeof(*dir_item) + name_len;
-	dir_item = insert_with_overflow(trans, root, path, &key, data_size,
+	dir_item = insert_with_overflow(trans, root, dir, path, &key, data_size,
 					name, name_len);
 	if (IS_ERR(dir_item)) {
 		ret = PTR_ERR(dir_item);
@@ -184,13 +187,14 @@ out_free:
 }
 
 /*
- * lookup a directory item based on name.  'dir' is the objectid
+ * lookup a directory item based on name.  'dirid' is the objectid
  * we're searching in, and 'mod' tells us if you plan on deleting the
  * item (use mod < 0) or changing the options (use mod > 0)
  */
 struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
 					     struct btrfs_root *root,
-					     struct btrfs_path *path, u64 dir,
+					     struct inode *dir,
+					     struct btrfs_path *path, u64 dirid,
 					     const char *name, int name_len,
 					     int mod)
 {
@@ -199,12 +203,16 @@ struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
 	int ins_len = mod < 0 ? -1 : 0;
 	int cow = mod != 0;
 
-	key.objectid = dir;
+	key.objectid = dirid;
 	btrfs_set_key_type(&key, BTRFS_DIR_ITEM_KEY);
 
 	key.offset = btrfs_name_hash(name, name_len);
 
-	ret = btrfs_search_slot(trans, root, &key, path, ins_len, cow);
+	if (dir)
+		ret = btrfs_search_slot_for_inode(trans, root, dir, &key, path,
+						  ins_len, cow);
+	else
+		ret = btrfs_search_slot(trans, root, &key, path, ins_len, cow);
 	if (ret < 0)
 		return ERR_PTR(ret);
 	if (ret > 0)
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index fcf77e1..48c11b3 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3396,7 +3396,7 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	 * because there might be preallocation past i_size
 	 */
 	ret = btrfs_lookup_file_extent(NULL, BTRFS_I(inode)->root,
-				       path, btrfs_ino(inode), -1, 0);
+				       path, inode, -1, 0);
 	if (ret < 0) {
 		btrfs_free_path(path);
 		return ret;
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index c7fb3a4..332ff9a 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -36,7 +36,7 @@
 
 int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
-			     u64 objectid, u64 pos,
+			     struct inode *inode, u64 pos,
 			     u64 disk_offset, u64 disk_num_bytes,
 			     u64 num_bytes, u64 offset, u64 ram_bytes,
 			     u8 compression, u8 encryption, u16 other_encoding)
@@ -46,6 +46,7 @@ int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
 	struct btrfs_key file_key;
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
+	u64 objectid = btrfs_ino(inode);
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -55,8 +56,8 @@ int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
 	btrfs_set_key_type(&file_key, BTRFS_EXTENT_DATA_KEY);
 
 	path->leave_spinning = 1;
-	ret = btrfs_insert_empty_item(trans, root, path, &file_key,
-				      sizeof(*item));
+	ret = btrfs_insert_empty_item_for_inode(trans, root, inode, path,
+						&file_key, sizeof(*item));
 	if (ret < 0)
 		goto out;
 	BUG_ON(ret);
@@ -133,7 +134,7 @@ fail:
 
 int btrfs_lookup_file_extent(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
-			     struct btrfs_path *path, u64 objectid,
+			     struct btrfs_path *path, struct inode *inode,
 			     u64 offset, int mod)
 {
 	int ret;
@@ -141,10 +142,11 @@ int btrfs_lookup_file_extent(struct btrfs_trans_handle *trans,
 	int ins_len = mod < 0 ? -1 : 0;
 	int cow = mod != 0;
 
-	file_key.objectid = objectid;
+	file_key.objectid = btrfs_ino(inode);
 	file_key.offset = offset;
 	btrfs_set_key_type(&file_key, BTRFS_EXTENT_DATA_KEY);
-	ret = btrfs_search_slot(trans, root, &file_key, path, ins_len, cow);
+	ret = btrfs_search_slot_for_inode(trans, root, inode, &file_key, path,
+					  ins_len, cow);
 	return ret;
 }
 
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 0621a3a..8c7a786 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -577,7 +577,7 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans, struct inode *inode,
 
 	while (1) {
 		recow = 0;
-		ret = btrfs_lookup_file_extent(trans, root, path, ino,
+		ret = btrfs_lookup_file_extent(trans, root, path, inode,
 					       search_start, -1);
 		if (ret < 0)
 			break;
@@ -865,7 +865,8 @@ again:
 	key.type = BTRFS_EXTENT_DATA_KEY;
 	key.offset = split;
 
-	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+	ret = btrfs_search_slot_for_inode(trans, root, inode, &key, path,
+					  -1, 1);
 	if (ret < 0)
 		goto out;
 	if (ret > 0 && path->slots[0] > 0)
diff --git a/fs/btrfs/inode-item.c b/fs/btrfs/inode-item.c
index baa74f3..68f2031 100644
--- a/fs/btrfs/inode-item.c
+++ b/fs/btrfs/inode-item.c
@@ -77,9 +77,9 @@ btrfs_lookup_inode_ref(struct btrfs_trans_handle *trans,
 }
 
 int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root,
-			   const char *name, int name_len,
-			   u64 inode_objectid, u64 ref_objectid, u64 *index)
+			struct btrfs_root *root,
+			const char *name, int name_len,
+			struct inode *inode, u64 ref_objectid, u64 *index)
 {
 	struct btrfs_path *path;
 	struct btrfs_key key;
@@ -92,7 +92,7 @@ int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
 	int ret;
 	int del_len = name_len + sizeof(*ref);
 
-	key.objectid = inode_objectid;
+	key.objectid = btrfs_ino(inode);
 	key.offset = ref_objectid;
 	btrfs_set_key_type(&key, BTRFS_INODE_REF_KEY);
 
@@ -102,7 +102,8 @@ int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
 
 	path->leave_spinning = 1;
 
-	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+	ret = btrfs_search_slot_for_inode(trans, root, inode, &key,
+					  path, -1, 1);
 	if (ret > 0) {
 		ret = -ENOENT;
 		goto out;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7405753..ad64e31 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -148,8 +148,8 @@ static noinline int insert_inline_extent(struct btrfs_trans_handle *trans,
 	datasize = btrfs_file_extent_calc_inline_size(cur_size);
 
 	inode_add_bytes(inode, size);
-	ret = btrfs_insert_empty_item(trans, root, path, &key,
-				      datasize);
+	ret = btrfs_insert_empty_item_for_inode(trans, root, inode, path, &key,
+						datasize);
 	BUG_ON(ret);
 	if (ret) {
 		err = ret;
@@ -1084,7 +1084,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 	cow_start = (u64)-1;
 	cur_offset = start;
 	while (1) {
-		ret = btrfs_lookup_file_extent(trans, root, path, ino,
+		ret = btrfs_lookup_file_extent(trans, root, path, inode,
 					       cur_offset, 0);
 		BUG_ON(ret < 0);
 		if (ret > 0 && path->slots[0] > 0 && check_prev) {
@@ -1670,7 +1670,8 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	ins.objectid = btrfs_ino(inode);
 	ins.offset = file_pos;
 	ins.type = BTRFS_EXTENT_DATA_KEY;
-	ret = btrfs_insert_empty_item(trans, root, path, &ins, sizeof(*fi));
+	ret = btrfs_insert_empty_item_for_inode(trans, root, inode, path,
+						&ins, sizeof(*fi));
 	BUG_ON(ret);
 	leaf = path->nodes[0];
 	fi = btrfs_item_ptr(leaf, path->slots[0],
@@ -2577,8 +2578,8 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 	}
 
 	path->leave_spinning = 1;
-	di = btrfs_lookup_dir_item(trans, root, path, dir_ino,
-				    name, name_len, -1);
+	di = btrfs_lookup_dir_item(trans, root, dir, path, dir_ino,
+				   name, name_len, -1);
 	if (IS_ERR(di)) {
 		ret = PTR_ERR(di);
 		goto err;
@@ -2594,7 +2595,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 		goto err;
 	btrfs_release_path(path);
 
-	ret = btrfs_del_inode_ref(trans, root, name, name_len, ino,
+	ret = btrfs_del_inode_ref(trans, root, name, name_len, inode,
 				  dir_ino, &index);
 	if (ret) {
 		printk(KERN_INFO "btrfs failed to delete reference to %.*s, "
@@ -2762,7 +2763,7 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir,
 
 	if (ret == 0 && S_ISREG(inode->i_mode)) {
 		ret = btrfs_lookup_file_extent(trans, root, path,
-					       ino, (u64)-1, 0);
+					       inode, (u64)-1, 0);
 		if (ret < 0) {
 			err = ret;
 			goto out;
@@ -2778,8 +2779,8 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir,
 		goto out;
 	}
 
-	di = btrfs_lookup_dir_item(trans, root, path, dir_ino,
-				dentry->d_name.name, dentry->d_name.len, 0);
+	di = btrfs_lookup_dir_item(trans, root, dir, path, dir_ino,
+				   dentry->d_name.name, dentry->d_name.len, 0);
 	if (IS_ERR(di)) {
 		err = PTR_ERR(di);
 		goto out;
@@ -2905,7 +2906,7 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
-	di = btrfs_lookup_dir_item(trans, root, path, dir_ino,
+	di = btrfs_lookup_dir_item(trans, root, dir, path, dir_ino,
 				   name, name_len, -1);
 	BUG_ON(IS_ERR_OR_NULL(di));
 
@@ -3046,7 +3047,8 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 
 search_again:
 	path->leave_spinning = 1;
-	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+	ret = btrfs_search_slot_for_inode(trans, root, inode, &key,
+					  path, -1, 1);
 	if (ret < 0) {
 		err = ret;
 		goto out;
@@ -3061,6 +3063,7 @@ search_again:
 		path->slots[0]--;
 	}
 
+	leaf = path->nodes[0];
 	while (1) {
 		fi = NULL;
 		leaf = path->nodes[0];
@@ -3385,7 +3388,7 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
 			}
 
 			err = btrfs_insert_file_extent(trans, root,
-					btrfs_ino(inode), cur_offset, 0,
+					inode, cur_offset, 0,
 					0, hole_size, 0, hole_size,
 					0, 0, 0);
 			if (err) {
@@ -3594,6 +3597,8 @@ void btrfs_evict_inode(struct inode *inode)
 	btrfs_end_transaction(trans, root);
 	btrfs_btree_balance_dirty(root, nr);
 no_delete:
+	free_extent_buffer(BTRFS_I(inode)->fs_eb);
+	free_extent_buffer(BTRFS_I(inode)->log_eb);
 	end_writeback(inode);
 	return;
 }
@@ -3616,8 +3621,8 @@ static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
 	if (!path)
 		return -ENOMEM;
 
-	di = btrfs_lookup_dir_item(NULL, root, path, btrfs_ino(dir), name,
-				    namelen, 0);
+	di = btrfs_lookup_dir_item(NULL, root, dir, path, btrfs_ino(dir), name,
+				   namelen, 0);
 	if (IS_ERR(di))
 		ret = PTR_ERR(di);
 
@@ -4079,7 +4084,7 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 	key.offset = filp->f_pos;
 	key.objectid = btrfs_ino(inode);
 
-	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	ret = btrfs_search_slot_for_inode(NULL, root, inode, &key, path, 0, 0);
 	if (ret < 0)
 		goto err;
 
@@ -4991,7 +4996,7 @@ again:
 	}
 
 	ret = btrfs_lookup_file_extent(trans, root, path,
-				       objectid, start, trans != NULL);
+				       inode, start, trans != NULL);
 	if (ret < 0) {
 		err = ret;
 		goto out;
@@ -5459,7 +5464,7 @@ static noinline int can_nocow_odirect(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
-	ret = btrfs_lookup_file_extent(trans, root, path, btrfs_ino(inode),
+	ret = btrfs_lookup_file_extent(trans, root, path, inode,
 				       offset, 0);
 	if (ret < 0)
 		goto out;
@@ -6761,6 +6766,9 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	INIT_LIST_HEAD(&ei->ordered_operations);
 	RB_CLEAR_NODE(&ei->rb_node);
 
+	ei->fs_eb = NULL;
+	ei->log_eb = NULL;
+
 	return inode;
 }
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0b06a5c..7a7fa8b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2657,7 +2657,7 @@ static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
 	}
 
 	dir_id = btrfs_super_root_dir(root->fs_info->super_copy);
-	di = btrfs_lookup_dir_item(trans, root->fs_info->tree_root, path,
+	di = btrfs_lookup_dir_item(trans, root->fs_info->tree_root, NULL, path,
 				   dir_id, "default", 7, 1);
 	if (IS_ERR_OR_NULL(di)) {
 		btrfs_free_path(path);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 8c1aae2..8ebf52f 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1477,7 +1477,7 @@ static int get_new_location(struct inode *reloc_inode, u64 *new_bytenr,
 		return -ENOMEM;
 
 	bytenr -= BTRFS_I(reloc_inode)->index_cnt;
-	ret = btrfs_lookup_file_extent(NULL, root, path, btrfs_ino(reloc_inode),
+	ret = btrfs_lookup_file_extent(NULL, root, path, reloc_inode,
 				       bytenr, 0);
 	if (ret < 0)
 		goto out;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 61717a4..f078df7 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -573,7 +573,8 @@ static struct dentry *get_default_root(struct super_block *sb,
 	 * to mount.
 	 */
 	dir_id = btrfs_super_root_dir(root->fs_info->super_copy);
-	di = btrfs_lookup_dir_item(NULL, root, path, dir_id, "default", 7, 0);
+	di = btrfs_lookup_dir_item(NULL, root, NULL, path, dir_id, "default",
+				   7, 0);
 	if (IS_ERR(di)) {
 		btrfs_free_path(path);
 		return ERR_CAST(di);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 966cc74..466dd0d 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -519,7 +519,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 	 * file.  This must be done before the btrfs_drop_extents run
 	 * so we don't try to drop this extent.
 	 */
-	ret = btrfs_lookup_file_extent(trans, root, path, btrfs_ino(inode),
+	ret = btrfs_lookup_file_extent(trans, root, path, inode,
 				       start, 0);
 
 	if (ret == 0 &&
@@ -719,7 +719,8 @@ static noinline int inode_in_dir(struct btrfs_root *root,
 		goto out;
 	btrfs_release_path(path);
 
-	di = btrfs_lookup_dir_item(NULL, root, path, dirid, name, name_len, 0);
+	di = btrfs_lookup_dir_item(NULL, root, NULL, path, dirid, name,
+				   name_len, 0);
 	if (di && !IS_ERR(di)) {
 		btrfs_dir_item_key_to_cpu(path->nodes[0], di, &location);
 		if (location.objectid != objectid)
@@ -922,7 +923,7 @@ again:
 	btrfs_release_path(path);
 
 	/* look for a conflicing name */
-	di = btrfs_lookup_dir_item(trans, root, path, btrfs_ino(dir),
+	di = btrfs_lookup_dir_item(trans, root, dir, path, btrfs_ino(dir),
 				   name, namelen, 0);
 	if (di && !IS_ERR(di)) {
 		ret = drop_one_dir_item(trans, root, path, dir, di);
@@ -1229,8 +1230,9 @@ static noinline int replay_one_name(struct btrfs_trans_handle *trans,
 	btrfs_release_path(path);
 
 	if (key->type == BTRFS_DIR_ITEM_KEY) {
-		dst_di = btrfs_lookup_dir_item(trans, root, path, key->objectid,
-				       name, name_len, 1);
+		dst_di = btrfs_lookup_dir_item(trans, root, NULL, path,
+					       key->objectid, name,
+					       name_len, 1);
 	} else if (key->type == BTRFS_DIR_INDEX_KEY) {
 		dst_di = btrfs_lookup_dir_index_item(trans, root, path,
 						     key->objectid,
@@ -1450,7 +1452,8 @@ again:
 				  name_len);
 		log_di = NULL;
 		if (log && dir_key->type == BTRFS_DIR_ITEM_KEY) {
-			log_di = btrfs_lookup_dir_item(trans, log, log_path,
+			log_di = btrfs_lookup_dir_item(trans, log, dir,
+						       log_path,
 						       dir_key->objectid,
 						       name, name_len, 0);
 		} else if (log && dir_key->type == BTRFS_DIR_INDEX_KEY) {
@@ -2262,7 +2265,7 @@ int btrfs_del_dir_entries_in_log(struct btrfs_trans_handle *trans,
 		goto out_unlock;
 	}
 
-	di = btrfs_lookup_dir_item(trans, log, path, dir_ino,
+	di = btrfs_lookup_dir_item(trans, log, dir, path, dir_ino,
 				   name, name_len, -1);
 	if (IS_ERR(di)) {
 		err = PTR_ERR(di);
@@ -2351,7 +2354,7 @@ int btrfs_del_inode_ref_in_log(struct btrfs_trans_handle *trans,
 	log = root->log_root;
 	mutex_lock(&BTRFS_I(inode)->log_mutex);
 
-	ret = btrfs_del_inode_ref(trans, log, name, name_len, btrfs_ino(inode),
+	ret = btrfs_del_inode_ref(trans, log, name, name_len, inode,
 				  dirid, &index);
 	mutex_unlock(&BTRFS_I(inode)->log_mutex);
 	if (ret == -ENOSPC) {
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index e7a5659..c7e3cab 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -125,7 +125,7 @@ static int do_setxattr(struct btrfs_trans_handle *trans,
 	}
 
 again:
-	ret = btrfs_insert_xattr_item(trans, root, path, btrfs_ino(inode),
+	ret = btrfs_insert_xattr_item(trans, root, inode, path,
 				      name, name_len, value, size);
 	/*
 	 * If we're setting an xattr to a new value but the new value is say
-- 
1.7.6.5
