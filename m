From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/3] btrfs: remove all unused functions
Date: Thu,  5 May 2011 15:39:59 +0200
Message-ID: <3dfa40345da15bb061fad672104b9c37763c8f21.1304595715.git.dsterba@suse.cz>
References: <cover.1304595715.git.dsterba@suse.cz>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1304595715.git.dsterba@suse.cz>
In-Reply-To: <cover.1304595715.git.dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Remove static and global declarations and/or definitions. Reduces size
of btrfs.ko by ~3.4kB.

  text    data     bss     dec     hex filename
402081    7464     200  409745   64091 btrfs.ko.base
398620    7144     200  405964   631cc btrfs.ko.remove-all

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ctree.h            |   78 ---------------
 fs/btrfs/delayed-ref.c      |   38 -------
 fs/btrfs/delayed-ref.h      |    1 -
 fs/btrfs/disk-io.c          |   27 -----
 fs/btrfs/disk-io.h          |    7 --
 fs/btrfs/extent_io.c        |  227 -------------------------------------------
 fs/btrfs/extent_io.h        |   21 ----
 fs/btrfs/free-space-cache.c |   15 ---
 fs/btrfs/free-space-cache.h |    1 -
 fs/btrfs/inode.c            |   52 ----------
 fs/btrfs/locking.c          |   25 -----
 fs/btrfs/locking.h          |    2 -
 fs/btrfs/ref-cache.c        |  164 -------------------------------
 fs/btrfs/ref-cache.h        |   24 -----
 fs/btrfs/relocation.c       |    2 +-
 fs/btrfs/root-tree.c        |   47 ---------
 fs/btrfs/sysfs.c            |   65 ------------
 fs/btrfs/volumes.c          |   19 ----
 fs/btrfs/volumes.h          |    3 -
 19 files changed, 1 insertions(+), 817 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b66216e..e37d441 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1440,26 +1440,12 @@ static inline u64 btrfs_stripe_offset_nr(struct extent_buffer *eb,
 	return btrfs_stripe_offset(eb, btrfs_stripe_nr(c, nr));
 }
 
-static inline void btrfs_set_stripe_offset_nr(struct extent_buffer *eb,
-					     struct btrfs_chunk *c, int nr,
-					     u64 val)
-{
-	btrfs_set_stripe_offset(eb, btrfs_stripe_nr(c, nr), val);
-}
-
 static inline u64 btrfs_stripe_devid_nr(struct extent_buffer *eb,
 					 struct btrfs_chunk *c, int nr)
 {
 	return btrfs_stripe_devid(eb, btrfs_stripe_nr(c, nr));
 }
 
-static inline void btrfs_set_stripe_devid_nr(struct extent_buffer *eb,
-					     struct btrfs_chunk *c, int nr,
-					     u64 val)
-{
-	btrfs_set_stripe_devid(eb, btrfs_stripe_nr(c, nr), val);
-}
-
 /* struct btrfs_block_group_item */
 BTRFS_SETGET_STACK_FUNCS(block_group_used, struct btrfs_block_group_item,
 			 used, 64);
@@ -1517,14 +1503,6 @@ btrfs_inode_ctime(struct btrfs_inode_item *inode_item)
 	return (struct btrfs_timespec *)ptr;
 }
 
-static inline struct btrfs_timespec *
-btrfs_inode_otime(struct btrfs_inode_item *inode_item)
-{
-	unsigned long ptr = (unsigned long)inode_item;
-	ptr += offsetof(struct btrfs_inode_item, otime);
-	return (struct btrfs_timespec *)ptr;
-}
-
 BTRFS_SETGET_FUNCS(timespec_sec, struct btrfs_timespec, sec, 64);
 BTRFS_SETGET_FUNCS(timespec_nsec, struct btrfs_timespec, nsec, 32);
 
@@ -1875,33 +1853,6 @@ static inline u8 *btrfs_header_chunk_tree_uuid(struct extent_buffer *eb)
 	return (u8 *)ptr;
 }
 
-static inline u8 *btrfs_super_fsid(struct extent_buffer *eb)
-{
-	unsigned long ptr = offsetof(struct btrfs_super_block, fsid);
-	return (u8 *)ptr;
-}
-
-static inline u8 *btrfs_header_csum(struct extent_buffer *eb)
-{
-	unsigned long ptr = offsetof(struct btrfs_header, csum);
-	return (u8 *)ptr;
-}
-
-static inline struct btrfs_node *btrfs_buffer_node(struct extent_buffer *eb)
-{
-	return NULL;
-}
-
-static inline struct btrfs_leaf *btrfs_buffer_leaf(struct extent_buffer *eb)
-{
-	return NULL;
-}
-
-static inline struct btrfs_header *btrfs_buffer_header(struct extent_buffer *eb)
-{
-	return NULL;
-}
-
 static inline int btrfs_is_leaf(struct extent_buffer *eb)
 {
 	return btrfs_header_level(eb) == 0;
@@ -2055,22 +2006,6 @@ static inline struct btrfs_root *btrfs_sb(struct super_block *sb)
 	return sb->s_fs_info;
 }
 
