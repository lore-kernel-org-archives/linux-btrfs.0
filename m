Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39717 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750991AbdJTM0l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Oct 2017 08:26:41 -0400
Subject: Re: [PATCH 1/2] btrfs: match btrfs_device->mode same as it used for
 open
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20171020103325.9595-1-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <dd850164-a7fa-b7d4-9c5c-4bf497289a66@suse.com>
Date: Fri, 20 Oct 2017 15:26:38 +0300
MIME-Version: 1.0
In-Reply-To: <20171020103325.9595-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 20.10.2017 13:33, Anand Jain wrote:
> We aren't saving the fmode_t flags at %struct btrfs_device->mode same
> as it used to open the device at device replace, so fix that.

I think this could use a bit of rewording to better explain what the
problem and what it can potentially cause.

> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/volumes.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index b39737568c22..765c2bd2d8d9 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2323,12 +2323,12 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
>  	u64 tmp;
>  	int seeding_dev = 0;
>  	int ret = 0;
> +	fmode_t flag = FMODE_WRITE | FMODE_EXCL;
>  
>  	if (sb_rdonly(sb) && !fs_info->fs_devices->seeding)
>  		return -EROFS;
>  
> -	bdev = blkdev_get_by_path(device_path, FMODE_WRITE | FMODE_EXCL,
> -				  fs_info->bdev_holder);
> +	bdev = blkdev_get_by_path(device_path, flag, fs_info->bdev_holder);
>  	if (IS_ERR(bdev))
>  		return PTR_ERR(bdev);
>  
> @@ -2392,7 +2392,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
>  	device->bdev = bdev;
>  	device->in_fs_metadata = 1;
>  	device->is_tgtdev_for_dev_replace = 0;
> -	device->mode = FMODE_EXCL;
> +	device->mode = flag;

So the actual bug being fixed by this patch is that currently we aren't
setting the FMODE_WRITE when initializing btrfs_device structure and
when calling blkdev_put, correct?

>  	device->dev_stats_valid = 1;
>  	set_blocksize(device->bdev, BTRFS_BDEV_BLOCKSIZE);
>  
> @@ -2506,7 +2506,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
>  	btrfs_sysfs_rm_device_link(fs_info->fs_devices, device);
>  	kfree(device);
>  error:
> -	blkdev_put(bdev, FMODE_EXCL);
> +	blkdev_put(bdev, flag);
>  	if (seeding_dev) {
>  		mutex_unlock(&uuid_mutex);
>  		up_write(&sb->s_umount);
> @@ -2526,6 +2526,7 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
>  	struct rcu_string *name;
>  	u64 devid = BTRFS_DEV_REPLACE_DEVID;
>  	int ret = 0;
> +	fmode_t flags = FMODE_WRITE | FMODE_EXCL;
>  
>  	*device_out = NULL;
>  	if (fs_info->fs_devices->seeding) {
> @@ -2533,8 +2534,7 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
>  		return -EINVAL;
>  	}
>  
> -	bdev = blkdev_get_by_path(device_path, FMODE_WRITE | FMODE_EXCL,
> -				  fs_info->bdev_holder);
> +	bdev = blkdev_get_by_path(device_path, flags, fs_info->bdev_holder);
>  	if (IS_ERR(bdev)) {
>  		btrfs_err(fs_info, "target device %s is invalid!", device_path);
>  		return PTR_ERR(bdev);
> @@ -2595,7 +2595,7 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
>  	device->bdev = bdev;
>  	device->in_fs_metadata = 1;
>  	device->is_tgtdev_for_dev_replace = 1;
> -	device->mode = FMODE_EXCL;
> +	device->mode = flags;
>  	device->dev_stats_valid = 1;
>  	set_blocksize(device->bdev, BTRFS_BDEV_BLOCKSIZE);
>  	device->fs_devices = fs_info->fs_devices;
> @@ -2608,7 +2608,7 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
>  	return ret;
>  
>  error:
> -	blkdev_put(bdev, FMODE_EXCL);
> +	blkdev_put(bdev, flags);
>  	return ret;
>  }
>  
> 
