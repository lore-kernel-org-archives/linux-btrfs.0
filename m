Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20007 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750914AbdCMHzW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Mar 2017 03:55:22 -0400
Subject: Re: [PATCH v3.1 5/7] btrfs: Allow barrier_all_devices to do chunk
 level device check
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <20170309013442.19957-1-quwenruo@cn.fujitsu.com>
 <20170309013442.19957-6-quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <d19e5374-9bd6-378c-edbc-04c3e16f4fac@oracle.com>
Date: Mon, 13 Mar 2017 16:00:03 +0800
MIME-Version: 1.0
In-Reply-To: <20170309013442.19957-6-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Qu,

patch 4/4 added a cleanup for barrier_all_devices() and introduced
a new function check_barrier_error() where integration with per chunk
level device check will simplify.

  [PATCH 4/4] btrfs: cleanup barrier_all_devices() to check dev stat 
flush error

Thanks, Anand



On 03/09/2017 09:34 AM, Qu Wenruo wrote:
> The last user of num_tolerated_disk_barrier_failures is
> barrier_all_devices().
> But it's can be easily changed to new per-chunk degradable check
> framework.
>
> Now btrfs_device will have two extra members, representing send/wait
> error, set at write_dev_flush() time.
> With these 2 new members, btrfs_check_rw_degradable() can check if the
> fs is still OK when the fs is committed to disk.
>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
> Tested-by: Adam Borowski <kilobyte@angband.pl>
> Tested-by: Dmitrii Tcvetkov <demfloro@demfloro.ru>
> ---
>  fs/btrfs/disk-io.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 658b8fab1d39..549045a3e15f 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3570,17 +3570,20 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
>  {
>  	struct list_head *head;
>  	struct btrfs_device *dev;
> -	int errors_send = 0;
> -	int errors_wait = 0;
> +	struct extra_rw_degrade_errors *errors;
>  	int ret;
>
> +	errors = alloc_extra_rw_degrade_errors(info->fs_devices->num_devices);
> +	if (!errors)
> +		return -ENOMEM;
> +
>  	/* send down all the barriers */
>  	head = &info->fs_devices->devices;
>  	list_for_each_entry_rcu(dev, head, dev_list) {
>  		if (dev->missing)
>  			continue;
>  		if (!dev->bdev) {
> -			errors_send++;
> +			record_extra_rw_degrade_error(errors, dev->devid);
>  			continue;
>  		}
>  		if (!dev->in_fs_metadata || !dev->writeable)
> @@ -3588,7 +3591,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
>
>  		ret = write_dev_flush(dev, 0);
>  		if (ret)
> -			errors_send++;
> +			record_extra_rw_degrade_error(errors, dev->devid);
>  	}
>
>  	/* wait for all the barriers */
> @@ -3596,7 +3599,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
>  		if (dev->missing)
>  			continue;
>  		if (!dev->bdev) {
> -			errors_wait++;
> +			record_extra_rw_degrade_error(errors, dev->devid);
>  			continue;
>  		}
>  		if (!dev->in_fs_metadata || !dev->writeable)
> @@ -3604,11 +3607,13 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
>
>  		ret = write_dev_flush(dev, 1);
>  		if (ret)
> -			errors_wait++;
> +			record_extra_rw_degrade_error(errors, dev->devid);
>  	}
> -	if (errors_send > info->num_tolerated_disk_barrier_failures ||
> -	    errors_wait > info->num_tolerated_disk_barrier_failures)
> +	if (!btrfs_check_rw_degradable(info, errors)) {
> +		kfree(errors);
>  		return -EIO;
> +	}
> +	kfree(errors);
>  	return 0;
>  }
>
>