-static inline int btrfs_set_root_name(struct btrfs_root *root,
-				      const char *name, int len)
-{
-	/* if we already have a name just free it */
-	kfree(root->name);
-
-	root->name = kmalloc(len+1, GFP_KERNEL);
-	if (!root->name)
-		return -ENOMEM;
-
-	memcpy(root->name, name, len);
-	root->name[len] = '\0';
-
-	return 0;
-}
-
 static inline u32 btrfs_level_size(struct btrfs_root *root, int level)
 {
 	if (level == 0)
@@ -2304,11 +2239,6 @@ static inline int btrfs_del_item(struct btrfs_trans_handle *trans,
 
 int btrfs_insert_item(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, struct btrfs_key *key, void *data, u32 data_size);
-int btrfs_insert_some_items(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root,
-			    struct btrfs_path *path,
-			    struct btrfs_key *cpu_key, u32 *data_size,
-			    int nr);
 int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
 			     struct btrfs_path *path,
@@ -2354,8 +2284,6 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *item);
 int btrfs_find_last_root(struct btrfs_root *root, u64 objectid, struct
 			 btrfs_root_item *item, struct btrfs_key *key);
-int btrfs_search_root(struct btrfs_root *root, u64 search_start,
-		      u64 *found_objectid);
 int btrfs_find_dead_roots(struct btrfs_root *root, u64 objectid);
 int btrfs_find_orphan_roots(struct btrfs_root *tree_root);
 int btrfs_set_root_node(struct btrfs_root_item *item,
@@ -2494,8 +2422,6 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 			       u32 min_type);
 
 int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput);
-int btrfs_start_one_delalloc_inode(struct btrfs_root *root, int delay_iput,
-				   int sync);
 int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
 			      struct extent_state **cached_state);
 int btrfs_writepages(struct address_space *mapping,
@@ -2579,10 +2505,6 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
 /* sysfs.c */
 int btrfs_init_sysfs(void);
 void btrfs_exit_sysfs(void);
-int btrfs_sysfs_add_super(struct btrfs_fs_info *fs);
-int btrfs_sysfs_add_root(struct btrfs_root *root);
-void btrfs_sysfs_del_root(struct btrfs_root *root);
-void btrfs_sysfs_del_super(struct btrfs_fs_info *root);
 
 /* xattr.c */
 ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index bce28f6..cb9b9a4 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -281,44 +281,6 @@ again:
 }
 
 /*
- * This checks to see if there are any delayed refs in the
- * btree for a given bytenr.  It returns one if it finds any
- * and zero otherwise.
- *
- * If it only finds a head node, it returns 0.
- *
- * The idea is to use this when deciding if you can safely delete an
- * extent from the extent allocation tree.  There may be a pending
- * ref in the rbtree that adds or removes references, so as long as this
- * returns one you need to leave the BTRFS_EXTENT_ITEM in the extent
- * allocation tree.
- */
-int btrfs_delayed_ref_pending(struct btrfs_trans_handle *trans, u64 bytenr)
-{
-	struct btrfs_delayed_ref_node *ref;
-	struct btrfs_delayed_ref_root *delayed_refs;
-	struct rb_node *prev_node;
-	int ret = 0;
-
-	delayed_refs = &trans->transaction->delayed_refs;
-	spin_lock(&delayed_refs->lock);
-
-	ref = find_ref_head(&delayed_refs->root, bytenr, NULL);
-	if (ref) {
-		prev_node = rb_prev(&ref->rb_node);
-		if (!prev_node)
-			goto out;
-		ref = rb_entry(prev_node, struct btrfs_delayed_ref_node,
-			       rb_node);
-		if (ref->bytenr == bytenr)
-			ret = 1;
-	}
-out:
-	spin_unlock(&delayed_refs->lock);
-	return ret;
-}
-
-/*
  * helper function to update an extent delayed ref in the
  * rbtree.  existing and update must both have the same
  * bytenr and parent
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index 946ed71..e287e3b 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -166,7 +166,6 @@ int btrfs_add_delayed_extent_op(struct btrfs_trans_handle *trans,
 
 struct btrfs_delayed_ref_head *
 btrfs_find_delayed_ref_head(struct btrfs_trans_handle *trans, u64 bytenr);
-int btrfs_delayed_ref_pending(struct btrfs_trans_handle *trans, u64 bytenr);
 int btrfs_delayed_ref_lock(struct btrfs_trans_handle *trans,
 			   struct btrfs_delayed_ref_head *head);
 int btrfs_find_ref_cluster(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 4084959..fa287c5 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -650,12 +650,6 @@ unsigned long btrfs_async_submit_limit(struct btrfs_fs_info *info)
 	return 256 * limit;
 }
 
-int btrfs_congested_async(struct btrfs_fs_info *info, int iodone)
-{
-	return atomic_read(&info->nr_async_bios) >
-		btrfs_async_submit_limit(info);
-}
-
 static void run_one_async_start(struct btrfs_work *work)
 {
 	struct async_submit_bio *async;
@@ -1283,21 +1277,6 @@ out:
 	return root;
 }
 
-struct btrfs_root *btrfs_lookup_fs_root(struct btrfs_fs_info *fs_info,
-					u64 root_objectid)
-{
-	struct btrfs_root *root;
-
-	if (root_objectid == BTRFS_ROOT_TREE_OBJECTID)
-		return fs_info->tree_root;
-	if (root_objectid == BTRFS_EXTENT_TREE_OBJECTID)
-		return fs_info->extent_root;
-
-	root = radix_tree_lookup(&fs_info->fs_roots_radix,
-				 (unsigned long)root_objectid);
-	return root;
-}
-
 struct btrfs_root *btrfs_read_fs_root_no_name(struct btrfs_fs_info *fs_info,
 					      struct btrfs_key *location)
 {
@@ -1369,11 +1348,6 @@ fail:
 	return ERR_PTR(ret);
 }
 
-struct btrfs_root *btrfs_read_fs_root(struct btrfs_fs_info *fs_info,
-				      struct btrfs_key *location,
-				      const char *name, int namelen)
-{
-	return btrfs_read_fs_root_no_name(fs_info, location);
 #if 0
 	struct btrfs_root *root;
 	int ret;
@@ -1402,7 +1376,6 @@ struct btrfs_root *btrfs_read_fs_root(struct btrfs_fs_info *fs_info,
 	root->in_sysfs = 1;
 	return root;
 #endif
-}
 
 static int btrfs_congested_fn(void *congested_data, int bdi_bits)
 {
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 758f3ca..2d75f9e 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -55,11 +55,6 @@ int btrfs_commit_super(struct btrfs_root *root);
 int btrfs_error_commit_super(struct btrfs_root *root);
 struct extent_buffer *btrfs_find_tree_block(struct btrfs_root *root,
 					    u64 bytenr, u32 blocksize);
-struct btrfs_root *btrfs_lookup_fs_root(struct btrfs_fs_info *fs_info,
-					u64 root_objectid);
-struct btrfs_root *btrfs_read_fs_root(struct btrfs_fs_info *fs_info,
-				      struct btrfs_key *location,
-				      const char *name, int namelen);
 struct btrfs_root *btrfs_read_fs_root_no_radix(struct btrfs_root *tree_root,
 					       struct btrfs_key *location);
 struct btrfs_root *btrfs_read_fs_root_no_name(struct btrfs_fs_info *fs_info,
@@ -80,8 +75,6 @@ int btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct inode *inode,
 			unsigned long bio_flags, u64 bio_offset,
 			extent_submit_bio_hook_t *submit_bio_start,
 			extent_submit_bio_hook_t *submit_bio_done);
-
-int btrfs_congested_async(struct btrfs_fs_info *info, int iodone);
 unsigned long btrfs_async_submit_limit(struct btrfs_fs_info *info);
 int btrfs_write_tree_block(struct extent_buffer *buf);
 int btrfs_wait_tree_block_writeback(struct extent_buffer *buf);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 9369289..9120829 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -941,13 +941,6 @@ int set_extent_new(struct extent_io_tree *tree, u64 start, u64 end,
 			      NULL, mask);
 }
 
-static int clear_extent_new(struct extent_io_tree *tree, u64 start, u64 end,
-		       gfp_t mask)
-{
-	return clear_extent_bit(tree, start, end, EXTENT_NEW, 0, 0,
-				NULL, mask);
-}
-
 int set_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
 			struct extent_state **cached_state, gfp_t mask)
 {
@@ -963,11 +956,6 @@ static int clear_extent_uptodate(struct extent_io_tree *tree, u64 start,
 				cached_state, mask);
 }
 
-int wait_on_extent_writeback(struct extent_io_tree *tree, u64 start, u64 end)
-{
-	return wait_extent_bit(tree, start, end, EXTENT_WRITEBACK);
-}
-
 /*
  * either insert or lock state struct between start and end use mask to tell
  * us if waiting is desired.
@@ -1028,25 +1016,6 @@ int unlock_extent(struct extent_io_tree *tree, u64 start, u64 end, gfp_t mask)
 }
 
 /*
- * helper function to set pages and extents in the tree dirty
- */
-int set_range_dirty(struct extent_io_tree *tree, u64 start, u64 end)
-{
-	unsigned long index = start >> PAGE_CACHE_SHIFT;
-	unsigned long end_index = end >> PAGE_CACHE_SHIFT;
-	struct page *page;
-
-	while (index <= end_index) {
-		page = find_get_page(tree->mapping, index);
-		BUG_ON(!page);
-		__set_page_dirty_nobuffers(page);
-		page_cache_release(page);
-		index++;
-	}
-	return 0;
-}
-
-/*
  * helper function to set both pages and extents in the tree writeback
  */
 static int set_range_writeback(struct extent_io_tree *tree, u64 start, u64 end)
