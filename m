From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [RFC][PATCH 2/2] Btrfs: snapshot-aware defragmentation
Date: Fri, 19 Aug 2011 16:25:18 +0800
Message-ID: <4E4E1DEE.2070203@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Note this patch is not complete. I send it out early to make sure this
is the right way to implement this feature.

When we defrag a file, btrfs will read the file data into memory and mark
the memory dirty. When writeback kicks off, file data will be re-written
to disk. This is how defragmentation works.

To make defrag snapshot-aware:

- when mark the memory dirty, we also add a defrag flag
- when writeback starts, we check the defrag flag
- If the flag is set, we find out all the backrefs for the extent that is
  to be re-written
- After writeback, we change the backrefs to point to the new extent

This patch makes use of extent backref iteration functions provided by
Jan Schmidt.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c        |   16 ++-
 fs/btrfs/extent_io.h        |    2 +
 fs/btrfs/file.c             |    4 +-
 fs/btrfs/free-space-cache.c |    7 +-
 fs/btrfs/inode.c            |  400 ++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/ioctl.c            |   13 +-
 6 files changed, 419 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d418164..168f8f8 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -928,7 +928,17 @@ int clear_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
 {
 	return clear_extent_bit(tree, start, end,
 				EXTENT_DIRTY | EXTENT_DELALLOC |
-				EXTENT_DO_ACCOUNTING, 0, 0, NULL, mask);
+				EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
+				0, 0, NULL, mask);
+}
+
+int set_extent_defrag(struct extent_io_tree *tree, u64 start, u64 end,
+		      struct extent_state **cached_state, gfp_t mask)
+{
+	return set_extent_bit(tree, start, end,
+			      EXTENT_DELALLOC | EXTENT_DIRTY |
+			      EXTENT_UPTODATE | EXTENT_DEFRAG,
+			      0, NULL, cached_state, mask);
 }
 
 int set_extent_new(struct extent_io_tree *tree, u64 start, u64 end,
@@ -2628,7 +2638,7 @@ int extent_invalidatepage(struct extent_io_tree *tree,
 	wait_on_page_writeback(page);
 	clear_extent_bit(tree, start, end,
 			 EXTENT_LOCKED | EXTENT_DIRTY | EXTENT_DELALLOC |
-			 EXTENT_DO_ACCOUNTING,
+			 EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
 			 1, 1, &cached_state, GFP_NOFS);
 	return 0;
 }
@@ -2703,7 +2713,7 @@ int try_release_extent_mapping(struct extent_map_tree *map,
 			}
 			if (!test_range_bit(tree, em->start,
 					    extent_map_end(em) - 1,
-					    EXTENT_LOCKED | EXTENT_WRITEBACK,
+					    EXTENT_LOCKED,
 					    0, NULL)) {
 				remove_extent_mapping(map, em);
 				/* once for the rb tree */
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 7b2f0c3..889b675 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -216,6 +216,8 @@ int clear_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
 		       gfp_t mask);
 int set_extent_delalloc(struct extent_io_tree *tree, u64 start, u64 end,
 			struct extent_state **cached_state, gfp_t mask);
+int set_extent_defrag(struct extent_io_tree *tree, u64 start, u64 end,
+			struct extent_state **cached_state, gfp_t mask);
 int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
 			  u64 *start_ret, u64 *end_ret, int bits);
 struct extent_state *find_first_extent_bit_state(struct extent_io_tree *tree,
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 658d669..e1cb0ba 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1129,8 +1129,8 @@ again:
 
 		clear_extent_bit(&BTRFS_I(inode)->io_tree, start_pos,
 				  last_pos - 1, EXTENT_DIRTY | EXTENT_DELALLOC |
-				  EXTENT_DO_ACCOUNTING, 0, 0, &cached_state,
-				  GFP_NOFS);
+				  EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
+				  0, 0, &cached_state, GFP_NOFS);
 		unlock_extent_cached(&BTRFS_I(inode)->io_tree,
 				     start_pos, last_pos - 1, &cached_state,
 				     GFP_NOFS);
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 6377713..e171b45 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -801,7 +801,8 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 		ret = -1;
 		clear_extent_bit(&BTRFS_I(inode)->io_tree, 0, bytes - 1,
 				 EXTENT_DIRTY | EXTENT_DELALLOC |
-				 EXTENT_DO_ACCOUNTING, 0, 0, NULL, GFP_NOFS);
+				 EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
+				 0, 0, NULL, GFP_NOFS);
 		goto out;
 	}
 	leaf = path->nodes[0];
