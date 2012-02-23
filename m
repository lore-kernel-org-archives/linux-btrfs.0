From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: clear the extent uptodate bits during parent transid
 failures
Date: Thu, 23 Feb 2012 10:12:26 +0800
Message-ID: <4F45A08A.4050007@cn.fujitsu.com>
References: <20120222174335.GO4078@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120222174335.GO4078@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/23/2012 01:43 AM, Chris Mason wrote:
> Normally I just toss patches into git, but this one is pretty subtle and
> I wanted to send it around for extra review.  QA at Oracle did a test
> where they unplugged one drive of a btrfs raid1 mirror for a while and
> then plugged it back in.
> 
> The end result is that we have a whole bunch of out-of-date blocks on
> the bad mirror.  The btrfs parent transid pointers are supposed to
> detect these bad blocks and then we're supposed to read from the good
> copy instead.
> 
> The good news is we did detect the bad blocks.  The bad news is we
> didn't jump over to the good mirror instead.  This patch explains why:
> 
> Author: Chris Mason <chris.mason@oracle.com>
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

Reviewed-by: Liu Bo <liubo2009@cn.fujitsu.com>

or we can be safer:

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index fcf77e1..c1fe25d 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3859,8 +3859,12 @@ int clear_extent_buffer_uptodate(struct extent_io_tree *tree,
 	}
 	for (i = 0; i < num_pages; i++) {
 		page = extent_buffer_page(eb, i);
-		if (page)
+		if (page) {
+			u64 start = (u64)page->index << PAGE_CACHE_SHIFT;
+			u64 end = start + PAGE_CACHE_SIZE - 1;
+
 			ClearPageUptodate(page);
+			clear_extent_uptodate(tree, start, end, NULL, GFP_NOFS);
 	}
 	return 0;
 }

>     Signed-off-by: Chris Mason <chris.mason@oracle.com>
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 1e8d5e5..a4dc892 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -3852,10 +3852,9 @@ int clear_extent_buffer_uptodate(struct extent_io_tree *tree,
>  	num_pages = num_extent_pages(eb->start, eb->len);
>  	clear_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
>  
> -	if (eb_straddles_pages(eb)) {
> -		clear_extent_uptodate(tree, eb->start, eb->start + eb->len - 1,
> -				      cached_state, GFP_NOFS);
> -	}
> +	clear_extent_uptodate(tree, eb->start, eb->start + eb->len - 1,
> +			      cached_state, GFP_NOFS);
> +
>  	for (i = 0; i < num_pages; i++) {
>  		page = extent_buffer_page(eb, i);
>  		if (page)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

