From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs Storage Array Corrupted
Date: Tue, 28 Feb 2012 21:50:27 -0500
Message-ID: <20120229025027.GB15383@shiny>
References: <CAPeorG-1EtMAu9XzSNqMW-=QwhN-_bZorLXy9Pr5N+J-LKPzTg@mail.gmail.com>
 <4F4D8259.2090209@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Travis Shivers <ttshivers@gmail.com>, linux-btrfs@vger.kernel.org
To: Gurudas Pai <gurudas.pai@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F4D8259.2090209@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 28, 2012 at 05:41:45PM -0800, Gurudas Pai wrote:
> 
> 
> ># btrfs-debug-tree /dev/sdh
> couldn't open because of unsupported option features (8).
> btrfs-debug-tree: disk-io.c:679: open_ctree_fd: Assertion `!(1)' failed
> 
> 
> 
> 
> See if following patch helps.

This patch may just fix things (if we're really lucky).  If not, yes we
can help figure out where the problem is and get past it.

-chris

> 
> Author: Chris Mason<chris.mason@oracle.com>
> Date:   Wed Feb 22 12:36:24 2012 -0500
> 
>     Btrfs: clear the extent uptodate bits during parent transid failures
> 
>     If btrfs reads a block and finds a parent transid mismatch, it clears
>     the uptodate flags on the extent buffer, and the pages inside it.  But
>     we only clear the uptodate bits in the state tree if the block straddles
>     more than one page.
> 
>     This is from an old optimization from to reduce contention on the extent
>     state tree.  But it is buggy because the code that retries a read from
>     a different copy of the block is going to find the uptodate state bits
>     set and skip the IO.
> 
>     The end result of the bug is that we'll never actually read the good
>     copy (if there is one).
> 
>     The fix here is to always clear the uptodate state bits, which is safe
>     because this code is only called when the parent transid fails.
> 
>     Signed-off-by: Chris Mason<chris.mason@oracle.com>
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 1e8d5e5..a4dc892 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -3852,10 +3852,9 @@ int clear_extent_buffer_uptodate(struct extent_io_tree *tree,
>  	num_pages = num_extent_pages(eb->start, eb->len);
>  	clear_bit(EXTENT_BUFFER_UPTODATE,&eb->bflags);
> 
> -	if (eb_straddles_pages(eb)) {
> -		clear_extent_uptodate(tree, eb->start, eb->start + eb->len - 1,
> -				      cached_state, GFP_NOFS);
> -	}
> +	clear_extent_uptodate(tree, eb->start, eb->start + eb->len - 1,
> +			      cached_state, GFP_NOFS);
> +
>  	for (i = 0; i<  num_pages; i++) {
>  		page = extent_buffer_page(eb, i);
>  		if (page)
> --
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
