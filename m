Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41606 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933242AbdLRMBs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Dec 2017 07:01:48 -0500
Subject: Re: [PATCH v3] btrfs: handle dynamically reappearing missing device
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20171217030458.25885-1-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <59867b1d-4e24-2a7f-6e99-d10bc068d919@suse.com>
Date: Mon, 18 Dec 2017 14:01:46 +0200
MIME-Version: 1.0
In-Reply-To: <20171217030458.25885-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 17.12.2017 05:04, Anand Jain wrote:
> If the device is not present at the time of (-o degrade) mount,
> the mount context will create a dummy missing struct btrfs_device.
> Later this device may reappear after the FS is mounted and
> then device is included in the device list but it missed the
> open_device part. So this patch handles that case by going
> through the open_device steps which this device missed and finally
> adds to the device alloc list.
> 
> So now with this patch, to bring back the missing device user can run,
> 
>    btrfs dev scan <path-of-missing-device>
> 
> Without this kernel patch, even though 'btrfs fi show' and 'btrfs
> dev ready' would tell you that missing device has reappeared
> successfully but actually in kernel FS layer it didn't.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> This patch needs:
>  [PATCH 0/4]  factor __btrfs_open_devices()
> v3:
> The check for missing in the device_list_add() is now a another
> patch as its not related.
>  btrfs: fix inconsistency during missing device rejoin
> 
> v2:
> Add more comments.
> Add more change log.
> Add to check if device missing is set, to handle the case
> dev open fail and user will rerun the dev scan.
> 
>  fs/btrfs/volumes.c | 57 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 55 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 93d65c72b731..5c3190c65f81 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -812,8 +812,61 @@ static noinline int device_list_add(const char *path,
>  		rcu_string_free(device->name);
>  		rcu_assign_pointer(device->name, name);
>  		if (test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state)) {
> -			fs_devices->missing_devices--;
> -			clear_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state);
> +			int ret;
> +			struct btrfs_fs_info *fs_info = fs_devices->fs_info;
> +			fmode_t fmode = FMODE_READ | FMODE_WRITE | FMODE_EXCL;
> +
> +			if (btrfs_super_flags(disk_super) &
> +					BTRFS_SUPER_FLAG_SEEDING)
> +				fmode &= ~FMODE_WRITE;
> +
> +			/*
> +			 * Missing can be set only when FS is mounted.
> +			 * So here its always fs_devices->opened > 0 and most
> +			 * of the struct device members are already updated by
> +			 * the mount process even if this device was missing, so
> +			 * now follow the normal open device procedure for this
> +			 * device. The scrub will take care of filling the

So how is scrub supposed to be initiated - automatically or by the user
since it's assumed he will have seen the message that a device has been
added? Reading the comment I'd expect scrub is kicked automatically.

> +			 * missing stripes for raid56 and balance for raid1 and
> +			 * raid10.
> +			 */
> +			ASSERT(fs_devices->opened);
> +			mutex_lock(&fs_devices->device_list_mutex);
> +			mutex_lock(&fs_info->chunk_mutex);
> +			/*
> +			 * As of now do not fail the dev scan thread for the
> +			 * reason that btrfs_open_one_device() fails and keep
> +			 * the legacy dev scan requisites as it is.
> +			 * And reset missing only if open is successful, as
> +			 * user can rerun dev scan after fixing the device
> +			 * for which the device open (below) failed.
> +			 */
> +			ret = btrfs_open_one_device(fs_devices, device, fmode,
> +							fs_info->bdev_holder);
> +			if (!ret) {
> +				fs_devices->missing_devices--;
> +				clear_bit(BTRFS_DEV_STATE_MISSING,
> +							&device->dev_state);
> +				btrfs_clear_opt(fs_info->mount_opt, DEGRADED);
> +				btrfs_warn(fs_info,
> +					"BTRFS: device %s devid %llu joined\n",
> +					path, devid);

why do we have to warn, this is considered to be a "good" thing so
perhaps btrfs_info?

> +			}
> +
> +			if (test_bit(BTRFS_DEV_STATE_WRITEABLE,
> +				     &device->dev_state) &&

Can a device that is missing really be writable? So we have 2 cases
where we add a missing device:

1. Is via add_missing_dev which sets dev_state_missing so writable will
be false.

2. In read_one_dev when we have successfully found the device from
btrfs_find_device but it doesn't have a ->bdev member, in which case we
don't really clear the writable fact (but perhaps we should) ?

Overall the lifecycle of these flags is not very clear ;\

> +			    !test_bit(BTRFS_DEV_STATE_REPLACE_TGT,
> +				      &device->dev_state)) {
> +				fs_devices->total_rw_bytes +=
> +							device->total_bytes;
> +				atomic64_add(device->total_bytes -
> +						device->bytes_used,
> +						&fs_info->free_chunk_space);
> +			}
> +			set_bit(BTRFS_DEV_STATE_IN_FS_METADATA,
> +							&device->dev_state);
> +			mutex_unlock(&fs_info->chunk_mutex);
> +			mutex_unlock(&fs_devices->device_list_mutex);
>  		}
>  	}
>  
> 
