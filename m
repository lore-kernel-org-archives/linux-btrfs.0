Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:55908 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726398AbeGKJiu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Jul 2018 05:38:50 -0400
Subject: Re: [PATCH v3 2/2] btrfs: get fs_devices pointer form
 btrfs_scan_one_device
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Cc: nborisov@suse.com
References: <1531272178-17471-1-git-send-email-gujx@cn.fujitsu.com>
 <1531272178-17471-2-git-send-email-gujx@cn.fujitsu.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <129950c6-ab51-a15a-a9ba-c696d9edeb67@oracle.com>
Date: Wed, 11 Jul 2018 17:38:37 +0800
MIME-Version: 1.0
In-Reply-To: <1531272178-17471-2-git-send-email-gujx@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/11/2018 09:22 AM, Gu Jinxiang wrote:
> Instead of pointer to btrfs_fs_devices as an arg in
> btrfs_scan_one_device, better to make it as a return value.

Yep this was in the list to fix. However I didn't like the idea
to return the btrfs_fs_devices pointer, instead return the
btrfs_device pointer, so that we can still retrieve its fs_devices.

Thanks, Anand

> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
> ---
> 
> Changelog:
> v3: as comment by robot, use PTR_ERR_OR_ZERO, and rebase to misc-next.
> v2: as comment by Nikolay, use ERR_CAST instead of cast type manually.
> 
>   fs/btrfs/super.c   | 29 ++++++++++++++++++-----------
>   fs/btrfs/volumes.c | 14 +++++++-------
>   fs/btrfs/volumes.h |  4 ++--
>   3 files changed, 27 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 78b5d51c7bc7..20e1ee338a95 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -916,11 +916,13 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
>   				error = -ENOMEM;
>   				goto out;
>   			}
> -			error = btrfs_scan_one_device(device_name,
> -					flags, holder, &fs_devices);
> +			fs_devices = btrfs_scan_one_device(device_name,
> +					flags, holder);
>   			kfree(device_name);
> -			if (error)
> +			if (IS_ERR(fs_devices)) {
> +				error = PTR_ERR(fs_devices);
>   				goto out;
> +			}
>   		}
>   	}
>   
> @@ -1537,9 +1539,11 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
>   			return ERR_PTR(error);
>   	}
>   
> -	error = btrfs_scan_one_device(device_name, mode, fs_type, &fs_devices);
> -	if (error)
> +	fs_devices = btrfs_scan_one_device(device_name, mode, fs_type);
> +	if (IS_ERR(fs_devices)) {
> +		error = PTR_ERR(fs_devices);
>   		goto error_sec_opts;
> +	}
>   
>   	/*
>   	 * Setup a dummy root and fs_info for test/set super.  This is because
> @@ -2220,7 +2224,7 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
>   				unsigned long arg)
>   {
>   	struct btrfs_ioctl_vol_args *vol;
> -	struct btrfs_fs_devices *fs_devices;
> +	struct btrfs_fs_devices *fs_devices = NULL;
>   	int ret = -ENOTTY;
>   
>   	if (!capable(CAP_SYS_ADMIN))
> @@ -2232,14 +2236,17 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
>   
>   	switch (cmd) {
>   	case BTRFS_IOC_SCAN_DEV:
> -		ret = btrfs_scan_one_device(vol->name, FMODE_READ,
> -					    &btrfs_root_fs_type, &fs_devices);
> +		fs_devices = btrfs_scan_one_device(vol->name, FMODE_READ,
> +					    &btrfs_root_fs_type);
> +		ret = PTR_ERR_OR_ZERO(fs_devices);
>   		break;
>   	case BTRFS_IOC_DEVICES_READY:
> -		ret = btrfs_scan_one_device(vol->name, FMODE_READ,
> -					    &btrfs_root_fs_type, &fs_devices);
> -		if (ret)
> +		fs_devices = btrfs_scan_one_device(vol->name, FMODE_READ,
> +					    &btrfs_root_fs_type);
> +		if (IS_ERR(fs_devices)) {
> +			ret = PTR_ERR(fs_devices);
>   			break;
> +		}
>   		ret = !(fs_devices->num_devices == fs_devices->total_devices);
>   		break;
>   	case BTRFS_IOC_GET_SUPPORTED_FEATURES:
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index af2704de9ff9..6a6321e41f1b 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1212,14 +1212,14 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
>    * and we are not allowed to call set_blocksize during the scan. The superblock
>    * is read via pagecache
>    */
> -int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
> -			  struct btrfs_fs_devices **fs_devices_ret)
> +struct btrfs_fs_devices *btrfs_scan_one_device(const char *path, fmode_t flags,
> +		void *holder)
>   {
>   	struct btrfs_super_block *disk_super;
>   	struct btrfs_device *device;
>   	struct block_device *bdev;
>   	struct page *page;
> -	int ret = 0;
> +	struct btrfs_fs_devices *ret = NULL;
>   	u64 bytenr;
>   
>   	/*
> @@ -1233,19 +1233,19 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
>   
>   	bdev = blkdev_get_by_path(path, flags, holder);
>   	if (IS_ERR(bdev))
> -		return PTR_ERR(bdev);
> +		return ERR_CAST(bdev);
>   
>   	if (btrfs_read_disk_super(bdev, bytenr, &page, &disk_super)) {
> -		ret = -EINVAL;
> +		ret = ERR_PTR(-EINVAL);
>   		goto error_bdev_put;
>   	}
>   
>   	mutex_lock(&uuid_mutex);
>   	device = device_list_add(path, disk_super);
>   	if (IS_ERR(device))
> -		ret = PTR_ERR(device);
> +		ret = ERR_CAST(device);
>   	else
> -		*fs_devices_ret = device->fs_devices;
> +		ret = device->fs_devices;
>   	mutex_unlock(&uuid_mutex);
>   
>   	btrfs_release_disk_super(page);
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 275c31c730cf..d8f0b6f85e35 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -405,8 +405,8 @@ blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
>   			   int mirror_num, int async_submit);
>   int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
>   		       fmode_t flags, void *holder);
> -int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
> -			  struct btrfs_fs_devices **fs_devices_ret);
> +struct btrfs_fs_devices *btrfs_scan_one_device(const char *path, fmode_t flags,
> +		void *holder);
>   int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
>   void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices, int step);
>   void btrfs_assign_next_active_device(struct btrfs_fs_info *fs_info,
> 
