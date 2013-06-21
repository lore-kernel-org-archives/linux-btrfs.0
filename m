Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51421 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161432Ab3FUQLc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Jun 2013 12:11:32 -0400
Date: Sat, 22 Jun 2013 00:11:24 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/5 v2] Btrfs-progs: fix closing of devices
Message-ID: <20130621161123.GC30620@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1370893895-24884-1-git-send-email-fdmanana@gmail.com>
 <1370908356-31792-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1370908356-31792-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 11, 2013 at 12:52:36AM +0100, Filipe David Borba Manana wrote:
> If a device could not be opened in volumes.c:read_one_dev(), a
> btrfs_device instance was allocated and added to the list of
> devices of the fs - however this device instance had its fd,
> name and label fields not initialized. This is problematic in
> disk-io.c:close_all_devices() as it tried to sync, fadvise and
> close the (invalid) fd of the device, and kfree() its name and
> label, which pointed to random memory locations.
> 
>   Thread 1 (Thread 0x7f0a3d2d1740 (LWP 23585)):
>   #0  __GI___libc_free (mem=0xa5a5a5a5a5a5a5a5) at malloc.c:2970
>   #1  0x000000000042054b in close_all_devices (fs_info=0x1e92bf0) at disk-io.c:1276
>   #2  0x0000000000421dcd in close_ctree (root=<optimized out>) at disk-io.c:1336
>   #3  0x0000000000418cfa in cmd_check (argc=<optimized out>, argv=<optimized out>) at cmds-check.c:4171
>   #4  0x0000000000403ed4 in main (argc=2, argv=0x7fff9a583d28) at btrfs.c:295
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
>  disk-io.c |    4 ++--
>  volumes.c |    5 +++--
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/disk-io.c b/disk-io.c
> index 21b410d..bd9cf4e 100644
> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -1267,12 +1267,12 @@ static int close_all_devices(struct btrfs_fs_info *fs_info)
>  	while (!list_empty(list)) {
>  		device = list_entry(list->next, struct btrfs_device, dev_list);
>  		list_del_init(&device->dev_list);
> -		if (device->fd) {
> +		if (device->fd >= 0) {
>  			fsync(device->fd);
>  			if (posix_fadvise(device->fd, 0, 0, POSIX_FADV_DONTNEED))
>  				fprintf(stderr, "Warning, could not drop caches\n");
> +			close(device->fd);
>  		}
> -		close(device->fd);
>  		kfree(device->name);
>  		kfree(device->label);
>  		kfree(device);
> diff --git a/volumes.c b/volumes.c
> index d6f81f8..061f094 100644
> --- a/volumes.c
> +++ b/volumes.c
> @@ -116,6 +116,7 @@ static int device_list_add(const char *path,
>  			/* we can safely leave the fs_devices entry around */
>  			return -ENOMEM;
>  		}
> +		device->fd = -1;

One nit here,
I think it's ok without this since if we get the right device->name, it
means this device is not missing and its fd will be valid.

thanks,
liubo

>  		device->devid = devid;
>  		memcpy(device->uuid, disk_super->dev_item.uuid,
>  		       BTRFS_UUID_SIZE);
> @@ -1628,10 +1629,10 @@ static int read_one_dev(struct btrfs_root *root,
>  	if (!device) {
>  		printk("warning devid %llu not found already\n",
>  			(unsigned long long)devid);
> -		device = kmalloc(sizeof(*device), GFP_NOFS);
> +		device = kzalloc(sizeof(*device), GFP_NOFS);
>  		if (!device)
>  			return -ENOMEM;
> -		device->total_ios = 0;
> +		device->fd = -1;
>  		list_add(&device->dev_list,
>  			 &root->fs_info->fs_devices->devices);
>  	}
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
