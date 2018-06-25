Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58249 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754133AbeFYJgh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Jun 2018 05:36:37 -0400
Subject: Re: [PATCH v2] Btrfs: fix physical offset reported by fiemap for
 inline extents
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <20180619113142.9020-1-fdmanana@kernel.org>
 <20180620090230.10757-1-fdmanana@kernel.org>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <97276aa3-5eff-886d-dc82-de6994560382@suse.com>
Date: Mon, 25 Jun 2018 12:36:35 +0300
MIME-Version: 1.0
In-Reply-To: <20180620090230.10757-1-fdmanana@kernel.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 20.06.2018 12:02, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
<snip>

> So fix this by ensuring the physical offset is always set to 0 when we
> are processing an extent with a special block_start value.
> 
> Fixes: 9d311e11fc1f ("Btrfs: fiemap: pass correct bytenr when fm_extent_count is zero")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

At first I was "wtf" since I had missed the u64 cast. After realising
that the constants are in fact always parsed as positive numbers then it
makes sense.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
> 
> v2: Set the physical offset to 0 for other extent maps with a special
>     block_start value as well.
> 
>  fs/btrfs/extent_io.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 8e4a7cdbc9f5..1aa91d57404a 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -4545,8 +4545,11 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>  			offset_in_extent = em_start - em->start;
>  		em_end = extent_map_end(em);
>  		em_len = em_end - em_start;
> -		disko = em->block_start + offset_in_extent;
>  		flags = 0;
> +		if (em->block_start < EXTENT_MAP_LAST_BYTE)
> +			disko = em->block_start + offset_in_extent;
> +		else
> +			disko = 0;
>  
>  		/*
>  		 * bump off for our next call to get_extent
> 
