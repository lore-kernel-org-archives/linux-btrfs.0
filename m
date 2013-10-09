Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36641 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab3JIKHc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Oct 2013 06:07:32 -0400
Date: Wed, 9 Oct 2013 18:07:20 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: limit delalloc pages outside of
 find_delalloc_range
Message-ID: <20131009100720.GA13983@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1381253517-914-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1381253517-914-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 08, 2013 at 01:31:57PM -0400, Josef Bacik wrote:
> Liu fixed part of this problem and unfortunately I steered him in slightly the
> wrong direction and so didn't completely fix the problem.  The problem is we
> limit the size of the delalloc range we are looking for to max bytes and then we
> try to lock that range.  If we fail to lock the pages in that range we will
> shrink the max bytes to a single page and re loop.  However if our first page is
> inside of the delalloc range then we will end up limiting the end of the range
> to a period before our first page.  This is illustrated below
> 
> [0 -------- delalloc range --------- 256mb]
>                                   [page]
> 
> So find_delalloc_range will return with delalloc_start as 0 and end as 128mb,
> and then we will notice that delalloc_start < *start and adjust it up, but not
> adjust delalloc_end up, so things go sideways.  To fix this we need to not limit

This makes me more confused...
so do you mean that 'delalloc_end < delalloc_start' leads to the not locked pages?

-liubo
thanks,

> the max bytes in find_delalloc_range, but in find_lock_delalloc_range and that
> way we don't end up with this confusion.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  fs/btrfs/extent_io.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index b48942f..2bf6f46 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -1491,10 +1491,8 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
>  		cur_start = state->end + 1;
>  		node = rb_next(node);
>  		total_bytes += state->end - state->start + 1;
> -		if (total_bytes >= max_bytes) {
> -			*end = *start + max_bytes - 1;
> +		if (total_bytes >= max_bytes)
>  			break;
> -		}
>  		if (!node)
>  			break;
>  	}
> @@ -1636,10 +1634,9 @@ again:
>  
>  	/*
>  	 * make sure to limit the number of pages we try to lock down
> -	 * if we're looping.
>  	 */
> -	if (delalloc_end + 1 - delalloc_start > max_bytes && loops)
> -		delalloc_end = delalloc_start + PAGE_CACHE_SIZE - 1;
> +	if (delalloc_end + 1 - delalloc_start > max_bytes)
> +		delalloc_end = delalloc_start + max_bytes - 1;
>  
>  	/* step two, lock all the pages after the page that has start */
>  	ret = lock_delalloc_pages(inode, locked_page,
> @@ -1650,8 +1647,7 @@ again:
>  		 */
>  		free_extent_state(cached_state);
>  		if (!loops) {
> -			unsigned long offset = (*start) & (PAGE_CACHE_SIZE - 1);
> -			max_bytes = PAGE_CACHE_SIZE - offset;
> +			max_bytes = PAGE_CACHE_SIZE;
>  			loops = 1;
>  			goto again;
>  		} else {
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
