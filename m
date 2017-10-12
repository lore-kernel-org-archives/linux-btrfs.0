Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43893 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752516AbdJLJDd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Oct 2017 05:03:33 -0400
Subject: Re: [PATCH] btrfs: use need_full_stripe() in __btrfs_map_block()
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20171012084300.4740-1-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <ec5ffd06-6881-d121-3046-9a2e1f79993c@suse.com>
Date: Thu, 12 Oct 2017 12:03:31 +0300
MIME-Version: 1.0
In-Reply-To: <20171012084300.4740-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12.10.2017 11:43, Anand Jain wrote:
> A cleanup patch, use need_full_stripe() to replace the open code.

The code is equivalent by merit of De Morgan's law (I had to actually go
look up the equivalence classes before I convinced myself it was correct)

~A ^ ~B == ~(A or B)

Reviewed-by: Nikolay Borisov <nborisov@suse.com>



> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/volumes.c | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 3b3ba1ecd88b..f5dee43f8f3f 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -5673,10 +5673,10 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
>  	if (map->type & BTRFS_BLOCK_GROUP_RAID0) {
>  		stripe_nr = div_u64_rem(stripe_nr, map->num_stripes,
>  				&stripe_index);
> -		if (op != BTRFS_MAP_WRITE && op != BTRFS_MAP_GET_READ_MIRRORS)
> +		if (!need_full_stripe(op))
>  			mirror_num = 1;
>  	} else if (map->type & BTRFS_BLOCK_GROUP_RAID1) {
> -		if (op == BTRFS_MAP_WRITE || op == BTRFS_MAP_GET_READ_MIRRORS)
> +		if (need_full_stripe(op))
>  			num_stripes = map->num_stripes;
>  		else if (mirror_num)
>  			stripe_index = mirror_num - 1;
> @@ -5689,7 +5689,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
>  		}
>  
>  	} else if (map->type & BTRFS_BLOCK_GROUP_DUP) {
> -		if (op == BTRFS_MAP_WRITE || op == BTRFS_MAP_GET_READ_MIRRORS) {
> +		if (need_full_stripe(op)) {
>  			num_stripes = map->num_stripes;
>  		} else if (mirror_num) {
>  			stripe_index = mirror_num - 1;
> @@ -5703,7 +5703,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
>  		stripe_nr = div_u64_rem(stripe_nr, factor, &stripe_index);
>  		stripe_index *= map->sub_stripes;
>  
> -		if (op == BTRFS_MAP_WRITE || op == BTRFS_MAP_GET_READ_MIRRORS)
> +		if (need_full_stripe(op))
>  			num_stripes = map->sub_stripes;
>  		else if (mirror_num)
>  			stripe_index += mirror_num - 1;
> @@ -5718,9 +5718,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
>  		}
>  
>  	} else if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK) {
> -		if (need_raid_map &&
> -		    (op == BTRFS_MAP_WRITE || op == BTRFS_MAP_GET_READ_MIRRORS ||
> -		     mirror_num > 1)) {
> +		if (need_raid_map && (need_full_stripe(op) || mirror_num > 1)) {
>  			/* push stripe_nr back to the start of the full stripe */
>  			stripe_nr = div64_u64(raid56_full_stripe_start,
>  					stripe_len * nr_data_stripes(map));
> @@ -5747,9 +5745,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
>  			/* We distribute the parity blocks across stripes */
>  			div_u64_rem(stripe_nr + stripe_index, map->num_stripes,
>  					&stripe_index);
> -			if ((op != BTRFS_MAP_WRITE &&
> -			     op != BTRFS_MAP_GET_READ_MIRRORS) &&
> -			    mirror_num <= 1)
> +			if (!need_full_stripe(op) && mirror_num <= 1)
>  				mirror_num = 1;
>  		}
>  	} else {
> 