@@ -1819,46 +1788,6 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 	bio_put(bio);
 }
 
-/*
- * IO done from prepare_write is pretty simple, we just unlock
- * the structs in the extent tree when done, and set the uptodate bits
- * as appropriate.
- */
-static void end_bio_extent_preparewrite(struct bio *bio, int err)
-{
-	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
-	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
-	struct extent_io_tree *tree;
-	u64 start;
-	u64 end;
-
-	do {
-		struct page *page = bvec->bv_page;
-		struct extent_state *cached = NULL;
-		tree = &BTRFS_I(page->mapping->host)->io_tree;
-
-		start = ((u64)page->index << PAGE_CACHE_SHIFT) +
-			bvec->bv_offset;
-		end = start + bvec->bv_len - 1;
-
-		if (--bvec >= bio->bi_io_vec)
-			prefetchw(&bvec->bv_page->flags);
-
-		if (uptodate) {
-			set_extent_uptodate(tree, start, end, &cached,
-					    GFP_ATOMIC);
-		} else {
-			ClearPageUptodate(page);
-			SetPageError(page);
-		}
-
-		unlock_extent_cached(tree, start, end, &cached, GFP_ATOMIC);
-
-	} while (bvec >= bio->bi_io_vec);
-
-	bio_put(bio);
-}
-
 struct bio *
 btrfs_bio_alloc(struct block_device *bdev, u64 first_sector, int nr_vecs,
 		gfp_t gfp_flags)
