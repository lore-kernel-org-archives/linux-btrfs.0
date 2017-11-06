Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57647 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752164AbdKFL7N (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 06:59:13 -0500
Subject: Re: [PATCH] btrfs: move volume_mutex into the btrfs_rm_device()
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20171106022800.9473-1-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <7a8c9c2a-f00d-d33e-f30c-535877ec5f58@suse.com>
Date: Mon, 6 Nov 2017 13:59:11 +0200
MIME-Version: 1.0
In-Reply-To: <20171106022800.9473-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  6.11.2017 04:28, Anand Jain wrote:
> A cleanup patch no functional change, we hold volume_mutex before
> calling btrfs_rm_device, so move it into the function itself.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
> David, This patch is based on your workspace/for-next plus your
> recent patchset '[PATCH 00/11] Device fixes and cleanups'.
> Thanks, Anand
> 
>  fs/btrfs/ioctl.c   | 4 ----
>  fs/btrfs/volumes.c | 2 ++
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index bc13b6d0f280..09c95f1b07dc 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2695,14 +2695,12 @@ static long btrfs_ioctl_rm_dev_v2(struct file *file, void __user *arg)
>  		goto out;
>  	}
>  
> -	mutex_lock(&fs_info->volume_mutex);
>  	if (vol_args->flags & BTRFS_DEVICE_SPEC_BY_ID) {
>  		ret = btrfs_rm_device(fs_info, NULL, vol_args->devid);
>  	} else {
>  		vol_args->name[BTRFS_SUBVOL_NAME_MAX] = '\0';
>  		ret = btrfs_rm_device(fs_info, vol_args->name, 0);
>  	}
> -	mutex_unlock(&fs_info->volume_mutex);
>  	clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
>  
>  	if (!ret) {
> @@ -2746,9 +2744,7 @@ static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
>  	}
>  
>  	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
> -	mutex_lock(&fs_info->volume_mutex);
>  	ret = btrfs_rm_device(fs_info, vol_args->name, 0);
> -	mutex_unlock(&fs_info->volume_mutex);
>  
>  	if (!ret)
>  		btrfs_info(fs_info, "disk deleted %s", vol_args->name);
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index e913d2154ffb..5b03c2b1b851 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1913,6 +1913,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
>  	u64 num_devices;
>  	int ret = 0;
>  
> +	mutex_lock(&fs_info->volume_mutex);
>  	mutex_lock(&uuid_mutex);
>  
>  	num_devices = fs_info->fs_devices->num_devices;
> @@ -2027,6 +2028,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
>  
>  out:
>  	mutex_unlock(&uuid_mutex);
> +	mutex_unlock(&fs_info->volume_mutex);
>  	return ret;
>  
>  er

ror_undo:
> 
