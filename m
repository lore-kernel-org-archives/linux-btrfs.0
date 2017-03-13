Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33242 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752603AbdCMJFN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Mar 2017 05:05:13 -0400
Subject: Re: [PATCH 4/4] btrfs: cleanup barrier_all_devices() to check dev
 stat flush error
To: Anand Jain <anand.jain@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <20170313074214.24123-1-anand.jain@oracle.com>
 <20170313074214.24123-5-anand.jain@oracle.com>
CC: <dsterba@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <c425830d-9c70-f795-9ad6-05d6ea62a0dc@cn.fujitsu.com>
Date: Mon, 13 Mar 2017 17:05:07 +0800
MIME-Version: 1.0
In-Reply-To: <20170313074214.24123-5-anand.jain@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/13/2017 03:42 PM, Anand Jain wrote:
> The objective of this patch is to cleanup barrier_all_devices()
> so that the error checking is in a separate loop independent of
> of the loop which submits and waits on the device flush requests.

The idea itself is quite good, and we do need it.

>
> By doing this it helps to further develop patches which would tune
> the error-actions as needed.
>
> Here functions such as btrfs_dev_stats_dirty() couldn't be used
> because it doesn't monitor the flush errors BTRFS_DEV_STAT_FLUSH_ERRS.
>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/disk-io.c | 96 +++++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 85 insertions(+), 11 deletions(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 5719e036048b..12531a5b14ff 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3566,6 +3566,76 @@ static int write_dev_flush(struct btrfs_device *device, int wait)
>  	return 0;
>  }
>
> +struct device_checkpoint {
> +	struct list_head list;
> +	struct btrfs_device *device;
> +	int stat_value_checkpoint;
> +};
> +
> +static int add_device_checkpoint(struct list_head *checkpoint,

Could we have another structure instead of list_head to record device 
checkpoints?
The list_head is never a meaningful structure under most cases.


> +					struct btrfs_device *device)
> +{
> +	struct device_checkpoint *cdev =
> +		kzalloc(sizeof(struct device_checkpoint), GFP_KERNEL);
> +	if (!cdev)
> +		return -ENOMEM;

This means that, we must check return value of add_device_checkpoint(), 
while later code doesn't check it at all.

> +
> +	list_add(&cdev->list, checkpoint);

And I prefer to do extra check, in case such device is already inserted 
once.

> +
> +	cdev->device = device;
> +	cdev->stat_value_checkpoint =
> +		btrfs_dev_stat_read(device, BTRFS_DEV_STAT_FLUSH_ERRS);
> +
> +	return 0;
> +}
> +
> +static void fini_devices_checkpoint(struct list_head *checkpoint)

Never a fan of the "fini_" naming.
What about "release_"?

> +{
> +	struct device_checkpoint *cdev;
> +
> +	while(!list_empty(checkpoint)) {
> +		cdev = list_entry(checkpoint->next,
> +				struct device_checkpoint, list);
> +		list_del(&cdev->list);
> +		kfree(cdev);
> +	}
> +}
> +
> +static int check_stat_flush(struct btrfs_device *dev,
> +				struct list_head *checkpoint)
> +{
> +	int val;
> +	struct device_checkpoint *cdev;
> +
> +	list_for_each_entry(cdev, checkpoint, list) {
> +		if (cdev->device == dev) {
> +			val = btrfs_dev_stat_read(dev,
> +				BTRFS_DEV_STAT_FLUSH_ERRS);
> +			if (cdev->stat_value_checkpoint != val)
> +				return 1;

This check implies that BTRFS_DEV_STAT_FLUSH_ERRS will only be modified 
by checkpoint related code.
Or any other modifier can easily break the check, causing false alert.

IIRC that's the reason why I update my previous degraded patch.


Personally speaking, I prefer the patchset to take more usage of the 
checkpoint system, or it's a little overkilled for current usage.

Thanks,
Qu

> +		}
> +	}
> +	return 0;
> +}
> +
> +static int check_barrier_error(struct btrfs_fs_devices *fsdevs,
> +				struct list_head *checkpoint)
> +{
> +	int dropouts = 0;
> +	struct btrfs_device *dev;
> +
> +	list_for_each_entry_rcu(dev, &fsdevs->devices, dev_list) {
> +		if (!dev->bdev || check_stat_flush(dev, checkpoint))
> +			dropouts++;
> +	}
> +
> +	if (dropouts >
> +		fsdevs->fs_info->num_tolerated_disk_barrier_failures)
> +		return -EIO;
> +
> +	return 0;
> +}
> +
>  /*
>   * send an empty flush down to each device in parallel,
>   * then wait for them
> @@ -3574,8 +3644,10 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
>  {
>  	struct list_head *head;
>  	struct btrfs_device *dev;
> -	int dropouts = 0;
>  	int ret;
> +	struct list_head checkpoint;
> +
> +	INIT_LIST_HEAD(&checkpoint);
>
>  	/* send down all the barriers */
>  	head = &info->fs_devices->devices;
> @@ -3587,29 +3659,31 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
>  		if (!dev->in_fs_metadata || !dev->writeable)
>  			continue;
>
> +		add_device_checkpoint(&checkpoint, dev);
>  		ret = write_dev_flush(dev, 0);
> -		if (ret)
> +		if (ret) {
> +			fini_devices_checkpoint(&checkpoint);
>  			return ret;
> +		}
>  	}
>
>  	/* wait for all the barriers */
>  	list_for_each_entry_rcu(dev, head, dev_list) {
>  		if (dev->missing)
>  			continue;
> -		if (!dev->bdev) {
> -			dropouts++;
> +		if (!dev->bdev)
>  			continue;
> -		}
>  		if (!dev->in_fs_metadata || !dev->writeable)
>  			continue;
>
> -		ret = write_dev_flush(dev, 1);
> -		if (ret)
> -			dropouts++;
> +		write_dev_flush(dev, 1);
>  	}
> -	if (dropouts > info->num_tolerated_disk_barrier_failures)
> -		return -EIO;
> -	return 0;
> +
> +	ret = check_barrier_error(info->fs_devices, &checkpoint);
> +
> +	fini_devices_checkpoint(&checkpoint);
> +
> +	return ret;
>  }
>
>  int btrfs_get_num_tolerated_disk_barrier_failures(u64 flags)
>


