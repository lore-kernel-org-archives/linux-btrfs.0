Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932085Ab3DYUlE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Apr 2013 16:41:04 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3PKf43W025786
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2013 16:41:04 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r3PKf1DB014250
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2013 16:41:03 -0400
Message-ID: <517994DD.2080604@redhat.com>
Date: Thu, 25 Apr 2013 15:41:01 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V2] btrfs: make static code static & remove dead code
References: <51719932.6010406@redhat.com>
In-Reply-To: <51719932.6010406@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Big patch, but all it does is add statics to functions which
are in fact static, then remove the associated dead-code fallout.

removed functions:

btrfs_iref_to_path()
__btrfs_lookup_delayed_deletion_item()
__btrfs_search_delayed_insertion_item()
__btrfs_search_delayed_deletion_item()
find_eb_for_page()
btrfs_find_block_group()
range_straddles_pages()
extent_range_uptodate()
btrfs_file_extent_length()
btrfs_scrub_cancel_devid()
btrfs_start_transaction_lflush()

btrfs_print_tree() is left because it is used for debugging.
btrfs_start_transaction_lflush() and btrfs_reada_detach() are
left for symmetry.

ulist.c functions are left, another patch will take care of those.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Notes:

btrfs_iref_to_path users went away when extrefs came on the scene.

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 04b5b30..b4fb415 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1189,6 +1189,20 @@ int btrfs_find_one_extref(struct btrfs_root *root, u64 inode_objectid,
 	return ret;
 }
 
+/*
+ * this iterates to turn a name (from iref/extref) into a full filesystem path.
+ * Elements of the path are separated by '/' and the path is guaranteed to be
+ * 0-terminated. the path is only given within the current file system.
+ * Therefore, it never starts with a '/'. the caller is responsible to provide
+ * "size" bytes in "dest". the dest buffer will be filled backwards. finally,
+ * the start point of the resulting string is returned. this pointer is within
+ * dest, normally.
+ * in case the path buffer would overflow, the pointer is decremented further
+ * as if output was written to the buffer, though no more output is actually
+ * generated. that way, the caller can determine how much space would be
+ * required for the path to fit into the buffer. in that case, the returned
+ * value will be smaller than dest. callers must check this!
+ */
 char *btrfs_ref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
 			u32 name_len, unsigned long name_off,
 			struct extent_buffer *eb_in, u64 parent,
@@ -1258,32 +1272,6 @@ char *btrfs_ref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
 }
 
 /*
- * this iterates to turn a btrfs_inode_ref into a full filesystem path. elements
- * of the path are separated by '/' and the path is guaranteed to be
- * 0-terminated. the path is only given within the current file system.
- * Therefore, it never starts with a '/'. the caller is responsible to provide
- * "size" bytes in "dest". the dest buffer will be filled backwards. finally,
- * the start point of the resulting string is returned. this pointer is within
- * dest, normally.
- * in case the path buffer would overflow, the pointer is decremented further
- * as if output was written to the buffer, though no more output is actually
- * generated. that way, the caller can determine how much space would be
- * required for the path to fit into the buffer. in that case, the returned
- * value will be smaller than dest. callers must check this!
- */
-char *btrfs_iref_to_path(struct btrfs_root *fs_root,
-			 struct btrfs_path *path,
-			 struct btrfs_inode_ref *iref,
-			 struct extent_buffer *eb_in, u64 parent,
-			 char *dest, u32 size)
-{
-	return btrfs_ref_to_path(fs_root, path,
-				 btrfs_inode_ref_name_len(eb_in, iref),
-				 (unsigned long)(iref + 1),
-				 eb_in, parent, dest, size);
-}
-
-/*
  * this makes the path point to (logical EXTENT_ITEM *)
  * returns BTRFS_EXTENT_FLAG_DATA for data, BTRFS_EXTENT_FLAG_TREE_BLOCK for
  * tree blocks and <0 on error.
diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
index 310a7f6..0f446d7 100644
--- a/fs/btrfs/backref.h
+++ b/fs/btrfs/backref.h
@@ -59,9 +59,6 @@ int paths_from_inode(u64 inum, struct inode_fs_paths *ipath);
 int btrfs_find_all_roots(struct btrfs_trans_handle *trans,
 				struct btrfs_fs_info *fs_info, u64 bytenr,
 				u64 time_seq, struct ulist **roots);
-char *btrfs_iref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
-			 struct btrfs_inode_ref *iref, struct extent_buffer *eb,
-			 u64 parent, char *dest, u32 size);
 char *btrfs_ref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
 			u32 name_len, unsigned long name_off,
 			struct extent_buffer *eb_in, u64 parent,
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index b9c5650..b189bd1 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -82,6 +82,10 @@ struct compressed_bio {
 	u32 sums;
 };
 
+static int btrfs_decompress_biovec(int type, struct page **pages_in,
+				   u64 disk_start, struct bio_vec *bvec,
+				   int vcnt, size_t srclen);
+
 static inline int compressed_bio_size(struct btrfs_root *root,
 				      unsigned long disk_size)
 {
@@ -738,7 +742,7 @@ static int comp_num_workspace[BTRFS_COMPRESS_TYPES];
 static atomic_t comp_alloc_workspace[BTRFS_COMPRESS_TYPES];
 static wait_queue_head_t comp_workspace_wait[BTRFS_COMPRESS_TYPES];
 
-struct btrfs_compress_op *btrfs_compress_op[] = {
+static struct btrfs_compress_op *btrfs_compress_op[] = {
 	&btrfs_zlib_compress,
 	&btrfs_lzo_compress,
 };
@@ -909,8 +913,9 @@ int btrfs_compress_pages(int type, struct address_space *mapping,
  * be contiguous.  They all correspond to the range of bytes covered by
  * the compressed extent.
  */
