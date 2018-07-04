Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:50300 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932290AbeGDIO4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jul 2018 04:14:56 -0400
Subject: Re: [PATCH 2/7] btrfs: extend critical section when scanning a new
 device
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1529516226.git.dsterba@suse.com>
 <92caa5382783c709d6ddab7d06747327bd7c120c.1529516228.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <d5b69aad-2ffb-4322-9c8d-e0003056b430@oracle.com>
Date: Wed, 4 Jul 2018 16:18:09 +0800
MIME-Version: 1.0
In-Reply-To: <92caa5382783c709d6ddab7d06747327bd7c120c.1529516228.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/21/2018 01:51 AM, David Sterba wrote:
> The stale device list removal needs to be protected by device_list_mutex
> too as this could delete from the list and could race with another list
> modification and cause crash.
> 
> The device needs to be fully initialized before it's added to the list
> so the fs_devices also need to be set under the mutex.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>   fs/btrfs/volumes.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 1da162928d1a..02246f9af0a3 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -791,12 +791,11 @@ static noinline struct btrfs_device *device_list_add(const char *path,
>   		rcu_assign_pointer(device->name, name);
>   
>   		mutex_lock(&fs_devices->device_list_mutex);
> +		device->fs_devices = fs_devices;
>   		list_add_rcu(&device->dev_list, &fs_devices->devices);
>   		fs_devices->num_devices++;
> -		mutex_unlock(&fs_devices->device_list_mutex);
> -
> -		device->fs_devices = fs_devices;
>   		btrfs_free_stale_devices(path, device);


This is not correct.

btrfs_free_stale_devices need the per fs_devices local device_list_mutex
lock as it traverses through the fs_uuids list. Holding just the lock of
the %fs_devices which is being scanned or mounted is not correct.

In my workspace I have replaced this patch with ..

  4130724ec926 btrfs: fix btrfs_free_stale_devices() with needed locks
  90fedec0c200 btrfs: btrfs_free_stale_devices() rename local variables
  439eec4e943c btrfs: fix device_list_add() missing device_list_mutex()
  417ecc91e223 btrfs: do btrfs_free_stale_devices() outside of 
device_list_add()

which are in the ML as well.

Thanks, Anand


> +		mutex_unlock(&fs_devices->device_list_mutex);
>   
>   		if (disk_super->label[0])
>   			pr_info("BTRFS: device label %s devid %llu transid %llu %s\n",
> 
