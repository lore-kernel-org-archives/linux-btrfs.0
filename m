Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:33737 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbbGTMzw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jul 2015 08:55:52 -0400
Received: from /spool/local
	by e23smtp04.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 20 Jul 2015 22:55:50 +1000
Received: from d23relay09.au.ibm.com (d23relay09.au.ibm.com [9.185.63.181])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id 0FE0C2CE8052
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Jul 2015 22:55:48 +1000 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay09.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t6KCteJg34013276
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Jul 2015 22:55:48 +1000
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
	by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t6KCtFNR005159
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Jul 2015 22:55:15 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: bo.li.liu@oracle.com
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com
Subject: Re: [RFC PATCH V11 14/21] Btrfs: subpagesize-blocksize: Explicitly Track I/O status of blocks of an ordered extent.
Date: Mon, 20 Jul 2015 18:24:56 +0530
Message-ID: <1749871.T0g3guXiav@localhost.localdomain>
In-Reply-To: <20150720083432.GB16931@localhost.localdomain>
References: <1433172176-8742-1-git-send-email-chandan@linux.vnet.ibm.com> <1433172176-8742-15-git-send-email-chandan@linux.vnet.ibm.com> <20150720083432.GB16931@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 20 Jul 2015 16:34:35 Liu Bo wrote:
> On Mon, Jun 01, 2015 at 08:52:49PM +0530, Chandan Rajendra wrote:
> > In subpagesize-blocksize scenario a page can have more than one block. So
> > in addition to PagePrivate2 flag, we would have to track the I/O status of
> > each block of a page to reliably mark the ordered extent as complete.
> > 
> > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> > ---
> > 
> >  fs/btrfs/extent_io.c    |  19 +--
> >  fs/btrfs/extent_io.h    |   5 +-
> >  fs/btrfs/inode.c        | 346
> >  +++++++++++++++++++++++++++++++++++------------- fs/btrfs/ordered-data.c
> >  |  17 +++
> >  fs/btrfs/ordered-data.h |   4 +
> >  5 files changed, 287 insertions(+), 104 deletions(-)
> > 
> > diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> > index 0110abc..55f900a 100644
> > --- a/fs/btrfs/extent_io.c
> > +++ b/fs/btrfs/extent_io.c
> > @@ -4545,11 +4545,10 @@ int extent_invalidatepage(struct extent_io_tree
> > *tree,> 
> >   * to drop the page.
> >   */
> >  
> >  static int try_release_extent_state(struct extent_map_tree *map,
> > 
> > -				    struct extent_io_tree *tree,
> > -				    struct page *page, gfp_t mask)
> > +				struct extent_io_tree *tree,
> > +				struct page *page, u64 start, u64 end,
> > +				gfp_t mask)
> > 
> >  {
> > 
> > -	u64 start = page_offset(page);
> > -	u64 end = start + PAGE_CACHE_SIZE - 1;
> > 
> >  	int ret = 1;
> >  	
> >  	if (test_range_bit(tree, start, end,
> > 
> > @@ -4583,12 +4582,12 @@ static int try_release_extent_state(struct
> > extent_map_tree *map,> 
> >   * map records are removed
> >   */
> >  
> >  int try_release_extent_mapping(struct extent_map_tree *map,
> > 
> > -			       struct extent_io_tree *tree, struct page *page,
> > -			       gfp_t mask)
> > +			struct extent_io_tree *tree, struct page *page,
> > +			u64 start, u64 end, gfp_t mask)
> > 
> >  {
> >  
> >  	struct extent_map *em;
> > 
> > -	u64 start = page_offset(page);
> > -	u64 end = start + PAGE_CACHE_SIZE - 1;
> > +	u64 orig_start = start;
> > +	u64 orig_end = end;
> > 
> >  	if ((mask & __GFP_WAIT) &&
> >  	
> >  	    page->mapping->host->i_size > 16 * 1024 * 1024) {
> > 
> > @@ -4622,7 +4621,9 @@ int try_release_extent_mapping(struct
> > extent_map_tree *map,> 
> >  			free_extent_map(em);
> >  		
> >  		}
> >  	
> >  	}
> > 
> > -	return try_release_extent_state(map, tree, page, mask);
> > +	return try_release_extent_state(map, tree, page,
> > +					orig_start, orig_end,
> > +					mask);
> > 
> >  }
> >  
> >  /*
> > 
> > diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> > index 8fe5ac3..c629e53 100644
> > --- a/fs/btrfs/extent_io.h
> > +++ b/fs/btrfs/extent_io.h
> > @@ -217,8 +217,9 @@ typedef struct extent_map *(get_extent_t)(struct inode
> > *inode,> 
> >  void extent_io_tree_init(struct extent_io_tree *tree,
> >  
> >  			 struct address_space *mapping);
> >  
> >  int try_release_extent_mapping(struct extent_map_tree *map,
> > 
> > -			       struct extent_io_tree *tree, struct page *page,
> > -			       gfp_t mask);
> > +			struct extent_io_tree *tree, struct page *page,
> > +			u64 start, u64 end,
> > +			gfp_t mask);
> > 
> >  int try_release_extent_buffer(struct page *page);
> >  int lock_extent(struct extent_io_tree *tree, u64 start, u64 end);
> >  int lock_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
> > 
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index bff60c6..bfffc62 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -2990,56 +2990,115 @@ static void finish_ordered_fn(struct btrfs_work
> > *work)> 
> >  	btrfs_finish_ordered_io(ordered_extent);
> >  
> >  }
> > 
> > -static int btrfs_writepage_end_io_hook(struct page *page, u64 start, u64
> > end, -				struct extent_state *state, int 
uptodate)
> > +static void mark_blks_io_complete(struct btrfs_ordered_extent *ordered,
> > +				u64 blk, u64 nr_blks, int uptodate)
> > 
> >  {
> > 
> > -	struct inode *inode = page->mapping->host;
> > +	struct inode *inode = ordered->inode;
> > 
> >  	struct btrfs_root *root = BTRFS_I(inode)->root;
> > 
> > -	struct btrfs_ordered_extent *ordered_extent = NULL;
> > 
> >  	struct btrfs_workqueue *wq;
> >  	btrfs_work_func_t func;
> > 
> > -	u64 ordered_start, ordered_end;
> > 
> >  	int done;
> > 
> > -	trace_btrfs_writepage_end_io_hook(page, start, end, uptodate);
> > +	while (nr_blks--) {
> > +		if (test_and_set_bit(blk, ordered->blocks_done)) {
> > +			blk++;
> > +			continue;
> > +		}
> > 
> > -	ClearPagePrivate2(page);
> > -loop:
> > -	ordered_extent = btrfs_lookup_ordered_range(inode, start,
> > -						end - start + 1);
> > -	if (!ordered_extent)
> > -		goto out;
> > +		done = btrfs_dec_test_ordered_pending(inode, &ordered,
> > +						ordered->file_offset
> > +						+ (blk << inode->i_sb-
>s_blocksize_bits),
> > +						root->sectorsize,
> > +						uptodate);
> > +		if (done) {
> > +			if (btrfs_is_free_space_inode(inode)) {
> > +				wq = root->fs_info->endio_freespace_worker;
> > +				func = btrfs_freespace_write_helper;
> > +			} else {
> > +				wq = root->fs_info->endio_write_workers;
> > +				func = btrfs_endio_write_helper;
> > +			}
> > 
> > -	ordered_start = max_t(u64, start, ordered_extent->file_offset);
> > -	ordered_end = min_t(u64, end,
> > -			ordered_extent->file_offset + ordered_extent->len - 
1);
> > -
> > -	done = btrfs_dec_test_ordered_pending(inode, &ordered_extent,
> > -					ordered_start,
> > -					ordered_end - ordered_start + 1,
> > -					uptodate);
> > -	if (done) {
> > -		if (btrfs_is_free_space_inode(inode)) {
> > -			wq = root->fs_info->endio_freespace_worker;
> > -			func = btrfs_freespace_write_helper;
> > -		} else {
> > -			wq = root->fs_info->endio_write_workers;
> > -			func = btrfs_endio_write_helper;
> > +			btrfs_init_work(&ordered->work, func,
> > +					finish_ordered_fn, NULL, NULL);
> > +			btrfs_queue_work(wq, &ordered->work);
> > 
> >  		}
> > 
> > -		btrfs_init_work(&ordered_extent->work, func,
> > -				finish_ordered_fn, NULL, NULL);
> > -		btrfs_queue_work(wq, &ordered_extent->work);
> > +		blk++;
> > 
> >  	}
> > 
> > +}
> > 
> > -	btrfs_put_ordered_extent(ordered_extent);
> > +int btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
> > +				struct extent_state *state, int uptodate)
> > +{
> > +	struct inode *inode = page->mapping->host;
> > +	struct btrfs_root *root = BTRFS_I(inode)->root;
> > +	struct btrfs_ordered_extent *ordered_extent = NULL;
> > +	u64 blk, nr_blks;
> > +	int clear;
> > 
> > -	start = ordered_end + 1;
> > +	trace_btrfs_writepage_end_io_hook(page, start, end, uptodate);
> > 
> > -	if (start < end)
> > -		goto loop;
> > +	while (start < end) {
> > +		ordered_extent = btrfs_lookup_ordered_extent(inode, start);
> > +		if (!ordered_extent) {
> > +			start += root->sectorsize;
> > +			continue;
> > +		}
> > +
> > +		blk = (start - ordered_extent->file_offset)
> > +			>> inode->i_sb->s_blocksize_bits;
> > +
> > +		nr_blks = (min(end, ordered_extent->file_offset + 
ordered_extent->len -
> > 1) +			+ 1 - start) >> inode->i_sb->s_blocksize_bits;
> > +
> > +		BUG_ON(!nr_blks);
> > +
> > +		mark_blks_io_complete(ordered_extent, blk, nr_blks, uptodate);
> 
> Range [start, end] is surely contiguous, so why are we processing blocks
> one by one in mark_blks_io_complete()?
>
Liu, Thanks for pointing it out. We can actually get rid of the loop in
mark_blks_io_complete() and set the bits (corresponding to the blocks in the
range [start, end]) at btrfs_ordered_extent->blocks_done using bitmap_set().

> Same question for invalidatepage().
Unfortunately for btrfs_invalidatepage(), we need to loop across the blocks
sequentially. Consider the following file operations,

1. Write blocks [0, 7] to a file. Assume all the 8 blocks are part of the same
   ordered extent.
2. Punch a hole starting at block 4 and spanning two blocks in length.
   Here btrfs_invalidatepage() gets invoked and hence
   btrfs_ordered_extent->bytes_left gets decremented by (2 * sectorsize).
3. Punch a hole starting at block 3 and spanning two blocks in length. Again,
   btrfs_invalidatepage() gets invoked and hence
   btrfs_ordered_extent->bytes_left gets decremented by (2 * sectorsize). This
   isn't corrent since block 4 was already accounted for in step 2.

Hence we will have to check each block's completion status before invoking
btrfs_dec_test_ordered_pending().

> 
> Thanks,
> 
> -liubo
> 
> > +
> > +		start = ordered_extent->file_offset + ordered_extent->len;
> > +
> > +		btrfs_put_ordered_extent(ordered_extent);
> > +	}
> > +
> > +	start = page_offset(page);
> > +	end = start + PAGE_CACHE_SIZE - 1;
> > +	clear = 1;
> > +
> > +	while (start < end) {
> > +		ordered_extent = btrfs_lookup_ordered_extent(inode, start);
> > +		if (!ordered_extent) {
> > +			start += root->sectorsize;
> > +			continue;
> > +		}
> > +
> > +		blk = (start - ordered_extent->file_offset)
> > +			>> inode->i_sb->s_blocksize_bits;
> > +		nr_blks = (min(end, ordered_extent->file_offset + 
ordered_extent->len -
> > 1) +			+ 1  - start) >> inode->i_sb-
>s_blocksize_bits;
> > +
> > +		BUG_ON(!nr_blks);
> > +
> > +		while (nr_blks--) {
> > +			if (!test_bit(blk++, ordered_extent->blocks_done)) {
> > +				clear = 0;
> > +				break;
> > +			}
> > +		}
> > +
> > +		if (!clear) {
> > +			btrfs_put_ordered_extent(ordered_extent);
> > +			break;
> > +		}
> > +
> > +		start += ordered_extent->len;
> > +
> > +		btrfs_put_ordered_extent(ordered_extent);
> > +	}
> > +
> > +	if (clear)
> > +		ClearPagePrivate2(page);
> > 
> > -out:
> >  	return 0;
> >  
> >  }
> > 
> > @@ -8472,7 +8531,9 @@ btrfs_readpages(struct file *file, struct
> > address_space *mapping,> 
> >  	return extent_readpages(tree, mapping, pages, nr_pages,
> >  	
> >  				btrfs_get_extent);
> >  
> >  }
> > 
> > -static int __btrfs_releasepage(struct page *page, gfp_t gfp_flags)
> > +
> > +static int __btrfs_releasepage(struct page *page, u64 start, u64 end,
> > +			gfp_t gfp_flags)
> > 
> >  {
> >  
> >  	struct extent_io_tree *tree;
> >  	struct extent_map_tree *map;
> > 
> > @@ -8480,31 +8541,149 @@ static int __btrfs_releasepage(struct page *page,
> > gfp_t gfp_flags)> 
> >  	tree = &BTRFS_I(page->mapping->host)->io_tree;
> >  	map = &BTRFS_I(page->mapping->host)->extent_tree;
> > 
> > -	ret = try_release_extent_mapping(map, tree, page, gfp_flags);
> > -	if (ret == 1)
> > +
> > +	ret = try_release_extent_mapping(map, tree, page, start, end,
> > +					gfp_flags);
> > +	if ((ret == 1) && ((end - start + 1) == PAGE_CACHE_SIZE)) {
> > 
> >  		clear_page_extent_mapped(page);
> > 
> > +	} else {
> > +		ret = 0;
> > +	}
> > 
> >  	return ret;
> >  
> >  }
> >  
> >  static int btrfs_releasepage(struct page *page, gfp_t gfp_flags)
> >  {
> > 
> > +	u64 start = page_offset(page);
> > +	u64 end = start + PAGE_CACHE_SIZE - 1;
> > +
> > 
> >  	if (PageWriteback(page) || PageDirty(page))
> >  	
> >  		return 0;
> > 
> > -	return __btrfs_releasepage(page, gfp_flags & GFP_NOFS);
> > +
> > +	return __btrfs_releasepage(page, start, end, gfp_flags & GFP_NOFS);
> > +}
> > +
> > +static void invalidate_ordered_extent_blocks(struct inode *inode,
> > +					struct btrfs_ordered_extent *ordered,
> > +					u64 locked_start, u64 locked_end,
> > +					u64 cur,
> > +					int inode_evicting)
> > +{
> > +	struct btrfs_root *root = BTRFS_I(inode)->root;
> > +	struct btrfs_ordered_inode_tree *ordered_tree;
> > +	struct extent_io_tree *tree;
> > +	u64 blk, blk_done, nr_blks;
> > +	u64 end;
> > +	u64 new_len;
> > +
> > +	tree = &BTRFS_I(inode)->io_tree;
> > +
> > +	end = min(locked_end, ordered->file_offset + ordered->len - 1);
> > +
> > +	if (!inode_evicting) {
> > +		clear_extent_bit(tree, cur, end,
> > +				EXTENT_DIRTY | EXTENT_DELALLOC |
> > +				EXTENT_DO_ACCOUNTING |
> > +				EXTENT_DEFRAG, 1, 0, NULL,
> > +				GFP_NOFS);
> > +		unlock_extent(tree, locked_start, locked_end);
> > +	}
> > +
> > +
> > +	ordered_tree = &BTRFS_I(inode)->ordered_tree;
> > +	spin_lock_irq(&ordered_tree->lock);
> > +	set_bit(BTRFS_ORDERED_TRUNCATED, &ordered->flags);
> > +	new_len = cur - ordered->file_offset;
> > +	if (new_len < ordered->truncated_len)
> > +		ordered->truncated_len = new_len;
> > +
> > +	blk = (cur - ordered->file_offset) >> inode->i_sb->s_blocksize_bits;
> > +	nr_blks = (end + 1 - cur) >> inode->i_sb->s_blocksize_bits;
> > +
> > +	while (nr_blks--) {
> > +		blk_done = !test_and_set_bit(blk, ordered->blocks_done);
> > +		if (blk_done) {
> > +			spin_unlock_irq(&ordered_tree->lock);
> > +			if (btrfs_dec_test_ordered_pending(inode, &ordered,
> > +								ordered-
>file_offset + (blk << inode->i_sb->s_blocksize_bits),
> > +								root-
>sectorsize,
> > +								1))
> > +				btrfs_finish_ordered_io(ordered);
> > +
> > +			spin_lock_irq(&ordered_tree->lock);
> > +		}
> > +		blk++;
> > +	}
> > +
> > +	spin_unlock_irq(&ordered_tree->lock);
> > +
> > +	if (!inode_evicting)
> > +		lock_extent_bits(tree, locked_start, locked_end, 0, NULL);
> > +}
> > +
> > +static int page_blocks_written(struct page *page)
> > +{
> > +	struct btrfs_ordered_extent *ordered;
> > +	struct btrfs_root *root;
> > +	struct inode *inode;
> > +	unsigned long outstanding_blk;
> > +	u64 page_start, page_end;
> > +	u64 blk, last_blk, nr_blks;
> > +	u64 cur;
> > +	u64 len;
> > +
> > +	inode = page->mapping->host;
> > +	root = BTRFS_I(inode)->root;
> > +
> > +	page_start = page_offset(page);
> > +	page_end = page_start + PAGE_CACHE_SIZE - 1;
> > +
> > +	cur = page_start;
> > +	while (cur < page_end) {
> > +		ordered = btrfs_lookup_ordered_extent(inode, cur);
> > +		if (!ordered) {
> > +			cur += root->sectorsize;
> > +			continue;
> > +		}
> > +
> > +		blk = (cur - ordered->file_offset)
> > +			>> inode->i_sb->s_blocksize_bits;
> > +		len = min(page_end, ordered->file_offset + ordered->len - 1)
> > +			- cur + 1;
> > +		nr_blks = len >> inode->i_sb->s_blocksize_bits;
> > +
> > +		last_blk = blk + nr_blks - 1;
> > +
> > +		outstanding_blk = find_next_zero_bit(ordered->blocks_done,
> > +						ordered->len >> inode->i_sb-
>s_blocksize_bits,
> > +						blk);
> > +		if (outstanding_blk <= last_blk) {
> > +			btrfs_put_ordered_extent(ordered);
> > +			return 0;
> > +		}
> > +
> > +		btrfs_put_ordered_extent(ordered);
> > +		cur += len;
> > +	}
> > +
> > +	return 1;
> > 
> >  }
> >  
> >  static void btrfs_invalidatepage(struct page *page, unsigned int offset,
> > 
> > -				 unsigned int length)
> > +				unsigned int length)
> > 
> >  {
> >  
> >  	struct inode *inode = page->mapping->host;
> > 
> > +	struct btrfs_root *root = BTRFS_I(inode)->root;
> > 
> >  	struct extent_io_tree *tree;
> >  	struct btrfs_ordered_extent *ordered;
> > 
> > -	struct extent_state *cached_state = NULL;
> > -	u64 page_start = page_offset(page);
> > -	u64 page_end = page_start + PAGE_CACHE_SIZE - 1;
> > +	u64 start, end, cur;
> > +	u64 page_start, page_end;
> > 
> >  	int inode_evicting = inode->i_state & I_FREEING;
> > 
> > +	page_start = page_offset(page);
> > +	page_end = page_start + PAGE_CACHE_SIZE - 1;
> > +
> > 
> >  	/*
> >  	
> >  	 * we have the page locked, so new writeback can't start,
> >  	 * and the dirty bit won't be cleared while we are here.
> > 
> > @@ -8515,73 +8694,54 @@ static void btrfs_invalidatepage(struct page
> > *page, unsigned int offset,> 
> >  	wait_on_page_writeback(page);
> >  	
> >  	tree = &BTRFS_I(inode)->io_tree;
> > 
> > -	if (offset) {
> > +
> > +	start = round_up(offset, root->sectorsize);
> > +	end = round_down(offset + length, root->sectorsize) - 1;
> > +	if (end - start + 1 < root->sectorsize) {
> > 
> >  		btrfs_releasepage(page, GFP_NOFS);
> >  		return;
> >  	
> >  	}
> > 
> > +	start = round_up(page_start + offset, root->sectorsize);
> > +	end = round_down(page_start + offset + length,
> > +			root->sectorsize) - 1;
> > +
> > 
> >  	if (!inode_evicting)
> > 
> > -		lock_extent_bits(tree, page_start, page_end, 0, 
&cached_state);
> > -	ordered = btrfs_lookup_ordered_range(inode, page_start,
> > PAGE_CACHE_SIZE);
> > -	if (ordered) {
> > -		/*
> > -		 * IO on this page will never be started, so we need
> > -		 * to account for any ordered extents now
> > -		 */
> > -		if (!inode_evicting)
> > -			clear_extent_bit(tree, page_start, page_end,
> > -					 EXTENT_DIRTY | EXTENT_DELALLOC |
> > -					 EXTENT_LOCKED | EXTENT_DO_ACCOUNTING 
|
> > -					 EXTENT_DEFRAG, 1, 0, &cached_state,
> > -					 GFP_NOFS);
> > -		/*
> > -		 * whoever cleared the private bit is responsible
> > -		 * for the finish_ordered_io
> > -		 */
> > -		if (TestClearPagePrivate2(page)) {
> > -			struct btrfs_ordered_inode_tree *tree;
> > -			u64 new_len;
> > +		lock_extent_bits(tree, start, end, 0, NULL);
> > 
> > -			tree = &BTRFS_I(inode)->ordered_tree;
> > +	cur = start;
> > +	while (cur < end) {
> > +		ordered = btrfs_lookup_ordered_extent(inode, cur);
> > +		if (!ordered) {
> > +			cur += root->sectorsize;
> > +			continue;
> > +		}
> > 
> > -			spin_lock_irq(&tree->lock);
> > -			set_bit(BTRFS_ORDERED_TRUNCATED, &ordered->flags);
> > -			new_len = page_start - ordered->file_offset;
> > -			if (new_len < ordered->truncated_len)
> > -				ordered->truncated_len = new_len;
> > -			spin_unlock_irq(&tree->lock);
> > +		invalidate_ordered_extent_blocks(inode, ordered,
> > +						start, end, cur,
> > +						inode_evicting);
> > 
> > -			if (btrfs_dec_test_ordered_pending(inode, &ordered,
> > -							   page_start,
> > -							   PAGE_CACHE_SIZE, 
1))
> > -				btrfs_finish_ordered_io(ordered);
> > -		}
> > +		cur = min(end + 1, ordered->file_offset + ordered->len);
> > 
> >  		btrfs_put_ordered_extent(ordered);
> > 
> > -		if (!inode_evicting) {
> > -			cached_state = NULL;
> > -			lock_extent_bits(tree, page_start, page_end, 0,
> > -					 &cached_state);
> > -		}
> > 
> >  	}
> > 
> > -	if (!inode_evicting) {
> > -		clear_extent_bit(tree, page_start, page_end,
> > -				 EXTENT_LOCKED | EXTENT_DIRTY |
> > -				 EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING |
> > -				 EXTENT_DEFRAG, 1, 1,
> > -				 &cached_state, GFP_NOFS);
> > +	if (page_blocks_written(page))
> > +		ClearPagePrivate2(page);
> > 
> > -		__btrfs_releasepage(page, GFP_NOFS);
> > +	if (!inode_evicting) {
> > +		clear_extent_bit(tree, start, end,
> > +				EXTENT_LOCKED | EXTENT_DIRTY |
> > +				EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING |
> > +				EXTENT_DEFRAG, 1, 1, NULL, GFP_NOFS);
> > 
> >  	}
> > 
> > -	ClearPageChecked(page);
> > -	if (PagePrivate(page)) {
> > -		ClearPagePrivate(page);
> > -		set_page_private(page, 0);
> > -		page_cache_release(page);
> > +	if (!offset && length == PAGE_CACHE_SIZE) {
> > +		WARN_ON(!__btrfs_releasepage(page, start, end, GFP_NOFS));
> > +		ClearPageChecked(page);
> > 
> >  	}
> >  
> >  }
> > 
> > +
> > 
> >  /*
> >  
> >   * btrfs_page_mkwrite() is not allowed to change the file size as it gets
> >   * called from a page fault handler when a page is first dirtied. Hence
> >   we must> 
> > diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> > index 157cc54..8e614ca 100644
> > --- a/fs/btrfs/ordered-data.c
> > +++ b/fs/btrfs/ordered-data.c
> > @@ -189,12 +189,25 @@ static int __btrfs_add_ordered_extent(struct inode
> > *inode, u64 file_offset,> 
> >  	struct btrfs_ordered_inode_tree *tree;
> >  	struct rb_node *node;
> >  	struct btrfs_ordered_extent *entry;
> > 
> > +	u64 nr_longs;
> > 
> >  	tree = &BTRFS_I(inode)->ordered_tree;
> >  	entry = kmem_cache_zalloc(btrfs_ordered_extent_cache, GFP_NOFS);
> >  	if (!entry)
> >  	
> >  		return -ENOMEM;
> > 
> > +	nr_longs = BITS_TO_LONGS(len >> inode->i_sb->s_blocksize_bits);
> > +	if (nr_longs == 1) {
> > +		entry->blocks_done = &entry->blocks_bitmap;
> > +	} else {
> > +		entry->blocks_done = kzalloc(nr_longs * sizeof(unsigned long),
> > +					GFP_NOFS);
> > +		if (!entry->blocks_done) {
> > +			kmem_cache_free(btrfs_ordered_extent_cache, entry);
> > +			return -ENOMEM;
> > +		}
> > +	}
> > +
> > 
> >  	entry->file_offset = file_offset;
> >  	entry->start = start;
> >  	entry->len = len;
> > 
> > @@ -553,6 +566,10 @@ void btrfs_put_ordered_extent(struct
> > btrfs_ordered_extent *entry)> 
> >  			list_del(&sum->list);
> >  			kfree(sum);
> >  		
> >  		}
> > 
> > +
> > +		if (entry->blocks_done != &entry->blocks_bitmap)
> > +			kfree(entry->blocks_done);
> > +
> > 
> >  		kmem_cache_free(btrfs_ordered_extent_cache, entry);
> >  	
> >  	}
> >  
> >  }
> > 
> > diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
> > index e96cd4c..4b3356a 100644
> > --- a/fs/btrfs/ordered-data.h
> > +++ b/fs/btrfs/ordered-data.h
> > @@ -140,6 +140,10 @@ struct btrfs_ordered_extent {
> > 
> >  	struct completion completion;
> >  	struct btrfs_work flush_work;
> >  	struct list_head work_list;
> > 
> > +
> > +	/* bitmap to track the blocks that have been written to disk */
> > +	unsigned long *blocks_done;
> > +	unsigned long blocks_bitmap;
> > 
> >  };
> >  
> >  /*

-- 
chandan