-int btrfs_decompress_biovec(int type, struct page **pages_in, u64 disk_start,
-			    struct bio_vec *bvec, int vcnt, size_t srclen)
+static int btrfs_decompress_biovec(int type, struct page **pages_in,
+				   u64 disk_start, struct bio_vec *bvec,
+				   int vcnt, size_t srclen)
 {
 	struct list_head *workspace;
 	int ret;
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 9afb0a6..0c803b4 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -30,8 +30,6 @@ int btrfs_compress_pages(int type, struct address_space *mapping,
 			 unsigned long *total_in,
 			 unsigned long *total_out,
 			 unsigned long max_out);
-int btrfs_decompress_biovec(int type, struct page **pages_in, u64 disk_start,
-			    struct bio_vec *bvec, int vcnt, size_t srclen);
 int btrfs_decompress(int type, unsigned char *data_in, struct page *dest_page,
 		     unsigned long start_byte, size_t srclen, size_t destlen);
 int btrfs_decompress_buf2page(char *buf, unsigned long buf_start,
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index a17d999..de6de8e 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -41,12 +41,7 @@ static void del_ptr(struct btrfs_root *root, struct btrfs_path *path,
 		    int level, int slot);
 static void tree_mod_log_free_eb(struct btrfs_fs_info *fs_info,
 				 struct extent_buffer *eb);
-struct extent_buffer *read_old_tree_block(struct btrfs_root *root, u64 bytenr,
-					  u32 blocksize, u64 parent_transid,
-					  u64 time_seq);
-struct extent_buffer *btrfs_find_old_tree_block(struct btrfs_root *root,
-						u64 bytenr, u32 blocksize,
-						u64 time_seq);
+static int btrfs_prev_leaf(struct btrfs_root *root, struct btrfs_path *path);
 
 struct btrfs_path *btrfs_alloc_path(void)
 {
@@ -208,7 +203,7 @@ struct extent_buffer *btrfs_lock_root_node(struct btrfs_root *root)
  * tree until you end up with a lock on the root.  A locked buffer
  * is returned, with a reference held.
  */
-struct extent_buffer *btrfs_read_lock_root_node(struct btrfs_root *root)
+static struct extent_buffer *btrfs_read_lock_root_node(struct btrfs_root *root)
 {
 	struct extent_buffer *eb;
 
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8624f49..26c1914 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3046,8 +3046,6 @@ struct btrfs_block_group_cache *btrfs_lookup_block_group(
 						 struct btrfs_fs_info *info,
 						 u64 bytenr);
 void btrfs_put_block_group(struct btrfs_block_group_cache *cache);
-u64 btrfs_find_block_group(struct btrfs_root *root,
-			   u64 search_start, u64 search_hint, int owner);
 struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 					struct btrfs_root *root, u32 blocksize,
 					u64 parent, u64 root_objectid,
@@ -3057,10 +3055,6 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   struct extent_buffer *buf,
 			   u64 parent, int last_ref);
-struct extent_buffer *btrfs_init_new_buffer(struct btrfs_trans_handle *trans,
-					    struct btrfs_root *root,
-					    u64 bytenr, u32 blocksize,
-					    int level);
 int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *root,
 				     u64 root_objectid, u64 owner,
@@ -3113,7 +3107,6 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root, u64 group_start);
 void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans,
 				       struct btrfs_root *root);
-u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags);
 u64 btrfs_get_alloc_profile(struct btrfs_root *root, int data);
 void btrfs_clear_space_info_full(struct btrfs_fs_info *info);
 
@@ -3302,7 +3295,6 @@ static inline int btrfs_next_item(struct btrfs_root *root, struct btrfs_path *p)
 {
 	return btrfs_next_old_item(root, p, 0);
 }
-int btrfs_prev_leaf(struct btrfs_root *root, struct btrfs_path *path);
 int btrfs_leaf_free_space(struct btrfs_root *root, struct extent_buffer *leaf);
 int __must_check btrfs_drop_snapshot(struct btrfs_root *root,
 				     struct btrfs_block_rsv *block_rsv,
@@ -3397,9 +3389,6 @@ struct btrfs_dir_item *
 btrfs_search_dir_index_item(struct btrfs_root *root,
 			    struct btrfs_path *path, u64 dirid,
 			    const char *name, int name_len);
-struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_root *root,
-			      struct btrfs_path *path,
-			      const char *name, int name_len);
 int btrfs_delete_one_dir_name(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root,
 			      struct btrfs_path *path,
@@ -3477,16 +3466,11 @@ int btrfs_lookup_file_extent(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
 			     struct btrfs_path *path, u64 objectid,
 			     u64 bytenr, int mod);
-u64 btrfs_file_extent_length(struct btrfs_path *path);
 int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   struct btrfs_ordered_sum *sums);
 int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
 		       struct bio *bio, u64 file_start, int contig);
-struct btrfs_csum_item *btrfs_lookup_csum(struct btrfs_trans_handle *trans,
-					  struct btrfs_root *root,
-					  struct btrfs_path *path,
-					  u64 bytenr, int cow);
 int btrfs_csum_truncate(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root, struct btrfs_path *path,
 			u64 isize);
@@ -3548,8 +3532,6 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput);
 int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
 			      struct extent_state **cached_state);
-int btrfs_writepages(struct address_space *mapping,
-		     struct writeback_control *wbc);
 int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *new_root, u64 new_dirid);
 int btrfs_merge_bio_hook(int rw, struct page *page, unsigned long offset,
@@ -3559,7 +3541,6 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
 int btrfs_readpage(struct file *file, struct page *page);
 void btrfs_evict_inode(struct inode *inode);
 int btrfs_write_inode(struct inode *inode, struct writeback_control *wbc);
-int btrfs_dirty_inode(struct inode *inode);
 struct inode *btrfs_alloc_inode(struct super_block *sb);
 void btrfs_destroy_inode(struct inode *inode);
 int btrfs_drop_inode(struct inode *inode);
@@ -3577,7 +3558,6 @@ int btrfs_update_inode(struct btrfs_trans_handle *trans,
 int btrfs_update_inode_fallback(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root, struct inode *inode);
 int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode);
-int btrfs_orphan_del(struct btrfs_trans_handle *trans, struct inode *inode);
 int btrfs_orphan_cleanup(struct btrfs_root *root);
 void btrfs_orphan_commit_root(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root);
@@ -3628,7 +3608,6 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans,
 int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 			      struct inode *inode, u64 start, u64 end);
 int btrfs_release_file(struct inode *inode, struct file *file);
