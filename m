Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:37248 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753812AbeARG41 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Jan 2018 01:56:27 -0500
Subject: Re: [PATCH 1/2] btrfs: fix the bug of device scan/ready for mounted,
 filesystem
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <7fba2dc9-44a9-4317-b9fd-263b2a687e9a@jp.fujitsu.com>
 <923e5500-d6d8-b4b5-eb0b-30b80760a3f1@jp.fujitsu.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <36426d8e-35a1-e35c-d654-90e3b1a80418@oracle.com>
Date: Thu, 18 Jan 2018 14:57:28 +0800
MIME-Version: 1.0
In-Reply-To: <923e5500-d6d8-b4b5-eb0b-30b80760a3f1@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 01/17/2018 04:37 PM, Misono, Tomohiro wrote:
> commit ae3acc5fc0bf ("btrfs: cleanup btrfs_mount() using
> btrfs_mount_root()") introduces a bug that "btrfs device scan/ready" for
> mounted filesystem fails.
> 
> This is because fs_info->bdev_holder has been changed to hold
> btrfs_root_fs_type instead of btrfs_fs_type by this commit, but ioctl
> for device scan/ready still uses btrfs_fs_type to call
> btrfs_scan_one_device(). This leads to failiure of blkdev_get_by_path()
> for mounted filesystem because of different holder type.
> 
> Fix this by specifying btrfs_root_fs_type for btrfs_scan_one_device() in
> the path of device ready/scan ioctl.


   Reviewed-by: Anand Jain <Anand.Jain@oracle.com>

Thanks, Anand

> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
> ---
>   fs/btrfs/super.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 9438d32c4267..6ff13948b655 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -2231,11 +2231,11 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
>   	switch (cmd) {
>   	case BTRFS_IOC_SCAN_DEV:
>   		ret = btrfs_scan_one_device(vol->name, FMODE_READ,
> -					    &btrfs_fs_type, &fs_devices);
> +					    &btrfs_root_fs_type, &fs_devices);
>   		break;
>   	case BTRFS_IOC_DEVICES_READY:
>   		ret = btrfs_scan_one_device(vol->name, FMODE_READ,
> -					    &btrfs_fs_type, &fs_devices);
> +					    &btrfs_root_fs_type, &fs_devices);
>   		if (ret)
>   			break;
>   		ret = !(fs_devices->num_devices == fs_devices->total_devices);
> 
