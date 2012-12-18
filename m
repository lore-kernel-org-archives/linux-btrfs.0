Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29596 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab2LRHcv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Dec 2012 02:32:51 -0500
Date: Tue, 18 Dec 2012 15:30:51 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: clinew@linux.vnet.ibm.com
Cc: linux-btrfs@vger.kernel.org, cmm@linux.vnet.ibm.com
Subject: Re: [PATCH] [RFC v2] Btrfs: Subpagesize blocksize (WIP).
Message-ID: <20121218073050.GA19332@liubo.cn.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1355814805-13935-1-git-send-email-clinew@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1355814805-13935-1-git-send-email-clinew@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 17, 2012 at 11:13:25PM -0800, clinew@linux.vnet.ibm.com wrote:
> From: Wade Cline <clinew@linux.vnet.ibm.com>
> 
> v1 -> v2:
> - Added Signed-off-by tag (it's kind of important).
> 
> This patch is only an RFC. My internship is ending and I was hoping
> to get some feedback and incorporate any suggestions people may
> have before my internship ends along with life as we know it (this
> Friday).
> 
> The filesystem should mount/umount properly but tends towards the
> explosive side when writes start happening. My current focus is on
> checksumming issues and also an error when releasing extent buffers
> when creating a large file with 'dd'... and probably any other
> method. There's still a significant amount of work that needs to be
> done before this should be incorporated into mainline.
> 
> A couple of notes:
>     - Based off of Josef's btrfs-next branch, commit
>       8d089a86e45b34d7bc534d955e9d8543609f7e42
>     - C99-style comments are "meta-comments" where I'd like more
>       feedback; they aren't permanent but make 'checkpatch' moan.
>     - extent_buffer allocation and freeing need their code paths
>       merged; they're currently in separate functions and are both
>       very ugly.
>     - The patch itself will eventually need to be broken down
>       into smaller pieces if at all possible...

Could you please first elaborate why we need this subpagesize stuff and
any user case in this patch's commit log?
Or Am I missing something?

thanks,
liubo

> 
> Signed-off-by: Wade Cline <clinew@linux.vnet.ibm.com>
> ---
>  fs/btrfs/ctree.h            |   11 +-
>  fs/btrfs/disk-io.c          |  110 +++++++--
>  fs/btrfs/extent_io.c        |  632 ++++++++++++++++++++++++++++++++++++++-----
>  fs/btrfs/extent_io.h        |    7 +
>  fs/btrfs/file.c             |    9 +-
>  fs/btrfs/free-space-cache.c |    2 +
>  fs/btrfs/inode.c            |   38 ++-
>  fs/btrfs/ioctl.c            |    4 +-
>  8 files changed, 709 insertions(+), 104 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index fbaaf20..c786a58 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1938,14 +1938,19 @@ static inline void btrfs_set_token_##name(struct extent_buffer *eb,	\
>  #define BTRFS_SETGET_HEADER_FUNCS(name, type, member, bits)		\
>  static inline u##bits btrfs_##name(struct extent_buffer *eb)		\
>  {									\
> -	type *p = page_address(eb->pages[0]);				\
> -	u##bits res = le##bits##_to_cpu(p->member);			\
> +	type *p;							\
> +	u##bits res;							\
> +									\
> +	p = page_address(eb->pages[0]) + (eb->start & (PAGE_SIZE - 1)); \
> +	res = le##bits##_to_cpu(p->member);				\
>  	return res;							\
>  }									\
>  static inline void btrfs_set_##name(struct extent_buffer *eb,		\
>  				    u##bits val)			\
>  {									\
> -	type *p = page_address(eb->pages[0]);				\
> +	type *p;							\
> +									\
> +	p = page_address(eb->pages[0]) + (eb->start & (PAGE_SIZE - 1)); \
>  	p->member = cpu_to_le##bits(val);				\
>  }
>  
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index f633af8..00b80b7 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -373,6 +373,24 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
>  					       WAIT_COMPLETE,
>  					       btree_get_extent, mirror_num);
>  		if (!ret) {
> +			/*
> +			 * I think that this is bad and should be moved
> +			 * into btree_readpage_end_io_hook(), but that
> +			 * it should apply to a single block at a time.
> +			 * That may be difficult and would make the
> +			 * function name a misnomer, but mostly I hate
> +			 * the silly goto.
> +			 */
> +			if (eb->len < PAGE_SIZE &&
> +			    !extent_buffer_uptodate(eb)) {
> +				if (csum_tree_block(root, eb, 1)) {
> +					ret = -EIO;
> +					goto bad;
> +				} else {
> +					set_extent_buffer_uptodate(eb);
> +				}
> +			}
> +
>  			if (!verify_parent_transid(io_tree, eb,
>  						   parent_transid, 0))
>  				break;
> @@ -385,6 +403,7 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
>  		 * there is no reason to read the other copies, they won't be
>  		 * any less wrong.
>  		 */
> +bad:
>  		if (test_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags))
>  			break;
>  
> @@ -416,29 +435,55 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
>   * checksum a dirty tree block before IO.  This has extra checks to make sure
>   * we only fill in the checksum field in the first page of a multi-page block
>   */
> -
> -static int csum_dirty_buffer(struct btrfs_root *root, struct page *page)
> +static int csum_dirty_buffer(struct btrfs_root *root, struct page *page,
> +			     unsigned int offset, unsigned int len)
>  {
> -	struct extent_io_tree *tree;
>  	u64 start = (u64)page->index << PAGE_CACHE_SHIFT;
>  	u64 found_start;
>  	struct extent_buffer *eb;
>  
> -	tree = &BTRFS_I(page->mapping->host)->io_tree;
> +	if (!PageUptodate(page)) {
> +		WARN_ON(1);
> +		return 0;
> +	}
>  
>  	eb = (struct extent_buffer *)page->private;
> -	if (page != eb->pages[0])
> -		return 0;
> +	if (eb->len >= PAGE_SIZE) {
> +		if (eb->pages[0] != page)
> +			return 0;
> +	} else {
> +		start += offset;
> +		while (eb->start != start) {
> +			eb = eb->next;
> +			BUG_ON(!eb);
> +		}
> +next:
> +		if (!test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags))
> +			WARN_ON(1);
> +		if (!test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags))
> +			WARN_ON(1);
> +		if (eb->pages[0] != page)
> +			WARN_ON(1);
> +	}
> +
>  	found_start = btrfs_header_bytenr(eb);
>  	if (found_start != start) {
>  		WARN_ON(1);
>  		return 0;
>  	}
> -	if (!PageUptodate(page)) {
> -		WARN_ON(1);
> -		return 0;
> -	}
> +
>  	csum_tree_block(root, eb, 0);
> +
> +	if (eb->len < PAGE_SIZE) {
> +		len -= eb->len;
> +		BUG_ON(len & (eb->len - 1));
> +		if (len) {
> +			start += eb->len;
> +			eb = eb->next;
> +			goto next;
> +		}
> +	}
> +
>  	return 0;
>  }
>  
> @@ -579,6 +624,19 @@ static int btree_readpage_end_io_hook(struct page *page, u64 start, u64 end,
>  
>  	tree = &BTRFS_I(page->mapping->host)->io_tree;
>  	eb = (struct extent_buffer *)page->private;
> +	if (eb->len < PAGE_SIZE) {
> +		/* Find the eb that tried to submit a read request. This is
> +		 * a little bit funky. */
> +		do {
> +			if (!atomic_read(&eb->io_pages))
> +				continue;
> +			if (test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags) ||
> +			    test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags))
> +				continue;
> +			break;
> +		} while ((eb = eb->next));
> +		BUG_ON(!eb);
> +	}
>  
>  	/* the pending IO might have been the only thing that kept this buffer
>  	 * in memory.  Make sure we have a ref for all this other checks
> @@ -615,8 +673,11 @@ static int btree_readpage_end_io_hook(struct page *page, u64 start, u64 end,
>  	btrfs_set_buffer_lockdep_class(btrfs_header_owner(eb),
>  				       eb, found_level);
>  
> -	ret = csum_tree_block(root, eb, 1);
> -	if (ret) {
> +	/*
> +	 * Subpagesize blocksize checksumming is currently done in
> +	 * btree_read_extent_buffer_pages().
> +	 */
> +	if (eb->len >= PAGE_SIZE && csum_tree_block(root, eb, 1)) {
>  		ret = -EIO;
>  		goto err;
>  	}
> @@ -631,8 +692,15 @@ static int btree_readpage_end_io_hook(struct page *page, u64 start, u64 end,
>  		ret = -EIO;
>  	}
>  
> -	if (!ret)
> +	/*
> +	 * For subpagesize blocksize, only the page needs to be set
> +	 * up-to-date; each extent_buffer is set up-to-date when it is
> +	 * checksummed.
> +	 */
> +	if (eb->len >= PAGE_SIZE)
>  		set_extent_buffer_uptodate(eb);
> +	else
> +		SetPageUptodate(eb->pages[0]);
>  err:
>  	if (test_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags)) {
>  		clear_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags);
> @@ -828,7 +896,8 @@ static int btree_csum_one_bio(struct bio *bio)
>  	WARN_ON(bio->bi_vcnt <= 0);
>  	while (bio_index < bio->bi_vcnt) {
>  		root = BTRFS_I(bvec->bv_page->mapping->host)->root;
> -		ret = csum_dirty_buffer(root, bvec->bv_page);
> +		ret = csum_dirty_buffer(root, bvec->bv_page, bvec->bv_offset,
> +					bvec->bv_len);
>  		if (ret)
>  			break;
>  		bio_index++;
> @@ -1007,9 +1076,13 @@ static int btree_set_page_dirty(struct page *page)
>  	BUG_ON(!PagePrivate(page));
>  	eb = (struct extent_buffer *)page->private;
>  	BUG_ON(!eb);
> -	BUG_ON(!test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
> -	BUG_ON(!atomic_read(&eb->refs));
> -	btrfs_assert_tree_locked(eb);
> +	/* There doesn't seem to be a method for passing the correct eb
> +	 * to this function, so no sanity checks for subpagesize blocksize. */
> +	if (eb->len >= PAGE_SIZE) {
> +		BUG_ON(!test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
> +		BUG_ON(!atomic_read(&eb->refs));
> +		btrfs_assert_tree_locked(eb);
> +	}
>  #endif
>  	return __set_page_dirty_nobuffers(page);
>  }
> @@ -2400,11 +2473,14 @@ int open_ctree(struct super_block *sb,
>  		goto fail_sb_buffer;
>  	}
>  
> +#if 0
> +	// Hmm. How to deal wth this for subpagesize blocksize?
>  	if (sectorsize != PAGE_SIZE) {
>  		printk(KERN_WARNING "btrfs: Incompatible sector size(%lu) "
>  		       "found on %s\n", (unsigned long)sectorsize, sb->s_id);
>  		goto fail_sb_buffer;
>  	}
> +#endif
>  
>  	mutex_lock(&fs_info->chunk_mutex);
>  	ret = btrfs_read_sys_array(tree_root);
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 1b319df..c1e052e 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2519,7 +2519,7 @@ static int submit_extent_page(int rw, struct extent_io_tree *tree,
>  	int contig = 0;
>  	int this_compressed = bio_flags & EXTENT_BIO_COMPRESSED;
>  	int old_compressed = prev_bio_flags & EXTENT_BIO_COMPRESSED;
> -	size_t page_size = min_t(size_t, size, PAGE_CACHE_SIZE);
> +	size_t bio_size = min_t(size_t, size, PAGE_CACHE_SIZE);
>  
>  	if (bio_ret && *bio_ret) {
>  		bio = *bio_ret;
> @@ -2530,8 +2530,8 @@ static int submit_extent_page(int rw, struct extent_io_tree *tree,
>  				sector;
>  
>  		if (prev_bio_flags != bio_flags || !contig ||
> -		    merge_bio(tree, page, offset, page_size, bio, bio_flags) ||
> -		    bio_add_page(bio, page, page_size, offset) < page_size) {
> +		    merge_bio(tree, page, offset, bio_size, bio, bio_flags) ||
> +		    bio_add_page(bio, page, bio_size, offset) < bio_size) {
>  			ret = submit_one_bio(rw, bio, mirror_num,
>  					     prev_bio_flags);
>  			if (ret < 0)
> @@ -2550,7 +2550,7 @@ static int submit_extent_page(int rw, struct extent_io_tree *tree,
>  	if (!bio)
>  		return -ENOMEM;
>  
> -	bio_add_page(bio, page, page_size, offset);
> +	bio_add_page(bio, page, bio_size, offset);
>  	bio->bi_end_io = end_io_func;
>  	bio->bi_private = tree;
>  
> @@ -3168,14 +3168,28 @@ static void end_bio_extent_buffer_writepage(struct bio *bio, int err)
>  	int uptodate = err == 0;
>  	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
>  	struct extent_buffer *eb;
> +	unsigned int offset;
> +	unsigned int bv_len;
> +	u64 start;
>  	int done;
>  
>  	do {
>  		struct page *page = bvec->bv_page;
> +		offset = bvec->bv_offset;
> +		bv_len = bvec->bv_len;
> +		start = ((u64)page->index << PAGE_CACHE_SHIFT) + offset;
>  
>  		bvec--;
>  		eb = (struct extent_buffer *)page->private;
>  		BUG_ON(!eb);
> +		if (eb->len < PAGE_SIZE) {
> +			while (eb->start != start) {
> +				eb = eb->next;
> +				BUG_ON(!eb);
> +			}
> +		}
> +
> +next_eb:
>  		done = atomic_dec_and_test(&eb->io_pages);
>  
>  		if (!uptodate || test_bit(EXTENT_BUFFER_IOERR, &eb->bflags)) {
> @@ -3184,12 +3198,50 @@ static void end_bio_extent_buffer_writepage(struct bio *bio, int err)
>  			SetPageError(page);
>  		}
>  
> -		end_page_writeback(page);
> +		if (eb->len >= PAGE_SIZE) {
> +			end_page_writeback(page);
>  
> -		if (!done)
> -			continue;
> +			if (!done)
> +				continue;
>  
> -		end_extent_buffer_writeback(eb);
> +			end_extent_buffer_writeback(eb);
> +		} else {
> +			/* Sanity checks. */
> +			if (!test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags))
> +				WARN_ON(1);
> +
> +			/* Ensure I/O page count is zero. */
> +			if (!done)
> +				WARN_ON(1);
> +
> +			/* Clear the extent buffer's writeback flag. */
> +			end_extent_buffer_writeback(eb);
> +
> +			/*
> +			 * See if any other extent buffers exists within the
> +			 * page.
> +			 */
> +			bv_len -= eb->len;
> +			BUG_ON(bv_len & (eb->len - 1));
> +			if (bv_len) {
> +				eb = eb->next;
> +				goto next_eb;
> +			}
> +
> +			/* Clear the page writeback flag. */
> +			eb = (struct extent_buffer *)page->private;
> +			BUG_ON(!eb); /* Can this even happen? */
> +			do {
> +				if (!eb) {
> +					end_page_writeback(page);
> +					break;
> +				}
> +				if (test_bit(EXTENT_BUFFER_WRITEBACK,
> +					     &eb->bflags))
> +					break;
> +				eb = eb->next;
> +			} while (1);
> +		}
>  	} while (bvec >= bio->bi_io_vec);
>  
>  	bio_put(bio);
> @@ -3202,7 +3254,8 @@ static int write_one_eb(struct extent_buffer *eb,
>  			struct extent_page_data *epd)
>  {
>  	struct block_device *bdev = fs_info->fs_devices->latest_bdev;
> -	u64 offset = eb->start;
> +	u64 start = eb->start;
> +	unsigned long offset = eb->start & (PAGE_CACHE_SIZE - 1);
>  	unsigned long i, num_pages;
>  	unsigned long bio_flags = 0;
>  	int rw = (epd->sync_io ? WRITE_SYNC : WRITE);
> @@ -3219,10 +3272,10 @@ static int write_one_eb(struct extent_buffer *eb,
>  
>  		clear_page_dirty_for_io(p);
>  		set_page_writeback(p);
> -		ret = submit_extent_page(rw, eb->tree, p, offset >> 9,
> -					 PAGE_CACHE_SIZE, 0, bdev, &epd->bio,
> -					 -1, end_bio_extent_buffer_writepage,
> -					 0, epd->bio_flags, bio_flags);
> +		ret = submit_extent_page(rw, eb->tree, p, start >> 9, eb->len,
> +					offset, bdev, &epd->bio, -1,
> +					end_bio_extent_buffer_writepage, 0,
> +					epd->bio_flags, bio_flags);
>  		epd->bio_flags = bio_flags;
>  		if (ret) {
>  			set_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
> @@ -3232,7 +3285,7 @@ static int write_one_eb(struct extent_buffer *eb,
>  			ret = -EIO;
>  			break;
>  		}
> -		offset += PAGE_CACHE_SIZE;
> +		start += PAGE_CACHE_SIZE;
>  		update_nr_written(p, wbc, 1);
>  		unlock_page(p);
>  	}
> @@ -3252,7 +3305,7 @@ int btree_write_cache_pages(struct address_space *mapping,
>  {
>  	struct extent_io_tree *tree = &BTRFS_I(mapping->host)->io_tree;
>  	struct btrfs_fs_info *fs_info = BTRFS_I(mapping->host)->root->fs_info;
> -	struct extent_buffer *eb, *prev_eb = NULL;
> +	struct extent_buffer *eb, *next, *prev_eb = NULL;
>  	struct extent_page_data epd = {
>  		.bio = NULL,
>  		.tree = tree,
> @@ -3326,17 +3379,41 @@ retry:
>  				spin_unlock(&mapping->private_lock);
>  				continue;
>  			}
> +			prev_eb = eb;
> +
> +next_eb:
> +			next = eb->next;
>  
>  			ret = atomic_inc_not_zero(&eb->refs);
> -			spin_unlock(&mapping->private_lock);
> -			if (!ret)
> -				continue;
> +			if (eb->len >= PAGE_SIZE) {
> +				spin_unlock(&mapping->private_lock);
> +				if (!ret)
> +					continue;
> +			} else {
> +				if (!ret)
> +					goto inc_eb;
> +				spin_unlock(&mapping->private_lock);
> +
> +				if (!test_bit(EXTENT_BUFFER_DIRTY,
> +					      &eb->bflags)) {
> +					spin_lock(&mapping->private_lock);
> +					atomic_dec(&eb->refs);
> +					ret = 0;
> +					goto inc_eb;
> +				}
> +			}
>  
> -			prev_eb = eb;
>  			ret = lock_extent_buffer_for_io(eb, fs_info, &epd);
>  			if (!ret) {
> +				if (!(eb->len >= PAGE_SIZE))
> +					spin_lock(&mapping->private_lock);
> +
>  				free_extent_buffer(eb);
> -				continue;
> +
> +				if (eb->len >= PAGE_SIZE)
> +					continue;
> +				else
> +					goto inc_eb;
>  			}
>  
>  			ret = write_one_eb(eb, fs_info, wbc, &epd);
> @@ -3345,8 +3422,26 @@ retry:
>  				free_extent_buffer(eb);
>  				break;
>  			}
> +
> +			if (eb->len >= PAGE_SIZE) {
> +				free_extent_buffer(eb);
> +				goto written;
> +			}
> +
> +			if (next)
> +				spin_lock(&mapping->private_lock);
>  			free_extent_buffer(eb);
>  
> +inc_eb:
> +			if (!next) {
> +				if (spin_is_locked(&mapping->private_lock))
> +					spin_unlock(&mapping->private_lock);
> +				goto written;
> +			}
> +			eb = next;
> +			goto next_eb;
> +
> +written:
>  			/*
>  			 * the filesystem may choose to bump up nr_to_write.
>  			 * We have to make sure to honor the new nr_to_write
> @@ -4000,6 +4095,18 @@ static void __free_extent_buffer(struct extent_buffer *eb)
>  	kmem_cache_free(extent_buffer_cache, eb);
>  }
>  
> +/* Helper function to free extent buffers when there are multiple
> + * extent buffers per page. */
> +static void __free_extent_buffers(struct extent_buffer *eb)
> +{
> +	struct extent_buffer *next;
> +
> +	do {
> +		next = eb->next;
> +		__free_extent_buffer(eb);
> +	} while ((eb = next));
> +}
> +
>  static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
>  						   u64 start,
>  						   unsigned long len,
> @@ -4017,6 +4124,7 @@ static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
>  	eb->len = len;
>  	eb->tree = tree;
>  	eb->bflags = 0;
> +	eb->next = NULL;
>  	rwlock_init(&eb->lock);
>  	atomic_set(&eb->write_locks, 0);
>  	atomic_set(&eb->read_locks, 0);
> @@ -4054,6 +4162,62 @@ static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
>  	return eb;
>  }
>  
> +/* Allocates an array of extent buffers for the specified page.
> + * Should be called with the mapping's spin lock set. */
> +static struct extent_buffer *__alloc_extent_buffers(struct extent_io_tree *tree,
> +						    struct page *page,
> +						    gfp_t mask)
> +{
> +	u32 blocksize_bits;
> +	struct btrfs_inode *inode;
> +	struct extent_buffer *eb_head;
> +	struct extent_buffer *eb_cur;
> +	u64 start;
> +	unsigned long len;
> +	int i;
> +
> +	/* Initialize variables. */
> +	inode = BTRFS_I(tree->mapping->host);
> +	blocksize_bits = inode->vfs_inode.i_sb->s_blocksize_bits;
> +
> +	/* Calculate extent buffer dimensions. */
> +	start = page->index << PAGE_CACHE_SHIFT;
> +	len = inode->root->leafsize;
> +
> +	/* Allocate the head extent buffer. */
> +	eb_head = __alloc_extent_buffer(tree, start, len, GFP_NOFS);
> +	if (!eb_head) {
> +		WARN_ON(1);
> +		return NULL;
> +	}
> +	start += len;
> +	eb_head->pages[0] = page;
> +	eb_cur = eb_head;
> +
> +	/* Allocate the other extent buffers. */
> +	for (i = 1; i < (PAGE_CACHE_SIZE >> blocksize_bits); i++) {
> +		eb_cur->next = __alloc_extent_buffer(tree, start, len,
> +						     GFP_NOFS);
> +		if (!eb_cur->next) {
> +			WARN_ON(1);
> +			goto free_ebs;
> +		}
> +		start += len;
> +		eb_cur = eb_cur->next;
> +		eb_cur->pages[0] = page;
> +	}
> +
> +	/* Return the extent buffer head. */
> +	return eb_head;
> +
> +free_ebs:
> +	/* Free each extent buffer. */
> +	// TODO: Implement.
> +	pr_crit(KERN_CRIT "HACK: Need to implement this...\n");
> +	WARN_ON(1);
> +	return NULL;
> +}
> +
>  struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src)
>  {
>  	unsigned long i;
> @@ -4170,12 +4334,121 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb,
>  }
>  
>  /*
> + * Frees the page if all extent buffers belonging to the page are not
> + * referernced. The extent buffers themselves must be free afterwards, too...
> + * ret:	0 if the page did not need to be freed; 1 if the page was freed.
> + */
> +static int btrfs_release_extent_buffers_page(struct extent_buffer *eb,
> +						struct extent_buffer **eb_head)
> +{
> +	struct extent_buffer *eb_cur;
> +	struct extent_buffer *eb_temp;
> +	struct page *page;
> +	int mapped = !test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags);
> +	int ret = 0;
> +
> +	if (extent_buffer_under_io(eb))
> +		BUG_ON(1);
> +
> +	// ...is this even possible?
> +	if (!num_extent_pages(eb->start, eb->len)) {
> +		WARN_ON(1);
> +		return ret;
> +	}
> +
> +	page = extent_buffer_page(eb, 0);
> +	if (page && mapped) {
> +		spin_lock(&page->mapping->private_lock);
> +		/*
> +		 * We do this since we'll remove the pages after we've
> +		 * removed the eb from the radix tree, so we could race
> +		 * and have this page now attached to the new eb.  So
> +		 * only clear page_private if it's still connected to
> +		 * this eb.
> +		 */
> +		if (!PagePrivate(page)) {
> +			spin_unlock(&page->mapping->private_lock);
> +		} else {
> +			/* Find the page eb corresponding to our eb. */
> +			eb_cur = (struct extent_buffer *)page->private;
> +			while (eb_cur->start != eb->start) {
> +				eb_cur = eb_cur->next;
> +				BUG_ON(!eb_cur);
> +			}
> +
> +			/* See if a new eb has been attached to the page. */
> +			if (eb_cur != eb) {
> +				spin_unlock(&page->mapping->private_lock);
> +				ret = 1;
> +				goto page_release;
> +			}
> +
> +			/* See if any other extent_buffer is using the page. */
> +			eb_cur = (struct extent_buffer *)page->private;
> +			do {
> +				/* Check for any other references on the eb. */
> +				spin_lock(&eb_cur->refs_lock);
> +				if (!atomic_dec_and_test(&eb_cur->refs)) {
> +					atomic_inc(&eb_cur->refs);
> +					spin_unlock(&eb_cur->refs_lock);
> +					eb_temp = eb_cur;
> +					eb_cur = (struct extent_buffer *)
> +						 page->private;
> +					while (eb_cur != eb_temp) {
> +						atomic_inc(&eb_cur->refs);
> +						eb_cur = eb_cur->next;
> +					}
> +					spin_unlock(
> +						&page->mapping->private_lock);
> +					goto page_release;
> +				}
> +				spin_unlock(&eb_cur->refs_lock);
> +			} while ((eb_cur = eb_cur->next) != NULL);
> +
> +			/* Sanity checks. */
> +			eb_cur = (struct extent_buffer *)page->private;
> +			do {
> +				BUG_ON(extent_buffer_under_io(eb_cur));
> +			} while ((eb_cur = eb_cur->next) != NULL);
> +			BUG_ON(PageDirty(page));
> +			BUG_ON(PageWriteback(page));
> +			/*
> +			 * We need to make sure we haven't been attached
> +			 * to a new eb.
> +			 */
> +			eb_cur = (struct extent_buffer *)page->private;
> +			*eb_head = eb_cur;
> +			eb_temp = NULL;
> +			ClearPagePrivate(page);
> +			set_page_private(page, 0);
> +			/* One for the page private. */
> +			page_cache_release(page);
> +			ret = 1;
> +			spin_unlock(&page->mapping->private_lock);
> +		}
> +	}
> +
> +page_release:
> +	if (page) {
> +		/* One for when we alloced the page */
> +		page_cache_release(page);
> +	}
> +	return ret;
> +}
> +
> +/*
>   * Helper for releasing the extent buffer.
>   */
>  static inline void btrfs_release_extent_buffer(struct extent_buffer *eb)
>  {
> -	btrfs_release_extent_buffer_page(eb, 0);
> -	__free_extent_buffer(eb);
> +	if (eb->len >= PAGE_SIZE) {
> +		btrfs_release_extent_buffer_page(eb, 0);
> +		__free_extent_buffer(eb);
> +	} else {
> +		struct extent_buffer *eb_head;
> +		if (btrfs_release_extent_buffers_page(eb, &eb_head))
> +			__free_extent_buffers(eb_head);
> +	}
>  }
>  
>  static void check_buffer_tree_ref(struct extent_buffer *eb)
> @@ -4222,16 +4495,153 @@ static void mark_extent_buffer_accessed(struct extent_buffer *eb)
>  struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
>  					  u64 start, unsigned long len)
>  {
> -	unsigned long num_pages = num_extent_pages(start, len);
> -	unsigned long i;
> -	unsigned long index = start >> PAGE_CACHE_SHIFT;
> +	/* Allocate a new extent_buffer depending on blocksize*/
> +	if (len < PAGE_CACHE_SIZE)
> +		return alloc_extent_buffer_multiple(tree, start, len);
> +	return alloc_extent_buffer_single(tree, start, len);
> +}
> +
> +struct extent_buffer *alloc_extent_buffer_multiple(struct extent_io_tree *tree,
> +						   u64 start,
> +						   unsigned long len) {
> +
> +	struct address_space *mapping;
> +	u32 blocksize_bits;
> +	struct btrfs_inode *btrfs_inode;
> +	struct extent_buffer *eb_cur;
> +	struct extent_buffer *eb_head;
> +	struct extent_buffer *exists;
> +	unsigned long index;
> +	struct page *page;
> +	int ret;
> +
> +	/* Initialize variables. */
> +	btrfs_inode = BTRFS_I(tree->mapping->host);
> +	blocksize_bits = btrfs_inode->vfs_inode.i_sb->s_blocksize_bits;
> +
> +	/* Sanity checks. */
> +	WARN_ON(num_extent_pages(start, len) > 1);
> +
> +	/* See if the extent_buffer already exists in the radix tree. */
> +	rcu_read_lock();
> +	eb_cur = radix_tree_lookup(&tree->buffer, start >> blocksize_bits);
> +	if (eb_cur && atomic_inc_not_zero(&eb_cur->refs)) {
> +		rcu_read_unlock();
> +		mark_extent_buffer_accessed(eb_cur);
> +		return eb_cur;
> +	}
> +	rcu_read_unlock();
> +
> +	/* Find the page in the mapping. */
> +	index = start >> PAGE_CACHE_SHIFT;
> +	mapping = tree->mapping;
> +	page = find_or_create_page(mapping, index, GFP_NOFS);
> +	if (!page) {
> +		WARN_ON(1);
> +		return NULL;
> +	}
> +
> +	/* Allocate each extent buffer for the page. */
> +	eb_head = __alloc_extent_buffers(tree, page, GFP_NOFS);
> +	if (!eb_head) {
> +		WARN_ON(1);
> +		return NULL;
> +	}
> +
> +	/* See if extent buffers have already been allocated for
> +	 * this page. */
> +	spin_lock(&mapping->private_lock);
> +	if (PagePrivate(page)) {
> +		/*
> +		 * We could have already allocated an eb for this page
> +		 * and attached one so lets see if we can get a ref on
> +		 * the existing eb, and if we can we know it's good and
> +		 * we can just return that one, else we know we can just
> +		 * overwrite page->private.
> +		 */
> +		eb_cur = (struct extent_buffer *)page->private;
> +		while (eb_cur->start != start) {
> +			eb_cur = eb_cur->next;
> +			BUG_ON(!eb_cur);
> +		}
> +		check_buffer_tree_ref(eb_cur);
> +		spin_unlock(&mapping->private_lock);
> +		unlock_page(page);
> +		mark_extent_buffer_accessed(eb_cur);
> +		__free_extent_buffers(eb_head);
> +		return eb_cur;
> +	}
> +
> +	/* Bind the extent buffer to the page. */
> +	attach_extent_buffer_page(eb_head, page);
> +	spin_unlock(&mapping->private_lock);
> +	WARN_ON(PageDirty(page));
> +	mark_page_accessed(page);
> +
> +again:
> +	/* Set eb_cur to the buffer added. */
> +	eb_cur = eb_head;
> +	while (start != eb_cur->start) {
> +		eb_cur = eb_cur->next;
> +		BUG_ON(!eb_cur);
> +	}
> +
> +	/* Preload the radix tree. */
> +	ret = radix_tree_preload(GFP_NOFS & ~__GFP_HIGHMEM);
> +	if (ret) {
> +		WARN_ON(1);
> +		return NULL;
> +	}
> +
> +	/* Add the extent buffer to the radix tree. */
> +	spin_lock(&tree->buffer_lock);
> +	ret = radix_tree_insert(&tree->buffer,
> +				eb_cur->start >> blocksize_bits,
> +				eb_cur);
> +	if (ret == -EEXIST) {
> +		exists = radix_tree_lookup(&tree->buffer,
> +				eb_cur->start >> blocksize_bits);
> +		if (exists->start != start)
> +			BUG_ON(1);
> +		if (!atomic_inc_not_zero(&exists->refs)) {
> +			spin_unlock(&tree->buffer_lock);
> +			radix_tree_preload_end();
> +			exists = NULL;
> +			goto again;
> +		}
> +		spin_unlock(&tree->buffer_lock);
> +		radix_tree_preload_end();
> +		mark_extent_buffer_accessed(exists);
> +		WARN_ON(!atomic_dec_and_test(&eb_cur->refs));
> +		btrfs_release_extent_buffer(eb_cur);
> +		return exists;
> +	}
> +
> +	/* Set the extent buffer's tree-reference bits. */
> +	check_buffer_tree_ref(eb_cur);
> +	spin_unlock(&tree->buffer_lock);
> +	radix_tree_preload_end();
> +
> +	/* Not quite sure what this does. */
> +	SetPageChecked(eb_head->pages[0]);
> +	unlock_page(eb_head->pages[0]);
> +
> +	return eb_cur;
> +}
> +
> +struct extent_buffer *alloc_extent_buffer_single(struct extent_io_tree *tree,
> +						 u64 start, unsigned long len) {
> +	struct address_space *mapping = tree->mapping;
>  	struct extent_buffer *eb;
>  	struct extent_buffer *exists = NULL;
> +	unsigned long i;
> +	unsigned long index = start >> PAGE_CACHE_SHIFT;
> +	unsigned long num_pages = num_extent_pages(start, len);
>  	struct page *p;
> -	struct address_space *mapping = tree->mapping;
>  	int uptodate = 1;
>  	int ret;
>  
> +	/* See if the extent_buffer already exists */
>  	rcu_read_lock();
>  	eb = radix_tree_lookup(&tree->buffer, start >> PAGE_CACHE_SHIFT);
>  	if (eb && atomic_inc_not_zero(&eb->refs)) {
> @@ -4350,9 +4760,17 @@ struct extent_buffer *find_extent_buffer(struct extent_io_tree *tree,
>  					 u64 start, unsigned long len)
>  {
>  	struct extent_buffer *eb;
> +	struct btrfs_inode *btrfs_inode = BTRFS_I(tree->mapping->host);
> +	u32 blocksize_bits = btrfs_inode->vfs_inode.i_sb->s_blocksize_bits;
>  
>  	rcu_read_lock();
> -	eb = radix_tree_lookup(&tree->buffer, start >> PAGE_CACHE_SHIFT);
> +	// This branch needs to be fixed when the allocation code is merged.
> +	// Seriously.
> +	if (blocksize_bits >= PAGE_CACHE_SHIFT)
> +		eb = radix_tree_lookup(&tree->buffer,
> +				       start >> PAGE_CACHE_SHIFT);
> +	else
> +		eb = radix_tree_lookup(&tree->buffer, start >> blocksize_bits);
>  	if (eb && atomic_inc_not_zero(&eb->refs)) {
>  		rcu_read_unlock();
>  		mark_extent_buffer_accessed(eb);
> @@ -4371,9 +4789,25 @@ static inline void btrfs_release_extent_buffer_rcu(struct rcu_head *head)
>  	__free_extent_buffer(eb);
>  }
>  
> -/* Expects to have eb->eb_lock already held */
> +/*
> + * The RCU head must point to the first extent buffer belonging to a page.
> + */
> +static inline void btrfs_release_extent_buffers_rcu(struct rcu_head *head)
> +{
> +	struct extent_buffer *eb =
> +			container_of(head, struct extent_buffer, rcu_head);
> +
> +	do {
> +		call_rcu(&eb->rcu_head, btrfs_release_extent_buffer_rcu);
> +	} while ((eb = eb->next));
> +}
> +
> +/* Expects to have eb->refs_lock already held */
>  static int release_extent_buffer(struct extent_buffer *eb, gfp_t mask)
>  {
> +	struct btrfs_inode *btrfs_inode = BTRFS_I(eb->tree->mapping->host);
> +	u32 blocksize_bits = btrfs_inode->vfs_inode.i_sb->s_blocksize_bits;
> +
>  	WARN_ON(atomic_read(&eb->refs) == 0);
>  	if (atomic_dec_and_test(&eb->refs)) {
>  		if (test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags)) {
> @@ -4381,17 +4815,35 @@ static int release_extent_buffer(struct extent_buffer *eb, gfp_t mask)
>  		} else {
>  			struct extent_io_tree *tree = eb->tree;
>  
> +			/* Dumb hack to make releasing the page easier. */
> +			if (eb->len < PAGE_SIZE)
> +				atomic_inc(&eb->refs);
> +
>  			spin_unlock(&eb->refs_lock);
>  
> +			// This also needs to be fixed when allocation code is
> +			// merged.
>  			spin_lock(&tree->buffer_lock);
> -			radix_tree_delete(&tree->buffer,
> -					  eb->start >> PAGE_CACHE_SHIFT);
> +			if (eb->len >= PAGE_SIZE)
> +				radix_tree_delete(&tree->buffer,
> +					  eb->start >> blocksize_bits);
> +			else
> +				radix_tree_delete(&tree->buffer,
> +					  eb->start >> blocksize_bits);
>  			spin_unlock(&tree->buffer_lock);
>  		}
>  
>  		/* Should be safe to release our pages at this point */
> -		btrfs_release_extent_buffer_page(eb, 0);
> -		call_rcu(&eb->rcu_head, btrfs_release_extent_buffer_rcu);
> +		if (eb->len >= PAGE_SIZE) {
> +			btrfs_release_extent_buffer_page(eb, 0);
> +			call_rcu(&eb->rcu_head,
> +				 btrfs_release_extent_buffer_rcu);
> +		} else {
> +			struct extent_buffer *eb_head;
> +			if (btrfs_release_extent_buffers_page(eb, &eb_head))
> +				btrfs_release_extent_buffers_rcu(
> +							&eb_head->rcu_head);
> +		}
>  		return 1;
>  	}
>  	spin_unlock(&eb->refs_lock);
> @@ -4482,6 +4934,11 @@ int set_extent_buffer_dirty(struct extent_buffer *eb)
>  
>  	for (i = 0; i < num_pages; i++)
>  		set_page_dirty(extent_buffer_page(eb, i));
> +	/* Run an additional sanity check here instead of
> +	 * in btree_set_page_dirty() since we can't get the eb there for
> +	 * subpage blocksize. */
> +	if (eb->len < PAGE_SIZE)
> +		btrfs_assert_tree_locked(eb);
>  	return was_dirty;
>  }
>  
> @@ -4503,11 +4960,14 @@ int clear_extent_buffer_uptodate(struct extent_buffer *eb)
>  	unsigned long num_pages;
>  
>  	clear_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
> -	num_pages = num_extent_pages(eb->start, eb->len);
> -	for (i = 0; i < num_pages; i++) {
> -		page = extent_buffer_page(eb, i);
> -		if (page)
> -			ClearPageUptodate(page);
> +	/* Ignore the page's uptodate flag forsubpage blocksize. */
> +	if (eb->len >= PAGE_SIZE) {
> +		num_pages = num_extent_pages(eb->start, eb->len);
> +		for (i = 0; i < num_pages; i++) {
> +			page = extent_buffer_page(eb, i);
> +			if (page)
> +				ClearPageUptodate(page);
> +		}
>  	}
>  	return 0;
>  }
> @@ -4518,11 +4978,16 @@ int set_extent_buffer_uptodate(struct extent_buffer *eb)
>  	struct page *page;
>  	unsigned long num_pages;
>  
> +	/* Set extent buffer up-to-date. */
>  	set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
> -	num_pages = num_extent_pages(eb->start, eb->len);
> -	for (i = 0; i < num_pages; i++) {
> -		page = extent_buffer_page(eb, i);
> -		SetPageUptodate(page);
> +
> +	/* Set pages up-to-date. */
> +	if (eb->len >= PAGE_CACHE_SIZE) {
> +		num_pages = num_extent_pages(eb->start, eb->len);
> +		for (i = 0; i < num_pages; i++) {
> +			page = extent_buffer_page(eb, i);
> +			SetPageUptodate(page);
> +		}
>  	}
>  	return 0;
>  }
> @@ -4606,7 +5071,7 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
>  		}
>  	}
>  	if (all_uptodate) {
> -		if (start_i == 0)
> +		if (start_i == 0 && eb->len >= PAGE_SIZE)
>  			set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
>  		goto unlock_exit;
>  	}
> @@ -4693,7 +5158,7 @@ int map_private_extent_buffer(struct extent_buffer *eb, unsigned long start,
>  			       unsigned long *map_start,
>  			       unsigned long *map_len)
>  {
> -	size_t offset = start & (PAGE_CACHE_SIZE - 1);
> +	size_t offset;
>  	char *kaddr;
>  	struct page *p;
>  	size_t start_offset = eb->start & ((u64)PAGE_CACHE_SIZE - 1);
> @@ -4709,6 +5174,9 @@ int map_private_extent_buffer(struct extent_buffer *eb, unsigned long start,
>  		*map_start = 0;
>  	} else {
>  		offset = 0;
> +		// I'm pretty sure that this is a) just plain wrong and
> +		// b) will never realistically execute; not entirely sure,
> +		// though...
>  		*map_start = ((u64)i << PAGE_CACHE_SHIFT) - start_offset;
>  	}
>  
> @@ -4722,7 +5190,7 @@ int map_private_extent_buffer(struct extent_buffer *eb, unsigned long start,
>  	p = extent_buffer_page(eb, i);
>  	kaddr = page_address(p);
>  	*map = kaddr + offset;
> -	*map_len = PAGE_CACHE_SIZE - offset;
> +	*map_len = (PAGE_CACHE_SIZE - offset) & (eb->len - 1);
>  	return 0;
>  }
>  
> @@ -4996,6 +5464,7 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
>  int try_release_extent_buffer(struct page *page, gfp_t mask)
>  {
>  	struct extent_buffer *eb;
> +	int ret;
>  
>  	/*
>  	 * We need to make sure noboody is attaching this page to an eb right
> @@ -5010,30 +5479,61 @@ int try_release_extent_buffer(struct page *page, gfp_t mask)
>  	eb = (struct extent_buffer *)page->private;
>  	BUG_ON(!eb);
>  
> -	/*
> -	 * This is a little awful but should be ok, we need to make sure that
> -	 * the eb doesn't disappear out from under us while we're looking at
> -	 * this page.
> -	 */
> -	spin_lock(&eb->refs_lock);
> -	if (atomic_read(&eb->refs) != 1 || extent_buffer_under_io(eb)) {
> -		spin_unlock(&eb->refs_lock);
> +	if (eb->len >= PAGE_SIZE) {
> +		/*
> +		 * This is a little awful but should be ok, we need to make
> +		 * sure that the eb doesn't disappear out from under us while
> +		 * we're looking at this page.
> +		 */
> +		spin_lock(&eb->refs_lock);
> +		if (atomic_read(&eb->refs) != 1 || extent_buffer_under_io(eb)) {
> +			spin_unlock(&eb->refs_lock);
> +			spin_unlock(&page->mapping->private_lock);
> +			return 0;
> +		}
>  		spin_unlock(&page->mapping->private_lock);
> -		return 0;
> -	}
> -	spin_unlock(&page->mapping->private_lock);
>  
> -	if ((mask & GFP_NOFS) == GFP_NOFS)
> -		mask = GFP_NOFS;
> +		if ((mask & GFP_NOFS) == GFP_NOFS)
> +			mask = GFP_NOFS;
>  
> -	/*
> -	 * If tree ref isn't set then we know the ref on this eb is a real ref,
> -	 * so just return, this page will likely be freed soon anyway.
> -	 */
> -	if (!test_and_clear_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags)) {
> -		spin_unlock(&eb->refs_lock);
> -		return 0;
> -	}
> +		/*
> +		 * If tree ref isn't set then we know the ref on this eb is a
> +		 * real ref, so just return, this page will likely be freed
> +		 * soon anyway.
> +		 */
> +		if (!test_and_clear_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags)) {
> +			spin_unlock(&eb->refs_lock);
> +			return 0;
> +		}
>  
> -	return release_extent_buffer(eb, mask);
> +		return release_extent_buffer(eb, mask);
> +	} else {
> +		ret = 0;
> +		do {
> +			spin_lock(&eb->refs_lock);
> +			if (atomic_read(&eb->refs) != 1 ||
> +					extent_buffer_under_io(eb)) {
> +				spin_unlock(&eb->refs_lock);
> +				continue;
> +			}
> +			spin_unlock(&page->mapping->private_lock);
> +
> +			if ((mask & GFP_NOFS) == GFP_NOFS)
> +				mask = GFP_NOFS;
> +
> +			if (!test_and_clear_bit(EXTENT_BUFFER_TREE_REF,
> +						&eb->bflags)) {
> +				spin_unlock(&eb->refs_lock);
> +				spin_lock(&page->mapping->private_lock);
> +				continue;
> +			}
> +
> +			/* No idea what to do with the 'ret' here. */
> +			ret |= release_extent_buffer(eb, mask);
> +
> +			spin_lock(&page->mapping->private_lock);
> +		} while ((eb = eb->next) != NULL);
> +		spin_unlock(&page->mapping->private_lock);
> +		return ret;
> +	}
>  }
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index 2eacfab..955ef5e 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -163,6 +163,9 @@ struct extent_buffer {
>  	wait_queue_head_t lock_wq;
>  	struct page *inline_pages[INLINE_EXTENT_BUFFER_PAGES];
>  	struct page **pages;
> +
> +	/* Acyclic linked list of extent_buffers belonging to a single page. */
> +	struct extent_buffer *next;
>  };
>  
>  static inline void extent_set_compress_type(unsigned long *bio_flags,
> @@ -270,6 +273,10 @@ void set_page_extent_mapped(struct page *page);
>  
>  struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
>  					  u64 start, unsigned long len);
> +struct extent_buffer *alloc_extent_buffer_single(struct extent_io_tree *tree,
> +						 u64 start, unsigned long len);
> +struct extent_buffer *alloc_extent_buffer_multiple(struct extent_io_tree *tree,
> +						 u64 start, unsigned long len);
>  struct extent_buffer *alloc_dummy_extent_buffer(u64 start, unsigned long len);
>  struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src);
>  struct extent_buffer *find_extent_buffer(struct extent_io_tree *tree,
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 3bff4d4..8745289 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1340,7 +1340,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
>  		}
>  
>  		ret = btrfs_delalloc_reserve_space(inode,
> -					num_pages << PAGE_CACHE_SHIFT);
> +					write_bytes);
>  		if (ret)
>  			break;
>  
> @@ -1354,7 +1354,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
>  				    force_page_uptodate);
>  		if (ret) {
>  			btrfs_delalloc_release_space(inode,
> -					num_pages << PAGE_CACHE_SHIFT);
> +					write_bytes);
>  			break;
>  		}
>  
> @@ -1392,8 +1392,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
>  				spin_unlock(&BTRFS_I(inode)->lock);
>  			}
>  			btrfs_delalloc_release_space(inode,
> -					(num_pages - dirty_pages) <<
> -					PAGE_CACHE_SHIFT);
> +						write_bytes - copied);
>  		}
>  
>  		if (copied > 0) {
> @@ -1402,7 +1401,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
>  						NULL);
>  			if (ret) {
>  				btrfs_delalloc_release_space(inode,
> -					dirty_pages << PAGE_CACHE_SHIFT);
> +						copied);
>  				btrfs_drop_pages(pages, num_pages);
>  				break;
>  			}
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index 59ea2e4..1c0e254 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -960,6 +960,8 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
>  
>  	if (block_group)
>  		start = block_group->key.objectid;
> +	else // Hmm I don't recall putting this here.
> +		start = (u64)-1;
>  
>  	while (block_group && (start < block_group->key.objectid +
>  			       block_group->key.offset)) {
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 3368c10..11ff3dd 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2040,22 +2040,38 @@ static int btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
>  	struct btrfs_root *root = BTRFS_I(inode)->root;
>  	struct btrfs_ordered_extent *ordered_extent = NULL;
>  	struct btrfs_workers *workers;
> +	u64 block_size = 1 << inode->i_blkbits;
> +	u64 io_size;
> +
> +	if (block_size >= PAGE_CACHE_SIZE)
> +		io_size = end - start + 1;
> +	else
> +		io_size = block_size;
>  
>  	trace_btrfs_writepage_end_io_hook(page, start, end, uptodate);
>  
>  	ClearPagePrivate2(page);
> -	if (!btrfs_dec_test_ordered_pending(inode, &ordered_extent, start,
> -					    end - start + 1, uptodate))
> -		return 0;
> -
> -	ordered_extent->work.func = finish_ordered_fn;
> -	ordered_extent->work.flags = 0;
> -
> -	if (btrfs_is_free_space_inode(inode))
> -		workers = &root->fs_info->endio_freespace_worker;
> -	else
> -		workers = &root->fs_info->endio_write_workers;
> -	btrfs_queue_worker(workers, &ordered_extent->work);
> +next_block:
> +	if (btrfs_dec_test_ordered_pending(inode, &ordered_extent, start,
> +					    io_size, uptodate)) {
> +		ordered_extent->work.func = finish_ordered_fn;
> +		ordered_extent->work.flags = 0;
> +
> +		if (btrfs_is_free_space_inode(inode))
> +			workers = &root->fs_info->endio_freespace_worker;
> +		else
> +			workers = &root->fs_info->endio_write_workers;
> +		btrfs_queue_worker(workers, &ordered_extent->work);
> +	}
> +
> +	// I think that writes are always block-size granularity.
> +	if (block_size < PAGE_CACHE_SIZE)
> +		BUG_ON(start & (io_size - 1)); // Welp, one way to make sure...
> +	start += io_size;
> +	if (start < end)
> +		goto next_block;
> +	// We overshot. I'm pretty sure that this is terrible.
> +	BUG_ON(start != (end + 1));
>  
>  	return 0;
>  }
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 657d83c..c0269df 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3937,8 +3937,8 @@ long btrfs_ioctl(struct file *file, unsigned int
>  		return btrfs_ioctl_qgroup_create(file, argp);
>  	case BTRFS_IOC_QGROUP_LIMIT:
>  		return btrfs_ioctl_qgroup_limit(file, argp);
> -	case BTRFS_IOC_DEV_REPLACE:
> -		return btrfs_ioctl_dev_replace(root, argp);
> +	//case BTRFS_IOC_DEV_REPLACE:
> +//		return btrfs_ioctl_dev_replace(root, argp);
>  	}
>  
>  	return -ENOTTY;
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
