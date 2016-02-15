Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59822 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbcBOQrv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Feb 2016 11:47:51 -0500
Date: Mon, 15 Feb 2016 17:47:46 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 09/13] btrfs: make use of
 btrfs_find_device_by_user_input()
Message-ID: <20160215164746.GM4374@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1455328900-1476-1-git-send-email-anand.jain@oracle.com>
 <1455328900-1476-10-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1455328900-1476-10-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 13, 2016 at 10:01:36AM +0800, Anand Jain wrote:
> btrfs_rm_device() has a section of the code which can be replaced
> btrfs_find_device_by_user_input()
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/volumes.c | 100 ++++++++++++++++++++---------------------------------
>  1 file changed, 37 insertions(+), 63 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 889fc0c..1324a9f 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1750,13 +1750,11 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
>  {
>  	struct btrfs_device *device;
>  	struct btrfs_device *next_device;
> -	struct block_device *bdev;
> +	struct block_device *bdev = NULL;
>  	struct buffer_head *bh = NULL;
> -	struct btrfs_super_block *disk_super;
> +	struct btrfs_super_block *disk_super = NULL;

disk_super is NULL here and unchanged until ...

>  	struct btrfs_fs_devices *cur_devices;
> -	u64 devid;
>  	u64 num_devices;
> -	u8 *dev_uuid;
>  	int ret = 0;
>  	bool clear_super = false;
>  
> @@ -1766,57 +1764,19 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
>  	if (ret)
>  		goto out;
>  
> -	if (strcmp(device_path, "missing") == 0) {
> -		struct list_head *devices;
> -		struct btrfs_device *tmp;
> -
> -		device = NULL;
> -		devices = &root->fs_info->fs_devices->devices;
> -		/*
> -		 * It is safe to read the devices since the volume_mutex
> -		 * is held.
> -		 */
> -		list_for_each_entry(tmp, devices, dev_list) {
> -			if (tmp->in_fs_metadata &&
> -			    !tmp->is_tgtdev_for_dev_replace &&
> -			    !tmp->bdev) {
> -				device = tmp;
> -				break;
> -			}
> -		}
> -		bdev = NULL;
> -		bh = NULL;
> -		disk_super = NULL;
> -		if (!device) {
> -			ret = BTRFS_ERROR_DEV_MISSING_NOT_FOUND;
> -			goto out;
> -		}
> -	} else {
> -		ret = btrfs_get_bdev_and_sb(device_path,
> -					    FMODE_WRITE | FMODE_EXCL,
> -					    root->fs_info->bdev_holder, 0,
> -					    &bdev, &bh);
> -		if (ret)
> -			goto out;
> -		disk_super = (struct btrfs_super_block *)bh->b_data;
> -		devid = btrfs_stack_device_id(&disk_super->dev_item);
> -		dev_uuid = disk_super->dev_item.uuid;
> -		device = btrfs_find_device(root->fs_info, devid, dev_uuid,
> -					   disk_super->fsid);
> -		if (!device) {
> -			ret = -ENOENT;
> -			goto error_brelse;
> -		}
> -	}
> +	ret = btrfs_find_device_by_user_input(root, 0, device_path,
> +				&device);
> +	if (ret)
> +		goto out;
>  
>  	if (device->is_tgtdev_for_dev_replace) {
>  		ret = BTRFS_ERROR_DEV_TGT_REPLACE;
> -		goto error_brelse;
> +		goto out;
>  	}
>  
>  	if (device->writeable && root->fs_info->fs_devices->rw_devices == 1) {
>  		ret = BTRFS_ERROR_DEV_ONLY_WRITABLE;
> -		goto error_brelse;
> +		goto out;
>  	}
>  
>  	if (device->writeable) {
> @@ -1906,16 +1866,33 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
>  	 * at this point, the device is zero sized.  We want to
>  	 * remove it from the devices list and zero out the old super
>  	 */
> -	if (clear_super && disk_super) {
> +	if (clear_super) {
>  		u64 bytenr;
>  		int i;
>  
> +		if (!disk_super) {

... here, so this will always take this branch

> +			ret = btrfs_get_bdev_and_sb(device_path,
> +					FMODE_WRITE | FMODE_EXCL,
> +					root->fs_info->bdev_holder, 0,
> +					&bdev, &bh);
> +			if (ret) {
> +				/*
> +				 * It could be a failed device ok for clear_super
> +				 * to fail. So return success
> +				 */
> +				ret = 0;
> +				goto out;
> +			}
> +
> +			disk_super = (struct btrfs_super_block *)bh->b_data;
> +		}

The patch looks otherwise good so I'm curious if this is a leftover or
I'm missing some logic behind that.
