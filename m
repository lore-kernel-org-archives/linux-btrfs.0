Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:30323 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754981AbdCGKcN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Mar 2017 05:32:13 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v274imEw002384
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 7 Mar 2017 04:44:48 GMT
Subject: Re: [PATCH v2 4/6] btrfs: Allow barrier_all_devices to do chunk level
 device check
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <20170306085855.11403-1-quwenruo@cn.fujitsu.com>
 <20170306085855.11403-5-quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, lists@colorremedies.com
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <10be6a52-355d-d23f-b534-0bb279516a56@oracle.com>
Date: Tue, 7 Mar 2017 12:48:19 +0800
MIME-Version: 1.0
In-Reply-To: <20170306085855.11403-5-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/06/2017 04:58 PM, Qu Wenruo wrote:
> The last user of num_tolerated_disk_barrier_failures is
> barrier_all_devices().
> But it's can be easily changed to new per-chunk degradable check
> framework.
>
> Now btrfs_device will have two extra members, representing send/wait
> error, set at write_dev_flush() time.
> With these 2 new members, btrfs_check_rw_degradable() can check if the
> fs is still OK when the fs is committed to disk.

  This logic isn't reentrant, earlier it was. How about using
  stack variable instead ?

Thanks, Anand


> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  fs/btrfs/disk-io.c | 15 +++++++--------
>  fs/btrfs/volumes.c |  4 +++-
>  fs/btrfs/volumes.h |  4 ++++
>  3 files changed, 14 insertions(+), 9 deletions(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index c26b8a0b121c..f596bd130524 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3569,17 +3569,17 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
>  {
>  	struct list_head *head;
>  	struct btrfs_device *dev;
> -	int errors_send = 0;
> -	int errors_wait = 0;
>  	int ret;
>
>  	/* send down all the barriers */
>  	head = &info->fs_devices->devices;
>  	list_for_each_entry_rcu(dev, head, dev_list) {
> +		dev->err_wait = false;
> +		dev->err_send = false;
>  		if (dev->missing)
>  			continue;
>  		if (!dev->bdev) {
> -			errors_send++;
> +			dev->err_send = true;
>  			continue;
>  		}
>  		if (!dev->in_fs_metadata || !dev->writeable)
> @@ -3587,7 +3587,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
>
>  		ret = write_dev_flush(dev, 0);
>  		if (ret)
> -			errors_send++;
> +			dev->err_send = true;
>  	}
>
>  	/* wait for all the barriers */
> @@ -3595,7 +3595,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
>  		if (dev->missing)
>  			continue;
>  		if (!dev->bdev) {
> -			errors_wait++;
> +			dev->err_wait = true;
>  			continue;
>  		}
>  		if (!dev->in_fs_metadata || !dev->writeable)
> @@ -3603,10 +3603,9 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
>
>  		ret = write_dev_flush(dev, 1);
>  		if (ret)
> -			errors_wait++;
> +			dev->err_wait = true;
>  	}
> -	if (errors_send > info->num_tolerated_disk_barrier_failures ||
> -	    errors_wait > info->num_tolerated_disk_barrier_failures)
> +	if (!btrfs_check_rw_degradable(info))
>  		return -EIO;
>  	return 0;
>  }
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index dd9dd94d7043..729cbd0d2b60 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -6796,7 +6796,9 @@ bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info)
>  			btrfs_get_num_tolerated_disk_barrier_failures(
>  					map->type);
>  		for (i = 0; i < map->num_stripes; i++) {
> -			if (map->stripes[i].dev->missing)
> +			if (map->stripes[i].dev->missing ||
> +			    map->stripes[i].dev->err_wait ||
> +			    map->stripes[i].dev->err_send)
>  				missing++;
>  		}
>  		if (missing > max_tolerated) {
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index db1b5ef479cf..112fccacdabc 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -75,6 +75,10 @@ struct btrfs_device {
>  	int can_discard;
>  	int is_tgtdev_for_dev_replace;
>
> +	/* If this devices fails to send/wait dev flush */
> +	bool err_send;
> +	bool err_wait;



>  #ifdef __BTRFS_NEED_DEVICE_DATA_ORDERED
>  	seqcount_t data_seqcount;
>  #endif
>
