Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54156 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751882AbeBXA2q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Feb 2018 19:28:46 -0500
Date: Sat, 24 Feb 2018 01:26:26 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: drop num argument from find_live_mirror()
Message-ID: <20180224002626.GV1469@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180130062831.14644-1-anand.jain@oracle.com>
 <20180130062831.14644-2-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180130062831.14644-2-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 30, 2018 at 02:28:30PM +0800, Anand Jain wrote:
> Obtain the stripes info from the map directly and so no need
> to pass it as an argument.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/volumes.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index f7147740b68e..9c9d987838c2 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -5252,13 +5252,22 @@ int btrfs_is_parity_mirror(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
>  }
>  
>  static int find_live_mirror(struct btrfs_fs_info *fs_info,
> -			    struct map_lookup *map, int first, int num,
> +			    struct map_lookup *map, int first,
>  			    int optimal, int dev_replace_is_ongoing)
>  {
>  	int i;
> +	int num;

Can you please rename it to something more descriptive? Eg. num_stripes.

>  	int tolerance;
>  	struct btrfs_device *srcdev;
>  
> +	ASSERT((map->type &
> +		 (BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_RAID10)));
> +
> +	if (map->type & BTRFS_BLOCK_GROUP_RAID10)
> +		num = map->sub_stripes;
> +	else
> +		num = map->num_stripes;
> +
>  	if (dev_replace_is_ongoing &&
>  	    fs_info->dev_replace.cont_reading_from_srcdev_mode ==
>  	     BTRFS_DEV_REPLACE_ITEM_CONT_READING_FROM_SRCDEV_MODE_AVOID)
> @@ -5812,7 +5821,6 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
>  			stripe_index = mirror_num - 1;
>  		else {
>  			stripe_index = find_live_mirror(fs_info, map, 0,
> -					    map->num_stripes,
>  					    current->pid % map->num_stripes,
>  					    dev_replace_is_ongoing);
>  			mirror_num = stripe_index + 1;
> @@ -5841,7 +5849,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
>  			int old_stripe_index = stripe_index;
>  			stripe_index = find_live_mirror(fs_info, map,
>  					      stripe_index,
> -					      map->sub_stripes, stripe_index +
> +					      stripe_index +
>  					      current->pid % map->sub_stripes,
>  					      dev_replace_is_ongoing);
>  			mirror_num = stripe_index - old_stripe_index + 1;
> -- 
> 2.7.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
