Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:52382 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932479AbeGDIQO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jul 2018 04:16:14 -0400
Subject: Re: [PATCH 3/7] btrfs: lift uuid_mutex to callers of
 btrfs_scan_one_device
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1529516226.git.dsterba@suse.com>
 <81dbac2d7ddba00de5e2c69813138f71752f74ff.1529516228.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <5ce72f80-6451-ffd4-5f80-c4c8c9ce3123@oracle.com>
Date: Wed, 4 Jul 2018 16:19:24 +0800
MIME-Version: 1.0
In-Reply-To: <81dbac2d7ddba00de5e2c69813138f71752f74ff.1529516228.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/21/2018 01:51 AM, David Sterba wrote:
> Prepartory work to fix race between mount and device scan.
> 
> The callers will have to manage the critical section, eg. mount wants to
> scan and then call btrfs_open_devices without the ioctl scan walking in
> and modifying the fs devices in the meantime.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand

> ---
>   fs/btrfs/super.c   | 12 +++++++++++-
>   fs/btrfs/volumes.c |  4 ++--
>   2 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 81107ad49f3a..735402ed3154 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -917,8 +917,10 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
>   				error = -ENOMEM;
>   				goto out;
>   			}
> +			mutex_lock(&uuid_mutex);
>   			error = btrfs_scan_one_device(device_name,
>   					flags, holder, fs_devices);
> +			mutex_unlock(&uuid_mutex);
>   			kfree(device_name);
>   			if (error)
>   				goto out;
> @@ -1539,7 +1541,9 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
>   			return ERR_PTR(error);
>   	}
>   
> +	mutex_lock(&uuid_mutex);
>   	error = btrfs_scan_one_device(device_name, mode, fs_type, &fs_devices);
> +	mutex_unlock(&uuid_mutex);
>   	if (error)
>   		goto error_sec_opts;
>   
> @@ -2234,15 +2238,21 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
>   
>   	switch (cmd) {
>   	case BTRFS_IOC_SCAN_DEV:
> +		mutex_lock(&uuid_mutex);
>   		ret = btrfs_scan_one_device(vol->name, FMODE_READ,
>   					    &btrfs_root_fs_type, &fs_devices);
> +		mutex_unlock(&uuid_mutex);
>   		break;
>   	case BTRFS_IOC_DEVICES_READY:
> +		mutex_lock(&uuid_mutex);
>   		ret = btrfs_scan_one_device(vol->name, FMODE_READ,
>   					    &btrfs_root_fs_type, &fs_devices);
> -		if (ret)
> +		if (ret) {
> +			mutex_unlock(&uuid_mutex);
>   			break;
> +		}
>   		ret = !(fs_devices->num_devices == fs_devices->total_devices);
> +		mutex_unlock(&uuid_mutex);
>   		break;
>   	case BTRFS_IOC_GET_SUPPORTED_FEATURES:
>   		ret = btrfs_ioctl_get_supported_features((void __user*)arg);
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 02246f9af0a3..958bfe1a725c 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1226,6 +1226,8 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
>   	int ret = 0;
>   	u64 bytenr;
>   
> +	lockdep_assert_held(&uuid_mutex);
> +
>   	/*
>   	 * we would like to check all the supers, but that would make
>   	 * a btrfs mount succeed after a mkfs from a different FS.
> @@ -1244,13 +1246,11 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
>   		goto error_bdev_put;
>   	}
>   
> -	mutex_lock(&uuid_mutex);
>   	device = device_list_add(path, disk_super);
>   	if (IS_ERR(device))
>   		ret = PTR_ERR(device);
>   	else
>   		*fs_devices_ret = device->fs_devices;
> -	mutex_unlock(&uuid_mutex);
>   
>   	btrfs_release_disk_super(page);
>   
> 
