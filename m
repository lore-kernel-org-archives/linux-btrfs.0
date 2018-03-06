Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:40192 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933126AbeCFTZB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Mar 2018 14:25:01 -0500
Date: Tue, 6 Mar 2018 11:22:21 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: scrub: batch rebuild for raid56
Message-ID: <20180306182220.GM30920@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Reply-To: bo.li.liu@oracle.com
References: <20180302231041.10442-1-bo.li.liu@oracle.com>
 <20180306104747.GM5942@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180306104747.GM5942@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 06, 2018 at 11:47:47AM +0100, David Sterba wrote:
> On Fri, Mar 02, 2018 at 04:10:37PM -0700, Liu Bo wrote:
> > In case of raid56, writes and rebuilds always take BTRFS_STRIPE_LEN(64K)
> > as unit, however, scrub_extent() sets blocksize as unit, so rebuild
> > process may be triggered on every block on a same stripe.
> > 
> > A typical example would be that when we're replacing a disappeared disk,
> > all reads on the disks get -EIO, every block (size is 4K if blocksize is
> > 4K) would go thru these,
> > 
> > scrub_handle_errored_block
> >   scrub_recheck_block # re-read pages one by one
> >   scrub_recheck_block # rebuild by calling raid56_parity_recover()
> >                         page by page
> > 
> > Although with raid56 stripe cache most of reads during rebuild can be
> > avoided, the parity recover calculation(xor or raid6 algorithms) needs to
> > be done $(BTRFS_STRIPE_LEN / blocksize) times.
> > 
> > This makes it less stupid by doing raid56 scrub/replace on stripe length.
> 
> missing s-o-b
>

I'm surprised that checkpatch.pl didn't complain.

