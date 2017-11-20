Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32417 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751061AbdKTIXC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Nov 2017 03:23:02 -0500
Subject: Re: [PATCH v2 1/2] btrfs: add function to device list delete
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
References: <20171113054410.24872-1-anand.jain@oracle.com>
 <20171118140337.13612-1-anand.jain@oracle.com>
Message-ID: <7bf08094-478e-d417-c757-b319a667d482@oracle.com>
Date: Mon, 20 Nov 2017 16:23:20 +0800
MIME-Version: 1.0
In-Reply-To: <20171118140337.13612-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


   Wrong ML. Pls ignore.

Thanks, Anand


On 11/18/2017 10:03 PM, Anand Jain wrote:
> We need device delete from the dev_list so create a new function,
> instead of refactor of btrfs_free_stale_device() because,
> btrfs_free_stale_device() doesn't hold device_list_mutex which
> is actually needed here.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v1: title of this patch
>    btrfs: refactor btrfs_free_stale_device() to get device list delete
> v2:
>   add new function instead of peal from
>   btrfs_free_stale_device() to delete a device from the device list,
>   since btrfs_free_stale_device() does not hold device_list_mutex,
>   may be it can be fixed later.
> 
> 
>   /btrfs/volumes.c | 21 +++++++++++++++++++++
>   1 file changed, 21 insertions(+)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index bddf75d5e6a0..68f1dd44385b 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -546,6 +546,27 @@ static void pending_bios_fn(struct btrfs_work *work)
>   	run_scheduled_bios(device);
>   }
>   
> +static void delete_device_from_list(struct btrfs_device *device)
> +{
> +	struct btrfs_fs_devices *fs_devices;
> +	fs_devices = device->fs_devices;
> +
> +	lockdep_assert_held(&uuid_mutex);
> +
> +	mutex_lock(&fs_devices->device_list_mutex);
> +	fs_devices->num_devices--;
> +	list_del(&device->dev_list);
> +	mutex_unlock(&fs_devices->device_list_mutex);
> +
> +	rcu_string_free(device->name);
> +	kfree(device);
> +
> +	if (fs_devices->num_devices == 0) {
> +		btrfs_sysfs_remove_fsid(fs_devices);
> +		list_del(&fs_devices->list);
> +		free_fs_devices(fs_devices);
> +	}
> +}
>   
>   void btrfs_free_stale_device(struct btrfs_device *cur_dev)
>   {
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
