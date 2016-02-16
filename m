Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26665 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296AbcBPJSR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Feb 2016 04:18:17 -0500
Subject: Re: [PATCH 15/15] btrfs: rename flags for vol args v2
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1455556900.git.dsterba@suse.com>
 <533b0847dc15f8d719aaf6198cf18953899f2164.1455556900.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56C2E954.4030202@oracle.com>
Date: Tue, 16 Feb 2016 17:18:12 +0800
MIME-Version: 1.0
In-Reply-To: <533b0847dc15f8d719aaf6198cf18953899f2164.1455556900.git.dsterba@suse.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



..

On 02/16/2016 01:34 AM, David Sterba wrote:
> Rename BTRFS_DEVICE_BY_ID so it's more descriptive that we specify the
> device by id, it'll be part of the public API. The mask of supported
> flags is also renamed, only for internal use.
>
> The error code for unknown flags is EOPNOTSUPP, fixed.
>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>   fs/btrfs/ioctl.c           | 8 ++++----
>   include/uapi/linux/btrfs.h | 7 ++++---
>   2 files changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 57fb05960435..6bcd7700b9fd 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2689,8 +2689,8 @@ static long btrfs_ioctl_rm_dev_v2(struct file *file, void __user *arg)
>   	}
>
>   	/* Check for compatibility reject unknown flags */
> -	if (vol_args->flags & ~BTRFS_VOL_ARG_V2_FLAGS)
> -		return -ENOTTY;
> +	if (vol_args->flags & ~BTRFS_VOL_ARG_V2_FLAGS_SUPPORTED)
> +		return -EOPNOTSUPP;
>
>   	if (atomic_xchg(&root->fs_info->mutually_exclusive_operation_running,
>   			1)) {
> @@ -2699,7 +2699,7 @@ static long btrfs_ioctl_rm_dev_v2(struct file *file, void __user *arg)
>   	}
>
>   	mutex_lock(&root->fs_info->volume_mutex);
> -	if (vol_args->flags & BTRFS_DEVICE_BY_ID) {
> +	if (vol_args->flags & BTRFS_DEVICE_SPEC_BY_ID) {
>   		ret = btrfs_rm_device(root, NULL, vol_args->devid);
>   	} else {
>   		vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
> @@ -2709,7 +2709,7 @@ static long btrfs_ioctl_rm_dev_v2(struct file *file, void __user *arg)
>   	atomic_set(&root->fs_info->mutually_exclusive_operation_running, 0);
>
>   	if (!ret) {
> -		if (vol_args->flags & BTRFS_DEVICE_BY_ID)
> +		if (vol_args->flags & BTRFS_DEVICE_SPEC_BY_ID)
>   			btrfs_info(root->fs_info, "device deleted: id %llu",
>   					vol_args->devid);
>   		else
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index 396a4efca775..3975e683af72 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -36,12 +36,13 @@ struct btrfs_ioctl_vol_args {
>   #define BTRFS_SUBVOL_CREATE_ASYNC	(1ULL << 0)
>   #define BTRFS_SUBVOL_RDONLY		(1ULL << 1)
>   #define BTRFS_SUBVOL_QGROUP_INHERIT	(1ULL << 2)
> -#define BTRFS_DEVICE_BY_ID		(1ULL << 3)
> -#define BTRFS_VOL_ARG_V2_FLAGS				\
> +#define BTRFS_DEVICE_SPEC_BY_ID		(1ULL << 3)
> +

  Just checked next/delete-by-id-v3.
  You may consider to update progs as well.

Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand



> +#define BTRFS_VOL_ARG_V2_FLAGS_SUPPORTED		\
>   			(BTRFS_SUBVOL_CREATE_ASYNC |	\
>   			BTRFS_SUBVOL_RDONLY |		\
>   			BTRFS_SUBVOL_QGROUP_INHERIT |	\
> -			BTRFS_DEVICE_BY_ID)
> +			BTRFS_DEVICE_SPEC_BY_ID)
>
>   #define BTRFS_FSID_SIZE 16
>   #define BTRFS_UUID_SIZE 16
>
