Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56718 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750983AbeGJHRm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jul 2018 03:17:42 -0400
Subject: Re: [PATCH 2/2] btrfs: get fs_devices pointer form
 btrfs_scan_one_device
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1531204433-11570-1-git-send-email-gujx@cn.fujitsu.com>
 <1531204433-11570-2-git-send-email-gujx@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <4f055eb5-4ce3-d7d0-232a-7ea568b66050@suse.com>
Date: Tue, 10 Jul 2018 10:17:40 +0300
MIME-Version: 1.0
In-Reply-To: <1531204433-11570-2-git-send-email-gujx@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10.07.2018 09:33, Gu Jinxiang wrote:
> Instead of pointer to btrfs_fs_devices as an arg in
> btrfs_scan_one_device, better to make it as a return value.
> 
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
> ---
>  fs/btrfs/super.c   | 29 ++++++++++++++++++-----------
>  fs/btrfs/volumes.c | 14 +++++++-------
>  fs/btrfs/volumes.h |  4 ++--
>  3 files changed, 27 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 4ee082e96d51..a5ddeb6836e3 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -918,11 +918,13 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
>  				error = -ENOMEM;
>  				goto out;
>  			}
> -			error = btrfs_scan_one_device(device_name,
> -					flags, holder, &fs_devices);
> +			fs_devices = btrfs_scan_one_device(device_name,
> +					flags, holder);
>  			kfree(device_name);
> -			if (error)
> +			if (IS_ERR(fs_devices)) {
> +				error = PTR_ERR(fs_devices);
>  				goto out;
> +			}
>  		}
>  	}
>  
> @@ -1539,9 +1541,11 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
>  			return ERR_PTR(error);
>  	}
>  
> -	error = btrfs_scan_one_device(device_name, mode, fs_type, &fs_devices);
> -	if (error)
> +	fs_devices = btrfs_scan_one_device(device_name, mode, fs_type);
> +	if (IS_ERR(fs_devices)) {
> +		error = PTR_ERR(fs_devices);
>  		goto error_sec_opts;
> +	}
>  
>  	/*
>  	 * Setup a dummy root and fs_info for test/set super.  This is because
> @@ -2222,7 +2226,7 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
>  				unsigned long arg)
>  {
>  	struct btrfs_ioctl_vol_args *vol;
> -	struct btrfs_fs_devices *fs_devices;
> +	struct btrfs_fs_devices *fs_devices = NULL;
>  	int ret = -ENOTTY;
>  
>  	if (!capable(CAP_SYS_ADMIN))
> @@ -2234,14 +2238,17 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
>  
>  	switch (cmd) {
>  	case BTRFS_IOC_SCAN_DEV:
> -		ret = btrfs_scan_one_device(vol->name, FMODE_READ,
> -					    &btrfs_root_fs_type, &fs_devices);
> +		fs_devices = btrfs_scan_one_device(vol->name, FMODE_READ,
> +					    &btrfs_root_fs_type);
> +		ret = IS_ERR(fs_devices) ? PTR_ERR(fs_devices) : 0;
>  		break;
>  	case BTRFS_IOC_DEVICES_READY:
> -		ret = btrfs_scan_one_device(vol->name, FMODE_READ,
> -					    &btrfs_root_fs_type, &fs_devices);
> -		if (ret)
> +		fs_devices = btrfs_scan_one_device(vol->name, FMODE_READ,
> +					    &btrfs_root_fs_type);
> +		if (IS_ERR(fs_devices)) {
> +			ret = PTR_ERR(fs_devices);
>  			break;
> +		}
>  		ret = !(fs_devices->num_devices == fs_devices->total_devices);
>  		break;
>  	case BTRFS_IOC_GET_SUPPORTED_FEATURES:
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index b33bf29130b6..922c4ad6d421 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1215,14 +1215,14 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
>   * and we are not allowed to call set_blocksize during the scan. The superblock
>   * is read via pagecache
>   */
> -int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
> -			  struct btrfs_fs_devices **fs_devices_ret)
> +struct btrfs_fs_devices *btrfs_scan_one_device(const char *path, fmode_t flags,
> +		void *holder)
>  {
>  	struct btrfs_super_block *disk_super;
>  	struct btrfs_device *device;
>  	struct block_device *bdev;
>  	struct page *page;
> -	int ret = 0;
> +	struct btrfs_fs_devices *ret = NULL;
>  	u64 bytenr;
>  
>  	/*
> @@ -1236,19 +1236,19 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
>  
>  	bdev = blkdev_get_by_path(path, flags, holder);
>  	if (IS_ERR(bdev))
> -		return PTR_ERR(bdev);
> +		return (struct btrfs_fs_devices *)bdev;

This makes my eyes bleed. There is already a construct which handles
this and it's called ERR_CAST so use it.

>  
>  	if (btrfs_read_disk_super(bdev, bytenr, &page, &disk_super)) {
> -		ret = -EINVAL;
> +		ret = ERR_PTR(-EINVAL);
>  		goto error_bdev_put;
>  	}
>  
>  	mutex_lock(&uuid_mutex);
>  	device = device_list_add(path, disk_super);
>  	if (IS_ERR(device))
> -		ret = PTR_ERR(device);
> +		ret = (struct btrfs_fs_devices *)device;
ERR_CAST

>  	else
> -		*fs_devices_ret = device->fs_devices;
> +		ret = device->fs_devices;
>  	mutex_unlock(&uuid_mutex);
>  
>  	btrfs_release_disk_super(page);
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 77e6004b6cb9..f867f07be963 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -406,8 +406,8 @@ blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
>  			   int mirror_num, int async_submit);
>  int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
>  		       fmode_t flags, void *holder);
> -int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
> -			  struct btrfs_fs_devices **fs_devices_ret);
> +struct btrfs_fs_devices *btrfs_scan_one_device(const char *path, fmode_t flags,
> +		void *holder);
>  int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
>  void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices, int step);
>  void btrfs_assign_next_active_device(struct btrfs_fs_info *fs_info,
> 
