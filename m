Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46588 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752780AbdKBKkv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Nov 2017 06:40:51 -0400
Subject: Re: [PATCH 01/11] btrfs: add missing device::flush_bio puts
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1509471604.git.dsterba@suse.com>
 <0c6045183bbefe81b5e37cf0c84e31c5193ba191.1509471604.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <2b2592d4-8c59-6398-206e-478240e50fc4@oracle.com>
Date: Thu, 2 Nov 2017 18:40:53 +0800
MIME-Version: 1.0
In-Reply-To: <0c6045183bbefe81b5e37cf0c84e31c5193ba191.1509471604.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11/01/2017 01:44 AM, David Sterba wrote:
> This fixes potential bio leaks, in several error paths. Unfortunatelly
> the device structure freeing is opencoded in many places and I missed
> them when introducing the flush_bio.
> 
> Most of the time, devices get freed through call_rcu(..., free_device),
> so it at least it's not that easy to hit the leak, but it's still
> possible through the path that frees stale devices.
> 
> Fixes: e0ae99941423 ("btrfs: preallocate device flush bio")
> Signed-off-by: David Sterba <dsterba@suse.com>

  Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand

> ---
>   fs/btrfs/volumes.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index ea8b20839ac0..08fb4b5609b7 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -189,6 +189,7 @@ static void free_fs_devices(struct btrfs_fs_devices *fs_devices)
>   				    struct btrfs_device, dev_list);
>   		list_del(&device->dev_list);
>   		rcu_string_free(device->name);
> +		bio_put(device->flush_bio);
>   		kfree(device);
>   	}
>   	kfree(fs_devices);
> @@ -578,6 +579,7 @@ static void btrfs_free_stale_device(struct btrfs_device *cur_dev)
>   				fs_devs->num_devices--;
>   				list_del(&dev->dev_list);
>   				rcu_string_free(dev->name);
> +				bio_put(dev->flush_bio);
>   				kfree(dev);
>   			}
>   			break;
> @@ -630,6 +632,7 @@ static noinline int device_list_add(const char *path,
>   
>   		name = rcu_string_strdup(path, GFP_NOFS);
>   		if (!name) {
> +			bio_put(device->flush_bio);
>   			kfree(device);
>   			return -ENOMEM;
>   		}
> @@ -742,6 +745,7 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
>   			name = rcu_string_strdup(orig_dev->name->str,
>   					GFP_KERNEL);
>   			if (!name) {
> +				bio_put(device->flush_bio);
>   				kfree(device);
>   				goto error;
>   			}
> @@ -807,6 +811,7 @@ void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices, int step)
>   		list_del_init(&device->dev_list);
>   		fs_devices->num_devices--;
>   		rcu_string_free(device->name);
> +		bio_put(device->flush_bio);
>   		kfree(device);
>   	}
>   
> @@ -2337,6 +2342,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
>   
>   	name = rcu_string_strdup(device_path, GFP_KERNEL);
>   	if (!name) {
> +		bio_put(device->flush_bio);
>   		kfree(device);
>   		ret = -ENOMEM;
>   		goto error;
> @@ -2346,6 +2352,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
>   	trans = btrfs_start_transaction(root, 0);
>   	if (IS_ERR(trans)) {
>   		rcu_string_free(device->name);
> +		bio_put(device->flush_bio);
>   		kfree(device);
>   		ret = PTR_ERR(trans);
>   		goto error;
> @@ -2489,6 +2496,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
>   	if (trans)
>   		btrfs_end_transaction(trans);
>   	rcu_string_free(device->name);
> +	bio_put(device->flush_bio);
>   	kfree(device);
>   error:
>   	blkdev_put(bdev, FMODE_EXCL);
> @@ -2555,6 +2563,7 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
>   
>   	name = rcu_string_strdup(device_path, GFP_KERNEL);
>   	if (!name) {
> +		bio_put(device->flush_bio);
>   		kfree(device);
>   		ret = -ENOMEM;
>   		goto error;
> @@ -6271,6 +6280,7 @@ struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
>   
>   		ret = find_next_devid(fs_info, &tmp);
>   		if (ret) {
> +			bio_put(dev->flush_bio);
>   			kfree(dev);
>   			return ERR_PTR(ret);
>   		}
> 
