Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38207 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751657AbeCNJWz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Mar 2018 05:22:55 -0400
Subject: Re: [PATCH v2 1/2] btrfs: drop num argument from find_live_mirror()
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180314082913.31503-1-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <35635f9b-49de-2e94-79c3-7e8ea5627f65@suse.com>
Date: Wed, 14 Mar 2018 11:22:52 +0200
MIME-Version: 1.0
In-Reply-To: <20180314082913.31503-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 14.03.2018 10:29, Anand Jain wrote:
> Obtain the stripes info from the map directly and so no need
> to pass it as an argument.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

LGTM

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
> v1->v2:
>   Accepts David's comment to rename %num to %num_stripes.
> 
>  fs/btrfs/volumes.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 1e72357bdfa8..9beea7c891a7 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -5275,13 +5275,22 @@ int btrfs_is_parity_mirror(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
>  }
>  
>  static int find_live_mirror(struct btrfs_fs_info *fs_info,
> -			    struct map_lookup *map, int first, int num,
> +			    struct map_lookup *map, int first,
>  			    int optimal, int dev_replace_is_ongoing)
>  {
>  	int i;
> +	int num_stripes;
>  	int tolerance;
>  	struct btrfs_device *srcdev;
>  
> +	ASSERT((map->type &
> +		 (BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_RAID10)));
> +
> +	if (map->type & BTRFS_BLOCK_GROUP_RAID10)
> +		num_stripes = map->sub_stripes;
> +	else
> +		num_stripes = map->num_stripes;
> +
>  	if (dev_replace_is_ongoing &&
>  	    fs_info->dev_replace.cont_reading_from_srcdev_mode ==
>  	     BTRFS_DEV_REPLACE_ITEM_CONT_READING_FROM_SRCDEV_MODE_AVOID)
> @@ -5298,7 +5307,7 @@ static int find_live_mirror(struct btrfs_fs_info *fs_info,
>  		if (map->stripes[optimal].dev->bdev &&
>  		    (tolerance || map->stripes[optimal].dev != srcdev))
>  			return optimal;
> -		for (i = first; i < first + num; i++) {
> +		for (i = first; i < first + num_stripes; i++) {
>  			if (map->stripes[i].dev->bdev &&
>  			    (tolerance || map->stripes[i].dev != srcdev))
>  				return i;
> @@ -5835,7 +5844,6 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
>  			stripe_index = mirror_num - 1;
>  		else {
>  			stripe_index = find_live_mirror(fs_info, map, 0,
> -					    map->num_stripes,
>  					    current->pid % map->num_stripes,
>  					    dev_replace_is_ongoing);
>  			mirror_num = stripe_index + 1;
> @@ -5864,7 +5872,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
>  			int old_stripe_index = stripe_index;
>  			stripe_index = find_live_mirror(fs_info, map,
>  					      stripe_index,
> -					      map->sub_stripes, stripe_index +
> +					      stripe_index +
>  					      current->pid % map->sub_stripes,
>  					      dev_replace_is_ongoing);
>  			mirror_num = stripe_index - old_stripe_index + 1;
> 
