Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:45770 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752793AbeFZHdM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Jun 2018 03:33:12 -0400
Subject: Re: [PATCH 2/7] btrfs: extend critical section when scanning a new
 device
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1529516226.git.dsterba@suse.com>
 <92caa5382783c709d6ddab7d06747327bd7c120c.1529516228.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <6d06a783-e772-03ba-db0e-02b9abb25443@oracle.com>
Date: Tue, 26 Jun 2018 15:34:17 +0800
MIME-Version: 1.0
In-Reply-To: <92caa5382783c709d6ddab7d06747327bd7c120c.1529516228.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/21/2018 01:51 AM, David Sterba wrote:
> The stale device list removal needs to be protected by device_list_mutex
> too as this could delete from the list and could race with another list
> modification and cause crash.

  Its is very less likely or almost practically impossible (unless
  instrumented) to have same device with same fsid but with different
  devid, which then it would delete the device which is under the same
  fs_devices which device_list_add just operated. Otherwise in most of
  the common cases it shall delete the device which does not belong to
  the fs_devices which the device_list_add() just added a device. So
  fs_devices::device_list_mutex lock won't help.

  I have few patches to fix this. I shall send it. But then it was all
  based on the atomic volume exclusive flag which in stages I had
  plans to replace fs_info::BTRFS_FS_EXCL_OP with volume exclusive flag
  as well.

  Also we need locks to manage with in btrfs_free_stale_devices() so
  that we can reuse this code to support user land forget device feature,
  (38cf665d338fca33af4b16f9ec7cad6637fc0fec btrfs: make
  btrfs_free_stale_device() to iterate all stales).

Thanks, Anand


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
> +		mutex_unlock(&fs_devices->device_list_mutex);
>   
>   		if (disk_super->label[0])
>   			pr_info("BTRFS: device label %s devid %llu transid %llu %s\n",
> 
