Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59963 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751512AbdEEOqK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 May 2017 10:46:10 -0400
Date: Fri, 5 May 2017 16:46:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs: add framework to handle device flush error as a
 volume
Message-ID: <20170505144602.GD10575@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170425085831.14999-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170425085831.14999-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 25, 2017 at 04:58:31PM +0800, Anand Jain wrote:
> This adds comments to the flush error handling part of
> the code, and hopes to maintain the same logic with a
> framework which can be used to handle the errors at the
> volume level.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/disk-io.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++----
>  fs/btrfs/volumes.h |  1 +
>  2 files changed, 55 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index eb1ee7b6f532..dafcb6bb2d5d 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3527,6 +3527,10 @@ static int write_dev_flush(struct btrfs_device *device, int wait)
>  	if (wait) {
>  		bio = device->flush_bio;
>  		if (!bio)
> +			/*
> +			 * This means the alloc has failed with ENOMEM, however
> +			 * here we return 0, as its not a device error.
> +			 */
>  			return 0;
>  
>  		wait_for_completion(&device->flush_wait);
> @@ -3566,6 +3570,33 @@ static int write_dev_flush(struct btrfs_device *device, int wait)
>  	return 0;
>  }
>  
> +static int check_barrier_error(struct btrfs_fs_devices *fsdevs)
> +{
> +	int submit_flush_error = 0;
> +	int dev_flush_error = 0;
> +	struct btrfs_device *dev;
> +
> +	list_for_each_entry_rcu(dev, &fsdevs->devices, dev_list) {
> +		if (!dev->bdev) {
> +			submit_flush_error++;
> +			dev_flush_error++;
> +			continue;
> +		}
> +		if (dev->last_flush_error == ENOMEM)

That's -ENOMEM

> +			submit_flush_error++;
> +		if (dev->last_flush_error && dev->last_flush_error != ENOMEM)

also here.

> +			dev_flush_error++;
> +	}
> +
> +	if (submit_flush_error >
> +		fsdevs->fs_info->num_tolerated_disk_barrier_failures ||
> +		dev_flush_error >
> +		fsdevs->fs_info->num_tolerated_disk_barrier_failures)
> +		return -EIO;

Can you please reformat this so it's clear what's the condition and
what's the statement?

> +
> +	return 0;
> +}
> +
>  /*
>   * send an empty flush down to each device in parallel,
>   * then wait for them
> @@ -3593,6 +3624,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
>  		ret = write_dev_flush(dev, 0);
>  		if (ret)
>  			errors_send++;
> +		dev->last_flush_error = ret;

Here the error is set unconditionally, so it always tracks the return
code, not only the error ...

>  	}
>  
>  	/* wait for all the barriers */
> @@ -3607,12 +3639,30 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
>  			continue;
>  
>  		ret = write_dev_flush(dev, 1);
> -		if (ret)
> +		if (ret) {
> +			dev->last_flush_error = ret;

... while this tracks only the errors. Unless I'm missing something,
both should be set in a consistent way.

>  			errors_wait++;
> +		}
> +	}
> +
> +	/*
> +	 * Try hard in case of flush. Lets say, in RAID1 we have
> +	 * the following situation
> +	 *  dev1: EIO dev2: ENOMEM
> +	 * this is not a fatal error as we hope to recover from
> +	 * ENOMEM in the next attempt to flush.

This could still be problematic under some very rare conditions, but I
don't deem it important at the moment as the memory allocation will be
gone. Then the comment reflects the current state, which is fine.

> +	 * But the following is considered as fatal
> +	 *  dev1: ENOMEM dev2: ENOMEM
> +	 *  dev1: bdev == NULL dev2: ENOMEM
> +	 */
> +	if (errors_send || errors_wait) {
> +		/*
> +		 * At some point we need the status of all disks
> +		 * to arrive at the volume status. So error checking
> +		 * is being pushed to a separate loop.
> +		 */
> +		return check_barrier_error(info->fs_devices);
>  	}
> -	if (errors_send > info->num_tolerated_disk_barrier_failures ||
> -	    errors_wait > info->num_tolerated_disk_barrier_failures)
> -		return -EIO;
>  	return 0;
>  }
>  
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 59be81206dd7..9c09dcd96e5d 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -74,6 +74,7 @@ struct btrfs_device {
>  	int missing;
>  	int can_discard;
>  	int is_tgtdev_for_dev_replace;
> +	int last_flush_error;
>  
>  #ifdef __BTRFS_NEED_DEVICE_DATA_ORDERED
>  	seqcount_t data_seqcount;
> -- 
> 2.10.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
