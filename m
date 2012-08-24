Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:34284 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687Ab2HXSiT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Aug 2012 14:38:19 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id ychlZBEP5KlyBX3i (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 24 Aug 2012 12:38:16 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: turbo charge fsync
Date: Fri, 24 Aug 2012 14:43:28 -0400
Message-ID: <1345833808-1539-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

At least for the vm workload.  Currently on fsync we will

1) Truncate all items in the log tree for the given inode if they exist

and

2) Copy all items for a given inode into the log

The problem with this is that for things like VMs you can have lots of
extents from the fragmented writing behavior, and worst yet you may have
only modified a few extents, not the entire thing.  This patch fixes this
problem by tracking which transid modified our extent, and then when we do
the tree logging we find all of the extents we've modified in our current
transaction, sort them and commit them.  We also only truncate up to the
xattrs of the inode and copy that stuff in normally, and then just drop any
extents in the range we have that exist in the log already.  Here are some
numbers of a 50 meg fio job that does random writes and fsync()s after every
write

		Original	Patched
SATA drive	82KB/s		140KB/s
Fusion drive	431KB/s		2532KB/s

So around 2-6 times faster depending on your hardware.  There are a few
corner cases, for example if you truncate at all we have to do it the old
way since there is no way to be sure what is in the log is ok.  This
probably could be done smarter, but if you write-fsync-truncate-write-fsync
you deserve what you get.  All this work is in RAM of course so if your
inode gets evicted from cache and you read it in and fsync it we'll do it
the slow way if we are still in the same transaction that we last modified
the inode in.

The biggest cool part of this is that it requires no changes to the recovery
code, so if you fsync with this patch and crash and load an old kernel, it
will run the recovery and be a-ok.  I have tested this pretty thoroughly
with an fsync tester and everything comes back fine, as well as xfstests.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/btrfs_inode.h |    1 +
 fs/btrfs/ctree.h       |    8 ++-
 fs/btrfs/extent_map.c  |   34 +++++++-
 fs/btrfs/extent_map.h  |    5 +-
 fs/btrfs/file.c        |   37 ++++++---
 fs/btrfs/inode.c       |  120 ++++++++++++++++++++++++--
 fs/btrfs/ioctl.c       |    4 +-
 fs/btrfs/tree-log.c    |  220 ++++++++++++++++++++++++++++++++++++++++++++++--
 8 files changed, 394 insertions(+), 35 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 5b2ad6b..7c7bf81 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -38,6 +38,7 @@
 #define BTRFS_INODE_DELALLOC_META_RESERVED	4
 #define BTRFS_INODE_HAS_ORPHAN_ITEM		5
 #define BTRFS_INODE_HAS_ASYNC_EXTENT		6
+#define BTRFS_INODE_NEEDS_FULL_SYNC		7
 
 /* in memory btrfs inode */
 struct btrfs_inode {
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0d195b5..f99cda1 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3315,9 +3315,13 @@ int btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info);
 int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync);
 int btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
 			    int skip_pinned);
+int btrfs_replace_extent_cache(struct inode *inode, struct extent_map *replace,
+			       u64 start, u64 end, int skip_pinned,
+			       int modified);
 extern const struct file_operations btrfs_file_operations;
-int btrfs_drop_extents(struct btrfs_trans_handle *trans, struct inode *inode,
-		       u64 start, u64 end, u64 *hint_byte, int drop_cache);
+int btrfs_drop_extents(struct btrfs_trans_handle *trans,
+		       struct btrfs_root *root, struct inode *inode, u64 start,
+		       u64 end, u64 *hint_byte, int drop_cache);
 int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 			      struct inode *inode, u64 start, u64 end);
 int btrfs_release_file(struct inode *inode, struct file *file);
diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 7c97b33..1fe82cf 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -35,6 +35,7 @@ void extent_map_exit(void)
 void extent_map_tree_init(struct extent_map_tree *tree)
 {
 	tree->map = RB_ROOT;
+	INIT_LIST_HEAD(&tree->modified_extents);
 	rwlock_init(&tree->lock);
 }
 
@@ -54,7 +55,9 @@ struct extent_map *alloc_extent_map(void)
 	em->in_tree = 0;
 	em->flags = 0;
 	em->compress_type = BTRFS_COMPRESS_NONE;
+	em->generation = 0;
 	atomic_set(&em->refs, 1);
+	INIT_LIST_HEAD(&em->list);
 	return em;
 }
 
@@ -72,6 +75,7 @@ void free_extent_map(struct extent_map *em)
 	WARN_ON(atomic_read(&em->refs) == 0);
 	if (atomic_dec_and_test(&em->refs)) {
 		WARN_ON(em->in_tree);
+		WARN_ON(!list_empty(&em->list));
 		kmem_cache_free(extent_map_cache, em);
 	}
 }
@@ -198,6 +202,12 @@ static void try_merge_map(struct extent_map_tree *tree, struct extent_map *em)
 			em->block_len += merge->block_len;
 			em->block_start = merge->block_start;
 			merge->in_tree = 0;
+			if (merge->generation > em->generation) {
+				em->generation = merge->generation;
+				list_move(&em->list, &tree->modified_extents);
+			}
+
+			list_del_init(&merge->list);
 			rb_erase(&merge->rb_node, &tree->map);
 			free_extent_map(merge);
 		}
@@ -211,11 +221,29 @@ static void try_merge_map(struct extent_map_tree *tree, struct extent_map *em)
 		em->block_len += merge->len;
 		rb_erase(&merge->rb_node, &tree->map);
 		merge->in_tree = 0;
+		if (merge->generation > em->generation) {
+			em->generation = merge->generation;
+			list_move(&em->list, &tree->modified_extents);
+		}
+		list_del_init(&merge->list);
 		free_extent_map(merge);
 	}
 }
 
-int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len)
+/**
+ * unpint_extent_cache - unpin an extent from the cache
+ * @tree:	tree to unpin the extent in
+ * @start:	logical offset in the file
+ * @len:	length of the extent
+ * @gen:	generation that this extent has been modified in
+ * @prealloc:	if this is set we need to clear the prealloc flag
+ *
+ * Called after an extent has been written to disk properly.  Set the generation
+ * to the generation that actually added the file item to the inode so we know
+ * we need to sync this extent when we call fsync().
+ */
+int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len,
+		       u64 gen)
 {
 	int ret = 0;
 	struct extent_map *em;
@@ -228,10 +256,11 @@ int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len)
 	if (!em)
 		goto out;
 
+	list_move(&em->list, &tree->modified_extents);
+	em->generation = gen;
 	clear_bit(EXTENT_FLAG_PINNED, &em->flags);
 
 	try_merge_map(tree, em);
-
 	free_extent_map(em);
 out:
 	write_unlock(&tree->lock);
@@ -358,6 +387,7 @@ int remove_extent_mapping(struct extent_map_tree *tree, struct extent_map *em)
 
 	WARN_ON(test_bit(EXTENT_FLAG_PINNED, &em->flags));
 	rb_erase(&em->rb_node, &tree->map);
+	list_del_init(&em->list);
 	em->in_tree = 0;
 	return ret;
 }
diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index 1195f09..2388a60 100644
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -23,15 +23,18 @@ struct extent_map {
 	u64 orig_start;
 	u64 block_start;
 	u64 block_len;
+	u64 generation;
 	unsigned long flags;
 	struct block_device *bdev;
 	atomic_t refs;
 	unsigned int in_tree;
 	unsigned int compress_type;
+	struct list_head list;
 };
 
 struct extent_map_tree {
 	struct rb_root map;
+	struct list_head modified_extents;
 	rwlock_t lock;
 };
 