@@ -2720,128 +2649,6 @@ int extent_invalidatepage(struct extent_io_tree *tree,
 }
 
 /*
- * simple commit_write call, set_range_dirty is used to mark both
- * the pages and the extent records as dirty
- */
-int extent_commit_write(struct extent_io_tree *tree,
-			struct inode *inode, struct page *page,
-			unsigned from, unsigned to)
-{
-	loff_t pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
-
-	set_page_extent_mapped(page);
-	set_page_dirty(page);
-
-	if (pos > inode->i_size) {
-		i_size_write(inode, pos);
-		mark_inode_dirty(inode);
-	}
-	return 0;
-}
-
-int extent_prepare_write(struct extent_io_tree *tree,
-			 struct inode *inode, struct page *page,
-			 unsigned from, unsigned to, get_extent_t *get_extent)
-{
-	u64 page_start = (u64)page->index << PAGE_CACHE_SHIFT;
-	u64 page_end = page_start + PAGE_CACHE_SIZE - 1;
-	u64 block_start;
-	u64 orig_block_start;
-	u64 block_end;
-	u64 cur_end;
-	struct extent_map *em;
-	unsigned blocksize = 1 << inode->i_blkbits;
-	size_t pg_offset = 0;
-	size_t block_off_start;
-	size_t block_off_end;
-	int err = 0;
-	int iocount = 0;
-	int ret = 0;
-	int isnew;
-
-	set_page_extent_mapped(page);
-
-	block_start = (page_start + from) & ~((u64)blocksize - 1);
-	block_end = (page_start + to - 1) | (blocksize - 1);
-	orig_block_start = block_start;
-
-	lock_extent(tree, page_start, page_end, GFP_NOFS);
-	while (block_start <= block_end) {
-		em = get_extent(inode, page, pg_offset, block_start,
-				block_end - block_start + 1, 1);
-		if (IS_ERR_OR_NULL(em))
-			goto err;
-
-		cur_end = min(block_end, extent_map_end(em) - 1);
-		block_off_start = block_start & (PAGE_CACHE_SIZE - 1);
-		block_off_end = block_off_start + blocksize;
-		isnew = clear_extent_new(tree, block_start, cur_end, GFP_NOFS);
-
-		if (!PageUptodate(page) && isnew &&
-		    (block_off_end > to || block_off_start < from)) {
-			void *kaddr;
-
-			kaddr = kmap_atomic(page, KM_USER0);
-			if (block_off_end > to)
-				memset(kaddr + to, 0, block_off_end - to);
-			if (block_off_start < from)
-				memset(kaddr + block_off_start, 0,
-				       from - block_off_start);
-			flush_dcache_page(page);
-			kunmap_atomic(kaddr, KM_USER0);
-		}
-		if ((em->block_start != EXTENT_MAP_HOLE &&
-		     em->block_start != EXTENT_MAP_INLINE) &&
-		    !isnew && !PageUptodate(page) &&
-		    (block_off_end > to || block_off_start < from) &&
-		    !test_range_bit(tree, block_start, cur_end,
-				    EXTENT_UPTODATE, 1, NULL)) {
-			u64 sector;
-			u64 extent_offset = block_start - em->start;
-			size_t iosize;
-			sector = (em->block_start + extent_offset) >> 9;
-			iosize = (cur_end - block_start + blocksize) &
-				~((u64)blocksize - 1);
-			/*
-			 * we've already got the extent locked, but we
-			 * need to split the state such that our end_bio
-			 * handler can clear the lock.
-			 */
-			set_extent_bit(tree, block_start,
-				       block_start + iosize - 1,
-				       EXTENT_LOCKED, 0, NULL, NULL, GFP_NOFS);
-			ret = submit_extent_page(READ, tree, page,
-					 sector, iosize, pg_offset, em->bdev,
-					 NULL, 1,
-					 end_bio_extent_preparewrite, 0,
-					 0, 0);
-			if (ret && !err)
-				err = ret;
-			iocount++;
-			block_start = block_start + iosize;
-		} else {
-			struct extent_state *cached = NULL;
-
-			set_extent_uptodate(tree, block_start, cur_end, &cached,
-					    GFP_NOFS);
-			unlock_extent_cached(tree, block_start, cur_end,
-					     &cached, GFP_NOFS);
-			block_start = cur_end + 1;
-		}
-		pg_offset = block_start & (PAGE_CACHE_SIZE - 1);
-		free_extent_map(em);
-	}
-	if (iocount) {
-		wait_extent_bit(tree, orig_block_start,
-				block_end, EXTENT_LOCKED);
-	}
-	check_page_uptodate(tree, page);
-err:
-	/* FIXME, zero out newly allocated blocks on error */
-	return err;
-}
-
-/*
  * a helper for releasepage, this tests for areas of the page that
  * are locked or under IO and drops the related state bits if it is safe
  * to drop the page.
@@ -2927,33 +2734,6 @@ int try_release_extent_mapping(struct extent_map_tree *map,
 	return try_release_extent_state(map, tree, page, mask);
 }
 
-sector_t extent_bmap(struct address_space *mapping, sector_t iblock,
-		get_extent_t *get_extent)
-{
-	struct inode *inode = mapping->host;
-	struct extent_state *cached_state = NULL;
-	u64 start = iblock << inode->i_blkbits;
-	sector_t sector = 0;
-	size_t blksize = (1 << inode->i_blkbits);
-	struct extent_map *em;
-
-	lock_extent_bits(&BTRFS_I(inode)->io_tree, start, start + blksize - 1,
-			 0, &cached_state, GFP_NOFS);
-	em = get_extent(inode, NULL, 0, start, blksize, 0);
-	unlock_extent_cached(&BTRFS_I(inode)->io_tree, start,
-			     start + blksize - 1, &cached_state, GFP_NOFS);
-	if (IS_ERR_OR_NULL(em))
-		return 0;
-
-	if (em->block_start > EXTENT_MAP_LAST_BYTE)
-		goto out;
-
-	sector = (em->block_start + start - em->start) >> inode->i_blkbits;
-out:
-	free_extent_map(em);
-	return sector;
-}
-
 /*
  * helper function for fiemap, which doesn't want to see any holes.
  * This maps until we find something past 'last'
@@ -3437,13 +3217,6 @@ int clear_extent_buffer_dirty(struct extent_io_tree *tree,
 	return 0;
 }
 
-int wait_on_extent_buffer_writeback(struct extent_io_tree *tree,
-				    struct extent_buffer *eb)
-{
-	return wait_on_extent_writeback(tree, eb->start,
-					eb->start + eb->len - 1);
-}
-
 int set_extent_buffer_dirty(struct extent_io_tree *tree,
 			     struct extent_buffer *eb)
 {
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index d1c5a57..4e8445a 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -153,15 +153,6 @@ static inline int extent_compress_type(unsigned long bio_flags)
 
 struct extent_map_tree;
 
-static inline struct extent_state *extent_state_next(struct extent_state *state)
-{
-	struct rb_node *node;
-	node = rb_next(&state->rb_node);
-	if (!node)
-		return NULL;
-	return rb_entry(node, struct extent_state, rb_node);
-}
-
 typedef struct extent_map *(get_extent_t)(struct inode *inode,
 					  struct page *page,
 					  size_t pg_offset,
@@ -237,17 +228,8 @@ int extent_readpages(struct extent_io_tree *tree,
 		     struct address_space *mapping,
 		     struct list_head *pages, unsigned nr_pages,
 		     get_extent_t get_extent);
-int extent_prepare_write(struct extent_io_tree *tree,
-			 struct inode *inode, struct page *page,
-			 unsigned from, unsigned to, get_extent_t *get_extent);
-int extent_commit_write(struct extent_io_tree *tree,
-			struct inode *inode, struct page *page,
-			unsigned from, unsigned to);
-sector_t extent_bmap(struct address_space *mapping, sector_t iblock,
-		get_extent_t *get_extent);
 int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		__u64 start, __u64 len, get_extent_t *get_extent);
-int set_range_dirty(struct extent_io_tree *tree, u64 start, u64 end);
 int set_state_private(struct extent_io_tree *tree, u64 start, u64 private);
 int get_state_private(struct extent_io_tree *tree, u64 start, u64 *private);
 void set_page_extent_mapped(struct page *page);
@@ -284,9 +266,6 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 			   unsigned long src_offset, unsigned long len);
 void memset_extent_buffer(struct extent_buffer *eb, char c,
 			  unsigned long start, unsigned long len);
-int wait_on_extent_buffer_writeback(struct extent_io_tree *tree,
-				    struct extent_buffer *eb);
-int wait_on_extent_writeback(struct extent_io_tree *tree, u64 start, u64 end);
 int wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits);
 int clear_extent_buffer_dirty(struct extent_io_tree *tree,
 			      struct extent_buffer *eb);
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 48fafcb..0290b0c 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1685,21 +1685,6 @@ void btrfs_dump_free_space(struct btrfs_block_group_cache *block_group,
 	       "\n", count);
 }
 
-u64 btrfs_block_group_free_space(struct btrfs_block_group_cache *block_group)
-{
-	struct btrfs_free_space *info;
-	struct rb_node *n;
-	u64 ret = 0;
-
-	for (n = rb_first(&block_group->free_space_offset); n;
-	     n = rb_next(n)) {
-		info = rb_entry(n, struct btrfs_free_space, offset_index);
-		ret += info->bytes;
-	}
-
-	return ret;
-}
-
 /*
  * for a given cluster, put all of its extents back into the free
  * space cache.  If the block group passed doesn't match the block group
diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index 65c3b93..12b2b51 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -55,7 +55,6 @@ u64 btrfs_find_space_for_alloc(struct btrfs_block_group_cache *block_group,
 			       u64 offset, u64 bytes, u64 empty_size);
 void btrfs_dump_free_space(struct btrfs_block_group_cache *block_group,
 			   u64 bytes);
-u64 btrfs_block_group_free_space(struct btrfs_block_group_cache *block_group);
 int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
 			     struct btrfs_block_group_cache *block_group,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2840989..57122a5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7185,58 +7185,6 @@ int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput)
 	return 0;
 }
 
-int btrfs_start_one_delalloc_inode(struct btrfs_root *root, int delay_iput,
-				   int sync)
-{
-	struct btrfs_inode *binode;
-	struct inode *inode = NULL;
-
-	spin_lock(&root->fs_info->delalloc_lock);
-	while (!list_empty(&root->fs_info->delalloc_inodes)) {
-		binode = list_entry(root->fs_info->delalloc_inodes.next,
-				    struct btrfs_inode, delalloc_inodes);
-		inode = igrab(&binode->vfs_inode);
-		if (inode) {
-			list_move_tail(&binode->delalloc_inodes,
-				       &root->fs_info->delalloc_inodes);
-			break;
-		}
-
-		list_del_init(&binode->delalloc_inodes);
-		cond_resched_lock(&root->fs_info->delalloc_lock);
-	}
-	spin_unlock(&root->fs_info->delalloc_lock);
-
-	if (inode) {
-		if (sync) {
-			filemap_write_and_wait(inode->i_mapping);
-			/*
-			 * We have to do this because compression doesn't
-			 * actually set PG_writeback until it submits the pages
-			 * for IO, which happens in an async thread, so we could
-			 * race and not actually wait for any writeback pages
-			 * because they've not been submitted yet.  Technically
-			 * this could still be the case for the ordered stuff
-			 * since the async thread may not have started to do its
-			 * work yet.  If this becomes the case then we need to
-			 * figure out a way to make sure that in writepage we
-			 * wait for any async pages to be submitted before
-			 * returning so that fdatawait does what its supposed to
-			 * do.
-			 */
-			btrfs_wait_ordered_range(inode, 0, (u64)-1);
-		} else {
-			filemap_flush(inode->i_mapping);
-		}
-		if (delay_iput)
-			btrfs_add_delayed_iput(inode);
-		else
-			iput(inode);
-		return 1;
-	}
-	return 0;
-}
-
 static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 			 const char *symname)
 {
diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index 6151f2e..66fa43d 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -185,31 +185,6 @@ sleep:
 	return 0;
 }
 
