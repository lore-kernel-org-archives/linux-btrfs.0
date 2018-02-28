Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:39006 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751521AbeB1B7s (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Feb 2018 20:59:48 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1S1uq69084372
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Feb 2018 01:59:47 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2gdgpk8d61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Feb 2018 01:59:47 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w1S1xkGT008255
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Feb 2018 01:59:46 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w1S1xjj9004439
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Feb 2018 01:59:46 GMT
Date: Tue, 27 Feb 2018 17:57:11 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs: introduce feature to forget a btrfs device
Message-ID: <20180228005711.GE12338@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Reply-To: bo.li.liu@oracle.com
References: <20180111012551.14765-1-anand.jain@oracle.com>
 <20180111012551.14765-2-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180111012551.14765-2-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 11, 2018 at 09:25:50AM +0800, Anand Jain wrote:
> Support for a new command 'btrfs dev forget [dev]' is proposed here,
> to undo the effects of 'btrfs dev scan [dev]'. For this purpose,
> this patch proposes to use ioctl #5 as it was empty.
> 	IOW(BTRFS_IOCTL_MAGIC, 5, ..)
> This patch adds new ioctl BTRFS_IOC_FORGET_DEV which can be sent from
> the /dev/btrfs-control to forget one or all devices, (devices which are
> not mounted) from the btrfs kernel.
>

To me this seems to offer a debugging ability, could you please
elaborate the use case where we need to forget a particular device
instead of just wiping the uuid?

Thanks,

-liubo
> The argument it takes is struct btrfs_ioctl_vol_args_v2, and ::name can be
> set to specify the device path. And all unmounted devices can be removed
> from the kernel using the BTRFS_DEVICE_SPEC_ALL_DEV flag. Remove all
> devices functionality would override remove one device when both are
> specified in an IOCTL call.
> Again, the devices are removed only if the relevant fsid aren't mounted.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/super.c           | 27 +++++++++++++++++++++++----
>  fs/btrfs/volumes.c         |  9 +++++++++
>  fs/btrfs/volumes.h         |  1 +
>  include/uapi/linux/btrfs.h |  6 +++++-
>  4 files changed, 38 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 559fc53ff59e..6a9a5ce8af3b 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -2219,21 +2219,37 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
>  				unsigned long arg)
>  {
>  	struct btrfs_ioctl_vol_args *vol;
> +	struct btrfs_ioctl_vol_args_v2 *vol2;
>  	struct btrfs_fs_devices *fs_devices;
>  	int ret = -ENOTTY;
>  
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
>  
> -	vol = memdup_user((void __user *)arg, sizeof(*vol));
> -	if (IS_ERR(vol))
> -		return PTR_ERR(vol);
> +	if (cmd == BTRFS_IOC_FORGET_DEV) {
> +		vol2 = memdup_user((void __user *)arg, sizeof(*vol2));
> +		if (IS_ERR(vol2))
> +			return PTR_ERR(vol2);
> +
> +		if (vol2->flags & ~BTRFS_VOL_ARG_V2_FLAGS_SUPPORTED)
> +			return -EOPNOTSUPP;
> +	} else {
> +		vol = memdup_user((void __user *)arg, sizeof(*vol));
> +		if (IS_ERR(vol))
> +			return PTR_ERR(vol);
> +	}
>  
>  	switch (cmd) {
>  	case BTRFS_IOC_SCAN_DEV:
>  		ret = btrfs_scan_one_device(vol->name, FMODE_READ,
>  					    &btrfs_fs_type, &fs_devices);
>  		break;
> +	case BTRFS_IOC_FORGET_DEV:
> +		if (vol2->flags & BTRFS_DEVICE_SPEC_ALL_DEV)
> +			ret = btrfs_forget_devices(NULL);
> +		else
> +			ret = btrfs_forget_devices(vol2->name);
> +		break;
>  	case BTRFS_IOC_DEVICES_READY:
>  		ret = btrfs_scan_one_device(vol->name, FMODE_READ,
>  					    &btrfs_fs_type, &fs_devices);
> @@ -2246,7 +2262,10 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
>  		break;
>  	}
>  
> -	kfree(vol);
> +	if (cmd == BTRFS_IOC_FORGET_DEV)
> +		kfree(vol2);
> +	else
> +		kfree(vol);
>  	return ret;
>  }
>  
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index e947e47f8fff..b0c9948baf9a 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1171,6 +1171,15 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
>  	return 0;
>  }
>  
> +int btrfs_forget_devices(const char *path)
> +{
> +	mutex_lock(&uuid_mutex);
> +	btrfs_free_stale_devices(path, NULL);
> +	mutex_unlock(&uuid_mutex);
> +
> +	return 0;
> +}
> +
>  /*
>   * Look for a btrfs signature on a device. This may be called out of the mount path
>   * and we are not allowed to call set_blocksize during the scan. The superblock
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 15216fed918b..b954ca3b79a9 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -422,6 +422,7 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
>  		       fmode_t flags, void *holder);
>  int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
>  			  struct btrfs_fs_devices **fs_devices_ret);
> +int btrfs_forget_devices(const char *path);
>  int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
>  void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices, int step);
>  void btrfs_assign_next_active_device(struct btrfs_fs_info *fs_info,
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index c8d99b9ca550..4e8ec1391872 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -41,12 +41,14 @@ struct btrfs_ioctl_vol_args {
>  #define BTRFS_SUBVOL_QGROUP_INHERIT	(1ULL << 2)
>  
>  #define BTRFS_DEVICE_SPEC_BY_ID		(1ULL << 3)
> +#define BTRFS_DEVICE_SPEC_ALL_DEV	(1ULL << 4)
>  
>  #define BTRFS_VOL_ARG_V2_FLAGS_SUPPORTED		\
>  			(BTRFS_SUBVOL_CREATE_ASYNC |	\
>  			BTRFS_SUBVOL_RDONLY |		\
>  			BTRFS_SUBVOL_QGROUP_INHERIT |	\
> -			BTRFS_DEVICE_SPEC_BY_ID)
> +			BTRFS_DEVICE_SPEC_BY_ID |	\
> +			BTRFS_DEVICE_SPEC_ALL_DEV)
>  
>  #define BTRFS_FSID_SIZE 16
>  #define BTRFS_UUID_SIZE 16
> @@ -745,6 +747,8 @@ enum btrfs_err_code {
>  				   struct btrfs_ioctl_vol_args)
>  #define BTRFS_IOC_SCAN_DEV _IOW(BTRFS_IOCTL_MAGIC, 4, \
>  				   struct btrfs_ioctl_vol_args)
> +#define BTRFS_IOC_FORGET_DEV _IOW(BTRFS_IOCTL_MAGIC, 5, \
> +				   struct btrfs_ioctl_vol_args)
>  /* trans start and trans end are dangerous, and only for
>   * use by applications that know how to avoid the
>   * resulting deadlocks
> -- 
> 2.7.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
