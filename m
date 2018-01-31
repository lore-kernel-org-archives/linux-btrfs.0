Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45050 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752015AbeAaHgn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Jan 2018 02:36:43 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D119EAC64
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Jan 2018 07:36:41 +0000 (UTC)
Subject: Re: [PATCH] btrfs: volumes: Cleanup stripe size calculation
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <20180131061634.17383-1-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <02241cf3-1577-df10-faf2-b201320cd668@suse.com>
Date: Wed, 31 Jan 2018 09:36:41 +0200
MIME-Version: 1.0
In-Reply-To: <20180131061634.17383-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 31.01.2018 08:16, Qu Wenruo wrote:
> Cleanup the following things:
> 1) open coded SZ_16M round up
> 2) use min() to replace open-coded size comparison
> 3) code style
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/volumes.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index cb0a8d27661b..90ad716d2b50 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -4761,18 +4761,17 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>  	 * and compare that answer with the max chunk size
>  	 */
>  	if (stripe_size * data_stripes > max_chunk_size) {
> -		u64 mask = (1ULL << 24) - 1;
> -
>  		stripe_size = div_u64(max_chunk_size, data_stripes);
>  
>  		/* bump the answer up to a 16MB boundary */
> -		stripe_size = (stripe_size + mask) & ~mask;
> +		stripe_size = round_up(stripe_size, SZ_16M);
>  
> -		/* but don't go higher than the limits we found
> +		/*
> +		 * but don't go higher than the limits we found
>  		 * while searching for free extents
>  		 */
> -		if (stripe_size > devices_info[ndevs-1].max_avail)
> -			stripe_size = devices_info[ndevs-1].max_avail;
> +		stripe_size = min(devices_info[ndevs - 1].max_avail,
> +				  stripe_size);
>  	}
>  
>  	stripe_size = div_u64(stripe_size, dev_stripes);
> 
