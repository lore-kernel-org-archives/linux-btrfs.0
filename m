From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] btrfs: make things static and include the right headers
Date: Thu, 20 Nov 2008 19:36:15 +0100
Message-ID: <20081120183615.GA20770@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Shut up various sparse warnings about symbols that should be either
static or have their declarations in scope.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: btrfs-unstable/fs/btrfs/disk-io.c
===================================================================
--- btrfs-unstable.orig/fs/btrfs/disk-io.c	2008-11-20 07:32:30.000000000 +0100
+++ btrfs-unstable/fs/btrfs/disk-io.c	2008-11-20 19:28:26.000000000 +0100
@@ -92,9 +92,9 @@ struct async_submit_bio {
  * extents on the btree inode are pretty simple, there's one extent
  * that covers the entire device
  */
-struct extent_map *btree_get_extent(struct inode *inode, struct page *page,
-				    size_t page_offset, u64 start, u64 len,
-				    int create)
+static struct extent_map *btree_get_extent(struct inode *inode,
+		struct page *page, size_t page_offset, u64 start, u64 len,
+		int create)
 {
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
 	struct extent_map *em;
@@ -294,7 +294,7 @@ printk("read extent buffer pages failed 
  * checksum a dirty tree block before IO.  This has extra checks to make
  * sure we only fill in the checksum field in the first page of a multi-page block
  */
-int csum_dirty_buffer(struct btrfs_root *root, struct page *page)
+static int csum_dirty_buffer(struct btrfs_root *root, struct page *page)
 {
 	struct extent_io_tree *tree;
 	u64 start = (u64)page->index << PAGE_CACHE_SHIFT;
@@ -364,7 +364,7 @@ static int check_tree_block_fsid(struct 
 	return ret;
 }
 
-int btree_readpage_end_io_hook(struct page *page, u64 start, u64 end,
+static int btree_readpage_end_io_hook(struct page *page, u64 start, u64 end,
 			       struct extent_state *state)
 {
 	struct extent_io_tree *tree;
@@ -659,7 +659,7 @@ static int btree_writepages(struct addre
 	return extent_writepages(tree, mapping, btree_get_extent, wbc);
 }
 
-int btree_readpage(struct file *file, struct page *page)
+static int btree_readpage(struct file *file, struct page *page)
 {
 	struct extent_io_tree *tree;
 	tree = &BTRFS_I(page->mapping->host)->io_tree;
@@ -1199,7 +1199,7 @@ static void __unplug_io_fn(struct backin
 	}
 }
 
-void btrfs_unplug_io_fn(struct backing_dev_info *bdi, struct page *page)
+static void btrfs_unplug_io_fn(struct backing_dev_info *bdi, struct page *page)
 {
 	struct inode *inode;
 	struct extent_map_tree *em_tree;
@@ -1836,7 +1836,7 @@ static void btrfs_end_buffer_write_sync(
 	put_bh(bh);
 }
 
-int write_all_supers(struct btrfs_root *root)
+static int write_all_supers(struct btrfs_root *root)
 {
 	struct list_head *cur;
 	struct list_head *head = &root->fs_info->fs_devices->devices;
Index: btrfs-unstable/fs/btrfs/extent-tree.c
===================================================================
--- btrfs-unstable.orig/fs/btrfs/extent-tree.c	2008-11-20 07:32:30.000000000 +0100
+++ btrfs-unstable/fs/btrfs/extent-tree.c	2008-11-20 19:28:26.000000000 +0100
@@ -72,7 +72,7 @@ static int block_group_bits(struct btrfs
  * this adds the block group to the fs_info rb tree for the block group
  * cache
  */
-int btrfs_add_block_group_cache(struct btrfs_fs_info *info,
+static int btrfs_add_block_group_cache(struct btrfs_fs_info *info,
 				struct btrfs_block_group_cache *block_group)
 {
 	struct rb_node **p;
@@ -287,7 +287,7 @@ err:
 /*
  * return the block group that starts at or after bytenr
  */
-struct btrfs_block_group_cache *btrfs_lookup_first_block_group(struct
+static struct btrfs_block_group_cache *btrfs_lookup_first_block_group(struct
 						       btrfs_fs_info *info,
 							 u64 bytenr)
 {
@@ -3440,7 +3440,7 @@ static int noinline cache_drop_leaf_ref(
 	return 0;
 }
 
-int drop_snap_lookup_refcount(struct btrfs_root *root, u64 start, u64 len,
+static int drop_snap_lookup_refcount(struct btrfs_root *root, u64 start, u64 len,
 			      u32 *refs)
 {
 	int ret;
@@ -5429,7 +5429,7 @@ static u64 update_block_group_flags(stru
 	return flags;
 }
 
-int __alloc_chunk_for_shrink(struct btrfs_root *root,
+static int __alloc_chunk_for_shrink(struct btrfs_root *root,
 		     struct btrfs_block_group_cache *shrink_block_group,
 		     int force)
 {
@@ -5698,8 +5698,8 @@ out:
 	return ret;
 }
 
-int find_first_block_group(struct btrfs_root *root, struct btrfs_path *path,
-			   struct btrfs_key *key)
+static int find_first_block_group(struct btrfs_root *root,
+		struct btrfs_path *path, struct btrfs_key *key)
 {
 	int ret = 0;
 	struct btrfs_key found_key;
Index: btrfs-unstable/fs/btrfs/inode-item.c
===================================================================
--- btrfs-unstable.orig/fs/btrfs/inode-item.c	2008-11-20 07:28:51.000000000 +0100
+++ btrfs-unstable/fs/btrfs/inode-item.c	2008-11-20 19:28:26.000000000 +0100
@@ -20,7 +20,7 @@
 #include "disk-io.h"
 #include "transaction.h"
 
-int find_name_in_backref(struct btrfs_path *path, const char * name,
+static int find_name_in_backref(struct btrfs_path *path, const char *name,
 			 int name_len, struct btrfs_inode_ref **ref_ret)
 {
 	struct extent_buffer *leaf;
Index: btrfs-unstable/fs/btrfs/super.c
===================================================================
--- btrfs-unstable.orig/fs/btrfs/super.c	2008-11-20 07:32:30.000000000 +0100
+++ btrfs-unstable/fs/btrfs/super.c	2008-11-20 19:28:26.000000000 +0100
@@ -645,7 +645,7 @@ static int btrfs_interface_init(void)
 	return misc_register(&btrfs_misc);
 }
 
-void btrfs_interface_exit(void)
+static void btrfs_interface_exit(void)
 {
 	if (misc_deregister(&btrfs_misc) < 0)
 		printk("misc_deregister failed for control device");
Index: btrfs-unstable/fs/btrfs/ctree.c
===================================================================
--- btrfs-unstable.orig/fs/btrfs/ctree.c	2008-11-20 07:32:30.000000000 +0100
+++ btrfs-unstable/fs/btrfs/ctree.c	2008-11-20 19:28:26.000000000 +0100
@@ -217,7 +217,7 @@ int btrfs_copy_root(struct btrfs_trans_h
  * this uses that block instead of allocating a new one.  btrfs_alloc_reserved_extent
  * is used to finish the allocation.
  */
-int noinline __btrfs_cow_block(struct btrfs_trans_handle *trans,
+static int noinline __btrfs_cow_block(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
 			     struct extent_buffer *buf,
 			     struct extent_buffer *parent, int parent_slot,
Index: btrfs-unstable/fs/btrfs/extent_io.c
===================================================================
--- btrfs-unstable.orig/fs/btrfs/extent_io.c	2008-11-20 07:32:30.000000000 +0100
+++ btrfs-unstable/fs/btrfs/extent_io.c	2008-11-20 19:28:26.000000000 +0100
@@ -112,7 +112,7 @@ void extent_io_tree_init(struct extent_i
 }
 EXPORT_SYMBOL(extent_io_tree_init);
 
-struct extent_state *alloc_extent_state(gfp_t mask)
+static struct extent_state *alloc_extent_state(gfp_t mask)
 {
 	struct extent_state *state;
 #ifdef LEAK_DEBUG
@@ -136,7 +136,7 @@ struct extent_state *alloc_extent_state(
 }
 EXPORT_SYMBOL(alloc_extent_state);
 
-void free_extent_state(struct extent_state *state)
+static void free_extent_state(struct extent_state *state)
 {
 	if (!state)
 		return;
@@ -660,7 +660,7 @@ static void set_state_bits(struct extent
  * [start, end] is inclusive
  * This takes the tree lock.
  */
-int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits,
+static int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits,
 		   int exclusive, u64 *failed_start, gfp_t mask)
 {
 	struct extent_state *state;
@@ -877,12 +877,11 @@ int set_extent_new(struct extent_io_tree
 }
 EXPORT_SYMBOL(set_extent_new);
 
-int clear_extent_new(struct extent_io_tree *tree, u64 start, u64 end,
+static int clear_extent_new(struct extent_io_tree *tree, u64 start, u64 end,
 		       gfp_t mask)
 {
 	return clear_extent_bit(tree, start, end, EXTENT_NEW, 0, 0, mask);
 }
-EXPORT_SYMBOL(clear_extent_new);
 
 int set_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
 			gfp_t mask)
@@ -892,27 +891,24 @@ int set_extent_uptodate(struct extent_io
 }
 EXPORT_SYMBOL(set_extent_uptodate);
 
-int clear_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
+static int clear_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
 			  gfp_t mask)
 {
 	return clear_extent_bit(tree, start, end, EXTENT_UPTODATE, 0, 0, mask);
 }
-EXPORT_SYMBOL(clear_extent_uptodate);
 
-int set_extent_writeback(struct extent_io_tree *tree, u64 start, u64 end,
+static int set_extent_writeback(struct extent_io_tree *tree, u64 start, u64 end,
 			 gfp_t mask)
 {
 	return set_extent_bit(tree, start, end, EXTENT_WRITEBACK,
 			      0, NULL, mask);
 }
-EXPORT_SYMBOL(set_extent_writeback);
 
-int clear_extent_writeback(struct extent_io_tree *tree, u64 start, u64 end,
+static int clear_extent_writeback(struct extent_io_tree *tree, u64 start, u64 end,
 			   gfp_t mask)
 {
 	return clear_extent_bit(tree, start, end, EXTENT_WRITEBACK, 1, 0, mask);
 }
-EXPORT_SYMBOL(clear_extent_writeback);
 
 int wait_on_extent_writeback(struct extent_io_tree *tree, u64 start, u64 end)
 {
@@ -992,7 +988,7 @@ EXPORT_SYMBOL(set_range_dirty);
 /*
  * helper function to set both pages and extents in the tree writeback
  */
-int set_range_writeback(struct extent_io_tree *tree, u64 start, u64 end)
+static int set_range_writeback(struct extent_io_tree *tree, u64 start, u64 end)
 {
 	unsigned long index = start >> PAGE_CACHE_SHIFT;
 	unsigned long end_index = end >> PAGE_CACHE_SHIFT;
@@ -1008,7 +1004,6 @@ int set_range_writeback(struct extent_io
 	set_extent_writeback(tree, start, end, GFP_NOFS);
 	return 0;
 }
-EXPORT_SYMBOL(set_range_writeback);
 
 /*
  * find the first offset in the io tree with 'bits' set. zero is
@@ -1430,11 +1425,13 @@ out:
 	spin_unlock_irq(&tree->lock);
 	return total_bytes;
 }
+
+#if 0
 /*
  * helper function to lock both pages and extents in the tree.
  * pages must be locked first.
  */
-int lock_range(struct extent_io_tree *tree, u64 start, u64 end)
+static int lock_range(struct extent_io_tree *tree, u64 start, u64 end)
 {
 	unsigned long index = start >> PAGE_CACHE_SHIFT;
 	unsigned long end_index = end >> PAGE_CACHE_SHIFT;
@@ -1471,12 +1468,11 @@ failed:
 	}
 	return err;
 }
-EXPORT_SYMBOL(lock_range);
 
 /*
  * helper function to unlock both pages and extents in the tree.
  */
-int unlock_range(struct extent_io_tree *tree, u64 start, u64 end)
+static int unlock_range(struct extent_io_tree *tree, u64 start, u64 end)
 {
 	unsigned long index = start >> PAGE_CACHE_SHIFT;
 	unsigned long end_index = end >> PAGE_CACHE_SHIFT;
@@ -1491,7 +1487,7 @@ int unlock_range(struct extent_io_tree *
 	unlock_extent(tree, start, end, GFP_NOFS);
 	return 0;
 }
-EXPORT_SYMBOL(unlock_range);
+#endif
 
 /*
  * set the private field for a given byte offset in the tree.  If there isn't
@@ -1954,7 +1950,7 @@ void set_page_extent_mapped(struct page 
 }
 EXPORT_SYMBOL(set_page_extent_mapped);
 
-void set_page_extent_head(struct page *page, unsigned long len)
+static void set_page_extent_head(struct page *page, unsigned long len)
 {
 	set_page_private(page, EXTENT_PAGE_PRIVATE_FIRST_PAGE | len << 2);
 }
@@ -2395,7 +2391,7 @@ update_nr_written:
  * WB_SYNC_ALL then we were called for data integrity and we must wait for
  * existing IO to complete.
  */
-int extent_write_cache_pages(struct extent_io_tree *tree,
+static int extent_write_cache_pages(struct extent_io_tree *tree,
 			     struct address_space *mapping,
 			     struct writeback_control *wbc,
 			     writepage_t writepage, void *data,
@@ -2499,7 +2495,6 @@ retry:
 	}
 	return ret;
 }
-EXPORT_SYMBOL(extent_write_cache_pages);
 
 static noinline void flush_write_bio(void *data)
 {
Index: btrfs-unstable/fs/btrfs/free-space-cache.c
===================================================================
--- btrfs-unstable.orig/fs/btrfs/free-space-cache.c	2008-11-20 07:28:51.000000000 +0100
+++ btrfs-unstable/fs/btrfs/free-space-cache.c	2008-11-20 19:28:26.000000000 +0100
@@ -443,7 +443,8 @@ void btrfs_remove_free_space_cache(struc
 	mutex_unlock(&block_group->alloc_mutex);
 }
 
-struct btrfs_free_space *btrfs_find_free_space_offset(struct
+#if 0
+static struct btrfs_free_space *btrfs_find_free_space_offset(struct
 						      btrfs_block_group_cache
 						      *block_group, u64 offset,
 						      u64 bytes)
@@ -458,7 +459,7 @@ struct btrfs_free_space *btrfs_find_free
 	return ret;
 }
 
-struct btrfs_free_space *btrfs_find_free_space_bytes(struct
+static struct btrfs_free_space *btrfs_find_free_space_bytes(struct
 						     btrfs_block_group_cache
 						     *block_group, u64 offset,
 						     u64 bytes)
@@ -472,6 +473,7 @@ struct btrfs_free_space *btrfs_find_free
 
 	return ret;
 }
+#endif
 
 struct btrfs_free_space *btrfs_find_free_space(struct btrfs_block_group_cache
 					       *block_group, u64 offset,
Index: btrfs-unstable/fs/btrfs/ioctl.c
===================================================================
--- btrfs-unstable.orig/fs/btrfs/ioctl.c	2008-11-20 07:32:30.000000000 +0100
+++ btrfs-unstable/fs/btrfs/ioctl.c	2008-11-20 19:35:12.000000000 +0100
@@ -353,7 +353,7 @@ out_unlock:
 }
 
 
-int btrfs_defrag_file(struct file *file)
+static int btrfs_defrag_file(struct file *file)
 {
 	struct inode *inode = fdentry(file)->d_inode;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -648,7 +648,7 @@ static int btrfs_ioctl_defrag(struct fil
 	return 0;
 }
 
-long btrfs_ioctl_add_dev(struct btrfs_root *root, void __user *arg)
+static long btrfs_ioctl_add_dev(struct btrfs_root *root, void __user *arg)
 {
 	struct btrfs_ioctl_vol_args *vol_args;
 	int ret;
@@ -670,7 +670,7 @@ out:
 	return ret;
 }
 
-long btrfs_ioctl_rm_dev(struct btrfs_root *root, void __user *arg)
+static long btrfs_ioctl_rm_dev(struct btrfs_root *root, void __user *arg)
 {
 	struct btrfs_ioctl_vol_args *vol_args;
 	int ret;
@@ -695,8 +695,8 @@ out:
 	return ret;
 }
 
-long btrfs_ioctl_clone(struct file *file, unsigned long srcfd, u64 off,
-		       u64 olen, u64 destoff)
+static long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
+		u64 off, u64 olen, u64 destoff)
 {
 	struct inode *inode = fdentry(file)->d_inode;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -1034,7 +1034,7 @@ out_fput:
 	return ret;
 }
 
-long btrfs_ioctl_clone_range(struct file *file, unsigned long argptr)
+static long btrfs_ioctl_clone_range(struct file *file, unsigned long argptr)
 {
 	struct btrfs_ioctl_clone_range_args args;
 
@@ -1050,7 +1050,7 @@ long btrfs_ioctl_clone_range(struct file
  * basically own the machine, and have a very in depth understanding
  * of all the possible deadlocks and enospc problems.
  */
-long btrfs_ioctl_trans_start(struct file *file)
+static long btrfs_ioctl_trans_start(struct file *file)
 {
 	struct inode *inode = fdentry(file)->d_inode;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
Index: btrfs-unstable/fs/btrfs/tree-log.c
===================================================================
--- btrfs-unstable.orig/fs/btrfs/tree-log.c	2008-11-20 07:28:51.000000000 +0100
+++ btrfs-unstable/fs/btrfs/tree-log.c	2008-11-20 19:28:26.000000000 +0100
@@ -23,6 +23,7 @@
 #include "locking.h"
 #include "print-tree.h"
 #include "compat.h"
+#include "tree-log.h"
 
 /* magic values for the inode_only field in btrfs_log_inode:
  *
@@ -78,7 +79,7 @@ static int __btrfs_log_inode(struct btrf
  * tree of log tree roots.  This must be called with a tree log transaction
  * running (see start_log_trans).
  */
-int btrfs_add_log_tree(struct btrfs_trans_handle *trans,
+static int btrfs_add_log_tree(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root)
 {
 	struct btrfs_key key;
@@ -1934,7 +1935,7 @@ static int walk_log_tree(struct btrfs_tr
 	return ret;
 }
 
-int wait_log_commit(struct btrfs_root *log)
+static int wait_log_commit(struct btrfs_root *log)
 {
 	DEFINE_WAIT(wait);
 	u64 transid = log->fs_info->tree_log_transid;
Index: btrfs-unstable/fs/btrfs/volumes.c
===================================================================
--- btrfs-unstable.orig/fs/btrfs/volumes.c	2008-11-20 07:32:30.000000000 +0100
+++ btrfs-unstable/fs/btrfs/volumes.c	2008-11-20 19:28:26.000000000 +0100
@@ -236,7 +236,7 @@ done:
 	return 0;
 }
 
-void pending_bios_fn(struct btrfs_work *work)
+static void pending_bios_fn(struct btrfs_work *work)
 {
 	struct btrfs_device *device;
 
@@ -684,7 +684,7 @@ error:
 	return ret;
 }
 
-int btrfs_free_dev_extent(struct btrfs_trans_handle *trans,
+static int btrfs_free_dev_extent(struct btrfs_trans_handle *trans,
 			  struct btrfs_device *device,
 			  u64 start)
 {
@@ -1391,7 +1391,7 @@ error:
 	goto out;
 }
 
-int noinline btrfs_update_device(struct btrfs_trans_handle *trans,
+static int noinline btrfs_update_device(struct btrfs_trans_handle *trans,
 				 struct btrfs_device *device)
 {
 	int ret;
@@ -1495,7 +1495,7 @@ static int btrfs_free_chunk(struct btrfs
 	return 0;
 }
 
-int btrfs_del_sys_chunk(struct btrfs_root *root, u64 chunk_objectid, u64
+static int btrfs_del_sys_chunk(struct btrfs_root *root, u64 chunk_objectid, u64
 			chunk_offset)
 {
 	struct btrfs_super_block *super_copy = &root->fs_info->super_copy;
@@ -1541,7 +1541,7 @@ int btrfs_del_sys_chunk(struct btrfs_roo
 	return ret;
 }
 
-int btrfs_relocate_chunk(struct btrfs_root *root,
+static int btrfs_relocate_chunk(struct btrfs_root *root,
 			 u64 chunk_tree, u64 chunk_objectid,
 			 u64 chunk_offset)
 {
@@ -1882,7 +1882,7 @@ done:
 	return ret;
 }
 
-int btrfs_add_system_chunk(struct btrfs_trans_handle *trans,
+static int btrfs_add_system_chunk(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   struct btrfs_key *key,
 			   struct btrfs_chunk *chunk, int item_size)
Index: btrfs-unstable/fs/btrfs/zlib.c
===================================================================
--- btrfs-unstable.orig/fs/btrfs/zlib.c	2008-11-20 07:32:30.000000000 +0100
+++ btrfs-unstable/fs/btrfs/zlib.c	2008-11-20 19:28:26.000000000 +0100
@@ -30,6 +30,7 @@
 #include <linux/sched.h>
 #include <linux/pagemap.h>
 #include <linux/bio.h>
+#include "compression.h"
 
 /* Plan: call deflate() with avail_in == *sourcelen,
 	avail_out = *dstlen - 12 and flush == Z_FINISH.
Index: btrfs-unstable/fs/btrfs/inode.c
===================================================================
--- btrfs-unstable.orig/fs/btrfs/inode.c	2008-11-20 07:32:30.000000000 +0100
+++ btrfs-unstable/fs/btrfs/inode.c	2008-11-20 19:34:30.000000000 +0100
@@ -1130,7 +1130,7 @@ static int run_delalloc_range(struct ino
  * bytes in this file, and to maintain the list of inodes that
  * have pending delalloc work to be done.
  */
-int btrfs_set_bit_hook(struct inode *inode, u64 start, u64 end,
+static int btrfs_set_bit_hook(struct inode *inode, u64 start, u64 end,
 		       unsigned long old, unsigned long bits)
 {
 	unsigned long flags;
@@ -1151,7 +1151,7 @@ int btrfs_set_bit_hook(struct inode *ino
 /*
  * extent_io.c clear_bit_hook, see set_bit_hook for why
  */
-int btrfs_clear_bit_hook(struct inode *inode, u64 start, u64 end,
+static int btrfs_clear_bit_hook(struct inode *inode, u64 start, u64 end,
 			 unsigned long old, unsigned long bits)
 {
 	if ((old & EXTENT_DELALLOC) && (bits & EXTENT_DELALLOC)) {
@@ -1215,7 +1215,7 @@ int btrfs_merge_bio_hook(struct page *pa
  * At IO completion time the cums attached on the ordered extent record
  * are inserted into the btree
  */
-int __btrfs_submit_bio_start(struct inode *inode, int rw, struct bio *bio,
+static int __btrfs_submit_bio_start(struct inode *inode, int rw, struct bio *bio,
 			  int mirror_num, unsigned long bio_flags)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -1234,7 +1234,7 @@ int __btrfs_submit_bio_start(struct inod
  * At IO completion time the cums attached on the ordered extent record
  * are inserted into the btree
  */
-int __btrfs_submit_bio_done(struct inode *inode, int rw, struct bio *bio,
+static int __btrfs_submit_bio_done(struct inode *inode, int rw, struct bio *bio,
 			  int mirror_num, unsigned long bio_flags)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -1245,7 +1245,7 @@ int __btrfs_submit_bio_done(struct inode
  * extent_io.c submission hook. This does the right thing for csum calculation on write,
  * or reading the csums from the tree before a read
  */
-int btrfs_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
+static int btrfs_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 			  int mirror_num, unsigned long bio_flags)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -1313,7 +1313,7 @@ struct btrfs_writepage_fixup {
 	struct btrfs_work work;
 };
 
-void btrfs_writepage_fixup_worker(struct btrfs_work *work)
+static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 {
 	struct btrfs_writepage_fixup *fixup;
 	struct btrfs_ordered_extent *ordered;
@@ -1372,7 +1372,7 @@ out_page:
  * to fix it up.  The async helper will wait for ordered extents, set
  * the delalloc bit and make it safe to write the page.
  */
-int btrfs_writepage_start_hook(struct page *page, u64 start, u64 end)
+static int btrfs_writepage_start_hook(struct page *page, u64 start, u64 end)
 {
 	struct inode *inode = page->mapping->host;
 	struct btrfs_writepage_fixup *fixup;
@@ -1526,7 +1526,7 @@ nocow:
 	return 0;
 }
 
-int btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
+static int btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
 				struct extent_state *state, int uptodate)
 {
 	return btrfs_finish_ordered_io(page->mapping->host, start, end);
@@ -1548,7 +1548,7 @@ struct io_failure_record {
 	int last_mirror;
 };
 
-int btrfs_io_failed_hook(struct bio *failed_bio,
+static int btrfs_io_failed_hook(struct bio *failed_bio,
 			 struct page *page, u64 start, u64 end,
 			 struct extent_state *state)
 {
@@ -1642,7 +1642,7 @@ int btrfs_io_failed_hook(struct bio *fai
  * each time an IO finishes, we do a fast check in the IO failure tree
  * to see if we need to process or clean up an io_failure_record
  */
-int btrfs_clean_io_failures(struct inode *inode, u64 start)
+static int btrfs_clean_io_failures(struct inode *inode, u64 start)
 {
 	u64 private;
 	u64 private_failure;
@@ -1675,7 +1675,7 @@ int btrfs_clean_io_failures(struct inode
  * if there's a match, we allow the bio to finish.  If not, we go through
  * the io_failure_record routines to find good copies
  */
-int btrfs_readpage_end_io_hook(struct page *page, u64 start, u64 end,
+static int btrfs_readpage_end_io_hook(struct page *page, u64 start, u64 end,
 			       struct extent_state *state)
 {
 	size_t offset = start - ((u64)page->index << PAGE_CACHE_SHIFT);
@@ -4362,8 +4362,8 @@ out:
  * Invalidate a single dcache entry at the root of the filesystem.
  * Needed after creation of snapshot or subvolume.
  */
-void btrfs_invalidate_dcache_root(struct inode *dir, char *name,
-				  int namelen)
+static void btrfs_invalidate_dcache_root(struct inode *dir,
+		char *name, int namelen)
 {
 	struct dentry *alias, *entry;
 	struct qstr qstr;
Index: btrfs-unstable/fs/btrfs/root-tree.c
===================================================================
--- btrfs-unstable.orig/fs/btrfs/root-tree.c	2008-11-20 19:33:51.000000000 +0100
+++ btrfs-unstable/fs/btrfs/root-tree.c	2008-11-20 19:34:07.000000000 +0100
@@ -276,7 +276,7 @@ out:
 	return ret;
 }
 
-int btrfs_del_root_ref(struct btrfs_trans_handle *trans,
+static int btrfs_del_root_ref(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *tree_root,
 		       u64 root_id, u8 type, u64 ref_id)
 {