-/*
- * Very quick trylock, this does not spin or schedule.  It returns
- * 1 with the spinlock held if it was able to take the lock, or it
- * returns zero if it was unable to take the lock.
- *
- * After this call, scheduling is not safe without first calling
- * btrfs_set_lock_blocking()
- */
-int btrfs_try_tree_lock(struct extent_buffer *eb)
-{
-	if (spin_trylock(&eb->lock)) {
-		if (test_bit(EXTENT_BUFFER_BLOCKING, &eb->bflags)) {
-			/*
-			 * we've got the spinlock, but the real owner is
-			 * blocking.  Drop the spinlock and return failure
-			 */
-			spin_unlock(&eb->lock);
-			return 0;
-		}
-		return 1;
-	}
-	/* someone else has the spinlock giveup */
-	return 0;
-}
-
 int btrfs_tree_unlock(struct extent_buffer *eb)
 {
 	/*
diff --git a/fs/btrfs/locking.h b/fs/btrfs/locking.h
index 6c4ce45..5c33a56 100644
--- a/fs/btrfs/locking.h
+++ b/fs/btrfs/locking.h
@@ -21,8 +21,6 @@
 
 int btrfs_tree_lock(struct extent_buffer *eb);
 int btrfs_tree_unlock(struct extent_buffer *eb);
-
-int btrfs_try_tree_lock(struct extent_buffer *eb);
 int btrfs_try_spin_lock(struct extent_buffer *eb);
 
 void btrfs_set_lock_blocking(struct extent_buffer *eb);
diff --git a/fs/btrfs/ref-cache.c b/fs/btrfs/ref-cache.c
index a97314c..82d569c 100644
--- a/fs/btrfs/ref-cache.c
+++ b/fs/btrfs/ref-cache.c
@@ -23,56 +23,6 @@
 #include "ref-cache.h"
 #include "transaction.h"
 
-/*
- * leaf refs are used to cache the information about which extents
- * a given leaf has references on.  This allows us to process that leaf
- * in btrfs_drop_snapshot without needing to read it back from disk.
- */
-
-/*
- * kmalloc a leaf reference struct and update the counters for the
- * total ref cache size
- */
-struct btrfs_leaf_ref *btrfs_alloc_leaf_ref(struct btrfs_root *root,
-					    int nr_extents)
-{
-	struct btrfs_leaf_ref *ref;
-	size_t size = btrfs_leaf_ref_size(nr_extents);
-
-	ref = kmalloc(size, GFP_NOFS);
-	if (ref) {
-		spin_lock(&root->fs_info->ref_cache_lock);
-		root->fs_info->total_ref_cache_size += size;
-		spin_unlock(&root->fs_info->ref_cache_lock);
-
-		memset(ref, 0, sizeof(*ref));
-		atomic_set(&ref->usage, 1);
-		INIT_LIST_HEAD(&ref->list);
-	}
-	return ref;
-}
-
-/*
- * free a leaf reference struct and update the counters for the
- * total ref cache size
- */
-void btrfs_free_leaf_ref(struct btrfs_root *root, struct btrfs_leaf_ref *ref)
-{
-	if (!ref)
-		return;
-	WARN_ON(atomic_read(&ref->usage) == 0);
-	if (atomic_dec_and_test(&ref->usage)) {
-		size_t size = btrfs_leaf_ref_size(ref->nritems);
-
-		BUG_ON(ref->in_tree);
-		kfree(ref);
-
-		spin_lock(&root->fs_info->ref_cache_lock);
-		root->fs_info->total_ref_cache_size -= size;
-		spin_unlock(&root->fs_info->ref_cache_lock);
-	}
-}
-
 static struct rb_node *tree_insert(struct rb_root *root, u64 bytenr,
 				   struct rb_node *node)
 {
@@ -116,117 +66,3 @@ static struct rb_node *tree_search(struct rb_root *root, u64 bytenr)
 	}
 	return NULL;
 }
