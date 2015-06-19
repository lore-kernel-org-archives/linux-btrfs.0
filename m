Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:47006 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbbFSJpH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Jun 2015 05:45:07 -0400
Received: from /spool/local
	by e28smtp09.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Fri, 19 Jun 2015 15:15:05 +0530
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by d28dlp02.in.ibm.com (Postfix) with ESMTP id 4E4D43940053
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2015 15:15:03 +0530 (IST)
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay03.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t5J9j3KD63242242
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2015 15:15:03 +0530
Received: from d28av02.in.ibm.com (localhost [127.0.0.1])
	by d28av02.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t5J8iYnF025264
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2015 14:14:34 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: bo.li.liu@oracle.com
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com
Subject: Re: [RFC PATCH V11 01/21] Btrfs: subpagesize-blocksize: Fix whole page read.
Date: Fri, 19 Jun 2015 15:15:01 +0530
Message-ID: <2574653.62sO1fmDVj@localhost.localdomain>
In-Reply-To: <20150619044536.GA31508@localhost.localdomain>
References: <1433172176-8742-1-git-send-email-chandan@linux.vnet.ibm.com> <1433172176-8742-2-git-send-email-chandan@linux.vnet.ibm.com> <20150619044536.GA31508@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 19 Jun 2015 12:45:37 Liu Bo wrote:
> On Mon, Jun 01, 2015 at 08:52:36PM +0530, Chandan Rajendra wrote:
> > For the subpagesize-blocksize scenario, a page can contain multiple
> > blocks. In such cases, this patch handles reading data from files.
> > 
> > To track the status of individual blocks of a page, this patch makes use
> > of a bitmap pointed to by page->private.
> 
> Start going through the patchset, it's not easy though.
> 
> Several comments are following.

Thanks for the review comments Liu.

