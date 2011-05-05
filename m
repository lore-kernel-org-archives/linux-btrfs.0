From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/3] btrfs: remove unused function prototypes
Date: Thu,  5 May 2011 15:39:58 +0200
Message-ID: <c91cdc139d9295fb1f3b7f54bebbdff448c8ffb1.1304595715.git.dsterba@suse.cz>
References: <cover.1304595715.git.dsterba@suse.cz>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1304595715.git.dsterba@suse.cz>
In-Reply-To: <cover.1304595715.git.dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

function prototypes without a body

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ctree.h       |   12 ------------
 fs/btrfs/delayed-ref.h |    5 -----
 fs/btrfs/disk-io.h     |   11 -----------
 fs/btrfs/extent_io.h   |    9 ---------
 fs/btrfs/transaction.h |    3 ---
 fs/btrfs/tree-log.h    |    1 -
 fs/btrfs/volumes.h     |    2 --
 7 files changed, 0 insertions(+), 43 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3f301f0..b66216e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2108,12 +2108,9 @@ int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 			     u64 num_bytes, u64 *refs, u64 *flags);
 int btrfs_pin_extent(struct btrfs_root *root,
 		     u64 bytenr, u64 num, int reserved);
-int btrfs_drop_leaf_ref(struct btrfs_trans_handle *trans,
-			struct btrfs_root *root, struct extent_buffer *leaf);
 int btrfs_cross_ref_exist(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root,
 			  u64 objectid, u64 offset, u64 bytenr);
-int btrfs_copy_pinned(struct btrfs_root *root, struct extent_io_tree *copy);
 struct btrfs_block_group_cache *btrfs_lookup_block_group(
 						 struct btrfs_fs_info *info,
 						 u64 bytenr);
@@ -2463,15 +2460,10 @@ int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
 			   struct btrfs_ordered_sum *sums);
 int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
 		       struct bio *bio, u64 file_start, int contig);
-int btrfs_csum_file_bytes(struct btrfs_root *root, struct inode *inode,
-			  u64 start, unsigned long len);
 struct btrfs_csum_item *btrfs_lookup_csum(struct btrfs_trans_handle *trans,
 					  struct btrfs_root *root,
 					  struct btrfs_path *path,
 					  u64 bytenr, int cow);
-int btrfs_csum_truncate(struct btrfs_trans_handle *trans,
-			struct btrfs_root *root, struct btrfs_path *path,
-			u64 isize);
 int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start,
 			     u64 end, struct list_head *list);
 /* inode.c */
@@ -2520,7 +2512,6 @@ unsigned long btrfs_force_ra(struct address_space *mapping,
 int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
 int btrfs_readpage(struct file *file, struct page *page);
 void btrfs_evict_inode(struct inode *inode);
-void btrfs_put_inode(struct inode *inode);
 int btrfs_write_inode(struct inode *inode, struct writeback_control *wbc);
 void btrfs_dirty_inode(struct inode *inode);
 struct inode *btrfs_alloc_inode(struct super_block *sb);
@@ -2531,8 +2522,6 @@ void btrfs_destroy_cachep(void);
 long btrfs_ioctl_trans_end(struct file *file);
 struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
 			 struct btrfs_root *root, int *was_new);
-int btrfs_commit_write(struct file *file, struct page *page,
-		       unsigned from, unsigned to);
 struct extent_map *btrfs_get_extent(struct inode *inode, struct page *page,
 				    size_t pg_offset, u64 start, u64 end,
 				    int create);
@@ -2571,7 +2560,6 @@ void btrfs_inherit_iflags(struct inode *inode, struct inode *dir);
 int btrfs_sync_file(struct file *file, int datasync);
 int btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
 			    int skip_pinned);
-int btrfs_check_file(struct btrfs_root *root, struct inode *inode);
 extern const struct file_operations btrfs_file_operations;
 int btrfs_drop_extents(struct btrfs_trans_handle *trans, struct inode *inode,
 		       u64 start, u64 end, u64 *hint_byte, int drop_cache);
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index 50e3cf9..946ed71 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -167,11 +167,6 @@ int btrfs_add_delayed_extent_op(struct btrfs_trans_handle *trans,
 struct btrfs_delayed_ref_head *
 btrfs_find_delayed_ref_head(struct btrfs_trans_handle *trans, u64 bytenr);
 int btrfs_delayed_ref_pending(struct btrfs_trans_handle *trans, u64 bytenr);
-int btrfs_update_delayed_ref(struct btrfs_trans_handle *trans,
-			  u64 bytenr, u64 num_bytes, u64 orig_parent,
-			  u64 parent, u64 orig_ref_root, u64 ref_root,
-			  u64 orig_ref_generation, u64 ref_generation,
-			  u64 owner_objectid, int pin);
 int btrfs_delayed_ref_lock(struct btrfs_trans_handle *trans,
 			   struct btrfs_delayed_ref_head *head);
 int btrfs_find_ref_cluster(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 07b20dc..758f3ca 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -65,25 +65,14 @@ struct btrfs_root *btrfs_read_fs_root_no_radix(struct btrfs_root *tree_root,
 struct btrfs_root *btrfs_read_fs_root_no_name(struct btrfs_fs_info *fs_info,
 					      struct btrfs_key *location);
 int btrfs_cleanup_fs_roots(struct btrfs_fs_info *fs_info);
-int btrfs_insert_dev_radix(struct btrfs_root *root,
-			   struct block_device *bdev,
-			   u64 device_id,
-			   u64 block_start,
-			   u64 num_blocks);
 void btrfs_btree_balance_dirty(struct btrfs_root *root, unsigned long nr);
 int btrfs_free_fs_root(struct btrfs_fs_info *fs_info, struct btrfs_root *root);
 void btrfs_mark_buffer_dirty(struct extent_buffer *buf);
-void btrfs_mark_buffer_dirty_nonblocking(struct extent_buffer *buf);
 int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid);
 int btrfs_set_buffer_uptodate(struct extent_buffer *buf);
-int wait_on_tree_block_writeback(struct btrfs_root *root,
-				 struct extent_buffer *buf);
 int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid);
 u32 btrfs_csum_data(struct btrfs_root *root, char *data, u32 seed, size_t len);
 void btrfs_csum_final(u32 crc, char *result);
-int btrfs_open_device(struct btrfs_device *dev);
-int btrfs_verify_block_csum(struct btrfs_root *root,
-			    struct extent_buffer *buf);
 int btrfs_bio_wq_end_io(struct btrfs_fs_info *info, struct bio *bio,
 			int metadata);
 int btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct inode *inode,
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 3c3be74..d1c5a57 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -215,14 +215,8 @@ int set_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
 		     gfp_t mask);
 int clear_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
 		       gfp_t mask);