-
-int btrfs_remove_leaf_refs(struct btrfs_root *root, u64 max_root_gen,
-			   int shared)
-{
-	struct btrfs_leaf_ref *ref = NULL;
-	struct btrfs_leaf_ref_tree *tree = root->ref_tree;
-
-	if (shared)
-		tree = &root->fs_info->shared_ref_tree;
-	if (!tree)
-		return 0;
-
-	spin_lock(&tree->lock);
-	while (!list_empty(&tree->list)) {
-		ref = list_entry(tree->list.next, struct btrfs_leaf_ref, list);
-		BUG_ON(ref->tree != tree);
-		if (ref->root_gen > max_root_gen)
-			break;
-		if (!xchg(&ref->in_tree, 0)) {
-			cond_resched_lock(&tree->lock);
-			continue;
-		}
-
-		rb_erase(&ref->rb_node, &tree->root);
-		list_del_init(&ref->list);
-
-		spin_unlock(&tree->lock);
-		btrfs_free_leaf_ref(root, ref);
-		cond_resched();
-		spin_lock(&tree->lock);
-	}
-	spin_unlock(&tree->lock);
-	return 0;
-}
-
-/*
- * find the leaf ref for a given extent.  This returns the ref struct with
- * a usage reference incremented
- */
-struct btrfs_leaf_ref *btrfs_lookup_leaf_ref(struct btrfs_root *root,
-					     u64 bytenr)
-{
-	struct rb_node *rb;
-	struct btrfs_leaf_ref *ref = NULL;
-	struct btrfs_leaf_ref_tree *tree = root->ref_tree;
-again:
-	if (tree) {
-		spin_lock(&tree->lock);
-		rb = tree_search(&tree->root, bytenr);
-		if (rb)
-			ref = rb_entry(rb, struct btrfs_leaf_ref, rb_node);
-		if (ref)
-			atomic_inc(&ref->usage);
-		spin_unlock(&tree->lock);
-		if (ref)
-			return ref;
-	}
-	if (tree != &root->fs_info->shared_ref_tree) {
-		tree = &root->fs_info->shared_ref_tree;
-		goto again;
-	}
-	return NULL;
-}
-
-/*
- * add a fully filled in leaf ref struct
- * remove all the refs older than a given root generation
- */
-int btrfs_add_leaf_ref(struct btrfs_root *root, struct btrfs_leaf_ref *ref,
-		       int shared)
-{
-	int ret = 0;
-	struct rb_node *rb;
-	struct btrfs_leaf_ref_tree *tree = root->ref_tree;
-
-	if (shared)
-		tree = &root->fs_info->shared_ref_tree;
-
-	spin_lock(&tree->lock);
-	rb = tree_insert(&tree->root, ref->bytenr, &ref->rb_node);
-	if (rb) {
-		ret = -EEXIST;
-	} else {
-		atomic_inc(&ref->usage);
-		ref->tree = tree;
-		ref->in_tree = 1;
-		list_add_tail(&ref->list, &tree->list);
-	}
-	spin_unlock(&tree->lock);
-	return ret;
-}
-
-/*
- * remove a single leaf ref from the tree.  This drops the ref held by the tree
- * only
- */
-int btrfs_remove_leaf_ref(struct btrfs_root *root, struct btrfs_leaf_ref *ref)
-{
-	struct btrfs_leaf_ref_tree *tree;
-
-	if (!xchg(&ref->in_tree, 0))
-		return 0;
-
-	tree = ref->tree;
-	spin_lock(&tree->lock);
-
-	rb_erase(&ref->rb_node, &tree->root);
-	list_del_init(&ref->list);
-
-	spin_unlock(&tree->lock);
-
-	btrfs_free_leaf_ref(root, ref);
-	return 0;
-}
diff --git a/fs/btrfs/ref-cache.h b/fs/btrfs/ref-cache.h
index e2a55cb..24f7001 100644
--- a/fs/btrfs/ref-cache.h
+++ b/fs/btrfs/ref-cache.h
@@ -49,28 +49,4 @@ static inline size_t btrfs_leaf_ref_size(int nr_extents)
 	return sizeof(struct btrfs_leaf_ref) +
 	       sizeof(struct btrfs_extent_info) * nr_extents;
 }
