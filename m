Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:53268 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932346AbeGDIRv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jul 2018 04:17:51 -0400
Subject: Re: [PATCH 6/7] btrfs: reorder initialization before the mount locks
 uuid_mutex
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1529516226.git.dsterba@suse.com>
 <c501e3ab67e55bbd71f07de9c0981eec19d49d3c.1529516228.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <ac0fc27b-375f-49f9-cf27-0c7215404585@oracle.com>
Date: Wed, 4 Jul 2018 16:21:03 +0800
MIME-Version: 1.0
In-Reply-To: <c501e3ab67e55bbd71f07de9c0981eec19d49d3c.1529516228.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/21/2018 01:51 AM, David Sterba wrote:
> In preparation to take a big lock, move resource initialization before
> the critical section. It's not obvious from the diff, the desired order
> is:
> 
> - initialize mount security options
> - allocate temporary fs_info
> - allocate superblock buffers
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand


> ---
>   fs/btrfs/super.c | 30 ++++++++++++++----------------
>   1 file changed, 14 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index e3324ddf2777..1780eb41f203 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1528,14 +1528,6 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
>   	if (!(flags & SB_RDONLY))
>   		mode |= FMODE_WRITE;
>   
> -	mutex_lock(&uuid_mutex);
> -	error = btrfs_parse_early_options(data, mode, fs_type,
> -					  &fs_devices);
> -	mutex_unlock(&uuid_mutex);
> -	if (error) {
> -		return ERR_PTR(error);
> -	}
> -
>   	security_init_mnt_opts(&new_sec_opts);
>   	if (data) {
>   		error = parse_security_options(data, &new_sec_opts);
> @@ -1543,12 +1535,6 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
>   			return ERR_PTR(error);
>   	}
>   
> -	mutex_lock(&uuid_mutex);
> -	error = btrfs_scan_one_device(device_name, mode, fs_type, &fs_devices);
> -	mutex_unlock(&uuid_mutex);
> -	if (error)
> -		goto error_sec_opts;
> -
>   	/*
>   	 * Setup a dummy root and fs_info for test/set super.  This is because
>   	 * we don't actually fill this stuff out until open_ctree, but we need
> @@ -1561,8 +1547,6 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
>   		goto error_sec_opts;
>   	}
>   
> -	fs_info->fs_devices = fs_devices;
> -
>   	fs_info->super_copy = kzalloc(BTRFS_SUPER_INFO_SIZE, GFP_KERNEL);
>   	fs_info->super_for_commit = kzalloc(BTRFS_SUPER_INFO_SIZE, GFP_KERNEL);
>   	security_init_mnt_opts(&fs_info->security_opts);
> @@ -1571,6 +1555,20 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
>   		goto error_fs_info;
>   	}
>   
> +	mutex_lock(&uuid_mutex);
> +	error = btrfs_parse_early_options(data, mode, fs_type, &fs_devices);
> +	mutex_unlock(&uuid_mutex);
> +	if (error)
> +		goto error_fs_info;
> +
> +	mutex_lock(&uuid_mutex);
> +	error = btrfs_scan_one_device(device_name, mode, fs_type, &fs_devices);
> +	mutex_unlock(&uuid_mutex);
> +	if (error)
> +		goto error_fs_info;
> +
> +	fs_info->fs_devices = fs_devices;
> +
>   	mutex_lock(&uuid_mutex);
>   	error = btrfs_open_devices(fs_devices, mode, fs_type);
>   	mutex_unlock(&uuid_mutex);
> 
