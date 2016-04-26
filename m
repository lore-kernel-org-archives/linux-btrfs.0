Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54016 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751757AbcDZPvo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 11:51:44 -0400
Subject: Re: [PATCH V18 01/18] Btrfs: subpage-blocksize: Fix whole page read.
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        <linux-btrfs@vger.kernel.org>
References: <1461677237-7703-1-git-send-email-chandan@linux.vnet.ibm.com>
 <1461677237-7703-2-git-send-email-chandan@linux.vnet.ibm.com>
CC: <dsterba@suse.cz>, <clm@fb.com>, <chandan@mykolab.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <63a690f0-20c4-f816-d9ff-0550306a97a1@fb.com>
Date: Tue, 26 Apr 2016 11:51:22 -0400
MIME-Version: 1.0
In-Reply-To: <1461677237-7703-2-git-send-email-chandan@linux.vnet.ibm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/26/2016 09:27 AM, Chandan Rajendra wrote:
> For the subpage-blocksize scenario, a page can contain multiple
> blocks. In such cases, this patch handles reading data from files.
>
> To track the status of individual blocks of a page, this patch makes use
> of a bitmap pointed to by the newly introduced per-page 'struct
> btrfs_page_private'.
>
> The per-page btrfs_page_private->io_lock plays the same role as
> BH_Uptodate_Lock (see end_buffer_async_read()) i.e. without the io_lock
> we may end up in the following situation,
>
> NOTE: Assume 64k page size and 4k block size. Also assume that the first
> 12 blocks of the page are contiguous while the next 4 blocks are
> contiguous. When reading the page we end up submitting two "logical
> address space" bios. So end_bio_extent_readpage function is invoked
> twice, once for each bio.
>
> |-------------------------+-------------------------+-------------|
> | Task A                  | Task B                  | Task C      |
> |-------------------------+-------------------------+-------------|
> | end_bio_extent_readpage |                         |             |
> | process block 0         |                         |             |
> | - clear BLK_STATE_IO    |                         |             |
> | - page_read_complete    |                         |             |
> | process block 1         |                         |             |
> |                         |                         |             |
> |                         |                         |             |
> |                         | end_bio_extent_readpage |             |
> |                         | process block 0         |             |
> |                         | - clear BLK_STATE_IO    |             |
> |                         | - page_read_complete    |             |
> |                         | process block 1         |             |
> |                         |                         |             |
> | process block 11        | process block 3         |             |
> | - clear BLK_STATE_IO    | - clear BLK_STATE_IO    |             |
> | - page_read_complete    | - page_read_complete    |             |
> |   - returns true        |   - returns true        |             |
> |   - unlock_page()       |                         |             |
> |                         |                         | lock_page() |
> |                         |   - unlock_page()       |             |
> |-------------------------+-------------------------+-------------|
>
> We end up incorrectly unlocking the page twice and "Task C" ends up
> working on an unlocked page. So private->io_lock makes sure that only
> one of the tasks gets "true" as the return value when page_io_complete()
> is invoked. As an optimization the patch gets the io_lock only when the
> last block of the bio_vec is being processed.
>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
>  fs/btrfs/extent_io.c | 321 +++++++++++++++++++++++++++++++++------------------
>  fs/btrfs/extent_io.h |  71 +++++++++++-
>  fs/btrfs/inode.c     |  13 +--
>  3 files changed, 280 insertions(+), 125 deletions(-)
>
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index d247fc0..1a9ce2c 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -1321,6 +1321,95 @@ int clear_record_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
>  				  changeset);
>  }
>
> +static int modify_page_blks_state(struct page *page,
> +				unsigned long blk_states,
> +				u64 start, u64 end, int set)
> +{
> +	struct inode *inode = page->mapping->host;
> +	unsigned long *bitmap;
> +	unsigned long first_state;
> +	unsigned long state;
> +	u64 nr_blks;
> +	u64 blk;
> +
> +	BUG_ON(!PagePrivate(page));

Let's use ASSERT() instead of BUG_ON().

> +
> +	bitmap = ((struct btrfs_page_private *)page->private)->bstate;
> +
> +	blk = BTRFS_BYTES_TO_BLKS(BTRFS_I(inode)->root->fs_info,
> +				start & (PAGE_SIZE - 1));
> +	nr_blks = BTRFS_BYTES_TO_BLKS(BTRFS_I(inode)->root->fs_info,
> +				(end - start + 1));
> +
> +	first_state = find_next_bit(&blk_states, BLK_NR_STATE, 0);
> +
> +	while (nr_blks--) {
> +		state = first_state;
> +
> +		while (state < BLK_NR_STATE) {
> +			if (set)
> +				set_bit((blk * BLK_NR_STATE) + state, bitmap);
> +			else
> +				clear_bit((blk * BLK_NR_STATE) + state, bitmap);
> +
> +			state = find_next_bit(&blk_states, BLK_NR_STATE,
> +					state + 1);
> +		}
> +
> +		++blk;
> +	}
> +
> +	return 0;
> +}
> +
> +int set_page_blks_state(struct page *page, unsigned long blk_states,
> +			u64 start, u64 end)
> +{
> +	return modify_page_blks_state(page, blk_states, start, end, 1);
> +}
> +
> +int clear_page_blks_state(struct page *page, unsigned long blk_states,
> +			u64 start, u64 end)
> +{
> +	return modify_page_blks_state(page, blk_states, start, end, 0);
> +}
> +
> +int test_page_blks_state(struct page *page, enum blk_state blk_state,
> +			u64 start, u64 end, int check_all)
> +{
> +	struct inode *inode = page->mapping->host;
> +	unsigned long *bitmap;
> +	unsigned long blk;
> +	u64 nr_blks;
> +	int found = 0;
> +
> +	BUG_ON(!PagePrivate(page));
> +
> +	bitmap = ((struct btrfs_page_private *)page->private)->bstate;
> +
> +	blk = BTRFS_BYTES_TO_BLKS(BTRFS_I(inode)->root->fs_info,
> +				start & (PAGE_SIZE - 1));
> +	nr_blks = BTRFS_BYTES_TO_BLKS(BTRFS_I(inode)->root->fs_info,
> +				(end - start + 1));
> +
> +	while (nr_blks--) {
> +		if (test_bit((blk * BLK_NR_STATE) + blk_state, bitmap)) {
> +			if (!check_all)
> +				return 1;
> +			found = 1;
> +		} else if (check_all) {
> +			return 0;
> +		}
> +
> +		++blk;
> +	}
> +
> +	if (!check_all && !found)
> +		return 0;
> +
> +	return 1;
> +}
> +
>  /*
>   * either insert or lock state struct between start and end use mask to tell
>   * us if waiting is desired.
> @@ -1958,14 +2047,22 @@ int test_range_bit(struct extent_io_tree *tree, u64 start, u64 end,
>   * helper function to set a given page up to date if all the
>   * extents in the tree for that page are up to date
>   */
> -static void check_page_uptodate(struct extent_io_tree *tree, struct page *page)
> +static void check_page_uptodate(struct page *page)
>  {
>  	u64 start = page_offset(page);
>  	u64 end = start + PAGE_SIZE - 1;
> -	if (test_range_bit(tree, start, end, EXTENT_UPTODATE, 1, NULL))
> +	if (test_page_blks_state(page, BLK_STATE_UPTODATE, start, end, 1))
>  		SetPageUptodate(page);
>  }
>
> +static int page_io_complete(struct page *page)
> +{
> +	u64 start = page_offset(page);
> +	u64 end = start + PAGE_SIZE - 1;
> +
> +	return !test_page_blks_state(page, BLK_STATE_IO, start, end, 0);
> +}
> +
>  int free_io_failure(struct inode *inode, struct io_failure_record *rec)
>  {
>  	int ret;
> @@ -2282,7 +2379,9 @@ int btrfs_check_repairable(struct inode *inode, struct bio *failed_bio,
>  	 *	a) deliver good data to the caller
>  	 *	b) correct the bad sectors on disk
>  	 */
> -	if (failed_bio->bi_vcnt > 1) {
> +	if ((failed_bio->bi_vcnt > 1)
> +		|| (failed_bio->bi_io_vec->bv_len
> +			> BTRFS_I(inode)->root->sectorsize)) {
>  		/*
>  		 * to fulfill b), we need to know the exact failing sectors, as
>  		 * we don't want to rewrite any more than the failed ones. thus,
> @@ -2488,18 +2587,6 @@ static void end_bio_extent_writepage(struct bio *bio)
>  	bio_put(bio);
>  }
>
> -static void
> -endio_readpage_release_extent(struct extent_io_tree *tree, u64 start, u64 len,
> -			      int uptodate)
> -{
> -	struct extent_state *cached = NULL;
> -	u64 end = start + len - 1;
> -
> -	if (uptodate && tree->track_uptodate)
> -		set_extent_uptodate(tree, start, end, &cached, GFP_ATOMIC);
> -	unlock_extent_cached(tree, start, end, &cached, GFP_ATOMIC);
> -}
> -
>  /*
>   * after a readpage IO is done, we need to:
>   * clear the uptodate bits on error
> @@ -2516,67 +2603,50 @@ static void end_bio_extent_readpage(struct bio *bio)
>  	struct bio_vec *bvec;
>  	int uptodate = !bio->bi_error;
>  	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
> +	struct extent_state *cached = NULL;
> +	struct btrfs_page_private *pg_private;
>  	struct extent_io_tree *tree;
> +	unsigned long flags;
>  	u64 offset = 0;
>  	u64 start;
>  	u64 end;
> -	u64 len;
> -	u64 extent_start = 0;
> -	u64 extent_len = 0;
> +	int nr_sectors;
>  	int mirror;
> +	int unlock;
>  	int ret;
>  	int i;
>
>  	bio_for_each_segment_all(bvec, bio, i) {
>  		struct page *page = bvec->bv_page;
>  		struct inode *inode = page->mapping->host;
> +		struct btrfs_root *root = BTRFS_I(inode)->root;
>
>  		pr_debug("end_bio_extent_readpage: bi_sector=%llu, err=%d, "
>  			 "mirror=%u\n", (u64)bio->bi_iter.bi_sector,
>  			 bio->bi_error, io_bio->mirror_num);
>  		tree = &BTRFS_I(inode)->io_tree;
>
> -		/* We always issue full-page reads, but if some block
> -		 * in a page fails to read, blk_update_request() will
> -		 * advance bv_offset and adjust bv_len to compensate.
> -		 * Print a warning for nonzero offsets, and an error
> -		 * if they don't add up to a full page.  */
> -		if (bvec->bv_offset || bvec->bv_len != PAGE_SIZE) {
> -			if (bvec->bv_offset + bvec->bv_len != PAGE_SIZE)
> -				btrfs_err(BTRFS_I(page->mapping->host)->root->fs_info,
> -				   "partial page read in btrfs with offset %u and length %u",
> -					bvec->bv_offset, bvec->bv_len);
> -			else
> -				btrfs_info(BTRFS_I(page->mapping->host)->root->fs_info,
> -				   "incomplete page read in btrfs with offset %u and "
> -				   "length %u",
> -					bvec->bv_offset, bvec->bv_len);
> -		}
> -
> -		start = page_offset(page);
> -		end = start + bvec->bv_offset + bvec->bv_len - 1;
> -		len = bvec->bv_len;
> -
> +		start = page_offset(page) + bvec->bv_offset;
> +		end = start + bvec->bv_len - 1;
> +		nr_sectors = BTRFS_BYTES_TO_BLKS(root->fs_info,
> +						bvec->bv_len);
>  		mirror = io_bio->mirror_num;
> +
> +next_block:
>  		if (likely(uptodate && tree->ops &&
> -			   tree->ops->readpage_end_io_hook)) {
> +				tree->ops->readpage_end_io_hook)) {

Looks like a whitespace screwup.

>  			ret = tree->ops->readpage_end_io_hook(io_bio, offset,
> -							      page, start, end,
> -							      mirror);
> +							page, start,
> +							start + root->sectorsize - 1,
> +							mirror);
>  			if (ret)
>  				uptodate = 0;
>  			else
> -				clean_io_failure(inode, start, page, 0);
> +				clean_io_failure(inode, start, page,
> +						start - page_offset(page));
>  		}
>
> -		if (likely(uptodate))
> -			goto readpage_ok;
> -
> -		if (tree->ops && tree->ops->readpage_io_failed_hook) {
> -			ret = tree->ops->readpage_io_failed_hook(page, mirror);
> -			if (!ret && !bio->bi_error)
> -				uptodate = 1;
> -		} else {
> +		if (!uptodate) {
>  			/*
>  			 * The generic bio_readpage_error handles errors the
>  			 * following way: If possible, new read requests are
> @@ -2587,58 +2657,61 @@ static void end_bio_extent_readpage(struct bio *bio)
>  			 * can't handle the error it will return -EIO and we
>  			 * remain responsible for that page.
>  			 */
> -			ret = bio_readpage_error(bio, offset, page, start, end,
> -						 mirror);
> +			ret = bio_readpage_error(bio, offset, page,
> +						start, start + root->sectorsize - 1,
> +						mirror);
>  			if (ret == 0) {
>  				uptodate = !bio->bi_error;
> -				offset += len;
> -				continue;
> +				offset += root->sectorsize;
> +				if (--nr_sectors) {
> +					start += root->sectorsize;
> +					goto next_block;
> +				} else {
> +					continue;
> +				}
>  			}
>  		}
> -readpage_ok:
> -		if (likely(uptodate)) {
> -			loff_t i_size = i_size_read(inode);
> -			pgoff_t end_index = i_size >> PAGE_SHIFT;
> -			unsigned off;
> -
> -			/* Zero out the end if this page straddles i_size */
> -			off = i_size & (PAGE_SIZE-1);
> -			if (page->index == end_index && off)
> -				zero_user_segment(page, off, PAGE_SIZE);
> -			SetPageUptodate(page);
> +
> +		if (uptodate) {
> +			set_page_blks_state(page, 1 << BLK_STATE_UPTODATE, start,
> +					start + root->sectorsize - 1);
> +			check_page_uptodate(page);
>  		} else {
>  			ClearPageUptodate(page);
>  			SetPageError(page);
>  		}
> -		unlock_page(page);
> -		offset += len;
> -
> -		if (unlikely(!uptodate)) {
> -			if (extent_len) {
> -				endio_readpage_release_extent(tree,
> -							      extent_start,
> -							      extent_len, 1);
> -				extent_start = 0;
> -				extent_len = 0;
> -			}
> -			endio_readpage_release_extent(tree, start,
> -						      end - start + 1, 0);
> -		} else if (!extent_len) {
> -			extent_start = start;
> -			extent_len = end + 1 - start;
> -		} else if (extent_start + extent_len == start) {
> -			extent_len += end + 1 - start;
> -		} else {
> -			endio_readpage_release_extent(tree, extent_start,
> -						      extent_len, uptodate);
> -			extent_start = start;
> -			extent_len = end + 1 - start;
> +
> +		offset += root->sectorsize;
> +
> +		if (--nr_sectors) {
> +			clear_page_blks_state(page, 1 << BLK_STATE_IO,
> +					start, start + root->sectorsize - 1);
> +			clear_extent_bit(tree, start, start + root->sectorsize - 1,
> +					EXTENT_LOCKED, 1, 0, &cached, GFP_ATOMIC);
> +			start += root->sectorsize;
> +			goto next_block;
>  		}
> +
> +		WARN_ON(!PagePrivate(page));
> +
> +		pg_private = (struct btrfs_page_private *)page->private;
> +
> +		spin_lock_irqsave(&pg_private->io_lock, flags);
> +
> +		clear_page_blks_state(page, 1 << BLK_STATE_IO,
> +				start, start + root->sectorsize - 1);
> +
> +		unlock = page_io_complete(page);
> +
> +		spin_unlock_irqrestore(&pg_private->io_lock, flags);
> +
> +		clear_extent_bit(tree, start, start + root->sectorsize - 1,
> +				EXTENT_LOCKED, 1, 0, &cached, GFP_ATOMIC);
> +
> +		if (unlock)
> +			unlock_page(page);
>  	}
>
> -	if (extent_len)
> -		endio_readpage_release_extent(tree, extent_start, extent_len,
> -					      uptodate);
>  	if (io_bio->end_io)
>  		io_bio->end_io(io_bio, bio->bi_error);
>  	bio_put(bio);
> @@ -2828,13 +2901,36 @@ static void attach_extent_buffer_page(struct extent_buffer *eb,
>  	}
>  }
>
> -void set_page_extent_mapped(struct page *page)
> +int set_page_extent_mapped(struct page *page)
>  {
> +	struct btrfs_page_private *pg_private;
> +
>  	if (!PagePrivate(page)) {
> +		pg_private = kzalloc(sizeof(*pg_private), GFP_NOFS);
> +		if (!pg_private)
> +			return -ENOMEM;

So I would like to avoid the per-page allocation in the case that 
sectorsize == pagesize.  Also this is going to be pretty heavily used, 
so a separate slab should be used.

In fact, couldn't we just use the extent io tree to deal with this?  It 
would be kind of heavy handed to have to look up in the io tree for 
every sub page range I suppose, but we could probably avoid doing it in 
most cases and only in the case that we know we're only doing the sub 
page IO.  Thanks,

Josef
