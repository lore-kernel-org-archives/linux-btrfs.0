Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:38477 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759006Ab3EONxa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 09:53:30 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id A8E287C0693
	for <linux-btrfs@vger.kernel.org>; Wed, 15 May 2013 07:53:29 -0600 (MDT)
Date: Wed, 15 May 2013 09:53:26 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Alexandre Oliva <oliva@gnu.org>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        <axboe@kernel.dk>
Subject: Re: I/O errors block the entire filesystem
Message-ID: <20130515135326.GD1765@localhost.localdomain>
References: <orhajmb7kc.fsf@livre.home>
 <orhaiax9yh.fsf@livre.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <orhaiax9yh.fsf@livre.home>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 11, 2013 at 01:16:38AM -0600, Alexandre Oliva wrote:
> On Apr  4, 2013, Alexandre Oliva <oliva@gnu.org> wrote:
> 
> > I've been trying to figure out the btrfs I/O stack to try to understand
> > why, sometimes (but not always), after a failure to read a (data
> > non-replicated) block from the disk, the file being accessed becomes
> > permanently locked, and the filesystem, unmountable.
> 
> So, after some further investigation, we could determine that the
> problem was that end_bio_extent_readpage would unlock_extent_cached only
> part of the page, because it had previously computed whole_page as zero
> because of the nonzero bv_offset.
> 
> So I started hunting for some place that would set up the bio with
> partial pages, and I failed.
> 
> I was already suspecting some race condition or other form of corruption
> of the bvec before it got to end_bio_extent_readpage when I realized
> that the bv_offset was always a multiple of 512 bytes, and it
> represented the offset into the 4KiB page that the sector that failed to
> read was going to occupy.
> 
> So I started hunting for places that modified bv_offset, and I found
> blk_update_request in fs/blk-core.c, where the very error message
> reporting the failed sector was output.
> 
> The conclusion is that we cannot assume bvec is unmodified between our
> submitting the bio and our getting an error back.
> 
> OTOH, I don't see that we ever set up bvecs that do not correspond to
> whole pages.  Indeed, my attempts to catch such situations with a
> wrapper around bio_add_page got no hits whatsoever, which suggests we
> could just do away with the whole_page computation, and take
> bv_offset+bv_len == PAGE_CACHE_SIZE as the requested read size.
> 
> With this patch, after a read error, I get an EIO rather than a process
> hang that causes further attempts to access the file to hang, generally
> in a non-interruptible way.  Yay!
> 
> 