-
-static inline void btrfs_leaf_ref_tree_init(struct btrfs_leaf_ref_tree *tree)
-{
-	tree->root = RB_ROOT;
-	INIT_LIST_HEAD(&tree->list);
-	spin_lock_init(&tree->lock);
-}
-
-static inline int btrfs_leaf_ref_tree_empty(struct btrfs_leaf_ref_tree *tree)
-{
-	return RB_EMPTY_ROOT(&tree->root);
-}
-
-void btrfs_leaf_ref_tree_init(struct btrfs_leaf_ref_tree *tree);
-struct btrfs_leaf_ref *btrfs_alloc_leaf_ref(struct btrfs_root *root,
-					    int nr_extents);
-void btrfs_free_leaf_ref(struct btrfs_root *root, struct btrfs_leaf_ref *ref);
-struct btrfs_leaf_ref *btrfs_lookup_leaf_ref(struct btrfs_root *root,
-					     u64 bytenr);
-int btrfs_add_leaf_ref(struct btrfs_root *root, struct btrfs_leaf_ref *ref,
-		       int shared);
-int btrfs_remove_leaf_refs(struct btrfs_root *root, u64 max_root_gen,
-			   int shared);
-int btrfs_remove_leaf_ref(struct btrfs_root *root, struct btrfs_leaf_ref *ref);
 #endif
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index f7b799b..f726e72 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -507,6 +507,7 @@ static int update_backref_cache(struct btrfs_trans_handle *trans,
 	return 1;
 }
 
+
 static int should_ignore_root(struct btrfs_root *root)
 {
 	struct btrfs_root *reloc_root;
@@ -529,7 +530,6 @@ static int should_ignore_root(struct btrfs_root *root)
 	 */
 	return 1;
 }
