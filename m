Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22787 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbaEZJs2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 May 2014 05:48:28 -0400
Message-ID: <53830EA7.0@oracle.com>
Date: Mon, 26 May 2014 17:51:35 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Jeff Mahoney <jeffm@suse.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] btrfs: handle add/remove of sysfs links when devices
 are added/removed
References: <537FAA8B.3060402@suse.com>
In-Reply-To: <537FAA8B.3060402@suse.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Jeff,

  We were working on the same bugs. I have sent out my patches
  as well.

  Further I will be working on to revamp /sys/fs/btrfs/<fsid>/devices
  so that instead of links to block device we will have dir based
  on devices of the FS.

     [PATCH RFC] btrfs: revamp /sys/fs/btrfs/<fsid>/devices

  Comments appreciated.

Thanks, Anand


On 24/05/14 04:07, Jeff Mahoney wrote:
>
> btrfs currently publishes device membership via sysfs based on the devices
> present when the file system is mounted. That publishing is not updated
> when devices are added or removed while mounted.
>
> This patch handles those events.
>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>   fs/btrfs/volumes.c |   11 +++++++++++
>   1 file changed, 11 insertions(+)
>
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1704,6 +1704,9 @@ int btrfs_rm_device(struct btrfs_root *r
>
>   	ret = 0;
>
> +	sysfs_remove_link(root->fs_info->device_dir_kobj,
> +			  part_to_dev(bdev->bd_part)->kobj.name);
> +
>   	/* Notify udev that device has changed */
>   	if (bdev)
>   		btrfs_kobject_uevent(bdev, KOBJ_CHANGE);
> @@ -2038,6 +2041,12 @@ int btrfs_init_new_device(struct btrfs_r
>   		goto error;
>   	}
>
> +	ret = sysfs_create_link(root->fs_info->device_dir_kobj,
> +				&part_to_dev(bdev->bd_part)->kobj,
> +				part_to_dev(bdev->bd_part)->kobj.name);
> +	if (ret)
> +		goto error;
> +
>   	lock_chunks(root);
>
>   	q = bdev_get_queue(bdev);
> @@ -2152,6 +2161,8 @@ error_trans:
>   	unlock_chunks(root);
>   	btrfs_end_transaction(trans, root);
>   	rcu_string_free(device->name);
> +	sysfs_remove_link(root->fs_info->device_dir_kobj,
> +			  part_to_dev(bdev->bd_part)->kobj.name);
>   	kfree(device);
>   error:
>   	blkdev_put(bdev, FMODE_EXCL);
>
