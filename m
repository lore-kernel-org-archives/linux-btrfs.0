Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:59509 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727186AbeICQrh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Sep 2018 12:47:37 -0400
Subject: Re: [PATCH 3/3] btrfs: Make btrfs_find_device_by_devspec return
 btrfs_device directly
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20180903094614.2667-1-nborisov@suse.com>
 <20180903094614.2667-4-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <22e93018-f703-8ea5-d603-b414413c5791@gmx.com>
Date: Mon, 3 Sep 2018 20:27:33 +0800
MIME-Version: 1.0
In-Reply-To: <20180903094614.2667-4-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018/9/3 下午5:46, Nikolay Borisov wrote:
> Instead of returning an error value and using one of the parameters for
> returning the actual object we are interested in just refactor the
> function to directly return btrfs_device *. Also bubble up the error
> handling for the special BTRFS_ERROR_DEV_MISSING_NOT_FOUND value into
> btrfs_rm_device. No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  fs/btrfs/dev-replace.c |  8 ++++----
>  fs/btrfs/volumes.c     | 40 +++++++++++++++++++---------------------
>  fs/btrfs/volumes.h     |  6 +++---
>  3 files changed, 26 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index dec01970d8c5..4e2b67d06305 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -409,10 +409,10 @@ int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
>  	struct btrfs_device *tgt_device = NULL;
>  	struct btrfs_device *src_device = NULL;
>  
> -	ret = btrfs_find_device_by_devspec(fs_info, srcdevid,
> -					    srcdev_name, &src_device);
> -	if (ret)
> -		return ret;
> +	src_device = btrfs_find_device_by_devspec(fs_info, srcdevid,
> +						  srcdev_name);
> +	if (IS_ERR(src_device))
> +		return PTR_ERR(src_device);
>  
>  	ret = btrfs_init_dev_replace_tgtdev(fs_info, tgtdev_name,
>  					    src_device, &tgt_device);
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 6202aa15d0d7..ce336b39fa0f 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1877,10 +1877,16 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
>  	if (ret)
>  		goto out;
>  
> -	ret = btrfs_find_device_by_devspec(fs_info, devid, device_path,
> -					   &device);
> -	if (ret)
> +	device = btrfs_find_device_by_devspec(fs_info, devid, device_path);
> +
> +	if (IS_ERR(device)) {
> +		if (PTR_ERR(device) == -ENOENT &&
> +		    strcmp(device_path, "missing") == 0)
> +			ret = BTRFS_ERROR_DEV_MISSING_NOT_FOUND;
> +		else
> +			ret = PTR_ERR(device);
>  		goto out;
> +	}
>  
>  	if (test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state)) {
>  		ret = BTRFS_ERROR_DEV_TGT_REPLACE;
> @@ -2153,30 +2159,22 @@ btrfs_find_device_missing_or_by_path(struct btrfs_fs_info *fs_info,
>  /*
>   * Lookup a device given by device id, or the path if the id is 0.
>   */
> -int btrfs_find_device_by_devspec(struct btrfs_fs_info *fs_info, u64 devid,
> -				 const char *devpath,
> -				 struct btrfs_device **device)
> +struct btrfs_device *
> +btrfs_find_device_by_devspec(struct btrfs_fs_info *fs_info, u64 devid,
> +			     const char *devpath)
>  {
> -	int ret = 0;
> +	struct btrfs_device *device;
>  
>  	if (devid) {
> -		*device = btrfs_find_device(fs_info, devid, NULL, NULL);
> -		if (!*device)
> -			ret = -ENOENT;
> +		device = btrfs_find_device(fs_info, devid, NULL, NULL);
> +		if (!device)
> +			return ERR_PTR(-ENOENT);
>  	} else {
>  		if (!devpath || !devpath[0])
> -			return -EINVAL;
> -
> -		*device = btrfs_find_device_missing_or_by_path(fs_info, devpath);
> -		if (IS_ERR(*device)) {
> -			if (PTR_ERR(*device) == -ENOENT &&
> -			    strcmp(devpath, "missing") == 0)
> -				ret = BTRFS_ERROR_DEV_MISSING_NOT_FOUND;
> -			else
> -				ret = PTR_ERR(*device);
> -		}
> +			return ERR_PTR(-EINVAL);
> +		device = btrfs_find_device_missing_or_by_path(fs_info, devpath);
>  	}
> -	return ret;
> +	return device;
>  }
>  
>  /*
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index e7811473024d..aefce895e994 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -410,9 +410,9 @@ int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
>  void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices, int step);
>  void btrfs_assign_next_active_device(struct btrfs_device *device,
>  				     struct btrfs_device *this_dev);
> -int btrfs_find_device_by_devspec(struct btrfs_fs_info *fs_info, u64 devid,
> -					 const char *devpath,
> -					 struct btrfs_device **device);
> +struct btrfs_device *btrfs_find_device_by_devspec(struct btrfs_fs_info *fs_info,
> +						  u64 devid,
> +						  const char *devpath);
>  struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
>  					const u64 *devid,
>  					const u8 *uuid);
> 
