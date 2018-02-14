Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36290 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030620AbeBNOvX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Feb 2018 09:51:23 -0500
Date: Wed, 14 Feb 2018 15:49:05 +0100
From: David Sterba <dsterba@suse.cz>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
        Arne Jansen <sensille@gmx.net>, Chris Mason <chris.mason@fusionio.com>
Subject: Re: [PATCH] btrfs: alloc_chunk: fix DUP stripe size handling
Message-ID: <20180214144904.GF3003@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180205164511.5549-1-hans.van.kranenburg@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180205164511.5549-1-hans.van.kranenburg@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 05, 2018 at 05:45:11PM +0100, Hans van Kranenburg wrote:
> In case of using DUP, we search for enough unallocated disk space on a
> device to hold two stripes.
> 
> The devices_info[ndevs-1].max_avail that holds the amount of unallocated
> space found is directly assigned to stripe_size, while it's actually
> twice the stripe size.
> 
> Later on in the code, an unconditional division of stripe_size by
> dev_stripes corrects the value, but in the meantime there's a check to
> see if the stripe_size does not exceed max_chunk_size. Since during this
> check stripe_size is twice the amount as intended, the check will reduce
> the stripe_size to max_chunk_size if the actual correct to be used
> stripe_size is more than half the amount of max_chunk_size.
> 
> The unconditional division later tries to correct stripe_size, but will
> actually make sure we can't allocate more than half the max_chunk_size.
> 
> Fix this by moving the division by dev_stripes before the max chunk size
> check, so it always contains the right value, instead of putting a duct
> tape division in further on to get it fixed again.
> 
> Since in all other cases than DUP, dev_stripes is 1, this change only
> affects DUP.
> 
> Other attempts in the past were made to fix this:
> * 37db63a400 "Btrfs: fix max chunk size check in chunk allocator" tried
> to fix the same problem, but still resulted in part of the code acting
> on a wrongly doubled stripe_size value.
> * 86db25785a "Btrfs: fix max chunk size on raid5/6" unintentionally
> broke this fix again.
> 
> The real problem was already introduced with the rest of the code in
> 73c5de0051.
> 
> The user visible result however will be that the max chunk size for DUP
> will suddenly double, while it's actually acting according to the limits
> in the code again like it was 5 years ago.
> 
> Reported-by: Naohiro Aota <naohiro.aota@wdc.com>
> Link: https://www.spinics.net/lists/linux-btrfs/msg69752.html
> Fixes: 73c5de0051 ("btrfs: quasi-round-robin for chunk allocation")
> Fixes: 86db25785a ("Btrfs: fix max chunk size on raid5/6")
> Signed-off-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
> Cc: Naohiro Aota <naohiro.aota@wdc.com>
> Cc: Arne Jansen <sensille@gmx.net>
> Cc: Chris Mason <chris.mason@fusionio.com>

I guess half of the addresses have bounced :) Have you used the
get_maintainer.pl script?

The fix is short, I had to read the allocator code again so it took me
longer to review it. Your description in the changelog was really
helpful.

> ---
>  fs/btrfs/volumes.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 4006b2a1233d..a50bd02b7ada 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -4737,7 +4737,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>  	 * the primary goal is to maximize the number of stripes, so use as many
>  	 * devices as possible, even if the stripes are not maximum sized.
>  	 */
> -	stripe_size = devices_info[ndevs-1].max_avail;
> +	stripe_size = div_u64(devices_info[ndevs-1].max_avail, dev_stripes);

I'll enhance the comment above with more explanation why do it here,
otherwise consider this

Reviewed-by: David Sterba <dsterba@suse.com>

>  	num_stripes = ndevs * dev_stripes;
>  
>  	/*
> @@ -4772,8 +4772,6 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>  			stripe_size = devices_info[ndevs-1].max_avail;
>  	}
>  
> -	stripe_size = div_u64(stripe_size, dev_stripes);
> -
>  	/* align to BTRFS_STRIPE_LEN */
>  	stripe_size = round_down(stripe_size, BTRFS_STRIPE_LEN);
>  
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
