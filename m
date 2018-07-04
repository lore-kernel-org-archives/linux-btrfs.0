Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:51346 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933959AbeGDIQ0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jul 2018 04:16:26 -0400
Subject: Re: [PATCH 4/7] btrfs: lift uuid_mutex to callers of
 btrfs_open_devices
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1529516226.git.dsterba@suse.com>
 <10602be89b1e8b940353fa64dfda47b6c27b14fa.1529516228.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <da05f3ae-3437-8f4e-d30e-8ae5e302d592@oracle.com>
Date: Wed, 4 Jul 2018 16:19:39 +0800
MIME-Version: 1.0
In-Reply-To: <10602be89b1e8b940353fa64dfda47b6c27b14fa.1529516228.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/21/2018 01:51 AM, David Sterba wrote:
> Prepartory work to fix race between mount and device scan.
> 
> The callers will have to manage the critical section, eg.  mount wants
> to scan and then call btrfs_open_devices without the ioctl scan walking
> in and modifying the fs devices in the meantime.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand

> ---
>   fs/btrfs/super.c   | 2 ++
>   fs/btrfs/volumes.c | 4 ++--
>   2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 735402ed3154..ee82d02f5453 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1569,7 +1569,9 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
>   		goto error_fs_info;
>   	}
>   
> +	mutex_lock(&uuid_mutex);
>   	error = btrfs_open_devices(fs_devices, mode, fs_type);
> +	mutex_unlock(&uuid_mutex);
>   	if (error)
>   		goto error_fs_info;
>   
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 958bfe1a725c..5336d9832ba4 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1145,7 +1145,8 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
>   {
>   	int ret;
>   
> -	mutex_lock(&uuid_mutex);
> +	lockdep_assert_held(&uuid_mutex);
> +
>   	mutex_lock(&fs_devices->device_list_mutex);
>   	if (fs_devices->opened) {
>   		fs_devices->opened++;
> @@ -1155,7 +1156,6 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
>   		ret = open_fs_devices(fs_devices, flags, holder);
>   	}
>   	mutex_unlock(&fs_devices->device_list_mutex);
> -	mutex_unlock(&uuid_mutex);
>   
>   	return ret;
>   }
> 
