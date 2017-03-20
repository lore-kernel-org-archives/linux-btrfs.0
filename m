Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39428 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754957AbdCTVAB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Mar 2017 17:00:01 -0400
Date: Mon, 20 Mar 2017 13:58:31 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/7] btrfs: preallocate radix tree node for global
 readahead tree
Message-ID: <20170320205831.GF5540@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1489593696.git.dsterba@suse.com>
 <47dc4887b9954bd94e3926354ca85067a9fa86ff.1489593696.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <47dc4887b9954bd94e3926354ca85067a9fa86ff.1489593696.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 15, 2017 at 05:02:30PM +0100, David Sterba wrote:
> We can preallocate the node so insertion does not have to do that under
> the lock. The GFP flags for the global radix tree are initialized to
>  GFP_NOFS & ~__GFP_DIRECT_RECLAIM
> but we can use GFP_KERNEL, because readahead is optional and not on any
> critical writeout path.
Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/disk-io.c | 2 +-
>  fs/btrfs/reada.c   | 7 +++++++
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 08b74daf35d0..1d4c30327247 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2693,7 +2693,7 @@ int open_ctree(struct super_block *sb,
>  	fs_info->commit_interval = BTRFS_DEFAULT_COMMIT_INTERVAL;
>  	fs_info->avg_delayed_ref_runtime = NSEC_PER_SEC >> 6; /* div by 64 */
>  	/* readahead state */
> -	INIT_RADIX_TREE(&fs_info->reada_tree, GFP_NOFS & ~__GFP_DIRECT_RECLAIM);
> +	INIT_RADIX_TREE(&fs_info->reada_tree, GFP_KERNEL);
>  	spin_lock_init(&fs_info->reada_lock);
>  
>  	fs_info->thread_pool_size = min_t(unsigned long,
> diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
> index dd78af5d265d..4c5a9b241cab 100644
> --- a/fs/btrfs/reada.c
> +++ b/fs/btrfs/reada.c
> @@ -391,6 +391,10 @@ static struct reada_extent *reada_find_extent(struct btrfs_fs_info *fs_info,
>  		goto error;
>  	}
>  
> +	ret = radix_tree_preload(GFP_KERNEL);
> +	if (ret)
> +		goto error;
> +
>  	/* insert extent in reada_tree + all per-device trees, all or nothing */
>  	btrfs_dev_replace_lock(&fs_info->dev_replace, 0);
>  	spin_lock(&fs_info->reada_lock);
> @@ -400,13 +404,16 @@ static struct reada_extent *reada_find_extent(struct btrfs_fs_info *fs_info,
>  		re_exist->refcnt++;
>  		spin_unlock(&fs_info->reada_lock);
>  		btrfs_dev_replace_unlock(&fs_info->dev_replace, 0);
> +		radix_tree_preload_end();
>  		goto error;
>  	}
>  	if (ret) {
>  		spin_unlock(&fs_info->reada_lock);
>  		btrfs_dev_replace_unlock(&fs_info->dev_replace, 0);
> +		radix_tree_preload_end();
>  		goto error;
>  	}
> +	radix_tree_preload_end();
>  	prev_dev = NULL;
>  	dev_replace_is_ongoing = btrfs_dev_replace_is_ongoing(
>  			&fs_info->dev_replace);
> -- 
> 2.12.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
