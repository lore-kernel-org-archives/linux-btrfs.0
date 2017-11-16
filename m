Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34020 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965008AbdKPN7b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Nov 2017 08:59:31 -0500
Subject: Re: [PATCH 1/2] btrfs: refactor btrfs_free_stale_device() to get
 device list delete
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20171113054410.24872-1-anand.jain@oracle.com>
 <20171113054410.24872-2-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <4a9afb0a-f6a5-d9b7-6846-f915d496d20c@suse.com>
Date: Thu, 16 Nov 2017 15:59:29 +0200
MIME-Version: 1.0
In-Reply-To: <20171113054410.24872-2-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 13.11.2017 07:44, Anand Jain wrote:
> We need to delete a device from the dev_list, so refactor
> btrfs_free_stale_device() for delete_device_from_list().
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/volumes.c | 27 +++++++++++++++++----------
>  1 file changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 8bac1cf17048..8ead85dba6f5 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -546,6 +546,22 @@ static void pending_bios_fn(struct btrfs_work *work)
>  	run_scheduled_bios(device);
>  }
>  
> +void delete_device_from_list(struct btrfs_device *dev)

In this patch and the other one this function is used only in volume.c
so make static. Also if it relies on some particular lock being held why
not add lockdep_assert_held(xxx) as a means of documenting that ?

> +{
> +	struct btrfs_fs_devices *fs_devs;
> +	fs_devs = dev->fs_devices;
> +
> +	if (fs_devs->num_devices == 1) {
> +		btrfs_sysfs_remove_fsid(fs_devs);
> +		list_del(&fs_devs->list);
> +		free_fs_devices(fs_devs);
> +	} else {
> +		fs_devs->num_devices--;
> +		list_del(&dev->dev_list);
> +		rcu_string_free(dev->name);
> +		kfree(dev);
> +	}
> +}
>  
>  void btrfs_free_stale_device(struct btrfs_device *cur_dev)
>  {
> @@ -586,16 +602,7 @@ void btrfs_free_stale_device(struct btrfs_device *cur_dev)
>  
>  		if (!del) {
>  			/* delete the stale device */
> -			if (fs_devs->num_devices == 1) {
> -				btrfs_sysfs_remove_fsid(fs_devs);
> -				list_del(&fs_devs->list);
> -				free_fs_devices(fs_devs);
> -			} else {
> -				fs_devs->num_devices--;
> -				list_del(&dev->dev_list);
> -				rcu_string_free(dev->name);
> -				kfree(dev);
> -			}
> +			delete_device_from_list(dev);
>  			break;
>  		}
>  	}
> 
