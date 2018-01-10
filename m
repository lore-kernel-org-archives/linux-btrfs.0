Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45647 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753056AbeAJIsh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jan 2018 03:48:37 -0500
Subject: Re: [PATCH 3/4] btrfs: get device pointer from device_list_add()
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180110051624.3813-1-anand.jain@oracle.com>
 <20180110051624.3813-4-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <a5fdc40b-43fe-d4d9-3154-fec9855d3a76@suse.com>
Date: Wed, 10 Jan 2018 10:48:35 +0200
MIME-Version: 1.0
In-Reply-To: <20180110051624.3813-4-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10.01.2018 07:16, Anand Jain wrote:
> Instead of pointer to btrfs_fs_devices as an arg in device_list_add()
> better to get pointer to btrfs_device as return value, then we have
> both, pointer to btrfs_device and btrfs_fs_devices. btrfs_device is
> needed to handle reappearing missing device.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/volumes.c | 34 ++++++++++++++++++----------------
>  1 file changed, 18 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 4e5b82976455..b5305bd48338 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -726,12 +726,11 @@ static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
>   * Add new device to list of registered devices
>   *
>   * Returns:
> - * 0   - device already known or newly added
> - * < 0 - error
> + * device pointer which was just added or updated when successful
> + * error pointer when failed
>   */
> -static noinline int device_list_add(const char *path,
> -			   struct btrfs_super_block *disk_super,
> -			   u64 devid, struct btrfs_fs_devices **fs_devices_ret)
> +static noinline struct btrfs_device *device_list_add(const char *path,
> +			   struct btrfs_super_block *disk_super, u64 devid)
>  {
>  	struct btrfs_device *device;
>  	struct btrfs_fs_devices *fs_devices;
> @@ -742,7 +741,7 @@ static noinline int device_list_add(const char *path,
>  	if (!fs_devices) {
>  		fs_devices = alloc_fs_devices(disk_super->fsid);
>  		if (IS_ERR(fs_devices))
> -			return PTR_ERR(fs_devices);
> +			return ERR_PTR(PTR_ERR(fs_devices));

No need to do any conversion, alloc_fs_devices already returns ERR_PTR
value so plain return fs_devices suffices.

>  
>  		list_add(&fs_devices->list, &fs_uuids);
>  
> @@ -754,19 +753,19 @@ static noinline int device_list_add(const char *path,
>  
>  	if (!device) {
>  		if (fs_devices->opened)
> -			return -EBUSY;
> +			return ERR_PTR(-EBUSY);
>  
>  		device = btrfs_alloc_device(NULL, &devid,
>  					    disk_super->dev_item.uuid);
>  		if (IS_ERR(device)) {
>  			/* we can safely leave the fs_devices entry around */
> -			return PTR_ERR(device);
> +			return ERR_PTR(PTR_ERR(device));
Ditto

>  		}
>  
>  		name = rcu_string_strdup(path, GFP_NOFS);
>  		if (!name) {
>  			free_device(device);
> -			return -ENOMEM;
> +			return ERR_PTR(-ENOMEM);
>  		}
>  		rcu_assign_pointer(device->name, name);
>  
> @@ -820,12 +819,12 @@ static noinline int device_list_add(const char *path,
>  			 * with larger generation number or the last-in if
>  			 * generation are equal.
>  			 */
> -			return -EEXIST;
> +			return ERR_PTR(-EEXIST);
>  		}
>  
>  		name = rcu_string_strdup(path, GFP_NOFS);
>  		if (!name)
> -			return -ENOMEM;
> +			return ERR_PTR(-ENOMEM);
>  		rcu_string_free(device->name);
>  		rcu_assign_pointer(device->name, name);
>  		if (test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state)) {
> @@ -845,9 +844,7 @@ static noinline int device_list_add(const char *path,
>  
>  	fs_devices->total_devices = btrfs_super_num_devices(disk_super);
>  
> -	*fs_devices_ret = fs_devices;
> -
> -	return 0;
> +	return device;
>  }
>  
>  static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
> @@ -1182,9 +1179,10 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
>  			  struct btrfs_fs_devices **fs_devices_ret)
>  {
>  	struct btrfs_super_block *disk_super;
> +	struct btrfs_device *device;
>  	struct block_device *bdev;
>  	struct page *page;
> -	int ret;
> +	int ret = 0;
>  	u64 devid;
>  	u64 bytenr;
>  
> @@ -1209,8 +1207,12 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
>  	devid = btrfs_stack_device_id(&disk_super->dev_item);
>  
>  	mutex_lock(&uuid_mutex);
> -	ret = device_list_add(path, disk_super, devid, fs_devices_ret);
> +	device = device_list_add(path, disk_super, devid);
>  	mutex_unlock(&uuid_mutex);
> +	if (IS_ERR(device))
> +		ret = PTR_ERR(device);
> +
> +	*fs_devices_ret = device->fs_devices;
>  
>  	btrfs_release_disk_super(page);
>  
> 
