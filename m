Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33749 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750959AbeA3JM1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 04:12:27 -0500
Subject: Re: [PATCH 2/2] btrfs: drop optimal argument from find_live_mirror()
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180130062831.14644-1-anand.jain@oracle.com>
 <20180130062831.14644-3-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <7f847ad2-eb70-40aa-1d4b-0ed2119075f4@suse.com>
Date: Tue, 30 Jan 2018 11:12:24 +0200
MIME-Version: 1.0
In-Reply-To: <20180130062831.14644-3-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 30.01.2018 08:28, Anand Jain wrote:
> Drop optimal argument from the function find_live_mirror()
> as we can deduce it in the function itself.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/volumes.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 9c9d987838c2..a61715677b67 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -5253,10 +5253,11 @@ int btrfs_is_parity_mirror(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
>  
>  static int find_live_mirror(struct btrfs_fs_info *fs_info,
>  			    struct map_lookup *map, int first,
> -			    int optimal, int dev_replace_is_ongoing)
> +			    int dev_replace_is_ongoing)
>  {
>  	int i;
>  	int num;
> +	int optimal;
>  	int tolerance;
>  	struct btrfs_device *srcdev;
>  
> @@ -5268,6 +5269,8 @@ static int find_live_mirror(struct btrfs_fs_info *fs_info,
>  	else
>  		num = map->num_stripes;
>  
> +	optimal = first + current->pid % num;
> +
>  	if (dev_replace_is_ongoing &&
>  	    fs_info->dev_replace.cont_reading_from_srcdev_mode ==
>  	     BTRFS_DEV_REPLACE_ITEM_CONT_READING_FROM_SRCDEV_MODE_AVOID)
> @@ -5821,7 +5824,6 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
>  			stripe_index = mirror_num - 1;
>  		else {
>  			stripe_index = find_live_mirror(fs_info, map, 0,
> -					    current->pid % map->num_stripes,
>  					    dev_replace_is_ongoing);
>  			mirror_num = stripe_index + 1;
>  		}
> @@ -5849,8 +5851,6 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
>  			int old_stripe_index = stripe_index;
>  			stripe_index = find_live_mirror(fs_info, map,
>  					      stripe_index,
> -					      stripe_index +
> -					      current->pid % map->sub_stripes,

The value of optimal here (BTRFS_BLOCK_GROUP_RAID10) is different than
the value of optimal in BTRFS_BLOCK_GROUP_RAID1 case. So you need to put
optimal in the conditional branch you added in the previous patch. In
raid 1 case:

optimal = current->pid % num;

In raid 10:

optimal = first + current->pid % num;

to current semantics

>  					      dev_replace_is_ongoing);
>  			mirror_num = stripe_index - old_stripe_index + 1;
>  		}
> 
