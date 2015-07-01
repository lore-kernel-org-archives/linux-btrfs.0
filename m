Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40206 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239AbbGAO1m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jul 2015 10:27:42 -0400
Date: Wed, 1 Jul 2015 22:27:22 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com
Subject: Re: [RFC PATCH V11 02/21] Btrfs: subpagesize-blocksize: Fix whole
 page write.
Message-ID: <20150701142720.GB2339@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1433172176-8742-1-git-send-email-chandan@linux.vnet.ibm.com>
 <1433172176-8742-3-git-send-email-chandan@linux.vnet.ibm.com>
 <20150626095052.GB16732@localhost.localdomain>
 <1563216.s1L9jJavQT@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1563216.s1L9jJavQT@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 29, 2015 at 02:24:18PM +0530, Chandan Rajendra wrote:
> On Friday 26 Jun 2015 17:50:54 Liu Bo wrote:
> > On Mon, Jun 01, 2015 at 08:52:37PM +0530, Chandan Rajendra wrote:
> > > For the subpagesize-blocksize scenario, a page can contain multiple
> > > blocks. In such cases, this patch handles writing data to files.
> > > 
> > > Also, When setting EXTENT_DELALLOC, we no longer set EXTENT_UPTODATE bit
> > > on
> > > the extent_io_tree since uptodate status is being tracked by the bitmap
> > > pointed to by page->private.
> > 
> > To be honestly, I'm not sure why we set EXTENT_UPTODATE bit for data as we
> > don't check for that bit at all for now, correct me if I'm wrong.
> 
> Yes, I didn't find any code using EXTENT_UPTODATE flag. That is probably
> because we could get away by referring to the page's PG_uptodate flag in
> blocksize == Pagesize scenario. But for the subpagesize-blocksize scenario we
> need BLK_STATE_UPTODATE to determine if a page's PG_uptodate flag can be set.
> 
> > 
> > > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> > > ---
> > > 
> > >  fs/btrfs/extent_io.c | 141
> > >  +++++++++++++++++++++++---------------------------- fs/btrfs/file.c     
> > >  |  16 ++++++
> > >  fs/btrfs/inode.c     |  58 ++++++++++++++++-----
> > >  3 files changed, 125 insertions(+), 90 deletions(-)
> > > 
> > > diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> > > index d37badb..3736ab5 100644
> > > --- a/fs/btrfs/extent_io.c
> > > +++ b/fs/btrfs/extent_io.c
> > > @@ -1283,9 +1283,8 @@ int clear_extent_bits(struct extent_io_tree *tree,
> > > u64 start, u64 end,> 
> > >  int set_extent_delalloc(struct extent_io_tree *tree, u64 start, u64 end,
> > >  
> > >  			struct extent_state **cached_state, gfp_t mask)
> > >  
> > >  {
> > > 
> > > -	return set_extent_bit(tree, start, end,
> > > -			      EXTENT_DELALLOC | EXTENT_UPTODATE,
> > > -			      NULL, cached_state, mask);
> > > +	return set_extent_bit(tree, start, end, EXTENT_DELALLOC,
> > > +			NULL, cached_state, mask);
> > > 
> > >  }
> > >  
> > >  int set_extent_defrag(struct extent_io_tree *tree, u64 start, u64 end,
> > > 
> > > @@ -1498,25 +1497,6 @@ int extent_range_redirty_for_io(struct inode
> > > *inode, u64 start, u64 end)> 
> > >  	return 0;
> > >  
> > >  }
> > > 
> > > -/*
> > > - * helper function to set both pages and extents in the tree writeback
> > > - */
> > > -static int set_range_writeback(struct extent_io_tree *tree, u64 start,
> > > u64 end) -{
> > > -	unsigned long index = start >> PAGE_CACHE_SHIFT;
> > > -	unsigned long end_index = end >> PAGE_CACHE_SHIFT;
> > > -	struct page *page;
> > > -
> > > -	while (index <= end_index) {
> > > -		page = find_get_page(tree->mapping, index);
> > > -		BUG_ON(!page); /* Pages should be in the extent_io_tree */
> > > -		set_page_writeback(page);
> > > -		page_cache_release(page);
> > > -		index++;
> > > -	}
> > > -	return 0;
> > > -}
> > > -
> > > 
> > >  /* find the first state struct with 'bits' set after 'start', and
> > >  
> > >   * return it.  tree->lock must be held.  NULL will returned if
> > >   * nothing was found after 'start'
> > > 
> > > @@ -2080,6 +2060,14 @@ static int page_read_complete(struct page *page)
> > > 
> > >  	return !test_page_blks_state(page, BLK_STATE_IO, start, end, 0);
> > >  
> > >  }
> > > 
> > > +static int page_write_complete(struct page *page)
> > > +{
> > > +	u64 start = page_offset(page);
> > > +	u64 end = start + PAGE_CACHE_SIZE - 1;
> > > +
> > > +	return !test_page_blks_state(page, BLK_STATE_IO, start, end, 0);
> > > +}
> > > +
> > > 
> > >  int free_io_failure(struct inode *inode, struct io_failure_record *rec)
> > >  {
> > >  
> > >  	int ret;
> > > 
> > > @@ -2575,38 +2563,37 @@ int end_extent_writepage(struct page *page, int
> > > err, u64 start, u64 end)> 
> > >   */
> > >  
> > >  static void end_bio_extent_writepage(struct bio *bio, int err)
> > >  {
> > > 
> > > +	struct btrfs_page_private *pg_private;
> > > 
> > >  	struct bio_vec *bvec;
> > > 
> > > +	unsigned long flags;
> > > 
> > >  	u64 start;
> > >  	u64 end;
> > > 
> > > +	int clear_writeback;
> > > 
> > >  	int i;
> > >  	
> > >  	bio_for_each_segment_all(bvec, bio, i) {
> > >  	
> > >  		struct page *page = bvec->bv_page;
> > > 
> > > -		/* We always issue full-page reads, but if some block
> > > -		 * in a page fails to read, blk_update_request() will
> > > -		 * advance bv_offset and adjust bv_len to compensate.
> > > -		 * Print a warning for nonzero offsets, and an error
> > > -		 * if they don't add up to a full page.  */
> > > -		if (bvec->bv_offset || bvec->bv_len != PAGE_CACHE_SIZE) {
> > > -			if (bvec->bv_offset + bvec->bv_len != PAGE_CACHE_SIZE)
> > > -				btrfs_err(BTRFS_I(page->mapping->host)->root-
> >fs_info,
> > > -				   "partial page write in btrfs with offset %u 
> and length %u",
> > > -					bvec->bv_offset, bvec->bv_len);
> > > -			else
> > > -				btrfs_info(BTRFS_I(page->mapping->host)->root-
> >fs_info,
> > > -				   "incomplete page write in btrfs with offset 
> %u and "
> > > -				   "length %u",
> > > -					bvec->bv_offset, bvec->bv_len);
> > > -		}
> > > +		start = page_offset(page) + bvec->bv_offset;
> > > +		end = start + bvec->bv_len - 1;
> > > 
> > > -		start = page_offset(page);
> > > -		end = start + bvec->bv_offset + bvec->bv_len - 1;
> > > +		pg_private = (struct btrfs_page_private *)page->private;
> > > +
> > > +		spin_lock_irqsave(&pg_private->io_lock, flags);
> > > 
> > > -		if (end_extent_writepage(page, err, start, end))
> > > +		if (end_extent_writepage(page, err, start, end)) {
> > > +			spin_unlock_irqrestore(&pg_private->io_lock, flags);
> > > 
> > >  			continue;
> > > 
> > > +		}
> > > 
> > > -		end_page_writeback(page);
> > > +		clear_page_blks_state(page, 1 << BLK_STATE_IO, start, end);
> > > +
> > > +		clear_writeback = page_write_complete(page);
> > > +
> > > +		spin_unlock_irqrestore(&pg_private->io_lock, flags);
> > > +
> > > +		if (clear_writeback)
> > > +			end_page_writeback(page);
> > > 
> > >  	}
> > >  	
> > >  	bio_put(bio);
> > > 
> > > @@ -3417,10 +3404,9 @@ static noinline_for_stack int
> > > __extent_writepage_io(struct inode *inode,> 
> > >  	u64 block_start;
> > >  	u64 iosize;
> > >  	sector_t sector;
> > > 
> > > -	struct extent_state *cached_state = NULL;
> > > 
> > >  	struct extent_map *em;
> > >  	struct block_device *bdev;
> > > 
> > > -	size_t pg_offset = 0;
> > > +	size_t pg_offset;
> > > 
> > >  	size_t blocksize;
> > >  	int ret = 0;
> > >  	int nr = 0;
> > > 
> > > @@ -3467,8 +3453,16 @@ static noinline_for_stack int
> > > __extent_writepage_io(struct inode *inode,> 
> > >  							 page_end, NULL, 1);
> > >  			
> > >  			break;
> > >  		
> > >  		}
> > > 
> > > -		em = epd->get_extent(inode, page, pg_offset, cur,
> > > -				     end - cur + 1, 1);
> > > +
> > > +		pg_offset = cur & (PAGE_CACHE_SIZE - 1);
> > > +
> > > +		if (!test_page_blks_state(page, BLK_STATE_DIRTY, cur,
> > > +						cur + blocksize - 1, 1)) {
> > > +			cur += blocksize;
> > > +			continue;
> > > +		}
> > 
> > If we don't check this, the below get_extent() will return a HOLE
> > (block_start == EXTENT_MAP_HOLE) and we can still go on to the next block,
> > then we don't need to maintain this BLK_STATE_DIRTY bit all the while.
> 
> Sorry, I am not sure if I understood your comment correctly. Are you
> suggesting that *page blocks* that are not dirty are always holes?
> 
> Let's assume a 64k page whose contents are within i_size and none of the
> blocks of the page map to a file hole. Also assume 4k as the block size. Say,
> the userspace writes to the "block 0" of the page. The corresponding code in
> __btrfs_buffered_write() reads up the complete page into the inode's page
> cache and then marks "block 0" of the page as BLK_STATE_DIRTY. Next, the
> userspace seeks and writes to "block 4" of the page. In this case, since the
> page has PG_uptodate flag already set we don't read the data from the disk
> again. We simply go ahead and mark "block 4" as BLK_STATE_DIRTY. As can be
> seen in the example scenario, the blocks 1, 2 and 3 are not holes and hence
> btrfs_get_extent() would end up returning values other than EXTENT_MAP_HOLE
> for em->block_start.

I see it now, this is a bit subtle at the first glance.

> 
> > 
> > > +
> > > +		em = epd->get_extent(inode, page, pg_offset, cur, blocksize, 
> 1);
> > > 
> > >  		if (IS_ERR_OR_NULL(em)) {
> > >  		
> > >  			SetPageError(page);
> > >  			ret = PTR_ERR_OR_ZERO(em);
> > > 
> > > @@ -3479,7 +3473,7 @@ static noinline_for_stack int
> > > __extent_writepage_io(struct inode *inode,> 
> > >  		em_end = extent_map_end(em);
> > >  		BUG_ON(em_end <= cur);
> > >  		BUG_ON(end < cur);
> > > 
> > > -		iosize = min(em_end - cur, end - cur + 1);
> > > +		iosize = min_t(u64, em_end - cur, blocksize);
> > > 
> > >  		iosize = ALIGN(iosize, blocksize);
> > 
> > This limits us to do one block per loop, if two blocks are contiguous,
> > it should be fine to write them along.
> 
> Yes, I agree. I will fix this up in one of the next versions of the
> patchset. Thanks for pointing it out.

OK.

> 
> > 
> > >  		sector = (em->block_start + extent_offset) >> 9;
> > >  		bdev = em->bdev;
> > > 
> > > @@ -3488,32 +3482,20 @@ static noinline_for_stack int
> > > __extent_writepage_io(struct inode *inode,> 
> > >  		free_extent_map(em);
> > >  		em = NULL;
> > > 
> > > -		/*
> > > -		 * compressed and inline extents are written through other
> > > -		 * paths in the FS
> > > -		 */
> > > -		if (compressed || block_start == EXTENT_MAP_HOLE ||
> > > -		    block_start == EXTENT_MAP_INLINE) {
> > > -			/*
> > > -			 * end_io notification does not happen here for
> > > -			 * compressed extents
> > > -			 */
> > > -			if (!compressed && tree->ops &&
> > > -			    tree->ops->writepage_end_io_hook)
> > > -				tree->ops->writepage_end_io_hook(page, cur,
> > > -							 cur + iosize - 1,
> > > -							 NULL, 1);
> > > -			else if (compressed) {
> > > -				/* we don't want to end_page_writeback on
> > > -				 * a compressed extent.  this happens
> > > -				 * elsewhere
> > > -				 */
> > > -				nr++;
> > > -			}
> > > +		BUG_ON(compressed);
> > > +		BUG_ON(block_start == EXTENT_MAP_INLINE);
> > > 
> > > -			cur += iosize;
> > > -			pg_offset += iosize;
> > > -			continue;
> > > +		if (block_start == EXTENT_MAP_HOLE) {
> > > +			if (test_page_blks_state(page, BLK_STATE_UPTODATE, 
> cur,
> > > +							cur + iosize - 1, 1)) 
> {
> > > +				clear_page_blks_state(page,
> > > +						1 << BLK_STATE_DIRTY, cur,
> > > +						cur + iosize - 1);
> > > +				cur += iosize;
> > > +				continue;
> > > +			} else {
> > > +				BUG();
> > > +			}
> > > 
> > >  		}
> > >  		
> > >  		if (tree->ops && tree->ops->writepage_io_hook) {
> > > 
> > > @@ -3527,7 +3509,13 @@ static noinline_for_stack int
> > > __extent_writepage_io(struct inode *inode,> 
> > >  		} else {
> > >  		
> > >  			unsigned long max_nr = (i_size >> PAGE_CACHE_SHIFT) + 
> 1;
> > > 
> > > -			set_range_writeback(tree, cur, cur + iosize - 1);
> > > +			clear_page_blks_state(page, 1 << BLK_STATE_DIRTY, cur,
> > > +					cur + iosize - 1);
> > > +			set_page_writeback(page);
> > > +
> > > +			set_page_blks_state(page, 1 << BLK_STATE_IO, cur,
> > > +					cur + iosize - 1);
> > > +
> > > 
> > >  			if (!PageWriteback(page)) {
> > >  			
> > >  				btrfs_err(BTRFS_I(inode)->root->fs_info,
> > >  				
> > >  					   "page %lu not writeback, cur %llu 
> end %llu",
> > > 
> > > @@ -3542,17 +3530,14 @@ static noinline_for_stack int
> > > __extent_writepage_io(struct inode *inode,> 
> > >  			if (ret)
> > >  			
> > >  				SetPageError(page);
> > >  		
> > >  		}
> > > 
> > > -		cur = cur + iosize;
> > > -		pg_offset += iosize;
> > > +
> > > +		cur += iosize;
> > > 
> > >  		nr++;
> > >  	
> > >  	}
> > >  
> > >  done:
> > >  	*nr_ret = nr;
> > >  
> > >  done_unlocked:
> > > -
> > > -	/* drop our reference on any cached states */
> > > -	free_extent_state(cached_state);
> > > 
> > >  	return ret;
> > >  
> > >  }
> > > 
> > > diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> > > index 23b6e03..cbe6381 100644
> > > --- a/fs/btrfs/file.c
> > > +++ b/fs/btrfs/file.c
> > > @@ -495,6 +495,9 @@ int btrfs_dirty_pages(struct btrfs_root *root, struct
> > > inode *inode,> 
> > >  	u64 num_bytes;
> > >  	u64 start_pos;
> > >  	u64 end_of_last_block;
> > > 
> > > +	u64 start;
> > > +	u64 end;
> > > +	u64 page_end;
> > > 
> > >  	u64 end_pos = pos + write_bytes;
> > >  	loff_t isize = i_size_read(inode);
> > > 
> > > @@ -507,11 +510,24 @@ int btrfs_dirty_pages(struct btrfs_root *root,
> > > struct inode *inode,> 
> > >  	if (err)
> > >  	
> > >  		return err;
> > > 
> > > +	start = start_pos;
> > > +
> > > 
> > >  	for (i = 0; i < num_pages; i++) {
> > >  	
> > >  		struct page *p = pages[i];
> > >  		SetPageUptodate(p);
> > >  		ClearPageChecked(p);
> > > 
> > > +
> > > +		end = page_end = page_offset(p) + PAGE_CACHE_SIZE - 1;
> > > +
> > > +		if (i == num_pages - 1)
> > > +			end = min_t(u64, page_end, end_of_last_block);
> > > +
> > > +		set_page_blks_state(p,
> > > +				1 << BLK_STATE_DIRTY | 1 << 
> BLK_STATE_UPTODATE,
> > > +				start, end);
> > > 
> > >  		set_page_dirty(p);
> > > 
> > > +
> > > +		start = page_end + 1;
> > 
> > This is not the usual way, page_end is unnecessary, (start +=
> > PAGE_CACHE_SIZE) should work.
> 
> "start" may not always be set to a file offset that is a multiple of page
> size. If the userspace dirties say "block 4" of 64k page, then start will be
> set to 16384. Hence in such cases, "start += PAGE_CACHE_SIZE" would yield an
> incorrect value.

Right.

> 
> > >  	}
> > >  	
> > >  	/*
> > > 
> > > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > > index 8262f83..ac6a3f3 100644
> > > --- a/fs/btrfs/inode.c
> > > +++ b/fs/btrfs/inode.c
> > > 
> > > @@ -1995,6 +1995,11 @@ again:
> > >  	 }
> > >  	
> > >  	btrfs_set_extent_delalloc(inode, page_start, page_end, &cached_state);
> > > 
> > > +
> > > +	set_page_blks_state(page,
> > > +			1 << BLK_STATE_DIRTY | 1 << BLK_STATE_UPTODATE,
> > > +			page_start, page_end);
> > > +
> > > 
> > >  	ClearPageChecked(page);
> > >  	set_page_dirty(page);
> > >  
> > >  out:
> > > @@ -2984,26 +2989,48 @@ static int btrfs_writepage_end_io_hook(struct page
> > > *page, u64 start, u64 end,> 
> > >  	struct btrfs_ordered_extent *ordered_extent = NULL;
> > >  	struct btrfs_workqueue *wq;
> > >  	btrfs_work_func_t func;
> > > 
> > > +	u64 ordered_start, ordered_end;
> > > +	int done;
> > > 
> > >  	trace_btrfs_writepage_end_io_hook(page, start, end, uptodate);
> > >  	
> > >  	ClearPagePrivate2(page);
> > > 
> > > -	if (!btrfs_dec_test_ordered_pending(inode, &ordered_extent, start,
> > > -					    end - start + 1, uptodate))
> > > -		return 0;
> > > +loop:
> > > +	ordered_extent = btrfs_lookup_ordered_range(inode, start,
> > > +						end - start + 1);
> > > +	if (!ordered_extent)
> > > +		goto out;
> > > 
> > > -	if (btrfs_is_free_space_inode(inode)) {
> > > -		wq = root->fs_info->endio_freespace_worker;
> > > -		func = btrfs_freespace_write_helper;
> > > -	} else {
> > > -		wq = root->fs_info->endio_write_workers;
> > > -		func = btrfs_endio_write_helper;
> > > +	ordered_start = max_t(u64, start, ordered_extent->file_offset);
> > > +	ordered_end = min_t(u64, end,
> > > +			ordered_extent->file_offset + ordered_extent->len - 
> 1);
> > > +
> > > +	done = btrfs_dec_test_ordered_pending(inode, &ordered_extent,
> > > +					ordered_start,
> > > +					ordered_end - ordered_start + 1,
> > > +					uptodate);
> > > +	if (done) {
> > > +		if (btrfs_is_free_space_inode(inode)) {
> > > +			wq = root->fs_info->endio_freespace_worker;
> > > +			func = btrfs_freespace_write_helper;
> > > +		} else {
> > > +			wq = root->fs_info->endio_write_workers;
> > > +			func = btrfs_endio_write_helper;
> > > +		}
> > > +
> > > +		btrfs_init_work(&ordered_extent->work, func,
> > > +				finish_ordered_fn, NULL, NULL);
> > > +		btrfs_queue_work(wq, &ordered_extent->work);
> > > 
> > >  	}
> > > 
> > > -	btrfs_init_work(&ordered_extent->work, func, finish_ordered_fn, NULL,
> > > -			NULL);
> > > -	btrfs_queue_work(wq, &ordered_extent->work);
> > > +	btrfs_put_ordered_extent(ordered_extent);
> > > +
> > > +	start = ordered_end + 1;
> > > +
> > > +	if (start < end)
> > > +		goto loop;
> > 
> > > +out:
> > I saw this's put a BUG_ON(block_start == EXTENT_MAP_INLINE); in writepage(),
> > but I didn't see the code of disabling inline data in patch 01 and patch
> > 02, but anyway I think we can avoid above searching for ordered_extents in
> > a single page if we enable inline data.
> 
> For inline extents, The call to __extent_writepage => writepage_delalloc =>
> run_delalloc_range => cow_file_range => cow_file_range_inline should write the
> block's content into the appropriate location in the btree leaf. Hence
> __extent_writepage_io() should never get invoked for files with inline
> extents. The call to BUG_ON(block_start == EXTENT_MAP_INLINE) just makes this
> explicit and also helps in debugging.

Yes, that's right, thanks for the explanation..

> 
> Liu, However I am not sure if we could avoid looping across ordered
> extents in the above code. Could you please elaborate on that?

Given that a page may span two ordered extents(in cow_file_range(), a
ENOSPC can split contiguous range into two ordered extents),
the above loop can make sure we don't miss any of the two. 

Thanks,

-liubo

> 
> -- 
> chandan
> 
