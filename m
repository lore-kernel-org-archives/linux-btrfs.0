Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:33818 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbdEPMAQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 08:00:16 -0400
Date: Tue, 16 May 2017 05:00:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 2/2] btrfs: Use blkdev_issue_flush_no_wait()
Message-ID: <20170516120015.GB18649@infradead.org>
References: <20170516093914.16035-1-anand.jain@oracle.com>
 <20170516093914.16035-3-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170516093914.16035-3-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 16, 2017 at 05:39:14PM +0800, Anand Jain wrote:
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

An explanation on why things are changed is entirely missing here..

> ---
>  fs/btrfs/disk-io.c | 108 ++++++++++++++++-------------------------------------
>  fs/btrfs/volumes.h |   2 +-
>  2 files changed, 33 insertions(+), 77 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 8685d67185d0..f059f9bdbbd7 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3478,121 +3478,77 @@ static int write_dev_supers(struct btrfs_device *device,
>  }
>  
>  /*
> - * endio for the write_dev_flush, this will wake anyone waiting
> + * endio for blkdev_issues_flush_no_wait, this will wake anyone waiting
>   * for the barrier when it is done
>   */
>  static void btrfs_end_empty_barrier(struct bio *bio)
>  {
> -	if (bio->bi_private)
> -		complete(bio->bi_private);
> +	struct btrfs_device *device;
> +
> +	device = container_of(bio->bi_private, struct btrfs_device,
> +						flush_wait);
> +
> +	device->last_flush_error = bio->bi_error;
> +	complete(&device->flush_wait);
> +
>  	bio_put(bio);
>  }
>  
> -/*
> - * trigger flushes for one the devices.  If you pass wait == 0, the flushes are
> - * sent down.  With wait == 1, it waits for the previous flush.
> - *
> - * any device where the flush fails with eopnotsupp are flagged as not-barrier
> - * capable
> - */
> -static int write_dev_flush(struct btrfs_device *device, int wait)
> +static void write_dev_flush(struct btrfs_device *device)
>  {
> +	int ret;
>  	struct request_queue *q = bdev_get_queue(device->bdev);
> -	struct bio *bio;
> -	int ret = 0;
>  
>  	if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags))
> -		return 0;
> -
> -	if (wait) {
> -		bio = device->flush_bio;
> -		if (!bio)
> -			return 0;
> -
> -		wait_for_completion(&device->flush_wait);
> -
> -		if (bio->bi_error) {
> -			ret = bio->bi_error;
> -			btrfs_dev_stat_inc_and_print(device,
> -				BTRFS_DEV_STAT_FLUSH_ERRS);
> -		}
> -
> -		/* drop the reference from the wait == 0 run */
> -		bio_put(bio);
> -		device->flush_bio = NULL;
> -
> -		return ret;
> -	}
> -
> -	/*
> -	 * one reference for us, and we leave it for the
> -	 * caller
> -	 */
> -	device->flush_bio = NULL;
> -	bio = btrfs_io_bio_alloc(GFP_NOFS, 0);
> -	if (!bio)
> -		return -ENOMEM;
> -
> -	bio->bi_end_io = btrfs_end_empty_barrier;
> -	bio->bi_bdev = device->bdev;
> -	bio->bi_opf = REQ_OP_WRITE | REQ_PREFLUSH;
> -	init_completion(&device->flush_wait);
> -	bio->bi_private = &device->flush_wait;
> -	device->flush_bio = bio;
> -
> -	bio_get(bio);
> -	btrfsic_submit_bio(bio);
> +		return;
>  
> -	return 0;
> +	ret = blkdev_issue_flush_no_wait(device->bdev, GFP_NOFS,
> +		btrfs_end_empty_barrier, &device->flush_wait);
> +	if (ret)
> +		device->last_flush_error = ret;
> +	else
> +		device->last_flush_error = -1;
>  }
>  
>  /*
> - * send an empty flush down to each device in parallel,
> - * then wait for them
> + * send flush down to each device in parallel, then wait for them.
>   */
>  static int barrier_all_devices(struct btrfs_fs_info *info)
>  {
>  	struct list_head *head;
>  	struct btrfs_device *dev;
> -	int errors_send = 0;
>  	int errors_wait = 0;
> -	int ret;
>  
>  	/* send down all the barriers */
>  	head = &info->fs_devices->devices;
>  	list_for_each_entry_rcu(dev, head, dev_list) {
> +		dev->last_flush_error = 0;
>  		if (dev->missing)
>  			continue;
> +
> +		if (!dev->in_fs_metadata || !dev->writeable)
> +			continue;
> +
>  		if (!dev->bdev) {
> -			errors_send++;
> +			dev->last_flush_error = -ENXIO;
>  			continue;
>  		}
> -		if (!dev->in_fs_metadata || !dev->writeable)
> -			continue;
>  
> -		ret = write_dev_flush(dev, 0);
> -		if (ret)
> -			errors_send++;
> +		write_dev_flush(dev);
>  	}
>  
>  	/* wait for all the barriers */
>  	list_for_each_entry_rcu(dev, head, dev_list) {
> -		if (dev->missing)
> -			continue;
> -		if (!dev->bdev) {
> -			errors_wait++;
> -			continue;
> -		}
> -		if (!dev->in_fs_metadata || !dev->writeable)
> -			continue;
> +		if (dev->last_flush_error == -1)
> +			wait_for_completion(&dev->flush_wait);
>  
> -		ret = write_dev_flush(dev, 1);
> -		if (ret)
> +		if (dev->last_flush_error)
>  			errors_wait++;
>  	}
> -	if (errors_send > info->num_tolerated_disk_barrier_failures ||
> -	    errors_wait > info->num_tolerated_disk_barrier_failures)
> +
> +	if (errors_wait > info->num_tolerated_disk_barrier_failures)
>  		return -EIO;
> +
>  	return 0;
>  }
>  
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index c7d0fbc915ca..27af3a227bfb 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -123,8 +123,8 @@ struct btrfs_device {
>  	struct list_head resized_list;
>  
>  	/* for sending down flush barriers */
> -	struct bio *flush_bio;
>  	struct completion flush_wait;
> +	int last_flush_error;
>  
>  	/* per-device scrub information */
>  	struct scrub_ctx *scrub_device;
> -- 
> 2.10.0
> 
---end quoted text---
