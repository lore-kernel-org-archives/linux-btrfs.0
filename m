Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:44731 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab3HINHI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Aug 2013 09:07:08 -0400
Message-ID: <5204E978.9010403@giantdisaster.de>
Date: Fri, 09 Aug 2013 15:07:04 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Filipe David Borba Manana <fdmanana@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix race between removing a dev and writing sbs
References: <1375992052-17706-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1375992052-17706-1-git-send-email-fdmanana@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu,  8 Aug 2013 21:00:52 +0100, Filipe David Borba Manana wrote:
> Since all code paths that update the number of devices in the
> super copy (fs_info->super_copy) first lock the device list
> (fs_info->fs_devices->device_list_mutex), and write_all_supers()
> also needs to lock the devices list mutex, make write_all_supers()
> read the number of devices from the super copy after it locks
> the device list mutex (and before unlocking it of course).
> 
> The only code path that doesn't lock the device list mutex
> before updating the number of devices in the super copy is
> disk-io.c:next_root_backup(), called by open_ctree() during
> mount time where concurrency issues can't happen.
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
>  fs/btrfs/disk-io.c |    2 +-
>  fs/btrfs/volumes.c |   11 ++++-------
>  2 files changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 254cdc8..c4b24c7 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3313,7 +3313,6 @@ static int write_all_supers(struct btrfs_root *root, int max_mirrors)
>  	int total_errors = 0;
>  	u64 flags;
>  
> -	max_errors = btrfs_super_num_devices(root->fs_info->super_copy) - 1;
>  	do_barriers = !btrfs_test_opt(root, NOBARRIER);
>  	backup_super_roots(root->fs_info);
>  
> @@ -3322,6 +3321,7 @@ static int write_all_supers(struct btrfs_root *root, int max_mirrors)
>  
>  	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
>  	head = &root->fs_info->fs_devices->devices;
> +	max_errors = btrfs_super_num_devices(root->fs_info->super_copy) - 1;
>  
>  	if (do_barriers) {
>  		ret = barrier_all_devices(root->fs_info);
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 090f57c..eddf386 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1568,11 +1568,6 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
>  	if (ret)
>  		goto error_undo;
>  
> -	/*
> -	 * TODO: the superblock still includes this device in its num_devices
> -	 * counter although write_all_supers() is not locked out. This
> -	 * could give a filesystem state which requires a degraded mount.
> -	 */
>  	ret = btrfs_rm_dev_item(root->fs_info->chunk_root, device);

The problem that I had seen when I added that comment is something
different than what you are addressing.

The call to btrfs_rm_dev_item() is the place where the device is removed
in the filesystem device tree. The transaction is commited.

root->fs_info->super_copy is not updated and still includes the device
that is not part of the device tree anymore.

19 lines later, the device_list_mutex is acquired. Until then, nobody
prevents write_all_supers() to write the superblock to disk. This means,
until then, you can create a state on disk with an updated device tree
and a num_devices value which is too high by one.

If you now crash or the power drops, the on-disk state is not
consistent. However, this is not a severe problem. btrfs_rm_device()
relocates all chunks that are located on the removed device. On next
mount, at first the device items are read which do not include the
deleted device anymore, afterwards the chunks are checked, whether they
reference a device that is not present. And this is not the case.
Therefore this situation is not a severe problem and my comment was
wrong that says "could require a degraded mount".

But the field num_devices in the superblock will stay wrong for the
lifetime of the filesystem, causing malfunction of the ioctl
BTRFS_IOC_DEVICES_READY, and potentially causing trouble in the future
when somebody adds code that relies on fs_devices->total_devices being
correct.

It's simply not correct like it is now. And your patch doesn't fix the
issue that the TODO comment describes.


>  	if (ret)
>  		goto error_undo;
> @@ -1588,7 +1583,9 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
>  	/*
>  	 * the device list mutex makes sure that we don't change
>  	 * the device list while someone else is writing out all
> -	 * the device supers.
> +	 * the device supers. Whoever is writing all supers, should
> +	 * lock the device list mutex before getting the number of
> +	 * devices in the super block (super_copy).
>  	 */
>  
>  	cur_devices = device->fs_devices;
> @@ -1612,10 +1609,10 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
>  		device->fs_devices->open_devices--;
>  
>  	call_rcu(&device->rcu, free_device);
> -	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
>  
>  	num_devices = btrfs_super_num_devices(root->fs_info->super_copy) - 1;
>  	btrfs_set_super_num_devices(root->fs_info->super_copy, num_devices);
> +	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
>  
>  	if (cur_devices->open_devices == 0) {
>  		struct btrfs_fs_devices *fs_devices;
> 