> > ---
> >  fs/btrfs/scrub.c | 78 +++++++++++++++++++++++++++++++++++++++++++-------------
> >  1 file changed, 60 insertions(+), 18 deletions(-)
> > 
> > diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> > index 9882513..e3203a1 100644
> > --- a/fs/btrfs/scrub.c
> > +++ b/fs/btrfs/scrub.c
> > @@ -1718,6 +1718,44 @@ static int scrub_submit_raid56_bio_wait(struct btrfs_fs_info *fs_info,
> >  	return blk_status_to_errno(bio->bi_status);
> >  }
> >  
> > +static void scrub_recheck_block_on_raid56(struct btrfs_fs_info *fs_info,
> > +					  struct scrub_block *sblock)
> > +{
> > +	struct scrub_page *first_page = sblock->pagev[0];
> > +	struct bio *bio = btrfs_io_bio_alloc(BIO_MAX_PAGES);
> 
> nontrivial initializations (variable to variable) are better put into
> the statement section.
>

OK.

> > +	int page_num;
> > +
> > +	/* All pages in sblock belongs to the same stripe on the same device. */
> > +	ASSERT(first_page->dev);
> > +	if (first_page->dev->bdev == NULL)
> > +		goto out;
> > +
> > +	bio_set_dev(bio, first_page->dev->bdev);
> > +
> > +	for (page_num = 0; page_num < sblock->page_count; page_num++) {
> > +		struct scrub_page *page = sblock->pagev[page_num];
> > +
> > +		WARN_ON(!page->page);
> > +		bio_add_page(bio, page->page, PAGE_SIZE, 0);
> > +	}
> > +
> > +	if (scrub_submit_raid56_bio_wait(fs_info, bio, first_page)) {
> > +		bio_put(bio);
> > +		goto out;
> > +	}
> > +
> > +	bio_put(bio);
> > +
> > +	scrub_recheck_block_checksum(sblock);
> > +
> > +	return;
> > +out:
> > +	for (page_num = 0; page_num < sblock->page_count; page_num++)
> > +		sblock->pagev[page_num]->io_error = 1;
> > +
> > +	sblock->no_io_error_seen = 0;
> > +}
> > +
> >  /*
> >   * this function will check the on disk data for checksum errors, header
> >   * errors and read I/O errors. If any I/O errors happen, the exact pages
> > @@ -1733,6 +1771,10 @@ static void scrub_recheck_block(struct btrfs_fs_info *fs_info,
> >  
> >  	sblock->no_io_error_seen = 1;
> >  
> > +	/* short cut for raid56 */
> > +	if (!retry_failed_mirror && scrub_is_page_on_raid56(sblock->pagev[0]))
> > +		return scrub_recheck_block_on_raid56(fs_info, sblock);
> > +
> >  	for (page_num = 0; page_num < sblock->page_count; page_num++) {
> >  		struct bio *bio;
> >  		struct scrub_page *page = sblock->pagev[page_num];
> > @@ -1748,19 +1790,12 @@ static void scrub_recheck_block(struct btrfs_fs_info *fs_info,
> >  		bio_set_dev(bio, page->dev->bdev);
> >  
> >  		bio_add_page(bio, page->page, PAGE_SIZE, 0);
> > -		if (!retry_failed_mirror && scrub_is_page_on_raid56(page)) {
> > -			if (scrub_submit_raid56_bio_wait(fs_info, bio, page)) {
> > -				page->io_error = 1;
> > -				sblock->no_io_error_seen = 0;
> > -			}
> > -		} else {
> > -			bio->bi_iter.bi_sector = page->physical >> 9;
> > -			bio_set_op_attrs(bio, REQ_OP_READ, 0);
> > +		bio->bi_iter.bi_sector = page->physical >> 9;
> > +		bio_set_op_attrs(bio, REQ_OP_READ, 0);
> 
> https://elixir.bootlin.com/linux/latest/source/include/linux/blk_types.h#L270
> 
> bio_set_op_attrs should not be used

OK.

Thanks,

-liubo
> 
> >  
> > -			if (btrfsic_submit_bio_wait(bio)) {
> > -				page->io_error = 1;
> > -				sblock->no_io_error_seen = 0;
> > -			}
> > +		if (btrfsic_submit_bio_wait(bio)) {
> > +			page->io_error = 1;
> > +			sblock->no_io_error_seen = 0;
> >  		}
> >  
> >  		bio_put(bio);
> > @@ -2728,7 +2763,8 @@ static int scrub_find_csum(struct scrub_ctx *sctx, u64 logical, u8 *csum)
> >  }
> >  
> >  /* scrub extent tries to collect up to 64 kB for each bio */
> > -static int scrub_extent(struct scrub_ctx *sctx, u64 logical, u64 len,
> > +static int scrub_extent(struct scrub_ctx *sctx, struct map_lookup *map,
> > +			u64 logical, u64 len,
> >  			u64 physical, struct btrfs_device *dev, u64 flags,
> >  			u64 gen, int mirror_num, u64 physical_for_dev_replace)
> >  {
> > @@ -2737,13 +2773,19 @@ static int scrub_extent(struct scrub_ctx *sctx, u64 logical, u64 len,
> >  	u32 blocksize;
> >  
> >  	if (flags & BTRFS_EXTENT_FLAG_DATA) {
> > -		blocksize = sctx->fs_info->sectorsize;
> > +		if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK)
> > +			blocksize = map->stripe_len;
> > +		else
> > +			blocksize = sctx->fs_info->sectorsize;
> >  		spin_lock(&sctx->stat_lock);
> >  		sctx->stat.data_extents_scrubbed++;
> >  		sctx->stat.data_bytes_scrubbed += len;
> >  		spin_unlock(&sctx->stat_lock);
> >  	} else if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
> > -		blocksize = sctx->fs_info->nodesize;
> > +		if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK)
> > +			blocksize = map->stripe_len;
> > +		else
> > +			blocksize = sctx->fs_info->nodesize;
> >  		spin_lock(&sctx->stat_lock);
> >  		sctx->stat.tree_extents_scrubbed++;
> >  		sctx->stat.tree_bytes_scrubbed += len;
> > @@ -2883,9 +2925,9 @@ static int scrub_extent_for_parity(struct scrub_parity *sparity,
> >  	}
> >  
> >  	if (flags & BTRFS_EXTENT_FLAG_DATA) {
> > -		blocksize = sctx->fs_info->sectorsize;
> > +		blocksize = sparity->stripe_len;
> >  	} else if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
> > -		blocksize = sctx->fs_info->nodesize;
> > +		blocksize = sparity->stripe_len;
> >  	} else {
> >  		blocksize = sctx->fs_info->sectorsize;
> >  		WARN_ON(1);
> > @@ -3595,7 +3637,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
> >  			if (ret)
> >  				goto out;
> >  
> > -			ret = scrub_extent(sctx, extent_logical, extent_len,
> > +			ret = scrub_extent(sctx, map, extent_logical, extent_len,
> >  					   extent_physical, extent_dev, flags,
> >  					   generation, extent_mirror_num,
> >  					   extent_logical - logical + physical);
> > -- 
> > 2.9.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
