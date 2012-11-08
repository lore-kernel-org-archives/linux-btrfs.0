Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47426 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976Ab2KHOZZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Nov 2012 09:25:25 -0500
Date: Thu, 8 Nov 2012 22:24:51 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 07/26] Btrfs: add two more find_device() methods
Message-ID: <20121108142450.GA3034@gmail.com>
References: <cover.1352217243.git.sbehrens@giantdisaster.de>
 <700c11c33955b15829597d5de5d890814be97ee9.1352217243.git.sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <700c11c33955b15829597d5de5d890814be97ee9.1352217243.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 06, 2012 at 05:38:25PM +0100, Stefan Behrens wrote:
> The new function btrfs_find_device_missing_or_by_path() will be
> used for the device replace procedure. This function itself calls
> the second new function btrfs_find_device_by_path().
> Unfortunately, it is not possible to currently make the rest of the
> code use these functions as well, since all functions that look
> similar at first view are all a little bit different in what they
> are doing. But in the future, new code could benefit from these
> two new functions, and currently, device replace uses them.
> 
> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
> ---
>  fs/btrfs/volumes.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/volumes.h |  5 ++++
>  2 files changed, 79 insertions(+)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index eeed97d..bcd3097 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1512,6 +1512,80 @@ error_undo:
>  	goto error_brelse;
>  }
>  
> +int btrfs_find_device_by_path(struct btrfs_root *root, char *device_path,
> +			      struct btrfs_device **device)
> +{
> +	int ret = 0;
> +	struct btrfs_super_block *disk_super;
> +	u64 devid;
> +	u8 *dev_uuid;
> +	struct block_device *bdev;
> +	struct buffer_head *bh = NULL;
> +
> +	*device = NULL;
> +	mutex_lock(&uuid_mutex);

Since the caller have held volume_mutex, we can get rid of the
mutex_lock here, can't we?

> +	bdev = blkdev_get_by_path(device_path, FMODE_READ,
> +				  root->fs_info->bdev_holder);
> +	if (IS_ERR(bdev)) {
> +		ret = PTR_ERR(bdev);
> +		bdev = NULL;
> +		goto out;
> +	}
> +
> +	set_blocksize(bdev, 4096);
> +	invalidate_bdev(bdev);
> +	bh = btrfs_read_dev_super(bdev);
> +	if (!bh) {
> +		ret = -EINVAL;
> +		goto out;
> +	}

I made a scan for this 'get bdev & bh' in the code, I think
maybe we can make a function,
func_get(device_path, flags, mode, &bdev, &bh, flush)

where we need to take care of setting bdev = NULL, bh = NULL, and
'flush' is for filemap_bdev().  Besides, we also need to make
some proper error handling.


thanks,
liubo

> +	disk_super = (struct btrfs_super_block *)bh->b_data;
> +	devid = btrfs_stack_device_id(&disk_super->dev_item);
> +	dev_uuid = disk_super->dev_item.uuid;
> +	*device = btrfs_find_device(root, devid, dev_uuid,
> +				    disk_super->fsid);
> +	brelse(bh);
> +	if (!*device)
> +		ret = -ENOENT;
> +out:
> +	mutex_unlock(&uuid_mutex);
> +	if (bdev)
> +		blkdev_put(bdev, FMODE_READ);
> +	return ret;
> +}
> +
> +int btrfs_find_device_missing_or_by_path(struct btrfs_root *root,
> +					 char *device_path,
> +					 struct btrfs_device **device)
> +{
> +	*device = NULL;
> +	if (strcmp(device_path, "missing") == 0) {
> +		struct list_head *devices;
> +		struct btrfs_device *tmp;
> +
> +		devices = &root->fs_info->fs_devices->devices;
> +		/*
> +		 * It is safe to read the devices since the volume_mutex
> +		 * is held by the caller.
> +		 */
> +		list_for_each_entry(tmp, devices, dev_list) {
> +			if (tmp->in_fs_metadata && !tmp->bdev) {
> +				*device = tmp;
> +				break;
> +			}
> +		}
> +
> +		if (!*device) {
> +			pr_err("btrfs: no missing device found\n");
> +			return -ENOENT;
> +		}
> +
> +		return 0;
> +	} else {
> +		return btrfs_find_device_by_path(root, device_path, device);
> +	}
> +}
> +
>  /*
>   * does all the dirty work required for changing file system's UUID.
>   */
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 1789cda..657bb12 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -268,6 +268,11 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
>  			  struct btrfs_fs_devices **fs_devices_ret);
>  int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
>  void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices);
> +int btrfs_find_device_missing_or_by_path(struct btrfs_root *root,
> +					 char *device_path,
> +					 struct btrfs_device **device);
> +int btrfs_find_device_by_path(struct btrfs_root *root, char *device_path,
> +			      struct btrfs_device **device);
>  int btrfs_add_device(struct btrfs_trans_handle *trans,
>  		     struct btrfs_root *root,
>  		     struct btrfs_device *device);
> -- 
> 1.8.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
