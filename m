Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53282 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751488AbdK2Lxc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Nov 2017 06:53:32 -0500
Subject: Re: [PATCH] btrfs: drop btrfs_device::can_discard to query directly
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20171129105343.23176-1-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <b37c23ae-6941-c2f2-ef1a-b00a1997392a@suse.com>
Date: Wed, 29 Nov 2017 13:53:29 +0200
MIME-Version: 1.0
In-Reply-To: <20171129105343.23176-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 29.11.2017 12:53, Anand Jain wrote:
> We can query the bdev directly when needed at btrfs_discard_extent()
> so drop btrfs_device::can_discard.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> Suggested-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/extent-tree.c | 5 ++++-
>  fs/btrfs/volumes.c     | 8 --------
>  fs/btrfs/volumes.h     | 1 -
>  3 files changed, 4 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 85a545cf4395..830666c95360 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2145,7 +2145,10 @@ int btrfs_discard_extent(struct btrfs_fs_info *fs_info, u64 bytenr,
>  
>  		for (i = 0; i < bbio->num_stripes; i++, stripe++) {
>  			u64 bytes;
> -			if (!stripe->dev->can_discard)
> +			struct request_queue *req_q;
> +
> +			req_q = bdev_get_queue(stripe->dev->bdev);
> +			if (!blk_queue_discard(req_q))
>  				continue;
>  
>  			ret = btrfs_issue_discard(stripe->dev->bdev,
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index ff62919d568f..ff52ecf17402 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -630,8 +630,6 @@ static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
>  	}
>  
>  	q = bdev_get_queue(bdev);
> -	if (blk_queue_discard(q))
> -		device->can_discard = 1;
>  	if (!blk_queue_nonrot(q))
>  		fs_devices->rotating = 1;
>  
> @@ -2387,8 +2385,6 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
>  	}
>  
>  	q = bdev_get_queue(bdev);
> -	if (blk_queue_discard(q))
> -		device->can_discard = 1;
>  	set_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state);
>  	device->generation = trans->transid;
>  	device->io_width = fs_info->sectorsize;
> @@ -2539,7 +2535,6 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
>  				  struct btrfs_device *srcdev,
>  				  struct btrfs_device **device_out)
>  {
> -	struct request_queue *q;
>  	struct btrfs_device *device;
>  	struct block_device *bdev;
>  	struct list_head *devices;
> @@ -2596,9 +2591,6 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
>  	}
>  	rcu_assign_pointer(device->name, name);
>  
> -	q = bdev_get_queue(bdev);
> -	if (blk_queue_discard(q))
> -		device->can_discard = 1;
>  	mutex_lock(&fs_info->fs_devices->device_list_mutex);
>  	set_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state);
>  	device->generation = 0;
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 2fbff6902c8d..1cc693716b9a 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -74,7 +74,6 @@ struct btrfs_device {
>  	fmode_t mode;
>  
>  	unsigned long dev_state;
> -	int can_discard;
>  	int is_tgtdev_for_dev_replace;
>  	blk_status_t last_flush_error;
>  	int flush_bio_sent;
> 
