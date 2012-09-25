Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:52526 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755278Ab2IYLjo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Sep 2012 07:39:44 -0400
Date: Tue, 25 Sep 2012 13:39:38 +0200
From: David Sterba <dave@jikos.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: limit thread pool size when remounting
Message-ID: <20120925113938.GT14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1348555713-7518-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1348555713-7518-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 25, 2012 at 02:48:33PM +0800, Liu Bo wrote:
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1158,17 +1158,20 @@ static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
>  	printk(KERN_INFO "btrfs: resize thread pool %d -> %d\n",
>  	       old_pool_size, new_pool_size);
>  
> -	btrfs_set_max_workers(&fs_info->generic_worker, new_pool_size);
> +	btrfs_set_max_workers(&fs_info->generic_worker, min(1, new_pool_size));

How could new_pool_size be < 1 ?

There's a check in super.c to pick only values > 0

>  	btrfs_set_max_workers(&fs_info->workers, new_pool_size);
>  	btrfs_set_max_workers(&fs_info->delalloc_workers, new_pool_size);
> -	btrfs_set_max_workers(&fs_info->submit_workers, new_pool_size);
> -	btrfs_set_max_workers(&fs_info->caching_workers, new_pool_size);
> -	btrfs_set_max_workers(&fs_info->fixup_workers, new_pool_size);
> +	btrfs_set_max_workers(&fs_info->submit_workers,
> +			      min_t(u64, fs_info->fs_devices->num_devices,
> +			      new_pool_size));

This ask for update also when a new device is added/removed.

> +	btrfs_set_max_workers(&fs_info->caching_workers, min(2, new_pool_size));
> +	btrfs_set_max_workers(&fs_info->fixup_workers, min(1, new_pool_size));

Same as above, is it expected to be < 1 ?

>  	btrfs_set_max_workers(&fs_info->endio_workers, new_pool_size);
>  	btrfs_set_max_workers(&fs_info->endio_meta_workers, new_pool_size);
>  	btrfs_set_max_workers(&fs_info->endio_meta_write_workers, new_pool_size);
>  	btrfs_set_max_workers(&fs_info->endio_write_workers, new_pool_size);
> -	btrfs_set_max_workers(&fs_info->endio_freespace_worker, new_pool_size);
> +	btrfs_set_max_workers(&fs_info->endio_freespace_worker,
> +			      min(1, new_pool_size));

Not sure, do we actually need more than 1 free space worker?

>  	btrfs_set_max_workers(&fs_info->delayed_workers, new_pool_size);
>  	btrfs_set_max_workers(&fs_info->readahead_workers, new_pool_size);
>  	btrfs_set_max_workers(&fs_info->scrub_workers, new_pool_size);
