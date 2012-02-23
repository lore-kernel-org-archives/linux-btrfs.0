From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: clear the extent uptodate bits during parent
 transid failures
Date: Thu, 23 Feb 2012 09:24:55 -0500
Message-ID: <20120223142455.GO18080@shiny>
References: <20120222174335.GO4078@shiny>
 <4F45A08A.4050007@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F45A08A.4050007@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 23, 2012 at 10:12:26AM +0800, Liu Bo wrote:
> On 02/23/2012 01:43 AM, Chris Mason wrote:
> > Normally I just toss patches into git, but this one is pretty subtle and
> > I wanted to send it around for extra review.  QA at Oracle did a test
> > where they unplugged one drive of a btrfs raid1 mirror for a while and
> > then plugged it back in.
> > 
> > The end result is that we have a whole bunch of out-of-date blocks on
> > the bad mirror.  The btrfs parent transid pointers are supposed to
> > detect these bad blocks and then we're supposed to read from the good
> > copy instead.
> > 
> > The good news is we did detect the bad blocks.  The bad news is we
> > didn't jump over to the good mirror instead.  This patch explains why:
> > 
> > Author: Chris Mason <chris.mason@oracle.com>
> > Date:   Wed Feb 22 12:36:24 2012 -0500
> > 
> >     Btrfs: clear the extent uptodate bits during parent transid failures
> >     
> >     If btrfs reads a block and finds a parent transid mismatch, it clears
> >     the uptodate flags on the extent buffer, and the pages inside it.  But
> >     we only clear the uptodate bits in the state tree if the block straddles
> >     more than one page.
> >     
> >     This is from an old optimization from to reduce contention on the extent
> >     state tree.  But it is buggy because the code that retries a read from
> >     a different copy of the block is going to find the uptodate state bits
> >     set and skip the IO.
> >     
> >     The end result of the bug is that we'll never actually read the good
> >     copy (if there is one).
> >     
> >     The fix here is to always clear the uptodate state bits, which is safe
> >     because this code is only called when the parent transid fails.
> > 
> 
> Reviewed-by: Liu Bo <liubo2009@cn.fujitsu.com>

Thanks!

> 
> or we can be safer:
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index fcf77e1..c1fe25d 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -3859,8 +3859,12 @@ int clear_extent_buffer_uptodate(struct extent_io_tree *tree,
>  	}
>  	for (i = 0; i < num_pages; i++) {
>  		page = extent_buffer_page(eb, i);
> -		if (page)
> +		if (page) {
> +			u64 start = (u64)page->index << PAGE_CACHE_SHIFT;
> +			u64 end = start + PAGE_CACHE_SIZE - 1;
> +
>  			ClearPageUptodate(page);
> +			clear_extent_uptodate(tree, start, end, NULL, GFP_NOFS);
>  	}
>  	return 0;
>  }

Hmmm, I'm not sure this is safer.  Our readpage trusts the extent
uptodate bits unconditionally, so we should really clear them
unconditionally as well.

-chris
