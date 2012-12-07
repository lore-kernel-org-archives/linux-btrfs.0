Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43081 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756625Ab2LGRHX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Dec 2012 12:07:23 -0500
Message-ID: <50C2238F.7000004@oracle.com>
Date: Sat, 08 Dec 2012 01:12:47 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Lukas Czerner <lczerner@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Notify udev when removing device
References: <1354821948-18855-1-git-send-email-lczerner@redhat.com>
In-Reply-To: <1354821948-18855-1-git-send-email-lczerner@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


It works. Nice fix.

Thanks
Anand


On 12/07/2012 03:25 AM, Lukas Czerner wrote:
> Currently udev does not know about the device being removed from the
> file system. This may result in the situation where we're unable to
> mount the file system by UUID or by LABEL because the by-uuid and
> by-label links may still point to the device which is no longer part of
> the btrfs file system and hence does not have any btrfs super block.
>
> It can be easily reproduced by the following:
>
> mkfs.btrfs -L bugfs /dev/loop[0-6]
> mount /dev/loop0 /mnt/test
> btrfs device delete /dev/loop0 /mnt/test
> umount /mnt/test
>
> mount LABEL=bugfs /mnt/test <---- this fails
>
> then see:
>
> ls -l /dev/disk/by-label/bugfs
>
> which will still point to the /dev/loop0
>
> We did not noticed this before because libblkid would send the udev
> event for us when it notice that the link does not fit the reality,
> however it does not do that anymore and completely relies on udev
> information.
>
> Fix this by sending the KOBJ_CHANGE event to the bdev kobject after
> successful device removal.
>
> Note that this does not affect device addition, because we will open the
> device prior the addition from userspace and udev will notice that and
> reread the device afterwards.
>
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>   fs/btrfs/volumes.c |   16 ++++++++++++++++
>   1 files changed, 16 insertions(+), 0 deletions(-)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 0f5ebb7..95c6f7d 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -71,6 +71,19 @@ static void free_fs_devices(struct btrfs_fs_devices *fs_devices)
>   	kfree(fs_devices);
>   }
>
> +static void btrfs_kobject_uevent(struct block_device *bdev,
> +				 enum kobject_action action)
> +{
> +	int ret;
> +
> +	ret = kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, action);
> +	if (ret)
> +		pr_warn("Sending event '%d' to kobject: '%s' (%p): failed\n",
> +			action,
> +			kobject_name(&disk_to_dev(bdev->bd_disk)->kobj),
> +			&disk_to_dev(bdev->bd_disk)->kobj);
> +}
> +
>   void btrfs_cleanup_fs_uuids(void)
>   {
>   	struct btrfs_fs_devices *fs_devices;
> @@ -1493,6 +1506,9 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
>
>   	ret = 0;
>
> +	/* Notify udev that device has changed */
> +	btrfs_kobject_uevent(bdev, KOBJ_CHANGE);
> +
>   error_brelse:
>   	brelse(bh);
>   error_close:
>