> > +static int modify_page_blks_state(struct page *page,
> > +				unsigned long blk_states,
> > +				u64 start, u64 end, int set)
> > +{
> > +	struct inode *inode = page->mapping->host;
> > +	unsigned long *bitmap;
> > +	unsigned long state;
> > +	u64 nr_blks;
> > +	u64 blk;
> > +
> > +	BUG_ON(!PagePrivate(page));
> > +
> > +	bitmap = ((struct btrfs_page_private *)page->private)->bstate;
> > +
> > +	blk = (start & (PAGE_CACHE_SIZE - 1)) >> inode->i_blkbits;
> > +	nr_blks = (end - start + 1) >> inode->i_blkbits;
> > +
> > +	while (nr_blks--) {
> > +		state = find_next_bit(&blk_states, BLK_NR_STATE, 0);
> 
> Looks like we don't need to do find_next_bit for every block.

Yes, I agree. The find_next_bit() invocation in the outer loop can be moved
outside the loop.
> 
> > +
> > +		while (state < BLK_NR_STATE) {
> > +			if (set)
> > +				set_bit((blk * BLK_NR_STATE) + state, bitmap);
> > +			else
> > +				clear_bit((blk * BLK_NR_STATE) + state, 
bitmap);
> > +
> > +			state = find_next_bit(&blk_states, BLK_NR_STATE,
> > +					state + 1);
> > +		}
> > +
> > +		++blk;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > 
> >  /*
> >  
> >   * after a readpage IO is done, we need to:
> >   * clear the uptodate bits on error
> > 
> > @@ -2548,14 +2628,16 @@ static void end_bio_extent_readpage(struct bio
> > *bio, int err)> 
> >  	struct bio_vec *bvec;
> >  	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
> >  	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
> > 
> > +	struct extent_state *cached = NULL;
> > +	struct btrfs_page_private *pg_private;
> > 
> >  	struct extent_io_tree *tree;
> > 
> > +	unsigned long flags;
> > 
> >  	u64 offset = 0;
> >  	u64 start;
> >  	u64 end;
> > 
> > -	u64 len;
> > -	u64 extent_start = 0;
> > -	u64 extent_len = 0;
> > +	int nr_sectors;
> > 
> >  	int mirror;
> > 
> > +	int unlock;
> > 
> >  	int ret;
> >  	int i;
> > 
> > @@ -2565,54 +2647,31 @@ static void end_bio_extent_readpage(struct bio
> > *bio, int err)> 
> >  	bio_for_each_segment_all(bvec, bio, i) {
> >  	
> >  		struct page *page = bvec->bv_page;
> >  		struct inode *inode = page->mapping->host;
> > 
> > +		struct btrfs_root *root = BTRFS_I(inode)->root;
> > 
> >  		pr_debug("end_bio_extent_readpage: bi_sector=%llu, err=%d, "
> >  		
> >  			 "mirror=%u\n", (u64)bio->bi_iter.bi_sector, err,
> >  			 io_bio->mirror_num);
> >  		
> >  		tree = &BTRFS_I(inode)->io_tree;
> > 
> > -		/* We always issue full-page reads, but if some block
> > -		 * in a page fails to read, blk_update_request() will
> > -		 * advance bv_offset and adjust bv_len to compensate.
> > -		 * Print a warning for nonzero offsets, and an error
> > -		 * if they don't add up to a full page.  */
> > -		if (bvec->bv_offset || bvec->bv_len != PAGE_CACHE_SIZE) {
> > -			if (bvec->bv_offset + bvec->bv_len != PAGE_CACHE_SIZE)
> > -				btrfs_err(BTRFS_I(page->mapping->host)->root-
>fs_info,
> > -				   "partial page read in btrfs with offset %u 
and length %u",
> > -					bvec->bv_offset, bvec->bv_len);
> > -			else
> > -				btrfs_info(BTRFS_I(page->mapping->host)->root-
>fs_info,
> > -				   "incomplete page read in btrfs with offset 
%u and "
> > -				   "length %u",
> > -					bvec->bv_offset, bvec->bv_len);
> > -		}
> > -
> > -		start = page_offset(page);
> > -		end = start + bvec->bv_offset + bvec->bv_len - 1;
> > -		len = bvec->bv_len;
> > -
> > +		start = page_offset(page) + bvec->bv_offset;
> > +		end = start + bvec->bv_len - 1;
> > +		nr_sectors = bvec->bv_len >> inode->i_sb->s_blocksize_bits;
> > 
> >  		mirror = io_bio->mirror_num;
> > 
> > -		if (likely(uptodate && tree->ops &&
> > -			   tree->ops->readpage_end_io_hook)) {
> > +
> > +next_block:
> > +		if (likely(uptodate)) {
> 
> Any reason of killing (tree->ops && tree->ops->readpage_end_io_hook)?

In subpagesize-blocksize scenario, For extent buffers we need the ability to
read just a single extent buffer rather than reading the complete contents of
the page containing the extent buffer. Similarly in the corresponding endio
function we need to verify a single extent buffer rather than the contents of
the full page.  Hence I ended up removing btree_readpage_end_io_hook() and
btree_io_failed_hook() functions and had verfication functions being
invoked directly by the endio function.

So since data "read page code" was the only one left to have
extent_io_tree->ops->readpage_end_io_hook set, I removed the code to check for
its existance. Now i realize that it is not the right thing to do. I will
restore back the condition check to its original state.

> 
> >  			ret = tree->ops->readpage_end_io_hook(io_bio, offset,
> > 
> > -							      page, start, 
end,
> > -							      mirror);
> > +							page, start,
> > +							start + root-
>sectorsize - 1,
> > +							mirror);
> > 
> >  			if (ret)
> >  			
> >  				uptodate = 0;
> >  			
> >  			else
> >  			
> >  				clean_io_failure(inode, start, page, 0);
> >  		
> >  		}
> > 
> > -		if (likely(uptodate))
> > -			goto readpage_ok;
> > -
> > -		if (tree->ops && tree->ops->readpage_io_failed_hook) {
> > -			ret = tree->ops->readpage_io_failed_hook(page, 
mirror);
> > -			if (!ret && !err &&
> > -			    test_bit(BIO_UPTODATE, &bio->bi_flags))
> > -				uptodate = 1;
> > -		} else {
> > +		if (!uptodate) {
> > 
> >  			/*
> >  			
> >  			 * The generic bio_readpage_error handles errors the
> >  			 * following way: If possible, new read requests are
> > 
> > @@ -2623,61 +2682,63 @@ static void end_bio_extent_readpage(struct bio
> > *bio, int err)> 
> >  			 * can't handle the error it will return -EIO and we
> >  			 * remain responsible for that page.
> >  			 */
> > 
> > -			ret = bio_readpage_error(bio, offset, page, start, 
end,
> > -						 mirror);
> > +			ret = bio_readpage_error(bio, offset, page,
> > +						start, start + root-
>sectorsize - 1,
> > +						mirror);
> > 
> >  			if (ret == 0) {
> > 
> > -				uptodate =
> > -					test_bit(BIO_UPTODATE, &bio-
>bi_flags);
> > +				uptodate = test_bit(BIO_UPTODATE, &bio-
>bi_flags);
> > 
> >  				if (err)
> >  				
> >  					uptodate = 0;
> > 
> > -				offset += len;
> > -				continue;
> > +				offset += root->sectorsize;
> > +				if (--nr_sectors) {
> > +					start += root->sectorsize;
> > +					goto next_block;
> > +				} else {
> > +					continue;
> > +				}
> > 
> >  			}
> >  		
> >  		}
> > 
> > -readpage_ok:
> > -		if (likely(uptodate)) {
> > -			loff_t i_size = i_size_read(inode);
> > -			pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
> > -			unsigned off;
> > -
> > -			/* Zero out the end if this page straddles i_size */
> > -			off = i_size & (PAGE_CACHE_SIZE-1);
> > -			if (page->index == end_index && off)
> > -				zero_user_segment(page, off, PAGE_CACHE_SIZE);
> > -			SetPageUptodate(page);
> > +
> > +		if (uptodate) {
> > +			set_page_blks_state(page, 1 << BLK_STATE_UPTODATE, 
start,
> > +					start + root->sectorsize - 1);
> > +			check_page_uptodate(page);
> > 
> >  		} else {
> >  		
> >  			ClearPageUptodate(page);
> >  			SetPageError(page);
> >  		
> >  		}
> > 
> > -		unlock_page(page);
> > -		offset += len;
> > -
> > -		if (unlikely(!uptodate)) {
> > -			if (extent_len) {
> > -				endio_readpage_release_extent(tree,
> > -							      extent_start,
> > -							      extent_len, 1);
> > -				extent_start = 0;
> > -				extent_len = 0;
> > -			}
> > -			endio_readpage_release_extent(tree, start,
> > -						      end - start + 1, 0);
> > -		} else if (!extent_len) {
> > -			extent_start = start;
> > -			extent_len = end + 1 - start;
> > -		} else if (extent_start + extent_len == start) {
> > -			extent_len += end + 1 - start;
> > -		} else {
> > -			endio_readpage_release_extent(tree, extent_start,
> > -						      extent_len, uptodate);
> > -			extent_start = start;
> > -			extent_len = end + 1 - start;
> > +
> > +		offset += root->sectorsize;
> > +
> > +		if (--nr_sectors) {
> > +			clear_page_blks_state(page, 1 << BLK_STATE_IO,
> > +					start, start + root->sectorsize - 1);
> 
> private->io_lock is not acquired here but not in below.
> 
> IIUC, this can be protected by EXTENT_LOCKED.
>

private->io_lock plays the same role as BH_Uptodate_Lock (see
end_buffer_async_read()) i.e. without the io_lock we may end up in the
following situation,

NOTE: Assume 64k page size and 4k block size. Also assume that the first 12
blocks of the page are contiguous while the next 4 blocks are contiguous. When
reading the page we end up submitting two "logical address space" bios. So
end_bio_extent_readpage function is invoked twice (once for each bio).

|-------------------------+-------------------------+-------------|
| Task A                  | Task B                  | Task C      |
|-------------------------+-------------------------+-------------|
| end_bio_extent_readpage |                         |             |
| process block 0         |                         |             |
| - clear BLK_STATE_IO    |                         |             |
| - page_read_complete    |                         |             |
| process block 1         |                         |             |
| ...                     |                         |             |
| ...                     |                         |             |
| ...                     | end_bio_extent_readpage |             |
| ...                     | process block 0         |             |
| ...                     | - clear BLK_STATE_IO    |             |
| ...                     | - page_read_complete    |             |
| ...                     | process block 1         |             |
| ...                     | ...                     |             |
| process block 11        | process block 3         |             |
| - clear BLK_STATE_IO    | - clear BLK_STATE_IO    |             |
| - page_read_complete    | - page_read_complete    |             |
|   - returns true        |   - returns true        |             |
|   - unlock_page()       |                         |             |
|                         |                         | lock_page() |
|                         |   - unlock_page()       |             |
|-------------------------+-------------------------+-------------|

So we end up incorrectly unlocking the page twice and "Task C" ends up working
on an unlocked page. So private->io_lock makes sure that only one of the tasks
gets "true" as the return value when page_read_complete() is invoked. As an
optimization the patch gets the io_lock only when nr_sectors counter reaches
the value 0 (i.e. when the last block of the bio_vec is being processed).
Please let me know if my analysis was incorrect.

Also, I noticed that page_read_complete() and page_write_complete() can be
replaced by just one function i.e. page_io_complete().


-- 
chandan

