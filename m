Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:50392 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756151Ab3BUSX5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Feb 2013 13:23:57 -0500
Received: by mail-ea0-f180.google.com with SMTP id c1so3906869eaa.11
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Feb 2013 10:23:56 -0800 (PST)
Message-ID: <51266681.9050209@gmail.com>
Date: Thu, 21 Feb 2013 19:25:05 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix max chunk size on raid5/6
References: <20130220213229.GC21291@shiny.masoncoding.com>
In-Reply-To: <20130220213229.GC21291@shiny.masoncoding.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

my comments below
On 02/20/2013 10:32 PM, Chris Mason wrote:
> Hi everyone,
> 
> This spot in the chunk allocation code has seen a lot of little tweaks,
> so I wanted to send this patch out for more eyes.
> 
> --
> 
> We try to limit the size of a chunk to 10GB, which keeps the unit of
> work reasonable during balance and resize operations.  The limit checks
> were taking into account the number of copies of the data we had but
> what they really should be doing is comparing against the logical
> size of the chunk we're creating.
> 
> This moves the code around a little to use the count of data stripes
> from raid5/6.
> 
> Signed-off-by: Chris Mason <chris.mason@fusionio.com>
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 5d6010b..538c5cf 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3837,10 +3837,6 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>  	 */
>  	data_stripes = num_stripes / ncopies;
>  
> -	if (stripe_size * ndevs > max_chunk_size * ncopies) {
> -		stripe_size = max_chunk_size * ncopies;
> -		do_div(stripe_size, ndevs);
> -	}
>  	if (type & BTRFS_BLOCK_GROUP_RAID5) {
>  		raid_stripe_len = find_raid56_stripe_len(ndevs - 1,
>  				 btrfs_super_stripesize(info->super_copy));
> @@ -3851,6 +3847,27 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>  				 btrfs_super_stripesize(info->super_copy));
>  		data_stripes = num_stripes - 2;
>  	}
> +
> +	/*
> +	 * Use the number of data stripes to figure out how big this chunk
> +	 * is really going to be in terms of logical address space,
> +	 * and compare that answer with the max chunk size
> +	 */
> +	if (stripe_size * data_stripes > max_chunk_size) {
> +		u64 mask = (1ULL << 24) - 1;

1<<24 should be a #define or better a parameter tunable via sysfs and/or
a superblock field.

May be we can use everywhere BTRFS_STRIPE_LEN ? (of course increasing
its value to 16MB or more ?) I am asking that because I don't know if it
makes sense to have BTRFS_STRIPE_LEN different from the "round up" value ...


> +		stripe_size = max_chunk_size;
> +		do_div(stripe_size, data_stripes);
> +
> +		/* bump the answer up to a 16MB boundary */
> +		stripe_size = (stripe_size + mask) & ~mask;
> +
> +		/* but don't go higher than the limits we found
> +		 * while searching for free extents
> +		 */
> +		if (stripe_size > devices_info[ndevs-1].max_avail)
> +			stripe_size = devices_info[ndevs-1].max_avail;
> +	}
> +
>  	do_div(stripe_size, dev_stripes);

The logic to me seems correct.
However my fear is that a "16MB" boundary is too low. I would felt
better with a round-up to 128MB. So the stripe size would vary from
128MB to 1GB in step of 128MB. The combination wouldn't be too high.


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
