Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:58415 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751324Ab2FLHeh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jun 2012 03:34:37 -0400
Message-ID: <4FD6F0B5.3000703@cn.fujitsu.com>
Date: Tue, 12 Jun 2012 15:33:09 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Josef Bacik <josef@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] Btrfs: implement ->show_devname
References: <1338920193-7843-1-git-send-email-josef@redhat.com> <1338920193-7843-2-git-send-email-josef@redhat.com>
In-Reply-To: <1338920193-7843-2-git-send-email-josef@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On tue, 5 Jun 2012 14:16:33 -0400, Josef Bacik wrote:
> Because btrfs can remove the device that was mounted we need to have a
> ->show_devname so that in this case we can print out some other device in
> the file system to /proc/mount.  We keep track of what device we called
> mount() with so that we can print out the correct one if it is still
> available, but otherwise we just pick the first device that has the lowest
> device id.  This was inspired (and copied in the case of btrfs_show_devname)
> from Miao Xie's patch.  Thanks,

In fact, it is hard  to keep track of the device that was mounted although we
add a flag to mark it unless we pass ->mnt_devname into ->show_devname(). For
example:
  # mkfs.btrfs <disk1> <disk2>
  # mount <disk1> <mnt1>
  # mount <disk2> <mnt2>
  # cat /proc/mounts
  <disk2> <mnt1> ...
  <disk2> <mnt2> ...

The mounted device of the first mount operation was changed.

Maybe we are overnice, and we needn't keep track of that device, and just
print out the name of the device which has the lowest device id.

Thanks
Miao

> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  fs/btrfs/super.c   |   43 ++++++++++++++++++++++++++++++++++++++++---
>  fs/btrfs/volumes.c |    9 ++++++---
>  fs/btrfs/volumes.h |    5 ++++-
>  3 files changed, 50 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 85cef50..2f36f28 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -54,6 +54,7 @@
>  #include "version.h"
>  #include "export.h"
>  #include "compression.h"
> +#include "rcu-string.h"
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/btrfs.h>
> @@ -647,7 +648,7 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
>  				goto out;
>  			}
>  			error = btrfs_scan_one_device(device_name,
> -					flags, holder, fs_devices);
> +					flags, holder, fs_devices, 0);
>  			kfree(device_name);
>  			if (error)
>  				goto out;
> @@ -1034,7 +1035,7 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
>  		return root;
>  	}
>  
> -	error = btrfs_scan_one_device(device_name, mode, fs_type, &fs_devices);
> +	error = btrfs_scan_one_device(device_name, mode, fs_type, &fs_devices, 1);
>  	if (error)
>  		return ERR_PTR(error);
>  
> @@ -1448,7 +1449,7 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
>  	switch (cmd) {
>  	case BTRFS_IOC_SCAN_DEV:
>  		ret = btrfs_scan_one_device(vol->name, FMODE_READ,
> -					    &btrfs_fs_type, &fs_devices);
> +					    &btrfs_fs_type, &fs_devices, 0);
>  		break;
>  	}
>  
> @@ -1472,12 +1473,48 @@ static int btrfs_unfreeze(struct super_block *sb)
>  	return 0;
>  }
>  
> +static int btrfs_show_devname(struct seq_file *m, struct dentry *root)
> +{
> +	struct btrfs_fs_info *fs_info = btrfs_sb(root->d_sb);
> +	struct btrfs_fs_devices *cur_devices;
> +	struct btrfs_device *dev, *first_dev = NULL;
> +	struct list_head *head;
> +	struct rcu_string *name;
> +
> +	mutex_lock(&fs_info->fs_devices->device_list_mutex);
> +	cur_devices = fs_info->fs_devices;
> +	while (cur_devices) {
> +		head = &cur_devices->devices;
> +		list_for_each_entry(dev, head, dev_list) {
> +			if (dev->mounted) {
> +				first_dev = dev;
> +				goto out;
> +			}
> +			if (!first_dev || dev->devid < first_dev->devid)
> +				first_dev = dev;
> +		}
> +		cur_devices = cur_devices->seed;
> +	}
> +out:
> +	if (first_dev) {
> +		rcu_read_lock();
> +		name = rcu_dereference(first_dev->name);
> +		seq_escape(m, name->str, " \t\n\\");
> +		rcu_read_unlock();
> +	} else {
> +		WARN_ON(1);
> +	}
> +	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
> +	return 0;
> +}
> +
>  static const struct super_operations btrfs_super_ops = {
>  	.drop_inode	= btrfs_drop_inode,
>  	.evict_inode	= btrfs_evict_inode,
>  	.put_super	= btrfs_put_super,
>  	.sync_fs	= btrfs_sync_fs,
>  	.show_options	= btrfs_show_options,
> +	.show_devname	= btrfs_show_devname,
>  	.write_inode	= btrfs_write_inode,
>  	.alloc_inode	= btrfs_alloc_inode,
>  	.destroy_inode	= btrfs_destroy_inode,
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 1eaa495..5e72fea 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -331,7 +331,8 @@ static void pending_bios_fn(struct btrfs_work *work)
>  
>  static noinline int device_list_add(const char *path,
>  			   struct btrfs_super_block *disk_super,
> -			   u64 devid, struct btrfs_fs_devices **fs_devices_ret)
> +			   u64 devid, struct btrfs_fs_devices **fs_devices_ret,
> +			   int mount)
>  {
>  	struct btrfs_device *device;
>  	struct btrfs_fs_devices *fs_devices;
> @@ -405,6 +406,7 @@ static noinline int device_list_add(const char *path,
>  		}
>  	}
>  
> +	device->mounted = mount;
>  	if (found_transid > fs_devices->latest_trans) {
>  		fs_devices->latest_devid = devid;
>  		fs_devices->latest_trans = found_transid;
> @@ -562,6 +564,7 @@ static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
>  		if (device->can_discard)
>  			fs_devices->num_can_discard--;
>  
> +		device->mounted = 0;
>  		new_device = kmalloc(sizeof(*new_device), GFP_NOFS);
>  		BUG_ON(!new_device); /* -ENOMEM */
>  		memcpy(new_device, device, sizeof(*new_device));
> @@ -730,7 +733,7 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
>  }
>  
>  int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
> -			  struct btrfs_fs_devices **fs_devices_ret)
> +			  struct btrfs_fs_devices **fs_devices_ret, int mount)
>  {
>  	struct btrfs_super_block *disk_super;
>  	struct block_device *bdev;
> @@ -765,7 +768,7 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
>  		printk(KERN_INFO "device fsid %pU ", disk_super->fsid);
>  	printk(KERN_CONT "devid %llu transid %llu %s\n",
>  	       (unsigned long long)devid, (unsigned long long)transid, path);
> -	ret = device_list_add(path, disk_super, devid, fs_devices_ret);
> +	ret = device_list_add(path, disk_super, devid, fs_devices_ret, mount);
>  
>  	brelse(bh);
>  error_close:
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 74366f2..c766902 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -107,6 +107,9 @@ struct btrfs_device {
>  	struct completion flush_wait;
>  	int nobarriers;
>  
> +	/* Set if mount() was called with this device */
> +	int mounted;
> +
>  	/* disk I/O failure stats. For detailed description refer to
>  	 * enum btrfs_dev_stat_values in ioctl.h */
>  	int dev_stats_valid;
> @@ -264,7 +267,7 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
>  int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
>  		       fmode_t flags, void *holder);
>  int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
> -			  struct btrfs_fs_devices **fs_devices_ret);
> +			  struct btrfs_fs_devices **fs_devices_ret, int mount);
>  int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
>  void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices);
>  int btrfs_add_device(struct btrfs_trans_handle *trans,

