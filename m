Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53408 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933313AbcIHOMk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Sep 2016 10:12:40 -0400
Subject: Re: [PATCH 6/7] Btrfs: kill the btree_inode
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
References: <1472845206-22870-1-git-send-email-jbacik@fb.com>
 <1472845206-22870-7-git-send-email-jbacik@fb.com>
 <8570191.KlMn4MSC1V@localhost.localdomain>
CC: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <1bdbbef3-7356-7eb8-a6b2-0678aad74d18@fb.com>
Date: Thu, 8 Sep 2016 10:12:29 -0400
MIME-Version: 1.0
In-Reply-To: <8570191.KlMn4MSC1V@localhost.localdomain>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/08/2016 01:17 AM, Chandan Rajendra wrote:
> On Friday, September 02, 2016 03:40:05 PM Josef Bacik wrote:
>
> Please find my comment inlined below,
>
>> In order to more efficiently support sub-page blocksizes we need to stop
>> allocating pages from pagecache for our metadata.  Instead switch to using the
>> account_metadata* counters for making sure we are keeping the system aware of
>> how much dirty metadata we have, and use the ->free_cached_objects super
>> operation in order to handle freeing up extent buffers.  This greatly simplifies
>> how we deal with extent buffers as now we no longer have to tie the page cache
>> reclaimation stuff to the extent buffer stuff.  This will also allow us to
>> simply kmalloc() our data for sub-page blocksizes.
>>
>> Signed-off-by: Josef Bacik <jbacik@fb.com>
>> ---
>>  fs/btrfs/btrfs_inode.h                 |   3 +-
>>  fs/btrfs/ctree.c                       |  10 +-
>>  fs/btrfs/ctree.h                       |  13 +-
>>  fs/btrfs/disk-io.c                     | 389 ++++----------
>>  fs/btrfs/extent_io.c                   | 913 ++++++++++++++++++---------------
>>  fs/btrfs/extent_io.h                   |  49 +-
>>  fs/btrfs/inode.c                       |   6 +-
>>  fs/btrfs/root-tree.c                   |   2 +-
>>  fs/btrfs/super.c                       |  29 +-
>>  fs/btrfs/tests/btrfs-tests.c           |  37 +-
>>  fs/btrfs/tests/extent-io-tests.c       |   4 +-
>>  fs/btrfs/tests/free-space-tree-tests.c |   4 +-
>>  fs/btrfs/tests/qgroup-tests.c          |   4 +-
>>  fs/btrfs/transaction.c                 |  11 +-
>>  14 files changed, 726 insertions(+), 748 deletions(-)
>>
>> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
>> index 1a8fa46..ad7b185 100644
>> --- a/fs/btrfs/btrfs_inode.h
>> +++ b/fs/btrfs/btrfs_inode.h
>> @@ -229,10 +229,9 @@ static inline u64 btrfs_ino(struct inode *inode)
>>  	u64 ino = BTRFS_I(inode)->location.objectid;
>>
>>  	/*
>> -	 * !ino: btree_inode
>>  	 * type == BTRFS_ROOT_ITEM_KEY: subvol dir
>>  	 */
>> -	if (!ino || BTRFS_I(inode)->location.type == BTRFS_ROOT_ITEM_KEY)
>> +	if (BTRFS_I(inode)->location.type == BTRFS_ROOT_ITEM_KEY)
>>  		ino = inode->i_ino;
>>  	return ino;
>>  }
>> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
>> index d1c56c9..b267053 100644
>> --- a/fs/btrfs/ctree.c
>> +++ b/fs/btrfs/ctree.c
>> @@ -1373,8 +1373,8 @@ tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
>>
>>  	if (tm->op == MOD_LOG_KEY_REMOVE_WHILE_FREEING) {
>>  		BUG_ON(tm->slot != 0);
>> -		eb_rewin = alloc_dummy_extent_buffer(fs_info, eb->start,
>> -						eb->len);
>> +		eb_rewin = alloc_dummy_extent_buffer(fs_info->eb_info,
>> +						     eb->start, eb->len);
>>  		if (!eb_rewin) {
>>  			btrfs_tree_read_unlock_blocking(eb);
>>  			free_extent_buffer(eb);
>> @@ -1455,8 +1455,8 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
>>  	} else if (old_root) {
>>  		btrfs_tree_read_unlock(eb_root);
>>  		free_extent_buffer(eb_root);
>> -		eb = alloc_dummy_extent_buffer(root->fs_info, logical,
>> -					root->nodesize);
>> +		eb = alloc_dummy_extent_buffer(root->fs_info->eb_info, logical,
>> +					       root->nodesize);
>>  	} else {
>>  		btrfs_set_lock_blocking_rw(eb_root, BTRFS_READ_LOCK);
>>  		eb = btrfs_clone_extent_buffer(eb_root);
>> @@ -1772,7 +1772,7 @@ static noinline int generic_bin_search(struct extent_buffer *eb,
>>  	int err;
>>
>>  	if (low > high) {
>> -		btrfs_err(eb->fs_info,
>> +		btrfs_err(eb->eb_info->fs_info,
>>  		 "%s: low (%d) > high (%d) eb %llu owner %llu level %d",
>>  			  __func__, low, high, eb->start,
>>  			  btrfs_header_owner(eb), btrfs_header_level(eb));
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index 282a031..ee6956c 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -37,6 +37,7 @@
>>  #include <linux/workqueue.h>
>>  #include <linux/security.h>
>>  #include <linux/sizes.h>
>> +#include <linux/list_lru.h>
>>  #include "extent_io.h"
>>  #include "extent_map.h"
>>  #include "async-thread.h"
>> @@ -675,6 +676,7 @@ struct btrfs_device;
>>  struct btrfs_fs_devices;
>>  struct btrfs_balance_control;
>>  struct btrfs_delayed_root;
>> +struct btrfs_eb_info;
>>
>>  #define BTRFS_FS_BARRIER			1
>>  #define BTRFS_FS_CLOSING_START			2
>> @@ -797,7 +799,7 @@ struct btrfs_fs_info {
>>  	struct btrfs_super_block *super_for_commit;
>>  	struct block_device *__bdev;
>>  	struct super_block *sb;
>> -	struct inode *btree_inode;
>> +	struct btrfs_eb_info *eb_info;
>>  	struct backing_dev_info bdi;
>>  	struct mutex tree_log_mutex;
>>  	struct mutex transaction_kthread_mutex;
>> @@ -1042,10 +1044,6 @@ struct btrfs_fs_info {
>>  	/* readahead works cnt */
>>  	atomic_t reada_works_cnt;
>>
>> -	/* Extent buffer radix tree */
>> -	spinlock_t buffer_lock;
>> -	struct radix_tree_root buffer_radix;
>> -
>>  	/* next backup root to be overwritten */
>>  	int backup_root_index;
>>
>> @@ -2884,6 +2882,8 @@ static inline int btrfs_need_cleaner_sleep(struct btrfs_root *root)
>>
>>  static inline void free_fs_info(struct btrfs_fs_info *fs_info)
>>  {
>> +	list_lru_destroy(&fs_info->eb_info->lru_list);
>> +	kfree(fs_info->eb_info);
>>  	kfree(fs_info->balance_ctl);
>>  	kfree(fs_info->delayed_root);
>>  	kfree(fs_info->extent_root);
>> @@ -3121,9 +3121,6 @@ int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
>>  			     struct btrfs_root *new_root,
>>  			     struct btrfs_root *parent_root,
>>  			     u64 new_dirid);
>> -int btrfs_merge_bio_hook(struct page *page, unsigned long offset,
>> -			 size_t size, struct bio *bio,
>> -			 unsigned long bio_flags);
>>  void btrfs_set_range_writeback(void *private_data, u64 start, u64 end);
>>  int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
>>  int btrfs_readpage(struct file *file, struct page *page);
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 9c42e53..03ac601 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -217,56 +217,6 @@ void btrfs_set_buffer_lockdep_class(u64 objectid, struct extent_buffer *eb,
>>
>>  #endif
>>
>> -/*
>> - * extents on the btree inode are pretty simple, there's one extent
>> - * that covers the entire device
>> - */
>> -static struct extent_map *btree_get_extent(struct inode *inode,
>> -		struct page *page, size_t pg_offset, u64 start, u64 len,
>> -		int create)
>> -{
>> -	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
>> -	struct extent_map *em;
>> -	int ret;
>> -
>> -	read_lock(&em_tree->lock);
>> -	em = lookup_extent_mapping(em_tree, start, len);
>> -	if (em) {
>> -		em->bdev =
>> -			BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev;
>> -		read_unlock(&em_tree->lock);
>> -		goto out;
>> -	}
>> -	read_unlock(&em_tree->lock);
>> -
>> -	em = alloc_extent_map();
>> -	if (!em) {
>> -		em = ERR_PTR(-ENOMEM);
>> -		goto out;
>> -	}
>> -	em->start = 0;
>> -	em->len = (u64)-1;
>> -	em->block_len = (u64)-1;
>> -	em->block_start = 0;
>> -	em->bdev = BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev;
>> -
>> -	write_lock(&em_tree->lock);
>> -	ret = add_extent_mapping(em_tree, em, 0);
>> -	if (ret == -EEXIST) {
>> -		free_extent_map(em);
>> -		em = lookup_extent_mapping(em_tree, start, len);
>> -		if (!em)
>> -			em = ERR_PTR(-EIO);
>> -	} else if (ret) {
>> -		free_extent_map(em);
>> -		em = ERR_PTR(ret);
>> -	}
>> -	write_unlock(&em_tree->lock);
>> -
>> -out:
>> -	return em;
>> -}
>> -
>>  u32 btrfs_csum_data(char *data, u32 seed, size_t len)
>>  {
>>  	return btrfs_crc32c(seed, data, len);
>> @@ -349,11 +299,11 @@ static int csum_tree_block(struct btrfs_fs_info *fs_info,
>>   * detect blocks that either didn't get written at all or got written
>>   * in the wrong place.
>>   */
>> -static int verify_parent_transid(struct extent_io_tree *io_tree,
>> -				 struct extent_buffer *eb, u64 parent_transid,
>> +static int verify_parent_transid(struct extent_buffer *eb, u64 parent_transid,
>>  				 int atomic)
>>  {
>>  	struct extent_state *cached_state = NULL;
>> +	struct extent_io_tree *io_tree = &eb->eb_info->io_tree;
>>  	int ret;
>>  	bool need_lock = (current->journal_info == BTRFS_SEND_TRANS_STUB);
>>
>> @@ -375,7 +325,7 @@ static int verify_parent_transid(struct extent_io_tree *io_tree,
>>  		ret = 0;
>>  		goto out;
>>  	}
>> -	btrfs_err_rl(eb->fs_info,
>> +	btrfs_err_rl(eb->eb_info->fs_info,
>>  		"parent transid verify failed on %llu wanted %llu found %llu",
>>  			eb->start,
>>  			parent_transid, btrfs_header_generation(eb));
>> @@ -445,7 +395,6 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
>>  					  struct extent_buffer *eb,
>>  					  u64 parent_transid)
>>  {
>> -	struct extent_io_tree *io_tree;
>>  	int failed = 0;
>>  	int ret;
>>  	int num_copies = 0;
>> @@ -453,13 +402,10 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
>>  	int failed_mirror = 0;
>>
>>  	clear_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
>> -	io_tree = &BTRFS_I(root->fs_info->btree_inode)->io_tree;
>>  	while (1) {
>> -		ret = read_extent_buffer_pages(io_tree, eb, WAIT_COMPLETE,
>> -					       btree_get_extent, mirror_num);
>> +		ret = read_extent_buffer_pages(eb, WAIT_COMPLETE, mirror_num);
>>  		if (!ret) {
>> -			if (!verify_parent_transid(io_tree, eb,
>> -						   parent_transid, 0))
>> +			if (!verify_parent_transid(eb, parent_transid, 0))
>>  				break;
>>  			else
>>  				ret = -EIO;
>> @@ -504,24 +450,11 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
>>
>>  static int csum_dirty_buffer(struct btrfs_fs_info *fs_info, struct page *page)
>>  {
>> -	u64 start = page_offset(page);
>> -	u64 found_start;
>>  	struct extent_buffer *eb;
>>
>>  	eb = (struct extent_buffer *)page->private;
>>  	if (page != eb->pages[0])
>>  		return 0;
>> -
>> -	found_start = btrfs_header_bytenr(eb);
>> -	/*
>> -	 * Please do not consolidate these warnings into a single if.
>> -	 * It is useful to know what went wrong.
>> -	 */
>> -	if (WARN_ON(found_start != start))
>> -		return -EUCLEAN;
>> -	if (WARN_ON(!PageUptodate(page)))
>> -		return -EUCLEAN;
>> -
>>  	ASSERT(memcmp_extent_buffer(eb, fs_info->fsid,
>>  			btrfs_header_fsid(), BTRFS_FSID_SIZE) == 0);
>>
>> @@ -619,8 +552,8 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
>>  	u64 found_start;
>>  	int found_level;
>>  	struct extent_buffer *eb;
>> -	struct btrfs_root *root = BTRFS_I(page->mapping->host)->root;
>> -	struct btrfs_fs_info *fs_info = root->fs_info;
>> +	struct btrfs_root *root;
>> +	struct btrfs_fs_info *fs_info;
>>  	int ret = 0;
>>  	int reads_done;
>>
>> @@ -633,6 +566,8 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
>>  	 * in memory.  Make sure we have a ref for all this other checks
>>  	 */
>>  	extent_buffer_get(eb);
>> +	fs_info = eb->eb_info->fs_info;
>> +	root = fs_info->tree_root;
>>
>>  	reads_done = atomic_dec_and_test(&eb->io_pages);
>>  	if (!reads_done)
>> @@ -693,11 +628,19 @@ err:
>>  		/*
>>  		 * our io error hook is going to dec the io pages
>>  		 * again, we have to make sure it has something
>> -		 * to decrement
>> +		 * to decrement.
>> +		 *
>> +		 * TODO: Kill this, we've re-arranged how this works now so we
>> +		 * don't need to do this io_pages dance.
>>  		 */
>>  		atomic_inc(&eb->io_pages);
>>  		clear_extent_buffer_uptodate(eb);
>>  	}
>> +	if (reads_done) {
>> +		clear_bit(EXTENT_BUFFER_READING, &eb->bflags);
>> +		smp_mb__after_atomic();
>> +		wake_up_bit(&eb->bflags, EXTENT_BUFFER_READING);
>> +	}
>>  	free_extent_buffer(eb);
>>  out:
>>  	return ret;
>> @@ -712,7 +655,7 @@ static int btree_io_failed_hook(struct page *page, int failed_mirror)
>>  	eb->read_mirror = failed_mirror;
>>  	atomic_dec(&eb->io_pages);
>>  	if (test_and_clear_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags))
>> -		btree_readahead_hook(eb->fs_info, eb, eb->start, -EIO);
>> +		btree_readahead_hook(eb->eb_info->fs_info, eb, eb->start, -EIO);
>>  	return -EIO;	/* we fixed nothing */
>>  }
>>
>> @@ -884,15 +827,13 @@ int btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
>>  	return 0;
>>  }
>>
>> -static int btree_csum_one_bio(struct bio *bio)
>> +static int btree_csum_one_bio(struct btrfs_fs_info *fs_info, struct bio *bio)
>>  {
>>  	struct bio_vec *bvec;
>> -	struct btrfs_root *root;
>>  	int i, ret = 0;
>>
>>  	bio_for_each_segment_all(bvec, bio, i) {
>> -		root = BTRFS_I(bvec->bv_page->mapping->host)->root;
>> -		ret = csum_dirty_buffer(root->fs_info, bvec->bv_page);
>> +		ret = csum_dirty_buffer(fs_info, bvec->bv_page);
>>  		if (ret)
>>  			break;
>>  	}
>> @@ -904,25 +845,27 @@ static int __btree_submit_bio_start(void *private_data, struct bio *bio,
>>  				    int mirror_num, unsigned long bio_flags,
>>  				    u64 bio_offset)
>>  {
>> +	struct btrfs_eb_info *eb_info = private_data;
>>  	/*
>>  	 * when we're called for a write, we're already in the async
>>  	 * submission context.  Just jump into btrfs_map_bio
>>  	 */
>> -	return btree_csum_one_bio(bio);
>> +	return btree_csum_one_bio(eb_info->fs_info, bio);
>>  }
>>
>>  static int __btree_submit_bio_done(void *private_data, struct bio *bio,
>>  				 int mirror_num, unsigned long bio_flags,
>>  				 u64 bio_offset)
>>  {
>> -	struct inode *inode = private_data;
>> +	struct btrfs_eb_info *eb_info = private_data;
>> +	struct btrfs_root *root = eb_info->fs_info->tree_root;
>>  	int ret;
>>
>>  	/*
>>  	 * when we're called for a write, we're already in the async
>>  	 * submission context.  Just jump into btrfs_map_bio
>>  	 */
>> -	ret = btrfs_map_bio(BTRFS_I(inode)->root, bio, mirror_num, 1);
>> +	ret = btrfs_map_bio(root, bio, mirror_num, 1);
>>  	if (ret) {
>>  		bio->bi_error = ret;
>>  		bio_endio(bio);
>> @@ -930,7 +873,7 @@ static int __btree_submit_bio_done(void *private_data, struct bio *bio,
>>  	return ret;
>>  }
>>
>> -static int check_async_write(struct inode *inode, unsigned long bio_flags)
>> +static int check_async_write(unsigned long bio_flags)
>>  {
>>  	if (bio_flags & EXTENT_BIO_TREE_LOG)
>>  		return 0;
>> @@ -945,8 +888,9 @@ static int btree_submit_bio_hook(void *private_data, struct bio *bio,
>>  				 int mirror_num, unsigned long bio_flags,
>>  				 u64 bio_offset)
>>  {
>> -	struct inode *inode = private_data;
>> -	int async = check_async_write(inode, bio_flags);
>> +	struct btrfs_eb_info *eb_info = private_data;
>> +	struct btrfs_root *root = eb_info->fs_info->tree_root;
>> +	int async = check_async_write(bio_flags);
>>  	int ret;
>>
>>  	if (bio_op(bio) != REQ_OP_WRITE) {
>> @@ -954,23 +898,22 @@ static int btree_submit_bio_hook(void *private_data, struct bio *bio,
>>  		 * called for a read, do the setup so that checksum validation
>>  		 * can happen in the async kernel threads
>>  		 */
>> -		ret = btrfs_bio_wq_end_io(BTRFS_I(inode)->root->fs_info,
>> -					  bio, BTRFS_WQ_ENDIO_METADATA);
>> +		ret = btrfs_bio_wq_end_io(eb_info->fs_info, bio,
>> +					  BTRFS_WQ_ENDIO_METADATA);
>>  		if (ret)
>>  			goto out_w_error;
>> -		ret = btrfs_map_bio(BTRFS_I(inode)->root, bio, mirror_num, 0);
>> +		ret = btrfs_map_bio(root, bio, mirror_num, 0);
>>  	} else if (!async) {
>> -		ret = btree_csum_one_bio(bio);
>> +		ret = btree_csum_one_bio(eb_info->fs_info, bio);
>>  		if (ret)
>>  			goto out_w_error;
>> -		ret = btrfs_map_bio(BTRFS_I(inode)->root, bio, mirror_num, 0);
>> +		ret = btrfs_map_bio(root, bio, mirror_num, 0);
>>  	} else {
>>  		/*
>>  		 * kthread helpers are used to submit writes so that
>>  		 * checksumming can happen in parallel across all CPUs
>>  		 */
>> -		ret = btrfs_wq_submit_bio(BTRFS_I(inode)->root->fs_info,
>> -					  bio, mirror_num, 0,
>> +		ret = btrfs_wq_submit_bio(eb_info->fs_info, bio, mirror_num, 0,
>>  					  bio_offset, private_data,
>>  					  __btree_submit_bio_start,
>>  					  __btree_submit_bio_done);
>> @@ -986,118 +929,14 @@ out_w_error:
>>  	return ret;
>>  }
>>
>> -#ifdef CONFIG_MIGRATION
>> -static int btree_migratepage(struct address_space *mapping,
>> -			struct page *newpage, struct page *page,
>> -			enum migrate_mode mode)
>> -{
>> -	/*
>> -	 * we can't safely write a btree page from here,
>> -	 * we haven't done the locking hook
>> -	 */
>> -	if (PageDirty(page))
>> -		return -EAGAIN;
>> -	/*
>> -	 * Buffers may be managed in a filesystem specific way.
>> -	 * We must have no buffers or drop them.
>> -	 */
>> -	if (page_has_private(page) &&
>> -	    !try_to_release_page(page, GFP_KERNEL))
>> -		return -EAGAIN;
>> -	return migrate_page(mapping, newpage, page, mode);
>> -}
>> -#endif
>> -
>> -
>> -static int btree_writepages(struct address_space *mapping,
>> -			    struct writeback_control *wbc)
>> -{
>> -	struct btrfs_fs_info *fs_info;
>> -	int ret;
>> -
>> -	if (wbc->sync_mode == WB_SYNC_NONE) {
>> -
>> -		if (wbc->for_kupdate)
>> -			return 0;
>> -
>> -		fs_info = BTRFS_I(mapping->host)->root->fs_info;
>> -		/* this is a bit racy, but that's ok */
>> -		ret = percpu_counter_compare(&fs_info->dirty_metadata_bytes,
>> -					     BTRFS_DIRTY_METADATA_THRESH);
>> -		if (ret < 0)
>> -			return 0;
>> -	}
>> -	return btree_write_cache_pages(mapping, wbc);
>> -}
>> -
>> -static int btree_readpage(struct file *file, struct page *page)
>> -{
>> -	struct extent_io_tree *tree;
>> -	tree = &BTRFS_I(page->mapping->host)->io_tree;
>> -	return extent_read_full_page(tree, page, btree_get_extent, 0);
>> -}
>> -
>> -static int btree_releasepage(struct page *page, gfp_t gfp_flags)
>> -{
>> -	if (PageWriteback(page) || PageDirty(page))
>> -		return 0;
>> -
>> -	return try_release_extent_buffer(page);
>> -}
>> -
>> -static void btree_invalidatepage(struct page *page, unsigned int offset,
>> -				 unsigned int length)
>> -{
>> -	struct extent_io_tree *tree;
>> -	tree = &BTRFS_I(page->mapping->host)->io_tree;
>> -	extent_invalidatepage(tree, page, offset);
>> -	btree_releasepage(page, GFP_NOFS);
>> -	if (PagePrivate(page)) {
>> -		btrfs_warn(BTRFS_I(page->mapping->host)->root->fs_info,
>> -			   "page private not zero on page %llu",
>> -			   (unsigned long long)page_offset(page));
>> -		ClearPagePrivate(page);
>> -		set_page_private(page, 0);
>> -		put_page(page);
>> -	}
>> -}
>> -
>> -static int btree_set_page_dirty(struct page *page)
>> -{
>> -#ifdef DEBUG
>> -	struct extent_buffer *eb;
>> -
>> -	BUG_ON(!PagePrivate(page));
>> -	eb = (struct extent_buffer *)page->private;
>> -	BUG_ON(!eb);
>> -	BUG_ON(!test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
>> -	BUG_ON(!atomic_read(&eb->refs));
>> -	btrfs_assert_tree_locked(eb);
>> -#endif
>> -	return __set_page_dirty_nobuffers(page);
>> -}
>> -
>> -static const struct address_space_operations btree_aops = {
>> -	.readpage	= btree_readpage,
>> -	.writepages	= btree_writepages,
>> -	.releasepage	= btree_releasepage,
>> -	.invalidatepage = btree_invalidatepage,
>> -#ifdef CONFIG_MIGRATION
>> -	.migratepage	= btree_migratepage,
>> -#endif
>> -	.set_page_dirty = btree_set_page_dirty,
>> -};
>> -
>>  void readahead_tree_block(struct btrfs_root *root, u64 bytenr)
>>  {
>>  	struct extent_buffer *buf = NULL;
>> -	struct inode *btree_inode = root->fs_info->btree_inode;
>>
>>  	buf = btrfs_find_create_tree_block(root, bytenr);
>>  	if (IS_ERR(buf))
>>  		return;
>> -	read_extent_buffer_pages(&BTRFS_I(btree_inode)->io_tree,
>> -				 buf, WAIT_NONE, btree_get_extent, 0);
>> +	read_extent_buffer_pages(buf, WAIT_NONE, 0);
>>  	free_extent_buffer(buf);
>>  }
>>
>> @@ -1105,8 +944,6 @@ int reada_tree_block_flagged(struct btrfs_root *root, u64 bytenr,
>>  			 int mirror_num, struct extent_buffer **eb)
>>  {
>>  	struct extent_buffer *buf = NULL;
>> -	struct inode *btree_inode = root->fs_info->btree_inode;
>> -	struct extent_io_tree *io_tree = &BTRFS_I(btree_inode)->io_tree;
>>  	int ret;
>>
>>  	buf = btrfs_find_create_tree_block(root, bytenr);
>> @@ -1115,8 +952,7 @@ int reada_tree_block_flagged(struct btrfs_root *root, u64 bytenr,
>>
>>  	set_bit(EXTENT_BUFFER_READAHEAD, &buf->bflags);
>>
>> -	ret = read_extent_buffer_pages(io_tree, buf, WAIT_PAGE_LOCK,
>> -				       btree_get_extent, mirror_num);
>> +	ret = read_extent_buffer_pages(buf, WAIT_PAGE_LOCK, mirror_num);
>>  	if (ret) {
>>  		free_extent_buffer(buf);
>>  		return ret;
>> @@ -1136,29 +972,29 @@ int reada_tree_block_flagged(struct btrfs_root *root, u64 bytenr,
>>  struct extent_buffer *btrfs_find_tree_block(struct btrfs_fs_info *fs_info,
>>  					    u64 bytenr)
>>  {
>> -	return find_extent_buffer(fs_info, bytenr);
>> +	return find_extent_buffer(fs_info->eb_info, bytenr);
>>  }
>>
>>  struct extent_buffer *btrfs_find_create_tree_block(struct btrfs_root *root,
>>  						 u64 bytenr)
>>  {
>>  	if (btrfs_is_testing(root->fs_info))
>> -		return alloc_test_extent_buffer(root->fs_info, bytenr,
>> -				root->nodesize);
>> +		return alloc_test_extent_buffer(root->fs_info->eb_info, bytenr,
>> +						root->nodesize);
>>  	return alloc_extent_buffer(root->fs_info, bytenr);
>>  }
>>
>>
>>  int btrfs_write_tree_block(struct extent_buffer *buf)
>>  {
>> -	return filemap_fdatawrite_range(buf->pages[0]->mapping, buf->start,
>> -					buf->start + buf->len - 1);
>> +	return btree_write_range(buf->eb_info->fs_info, buf->start,
>> +				 buf->start + buf->len - 1);
>>  }
>>
>>  int btrfs_wait_tree_block_writeback(struct extent_buffer *buf)
>>  {
>> -	return filemap_fdatawait_range(buf->pages[0]->mapping,
>> -				       buf->start, buf->start + buf->len - 1);
>> +	return btree_wait_range(buf->eb_info->fs_info, buf->start,
>> +				buf->start + buf->len - 1);
>>  }
>>
>>  struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
>> @@ -1188,14 +1024,10 @@ void clean_tree_block(struct btrfs_trans_handle *trans,
>>  	    fs_info->running_transaction->transid) {
>>  		btrfs_assert_tree_locked(buf);
>>
>> -		if (test_and_clear_bit(EXTENT_BUFFER_DIRTY, &buf->bflags)) {
>> +		if (clear_extent_buffer_dirty(buf))
>>  			__percpu_counter_add(&fs_info->dirty_metadata_bytes,
>>  					     -buf->len,
>>  					     fs_info->dirty_metadata_batch);
>> -			/* ugh, clear_extent_buffer_dirty needs to lock the page */
>> -			btrfs_set_lock_blocking(buf);
>> -			clear_extent_buffer_dirty(buf);
>> -		}
>>  	}
>>  }
>>
>> @@ -2247,33 +2079,20 @@ static void btrfs_init_balance(struct btrfs_fs_info *fs_info)
>>  	init_waitqueue_head(&fs_info->balance_wait_q);
>>  }
>>
>> -static void btrfs_init_btree_inode(struct btrfs_fs_info *fs_info,
>> -				   struct btrfs_root *tree_root)
>> +int btrfs_init_eb_info(struct btrfs_fs_info *fs_info)
>>  {
>> -	fs_info->btree_inode->i_ino = BTRFS_BTREE_INODE_OBJECTID;
>> -	set_nlink(fs_info->btree_inode, 1);
>> -	/*
>> -	 * we set the i_size on the btree inode to the max possible int.
>> -	 * the real end of the address space is determined by all of
>> -	 * the devices in the system
>> -	 */
>> -	fs_info->btree_inode->i_size = OFFSET_MAX;
>> -	fs_info->btree_inode->i_mapping->a_ops = &btree_aops;
>> -
>> -	RB_CLEAR_NODE(&BTRFS_I(fs_info->btree_inode)->rb_node);
>> -	extent_io_tree_init(&BTRFS_I(fs_info->btree_inode)->io_tree,
>> -			    fs_info->btree_inode);
>> -	BTRFS_I(fs_info->btree_inode)->io_tree.track_uptodate = 0;
>> -	extent_map_tree_init(&BTRFS_I(fs_info->btree_inode)->extent_tree);
>> -
>> -	BTRFS_I(fs_info->btree_inode)->io_tree.ops = &btree_extent_io_ops;
>> -
>> -	BTRFS_I(fs_info->btree_inode)->root = tree_root;
>> -	memset(&BTRFS_I(fs_info->btree_inode)->location, 0,
>> -	       sizeof(struct btrfs_key));
>> -	set_bit(BTRFS_INODE_DUMMY,
>> -		&BTRFS_I(fs_info->btree_inode)->runtime_flags);
>> -	btrfs_insert_inode_hash(fs_info->btree_inode);
>> +	struct btrfs_eb_info *eb_info = fs_info->eb_info;
>> +
>> +	eb_info->fs_info = fs_info;
>> +	extent_io_tree_init(&eb_info->io_tree, eb_info);
>> +	eb_info->io_tree.track_uptodate = 0;
>> +	eb_info->io_tree.ops = &btree_extent_io_ops;
>> +	extent_io_tree_init(&eb_info->io_failure_tree, eb_info);
>> +	INIT_RADIX_TREE(&eb_info->buffer_radix, GFP_ATOMIC);
>> +	spin_lock_init(&eb_info->buffer_lock);
>> +	if (list_lru_init(&eb_info->lru_list))
>> +		return -ENOMEM;
>> +	return 0;
>>  }
>>
>>  static void btrfs_init_dev_replace_locks(struct btrfs_fs_info *fs_info)
>> @@ -2566,16 +2385,7 @@ int open_ctree(struct super_block *sb,
>>  		goto fail_delalloc_bytes;
>>  	}
>>
>> -	fs_info->btree_inode = new_inode(sb);
>> -	if (!fs_info->btree_inode) {
>> -		err = -ENOMEM;
>> -		goto fail_bio_counter;
>> -	}
>> -
>> -	mapping_set_gfp_mask(fs_info->btree_inode->i_mapping, GFP_NOFS);
>> -
>>  	INIT_RADIX_TREE(&fs_info->fs_roots_radix, GFP_ATOMIC);
>> -	INIT_RADIX_TREE(&fs_info->buffer_radix, GFP_ATOMIC);
>>  	INIT_LIST_HEAD(&fs_info->trans_list);
>>  	INIT_LIST_HEAD(&fs_info->dead_roots);
>>  	INIT_LIST_HEAD(&fs_info->delayed_iputs);
>> @@ -2590,7 +2400,6 @@ int open_ctree(struct super_block *sb,
>>  	spin_lock_init(&fs_info->tree_mod_seq_lock);
>>  	spin_lock_init(&fs_info->super_lock);
>>  	spin_lock_init(&fs_info->qgroup_op_lock);
>> -	spin_lock_init(&fs_info->buffer_lock);
>>  	spin_lock_init(&fs_info->unused_bgs_lock);
>>  	rwlock_init(&fs_info->tree_mod_log_lock);
>>  	mutex_init(&fs_info->unused_bg_unpin_mutex);
>> @@ -2643,7 +2452,7 @@ int open_ctree(struct super_block *sb,
>>  					GFP_KERNEL);
>>  	if (!fs_info->delayed_root) {
>>  		err = -ENOMEM;
>> -		goto fail_iput;
>> +		goto fail_alloc;
>>  	}
>>  	btrfs_init_delayed_root(fs_info->delayed_root);
>>
>> @@ -2658,7 +2467,15 @@ int open_ctree(struct super_block *sb,
>>  	sb->s_blocksize_bits = blksize_bits(4096);
>>  	sb->s_bdi = &fs_info->bdi;
>>
>> -	btrfs_init_btree_inode(fs_info, tree_root);
>> +	fs_info->eb_info = kzalloc(sizeof(struct btrfs_eb_info), GFP_KERNEL);
>> +	if (!fs_info->eb_info) {
>> +		err = -ENOMEM;
>> +		goto fail_alloc;
>> +	}
>> +	if (btrfs_init_eb_info(fs_info)) {
>> +		err = -ENOMEM;
>> +		goto fail_alloc;
>> +	}
>>
>>  	spin_lock_init(&fs_info->block_group_cache_lock);
>>  	fs_info->block_group_cache_tree = RB_ROOT;
>> @@ -3085,6 +2902,14 @@ retry_root_backup:
>>  	if (sb->s_flags & MS_RDONLY)
>>  		return 0;
>>
>> +	/*
>> +	 * We need to make sure we are on the bdi's dirty list so we get
>> +	 * writeback requests for our fs properly.
>> +	 */
>> +	spin_lock(&fs_info->bdi.sb_list_lock);
>> +	list_add_tail(&fs_info->bdi.dirty_sb_list, &sb->s_bdi_list);
>> +	spin_unlock(&fs_info->bdi.sb_list_lock);
>> +
>>  	if (btrfs_test_opt(tree_root->fs_info, FREE_SPACE_TREE) &&
>>  	    !btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE)) {
>>  		btrfs_info(fs_info, "creating free space tree");
>> @@ -3180,7 +3005,8 @@ fail_cleaner:
>>  	 * make sure we're done with the btree inode before we stop our
>>  	 * kthreads
>>  	 */
>> -	filemap_write_and_wait(fs_info->btree_inode->i_mapping);
>> +	btree_write_range(fs_info, 0, (u64)-1);
>> +	btree_wait_range(fs_info, 0, (u64)-1);
>>
>>  fail_sysfs:
>>  	btrfs_sysfs_remove_mounted(fs_info);
>> @@ -3194,16 +3020,11 @@ fail_block_groups:
>>
>>  fail_tree_roots:
>>  	free_root_pointers(fs_info, 1);
>> -	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
>> -
>> +	btrfs_invalidate_eb_info(fs_info->eb_info);
>>  fail_sb_buffer:
>>  	btrfs_stop_all_workers(fs_info);
>>  fail_alloc:
>> -fail_iput:
>>  	btrfs_mapping_tree_free(&fs_info->mapping_tree);
>> -
>> -	iput(fs_info->btree_inode);
>> -fail_bio_counter:
>>  	percpu_counter_destroy(&fs_info->bio_counter);
>>  fail_delalloc_bytes:
>>  	percpu_counter_destroy(&fs_info->delalloc_bytes);
>> @@ -3908,14 +3729,11 @@ void close_ctree(struct btrfs_root *root)
>>  	 * we must make sure there is not any read request to
>>  	 * submit after we stopping all workers.
>>  	 */
>> -	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
>>  	btrfs_stop_all_workers(fs_info);
>>
>>  	clear_bit(BTRFS_FS_OPEN, &fs_info->flags);
>>  	free_root_pointers(fs_info, 1);
>>
>> -	iput(fs_info->btree_inode);
>> -
>>  #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
>>  	if (btrfs_test_opt(root->fs_info, CHECK_INTEGRITY))
>>  		btrfsic_unmount(root, fs_info->fs_devices);
>> @@ -3924,6 +3742,8 @@ void close_ctree(struct btrfs_root *root)
>>  	btrfs_close_devices(fs_info->fs_devices);
>>  	btrfs_mapping_tree_free(&fs_info->mapping_tree);
>>
>> +	btrfs_invalidate_eb_info(fs_info->eb_info);
>> +
>>  	percpu_counter_destroy(&fs_info->dirty_metadata_bytes);
>>  	percpu_counter_destroy(&fs_info->delalloc_bytes);
>>  	percpu_counter_destroy(&fs_info->bio_counter);
>> @@ -3951,14 +3771,12 @@ int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid,
>>  			  int atomic)
>>  {
>>  	int ret;
>> -	struct inode *btree_inode = buf->pages[0]->mapping->host;
>>
>>  	ret = extent_buffer_uptodate(buf);
>>  	if (!ret)
>>  		return ret;
>>
>> -	ret = verify_parent_transid(&BTRFS_I(btree_inode)->io_tree, buf,
>> -				    parent_transid, atomic);
>> +	ret = verify_parent_transid(buf, parent_transid, atomic);
>>  	if (ret == -EAGAIN)
>>  		return ret;
>>  	return !ret;
>> @@ -3979,7 +3797,7 @@ void btrfs_mark_buffer_dirty(struct extent_buffer *buf)
>>  	if (unlikely(test_bit(EXTENT_BUFFER_DUMMY, &buf->bflags)))
>>  		return;
>>  #endif
>> -	root = BTRFS_I(buf->pages[0]->mapping->host)->root;
>> +	root = buf->eb_info->fs_info->tree_root;
>>  	btrfs_assert_tree_locked(buf);
>>  	if (transid != root->fs_info->generation)
>>  		WARN(1, KERN_CRIT "btrfs transid mismatch buffer %llu, "
>> @@ -4015,10 +3833,9 @@ static void __btrfs_btree_balance_dirty(struct btrfs_root *root,
>>
>>  	ret = percpu_counter_compare(&root->fs_info->dirty_metadata_bytes,
>>  				     BTRFS_DIRTY_METADATA_THRESH);
>> -	if (ret > 0) {
>> +	if (ret > 0)
>>  		balance_dirty_pages_ratelimited(&root->fs_info->bdi,
>>  						root->fs_info->sb);
>> -	}
>>  }
>>
>>  void btrfs_btree_balance_dirty(struct btrfs_root *root)
>> @@ -4033,7 +3850,7 @@ void btrfs_btree_balance_dirty_nodelay(struct btrfs_root *root)
>>
>>  int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid)
>>  {
>> -	struct btrfs_root *root = BTRFS_I(buf->pages[0]->mapping->host)->root;
>> +	struct btrfs_root *root = buf->eb_info->fs_info->tree_root;
>>  	return btree_read_extent_buffer_pages(root, buf, parent_transid);
>>  }
>>
>> @@ -4376,10 +4193,7 @@ static int btrfs_destroy_marked_extents(struct btrfs_root *root,
>>  			if (!eb)
>>  				continue;
>>  			wait_on_extent_buffer_writeback(eb);
>> -
>> -			if (test_and_clear_bit(EXTENT_BUFFER_DIRTY,
>> -					       &eb->bflags))
>> -				clear_extent_buffer_dirty(eb);
>> +			clear_extent_buffer_dirty(eb);
>>  			free_extent_buffer_stale(eb);
>>  		}
>>  	}
>> @@ -4504,16 +4318,37 @@ static int btrfs_cleanup_transaction(struct btrfs_root *root)
>>
>>  static struct btrfs_fs_info *btree_fs_info(void *private_data)
>>  {
>> -	struct inode *inode = private_data;
>> -	return btrfs_sb(inode->i_sb);
>> +	struct btrfs_eb_info *eb_info = private_data;
>> +	return eb_info->fs_info;
>> +}
>> +
>> +static int btree_merge_bio_hook(struct page *page, unsigned long offset,
>> +				size_t size, struct bio *bio,
>> +				unsigned long bio_flags)
>> +{
>> +	struct extent_buffer *eb = (struct extent_buffer *)page->private;
>> +	struct btrfs_fs_info *fs_info = eb->eb_info->fs_info;
>> +	u64 logical = (u64)bio->bi_iter.bi_sector << 9;
>> +	u64 length = 0;
>> +	u64 map_length;
>> +	int ret;
>> +
>> +	length = bio->bi_iter.bi_size;
>> +	map_length = length;
>> +	ret = btrfs_map_block(fs_info, bio_op(bio), logical, &map_length,
>> +			      NULL, 0);
>> +	if (ret < 0)
>> +		return ret;
>> +	if (map_length < length + size)
>> +		return 1;
>> +	return 0;
>>  }
>>
>>  static const struct extent_io_ops btree_extent_io_ops = {
>>  	.readpage_end_io_hook = btree_readpage_end_io_hook,
>>  	.readpage_io_failed_hook = btree_io_failed_hook,
>>  	.submit_bio_hook = btree_submit_bio_hook,
>> -	/* note we're sharing with inode.c for the merge bio hook */
>> -	.merge_bio_hook = btrfs_merge_bio_hook,
>> +	.merge_bio_hook = btree_merge_bio_hook,
>>  	.tree_fs_info = btree_fs_info,
>>  	.set_range_writeback = btrfs_set_range_writeback,
>>  };
>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>> index 5dcdd3e..5c18a49 100644
>> --- a/fs/btrfs/extent_io.c
>> +++ b/fs/btrfs/extent_io.c
>> @@ -75,8 +75,8 @@ void btrfs_leak_debug_check(void)
>>  	while (!list_empty(&buffers)) {
>>  		eb = list_entry(buffers.next, struct extent_buffer, leak_list);
>>  		printk(KERN_ERR "BTRFS: buffer leak start %llu len %lu "
>> -		       "refs %d\n",
>> -		       eb->start, eb->len, atomic_read(&eb->refs));
>> +		       "bflags %lu refs %d\n",
>> +		       eb->start, eb->len, eb->bflags, atomic_read(&eb->refs));
>>  		list_del(&eb->leak_list);
>>  		kmem_cache_free(extent_buffer_cache, eb);
>>  	}
>> @@ -3538,7 +3538,7 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
>>  			  struct btrfs_fs_info *fs_info,
>>  			  struct extent_page_data *epd)
>>  {
>> -	unsigned long i, num_pages;
>> +	struct btrfs_eb_info *eb_info = fs_info->eb_info;
>>  	int flush = 0;
>>  	int ret = 0;
>>
>> @@ -3585,37 +3585,42 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
>>
>>  	btrfs_tree_unlock(eb);
>>
>> -	if (!ret)
>> -		return ret;
>> -
>> -	num_pages = num_extent_pages(eb->start, eb->len);
>> -	for (i = 0; i < num_pages; i++) {
>> -		struct page *p = eb->pages[i];
>> -
>> -		if (!trylock_page(p)) {
>> -			if (!flush) {
>> -				flush_write_bio(epd);
>> -				flush = 1;
>> -			}
>> -			lock_page(p);
>> -		}
>> +	/*
>> +	 * We cleared dirty on this buffer, we need to adjust the radix tags.
>> +	 * We do the actual page accounting in write_one_eb.
>> +	 */
>> +	if (ret) {
>> +		spin_lock_irq(&eb_info->buffer_lock);
>> +		radix_tree_tag_set(&eb_info->buffer_radix, eb_index(eb),
>> +				   PAGECACHE_TAG_WRITEBACK);
>> +		radix_tree_tag_clear(&eb_info->buffer_radix, eb_index(eb),
>> +				     PAGECACHE_TAG_DIRTY);
>> +		radix_tree_tag_clear(&eb_info->buffer_radix, eb_index(eb),
>> +				     PAGECACHE_TAG_TOWRITE);
>> +		spin_unlock_irq(&eb_info->buffer_lock);
>>  	}
>> -
>>  	return ret;
>>  }
>>
>>  static void end_extent_buffer_writeback(struct extent_buffer *eb)
>>  {
>> -	clear_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags);
>> -	smp_mb__after_atomic();
>> -	wake_up_bit(&eb->bflags, EXTENT_BUFFER_WRITEBACK);
>> +	if (test_and_clear_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags)) {
>> +		struct btrfs_eb_info *eb_info = eb->eb_info;
>> +		unsigned long flags;
>> +
>> +		spin_lock_irqsave(&eb_info->buffer_lock, flags);
>> +		radix_tree_tag_clear(&eb_info->buffer_radix, eb_index(eb),
>> +				     PAGECACHE_TAG_WRITEBACK);
>> +		spin_unlock_irqrestore(&eb_info->buffer_lock, flags);
>> +		wake_up_bit(&eb->bflags, EXTENT_BUFFER_WRITEBACK);
>> +	}
>>  }
>>
>>  static void set_btree_ioerr(struct page *page)
>>  {
>>  	struct extent_buffer *eb = (struct extent_buffer *)page->private;
>> +	struct btrfs_fs_info *fs_info = eb->eb_info->fs_info;
>>
>> -	SetPageError(page);
>>  	if (test_and_set_bit(EXTENT_BUFFER_WRITE_ERR, &eb->bflags))
>>  		return;
>>
>> @@ -3624,8 +3629,7 @@ static void set_btree_ioerr(struct page *page)
>>  	 * failed, increment the counter transaction->eb_write_errors.
>>  	 * We do this because while the transaction is running and before it's
>>  	 * committing (when we call filemap_fdata[write|wait]_range against
>> -	 * the btree inode), we might have
>> -	 * btree_inode->i_mapping->a_ops->writepages() called by the VM - if it
>> +	 * the btree inode), we might have write_metadata() called - if it
>>  	 * returns an error or an error happens during writeback, when we're
>>  	 * committing the transaction we wouldn't know about it, since the pages
>>  	 * can be no longer dirty nor marked anymore for writeback (if a
>> @@ -3659,13 +3663,13 @@ static void set_btree_ioerr(struct page *page)
>>  	 */
>>  	switch (eb->log_index) {
>>  	case -1:
>> -		set_bit(BTRFS_FS_BTREE_ERR, &eb->fs_info->flags);
>> +		set_bit(BTRFS_FS_BTREE_ERR, &fs_info->flags);
>>  		break;
>>  	case 0:
>> -		set_bit(BTRFS_FS_LOG1_ERR, &eb->fs_info->flags);
>> +		set_bit(BTRFS_FS_LOG1_ERR, &fs_info->flags);
>>  		break;
>>  	case 1:
>> -		set_bit(BTRFS_FS_LOG2_ERR, &eb->fs_info->flags);
>> +		set_bit(BTRFS_FS_LOG2_ERR, &fs_info->flags);
>>  		break;
>>  	default:
>>  		BUG(); /* unexpected, logic error */
>> @@ -3686,16 +3690,13 @@ static void end_bio_extent_buffer_writepage(struct bio *bio)
>>  		done = atomic_dec_and_test(&eb->io_pages);
>>
>>  		if (bio->bi_error ||
>> -		    test_bit(EXTENT_BUFFER_WRITE_ERR, &eb->bflags)) {
>> -			ClearPageUptodate(page);
>> +		    test_bit(EXTENT_BUFFER_WRITE_ERR, &eb->bflags))
>>  			set_btree_ioerr(page);
>> -		}
>> -
>> -		end_page_writeback(page);
>>
>> +		account_metadata_end_writeback(page,
>> +					       &eb->eb_info->fs_info->bdi);
>>  		if (!done)
>>  			continue;
>> -
>>  		end_extent_buffer_writeback(eb);
>>  	}
>>
>> @@ -3708,7 +3709,7 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
>>  			struct extent_page_data *epd)
>>  {
>>  	struct block_device *bdev = fs_info->fs_devices->latest_bdev;
>> -	struct extent_io_tree *tree = &BTRFS_I(fs_info->btree_inode)->io_tree;
>> +	struct extent_io_tree *tree = &fs_info->eb_info->io_tree;
>>  	u64 offset = eb->start;
>>  	unsigned long i, num_pages;
>>  	unsigned long bio_flags = 0;
>> @@ -3724,8 +3725,6 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
>>  	for (i = 0; i < num_pages; i++) {
>>  		struct page *p = eb->pages[i];
>>
>> -		clear_page_dirty_for_io(p);
>> -		set_page_writeback(p);
>>  		ret = submit_extent_page(REQ_OP_WRITE, write_flags, tree, wbc,
>>  					 p, offset >> 9, PAGE_SIZE, 0, bdev,
>>  					 &epd->bio, -1,
>> @@ -3734,34 +3733,90 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
>>  		epd->bio_flags = bio_flags;
>>  		if (ret) {
>>  			set_btree_ioerr(p);
>> -			end_page_writeback(p);
>>  			if (atomic_sub_and_test(num_pages - i, &eb->io_pages))
>>  				end_extent_buffer_writeback(eb);
>>  			ret = -EIO;
>>  			break;
>>  		}
>> +		account_metadata_writeback(p, &fs_info->bdi);
>>  		offset += PAGE_SIZE;
>>  		update_nr_written(p, wbc, 1);
>> -		unlock_page(p);
>>  	}
>>
>> -	if (unlikely(ret)) {
>> -		for (; i < num_pages; i++) {
>> -			struct page *p = eb->pages[i];
>> -			clear_page_dirty_for_io(p);
>> -			unlock_page(p);
>> +	return ret;
>> +}
>> +
>> +#define EB_TAG_BATCH 4096
>> +static void tag_ebs_for_writeback(struct btrfs_eb_info *eb_info, pgoff_t start,
>> +				  pgoff_t end)
>> +{
>> +	unsigned long tagged;
>> +
>> +	do {
>> +		spin_lock_irq(&eb_info->buffer_lock);
>> +		tagged = radix_tree_range_tag_if_tagged(&eb_info->buffer_radix,
>> +							&start, end,
>> +							EB_TAG_BATCH,
>> +							PAGECACHE_TAG_DIRTY,
>> +							PAGECACHE_TAG_TOWRITE);
>> +		spin_unlock_irq(&eb_info->buffer_lock);
>> +		cond_resched();
>> +	} while (tagged >= EB_TAG_BATCH && start);
>> +}
>> +
>> +static unsigned eb_lookup_tag(struct btrfs_eb_info *eb_info,
>> +			      struct extent_buffer **ebs, pgoff_t *index,
>> +			      int tag, unsigned nr)
>> +{
>> +	struct radix_tree_iter iter;
>> +	void **slot;
>> +	unsigned ret = 0;
>> +
>> +	if (unlikely(!nr))
>> +		return 0;
>> +
>> +	rcu_read_lock();
>> +	radix_tree_for_each_tagged(slot, &eb_info->buffer_radix, &iter, *index,
>> +				   tag) {
>> +		struct extent_buffer *eb;
>> +repeat:
>> +		eb = radix_tree_deref_slot(slot);
>> +		if (unlikely(!eb))
>> +			continue;
>> +
>> +		if (radix_tree_exception(eb)) {
>> +			if (radix_tree_deref_retry(eb)) {
>> +				slot = radix_tree_iter_retry(&iter);
>> +				continue;
>> +			}
>> +			continue;
>>  		}
>> -	}
>>
>> +		if (unlikely(!atomic_inc_not_zero(&eb->refs)))
>> +			continue;
>> +
>> +		if (unlikely(eb != *slot)) {
>> +			free_extent_buffer(eb);
>> +			goto repeat;
>> +		}
>> +
>> +		ebs[ret] = eb;
>> +		if (++ret == nr)
>> +			break;
>> +	}
>> +	rcu_read_unlock();
>> +	if (ret)
>> +		*index = (ebs[ret - 1]->start >> PAGE_SHIFT) + 1;
>>  	return ret;
>>  }
>>
>> -int btree_write_cache_pages(struct address_space *mapping,
>> +#define EBVEC_SIZE 16
>> +static int btree_write_cache_pages(struct btrfs_fs_info *fs_info,
>>  				   struct writeback_control *wbc)
>>  {
>> -	struct extent_io_tree *tree = &BTRFS_I(mapping->host)->io_tree;
>> -	struct btrfs_fs_info *fs_info = BTRFS_I(mapping->host)->root->fs_info;
>> -	struct extent_buffer *eb, *prev_eb = NULL;
>> +	struct btrfs_eb_info *eb_info = fs_info->eb_info;
>> +	struct extent_io_tree *tree = &eb_info->io_tree;
>> +	struct extent_buffer *eb;
>>  	struct extent_page_data epd = {
>>  		.bio = NULL,
>>  		.tree = tree,
>> @@ -3772,16 +3827,16 @@ int btree_write_cache_pages(struct address_space *mapping,
>>  	int ret = 0;
>>  	int done = 0;
>>  	int nr_to_write_done = 0;
>> -	struct pagevec pvec;
>> -	int nr_pages;
>> +	struct extent_buffer *ebs[EBVEC_SIZE];
>> +	int nr_ebs;
>>  	pgoff_t index;
>>  	pgoff_t end;		/* Inclusive */
>> +	pgoff_t done_index = 0;
>>  	int scanned = 0;
>>  	int tag;
>>
>> -	pagevec_init(&pvec, 0);
>>  	if (wbc->range_cyclic) {
>> -		index = mapping->writeback_index; /* Start from prev offset */
>> +		index = eb_info->writeback_index; /* Start from prev offset */
>>  		end = -1;
>>  	} else {
>>  		index = wbc->range_start >> PAGE_SHIFT;
>> @@ -3794,53 +3849,27 @@ int btree_write_cache_pages(struct address_space *mapping,
>>  		tag = PAGECACHE_TAG_DIRTY;
>>  retry:
>>  	if (wbc->sync_mode == WB_SYNC_ALL)
>> -		tag_pages_for_writeback(mapping, index, end);
>> +		tag_ebs_for_writeback(fs_info->eb_info, index, end);
>>  	while (!done && !nr_to_write_done && (index <= end) &&
>> -	       (nr_pages = pagevec_lookup_tag(&pvec, mapping, &index, tag,
>> -			min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1))) {
>> +	       (nr_ebs = eb_lookup_tag(eb_info, ebs, &index, tag,
>> +			min(end - index, (pgoff_t)EBVEC_SIZE-1) + 1))) {
>>  		unsigned i;
>>
>>  		scanned = 1;
>> -		for (i = 0; i < nr_pages; i++) {
>> -			struct page *page = pvec.pages[i];
>> -
>> -			if (!PagePrivate(page))
>> -				continue;
>> -
>> -			if (!wbc->range_cyclic && page->index > end) {
>> -				done = 1;
>> -				break;
>> -			}
>> -
>> -			spin_lock(&mapping->private_lock);
>> -			if (!PagePrivate(page)) {
>> -				spin_unlock(&mapping->private_lock);
>> -				continue;
>> -			}
>> -
>> -			eb = (struct extent_buffer *)page->private;
>> -
>> -			/*
>> -			 * Shouldn't happen and normally this would be a BUG_ON
>> -			 * but no sense in crashing the users box for something
>> -			 * we can survive anyway.
>> -			 */
>> -			if (WARN_ON(!eb)) {
>> -				spin_unlock(&mapping->private_lock);
>> +		for (i = 0; i < nr_ebs; i++) {
>> +			eb = ebs[i];
>> +			if (done) {
>> +				free_extent_buffer(eb);
>>  				continue;
>>  			}
>>
>> -			if (eb == prev_eb) {
>> -				spin_unlock(&mapping->private_lock);
>> +			if (!wbc->range_cyclic && eb->start > wbc->range_end) {
>> +				done = 1;
>> +				free_extent_buffer(eb);
>>  				continue;
>>  			}
>>
>> -			ret = atomic_inc_not_zero(&eb->refs);
>> -			spin_unlock(&mapping->private_lock);
>> -			if (!ret)
>> -				continue;
>> -
>> -			prev_eb = eb;
>> +			done_index = eb_index(eb);
>>  			ret = lock_extent_buffer_for_io(eb, fs_info, &epd);
>>  			if (!ret) {
>>  				free_extent_buffer(eb);
>> @@ -3848,12 +3877,11 @@ retry:
>>  			}
>>
>>  			ret = write_one_eb(eb, fs_info, wbc, &epd);
>> +			free_extent_buffer(eb);
>>  			if (ret) {
>>  				done = 1;
>> -				free_extent_buffer(eb);
>> -				break;
>> +				continue;
>>  			}
>> -			free_extent_buffer(eb);
>>
>>  			/*
>>  			 * the filesystem may choose to bump up nr_to_write.
>> @@ -3862,7 +3890,6 @@ retry:
>>  			 */
>>  			nr_to_write_done = wbc->nr_to_write <= 0;
>>  		}
>> -		pagevec_release(&pvec);
>>  		cond_resched();
>>  	}
>>  	if (!scanned && !done) {
>> @@ -3874,10 +3901,77 @@ retry:
>>  		index = 0;
>>  		goto retry;
>>  	}
>> +	if (wbc->range_cyclic)
>> +		fs_info->eb_info->writeback_index = done_index;
>>  	flush_write_bio(&epd);
>>  	return ret;
>>  }
>>
>> +void btrfs_write_ebs(struct super_block *sb, struct writeback_control *wbc)
>> +{
>> +	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
>> +	btree_write_cache_pages(fs_info, wbc);
>> +}
>> +
>> +static int __btree_write_range(struct btrfs_fs_info *fs_info, u64 start,
>> +			       u64 end, int sync_mode)
>> +{
>> +	struct writeback_control wbc = {
>> +		.sync_mode = sync_mode,
>> +		.nr_to_write = LONG_MAX,
>> +		.range_start = start,
>> +		.range_end = end,
>> +	};
>> +
>> +	return btree_write_cache_pages(fs_info, &wbc);
>> +}
>> +
>> +void btree_flush(struct btrfs_fs_info *fs_info)
>> +{
>> +	__btree_write_range(fs_info, 0, (u64)-1, WB_SYNC_NONE);
>> +}
>> +
>> +int btree_write_range(struct btrfs_fs_info *fs_info, u64 start, u64 end)
>> +{
>> +	return __btree_write_range(fs_info, start, end, WB_SYNC_ALL);
>> +}
>> +
>> +int btree_wait_range(struct btrfs_fs_info *fs_info, u64 start, u64 end)
>> +{
>> +	struct extent_buffer *ebs[EBVEC_SIZE];
>> +	pgoff_t index = start >> PAGE_SHIFT;
>> +	pgoff_t end_index = end >> PAGE_SHIFT;
>> +	unsigned nr_ebs;
>> +	int ret = 0;
>> +
>> +	if (end < start)
>> +		return ret;
>> +
>> +	while ((index <= end) &&
>> +	       (nr_ebs = eb_lookup_tag(fs_info->eb_info, ebs, &index,
>> +				       PAGECACHE_TAG_WRITEBACK,
>> +				       min(end_index - index,
>> +					   (pgoff_t)EBVEC_SIZE-1) + 1)) != 0) {
>> +		unsigned i;
>> +
>> +		for (i = 0; i < nr_ebs; i++) {
>> +			struct extent_buffer *eb = ebs[i];
>> +
>> +			if (eb->start > end) {
>> +				free_extent_buffer(eb);
>> +				continue;
>> +			}
>> +
>> +			wait_on_extent_buffer_writeback(eb);
>> +			if (test_bit(EXTENT_BUFFER_WRITE_ERR, &eb->bflags))
>> +				ret = -EIO;
>> +			free_extent_buffer(eb);
>> +		}
>> +		cond_resched();
>> +	}
>> +	return ret;
>> +}
>> +
>>  /**
>>   * write_cache_pages - walk the list of dirty pages of the given address space and write all of them.
>>   * @mapping: address space structure to write
>> @@ -4558,7 +4652,6 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb)
>>  {
>>  	unsigned long index;
>>  	struct page *page;
>> -	int mapped = !test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags);
>>
>>  	BUG_ON(extent_buffer_under_io(eb));
>>
>> @@ -4566,39 +4659,21 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb)
>>  	if (index == 0)
>>  		return;
>>
>> +	ASSERT(!test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
>>  	do {
>>  		index--;
>>  		page = eb->pages[index];
>>  		if (!page)
>>  			continue;
>> -		if (mapped)
>> -			spin_lock(&page->mapping->private_lock);
>> -		/*
>> -		 * We do this since we'll remove the pages after we've
>> -		 * removed the eb from the radix tree, so we could race
>> -		 * and have this page now attached to the new eb.  So
>> -		 * only clear page_private if it's still connected to
>> -		 * this eb.
>> -		 */
>> -		if (PagePrivate(page) &&
>> -		    page->private == (unsigned long)eb) {
>> -			BUG_ON(test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
>> -			BUG_ON(PageDirty(page));
>> -			BUG_ON(PageWriteback(page));
>> -			/*
>> -			 * We need to make sure we haven't be attached
>> -			 * to a new eb.
>> -			 */
>> -			ClearPagePrivate(page);
>> -			set_page_private(page, 0);
>> -			/* One for the page private */
>> -			put_page(page);
>> -		}
>> +		ASSERT(PagePrivate(page));
>> +		ASSERT(page->private == (unsigned long)eb);
>> +		ClearPagePrivate(page);
>> +		set_page_private(page, 0);
>>
>> -		if (mapped)
>> -			spin_unlock(&page->mapping->private_lock);
>> +		/* Once for the page private. */
>> +		put_page(page);
>>
>> -		/* One for when we allocated the page */
>> +		/* Once for the alloc_page. */
>>  		put_page(page);
>>  	} while (index != 0);
>>  }
>> @@ -4613,7 +4688,7 @@ static inline void btrfs_release_extent_buffer(struct extent_buffer *eb)
>>  }
>>
>>  static struct extent_buffer *
>> -__alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
>> +__alloc_extent_buffer(struct btrfs_eb_info *eb_info, u64 start,
>>  		      unsigned long len)
>>  {
>>  	struct extent_buffer *eb = NULL;
>> @@ -4621,7 +4696,7 @@ __alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
>>  	eb = kmem_cache_zalloc(extent_buffer_cache, GFP_NOFS|__GFP_NOFAIL);
>>  	eb->start = start;
>>  	eb->len = len;
>> -	eb->fs_info = fs_info;
>> +	eb->eb_info = eb_info;
>>  	eb->bflags = 0;
>>  	rwlock_init(&eb->lock);
>>  	atomic_set(&eb->write_locks, 0);
>> @@ -4633,6 +4708,7 @@ __alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
>>  	eb->lock_nested = 0;
>>  	init_waitqueue_head(&eb->write_lock_wq);
>>  	init_waitqueue_head(&eb->read_lock_wq);
>> +	INIT_LIST_HEAD(&eb->lru);
>>
>>  	btrfs_leak_debug_add(&eb->leak_list, &buffers);
>>
>> @@ -4657,7 +4733,7 @@ struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src)
>>  	struct extent_buffer *new;
>>  	unsigned long num_pages = num_extent_pages(src->start, src->len);
>>
>> -	new = __alloc_extent_buffer(src->fs_info, src->start, src->len);
>> +	new = __alloc_extent_buffer(src->eb_info, src->start, src->len);
>>  	if (new == NULL)
>>  		return NULL;
>>
>> @@ -4668,8 +4744,6 @@ struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src)
>>  			return NULL;
>>  		}
>>  		attach_extent_buffer_page(new, p);
>> -		WARN_ON(PageDirty(p));
>> -		SetPageUptodate(p);
>>  		new->pages[i] = p;
>>  	}
>>
>> @@ -4680,8 +4754,8 @@ struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src)
>>  	return new;
>>  }
>>
>> -struct extent_buffer *__alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
>> -						  u64 start, unsigned long len)
>> +struct extent_buffer *alloc_dummy_extent_buffer(struct btrfs_eb_info *eb_info,
>> +						u64 start, unsigned long len)
>>  {
>>  	struct extent_buffer *eb;
>>  	unsigned long num_pages;
>> @@ -4689,7 +4763,7 @@ struct extent_buffer *__alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
>>
>>  	num_pages = num_extent_pages(start, len);
>>
>> -	eb = __alloc_extent_buffer(fs_info, start, len);
>> +	eb = __alloc_extent_buffer(eb_info, start, len);
>>  	if (!eb)
>>  		return NULL;
>>
>> @@ -4697,6 +4771,7 @@ struct extent_buffer *__alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
>>  		eb->pages[i] = alloc_page(GFP_NOFS);
>>  		if (!eb->pages[i])
>>  			goto err;
>> +		attach_extent_buffer_page(eb, eb->pages[i]);
>>  	}
>>  	set_extent_buffer_uptodate(eb);
>>  	btrfs_set_header_nritems(eb, 0);
>> @@ -4704,30 +4779,10 @@ struct extent_buffer *__alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
>>
>>  	return eb;
>>  err:
>> -	for (; i > 0; i--)
>> -		__free_page(eb->pages[i - 1]);
>> -	__free_extent_buffer(eb);
>> +	btrfs_release_extent_buffer(eb);
>>  	return NULL;
>>  }
>>
>> -struct extent_buffer *alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
>> -						u64 start, u32 nodesize)
>> -{
>> -	unsigned long len;
>> -
>> -	if (!fs_info) {
>> -		/*
>> -		 * Called only from tests that don't always have a fs_info
>> -		 * available
>> -		 */
>> -		len = nodesize;
>> -	} else {
>> -		len = fs_info->tree_root->nodesize;
>> -	}
>> -
>> -	return __alloc_dummy_extent_buffer(fs_info, start, len);
>> -}
>> -
>>  static void check_buffer_tree_ref(struct extent_buffer *eb)
>>  {
>>  	int refs;
>> @@ -4777,13 +4832,13 @@ static void mark_extent_buffer_accessed(struct extent_buffer *eb,
>>  	}
>>  }
>>
>> -struct extent_buffer *find_extent_buffer(struct btrfs_fs_info *fs_info,
>> +struct extent_buffer *find_extent_buffer(struct btrfs_eb_info *eb_info,
>>  					 u64 start)
>>  {
>>  	struct extent_buffer *eb;
>>
>>  	rcu_read_lock();
>> -	eb = radix_tree_lookup(&fs_info->buffer_radix,
>> +	eb = radix_tree_lookup(&eb_info->buffer_radix,
>>  			       start >> PAGE_SHIFT);
>>  	if (eb && atomic_inc_not_zero(&eb->refs)) {
>>  		rcu_read_unlock();
>> @@ -4815,30 +4870,30 @@ struct extent_buffer *find_extent_buffer(struct btrfs_fs_info *fs_info,
>>  }
>>
>>  #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
>> -struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
>> -					u64 start, u32 nodesize)
>> +struct extent_buffer *alloc_test_extent_buffer(struct btrfs_eb_info *eb_info,
>> +					       u64 start, u32 nodesize)
>>  {
>>  	struct extent_buffer *eb, *exists = NULL;
>>  	int ret;
>>
>> -	eb = find_extent_buffer(fs_info, start);
>> +	eb = find_extent_buffer(eb_info, start);
>>  	if (eb)
>>  		return eb;
>> -	eb = alloc_dummy_extent_buffer(fs_info, start, nodesize);
>> +	eb = alloc_dummy_extent_buffer(eb_info, start, nodesize);
>>  	if (!eb)
>>  		return NULL;
>> -	eb->fs_info = fs_info;
>> +	eb->eb_info = eb_info;
>>  again:
>>  	ret = radix_tree_preload(GFP_NOFS);
>>  	if (ret)
>>  		goto free_eb;
>> -	spin_lock(&fs_info->buffer_lock);
>> -	ret = radix_tree_insert(&fs_info->buffer_radix,
>> +	spin_lock_irq(&eb_info->buffer_lock);
>> +	ret = radix_tree_insert(&eb_info->buffer_radix,
>>  				start >> PAGE_SHIFT, eb);
>> -	spin_unlock(&fs_info->buffer_lock);
>> +	spin_unlock_irq(&eb_info->buffer_lock);
>>  	radix_tree_preload_end();
>>  	if (ret == -EEXIST) {
>> -		exists = find_extent_buffer(fs_info, start);
>> +		exists = find_extent_buffer(eb_info, start);
>>  		if (exists)
>>  			goto free_eb;
>>  		else
>> @@ -4854,6 +4909,7 @@ again:
>>  	 * bump the ref count again.
>>  	 */
>>  	atomic_inc(&eb->refs);
>> +	set_extent_buffer_uptodate(eb);
>>  	return eb;
>>  free_eb:
>>  	btrfs_release_extent_buffer(eb);
>> @@ -4867,12 +4923,12 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
>>  	unsigned long len = fs_info->tree_root->nodesize;
>>  	unsigned long num_pages = num_extent_pages(start, len);
>>  	unsigned long i;
>> -	unsigned long index = start >> PAGE_SHIFT;
>>  	struct extent_buffer *eb;
>>  	struct extent_buffer *exists = NULL;
>>  	struct page *p;
>> -	struct address_space *mapping = fs_info->btree_inode->i_mapping;
>> -	int uptodate = 1;
>> +	struct btrfs_eb_info *eb_info = fs_info->eb_info;
>> +//	struct zone *last_zone = NULL;
>> +//	struct pg_data_t *last_pgdata = NULL;
>>  	int ret;
>>
>>  	if (!IS_ALIGNED(start, fs_info->tree_root->sectorsize)) {
>> @@ -4880,62 +4936,36 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
>>  		return ERR_PTR(-EINVAL);
>>  	}
>>
>> -	eb = find_extent_buffer(fs_info, start);
>> +	eb = find_extent_buffer(eb_info, start);
>>  	if (eb)
>>  		return eb;
>>
>> -	eb = __alloc_extent_buffer(fs_info, start, len);
>> +	eb = __alloc_extent_buffer(eb_info, start, len);
>>  	if (!eb)
>>  		return ERR_PTR(-ENOMEM);
>>
>> -	for (i = 0; i < num_pages; i++, index++) {
>> -		p = find_or_create_page(mapping, index, GFP_NOFS|__GFP_NOFAIL);
>> +	for (i = 0; i < num_pages; i++) {
>> +		p = alloc_page(GFP_NOFS|__GFP_NOFAIL);
>>  		if (!p) {
>>  			exists = ERR_PTR(-ENOMEM);
>>  			goto free_eb;
>>  		}
>>
>> -		spin_lock(&mapping->private_lock);
>> -		if (PagePrivate(p)) {
>> -			/*
>> -			 * We could have already allocated an eb for this page
>> -			 * and attached one so lets see if we can get a ref on
>> -			 * the existing eb, and if we can we know it's good and
>> -			 * we can just return that one, else we know we can just
>> -			 * overwrite page->private.
>> -			 */
>> -			exists = (struct extent_buffer *)p->private;
>> -			if (atomic_inc_not_zero(&exists->refs)) {
>> -				spin_unlock(&mapping->private_lock);
>> -				unlock_page(p);
>> -				put_page(p);
>> -				mark_extent_buffer_accessed(exists, p);
>> -				goto free_eb;
>> -			}
>> -			exists = NULL;
>> -
>> -			/*
>> -			 * Do this so attach doesn't complain and we need to
>> -			 * drop the ref the old guy had.
>> -			 */
>> -			ClearPagePrivate(p);
>> -			WARN_ON(PageDirty(p));
>> -			put_page(p);
>> -		}
>> +		/*
>> +		 * If our pages span zones or numa nodes we have to do
>> +		 * dirty/writeback accounting per page, otherwise we can do it
>> +		 * in bulk and save us some looping.
>> +		 *
>> +		if (!last_zone)
>> +			last_zone = page_zone(p);
>> +		if (!last_pgdata)
>> +			last_pgdata = page_pgdata(p);
>> +		if (last_zone != page_zone(p) || last_pgdata != page_pgdata(p))
>> +			set_bit(EXTENT_BUFFER_MIXED_PAGES, &eb->bflags);
>> +		*/
>>  		attach_extent_buffer_page(eb, p);
>> -		spin_unlock(&mapping->private_lock);
>> -		WARN_ON(PageDirty(p));
>>  		eb->pages[i] = p;
>> -		if (!PageUptodate(p))
>> -			uptodate = 0;
>> -
>> -		/*
>> -		 * see below about how we avoid a nasty race with release page
>> -		 * and why we unlock later
>> -		 */
>>  	}
>> -	if (uptodate)
>> -		set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
>>  again:
>>  	ret = radix_tree_preload(GFP_NOFS);
>>  	if (ret) {
>> @@ -4943,13 +4973,13 @@ again:
>>  		goto free_eb;
>>  	}
>>
>> -	spin_lock(&fs_info->buffer_lock);
>> -	ret = radix_tree_insert(&fs_info->buffer_radix,
>> +	spin_lock_irq(&eb_info->buffer_lock);
>> +	ret = radix_tree_insert(&eb_info->buffer_radix,
>>  				start >> PAGE_SHIFT, eb);
>> -	spin_unlock(&fs_info->buffer_lock);
>> +	spin_unlock_irq(&eb_info->buffer_lock);
>>  	radix_tree_preload_end();
>>  	if (ret == -EEXIST) {
>> -		exists = find_extent_buffer(fs_info, start);
>> +		exists = find_extent_buffer(eb_info, start);
>>  		if (exists)
>>  			goto free_eb;
>>  		else
>> @@ -4959,31 +4989,10 @@ again:
>>  	check_buffer_tree_ref(eb);
>>  	set_bit(EXTENT_BUFFER_IN_TREE, &eb->bflags);
>>
>> -	/*
>> -	 * there is a race where release page may have
>> -	 * tried to find this extent buffer in the radix
>> -	 * but failed.  It will tell the VM it is safe to
>> -	 * reclaim the, and it will clear the page private bit.
>> -	 * We must make sure to set the page private bit properly
>> -	 * after the extent buffer is in the radix tree so
>> -	 * it doesn't get lost
>> -	 */
>> -	SetPageChecked(eb->pages[0]);
>> -	for (i = 1; i < num_pages; i++) {
>> -		p = eb->pages[i];
>> -		ClearPageChecked(p);
>> -		unlock_page(p);
>> -	}
>> -	unlock_page(eb->pages[0]);
>>  	return eb;
>>
>>  free_eb:
>>  	WARN_ON(!atomic_dec_and_test(&eb->refs));
>> -	for (i = 0; i < num_pages; i++) {
>> -		if (eb->pages[i])
>> -			unlock_page(eb->pages[i]);
>> -	}
>> -
>>  	btrfs_release_extent_buffer(eb);
>>  	return exists;
>>  }
>> @@ -4999,17 +5008,19 @@ static inline void btrfs_release_extent_buffer_rcu(struct rcu_head *head)
>>  /* Expects to have eb->eb_lock already held */
>>  static int release_extent_buffer(struct extent_buffer *eb)
>>  {
>> +	struct btrfs_eb_info *eb_info = eb->eb_info;
>> +
>>  	WARN_ON(atomic_read(&eb->refs) == 0);
>>  	if (atomic_dec_and_test(&eb->refs)) {
>> +		if (eb_info)
>> +			list_lru_del(&eb_info->lru_list, &eb->lru);
>>  		if (test_and_clear_bit(EXTENT_BUFFER_IN_TREE, &eb->bflags)) {
>> -			struct btrfs_fs_info *fs_info = eb->fs_info;
>> -
>>  			spin_unlock(&eb->refs_lock);
>>
>> -			spin_lock(&fs_info->buffer_lock);
>> -			radix_tree_delete(&fs_info->buffer_radix,
>> -					  eb->start >> PAGE_SHIFT);
>> -			spin_unlock(&fs_info->buffer_lock);
>> +			spin_lock_irq(&eb_info->buffer_lock);
>> +			radix_tree_delete(&eb_info->buffer_radix,
>> +					  eb_index(eb));
>> +			spin_unlock_irq(&eb_info->buffer_lock);
>>  		} else {
>>  			spin_unlock(&eb->refs_lock);
>>  		}
>> @@ -5024,6 +5035,8 @@ static int release_extent_buffer(struct extent_buffer *eb)
>>  #endif
>>  		call_rcu(&eb->rcu_head, btrfs_release_extent_buffer_rcu);
>>  		return 1;
>> +	} else if (eb_info && atomic_read(&eb->refs) == 1) {
>> +		list_lru_add(&eb_info->lru_list, &eb->lru);
>>  	}
>>  	spin_unlock(&eb->refs_lock);
>>
>> @@ -5057,10 +5070,6 @@ void free_extent_buffer(struct extent_buffer *eb)
>>  	    test_and_clear_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags))
>>  		atomic_dec(&eb->refs);
>>
>> -	/*
>> -	 * I know this is terrible, but it's temporary until we stop tracking
>> -	 * the uptodate bits and such for the extent buffers.
>> -	 */
>>  	release_extent_buffer(eb);
>>  }
>>
>> @@ -5078,82 +5087,163 @@ void free_extent_buffer_stale(struct extent_buffer *eb)
>>  	release_extent_buffer(eb);
>>  }
>>
>> -void clear_extent_buffer_dirty(struct extent_buffer *eb)
>> +long btrfs_nr_ebs(struct super_block *sb, struct shrink_control *sc)
>>  {
>> -	unsigned long i;
>> -	unsigned long num_pages;
>> -	struct page *page;
>> +	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
>> +	struct btrfs_eb_info *eb_info = fs_info->eb_info;
>>
>> -	num_pages = num_extent_pages(eb->start, eb->len);
>> +	return list_lru_shrink_count(&eb_info->lru_list, sc);
>> +}
>>
>> -	for (i = 0; i < num_pages; i++) {
>> -		page = eb->pages[i];
>> -		if (!PageDirty(page))
>> -			continue;
>> +static enum lru_status eb_lru_isolate(struct list_head *item,
>> +				      struct list_lru_one *lru,
>> +				      spinlock_t *lru_lock, void *arg)
>> +{
>> +	struct list_head *freeable = (struct list_head *)arg;
>> +	struct extent_buffer *eb = container_of(item, struct extent_buffer,
>> +						lru);
>> +	enum lru_status ret;
>> +	int refs;
>>
>> -		lock_page(page);
>> -		WARN_ON(!PagePrivate(page));
>> +	if (!spin_trylock(&eb->refs_lock))
>> +		return LRU_SKIP;
>>
>> -		clear_page_dirty_for_io(page);
>> -		spin_lock_irq(&page->mapping->tree_lock);
>> -		if (!PageDirty(page)) {
>> -			radix_tree_tag_clear(&page->mapping->page_tree,
>> -						page_index(page),
>> -						PAGECACHE_TAG_DIRTY);
>> -		}
>> -		spin_unlock_irq(&page->mapping->tree_lock);
>> -		ClearPageError(page);
>> -		unlock_page(page);
>> +	if (extent_buffer_under_io(eb)) {
>> +		ret = LRU_ROTATE;
>> +		goto out;
>> +	}
>> +
>> +	refs = atomic_read(&eb->refs);
>> +	/* We can race with somebody freeing us, just skip if this happens. */
>> +	if (refs == 0) {
>> +		ret = LRU_SKIP;
>> +		goto out;
>> +	}
>> +
>> +	/* Eb is in use, don't kill it. */
>> +	if (refs > 1) {
>> +		ret = LRU_ROTATE;
>> +		goto out;
>> +	}
>> +
>> +	/*
>> +	 * If we don't clear the TREE_REF flag then this eb is going to
>> +	 * disappear soon anyway.  Otherwise we become responsible for dropping
>> +	 * the last ref on this eb and we know it'll survive until we call
>> +	 * dispose_list.
>> +	 */
>> +	if (!test_and_clear_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags)) {
>> +		ret = LRU_SKIP;
>> +		goto out;
>> +	}
>> +	list_lru_isolate_move(lru, &eb->lru, freeable);
>> +	ret = LRU_REMOVED;
>> +out:
>> +	spin_unlock(&eb->refs_lock);
>> +	return ret;
>> +}
>> +
>> +static void dispose_list(struct list_head *list)
>> +{
>> +	struct extent_buffer *eb;
>> +
>> +	while (!list_empty(list)) {
>> +		eb = list_first_entry(list, struct extent_buffer, lru);
>> +
>> +		spin_lock(&eb->refs_lock);
>> +		list_del_init(&eb->lru);
>> +		spin_unlock(&eb->refs_lock);
>> +		free_extent_buffer(eb);
>> +		cond_resched();
>>  	}
>> +}
>> +
>> +long btrfs_free_ebs(struct super_block *sb, struct shrink_control *sc)
>> +{
>> +	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
>> +	struct btrfs_eb_info *eb_info = fs_info->eb_info;
>> +	LIST_HEAD(freeable);
>> +	long freed;
>> +
>> +	freed = list_lru_shrink_walk(&eb_info->lru_list, sc, eb_lru_isolate,
>> +				     &freeable);
>> +	dispose_list(&freeable);
>> +	return freed;
>> +}
>> +
>> +#define MAX_EVICT_COUNT 1024
>> +void btrfs_invalidate_eb_info(struct btrfs_eb_info *eb_info)
>> +{
>> +	LIST_HEAD(freeable);
>> +	unsigned long count;
>> +
>> +	/*
>> +	 * Evict in batches so we don't lockup the system trying to evict
>> +	 * memory.
>> +	 */
>> +	do {
>> +		count = list_lru_walk(&eb_info->lru_list, eb_lru_isolate,
>> +				      &freeable, MAX_EVICT_COUNT);
>> +		cond_resched();
>> +	} while (count);
>> +	dispose_list(&freeable);
>> +	synchronize_rcu();
>> +}
>> +
>> +int clear_extent_buffer_dirty(struct extent_buffer *eb)
>> +{
>> +	struct btrfs_eb_info *eb_info = eb->eb_info;
>> +	unsigned long i;
>> +	unsigned long num_pages;
>> +
>> +	if (!test_and_clear_bit(EXTENT_BUFFER_DIRTY, &eb->bflags))
>> +		return 0;
>> +
>> +	spin_lock_irq(&eb_info->buffer_lock);
>> +	radix_tree_tag_clear(&eb_info->buffer_radix, eb_index(eb),
>> +			     PAGECACHE_TAG_DIRTY);
>> +	spin_unlock_irq(&eb_info->buffer_lock);
>> +
>> +	num_pages = num_extent_pages(eb->start, eb->len);
>> +	for (i = 0; i < num_pages; i++)
>> +		account_metadata_cleaned(eb->pages[i], &eb_info->fs_info->bdi);
>>  	WARN_ON(atomic_read(&eb->refs) == 0);
>> +	return 1;
>>  }
>>
>>  int set_extent_buffer_dirty(struct extent_buffer *eb)
>>  {
>> +	struct btrfs_eb_info *eb_info = eb->eb_info;
>>  	unsigned long i;
>>  	unsigned long num_pages;
>>  	int was_dirty = 0;
>>
>>  	check_buffer_tree_ref(eb);
>>
>> -	was_dirty = test_and_set_bit(EXTENT_BUFFER_DIRTY, &eb->bflags);
>> -
>> -	num_pages = num_extent_pages(eb->start, eb->len);
>>  	WARN_ON(atomic_read(&eb->refs) == 0);
>>  	WARN_ON(!test_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags));
>> +	if (test_and_set_bit(EXTENT_BUFFER_DIRTY, &eb->bflags))
>> +		return 1;
>>
>> +	num_pages = num_extent_pages(eb->start, eb->len);
>>  	for (i = 0; i < num_pages; i++)
>> -		set_page_dirty(eb->pages[i]);
>> +		account_metadata_dirtied(eb->pages[i],
>> +					 &eb->eb_info->fs_info->bdi);
>> +	spin_lock_irq(&eb_info->buffer_lock);
>> +	radix_tree_tag_set(&eb_info->buffer_radix, eb_index(eb),
>> +			   PAGECACHE_TAG_DIRTY);
>> +	spin_unlock_irq(&eb_info->buffer_lock);
>>  	return was_dirty;
>>  }
>>
>>  void clear_extent_buffer_uptodate(struct extent_buffer *eb)
>>  {
>> -	unsigned long i;
>> -	struct page *page;
>> -	unsigned long num_pages;
>> -
>>  	clear_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
>> -	num_pages = num_extent_pages(eb->start, eb->len);
>> -	for (i = 0; i < num_pages; i++) {
>> -		page = eb->pages[i];
>> -		if (page)
>> -			ClearPageUptodate(page);
>> -	}
>>  }
>>
>>  void set_extent_buffer_uptodate(struct extent_buffer *eb)
>>  {
>> -	unsigned long i;
>> -	struct page *page;
>> -	unsigned long num_pages;
>> -
>>  	set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
>> -	num_pages = num_extent_pages(eb->start, eb->len);
>> -	for (i = 0; i < num_pages; i++) {
>> -		page = eb->pages[i];
>> -		SetPageUptodate(page);
>> -	}
>>  }
>>
>>  int extent_buffer_uptodate(struct extent_buffer *eb)
>> @@ -5161,103 +5251,166 @@ int extent_buffer_uptodate(struct extent_buffer *eb)
>>  	return test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
>>  }
>>
>> -int read_extent_buffer_pages(struct extent_io_tree *tree,
>> -			     struct extent_buffer *eb, int wait,
>> -			     get_extent_t *get_extent, int mirror_num)
>> +static void end_bio_extent_buffer_readpage(struct bio *bio)
>>  {
>> +	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
>> +	struct extent_io_tree *tree = NULL;
>> +	struct bio_vec *bvec;
>> +	u64 unlock_start = 0, unlock_len = 0;
>> +	int mirror_num = io_bio->mirror_num;
>> +	int uptodate = !bio->bi_error;
>> +	int i, ret;
>> +
>> +	bio_for_each_segment_all(bvec, bio, i) {
>> +		struct page *page = bvec->bv_page;
>> +		struct btrfs_eb_info *eb_info;
>> +		struct extent_buffer *eb;
>> +
>> +		eb = (struct extent_buffer *)page->private;
>> +		if (WARN_ON(!eb))
>> +			continue;
>> +
>> +		eb_info = eb->eb_info;
>> +		if (!tree)
>> +			tree = &eb_info->io_tree;
>> +		if (uptodate) {
>> +			/*
>> +			 * btree_readpage_end_io_hook doesn't care about
>> +			 * start/end so just pass 0.  We'll kill this later.
>> +			 */
>> +			ret = tree->ops->readpage_end_io_hook(io_bio, 0,
>> +							      page, 0, 0,
>> +							      mirror_num);
>> +			if (ret) {
>> +				uptodate = 0;
>> +			} else {
>> +				u64 start = eb->start;
>> +				int c, num_pages;
>> +
>> +				num_pages = num_extent_pages(eb->start,
>> +							     eb->len);
>> +				for (c = 0; c < num_pages; c++) {
>> +					if (eb->pages[c] == page)
>> +						break;
>> +					start += PAGE_SIZE;
>> +				}
>> +				clean_io_failure(eb_info->fs_info,
>> +						 &eb_info->io_failure_tree,
>> +						 tree, start, page, 0, 0);
>> +			}
>> +		}
>> +		/*
>> +		 * We never fix anything in btree_io_failed_hook.
>> +		 *
>> +		 * TODO: rework the io failed hook to not assume we can fix
>> +		 * anything.
>> +		 */
>> +		if (!uptodate)
>> +			tree->ops->readpage_io_failed_hook(page, mirror_num);
>> +
>> +		if (unlock_start == 0) {
>> +			unlock_start = eb->start;
>> +			unlock_len = PAGE_SIZE;
>> +		} else {
>> +			unlock_len += PAGE_SIZE;
>> +		}
>> +	}
>> +
>> +	if (unlock_start)
>> +		unlock_extent(tree, unlock_start,
>> +			      unlock_start + unlock_len - 1);
>> +	if (io_bio->end_io)
>> +		io_bio->end_io(io_bio, bio->bi_error);
>> +	bio_put(bio);
>> +}
>> +
>> +int read_extent_buffer_pages(struct extent_buffer *eb, int wait,
>> +			     int mirror_num)
>> +{
>> +	struct btrfs_eb_info *eb_info = eb->eb_info;
>> +	struct extent_io_tree *io_tree = &eb_info->io_tree;
>> +	struct block_device *bdev = eb_info->fs_info->fs_devices->latest_bdev;
>> +	struct bio *bio = NULL;
>> +	u64 offset = eb->start;
>> +	u64 unlock_start = 0, unlock_len = 0;
>>  	unsigned long i;
>>  	struct page *page;
>>  	int err;
>>  	int ret = 0;
>> -	int locked_pages = 0;
>> -	int all_uptodate = 1;
>>  	unsigned long num_pages;
>> -	unsigned long num_reads = 0;
>> -	struct bio *bio = NULL;
>> -	unsigned long bio_flags = 0;
>>
>>  	if (test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags))
>>  		return 0;
>>
>> -	num_pages = num_extent_pages(eb->start, eb->len);
>> -	for (i = 0; i < num_pages; i++) {
>> -		page = eb->pages[i];
>> -		if (wait == WAIT_NONE) {
>> -			if (!trylock_page(page))
>> -				goto unlock_exit;
>> -		} else {
>> -			lock_page(page);
>> -		}
>> -		locked_pages++;
>> -		if (!PageUptodate(page)) {
>> -			num_reads++;
>> -			all_uptodate = 0;
>> -		}
>> -	}
>> -	if (all_uptodate) {
>> -		set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
>> -		goto unlock_exit;
>> +	if (test_and_set_bit(EXTENT_BUFFER_READING, &eb->bflags)) {
>> +		if (wait != WAIT_COMPLETE)
>> +			return 0;
>> +		wait_on_bit_io(&eb->bflags, EXTENT_BUFFER_READING,
>> +			       TASK_UNINTERRUPTIBLE);
>> +		if (!test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags))
>> +			ret = -EIO;
>> +		return ret;
>>  	}
>>
>> +	lock_extent(io_tree, eb->start, eb->start + eb->len - 1);
>> +	num_pages = num_extent_pages(eb->start, eb->len);
>>  	clear_bit(EXTENT_BUFFER_READ_ERR, &eb->bflags);
>>  	eb->read_mirror = 0;
>> -	atomic_set(&eb->io_pages, num_reads);
>> +	atomic_set(&eb->io_pages, num_pages);
>>  	for (i = 0; i < num_pages; i++) {
>>  		page = eb->pages[i];
>> -
>> -		if (!PageUptodate(page)) {
>> -			if (ret) {
>> -				atomic_dec(&eb->io_pages);
>> -				unlock_page(page);
>> -				continue;
>> +		if (ret) {
>> +			unlock_len += PAGE_SIZE;
>> +			if (atomic_dec_and_test(&eb->io_pages)) {
>> +				clear_bit(EXTENT_BUFFER_READING, &eb->bflags);
>> +				smp_mb__after_atomic();
>> +				wake_up_bit(&eb->bflags, EXTENT_BUFFER_READING);
>>  			}
>> +			continue;
>> +		}
>>
>> -			ClearPageError(page);
>> -			err = __extent_read_full_page(tree, page,
>> -						      get_extent, &bio,
>> -						      mirror_num, &bio_flags,
>> -						      REQ_META);
>> -			if (err) {
>> -				ret = err;
>> -				/*
>> -				 * We use &bio in above __extent_read_full_page,
>> -				 * so we ensure that if it returns error, the
>> -				 * current page fails to add itself to bio and
>> -				 * it's been unlocked.
>> -				 *
>> -				 * We must dec io_pages by ourselves.
>> -				 */
>> -				atomic_dec(&eb->io_pages);
>> +		err = submit_extent_page(REQ_OP_READ, REQ_META, io_tree, NULL,
>> +					 page, offset >> 9, PAGE_SIZE, 0, bdev,
>> +					 &bio, -1,
>> +					 end_bio_extent_buffer_readpage,
>> +					 mirror_num, 0, 0, false);
>> +		if (err) {
>> +			ret = err;
>> +			/*
>> +			 * We use &bio in above submit_extent_page
>> +			 * so we ensure that if it returns error, the
>> +			 * current page fails to add itself to bio and
>> +			 * it's been unlocked.
>> +			 *
>> +			 * We must dec io_pages by ourselves.
>> +			 */
>> +			if (atomic_dec_and_test(&eb->io_pages)) {
>> +				clear_bit(EXTENT_BUFFER_READING, &eb->bflags);
>> +				smp_mb__after_atomic();
>> +				wake_up_bit(&eb->bflags, EXTENT_BUFFER_READING);
>>  			}
>> -		} else {
>> -			unlock_page(page);
>> +			unlock_start = eb->start;
>
> Josef, IMHO "unlock_start" should have been set to "offset". Lets say we
> have 4 pages making up a metadata block and the first page was successfully
> added to a bio. Assume that adding the second page to the bio resulted in
> submit_extent_page() returning an error. In this scenario,
> end_bio_extent_buffer_readpage() will own the responsibility of unlocking the
> first 4k range in the io tree. However with "unlock_start" being set to
> "eb->start", read_extent_buffer_pages() may end up unlocking the first 4k
> range in the io tree.

Oops, good catch, I'll fix it up.  Thanks,

Josef
