Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1709 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754857AbcGZRSq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jul 2016 13:18:46 -0400
Subject: Re: [PATCH V20 02/19] Btrfs: subpage-blocksize: Fix whole page write
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>, <clm@fb.com>,
        <dsterba@suse.com>
References: <1467606879-14181-1-git-send-email-chandan@linux.vnet.ibm.com>
 <1467606879-14181-3-git-send-email-chandan@linux.vnet.ibm.com>
CC: <linux-btrfs@vger.kernel.org>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <e905813f-4995-e82b-57ab-30a70c01764b@fb.com>
Date: Tue, 26 Jul 2016 13:18:30 -0400
MIME-Version: 1.0
In-Reply-To: <1467606879-14181-3-git-send-email-chandan@linux.vnet.ibm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/04/2016 12:34 AM, Chandan Rajendra wrote:
> For the subpage-blocksize scenario, a page can contain multiple
> blocks. In such cases, this patch handles writing data to files.
>
> Also, When setting EXTENT_DELALLOC, we no longer set EXTENT_UPTODATE bit on
> the extent_io_tree since uptodate status is being tracked by the bitmap
> pointed to by page->private.
>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
>  fs/btrfs/extent_io.c  | 150 ++++++++++++++++++++++++--------------------------
>  fs/btrfs/file.c       |  17 ++++++
>  fs/btrfs/inode.c      |  75 +++++++++++++++++++++----
>  fs/btrfs/relocation.c |   3 +
>  4 files changed, 155 insertions(+), 90 deletions(-)
>
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index a349f99..0adbff5 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -1494,24 +1494,6 @@ void extent_range_redirty_for_io(struct inode *inode, u64 start, u64 end)
>  	}
>  }
>
> -/*
> - * helper function to set both pages and extents in the tree writeback
> - */
> -static void set_range_writeback(struct extent_io_tree *tree, u64 start, u64 end)
> -{
> -	unsigned long index = start >> PAGE_SHIFT;
> -	unsigned long end_index = end >> PAGE_SHIFT;
> -	struct page *page;
> -
> -	while (index <= end_index) {
> -		page = find_get_page(tree->mapping, index);
> -		BUG_ON(!page); /* Pages should be in the extent_io_tree */
> -		set_page_writeback(page);
> -		put_page(page);
> -		index++;
> -	}
> -}
> -
>  /* find the first state struct with 'bits' set after 'start', and
>   * return it.  tree->lock must be held.  NULL will returned if
>   * nothing was found after 'start'
> @@ -2585,36 +2567,41 @@ void end_extent_writepage(struct page *page, int err, u64 start, u64 end)
>   */
>  static void end_bio_extent_writepage(struct bio *bio)
>  {
> +	struct btrfs_page_private *pg_private;
>  	struct bio_vec *bvec;
> +	unsigned long flags;
>  	u64 start;
>  	u64 end;
> +	int clear_writeback;
>  	int i;
>
>  	bio_for_each_segment_all(bvec, bio, i) {
>  		struct page *page = bvec->bv_page;
> +		struct btrfs_root *root = BTRFS_I(page->mapping->host)->root;
>
> -		/* We always issue full-page reads, but if some block
> -		 * in a page fails to read, blk_update_request() will
> -		 * advance bv_offset and adjust bv_len to compensate.
> -		 * Print a warning for nonzero offsets, and an error
> -		 * if they don't add up to a full page.  */
> -		if (bvec->bv_offset || bvec->bv_len != PAGE_SIZE) {
> -			if (bvec->bv_offset + bvec->bv_len != PAGE_SIZE)
> -				btrfs_err(BTRFS_I(page->mapping->host)->root->fs_info,
> -				   "partial page write in btrfs with offset %u and length %u",
> -					bvec->bv_offset, bvec->bv_len);
> -			else
> -				btrfs_info(BTRFS_I(page->mapping->host)->root->fs_info,
> -				   "incomplete page write in btrfs with offset %u and "
> -				   "length %u",
> -					bvec->bv_offset, bvec->bv_len);
> -		}
> +		pg_private = NULL;
> +		flags = 0;
> +		clear_writeback = 1;
>
> -		start = page_offset(page);
> -		end = start + bvec->bv_offset + bvec->bv_len - 1;
> +		start = page_offset(page) + bvec->bv_offset;
> +		end = start + bvec->bv_len - 1;
> +
> +		if (root->sectorsize < PAGE_SIZE) {
> +			pg_private = (struct btrfs_page_private *)page->private;
> +			spin_lock_irqsave(&pg_private->io_lock, flags);
> +		}
>
>  		end_extent_writepage(page, bio->bi_error, start, end);
> -		end_page_writeback(page);
> +
> +		if (root->sectorsize < PAGE_SIZE) {
> +			clear_page_blks_state(page, 1 << BLK_STATE_IO, start,
> +					end);
> +			clear_writeback = page_io_complete(page);
> +			spin_unlock_irqrestore(&pg_private->io_lock, flags);
> +		}
> +
> +		if (clear_writeback)
> +			end_page_writeback(page);
>  	}
>
>  	bio_put(bio);
> @@ -3486,7 +3473,6 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
>  	u64 block_start;
>  	u64 iosize;
>  	sector_t sector;
> -	struct extent_state *cached_state = NULL;
>  	struct extent_map *em;
>  	struct block_device *bdev;
>  	size_t pg_offset = 0;
> @@ -3538,20 +3524,29 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
>  							 page_end, NULL, 1);
>  			break;
>  		}
> -		em = epd->get_extent(inode, page, pg_offset, cur,
> -				     end - cur + 1, 1);
> +
> +		if (blocksize < PAGE_SIZE
> +			&& !test_page_blks_state(page, BLK_STATE_DIRTY, cur,
> +						cur + blocksize - 1, 1)) {
> +			cur += blocksize;
> +			continue;
> +		}
> +
> +		pg_offset = cur & (PAGE_SIZE - 1);
> +
> +		em = epd->get_extent(inode, page, pg_offset, cur, blocksize, 1);
>  		if (IS_ERR_OR_NULL(em)) {
>  			SetPageError(page);
>  			ret = PTR_ERR_OR_ZERO(em);
>  			break;
>  		}
>
> -		extent_offset = cur - em->start;
>  		em_end = extent_map_end(em);
>  		BUG_ON(em_end <= cur);
>  		BUG_ON(end < cur);
> -		iosize = min(em_end - cur, end - cur + 1);
> -		iosize = ALIGN(iosize, blocksize);
> +
> +		iosize = blocksize;
> +		extent_offset = cur - em->start;
>  		sector = (em->block_start + extent_offset) >> 9;
>  		bdev = em->bdev;
>  		block_start = em->block_start;
> @@ -3559,65 +3554,64 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
>  		free_extent_map(em);
>  		em = NULL;
>
> -		/*
> -		 * compressed and inline extents are written through other
> -		 * paths in the FS
> -		 */
> -		if (compressed || block_start == EXTENT_MAP_HOLE ||
> -		    block_start == EXTENT_MAP_INLINE) {
> -			/*
> -			 * end_io notification does not happen here for
> -			 * compressed extents
> -			 */
> -			if (!compressed && tree->ops &&
> -			    tree->ops->writepage_end_io_hook)
> -				tree->ops->writepage_end_io_hook(page, cur,
> -							 cur + iosize - 1,
> -							 NULL, 1);
> -			else if (compressed) {
> -				/* we don't want to end_page_writeback on
> -				 * a compressed extent.  this happens
> -				 * elsewhere
> -				 */
> -				nr++;
> -			}
> +		ASSERT(!compressed);
> +		ASSERT(block_start != EXTENT_MAP_INLINE);
>
> +		if (block_start == EXTENT_MAP_HOLE) {
> +			if (blocksize < PAGE_SIZE) {
> +				if (test_page_blks_state(page, BLK_STATE_UPTODATE,
> +								cur, cur + iosize - 1,
> +								1)) {
> +					clear_page_blks_state(page,
> +							1 << BLK_STATE_DIRTY, cur,
> +							cur + iosize - 1);
> +				} else {
> +					BUG();
> +				}
> +			} else if (!PageUptodate(page)) {
> +					BUG();
> +			}

No new BUG()'s.  If we think its actually a possibility then return an error, 
otherwise use ASSERT.

>  			cur += iosize;
> -			pg_offset += iosize;
>  			continue;
>  		}
>
>  		max_nr = (i_size >> PAGE_SHIFT) + 1;
>
> -		set_range_writeback(tree, cur, cur + iosize - 1);
> +		if (blocksize < PAGE_SIZE)
> +			clear_page_blks_state(page,
> +					1 << BLK_STATE_DIRTY, cur,
> +					cur + iosize - 1);
> +		set_page_writeback(page);
> +
> +		if (blocksize < PAGE_SIZE)
> +			set_page_blks_state(page, 1 << BLK_STATE_IO,
> +					cur, cur + iosize - 1);
> +
>  		if (!PageWriteback(page)) {
>  			btrfs_err(BTRFS_I(inode)->root->fs_info,
> -				   "page %lu not writeback, cur %llu end %llu",
> -			       page->index, cur, end);
> +				"page %lu not writeback, cur %llu end %llu",
> +				page->index, cur, end);
>  		}
>
>  		ret = submit_extent_page(write_flags, tree, wbc, page,
> -					 sector, iosize, pg_offset,
> -					 bdev, &epd->bio, max_nr,
> -					 end_bio_extent_writepage,
> -					 0, 0, 0, false);
> +					sector, iosize, pg_offset,
> +					bdev, &epd->bio, max_nr,
> +					end_bio_extent_writepage,
> +					0, 0, 0, false);

Whitespace change?

>  		if (ret)
>  			SetPageError(page);
>
> -		cur = cur + iosize;
> -		pg_offset += iosize;
> +		cur += iosize;
>  		nr++;
>  	}
>  done:
>  	*nr_ret = nr;
>
>  done_unlocked:
> -
> -	/* drop our reference on any cached states */
> -	free_extent_state(cached_state);
>  	return ret;
>  }
>
> +

Random whitespace.  Also for the whole series I'd like to see us do away with 
the if (sectorsize < PAGE_SIZE) everywhere and just push that down into the 
helpers.  Thanks,

Josef
