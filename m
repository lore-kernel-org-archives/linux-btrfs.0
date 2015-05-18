Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20025 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932362AbbERQ1x (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 May 2015 12:27:53 -0400
Date: Tue, 19 May 2015 00:27:18 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org, ce3g8jdj@umail.furryterror.org
Subject: Re: [PATCH] Btrfs: wake up extent state waiters on unlock through
 clear_extent_bits
Message-ID: <20150518162716.GA26112@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1431632467-2000-1-git-send-email-fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1431632467-2000-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 14, 2015 at 08:41:07PM +0100, Filipe Manana wrote:
> When we clear an extent state's EXTENT_LOCKED bit with clear_extent_bits()
> through free_io_failure(), we weren't waking up any tasks waiting for the
> extent's state EXTENT_LOCKED bit, leading to an hang.
> 
> So make sure clear_extent_bits() ends up waking up any waiters if the
> bit EXTENT_LOCKED is supplied by its callers.
> 
> Zygo Blaxell was experiencing such hangs at inode eviction time after
> file unlinks. Thanks to him for a set of scripts to reproduce the issue.

Good catch!

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo

> 
> Reported-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/extent_io.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index c32d226..856c2e8 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -1277,7 +1277,12 @@ int set_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
>  int clear_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
>  		      unsigned bits, gfp_t mask)
>  {
> -	return clear_extent_bit(tree, start, end, bits, 0, 0, NULL, mask);
> +	int wake = 0;
> +
> +	if (bits & EXTENT_LOCKED)
> +		wake = 1;
> +
> +	return clear_extent_bit(tree, start, end, bits, wake, 0, NULL, mask);
>  }
>  
>  int set_extent_delalloc(struct extent_io_tree *tree, u64 start, u64 end,
> -- 
> 2.1.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
