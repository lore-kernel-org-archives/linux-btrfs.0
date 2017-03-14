Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:25681 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750919AbdCNIyF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Mar 2017 04:54:05 -0400
Subject: Re: [PATCH 3/4] btrfs: cleanup barrier_all_devices() unify dev error
 count
To: Anand Jain <anand.jain@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <20170313074214.24123-1-anand.jain@oracle.com>
 <20170313074214.24123-4-anand.jain@oracle.com>
CC: <dsterba@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <f91ffa3c-b09d-4b3e-502c-6caffdc9f487@cn.fujitsu.com>
Date: Tue, 14 Mar 2017 16:53:59 +0800
MIME-Version: 1.0
In-Reply-To: <20170313074214.24123-4-anand.jain@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/13/2017 03:42 PM, Anand Jain wrote:
> Now when counting number of error devices we don't need to count
> them separately once during send and wait, as because device error
> counted during send is more of static check.
>
> Also kindly note that as of now there is no code which would set
> dev->bdev = NULL unless device is missing. However I still kept
> bdev == NULL counted towards error device in view of future
> enhancements. And as the device_list_mutex is held when
> barrier_all_devices() is called, I don't expect a new bdev to null
> in between send and wait.
>
> Now in this process I also rename error_wait to dropouts.
>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Looks good.

Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Thanks,
Qu
> ---
>  fs/btrfs/disk-io.c | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index ee3e601da511..5719e036048b 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3574,8 +3574,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
>  {
>  	struct list_head *head;
>  	struct btrfs_device *dev;
> -	int errors_send = 0;
> -	int errors_wait = 0;
> +	int dropouts = 0;
>  	int ret;
>
>  	/* send down all the barriers */
> @@ -3583,10 +3582,8 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
>  	list_for_each_entry_rcu(dev, head, dev_list) {
>  		if (dev->missing)
>  			continue;
> -		if (!dev->bdev) {
> -			errors_send++;
> +		if (!dev->bdev)
>  			continue;
> -		}
>  		if (!dev->in_fs_metadata || !dev->writeable)
>  			continue;
>
> @@ -3600,7 +3597,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
>  		if (dev->missing)
>  			continue;
>  		if (!dev->bdev) {
> -			errors_wait++;
> +			dropouts++;
>  			continue;
>  		}
>  		if (!dev->in_fs_metadata || !dev->writeable)
> @@ -3608,10 +3605,9 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
>
>  		ret = write_dev_flush(dev, 1);
>  		if (ret)
> -			errors_wait++;
> +			dropouts++;
>  	}
> -	if (errors_send > info->num_tolerated_disk_barrier_failures ||
> -	    errors_wait > info->num_tolerated_disk_barrier_failures)
> +	if (dropouts > info->num_tolerated_disk_barrier_failures)
>  		return -EIO;
>  	return 0;
>  }
>


