Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17903 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759925AbdKPX23 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Nov 2017 18:28:29 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAGNSSva002198
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Nov 2017 23:28:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vAGNSSsT026412
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Nov 2017 23:28:28 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vAGNSSEV024253
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Nov 2017 23:28:28 GMT
Date: Thu, 16 Nov 2017 15:28:27 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: handle dynamically reappearing missing device
Message-ID: <20171116232826.GB23614@dhcp-whq-twvpn-1-vpnpool-10-159-142-193.vpn.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <20171112105650.3248-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171112105650.3248-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 12, 2017 at 06:56:50PM +0800, Anand Jain wrote:
> If the device is not present at the time of (-o degrade) mount
> the mount context will create a dummy missing struct btrfs_device.
> Later this device may reappear after the FS is mounted.

This commit log doesn't explain what would happen when the missing
device re-appears.

> So this
> patch handles that case by going through the open_device steps
> which this device missed and finally adds to the device alloc list.
> 
> So now with this patch, to bring back the missing device user can run,
> 
>    btrfs dev scan <path-of-missing-device>

Most common distros already have some udev rules of btrfs to process a
reappeared disk.

> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> This patch needs:
>  [PATCH 0/4]  factor __btrfs_open_devices()
> 
>  fs/btrfs/volumes.c | 43 +++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 41 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index d24e966ee29f..e7dd996831f2 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -769,8 +769,47 @@ static noinline int device_list_add(const char *path,
>  		rcu_string_free(device->name);
>  		rcu_assign_pointer(device->name, name);
>  		if (device->missing) {
> -			fs_devices->missing_devices--;
> -			device->missing = 0;
> +			int ret;
> +			struct btrfs_fs_info *fs_info = fs_devices->fs_info;
> +			fmode_t fmode = FMODE_READ | FMODE_WRITE | FMODE_EXCL;
> +
> +			if (btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_SEEDING)
> +				fmode &= ~FMODE_WRITE;
> +
> +			/*
> +			 * Missing can be set only when FS is mounted.
> +			 * So here its always fs_devices->opened > 0 and most
> +			 * of the struct device members are already updated by
> +			 * the mount process even if this device was missing, so
> +			 * now follow the normal open device procedure for this
> +			 * device. The scrub will take care of filling the
> +			 * missing stripes for raid56 and balance for raid1 and
> +			 * raid10.
> +			 */


The idea looks good to me.

What if users skip balance/scrub given both could take a while?

Then btrfs takes the disks back and reads content from it, and it's OK
for raid1/10 as they may have a good copy, but in case of raid56, it
might hit the reconstruction bug if two disks are missing and added
back, which I tried to address recently.

At least ->writable should not be set until balance/scrub completes
the re-sync job.

Thanks,

-liubo

> +			ASSERT(fs_devices->opened);
> +			mutex_lock(&fs_devices->device_list_mutex);
> +			mutex_lock(&fs_info->chunk_mutex);
> +			ret = btrfs_open_one_device(fs_devices, device, fmode,
> +							fs_info->bdev_holder);
> +			if (!ret) {
> +				fs_devices->missing_devices--;
> +				device->missing = 0;
> +				btrfs_clear_opt(fs_info->mount_opt, DEGRADED);
> +				btrfs_warn(fs_info,
> +					"BTRFS: device %s devid %llu uuid %pU joined\n",
> +					path, devid, device->uuid);
> +			}
> +
> +			if (device->writeable &&
> +					!device->is_tgtdev_for_dev_replace) {
> +				fs_devices->total_rw_bytes += device->total_bytes;
> +				atomic64_add(device->total_bytes -
> +						device->bytes_used,
> +						&fs_info->free_chunk_space);
> +			}
> +			device->in_fs_metadata = 1;
> +			mutex_unlock(&fs_devices->fs_info->chunk_mutex);
> +			mutex_unlock(&fs_devices->device_list_mutex);
>  		}
>  	}
>  
> -- 
> 2.13.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
