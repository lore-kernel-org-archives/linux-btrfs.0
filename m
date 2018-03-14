Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38378 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750844AbeCNJY3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Mar 2018 05:24:29 -0400
Subject: Re: [PATCH v2 2/2] btrfs: drop optimal argument from
 find_live_mirror()
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180314082913.31503-1-anand.jain@oracle.com>
 <20180314082913.31503-2-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <2388f361-646e-a0bd-bf71-a2d149f83f6a@suse.com>
Date: Wed, 14 Mar 2018 11:24:27 +0200
MIME-Version: 1.0
In-Reply-To: <20180314082913.31503-2-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 14.03.2018 10:29, Anand Jain wrote:
> Drop optimal argument from the function find_live_mirror()
> as we can deduce it in the function itself. Also rename
> optimal to preferred_mirror.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
> I thought I have sent v2 to the ML. But now I realize I didn't.
> v1->v2:
>    Accepts David's comment to rename %optimal. IMO, %preferred_mirror is
>    better than the suggested %fallback.
> 
>  fs/btrfs/volumes.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 9beea7c891a7..f1b7efbdcec1 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -5276,10 +5276,11 @@ int btrfs_is_parity_mirror(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
>  
>  static int find_live_mirror(struct btrfs_fs_info *fs_info,
>  			    struct map_lookup *map, int first,
> -			    int optimal, int dev_replace_is_ongoing)
> +			    int dev_replace_is_ongoing)
>  {
>  	int i;
>  	int num_stripes;
> +	int preferred_mirror;
>  	int tolerance;
>  	struct btrfs_device *srcdev;
>  
> @@ -5291,6 +5292,8 @@ static int find_live_mirror(struct btrfs_fs_info *fs_info,
>  	else
>  		num_stripes = map->num_stripes;
>  
> +	preferred_mirror = first + current->pid % num_stripes;
> +
>  	if (dev_replace_is_ongoing &&
>  	    fs_info->dev_replace.cont_reading_from_srcdev_mode ==
>  	     BTRFS_DEV_REPLACE_ITEM_CONT_READING_FROM_SRCDEV_MODE_AVOID)
> @@ -5304,9 +5307,9 @@ static int find_live_mirror(struct btrfs_fs_info *fs_info,
>  	 * mirror is available
>  	 */
>  	for (tolerance = 0; tolerance < 2; tolerance++) {
> -		if (map->stripes[optimal].dev->bdev &&
> -		    (tolerance || map->stripes[optimal].dev != srcdev))
> -			return optimal;
> +		if (map->stripes[preferred_mirror].dev->bdev &&
> +		    (tolerance || map->stripes[preferred_mirror].dev != srcdev))
> +			return preferred_mirror;
>  		for (i = first; i < first + num_stripes; i++) {
>  			if (map->stripes[i].dev->bdev &&
>  			    (tolerance || map->stripes[i].dev != srcdev))
> @@ -5317,7 +5320,7 @@ static int find_live_mirror(struct btrfs_fs_info *fs_info,
>  	/* we couldn't find one that doesn't fail.  Just return something
>  	 * and the io error handling code will clean up eventually
>  	 */
> -	return optimal;
> +	return preferred_mirror;
>  }
>  
>  static inline int parity_smaller(u64 a, u64 b)
> @@ -5844,7 +5847,6 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
>  			stripe_index = mirror_num - 1;
>  		else {
>  			stripe_index = find_live_mirror(fs_info, map, 0,
> -					    current->pid % map->num_stripes,
>  					    dev_replace_is_ongoing);
>  			mirror_num = stripe_index + 1;
>  		}
> @@ -5872,8 +5874,6 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
>  			int old_stripe_index = stripe_index;
>  			stripe_index = find_live_mirror(fs_info, map,
>  					      stripe_index,
> -					      stripe_index +
> -					      current->pid % map->sub_stripes,
>  					      dev_replace_is_ongoing);
>  			mirror_num = stripe_index - old_stripe_index + 1;
>  		}
> 