@@ -815,8 +816,8 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 			ret = -1;
 			clear_extent_bit(&BTRFS_I(inode)->io_tree, 0, bytes - 1,
 					 EXTENT_DIRTY | EXTENT_DELALLOC |
-					 EXTENT_DO_ACCOUNTING, 0, 0, NULL,
-					 GFP_NOFS);
+					 EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
+					 0, 0, NULL, GFP_NOFS);
 			btrfs_release_path(path);
 			goto out;
 		}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 15fceef..d725731 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -53,6 +53,7 @@
 #include "locking.h"
 #include "free-space-cache.h"
 #include "inode-map.h"
+#include "backref.h"
 
 struct btrfs_iget_args {
 	u64 ino;
@@ -1698,6 +1699,362 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
+struct extent_backref {
+	struct list_head list;
+	u64 root_id;
+	u64 inum;
+	u64 offset;
+	u64 generation;
+};
+
+struct old_extent {
+	struct list_head list;
+	struct list_head head;
+	u64 old_bytenr;
+	u64 offset;
+	u64 len;
+	u64 new_bytenr;
+	struct inode *inode;
+	struct btrfs_path *path;
+};
+
+struct relink_work {
+	struct work_struct work;
+	struct list_head head;
+};
+
+static int add_one_backref(u64 inum, u64 offset, u64 root_id, void *ctx)
+{
+	struct old_extent *ex = ctx;
+	struct inode *inode = ex->inode;
+	struct btrfs_path *path = ex->path;
+	struct btrfs_key key;
+	struct btrfs_fs_info *fs_info;
+	struct btrfs_file_extent_item *extent;
+	struct btrfs_root *root;
+	struct extent_backref *backref;
+	int ret;
+
+	if (BTRFS_I(inode)->root->root_key.objectid == root_id &&
+	    inum == btrfs_ino(inode))
+		return 0;
+
+	key.objectid = root_id;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = (u64)-1;
+
+	fs_info = BTRFS_I(inode)->root->fs_info;
+	root = btrfs_read_fs_root_no_name(fs_info, &key);
+	if (IS_ERR(root))
+		return PTR_ERR(root);
+
+	key.objectid = inum;
+	key.type = BTRFS_EXTENT_DATA_KEY;
+	key.offset = offset;
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0) {
+		return ret;
+	} else if (ret > 0) {
+		btrfs_release_path(path);
+		return -ENOENT;
+	}
+
+	extent = btrfs_item_ptr(path->nodes[0], path->slots[0],
+				struct btrfs_file_extent_item);
+
+	if (btrfs_file_extent_disk_bytenr(path->nodes[0], extent) !=
+		ex->old_bytenr) {
+		btrfs_release_path(path);
+		return 0;
+	}
+
+	backref = kmalloc(sizeof(*backref), GFP_NOFS);
+	if (!backref)
+		goto out;
+
+	backref->root_id = root_id;
+	backref->inum = inum;
+	backref->offset = offset;
+	backref->generation = btrfs_file_extent_generation(path->nodes[0], extent);
+	list_add_tail(&backref->list, &ex->head);
+out:
+	return 0;
+}
+
+static void __find_extent_backrefs(struct list_head *head, struct inode *inode)
+{
+	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	struct old_extent *ex;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return;
+
+	list_for_each_entry(ex, head, list) {
+		ex->path = path;
+
+		ret = extent_from_logical(fs_info, ex->old_bytenr, path, &key);
+		if (ret >= 0) {
+			iterate_extent_inodes(fs_info, path, key.objectid, 0,
+					      add_one_backref, ex);
+		}
+	}
+
+	btrfs_free_path(path);
+}
+
+static void find_extent_backrefs(struct list_head *head, struct inode *inode,
+				 u64 file_offset, u64 file_end, u64 new_bytenr)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	struct old_extent *ex, *tmp;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return;
+
+	key.objectid = btrfs_ino(inode);
+	key.type = BTRFS_EXTENT_DATA_KEY;
+	key.offset = file_offset;
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0)
+		goto fail;
+	if (ret > 0 && path->slots[0] > 0)
+		path->slots[0]--;
+
+	while (1) {
+		struct btrfs_file_extent_item *extent;
+		struct extent_buffer *l;
+		int slot;
+		u64 num_bytes;
+		u64 offset;
+		u64 end;
+
+		l = path->nodes[0];
+		slot = path->slots[0];
+
+		if (slot >= btrfs_header_nritems(l)) {
+			ret = btrfs_next_leaf(root, path);
+			if (ret < 0)
+				goto fail;
+			else if (ret > 0)
+				break;
+			continue;
+		}
+
+		btrfs_item_key_to_cpu(l, &key, slot);
+
+		if (key.objectid != btrfs_ino(inode))
+			break;
+		if (key.type != BTRFS_EXTENT_DATA_KEY)
+			break;
+		if (key.offset >= file_end)
+			break;
+
+		extent = btrfs_item_ptr(l, slot, struct btrfs_file_extent_item);
+
+		num_bytes = btrfs_file_extent_num_bytes(l, extent);
+		if (key.offset + num_bytes < file_offset)
+			goto next;
+
+		ex = kmalloc(sizeof(*ex), GFP_NOFS);
+		if (!ex)
+			goto fail;
+
+		offset = max(file_offset, key.offset);
+		end = min(file_end, key.offset + num_bytes);
+
+		ex->old_bytenr = btrfs_file_extent_disk_bytenr(l, extent);
+		ex->offset = offset - key.offset;
+		ex->len = end - offset;
+		ex->new_bytenr = new_bytenr + offset - file_offset;
+		ex->inode = inode;
+		INIT_LIST_HEAD(&ex->head);
+
+		list_add_tail(&ex->list, head);
+next:
+		path->slots[0]++;
+	}
+
+	btrfs_free_path(path);
+
+	__find_extent_backrefs(head, inode);
+
+	return;
+
+fail:
+	list_for_each_entry_safe(ex, tmp, head, list) {
+		list_del(&ex->list);
+		kfree(ex);
+	}
+	btrfs_free_path(path);
+}
+
+static void relink_extent_backref(struct btrfs_path *path, struct old_extent *ex,
+				  struct extent_backref *backref)
+{
+	struct btrfs_file_extent_item *extent;
+	struct btrfs_file_extent_item *item;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_fs_info *fs_info;
+	struct btrfs_root *root;
+	struct btrfs_key key;
+	struct extent_buffer *leaf;
+	struct inode *src_inode = ex->inode;
+	struct inode *inode;
+	int ret = 0;
+	u64 hint_byte;
+
+	key.objectid = backref->root_id;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = (u64)-1;
+
+	fs_info = BTRFS_I(src_inode)->root->fs_info;
+	root = btrfs_read_fs_root_no_name(fs_info, &key);
+	if (IS_ERR(root))
+		return;
+
+	key.objectid = backref->inum;
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.offset = 0;
+
+	inode = btrfs_iget(fs_info->sb, &key, root, NULL);
+	if (IS_ERR_OR_NULL(inode) || is_bad_inode(inode)) {
+		if (inode && !IS_ERR(inode))
+			iput(inode);
+		return;
+	}
+
+	while (1) {
+		struct btrfs_ordered_extent *ordered;
+
+		lock_extent(&BTRFS_I(inode)->io_tree, backref->offset, ex->len,
+				GFP_NOFS);
+		ordered = btrfs_lookup_first_ordered_extent(inode,
+							backref->offset + ex->len);
+		if (!ordered && !test_range_bit(&BTRFS_I(inode)->io_tree,
+					backref->offset, backref->offset + ex->len,
+					EXTENT_DELALLOC, 0, NULL))
+			break;
+		unlock_extent(&BTRFS_I(inode)->io_tree, backref->offset,
+				backref->offset + ex->len, GFP_NOFS);
+		if (ordered)
+			btrfs_put_ordered_extent(ordered);
+		btrfs_wait_ordered_range(inode, backref->offset,
+					backref->offset + ex->len);
+	}
+
+	trans = btrfs_start_transaction(root, 2);
+	if (IS_ERR(trans))
+		goto out;
+
+	key.objectid = backref->inum;
+	key.type = BTRFS_EXTENT_DATA_KEY;
+	key.offset = backref->offset;
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+	else if (ret > 0)
+		goto out2;
+
+	extent = btrfs_item_ptr(path->nodes[0], path->slots[0],
+				struct btrfs_file_extent_item);
+
+	if (btrfs_file_extent_generation(path->nodes[0], extent) !=
+	    backref->generation)
+		goto out2;
+
+	btrfs_release_path(path);
+
+	ret = btrfs_drop_extents(trans, inode, backref->offset,
+				 backref->offset + ex->len, &hint_byte, 1);
+	BUG_ON(ret);
+
+	key.objectid = btrfs_ino(inode);
+	key.type = BTRFS_EXTENT_DATA_KEY;
+	key.offset = backref->offset;
+
+	ret = btrfs_insert_empty_item(trans, root, path, &key,
+					sizeof(*extent));
+	BUG_ON(ret);
+
+	leaf = path->nodes[0];
+	item = btrfs_item_ptr(leaf, path->slots[0],
+				struct btrfs_file_extent_item);
+	btrfs_set_file_extent_disk_bytenr(leaf, item, ex->new_bytenr);
+	btrfs_set_file_extent_disk_num_bytes(leaf, item, ex->len);
+	btrfs_set_file_extent_offset(leaf, item, 0);
+	btrfs_set_file_extent_num_bytes(leaf, item, ex->len);
+	btrfs_set_file_extent_ram_bytes(leaf, item, ex->len);
+	btrfs_set_file_extent_generation(leaf, item, trans->transid);
+	btrfs_set_file_extent_type(leaf, item, BTRFS_FILE_EXTENT_REG);
+	btrfs_set_file_extent_compression(leaf, item, 0);
+	btrfs_set_file_extent_encryption(leaf, item, 0);
+	btrfs_set_file_extent_other_encoding(leaf, item, 0);
+
+	btrfs_mark_buffer_dirty(leaf);
+
+	inode_add_bytes(inode, ex->len);
+	ret = btrfs_inc_extent_ref(trans, root, ex->new_bytenr, ex->len, 0,
+			root->root_key.objectid, btrfs_ino(inode), 0);
+	BUG_ON(ret);
+
+	btrfs_end_transaction(trans, root);
+out2:
+	btrfs_release_path(path);
+out:
+	unlock_extent(&BTRFS_I(inode)->io_tree, backref->offset,
+			backref->offset + ex->len, GFP_NOFS);
+	iput(inode);
+}
+
+static void relink_file_extent(struct btrfs_path *path, struct old_extent *ex)
+{
+	struct extent_backref *backref, *tmp;
+
+	list_for_each_entry_safe(backref, tmp, &ex->head, list) {
+		list_del(&backref->list);
+
+		relink_extent_backref(path, ex, backref);
+
+		kfree(backref);
+	}
+}
+
+static void relink_file_extents(struct work_struct *work)
+{
+	struct relink_work *rwork;
+	struct btrfs_path *path;
+	struct old_extent *old, *tmp;
+
+	rwork = container_of(work, struct relink_work, work);
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return;
+
+	list_for_each_entry_safe(old, tmp, &rwork->head, list) {
+		list_del(&old->list);
+
+		relink_file_extent(path, old);
+
+		kfree(old);
+	}
+
+	btrfs_free_path(path);
+
+	kfree(rwork);
+}
+
 /*
  * helper function for btrfs_finish_ordered_io, this
  * just reads in some of the csum leaves to prime them into ram
@@ -1715,6 +2072,7 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 	struct btrfs_ordered_extent *ordered_extent = NULL;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct extent_state *cached_state = NULL;
+	struct relink_work *work = NULL;
 	int compress_type = 0;
 	int ret;
 	bool nolock;
@@ -1747,6 +2105,20 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 			 ordered_extent->file_offset + ordered_extent->len - 1,
 			 0, &cached_state, GFP_NOFS);
 
+	ret = test_range_bit(io_tree, ordered_extent->file_offset,
+			ordered_extent->file_offset + ordered_extent->len - 1,
+			EXTENT_DEFRAG, 1, cached_state);
+	if (ret) {
+		work = kmalloc(sizeof(*work), GFP_NOFS);
+		if (work) {
+			INIT_LIST_HEAD(&work->head);
+			find_extent_backrefs(&work->head, inode,
+				   ordered_extent->file_offset,
+				   ordered_extent->file_offset + ordered_extent->len,
+				   ordered_extent->start);
+		}
+	}
+
 	if (nolock)
 		trans = btrfs_join_transaction_nolock(root);
 	else
@@ -1778,6 +2150,7 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 				   ordered_extent->len);
 		BUG_ON(ret);
 	}
+
 	unlock_extent_cached(io_tree, ordered_extent->file_offset,
 			     ordered_extent->file_offset +
 			     ordered_extent->len - 1, &cached_state, GFP_NOFS);
@@ -1801,6 +2174,11 @@ out:
 			btrfs_end_transaction(trans, root);
 	}
 
+	if (work) {
+		INIT_WORK(&work->work, relink_file_extents);
+		schedule_work(&work->work);
+	}
+
 	/* once for us */
 	btrfs_put_ordered_extent(ordered_extent);
 	/* once for the tree */
