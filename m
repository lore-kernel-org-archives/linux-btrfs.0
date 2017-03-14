Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17225 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750868AbdCNIrM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Mar 2017 04:47:12 -0400
Subject: Re: [PATCH V2 4/4] btrfs: cleanup barrier_all_devices() to check dev
 stat flush error
To: Anand Jain <anand.jain@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <20170313074214.24123-5-anand.jain@oracle.com>
 <20170314082611.31530-1-anand.jain@oracle.com>
CC: <dsterba@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <ba9478e9-5574-9a73-759c-e767c26a57f7@cn.fujitsu.com>
Date: Tue, 14 Mar 2017 16:47:05 +0800
MIME-Version: 1.0
In-Reply-To: <20170314082611.31530-1-anand.jain@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/14/2017 04:26 PM, Anand Jain wrote:
> The objective of this patch is to cleanup barrier_all_devices()
> so that the error checking is in a separate loop independent of
> of the loop which submits and waits on the device flush requests.
>
> By doing this it helps to further develop patches which would tune
> the error-actions as needed.
>
> Here functions such as btrfs_dev_stats_dirty() couldn't be used
> because it doesn't monitor the flush errors BTRFS_DEV_STAT_FLUSH_ERRS.
>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v2: Address Qu review comments viz..
>      Add meaningful names, like cp_list (for checkpoint_list head).
>      (And actually it does not need a new struct type just to hold
>       the head pointer, list node is already named as device_checkpoint).
>      Check return value of add_device_checkpoint()
>      Check if the device is already added at add_device_checkpoint()
>      Rename fini_devices_checkpoint() to rel_devices_checkpoint()
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 5719e036048b..d0c401884643 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3566,6 +3566,86 @@ static int write_dev_flush(struct btrfs_device *device, int wait)
>  	return 0;
>  }
>
> +struct device_checkpoint {
> +	struct list_head cp_node;
> +	struct btrfs_device *device;
> +	int stat_value_checkpoint;
> +};
> +
> +static int add_device_checkpoint(struct btrfs_device *device,
> +				struct list_head *cp_list)
> +{
> +	struct device_checkpoint *cdev;
> +
> +	list_for_each_entry(cdev, cp_list, cp_node) {
> +		if (cdev->device == device) {
> +			cdev->stat_value_checkpoint =
> +				btrfs_dev_stat_read(device,
> +					BTRFS_DEV_STAT_FLUSH_ERRS);
> +			return 0;
> +		}
> +	}
> +
> +	cdev = kzalloc(sizeof(struct device_checkpoint), GFP_KERNEL);
> +	if (!cdev)
> +		return -ENOMEM;
> +
> +	list_add(&cdev->cp_node, cp_list);
> +
> +	cdev->device = device;
> +	cdev->stat_value_checkpoint =
> +		btrfs_dev_stat_read(device, BTRFS_DEV_STAT_FLUSH_ERRS);
> +
> +	return 0;
> +}
> +
> +static void rel_devices_checkpoint(struct list_head *cp_list)

I meant "release_devices_checkpoint", 'fini' and 'rel' is too short for 
to be meaningful.

Despite of that, looks not too bad to me.

Although I prefer to do extra locking to protect the operation to make 
the checkpoint system more independent and robust, but it can be done later.

So far so good. Although I'm still not sure if other reviewers will have 
other comments.

Thanks,
Qu
> +{
> +	struct device_checkpoint *cdev;
> +
> +	while(!list_empty(cp_list)) {
> +		cdev = list_entry(cp_list->next,
> +				struct device_checkpoint, cp_node);
> +		list_del(&cdev->cp_node);
> +		kfree(cdev);
> +	}
> +}
> +
> +static int check_stat_flush(struct btrfs_device *dev,
> +				struct list_head *cp_list)
> +{
> +	int val;
> +	struct device_checkpoint *cdev;
> +
> +	list_for_each_entry(cdev, cp_list, cp_node) {
> +		if (cdev->device == dev) {
> +			val = btrfs_dev_stat_read(dev,
> +				BTRFS_DEV_STAT_FLUSH_ERRS);
> +			if (cdev->stat_value_checkpoint != val)
> +				return 1;
> +		}
> +	}
> +	return 0;
> +}
> +
> +static int check_barrier_error(struct btrfs_fs_devices *fsdevs,
> +				struct list_head *cp_list)
> +{
> +	int dropouts = 0;
> +	struct btrfs_device *dev;
> +
> +	list_for_each_entry_rcu(dev, &fsdevs->devices, dev_list) {
> +		if (!dev->bdev || check_stat_flush(dev, cp_list))
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
> @@ -3574,8 +3654,8 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
>  {
>  	struct list_head *head;
>  	struct btrfs_device *dev;
> -	int dropouts = 0;
>  	int ret;
> +	static LIST_HEAD(cp_list);
>
>  	/* send down all the barriers */
>  	head = &info->fs_devices->devices;
> @@ -3587,29 +3667,35 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
>  		if (!dev->in_fs_metadata || !dev->writeable)
>  			continue;
>
> +		ret = add_device_checkpoint(dev, &cp_list);
> +		if (ret) {
> +			rel_devices_checkpoint(&cp_list);
> +			return ret;
> +		}
>  		ret = write_dev_flush(dev, 0);
> -		if (ret)
> +		if (ret) {
> +			rel_devices_checkpoint(&cp_list);
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
> +	ret = check_barrier_error(info->fs_devices, &cp_list);
> +
> +	rel_devices_checkpoint(&cp_list);
> +
> +	return ret;
>  }
>
>  int btrfs_get_num_tolerated_disk_barrier_failures(u64 flags)
>