-void btrfs_drop_pages(struct page **pages, size_t num_pages);
 int btrfs_dirty_pages(struct btrfs_root *root, struct inode *inode,
 		      struct page **pages, size_t num_pages,
 		      loff_t pos, size_t write_bytes,
@@ -3804,7 +3783,6 @@ void btrfs_scrub_continue_super(struct btrfs_root *root);
 int btrfs_scrub_cancel(struct btrfs_fs_info *info);
 int btrfs_scrub_cancel_dev(struct btrfs_fs_info *info,
 			   struct btrfs_device *dev);
-int btrfs_scrub_cancel_devid(struct btrfs_root *root, u64 devid);
 int btrfs_scrub_progress(struct btrfs_root *root, u64 devid,
 			 struct btrfs_scrub_progress *progress);
 
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 71b78c2..f26f38c 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -202,7 +202,7 @@ static void btrfs_dequeue_delayed_node(struct btrfs_delayed_root *root,
 	spin_unlock(&root->lock);
 }
 
-struct btrfs_delayed_node *btrfs_first_delayed_node(
+static struct btrfs_delayed_node *btrfs_first_delayed_node(
 			struct btrfs_delayed_root *delayed_root)
 {
 	struct list_head *p;
@@ -221,7 +221,7 @@ out:
 	return node;
 }
 
-struct btrfs_delayed_node *btrfs_next_delayed_node(
+static struct btrfs_delayed_node *btrfs_next_delayed_node(
 						struct btrfs_delayed_node *node)
 {
 	struct btrfs_delayed_root *delayed_root;
@@ -282,7 +282,7 @@ static inline void btrfs_release_delayed_node(struct btrfs_delayed_node *node)
 	__btrfs_release_delayed_node(node, 0);
 }
 
-struct btrfs_delayed_node *btrfs_first_prepared_delayed_node(
+static struct btrfs_delayed_node *btrfs_first_prepared_delayed_node(
 					struct btrfs_delayed_root *delayed_root)
 {
 	struct list_head *p;
@@ -308,7 +308,7 @@ static inline void btrfs_release_prepared_delayed_node(
 	__btrfs_release_delayed_node(node, 1);
 }
 
-struct btrfs_delayed_item *btrfs_alloc_delayed_item(u32 data_len)
+static struct btrfs_delayed_item *btrfs_alloc_delayed_item(u32 data_len)
 {
 	struct btrfs_delayed_item *item;
 	item = kmalloc(sizeof(*item) + data_len, GFP_NOFS);
@@ -383,7 +383,7 @@ static struct btrfs_delayed_item *__btrfs_lookup_delayed_item(
 	return NULL;
 }
 
-struct btrfs_delayed_item *__btrfs_lookup_delayed_insertion_item(
+static struct btrfs_delayed_item *__btrfs_lookup_delayed_insertion_item(
 					struct btrfs_delayed_node *delayed_node,
 					struct btrfs_key *key)
 {
@@ -394,45 +394,6 @@ struct btrfs_delayed_item *__btrfs_lookup_delayed_insertion_item(
 	return item;
 }
 
-struct btrfs_delayed_item *__btrfs_lookup_delayed_deletion_item(
-					struct btrfs_delayed_node *delayed_node,
-					struct btrfs_key *key)
-{
-	struct btrfs_delayed_item *item;
-
-	item = __btrfs_lookup_delayed_item(&delayed_node->del_root, key,
-					   NULL, NULL);
-	return item;
-}
-
-struct btrfs_delayed_item *__btrfs_search_delayed_insertion_item(
-					struct btrfs_delayed_node *delayed_node,
-					struct btrfs_key *key)
-{
-	struct btrfs_delayed_item *item, *next;
-
-	item = __btrfs_lookup_delayed_item(&delayed_node->ins_root, key,
-					   NULL, &next);
-	if (!item)
-		item = next;
-
-	return item;
-}
-
-struct btrfs_delayed_item *__btrfs_search_delayed_deletion_item(
-					struct btrfs_delayed_node *delayed_node,
-					struct btrfs_key *key)
-{
-	struct btrfs_delayed_item *item, *next;
-
-	item = __btrfs_lookup_delayed_item(&delayed_node->del_root, key,
-					   NULL, &next);
-	if (!item)
-		item = next;
-
-	return item;
-}
-
 static int __btrfs_add_delayed_item(struct btrfs_delayed_node *delayed_node,
 				    struct btrfs_delayed_item *ins,
 				    int action)
@@ -535,7 +496,7 @@ static void btrfs_release_delayed_item(struct btrfs_delayed_item *item)
 	}
 }
 
-struct btrfs_delayed_item *__btrfs_first_delayed_insertion_item(
+static struct btrfs_delayed_item *__btrfs_first_delayed_insertion_item(
 					struct btrfs_delayed_node *delayed_node)
 {
 	struct rb_node *p;
@@ -548,7 +509,7 @@ struct btrfs_delayed_item *__btrfs_first_delayed_insertion_item(
 	return item;
 }
 
-struct btrfs_delayed_item *__btrfs_first_delayed_deletion_item(
+static struct btrfs_delayed_item *__btrfs_first_delayed_deletion_item(
 					struct btrfs_delayed_node *delayed_node)
 {
 	struct rb_node *p;
@@ -561,7 +522,7 @@ struct btrfs_delayed_item *__btrfs_first_delayed_deletion_item(
 	return item;
 }
 
-struct btrfs_delayed_item *__btrfs_next_delayed_item(
+static struct btrfs_delayed_item *__btrfs_next_delayed_item(
 						struct btrfs_delayed_item *item)
 {
 	struct rb_node *p;
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 71fa113..79e594e 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -21,6 +21,10 @@
 #include "hash.h"
 #include "transaction.h"
 
+static struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_root *root,
+			      struct btrfs_path *path,
+			      const char *name, int name_len);
+
 /*
  * insert a name into a directory, doing overflow properly if there is a hash
  * collision.  data_size indicates how big the item inserted should be.  On
@@ -379,7 +383,7 @@ struct btrfs_dir_item *btrfs_lookup_xattr(struct btrfs_trans_handle *trans,
  * this walks through all the entries in a dir item and finds one
  * for a specific name.
  */
-struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_root *root,
+static struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_root *root,
 			      struct btrfs_path *path,
 			      const char *name, int name_len)
 {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 06510f6..2a44209 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -70,6 +70,8 @@ static int btrfs_destroy_marked_extents(struct btrfs_root *root,
 					int mark);
 static int btrfs_destroy_pinned_extent(struct btrfs_root *root,
 				       struct extent_io_tree *pinned_extents);
+static int btrfs_cleanup_transaction(struct btrfs_root *root);
+static void btrfs_error_commit_super(struct btrfs_root *root);
 
 /*
  * end_io_wq structs are used to do processing in task context when an IO is
@@ -569,41 +571,6 @@ static noinline int check_leaf(struct btrfs_root *root,
 	return 0;
 }
 
-struct extent_buffer *find_eb_for_page(struct extent_io_tree *tree,
-				       struct page *page, int max_walk)
-{
-	struct extent_buffer *eb;
-	u64 start = page_offset(page);
-	u64 target = start;
-	u64 min_start;
-
-	if (start < max_walk)
-		min_start = 0;
-	else
-		min_start = start - max_walk;
-
-	while (start >= min_start) {
-		eb = find_extent_buffer(tree, start, 0);
-		if (eb) {
-			/*
-			 * we found an extent buffer and it contains our page
-			 * horray!
-			 */
-			if (eb->start <= target &&
-			    eb->start + eb->len > target)
-				return eb;
-
-			/* we found an extent buffer that wasn't for us */
-			free_extent_buffer(eb);
-			return NULL;
-		}
-		if (start == 0)
-			break;
-		start -= PAGE_CACHE_SIZE;
-	}
-	return NULL;
-}
-
 static int btree_readpage_end_io_hook(struct page *page, u64 start, u64 end,
 			       struct extent_state *state, int mirror)
 {
@@ -3292,7 +3259,7 @@ int btrfs_calc_num_tolerated_disk_barrier_failures(
 	return num_tolerated_disk_barrier_failures;
 }
 
-int write_all_supers(struct btrfs_root *root, int max_mirrors)
+static int write_all_supers(struct btrfs_root *root, int max_mirrors)
 {
 	struct list_head *head;
 	struct btrfs_device *dev;
@@ -3653,7 +3620,7 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
-void btrfs_error_commit_super(struct btrfs_root *root)
+static void btrfs_error_commit_super(struct btrfs_root *root)
 {
 	mutex_lock(&root->fs_info->cleaner_mutex);
 	btrfs_run_delayed_iputs(root);
@@ -3922,7 +3889,7 @@ void btrfs_cleanup_one_transaction(struct btrfs_transaction *cur_trans,
 	*/
 }
 
-int btrfs_cleanup_transaction(struct btrfs_root *root)
+static int btrfs_cleanup_transaction(struct btrfs_root *root)
 {
 	struct btrfs_transaction *t;
 	LIST_HEAD(list);
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 85c23e6..be69ce1 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -61,7 +61,6 @@ int write_ctree_super(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root, int max_mirrors);
 struct buffer_head *btrfs_read_dev_super(struct block_device *bdev);
 int btrfs_commit_super(struct btrfs_root *root);
-void btrfs_error_commit_super(struct btrfs_root *root);
 struct extent_buffer *btrfs_find_tree_block(struct btrfs_root *root,
 					    u64 bytenr, u32 blocksize);
 struct btrfs_root *btrfs_read_fs_root_no_radix(struct btrfs_root *tree_root,
@@ -93,7 +92,6 @@ int btrfs_init_log_root_tree(struct btrfs_trans_handle *trans,
 			     struct btrfs_fs_info *fs_info);
 int btrfs_add_log_tree(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root);
-int btrfs_cleanup_transaction(struct btrfs_root *root);
 void btrfs_cleanup_one_transaction(struct btrfs_transaction *trans,
 				  struct btrfs_root *root);
 struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index be8909d..41365f6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -105,6 +105,8 @@ static int btrfs_update_reserved_bytes(struct btrfs_block_group_cache *cache,
 				       u64 num_bytes, int reserve);
 static int block_rsv_use_bytes(struct btrfs_block_rsv *block_rsv,
 			       u64 num_bytes);
+int btrfs_pin_extent(struct btrfs_root *root,
+		     u64 bytenr, u64 num_bytes, int reserved);
 
 static noinline int
 block_group_cache_done(struct btrfs_block_group_cache *cache)
@@ -684,55 +686,6 @@ void btrfs_clear_space_info_full(struct btrfs_fs_info *info)
 	rcu_read_unlock();
 }
 
-u64 btrfs_find_block_group(struct btrfs_root *root,
-			   u64 search_start, u64 search_hint, int owner)
-{
-	struct btrfs_block_group_cache *cache;
-	u64 used;
-	u64 last = max(search_hint, search_start);
-	u64 group_start = 0;
-	int full_search = 0;
-	int factor = 9;
-	int wrapped = 0;
-again:
-	while (1) {
-		cache = btrfs_lookup_first_block_group(root->fs_info, last);
-		if (!cache)
-			break;
-
-		spin_lock(&cache->lock);
-		last = cache->key.objectid + cache->key.offset;
-		used = btrfs_block_group_used(&cache->item);
-
-		if ((full_search || !cache->ro) &&
-		    block_group_bits(cache, BTRFS_BLOCK_GROUP_METADATA)) {
-			if (used + cache->pinned + cache->reserved <
-			    div_factor(cache->key.offset, factor)) {
-				group_start = cache->key.objectid;
-				spin_unlock(&cache->lock);
-				btrfs_put_block_group(cache);
-				goto found;
-			}
-		}
-		spin_unlock(&cache->lock);
-		btrfs_put_block_group(cache);
-		cond_resched();
-	}
-	if (!wrapped) {
-		last = search_start;
-		wrapped = 1;
-		goto again;
-	}
-	if (!full_search && factor < 10) {
-		last = search_start;
-		full_search = 1;
-		factor = 10;
-		goto again;
-	}
-found:
-	return group_start;
-}
-
 /* simple helper to search for an existing extent at a given offset */
 int btrfs_lookup_extent(struct btrfs_root *root, u64 start, u64 len)
 {
@@ -3453,7 +3406,7 @@ static u64 get_restripe_target(struct btrfs_fs_info *fs_info, u64 flags)
  * progress (either running or paused) picks the target profile (if it's
  * already available), otherwise falls back to plain reducing.
  */
-u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags)
+static u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags)
 {
 	/*
 	 * we add in the count of missing devices because we want
@@ -3944,8 +3897,8 @@ static inline int writeback_inodes_sb_nr_if_idle_safe(struct super_block *sb,
 	return 0;
 }
 
-void btrfs_writeback_inodes_sb_nr(struct btrfs_root *root,
-				  unsigned long nr_pages)
+static void btrfs_writeback_inodes_sb_nr(struct btrfs_root *root,
+					 unsigned long nr_pages)
 {
 	struct super_block *sb = root->fs_info->sb;
 	int started;
@@ -6668,10 +6621,9 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-struct extent_buffer *btrfs_init_new_buffer(struct btrfs_trans_handle *trans,
-					    struct btrfs_root *root,
-					    u64 bytenr, u32 blocksize,
-					    int level)
+static struct extent_buffer *
+btrfs_init_new_buffer(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		      u64 bytenr, u32 blocksize, int level)
 {
 	struct extent_buffer *buf;
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b3b0ff3..15591ca 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -477,7 +477,7 @@ alloc_extent_state_atomic(struct extent_state *prealloc)
 	return prealloc;
 }
 
-void extent_io_tree_panic(struct extent_io_tree *tree, int err)
+static void extent_io_tree_panic(struct extent_io_tree *tree, int err)
 {
 	btrfs_panic(tree_fs_info(tree), err, "Locking error: "
 		    "Extent tree was modified by another "
@@ -658,7 +658,8 @@ static void wait_on_state(struct extent_io_tree *tree,
  * The range [start, end] is inclusive.
  * The tree lock is taken by this function
  */
-void wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits)
+static void wait_extent_bit(struct extent_io_tree *tree, u64 start,
+			    u64 end, int bits)
 {
 	struct extent_state *state;
 	struct rb_node *node;
@@ -1327,8 +1328,9 @@ static int set_range_writeback(struct extent_io_tree *tree, u64 start, u64 end)
  * return it.  tree->lock must be held.  NULL will returned if
  * nothing was found after 'start'
  */
-struct extent_state *find_first_extent_bit_state(struct extent_io_tree *tree,
-						 u64 start, int bits)
+static struct extent_state *
+find_first_extent_bit_state(struct extent_io_tree *tree,
+			    u64 start, int bits)
 {
 	struct rb_node *node;
 	struct extent_state *state;
@@ -2668,7 +2670,8 @@ static int submit_extent_page(int rw, struct extent_io_tree *tree,
 	return ret;
 }
 
-void attach_extent_buffer_page(struct extent_buffer *eb, struct page *page)
+static void attach_extent_buffer_page(struct extent_buffer *eb,
+				      struct page *page)
 {
 	if (!PagePrivate(page)) {
 		SetPagePrivate(page);
@@ -3786,9 +3789,9 @@ int extent_invalidatepage(struct extent_io_tree *tree,
  * are locked or under IO and drops the related state bits if it is safe
  * to drop the page.
  */
-int try_release_extent_state(struct extent_map_tree *map,
-			     struct extent_io_tree *tree, struct page *page,
-			     gfp_t mask)
+static int try_release_extent_state(struct extent_map_tree *map,
+				    struct extent_io_tree *tree,
+				    struct page *page, gfp_t mask)
 {
 	u64 start = page_offset(page);
 	u64 end = start + PAGE_CACHE_SIZE - 1;
@@ -4571,17 +4574,6 @@ int set_extent_buffer_dirty(struct extent_buffer *eb)
 	return was_dirty;
 }
 
-static int range_straddles_pages(u64 start, u64 len)
-{
-	if (len < PAGE_CACHE_SIZE)
-		return 1;
-	if (start & (PAGE_CACHE_SIZE - 1))
-		return 1;
-	if ((start + len) & (PAGE_CACHE_SIZE - 1))
-		return 1;
-	return 0;
-}
-
 int clear_extent_buffer_uptodate(struct extent_buffer *eb)
 {
 	unsigned long i;
@@ -4613,37 +4605,6 @@ int set_extent_buffer_uptodate(struct extent_buffer *eb)
 	return 0;
 }
 
-int extent_range_uptodate(struct extent_io_tree *tree,
-			  u64 start, u64 end)
-{
-	struct page *page;
-	int ret;
-	int pg_uptodate = 1;
-	int uptodate;
-	unsigned long index;
-
-	if (range_straddles_pages(start, end - start + 1)) {
-		ret = test_range_bit(tree, start, end,
-				     EXTENT_UPTODATE, 1, NULL);
-		if (ret)
-			return 1;
-	}
-	while (start <= end) {
-		index = start >> PAGE_CACHE_SHIFT;
-		page = find_get_page(tree->mapping, index);
-		if (!page)
-			return 1;
-		uptodate = PageUptodate(page);
-		page_cache_release(page);
-		if (!uptodate) {
-			pg_uptodate = 0;
-			break;
-		}
-		start += PAGE_CACHE_SIZE;
-	}
-	return pg_uptodate;
-}
-
 int extent_buffer_uptodate(struct extent_buffer *eb)
 {
 	return test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 59d883b..9ebb4c7 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -190,9 +190,6 @@ int try_release_extent_mapping(struct extent_map_tree *map,
 			       struct extent_io_tree *tree, struct page *page,
 			       gfp_t mask);
 int try_release_extent_buffer(struct page *page, gfp_t mask);
-int try_release_extent_state(struct extent_map_tree *map,
-			     struct extent_io_tree *tree, struct page *page,
-			     gfp_t mask);
 int lock_extent(struct extent_io_tree *tree, u64 start, u64 end);
 int lock_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
 		     int bits, struct extent_state **cached);
@@ -242,8 +239,6 @@ int set_extent_defrag(struct extent_io_tree *tree, u64 start, u64 end,
 int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
 			  u64 *start_ret, u64 *end_ret, int bits,
 			  struct extent_state **cached_state);
-struct extent_state *find_first_extent_bit_state(struct extent_io_tree *tree,
-						 u64 start, int bits);
 int extent_invalidatepage(struct extent_io_tree *tree,
 			  struct page *page, unsigned long offset);
 int extent_write_full_page(struct extent_io_tree *tree, struct page *page,
@@ -322,7 +317,6 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 			   unsigned long src_offset, unsigned long len);
 void memset_extent_buffer(struct extent_buffer *eb, char c,
 			  unsigned long start, unsigned long len);
-void wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits);
 void clear_extent_buffer_dirty(struct extent_buffer *eb);
 int set_extent_buffer_dirty(struct extent_buffer *eb);
 int set_extent_buffer_uptodate(struct extent_buffer *eb);
@@ -332,8 +326,6 @@ int map_private_extent_buffer(struct extent_buffer *eb, unsigned long offset,
 		      unsigned long min_len, char **map,
 		      unsigned long *map_start,
 		      unsigned long *map_len);
-int extent_range_uptodate(struct extent_io_tree *tree,
-			  u64 start, u64 end);
 int extent_range_clear_dirty_for_io(struct inode *inode, u64 start, u64 end);
 int extent_range_redirty_for_io(struct inode *inode, u64 start, u64 end);
 int extent_clear_unlock_delalloc(struct inode *inode,
diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index ca96874..a4a7a1a 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -345,8 +345,9 @@ static u64 range_end(u64 start, u64 len)
 	return start + len;
 }
 
-struct extent_map *__lookup_extent_mapping(struct extent_map_tree *tree,
-					   u64 start, u64 len, int strict)
+static struct extent_map *
+__lookup_extent_mapping(struct extent_map_tree *tree,
+			u64 start, u64 len, int strict)
 {
 	struct extent_map *em;
 	struct rb_node *rb_node;
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 769eb86..b193bf3 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -83,10 +83,11 @@ out:
 	return ret;
 }
 
-struct btrfs_csum_item *btrfs_lookup_csum(struct btrfs_trans_handle *trans,
-					  struct btrfs_root *root,
-					  struct btrfs_path *path,
-					  u64 bytenr, int cow)
+static struct btrfs_csum_item *
+btrfs_lookup_csum(struct btrfs_trans_handle *trans,
+		  struct btrfs_root *root,
+		  struct btrfs_path *path,
+		  u64 bytenr, int cow)
 {
 	int ret;
 	struct btrfs_key file_key;
@@ -152,27 +153,6 @@ int btrfs_lookup_file_extent(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-u64 btrfs_file_extent_length(struct btrfs_path *path)
-{
-	int extent_type;
-	struct btrfs_file_extent_item *fi;
-	u64 len;
-
-	fi = btrfs_item_ptr(path->nodes[0], path->slots[0],
-			    struct btrfs_file_extent_item);
-	extent_type = btrfs_file_extent_type(path->nodes[0], fi);
-
-	if (extent_type == BTRFS_FILE_EXTENT_REG ||
-	    extent_type == BTRFS_FILE_EXTENT_PREALLOC)
-		len = btrfs_file_extent_num_bytes(path->nodes[0], fi);
-	else if (extent_type == BTRFS_FILE_EXTENT_INLINE)
-		len = btrfs_file_extent_inline_len(path->nodes[0], fi);
-	else
-		BUG();
-
-	return len;
-}
-
 static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 				   struct inode *inode, struct bio *bio,
 				   u64 logical_offset, u32 *dst, int dio)
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 0dd0741..4e4c24a 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -192,8 +192,8 @@ int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
  * the same inode in the tree, we will merge them together (by
  * __btrfs_add_inode_defrag()) and free the one that we want to requeue.
  */
-void btrfs_requeue_inode_defrag(struct inode *inode,
-				struct inode_defrag *defrag)
+static void btrfs_requeue_inode_defrag(struct inode *inode,
+				       struct inode_defrag *defrag)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret;
@@ -473,7 +473,7 @@ static noinline int btrfs_copy_from_user(loff_t pos, int num_pages,
 /*
  * unlocks pages after btrfs_file_write is done with them
  */
-void btrfs_drop_pages(struct page **pages, size_t num_pages)
+static void btrfs_drop_pages(struct page **pages, size_t num_pages)
 {
 	size_t i;
 	for (i = 0; i < num_pages; i++) {
@@ -497,9 +497,9 @@ void btrfs_drop_pages(struct page **pages, size_t num_pages)
  * doing real data extents, marking pages dirty and delalloc as required.
  */
 int btrfs_dirty_pages(struct btrfs_root *root, struct inode *inode,
-		      struct page **pages, size_t num_pages,
-		      loff_t pos, size_t write_bytes,
-		      struct extent_state **cached)
+			     struct page **pages, size_t num_pages,
+			     loff_t pos, size_t write_bytes,
+			     struct extent_state **cached)
 {
 	int err = 0;
 	int i;
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index fa1a814..f2775af 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -120,9 +120,10 @@ struct inode *lookup_free_space_inode(struct btrfs_root *root,
 	return inode;
 }
 
-int __create_free_space_inode(struct btrfs_root *root,
-			      struct btrfs_trans_handle *trans,
-			      struct btrfs_path *path, u64 ino, u64 offset)
+static int __create_free_space_inode(struct btrfs_root *root,
+				     struct btrfs_trans_handle *trans,
+				     struct btrfs_path *path,
+				     u64 ino, u64 offset)
 {
 	struct btrfs_key key;
 	struct btrfs_disk_key disk_key;
@@ -625,9 +626,9 @@ next:
 	spin_unlock(&ctl->tree_lock);
 }
 
-int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
-			    struct btrfs_free_space_ctl *ctl,
-			    struct btrfs_path *path, u64 offset)
+static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
+				   struct btrfs_free_space_ctl *ctl,
+				   struct btrfs_path *path, u64 offset)
 {
 	struct btrfs_free_space_header *header;
 	struct extent_buffer *leaf;
@@ -868,11 +869,11 @@ out:
  * on mount.  This will return 0 if it was successfull in writing the cache out,
  * and -1 if it was not.
  */
-int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
-			    struct btrfs_free_space_ctl *ctl,
-			    struct btrfs_block_group_cache *block_group,
-			    struct btrfs_trans_handle *trans,
-			    struct btrfs_path *path, u64 offset)
+static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
+				   struct btrfs_free_space_ctl *ctl,
+				   struct btrfs_block_group_cache *block_group,
+				   struct btrfs_trans_handle *trans,
+				   struct btrfs_path *path, u64 offset)
 {
 	struct btrfs_free_space_header *header;
 	struct extent_buffer *leaf;
@@ -2067,7 +2068,8 @@ out:
 	return 0;
 }
 
-void __btrfs_remove_free_space_cache_locked(struct btrfs_free_space_ctl *ctl)
+static void __btrfs_remove_free_space_cache_locked(
+				struct btrfs_free_space_ctl *ctl)
 {
 	struct btrfs_free_space *info;
 	struct rb_node *node;
diff --git a/fs/btrfs/inode-item.c b/fs/btrfs/inode-item.c
index 1640e03..e0b7034 100644
--- a/fs/btrfs/inode-item.c
+++ b/fs/btrfs/inode-item.c
@@ -183,10 +183,11 @@ int btrfs_get_inode_ref_index(struct btrfs_trans_handle *trans,
 	return -ENOENT;
 }
 
-int btrfs_del_inode_extref(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root,
-			   const char *name, int name_len,
-			   u64 inode_objectid, u64 ref_objectid, u64 *index)
+static int btrfs_del_inode_extref(struct btrfs_trans_handle *trans,
+				  struct btrfs_root *root,
+				  const char *name, int name_len,
+				  u64 inode_objectid, u64 ref_objectid,
+				  u64 *index)
 {
 	struct btrfs_path *path;
 	struct btrfs_key key;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a239913..3298d52 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -103,6 +103,8 @@ static struct extent_map *create_pinned_em(struct inode *inode, u64 start,
 					   u64 orig_block_len, u64 ram_bytes,
 					   int type);
 
+static int btrfs_dirty_inode(struct inode *inode);
+
 static int btrfs_init_inode_security(struct btrfs_trans_handle *trans,
 				     struct inode *inode,  struct inode *dir,
 				     const struct qstr *qstr)
@@ -3024,7 +3026,8 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
  * We have done the truncate/delete so we can go ahead and remove the orphan
  * item for this particular inode.
  */
-int btrfs_orphan_del(struct btrfs_trans_handle *trans, struct inode *inode)
+static int btrfs_orphan_del(struct btrfs_trans_handle *trans,
+			    struct inode *inode)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int delete_item = 0;
@@ -5342,7 +5345,7 @@ int btrfs_write_inode(struct inode *inode, struct writeback_control *wbc)
  * FIXME, needs more benchmarking...there are no reasons other than performance
  * to keep or drop this code.
  */
-int btrfs_dirty_inode(struct inode *inode)
+static int btrfs_dirty_inode(struct inode *inode)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_trans_handle *trans;
@@ -7437,8 +7440,8 @@ static int btrfs_writepage(struct page *page, struct writeback_control *wbc)
 	return extent_write_full_page(tree, page, btrfs_get_extent, wbc);
 }
 
-int btrfs_writepages(struct address_space *mapping,
-		     struct writeback_control *wbc)
+static int btrfs_writepages(struct address_space *mapping,
+			    struct writeback_control *wbc)
 {
 	struct extent_io_tree *tree;
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 5e93bb8..455ff4c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3010,7 +3010,7 @@ void btrfs_get_block_group_info(struct list_head *groups_list,
 	}
 }
 
-long btrfs_ioctl_space_info(struct btrfs_root *root, void __user *arg)
+static long btrfs_ioctl_space_info(struct btrfs_root *root, void __user *arg)
 {
 	struct btrfs_ioctl_space_args space_args;
 	struct btrfs_ioctl_space_info space;
diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index e95df43..01277b8 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -24,7 +24,7 @@
 #include "extent_io.h"
 #include "locking.h"
 
-void btrfs_assert_tree_read_locked(struct extent_buffer *eb);
+static void btrfs_assert_tree_read_locked(struct extent_buffer *eb);
 
 /*
  * if we currently have a spinning reader or writer lock
@@ -264,7 +264,7 @@ void btrfs_assert_tree_locked(struct extent_buffer *eb)
 	BUG_ON(!atomic_read(&eb->write_locks));
 }
 
-void btrfs_assert_tree_read_locked(struct extent_buffer *eb)
+static void btrfs_assert_tree_read_locked(struct extent_buffer *eb)
 {
 	BUG_ON(!atomic_read(&eb->read_locks));
 }
diff --git a/fs/btrfs/print-tree.h b/fs/btrfs/print-tree.h
index da75efe..7faddfa 100644
--- a/fs/btrfs/print-tree.h
+++ b/fs/btrfs/print-tree.h
@@ -19,5 +19,5 @@
 #ifndef __PRINT_TREE_
 #define __PRINT_TREE_
 void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l);
-void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *t);
+void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *c);
 #endif
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 9a79fb7..0740621 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -410,7 +410,7 @@ static void remove_rbio_from_cache(struct btrfs_raid_bio *rbio)
 /*
  * remove everything in the cache
  */
-void btrfs_clear_rbio_cache(struct btrfs_fs_info *info)
+static void btrfs_clear_rbio_cache(struct btrfs_fs_info *info)
 {
 	struct btrfs_stripe_hash_table *table;
 	unsigned long flags;
@@ -1010,12 +1010,12 @@ static int alloc_rbio_parity_pages(struct btrfs_raid_bio *rbio)
  * this will try to merge into existing bios if possible, and returns
  * zero if all went well.
  */
-int rbio_add_io_page(struct btrfs_raid_bio *rbio,
-		     struct bio_list *bio_list,
-		     struct page *page,
-		     int stripe_nr,
-		     unsigned long page_index,
-		     unsigned long bio_max_len)
+static int rbio_add_io_page(struct btrfs_raid_bio *rbio,
+			    struct bio_list *bio_list,
+			    struct page *page,
+			    int stripe_nr,
+			    unsigned long page_index,
+			    unsigned long bio_max_len)
 {
 	struct bio *last = bio_list->tail;
 	u64 last_end = 0;
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index b537064..d1b1376 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -326,8 +326,7 @@ static struct rb_node *tree_search(struct rb_root *root, u64 bytenr)
 	return NULL;
 }
 
-void backref_tree_panic(struct rb_node *rb_node, int errno,
-					  u64 bytenr)
+static void backref_tree_panic(struct rb_node *rb_node, int errno, u64 bytenr)
 {
 
 	struct btrfs_fs_info *fs_info = NULL;
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 28db5dc..47500c2 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3012,28 +3012,6 @@ int btrfs_scrub_cancel_dev(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
-int btrfs_scrub_cancel_devid(struct btrfs_root *root, u64 devid)
-{
-	struct btrfs_fs_info *fs_info = root->fs_info;
-	struct btrfs_device *dev;
-	int ret;
-
-	/*
-	 * we have to hold the device_list_mutex here so the device
-	 * does not go away in cancel_dev. FIXME: find a better solution
-	 */
-	mutex_lock(&fs_info->fs_devices->device_list_mutex);
-	dev = btrfs_find_device(fs_info, devid, NULL, NULL);
-	if (!dev) {
-		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
-		return -ENODEV;
-	}
-	ret = btrfs_scrub_cancel_dev(fs_info, dev);
-	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
-
-	return ret;
-}
-
 int btrfs_scrub_progress(struct btrfs_root *root, u64 devid,
 			 struct btrfs_scrub_progress *progress)
 {
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 1a35a82..5ebb207 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -387,7 +387,7 @@ static struct btrfs_path *alloc_path_for_send(void)
 	return path;
 }
 
-int write_buf(struct file *filp, const void *buf, u32 len, loff_t *off)
+static int write_buf(struct file *filp, const void *buf, u32 len, loff_t *off)
 {
 	int ret;
 	mm_segment_t old_fs;
diff --git a/fs/btrfs/send.h b/fs/btrfs/send.h
index 8bb18f7..48d425a 100644
--- a/fs/btrfs/send.h
+++ b/fs/btrfs/send.h
@@ -131,5 +131,4 @@ enum {
 
 #ifdef __KERNEL__
 long btrfs_ioctl_send(struct file *mnt_file, void __user *arg);
-int write_buf(struct file *filp, const void *buf, u32 len, loff_t *off);
 #endif
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index a12c3fd..b08db38 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -34,7 +34,7 @@
 
 #define BTRFS_ROOT_TRANS_TAG 0
 
-void put_transaction(struct btrfs_transaction *transaction)
+static void put_transaction(struct btrfs_transaction *transaction)
 {
 	WARN_ON(atomic_read(&transaction->use_count) == 0);
 	if (atomic_dec_and_test(&transaction->use_count)) {
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index f6edd5e..24c9733 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -146,5 +146,4 @@ int btrfs_wait_marked_extents(struct btrfs_root *root,
 				struct extent_io_tree *dirty_pages, int mark);
 int btrfs_transaction_blocked(struct btrfs_fs_info *info);
 int btrfs_transaction_in_commit(struct btrfs_fs_info *info);
-void put_transaction(struct btrfs_transaction *transaction);
 #endif
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f50137a..95bc7a9 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3777,9 +3777,9 @@ out:
  * only logging is done of any parent directories that are older than
  * the last committed transaction
  */
-int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
-		    struct btrfs_root *root, struct inode *inode,
-		    struct dentry *parent, int exists_only)
+static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
+			    	  struct btrfs_root *root, struct inode *inode,
+			    	  struct dentry *parent, int exists_only)
 {
 	int inode_only = exists_only ? LOG_INODE_EXISTS : LOG_INODE_ALL;
 	struct super_block *sb;
diff --git a/fs/btrfs/tree-log.h b/fs/btrfs/tree-log.h
index 862ac81..1d4ae0d 100644
--- a/fs/btrfs/tree-log.h
+++ b/fs/btrfs/tree-log.h
@@ -40,9 +40,6 @@ int btrfs_del_inode_ref_in_log(struct btrfs_trans_handle *trans,
 			       struct inode *inode, u64 dirid);
 void btrfs_end_log_trans(struct btrfs_root *root);
 int btrfs_pin_log_trans(struct btrfs_root *root);
-int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
-		    struct btrfs_root *root, struct inode *inode,
-		    struct dentry *parent, int exists_only);
 void btrfs_record_unlink_dir(struct btrfs_trans_handle *trans,
 			     struct inode *dir, struct inode *inode,
 			     int for_rename);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c1a2217..a191bac 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -46,6 +46,7 @@ static int init_first_rw_device(struct btrfs_trans_handle *trans,
 				struct btrfs_device *device);
 static int btrfs_relocate_sys_chunks(struct btrfs_root *root);
 static void __btrfs_reset_dev_stats(struct btrfs_device *dev);
+static void btrfs_dev_stat_print_on_error(struct btrfs_device *dev);
 static void btrfs_dev_stat_print_on_load(struct btrfs_device *device);
 
 static DEFINE_MUTEX(uuid_mutex);
@@ -1199,10 +1200,10 @@ out:
 	return ret;
 }
 
-int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
-			   struct btrfs_device *device,
-			   u64 chunk_tree, u64 chunk_objectid,
-			   u64 chunk_offset, u64 start, u64 num_bytes)
+static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
+				  struct btrfs_device *device,
+				  u64 chunk_tree, u64 chunk_objectid,
+				  u64 chunk_offset, u64 start, u64 num_bytes)
 {
 	int ret;
 	struct btrfs_path *path;
@@ -1329,9 +1330,9 @@ error:
  * the device information is stored in the chunk root
  * the btrfs_device struct should be fully filled in
  */
-int btrfs_add_device(struct btrfs_trans_handle *trans,
-		     struct btrfs_root *root,
-		     struct btrfs_device *device)
+static int btrfs_add_device(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root,
+			    struct btrfs_device *device)
 {
 	int ret;
 	struct btrfs_path *path;
@@ -1710,8 +1711,8 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 }
 
-int btrfs_find_device_by_path(struct btrfs_root *root, char *device_path,
-			      struct btrfs_device **device)
+static int btrfs_find_device_by_path(struct btrfs_root *root, char *device_path,
+				     struct btrfs_device **device)
 {
 	int ret = 0;
 	struct btrfs_super_block *disk_super;
@@ -3607,7 +3608,7 @@ static int btrfs_cmp_device_info(const void *a, const void *b)
 	return 0;
 }
 
-struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
+static struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 	[BTRFS_RAID_RAID10] = {
 		.sub_stripes	= 2,
 		.dev_stripes	= 1,
@@ -5120,9 +5121,9 @@ struct async_sched {
  * This will add one bio to the pending list for a device and make sure
  * the work struct is scheduled.
  */
-noinline void btrfs_schedule_bio(struct btrfs_root *root,
-				 struct btrfs_device *device,
-				 int rw, struct bio *bio)
+static noinline void btrfs_schedule_bio(struct btrfs_root *root,
+					struct btrfs_device *device,
+					int rw, struct bio *bio)
 {
 	int should_queue = 1;
 	struct btrfs_pending_bios *pending_bios;
@@ -5940,7 +5941,7 @@ void btrfs_dev_stat_inc_and_print(struct btrfs_device *dev, int index)
 	btrfs_dev_stat_print_on_error(dev);
 }
 
-void btrfs_dev_stat_print_on_error(struct btrfs_device *dev)
+static void btrfs_dev_stat_print_on_error(struct btrfs_device *dev)
 {
 	if (!dev->dev_stats_valid)
 		return;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 062d860..845ccbb 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -254,10 +254,6 @@ int btrfs_account_dev_extents_size(struct btrfs_device *device, u64 start,
 #define btrfs_bio_size(n) (sizeof(struct btrfs_bio) + \
 			    (sizeof(struct btrfs_bio_stripe) * (n)))
 
-int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
-			   struct btrfs_device *device,
-			   u64 chunk_tree, u64 chunk_objectid,
-			   u64 chunk_offset, u64 start, u64 num_bytes);
 int btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 		    u64 logical, u64 *length,
 		    struct btrfs_bio **bbio_ret, int mirror_num);
@@ -282,11 +278,6 @@ void btrfs_close_extra_devices(struct btrfs_fs_info *fs_info,
 int btrfs_find_device_missing_or_by_path(struct btrfs_root *root,
 					 char *device_path,
 					 struct btrfs_device **device);
-int btrfs_find_device_by_path(struct btrfs_root *root, char *device_path,
-			      struct btrfs_device **device);
-int btrfs_add_device(struct btrfs_trans_handle *trans,
-		     struct btrfs_root *root,
-		     struct btrfs_device *device);
 int btrfs_rm_device(struct btrfs_root *root, char *device_path);
 void btrfs_cleanup_fs_uuids(void);
 int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len);
@@ -307,7 +298,6 @@ int btrfs_cancel_balance(struct btrfs_fs_info *fs_info);
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
 			 u64 *start, u64 *max_avail);
-void btrfs_dev_stat_print_on_error(struct btrfs_device *device);
 void btrfs_dev_stat_inc_and_print(struct btrfs_device *dev, int index);
 int btrfs_get_dev_stats(struct btrfs_root *root,
 			struct btrfs_ioctl_get_dev_stats *stats);
@@ -321,9 +311,6 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 void btrfs_init_dev_replace_tgtdev_for_resume(struct btrfs_fs_info *fs_info,
 					      struct btrfs_device *tgtdev);
 int btrfs_scratch_superblock(struct btrfs_device *device);
-void btrfs_schedule_bio(struct btrfs_root *root,
-			struct btrfs_device *device,
-			int rw, struct bio *bio);
 int btrfs_is_parity_mirror(struct btrfs_mapping_tree *map_tree,
 			   u64 logical, u64 len, int mirror_num);
 unsigned long btrfs_full_stripe_len(struct btrfs_root *root,
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 446a684..05740b9 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -406,8 +406,8 @@ int btrfs_removexattr(struct dentry *dentry, const char *name)
 				XATTR_REPLACE);
 }
 
-int btrfs_initxattrs(struct inode *inode, const struct xattr *xattr_array,
-		     void *fs_info)
+static int btrfs_initxattrs(struct inode *inode,
+			    const struct xattr *xattr_array, void *fs_info)
 {
 	const struct xattr *xattr;
 	struct btrfs_trans_handle *trans = fs_info;