> btrfs: do away with non-whole_page extent I/O
> 
> From: Alexandre Oliva <oliva@gnu.org>
> 
> end_bio_extent_readpage computes whole_page based on bv_offset and
> bv_len, without taking into account that blk_update_request may modify
> them when some of the blocks to be read into a page produce a read
> error.  This would cause the read to unlock only part of the file
> range associated with the page, which would in turn leave the entire
> page locked, which would not only keep the process blocked instead of
> returning -EIO to it, but also prevent any further access to the file.
> 
> It turns out that btrfs always issues whole-page reads and writes.
> The special handling of non-whole_page appears to be a mistake or a
> left-over from a time when this wasn't the case.  Indeed,
> end_bio_extent_writepage distinguished between whole_page and
> non-whole_page writes but behaved identically in both cases!
> 
> I've replaced the whole_page computations with warnings, just to be
> sure that we're not issuing partial page reads or writes.  The
> warnings should probably just go away some time.
> 
> Signed-off-by: Alexandre Oliva <oliva@gnu.org>
> ---
>  fs/btrfs/extent_io.c |   85 ++++++++++++++++++--------------------------------
>  1 file changed, 30 insertions(+), 55 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index cdee391..f44b033 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -1873,28 +1873,6 @@ static void check_page_uptodate(struct extent_io_tree *tree, struct page *page)
>  }
>  
>  /*
> - * helper function to unlock a page if all the extents in the tree
> - * for that page are unlocked
> - */
> -static void check_page_locked(struct extent_io_tree *tree, struct page *page)
> -{
> -	u64 start = page_offset(page);
> -	u64 end = start + PAGE_CACHE_SIZE - 1;
> -	if (!test_range_bit(tree, start, end, EXTENT_LOCKED, 0, NULL))
> -		unlock_page(page);
> -}
> -
> -/*
> - * helper function to end page writeback if all the extents
> - * in the tree for that page are done with writeback
> - */
> -static void check_page_writeback(struct extent_io_tree *tree,
> -				 struct page *page)
> -{
> -	end_page_writeback(page);
> -}
> -
> -/*
>   * When IO fails, either with EIO or csum verification fails, we
>   * try other mirrors that might have a good copy of the data.  This
>   * io_failure_record is used to record state as we go through all the
> @@ -2323,19 +2301,24 @@ static void end_bio_extent_writepage(struct bio *bio, int err)
>  	struct extent_io_tree *tree;
>  	u64 start;
>  	u64 end;
> -	int whole_page;
>  
>  	do {
>  		struct page *page = bvec->bv_page;
>  		tree = &BTRFS_I(page->mapping->host)->io_tree;
>  
> -		start = page_offset(page) + bvec->bv_offset;
> -		end = start + bvec->bv_len - 1;
> +		/* We always issue full-page reads, but if some block
> +		 * in a page fails to read, blk_update_request() will
> +		 * advance bv_offset and adjust bv_len to compensate.
> +		 * Print a warning for nonzero offsets, and an error
> +		 * if they don't add up to a full page.  */
> +		if (bvec->bv_offset || bvec->bv_len != PAGE_CACHE_SIZE)
> +			printk("%s page write in btrfs with offset %u and length %u\n",
> +			       bvec->bv_offset + bvec->bv_len != PAGE_CACHE_SIZE
> +			       ? KERN_ERR "partial" : KERN_INFO "incomplete",
> +			       bvec->bv_offset, bvec->bv_len);
>  
> -		if (bvec->bv_offset == 0 && bvec->bv_len == PAGE_CACHE_SIZE)
> -			whole_page = 1;
> -		else
> -			whole_page = 0;
> +		start = page_offset(page);
> +		end = start + bvec->bv_offset + bvec->bv_len - 1;
>  
>  		if (--bvec >= bio->bi_io_vec)
>  			prefetchw(&bvec->bv_page->flags);
> @@ -2343,10 +2326,7 @@ static void end_bio_extent_writepage(struct bio *bio, int err)
>  		if (end_extent_writepage(page, err, start, end))
>  			continue;
>  
> -		if (whole_page)
> -			end_page_writeback(page);
> -		else
> -			check_page_writeback(tree, page);
> +		end_page_writeback(page);
>  	} while (bvec >= bio->bi_io_vec);
>  
>  	bio_put(bio);
> @@ -2371,7 +2351,6 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
>  	struct extent_io_tree *tree;
>  	u64 start;
>  	u64 end;
> -	int whole_page;
>  	int mirror;
>  	int ret;
>  
> @@ -2388,13 +2367,19 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
>  			 (long int)bio->bi_bdev);
>  		tree = &BTRFS_I(page->mapping->host)->io_tree;
>  
> -		start = page_offset(page) + bvec->bv_offset;
> -		end = start + bvec->bv_len - 1;
> +		/* We always issue full-page reads, but if some block
> +		 * in a page fails to read, blk_update_request() will
> +		 * advance bv_offset and adjust bv_len to compensate.
> +		 * Print a warning for nonzero offsets, and an error
> +		 * if they don't add up to a full page.  */
> +		if (bvec->bv_offset || bvec->bv_len != PAGE_CACHE_SIZE)
> +			printk("%s page read in btrfs with offset %u and length %u\n",
> +			       bvec->bv_offset + bvec->bv_len != PAGE_CACHE_SIZE
> +			       ? KERN_ERR "partial" : KERN_INFO "incomplete",
> +			       bvec->bv_offset, bvec->bv_len);
>  
> -		if (bvec->bv_offset == 0 && bvec->bv_len == PAGE_CACHE_SIZE)
> -			whole_page = 1;
> -		else
> -			whole_page = 0;
> +		start = page_offset(page);
> +		end = start + bvec->bv_offset + bvec->bv_len - 1;
>  
>  		if (++bvec <= bvec_end)
>  			prefetchw(&bvec->bv_page->flags);
> @@ -2453,23 +2438,13 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
>  		}
>  		unlock_extent_cached(tree, start, end, &cached, GFP_ATOMIC);
>  
> -		if (whole_page) {
> -			if (uptodate) {
> -				SetPageUptodate(page);
> -			} else {
> -				ClearPageUptodate(page);
> -				SetPageError(page);
> -			}
> -			unlock_page(page);
> +		if (uptodate) {
> +			SetPageUptodate(page);
>  		} else {
> -			if (uptodate) {
> -				check_page_uptodate(tree, page);
> -			} else {
> -				ClearPageUptodate(page);
> -				SetPageError(page);
> -			}
> -			check_page_locked(tree, page);
> +			ClearPageUptodate(page);
> +			SetPageError(page);
>  		}
> +		unlock_page(page);
>  	} while (bvec <= bvec_end);
>  
>  	bio_put(bio);

So this should only happen in the case that you are on a dm device it looks
like, is that how you are running?  Kind of mean that the block layer does that
to us though, I wonder what fs'es that do sub page size writes are supposed to
do.  Jens do you have any insight to offer here?  Do we just need to cram the
info we need into a private and just not trust the bio we get back?  Thanks,

Josef
