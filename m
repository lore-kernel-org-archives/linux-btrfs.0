Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60769 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751177AbdLET0e (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 14:26:34 -0500
Date: Tue, 5 Dec 2017 20:24:34 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 2/2] btrfs: introduce feature to ignore a btrfs device
Message-ID: <20171205192434.GW3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171205085258.4038-1-anand.jain@oracle.com>
 <20171205085258.4038-4-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171205085258.4038-4-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 05, 2017 at 04:52:58PM +0800, Anand Jain wrote:
> Support for a new command is being added here:
>  btrfs dev ignore <dev>
> Which shall undo the effects of the command
>  btrfs dev scan <dev>
> 
> This cli/ioctl is needed as there is no way to continue to mount in
> degraded mode if the device is already scanned, which is required to
> recover from the split brain raid conditions.
> 
> This patch proposes to use ioctl #5 as it was empty.
> 	IOW(BTRFS_IOCTL_MAGIC, 5, ..)
> If #5 is reserved for some other purpose, I think I should change this.

I think 5 is free for use.

> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v2: Use -EBUSY instead of -ENOENT
>     Since now delete_device_from_list() holds device_list_mutex
>     so dont hold device_list_mutex in its parent. Reword and indent
>     pr_err/info.
> v3: Send to correct ML
> v4: no change.
> 
>  fs/btrfs/super.c           |  4 +++
>  fs/btrfs/volumes.c         | 64 ++++++++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/volumes.h         |  2 ++
>  include/uapi/linux/btrfs.h |  2 ++
>  4 files changed, 72 insertions(+)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index f443517fa2f8..fcc4a6ef4795 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -2212,6 +2212,10 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
>  		ret = btrfs_scan_one_device(vol->name, FMODE_READ,
>  					    &btrfs_fs_type, &fs_devices);
>  		break;
> +	case BTRFS_IOC_IGNORE_DEV:
> +		ret = btrfs_ignore_one_device(vol->name, FMODE_READ,
> +					    &btrfs_fs_type, &fs_devices);
> +		break;
>  	case BTRFS_IOC_DEVICES_READY:
>  		ret = btrfs_scan_one_device(vol->name, FMODE_READ,
>  					    &btrfs_fs_type, &fs_devices);
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 5deda80316f0..2bae2ccd262d 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1205,6 +1205,70 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
>  	return 0;
>  }
>  
> +static int device_list_remove(struct btrfs_super_block *disk_super, u64 devid)
> +{
> +	int ret = 0;
> +	struct btrfs_fs_devices *fs_devices;
> +	struct btrfs_device *device;
> +
> +	fs_devices = find_fsid(disk_super->fsid);

Don't we need uuid mutext to call find_fsid? All other users do that.

> +	if (!fs_devices)
> +		return -ENOENT;
> +
> +	if (fs_devices->opened)
> +		return -EBUSY;
> +
> +	mutex_lock(&uuid_mutex);
> +
> +	device = find_device(fs_devices, devid, disk_super->dev_item.uuid);
> +	if (device)
> +		delete_device_from_list(device);
> +
> +	mutex_unlock(&uuid_mutex);
> +
> +	return ret;
> +}
> +
> +int btrfs_ignore_one_device(const char *path, fmode_t flags, void *holder,
> +			  struct btrfs_fs_devices **fs_devices_ret)
> +{
> +	struct btrfs_super_block *disk_super;
> +	struct block_device *bdev;
> +	struct page *page;
> +	int ret = -EINVAL;

Please move EINVAL to the point where this happens (ie. after the
btrfs_read_disk_super call). This is the common pattern and makes
reading the code smooth.

> +	u64 devid;
> +	u64 bytenr;
> +
> +	bytenr = btrfs_sb_offset(0);
> +	flags |= FMODE_EXCL;
> +
> +	bdev = blkdev_get_by_path(path, flags, holder);
> +	if (IS_ERR(bdev)) {
> +		ret = PTR_ERR(bdev);
> +		goto error;
> +	}
> +
> +	if (btrfs_read_disk_super(bdev, bytenr, &page, &disk_super))
> +		goto error_bdev_put;
> +
> +	devid = btrfs_stack_device_id(&disk_super->dev_item);
> +
> +	ret = device_list_remove(disk_super, devid);
> +	if (ret)
> +		pr_err("BTRFS: %pU device %s devid %llu failed to ignore: %d\n",
> +			disk_super->fsid, path, devid, ret);

So we can't easily use btrfs_printk here due to lack of fs_info that
would appear as "<unknown>" in place of the device. Ok.

> +	else
> +		pr_info("BTRFS: %pU device %s devid %llu ignored\n",
> +			disk_super->fsid, path, devid);
> +
> +	btrfs_release_disk_super(page);
> +
> +error_bdev_put:
> +	blkdev_put(bdev, flags);
> +error:
> +	return ret;
> +}
> +
>  /*
>   * Look for a btrfs signature on a device. This may be called out of the mount path
>   * and we are not allowed to call set_blocksize during the scan. The superblock
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 7acfd61611aa..08d3425bc880 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -423,6 +423,8 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
>  		       fmode_t flags, void *holder);
>  int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
>  			  struct btrfs_fs_devices **fs_devices_ret);
> +int btrfs_ignore_one_device(const char *path, fmode_t flags, void *holder,
> +			  struct btrfs_fs_devices **fs_devices_ret);
>  int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
>  void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices, int step);
>  void btrfs_assign_next_active_device(struct btrfs_fs_info *fs_info,
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index ce615b75e855..bb13bad41b30 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -744,6 +744,8 @@ enum btrfs_err_code {
>  				   struct btrfs_ioctl_vol_args)
>  #define BTRFS_IOC_SCAN_DEV _IOW(BTRFS_IOCTL_MAGIC, 4, \
>  				   struct btrfs_ioctl_vol_args)
> +#define BTRFS_IOC_IGNORE_DEV _IOW(BTRFS_IOCTL_MAGIC, 5, \
> +				   struct btrfs_ioctl_vol_args)

While reading the patches, I realized we may want to extend the ioctl to
unregister/forge all devices that are not currently mounted. For that
purpose using the btrfs_ioctl_vol_args_v2 would be suitable as it has
more struct members.

Another extension is to unregister only stale devices (when there's no
device node under /dev), eg. after the device is unuplugged and readded
by another name.
