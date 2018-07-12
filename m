Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56032 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726227AbeGLHwV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jul 2018 03:52:21 -0400
Subject: Re: [PATCH 3/3] btrfs: add helper function check device delete able
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180710182241.23754-1-anand.jain@oracle.com>
 <20180710182241.23754-3-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <caf594a1-0c04-ef34-a653-50b7210cf340@suse.com>
Date: Thu, 12 Jul 2018 10:43:57 +0300
MIME-Version: 1.0
In-Reply-To: <20180710182241.23754-3-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10.07.2018 21:22, Anand Jain wrote:
> Move the section of the code which performs the check if the device is
> indelible, move that into a helper function.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/volumes.c | 49 ++++++++++++++++++++++++++++++-------------------
>  1 file changed, 30 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 59a6d8f42c98..feb29c5b44f6 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1945,6 +1945,33 @@ static inline u64 btrfs_num_devices(struct btrfs_fs_info *fs_info)
>  	return num_devices;
>  }
>  
> +static struct btrfs_device *btrfs_device_delete_able(

Ugliest name ever! So this function is not really a predicate, rather
it's used to fetch the struct btrfs_device * to delete. So a more
becoming name would be:

btrfs_get_device_for_delete - though this a bit verbose.

I guess btrfs_can_delete_device is more suitable if you want to follow
this predicate style. At the very least, though, the correct form of the
adjective is deletable so it should be btrfs_device_deletable. But as I
said this function is not really used as a predicate.

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

Not really related to this patchset, but I think the whole
btrfs_find_device_by_devspec -> btrfs_find_device_missing_or_by_path
could be simplified by making those functions return a pointer to
btrfs_device rather than an int error value. That way you eliminate the
ugly "argument as return value" convention.

> +	if (ret)
> +		return ERR_PTR(ret);
> +
> +	if (test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state))
> +		return ERR_PTR(BTRFS_ERROR_DEV_TGT_REPLACE);
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
> @@ -1958,25 +1985,9 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
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
> +	device = btrfs_device_delete_able(fs_info, device_path, devid);
> +	if (IS_ERR(device)) {
> +		ret = PTR_ERR(device);
>  		goto out;
>  	}
>  
> 