-int clear_extent_ordered(struct extent_io_tree *tree, u64 start, u64 end,
-		       gfp_t mask);
-int clear_extent_ordered_metadata(struct extent_io_tree *tree, u64 start,
-				  u64 end, gfp_t mask);
 int set_extent_delalloc(struct extent_io_tree *tree, u64 start, u64 end,
 			struct extent_state **cached_state, gfp_t mask);
-int set_extent_ordered(struct extent_io_tree *tree, u64 start, u64 end,
-		     gfp_t mask);
 int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
 			  u64 *start_ret, u64 *end_ret, int bits);
 struct extent_state *find_first_extent_bit_state(struct extent_io_tree *tree,
@@ -298,8 +292,6 @@ int clear_extent_buffer_dirty(struct extent_io_tree *tree,
 			      struct extent_buffer *eb);
 int set_extent_buffer_dirty(struct extent_io_tree *tree,
 			     struct extent_buffer *eb);
-int test_extent_buffer_dirty(struct extent_io_tree *tree,
-			     struct extent_buffer *eb);
 int set_extent_buffer_uptodate(struct extent_io_tree *tree,
 			       struct extent_buffer *eb);
 int clear_extent_buffer_uptodate(struct extent_io_tree *tree,
@@ -317,7 +309,6 @@ int map_private_extent_buffer(struct extent_buffer *eb, unsigned long offset,
 		      unsigned long *map_start,
 		      unsigned long *map_len, int km);
 void unmap_extent_buffer(struct extent_buffer *eb, char *token, int km);
-int release_extent_buffer_tail_pages(struct extent_buffer *eb);
 int extent_range_uptodate(struct extent_io_tree *tree,
 			  u64 start, u64 end);
 int extent_clear_unlock_delalloc(struct inode *inode,
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index e441acc..000a410 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -101,11 +101,8 @@ struct btrfs_trans_handle *btrfs_start_ioctl_transaction(struct btrfs_root *r,
 int btrfs_wait_for_commit(struct btrfs_root *root, u64 transid);
 int btrfs_write_and_wait_transaction(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *root);
-int btrfs_commit_tree_roots(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root);
 
 int btrfs_add_dead_root(struct btrfs_root *root);
-int btrfs_drop_dead_root(struct btrfs_root *root);
 int btrfs_defrag_root(struct btrfs_root *root, int cacheonly);
 int btrfs_clean_old_snapshots(struct btrfs_root *root);
 int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/tree-log.h b/fs/btrfs/tree-log.h
index 3dfae84..2270ac5 100644
--- a/fs/btrfs/tree-log.h
+++ b/fs/btrfs/tree-log.h
@@ -38,7 +38,6 @@ int btrfs_del_inode_ref_in_log(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root,
 			       const char *name, int name_len,
 			       struct inode *inode, u64 dirid);
-int btrfs_join_running_log_trans(struct btrfs_root *root);
 int btrfs_end_log_trans(struct btrfs_root *root);
 int btrfs_pin_log_trans(struct btrfs_root *root);
 int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index cc2eada..036b276 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -209,8 +209,6 @@ int btrfs_add_device(struct btrfs_trans_handle *trans,
 int btrfs_rm_device(struct btrfs_root *root, char *device_path);
 int btrfs_cleanup_fs_uuids(void);
 int btrfs_num_copies(struct btrfs_mapping_tree *map_tree, u64 logical, u64 len);
-int btrfs_unplug_page(struct btrfs_mapping_tree *map_tree,
-		      u64 logical, struct page *page);
 int btrfs_grow_device(struct btrfs_trans_handle *trans,
 		      struct btrfs_device *device, u64 new_size);
 struct btrfs_device *btrfs_find_device(struct btrfs_root *root, u64 devid,
-- 
1.7.5.1.169.g505a1