@@ -3420,7 +3798,8 @@ again:
 	}
 
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, page_start, page_end,
-			  EXTENT_DIRTY | EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING,
+			  EXTENT_DIRTY | EXTENT_DELALLOC |
+			  EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
 			  0, 0, &cached_state, GFP_NOFS);
 
 	ret = btrfs_set_extent_delalloc(inode, page_start, page_end,
@@ -5664,8 +6043,9 @@ must_cow:
 	len = min(len, em->len - (start - em->start));
 unlock:
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, start, start + len - 1,
-			  EXTENT_LOCKED | EXTENT_DELALLOC | EXTENT_DIRTY, 1,
-			  0, NULL, GFP_NOFS);
+			  EXTENT_LOCKED | EXTENT_DELALLOC |
+			  EXTENT_DIRTY | EXTENT_DEFRAG,
+			  1, 0, NULL, GFP_NOFS);
 map:
 	bh_result->b_blocknr = (em->block_start + (start - em->start)) >>
 		inode->i_blkbits;
@@ -6229,7 +6609,8 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 	 * the dirty or uptodate bits
 	 */
 	if (writing) {
-		write_bits = EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING;
+		write_bits = EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING |
+				EXTENT_DEFRAG;
 		ret = set_extent_bit(&BTRFS_I(inode)->io_tree, lockstart, lockend,
 				     EXTENT_DELALLOC, 0, NULL, &cached_state,
 				     GFP_NOFS);
@@ -6372,7 +6753,8 @@ static void btrfs_invalidatepage(struct page *page, unsigned long offset)
 		 */
 		clear_extent_bit(tree, page_start, page_end,
 				 EXTENT_DIRTY | EXTENT_DELALLOC |
-				 EXTENT_LOCKED | EXTENT_DO_ACCOUNTING, 1, 0,
+				 EXTENT_DEFRAG | EXTENT_LOCKED |
+				 EXTENT_DO_ACCOUNTING, 1, 0,
 				 &cached_state, GFP_NOFS);
 		/*
 		 * whoever cleared the private bit is responsible
@@ -6388,8 +6770,9 @@ static void btrfs_invalidatepage(struct page *page, unsigned long offset)
 				 GFP_NOFS);
 	}
 	clear_extent_bit(tree, page_start, page_end,
-		 EXTENT_LOCKED | EXTENT_DIRTY | EXTENT_DELALLOC |
-		 EXTENT_DO_ACCOUNTING, 1, 1, &cached_state, GFP_NOFS);
+			 EXTENT_LOCKED | EXTENT_DIRTY | EXTENT_DELALLOC |
+			 EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG, 1, 1,
+			 &cached_state, GFP_NOFS);
 	__btrfs_releasepage(page, GFP_NOFS);
 
 	ClearPageChecked(page);
@@ -6479,7 +6862,8 @@ again:
 	 * prepare_pages in the normal write path.
 	 */
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, page_start, page_end,
-			  EXTENT_DIRTY | EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING,
+			  EXTENT_DIRTY | EXTENT_DELALLOC |
+			  EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
 			  0, 0, &cached_state, GFP_NOFS);
 
 	ret = btrfs_set_extent_delalloc(inode, page_start, page_end,
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7cf0133..347fce8a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -924,10 +924,10 @@ again:
 	if (ordered)
 		btrfs_put_ordered_extent(ordered);
 
-	clear_extent_bit(&BTRFS_I(inode)->io_tree, page_start,
-			  page_end - 1, EXTENT_DIRTY | EXTENT_DELALLOC |
-			  EXTENT_DO_ACCOUNTING, 0, 0, &cached_state,
-			  GFP_NOFS);
+	clear_extent_bit(&BTRFS_I(inode)->io_tree, page_start, page_end - 1,
+			  EXTENT_DIRTY | EXTENT_DELALLOC |
+			  EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG, 0, 0,
+			  &cached_state, GFP_NOFS);
 
 	if (i_done != num_pages) {
 		spin_lock(&BTRFS_I(inode)->lock);
@@ -937,9 +937,8 @@ again:
 				     (num_pages - i_done) << PAGE_CACHE_SHIFT);
 	}
 
-
-	btrfs_set_extent_delalloc(inode, page_start, page_end - 1,
-				  &cached_state);
+	set_extent_defrag(&BTRFS_I(inode)->io_tree, page_start, page_end - 1,
+			  &cached_state, GFP_NOFS);
 
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree,
 			     page_start, page_end - 1, &cached_state,
-- 
1.7.3.1