@@ -60,7 +63,7 @@ struct extent_map *alloc_extent_map(void);
 void free_extent_map(struct extent_map *em);
 int __init extent_map_init(void);
 void extent_map_exit(void);
-int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len);
+int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len, u64 gen);
 struct extent_map *search_extent_mapping(struct extent_map_tree *tree,
 					 u64 start, u64 len);
 #endif
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index b7c885c..90cc039 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -459,13 +459,14 @@ int btrfs_dirty_pages(struct btrfs_root *root, struct inode *inode,
  * [start, end].  Existing extents are split as required.
  */
 int btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
-			    int skip_pinned)
+			       int skip_pinned)
 {
 	struct extent_map *em;
 	struct extent_map *split = NULL;
 	struct extent_map *split2 = NULL;
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
 	u64 len = end - start + 1;
+	u64 gen;
 	int ret;
 	int testend = 1;
 	unsigned long flags;
@@ -490,6 +491,7 @@ int btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
 			break;
 		}
 		flags = em->flags;
+		gen = em->generation;
 		if (skip_pinned && test_bit(EXTENT_FLAG_PINNED, &em->flags)) {
 			if (testend && em->start + em->len >= start + len) {
 				free_extent_map(em);
@@ -518,12 +520,13 @@ int btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
 				split->block_len = em->block_len;
 			else
 				split->block_len = split->len;
-
+			split->generation = gen;
 			split->bdev = em->bdev;
 			split->flags = flags;
 			split->compress_type = em->compress_type;
 			ret = add_extent_mapping(em_tree, split);
 			BUG_ON(ret); /* Logic error */
+			list_move(&split->list, &em_tree->modified_extents);
 			free_extent_map(split);
 			split = split2;
 			split2 = NULL;
@@ -537,6 +540,7 @@ int btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
 			split->bdev = em->bdev;
 			split->flags = flags;
 			split->compress_type = em->compress_type;
+			split->generation = gen;
 
 			if (compressed) {
 				split->block_len = em->block_len;
@@ -550,6 +554,7 @@ int btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
 
 			ret = add_extent_mapping(em_tree, split);
 			BUG_ON(ret); /* Logic error */
+			list_move(&split->list, &em_tree->modified_extents);
 			free_extent_map(split);
 			split = NULL;
 		}
@@ -576,10 +581,10 @@ int btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
  * it is either truncated or split.  Anything entirely inside the range
  * is deleted from the tree.
  */
-int btrfs_drop_extents(struct btrfs_trans_handle *trans, struct inode *inode,
-		       u64 start, u64 end, u64 *hint_byte, int drop_cache)
+int btrfs_drop_extents(struct btrfs_trans_handle *trans,
+		       struct btrfs_root *root, struct inode *inode, u64 start,
+		       u64 end, u64 *hint_byte, int drop_cache)
 {
-	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct extent_buffer *leaf;
 	struct btrfs_file_extent_item *fi;
 	struct btrfs_path *path;
@@ -597,6 +602,7 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans, struct inode *inode,
 	int recow;
 	int ret;
 	int modify_tree = -1;
+	int update_refs = (root->ref_cows || root == root->fs_info->tree_root);
 
 	if (drop_cache)
 		btrfs_drop_extent_cache(inode, start, end - 1, 0);
@@ -707,7 +713,7 @@ next_slot:
 							extent_end - start);
 			btrfs_mark_buffer_dirty(leaf);
 
-			if (disk_bytenr > 0) {
+			if (update_refs && disk_bytenr > 0) {
 				ret = btrfs_inc_extent_ref(trans, root,
 						disk_bytenr, num_bytes, 0,
 						root->root_key.objectid,
@@ -734,7 +740,7 @@ next_slot:
 			btrfs_set_file_extent_num_bytes(leaf, fi,
 							extent_end - end);
 			btrfs_mark_buffer_dirty(leaf);
-			if (disk_bytenr > 0) {
+			if (update_refs && disk_bytenr > 0) {
 				inode_sub_bytes(inode, end - key.offset);
 				*hint_byte = disk_bytenr;
 			}
@@ -753,7 +759,7 @@ next_slot:
 			btrfs_set_file_extent_num_bytes(leaf, fi,
 							start - key.offset);
 			btrfs_mark_buffer_dirty(leaf);
-			if (disk_bytenr > 0) {
+			if (update_refs && disk_bytenr > 0) {
 				inode_sub_bytes(inode, extent_end - start);
 				*hint_byte = disk_bytenr;
 			}
@@ -777,12 +783,13 @@ next_slot:
 				del_nr++;
 			}
 
-			if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
+			if (update_refs &&
+			    extent_type == BTRFS_FILE_EXTENT_INLINE) {
 				inode_sub_bytes(inode,
 						extent_end - key.offset);
 				extent_end = ALIGN(extent_end,
 						   root->sectorsize);
-			} else if (disk_bytenr > 0) {
+			} else if (update_refs && disk_bytenr > 0) {
 				ret = btrfs_free_extent(trans, root,
 						disk_bytenr, num_bytes, 0,
 						root->root_key.objectid,
@@ -892,8 +899,6 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 	int ret;
 	u64 ino = btrfs_ino(inode);
 
-	btrfs_drop_extent_cache(inode, start, end - 1, 0);
-
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
@@ -1556,6 +1561,14 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	    BTRFS_I(inode)->last_trans <=
 	    root->fs_info->last_trans_committed) {
 		BTRFS_I(inode)->last_trans = 0;
+
+		/*
+		 * We'v had everything committed since the last time we were
+		 * modified so clear this flag in case it was set for whatever
+		 * reason, it's no longer relevant.
+		 */
+		clear_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
+			  &BTRFS_I(inode)->runtime_flags);
 		mutex_unlock(&inode->i_mutex);
 		goto out;
 	}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 273b987..de8e057 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -248,7 +248,7 @@ static noinline int cow_file_range_inline(struct btrfs_trans_handle *trans,
 		return 1;
 	}
 
-	ret = btrfs_drop_extents(trans, inode, start, aligned_end,
+	ret = btrfs_drop_extents(trans, root, inode, start, aligned_end,
 				 &hint_byte, 1);
 	if (ret)
 		return ret;
@@ -1804,7 +1804,8 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	 * the caller is expected to unpin it and allow it to be merged
 	 * with the others.
 	 */
-	ret = btrfs_drop_extents(trans, inode, file_pos, file_pos + num_bytes,
+	ret = btrfs_drop_extents(trans, root, inode, file_pos,
+				 file_pos + num_bytes,
 				 &hint, 0);
 	if (ret)
 		goto out;
@@ -1927,11 +1928,10 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 						ordered_extent->len,
 						compress_type, 0, 0,
 						BTRFS_FILE_EXTENT_REG);
-		unpin_extent_cache(&BTRFS_I(inode)->extent_tree,
-				   ordered_extent->file_offset,
-				   ordered_extent->len);
 	}
-
+	unpin_extent_cache(&BTRFS_I(inode)->extent_tree,
+			   ordered_extent->file_offset, ordered_extent->len,
+			   trans->transid);
 	if (ret < 0) {
 		btrfs_abort_transaction(trans, root, ret);
 		goto out_unlock;
@@ -2590,6 +2590,18 @@ static void btrfs_read_locked_inode(struct inode *inode)
 
 	inode_set_bytes(inode, btrfs_inode_nbytes(leaf, inode_item));
 	BTRFS_I(inode)->generation = btrfs_inode_generation(leaf, inode_item);
+	BTRFS_I(inode)->last_trans = btrfs_inode_transid(leaf, inode_item);
+
+	/*
+	 * If we were modified in the current generation and evicted from memory
+	 * and then re-read we need to do a full sync since we don't have any
+	 * idea about which extents were modified before we were evicted from
+	 * cache.
+	 */
+	if (BTRFS_I(inode)->last_trans == root->fs_info->generation)
+		set_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
+			&BTRFS_I(inode)->runtime_flags);
+
 	inode->i_version = btrfs_inode_sequence(leaf, inode_item);
 	inode->i_generation = BTRFS_I(inode)->generation;
 	inode->i_rdev = 0;
@@ -3267,8 +3279,13 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 	path->reada = -1;
 
+	/*
+	 * We want to drop from the next block forward in case this new size is
+	 * not block aligned since we will be keeping the last block of the
+	 * extent just the way it is.
+	 */
 	if (root->ref_cows || root == root->fs_info->tree_root)
-		btrfs_drop_extent_cache(inode, new_size & (~mask), (u64)-1, 0);
+		btrfs_drop_extent_cache(inode, (new_size + mask) & (~mask), (u64)-1, 0);
 
 	/*
 	 * This function is also used to drop the items in the log tree before
@@ -3577,6 +3594,7 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct extent_map *em = NULL;
 	struct extent_state *cached_state = NULL;
+	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
 	u64 mask = root->sectorsize - 1;
 	u64 hole_start = (oldsize + mask) & ~mask;
 	u64 block_end = (size + mask) & ~mask;
@@ -3613,6 +3631,7 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
 		last_byte = min(extent_map_end(em), block_end);
 		last_byte = (last_byte + mask) & ~mask;
 		if (!test_bit(EXTENT_FLAG_PREALLOC, &em->flags)) {
+			struct extent_map *hole_em;
 			u64 hint_byte = 0;
 			hole_size = last_byte - cur_offset;
 
@@ -3622,7 +3641,8 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
 				break;
 			}
 
-			err = btrfs_drop_extents(trans, inode, cur_offset,
+			err = btrfs_drop_extents(trans, root, inode,
+						 cur_offset,
 						 cur_offset + hole_size,
 						 &hint_byte, 1);
 			if (err) {
@@ -3641,9 +3661,39 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
 				break;
 			}
 
-			btrfs_drop_extent_cache(inode, hole_start,
-					last_byte - 1, 0);
+			btrfs_drop_extent_cache(inode, cur_offset,
+						cur_offset + hole_size - 1, 0);
+			hole_em = alloc_extent_map();
+			if (!hole_em) {
+				set_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
+					&BTRFS_I(inode)->runtime_flags);
+				goto next;
+			}
+			hole_em->start = cur_offset;
+			hole_em->len = hole_size;
+			hole_em->orig_start = cur_offset;
+
+			hole_em->block_start = EXTENT_MAP_HOLE;
+			hole_em->block_len = 0;
+			hole_em->bdev = root->fs_info->fs_devices->latest_bdev;
+			hole_em->compress_type = BTRFS_COMPRESS_NONE;
+			hole_em->generation = trans->transid;
 
+			while (1) {
+				write_lock(&em_tree->lock);
+				err = add_extent_mapping(em_tree, hole_em);
+				if (!err)
+					list_move(&hole_em->list,
+						  &em_tree->modified_extents);
+				write_unlock(&em_tree->lock);
+				if (err != -EEXIST)
+					break;
+				btrfs_drop_extent_cache(inode, cur_offset,
+							cur_offset +
+							hole_size - 1, 0);
+			}
+			free_extent_map(hole_em);
+next:
 			btrfs_update_inode(trans, root, inode);
 			btrfs_end_transaction(trans, root);
 		}
@@ -4671,6 +4721,14 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	BTRFS_I(inode)->generation = trans->transid;
 	inode->i_generation = BTRFS_I(inode)->generation;
 
+	/*
+	 * We could have gotten an inode number from somebody who was fsynced
+	 * and then removed in this same transaction, so let's just set full
+	 * sync since it will be a full sync anyway and this will blow away the
+	 * old info in the log.
+	 */
+	set_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &BTRFS_I(inode)->runtime_flags);
+
 	if (S_ISDIR(mode))
 		owner = 0;
 	else
@@ -6821,6 +6879,15 @@ static int btrfs_truncate(struct inode *inode)
 					   &BTRFS_I(inode)->runtime_flags))
 		btrfs_add_ordered_operation(trans, root, inode);
 
+	/*
+	 * So if we truncate and then write and fsync we normally would just
+	 * write the extents that changed, which is a problem if we need to
+	 * first truncate that entire inode.  So set this flag so we write out
+	 * all of the extents in the inode to the sync log so we're completely
+	 * safe.
+	 */
+	set_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &BTRFS_I(inode)->runtime_flags);
+
 	while (1) {
 		ret = btrfs_block_rsv_refill(root, rsv, min_size);
 		if (ret) {
@@ -7500,6 +7567,8 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 				       loff_t actual_len, u64 *alloc_hint,
 				       struct btrfs_trans_handle *trans)
 {
+	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
+	struct extent_map *em;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_key ins;
 	u64 cur_offset = start;
@@ -7540,6 +7609,37 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 		btrfs_drop_extent_cache(inode, cur_offset,
 					cur_offset + ins.offset -1, 0);
 
+		em = alloc_extent_map();
+		if (!em) {
+			set_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
+				&BTRFS_I(inode)->runtime_flags);
+			goto next;
+		}
+
+		em->start = cur_offset;
+		em->orig_start = cur_offset;
+		em->len = ins.offset;
+		em->block_start = ins.objectid;
+		em->block_len = ins.offset;
+		em->bdev = root->fs_info->fs_devices->latest_bdev;
+		set_bit(EXTENT_FLAG_PREALLOC, &em->flags);
+		em->generation = trans->transid;
+
+		while (1) {
+			write_lock(&em_tree->lock);
+			ret = add_extent_mapping(em_tree, em);
+			if (!ret)
+				list_move(&em->list,
+					  &em_tree->modified_extents);
+			write_unlock(&em_tree->lock);
+			if (ret != -EEXIST)
+				break;
+			btrfs_drop_extent_cache(inode, cur_offset,
+						cur_offset + ins.offset - 1,
+						0);
+		}
+		free_extent_map(em);
+next:
 		num_bytes -= ins.offset;
 		cur_offset += ins.offset;
 		*alloc_hint = ins.objectid + ins.offset;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9df50fa..9522322 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2576,7 +2576,7 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 					datal -= off - key.offset;
 				}
 
-				ret = btrfs_drop_extents(trans, inode,
+				ret = btrfs_drop_extents(trans, root, inode,
 							 new_key.offset,
 							 new_key.offset + datal,
 							 &hint_byte, 1);
@@ -2650,7 +2650,7 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 				size -= skip + trim;
 				datal -= skip + trim;
 
-				ret = btrfs_drop_extents(trans, inode,
+				ret = btrfs_drop_extents(trans, root, inode,
 							 new_key.offset,
 							 new_key.offset + datal,
 							 &hint_byte, 1);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c86670f..5190cd6 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -18,6 +18,7 @@
 
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/list_sort.h>
 #include "ctree.h"
 #include "transaction.h"
 #include "disk-io.h"
@@ -550,7 +551,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 
 	saved_nbytes = inode_get_bytes(inode);
 	/* drop any overlapping extents */
-	ret = btrfs_drop_extents(trans, inode, start, extent_end,
+	ret = btrfs_drop_extents(trans, root, inode, start, extent_end,
 				 &alloc_hint, 1);
 	BUG_ON(ret);
 
@@ -2803,6 +2804,194 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+static int extent_cmp(void *priv, struct list_head *a, struct list_head *b)
+{
+	struct extent_map *em1, *em2;
+
+	em1 = list_entry(a, struct extent_map, list);
+	em2 = list_entry(b, struct extent_map, list);
+
+	if (em1->start < em2->start)
+		return -1;
+	else if (em1->start > em2->start)
+		return 1;
+	return 0;
+}
+
+struct log_args {
+	struct extent_buffer *src;
+	u64 next_offset;
+	int start_slot;
+	int nr;
+};
+
+static int log_one_extent(struct btrfs_trans_handle *trans,
+			  struct inode *inode, struct btrfs_root *root,
+			  struct extent_map *em, struct btrfs_path *path,
+			  struct btrfs_path *dst_path, struct log_args *args)
+{
+	struct btrfs_root *log = root->log_root;
+	struct btrfs_file_extent_item *fi;
+	struct btrfs_key key;
+	u64 start = em->start;
+	u64 len = em->len;
+	u64 num_bytes;
+	int nritems;
+	int ret;
+
+	if (BTRFS_I(inode)->logged_trans == trans->transid) {
+		u64 tmp;
+		ret = btrfs_drop_extents(trans, log, inode, start,
+					 start + len, &tmp, 0);
+		if (ret)
+			return ret;
+	}
+
+	while (len) {
+		if (args->nr)
+			goto next_slot;
+		key.objectid = btrfs_ino(inode);
+		key.type = BTRFS_EXTENT_DATA_KEY;
+		key.offset = start;
+
+		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+		if (ret < 0)
+			return ret;
+		if (ret) {
+			/*
+			 * This shouldn't happen, but it might so warn and
+			 * return an error.
+			 */
+			WARN_ON(1);
+			return -ENOENT;
+		}
+		args->src = path->nodes[0];
+next_slot:
+		fi = btrfs_item_ptr(args->src, path->slots[0],
+				    struct btrfs_file_extent_item);
+		if (args->nr &&
+		    args->start_slot + args->nr == path->slots[0]) {
+			args->nr++;
+		} else if (args->nr) {
+			ret = copy_items(trans, log, dst_path, args->src,
+					 args->start_slot, args->nr,
+					 LOG_INODE_ALL);
+			if (ret)
+				return ret;
+			args->nr = 1;
+			args->start_slot = path->slots[0];
+		} else if (!args->nr) {
+			args->nr = 1;
+			args->start_slot = path->slots[0];
+		}
+		nritems = btrfs_header_nritems(path->nodes[0]);
+		path->slots[0]++;
+		num_bytes = btrfs_file_extent_num_bytes(args->src, fi);
+		if (len < num_bytes) {
+			/* I _think_ this is ok, envision we write to a
+			 * preallocated space that is adjacent to a previously
+			 * written preallocated space that gets merged when we
+			 * mark this preallocated space written.  If we do not
+			 * have the adjacent extent in cache then when we copy
+			 * this extent it could end up being larger than our EM
+			 * thinks it is, which is a-ok, so just set len to 0.
+			 */
+			len = 0;
+		} else {
+			len -= num_bytes;
+		}
+		start += btrfs_file_extent_num_bytes(args->src, fi);
+		args->next_offset = start;
+
+		if (path->slots[0] < nritems) {
+			if (len)
+				goto next_slot;
+			break;
+		}
+
+		if (args->nr) {
+			ret = copy_items(trans, log, dst_path, args->src,
+					 args->start_slot, args->nr,
+					 LOG_INODE_ALL);
+			if (ret)
+				return ret;
+			args->nr = 0;
+			btrfs_release_path(path);
+		}
+	}
+
+	return 0;
+}
+
+static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
+				     struct btrfs_root *root,
+				     struct inode *inode,
+				     struct btrfs_path *path,
+				     struct btrfs_path *dst_path)
+{
+	struct log_args args;
+	struct btrfs_root *log = root->log_root;
+	struct extent_map *em, *n;
+	struct list_head extents;
+	struct extent_map_tree *tree = &BTRFS_I(inode)->extent_tree;
+	u64 test_gen;
+	int ret = 0;
+
+	INIT_LIST_HEAD(&extents);
+
+	memset(&args, 0, sizeof(args));
+
+	write_lock(&tree->lock);
+	test_gen = root->fs_info->last_trans_committed;
+
+	list_for_each_entry_safe(em, n, &tree->modified_extents, list) {
+		list_del_init(&em->list);
+		if (em->generation <= test_gen)
+			continue;
+		list_add_tail(&em->list, &extents);
+	}
+
+	list_sort(NULL, &extents, extent_cmp);
+
+	while (!list_empty(&extents)) {
+		em = list_entry(extents.next, struct extent_map, list);
+
+		list_del_init(&em->list);
+
+		/*
+		 * If we had an error we just need to delete everybody from our
+		 * private list.
+		 */
+		if (ret)
+			continue;
+
+		/*
+		 * If the previous EM and the last extent we left off on aren't
+		 * sequential then we need to copy the items we have and redo
+		 * our search
+		 */
+		if (args.nr && em->start != args.next_offset) {
+			ret = copy_items(trans, log, dst_path, args.src,
+					 args.start_slot, args.nr,
+					 LOG_INODE_ALL);
+			if (ret)
+				continue;
+			btrfs_release_path(path);
+			args.nr = 0;
+		}
+
+		ret = log_one_extent(trans, inode, root, em, path, dst_path, &args);
+	}
+
+	if (!ret && args.nr)
+		ret = copy_items(trans, log, dst_path, args.src,
+				 args.start_slot, args.nr, LOG_INODE_ALL);
+	btrfs_release_path(path);
+	WARN_ON(!list_empty(&extents));
+	write_unlock(&tree->lock);
+	return ret;
+}
+
 /* log a single inode in the tree log.
  * At least one parent directory for this inode must exist in the tree
  * or be logged already.
@@ -2832,6 +3021,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 	int nritems;
 	int ins_start_slot = 0;
 	int ins_nr;
+	bool fast_search = false;
 	u64 ino = btrfs_ino(inode);
 
 	log = root->log_root;
@@ -2851,10 +3041,8 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 
 	max_key.objectid = ino;
 
-	/* today the code can only do partial logging of directories */
-	if (!S_ISDIR(inode->i_mode))
-	    inode_only = LOG_INODE_ALL;
 
+	/* today the code can only do partial logging of directories */
 	if (inode_only == LOG_INODE_EXISTS || S_ISDIR(inode->i_mode))
 		max_key.type = BTRFS_XATTR_ITEM_KEY;
 	else
@@ -2881,7 +3069,16 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 			max_key_type = BTRFS_XATTR_ITEM_KEY;
 		ret = drop_objectid_items(trans, log, path, ino, max_key_type);
 	} else {
-		ret = btrfs_truncate_inode_items(trans, log, inode, 0, 0);
+		if (test_and_clear_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
+				       &BTRFS_I(inode)->runtime_flags)) {
+			ret = btrfs_truncate_inode_items(trans, log,
+							 inode, 0, 0);
+		} else {
+			fast_search = true;
+			max_key.type = BTRFS_XATTR_ITEM_KEY;
+			ret = drop_objectid_items(trans, log, path, ino,
+						  BTRFS_XATTR_ITEM_KEY);
+		}
 	}
 	if (ret) {
 		err = ret;
@@ -2960,7 +3157,18 @@ next_slot:
 		}
 		ins_nr = 0;
 	}
-	WARN_ON(ins_nr);
+
+	if (fast_search) {
+		btrfs_release_path(path);
+		btrfs_release_path(dst_path);
+		ret = btrfs_log_changed_extents(trans, root, inode, path,
+						dst_path);
+		if (ret) {
+			err = ret;
+			goto out_unlock;
+		}
+	}
+
 	if (inode_only == LOG_INODE_ALL && S_ISDIR(inode->i_mode)) {
 		btrfs_release_path(path);
 		btrfs_release_path(dst_path);
-- 
1.7.7.6

