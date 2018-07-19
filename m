Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35452 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727541AbeGSMg3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 08:36:29 -0400
Date: Thu, 19 Jul 2018 13:53:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/7] btrfs: add helper btrfs_num_devices() to deduce
 num_devices
Message-ID: <20180719115332.GI26141@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180716145812.20836-1-anand.jain@oracle.com>
 <20180716145812.20836-7-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180716145812.20836-7-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 16, 2018 at 10:58:11PM +0800, Anand Jain wrote:
> When the replace is running the fs_devices::num_devices also includes
> the replace device, however in some operations like device delete and
> balance it needs the actual num_devices without the repalce devices, so
> now the function btrfs_num_devices() just provides that.

We can't run any two from device delete, device replace or balance at
the same time.

> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v2: add comments. Thanks Nikolay.
> 
>  fs/btrfs/volumes.c | 32 ++++++++++++++++++--------------
>  1 file changed, 18 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 0f4c512aa6b4..1c0b56374992 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1844,6 +1844,21 @@ void btrfs_assign_next_active_device(struct btrfs_fs_info *fs_info,
>  		fs_info->fs_devices->latest_bdev = next_device->bdev;
>  }
>  
> +/* Returns btrfs_fs_devices::num_devices excluding replace device if any */
> +static inline u64 btrfs_num_devices(struct btrfs_fs_info *fs_info)
> +{
> +	u64 num_devices = fs_info->fs_devices->num_devices;
> +
> +	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
> +	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
> +		WARN_ON(num_devices < 1);
> +		num_devices--;
> +	}
> +	btrfs_dev_replace_read_unlock(&fs_info->dev_replace);

This does not make sense, besides that btrfs_dev_replace_is_ongoing is
always going to be false here, the locking would need to cover the whole
range where we want the num_devices to remain unchanged by other
operatons.

> +
> +	return num_devices;
> +}
> +
>  int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
>  		u64 devid)
>  {
> @@ -1857,13 +1872,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
>  
>  	mutex_lock(&uuid_mutex);
>  
> -	num_devices = fs_devices->num_devices;
> -	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
> -	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
> -		WARN_ON(num_devices < 1);
> -		num_devices--;
> -	}
> -	btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
> +	num_devices = btrfs_num_devices(fs_info);
>  
>  	ret = btrfs_check_raid_min_devices(fs_info, num_devices - 1);
>  	if (ret)
> @@ -3723,13 +3732,8 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
>  		}
>  	}
>  
> -	num_devices = fs_info->fs_devices->num_devices;
> -	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
> -	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
> -		WARN_ON(num_devices < 1);
> -		num_devices--;
> -	}
> -	btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
> +	num_devices = btrfs_num_devices(fs_info);
> +
>  	allowed = BTRFS_AVAIL_ALLOC_BIT_SINGLE | BTRFS_BLOCK_GROUP_DUP;
>  	if (num_devices > 1)
>  		allowed |= (BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1);
> -- 
> 2.7.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