-
 /*
  * find reloc tree by address of tree root
  */
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 59a94c1..3bcfe5a 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -22,53 +22,6 @@
 #include "print-tree.h"
 
 /*
- *  search forward for a root, starting with objectid 'search_start'
- *  if a root key is found, the objectid we find is filled into 'found_objectid'
- *  and 0 is returned.  < 0 is returned on error, 1 if there is nothing
- *  left in the tree.
- */
-int btrfs_search_root(struct btrfs_root *root, u64 search_start,
-		      u64 *found_objectid)
-{
-	struct btrfs_path *path;
-	struct btrfs_key search_key;
-	int ret;
-
-	root = root->fs_info->tree_root;
-	search_key.objectid = search_start;
-	search_key.type = (u8)-1;
-	search_key.offset = (u64)-1;
-
-	path = btrfs_alloc_path();
-	BUG_ON(!path);
-again:
-	ret = btrfs_search_slot(NULL, root, &search_key, path, 0, 0);
-	if (ret < 0)
-		goto out;
-	if (ret == 0) {
-		ret = 1;
-		goto out;
-	}
-	if (path->slots[0] >= btrfs_header_nritems(path->nodes[0])) {
-		ret = btrfs_next_leaf(root, path);
-		if (ret)
-			goto out;
-	}
-	btrfs_item_key_to_cpu(path->nodes[0], &search_key, path->slots[0]);
-	if (search_key.type != BTRFS_ROOT_ITEM_KEY) {
-		search_key.offset++;
-		btrfs_release_path(path);
-		goto again;
-	}
-	ret = 0;
-	*found_objectid = search_key.objectid;
-
-out:
-	btrfs_free_path(path);
-	return ret;
-}
-
-/*
  * lookup the root with the highest offset for a given objectid.  The key we do
  * find is copied into 'key'.  If we find something return 0, otherwise 1, < 0
  * on error.
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 4ce16ef..ab9633f 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -189,71 +189,6 @@ static struct kobj_type btrfs_super_ktype = {
 /* /sys/fs/btrfs/ entry */
 static struct kset *btrfs_kset;
 
-int btrfs_sysfs_add_super(struct btrfs_fs_info *fs)
-{
-	int error;
-	char *name;
-	char c;
-	int len = strlen(fs->sb->s_id) + 1;
-	int i;
-
-	name = kmalloc(len, GFP_NOFS);
-	if (!name) {
-		error = -ENOMEM;
-		goto fail;
-	}
-
-	for (i = 0; i < len; i++) {
-		c = fs->sb->s_id[i];
-		if (c == '/' || c == '\\')
-			c = '!';
-		name[i] = c;
-	}
-	name[len] = '\0';
-
-	fs->super_kobj.kset = btrfs_kset;
-	error = kobject_init_and_add(&fs->super_kobj, &btrfs_super_ktype,
-				     NULL, "%s", name);
-	kfree(name);
-	if (error)
-		goto fail;
-
-	return 0;
-
-fail:
-	printk(KERN_ERR "btrfs: sysfs creation for super failed\n");
-	return error;
-}
-
-int btrfs_sysfs_add_root(struct btrfs_root *root)
-{
-	int error;
-
-	error = kobject_init_and_add(&root->root_kobj, &btrfs_root_ktype,
-				     &root->fs_info->super_kobj,
-				     "%s", root->name);
-	if (error)
-		goto fail;
-
-	return 0;
-
-fail:
-	printk(KERN_ERR "btrfs: sysfs creation for root failed\n");
-	return error;
-}
-
-void btrfs_sysfs_del_root(struct btrfs_root *root)
-{
-	kobject_put(&root->root_kobj);
-	wait_for_completion(&root->kobj_unregister);
-}
-
-void btrfs_sysfs_del_super(struct btrfs_fs_info *fs)
-{
-	kobject_put(&fs->super_kobj);
-	wait_for_completion(&fs->kobj_unregister);
-}
-
 int btrfs_init_sysfs(void)
 {
 	btrfs_kset = kset_create_and_add("btrfs", NULL, fs_kobj);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e21130d..cd0b31a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -44,16 +44,6 @@ static int btrfs_relocate_sys_chunks(struct btrfs_root *root);
 static DEFINE_MUTEX(uuid_mutex);
 static LIST_HEAD(fs_uuids);
 
-void btrfs_lock_volumes(void)
-{
-	mutex_lock(&uuid_mutex);
-}
-
-void btrfs_unlock_volumes(void)
-{
-	mutex_unlock(&uuid_mutex);
-}
-
 static void lock_chunks(struct btrfs_root *root)
 {
 	mutex_lock(&root->fs_info->chunk_mutex);
@@ -3688,15 +3678,6 @@ static int read_one_dev(struct btrfs_root *root,
 	return ret;
 }
 
-int btrfs_read_super_device(struct btrfs_root *root, struct extent_buffer *buf)
-{
-	struct btrfs_dev_item *dev_item;
-
-	dev_item = (struct btrfs_dev_item *)offsetof(struct btrfs_super_block,
-						     dev_item);
-	return read_one_dev(root, buf, dev_item);
-}
-
 int btrfs_read_sys_array(struct btrfs_root *root)
 {
 	struct btrfs_super_block *super_copy = &root->fs_info->super_copy;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 036b276..5669ae8 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -196,7 +196,6 @@ void btrfs_mapping_init(struct btrfs_mapping_tree *tree);
 void btrfs_mapping_tree_free(struct btrfs_mapping_tree *tree);
 int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 		  int mirror_num, int async_submit);
-int btrfs_read_super_device(struct btrfs_root *root, struct extent_buffer *buf);
 int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 		       fmode_t flags, void *holder);
 int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
@@ -216,8 +215,6 @@ struct btrfs_device *btrfs_find_device(struct btrfs_root *root, u64 devid,
 int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
 int btrfs_init_new_device(struct btrfs_root *root, char *path);
 int btrfs_balance(struct btrfs_root *dev_root);
-void btrfs_unlock_volumes(void);
-void btrfs_lock_volumes(void);
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 int find_free_dev_extent(struct btrfs_trans_handle *trans,
 			 struct btrfs_device *device, u64 num_bytes,
-- 
1.7.5.1.169.g505a1


