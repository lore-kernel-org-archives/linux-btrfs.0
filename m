Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34160 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730621AbeGSM2m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 08:28:42 -0400
Date: Thu, 19 Jul 2018 13:45:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 7/7] btrfs: add helper function check device delete able
Message-ID: <20180719114546.GH26141@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180716145812.20836-1-anand.jain@oracle.com>
 <20180716145812.20836-8-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180716145812.20836-8-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 16, 2018 at 10:58:12PM +0800, Anand Jain wrote:
> Move the section of the code which performs the check if the device is
> indelible, move that into a helper function.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v1->v2: Rename function to btrfs_get_device_for_delete(), thanks
> Nikolay.
> 
>  fs/btrfs/volumes.c | 49 ++++++++++++++++++++++++++++++-------------------
>  1 file changed, 30 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 1c0b56374992..0cefc24b028c 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1859,6 +1859,33 @@ static inline u64 btrfs_num_devices(struct btrfs_fs_info *fs_info)
>  	return num_devices;
>  }
>  
> +static struct btrfs_device *btrfs_get_device_for_delete(
> +				struct btrfs_fs_info *fs_info,
> +				const char *device_path, u64 devid)
> +{
> +	int ret;
> +	struct btrfs_device *device;
> +
> +	ret = btrfs_check_raid_min_devices(fs_info,
> +					   btrfs_num_devices(fs_info) - 1);
> +	if (ret)
> +		return ERR_PTR(ret);
> +
> +	ret = btrfs_find_device_by_devspec(fs_info, devid, device_path,
> +					   &device);
> +	if (ret)
> +		return ERR_PTR(ret);
> +
> +	if (test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state))
> +		return ERR_PTR(BTRFS_ERROR_DEV_TGT_REPLACE);

This is wrong, the BTRFS_ERROR valueas are >= 1, but the IS_ERR, ERR_PTR
work for errno values -4095..0 .

Thouth ERR_PTR would cast the integer into pointer, the callers of
btrfs_get_device_for_delete will not detect the error and continue.

> +
> +	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state) &&
> +	    fs_info->fs_devices->rw_devices == 1)
> +		return ERR_PTR(BTRFS_ERROR_DEV_ONLY_WRITABLE);
> +
> +	return device;
> +}
> +
>  int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
>  		u64 devid)
>  {
> @@ -1872,25 +1899,9 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
>  
>  	mutex_lock(&uuid_mutex);
>  
> -	num_devices = btrfs_num_devices(fs_info);
> -
> -	ret = btrfs_check_raid_min_devices(fs_info, num_devices - 1);
> -	if (ret)
> -		goto out;
> -
> -	ret = btrfs_find_device_by_devspec(fs_info, devid, device_path,
> -					   &device);
> -	if (ret)
> -		goto out;
> -
> -	if (test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state)) {
> -		ret = BTRFS_ERROR_DEV_TGT_REPLACE;
> -		goto out;
> -	}
> -
> -	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state) &&
> -	    fs_info->fs_devices->rw_devices == 1) {
> -		ret = BTRFS_ERROR_DEV_ONLY_WRITABLE;
> +	device = btrfs_get_device_for_delete(fs_info, device_path, devid);
> +	if (IS_ERR(device)) {

BTRFS_ERROR_DEV_ONLY_WRITABLE won't work here.

> +		ret = PTR_ERR(device);
>  		goto out;
>  	}
>  
> -- 
> 2.7.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
