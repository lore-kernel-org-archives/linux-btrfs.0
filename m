Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22526 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755025AbdCTUlR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Mar 2017 16:41:17 -0400
Date: Mon, 20 Mar 2017 13:40:28 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/7] btrfs: preallocate radix tree node for readahead
Message-ID: <20170320204027.GD5540@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1489593696.git.dsterba@suse.com>
 <81148cc21c03374082730036fe9c35f3072bd173.1489593696.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <81148cc21c03374082730036fe9c35f3072bd173.1489593696.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 15, 2017 at 05:02:23PM +0100, David Sterba wrote:
> We can preallocate the node so insertion does not have to do that under
> the lock. The GFP flags for the per-device radix tree are initialized to
>  GFP_NOFS & ~__GFP_DIRECT_RECLAIM
> but we can use GFP_KERNEL, same as an allocation above anyway, but also
> because readahead is optional and not on any critical writeout path.
> 
Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/reada.c   | 7 +++++++
>  fs/btrfs/volumes.c | 2 +-
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
> index e88bca87f5d2..fdae8ca79401 100644
> --- a/fs/btrfs/reada.c
> +++ b/fs/btrfs/reada.c
> @@ -270,6 +270,12 @@ static struct reada_zone *reada_find_zone(struct btrfs_fs_info *fs_info,
>  	if (!zone)
>  		return NULL;
>  
> +	ret = radix_tree_preload(GFP_KERNEL);
> +	if (ret) {
> +		kfree(zone);
> +		return NULL;
> +	}
> +
>  	zone->start = start;
>  	zone->end = end;
>  	INIT_LIST_HEAD(&zone->list);
> @@ -299,6 +305,7 @@ static struct reada_zone *reada_find_zone(struct btrfs_fs_info *fs_info,
>  			zone = NULL;
>  	}
>  	spin_unlock(&fs_info->reada_lock);
> +	radix_tree_preload_end();
>  
>  	return zone;
>  }
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 73d56eef5e60..f158b8657ae3 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -247,7 +247,7 @@ static struct btrfs_device *__alloc_device(void)
>  	atomic_set(&dev->reada_in_flight, 0);
>  	atomic_set(&dev->dev_stats_ccnt, 0);
>  	btrfs_device_data_ordered_init(dev);
> -	INIT_RADIX_TREE(&dev->reada_zones, GFP_NOFS & ~__GFP_DIRECT_RECLAIM);
> +	INIT_RADIX_TREE(&dev->reada_zones, GFP_KERNEL);
>  	INIT_RADIX_TREE(&dev->reada_extents, GFP_NOFS & ~__GFP_DIRECT_RECLAIM);
>  
>  	return dev;
> -- 
> 2.12.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
